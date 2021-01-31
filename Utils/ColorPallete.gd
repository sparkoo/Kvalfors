extends Node

var colors = [
	"#140e1e",
	"#2d1a71",
	"#3257be",
	"#409def",
	"#70dbff",
	"#bfffff",
	"#3e32d5",
	"#6e6aff",
	"#a6adff",
	"#d8e0ff",
	"#652bbc",
	"#b44cef",
	"#ec8cff",
	"#ffcdff",
	"#480e55",
	"#941887",
	"#e444c3",
	"#ff91e2",
	"#190c12",
	"#550e2b",
	"#af102e",
	"#ff424f",
	"#ff9792",
	"#ffd5cf",
	"#491d1e",
	"#aa2c1e",
	"#f66d1e",
	"#ffae68",
	"#ffe1b5",
	"#492917",
	"#97530f",
	"#dd8c00",
	"#fbc800",
	"#fff699",
	"#0c101b",
	"#0e3e12",
	"#38741a",
	"#6cb328",
	"#afe356",
	"#e4fca2",
	"#0d384c",
	"#177578",
	"#00bc9f",
	"#6becbd",
	"#c9fccc",
	"#353234",
	"#665d5b",
	"#998d86",
	"#cdbfb3",
	"#eae6da",
	"#2f3143",
	"#505d6d",
	"#7b95a0",
	"#a6cfd0",
	"#dfeae4",
	"#8d4131",
	"#cb734d",
	"#efaf79",
	"#9c2b3b",
	"#e45761",
	"#ffffff",
	"#000000",
	"#e4162b",
	"#ffff40"
	]

func randomColor() -> Color:
	return Color(colors[randi() % colors.size()])