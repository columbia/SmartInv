1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../strategy/base/BaseSplitter.sol';
10 
11 contract TreeSplitterMock is BaseSplitter {
12   constructor(
13     IMaster _initialParent,
14     INode _initialChildOne,
15     INode _initialChildTwo
16   ) BaseSplitter(_initialParent, _initialChildOne, _initialChildTwo) {}
17 
18   function _withdraw(uint256 _amount) internal virtual override {
19     if (_amount % (2 * 10**6) == 0) {
20       // if USDC amount is even
21       childOne.withdraw(_amount);
22     } else if (_amount % (1 * 10**6) == 0) {
23       // if USDC amount is uneven
24       childTwo.withdraw(_amount);
25     } else {
26       // if USDC has decimals
27       revert('WITHDRAW');
28     }
29   }
30 
31   function _deposit() internal virtual override {
32     uint256 balance = want.balanceOf(address(this));
33 
34     if (balance % (2 * 10**6) == 0) {
35       // if USDC amount is even
36       want.transfer(address(childOne), balance);
37       childOne.deposit();
38     } else if (balance % (1 * 10**6) == 0) {
39       // if USDC amount is uneven
40       want.transfer(address(childTwo), balance);
41       childTwo.deposit();
42     } else {
43       // if USDC has decimals
44       revert('DEPOSIT');
45     }
46   }
47 }
48 
49 contract TreeSplitterMockCustom is ISplitter {
50   address public override core;
51   IERC20 public override want;
52   IMaster public override parent;
53   uint256 public depositCalled;
54   uint256 public withdrawCalled;
55   uint256 public withdrawByAdminCalled;
56   uint256 public withdrawAllCalled;
57   uint256 public withdrawAllByAdminCalled;
58   uint256 public childRemovedCalled;
59   INode public updateChildCalled;
60   INode public override childOne;
61   INode public override childTwo;
62   bool public override setupCompleted;
63 
64   function prepareBalanceCache() external override returns (uint256) {
65   }
66 
67   function expireBalanceCache() external override {
68   }
69 
70   function balanceOf() external view override returns (uint256) {}
71 
72   function setSetupCompleted(bool _completed) external {
73     setupCompleted = _completed;
74   }
75 
76   function setChildOne(INode _child) external {
77     childOne = _child;
78   }
79 
80   function setChildTwo(INode _child) external {
81     childTwo = _child;
82   }
83 
84   function setCore(address _core) external {
85     core = _core;
86   }
87 
88   function setWant(IERC20 _want) external {
89     want = _want;
90   }
91 
92   function setParent(IMaster _parent) external {
93     parent = _parent;
94   }
95 
96   function deposit() external override {
97     depositCalled++;
98   }
99 
100   function replace(INode _node) external override {}
101 
102   function replaceAsChild(ISplitter _node) external override {}
103 
104   function replaceForce(INode _node) external override {}
105 
106   function updateParent(IMaster _node) external override {}
107 
108   function withdraw(uint256 _amount) external override {
109     withdrawCalled++;
110   }
111 
112   function withdrawAll() external override returns (uint256) {
113     withdrawAllCalled++;
114     return type(uint256).max;
115   }
116 
117   function withdrawAllByAdmin() external override returns (uint256) {
118     withdrawAllByAdminCalled++;
119   }
120 
121   function withdrawByAdmin(uint256 _amount) external override {
122     withdrawByAdminCalled++;
123   }
124 
125   /// @notice Call by child if it's needs to be updated
126   function updateChild(INode _node) external override {
127     updateChildCalled = _node;
128   }
129 
130   /// @notice Call by child if removed
131   function childRemoved() external override {
132     childRemovedCalled++;
133   }
134 
135   function isMaster() external view override returns (bool) {}
136 
137   function setInitialChildOne(INode _child) external override {}
138 
139   function setInitialChildTwo(INode _child) external override {}
140 
141   function siblingRemoved() external override {}
142 }
143 
144 contract TreeSplitterMockTest {
145   address public core;
146   IERC20 public want;
147 
148   function setCore(address _core) external {
149     core = _core;
150   }
151 
152   function setWant(IERC20 _want) external {
153     want = _want;
154   }
155 
156   function deposit(INode _strategy) external {
157     _strategy.deposit();
158   }
159 
160   function withdraw(INode _strategy, uint256 _amount) external {
161     _strategy.withdraw(_amount);
162   }
163 
164   function withdrawAll(INode _strategy) external {
165     _strategy.withdrawAll();
166   }
167 }
