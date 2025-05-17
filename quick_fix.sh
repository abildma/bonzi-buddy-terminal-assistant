#!/bin/bash
# Quick fix script for test systems
# Run this on your test VM to fix the command wrappers

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Find the Bonzi Buddy installation directory
SCRIPT_DIR="$(cd "$(dirname "$0")" &> /dev/null && pwd)"
echo -e "${BLUE}Current directory: ${SCRIPT_DIR}${NC}"

# Fix the subo wrapper
echo -e "${YELLOW}Fixing subo wrapper...${NC}"
cat > "$SCRIPT_DIR/subo-wrapper" << EOF
#!/bin/bash
# Fixed wrapper for subo command
BONZI_DIR="$SCRIPT_DIR"
"\$BONZI_DIR/subo.sh" "\$@"
EOF
chmod +x "$SCRIPT_DIR/subo-wrapper"

# Fix the bonzi wrapper
echo -e "${YELLOW}Fixing bonzi wrapper...${NC}"
cat > "$SCRIPT_DIR/bonzi-wrapper" << EOF
#!/bin/bash
# Fixed wrapper for bonzi command
BONZI_DIR="$SCRIPT_DIR"
"\$BONZI_DIR/bonzi.sh" "\$@"
EOF
chmod +x "$SCRIPT_DIR/bonzi-wrapper"

# Create the bin directory if it doesn't exist
if [ ! -d ~/bin ]; then
    echo -e "${YELLOW}Creating ~/bin directory...${NC}"
    mkdir -p ~/bin
fi

# Create new symbolic links
echo -e "${YELLOW}Creating symbolic links in ~/bin...${NC}"
ln -sf "$SCRIPT_DIR/subo-wrapper" ~/bin/subo
ln -sf "$SCRIPT_DIR/bonzi-wrapper" ~/bin/bonzi

echo -e "${GREEN}Fix complete! Try using subo and bonzi commands now.${NC}"
echo -e "${BLUE}If needed, run 'export PATH=\"\$HOME/bin:\$PATH\"' to ensure ~/bin is in your PATH.${NC}"
