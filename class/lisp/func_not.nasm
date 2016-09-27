%include 'inc/func.inc'
%include 'class/class_vector.inc'
%include 'class/class_lisp.inc'

	def_function class/lisp/func_not
		;inputs
		;r0 = lisp object
		;r1 = args
		;outputs
		;r0 = lisp object
		;r1 = 0, else value

		ptr this, args
		ulong length

		push_scope
		retire {r0, r1}, {this, args}

		static_call vector, get_length, {args}, {length}
		if {length == 2}
			static_call vector, get_element, {args, 1}, {args}
			static_call lisp, repl_eval, {this, args}, {args}
			breakifnot {args}
			if {args == this->lisp_sym_nil}
				static_call ref, deref, {args}
				assign {this->lisp_sym_t}, {args}
				static_call ref, ref, {args}
			else
				static_call ref, deref, {args}
				assign {this->lisp_sym_nil}, {args}
				static_call ref, ref, {args}
			endif
		else
			static_call lisp, error, {this, "(not form) wrong numbers of args", args}
			assign {0}, {args}
		endif

		eval {this, args}, {r0, r1}
		pop_scope
		return

	def_function_end