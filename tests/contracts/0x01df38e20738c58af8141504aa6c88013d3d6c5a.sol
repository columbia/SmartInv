{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "istanbul",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "none",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "remappings": [],
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    }
  },
  "sources": {
    "contracts/optimistic-ethereum/libraries/resolver/Lib_AddressManager.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity >0.5.0 <0.8.0;\n\n/* Contract Imports */\nimport { Ownable } from \"./Lib_Ownable.sol\";\n\n/**\n * @title Lib_AddressManager\n */\ncontract Lib_AddressManager is Ownable {\n\n    /**********\n     * Events *\n     **********/\n\n    event AddressSet(\n        string _name,\n        address _newAddress\n    );\n\n    /*******************************************\n     * Contract Variables: Internal Accounting *\n     *******************************************/\n\n    mapping (bytes32 => address) private addresses;\n\n\n    /********************\n     * Public Functions *\n     ********************/\n\n    function setAddress(\n        string memory _name,\n        address _address\n    )\n        public\n        onlyOwner\n    {\n        emit AddressSet(_name, _address);\n        addresses[_getNameHash(_name)] = _address;\n    }\n\n    function getAddress(\n        string memory _name\n    )\n        public\n        view\n        returns (address)\n    {\n        return addresses[_getNameHash(_name)];\n    }\n\n\n    /**********************\n     * Internal Functions *\n     **********************/\n\n    function _getNameHash(\n        string memory _name\n    )\n        internal\n        pure\n        returns (\n            bytes32 _hash\n        )\n    {\n        return keccak256(abi.encodePacked(_name));\n    }\n}\n"
    },
    "contracts/optimistic-ethereum/libraries/resolver/Lib_Ownable.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity >0.5.0 <0.8.0;\n\n/**\n * @title Ownable\n * @dev Adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol\n */\nabstract contract Ownable {\n\n    /*************\n     * Variables *\n     *************/\n\n    address public owner;\n\n\n    /**********\n     * Events *\n     **********/\n\n    event OwnershipTransferred(\n        address indexed previousOwner,\n        address indexed newOwner\n    );\n\n\n    /***************\n     * Constructor *\n     ***************/\n\n    constructor() {\n        owner = msg.sender;\n        emit OwnershipTransferred(address(0), owner);\n    }\n\n\n    /**********************\n     * Function Modifiers *\n     **********************/\n\n    modifier onlyOwner() {\n        require(\n            owner == msg.sender,\n            \"Ownable: caller is not the owner\"\n        );\n        _;\n    }\n\n\n    /********************\n     * Public Functions *\n     ********************/\n\n    function renounceOwnership()\n        public\n        virtual\n        onlyOwner\n    {\n        emit OwnershipTransferred(owner, address(0));\n        owner = address(0);\n    }\n\n    function transferOwnership(address _newOwner)\n        public\n        virtual\n        onlyOwner\n    {\n        require(\n            _newOwner != address(0),\n            \"Ownable: new owner cannot be the zero address\"\n        );\n\n        emit OwnershipTransferred(owner, _newOwner);\n        owner = _newOwner;\n    }\n}\n"
    },
    "contracts/optimistic-ethereum/libraries/resolver/Lib_ResolvedDelegateProxy.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity >0.5.0 <0.8.0;\n\n/* Library Imports */\nimport { Lib_AddressManager } from \"./Lib_AddressManager.sol\";\n\n/**\n * @title Lib_ResolvedDelegateProxy\n */\ncontract Lib_ResolvedDelegateProxy {\n\n    /*************\n     * Variables *\n     *************/\n\n    // Using mappings to store fields to avoid overwriting storage slots in the\n    // implementation contract. For example, instead of storing these fields at\n    // storage slot `0` & `1`, they are stored at `keccak256(key + slot)`.\n    // See: https://solidity.readthedocs.io/en/v0.7.0/internals/layout_in_storage.html\n    // NOTE: Do not use this code in your own contract system. \n    //      There is a known flaw in this contract, and we will remove it from the repository\n    //      in the near future. Due to the very limited way that we are using it, this flaw is\n    //      not an issue in our system. \n    mapping (address => string) private implementationName;\n    mapping (address => Lib_AddressManager) private addressManager;\n\n\n    /***************\n     * Constructor *\n     ***************/\n\n    /**\n     * @param _libAddressManager Address of the Lib_AddressManager.\n     * @param _implementationName implementationName of the contract to proxy to.\n     */\n    constructor(\n        address _libAddressManager,\n        string memory _implementationName\n    )\n    {\n        addressManager[address(this)] = Lib_AddressManager(_libAddressManager);\n        implementationName[address(this)] = _implementationName;\n    }\n\n\n    /*********************\n     * Fallback Function *\n     *********************/\n\n    fallback()\n        external\n        payable\n    {\n        address target = addressManager[address(this)].getAddress(\n            (implementationName[address(this)])\n        );\n\n        require(\n            target != address(0),\n            \"Target address must be initialized.\"\n        );\n\n        (bool success, bytes memory returndata) = target.delegatecall(msg.data);\n\n        if (success == true) {\n            assembly {\n                return(add(returndata, 0x20), mload(returndata))\n            }\n        } else {\n            assembly {\n                revert(add(returndata, 0x20), mload(returndata))\n            }\n        }\n    }\n}\n"
    }
  }
}}