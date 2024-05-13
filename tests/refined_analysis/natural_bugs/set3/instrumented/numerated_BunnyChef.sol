1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
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
36 import '@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol';
37 import '@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol';
38 import '@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol';
39 import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
40 
41 import "../interfaces/IBunnyMinterV2.sol";
42 import "../interfaces/IBunnyChef.sol";
43 import "../interfaces/IStrategy.sol";
44 import "./BunnyToken.sol";
45 
46 
47 contract BunnyChef is IBunnyChef, OwnableUpgradeable {
48     using SafeMath for uint;
49     using SafeBEP20 for IBEP20;
50 
51     /* ========== CONSTANTS ============= */
52 
53     BunnyToken public constant BUNNY = BunnyToken(0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51);
54 
55     /* ========== STATE VARIABLES ========== */
56 
57     address[] private _vaultList;
58     mapping(address => VaultInfo) vaults;
59     mapping(address => mapping(address => UserInfo)) vaultUsers;
60 
61     IBunnyMinterV2 public minter;
62 
63     uint public startBlock;
64     uint public override bunnyPerBlock;
65     uint public override totalAllocPoint;
66 
67     /* ========== MODIFIERS ========== */
68 
69     modifier onlyVaults {
70         require(vaults[msg.sender].token != address(0), "BunnyChef: caller is not on the vault");
71         _;
72     }
73 
74     modifier updateRewards(address vault) {
75         VaultInfo storage vaultInfo = vaults[vault];
76         if (block.number > vaultInfo.lastRewardBlock) {
77             uint tokenSupply = tokenSupplyOf(vault);
78             if (tokenSupply > 0) {
79                 uint multiplier = timeMultiplier(vaultInfo.lastRewardBlock, block.number);
80                 uint rewards = multiplier.mul(bunnyPerBlock).mul(vaultInfo.allocPoint).div(totalAllocPoint);
81                 vaultInfo.accBunnyPerShare = vaultInfo.accBunnyPerShare.add(rewards.mul(1e12).div(tokenSupply));
82             }
83             vaultInfo.lastRewardBlock = block.number;
84         }
85         _;
86     }
87 
88     /* ========== EVENTS ========== */
89 
90     event NotifyDeposited(address indexed user, address indexed vault, uint amount);
91     event NotifyWithdrawn(address indexed user, address indexed vault, uint amount);
92     event BunnyRewardPaid(address indexed user, address indexed vault, uint amount);
93 
94     /* ========== INITIALIZER ========== */
95 
96     function initialize(uint _startBlock, uint _bunnyPerBlock) external initializer {
97         __Ownable_init();
98 
99         startBlock = _startBlock;
100         bunnyPerBlock = _bunnyPerBlock;
101     }
102 
103     /* ========== VIEWS ========== */
104 
105     function timeMultiplier(uint from, uint to) public pure returns (uint) {
106         return to.sub(from);
107     }
108 
109     function tokenSupplyOf(address vault) public view returns (uint) {
110         return IStrategy(vault).totalSupply();
111     }
112 
113     function vaultInfoOf(address vault) external view override returns (VaultInfo memory) {
114         return vaults[vault];
115     }
116 
117     function vaultUserInfoOf(address vault, address user) external view override returns (UserInfo memory) {
118         return vaultUsers[vault][user];
119     }
120 
121     function pendingBunny(address vault, address user) public view override returns (uint) {
122         UserInfo storage userInfo = vaultUsers[vault][user];
123         VaultInfo storage vaultInfo = vaults[vault];
124 
125         uint accBunnyPerShare = vaultInfo.accBunnyPerShare;
126         uint tokenSupply = tokenSupplyOf(vault);
127         if (block.number > vaultInfo.lastRewardBlock && tokenSupply > 0) {
128             uint multiplier = timeMultiplier(vaultInfo.lastRewardBlock, block.number);
129             uint bunnyRewards = multiplier.mul(bunnyPerBlock).mul(vaultInfo.allocPoint).div(totalAllocPoint);
130             accBunnyPerShare = accBunnyPerShare.add(bunnyRewards.mul(1e12).div(tokenSupply));
131         }
132         return userInfo.pending.add(userInfo.balance.mul(accBunnyPerShare).div(1e12).sub(userInfo.rewardPaid));
133     }
134 
135     /* ========== RESTRICTED FUNCTIONS ========== */
136 
137     function addVault(address vault, address token, uint allocPoint) public onlyOwner {
138         require(vaults[vault].token == address(0), "BunnyChef: vault is already set");
139         bulkUpdateRewards();
140 
141         uint lastRewardBlock = block.number > startBlock ? block.number : startBlock;
142         totalAllocPoint = totalAllocPoint.add(allocPoint);
143         vaults[vault] = VaultInfo(token, allocPoint, lastRewardBlock, 0);
144         _vaultList.push(vault);
145     }
146 
147     function updateVault(address vault, uint allocPoint) public onlyOwner {
148         require(vaults[vault].token != address(0), "BunnyChef: vault must be set");
149         bulkUpdateRewards();
150 
151         uint lastAllocPoint = vaults[vault].allocPoint;
152         if (lastAllocPoint != allocPoint) {
153             totalAllocPoint = totalAllocPoint.sub(lastAllocPoint).add(allocPoint);
154         }
155         vaults[vault].allocPoint = allocPoint;
156     }
157 
158     function setMinter(address _minter) external onlyOwner {
159         require(address(minter) == address(0), "BunnyChef: setMinter only once");
160         minter = IBunnyMinterV2(_minter);
161     }
162 
163     function setBunnyPerBlock(uint _bunnyPerBlock) external onlyOwner {
164         bulkUpdateRewards();
165         bunnyPerBlock = _bunnyPerBlock;
166     }
167 
168     /* ========== MUTATIVE FUNCTIONS ========== */
169 
170     function notifyDeposited(address user, uint amount) external override onlyVaults updateRewards(msg.sender) {
171         UserInfo storage userInfo = vaultUsers[msg.sender][user];
172         VaultInfo storage vaultInfo = vaults[msg.sender];
173 
174         uint pending = userInfo.balance.mul(vaultInfo.accBunnyPerShare).div(1e12).sub(userInfo.rewardPaid);
175         userInfo.pending = userInfo.pending.add(pending);
176         userInfo.balance = userInfo.balance.add(amount);
177         userInfo.rewardPaid = userInfo.balance.mul(vaultInfo.accBunnyPerShare).div(1e12);
178         emit NotifyDeposited(user, msg.sender, amount);
179     }
180 
181     function notifyWithdrawn(address user, uint amount) external override onlyVaults updateRewards(msg.sender) {
182         UserInfo storage userInfo = vaultUsers[msg.sender][user];
183         VaultInfo storage vaultInfo = vaults[msg.sender];
184 
185         uint pending = userInfo.balance.mul(vaultInfo.accBunnyPerShare).div(1e12).sub(userInfo.rewardPaid);
186         userInfo.pending = userInfo.pending.add(pending);
187         userInfo.balance = userInfo.balance.sub(amount);
188         userInfo.rewardPaid = userInfo.balance.mul(vaultInfo.accBunnyPerShare).div(1e12);
189         emit NotifyWithdrawn(user, msg.sender, amount);
190     }
191 
192     function safeBunnyTransfer(address user) external override onlyVaults updateRewards(msg.sender) returns (uint) {
193         UserInfo storage userInfo = vaultUsers[msg.sender][user];
194         VaultInfo storage vaultInfo = vaults[msg.sender];
195 
196         uint pending = userInfo.balance.mul(vaultInfo.accBunnyPerShare).div(1e12).sub(userInfo.rewardPaid);
197         uint amount = userInfo.pending.add(pending);
198         userInfo.pending = 0;
199         userInfo.rewardPaid = userInfo.balance.mul(vaultInfo.accBunnyPerShare).div(1e12);
200 
201         minter.mint(amount);
202         minter.safeBunnyTransfer(user, amount);
203         emit BunnyRewardPaid(user, msg.sender, amount);
204         return amount;
205     }
206 
207     function bulkUpdateRewards() public {
208         for (uint idx = 0; idx < _vaultList.length; idx++) {
209             if (_vaultList[idx] != address(0) && vaults[_vaultList[idx]].token != address(0)) {
210                 updateRewardsOf(_vaultList[idx]);
211             }
212         }
213     }
214 
215     function updateRewardsOf(address vault) public override updateRewards(vault) {
216     }
217 
218     /* ========== SALVAGE PURPOSE ONLY ========== */
219 
220     function recoverToken(address _token, uint amount) virtual external onlyOwner {
221         require(_token != address(BUNNY), "BunnyChef: cannot recover BUNNY token");
222         IBEP20(_token).safeTransfer(owner(), amount);
223     }
224 }
