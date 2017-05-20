#load "fmt.odin";
#load "regextree.odin";
#import "bitset.odin";


terminalIdCounter : u8 = 1; // TODO(Felix): set back to 0 after testing

compute_name_and_empty_and_first :: proc (using t : ^SyntaxTreeNode) {
    using SymbolType;

    if type == Terminal {
        number = terminalIdCounter;
        terminalIdCounter += 1;
        empty = false;
        bitset.set(&first, number);
    } else {
        for c in children {
            compute_name_and_empty_and_first(c);
        }
        match type {
            case Option, Repeat:
                empty = true;
                first = children[0].first;
            case Or:
                empty = false;
                for c in children {
                    empty |= c.empty;
                }
                first = 0;
                for c in children {
                    first |= c.first;
                }
            case Concat:
                empty = true;
                for c in children {
                    empty &= c.empty;
                }
                if children[0].empty {
                    first = 0;
                    for c in children {
                        first |= c.first;
                    }
                } else {
                    first = children[0].first;
                }
            case AtLeastOne:
                empty = children[0].empty;
                first = children[0].first;
        }
    }
 }

berry_sethi :: proc (t : ^SyntaxTreeNode) {
    compute_name_and_empty_and_first(t);
}


test_regex :: proc () {
    regexp := "(ba)?(c(a|b)*)";

    tree := build_tree(regexp);
    berry_sethi(tree);
    print_tree(tree);

}
