sync:
	cp examples/dist/*.js js/
	git add js/*
	git com -m "update"
	git push
