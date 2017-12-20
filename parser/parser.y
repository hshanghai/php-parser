%{
package parser

import (
    "io"
    "fmt"
    "strings"
    "github.com/z7zmey/php-parser/token"
    "github.com/z7zmey/php-parser/node"
    "github.com/z7zmey/php-parser/node/scalar"
    "github.com/z7zmey/php-parser/node/name"
    "github.com/z7zmey/php-parser/node/stmt"
    "github.com/z7zmey/php-parser/node/expr"
    "github.com/z7zmey/php-parser/node/expr/assign_op"
    "github.com/z7zmey/php-parser/node/expr/binary_op"
    "github.com/z7zmey/php-parser/node/expr/cast"
)

var rootnode = stmt.NewStmtList([]node.Node{})

func Parse(src io.Reader, fName string) node.Node {
    yyDebug        = 0
    yyErrorVerbose = true
    rootnode = stmt.NewStmtList([]node.Node{}) //reset
    yyParse(newLexer(src, fName))
    return rootnode
}

%}

%union{
    node node.Node
    token token.Token
    value string
    list []node.Node
    strings []string
}

%left T_INCLUDE T_INCLUDE_ONCE T_EVAL T_REQUIRE T_REQUIRE_ONCE
%left ','
%left T_LOGICAL_OR
%left T_LOGICAL_XOR
%left T_LOGICAL_AND
%right T_PRINT
%right T_YIELD
%right T_DOUBLE_ARROW
%right T_YIELD_FROM
%left '=' T_PLUS_EQUAL T_MINUS_EQUAL T_MUL_EQUAL T_DIV_EQUAL T_CONCAT_EQUAL T_MOD_EQUAL T_AND_EQUAL T_OR_EQUAL T_XOR_EQUAL T_SL_EQUAL T_SR_EQUAL T_POW_EQUAL
%left '?' ':'
%right T_COALESCE
%left T_BOOLEAN_OR
%left T_BOOLEAN_AND
%left '|'
%left '^'
%left '&'
%nonassoc T_IS_EQUAL T_IS_NOT_EQUAL T_IS_IDENTICAL T_IS_NOT_IDENTICAL T_SPACESHIP
%nonassoc '<' T_IS_SMALLER_OR_EQUAL '>' T_IS_GREATER_OR_EQUAL
%left T_SL T_SR
%left '+' '-' '.'
%left '*' '/' '%'
%right '!'
%nonassoc T_INSTANCEOF
%right '~' T_INC T_DEC T_INT_CAST T_DOUBLE_CAST T_STRING_CAST T_ARRAY_CAST T_OBJECT_CAST T_BOOL_CAST T_UNSET_CAST '@'
%right T_POW
%right '['
%nonassoc T_NEW T_CLONE
%left T_NOELSE
%left T_ELSEIF
%left T_ELSE
%left T_ENDIF
%right T_STATIC T_ABSTRACT T_FINAL T_PRIVATE T_PROTECTED T_PUBLIC

%type <token> $unk
%token <token> T_INCLUDE
%token <token> T_INCLUDE_ONCE
%token <token> T_EXIT
%token <token> T_IF
%token <token> T_LNUMBER
%token <token> T_DNUMBER
%token <token> T_STRING
%token <token> T_STRING_VARNAME
%token <token> T_VARIABLE
%token <token> T_NUM_STRING
%token <token> T_INLINE_HTML
%token <token> T_CHARACTER
%token <token> T_BAD_CHARACTER
%token <token> T_ENCAPSED_AND_WHITESPACE
%token <token> T_CONSTANT_ENCAPSED_STRING
%token <token> T_ECHO
%token <token> T_DO
%token <token> T_WHILE
%token <token> T_ENDWHILE
%token <token> T_FOR
%token <token> T_ENDFOR
%token <token> T_FOREACH
%token <token> T_ENDFOREACH
%token <token> T_DECLARE
%token <token> T_ENDDECLARE
%token <token> T_AS
%token <token> T_SWITCH
%token <token> T_ENDSWITCH
%token <token> T_CASE
%token <token> T_DEFAULT
%token <token> T_BREAK
%token <token> T_CONTINUE
%token <token> T_GOTO
%token <token> T_FUNCTION
%token <token> T_CONST
%token <token> T_RETURN
%token <token> T_TRY
%token <token> T_CATCH
%token <token> T_FINALLY
%token <token> T_THROW
%token <token> T_USE
%token <token> T_INSTEADOF
%token <token> T_GLOBAL
%token <token> T_VAR
%token <token> T_UNSET
%token <token> T_ISSET
%token <token> T_EMPTY
%token <token> T_HALT_COMPILER
%token <token> T_CLASS
%token <token> T_TRAIT
%token <token> T_INTERFACE
%token <token> T_EXTENDS
%token <token> T_IMPLEMENTS
%token <token> T_OBJECT_OPERATOR
%token <token> T_DOUBLE_ARROW
%token <token> T_LIST
%token <token> T_ARRAY
%token <token> T_CALLABLE
%token <token> T_CLASS_C
%token <token> T_TRAIT_C
%token <token> T_METHOD_C
%token <token> T_FUNC_C
%token <token> T_LINE
%token <token> T_FILE
%token <token> T_COMMENT
%token <token> T_DOC_COMMENT
%token <token> T_OPEN_TAG
%token <token> T_OPEN_TAG_WITH_ECHO
%token <token> T_CLOSE_TAG
%token <token> T_WHITESPACE
%token <token> T_START_HEREDOC
%token <token> T_END_HEREDOC
%token <token> T_DOLLAR_OPEN_CURLY_BRACES
%token <token> T_CURLY_OPEN
%token <token> T_PAAMAYIM_NEKUDOTAYIM
%token <token> T_NAMESPACE
%token <token> T_NS_C
%token <token> T_DIR
%token <token> T_NS_SEPARATOR
%token <token> T_ELLIPSIS
%token <token> T_EVAL
%token <token> T_REQUIRE
%token <token> T_REQUIRE_ONCE
%token <token> T_LOGICAL_OR
%token <token> T_LOGICAL_XOR
%token <token> T_LOGICAL_AND
%token <token> T_INSTANCEOF
%token <token> T_NEW
%token <token> T_CLONE
%token <token> T_ELSEIF
%token <token> T_ELSE
%token <token> T_ENDIF
%token <token> T_PRINT
%token <token> T_YIELD
%token <token> T_STATIC
%token <token> T_ABSTRACT
%token <token> T_FINAL
%token <token> T_PRIVATE
%token <token> T_PROTECTED
%token <token> T_PUBLIC
%token <token> '"'
%token <token> '`'
%token <token> '{'
%token <token> '}'
%token <token> ';'
%token <token> '('
%token <token> ')'
%token <token> '['
%token <token> ']'

%type <value> is_reference
%type <value> is_variadic
%type <value> returns_ref
%type <value> class_modifier

%type <token> reserved_non_modifiers
%type <token> semi_reserved
%type <token> identifier

%type <node> top_statement name statement function_declaration_statement
%type <node> class_declaration_statement trait_declaration_statement
%type <node> interface_declaration_statement interface_extends_list
%type <node> group_use_declaration inline_use_declaration
%type <node> mixed_group_use_declaration use_declaration unprefixed_use_declaration
%type <node> const_decl inner_statement
%type <node> expr optional_expr while_statement for_statement foreach_variable
%type <node> foreach_statement declare_statement finally_statement unset_variable variable
%type <node> extends_from parameter optional_type argument expr_without_variable global_var
%type <node> static_var class_statement trait_adaptation trait_precedence trait_alias
%type <node> absolute_trait_method_reference trait_method_reference property echo_expr
%type <node> new_expr anonymous_class class_name class_name_reference simple_variable
%type <node> internal_functions_in_yacc
%type <node> exit_expr scalar lexical_var function_call member_name property_name
%type <node> variable_class_name dereferencable_scalar constant dereferencable
%type <node> callable_expr callable_variable static_member new_variable
%type <node> encaps_var encaps_var_offset
%type <node> if_stmt
%type <node> alt_if_stmt
%type <node> implements_list if_stmt_without_else
%type <node> class_const_decl name_list
%type <node> alt_if_stmt_without_else
%type <node> array_pair possible_array_pair
%type <node> isset_variable type return_type type_expr

%type <node> variable_modifiers
%type <node> method_modifiers non_empty_member_modifiers member_modifier
%type <node> use_type

%type <strings> class_modifiers
%type <list> encaps_list backticks_expr namespace_name catch_name_list catch_list class_const_list
%type <list> const_list echo_expr_list for_exprs non_empty_for_exprs global_var_list
%type <list> unprefixed_use_declarations inline_use_declarations property_list static_var_list
%type <list> switch_case_list case_list trait_adaptation_list trait_adaptations unset_variables
%type <list> use_declarations lexical_var_list lexical_vars isset_variables non_empty_array_pair_list
%type <list> array_pair_list ctor_arguments argument_list non_empty_argument_list top_statement_list
%type <list> inner_statement_list parameter_list non_empty_parameter_list class_statement_list
%type <list> method_body

%%

/////////////////////////////////////////////////////////////////////////

start:
    top_statement_list                                  { rootnode = stmt.NewStmtList($1); }
;

reserved_non_modifiers:
      T_INCLUDE {$$=$1} | T_INCLUDE_ONCE {$$=$1} | T_EVAL {$$=$1} | T_REQUIRE {$$=$1} | T_REQUIRE_ONCE {$$=$1} | T_LOGICAL_OR {$$=$1} | T_LOGICAL_XOR {$$=$1} | T_LOGICAL_AND {$$=$1} 
    | T_INSTANCEOF {$$=$1} | T_NEW {$$=$1} | T_CLONE {$$=$1} | T_EXIT {$$=$1} | T_IF {$$=$1} | T_ELSEIF {$$=$1} | T_ELSE {$$=$1} | T_ENDIF {$$=$1} | T_ECHO {$$=$1} | T_DO {$$=$1} | T_WHILE {$$=$1} | T_ENDWHILE {$$=$1} 
    | T_FOR {$$=$1} | T_ENDFOR {$$=$1} | T_FOREACH {$$=$1} | T_ENDFOREACH {$$=$1} | T_DECLARE {$$=$1} | T_ENDDECLARE {$$=$1} | T_AS {$$=$1} | T_TRY {$$=$1} | T_CATCH {$$=$1} | T_FINALLY {$$=$1} 
    | T_THROW {$$=$1} | T_USE {$$=$1} | T_INSTEADOF {$$=$1} | T_GLOBAL {$$=$1} | T_VAR {$$=$1} | T_UNSET {$$=$1} | T_ISSET {$$=$1} | T_EMPTY {$$=$1} | T_CONTINUE {$$=$1} | T_GOTO {$$=$1} 
    | T_FUNCTION {$$=$1} | T_CONST {$$=$1} | T_RETURN {$$=$1} | T_PRINT {$$=$1} | T_YIELD {$$=$1} | T_LIST {$$=$1} | T_SWITCH {$$=$1} | T_ENDSWITCH {$$=$1} | T_CASE {$$=$1} | T_DEFAULT {$$=$1} | T_BREAK {$$=$1} 
    | T_ARRAY {$$=$1} | T_CALLABLE {$$=$1} | T_EXTENDS {$$=$1} | T_IMPLEMENTS {$$=$1} | T_NAMESPACE {$$=$1} | T_TRAIT {$$=$1} | T_INTERFACE {$$=$1} | T_CLASS {$$=$1} 
    | T_CLASS_C {$$=$1} | T_TRAIT_C {$$=$1} | T_FUNC_C {$$=$1} | T_METHOD_C {$$=$1} | T_LINE {$$=$1} | T_FILE {$$=$1} | T_DIR {$$=$1} | T_NS_C {$$=$1} 
;

semi_reserved:
        reserved_non_modifiers {$$=$1}
    | T_STATIC {$$=$1} | T_ABSTRACT {$$=$1} | T_FINAL {$$=$1} | T_PRIVATE {$$=$1} | T_PROTECTED {$$=$1} | T_PUBLIC {$$=$1}
;

identifier:
        T_STRING                                        { $$ = $1 }
    |   semi_reserved                                   { $$ = $1 }
;

top_statement_list:
        top_statement_list top_statement                { $$ = append($1, $2) }
    |   /* empty */                                     { $$ = []node.Node{} }
;

namespace_name:
        T_STRING                                        { $$ = []node.Node{name.NewNamePart($1)} }
    |   namespace_name T_NS_SEPARATOR T_STRING          { $$ = append($1, name.NewNamePart($3)) }
;

name:
      namespace_name                                    { $$ = name.NewName($1) }
    | T_NAMESPACE T_NS_SEPARATOR namespace_name         { $$ = name.NewRelative($3) }
    | T_NS_SEPARATOR namespace_name                     { $$ = name.NewFullyQualified($2) }
;

top_statement:
        statement                                       { $$ = $1; }
    |   function_declaration_statement                  { $$ = $1; }
    |   class_declaration_statement                     { $$ = $1; }
    |   trait_declaration_statement                     { $$ = $1; }
    |   interface_declaration_statement                 { $$ = $1; }
    |   T_HALT_COMPILER '(' ')' ';'                     { $$ = stmt.NewHaltCompiler($1) }
    |   T_NAMESPACE namespace_name ';'                  { $$ = stmt.NewNamespace($1, name.NewName($2), nil) }
    |   T_NAMESPACE namespace_name '{' top_statement_list '}'
                                                        { $$ = stmt.NewNamespace($1, name.NewName($2), $4) }
    |   T_NAMESPACE '{' top_statement_list '}'          { $$ = stmt.NewNamespace($1, nil, $3) }
    |   T_USE mixed_group_use_declaration ';'           { $$ = $2.(stmt.GroupUse).SetToken($1) }
    |   T_USE use_type group_use_declaration ';'        { $$ = $3.(stmt.GroupUse).SetToken($1).(stmt.GroupUse).SetUseType($2) }
    |   T_USE use_declarations ';'                      { $$ = stmt.NewUseList($1, nil, $2) }
    |   T_USE use_type use_declarations ';'             { $$ = stmt.NewUseList($1, $2, $3) }
    |   T_CONST const_list ';'                          { $$ = stmt.NewStmtConst($1, $2) }
;

use_type:
        T_FUNCTION                                      { $$ = node.NewSimpleNode("FuncUseType"); }
    |   T_CONST                                         { $$ = node.NewSimpleNode("ConstUseType"); }
;

group_use_declaration:
        namespace_name T_NS_SEPARATOR '{' unprefixed_use_declarations possible_comma '}'
            {
                fmt.Println("group")
                $$ = stmt.NewGroupUse(nil, nil, name.NewName($1), $4)
            }
    |   T_NS_SEPARATOR namespace_name T_NS_SEPARATOR '{' unprefixed_use_declarations possible_comma '}'
            {
                $$ = stmt.NewGroupUse(nil, nil, name.NewName($2), $5)
            }
;

mixed_group_use_declaration:
        namespace_name T_NS_SEPARATOR '{' inline_use_declarations possible_comma '}'
            {
                fmt.Println("mixed")
                $$ = stmt.NewGroupUse(nil, nil, name.NewName($1), $4)
            }
    |   T_NS_SEPARATOR namespace_name T_NS_SEPARATOR '{' inline_use_declarations possible_comma '}'
            {
                $$ = stmt.NewGroupUse(nil, nil, name.NewName($2), $5)
            }
;

possible_comma:
        /* empty */
    |   ','
;

inline_use_declarations:
        inline_use_declarations ',' inline_use_declaration
                                                        { $$ = append($1, $3) }
    |   inline_use_declaration                          { $$ = []node.Node{$1} }
;

unprefixed_use_declarations:
        unprefixed_use_declarations ',' unprefixed_use_declaration
                                                        { $$ = append($1, $3) }
    |   unprefixed_use_declaration                      { $$ = []node.Node{$1} }
;

use_declarations:
        use_declarations ',' use_declaration            { $$ = append($1, $3) }
    |   use_declaration                                 { $$ = []node.Node{$1} }
;

inline_use_declaration:
        unprefixed_use_declaration                      { $$ = $1; }
    |   use_type unprefixed_use_declaration             { $$ = $2.(stmt.Use).SetType($1) }
;

unprefixed_use_declaration:
        namespace_name                                  { $$ = stmt.NewUse(nil, name.NewName($1), nil) }
    |   namespace_name T_AS T_STRING                    { $$ = stmt.NewUse(nil, name.NewName($1), $3) }
;

use_declaration:
        unprefixed_use_declaration                      { $$ = $1; }
    |   T_NS_SEPARATOR unprefixed_use_declaration       { $$ = $2; }
;

const_list:
        const_list ',' const_decl                       { $$ = append($1, $3) }
    |   const_decl                                      { $$ = []node.Node{$1} }
;

inner_statement_list:
        inner_statement_list inner_statement            { $$ = append($1, $2) }
    |   /* empty */                                     { $$ = []node.Node{} }
;

inner_statement:
    statement                                           { $$ = $1; }
    |   function_declaration_statement                  { $$ = $1; }
    |   class_declaration_statement                     { $$ = $1; }
    |   trait_declaration_statement                     { $$ = $1; }
    |   interface_declaration_statement                 { $$ = $1; }
    |   T_HALT_COMPILER '(' ')' ';'                     { $$ = stmt.NewHaltCompiler($1) }

statement:
    '{' inner_statement_list '}'                        { $$ = stmt.NewStmtList($2) }
    |   if_stmt                                         { $$ = $1; }
    |   alt_if_stmt                                     { $$ = $1; }
    |   T_WHILE '(' expr ')' while_statement
                                                        { $$ = stmt.NewWhile($1, $3, $5) }
    |   T_DO statement T_WHILE '(' expr ')' ';'         { $$ = stmt.NewDo($1, $2, $5) }
    |   T_FOR '(' for_exprs ';' for_exprs ';' for_exprs ')' for_statement
                                                        { $$ = stmt.NewFor($1, $3, $5, $7, $9) }
    |   T_SWITCH '(' expr ')' switch_case_list          { $$ = stmt.NewSwitch($1, $3, $5) }
    |   T_BREAK optional_expr ';'                       { $$ = stmt.NewBreak($1, $2) }
    |   T_CONTINUE optional_expr ';'                    { $$ = stmt.NewContinue($1, $2) }
    |   T_RETURN optional_expr ';'                      { $$ = stmt.NewReturn($1, $2) }
    |   T_GLOBAL global_var_list ';'                    { $$ = stmt.NewGlobal($1, $2) }
    |   T_STATIC static_var_list ';'                    { $$ = stmt.NewStatic($1, $2); }
    |   T_ECHO echo_expr_list ';'                       { $$ = stmt.NewEcho($1, $2) }
    |   T_INLINE_HTML                                   { $$ = stmt.NewInlineHtml($1) }
    |   expr ';'                                        { $$ = stmt.NewExpression($1); }
    |   T_UNSET '(' unset_variables possible_comma ')' ';' 
                                                        { $$ = stmt.NewUnset($1, $3) }
    |   T_FOREACH '(' expr T_AS foreach_variable ')' foreach_statement
                                                        { $$ = stmt.NewForeach($1, $3, nil, $5, $7); }
    |   T_FOREACH '(' expr T_AS foreach_variable T_DOUBLE_ARROW foreach_variable ')' foreach_statement
                                                        { $$ = stmt.NewForeach($1, $3, $5, $7, $9); }
    |   T_DECLARE '(' const_list ')' declare_statement  { $$ = stmt.NewDeclare($1, $3, $5) }
    |   ';'                                             { $$ = stmt.NewNop($1) }
    |   T_TRY '{' inner_statement_list '}' catch_list finally_statement
            {
                $$ = stmt.NewTry($1, $3, $5, $6)
            }
    |   T_THROW expr ';'                                { $$ = stmt.NewThrow($1, $2) }
    |   T_GOTO T_STRING ';'                             { $$ = stmt.NewGoto($1, $2) }
    |   T_STRING ':'                                    { $$ = stmt.NewLabel($1) }

catch_list:
        /* empty */                                     { $$ = []node.Node{} }
    |   catch_list T_CATCH '(' catch_name_list T_VARIABLE ')' '{' inner_statement_list '}'
                                                        { $$ = append($1, stmt.NewCatch($2, $4, expr.NewVariable(node.NewIdentifier($5)), $8)) }
;
catch_name_list:
        name                                            { $$ = []node.Node{$1} }
    |   catch_name_list '|' name                        { $$ = append($1, $3) }
;

finally_statement:
        /* empty */                                     { $$ = nil }
    |   T_FINALLY '{' inner_statement_list '}'          { $$ = stmt.NewFinally($1, $3) }
;

unset_variables:
        unset_variable                                  { $$ = []node.Node{$1} }
    |   unset_variables ',' unset_variable              { $$ = append($1, $3) }
;

unset_variable:
    variable                                            { $$ = $1 }
;

function_declaration_statement:
    T_FUNCTION returns_ref T_STRING '(' parameter_list ')' return_type '{' inner_statement_list '}'
        {
            $$ = stmt.NewFunction($3, $2 == "true", $5, $7, $9)
        }
;

is_reference:
        /* empty */                                     { $$ = "false"; }
    |   '&'                                             { $$ = "true"; }
;

is_variadic:
        /* empty */                                     { $$ = "false"; }
    |   T_ELLIPSIS                                      { $$ = "true"; }
;

class_declaration_statement:
        class_modifiers T_CLASS T_STRING extends_from implements_list '{' class_statement_list '}'
                                                        { $$ = stmt.NewClass($3, $1, nil, $4, $5.(node.SimpleNode).Children, $7) }
    |   T_CLASS T_STRING extends_from implements_list '{' class_statement_list '}'
                                                        { $$ = stmt.NewClass($2, nil, nil, $3, $4.(node.SimpleNode).Children, $6) }
;

class_modifiers:
        class_modifier                                  { $$ = []string{$1} }
    |   class_modifiers class_modifier                  { $$ = append($1, $2) }
;

class_modifier:
        T_ABSTRACT                                      { $$ = "abstract" }
    |   T_FINAL                                         { $$ = "final" }
;

trait_declaration_statement:
    T_TRAIT T_STRING '{' class_statement_list '}'       { $$ = stmt.NewTrait($2, $4) }
;

interface_declaration_statement:
    T_INTERFACE T_STRING interface_extends_list '{' class_statement_list '}'
                                                        { $$ = stmt.NewInterface($1, $2, $3, $5) }
;

extends_from:
        /* empty */                                     { $$ = nil }
    |   T_EXTENDS name                                  { $$ = $2; }
;

interface_extends_list:
        /* empty */                                     { $$ = nil }
    |   T_EXTENDS name_list                             { $$ = $2; }
;

implements_list:
        /* empty */                                     { $$ = node.NewSimpleNode("TODO: must be nil"); }
    |   T_IMPLEMENTS name_list                          { $$ = $2; }
;

foreach_variable:
        variable                                        { $$ = $1; }
    |   '&' variable                                    { $$ = node.NewSimpleNode("Ref").Append($2); }
    |   T_LIST '(' array_pair_list ')'                  { $$ = expr.NewList($3) }
    |   '[' array_pair_list ']'                         { $$ = expr.NewShortList($2) }
;

for_statement:
        statement                                       { $$ = $1; }
    |    ':' inner_statement_list T_ENDFOR ';'          { $$ = stmt.NewStmtList($2); }
;

foreach_statement:
        statement                                       { $$ = $1; }
    |   ':' inner_statement_list T_ENDFOREACH ';'       { $$ = stmt.NewStmtList($2); }
;

declare_statement:
        statement                                       { $$ = $1; }
    |   ':' inner_statement_list T_ENDDECLARE ';'       { $$ = stmt.NewStmtList($2); }
;

switch_case_list:
        '{' case_list '}'                               { $$ = $2; }
    |   '{' ';' case_list '}'                           { $$ = $3; }
    |   ':' case_list T_ENDSWITCH ';'                   { $$ = $2; }
    |   ':' ';' case_list T_ENDSWITCH ';'               { $$ = $3; }
;

case_list:
        /* empty */                                     { $$ = []node.Node{} }
    |   case_list T_CASE expr case_separator inner_statement_list
            {
                $$ = append($1, stmt.NewCase($2, $3, $5))
            }
    |   case_list T_DEFAULT case_separator inner_statement_list
            {
                $$ = append($1, stmt.NewDefault($2, $4))
            }
;

case_separator:
        ':'
    |   ';'
;

while_statement:
        statement                                       { $$ = $1; }
    |   ':' inner_statement_list T_ENDWHILE ';'         { $$ = stmt.NewStmtList($2); }
;

if_stmt_without_else:
        T_IF '(' expr ')' statement                     { $$ = stmt.NewIf($1, $3, $5) }
    |   if_stmt_without_else T_ELSEIF '(' expr ')' statement
            { 
                _elseIf := stmt.NewElseIf($2, $4, $6)
                $$ = $1.(stmt.If).AddElseIf(_elseIf)
            }
;

if_stmt:
        if_stmt_without_else %prec T_NOELSE             { $$ = $1; }
    |   if_stmt_without_else T_ELSE statement
            {
                _else := stmt.NewElse($2, $3)
                $$ = $1.(stmt.If).SetElse(_else)
            }
;

alt_if_stmt_without_else:
        T_IF '(' expr ')' ':' inner_statement_list
            { 
                $$ = stmt.NewAltIf($1, $3, stmt.NewStmtList($6))
            }
    |   alt_if_stmt_without_else T_ELSEIF '(' expr ')' ':' inner_statement_list
            {
                _elseIf := stmt.NewAltElseIf($2, $4, stmt.NewStmtList($7))
                $$ = $1.(stmt.AltIf).AddElseIf(_elseIf)
            }
;

alt_if_stmt:
        alt_if_stmt_without_else T_ENDIF ';'            { $$ = $1; }
    |   alt_if_stmt_without_else T_ELSE ':' inner_statement_list T_ENDIF ';'
            {
                _else := stmt.NewAltElse($2, stmt.NewStmtList($4))
                $$ = $1.(stmt.AltIf).SetElse(_else)
            }
;

parameter_list:
        non_empty_parameter_list                        { $$ = $1; }
    |   /* empty */                                     { $$ = nil }
;

non_empty_parameter_list:
        parameter                                       { $$ = []node.Node{$1} }
    |   non_empty_parameter_list ',' parameter          { $$ = append($1, $3) }
;

parameter:
        optional_type is_reference is_variadic T_VARIABLE
            {
                $$ = node.NewSimpleNode("Parameter").
                    Append($1).
                    Attribute("is_reference", $2).
                    Attribute("is_variadic", $3).
                    Attribute("var", $4.String());
            }
    |   optional_type is_reference is_variadic T_VARIABLE '=' expr
            {
                $$ = node.NewSimpleNode("Parameter").
                    Append($1).
                    Attribute("is_reference", $2).
                    Attribute("is_variadic", $3).
                    Attribute("var", $4.String()).
                    Append($6);
            }
;

optional_type:
        /* empty */                                     { $$ = node.NewSimpleNode("No type") }
    |   type_expr                                       { $$ = $1; }
;

type_expr:
        type                                            { $$ = $1; }
    |   '?' type                                        { $$ = $2; $$.Attribute("nullable", "true") }
;

type:
        T_ARRAY                                         { $$ = node.NewSimpleNode("array type"); }
    |   T_CALLABLE                                      { $$ = node.NewSimpleNode("callable type"); }
    |   name                                            { $$ = $1; }
;

return_type:
        /* empty */                                     { $$ = node.NewSimpleNode("No return type"); }
    |   ':' type_expr                                   { $$ = $2; }
;

argument_list:
        '(' ')'                                         { $$ = []node.Node{} }
    |   '(' non_empty_argument_list possible_comma ')'  { $$ = $2; }
;

non_empty_argument_list:
        argument                                        { $$ = []node.Node{$1} }
    |   non_empty_argument_list ',' argument            { $$ = append($1, $3) }
;

argument:
        expr                                            { $$ = $1; }
    |   T_ELLIPSIS expr                                 { $$ = node.NewSimpleNode("Unpack").Append($2) }
;

global_var_list:
        global_var_list ',' global_var                  { $$ = append($1, $3); }
    |   global_var                                      { $$ = []node.Node{$1} }
;

global_var:
    simple_variable                                     { $$ = $1 }
;

static_var_list:
        static_var_list ',' static_var                  { $$ = append($1, $3) }
    |   static_var                                      { $$ = []node.Node{$1} }
;

static_var:
        T_VARIABLE                                      { $$ = stmt.NewStaticVar($1, nil) }
    |   T_VARIABLE '=' expr                             { $$ = stmt.NewStaticVar($1, $3) }
;

class_statement_list:
        class_statement_list class_statement            { $$ = append($1, $2) }
    |   /* empty */                                     { $$ = []node.Node{} }
;

class_statement:
        variable_modifiers property_list ';'            { $$ = stmt.NewPropertyList($1, $2) }
    |   method_modifiers T_CONST class_const_list ';'   { $$ = stmt.NewClassConst($2, $1.(node.SimpleNode).Children, $3); }
    |   T_USE name_list trait_adaptations               { $$ = stmt.NewTraitUse($1, $2.(node.SimpleNode).Children, $3) }
    |   method_modifiers T_FUNCTION returns_ref identifier '(' parameter_list ')' return_type method_body
            {
                $$ = stmt.NewClassMethod($4, $1.(node.SimpleNode).Children, $3 == "true", $6, $8, $9)
            }
;

name_list:
        name                                            { $$ = node.NewSimpleNode("NameList").Append($1) }
    |   name_list ',' name                              { $$ = $1.Append($3) }
;

trait_adaptations:
        ';'                                             { $$ = nil }
    |   '{' '}'                                         { $$ = nil }
    |   '{' trait_adaptation_list '}'                   { $$ = $2; }
;

trait_adaptation_list:
        trait_adaptation                                { $$ = []node.Node{$1} }
    |   trait_adaptation_list trait_adaptation          { $$ = append($1, $2) }
;

trait_adaptation:
        trait_precedence ';'                            { $$ = $1; }
    |   trait_alias ';'                                 { $$ = $1; }
;

trait_precedence:
    absolute_trait_method_reference T_INSTEADOF name_list
        {
            name := name.NewName($3.(node.SimpleNode).Children)
            $$ = stmt.NewTraitUsePrecedence($1, name)
        }
;

trait_alias:
        trait_method_reference T_AS T_STRING            { $$ = stmt.NewTraitUseAlias($1, nil, $3) }
    |   trait_method_reference T_AS reserved_non_modifiers
                                                        { $$ = stmt.NewTraitUseAlias($1, nil, $3)  }
    |   trait_method_reference T_AS member_modifier identifier
                                                        { $$ = stmt.NewTraitUseAlias($1, $3, $4) }
    |   trait_method_reference T_AS member_modifier     { $$ = stmt.NewTraitUseAlias($1, $3, nil) }
;

trait_method_reference:
        identifier                                      { $$ = stmt.NewTraitMethodRef(nil, $1) }
    |   absolute_trait_method_reference                 { $$ = $1; }
;

absolute_trait_method_reference:
    name T_PAAMAYIM_NEKUDOTAYIM identifier              { $$ = stmt.NewTraitMethodRef($1, $3) }
;

method_body:
        ';' /* abstract method */                       { $$ = nil }
    |   '{' inner_statement_list '}'                    { $$ = $2 }
;

variable_modifiers:
        non_empty_member_modifiers                      { $$ = $1; }
    |   T_VAR                                           { $$ = node.NewSimpleNode("VarMemberModifier") }
;

method_modifiers:
        /* empty */                                     { $$ = node.NewSimpleNode("MemberModifiers").Append(node.NewSimpleNode("PublicMemberModifier")); }
    |   non_empty_member_modifiers                      { $$ = $1; }
;

non_empty_member_modifiers:
        member_modifier	                                { $$ = node.NewSimpleNode("MemberModifiers").Append($1); }
    |   non_empty_member_modifiers member_modifier      { $$ = $1.Append($2) }
;

member_modifier:
        T_PUBLIC                                        { $$ = node.NewSimpleNode("PublicMemberModifier"); }
    |   T_PROTECTED                                     { $$ = node.NewSimpleNode("ProtectedMemberModifier"); }
    |   T_PRIVATE                                       { $$ = node.NewSimpleNode("PrivateMemberModifier"); }
    |   T_STATIC                                        { $$ = node.NewSimpleNode("StaticMemberModifier"); }
    |   T_ABSTRACT                                      { $$ = node.NewSimpleNode("AbstractMemberModifier"); }
    |   T_FINAL                                         { $$ = node.NewSimpleNode("FinalMemberModifier"); }
;

property_list:
        property_list ',' property                      { $$ = append($1, $3) }
    |   property                                        { $$ = []node.Node{$1} }
;

property:
        T_VARIABLE                                      { $$ = stmt.NewProperty($1, nil) }
    |   T_VARIABLE '=' expr                             { $$ = stmt.NewProperty($1, $3) }
;

class_const_list:
        class_const_list ',' class_const_decl           { $$ = append($1, $3) }
    |   class_const_decl                                { $$ = []node.Node{$1} }
;

class_const_decl:
    identifier '=' expr                                 { $$ = stmt.NewConstant($1, $3) }
;

const_decl:
    T_STRING '=' expr                                   { $$ = stmt.NewConstant($1, $3) }
;

echo_expr_list:
        echo_expr_list ',' echo_expr                    { $$ = append($1, $3) }
    |   echo_expr                                       { $$ = []node.Node{$1} }
;

echo_expr:
    expr                                                { $$ = $1 }
;

for_exprs:
        /* empty */                                     { $$ = nil; }
    |   non_empty_for_exprs                             { $$ = $1; }
;
non_empty_for_exprs:
        non_empty_for_exprs ',' expr                    { $$ = append($1, $3) }
    |   expr                                            { $$ = []node.Node{$1} }
;

anonymous_class:
    T_CLASS ctor_arguments extends_from implements_list '{' class_statement_list '}'
        {
            { $$ = stmt.NewClass($1, nil, $2, $3, $4.(node.SimpleNode).Children, $6) }
        }
;

new_expr:
        T_NEW class_name_reference ctor_arguments       { $$ = expr.NewNew($2, $3) }
    |   T_NEW anonymous_class                           { $$ = expr.NewNew($2, nil) }
;

expr_without_variable:
        T_LIST '(' array_pair_list ')' '=' expr
            {
                list := expr.NewList($3)
                $$ = assign_op.NewAssign(list, $6)
            }
    |   '[' array_pair_list ']' '=' expr
        {
            shortList := expr.NewShortList($2)
            $$ = assign_op.NewAssign(shortList, $5)
        }
    |   variable '=' expr                               { $$ = assign_op.NewAssign($1, $3) }
    |   variable '=' '&' expr                           { $$ = assign_op.NewAssignRef($1, $4) }
    |   T_CLONE expr                                    { $$ = expr.NewClone($2) }
    |   variable T_PLUS_EQUAL expr                      { $$ = assign_op.NewPlus($1, $3) }
    |   variable T_MINUS_EQUAL expr                     { $$ = assign_op.NewMinus($1, $3) }
    |   variable T_MUL_EQUAL expr                       { $$ = assign_op.NewMul($1, $3) }
    |   variable T_POW_EQUAL expr                       { $$ = assign_op.NewPow($1, $3) }
    |   variable T_DIV_EQUAL expr                       { $$ = assign_op.NewDiv($1, $3) }
    |   variable T_CONCAT_EQUAL expr                    { $$ = assign_op.NewConcat($1, $3) }
    |   variable T_MOD_EQUAL expr                       { $$ = assign_op.NewMod($1, $3) }
    |   variable T_AND_EQUAL expr                       { $$ = assign_op.NewBitwiseAnd($1, $3) }
    |   variable T_OR_EQUAL expr                        { $$ = assign_op.NewBitwiseOr($1, $3) }
    |   variable T_XOR_EQUAL expr                       { $$ = assign_op.NewBitwiseXor($1, $3) }
    |   variable T_SL_EQUAL expr                        { $$ = assign_op.NewShiftLeft($1, $3) }
    |   variable T_SR_EQUAL expr                        { $$ = assign_op.NewShiftRight($1, $3) }
    |   variable T_INC                                  { $$ = expr.NewPostInc($1) }
    |   T_INC variable                                  { $$ = expr.NewPreInc($2) }
    |   variable T_DEC                                  { $$ = expr.NewPostDec($1) }
    |   T_DEC variable                                  { $$ = expr.NewPreDec($2) }
    |   expr T_BOOLEAN_OR expr                          { $$ = binary_op.NewBooleanOr($1, $3) }
    |   expr T_BOOLEAN_AND expr                         { $$ = binary_op.NewBooleanAnd($1, $3) }
    |   expr T_LOGICAL_OR expr                          { $$ = binary_op.NewLogicalOr($1, $3) }
    |   expr T_LOGICAL_AND expr                         { $$ = binary_op.NewLogicalAnd($1, $3) }
    |   expr T_LOGICAL_XOR expr                         { $$ = binary_op.NewLogicalXor($1, $3) }
    |   expr '|' expr                                   { $$ = binary_op.NewBitwiseOr($1, $3) }
    |   expr '&' expr                                   { $$ = binary_op.NewBitwiseAnd($1, $3) }
    |   expr '^' expr                                   { $$ = binary_op.NewBitwiseXor($1, $3) }
    |   expr '.' expr                                   { $$ = binary_op.NewConcat($1, $3) }
    |   expr '+' expr                                   { $$ = binary_op.NewPlus($1, $3) }
    |   expr '-' expr                                   { $$ = binary_op.NewMinus($1, $3) }
    |   expr '*' expr                                   { $$ = binary_op.NewMul($1, $3) }
    |   expr T_POW expr                                 { $$ = binary_op.NewPow($1, $3) }
    |   expr '/' expr                                   { $$ = binary_op.NewDiv($1, $3) }
    |   expr '%' expr                                   { $$ = binary_op.NewMod($1, $3) }
    |   expr T_SL expr                                  { $$ = binary_op.NewShiftLeft($1, $3) }
    |   expr T_SR expr                                  { $$ = binary_op.NewShiftRight($1, $3) }
    |   '+' expr %prec T_INC                            { $$ = expr.NewUnaryPlus($2) }
    |   '-' expr %prec T_INC                            { $$ = expr.NewUnaryMinus($2) }
    |   '!' expr                                        { $$ = expr.NewBooleanNot($2) }
    |   '~' expr                                        { $$ = expr.NewBitwiseNot($2) }
    |   expr T_IS_IDENTICAL expr                        { $$ = binary_op.NewIdentical($1, $3) }
    |   expr T_IS_NOT_IDENTICAL expr                    { $$ = binary_op.NewNotIdentical($1, $3) }
    |   expr T_IS_EQUAL expr                            { $$ = binary_op.NewEqual($1, $3) }
    |   expr T_IS_NOT_EQUAL expr                        { $$ = binary_op.NewNotEqual($1, $3) }
    |   expr '<' expr                                   { $$ = binary_op.NewSmaller($1, $3) }
    |   expr T_IS_SMALLER_OR_EQUAL expr                 { $$ = binary_op.NewSmallerOrEqual($1, $3) }
    |   expr '>' expr                                   { $$ = binary_op.NewGreater($1, $3) }
    |   expr T_IS_GREATER_OR_EQUAL expr                 { $$ = binary_op.NewGreaterOrEqual($1, $3) }
    |   expr T_SPACESHIP expr                           { $$ = binary_op.NewSpaceship($1, $3) }
    |   expr T_INSTANCEOF class_name_reference          { $$ = expr.NewInstanceOf($1, $3) }
    |   '(' expr ')'                                    { $$ = $2; }
    |   new_expr                                        { $$ = $1; }
    |   expr '?' expr ':' expr                          { $$ = expr.NewTernary($1, $3, $5) }
    |   expr '?' ':' expr                               { $$ = expr.NewTernary($1, nil, $4) }
    |   expr T_COALESCE expr                            { $$ = binary_op.NewCoalesce($1, $3) }
    |   internal_functions_in_yacc                      { $$ = $1}
    |   T_INT_CAST expr                                 { $$ = cast.NewCastInt($2) }
    |   T_DOUBLE_CAST expr                              { $$ = cast.NewCastDouble($2) }
    |   T_STRING_CAST expr                              { $$ = cast.NewCastString($2) }
    |   T_ARRAY_CAST expr                               { $$ = cast.NewCastArray($2) }
    |   T_OBJECT_CAST expr                              { $$ = cast.NewCastObject($2) }
    |   T_BOOL_CAST expr                                { $$ = cast.NewCastBool($2) }
    |   T_UNSET_CAST expr                               { $$ = cast.NewCastUnset($2) }
    |   T_EXIT exit_expr                                { $$ = expr.NewExit($2, strings.EqualFold($1.Value, "die")) }
    |   '@' expr                                        { $$ = node.NewSimpleNode("Silence").Append($2); }
    |   scalar                                          { $$ = $1; }
    |   '`' backticks_expr '`'                          { $$ = expr.NewShellExec($2) }
    |   T_PRINT expr                                    { $$ = expr.NewPrint($2) }
    |   T_YIELD                                         { $$ = expr.NewYield(nil, nil) }
    |   T_YIELD expr                                    { $$ = expr.NewYield(nil, $2) }
    |   T_YIELD expr T_DOUBLE_ARROW expr                { $$ = expr.NewYield($2, $4) }
    |   T_YIELD_FROM expr                               { $$ = expr.NewYieldFrom($2) }
    |   T_FUNCTION returns_ref '(' parameter_list ')' lexical_vars return_type '{' inner_statement_list '}'
            {
                $$ = expr.NewClosure($4, $6, $7, $9, false, $2 == "true")
            }
    |   T_STATIC T_FUNCTION returns_ref '(' parameter_list ')' lexical_vars return_type '{' inner_statement_list '}'
            {
                $$ = expr.NewClosure($5, $7, $8, $10, true, $3 == "true")
            }
;

returns_ref:
        /* empty */                                     { $$ = "false"; }
    |   '&'                                             { $$ = "true"; }
;

lexical_vars:
        /* empty */                                     { $$ = []node.Node{} }
    |   T_USE '(' lexical_var_list ')'                  { $$ = $3; }
;

lexical_var_list:
        lexical_var_list ',' lexical_var                { $$ = append($1, $3) }
    |   lexical_var                                     { $$ = []node.Node{$1} }
;

lexical_var:
        T_VARIABLE                                      { $$ = expr.NewClusureUse(expr.NewVariable(node.NewIdentifier($1)), false) }
    |   '&' T_VARIABLE                                  { $$ = expr.NewClusureUse(expr.NewVariable(node.NewIdentifier($2)), true) }
;

function_call:
        name argument_list                              { $$ = expr.NewFunctionCall($1, $2) }
    |   class_name T_PAAMAYIM_NEKUDOTAYIM member_name argument_list
                                                        { $$ = expr.NewStaticCall($1, $3, $4) }
    |   variable_class_name T_PAAMAYIM_NEKUDOTAYIM member_name argument_list
                                                        { $$ = expr.NewStaticCall($1, $3, $4) }
    |   callable_expr argument_list                     { $$ = expr.NewFunctionCall($1, $2) }
;

class_name:
        T_STATIC                                        { $$ = node.NewSimpleNode("Static") }
    |   name                                            { $$ = $1; }
;

class_name_reference:
        class_name                                      { $$ = $1; }
    |   new_variable                                    { $$ = $1; }
;

exit_expr:
        /* empty */                                     { $$ = node.NewSimpleNode("") }
    |   '(' optional_expr ')'                           { $$ = $2; }
;

backticks_expr:
        /* empty */                                     { $$ = []node.Node{} }
    |   T_ENCAPSED_AND_WHITESPACE                       { $$ = []node.Node{scalar.NewEncapsedStringPart($1)} }
    |   encaps_list                                     { $$ = $1; }
;

ctor_arguments:
        /* empty */	                                    { $$ = nil }
    |   argument_list                                   { $$ = $1 }
;

dereferencable_scalar:
        T_ARRAY '(' array_pair_list ')'                 { $$ = expr.NewArray($1, $4, $3) }
    |   '[' array_pair_list ']'                         { $$ = expr.NewShortArray($1, $3, $2) }
    |   T_CONSTANT_ENCAPSED_STRING                      { $$ = scalar.NewString($1) }
;

scalar:
        T_LNUMBER                                       { $$ = scalar.NewLnumber($1) }
    |   T_DNUMBER                                       { $$ = scalar.NewDnumber($1) }
    |   T_LINE                                          { $$ = scalar.NewMagicConstant($1) }
    |   T_FILE                                          { $$ = scalar.NewMagicConstant($1) }
    |   T_DIR                                           { $$ = scalar.NewMagicConstant($1) }
    |   T_TRAIT_C                                       { $$ = scalar.NewMagicConstant($1) }
    |   T_METHOD_C                                      { $$ = scalar.NewMagicConstant($1) }
    |   T_FUNC_C                                        { $$ = scalar.NewMagicConstant($1) }
    |   T_NS_C                                          { $$ = scalar.NewMagicConstant($1) }
    |   T_CLASS_C                                       { $$ = scalar.NewMagicConstant($1) }
    |   T_START_HEREDOC T_ENCAPSED_AND_WHITESPACE T_END_HEREDOC 
                                                        { $$ = scalar.NewString($2) /* TODO: mark as Heredoc*/ }
    |   T_START_HEREDOC T_END_HEREDOC
                                                        { $$ = scalar.NewEncapsed($1, nil, $2) }
    |   '"' encaps_list '"'                             { $$ = scalar.NewEncapsed($1, $2, $3) }
    |   T_START_HEREDOC encaps_list T_END_HEREDOC       { $$ = scalar.NewEncapsed($1, $2, $3) }
    |   dereferencable_scalar                           { $$ = $1; }
    |   constant                                        { $$ = $1; }
;

constant:
        name                                            { $$ = expr.NewConstFetch($1) }
    |   class_name T_PAAMAYIM_NEKUDOTAYIM identifier    { $$ = expr.NewClassConstFetch($1, $3) }
    |   variable_class_name T_PAAMAYIM_NEKUDOTAYIM identifier
                                                        { $$ = expr.NewClassConstFetch($1, $3) }
;

expr:
        variable                                        { $$ = $1; }
    |   expr_without_variable                           { $$ = $1; }
;

optional_expr:
        /* empty */                                     { $$ = node.NewSimpleNode("optional node. TODO: must be nil") }
    |   expr                                            { $$ = $1; }
;

variable_class_name:
    dereferencable                                      { $$ = $1; }
;

dereferencable:
        variable                                        { $$ = $1; }
    |   '(' expr ')'                                    { $$ = $2; }
    |   dereferencable_scalar                           { $$ = $1; }
;

callable_expr:
        callable_variable                               { $$ = $1; }
    |   '(' expr ')'                                    { $$ = $2; }
    |   dereferencable_scalar                           { $$ = $1; }
;

callable_variable:
    simple_variable                                     { $$ = $1; }
    |   dereferencable '[' optional_expr ']'            { $$ = expr.NewArrayDimFetch($1, $3) }
    |   constant '[' optional_expr ']'                  { $$ = expr.NewArrayDimFetch($1, $3) }
    |   dereferencable '{' expr '}'                     { $$ = expr.NewArrayDimFetch($1, $3) }
    |   dereferencable T_OBJECT_OPERATOR property_name argument_list
                                                        { $$ = expr.NewMethodCall($1, $3, $4) }
    |   function_call                                   { $$ = $1; }
;

variable:
        callable_variable                               { $$ = $1; }
    |   static_member                                   { $$ = $1; }
    |   dereferencable T_OBJECT_OPERATOR property_name  { $$ = expr.NewPropertyFetch($1, $3) }
;

simple_variable:
        T_VARIABLE                                      { $$ = expr.NewVariable(node.NewIdentifier($1)) }
    |   '$' '{' expr '}'                                { $$ = expr.NewVariable($3) }
    |   '$' simple_variable                             { $$ = expr.NewVariable($2) }
;

static_member:
        class_name T_PAAMAYIM_NEKUDOTAYIM simple_variable
                                                        { $$ = expr.NewStaticPropertyFetch($1, $3) }
    |   variable_class_name T_PAAMAYIM_NEKUDOTAYIM simple_variable
                                                        { $$ = expr.NewStaticPropertyFetch($1, $3) }
;

new_variable:
        simple_variable                                 { $$ = $1 }
    |   new_variable '[' optional_expr ']'              { $$ = expr.NewArrayDimFetch($1, $3) }
    |   new_variable '{' expr '}'                       { $$ = expr.NewArrayDimFetch($1, $3) }
    |   new_variable T_OBJECT_OPERATOR property_name    { $$ = expr.NewPropertyFetch($1, $3) }
    |   class_name T_PAAMAYIM_NEKUDOTAYIM simple_variable
                                                        { $$ = expr.NewStaticPropertyFetch($1, $3) }
    |   new_variable T_PAAMAYIM_NEKUDOTAYIM simple_variable
                                                        { $$ = expr.NewStaticPropertyFetch($1, $3) }
;

member_name:
        identifier                                      { $$ = node.NewSimpleNode("MemberName").Attribute("value", $1.Value); }
    |   '{' expr '}'                                    { $$ = $2; }
    |   simple_variable                                 { $$ = $1 }
;

property_name:
        T_STRING                                        { $$ = node.NewIdentifier($1) }
    |   '{' expr '}'                                    { $$ = $2; }
    |   simple_variable                                 { $$ = $1 }
;

array_pair_list:
    non_empty_array_pair_list
        {
            if ($1[len($1)-1] == nil) {
                $$ = $1[:len($1)-1]
            } else {
                $$ = $1
            }
        }
;

possible_array_pair:
        /* empty */                                     { $$ = nil }
    |   array_pair                                      { $$ = $1; }
;

non_empty_array_pair_list:
        non_empty_array_pair_list ',' possible_array_pair
                                                        { $$ = append($1, $3) }
    |   possible_array_pair                             { $$ = []node.Node{$1} }
;

array_pair:
        expr T_DOUBLE_ARROW expr                        { $$ = expr.NewArrayItem($1, $3, false) }
    |   expr                                            { $$ = expr.NewArrayItem(nil, $1, false) }
    |   expr T_DOUBLE_ARROW '&' variable                { $$ = expr.NewArrayItem($1, $4, true) }
    |   '&' variable                                    { $$ = expr.NewArrayItem(nil, $2, true) }
    |   expr T_DOUBLE_ARROW T_LIST '(' array_pair_list ')'
            {
                // TODO: Cannot use list() as standalone expression
                list := expr.NewList($5)
                $$ = expr.NewArrayItem($1, list, false)
            }
    |   T_LIST '(' array_pair_list ')'
            {
                // TODO: Cannot use list() as standalone expression
                list := expr.NewList($3)
                $$ = expr.NewArrayItem(nil, list, false)
            }
;

encaps_list:
        encaps_list encaps_var                          { $$ = append($1, $2) }
    |   encaps_list T_ENCAPSED_AND_WHITESPACE           { $$ = append($1, scalar.NewEncapsedStringPart($2)) }
    |   encaps_var                                      { $$ = []node.Node{$1} }
    |   T_ENCAPSED_AND_WHITESPACE encaps_var            { $$ = []node.Node{scalar.NewEncapsedStringPart($1), $2} }
;

encaps_var:
        T_VARIABLE                                      { $$ = expr.NewVariable(node.NewIdentifier($1)) }
    |   T_VARIABLE '[' encaps_var_offset ']'            { $$ = expr.NewArrayDimFetch(expr.NewVariable(node.NewIdentifier($1)), $3) }
    |   T_VARIABLE T_OBJECT_OPERATOR T_STRING           { $$ = expr.NewPropertyFetch(expr.NewVariable(node.NewIdentifier($1)), node.NewIdentifier($3)) }
    |   T_DOLLAR_OPEN_CURLY_BRACES expr '}'             { $$ = expr.NewVariable($2) }
    |   T_DOLLAR_OPEN_CURLY_BRACES T_STRING_VARNAME '}' { $$ = expr.NewVariable(node.NewIdentifier($2)) }
    |   T_DOLLAR_OPEN_CURLY_BRACES T_STRING_VARNAME '[' expr ']' '}'
                                                        { $$ = expr.NewArrayDimFetch(expr.NewVariable(node.NewIdentifier($2)), $4) }
    |   T_CURLY_OPEN variable '}'                       { $$ = $2; }
;
encaps_var_offset:
        T_STRING                                        { $$ = node.NewSimpleNode("OffsetString").Attribute("value", $1.String()) }
    |   T_NUM_STRING                                    { $$ = node.NewSimpleNode("OffsetNumString").Attribute("value", $1.String()) }
    |   '-' T_NUM_STRING                                { $$ = node.NewSimpleNode("OffsetNegateNumString").Attribute("value", $2.String()) }
    |   T_VARIABLE                                      { $$ = node.NewSimpleNode("OffsetVariable").Attribute("value", $1.String()) }
;

internal_functions_in_yacc:
        T_ISSET '(' isset_variables possible_comma ')'  { $$ = expr.NewIsset($3) }
    |   T_EMPTY '(' expr ')'                            { $$ = expr.NewEmpty($3) }
    |   T_INCLUDE expr                                  { $$ = expr.NewInclude($2) }
    |   T_INCLUDE_ONCE expr                             { $$ = expr.NewIncludeOnce($2) }
    |   T_EVAL '(' expr ')'                             { $$ = expr.NewEval($3) }
    |   T_REQUIRE expr                                  { $$ = expr.NewRequire($2) }
    |   T_REQUIRE_ONCE expr                             { $$ = expr.NewRequireOnce($2) }
;

isset_variables:
        isset_variable                                  { $$ = []node.Node{$1} }
    |   isset_variables ',' isset_variable              { $$ = append($1, $3) }
;

isset_variable:
    expr                                                { $$ = $1 }
;

/////////////////////////////////////////////////////////////////////////

%%