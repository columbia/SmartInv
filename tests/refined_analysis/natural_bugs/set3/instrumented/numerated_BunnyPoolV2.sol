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
34 * SOFTWARE.
35 */
36 
37 import "@openzeppelin/contracts/math/Math.sol";
38 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
39 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
40 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
41 
42 import "../library/SafeToken.sol";
43 
44 import "../interfaces/IBunnyPool.sol";
45 
46 import "./VaultController.sol";
47 
48 contract BunnyPoolV2 is IBunnyPool, VaultController, ReentrancyGuardUpgradeable {
49     using SafeBEP20 for IBEP20;
50     using SafeMath for uint;
51     using SafeToken for address;
52 
53     /* ========== CONSTANT ========== */
54 
55     address public constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
56     address public constant BUNNY = 0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51;
57     address public constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
58     address public constant MINTER = 0x8cB88701790F650F273c8BB2Cc4c5f439cd65219;
59     address public constant FEE_BOX = 0x3749f69B2D99E5586D95d95B6F9B5252C71894bb;
60 
61     struct RewardInfo {
62         address token;
63         uint rewardPerTokenStored;
64         uint rewardRate;
65         uint lastUpdateTime;
66     }
67 
68     /* ========== STATE VARIABLES ========== */
69 
70     address public rewardsDistribution;
71 
72     uint public periodFinish;
73     uint public rewardsDuration;
74     uint public totalSupply;
75 
76     address[] private _rewardTokens;
77     mapping(address => RewardInfo) public rewards;
78     mapping(address => mapping(address => uint)) public userRewardPerToken;
79     mapping(address => mapping(address => uint)) public userRewardPerTokenPaid;
80 
81     mapping(address => uint) private _balances;
82 
83     /* ========== EVENTS ========== */
84 
85     event Deposited(address indexed user, uint amount);
86     event Withdrawn(address indexed user, uint amount);
87 
88     event RewardsAdded(uint[] amounts);
89     event RewardsPaid(address indexed user, address token, uint amount);
90     event BunnyPaid(address indexed user, uint profit, uint performanceFee);
91 
92     /* ========== INITIALIZER ========== */
93 
94     receive() external payable {}
95 
96     function initialize() external initializer {
97         __VaultController_init(IBEP20(BUNNY));
98         __ReentrancyGuard_init();
99 
100         rewardsDuration = 30 days;
101         rewardsDistribution = FEE_BOX;
102     }
103 
104     /* ========== MODIFIERS ========== */
105 
106     modifier onlyRewardsDistribution() {
107         require(msg.sender == rewardsDistribution, "BunnyPoolV2: caller is not the rewardsDistribution");
108         _;
109     }
110 
111     modifier updateRewards(address account) {
112         for (uint i = 0; i < _rewardTokens.length; i++) {
113             RewardInfo storage rewardInfo = rewards[_rewardTokens[i]];
114             rewardInfo.rewardPerTokenStored = rewardPerToken(rewardInfo.token);
115             rewardInfo.lastUpdateTime = lastTimeRewardApplicable();
116 
117             if (account != address(0)) {
118                 userRewardPerToken[account][rewardInfo.token] = earnedPerToken(account, rewardInfo.token);
119                 userRewardPerTokenPaid[account][rewardInfo.token] = rewardInfo.rewardPerTokenStored;
120             }
121         }
122         _;
123     }
124 
125     modifier canStakeTo() {
126         require(msg.sender == owner() || msg.sender == MINTER, "BunnyPoolV2: no auth");
127         _;
128     }
129 
130     /* ========== VIEWS ========== */
131 
132     function balanceOf(address account) public override view returns (uint) {
133         return _balances[account];
134     }
135 
136     function earned(address account) public override view returns (uint[] memory) {
137         uint[] memory pendingRewards = new uint[](_rewardTokens.length);
138         for (uint i = 0; i < _rewardTokens.length; i++) {
139             pendingRewards[i] = earnedPerToken(account, _rewardTokens[i]);
140         }
141         return pendingRewards;
142     }
143 
144     function earnedPerToken(address account, address token) public view returns (uint) {
145         return _balances[account].mul(
146             rewardPerToken(token).sub(userRewardPerTokenPaid[account][token])
147         ).div(1e18).add(userRewardPerToken[account][token]);
148     }
149 
150     function rewardTokens() public view override returns (address[] memory) {
151         return _rewardTokens;
152     }
153 
154     function rewardPerToken(address token) public view returns (uint) {
155         if (totalSupply == 0) return rewards[token].rewardPerTokenStored;
156         return rewards[token].rewardPerTokenStored.add(
157             lastTimeRewardApplicable().sub(rewards[token].lastUpdateTime).mul(rewards[token].rewardRate).mul(1e18).div(totalSupply)
158         );
159     }
160 
161     function lastTimeRewardApplicable() public view returns (uint) {
162         return Math.min(block.timestamp, periodFinish);
163     }
164 
165     /* ========== RESTRICTED FUNCTIONS ========== */
166 
167     function addRewardsToken(address _rewardsToken) public onlyOwner {
168         require(_rewardsToken != address(0), "BunnyPoolV2: BNB uses WBNB address");
169         require(rewards[_rewardsToken].token == address(0), "BunnyPoolV2: duplicated rewards token");
170         rewards[_rewardsToken] = RewardInfo(_rewardsToken, 0, 0, 0);
171         _rewardTokens.push(_rewardsToken);
172     }
173 
174     function setRewardsDistribution(address _rewardsDistribution) public onlyOwner {
175         rewardsDistribution = _rewardsDistribution;
176     }
177 
178     function setRewardsDuration(uint _rewardsDuration) external onlyOwner {
179         require(periodFinish == 0 || block.timestamp > periodFinish, "BunnyPoolV2: invalid rewards duration");
180         rewardsDuration = _rewardsDuration;
181     }
182 
183     function notifyRewardAmounts(uint[] memory amounts) external override onlyRewardsDistribution updateRewards(address(0)) {
184         require(amounts.length == _rewardTokens.length, "BunnyPoolV2: invalid length of amounts");
185         for (uint i = 0; i < _rewardTokens.length; i++) {
186             RewardInfo storage rewardInfo = rewards[_rewardTokens[i]];
187             if (block.timestamp >= periodFinish) {
188                 rewardInfo.rewardRate = amounts[i].div(rewardsDuration);
189             } else {
190                 uint remaining = periodFinish.sub(block.timestamp);
191                 uint leftover = remaining.mul(rewardInfo.rewardRate);
192                 rewardInfo.rewardRate = amounts[i].add(leftover).div(rewardsDuration);
193             }
194             rewardInfo.lastUpdateTime = block.timestamp;
195 
196             // Ensure the provided reward amount is not more than the balance in the contract.
197             // This keeps the reward rate in the right range, preventing overflows due to
198             // very high values of rewardRate in the earned and rewardsPerToken functions;
199             // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
200             uint _balance;
201             if (rewardInfo.token == WBNB) {
202                 _balance = address(this).balance;
203             } else if (rewardInfo.token == BUNNY) {
204                 _balance = IBEP20(BUNNY).balanceOf(address(this)).sub(totalSupply);
205             } else {
206                 _balance = IBEP20(rewardInfo.token).balanceOf(address(this));
207             }
208 
209             require(rewardInfo.rewardRate <= _balance.div(rewardsDuration), "BunnyPoolV2: invalid rewards amount");
210         }
211 
212         periodFinish = block.timestamp.add(rewardsDuration);
213         emit RewardsAdded(amounts);
214     }
215 
216     function depositOnBehalf(uint _amount, address _to) external override canStakeTo {
217         _deposit(_amount, _to);
218     }
219 
220     /* ========== MUTATE FUNCTIONS ========== */
221 
222     function deposit(uint _amount) public override nonReentrant {
223         _deposit(_amount, msg.sender);
224     }
225 
226     function depositAll() public nonReentrant {
227         _deposit(IBEP20(_stakingToken).balanceOf(msg.sender), msg.sender);
228     }
229 
230     function withdraw(uint _amount) public override nonReentrant notPaused updateRewards(msg.sender) {
231         require(_amount > 0, "BunnyPoolV2: invalid amount");
232         _bunnyChef.notifyWithdrawn(msg.sender, _amount);
233 
234         totalSupply = totalSupply.sub(_amount);
235         _balances[msg.sender] = _balances[msg.sender].sub(_amount);
236         IBEP20(_stakingToken).safeTransfer(msg.sender, _amount);
237         emit Withdrawn(msg.sender, _amount);
238     }
239 
240     function withdrawAll() external override {
241         uint amount = _balances[msg.sender];
242         if (amount > 0) {
243             withdraw(amount);
244         }
245 
246         getReward();
247     }
248 
249     function getReward() public override nonReentrant updateRewards(msg.sender) {
250         for (uint i = 0; i < _rewardTokens.length; i++) {
251             uint reward = userRewardPerToken[msg.sender][_rewardTokens[i]];
252             if (reward > 0) {
253                 userRewardPerToken[msg.sender][_rewardTokens[i]] = 0;
254 
255                 if (_rewardTokens[i] == WBNB) {
256                     SafeToken.safeTransferETH(msg.sender, reward);
257                 } else {
258                     IBEP20(_rewardTokens[i]).safeTransfer(msg.sender, reward);
259                 }
260                 emit RewardsPaid(msg.sender, _rewardTokens[i], reward);
261             }
262         }
263 
264         uint bunnyAmount = _bunnyChef.safeBunnyTransfer(msg.sender);
265         emit BunnyPaid(msg.sender, bunnyAmount, 0);
266     }
267 
268 
269     /* ========== PRIVATE FUNCTIONS ========== */
270 
271     function _deposit(uint _amount, address _to) private notPaused updateRewards(_to) {
272         IBEP20(_stakingToken).safeTransferFrom(msg.sender, address(this), _amount);
273         _bunnyChef.updateRewardsOf(address(this));
274 
275         totalSupply = totalSupply.add(_amount);
276         _balances[_to] = _balances[_to].add(_amount);
277 
278         _bunnyChef.notifyDeposited(_to, _amount);
279         emit Deposited(_to, _amount);
280     }
281 }