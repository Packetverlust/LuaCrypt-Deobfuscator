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

const fkey = content.match(
    /local\s+gg\s*=\s*\((\d+)-(\d+)\)/
);

if (!fkey) {
    throw new Error("Could not find LuaCrypt key.");
}

const key =
    Number(fkey[1]) -
    Number(fkey[2]);

console.log("Key:", key);

const ftbl = content.match(
    /local\s+e\s*=\s*\{([\s\S]*?)\}/
);

if (!ftbl) {
    throw new Error("Could not find encrypted table.");
}

const chars = [];

const regex = /\((\d+)-(\d+)\)/g;
let match;

while ((match = regex.exec(ftbl[1])) !== null) {
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
