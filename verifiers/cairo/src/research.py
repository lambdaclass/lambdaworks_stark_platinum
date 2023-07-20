from eth_hash.auto import keccak



def bytes_to_little_endian_ints(input_bytes):
    byte_chunks = [input_bytes[i:i + 8] for i in range(0, len(input_bytes), 8)]
    little_endian_ints = [int.from_bytes(chunk, byteorder='little') for chunk in byte_chunks]
    return little_endian_ints


def split_128(a):
    return (a & ((1 << 128) - 1), a >> 128)

h=keccak(b"hello")


def to_uint(low, high):
    return (low+(high<<128))


TWO_ADIC_PRIMITVE_ROOT_OF_UNITY = 1374927983041104569048711644287044720861432102729607324204792234194188899468
TWO_ADICITY = 48
PRIME = 3618502788666131213697322783095070105623107215331596699973092056135872020481
def write_felt_252_array_inline(name:str, data:list)->str:
    code=f"let mut {name} = ArrayDefault::<felt252>::default();"
    for felt in data:
        code+=f"\n    {name}.append({felt});"
    code+=f"\n"
    return code
values = [pow(TWO_ADIC_PRIMITVE_ROOT_OF_UNITY, 2**k, PRIME) for k in range(TWO_ADICITY+1)]
def generate_loopkup(root=TWO_ADIC_PRIMITVE_ROOT_OF_UNITY, adicity=TWO_ADICITY):
    code="fn lookup(k: felt252) -> felt252{\n"
    code+=write_felt_252_array_inline("values", values)
    code+="    return (*values.at(k));\n}\n"
    return code

    
def generate_pow2_lookup():
    code="fn pow2_lookup() -> Array<u64>{\n"
    code+=write_felt_252_array_inline("values", reversed([pow(2, k) for k in range(64)]))
    code+="    return values;\n}\n"
    return code

