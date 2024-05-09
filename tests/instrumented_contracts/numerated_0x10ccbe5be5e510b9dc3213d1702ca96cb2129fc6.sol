1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 
4 /*
5 
6 Become The King ($RULER)
7 - 1 trillion supply
8 - 99% of supply is used as liquidity, locked permanently
9 - a 'ruler' that collects the LP fees
10 - lock more tokens than the current ruler to usurp them
11 - locked tokens are returned to the original ruler when usurped
12 - the ruler can add to their own locked tokens
13 - the ruler can also unlock tokens and return them to their wallet
14 - 10% transfer and buy fee (no sell fee), disbursed to holders (8%) and ruler (2%)
15 - no fee on locks/unlocks
16 
17 Obviously don't buy the token unless you know the risks.
18 Good luck and have fun!
19 
20 https://ruler.tax
21 
22 */
23 
24 interface Callable {
25 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
26 }
27 
28 interface Router {
29 	function factory() external view returns (address);
30 	function positionManager() external view returns (address);
31 	function WETH9() external view returns (address);
32 }
33 
34 interface Factory {
35 	function createPool(address _tokenA, address _tokenB, uint24 _fee) external returns (address);
36 }
37 
38 interface Pool {
39 	function initialize(uint160 _sqrtPriceX96) external;
40 }
41 
42 interface Params {
43 	struct MintParams {
44 		address token0;
45 		address token1;
46 		uint24 fee;
47 		int24 tickLower;
48 		int24 tickUpper;
49 		uint256 amount0Desired;
50 		uint256 amount1Desired;
51 		uint256 amount0Min;
52 		uint256 amount1Min;
53 		address recipient;
54 		uint256 deadline;
55 	}
56 	struct CollectParams {
57 		uint256 tokenId;
58 		address recipient;
59 		uint128 amount0Max;
60 		uint128 amount1Max;
61 	}
62 }
63 
64 interface PositionManager is Params {
65 	function mint(MintParams calldata) external payable returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
66 	function collect(CollectParams calldata) external payable returns (uint256 amount0, uint256 amount1);
67 }
68 
69 
70 contract RULER is Params {
71 
72 	uint256 constant private FLOAT_SCALAR = 2**64;
73 	uint256 constant private UINT_MAX = type(uint256).max;
74 	uint128 constant private UINT128_MAX = type(uint128).max;
75 	uint256 constant private INITIAL_SUPPLY = 1e30; // 1 trillion
76 	Router constant private ROUTER = Router(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
77 	uint256 constant private INITIAL_ETH_MC = 1e3 ether; // 1,000 ETH initial market cap price
78 	uint256 constant private CONCENTRATED_PERCENT = 5; // 5% of tokens will be sold at the min price (50 ETH)
79 	uint256 constant private UPPER_ETH_MC = 1e5 ether; // 100,000 ETH max market cap price
80 	uint256 constant private INITIAL_RULER_TOKENS_PERCENT = 1; // 1%
81 	uint256 constant private TRANSFER_FEE = 10; // 10%
82 	uint256 constant private RULER_FEE = 2; // 2% of the 10% transfer fee goes to ruler, 8% to everyone else
83 
84 	int24 constant internal MIN_TICK = -887272;
85 	int24 constant internal MAX_TICK = -MIN_TICK;
86 	uint160 constant internal MIN_SQRT_RATIO = 4295128739;
87 	uint160 constant internal MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
88 
89 	string constant public name = "Become The King";
90 	string constant public symbol = "RULER";
91 	uint8 constant public decimals = 18;
92 
93 	struct User {
94 		uint256 balance;
95 		mapping(address => uint256) allowance;
96 		int256 scaledPayout;
97 	}
98 
99 	struct Info {
100 		address pool;
101 		address ruler;
102 		uint256 rulerLocked;
103 		uint256 totalSupply;
104 		uint256 scaledRewardsPerToken;
105 		mapping(address => User) users;
106 		uint256 lowerPositionId;
107 		uint256 upperPositionId;
108 	}
109 	Info private info;
110 
111 
112 	event Transfer(address indexed from, address indexed to, uint256 tokens);
113 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
114 	event ClaimRewards(address indexed user, uint256 amount);
115 	event Locked(address indexed ruler, uint256 amount);
116 	event Unlocked(address indexed ruler, uint256 amount);
117 	event Reward(uint256 amount);
118 
119 
120 	modifier _onlyRuler() {
121 		require(msg.sender == ruler());
122 		_;
123 	}
124 
125 
126 	constructor() {
127 		address _this = address(this);
128 		address _weth = ROUTER.WETH9();
129 		(uint160 _initialSqrtPrice, ) = _getPriceAndTickFromValues(_weth < _this, INITIAL_SUPPLY, INITIAL_ETH_MC);
130 		info.pool = Factory(ROUTER.factory()).createPool(_this, _weth, 10000);
131 		Pool(pool()).initialize(_initialSqrtPrice);
132 	}
133 
134 	function setRuler(address _ruler) external _onlyRuler {
135 		info.ruler = _ruler;
136 	}
137 	
138 	function unlock(uint256 _amount) external _onlyRuler {
139 		unchecked {
140 			require(rulerLocked() >= _amount);
141 			info.rulerLocked -= _amount;
142 			_transfer(address(this), ruler(), _amount);
143 			emit Unlocked(ruler(), _amount);
144 		}
145 	}
146 
147 	
148 	function initialize() external {
149 		require(totalSupply() == 0);
150 		address _this = address(this);
151 		address _weth = ROUTER.WETH9();
152 		bool _weth0 = _weth < _this;
153 		PositionManager _pm = PositionManager(ROUTER.positionManager());
154 		info.totalSupply = INITIAL_SUPPLY;
155 		info.ruler = 0xFaDED72464D6e76e37300B467673b36ECc4d2ccF;
156 		info.rulerLocked = INITIAL_RULER_TOKENS_PERCENT * INITIAL_SUPPLY / 100;
157 		emit Locked(ruler(), rulerLocked());
158 		info.users[_this].balance = INITIAL_SUPPLY;
159 		emit Transfer(address(0x0), _this, INITIAL_SUPPLY);
160 		_approve(_this, address(_pm), INITIAL_SUPPLY - rulerLocked());
161 		( , int24 _minTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, INITIAL_ETH_MC);
162 		( , int24 _maxTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, UPPER_ETH_MC);
163 		uint256 _concentratedTokens = CONCENTRATED_PERCENT * INITIAL_SUPPLY / 100;
164 		(info.lowerPositionId, , , ) = _pm.mint(MintParams({
165 			token0: _weth0 ? _weth : _this,
166 			token1: !_weth0 ? _weth : _this,
167 			fee: 10000,
168 			tickLower: _weth0 ? _minTick - 200 : _minTick,
169 			tickUpper: !_weth0 ? _minTick + 200 : _minTick,
170 			amount0Desired: _weth0 ? 0 : _concentratedTokens,
171 			amount1Desired: !_weth0 ? 0 : _concentratedTokens,
172 			amount0Min: 0,
173 			amount1Min: 0,
174 			recipient: _this,
175 			deadline: block.timestamp
176 		}));
177 		(info.upperPositionId, , , ) = _pm.mint(MintParams({
178 			token0: _weth0 ? _weth : _this,
179 			token1: !_weth0 ? _weth : _this,
180 			fee: 10000,
181 			tickLower: _weth0 ? _maxTick : _minTick + 200,
182 			tickUpper: !_weth0 ? _maxTick : _minTick - 200,
183 			amount0Desired: _weth0 ? 0 : INITIAL_SUPPLY - _concentratedTokens - rulerLocked(),
184 			amount1Desired: !_weth0 ? 0 : INITIAL_SUPPLY - _concentratedTokens - rulerLocked(),
185 			amount0Min: 0,
186 			amount1Min: 0,
187 			recipient: _this,
188 			deadline: block.timestamp
189 		}));
190 	}
191 
192 	function collectTradingFees() public {
193 		PositionManager _pm = PositionManager(ROUTER.positionManager());
194 		_pm.collect(CollectParams({
195 			tokenId: info.lowerPositionId,
196 			recipient: ruler(),
197 			amount0Max: UINT128_MAX,
198 			amount1Max: UINT128_MAX
199 		}));
200 		_pm.collect(CollectParams({
201 			tokenId: info.upperPositionId,
202 			recipient: ruler(),
203 			amount0Max: UINT128_MAX,
204 			amount1Max: UINT128_MAX
205 		}));
206 	}
207 
208 	function lock(uint256 _amount) external {
209 		unchecked {
210 			if (msg.sender == ruler()) {
211 				transfer(address(this), _amount);
212 				info.rulerLocked += _amount;
213 			} else {
214 				require(_amount > rulerLocked());
215 				collectTradingFees();
216 				_transfer(address(this), ruler(), rulerLocked());
217 				emit Unlocked(ruler(), rulerLocked());
218 				transfer(address(this), _amount);
219 				info.ruler = msg.sender;
220 				info.rulerLocked = _amount;
221 			}
222 			emit Locked(ruler(), _amount);
223 		}
224 	}
225 
226 	function claimRewards() external {
227 		unchecked {
228 			uint256 _rewards = rewardsOf(msg.sender);
229 			if (_rewards > 0) {
230 				info.users[msg.sender].scaledPayout += int256(_rewards * FLOAT_SCALAR);
231 				_transfer(address(this), msg.sender, _rewards);
232 				emit ClaimRewards(msg.sender, _rewards);
233 			}
234 		}
235 	}
236 	
237 	function burn(uint256 _tokens) external {
238 		_burn(msg.sender, _tokens);
239 	}
240 
241 	function transfer(address _to, uint256 _tokens) public returns (bool) {
242 		return _transfer(msg.sender, _to, _tokens);
243 	}
244 
245 	function approve(address _spender, uint256 _tokens) external returns (bool) {
246 		return _approve(msg.sender, _spender, _tokens);
247 	}
248 
249 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
250 		unchecked {
251 			uint256 _allowance = allowance(_from, msg.sender);
252 			require(_allowance >= _tokens);
253 			if (_allowance != UINT_MAX) {
254 				info.users[_from].allowance[msg.sender] -= _tokens;
255 			}
256 			return _transfer(_from, _to, _tokens);
257 		}
258 	}
259 
260 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
261 		unchecked {
262 			uint256 _balanceBefore = balanceOf(_to);
263 			_transfer(msg.sender, _to, _tokens);
264 			uint256 _tokensReceived = balanceOf(_to) - _balanceBefore;
265 			uint32 _size;
266 			assembly {
267 				_size := extcodesize(_to)
268 			}
269 			if (_size > 0) {
270 				require(Callable(_to).tokenCallback(msg.sender, _tokensReceived, _data));
271 			}
272 			return true;
273 		}
274 	}
275 	
276 
277 	function pool() public view returns (address) {
278 		return info.pool;
279 	}
280 
281 	function ruler() public view returns (address) {
282 		return info.ruler;
283 	}
284 
285 	function rulerLocked() public view returns (uint256) {
286 		return info.rulerLocked;
287 	}
288 
289 	function totalSupply() public view returns (uint256) {
290 		return info.totalSupply;
291 	}
292 
293 	function balanceOf(address _user) public view returns (uint256) {
294 		return info.users[_user].balance;
295 	}
296 
297 	function rewardsOf(address _user) public view returns (uint256) {
298 		return uint256(int256(info.scaledRewardsPerToken * balanceOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
299 	}
300 
301 	function allowance(address _user, address _spender) public view returns (uint256) {
302 		return info.users[_user].allowance[_spender];
303 	}
304 
305 	function positions() external view returns (uint256 lower, uint256 upper) {
306 		return (info.lowerPositionId, info.upperPositionId);
307 	}
308 
309 	function allInfoFor(address _user) external view returns (address currentRuler, uint256 rulerLockedTokens, uint256 totalTokens, uint256 userBalance, uint256 userRewards) {
310 		return (ruler(), rulerLocked(), totalSupply(), balanceOf(_user), rewardsOf(_user));
311 	}
312 
313 
314 	function _burn(address _account, uint256 _tokens) internal {
315 		unchecked {
316 			require(balanceOf(_account) >= _tokens);
317 			info.totalSupply -= _tokens;
318 			info.users[_account].balance -= _tokens;
319 			info.users[_account].scaledPayout -= int256(_tokens * info.scaledRewardsPerToken);
320 			emit Transfer(_account, address(0x0), _tokens);
321 		}
322 	}
323 	
324 	function _approve(address _owner, address _spender, uint256 _tokens) internal returns (bool) {
325 		info.users[_owner].allowance[_spender] = _tokens;
326 		emit Approval(_owner, _spender, _tokens);
327 		return true;
328 	}
329 	
330 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
331 		unchecked {
332 			require(balanceOf(_from) >= _tokens);
333 			info.users[_from].balance -= _tokens;
334 			info.users[_from].scaledPayout -= int256(_tokens * info.scaledRewardsPerToken);
335 			address _this = address(this);
336 			address _pm = ROUTER.positionManager();
337 			uint256 _fee = 0;
338 			if (!(_from == _this || _to == _this || _to == pool() || _from == _pm || _to == _pm)) {
339 				_fee = _tokens * TRANSFER_FEE / 100;
340 				info.users[_this].balance += _fee;
341 				emit Transfer(_from, _this, _fee);
342 			}
343 			uint256 _transferred = _tokens - _fee;
344 			info.users[_to].balance += _transferred;
345 			info.users[_to].scaledPayout += int256(_transferred * info.scaledRewardsPerToken);
346 			emit Transfer(_from, _to, _transferred);
347 			_disburse(_fee);
348 			return true;
349 		}
350 	}
351 
352 	function _disburse(uint256 _amount) internal {
353 		unchecked {
354 			if (_amount > 0) {
355 				uint256 _rulerReward = RULER_FEE * _amount / TRANSFER_FEE;
356 				info.users[ruler()].scaledPayout -= int256(_rulerReward * FLOAT_SCALAR);
357 				info.scaledRewardsPerToken += (_amount - _rulerReward) * FLOAT_SCALAR / (totalSupply() - balanceOf(pool()) - balanceOf(address(this)));
358 				emit Reward(_amount);
359 			}
360 		}
361 	}
362 
363 
364 	function _getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
365 		unchecked {
366 			uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
367 			require(absTick <= uint256(int256(MAX_TICK)), 'T');
368 
369 			uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
370 			if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
371 			if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
372 			if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
373 			if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
374 			if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
375 			if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
376 			if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
377 			if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
378 			if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
379 			if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
380 			if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
381 			if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
382 			if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
383 			if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
384 			if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
385 			if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
386 			if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
387 			if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
388 			if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
389 
390 			if (tick > 0) ratio = type(uint256).max / ratio;
391 
392 			sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
393 		}
394 	}
395 
396 	function _getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
397 		unchecked {
398 			require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
399 			uint256 ratio = uint256(sqrtPriceX96) << 32;
400 
401 			uint256 r = ratio;
402 			uint256 msb = 0;
403 
404 			assembly {
405 				let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
406 				msb := or(msb, f)
407 				r := shr(f, r)
408 			}
409 			assembly {
410 				let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
411 				msb := or(msb, f)
412 				r := shr(f, r)
413 			}
414 			assembly {
415 				let f := shl(5, gt(r, 0xFFFFFFFF))
416 				msb := or(msb, f)
417 				r := shr(f, r)
418 			}
419 			assembly {
420 				let f := shl(4, gt(r, 0xFFFF))
421 				msb := or(msb, f)
422 				r := shr(f, r)
423 			}
424 			assembly {
425 				let f := shl(3, gt(r, 0xFF))
426 				msb := or(msb, f)
427 				r := shr(f, r)
428 			}
429 			assembly {
430 				let f := shl(2, gt(r, 0xF))
431 				msb := or(msb, f)
432 				r := shr(f, r)
433 			}
434 			assembly {
435 				let f := shl(1, gt(r, 0x3))
436 				msb := or(msb, f)
437 				r := shr(f, r)
438 			}
439 			assembly {
440 				let f := gt(r, 0x1)
441 				msb := or(msb, f)
442 			}
443 
444 			if (msb >= 128) r = ratio >> (msb - 127);
445 			else r = ratio << (127 - msb);
446 
447 			int256 log_2 = (int256(msb) - 128) << 64;
448 
449 			assembly {
450 				r := shr(127, mul(r, r))
451 				let f := shr(128, r)
452 				log_2 := or(log_2, shl(63, f))
453 				r := shr(f, r)
454 			}
455 			assembly {
456 				r := shr(127, mul(r, r))
457 				let f := shr(128, r)
458 				log_2 := or(log_2, shl(62, f))
459 				r := shr(f, r)
460 			}
461 			assembly {
462 				r := shr(127, mul(r, r))
463 				let f := shr(128, r)
464 				log_2 := or(log_2, shl(61, f))
465 				r := shr(f, r)
466 			}
467 			assembly {
468 				r := shr(127, mul(r, r))
469 				let f := shr(128, r)
470 				log_2 := or(log_2, shl(60, f))
471 				r := shr(f, r)
472 			}
473 			assembly {
474 				r := shr(127, mul(r, r))
475 				let f := shr(128, r)
476 				log_2 := or(log_2, shl(59, f))
477 				r := shr(f, r)
478 			}
479 			assembly {
480 				r := shr(127, mul(r, r))
481 				let f := shr(128, r)
482 				log_2 := or(log_2, shl(58, f))
483 				r := shr(f, r)
484 			}
485 			assembly {
486 				r := shr(127, mul(r, r))
487 				let f := shr(128, r)
488 				log_2 := or(log_2, shl(57, f))
489 				r := shr(f, r)
490 			}
491 			assembly {
492 				r := shr(127, mul(r, r))
493 				let f := shr(128, r)
494 				log_2 := or(log_2, shl(56, f))
495 				r := shr(f, r)
496 			}
497 			assembly {
498 				r := shr(127, mul(r, r))
499 				let f := shr(128, r)
500 				log_2 := or(log_2, shl(55, f))
501 				r := shr(f, r)
502 			}
503 			assembly {
504 				r := shr(127, mul(r, r))
505 				let f := shr(128, r)
506 				log_2 := or(log_2, shl(54, f))
507 				r := shr(f, r)
508 			}
509 			assembly {
510 				r := shr(127, mul(r, r))
511 				let f := shr(128, r)
512 				log_2 := or(log_2, shl(53, f))
513 				r := shr(f, r)
514 			}
515 			assembly {
516 				r := shr(127, mul(r, r))
517 				let f := shr(128, r)
518 				log_2 := or(log_2, shl(52, f))
519 				r := shr(f, r)
520 			}
521 			assembly {
522 				r := shr(127, mul(r, r))
523 				let f := shr(128, r)
524 				log_2 := or(log_2, shl(51, f))
525 				r := shr(f, r)
526 			}
527 			assembly {
528 				r := shr(127, mul(r, r))
529 				let f := shr(128, r)
530 				log_2 := or(log_2, shl(50, f))
531 			}
532 
533 			int256 log_sqrt10001 = log_2 * 255738958999603826347141;
534 
535 			int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
536 			int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
537 
538 			tick = tickLow == tickHi ? tickLow : _getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
539 		}
540 	}
541 
542 	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
543 		unchecked {
544 			uint256 _tmp = (_n + 1) / 2;
545 			result = _n;
546 			while (_tmp < result) {
547 				result = _tmp;
548 				_tmp = (_n / _tmp + _tmp) / 2;
549 			}
550 		}
551 	}
552 
553 	function _getPriceAndTickFromValues(bool _weth0, uint256 _tokens, uint256 _weth) internal pure returns (uint160 price, int24 tick) {
554 		uint160 _tmpPrice = uint160(_sqrt(2**192 / (!_weth0 ? _tokens : _weth) * (_weth0 ? _tokens : _weth)));
555 		tick = _getTickAtSqrtRatio(_tmpPrice);
556 		tick = tick - (tick % 200);
557 		price = _getSqrtRatioAtTick(tick);
558 	}
559 }