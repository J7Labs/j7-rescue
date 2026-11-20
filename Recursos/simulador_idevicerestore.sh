#!/bin/bash
# SIMULADOR de idevicerestore: solo para PROBAR la app. No toca ningún iPhone.
# Escenarios (variable RESCATE_SIM_ESCENARIO): ok (por defecto) · borrar · falta
esc="${RESCATE_SIM_ESCENARIO:-ok}"
dormir() { sleep "${RESCATE_SIM_PAUSA:-0.4}"; }
echo "idevicerestore SIMULADO. Argumentos: $*"
case " $* " in *" -e "*|*" --erase "*) echo "SIMULADOR: me han pasado -e. ¡Esto no debería pasar!"; exit 99;; esac
echo "Found device in Recovery mode"; dormir
if [ "$esc" = "borrar" ]; then
  echo "Selected build identity: Customer Erase Install (IPSW) — will erase all data"; dormir
  for i in $(seq 1 60); do echo "esperando..."; sleep 1; done; exit 0
fi
echo "Variant: Customer Upgrade Install (IPSW)"; dormir
echo "This restore will update the device without erasing user data."; echo "without erasing user data"; dormir
echo "Declaring Cryptex1,SystemOSSize as ${IDEVICERESTORE_CRYPTEX_SIZE_MIB} MiB (real size 6030 MiB)"; dormir
echo "Extracting and personalizing…"; dormir; dormir
if [ "$esc" = "falta" ]; then
  echo "ERROR: Failed preallocation due to space"; echo "EXIT=255"; exit 255
fi
echo "Sending Cryptex1,SystemOS now (6030 MiB)…"; dormir; dormir
echo "Sealing System Volume (77)"; dormir
echo "Status: Restore Finished"
