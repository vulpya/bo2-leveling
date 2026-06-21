MOD_NAME="t6-leveling"
MOD_DIR="$LOCALAPPDATA/Plutonium/storage/t6/mods/$MOD_NAME"
SCRIPTS_DIR="$MOD_DIR/scripts"

rm -rf "$SCRIPTS_DIR"
mkdir -p "$SCRIPTS_DIR"
mkdir -p "$MOD_DIR"

cp -r ./src/scripts/* "$SCRIPTS_DIR/"
cp ./mod.json "$MOD_DIR/mod.json"

echo "Deploy successful."