(*<*) 
theory Semantica
  imports 
    Formulas
begin
(*>*)

section\<open>Semántica\<close>


text\<open>Definición de interpretación como una aplicación de los símbolos
  proposicionales (o átomos) en los valores de verdad\<close>

type_synonym 'a valuation = "'a \<Rightarrow> bool"

text\<open>The implicit statement here is that an assignment or valuation is
  always defined on all atoms (because HOL is a total logic).
  Thus, there are no unsuitable assignments.\<close>

text\<open>Definición: valor de una fórmula proposicional en una
  interpretación (la def. es por recursión en la estructura de la 
  fórmula)\<close>

primrec formula_semantics :: 
  "'a valuation \<Rightarrow> 'a formula \<Rightarrow> bool" (infix "\<Turnstile>" 51) where
  "\<A> \<Turnstile> Atom k = \<A> k" 
| "\<A> \<Turnstile> \<bottom> = False" 
| "\<A> \<Turnstile> Not F = (\<not> \<A> \<Turnstile> F)" 
| "\<A> \<Turnstile> And F G = (\<A> \<Turnstile> F \<and> \<A> \<Turnstile> G)" 
| "\<A> \<Turnstile> Or F G = (\<A> \<Turnstile> F \<or> \<A> \<Turnstile> G)" 
| "\<A> \<Turnstile> Imp F G = (\<A> \<Turnstile> F \<longrightarrow> \<A> \<Turnstile> G)"

thm formula_semantics.simps


text \<open>Definición de fórmula válida (o tautología).\<close>

abbreviation valid ("\<Turnstile> _" 51) where
  "\<Turnstile> F \<equiv> \<forall>A. A \<Turnstile> F"

text \<open>Lema: enunciar y hacer la demostración detallada.\<close>

find_theorems "_\<in>_ \<Longrightarrow> _ = _"

lemma irrelevant_atom_atomica:
  assumes "A \<notin> atoms (Atom x)" 
  shows "(\<A>(A := V)) \<Turnstile> (Atom x) \<longleftrightarrow> \<A> \<Turnstile> (Atom x)"
proof (rule iffI)
  assume "(\<A>(A := V)) \<Turnstile> (Atom x)"
  then have "(\<A>(A := V)) x" 
    by (simp only: formula_semantics.simps(1))
  then have 1:"if x = A then V else \<A> x"
    by (simp only: fun_upd_apply)
  have "x \<noteq> A" 
  proof (rule notI)
    assume "x = A"
    then have "A \<in> {x}" 
      by (simp only: singleton_iff)
    also have "\<dots> = atoms (Atom x)"
      by (simp only: formula.set(1))
    finally have 2:"A \<in> atoms (Atom x)"
      by (simp only: singleton_iff)
    show "False" using assms 2 
      by (rule notE)
  qed
  then have "\<A> x" using 1
    by (simp only: if_False)
  thus "\<A> \<Turnstile> (Atom x)" 
    by (simp only: formula_semantics.simps(1))
next
  assume "\<A> \<Turnstile> (Atom x)"
  then have "\<A> x" 
    by (simp only: formula_semantics.simps(1))
  then have "(\<A>(A := V)) x" using assms using [[simp_trace]]
    by simp (*Pendiente*)
  thus "(\<A>(A := V)) \<Turnstile> (Atom x)" 
    by (simp only: formula_semantics.simps(1))
qed

lemma irrelevant_atom_bot:
  assumes "A \<notin> atoms \<bottom>" 
  shows "(\<A>(A := V)) \<Turnstile> \<bottom> \<longleftrightarrow> \<A> \<Turnstile> \<bottom>"
proof (rule iffI)
  assume "(\<A>(A := V)) \<Turnstile> \<bottom>"
  thus "\<A> \<Turnstile> \<bottom>" 
    by (simp only: formula_semantics.simps(2))
next
  assume "\<A> \<Turnstile> \<bottom>"
  thus "(\<A>(A := V)) \<Turnstile> \<bottom>" 
    by (simp only: formula_semantics.simps(2))
qed

(*lemma irrelevant_atom_not:
  assumes "A \<notin> atoms (\<^bold>\<not> F)" 
  shows "(\<A>(A := V)) \<Turnstile> (\<^bold>\<not> F) \<longleftrightarrow> \<A> \<Turnstile> (\<^bold>\<not> F)"
proof (rule iffI)
  assume "(\<A>(A := V)) \<Turnstile> (\<^bold>\<not> F)"
  then have "if \<A> \<Turnstile> F then V else \<not> \<A> \<Turnstile> F" 
    by simp
  thus "\<A> \<Turnstile> \<^bold>\<not> F" 
    by (simp only: formula_semantics.simps(3))
next
  assume "\<A> \<Turnstile> \<^bold>\<not> F"
  then have "\<not> \<A> \<Turnstile> F" 
    by simp
  then have "\<not> (\<A>(A := V))  \<Turnstile> F"
    by simp
  thus "(\<A>(A := V)) \<Turnstile> (\<^bold>\<not> F)" 
    by (simp only: formula_semantics.simps(3))
qed*)

lemma irrelevant_atom: 
   "A \<notin> atoms F \<Longrightarrow> (\<A>(A := V)) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
  by (induction F; simp)

text\<open>Lema: enunciar y hacer la demostración detallada.\<close>

lemma relevant_atoms_same_semantics: 
   "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
  by (induction F; simp)


text \<open>Definición: consecuencia lógica.\<close>

definition entailment :: 
  "'a formula set \<Rightarrow> 'a formula \<Rightarrow> bool" ("(_ \<TTurnstile>/ _)" 
    (* \TTurnstile *) [53,53] 53) where
  "\<Gamma> \<TTurnstile> F \<equiv> (\<forall>\<A>. ((\<forall>G \<in> \<Gamma>. \<A> \<Turnstile> G) \<longrightarrow> (\<A> \<Turnstile> F)))"

text \<open>We write entailment differently than semantics (\<open>\<Turnstile>\<close> vs. \<open>\<TTurnstile>\<close>).
  For humans, it is usually pretty clear what is meant in a specific
  situation, but it often needs to be decided from context that
  Isabelle/HOL does not have.\<close> 
  
text \<open>Some helpers for the derived connectives\<close>

text \<open>Lemas: enunciar y demostrar detalladamente.\<close>

(*lemma "A \<Turnstile> \<top>" 
proof -
  show "A \<Turnstile> \<bottom> \<^bold>\<rightarrow> \<bottom>" unfolding Top_def *)


   

lemma top_semantics: 
  "A \<Turnstile> \<top>" 
  unfolding Top_def 
  by simp

lemma BigAnd_semantics: 
  "A \<Turnstile> \<^bold>\<And>F \<longleftrightarrow> (\<forall>f \<in> set F. A \<Turnstile> f)"
  by (induction F; simp)

lemma BigOr_semantics: 
  "A \<Turnstile> \<^bold>\<Or>F \<longleftrightarrow> (\<exists>f \<in> set F. A \<Turnstile> f)" 
  by (induction F; simp)
    
text \<open>Definitions for sets of formulae, used for compactness and model 
  existence.\<close>

text\<open> Definición: conjunto de fórmulas consistente.\<close>

definition "sat S \<equiv> \<exists>\<A>. \<forall>F \<in> S. \<A> \<Turnstile> F"

text \<open>Definición: conjunto de fórmulas finitamente consistente.\<close>

definition "fin_sat S \<equiv> (\<forall>s \<subseteq> S. finite s \<longrightarrow> sat s)"

text \<open>Lema: un conjunto de fórmulas S es inconsistente si y sólo si
 \<bottom> es consecuencia lógica de S.\<close>

lemma entail_sat: 
  "\<Gamma> \<TTurnstile> \<bottom> \<longleftrightarrow> \<not> sat \<Gamma>" 
  unfolding sat_def entailment_def 
  by simp

(*<*)
end
(*>*) 