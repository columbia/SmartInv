1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 import "@openzeppelin/contracts/math/Math.sol";
6 
7 library SortitionSumTreeFactory {
8 
9     struct SortitionSumTree {
10         uint K;
11         uint[] stack;
12         uint[] nodes;
13         mapping(bytes32 => uint) IDsToNodeIndexes;
14         mapping(uint => bytes32) nodeIndexesToIDs;
15     }
16 
17     /* ========== STATE VARIABLES ========== */
18 
19     struct SortitionSumTrees {
20         mapping(bytes32 => SortitionSumTree) sortitionSumTrees;
21     }
22 
23     /* ========== PUBLIC FUNCTIONS ========== */
24 
25     function createTree(SortitionSumTrees storage self, bytes32 _key, uint _K) public {
26         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
27         require(_K > 1, "K must be greater than one.");
28         tree.K = _K;
29         tree.stack = new uint[](0);
30         tree.nodes = new uint[](0);
31         tree.nodes.push(0);
32     }
33 
34     function set(SortitionSumTrees storage self, bytes32 _key, uint _value, bytes32 _ID) public {
35         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
36         uint treeIndex = Math.min(tree.IDsToNodeIndexes[_ID], tree.nodes.length - 1);
37 
38         if (treeIndex == 0) {
39             if (_value != 0) {
40                 if (tree.stack.length == 0) {
41                     treeIndex = tree.nodes.length;
42                     tree.nodes.push(_value);
43 
44                     if (treeIndex != 1 && (treeIndex - 1) % tree.K == 0) {
45                         uint parentIndex = treeIndex / tree.K;
46                         bytes32 parentID = tree.nodeIndexesToIDs[parentIndex];
47                         uint newIndex = treeIndex + 1;
48                         tree.nodes.push(tree.nodes[parentIndex]);
49                         delete tree.nodeIndexesToIDs[parentIndex];
50                         tree.IDsToNodeIndexes[parentID] = newIndex;
51                         tree.nodeIndexesToIDs[newIndex] = parentID;
52                     }
53                 } else {
54                     treeIndex = tree.stack[tree.stack.length - 1];
55                     tree.stack.pop();
56                     tree.nodes[treeIndex] = _value;
57                 }
58 
59                 tree.IDsToNodeIndexes[_ID] = treeIndex;
60                 tree.nodeIndexesToIDs[treeIndex] = _ID;
61 
62                 updateParents(self, _key, treeIndex, true, _value);
63             }
64         } else {
65             if (_value == 0) {
66                 uint value = tree.nodes[treeIndex];
67                 tree.nodes[treeIndex] = 0;
68 
69                 tree.stack.push(treeIndex);
70 
71                 delete tree.IDsToNodeIndexes[_ID];
72                 delete tree.nodeIndexesToIDs[treeIndex];
73 
74                 updateParents(self, _key, treeIndex, false, value);
75             } else if (_value != tree.nodes[treeIndex]) {// New, non zero value.
76                 bool plusOrMinus = tree.nodes[treeIndex] <= _value;
77                 uint plusOrMinusValue = plusOrMinus ? _value - tree.nodes[treeIndex] : tree.nodes[treeIndex] - _value;
78                 tree.nodes[treeIndex] = _value;
79 
80                 updateParents(self, _key, treeIndex, plusOrMinus, plusOrMinusValue);
81             }
82         }
83     }
84 
85     function draw(SortitionSumTrees storage self, bytes32 _key, uint _drawnNumber) public returns (bytes32 ID) {
86         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
87         uint treeIndex = 0;
88         uint currentDrawnNumber = _drawnNumber % tree.nodes[0];
89 
90         while ((tree.K * treeIndex) + 1 < tree.nodes.length)
91             for (uint i = 1; i <= tree.K; i++) {
92                 uint nodeIndex = (tree.K * treeIndex) + i;
93                 uint nodeValue = tree.nodes[nodeIndex];
94 
95                 if (currentDrawnNumber >= nodeValue) currentDrawnNumber -= nodeValue;
96                 else {
97                     treeIndex = nodeIndex;
98                     break;
99                 }
100             }
101 
102         ID = tree.nodeIndexesToIDs[treeIndex];
103         tree.nodes[treeIndex] = 0;
104     }
105 
106     function stakeOf(SortitionSumTrees storage self, bytes32 _key, bytes32 _ID) public view returns (uint value) {
107         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
108         uint treeIndex = Math.min(tree.IDsToNodeIndexes[_ID], tree.nodes.length - 1);
109 
110         if (treeIndex == 0) value = 0;
111         else value = tree.nodes[treeIndex];
112     }
113 
114     /* ========== PRIVATE FUNCTIONS ========== */
115 
116     function updateParents(SortitionSumTrees storage self, bytes32 _key, uint _treeIndex, bool _plusOrMinus, uint _value) private {
117         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
118 
119         uint parentIndex = _treeIndex;
120         while (parentIndex != 0) {
121             parentIndex = (parentIndex - 1) / tree.K;
122             tree.nodes[parentIndex] = _plusOrMinus ? tree.nodes[parentIndex] + _value : tree.nodes[parentIndex] - _value;
123         }
124     }
125 }
