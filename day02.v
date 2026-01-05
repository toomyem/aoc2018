module day02

import utils

fn prepare(input []string) []string {
	return input
}

fn solve1(input []string) !string {
	return '1'
}

fn solve2(input []string) !string {
	return '2'
}

pub fn main() {
	utils.print_solution(2, prepare, solve1, solve2) or { println('Error: ${err}') }
}
