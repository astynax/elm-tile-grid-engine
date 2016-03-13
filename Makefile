sync:
	cp examples/dist/*.html .
	git add *.html
	git com -m "update"
	git push

