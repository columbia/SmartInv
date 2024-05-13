1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../strategy/base/BaseStrategy.sol';
10 
11 abstract contract BaseStrategyMock {
12   function mockUpdateChild(IMaster _parent, INode _newNode) external {
13     _parent.updateChild(_newNode);
14   }
15 }
16 
17 contract TreeStrategyMock is BaseStrategyMock, BaseStrategy {
18   event WithdrawAll();
19   event Withdraw(uint256 amount);
20   event Deposit();
21 
22   uint256 public internalWithdrawAllCalled;
23   uint256 public internalWithdrawCalled;
24   uint256 public internalDepositCalled;
25   bool public notWithdraw;
26 
27   function setupCompleted() external view override returns (bool) {
28     return true;
29   }
30 
31   constructor(IMaster _initialParent) BaseNode(_initialParent) {}
32 
33   function _balanceOf() internal view override returns (uint256) {
34     return want.balanceOf(address(this));
35   }
36 
37   function _withdrawAll() internal override returns (uint256 amount) {
38     if (notWithdraw) return 0;
39     amount = _balanceOf();
40     want.transfer(msg.sender, amount);
41 
42     internalWithdrawAllCalled++;
43 
44     emit WithdrawAll();
45   }
46 
47   function _withdraw(uint256 _amount) internal override {
48     want.transfer(msg.sender, _amount);
49 
50     internalWithdrawCalled++;
51 
52     emit Withdraw(_amount);
53   }
54 
55   function _deposit() internal override {
56     internalDepositCalled++;
57     emit Deposit();
58   }
59 
60   function mockSetParent(IMaster _newParent) external {
61     parent = _newParent;
62   }
63 
64   function setNotWithdraw(bool _do) external {
65     notWithdraw = _do;
66   }
67 }
68 
69 contract TreeStrategyMockCustom is BaseStrategyMock, IStrategy {
70   address public override core;
71   IERC20 public override want;
72   IMaster public override parent;
73   uint256 public depositCalled;
74   uint256 public withdrawCalled;
75   uint256 public withdrawByAdminCalled;
76   uint256 public withdrawAllCalled;
77   uint256 public withdrawAllByAdminCalled;
78   uint256 public siblingRemovedCalled;
79   bool public override setupCompleted;
80 
81   function prepareBalanceCache() external override returns (uint256) {
82     return want.balanceOf(address(this));
83   }
84 
85   function expireBalanceCache() external override {}
86 
87   function balanceOf() external view override returns (uint256) {}
88 
89   function setSetupCompleted(bool _completed) external {
90     setupCompleted = _completed;
91   }
92 
93   function setCore(address _core) external {
94     core = _core;
95   }
96 
97   function setWant(IERC20 _want) external {
98     want = _want;
99   }
100 
101   function setParent(IMaster _parent) external {
102     parent = _parent;
103   }
104 
105   function deposit() external override {
106     depositCalled++;
107   }
108 
109   function remove() external override {}
110 
111   function replace(INode _node) external override {}
112 
113   function replaceAsChild(ISplitter _node) external override {}
114 
115   function replaceForce(INode _node) external override {}
116 
117   function updateParent(IMaster _node) external override {}
118 
119   function withdraw(uint256 _amount) external override {
120     withdrawCalled++;
121     if (want.balanceOf(address(this)) != 0) {
122       want.transfer(address(core), _amount);
123     }
124   }
125 
126   function withdrawAll() external override returns (uint256) {
127     withdrawAllCalled++;
128 
129     uint256 b = want.balanceOf(address(this));
130     if (b != 0) {
131       want.transfer(address(core), b);
132       return b;
133     }
134 
135     return type(uint256).max;
136   }
137 
138   function withdrawAllByAdmin() external override returns (uint256) {
139     withdrawAllByAdminCalled++;
140   }
141 
142   function withdrawByAdmin(uint256 _amount) external override {
143     withdrawByAdminCalled++;
144   }
145 
146   function siblingRemoved() external override {
147     siblingRemovedCalled++;
148   }
149 }
