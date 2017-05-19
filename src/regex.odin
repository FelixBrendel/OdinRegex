#load "fmt.odin";

SymbolType :: enum {
    Terminal,
    Or,         // |
    Concat,
    Option,     // ?
    AtLeastOne, // +
    Repeat,     // *
}

SyntaxTreeNode :: struct {
    type     : SymbolType,
    children : [dynamic]^SyntaxTreeNode,

    // for berry sethi -> u64 are bitsets
    empty : bool,
    first : u64,
    last  : u64,
    next  : u64,

    // if type is terminal these become relevant:
    symbol : string, // symbols can be more than 1 char: \d or \(
    number : u32,
}

split_into_tokens :: proc(exp : string) -> [dynamic]string {
    ret : [dynamic]string;
    for i := 0; i < len(exp); i+=1 {
        if exp[i] == '\\' {
            append(ret, exp[i..i+1]);
            i++;
        } else {
            append(ret, exp[i..i]);
        }
    }
    return ret;
}

build_tree :: proc(exp : string) -> SyntaxTreeNode {
    tree : SyntaxTreeNode;

    tokenStream := split_into_tokens(exp);

    return tree;
}

test_regex :: proc () {
    regexp := "a|c(2\\d*)";

    println(split_into_tokens(regexp));

}
