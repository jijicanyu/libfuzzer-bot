set terminal pdf

set output "/work/graph.pdf"
set logscale x
set nokey

plot for [file in filenames] file using 1:3


