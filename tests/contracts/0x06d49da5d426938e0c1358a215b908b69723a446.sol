{{
  "language": "Solidity",
  "sources": {
    "fq.sol": {
      "content": "/**\r\n *Submitted for verification at Etherscan.io on 2022-06-24\r\n*/\r\n\r\ncontract FlipTest {\r\n    bool paused;\r\n\r\n    function setPaused(bool _state) external {\r\n        paused = _state;\r\n    }\r\n\r\n    function testMint(uint32 bot_type) external{\r\n      require(!paused);\r\n    }\r\n}"
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