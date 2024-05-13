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
36 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
37 import "@openzeppelin/contracts/math/Math.sol";
38 
39 import "../interfaces/IStrategy.sol";
40 import "../interfaces/IMasterChef.sol";
41 import "../interfaces/IBunnyMinter.sol";
42 import "./VaultController.sol";
43 import {PoolConstant} from "../library/PoolConstant.sol";
44 
45 
46 contract VaultCakeToCake is VaultController, IStrategy {
47     using SafeBEP20 for IBEP20;
48     using SafeMath for uint;
49 
50     /* ========== CONSTANTS ============= */
51 
52     IBEP20 private constant CAKE = IBEP20(0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82);
53     IMasterChef private constant CAKE_MASTER_CHEF = IMasterChef(0x73feaa1eE314F8c655E354234017bE2193C9E24E);
54 
55     uint public constant override pid = 0;
56     PoolConstant.PoolTypes public constant override poolType = PoolConstant.PoolTypes.CakeStake;
57 
58     uint private constant DUST = 1000;
59 
60     /* ========== STATE VARIABLES ========== */
61 
62     uint public totalShares;
63     mapping (address => uint) private _shares;
64     mapping (address => uint) private _principal;
65     mapping (address => uint) private _depositedAt;
66 
67     /* ========== INITIALIZER ========== */
68 
69     function initialize() external initializer {
70         __VaultController_init(CAKE);
71         CAKE.safeApprove(address(CAKE_MASTER_CHEF), uint(- 1));
72 
73         setMinter(0x8cB88701790F650F273c8BB2Cc4c5f439cd65219);
74     }
75 
76     /* ========== VIEW FUNCTIONS ========== */
77 
78     function totalSupply() external view override returns (uint) {
79         return totalShares;
80     }
81 
82     function balance() public view override returns (uint amount) {
83         (amount,) = CAKE_MASTER_CHEF.userInfo(pid, address(this));
84     }
85 
86     function balanceOf(address account) public view override returns(uint) {
87         if (totalShares == 0) return 0;
88         return balance().mul(sharesOf(account)).div(totalShares);
89     }
90 
91     function withdrawableBalanceOf(address account) public view override returns (uint) {
92         return balanceOf(account);
93     }
94 
95     function sharesOf(address account) public view override returns (uint) {
96         return _shares[account];
97     }
98 
99     function principalOf(address account) public view override returns (uint) {
100         return _principal[account];
101     }
102 
103     function earned(address account) public view override returns (uint) {
104         if (balanceOf(account) >= principalOf(account) + DUST) {
105             return balanceOf(account).sub(principalOf(account));
106         } else {
107             return 0;
108         }
109     }
110 
111     function priceShare() external view override returns(uint) {
112         if (totalShares == 0) return 1e18;
113         return balance().mul(1e18).div(totalShares);
114     }
115 
116     function depositedAt(address account) external view override returns (uint) {
117         return _depositedAt[account];
118     }
119 
120     function rewardsToken() external view override returns (address) {
121         return address(_stakingToken);
122     }
123 
124     /* ========== MUTATIVE FUNCTIONS ========== */
125 
126     function deposit(uint _amount) public override {
127         _deposit(_amount, msg.sender);
128 
129         if (isWhitelist(msg.sender) == false) {
130             _principal[msg.sender] = _principal[msg.sender].add(_amount);
131             _depositedAt[msg.sender] = block.timestamp;
132         }
133     }
134 
135     function depositAll() external override {
136         deposit(CAKE.balanceOf(msg.sender));
137     }
138 
139     function withdrawAll() external override {
140         uint amount = balanceOf(msg.sender);
141         uint principal = principalOf(msg.sender);
142         uint depositTimestamp = _depositedAt[msg.sender];
143 
144         totalShares = totalShares.sub(_shares[msg.sender]);
145         delete _shares[msg.sender];
146         delete _principal[msg.sender];
147         delete _depositedAt[msg.sender];
148 
149         uint cakeHarvested = _withdrawStakingToken(amount);
150 
151         uint profit = amount > principal ? amount.sub(principal) : 0;
152         uint withdrawalFee = canMint() ? _minter.withdrawalFee(principal, depositTimestamp) : 0;
153         uint performanceFee = canMint() ? _minter.performanceFee(profit) : 0;
154 
155         if (withdrawalFee.add(performanceFee) > DUST) {
156             _minter.mintFor(address(CAKE), withdrawalFee, performanceFee, msg.sender, depositTimestamp);
157             if (performanceFee > 0) {
158                 emit ProfitPaid(msg.sender, profit, performanceFee);
159             }
160             amount = amount.sub(withdrawalFee).sub(performanceFee);
161         }
162 
163         CAKE.safeTransfer(msg.sender, amount);
164         emit Withdrawn(msg.sender, amount, withdrawalFee);
165 
166         _harvest(cakeHarvested);
167     }
168 
169     function harvest() external override {
170         uint cakeHarvested = _withdrawStakingToken(0);
171         _harvest(cakeHarvested);
172     }
173 
174     function withdraw(uint shares) external override onlyWhitelisted {
175         uint amount = balance().mul(shares).div(totalShares);
176         totalShares = totalShares.sub(shares);
177         _shares[msg.sender] = _shares[msg.sender].sub(shares);
178 
179         uint cakeHarvested = _withdrawStakingToken(amount);
180         CAKE.safeTransfer(msg.sender, amount);
181         emit Withdrawn(msg.sender, amount, 0);
182 
183         _harvest(cakeHarvested);
184     }
185 
186     // @dev underlying only + withdrawal fee + no perf fee
187     function withdrawUnderlying(uint _amount) external {
188         uint amount = Math.min(_amount, _principal[msg.sender]);
189         uint shares = Math.min(amount.mul(totalShares).div(balance()), _shares[msg.sender]);
190         totalShares = totalShares.sub(shares);
191         _shares[msg.sender] = _shares[msg.sender].sub(shares);
192         _principal[msg.sender] = _principal[msg.sender].sub(amount);
193 
194         uint cakeHarvested = _withdrawStakingToken(amount);
195         uint depositTimestamp = _depositedAt[msg.sender];
196         uint withdrawalFee = canMint() ? _minter.withdrawalFee(amount, depositTimestamp) : 0;
197         if (withdrawalFee > DUST) {
198             _minter.mintFor(address(CAKE), withdrawalFee, 0, msg.sender, depositTimestamp);
199             amount = amount.sub(withdrawalFee);
200         }
201 
202         CAKE.safeTransfer(msg.sender, amount);
203         emit Withdrawn(msg.sender, amount, withdrawalFee);
204 
205         _harvest(cakeHarvested);
206     }
207 
208     function getReward() external override {
209         uint amount = earned(msg.sender);
210         uint shares = Math.min(amount.mul(totalShares).div(balance()), _shares[msg.sender]);
211         totalShares = totalShares.sub(shares);
212         _shares[msg.sender] = _shares[msg.sender].sub(shares);
213         _cleanupIfDustShares();
214 
215         uint cakeHarvested = _withdrawStakingToken(amount);
216         uint depositTimestamp = _depositedAt[msg.sender];
217         uint performanceFee = canMint() ? _minter.performanceFee(amount) : 0;
218         if (performanceFee > DUST) {
219             _minter.mintFor(address(CAKE), 0, performanceFee, msg.sender, depositTimestamp);
220             amount = amount.sub(performanceFee);
221         }
222 
223         CAKE.safeTransfer(msg.sender, amount);
224         emit ProfitPaid(msg.sender, amount, performanceFee);
225 
226         _harvest(cakeHarvested);
227     }
228 
229     /* ========== PRIVATE FUNCTIONS ========== */
230 
231     function _depositStakingToken(uint amount) private returns(uint cakeHarvested) {
232         uint before = CAKE.balanceOf(address(this));
233         CAKE_MASTER_CHEF.enterStaking(amount);
234         cakeHarvested = CAKE.balanceOf(address(this)).add(amount).sub(before);
235     }
236 
237     function _withdrawStakingToken(uint amount) private returns(uint cakeHarvested) {
238         uint before = CAKE.balanceOf(address(this));
239         CAKE_MASTER_CHEF.leaveStaking(amount);
240         cakeHarvested = CAKE.balanceOf(address(this)).sub(amount).sub(before);
241     }
242 
243     function _harvest(uint cakeAmount) private {
244         if (cakeAmount > 0) {
245             emit Harvested(cakeAmount);
246             CAKE_MASTER_CHEF.enterStaking(cakeAmount);
247         }
248     }
249 
250     function _deposit(uint _amount, address _to) private notPaused {
251         uint _pool = balance();
252         CAKE.safeTransferFrom(msg.sender, address(this), _amount);
253         uint shares = 0;
254         if (totalShares == 0) {
255             shares = _amount;
256         } else {
257             shares = (_amount.mul(totalShares)).div(_pool);
258         }
259 
260         totalShares = totalShares.add(shares);
261         _shares[_to] = _shares[_to].add(shares);
262 
263         uint cakeHarvested = _depositStakingToken(_amount);
264         emit Deposited(msg.sender, _amount);
265 
266         _harvest(cakeHarvested);
267     }
268 
269     function _cleanupIfDustShares() private {
270         uint shares = _shares[msg.sender];
271         if (shares > 0 && shares < DUST) {
272             totalShares = totalShares.sub(shares);
273             delete _shares[msg.sender];
274         }
275     }
276 
277     /* ========== SALVAGE PURPOSE ONLY ========== */
278 
279     // @dev _stakingToken(CAKE) must not remain balance in this contract. So dev should be able to salvage staking token transferred by mistake.
280     function recoverToken(address _token, uint amount) virtual external override onlyOwner {
281         IBEP20(_token).safeTransfer(owner(), amount);
282 
283         emit Recovered(_token, amount);
284     }
285 }
