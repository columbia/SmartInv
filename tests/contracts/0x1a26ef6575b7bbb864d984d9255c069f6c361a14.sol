{{
  "language": "Solidity",
  "sources": {
    "contracts/libraries/Proxy__L1LiquidityPool.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity 0.7.6;\n\n/**\n * @title Lib_ResolvedDelegateProxy\n */\ncontract Proxy__L1LiquidityPoolArguments {\n\n    /*************\n     * Variables *\n     *************/\n\n    mapping(string => address) public addressManager;\n\n    /***************\n     * Constructor *\n     ***************/\n\n    /**\n     * @param _proxyTarget Address of the target contract.\n     */\n    constructor(\n        address _proxyTarget\n    ) {\n        addressManager[\"proxyTarget\"] = _proxyTarget;\n        addressManager[\"proxyOwner\"] = msg.sender;\n    }\n\n    /**********************\n     * Function Modifiers *\n     **********************/\n\n    modifier proxyCallIfNotOwner() {\n        if (msg.sender == addressManager[\"proxyOwner\"]) {\n            _;\n        } else {\n            // This WILL halt the call frame on completion.\n            _doProxyCall();\n        }\n    }\n\n    /*********************\n     * Fallback Function *\n     *********************/\n\n    fallback()\n        external\n        payable\n    {\n        // Proxy call by default.\n        _doProxyCall();\n    }\n\n    /********************\n     * Public Functions *\n     ********************/\n\n    /**\n     * Update target\n     *\n     * @param _proxyTarget address of proxy target contract\n     */\n    function setTargetContract(\n        address _proxyTarget\n    )\n        proxyCallIfNotOwner\n        external\n    {\n        addressManager[\"proxyTarget\"] = _proxyTarget;\n    }\n\n    /**\n     * Transfer owner\n     */\n    function transferProxyOwnership()\n        proxyCallIfNotOwner\n        external\n    {\n        addressManager[\"proxyOwner\"] = msg.sender;\n    }\n\n    /**\n     * Performs the proxy call via a delegatecall.\n     */\n    function _doProxyCall()\n        internal\n    {\n\n        require(\n            addressManager[\"proxyOwner\"] != address(0),\n            \"Target address must be initialized.\"\n        );\n\n        (bool success, bytes memory returndata) = addressManager[\"proxyTarget\"].delegatecall(msg.data);\n\n        if (success == true) {\n            assembly {\n                return(add(returndata, 0x20), mload(returndata))\n            }\n        } else {\n            assembly {\n                revert(add(returndata, 0x20), mload(returndata))\n            }\n        }\n    }\n}\n"
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
          "abi"
        ]
      }
    },
    "metadata": {
      "useLiteralContent": true
    },
    "libraries": {}
  }
}}