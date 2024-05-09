1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 
4 // SUPER GAPE COIN ($GAPE)
5 // https://supergapecoin.com/
6 
7 interface Callable {
8 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
9 }
10 
11 interface Router {
12 	function factory() external view returns (address);
13 	function positionManager() external view returns (address);
14 	function WETH9() external view returns (address);
15 }
16 
17 interface Factory {
18 	function createPool(address _tokenA, address _tokenB, uint24 _fee) external returns (address);
19 }
20 
21 interface Pool {
22 	function initialize(uint160 _sqrtPriceX96) external;
23 }
24 
25 interface PositionManager {
26 	struct MintParams {
27 		address token0;
28 		address token1;
29 		uint24 fee;
30 		int24 tickLower;
31 		int24 tickUpper;
32 		uint256 amount0Desired;
33 		uint256 amount1Desired;
34 		uint256 amount0Min;
35 		uint256 amount1Min;
36 		address recipient;
37 		uint256 deadline;
38 	}
39 	struct CollectParams {
40 		uint256 tokenId;
41 		address recipient;
42 		uint128 amount0Max;
43 		uint128 amount1Max;
44 	}
45 	function mint(MintParams calldata) external payable returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
46 	function collect(CollectParams calldata) external payable returns (uint256 amount0, uint256 amount1);
47 }
48 
49 interface ERC20 {
50 	function balanceOf(address) external view returns (uint256);
51 	function transfer(address, uint256) external returns (bool);
52 }
53 
54 interface WETH is ERC20 {
55 	function withdraw(uint256) external;
56 }
57 
58 
59 contract Team {
60 
61 	Router constant private ROUTER = Router(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
62 
63 	struct Share {
64 		address payable user;
65 		uint256 shares;
66 	}
67 	Share[] public shares;
68 	uint256 public totalShares;
69 	ERC20 public token;
70 
71 
72 	constructor() {
73 		token = ERC20(msg.sender);
74 		_addShare(0xda5dcA304139DFC92dD5491E82f84c5Df023677b, 2);
75 		_addShare(0x3CB30579e7C4A943509Dba604141c12A4609960A, 1);
76 		_addShare(0x63F52299d9B808eb2DE6115535E42Ef155dB1dfD, 1);
77 	}
78 
79 	receive() external payable {}
80 
81 	function withdrawETH() public {
82 		uint256 _balance = address(this).balance;
83 		if (_balance > 0) {
84 			for (uint256 i = 0; i < shares.length; i++) {
85 				Share memory _share = shares[i];
86 				!_share.user.send(_balance * _share.shares / totalShares);
87 			}
88 		}
89 	}
90 
91 	function withdrawToken(ERC20 _token) public {
92 		uint256 _balance = _token.balanceOf(address(this));
93 		if (_balance > 0) {
94 			for (uint256 i = 0; i < shares.length; i++) {
95 				Share memory _share = shares[i];
96 				_token.transfer(_share.user, _balance * _share.shares / totalShares);
97 			}
98 		}
99 	}
100 
101 	function withdrawFees() external {
102 		WETH _weth = WETH(ROUTER.WETH9());
103 		_weth.withdraw(_weth.balanceOf(address(this)));
104 		withdrawETH();
105 		withdrawToken(token);
106 	}
107 
108 
109 	function _addShare(address _user, uint256 _shares) internal {
110 		shares.push(Share(payable(_user), _shares));
111 		totalShares += _shares;
112 	}
113 }
114 
115 
116 contract GAPE {
117 
118 	uint256 constant private FLOAT_SCALAR = 2**64;
119 	uint256 constant private UINT_MAX = type(uint256).max;
120 	uint128 constant private UINT128_MAX = type(uint128).max;
121 	uint256 constant private INITIAL_SUPPLY = 69_696_969_696e18;
122 	Router constant private ROUTER = Router(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
123 	uint256 constant private INITIAL_ETH_MC = 100 ether; // 100 ETH initial market cap price
124 	uint256 constant private CONCENTRATED_PERCENT = 20; // 20% of tokens will be sold at the min price (20 ETH)
125 	uint256 constant private UPPER_ETH_MC = 1e6 ether; // 1,000,000 ETH max market cap price
126 
127 	int24 constant private MIN_TICK = -887272;
128 	int24 constant private MAX_TICK = -MIN_TICK;
129 	uint160 constant private MIN_SQRT_RATIO = 4295128739;
130 	uint160 constant private MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
131 
132 	string constant public name = "SUPER GAPE COIN";
133 	string constant public symbol = "GAPE";
134 	uint8 constant public decimals = 18;
135 
136 	struct User {
137 		uint256 balance;
138 		mapping(address => uint256) allowance;
139 	}
140 
141 	struct Info {
142 		Team team;
143 		address pool;
144 		uint256 totalSupply;
145 		mapping(address => User) users;
146 		uint256 lowerPositionId;
147 		uint256 upperPositionId;
148 	}
149 	Info private info;
150 
151 
152 	event Transfer(address indexed from, address indexed to, uint256 tokens);
153 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
154 
155 
156 	constructor() {
157 		info.team = new Team();
158 		address _this = address(this);
159 		address _weth = ROUTER.WETH9();
160 		(uint160 _initialSqrtPrice, ) = _getPriceAndTickFromValues(_weth < _this, INITIAL_SUPPLY, INITIAL_ETH_MC);
161 		info.pool = Factory(ROUTER.factory()).createPool(_this, _weth, 10000);
162 		Pool(pool()).initialize(_initialSqrtPrice);
163 	}
164 	
165 	function initialize() external {
166 		require(totalSupply() == 0);
167 		address _this = address(this);
168 		address _weth = ROUTER.WETH9();
169 		bool _weth0 = _weth < _this;
170 		PositionManager _pm = PositionManager(ROUTER.positionManager());
171 		info.totalSupply = INITIAL_SUPPLY;
172 		info.users[_this].balance = INITIAL_SUPPLY;
173 		emit Transfer(address(0x0), _this, INITIAL_SUPPLY);
174 		_approve(_this, address(_pm), INITIAL_SUPPLY);
175 		( , int24 _minTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, INITIAL_ETH_MC);
176 		( , int24 _maxTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, UPPER_ETH_MC);
177 		uint256 _concentratedTokens = CONCENTRATED_PERCENT * INITIAL_SUPPLY / 100;
178 		(info.lowerPositionId, , , ) = _pm.mint(PositionManager.MintParams({
179 			token0: _weth0 ? _weth : _this,
180 			token1: !_weth0 ? _weth : _this,
181 			fee: 10000,
182 			tickLower: _weth0 ? _minTick - 200 : _minTick,
183 			tickUpper: !_weth0 ? _minTick + 200 : _minTick,
184 			amount0Desired: _weth0 ? 0 : _concentratedTokens,
185 			amount1Desired: !_weth0 ? 0 : _concentratedTokens,
186 			amount0Min: 0,
187 			amount1Min: 0,
188 			recipient: _this,
189 			deadline: block.timestamp
190 		}));
191 		(info.upperPositionId, , , ) = _pm.mint(PositionManager.MintParams({
192 			token0: _weth0 ? _weth : _this,
193 			token1: !_weth0 ? _weth : _this,
194 			fee: 10000,
195 			tickLower: _weth0 ? _maxTick : _minTick + 200,
196 			tickUpper: !_weth0 ? _maxTick : _minTick - 200,
197 			amount0Desired: _weth0 ? 0 : INITIAL_SUPPLY - _concentratedTokens,
198 			amount1Desired: !_weth0 ? 0 : INITIAL_SUPPLY - _concentratedTokens,
199 			amount0Min: 0,
200 			amount1Min: 0,
201 			recipient: _this,
202 			deadline: block.timestamp
203 		}));
204 	}
205 
206 	function collectTradingFees() external {
207 		PositionManager _pm = PositionManager(ROUTER.positionManager());
208 		_pm.collect(PositionManager.CollectParams({
209 			tokenId: info.lowerPositionId,
210 			recipient: address(info.team),
211 			amount0Max: UINT128_MAX,
212 			amount1Max: UINT128_MAX
213 		}));
214 		_pm.collect(PositionManager.CollectParams({
215 			tokenId: info.upperPositionId,
216 			recipient: address(info.team),
217 			amount0Max: UINT128_MAX,
218 			amount1Max: UINT128_MAX
219 		}));
220 		info.team.withdrawFees();
221 	}
222 
223 	function transfer(address _to, uint256 _tokens) external returns (bool) {
224 		return _transfer(msg.sender, _to, _tokens);
225 	}
226 
227 	function approve(address _spender, uint256 _tokens) external returns (bool) {
228 		return _approve(msg.sender, _spender, _tokens);
229 	}
230 
231 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
232 		uint256 _allowance = allowance(_from, msg.sender);
233 		require(_allowance >= _tokens);
234 		if (_allowance != UINT_MAX) {
235 			info.users[_from].allowance[msg.sender] -= _tokens;
236 		}
237 		return _transfer(_from, _to, _tokens);
238 	}
239 
240 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
241 		_transfer(msg.sender, _to, _tokens);
242 		uint32 _size;
243 		assembly {
244 			_size := extcodesize(_to)
245 		}
246 		if (_size > 0) {
247 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
248 		}
249 		return true;
250 	}
251 	
252 
253 	function pool() public view returns (address) {
254 		return info.pool;
255 	}
256 
257 	function totalSupply() public view returns (uint256) {
258 		return info.totalSupply;
259 	}
260 
261 	function balanceOf(address _user) public view returns (uint256) {
262 		return info.users[_user].balance;
263 	}
264 
265 	function allowance(address _user, address _spender) public view returns (uint256) {
266 		return info.users[_user].allowance[_spender];
267 	}
268 
269 	function positions() external view returns (uint256 lower, uint256 upper) {
270 		return (info.lowerPositionId, info.upperPositionId);
271 	}
272 
273 
274 	function _approve(address _owner, address _spender, uint256 _tokens) internal returns (bool) {
275 		info.users[_owner].allowance[_spender] = _tokens;
276 		emit Approval(_owner, _spender, _tokens);
277 		return true;
278 	}
279 	
280 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
281 		unchecked {
282 			require(balanceOf(_from) >= _tokens);
283 			info.users[_from].balance -= _tokens;
284 			info.users[_to].balance += _tokens;
285 			emit Transfer(_from, _to, _tokens);
286 			return true;
287 		}
288 	}
289 
290 
291 	function _getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
292 		unchecked {
293 			uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
294 			require(absTick <= uint256(int256(MAX_TICK)), 'T');
295 
296 			uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
297 			if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
298 			if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
299 			if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
300 			if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
301 			if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
302 			if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
303 			if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
304 			if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
305 			if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
306 			if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
307 			if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
308 			if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
309 			if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
310 			if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
311 			if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
312 			if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
313 			if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
314 			if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
315 			if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
316 
317 			if (tick > 0) ratio = type(uint256).max / ratio;
318 
319 			sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
320 		}
321 	}
322 
323 	function _getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
324 		unchecked {
325 			require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
326 			uint256 ratio = uint256(sqrtPriceX96) << 32;
327 
328 			uint256 r = ratio;
329 			uint256 msb = 0;
330 
331 			assembly {
332 				let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
333 				msb := or(msb, f)
334 				r := shr(f, r)
335 			}
336 			assembly {
337 				let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
338 				msb := or(msb, f)
339 				r := shr(f, r)
340 			}
341 			assembly {
342 				let f := shl(5, gt(r, 0xFFFFFFFF))
343 				msb := or(msb, f)
344 				r := shr(f, r)
345 			}
346 			assembly {
347 				let f := shl(4, gt(r, 0xFFFF))
348 				msb := or(msb, f)
349 				r := shr(f, r)
350 			}
351 			assembly {
352 				let f := shl(3, gt(r, 0xFF))
353 				msb := or(msb, f)
354 				r := shr(f, r)
355 			}
356 			assembly {
357 				let f := shl(2, gt(r, 0xF))
358 				msb := or(msb, f)
359 				r := shr(f, r)
360 			}
361 			assembly {
362 				let f := shl(1, gt(r, 0x3))
363 				msb := or(msb, f)
364 				r := shr(f, r)
365 			}
366 			assembly {
367 				let f := gt(r, 0x1)
368 				msb := or(msb, f)
369 			}
370 
371 			if (msb >= 128) r = ratio >> (msb - 127);
372 			else r = ratio << (127 - msb);
373 
374 			int256 log_2 = (int256(msb) - 128) << 64;
375 
376 			assembly {
377 				r := shr(127, mul(r, r))
378 				let f := shr(128, r)
379 				log_2 := or(log_2, shl(63, f))
380 				r := shr(f, r)
381 			}
382 			assembly {
383 				r := shr(127, mul(r, r))
384 				let f := shr(128, r)
385 				log_2 := or(log_2, shl(62, f))
386 				r := shr(f, r)
387 			}
388 			assembly {
389 				r := shr(127, mul(r, r))
390 				let f := shr(128, r)
391 				log_2 := or(log_2, shl(61, f))
392 				r := shr(f, r)
393 			}
394 			assembly {
395 				r := shr(127, mul(r, r))
396 				let f := shr(128, r)
397 				log_2 := or(log_2, shl(60, f))
398 				r := shr(f, r)
399 			}
400 			assembly {
401 				r := shr(127, mul(r, r))
402 				let f := shr(128, r)
403 				log_2 := or(log_2, shl(59, f))
404 				r := shr(f, r)
405 			}
406 			assembly {
407 				r := shr(127, mul(r, r))
408 				let f := shr(128, r)
409 				log_2 := or(log_2, shl(58, f))
410 				r := shr(f, r)
411 			}
412 			assembly {
413 				r := shr(127, mul(r, r))
414 				let f := shr(128, r)
415 				log_2 := or(log_2, shl(57, f))
416 				r := shr(f, r)
417 			}
418 			assembly {
419 				r := shr(127, mul(r, r))
420 				let f := shr(128, r)
421 				log_2 := or(log_2, shl(56, f))
422 				r := shr(f, r)
423 			}
424 			assembly {
425 				r := shr(127, mul(r, r))
426 				let f := shr(128, r)
427 				log_2 := or(log_2, shl(55, f))
428 				r := shr(f, r)
429 			}
430 			assembly {
431 				r := shr(127, mul(r, r))
432 				let f := shr(128, r)
433 				log_2 := or(log_2, shl(54, f))
434 				r := shr(f, r)
435 			}
436 			assembly {
437 				r := shr(127, mul(r, r))
438 				let f := shr(128, r)
439 				log_2 := or(log_2, shl(53, f))
440 				r := shr(f, r)
441 			}
442 			assembly {
443 				r := shr(127, mul(r, r))
444 				let f := shr(128, r)
445 				log_2 := or(log_2, shl(52, f))
446 				r := shr(f, r)
447 			}
448 			assembly {
449 				r := shr(127, mul(r, r))
450 				let f := shr(128, r)
451 				log_2 := or(log_2, shl(51, f))
452 				r := shr(f, r)
453 			}
454 			assembly {
455 				r := shr(127, mul(r, r))
456 				let f := shr(128, r)
457 				log_2 := or(log_2, shl(50, f))
458 			}
459 
460 			int256 log_sqrt10001 = log_2 * 255738958999603826347141;
461 
462 			int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
463 			int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
464 
465 			tick = tickLow == tickHi ? tickLow : _getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
466 		}
467 	}
468 
469 	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
470 		unchecked {
471 			uint256 _tmp = (_n + 1) / 2;
472 			result = _n;
473 			while (_tmp < result) {
474 				result = _tmp;
475 				_tmp = (_n / _tmp + _tmp) / 2;
476 			}
477 		}
478 	}
479 
480 	function _getPriceAndTickFromValues(bool _weth0, uint256 _tokens, uint256 _weth) internal pure returns (uint160 price, int24 tick) {
481 		uint160 _tmpPrice = uint160(_sqrt(2**192 / (!_weth0 ? _tokens : _weth) * (_weth0 ? _tokens : _weth)));
482 		tick = _getTickAtSqrtRatio(_tmpPrice);
483 		tick = tick - (tick % 200);
484 		price = _getSqrtRatioAtTick(tick);
485 	}
486 }
487 
488 
489 contract Deploy {
490 	GAPE immutable public gape;
491 	constructor() {
492 		gape = new GAPE();
493 		gape.initialize();
494 	}
495 }