import json


path = "verifiers/cairo/src/sample_proof.cairo"
proof=json.load(open("tests/proof.json"))

def create_sample_proof_file(path:str=path):
    code=init_sample_proof_file()
    code+=write_felt_252_array("lde_trace_merkle_roots", proof["lde_trace_merkle_roots"])
    code+=write_frame("trace_ood_frame_evaluations", proof["trace_ood_frame_evaluations"], proof['trace_ood_frame_evaluations_row_width'])
    code+=write_felt_252("composition_poly_even_root", proof["composition_poly_even_root"])
    code+=write_felt_252("composition_poly_even_ood_evaluation", proof["composition_poly_even_ood_evaluation"])
    code+=write_felt_252("composition_poly_odd_root", proof["composition_poly_odd_root"])
    code+=write_felt_252("composition_poly_odd_ood_evaluation", proof["composition_poly_odd_ood_evaluation"])
    code+=write_felt_252_array("fri_layers_merkle_roots", proof["fri_layers_merkle_roots"])
    code+=write_felt_252("fri_last_value", proof["fri_last_value"])
    code+=write_fri_decommitment_array("query_list", proof["query_list"])
    code+=write_deep_poly_openings(proof["deep_poly_openings"])
    # write file : 
    with open(path, "w+") as f:
        f.write(code)
    f.close()
    return code


def init_sample_proof_file():
    code="""use array::ArrayTrait;
use debug::PrintTrait;
use array::ArrayDefault;
use cairo_verifier::stark_proof::{STARKProof, Frame, FriDecommitment, DeepPolynomialOpenings};\n

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
    let deep_poly_openings: DeepPolynomialOpenings = get_deep_poly_openings();\n

\n    return STARKProof {
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
}\n\n"""
    return code

def write_frame(name:str, data:list, row_width:str)->str:
    code=f"""fn get_{name}() -> Frame {{
    let mut data = ArrayDefault::<felt252>::default();"""
    for felt in data:
        code+=f"\n    data.append({felt});"
    code+=f"\n    let row_width = {row_width};"

    code+=f"\n    return Frame {{data: data, row_width: row_width}};\n}}\n\n"
    return code

def write_felt_252(name:str, data:str)->str:
    code=f"""fn get_{name}() -> felt252 {{
    let {name} = {data};
    return {name};
}}\n\n"""
    return code

def write_felt_252_array(name:str, data:list)->str:
    code=f"""fn get_{name}() -> Array<felt252> {{
    let mut {name} = ArrayDefault::<felt252>::default();"""
    for felt in data:
        code+=f"\n    {name}.append({felt});"
    code+=f"\n    return {name};\n}}\n\n"
    return code

def write_fri_decommitment_array(name:str, data:list)->str:
    code=f"fn get_query_list() -> Array<FriDecommitment> {{"
    code+=f"\nlet mut query_list = ArrayDefault::<FriDecommitment>::default();"
    for i, fri_decommitment in enumerate(data):
        layers_auth_paths_sym_array = fri_decommitment["layers_auth_paths_sym"]
        code+=f"\nlet mut layers_auth_paths_sym_{i} = ArrayDefault::<Array<felt252>>::default();"
        for k,proof in enumerate(layers_auth_paths_sym_array):
            merkle_path = proof["merkle_path"]
            code+=f"\nlet mut layers_auth_paths_sym_{i}_{k} = ArrayDefault::<felt252>::default();"
            for felt in merkle_path:
                code+=f"\n    layers_auth_paths_sym_{i}_{k}.append({felt});"
        for k in range(len(layers_auth_paths_sym_array)):
            code+=f"\n    layers_auth_paths_sym_{i}.append(layers_auth_paths_sym_{i}_{k});"
        
        layers_evaluations_sym = fri_decommitment["layers_evaluations_sym"]
        code+=f"\nlet mut layers_evaluations_sym_{i} = ArrayDefault::<felt252>::default();"
        for felt in layers_evaluations_sym:
            code+=f"\n    layers_evaluations_sym_{i}.append({felt});"
        
        first_layer_evaluation = fri_decommitment["first_layer_evaluation"]

        code += f"\nlet mut first_layer_evaluation_{i} = {first_layer_evaluation};"

        first_layer_auth_path = fri_decommitment["first_layer_auth_path"]["merkle_path"]
        code+=f"\nlet mut first_layer_auth_path_{i} = ArrayDefault::<felt252>::default();"
        for felt in first_layer_auth_path:
            code+=f"\n    first_layer_auth_path_{i}.append({felt});"
        
        code+=f"""\nlet fri_decommitment_{i} = FriDecommitment {{
        layers_auth_paths_sym: layers_auth_paths_sym_{i},
        layers_evaluations_sym: layers_evaluations_sym_{i},
        first_layer_evaluation: first_layer_evaluation_{i},
        first_layer_auth_path: first_layer_auth_path_{i},
        }};
        query_list.append(fri_decommitment_{i});"""

    code+=f"\n    return query_list;\n}}\n\n"
    return code

def write_deep_poly_openings(data):
    code=f"fn get_deep_poly_openings() -> DeepPolynomialOpenings {{"
    lde_composition_poly_even_proof = data["lde_composition_poly_even_proof"]['merkle_path']
    lde_composition_poly_even_evaluation = data["lde_composition_poly_even_evaluation"]
    lde_composition_poly_odd_proof = data["lde_composition_poly_odd_proof"]['merkle_path']
    lde_composition_poly_odd_evaluation = data["lde_composition_poly_odd_evaluation"]
    lde_trace_merkle_proofs = data["lde_trace_merkle_proofs"]
    lde_trace_evaluations = data["lde_trace_evaluations"]

    code+=f"\nlet mut lde_composition_poly_even_proof = ArrayDefault::<felt252>::default();"
    for felt in lde_composition_poly_even_proof:
        code+=f"\n    lde_composition_poly_even_proof.append({felt});"

    code+=f"\nlet mut lde_composition_poly_even_evaluation = {lde_composition_poly_even_evaluation};"

    code+=f"\nlet mut lde_composition_poly_odd_proof = ArrayDefault::<felt252>::default();"
    for felt in lde_composition_poly_odd_proof:
        code+=f"\n    lde_composition_poly_odd_proof.append({felt});"
    
    code+=f"\nlet mut lde_composition_poly_odd_evaluation = {lde_composition_poly_odd_evaluation};"

    code+=f"\nlet mut lde_trace_merkle_proofs = ArrayDefault::<Array<felt252>>::default();"
    for i, array in enumerate(lde_trace_merkle_proofs):
        code+=f"\nlet mut lde_trace_merkle_proofs_{i} = ArrayDefault::<felt252>::default();"
        for felt in array['merkle_path']:
            code+=f"\n    lde_trace_merkle_proofs_{i}.append({felt});"
        code+=f"\n    lde_trace_merkle_proofs.append(lde_trace_merkle_proofs_{i});"
    
    code+=f"\nlet mut lde_trace_evaluations = ArrayDefault::<felt252>::default();"
    for felt in lde_trace_evaluations:
        code+=f"\n    lde_trace_evaluations.append({felt});"
    
    code+=f"""\n return DeepPolynomialOpenings {{lde_composition_poly_even_proof: lde_composition_poly_even_proof,
        lde_composition_poly_even_evaluation: lde_composition_poly_even_evaluation,
        lde_composition_poly_odd_proof: lde_composition_poly_odd_proof,
        lde_composition_poly_odd_evaluation: lde_composition_poly_odd_evaluation,
        lde_trace_merkle_proofs: lde_trace_merkle_proofs,
        lde_trace_evaluations: lde_trace_evaluations,
    }};\n}}\n\n"""
    return code



code=create_sample_proof_file()
# print(code)

