1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import './Manager.sol';
10 import '../interfaces/managers/IStrategyManager.sol';
11 import '../interfaces/strategy/IStrategy.sol';
12 import '../interfaces/strategy/INode.sol';
13 import '../strategy/base/BaseMaster.sol';
14 
15 import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
16 
17 contract InfoStorage {
18   IERC20 public immutable want;
19   address public immutable core;
20 
21   constructor(IERC20 _want, address _core) {
22     want = _want;
23     core = _core;
24   }
25 }
26 
27 // This contract is not desgined to hold funds (except during runtime)
28 // If it does (by someone sending funds directly) it will not be reflected in the balanceOf()
29 // On `deposit()` the funds will be added to the balance
30 // As an observer, if the TVL is 10m and this contract contains 10m, you can easily double your money if you
31 // enter the pool before `deposit()` is called.
32 contract MasterStrategy is
33   BaseMaster,
34   Manager /* IStrategyManager */
35 {
36   using SafeERC20 for IERC20;
37 
38   constructor(IMaster _initialParent) BaseNode(_initialParent) {
39     sherlockCore = ISherlock(core);
40 
41     emit SherlockCoreSet(ISherlock(core));
42   }
43 
44   /*//////////////////////////////////////////////////////////////
45                         TREE STRUCTURE LOGIC
46   //////////////////////////////////////////////////////////////*/
47 
48   function isMaster() external view override returns (bool) {
49     return true;
50   }
51 
52   function setupCompleted() external view override returns (bool) {
53     return address(childOne) != address(0);
54   }
55 
56   function childRemoved() external override {
57     // not implemented as the system can not function without `childOne` in this contract
58     revert NotImplemented(msg.sig);
59   }
60 
61   function replaceAsChild(ISplitter _newParent) external override {
62     revert NotImplemented(msg.sig);
63   }
64 
65   function replace(INode _node) external override {
66     revert NotImplemented(msg.sig);
67   }
68 
69   function replaceForce(INode _node) external override {
70     revert NotImplemented(msg.sig);
71   }
72 
73   function updateChild(INode _newChild) external override {
74     address _childOne = address(childOne);
75     if (_childOne == address(0)) revert NotSetup();
76     if (_childOne != msg.sender) revert InvalidSender();
77 
78     _verifySetChild(INode(msg.sender), _newChild);
79     _setChildOne(INode(msg.sender), _newChild);
80   }
81 
82   function updateParent(IMaster _node) external override {
83     // not implemented as the parent can not be updated by the tree system
84     revert NotImplemented(msg.sig);
85   }
86 
87   /*//////////////////////////////////////////////////////////////
88                         YIELD STRATEGY LOGIC
89   //////////////////////////////////////////////////////////////*/
90 
91   modifier balanceCache() {
92     childOne.prepareBalanceCache();
93     _;
94     childOne.expireBalanceCache();
95   }
96 
97   function prepareBalanceCache() external override returns (uint256) {
98     revert NotImplemented(msg.sig);
99   }
100 
101   function expireBalanceCache() external override {
102     revert NotImplemented(msg.sig);
103   }
104 
105   function balanceOf()
106     public
107     view
108     override(
109       /*IStrategyManager, */
110       INode
111     )
112     returns (uint256)
113   {
114     return childOne.balanceOf();
115   }
116 
117   function deposit()
118     external
119     override(
120       /*IStrategyManager, */
121       INode
122     )
123     whenNotPaused
124     onlySherlockCore
125     balanceCache
126   {
127     uint256 balance = want.balanceOf(address(this));
128     if (balance == 0) revert InvalidConditions();
129 
130     want.safeTransfer(address(childOne), balance);
131 
132     childOne.deposit();
133   }
134 
135   function withdrawAllByAdmin() external override onlyOwner balanceCache returns (uint256 amount) {
136     amount = childOne.withdrawAll();
137     emit AdminWithdraw(amount);
138   }
139 
140   function withdrawAll()
141     external
142     override(
143       /*IStrategyManager, */
144       INode
145     )
146     onlySherlockCore
147     balanceCache
148     returns (uint256)
149   {
150     return childOne.withdrawAll();
151   }
152 
153   function withdrawByAdmin(uint256 _amount) external override onlyOwner balanceCache {
154     if (_amount == 0) revert ZeroArg();
155 
156     childOne.withdraw(_amount);
157     emit AdminWithdraw(_amount);
158   }
159 
160   function withdraw(uint256 _amount)
161     external
162     override(
163       /*IStrategyManager, */
164       INode
165     )
166     onlySherlockCore
167     balanceCache
168   {
169     if (_amount == 0) revert ZeroArg();
170 
171     childOne.withdraw(_amount);
172   }
173 }
