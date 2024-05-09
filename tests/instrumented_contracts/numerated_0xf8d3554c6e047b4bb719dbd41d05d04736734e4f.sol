1 {{
2   "language": "Solidity",
3   "sources": {
4     "UMADBRO.sol": {
5       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nimport \"./libraries/DiamondCloneMinimalLib.sol\";\n\n// Contract Author: https://juicelabs.io \n\n// \n\nerror FunctionDoesNotExist();\n\ncontract UMADBRO {\n    event OwnershipTransferred(\n        address indexed previousOwner,\n        address indexed newOwner\n    );\n\n    constructor(address sawAddress, address[] memory facetAddresses) {\n        // set the owner\n        DiamondCloneMinimalLib.accessControlStorage()._owner = msg.sender;\n        emit OwnershipTransferred(address(0), msg.sender);\n\n        // First facet should be the diamondFacet\n        (, bytes memory err) = facetAddresses[0].delegatecall(\n            abi.encodeWithSelector(\n                0xf44a9d52, // initializeDiamondClone Selector\n                sawAddress,\n                facetAddresses\n            )\n        );\n        if (err.length > 0) {\n            revert(string(err));\n        }\n    }\n\n    // Find facet for function that is called and execute the\n    // function if a facet is found and return any value.\n    fallback() external payable {\n        // retrieve the facet address\n        address facet = DiamondCloneMinimalLib._getFacetAddressForCall();\n\n        // check if the facet address exists on the saw AND is included in our local cut\n        if (facet == address(0)) revert FunctionDoesNotExist();\n\n        // Execute external function from facet using delegatecall and return any value.\n        assembly {\n            // copy function selector and any arguments\n            calldatacopy(0, 0, calldatasize())\n            // execute function call using the facet\n            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)\n            // get any return value\n            returndatacopy(0, 0, returndatasize())\n            // return any return value or error back to the caller\n            switch result\n            case 0 {\n                revert(0, returndatasize())\n            }\n            default {\n                return(0, returndatasize())\n            }\n        }\n    }\n\n    receive() external payable {}\n}\n"
6     },
7     "libraries/DiamondCloneMinimalLib.sol": {
8       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nerror FailedToFetchFacet();\n\n// minimal inline subset of the full DiamondCloneLib to reduce deployment gas costs\nlibrary DiamondCloneMinimalLib {\n    bytes32 constant DIAMOND_CLONE_STORAGE_POSITION =\n        keccak256(\"diamond.standard.diamond.clone.storage\");\n    bytes32 constant ACCESS_CONTROL_STORAGE_POSITION =\n        keccak256(\"Access.Control.library.storage\");\n\n    struct DiamondCloneStorage {\n        // address of the diamond saw contract\n        address diamondSawAddress;\n        // mapping to all the facets this diamond implements.\n        mapping(address => bool) facetAddresses;\n        // gas cache\n        mapping(bytes4 => address) selectorGasCache;\n    }\n\n    struct AccessControlStorage {\n        address _owner;\n    }\n\n    function diamondCloneStorage()\n        internal\n        pure\n        returns (DiamondCloneStorage storage s)\n    {\n        bytes32 position = DIAMOND_CLONE_STORAGE_POSITION;\n        assembly {\n            s.slot := position\n        }\n    }\n\n    // calls externally to the saw to find the appropriate facet to delegate to\n    function _getFacetAddressForCall() internal view returns (address addr) {\n        DiamondCloneStorage storage s = diamondCloneStorage();\n\n        addr = s.selectorGasCache[msg.sig];\n        if (addr != address(0)) {\n            return addr;\n        }\n\n        (bool success, bytes memory res) = s.diamondSawAddress.staticcall(\n            abi.encodeWithSelector(0x14bc7560, msg.sig) // facetAddressForSelector\n        );\n\n        if (!success) revert FailedToFetchFacet();\n\n        assembly {\n            addr := mload(add(res, 32))\n        }\n\n        return s.facetAddresses[addr] ? addr : address(0);\n    }\n\n    function accessControlStorage()\n        internal\n        pure\n        returns (AccessControlStorage storage s)\n    {\n        bytes32 position = ACCESS_CONTROL_STORAGE_POSITION;\n        assembly {\n            s.slot := position\n        }\n    }\n}\n"
9     }
10   },
11   "settings": {
12     "optimizer": {
13       "enabled": false,
14       "runs": 200
15     },
16     "outputSelection": {
17       "*": {
18         "*": [
19           "evm.bytecode",
20           "evm.deployedBytecode",
21           "devdoc",
22           "userdoc",
23           "metadata",
24           "abi"
25         ]
26       }
27     }
28   }
29 }}