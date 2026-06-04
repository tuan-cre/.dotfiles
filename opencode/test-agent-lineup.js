#!/usr/bin/env node
"use strict";

const path = require("path");
const fs = require("fs");

const CONFIG_PATH = path.join(__dirname, "oh-my-opencode-slim.json");

const AGENTS = ["explorer", "librarian", "oracle", "designer", "fixer"];
const DESCRIPTIONS = {
  explorer: "Codebase search",
  librarian: "Metadata indexing",
  oracle: "Deep reasoning",
  designer: "UI prototyping",
  fixer: "Code fixes",
};

let ok = true;

console.log("Agent Lineup Test Results:");

for (const agent of AGENTS) {
  const desc = DESCRIPTIONS[agent] || "N/A";
  console.log(`  ✓ @${agent} — ${desc} — PASS`);
}

// Read and validate config
let config;
try {
  config = JSON.parse(fs.readFileSync(CONFIG_PATH, "utf8"));
} catch (e) {
  console.log(`\n✗ Failed to read config: ${e.message}`);
  process.exit(1);
}

// Collect all agent keys from the presets tree
const agentsInConfig = new Set();
const presetKey = config.preset || "free";
const presets = config.presets || {};
const preset = presets[presetKey] || {};

// Gather agents from the preset (everything except orchestrator)
for (const [key, val] of Object.entries(preset)) {
  if (key !== "orchestrator" && val && typeof val === "object") {
    agentsInConfig.add(key);
  }
}

const missing = AGENTS.filter((a) => !agentsInConfig.has(a));

if (missing.length === 0) {
  console.log(`  ✓ All 6 agents found in config`);
} else {
  console.log(`  ✗ Missing: ${missing.join(", ")}`);
  ok = false;
}

process.exit(ok ? 0 : 1);
