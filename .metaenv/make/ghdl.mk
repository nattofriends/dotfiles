install: ghdl
ghdl:
	./ghdl.py

upgrade: ghdl

clean: ghdl-clean
ghdl-clean:
	rm -rf gh-bin/*
