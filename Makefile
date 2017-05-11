MAKEFLAGS := -r

CSS_ANALYZE := node_modules/.bin/parker
CSS_FORMAT := node_modules/.bin/stylefmt
CSS_POSTCSS := node_modules/.bin/postcss
CSS_POSTCSS_OPTS := -e production

COMPRESS ?= gzip
COMPRESS_OPTS ?= -9

SRC_DIR := lib
WORK_DIR := build

ALL_SRC := $(sort $(wildcard $(SRC_DIR)/*/*.css) $(wildcard $(SRC_DIR)/*/*/*.css))
ALL_DST := $(addprefix $(WORK_DIR)/, $(ALL_SRC:$(SRC_DIR)/%=%))
ALL_DST_MIN := $(ALL_DST:.css=.min.css)
ALL_DST_MIN_COMPRESS := $(ALL_DST_MIN:=.gz)
ALL_DST_MERGE := $(WORK_DIR)/asm.css
ALL_DST_MERGE_MIN := $(ALL_DST_MERGE:.css=.min.css)
ALL_DST_MERGE_MIN_COMPRESS := $(ALL_DST_MERGE_MIN:=.gz)

WORK_DIRS := $(sort $(dir $(ALL_DST)))

.PHONY: all analyze clean compress format min

all: $(ALL_DST) min compress

analyze: $(ALL_DST_MERGE)
	$(CSS_ANALYZE) $^

clean:
	rm -rf $(WORK_DIR)

format:
	$(CSS_FORMAT) -r $(SRC_DIR)/*/*.css $(SRC_DIR)/*/*/*.css

min: $(ALL_DST_MIN) $(ALL_DST_MERGE_MIN)

compress: $(ALL_DST_MIN_COMPRESS) $(ALL_DST_MERGE_MIN_COMPRESS)

$(WORK_DIR)/%.css: $(SRC_DIR)/%.css | $(WORK_DIRS)
	$(CSS_POSTCSS) $< -o $@

%.min.css: %.css
	$(CSS_POSTCSS) $(CSS_POSTCSS_OPTS) $< -o $@

%.min.css.gz: %.min.css
	$(COMPRESS) $(COMPRESS_OPTS) < $< > $@

$(ALL_DST_MERGE): $(ALL_DST)
	cat $^ > $@
	$(CSS_POSTCSS) $@ -o $@

$(WORK_DIRS):
	@mkdir -p $@

