open Proj2_types;;

let ls = ["a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";"m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"w";"x";"y";"z"];;

let inList a l = List.mem a l;;

 let tester a = inList a ls;;

 let rec checker = function
  |[] ->[]
  |h::t -> if tester h then h::(checker t) else checker t;;

 let rec remove_dups lst= match lst with
| [] -> []
| h::t -> h::(remove_dups (List.filter (fun x -> x<>h) t))
 ;;

 let print_string = function
         |[] -> []
         |h::t ->h::t ;;


 let rec gen list var carry = match var with
  |[] ->  List.rev list, carry
  |(a,b)::tl -> if carry = true && b = false then gen ((a, false)::list) tl false
else if carry = true && b = true then gen ((a,false)::list) tl true
else if carry = false && b = false then gen((a,true)::list) tl false
else if carry = false && b = true then gen((a,false)::list) tl false
else gen((a,true)::list) tl carry;;

let rec get list = match list with
[]-> []
|h::t -> if h = ")" then t else get t;;

let fetch name = match name with
|TreeNode(h, []) -> h
|TreeNode(h, [_]) -> h
|TreeNode (h, _::_::_) -> h;;


let rec buildParseTree (input : string list) : tree =  let rec parse_S list = match list with
[] -> TreeNode("S", [])
|")"::t -> TreeNode(")",[])
|"TRUE"::t -> TreeNode("S",[TreeNode("TRUE", [])])
|"FALSE"::t -> TreeNode("S",[TreeNode("FALSE", [])])
|"("::a::t -> TreeNode("S",[TreeNode("(",[]);TreeNode("T", parse_T (a::t)); TreeNode(")",[])])
|h::[] -> TreeNode("S", [TreeNode(h, [])]) 
and 
parse_T list = match list with
[] -> []
|"and"::a::c::t -> let a1 = get t in if a = "(" then [TreeNode("and",[]);parse_S (a::c::t);parse_S a1] else if c = "(" then [TreeNode("and",[]);TreeNode("S",[TreeNode(a, [])]);parse_S (c::t)] else [TreeNode("and",[]);TreeNode("S",[TreeNode(a,[])]);TreeNode("S",[TreeNode(c,[])])]
|"or"::a::c::t -> let a1 = get t in if a = "(" then [TreeNode("or",[]);parse_S (a::c::t);parse_S a1] else if c = "(" then [TreeNode("and",[]);TreeNode("S",[TreeNode(a, [])]);parse_S (c::t)] else [TreeNode("or",[]);TreeNode("S",[TreeNode(a,[])]);TreeNode("S",[TreeNode(c,[])])]
|"not"::a::t -> let a1 = get t in if a = "(" then [TreeNode("not",[]);parse_S (a::t);parse_S a1] else [TreeNode("not",[]);TreeNode("S",[TreeNode(a,[])])]
in parse_S input;;





let rec buildAbstractSyntaxTree (input : tree) : tree = match input with
|TreeNode("S", [a]) -> a
|TreeNode("S", [a;b;c]) -> buildAbstractSyntaxTree b
|TreeNode("T", [a;b]) -> let a1 = fetch a in TreeNode(a1, [buildAbstractSyntaxTree b])
|TreeNode("T", [a;b;c]) -> let a1 = fetch a in TreeNode(a1, [buildAbstractSyntaxTree b; buildAbstractSyntaxTree c]);;




let scanVariable (input : string list) : string list = let rec checker = 
   function
  |[] ->[]
  |h::t -> if tester h then h::(checker t) else checker t in 
  let dog = checker input in 
  let dogstring = remove_dups dog in 
  print_string dogstring;;


let generateInitialAssignList (varList : string list) : (string * bool) list = let rec aux count acc = function
  |[] -> []
  |[x] -> (x, count) :: acc
  |a :: (b :: _ as t) -> if a = b then aux(count) acc t
  else aux false ((a, count) :: acc) t in 
  List.rev(aux false [] varList);;


let generateNextAssignList (assignList : (string * bool) list) : (string * bool) list * bool = match assignList with
  |[] -> gen [] assignList true
|(a,b)::[] -> gen [] assignList true 
  |(a,b)::(c,d)::t -> if b=d then gen [] assignList true else gen [] assignList false;;

let rec lookupVar (assignList : (string * bool) list) (str : string) : bool = match assignList  with
|[] -> raise Not_found
|(a,b)::t -> if a = str then b else lookupVar t str;;


let evaluateTree (t : tree) (assignList : (string * bool) list) : bool = match assignList with
  |[] -> false
  |(a,b)::[] -> false 
  |(a,b)::(c,d)::_ -> if b = true || d = true then true else false;;

let satisfiable (input : string list) : (string * bool) list list = let a1 = input in 
let a2 = buildParseTree a1 in
let a3 = buildAbstractSyntaxTree a2 in 
let rec check tree = match tree with 
|TreeNode("not", [a]) -> if fetch a = "and"||fetch a = "or" then check a else [[(fetch a, false)]]
|TreeNode("FALSE", [])-> [[]]
|TreeNode("TRUE" ,[]) -> [[]]
|TreeNode("and", [a;b]) -> if fetch b = "FALSE" then [] else if fetch b = "TRUE" then check a else if fetch b = "not" then [] else if fetch b = "not" then [] else [[(fetch a, true);(fetch b, true)]]
|TreeNode("or", [a;b]) -> if fetch b = "FALSE" then check a else if fetch b = "TRUE" then check a else [[(fetch a, true);(fetch b, true)];[(fetch a, false);(fetch b, true)];[(fetch a, true);(fetch b, false)]]
|TreeNode(h, []) -> [[(h, true)]]
in check a3;;
