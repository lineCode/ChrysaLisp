%include 'inc/func.ninc'
%include 'class/class_stream.ninc'
%include 'class/class_vector.ninc'
%include 'class/class_error.ninc'
%include 'class/class_lisp.ninc'

def_func class/lisp/repl_read
	;inputs
	;r0 = lisp object
	;r1 = stream
	;r2 = next char
	;outputs
	;r0 = lisp object
	;r1 = ast
	;r2 = next char

	const char_space, ' '
	const char_lrb, '('
	const char_rrb, ')'
	const char_lab, '<'
	const char_rab, '>'
	const char_0, '0'
	const char_9, '9'
	const char_minus, '-'
	const char_quote, "'"
	const char_double_quote, '"'
	const char_quasi_quote, '`'
	const char_unquote, ','
	const char_splicing, '~'
	const char_semi, ';'
	const char_lf, 10
	const char_lcurly, '{'

	ptr this, stream, ast
	ulong char

	push_scope
	retire {r0, r1, r2}, {this, stream, char}

	;skip white space
skip_white:
	loop_while {char <= char_space && char != -1}
		func_call stream, read_char, {stream}, {char}
	loop_end

	;what are we reading ?
	vpif {char != -1}
		switch
		case {char == char_semi}
			func_call stream, skip_not, {stream, char_lf}
			func_call stream, read_char, {stream}, {char}
			goto skip_white
		case {char == char_rrb}
			func_call error, create, {"unexpected )", this->lisp_sym_nil}, {ast}
			func_call stream, read_char, {stream}, {char}
			break
;		case {char == char_rab}
;			func_call error, create, {"unexpected >", this->lisp_sym_nil}, {ast}
;			func_call stream, read_char, {stream}, {char}
;			break
		case {char == char_lrb}
			func_call lisp, repl_read_list, {this, stream, char}, {ast, char}
			break
;		case {char == char_lab}
;			func_call lisp, repl_read_pair, {this, stream, char}, {ast, char}
;			break
		case {char == char_minus || (char >= char_0 && char <= char_9)}
			func_call lisp, repl_read_num, {this, stream, char}, {ast, char}
			break
		case {char == char_double_quote}
			func_call lisp, repl_read_str, {this, stream, char}, {ast, char}
			break
		case {char == char_lcurly}
			func_call lisp, repl_read_group, {this, stream, char}, {ast, char}
			break
		case {char == char_quote}
			func_call lisp, repl_read_quote, {this, stream, char}, {ast, char}
			break
		case {char == char_quasi_quote}
			func_call lisp, repl_read_qquote, {this, stream, char}, {ast, char}
			break
		case {char == char_unquote}
			func_call lisp, repl_read_unquote, {this, stream, char}, {ast, char}
			break
		case {char == char_splicing}
			func_call lisp, repl_read_splicing, {this, stream, char}, {ast, char}
			break
		default
			func_call lisp, repl_read_sym, {this, stream, char}, {ast, char}
		endswitch
	else
		assign {this->lisp_sym_nil}, {ast}
		func_call ref, ref, {ast}
	endif

	expr {this, ast, char}, {r0, r1, r2}
	pop_scope
	return

def_func_end
