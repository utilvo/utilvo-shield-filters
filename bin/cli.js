#!/usr/bin/env node
"use strict";

const { parseAbpRule, isHostBlocked, FILTER_LIST_URL, SHIELD_HOMEPAGE } = require("../index.js");

const args = process.argv.slice(2);
if (args.length === 0 || args.includes("--help") || args.includes("-h")) {
  console.log("utilvo-shield-filters CLI");
  console.log("Usage:");
  console.log("  utilvo-shield-filters parse \"||01counter.com^$third-party\"");
  console.log("  utilvo-shield-filters check <hostname> <blocked-domain-1,blocked-domain-2>");
  console.log(`Filter list: ${FILTER_LIST_URL}`);
  console.log(`Homepage:    ${SHIELD_HOMEPAGE}`);
  process.exit(0);
}

const cmd = args[0];
if (cmd === "parse" && args[1]) {
  const res = parseAbpRule(args[1]);
  console.log(JSON.stringify(res));
} else if (cmd === "check" && args[1] && args[2]) {
  const set = new Set(args[2].split(",").map((s) => s.trim().toLowerCase()).filter(Boolean));
  console.log(JSON.stringify({ hostname: args[1], blocked: isHostBlocked(args[1], set) }));
} else {
  console.error("Invalid arguments. Run with --help for usage.");
  process.exit(1);
}
