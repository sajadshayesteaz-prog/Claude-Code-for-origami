#!/usr/bin/env bash
# Re-fetch all origami-app source repos at the exact commits digested on 2026-10-18.
# Usage: bash fetch-sources.sh [target_dir]   (needs git + network access to github.com and registry.npmjs.org)
set -e
T="${1:-origami-sources}"; mkdir -p "$T"; cd "$T"
fetch(){ n=$1; url=$2; c=$3; [ -d "$n" ] || git clone -q --filter=blob:none "$url" "$n"; git -C "$n" fetch -q --depth 1 origin "$c" 2>/dev/null || true; git -C "$n" checkout -q "$c"; echo "ok $n @ ${c:0:10}"; }
fetch fold https://github.com/edemaine/fold 824f9fa6f944248787b0b2077ef622761489201e
fetch OrigamiSimulator https://github.com/amandaghassaei/OrigamiSimulator 903ef27afcec7113390659935ae884798ed27188
fetch box-pleating-studio https://github.com/bp-studio/box-pleating-studio 0496ad070ba4f4aeba3a018fd3b70e8213797aa1
fetch cp-editor https://github.com/edemaine/cp-editor 8b711099ca50e9fd2fb4418281f87a372aaef6bf
fetch oripa https://github.com/oripa/oripa 095899f6d87d94737247d4ba177d2801e32113da
fetch treemaker https://github.com/bugfolder/treemaker 3b013bff75086f9731515713f12465bf947ed8aa
fetch orirevo https://github.com/jun-mitani/orirevo e408db4fe7755abd14f84c9a61dbe515a88d79a7
fetch popup_card https://github.com/jun-mitani/popup_card 2bb05f6748b231809b3dce219cb7f6c481e5820e
fetch reference-finder-cpp https://github.com/MuTsunTsai/reference-finder-cpp 5c084091cffabc41e75c711e6159cf7cbe922e7c
fetch rabbit-ear https://github.com/rabbit-ear/rabbit-ear 762f800db11acc8ccdd38a3711cb425e8f22bf84
fetch scikit-image https://github.com/scikit-image/scikit-image b700edc8005e4ee9e74fc83259f09e8df3213f15
fetch awesome-origami https://github.com/oriedita/awesome-origami 5466e7515af6d0173397c186a79f8d91b7eb353c
mkdir -p npm && (cd npm && npm pack fold@0.12.0 rabbit-ear@0.9.41 --silent)
echo done
