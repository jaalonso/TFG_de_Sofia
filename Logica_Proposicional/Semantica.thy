(*<*) 
theory Semantica
  imports 
    Sintaxis
begin
(*>*)

section \<open>Semántica\<close>

text \<open>En esta sección presentaremos la semántica de las fórmulas
  proposicionales y su formalización en Isabelle/HOL. 

  \begin{definicion}
  Una interpretación es una aplicación del conjunto de variables
  proposicionales en el conjunto \<open>\<BB>\<close> de los booleanos.
  \end{definicion}

  De este modo, las interpretaciones asignan valores de verdad a las 
  variables proposicionales.

  En Isabelle, se formaliza como sigue.\<close> 

type_synonym 'a valuation = "'a \<Rightarrow> bool"

  text \<open>Como podemos observar, \<open>'a valuation\<close> representa
  una función entre elementos de tipo \<open>'a\<close> cualquiera que conforman los
  átomos de una fórmula proposicional a los que les asigna un booleano. 
  Se define mediante el tipo \<open>type_synonym\<close>, pues consiste en renombrar 
  una construcción ya existente en Isabelle.

  Dada una interpretación, vamos a definir el valor de verdad de una 
  fórmula proposicional en dicha interpretación.

  \begin{definicion}
  Para cada interpretación \<open>\<A>\<close> existe una única aplicación \<open>\<I>\<^sub>\<A>\<close> desde 
  el conjunto de fórmulas al conjunto \<open>\<BB>\<close> de los booleanos definida 
  recursivamente sobre la estructura de las fórmulas como sigue:\\
  Sea \<open>F\<close> una fórmula cualquiera,
    \begin{itemize}
      \item Si \<open>F\<close> es una fórmula atómica de la forma \<open>p\<close>, entonces \\ 
        \<open>\<I>\<^sub>\<A>(F) = \<A>(p)\<close>.
      \item Si \<open>F\<close> es la fórmula \<open>\<bottom>\<close>, entonces \<open>\<I>\<^sub>\<A>(F) = False\<close>.
      \item Si \<open>F\<close> es de la forma \<open>\<not> G\<close> para cierta fórmula \<open>G\<close>, 
        entonces\\ \<open>\<I>\<^sub>\<A>(F) = \<not> \<I>\<^sub>\<A>(G)\<close>.
      \item Si \<open>F\<close> es de la forma \<open>G \<and> H\<close> para ciertas fórmulas \<open>G\<close> y 
        \<open>H\<close>, entonces\\ \<open>\<I>\<^sub>\<A>(F)= \<I>\<^sub>\<A>(G) \<and> \<I>\<^sub>\<A>(H)\<close>.
      \item Si \<open>F\<close> es de la forma \<open>G \<or> H\<close> para ciertas fórmulas \<open>G\<close> y 
        \<open>H\<close>, entonces\\ \<open>\<I>\<^sub>\<A>(F)= \<I>\<^sub>\<A>(G) \<or> \<I>\<^sub>\<A>(H)\<close>.
      \item Si \<open>F\<close> es de la forma \<open>G \<longrightarrow> H\<close> para ciertas fórmulas \<open>G\<close> y 
        \<open>H\<close>, entonces\\ \<open>\<I>\<^sub>\<A>(F)= \<I>\<^sub>\<A>(G) \<longrightarrow> \<I>\<^sub>\<A>(H)\<close>.
    \end{itemize}
  En estas condiciones se dice que \<open>\<I>\<^sub>\<A>(F)\<close> es el valor de la fórmula 
  \<open>F\<close> en la interpretación \<open>\<A>\<close>.
  \end{definicion}

  En Isabelle, dada una interpretación \<open>\<A>\<close> y una fórmula \<open>F\<close>, vamos a 
  definir \<open>\<I>\<^sub>\<A>(F)\<close> mediante la función \<open>formula_semantics \<A> F\<close>, 
  notado como \<open>\<A> \<Turnstile> F\<close>.\<close>

primrec formula_semantics :: 
  "'a valuation \<Rightarrow> 'a formula \<Rightarrow> bool" (infix "\<Turnstile>" 51) where
  "\<A> \<Turnstile> Atom k = \<A> k" 
| "\<A> \<Turnstile> \<bottom> = False" 
| "\<A> \<Turnstile> Not F = (\<not> \<A> \<Turnstile> F)" 
| "\<A> \<Turnstile> And F G = (\<A> \<Turnstile> F \<and> \<A> \<Turnstile> G)" 
| "\<A> \<Turnstile> Or F G = (\<A> \<Turnstile> F \<or> \<A> \<Turnstile> G)" 
| "\<A> \<Turnstile> Imp F G = (\<A> \<Turnstile> F \<longrightarrow> \<A> \<Turnstile> G)"

text \<open>Como podemos observar, \<open>formula_semantics\<close> es una función
  primitiva recursiva, como indica el tipo \<open>primrec\<close>, notada con el 
  símbolo infijo \<open>\<Turnstile>\<close>. De este modo, dada una interpretación \<open>\<A>\<close> sobre 
  variables proposicionales de un tipo \<open>'a\<close> cualquiera y una fórmula,
  se define el valor de la fórmula en la interpretación \<open>\<A>\<close> como se 
  muestra. Veamos algunos ejemplos.\<close>

notepad
begin
  fix \<A> :: "nat valuation"

have "(\<A> (1 := True, 2 := False, 3 := True) 
            \<Turnstile> (\<^bold>\<not> ((Atom 1 \<^bold>\<or> Atom 2)) \<^bold>\<rightarrow> Atom 3)) = True" 
  by simp
  
  have "(\<A> (1 := True) \<Turnstile> Atom 1) = True"
    by simp

  have "(\<A> (1 := True) \<Turnstile> \<^bold>\<not> (Atom 1)) = False"
    by simp

  have "(\<A> (1 := True, 2 := False) \<Turnstile> \<^bold>\<not> (Atom 1) \<^bold>\<and> (Atom 2)) = False"
    by simp

  have "(\<A> (1 := True, 2 := False, 3 := False) 
            \<Turnstile> (\<^bold>\<not> ((Atom 1 \<^bold>\<and> Atom 2)) \<^bold>\<rightarrow> Atom 3)) = False" 
    by simp

end

(*He encontrado una fórmula que con esa interpretación Isabelle 
  encuentra contraejemplo tanto para Verdadero como Falso:

  have "(\<A> (p := True, q := False, r := False) 
            \<Turnstile> (\<^bold>\<not> ((Atom p \<^bold>\<or> Atom q)) \<^bold>\<rightarrow> Atom r)) = False"
    by simp

DUDA *)

text \<open>En los ejemplos anteriores se ha usado la notación para
  funciones\\ \<open>f (a := b)\<close>. Dicha notación abreviada se corresponde con 
  la definción de \<open>fun_upd f a b\<close>.

  \begin{itemize}
    \item[] @{thm[mode=Def] fun_upd_def} 
      \hfill (@{text fun_upd_def})
  \end{itemize}

  Es decir, \<open>f (a:=b)\<close> es la función que para cualquier valor \<open>x\<close> del 
  dominio, si \<open>x = a\<close>, entonces devuelve \<open>b\<close>. En caso contrario, 
  devuelve el valor \<open>f x\<close>.

  A continuación veamos una serie de definiciones sobre fórmulas e 
  interpretaciones, en primer lugar, la noción de modelo de una 
  fórmula.

  \begin{definicion}
  Una interpretación \<open>\<A>\<close> es modelo de una fórmula \<open>F\<close> si\\
  \<open>\<I>\<^sub>\<A>(F) = True\<close>. 
  \end{definicion}

  En Isabelle se formaliza de la siguiente manera.\<close>

definition "isModel \<A> F \<equiv> \<A> \<Turnstile> F"

text \<open>Veamos cuáles de las interpretaciones de los ejemplos anteriores
  son modelos de las fórmulas dadas.\<close>

notepad
begin
  fix p q r :: 'a

  have "isModel (\<A> (p := True)) (Atom p)"
    by (simp add: isModel_def)

  have "\<not> isModel (\<A> (p := True)) (\<^bold>\<not> (Atom p))"
    by (simp add: isModel_def)

  have "\<not> isModel (\<A> (p := True, q := False)) (\<^bold>\<not> (Atom p) \<^bold>\<and> (Atom q))"
    by (simp add: isModel_def)

  have "\<not> isModel (\<A> (p := True, q := False, r := False)) 
          (\<^bold>\<not> ((Atom p \<^bold>\<and> Atom q)) \<^bold>\<rightarrow> Atom r)"
    by (simp add: isModel_def)

  have "isModel (\<A> (p := True, q := False, r := True)) 
          (\<^bold>\<not> ((Atom p \<^bold>\<or> Atom q)) \<^bold>\<rightarrow> Atom r)"
    by (simp add: isModel_def)

end

text \<open>Demos ahora la noción de fórmula satisfacible.

  \begin{definicion}
    Una fórmula es satisfacible si tiene algún modelo.
  \end{definicion}

  Se concreta en Isabelle como sigue.\<close>

definition "satF(F) \<equiv> \<exists>\<A>. \<A> \<Turnstile> F"

text \<open>Mostremos ejemplos de fórmulas satisfacibles y no satisfacibles.
  Estas últimas son también llamadas contradicciones, pues son
  falsas para cualquier interpretación.\<close>

notepad
begin
  fix p :: 'a

  have "satF (Atom p)"
    by (meson formula_semantics.simps(1) satF_def)

  have "satF (Atom p \<^bold>\<and> Atom q)" 
    using satF_def by force

  have "\<not> satF (Atom p \<^bold>\<and> (\<^bold>\<not> (Atom p)))"
    using satF_def by force

end

text \<open>Por último, extendamos la noción de modelo a un conjunto de 
  fórmulas.

  \begin{definicion}
  Una interpretación es modelo de un conjunto de fórmulas si es modelo
  de todas las fórmulas del conjunto.
  \end{definicion}

  Su formalización en Isabelle es la siguiente.\<close>

definition "isModelSet \<A> S \<equiv> \<forall>F. (F\<in> S \<longrightarrow> \<A> \<Turnstile> F)"

text \<open>Continuando con los ejemplos anteriores, veamos una interpretación
  que es modelo de un conjunto de fórmulas.\<close>

notepad
begin
  fix p :: 'a

  have "isModelSet (\<A> (p := True))
     {Atom p, (Atom p \<^bold>\<and> Atom p) \<^bold>\<rightarrow> Atom p}"
    by (simp add: isModelSet_def)

end

(*Sale un contraejemplo que no entiendo:
  have "isModelSet (\<A> (p := True, q := False, r := True))
     {Atom p, (\<^bold>\<not> ((Atom p \<^bold>\<or> Atom q)) \<^bold>\<rightarrow> Atom r)}" 

DUDA *)

text \<open>Como podemos observar, \<open>isModel\<close>, \<open>satF\<close> y \<open>inModelSet\<close> se han 
  formalizado usando el tipo \<open>definition\<close> ...

  \comentario{Completar comentario respecto al tipo.}

  A continuación vamos a dar un resultado que relaciona los conceptos de 
  ser modelo de una fórmula y de un conjunto de fórmulas en Isabelle.
  La equivalencia se demostrará fácilmente mediante las definiciones
  de\\ \<open>isModel\<close> e \<open>isModelSet\<close>.\<close>

lemma modelSet:
  "isModelSet A S \<equiv> \<forall>F. (F\<in> S \<longrightarrow> isModel A F)" 
  by (simp only: isModelSet_def isModel_def)

text \<open>Continuemos con la noción de fórmula válida o tautología.

  \begin{definicion} 
  \<open>F\<close> es una fórmula válida o tautología (\<open>\<Turnstile> F\<close>) si toda interpretación 
  es modelo de \<open>F\<close>, es decir, dada cualquier interpretación \<open>\<A>\<close> se 
  tiene \<open>\<I>\<^sub>\<A>(F) = True\<close>. 
  \end{definicion}

  Es decir, una tautología es una fórmula que es verdadera para 
  cualquier interpretación.

  En Isabelle se formaliza de la siguiente manera.\<close>

abbreviation valid ("\<Turnstile> _" 51) where
  "\<Turnstile> F \<equiv> \<forall>A. A \<Turnstile> F"

text \<open>Podemos observar que se ha definido mediante el tipo 
  \<open>abbreviation\<close>..

  \comentario{Terminar de comentar el tipo.}

  Veamos un ejemplo clásico de tautología: el principio del tercio
  excluso.\<close>

notepad
begin
  fix p :: 'a

  have "\<Turnstile> (Atom p \<^bold>\<or> (\<^bold>\<not> (Atom p)))"
    by simp

end

text \<open>Mostremos el primer lema de la sección.

  \begin{lema}
  Dadas una interpretación \<open>\<A>\<close> y una fórmula \<open>F\<close> de modo que \<open>A\<close>
  es una variable proposicional que no pertenece al conjunto de átomos
  de \<open>F\<close>. Sea la interpretación \<open>\<A>'\<close> la función que devuelve \<open>\<A>(q)\<close>
  para cualquier variable proposicional \<open>q\<close> distinta de \<open>A\<close>, y \<open>V\<close> en 
  caso contrario.

  Entonces, el valor de la fórmula \<open>F\<close> es el mismo para las 
  interpretaciones \<open>\<A>\<close> y \<open>\<A>'\<close>.
  \end{lema}

  \begin{demostracion}
  Vamos a probar el resultado por inducción en la estructura recursiva
  de las fórmulas. De este modo, demostremos los siguientes casos.

  Sea \<open>p\<close> una fórmula atómica cualquiera tal que \<open>A\<close> no pertenece
  al conjunto de sus átomos \<open>{p}\<close>. De este modo, se tiene \<open>p \<noteq> A\<close>. 
  Por definición, el valor de la fórmula atómica \<open>p\<close> dada la 
  interpretación \<open>\<A>'\<close>, es \<open>\<A>'(p)\<close>. Como hemos visto que \<open>p \<noteq> A\<close>, 
  tenemos a su vez \<open>\<A>'(p) = \<A>(p)\<close> según la definición de \<open>\<A>'\<close>. A su
  vez, \<open>\<A>(p)\<close> es el valor de la fórmula atómica \<open>p\<close> dada la 
  interpretación \<open>\<A>\<close>, luego se tiene finalmente que ambos valores
  coinciden. 

  Sea la fórmula \<open>\<bottom>\<close>. Por definición, el valor de dicha fórmula es 
  \<open>Falso\<close> dada cualquier interpretación, luego se verifica el
  resultado en particular.

  Sea \<open>F\<close> una fórmula tal que para cualquier variable que no pertenezca
  al conjunto de sus átomos, entonces el valor de \<open>F\<close> dada la 
  interpretación \<open>\<A>\<close> coincide con su valor dada la interpretación \<open>\<A>'\<close> 
  construida como se indica en el enunciado. Vamos a demostrar el 
  resultado para la fórmula \<open>\<not> F\<close> considerando una variable \<open>A\<close> 
  cualquiera que no pertenezca al conjunto de átomos de \<open>\<not> F\<close>. Como 
  los conjuntos de átomos de \<open>F\<close> y \<open>\<not> F\<close> son el mismo, entonces \<open>A\<close> 
  tampoco pertenece al conjunto de átomos de \<open>F\<close>. De este modo, por 
  hipótesis de inducción, el valor de la fórmula \<open>F\<close> dada la 
  interpretación \<open>\<A>\<close> coincide con su valor dada la interpretación 
  \<open>\<A>'\<close>. Por otro lado, por definición, tenemos que el valor de la 
  fórmula \<open>\<not> F\<close> dada \<open>\<A>\<close> es \<open>\<not> \<I>\<^sub>\<A>(F)\<close>. Por lo visto anteriormente,
  esto es igual a \<open>\<not> \<I>\<^sub>\<A>\<^sub>'(F)\<close> que, por definición, es igual al valor 
  de \<open>\<not> F\<close> dada \<open>\<A>'\<close>, como quería demostrar.
  \end{demostracion}

  \comentario{Terminar demostracion a mano.}\<close>

lemma "A \<notin> atoms F \<Longrightarrow> (\<A>(A := V)) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
  oops

lemma irrelevant_atom_atomic_l1:
  assumes "A \<notin> atoms (Atom x)" 
  shows "x \<noteq> A"
proof (rule notI)
  assume "x = A"
  then have "A \<in> {x}" 
    by (simp only: singleton_iff)
  also have "\<dots> = atoms (Atom x)"
    by (simp only: formula.set(1))
  finally have "A \<in> atoms (Atom x)"
    by this 
  with assms show "False"  
    by (rule notE)
qed

lemma irrelevant_atom_atomic:
  assumes "A \<notin> atoms (Atom x)" 
  shows "(\<A>(A := V)) \<Turnstile> (Atom x) \<longleftrightarrow> \<A> \<Turnstile> (Atom x)"
proof -
  have "x \<noteq> A"
    using assms
    by (rule irrelevant_atom_atomic_l1)
  have "(\<A>(A := V)) \<Turnstile> (Atom x) = (\<A>(A := V)) x"
    by (simp only: formula_semantics.simps(1))
  also have "\<dots> = \<A> x"
    using \<open>x \<noteq> A\<close>
    by (rule fun_upd_other)
  also have "\<dots> = \<A> \<Turnstile> (Atom x)"
    by (simp only: formula_semantics.simps(1))
  finally show ?thesis
    by this
qed

lemma irrelevant_atom_bot:
  assumes "A \<notin> atoms \<bottom>" 
  shows "(\<A>(A := V)) \<Turnstile> \<bottom> \<longleftrightarrow> \<A> \<Turnstile> \<bottom>"
  by (simp only: formula_semantics.simps(2))

lemma irrelevant_atom_not_l1:
  assumes "A \<notin> atoms (\<^bold>\<not> F)"
  shows   "A \<notin> atoms F"
proof
  assume "A \<in> atoms F"
  then have "A \<in> atoms (\<^bold>\<not> F)"
    by (simp only: formula.set(3)) 
  with assms show False
    by (rule notE)
qed

lemma irrelevant_atom_not:
  assumes "A \<notin> atoms F \<Longrightarrow> \<A>(A := V) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
          "A \<notin> atoms (\<^bold>\<not> F)"
 shows "\<A>(A := V) \<Turnstile> \<^bold>\<not> F \<longleftrightarrow> \<A> \<Turnstile> \<^bold>\<not> F"
proof -
  have "A \<notin> atoms F"
    using assms(2) by (rule irrelevant_atom_not_l1)
  then have "\<A>(A := V) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
    by (rule assms(1))
  have "\<A>(A := V) \<Turnstile> \<^bold>\<not> F = (\<not> \<A>(A := V) \<Turnstile> F)"
    by (simp only: formula_semantics.simps(3))
  also have "\<dots> = (\<not> \<A> \<Turnstile> F)"
    by (simp only: \<open>\<A>(A := V) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F\<close>)
  also have "\<dots> = \<A> \<Turnstile> \<^bold>\<not> F"
    by (simp only: formula_semantics.simps(3))
  finally show "\<A>(A := V) \<Turnstile> \<^bold>\<not> F \<longleftrightarrow> \<A> \<Turnstile> \<^bold>\<not> F"
    by this
qed

lemma irrelevant_atom_and_l1:
  assumes "A \<notin> atoms (F \<^bold>\<and> G)"
  shows   "A \<notin> atoms F"
proof 
  assume "A \<in> atoms F"
  then have "A \<in> atoms F \<union> atoms G"
    by (rule UnI1)
  then have "A \<in> atoms (F \<^bold>\<and> G)"
    by (simp only: formula.set(4))
  with assms show False 
    by (rule notE)
qed

lemma irrelevant_atom_and_l2:
  assumes "A \<notin> atoms (F \<^bold>\<and> G)"
  shows   "A \<notin> atoms G"
proof 
  assume "A \<in> atoms G"
  then have "A \<in> atoms F \<union> atoms G"
    by (rule UnI2)
  then have "A \<in> atoms (F \<^bold>\<and> G)"
    by (simp only: formula.set(4))
  with assms show False 
    by (rule notE)
qed

lemma irrelevant_atom_and:
  assumes "A \<notin> atoms F \<Longrightarrow> \<A>(A := V) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
          "A \<notin> atoms G \<Longrightarrow> \<A>(A := V) \<Turnstile> G \<longleftrightarrow> \<A> \<Turnstile> G"
          "A \<notin> atoms (F \<^bold>\<and> G)"
  shows "\<A>(A := V) \<Turnstile> (F \<^bold>\<and> G) \<longleftrightarrow> \<A> \<Turnstile> (F \<^bold>\<and> G)"
proof -
  have "A \<notin> atoms F"
    using assms(3)
    by (rule irrelevant_atom_and_l1)
  then have HF: "\<A>(A := V) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
    by (rule assms(1))
  have "A \<notin> atoms G"
    using assms(3)
    by (rule irrelevant_atom_and_l2)
  then have HG: "\<A>(A := V) \<Turnstile> G \<longleftrightarrow> \<A> \<Turnstile> G"
    by (rule assms(2))
  have "\<A>(A := V) \<Turnstile> (F \<^bold>\<and> G) = (\<A>(A := V) \<Turnstile> F \<and> \<A>(A := V) \<Turnstile> G)"
    by (simp only: formula_semantics.simps(4))
  also have "\<dots> = (\<A> \<Turnstile> F \<and> \<A> \<Turnstile> G)"
    by (simp only: HF HG)
  also have "\<dots> = \<A> \<Turnstile> (F \<^bold>\<and> G)"
    by (simp only: formula_semantics.simps(4))
  finally show "\<A>(A := V) \<Turnstile> (F \<^bold>\<and> G) \<longleftrightarrow> \<A> \<Turnstile> (F \<^bold>\<and> G)"
    by this
qed

lemma irrelevant_atom_or_l1:
  assumes "A \<notin> atoms (F \<^bold>\<or> G)"
  shows   "A \<notin> atoms F"
proof 
  assume "A \<in> atoms F"
  then have "A \<in> atoms F \<union> atoms G"
    by (rule UnI1)
  then have "A \<in> atoms (F \<^bold>\<or> G)"
    by (simp only: formula.set(5))
  with assms show False 
    by (rule notE)
qed

lemma irrelevant_atom_or_l2:
  assumes "A \<notin> atoms (F \<^bold>\<or> G)"
  shows   "A \<notin> atoms G"
proof 
  assume "A \<in> atoms G"
  then have "A \<in> atoms F \<union> atoms G"
    by (rule UnI2)
  then have "A \<in> atoms (F \<^bold>\<or> G)"
    by (simp only: formula.set(5))
  with assms show False 
    by (rule notE)
qed

lemma irrelevant_atom_or:
  assumes "A \<notin> atoms F \<Longrightarrow> \<A>(A := V) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
          "A \<notin> atoms G \<Longrightarrow> \<A>(A := V) \<Turnstile> G \<longleftrightarrow> \<A> \<Turnstile> G"
          "A \<notin> atoms (F \<^bold>\<or> G)"
  shows   "\<A>(A := V) \<Turnstile> (F \<^bold>\<or> G) \<longleftrightarrow> \<A> \<Turnstile> (F \<^bold>\<or> G)"
proof -
  have "A \<notin> atoms F"
    using assms(3)
    by (rule irrelevant_atom_or_l1)
  then have HF: "\<A>(A := V) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
    by (rule assms(1))
  have "A \<notin> atoms G"
    using assms(3)
    by (rule irrelevant_atom_or_l2)
  then have HG: "\<A>(A := V) \<Turnstile> G \<longleftrightarrow> \<A> \<Turnstile> G"
    by (rule assms(2))
  have "\<A>(A := V) \<Turnstile> (F \<^bold>\<or> G) = (\<A>(A := V) \<Turnstile> F \<or> \<A>(A := V) \<Turnstile> G)"
    by (simp only: formula_semantics.simps(5))
  also have "\<dots> = (\<A> \<Turnstile> F \<or> \<A> \<Turnstile> G)"
    by (simp only: HF HG)
  also have "\<dots> = \<A> \<Turnstile> (F \<^bold>\<or> G)"
    by (simp only: formula_semantics.simps(5))
  finally show "\<A>(A := V) \<Turnstile> (F \<^bold>\<or> G) \<longleftrightarrow> \<A> \<Turnstile> (F \<^bold>\<or> G)"
    by this
qed

lemma irrelevant_atom_imp_l1:
  assumes "A \<notin> atoms (F \<^bold>\<rightarrow> G)"
  shows   "A \<notin> atoms F"
proof 
  assume "A \<in> atoms F"
  then have "A \<in> atoms F \<union> atoms G"
    by (rule UnI1)
  then have "A \<in> atoms (F \<^bold>\<rightarrow> G)"
    by (simp only: formula.set(6))
  with assms show False 
    by (rule notE)
qed

lemma irrelevant_atom_imp_l2:
  assumes "A \<notin> atoms (F \<^bold>\<rightarrow> G)"
  shows   "A \<notin> atoms G"
proof 
  assume "A \<in> atoms G"
  then have "A \<in> atoms F \<union> atoms G"
    by (rule UnI2)
  then have "A \<in> atoms (F \<^bold>\<rightarrow> G)"
    by (simp only: formula.set(6))
  with assms show False 
    by (rule notE)
qed

lemma irrelevant_atom_imp:
  assumes "A \<notin> atoms F \<Longrightarrow> \<A>(A := V) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
          "A \<notin> atoms G \<Longrightarrow> \<A>(A := V) \<Turnstile> G \<longleftrightarrow> \<A> \<Turnstile> G"
          "A \<notin> atoms (F \<^bold>\<rightarrow> G)"
  shows "\<A>(A := V) \<Turnstile> (F \<^bold>\<rightarrow> G) \<longleftrightarrow> \<A> \<Turnstile> (F \<^bold>\<rightarrow> G)"
proof -
  have "A \<notin> atoms F"
    using assms(3)
    by (rule irrelevant_atom_imp_l1)
  then have HF: "\<A>(A := V) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
    by (rule assms(1))
  have "A \<notin> atoms G"
    using assms(3)
    by (rule irrelevant_atom_imp_l2)
  then have HG: "\<A>(A := V) \<Turnstile> G \<longleftrightarrow> \<A> \<Turnstile> G"
    by (rule assms(2))
  have "\<A>(A := V) \<Turnstile> (F \<^bold>\<rightarrow> G) = (\<A>(A := V) \<Turnstile> F \<longrightarrow> \<A>(A := V) \<Turnstile> G)"
    by (simp only: formula_semantics.simps(6))
  also have "\<dots> = (\<A> \<Turnstile> F \<longrightarrow> \<A> \<Turnstile> G)"
    by (simp only: HF HG)
  also have "\<dots> = \<A> \<Turnstile> (F \<^bold>\<rightarrow> G)"
    by (simp only: formula_semantics.simps(6))
  finally show "\<A>(A := V) \<Turnstile> (F \<^bold>\<rightarrow> G) \<longleftrightarrow> \<A> \<Turnstile> (F \<^bold>\<rightarrow> G)"
    by this
qed

lemma "A \<notin> atoms F \<Longrightarrow> (\<A>(A := V)) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
proof (induction F)
  case (Atom x)
  then show ?case by (rule irrelevant_atom_atomic)
next
  case Bot
  then show ?case by (rule irrelevant_atom_bot)
next
  case (Not F)
  then show ?case by (rule irrelevant_atom_not)
next
  case (And F1 F2)
  then show ?case by (rule irrelevant_atom_and)
next
  case (Or F1 F2)
  then show ?case by (rule irrelevant_atom_or)
next
  case (Imp F1 F2)
  then show ?case by (rule irrelevant_atom_imp)
qed

lemma irrelevant_atom: 
  "A \<notin> atoms F \<Longrightarrow> (\<A>(A := V)) \<Turnstile> F \<longleftrightarrow> \<A> \<Turnstile> F"
  by (induction F) simp_all

text \<open>Lema: enunciar y hacer la demostración detallada.\<close>

lemma relevant_atoms_same_semantics_atomic_l1:
  "x \<in> atoms (Atom x)"
proof 
  show "x \<in> {x}"
    by (simp only: singleton_iff)
next
  show "{x} \<subseteq> atoms (Atom x)"
    by (simp only: formula.set(1))
qed

lemma relevant_atoms_same_semantics_atomic: 
  assumes "\<forall>k \<in> atoms (Atom x). \<A>\<^sub>1 k = \<A>\<^sub>2 k"
  shows   "\<A>\<^sub>1 \<Turnstile> Atom x \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> Atom x"
proof -
  have "\<A>\<^sub>1 \<Turnstile> Atom x = \<A>\<^sub>1 x"
    by (simp only: formula_semantics.simps(1))
  also have "\<dots> = \<A>\<^sub>2 x"
    using  assms(1)
    by (simp only: relevant_atoms_same_semantics_atomic_l1)
  also have "\<dots> = \<A>\<^sub>2 \<Turnstile> Atom x"
    by (simp only: formula_semantics.simps(1))
  finally show ?thesis
    by this
qed

lemma relevant_atoms_same_semantics_bot: 
  assumes "\<forall>k \<in> atoms \<bottom>. \<A>\<^sub>1 k = \<A>\<^sub>2 k"
  shows "\<A>\<^sub>1 \<Turnstile> \<bottom> \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> \<bottom>"
  by (simp only: formula_semantics.simps(2))

lemma relevant_atoms_same_semantics_not: 
  assumes "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
          "\<forall>k \<in> atoms (\<^bold>\<not> F). \<A>\<^sub>1 k = \<A>\<^sub>2 k"
        shows "\<A>\<^sub>1 \<Turnstile> (\<^bold>\<not> F) \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> (\<^bold>\<not> F)"
proof -
  have "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k" using assms(2)
    by (simp only: formula.set(3))
  then have H:"\<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
    by (simp only: assms(1))
  have "\<A>\<^sub>1 \<Turnstile> (\<^bold>\<not> F) = (\<not> \<A>\<^sub>1 \<Turnstile> F)"
    by (simp only: formula_semantics.simps(3))
  also have "\<dots> = (\<not> \<A>\<^sub>2 \<Turnstile> F)"
    using H by (rule arg_cong)
  also have "\<dots> = \<A>\<^sub>2 \<Turnstile> (\<^bold>\<not> F)"
    by (simp only: formula_semantics.simps(3))
  finally show ?thesis
    by this
qed

lemma forall_union1: 
  assumes "\<forall>x \<in> A \<union> B. P x"
  shows "\<forall>x \<in> A. P x"
proof (rule ballI)
  fix x
  assume "x \<in> A"
  then have "x \<in> A \<union> B" 
    by (simp only: UnI1)
  then show "P x" 
    by (simp only: assms)
qed

lemma forall_union2:
  assumes "\<forall>x \<in> A \<union> B. P x"
  shows "\<forall>x \<in> B. P x"
proof (rule ballI)
  fix x
  assume "x \<in> B"
  then have "x \<in> A \<union> B" 
    by (simp only: UnI2)
  then show "P x" 
    by (simp only: assms)
qed

lemma relevant_atoms_same_semantics_and: 
  assumes "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
          "\<forall>k \<in> atoms G. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> G \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> G"
          "\<forall>k \<in> atoms (F \<^bold>\<and> G). \<A>\<^sub>1 k = \<A>\<^sub>2 k"
        shows "\<A>\<^sub>1 \<Turnstile> (F \<^bold>\<and> G) \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> (F \<^bold>\<and> G)"
proof -
  have H:"\<forall>k \<in> atoms F \<union> atoms G. \<A>\<^sub>1 k = \<A>\<^sub>2 k" using assms(3)
    by (simp only: formula.set(4))
  then have "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k"
    by (rule forall_union1)
  then have H1:"\<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
    by (simp only: assms(1))
  have "\<forall>k \<in> atoms G. \<A>\<^sub>1 k = \<A>\<^sub>2 k"
    using H by (rule forall_union2)
  then have H2:"\<A>\<^sub>1 \<Turnstile> G \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> G"
    by (simp only: assms(2))
  have "\<A>\<^sub>1 \<Turnstile> F \<^bold>\<and> G = (\<A>\<^sub>1 \<Turnstile> F \<and> \<A>\<^sub>1 \<Turnstile> G)"
    by (simp only: formula_semantics.simps(4))
  also have "\<dots> = (\<A>\<^sub>2 \<Turnstile> F \<and> \<A>\<^sub>2 \<Turnstile> G)"
    using H1 H2 by (rule arg_cong2)
  also have "\<dots> = \<A>\<^sub>2 \<Turnstile> F \<^bold>\<and> G"
    by (simp only: formula_semantics.simps(4))
  finally show ?thesis 
    by this
qed

lemma relevant_atoms_same_semantics_or: 
  assumes "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
          "\<forall>k \<in> atoms G. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> G \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> G"
          "\<forall>k \<in> atoms (F \<^bold>\<or> G). \<A>\<^sub>1 k = \<A>\<^sub>2 k"
     shows "\<A>\<^sub>1 \<Turnstile> (F \<^bold>\<or> G) \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> (F \<^bold>\<or> G)"
proof -
  have H:"\<forall>k \<in> atoms F \<union> atoms G. \<A>\<^sub>1 k = \<A>\<^sub>2 k" using assms(3)
    by (simp only: formula.set(5))
  then have "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k"
    by (rule forall_union1)
  then have H1:"\<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
    by (simp only: assms(1))
  have "\<forall>k \<in> atoms G. \<A>\<^sub>1 k = \<A>\<^sub>2 k"
    using H by (rule forall_union2)
  then have H2:"\<A>\<^sub>1 \<Turnstile> G \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> G"
    by (simp only: assms(2))
  have "\<A>\<^sub>1 \<Turnstile> F \<^bold>\<or> G = (\<A>\<^sub>1 \<Turnstile> F \<or> \<A>\<^sub>1 \<Turnstile> G)"
    by (simp only: formula_semantics.simps(5))
  also have "\<dots> = (\<A>\<^sub>2 \<Turnstile> F \<or> \<A>\<^sub>2 \<Turnstile> G)"
    using H1 H2 by (rule arg_cong2)
  also have "\<dots> = \<A>\<^sub>2 \<Turnstile> F \<^bold>\<or> G"
    by (simp only: formula_semantics.simps(5))
  finally show ?thesis 
    by this
qed

lemma relevant_atoms_same_semantics_imp: 
  assumes "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
          "\<forall>k \<in> atoms G. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> G \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> G"
          "\<forall>k \<in> atoms (F \<^bold>\<rightarrow> G). \<A>\<^sub>1 k = \<A>\<^sub>2 k"
     shows "\<A>\<^sub>1 \<Turnstile> (F \<^bold>\<rightarrow> G) \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> (F \<^bold>\<rightarrow> G)"
proof -
  have H:"\<forall>k \<in> atoms F \<union> atoms G. \<A>\<^sub>1 k = \<A>\<^sub>2 k" using assms(3)
    by (simp only: formula.set(6))
  then have "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k"
    by (rule forall_union1)
  then have H1:"\<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
    by (simp only: assms(1))
  have "\<forall>k \<in> atoms G. \<A>\<^sub>1 k = \<A>\<^sub>2 k"
    using H by (rule forall_union2)
  then have H2:"\<A>\<^sub>1 \<Turnstile> G \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> G"
    by (simp only: assms(2))
  have "\<A>\<^sub>1 \<Turnstile> F \<^bold>\<rightarrow> G = (\<A>\<^sub>1 \<Turnstile> F \<longrightarrow> \<A>\<^sub>1 \<Turnstile> G)"
    by (simp only: formula_semantics.simps(6))
  also have "\<dots> = (\<A>\<^sub>2 \<Turnstile> F \<longrightarrow> \<A>\<^sub>2 \<Turnstile> G)"
    using H1 H2 by (rule arg_cong2)
  also have "\<dots> = \<A>\<^sub>2 \<Turnstile> F \<^bold>\<rightarrow> G"
    by (simp only: formula_semantics.simps(6))
  finally show ?thesis 
    by this
qed

lemma "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
proof (induction F)
case (Atom x)
  then show ?case by (rule relevant_atoms_same_semantics_atomic)
next
  case Bot
then show ?case by (rule relevant_atoms_same_semantics_bot)
next
  case (Not F)
then show ?case by (rule relevant_atoms_same_semantics_not)
next
  case (And F1 F2)
  then show ?case by (rule relevant_atoms_same_semantics_and)
next
case (Or F1 F2)
  then show ?case by (rule relevant_atoms_same_semantics_or)
next
  case (Imp F1 F2)
  then show ?case by (rule relevant_atoms_same_semantics_imp)
qed

lemma relevant_atoms_same_semantics: 
   "\<forall>k \<in> atoms F. \<A>\<^sub>1 k = \<A>\<^sub>2 k \<Longrightarrow> \<A>\<^sub>1 \<Turnstile> F \<longleftrightarrow> \<A>\<^sub>2 \<Turnstile> F"
  by (induction F) simp_all

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

lemma "A \<Turnstile> \<top>" 
proof -
 have "A \<Turnstile> \<bottom> \<longrightarrow> A \<Turnstile> \<bottom>" 
   by (rule imp_refl)
 then have "A \<Turnstile> (\<bottom> \<^bold>\<rightarrow> \<bottom>)"
   by (simp only: formula_semantics.simps(6))
 thus "A \<Turnstile> \<top>" unfolding Top_def by this
qed
  
lemma top_semantics: 
  "A \<Turnstile> \<top>" 
  unfolding Top_def 
  by simp 

lemma BigAnd_semantics_nil: "A \<Turnstile> \<^bold>\<And>[] \<longleftrightarrow> (\<forall>f \<in> set []. A \<Turnstile> f)"
proof - 
  have "A \<Turnstile> \<^bold>\<And>[] = A \<Turnstile> (\<^bold>\<not>\<bottom>)"
    by (simp only: BigAnd.simps(1))
  also have "\<dots> = (\<not> A \<Turnstile> \<bottom>)"
    by (simp only: formula_semantics.simps(3))
  also have "\<dots> = (\<not> False)"
    by (simp only: formula_semantics.simps(2))
  also have "\<dots> = True"
    by (simp only: not_False_eq_True)
  also have "\<dots> = (\<forall>f \<in> \<emptyset>. A \<Turnstile> f)"
    by (simp only: ball_empty) 
  also have "\<dots> = (\<forall>f \<in> set []. A \<Turnstile> f)"
    by (simp only: list.set)
  finally show ?thesis
    by this
qed

text \<open>\comentario{Terminar los pendientes de BigAnd semantics y 
  BigOr semantics.}\<close>

lemma BigAnd_semantics_cons: 
  assumes "A \<Turnstile> \<^bold>\<And>Fs \<longleftrightarrow> (\<forall>f \<in> set Fs. A \<Turnstile> f)"
  shows "A \<Turnstile> \<^bold>\<And>(F#Fs) \<longleftrightarrow> (\<forall>f \<in> set (F#Fs). A \<Turnstile> f)"
proof -
  have "A \<Turnstile> \<^bold>\<And>(F#Fs) = A \<Turnstile> F \<^bold>\<and> \<^bold>\<And>Fs"
    by (simp only: BigAnd.simps(2))
  also have "\<dots> = (A \<Turnstile> F \<and> A \<Turnstile> \<^bold>\<And>Fs)"
    by (simp only: formula_semantics.simps(4))
  also have "\<dots> = (A \<Turnstile> F \<and> (\<forall>f \<in> set Fs. A \<Turnstile> f))"
    by (simp only: assms)
  also have "\<dots> = (\<forall>f \<in> (set [F] \<union> set Fs). A \<Turnstile> f)"
    by simp (*Pendiente*)
  also have "\<dots> = (\<forall>f \<in> set (F#Fs). A \<Turnstile> f)" using [[simp_trace]]
    by simp (*Pendiente*)
  finally show ?thesis
    by this
qed

lemma "A \<Turnstile> \<^bold>\<And>Fs \<longleftrightarrow> (\<forall>f \<in> set Fs. A \<Turnstile> f)"
proof (induction Fs)
  case Nil
  then show ?case by (rule BigAnd_semantics_nil)
next
  case (Cons a Fs)
  then show ?case by (rule BigAnd_semantics_cons)
qed

lemma BigAnd_semantics: 
  "A \<Turnstile> \<^bold>\<And>Fs \<longleftrightarrow> (\<forall>f \<in> set Fs. A \<Turnstile> f)"
  by (induction Fs; simp)

lemma BigOr_semantics_nil: "A \<Turnstile> \<^bold>\<Or>[] \<longleftrightarrow> (\<exists>f \<in> set []. A \<Turnstile> f)" 
proof -
  have "A \<Turnstile> \<^bold>\<Or>[] = A \<Turnstile> \<bottom>"
    by (simp only: BigOr.simps(1))
  also have "\<dots> = False"
    by (simp only: formula_semantics.simps(2))
  also have "\<dots> = (\<exists>f \<in> \<emptyset>. A \<Turnstile> f)"
    by (simp only: bex_empty)
  also have "\<dots> = (\<exists>f \<in> set []. A \<Turnstile> f)"
    by (simp only: list.set)
  finally show ?thesis
    by this
qed

lemma BigOr_semantics_cons: 
  assumes "A \<Turnstile> \<^bold>\<Or>Fs \<longleftrightarrow> (\<exists>f \<in> set Fs. A \<Turnstile> f)" 
  shows "A \<Turnstile> \<^bold>\<Or>(F#Fs) \<longleftrightarrow> (\<exists>f \<in> set (F#Fs). A \<Turnstile> f)" 
proof -
  have "A \<Turnstile> \<^bold>\<Or>(F#Fs) = A \<Turnstile> F \<^bold>\<or> \<^bold>\<Or>Fs"
    by (simp only: BigOr.simps(2))
  also have "\<dots> = (A \<Turnstile> F \<or> A \<Turnstile> \<^bold>\<Or>Fs)"
    by (simp only: formula_semantics.simps(5))
  also have "\<dots> = (A \<Turnstile> F \<or> (\<exists>f \<in> set Fs. A \<Turnstile> f))"
    by (simp only: assms)
  also have "\<dots> = (\<exists>f \<in> set (F#Fs). A \<Turnstile> f)"
    by simp (*Pendiente*)
  finally show ?thesis
    by this
qed

text \<open>\comentario{Añadir ball empty, list set, not False eq True,
 bex empty al glosario.}\<close>

lemma "A \<Turnstile> \<^bold>\<Or>Fs \<longleftrightarrow> (\<exists>f \<in> set Fs. A \<Turnstile> f)" 
proof (induction Fs)
case Nil
  then show ?case by (rule BigOr_semantics_nil)
next
  case (Cons a Fs)
then show ?case by (rule BigOr_semantics_cons)
qed

lemma BigOr_semantics: 
  "A \<Turnstile> \<^bold>\<Or>Fs \<longleftrightarrow> (\<exists>f \<in> set Fs. A \<Turnstile> f)" 
  by (induction Fs; simp)
    
text \<open>Definitions for sets of formulae, used for compactness and model 
  existence.\<close>

text\<open> Definición: conjunto de fórmulas consistente.\<close>

definition "sat S \<equiv> \<exists>\<A>. \<forall>F \<in> S. \<A> \<Turnstile> F" 

text \<open>\comentario{Unificar nomenclatura de consistente y sat.}\<close>

text \<open>Definición: conjunto de fórmulas finitamente consistente.\<close>

definition "fin_sat S \<equiv> (\<forall>s \<subseteq> S. finite s \<longrightarrow> sat s)"

text \<open>Lema: un conjunto de fórmulas S es inconsistente si y sólo si
 $\bot$ es consecuencia lógica de S.\<close>

lemma "\<Gamma> \<TTurnstile> \<bottom> \<longleftrightarrow> \<not> sat \<Gamma>" 
proof -
  have "\<Gamma> \<TTurnstile> \<bottom> = (\<forall>\<A>. ((\<forall>G \<in> \<Gamma>. \<A> \<Turnstile> G) \<longrightarrow> \<A> \<Turnstile> \<bottom>))"
    by (simp only: entailment_def)
  also have "\<dots> = (\<forall>\<A>. ((\<forall>G \<in> \<Gamma>. \<A> \<Turnstile> G) \<longrightarrow> False))"
    by (simp only: formula_semantics.simps(2))
  also have "\<dots> = (\<forall>\<A>. \<not>(\<forall>G \<in> \<Gamma>. \<A> \<Turnstile> G))"
    by (simp only: not_def)
  also have "\<dots> = (\<forall>\<A>. (\<exists>G \<in> \<Gamma>. \<not> (\<A> \<Turnstile> G)))"
    by (simp only: ball_simps(10)) 
  also have "\<dots> = (\<forall>\<A>. \<not>(\<forall>G \<in> \<Gamma>. \<A> \<Turnstile> G))"
    by (simp only: ball_simps(10)) 
  also have "\<dots> =  (\<not>(\<exists>\<A>. \<forall>G \<in> \<Gamma>. \<A> \<Turnstile> G))"
    by (simp only: not_ex) 
  also have "\<dots> = (\<not> sat \<Gamma>)"
    by (simp only: sat_def)
  finally show ?thesis
    by this
qed

lemma entail_sat: 
  "\<Gamma> \<TTurnstile> \<bottom> \<longleftrightarrow> \<not> sat \<Gamma>" 
  unfolding sat_def entailment_def 
  by simp

(*<*)
end
(*>*) 
