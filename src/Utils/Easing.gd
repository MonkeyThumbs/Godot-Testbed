class Back:
	static func easeIn(t, b, c, d, s = 1.70158):
		t = t / d
		return c * t * t * ((s + 1) * t - s) + b

	static func easeOut(t, b, c, d, s = 1.70158):
		t = t / d  - 1
		return c * (t * t * ((s + 1) * t + s) + 1) + b

	static func easeInOut(t, b, c, d, s = 1.70158):
		t = (t / (d / 2))
		if (t < 1):
			s = s * 1.525
			return c / 2 * (t * t * ((s + 1 ) * t - s)) + b;
		else:
			t = t - 2
			s = s * 1.525
			return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b


class Bounce:
	static func easeIn(t, b, c, d):
		if b is Vector2:
			return c - easeOut(d - t, Vector2.ZERO, c, d) + b
		return c - easeOut(d - t, 0, c, d) + b

	static func easeOut(t, b, c, d):
		t = t / d
		if (t < (1 / 2.75)):
			return c * (7.5625 * t * t) + b
		elif (t < (2 / 2.75)):
			t = t - (1.5 / 2.75)
			return c * (7.5625 * t * t + 0.75) + b
		elif (t < (2.5 / 2.75)):
			t = t - (2.25 / 2.75)
			return c * (7.5625 * t * t + 0.9375) + b
		else:
			t = t - (2.625 / 2.75)
			return c * (7.5625 * t * t + 0.984375) + b

	static func easeInOut(t, b, c, d):
		if b is Vector2:
			if (t < (d / 2)):
				return easeIn (t * 2, Vector2.ZERO, c, d) * 0.5 + b
			else:
				return easeOut (t * 2 - d, Vector2.ZERO, c, d) * 0.5 + c * 0.5 + b
		if (t < (d / 2)):
			return easeIn (t * 2, 0, c, d) * 0.5 + b
		else:
			return easeOut (t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b


class Circ:
	static func easeIn(t, b, c, d):
		t = t / d
		return -c * (sqrt(1 - t * t) - 1) + b

	static func easeOut(t, b, c, d):
		t = t / d - 1
		return c * sqrt(1 - t * t) + b

	static func easeInOut(t, b, c, d):
		t = (t / (d / 2))
		if (t < 1):
			return -c / 2 * (sqrt(1 - t * t) - 1) + b
		else:
			t = t - 2
			return c / 2 * (sqrt(1 - t * t) + 1) + b


class Cubic:
	static func easeIn(t, b, c, d):
		t = t / d
		return c * t * t * t + b;

	static func easeOut(t, b, c, d):
		t = t / d - 1
		return c * (t * t * t + 1) + b

	static func easeInOut(t, b, c, d):
		t = (t / (d / 2))
		if (t < 1):
			return c / 2 * t * t * t + b
		else:
			t = t - 2
			return c / 2 * (t * t * t + 2) + b


class Elastic:
	static func easeIn(t, b, c, d):
		if (t == 0):
			return b
		t = t / d
		if (t == 1):
			return b + c
		var p = d * 0.3
		var a = c
		var s = p / 4
		t = t - 1
		return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * PI) / p)) + b

	static func easeInEx(t, b, c, d, a, p):
		var s
		if (t == 0):
			return b
		t = t / d
		if (t == 1):
			return b + c
		if (a < abs(c)):
			a = c
			s = p / 4
		else:
			s = p / (2 * PI) * asin(c / a)
		t = t - 1
		return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * PI) / p)) + b

	static func easeOut(t, b, c, d):
		if (t == 0):
			return b
		t = t / d
		if (t == 1):
			return b + c
		var p = d * 0.4
		var a = c
		var s = p / 4
		return (a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) + c + b)

	static func easeOutEx(t, b, c, d, a, p):
		var s
		if (t == 0):
			return b
		t = t / d
		if (t == 1):
			return b + c
		if (a < abs(c)):
			a = c
			s = p / 4
		else:
			s = p / (2 * PI) * asin(c / a)
		return (a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) + c + b)

	static func easeInOut(t, b, c, d):
		if (t == 0):
			return b
		t = (t / (d / 2))
		if (t == 2):
			return b + c
		var p = d * (0.4 * 1.5)
		var a = c
		var s = p / 4
		if (t < 1):
			t = t - 1
			return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * PI) / p)) + b
		else:
			t = t - 1
			return a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) * 0.5 + c + b

	static func easeInOutEx(t, b, c, d, a, p):
		var s
		if (t == 0):
			return b
		t = t / d / 2
		if (t == 2):
			return b + c
		if (a < abs(c)):
			a = c
			s = p / 4
		else:
			s = p / (2 * PI) * asin(c / a)
		if (t < 1):
			t = t - 1
			return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * PI) / p)) + b
		else:
			t = t - 1
			return a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) * 0.5 + c + b


class Expo:
	static func easeIn(t, b, c, d):
		if (t == 0):
			return b
		else:
			return c * pow(2, 10 * (t / d - 1)) + b

	static func easeOut(t, b, c, d):
		if (t == d):
			return b + c
		else:
			return c * (-pow(2, -10 * t / d) + 1) + b

	static func easeInOut(t, b, c, d):
		if (t == 0):
			return b
		if (t == d):
			return b + c
		t = (t / (d / 2))
		if (t < 1):
			return c / 2 * pow(2, 10 * (t - 1)) + b
		else:
			t = t - 1
			return c / 2 * (-pow(2, -10 * t) + 2) + b


class Linear:
	static func easeNone(t, b, c, d):
		return c * t / d + b

	static func easeIn(t, b, c, d):
		return c * t / d + b

	static func easeOut(t, b, c, d):
		return c * t / d + b

	static func easeInOut(t, b, c, d):
		return c * t / d + b


class Quad:
	static func easeIn(t, b, c, d):
		t = t / d
		return c * t * t + b

	static func easeOut(t, b, c, d):
		t = t / d
		return -c * t * (t - 2) + b

	static func easeInOut(t, b, c, d):
		t = (t / (d / 2))
		if (t < 1):
			return c / 2 * t * t + b
		else:
			t -= 1
			return -c / 2 * (t * (t - 2) - 1) + b


class Quart:
	static func easeIn(t, b, c, d):
		t = t / d
		return c * t * t * t * t + b

	static func easeOut(t, b, c, d):
		t = t / d - 1
		return -c * (t * t * t * t - 1) + b

	static func easeInOut(t, b, c, d):
		t = (t / (d / 2))
		if (t < 1):
			return c / 2 * t * t * t * t + b
		else:
			t = t - 2
			return -c / 2 * (t * t * t * t - 2) + b


class Quint:
	static func easeIn(t, b, c, d):
		t = t / d
		return c * t * t * t * t * t + b

	static func easeOut(t, b, c, d):
		t = t / d - 1
		return c * (t * t * t * t * t + 1) + b

	static func easeInOut(t, b, c, d):
		t = (t / (d / 2))
		if (t < 1):
			return c / 2 * t * t * t * t * t + b
		else:
			t = t - 2
			return c / 2 * (t * t * t * t * t + 2) + b


class Sine:
	static func easeIn(t, b, c, d):
		return -c * cos(t / d * (PI / 2)) + c + b

	static func easeOut(t, b, c, d):
		return c * sin(t / d * (PI / 2)) + b

	static func easeInOut(t, b, c, d):
		return -c / 2 * (cos(PI * t / d) - 1) + b
