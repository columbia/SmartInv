{{
  "language": "Solidity",
  "sources": {
    "@synthetixio/core-contracts/contracts/errors/AccessError.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity >=0.8.11 <0.9.0;\n\n/**\n * @title Library for access related errors.\n */\nlibrary AccessError {\n    /**\n     * @dev Thrown when an address tries to perform an unauthorized action.\n     * @param addr The address that attempts the action.\n     */\n    error Unauthorized(address addr);\n}\n"
    },
    "@synthetixio/core-contracts/contracts/errors/AddressError.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity >=0.8.11 <0.9.0;\n\n/**\n * @title Library for address related errors.\n */\nlibrary AddressError {\n    /**\n     * @dev Thrown when a zero address was passed as a function parameter (0x0000000000000000000000000000000000000000).\n     */\n    error ZeroAddress();\n\n    /**\n     * @dev Thrown when an address representing a contract is expected, but no code is found at the address.\n     * @param contr The address that was expected to be a contract.\n     */\n    error NotAContract(address contr);\n}\n"
    },
    "@synthetixio/core-contracts/contracts/ownership/OwnableStorage.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity >=0.8.11 <0.9.0;\n\nimport \"../errors/AccessError.sol\";\n\nlibrary OwnableStorage {\n    bytes32 private constant _SLOT_OWNABLE_STORAGE =\n        keccak256(abi.encode(\"io.synthetix.core-contracts.Ownable\"));\n\n    struct Data {\n        bool initialized;\n        address owner;\n        address nominatedOwner;\n    }\n\n    function load() internal pure returns (Data storage store) {\n        bytes32 s = _SLOT_OWNABLE_STORAGE;\n        assembly {\n            store.slot := s\n        }\n    }\n\n    function onlyOwner() internal view {\n        if (msg.sender != getOwner()) {\n            revert AccessError.Unauthorized(msg.sender);\n        }\n    }\n\n    function getOwner() internal view returns (address) {\n        return OwnableStorage.load().owner;\n    }\n}\n"
    },
    "@synthetixio/core-contracts/contracts/proxy/AbstractProxy.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity >=0.8.11 <0.9.0;\n\nabstract contract AbstractProxy {\n    fallback() external payable {\n        _forward();\n    }\n\n    receive() external payable {\n        _forward();\n    }\n\n    function _forward() internal {\n        address implementation = _getImplementation();\n\n        // solhint-disable-next-line no-inline-assembly\n        assembly {\n            calldatacopy(0, 0, calldatasize())\n\n            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)\n\n            returndatacopy(0, 0, returndatasize())\n\n            switch result\n            case 0 {\n                revert(0, returndatasize())\n            }\n            default {\n                return(0, returndatasize())\n            }\n        }\n    }\n\n    function _getImplementation() internal view virtual returns (address);\n}\n"
    },
    "@synthetixio/core-contracts/contracts/proxy/ProxyStorage.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity >=0.8.11 <0.9.0;\n\ncontract ProxyStorage {\n    bytes32 private constant _SLOT_PROXY_STORAGE =\n        keccak256(abi.encode(\"io.synthetix.core-contracts.Proxy\"));\n\n    struct ProxyStore {\n        address implementation;\n        bool simulatingUpgrade;\n    }\n\n    function _proxyStore() internal pure returns (ProxyStore storage store) {\n        bytes32 s = _SLOT_PROXY_STORAGE;\n        assembly {\n            store.slot := s\n        }\n    }\n}\n"
    },
    "@synthetixio/core-contracts/contracts/proxy/UUPSProxy.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity >=0.8.11 <0.9.0;\n\nimport \"./AbstractProxy.sol\";\nimport \"./ProxyStorage.sol\";\nimport \"../errors/AddressError.sol\";\nimport \"../utils/AddressUtil.sol\";\n\ncontract UUPSProxy is AbstractProxy, ProxyStorage {\n    constructor(address firstImplementation) {\n        if (firstImplementation == address(0)) {\n            revert AddressError.ZeroAddress();\n        }\n\n        if (!AddressUtil.isContract(firstImplementation)) {\n            revert AddressError.NotAContract(firstImplementation);\n        }\n\n        _proxyStore().implementation = firstImplementation;\n    }\n\n    function _getImplementation() internal view virtual override returns (address) {\n        return _proxyStore().implementation;\n    }\n}\n"
    },
    "@synthetixio/core-contracts/contracts/proxy/UUPSProxyWithOwner.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity >=0.8.11 <0.9.0;\n\nimport {UUPSProxy} from \"./UUPSProxy.sol\";\nimport {OwnableStorage} from \"../ownership/OwnableStorage.sol\";\n\ncontract UUPSProxyWithOwner is UUPSProxy {\n    // solhint-disable-next-line no-empty-blocks\n    constructor(address firstImplementation, address initialOwner) UUPSProxy(firstImplementation) {\n        OwnableStorage.load().owner = initialOwner;\n    }\n}\n"
    },
    "@synthetixio/core-contracts/contracts/utils/AddressUtil.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity >=0.8.11 <0.9.0;\n\nlibrary AddressUtil {\n    function isContract(address account) internal view returns (bool) {\n        uint256 size;\n\n        assembly {\n            size := extcodesize(account)\n        }\n\n        return size > 0;\n    }\n}\n"
    },
    "contracts/Proxy.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity 0.8.17;\n\nimport {UUPSProxyWithOwner} from \"@synthetixio/core-contracts/contracts/proxy/UUPSProxyWithOwner.sol\";\n\ncontract Proxy is UUPSProxyWithOwner {\n  // solhint-disable-next-line no-empty-blocks\n  constructor(address firstImplementation, address initialOwner) UUPSProxyWithOwner(firstImplementation, initialOwner) {}\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": false,
      "runs": 200
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    },
    "libraries": {}
  }
}}