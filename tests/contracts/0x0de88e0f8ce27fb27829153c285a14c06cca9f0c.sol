{{
  "language": "Solidity",
  "sources": {
    "contracts/KeenysFlipTest.sol": {
      "content": "/**\r\n*/\r\n//  I WROTE THIS BTW :keeny:\r\n\r\ncontract KeenysFlipTest {\r\n    bool paused;\r\n    \r\n    function setPaused(bool _state) external {\r\n        paused = _state;\r\n    }\r\n\r\n    function testMint(uint32 bot_type) external{\r\n      require(!paused);\r\n    }\r\n}"
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
    }
  }
}}