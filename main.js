const fs = require("fs");

const input = process.argv[2];
const output = process.argv[3] || "deobfuscated.lua";

if (!input) {
    process.exit(1);
}

const content = fs.readFileSync(input, "utf8");

function xor(a, b) {
    let result = 0;
    let bit = 1;

    while (a > 0 || b > 0) {
        const abit = a % 2;
        const bbit = b % 2;

        if (abit !== bbit) {
            result += bit;
        }

        a = Math.floor(a / 2);
        b = Math.floor(b / 2);
        bit *= 2;
    }

    return result;
}

const keyRegex = /local\s+[A-Za-z_][A-Za-z0-9_]*\s*=\s*\((\d+)-(\d+)\)/g;
const tableRegex = /local\s+[A-Za-z_][A-Za-z0-9_]*\s*=\s*\{([\s\S]*?)\}/g;

let keyMatch = null;
let tempMatch;
while ((tempMatch = keyRegex.exec(content)) !== null) {
    keyMatch = tempMatch;
    break;
}

if (!keyMatch) {
    throw new Error("Could not find LuaCrypt key.");
}

const key =
    Number(keyMatch[1]) -
    Number(keyMatch[2]);

let tableMatch = null;
while ((tempMatch = tableRegex.exec(content)) !== null) {
    if (/\((\d+)-(\d+)\)/.test(tempMatch[1])) {
        tableMatch = tempMatch;
        break;
    }
}

if (!tableMatch) {
    throw new Error("Could not find encrypted table.");
}

const chars = [];

const regex = /\((\d+)-(\d+)\)/g;
let match;

while ((match = regex.exec(tableMatch[1])) !== null) {
    const value =
        Number(match[1]) -
        Number(match[2]);

    chars.push(
        String.fromCharCode(
            xor(value, key)
        )
    );
}

const result = chars.join("");

fs.writeFileSync(output, result);

console.log("Saved:", output);
