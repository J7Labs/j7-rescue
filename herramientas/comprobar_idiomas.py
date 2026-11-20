#!/usr/bin/env python3
"""Comprueba que cada idioma tiene las mismas claves y marcadores (%@, %1$@) que el español. Uso: python3 -I herramientas/comprobar_idiomas.py"""
import re, sys, pathlib
raiz = pathlib.Path(__file__).resolve().parent.parent / "Recursos"
def leer(p):
    d = {}
    for l in p.read_text(encoding="utf-8").splitlines():
        m = re.match(r'^"([^"]+)"\s*=\s*"(.*)";\s*$', l)
        if m: d[m.group(1)] = m.group(2)
    return d
base = leer(raiz / "Idiomas/es.lproj/Localizable.strings")
marc = lambda s: sorted(re.findall(r'%(?:\d\$)?@', s.replace('%1$@','%@').replace('%2$@','%@').replace('%3$@','%@').replace('%4$@','%@')))
mal = 0
for carp in ["en", "nl", "pt-BR", "fr"]:
    p = raiz / f"Idiomas/{carp}.lproj/Localizable.strings"
    if not p.exists(): print(f"✘ falta {p}"); mal += 1; continue
    d = leer(p)
    for k in base:
        if k not in d: print(f"✘ {carp}: falta la clave {k}"); mal += 1
        elif marc(base[k]) != marc(d[k]): print(f"✘ {carp}: marcadores distintos en {k}"); mal += 1
    for k in d:
        if k not in base: print(f"✘ {carp}: clave de más {k}"); mal += 1
    suf = "pt" if carp == "pt-BR" else carp
    for doc in ["TUTORIAL", "AVISOS_LICENCIAS", "LEEME_DESCARGA"]:
        if not (raiz / f"{doc}.{suf}.md").exists(): print(f"✘ falta {doc}.{suf}.md"); mal += 1
print("✔ idiomas completos" if not mal else f"{mal} problemas"); sys.exit(1 if mal else 0)
