1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 
4 /*
5 
6 Try To Rug Me ($RUGME)
7 - 1 trillion supply
8 - 100% of supply is used as liquidity
9 - 10% transfer and buy fee (no sell fee), all disbursed to holders
10 - a puzzle 'onion' to solve which can rug the liquidity (see bottom of file)
11 - when rugged, 20% goes to the rugger and 80% is refunded to holders
12 
13 Obviously don't buy the token unless you know the risks.
14 Good luck and have fun!
15 
16 */
17 
18 interface Callable {
19 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
20 }
21 
22 interface WETH {
23 	function balanceOf(address) external view returns (uint256);
24 	function transfer(address, uint256) external returns (bool);
25 }
26 
27 interface Router {
28 	function factory() external view returns (address);
29 	function positionManager() external view returns (address);
30 	function WETH9() external view returns (address);
31 }
32 
33 interface Factory {
34 	function createPool(address _tokenA, address _tokenB, uint24 _fee) external returns (address);
35 }
36 
37 interface Pool {
38 	function initialize(uint160 _sqrtPriceX96) external;
39 }
40 
41 interface Params {
42 	struct MintParams {
43 		address token0;
44 		address token1;
45 		uint24 fee;
46 		int24 tickLower;
47 		int24 tickUpper;
48 		uint256 amount0Desired;
49 		uint256 amount1Desired;
50 		uint256 amount0Min;
51 		uint256 amount1Min;
52 		address recipient;
53 		uint256 deadline;
54 	}
55 	struct CollectParams {
56 		uint256 tokenId;
57 		address recipient;
58 		uint128 amount0Max;
59 		uint128 amount1Max;
60 	}
61 	struct DecreaseLiquidityParams {
62 		uint256 tokenId;
63 		uint128 liquidity;
64 		uint256 amount0Min;
65 		uint256 amount1Min;
66 		uint256 deadline;
67 	}
68 }
69 
70 interface PositionManager is Params {
71 	function mint(MintParams calldata) external payable returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
72 	function collect(CollectParams calldata) external payable returns (uint256 amount0, uint256 amount1);
73 	function decreaseLiquidity(DecreaseLiquidityParams calldata) external payable returns (uint256 amount0, uint256 amount1);
74 	function positions(uint256) external view returns (uint96 nonce, address operator, address token0, address token1, uint24 fee, int24 tickLower, int24 tickUpper, uint128 liquidity, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, uint128 tokensOwed0, uint128 tokensOwed1);
75 }
76 
77 
78 contract TickMath {
79 
80 	int24 internal constant MIN_TICK = -887272;
81 	int24 internal constant MAX_TICK = -MIN_TICK;
82 	uint160 internal constant MIN_SQRT_RATIO = 4295128739;
83 	uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
84 
85 
86 	function _getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
87 		unchecked {
88 			uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
89 			require(absTick <= uint256(int256(MAX_TICK)), 'T');
90 
91 			uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
92 			if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
93 			if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
94 			if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
95 			if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
96 			if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
97 			if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
98 			if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
99 			if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
100 			if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
101 			if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
102 			if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
103 			if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
104 			if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
105 			if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
106 			if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
107 			if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
108 			if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
109 			if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
110 			if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
111 
112 			if (tick > 0) ratio = type(uint256).max / ratio;
113 
114 			sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
115 		}
116 	}
117 
118 	function _getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
119 		unchecked {
120 			require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
121 			uint256 ratio = uint256(sqrtPriceX96) << 32;
122 
123 			uint256 r = ratio;
124 			uint256 msb = 0;
125 
126 			assembly {
127 				let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
128 				msb := or(msb, f)
129 				r := shr(f, r)
130 			}
131 			assembly {
132 				let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
133 				msb := or(msb, f)
134 				r := shr(f, r)
135 			}
136 			assembly {
137 				let f := shl(5, gt(r, 0xFFFFFFFF))
138 				msb := or(msb, f)
139 				r := shr(f, r)
140 			}
141 			assembly {
142 				let f := shl(4, gt(r, 0xFFFF))
143 				msb := or(msb, f)
144 				r := shr(f, r)
145 			}
146 			assembly {
147 				let f := shl(3, gt(r, 0xFF))
148 				msb := or(msb, f)
149 				r := shr(f, r)
150 			}
151 			assembly {
152 				let f := shl(2, gt(r, 0xF))
153 				msb := or(msb, f)
154 				r := shr(f, r)
155 			}
156 			assembly {
157 				let f := shl(1, gt(r, 0x3))
158 				msb := or(msb, f)
159 				r := shr(f, r)
160 			}
161 			assembly {
162 				let f := gt(r, 0x1)
163 				msb := or(msb, f)
164 			}
165 
166 			if (msb >= 128) r = ratio >> (msb - 127);
167 			else r = ratio << (127 - msb);
168 
169 			int256 log_2 = (int256(msb) - 128) << 64;
170 
171 			assembly {
172 				r := shr(127, mul(r, r))
173 				let f := shr(128, r)
174 				log_2 := or(log_2, shl(63, f))
175 				r := shr(f, r)
176 			}
177 			assembly {
178 				r := shr(127, mul(r, r))
179 				let f := shr(128, r)
180 				log_2 := or(log_2, shl(62, f))
181 				r := shr(f, r)
182 			}
183 			assembly {
184 				r := shr(127, mul(r, r))
185 				let f := shr(128, r)
186 				log_2 := or(log_2, shl(61, f))
187 				r := shr(f, r)
188 			}
189 			assembly {
190 				r := shr(127, mul(r, r))
191 				let f := shr(128, r)
192 				log_2 := or(log_2, shl(60, f))
193 				r := shr(f, r)
194 			}
195 			assembly {
196 				r := shr(127, mul(r, r))
197 				let f := shr(128, r)
198 				log_2 := or(log_2, shl(59, f))
199 				r := shr(f, r)
200 			}
201 			assembly {
202 				r := shr(127, mul(r, r))
203 				let f := shr(128, r)
204 				log_2 := or(log_2, shl(58, f))
205 				r := shr(f, r)
206 			}
207 			assembly {
208 				r := shr(127, mul(r, r))
209 				let f := shr(128, r)
210 				log_2 := or(log_2, shl(57, f))
211 				r := shr(f, r)
212 			}
213 			assembly {
214 				r := shr(127, mul(r, r))
215 				let f := shr(128, r)
216 				log_2 := or(log_2, shl(56, f))
217 				r := shr(f, r)
218 			}
219 			assembly {
220 				r := shr(127, mul(r, r))
221 				let f := shr(128, r)
222 				log_2 := or(log_2, shl(55, f))
223 				r := shr(f, r)
224 			}
225 			assembly {
226 				r := shr(127, mul(r, r))
227 				let f := shr(128, r)
228 				log_2 := or(log_2, shl(54, f))
229 				r := shr(f, r)
230 			}
231 			assembly {
232 				r := shr(127, mul(r, r))
233 				let f := shr(128, r)
234 				log_2 := or(log_2, shl(53, f))
235 				r := shr(f, r)
236 			}
237 			assembly {
238 				r := shr(127, mul(r, r))
239 				let f := shr(128, r)
240 				log_2 := or(log_2, shl(52, f))
241 				r := shr(f, r)
242 			}
243 			assembly {
244 				r := shr(127, mul(r, r))
245 				let f := shr(128, r)
246 				log_2 := or(log_2, shl(51, f))
247 				r := shr(f, r)
248 			}
249 			assembly {
250 				r := shr(127, mul(r, r))
251 				let f := shr(128, r)
252 				log_2 := or(log_2, shl(50, f))
253 			}
254 
255 			int256 log_sqrt10001 = log_2 * 255738958999603826347141;
256 
257 			int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
258 			int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
259 
260 			tick = tickLow == tickHi ? tickLow : _getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
261 		}
262 	}
263 
264 	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
265 		unchecked {
266 			uint256 _tmp = (_n + 1) / 2;
267 			result = _n;
268 			while (_tmp < result) {
269 				result = _tmp;
270 				_tmp = (_n / _tmp + _tmp) / 2;
271 			}
272 		}
273 	}
274 
275 	function _getPriceAndTickFromValues(bool _weth0, uint256 _tokens, uint256 _weth) internal pure returns (uint160 price, int24 tick) {
276 		uint160 _tmpPrice = uint160(_sqrt(2**192 / (!_weth0 ? _tokens : _weth) * (_weth0 ? _tokens : _weth)));
277 		tick = _getTickAtSqrtRatio(_tmpPrice);
278 		tick = tick - (tick % 200);
279 		price = _getSqrtRatioAtTick(tick);
280 	}
281 }
282 
283 
284 contract RUGME is TickMath, Params {
285 
286 	uint256 constant private FLOAT_SCALAR = 2**64;
287 	uint256 constant private UINT_MAX = type(uint256).max;
288 	uint128 constant private UINT128_MAX = type(uint128).max;
289 	uint256 constant private INITIAL_SUPPLY = 1e30; // 1 trillion
290 	Router constant private ROUTER = Router(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
291 	address constant private RUG_SIGNER = 0x00F01dA987bab23Cfe2DCe67FE527631f108fb7c;
292 	uint256 constant private INITIAL_ETH_MC = 1e3 ether; // 1,000 ETH initial market cap price
293 	uint256 constant private CONCENTRATED_PERCENT = 10; // 10% of tokens will be sold at the min price (100 ETH)
294 	uint256 constant private UPPER_ETH_MC = 1e5 ether; // 100,000 ETH max market cap price
295 	uint256 constant private RUGGER_PERCENT = 20; // 20% to the rugger, 80% refunded to all remaining tokens
296 	uint256 constant private TRANSFER_FEE = 10; // 10%
297 
298 	string constant public name = "Try To Rug Me";
299 	string constant public symbol = "RUGME";
300 	uint8 constant public decimals = 18;
301 
302 	struct User {
303 		uint256 balance;
304 		mapping(address => uint256) allowance;
305 		int256 scaledPayout;
306 	}
307 
308 	struct Info {
309 		bool rugged;
310 		address owner;
311 		address pool;
312 		uint256 totalSupply;
313 		uint256 scaledRewardsPerToken;
314 		mapping(address => User) users;
315 		uint256 lowerPositionId;
316 		uint256 upperPositionId;
317 	}
318 	Info private info;
319 
320 
321 	event Transfer(address indexed from, address indexed to, uint256 tokens);
322 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
323 	event ClaimRewards(address indexed user, uint256 amount);
324 	event Reward(uint256 amount);
325 
326 
327 	modifier _onlyOwner() {
328 		require(msg.sender == owner());
329 		_;
330 	}
331 
332 
333 	constructor() {
334 		info.rugged = false;
335 		info.owner = 0xFaDED72464D6e76e37300B467673b36ECc4d2ccF;
336 		address _this = address(this);
337 		address _weth = ROUTER.WETH9();
338 		(uint160 _initialSqrtPrice, ) = _getPriceAndTickFromValues(_weth < _this, INITIAL_SUPPLY, INITIAL_ETH_MC);
339 		info.pool = Factory(ROUTER.factory()).createPool(_this, _weth, 10000);
340 		Pool(pool()).initialize(_initialSqrtPrice);
341 	}
342 
343 	function setOwner(address _owner) external _onlyOwner {
344 		info.owner = _owner;
345 	}
346 
347 	function collectTradingFees() external _onlyOwner {
348 		bool _weth0 = ROUTER.WETH9() < address(this);
349 		PositionManager _pm = PositionManager(ROUTER.positionManager());
350 		_pm.collect(CollectParams({
351 			tokenId: info.lowerPositionId,
352 			recipient: owner(),
353 			amount0Max: _weth0 ? UINT128_MAX : 0,
354 			amount1Max: !_weth0 ? UINT128_MAX : 0
355 		}));
356 		_pm.collect(CollectParams({
357 			tokenId: info.upperPositionId,
358 			recipient: owner(),
359 			amount0Max: _weth0 ? UINT128_MAX : 0,
360 			amount1Max: !_weth0 ? UINT128_MAX : 0
361 		}));
362 	}
363 
364 	
365 	function initialize() external {
366 		require(!rugged());
367 		require(totalSupply() == 0);
368 		address _this = address(this);
369 		address _weth = ROUTER.WETH9();
370 		bool _weth0 = _weth < _this;
371 		PositionManager _pm = PositionManager(ROUTER.positionManager());
372 		info.totalSupply = INITIAL_SUPPLY;
373 		info.users[_this].balance = INITIAL_SUPPLY;
374 		emit Transfer(address(0x0), _this, INITIAL_SUPPLY);
375 		_approve(_this, address(_pm), INITIAL_SUPPLY);
376 		( , int24 _minTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, INITIAL_ETH_MC);
377 		( , int24 _maxTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, UPPER_ETH_MC);
378 		uint256 _concentratedTokens = CONCENTRATED_PERCENT * INITIAL_SUPPLY / 100;
379 		(info.lowerPositionId, , , ) = _pm.mint(MintParams({
380 			token0: _weth0 ? _weth : _this,
381 			token1: !_weth0 ? _weth : _this,
382 			fee: 10000,
383 			tickLower: _weth0 ? _minTick - 200 : _minTick,
384 			tickUpper: !_weth0 ? _minTick + 200 : _minTick,
385 			amount0Desired: _weth0 ? 0 : _concentratedTokens,
386 			amount1Desired: !_weth0 ? 0 : _concentratedTokens,
387 			amount0Min: 0,
388 			amount1Min: 0,
389 			recipient: _this,
390 			deadline: block.timestamp
391 		}));
392 		(info.upperPositionId, , , ) = _pm.mint(MintParams({
393 			token0: _weth0 ? _weth : _this,
394 			token1: !_weth0 ? _weth : _this,
395 			fee: 10000,
396 			tickLower: _weth0 ? _maxTick : _minTick + 200,
397 			tickUpper: !_weth0 ? _maxTick : _minTick - 200,
398 			amount0Desired: _weth0 ? 0 : INITIAL_SUPPLY - _concentratedTokens,
399 			amount1Desired: !_weth0 ? 0 : INITIAL_SUPPLY - _concentratedTokens,
400 			amount0Min: 0,
401 			amount1Min: 0,
402 			recipient: _this,
403 			deadline: block.timestamp
404 		}));
405 	}
406 
407 	function rug(bytes memory _signature) external {
408 		require(!rugged());
409 		require(_signature.length == 65);
410 		bytes32 r; bytes32 s; uint8 v;
411 		assembly {
412 			r := mload(add(_signature, 32))
413 			s := mload(add(_signature, 64))
414 			v := byte(0, mload(add(_signature, 96)))
415 		}
416 		require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(msg.sender)))), v, r, s) == RUG_SIGNER);
417 		address _this = address(this);
418 		uint256 _balanceBefore = balanceOf(_this);
419 		WETH _weth = WETH(ROUTER.WETH9());
420 		bool _weth0 = address(_weth) < _this;
421 		PositionManager _pm = PositionManager(ROUTER.positionManager());
422 		_pm.collect(CollectParams({
423 			tokenId: info.lowerPositionId,
424 			recipient: _this,
425 			amount0Max: _weth0 ? 0 : UINT128_MAX,
426 			amount1Max: !_weth0 ? 0 : UINT128_MAX
427 		}));
428 		( , , , , , , , uint128 _liquidity, , , uint128 _tokensOwedBefore0, uint128 _tokensOwedBefore1) = _pm.positions(info.lowerPositionId);
429 		_pm.decreaseLiquidity(DecreaseLiquidityParams({
430 			tokenId: info.lowerPositionId,
431 			liquidity: _liquidity,
432 			amount0Min: 0,
433 			amount1Min: 0,
434 			deadline: block.timestamp
435 		}));
436 		( , , , , , , , , , , uint128 _tokensOwed0, uint128 _tokensOwed1) = _pm.positions(info.lowerPositionId);
437 		_pm.collect(CollectParams({
438 			tokenId: info.lowerPositionId,
439 			recipient: _this,
440 			amount0Max: _weth0 ? _tokensOwed0 - _tokensOwedBefore0 : UINT128_MAX,
441 			amount1Max: !_weth0 ? _tokensOwed1 - _tokensOwedBefore1 : UINT128_MAX
442 		}));
443 		_pm.collect(CollectParams({
444 			tokenId: info.upperPositionId,
445 			recipient: _this,
446 			amount0Max: _weth0 ? 0 : UINT128_MAX,
447 			amount1Max: !_weth0 ? 0 : UINT128_MAX
448 		}));
449 		( , , , , , , , _liquidity, , , _tokensOwedBefore0, _tokensOwedBefore1) = _pm.positions(info.upperPositionId);
450 		_pm.decreaseLiquidity(DecreaseLiquidityParams({
451 			tokenId: info.upperPositionId,
452 			liquidity: _liquidity,
453 			amount0Min: 0,
454 			amount1Min: 0,
455 			deadline: block.timestamp
456 		}));
457 		( , , , , , , , , , , _tokensOwed0, _tokensOwed1) = _pm.positions(info.upperPositionId);
458 		_pm.collect(CollectParams({
459 			tokenId: info.upperPositionId,
460 			recipient: _this,
461 			amount0Max: _weth0 ? _tokensOwed0 - _tokensOwedBefore0 : UINT128_MAX,
462 			amount1Max: !_weth0 ? _tokensOwed1 - _tokensOwedBefore1 : UINT128_MAX
463 		}));
464 		_burn(_this, balanceOf(_this) - _balanceBefore);
465 		_weth.transfer(msg.sender, RUGGER_PERCENT * _weth.balanceOf(_this) / 100);
466 		info.rugged = true;
467 	}
468 
469 	function refund() external {
470 		unchecked {
471 			require(rugged());
472 			claimRewards();
473 			uint256 _balance = balanceOf(msg.sender);
474 			require(_balance > 0);
475 			WETH _weth = WETH(ROUTER.WETH9());
476 			uint256 _refund = _weth.balanceOf(address(this)) * _balance / totalSupply();
477 			_burn(msg.sender, _balance);
478 			_weth.transfer(msg.sender, _refund);
479 		}
480 	}
481 
482 	function claimRewards() public {
483 		unchecked {
484 			uint256 _rewards = rewardsOf(msg.sender);
485 			if (_rewards > 0) {
486 				info.users[msg.sender].scaledPayout += int256(_rewards * FLOAT_SCALAR);
487 				_transfer(address(this), msg.sender, _rewards);
488 				emit ClaimRewards(msg.sender, _rewards);
489 			}
490 		}
491 	}
492 	
493 	function burn(uint256 _tokens) public {
494 		require(!rugged());
495 		_burn(msg.sender, _tokens);
496 	}
497 
498 	function transfer(address _to, uint256 _tokens) external returns (bool) {
499 		return _transfer(msg.sender, _to, _tokens);
500 	}
501 
502 	function approve(address _spender, uint256 _tokens) external returns (bool) {
503 		return _approve(msg.sender, _spender, _tokens);
504 	}
505 
506 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
507 		uint256 _allowance = allowance(_from, msg.sender);
508 		require(_allowance >= _tokens);
509 		if (_allowance != UINT_MAX) {
510 			info.users[_from].allowance[msg.sender] -= _tokens;
511 		}
512 		return _transfer(_from, _to, _tokens);
513 	}
514 
515 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
516 		uint256 _balanceBefore = balanceOf(_to);
517 		_transfer(msg.sender, _to, _tokens);
518 		uint256 _tokensReceived = balanceOf(_to) - _balanceBefore;
519 		uint32 _size;
520 		assembly {
521 			_size := extcodesize(_to)
522 		}
523 		if (_size > 0) {
524 			require(Callable(_to).tokenCallback(msg.sender, _tokensReceived, _data));
525 		}
526 		return true;
527 	}
528 	
529 
530 	function rugged() public view returns (bool) {
531 		return info.rugged;
532 	}
533 
534 	function owner() public view returns (address) {
535 		return info.owner;
536 	}
537 
538 	function pool() public view returns (address) {
539 		return info.pool;
540 	}
541 
542 	function totalSupply() public view returns (uint256) {
543 		return info.totalSupply;
544 	}
545 
546 	function balanceOf(address _user) public view returns (uint256) {
547 		return info.users[_user].balance;
548 	}
549 
550 	function rewardsOf(address _user) public view returns (uint256) {
551 		return uint256(int256(info.scaledRewardsPerToken * balanceOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
552 	}
553 
554 	function allowance(address _user, address _spender) public view returns (uint256) {
555 		return info.users[_user].allowance[_spender];
556 	}
557 
558 	function positions() external view returns (uint256 lower, uint256 upper) {
559 		return (info.lowerPositionId, info.upperPositionId);
560 	}
561 
562 	function allInfoFor(address _user) external view returns (bool isRugged, uint256 totalTokens, uint256 wethBalance, uint256 userBalance, uint256 userRewards) {
563 		isRugged = rugged();
564 		totalTokens = totalSupply();
565 		wethBalance = WETH(ROUTER.WETH9()).balanceOf(address(this));
566 		userBalance = balanceOf(_user);
567 		userRewards = rewardsOf(_user);
568 	}
569 
570 
571 	function _burn(address _account, uint256 _tokens) internal {
572 		unchecked {
573 			require(balanceOf(_account) >= _tokens);
574 			info.totalSupply -= _tokens;
575 			info.users[_account].balance -= _tokens;
576 			info.users[_account].scaledPayout -= int256(_tokens * info.scaledRewardsPerToken);
577 			emit Transfer(_account, address(0x0), _tokens);
578 		}
579 	}
580 	
581 	function _approve(address _owner, address _spender, uint256 _tokens) internal returns (bool) {
582 		info.users[_owner].allowance[_spender] = _tokens;
583 		emit Approval(_owner, _spender, _tokens);
584 		return true;
585 	}
586 	
587 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
588 		unchecked {
589 			require(balanceOf(_from) >= _tokens);
590 			info.users[_from].balance -= _tokens;
591 			info.users[_from].scaledPayout -= int256(_tokens * info.scaledRewardsPerToken);
592 			address _this = address(this);
593 			uint256 _fee = 0;
594 			if (!(_from == _this || _to == _this || _to == pool())) {
595 				_fee = _tokens * TRANSFER_FEE / 100;
596 				info.users[_this].balance += _fee;
597 				info.users[_this].scaledPayout += int256(_fee * info.scaledRewardsPerToken);
598 				emit Transfer(_from, _this, _fee);
599 			}
600 			uint256 _transferred = _tokens - _fee;
601 			info.users[_to].balance += _transferred;
602 			info.users[_to].scaledPayout += int256(_transferred * info.scaledRewardsPerToken);
603 			emit Transfer(_from, _to, _transferred);
604 			_disburse(_fee);
605 			return true;
606 		}
607 	}
608 
609 	function _disburse(uint256 _amount) internal {
610 		unchecked {
611 			if (_amount > 0) {
612 				info.scaledRewardsPerToken += _amount * FLOAT_SCALAR / (totalSupply() - balanceOf(pool()) - balanceOf(address(this)));
613 				emit Reward(_amount);
614 			}
615 		}
616 	}
617 }
618 
619 
620 /*
621 
622 "The world is swirling with so many mysteries and secrets that
623 nobody will ever track down all of them. But with a book you can
624 stay up very late, reading until all the secrets are clear to
625 you. The questions of the world are hidden forever, but the
626 answers in a book are hiding in plain sight."
627 - Lemony Snicket
628 
629 -----BEGIN PGP MESSAGE-----
630 
631 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
793 Cg==
794 =gz7Q
795 -----END PGP MESSAGE-----
796 
797 */