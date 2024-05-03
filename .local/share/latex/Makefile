help:
	echo "Provide which .tex file you need to update."

environment: 
	find "`cd environments && pwd`" -type f | awk '{printf "\\input{%s}\n", $$1}' > environments.tex
