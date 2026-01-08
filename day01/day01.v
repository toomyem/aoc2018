module day01

import arrays
import utils

fn prepare(input []string) ![]int {
	return input.filter(it != '').map(it.int())
}

fn solve1(input []int) !string {
	return arrays.sum(input)!.str()
}

fn solve2(input []int) !string {
	mut found := map[int]bool{}
	mut n := 0
	mut i := 0
	for {
		n += input[i]
		if n in found {
			break
		}
		found[n] = true
		i = (i + 1) % input.len
	}
	return n.str()
}

pub fn main() ! {
	utils.print_solution(1, prepare, solve1, solve2)!
}
