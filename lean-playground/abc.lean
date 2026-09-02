import Mathlib.Data.ZMod.Basic

#eval 1+1

def add1 (n: Nat): Nat := n + 1

#eval add1 3

def add2 (n1 n2: Nat): Nat := n1 + n2

#eval add2 4 5

#eval String.append (String.append "Naa " "peru") " Deepak"

#eval 6 / 0

def x: Nat := 7

#eval add2 x x

#check add2

def joinStringsWith (sep x y: String): String :=
  String.append x (String.append sep y)

-- #eval joinStringsWith "; " "one" "and another"

-- #check joinStringsWith ". "

structure Point where
  x: Float
  y: Float

def p: Point := {x := 1.2, y := 2.3}

def addPoints (p1 p2: Point): Point := {
  x := p1.x + p2.x,
  y := p1.y + p2.y
}

-- #eval addPoints p p

theorem onePlusOneOrLessThan : 1 + 1 = 2 ∨ 3 < 5 := by
  decide

theorem exerciseOne: 2 + 3 = 5 := rfl
theorem exerciseTwo: 15 - 8 = 7 := rfl
theorem exerciseThree: "Hello".append "world" = "Helloworld" := rfl
theorem exerciseFour: 4 < 18 := by decide

def getFifthElement {a: Type} (l: List a) (ok: l.length >= 5) : a := l[4]

#check Nat

#check (λ x => x + 4)

def fibonacci (n: Nat) : Nat :=
  match n with
  | 0 => 1
  | 1 => 1
  | k + 2 => fibonacci k + fibonacci (k + 1)

#eval fibonacci 10

#print fibonacci

variable (p q r s : Prop)

theorem t2 (h₁ : q → r) (h₂ : p → q) : p → r :=
  fun h₃ : p =>
  show r from h₁ (h₂ h₃)

-- 2, 5, 8, ..
def fibParity: Prop :=
  ∀ n: Nat,
      (fibonacci (3*n)) % 2 = 1 ∧
      (fibonacci (3*n+1)) % 2 = 1 ∧
      (fibonacci (3*n+2)) % 2 = 0

theorem fib_step: ∀ n : Nat, fibonacci (n+2) = fibonacci n + fibonacci (n+1) := by
  intro n
  rfl

#print fib_step

theorem fibParity_proof: fibParity := by
  unfold fibParity
  intro n
  induction n with
  | zero => decide
  /-
      apply And.intro
      · rfl
      · apply And.intro
        · rfl
        · rfl
  -/
  | succ n ih =>
      rcases ih with ⟨ h0, h1, h2 ⟩

      have h3 : fibonacci (3 * n + 3) % 2 = 1 := by
        have t : 3 * n + 3 = (3 * n + 1) + 2 := by omega
        rw [t, fib_step, Nat.add_mod, h1, h2]

      have h4: fibonacci (3 * n + 4) % 2 = 1 := by
        have t:  3 * n + 4 = (3 * n + 2) + 2 := by omega
        have t2: (3 * n + 2 + 1) = 3 * n + 3 := by omega
        rw [t, fib_step, t2, Nat.add_mod, h2, h3]

      constructor
      · have tGoal : 3 * (n + 1) = 3 * n + 3 := by omega
        rw [tGoal, h3]
      · constructor
        · have t: (3 * (n+1) + 1) = (3 * n + 4) := by omega
          rw [t, h4]
        · have t: (3 * (n+1)) = (3*n + 3) := by omega
          have t2: 3*n + 3 + 1 = 3*n + 4 := by omega
          rw [t, fib_step, t2, Nat.add_mod, h3, h4]

-- #print fibParity_proof

theorem test (p q : Prop) (hp : p) (hq : q) : p ∧ q ∧ p := by
  exact ⟨hp, hq, hp⟩

-- #print test

theorem test2 (p q : Prop) : p -> q -> p :=
  fun hp _ => hp
  -- fun hp : p => fun _ : q => hp
#print test2

theorem test3 (p q : Prop) : p -> q -> p :=
  fun hp : p => fun _ : q => hp
#print test3

theorem test4 : ∀ (p q : Prop), p → q → p :=
  fun _p _q hp _hq => hp
#print test4


--- HashClock blog post: https://hashcloak.com/blog/tutorial-introduction-to-formal-verification-with-lean-(part-1)

#eval (5: ZMod 7) + (6: ZMod 7)

#check ZMod

def BitString (L: ℕ): Type := Vector (ZMod 2) L

namespace BitString

def xor {L: ℕ} (x y: BitString L): BitString L :=
  Vector.zipWith (fun a b => a + b) x y

#eval (xor #v[0, 1, 2] #v[1, 1, 3]).toArray

def xor_comm {L: ℕ} (x y: BitString L): Prop :=
  xor x y = xor y x

lemma xor_comm_proof {L: ℕ} (x y: BitString L): xor_comm x y :=
  by
    apply Vector.ext
    intro i h_i_lt_L
    simp[xor]
    simp[add_comm]

def xor_assoc {L: ℕ} (x y z: BitString L): Prop :=
  xor x (xor y z) = xor (xor x y) z

lemma xor_assoc_proof {L: ℕ} (x y z: BitString L): xor_assoc x y z :=
  by
    apply Vector.ext
    intro i h_i_lt_L
    simp[xor]
    simp[add_assoc]

def BitString_ID {L: ℕ} : BitString L := Vector.replicate L 0

lemma xor_show_identity_proof {L: ℕ} (x: BitString L): xor x BitString_ID = x :=
  by
    apply Vector.ext
    intro i h
    simp[xor]
    simp[BitString_ID]

lemma xor_self_inverse {L: ℕ} (x: BitString L): xor x x = BitString_ID :=
  by
    apply Vector.ext
    intro i i_less_than_L
    simp[xor, BitString_ID]
    exact CharTwo.add_eq_zero.mpr rfl

structure ShannonCipher (K M C: Type) where
  enc: K → M → C
  dec: K → C → M
  correctness: ∀ k m, dec k (enc k m) = m

lemma oneTimePad_correctness {L : ℕ} (k m : BitString L) :
    xor k (xor k m) = m := by
  rw [xor_assoc_proof, xor_self_inverse,
      xor_comm_proof, xor_show_identity_proof]

def OneTimePad (L: ℕ ): ShannonCipher (BitString L) (BitString L) (BitString L) :=
{
  enc k m := xor k m
  dec k c := xor k c
  correctness := oneTimePad_correctness
}

end BitString
