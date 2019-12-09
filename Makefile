# Default command for `make`:
.DEFAULT_GOAL := compile

# Generate current timestamp:
timestamp := $(shell date +%s)

# Command: install
# Description:
# 1. Install hugo
# 2. Install hugo-theme-mod-kiera as mod-kiera
.PHONY: install
install:
	@yay -S hugo
	@git submodule add git@github.com:ejelome/hugo-theme-mod-kiera.git themes/mod-kiera

# Command: clean
# Description:
# 1. Remove files and directories specified in .gitignore
.PHONY: clean
clean:
	@git clean -Xdff

# Command: compile
# Description:
# 1. Compile markdown files to public/
.PHONY: compile
compile:
	@hugo

# Command: server
# Description:
# 1. Open content/index.html using the default browser
# 2. Run hugo web server with auto navigate on file change
.PHONY: server
server:
	@xdg-open http://localhost:1313
	@hugo server -D --navigateToChanged

# Command: optimize-html
# Description: Minify .html files
# Package: html-minifier
# Dependencies: npm, clean-css, uglify-js, relateurl
.PHONY: optimize-html
optimize-html:
	@html-minifier --case-sensitive                    \
								 --collapse-boolean-attributes       \
								 --collapse-inline-tag-whitespace    \
								 --collapse-whitespace               \
								 --conservative-collapse             \
								 --decode-entities                   \
								 --no-html5                          \
								 --no-include-auto-generated-tags    \
								 --keep-closing-slash                \
								 --minify-css true                   \
								 --minify-js true                    \
								 --minify-urls                       \
								 --prevent-attributes-escaping       \
								 --quote-character \"                \
								 --remove-attribute-quotes           \
								 --remove-comments                   \
								 --remove-empty-attributes           \
								 --remove-redundant-attributes       \
								 --remove-script-type-attributes     \
								 --remove-style-link-type-attributes \
								 --sort-attributes                   \
								 --sort-class-name                   \
								 --use-short-doctype                 \
								 --input-dir public/                 \
								 --output-dir public/                \
								 --file-ext html

# Command: optimize-css
# Description: Minify css/styles.css to css/styles.min.css
# Package: csso-cli
# Dependencies: npm
.PHONY: optimize-css
optimize-css:
	@csso public/css/styles.css        \
				-o public/css/styles.min.css \
				--no-restructure
	@sed -i 's/: /:/g' public/css/styles.min.css

# Command: optimize-js
# Description: Minify js/scripts.js to js/scripts.min.js
# Package: uglify-js
# Dependencies: npm
.PHONY: optimize-js
optimize-js:
	@uglifyjs public/js/scripts.js        \
						-o public/js/scripts.min.js \
						-c                          \
						-m

# Command: optimize-img
# Description: Optimize images
# Package: imagemin-cli
# Dependencies: npm
.PHONY: optimize-img
optimize-img:
	@imagemin public/img/* \
						--out-dir public/img/

# Command: rep-asset-urls
# Description:
# 1. Replace .css and .js urls to minified urls
.PHONY: rep-asset-urls
rep-asset-urls:
	@find public/ -type f        \
								-name '*.html' \
								-exec sed -i 's/href=\/css\/styles.css/href=\/css\/styles.min.css/g' {} +
	@find public/ -type f        \
								-name '*.html' \
								-exec sed -i 's/src=\/js\/scripts.js/src=\/js\/scripts.min.js/g' {} +

# Command: rel-nofollow
# Description:
# 1. Add rel="nofollow" on hrefs with external links
.PHONY: rel-nofollow
rel-nofollow:
	@find public/ -type f        \
								-name '*.html' \
								-exec sed -i 's/href=http/rel=nofollow href=http/g' {} +

# Command: publish
# Description:
# 0. Execute compile, optimize-(html,css,js,img) rep-asset-urls and rel-nofollow
# 1. Remove existing docs/ (if there is any)
# 2. Rename public/ to docs/
# 3. Stage all the files to git
# 4. Commit the staged files with date +%s (timestamp) as message
# 5. Push the commit to master branch (origin)
.PHONY: publish
publish: compile optimize-html optimize-css optimize-js optimize-img rep-asset-urls rel-nofollow
	@rm -rf docs/
	@mv public/ docs/
	@git add -A
	@git commit -m '$(timestamp)'
	@git push -u origin master
