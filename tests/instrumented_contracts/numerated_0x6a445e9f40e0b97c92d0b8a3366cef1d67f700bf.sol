1 {{
2   "language": "Solidity",
3   "settings": {
4     "evmVersion": "istanbul",
5     "libraries": {
6       "solc_0.7/proxy/EIP173Proxy.sol:EIP173Proxy": {
7         "Accountant": "0x22225d74Bab7E0c7232864EaA0F143B30C811481"
8       }
9     },
10     "metadata": {
11       "bytecodeHash": "ipfs",
12       "useLiteralContent": true
13     },
14     "optimizer": {
15       "enabled": true,
16       "runs": 2000
17     },
18     "remappings": [],
19     "outputSelection": {
20       "*": {
21         "*": [
22           "evm.bytecode",
23           "evm.deployedBytecode",
24           "abi"
25         ]
26       }
27     }
28   },
29   "sources": {
30     "solc_0.7/proxy/EIP173Proxy.sol": {
31       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.7.0;\n\nimport \"./Proxy.sol\";\n\ninterface ERC165 {\n    function supportsInterface(bytes4 id) external view returns (bool);\n}\n\n///@notice Proxy implementing EIP173 for ownership management\ncontract EIP173Proxy is Proxy {\n    // ////////////////////////// EVENTS ///////////////////////////////////////////////////////////////////////\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    // /////////////////////// CONSTRUCTOR //////////////////////////////////////////////////////////////////////\n\n    constructor(\n        address implementationAddress,\n        bytes memory data,\n        address ownerAddress\n    ) {\n        _setImplementation(implementationAddress, data);\n        _setOwner(ownerAddress);\n    }\n\n    // ///////////////////// EXTERNAL ///////////////////////////////////////////////////////////////////////////\n\n    function owner() external view returns (address) {\n        return _owner();\n    }\n\n    function supportsInterface(bytes4 id) external view returns (bool) {\n        if (id == 0x01ffc9a7 || id == 0x7f5828d0) {\n            return true;\n        }\n        if (id == 0xFFFFFFFF) {\n            return false;\n        }\n\n        ERC165 implementation;\n        // solhint-disable-next-line security/no-inline-assembly\n        assembly {\n            implementation := sload(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc)\n        }\n\n        // This technically is not standard compliant as it ERC-165 require 30,000 gas which that call cannot ensure, since it is itself inside `supportsInterface`\n        // in practise this is unlikely to be an issue\n        try implementation.supportsInterface(id) returns (bool support) {\n            return support;\n        } catch {\n            return false;\n        }\n    }\n\n    function transferOwnership(address newOwner) external onlyOwner {\n        _setOwner(newOwner);\n    }\n\n    function changeImplementation(address newImplementation, bytes calldata data) external onlyOwner {\n        _setImplementation(newImplementation, data);\n    }\n\n    // /////////////////////// MODIFIERS ////////////////////////////////////////////////////////////////////////\n\n    modifier onlyOwner() {\n        require(msg.sender == _owner(), \"NOT_AUTHORIZED\");\n        _;\n    }\n\n    // ///////////////////////// INTERNAL //////////////////////////////////////////////////////////////////////\n\n    function _owner() internal view returns (address adminAddress) {\n        // solhint-disable-next-line security/no-inline-assembly\n        assembly {\n            adminAddress := sload(0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103)\n        }\n    }\n\n    function _setOwner(address newOwner) internal {\n        address previousOwner = _owner();\n        // solhint-disable-next-line security/no-inline-assembly\n        assembly {\n            sstore(0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103, newOwner)\n        }\n        emit OwnershipTransferred(previousOwner, newOwner);\n    }\n}\n"
32     },
33     "solc_0.7/proxy/Proxy.sol": {
34       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.7.0;\n\n// EIP-1967\nabstract contract Proxy {\n    // /////////////////////// EVENTS ///////////////////////////////////////////////////////////////////////////\n\n    event ProxyImplementationUpdated(address indexed previousImplementation, address indexed newImplementation);\n\n    // ///////////////////// EXTERNAL ///////////////////////////////////////////////////////////////////////////\n\n    receive() external payable {\n        _fallback();\n    }\n\n    fallback() external payable {\n        _fallback();\n    }\n\n    // ///////////////////////// INTERNAL //////////////////////////////////////////////////////////////////////\n\n    function _fallback() internal {\n        // solhint-disable-next-line security/no-inline-assembly\n        assembly {\n            let implementationAddress := sload(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc)\n            calldatacopy(0x0, 0x0, calldatasize())\n            let success := delegatecall(gas(), implementationAddress, 0x0, calldatasize(), 0, 0)\n            let retSz := returndatasize()\n            returndatacopy(0, 0, retSz)\n            switch success\n                case 0 {\n                    revert(0, retSz)\n                }\n                default {\n                    return(0, retSz)\n                }\n        }\n    }\n\n    function _setImplementation(address newImplementation, bytes memory data) internal {\n        address previousImplementation;\n        // solhint-disable-next-line security/no-inline-assembly\n        assembly {\n            previousImplementation := sload(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc)\n        }\n\n        // solhint-disable-next-line security/no-inline-assembly\n        assembly {\n            sstore(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, newImplementation)\n        }\n\n        emit ProxyImplementationUpdated(previousImplementation, newImplementation);\n\n        if (data.length > 0) {\n            (bool success, ) = newImplementation.delegatecall(data);\n            if (!success) {\n                assembly {\n                    // This assembly ensure the revert contains the exact string data\n                    let returnDataSize := returndatasize()\n                    returndatacopy(0, 0, returnDataSize)\n                    revert(0, returnDataSize)\n                }\n            }\n        }\n    }\n}\n"
35     }
36   }
37 }}