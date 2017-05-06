#load "fmt.odin";

OR_SYMBOL         :: '|';
REPEAT_SYMBOL     :: '*';
ATLEASTONE_SYMBOL :: '+';
OPTION_SYMBOL     :: '?';

SymbolType :: enum {
    Undefinded,
    Terminal,
    Or,         // |
    Conact,
    Option,     // ?
    AtLeastOne, // +
    Repeat,     // *
}

SyntaxTree :: struct {
    root       : ^SyntaxTreeNode,
    expression : string,
}

SyntaxTreeNode :: struct {
    type     : SymbolType,
    symbol   : rune,
    children : []^SyntaxTreeNode,
}

get_symbol_type :: proc(symbol : u8) -> SymbolType {
    match symbol {
        case OR_SYMBOL:         return SymbolType.Or;
        case REPEAT_SYMBOL:     return SymbolType.Repeat;
        case ATLEASTONE_SYMBOL: return SymbolType.AtLeastOne;
        case OPTION_SYMBOL:     return SymbolType.Option;
        default: return SymbolType.Terminal;
    }
}

build_tree :: proc(exp : string) -> ^SyntaxTree {
    using sTree := new(SyntaxTree);
    expression = exp;

    // TODO(Felix): find lowest, recurse

    return sTree;
}

findCloseBrackets:: proc(posInStr : u32, str: string) -> u32 {
    nestness := 0;
    for i in posInStr+1..<u32(len(str)) {
        match str[i] {
            case ')':
                if nestness == 0 { return i; }
                nestness--;
        }
    }
    return 0;
}

get_lowest_operator :: proc(str : string) -> (SymbolType, u32) {
    // for return
    operator : SymbolType;
    operatorPos : u32 = 0;

    // for loop
    posInStr : u32 = 0;
    currChar : u8;

    for {
        if posInStr == u32(len(str)) { break; }
        println(posInStr, operator, operatorPos);

        currChar = str[posInStr];
        if currChar == u8('(') {
            closeBracketsPos := findCloseBrackets(posInStr, str);
            if closeBracketsPos == 0 { return SymbolType.Undefinded, 0; };
            if posInStr == 0 && closeBracketsPos == u32(len(str)-1) {
                return get_lowest_operator(str[1..len(str)-2]);
            } else {
                posInStr = closeBracketsPos + 1;
            }
        } else {
            match currChar {
                case OR_SYMBOL, REPEAT_SYMBOL, ATLEASTONE_SYMBOL, OPTION_SYMBOL:
                    currSymbol := get_symbol_type(currChar);
                    if operator == SymbolType.Undefinded || currSymbol < operator {
                        operator = currSymbol;
                        operatorPos = posInStr;
                    }
            }
            posInStr++;
        }
    }

    if operator > SymbolType.Conact {
        // TODO(Felix): try to find concat here:
    }

    return operator, operatorPos;
}

test_regex :: proc () {
    o,p := get_lowest_operator("aasd(s(a*|z+))");
    println();
    println(o,p);
}
