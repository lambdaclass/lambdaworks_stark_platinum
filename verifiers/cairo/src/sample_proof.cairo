use array::ArrayTrait;
use debug::PrintTrait;
use array::ArrayDefault;
use cairo_verifier::stark_proof::{STARKProof, Frame, FriDecommitment, DeepPolynomialOpenings};

fn get_sample_proof() -> STARKProof {
    let lde_trace_merkle_roots: Array<felt252> = get_lde_trace_merkle_roots();
    let trace_ood_frame_evaluations: Frame = get_trace_ood_frame_evaluations();
    let composition_poly_even_root: felt252 = get_composition_poly_even_root();
    let composition_poly_even_ood_evaluation: felt252 = get_composition_poly_even_ood_evaluation();
    let composition_poly_odd_root: felt252 = get_composition_poly_odd_root();
    let composition_poly_odd_ood_evaluation: felt252 = get_composition_poly_odd_ood_evaluation();
    let fri_layers_merkle_roots: Array<felt252> = get_fri_layers_merkle_roots();
    let fri_last_value: felt252 = get_fri_last_value();
    let query_list: Array<FriDecommitment> = get_query_list();
    let deep_poly_openings: DeepPolynomialOpenings = get_deep_poly_openings();

    return STARKProof {
        lde_trace_merkle_roots: lde_trace_merkle_roots,
        trace_ood_frame_evaluations: trace_ood_frame_evaluations,
        composition_poly_even_root: composition_poly_even_root,
        composition_poly_even_ood_evaluation: composition_poly_even_ood_evaluation,
        composition_poly_odd_root: composition_poly_odd_root,
        composition_poly_odd_ood_evaluation: composition_poly_odd_ood_evaluation,
        fri_layers_merkle_roots: fri_layers_merkle_roots,
        fri_last_value: fri_last_value,
        query_list: query_list,
        deep_poly_openings: deep_poly_openings,
    };
}

fn get_lde_trace_merkle_roots() -> Array<felt252> {
    let mut lde_trace_merkle_roots = ArrayDefault::<felt252>::default();
    lde_trace_merkle_roots
        .append(0x705e8834a75fb0cdec518d837f9901371ee0076918792fdd595752e07d97e69);
    lde_trace_merkle_roots
        .append(0x28127ef48d69d793f3e4abac875e9caa2bc52baeeee2d51c9b1ddce1932b185);
    lde_trace_merkle_roots
        .append(0x3734b5e9fcc8db3158e8b1954f7270bb194c95f4e4d663be760938b9374eb33);
    lde_trace_merkle_roots.append(0x3df1701662890b3a516a5373cf991dd20ed240659304f9f995653c68045914);
    lde_trace_merkle_roots
        .append(0x241937877316231740a14cc9f8aa53a6fd636486e9727ec1e370f22bbccf2e1);
    lde_trace_merkle_roots
        .append(0x3f3e420a0b7d36e528c116af32973515fcf10bed0d267b5d850d957b1f3955b);
    lde_trace_merkle_roots
        .append(0x264095143e49f3cb4fe1ba9e564de1d8983be064febc68e7f50d6736b4be4c0);
    lde_trace_merkle_roots
        .append(0x6490266c1985e3a2ddd99dc4816390055ff874081bbd57e5593a2d39c72cb8d);
    lde_trace_merkle_roots
        .append(0x703d9bd302025ab86b32101cb7607bc6199c08862ef321a38aeeefe00164de4);
    lde_trace_merkle_roots
        .append(0x673f46d6c28868d1082ec506d4a0e20e2234e2171744b8766af51c0a118e649);
    lde_trace_merkle_roots
        .append(0x264095143e49f3cb4fe1ba9e564de1d8983be064febc68e7f50d6736b4be4c0);
    lde_trace_merkle_roots
        .append(0x21119dc3c9f341be412d66c27e11472c3ab8c91a92f9c93bea6cbee3636aeb5);
    lde_trace_merkle_roots
        .append(0x703d9bd302025ab86b32101cb7607bc6199c08862ef321a38aeeefe00164de4);
    lde_trace_merkle_roots
        .append(0x6490266c1985e3a2ddd99dc4816390055ff874081bbd57e5593a2d39c72cb8d);
    lde_trace_merkle_roots
        .append(0x78111c7ea3eb64038c9156680bec448c95c460d711e78f7defc80ac20abca34);
    lde_trace_merkle_roots
        .append(0x264095143e49f3cb4fe1ba9e564de1d8983be064febc68e7f50d6736b4be4c0);
    lde_trace_merkle_roots
        .append(0x103bedc79631a66cba25bd056b3c8f9e55a078f44fa59a7d4e77b971c8bae4f);
    lde_trace_merkle_roots
        .append(0x218f357d7c846921b9b7d9b0d6c381cd93d1bda4cb3c454b896485a37d4b65c);
    lde_trace_merkle_roots
        .append(0x3ded0c68f35514b4dd76c79dc666fc50ef3966822719fd649b0573dc4ab900a);
    lde_trace_merkle_roots
        .append(0x7823867269cd71f1457708eec954a3405ab063d547de027764246f5532ce112);
    lde_trace_merkle_roots
        .append(0x2dc886e242ae513e68c482f8856e1f0e91c5996b47a18c4058351c6e6655573);
    lde_trace_merkle_roots
        .append(0x73087878fa32c56be20005297ae228e1e0a16824b8350d8ec4cb6d91756a493);
    lde_trace_merkle_roots
        .append(0x6765238b88b18a1439511d80fb0d43b17b0d82d7a28b510023c065d16ec6c1f);
    lde_trace_merkle_roots
        .append(0x2e7e9b79f30419a2c09eb5a57ed839218ae96319c2e59251804b21cac723bd2);
    lde_trace_merkle_roots
        .append(0x22615274a59e91d239bbc53f0f2624f8af920f7e6b39552c0f8297fb5d5783e);
    lde_trace_merkle_roots.append(0xa67637348f90f182d42cd52ed1269e7c896563e33710b09962dc7e9b35d054);
    lde_trace_merkle_roots
        .append(0x1fff23212c0870437e0c3674d91725458e53bc28b7672e3558a5219c431f410);
    lde_trace_merkle_roots
        .append(0x6845ababb8ef58692a3aec2fd6582b0e4d7f257ff2f691501864037c95573fb);
    lde_trace_merkle_roots
        .append(0x70550aac2d649b2eb2cad0fe70c8cb2a9b87c9f9e17b942e4a1e8881393091e);
    lde_trace_merkle_roots
        .append(0x7aafe7503609a9a87262b90c2df215f9d11c9fe95d63e97c224ce0907630a40);
    lde_trace_merkle_roots
        .append(0x50d3598fa63e3a8cc7b20a39e47f8987c921fc232225628e4a5b53369765a63);
    lde_trace_merkle_roots.append(0x4ac531cf35482195a5e91cdb110f02a7d1a8344f2b0d864ea59875dd3d0ee1);
    lde_trace_merkle_roots
        .append(0x1cb5e096576fd8563e5101376de39fc96c25234abe79ee20e071ad28700bc1a);
    lde_trace_merkle_roots
        .append(0x5153081c356499a8a9e2609e7fdc5a505e2d54ec7c90099042ce8dcea680b69);
    lde_trace_merkle_roots
        .append(0x58ddf4e2b68a424e05bf12ba6f995769d2d81dbf528d941c9821f5c54253fa4);
    lde_trace_merkle_roots
        .append(0x2ee4a171f2e0137a57aa790462fcfee20f7ba5957e84f52a6eaa11184105dcc);
    lde_trace_merkle_roots
        .append(0x3cd4df760ac8b37f23b4bc34b2979e67fc94c6c25a3f6dacbf2f735ade18d04);
    lde_trace_merkle_roots.append(0xc83c326489ed895ebd935b9071f05c57d24777e2ef00d3abe50b6aa68750be);
    lde_trace_merkle_roots
        .append(0x3adacde9d57386aa15fb8c09fe93621afad2dac652e3ae3e923ef12703daaed);
    lde_trace_merkle_roots.append(0x4603f55bb41442b4b8aceaef07ea1de295c3932e95b53bfbc800e985f58285);
    lde_trace_merkle_roots
        .append(0x324df7f58ce3c782f44cb6e051051843bf70bacb1403852bd2394cd00bfc7b4);
    lde_trace_merkle_roots
        .append(0x11a88cc6aa10667a5c6eecd4779285a44548503e9a724c4bf5f837e084aa4d7);
    lde_trace_merkle_roots.append(0xab080b4443584b04da21854335fc26e49b4bfa154f047224d55f6f0b4817e2);
    lde_trace_merkle_roots.append(0x744cef13ef856ac0262e570f00785b0492b6af2ae4b693ccc1de8fdb75322b);
    lde_trace_merkle_roots
        .append(0x34c749198297d15a2e15a06ca0c828344f33844c9f3a47f8b09f8100e73956e);
    lde_trace_merkle_roots
        .append(0x56e21c88634b09e4b869cd0c109c9b26326b51d46db526f2a7f09d876011536);
    lde_trace_merkle_roots
        .append(0x109e3618a56d9866a104a2d1f3477e3fec7b46acc2d090d4395b475bfa502ac);
    lde_trace_merkle_roots
        .append(0x2df43b9ad3fbade18dfcd05282d67af09db2f93cc9026803c225e0a8ec0f185);
    lde_trace_merkle_roots
        .append(0x6486415ad5c5ca67a21c471049cd48cda5bfc9c92e84b24d7f7afcb9be24f35);
    lde_trace_merkle_roots.append(0x81b5049daf093ce20b1d452645d5a067531b379a4b4b62e88f439018a75018);
    lde_trace_merkle_roots
        .append(0x71696a73e6ccaf29c00ff3e31fb5ccefe25938350c3c1976132849bb42ca7fd);
    lde_trace_merkle_roots
        .append(0x2e76ba8b43bade268c1d60bb81ab49e686c64003d1ffdde59cbc71829987aa9);
    return lde_trace_merkle_roots;
}

fn get_trace_ood_frame_evaluations() -> Frame {
    let mut data = ArrayDefault::<felt252>::default();
    data.append(0x3dc5160485b5078f7b391a1920878740a3bbcea5494383d366cd9f7732c8e68);
    data.append(0x2f8f1b0bf66bda7e4a1e686ad59a48663f300e670c16bcdce88874ad1077d71);
    data.append(0x7b0225fc3ef7f6e5c4f65ac70ed89cb25e060c1497164cef1761a231e62b005);
    data.append(0x32f6a7f17d84b01108d483c1f5939969cb9eb266a22de5e1fb08a91839e97e);
    data.append(0x1ce6f84a92fbf292a7c5cfcd1ce29b7054008c4fec6d4b2c8edd33c963667f);
    data.append(0xdff52e7193660b3ee92f48e619d97478359dd98adbb6a7f948e2b1621a796f);
    data.append(0x0);
    data.append(0x58d87dc3385a445cf5db115489680348da68a857c4aa37c713f988b7ac483bd);
    data.append(0x5070e4f409942691b5e197952a65b799c0cff198f3e9432317778b52ef88291);
    data.append(0x64ec98414d5ac442855e08c4971f83f7c953264d84994c0c52d416bf8680aac);
    data.append(0x0);
    data.append(0x4f2835bf8e751dd11b56462eae1182a959945972cc723ab6609cf6ba8f0b1a0);
    data.append(0x5070e4f409942691b5e197952a65b799c0cff198f3e9432317778b52ef88291);
    data.append(0x58d87dc3385a445cf5db115489680348da68a857c4aa37c713f988b7ac483bd);
    data.append(0x71ca050770b6d3fecee54e51b512c1259b743fc1c2d3390981bad535ddaef0a);
    data.append(0x0);
    data.append(0x371c135b3807e52216f0a8244a41eb2450ae3484accc890482209d5d0bf1e6e);
    data.append(0x62e717516837aa4c3d770b168d952673f290232a7db4e225630d59ce7890403);
    data.append(0x12ce3b3febc5329419e9e2eb8499970e2071aa616144f9cfb4fb527908ce9f2);
    data.append(0x4188e5da71c3e630150cd8dd1bb5dd9fd77f0c19b678798bc5155f77f18dffb);
    data.append(0x45499790f5ec5c89345915cad6f4380d54118ed53aa1810a059e9034b5d6fed);
    data.append(0x689a1e74cf064b570f1d45ff4341a94e8b63888bc581400e351d72536936532);
    data.append(0x21b438a5ba365f065fd9f3356fb77e2b9fad13f3f9d3ed8c22fa6a8f1ddb7cd);
    data.append(0x71566b1c848030c3f1fbe9dfb9dd65fc70a0d8b7f075eb9f3e085a566fe7d9);
    data.append(0x759ae3718fb1ed6ffddcaa4e683851f8fb61fb2b31d113c728f9e5c81edd9b8);
    data.append(0xb63e885146e43175046c65f6c9b517bee95f4503eac14d44f82d7e52328624);
    data.append(0x1e468b71b1a4abf8624dd5e36030712a646a6c5e984462886aff3f60f27bc5a);
    data.append(0x7ce76c6dc4f979a0d0a0bae620d02f0aad555618f27eadf9be72cbd6c551b1d);
    data.append(0x2f28b5042ed0d3912c84fdac88c2aac5870f69bc54820c7b3091aa600bd130c);
    data.append(0x75311640364617860f59b3da8a0f6cc46fd846f83efbd16642b06b99b024844);
    data.append(0x28c90294613cce2be5b330c356125355418b5e7d0cc1603b857e404f35f54d5);
    data.append(0x58f77290419acd215cb055a751bbdb8ec70267e255bea654d0c3a05767f878b);
    data.append(0x31ba7d5ff79d105bd73c88a23359046c1fcdd5d2feb7cc31cda0bf1f15f811a);
    data.append(0x72701e16fa83f0270fb8a67c6a7b86628c5fada03fa1fc66823432de968dc02);
    data.append(0x2e33d65e3e36afe93d8164b16283b3a0f3b3b131c9276c2737654558344dadf);
    data.append(0x54a86354da889d787f86cd41c448862a66a5c25072c69aa1c5b725e6e28d2cf);
    data.append(0x7e30db60af395048483a23bc8781b56a5a84bc5425bec156645c3bc85c77609);
    data.append(0x52fa36f5694f2ebf5420fcff35a3bfe80be2d3b03c54b64a9ea1164b111963f);
    data.append(0x78aa3bc692d7ff0fc3196d2e46c55277a4011cb99bd4f48e7a5d3f881989d82);
    data.append(0x7f7da3d68f9233c25ad899064664eb06f3b6f0c136c46f9ef608b26c9c835);
    data.append(0x16bdc24a0eeb49cdc4a0c9da6c128e1c967fe219ac3280e12b5efc4e01d4bd3);
    data.append(0x1c1a82c0fe53c2e930ff0965cf64f69a99a974f9f2020eae47e558841d7f910);
    data.append(0x2656df4eb96c266e3350d91bbb633974b81d3e5241d7283f5d3b37ec774ba01);
    data.append(0x4481634f6baa6bac546e77d536974bb7b6bfff4c737df24cdccba50ee4e05b7);
    data.append(0x76b9198bdb56f9dec8437c16de6c1b4f3b997d3956adf31c2eaeac435a7cff3);
    data.append(0x7b55d966a2038c38c1c3da3752098c676df13fb39bb6b2f092cd6c3fef2f7e7);
    data.append(0x4ca691022a2431aaa53d0dc6e3d48b44e8a82d6a9486c911e791c0a27acbbfa);
    data.append(0x6fcdc0cb05d64c225a9f7f1858417b9bade542d075a68a10e54f995c5a5dc00);
    data.append(0xd9d265060f095d29a822535a4a3b4278de07000e34c08fa18fb1d746c1cf57);
    data.append(0x6ac258751b3eea4e7ff0a729069534d8dbc3808e97055fada44d7a18f19d6b);
    data.append(0x73d4f88580ff9769a3993bca24e489f2d00bb6d51025fc54495de51bfc4adbc);
    data.append(0x705644f6dfb82eb17b726d1f38e058d292f234c6fe922aa380c9a261dfb8648);
    data.append(0x51f51323a31580f9ebfdf82a1c4f2656875e910420ae6d563c0e53814ef7828);
    data.append(0x657bcb860f23a63502b01e2f954b405621f74e0a6a932a2eaab3cac0a5e843d);
    data.append(0x52cc6849cbd10231d4784225af51ac8a7735cf415d64d77db17b0a0635a14d7);
    data.append(0x493309079eaebd0687588a4335be5a2dc7b1edc729d89cd187478b33097f0ba);
    data.append(0x64008eae958042e7a42f33971aeff947c11842f778c28bb0c73d6ac6c0dfa72);
    data.append(0x5ac5e214eaca8c4a872cb2a4238a0545cc4270a754857b0799b17393fe2ee0a);
    data.append(0x0);
    data.append(0x1842e2f99815a68361c6094f1e96ebcc68e9f6b2cc52a332496c82e5f6f597);
    data.append(0x1a843479f0dc5adafd4fe1d06ab4bfa9de08b1f5956cd5d1554c353f5a17bc5);
    data.append(0x5070e4f409942691b5e197952a65b799c0cff198f3e9432317778b52ef88291);
    data.append(0x0);
    data.append(0x27b123ab1f8055efa368caf2f525c152a1764624a8ef4368635da6ae8a5df4c);
    data.append(0x1a843479f0dc5adafd4fe1d06ab4bfa9de08b1f5956cd5d1554c353f5a17bc5);
    data.append(0x1842e2f99815a68361c6094f1e96ebcc68e9f6b2cc52a332496c82e5f6f597);
    data.append(0x1386b8626c0e253b16b2260578fc19ff9a98bd0649e4bcd86ea5773f56f0c15);
    data.append(0x0);
    data.append(0x650031e324425f08ce2bc5bb16d0d3a77bcb16b780803c346bfc4e0582919c0);
    data.append(0x63d5279a513e78d51a1a387fe4fd8bc34fb8cacdd8aa27c296b5a0ade3606c4);
    data.append(0x45b9bc7d129891074290e7258c0918e8aed715a6de1494fa2f970bfd63b86a5);
    data.append(0x7219fe259d9c6d95a7f2cc6a48b4601f532270977ac0b795e6a048a1572bb08);
    data.append(0x4c1d903b6f50de1c6bd53fcbd27f6c768a117fd871e2fa829cc72b6a87fa9a7);
    data.append(0x31b214fe4e71fb0c18de7e350db1a57f05a422a0e5346a7ec81989b5ad3b254);
    data.append(0x44f6b5cbc381d427378d8dfada4a749b3909d4966f47d7e995f1e5ef68e7429);
    data.append(0xd5dc66d5468558e8a39a60929d7be8e41d04826ecaccf24dee06657698da21);
    data.append(0x76a048677f6553c77d99ddf1593985e47cf190ac81a6d98f8da8a00f3b8af4a);
    data.append(0x3eb4bfbd19734c769545fe1167d5a226504483c8991aae59fd5aa242809e045);
    data.append(0x4af90d418bf38766ce312a6972e4290464c8d5e4811353897a70a70603b452a);
    data.append(0x1fcf600d63b30a4efed91d041925a30c3750757d29c468c06523fd19a5fe058);
    data.append(0x4d8dbfa988ee060e32e5b309eaddbdaa9587b2d7d65168e9d5ae42a7e7e8c62);
    data.append(0x6a8bb15cf2999bc1110cd3a978349d7a29e970774acccb6f73a66037ac3bdd4);
    data.append(0x62b2b7b66d10c8917d7015a8c602bb9ec3255c16b5f9a93b68da86e4e2e270c);
    data.append(0x3b34ee715a25240158a34deb1610601f2c31c7d74fbde8e9d930d9cfbd03d25);
    data.append(0x59450f451687888c7749d9cf006844e55051990e16aa1f7a56647488caaead0);
    data.append(0x4182f469defa303106d2de904c6f97ce70801773eacd84de9aec0da509bb837);
    data.append(0x3a487ab6e7597ef0373af5753002773389c892653a6c90b91b14fdf832fc756);
    data.append(0xdc380ce32846c9b48b2bb1cdf624ee14b990c658df90a99248d97fe616c12f);
    data.append(0x37c976fe6a90d07149fdfd21c1a9ffee1b91b08b3c38d2a132287bd5f7da5f);
    data.append(0xff3951460118d319c26ba36db03443afca374202e1a4bf3118bd05ea8381a2);
    data.append(0x362877fe2398579f9f094525a22c987fe0eea5fecd848a337a50071e20b4ae6);
    data.append(0x770d9ed720336bf21d3ea77d8018b0bedee73ad56ee978591280a1deda4db34);
    data.append(0x60bcef967eb59d3a6e6eb1ef64514953b1b9a2b291380f4b28a8d0be65fa77c);
    data.append(0x40be755f9d577d2cf2932b3c077c28a5869c15d2ddf09714c7f53dffb117bc9);
    data.append(0x1a9d377c46174371600e71e06f002ba1d1ada53832178d8194a8810fa985c8b);
    data.append(0x67af037bbbe2e91f7d0ce05090b1622954c97731f98452d0391e4a888f76b07);
    data.append(0x229ed190b7ffa51a5da1faf498f13b33e37fcdfb15f30e4d3cf035567987eee);
    data.append(0x1436d91f82ec208a6d882cb9d4eb387292b2836f246a208b0973becc4b59e0e);
    data.append(0x25ca1e130b1295fbdb378cc0647672ea7732ab3eaf67ffa53579a29698060d7);
    data.append(0x5a6cd6ebbf222b6e6028f19610c00e5e9eda3b0c940dade020cd90ead459376);
    data.append(0xbc2a7d7a4a0b5dd703e39be187f698f6aaf873c53450526762a7045551405e);
    data.append(0x2633c6fe63223e63e1f855ea048e1248bb494972adb8a99797741d2f78b6a88);
    data.append(0x71dfbf9eae583d6f7a94844b05d433af69fc5591762c66ad7249c3295ba4623);
    data.append(0x1edcaa461d30306d497c7fda395581e03be526410daae63fcfe70f8fa4c57dc);
    let row_width = 52;
    return Frame { data: data, row_width: row_width };
}

fn get_composition_poly_even_root() -> felt252 {
    let composition_poly_even_root =
        0x598856342fdc77f21be2fdd1721aaac057202195d7d1c76fb8ff56c418f131a;
    return composition_poly_even_root;
}

fn get_composition_poly_even_ood_evaluation() -> felt252 {
    let composition_poly_even_ood_evaluation =
        0x4134aab9307c6a252a3e5d94c26783511e9500a7ceb237c98f9260139f16a58;
    return composition_poly_even_ood_evaluation;
}

fn get_composition_poly_odd_root() -> felt252 {
    let composition_poly_odd_root =
        0x2e82d562652f049a98c8c879074fc4a4e60504b5ef8d8a3de8f9a8799b6247a;
    return composition_poly_odd_root;
}

fn get_composition_poly_odd_ood_evaluation() -> felt252 {
    let composition_poly_odd_ood_evaluation =
        0x3f12fb3b303226f09326db0b4f8e2ca6a2e27db13447e50e56cd11a7aa73939;
    return composition_poly_odd_ood_evaluation;
}

fn get_fri_layers_merkle_roots() -> Array<felt252> {
    let mut fri_layers_merkle_roots = ArrayDefault::<felt252>::default();
    fri_layers_merkle_roots
        .append(0x362a40ae9e0e3bbfb2dd9dbcc50f98091ad282ba8531f0f0e12df6f2f449160);
    fri_layers_merkle_roots
        .append(0x5989b3c4cb951c2b421903c9cf99b18147e4792f16d869887d98b1ad37b8d99);
    fri_layers_merkle_roots
        .append(0x6914e10e74d87fcfcce3305fa68186fff479b217b1084693c5f3853c0d46b39);
    fri_layers_merkle_roots
        .append(0x5f51997108eb0aaf96b282ad9e207128e3190303fc541beb9b1f856adb74d82);
    fri_layers_merkle_roots
        .append(0x6c67296745122ed7a20523887094cfb7c5d96eae2bfa9f3feec5120f5527266);
    fri_layers_merkle_roots
        .append(0x7bbb509bf01d1f422838838c6575e134c25812f6e12db620856cf9c645c02fc);
    return fri_layers_merkle_roots;
}

fn get_fri_last_value() -> felt252 {
    let fri_last_value = 0xc87984bcdf490d2daa1fa60694c1eab740125515f0960d1b36fc9cbb0101d3;
    return fri_last_value;
}

fn get_query_list() -> Array<FriDecommitment> {
    let mut query_list = ArrayDefault::<FriDecommitment>::default();
    let mut layers_auth_paths_sym_0 = ArrayDefault::<Array<felt252>>::default();
    let mut layers_auth_paths_sym_0_0 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_0_0
        .append(0x2263314f7e8e608b2295800513f6bc016426753eca952c674ecb9deb07205de);
    layers_auth_paths_sym_0_0
        .append(0x5e449308c4dcb6be8bd95ad1690b353d245f01f7a4b8e9bd35d71524e81cfd7);
    layers_auth_paths_sym_0_0
        .append(0x1a0b0af2696f7a133dfb488ffc59b5a7574e8a1b139fd3da490fa286f0d3ed2);
    layers_auth_paths_sym_0_0
        .append(0x24e56d6b0d5559ee104af66ff91189bbf17e0d2df6a09d950380e07d950b0b6);
    layers_auth_paths_sym_0_0
        .append(0x7bdec7f52666e5ca24650ebd75fb0cbbd498fb37389983da3ee6609cada4655);
    layers_auth_paths_sym_0_0
        .append(0x584d92e12e4fdbca8f9c835a9a8a0ded60c54ec96dbf7c06fd21c1237adcb84);
    layers_auth_paths_sym_0_0
        .append(0x463c08666bbfc8d3a22d0e1262f2df98a3a9df0f0518f8fc184e6a6ba994584);
    layers_auth_paths_sym_0_0
        .append(0x2bdcbf049cf74f107dc1129289379a7409c7e94c9d5f27156e231219c87eff9);
    let mut layers_auth_paths_sym_0_1 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_0_1
        .append(0x63db1bddc80e00822286e5b4b9b141dae6b6a802b9de81c7aa738954fd8934a);
    layers_auth_paths_sym_0_1
        .append(0x2803f2ad698936cf226f1ccc5d3ac47d1719143a001183e89ab65d6180f2894);
    layers_auth_paths_sym_0_1
        .append(0x30a5c264d88ff14f0faeb717b2c09de528b2f1d47021c4bd3d02ae9c6524508);
    layers_auth_paths_sym_0_1
        .append(0x5455bcc7a4414d2777e07bd8c17ad330f1cddc3e1f58e8a8395bdbcb580ac00);
    layers_auth_paths_sym_0_1
        .append(0x9586d2b2630e72974a20ccc73ddc262a6d0ff70befa776cc13c7f5cbd96c60);
    layers_auth_paths_sym_0_1
        .append(0xded45d0fade4f7ed7cd03bd009da15cbb38d170603e43e1187a9040c4c32d4);
    layers_auth_paths_sym_0_1
        .append(0x518f52c6d81e4a3c44c71565c2ca10924b46b4d6ecbb27fd3961fd15289b23a);
    let mut layers_auth_paths_sym_0_2 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_0_2
        .append(0x66226649bc9d6b5a952ce837882fbcc1251717e302cd719c4ccc2c5437239fc);
    layers_auth_paths_sym_0_2
        .append(0x38da69da1e58aac49d1871af67563ad2eca5fab81ede5d290118a7034757634);
    layers_auth_paths_sym_0_2
        .append(0x117ba7ff3d2c47334ae572a988e5392b2f49220452705402c18567bc6d13452);
    layers_auth_paths_sym_0_2
        .append(0x1f5c06d9ff2275ea5fd34de470e5bc5c90fc5adac3d0c6c2e55c40fb02a3ae5);
    layers_auth_paths_sym_0_2
        .append(0x678e9021b52e78faa025e0423b64cf217ace8376ec2ea3c2f57f08a269919e2);
    layers_auth_paths_sym_0_2
        .append(0x1370df0edd6909bacb7b079b63b22ccf521ad07cbf46a973d01da8bfbb3fc06);
    let mut layers_auth_paths_sym_0_3 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_0_3
        .append(0x19c3cb72374a999f77321cbf479dc10be1dcd39349d52d0d36c29267a1428e9);
    layers_auth_paths_sym_0_3
        .append(0x505cd2e245624c9a9c243b34ff731dea3434343134044d9a4b9a5996682a6ee);
    layers_auth_paths_sym_0_3
        .append(0x40a2d1f91121116fcea97e087bd36493f0e3d55c5a58f65884caffa787a7740);
    layers_auth_paths_sym_0_3
        .append(0x3187aa4be7bf1899c5618afd3e6e729442df3a1d4a87ad0a4ab8de3808f6e87);
    layers_auth_paths_sym_0_3
        .append(0x1f0889ffcf5d039325825cfcf15680518a873210b94853da475aaeef5bb41ca);
    let mut layers_auth_paths_sym_0_4 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_0_4
        .append(0x29257e3f83734aeaf486a14295c358f9044f245b7e1b93f129bf7d2708b6afd);
    layers_auth_paths_sym_0_4
        .append(0xd50e0b98ac1a4508044eeb656c54ba76d64a7625b282aea5e3b0dfad12dc1c);
    layers_auth_paths_sym_0_4
        .append(0x64d872db1be2cefe32ee546d55a619d88328f69afc09d2893c950882191fbb4);
    layers_auth_paths_sym_0_4
        .append(0x6f1476869c2a5a192ff66bcc730c71a2700fa687c656e6f65b1a531c67ff161);
    let mut layers_auth_paths_sym_0_5 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_0_5
        .append(0x1b9eef89dbecbd865bef94cf36b9744ed85e8688585c02ffc6cc414f170690f);
    layers_auth_paths_sym_0_5
        .append(0x243d9270a687cf8c1b1ce6abfeec702412c8e7ca7f3cadaf462b58cb87f54e4);
    layers_auth_paths_sym_0_5
        .append(0x18af8e1c23482edbf9af3d38505271d0bca88e919b5473d9f3e7288c5ab29b6);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_0);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_1);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_2);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_3);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_4);
    layers_auth_paths_sym_0.append(layers_auth_paths_sym_0_5);
    let mut layers_evaluations_sym_0 = ArrayDefault::<felt252>::default();
    layers_evaluations_sym_0
        .append(0xfcace76d60ab9ddcd1550be423af4dff94aadef01d6e4caf883be41b6402ed);
    layers_evaluations_sym_0
        .append(0x6f2c407fe05f7b09a339c8fac7d11c2e4decfa3cfb3bdb50f5ecbb43a4774a4);
    layers_evaluations_sym_0
        .append(0x60a4b2e5116c2e66f63b0aa0bb1ea39618b0fb45d027336fee3a621af06cbd7);
    layers_evaluations_sym_0
        .append(0x5dd6a3f0edb5f17dbf7b411fe14e247b8e1aa14dbca7d747243efa089e04af2);
    layers_evaluations_sym_0
        .append(0x2c66fb09bbb54b330be9d2a7dd2e43f3dc9dacec067b5cbec6161c9da26c426);
    layers_evaluations_sym_0
        .append(0x33f36bb6ea11c142804a51767860beadca33840479929b915e61fbd80c95913);
    let mut first_layer_evaluation_0 =
        0x6db749791bcbeac74e7dceca388339c59d70b5675fa2ab3db257459c027020f;
    let mut first_layer_auth_path_0 = ArrayDefault::<felt252>::default();
    first_layer_auth_path_0
        .append(0x28441c58872921dcf812548b6e874484a85a94716ca3c17181dafb5862955f);
    first_layer_auth_path_0
        .append(0x526a846bbcb32ac98dbe11fadd9fe5dd48171b1c0990b6eecbc0df107c84032);
    first_layer_auth_path_0
        .append(0xeac09abf761394819d76e5fce2599ad50af3a2cce4fe25467b943c9b5fcf13);
    first_layer_auth_path_0
        .append(0x571e6894888150f6e5fba11dbee2a9c2a90e4c45d99b1419a878421db8c1bcc);
    first_layer_auth_path_0
        .append(0x71569422c3c72684346638b80fe46f4f3129bd72e1d9c4831a0f881ec2dc48d);
    first_layer_auth_path_0
        .append(0x76578bb8c5bb3ed0facd71380e8dd23db8b20cf204904d83335884988b0c127);
    first_layer_auth_path_0
        .append(0x10519908b0f801deb26d5555881bc37d5386831c9128efdbc1a58753dfc4280);
    first_layer_auth_path_0
        .append(0x19cdf4016ea48fd0e11ca88ed8cc5a27bd3393bd8f469ff5b7920ee0c980488);
    let fri_decommitment_0 = FriDecommitment {
        layers_auth_paths_sym: layers_auth_paths_sym_0,
        layers_evaluations_sym: layers_evaluations_sym_0,
        first_layer_evaluation: first_layer_evaluation_0,
        first_layer_auth_path: first_layer_auth_path_0,
    };
    query_list.append(fri_decommitment_0);
    let mut layers_auth_paths_sym_1 = ArrayDefault::<Array<felt252>>::default();
    let mut layers_auth_paths_sym_1_0 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_1_0
        .append(0x28adb62ffc25fdfa1d9327f46f534c8c32d00554b5ad2ecdca595d99e3b1252);
    layers_auth_paths_sym_1_0
        .append(0x599e1c83f551d2ed53530bb89ba274863f745705c3fe02cfcc1c8aa8e186734);
    layers_auth_paths_sym_1_0
        .append(0x141c0bcf5099a3febcc96b316a44a29c8f6ce76cd33798b80d29a3d851418b2);
    layers_auth_paths_sym_1_0
        .append(0x1dd74489261e34f1334a1eff0c6b4ce16ec6466ac03173b1fa2fdc61392135a);
    layers_auth_paths_sym_1_0
        .append(0x2505d6c8df7aa175bfca317a2c34ad1ba526e066f09c0246f5bf042cf0317c0);
    layers_auth_paths_sym_1_0
        .append(0x650b12e439bb5e9cf96398954486a4e22b8c147bba1cd855a664131f031feae);
    layers_auth_paths_sym_1_0
        .append(0x172f2d43f383431d17b408e6bba621466d6bc9d99d151bbcf8e59c2d2bdf437);
    layers_auth_paths_sym_1_0
        .append(0x2bdcbf049cf74f107dc1129289379a7409c7e94c9d5f27156e231219c87eff9);
    let mut layers_auth_paths_sym_1_1 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_1_1
        .append(0xb00bedece1d1290c819ad5078b5c64bc59fd6e0588ebf7359d733120ee27f1);
    layers_auth_paths_sym_1_1
        .append(0x93a6bea419a350b478c1bebfb0b80a13b8431f53529137e96fbc08eaf503cd);
    layers_auth_paths_sym_1_1
        .append(0x51984be5f0f51ab38184d9d292aca8e4efa53a6a94c1b3b4aa32e04828725bc);
    layers_auth_paths_sym_1_1
        .append(0x7660e128ae78256ec50fe0b242620241c46c470483d511608f3816af98ab607);
    layers_auth_paths_sym_1_1
        .append(0x26840fcdae34307048f6883de7e3e6c750a4a15a09fdbfd0944a06a40a8c576);
    layers_auth_paths_sym_1_1
        .append(0x1abe9db8b1a2e4ab13cdd9a095cdffc14b51bb76548db32485bcc28032125ad);
    layers_auth_paths_sym_1_1
        .append(0x7784ec5f48673a0a8c5d1501bcb5d451eb156d84d35ea68621f2de867655fd3);
    let mut layers_auth_paths_sym_1_2 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_1_2
        .append(0x5860e8ef7fc537a6dd03e2717d3479c0d9e2b5d867a487b772c7a6592c8e322);
    layers_auth_paths_sym_1_2
        .append(0x7c318e4ad696986d23404b4447360719a33df8705cdc3a04422199771dbfb32);
    layers_auth_paths_sym_1_2
        .append(0x640ed943aa94a09a1af620f1442fca95a9d63201ba20734ca6bf1803a18f9a8);
    layers_auth_paths_sym_1_2
        .append(0x68b6e683a5535be14a5ce0d5964a0d3266abcc460c7f6868410d638ac30122e);
    layers_auth_paths_sym_1_2
        .append(0x409dd887c26dd9db1474b2c3089c4573492e391044a14ce590fd49ebe462cf0);
    layers_auth_paths_sym_1_2
        .append(0x2c7c3937fa4dfe7f0af0de8a072439e3bc5b42078a2555ede375c6da922e867);
    let mut layers_auth_paths_sym_1_3 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_1_3
        .append(0x387cc8e8cc411f619f600953651885439ce7c8dc14d6b2ec17cbc444ed6192c);
    layers_auth_paths_sym_1_3
        .append(0x60c93bedc5ac553efecff402f2339d91490d0b11757c5644b861fe77d84a34a);
    layers_auth_paths_sym_1_3
        .append(0x612b7cf4d0a6898803652f414158e5fcc78a6a9347359895517b4f031be3f17);
    layers_auth_paths_sym_1_3
        .append(0x5c7df19e366d84728c6fe8d066e19694e986c5cecdc4333e6a94781de7634dc);
    layers_auth_paths_sym_1_3
        .append(0x1f0889ffcf5d039325825cfcf15680518a873210b94853da475aaeef5bb41ca);
    let mut layers_auth_paths_sym_1_4 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_1_4
        .append(0x7afa0689cb598e577e82e0e70a9ebcae972bb0668f61b9ee7c1a35cb0353483);
    layers_auth_paths_sym_1_4
        .append(0x6e28a7391deb4af56d607c6254482bb9736a4fecd641bad60edc72f32afb701);
    layers_auth_paths_sym_1_4
        .append(0x440d96926e97926ce8451177a195a7a423320541f3913ae4057e59e41711810);
    layers_auth_paths_sym_1_4
        .append(0x75ae8d64286c67e8885e750642d16c320b16c7f106fcd1eb9eba314d00f1622);
    let mut layers_auth_paths_sym_1_5 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_1_5
        .append(0x5c8063562c87ddef14185bac0964cd2e4c1dcaaf3eae3e3681637db9e2029eb);
    layers_auth_paths_sym_1_5
        .append(0x243d9270a687cf8c1b1ce6abfeec702412c8e7ca7f3cadaf462b58cb87f54e4);
    layers_auth_paths_sym_1_5
        .append(0x18af8e1c23482edbf9af3d38505271d0bca88e919b5473d9f3e7288c5ab29b6);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_0);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_1);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_2);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_3);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_4);
    layers_auth_paths_sym_1.append(layers_auth_paths_sym_1_5);
    let mut layers_evaluations_sym_1 = ArrayDefault::<felt252>::default();
    layers_evaluations_sym_1
        .append(0x50d0558ce3e0dccc1871e2472052c6fe3c628f8c9771339e5b8847c849c9494);
    layers_evaluations_sym_1
        .append(0x4597416782a0e57b75f0548e17ab93b3e750b9756d3d17f399dcc7b91449a37);
    layers_evaluations_sym_1
        .append(0x6356085f945b6a4d29230f7645ce28834dcda02e172464085fde553d77feb30);
    layers_evaluations_sym_1
        .append(0x1a5ff7c913f29c08a5a77e08151bf8daf0fc599c6ff6cdea65d72abb7e3f483);
    layers_evaluations_sym_1
        .append(0x54e0639d2f45302a497c675984b771f74bb41842af983523baf78f308f0e9f1);
    layers_evaluations_sym_1
        .append(0x44d765909e051d9c6f8bd2af97e0acf393d7a4e70cecd4b5519882d5adc0171);
    let mut first_layer_evaluation_1 =
        0x176ffd7f3c029719629f87deae28d82a280fafe3ac737544d0e7a464315bc2;
    let mut first_layer_auth_path_1 = ArrayDefault::<felt252>::default();
    first_layer_auth_path_1
        .append(0x201570a1cef0a7f11b2290b9f2ea6449384beefa3d37a41968ec37fb0f4b14e);
    first_layer_auth_path_1
        .append(0x1f7d926d8266c4d7ee055f91727ff66b2e73be9e036e4e7741d93aaa937cde3);
    first_layer_auth_path_1
        .append(0x3c8ff72904a6e74dc8946ca81eac1822c9a9c564bb506e0583526d0255680ff);
    first_layer_auth_path_1
        .append(0x464666a20da416b33ccabcea8c6916b3869387d8c6bec1fe9675ffc8fd2822d);
    first_layer_auth_path_1
        .append(0x324e476cf28ff29d0906ad1308e5fc06d451843e427b01fd56e7d602723a8ea);
    first_layer_auth_path_1
        .append(0x69d33d9338a1ec2da18017cbc1ca097760f5039409ec21c798c366d8b97586f);
    first_layer_auth_path_1
        .append(0x1681d4fce0e4542d31e1dc3df641f5fe656c737f39bbeedea4302f0dfa277f6);
    first_layer_auth_path_1
        .append(0x19cdf4016ea48fd0e11ca88ed8cc5a27bd3393bd8f469ff5b7920ee0c980488);
    let fri_decommitment_1 = FriDecommitment {
        layers_auth_paths_sym: layers_auth_paths_sym_1,
        layers_evaluations_sym: layers_evaluations_sym_1,
        first_layer_evaluation: first_layer_evaluation_1,
        first_layer_auth_path: first_layer_auth_path_1,
    };
    query_list.append(fri_decommitment_1);
    let mut layers_auth_paths_sym_2 = ArrayDefault::<Array<felt252>>::default();
    let mut layers_auth_paths_sym_2_0 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_2_0
        .append(0x65058696dcd4471c7ca03c4f6ba2db172e8a10c13de2dd08de0a41f2944a441);
    layers_auth_paths_sym_2_0
        .append(0x903017c2da42f89deb576e1c11064fff70a23876d8205e6802fd6ed8a2fb2e);
    layers_auth_paths_sym_2_0
        .append(0x7fdeb2c580b454fbbb08641dbd2e092c0ab957b3a5ec6be501d46cf2a3061ad);
    layers_auth_paths_sym_2_0
        .append(0x7a2db2516cfe18fc61e10536de3f28b6e31ee85564fdaeb93bc02b4162c20cf);
    layers_auth_paths_sym_2_0
        .append(0x5c976a439e8250580558eb1159b83394bac264f835a91f795d38f4c380ebd5a);
    layers_auth_paths_sym_2_0
        .append(0x76578bb8c5bb3ed0facd71380e8dd23db8b20cf204904d83335884988b0c127);
    layers_auth_paths_sym_2_0
        .append(0x10519908b0f801deb26d5555881bc37d5386831c9128efdbc1a58753dfc4280);
    layers_auth_paths_sym_2_0
        .append(0x19cdf4016ea48fd0e11ca88ed8cc5a27bd3393bd8f469ff5b7920ee0c980488);
    let mut layers_auth_paths_sym_2_1 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_2_1
        .append(0x59883e033b083db0cf60b8c8df300b8bcabf4ccd97113784dce9451450f5f76);
    layers_auth_paths_sym_2_1
        .append(0x77e7844aaa102e5b790b682dad54abb8bb682019af9aef65e98d17403ad05be);
    layers_auth_paths_sym_2_1
        .append(0x2ff7f6faa44b10881a2b43c25cbdadb60a796b1733897e397523abdabe84b3);
    layers_auth_paths_sym_2_1
        .append(0x4671395ad7924971af49017533cc12130b490aceb3d0ce314ee492ea22ee582);
    layers_auth_paths_sym_2_1
        .append(0x32a138bed01c83b7c55b9b55485a4735b2b86ff679f6abc17a4da41583c8119);
    layers_auth_paths_sym_2_1
        .append(0xded45d0fade4f7ed7cd03bd009da15cbb38d170603e43e1187a9040c4c32d4);
    layers_auth_paths_sym_2_1
        .append(0x518f52c6d81e4a3c44c71565c2ca10924b46b4d6ecbb27fd3961fd15289b23a);
    let mut layers_auth_paths_sym_2_2 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_2_2
        .append(0xd7c4bfcefc1868b6e825bb9e91c14bc3687cbc04c70d95ebb5666b3c0ee4cc);
    layers_auth_paths_sym_2_2
        .append(0x7df09be4e8d11685c142d9e5006b018f17f1160b47c92c4947962fc5324189);
    layers_auth_paths_sym_2_2
        .append(0x4f15667b06410c18b71cc11cde7671d2668eb8691ef460cc925b39f06543e18);
    layers_auth_paths_sym_2_2
        .append(0x1549bb1e655d411905d77efc3929d9dd7b06c31d8d5fe64193585d905d9c4ae);
    layers_auth_paths_sym_2_2
        .append(0x4338af5b6649a64dbf938a56ebab903e1528ec6d0d4c0060ec48f4a5c84744);
    layers_auth_paths_sym_2_2
        .append(0x1370df0edd6909bacb7b079b63b22ccf521ad07cbf46a973d01da8bfbb3fc06);
    let mut layers_auth_paths_sym_2_3 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_2_3
        .append(0x5dabba105bb17c6892a0eeacfb3a85fe90c8cf3786ac307f6fa739591aa37a0);
    layers_auth_paths_sym_2_3
        .append(0x50871bb913afd99ee5c7b7b6dd03f6bd45f61a9821f07e9d865f6e818fcb847);
    layers_auth_paths_sym_2_3
        .append(0x6fa5e1cfb6cea6e9a68b477810457083d7bbc211edb77308ebd778f4affa429);
    layers_auth_paths_sym_2_3
        .append(0x6aba89c2b5cb069629f95ea3b8644869dcb54dcc1f4047e46165e0be3af70f8);
    layers_auth_paths_sym_2_3
        .append(0x395d11819fd326ce28cd28290c6463a9653394dadfe523e8e183455af852210);
    let mut layers_auth_paths_sym_2_4 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_2_4
        .append(0x1253b49246c8ee68616a9de84fc3780a392dbf7010fc72ce55f7d966466e9e4);
    layers_auth_paths_sym_2_4
        .append(0x6c980dbbcd9ce8d8631972e654b26faa79a29562984c2941363ce3943b6c3bc);
    layers_auth_paths_sym_2_4
        .append(0x64d872db1be2cefe32ee546d55a619d88328f69afc09d2893c950882191fbb4);
    layers_auth_paths_sym_2_4
        .append(0x6f1476869c2a5a192ff66bcc730c71a2700fa687c656e6f65b1a531c67ff161);
    let mut layers_auth_paths_sym_2_5 = ArrayDefault::<felt252>::default();
    layers_auth_paths_sym_2_5
        .append(0x5d3c0dceba90ea9c504cfcef66f2a368fffd6d1e4dac2f0399adde452ef5cb5);
    layers_auth_paths_sym_2_5
        .append(0x6759ab35eb979ea274d3e0dbe78526079025e4fc800948857362de82eec51bd);
    layers_auth_paths_sym_2_5
        .append(0x18af8e1c23482edbf9af3d38505271d0bca88e919b5473d9f3e7288c5ab29b6);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_0);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_1);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_2);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_3);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_4);
    layers_auth_paths_sym_2.append(layers_auth_paths_sym_2_5);
    let mut layers_evaluations_sym_2 = ArrayDefault::<felt252>::default();
    layers_evaluations_sym_2
        .append(0x913bc9285947a54eda443a897ac33ed496c609de56b0768a8296cbfb4339fd);
    layers_evaluations_sym_2
        .append(0x1fdb29f6097da9cf4980b06a11c7788d1ff2618962ecab8708ad194767a1e0e);
    layers_evaluations_sym_2
        .append(0x6ecc14e599efc112e85509a6af08737ac721ec304801d071e4092f215efc3d5);
    layers_evaluations_sym_2
        .append(0x278aebe230eec947ab7a49d6d6c59453f63009caf7c08ed0ce182b6a4c4428);
    layers_evaluations_sym_2
        .append(0x231fc62c0f4f50da1518c9b9146ae3fb92c0fac90efea56ee6b021d9fb2b6fe);
    layers_evaluations_sym_2
        .append(0x6b289dee08a668d21449b2f06f0fa9370d0072f78731effd284717ca06837d3);
    let mut first_layer_evaluation_2 =
        0x4abc352ff7f605c8be8b8076d9cbcede03521569a61fa7369b2de155ec1d1b;
    let mut first_layer_auth_path_2 = ArrayDefault::<felt252>::default();
    first_layer_auth_path_2
        .append(0xd3fec13f40d9d422f4ad859edfb1d0dbc697a8215badd2e28c42e1e502daf7);
    first_layer_auth_path_2
        .append(0x2c90ab295eb0d8be3444e14f11af67321be71c3790a2076077b201861c280cc);
    first_layer_auth_path_2
        .append(0x622220a81741d2033de7bed0bc15d141c3394b10ebeb564ec16772b7f4553c9);
    first_layer_auth_path_2
        .append(0x35ff45972a766c172ea6dc5aebaf78466054d100b24bfa4ed9041a04a3788ca);
    first_layer_auth_path_2
        .append(0x13468523d09f405f8145cff4d15b329344f8d3fa4085414367d5fdc319a13bf);
    first_layer_auth_path_2
        .append(0x584d92e12e4fdbca8f9c835a9a8a0ded60c54ec96dbf7c06fd21c1237adcb84);
    first_layer_auth_path_2
        .append(0x463c08666bbfc8d3a22d0e1262f2df98a3a9df0f0518f8fc184e6a6ba994584);
    first_layer_auth_path_2
        .append(0x2bdcbf049cf74f107dc1129289379a7409c7e94c9d5f27156e231219c87eff9);
    let fri_decommitment_2 = FriDecommitment {
        layers_auth_paths_sym: layers_auth_paths_sym_2,
        layers_evaluations_sym: layers_evaluations_sym_2,
        first_layer_evaluation: first_layer_evaluation_2,
        first_layer_auth_path: first_layer_auth_path_2,
    };
    query_list.append(fri_decommitment_2);
    return query_list;
}

fn get_deep_poly_openings() -> DeepPolynomialOpenings {
    let mut lde_composition_poly_even_proof = ArrayDefault::<felt252>::default();
    lde_composition_poly_even_proof
        .append(0x3df5bb6104701b5ec0729fe8cfdc18780e9d8db714832ef2be8d9a1e48b0164);
    lde_composition_poly_even_proof
        .append(0x781031348240cf9b2340f38c63a51c647bcd17e26925a23cc3f8fd0cfbe8956);
    lde_composition_poly_even_proof
        .append(0x5bb622f4663f4ec428aad0433bd4b82184e827e2c59d7dd2b220171eef96d2);
    lde_composition_poly_even_proof
        .append(0x5bd1a3a39e50b0e834f7873ea16e08f44285d11ece6aff17a9919cf2eac1d);
    lde_composition_poly_even_proof
        .append(0x42c318c261b0ebc34d43553daa83be3e21b1c537e93511afb6881d5e9a1667b);
    lde_composition_poly_even_proof
        .append(0x7b33c1bf3f8f374e69a15e31261bf532b4cd4dfe5d016ef6e9d8b863a6bcdec);
    lde_composition_poly_even_proof
        .append(0x33eb1d76ec6721dbe3d7692a6dcbe5dacb00ba66bd36d5f71322b1a2be73e6c);
    lde_composition_poly_even_proof
        .append(0x512418044966687eddd451100c2aaf6ca1313aa051a5d8b4a8f880ac1151286);
    let mut lde_composition_poly_even_evaluation =
        0x5921d91b7707cda26d10aa451204d475b0de3cb2fff2e4463f94c3a3e2b1215;
    let mut lde_composition_poly_odd_proof = ArrayDefault::<felt252>::default();
    lde_composition_poly_odd_proof
        .append(0x7a2642f1d018a87c82d3ce1aaacaf4e26dc2e82fbf446d1b61280893183eec2);
    lde_composition_poly_odd_proof
        .append(0x589b7631149bcf5cd210f21d4f77e59c59fe8967618da8e0cbcc14135b0c2ac);
    lde_composition_poly_odd_proof
        .append(0x63106d639fabda5a166f59d3ff2193ed83cff62050b8671d6aa86e641afff15);
    lde_composition_poly_odd_proof
        .append(0x227c47d0d60aa2cfe64d667bf99c998186705a070a1a44732154aacb3dba42a);
    lde_composition_poly_odd_proof
        .append(0x519f711eceb656a439bb6bb3b93c662593d2072d2bd0ce8a343d0ebce6f456f);
    lde_composition_poly_odd_proof
        .append(0xe2868ba4ea9fac5864034271d33811c0688633a35a790154597f5b27d155d9);
    lde_composition_poly_odd_proof
        .append(0x1c34b3f5983c3ecb64c20da7f5eb917d1a36ec0445ab3b2950db4f31b252817);
    lde_composition_poly_odd_proof
        .append(0x33751e9273c5720e2cbda51c54608f0d7fd9b2ff502d6a8ca5f2c34b7eb074f);
    let mut lde_composition_poly_odd_evaluation =
        0x7965ab7298c9cecdfef91a1b23bcdb51282ca7db2a6af36c9407cae555ff2b4;
    let mut lde_trace_merkle_proofs = ArrayDefault::<Array<felt252>>::default();
    let mut lde_trace_merkle_proofs_0 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_0
        .append(0x1c48cceea5267192b99832ca2f0e663a887545a7687b4a002c7f0fad6b444d8);
    lde_trace_merkle_proofs_0
        .append(0x43236c34f50a58a605967d95c3f95f8f26cc50a16d310be992407fa5eb30c82);
    lde_trace_merkle_proofs_0
        .append(0x56a214f7e6b1e30614767ba9c88c4c8e1c84f703a0a282835d1b23874db7aa);
    lde_trace_merkle_proofs_0
        .append(0x1f91794cede3db3015973400cf16134b5f3fa73480ec96bd7ac6c1687ea3344);
    lde_trace_merkle_proofs_0
        .append(0x33994d28f761dbd6ed1389e293e8af32fa13dab869cb035014e2a04460b1f70);
    lde_trace_merkle_proofs_0
        .append(0x9a40720e66e6eeb71ee6789a8f36c1fb8f8e56e34b61c57199370a07a33e04);
    lde_trace_merkle_proofs_0
        .append(0x56e68c06d105dd9bf63557688ab21386bb489542b066b34c7bf78d102d8b600);
    lde_trace_merkle_proofs_0
        .append(0x4557c6bb10effdd2daf6a5090bd69c5e754cda4e0d170be94b71d2bf9fe31ce);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_0);
    let mut lde_trace_merkle_proofs_1 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_1
        .append(0x61543d2cdcd73a153df9d15bc2f603a3b218fffa931435dbfa1d27306118f58);
    lde_trace_merkle_proofs_1
        .append(0x2426cec4f76912aba8ea5aff6cd34457a712ee5e2db2faa5ccdd98a7e7bc12f);
    lde_trace_merkle_proofs_1
        .append(0x56c066ec0326b886db880d886b8ec1e64c6b924df707aad0bed1b5be9843014);
    lde_trace_merkle_proofs_1
        .append(0x5aa61d3213c1409efd7b4ca102a6582949ae7809286ed0aa5f481a7247b74ae);
    lde_trace_merkle_proofs_1
        .append(0x12ba92bd5bc254017b97b7383c3064dfe400f5f3a2ebadaa7cf92a89be765e9);
    lde_trace_merkle_proofs_1
        .append(0x64d241709b28a67a84bec3a6161245ff3910c82c3e714e92fc15db49f7a157f);
    lde_trace_merkle_proofs_1
        .append(0x53ce91277d85f68196c667301acc6ec0d1d71ca7e03a7d14c90dff5b307dbc5);
    lde_trace_merkle_proofs_1
        .append(0x201af412e11644ce36c116debcf80f063f54d84b3df629bb9467b5892b655e8);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_1);
    let mut lde_trace_merkle_proofs_2 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_2
        .append(0x181c466fb5ce9667cb25c79cf87cfaa4304ae9f03ac223b8765f8d9c6563ab4);
    lde_trace_merkle_proofs_2
        .append(0x6e9a5b67112264ada7ce6743b48f61b556ed9ee66e9587d2a2d5932f00dc804);
    lde_trace_merkle_proofs_2
        .append(0x37be08a1054309ded50f5c0011a4983d0285e1eb988331fe6d4cf0b3e5db0b3);
    lde_trace_merkle_proofs_2
        .append(0x5689492826f262d6bb01f1c18418768d924b72cebaef9d2b1e6fd4b61cd9322);
    lde_trace_merkle_proofs_2
        .append(0xcc999e780806789feebabc882037b9bebe077d1d73485a511110e53d4132f5);
    lde_trace_merkle_proofs_2
        .append(0x5e6d562bcac2c60226abb6d2cad39eee8a1f186172e7219f5ad0320549f1058);
    lde_trace_merkle_proofs_2
        .append(0x7b1396a0cff926238ec3d41052af42ae9abfe8af56e2341e773b3e3ea1a165e);
    lde_trace_merkle_proofs_2
        .append(0x3473c9e3ce03b1b894fb45b69218b368ba72e1d1bf13670e4a6e46ec6695b46);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_2);
    let mut lde_trace_merkle_proofs_3 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_3
        .append(0x3c0db67ec0586830498fccc825730950ab466828cbc1dbdb4a0168f913a34a9);
    lde_trace_merkle_proofs_3
        .append(0x1bd3de2cbdd9149697b5597e6e1f002b9ce7578b30ac0d574eb44e928e2368b);
    lde_trace_merkle_proofs_3
        .append(0x7bef9eef71e2d584f8f4086ee7d883d5adc4ce532fd7538a827d3f80b11f0d2);
    lde_trace_merkle_proofs_3
        .append(0x78c006550057f7dd337a878bb2db2d37bc7fd9b2207ba70c2304aa96eb39714);
    lde_trace_merkle_proofs_3
        .append(0x522c6166d6067d1abe48ef31ce62843b0a66ffe47c2fe74cc74cbf3dda990a);
    lde_trace_merkle_proofs_3
        .append(0x400b5cf51d75725a0bef1f0a8fcad17e30e41435f6fe82e4986779f5bf99a86);
    lde_trace_merkle_proofs_3
        .append(0x6d511fe642a97d286723074bfa8771f86c76c214431796368f6708039042add);
    lde_trace_merkle_proofs_3
        .append(0x6ca2a2851e62e8454d399a2bcdcb46386a79746811093f1c5bd58761f0d3b3f);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_3);
    let mut lde_trace_merkle_proofs_4 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_4
        .append(0x76f8410c925a12375f275124b8a284420c74b89d7b628a138b8f624f9ecc557);
    lde_trace_merkle_proofs_4
        .append(0x4e4d590e4b0e786d47d50a1295827b892816fab1591bdb2c583e9e465ccdc6);
    lde_trace_merkle_proofs_4
        .append(0x33636889dc1f7e8f4210ec87cb814dd61f0e4a352090999b4ad3f0082cb9c1f);
    lde_trace_merkle_proofs_4
        .append(0x42d1df87c5b3cd171632a8adfe881dd28b089a41110ee1b744e8f3fa452944);
    lde_trace_merkle_proofs_4
        .append(0x653f5f4ba8bc4c6baf784cf279522228a26e8997e651fb6364faf3d7c239776);
    lde_trace_merkle_proofs_4
        .append(0x77b156b262b6fa2e3340cd5fe36397b843a58a20ca497b04da47f0dfe0c664b);
    lde_trace_merkle_proofs_4
        .append(0x771afd415a1fdfd305c0bceeb94319be05e80183bd6bfe3aa1a273db041b0a2);
    lde_trace_merkle_proofs_4
        .append(0x879f6ee81f5c9a48dfde2357f50210c8e8a08c016fb9609545a0468839f850);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_4);
    let mut lde_trace_merkle_proofs_5 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_5
        .append(0x187e45ac4f1aa72b3898ba8c489cfdec4c5370a322904ede486decba90c1b85);
    lde_trace_merkle_proofs_5
        .append(0x493c8c7e73c4209604ef2a0aa3e7441d194acaef9e7f2bb234926a08dd7672c);
    lde_trace_merkle_proofs_5
        .append(0x7e640121cc66e456a11ed9fe9ee57efa62782aa72c7149e9b845c7a1c119091);
    lde_trace_merkle_proofs_5
        .append(0x493c7161889769411ddcae503db8a5c1ae3504223b78c9e99a561f8bdf48a);
    lde_trace_merkle_proofs_5
        .append(0x232ffc5327ac73b20aa7855da87a18ea1d856ac10420712bca1eed5d5ecc3af);
    lde_trace_merkle_proofs_5
        .append(0x198ff02b32c7e72c28fb2616ce8357be36a5ed84d481fc8aa47cc307e5ad295);
    lde_trace_merkle_proofs_5
        .append(0x69e7f6637bdf647bb0a7276e9f516015182297a1434cc36e3815d6113c2a1a5);
    lde_trace_merkle_proofs_5
        .append(0x12212811a952a613965778f73b2d5edb8fae86ad7e8cbf66430cbbb5403fd5a);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_5);
    let mut lde_trace_merkle_proofs_6 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_6
        .append(0x69e3bed9971dae847a0b2a59bb4b4186fd8f9ca9bc70840d94db40c97916295);
    lde_trace_merkle_proofs_6
        .append(0x65a71d1d0fa6f00a222a34190da204b62a477c44c8aa7544471157872bef323);
    lde_trace_merkle_proofs_6
        .append(0x328ba168c8eb6c8ead8f530f7ec0dfc6fc61670dfbb6b46b661e45d4823872a);
    lde_trace_merkle_proofs_6
        .append(0x10877c1b2f44002e4ea4c9dd513d942989d3ea35eb9077e69005c7216b955ac);
    lde_trace_merkle_proofs_6
        .append(0x5eb8c1acbdc12bafac1f42254a501128db38672a28306a5a656fdaa575b09ad);
    lde_trace_merkle_proofs_6
        .append(0x4b95a20b0b4e9ba6cf184458d3bf757f9e8e9d9561bbb424e12c9906a69c990);
    lde_trace_merkle_proofs_6
        .append(0x35ea512976136fc2d49fb8487e931a4c1a4cd6ad4369d469867ce0455612d3e);
    lde_trace_merkle_proofs_6
        .append(0x249d1ce35433dce52bd6d68fa558397559d136f3a6038709269a602d26c7a9a);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_6);
    let mut lde_trace_merkle_proofs_7 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_7
        .append(0x7d6f7be6c1069aeae247734c504b81d0819a9b948ce7a28f1ed4362f4ceff7b);
    lde_trace_merkle_proofs_7
        .append(0x585cd383e14fb829eb1ddf59919b8da70c2372fc3bd249dcac7fbbab9c4aa4c);
    lde_trace_merkle_proofs_7
        .append(0x32c279e810c8601f61982ceeae6019ef3084ef1a6784e8e70b5ace6991ed846);
    lde_trace_merkle_proofs_7
        .append(0x72bc347909b40480c4c6cfc96ce4e013733d0281389866a19d7bf8957eaf7c6);
    lde_trace_merkle_proofs_7
        .append(0x27babab74ed2b03398d9e6606d7469299a04fafa8b96686ffe3e759ae987bcb);
    lde_trace_merkle_proofs_7
        .append(0x71ec7a53a25a419b20791ec1bb12e661421a730c330b3c6eaa6d8d0ea71b131);
    lde_trace_merkle_proofs_7
        .append(0x50199be2aa728d8fa0fd5478f2a304113f3f463d7ac9a717ac622d5c89c3c8);
    lde_trace_merkle_proofs_7
        .append(0x4c4d776186f2ee81fe9adfbb52ac8ad3593ae7025d63c3c3cb270307db6fab8);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_7);
    let mut lde_trace_merkle_proofs_8 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_8
        .append(0x70f7f49cc167490b841e7616d43a1a7e3b9be0a1a6ffde1314b6fa47d29d9c6);
    lde_trace_merkle_proofs_8
        .append(0x68c6743f58514db424f4101e5eda2439b1c27c220984a77fe6646a6ece977b0);
    lde_trace_merkle_proofs_8
        .append(0x6cda34dd43a208b634222b07b14f3b55a03d6f0973fcc738ee4ee70f2e812ba);
    lde_trace_merkle_proofs_8
        .append(0x6caafc1e08dd83a73fea56e17e631cabb87930efd885cf7616d5adab968800c);
    lde_trace_merkle_proofs_8
        .append(0x791f74bb2820a73fddff71143255266bd161c7f5871ed44bcea34800706b454);
    lde_trace_merkle_proofs_8
        .append(0x15175c40082c58246ddbdd72f66197a69b31b797744a2db2aeb6a2392562451);
    lde_trace_merkle_proofs_8
        .append(0x68770dc7dd820e045d34d72d1a8792e4767f5d96aa5da97e66fa89facad58ca);
    lde_trace_merkle_proofs_8
        .append(0x5280f51d0e4deff83d32e540558173e73be9b278d388b83fa145641f54ae58d);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_8);
    let mut lde_trace_merkle_proofs_9 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_9
        .append(0x4ebb8b601b831a7a6d513a34cb02e4a054d8561b6e007c68a95b2b5fa407e63);
    lde_trace_merkle_proofs_9
        .append(0x2b0d1f1d9ea05e1af440530137b7fc37d705c96e2f948fd00b0e27a60db3db6);
    lde_trace_merkle_proofs_9
        .append(0x7848f1d9046e63cf4dd8f363cfb19a0a517457afefc77eefa51d18f6d9393c);
    lde_trace_merkle_proofs_9
        .append(0x443d9b92efc3faf8de5ff04c9bdc3c5343d397b3d56957b5cf78c7f752cac46);
    lde_trace_merkle_proofs_9
        .append(0x560b6d1ed971c3445c55df0b8ca226067f9d68a31fc56a930e48d145a916c47);
    lde_trace_merkle_proofs_9
        .append(0x31bc4c730285b37053d95f6cebfe0c9d8d7717542d2abb1d4f5caebca2c4f1f);
    lde_trace_merkle_proofs_9
        .append(0x734d88c7e9b663292a93b7cf359f5d4ce346148aec79291c3f3127799d556a0);
    lde_trace_merkle_proofs_9
        .append(0x29479cfe2c2e738978f39bf7f5ee8a1768bdae07aa755954efbc6445bce4a56);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_9);
    let mut lde_trace_merkle_proofs_10 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_10
        .append(0x69e3bed9971dae847a0b2a59bb4b4186fd8f9ca9bc70840d94db40c97916295);
    lde_trace_merkle_proofs_10
        .append(0x65a71d1d0fa6f00a222a34190da204b62a477c44c8aa7544471157872bef323);
    lde_trace_merkle_proofs_10
        .append(0x328ba168c8eb6c8ead8f530f7ec0dfc6fc61670dfbb6b46b661e45d4823872a);
    lde_trace_merkle_proofs_10
        .append(0x10877c1b2f44002e4ea4c9dd513d942989d3ea35eb9077e69005c7216b955ac);
    lde_trace_merkle_proofs_10
        .append(0x5eb8c1acbdc12bafac1f42254a501128db38672a28306a5a656fdaa575b09ad);
    lde_trace_merkle_proofs_10
        .append(0x4b95a20b0b4e9ba6cf184458d3bf757f9e8e9d9561bbb424e12c9906a69c990);
    lde_trace_merkle_proofs_10
        .append(0x35ea512976136fc2d49fb8487e931a4c1a4cd6ad4369d469867ce0455612d3e);
    lde_trace_merkle_proofs_10
        .append(0x249d1ce35433dce52bd6d68fa558397559d136f3a6038709269a602d26c7a9a);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_10);
    let mut lde_trace_merkle_proofs_11 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_11
        .append(0x42a9115940289cf6f294af0b90a6b46c0c3b9774dc5a9295b1fb7d004a2ee9b);
    lde_trace_merkle_proofs_11
        .append(0x7a95c780c02138c9ed05c76ed7806e20bbb484dc977ee5505426e2b047d9737);
    lde_trace_merkle_proofs_11
        .append(0x202fac9023d297a58808d670a94132604566cd4cbca7198d4c3c07044aa12cb);
    lde_trace_merkle_proofs_11
        .append(0x2eb3ff43f59b7394cf58a17b3a8c8cadb5f09674518d486e52c39c2845327cf);
    lde_trace_merkle_proofs_11
        .append(0x144edb1201ee73690c2a131e9ea98de837186d48be5d1fb10a72fcfae2c491d);
    lde_trace_merkle_proofs_11
        .append(0x1ff58c94c4eb46f6279f7324ea8d1943d92e45f47770774d94b3953ad2b06d8);
    lde_trace_merkle_proofs_11
        .append(0x3b666a9a06ea91624d3794a01d1ccfaec89b9ae4fbca153b29d3455a7a41e68);
    lde_trace_merkle_proofs_11
        .append(0x697b54fae02cd3277ade21df29eae3deba1af9081da9dff7d72a590102a2c66);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_11);
    let mut lde_trace_merkle_proofs_12 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_12
        .append(0x70f7f49cc167490b841e7616d43a1a7e3b9be0a1a6ffde1314b6fa47d29d9c6);
    lde_trace_merkle_proofs_12
        .append(0x68c6743f58514db424f4101e5eda2439b1c27c220984a77fe6646a6ece977b0);
    lde_trace_merkle_proofs_12
        .append(0x6cda34dd43a208b634222b07b14f3b55a03d6f0973fcc738ee4ee70f2e812ba);
    lde_trace_merkle_proofs_12
        .append(0x6caafc1e08dd83a73fea56e17e631cabb87930efd885cf7616d5adab968800c);
    lde_trace_merkle_proofs_12
        .append(0x791f74bb2820a73fddff71143255266bd161c7f5871ed44bcea34800706b454);
    lde_trace_merkle_proofs_12
        .append(0x15175c40082c58246ddbdd72f66197a69b31b797744a2db2aeb6a2392562451);
    lde_trace_merkle_proofs_12
        .append(0x68770dc7dd820e045d34d72d1a8792e4767f5d96aa5da97e66fa89facad58ca);
    lde_trace_merkle_proofs_12
        .append(0x5280f51d0e4deff83d32e540558173e73be9b278d388b83fa145641f54ae58d);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_12);
    let mut lde_trace_merkle_proofs_13 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_13
        .append(0x7d6f7be6c1069aeae247734c504b81d0819a9b948ce7a28f1ed4362f4ceff7b);
    lde_trace_merkle_proofs_13
        .append(0x585cd383e14fb829eb1ddf59919b8da70c2372fc3bd249dcac7fbbab9c4aa4c);
    lde_trace_merkle_proofs_13
        .append(0x32c279e810c8601f61982ceeae6019ef3084ef1a6784e8e70b5ace6991ed846);
    lde_trace_merkle_proofs_13
        .append(0x72bc347909b40480c4c6cfc96ce4e013733d0281389866a19d7bf8957eaf7c6);
    lde_trace_merkle_proofs_13
        .append(0x27babab74ed2b03398d9e6606d7469299a04fafa8b96686ffe3e759ae987bcb);
    lde_trace_merkle_proofs_13
        .append(0x71ec7a53a25a419b20791ec1bb12e661421a730c330b3c6eaa6d8d0ea71b131);
    lde_trace_merkle_proofs_13
        .append(0x50199be2aa728d8fa0fd5478f2a304113f3f463d7ac9a717ac622d5c89c3c8);
    lde_trace_merkle_proofs_13
        .append(0x4c4d776186f2ee81fe9adfbb52ac8ad3593ae7025d63c3c3cb270307db6fab8);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_13);
    let mut lde_trace_merkle_proofs_14 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_14
        .append(0x131f03b787ac7c200c4f5a35be85fa659404ff6305a79969ae91b6bd62cc93c);
    lde_trace_merkle_proofs_14
        .append(0x24ede40437b64869897115487b5e24aefaf7586da01b3c8d6359b147df94777);
    lde_trace_merkle_proofs_14
        .append(0x2fa1f9053179667c170ffa3a2bbd264f62fbdd8370a9ee23e3ac637f963ec88);
    lde_trace_merkle_proofs_14
        .append(0x39fa1c243f14f53a9af67976e069ffab708554d4d5bedca9ea34d762314d7ef);
    lde_trace_merkle_proofs_14
        .append(0x6c7be2c60d70ef60d669cea374616287b78376b297aaf3739cdac861d1c8d93);
    lde_trace_merkle_proofs_14
        .append(0x2acf7977cf500f153da29bfddcadbe560e958cb3088ce8af438c8e2d5792772);
    lde_trace_merkle_proofs_14
        .append(0x6beb3e891da1fd5289c7aee16cb1ec52400fcb2115ee03052f71bcb7bb4fe92);
    lde_trace_merkle_proofs_14
        .append(0x7748b51024f76ad2d1f28ada0d9e935b8726feb15b1ebeeb7ac1426176dc3b1);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_14);
    let mut lde_trace_merkle_proofs_15 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_15
        .append(0x69e3bed9971dae847a0b2a59bb4b4186fd8f9ca9bc70840d94db40c97916295);
    lde_trace_merkle_proofs_15
        .append(0x65a71d1d0fa6f00a222a34190da204b62a477c44c8aa7544471157872bef323);
    lde_trace_merkle_proofs_15
        .append(0x328ba168c8eb6c8ead8f530f7ec0dfc6fc61670dfbb6b46b661e45d4823872a);
    lde_trace_merkle_proofs_15
        .append(0x10877c1b2f44002e4ea4c9dd513d942989d3ea35eb9077e69005c7216b955ac);
    lde_trace_merkle_proofs_15
        .append(0x5eb8c1acbdc12bafac1f42254a501128db38672a28306a5a656fdaa575b09ad);
    lde_trace_merkle_proofs_15
        .append(0x4b95a20b0b4e9ba6cf184458d3bf757f9e8e9d9561bbb424e12c9906a69c990);
    lde_trace_merkle_proofs_15
        .append(0x35ea512976136fc2d49fb8487e931a4c1a4cd6ad4369d469867ce0455612d3e);
    lde_trace_merkle_proofs_15
        .append(0x249d1ce35433dce52bd6d68fa558397559d136f3a6038709269a602d26c7a9a);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_15);
    let mut lde_trace_merkle_proofs_16 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_16
        .append(0x6006aafd8c221fd049e0e2803916d2aa8877bbd95c49fe942fd91f698c75a64);
    lde_trace_merkle_proofs_16
        .append(0x2c16f31e07e01f1ce83e80035b23ccbed4d2d7f4714306255fb6264e2c0e4e3);
    lde_trace_merkle_proofs_16
        .append(0x268f9828a9b844696d6f29693fb11c2e9576b2852b6cafe14f9fa92ae2b7016);
    lde_trace_merkle_proofs_16
        .append(0x5b2afd6a71f308838c293af057b8c0327ac6039a497fd4f22ca31f0ce74de8b);
    lde_trace_merkle_proofs_16
        .append(0x1fa686fab9caa11ca4641d1ccf2107aeca02aef5143130e29282a7db9e4cba7);
    lde_trace_merkle_proofs_16
        .append(0xe702d947492f6e2bcb046cdc95720841d25c15998464e3d4bd0f7fdc8b2627);
    lde_trace_merkle_proofs_16
        .append(0x2927e6a5ccc51fac24dd7d8c526e160e97920e67576977c954879e0faa687c0);
    lde_trace_merkle_proofs_16
        .append(0x1797a4068c11dd22f9198d1d36f333a8f6b1b3b3aa3d8696d1c75cd31f703c7);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_16);
    let mut lde_trace_merkle_proofs_17 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_17
        .append(0x696f98dcb483dfa6c3fb1c2b86c55965547b1de817750ec9aa2fac0f6d11d30);
    lde_trace_merkle_proofs_17
        .append(0x39b7dda813bcba8dfbb8023ac8b36c48bc45449c67ff025a134a03662c1fa31);
    lde_trace_merkle_proofs_17
        .append(0x37b2f6a51cb46c60b5abd9c2aabcb509cc0a48f6af159054f48756310684e37);
    lde_trace_merkle_proofs_17
        .append(0x192bc69d90c0178dd4464278aea4bcf9bbae1295ae4fd23282b68f9c55e9cff);
    lde_trace_merkle_proofs_17
        .append(0x2bc87b66519629101f85c7d4868ce0c6bca4f3190071e2c644e77a0dacb95ca);
    lde_trace_merkle_proofs_17
        .append(0x2dac760b55028ac01df250edacabcfb9a5e1523373472b1427d66bb6b8eb363);
    lde_trace_merkle_proofs_17
        .append(0x1340a3b9c47d04176aeabb5409df59e8b59898b470a91cfa002e434d712be09);
    lde_trace_merkle_proofs_17
        .append(0x7535d86c3e9dae73fb86e82e893360bec387a76108923f07cd94efef7db9052);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_17);
    let mut lde_trace_merkle_proofs_18 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_18
        .append(0x4eae9ebaa49b6fa9479869338a9118f7b92e0a4be8a44197297452ab79d3039);
    lde_trace_merkle_proofs_18
        .append(0x21e735dbd6b21873657f7fe683c01375d24c52bde5c28b9a505f0b5bf38c47c);
    lde_trace_merkle_proofs_18
        .append(0x183fe07a557beb6667f1bc432e564e04efb339c942726c99051e3c065085023);
    lde_trace_merkle_proofs_18
        .append(0x7bd587b8bd252b5156a8f1b334f7276332094d0a41223c96309f497b6f763e2);
    lde_trace_merkle_proofs_18
        .append(0x598cc29f75f5a0420de8cfa35644a952c00e1515f5c3bf45a39afa46efe41d0);
    lde_trace_merkle_proofs_18
        .append(0x5a8ff91548344069da1d1a9464669c3d1e1177731573aa1b66478d18211b44b);
    lde_trace_merkle_proofs_18
        .append(0x459b405e2e2fbe253172be464892eb32a36a02dc79b69842bb5513cf42e0207);
    lde_trace_merkle_proofs_18
        .append(0x1d41ca1eb544501feb8bf2d9ca18cd4e7b3641c04f138297465545634b4bf4f);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_18);
    let mut lde_trace_merkle_proofs_19 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_19
        .append(0x18e76598ed2ba6d95fd7dbf4a40044eecb3c268a544042ada1c889b9c004a55);
    lde_trace_merkle_proofs_19
        .append(0x1cff96939d56916cb227cd5eaf6343c7df2a8e8c1b6d53ac5027005f9bafb15);
    lde_trace_merkle_proofs_19
        .append(0x1f5ce005d76b8f2a7bebacaa66fd319349927676cc698eee96523717a33ed50);
    lde_trace_merkle_proofs_19
        .append(0x45c09c85d5fd0b491842b735e8f7fff2c5e78ec0a219819fb375ccc656f8e2d);
    lde_trace_merkle_proofs_19
        .append(0x5df8feb2f946dd0edc088735be61807179e5ba8c8a30ed5022921d83b7c1fc3);
    lde_trace_merkle_proofs_19
        .append(0x35a38024b2eb278c592eb812ff72be0e6697630b88d26d4427c332c028e1715);
    lde_trace_merkle_proofs_19
        .append(0x36e8bac5b5c70eea91f4e80c5859eb90c098ef784e382e0536df36cd2e61af0);
    lde_trace_merkle_proofs_19
        .append(0x5d0ecbaee2eb43c8b6376e00ef5466c8f3a1c94290d84254bec3299bdaa704c);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_19);
    let mut lde_trace_merkle_proofs_20 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_20
        .append(0x426e29c621a8d00c0f5e702eb71aac2038ae9c0c439a15f1a73918ecab39dbc);
    lde_trace_merkle_proofs_20
        .append(0x119c6ac700b421ac40ec74f79da6d7d486b71d6f3561eaa2df36d328f229d97);
    lde_trace_merkle_proofs_20
        .append(0x79d47c01cc89de4932161f5324a82bfcb5598c7c7dc8fe476106c58e99b9a1);
    lde_trace_merkle_proofs_20
        .append(0x3da4a02238e7fa77bd0e4e375de869956de226ec3680da8987729f43f20bd0b);
    lde_trace_merkle_proofs_20
        .append(0x5e1bda51629a03434eeafe2e34dc2a9db438fd6e8b34fb3990fb357f8ed40c8);
    lde_trace_merkle_proofs_20
        .append(0x3f1b3895099ce3154a8b6137c46feae3d1693909ba3b59c8492e5306a394437);
    lde_trace_merkle_proofs_20
        .append(0x642ff1284f8b9f57d66c37c928f393ed58cfaac34044f71b09ab1e7de670145);
    lde_trace_merkle_proofs_20
        .append(0x1556434500aa7ce18c7f977681bca4f2c90195c70510b3e127d5871bb36354b);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_20);
    let mut lde_trace_merkle_proofs_21 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_21
        .append(0x23d28db8b53e48a95af0575219d6a202feb94d036554f1b9d24ce547cff5f79);
    lde_trace_merkle_proofs_21
        .append(0x555f46c89f7bcdcc0942358f9cf89b9d5c25470be473b12d403ca6476ccd32d);
    lde_trace_merkle_proofs_21
        .append(0x5b924b78601300f0a0db53a6872267d7c7a61b9ad85ad9c86c7b38ba4989058);
    lde_trace_merkle_proofs_21
        .append(0x1e3c48c1840af96ad88f86c0ad491d45b3c11bc9d5ade1e2f45c14d1cd1dae3);
    lde_trace_merkle_proofs_21
        .append(0x36b8a3eb4c783ad316cb9f1a96fdf7ce2d914900fe26613a4f9c06ece1f650f);
    lde_trace_merkle_proofs_21
        .append(0x42a9e9c943aad31b107c0f06e9ea7a0760147c9cbe86cf199ac29f2184790c5);
    lde_trace_merkle_proofs_21
        .append(0x9f0d145dfb751f568e756a6421b316676bf1a7acad12a8b2871325e447a84d);
    lde_trace_merkle_proofs_21
        .append(0x2374da9cd5d73b61b99d8a76a99aab858a320bcfd9abec36b0166c67ca89922);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_21);
    let mut lde_trace_merkle_proofs_22 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_22
        .append(0x183b8c964ee23256211eb510f91fd300ea8e151d5af951c309800d8d58071a0);
    lde_trace_merkle_proofs_22
        .append(0x7f2dd8c1cb4ce9e53b7d0e72dc724b132515a8fbd380d4e526038717dbc5068);
    lde_trace_merkle_proofs_22
        .append(0x240d1eecb088d327942edba61c64f0e24782912f047110cc8b3eaeba9bb43a6);
    lde_trace_merkle_proofs_22
        .append(0x14b73e0e2ca3ad06ec3c450a253b6c4433bebedc57facdfd7bd99f394329dcf);
    lde_trace_merkle_proofs_22
        .append(0x18e0f957e0e212178c6d98a5d90588612ccdd9c91941220cb1184262ef00471);
    lde_trace_merkle_proofs_22
        .append(0x6ad2f8ad87951723750ada302a4ba2e9c02b60de7b957557e756d06dd6d2d09);
    lde_trace_merkle_proofs_22
        .append(0x6e883c43c489a4f176e0cf0f732dfb4995373e48b55cf17f8a4ea961451822d);
    lde_trace_merkle_proofs_22
        .append(0x4d5ac98ba1c16668b798d8fd6c949ba8845ee39539bc1b9c6a12d2321e4d50e);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_22);
    let mut lde_trace_merkle_proofs_23 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_23
        .append(0x817dd3c060b2305dcd53462c627595e00682781565772394b9bdff26a9d4dc);
    lde_trace_merkle_proofs_23
        .append(0x5e3a76c7e0faf86ae41b8db3cb7922d459b6153a92809be2a4fef6998db0f04);
    lde_trace_merkle_proofs_23
        .append(0x350174c15b027f7b862e84763fc84dde3759f399429298d87bf14b0d6998cde);
    lde_trace_merkle_proofs_23
        .append(0xe6b1eb2c5d2bceecded9212f0be27f8c8ffa1dbbb796c5c304e8794e7fdd2a);
    lde_trace_merkle_proofs_23
        .append(0x2c80a33a41b65040285c12d65defb7eb84f27b22a683f4326a2c4524c532d2f);
    lde_trace_merkle_proofs_23
        .append(0x56333680ab675fc5bfe74513b18906af9655c1109f3db05258e4576483523c2);
    lde_trace_merkle_proofs_23
        .append(0x7409f4eb145dad6583a497ba79b1cbd2c49b777b970628143fc99c621b40a89);
    lde_trace_merkle_proofs_23
        .append(0x68dbfe1556c2ce044bc9f94892f531033e80d61a62809fe5cd1c8329f6bf087);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_23);
    let mut lde_trace_merkle_proofs_24 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_24
        .append(0x173ca3271c4be531533053dbccdd1422ecde59365d6b628ec5cbd985c83c431);
    lde_trace_merkle_proofs_24
        .append(0x7f78f28b31a9606c41a553a6f09351974c15240168dcc278417d556a1316581);
    lde_trace_merkle_proofs_24
        .append(0x137aa617307bc9f26ed26b28f2397b6540e57b547a72a8955a8ccbfe62106d5);
    lde_trace_merkle_proofs_24
        .append(0xfbd07725e228f22f6bc20fdd1cecdf7937f69d2c61b7620f8293ba8567431a);
    lde_trace_merkle_proofs_24
        .append(0x556c57cc5ad6fb0a1ab81b9b176b8227c75ffd7d264e71d6e777ce3a5a8f72);
    lde_trace_merkle_proofs_24
        .append(0x2990cabd8c795e64970f0a56f1896d1490aa2836ab0397469a70feb5b2bfa2f);
    lde_trace_merkle_proofs_24
        .append(0x67eb1780fbeb20c5cb3064dfb62ed0bdcfa4cf198eca7ed2419a18840670783);
    lde_trace_merkle_proofs_24
        .append(0x39b4bae8ae084e7e4ea65e704df0bbb10e417e59b9fa5b3d0f9dfb71a0aaa72);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_24);
    let mut lde_trace_merkle_proofs_25 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_25
        .append(0x229af9161c4d87121d8b46020b1d27e9e1471023825fb48080a647417fa948e);
    lde_trace_merkle_proofs_25
        .append(0x30d1cfe46401899f67eb736668777ab559be8c0b48650de2461564745cacb24);
    lde_trace_merkle_proofs_25
        .append(0x552c0b43211722443a9baf708f450c71cc0a6b236ce23dfde608bec2b512fb);
    lde_trace_merkle_proofs_25
        .append(0xab6e690456b240dd3cfa4505bed9a2df6231459f7ecd8e2e7ffa289006c4c1);
    lde_trace_merkle_proofs_25
        .append(0x49a01a814e89b56d0823848f8bfa44c6a819e91f9fe9c95847cf8c65a934d15);
    lde_trace_merkle_proofs_25
        .append(0x521d25fbff00145cfeb700046d538c6fa7fa65cabfc11a96958b148069d3b86);
    lde_trace_merkle_proofs_25
        .append(0x1ee111c7917a50f249673cb05cd937548bdf8a36ab76353037549a0eb0ddd61);
    lde_trace_merkle_proofs_25
        .append(0x63a69168b087239818e606b61a37aa9c7b3e353e4be01ae386b43bda0bb6d2d);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_25);
    let mut lde_trace_merkle_proofs_26 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_26
        .append(0x71ffd42bbfc3d2950be1f915baf90700242e9a12427ac165383c2f8c8f0fbe4);
    lde_trace_merkle_proofs_26
        .append(0x4b7886e451221846903eff1873f7cd4652f1f87d44bb0afcf60bdf76f259576);
    lde_trace_merkle_proofs_26
        .append(0x7eda6892981dc76c4f5380dc986c9a4d099be68ddf78f4f9cbf52b4f5fd6d32);
    lde_trace_merkle_proofs_26
        .append(0x7f2561eaf26c40dc00613dd63961d1260bfc373e8448c01daa088d50ff1c1bb);
    lde_trace_merkle_proofs_26
        .append(0x21f86d326c941521d4d73bd35e568ed8913d7860df3b581c438a17447fb75d3);
    lde_trace_merkle_proofs_26
        .append(0x1a00e24cc68853e451994303a5545e5f4178f677bc648df78a54ff52bcff876);
    lde_trace_merkle_proofs_26
        .append(0x7f5b5ca4c74a162d2d29bc268acc405c23e81374b3d6a8d6443a8622129e5a6);
    lde_trace_merkle_proofs_26
        .append(0x30785041136e827df053e0aaa34c38b0e95635af5770258669821c0c9023f19);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_26);
    let mut lde_trace_merkle_proofs_27 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_27
        .append(0x49cbc70fac0e811abd906793099ca094c4afe78a4c6b06170ffcc631bb72111);
    lde_trace_merkle_proofs_27
        .append(0x6c8da15fa06a1a855a6ccba7d669d37e536d19b364836c0d18e4868142bc10a);
    lde_trace_merkle_proofs_27
        .append(0xfec29cc421377580a3e0ed132095f866133b744af807ef101ab87387baa378);
    lde_trace_merkle_proofs_27
        .append(0x5fee1aea3d3a44efd7a02fb29c2178af6194b42b608840d35e9f5ab1875a8e);
    lde_trace_merkle_proofs_27
        .append(0x796d488f2c8a12f3fe1d7108f825fc5d960316eb9f48220978486980b72c48c);
    lde_trace_merkle_proofs_27
        .append(0x3e50cf4c38270b1512c787290366ce09d5bec151e967e67d980fbe68115327b);
    lde_trace_merkle_proofs_27
        .append(0x27b35a4210b231bab45cb41231b5dfa4ac42ce5a6d8eafc953622ae39778772);
    lde_trace_merkle_proofs_27
        .append(0x7efeff75450bdbabaca5768721be41d25919cd142b365dd7a223cd1a4113c40);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_27);
    let mut lde_trace_merkle_proofs_28 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_28
        .append(0xebba6117c5bb9557fb521ff3001a85eea0a93e4b730311350c6ec2e52600d);
    lde_trace_merkle_proofs_28
        .append(0xb04e4db5f20e0ad5302d1e8221340ca6edab3e692a6bb48f3eddc4a00e9d4c);
    lde_trace_merkle_proofs_28
        .append(0x4d8f70fee7e135b4488aff6747e00f2aefcac053b1b3f326402474dbb5893f8);
    lde_trace_merkle_proofs_28
        .append(0x3cd1b5f31e86027d31ea530156597f256b2ecbaeaeabe4f478d79e8b1b6d4b5);
    lde_trace_merkle_proofs_28
        .append(0x7aab7f66a2b47c970d12f4a35f1c130fb61f854ffa1d76f0790541876fe8a0d);
    lde_trace_merkle_proofs_28
        .append(0x2554dad850d88d6798b0a3d46e36eec653024a904c02bfc23bfcf07264c2104);
    lde_trace_merkle_proofs_28
        .append(0x78948d9a1b8a29d7d0470a8cf721ade1507b4dbc4b0cdeb30f68b60a7f150e8);
    lde_trace_merkle_proofs_28
        .append(0x8155a694c0ac6e3872977b3ee6658524c200d625aea906567b8519b459e30a);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_28);
    let mut lde_trace_merkle_proofs_29 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_29
        .append(0x598a66c59fc906746fcc9973871cb9517b542a2dd183d59f73d3ddd5754c92e);
    lde_trace_merkle_proofs_29
        .append(0x4488a6ef748b34bf729ec6d9274136d9d15160201523d3933f7d86693c050f5);
    lde_trace_merkle_proofs_29
        .append(0x61e2d5d23d75ba4235c401aae0219564aab8c7df752a80ad25fde22e7b798fc);
    lde_trace_merkle_proofs_29
        .append(0x7e49ae1a428e23740e793fed0e1f356c6d9a6b2b890bc092703030d773b0fb6);
    lde_trace_merkle_proofs_29
        .append(0x27c674fa746c711ab09b8a7b1f9d8ffd2e9d1e2d330164820f4134264305a38);
    lde_trace_merkle_proofs_29
        .append(0x7fdda92ed6bacae0e7c5c12d73a5aeff085f1977e8a07d51cfddc8623ae4d5b);
    lde_trace_merkle_proofs_29
        .append(0x3fbe4eed65e427379bd2525e8827d6b8a2fb190e1cdc540bf84ccbc7c137d50);
    lde_trace_merkle_proofs_29
        .append(0x340baf1b061e1b50e250ba146bff7074a7eb5dbd13dea18c80a0f82f78f9854);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_29);
    let mut lde_trace_merkle_proofs_30 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_30
        .append(0x2972128ffeb25c0f2ea4e4b1e634d08d3d1197bc7effa79db3a356c112ea7a6);
    lde_trace_merkle_proofs_30
        .append(0x504b820dd3e7085cb599f3729d363c18bd87eab4c3e90123f5df63f9c809b0b);
    lde_trace_merkle_proofs_30
        .append(0x7a7da1ce38fec0d0fa97127015cc7083cbdc1e9d7e5680c805f0d47a6013acb);
    lde_trace_merkle_proofs_30
        .append(0x5d7a2b0f3e68c58d3cd59491921db57b4b51f55e0f373a049504aaf1cb1bb7);
    lde_trace_merkle_proofs_30
        .append(0x2f0517852943234e623ea2d36aaf2682524d59d940079392f695337becb6ec1);
    lde_trace_merkle_proofs_30
        .append(0x112fd688ebd888f30a1825c5ea621559878bc4876ad61c9ffdb74a0e43a7c9c);
    lde_trace_merkle_proofs_30
        .append(0x47ce7644c43c07da9ca458a080065a2700d8b1463b9f2c250d709c33f54fc2b);
    lde_trace_merkle_proofs_30
        .append(0x4201d7f03ec524e4f2a9d8e96b881fef937bb40e205ce932f5bdfa150e4bb27);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_30);
    let mut lde_trace_merkle_proofs_31 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_31
        .append(0x7f0d847ed47f710f1c74b2fd7c189e0528d70a362fbffd98c3769d4b01a780);
    lde_trace_merkle_proofs_31
        .append(0xf965f28ab2c1fe95722d27b71a7f647c68d45072dd103604385c6b5f641019);
    lde_trace_merkle_proofs_31
        .append(0x4f086290fdd2fa21a9ff0644cc185ada39fbebde2da191158f6f8c1e30954b2);
    lde_trace_merkle_proofs_31
        .append(0x60ec1a014105ad6770c27e78dd568d9122839a559cc173945e400249dd1072b);
    lde_trace_merkle_proofs_31
        .append(0x1931e6f4a68887d2e15e077564ce795eaf5ffc921350947980d32417a93d590);
    lde_trace_merkle_proofs_31
        .append(0x7658e35d63b23d80a7735241697640e8635a472939ec81c4ee63fae92e9fa74);
    lde_trace_merkle_proofs_31
        .append(0x474ebe1552a4de7e7de75c1abbb9e8198bab4493b45f8b88a4ef2f0e1744715);
    lde_trace_merkle_proofs_31
        .append(0x7f8c66f5a9f9251971a177d4416f7012ac16598a04eae0a8f1f228029dc8489);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_31);
    let mut lde_trace_merkle_proofs_32 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_32
        .append(0x7a20e27d265b4c454f8e83d508454deed3946d171b225934ac04fa854414b8f);
    lde_trace_merkle_proofs_32
        .append(0x3ceb0fde7b84227b9d58d5d28d249b12a216e7d03f625e231d2b2828718f488);
    lde_trace_merkle_proofs_32
        .append(0x13311095ac4aafeec961989a669414498cbf9a1ab4c035e3c785f8cde196140);
    lde_trace_merkle_proofs_32
        .append(0xda71978abee74bbc5e504b644f67dd4e246d6f1bb42642f52cff766683510c);
    lde_trace_merkle_proofs_32
        .append(0x2ce36ca2589f5211b2df85d9ba8f20f0020302464bac96d30d8d82a8d454355);
    lde_trace_merkle_proofs_32
        .append(0x11ec0e71ea018ac145c3800e7ea88db1fa460e01b55809504decb17de6736af);
    lde_trace_merkle_proofs_32
        .append(0xa5480a38f437dfd3590e4a96a4f2fdec7a8556a6218a43112d8c63ef817454);
    lde_trace_merkle_proofs_32
        .append(0x7faf339961c740b204d86f6edfdf4103e9264610e7cf9fd9ed091e9c43594ab);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_32);
    let mut lde_trace_merkle_proofs_33 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_33
        .append(0x5a9f898ae68cca72bb44962b17ee6b9da61c4da09e73620e83338e660d9395b);
    lde_trace_merkle_proofs_33
        .append(0x249c978d3a88f42ddfbca38a3257519eb27d5971a5d808f90c945943210a9e5);
    lde_trace_merkle_proofs_33
        .append(0x389574a9defed292346d573015abe3ad540b2180d43ac69a839be334dfb9947);
    lde_trace_merkle_proofs_33
        .append(0x5495e1268d66d336e51165e6189948539cfc379055946d3eb8bb257d7d32894);
    lde_trace_merkle_proofs_33
        .append(0x723934367b63dd836d2ab35566a3f2914fe94e073d686a6bd2aebaa8e479f4a);
    lde_trace_merkle_proofs_33
        .append(0x11c5010f12c9b34cc90229e59c1aa594791120dd1485ddb9fc6daea81142dc1);
    lde_trace_merkle_proofs_33
        .append(0x363da87092af4b90b947b03262ca5dfbd5eb9ea74870f035e9cb2f7e38e952c);
    lde_trace_merkle_proofs_33
        .append(0xf84ad42ab771921bb392a8eded15281e659394236d539add77bbcf698b4075);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_33);
    let mut lde_trace_merkle_proofs_34 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_34
        .append(0x2b1dfe342b4081942ec565c142a1baa159f981036c0cfcf7e08574f6f0b33f0);
    lde_trace_merkle_proofs_34
        .append(0x598d1b9e3d55ca9b6185d6ff63ae2372783315f75d13219e977cb04e32572f0);
    lde_trace_merkle_proofs_34
        .append(0x50b92329119ba2417510e70e6d695e229ac893bb6ccdc2db020a41e49b7bd6c);
    lde_trace_merkle_proofs_34
        .append(0x7de07ea547f195f80689eaadf83a7ed4a3638ff89515e8108fdef10d5d04a94);
    lde_trace_merkle_proofs_34
        .append(0x435249e302637ad52d47655b76223c7bb096597a892fce6cb0d9d9ee4acb30f);
    lde_trace_merkle_proofs_34
        .append(0x1e52d520fcc4acc49e55c8ef6cb35c534155348206dcc4904a39cb6e8bf116);
    lde_trace_merkle_proofs_34
        .append(0x75bf64ce69387ed06154f9150df43c69000f259353a5484d48dad9bc0a26af6);
    lde_trace_merkle_proofs_34
        .append(0x6d907ae9d6b0cfb7de4d85e0c250d2bf9dd1d07cd3c13cbc37d8375a5b9b6aa);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_34);
    let mut lde_trace_merkle_proofs_35 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_35
        .append(0x2d85d0126e9fe7c1bfad4204165e723c033bf02c71d28706b16b06f5e24e19e);
    lde_trace_merkle_proofs_35
        .append(0x259a6cc90951f972c15f588b6a666ab86b1af8e42c48ea5c8da900c6ac194da);
    lde_trace_merkle_proofs_35
        .append(0x78c146ce7248e361fe4883a55efa73a20ecd21622f3e68b50b7f867dd636394);
    lde_trace_merkle_proofs_35
        .append(0x3110281f7f514970be24fadb14ed7cf544243aa6054014a7d7158cb224afe40);
    lde_trace_merkle_proofs_35
        .append(0x2b53a9c7a11f81fa5cd16ca77b40d023242c0570ab419bfea4a5165ee17d2fe);
    lde_trace_merkle_proofs_35
        .append(0x7b8e5f604ad4dc58258634e6457ea9da5dbb31ee47c897a400edea42f753917);
    lde_trace_merkle_proofs_35
        .append(0x2f0ef95ae369fba84971abea01ba746dd5814d9b64e1af1e195fd4a2ca6d76c);
    lde_trace_merkle_proofs_35
        .append(0x3205796434f50b0c425d6876d504e3f3c7518b4ec8a09b2c09d5045bc4aab18);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_35);
    let mut lde_trace_merkle_proofs_36 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_36
        .append(0x4bed97408dcc17e7f7afeeec71d5c075670828cf8084b3ee8d2d63969f8283a);
    lde_trace_merkle_proofs_36
        .append(0x4bbdb93b736b0cd3d78032a8bc8e79890042e5ceb65202e76f6fdf152d21fc5);
    lde_trace_merkle_proofs_36
        .append(0x4d146b3be215dce2512b6ea2acf134812840337234478fb8184e2c4e0499467);
    lde_trace_merkle_proofs_36
        .append(0x7817b8e1617cd9554be03dc51307e0d5ed5dc3fb7b8e57be67803fba622caa5);
    lde_trace_merkle_proofs_36
        .append(0x77cce4f3e47aac81bd62bd69c982dd5898a9f803e7c3832ceb642adc20ecc7b);
    lde_trace_merkle_proofs_36
        .append(0x6ada4534be005492bfad71e07765245fdabea356fd4f52503edc7177d58282c);
    lde_trace_merkle_proofs_36
        .append(0x3afae580cc319eb21e31c7d72e7b0e6be0ffddbc55c1459c128fa1801d17255);
    lde_trace_merkle_proofs_36
        .append(0x24ed1d380d8087d0de5859546475200e317a1867b8451339c312816cdbaad12);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_36);
    let mut lde_trace_merkle_proofs_37 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_37
        .append(0x789e4b8c63a88b38fe0446d245937b18f797de38ec1453fcc12a59f8002ce81);
    lde_trace_merkle_proofs_37
        .append(0x118f18924834f3d12d08168fdb192b96b9010033acbeda959959d37afcf0f61);
    lde_trace_merkle_proofs_37
        .append(0x2ce9ba731485029b9e573f478807d5187c42cf28a297545faf8a9d7d24e406a);
    lde_trace_merkle_proofs_37
        .append(0x3f7af81c1dbbe1c0dc484d5995bbe335edaaafec007b113b899f4532a8b2c1d);
    lde_trace_merkle_proofs_37
        .append(0x1e4568491c2cbb8e2f8f0fa57d9e5e6437511d74660d0ae43ee72c037a17fb8);
    lde_trace_merkle_proofs_37
        .append(0x64c8924651d6d85f2af5f27e4650ad25665fad6ebf33bf817be9f7e6d1c039f);
    lde_trace_merkle_proofs_37
        .append(0x72a7b0c2411adb6a53b96bb0a7a7f7eb7e33a2e575fd1f5cd8d93fc43924bc4);
    lde_trace_merkle_proofs_37
        .append(0x18b5f214b5bd339bd5d295129ad850868a0f644f19a1e51f2eada0caee6135c);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_37);
    let mut lde_trace_merkle_proofs_38 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_38
        .append(0x7e77cdb5d0d054586828f95f8176beee10b2712173a10205c94a82014159c50);
    lde_trace_merkle_proofs_38
        .append(0x60f8e9e30d987e39d824be403665e924ea3e413f99012de8e08250284f66f3a);
    lde_trace_merkle_proofs_38
        .append(0x75ebcce8fe100f2ed639f8de40cca0af7d17b1f0a3f0b4384491ec57d79944d);
    lde_trace_merkle_proofs_38
        .append(0x7271a6998318aebacab11c46a23453932919fd06d95dc5782f964e6a6339e81);
    lde_trace_merkle_proofs_38
        .append(0x6a38930e546b47e9468ba74a2bd11034638fdb1ead10d526e976710faeaaa25);
    lde_trace_merkle_proofs_38
        .append(0x748da010f1cf2d4f4782112f1bdba5ad85d97e07816a4a7679b42f110d8e4ae);
    lde_trace_merkle_proofs_38
        .append(0x4bab208aeb74e662e2efbfb648c47e774093f960d6ab0070f95acaacbbbe320);
    lde_trace_merkle_proofs_38
        .append(0x2d1984809b8f838338c72459a865dc8edb8bb2e882b4dd297838ae693a97a18);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_38);
    let mut lde_trace_merkle_proofs_39 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_39
        .append(0x7e53ad753c1ab6e7f8d73f8827dec25c602ee1a7eff661c25ad30d04c1797c8);
    lde_trace_merkle_proofs_39
        .append(0x7345d5ffe24dd51c09672fe41c7e937108daa80acab2aaa3d269417571ed09a);
    lde_trace_merkle_proofs_39
        .append(0x6a7a7748516476b524ae2bca31c8dfde2e3fd93a32dec2b371cbbe379592d2c);
    lde_trace_merkle_proofs_39
        .append(0x3e552873bd830ee9d67276c496dafe7687ea39d547106a87fbd40c6b7229242);
    lde_trace_merkle_proofs_39
        .append(0x491f10652b1a69df4b75c536e3f04dfe2ae2e1ce0dab979a2400c34dbd5a9c8);
    lde_trace_merkle_proofs_39
        .append(0x43ca41232e790eab040172795c77599da7a7040d8903f3f7a52cd0734c0e9bd);
    lde_trace_merkle_proofs_39
        .append(0x231447ba5e2cc6065b1d7defc9f6345e97d8b25866d22f7a15b38f94e16b6e4);
    lde_trace_merkle_proofs_39
        .append(0xb671c1ba7d1da764f94254b212f583f1ad900807307f0839833a6d6c240d98);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_39);
    let mut lde_trace_merkle_proofs_40 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_40
        .append(0x720e70c32a266c6a21470df879a8582131377860d5a22cb1b25bbb424a5c272);
    lde_trace_merkle_proofs_40
        .append(0x62a5325b63a99a8ecab5623d1beaa08fc8aa3b435b03f3eddb500d76249a4df);
    lde_trace_merkle_proofs_40
        .append(0x7a9fcee6cd386b33cec9701cfaf60c0f3787761bd8b4fe772fbb2acf353a946);
    lde_trace_merkle_proofs_40
        .append(0x5bba77e2c233bac4bc8de26c8a86d95e4d6e4c652d3ad812baad1f03384a44f);
    lde_trace_merkle_proofs_40
        .append(0x16be4f6cd67c21a7cfe92af682edb1d44cd2f8eca93456d6b3fd6d95db9c3aa);
    lde_trace_merkle_proofs_40
        .append(0x5a15d88328ea64c1bb305499dc6800ba5fddde3d77c722948cf1079684c4bf3);
    lde_trace_merkle_proofs_40
        .append(0x4b5530ddafcee1df9b307fae2666cde37938c59953798a1cbb9f17c63576b1e);
    lde_trace_merkle_proofs_40
        .append(0x210cf65c8277bae86a28b1ff3f0220bbe77a898fd0ac00eaae8eb77de6950ad);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_40);
    let mut lde_trace_merkle_proofs_41 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_41
        .append(0x45bedeb899fce5594135c501d5b4f099ae2c3ef8b9d9fea890f72f66a25cb06);
    lde_trace_merkle_proofs_41
        .append(0x3a0ca35d2f5fe92b07cd9d2684480aa255e5bd1cd9a9942b645f6dcd1d32e67);
    lde_trace_merkle_proofs_41
        .append(0x75bc10289ca977fea46a22cff9e8df5bfc7d91264fab6851dfe4e83577d78cf);
    lde_trace_merkle_proofs_41
        .append(0x7eaa1dc1185c5a55066776f5d36a361ff60c1b095c67998392b2a233edb3247);
    lde_trace_merkle_proofs_41
        .append(0x7fdaee10bdb359cc2a843527593804e6f904266426d2e8ab77c672b775c4c35);
    lde_trace_merkle_proofs_41
        .append(0x89c770b2969d7e65118d22b3a6a8973f4bf973fad1b97ff3351bf897c150dc);
    lde_trace_merkle_proofs_41
        .append(0x7cd14b9b7ade740ad3ec1e3f705cd8c6decabcb84a62009ca6daf91257a6399);
    lde_trace_merkle_proofs_41
        .append(0x717b935726691b83abb91946db58f80124df917c041fbd88388c80bd14e504f);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_41);
    let mut lde_trace_merkle_proofs_42 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_42
        .append(0x414227cbf4300a8a55a366a97edef45f2af26287134a00db2c35613199d2d16);
    lde_trace_merkle_proofs_42
        .append(0x14ebb188a00d0b478139feb4d3eb6cbde6d122f2b814ae81bc20b13b801291a);
    lde_trace_merkle_proofs_42
        .append(0x6c6b3fc8465196444cc077e95122168f1f8a9743419c16e62f05c5eb645225b);
    lde_trace_merkle_proofs_42
        .append(0x161110095838f8ae9d2ae2401c703592f0325bf096bbeec8aee7ea1bee00cb1);
    lde_trace_merkle_proofs_42
        .append(0x66453563ac99d34153f8af251c7c8190b0109be227f08120ed518460309f3c9);
    lde_trace_merkle_proofs_42
        .append(0x57ee93187eba9eb57f97b69dc0403d6f15bc02e88d7aafa214c2b832075c1e2);
    lde_trace_merkle_proofs_42
        .append(0x44dcfc046114ff0dcf74bec285c9167b325b6504858d345d9e7ee29899a1a47);
    lde_trace_merkle_proofs_42
        .append(0x6cf0fd853f44e61d1ab4dcf5c1befc409397044a6e70a0b41c34d0932696524);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_42);
    let mut lde_trace_merkle_proofs_43 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_43
        .append(0x7a3e09af90f427e63540295c8f329337bcedb2c0badfa5a3aeb4089129a5a62);
    lde_trace_merkle_proofs_43
        .append(0x635e6213adb4bd135848b1d1a9c8ae3766b46d34f2da69b1fbb174033094937);
    lde_trace_merkle_proofs_43
        .append(0x1faeec6527598fc4123cf78cc90a94ebfeeab853bbb93df3ca8d8341398a081);
    lde_trace_merkle_proofs_43
        .append(0x13fdecdc0fc2b75e54c90ade918366c69d590a596bbe636dfc479ad00d889fe);
    lde_trace_merkle_proofs_43
        .append(0xf95138cab0bb6848e439952fed7bde60adf338da4f46f275f1593ffbcbc197);
    lde_trace_merkle_proofs_43
        .append(0x33bb209975877744b3331c38e44a8b188a5003958ad931363f53c874af0bce3);
    lde_trace_merkle_proofs_43
        .append(0x624309190313978599286867a1524913045e14d3797ca6186a3b9f6de10c4a0);
    lde_trace_merkle_proofs_43
        .append(0x704841f38f2b3f332d7227f1682fac5eae0ad0ece7c4d9f07fb951fe0a1840b);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_43);
    let mut lde_trace_merkle_proofs_44 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_44
        .append(0x4d59dadeef805a6d6d4d1c6108e7227c5d4a2768dfbd602057c9ff02230e6d6);
    lde_trace_merkle_proofs_44
        .append(0x21f03e0d8f39f8592cae58ec4d6e667151f42b2719224501ea47d1e68918dba);
    lde_trace_merkle_proofs_44
        .append(0x465c1b594cc510dc48d1059a7dda77ddfe0f0058d1cc9f6c3918c3cf7349ae0);
    lde_trace_merkle_proofs_44
        .append(0x1f49135cb184e8237f388e956b3d893531566b155fb2c8ab86288d33d088ce5);
    lde_trace_merkle_proofs_44
        .append(0xa671d1fd58d6afa7150bbc688071d8c81f05eb8a53706261cb0f45db0f4c30);
    lde_trace_merkle_proofs_44
        .append(0x26c86f6b69309bcdaabba9eeedc7cbdd9fe26cbb8f46ebae935810be0577048);
    lde_trace_merkle_proofs_44
        .append(0x7f4bea74b04c7c8ed829e8873eb773747e62384dc6d709128a1a2c024a8a8a);
    lde_trace_merkle_proofs_44
        .append(0x1f9a69c3c254a899a2d6f3552b1779361d2b2879608267ea55fb6e8607df2db);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_44);
    let mut lde_trace_merkle_proofs_45 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_45
        .append(0x6df789acc64feda923416591f86cab37e2a637975ffaa4b47b35df121260156);
    lde_trace_merkle_proofs_45
        .append(0x681e05ed3246ca6fb7d0ca74452eb51f67667628c66c8af57313d8c669e857);
    lde_trace_merkle_proofs_45
        .append(0x2fcdeff151b0f7b4ee9b8f2bb696ce6db68c1ac99e631bbab7930c50d394129);
    lde_trace_merkle_proofs_45
        .append(0x3f66667617c80cce4ba5fa82130141206ae068d9b0e01997d1dfb41fc6a0570);
    lde_trace_merkle_proofs_45
        .append(0x3f2da72ee3a73cd2e144222e7b75fbe17cfb7b15785606d122f80c5d9e6ca7e);
    lde_trace_merkle_proofs_45
        .append(0x691604425ef18cae6abd30129fa26b43563a7a3e51677446ea12508a92f5ad0);
    lde_trace_merkle_proofs_45
        .append(0x61d631f43d9edfcef21c5386640a44f7e2d40b247b063af62341c9b7e022c60);
    lde_trace_merkle_proofs_45
        .append(0x6a0f9d97cacc64eb774d40db2474adc4df99f4ded2ec07090100d655118a252);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_45);
    let mut lde_trace_merkle_proofs_46 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_46
        .append(0x5a37d88fa3a478d61f0a9f49fed900978cf6dee6f5e5e41fb7f532709df73ce);
    lde_trace_merkle_proofs_46
        .append(0x4512a2e93c2c724dfdfc9c570382d06a33960dbb79106354dab9e5907bb0428);
    lde_trace_merkle_proofs_46
        .append(0x7f963f1c9f3c47c96177c8646f672a16298d33c18ecd86edd034d1ba7fa18b1);
    lde_trace_merkle_proofs_46
        .append(0x5523194d3759e8f6a29a920af7b4fdf347632e7b4ff32db09a99a25082137c);
    lde_trace_merkle_proofs_46
        .append(0x7742ff19cb88f2992ba73036b05bd979deeff6f711d5482aeb4f18989f99972);
    lde_trace_merkle_proofs_46
        .append(0x24413447192719509149c6d322b664326b582a4834db4a936d6605da32f067a);
    lde_trace_merkle_proofs_46
        .append(0x580b2ad7deab0ec58de6d717525e51b40b66388f7c96d8160bd3b7fce7d0a0e);
    lde_trace_merkle_proofs_46
        .append(0x4aef481cf4952eda2010a4858d922ab1645d0f155065092fddfb7947cd918e7);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_46);
    let mut lde_trace_merkle_proofs_47 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_47
        .append(0x2d9efe2f7854f4f21d7e99c96e417cfad32fc0d700ce5b6e38edb3fc503a6);
    lde_trace_merkle_proofs_47
        .append(0x1b5c3c5812d165b575d7e9776ec40231efbbba6d4d3f8f6bf38689e59eecb9b);
    lde_trace_merkle_proofs_47
        .append(0x5d6f7ee34ec46fca1046ed061b1b77a63774f67aa26a2e725a44cd8ce91cec5);
    lde_trace_merkle_proofs_47
        .append(0x170be323f580a90862c9e1d494752b9da8507bf64e7e3e3072e702dd41a6bf5);
    lde_trace_merkle_proofs_47
        .append(0x37be094a9a46873f2a13303a56c39dddcba6cc4ad91d534f16f101f02b323ea);
    lde_trace_merkle_proofs_47
        .append(0x6cbb77ddae744a080ad204837b16f342427d4bea5c7600236c755dc51829a78);
    lde_trace_merkle_proofs_47
        .append(0x778c1af5ef5ad27545ae7e6f5a267f594073282358e15794f770dcd169f459d);
    lde_trace_merkle_proofs_47
        .append(0x47c339d292629c3b40b96fa6ab0eddc882a28c93128f788fba0a9c6c3357c4b);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_47);
    let mut lde_trace_merkle_proofs_48 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_48
        .append(0x524fcdc5c796cc0851d7b26e1d54bb462b0b98acf1f499c3ef23ae356802a1a);
    lde_trace_merkle_proofs_48
        .append(0x3ca5b0327ed8cad572580c72b545ee972e9b5a8566921f5a65b905847b5e21b);
    lde_trace_merkle_proofs_48
        .append(0x3de9d6c84ed62833d3ec6f59bbfe22a13c278711b629526e364928d4631521f);
    lde_trace_merkle_proofs_48
        .append(0x287fe30b4ee1f4596120dfdf862c365f8af213736f48410362655ea0b90f990);
    lde_trace_merkle_proofs_48
        .append(0x595d8efd61753ba66bbb6e9f2ab9e5cbd0998d39c8f3a4dca90d5dc43691475);
    lde_trace_merkle_proofs_48
        .append(0x7779c8ad4dc9318bc4091bb1743d43d4f16405b4eaaa4fa8c4341d71ae9d86b);
    lde_trace_merkle_proofs_48
        .append(0x382dff38ec56c1ab3e75cc47510c05cc8971ad04d13d98990e6037fa0103c32);
    lde_trace_merkle_proofs_48
        .append(0x21b6e62698d9c203cc51caefdede030d4073d8ff570b47b2ae4abf1515ff8db);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_48);
    let mut lde_trace_merkle_proofs_49 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_49
        .append(0x44523b957409efdc5b5ffa19414dddbb2a49bb0772f41583e039dff572c29be);
    lde_trace_merkle_proofs_49
        .append(0x3d54544da8107bdd1d79fd2bbe098787ae45ab2cce682dcc0ab92cff0d3da76);
    lde_trace_merkle_proofs_49
        .append(0x52da25b44c994cc591b927322f2741d1e2b734dd410337351a737d035e76882);
    lde_trace_merkle_proofs_49
        .append(0x2627b7b8bf15fe562958b32d583bc425e1bcf6111642e384031a4c66bb4a349);
    lde_trace_merkle_proofs_49
        .append(0x74389a894600ef631cc825be412840c4eea93d6683b2edd30fea8c8297cd656);
    lde_trace_merkle_proofs_49
        .append(0x5125d23d5309bd4c70fcd1d42059b62fa797fd0ea52861b1d505b6077899c5e);
    lde_trace_merkle_proofs_49
        .append(0x770707a441281dcb17308a9cf74327f7eec0c8b5496eeb73766fa45534ab18e);
    lde_trace_merkle_proofs_49
        .append(0x1d5a878b86060541c164429b1e79378a03f4421ed240dc230e9c5a021379869);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_49);
    let mut lde_trace_merkle_proofs_50 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_50
        .append(0x3e6c4b59294f7d0d2cde52c661160ca6441e1063c646909c9371f2dec5853b1);
    lde_trace_merkle_proofs_50
        .append(0x4bfca5f533ab87bea43a132473c5e015bd4f9e2e9a51524c53a65a2eff95c28);
    lde_trace_merkle_proofs_50
        .append(0x88a8698c3dae42d23ba07c776b1575d0795d19a818d011f76f6a5d249b07bb);
    lde_trace_merkle_proofs_50
        .append(0x61096ff9857ab3e06dda72a28ceead70f847a001b4f86bfb745939959cd042d);
    lde_trace_merkle_proofs_50
        .append(0x543244a013a9499a8597ce9e81486d7c78da7bbfec328b87a195561a36a949b);
    lde_trace_merkle_proofs_50
        .append(0x4f876eac49c02b72dacad166fa6d962eaccfeaeeabce374396793da7e0e1362);
    lde_trace_merkle_proofs_50
        .append(0x235475c434ca0e971abeca908a2a9af04e2ce6ad977ed870fb57325cef076e4);
    lde_trace_merkle_proofs_50
        .append(0x2da6d63a4cd378a3c7646258c83cd4fb331d4530f273d43c5af2bffa6bf0a09);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_50);
    let mut lde_trace_merkle_proofs_51 = ArrayDefault::<felt252>::default();
    lde_trace_merkle_proofs_51
        .append(0x6bbc4beb2dd12640ca0cadb94454a02b574d698fa227c4b2546a6f04f7c6bc1);
    lde_trace_merkle_proofs_51
        .append(0x38b3cac9d01821b97bab896a4143ea1bd07ebe332b2d25aaefd310797b6f2d5);
    lde_trace_merkle_proofs_51
        .append(0x526c13e1e46e99edddf80aa6e5352238e7a5ceae3b5ac528d5e01e9e3c40a0f);
    lde_trace_merkle_proofs_51
        .append(0x657dcfcbe3054b623d1126dbb187ce8f50bb9ebbb0d15da475713ec17681c67);
    lde_trace_merkle_proofs_51
        .append(0x38033a40f835a27c426ef829076b652ed31bf3d7a5873f6e9d12d6b07331a1b);
    lde_trace_merkle_proofs_51
        .append(0x75e83ce400dcb07b2916fa86c4ab13e3b7c9ba6d3826472fac6d91df643e1ac);
    lde_trace_merkle_proofs_51
        .append(0x67056fcb317a27aa8899dd591fa6af590b8f292f934e60107eeef823786c915);
    lde_trace_merkle_proofs_51
        .append(0x53e4e352f806f82e19814a561114fc8aa4b8c9c49970f2ba93d3d1586c261bc);
    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_51);
    let mut lde_trace_evaluations = ArrayDefault::<felt252>::default();
    lde_trace_evaluations.append(0xe5cd89c30a7e3bd8d69ad0c2b3d71f8fd93e53fefffac658e7e7a5d2533e9f);
    lde_trace_evaluations.append(0x51c37b943730dee475e8121574c034918eb587c63e13e738a87e9cdb4f51485);
    lde_trace_evaluations.append(0x13bf7242d26387a4db72ed83f338453c44f605703074ff4fd6b3d66f1a2b896);
    lde_trace_evaluations.append(0x5cc04cfdc660f458e4009d01913309b67af45d2bb39386ac2cb7214c3ce1bf1);
    lde_trace_evaluations.append(0xf8040bf673b8512408c757a7b94b10d40159d641bf77a03fc950844a8f2b7b);
    lde_trace_evaluations.append(0x33c45cfe360d831e13633a7e0841db5f7f7ce5c912c8ff677abb352a66fec33);
    lde_trace_evaluations.append(0x0);
    lde_trace_evaluations.append(0x713cb16a88ae5fa1147fd88881e719dcfa0aa3983bcd72f34fa252347374b78);
    lde_trace_evaluations.append(0x2e3c846bc8cf222b8a17edea8b3fcb6e714a7839c1ec18c757816324b0aeb7d);
    lde_trace_evaluations.append(0x1d202731a7f9852c78e9d483a956581c038941a7b43239723edc2828b1bf328);
    lde_trace_evaluations.append(0x0);
    lde_trace_evaluations.append(0xf9bc2b3c1925c0589dcf4289d964f045cd30a7266a669c322efbf82c233a49);
    lde_trace_evaluations.append(0x2e3c846bc8cf222b8a17edea8b3fcb6e714a7839c1ec18c757816324b0aeb7d);
    lde_trace_evaluations.append(0x713cb16a88ae5fa1147fd88881e719dcfa0aa3983bcd72f34fa252347374b78);
    lde_trace_evaluations.append(0x4366a2f80688fb26e87e65094982c2989121a2864e143ad31a00227e2a1d5e6);
    lde_trace_evaluations.append(0x0);
    lde_trace_evaluations.append(0x2675215f7413d46b7f76e107260ec93c4bb034914f4805a6734e1dfc840c1c0);
    lde_trace_evaluations.append(0x301cf86304e405b6622f8243853fdd4260950ba85e3931d777c36bc85d06d1f);
    lde_trace_evaluations.append(0x50fe6880e82353ac903697de5181e7ca523fcf3db20289752264e344ea2249f);
    lde_trace_evaluations.append(0x1f7ef6cc0c01e4596d0bd69f23fdf981f8859bbed79a674db7c17b2b2fcce7);
    lde_trace_evaluations.append(0x4c4319f4243172dc8d1f3fcbdaf6d595b4755391f3cfe9cb8a81ee0ea7dc933);
    lde_trace_evaluations.append(0x706f2f57c938be08cfd96021843734e27a0eaf1b7153041645319ceb7f2b37f);
    lde_trace_evaluations.append(0x47abeff7cc3c0aaac19ad4eaae8ad1657d26f884423d3a11be643f67dd1ae78);
    lde_trace_evaluations.append(0x5db695e82cc63527f6224c03c21b86591f374ac6a5d6195c73c499f74eb155d);
    lde_trace_evaluations.append(0x2e6e66bd3e8290550f20da5375b6765437265396bc606f342f63d8771e08e49);
    lde_trace_evaluations.append(0x4ab26bd1fdfd57dee41b6ddafab15a41a3fb43a35e640c3aea93e8940b4a0dc);
    lde_trace_evaluations.append(0x591f2c27072f83de8960a6f209b61ff1fc97d0a869891eb7d0a289b9f867757);
    lde_trace_evaluations.append(0x125b4751b1c015470da160835442505dcd005bc484609cb2ad1680219bf73fe);
    lde_trace_evaluations.append(0x15b2178f8432191bafd9e2ff29d821ce8c65221ffab4f83da4585e9464f9551);
    lde_trace_evaluations.append(0x5573d10c8473cc1007d718223cf809dec71940c1dda04971199437522f25445);
    lde_trace_evaluations.append(0x78ae306ce481086f86987df87249ba70327b5395f9c97c2c9507b07c7e926a);
    lde_trace_evaluations.append(0x3a0c8004cc18358af62bba8ccdb677d5b2a516764f61d8dd84f9645d25a150);
    lde_trace_evaluations.append(0x7a7535f9374e0ccd796806f25a45c49849c11439933d16e118f46e777d8fe98);
    lde_trace_evaluations.append(0x7e493679b6869cad9a6fd2ea4b0228e99472a6fdd15363081c2973b2c982395);
    lde_trace_evaluations.append(0x716724c961a4060989f5778705cc071415b3fa06f0788c36bfd96a89330325e);
    lde_trace_evaluations.append(0x685e43b84f25fd991d836cf931534841583a07494c997fa45b49d5a872557dc);
    lde_trace_evaluations.append(0x5815c1b7afaba2bfe4c37cc2fb910631905ae9175455061fc1154492f7547cc);
    lde_trace_evaluations.append(0x3e5b7490f82ade9cf4ec84b5037521f506b5c8e7265ada7db9191244f6cd7f);
    lde_trace_evaluations.append(0x29437a2ce7a06f1c98856908ea6d468459f80dbe5bef8ee0afaecf20ef73a8c);
    lde_trace_evaluations.append(0x5ac8ea593c0cf26a50763d9d69368a19c6394f7b3749ec6513152000791669b);
    lde_trace_evaluations.append(0x44bc881300f3e643d1de95ca5987626033bb422c1a09d20f3ca7ef8cefca7f4);
    lde_trace_evaluations.append(0x4591a0e6d7d73f6b59966ea6d214120733e6486c37c7d99e43c55b8b2001ec1);
    lde_trace_evaluations.append(0x6b3a61903ba7b52f29327f0a86556887419f32e3b91cd9b9c8669c8b8aa1e16);
    lde_trace_evaluations.append(0x1e73999700c821f9f6f62b1df0d70a6a39df080164e019c83c55b5a6cace88);
    lde_trace_evaluations.append(0x2b8c7eaa61f0eb26f743dc46dac214cfda5d44bc1ce56ca5ca96f29b7011f5e);
    lde_trace_evaluations.append(0x306beafd4cc47709a8a6830a0f9b04a967768417266ee2ee9b693a185a2ed1f);
    lde_trace_evaluations.append(0x5273745bf019f05b552d048bfe25178ae25967940eebe0e9ce81c7d26bdd111);
    lde_trace_evaluations.append(0x3d2b8edd24627df5f4c7d2c999f29ebf588df14cdf5d63b4f6fe8894ba5050e);
    lde_trace_evaluations.append(0x18f9e0284461cfdf4c1924cb1475a4eb086fbf356927142b9ad2b707b8d3613);
    lde_trace_evaluations.append(0x49b3a55f7c210160e886952ad3ed2cbc10a084cc013fce650ab6d8e794f4d0b);
    lde_trace_evaluations.append(0x8640f81e97af331cd8f67dd4801027d960b6a28e0794e682301f84a7dbb09f);
    lde_trace_evaluations.append(0xc47b5887ea55505c4677fcc7d823fd62eb7318c9a6d5c7032d4ce1aacc275);
    return DeepPolynomialOpenings {
        lde_composition_poly_even_proof: lde_composition_poly_even_proof,
        lde_composition_poly_even_evaluation: lde_composition_poly_even_evaluation,
        lde_composition_poly_odd_proof: lde_composition_poly_odd_proof,
        lde_composition_poly_odd_evaluation: lde_composition_poly_odd_evaluation,
        lde_trace_merkle_proofs: lde_trace_merkle_proofs,
        lde_trace_evaluations: lde_trace_evaluations,
    };
}

