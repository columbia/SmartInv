1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "./ConvexStrategyBase.sol";
5 import "../../interfaces/IERC20Full.sol";
6 
7 /**
8  * This is the BkdTriHopCvx strategy, which is designed to be used by a Backd ERC20 Vault.
9  * The strategy holds a given ERC20 underlying and allocates liquidity to Convex via a given Curve Pool.
10  * The Curve Pools used are Meta Pools which first require getting an LP Token from another Curve Pool.
11  * The strategy does a 'Hop' when depositing and withdrawing, by first getting the required LP Token, and then the final LP Token for Convex.
12  * Rewards received on Convex (CVX, CRV), are sold in part for the underlying.
13  * A share of earned CVX & CRV are retained on behalf of the Backd community to participate in governance.
14  */
15 contract BkdTriHopCvx is ConvexStrategyBase {
16     using ScaledMath for uint256;
17     using SafeERC20 for IERC20;
18 
19     ICurveSwapEth public immutable curveHopPool; // Curve Pool to use for Hops
20     IERC20 public immutable hopLp; // Curve Hop Pool LP Token
21     uint256 public immutable curveHopIndex; // Underlying index in Curve Pool
22 
23     uint256 public hopImbalanceToleranceIn; // Maximum allowed slippage from Curve Hop Pool Imbalance for depositing
24     uint256 public hopImbalanceToleranceOut; // Maximum allowed slippage from Curve Hop Pool Imbalance for withdrawing
25     uint256 public decimalMultiplier; // Used for converting between underlying and LP
26 
27     event SetHopImbalanceToleranceIn(uint256 value); // Emitted after a succuessful setting of hop imbalance tolerance in
28     event SetHopImbalanceToleranceOut(uint256 value); // Emitted after a succuessful setting of hop imbalance tolerance out
29 
30     constructor(
31         address vault_,
32         address strategist_,
33         uint256 convexPid_,
34         address curvePool_,
35         uint256 curveIndex_,
36         address curveHopPool_,
37         uint256 curveHopIndex_,
38         IAddressProvider addressProvider_,
39         address strategySwapper_
40     )
41         ConvexStrategyBase(
42             vault_,
43             strategist_,
44             convexPid_,
45             curvePool_,
46             curveIndex_,
47             addressProvider_,
48             strategySwapper_
49         )
50     {
51         // Getting data from supporting contracts
52         _validateCurvePool(curveHopPool_);
53         (address lp_, , , , , ) = _BOOSTER.poolInfo(convexPid_);
54         address hopLp_ = ICurveSwapEth(curvePool_).coins(curveIndex_);
55         hopLp = IERC20(hopLp_);
56         curveHopPool = ICurveSwapEth(curveHopPool_);
57         address underlying_ = ICurveSwapEth(curveHopPool_).coins(curveHopIndex_);
58         underlying = IERC20(underlying_);
59         decimalMultiplier = 10**(18 - IERC20Full(underlying_).decimals());
60 
61         // Setting inputs
62         curveHopIndex = curveHopIndex_;
63 
64         // Setting default values
65         imbalanceToleranceIn = 0.001e18;
66         imbalanceToleranceOut = 0.048e18;
67         hopImbalanceToleranceIn = 0.001e18;
68         hopImbalanceToleranceOut = 0.0015e18;
69 
70         // Approvals
71         IERC20(underlying_).safeApprove(curveHopPool_, type(uint256).max);
72         IERC20(hopLp_).safeApprove(curvePool_, type(uint256).max);
73         IERC20(lp_).safeApprove(address(_BOOSTER), type(uint256).max);
74     }
75 
76     /**
77      * @notice Set hop imbalance tolerance for Curve Hop Pool deposits.
78      * @dev Stored as a percent, e.g. 1% would be set as 0.01
79      * @param _hopImbalanceToleranceIn New hop imbalance tolarance in.
80      * @return True if successfully set.
81      */
82     function setHopImbalanceToleranceIn(uint256 _hopImbalanceToleranceIn)
83         external
84         onlyGovernance
85         returns (bool)
86     {
87         hopImbalanceToleranceIn = _hopImbalanceToleranceIn;
88         emit SetHopImbalanceToleranceIn(_hopImbalanceToleranceIn);
89         return true;
90     }
91 
92     /**
93      * @notice Set hop imbalance tolerance for Curve Hop Pool withdrawals.
94      * @dev Stored as a percent, e.g. 1% would be set as 0.01
95      * @param _hopImbalanceToleranceOut New hop imbalance tolarance out.
96      * @return True if successfully set.
97      */
98     function setHopImbalanceToleranceOut(uint256 _hopImbalanceToleranceOut)
99         external
100         onlyGovernance
101         returns (bool)
102     {
103         hopImbalanceToleranceOut = _hopImbalanceToleranceOut;
104         emit SetHopImbalanceToleranceOut(_hopImbalanceToleranceOut);
105         return true;
106     }
107 
108     /**
109      * @notice Changes the Convex Pool used for farming yield, e.g. from FRAX to MIM.
110      * @dev First withdraws all funds, then harvests any rewards, then changes pool, then deposits again.
111      * @param convexPid_ The PID for the new Convex Pool.
112      * @param curvePool_ The Curve Pool to deposit into to get the required LP Token for Convex staking.
113      * @param curveIndex_ The index of the new Convex Pool Token in the new Curve Pool.
114      */
115     function changeConvexPool(
116         uint256 convexPid_,
117         address curvePool_,
118         uint256 curveIndex_
119     ) external onlyGovernance {
120         _validateCurvePool(curvePool_);
121         _harvest();
122         _withdrawAllToHopLp();
123         convexPid = convexPid_;
124         curveIndex = curveIndex_;
125         (address lp_, , , address rewards_, , ) = _BOOSTER.poolInfo(convexPid_);
126         lp = IERC20(lp_);
127         rewards = IRewardStaking(rewards_);
128         curvePool = ICurveSwapEth(curvePool_);
129         IERC20(hopLp).safeApprove(curvePool_, 0);
130         IERC20(hopLp).safeApprove(curvePool_, type(uint256).max);
131         IERC20(lp_).safeApprove(address(_BOOSTER), 0);
132         IERC20(lp_).safeApprove(address(_BOOSTER), type(uint256).max);
133         require(_deposit(), Error.DEPOSIT_FAILED);
134     }
135 
136     function balance() public view override returns (uint256) {
137         return
138             _underlyingBalance() +
139             _hopLpToUnderlying(_lpToHopLp(_stakedBalance() + _lpBalance()) + _hopLpBalance());
140     }
141 
142     function name() public pure override returns (string memory) {
143         return "BkdTriHopCvx";
144     }
145 
146     function _deposit() internal override returns (bool) {
147         require(msg.value == 0, Error.INVALID_VALUE);
148 
149         // Depositing into Curve Hop Pool
150         uint256 underlyingBalance = _underlyingBalance();
151         if (underlyingBalance > 0) {
152             uint256[3] memory hopAmounts;
153             hopAmounts[curveHopIndex] = underlyingBalance;
154             curveHopPool.add_liquidity(hopAmounts, _minHopLpAcceptedFromDeposit(underlyingBalance));
155         }
156 
157         // Depositing into Curve Pool
158         uint256 hopLpBalance = _hopLpBalance();
159         if (hopLpBalance > 0) {
160             uint256[2] memory amounts;
161             amounts[curveIndex] = hopLpBalance;
162             curvePool.add_liquidity(amounts, _minLpAccepted(hopLpBalance));
163         }
164 
165         // Depositing into Convex and Staking
166         if (_lpBalance() == 0) return false;
167         if (!_BOOSTER.depositAll(convexPid, true)) return false;
168         return true;
169     }
170 
171     function _withdraw(uint256 amount) internal override returns (bool) {
172         // Transferring from idle balance if enough
173         uint256 underlyingBalance = _underlyingBalance();
174         if (underlyingBalance >= amount) {
175             underlying.safeTransfer(vault, amount);
176             emit Withdraw(amount);
177             return true;
178         }
179 
180         // Calculating needed amount of LP to withdraw
181         uint256 requiredUnderlyingAmount = amount - underlyingBalance;
182         uint256 maxHopLpBurned = _maxHopLpBurned(requiredUnderlyingAmount);
183         uint256 requiredHopLpAmount = maxHopLpBurned - _hopLpBalance();
184         uint256 maxLpBurned = _maxLpBurned(requiredHopLpAmount);
185         uint256 requiredLpAmount = maxLpBurned - _lpBalance();
186 
187         // Unstaking needed LP Tokens from Convex
188         if (!rewards.withdrawAndUnwrap(requiredLpAmount, false)) return false;
189 
190         // Removing needed liquidity from Curve Pool
191         uint256[2] memory amounts;
192         amounts[curveIndex] = requiredHopLpAmount;
193         curvePool.remove_liquidity_imbalance(amounts, maxLpBurned);
194 
195         // Removing needed liquidity from Curve Hop Pool
196         uint256[3] memory hopAmounts;
197         hopAmounts[curveHopIndex] = requiredUnderlyingAmount;
198         curveHopPool.remove_liquidity_imbalance(hopAmounts, maxHopLpBurned);
199 
200         // Sending underlying to vault
201         underlying.safeTransfer(vault, amount);
202         return true;
203     }
204 
205     function _withdrawAll() internal override returns (uint256) {
206         // Withdrawing all from Convex and converting to Hop LP Token
207         _withdrawAllToHopLp();
208 
209         // Removing liquidity from Curve Hop Pool
210         uint256 hopLpBalance = _hopLpBalance();
211         if (hopLpBalance > 0) {
212             curveHopPool.remove_liquidity_one_coin(
213                 hopLpBalance,
214                 int128(uint128(curveHopIndex)),
215                 _minUnderlyingAccepted(hopLpBalance)
216             );
217         }
218 
219         // Transferring underlying to vault
220         uint256 underlyingBalance = _underlyingBalance();
221         if (underlyingBalance == 0) return 0;
222         underlying.safeTransfer(vault, underlyingBalance);
223         return underlyingBalance;
224     }
225 
226     function _underlyingBalance() internal view override returns (uint256) {
227         return underlying.balanceOf(address(this));
228     }
229 
230     /**
231      * @dev Get the balance of the hop lp.
232      */
233     function _hopLpBalance() internal view returns (uint256) {
234         return hopLp.balanceOf(address(this));
235     }
236 
237     /**
238      * @notice Calculates the minimum LP to accept when depositing underlying into Curve Pool.
239      * @param _hopLpAmount Amount of Hop LP that is being deposited into Curve Pool.
240      * @return The minimum LP balance to accept.
241      */
242     function _minLpAccepted(uint256 _hopLpAmount) internal view returns (uint256) {
243         return _hopLpToLp(_hopLpAmount).scaledMul(ScaledMath.ONE - imbalanceToleranceIn);
244     }
245 
246     /**
247      * @notice Calculates the maximum LP to accept burning when withdrawing amount from Curve Pool.
248      * @param _hopLpAmount Amount of Hop LP that is being widthdrawn from Curve Pool.
249      * @return The maximum LP balance to accept burning.
250      */
251     function _maxLpBurned(uint256 _hopLpAmount) internal view returns (uint256) {
252         return _hopLpToLp(_hopLpAmount).scaledMul(ScaledMath.ONE + imbalanceToleranceOut);
253     }
254 
255     /**
256      * @notice Calculates the minimum Hop LP to accept when burning LP tokens to withdraw from Curve Pool.
257      * @param _lpAmount Amount of LP tokens being burned to withdraw from Curve Pool.
258      * @return The mininum Hop LP balance to accept.
259      */
260     function _minHopLpAcceptedFromWithdraw(uint256 _lpAmount) internal view returns (uint256) {
261         return _lpToHopLp(_lpAmount).scaledMul(ScaledMath.ONE - imbalanceToleranceOut);
262     }
263 
264     /**
265      * @notice Calculates the minimum Hop LP to accept when depositing underlying into Curve Hop Pool.
266      * @param _underlyingAmount Amount of underlying that is being deposited into Curve Hop Pool.
267      * @return The minimum Hop LP balance to accept.
268      */
269     function _minHopLpAcceptedFromDeposit(uint256 _underlyingAmount)
270         internal
271         view
272         returns (uint256)
273     {
274         return
275             _underlyingToHopLp(_underlyingAmount).scaledMul(
276                 ScaledMath.ONE - hopImbalanceToleranceIn
277             );
278     }
279 
280     /**
281      * @notice Calculates the maximum Hop LP to accept burning when withdrawing amount from Curve Hop Pool.
282      * @param _underlyingAmount Amount of underlying that is being widthdrawn from Curve Hop Pool.
283      * @return The maximum Hop LP balance to accept burning.
284      */
285     function _maxHopLpBurned(uint256 _underlyingAmount) internal view returns (uint256) {
286         return
287             _underlyingToHopLp(_underlyingAmount).scaledMul(
288                 ScaledMath.ONE + hopImbalanceToleranceOut
289             );
290     }
291 
292     /**
293      * @notice Calculates the minimum underlying to accept when burning Hop LP tokens to withdraw from Curve Hop Pool.
294      * @param _hopLpAmount Amount of Hop LP tokens being burned to withdraw from Curve Hop Pool.
295      * @return The mininum underlying balance to accept.
296      */
297     function _minUnderlyingAccepted(uint256 _hopLpAmount) internal view returns (uint256) {
298         return
299             _hopLpToUnderlying(_hopLpAmount).scaledMul(ScaledMath.ONE - hopImbalanceToleranceOut);
300     }
301 
302     /**
303      * @notice Converts an amount of underlying into their estimated Hop LP value.
304      * @dev Uses get_virtual_price which is less suceptible to manipulation.
305      *  But is also less accurate to how much could be withdrawn.
306      * @param _underlyingAmount Amount of underlying to convert.
307      * @return The estimated value in the Hop LP.
308      */
309     function _underlyingToHopLp(uint256 _underlyingAmount) internal view returns (uint256) {
310         return (_underlyingAmount * decimalMultiplier).scaledDiv(curveHopPool.get_virtual_price());
311     }
312 
313     /**
314      * @notice Converts an amount of Hop LP into their estimated underlying value.
315      * @dev Uses get_virtual_price which is less suceptible to manipulation.
316      *  But is also less accurate to how much could be withdrawn.
317      * @param _hopLpAmount Amount of Hop LP to convert.
318      * @return The estimated value in the underlying.
319      */
320     function _hopLpToUnderlying(uint256 _hopLpAmount) internal view returns (uint256) {
321         return (_hopLpAmount / decimalMultiplier).scaledMul(curveHopPool.get_virtual_price());
322     }
323 
324     /**
325      * @notice Converts an amount of LP into their estimated Hop LP value.
326      * @dev Uses get_virtual_price which is less suceptible to manipulation.
327      *  But is also less accurate to how much could be withdrawn.
328      * @param _lpAmount Amount of underlying to convert.
329      * @return The estimated value in the Hop LP.
330      */
331     function _lpToHopLp(uint256 _lpAmount) internal view returns (uint256) {
332         return
333             _lpAmount.scaledMul(curvePool.get_virtual_price()).scaledDiv(
334                 curveHopPool.get_virtual_price()
335             );
336     }
337 
338     /**
339      * @notice Converts an amount of Hop LP into their estimated LP value.
340      * @dev Uses get_virtual_price which is less suceptible to manipulation.
341      *  But is also less accurate to how much could be withdrawn.
342      * @param _hopLpAmount Amount of Hop LP to convert.
343      * @return The estimated value in the LP.
344      */
345     function _hopLpToLp(uint256 _hopLpAmount) internal view returns (uint256) {
346         return
347             _hopLpAmount.scaledMul(curveHopPool.get_virtual_price()).scaledDiv(
348                 curvePool.get_virtual_price()
349             );
350     }
351 
352     /**
353      * @dev Withdraw all underlying and convert to the Hop LP Token.
354      */
355     function _withdrawAllToHopLp() private {
356         // Unstaking and withdrawing from Convex pool
357         uint256 stakedBalance = _stakedBalance();
358         if (stakedBalance > 0) {
359             rewards.withdrawAndUnwrap(stakedBalance, false);
360         }
361 
362         // Removing liquidity from Curve Pool
363         uint256 lpBalance = _lpBalance();
364         if (lpBalance > 0) {
365             curvePool.remove_liquidity_one_coin(
366                 lpBalance,
367                 int128(uint128(curveIndex)),
368                 _minHopLpAcceptedFromWithdraw(lpBalance)
369             );
370         }
371     }
372 }
