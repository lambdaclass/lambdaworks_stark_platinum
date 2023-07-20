import json
import math

path = "verifiers/cairo/src/sample_proof.cairo"
proof=json.load(open("tests/proof.json"))
cairo_air=json.load(open("tests/cairo_air.json"))


def create_sample_proof_file(path:str=path):
    code=init_sample_proof_file()
    code+=write_stark_proof(proof)
    code+=write_cairo_air(cairo_air)

    # write file : 
    with open(path, "w+") as f:
        f.write(code)
    f.close()
    return code

def init_sample_proof_file():
    code="""use array::ArrayTrait;
use debug::PrintTrait;
use array::ArrayDefault;
use integer::{u256, u128};
use cairo_verifier::structs::{STARKProof, Frame, FriDecommitment, DeepPolynomialOpening, CairoAIR, AirContext, ProofOptions, PublicInputs, Range, MemorySegments, MemoryCell};\n

"""
    return code

def write_stark_proof(data):
    code="fn get_sample_proof() -> STARKProof {\n"
    code+=write_u256_array_keccak_inline("lde_trace_merkle_roots", data["lde_trace_merkle_roots"])
    code+=write_frame_inline("trace_ood_frame_evaluations", data["trace_ood_frame_evaluations"], data['trace_ood_frame_evaluations_row_width'])
    code+=write_u256_inline("composition_poly_root", data["composition_poly_root"])
    code+=write_felt_252_inline("composition_poly_even_ood_evaluation", data["composition_poly_even_ood_evaluation"])
    code+=write_felt_252_inline("composition_poly_odd_ood_evaluation", data["composition_poly_odd_ood_evaluation"])
    code+=write_u256_array_inline("fri_layers_merkle_roots", data["fri_layers_merkle_roots"])
    code+=write_felt_252_inline("fri_last_value", data["fri_last_value"])
    code+=write_query_list("query_list", data["query_list"])
    code+=write_deep_poly_openings(data["deep_poly_openings"])
    code+= write_felt_252_inline("nonce", data["nonce"])
    code+="""
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
"""
    return code

def write_memory_segments_inline(data):
    if "RangeCheck" in data.keys():
        range_check = data["RangeCheck"]
    else:
        range_check = [0,0]
    if "Output" in data.keys():
        output = data["Output"]
    else:
        output = [0,0]
    
    code=f"""
    let memory_segments = MemorySegments {{range_check : Range {{start: {range_check[0]}, end: {range_check[1]}}},
    output : Range {{start: {output[0]}, end: {output[1]}}}}};\n
    """
    return code

def write_public_memory_inline(data):
    code=f"let mut public_memory = ArrayDefault::<MemoryCell>::default();"
    for k,v in data.items():
        code+=f"\n    public_memory.append(MemoryCell {{address: {k}, value: {v}}});"
    code+="\n"
    return code


def write_public_inputs_inline(data):
    code="\n"
    code+=write_felt_252_inline("pc_init", data["pc_init"])
    code+=write_felt_252_inline("ap_init", data["ap_init"])
    code+=write_felt_252_inline("fp_init", data["fp_init"])
    code+=write_felt_252_inline("pc_final", data["pc_final"])
    code+=write_felt_252_inline("ap_final", data["ap_final"])
    code+=write_felt_252_inline("range_check_min", data["range_check_min"])
    code+=write_felt_252_inline("range_check_max", data["range_check_max"])
    code+=write_memory_segments_inline(data["memory_segments"])
    code+=write_public_memory_inline(data["public_memory"])
    code+=write_felt_252_inline("num_steps", data["num_steps"])
    code+=write_u64_array_inline("num_steps_min_one_binary", to_little_endian_binary(data["num_steps"]-1))


    code+="""
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

    """
    return code
def count_trailing_zeros(n):
    binary = bin(n)[2:]
    reversed_binary = binary[::-1]
    counter = 0
    for bit in reversed_binary:
        if bit == '0':
            counter += 1
        else:
            break
    return counter

def write_cairo_air(data):
    context=data["context"]
    options=context["proof_options"]
    code="fn get_sample_cairo_air() -> CairoAIR {\n"
    code+=write_felt_252_inline("trace_length", data["trace_length"])
    code+=write_u64_array_inline("trace_length_min_one_binary", to_little_endian_binary(data["trace_length"]-1))
    code+=write_felt_252_inline("root_order", count_trailing_zeros(data["trace_length"]))

    code+=write_felt_252_inline("has_rc_builtin", int(data["has_rc_builtin"]))

    code+=write_felt_252_inline("blowup_factor_pow", int(math.log2(options["blowup_factor"])))
    code+=write_felt_252_inline("fri_number_of_queries", options["fri_number_of_queries"])
    code+=write_felt_252_inline("coset_offset", options["coset_offset"])
    code+="""
    let options = ProofOptions {
        blowup_factor_pow: blowup_factor_pow,
        fri_number_of_queries: fri_number_of_queries,
        coset_offset: coset_offset,
    };
    """
    code+=write_felt_252_inline("trace_columns", context["trace_columns"])
    code+=write_felt_252_array_inline("transition_degrees", context["transition_degrees"])
    code+=write_felt_252_array_inline("transition_offsets", context["transition_offsets"])
    code+=write_felt_252_array_inline("transition_exemptions", context["transition_exemptions"])
    code+=write_felt_252_inline("num_transition_constraints", context["num_transition_constraints"])
    code+="""
    let air_context = AirContext {
        options: options,
        trace_columns: trace_columns,
        transition_degrees: transition_degrees,
        transition_offsets: transition_offsets,
        transition_exemptions: transition_exemptions,
        num_transition_constraints: num_transition_constraints,
    };

    """
    code+=write_public_inputs_inline(data["pub_inputs"])
    code+="""
    return CairoAIR {
        context: air_context,
        trace_length: trace_length,
        trace_length_min_one_binary: trace_length_min_one_binary,
        root_order: root_order,
        public_inputs: public_inputs,
        has_rc_builtin: has_rc_builtin,
    };
    
}"""
    return code

def write_frame_inline(name:str, data:list, row_width:str)->str:
    code=f"let mut data = ArrayDefault::<felt252>::default();"
    for felt in data:
        code+=f"\n    data.append({felt});"
    code+=f"\n    let row_width = {row_width};"
    code+=f"\n    let {name} =  Frame {{data: data, row_width: row_width}};\n\n"
    return code

def write_felt_252_inline(name:str, data:str)->str:
    code=f"let {name} = {data};\n"
    return code

def split_128(a):
    return (a & ((1 << 128) - 1), a >> 128)

def write_u256_inline(name:str, data:str)->str:
    val = split_128(int(data, 16))
    code=f"let {name} = u256 {{ low: {val[0]}, high:{val[1]} }};\n"
    return code

def write_u256_array_inline(name:str, data:list)->str:
    code=f"let mut {name} = ArrayDefault::<u256>::default();"
    for uint in data:
        val = split_128(int(uint, 16))
        code+=f"\n    {name}.append(u256 {{ low: {val[0]}, high:{val[1]} }});"
    code+=f"\n"
    return code

def to_little_endian_binary(n):
    return [int(bit) for bit in bin(n)[:1:-1]]
def to_big_endian_binary(n):
    return [int(bit) for bit in bin(n)[2:]]

def bytes_to_little_endian_ints(input_bytes):
     byte_chunks = [input_bytes[i:i + 8] for i in range(0, len(input_bytes), 8)]
     little_endian_ints = [int.from_bytes(chunk, byteorder='little') for chunk in byte_chunks]
     return little_endian_ints

def padd_17(input_bytes):
    ints = bytes_to_little_endian_ints(input_bytes)
    r=17-len(ints)
    assert r>=0, "input too long"
    if r==1:
        ints.append(0x8000000000000001)
        return ints
    elif r==0:
        return ints
    else:
        ints.append(1)
        while len(ints) < 16:
            ints.append(0)
        ints.append(0x8000000000000000)
        return ints

def write_u256_array_keccak_inline(name:str, data:list)->str:

    code=f"let mut {name} = ArrayDefault::<Array<u64>>::default();"
    for i, uint in enumerate(data):
        vals=padd_17(bytes.fromhex(uint))
        code+=f"\n    let mut {name}_{i} = ArrayDefault::<u64>::default();"
        for val in vals:
            code+=f"\n    {name}_{i}.append({val});"
        code+=f"\n    {name}.append({name}_{i});"
    code+=f"\n"
    return code


def write_felt_252_array_inline(name:str, data:list)->str:
    code=f"let mut {name} = ArrayDefault::<felt252>::default();"
    for felt in data:
        code+=f"\n    {name}.append({felt});"
    code+=f"\n"
    return code

def write_u64_array_inline(name:str, data:list)->str:
    code=f"let mut {name} = ArrayDefault::<u64>::default();"
    for felt in data:
        code+=f"\n    {name}.append({felt});"
    code+=f"\n"
    return code

def write_query_list(name:str, data:list)->str:
    code=f"\nlet mut query_list = ArrayDefault::<FriDecommitment>::default();"
    for i, fri_decommitment in enumerate(data):
        layers_auth_paths_sym_array = fri_decommitment["layers_auth_paths_sym"]
        code+=f"\nlet mut layers_auth_paths_sym_{i} = ArrayDefault::<Array<u256>>::default();"
        for k,proof in enumerate(layers_auth_paths_sym_array):
            merkle_path = proof["merkle_path"]
            code+=write_u256_array_inline(f"layers_auth_paths_sym_{i}_{k}", merkle_path)
        for k in range(len(layers_auth_paths_sym_array)):
            code+=f"\n    layers_auth_paths_sym_{i}.append(layers_auth_paths_sym_{i}_{k});"
        
        layers_evaluations_sym = fri_decommitment["layers_evaluations_sym"]
        code+=write_felt_252_array_inline(f"layers_evaluations_sym_{i}", layers_evaluations_sym)

        layers_auth_paths_array = fri_decommitment["layers_auth_paths"]
        code+=f"\nlet mut layers_auth_paths_{i} = ArrayDefault::<Array<u256>>::default();"
        for k,proof in enumerate(layers_auth_paths_array):
            merkle_path = proof["merkle_path"]
            code+=write_u256_array_inline(f"layers_auth_paths_{i}_{k}", merkle_path)
        for k in range(len(layers_auth_paths_sym_array)):
            code+=f"\n    layers_auth_paths_{i}.append(layers_auth_paths_{i}_{k});"
        
        layers_evaluations = fri_decommitment["layers_evaluations"]
        code+=write_felt_252_array_inline(f"layers_evaluations_{i}", layers_evaluations)


        # code+=write_felt_252_inline(f"first_layer_evaluation_{i}", fri_decommitment["first_layer_evaluation"])

        # code+=write_u256_array_inline(f"first_layer_auth_path_{i}", fri_decommitment["first_layer_auth_path"]["merkle_path"])
        
        code+=f"""\nlet fri_decommitment_{i} = FriDecommitment {{
        layers_auth_paths_sym: layers_auth_paths_sym_{i},
        layers_evaluations_sym: layers_evaluations_sym_{i},
        layers_auth_paths: layers_auth_paths_{i},
        layers_evaluations: layers_evaluations_{i},
        }};
        query_list.append(fri_decommitment_{i});"""

    code+=f"\n"
    return code

def write_deep_poly_opening_inline(data, index=''):
    code=write_u256_array_inline(f"lde_composition_poly_proof_{index}", data["lde_composition_poly_proof"]['merkle_path'])
    code+=write_felt_252_inline(f"lde_composition_poly_even_evaluation_{index}", data["lde_composition_poly_even_evaluation"])
    code+=write_felt_252_inline(f"lde_composition_poly_odd_evaluation_{index}", data["lde_composition_poly_odd_evaluation"])

    code+=f"\nlet mut lde_trace_merkle_proofs_{index} = ArrayDefault::<Array<u256>>::default();"
    for i, array in enumerate(data["lde_trace_merkle_proofs"]):
        code+=write_u256_array_inline(f"lde_trace_merkle_proofs_{index}_{i}", array['merkle_path'])
        code+=f"\n    lde_trace_merkle_proofs_{index}.append(lde_trace_merkle_proofs_{index}_{i});"
    
    code+=write_felt_252_array_inline(f"lde_trace_evaluations_{index}", data["lde_trace_evaluations"])

    code+=f"""\n let deep_poly_opening_{index} = DeepPolynomialOpening {{lde_composition_poly_proof: lde_composition_poly_proof_{index},
        lde_composition_poly_even_evaluation: lde_composition_poly_even_evaluation_{index},
        lde_composition_poly_odd_evaluation: lde_composition_poly_odd_evaluation_{index},
        lde_trace_merkle_proofs: lde_trace_merkle_proofs_{index},
        lde_trace_evaluations: lde_trace_evaluations_{index},
    }};\n\n"""

    return code


def write_deep_poly_openings(data):
    code="let mut deep_poly_openings=ArrayDefault::<DeepPolynomialOpening>::default();\n"
    for i, deep_poly_openings in enumerate(data):
        code+=write_deep_poly_opening_inline(deep_poly_openings, i)
        code+=f"deep_poly_openings.append(deep_poly_opening_{i}); \n"

    return code



code=create_sample_proof_file()
# print(code)


