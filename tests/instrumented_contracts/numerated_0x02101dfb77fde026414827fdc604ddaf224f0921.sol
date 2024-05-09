1 {{
2   "language": "Solidity",
3   "sources": {
4     "src/ERC6551Registry.sol": {
5       "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.8.0;\n\nimport \"openzeppelin-contracts/utils/Create2.sol\";\n\nimport \"./interfaces/IERC6551Registry.sol\";\nimport \"./lib/ERC6551BytecodeLib.sol\";\n\ncontract ERC6551Registry is IERC6551Registry {\n    error InitializationFailed();\n\n    function createAccount(\n        address implementation,\n        uint256 chainId,\n        address tokenContract,\n        uint256 tokenId,\n        uint256 salt,\n        bytes calldata initData\n    ) external returns (address) {\n        bytes memory code = ERC6551BytecodeLib.getCreationCode(\n            implementation,\n            chainId,\n            tokenContract,\n            tokenId,\n            salt\n        );\n\n        address _account = Create2.computeAddress(bytes32(salt), keccak256(code));\n\n        if (_account.code.length != 0) return _account;\n\n        emit AccountCreated(_account, implementation, chainId, tokenContract, tokenId, salt);\n\n        _account = Create2.deploy(0, bytes32(salt), code);\n\n        if (initData.length != 0) {\n            (bool success, ) = _account.call(initData);\n            if (!success) revert InitializationFailed();\n        }\n\n        return _account;\n    }\n\n    function account(\n        address implementation,\n        uint256 chainId,\n        address tokenContract,\n        uint256 tokenId,\n        uint256 salt\n    ) external view returns (address) {\n        bytes32 bytecodeHash = keccak256(\n            ERC6551BytecodeLib.getCreationCode(\n                implementation,\n                chainId,\n                tokenContract,\n                tokenId,\n                salt\n            )\n        );\n\n        return Create2.computeAddress(bytes32(salt), bytecodeHash);\n    }\n}\n"
6     },
7     "lib/openzeppelin-contracts/contracts/utils/Create2.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.8.0) (utils/Create2.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.\n * `CREATE2` can be used to compute in advance the address where a smart\n * contract will be deployed, which allows for interesting new mechanisms known\n * as 'counterfactual interactions'.\n *\n * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more\n * information.\n */\nlibrary Create2 {\n    /**\n     * @dev Deploys a contract using `CREATE2`. The address where the contract\n     * will be deployed can be known in advance via {computeAddress}.\n     *\n     * The bytecode for a contract can be obtained from Solidity with\n     * `type(contractName).creationCode`.\n     *\n     * Requirements:\n     *\n     * - `bytecode` must not be empty.\n     * - `salt` must have not been used for `bytecode` already.\n     * - the factory must have a balance of at least `amount`.\n     * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.\n     */\n    function deploy(\n        uint256 amount,\n        bytes32 salt,\n        bytes memory bytecode\n    ) internal returns (address addr) {\n        require(address(this).balance >= amount, \"Create2: insufficient balance\");\n        require(bytecode.length != 0, \"Create2: bytecode length is zero\");\n        /// @solidity memory-safe-assembly\n        assembly {\n            addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)\n        }\n        require(addr != address(0), \"Create2: Failed on deploy\");\n    }\n\n    /**\n     * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the\n     * `bytecodeHash` or `salt` will result in a new destination address.\n     */\n    function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {\n        return computeAddress(salt, bytecodeHash, address(this));\n    }\n\n    /**\n     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at\n     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.\n     */\n    function computeAddress(\n        bytes32 salt,\n        bytes32 bytecodeHash,\n        address deployer\n    ) internal pure returns (address addr) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            let ptr := mload(0x40) // Get free memory pointer\n\n            // |                   | ↓ ptr ...  ↓ ptr + 0x0B (start) ...  ↓ ptr + 0x20 ...  ↓ ptr + 0x40 ...   |\n            // |-------------------|---------------------------------------------------------------------------|\n            // | bytecodeHash      |                                                        CCCCCCCCCCCCC...CC |\n            // | salt              |                                      BBBBBBBBBBBBB...BB                   |\n            // | deployer          | 000000...0000AAAAAAAAAAAAAAAAAAA...AA                                     |\n            // | 0xFF              |            FF                                                             |\n            // |-------------------|---------------------------------------------------------------------------|\n            // | memory            | 000000...00FFAAAAAAAAAAAAAAAAAAA...AABBBBBBBBBBBBB...BBCCCCCCCCCCCCC...CC |\n            // | keccak(start, 85) |            ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ |\n\n            mstore(add(ptr, 0x40), bytecodeHash)\n            mstore(add(ptr, 0x20), salt)\n            mstore(ptr, deployer) // Right-aligned with 12 preceding garbage bytes\n            let start := add(ptr, 0x0b) // The hashed data starts at the final garbage byte which we will set to 0xff\n            mstore8(start, 0xff)\n            addr := keccak256(start, 85)\n        }\n    }\n}\n"
9     },
10     "src/interfaces/IERC6551Registry.sol": {
11       "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.8.0;\n\ninterface IERC6551Registry {\n    event AccountCreated(\n        address account,\n        address implementation,\n        uint256 chainId,\n        address tokenContract,\n        uint256 tokenId,\n        uint256 salt\n    );\n\n    function createAccount(\n        address implementation,\n        uint256 chainId,\n        address tokenContract,\n        uint256 tokenId,\n        uint256 seed,\n        bytes calldata initData\n    ) external returns (address);\n\n    function account(\n        address implementation,\n        uint256 chainId,\n        address tokenContract,\n        uint256 tokenId,\n        uint256 salt\n    ) external view returns (address);\n}\n"
12     },
13     "src/lib/ERC6551BytecodeLib.sol": {
14       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nlibrary ERC6551BytecodeLib {\n    function getCreationCode(\n        address implementation_,\n        uint256 chainId_,\n        address tokenContract_,\n        uint256 tokenId_,\n        uint256 salt_\n    ) internal pure returns (bytes memory) {\n        return\n            abi.encodePacked(\n                hex\"3d60ad80600a3d3981f3363d3d373d3d3d363d73\",\n                implementation_,\n                hex\"5af43d82803e903d91602b57fd5bf3\",\n                abi.encode(salt_, chainId_, tokenContract_, tokenId_)\n            );\n    }\n}\n"
15     }
16   },
17   "settings": {
18     "remappings": [
19       "ds-test/=lib/forge-std/lib/ds-test/src/",
20       "forge-std/=lib/forge-std/src/",
21       "openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/",
22       "sstore2/=lib/sstore2/contracts/"
23     ],
24     "optimizer": {
25       "enabled": true,
26       "runs": 200
27     },
28     "metadata": {
29       "bytecodeHash": "ipfs"
30     },
31     "outputSelection": {
32       "*": {
33         "*": [
34           "evm.bytecode",
35           "evm.deployedBytecode",
36           "devdoc",
37           "userdoc",
38           "metadata",
39           "abi"
40         ]
41       }
42     },
43     "evmVersion": "london",
44     "libraries": {}
45   }
46 }}