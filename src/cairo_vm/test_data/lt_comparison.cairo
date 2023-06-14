%builtins range_check

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math_cmp import is_le

func main{range_check_ptr: felt}() {
    let result = is_le(11111, 11115);
    assert result = TRUE;
    return ();
}
