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
39 import {PoolConstant} from "../library/PoolConstant.sol";
40 import "../interfaces/IPancakePair.sol";
41 import "../interfaces/IPancakeFactory.sol";
42 import "../interfaces/IStrategy.sol";
43 import "../interfaces/IMasterChef.sol";
44 import "../interfaces/IBunnyMinter.sol";
45 
46 import "../zap/ZapBSC.sol";
47 import "./VaultController.sol";
48 
49 
50 contract VaultFlipToFlip is VaultController, IStrategy {
51     using SafeBEP20 for IBEP20;
52     using SafeMath for uint256;
53 
54     /* ========== CONSTANTS ============= */
55 
56     IBEP20 private constant CAKE = IBEP20(0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82);
57     IBEP20 private constant WBNB = IBEP20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
58     IMasterChef private constant CAKE_MASTER_CHEF = IMasterChef(0x73feaa1eE314F8c655E354234017bE2193C9E24E);
59     PoolConstant.PoolTypes public constant override poolType = PoolConstant.PoolTypes.FlipToFlip;
60 
61     ZapBSC public constant zapBSC = ZapBSC(0xdC2bBB0D33E0e7Dea9F5b98F46EDBaC823586a0C);
62 
63     uint private constant DUST = 1000;
64 
65     /* ========== STATE VARIABLES ========== */
66 
67     uint public override pid;
68 
69     address private _token0;
70     address private _token1;
71 
72     uint public totalShares;
73     mapping (address => uint) private _shares;
74     mapping (address => uint) private _principal;
75     mapping (address => uint) private _depositedAt;
76 
77     uint public cakeHarvested;
78 
79     /* ========== MODIFIER ========== */
80 
81     modifier updateCakeHarvested {
82         uint before = CAKE.balanceOf(address(this));
83         _;
84         uint _after = CAKE.balanceOf(address(this));
85         cakeHarvested = cakeHarvested.add(_after).sub(before);
86     }
87 
88     /* ========== INITIALIZER ========== */
89 
90     function initialize(uint _pid, address _token) external initializer {
91         __VaultController_init(IBEP20(_token));
92 
93         _stakingToken.safeApprove(address(CAKE_MASTER_CHEF), uint(- 1));
94         pid = _pid;
95 
96         CAKE.safeApprove(address(zapBSC), uint(- 1));
97     }
98 
99     /* ========== VIEW FUNCTIONS ========== */
100 
101     function totalSupply() external view override returns (uint) {
102         return totalShares;
103     }
104 
105     function balance() public view override returns (uint amount) {
106         (amount,) = CAKE_MASTER_CHEF.userInfo(pid, address(this));
107     }
108 
109     function balanceOf(address account) public view override returns(uint) {
110         if (totalShares == 0) return 0;
111         return balance().mul(sharesOf(account)).div(totalShares);
112     }
113 
114     function withdrawableBalanceOf(address account) public view override returns (uint) {
115         return balanceOf(account);
116     }
117 
118     function sharesOf(address account) public view override returns (uint) {
119         return _shares[account];
120     }
121 
122     function principalOf(address account) public view override returns (uint) {
123         return _principal[account];
124     }
125 
126     function earned(address account) public view override returns (uint) {
127         if (balanceOf(account) >= principalOf(account) + DUST) {
128             return balanceOf(account).sub(principalOf(account));
129         } else {
130             return 0;
131         }
132     }
133 
134     function depositedAt(address account) external view override returns (uint) {
135         return _depositedAt[account];
136     }
137 
138     function rewardsToken() external view override returns (address) {
139         return address(_stakingToken);
140     }
141 
142     function priceShare() external view override returns(uint) {
143         if (totalShares == 0) return 1e18;
144         return balance().mul(1e18).div(totalShares);
145     }
146 
147     /* ========== MUTATIVE FUNCTIONS ========== */
148 
149     function deposit(uint _amount) public override {
150         _depositTo(_amount, msg.sender);
151     }
152 
153     function depositAll() external override {
154         deposit(_stakingToken.balanceOf(msg.sender));
155     }
156 
157     function withdrawAll() external override {
158         uint amount = balanceOf(msg.sender);
159         uint principal = principalOf(msg.sender);
160         uint depositTimestamp = _depositedAt[msg.sender];
161 
162         totalShares = totalShares.sub(_shares[msg.sender]);
163         delete _shares[msg.sender];
164         delete _principal[msg.sender];
165         delete _depositedAt[msg.sender];
166 
167         amount = _withdrawTokenWithCorrection(amount);
168         uint profit = amount > principal ? amount.sub(principal) : 0;
169 
170         uint withdrawalFee = canMint() ? _minter.withdrawalFee(principal, depositTimestamp) : 0;
171         uint performanceFee = canMint() ? _minter.performanceFee(profit) : 0;
172         if (withdrawalFee.add(performanceFee) > DUST) {
173             _minter.mintForV2(address(_stakingToken), withdrawalFee, performanceFee, msg.sender, depositTimestamp);
174 
175             if (performanceFee > 0) {
176                 emit ProfitPaid(msg.sender, profit, performanceFee);
177             }
178             amount = amount.sub(withdrawalFee).sub(performanceFee);
179         }
180 
181         _stakingToken.safeTransfer(msg.sender, amount);
182         emit Withdrawn(msg.sender, amount, withdrawalFee);
183     }
184 
185     function harvest() external override onlyKeeper {
186         _harvest();
187 
188         uint before = _stakingToken.balanceOf(address(this));
189         zapBSC.zapInToken(address(CAKE), cakeHarvested, address(_stakingToken));
190         uint harvested = _stakingToken.balanceOf(address(this)).sub(before);
191 
192         CAKE_MASTER_CHEF.deposit(pid, harvested);
193         emit Harvested(harvested);
194 
195         cakeHarvested = 0;
196     }
197 
198     function _harvest() private updateCakeHarvested {
199         CAKE_MASTER_CHEF.withdraw(pid, 0);
200     }
201 
202     function withdraw(uint) external override onlyWhitelisted {
203         // we don't use withdraw function.
204         revert("N/A");
205     }
206 
207     // @dev underlying only + withdrawal fee + no perf fee
208     function withdrawUnderlying(uint _amount) external {
209         uint amount = Math.min(_amount, _principal[msg.sender]);
210         uint shares = Math.min(amount.mul(totalShares).div(balance()), _shares[msg.sender]);
211         totalShares = totalShares.sub(shares);
212         _shares[msg.sender] = _shares[msg.sender].sub(shares);
213         _principal[msg.sender] = _principal[msg.sender].sub(amount);
214 
215         amount = _withdrawTokenWithCorrection(amount);
216         uint depositTimestamp = _depositedAt[msg.sender];
217         uint withdrawalFee = canMint() ? _minter.withdrawalFee(amount, depositTimestamp) : 0;
218         if (withdrawalFee > DUST) {
219             _minter.mintForV2(address(_stakingToken), withdrawalFee, 0, msg.sender, depositTimestamp);
220             amount = amount.sub(withdrawalFee);
221         }
222 
223         _stakingToken.safeTransfer(msg.sender, amount);
224         emit Withdrawn(msg.sender, amount, withdrawalFee);
225     }
226 
227     // @dev profits only (underlying + bunny) + no withdraw fee + perf fee
228     function getReward() external override {
229         uint amount = earned(msg.sender);
230         uint shares = Math.min(amount.mul(totalShares).div(balance()), _shares[msg.sender]);
231         totalShares = totalShares.sub(shares);
232         _shares[msg.sender] = _shares[msg.sender].sub(shares);
233         _cleanupIfDustShares();
234 
235         amount = _withdrawTokenWithCorrection(amount);
236         uint depositTimestamp = _depositedAt[msg.sender];
237         uint performanceFee = canMint() ? _minter.performanceFee(amount) : 0;
238         if (performanceFee > DUST) {
239             _minter.mintForV2(address(_stakingToken), 0, performanceFee, msg.sender, depositTimestamp);
240             amount = amount.sub(performanceFee);
241         }
242 
243         _stakingToken.safeTransfer(msg.sender, amount);
244         emit ProfitPaid(msg.sender, amount, performanceFee);
245     }
246 
247     /* ========== PRIVATE FUNCTIONS ========== */
248 
249     function _depositTo(uint _amount, address _to) private notPaused updateCakeHarvested {
250         uint _pool = balance();
251         uint _before = _stakingToken.balanceOf(address(this));
252         _stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
253         uint _after = _stakingToken.balanceOf(address(this));
254         _amount = _after.sub(_before); // Additional check for deflationary tokens
255         uint shares = 0;
256         if (totalShares == 0) {
257             shares = _amount;
258         } else {
259             shares = (_amount.mul(totalShares)).div(_pool);
260         }
261 
262         totalShares = totalShares.add(shares);
263         _shares[_to] = _shares[_to].add(shares);
264         _principal[_to] = _principal[_to].add(_amount);
265         _depositedAt[_to] = block.timestamp;
266 
267         CAKE_MASTER_CHEF.deposit(pid, _amount);
268         emit Deposited(_to, _amount);
269     }
270 
271     function _withdrawTokenWithCorrection(uint amount) private updateCakeHarvested returns (uint) {
272         uint before = _stakingToken.balanceOf(address(this));
273         CAKE_MASTER_CHEF.withdraw(pid, amount);
274         return _stakingToken.balanceOf(address(this)).sub(before);
275     }
276 
277     function _cleanupIfDustShares() private {
278         uint shares = _shares[msg.sender];
279         if (shares > 0 && shares < DUST) {
280             totalShares = totalShares.sub(shares);
281             delete _shares[msg.sender];
282         }
283     }
284 
285     /* ========== SALVAGE PURPOSE ONLY ========== */
286 
287     // @dev stakingToken must not remain balance in this contract. So dev should salvage staking token transferred by mistake.
288     function recoverToken(address token, uint amount) external override onlyOwner {
289         if (token == address(CAKE)) {
290             uint cakeBalance = CAKE.balanceOf(address(this));
291             require(amount <= cakeBalance.sub(cakeHarvested), "VaultFlipToFlip: cannot recover lp's harvested cake");
292         }
293 
294         IBEP20(token).safeTransfer(owner(), amount);
295         emit Recovered(token, amount);
296     }
297 }
