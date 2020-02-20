extends Node

const UP = Vector2 (0.0, -1.0)
const gravity = Vector2(0.0, 960.0)
const max_speed = Vector2(2400, 2400)
const UNIT_SIZE = 24
const SAFETY_MARGIN = 0.08

const screen_resolutions = [Vector2(1280,720), 
							Vector2(1366,768),
							Vector2(1600,900),
							Vector2(1920,1080), 
							Vector2(2560,1440),
							Vector2(3200,1800),
							Vector2(3840,2160),
							Vector2(4096,2160)]

const resolution_options = ["1280x720", 
							"1366x768",
							"1600x900",
							"1920x1080", 
							"2560x1440",
							"3200x1800",
							"3840x2160",
							"4096x2160"]

enum facings {left = -1, right = 1}
enum { STATUS_NONE, STATUS_INVINCIBLE, STATUS_POISONED, STATUS_STUNNED }

var entrance_position : Vector2 = Vector2(748, 550)
