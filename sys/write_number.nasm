%include 'inc/func.inc'
%include 'inc/syscall.inc'

	fn_function sys/write_number
		;inputs
		;r0 = number
		;r1 = fd
		;r2 = base
		;trashes
		;r0, r2-r3, r5

		vp_cpy r2, r3	;base
		vp_cpy r4, r5	;stack location
		loop_start
			vp_xor r2, r2
			vp_div r3, r2, r0
			vp_push r2
		loop_until r0, ==, 0
		loop_start
			vp_pop r0
			vp_add '0', r0
			if r0, >, '9'
				vp_add 'A' - ':', r0
			endif
			sys_write_char r1, r0
		loop_until r5, ==, r4
		vp_ret

	fn_function_end
