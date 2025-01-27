{-# OPTIONS --cubical #-}

module Free where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function
open import Cubical.Data.Nat hiding (_^_)
open import Cubical.Data.Sigma
open import Cubical.Data.List
open import Cubical.Data.Unit


infixr 30 _⊗_
infixr 0 _⊸_
infixl 10 [_,_]
infixr 11 _⊸⊗_
infixr 10 _⊸∘_


data sply (ℓ : Level) : Type (ℓ-suc ℓ) where
  η : {A : Type ℓ} → A → sply ℓ
  ◇ : sply ℓ
  _⊗_ : sply ℓ → sply ℓ → sply ℓ
  [_,_] : sply ℓ → sply ℓ → sply ℓ


data _⊸_ {ℓ : Level} : sply ℓ → sply ℓ → Type (ℓ-suc ℓ) where
  id : ∀ Δ → Δ ⊸ Δ

  unitl⊸ : ∀ Δ → (◇ ⊗ Δ) ⊸ Δ
  unitl⊸' : ∀ Δ → Δ ⊸ ◇ ⊗ Δ
  swap : ∀ x y → x ⊗ y ⊸ y ⊗ x
  assoc : ∀ x y z → x ⊗ (y ⊗ z) ⊸ (x ⊗ y) ⊗ z


  _⊸∘_ : ∀ {Δ₀ Δ₁ Δ₂}
    →  Δ₁ ⊸ Δ₂
    →  Δ₀ ⊸ Δ₁
    →  Δ₀ ⊸ Δ₂

  cur : ∀{Δ₀ Δ₁ Δ₂} →  (Δ₀ ⊗ Δ₁) ⊸ Δ₂ → Δ₀ ⊸ ([_,_] Δ₁ Δ₂)
  unc : ∀{Δ₀ Δ₁ Δ₂} →  Δ₀ ⊸ ([_,_] Δ₁ Δ₂) →  (Δ₀ ⊗ Δ₁) ⊸  Δ₂

  _⊸⊗_ :  ∀{Δ₀ Δ₁ Δ₀' Δ₁'}
    → Δ₀ ⊸ Δ₁
    → Δ₀' ⊸ Δ₁'
    → Δ₀ ⊗ Δ₀' ⊸ Δ₁ ⊗ Δ₁'


  ι, : {A : Type ℓ} {B : A → Type ℓ} {a : A} {b : B a}
    → η {A = Σ A B} (a , b) ⊸ (η a ⊗ η b)
  ω, : {A : Type ℓ} {B : A → Type ℓ} {a : A} {b : B a}
    → (η a ⊗ η b) ⊸ η {A = Σ A B} (a , b)

  ι∷ : {A : Type ℓ} {x : A} {xs : List A} → η (x ∷ xs) ⊸ η x ⊗ η xs
  ω∷ : {A : Type ℓ} {x : A} {xs : List A} → η x ⊗ η xs ⊸ η (x ∷ xs)

  ι[] : {A : Type ℓ} → (η {A = List A} []) ⊸ ◇
  ω[] : {A : Type ℓ} → ◇ ⊸ (η {A = List A} [])




private
  variable
    ℓ : Level

postulate
  Λₒ : (A : Type ℓ) → (A → sply ℓ) → sply ℓ

  λₒ : {A : Type ℓ} {Δ₀ : sply ℓ} {Δ₁ : A → sply ℓ}
    → ((x : A) → ( Δ₀ ⊸  (Δ₁ x)))
    → ( Δ₀ ⊸  (Λₒ A Δ₁))

  λₒ⁻¹ : {A : Type ℓ} {Δ₀ : sply ℓ} {Δ₁ : A → sply ℓ}
    → ( Δ₀ ⊸  (Λₒ A Δ₁))
    → ((x : A) → ( Δ₀ ⊸  (Δ₁ x)))

