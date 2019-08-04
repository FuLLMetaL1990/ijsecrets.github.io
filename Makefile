# Default command for `make`:
.DEFAULT_GOAL := compile

# Generate current timestamp:
timestamp := $(shell date +%s)

# Command: install
# Description:
# 1. Create a tmp directory
# 2. Move .gitignore and content directory to tmp
# 3. Generate a cryogen template in the current directory
# 4. Remove the generated .gitignore, content directory and themes' subdirectories
# 5. Move back .gitignore and content directory from tmp directory to current directory
# 6. Remove the created tmp directory
# 7. Clone cryogen-theme-wooji as themes/wooji
.PHONY: install
install:
	@mkdir -p tmp
	@mv {.gitignore,content} tmp
	@lein new cryogen . --force
	@rm -rf {.gitignore,content,themes/*}
	@mv tmp/{.gitignore,content} .
	@rm -rf tmp
	@git clone git@github.com:ejelome/cryogen-theme-wooji themes/wooji

# Command: compile
# Description:
# 1. Run the command lein run (compile the files without running a web server)
.PHONY: compile
compile:
	@lein run

# Command: run
# Description:
# 1. Run the command lein ring server (compile the files then run a web server)
.PHONY: run
run:
	@lein ring server

# Command: publish
# Description:
# 0. Re-compile, fix sitemap.xml then minify all markup, style, script and image files
# 1. Remove previously moved docs directory (if there is any)
# 2. Rename public directory to docs directory
# 3. Stage all the files to git
# 4. Commit the staged files with date +%s (timestamp) as message
# 5. Push the commit to master branch (origin)
.PHONY: publish
publish: compile fix-all rel-nofollow optimize-all
	@rm -rf docs
	@mv public docs
	@git add -A
	@git commit -m '$(timestamp)'
	@git push -u origin master

# Command: fix-sitemap
# Description:
# 1. Add trailing slash (/) after .com on sitemap.xml
.PHONY: fix-sitemap
fix-sitemap:
	@sed -i 's/.com/.com\//g' public/sitemap.xml

# Commands: fix-all
# Description:
# 1. Run all fix-* commands
.PHONY: fix-all
fix-all: fix-sitemap

# Command: rel-nofollow
# Description:
# 1. Add rel-nofollow on external links
.PHONY: rel-nofollow
rel-nofollow:
	@find public -type f        \
							 -name '*.html' \
							 -exec sed -i "s/href='/rel='nofollow' href='/g" {} +


# Command: optimize-html
# Description: Minify all markup (*.html) files
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
								 --remove-empty-elements             \
								 --remove-redundant-attributes       \
								 --remove-script-type-attributes     \
								 --remove-style-link-type-attributes \
								 --sort-attributes                   \
								 --sort-class-name                   \
								 --use-short-doctype                 \
								 --input-dir public                  \
								 --output-dir public                 \
								 --file-ext html

# Command: optimize-css
# Description: Minify css/styles.css file
# Package: csso-cli
# Dependencies: npm
.PHONY: optimize-css
optimize-css:
	@csso public/css/styles.css -o public/css/styles.css
	@sed -i 's/: /:/g' public/css/styles.css

# Command: optimize-js
# Description: Minify js/scripts.js file
# Package: uglify-js
# Dependencies: npm
.PHONY: optimize-js
optimize-js:
	@uglifyjs public/js/scripts.js -o public/js/scripts.js \
																 -c                      \
																 -m

# Command: optimize-img
# Description: Optimize all image files
# Package: imagemin-cli
# Dependencies: npm
.PHONY: optimize-img
optimize-img:
	@imagemin public/img/* --out-dir public/img/

# Commands: optimize-all
# Description:
# 1. Run all optimize-* commands
.PHONY: optimize-all
optimize-all: optimize-html optimize-css optimize-js optimize-img
