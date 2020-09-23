.PHONY: all

all:
	latexmk thesis
silent:
	latexmk thesis -silent
clean:
	latexmk -C
wc:
	texcount -inc thesis.tex

run-container:
	docker pull aergus/latex
	docker start thesis-container || docker run --name thesis-container -t -d aergus/latex

end-container:
	docker stop thesis-container
	docker rm thesis-container

wc-in-container:
	docker cp . thesis-container:.
	docker exec thesis-container make wc

in-container:
	$(MAKE) in-container-main || ${MAKE} in-container-fallback

in-container-main:
	docker cp . thesis-container:.
	docker exec thesis-container make silent
	docker container cp thesis-container:thesis.pdf .

in-container-fallback:
	echo "Docker build failed. Tearing down the setup and copying thesis.log..."
	docker container cp thesis-container:thesis.log .
	docker container cp thesis-container:thesis.pdf .
