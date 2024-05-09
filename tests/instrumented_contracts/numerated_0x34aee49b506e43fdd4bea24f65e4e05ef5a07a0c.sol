1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0 <0.9.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address to, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(
11         address from,
12         address to,
13         uint256 amount
14     ) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 abstract contract Auth {
20 
21     address internal owner;
22     mapping (address => bool) internal authorizations;
23 
24     constructor(address _owner) {
25         owner = _owner;
26         authorizations[_owner] = true;
27     }
28 
29     modifier onlyOwner() {
30         require(isOwner(msg.sender), "!OWNER"); _;
31     }
32 
33     modifier authorized() {
34         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
35     }
36 
37     function authorize(address adr) public onlyOwner {
38         authorizations[adr] = true;
39     }
40 
41     function unauthorize(address adr) public onlyOwner {
42         authorizations[adr] = false;
43     }
44 
45     function isOwner(address account) public view returns (bool) {
46         return account == owner;
47     }
48 
49     function isAuthorized(address adr) public view returns (bool) {
50         return authorizations[adr];
51     }
52 
53     function transferOwnership(address payable adr) public onlyOwner {
54         owner = adr;
55         authorizations[adr] = true;
56         emit OwnershipTransferred(adr);
57     }
58 
59     event OwnershipTransferred(address owner);
60 }
61 
62 contract PyroStaking is Auth {
63 
64     struct PoolConfiguration {
65         uint256 poolStakedTokens;
66 		uint16 apr;
67 		uint16 depositFee;
68         uint16 earlyWithdrawFee;
69         uint32 withdrawLockPeriod;
70 		bool available;
71 		bool burnDeposit;
72     }
73 
74 	struct StakeState {
75 		uint256 stakedAmount;
76 		uint256 rewardDebt; 
77 		uint32 lastChangeTime;
78 		uint32 lockEndTime;
79 	}
80 
81 	event TokenStaked(address indexed user, uint256 amount);
82 	event TokenUnstaked(address indexed user, uint256 amount);
83 	event RewardClaimed(address indexed user, uint256 outAmount);
84 	event PoolAvailability(bool available);
85 	event PoolConfigurated(uint16 apr, uint16 depositFee, uint32 lockPeriod, uint16 earlyWithdrawFee);
86 	event DepositFeeBurnStatus(bool active);
87 	event DepositFeeBurn(uint256 burn);
88 	event StakingTokenUpdate(address indexed oldToken, address indexed newToken);
89 
90 	// Informs about the address for the token being used for staking.
91 	address public stakingToken;
92 
93     // Taxes are set in /10000.
94 	// Using solidity underscore separator for easier reading.
95 	// Digits before underscore are the percentage.
96 	// Digits after underscore are decimals for said percentage.
97     uint256 public immutable denominator = 100_00;
98 
99     // Staking pool configuration.
100 	PoolConfiguration private poolConfig;
101 
102 	// Info of each user that stakes tokens.
103 	mapping (address => StakeState) public stakerDetails;
104 
105 	// Burn address.
106 	address public immutable DEAD = address(0xdead);
107 
108 	constructor(address t) Auth(msg.sender) {
109 		stakingToken = t;
110 
111 		uint16 apr = 100_00; // 100%
112 		uint16 depositFee = 3_00; // 3%
113 		uint16 earlyWithdrawFee = 50_00; // 50%
114 		uint32 lockPeriod = 30 days;
115 		bool available = true;
116 
117 		_setStakingConfig(apr, depositFee, earlyWithdrawFee, lockPeriod, available, false);
118 	}
119 
120 	modifier noStakes {
121 		require(poolConfig.poolStakedTokens == 0, "Action can only be done when there are no staked tokens.");
122 		_;
123 	}
124 
125 	modifier positiveAPR(uint16 apr) {
126 		require(apr > 0, "APR cannot be 0.");
127 		_;
128 	}
129 
130 	modifier validFee(uint16 fee) {
131 		require(fee <= 5000, "Fees cannot be more than 50%.");
132 		_;
133 	}
134 
135 	modifier validLockPeriod(uint32 time) {
136 		require(time < 365 days, "Lockout period should be less than a year.");
137 		_;
138 	}
139 
140 	function setPoolConfiguration(
141 		uint16 apr, uint16 depositFee, uint16 earlyWithdrawFee, uint32 withdrawLockPeriod, bool active, bool burn
142 	)
143 		external authorized noStakes positiveAPR(apr)
144 		validFee(depositFee) validFee(earlyWithdrawFee)
145 		validLockPeriod(withdrawLockPeriod)
146 	{		
147 		_setStakingConfig(apr, depositFee, earlyWithdrawFee, withdrawLockPeriod, active, burn);
148 	}
149 
150 	/**
151 	 * @dev Internal function for updating full stake configuration.
152 	 */
153 	function _setStakingConfig(
154 		uint16 apr, uint16 depositFee, uint16 earlyWithdrawFee, uint32 withdrawLockPeriod, bool active, bool burn
155 	) internal {
156 		poolConfig.apr = apr;
157 		poolConfig.depositFee = depositFee;
158         poolConfig.earlyWithdrawFee = earlyWithdrawFee;
159 		poolConfig.withdrawLockPeriod = withdrawLockPeriod;
160 		poolConfig.available = active;
161 		poolConfig.burnDeposit = burn;
162 
163 		emit PoolConfigurated(apr, depositFee, withdrawLockPeriod, earlyWithdrawFee);
164 		emit PoolAvailability(active);
165 		emit DepositFeeBurnStatus(burn);
166 	}
167 
168 	/**
169 	 * @dev Sets APR out of / 10000.
170 	 * Each 100 means 1%.
171 	 */
172 	function setAPR(uint16 apr) external authorized positiveAPR(apr) {
173 		if (poolConfig.poolStakedTokens > 0) {
174 			require(apr >= poolConfig.apr, "APR cannot be lowered while there are tokens staked.");
175 		}
176 		poolConfig.apr = apr;
177 
178 		emit PoolConfigurated(apr, poolConfig.depositFee, poolConfig.withdrawLockPeriod, poolConfig.earlyWithdrawFee);
179 	}
180 
181 	/**
182 	 * @dev Sets deposit fee out of / 10000.
183 	 */
184 	function setDepositFee(uint16 fee) external authorized validFee(fee) {
185 		poolConfig.depositFee = fee;
186 
187 		emit PoolConfigurated(poolConfig.apr, fee, poolConfig.withdrawLockPeriod, poolConfig.earlyWithdrawFee);
188 	}
189 
190 	/**
191 	 * @dev Early withdraw fee out of / 10000.
192 	 */
193 	function setEarlyWithdrawFee(uint16 fee) external authorized validFee(fee) {
194 		poolConfig.earlyWithdrawFee = fee;
195 
196 		emit PoolConfigurated(poolConfig.apr, poolConfig.depositFee, poolConfig.withdrawLockPeriod, fee);
197 	}
198 
199 	/**
200 	 * @dev Pool can be set inactive to end staking after the last lock and restart with new values.
201 	 */
202 	function setPoolAvailable(bool active) external authorized {
203 		poolConfig.available = active;
204 		emit PoolAvailability(active);
205 	}
206 
207 	/**
208 	 * @dev Early withdraw penalty in seconds.
209 	 */
210 	function setEarlyWithdrawLock(uint32 time) external authorized noStakes validLockPeriod(time) {
211 		poolConfig.withdrawLockPeriod = time;
212 		emit PoolConfigurated(poolConfig.apr, poolConfig.depositFee, time, poolConfig.earlyWithdrawFee);
213 	}
214 
215 	function setFeeBurn(bool burn) external authorized {
216 		poolConfig.burnDeposit = burn;
217 		emit DepositFeeBurnStatus(burn);
218 	}
219 
220     function updateStakingToken(address t) external authorized noStakes {
221 		emit StakingTokenUpdate(stakingToken, t);
222         stakingToken = t;
223     }
224 
225 	/**
226 	 * @dev Check the current unclaimed pending reward for a specific stake.
227 	 */
228 	function pendingReward(address account) public view returns (uint256) {
229 		StakeState storage user = stakerDetails[account];
230 		// Last change time of 0 means there's never been a stake to begin with.
231 		if (user.lastChangeTime == 0) {
232 			return 0;
233 		}
234 
235 		// Ellapsed time since staking and now.
236 		if (block.timestamp <= user.lastChangeTime) {
237 			return 0;
238 		}
239 		uint256 deltaTime = block.timestamp - user.lastChangeTime;
240 		uint256 accrued = yieldFromElapsedTime(user.stakedAmount, deltaTime);
241 
242 		return accrued + user.rewardDebt;
243 	}
244 
245 	function yieldFromElapsedTime(uint256 amount, uint256 deltaTime) public view returns (uint256) {
246 		// No elapsed time or no amount means no reward accrued.
247 		if (amount == 0 || deltaTime == 0) {
248 			return 0;
249 		}
250 
251 		/**
252 		 * It's quite simple to derive owed reward from time using the set duration (APR):
253 		 * Total cycle reward plus time elapsed divided by cycle duration.
254 		 * Time is counted by seconds, so we divide the total reward by seconds and calculate the amount due to seconds passed.
255 		 */
256 		uint256 annuality = annualYield(amount);
257 		if (annuality == 0) {
258 			return 0;
259 		}
260 
261 		return (deltaTime * annuality) / 365 days;
262 	}
263 
264 	/**
265 	 * @dev Given an amount to stake returns a total yield as per APR.
266 	 */
267 	function annualYield(uint256 amount) public view returns (uint256) {
268 		if (amount == 0 || poolConfig.apr == 0) {
269 			return 0;
270 		}
271 
272 		return amount * poolConfig.apr / denominator;
273 	}
274 
275 	function dailyYield(uint256 amount) external view returns (uint256) {
276 		// Due to how Solidity decimals work, any amount less than 365 will yield 0 per day.
277 		// On a 9 decimal token this means less than 0.000000365 -- basically nothing at all.
278 		// Once the time has surpassed 365 days the yield will be owed normally as soon as the decimal place jumps.
279 		if (amount < 365) {
280 			return 0;
281 		}
282 		if (amount == 365) {
283 			return 1;
284 		}
285 
286 		return annualYield(amount) / 365;
287 	}
288 
289 	function stake(uint256 amount) external {
290 		require(amount > 0, "Amount needs to be bigger than 0");
291 		require(poolConfig.available, "Pool is not accepting staking right now.");
292 
293 		IERC20(stakingToken).transferFrom(msg.sender, address(this), amount);
294 		StakeState storage user = stakerDetails[msg.sender];
295 		// Calc unclaimed reward on stake update.
296 		if (user.lastChangeTime != 0 && user.stakedAmount > 0) {
297 			user.rewardDebt = pendingReward(msg.sender);
298 		}
299         uint256 stakeAmount = amount;
300 
301         // Check deposit fee
302         if (poolConfig.depositFee > 0) {
303             uint256 dFee = depositFeeFromAmount(amount);
304             stakeAmount -= dFee;
305 			// If the pool has enough for rewards, deposit fee can be sent to burn address instead.
306 			if (poolConfig.burnDeposit) {
307 				IERC20(stakingToken).transfer(DEAD, dFee);
308 				emit DepositFeeBurn(dFee);
309 			}
310         }
311 
312 		user.stakedAmount += stakeAmount;
313 		uint32 rnow = uint32(block.timestamp);
314 		user.lastChangeTime = rnow;
315         if (user.lockEndTime == 0) {
316             user.lockEndTime = rnow + poolConfig.withdrawLockPeriod;
317         }
318 		poolConfig.poolStakedTokens += stakeAmount;
319 
320 		emit TokenStaked(msg.sender, stakeAmount);
321 	}
322 
323 	function depositFeeFromAmount(uint256 amount) public view returns (uint256) {
324 		if (poolConfig.depositFee == 0) {
325 			return 0;
326 		}
327 		return amount * poolConfig.depositFee / denominator;
328 	}
329 
330 	function unstake() external {
331 		unstakeFor(msg.sender);
332 	}
333 
334 	function unstakeFor(address staker) internal {
335 		StakeState storage user = stakerDetails[staker];
336 		uint256 amount = user.stakedAmount;
337 		require(amount > 0, "No stake on pool.");
338 
339 		// Update user staking status.
340 		// When unstaking is done, claim is automatically done.
341 		_claim(staker);
342 		user.stakedAmount = 0;
343 
344 		uint256 unstakeAmount = amount;
345         // Check for early withdraw fee.
346         if (block.timestamp < user.lockEndTime && poolConfig.earlyWithdrawFee > 0) {
347             uint256 fee = amount * poolConfig.earlyWithdrawFee / denominator;
348             unstakeAmount -= fee;
349         }
350         user.lockEndTime = 0;
351 
352 		IERC20 stakedToken = IERC20(stakingToken);
353 		// Check for a clear revert error if rewards+unstake surpass balance.
354 		require(stakedToken.balanceOf(address(this)) >= unstakeAmount, "Staking contract does not have enough tokens.");
355 
356 		// Return token to staker and update staking values.
357 		stakedToken.transfer(staker, unstakeAmount);
358 		poolConfig.poolStakedTokens -= amount;
359 
360 		emit TokenUnstaked(staker, unstakeAmount);
361 	}
362 
363 	function claim() external {
364 		_claim(msg.sender);
365 	}
366 
367 	/**
368 	 * @dev Allows an authorised account to finalise a staking that has not claimed nor unstaked while the period is over.
369 	 */
370 	function forceClaimUnstake(address staker) external authorized {
371 		// Pool must not be available for staking, otherwise the user should be free to renew their stake.
372 		require(!poolConfig.available, "Pool is still available.");
373 		// The stake must have finished its lock time and accrued all the APR.
374 		require(block.timestamp > stakerDetails[staker].lockEndTime, "User's lock time has not finished yet.");
375 		// Run their claim and unstake.
376 		unstakeFor(staker);
377 	}
378 
379 	function _claim(address staker) internal {
380 		StakeState storage user = stakerDetails[staker];
381 		uint256 outAmount = pendingReward(staker);
382 		if (outAmount > 0) {
383 			// Check for a clear revert error if rewards+unstake surpass balance.
384 			uint256 contractBalance = IERC20(stakingToken).balanceOf(address(this));
385 			require(contractBalance >= outAmount, "Staking contract does not own enough tokens.");
386 
387 			IERC20(stakingToken).transfer(staker, outAmount);
388 			user.rewardDebt = 0;
389 			user.lastChangeTime = uint32(block.timestamp);
390 
391 			emit RewardClaimed(staker, outAmount);
392 		}
393 	}
394 
395 	/**
396 	 * @dev Checks whether there's a stake withdraw fee or not.
397 	 */
398 	function canWithdrawTokensNoFee(address user) external view returns (bool) {
399 		if (stakerDetails[user].lastChangeTime == 0) {
400 			return false;
401 		}
402 
403 		return block.timestamp > stakerDetails[user].lockEndTime;
404 	}
405 
406 	/**
407 	 * @dev Rescue non staking tokens sent to this contract by accident.
408 	 */
409 	function rescueToken(address t, address receiver) external authorized {
410 		require(t != stakingToken, "Staking token can't be withdrawn!");
411 		uint256 balance = IERC20(t).balanceOf(address(this));
412 		IERC20(t).transfer(receiver, balance);
413 	}
414 
415 	function viewPoolDetails() external view returns (PoolConfiguration memory) {
416 		return poolConfig;
417 	}
418 
419 	function viewStake(address staker) public view returns (StakeState memory) {
420 		return stakerDetails[staker];
421 	}
422 
423 	function viewMyStake() external view returns (StakeState memory) {
424 		return viewStake(msg.sender);
425 	}
426 
427 	function viewMyPendingReward() external view returns (uint256) {
428 		return pendingReward(msg.sender);
429 	}
430 
431 	/**
432 	 * @dev Returns APR in percentage.
433 	 */
434 	function viewAPRPercent() external view returns (uint16) {
435 		return poolConfig.apr / 100;
436 	}
437 
438 	/**
439 	 * @dev Returns APR in percentage and 2 decimal points in an extra varaible.
440 	 */
441 	function viewAPRPercentDecimals() external view returns (uint16 aprPercent, uint16 decimalValue) {
442 		return (poolConfig.apr / 100, poolConfig.apr % 100);
443 	}
444 
445 	/**
446 	 * @dev Given a theroetical stake, returns the unstake returning amount, deposit fee paid, and yield on a full cycle.
447 	 */
448 	function simulateYearStake(uint256 amount) external view returns (uint256 unstakeAmount, uint256 depositFee, uint256 yield) {
449 		if (amount == 0) {
450 			return (0, 0, 0);
451 		}
452 		uint256 fee = depositFeeFromAmount(amount);
453 		uint256 actual = amount - fee;
454 		uint256 y = annualYield(actual);
455 
456 		return (actual, fee, y);
457 	}
458 
459 	/**
460 	 * @dev Given an amount to stake and a duration, returns unstake returning amount, deposit fee paid, and yield.
461 	 */
462 	function simulateStake(uint256 amount, uint32 duration) external view returns (uint256 unstakeAmount, uint256 depositFee, uint256 yield) {
463 		if (amount == 0 || duration == 0) {
464 			return (0, 0, 0);
465 		}
466 		uint256 fee = depositFeeFromAmount(amount);
467 		uint256 actual = amount - fee;
468 		uint256 y = yieldFromElapsedTime(actual, duration);
469 		if (duration < poolConfig.withdrawLockPeriod && poolConfig.earlyWithdrawFee > 0) {
470             uint256 withdrawFee = amount * poolConfig.earlyWithdrawFee / denominator;
471             actual -= withdrawFee;
472         }
473 
474 		return (actual, fee, y);
475 	}
476 
477 	/**
478 	 * @dev Returns total amount of tokens staked by users.
479 	 */
480 	function totalStakedTokens() external view returns (uint256) {
481 		return poolConfig.poolStakedTokens;
482 	}
483 }