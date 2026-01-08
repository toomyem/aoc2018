module utils

import os
import net.http
import time

fn get_input(day int) ![]string {
	file_name := 'input${day:02}.txt'
	if !os.is_file(file_name) {
		url := 'https://adventofcode.com/2018/day/$day/input'
		println('Trying to fetch input from AoC site...')
		session := os.environ()['SESSION']
		if session == '' {
			return error('Missing SESSION env')
		}
		cookies := {
			'session': session
		}
		http.download_file_with_cookies(url, file_name, cookies) or {
			panic('Cannot download $url: $err')
		}
	}
	return os.read_lines(file_name)!
}

fn get_expected(day int) ![]string {
	file_name := 'expected${day:02}.txt'
	if !os.is_file(file_name) {
		url := 'https://adventofcode.com/2018/day/${day}'
		println('Trying to fetch expected from AoC site...')
		session := os.environ()['SESSION']
		if session == '' {
			return error('Missing SESSION env')
		}
		mut req := http.new_request(.get, url, '')
		req.add_cookie(http.Cookie{ name: 'session', value: session })
		resp := req.do()!
		body := resp.body
		mut exp := []string{}
		mut i := 0

		for {
			i = body.index_after_('Your puzzle answer was <code>', i)
			if i == -1 {
				break
			}
			j := body.index_after_('</code>', i)
			if j > -1 {
				exp << body.substr(i + 29, j)
				i = j + 7
			} else {
				i = i + 29
			}
		}
		os.write_lines(file_name, exp)!
	}
	return os.read_lines(file_name)!
}

fn pad_right(s string, width int, ch rune) string {
	len := s.runes().len
	if len >= width {
		return s
	}
	return s + ch.str().repeat(width - len)
}

fn run_solution[T](part u8, input T, expected []string, func fn (T) !string) ! {
	mut watch := time.new_stopwatch()
	solution := func(input)!
	dur := watch.elapsed()
	exp := expected[part - 1] or { '??' }
	txt := pad_right('Solution $part: $solution (took: ${dur.str()})', 60, `.`)
	res := if solution == exp { '✅' } else { '❌' }
	println(txt + res)
}

pub fn print_solution[T](day int, prepare fn ([]string) !T, solve1 fn (T) !string, solve2 fn (T) !string) ! {
	println('===== Day $day:')
	input := prepare(get_input(day)!)!
	expected := get_expected(day)!

	run_solution(1, input, expected, solve1)!
	run_solution(2, input, expected, solve2)!
}
