1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 
4 // $MULLET
5 // - 1 billion supply
6 // - no contract owner
7 // - 100% of tokens in initial LP
8 // - LP locked in contract permanently
9 // - V3 LP with a 5 ETH initial market cap
10 // - 1,000,000 token max transfer for 5 minutes
11 // https://mullet.capital
12 
13 // $HAIR
14 // - fully liquid without the need for a DEX
15 // - 10% buy/sell tax
16 // - tax distributed to token holders in the form of ETH
17 // - referral link, own 100 $HAIR or more to get 3% of referred buys/reinvests
18 // https://hedge.mullet.capital
19 
20 
21 interface Callable {
22 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
23 }
24 
25 interface Router {
26 	struct ExactInputSingleParams {
27 		address tokenIn;
28 		address tokenOut;
29 		uint24 fee;
30 		address recipient;
31 		uint256 amountIn;
32 		uint256 amountOutMinimum;
33 		uint160 sqrtPriceLimitX96;
34 	}
35 	function factory() external view returns (address);
36 	function positionManager() external view returns (address);
37 	function WETH9() external view returns (address);
38 	function exactInputSingle(ExactInputSingleParams calldata) external payable returns (uint256);
39 }
40 
41 interface Factory {
42 	function createPool(address _tokenA, address _tokenB, uint24 _fee) external returns (address);
43 }
44 
45 interface Pool {
46 	function initialize(uint160 _sqrtPriceX96) external;
47 }
48 
49 interface PositionManager {
50 	struct MintParams {
51 		address token0;
52 		address token1;
53 		uint24 fee;
54 		int24 tickLower;
55 		int24 tickUpper;
56 		uint256 amount0Desired;
57 		uint256 amount1Desired;
58 		uint256 amount0Min;
59 		uint256 amount1Min;
60 		address recipient;
61 		uint256 deadline;
62 	}
63 	struct CollectParams {
64 		uint256 tokenId;
65 		address recipient;
66 		uint128 amount0Max;
67 		uint128 amount1Max;
68 	}
69 	function mint(MintParams calldata) external payable returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
70 	function collect(CollectParams calldata) external payable returns (uint256 amount0, uint256 amount1);
71 }
72 
73 interface ERC20 {
74 	function balanceOf(address) external view returns (uint256);
75 	function transfer(address, uint256) external returns (bool);
76 }
77 
78 interface WETH is ERC20 {
79 	function withdraw(uint256) external;
80 }
81 
82 
83 contract HEDGE {
84 
85 	uint256 constant private FLOAT_SCALAR = 2**64;
86 	uint256 constant private BUY_TAX = 10;
87 	uint256 constant private SELL_TAX = 10;
88 	uint256 constant private TEAM_TAX = 1;
89 	uint256 constant private REF_TAX = 3;
90 	uint256 constant private REF_REQUIREMENT = 1e20; // 100 HAIR
91 	uint256 constant private STARTING_PRICE = 0.001 ether;
92 	uint256 constant private INCREMENT = 1e10; // 10 Gwei
93 	address constant private BUYBACK_ADDRESS = 0xA093Ea0904250084411F98d9195567e8b4406696;
94 
95 	string constant public name = "HEDGE";
96 	string constant public symbol = "HAIR";
97 	uint8 constant public decimals = 18;
98 
99 	struct User {
100 		uint256 balance;
101 		mapping(address => uint256) allowance;
102 		int256 scaledPayout;
103 		address ref;
104 	}
105 
106 	struct Info {
107 		uint256 totalSupply;
108 		mapping(address => User) users;
109 		uint256 scaledEthPerToken;
110 		address team;
111 	}
112 	Info private info;
113 
114 
115 	event Transfer(address indexed from, address indexed to, uint256 tokens);
116 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
117 	event Buy(address indexed buyer, uint256 amountSpent, uint256 tokensReceived);
118 	event Sell(address indexed seller, uint256 tokensSpent, uint256 amountReceived);
119 	event Withdraw(address indexed user, uint256 amount);
120 	event Reinvest(address indexed user, uint256 amount);
121 
122 
123 	constructor() {
124 		info.team = msg.sender;
125 	}
126 	
127 	receive() external payable {
128 		buy();
129 	}
130 	
131 	function buy() public payable returns (uint256) {
132 		return buy(address(0x0));
133 	}
134 	
135 	function buy(address _ref) public payable returns (uint256) {
136 		require(msg.value > 0);
137 		if (_ref != address(0x0) && _ref != msg.sender && _ref != refOf(msg.sender)) {
138 			info.users[msg.sender].ref = _ref;
139 		}
140 		return _buy(msg.value);
141 	}
142 
143 	function sell(uint256 _tokens) external returns (uint256) {
144 		return _sell(_tokens);
145 	}
146 
147 	function withdraw() external returns (uint256) {
148 		uint256 _rewards = rewardsOf(msg.sender);
149 		require(_rewards >= 0);
150 		info.users[msg.sender].scaledPayout += int256(_rewards * FLOAT_SCALAR);
151 		payable(msg.sender).transfer(_rewards);
152 		emit Withdraw(msg.sender, _rewards);
153 		return _rewards;
154 	}
155 
156 	function reinvest() external returns (uint256) {
157 		uint256 _rewards = rewardsOf(msg.sender);
158 		require(_rewards >= 0);
159 		info.users[msg.sender].scaledPayout += int256(_rewards * FLOAT_SCALAR);
160 		emit Reinvest(msg.sender, _rewards);
161 		return _buy(_rewards);
162 	}
163 
164 	function transfer(address _to, uint256 _tokens) external returns (bool) {
165 		return _transfer(msg.sender, _to, _tokens);
166 	}
167 
168 	function approve(address _spender, uint256 _tokens) external returns (bool) {
169 		info.users[msg.sender].allowance[_spender] = _tokens;
170 		emit Approval(msg.sender, _spender, _tokens);
171 		return true;
172 	}
173 
174 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
175 		require(allowance(_from, msg.sender) >= _tokens);
176 		info.users[_from].allowance[msg.sender] -= _tokens;
177 		return _transfer(_from, _to, _tokens);
178 	}
179 
180 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
181 		_transfer(msg.sender, _to, _tokens);
182 		uint32 _size;
183 		assembly {
184 			_size := extcodesize(_to)
185 		}
186 		if (_size > 0) {
187 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
188 		}
189 		return true;
190 	}
191 
192 
193 	function team() public view returns (address) {
194 		return info.team;
195 	}
196 
197 	function buybackAddress() public pure returns (address) {
198 		return BUYBACK_ADDRESS;
199 	}
200 
201 	function totalSupply() public view returns (uint256) {
202 		return info.totalSupply;
203 	}
204 
205 	function currentPrices() public view returns (uint256 truePrice, uint256 buyPrice, uint256 sellPrice) {
206 		truePrice = STARTING_PRICE + INCREMENT * totalSupply() / 1e18;
207 		buyPrice = truePrice * 100 / (100 - BUY_TAX);
208 		sellPrice = truePrice * (100 - SELL_TAX) / 100;
209 	}
210 
211 	function refOf(address _user) public view returns (address) {
212 		return info.users[_user].ref;
213 	}
214 
215 	function balanceOf(address _user) public view returns (uint256) {
216 		return info.users[_user].balance;
217 	}
218 
219 	function rewardsOf(address _user) public view returns (uint256) {
220 		return uint256(int256(info.scaledEthPerToken * balanceOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
221 	}
222 
223 	function allInfoFor(address _user) public view returns (uint256 contractBalance, uint256 totalTokenSupply, uint256 truePrice, uint256 buyPrice, uint256 sellPrice, uint256 userETH, uint256 userBalance, uint256 userRewards, uint256 userLiquidValue, address userRef) {
224 		contractBalance = address(this).balance;
225 		totalTokenSupply = totalSupply();
226 		(truePrice, buyPrice, sellPrice) = currentPrices();
227 		userETH = _user.balance;
228 		userBalance = balanceOf(_user);
229 		userRewards = rewardsOf(_user);
230 		userLiquidValue = calculateResult(userBalance, false, false) + userRewards;
231 		userRef = refOf(_user);
232 	}
233 
234 	function allowance(address _user, address _spender) public view returns (uint256) {
235 		return info.users[_user].allowance[_spender];
236 	}
237 
238 	function calculateResult(uint256 _amount, bool _isBuy, bool _inverse) public view returns (uint256) {
239 		unchecked {
240 			uint256 _buyPrice;
241 			uint256 _sellPrice;
242 			( , _buyPrice, _sellPrice) = currentPrices();
243 			uint256 _rate = (_isBuy ? _buyPrice : _sellPrice);
244 			uint256 _increment = INCREMENT * (_isBuy ? 100 : (100 - SELL_TAX)) / (_isBuy ? (100 - BUY_TAX) : 100);
245 			if ((_isBuy && !_inverse) || (!_isBuy && _inverse)) {
246 				if (_inverse) {
247 					return (2 * _rate - _sqrt(4 * _rate * _rate + _increment * _increment - 4 * _rate * _increment - 8 * _amount * _increment) - _increment) * 1e18 / (2 * _increment);
248 				} else {
249 					return (_sqrt((_increment + 2 * _rate) * (_increment + 2 * _rate) + 8 * _amount * _increment) - _increment - 2 * _rate) * 1e18 / (2 * _increment);
250 				}
251 			} else {
252 				if (_inverse) {
253 					return (_rate * _amount + (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
254 				} else {
255 					return (_rate * _amount - (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
256 				}
257 			}
258 		}
259 	}
260 
261 
262 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
263 		require(balanceOf(_from) >= _tokens);
264 		info.users[_from].balance -= _tokens;
265 		info.users[_from].scaledPayout -= int256(_tokens * info.scaledEthPerToken);
266 		info.users[_to].balance += _tokens;
267 		info.users[_to].scaledPayout += int256(_tokens * info.scaledEthPerToken);
268 		emit Transfer(_from, _to, _tokens);
269 		return true;
270 	}
271 
272 	function _buy(uint256 _amount) internal returns (uint256 tokens) {
273 		uint256 _tax = _amount * BUY_TAX / 100;
274 		tokens = calculateResult(_amount, true, false);
275 		info.totalSupply += tokens;
276 		info.users[msg.sender].balance += tokens;
277 		info.users[msg.sender].scaledPayout += int256(tokens * info.scaledEthPerToken);
278 		uint256 _teamTax = _amount * TEAM_TAX / 100;
279 		info.users[team()].scaledPayout -= int256(_teamTax * FLOAT_SCALAR);
280 		uint256 _refTax = _amount * REF_TAX / 100;
281 		address _ref = refOf(msg.sender);
282 		if (_ref != address(0x0) && balanceOf(_ref) >= REF_REQUIREMENT) {
283 			info.users[_ref].scaledPayout -= int256(_refTax * FLOAT_SCALAR);
284 		} else {
285 			info.users[buybackAddress()].scaledPayout -= int256(_refTax * FLOAT_SCALAR);
286 		}
287 		info.scaledEthPerToken += (_tax - _teamTax - _refTax) * FLOAT_SCALAR / info.totalSupply;
288 		emit Transfer(address(0x0), msg.sender, tokens);
289 		emit Buy(msg.sender, _amount, tokens);
290 	}
291 
292 	function _sell(uint256 _tokens) internal returns (uint256 amount) {
293 		require(balanceOf(msg.sender) >= _tokens);
294 		amount = calculateResult(_tokens, false, false);
295 		uint256 _tax = amount * SELL_TAX / (100 - SELL_TAX);
296 		info.totalSupply -= _tokens;
297 		info.users[msg.sender].balance -= _tokens;
298 		info.users[msg.sender].scaledPayout -= int256(_tokens * info.scaledEthPerToken);
299 		uint256 _teamTax = amount * TEAM_TAX / (100 - SELL_TAX);
300 		info.users[team()].scaledPayout -= int256(_teamTax * FLOAT_SCALAR);
301 		info.scaledEthPerToken += (_tax - _teamTax) * FLOAT_SCALAR / info.totalSupply;
302 		payable(msg.sender).transfer(amount);
303 		emit Transfer(msg.sender, address(0x0), _tokens);
304 		emit Sell(msg.sender, _tokens, amount);
305 	}
306 
307 
308 	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
309 		unchecked {
310 			uint256 _tmp = (_n + 1) / 2;
311 			result = _n;
312 			while (_tmp < result) {
313 				result = _tmp;
314 				_tmp = (_n / _tmp + _tmp) / 2;
315 			}
316 		}
317 	}
318 }
319 
320 
321 contract Team {
322 
323 	Router constant private ROUTER = Router(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
324 
325 	struct Share {
326 		address payable user;
327 		uint256 shares;
328 	}
329 	Share[] public shares;
330 	uint256 public totalShares;
331 	ERC20 immutable public token;
332 	HEDGE immutable public hedge;
333 
334 
335 	constructor() {
336 		token = ERC20(msg.sender);
337 		hedge = new HEDGE();
338 		_addShare(0x7178523CD70c5E96C079701fE46Cda3E1799b4Ce, 9);
339 		_addShare(0xc61D594dff6D253142C7Fa83F41D318F157B018a, 9);
340 		_addShare(0x2000Af01b455C4cd3E65AED180eC3EE52BD6C264, 2);
341 	}
342 
343 	receive() external payable {}
344 
345 	function withdrawETH() public {
346 		uint256 _balance = address(this).balance;
347 		if (_balance > 0) {
348 			for (uint256 i = 0; i < shares.length; i++) {
349 				Share memory _share = shares[i];
350 				!_share.user.send(_balance * _share.shares / totalShares);
351 			}
352 		}
353 	}
354 
355 	function withdrawHAIR() external {
356 		hedge.withdraw();
357 		withdrawETH();
358 	}
359 
360 	function withdrawToken(ERC20 _token) public {
361 		WETH _weth = WETH(ROUTER.WETH9());
362 		if (address(_token) == address(_weth)) {
363 			_weth.withdraw(_weth.balanceOf(address(this)));
364 			withdrawETH();
365 		} else {
366 			uint256 _balance = _token.balanceOf(address(this));
367 			if (_balance > 0) {
368 				for (uint256 i = 0; i < shares.length; i++) {
369 					Share memory _share = shares[i];
370 					_token.transfer(_share.user, _balance * _share.shares / totalShares);
371 				}
372 			}
373 		}
374 	}
375 
376 	function withdrawWETH() public {
377 		withdrawToken(ERC20(ROUTER.WETH9()));
378 	}
379 
380 	function withdrawFees() external {
381 		withdrawWETH();
382 		withdrawToken(token);
383 	}
384 
385 
386 	function _addShare(address _user, uint256 _shares) internal {
387 		shares.push(Share(payable(_user), _shares));
388 		totalShares += _shares;
389 	}
390 }
391 
392 
393 contract Ambassadors {
394 
395 	struct Share {
396 		address payable user;
397 		uint256 shares;
398 	}
399 	Share[] public shares;
400 	uint256 public totalShares;
401 	ERC20 immutable public token;
402 
403 
404 	constructor() {
405 		token = ERC20(msg.sender);
406 		_addShare(0x1427798f129b92F19927931a964D17bd6C2F5253, 10);
407 		_addShare(0x9D756A1848Ee62db36C17f000699f65BfEF9bf11, 7);
408 		_addShare(0x1248E5Ce0dB0F869A9A934b1677bd5A17e5B8DFe, 7);
409 		_addShare(0x6A5da854d5a3A0Fc4A760Bc6A9062D2A8e36431a, 7);
410 		_addShare(0x5a02FbCE3B19E9508F5Cc7F351f671795c1a81a4, 7);
411 		_addShare(0x1B1B694c797904D9B84ed636661C32C4DcaA17d9, 7);
412 		_addShare(0x492bb59126d7F06C2c5B13cD50caD209a43eA326, 7);
413 		_addShare(0x60d5567d7f8d05C899C89e63E00E4f6ca396ec13, 7);
414 		_addShare(0xBaE44b530f65Aa9A97bb0d17b4eafb07Ac67259C, 7);
415 		_addShare(0xe6eD771d0deC3a1F5B1A9bBc90fF9353E7Ec9c56, 7);
416 		_addShare(0xc44241b85051E5837B522289B2559d70496B16dC, 7);
417 		_addShare(0x0539480eE00A547974e7E38c1A9c8b046d767F22, 7);
418 		_addShare(0x7a3DD779b524C80e464B23AfCA6906539Df958D0, 7);
419 		_addShare(0xDfCE959d59F3E34c4f018cd91E4A5B9453Ff2D7d, 7);
420 		_addShare(0xAc537fcf993fAbCA3e795658B5b1a06c5DEC1e85, 7);
421 		_addShare(0x0d9997acB3f204fe3A09aCB1Fd594F906bCc88BB, 7);
422 		_addShare(0x6a49351D350245cFA979c1EBce7D18ADa46406d5, 7);
423 		_addShare(0x8E44aF6308e52b94157Ec9A898eC9f31cc1B0E16, 7);
424 		_addShare(0xf939FDa6330984F3E84EB32701bd404dACc27D50, 7);
425 		_addShare(0x29f3536D4E2a790f11d5827490390Dd1dca3e9b1, 7);
426 		_addShare(0xA4C501D7Cd0914fCfDb9E2bf367cC224a4531fAc, 7);
427 		_addShare(0x5dBFEAcf8f26e83314790f3Ee91eEAB97617F734, 7);
428 		_addShare(0xEBf184353dD81C21AAaB257143346584d75d1537, 7);
429 		_addShare(0xdAf028effC6e75307c54899a433b40514fEBB936, 7);
430 		_addShare(0xC4be049c2835D5F42c3B11a44c775F8A4909bd5F, 7);
431 		_addShare(0xD89eF44a1fBeA729912Fc40CAcF7d0CAe2A49841, 7);
432 		_addShare(0x5E056D473F95eA7Ef9660a46310297b2D457cAaD, 7);
433 		_addShare(0xb592016Dc145aFBA2aeE5B35e2Dfe0629BF83A36, 4);
434 		_addShare(0x95f572bD843b74C0d582b1BE5AF2583293ad2255, 2);
435 	}
436 
437 	function distribute() external {
438 		uint256 _balance = token.balanceOf(address(this));
439 		if (_balance > 0) {
440 			for (uint256 i = 0; i < shares.length; i++) {
441 				Share memory _share = shares[i];
442 				token.transfer(_share.user, _balance * _share.shares / totalShares);
443 			}
444 		}
445 	}
446 
447 
448 	function _addShare(address _user, uint256 _shares) internal {
449 		shares.push(Share(payable(_user), _shares));
450 		totalShares += _shares;
451 	}
452 }
453 
454 
455 contract MULLET {
456 
457 	uint256 constant private UINT_MAX = type(uint256).max;
458 	uint128 constant private UINT128_MAX = type(uint128).max;
459 	uint256 constant private INITIAL_SUPPLY = 1e27; // 1 billion
460 	Router constant private ROUTER = Router(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
461 	uint256 constant private INITIAL_ETH_MC = 5 ether; // 5 ETH initial market cap price
462 	uint256 constant private UPPER_ETH_MC = 1e6 ether; // 1,000,000 ETH max market cap price
463 	uint256 constant private LIMIT_TIME = 5 minutes;
464 	uint256 constant private TOKEN_LIMIT = (INITIAL_SUPPLY / 1000); // max buy of 1m tokens, approx. 0.005 ETH, for 5 minutes
465 
466 	int24 constant private MIN_TICK = -887272;
467 	int24 constant private MAX_TICK = -MIN_TICK;
468 	uint160 constant private MIN_SQRT_RATIO = 4295128739;
469 	uint160 constant private MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
470 
471 	string constant public name = "Mullet Money Mission";
472 	string constant public symbol = "MULLET";
473 	uint8 constant public decimals = 18;
474 
475 	struct User {
476 		uint256 balance;
477 		mapping(address => uint256) allowance;
478 	}
479 
480 	struct Info {
481 		Team team;
482 		address pool;
483 		uint256 totalSupply;
484 		mapping(address => User) users;
485 		uint128 positionId;
486 		uint128 startTime;
487 	}
488 	Info private info;
489 
490 
491 	event Transfer(address indexed from, address indexed to, uint256 tokens);
492 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
493 
494 
495 	constructor() payable {
496 		require(msg.value > 0);
497 		info.team = new Team();
498 		address _this = address(this);
499 		address _weth = ROUTER.WETH9();
500 		(uint160 _initialSqrtPrice, ) = _getPriceAndTickFromValues(_weth < _this, INITIAL_SUPPLY, INITIAL_ETH_MC);
501 		info.pool = Factory(ROUTER.factory()).createPool(_this, _weth, 10000);
502 		Pool(pool()).initialize(_initialSqrtPrice);
503 	}
504 	
505 	function initialize() external {
506 		require(totalSupply() == 0);
507 		address _this = address(this);
508 		address _weth = ROUTER.WETH9();
509 		bool _weth0 = _weth < _this;
510 		PositionManager _pm = PositionManager(ROUTER.positionManager());
511 		info.totalSupply = INITIAL_SUPPLY;
512 		info.users[_this].balance = INITIAL_SUPPLY;
513 		emit Transfer(address(0x0), _this, INITIAL_SUPPLY);
514 		_approve(_this, address(_pm), INITIAL_SUPPLY);
515 		( , int24 _minTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, INITIAL_ETH_MC);
516 		( , int24 _maxTick) = _getPriceAndTickFromValues(_weth0, INITIAL_SUPPLY, UPPER_ETH_MC);
517 		(uint256 _positionId, , , ) = _pm.mint(PositionManager.MintParams({
518 			token0: _weth0 ? _weth : _this,
519 			token1: !_weth0 ? _weth : _this,
520 			fee: 10000,
521 			tickLower: _weth0 ? _maxTick : _minTick,
522 			tickUpper: !_weth0 ? _maxTick : _minTick,
523 			amount0Desired: _weth0 ? 0 : INITIAL_SUPPLY,
524 			amount1Desired: !_weth0 ? 0 : INITIAL_SUPPLY,
525 			amount0Min: 0,
526 			amount1Min: 0,
527 			recipient: _this,
528 			deadline: block.timestamp
529 		}));
530 		info.positionId = uint128(_positionId);
531 		Ambassadors _ambassadors = new Ambassadors();
532 		ROUTER.exactInputSingle{value:_this.balance}(Router.ExactInputSingleParams({
533 			tokenIn: _weth,
534 			tokenOut: _this,
535 			fee: 10000,
536 			recipient: address(_ambassadors),
537 			amountIn: _this.balance,
538 			amountOutMinimum: 0,
539 			sqrtPriceLimitX96: 0
540 		}));
541 		_ambassadors.distribute();
542 		info.startTime = uint128(block.timestamp);
543 	}
544 
545 	function collectTradingFees() external {
546 		PositionManager(ROUTER.positionManager()).collect(PositionManager.CollectParams({
547 			tokenId: position(),
548 			recipient: team(),
549 			amount0Max: UINT128_MAX,
550 			amount1Max: UINT128_MAX
551 		}));
552 		info.team.withdrawFees();
553 	}
554 
555 	function transfer(address _to, uint256 _tokens) external returns (bool) {
556 		return _transfer(msg.sender, _to, _tokens);
557 	}
558 
559 	function approve(address _spender, uint256 _tokens) external returns (bool) {
560 		return _approve(msg.sender, _spender, _tokens);
561 	}
562 
563 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
564 		uint256 _allowance = allowance(_from, msg.sender);
565 		require(_allowance >= _tokens);
566 		if (_allowance != UINT_MAX) {
567 			info.users[_from].allowance[msg.sender] -= _tokens;
568 		}
569 		return _transfer(_from, _to, _tokens);
570 	}
571 
572 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
573 		_transfer(msg.sender, _to, _tokens);
574 		uint32 _size;
575 		assembly {
576 			_size := extcodesize(_to)
577 		}
578 		if (_size > 0) {
579 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
580 		}
581 		return true;
582 	}
583 	
584 
585 	function team() public view returns (address) {
586 		return address(info.team);
587 	}
588 
589 	function pool() public view returns (address) {
590 		return info.pool;
591 	}
592 
593 	function totalSupply() public view returns (uint256) {
594 		return info.totalSupply;
595 	}
596 
597 	function balanceOf(address _user) public view returns (uint256) {
598 		return info.users[_user].balance;
599 	}
600 
601 	function allowance(address _user, address _spender) public view returns (uint256) {
602 		return info.users[_user].allowance[_spender];
603 	}
604 
605 	function position() public view returns (uint256) {
606 		return info.positionId;
607 	}
608 
609 
610 	function _approve(address _owner, address _spender, uint256 _tokens) internal returns (bool) {
611 		info.users[_owner].allowance[_spender] = _tokens;
612 		emit Approval(_owner, _spender, _tokens);
613 		return true;
614 	}
615 	
616 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
617 		unchecked {
618 			if (block.timestamp < info.startTime + LIMIT_TIME) {
619 				require(_tokens <= TOKEN_LIMIT);
620 			}
621 			require(balanceOf(_from) >= _tokens);
622 			info.users[_from].balance -= _tokens;
623 			info.users[_to].balance += _tokens;
624 			emit Transfer(_from, _to, _tokens);
625 			return true;
626 		}
627 	}
628 
629 
630 	function _getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
631 		unchecked {
632 			uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
633 			require(absTick <= uint256(int256(MAX_TICK)), 'T');
634 
635 			uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
636 			if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
637 			if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
638 			if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
639 			if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
640 			if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
641 			if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
642 			if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
643 			if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
644 			if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
645 			if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
646 			if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
647 			if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
648 			if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
649 			if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
650 			if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
651 			if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
652 			if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
653 			if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
654 			if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
655 
656 			if (tick > 0) ratio = type(uint256).max / ratio;
657 
658 			sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
659 		}
660 	}
661 
662 	function _getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
663 		unchecked {
664 			require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
665 			uint256 ratio = uint256(sqrtPriceX96) << 32;
666 
667 			uint256 r = ratio;
668 			uint256 msb = 0;
669 
670 			assembly {
671 				let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
672 				msb := or(msb, f)
673 				r := shr(f, r)
674 			}
675 			assembly {
676 				let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
677 				msb := or(msb, f)
678 				r := shr(f, r)
679 			}
680 			assembly {
681 				let f := shl(5, gt(r, 0xFFFFFFFF))
682 				msb := or(msb, f)
683 				r := shr(f, r)
684 			}
685 			assembly {
686 				let f := shl(4, gt(r, 0xFFFF))
687 				msb := or(msb, f)
688 				r := shr(f, r)
689 			}
690 			assembly {
691 				let f := shl(3, gt(r, 0xFF))
692 				msb := or(msb, f)
693 				r := shr(f, r)
694 			}
695 			assembly {
696 				let f := shl(2, gt(r, 0xF))
697 				msb := or(msb, f)
698 				r := shr(f, r)
699 			}
700 			assembly {
701 				let f := shl(1, gt(r, 0x3))
702 				msb := or(msb, f)
703 				r := shr(f, r)
704 			}
705 			assembly {
706 				let f := gt(r, 0x1)
707 				msb := or(msb, f)
708 			}
709 
710 			if (msb >= 128) r = ratio >> (msb - 127);
711 			else r = ratio << (127 - msb);
712 
713 			int256 log_2 = (int256(msb) - 128) << 64;
714 
715 			assembly {
716 				r := shr(127, mul(r, r))
717 				let f := shr(128, r)
718 				log_2 := or(log_2, shl(63, f))
719 				r := shr(f, r)
720 			}
721 			assembly {
722 				r := shr(127, mul(r, r))
723 				let f := shr(128, r)
724 				log_2 := or(log_2, shl(62, f))
725 				r := shr(f, r)
726 			}
727 			assembly {
728 				r := shr(127, mul(r, r))
729 				let f := shr(128, r)
730 				log_2 := or(log_2, shl(61, f))
731 				r := shr(f, r)
732 			}
733 			assembly {
734 				r := shr(127, mul(r, r))
735 				let f := shr(128, r)
736 				log_2 := or(log_2, shl(60, f))
737 				r := shr(f, r)
738 			}
739 			assembly {
740 				r := shr(127, mul(r, r))
741 				let f := shr(128, r)
742 				log_2 := or(log_2, shl(59, f))
743 				r := shr(f, r)
744 			}
745 			assembly {
746 				r := shr(127, mul(r, r))
747 				let f := shr(128, r)
748 				log_2 := or(log_2, shl(58, f))
749 				r := shr(f, r)
750 			}
751 			assembly {
752 				r := shr(127, mul(r, r))
753 				let f := shr(128, r)
754 				log_2 := or(log_2, shl(57, f))
755 				r := shr(f, r)
756 			}
757 			assembly {
758 				r := shr(127, mul(r, r))
759 				let f := shr(128, r)
760 				log_2 := or(log_2, shl(56, f))
761 				r := shr(f, r)
762 			}
763 			assembly {
764 				r := shr(127, mul(r, r))
765 				let f := shr(128, r)
766 				log_2 := or(log_2, shl(55, f))
767 				r := shr(f, r)
768 			}
769 			assembly {
770 				r := shr(127, mul(r, r))
771 				let f := shr(128, r)
772 				log_2 := or(log_2, shl(54, f))
773 				r := shr(f, r)
774 			}
775 			assembly {
776 				r := shr(127, mul(r, r))
777 				let f := shr(128, r)
778 				log_2 := or(log_2, shl(53, f))
779 				r := shr(f, r)
780 			}
781 			assembly {
782 				r := shr(127, mul(r, r))
783 				let f := shr(128, r)
784 				log_2 := or(log_2, shl(52, f))
785 				r := shr(f, r)
786 			}
787 			assembly {
788 				r := shr(127, mul(r, r))
789 				let f := shr(128, r)
790 				log_2 := or(log_2, shl(51, f))
791 				r := shr(f, r)
792 			}
793 			assembly {
794 				r := shr(127, mul(r, r))
795 				let f := shr(128, r)
796 				log_2 := or(log_2, shl(50, f))
797 			}
798 
799 			int256 log_sqrt10001 = log_2 * 255738958999603826347141;
800 
801 			int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
802 			int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
803 
804 			tick = tickLow == tickHi ? tickLow : _getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
805 		}
806 	}
807 
808 	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
809 		unchecked {
810 			uint256 _tmp = (_n + 1) / 2;
811 			result = _n;
812 			while (_tmp < result) {
813 				result = _tmp;
814 				_tmp = (_n / _tmp + _tmp) / 2;
815 			}
816 		}
817 	}
818 
819 	function _getPriceAndTickFromValues(bool _weth0, uint256 _tokens, uint256 _weth) internal pure returns (uint160 price, int24 tick) {
820 		uint160 _tmpPrice = uint160(_sqrt(2**192 / (!_weth0 ? _tokens : _weth) * (_weth0 ? _tokens : _weth)));
821 		tick = _getTickAtSqrtRatio(_tmpPrice);
822 		tick = tick - (tick % 200);
823 		price = _getSqrtRatioAtTick(tick);
824 	}
825 }
826 
827 
828 contract Deploy {
829 	MULLET immutable public mullet;
830 	HEDGE immutable public hedge;
831 	constructor() payable {
832 		mullet = new MULLET{value:msg.value}();
833 		mullet.initialize();
834 		hedge = HEDGE(Team(payable(mullet.team())).hedge());
835 	}
836 }