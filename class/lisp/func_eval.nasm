%include 'inc/func.ninc'
%include 'class/class_vector.ninc'
%include 'class/class_error.ninc'
%include 'class/class_lisp.ninc'

def_func class/lisp/func_eval
	;inputs
	;r0 = lisp object
	;r1 = args
	;outputs
	;r0 = lisp object
	;r1 = value

	ptr this, args
	ulong length

	push_scope
	retire {r0, r1}, {this, args}

	devirt_call vector, get_length, {args}, {length}
	if {length == 1}
		func_call vector, get_element, {args, 0}, {args}
		func_call lisp, repl_eval, {this, args}, {args}
	else
		func_call error, create, {"(eval form) wrong number of args", args}, {args}
	endif

	eval {this, args}, {r0, r1}
	pop_scope
	return

def_func_end