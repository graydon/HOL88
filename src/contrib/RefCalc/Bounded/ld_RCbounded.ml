% File: ld_RCbounded.ml
   Loads the RCbounded theory
%

extend_theory `RCbounded`;;

let  state  = ":*s"
 and state1 = ":*s1"
 and state2 = ":*s2"
 and state3 = ":*s3"
 and astate = ":*a#*s"
 and cstate = ":*c#*s";;
let  pred  = ":^state->bool"
 and pred1 = ":^state1->bool"
 and pred2 = ":^state2->bool"
 and pred3 = ":^state3->bool"
 and apred = ":^astate->bool"
 and cpred = ":^cstate->bool";;
let  ptrans  = ":^pred->^pred"
 and ptrans12 = ":^pred1->^pred2"
 and ptrans23 = ":^pred2->^pred3"
 and aptrans = ":^apred->^apred"
 and cptrans = ":^cpred->^cpred";;
let arel = ":*a#*c#*s->bool";;

load_library `taut`;;
let TAUT t = TAC_PROOF(([],t),TAUT_TAC);;

loadf `defs`;;

let autoload_defs thy =
  map (\name. autoload_theory(`definition`,thy,name))
      (map fst (definitions thy));;
let autoload_thms thy =
  map (\name. autoload_theory(`theorem`,thy,name))
      (map fst (theorems thy));;

autoload_defs `RCpredicate`;;
autoload_thms `RCpredicate`;;
loadf `Predicate/RCpredicate_convs`;;

autoload_defs `RCcommand`;;
autoload_thms `RCcommand`;;
loadf `Command/RCcommand_convs`;;

autoload_defs `RCcorrect`;;
autoload_thms `RCcorrect`;;
load_library `pair`;;
loadf `Correct/RCcorrect_convs`;;

autoload_defs `RCrefine`;;
autoload_thms `RCrefine`;;

autoload_defs `RCrecursion`;;
autoload_thms `RCrecursion`;;

autoload_defs `RCdataref`;;
autoload_thms `RCdataref`;;

autoload_defs `RCbounded`;;
autoload_thms `RCbounded`;;
