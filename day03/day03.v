module day03

import utils
import regex
import math.stats

struct Rect {
  id string
	x int
	y int
	w int
	h int
}

fn prepare(input []string) ![]Rect {
	// #1 @ 1,3: 4x4
	s := '#(?P<id>\\w+) @ (?P<x>\\d+),(?P<y>\\d+): (?P<w>\\d+)x(?P<h>\\d+)'
	re := regex.regex_opt(s) or { panic(err) }
	return input.filter(it != '').map(fn [re] (line string) Rect {
		if !re.matches_string(line) {
			panic('${line} not matches')
		}
		return Rect{
		  id: re.get_group_by_name(line, 'id')
			x: re.get_group_by_name(line, 'x').int()
			y: re.get_group_by_name(line, 'y').int()
			w: re.get_group_by_name(line, 'w').int()
			h: re.get_group_by_name(line, 'h').int()
		}
	})
}

fn (r Rect) contains(x int, y int) bool {
	return x >= r.x && x < r.x + r.w && y >= r.y && y < r.y + r.h
}

fn (r1 Rect) overlaps(r2 Rect) bool {
	return r1.x < r2.x + r2.w && r1.x + r1.w > r2.x && r1.y < r2.y + r2.h && r1.y + r1.h > r2.y
}

fn solve1(input []Rect) !string {
	mut min_x := stats.min(input.map(|r| r.x))
	mut min_y := stats.min(input.map(|r| r.y))
	mut max_x := stats.max(input.map(|r| r.x + r.w))
	mut max_y := stats.max(input.map(|r| r.y + r.h))

	mut c := 0
	for x in min_x .. max_x {
		for y in min_y .. max_y {
			if input.count(fn [x, y] (r Rect) bool {
				return r.contains(x, y)
			}) >= 2 {
				c += 1
			}
		}
	}
	return c.str()
}

fn solve2(input []Rect) !string {
  LOOP:
  for r1 in input {
    for r2 in input {
      if r1.id != r2.id && r1.overlaps(r2) {
        continue LOOP
      }
    }
    return r1.id
  }
  return error("Not found?")
}

pub fn main() ! {
	utils.print_solution(3, prepare, solve1, solve2)!
}
