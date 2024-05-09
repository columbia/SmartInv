1 {{
2   "language": "Solidity",
3   "sources": {
4     "@pie-dao/proxy/contracts/PProxy.sol": {
5       "content": "pragma solidity ^0.7.1;\r\n\r\nimport \"./PProxyStorage.sol\";\r\n\r\ncontract PProxy is PProxyStorage {\r\n\r\n    bytes32 constant IMPLEMENTATION_SLOT = keccak256(abi.encodePacked(\"IMPLEMENTATION_SLOT\"));\r\n    bytes32 constant OWNER_SLOT = keccak256(abi.encodePacked(\"OWNER_SLOT\"));\r\n\r\n    modifier onlyProxyOwner() {\r\n        require(msg.sender == readAddress(OWNER_SLOT), \"PProxy.onlyProxyOwner: msg sender not owner\");\r\n        _;\r\n    }\r\n\r\n    constructor () public {\r\n        setAddress(OWNER_SLOT, msg.sender);\r\n    }\r\n\r\n    function getProxyOwner() public view returns (address) {\r\n       return readAddress(OWNER_SLOT);\r\n    }\r\n\r\n    function setProxyOwner(address _newOwner) onlyProxyOwner public {\r\n        setAddress(OWNER_SLOT, _newOwner);\r\n    }\r\n\r\n    function getImplementation() public view returns (address) {\r\n        return readAddress(IMPLEMENTATION_SLOT);\r\n    }\r\n\r\n    function setImplementation(address _newImplementation) onlyProxyOwner public {\r\n        setAddress(IMPLEMENTATION_SLOT, _newImplementation);\r\n    }\r\n\r\n\r\n    fallback () external payable {\r\n       return internalFallback();\r\n    }\r\n\r\n    function internalFallback() internal virtual {\r\n        address contractAddr = readAddress(IMPLEMENTATION_SLOT);\r\n        assembly {\r\n            let ptr := mload(0x40)\r\n            calldatacopy(ptr, 0, calldatasize())\r\n            let result := delegatecall(gas(), contractAddr, ptr, calldatasize(), 0, 0)\r\n            let size := returndatasize()\r\n            returndatacopy(ptr, 0, size)\r\n\r\n            switch result\r\n            case 0 { revert(ptr, size) }\r\n            default { return(ptr, size) }\r\n        }\r\n    }\r\n\r\n}"
6     },
7     "@pie-dao/proxy/contracts/PProxyStorage.sol": {
8       "content": "pragma solidity ^0.7.1;\r\n\r\ncontract PProxyStorage {\r\n\r\n    function readBool(bytes32 _key) public view returns(bool) {\r\n        return storageRead(_key) == bytes32(uint256(1));\r\n    }\r\n\r\n    function setBool(bytes32 _key, bool _value) internal {\r\n        if(_value) {\r\n            storageSet(_key, bytes32(uint256(1)));\r\n        } else {\r\n            storageSet(_key, bytes32(uint256(0)));\r\n        }\r\n    }\r\n\r\n    function readAddress(bytes32 _key) public view returns(address) {\r\n        return bytes32ToAddress(storageRead(_key));\r\n    }\r\n\r\n    function setAddress(bytes32 _key, address _value) internal {\r\n        storageSet(_key, addressToBytes32(_value));\r\n    }\r\n\r\n    function storageRead(bytes32 _key) public view returns(bytes32) {\r\n        bytes32 value;\r\n        //solium-disable-next-line security/no-inline-assembly\r\n        assembly {\r\n            value := sload(_key)\r\n        }\r\n        return value;\r\n    }\r\n\r\n    function storageSet(bytes32 _key, bytes32 _value) internal {\r\n        // targetAddress = _address;  // No!\r\n        bytes32 implAddressStorageKey = _key;\r\n        //solium-disable-next-line security/no-inline-assembly\r\n        assembly {\r\n            sstore(implAddressStorageKey, _value)\r\n        }\r\n    }\r\n\r\n    function bytes32ToAddress(bytes32 _value) public pure returns(address) {\r\n        return address(uint160(uint256(_value)));\r\n    }\r\n\r\n    function addressToBytes32(address _value) public pure returns(bytes32) {\r\n        return bytes32(uint256(_value));\r\n    }\r\n\r\n}"
9     }
10   },
11   "settings": {
12     "optimizer": {
13       "enabled": true,
14       "runs": 200
15     },
16     "outputSelection": {
17       "*": {
18         "*": [
19           "evm.bytecode",
20           "evm.deployedBytecode",
21           "abi"
22         ]
23       }
24     },
25     "metadata": {
26       "useLiteralContent": true
27     },
28     "libraries": {}
29   }
30 }}