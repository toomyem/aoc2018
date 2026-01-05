module main

import os
import strconv
import day01
import day02

pub fn main() {
	days := [day01.main, day02.main]
	if os.args.len == 2 {
		n := strconv.atoi(os.args[1]) or {
			println('Invalid day number')
			return
		}
		day := days[n - 1]
		day()
		return
	}
	for day in days {
		day()
	}
}
