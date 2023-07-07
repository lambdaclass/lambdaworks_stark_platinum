use array::ArrayDefault;
use array::{Span, ArrayTrait, SpanTrait, ArrayDrop};
use debug::PrintTrait;
use traits::{Into, TryInto};
use option::OptionTrait;
use box::BoxTrait;


const TWO_ADICITY: u128 = 48;
const TWO_ADIC_PRIMITVE_ROOT_OF_UNITY: felt252 =
    0x30a2e815081f7d927f73df497923b55d38dbf3801c203cee2bf6c4b68bc148c;

fn pow128(base: u128, mut exp: u128) -> u128 {
    if exp == 0 {
        1
    } else {
        base * pow128(base, exp - 1)
    }
}

fn powfelt(base: felt252, mut exp: felt252) -> felt252 {
    if exp == 0 {
        1
    } else {
        base * powfelt(base, exp - 1)
    }
}
// Poly must be in the form [a_n, a_n-1, ..., a_0]. 
fn evaluate(poly: @Array<felt252>, x: felt252, counter: u32) -> felt252 {
    if counter == 0 {
        return *poly.at(0);
    } else {
        return *poly.at(counter) + x * evaluate(poly, x, counter - 1);
    }
}

// Returns the polynomial mx + b in the form [b, m] that interpolates the points (x0, y0), (x1, y1)
// So P(x0) = y0, P(x1) = y1
fn interpolate_two_points(x0: felt252, y0: felt252, x1: felt252, y1: felt252) -> Array<felt252> {
    let mut poly = ArrayDefault::<felt252>::default();
    let m = felt252_div(y1 - y0, (x1 - x0).try_into().unwrap());
    let b = y0 - m * x0;
    poly.append(m);
    poly.append(b);
    'mx + b'.print();
    m.print();
    b.print();
    return poly;
}
fn mul_by_binomial(poly_a: @Array<felt252>, poly_b: @Array<felt252>) -> Array<felt252> {
    let mut counter = 0;
    let mut res = ArrayDefault::<felt252>::default();
    let mut previous_product = (*poly_a.at(counter)) * (*poly_b.at(1));

    res.append((*poly_a.at(counter)) * (*poly_b.at(0)));
    counter += 1;

    loop {
        if counter == poly_a.len() {
            break;
        }
        let current_product = (*poly_a.at(counter)) * (*poly_b.at(1));
        res.append(previous_product + (*poly_a.at(counter)) * (*poly_b.at(0)));
        previous_product = current_product;
        counter += 1;
    };

    res.append(previous_product);
    return res;
}


fn mul_binomial_by_binomial(poly_a: @Array<felt252>, poly_b: @Array<felt252>) -> Array<felt252> {
    let mut res = ArrayDefault::<felt252>::default();
    res.append(*poly_a.at(0) * *poly_b.at(0));
    res.append(*poly_a.at(0) * *poly_b.at(1) + *poly_a.at(1) * *poly_b.at(0));
    res.append(*poly_a.at(1) * (*poly_b.at(1)));
    return res;
}

// returns 2**i up to 2**63
fn get_pow2_array() -> @Array<u64> {
    let mut values = ArrayDefault::<u64>::default();
    values.append(1);
    values.append(2);
    values.append(4);
    values.append(8);
    values.append(16);
    values.append(32);
    values.append(64);
    values.append(128);
    values.append(256);
    values.append(512);
    values.append(1024);
    values.append(2048);
    values.append(4096);
    values.append(8192);
    values.append(16384);
    values.append(32768);
    values.append(65536);
    values.append(131072);
    values.append(262144);
    values.append(524288);
    values.append(1048576);
    values.append(2097152);
    values.append(4194304);
    values.append(8388608);
    values.append(16777216);
    values.append(33554432);
    values.append(67108864);
    values.append(134217728);
    values.append(268435456);
    values.append(536870912);
    values.append(1073741824);
    values.append(2147483648);
    values.append(4294967296);
    values.append(8589934592);
    values.append(17179869184);
    values.append(34359738368);
    values.append(68719476736);
    values.append(137438953472);
    values.append(274877906944);
    values.append(549755813888);
    values.append(1099511627776);
    values.append(2199023255552);
    values.append(4398046511104);
    values.append(8796093022208);
    values.append(17592186044416);
    values.append(35184372088832);
    values.append(70368744177664);
    values.append(140737488355328);
    values.append(281474976710656);
    values.append(562949953421312);
    values.append(1125899906842624);
    values.append(2251799813685248);
    values.append(4503599627370496);
    values.append(9007199254740992);
    values.append(18014398509481984);
    values.append(36028797018963968);
    values.append(72057594037927936);
    values.append(144115188075855872);
    values.append(288230376151711744);
    values.append(576460752303423488);
    values.append(1152921504606846976);
    values.append(2305843009213693952);
    values.append(4611686018427387904);
    values.append(9223372036854775808);
    return @values;
}

// returns 2**i up to 2**63 in felt252
fn get_pow2_arrayf() -> @Array<felt252> {
    let mut values = ArrayDefault::<felt252>::default();
    values.append(1);
    values.append(2);
    values.append(4);
    values.append(8);
    values.append(16);
    values.append(32);
    values.append(64);
    values.append(128);
    values.append(256);
    values.append(512);
    values.append(1024);
    values.append(2048);
    values.append(4096);
    values.append(8192);
    values.append(16384);
    values.append(32768);
    values.append(65536);
    values.append(131072);
    values.append(262144);
    values.append(524288);
    values.append(1048576);
    values.append(2097152);
    values.append(4194304);
    values.append(8388608);
    values.append(16777216);
    values.append(33554432);
    values.append(67108864);
    values.append(134217728);
    values.append(268435456);
    values.append(536870912);
    values.append(1073741824);
    values.append(2147483648);
    values.append(4294967296);
    values.append(8589934592);
    values.append(17179869184);
    values.append(34359738368);
    values.append(68719476736);
    values.append(137438953472);
    values.append(274877906944);
    values.append(549755813888);
    values.append(1099511627776);
    values.append(2199023255552);
    values.append(4398046511104);
    values.append(8796093022208);
    values.append(17592186044416);
    values.append(35184372088832);
    values.append(70368744177664);
    values.append(140737488355328);
    values.append(281474976710656);
    values.append(562949953421312);
    values.append(1125899906842624);
    values.append(2251799813685248);
    values.append(4503599627370496);
    values.append(9007199254740992);
    values.append(18014398509481984);
    values.append(36028797018963968);
    values.append(72057594037927936);
    values.append(144115188075855872);
    values.append(288230376151711744);
    values.append(576460752303423488);
    values.append(1152921504606846976);
    values.append(2305843009213693952);
    values.append(4611686018427387904);
    values.append(9223372036854775808);
    return @values;
}

// works with little endian bit representation
// useful to verify bit representation of a number is correct
// returns 1 if sum(bit_repr[i] * 2^i) == number
// returns 0 otherwise
// Does not use actual values of bit_repr[i] but only checks if they are 0 or not
// to prevent additional checks for bit_repr[i] > 1. 
fn verify_bit_representation(number: u64, bit_representation: @Array<u64>) {
    let mut acc: u64 = 0;
    let pow2_array = get_pow2_array();
    assert(bit_representation.len() <= 64, 'bit repr too long');
    let mut counter = bit_representation.len() - 1;
    loop {
        if counter == 0 {
            if *bit_representation.at(counter) != 0 {
                acc = acc + *(pow2_array.at(counter));
            }
            break;
        }
        if *bit_representation.at(counter) != 0 {
            acc = acc + *(pow2_array.at(counter));
        }
        counter -= 1;
    };
    assert(acc == number, 'wrong bin repr');
    return ();
}
// returns base ^ exp, where exp = sum(exp[i] * 2^i)
// use square and multiply algorithm
fn powfelt_square_mul(base: felt252, exp: @Array<u64>) -> felt252 {
    let mut acc: felt252 = 1;
    let mut counter = 0;
    let mut base_sqr = base;
    loop {
        if counter == exp.len() {
            break;
        }
        if *exp.at(counter) != 0 {
            acc = acc * base_sqr;
        }
        base_sqr = base_sqr * base_sqr;
        counter += 1;
    };
    return acc;
}

fn verify_trailing_zeros(number: u128, trailing_zeros: u128) -> felt252 {
    number.print();
    let pow = pow128(2, trailing_zeros);
    let right = 2 * pow - 1;
    let expected = pow;
    let actual = number & right;
    actual.print();
    if expected == actual {
        return 1;
    } else {
        return 0;
    }
}

fn count_trailing_zeros(n: u64, count: felt252) -> felt252 {
    if n == 0 {
        return count;
    } else {
        let r = n % 2;
        if r == 0 {
            return count_trailing_zeros(n / 2, count + 1);
        } else {
            return count;
        }
    }
}

fn u64_byte_reverse(word: u64) -> u64 {
    let word: u128 = word.into();
    let word = (word & 0x00ff00ff00ff00ff00ff00ff00ff00ff) * (65535) + word;
    let word = (word & 0x00ffff0000ffff0000ffff0000ffff00) * (4294967295) + word;
    let word = (word & 0x0fffffffffffffff0000000000000000) * (18446744073709551615) + word;

    return (word / (72057594037927936)).try_into().unwrap();
}

fn get_primitive_root_of_unity(order: u128) -> felt252 {
    let k: u32 = (TWO_ADICITY - order).try_into().unwrap();
    let root: felt252 = lookup(k);
    return root;
}

fn get_powers_of_primitive_root_coset(n: u128, count: felt252, offset: felt252) -> Array<felt252> {
    let root = get_primitive_root_of_unity(n);
    let mut results = ArrayDefault::<felt252>::default();
    let mut counter = 0;
    loop {
        if counter == count {
            break;
        }
        let power: felt252 = powfelt(root, counter);
        let result = power * offset;
        results.append(result);
        counter += 1;
    };
    return results;
}

// TWO_ADIC_PRIMITVE_ROOT_OF_UNITY^(2^k) mod PRIME for k=0...48. 
fn lookup(k: u32) -> felt252 {
    let mut values = ArrayDefault::<felt252>::default();
    values.append(1374927983041104569048711644287044720861432102729607324204792234194188899468);
    values.append(258103283284781341314469267289850711163274146460948323705525695890615138079);
    values.append(3596371882406329793708031568772227224523684274103878388370272184624981539717);
    values.append(2695871979792953617670148970020986204632052477932492867810013195217420461349);
    values.append(1863733278740973194163756545799723946771511809583317358157512329734386686923);
    values.append(1252390754480737609759263423229120633834933730806128638489941661241229245874);
    values.append(1633986134005522519322187923991050763446810897812851642310219297408414537251);
    values.append(1113178875901063824114491316322134568819036656652349859636841782522226248574);
    values.append(2906900852430684062390926451259176974067077572549905960490047220876289299432);
    values.append(1228377489451803944018088163855314357279724181397983909230230209751946417297);
    values.append(3369014874615264335762679988973596847293764463839558888117740086607762124880);
    values.append(454079519889002904682209345449797907472578748695945936400062271067395487940);
    values.append(2950383176193724615112287384582509849137136957308062730961080641938595911420);
    values.append(1006329975307025002475249161764122658755480765313891654513575010964327679171);
    values.append(3496343910150381292206254102533302429424041792343847657836742260001703242030);
    values.append(633917693793491093438410342303993577239887880640455835956139233879323505096);
    values.append(2274283650448687101415851970593711626031105468891204880928373412733104589202);
    values.append(2732875990783618332335579120230593087094077780499501830257604862680528012567);
    values.append(982134047660929852025779334629405023337767392320059971064889431375340329140);
    values.append(2671243574039810951864803898612677122151470397775922046811652824862597083452);
    values.append(2477957756265675706094135298666630427179608442630851423724318940933526921977);
    values.append(876922266912309748724099425703447978111447376928886119793644184598497690063);
    values.append(1740032260176861730069282301706899931803609121779848595553493302998775290819);
    values.append(3125382754445177052723936368432116465243259141967510926474057405479550226428);
    values.append(3212622950840765133933709657845517377320982515761066354075737946972812045746);
    values.append(461625156185106109674757843869089899645188733783009008020560400212434869224);
    values.append(1760167608450351411175491059251246920596160626412255333011233334102270291787);
    values.append(884767640635888335079619399138397816824468332068211437205303391566300183736);
    values.append(2524373679629943969694315332668304401069069270208147504317031858433177217055);
    values.append(1276259529452344066087051760234356737143210822436609816392252937419502561755);
    values.append(2018678091584329218435280089678148721952597162209143564155364750690020073542);
    values.append(3008896061661996704389990101929484883829232035463363036227102979064119803820);
    values.append(868277774033475215476395060850907016745523396068173821916757070607579717033);
    values.append(1490096455520052234184227906934233732167884042058884987838510110322811434080);
    values.append(1617791213734658136968748589722407098633951096380418940975101280625155408609);
    values.append(1533340560886622357184336952203971929989931006618142264948672762036027043885);
    values.append(107921729611698366527568132789226143223411882538548396875627203627394603135);
    values.append(479350917366973328867231618769870247883647010050794749859407019189500839696);
    values.append(2872618801630522944228933398573680209863705690227914327550521950087758333169);
    values.append(503605588685115615492164649363646553713524688081596594798612835801738386699);
    values.append(355459239873039554746754348566197485723154649641346812441506253094066631495);
    values.append(27902509089891984638895139203459090191082442476177253201387137074461340175);
    values.append(524650022574296031033701339672259635908291236977496998655060095531066865509);
    values.append(3409443867035641044245057348756544640549407421541289951053907001322227935403);
    values.append(2679026602897868112349604024891625875968950767352485125058791696935099163961);
    values.append(2804690217475462062143361339624939640984649667966511418446363596075299761851);
    values.append(2779265777490745486907812647164038750808419677710890077123925563301162072035);
    values.append(3618502788666131213697322783095070105623107215331596699973092056135872020480);
    values.append(1);
    return *(values.at(k));
}


fn is_val_in_array(val: felt252, array: @Array<felt252>, len: u32) -> felt252 {
    let check_value = *(array.at(len));
    if val == check_value {
        return 1;
    } else {
        if len == 0 {
            return 0;
        } else {
            return is_val_in_array(val, array, len - 1);
        }
    }
}

