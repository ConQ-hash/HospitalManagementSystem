#!/bin/bash
set -e

# Ensure we run from repo root
cd "$(dirname "$0")"

# Create Directory.Build.props
cat > Directory.Build.props <<'EOF'
<Project>
  <PropertyGroup>
    <!-- Enable nullable reference types -->
    <Nullable>enable</Nullable>

    <!-- Use implicit global using directives -->
    <ImplicitUsings>enable</ImplicitUsings>

    <!-- Use the latest major C# language version -->
    <LangVersion>latestMajor</LangVersion>

    <!-- Enable .NET analyzers -->
    <AnalysisLevel>latestRecommended</AnalysisLevel>

    <!-- Do NOT treat warnings as errors locally -->
    <TreatWarningsAsErrors>false</TreatWarningsAsErrors>
  </PropertyGroup>
</Project>
EOF

echo "✅ Created Directory.Build.props"

# Create Directory.Build.targets for CI-only strictness
cat > Directory.Build.targets <<'EOF'
<Project>
  <PropertyGroup Condition="'$(CI)' == 'true'">
    <!-- Fail the build on warnings in CI -->
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
  </PropertyGroup>
</Project>
EOF

echo "✅ Created Directory.Build.targets (WarningsAsErrors only in CI)"

# Show final structure
echo "📂 Created files in:"
pwd
ls -1 Directory.Build.props Directory.Build.targets
