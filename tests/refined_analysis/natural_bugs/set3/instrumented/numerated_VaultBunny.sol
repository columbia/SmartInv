1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6   ___                      _   _
7  | _ )_  _ _ _  _ _ _  _  | | | |
8  | _ \ || | ' \| ' \ || | |_| |_|
9  |___/\_,_|_||_|_||_\_, | (_) (_)
10                     |__/
11 
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 BunnyFinance
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 import "@openzeppelin/contracts/math/Math.sol";
37 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
38 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
39 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
40 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
41 
42 import "../interfaces/IStrategy.sol";
43 import "../interfaces/IBunnyMinter.sol";
44 import "../interfaces/IBunnyChef.sol";
45 import "./VaultController.sol";
46 import {PoolConstant} from "../library/PoolConstant.sol";
47 
48 
49 contract VaultBunny is VaultController, IStrategy, ReentrancyGuardUpgradeable {
50     using SafeMath for uint;
51     using SafeBEP20 for IBEP20;
52 
53     /* ========== CONSTANTS ============= */
54 
55     address private constant BUNNY = 0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51;
56     PoolConstant.PoolTypes public constant override poolType = PoolConstant.PoolTypes.Bunny;
57 
58     /* ========== STATE VARIABLES ========== */
59 
60     uint public override pid;
61     uint private _totalSupply;
62     mapping(address => uint) private _balances;
63     mapping(address => uint) private _depositedAt;
64 
65     /* ========== INITIALIZER ========== */
66 
67     function initialize() external initializer {
68         __VaultController_init(IBEP20(BUNNY));
69         __ReentrancyGuard_init();
70     }
71 
72     /* ========== VIEWS ========== */
73 
74     function totalSupply() external view override returns (uint) {
75         return _totalSupply;
76     }
77 
78     function balance() external view override returns (uint) {
79         return _totalSupply;
80     }
81 
82     function balanceOf(address account) external view override returns (uint) {
83         return _balances[account];
84     }
85 
86     function sharesOf(address account) external view override returns (uint) {
87         return _balances[account];
88     }
89 
90     function principalOf(address account) external view override returns (uint) {
91         return _balances[account];
92     }
93 
94     function depositedAt(address account) external view override returns (uint) {
95         return _depositedAt[account];
96     }
97 
98     function withdrawableBalanceOf(address account) public view override returns (uint) {
99         return _balances[account];
100     }
101 
102     function rewardsToken() external view override returns (address) {
103         return BUNNY;
104     }
105 
106     function priceShare() external view override returns (uint) {
107         return 1e18;
108     }
109 
110     function earned(address) override public view returns (uint) {
111         return 0;
112     }
113 
114     /* ========== MUTATIVE FUNCTIONS ========== */
115 
116     function deposit(uint amount) override public {
117         _deposit(amount, msg.sender);
118     }
119 
120     function depositAll() override external {
121         deposit(_stakingToken.balanceOf(msg.sender));
122     }
123 
124     function withdraw(uint amount) override public nonReentrant {
125         require(amount > 0, "VaultBunny: amount must be greater than zero");
126         _bunnyChef.notifyWithdrawn(msg.sender, amount);
127 
128         _totalSupply = _totalSupply.sub(amount);
129         _balances[msg.sender] = _balances[msg.sender].sub(amount);
130 
131         uint withdrawalFee;
132         if (canMint()) {
133             uint depositTimestamp = _depositedAt[msg.sender];
134             withdrawalFee = _minter.withdrawalFee(amount, depositTimestamp);
135             if (withdrawalFee > 0) {
136                 _minter.mintFor(address(_stakingToken), withdrawalFee, 0, msg.sender, depositTimestamp);
137                 amount = amount.sub(withdrawalFee);
138             }
139         }
140 
141         _stakingToken.safeTransfer(msg.sender, amount);
142         emit Withdrawn(msg.sender, amount, withdrawalFee);
143     }
144 
145     function withdrawAll() external override {
146         uint _withdraw = withdrawableBalanceOf(msg.sender);
147         if (_withdraw > 0) {
148             withdraw(_withdraw);
149         }
150         getReward();
151     }
152 
153     function getReward() public override nonReentrant {
154         uint bunnyAmount = _bunnyChef.safeBunnyTransfer(msg.sender);
155         emit BunnyPaid(msg.sender, bunnyAmount, 0);
156     }
157 
158     function harvest() public override {
159     }
160 
161     /* ========== RESTRICTED FUNCTIONS ========== */
162 
163     function setMinter(address newMinter) public override onlyOwner {
164         VaultController.setMinter(newMinter);
165     }
166 
167     function setBunnyChef(IBunnyChef _chef) public override onlyOwner {
168         require(address(_bunnyChef) == address(0), "VaultBunny: setBunnyChef only once");
169         VaultController.setBunnyChef(IBunnyChef(_chef));
170     }
171 
172     /* ========== PRIVATE FUNCTIONS ========== */
173 
174     function _deposit(uint amount, address _to) private nonReentrant notPaused {
175         require(amount > 0, "VaultBunny: amount must be greater than zero");
176         _bunnyChef.updateRewardsOf(address(this));
177 
178         _totalSupply = _totalSupply.add(amount);
179         _balances[_to] = _balances[_to].add(amount);
180         _depositedAt[_to] = block.timestamp;
181         _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
182 
183         _bunnyChef.notifyDeposited(msg.sender, amount);
184         emit Deposited(_to, amount);
185     }
186 
187     /* ========== SALVAGE PURPOSE ONLY ========== */
188 
189     function recoverToken(address tokenAddress, uint tokenAmount) external override onlyOwner {
190         require(tokenAddress != address(_stakingToken), "VaultBunny: cannot recover underlying token");
191         IBEP20(tokenAddress).safeTransfer(owner(), tokenAmount);
192         emit Recovered(tokenAddress, tokenAmount);
193     }
194 }
