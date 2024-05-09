1 {{
2   "language": "Solidity",
3   "sources": {
4     "fq.sol": {
5       "content": "/**\r\n *Submitted for verification at Etherscan.io on 2022-06-24\r\n*/\r\n\r\ncontract FlipTest {\r\n    bool paused;\r\n\r\n    function setPaused(bool _state) external {\r\n        paused = _state;\r\n    }\r\n\r\n    function testMint(uint32 bot_type) external{\r\n      require(!paused);\r\n    }\r\n}"
6     }
7   },
8   "settings": {
9     "optimizer": {
10       "enabled": false,
11       "runs": 200
12     },
13     "outputSelection": {
14       "*": {
15         "*": [
16           "evm.bytecode",
17           "evm.deployedBytecode",
18           "devdoc",
19           "userdoc",
20           "metadata",
21           "abi"
22         ]
23       }
24     }
25   }
26 }}