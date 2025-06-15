#!/bin/bash

# Golden Test Helper Script for BDD Gherkin Project
# Usage: ./scripts/golden-test.sh [command]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_help() {
    echo -e "${BLUE}🎯 Golden Test Helper${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo -e "  ${GREEN}run${NC}           Run all golden tests"
    echo -e "  ${GREEN}update${NC}        Update/generate golden master images"
    echo -e "  ${GREEN}verify${NC}        Run tests and show detailed output"
    echo -e "  ${GREEN}clean${NC}         Remove all golden files"
    echo -e "  ${GREEN}status${NC}        Show golden test status"
    echo -e "  ${GREEN}help${NC}          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 run          # Run golden tests"
    echo "  $0 update       # Generate new golden images"
    echo "  $0 verify       # Run with verbose output"
}

run_golden_tests() {
    echo -e "${BLUE}🧪 Running Golden Tests...${NC}"
    flutter test test/golden_test.dart
    echo -e "${GREEN}✅ Golden tests completed!${NC}"
}

update_golden_files() {
    echo -e "${YELLOW}📸 Updating golden master images...${NC}"
    flutter test test/golden_test.dart --update-goldens
    echo -e "${GREEN}✅ Golden images updated!${NC}"
    
    # Show generated files
    if [ -d "test/goldens" ]; then
        echo -e "\n${BLUE}Generated files:${NC}"
        ls -la test/goldens/
    fi
}

verify_golden_tests() {
    echo -e "${BLUE}🔍 Running Golden Tests with detailed output...${NC}"
    flutter test test/golden_test.dart --verbose --reporter=expanded
}

clean_golden_files() {
    echo -e "${YELLOW}🧹 Cleaning golden files...${NC}"
    if [ -d "test/goldens" ]; then
        rm -rf test/goldens/
        echo -e "${GREEN}✅ Golden files cleaned!${NC}"
    else
        echo -e "${YELLOW}⚠️  No golden files found to clean${NC}"
    fi
}

show_status() {
    echo -e "${BLUE}📊 Golden Test Status${NC}"
    echo ""
    
    # Check if golden_toolkit is in pubspec.yaml
    if grep -q "golden_toolkit" pubspec.yaml; then
        echo -e "${GREEN}✅ golden_toolkit package installed${NC}"
    else
        echo -e "${RED}❌ golden_toolkit package not found in pubspec.yaml${NC}"
    fi
    
    # Check if golden test file exists
    if [ -f "test/golden_test.dart" ]; then
        echo -e "${GREEN}✅ Golden test file exists${NC}"
    else
        echo -e "${RED}❌ Golden test file not found${NC}"
    fi
    
    # Check if flutter_test_config.dart exists
    if [ -f "test/flutter_test_config.dart" ]; then
        echo -e "${GREEN}✅ Test configuration file exists${NC}"
    else
        echo -e "${YELLOW}⚠️  Test configuration file not found${NC}"
    fi
    
    # Show golden files
    if [ -d "test/goldens" ]; then
        echo -e "${GREEN}✅ Golden files directory exists${NC}"
        file_count=$(ls -1 test/goldens/ | wc -l)
        echo -e "   📁 Contains $file_count golden images"
        echo ""
        echo -e "${BLUE}Golden files:${NC}"
        ls -la test/goldens/
    else
        echo -e "${YELLOW}⚠️  No golden files generated yet${NC}"
        echo "   Run: $0 update"
    fi
}

# Main script logic
case "${1:-help}" in
    "run")
        run_golden_tests
        ;;
    "update")
        update_golden_files
        ;;
    "verify")
        verify_golden_tests
        ;;
    "clean")
        clean_golden_files
        ;;
    "status")
        show_status
        ;;
    "help"|*)
        print_help
        ;;
esac
