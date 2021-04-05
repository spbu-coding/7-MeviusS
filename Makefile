include CONFIG.cfg
CC = gcc 
CHECK_OK = ok
CHECK_FAIL = fail
EXEC = $(BUILD_DIR)/$(NAME)
OBJECT = $(BUILD_DIR)/main.o
LOG = $(patsubst $(TEST_DIR)/%.in, $(TEST_DIR)/%.log, $(wildcard $(TEST_DIR)/*.in))

.PHONY: all check clean

all: $(EXEC)

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c | $(BUILD_DIR)
	$(CC) -c $< -o $@

$(EXEC): $(OBJECT) | $(BUILD_DIR) 
	$(CC) $^ -o $@ 

$(BUILD_DIR): 
	mkdir -p $@ 

check: $(LOG) 
	@for test in $^ ; do \ 
	if [ "$$(cat $${test})" != "OK" ] ; then \ 
		exit 1 ; \ 
	fi ; \ 
	done 

$(TEST_DIR)/%.log: $(TEST_DIR)/%.in $(TEST_DIR)/%.out $(EXEC) 
	@if [ "$$(./$(EXEC) ./$<)" = "$$(cat $(word 2, $^))" ] ; then \ 
	echo "OK" > $@ ; \ 
	echo "Test $< passed" ; \ 
    else \ 
	echo "FAIL" > $@ ; \ 
	echo "Test $< failed" ; \ 
    fi 

clean: 
	rm -rf $(EXEC) $(OBJECT) $(LOG)
