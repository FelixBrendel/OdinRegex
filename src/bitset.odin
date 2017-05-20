
set :: proc(n : ^u64, bit : u8) {
	mask : u64 = 1 << bit;
	n^ |= mask;
}

unset :: proc(n : ^u64, bit : u8) {
	mask : u64 = 1 << bit;
	mask = ~0~mask;
	n^ &= mask;
}

get :: proc(n : u64, bit : u8) -> bool {
	mask : u64 = 1 << bit;
	return n & mask != 0;
}

get_all :: proc(n : u64) -> []u8 {
	ret : [dynamic]u8;
	for i : u8 = 0; i < 64; i+=1 {
		if get(n, i) {
			append(ret, i);
		}
	}
	return ret[..];
}

/*get_union :: proc (s1 : u64, s2 : u64) -> u64 #inline {
	return s1 & s2;
}*/
