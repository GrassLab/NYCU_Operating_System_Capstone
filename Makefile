HTML_OUTPUT = docs

.PHONY: all, clean

all:
	sphinx-build . ${HTML_OUTPUT}

clean:
	rm -rf ${HTML_OUTPUT}