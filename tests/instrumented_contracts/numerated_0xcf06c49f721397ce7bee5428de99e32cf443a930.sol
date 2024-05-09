1 {{
2   "language": "Solidity",
3   "sources": {
4     "contracts/CLJUpgrader.sol": {
5       "content": "// SPDX-License-Identifier: UNLICENSED\r\npragma solidity ^0.8.13;\r\n\r\ninterface ICLJ{\r\n    function burn(uint _token_id) external;\r\n    function ownerOf(uint256 tokenId) external view returns (address owner);\r\n    function approve(address to, uint256 tokenId) external;\r\n    function safeTransferFrom(address from, address to, uint256 tokenId) external;\r\n}\r\n\r\ncontract CLJUpgrader {\r\n\r\n    event BurnedForUpgrade(uint256 indexed upgradedId, uint256 indexed burnedId);\r\n\r\n    error TokenIdNotOwned();\r\n    error CapReached(uint rank);\r\n    error RequireExactBurnAmount();\r\n    error Reentered();\r\n\r\n    ICLJ public immutable clj;\r\n\r\n    mapping(uint256 => uint256) public tokenUpgradeCount;\r\n    mapping(uint256 => uint256) public rankCount;\r\n\r\n    uint256 immutable SILVER_CAP;\r\n    uint256 immutable GOLD_CAP;\r\n    uint256 immutable PLATINUM_CAP;\r\n    uint256 immutable DIAMOND_CAP;\r\n\r\n    uint8 immutable BRONZE_THRESH = 1;\r\n    uint8 immutable SILVER_THRESH = 2;\r\n    uint8 immutable GOLD_THRESH = 4;\r\n    uint8 immutable PLATINUM_THRESH = 6;\r\n    uint8 immutable DIAMOND_THRESH = 10;\r\n\r\n    uint256 internal _ENTERED = 1;\r\n\r\n    modifier noReenter() {\r\n        if (_ENTERED != 1) revert Reentered();\r\n        _ENTERED = 2;\r\n        _;\r\n        _ENTERED = 1;\r\n    }\r\n\r\n    constructor(uint256[] memory caps){\r\n        clj = ICLJ(0x867ba3C89fB7C8F4d72068859c26d147F5330043);\r\n\r\n        SILVER_CAP = caps[0];\r\n        GOLD_CAP = caps[1];\r\n        PLATINUM_CAP = caps[2];\r\n        DIAMOND_CAP = caps[3];\r\n\r\n        rankCount[DIAMOND_THRESH] = 35;\r\n    }\r\n\r\n    function burnToUpgrade(uint256 tokenIdToUpgrade, uint256[] calldata tokenIdsToBurn)\r\n    external\r\n    noReenter{\r\n\r\n        if (msg.sender != clj.ownerOf(tokenIdToUpgrade)){\r\n                revert TokenIdNotOwned();\r\n        }\r\n\r\n        uint256 sumTokenValues;\r\n\r\n        for (uint i=0; i<tokenIdsToBurn.length; i++){\r\n            uint256 tokenIdToBurn = tokenIdsToBurn[i];\r\n            if (msg.sender != clj.ownerOf(tokenIdToBurn)){\r\n                revert TokenIdNotOwned();\r\n            }\r\n            uint256 tokenCount = tokenUpgradeCount[tokenIdToBurn];\r\n            sumTokenValues += tokenCount + 1;\r\n\r\n            //do this before upgrade, in case a capped rank frees a slot\r\n            decrementCounter(tokenCount);\r\n\r\n            delete tokenUpgradeCount[tokenIdToBurn];\r\n            //breaks checks-effects-interactions-pattern, but should be fine\r\n            clj.burn(tokenIdToBurn);\r\n            emit BurnedForUpgrade(tokenIdToUpgrade, tokenIdToBurn);\r\n        }\r\n        upgradeIfAllowed(tokenIdToUpgrade, sumTokenValues);\r\n    }\r\n\r\n    function decrementCounter(uint256 tokenCount) internal{\r\n        if (tokenCount > 0) {\r\n            --rankCount[tokenCount];\r\n        }\r\n    }\r\n\r\n    function upgradeIfAllowed(uint256 tokenIdToUpgrade, uint256 sumTokenValues) internal{\r\n        uint256 previousCount = tokenUpgradeCount[tokenIdToUpgrade];\r\n        uint256 nextUpgradeCount = previousCount + sumTokenValues;\r\n        if(nextUpgradeCount == BRONZE_THRESH){\r\n            //NOOP\r\n        } else if (nextUpgradeCount == SILVER_THRESH){\r\n            if (rankCount[SILVER_THRESH]+1 > SILVER_CAP) {\r\n                revert CapReached(SILVER_THRESH);\r\n            }\r\n        } else if (nextUpgradeCount == GOLD_THRESH){\r\n            if (rankCount[GOLD_THRESH]+1 > GOLD_CAP) {\r\n                revert CapReached(GOLD_THRESH);\r\n            }\r\n        } else if (nextUpgradeCount == PLATINUM_THRESH){\r\n            if (rankCount[PLATINUM_THRESH]+1 > PLATINUM_CAP) {\r\n                revert CapReached(PLATINUM_THRESH);\r\n            }\r\n        } else if (nextUpgradeCount == DIAMOND_THRESH){\r\n            if (rankCount[DIAMOND_THRESH]+1 > DIAMOND_CAP) {\r\n                revert CapReached(DIAMOND_THRESH);\r\n            }\r\n        } else {\r\n            revert RequireExactBurnAmount();\r\n        }\r\n\r\n        tokenUpgradeCount[tokenIdToUpgrade] = nextUpgradeCount;\r\n        if (previousCount > 0) {\r\n            --rankCount[previousCount];\r\n        }\r\n        ++rankCount[nextUpgradeCount];\r\n    }\r\n}\r\n"
6     }
7   },
8   "settings": {
9     "optimizer": {
10       "enabled": true,
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
24     },
25     "libraries": {}
26   }
27 }}