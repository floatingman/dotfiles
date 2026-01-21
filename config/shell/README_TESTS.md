# Shell Function Tests

Unit tests for shell functions defined in the `funcs` file.

## Running Tests

To run all tests:

```bash
./test_funcs.sh
```

Or with an absolute path:

```bash
/home/dnewman/.dotfiles/config/shell/test_funcs.sh
```

## Current Test Coverage

### play_videos_newest()

1. **Sorts by modification time**: Verifies that video files are found and passed to mpv in descending order by modification time (newest first)
2. **Handles empty directories gracefully**: Ensures the function doesn't crash when no video files are present

## Test Implementation

The tests use:
- Temporary directories for isolation
- Mock `mpv` executable to avoid actually playing videos
- Verification of command arguments and execution order
