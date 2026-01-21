#!/usr/bin/env bash

# Unit tests for shell functions in funcs file
# Source the functions file
# shellcheck disable=SC1091
source "$(dirname "$0")/funcs"

# Test helpers
setup_test_dir() {
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR" || exit 1
}

teardown_test_dir() {
    cd - >/dev/null || exit 1
    rm -rf "$TEST_DIR"
}

assert_equal() {
    if [[ "$1" != "$2" ]]; then
        echo "FAIL: Expected '$2', got '$1'"
        return 1
    fi
    echo "PASS"
    return 0
}

assert_success() {
    if [[ $1 -ne 0 ]]; then
        echo "FAIL: Expected success, got exit code $1"
        return 1
    fi
    echo "PASS"
    return 0
}

# Test 1: play_videos_newest() finds and plays video files sorted by modification time in descending order
test_play_videos_newest_sorts_by_mtime() {
    echo "Test 1: play_videos_newest() finds and plays video files sorted by modification time"
    
    setup_test_dir
    
    # Create test video files with different modification times
    touch -t 202601011200 old_video.mp4
    sleep 0.1
    touch -t 202601021200 middle_video.mkv
    sleep 0.1
    touch -t 202601031200 newest_video.avi
    
    # Create a mock mpv script that captures arguments
    cat > "$TEST_DIR/mpv" <<EOF
#!/bin/bash
echo "\$@" > "$TEST_DIR/mpv_args.txt"
EOF
    chmod +x "$TEST_DIR/mpv"
    
    # Add mock mpv to PATH
    export PATH="$TEST_DIR:$PATH"
    
    # Run the function
    play_videos_newest 2>/dev/null
    
    # Check that mpv was called with files in correct order (newest first)
    if [[ -f "$TEST_DIR/mpv_args.txt" ]]; then
        local args=$(cat "$TEST_DIR/mpv_args.txt")
        # Extract just the filenames in order
        local first_file=$(echo "$args" | grep -oE '\./[^ ]+' | head -1 | xargs basename)
        local last_file=$(echo "$args" | grep -oE '\./[^ ]+' | tail -1 | xargs basename)
        
        if [[ "$first_file" == "newest_video.avi" ]] && [[ "$last_file" == "old_video.mp4" ]]; then
            echo "PASS: Videos sorted correctly by modification time (newest first)"
            teardown_test_dir
            return 0
        else
            echo "FAIL: Videos not sorted correctly. First: $first_file, Last: $last_file"
            teardown_test_dir
            return 1
        fi
    else
        echo "FAIL: mpv was not called"
        teardown_test_dir
        return 1
    fi
}

# Test 2: play_videos_newest() handles directories with no video files gracefully
test_play_videos_newest_no_files() {
    echo "Test 2: play_videos_newest() handles directories with no video files gracefully"
    
    setup_test_dir
    
    # Create non-video files
    touch readme.txt
    touch document.pdf
    mkdir subdir
    
    # Create a mock mpv script that captures arguments
    cat > "$TEST_DIR/mpv" <<EOF
#!/bin/bash
echo "\$@" > "$TEST_DIR/mpv_args.txt"
EOF
    chmod +x "$TEST_DIR/mpv"
    
    # Add mock mpv to PATH
    export PATH="$TEST_DIR:$PATH"
    
    # Run the function - it should not crash
    play_videos_newest 2>/dev/null
    local exit_code=$?
    
    # The function should complete without error
    # Check that mpv either wasn't called or was called with no arguments (empty input)
    if [[ ! -f "$TEST_DIR/mpv_args.txt" ]] || [[ -z "$(cat "$TEST_DIR/mpv_args.txt" 2>/dev/null)" ]]; then
        echo "PASS: Function handled no video files gracefully (no crash, no files passed to mpv)"
        teardown_test_dir
        return 0
    else
        echo "FAIL: Unexpected behavior with no video files"
        teardown_test_dir
        return 1
    fi
}

# Run all tests
main() {
    local failed=0
    
    echo "Running unit tests for play_videos_newest()..."
    echo ""
    
    test_play_videos_newest_sorts_by_mtime || ((failed++))
    echo ""
    
    test_play_videos_newest_no_files || ((failed++))
    echo ""
    
    if [[ $failed -eq 0 ]]; then
        echo "All tests passed!"
        return 0
    else
        echo "$failed test(s) failed"
        return 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
