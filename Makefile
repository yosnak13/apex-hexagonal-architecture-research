lint:
	npx prettier --plugin=prettier-plugin-apex --write "force-app/**/*.cls"
	npx prettier --write "force-app/**/*.html"
	npx eslint "force-app/**/*.js" --fix
