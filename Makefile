play:
	cd src && love .
love:
	cd src && zip -r ../dist/fireworks.love .
js: love
	love.js -c --title=fireworks ./dist/fireworks.love ./dist/js
mb:
	rsync -avr --delete --progress dist/js/ mb:www/bazar/fireworks/
	rsync -avr --delete --progress dist/fireworks.love mb:www/bazar/fireworks/
