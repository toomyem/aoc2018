module day02

import utils

fn prepare(input []string) ![]string {
	return input
}

fn is_double(s string) bool {
	arr := s.split('').sorted()
	size := arr.len - 1

	for i in 0 .. size {
		if arr[i] == arr[i + 1] && (i + 2 >= size || arr[i + 2] != arr[i]) {
			return true
		}
	}
	return false
}

fn is_triple(s string) bool {
	arr := s.split('').sorted()
	size := arr.len - 2

	for i in 0 .. size {
		if arr[i] == arr[i + 1] && arr[i] == arr[i + 2] && (i + 3 >= size || arr[i + 3] != arr[i]) {
			return true
		}
	}
	return false
}

fn solve1(input []string) !string {
	d2 := input.filter(is_double).len
	d3 := input.filter(is_triple).len
	return (d2 * d3).str()
}

fn diff(s1 string, s2 string) ?int {
	if s1.len != s2.len {
		return none
	}
	mut idx := ?int(none)
	mut n := 0

	for i in 0 .. s1.len {
		if s1[i] != s2[i] {
			idx = i
			n++
		}
	}

	return if n == 1 { idx } else { none }
}

fn solve2(input []string) !string {
	for i in 0 .. input.len {
		for j in i .. input.len {
			if idx := diff(input[i], input[j]) {
				return input[i][..idx] + input[i][idx + 1..]
			}
		}
	}
	return error('Not found')
}

pub fn main() ! {
	utils.print_solution(2, prepare, solve1, solve2)!
}
