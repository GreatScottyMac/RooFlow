SOURCE_DIR="/your/path/to/RooFlow"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

cp "$SOURCE_DIR/.clinerules-architect" "./.clinerules-architect"
cp "$SOURCE_DIR/.clinerules-ask"        "./.clinerules-ask"
cp "$SOURCE_DIR/.clinerules-code"       "./.clinerules-code"
cp "$SOURCE_DIR/.clinerules-debug"      "./.clinerules-debug"
cp "$SOURCE_DIR/.clinerules-test"       "./.clinerules-test"

cp "$SOURCE_DIR/.roomodes"              "./.roomodes"

echo "All files and directories from '$SOURCE_DIR' have been copied to the current directory."
