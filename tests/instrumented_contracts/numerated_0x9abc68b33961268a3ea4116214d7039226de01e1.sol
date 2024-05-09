1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 
4 /*
5 
6 Once upon a time, in the wild and unpredictable world of
7 cryptocurrencies, there emerged a coin known as
8 "UltraSuperfuckingDementedgreendildoretardstrengthCoin"
9 ($USDC). Despite its dubious origins and questionable
10 fundamentals, USDC possessed an inexplicable power that defied
11 all logic. It was endowed with what some called "retard
12 strength" in the crypto market.
13 
14 Every time USDC was on the verge of being written off as just
15 another worthless token, it would suddenly experience an intense
16 and unexpected pump. The price would skyrocket, leaving seasoned
17 traders scratching their heads in disbelief. The market seemed
18 to embrace its volatility, and investors flocked to buy this
19 peculiar coin.
20 
21 Some theorized that USDC tapped into the collective
22 irrationality of the market, exploiting the pump and dump
23 instincts of traders hoping to strike it rich. Others believed
24 it was simply a result of a frenzy created by coordinated social
25 media campaigns and a relentless hype machine. Regardless of the
26 reason, USDC became a symbol of the unpredictable nature of the
27 crypto space.
28 
29 As the legend of USDC grew, it attracted a dedicated following
30 of believers who saw it as a metaphor for the unpredictable and
31 chaotic nature of life itself. They celebrated its "retard
32 strength" and reveled in the madness and excitement it
33 generated. USDC was the embodiment of the rollercoaster ride
34 that many crypto enthusiasts willingly embraced.
35 
36 https://greendildo.finance/
37 
38 */
39 
40 interface Callable {
41 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
42 }
43 
44 interface Router {
45 	function factory() external view returns (address);
46 	function positionManager() external view returns (address);
47 	function WETH9() external view returns (address);
48 }
49 
50 interface Factory {
51 	function createPool(address _tokenA, address _tokenB, uint24 _fee) external returns (address);
52 }
53 
54 interface Pool {
55 	function initialize(uint160 _sqrtPriceX96) external;
56 }
57 
58 interface PositionManager {
59 	struct MintParams {
60 		address token0;
61 		address token1;
62 		uint24 fee;
63 		int24 tickLower;
64 		int24 tickUpper;
65 		uint256 amount0Desired;
66 		uint256 amount1Desired;
67 		uint256 amount0Min;
68 		uint256 amount1Min;
69 		address recipient;
70 		uint256 deadline;
71 	}
72 	struct CollectParams {
73 		uint256 tokenId;
74 		address recipient;
75 		uint128 amount0Max;
76 		uint128 amount1Max;
77 	}
78 	function mint(MintParams calldata) external payable returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
79 	function collect(CollectParams calldata) external payable returns (uint256 amount0, uint256 amount1);
80 }
81 
82 
83 contract UltraSuperfuckingDementedgreendildoretardstrengthCoin {
84 
85 	uint256 constant private FLOAT_SCALAR = 2**64;
86 	uint256 constant private UINT_MAX = type(uint256).max;
87 	uint128 constant private UINT128_MAX = type(uint128).max;
88 	uint256 constant private INITIAL_SUPPLY = 1e30; // 1 trillion
89 	Router constant private ROUTER = Router(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
90 	uint256 constant private INITIAL_ETH_MC = 100 ether; // 100 ETH initial market cap price
91 	uint256 constant private CONCENTRATED_PERCENT = 20; // 20% of tokens will be sold at the min price (20 ETH)
92 	uint256 constant private UPPER_ETH_MC = 1e6 ether; // 1,000,000 ETH max market cap price
93 
94 	int24 constant private MIN_TICK = -887272;
95 	int24 constant private MAX_TICK = -MIN_TICK;
96 	uint160 constant private MIN_SQRT_RATIO = 4295128739;
97 	uint160 constant private MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
98 
99 	string constant public name = "UltraSuperfuckingDementedgreendildoretardstrengthCoin";
100 	string constant public symbol = "USDC";
101 	uint8 constant public decimals = 18;
102 
103 	struct User {
104 		uint256 balance;
105 		mapping(address => uint256) allowance;
106 	}
107 
108 	struct Info {
109 		address owner;
110 		address pool;
111 		uint256 totalSupply;
112 		mapping(address => User) users;
113 		uint256 lowerPositionId1;
114 		uint256 lowerPositionId2;
115 		uint256 upperPositionId1;
116 		uint256 upperPositionId2;
117 	}
118 	Info private info;
119 
120 
121 	event Transfer(address indexed from, address indexed to, uint256 tokens);
122 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
123 
124 
125 	constructor() {
126 		address _this = address(this);
127 		address _weth = ROUTER.WETH9();
128 		(uint160 _initialSqrtPrice, ) = _getPriceAndTickFromValues(_weth < _this, INITIAL_SUPPLY, INITIAL_ETH_MC);
129 		info.pool = Factory(ROUTER.factory()).createPool(_this, _weth, 10000);
130 		Pool(pool()).initialize(_initialSqrtPrice);
131 	}
132 	
133 	function initialize() external {
134 		require(totalSupply() == 0);
135 		address _this = address(this);
136 		address _weth = ROUTER.WETH9();
137 		bool _weth0 = _weth < _this;
138 		PositionManager _pm = PositionManager(ROUTER.positionManager());
139 		info.totalSupply = INITIAL_SUPPLY;
140 		info.users[_this].balance = INITIAL_SUPPLY;
141 		emit Transfer(address(0x0), _this, INITIAL_SUPPLY);
142 		_approve(_this, address(_pm), INITIAL_SUPPLY);
143 		( , int24 _minTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, INITIAL_ETH_MC);
144 		( , int24 _maxTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, UPPER_ETH_MC);
145 		uint256 _concentratedTokens = CONCENTRATED_PERCENT * INITIAL_SUPPLY / 100;
146 		(info.lowerPositionId1, , , ) = _pm.mint(PositionManager.MintParams({
147 			token0: _weth0 ? _weth : _this,
148 			token1: !_weth0 ? _weth : _this,
149 			fee: 10000,
150 			tickLower: _weth0 ? _minTick - 200 : _minTick,
151 			tickUpper: !_weth0 ? _minTick + 200 : _minTick,
152 			amount0Desired: _weth0 ? 0 : _concentratedTokens / 2,
153 			amount1Desired: !_weth0 ? 0 : _concentratedTokens / 2,
154 			amount0Min: 0,
155 			amount1Min: 0,
156 			recipient: _this,
157 			deadline: block.timestamp
158 		}));
159 		(info.lowerPositionId2, , , ) = _pm.mint(PositionManager.MintParams({
160 			token0: _weth0 ? _weth : _this,
161 			token1: !_weth0 ? _weth : _this,
162 			fee: 10000,
163 			tickLower: _weth0 ? _minTick - 200 : _minTick,
164 			tickUpper: !_weth0 ? _minTick + 200 : _minTick,
165 			amount0Desired: _weth0 ? 0 : _concentratedTokens / 2,
166 			amount1Desired: !_weth0 ? 0 : _concentratedTokens / 2,
167 			amount0Min: 0,
168 			amount1Min: 0,
169 			recipient: _this,
170 			deadline: block.timestamp
171 		}));
172 		(info.upperPositionId1, , , ) = _pm.mint(PositionManager.MintParams({
173 			token0: _weth0 ? _weth : _this,
174 			token1: !_weth0 ? _weth : _this,
175 			fee: 10000,
176 			tickLower: _weth0 ? _maxTick : _minTick + 200,
177 			tickUpper: !_weth0 ? _maxTick : _minTick - 200,
178 			amount0Desired: _weth0 ? 0 : (INITIAL_SUPPLY - _concentratedTokens) / 2,
179 			amount1Desired: !_weth0 ? 0 : (INITIAL_SUPPLY - _concentratedTokens) / 2,
180 			amount0Min: 0,
181 			amount1Min: 0,
182 			recipient: _this,
183 			deadline: block.timestamp
184 		}));
185 		(info.upperPositionId2, , , ) = _pm.mint(PositionManager.MintParams({
186 			token0: _weth0 ? _weth : _this,
187 			token1: !_weth0 ? _weth : _this,
188 			fee: 10000,
189 			tickLower: _weth0 ? _maxTick : _minTick + 200,
190 			tickUpper: !_weth0 ? _maxTick : _minTick - 200,
191 			amount0Desired: _weth0 ? 0 : (INITIAL_SUPPLY - _concentratedTokens) / 2,
192 			amount1Desired: !_weth0 ? 0 : (INITIAL_SUPPLY - _concentratedTokens) / 2,
193 			amount0Min: 0,
194 			amount1Min: 0,
195 			recipient: _this,
196 			deadline: block.timestamp
197 		}));
198 	}
199 
200 	function collectTradingFees() external {
201 		PositionManager _pm = PositionManager(ROUTER.positionManager());
202 		_pm.collect(PositionManager.CollectParams({
203 			tokenId: info.lowerPositionId1,
204 			recipient: 0x08bC60d3132b7090E71DB0AF691d612FFcB324d3,
205 			amount0Max: UINT128_MAX,
206 			amount1Max: UINT128_MAX
207 		}));
208 		_pm.collect(PositionManager.CollectParams({
209 			tokenId: info.lowerPositionId2,
210 			recipient: 0xFaDED72464D6e76e37300B467673b36ECc4d2ccF,
211 			amount0Max: UINT128_MAX,
212 			amount1Max: UINT128_MAX
213 		}));
214 		_pm.collect(PositionManager.CollectParams({
215 			tokenId: info.upperPositionId1,
216 			recipient: 0x08bC60d3132b7090E71DB0AF691d612FFcB324d3,
217 			amount0Max: UINT128_MAX,
218 			amount1Max: UINT128_MAX
219 		}));
220 		_pm.collect(PositionManager.CollectParams({
221 			tokenId: info.upperPositionId2,
222 			recipient: 0xFaDED72464D6e76e37300B467673b36ECc4d2ccF,
223 			amount0Max: UINT128_MAX,
224 			amount1Max: UINT128_MAX
225 		}));
226 	}
227 
228 	function transfer(address _to, uint256 _tokens) external returns (bool) {
229 		return _transfer(msg.sender, _to, _tokens);
230 	}
231 
232 	function approve(address _spender, uint256 _tokens) external returns (bool) {
233 		return _approve(msg.sender, _spender, _tokens);
234 	}
235 
236 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
237 		uint256 _allowance = allowance(_from, msg.sender);
238 		require(_allowance >= _tokens);
239 		if (_allowance != UINT_MAX) {
240 			info.users[_from].allowance[msg.sender] -= _tokens;
241 		}
242 		return _transfer(_from, _to, _tokens);
243 	}
244 
245 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
246 		_transfer(msg.sender, _to, _tokens);
247 		uint32 _size;
248 		assembly {
249 			_size := extcodesize(_to)
250 		}
251 		if (_size > 0) {
252 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
253 		}
254 		return true;
255 	}
256 	
257 
258 	function pool() public view returns (address) {
259 		return info.pool;
260 	}
261 
262 	function totalSupply() public view returns (uint256) {
263 		return info.totalSupply;
264 	}
265 
266 	function balanceOf(address _user) public view returns (uint256) {
267 		return info.users[_user].balance;
268 	}
269 
270 	function allowance(address _user, address _spender) public view returns (uint256) {
271 		return info.users[_user].allowance[_spender];
272 	}
273 
274 	function positions() external view returns (uint256 lower1, uint256 lower2, uint256 upper1, uint256 upper2) {
275 		return (info.lowerPositionId1, info.lowerPositionId2, info.upperPositionId1, info.upperPositionId2);
276 	}
277 
278 
279 	function _approve(address _owner, address _spender, uint256 _tokens) internal returns (bool) {
280 		info.users[_owner].allowance[_spender] = _tokens;
281 		emit Approval(_owner, _spender, _tokens);
282 		return true;
283 	}
284 	
285 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
286 		unchecked {
287 			require(balanceOf(_from) >= _tokens);
288 			info.users[_from].balance -= _tokens;
289 			info.users[_to].balance += _tokens;
290 			emit Transfer(_from, _to, _tokens);
291 			return true;
292 		}
293 	}
294 
295 
296 	function _getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
297 		unchecked {
298 			uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
299 			require(absTick <= uint256(int256(MAX_TICK)), 'T');
300 
301 			uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
302 			if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
303 			if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
304 			if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
305 			if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
306 			if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
307 			if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
308 			if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
309 			if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
310 			if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
311 			if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
312 			if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
313 			if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
314 			if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
315 			if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
316 			if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
317 			if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
318 			if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
319 			if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
320 			if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
321 
322 			if (tick > 0) ratio = type(uint256).max / ratio;
323 
324 			sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
325 		}
326 	}
327 
328 	function _getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
329 		unchecked {
330 			require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
331 			uint256 ratio = uint256(sqrtPriceX96) << 32;
332 
333 			uint256 r = ratio;
334 			uint256 msb = 0;
335 
336 			assembly {
337 				let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
338 				msb := or(msb, f)
339 				r := shr(f, r)
340 			}
341 			assembly {
342 				let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
343 				msb := or(msb, f)
344 				r := shr(f, r)
345 			}
346 			assembly {
347 				let f := shl(5, gt(r, 0xFFFFFFFF))
348 				msb := or(msb, f)
349 				r := shr(f, r)
350 			}
351 			assembly {
352 				let f := shl(4, gt(r, 0xFFFF))
353 				msb := or(msb, f)
354 				r := shr(f, r)
355 			}
356 			assembly {
357 				let f := shl(3, gt(r, 0xFF))
358 				msb := or(msb, f)
359 				r := shr(f, r)
360 			}
361 			assembly {
362 				let f := shl(2, gt(r, 0xF))
363 				msb := or(msb, f)
364 				r := shr(f, r)
365 			}
366 			assembly {
367 				let f := shl(1, gt(r, 0x3))
368 				msb := or(msb, f)
369 				r := shr(f, r)
370 			}
371 			assembly {
372 				let f := gt(r, 0x1)
373 				msb := or(msb, f)
374 			}
375 
376 			if (msb >= 128) r = ratio >> (msb - 127);
377 			else r = ratio << (127 - msb);
378 
379 			int256 log_2 = (int256(msb) - 128) << 64;
380 
381 			assembly {
382 				r := shr(127, mul(r, r))
383 				let f := shr(128, r)
384 				log_2 := or(log_2, shl(63, f))
385 				r := shr(f, r)
386 			}
387 			assembly {
388 				r := shr(127, mul(r, r))
389 				let f := shr(128, r)
390 				log_2 := or(log_2, shl(62, f))
391 				r := shr(f, r)
392 			}
393 			assembly {
394 				r := shr(127, mul(r, r))
395 				let f := shr(128, r)
396 				log_2 := or(log_2, shl(61, f))
397 				r := shr(f, r)
398 			}
399 			assembly {
400 				r := shr(127, mul(r, r))
401 				let f := shr(128, r)
402 				log_2 := or(log_2, shl(60, f))
403 				r := shr(f, r)
404 			}
405 			assembly {
406 				r := shr(127, mul(r, r))
407 				let f := shr(128, r)
408 				log_2 := or(log_2, shl(59, f))
409 				r := shr(f, r)
410 			}
411 			assembly {
412 				r := shr(127, mul(r, r))
413 				let f := shr(128, r)
414 				log_2 := or(log_2, shl(58, f))
415 				r := shr(f, r)
416 			}
417 			assembly {
418 				r := shr(127, mul(r, r))
419 				let f := shr(128, r)
420 				log_2 := or(log_2, shl(57, f))
421 				r := shr(f, r)
422 			}
423 			assembly {
424 				r := shr(127, mul(r, r))
425 				let f := shr(128, r)
426 				log_2 := or(log_2, shl(56, f))
427 				r := shr(f, r)
428 			}
429 			assembly {
430 				r := shr(127, mul(r, r))
431 				let f := shr(128, r)
432 				log_2 := or(log_2, shl(55, f))
433 				r := shr(f, r)
434 			}
435 			assembly {
436 				r := shr(127, mul(r, r))
437 				let f := shr(128, r)
438 				log_2 := or(log_2, shl(54, f))
439 				r := shr(f, r)
440 			}
441 			assembly {
442 				r := shr(127, mul(r, r))
443 				let f := shr(128, r)
444 				log_2 := or(log_2, shl(53, f))
445 				r := shr(f, r)
446 			}
447 			assembly {
448 				r := shr(127, mul(r, r))
449 				let f := shr(128, r)
450 				log_2 := or(log_2, shl(52, f))
451 				r := shr(f, r)
452 			}
453 			assembly {
454 				r := shr(127, mul(r, r))
455 				let f := shr(128, r)
456 				log_2 := or(log_2, shl(51, f))
457 				r := shr(f, r)
458 			}
459 			assembly {
460 				r := shr(127, mul(r, r))
461 				let f := shr(128, r)
462 				log_2 := or(log_2, shl(50, f))
463 			}
464 
465 			int256 log_sqrt10001 = log_2 * 255738958999603826347141;
466 
467 			int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
468 			int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
469 
470 			tick = tickLow == tickHi ? tickLow : _getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
471 		}
472 	}
473 
474 	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
475 		unchecked {
476 			uint256 _tmp = (_n + 1) / 2;
477 			result = _n;
478 			while (_tmp < result) {
479 				result = _tmp;
480 				_tmp = (_n / _tmp + _tmp) / 2;
481 			}
482 		}
483 	}
484 
485 	function _getPriceAndTickFromValues(bool _weth0, uint256 _tokens, uint256 _weth) internal pure returns (uint160 price, int24 tick) {
486 		uint160 _tmpPrice = uint160(_sqrt(2**192 / (!_weth0 ? _tokens : _weth) * (_weth0 ? _tokens : _weth)));
487 		tick = _getTickAtSqrtRatio(_tmpPrice);
488 		tick = tick - (tick % 200);
489 		price = _getSqrtRatioAtTick(tick);
490 	}
491 }
492 
493 
494 contract Deploy {
495 	UltraSuperfuckingDementedgreendildoretardstrengthCoin immutable public USDC;
496 	constructor() {
497 		USDC = new UltraSuperfuckingDementedgreendildoretardstrengthCoin();
498 		USDC.initialize();
499 	}
500 }