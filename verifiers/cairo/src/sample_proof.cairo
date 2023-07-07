use array::ArrayTrait;
use debug::PrintTrait;
use array::ArrayDefault;
use integer::{u256, u128};
use cairo_verifier::structs::{
    STARKProof, Frame, FriDecommitment, DeepPolynomialOpening, CairoAIR, AirContext, ProofOptions,
    PublicInputs, Range, MemorySegments, MemoryCell
};


fn get_sample_proof() -> STARKProof {
    let mut lde_trace_merkle_roots = ArrayDefault::<Array<u64>>::default();
    let mut lde_trace_merkle_roots_0 = ArrayDefault::<u64>::default();
    lde_trace_merkle_roots_0.append(7103867044575730553);
    lde_trace_merkle_roots_0.append(395728038029941194);
    lde_trace_merkle_roots_0.append(13542134008811771202);
    lde_trace_merkle_roots_0.append(13184668983641167427);
    lde_trace_merkle_roots_0.append(1);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(0);
    lde_trace_merkle_roots_0.append(9223372036854775808);
    lde_trace_merkle_roots.append(lde_trace_merkle_roots_0);
    let mut lde_trace_merkle_roots_1 = ArrayDefault::<u64>::default();
    lde_trace_merkle_roots_1.append(9166845830801919599);
    lde_trace_merkle_roots_1.append(12448142920641535998);
    lde_trace_merkle_roots_1.append(7501362383951718873);
    lde_trace_merkle_roots_1.append(6463002326844705151);
    lde_trace_merkle_roots_1.append(1);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(0);
    lde_trace_merkle_roots_1.append(9223372036854775808);
    lde_trace_merkle_roots.append(lde_trace_merkle_roots_1);
    let mut data = ArrayDefault::<felt252>::default();
    data.append(0x7f1281907e3aa398c119a58e8eb16b791d860c4759afc41c9e030527e7dc5dd);
    data.append(0x75c8e9f23fc5b599645d1c58d0a2a0b40571773e5eefe8bcb33a81b28bef68b);
    data.append(0x1084999d297c1a6404a90ef8b2be47dc680fd42cde1926b81c25a8037c6764d);
    data.append(0x2b72ebf34242007b967f90de1ba905a6b26315c27d1fb54f07f3e94a066cf29);
    data.append(0x7a745ff3cfae0e06701ae40e84385f9ebce8472ca0ce6f15644dc7db14ea374);
    data.append(0x24a47116609add8f071f08664b17773b37ec03b69d5f663e05d234806969556);
    data.append(0x531e49efb4bfa82614778b8d33421a09e1f67fd37156bb7e898c1dcde1e22b3);
    data.append(0x5c1d8faa440f87a454e9300a5491b5e3dcdc883be4a25939a2df2d614122e30);
    data.append(0x5e74d570a9ccffa31830a49999794e762e0ddba43acfca0870091ebdeac62de);
    data.append(0x0);
    data.append(0x0);
    data.append(0x4d6125fa4da39dfcc3589e5df50052ef4259572ca5d3e87ea941b7eeb30c67d);
    data.append(0x5e74d570a9ccffa31830a49999794e762e0ddba43acfca0870091ebdeac62de);
    data.append(0x5c1d8faa440f87a454e9300a5491b5e3dcdc883be4a25939a2df2d614122e30);
    data.append(0x2a2220774fd209d606abdacc5e871d8f6d078cf89eaa6712d4b2135c4feb860);
    data.append(0x0);
    data.append(0x2cddb329529b4e0a797d78c1e3bfc99f39a4222571a1b1f57d328acde34cf5c);
    data.append(0x7a2ac80cf60e046bfaacd9f5096174f88976597b0e8f2065e0b2c900fff9ad8);
    data.append(0x19f30ccbdefbabf7130c10aaa10fc27b2c114b5e6998b50ba347ce80e2a7247);
    data.append(0x787d54bbce9a727f82c2926b246c68338ecded31af0b19489626f3a802e1813);
    data.append(0x4c6bf56a8cfcdb233df2784eca6a4bd43e16bb79bbcb429708067139367bfb1);
    data.append(0xcde19049b31d2afaf6e7ece9991a530828c03b0b6d679624e9da9517afc788);
    data.append(0x37bfccfbf4e1b869d316ce5127752d51dfb00734d38cdc894ab183577cf1aed);
    data.append(0x784c302265367097f58b0d972ff20140d48b8384c1b6c3eb0938fa113d703f8);
    data.append(0x1cba607118b7af63593e11473aae9e2a913a8dd08df3e39d74a16024ec94612);
    data.append(0x11c2174a6eeef2dba3a4021aea24e4bb7279f8bd16f24f99fb961a83e6ebf54);
    data.append(0x74a28f61a9d65be1fa1bbfd3be585b175ed1fb72dce2f9172a942780a2fc078);
    data.append(0x7f06cb65c916dd67c8ef0b603595d399ba1c005f014fcd858b88b9ee889c774);
    data.append(0x4556b274934cbf176a4d4c64070b731d5a5467a7d0f256e03abe11ea7b3d32c);
    data.append(0x285e6265615c3978ee3229604304bbabafbc606b7ca90afda1ad48c1c202ab7);
    data.append(0x0);
    data.append(0x0);
    data.append(0x563dd8b9d2d81512275a8f8e6e8921e5b1237027ae4b680e2a418e4ead590af);
    data.append(0x3d6a63bec575a947ce3f60df74c695babf80381c1893fdc9cb21bcdcb6731bf);
    data.append(0x4580b9580a04dffb2563c0504915f0bcde191a047c6549dabb840c4deef322c);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x4580b9580a04dffb2563c0504915f0bcde191a047c6549dabb840c4deef322c);
    data.append(0x5f718112dc435761bd5e2d82b97173ef48f21fdebe55e7c5d6609b6a442719e);
    data.append(0x7c048af692efeb8605d81140dbbd1ec13bd34239f0d1500c06519c1d74c095c);
    data.append(0x63e32fffc56a53bdfd65fc524aec42fca17efb7a6733d4fb415851f81065a37);
    data.append(0x2d90186880a89a31c3c3330df6fcf8c6e7fc7ed5904c738c4a2abe1e24224e8);
    data.append(0x2a76b078ee0a18715ae7de5bf25dda64aa6edabdbe402ed892e68de93277e89);
    data.append(0x4a2611d31e048a7211cac483f7517b9e0c35b85cf5d0c08a03e2d2edc3f3f96);
    data.append(0x3be25f6d8a8d324b659548bd17ba55c2574c73af71c7b055800de18cd7b3d8b);
    data.append(0x7fb6b3224db1a4153e8417509d87f1a8268ffddbcf37a8642a05a3b25b58260);
    data.append(0x6056b0ff89504550546d09a68d25dbe354f5e68431c66fa9bf8d7f4d2ea0391);
    data.append(0x7c71cfc317848a2fb7b47f08e1eecacc9c4d7daad853ff1eb0d12458a7575b);
    data.append(0x14c21444a7023cb73407ad44a195954ac83259c68b45c0bd27804719752dd84);
    data.append(0x3f6758189213a40b9557948fc5a1412d75efd0e2c143df05e3a7e5fc6c4dcb7);
    data.append(0x643117ac6cefa7cfa27c90ab0bcfe9e9b57187aa898d6955e2b20e93af5cf3b);
    data.append(0x12301784bb0255e932d108577c1569346f22c20f80987a92673f4e630d62358);
    data.append(0x37494707ef861b12806ab467c9cc82583dd52b1267c749c3a934a95bf724da4);
    data.append(0x58692935ab32a53ae2016d1fece9a774cda61439aaa6070d8c06050dfe789da);
    data.append(0x22567d099448dbb133b298540f6d3e8d01bedbee8a9586da345eaaccd1a8592);
    data.append(0x514ae5b7a7a26c3aaeba94298a8fc353fbbe32cc2fef3a2321d9e852f32078f);
    data.append(0x3eb37975e61906d71c427d2892dc5fa990f58385faa73ff8bba498bf5a6192);
    data.append(0x7fd995ce34428f24ae24c6ecbb59870e188189b9b370bb885701d5b20048332);
    data.append(0x27c7a89617802463937ca0ae72797bf878d5404057522a76e8b4d86ac0746f9);
    data.append(0x4aa7497666e60696797db19316921e37a5bdbfe698b2cb26a6890595ba66cbd);
    data.append(0x6dad877c0c1cbd91d6af65018ff5244204c5471681d0434db215d3ee503c6f8);
    data.append(0x2ade97941d6416f1a8622f13bab59c9405a2fb20855712c829a52f73418dd47);
    data.append(0x421fd31d7dfcf458ed2f79a35ab0ddad415dcd8f18a55896876616d2ec784f7);
    data.append(0x601d83e144618692aacf206e25315ff678e7ff72a47a534683e89b9c7aec883);
    data.append(0x34800753534d852abe5c869af62447e22d38f48bf0fb0cc77c47179e3a2d39);
    data.append(0x0);
    data.append(0x0);
    data.append(0x5f22c5c557dfbda22c54a473ea95d8a30a45ac992d8c9c1a9f0d683a1a98620);
    data.append(0x34800753534d852abe5c869af62447e22d38f48bf0fb0cc77c47179e3a2d39);
    data.append(0x601d83e144618692aacf206e25315ff678e7ff72a47a534683e89b9c7aec883);
    data.append(0x60194e526aae9c98b19e326b7e19e4cd7d39bc6cb38d92d8f7a6c84e715c13b);
    data.append(0x0);
    data.append(0x1a20e8f6368c3a3d61a75bea3b62b4f6c8711112a8d85fbea3730507016bb53);
    data.append(0x27d400690919625fa77dcd29cc3700b3f7293ae08fa152ba0e7f3c2b3ebfd05);
    data.append(0x4071b0329fc7681584a7ed86b7b4abae41ad27ba429dbaa93318913b3e635cb);
    data.append(0x42678ff39f714152c3ea6ce4f870e4da08dd3562db6aa4e75e597718aa30417);
    data.append(0x7151c0e2e1df08cb8e1600f2cc606fc62979e5c7effed7f38423711d239b6ba);
    data.append(0x38754895a7d564445ddb389b6c8bed74fff78df45db48a5f491d820ad0a7406);
    data.append(0x3a00b260f3532708eac90e1a53f1c2faf4b9500785baec8150cf485a200a572);
    data.append(0x2eff8fda852619c0baa2941dd2e7faa72f9a95164726216ad83ff309f301cfe);
    data.append(0x4f723b60e3db20f13c51b0549fd905eb621cd47cb178fce7351e7bf461a3f8c);
    data.append(0x32e322a367bbbdf75146caa61a17458fec214a800ae216f6cfad72dfd35438e);
    data.append(0x2c9493b9c1a946ee089e5468a9009f2d7e440a416e50b709e78ff6ca5ae301e);
    data.append(0x68c3f86973d38cb2d830dc2e1011919c03672eb7ad2812825f9af69d5555ab0);
    data.append(0x7765ca28873c5794206a6a304bbaa9e89e2dfe6bef16d8b7e583e827f676785);
    data.append(0x2fdba8d752d21bce6989b301badb2cd3cf64ba89f0812b0a3edb256e361f544);
    data.append(0x0);
    data.append(0x0);
    data.append(0x1fe0535ce4f3a1686c4848b8cab7bddc9041d3a41430eeba81f43975f184579);
    data.append(0x520c1957070dce5c5aa92332bb784a59443a1af0c6bcec85ab4c15cd178bd3);
    data.append(0x3cd88bd650b39116d5f8fadbc7e528407243490194eb2d915cb6ba83dc80f0a);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x0);
    data.append(0x3cd88bd650b39116d5f8fadbc7e528407243490194eb2d915cb6ba83dc80f0a);
    data.append(0x3f05ef35745f05d3bdd07b115b22f8b26bb7ddbf87373c7ec655afda77ade5b);
    data.append(0x2f51e938897eae333a560fd013e59971bfa91d470325f376b04128da55466ac);
    data.append(0x7ee91dcdadee93c22758e227a65bdfd81ba14d7c8f4e669294f40dd2fa832bd);
    data.append(0x1de9956a7dd29368014d7ebc7ccec02a87ed8dac861f885090f051987c91a22);
    data.append(0x5fb9553b943b81c260bb587b003a5dc0e719ad1e6d2d6b5f8652e90d876407d);
    data.append(0x14d4b66f4233a7a807104b3551b65b7bfe37205fe462efd36a8551b0c5dc128);
    data.append(0x7495373abb5588ba54bfd9925633339d1689ea967c921562dcf61723a4131de);
    data.append(0x3609cd9bca85e80f1e0095e42d090bd9d621e39a884e083951078653190d8e8);
    data.append(0x2fe2ff57c87a020dd574702bebcad0fb0e3e3aa6b4adc479029485e221da800);
    data.append(0x1dd1aee8ff0cc3d3d137507d6551798397a3f4c686ba9a55bdc07b9fb7a2bdc);
    data.append(0x296f39fcee5df6d7af199279c514eea4fc393ab2f2b6b10c2e67a8ae1976122);
    data.append(0x59c821b786616649856ed892c7c3b0dbfddb251a233064e02dc92bc77d7010d);
    data.append(0xc071f34ee11fdea9206b065383c78d2c8fd3bb896657ee2916e488aeaf2f6b);
    data.append(0x5251e7d67713cbd38ab842d8214997a62866859d9781845383ebba3d8c588ba);
    data.append(0x5e78e9874ffc077b52710d3cb35e61630369a43e66a36575e02102861f5866f);
    data.append(0x2ff75f81bd9f1faeb37313c22db76dcd21d9409cf7c6aad7e5aee79e4ebe3e5);
    data.append(0x4d4f87157cacc8ff08f1749782e932b924c566bc3a80ab8266964af30fb761);
    data.append(0x6e148cfd834789d4016443023b4da45a10aeda4d844d2284cbffcd60dd80ed9);
    let row_width = 61;
    let trace_ood_frame_evaluations = Frame { data: data, row_width: row_width };

    let composition_poly_root = u256 {
        low: 188439682086921620678280960776382410712, high: 161704816304945881716425537654715591314
    };
    let composition_poly_even_ood_evaluation =
        0x71b5b92bc8b3057cf24d8670e83bd33bb1f3115b65d5a03fa1944f23a904113;
    let composition_poly_odd_ood_evaluation =
        0x5fb1d5d40db01c1e59f140a72d8a61b6dc2a8d4191a7fd8ebc7299d3e6307bc;
    let mut fri_layers_merkle_roots = ArrayDefault::<u256>::default();
    fri_layers_merkle_roots
        .append(
            u256 {
                low: 305913287490057300420898601817584367068,
                high: 207594977462166450984306413377039093144
            }
        );
    fri_layers_merkle_roots
        .append(
            u256 {
                low: 55335315083994328528588501462792745583,
                high: 181581000248017190344674103957956727540
            }
        );
    fri_layers_merkle_roots
        .append(
            u256 {
                low: 14695188857887319629710572455513965387,
                high: 85641819647568908364130469107424781700
            }
        );
    fri_layers_merkle_roots
        .append(
            u256 {
                low: 183913079015005549249559353178396911116,
                high: 153675410364725606464286789938712277297
            }
        );
    fri_layers_merkle_roots
        .append(
            u256 {
                low: 184849288873132664577609901913056663734,
                high: 234172288364534461055988250699066721909
            }
        );
    fri_layers_merkle_roots
        .append(
            u256 {
                low: 56851530546194457257482938038411020487,
                high: 265269496079305146203587747214291650974
            }
        );
    fri_layers_merkle_roots
        .append(
            u256 {
                low: 89856603511147145033192791975515926927,
                high: 50713113863381239949201777501066186201
            }
        );
    fri_layers_merkle_roots
        .append(
            u256 {
                low: 160163460398689796614918915796300262971,
                high: 174655228457069388545645693994635587371
            }
        );
    let fri_last_value = 0x60a0d13d9df32caec4a356f09e81ee106fe18d927219a583a07847f45983015;

    let mut query_list = ArrayDefault::<FriDecommitment>::default();
    let mut layers_auth_paths_sym_0 = ArrayDefault::<Array<u256>>::default();
    let mut layers_auth_paths_sym_0_0 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 264250274594422657776189030215592812629,
                high: 35525513479159988338805264412700792473
            }
        );
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 273289592238661269661998739582572188675,
                high: 251324322648788441191308565623158964109
            }
        );
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 85093055956219373119244668606753878151,
                high: 76269292740997947848216175470333341809
            }
        );
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 99182496062957756903877282746918475898,
                high: 116648327029056610538643722638165802321
            }
        );
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 106277017748678430703467385908295970003,
                high: 212493076766433105218838931221047694967
            }
        );
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 237661162293474568940370936961028310685,
                high: 107604881858758219700672604305576926002
            }
        );
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 290644873374169483050293079504999411537,
                high: 306891544571067764785072642822876087991
            }
        );
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 281177692179377668111561237578423127815,
                high: 196969228515679364155797001914780771490
            }
        );
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 119771752972243738447005099739249384830,
                high: 210902998146560272646491699003891643200
            }
        );
    layers_auth_paths_sym_0_0
        .append(
            u256 {
                low: 287413520183178317777135645887624208226,
                high: 331496425490372260601024991771599738477
            }
        );
    let mut layers_auth_paths_sym_0_1 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_0_1
        .append(
            u256 {
                low: 121999049698285455681213706377578034569,
                high: 252303659061181368518584541607727113962
            }
        );
    layers_auth_paths_sym_0_1
        .append(
            u256 {
                low: 114729088603351544954869914342067816347,
                high: 260179891056723572055379731330041103561
            }
        );
    layers_auth_paths_sym_0_1
        .append(
            u256 {
                low: 262976145343059495293858558931251482719,
                high: 194740970070635788943485817538720647135
            }
        );
    layers_auth_paths_sym_0_1
        .append(
            u256 {
                low: 15282708647963196880135327551898561168,
                high: 149199974154111253614896556485886294228
            }
        );
    layers_auth_paths_sym_0_1
        .append(
            u256 {
                low: 250147556457059419885032222825860265314,
                high: 37461635803378255848761602354493412860
            }
        );
    layers_auth_paths_sym_0_1
        .append(
            u256 {
                low: 232068853321064042540364852936548062881,
                high: 287996189539756551120500672596659304020
            }
        );
    layers_auth_paths_sym_0_1
        .append(
            u256 {
                low: 20109109576525157578359225686006372609,
                high: 273908604101591122155293731069944417278
            }
        );
    layers_auth_paths_sym_0_1
        .append(
            u256 {
                low: 13459777295538119246461746181036692641,
                high: 81832489705007973988813297392510105224
            }
        );
    layers_auth_paths_sym_0_1
        .append(
            u256 {
                low: 24446239940912575710402166432704535459,
                high: 33769997792391823602231864473096053116
            }
        );
    let mut layers_auth_paths_sym_0_2 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_0_2
        .append(
            u256 {
                low: 219766630962416833842742238633181925138,
                high: 270122132587889679890899469945578972626
            }
        );
    layers_auth_paths_sym_0_2
        .append(
            u256 {
                low: 182238415463394385117549786100559358407,
                high: 173184358577683118806889122621246124296
            }
        );
    layers_auth_paths_sym_0_2
        .append(
            u256 {
                low: 56041251441593058389714026320492951771,
                high: 8423684209741837965363148488232778407
            }
        );
    layers_auth_paths_sym_0_2
        .append(
            u256 {
                low: 135323981789150257768132120896078522526,
                high: 1176506031453371314991177073193312770
            }
        );
    layers_auth_paths_sym_0_2
        .append(
            u256 {
                low: 286454506560761420944177050739728497232,
                high: 70227946224446136005931917494987987324
            }
        );
    layers_auth_paths_sym_0_2
        .append(
            u256 {
                low: 160159028130458558518729366579970053347,
                high: 1909503949136432248727458703023946481
            }
        );
    layers_auth_paths_sym_0_2
        .append(
            u256 {
                low: 319479993357195205793322590052499089009,
                high: 248849289587076686404206313044364931834
            }
        );
    layers_auth_paths_sym_0_2
        .append(
            u256 {
                low: 25668642760051300240340639726985410401,
                high: 55451695112306766710790848305171195208
            }
        );
    let mut layers_auth_paths_sym_0_3 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_0_3
        .append(
            u256 {
                low: 22840309361824880741980950175611772823,
                high: 16734429134860910856929963967432022443
            }
        );
    layers_auth_paths_sym_0_3
        .append(
            u256 {
                low: 308898680601706282781912084456487579674,
                high: 192599395900172774859365169354953825733
            }
        );
    layers_auth_paths_sym_0_3
        .append(
            u256 {
                low: 146518726316903955421921046441487532780,
                high: 198602984894823257899837707505607163073
            }
        );
    layers_auth_paths_sym_0_3
        .append(
            u256 {
                low: 139476235420337940832507108613116065441,
                high: 51092894586585313583259903853374462211
            }
        );
    layers_auth_paths_sym_0_3
        .append(
            u256 {
                low: 260927223976362047336129419120728513332,
                high: 66968298117881759720960102032874800222
            }
        );
    layers_auth_paths_sym_0_3
        .append(
            u256 {
                low: 116889397007894908277364218584678928888,
                high: 292885342018104122321860469006658194859
            }
        );
    layers_auth_paths_sym_0_3
        .append(
            u256 {
                low: 132004417065944158262759950088273194550,
                high: 117542597907677031594803928870487949326
            }
        );
    let mut layers_auth_paths_sym_0_4 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_0_4
        .append(
            u256 {
                low: 72920977173129774002893007061073073184,
                high: 311601601276022000255821714704011619640
            }
        );
    layers_auth_paths_sym_0_4
        .append(
            u256 {
                low: 207002025686384840783350827319347951561,
                high: 157170442754847452536466419890604541593
            }
        );
    layers_auth_paths_sym_0_4
        .append(
            u256 {
                low: 159758742659884460665094758391194896659,
                high: 144481378913463205284910910346541699451
            }
        );
    layers_auth_paths_sym_0_4
        .append(
            u256 {
                low: 167770787601162689052941737075026733035,
                high: 161439320314860929208038380325577741148
            }
        );
    layers_auth_paths_sym_0_4
        .append(
            u256 {
                low: 11738409729192584274153829087312013896,
                high: 209878191762331363443216895000456079272
            }
        );
    layers_auth_paths_sym_0_4
        .append(
            u256 {
                low: 83807366973467871380607186738821016710,
                high: 278444839435223765219780459675870208580
            }
        );
    let mut layers_auth_paths_sym_0_5 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_0_5
        .append(
            u256 {
                low: 183504202778769862783873303022676086802,
                high: 305089168954397962904606615464411135654
            }
        );
    layers_auth_paths_sym_0_5
        .append(
            u256 {
                low: 11688961050010950945634928678676280936,
                high: 196534895110520403468668732540068853257
            }
        );
    layers_auth_paths_sym_0_5
        .append(
            u256 {
                low: 40632891138550327366235261530189370032,
                high: 59472961261727285026209866601168991375
            }
        );
    layers_auth_paths_sym_0_5
        .append(
            u256 {
                low: 158762673685784414170104553691974967898,
                high: 236769934064857992001888578478409088515
            }
        );
    layers_auth_paths_sym_0_5
        .append(
            u256 {
                low: 289415171726221612463310997637235358079,
                high: 334639251267131551826472078786779035435
            }
        );
    let mut layers_auth_paths_sym_0_6 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_0_6
        .append(
            u256 {
                low: 266514397095452327027773254569867062028,
                high: 1835920979859448989004232336222137741
            }
        );
    layers_auth_paths_sym_0_6
        .append(
            u256 {
                low: 35358595743390628738884295802181859000,
                high: 110104655771562844348110548778900603962
            }
        );
    layers_auth_paths_sym_0_6
        .append(
            u256 {
                low: 114361401917513213130806253386415487430,
                high: 333888436753491099429433488360832052187
            }
        );
    layers_auth_paths_sym_0_6
        .append(
            u256 {
                low: 328342918320856762977801565857141253240,
                high: 278762061327697326664270612392826830156
            }
        );
    let mut layers_auth_paths_sym_0_7 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_0_7
        .append(
            u256 {
                low: 111664371490223067993570467962778159387,
                high: 194899032737421637582684940215022217106
            }
        );
    layers_auth_paths_sym_0_7
        .append(
            u256 {
                low: 292412282057761078370801221633847365662,
                high: 143168140807264409366301497681367476072
            }
        );
    layers_auth_paths_sym_0_7
        .append(
            u256 {
                low: 110083782178434677884302968743125804305,
                high: 90000316738646863924086218928571489800
            }
        );

    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_0);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_1);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_2);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_3);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_4);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_5);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_6);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_7);
    let mut layers_evaluations_sym_0 = ArrayDefault::<felt252>::default();
    layers_evaluations_sym_0
        .append(0x5e2e6d7896b9ecd85d60e421c3c663dfe8c7c1e10236792fff42fc6016bee8d);
    layers_evaluations_sym_0
        .append(0x39439f8d23bb0cc52ccf3b58e4b1c31e0b624e6ac2455496c6f60c911ed99c7);
    layers_evaluations_sym_0
        .append(0x28af063edc26ee0e74b61ec27f407563d0e3cdc7016957de39623bed43671dc);
    layers_evaluations_sym_0
        .append(0x25a4d10f3701d2adcf9f411303dc0180cef103c978740110ad15a84d11cbae0);
    layers_evaluations_sym_0
        .append(0x7cbbedf415124ee70d09467ceb4c48c28ce75cf4a91ea850a36def7d8ff9888);
    layers_evaluations_sym_0
        .append(0x2ea34659d44be176347dede5b9c66ea959cdd67f957cd5dd3370f1174329b13);
    layers_evaluations_sym_0
        .append(0x1564d9aa8d01faf03d74cebbaadaf89fd157e555d7c53b2ff3dad397113b2a7);
    layers_evaluations_sym_0
        .append(0x7912239f5614ba51727a1724ef96713eef99d1367729a60ff5a84f54290c6e3);

    let mut layers_auth_paths_0 = ArrayDefault::<Array<u256>>::default();
    let mut layers_auth_paths_0_0 = ArrayDefault::<u256>::default();
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 42777689024213990886975174202745871864,
                high: 147423266779238664230250736393419006642
            }
        );
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 49493124204778466756066411828962981679,
                high: 66643829188584260411187846643156283446
            }
        );
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 229216548916534109276290569402710948691,
                high: 274234632033684280445039986283400970171
            }
        );
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 125444445461776451511135339546965172660,
                high: 66248783221416356540781716038275011888
            }
        );
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 294030270340687768611957894829075536583,
                high: 101439402287156797919283089821751852398
            }
        );
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 225212072308169585838824735575817393195,
                high: 32545626897911135852399844985877609581
            }
        );
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 333483280097267271150329521490109290457,
                high: 337830594337446999660706251137568843833
            }
        );
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 76112708822376260277847961035534507406,
                high: 170998254808002862957286075001599035742
            }
        );
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 223202216385695728384579475401167551090,
                high: 299629850818018557601744941196407114840
            }
        );
    layers_auth_paths_0_0
        .append(
            u256 {
                low: 124353648107075363806813211650795747188,
                high: 323709849113742745014784451740485302172
            }
        );
    let mut layers_auth_paths_0_1 = ArrayDefault::<u256>::default();
    layers_auth_paths_0_1
        .append(
            u256 {
                low: 253835182177475325949249596272823943238,
                high: 48524476151921207961985044072377730600
            }
        );
    layers_auth_paths_0_1
        .append(
            u256 {
                low: 260229688541841922213359502900116953102,
                high: 199622098950204479736233807525356201651
            }
        );
    layers_auth_paths_0_1
        .append(
            u256 {
                low: 199805529679465150214710578406418292716,
                high: 189280301832312975759537749583859863849
            }
        );
    layers_auth_paths_0_1
        .append(
            u256 {
                low: 83676311912627141417301304818459251127,
                high: 5707758273925892630209633643484759127
            }
        );
    layers_auth_paths_0_1
        .append(
            u256 {
                low: 46541675637193908623157790314634538965,
                high: 214217937363813562418814818314923904228
            }
        );
    layers_auth_paths_0_1
        .append(
            u256 {
                low: 142552126845285768228379097489370946498,
                high: 62646707470441169347064373375884099917
            }
        );
    layers_auth_paths_0_1
        .append(
            u256 {
                low: 221847468552955635879765835974431395831,
                high: 158285880652205327052686161954710669359
            }
        );
    layers_auth_paths_0_1
        .append(
            u256 {
                low: 265395950470209665144406967824313046138,
                high: 314783789504197782263220423178063033119
            }
        );
    layers_auth_paths_0_1
        .append(
            u256 {
                low: 156107435889997327808399678620525069992,
                high: 337189103180430242969139377630750491113
            }
        );
    let mut layers_auth_paths_0_2 = ArrayDefault::<u256>::default();
    layers_auth_paths_0_2
        .append(
            u256 {
                low: 315502288571408535535719579964184783028,
                high: 214400297200908325436490557505033529792
            }
        );
    layers_auth_paths_0_2
        .append(
            u256 {
                low: 232226464744663719584748089612239632766,
                high: 207836518339761946693963985205703470531
            }
        );
    layers_auth_paths_0_2
        .append(
            u256 {
                low: 53971441476689332446342502939783724410,
                high: 132807788469789123551644372042827160972
            }
        );
    layers_auth_paths_0_2
        .append(
            u256 {
                low: 96638640112350628065507922945738650163,
                high: 295776226961098706411385593119211350870
            }
        );
    layers_auth_paths_0_2
        .append(
            u256 {
                low: 274206212534142973372709231477474749126,
                high: 90818492916474777825312712527234769888
            }
        );
    layers_auth_paths_0_2
        .append(
            u256 {
                low: 202757792622251928903255741043861242713,
                high: 181001479559579113863525823892055060711
            }
        );
    layers_auth_paths_0_2
        .append(
            u256 {
                low: 80473776902925455258999581273950887392,
                high: 65945867187817652396531004148012851617
            }
        );
    layers_auth_paths_0_2
        .append(
            u256 {
                low: 99179036659774354842096222796057668201,
                high: 116515794677859955514361202081784773234
            }
        );
    let mut layers_auth_paths_0_3 = ArrayDefault::<u256>::default();
    layers_auth_paths_0_3
        .append(
            u256 {
                low: 270823615170042943206608877666796255427,
                high: 211994817492218497810412474407589701799
            }
        );
    layers_auth_paths_0_3
        .append(
            u256 {
                low: 152906719211242024107490577846168914602,
                high: 314729057720926179253041886918203405590
            }
        );
    layers_auth_paths_0_3
        .append(
            u256 {
                low: 71959040222832839839143816938433984532,
                high: 179281117793602497343662608367154095796
            }
        );
    layers_auth_paths_0_3
        .append(
            u256 {
                low: 112433815828448952549666343556901588162,
                high: 224114996398312625735404965991552911444
            }
        );
    layers_auth_paths_0_3
        .append(
            u256 {
                low: 39415349541521654423672597253110567931,
                high: 37648677601961437698096384235155283720
            }
        );
    layers_auth_paths_0_3
        .append(
            u256 {
                low: 294577109418722360748185646269723678041,
                high: 267253273818919042922138020594417972128
            }
        );
    layers_auth_paths_0_3
        .append(
            u256 {
                low: 160823391972794652570745180193193033627,
                high: 317797290068453894944819571966820835934
            }
        );
    let mut layers_auth_paths_0_4 = ArrayDefault::<u256>::default();
    layers_auth_paths_0_4
        .append(
            u256 {
                low: 239792131416437555380070975578371568971,
                high: 118235158082242195051559468479093615342
            }
        );
    layers_auth_paths_0_4
        .append(
            u256 {
                low: 77807778936828510829550566261291825070,
                high: 250964710819486091630637097490078904877
            }
        );
    layers_auth_paths_0_4
        .append(
            u256 {
                low: 123095377930565696006055503619384273961,
                high: 82934076162074320630363604923580507843
            }
        );
    layers_auth_paths_0_4
        .append(
            u256 {
                low: 294750448859283568524755276790758058543,
                high: 320851053429880463955678326877083045713
            }
        );
    layers_auth_paths_0_4
        .append(
            u256 {
                low: 337015246483329663669017287451506338162,
                high: 279670346032950065295907316297950875136
            }
        );
    layers_auth_paths_0_4
        .append(
            u256 {
                low: 45705404148533291620111678777204003710,
                high: 33034682838256325486536211038035399696
            }
        );
    let mut layers_auth_paths_0_5 = ArrayDefault::<u256>::default();
    layers_auth_paths_0_5
        .append(
            u256 {
                low: 47179622394853807573652958122480930109,
                high: 118985129742252215723925608199260027990
            }
        );
    layers_auth_paths_0_5
        .append(
            u256 {
                low: 3969056756735515588118398160530158158,
                high: 88732407364063897878413802012446778067
            }
        );
    layers_auth_paths_0_5
        .append(
            u256 {
                low: 166219820271663397863714280745345070902,
                high: 112064112153103521094929723754296592992
            }
        );
    layers_auth_paths_0_5
        .append(
            u256 {
                low: 166799690118368986209861268982930210381,
                high: 71118822533843321454062995458727575194
            }
        );
    layers_auth_paths_0_5
        .append(
            u256 {
                low: 228245847417283761870414481004685531428,
                high: 140943136689202621901201270160181623281
            }
        );
    let mut layers_auth_paths_0_6 = ArrayDefault::<u256>::default();
    layers_auth_paths_0_6
        .append(
            u256 {
                low: 162623783827324527292077659533258793090,
                high: 116079847679945500547013732670573637072
            }
        );
    layers_auth_paths_0_6
        .append(
            u256 {
                low: 123750472159826897925977193587107686795,
                high: 37226617219927293199310345995334426143
            }
        );
    layers_auth_paths_0_6
        .append(
            u256 {
                low: 34850652219020939007425828603363554044,
                high: 101464016638349968833240076228794149446
            }
        );
    layers_auth_paths_0_6
        .append(
            u256 {
                low: 165078416090957814657996838956930728133,
                high: 48779952954251509984159724599570761582
            }
        );
    let mut layers_auth_paths_0_7 = ArrayDefault::<u256>::default();
    layers_auth_paths_0_7
        .append(
            u256 {
                low: 298773781772445226461854728299677779162,
                high: 131940913397192481733230034817475969948
            }
        );
    layers_auth_paths_0_7
        .append(
            u256 {
                low: 236457633781949116968692696554316544188,
                high: 108486755406460996391236657651616759396
            }
        );
    layers_auth_paths_0_7
        .append(
            u256 {
                low: 166994159928196044442312366406028910249,
                high: 223237937838162716452599516456343849407
            }
        );

    layers_auth_paths_0.append(layers_auth_paths_0_0);
    layers_auth_paths_0.append(layers_auth_paths_0_1);
    layers_auth_paths_0.append(layers_auth_paths_0_2);
    layers_auth_paths_0.append(layers_auth_paths_0_3);
    layers_auth_paths_0.append(layers_auth_paths_0_4);
    layers_auth_paths_0.append(layers_auth_paths_0_5);
    layers_auth_paths_0.append(layers_auth_paths_0_6);
    layers_auth_paths_0.append(layers_auth_paths_0_7);
    let mut layers_evaluations_0 = ArrayDefault::<felt252>::default();
    layers_evaluations_0.append(0x7d8c73e0406f29ac1f76816b305f97496f1453830dfc374d5827d51df21d0cc);
    layers_evaluations_0.append(0x361347819f4b2cbe07387a30e2000e4919153da8f5cdc383aeab27cfb3f13ed);
    layers_evaluations_0.append(0x407e57fbc3f8df35672d5a3d4a7f2aaf6d3d0a5180354a8d0cf7dfad202960e);
    layers_evaluations_0.append(0x623683696319382f5859cd904d2aba9296bdc4b33a2bfc83f49fb403dd98858);
    layers_evaluations_0.append(0x25498a3dc06027854d78f9ca844dbebc6691daa3fe64e927f0ef62cd4935329);
    layers_evaluations_0.append(0x2100fe583937b6b6a71ea77e114b3ce1038f472b4971e48732ad49b4fa1b11);
    layers_evaluations_0.append(0x2680893a2f333a177c074150ceba5de0cf61a5326942a0235345a979e9b7b2);
    layers_evaluations_0.append(0x631006ca6bfa8bf9ed4117607e673f8f05a01d592dbc2dbedfc8a0a68bb5831);

    let fri_decommitment_0 = FriDecommitment {
        layers_auth_paths_sym: layers_auth_paths_sym_0,
        layers_evaluations_sym: layers_evaluations_sym_0,
        layers_auth_paths: layers_auth_paths_0,
        layers_evaluations: layers_evaluations_0,
    };
    query_list.append(fri_decommitment_0);
    let mut layers_auth_paths_sym_1 = ArrayDefault::<Array<u256>>::default();
    let mut layers_auth_paths_sym_1_0 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 253100848627466184407919062468644036721,
                high: 68696127041064341035008932238600572447
            }
        );
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 310000059694738913972676791789095408305,
                high: 279950015980275657949776485269083883329
            }
        );
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 91378295691606701179578490080794861048,
                high: 310157038405155965809584214507193762138
            }
        );
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 110756483083516128930957550358386159499,
                high: 3487930443699917860257057034696502428
            }
        );
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 268504104261880762650576036660434401578,
                high: 322673469455764776391783872815067694275
            }
        );
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 144155251645667199823164080444975097610,
                high: 161940052518956975953317906681388916834
            }
        );
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 206124301735870216912739074000548166585,
                high: 264042517217357752267107920946717225371
            }
        );
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 12903660890916496934831321067110124884,
                high: 240076374127065225099758835887095368824
            }
        );
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 286470498567857585816092614585228411206,
                high: 21407098366465489100471982281877431695
            }
        );
    layers_auth_paths_sym_1_0
        .append(
            u256 {
                low: 287413520183178317777135645887624208226,
                high: 331496425490372260601024991771599738477
            }
        );
    let mut layers_auth_paths_sym_1_1 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_1_1
        .append(
            u256 {
                low: 208970419217923199963041146374757366668,
                high: 12422812633737948559319649296010558504
            }
        );
    layers_auth_paths_sym_1_1
        .append(
            u256 {
                low: 62970850051601394014319922513869994377,
                high: 69381533156654352162852360833739170865
            }
        );
    layers_auth_paths_sym_1_1
        .append(
            u256 {
                low: 221293190077080622427846309865651478003,
                high: 139361756516115182950455431040656943391
            }
        );
    layers_auth_paths_sym_1_1
        .append(
            u256 {
                low: 240931899071222149202718255169114791903,
                high: 41149806113806006579484926163768036943
            }
        );
    layers_auth_paths_sym_1_1
        .append(
            u256 {
                low: 237068675494675349383289161487669269751,
                high: 107627590033772917925374291465964382794
            }
        );
    layers_auth_paths_sym_1_1
        .append(
            u256 {
                low: 152019452409673925770103909537692685027,
                high: 274299601988327834040420479697177787504
            }
        );
    layers_auth_paths_sym_1_1
        .append(
            u256 {
                low: 272769620257917927256374857129320591489,
                high: 248149500047200955047322442605793575681
            }
        );
    layers_auth_paths_sym_1_1
        .append(
            u256 {
                low: 133615615528443242692204596768321150668,
                high: 277025064425157309085485950527646522360
            }
        );
    layers_auth_paths_sym_1_1
        .append(
            u256 {
                low: 156107435889997327808399678620525069992,
                high: 337189103180430242969139377630750491113
            }
        );
    let mut layers_auth_paths_sym_1_2 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_1_2
        .append(
            u256 {
                low: 322570260131395660327387156250836835033,
                high: 137975395622339774770383630823361741301
            }
        );
    layers_auth_paths_sym_1_2
        .append(
            u256 {
                low: 154608240239994921004642617133301177406,
                high: 101085486624866566810108127984087854161
            }
        );
    layers_auth_paths_sym_1_2
        .append(
            u256 {
                low: 24168230038173904937923779959348264379,
                high: 274647651084513881294695695330933984028
            }
        );
    layers_auth_paths_sym_1_2
        .append(
            u256 {
                low: 222364627460217932622783590346817169644,
                high: 155150105087022566311353683011996092348
            }
        );
    layers_auth_paths_sym_1_2
        .append(
            u256 {
                low: 233815625559357828479055975501596829550,
                high: 65064559724883418289915164522282644670
            }
        );
    layers_auth_paths_sym_1_2
        .append(
            u256 {
                low: 95090073801550983592310174613477660006,
                high: 163349460366325413578539602293492528407
            }
        );
    layers_auth_paths_sym_1_2
        .append(
            u256 {
                low: 22221127419412047016286660954003212580,
                high: 20858655967067623060621205047478416397
            }
        );
    layers_auth_paths_sym_1_2
        .append(
            u256 {
                low: 99179036659774354842096222796057668201,
                high: 116515794677859955514361202081784773234
            }
        );
    let mut layers_auth_paths_sym_1_3 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_1_3
        .append(
            u256 {
                low: 258745057304912137779108989689770356405,
                high: 137227278807102334351523962293446772407
            }
        );
    layers_auth_paths_sym_1_3
        .append(
            u256 {
                low: 227647942255472610338595324886926950535,
                high: 153626101552701494846627478633699081901
            }
        );
    layers_auth_paths_sym_1_3
        .append(
            u256 {
                low: 80520984822695340590035753198515373915,
                high: 312209045433505603922579274375490438410
            }
        );
    layers_auth_paths_sym_1_3
        .append(
            u256 {
                low: 102980117372940879741778136454255243095,
                high: 119405115987361620767216543919793345245
            }
        );
    layers_auth_paths_sym_1_3
        .append(
            u256 {
                low: 230270433738731545050758085472697542455,
                high: 122700685961871202956857093375283408463
            }
        );
    layers_auth_paths_sym_1_3
        .append(
            u256 {
                low: 185772167465320613723281067202867788667,
                high: 245656288358948344752473617017811865687
            }
        );
    layers_auth_paths_sym_1_3
        .append(
            u256 {
                low: 160823391972794652570745180193193033627,
                high: 317797290068453894944819571966820835934
            }
        );
    let mut layers_auth_paths_sym_1_4 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_1_4
        .append(
            u256 {
                low: 177560531094608550098182245831229099539,
                high: 245140620166824969995698065681264333245
            }
        );
    layers_auth_paths_sym_1_4
        .append(
            u256 {
                low: 71844536412495691563768181223893394026,
                high: 229361307905615504251156101049315095218
            }
        );
    layers_auth_paths_sym_1_4
        .append(
            u256 {
                low: 38147699126311365391903971362927190587,
                high: 16464998194401025376220185605595091267
            }
        );
    layers_auth_paths_sym_1_4
        .append(
            u256 {
                low: 30740596863151906292168212989443945186,
                high: 209899443328338663348718580393388365986
            }
        );
    layers_auth_paths_sym_1_4
        .append(
            u256 {
                low: 337015246483329663669017287451506338162,
                high: 279670346032950065295907316297950875136
            }
        );
    layers_auth_paths_sym_1_4
        .append(
            u256 {
                low: 45705404148533291620111678777204003710,
                high: 33034682838256325486536211038035399696
            }
        );
    let mut layers_auth_paths_sym_1_5 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_1_5
        .append(
            u256 {
                low: 41581535950718331516723078716353949496,
                high: 105125733953785731414375447916680177039
            }
        );
    layers_auth_paths_sym_1_5
        .append(
            u256 {
                low: 54733775934323038969283058468915072052,
                high: 286962668966444824960499068408936468298
            }
        );
    layers_auth_paths_sym_1_5
        .append(
            u256 {
                low: 99009004626153118967834837802640872774,
                high: 81856189214053681172518810619006091313
            }
        );
    layers_auth_paths_sym_1_5
        .append(
            u256 {
                low: 164142427247052558373324764565351784214,
                high: 234204021883364125033695894647335803787
            }
        );
    layers_auth_paths_sym_1_5
        .append(
            u256 {
                low: 289415171726221612463310997637235358079,
                high: 334639251267131551826472078786779035435
            }
        );
    let mut layers_auth_paths_sym_1_6 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_1_6
        .append(
            u256 {
                low: 88926070128999314939460522506221873341,
                high: 275899612365973506088003892921411126684
            }
        );
    layers_auth_paths_sym_1_6
        .append(
            u256 {
                low: 16582084675955095922875761085858232482,
                high: 216160967542403200552068849094246544903
            }
        );
    layers_auth_paths_sym_1_6
        .append(
            u256 {
                low: 122600220912034231258284145266045823665,
                high: 33629633349675568392084039552373564697
            }
        );
    layers_auth_paths_sym_1_6
        .append(
            u256 {
                low: 165078416090957814657996838956930728133,
                high: 48779952954251509984159724599570761582
            }
        );
    let mut layers_auth_paths_sym_1_7 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_1_7
        .append(
            u256 {
                low: 298773781772445226461854728299677779162,
                high: 131940913397192481733230034817475969948
            }
        );
    layers_auth_paths_sym_1_7
        .append(
            u256 {
                low: 236457633781949116968692696554316544188,
                high: 108486755406460996391236657651616759396
            }
        );
    layers_auth_paths_sym_1_7
        .append(
            u256 {
                low: 166994159928196044442312366406028910249,
                high: 223237937838162716452599516456343849407
            }
        );

    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_0);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_1);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_2);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_3);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_4);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_5);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_6);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_7);
    let mut layers_evaluations_sym_1 = ArrayDefault::<felt252>::default();
    layers_evaluations_sym_1
        .append(0x267bc06a87ea6b80b2370c46124ae0a51ad41a191aa4b9f9401e216f9722849);
    layers_evaluations_sym_1
        .append(0x54a7a1a757828a7e6b14020a5df965f729cd453d74f84bcf0ac50374097ad2e);
    layers_evaluations_sym_1
        .append(0x6c3157b9ddae0c9ed4806f552020da3d91ae2bf3387d44620913ab334ab2aea);
    layers_evaluations_sym_1
        .append(0xef4e2251cb4aae0379d924f23558db355bab247f0ae07aba4db6acf708f98e);
    layers_evaluations_sym_1
        .append(0x107125f21c4e77132697aeebab81b011ba5d49450eb2cec562ebdb65393f51c);
    layers_evaluations_sym_1
        .append(0x127a7b5c71b05cda95b4b969047b97a43ebfe99aac45f2d48024b776d970fa0);
    layers_evaluations_sym_1
        .append(0x3c3add26ce2c77e19de24ec5bd5b7b74b4de261f934ebae9cca1cc6645effed);
    layers_evaluations_sym_1
        .append(0x631006ca6bfa8bf9ed4117607e673f8f05a01d592dbc2dbedfc8a0a68bb5831);

    let mut layers_auth_paths_1 = ArrayDefault::<Array<u256>>::default();
    let mut layers_auth_paths_1_0 = ArrayDefault::<u256>::default();
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 162512110449254205661206404935528450707,
                high: 189645549475760791815656762357551531108
            }
        );
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 226443018829039051334802260478319377498,
                high: 261610064953128699866577120250160189413
            }
        );
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 295925380162883266539220415259589645877,
                high: 185363831359760658637224896902140644596
            }
        );
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 224635245219739114444587509399784263069,
                high: 74610766713362067142738238808999612795
            }
        );
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 16145416896338775297911417318161478938,
                high: 89979076182073927581261370680684823027
            }
        );
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 99246611542447413749674753790614850062,
                high: 324798113710348389613613673583733692320
            }
        );
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 293319488218682841900224459153239040498,
                high: 191072509299747351490633124337922302271
            }
        );
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 305852550736656050890207941167721533950,
                high: 111011900567146745386984740340249042326
            }
        );
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 139977605963565248377296480483002407187,
                high: 159418815533181393629010393818806367813
            }
        );
    layers_auth_paths_1_0
        .append(
            u256 {
                low: 124353648107075363806813211650795747188,
                high: 323709849113742745014784451740485302172
            }
        );
    let mut layers_auth_paths_1_1 = ArrayDefault::<u256>::default();
    layers_auth_paths_1_1
        .append(
            u256 {
                low: 122171505230502199747132870422654283613,
                high: 277015028533027189090909932000813517616
            }
        );
    layers_auth_paths_1_1
        .append(
            u256 {
                low: 168555136224399424634728711271222659425,
                high: 159938413715408497002042087999251379911
            }
        );
    layers_auth_paths_1_1
        .append(
            u256 {
                low: 249185423438219449467584698230928088833,
                high: 284541035284212011173807133506768230535
            }
        );
    layers_auth_paths_1_1
        .append(
            u256 {
                low: 236222581130409938708484376552956844213,
                high: 158732367677786986857705244433693403093
            }
        );
    layers_auth_paths_1_1
        .append(
            u256 {
                low: 164647728198709900057901350155491541780,
                high: 219183785519636743723299072722468156521
            }
        );
    layers_auth_paths_1_1
        .append(
            u256 {
                low: 87440738586749843867960456303035747459,
                high: 303095629751325400616487269136320724988
            }
        );
    layers_auth_paths_1_1
        .append(
            u256 {
                low: 153133580036803179752190161098222891313,
                high: 214817436886091208426384083610989412333
            }
        );
    layers_auth_paths_1_1
        .append(
            u256 {
                low: 333848460072635327382288744899807843090,
                high: 153393624087630980854051318944212642545
            }
        );
    layers_auth_paths_1_1
        .append(
            u256 {
                low: 24446239940912575710402166432704535459,
                high: 33769997792391823602231864473096053116
            }
        );
    let mut layers_auth_paths_1_2 = ArrayDefault::<u256>::default();
    layers_auth_paths_1_2
        .append(
            u256 {
                low: 168968722303988592295201840752358148009,
                high: 208348680725377477503431497769379054531
            }
        );
    layers_auth_paths_1_2
        .append(
            u256 {
                low: 56408135439103785861679663053122587817,
                high: 20943567923629173231528032143559159490
            }
        );
    layers_auth_paths_1_2
        .append(
            u256 {
                low: 289332514281682174699794039976621984541,
                high: 178940829093641904701906960377115432058
            }
        );
    layers_auth_paths_1_2
        .append(
            u256 {
                low: 246400127531608170782813537925822152126,
                high: 64873867016955076155006308479851908023
            }
        );
    layers_auth_paths_1_2
        .append(
            u256 {
                low: 286406452669584381922799580155378172250,
                high: 78245009473863957939799226126529488972
            }
        );
    layers_auth_paths_1_2
        .append(
            u256 {
                low: 306901331021777836995569278454914583786,
                high: 260386217674826548978388621506423230772
            }
        );
    layers_auth_paths_1_2
        .append(
            u256 {
                low: 153732009761575835618799450516033837582,
                high: 54227404073201267982332375978295982789
            }
        );
    layers_auth_paths_1_2
        .append(
            u256 {
                low: 25668642760051300240340639726985410401,
                high: 55451695112306766710790848305171195208
            }
        );
    let mut layers_auth_paths_1_3 = ArrayDefault::<u256>::default();
    layers_auth_paths_1_3
        .append(
            u256 {
                low: 125590112074800153220382681046830753618,
                high: 263541126801114894426331140853826215331
            }
        );
    layers_auth_paths_1_3
        .append(
            u256 {
                low: 71558158810049802187568131231682560162,
                high: 260484876269938662964888355936330779377
            }
        );
    layers_auth_paths_1_3
        .append(
            u256 {
                low: 128361425503723533213194422878642175081,
                high: 304389738510980374730084151104490488269
            }
        );
    layers_auth_paths_1_3
        .append(
            u256 {
                low: 52595873092421165020269544959116107529,
                high: 206036162197733601415810043971489154574
            }
        );
    layers_auth_paths_1_3
        .append(
            u256 {
                low: 250634216572021170156725207445678759340,
                high: 316026507437077781980099345571291419456
            }
        );
    layers_auth_paths_1_3
        .append(
            u256 {
                low: 188836902783563390032780708103971340567,
                high: 281838652399300933196271789362851612217
            }
        );
    layers_auth_paths_1_3
        .append(
            u256 {
                low: 132004417065944158262759950088273194550,
                high: 117542597907677031594803928870487949326
            }
        );
    let mut layers_auth_paths_1_4 = ArrayDefault::<u256>::default();
    layers_auth_paths_1_4
        .append(
            u256 {
                low: 148341715903374776914410334907691773904,
                high: 178187747524086586094464178821477074726
            }
        );
    layers_auth_paths_1_4
        .append(
            u256 {
                low: 251676492276298848001640292471625046200,
                high: 140391420240945230465638436333224339346
            }
        );
    layers_auth_paths_1_4
        .append(
            u256 {
                low: 288509124075091670228123404716012907152,
                high: 158639671311204457324889722299293784839
            }
        );
    layers_auth_paths_1_4
        .append(
            u256 {
                low: 175030661742321925161746280345665196438,
                high: 176284082283646433354816144868875299143
            }
        );
    layers_auth_paths_1_4
        .append(
            u256 {
                low: 11738409729192584274153829087312013896,
                high: 209878191762331363443216895000456079272
            }
        );
    layers_auth_paths_1_4
        .append(
            u256 {
                low: 83807366973467871380607186738821016710,
                high: 278444839435223765219780459675870208580
            }
        );
    let mut layers_auth_paths_1_5 = ArrayDefault::<u256>::default();
    layers_auth_paths_1_5
        .append(
            u256 {
                low: 171450173536607456247182286076617976929,
                high: 21382129442902662676025123331943137373
            }
        );
    layers_auth_paths_1_5
        .append(
            u256 {
                low: 289441614599635358245681169385524531946,
                high: 173115097103883766458982337280588350629
            }
        );
    layers_auth_paths_1_5
        .append(
            u256 {
                low: 6721623748377167123614085984118348430,
                high: 159891680812259557479910218930222318300
            }
        );
    layers_auth_paths_1_5
        .append(
            u256 {
                low: 49196434510664117196060617014774932503,
                high: 242095771888215333687403209299953283051
            }
        );
    layers_auth_paths_1_5
        .append(
            u256 {
                low: 228245847417283761870414481004685531428,
                high: 140943136689202621901201270160181623281
            }
        );
    let mut layers_auth_paths_1_6 = ArrayDefault::<u256>::default();
    layers_auth_paths_1_6
        .append(
            u256 {
                low: 96225297302185707342640136691709410928,
                high: 317087333864595695445828035624345831144
            }
        );
    layers_auth_paths_1_6
        .append(
            u256 {
                low: 240051536079205426587848332730701153497,
                high: 269243237797607350098421635038247227638
            }
        );
    layers_auth_paths_1_6
        .append(
            u256 {
                low: 286779774655990185356565352129128872898,
                high: 85394329172497948288626867291293968331
            }
        );
    layers_auth_paths_1_6
        .append(
            u256 {
                low: 328342918320856762977801565857141253240,
                high: 278762061327697326664270612392826830156
            }
        );
    let mut layers_auth_paths_1_7 = ArrayDefault::<u256>::default();
    layers_auth_paths_1_7
        .append(
            u256 {
                low: 111664371490223067993570467962778159387,
                high: 194899032737421637582684940215022217106
            }
        );
    layers_auth_paths_1_7
        .append(
            u256 {
                low: 292412282057761078370801221633847365662,
                high: 143168140807264409366301497681367476072
            }
        );
    layers_auth_paths_1_7
        .append(
            u256 {
                low: 110083782178434677884302968743125804305,
                high: 90000316738646863924086218928571489800
            }
        );

    layers_auth_paths_1.append(layers_auth_paths_1_0);
    layers_auth_paths_1.append(layers_auth_paths_1_1);
    layers_auth_paths_1.append(layers_auth_paths_1_2);
    layers_auth_paths_1.append(layers_auth_paths_1_3);
    layers_auth_paths_1.append(layers_auth_paths_1_4);
    layers_auth_paths_1.append(layers_auth_paths_1_5);
    layers_auth_paths_1.append(layers_auth_paths_1_6);
    layers_auth_paths_1.append(layers_auth_paths_1_7);
    let mut layers_evaluations_1 = ArrayDefault::<felt252>::default();
    layers_evaluations_1.append(0x53ba84dcfd8299a5263d5571949e30bf439ef0eef03025a14996dc6d69dc8c4);
    layers_evaluations_1.append(0x2a2701a35a0d636d9b0ff11b05e364302bba2dd0bf2e4f14e82c2f0c147a183);
    layers_evaluations_1.append(0x1c94bad1fcd7734a9220bffa7dc355f01e9ca1ec8a3797c9f3b4b20f9aa896);
    layers_evaluations_1.append(0x24cb3bf50300dde0f90840233d8b2bc8d3c1778f8b2c273bbfe4cbe5108ef27);
    layers_evaluations_1.append(0x21492e849d33944046070de5075ef031ccf0c5ae076ef444dd0601ae7077c6b);
    layers_evaluations_1.append(0x65ae4bbf1c9ca3371c6834e231d6ef91f2f8700c9d6fe83d26ba98c62bda012);
    layers_evaluations_1.append(0x2c838858de47d69eed20495d153ec1bbf7340d2a4d150b49f98463874447ca1);
    layers_evaluations_1.append(0x7912239f5614ba51727a1724ef96713eef99d1367729a60ff5a84f54290c6e3);

    let fri_decommitment_1 = FriDecommitment {
        layers_auth_paths_sym: layers_auth_paths_sym_1,
        layers_evaluations_sym: layers_evaluations_sym_1,
        layers_auth_paths: layers_auth_paths_1,
        layers_evaluations: layers_evaluations_1,
    };
    query_list.append(fri_decommitment_1);
    let mut layers_auth_paths_sym_2 = ArrayDefault::<Array<u256>>::default();
    let mut layers_auth_paths_sym_2_0 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 85683705256171447272265349800332597935,
                high: 4793617602534085654697580017053847632
            }
        );
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 33238907542146867129674857235219127957,
                high: 134851497865416964939303291046685310682
            }
        );
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 163701286536776587657475259175584641560,
                high: 216108506676984896935614116514752991667
            }
        );
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 263396601346812962172918348372448451256,
                high: 2209776501965719505742308449899127421
            }
        );
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 220442646925959374080982426910230839077,
                high: 336155414839119331270623288583126380433
            }
        );
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 314446226455043829552830220223469525251,
                high: 2030988907138928985393066269834766553
            }
        );
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 8363676324085251659156382583064671354,
                high: 306438339247036967169373017447900330878
            }
        );
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 76112708822376260277847961035534507406,
                high: 170998254808002862957286075001599035742
            }
        );
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 223202216385695728384579475401167551090,
                high: 299629850818018557601744941196407114840
            }
        );
    layers_auth_paths_sym_2_0
        .append(
            u256 {
                low: 124353648107075363806813211650795747188,
                high: 323709849113742745014784451740485302172
            }
        );
    let mut layers_auth_paths_sym_2_1 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_2_1
        .append(
            u256 {
                low: 250638889352087094965309988369077666428,
                high: 126423251722801446335397811959130115952
            }
        );
    layers_auth_paths_sym_2_1
        .append(
            u256 {
                low: 68688008401394852846431384993625297987,
                high: 255098562092636497448070212408627560918
            }
        );
    layers_auth_paths_sym_2_1
        .append(
            u256 {
                low: 187810599243954226024693168376642286246,
                high: 68772912409748051490296129801905796302
            }
        );
    layers_auth_paths_sym_2_1
        .append(
            u256 {
                low: 23727653352428400297701847279230117361,
                high: 144210279206560335875010880838289655100
            }
        );
    layers_auth_paths_sym_2_1
        .append(
            u256 {
                low: 172296785493152021051431889396886584183,
                high: 162794138045413693930556049250199946865
            }
        );
    layers_auth_paths_sym_2_1
        .append(
            u256 {
                low: 288244775718370661471334686352114907428,
                high: 173610308660831507702540945582619334816
            }
        );
    layers_auth_paths_sym_2_1
        .append(
            u256 {
                low: 179690372464420033579944799794003256964,
                high: 290212415614681343395470888737924951894
            }
        );
    layers_auth_paths_sym_2_1
        .append(
            u256 {
                low: 13459777295538119246461746181036692641,
                high: 81832489705007973988813297392510105224
            }
        );
    layers_auth_paths_sym_2_1
        .append(
            u256 {
                low: 24446239940912575710402166432704535459,
                high: 33769997792391823602231864473096053116
            }
        );
    let mut layers_auth_paths_sym_2_2 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_2_2
        .append(
            u256 {
                low: 252902163155263362047093915886676031507,
                high: 192098385356866844612999570121067339646
            }
        );
    layers_auth_paths_sym_2_2
        .append(
            u256 {
                low: 241799529118124738688459771509303380145,
                high: 184817023541911565000132040436608397402
            }
        );
    layers_auth_paths_sym_2_2
        .append(
            u256 {
                low: 272667744685368919768098309450771095044,
                high: 95379761861113827028846340808829775316
            }
        );
    layers_auth_paths_sym_2_2
        .append(
            u256 {
                low: 278614440479664487769074424308275051675,
                high: 142199431601444067291143278685985057962
            }
        );
    layers_auth_paths_sym_2_2
        .append(
            u256 {
                low: 101327672443368202572421645710383747361,
                high: 66917095661966477281850212156516886006
            }
        );
    layers_auth_paths_sym_2_2
        .append(
            u256 {
                low: 222808752553988863666046314460433682660,
                high: 200422608920980450694431691725756252261
            }
        );
    layers_auth_paths_sym_2_2
        .append(
            u256 {
                low: 153732009761575835618799450516033837582,
                high: 54227404073201267982332375978295982789
            }
        );
    layers_auth_paths_sym_2_2
        .append(
            u256 {
                low: 25668642760051300240340639726985410401,
                high: 55451695112306766710790848305171195208
            }
        );
    let mut layers_auth_paths_sym_2_3 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_2_3
        .append(
            u256 {
                low: 166737830522136488829772217606256830517,
                high: 45584260208334453270636791218682167656
            }
        );
    layers_auth_paths_sym_2_3
        .append(
            u256 {
                low: 268436668160009058350083724927845009311,
                high: 278614943398451210284316857600810856485
            }
        );
    layers_auth_paths_sym_2_3
        .append(
            u256 {
                low: 273078782917647835788648306437598673013,
                high: 305157290660621540979785480282428767910
            }
        );
    layers_auth_paths_sym_2_3
        .append(
            u256 {
                low: 78156282221422478160664793307553797499,
                high: 201918318917341004098033378496040643268
            }
        );
    layers_auth_paths_sym_2_3
        .append(
            u256 {
                low: 94122026130988584712234062661923856033,
                high: 222252053025506709628771573051169984158
            }
        );
    layers_auth_paths_sym_2_3
        .append(
            u256 {
                low: 294577109418722360748185646269723678041,
                high: 267253273818919042922138020594417972128
            }
        );
    layers_auth_paths_sym_2_3
        .append(
            u256 {
                low: 160823391972794652570745180193193033627,
                high: 317797290068453894944819571966820835934
            }
        );
    let mut layers_auth_paths_sym_2_4 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_2_4
        .append(
            u256 {
                low: 293171873101474003601697144293698326872,
                high: 302132735087108881251527574116150576034
            }
        );
    layers_auth_paths_sym_2_4
        .append(
            u256 {
                low: 27896349088288897525831749049057573341,
                high: 250218346047441816725138579158941539915
            }
        );
    layers_auth_paths_sym_2_4
        .append(
            u256 {
                low: 335889472220752588392203455978806603464,
                high: 38117660743914412675630049866241728402
            }
        );
    layers_auth_paths_sym_2_4
        .append(
            u256 {
                low: 309351558938965194903959955563812499176,
                high: 333509483997269176794509660171396725129
            }
        );
    layers_auth_paths_sym_2_4
        .append(
            u256 {
                low: 289544029083401537011775241795359699531,
                high: 327194153644665706885444735622814809556
            }
        );
    layers_auth_paths_sym_2_4
        .append(
            u256 {
                low: 83807366973467871380607186738821016710,
                high: 278444839435223765219780459675870208580
            }
        );
    let mut layers_auth_paths_sym_2_5 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_2_5
        .append(
            u256 {
                low: 128465502810025849770853411959420907567,
                high: 210997357633337866535409184780746074358
            }
        );
    layers_auth_paths_sym_2_5
        .append(
            u256 {
                low: 125013086447258695821493138198410560495,
                high: 254927849628256320740942049165520950563
            }
        );
    layers_auth_paths_sym_2_5
        .append(
            u256 {
                low: 253853412108568620046270310279380430510,
                high: 26207715323632900912500189741393930466
            }
        );
    layers_auth_paths_sym_2_5
        .append(
            u256 {
                low: 49196434510664117196060617014774932503,
                high: 242095771888215333687403209299953283051
            }
        );
    layers_auth_paths_sym_2_5
        .append(
            u256 {
                low: 228245847417283761870414481004685531428,
                high: 140943136689202621901201270160181623281
            }
        );
    let mut layers_auth_paths_sym_2_6 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_2_6
        .append(
            u256 {
                low: 52408814627655990336329197360758810415,
                high: 339443646280028115260712981723240428766
            }
        );
    layers_auth_paths_sym_2_6
        .append(
            u256 {
                low: 61837615703677519045861849480325500823,
                high: 248145258469591921200401058698936798383
            }
        );
    layers_auth_paths_sym_2_6
        .append(
            u256 {
                low: 34850652219020939007425828603363554044,
                high: 101464016638349968833240076228794149446
            }
        );
    layers_auth_paths_sym_2_6
        .append(
            u256 {
                low: 165078416090957814657996838956930728133,
                high: 48779952954251509984159724599570761582
            }
        );
    let mut layers_auth_paths_sym_2_7 = ArrayDefault::<u256>::default();
    layers_auth_paths_sym_2_7
        .append(
            u256 {
                low: 323270130103142226837021840238801503674,
                high: 102421805980942036767216330974748987931
            }
        );
    layers_auth_paths_sym_2_7
        .append(
            u256 {
                low: 317036961960811570359811204409125546400,
                high: 164970616031034127133431921980465430667
            }
        );
    layers_auth_paths_sym_2_7
        .append(
            u256 {
                low: 110083782178434677884302968743125804305,
                high: 90000316738646863924086218928571489800
            }
        );

    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_0);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_1);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_2);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_3);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_4);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_5);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_6);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_7);
    let mut layers_evaluations_sym_2 = ArrayDefault::<felt252>::default();
    layers_evaluations_sym_2
        .append(0x4b93370f443bea9846bd9174bede49624697101fec1c065758d51fcad004bce);
    layers_evaluations_sym_2
        .append(0x5a443a0406843cc676dabe24fab289efb212bcd0d1083d35ce7826aa667f8d5);
    layers_evaluations_sym_2
        .append(0x41ddfb357026e369a6a6b3eeb48641eb71879ce50688e6eb1166cf784246086);
    layers_evaluations_sym_2
        .append(0x7b599bf22a656c785988a610642e51758d8fcf4215b12003abae29a38cbad3e);
    layers_evaluations_sym_2
        .append(0x56027e154c5537bc0dfe0db556c640fed545908a1f56eb818e1d3385169700);
    layers_evaluations_sym_2
        .append(0x2b2269f99a2caa1831928debf2eaf0e1b70e1f44e4b5232f1ace7f94f518f64);
    layers_evaluations_sym_2
        .append(0x41b95071b7d5c70bddbedb3fbdea21243d8a6f2bfdd360bfaf95eb18946c8e1);
    layers_evaluations_sym_2
        .append(0x5c1ca60d39419258f0907a0a338eebc5229ef42b3408f687116769216c70586);

    let mut layers_auth_paths_2 = ArrayDefault::<Array<u256>>::default();
    let mut layers_auth_paths_2_0 = ArrayDefault::<u256>::default();
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 65863557065332996753095985792207652320,
                high: 51600890422906285696925900609620883492
            }
        );
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 15942222060666610314059618085263072713,
                high: 301778505361696160425450973845779691907
            }
        );
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 333951845861422269502181585209058854268,
                high: 88635270779824922219253214216839366006
            }
        );
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 171103898010734299077041577276869335894,
                high: 86431988136954728881238115474726526174
            }
        );
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 269215164340137313951419376114451974734,
                high: 260197181631671378890430279915793255194
            }
        );
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 191276968441953858836778275244625627501,
                high: 57653403722097408471602378413929959690
            }
        );
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 48260166547845666840459788739864799843,
                high: 335587212342209795540941665106744951644
            }
        );
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 281177692179377668111561237578423127815,
                high: 196969228515679364155797001914780771490
            }
        );
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 119771752972243738447005099739249384830,
                high: 210902998146560272646491699003891643200
            }
        );
    layers_auth_paths_2_0
        .append(
            u256 {
                low: 287413520183178317777135645887624208226,
                high: 331496425490372260601024991771599738477
            }
        );
    let mut layers_auth_paths_2_1 = ArrayDefault::<u256>::default();
    layers_auth_paths_2_1
        .append(
            u256 {
                low: 121167499378694011570672522486480759440,
                high: 295324512487797433579030804460047727242
            }
        );
    layers_auth_paths_2_1
        .append(
            u256 {
                low: 167378822235396109086537312166293273634,
                high: 170598417507472802691041139703588532427
            }
        );
    layers_auth_paths_2_1
        .append(
            u256 {
                low: 31721988913909408842898954514647514511,
                high: 201250796002473850770025521481283865346
            }
        );
    layers_auth_paths_2_1
        .append(
            u256 {
                low: 254368150557500809148934256767758909268,
                high: 119249114102477643224997822137190679759
            }
        );
    layers_auth_paths_2_1
        .append(
            u256 {
                low: 219407795368169906343520587063667154612,
                high: 279284989697428345231558272080725281724
            }
        );
    layers_auth_paths_2_1
        .append(
            u256 {
                low: 161626423327994674928346225898303435068,
                high: 53022273679558994906548039817369599094
            }
        );
    layers_auth_paths_2_1
        .append(
            u256 {
                low: 217394260214668435652757851740795281162,
                high: 337410062618171048233857839143487692529
            }
        );
    layers_auth_paths_2_1
        .append(
            u256 {
                low: 265395950470209665144406967824313046138,
                high: 314783789504197782263220423178063033119
            }
        );
    layers_auth_paths_2_1
        .append(
            u256 {
                low: 156107435889997327808399678620525069992,
                high: 337189103180430242969139377630750491113
            }
        );
    let mut layers_auth_paths_2_2 = ArrayDefault::<u256>::default();
    layers_auth_paths_2_2
        .append(
            u256 {
                low: 81385077599138701036659274229792665813,
                high: 6107074363382841159937331140458251085
            }
        );
    layers_auth_paths_2_2
        .append(
            u256 {
                low: 261489544417790124177847124354267805905,
                high: 61614049659565151050422043792608000826
            }
        );
    layers_auth_paths_2_2
        .append(
            u256 {
                low: 165742949938532299479483226457398556513,
                high: 190278949923289669837359514662010975869
            }
        );
    layers_auth_paths_2_2
        .append(
            u256 {
                low: 31559343356777455454159063252582212560,
                high: 21473449130507583398620936073849978957
            }
        );
    layers_auth_paths_2_2
        .append(
            u256 {
                low: 157661799023488968832477666244515349674,
                high: 263774000615685231929356796283149532166
            }
        );
    layers_auth_paths_2_2
        .append(
            u256 {
                low: 238005225195584203283377238315541740338,
                high: 292994531977412743324524470989619904926
            }
        );
    layers_auth_paths_2_2
        .append(
            u256 {
                low: 22221127419412047016286660954003212580,
                high: 20858655967067623060621205047478416397
            }
        );
    layers_auth_paths_2_2
        .append(
            u256 {
                low: 99179036659774354842096222796057668201,
                high: 116515794677859955514361202081784773234
            }
        );
    let mut layers_auth_paths_2_3 = ArrayDefault::<u256>::default();
    layers_auth_paths_2_3
        .append(
            u256 {
                low: 230313153151889662013437030520506396217,
                high: 243027172064218406998420528019932433117
            }
        );
    layers_auth_paths_2_3
        .append(
            u256 {
                low: 270843851091949801175775338166777823642,
                high: 313853000837449247154727094245077571051
            }
        );
    layers_auth_paths_2_3
        .append(
            u256 {
                low: 24050273909709472514410116300755357580,
                high: 242066326847918813006659509791634811701
            }
        );
    layers_auth_paths_2_3
        .append(
            u256 {
                low: 160531812154595860466566423376259860607,
                high: 69120451688641625292387138165124536431
            }
        );
    layers_auth_paths_2_3
        .append(
            u256 {
                low: 29774224862488118200603209730850658977,
                high: 293737291229543170127069246836567404607
            }
        );
    layers_auth_paths_2_3
        .append(
            u256 {
                low: 116889397007894908277364218584678928888,
                high: 292885342018104122321860469006658194859
            }
        );
    layers_auth_paths_2_3
        .append(
            u256 {
                low: 132004417065944158262759950088273194550,
                high: 117542597907677031594803928870487949326
            }
        );
    let mut layers_auth_paths_2_4 = ArrayDefault::<u256>::default();
    layers_auth_paths_2_4
        .append(
            u256 {
                low: 110142266068709640970381288902164207864,
                high: 9383685377898881527728642222346810209
            }
        );
    layers_auth_paths_2_4
        .append(
            u256 {
                low: 169228479702151149383481305300500110695,
                high: 192654604342903774162341266199882162590
            }
        );
    layers_auth_paths_2_4
        .append(
            u256 {
                low: 170245610554037038649601321008547303491,
                high: 332748406861545380785932669479256442662
            }
        );
    layers_auth_paths_2_4
        .append(
            u256 {
                low: 191115320409313052383500772376418454316,
                high: 112339783181971616273587109245689059991
            }
        );
    layers_auth_paths_2_4
        .append(
            u256 {
                low: 137702482037135060822535771300878524246,
                high: 337424612760316108782939245134901052428
            }
        );
    layers_auth_paths_2_4
        .append(
            u256 {
                low: 45705404148533291620111678777204003710,
                high: 33034682838256325486536211038035399696
            }
        );
    let mut layers_auth_paths_2_5 = ArrayDefault::<u256>::default();
    layers_auth_paths_2_5
        .append(
            u256 {
                low: 165488884149631852862338534082323051975,
                high: 194052830808749844792880240733986860170
            }
        );
    layers_auth_paths_2_5
        .append(
            u256 {
                low: 198578032739535377625391053548895985399,
                high: 203934110680608252377188192500786646157
            }
        );
    layers_auth_paths_2_5
        .append(
            u256 {
                low: 208055107560311307257023471837373699681,
                high: 165052500675577063563479673294833051062
            }
        );
    layers_auth_paths_2_5
        .append(
            u256 {
                low: 164142427247052558373324764565351784214,
                high: 234204021883364125033695894647335803787
            }
        );
    layers_auth_paths_2_5
        .append(
            u256 {
                low: 289415171726221612463310997637235358079,
                high: 334639251267131551826472078786779035435
            }
        );
    let mut layers_auth_paths_2_6 = ArrayDefault::<u256>::default();
    layers_auth_paths_2_6
        .append(
            u256 {
                low: 11348910636811919021611909015861385128,
                high: 96759112603360386242367604550197805273
            }
        );
    layers_auth_paths_2_6
        .append(
            u256 {
                low: 123058011022560734544974502296961070400,
                high: 80163405304681790236426766307392523823
            }
        );
    layers_auth_paths_2_6
        .append(
            u256 {
                low: 114361401917513213130806253386415487430,
                high: 333888436753491099429433488360832052187
            }
        );
    layers_auth_paths_2_6
        .append(
            u256 {
                low: 328342918320856762977801565857141253240,
                high: 278762061327697326664270612392826830156
            }
        );
    let mut layers_auth_paths_2_7 = ArrayDefault::<u256>::default();
    layers_auth_paths_2_7
        .append(
            u256 {
                low: 47514489998597771299286761741355184051,
                high: 61740926130458368730589785962115077478
            }
        );
    layers_auth_paths_2_7
        .append(
            u256 {
                low: 288085230283027516453074167189285595794,
                high: 41879712669678782392208329462231176577
            }
        );
    layers_auth_paths_2_7
        .append(
            u256 {
                low: 166994159928196044442312366406028910249,
                high: 223237937838162716452599516456343849407
            }
        );

    layers_auth_paths_2.append(layers_auth_paths_2_0);
    layers_auth_paths_2.append(layers_auth_paths_2_1);
    layers_auth_paths_2.append(layers_auth_paths_2_2);
    layers_auth_paths_2.append(layers_auth_paths_2_3);
    layers_auth_paths_2.append(layers_auth_paths_2_4);
    layers_auth_paths_2.append(layers_auth_paths_2_5);
    layers_auth_paths_2.append(layers_auth_paths_2_6);
    layers_auth_paths_2.append(layers_auth_paths_2_7);
    let mut layers_evaluations_2 = ArrayDefault::<felt252>::default();
    layers_evaluations_2.append(0x18b1ed359024862fae8c5163cdcb08ebbbf89d2153c6f13df29875056fee626);
    layers_evaluations_2.append(0x3c3587bbd4d86bea3213b7e3020b5b9a880a220785e836169506c9ff8c4329);
    layers_evaluations_2.append(0x9e291d3313902e59fd7f02fb7fd3c73e42c68e83cc4fc7442489f1c4b73eda);
    layers_evaluations_2.append(0x20c8dcbb298e5082cd3e70692339f0e0a38a3adc3d5443224b39178742262a7);
    layers_evaluations_2.append(0x52315fbfa54cbce6eb3d562942a221eefc63fa805c7ad6c15880cdc8e8221ff);
    layers_evaluations_2.append(0x48c5f803302130705c2dda9b277fda5df5ad7a4e845b762afd6cd811feaa32d);
    layers_evaluations_2.append(0xd7f3f7af045440bb50940cee0fffba5bc7d2e722f63fe5416735a2a4f85297);
    layers_evaluations_2.append(0x5845c88cdb2e26f2ab47b3a6ec508d29afa6470dcdd47c40986d9485198d);

    let fri_decommitment_2 = FriDecommitment {
        layers_auth_paths_sym: layers_auth_paths_sym_2,
        layers_evaluations_sym: layers_evaluations_sym_2,
        layers_auth_paths: layers_auth_paths_2,
        layers_evaluations: layers_evaluations_2,
    };
    query_list.append(fri_decommitment_2);
    let mut deep_poly_openings = ArrayDefault::<DeepPolynomialOpening>::default();
    let mut lde_composition_poly_proof_0 = ArrayDefault::<u256>::default();
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 285649241261589436545127127523371902801,
                high: 112444832814062715941069989575077925404
            }
        );
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 156316716583054213591798112829163989331,
                high: 174474819662742898028362458607542526120
            }
        );
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 213539610672701374211766062309585915120,
                high: 314627782345524464624155609454044498147
            }
        );
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 301377079661297164622701830256497654516,
                high: 185837839368304840089686737803674703574
            }
        );
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 12613427431708405108978291984511825058,
                high: 320548687998215593276758518032814519781
            }
        );
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 298886593891858671641709589649936318555,
                high: 212489580986344824269127683392099792242
            }
        );
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 67576889910510819580859162347508601023,
                high: 213876856726722892195888740850434148891
            }
        );
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 163940126929161031835982112643660371541,
                high: 338328438566214897661924448977204543112
            }
        );
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 66642723227253927428495451462293525082,
                high: 295232264218864911555861303323001813404
            }
        );
    lde_composition_poly_proof_0
        .append(
            u256 {
                low: 87435816330346738842951431082121753254,
                high: 312603162713872844830471539794703099760
            }
        );
    let lde_composition_poly_even_evaluation_0 =
        0x1966c79bba477abb8f88ea7ebe9290a4ead06d938499fa8d4028f24b3617180;
    let lde_composition_poly_odd_evaluation_0 =
        0x147999956c20e499e9e6658d60d4f2daa04c4bd01f0b36a651eae40d7e71a54;

    let mut lde_trace_merkle_proofs_0 = ArrayDefault::<Array<u256>>::default();
    let mut lde_trace_merkle_proofs_0_0 = ArrayDefault::<u256>::default();
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 49343015563398757342642519633601865884,
                high: 273534292692704455734746763238174993989
            }
        );
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 206504888945566879680259985965963268928,
                high: 13700961224795856834631128342016427539
            }
        );
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 101495210234480237428976623666397430726,
                high: 138930466493953715027032566601969870441
            }
        );
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 51526645782243900716463592327514540177,
                high: 2919143958292573881332440294696073939
            }
        );
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 300982793712038891812695501493111370529,
                high: 213107408521504748594113754906976122709
            }
        );
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 208166160725628917578625157028218024819,
                high: 262306185268216761443281300342513150576
            }
        );
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 19806608586497851510168815429747052309,
                high: 339524252181070942253448992768260505952
            }
        );
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 163415563213469020072524588866251966172,
                high: 324807715067720323463054427886844192238
            }
        );
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 109390924622568793827473218528659038683,
                high: 127157106212003215089216227508752207662
            }
        );
    lde_trace_merkle_proofs_0_0
        .append(
            u256 {
                low: 208459835364953149826526387251613187249,
                high: 285745587152506486862315843202392205048
            }
        );

    lde_trace_merkle_proofs_0.append(lde_trace_merkle_proofs_0_0);
    let mut lde_trace_merkle_proofs_0_1 = ArrayDefault::<u256>::default();
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 164615390282386896344811433509462789849,
                high: 187237607045315902120941239810613424616
            }
        );
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 153488717033288943716079673144694869371,
                high: 274489367852990260896209330044534302404
            }
        );
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 274661919666573057098011011599290941846,
                high: 318498863254534367408726871978947385257
            }
        );
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 316818032159974955386559367229914739932,
                high: 270186211607025919976700319608195205867
            }
        );
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 105646712881570394516194506338621662115,
                high: 214636120402751385572537280922223794312
            }
        );
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 331770753660268342713324777312680333327,
                high: 7013189265938396642892335787301258719
            }
        );
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 249930218045770111338656385168051675804,
                high: 248763539191584035675683995578966981535
            }
        );
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 250184823568102569722740390443463924591,
                high: 245617699465521339075229906728868761728
            }
        );
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 67834388747622315903349142666137251795,
                high: 97670926350164008276108120126874114737
            }
        );
    lde_trace_merkle_proofs_0_1
        .append(
            u256 {
                low: 256556173767860593654392767574299922965,
                high: 137887995771497026660527180525104757273
            }
        );

    lde_trace_merkle_proofs_0.append(lde_trace_merkle_proofs_0_1);
    let mut lde_trace_evaluations_0 = ArrayDefault::<felt252>::default();
    lde_trace_evaluations_0
        .append(0x44e716fc2160f943147420cc85c2e6bd5b98cdf54d69092de08982d81ae6d30);
    lde_trace_evaluations_0
        .append(0x4c120c486b100f3454e75bb852d7b1e7beb4584412e72574f721afa12de3d7);
    lde_trace_evaluations_0
        .append(0x71f8fd8f0924fe295de98cb4711d78a6129198e2939202657cf6b6b352152f7);
    lde_trace_evaluations_0
        .append(0x2418e7cbc22277fa59d4a308ac7e42e3fe5f23d6a1155820c88f01d64b703df);
    lde_trace_evaluations_0
        .append(0x3cdbf420a1b48591c5e511d30030ac53b5757e446c1d024733d8a56c2d85521);
    lde_trace_evaluations_0
        .append(0x713fe00f5101c61a8d8522070931c0fe3632da767eed7ea29d8239c9075ddc9);
    lde_trace_evaluations_0
        .append(0x767b618231e7feb75a0216cff9841de50a06b34c27721b00f19e47417a87fb9);
    lde_trace_evaluations_0
        .append(0x31dd0f4dac2e32eab0c998ab5078d98e4cebaa31d0f038a2a37502f61875a36);
    lde_trace_evaluations_0
        .append(0x18ee1fa3e8a5c4599cc91c7321038d78a953cf455e4337ebe3ee72f27115d2b);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0
        .append(0x3b6bd1996a88958b745644becd7c72f3685146a96bafe04f4fc9d7bbee7e03c);
    lde_trace_evaluations_0
        .append(0x18ee1fa3e8a5c4599cc91c7321038d78a953cf455e4337ebe3ee72f27115d2b);
    lde_trace_evaluations_0
        .append(0x31dd0f4dac2e32eab0c998ab5078d98e4cebaa31d0f038a2a37502f61875a36);
    lde_trace_evaluations_0
        .append(0x491c512238a483bc51b773305d64df718fc960dcd5ef22120524e5c04232073);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0
        .append(0x737c873d04d814844cc2a08c0010a615aec0f761165441a9778e3082ec2013e);
    lde_trace_evaluations_0
        .append(0x2ac9fae0a9488d7801efd92ddb71e5b0922fdb7b4ea80eb6004420079ebf243);
    lde_trace_evaluations_0
        .append(0x3d9346ebf3349e56299a01afa0b15559fad93aa0dc16ec5cebc256a649824ea);
    lde_trace_evaluations_0
        .append(0x21e10feccb7de654b4bf3d61532253bc5e214c222de7fb8261b09d3059071a0);
    lde_trace_evaluations_0
        .append(0x109eaf134f93ac21b3c00bc0117d0959cfa217412275ca5fd834e2b82873be2);
    lde_trace_evaluations_0
        .append(0x7b0c2aacbb5bd694b0d88575ef95b70d7f574cd0b6158988471eb2e7f72c992);
    lde_trace_evaluations_0
        .append(0x3c874154401db4b732d4f50475889042e0df4ab277d53c040096d8e682fb00a);
    lde_trace_evaluations_0
        .append(0x6fa498dda6f468f9742a677dd7c80ee4db84b962cd51673b66a7bda1d3bbda7);
    lde_trace_evaluations_0
        .append(0x7336ad9f3cbde1641ce6d4d8aacec2bd05e6fb76d9465a6e6364d082f72429a);
    lde_trace_evaluations_0
        .append(0x74b80fab4f45911f5ab99b6c3b92c245a90f61ba275f931d3f5dda876e4f01b);
    lde_trace_evaluations_0
        .append(0x6bccd7eddb57d227782f856a3e8e1d0771d3bee92072da755df5efac3518c94);
    lde_trace_evaluations_0
        .append(0x4a88165b913bbeb195a2c2df292c70f587018e564f51b261b0cdcf6291a6f56);
    lde_trace_evaluations_0
        .append(0x5b5a7c1a3547e36f0dc1017fc7ccdccdfee52931e259d6c7c044727e0798594);
    lde_trace_evaluations_0
        .append(0x11c517d2f93850d0728f45e8f16e7f409a845731e9ebec2ec3c92ec59652ac9);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0
        .append(0x440a352fc205096b6f55c3bcb688297b11b770c92a464f3a972bae850d6a12d);
    lde_trace_evaluations_0
        .append(0x46bbfe63f3e9f78e1dd0f6fb42f78b39d32da2d67c78f6faabcd6730687506b);
    lde_trace_evaluations_0
        .append(0x2625bdb1388215a48362fd1a032d1423c1ac7cefcf043e565c3908941c60097);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0.append(0x0);
    lde_trace_evaluations_0
        .append(0x2625bdb1388215a48362fd1a032d1423c1ac7cefcf043e565c3908941c60097);
    lde_trace_evaluations_0
        .append(0xd7ca79fe778949b06a6ee4ab00545d96bb8249e6e550bad320c2aea083ed8c);
    lde_trace_evaluations_0
        .append(0x6b67273fb95f4a06c900099e03bda694838101d0b982b96a61ad4d31c7b7292);
    lde_trace_evaluations_0
        .append(0x505e4012ad9e9b7d5c66ffd0047989321f94cf17543316a2ba71557c6a5c5e7);
    lde_trace_evaluations_0
        .append(0x2d83c2ff5a127068c681d97c93dd1b6686f37e65a2ae1469587c2fa09a9c10b);
    lde_trace_evaluations_0
        .append(0x70938d6e5c6590c1f5f9b68127b4eb5d5bf8732513bdce12f09ad8390593f70);
    lde_trace_evaluations_0
        .append(0x5930a8653e1b6d32799672111a3b69e3c4d882a46e7cb1403bcbbd76f205b9d);
    lde_trace_evaluations_0
        .append(0x31fe079246a4b282ed203f83023b9ad4081c5c794e017714b4afc2ef3845a80);
    lde_trace_evaluations_0
        .append(0x65702007227117fc91302de3d55edc1712638374a89414d277810e19050363a);
    lde_trace_evaluations_0
        .append(0x193318b885a95b69ed27a8d4c382c20b9671ba91c3d670b98ada35ba007f4c1);
    lde_trace_evaluations_0
        .append(0x58e81ae691fc3f3bc216b71da7f372aec722db57dcb4d33c156b789f51af7b0);
    lde_trace_evaluations_0
        .append(0x61a45a78409baa170db63291ebf64816a2187f0b4177ef1b9d0b99f4f247c99);
    lde_trace_evaluations_0
        .append(0x5fb48dcb33ef64e7ca90c8c996d188ab19cd95c594f9d5c2b377183c38b2d20);
    lde_trace_evaluations_0
        .append(0x5024ffb9a5e5eafb3089ac3dab0a32063c2250f639da0b117d99d1c6bcef721);
    lde_trace_evaluations_0
        .append(0x3c996160905051c4280618b6c5badd7f7e941f6e32a2103e118c2ec712e4df5);
    lde_trace_evaluations_0
        .append(0x62de5986482d4f9afd70b10e04834e522ea00498a533188dd1524c210f1f504);
    lde_trace_evaluations_0
        .append(0x3be5c379c6c1a076500d74c9c84d3c8962ca327ef12ce3ea97b4c2413fe5f8e);
    lde_trace_evaluations_0
        .append(0x39af9c84ba341a6aa90b4045d1fc6b1630ebc1345494f94449b71c928fe4be5);
    lde_trace_evaluations_0
        .append(0x3f6133c429761f7e08eb49c1703854a19d491f2062a5c94325bb6608ad08faa);

    let deep_poly_opening_0 = DeepPolynomialOpening {
        lde_composition_poly_proof: lde_composition_poly_proof_0,
        lde_composition_poly_even_evaluation: lde_composition_poly_even_evaluation_0,
        lde_composition_poly_odd_evaluation: lde_composition_poly_odd_evaluation_0,
        lde_trace_merkle_proofs: lde_trace_merkle_proofs_0,
        lde_trace_evaluations: lde_trace_evaluations_0,
    };

    deep_poly_openings.append(deep_poly_opening_0);
    let mut lde_composition_poly_proof_1 = ArrayDefault::<u256>::default();
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 258800727072408281038182490293169355461,
                high: 272847134322908805965419219433747406806
            }
        );
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 80858360537888284706993551238779620964,
                high: 336111390895267490021404589125242129186
            }
        );
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 186028038969011654701672071520985057413,
                high: 135420310615613647315580607752875929800
            }
        );
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 201468519163829916732153173265877026569,
                high: 789702596115249355677845397243492413
            }
        );
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 195622555663744848919867416310016108383,
                high: 337226905897090497992673476934234403642
            }
        );
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 48065302068391432033263734573208659828,
                high: 57259794730047401796627939434604282168
            }
        );
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 186516454869023353127355902697047852985,
                high: 292788910046059756747089664150041496694
            }
        );
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 13393401216493537477880506329590217191,
                high: 310998304204430158816079081749165993428
            }
        );
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 23382061188495446682213456229702966569,
                high: 35861801649347364320502619569397769035
            }
        );
    lde_composition_poly_proof_1
        .append(
            u256 {
                low: 87435816330346738842951431082121753254,
                high: 312603162713872844830471539794703099760
            }
        );
    let lde_composition_poly_even_evaluation_1 =
        0x3ceaabafbbd0988854648e675976eafa3b791da5647451de4006026b032211a;
    let lde_composition_poly_odd_evaluation_1 =
        0x3f868701964545530a50da8871a9dd613f09c62b9b5c0bdfdab901e9915c683;

    let mut lde_trace_merkle_proofs_1 = ArrayDefault::<Array<u256>>::default();
    let mut lde_trace_merkle_proofs_1_0 = ArrayDefault::<u256>::default();
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 294580975881656863046735947289179103643,
                high: 55124434719169555412144144980235273527
            }
        );
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 309411795921652774421147257792986183206,
                high: 196024430583804388879962839026566122354
            }
        );
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 321297022985671163015140209604066810730,
                high: 121291635939475780094829185639343898991
            }
        );
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 334706466244097258548298741950515806191,
                high: 45794703559193579082307342983669300780
            }
        );
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 203788044406085521273376778597555969587,
                high: 198557340724226585117938208857519486297
            }
        );
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 39283496606656432518775735752029140712,
                high: 242959249762647647098213194699014095389
            }
        );
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 73569587055486145206946653402692615629,
                high: 71420501210390571313060868491442162163
            }
        );
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 63351295368309100093266045684468728770,
                high: 79227371830500149562078930524482421088
            }
        );
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 279953710000550660353627716055252054973,
                high: 17156612035431549274266270420440907446
            }
        );
    lde_trace_merkle_proofs_1_0
        .append(
            u256 {
                low: 208459835364953149826526387251613187249,
                high: 285745587152506486862315843202392205048
            }
        );

    lde_trace_merkle_proofs_1.append(lde_trace_merkle_proofs_1_0);
    let mut lde_trace_merkle_proofs_1_1 = ArrayDefault::<u256>::default();
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 110427704384814699782250435029888241982,
                high: 212660716498134781458130689973896959230
            }
        );
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 200424198584199676264087691388187306729,
                high: 55473272480871767877040873461375740509
            }
        );
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 155649994344064924065525325847083747965,
                high: 88413910166715525112736352928700282266
            }
        );
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 314999781142133585542389520401544846886,
                high: 45226220847468891494065316906768279193
            }
        );
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 257233681148504919666074770249175862084,
                high: 228459763459349316101491957398482733856
            }
        );
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 333718437193300840130979962465953286950,
                high: 188969518683187979879080359315791848538
            }
        );
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 260251755670717317162732379054500499354,
                high: 127332454673471020059206337278720092227
            }
        );
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 26503134610422562837290317731434089639,
                high: 337679854516155582653902947078701571967
            }
        );
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 93426551633246203190140553236812075192,
                high: 13336328330998204195418603605564495692
            }
        );
    lde_trace_merkle_proofs_1_1
        .append(
            u256 {
                low: 256556173767860593654392767574299922965,
                high: 137887995771497026660527180525104757273
            }
        );

    lde_trace_merkle_proofs_1.append(lde_trace_merkle_proofs_1_1);
    let mut lde_trace_evaluations_1 = ArrayDefault::<felt252>::default();
    lde_trace_evaluations_1
        .append(0x534f925c991a6548e309933b49394af192c43813888b4a6d985c37f1890e1a8);
    lde_trace_evaluations_1
        .append(0x48b49b71163da589133fa1f55571706ea8eadb960ea110043920e7d81a38e07);
    lde_trace_evaluations_1
        .append(0x159b9ecea682efc79ea71728404ef16921c94a9ca6ae3cb40582333be22547b);
    lde_trace_evaluations_1
        .append(0x418f6e47ce00347db38f93999d5989f439da7bc106f8a51ed2c7770f95cdae);
    lde_trace_evaluations_1
        .append(0x720211f58d32900b40a8a5537491d8f61784b160154afb2fa99d15cc3efee6e);
    lde_trace_evaluations_1
        .append(0x52ec16dce05f8b0920070fe257494d6acfe0c96ed7daa77512a6dad5d68e906);
    lde_trace_evaluations_1
        .append(0xfad4888f3bd0884b6300af4e459c8dee603a0a836b5df590daca83c0f06fe3);
    lde_trace_evaluations_1
        .append(0x5f2f023a4afab0f9837466e573e2a3bc50ffd90d767d47472a11a5651a5dbf4);
    lde_trace_evaluations_1
        .append(0x14b37277220217a07e27290dedf5077adb5520ff4e1785b5338ca8d2ef4363);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1
        .append(0x438128fc180b385a094a7d72e8805b4cf056b2fdbe4423a1ed97bd136147bd9);
    lde_trace_evaluations_1
        .append(0x14b37277220217a07e27290dedf5077adb5520ff4e1785b5338ca8d2ef4363);
    lde_trace_evaluations_1
        .append(0x5f2f023a4afab0f9837466e573e2a3bc50ffd90d767d47472a11a5651a5dbf4);
    lde_trace_evaluations_1
        .append(0x422a86f52917e7a4259677f1f0776ae24e6b6239f0cf3e02dfd86c50470f060);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1
        .append(0x2b5e2ac53f6bbd8aa86d6917c2dba1781405316aecb41ff9c2696bd5d9b3c1e);
    lde_trace_evaluations_1
        .append(0x2f29d3a7157922e4bebaf49d8e9ed96d0b97e6ff7d40069591e5fe25c9672b8);
    lde_trace_evaluations_1
        .append(0x599ba33f8ec308a92e4f9affad73bfa5ecc1ae4fcd5504026bf38994f91ac37);
    lde_trace_evaluations_1
        .append(0x1b0940b6b83a5660ac35d2e01f74376ca30d2d7642caf2886baf5cd095b7bb2);
    lde_trace_evaluations_1
        .append(0x221d33535905ff8a478cb0683479a21ad7abec48a954cfb4686bdf1a9d64c02);
    lde_trace_evaluations_1
        .append(0x192d80b7c904a7dab703a4894d94166a635b884dfdacc1181382ff8de4a3580);
    lde_trace_evaluations_1
        .append(0x7907d46958f0d667f0900cb6a16023dc5ec1b5f6fac03894dd934df2fa34aab);
    lde_trace_evaluations_1
        .append(0x26a9841a53e1e5969af983871ee4bcabd7d7aa211d6f495f381987bb73044b3);
    lde_trace_evaluations_1
        .append(0x4e8cf345b452cb901ce19843edaa2743ea62891a70d6c5cd4c38dae140b0d12);
    lde_trace_evaluations_1
        .append(0xb2d0b0a9bb540687d015f0b579f8a8f733260400920990ce14c8872fcd2d1a);
    lde_trace_evaluations_1
        .append(0x44710f900269b9e6ad9cc6d687e758aa5f7a4d85f7e1b58e69ea338a31c2ea0);
    lde_trace_evaluations_1
        .append(0x7ad7b76d2dbbf61226f9fdfc2a33fdcb8e525000e4c524f8d45abd8c798a10b);
    lde_trace_evaluations_1
        .append(0x2a438713b392fa4f695ec822abaa76102098942b5498026de6e2f09fbc5db6d);
    lde_trace_evaluations_1
        .append(0x3dbb75a029ddeaf16d3482a53f7709b2f6f2b8f58db89a024e8368ed26f4482);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1
        .append(0x6abed7fbeb6f4338b5afe225e1618ff9de71d03ee45c3f6b8af4b4bfec8ecc5);
    lde_trace_evaluations_1
        .append(0x745c8424556674c5108a11a866e0e9846cb531a4b1e5a9fd9b833d6e6917354);
    lde_trace_evaluations_1
        .append(0x4b4afcb81afa51e051e06981c55706d62fd94d8ea445e13e713e972d7254851);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1.append(0x0);
    lde_trace_evaluations_1
        .append(0x4b4afcb81afa51e051e06981c55706d62fd94d8ea445e13e713e972d7254851);
    lde_trace_evaluations_1
        .append(0x5caf438ef7d0817a94f3b398c22ae361235a5a00de5c9719c58a34aaaf809de);
    lde_trace_evaluations_1
        .append(0x3a9cec5c0a9e7a3ffa1584e034aa2dba6e7753926408d8e4093d82e1dc618dd);
    lde_trace_evaluations_1
        .append(0x47ec9d2447ae561d1c29f1a50ea6d66f36b2d9d1ff5fb160ba4774e5acb603d);
    lde_trace_evaluations_1
        .append(0x3b1576e0a75bb82e13087c86df8e27c7562dab7dd81041eff00e2f2c81dc741);
    lde_trace_evaluations_1
        .append(0x5960064280dd0155ef318a8340d05779721aa60e2c394fed5e26c653d46cf96);
    lde_trace_evaluations_1
        .append(0x3199900b8a8b3302627427110b10b990fa89155e0cd7349a9450090f8546efc);
    lde_trace_evaluations_1
        .append(0x43098a60e15d29ec8650a8100c61578f3fc0aaa7147a5faa3ecdde51ac432c5);
    lde_trace_evaluations_1
        .append(0x6703926b7ece2b1407a423acbb246235ff1d0a30f65c7a560f72ca00639589d);
    lde_trace_evaluations_1
        .append(0x1a3eb885e2207622da2167c433b7ab75f9867fb34398a0a1d02682ed9dfdb49);
    lde_trace_evaluations_1
        .append(0x293ee27689470db72b77cff8ecbfc06e79db48cf2971bc806857218fd7aefa1);
    lde_trace_evaluations_1
        .append(0x30ade9408b759a7b02fddf378fe644f297825c83a072451d45196b0bce4586b);
    lde_trace_evaluations_1
        .append(0x593dc650d7610a5178a6e1dde2153a17f5b53f62d31c0ca5ccfb360c0592b1d);
    lde_trace_evaluations_1
        .append(0x55fc86a972713d33303a8393b91cce9dffb9670aecd23a7cc5224c61a66297a);
    lde_trace_evaluations_1
        .append(0x358aaaec2c45978f88439a8e6b3eadb401942f0d9555d30f94f20219d08ccf2);
    lde_trace_evaluations_1
        .append(0xdbab24d89176911d099b51ce4715bda82b3b3a2951e38892ee9543ee470cd9);
    lde_trace_evaluations_1
        .append(0x7a5236bfa8da7319af42e22afc4f5979c083e68af83742f79fa768c37ceed68);
    lde_trace_evaluations_1
        .append(0x5395c6d74e00b7ebb88f6871759e85332e0c872aea491e43df591e4a687b461);
    lde_trace_evaluations_1
        .append(0x4997e7f20d4d33d8458b670d2b964c21350dfdf573ee266fe5450ef038662a2);

    let deep_poly_opening_1 = DeepPolynomialOpening {
        lde_composition_poly_proof: lde_composition_poly_proof_1,
        lde_composition_poly_even_evaluation: lde_composition_poly_even_evaluation_1,
        lde_composition_poly_odd_evaluation: lde_composition_poly_odd_evaluation_1,
        lde_trace_merkle_proofs: lde_trace_merkle_proofs_1,
        lde_trace_evaluations: lde_trace_evaluations_1,
    };

    deep_poly_openings.append(deep_poly_opening_1);
    let mut lde_composition_poly_proof_2 = ArrayDefault::<u256>::default();
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 293741514647772819097812622163243055406,
                high: 33324396459642957036102374690900047138
            }
        );
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 312901012000973822803866028722499336461,
                high: 123590143885798659279536537703117009306
            }
        );
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 270660300208270864698535290726394783117,
                high: 322600840857762793617893835173180651619
            }
        );
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 228998800138418444580897025278422453587,
                high: 194338336551800040604743372319881187547
            }
        );
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 164691054608760378448922428745333482057,
                high: 88158042132468728902467396881678252937
            }
        );
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 177934811210338429378717070999862469627,
                high: 69687287753899993677697484893301727263
            }
        );
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 264106803443005075387887181384544968051,
                high: 238267739128178700058677880703717589313
            }
        );
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 57218401069577225491828330111627019500,
                high: 326110049829750375511240776742002396241
            }
        );
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 49462482668476392460925149210547151065,
                high: 58195632955978509634595884932330861055
            }
        );
    lde_composition_poly_proof_2
        .append(
            u256 {
                low: 251192587074098277153185733669175806177,
                high: 68518053939596070958558458841401646847
            }
        );
    let lde_composition_poly_even_evaluation_2 =
        0x4dea046a671d1b2985cc1fdc2cb3d9813fe147ddee87d9b129ddfc70f2a2001;
    let lde_composition_poly_odd_evaluation_2 =
        0x64839aa9be88b387e692f77eaff56f05155b87d1bb09b55df489458dcafdb65;

    let mut lde_trace_merkle_proofs_2 = ArrayDefault::<Array<u256>>::default();
    let mut lde_trace_merkle_proofs_2_0 = ArrayDefault::<u256>::default();
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 63442256017316696586024221453351288665,
                high: 105819701409270235884844879598493220652
            }
        );
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 334905658816444650235488149768591568571,
                high: 134741223880564992344757149982440060139
            }
        );
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 243388394993767688600894689301406946229,
                high: 9012192937401074905874668419885036339
            }
        );
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 133596312434796217962450255553076877058,
                high: 290357203792319787381782421397662337372
            }
        );
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 333686423794119426123008814622804127963,
                high: 128123175477473230470850716982017918808
            }
        );
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 74639931621690340631720086141479586290,
                high: 94588339114316852881450128723914038931
            }
        );
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 205019940399281452356846077944153910668,
                high: 160448705591836521002842084776256036422
            }
        );
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 164993301147486537185900971889922335207,
                high: 114124764154616201535535465863622592923
            }
        );
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 82493355805092275452363836240570343519,
                high: 76467127538302756752522126075221488781
            }
        );
    lde_trace_merkle_proofs_2_0
        .append(
            u256 {
                low: 300061163460130047323780510638983196204,
                high: 225491387196298162616573433653429058670
            }
        );

    lde_trace_merkle_proofs_2.append(lde_trace_merkle_proofs_2_0);
    let mut lde_trace_merkle_proofs_2_1 = ArrayDefault::<u256>::default();
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 27962256173837181073266973977372086323,
                high: 248044683193943252131262332289759047892
            }
        );
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 174148455615662491627245736931137104484,
                high: 188242383958674283929850759284014072208
            }
        );
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 14600476215417075956388121020965021409,
                high: 80497540707656780094256335098528190892
            }
        );
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 331799555513123850496763982834442781968,
                high: 281199849141705201314614777194808372195
            }
        );
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 197578403117872228086814064813609659983,
                high: 166940751887877400255005214184811496451
            }
        );
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 256679739090895129004100532250402423419,
                high: 30184552393483377207510638200332399306
            }
        );
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 49723416027486759593614080648345690716,
                high: 85552848628635261562144370697407696070
            }
        );
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 114667173862090728435176959616085305846,
                high: 145756865119453090064323891980381098928
            }
        );
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 150489257383939984495940161615055896743,
                high: 325146153883231427640372548537179021993
            }
        );
    lde_trace_merkle_proofs_2_1
        .append(
            u256 {
                low: 40888374539203920816318608278097514992,
                high: 122690965418676749383260567562573162865
            }
        );

    lde_trace_merkle_proofs_2.append(lde_trace_merkle_proofs_2_1);
    let mut lde_trace_evaluations_2 = ArrayDefault::<felt252>::default();
    lde_trace_evaluations_2
        .append(0x25b698e86ce75046e2cae218fc42bab47b7b77e9e67c6156aaf52a767925d86);
    lde_trace_evaluations_2
        .append(0x4d60f71504f32cd6650ccd35ad56d004ad9bbad08cad03a885faa3dee83dc9e);
    lde_trace_evaluations_2
        .append(0x7c547394fbf0083066c5c396a0faabc42f624acabdaa5d9b66fd4518df96106);
    lde_trace_evaluations_2
        .append(0x5f97920f09a90820c76f235d3d66a64037572b7a6e15da81069d77543a3c58b);
    lde_trace_evaluations_2
        .append(0x77019234e8d4cf36ae706a1ca6f7b14590e703dd18a94edcfdf01be446655b4);
    lde_trace_evaluations_2
        .append(0x296c5b7d750a2cae9785d8fd0282f5142cd06e4ef8db443bb02944685edada9);
    lde_trace_evaluations_2
        .append(0x18ccbdbada6cc8def9710e4e32f993aa5e9ca03b2a0863ee392685500403f4);
    lde_trace_evaluations_2
        .append(0x108e14baa48d01781cdc2b721af23af708a6dd5e84a17ec0213ea9532b3de22);
    lde_trace_evaluations_2
        .append(0x3f83a7441a21f17a06dbfd0ea35f8b0f4a5d44d05180e52bc362107e2653440);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2
        .append(0x4e04b771df77b056c42baa6409637aac07e7243a5a3cfe2c6d884d3228f3eee);
    lde_trace_evaluations_2
        .append(0x3f83a7441a21f17a06dbfd0ea35f8b0f4a5d44d05180e52bc362107e2653440);
    lde_trace_evaluations_2
        .append(0x108e14baa48d01781cdc2b721af23af708a6dd5e84a17ec0213ea9532b3de22);
    lde_trace_evaluations_2
        .append(0x26bb8fb43a772cfb96fdf25d0c3f5d9730713c59de363fe0d8bca614bba0604);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2
        .append(0x3645e8a2ff313f95792e7bd45c39ef6eee02a17cf78e4fb9c394c7f81003f6);
    lde_trace_evaluations_2
        .append(0x446c104aa1efd69fd6424794840955503b2a96ca97fbcc74d80d9b53994a118);
    lde_trace_evaluations_2
        .append(0x1bbb52918f65b4b4dc0c02fc0cf2bd054d7a327c24919df1398514efd762616);
    lde_trace_evaluations_2
        .append(0x4f31b9dec9347c38cedd0cb8fa6fee2b2ff1af1e41234533f88e7e9abcf18d1);
    lde_trace_evaluations_2
        .append(0x52456429af38c23d8fe60f2bfff0f9c158c8da6dd86a05e3f22b1d6851d76b1);
    lde_trace_evaluations_2
        .append(0x42c00ad8e4189bfd11489d67dd34d162fd25caeacdf86b7a4b878fbfe8d577);
    lde_trace_evaluations_2
        .append(0x3fa92513c410578a6eaa846aaf160eed1eeb6478d82115c024699f421ae8cf4);
    lde_trace_evaluations_2
        .append(0x278e24e504a0f592984aba2280725958dce8b79806510d53c7ab4b742d0d10f);
    lde_trace_evaluations_2
        .append(0x5a90581f515ddd169649dd85a9f41347dda52ea1ae814c1f182b1a4c1bd5b32);
    lde_trace_evaluations_2
        .append(0x14d68c398dea9a40a42741dd8056c7eb25317e8eac4e3edd0ee034de588b706);
    lde_trace_evaluations_2
        .append(0x22b28cdf0872d9f6871a656ea06aaa94b1806ed69bbe66574287ce3084e2ca9);
    lde_trace_evaluations_2
        .append(0x73b2657f1714470e0e8dd4b1a694390399f9ad056a6d00a7331adae3f177fa5);
    lde_trace_evaluations_2
        .append(0x7c3b4a696b3a8a4876c1d87c23dd519e9c45d8777c3ab881cbed17b705fe6a7);
    lde_trace_evaluations_2
        .append(0x5a68edfb95a80de48ac73141cac3e4184708261cbf858c5cd02442314add1e6);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2
        .append(0x3103cc1a7fec0ace57949b73bbf51b1a9e8925e7ef91cb3d965883b41685156);
    lde_trace_evaluations_2
        .append(0x59c4a80715e1247c9ff8b63d1c6556de61a5b4ff27428509dbd5ec7cfab0d26);
    lde_trace_evaluations_2
        .append(0x34c0c552320b9565b46bacc43da2b700fb88ae863d07316ebe1ec4bc6b5fa4d);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2.append(0x0);
    lde_trace_evaluations_2
        .append(0x34c0c552320b9565b46bacc43da2b700fb88ae863d07316ebe1ec4bc6b5fa4d);
    lde_trace_evaluations_2
        .append(0x1dc52febc5c09a0fb26e6e9a29c43198388d8e13a1334873cabe4deeb7550d5);
    lde_trace_evaluations_2
        .append(0x12230ea1a7b6aee2a7833bbfb82547000366c758804b4006835e70b47930566);
    lde_trace_evaluations_2
        .append(0x1f6329bfc842c1c85531d5040b268eecdf5e3ba7213432ec60412b240710218);
    lde_trace_evaluations_2
        .append(0x5fa9cc7dac351898c9277a2b3ce03d86eaae1365d822f4a8c77500684c05a26);
    lde_trace_evaluations_2
        .append(0x764295b13b061290b1b36420e7cedfcca6cc70c917a5e8492b7aee1c1cdf454);
    lde_trace_evaluations_2
        .append(0x4cf30799c2f04cc216b094736dac235b9c1df2f8e4fb36f86bd7e4e3978a4e0);
    lde_trace_evaluations_2
        .append(0x1ba921859b516f6b6ef7a659c7543dab77ccf1d767dd81e74de13c909364f60);
    lde_trace_evaluations_2
        .append(0x6e6dc80f25e80b762d92dc04a7bc753e2b484e377d668a12fe5ebccfe66e75a);
    lde_trace_evaluations_2
        .append(0x6f5e17c40b7d2967318d0cdbdbddd7fdba0a97cd9829febea25780336aaea8b);
    lde_trace_evaluations_2
        .append(0x3ff40157266c38d90bf040db56895c5b7210bb100943dcf60183a58079707b0);
    lde_trace_evaluations_2
        .append(0x10f93401ea73b292a8e9eed0d60aba66968f9b89f20746edc09020876787b9e);
    lde_trace_evaluations_2
        .append(0x7a8750adfed777209759eb4da18e69a2764f8bbff8f8905f8cec4e8cd22c8a6);
    lde_trace_evaluations_2
        .append(0x204b427f0ee9147068d9eec8fc13a32952dd6dd2b4a0abf6a3aeb58164e4751);
    lde_trace_evaluations_2
        .append(0x30dc74d612653a92a943dba4db89175cfcbe0061eb937c7645adce16ef60fe6);
    lde_trace_evaluations_2
        .append(0x145d1a91b73b920cb2dac11bcbe5dde40c5b8b71839568aa3a4232fd8f5931b);
    lde_trace_evaluations_2
        .append(0x60583a0376761d86dcfae44b9cfc4a9dc2576ff52b3af69b29460f84d955ba1);
    lde_trace_evaluations_2
        .append(0x30287f98efdd5a16bf83727d8ae5a3d0de4eab267cb9a5c80d546a242d70e42);
    lde_trace_evaluations_2
        .append(0x4af620fecf6770b8dcbd3bea9c2d1e03f65a813b2dab04a63af1a9e03ce2160);

    let deep_poly_opening_2 = DeepPolynomialOpening {
        lde_composition_poly_proof: lde_composition_poly_proof_2,
        lde_composition_poly_even_evaluation: lde_composition_poly_even_evaluation_2,
        lde_composition_poly_odd_evaluation: lde_composition_poly_odd_evaluation_2,
        lde_trace_merkle_proofs: lde_trace_merkle_proofs_2,
        lde_trace_evaluations: lde_trace_evaluations_2,
    };

    deep_poly_openings.append(deep_poly_opening_2);
    let nonce = 1;

    return STARKProof {
        lde_trace_merkle_roots: lde_trace_merkle_roots,
        trace_ood_frame_evaluations: trace_ood_frame_evaluations,
        composition_poly_root: composition_poly_root,
        composition_poly_even_ood_evaluation: composition_poly_even_ood_evaluation,
        composition_poly_odd_ood_evaluation: composition_poly_odd_ood_evaluation,
        fri_layers_merkle_roots: fri_layers_merkle_roots,
        fri_last_value: fri_last_value,
        query_list: query_list,
        deep_poly_openings: deep_poly_openings,
        nonce: nonce
    };
}
fn get_sample_cairo_air() -> CairoAIR {
    let trace_length = 256;
    let mut trace_length_min_one_binary = ArrayDefault::<u64>::default();
    trace_length_min_one_binary.append(1);
    trace_length_min_one_binary.append(1);
    trace_length_min_one_binary.append(1);
    trace_length_min_one_binary.append(1);
    trace_length_min_one_binary.append(1);
    trace_length_min_one_binary.append(1);
    trace_length_min_one_binary.append(1);
    trace_length_min_one_binary.append(1);
    let root_order = 8;
    let has_rc_builtin = 1;
    let blowup_factor_pow = 2;
    let fri_number_of_queries = 3;
    let coset_offset = 3;

    let options = ProofOptions {
        blowup_factor_pow: blowup_factor_pow,
        fri_number_of_queries: fri_number_of_queries,
        coset_offset: coset_offset,
    };
    let trace_columns = 61;
    let mut transition_degrees = ArrayDefault::<felt252>::default();
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(1);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(3);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(2);
    transition_degrees.append(1);
    let mut transition_offsets = ArrayDefault::<felt252>::default();
    transition_offsets.append(0);
    transition_offsets.append(1);
    let mut transition_exemptions = ArrayDefault::<felt252>::default();
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(1);
    transition_exemptions.append(1);
    transition_exemptions.append(1);
    transition_exemptions.append(1);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(1);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(1);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(1);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(1);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    transition_exemptions.append(0);
    let num_transition_constraints = 50;

    let air_context = AirContext {
        options: options,
        trace_columns: trace_columns,
        transition_degrees: transition_degrees,
        transition_offsets: transition_offsets,
        transition_exemptions: transition_exemptions,
        num_transition_constraints: num_transition_constraints,
    };

    let pc_init = 0x42;
    let ap_init = 0x7e;
    let fp_init = 0x7e;
    let pc_final = 0x79;
    let ap_final = 0x121;
    let range_check_min = 32695;
    let range_check_max = 32769;

    let memory_segments = MemorySegments {
        range_check: Range { start: 293, end: 309 }, output: Range { start: 289, end: 293 }
    };

    let mut public_memory = ArrayDefault::<MemoryCell>::default();
    public_memory.append(MemoryCell { address: 0x48, value: 0x1d });
    public_memory.append(MemoryCell { address: 0x37, value: 0x48127ffd7fff8000 });
    public_memory.append(MemoryCell { address: 0x27, value: 0x208b7fff7fff7ffe });
    public_memory.append(MemoryCell { address: 0x71, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x6c, value: 0x48127ffd7fff8000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x4d,
                value: 0x800000000000010fffffffffffffffffffffffffffffffffffffffffffffff7
            }
        );
    public_memory.append(MemoryCell { address: 0x77, value: 0x48127fb77fff8000 });
    public_memory.append(MemoryCell { address: 0x36, value: 0x48487ffd7fff8000 });
    public_memory.append(MemoryCell { address: 0x40, value: 0x480280007ffa8000 });
    public_memory.append(MemoryCell { address: 0x60, value: 0x48127ff27fff8000 });
    public_memory.append(MemoryCell { address: 0x123, value: 0x2 });
    public_memory.append(MemoryCell { address: 0x24, value: 0x400380007ffc7ffd });
    public_memory.append(MemoryCell { address: 0x32, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x22, value: 0x480280007ffa8000 });
    public_memory.append(MemoryCell { address: 0x63, value: 0x48127fec7fff8000 });
    public_memory.append(MemoryCell { address: 0x5d, value: 0x48127fd27fff8000 });
    public_memory.append(MemoryCell { address: 0x68, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x3b, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x5b, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x1a, value: 0x480280017ffa8000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x1c,
                value: 0x800000000000011000000000000000000000000000000000000000000000000
            }
        );
    public_memory
        .append(
            MemoryCell {
                address: 0x121,
                value: 0x800000000000010fffffffffffffffffffffffffffffffffffffffffffffffd
            }
        );
    public_memory
        .append(
            MemoryCell {
                address: 0x74,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffb6
            }
        );
    public_memory.append(MemoryCell { address: 0xf, value: 0x482680017ffa8000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x59,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffcd
            }
        );
    public_memory
        .append(
            MemoryCell {
                address: 0x53,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffd7
            }
        );
    public_memory
        .append(
            MemoryCell {
                address: 0x1e,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffe9
            }
        );
    public_memory.append(MemoryCell { address: 0x17, value: 0x2 });
    public_memory.append(MemoryCell { address: 0x38, value: 0x480280017ffa8000 });
    public_memory.append(MemoryCell { address: 0x4f, value: 0x3 });
    public_memory.append(MemoryCell { address: 0x52, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0xb, value: 0x48287ffd80007fff });
    public_memory.append(MemoryCell { address: 0x78, value: 0x48127ffc7fff8000 });
    public_memory.append(MemoryCell { address: 0x14, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x2f, value: 0x480280007ffa8000 });
    public_memory.append(MemoryCell { address: 0x7, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x10, value: 0x2 });
    public_memory.append(MemoryCell { address: 0x55, value: 0x40127fff7fff7fdb });
    public_memory.append(MemoryCell { address: 0x49, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x28, value: 0x480280017ffa8000 });
    public_memory.append(MemoryCell { address: 0xa, value: 0x480280017ffa8000 });
    public_memory.append(MemoryCell { address: 0x25, value: 0x482680017ffc8000 });
    public_memory.append(MemoryCell { address: 0x4e, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0xc, value: 0x48487ffc7fff8000 });
    public_memory.append(MemoryCell { address: 0x16, value: 0x480680017fff8000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x13,
                value: 0x800000000000011000000000000000000000000000000000000000000000000
            }
        );
    public_memory.append(MemoryCell { address: 0x21, value: 0x48287ffd80007ffe });
    public_memory.append(MemoryCell { address: 0x1f, value: 0x480280017ffa8000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x33,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffd4
            }
        );
    public_memory.append(MemoryCell { address: 0x56, value: 0x480a7ffc7fff8000 });
    public_memory.append(MemoryCell { address: 0x26, value: 0x1 });
    public_memory.append(MemoryCell { address: 0x4b, value: 0x48127ffd7fff8000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x8,
                value: 0x800000000000010fffffffffffffffffffffffffffffffffffffffffffffffb
            }
        );
    public_memory.append(MemoryCell { address: 0xe, value: 0x40317fff7ffe7ffb });
    public_memory
        .append(
            MemoryCell {
                address: 0x3a,
                value: 0x800000000000011000000000000000000000000000000000000000000000000
            }
        );
    public_memory.append(MemoryCell { address: 0x9, value: 0x208b7fff7fff7ffe });
    public_memory.append(MemoryCell { address: 0x75, value: 0x40127ffe7fff7fda });
    public_memory
        .append(
            MemoryCell {
                address: 0x122,
                value: 0x800000000000010fffffffffffffffffffffffffffffffffffffffffffffffd
            }
        );
    public_memory.append(MemoryCell { address: 0x50, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x12, value: 0x482680017ffc8000 });
    public_memory.append(MemoryCell { address: 0x124, value: 0x2 });
    public_memory.append(MemoryCell { address: 0x11, value: 0x480280007ffa8000 });
    public_memory.append(MemoryCell { address: 0x29, value: 0x48287ffd80007fff });
    public_memory.append(MemoryCell { address: 0x3f, value: 0x48287ffd80007ffe });
    public_memory.append(MemoryCell { address: 0x1d, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x23, value: 0x208b7fff7fff7ffe });
    public_memory
        .append(
            MemoryCell {
                address: 0x4a,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffc2
            }
        );
    public_memory.append(MemoryCell { address: 0x42, value: 0x480a7ffd7fff8000 });
    public_memory.append(MemoryCell { address: 0x69, value: 0x1d });
    public_memory
        .append(
            MemoryCell {
                address: 0x15,
                value: 0x800000000000010fffffffffffffffffffffffffffffffffffffffffffffff2
            }
        );
    public_memory.append(MemoryCell { address: 0x1, value: 0x400380007ffc7ffd });
    public_memory
        .append(
            MemoryCell {
                address: 0x62,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffc4
            }
        );
    public_memory.append(MemoryCell { address: 0x64, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x70, value: 0x3 });
    public_memory.append(MemoryCell { address: 0x41, value: 0x208b7fff7fff7ffe });
    public_memory.append(MemoryCell { address: 0x79, value: 0x208b7fff7fff7ffe });
    public_memory.append(MemoryCell { address: 0x61, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x3, value: 0x1 });
    public_memory.append(MemoryCell { address: 0x2b, value: 0x480280007ffa8000 });
    public_memory.append(MemoryCell { address: 0xd, value: 0x480280007ffa8000 });
    public_memory.append(MemoryCell { address: 0x46, value: 0x3 });
    public_memory
        .append(
            MemoryCell {
                address: 0x44,
                value: 0x800000000000010fffffffffffffffffffffffffffffffffffffffffffffff7
            }
        );
    public_memory.append(MemoryCell { address: 0x6f, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x54, value: 0x40127ffe7fff7fda });
    public_memory.append(MemoryCell { address: 0x6e, value: 0xa });
    public_memory.append(MemoryCell { address: 0x39, value: 0x482480017ffd8000 });
    public_memory.append(MemoryCell { address: 0x66, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x2d, value: 0x482680017ffa8000 });
    public_memory.append(MemoryCell { address: 0x58, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x65, value: 0xa });
    public_memory.append(MemoryCell { address: 0x73, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x20, value: 0x48127ffe7fff8000 });
    public_memory.append(MemoryCell { address: 0x3d, value: 0x480280017ffa8000 });
    public_memory.append(MemoryCell { address: 0x6a, value: 0x1104800180018000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x3c,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffcb
            }
        );
    public_memory.append(MemoryCell { address: 0x6d, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x72, value: 0x1d });
    public_memory.append(MemoryCell { address: 0x2c, value: 0x40317fff7ffe7ffb });
    public_memory
        .append(
            MemoryCell {
                address: 0x5f,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffc7
            }
        );
    public_memory.append(MemoryCell { address: 0x5, value: 0x480a7ffb7fff8000 });
    public_memory.append(MemoryCell { address: 0x1b, value: 0x482480017ffd8000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x31,
                value: 0x800000000000011000000000000000000000000000000000000000000000000
            }
        );
    public_memory.append(MemoryCell { address: 0x4, value: 0x208b7fff7fff7ffe });
    public_memory.append(MemoryCell { address: 0x3e, value: 0x48127ffe7fff8000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x5c,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffca
            }
        );
    public_memory.append(MemoryCell { address: 0x34, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x35, value: 0x2 });
    public_memory.append(MemoryCell { address: 0x2a, value: 0x48487ffc7fff8000 });
    public_memory.append(MemoryCell { address: 0x45, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x18, value: 0x48487ffd7fff8000 });
    public_memory
        .append(
            MemoryCell {
                address: 0x6b,
                value: 0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffa1
            }
        );
    public_memory.append(MemoryCell { address: 0x76, value: 0x40127fff7fff7fdb });
    public_memory.append(MemoryCell { address: 0x2, value: 0x482680017ffc8000 });
    public_memory.append(MemoryCell { address: 0x30, value: 0x482680017ffc8000 });
    public_memory.append(MemoryCell { address: 0x51, value: 0x1d });
    public_memory.append(MemoryCell { address: 0x4c, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x2e, value: 0x2 });
    public_memory.append(MemoryCell { address: 0x5a, value: 0x48127ff97fff8000 });
    public_memory.append(MemoryCell { address: 0x67, value: 0x3 });
    public_memory.append(MemoryCell { address: 0x43, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x5e, value: 0x1104800180018000 });
    public_memory.append(MemoryCell { address: 0x57, value: 0x48127fd97fff8000 });
    public_memory.append(MemoryCell { address: 0x47, value: 0x480680017fff8000 });
    public_memory.append(MemoryCell { address: 0x6, value: 0x48297ffc80007ffd });
    public_memory.append(MemoryCell { address: 0x19, value: 0x48127ffd7fff8000 });
    let num_steps = 184;
    let mut num_steps_min_one_binary = ArrayDefault::<u64>::default();
    num_steps_min_one_binary.append(1);
    num_steps_min_one_binary.append(1);
    num_steps_min_one_binary.append(1);
    num_steps_min_one_binary.append(0);
    num_steps_min_one_binary.append(1);
    num_steps_min_one_binary.append(1);
    num_steps_min_one_binary.append(0);
    num_steps_min_one_binary.append(1);

    let public_inputs = PublicInputs {
        pc_init: pc_init,
        ap_init: ap_init,
        fp_init: fp_init,
        pc_final: pc_final,
        ap_final: ap_final,
        range_check_min: range_check_min,
        range_check_max: range_check_max,
        memory_segments: memory_segments,
        public_memory: public_memory,
        num_steps: num_steps,
        num_steps_min_one_binary: num_steps_min_one_binary,
    };

    return CairoAIR {
        context: air_context,
        trace_length: trace_length,
        trace_length_min_one_binary: trace_length_min_one_binary,
        root_order: root_order,
        public_inputs: public_inputs,
        has_rc_builtin: has_rc_builtin,
    };
}
