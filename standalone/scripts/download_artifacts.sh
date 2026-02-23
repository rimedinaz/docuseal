#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ARTIFACTS_DIR="$SCRIPT_DIR/../artifacts"

mkdir -p "$ARTIFACTS_DIR/fonts"

echo "Downloading artifacts to $ARTIFACTS_DIR..."

# Fonts
echo "Downloading fonts..."
wget -nc -P "$ARTIFACTS_DIR/fonts" "https://github.com/satbyy/go-noto-universal/releases/download/v7.0/GoNotoKurrent-Regular.ttf"
wget -nc -P "$ARTIFACTS_DIR/fonts" "https://github.com/satbyy/go-noto-universal/releases/download/v7.0/GoNotoKurrent-Bold.ttf"
wget -nc -P "$ARTIFACTS_DIR/fonts" "https://github.com/impallari/DancingScript/raw/master/fonts/DancingScript-Regular.otf"
wget -nc -P "$ARTIFACTS_DIR/fonts" "https://cdn.jsdelivr.net/gh/notofonts/notofonts.github.io/fonts/NotoSansSymbols2/hinted/ttf/NotoSansSymbols2-Regular.ttf"
wget -nc -P "$ARTIFACTS_DIR/fonts" "https://github.com/Maxattax97/gnu-freefont/raw/master/ttf/FreeSans.ttf"
wget -nc -P "$ARTIFACTS_DIR/fonts" "https://github.com/impallari/DancingScript/raw/master/OFL.txt"

# ONNX Model
echo "Downloading ONNX model..."
wget -nc -O "$ARTIFACTS_DIR/model.onnx" "https://github.com/docusealco/fields-detection/releases/download/2.0.0/model_704_int8.onnx"

# PDFium
# Determine architecture. Default to x64 if not detected properly or unsupported.
ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
  PDFIUM_ARCH="x64"
elif [ "$ARCH" == "aarch64" ]; then
  PDFIUM_ARCH="arm64"
else
  echo "Unsupported architecture: $ARCH. Defaulting to x64 for PDFium download."
  PDFIUM_ARCH="x64"
fi

echo "Downloading PDFium for $PDFIUM_ARCH..."
wget -nc -O "$ARTIFACTS_DIR/pdfium-linux.tgz" "https://github.com/docusealco/pdfium-binaries/releases/latest/download/pdfium-linux-${PDFIUM_ARCH}.tgz"

echo "Artifacts downloaded successfully."
