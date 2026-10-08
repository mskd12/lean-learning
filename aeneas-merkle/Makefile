.DEFAULT_GOAL := help

GENERATED_FILES := \
	generated/aeneas_merkle.llbc \
	proofs/translation.json \
	proofs/FastcryptoMerkle/Code/Types.lean \
	proofs/FastcryptoMerkle/Code/Funs.lean \
	proofs/FastcryptoMerkle/Code/TypesExternal_Template.lean \
	proofs/FastcryptoMerkle/Code/FunsExternal_Template.lean

.PHONY: help check translate regenerate clean clean-generated

help:
	@echo "make check       Check the Rust wrapper"
	@echo "make translate   Generate LLBC and Lean files"
	@echo "make regenerate  Remove generated files, then translate"
	@echo "make clean       Remove only generated translation files"

check:
	cargo check

translate:
	./scripts/translate.sh

regenerate: clean-generated
	./scripts/translate.sh

clean: clean-generated

clean-generated:
	$(RM) $(GENERATED_FILES)
