% ===================================================================== %
% FILE		: mk_more_gp.ml						%
% DESCRIPTION   : creates the some of the hogher-order theory of groups.%
%                 The resulting theory file is called more_gp.th.  No   %
%                 group theory involving finite set theory is included. %
%									%
% AUTHOR	: E. L. Gunter						%
% DATE		: 89.3.21						%
%									%
% ===================================================================== %

new_theory `more_gp`;;
new_parent `elt_gp`;;

loadt `load_elt_gp`;;


%A subset of a group is called a subgroup if it forms a group under the
 product of the group.%

let SUBGROUP_DEF = new_definition(`SUBGROUP_DEF`, "SUBGROUP (G,prod) H =
  (GROUP(G, prod) /\(!x:*. (H x) ==> (G x)) /\ GROUP(H,prod))");;

%SUBGROUP_DEF = 
|- SUBGROUP(G,prod)H =
   GROUP(G,prod) /\ (!x. H x ==> G x) /\ GROUP(H,prod)%


let SBGP_ID_GP_ID = prove_thm (`SBGP_ID_GP_ID`, "(SUBGROUP(G,prod) H) ==>
  (ID(H,prod) = ID(G,prod):*)",
((NEW_SUBST1_TAC (SPEC_ALL SUBGROUP_DEF)) THEN
 STRIP_TAC THEN
 ((SUPPOSE_TAC "(H:* -> bool) (ID(H,prod))") THENL
   [RES_TAC;GROUP_ELT_TAC]) THEN
 (MP_IMP_TAC (UNDISCH (UNDISCH (STRONG_INST [("ID(H,prod):*","x:*")]
   (hd (IMP_CANON (SPEC "ID(H,prod):*" (UNDISCH UNIQUE_ID)))))))) THEN
 (ACCEPT_TAC (UNDISCH (SPEC "ID(H,prod):*" (CONJUNCT1 (CONJUNCT2 (UNDISCH
     (STRONG_INST [("H:* -> bool","G:* -> bool")] ID_LEMMA)))))))));;

%SBGP_ID_GP_ID = |- SUBGROUP(G,prod)H ==> (ID(H,prod) = ID(G,prod))%


let SBGP_INV_GP_INV = prove_thm (`SBGP_INV_GP_INV`,"(SUBGROUP(G,prod) H) ==>
   (!x:*. (H x) ==> ((INV(H,prod)x = INV(G,prod)x)))",
((REPEAT STRIP_TAC) THEN
 (ASSUME_LIST_TAC (CONJUNCTS (UNDISCH (fst
   (EQ_IMP_RULE (SPEC_ALL SUBGROUP_DEF))))))THEN
 ((SUPPOSE_TAC "(H:* -> bool) (INV(H,prod)x)") THENL
  [RES_TAC;GROUP_ELT_TAC]) THEN
 (MP_IMP_TAC (UNDISCH (hd (IMP_CANON (SPEC "INV(H,prod)x:*" (UNDISCH
  (SPEC "x:*" (UNDISCH UNIQUE_INV)))))))) THEN
 (NEW_SUBST1_TAC (SYM (UNDISCH (SBGP_ID_GP_ID)))) THEN
 (ACCEPT_TAC (CONJUNCT1 (UNDISCH (SPEC "x:*" (UNDISCH
     (STRONG_INST [("H:* -> bool","G:* -> bool")] INV_LEMMA))))))));;

%SBGP_INV_GP_INV = 
|- SUBGROUP(G,prod)H ==> (!x. H x ==> (INV(H,prod)x = INV(G,prod)x))%

% Proof rewritten for HOL version 1.12 	[TFM 91.01.24]			%

let SBGP_SBGP_LEMMA =
    prove_thm
    (`SBGP_SBGP_LEMMA`,
     "SUBGROUP((G:* -> bool),prod)H /\ SUBGROUP(H,prod)K1 ==>
      SUBGROUP(G,prod)K1",
     PURE_ONCE_REWRITE_TAC [SUBGROUP_DEF] THEN
     REPEAT STRIP_TAC THEN
     REPEAT (FIRST_ASSUM MATCH_MP_TAC) THEN
     FIRST_ASSUM ACCEPT_TAC);;


%SBGP_SBGP_LEMMA = 
|- SUBGROUP(G,prod)(H:* -> bool) /\ SUBGROUP(H,prod)(K1:* -> bool) ==>
   SUBGROUP(G,prod)(K1:* -> bool) %


let GROUP_IS_SBGP = prove_thm(`GROUP_IS_SBGP`,
"GROUP(G,prod) ==> SUBGROUP (G:* -> bool,prod)G",
(REWRITE_TAC[SUBGROUP_DEF]));;

%GROUP_IS_SBGP = |- GROUP(G,prod) ==> SUBGROUP(G,prod)G%


let ID_IS_SBGP =prove_thm(`ID_IS_SBGP`, "GROUP((G:* -> bool),prod) ==>
   SUBGROUP(G,prod)(\x.x = ID(G,prod))",
(DISCH_TAC THEN (PURE_ONCE_REWRITE_TAC [SUBGROUP_DEF]) THEN BETA_TAC THEN
 STRIP_TAC THENL [(FIRST_ASSUM ACCEPT_TAC);ALL_TAC] THEN STRIP_TAC THENL
 [(GEN_TAC THEN DISCH_TAC THEN (ASM_REWRITE_TAC[]) THEN GROUP_ELT_TAC);
  ((PURE_ONCE_REWRITE_TAC[GROUP_DEF]) THEN BETA_TAC THEN
   (STRIP_ASSUME_TAC (UNDISCH (ID_LEMMA))) THEN STRIP_TAC THENL
   [ALL_TAC;STRIP_TAC] THENL
   [ALL_TAC;ALL_TAC;
    ((EXISTS_TAC "ID(G,prod):*") THEN (REPEAT STRIP_TAC) THEN
     (((EXISTS_TAC "ID(G,prod):*") THEN STRIP_TAC) ORELSE ALL_TAC))] THEN
   (REFL_TAC ORELSE ALL_TAC) THENL
   [((REPEAT GEN_TAC) THEN (REPEAT STRIP_TAC));
    ((REPEAT GEN_TAC) THEN (REPEAT STRIP_TAC));ALL_TAC;ALL_TAC] THEN
   (RES_TAC THEN ASM_REWRITE_TAC []))]));;

%ID_IS_SBGP = |- GROUP(G,prod) ==> SUBGROUP(G,prod)(\x. x = ID(G,prod))%


let SUBGROUP_LEMMA = prove_thm(`SUBGROUP_LEMMA`,
"SUBGROUP(G:* -> bool,prod)H = (GROUP(G,prod) /\
 (?x:*. H x) /\ (!x. H x ==> G x) /\ (!x y. (H x /\ H y) ==> H(prod x y)) /\
 (!x. H x ==> H(INV(G,prod)x)))",
((PURE_REWRITE_TAC [SUBGROUP_DEF]) THEN
 (EQ_TAC THENL
  [((REPEAT STRIP_TAC) THEN RES_TAC THEN GROUP_ELT_TAC);
   (STRIP_TAC THEN (ASM_REWRITE_TAC []))]) THENL
 [((EXISTS_TAC "ID(H:* -> bool,prod)") THEN GROUP_ELT_TAC);
  ((NEW_SUBST1_TAC (SYM (UNDISCH_ALL (hd (IMP_CANON
    (PURE_ONCE_REWRITE_RULE [SUBGROUP_DEF] SBGP_INV_GP_INV)))))) THEN
   GROUP_ELT_TAC);
  ((STRIP_ASSUME_TAC (UNDISCH(fst(EQ_IMP_RULE (SPEC_ALL GROUP_DEF))))) THEN
   (PURE_ONCE_REWRITE_TAC[GROUP_DEF]) THEN
   (STRIP_TAC THENL [(FIRST_ASSUM ACCEPT_TAC);CONJ_TAC]) THENL
    [((CONV_TAC (GEN_ALPHA_CONV "w:*")) THEN (REPEAT STRIP_TAC) THEN
     (IMP_RES_TAC (ASSUME "!x:*. H x ==> G x")) THEN
     (NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON
      (ASSUME "!(x:*) y z.
          G x /\ G y /\ G z ==> (prod(prod x y)z = prod x(prod y z))"))))));
    ((EXISTS_TAC "ID(G:* -> bool,prod)") THEN (REPEAT CONJ_TAC) THEN
     (((CONV_TAC (GEN_ALPHA_CONV "w:*")) THEN (REPEAT STRIP_TAC))
        ORELSE ALL_TAC) THEN
     (IMP_RES_TAC (ASSUME "!x:*. H x ==> G x")) THENL
     [((NEW_SUBST1_TAC
         (SYM(CONJUNCT1(UNDISCH(SPEC"x:*"(UNDISCH INV_LEMMA)))))) THEN
       (IMP_RES_TAC (ASSUME "!x:*. H x ==> H(INV(G,prod)x)")) THEN
       (REDUCE_TAC [(ASSUME "!(x:*) y. H x /\ H y ==> H(prod x y)")]));
       (NEW_MATCH_ACCEPT_TAC
         (UNDISCH(SPEC_ALL(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA))))));
      ((IMP_RES_TAC (ASSUME "!x:*. H x ==> H(INV(G,prod)x)")) THEN
       (EXISTS_TAC "INV(G:* -> bool,prod)w") THEN 
       (ASM_REWRITE_TAC
          [(CONJUNCT1(UNDISCH(SPEC"w:*"(UNDISCH INV_LEMMA))))]))])])]));;

%SUBGROUP_LEMMA = 
|- SUBGROUP(G,prod)H =
   GROUP(G,prod) /\
   (?x. H x) /\
   (!x. H x ==> G x) /\
   (!x y. H x /\ H y ==> H(prod x y)) /\
   (!x. H x ==> H(INV(G,prod)x)) %


let SBGP_INTERSECTION = prove_thm(`SBGP_INTERSECTION`,"(?j:** .(Ind j)) ==>
 ((!i:**. (Ind i) ==> SUBGROUP(G,prod)(H i)) ==>
  SUBGROUP(G,prod)(\x:*. (!i. (Ind i) ==> ((H i) x))))",
(DISCH_TAC THEN DISCH_TAC THEN
 (ASSUME_TAC (PURE_REWRITE_RULE[SUBGROUP_DEF]
   (ASSUME "!i:**. Ind i ==> SUBGROUP(G:* -> bool,prod)(H i)"))) THEN
 (ASSUME_TAC (SELECT_RULE (ASSUME "?j:**. Ind j"))) THEN
 (PURE_ONCE_REWRITE_TAC[SUBGROUP_LEMMA]) THEN BETA_TAC THEN
 (CONJ_TAC THENL [ALL_TAC;(ASM_CONJ1_TAC THEN (REPEAT STRIP_TAC))]) THEN
 RES_TAC THENL
 [((EXISTS_TAC "ID(G:* -> bool,prod)") THEN (REPEAT STRIP_TAC) THEN
   RES_TAC THEN
   (NEW_SUBST1_TAC (SYM (UNDISCH 
     (STRONG_INST [("H (i:**):* -> bool","H:* -> bool")] SBGP_ID_GP_ID)))) THEN
   GROUP_ELT_TAC);
   GROUP_ELT_TAC;
  ((NEW_SUBST1_TAC (SYM (UNDISCH (SPEC "x:*" (UNDISCH
    (STRONG_INST [("H (i:**):* -> bool","H:* -> bool")]
       SBGP_INV_GP_INV)))))) THEN
   GROUP_ELT_TAC)]));;

%SBGP_INTERSECTION = 
|- (?j. Ind j) ==>
   (!i. Ind i ==> SUBGROUP(G,prod)(H i)) ==>
   SUBGROUP(G,prod)(\x. !i. Ind i ==> H i x)%


let COR_SBGP_INT = prove_thm(`COR_SBGP_INT`,
"((SUBGROUP(G,prod)(H:* -> bool)) /\
 (SUBGROUP(G,prod)K1)) ==> (SUBGROUP(G,prod)(\x.(H x) /\ (K1 x)))",
(STRIP_TAC THEN
 (SUPPOSE_TAC "(\x:*.H x /\ K1 x) = (\x:*.!i.(i = H)\/(i = K1) ==> i x)") THENL
  [((SUPPOSE_TAC "?j:* -> bool. (j = H) \/ (j = K1)") THENL
    [(((ASM_REWRITE_TAC[]) THEN (MP_IMP_TAC (UNDISCH 
         (REWRITE_RULE [(BETA_CONV "(\j:* -> bool. j)i");
           (BETA_CONV "(\j:* -> bool. (j = H) \/ (j = K1))i")]
         (STRONG_INST [("\j:* -> bool.((j = H) \/ (j = K1))",
                 "Ind:(* -> bool) -> bool");
            ("\j:* -> bool.j","H:(* -> bool) -> (* -> bool)")]
         (INST_TYPE [(":* -> bool",":**")] SBGP_INTERSECTION)))))) THEN
      (GEN_TAC THEN STRIP_TAC THEN ASM_REWRITE_TAC[]));
     ((EXISTS_TAC "H:* -> bool") THEN DISJ1_TAC THEN  REFL_TAC)]);
   (((EXT_TAC "x:*") THEN BETA_TAC THEN GEN_TAC THEN EQ_TAC) THENL
    [((REPEAT STRIP_TAC) THEN (ASM_REWRITE_TAC[]));
     (DISCH_TAC THEN ACCEPT_TAC (
      let th = (ASSUME "!i:* -> bool.(i = H) \/ (i = K1) ==> i x") in
      (CONJ (MP (hd (IMP_CANON (SPEC "H:* -> bool" th))) (REFL "H:* -> bool"))
      (MP (hd (tl (IMP_CANON (SPEC "K1:* -> bool" th))))
        (REFL "K1:* -> bool")))))])]));;

%COR_SBGP_INT = 
|- SUBGROUP(G,prod)H /\ SUBGROUP(G,prod)K1 ==>
   SUBGROUP(G,prod)(\x. H x /\ K1 x)%


let LEFT_COSET_DEF =
new_definition (`LEFT_COSET_DEF`,"LEFT_COSET(G,prod) H x (y:*) =
 (GROUP(G,prod) /\ SUBGROUP(G,prod)H /\ G x /\ G y /\
  (?h. ((H h) /\ (y = prod x h))))");;

%LEFT_COSET_DEF = 
|- LEFT_COSET(G,prod)H x y =
   GROUP(G,prod) /\
   SUBGROUP(G,prod)H /\
   G x /\
   G y /\
   (?h. H h /\ (y = prod x h))%


let LEFT_COSETS_COVER = prove_thm(`LEFT_COSETS_COVER`,
"SUBGROUP(G,prod)H ==>
 (!x:*. (G x) ==> LEFT_COSET(G,prod)H x x)",
((REPEAT STRIP_TAC) THEN
 (STRIP_ASSUME_TAC (UNDISCH(fst (EQ_IMP_RULE (SPEC_ALL SUBGROUP_DEF))))) THEN
 (ASM_REWRITE_TAC [LEFT_COSET_DEF]) THEN
 (EXISTS_TAC "ID(G,prod):*") THEN CONJ_TAC THENL
 [((NEW_SUBST1_TAC (SYM (UNDISCH (SBGP_ID_GP_ID)))) THEN GROUP_ELT_TAC);
  (ACCEPT_TAC (SYM (UNDISCH (SPEC "x:*" (CONJUNCT1 (CONJUNCT2 (CONJUNCT2
    (UNDISCH ID_LEMMA))))))))]));;

%LEFT_COSETS_COVER = 
|- SUBGROUP(G,prod)H ==> (!x. G x ==> LEFT_COSET(G,prod)H x x)%


let LEFT_COSET_DISJOINT_LEMMA = prove_thm(`LEFT_COSET_DISJOINT_LEMMA`,
"SUBGROUP(G,prod)H ==> !x (y:*).((G x) /\ (G y)) ==> 
 (?w.(LEFT_COSET(G,prod)H x w /\ LEFT_COSET(G,prod)H y w)) ==>
  (!z.(LEFT_COSET(G,prod)H x z ==> LEFT_COSET(G,prod)H y z))",
(DISCH_TAC THEN
 (STRIP_ASSUME_TAC (UNDISCH (fst (EQ_IMP_RULE (SPEC_ALL SUBGROUP_DEF))))) THEN
 STRIP_TAC THEN STRIP_TAC THEN STRIP_TAC THEN
 (ASM_REWRITE_TAC[LEFT_COSET_DEF]) THEN
 ((REPEAT STRIP_TAC) THEN
  ((FIRST_ASSUM ACCEPT_TAC) ORELSE ALL_TAC)) THEN
 ((EXISTS_TAC "prod(prod h'(INV(G,prod)h))(h'':*)") THEN CONJ_TAC THENL
  [((NEW_SUBST1_TAC (SYM (UNDISCH (SPEC "h:*" (UNDISCH SBGP_INV_GP_INV)))))
    THEN GROUP_ELT_TAC); ALL_TAC]) THEN
 RES_TAC THEN
 (GROUP_LEFT_ASSOC_TAC "prod (y:*)(prod(prod h'(INV(G,prod)h))h'')") THEN
 (GROUP_LEFT_ASSOC_TAC "prod (y:*)(prod h'(INV(G,prod)h))") THEN
 (REWRITE_TAC
  [(SYM (ASSUME "(w:*) = prod (y:*) (h':*)"));
   (ASSUME "(w:*) = prod (x:*) (h:*)")]) THEN
 (GROUP_RIGHT_ASSOC_TAC "prod(prod (x:*) h)(INV(G,prod)h)") THEN
 (NEW_SUBST1_TAC(CONJUNCT2 (UNDISCH (SPEC "h:*" (UNDISCH INV_LEMMA))))) THEN
 (NEW_SUBST1_TAC (UNDISCH (SPEC "x:*"
   (CONJUNCT1 (CONJUNCT2 (CONJUNCT2 (UNDISCH ID_LEMMA))))))) THEN
 (FIRST_ASSUM ACCEPT_TAC)));;

%LEFT_COSET_DISJOINT_LEMMA = 
|- SUBGROUP(G,prod)H ==>
   (!x y.
     G x /\ G y ==>
     (?w. LEFT_COSET(G,prod)H x w /\ LEFT_COSET(G,prod)H y w) ==>
     (!z. LEFT_COSET(G,prod)H x z ==> LEFT_COSET(G,prod)H y z))%


let LEFT_COSET_DISJOINT_UNION = prove_thm (`LEFT_COSET_DISJOINT_UNION`,
"SUBGROUP(G,prod)H ==>
((!x:*. (G x ==> (?y.G y /\ LEFT_COSET (G,prod) H y x))) /\
 (!x y. G x /\ G y ==>
  ((LEFT_COSET(G,prod)H x) = (LEFT_COSET(G,prod)H y)) \/
   ((\z.((LEFT_COSET(G,prod)H x z) /\ 
         (LEFT_COSET(G,prod)H y z))) = \z.F)))",
((REPEAT STRIP_TAC) THENL
 [((EXISTS_TAC "x:*") THEN
   (ASM_REWRITE_TAC [(UNDISCH (SPEC "x:*" (UNDISCH LEFT_COSETS_COVER)))]));
  ((ASM_CASES_TAC "LEFT_COSET(G,prod)H y (x:*)") THENL
   [(DISJ1_TAC THEN
     (EXT_TAC "z:*") THEN GEN_TAC THEN EQ_TAC THENL
     [((SPEC_TAC ("z:*","z:*")) THEN
       (MP_IMP_TAC 
          (PROVE_HYP (CONJ (ASSUME "(G:* -> bool)x") (ASSUME "(G:* -> bool)y"))
              (UNDISCH (SPEC_ALL (UNDISCH LEFT_COSET_DISJOINT_LEMMA))))) THEN
       (EXISTS_TAC "x:*") THEN
       (ASM_REWRITE_TAC
         [(UNDISCH (SPEC "x:*" (UNDISCH LEFT_COSETS_COVER)))]));
      ((SPEC_TAC ("z:*","z:*")) THEN
       (MP_IMP_TAC
          (PROVE_HYP (CONJ (ASSUME "(G:* -> bool)y") (ASSUME "(G:* -> bool)x"))
              (UNDISCH (SPECL ["y:*";"x:*"]
                  (UNDISCH LEFT_COSET_DISJOINT_LEMMA))))) THEN
       (EXISTS_TAC "x:*") THEN
       (ASM_REWRITE_TAC
          [(UNDISCH (SPEC "x:*" (UNDISCH LEFT_COSETS_COVER)))]))]);
   (DISJ2_TAC THEN (EXT_TAC "w:*") THEN BETA_TAC THEN
    (REWRITE_TAC[]) THEN 
    CONV_TAC FORALL_NOT_CONV THEN % changed by WW 29 Jan 94 (REPEAT STRIP_TAC)%
    (SUPPOSE_TAC "~(!z:*. LEFT_COSET(G,prod)H x z ==>
                         LEFT_COSET(G,prod)H y z)") THENL
    [(% deleted by WW 26 Jan 94 (REWRITE_TAC[]) THEN (REPEAT STRIP_TAC) THEN %
      (ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON (CONTRAPOS (PROVE_HYP
          (CONJ (ASSUME "(G:* -> bool)x") (ASSUME "(G:* -> bool)y"))
          (UNDISCH (SPEC_ALL (UNDISCH LEFT_COSET_DISJOINT_LEMMA))))))))));
     (STRIP_TAC THEN
      (POP_ASSUM (\thm.(ASSUME_TAC (MP (SPEC "x:*" thm)
       (UNDISCH (SPEC "x:*" (UNDISCH LEFT_COSETS_COVER))))))) THEN
      RES_TAC)])])]));;

%LEFT_COSET_DISJOINT_UNION = 
|- SUBGROUP(G,prod)H ==>
   (!x. G x ==> (?y. G y /\ LEFT_COSET(G,prod)H y x)) /\
   (!x y.
     G x /\ G y ==>
     (LEFT_COSET(G,prod)H x = LEFT_COSET(G,prod)H y) \/
     ((\z. LEFT_COSET(G,prod)H x z /\ LEFT_COSET(G,prod)H y z) =
      (\z. F)))%


let EQUIV_REL_DEF = new_definition(`EQUIV_REL_DEF`,
"EQUIV_REL (G:* -> bool) R =
   (!x. G x ==> R x x) /\
   (!x y. G x /\ G y ==> (R x y ==> R y x)) /\
   (!x y z. G x /\ G y /\ G z ==> (R x y /\ R y z ==> R x z))");;

%EQUIV_REL_DEF = 
|- EQUIV_REL G R =
   (!x. G x ==> R x x) /\
   (!x y. G x /\ G y ==> R x y ==> R y x) /\
   (!x y z. G x /\ G y /\ G z ==> R x y /\ R y z ==> R x z)%


let LEFT_COSET_EQUIV_REL = prove_thm(`LEFT_COSET_EQUIV_REL`,
"SUBGROUP(G:*->bool,prod)H ==> EQUIV_REL G (LEFT_COSET(G,prod)H)",
(STRIP_TAC THEN (PURE_ONCE_REWRITE_TAC[EQUIV_REL_DEF]) THEN
 (ASM_CONJ1_TAC THENL
  [(ACCEPT_TAC (UNDISCH LEFT_COSETS_COVER));ALL_TAC]) THEN
 ASM_CONJ1_TAC THEN (REPEAT STRIP_TAC) THEN RES_TAC THENL
 [((use_thm
    (PROVE_HYP (CONJ (ASSUME "(G:* -> bool)y") (ASSUME "(G:* -> bool)x"))
      (UNDISCH (SPECL ["y:*";"x:*"] (CONJUNCT2
         (UNDISCH LEFT_COSET_DISJOINT_UNION)))))
      DISJ_CASES_TAC) THENL
   [(ASM_REWRITE_TAC[]);
    (POP_ASSUM(\thm.
      (IMP_RES_TAC(fst(EQ_IMP_RULE(BETA_RULE (AP_THM thm "y:*")))))))]);
  ((use_thm
    (PROVE_HYP (CONJ (ASSUME "(G:* -> bool)x") (ASSUME "(G:* -> bool)y"))
      (UNDISCH (SPEC_ALL (CONJUNCT2 (UNDISCH LEFT_COSET_DISJOINT_UNION)))))
      DISJ_CASES_TAC) THENL
   [(ASM_REWRITE_TAC[]);
    (POP_ASSUM(\thm.
      (IMP_RES_TAC(fst(EQ_IMP_RULE(BETA_RULE (AP_THM thm "y:*")))))))])]));;

%LEFT_COSET_EQUIV_REL = 
|- SUBGROUP(G,prod)H ==> EQUIV_REL G(LEFT_COSET(G,prod)H)%


let LEFT_COSETS_SAME_SIZE = prove_thm(`LEFT_COSETS_SAME_SIZE`,
"SUBGROUP(G:* -> bool,prod)H ==>
 !x y. G x /\ G y ==> ?f g.
   (!u. LEFT_COSET(G,prod)H x u ==> LEFT_COSET(G,prod)H y (f u)) /\
   (!v. LEFT_COSET(G,prod)H y v ==> LEFT_COSET(G,prod)H x (g v)) /\
   (!u. LEFT_COSET(G,prod)H x u ==> ((g (f u)) = u)) /\
   (!v. LEFT_COSET(G,prod)H y v ==> ((f (g v)) = v))",
(DISCH_TAC THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[SUBGROUP_DEF]
   (ASSUME "SUBGROUP(G:* -> bool,prod)H"))) THEN
 (ASM_REWRITE_TAC[LEFT_COSET_DEF]) THEN
 (REPEAT STRIP_TAC) THEN
 (EXISTS_TAC "\z:*.prod y (prod(INV(G,prod)x)z)") THEN
 (EXISTS_TAC "\z:*.prod x (prod(INV(G,prod)y) z)") THEN
 BETA_TAC THEN
 ((REPEAT STRIP_TAC) THENL
  [ALL_TAC;GROUP_ELT_TAC;(EXISTS_TAC "h:*");ALL_TAC;GROUP_ELT_TAC;
   (EXISTS_TAC "h:*");ALL_TAC;ALL_TAC]) THEN
 (ASM_REWRITE_TAC []) THEN RES_TAC THENL
 [((GROUP_LEFT_ASSOC_TAC "prod(INV(G,prod)x)(prod (x:*) h)") THEN
   (REWRITE_TAC
     [(CONJUNCT1(UNDISCH(SPEC"x:*"(UNDISCH INV_LEMMA))));
      (UNDISCH(SPEC"h:*"(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))))]));
  ((GROUP_LEFT_ASSOC_TAC "prod(INV(G,prod)y)(prod (y:*) h)") THEN
   (REWRITE_TAC
     [(CONJUNCT1(UNDISCH(SPEC"y:*"(UNDISCH INV_LEMMA))));
      (UNDISCH(SPEC"h:*"(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))))]));
  ((GROUP_LEFT_ASSOC_TAC "prod(INV(G,prod)x)(prod (x:*) h)") THEN
   (REWRITE_TAC
     [(CONJUNCT1(UNDISCH(SPEC"x:*"(UNDISCH INV_LEMMA))));
      (UNDISCH(SPEC"h:*"(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))))]) THEN
   (GROUP_LEFT_ASSOC_TAC "prod(INV(G,prod)y)(prod (y:*) h)") THEN
   (REWRITE_TAC
     [(CONJUNCT1(UNDISCH(SPEC"y:*"(UNDISCH INV_LEMMA))));
      (UNDISCH(SPEC"h:*"(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))))]));
  ((GROUP_LEFT_ASSOC_TAC "prod(INV(G,prod)y)(prod (y:*) h)") THEN
   (REWRITE_TAC
     [(CONJUNCT1(UNDISCH(SPEC"y:*"(UNDISCH INV_LEMMA))));
      (UNDISCH(SPEC"h:*"(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))))]) THEN
   (GROUP_LEFT_ASSOC_TAC "prod(INV(G,prod)x)(prod (x:*) h)") THEN
   (REWRITE_TAC
     [(CONJUNCT1(UNDISCH(SPEC"x:*"(UNDISCH INV_LEMMA))));
      (UNDISCH(SPEC"h:*"(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))))]))]));;

%LEFT_COSETS_SAME_SIZE = 
|- SUBGROUP(G,prod)H ==>
   (!x y.
     G x /\ G y ==>
     (?f g.
       (!u. LEFT_COSET(G,prod)H x u ==> LEFT_COSET(G,prod)H y(f u)) /\
       (!v. LEFT_COSET(G,prod)H y v ==> LEFT_COSET(G,prod)H x(g v)) /\
       (!u. LEFT_COSET(G,prod)H x u ==> (g(f u) = u)) /\
       (!v. LEFT_COSET(G,prod)H y v ==> (f(g v) = v))))%


let NORMAL_DEF = new_definition(`NORMAL_DEF`,
"NORMAL(G:* -> bool,prod)N = SUBGROUP(G,prod)N /\ (!x n. G x /\ N n ==>
    N (prod (INV(G,prod)x) (prod n x)))");;


%NORMAL_DEF = 
|- NORMAL(G,prod)N =
   SUBGROUP(G,prod)N /\
   (!x n. G x /\ N n ==> N(prod(INV(G,prod)x)(prod n x)))%


let GROUP_IS_NORMAL = prove_thm(`GROUP_IS_NORMAL`,
"GROUP(G:* -> bool,prod) ==> NORMAL(G,prod)G",
(DISCH_TAC THEN (PURE_ONCE_REWRITE_TAC[NORMAL_DEF])
 THEN (GROUP_TAC[GROUP_IS_SBGP])));;

%GROUP_IS_NORMAL = |- GROUP(G,prod) ==> NORMAL(G,prod)G%


let ID_IS_NORMAL = prove_thm(`ID_IS_NORMAL`,
"GROUP(G:* -> bool,prod) ==> NORMAL(G,prod)(\x.(x = ID(G,prod)))",
(DISCH_TAC THEN (PURE_ONCE_REWRITE_TAC[NORMAL_DEF]) THEN BETA_TAC THEN
 (REPEAT STRIP_TAC) THENL
 [(ACCEPT_TAC (UNDISCH ID_IS_SBGP));
  (ASM_REWRITE_TAC
    [(UNDISCH(SPEC "x:*"(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))));
     (CONJUNCT1(UNDISCH(SPEC "x:*" (UNDISCH INV_LEMMA))))])]));;

%ID_IS_NORMAL = |- GROUP(G,prod) ==> NORMAL(G,prod)(\x. x = ID(G,prod))%


let NORMAL_INTERSECTION = prove_thm (`NORMAL_INTERSECTION`,
"SUBGROUP(G,prod)H /\ NORMAL(G,prod)N ==> NORMAL(H,prod)(\x:*.H x /\ N x)",
(STRIP_TAC THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE [SUBGROUP_DEF]
   (ASSUME "SUBGROUP(G,prod)(H:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC
   (PURE_ONCE_REWRITE_RULE [NORMAL_DEF]
      (ASSUME "NORMAL(G,prod)(N:* -> bool)"))) THEN
 (REWRITE_TAC [NORMAL_DEF]) THEN BETA_TAC THEN CONJ_TAC THENL
 [((STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE [SUBGROUP_DEF]
     (UNDISCH_ALL (hd (IMP_CANON
         (STRONG_INST [("N:* -> bool","K1:* -> bool")] COR_SBGP_INT)))))) THEN
   (ASM_REWRITE_TAC [SUBGROUP_DEF]) THEN BETA_TAC THEN
   (REPEAT STRIP_TAC) THEN (FIRST_ASSUM ACCEPT_TAC));
  ((REPEAT STRIP_TAC) THENL
    [GROUP_ELT_TAC;
     (RES_TAC THEN RES_TAC THEN
      (ASM_REWRITE_TAC
         [(UNDISCH (SPEC "x:*" (UNDISCH SBGP_INV_GP_INV)))]))])]));;

%NORMAL_INTERSECTION = 
|- SUBGROUP(G,prod)H /\ NORMAL(G,prod)N ==>
   NORMAL(H,prod)(\x. H x /\ N x) %


let NORM_NORM_INT = prove_thm(`NORM_NORM_INT`,
"NORMAL(G,prod)N1 /\ NORMAL(G,prod)N2 ==> NORMAL(G,prod)(\n:*.(N1 n /\ N2 n))",
((PURE_REWRITE_TAC [NORMAL_DEF]) THEN BETA_TAC THEN
 (REPEAT STRIP_TAC) THENL
 [((MATCH_MP_IMP_TAC COR_SBGP_INT) THEN (REDUCE_TAC []));RES_TAC;RES_TAC]));;

%NORM_NORM_INT = 
|- NORMAL(G,prod)N1 /\ NORMAL(G,prod)N2 ==>
   NORMAL(G,prod)(\n. N1 n /\ N2 n) %


let SET_PROD_DEF = new_definition(`SET_PROD_DEF`,
"set_prod(G,prod)A B = \x:*. GROUP(G,prod) /\ (!a. A a ==> G a) /\
  (!b. B b ==> G b) /\ (?a. A a /\ ?b. B b /\ (x = prod a b))");;

%SET_PROD_DEF = 
|- set_prod(G,prod)A B =
   (\x.
     GROUP(G,prod) /\
     (!a. A a ==> G a) /\
     (!b. B b ==> G b) /\
     (?a. A a /\ (?b. B b /\ (x = prod a b))))%

let NORMAL_PROD = prove_thm(`NORMAL_PROD`,
"NORMAL(G,prod)N /\ SUBGROUP(G,prod)H ==>
 SUBGROUP(G,prod)(set_prod(G,prod)H (N:* -> bool))",
(STRIP_TAC THEN
 (STRIP_ASSUME_TAC
   (PURE_ONCE_REWRITE_RULE [NORMAL_DEF]
      (ASSUME "NORMAL(G,prod)(N:* -> bool)"))) THEN
 (let asm_list =
   [(ASSUME "SUBGROUP(G,prod)(N:* -> bool)");
    (ASSUME "SUBGROUP(G,prod)(H:* -> bool)")] in
  (MAP_EVERY
     (STRIP_ASSUME_TAC o (PURE_ONCE_REWRITE_RULE [SUBGROUP_DEF]))
     asm_list) THEN
  (MAP_EVERY
     (STRIP_ASSUME_TAC o (PURE_ONCE_REWRITE_RULE
       [(SUBS[(GEN_ALPHA_CONV "X:*" "?x:*.H x")]SUBGROUP_LEMMA)]))
     asm_list)) THEN
 (ASM_REWRITE_TAC[SET_PROD_DEF;SUBGROUP_LEMMA]) THEN
 BETA_TAC THEN (REPEAT STRIP_TAC) THENL
 [((EXISTS_TAC "ID(G,prod):*") THEN
   (EXISTS_TAC "ID(H,prod):*") THEN
   (ASM_CONJ1_TAC THENL [GROUP_ELT_TAC;ALL_TAC]) THEN
   (EXISTS_TAC "ID(N,prod):*") THEN
   (ASM_CONJ1_TAC THENL [GROUP_ELT_TAC;ALL_TAC]) THEN
   (REWRITE_TAC
     [(UNDISCH SBGP_ID_GP_ID);
      (UNDISCH (STRONG_INST [("N:* -> bool","H:* -> bool")]
         SBGP_ID_GP_ID))])THEN
   ((SUBST_MATCH_TAC
     (UNDISCH (SPEC_ALL (CONJUNCT1 (CONJUNCT2 (UNDISCH ID_LEMMA)))))) THENL
    [REFL_TAC;GROUP_ELT_TAC]));
  ((ASM_REWRITE_TAC []) THEN 
   (IMP_RES_TAC (ASSUME "!x:*. H x ==> G x")) THEN
   (IMP_RES_TAC (ASSUME "!x:*. N x ==> G x")) THEN
   GROUP_ELT_TAC);
  ((EXISTS_TAC "(prod (a:*) (a':*)):*") THEN
   (CONJ_TAC THENL [GROUP_ELT_TAC; ALL_TAC]) THEN
   (EXISTS_TAC "prod (prod(INV(G,prod)(a':*))(prod b a'))b'") THEN
   (ASM_REWRITE_TAC []) THEN
   (IMP_RES_TAC (ASSUME "!x:*. H x ==> G x")) THEN
   (CONJ_TAC THENL
    [(GROUP_TAC [(UNDISCH_ALL (hd (IMP_CANON (SPECL ["a':*";"b:*"]
       (ASSUME "!x n:*. G x /\ N n ==> N(prod(INV(G,prod)x)(prod n x))")))))]);
     ALL_TAC]) THEN
   (IMP_RES_TAC (ASSUME "!x:*. N x ==> G x")) THEN
   (GROUP_LEFT_ASSOC_TAC "prod(prod a b)(prod a' b'):*") THEN
   (GROUP_LEFT_ASSOC_TAC
      "prod(prod a a')(prod(prod(INV(G,prod)a')(prod b a'))b'):*") THEN
   (GROUP_RIGHT_ASSOC_TAC "prod(prod a (b:*))a':*") THEN
   (GROUP_RIGHT_ASSOC_TAC
     "prod(prod a a')(prod(INV(G,prod)a')(prod b a')):*") THEN
   (GROUP_LEFT_ASSOC_TAC "prod a' (prod(INV(G,prod)a')(prod b a')):*") THEN
   (NEW_SUBST1_TAC (CONJUNCT2 (UNDISCH (SPEC"a':*" (UNDISCH INV_LEMMA))))) THEN
   (NEW_SUBST1_TAC (UNDISCH (SPEC "(prod (b:*) (a':*)):*" (CONJUNCT1 (CONJUNCT2
       (UNDISCH ID_LEMMA)))))) THEN REFL_TAC);
  ((EXISTS_TAC "INV(H,prod)(a:*)") THEN
   (CONJ_TAC THENL
    [GROUP_ELT_TAC; 
     (NEW_SUBST1_TAC (UNDISCH (SPEC "a:*" (UNDISCH SBGP_INV_GP_INV))))]) THEN
   (EXISTS_TAC "prod a(prod (INV(N,prod)b) (INV(G,prod)(a:*)))") THEN
   (ASM_REWRITE_TAC []) THEN
   (IMP_RES_TAC (ASSUME "!x:*. H x ==> G x")) THEN
   (CONJ_TAC THENL
    [((MP_IMP_TAC
        (PURE_ONCE_REWRITE_RULE
          [(UNDISCH(SPEC "a:*" (UNDISCH INV_INV_LEMMA)))]
          (SPECL ["INV(G,prod)a:*";"INV(N,prod)b:*"]
           (ASSUME "!x n:*. G x /\ N n ==>
             N(prod(INV(G,prod)x)(prod n x))")))) THEN GROUP_ELT_TAC);
    (NEW_SUBST1_TAC (UNDISCH (SPEC "b:*" (UNDISCH 
       (STRONG_INST ["N:* -> bool","H:* -> bool"] SBGP_INV_GP_INV)))))]) THEN
   (ASSUME_TAC (UNDISCH (SPEC "b:*" (ASSUME "!x:*. N x ==> G x")))) THEN
   (NEW_SUBST1_TAC (SYM (UNDISCH_ALL (hd (IMP_CANON (SPECL ["b:*";"a:*"]
     (UNDISCH DIST_INV_LEMMA))))))) THEN
   (GROUP_LEFT_ASSOC_TAC
      "prod(INV(G,prod)a)(prod a(prod (INV(G,prod)b)(INV(G,prod)a))):*") THEN
   (NEW_SUBST1_TAC (CONJUNCT1 (UNDISCH (SPEC "a:*" (UNDISCH INV_LEMMA))))) THEN
   (ACCEPT_TAC (SYM (UNDISCH (SPEC "prod(INV(G,prod)b)(INV(G,prod)(a:*))"
     (CONJUNCT1 (CONJUNCT2 (UNDISCH ID_LEMMA))))))))]));;

%NORMAL_PROD = 
|- NORMAL(G,prod)N /\ SUBGROUP(G,prod)H ==>
   SUBGROUP(G,prod)(set_prod(G,prod)H N) %


let QUOTIENT_SET_DEF = new_definition(`QUOTIENT_SET_DEF`,
"quot_set(G,prod)N q =
   NORMAL(G,prod)N /\ (?x:*. G x /\ (q = (LEFT_COSET(G,prod)N x)))");; 

%QUOTIENT_SET_DEF = 
|- quot_set(G,prod)N q =
   NORMAL(G,prod)N /\ (?x. G x /\ (q = LEFT_COSET(G,prod)N x)) %


let QUOTIENT_PROD_DEF = new_definition(`QUOTIENT_PROD_DEF`,
"quot_prod(G:* -> bool,prod)N q r =
    LEFT_COSET(G,prod)N (prod (@x. G x /\ (q = LEFT_COSET(G,prod)N x))
              (@y. G y /\ (r = LEFT_COSET(G,prod)N y)))");;

%QUOTIENT_PROD_DEF = 
|- quot_prod(G,prod)N q r =
   LEFT_COSET
   (G,prod)
   N
   (prod
    (@x. G x /\ (q = LEFT_COSET(G,prod)N x))
    (@y. G y /\ (r = LEFT_COSET(G,prod)N y))) %


let QUOT_PROD = prove_thm(`QUOT_PROD`,
"NORMAL(G:* -> bool,prod)N ==> (!x y. G x /\ G y ==>
    (quot_prod(G,prod)N (LEFT_COSET(G,prod)N x) (LEFT_COSET(G,prod)N y) =
       LEFT_COSET(G,prod)N (prod x y)))",
(let x1 = "@x':*. G x' /\ (LEFT_COSET(G,prod)N x = LEFT_COSET(G,prod)N x')" in
let y1 = "@y':*. G y' /\ (LEFT_COSET(G,prod)N y = LEFT_COSET(G,prod)N y')" in
let tm_thm =
\tm. \tm1. (
(ASSUME "LEFT_COSET(G,prod)N ^tm = LEFT_COSET(G,prod)N ^tm1") and_then
(\thm. AP_THM thm tm) and_then
(\thm. EQ_MP thm
  (UNDISCH (SPEC tm (UNDISCH (STRONG_INST [("N:* -> bool","H:* -> bool")]
   LEFT_COSETS_COVER))))) and_then
(PURE_ONCE_REWRITE_RULE [LEFT_COSET_DEF]) and_then
(UNDISCH_ALL o hd o rev o IMP_CANON)) in
 (PURE_ONCE_REWRITE_TAC[NORMAL_DEF;QUOTIENT_PROD_DEF]) THEN STRIP_TAC THEN
 (IMP_RES_TAC (fst(EQ_IMP_RULE (SPEC_ALL SUBGROUP_DEF)))) THEN
 (REPEAT (STRIP_TAC)) THEN 
  (let thm =
   ((CONJ (ASSUME "(G:* -> bool) w") (REFL "LEFT_COSET(G:* -> bool,prod)N w"))
     and_then (EXISTS ("?w'. (G:* -> bool) w' /\
      (LEFT_COSET(G,prod)N w = LEFT_COSET(G,prod)N w')","w:*"))
     and_then SELECT_RULE) in
   (STRIP_ASSUME_TAC(STRONG_INST[("x:*","w:*")] thm)) THEN
   (STRIP_ASSUME_TAC(STRONG_INST[("y:*","w:*")] thm))) THEN
 (MATCH_MP_IMP_TAC
  (DISJ_IMP(PURE_ONCE_REWRITE_RULE[DISJ_SYM](UNDISCH_ALL(hd(IMP_CANON
    (CONJUNCT2(UNDISCH LEFT_COSET_DISJOINT_UNION)))))))) THEN
 GROUP_ELT_TAC THEN
 (NEW_SUBST1_TAC (SYM (BETA_RULE (AP_THM 
   (ASSUME "(\z:*.LEFT_COSET(G,prod)N(prod
      (@x'. G x' /\ (LEFT_COSET(G,prod)N x = LEFT_COSET(G,prod)N x'))
      (@y'. G y' /\ (LEFT_COSET(G,prod)N y = LEFT_COSET(G,prod)N y')))z /\
     LEFT_COSET(G,prod)N(prod x y)z) =
   (\z. F)")
  "(prod:* -> * -> *) x y")))) THEN (POP_ASSUM \thm.ALL_TAC) THEN
 (CONJ_TAC THENL
  [ALL_TAC;
   (NEW_MATCH_ACCEPT_TAC (UNDISCH(SPEC_ALL(UNDISCH LEFT_COSETS_COVER))))]) THEN
 (PURE_ONCE_REWRITE_TAC[LEFT_COSET_DEF]) THEN
 (REPEAT STRIP_TAC THEN ((FIRST_ASSUM ACCEPT_TAC) ORELSE ALL_TAC)) THEN
 (STRIP_ASSUME_TAC (tm_thm "x:*" x1)) THEN
 (STRIP_ASSUME_TAC (tm_thm "y:*" y1)) THEN
 (EXISTS_TAC "prod(prod(INV(G:* -> bool,prod)^y1)(prod h ^y1)) h'") THEN
  (CONJ_TAC THENL
   [((NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL(hd(IMP_CANON(SPEC_ALL(UNDISCH
       (fst (EQ_IMP_RULE (SPEC_ALL GROUP_DEF))))))))) THEN
     (NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON (ASSUME
      "!(x:*) (n:*). G x /\ N n ==> N(prod(INV(G,prod)x)(prod n x))"))))));
    ALL_TAC]) THEN
 (IMP_RES_TAC (ASSUME "!x:*. N x ==> G x")) THEN
 (\ (asl,gl).(GROUP_RIGHT_ASSOC_TAC (rand(rhs gl))(asl,gl))) THEN
 (\ (asl,gl).(GROUP_LEFT_ASSOC_TAC (rhs gl) (asl,gl))) THEN
 (\ (asl,gl).(GROUP_RIGHT_ASSOC_TAC (rand (rator (rhs gl))) (asl,gl))) THEN
 (PURE_REWRITE_TAC
  [(CONJUNCT2(UNDISCH (SPEC y1 (UNDISCH INV_LEMMA))));
   (UNDISCH(SPEC x1(CONJUNCT1(CONJUNCT2(CONJUNCT2(UNDISCH ID_LEMMA))))))]) THEN
 (\ (asl,gl).(GROUP_RIGHT_ASSOC_TAC (rand(rhs gl))(asl,gl))) THEN
 (\ (asl,gl).(GROUP_LEFT_ASSOC_TAC (rhs gl) (asl,gl))) THEN
 (NEW_SUBST1_TAC (SYM (ASSUME "x:* = (prod:* -> * -> *) ^x1 h"))) THEN
 (NEW_SUBST1_TAC (SYM (ASSUME "y:* = (prod:* -> * -> *) ^y1 h'"))) THEN
 REFL_TAC));;

%QUOT_PROD = 
|- NORMAL(G,prod)N ==>
   (!x y.
     G x /\ G y ==>
     (quot_prod(G,prod)N(LEFT_COSET(G,prod)N x)(LEFT_COSET(G,prod)N y) =
      LEFT_COSET(G,prod)N(prod x y))) %


let QUOTIENT_GROUP = prove_thm(`QUOTIENT_GROUP`,
"NORMAL(G:* -> bool,prod)N ==> GROUP(quot_set(G,prod)N,quot_prod(G,prod)N)",
(let thm1 = UNDISCH_ALL (hd (IMP_CANON (SPEC_ALL (UNDISCH QUOT_PROD)))) in
 DISCH_TAC THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE [NORMAL_DEF]
   (ASSUME "NORMAL(G:* -> bool,prod)N"))) THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE [SUBGROUP_DEF]
   (ASSUME "SUBGROUP(G:* -> bool,prod)N"))) THEN
 (PURE_ONCE_REWRITE_TAC[GROUP_DEF]) THEN
 (PURE_REWRITE_TAC [QUOTIENT_SET_DEF]) THEN
 (ASM_REWRITE_TAC []) THEN 
 (REPEAT STRIP_TAC) THENL
 [((ONCE_ASM_REWRITE_TAC[]) THEN
   (SUBST_MATCH_TAC thm1) THEN
   (EXISTS_TAC "(prod (x':*) (x'':*)):*") THEN
   (CONJ_TAC THENL [GROUP_ELT_TAC; REFL_TAC]));
  ((ASM_REWRITE_TAC[]) THEN
   (SUBST_MATCH_TAC thm1) THEN
   ((SUBST_MATCH_TAC thm1) THENL [ALL_TAC;GROUP_ELT_TAC]) THEN
   (SUBST_MATCH_TAC thm1) THEN
   ((SUBST_MATCH_TAC thm1) THENL [ALL_TAC;GROUP_ELT_TAC]) THEN
   (GROUP_RIGHT_ASSOC_TAC "prod(prod (x':*)(x'':*))x'''") THEN REFL_TAC);
  ((EXISTS_TAC "LEFT_COSET(G:* -> bool,prod)N(ID(G,prod))") THEN
   (REPEAT STRIP_TAC) THENL
   [((EXISTS_TAC "ID(G:* -> bool,prod)") THEN STRIP_TAC THENL
      [GROUP_ELT_TAC;REFL_TAC]);
    ((ONCE_ASM_REWRITE_TAC[]) THEN
     ((SUBST_MATCH_TAC thm1) THENL [ALL_TAC;GROUP_ELT_TAC]) THEN
     (NEW_SUBST1_TAC
        (UNDISCH(SPEC "x':*"(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))))) THEN
     REFL_TAC);
   ((ONCE_ASM_REWRITE_TAC[]) THEN
     (EXISTS_TAC "LEFT_COSET(G:* -> bool,prod)N(INV(G,prod)x')") THEN
     STRIP_TAC THENL
     [((EXISTS_TAC "INV(G:* -> bool,prod)x'") THEN STRIP_TAC THENL
       [GROUP_ELT_TAC;REFL_TAC]);
      (((SUBST_MATCH_TAC thm1) THENL [ALL_TAC;GROUP_ELT_TAC]) THEN
       (NEW_SUBST1_TAC
         (CONJUNCT1(UNDISCH(SPEC "x':*"(UNDISCH INV_LEMMA))))) THEN
       REFL_TAC)])])]));;

%QUOTIENT_GROUP = 
|- NORMAL(G,prod)N ==> GROUP(quot_set(G,prod)N,quot_prod(G,prod)N) %


let GP_HOM_DEF = new_definition (`GP_HOM_DEF`,
"GP_HOM(G1:* -> bool,prod1)(G2:** -> bool,prod2)f =
   GROUP(G1,prod1) /\ GROUP(G2,prod2) /\
   (!x. G1 x ==> G2 (f x)) /\
   (!x y. G1 x /\ G1 y ==> (f(prod1 x y) = prod2 (f x) (f y)))");;

%GP_HOM_DEF = 
|- GP_HOM(G1,prod1)(G2,prod2)f =
   GROUP(G1,prod1) /\
   GROUP(G2,prod2) /\
   (!x. G1 x ==> G2(f x)) /\
   (!x y. G1 x /\ G1 y ==> (f(prod1 x y) = prod2(f x)(f y)))%


let GP_HOM_COMP = prove_thm(`GP_HOM_COMP`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) /\
 GP_HOM(G2,prod2)(G3,prod3)(g:** -> ***) ==>
 GP_HOM(G1,prod1)(G3,prod3)(\x.g (f x))",
((PURE_ONCE_REWRITE_TAC[GP_HOM_DEF]) THEN BETA_TAC THEN 
 (REPEAT STRIP_TAC) THEN RES_TAC THEN RES_TAC THEN
 (ASM_REWRITE_TAC[])));;

%GP_HOM_COMP = 
|- GP_HOM(G1,prod1)(G2,prod2)f /\ GP_HOM(G2,prod2)(G3,prod3)g ==>
   GP_HOM(G1,prod1)(G3,prod3)(\x. g(f x))%


let HOM_ID_INV_LEMMA = prove_thm (`HOM_ID_INV_LEMMA`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==>
 (f (ID(G1,prod1)) = ID(G2,prod2)) /\
 (!x.G1 x ==> (f(INV(G1,prod1)x) = INV(G2,prod2)(f x)))",
((PURE_ONCE_REWRITE_TAC [GP_HOM_DEF]) THEN STRIP_TAC THEN
 ASM_CONJ1_TAC THENL
 [((ASSUME_TAC (CONJUNCT1 (UNDISCH (STRONG_INST
     [("G1:* -> bool","G:* -> bool");("prod1:* -> * -> *","prod:* -> * -> *")]
      ID_LEMMA)))) THEN RES_TAC THEN
   (MATCH_MP_IMP_TAC (SPEC_ALL (UNDISCH UNIQUE_ID))) THEN
   (CONJ_TAC THENL
    [(FIRST_ASSUM ACCEPT_TAC);
     (DISJ1_TAC THEN (EXISTS_TAC "(f:* -> **)(ID(G1,prod1))") THEN
      (CONJ_TAC THENL [(FIRST_ASSUM ACCEPT_TAC);ALL_TAC]))]) THEN
   (NEW_SUBST1_TAC (SYM (ASSUME
     "(f:* -> **)(prod1(ID(G1,prod1))(ID(G1,prod1))) =
       prod2(f(ID(G1,prod1)))(f(ID(G1,prod1)))"))) THEN
   AP_TERM_TAC THEN
   (NEW_MATCH_ACCEPT_TAC (UNDISCH(SPEC "(ID(G,prod)):*"
      (CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))))));
  ((REPEAT STRIP_TAC) THEN
   (ASSUME_TAC (CONJUNCT1 (UNDISCH (SPEC "x:*" (UNDISCH (STRONG_INST
     [("G1:* -> bool","G:* -> bool");("prod1:* -> * -> *","prod:* -> * -> *")]
     INV_LEMMA)))))) THEN
   (ASSUME_TAC (UNDISCH (SPEC "x:*" (UNDISCH (STRONG_INST
     [("G1:* -> bool","G:* -> bool");("prod1:* -> * -> *","prod:* -> * -> *")]
     INV_CLOSURE))))) THEN
   RES_TAC THEN
   (MATCH_MP_IMP_TAC(SPEC_ALL(UNDISCH(SPEC_ALL(UNDISCH UNIQUE_INV)))))THEN
   (CONJ_TAC THENL [GROUP_ELT_TAC;ALL_TAC]) THEN
   (NEW_SUBST1_TAC (SYM (ASSUME
    "(f:* -> **)(prod1(INV(G1,prod1)x)x) =
      prod2(f(INV(G1,prod1)x))(f x)"))) THEN
   (NEW_SUBST1_TAC
    (SYM (ASSUME "(f:* -> **)(ID(G1,prod1)) = ID(G2,prod2)"))) THEN
   AP_TERM_TAC THEN
   (NEW_MATCH_ACCEPT_TAC
     (CONJUNCT1(UNDISCH(SPEC "x:*"(UNDISCH INV_LEMMA))))))]));;

%HOM_ID_INV_LEMMA = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==>
   (f(ID(G1,prod1)) = ID(G2,prod2)) /\
   (!x. G1 x ==> (f(INV(G1,prod1)x) = INV(G2,prod2)(f x)))%


let Id_GP_HOM = prove_thm(`Id_GP_HOM`,
"GROUP(G1,prod1) ==> GP_HOM(G1,prod1)(G1,prod1)(\x:*.x)",
(DISCH_TAC THEN (PURE_ONCE_REWRITE_TAC[GP_HOM_DEF]) THEN
 BETA_TAC THEN (ASM_REWRITE_TAC[])));;

%Id_GP_HOM = |- GROUP(G1,prod1) ==> GP_HOM(G1,prod1)(G1,prod1)(\x. x) %


let Triv_GP_HOM = prove_thm(`Triv_GP_HOM`,

"GROUP(G1,prod1) /\ GROUP(G2,prod2) ==>
 GP_HOM(G1,prod1)(G2,prod2)(\x:*.ID(G2,prod2):**)",
(STRIP_TAC THEN (PURE_ONCE_REWRITE_TAC[GP_HOM_DEF]) THEN
 BETA_TAC THEN (ASM_REWRITE_TAC[]) THEN
 ((REPEAT STRIP_TAC) THENL
  [ALL_TAC;
   (NEW_MATCH_ACCEPT_TAC
      (SYM (UNDISCH (SPEC_ALL (CONJUNCT1 (CONJUNCT2 (UNDISCH ID_LEMMA)))))))])
 THEN GROUP_ELT_TAC));;

%Triv_GP_HOM = 
|- GROUP(G1,prod1) /\ GROUP(G2,prod2) ==>
   GP_HOM(G1,prod1)(G2,prod2)(\x. ID(G2,prod2)) %


let GP_HOM_RESTRICT_DOM = prove_thm(`GP_HOM_RESTRICT_DOM`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) /\ SUBGROUP(G1,prod1)H1 ==>
 GP_HOM(H1,prod1)(G2,prod2)f",
((PURE_ONCE_REWRITE_TAC[GP_HOM_DEF;SUBGROUP_DEF]) THEN
 (REPEAT STRIP_TAC) THEN (ASM_REWRITE_TAC[]) THEN
 (RES_TAC THEN RES_TAC)));;

%GP_HOM_RESTRICT_DOM = 
|- GP_HOM(G1,prod1)(G2,prod2)f /\ SUBGROUP(G1,prod1)H1 ==>
   GP_HOM(H1,prod1)(G2,prod2)f %


let IM_DEF = new_definition (`IM_DEF`,
"IM (G:* -> bool) (f:* -> **) = \y.(?x. (G x) /\ (y = f x))");;

%IM_DEF = |- IM G f = (\y. ?x. G x /\ (y = f x))%

% --------------------------------------------------------------------- %
% Following proof totally rewritten for HOL version 1.12 [TFM 91.01.26]	%
% --------------------------------------------------------------------- %

let SUBGROUP_HOM_IM = 
    prove_thm
    (`SUBGROUP_HOM_IM`,
     "GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==>
      !H. SUBGROUP(G1,prod1)H ==> SUBGROUP(G2,prod2)(IM H f)",
     DISCH_TAC THEN IMP_RES_TAC GP_HOM_DEF THEN
     GEN_TAC THEN DISCH_TAC THEN
     IMP_RES_TAC (fst(EQ_IMP_RULE (SPEC_ALL SUBGROUP_DEF))) THEN
     IMP_RES_THEN ASSUME_TAC SBGP_INV_GP_INV THEN
     ASM_REWRITE_TAC[SUBGROUP_LEMMA;IM_DEF] THEN
     CONV_TAC (ONCE_DEPTH_CONV BETA_CONV) THEN
     REPEAT STRIP_TAC THENL
     [EXISTS_TAC "(f:* -> **)(ID(G1,prod1))" THEN
      EXISTS_TAC "ID(H:* -> bool,prod1)" THEN
      ASM_CONJ1_TAC THENL
       [GROUP_ELT_TAC;
        AP_TERM_TAC THEN CONV_TAC SYM_CONV THEN IMP_RES_TAC SBGP_ID_GP_ID];
      FIRST_ASSUM (\th g. SUBST1_TAC th g) THEN
      FIRST_ASSUM MATCH_MP_TAC THEN RES_TAC;
      EXISTS_TAC "(prod1 (x':*) (x'':*)):*" THEN
      RES_TAC THEN RES_TAC THEN ASM_REWRITE_TAC[] THEN
      GROUP_ELT_TAC;
      EXISTS_TAC "INV(H,prod1)(x':*)" THEN
      CONJ_TAC THENL
      [GROUP_ELT_TAC;  
       RES_TAC THEN 
       ASM_REWRITE_TAC
          [UNDISCH(SPEC "x':*"(CONJUNCT2(UNDISCH HOM_ID_INV_LEMMA)))] THEN
       GROUP_ELT_TAC]]);;


%SUBGROUP_HOM_IM = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==>
   (!H. SUBGROUP(G1,prod1)H ==> SUBGROUP(G2,prod2)(IM H f))%


let GROUP_HOM_IM = prove_thm(`GROUP_HOM_IM`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==> SUBGROUP(G2,prod2)(IM G1 f)",
(DISCH_TAC THEN
 (FIRST_ASSUM (STRIP_ASSUME_TAC o (PURE_ONCE_REWRITE_RULE[GP_HOM_DEF]))) THEN
 (MP_IMP_TAC (SPEC "G1:* -> bool" (UNDISCH SUBGROUP_HOM_IM))) THEN
 (NEW_MATCH_ACCEPT_TAC (UNDISCH GROUP_IS_SBGP))));;

%GROUP_HOM_IM = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==> SUBGROUP(G2,prod2)(IM G1 f)%


let GP_HOM_RESTRICT_RANGE = prove_thm(`GP_HOM_RESTRICT_RANGE`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) /\ SUBGROUP(G2,prod2)H2 /\
 (!y. IM G1 f y ==> H2 y) ==> GP_HOM(G1,prod1)(H2,prod2)f",
((PURE_ONCE_REWRITE_TAC[GP_HOM_DEF;SUBGROUP_DEF;IM_DEF]) THEN
 BETA_TAC THEN
 (REPEAT STRIP_TAC) THEN (ASM_REWRITE_TAC []) THENL
 [((MP_IMP_TAC (SPEC "(f:* -> **) x"
      (ASSUME "!y:**. (?x:*. G1 x /\ (y = f x)) ==> H2 y"))) THEN
   (EXISTS_TAC "x:*") THEN (ASM_REWRITE_TAC []));
  RES_TAC]));;

%GP_HOM_RESTRICT_RANGE = 
|- GP_HOM(G1,prod1)(G2,prod2)f /\
   SUBGROUP(G2,prod2)H2 /\
   (!y. IM G1 f y ==> H2 y) ==>
   GP_HOM(G1,prod1)(H2,prod2)f %


let GP_HOM_RES_TO_IM = prove_thm(`GP_HOM_RES_TO_IM`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==>
 GP_HOM(G1,prod1)((IM G1 f),prod2)(f:* -> **)",
(DISCH_TAC THEN
 (MATCH_MP_IMP_TAC GP_HOM_RESTRICT_RANGE) THEN
 (ASM_REWRITE_TAC[(UNDISCH GROUP_HOM_IM);IM_DEF])));;

%GP_HOM_RES_TO_IM = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==> GP_HOM(G1,prod1)(IM G1 f,prod2)f %


let KERNEL_DEF = new_definition(`KERNEL_DEF`,
"KERNEL(G1,prod1)(G2,prod2)(f:* -> **) =
 \x. GP_HOM(G1,prod1)(G2,prod2)f /\ G1 x /\ (f x = ID(G2,prod2))");;

%KERNEL_DEF = 
|- KERNEL(G1,prod1)(G2,prod2)f =
   (\x. GP_HOM(G1,prod1)(G2,prod2)f /\ G1 x /\ (f x = ID(G2,prod2)))%

% Proof rewritten for HOL version 1.12 	[TFM 91.01.24]			%

let GP_HOM_RES_TO_SBGP =
    prove_thm
    (`GP_HOM_RES_TO_SBGP`,
     "GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) /\ SUBGROUP(G1,prod1)H ==>
      GP_HOM(H,prod1)(G2,prod2)f /\
     (KERNEL(H,prod1)(G2,prod2)f =
       \x. H x /\ KERNEL(G1,prod1)(G2,prod2)f x) /\
     (!y. IM H f y ==> IM G1 f y)",
     STRIP_TAC THEN
     IMP_RES_TAC GP_HOM_DEF THEN
     IMP_RES_TAC (fst(EQ_IMP_RULE (SPEC_ALL SUBGROUP_DEF))) THEN
     ASM_CONJ1_TAC THENL
     [ASM_REWRITE_TAC[GP_HOM_DEF] THEN
      REPEAT STRIP_TAC THEN RES_TAC THEN RES_TAC;
      ASM_REWRITE_TAC[KERNEL_DEF;IM_DEF] THEN
      CONV_TAC (ONCE_DEPTH_CONV BETA_CONV) THEN
      CONJ_TAC THENL
      [CONV_TAC (X_FUN_EQ_CONV "x:*") THEN
       GEN_TAC THEN BETA_TAC THEN EQ_TAC THEN
       REPEAT STRIP_TAC THEN RES_TAC THEN FIRST_ASSUM ACCEPT_TAC;
       REPEAT STRIP_TAC THEN EXISTS_TAC "x:*" THEN
       RES_TAC THEN REDUCE_TAC[]]]);;

%GP_HOM_RES_TO_SBGP = 
|- GP_HOM(G1,prod1)(G2,prod2)f /\ SUBGROUP(G1,prod1)H ==>
   GP_HOM(H,prod1)(G2,prod2)f /\
   (KERNEL(H,prod1)(G2,prod2)f =
    (\x. H x /\ KERNEL(G1,prod1)(G2,prod2)f x)) /\
   (!y. IM H f y ==> IM G1 f y) %


let KERNEL_NORMAL = prove_thm (`KERNEL_NORMAL`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==>
 NORMAL(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f)",
(DISCH_TAC THEN
 (STRIP_ASSUME_TAC
   (PURE_ONCE_REWRITE_RULE[GP_HOM_DEF]
    (ASSUME"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **)"))) THEN
 (ASM_REWRITE_TAC[KERNEL_DEF;NORMAL_DEF;SUBGROUP_LEMMA]) THEN
 BETA_TAC THEN
 ((REPEAT STRIP_TAC) THENL
  [ALL_TAC; GROUP_ELT_TAC; ALL_TAC; GROUP_ELT_TAC; ALL_TAC; GROUP_ELT_TAC;
   ALL_TAC]) THENL
 [((EXISTS_TAC "ID(G1,prod1):*") THEN
   (CONJ_TAC THENL
    [GROUP_ELT_TAC;ACCEPT_TAC (CONJUNCT1(UNDISCH(HOM_ID_INV_LEMMA)))]));
  (RES_TAC THEN
   (ASM_REWRITE_TAC[]) THEN
   (NEW_MATCH_ACCEPT_TAC
    (UNDISCH(SPEC"ID(G,prod):*"(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA)))))) THEN
   GROUP_ELT_TAC);
  (RES_TAC THEN
   (NEW_SUBST1_TAC
     (UNDISCH (SPEC "x:*" (CONJUNCT2 (UNDISCH HOM_ID_INV_LEMMA))))) THEN
   (NEW_MATCH_ACCEPT_TAC
     (SYM (UNDISCH (SPEC "(ID(G,PROD)):*" (UNDISCH
       (SPEC_ALL (UNDISCH UNIQUE_INV))))))) THEN
   (ASM_REWRITE_TAC[]) THEN
   (CONJ_TAC THENL
    [ALL_TAC;
     (NEW_MATCH_ACCEPT_TAC
       (UNDISCH(SPEC_ALL(CONJUNCT1(CONJUNCT2(UNDISCH ID_LEMMA))))))]) THEN
    GROUP_ELT_TAC);
   (((NEW_SUBST1_TAC
      (UNDISCH_ALL(hd(IMP_CANON(SPECL
       ["INV(G1,prod1)(x:*)";"(prod1:* -> * -> *)n x"]
       (ASSUME "!(x:*) (y:*). G1 x /\ G1 y ==>
          ((f:* -> **)(prod1 x y) = prod2(f x)(f y))")))))) THENL
      [ALL_TAC;GROUP_ELT_TAC;GROUP_ELT_TAC]) THEN
    (IMP_RES_TAC (ASSUME "!x. G1 x ==> G2((f:* -> **) x)")) THEN
     (ASM_REWRITE_TAC
      [(UNDISCH_ALL(hd(IMP_CANON(SPECL ["n:*"; "x:*"]
        (ASSUME "!(x:*) (y:*). G1 x /\ G1 y ==>
          ((f:* -> **)(prod1 x y) = prod2(f x)(f y))")))));
       (UNDISCH (SPEC "x:*" (CONJUNCT2 (UNDISCH HOM_ID_INV_LEMMA))));
       (UNDISCH(SPEC "(f:* -> **)x"(CONJUNCT1(CONJUNCT2(UNDISCH
        (STRONG_INST_TY_TERM
          (match "GROUP(G:* -> bool,prod)" "GROUP(G2:** -> bool,prod2)")
          ID_LEMMA))))));
       (CONJUNCT1(UNDISCH(SPEC "(f:* -> **)x"(UNDISCH (STRONG_INST_TY_TERM
          (match "GROUP(G:* -> bool,prod)" "GROUP(G2:** -> bool,prod2)")
          INV_LEMMA)))))]))]));;

%KERNEL_NORMAL = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==>
   NORMAL(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f)%


let KERNEL_IM_LEMMA = prove_thm(`KERNEL_IM_LEMMA`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==>
(IM (KERNEL(G1,prod1)(G2,prod2)f) f = (\y.(y = ID(G2,prod2))))",
(DISCH_TAC THEN
 (FIRST_ASSUM (STRIP_ASSUME_TAC o (PURE_ONCE_REWRITE_RULE[GP_HOM_DEF]))) THEN
 (ASM_REWRITE_TAC [KERNEL_DEF;IM_DEF]) THEN
 (EXT_TAC "y:**") THEN BETA_TAC THEN GEN_TAC THEN EQ_TAC THEN
 STRIP_TAC THENL
 [(ASM_REWRITE_TAC[]);
  ((EXISTS_TAC "ID(G1,prod1):*") THEN
   (ASM_REWRITE_TAC[]) THEN
   (ASM_CONJ2_TAC THENL
      [((ASM_REWRITE_TAC[]) THEN GROUP_ELT_TAC);ALL_TAC]) THEN
   (ACCEPT_TAC (SYM (CONJUNCT1 (UNDISCH HOM_ID_INV_LEMMA)))))]));;

%KERNEL_IM_LEMMA = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==>
   (IM(KERNEL(G1,prod1)(G2,prod2)f)f = (\y. y = ID(G2,prod2)))%


let INV_IM_DEF = new_definition (`INV_IM_DEF`,
"INV_IM G1 G2 (f:* -> **) = \x. G1 x /\ G2(f x)");;

%INV_IM_DEF = |- INV_IM G1 G2 f = (\x. G1 x /\ G2(f x)) %

let KERNEL_INV_IM_LEMMA = prove_thm(`KERNEL_INV_IM_LEMMA`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==>
(KERNEL(G1,prod1)(G2,prod2)f = INV_IM G1 (\y.(y = ID(G2,prod2))) f)",
(DISCH_TAC THEN
 (FIRST_ASSUM (STRIP_ASSUME_TAC o (PURE_ONCE_REWRITE_RULE[GP_HOM_DEF]))) THEN
 (ASM_REWRITE_TAC [KERNEL_DEF;INV_IM_DEF]) THEN
 BETA_TAC THEN REFL_TAC));;

%KERNEL_INV_IM_LEMMA = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==>
   (KERNEL(G1,prod1)(G2,prod2)f = INV_IM G1(\y. y = ID(G2,prod2))f) %


let SUBGROUP_INV_IM = prove_thm(`SUBGROUP_INV_IM`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) /\ SUBGROUP(G2,prod2)H ==>
(SUBGROUP(G1,prod1)(INV_IM G1 G2 f) /\
 !x. KERNEL(G1,prod1)(G2,prod2)f x ==> INV_IM G1 G2 f x)",
(STRIP_TAC THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[GP_HOM_DEF]
   (ASSUME "GP_HOM(G1,prod1)(G2,prod2)(f:* -> **)"))) THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[SUBGROUP_DEF]
   (ASSUME "SUBGROUP(G2,prod2)(H:** -> bool)"))) THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[SUBGROUP_LEMMA]
   (ASSUME "SUBGROUP(G2,prod2)(H:** -> bool)"))) THEN
 (PURE_REWRITE_TAC
   [SUBGROUP_LEMMA;INV_IM_DEF;(UNDISCH KERNEL_INV_IM_LEMMA)]) THEN
 BETA_TAC THEN (REPEAT STRIP_TAC) THEN
 GROUP_ELT_TAC THENL
 [((EXISTS_TAC "ID(G1,prod1):*") THEN
   (ASM_CONJ1_TAC THENL [GROUP_ELT_TAC;RES_TAC]));
  ((MP_IMP_TAC (SPEC "(prod1:* -> * -> *) x' y"
      (ASSUME "!x:*.G1 x ==> G2((f x):**)"))) THEN
   GROUP_ELT_TAC);
  ((NEW_SUBST1_TAC
      (UNDISCH(SPEC "x':*" (CONJUNCT2(UNDISCH HOM_ID_INV_LEMMA))))) THEN
   GROUP_ELT_TAC);
  RES_TAC]));;

%SUBGROUP_INV_IM = 
|- GP_HOM(G1,prod1)(G2,prod2)f /\ SUBGROUP(G2,prod2)H ==>
   SUBGROUP(G1,prod1)(INV_IM G1 G2 f) /\
   (!x. KERNEL(G1,prod1)(G2,prod2)f x ==> INV_IM G1 G2 f x) %


let NORMAL_INV_IM = prove_thm(`NORMAL_INV_IM`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) /\ NORMAL(G2,prod2)H ==>
 NORMAL(G1,prod1)(INV_IM G1 G2 f)",
(STRIP_TAC THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE [NORMAL_DEF]
    (ASSUME "NORMAL(G2,prod2)(H:** -> bool)"))) THEN
 (ASSUME_TAC (UNDISCH_ALL(hd(IMP_CANON SUBGROUP_INV_IM)))) THEN
 (ASM_REWRITE_TAC [NORMAL_DEF;INV_IM_DEF]) THEN BETA_TAC THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[GP_HOM_DEF]
    (ASSUME "GP_HOM(G1,prod1)(G2,prod2)(f:* -> **)"))) THEN
 ((REPEAT STRIP_TAC) THENL [GROUP_ELT_TAC; ALL_TAC]) THEN
 (SUPPOSE_TAC "G1 (prod1(INV(G1,prod1)x)(prod1 n (x:*)))") THENL
 [RES_TAC;GROUP_ELT_TAC]));;

%NORMAL_INV_IM = 
|- GP_HOM(G1,prod1)(G2,prod2)f /\ NORMAL(G2,prod2)H ==>
   NORMAL(G1,prod1)(INV_IM G1 G2 f) %


let NAT_HOM_DEF = new_definition (`NAT_HOM_DEF`,
"NAT_HOM(G,prod)N x= 
  (\y:*. GROUP(G,prod) /\ NORMAL(G,prod)N /\ LEFT_COSET(G,prod)N x y)");;

%NAT_HOM_DEF = 
|- NAT_HOM(G,prod)N x =
   (\y. GROUP(G,prod) /\ NORMAL(G,prod)N /\ LEFT_COSET(G,prod)N x y)%


let NAT_HOM_THM = prove_thm(`NAT_HOM_THM`,
"GROUP(G:* -> bool,prod) /\ NORMAL(G,prod)N ==>
 GP_HOM(G,prod)(quot_set(G,prod)N,quot_prod(G,prod)N)(NAT_HOM(G,prod)N) /\
 (!q. (?x. G x /\ (q = LEFT_COSET(G,prod)N x)) ==>
  (?x. G x /\ (q = NAT_HOM(G,prod)N x))) /\
 (KERNEL(G,prod)(quot_set(G,prod)N,quot_prod(G,prod)N)(NAT_HOM(G,prod)N) =
   N)",
(STRIP_TAC THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[NORMAL_DEF]
   (ASSUME "NORMAL(G:* -> bool,prod)N"))) THEN
 (STRIP_ASSUME_TAC (UNDISCH QUOTIENT_GROUP)) THEN
 (ASM_REWRITE_TAC
   [(PURE_ONCE_REWRITE_RULE[ETA_AX]
  (MK_ABS (GEN "x:*" (SPEC_ALL NAT_HOM_DEF))))]) THEN
 ASM_CONJ1_TAC THEN
 (ASM_REWRITE_TAC [ETA_AX;GP_HOM_DEF;KERNEL_DEF]) THEN
 BETA_TAC THEN
 (REPEAT STRIP_TAC) THENL
 [((ASM_REWRITE_TAC[QUOTIENT_SET_DEF]) THEN
   (EXISTS_TAC "x:*") THEN (ASM_REWRITE_TAC []));
  (ACCEPT_TAC (SYM (UNDISCH_ALL (hd (IMP_CANON (SPECL ["x:*";"y:*"] 
    (UNDISCH QUOT_PROD)))))));
  ((EXT_TAC "n:*") THEN BETA_TAC THEN
   (\ (asl,gl). (NEW_SUBST1_TAC
     (REWRITE_RULE[(ASSUME "NORMAL(G:* -> bool,prod)N")] (SYM (CONJUNCT1
      (MATCH_MP HOM_ID_INV_LEMMA (ASSUME (hd asl)))))))(asl,gl)) THEN
   (PURE_ONCE_REWRITE_TAC
     [(PURE_ONCE_REWRITE_RULE [ETA_AX]
       (MK_ABS (GEN "y:*" (SPEC_ALL LEFT_COSET_DEF))))]) THEN
   BETA_TAC THEN
   (STRIP_ASSUME_TAC
     (PURE_ONCE_REWRITE_RULE[SUBGROUP_DEF]
       (ASSUME "SUBGROUP(G:* -> bool,prod)N"))) THEN
   (ASSUME_TAC (CONJUNCT1 (UNDISCH ID_LEMMA))) THEN
   (ASM_REWRITE_TAC []) THEN
   GEN_TAC THEN EQ_TAC THENL
   [(STRIP_TAC THEN
     (\ (asl,gl). (ASSUME_TAC (REWRITE_RULE [(ASSUME "(G:* -> bool) n")]
       (BETA_RULE (AP_THM (ASSUME (hd asl)) "n:*")))) (asl,gl)) THEN
     (FIRST_ASSUM (\thm. (UNDISCH_TAC (concl thm)))) THEN
     ((REV_SUPPOSE_TAC "?h:*.N h /\ ((n:*) = prod n h)") THENL
      [((EXISTS_TAC "(ID(G,prod)):*") THEN
        (REWRITE_TAC
         [(UNDISCH(SPEC "n:*" (CONJUNCT1 (CONJUNCT2
             (CONJUNCT2 (UNDISCH ID_LEMMA))))));
          (SYM (UNDISCH (STRONG_INST [("N:* -> bool","H:* -> bool")]
            SBGP_ID_GP_ID)))]) THEN
        GROUP_ELT_TAC);
      (ASM_REWRITE_TAC [(SYM (UNDISCH (STRONG_INST
          [("N:* -> bool","H:* -> bool")] SBGP_ID_GP_ID)))])]) THEN
     STRIP_TAC THEN (ASM_REWRITE_TAC []) THEN GROUP_ELT_TAC);
    (DISCH_TAC THEN (IMP_RES_TAC (ASSUME "!x:*. N x ==> G x")) THEN
     (ASM_REWRITE_TAC[]) THEN
     (EXT_TAC "y:*") THEN BETA_TAC THEN GEN_TAC THEN EQ_TAC THEN STRIP_TAC THEN
     (ASM_REWRITE_TAC []) THEN (FIRST_ASSUM NEW_SUBST1_TAC) THEN
     (IMP_RES_TAC (ASSUME "!x:*. N x ==> G x")) THENL
     [((EXISTS_TAC "(prod:* -> * -> *) n h") THEN
       (CONJ_TAC THENL
        [ALL_TAC;
         (NEW_MATCH_ACCEPT_TAC (SYM (UNDISCH (SPEC_ALL
           (CONJUNCT1 (CONJUNCT2 (UNDISCH ID_LEMMA)))))))]) THEN
       RES_TAC THEN GROUP_ELT_TAC);
      (((REV_SUPPOSE_TAC "N(INV(N,prod)(n:*))") THENL
         [GROUP_ELT_TAC; (IMP_RES_TAC (ASSUME "!x:*.N x ==> G x"))]) THEN
       (EXISTS_TAC "prod (INV(N,prod)n) (h:*)") THEN
       (GROUP_LEFT_ASSOC_TAC "prod n (prod (INV(N,prod)n) (h:*))") THEN
       (CONJ_TAC THENL
        [GROUP_ELT_TAC;
         ((NEW_SUBST1_TAC (CONJUNCT2 (UNDISCH (SPEC "n:*" (UNDISCH
           (STRONG_INST [("N:* -> bool","G:* -> bool")] INV_LEMMA)))))) THEN
          (NEW_SUBST1_TAC (UNDISCH (STRONG_INST [("N:* -> bool","H:* -> bool")]
              SBGP_ID_GP_ID))) THEN
          REFL_TAC)]))])])]));;

%NAT_HOM_THM = 
|- GROUP(G,prod) /\ NORMAL(G,prod)N ==>
   GP_HOM
   (G,prod)
   (quot_set(G,prod)N,quot_prod(G,prod)N)
   (NAT_HOM(G,prod)N) /\
   (!q.
     (?x. G x /\ (q = LEFT_COSET(G,prod)N x)) ==>
     (?x. G x /\ (q = NAT_HOM(G,prod)N x))) /\
   (KERNEL
    (G,prod)
    (quot_set(G,prod)N,quot_prod(G,prod)N)
    (NAT_HOM(G,prod)N) =
    N) %

let QUOTIENT_HOM_DEF = new_definition (`QUOTIENT_HOM_DEF`,
"quot_hom(G1,prod1)(G2,prod2)N (f:* -> **) =
 \q. f (@w.
   GP_HOM(G1,prod1)(G2,prod2)f /\
   NORMAL(G1,prod1)N /\ (!n. N n ==> KERNEL(G1,prod1)(G2,prod2)f n) /\
   (?x. G1 x /\ (q = LEFT_COSET(G1,prod1)N x)) ==>
      G1 w /\ (q = LEFT_COSET(G1,prod1)N w))");;

%QUOTIENT_HOM_DEF =
|- quot_hom(G1,prod1)(G2,prod2)N f =
   (\q.
     f
     (@w.
       GP_HOM(G1,prod1)(G2,prod2)f /\
       NORMAL(G1,prod1)N /\
       (!n. N n ==> KERNEL(G1,prod1)(G2,prod2)f n) /\
       (?x. G1 x /\ (q = LEFT_COSET(G1,prod1)N x)) ==>
       G1 w /\ (q = LEFT_COSET(G1,prod1)N w))) %


let QUOTIENT_HOM_LEMMA = prove_thm (`QUOTIENT_HOM_LEMMA`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) /\
   SUBGROUP(G1,prod1)H /\ (!h. H h ==> KERNEL(G1,prod1)(G2,prod2)f h) ==>
  (!x y. LEFT_COSET(G1,prod1)H x y ==> (f x = f y))",
(STRIP_TAC THEN 
 (UNDISCH_TAC "!h. H h ==> KERNEL(G1,prod1)(G2,prod2)(f:* -> **) h") THEN
 (EVERY_ASSUM (STRIP_ASSUME_TAC o
   (REWRITE_RULE [GP_HOM_DEF;SUBGROUP_DEF]))) THEN
 (ASM_REWRITE_TAC [KERNEL_DEF;LEFT_COSET_DEF]) THEN
 BETA_TAC THEN
 (REPEAT STRIP_TAC) THEN
 (IMP_RES_TAC (ASSUME "!x. G1 x ==> G2((f:* -> **) x)"))  THEN
 ((MP_IMP_TAC 
   (UNDISCH (SPECL
    ["INV(G2,prod2)((f:* -> **) y)";"(f:* -> **)x";"(f:* -> **)y"]
   (UNDISCH (STRONG_INST_TY_TERM
    (match "GROUP(G:* -> bool,prod)" "GROUP(G2:** -> bool,prod2)")
   LEFT_CANCELLATION))))) THENL [ALL_TAC;GROUP_ELT_TAC]) THEN
 (SUBST_MATCH_TAC (CONJUNCT1 (UNDISCH (SPEC_ALL
    (UNDISCH INV_LEMMA))))) THEN
 (NEW_SUBST1_TAC (SYM (UNDISCH (SPEC "y:*" (CONJUNCT2 (UNDISCH
   HOM_ID_INV_LEMMA)))))) THEN
 ((SUBST_MATCH_TAC (SYM (UNDISCH (SPEC_ALL (ASSUME
    "!x y. G1 x /\ G1 y ==>
      (f(prod1 x y) = prod2(f x)((f:* -> **) y))"))))) THENL
   [ALL_TAC;GROUP_ELT_TAC]) THEN
 (NEW_MATCH_ACCEPT_TAC (CONJUNCT2 (UNDISCH (SPEC_ALL
   (ASSUME "!h. H h ==> G1 h /\ ((f:* -> **) h = ID(G2,prod2))"))))) THEN
 (ASM_REWRITE_TAC []) THEN
 (IMP_RES_TAC (ASSUME "!x:*. H x ==> G1 x")) THEN
 (SUBST_MATCH_TAC
   (SYM (UNDISCH_ALL(hd (IMP_CANON (UNDISCH DIST_INV_LEMMA)))))) THEN
 (GROUP_RIGHT_ASSOC_TAC
   "prod1(prod1(INV(G1,prod1)h)(INV(G1,prod1)x))(x:*)") THEN
 (SUBST_MATCH_TAC (CONJUNCT1 (UNDISCH (SPEC_ALL (UNDISCH INV_LEMMA))))) THEN
 (SUBST_MATCH_TAC (SYM (UNDISCH SBGP_ID_GP_ID))) THEN
 (SUBST_MATCH_TAC (SYM (UNDISCH (SPEC_ALL (UNDISCH SBGP_INV_GP_INV))))) THEN
 GROUP_ELT_TAC));;

%QUOTIENT_HOM_LEMMA = 
|- GP_HOM(G1,prod1)(G2,prod2)f /\
   SUBGROUP(G1,prod1)H /\
   (!h. H h ==> KERNEL(G1,prod1)(G2,prod2)f h) ==>
   (!x y. LEFT_COSET(G1,prod1)H x y ==> (f x = f y)) %


% --------------------------------------------------------------------- %
% I have been completely unable to revise the following proof of 	%
% QUOT_HOM_THM for hol version 1.12, so load in the version 11		%
% compatability file for old resolution here.				%
% --------------------------------------------------------------------- %

loadt `compat11`;;

let QUOT_HOM_THM = prove_thm(`QUOT_HOM_THM`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) /\
   NORMAL(G1,prod1)N /\ (!n. N n ==> KERNEL(G1,prod1)(G2,prod2)f n) ==>
 GP_HOM(quot_set(G1,prod1)N,quot_prod(G1,prod1)N)(G2,prod2)
       (quot_hom(G1,prod1)(G2,prod2)N f) /\
 (!x. G1 x ==>
      ((quot_hom(G1,prod1)(G2,prod2)N f)(NAT_HOM(G1,prod1)N x) = f x))/\
 (IM(quot_set(G1,prod1)N)(quot_hom(G1,prod1)(G2,prod2)N f) = IM G1 f) /\
 ((KERNEL(quot_set(G1,prod1)N,quot_prod(G1,prod1)N)(G2,prod2)
         (quot_hom(G1,prod1)(G2,prod2)N (f:* -> **))) =
  (IM (KERNEL(G1,prod1)(G2,prod2)(f:* -> **)) (NAT_HOM(G1,prod1)N))) /\
 (!g. GP_HOM(quot_set(G1,prod1)N,quot_prod(G1,prod1)N)(G2,prod2)g /\
      (!x. G1 x ==> (g (NAT_HOM(G1,prod1)N x) = f x)) ==>
   !q. quot_set(G1,prod1)N q ==> (g q = quot_hom(G1,prod1)(G2,prod2)N f q))",
(STRIP_TAC THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE [GP_HOM_DEF]
   (ASSUME "GP_HOM(G1,prod1)(G2,prod2)(f:* -> **)"))) THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[NORMAL_DEF]
   (ASSUME "NORMAL(G1,prod1)(N:* -> bool)"))) THEN
 (ASSUME_TAC (UNDISCH
   (STRONG_INST
     [("G1:* -> bool","G:* -> bool");
      ("prod1:* -> * -> *","prod:* -> * -> *")] QUOTIENT_GROUP))) THEN
 ((REV_SUPPOSE_TAC "!Q.?w. GP_HOM(G1,prod1)(G2,prod2)f /\ NORMAL(G1,prod1)N /\
       (!n. N n ==> KERNEL(G1,prod1)(G2,prod2)(f:* -> **) n) /\
       (?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
       G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)") THENL
   [(GEN_TAC THEN 
     (EXISTS_TAC "@x:*.G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)") THEN
     (ASM_REWRITE_TAC[]) THEN DISCH_TAC THEN
     (SELECT_TAC "@x:*.G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)") THEN
     (FIRST_ASSUM ACCEPT_TAC));
    (POP_ASSUM
      \thm.(ASSUM_LIST
        \thl.(ASSUME_TAC
          (GEN "Q:* -> bool" (REWRITE_RULE thl 
           (SELECT_RULE (SPEC_ALL thm)))))))]) THEN(ASM_CONJ1_TAC THENL
  [ALL_TAC;
   ((FIRST_ASSUM
      (STRIP_ASSUME_TAC o (PURE_ONCE_REWRITE_RULE [GP_HOM_DEF]))) THEN
    ASM_CONJ1_TAC)]) THEN (REPEAT CONJ_TAC) THENL
 [((ASM_REWRITE_TAC [GP_HOM_DEF;QUOTIENT_SET_DEF;QUOTIENT_HOM_DEF]) THEN
   BETA_TAC THEN STRIP_TAC THENL
   [((X_GEN_TAC "q:* -> bool") THEN DISCH_TAC THEN RES_TAC);
    ((X_GEN_TAC "q:* -> bool") THEN (X_GEN_TAC "r:* -> bool") THEN
     DISCH_TAC THEN
     (POP_ASSUM
        \thm.((ASSUME_TAC (CONJUNCT1 thm)) THEN
              (ASSUME_TAC (CONJUNCT2 thm)))) THEN
     (IMP_RES_TAC (ASSUME "!Q.(?x:*. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
            G1(@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
              G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)) /\
            (Q = LEFT_COSET(G1,prod1) N
             (@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
               G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)))")) THEN
     (SUBST_MATCH_TAC (SYM (UNDISCH_ALL (hd (IMP_CANON
      (ASSUME "!x y. G1 x /\ G1 y ==>
               (f(prod1 x y) = prod2(f x)((f:* -> **) y))")))))) THEN
     (ASSUM_LIST \thl.(let eql = filter (is_eq o concl) thl in
       ((NEW_SUBST1_TAC
          (AP_TERM "quot_prod(G1,prod1)N (q:* -> bool)" (hd (tl eql)))) THEN
        (NEW_SUBST1_TAC
          (AP_TERM "quot_prod(G1,prod1)(N:* -> bool)" (hd eql)))))) THEN
     (NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON 
      (STRONG_INST ["N:* -> bool","H:* -> bool"] QUOTIENT_HOM_LEMMA))))) THEN
     (SUBST_MATCH_TAC (UNDISCH_ALL (hd (IMP_CANON QUOT_PROD)))) THEN
     ((REV_SUPPOSE_TAC "(?x:*. G1 x /\
         (LEFT_COSET (G1,prod1) N
          (prod1(@w. (?x. G1 x /\ (q = LEFT_COSET(G1,prod1)N x)) ==>
             G1 w /\ (q = LEFT_COSET(G1,prod1)N w))
           (@w'. (?x'. G1 x' /\ (r = LEFT_COSET(G1,prod1)N x')) ==>
             G1 w' /\ (r = LEFT_COSET(G1,prod1)N w'))) =
          LEFT_COSET(G1,prod1)N x))") THENL
      [((EXISTS_TAC "(prod1(@w:*. (?x. G1 x /\
          (q = LEFT_COSET(G1,prod1)N x)) ==>
             G1 w /\ (q = LEFT_COSET(G1,prod1)N w))
           (@w'. (?x'. G1 x' /\ (r = LEFT_COSET(G1,prod1)N x')) ==>
             G1 w' /\ (r = LEFT_COSET(G1,prod1)N w')))") THEN
        (CONJ_TAC THENL [GROUP_ELT_TAC; REFL_TAC]));
       ALL_TAC]) THEN
     (IMP_RES_TAC (ASSUME"!Q.(?x:*. G1 x /\
            (Q = LEFT_COSET(G1,prod1)N x)) ==>
            G1(@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
              G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)) /\
            (Q = LEFT_COSET(G1,prod1)N
             (@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
               G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)))")) THEN
     (POP_ASSUM STRIP_ASSUME_TAC) THEN
     (\ (asl,gl). (NEW_SUBST1_TAC (SYM (ASSUME (hd asl))) (asl,gl))) THEN
     (NEW_MATCH_ACCEPT_TAC
         (UNDISCH (SPEC_ALL (UNDISCH LEFT_COSETS_COVER)))) THEN
     GROUP_ELT_TAC)]);
  ((ASM_REWRITE_TAC[QUOTIENT_HOM_DEF;NAT_HOM_DEF;ETA_AX]) THEN BETA_TAC THEN
   (REPEAT STRIP_TAC) THEN
   ((REV_SUPPOSE_TAC
      "?x':*. G1 x' /\
           (LEFT_COSET(G1,prod1)N x = LEFT_COSET(G1,prod1)N x')") THENL
     [((EXISTS_TAC "x:*") THEN
       (CONJ_TAC THENL [(FIRST_ASSUM ACCEPT_TAC);REFL_TAC]));
      ((IMP_RES_TAC (ASSUME"!Q.(?x:*. G1 x /\
          (Q = LEFT_COSET(G1,prod1)N x)) ==>
          G1(@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
            G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)) /\
          (Q = LEFT_COSET(G1,prod1)N
           (@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
             G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)))")) THEN
         (POP_ASSUM STRIP_ASSUME_TAC))]) THEN
   (NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON 
    (STRONG_INST ["N:* -> bool","H:* -> bool"] QUOTIENT_HOM_LEMMA))))) THEN
   (\ (asl,gl). (NEW_SUBST1_TAC (SYM (ASSUME (hd asl))) (asl,gl))) THEN
   (NEW_MATCH_ACCEPT_TAC
     (UNDISCH (SPEC_ALL (UNDISCH LEFT_COSETS_COVER)))));
  ((ASM_REWRITE_TAC[IM_DEF;QUOTIENT_SET_DEF;QUOTIENT_HOM_DEF]) THEN
   BETA_TAC THEN
   (EXT_TAC "y:**") THEN BETA_TAC THEN GEN_TAC THEN
   EQ_TAC THEN STRIP_TAC THENL
   [((REPEAT STRIP_TAC) THEN
     ((REV_SUPPOSE_TAC
        "?x':*. G1 x' /\
             (x = LEFT_COSET(G1,prod1)N x')") THENL
       [((EXISTS_TAC "x':*") THEN
         (CONJ_TAC THEN (FIRST_ASSUM ACCEPT_TAC)));
        ((IMP_RES_TAC (ASSUME"!Q.(?x:*. G1 x /\
            (Q = LEFT_COSET(G1,prod1)N x)) ==>
            G1(@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
              G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)) /\
            (Q = LEFT_COSET(G1,prod1)N
             (@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
               G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)))")) THEN
           (POP_ASSUM STRIP_ASSUME_TAC))]) THEN
     (EXISTS_TAC "@w:*. (?x'. G1 x' /\ (x = LEFT_COSET(G1,prod1)N x')) ==>
        G1 w /\ (x = LEFT_COSET(G1,prod1)N w)") THEN
     (CONJ_TAC THEN (FIRST_ASSUM ACCEPT_TAC)));
    ((EXISTS_TAC "LEFT_COSET(G1,prod1)N (x:*)") THEN
     (ASM_REWRITE_TAC[]) THEN
     (ASM_CONJ1_TAC THENL
      [((EXISTS_TAC "x:*") THEN
        (CONJ_TAC THENL [(FIRST_ASSUM ACCEPT_TAC);REFL_TAC]));
        ((IMP_RES_TAC (ASSUME"!Q.(?x:*. G1 x /\
            (Q = LEFT_COSET(G1,prod1)N x)) ==>
            G1(@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
              G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)) /\
            (Q = LEFT_COSET(G1,prod1)N
             (@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
               G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)))")) THEN
          (POP_ASSUM STRIP_ASSUME_TAC))]) THEN
     (NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON 
      (STRONG_INST ["N:* -> bool","H:* -> bool"] QUOTIENT_HOM_LEMMA))))) THEN
     (\ (asl,gl). (NEW_SUBST1_TAC
      (AP_THM (ASSUME (hd asl)) (rand gl)) (asl,gl))) THEN
     (NEW_MATCH_ACCEPT_TAC
         (UNDISCH (SPEC_ALL (UNDISCH LEFT_COSETS_COVER)))))]);
  ((ASM_REWRITE_TAC [IM_DEF;KERNEL_DEF]) THEN BETA_TAC THEN
   (EXT_TAC "q:* -> bool") THEN BETA_TAC THEN
   (ASM_REWRITE_TAC
      [QUOTIENT_SET_DEF;QUOTIENT_HOM_DEF;NAT_HOM_DEF;ETA_AX]) THEN
   BETA_TAC THEN GEN_TAC THEN EQ_TAC THEN STRIP_TAC THENL
   [((EXISTS_TAC "x:*") THEN (REDUCE_TAC[]) THEN
     (\ (asl,gl).NEW_SUBST1_TAC (SYM (ASSUME (hd asl))) (asl,gl)) THEN
     (NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON 
       (STRONG_INST ["N:* -> bool","H:* -> bool"] QUOTIENT_HOM_LEMMA))))) THEN
     (REPEAT STRIP_TAC) THEN
     ((REV_SUPPOSE_TAC
        "?x:*. G1 x /\
             (q = LEFT_COSET(G1,prod1)N x)") THENL
       [((EXISTS_TAC "x:*") THEN
         (CONJ_TAC THEN (FIRST_ASSUM ACCEPT_TAC)));
        ((IMP_RES_TAC (ASSUME"!Q.(?x:*. G1 x /\
            (Q = LEFT_COSET(G1,prod1)N x)) ==>
            G1(@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
              G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)) /\
            (Q = LEFT_COSET(G1,prod1)N
             (@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
               G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)))")) THEN
           (POP_ASSUM STRIP_ASSUME_TAC))]) THEN
     (\ (asl,gl). (NEW_SUBST1_TAC
      (SYM (AP_THM (ASSUME "q = LEFT_COSET(G1,prod1)N (x:*)")
             (rand gl))) (asl,gl))) THEN
     (\ (asl,gl). (NEW_SUBST1_TAC
      (AP_THM (ASSUME (hd asl)) (rand gl)) (asl,gl))) THEN
     (NEW_MATCH_ACCEPT_TAC
         (UNDISCH (SPEC_ALL (UNDISCH LEFT_COSETS_COVER)))));
    ((ASM_CONJ1_TAC THENL
       [((EXISTS_TAC "x:*") THEN REDUCE_TAC[]);
        ((IMP_RES_TAC (ASSUME"!Q.(?x:*. G1 x /\
            (Q = LEFT_COSET(G1,prod1)N x)) ==>
            G1(@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
              G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)) /\
            (Q = LEFT_COSET(G1,prod1)N
             (@w.(?x. G1 x /\ (Q = LEFT_COSET(G1,prod1)N x)) ==>
               G1 w /\ (Q = LEFT_COSET(G1,prod1)N w)))")) THEN
          (POP_ASSUM STRIP_ASSUME_TAC))]) THEN
     (NEW_SUBST1_TAC (SYM (ASSUME "(f:* -> **) x = ID(G2,prod2)"))) THEN
     (NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON 
       (STRONG_INST ["N:* -> bool","H:* -> bool"] QUOTIENT_HOM_LEMMA))))) THEN
     (\ (asl,gl). (NEW_SUBST1_TAC
       (SYM (ASSUME (hd asl))) (asl,gl))) THEN
     (\ (asl,gl). (NEW_SUBST1_TAC (AP_THM
       (ASSUME "q = LEFT_COSET(G1,prod1)N (x:*)")(rand gl))(asl,gl))) THEN
     (NEW_MATCH_ACCEPT_TAC
         (UNDISCH (SPEC_ALL (UNDISCH LEFT_COSETS_COVER)))))]);
  ((ASM_REWRITE_TAC[NAT_HOM_DEF;ETA_AX]) THEN
   (POP_ASSUM \thm.ASSUM_LIST \thl.STRIP_ASSUME_TAC
     (REWRITE_RULE ([NAT_HOM_DEF;ETA_AX] @ thl) thm)) THEN
   GEN_TAC THEN STRIP_TAC THEN GEN_TAC THEN
   (ASM_REWRITE_TAC [QUOTIENT_SET_DEF]) THEN STRIP_TAC THEN
   (NEW_SUBST1_TAC (AP_TERM "g:(* -> bool) -> **" 
     (ASSUME "q = LEFT_COSET(G1,prod1)N (x:*)"))) THEN
   (IMP_RES_TAC (ASSUME
      "!x. G1 x ==>
           (quot_hom(G1,prod1)(G2,prod2)N f(LEFT_COSET(G1,prod1)N x) =
            (f:* -> **) x)")) THEN
   (IMP_RES_TAC (ASSUME
      "!x. G1 x ==> (g(LEFT_COSET(G1,prod1)N x) = (f:* -> **) x)")) THEN
   (ASM_REWRITE_TAC []))]));;

%QUOT_HOM_THM = 
|- GP_HOM(G1,prod1)(G2,prod2)f /\
   NORMAL(G1,prod1)N /\
   (!n. N n ==> KERNEL(G1,prod1)(G2,prod2)f n) ==>
   GP_HOM
   (quot_set(G1,prod1)N,quot_prod(G1,prod1)N)
   (G2,prod2)
   (quot_hom(G1,prod1)(G2,prod2)N f) /\
   (!x.
     G1 x ==>
     (quot_hom(G1,prod1)(G2,prod2)N f(NAT_HOM(G1,prod1)N x) = f x)) /\
   (IM(quot_set(G1,prod1)N)(quot_hom(G1,prod1)(G2,prod2)N f) = IM G1 f) /\
   (KERNEL
    (quot_set(G1,prod1)N,quot_prod(G1,prod1)N)
    (G2,prod2)
    (quot_hom(G1,prod1)(G2,prod2)N f) =
    IM(KERNEL(G1,prod1)(G2,prod2)f)(NAT_HOM(G1,prod1)N)) /\
   (!g.
     GP_HOM(quot_set(G1,prod1)N,quot_prod(G1,prod1)N)(G2,prod2)g /\
     (!x. G1 x ==> (g(NAT_HOM(G1,prod1)N x) = f x)) ==>
     (!q.
       quot_set(G1,prod1)N q ==>
       (g q = quot_hom(G1,prod1)(G2,prod2)N f q))) %


let QUOTIENT_IM_LEMMA = prove_thm(`QUOTIENT_IM_LEMMA`,
"SUBGROUP(G,prod)H /\ NORMAL(G,prod)N /\ (!n:*. N n ==> H n) ==>
(IM H (NAT_HOM(G,prod)N) = quot_set(H,prod)N)",
(STRIP_TAC THEN
 (STRIP_ASSUME_TAC (PURE_REWRITE_RULE[SUBGROUP_DEF]
  (ASSUME "SUBGROUP(G,prod)(H:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC (PURE_REWRITE_RULE[NORMAL_DEF]
  (ASSUME "NORMAL(G,prod)(N:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC (PURE_REWRITE_RULE[SUBGROUP_DEF]
  (ASSUME "SUBGROUP(G,prod)(N:* -> bool)"))) THEN
 (EXT_TAC "q:* -> bool") THEN GEN_TAC THEN
 (ASM_REWRITE_TAC[IM_DEF;NAT_HOM_DEF;QUOTIENT_SET_DEF]) THEN
 BETA_TAC THEN (CONV_TAC (DEPTH_CONV ETA_CONV)) THEN EQ_TAC THEN
 (REPEAT STRIP_TAC) THENL
 [((SUPPOSE_TAC "N = \x:*.H x /\ N x") THENL
    [((ONCE_ASM_REWRITE_TAC[]) THEN
      (ACCEPT_TAC (UNDISCH_ALL(hd(IMP_CANON NORMAL_INTERSECTION)))));
     ((EXT_TAC "n:*") THEN BETA_TAC THEN GEN_TAC THEN
      EQ_TAC THEN STRIP_TAC THEN RES_TAC THEN (ASM_REWRITE_TAC[]))]);
  ((EXISTS_TAC "x:*") THEN 
   (ASM_REWRITE_TAC
     [(CONV_RULE (DEPTH_CONV ETA_CONV) (ABS "y:*" (SPEC_ALL LEFT_COSET_DEF)));
      SUBGROUP_DEF]) THEN
   (EXT_TAC "y:*") THEN BETA_TAC THEN GEN_TAC THEN
   EQ_TAC THEN STRIP_TAC THENL
   [(CONJ_TAC THENL 
     [((ASM_REWRITE_TAC[]) THEN RES_TAC THEN GROUP_ELT_TAC);
      ((EXISTS_TAC "h:*") THEN CONJ_TAC THEN (FIRST_ASSUM ACCEPT_TAC))]);
    (RES_TAC THEN (ASM_REWRITE_TAC[]) THEN (EXISTS_TAC "h:*") THEN
     CONJ_TAC THENL [FIRST_ASSUM ACCEPT_TAC; REFL_TAC])]);
  ((EXISTS_TAC "x:*") THEN 
   (ASM_REWRITE_TAC
     [(CONV_RULE (DEPTH_CONV ETA_CONV) (ABS "y:*" (SPEC_ALL LEFT_COSET_DEF)));
      SUBGROUP_DEF]) THEN
   (EXT_TAC "y:*") THEN BETA_TAC THEN GEN_TAC THEN
   EQ_TAC THEN STRIP_TAC THENL
   [(RES_TAC THEN (ASM_REWRITE_TAC[]) THEN (EXISTS_TAC "h:*") THEN
     CONJ_TAC THENL [FIRST_ASSUM ACCEPT_TAC; REFL_TAC]);
    (CONJ_TAC THENL 
     [((ASM_REWRITE_TAC[]) THEN RES_TAC THEN GROUP_ELT_TAC);
      ((EXISTS_TAC "h:*") THEN CONJ_TAC THEN (FIRST_ASSUM ACCEPT_TAC))])])]));;

%QUOTIENT_IM_LEMMA = 
|- SUBGROUP(G,prod)H /\ NORMAL(G,prod)N /\ (!n. N n ==> H n) ==>
   (IM H(NAT_HOM(G,prod)N) = quot_set(H,prod)N) %


let GP_ISO_DEF = new_definition(`GP_ISO_DEF`,
"GP_ISO(G1:* -> bool,prod1)(G2:** -> bool,prod2)f =
   GP_HOM(G1,prod1)(G2,prod2)f /\
   (?g. GP_HOM(G2,prod2)(G1,prod1)g /\
        (!x. G1 x ==> (g (f x) = x)) /\
        (!y. G2 y ==> (f (g y) = y)))");;

%GP_ISO_DEF = 
|- GP_ISO(G1,prod1)(G2,prod2)f =
   GP_HOM(G1,prod1)(G2,prod2)f /\
   (?g.
     GP_HOM(G2,prod2)(G1,prod1)g /\
     (!x. G1 x ==> (g(f x) = x)) /\
     (!y. G2 y ==> (f(g y) = y)))%


let GP_ISO_COMP = prove_thm(`GP_ISO_COMP`,
"GP_ISO(G1,prod1)(G2,prod2)(f:* -> **) /\
 GP_ISO(G2,prod2)(G3,prod3)(g:** -> ***) ==>
 GP_ISO(G1,prod1)(G3,prod3)(\x.g (f x))",
((PURE_ONCE_REWRITE_TAC[GP_ISO_DEF]) THEN BETA_TAC THEN 
 (REPEAT STRIP_TAC) THENL
  [(ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON GP_HOM_COMP))));
   ALL_TAC]) THEN
 (EVERY_ASSUM (\thm.(if is_forall (concl thm) then ALL_TAC
   else (ASSUME_TAC (MATCH_MP
    (DISCH_ALL (CONJUNCT1 (CONJUNCT2 (CONJUNCT2 (UNDISCH
      (fst (EQ_IMP_RULE (SPEC_ALL GP_HOM_DEF)))))))) thm))))) THEN
 (EXISTS_TAC "\z:***.(g'((g'' z):**):*)") THEN
 (REPEAT STRIP_TAC) THEN
 ((NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON GP_HOM_COMP)))) ORELSE
  (BETA_TAC THEN RES_TAC THEN RES_TAC THEN (ASM_REWRITE_TAC[]))));;


%GP_ISO_COMP = 
|- GP_ISO(G1,prod1)(G2,prod2)f /\ GP_ISO(G2,prod2)(G3,prod3)g ==>
   GP_ISO(G1,prod1)(G3,prod3)(\x. g(f x)) %

let Id_GP_ISO = prove_thm(`Id_GP_ISO`,
"GROUP(G1,prod1) ==> GP_ISO(G1,prod1)(G1,prod1)(\x:*.x)",
(DISCH_TAC THEN 
 (IMP_RES_TAC Id_GP_HOM) THEN
 (ASM_REWRITE_TAC[GP_ISO_DEF]) THEN
 (EXISTS_TAC "\x:*.x") THEN
 BETA_TAC THEN (ASM_REWRITE_TAC[])));;

%Id_GP_ISO = |- GROUP(G1,prod1) ==> GP_ISO(G1,prod1)(G1,prod1)(\x. x)%


let GP_ISO_INV_ISO = prove_thm(`GP_ISO_INV`,
"GP_ISO(G1,prod1)(G2,prod2)(f:* -> **) ==>
 ?g. (!x. G1 x ==> (g(f x) = x)) /\ (!y. G2 y ==> (f(g y) = y)) /\
     GP_ISO(G2,prod2)(G1,prod1)g",
((PURE_ONCE_REWRITE_TAC[GP_ISO_DEF]) THEN (REPEAT STRIP_TAC) THEN
 (EXISTS_TAC "g:** -> *") THEN (ASM_REWRITE_TAC[]) THEN
(EXISTS_TAC "f:* -> **") THEN (ASM_REWRITE_TAC[])));;

%GP_ISO_INV_ISO = 
|- GP_ISO(G1,prod1)(G2,prod2)f ==>
   (?g.
     (!x. G1 x ==> (g(f x) = x)) /\
     (!y. G2 y ==> (f(g y) = y)) /\
     GP_ISO(G2,prod2)(G1,prod1)g) %

let GP_ISO_IM_LEMMA = prove_thm(`GP_ISO_IM_LEMMA`,
"GP_ISO(G1,prod1)(G2,prod2)(f:* -> **) ==> ((IM G1 f) = G2)",
(DISCH_TAC THEN
 (FIRST_ASSUM
   (STRIP_ASSUME_TAC o (PURE_REWRITE_RULE [GP_ISO_DEF;GP_HOM_DEF]))) THEN
 (PURE_ONCE_REWRITE_TAC[IM_DEF]) THEN
 (EXT_TAC "z:**") THEN BETA_TAC THEN
 GEN_TAC THEN EQ_TAC THEN STRIP_TAC THEN RES_TAC THENL
 [(ASM_REWRITE_TAC[]);
  ((EXISTS_TAC "(g (z:**)):*") THEN (ASM_REWRITE_TAC[]))]));;

%GP_ISO_IM_LEMMA = |- GP_ISO(G1,prod1)(G2,prod2)f ==> (IM G1 f = G2) %


let GP_ISO_KERNEL = prove_thm (`GP_ISO_KERNEL`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==>
 (GP_ISO(G1,prod1)((IM G1 f),prod2)(f:* -> **) =
  (KERNEL(G1,prod1)(G2,prod2)f = \x. (x = ID(G1,prod1))))",
(DISCH_TAC THEN
 (ASM_REWRITE_TAC[GP_ISO_DEF;(UNDISCH GP_HOM_RES_TO_IM);KERNEL_DEF]) THEN
 (NEW_SUBST1_TAC
      (SYM (MATCH_MP SBGP_ID_GP_ID (UNDISCH GROUP_HOM_IM)))) THEN
 (POP_ASSUM (ASSUME_TAC o
   (PURE_ONCE_REWRITE_RULE [IM_DEF]) o (MP GP_HOM_RES_TO_IM))) THEN
 (FIRST_ASSUM (STRIP_ASSUME_TAC o BETA_RULE o
   (PURE_ONCE_REWRITE_RULE[GP_HOM_DEF]))) THEN
 (PURE_ONCE_REWRITE_TAC [IM_DEF]) THEN BETA_TAC THEN EQ_TAC THENL
 [(STRIP_TAC THEN (EXT_TAC "x:*") THEN BETA_TAC THEN
   GEN_TAC THEN EQ_TAC THENL
   [(STRIP_TAC THEN
     (NEW_SUBST1_TAC (SYM (UNDISCH (SPEC "x:*"
        (ASSUME "!x:*. G1 x ==> (g((f x):**) = x)"))))) THEN
     (NEW_SUBST1_TAC 
        (ASSUME "f (x:*) = ID((\y:**. ?x. G1 x /\ (y = f x)),prod2)")) THEN
     (NEW_MATCH_ACCEPT_TAC (CONJUNCT1 (UNDISCH HOM_ID_INV_LEMMA))));
    (DISCH_TAC THEN
     (CONJ_TAC THENL [((ASM_REWRITE_TAC[]) THEN GROUP_ELT_TAC);ALL_TAC]) THEN
     (NEW_SUBST1_TAC
        (AP_TERM "f:* -> **" (ASSUME "(x:*) = ID(G1,prod1)"))) THEN
     (NEW_MATCH_ACCEPT_TAC (CONJUNCT1 (UNDISCH HOM_ID_INV_LEMMA))))]);
  (DISCH_TAC THEN
   (POP_ASSUM 
      \thm. (ASSUME_TAC (GEN "z:*" (BETA_RULE (AP_THM thm "z:*"))))) THEN
   (SUPPOSE_TAC "?g:** -> *. (!x. G1 x ==> (g(f x) = x)) /\
    (!y. (?x. G1 x /\ (y = f x)) ==> (f(g y) = y))") THENL
   [((POP_ASSUM (STRIP_ASSUME_TAC o SELECT_RULE)) THEN
     (EXISTS_TAC "@g:** -> *. (!x. G1 x ==> (g(f x) = x)) /\
      (!y. (?x. G1 x /\ (y = f x)) ==> (f(g y) = y))") THEN
     (ASM_REWRITE_TAC []) THEN
     (PURE_ONCE_REWRITE_TAC[GP_HOM_DEF]) THEN
     BETA_TAC THEN (ASM_REWRITE_TAC []) THEN
     (REPEAT STRIP_TAC) THEN RES_TAC THEN
     (ASM_REWRITE_TAC[]) THEN
     (NEW_SUBST1_TAC (SYM (UNDISCH_ALL (hd (IMP_CANON
        (SPECL ["x':*";"x'':*"] (ASSUME "!(x:*) y. G1 x /\ G1 y ==>
          (f(prod1 x y) = prod2(f x)((f y):**))"))))))) THEN
     ((NEW_SUBST1_TAC (UNDISCH (SPEC "(prod1:* -> * -> *) x' x''"
        (ASSUME "!x:*. G1 x ==> ((@g. (!x. G1 x ==> (g(f x) = x)) /\ 
           (!y:**. (?x. G1 x /\ (y = f x)) ==>
              (f(g y) = y))) (f x) = x)")))) THENL
      [REFL_TAC;GROUP_ELT_TAC]));
    (((REV_SUPPOSE_TAC
        "!y:**. ?w:*. (?x. G1 x /\ (y = f x)) ==> G1 w /\ (y = f w)") THENL
       [(GEN_TAC THEN (EXISTS_TAC "@x:*. G1 x /\ ((y:**) = f x)") THEN
         DISCH_TAC THEN (POP_ASSUM (ACCEPT_TAC o SELECT_RULE)));
        (POP_ASSUM (ASSUME_TAC o 
          \thm. (GEN "y:**" (SELECT_RULE (SPEC "y:**" thm)))))]) THEN
     (EXISTS_TAC 
       "\y:**. @w:*. (?x. G1 x /\ (y = f x)) ==> G1 w /\ (y = f w)") THEN
     BETA_TAC THEN ASM_CONJ2_TAC THEN (REPEAT STRIP_TAC) THEN
     (IMP_RES_TAC (ASSUME "!x:*. G1 x ==>
       (?x'. G1 x' /\ (((f x):**) = f x'))")) THEN
     (IMP_RES_TAC (ASSUME "!y:**. (?x:*. G1 x /\ (y = f x)) ==>
            G1(@w. (?x. G1 x /\ (y = f x)) ==> G1 w /\ (y = f w)) /\
            (y = f(@w. (?x. G1 x /\ (y = f x)) ==> G1 w /\ (y = f w)))")) THENL
      [(((MATCH_MP_IMP_TAC (UNDISCH (UNDISCH (UNDISCH (hd (IMP_CANON
          (SPECL ["INV(G1,prod1)(x:*)";"y:*";"x:*"] (UNDISCH
          (STRONG_INST [("G1:* -> bool","G:* -> bool");
           "prod1:* -> * -> *","prod:* -> * -> *"]
             LEFT_CANCELLATION))))))))) THENL
         [(SUBST_MATCH_TAC (CONJUNCT1 (UNDISCH 
            (SPEC "x:*" (UNDISCH INV_LEMMA)))));
          GROUP_ELT_TAC]) THEN
       (PURE_ONCE_REWRITE_TAC [(SYM (SPEC_ALL (ASSUME "!z:*.
              G1 z /\ (f z = ID((\y:**. ?x. G1 x /\ (y = f x)),prod2)) =
              (z = ID(G1,prod1))")))]) THEN
       (CONJ_TAC THENL [GROUP_ELT_TAC;ALL_TAC]) THEN
       (NEW_SUBST1_TAC (UNDISCH_ALL(hd (IMP_CANON (SPECL
           ["INV(G1,prod1)x:*";
            "(@w:*. (?x'. G1 x' /\ (((f x):**) = f x')) ==>
                 G1 w /\ (f x = f w))"]
           (ASSUME "!(x:*) y. G1 x /\ G1 y ==>
           (f(prod1 x y) = prod2(f x)((f y):**))")))))) THEN
       (IMP_RES_TAC (ASSUME "!x:*. G1 x ==>
         (?x'. G1 x' /\ (((f x):**) = f x'))")) THEN
       ((MP_IMP_TAC 
          (UNDISCH (SPECL ["f(x:*):**";
            "prod2((f(INV(G1,prod1)(x:*))):**)
              (f(@w. (?x'. G1 x' /\ (f x = f x')) ==>
                 G1 w /\ (f x = f w))):**";
            "ID((\y:**. ?x:*. G1 x /\ (y = f x)),prod2)"]
          (UNDISCH (STRONG_INST_TY_TERM
            (match "ID(G,prod):*" "ID((\y:**. ?x:*. G1 x /\ (y = f x)),prod2)")
            LEFT_CANCELLATION))))) THENL
         [(POP_ASSUM STRIP_ASSUME_TAC);
          (GROUP_ELT_TAC THEN BETA_TAC THEN (FIRST_ASSUM ACCEPT_TAC))]) THEN
       (GROUP_LEFT_ASSOC_TAC "prod2 ((f x):**)(prod2 (f(INV(G1,prod1)x))
          (f(@w:*. (?x'. G1 x' /\ (f x = f x')) ==>
             G1 w /\ (f x = f w))))") THEN
       BETA_TAC THEN ((FIRST_ASSUM ACCEPT_TAC) ORELSE ALL_TAC) THEN
       (NEW_SUBST1_TAC (UNDISCH (SPEC_ALL (CONJUNCT2 (UNDISCH
          (STRONG_INST [("(\y:**. ?x:*. G1 x /\ (y = f x))","G2:** -> bool")]
          HOM_ID_INV_LEMMA)))))) THEN
       (SUBST_MATCH_TAC (CONJUNCT2 (UNDISCH
         (SPEC_ALL (UNDISCH INV_LEMMA))))) THEN
       (SUBST_MATCH_TAC (UNDISCH (SPEC_ALL (CONJUNCT1
         (CONJUNCT2 (UNDISCH ID_LEMMA)))))) THEN
       (SUBST_MATCH_TAC (UNDISCH (SPEC_ALL (CONJUNCT1
         (CONJUNCT2 (CONJUNCT2 (UNDISCH ID_LEMMA))))))) THEN
       (PURE_ONCE_REWRITE_TAC[EQ_SYM_EQ]) THEN (FIRST_ASSUM ACCEPT_TAC));
      ((NEW_SUBST1_TAC (ASSUME "(y:**) = f (x:*)")) THEN
       (PURE_ONCE_REWRITE_TAC[EQ_SYM_EQ]) THEN
       (FIRST_ASSUM ACCEPT_TAC))])])]));;

%GP_ISO_KERNEL = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==>
   (GP_ISO(G1,prod1)(IM G1 f,prod2)f =
    (KERNEL(G1,prod1)(G2,prod2)f = (\x. x = ID(G1,prod1)))) %


let GP_ISO_CHAR = prove_thm(`GP_ISO_CHAR`,
"GP_ISO(G1,prod1)(G2,prod2)(f:* -> **) =
 GP_HOM(G1,prod1)(G2,prod2)f /\ (IM G1 f = G2) /\
 (KERNEL(G1,prod1)(G2,prod2)f = (\x. x = ID(G1,prod1)))",
(EQ_TAC THENL
 [(DISCH_TAC THEN
   (FIRST_ASSUM
    (STRIP_ASSUME_TAC o (PURE_ONCE_REWRITE_RULE[GP_ISO_DEF]))) THEN
   (ASM_REWRITE_TAC []) THEN
   (ASM_CONJ1_TAC THENL
     [(ACCEPT_TAC(UNDISCH GP_ISO_IM_LEMMA));
      (ASM_REWRITE_TAC[(SYM(UNDISCH GP_ISO_KERNEL))])]));
  (STRIP_TAC THEN
   (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE [KERNEL_DEF]
     (ASSUME "KERNEL(G1,prod1)(G2,prod2)(f:* -> **) =
              (\x. x = ID(G1,prod1))"))) THEN
   (NEW_SUBST1_TAC 
     (PURE_ONCE_REWRITE_RULE [(ASSUME "(IM G1 (f:* -> **) = G2)")]
        (UNDISCH GP_ISO_KERNEL))) THEN
   (FIRST_ASSUM ACCEPT_TAC))]));;

%GP_ISO_CHAR = 
|- GP_ISO(G1,prod1)(G2,prod2)f =
   GP_HOM(G1,prod1)(G2,prod2)f /\
   (IM G1 f = G2) /\
   (KERNEL(G1,prod1)(G2,prod2)f = (\x. x = ID(G1,prod1))) %


let FIRST_ISO_THM = prove_thm (`FIRST_ISO_THM`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==>
 GP_ISO(quot_set(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f),
        quot_prod(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f))
       ((IM G1 f),prod2)
       (quot_hom(G1,prod1)(G2,prod2)(KERNEL(G1,prod1)(G2,prod2)f) f) /\ 
  !x. G1 x ==>
   (quot_hom(G1,prod1)(G2,prod2)(KERNEL(G1,prod1)(G2,prod2)f) f
      (NAT_HOM(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f) x) = f x)",
(DISCH_TAC THEN (STRIP_ASSUME_TAC (UNDISCH
  (REWRITE_RULE[(UNDISCH KERNEL_NORMAL)] 
   (INST [("KERNEL(G1,prod1)(G2,prod2)(f:* -> **)","N:* -> bool")]
    QUOT_HOM_THM)))) THEN
 (ASM_REWRITE_TAC[]) THEN
 (NEW_SUBST1_TAC (SYM (ASSUME
    "IM (quot_set(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f))
        (quot_hom(G1,prod1)(G2,prod2)(KERNEL(G1,prod1)(G2,prod2)f)f) =
     IM G1 (f:* -> **)"))) THEN
 (SUBST_MATCH_TAC (UNDISCH GP_ISO_KERNEL)) THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[GP_HOM_DEF]
   (ASSUME "GP_HOM(G1,prod1)(G2,prod2)(f:* -> **)"))) THEN
 (ASSUME_TAC (UNDISCH KERNEL_NORMAL)) THEN
 (ASM_REWRITE_TAC[]) THEN
 (SUBST_MATCH_TAC (UNDISCH_ALL (hd (IMP_CANON (DISCH_ALL
   (AP_TERM "IM:(* -> bool) -> (* -> **) -> (** -> bool)"
   (SYM (CONJUNCT2 (CONJUNCT2 (UNDISCH 
   (STRONG_INST [("G1:* -> bool","G:* -> bool");
                 ("prod1:* -> * -> *","prod:* -> * -> *")]
   NAT_HOM_THM))))))))))) THEN
 (NEW_MATCH_ACCEPT_TAC (UNDISCH KERNEL_IM_LEMMA)) THEN
 (NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON (DISCH_ALL
  (CONJUNCT1 (UNDISCH NAT_HOM_THM)))))))));;

%FIRST_ISO_THM = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==>
   GP_ISO
   (quot_set(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f),
    quot_prod(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f))
   (IM G1 f,prod2)
   (quot_hom(G1,prod1)(G2,prod2)(KERNEL(G1,prod1)(G2,prod2)f)f) /\
   (!x.
     G1 x ==>
     (quot_hom
      (G1,prod1)
      (G2,prod2)
      (KERNEL(G1,prod1)(G2,prod2)f)
      f
      (NAT_HOM(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f)x) =
      f x)) %


let CLASSICAL_FIRST_ISO_THM = prove_thm(`CLASSICAL_FIRST_ISO_THM`,
"GP_HOM(G1,prod1)(G2,prod2)(f:* -> **) ==>
 ?f_bar.
  GP_ISO(quot_set(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f),
         quot_prod(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f))
         ((IM G1 f),prod2)
         f_bar /\
  !x. G1 x ==>
      (f_bar (NAT_HOM(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f) x) = f x)",
(DISCH_TAC THEN
 (EXISTS_TAC
   "(quot_hom(G1,prod1)(G2,prod2)(KERNEL(G1,prod1)(G2,prod2)f)(f:* -> **))")
  THEN (ACCEPT_TAC (UNDISCH FIRST_ISO_THM))));;

%CLASSICAL_FIRST_ISO_THM = 
|- GP_HOM(G1,prod1)(G2,prod2)f ==>
   (?f_bar.
     GP_ISO
     (quot_set(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f),
      quot_prod(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f))
     (IM G1 f,prod2)
     f_bar /\
     (!x.
       G1 x ==>
       (f_bar(NAT_HOM(G1,prod1)(KERNEL(G1,prod1)(G2,prod2)f)x) = f x)))%


let SND_ISO_THM = prove_thm (`SND_ISO_THM`,
"NORMAL(G,prod)N /\ NORMAL(G,prod)M /\ (!n:*. N n ==> M n) ==>
GP_ISO
  (quot_set(quot_set(G,prod)N,quot_prod(G,prod)N)(quot_set(M,prod)N),
   quot_prod(quot_set(G,prod)N,quot_prod(G,prod)N)(quot_set(M,prod)N))
  (quot_set(G,prod)M,quot_prod(G,prod)M)
  (quot_hom
    (quot_set(G,prod)N,quot_prod(G,prod)N)
    (quot_set(G,prod)M,quot_prod(G,prod)M)
    (quot_set(M,prod)N)
    (quot_hom
      (G,prod)
      (quot_set(G,prod)M,quot_prod(G,prod)M)
      N
      (NAT_HOM(G,prod)M)))",
(STRIP_TAC THEN
 (STRIP_ASSUME_TAC (PURE_REWRITE_RULE[NORMAL_DEF]
   (ASSUME "NORMAL(G,prod)(M:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC (PURE_REWRITE_RULE[NORMAL_DEF]
   (ASSUME "NORMAL(G,prod)(N:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC (PURE_REWRITE_RULE[SUBGROUP_DEF]
   (ASSUME "SUBGROUP(G,prod)(M:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC (PURE_REWRITE_RULE[SUBGROUP_DEF]
   (ASSUME "SUBGROUP(G,prod)(N:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC (UNDISCH GROUP_IS_SBGP)) THEN
 (ASSUM_LIST \thl.STRIP_ASSUME_TAC (REWRITE_RULE thl
  (STRONG_INST ["M:* -> bool","N:* -> bool"] NAT_HOM_THM))) THEN
 (ASSUM_LIST \thl.STRIP_ASSUME_TAC (REWRITE_RULE thl
  (STRONG_INST_TY_TERM
   (match "GP_HOM(G1,prod1)(G2,prod2)(f:* -> **)"
     "GP_HOM(G,prod)(quot_set(G,prod)M,quot_prod(G,prod)M)
      (NAT_HOM(G,prod)(M:* -> bool))") QUOT_HOM_THM))) THEN
 (NEW_MATCH_ACCEPT_TAC
  ((STRONG_INST_TY_TERM
    (match "GP_HOM(G1:* -> bool,prod1)(G2:** -> bool,prod2)"
     "GP_HOM(quot_set(G,prod)N,quot_prod(G,prod)(N:* -> bool))
       (quot_set(G,prod)M,quot_prod(G,prod)M)")
     FIRST_ISO_THM) and_then
   (REWRITE_RULE 
    [(ASSUME "KERNEL(quot_set(G,prod)N,quot_prod(G,prod)N)
               (quot_set(G,prod)M,quot_prod(G,prod)M) f =
              quot_set(M,prod)(N:* -> bool)");
     (ASSUME "IM (quot_set(G,prod)N) f = quot_set(G,prod)(M:* -> bool)")])
   and_then UNDISCH and_then CONJUNCT1)) THEN
 (ASM_REWRITE_TAC[]) THEN
 (NEW_MATCH_ACCEPT_TAC (UNDISCH_ALL (hd (IMP_CANON QUOTIENT_IM_LEMMA))))));;

%SND_ISO_THM = 
|- NORMAL(G,prod)N /\ NORMAL(G,prod)M /\ (!n. N n ==> M n) ==>
   GP_ISO
   (quot_set(quot_set(G,prod)N,quot_prod(G,prod)N)(quot_set(M,prod)N),
    quot_prod(quot_set(G,prod)N,quot_prod(G,prod)N)(quot_set(M,prod)N))
   (quot_set(G,prod)M,quot_prod(G,prod)M)
   (quot_hom
    (quot_set(G,prod)N,quot_prod(G,prod)N)
    (quot_set(G,prod)M,quot_prod(G,prod)M)
    (quot_set(M,prod)N)
    (quot_hom
     (G,prod)
     (quot_set(G,prod)M,quot_prod(G,prod)M)
     N
     (NAT_HOM(G,prod)M))) %


let CLASSICAL_SND_ISO_THM = prove_thm(`CLASSICAL_SND_ISO_THM`,
"NORMAL(G,prod)N /\ NORMAL(G,prod)M /\ (!n:*. N n ==> M n) ==>
 ?f. GP_ISO
     (quot_set(quot_set(G,prod)N,quot_prod(G,prod)N)(quot_set(M,prod)N),
      quot_prod(quot_set(G,prod)N,quot_prod(G,prod)N)(quot_set(M,prod)N))
     (quot_set(G,prod)M,quot_prod(G,prod)M)
     f",
((REPEAT STRIP_TAC) THEN
 (EXISTS_TAC
  "quot_hom
    (quot_set(G,prod)N,quot_prod(G,prod)N)
    (quot_set(G,prod)M,quot_prod(G,prod)M)
    (quot_set(M,prod)N)
    (quot_hom
      (G,prod)
      (quot_set(G,prod)M,quot_prod(G,prod)M)
      (N:* -> bool)
      (NAT_HOM(G,prod)M))")
  THEN (MP_IMP_TAC SND_ISO_THM) THEN (REDUCE_TAC []) THEN RES_TAC));;

%CLASSICAL_SND_ISO_THM = 
|- NORMAL(G,prod)N /\ NORMAL(G,prod)M /\ (!n. N n ==> M n) ==>
   (?f.
     GP_ISO
     (quot_set(quot_set(G,prod)N,quot_prod(G,prod)N)(quot_set(M,prod)N),
      quot_prod(quot_set(G,prod)N,quot_prod(G,prod)N)(quot_set(M,prod)N))
     (quot_set(G,prod)M,quot_prod(G,prod)M)
     f) %


let THIRD_ISO_THM = prove_thm(`THIRD_ISO_THM`,
"SUBGROUP(G,prod)H /\ NORMAL(G,prod)(N:* -> bool) ==>
GP_ISO
(quot_set(H,prod)(\x.H x /\ N x),quot_prod(H,prod)(\x.H x /\ N x))
(quot_set(set_prod(G,prod)H N,prod)N,quot_prod(set_prod(G,prod)H N,prod)N)
(quot_hom
 (H,prod)
 (quot_set(set_prod(G,prod)H N,prod)N,quot_prod(set_prod(G,prod)H N,prod)N)
 (\x.H x /\ N x)
 (NAT_HOM(set_prod(G,prod)H N,prod)N))",
(STRIP_TAC THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[NORMAL_DEF]
   (ASSUME "NORMAL(G,prod)(N:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[SUBGROUP_DEF]
   (ASSUME "SUBGROUP(G,prod)(H:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[SUBGROUP_DEF]
   (ASSUME "SUBGROUP(G,prod)(N:* -> bool)"))) THEN
 (STRIP_ASSUME_TAC (UNDISCH_ALL (hd (IMP_CANON NORMAL_PROD)))) THEN
 (FIRST_ASSUM (STRIP_ASSUME_TAC o (PURE_ONCE_REWRITE_RULE[SUBGROUP_DEF]))) THEN
 ((REV_SUPPOSE_TAC "NORMAL(set_prod(G,prod)H N,prod)(N:* -> bool)") THENL
 [((SUPPOSE_TAC "N = \x:*.set_prod(G,prod)H N x /\ N x") THENL
   [((\ (asl,gl).
       NEW_SUBST1_TAC (AP_TERM (rator gl) (ASSUME (hd asl)))(asl,gl)) THEN
     (NEW_MATCH_ACCEPT_TAC
       (UNDISCH_ALL (hd (IMP_CANON NORMAL_INTERSECTION)))));
    ((EXT_TAC "n:*") THEN BETA_TAC THEN GEN_TAC THEN 
     EQ_TAC THEN STRIP_TAC THEN
     (ASM_REWRITE_TAC[SET_PROD_DEF]) THEN BETA_TAC THEN
     (EXISTS_TAC "ID(H,prod):*") THEN
     (CONJ_TAC THENL
      [GROUP_ELT_TAC;(NEW_SUBST1_TAC(UNDISCH SBGP_ID_GP_ID))]) THEN
     (EXISTS_TAC "n:*") THEN
     (CONJ_TAC THENL
      [(FIRST_ASSUM ACCEPT_TAC);
       (RES_TAC THEN
        (ACCEPT_TAC (SYM (UNDISCH (SPEC "n:*" (CONJUNCT1
          (CONJUNCT2 (UNDISCH ID_LEMMA))))))))]))]);
  ALL_TAC]) THEN
 ((REV_SUPPOSE_TAC
    "SUBGROUP(set_prod(G,prod)H N,prod)(H:* -> bool)") THENL
  [((ASM_REWRITE_TAC[SUBGROUP_DEF]) THEN
    (ASM_REWRITE_TAC[SET_PROD_DEF]) THEN
    BETA_TAC THEN GEN_TAC THEN DISCH_TAC THEN
    (EXISTS_TAC "x:*") THEN
    (CONJ_TAC THENL
     [(FIRST_ASSUM ACCEPT_TAC);(EXISTS_TAC "ID(N,prod):*")]) THEN
    (CONJ_TAC THENL
     [GROUP_ELT_TAC;
      ((NEW_SUBST1_TAC (UNDISCH
        (STRONG_INST [("N:* -> bool","H:* -> bool")] SBGP_ID_GP_ID))) THEN
       RES_TAC THEN
       (ACCEPT_TAC (SYM (UNDISCH (SPEC "x:*" (CONJUNCT1 (CONJUNCT2
          (CONJUNCT2 (UNDISCH ID_LEMMA)))))))))]));
   ALL_TAC]) THEN
 (ASSUM_LIST \thl.STRIP_ASSUME_TAC (REWRITE_RULE thl
  (STRONG_INST [("set_prod(G,prod)H (N:* -> bool)","G:* -> bool")]
   NAT_HOM_THM))) THEN
 (ASSUM_LIST \thl.STRIP_ASSUME_TAC (REWRITE_RULE thl
  (STRONG_INST_TY_TERM
    (match "GP_HOM(G1,prod1)(G2,prod2)(f:* -> **)"
     "GP_HOM (set_prod(G,prod)(H:* -> bool) N,prod)
       (quot_set(set_prod(G,prod)H N,prod)N,
        quot_prod(set_prod(G,prod)H N,prod)N)
       (NAT_HOM(set_prod(G,prod)H N,prod)N)")
    GP_HOM_RES_TO_SBGP))) THEN
 (NEW_MATCH_ACCEPT_TAC
  ((STRONG_INST_TY_TERM
    (match "GP_HOM(G1:* -> bool,prod1)(G2:** -> bool,prod2)"
     "GP_HOM(H:* -> bool,prod)
       (quot_set(set_prod(G,prod)H N,prod)N,
        quot_prod(set_prod(G,prod)H N,prod)N)")
     FIRST_ISO_THM) and_then
   (REWRITE_RULE
    [(ASSUME "KERNEL(H:* -> bool,prod)
       (quot_set(set_prod(G,prod)H N,prod)N,
        quot_prod(set_prod(G,prod)H N,prod)N) f = \x.H x /\ N x");
     (ASSUME "IM (H:* -> bool) f = quot_set(set_prod(G,prod)H N,prod)N")])
   and_then UNDISCH and_then CONJUNCT1)) THEN
 (EXT_TAC "q:* -> bool") THEN GEN_TAC THEN EQ_TAC THENL
 [(DISCH_TAC THEN RES_TAC THEN
   (STRIP_ASSUME_TAC (PURE_REWRITE_RULE[NORMAL_DEF;SUBGROUP_DEF]
    (ASSUME "NORMAL(set_prod(G,prod)H N,prod)(N:* -> bool)"))) THEN
   (STRIP_ASSUME_TAC (UNDISCH (STRONG_INST
     [("set_prod(G,prod)H (N:* -> bool)","G:* -> bool")] GROUP_IS_SBGP))) THEN
   (NEW_SUBST1_TAC (SYM (UNDISCH_ALL (hd (IMP_CANON
     (STRONG_INST [("set_prod(G,prod)H (N:* -> bool)","G:* -> bool");
                   ("set_prod(G,prod)H (N:* -> bool)","H:* -> bool")]
      QUOTIENT_IM_LEMMA)))))) THEN
   (FIRST_ASSUM ACCEPT_TAC));
  ((ASM_REWRITE_TAC[IM_DEF;QUOTIENT_SET_DEF]) THEN BETA_TAC THEN
   DISCH_TAC THEN RES_TAC THEN
   (\ (asl,gl). (UNDISCH_TAC (hd asl) (asl,gl))) THEN STRIP_TAC THEN
   (ASSUM_LIST \thl. STRIP_ASSUME_TAC (REWRITE_RULE thl (BETA_RULE 
    (PURE_ONCE_REWRITE_RULE [SET_PROD_DEF]
      (ASSUME "set_prod(G,prod)H N (x:*)"))))) THEN
   (EXISTS_TAC "a:*") THEN
   (ASM_REWRITE_TAC[NAT_HOM_DEF]) THEN BETA_TAC THEN
   (CONV_TAC (DEPTH_CONV ETA_CONV)) THEN
   (FIRST_ASSUM \thm. STRIP_ASSUME_TAC
    (PURE_ONCE_REWRITE_RULE[thm] (ASSUME "set_prod(G,prod)H N (x:*)"))) THEN
   (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[NORMAL_DEF]
    (ASSUME "NORMAL(set_prod(G,prod)H N,prod)(N:* -> bool)"))) THEN
   (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[SUBGROUP_DEF]
    (ASSUME "SUBGROUP(set_prod(G,prod)H N,prod)(H:* -> bool)"))) THEN
   (STRIP_ASSUME_TAC (PURE_ONCE_REWRITE_RULE[SUBGROUP_DEF]
    (ASSUME "SUBGROUP(set_prod(G,prod)H N,prod)(N:* -> bool)"))) THEN
   (IMP_RES_TAC (ASSUME "!x:*. H x ==> set_prod(G,prod)H N x")) THEN
   (IMP_RES_TAC (ASSUME "!x:*. H x ==> set_prod(G,prod)H N x")) THEN
   (MATCH_MP_IMP_TAC
    (DISJ_IMP(PURE_ONCE_REWRITE_RULE[DISJ_SYM](UNDISCH_ALL(hd(IMP_CANON
      (CONJUNCT2(UNDISCH LEFT_COSET_DISJOINT_UNION)))))))) THEN
   STRIP_TAC THEN
   (NEW_SUBST1_TAC (SYM (BETA_RULE (AP_THM 
     (ASSUME "(\z:*. LEFT_COSET(set_prod(G,prod)H N,prod)N(prod a b)z /\
       LEFT_COSET(set_prod(G,prod)H N,prod)N a z) = (\z. F)")
      "(prod (a:*) (b:*)):*")))) THEN
   (CONJ_TAC THENL
    [(NEW_MATCH_ACCEPT_TAC (UNDISCH(SPEC_ALL(UNDISCH LEFT_COSETS_COVER))));
     ALL_TAC]) THEN
   (ASM_REWRITE_TAC[LEFT_COSET_DEF]) THEN
   (EXISTS_TAC "b:*") THEN (CONJ_TAC THENL
    [(FIRST_ASSUM ACCEPT_TAC);REFL_TAC]))]));;

%THIRD_ISO_THM = 
|- SUBGROUP(G,prod)H /\ NORMAL(G,prod)N ==>
   GP_ISO
   (quot_set(H,prod)(\x. H x /\ N x),quot_prod(H,prod)(\x. H x /\ N x))
   (quot_set(set_prod(G,prod)H N,prod)N,
    quot_prod(set_prod(G,prod)H N,prod)N)
   (quot_hom
    (H,prod)
    (quot_set(set_prod(G,prod)H N,prod)N,
     quot_prod(set_prod(G,prod)H N,prod)N)
    (\x. H x /\ N x)
    (NAT_HOM(set_prod(G,prod)H N,prod)N)) %


let CLASSICAL_THIRD_ISO_THM = prove_thm(`CLASSICAL_THIRD_ISO_THM`,
"SUBGROUP(G,prod)H /\ NORMAL(G,prod)(N:* -> bool) ==>
 ?f. GP_ISO
     (quot_set(H,prod)(\x.H x /\ N x),quot_prod(H,prod)(\x.H x /\ N x))
     (quot_set(set_prod(G,prod)H N,prod)N,quot_prod(set_prod(G,prod)H N,prod)N)
     f",
((REPEAT STRIP_TAC) THEN
 (EXISTS_TAC
  "quot_hom
   (H,prod)
   (quot_set(set_prod(G,prod)H N,prod)N,quot_prod(set_prod(G,prod)H N,prod)N)
   (\x:*.H x /\ N x)
   (NAT_HOM(set_prod(G,prod)H N,prod)N)") THEN
 (MP_IMP_TAC THIRD_ISO_THM) THEN (REDUCE_TAC [])));;

%CLASSICAL_THIRD_ISO_THM = 
|- SUBGROUP(G,prod)H /\ NORMAL(G,prod)N ==>
   (?f.
     GP_ISO
     (quot_set(H,prod)(\x. H x /\ N x),quot_prod(H,prod)(\x. H x /\ N x))
     (quot_set(set_prod(G,prod)H N,prod)N,
      quot_prod(set_prod(G,prod)H N,prod)N)
     f) %

% close_theory `more_gp`;;	`more_gp` changed to void. [TFM 90.06.06] %
close_theory();;



