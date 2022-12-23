@echo off
if exist *.tpu del *.tpu
if exist *.bak del *.bak

tpc -m ticproc.pas
tpc -m hatch.pas

if exist *.tpu del *.tpu
if exist *.bak del *.bak
if exist *.bin del *.bin
