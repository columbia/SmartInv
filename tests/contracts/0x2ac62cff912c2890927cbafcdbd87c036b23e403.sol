{{
  "language": "Solidity",
  "sources": {
    "lib/solidstate-solidity/contracts/access/ownable/IOwnableInternal.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nimport { IERC173Internal } from '../../interfaces/IERC173Internal.sol';\n\ninterface IOwnableInternal is IERC173Internal {\n    error Ownable__NotOwner();\n    error Ownable__NotTransitiveOwner();\n}\n"
    },
    "lib/solidstate-solidity/contracts/access/ownable/OwnableInternal.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nimport { IERC173 } from '../../interfaces/IERC173.sol';\nimport { AddressUtils } from '../../utils/AddressUtils.sol';\nimport { IOwnableInternal } from './IOwnableInternal.sol';\nimport { OwnableStorage } from './OwnableStorage.sol';\n\nabstract contract OwnableInternal is IOwnableInternal {\n    using AddressUtils for address;\n    using OwnableStorage for OwnableStorage.Layout;\n\n    modifier onlyOwner() {\n        if (msg.sender != _owner()) revert Ownable__NotOwner();\n        _;\n    }\n\n    modifier onlyTransitiveOwner() {\n        if (msg.sender != _transitiveOwner())\n            revert Ownable__NotTransitiveOwner();\n        _;\n    }\n\n    function _owner() internal view virtual returns (address) {\n        return OwnableStorage.layout().owner;\n    }\n\n    function _transitiveOwner() internal view virtual returns (address) {\n        address owner = _owner();\n\n        while (owner.isContract()) {\n            try IERC173(owner).owner() returns (address transitiveOwner) {\n                owner = transitiveOwner;\n            } catch {\n                return owner;\n            }\n        }\n\n        return owner;\n    }\n\n    function _transferOwnership(address account) internal virtual {\n        OwnableStorage.layout().setOwner(account);\n        emit OwnershipTransferred(msg.sender, account);\n    }\n}\n"
    },
    "lib/solidstate-solidity/contracts/access/ownable/OwnableStorage.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nlibrary OwnableStorage {\n    struct Layout {\n        address owner;\n    }\n\n    bytes32 internal constant STORAGE_SLOT =\n        keccak256('solidstate.contracts.storage.Ownable');\n\n    function layout() internal pure returns (Layout storage l) {\n        bytes32 slot = STORAGE_SLOT;\n        assembly {\n            l.slot := slot\n        }\n    }\n\n    function setOwner(Layout storage l, address owner) internal {\n        l.owner = owner;\n    }\n}\n"
    },
    "lib/solidstate-solidity/contracts/interfaces/IERC173.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nimport { IERC173Internal } from './IERC173Internal.sol';\n\n/**\n * @title Contract ownership standard interface\n * @dev see https://eips.ethereum.org/EIPS/eip-173\n */\ninterface IERC173 is IERC173Internal {\n    /**\n     * @notice get the ERC173 contract owner\n     * @return conrtact owner\n     */\n    function owner() external view returns (address);\n\n    /**\n     * @notice transfer contract ownership to new account\n     * @param account address of new owner\n     */\n    function transferOwnership(address account) external;\n}\n"
    },
    "lib/solidstate-solidity/contracts/interfaces/IERC173Internal.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\n/**\n * @title Partial ERC173 interface needed by internal functions\n */\ninterface IERC173Internal {\n    event OwnershipTransferred(\n        address indexed previousOwner,\n        address indexed newOwner\n    );\n}\n"
    },
    "lib/solidstate-solidity/contracts/proxy/IProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\ninterface IProxy {\n    error Proxy__ImplementationIsNotContract();\n\n    fallback() external payable;\n}\n"
    },
    "lib/solidstate-solidity/contracts/proxy/Proxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nimport { AddressUtils } from '../utils/AddressUtils.sol';\nimport { IProxy } from './IProxy.sol';\n\n/**\n * @title Base proxy contract\n */\nabstract contract Proxy is IProxy {\n    using AddressUtils for address;\n\n    /**\n     * @notice delegate all calls to implementation contract\n     * @dev reverts if implementation address contains no code, for compatibility with metamorphic contracts\n     * @dev memory location in use by assembly may be unsafe in other contexts\n     */\n    fallback() external payable virtual {\n        address implementation = _getImplementation();\n\n        if (!implementation.isContract())\n            revert Proxy__ImplementationIsNotContract();\n\n        assembly {\n            calldatacopy(0, 0, calldatasize())\n            let result := delegatecall(\n                gas(),\n                implementation,\n                0,\n                calldatasize(),\n                0,\n                0\n            )\n            returndatacopy(0, 0, returndatasize())\n\n            switch result\n            case 0 {\n                revert(0, returndatasize())\n            }\n            default {\n                return(0, returndatasize())\n            }\n        }\n    }\n\n    /**\n     * @notice get logic implementation address\n     * @return implementation address\n     */\n    function _getImplementation() internal virtual returns (address);\n}\n"
    },
    "lib/solidstate-solidity/contracts/proxy/upgradeable/IUpgradeableProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nimport { IProxy } from '../IProxy.sol';\n\ninterface IUpgradeableProxy is IProxy {}\n"
    },
    "lib/solidstate-solidity/contracts/proxy/upgradeable/IUpgradeableProxyOwnable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nimport { IUpgradeableProxy } from './IUpgradeableProxy.sol';\n\ninterface IUpgradeableProxyOwnable is IUpgradeableProxy {\n    /**\n     * TODO: add to IUpgradeableProxy or remove from here\n     */\n    function setImplementation(address implementation) external;\n}\n"
    },
    "lib/solidstate-solidity/contracts/proxy/upgradeable/UpgradeableProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nimport { Proxy } from '../Proxy.sol';\nimport { IUpgradeableProxy } from './IUpgradeableProxy.sol';\nimport { UpgradeableProxyStorage } from './UpgradeableProxyStorage.sol';\n\n/**\n * @title Proxy with upgradeable implementation\n */\nabstract contract UpgradeableProxy is IUpgradeableProxy, Proxy {\n    using UpgradeableProxyStorage for UpgradeableProxyStorage.Layout;\n\n    /**\n     * @inheritdoc Proxy\n     */\n    function _getImplementation() internal view override returns (address) {\n        // inline storage layout retrieval uses less gas\n        UpgradeableProxyStorage.Layout storage l;\n        bytes32 slot = UpgradeableProxyStorage.STORAGE_SLOT;\n        assembly {\n            l.slot := slot\n        }\n\n        return l.implementation;\n    }\n\n    /**\n     * @notice set logic implementation address\n     * @param implementation implementation address\n     */\n    function _setImplementation(address implementation) internal {\n        UpgradeableProxyStorage.layout().setImplementation(implementation);\n    }\n}\n"
    },
    "lib/solidstate-solidity/contracts/proxy/upgradeable/UpgradeableProxyOwnable.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nimport { OwnableInternal } from '../../access/ownable/OwnableInternal.sol';\nimport { IUpgradeableProxyOwnable } from './IUpgradeableProxyOwnable.sol';\nimport { UpgradeableProxy } from './UpgradeableProxy.sol';\n\n/**\n * @title Proxy with upgradeable implementation controlled by ERC171 owner\n */\nabstract contract UpgradeableProxyOwnable is\n    IUpgradeableProxyOwnable,\n    UpgradeableProxy,\n    OwnableInternal\n{\n    /**\n     * @notice set logic implementation address\n     * @param implementation implementation address\n     */\n    function setImplementation(address implementation) external onlyOwner {\n        _setImplementation(implementation);\n    }\n}\n"
    },
    "lib/solidstate-solidity/contracts/proxy/upgradeable/UpgradeableProxyStorage.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nlibrary UpgradeableProxyStorage {\n    struct Layout {\n        address implementation;\n    }\n\n    bytes32 internal constant STORAGE_SLOT =\n        keccak256('solidstate.contracts.storage.UpgradeableProxy');\n\n    function layout() internal pure returns (Layout storage l) {\n        bytes32 slot = STORAGE_SLOT;\n        assembly {\n            l.slot := slot\n        }\n    }\n\n    function setImplementation(Layout storage l, address implementation)\n        internal\n    {\n        l.implementation = implementation;\n    }\n}\n"
    },
    "lib/solidstate-solidity/contracts/utils/AddressUtils.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\nimport { UintUtils } from './UintUtils.sol';\n\nlibrary AddressUtils {\n    using UintUtils for uint256;\n\n    error AddressUtils__InsufficientBalance();\n    error AddressUtils__NotContract();\n    error AddressUtils__SendValueFailed();\n\n    function toString(address account) internal pure returns (string memory) {\n        return uint256(uint160(account)).toHexString(20);\n    }\n\n    function isContract(address account) internal view returns (bool) {\n        uint256 size;\n        assembly {\n            size := extcodesize(account)\n        }\n        return size > 0;\n    }\n\n    function sendValue(address payable account, uint256 amount) internal {\n        (bool success, ) = account.call{ value: amount }('');\n        if (!success) revert AddressUtils__SendValueFailed();\n    }\n\n    function functionCall(address target, bytes memory data)\n        internal\n        returns (bytes memory)\n    {\n        return\n            functionCall(target, data, 'AddressUtils: failed low-level call');\n    }\n\n    function functionCall(\n        address target,\n        bytes memory data,\n        string memory error\n    ) internal returns (bytes memory) {\n        return _functionCallWithValue(target, data, 0, error);\n    }\n\n    function functionCallWithValue(\n        address target,\n        bytes memory data,\n        uint256 value\n    ) internal returns (bytes memory) {\n        return\n            functionCallWithValue(\n                target,\n                data,\n                value,\n                'AddressUtils: failed low-level call with value'\n            );\n    }\n\n    function functionCallWithValue(\n        address target,\n        bytes memory data,\n        uint256 value,\n        string memory error\n    ) internal returns (bytes memory) {\n        if (value > address(this).balance)\n            revert AddressUtils__InsufficientBalance();\n        return _functionCallWithValue(target, data, value, error);\n    }\n\n    function _functionCallWithValue(\n        address target,\n        bytes memory data,\n        uint256 value,\n        string memory error\n    ) private returns (bytes memory) {\n        if (!isContract(target)) revert AddressUtils__NotContract();\n\n        (bool success, bytes memory returnData) = target.call{ value: value }(\n            data\n        );\n\n        if (success) {\n            return returnData;\n        } else if (returnData.length > 0) {\n            assembly {\n                let returnData_size := mload(returnData)\n                revert(add(32, returnData), returnData_size)\n            }\n        } else {\n            revert(error);\n        }\n    }\n}\n"
    },
    "lib/solidstate-solidity/contracts/utils/UintUtils.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.8;\n\n/**\n * @title utility functions for uint256 operations\n * @dev derived from https://github.com/OpenZeppelin/openzeppelin-contracts/ (MIT license)\n */\nlibrary UintUtils {\n    error UintUtils__InsufficientHexLength();\n\n    bytes16 private constant HEX_SYMBOLS = '0123456789abcdef';\n\n    function add(uint256 a, int256 b) internal pure returns (uint256) {\n        return b < 0 ? sub(a, -b) : a + uint256(b);\n    }\n\n    function sub(uint256 a, int256 b) internal pure returns (uint256) {\n        return b < 0 ? add(a, -b) : a - uint256(b);\n    }\n\n    function toString(uint256 value) internal pure returns (string memory) {\n        if (value == 0) {\n            return '0';\n        }\n\n        uint256 temp = value;\n        uint256 digits;\n\n        while (temp != 0) {\n            digits++;\n            temp /= 10;\n        }\n\n        bytes memory buffer = new bytes(digits);\n\n        while (value != 0) {\n            digits -= 1;\n            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));\n            value /= 10;\n        }\n\n        return string(buffer);\n    }\n\n    function toHexString(uint256 value) internal pure returns (string memory) {\n        if (value == 0) {\n            return '0x00';\n        }\n\n        uint256 length = 0;\n\n        for (uint256 temp = value; temp != 0; temp >>= 8) {\n            unchecked {\n                length++;\n            }\n        }\n\n        return toHexString(value, length);\n    }\n\n    function toHexString(uint256 value, uint256 length)\n        internal\n        pure\n        returns (string memory)\n    {\n        bytes memory buffer = new bytes(2 * length + 2);\n        buffer[0] = '0';\n        buffer[1] = 'x';\n\n        unchecked {\n            for (uint256 i = 2 * length + 1; i > 1; --i) {\n                buffer[i] = HEX_SYMBOLS[value & 0xf];\n                value >>= 4;\n            }\n        }\n\n        if (value != 0) revert UintUtils__InsufficientHexLength();\n\n        return string(buffer);\n    }\n}\n"
    },
    "src/DeadLinkzProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.17;\n\nimport {UpgradeableProxyOwnable} from \"@solidstate-solidity/proxy/upgradeable/UpgradeableProxyOwnable.sol\";\nimport {OwnableStorage} from \"@solidstate-solidity/access/ownable/OwnableStorage.sol\";\n\ncontract DeadLinkzProxy is UpgradeableProxyOwnable {\n    constructor(address implementation) {\n        _setImplementation(implementation);\n        OwnableStorage.layout().owner = msg.sender;\n    }\n\n    /**\n     * @dev suppress compiler warning\n     */\n    receive() external payable {}\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "@erc721a-upgradable/=lib/ERC721A-Upgradeable/contracts/",
      "@solady/=lib/solady/src/",
      "@solidstate-solidity/=lib/solidstate-solidity/contracts/",
      "@std/=lib/forge-std/src/",
      "ERC721A-Upgradeable/=lib/ERC721A-Upgradeable/contracts/",
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/",
      "solady/=lib/solady/src/",
      "solidstate-solidity/=lib/solidstate-solidity/contracts/",
      "solmate/=lib/solady/lib/solmate/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "metadata": {
      "bytecodeHash": "ipfs"
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
    "evmVersion": "london",
    "libraries": {}
  }
}}