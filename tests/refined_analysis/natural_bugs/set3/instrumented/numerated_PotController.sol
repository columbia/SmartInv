1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 import "../library/WhitelistUpgradeable.sol";
6 import "../library/PausableUpgradeable.sol";
7 import "../library/SortitionSumTreeFactory.sol";
8 
9 import "../interfaces/IPotController.sol";
10 import "../interfaces/IRNGenerator.sol";
11 
12 
13 contract PotController is IPotController, PausableUpgradeable, WhitelistUpgradeable {
14     using SortitionSumTreeFactory for SortitionSumTreeFactory.SortitionSumTrees;
15 
16     /* ========== CONSTANT ========== */
17 
18     uint constant private MAX_TREE_LEAVES = 5;
19     IRNGenerator constant private RNGenerator = IRNGenerator(0x2Eb45a1017e9E0793E05aaF0796298d9b871eCad);
20 
21     /* ========== STATE VARIABLES ========== */
22 
23     SortitionSumTreeFactory.SortitionSumTrees private _sortitionSumTree;
24     bytes32 private _requestId;  // random number
25 
26     uint internal _randomness;
27     uint public potId;
28     uint public startedAt;
29 
30     /* ========== MODIFIERS ========== */
31 
32     modifier onlyRandomGenerator() {
33         require(msg.sender == address(RNGenerator), "Only random generator");
34         _;
35     }
36 
37     /* ========== INTERNAL FUNCTIONS ========== */
38 
39     function createTree(bytes32 key) internal {
40         _sortitionSumTree.createTree(key, MAX_TREE_LEAVES);
41     }
42 
43     function getWeight(bytes32 key, bytes32 _ID) internal view returns (uint) {
44         return _sortitionSumTree.stakeOf(key, _ID);
45     }
46 
47     function setWeight(bytes32 key, uint weight, bytes32 _ID) internal {
48         _sortitionSumTree.set(key, weight, _ID);
49     }
50 
51     function draw(bytes32 key, uint randomNumber) internal returns (address) {
52         return address(uint(_sortitionSumTree.draw(key, randomNumber)));
53     }
54 
55     function getRandomNumber(uint weight) internal {
56         _requestId = RNGenerator.getRandomNumber(potId, weight);
57     }
58 
59     /* ========== CALLBACK FUNCTIONS ========== */
60 
61     function numbersDrawn(uint _potId, bytes32 requestId, uint randomness) override external onlyRandomGenerator {
62         if (_requestId == requestId && potId == _potId) {
63             _randomness = randomness;
64         }
65     }
66 }
