#!/usr/bin/osascript
on run argv
  set BASEDIR to item 1 of argv as string
  tell application "iTerm2"
    # open fourth terminal start connect
    tell fourth session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01-1_startconnect.sh"
        split horizontally with default profile
        split vertically with default profile
    end tell
    # open fifth terminal and start replicator and consume
    # tell fifth session of current tab of current window
    tell fifth session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01-2_startreplicator.sh"
        split vertically with default profile
    end tell
    # open sixth terminal and consume
    # tell sixth session of current tab of current window
    tell sixth session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01-3_consumeTarget.sh"
    end tell
    # open seventh terminal produce to source
    # tell seventh session of current tab of current window
    tell seventh session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01-4_produceSource.sh"
    end tell
  end tell
end run