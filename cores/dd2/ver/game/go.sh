#!/bin/bash
if [ -e ../../mist/*hex ]; then
    for i in ../../mist/*hex; do
        if [ ! -e $(basename $i) ]; then
            if [ -e "$i" ]; then ln -s $i; fi
        fi
    done
fi

if [ -e char.bin ]; then
    $JTFRAME/bin/drop1 -l < char.bin > char_hi.bin
    $JTFRAME/bin/drop1    < char.bin > char_lo.bin
fi

if [ -e scr.bin ]; then
    $JTFRAME/bin/drop1 -l < scr.bin > scr_hi.bin
    $JTFRAME/bin/drop1    < scr.bin > scr_lo.bin
fi

MIST=-mist
VIDEO=0
for k in $*; do
    if [ "$k" = -mister ]; then
        echo "MiSTer setup chosen."
        MIST=$k
    fi
    if [ "$k" = -video ]; then
        VIDEO=1
    fi
done

export GAME_ROM_PATH=$ROM/JTDD2.rom
export MEM_CHECK_TIME=240_000_000
export BIN2PNG_OPTIONS="--scale"
export CONVERT_OPTIONS="-resize 300%x300%"
export YM2151=1
export M6809=1
export MSM6295=1

if [ ! -e $GAME_ROM_PATH ]; then
    echo Missing file $GAME_ROM_PATH
    exit 1
fi

# Generic simulation script from JTFRAME
# JTFRAME_DUAL_RAM_DUMP
echo "Game ROM length: " $GAME_ROM_LEN
$JTFRAME/bin/sim.sh $MIST  -sysname dd2 \
    -def ../../hdl/jtdd2.def \
    -d VIDEO_START=2 \
    -d JT51_NODEBUG  -d JTFRAME_DUAL_RAM_DUMP \
    $*
rm sub*.bin
sub2bin