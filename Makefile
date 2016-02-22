sync:
	cp dist/*.js js/
	git add js/*
	git com -m "update"
	git push
