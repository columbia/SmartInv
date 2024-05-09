1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 interface Callable {
5 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
6 }
7 
8 interface Bridge {
9 	function depositFor(address _user, address _rootToken, bytes calldata _depositData) external;
10 }
11 
12 interface Router {
13 	function WETH() external pure returns (address);
14 	function factory() external pure returns (address);
15 }
16 
17 interface Factory {
18 	function createPair(address, address) external returns (address);
19 }
20 
21 interface Pair {
22 	function token0() external view returns (address);
23 	function totalSupply() external view returns (uint256);
24 	function balanceOf(address) external view returns (uint256);
25 	function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
26 }
27 
28 interface WhalesGame {
29 	function krillAddress() external view returns (address);
30 	function stakingRewardsAddress() external view returns (address);
31 	function getIsWhale(uint256) external view returns (bool);
32 	function balanceOf(address) external view returns (uint256);
33 	function ownerOf(uint256) external view returns (address);
34 	function fishermenOf(address) external view returns (uint256);
35 	function whalesOf(address) external view returns (uint256);
36 	function isApprovedForAll(address, address) external view returns (bool);
37 	function transferFrom(address, address, uint256) external;
38 	function claim() external;
39 }
40 
41 interface KRILL {
42 	function allowance(address, address) external view returns (uint256);
43 	function balanceOf(address) external view returns (uint256);
44 	function approve(address, uint256) external returns (bool);
45 	function transfer(address, uint256) external returns (bool);
46 	function transferFrom(address, address, uint256) external returns (bool);
47 	function burn(uint256) external;
48 }
49 
50 contract WrappedToken {
51 
52 	uint256 constant private UINT_MAX = type(uint256).max;
53 	uint256 constant private FLOAT_SCALAR = 2**64;
54 	address constant private POLYGON_ERC20_BRIDGE = 0x40ec5B33f54e0E8A33A975908C5BA1c14e5BbbDf;
55 
56 	uint8 constant public decimals = 18;
57 
58 	struct User {
59 		uint256 balance;
60 		mapping(address => uint256) allowance;
61 		int256 scaledPayout;
62 	}
63 
64 	struct Info {
65 		uint256 totalSupply;
66 		uint256 scaledRewardsPerToken;
67 		uint256 pendingRewards;
68 		mapping(address => User) users;
69 		mapping(address => bool) rewardBurn;
70 		address burnDestination;
71 		address owner;
72 		bool isBridged;
73 		Bridge bridge;
74 		Router router;
75 		Pair pair;
76 		bool weth0;
77 		bool isWhale;
78 		WhalesGame wg;
79 		KRILL krill;
80 	}
81 	Info private info;
82 
83 
84 	event Transfer(address indexed from, address indexed to, uint256 tokens);
85 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
86 	event Claim(address indexed user, uint256 amount);
87 	event Reward(uint256 amount);
88 
89 
90 	modifier _onlyOwner() {
91 		require(msg.sender == owner());
92 		_;
93 	}
94 
95 
96 	constructor(WhalesGame _wg, bool _isWhale) {
97 		info.isBridged = false;
98 		info.bridge = Bridge(0xA0c68C638235ee32657e8f720a23ceC1bFc77C77);
99 		info.router = Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
100 		info.pair = Pair(Factory(info.router.factory()).createPair(info.router.WETH(), address(this)));
101 		info.weth0 = info.pair.token0() == info.router.WETH();
102 		info.wg = _wg;
103 		info.krill = KRILL(_wg.krillAddress());
104 		info.isWhale = _isWhale;
105 		info.owner = tx.origin;
106 		info.rewardBurn[address(this)] = true;
107 		info.rewardBurn[pairAddress()] = true;
108 		info.rewardBurn[POLYGON_ERC20_BRIDGE] = true;
109 		info.krill.approve(POLYGON_ERC20_BRIDGE, UINT_MAX);
110 		info.burnDestination = address(0x0);
111 	}
112 
113 	function setOwner(address _owner) external _onlyOwner {
114 		info.owner = _owner;
115 	}
116 
117 	function setIsBridged(bool _isBridged) external _onlyOwner {
118 		info.isBridged = _isBridged;
119 	}
120 
121 	function setRewardBurn(address _user, bool _shouldBurn) external _onlyOwner {
122 		uint32 _size;
123 		assembly {
124 			_size := extcodesize(_user)
125 		}
126 		require(_size > 0);
127 		info.rewardBurn[_user] = _shouldBurn;
128 	}
129 
130 	function setBurnDestination(address _destination) external _onlyOwner {
131 		info.burnDestination = _destination;
132 	}
133 
134 
135 	function disburse(uint256 _amount) external {
136 		if (_amount > 0) {
137 			address _this = address(this);
138 			uint256 _balanceBefore = info.krill.balanceOf(_this);
139 			info.krill.transferFrom(msg.sender, _this, _amount);
140 			_disburse(info.krill.balanceOf(_this) - _balanceBefore);
141 		}
142 	}
143 
144 	function wrap(uint256[] calldata _tokenIds) external {
145 		uint256 _count = _tokenIds.length;
146 		require(_count > 0);
147 		_update();
148 		for (uint256 i = 0; i < _count; i++) {
149 			require(info.wg.getIsWhale(_tokenIds[i]) == info.isWhale);
150 			info.wg.transferFrom(msg.sender, address(this), _tokenIds[i]);
151 		}
152 		uint256 _amount = _count * 1e18;
153 		info.totalSupply += _amount;
154 		info.users[msg.sender].balance += _amount;
155 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledRewardsPerToken);
156 		emit Transfer(address(0x0), msg.sender, _amount);
157 	}
158 
159 	function unwrap(uint256[] calldata _tokenIds) external returns (uint256 totalUnwrapped) {
160 		uint256 _count = _tokenIds.length;
161 		require(balanceOf(msg.sender) >= _count * 1e18);
162 		_update();
163 		totalUnwrapped = 0;
164 		for (uint256 i = 0; i < _count; i++) {
165 			if (info.wg.ownerOf(_tokenIds[i]) == address(this)) {
166 				require(info.wg.getIsWhale(_tokenIds[i]) == info.isWhale);
167 				info.wg.transferFrom(address(this), msg.sender, _tokenIds[i]);
168 				totalUnwrapped++;
169 			}
170 		}
171 		require(totalUnwrapped > 0);
172 		uint256 _cost = totalUnwrapped * 1e18;
173 		info.totalSupply -= _cost;
174 		info.users[msg.sender].balance -= _cost;
175 		info.users[msg.sender].scaledPayout -= int256(_cost * info.scaledRewardsPerToken);
176 		emit Transfer(msg.sender, address(0x0), _cost);
177 	}
178 
179 	function claim() external {
180 		claimFor(msg.sender);
181 	}
182 
183 	function claimFor(address _user) public {
184 		_update();
185 		uint256 _rewards = rewardsOf(_user);
186 		if (_rewards > 0) {
187 			info.users[_user].scaledPayout += int256(_rewards * FLOAT_SCALAR);
188 			if (rewardBurn(_user)) {
189 				address _destination = burnDestination();
190 				if (_destination == address(0x0)) {
191 					info.krill.burn(_rewards);
192 				} else {
193 					if (isBridged()) {
194 						info.bridge.depositFor(_destination, address(info.krill), abi.encodePacked(_rewards));
195 					} else {
196 						info.krill.transfer(_destination, _rewards);
197 					}
198 				}
199 			} else {
200 				info.krill.transfer(_user, _rewards);
201 			}
202 			emit Claim(_user, _rewards);
203 		}
204 	}
205 
206 	function transfer(address _to, uint256 _tokens) external returns (bool) {
207 		return _transfer(msg.sender, _to, _tokens);
208 	}
209 
210 	function approve(address _spender, uint256 _tokens) external returns (bool) {
211 		info.users[msg.sender].allowance[_spender] = _tokens;
212 		emit Approval(msg.sender, _spender, _tokens);
213 		return true;
214 	}
215 
216 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
217 		uint256 _allowance = allowance(_from, msg.sender);
218 		require(_allowance >= _tokens);
219 		if (_allowance != UINT_MAX) {
220 			info.users[_from].allowance[msg.sender] -= _tokens;
221 		}
222 		return _transfer(_from, _to, _tokens);
223 	}
224 
225 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
226 		_transfer(msg.sender, _to, _tokens);
227 		uint32 _size;
228 		assembly {
229 			_size := extcodesize(_to)
230 		}
231 		if (_size > 0) {
232 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
233 		}
234 		return true;
235 	}
236 	
237 
238 	function name() external view returns (string memory) {
239 		return info.isWhale ? 'Wrapped Whales' : 'Wrapped Fishermen';
240 	}
241 
242 	function symbol() external view returns (string memory) {
243 		return info.isWhale ? 'wWH' : 'wFM';
244 	}
245 	
246 	function owner() public view returns (address) {
247 		return info.owner;
248 	}
249 	
250 	function isBridged() public view returns (bool) {
251 		return info.isBridged;
252 	}
253 	
254 	function burnDestination() public view returns (address) {
255 		return info.burnDestination;
256 	}
257 	
258 	function rewardBurn(address _user) public view returns (bool) {
259 		return info.rewardBurn[_user];
260 	}
261 	
262 	function pairAddress() public view returns (address) {
263 		return address(info.pair);
264 	}
265 	
266 	function totalSupply() public view returns (uint256) {
267 		return info.totalSupply;
268 	}
269 
270 	function balanceOf(address _user) public view returns (uint256) {
271 		return info.users[_user].balance;
272 	}
273 	
274 	function rewardsOf(address _user) public view returns (uint256) {
275 		return uint256(int256(info.scaledRewardsPerToken * balanceOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
276 	}
277 
278 	function allowance(address _user, address _spender) public view returns (uint256) {
279 		return info.users[_user].allowance[_spender];
280 	}
281 
282 	function allInfoFor(address _user) external view returns (uint256 totalTokens, uint256 totalLPTokens, uint256 wethReserve, uint256 wrappedReserve, uint256 userTokens, bool userApproved, uint256 userBalance, uint256 userRewards, uint256 userLPBalance, uint256 contractFishermen, uint256 contractWhales) {
283 		totalTokens = totalSupply();
284 		totalLPTokens = info.pair.totalSupply();
285 		(uint256 _res0, uint256 _res1, ) = info.pair.getReserves();
286 		wethReserve = info.weth0 ? _res0 : _res1;
287 		wrappedReserve = info.weth0 ? _res1 : _res0;
288 		userTokens = info.wg.balanceOf(_user);
289 		userApproved = info.wg.isApprovedForAll(_user, address(this));
290 		userBalance = balanceOf(_user);
291 		userRewards = rewardsOf(_user);
292 		userLPBalance = info.pair.balanceOf(_user);
293 		contractFishermen = info.wg.fishermenOf(address(this));
294 		contractWhales = info.wg.whalesOf(address(this));
295 	}
296 
297 
298 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
299 		require(balanceOf(_from) >= _tokens);
300 		_update();
301 		info.users[_from].balance -= _tokens;
302 		info.users[_from].scaledPayout -= int256(_tokens * info.scaledRewardsPerToken);
303 		info.users[_to].balance += _tokens;
304 		info.users[_to].scaledPayout += int256(_tokens * info.scaledRewardsPerToken);
305 		emit Transfer(_from, _to, _tokens);
306 		return true;
307 	}
308 
309 	function _update() internal {
310 		address _this = address(this);
311 		uint256 _balanceBefore = info.krill.balanceOf(_this);
312 		info.wg.claim();
313 		_disburse(info.krill.balanceOf(_this) - _balanceBefore);
314 	}
315 
316 	function _disburse(uint256 _amount) internal {
317 		if (_amount > 0) {
318 			if (totalSupply() == 0) {
319 				info.pendingRewards += _amount;
320 			} else {
321 				info.scaledRewardsPerToken += (_amount + info.pendingRewards) * FLOAT_SCALAR / totalSupply();
322 				info.pendingRewards = 0;
323 			}
324 			emit Reward(_amount);
325 		}
326 	}
327 }
328 
329 contract Islands {
330 
331 	uint256 constant private UINT_MAX = type(uint256).max;
332 	uint256 constant private POLYGON_ISLANDS = 1000;
333 	uint256 constant private MINTABLE_ISLANDS = 1000;
334 	uint256 constant private MAX_ISLANDS = POLYGON_ISLANDS + MINTABLE_ISLANDS; // 2k
335 	uint256 constant private BASE_KRILL_COST = 1e23; // 100k
336 	uint256 constant private KRILL_COST_INCREMENT = 2e21; // 2k
337 
338 	string constant public name = "Whales Game Islands";
339 	string constant public symbol = "ISLAND";
340 	uint8 constant public decimals = 18;
341 
342 	struct User {
343 		uint256 balance;
344 		mapping(address => uint256) allowance;
345 	}
346 
347 	struct Info {
348 		uint256 totalSupply;
349 		mapping(address => User) users;
350 		Router router;
351 		Pair pair;
352 		WhalesGame wg;
353 		KRILL krill;
354 		WrappedToken wfm;
355 		WrappedToken wwh;
356 		address owner;
357 		address feeRecipient;
358 		bool weth0;
359 		uint256 openingTime;
360 	}
361 	Info private info;
362 
363 
364 	event Transfer(address indexed from, address indexed to, uint256 tokens);
365 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
366 
367 
368 	modifier _onlyOwner() {
369 		require(msg.sender == owner());
370 		_;
371 	}
372 
373 
374 	constructor(WhalesGame _wg, address _booster, uint256 _openingTime) {
375 		info.router = Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
376 		info.pair = Pair(Factory(info.router.factory()).createPair(info.router.WETH(), address(this)));
377 		info.weth0 = info.pair.token0() == info.router.WETH();
378 		info.wg = _wg;
379 		info.krill = KRILL(_wg.krillAddress());
380 		info.wfm = new WrappedToken(_wg, false);
381 		info.wwh = new WrappedToken(_wg, true);
382 		info.owner = msg.sender;
383 		info.feeRecipient = _booster;
384 		info.openingTime = _openingTime;
385 
386 		uint256 _polygonIslands = POLYGON_ISLANDS * 1e18;
387 		info.totalSupply = _polygonIslands;
388 		info.users[msg.sender].balance = _polygonIslands;
389 		emit Transfer(address(0x0), msg.sender, _polygonIslands);
390 	}
391 
392 	function setOwner(address _owner) external _onlyOwner {
393 		info.owner = _owner;
394 	}
395 
396 	function setFeeRecipient(address _feeRecipient) external _onlyOwner {
397 		info.feeRecipient = _feeRecipient;
398 	}
399 
400 	function buyIsland(uint256[4] memory _fishermenIds, uint256 _whaleId) external {
401 		require(block.timestamp >= info.openingTime);
402 		require(totalIslands() < MAX_ISLANDS);
403 		require(info.wg.getIsWhale(_whaleId));
404 		info.wg.transferFrom(msg.sender, wrappedWhalesAddress(), _whaleId);
405 		require(!info.wg.getIsWhale(_fishermenIds[0]));
406 		info.wg.transferFrom(msg.sender, wrappedFishermenAddress(), _fishermenIds[0]);
407 		require(!info.wg.getIsWhale(_fishermenIds[1]));
408 		info.wg.transferFrom(msg.sender, info.wg.stakingRewardsAddress(), _fishermenIds[1]);
409 		require(!info.wg.getIsWhale(_fishermenIds[2]));
410 		info.wg.transferFrom(msg.sender, info.wg.stakingRewardsAddress(), _fishermenIds[2]);
411 		require(!info.wg.getIsWhale(_fishermenIds[3]));
412 		info.wg.transferFrom(msg.sender, feeRecipient(), _fishermenIds[3]);
413 		info.krill.transferFrom(msg.sender, feeRecipient(), currentKrillCost());
414 
415 		info.totalSupply += 1e18;
416 		info.users[msg.sender].balance += 1e18;
417 		emit Transfer(address(0x0), msg.sender, 1e18);
418 	}
419 
420 	function transfer(address _to, uint256 _tokens) external returns (bool) {
421 		return _transfer(msg.sender, _to, _tokens);
422 	}
423 
424 	function approve(address _spender, uint256 _tokens) external returns (bool) {
425 		info.users[msg.sender].allowance[_spender] = _tokens;
426 		emit Approval(msg.sender, _spender, _tokens);
427 		return true;
428 	}
429 
430 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
431 		uint256 _allowance = allowance(_from, msg.sender);
432 		require(_allowance >= _tokens);
433 		if (_allowance != UINT_MAX) {
434 			info.users[_from].allowance[msg.sender] -= _tokens;
435 		}
436 		return _transfer(_from, _to, _tokens);
437 	}
438 
439 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
440 		_transfer(msg.sender, _to, _tokens);
441 		uint32 _size;
442 		assembly {
443 			_size := extcodesize(_to)
444 		}
445 		if (_size > 0) {
446 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
447 		}
448 		return true;
449 	}
450 	
451 	
452 	function whalesGameAddress() external view returns (address) {
453 		return address(info.wg);
454 	}
455 
456 	function wrappedFishermenAddress() public view returns (address) {
457 		return address(info.wfm);
458 	}
459 
460 	function wrappedWhalesAddress() public view returns (address) {
461 		return address(info.wwh);
462 	}
463 
464 	function owner() public view returns (address) {
465 		return info.owner;
466 	}
467 
468 	function feeRecipient() public view returns (address) {
469 		return info.feeRecipient;
470 	}
471 
472 	function totalSupply() public view returns (uint256) {
473 		return info.totalSupply;
474 	}
475 
476 	function totalIslands() public view returns (uint256) {
477 		return totalSupply() / 1e18;
478 	}
479 
480 	function currentKrillCost() public view returns (uint256) {
481 		return BASE_KRILL_COST + (totalIslands() - POLYGON_ISLANDS) * KRILL_COST_INCREMENT;
482 	}
483 
484 	function balanceOf(address _user) public view returns (uint256) {
485 		return info.users[_user].balance;
486 	}
487 
488 	function allowance(address _user, address _spender) public view returns (uint256) {
489 		return info.users[_user].allowance[_spender];
490 	}
491 
492 	function allInfoFor(address _user) external view returns (uint256 openingTime, uint256 totalTokens, uint256 totalLPTokens, uint256 wethReserve, uint256 islandReserve, uint256 userTokens, bool userApproved, uint256 userAllowance, uint256 userKRILL, uint256 userBalance, uint256 userLPBalance) {
493 		openingTime = info.openingTime;
494 		totalTokens = totalSupply();
495 		totalLPTokens = info.pair.totalSupply();
496 		(uint256 _res0, uint256 _res1, ) = info.pair.getReserves();
497 		wethReserve = info.weth0 ? _res0 : _res1;
498 		islandReserve = info.weth0 ? _res1 : _res0;
499 		userTokens = info.wg.balanceOf(_user);
500 		userApproved = info.wg.isApprovedForAll(_user, address(this));
501 		userAllowance = info.krill.allowance(_user, address(this));
502 		userKRILL = info.krill.balanceOf(_user);
503 		userBalance = balanceOf(_user);
504 		userLPBalance = info.pair.balanceOf(_user);
505 	}
506 
507 
508 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
509 		require(balanceOf(_from) >= _tokens);
510 		info.users[_from].balance -= _tokens;
511 		info.users[_to].balance += _tokens;
512 		emit Transfer(_from, _to, _tokens);
513 		return true;
514 	}
515 }