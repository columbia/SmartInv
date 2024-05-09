1 {{
2   "language": "Solidity",
3   "settings": {
4     "evmVersion": "berlin",
5     "libraries": {},
6     "metadata": {
7       "bytecodeHash": "none"
8     },
9     "optimizer": {
10       "details": {
11         "constantOptimizer": true,
12         "cse": true,
13         "deduplicate": true,
14         "jumpdestRemover": true,
15         "orderLiterals": false,
16         "peephole": true,
17         "yul": false
18       },
19       "runs": 256
20     },
21     "remappings": [],
22     "outputSelection": {
23       "*": {
24         "*": [
25           "evm.bytecode",
26           "evm.deployedBytecode",
27           "abi"
28         ]
29       }
30     }
31   },
32   "sources": {
33     "@NutBerry/NutBerry/src/tsm/contracts/NutBerryEvents.sol": {
34       "content": "// SPDX-License-Identifier: Unlicense\npragma solidity >=0.7.6;\n\n/// @notice Contains event declarations related to NutBerry.\n// Audit-1: ok\ninterface NutBerryEvents {\n  event BlockBeacon();\n  event CustomBlockBeacon();\n  event NewSolution();\n  event RollupUpgrade(address target);\n}\n"
35     },
36     "src/rollup/contracts/RollupProxy.sol": {
37       "content": "// SPDX-License-Identifier: Unlicense\npragma solidity >=0.7.6;\n\nimport '@NutBerry/NutBerry/src/tsm/contracts/NutBerryEvents.sol';\n\n/// @notice Callforwarding proxy\n// Audit-1: ok\ncontract RollupProxy is NutBerryEvents {\n  constructor (address initialImplementation) {\n    assembly {\n      // stores the initial contract address to forward calls\n      sstore(not(returndatasize()), initialImplementation)\n      // created at block - a hint for clients to know from which block to start syncing events\n      sstore(0x319a610c8254af7ecb1f669fb64fa36285b80cad26faf7087184ce1dceb114df, number())\n    }\n    // emit upgrade event\n    emit NutBerryEvents.RollupUpgrade(initialImplementation);\n  }\n\n  fallback () external payable {\n    assembly {\n      // copy all calldata into memory - returndatasize() is a substitute for `0`\n      calldatacopy(returndatasize(), returndatasize(), calldatasize())\n      // keep a copy to be used after the call\n      let zero := returndatasize()\n      // call contract address loaded from storage slot with key `uint256(-1)`\n      let success := delegatecall(\n        gas(),\n        sload(not(returndatasize())),\n        returndatasize(),\n        calldatasize(),\n        returndatasize(),\n        returndatasize()\n      )\n\n      // copy all return data into memory\n      returndatacopy(zero, zero, returndatasize())\n\n      // if the delegatecall succeeded, then return\n      if success {\n        return(zero, returndatasize())\n      }\n      // else revert\n      revert(zero, returndatasize())\n    }\n  }\n}\n"
38     }
39   }
40 }}