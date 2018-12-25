toBin(i, s = 0, c = 0) {
	l := StrLen(i := Abs(i + u := i < 0))
	Loop, % Abs(s) + !s * l << 2
		b := u ^ 1 & i // (1 << c++) . b
	Return, b
}