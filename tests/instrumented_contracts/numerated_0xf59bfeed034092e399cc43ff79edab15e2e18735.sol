1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 /*
5 
6        .
7       ":"
8     ___:____     |"\/"|
9   ,'        `.    \  /
10   |  O        \___/  |
11 ~^~^~^~^~^~^~^~^~^~^~^~^~
12 
13 Whales Game | Generative Yield NFTs
14 Mint tokens and earn KRILL with this new blockchain based game! Battle it out to see who can generate the most yield.
15 
16 Website: https://whales.game/
17 
18 */
19 
20 interface MetadataInterface {
21 	function name() external view returns (string memory);
22 	function symbol() external view returns (string memory);
23 	function tokenURI(uint256 _tokenId) external view returns (string memory);
24 	function deploySetWhalesGame(WhalesGame _wg) external;
25 }
26 
27 interface Callable {
28 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
29 }
30 
31 interface Receiver {
32 	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns (bytes4);
33 }
34 
35 interface Router {
36 	function WETH() external pure returns (address);
37 	function factory() external pure returns (address);
38 }
39 
40 interface Factory {
41 	function getPair(address, address) external view returns (address);
42 	function createPair(address, address) external returns (address);
43 }
44 
45 interface Pair {
46 	function token0() external view returns (address);
47 	function totalSupply() external view returns (uint256);
48 	function balanceOf(address) external view returns (uint256);
49 	function allowance(address, address) external view returns (uint256);
50 	function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
51 	function transfer(address, uint256) external returns (bool);
52 	function transferFrom(address, address, uint256) external returns (bool);
53 }
54 
55 
56 contract KRILL {
57 
58 	uint256 constant private UINT_MAX = type(uint256).max;
59 	uint256 constant private TRANSFER_FEE = 1; // 1% per transfer
60 
61 	string constant public name = "Krill Token";
62 	string constant public symbol = "KRILL";
63 	uint8 constant public decimals = 18;
64 
65 	struct User {
66 		uint256 balance;
67 		mapping(address => uint256) allowance;
68 	}
69 
70 	struct Info {
71 		uint256 totalSupply;
72 		mapping(address => User) users;
73 		mapping(address => bool) toWhitelist;
74 		mapping(address => bool) fromWhitelist;
75 		address owner;
76 		Router router;
77 		Pair pair;
78 		bool weth0;
79 		WhalesGame wg;
80 		StakingRewards stakingRewards;
81 	}
82 	Info private info;
83 
84 
85 	event Transfer(address indexed from, address indexed to, uint256 tokens);
86 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
87 	event WhitelistUpdated(address indexed user, bool fromWhitelisted, bool toWhitelisted);
88 
89 
90 	modifier _onlyOwner() {
91 		require(msg.sender == owner());
92 		_;
93 	}
94 
95 
96 	constructor() {
97 		info.router = Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
98 		info.pair = Pair(Factory(info.router.factory()).createPair(info.router.WETH(), address(this)));
99 		info.weth0 = info.pair.token0() == info.router.WETH();
100 		info.owner = msg.sender;
101 	}
102 
103 	function setOwner(address _owner) external _onlyOwner {
104 		info.owner = _owner;
105 	}
106 
107 	function setWhitelisted(address _address, bool _fromWhitelisted, bool _toWhitelisted) external _onlyOwner {
108 		info.fromWhitelist[_address] = _fromWhitelisted;
109 		info.toWhitelist[_address] = _toWhitelisted;
110 		emit WhitelistUpdated(_address, _fromWhitelisted, _toWhitelisted);
111 	}
112 
113 	function deploySetWhalesGame(WhalesGame _wg) external {
114 		require(tx.origin == owner() && stakingRewardsAddress() == address(0x0));
115 		info.wg = _wg;
116 		info.stakingRewards = new StakingRewards(info.wg, info.pair);
117 		_approve(address(this), stakingRewardsAddress(), UINT_MAX);
118 	}
119 
120 
121 	function mint(address _receiver, uint256 _tokens) external {
122 		require(msg.sender == address(info.wg));
123 		info.totalSupply += _tokens;
124 		info.users[_receiver].balance += _tokens;
125 		emit Transfer(address(0x0), _receiver, _tokens);
126 	}
127 
128 	function burn(uint256 _tokens) external {
129 		require(balanceOf(msg.sender) >= _tokens);
130 		info.totalSupply -= _tokens;
131 		info.users[msg.sender].balance -= _tokens;
132 		emit Transfer(msg.sender, address(0x0), _tokens);
133 	}
134 
135 	function transfer(address _to, uint256 _tokens) external returns (bool) {
136 		return _transfer(msg.sender, _to, _tokens);
137 	}
138 
139 	function approve(address _spender, uint256 _tokens) external returns (bool) {
140 		return _approve(msg.sender, _spender, _tokens);
141 	}
142 
143 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
144 		uint256 _allowance = allowance(_from, msg.sender);
145 		require(_allowance >= _tokens);
146 		if (_allowance != UINT_MAX) {
147 			info.users[_from].allowance[msg.sender] -= _tokens;
148 		}
149 		return _transfer(_from, _to, _tokens);
150 	}
151 
152 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
153 		uint256 _balanceBefore = balanceOf(_to);
154 		_transfer(msg.sender, _to, _tokens);
155 		uint256 _tokensReceived = balanceOf(_to) - _balanceBefore;
156 		uint32 _size;
157 		assembly {
158 			_size := extcodesize(_to)
159 		}
160 		if (_size > 0) {
161 			require(Callable(_to).tokenCallback(msg.sender, _tokensReceived, _data));
162 		}
163 		return true;
164 	}
165 	
166 
167 	function whalesGameAddress() public view returns (address) {
168 		return address(info.wg);
169 	}
170 
171 	function pairAddress() external view returns (address) {
172 		return address(info.pair);
173 	}
174 
175 	function stakingRewardsAddress() public view returns (address) {
176 		return address(info.stakingRewards);
177 	}
178 
179 	function owner() public view returns (address) {
180 		return info.owner;
181 	}
182 
183 	function isFromWhitelisted(address _address) public view returns (bool) {
184 		return info.fromWhitelist[_address];
185 	}
186 
187 	function isToWhitelisted(address _address) public view returns (bool) {
188 		return info.toWhitelist[_address];
189 	}
190 	
191 	function totalSupply() public view returns (uint256) {
192 		return info.totalSupply;
193 	}
194 
195 	function balanceOf(address _user) public view returns (uint256) {
196 		return info.users[_user].balance;
197 	}
198 
199 	function allowance(address _user, address _spender) public view returns (uint256) {
200 		return info.users[_user].allowance[_spender];
201 	}
202 
203 	function allInfoFor(address _user) external view returns (uint256 totalTokens, uint256 totalLPTokens, uint256 wethReserve, uint256 krillReserve, uint256 userAllowance, uint256 userBalance, uint256 userLPBalance) {
204 		totalTokens = totalSupply();
205 		totalLPTokens = info.pair.totalSupply();
206 		(uint256 _res0, uint256 _res1, ) = info.pair.getReserves();
207 		wethReserve = info.weth0 ? _res0 : _res1;
208 		krillReserve = info.weth0 ? _res1 : _res0;
209 		userAllowance = allowance(_user, whalesGameAddress());
210 		userBalance = balanceOf(_user);
211 		userLPBalance = info.pair.balanceOf(_user);
212 	}
213 
214 
215 	function _approve(address _owner, address _spender, uint256 _tokens) internal returns (bool) {
216 		info.users[_owner].allowance[_spender] = _tokens;
217 		emit Approval(_owner, _spender, _tokens);
218 		return true;
219 	}
220 	
221 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
222 		require(balanceOf(_from) >= _tokens);
223 		info.users[_from].balance -= _tokens;
224 		uint256 _fee = 0;
225 		if (!(_from == stakingRewardsAddress() || _to == stakingRewardsAddress() || _to == whalesGameAddress() || isFromWhitelisted(_from) || isToWhitelisted(_to))) {
226 			_fee = _tokens * TRANSFER_FEE / 100;
227 			address _this = address(this);
228 			info.users[_this].balance += _fee;
229 			emit Transfer(_from, _this, _fee);
230 			info.stakingRewards.disburse(balanceOf(_this));
231 		}
232 		info.users[_to].balance += _tokens - _fee;
233 		emit Transfer(_from, _to, _tokens - _fee);
234 		return true;
235 	}
236 }
237 
238 
239 contract StakingRewards {
240 
241 	uint256 constant private FLOAT_SCALAR = 2**64;
242 
243 	struct User {
244 		uint256 deposited;
245 		int256 scaledPayout;
246 	}
247 
248 	struct Info {
249 		uint256 totalDeposited;
250 		uint256 scaledRewardsPerToken;
251 		uint256 pendingRewards;
252 		mapping(address => User) users;
253 		WhalesGame wg;
254 		KRILL krill;
255 		Pair pair;
256 	}
257 	Info private info;
258 
259 
260 	event Deposit(address indexed user, uint256 amount);
261 	event Withdraw(address indexed user, uint256 amount);
262 	event Claim(address indexed user, uint256 amount);
263 	event Reward(uint256 amount);
264 
265 
266 	constructor(WhalesGame _wg, Pair _pair) {
267 		info.wg = _wg;
268 		info.krill = KRILL(msg.sender);
269 		info.pair = _pair;
270 	}
271 
272 	function disburse(uint256 _amount) external {
273 		if (_amount > 0) {
274 			info.krill.transferFrom(msg.sender, address(this), _amount);
275 			_disburse(_amount);
276 		}
277 	}
278 
279 	function deposit(uint256 _amount) external {
280 		depositFor(_amount, msg.sender);
281 	}
282 
283 	function depositFor(uint256 _amount, address _user) public {
284 		require(_amount > 0);
285 		_update();
286 		info.pair.transferFrom(msg.sender, address(this), _amount);
287 		info.totalDeposited += _amount;
288 		info.users[_user].deposited += _amount;
289 		info.users[_user].scaledPayout += int256(_amount * info.scaledRewardsPerToken);
290 		emit Deposit(_user, _amount);
291 	}
292 
293 	function withdrawAll() external {
294 		uint256 _deposited = depositedOf(msg.sender);
295 		if (_deposited > 0) {
296 			withdraw(_deposited);
297 		}
298 	}
299 
300 	function withdraw(uint256 _amount) public {
301 		require(_amount > 0 && _amount <= depositedOf(msg.sender));
302 		_update();
303 		info.totalDeposited -= _amount;
304 		info.users[msg.sender].deposited -= _amount;
305 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledRewardsPerToken);
306 		info.pair.transfer(msg.sender, _amount);
307 		emit Withdraw(msg.sender, _amount);
308 	}
309 
310 	function claim() external {
311 		_update();
312 		uint256 _rewards = rewardsOf(msg.sender);
313 		if (_rewards > 0) {
314 			info.users[msg.sender].scaledPayout += int256(_rewards * FLOAT_SCALAR);
315 			info.krill.transfer(msg.sender, _rewards);
316 			emit Claim(msg.sender, _rewards);
317 		}
318 	}
319 
320 	
321 	function totalDeposited() public view returns (uint256) {
322 		return info.totalDeposited;
323 	}
324 
325 	function depositedOf(address _user) public view returns (uint256) {
326 		return info.users[_user].deposited;
327 	}
328 	
329 	function rewardsOf(address _user) public view returns (uint256) {
330 		return uint256(int256(info.scaledRewardsPerToken * depositedOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
331 	}
332 
333 	function allInfoFor(address _user) external view returns (uint256 totalLPDeposited, uint256 totalLPTokens, uint256 wethReserve, uint256 krillReserve, uint256 userBalance, uint256 userAllowance, uint256 userDeposited, uint256 userRewards) {
334 		totalLPDeposited = totalDeposited();
335 		( , totalLPTokens, wethReserve, krillReserve, , , ) = info.krill.allInfoFor(address(this));
336 		userBalance = info.pair.balanceOf(_user);
337 		userAllowance = info.pair.allowance(_user, address(this));
338 		userDeposited = depositedOf(_user);
339 		userRewards = rewardsOf(_user);
340 	}
341 
342 	function _update() internal {
343 		address _this = address(this);
344 		uint256 _balanceBefore = info.krill.balanceOf(_this);
345 		info.wg.claim();
346 		_disburse(info.krill.balanceOf(_this) - _balanceBefore);
347 	}
348 
349 	function _disburse(uint256 _amount) internal {
350 		if (_amount > 0) {
351 			if (totalDeposited() == 0) {
352 				info.pendingRewards += _amount;
353 			} else {
354 				info.scaledRewardsPerToken += (_amount + info.pendingRewards) * FLOAT_SCALAR / totalDeposited();
355 				info.pendingRewards = 0;
356 			}
357 			emit Reward(_amount);
358 		}
359 	}
360 }
361 
362 
363 contract WhalesGame {
364 
365 	uint256 constant public ETH_MINTABLE_SUPPLY = 2000;
366 	uint256 constant public WHITELIST_ETH_MINTABLE_SUPPLY = 8000;
367 	uint256 constant public KRILL_MINTABLE_SUPPLY = 40000;
368 	uint256 constant public MAX_SUPPLY = ETH_MINTABLE_SUPPLY + WHITELIST_ETH_MINTABLE_SUPPLY + KRILL_MINTABLE_SUPPLY;
369 	uint256 constant public INITIAL_MINT_COST_ETH = 0.05 ether;
370 	uint256 constant public KRILL_PER_DAY_PER_FISHERMAN = 1e22; // 10,000
371 
372 	uint256 constant private KRILL_COST_ADD = 1e4;
373 	uint256 constant private KRILL_COST_EXPONENT = 3;
374 	uint256 constant private KRILL_COST_SCALER = 2e10;
375 	// KRILL minted tokens = 0, minting cost = 20,000
376 	// KRILL minted tokens = 40k, minting cost = 2,500,000
377 
378 	uint256 constant private FLOAT_SCALAR = 2**64;
379 	uint256 constant private WHALE_MODULUS = 10; // 1 in 10
380 	uint256 constant private WHALES_CUT = 20; // 20% of all yield
381 	uint256 constant private STAKING_CUT = 25; // 25% of minting costs
382 	uint256 constant private DEV_TOKENS = 50;
383 	uint256 constant private OPENING_DELAY = 2 hours;
384 	uint256 constant private WHITELIST_DURATION = 8 hours;
385 
386 	struct User {
387 		uint256 balance;
388 		mapping(uint256 => uint256) list;
389 		mapping(address => bool) approved;
390 		mapping(uint256 => uint256) indexOf;
391 		uint256 rewards;
392 		uint256 lastUpdated;
393 		uint256 krillPerDay;
394 		uint256 whales;
395 		int256 scaledPayout;
396 	}
397 
398 	struct Token {
399 		address owner;
400 		address approved;
401 		bytes32 seed;
402 		bool isWhale;
403 	}
404 
405 	struct Info {
406 		uint256 totalSupply;
407 		uint256 totalWhales;
408 		uint256 ethMintedTokens;
409 		uint256 krillMintedTokens;
410 		uint256 scaledRewardsPerWhale;
411 		uint256 openingTime;
412 		uint256 whitelistExpiry;
413 		mapping(uint256 => Token) list;
414 		mapping(address => User) users;
415 		mapping(uint256 => uint256) claimedBitMap;
416 		bytes32 merkleRoot;
417 		MetadataInterface metadata;
418 		address owner;
419 		KRILL krill;
420 		StakingRewards stakingRewards;
421 	}
422 	Info private info;
423 
424 	mapping(bytes4 => bool) public supportsInterface;
425 
426 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
427 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
428 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
429 
430 	event Mint(address indexed owner, uint256 indexed tokenId, bytes32 seed, bool isWhale);
431 	event ClaimFishermenRewards(address indexed user, uint256 amount);
432 	event ClaimWhaleRewards(address indexed user, uint256 amount);
433 	event Reward(address indexed user, uint256 amount);
434 	event WhalesReward(uint256 amount);
435 	event StakingReward(uint256 amount);
436 
437 
438 	modifier _onlyOwner() {
439 		require(msg.sender == owner());
440 		_;
441 	}
442 
443 
444 	constructor(MetadataInterface _metadata, KRILL _krill, bytes32 _merkleRoot) {
445 		info.metadata = _metadata;
446 		info.metadata.deploySetWhalesGame(this);
447 		info.krill = _krill;
448 		info.krill.deploySetWhalesGame(this);
449 		info.stakingRewards = StakingRewards(info.krill.stakingRewardsAddress());
450 		info.krill.approve(stakingRewardsAddress(), type(uint256).max);
451 		info.merkleRoot = _merkleRoot;
452 		info.owner = 0x99A768bd14Ea62FaADA61F2c7f123303CDAa69fC;
453 		info.openingTime = block.timestamp + OPENING_DELAY;
454 		info.whitelistExpiry = block.timestamp + OPENING_DELAY + WHITELIST_DURATION;
455 
456 		supportsInterface[0x01ffc9a7] = true; // ERC-165
457 		supportsInterface[0x80ac58cd] = true; // ERC-721
458 		supportsInterface[0x5b5e139f] = true; // Metadata
459 		supportsInterface[0x780e9d63] = true; // Enumerable
460 
461 		for (uint256 i = 0; i < DEV_TOKENS; i++) {
462 			_mint(0xa1450E7D547b4748fc94C8C98C9dB667eaD31cF8);
463 		}
464 	}
465 
466 	function setOwner(address _owner) external _onlyOwner {
467 		info.owner = _owner;
468 	}
469 
470 	function setMetadata(MetadataInterface _metadata) external _onlyOwner {
471 		info.metadata = _metadata;
472 	}
473 
474 	function withdraw() external {
475 		address _this = address(this);
476 		require(_this.balance > 0);
477 		payable(0xFaDED72464D6e76e37300B467673b36ECc4d2ccF).transfer(_this.balance / 2); // 50% total
478 		payable(0x1cC79d49ce5b9519C912D810E39025DD27d1F033).transfer(_this.balance / 10); // 5% total
479 		payable(0xa1450E7D547b4748fc94C8C98C9dB667eaD31cF8).transfer(_this.balance); // 45% total
480 	}
481 
482 	
483 	receive() external payable {
484 		mintManyWithETH(msg.value / INITIAL_MINT_COST_ETH);
485 	}
486 	
487 	function mintWithETH() external payable {
488 		mintManyWithETH(1);
489 	}
490 
491 	function mintManyWithETH(uint256 _tokens) public payable {
492 		require(isOpen());
493 		require(_tokens > 0);
494 		if (whitelistExpired()) {
495 			require(totalSupply() - krillMintedTokens() + _tokens <= ETH_MINTABLE_SUPPLY + WHITELIST_ETH_MINTABLE_SUPPLY);
496 		} else {
497 			require(ethMintedTokens() + _tokens <= ETH_MINTABLE_SUPPLY);
498 		}
499 		uint256 _cost = _tokens * INITIAL_MINT_COST_ETH;
500 		require(msg.value >= _cost);
501 		info.ethMintedTokens += _tokens;
502 		for (uint256 i = 0; i < _tokens; i++) {
503 			_mint(msg.sender);
504 		}
505 		if (msg.value > _cost) {
506 			payable(msg.sender).transfer(msg.value - _cost);
507 		}
508 	}
509 
510 	function mintWithProof(uint256 _index, address _account, bytes32[] calldata _merkleProof) external payable {
511 		require(isOpen());
512 		require(!whitelistExpired() && whitelistMintedTokens() < WHITELIST_ETH_MINTABLE_SUPPLY);
513 		require(msg.value >= INITIAL_MINT_COST_ETH);
514 		require(!proofClaimed(_index));
515 		bytes32 _node = keccak256(abi.encodePacked(_index, _account));
516 		require(_verify(_merkleProof, _node));
517 		uint256 _claimedWordIndex = _index / 256;
518 		uint256 _claimedBitIndex = _index % 256;
519 		info.claimedBitMap[_claimedWordIndex] = info.claimedBitMap[_claimedWordIndex] | (1 << _claimedBitIndex);
520 		_mint(_account);
521 		if (msg.value > INITIAL_MINT_COST_ETH) {
522 			payable(msg.sender).transfer(msg.value - INITIAL_MINT_COST_ETH);
523 		}
524 	}
525 
526 	function mint() external {
527 		mintMany(1);
528 	}
529 
530 	function mintMany(uint256 _tokens) public {
531 		require(isOpen());
532 		require(_tokens > 0 && krillMintedTokens() + _tokens <= KRILL_MINTABLE_SUPPLY);
533 		uint256 _cost = calculateKrillMintCost(_tokens);
534 		info.krill.transferFrom(msg.sender, address(this), _cost);
535 		uint256 _stakingReward = _cost * STAKING_CUT / 100;
536 		info.stakingRewards.disburse(_stakingReward);
537 		emit StakingReward(_stakingReward);
538 		info.krill.burn(info.krill.balanceOf(address(this)));
539 		info.krillMintedTokens += _tokens;
540 		for (uint256 i = 0; i < _tokens; i++) {
541 			_mint(msg.sender);
542 		}
543 	}
544 
545 	function claim() external {
546 		claimFishermenRewards();
547 		claimWhaleRewards();
548 	}
549 
550 	function claimFishermenRewards() public {
551 		_update(msg.sender);
552 		uint256 _rewards = info.users[msg.sender].rewards;
553 		if (_rewards > 0) {
554 			info.users[msg.sender].rewards = 0;
555 			info.krill.mint(msg.sender, _rewards);
556 			emit ClaimFishermenRewards(msg.sender, _rewards);
557 		}
558 	}
559 
560 	function claimWhaleRewards() public {
561 		uint256 _rewards = whaleRewardsOf(msg.sender);
562 		if (_rewards > 0) {
563 			info.users[msg.sender].scaledPayout += int256(_rewards * FLOAT_SCALAR);
564 			info.krill.mint(msg.sender, _rewards);
565 			emit ClaimWhaleRewards(msg.sender, _rewards);
566 		}
567 	}
568 	
569 	function approve(address _approved, uint256 _tokenId) external {
570 		require(msg.sender == ownerOf(_tokenId));
571 		info.list[_tokenId].approved = _approved;
572 		emit Approval(msg.sender, _approved, _tokenId);
573 	}
574 
575 	function setApprovalForAll(address _operator, bool _approved) external {
576 		info.users[msg.sender].approved[_operator] = _approved;
577 		emit ApprovalForAll(msg.sender, _operator, _approved);
578 	}
579 
580 	function transferFrom(address _from, address _to, uint256 _tokenId) external {
581 		_transfer(_from, _to, _tokenId);
582 	}
583 
584 	function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
585 		safeTransferFrom(_from, _to, _tokenId, "");
586 	}
587 
588 	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public {
589 		_transfer(_from, _to, _tokenId);
590 		uint32 _size;
591 		assembly {
592 			_size := extcodesize(_to)
593 		}
594 		if (_size > 0) {
595 			require(Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) == 0x150b7a02);
596 		}
597 	}
598 
599 
600 	function name() external view returns (string memory) {
601 		return info.metadata.name();
602 	}
603 
604 	function symbol() external view returns (string memory) {
605 		return info.metadata.symbol();
606 	}
607 
608 	function tokenURI(uint256 _tokenId) external view returns (string memory) {
609 		return info.metadata.tokenURI(_tokenId);
610 	}
611 
612 	function krillAddress() external view returns (address) {
613 		return address(info.krill);
614 	}
615 
616 	function pairAddress() external view returns (address) {
617 		return info.krill.pairAddress();
618 	}
619 
620 	function stakingRewardsAddress() public view returns (address) {
621 		return address(info.stakingRewards);
622 	}
623 
624 	function merkleRoot() public view returns (bytes32) {
625 		return info.merkleRoot;
626 	}
627 
628 	function openingTime() public view returns (uint256) {
629 		return info.openingTime;
630 	}
631 
632 	function isOpen() public view returns (bool) {
633 		return block.timestamp > openingTime();
634 	}
635 
636 	function whitelistExpiry() public view returns (uint256) {
637 		return info.whitelistExpiry;
638 	}
639 
640 	function whitelistExpired() public view returns (bool) {
641 		return block.timestamp > whitelistExpiry();
642 	}
643 
644 	function owner() public view returns (address) {
645 		return info.owner;
646 	}
647 
648 	function totalSupply() public view returns (uint256) {
649 		return info.totalSupply;
650 	}
651 
652 	function ethMintedTokens() public view returns (uint256) {
653 		return info.ethMintedTokens;
654 	}
655 
656 	function krillMintedTokens() public view returns (uint256) {
657 		return info.krillMintedTokens;
658 	}
659 
660 	function whitelistMintedTokens() public view returns (uint256) {
661 		return totalSupply() - ethMintedTokens() - krillMintedTokens();
662 	}
663 
664 	function totalWhales() public view returns (uint256) {
665 		return info.totalWhales;
666 	}
667 
668 	function totalFishermen() public view returns (uint256) {
669 		return totalSupply() - totalWhales();
670 	}
671 
672 	function totalKrillPerDay() external view returns (uint256) {
673 		return totalFishermen() * KRILL_PER_DAY_PER_FISHERMAN;
674 	}
675 
676 	function currentKrillMintCost() public view returns (uint256) {
677 		return krillMintCost(krillMintedTokens());
678 	}
679 
680 	function krillMintCost(uint256 _krillMintedTokens) public pure returns (uint256) {
681 		return (_krillMintedTokens + KRILL_COST_ADD)**KRILL_COST_EXPONENT * KRILL_COST_SCALER;
682 	}
683 
684 	function calculateKrillMintCost(uint256 _tokens) public view returns (uint256 cost) {
685 		cost = 0;
686 		for (uint256 i = 0; i < _tokens; i++) {
687 			cost += krillMintCost(krillMintedTokens() + i);
688 		}
689 	}
690 
691 	function fishermenRewardsOf(address _owner) public view returns (uint256) {
692 		uint256 _pending = 0;
693 		uint256 _last = info.users[_owner].lastUpdated;
694 		if (_last < block.timestamp) {
695 			uint256 _diff = block.timestamp - _last;
696 			_pending += ownerKrillPerDay(_owner) * _diff * (100 - WHALES_CUT) / 8640000;
697 		}
698 		return info.users[_owner].rewards + _pending;
699 	}
700 	
701 	function whaleRewardsOf(address _owner) public view returns (uint256) {
702 		return uint256(int256(info.scaledRewardsPerWhale * whalesOf(_owner)) - info.users[_owner].scaledPayout) / FLOAT_SCALAR;
703 	}
704 
705 	function balanceOf(address _owner) public view returns (uint256) {
706 		return info.users[_owner].balance;
707 	}
708 
709 	function whalesOf(address _owner) public view returns (uint256) {
710 		return info.users[_owner].whales;
711 	}
712 
713 	function fishermenOf(address _owner) public view returns (uint256) {
714 		return balanceOf(_owner) - whalesOf(_owner);
715 	}
716 
717 	function ownerOf(uint256 _tokenId) public view returns (address) {
718 		require(_tokenId < totalSupply());
719 		return info.list[_tokenId].owner;
720 	}
721 
722 	function getApproved(uint256 _tokenId) public view returns (address) {
723 		require(_tokenId < totalSupply());
724 		return info.list[_tokenId].approved;
725 	}
726 
727 	function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
728 		return info.users[_owner].approved[_operator];
729 	}
730 
731 	function getSeed(uint256 _tokenId) public view returns (bytes32) {
732 		require(_tokenId < totalSupply());
733 		return info.list[_tokenId].seed;
734 	}
735 
736 	function getIsWhale(uint256 _tokenId) public view returns (bool) {
737 		require(_tokenId < totalSupply());
738 		return info.list[_tokenId].isWhale;
739 	}
740 
741 	function tokenByIndex(uint256 _index) public view returns (uint256) {
742 		require(_index < totalSupply());
743 		return _index;
744 	}
745 
746 	function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
747 		require(_index < balanceOf(_owner));
748 		return info.users[_owner].list[_index];
749 	}
750 
751 	function ownerKrillPerDay(address _owner) public view returns (uint256 amount) {
752 		return info.users[_owner].krillPerDay;
753 	}
754 
755 	function proofClaimed(uint256 _index) public view returns (bool) {
756 		uint256 _claimedWordIndex = _index / 256;
757 		uint256 _claimedBitIndex = _index % 256;
758 		uint256 _claimedWord = info.claimedBitMap[_claimedWordIndex];
759 		uint256 _mask = (1 << _claimedBitIndex);
760 		return _claimedWord & _mask == _mask;
761 	}
762 
763 	function getToken(uint256 _tokenId) public view returns (address tokenOwner, address approved, bytes32 seed, bool isWhale) {
764 		return (ownerOf(_tokenId), getApproved(_tokenId), getSeed(_tokenId), getIsWhale(_tokenId));
765 	}
766 
767 	function getTokens(uint256[] memory _tokenIds) public view returns (address[] memory owners, address[] memory approveds, bytes32[] memory seeds, bool[] memory isWhales) {
768 		uint256 _length = _tokenIds.length;
769 		owners = new address[](_length);
770 		approveds = new address[](_length);
771 		seeds = new bytes32[](_length);
772 		isWhales = new bool[](_length);
773 		for (uint256 i = 0; i < _length; i++) {
774 			(owners[i], approveds[i], seeds[i], isWhales[i]) = getToken(_tokenIds[i]);
775 		}
776 	}
777 
778 	function getTokensTable(uint256 _limit, uint256 _page, bool _isAsc) external view returns (uint256[] memory tokenIds, address[] memory owners, address[] memory approveds, bytes32[] memory seeds, bool[] memory isWhales, uint256 totalTokens, uint256 totalPages) {
779 		require(_limit > 0);
780 		totalTokens = totalSupply();
781 
782 		if (totalTokens > 0) {
783 			totalPages = (totalTokens / _limit) + (totalTokens % _limit == 0 ? 0 : 1);
784 			require(_page < totalPages);
785 
786 			uint256 _offset = _limit * _page;
787 			if (_page == totalPages - 1 && totalTokens % _limit != 0) {
788 				_limit = totalTokens % _limit;
789 			}
790 
791 			tokenIds = new uint256[](_limit);
792 			for (uint256 i = 0; i < _limit; i++) {
793 				tokenIds[i] = tokenByIndex(_isAsc ? _offset + i : totalTokens - _offset - i - 1);
794 			}
795 		} else {
796 			totalPages = 0;
797 			tokenIds = new uint256[](0);
798 		}
799 		(owners, approveds, seeds, isWhales) = getTokens(tokenIds);
800 	}
801 
802 	function getOwnerTokensTable(address _owner, uint256 _limit, uint256 _page, bool _isAsc) external view returns (uint256[] memory tokenIds, address[] memory approveds, bytes32[] memory seeds, bool[] memory isWhales, uint256 totalTokens, uint256 totalPages) {
803 		require(_limit > 0);
804 		totalTokens = balanceOf(_owner);
805 
806 		if (totalTokens > 0) {
807 			totalPages = (totalTokens / _limit) + (totalTokens % _limit == 0 ? 0 : 1);
808 			require(_page < totalPages);
809 
810 			uint256 _offset = _limit * _page;
811 			if (_page == totalPages - 1 && totalTokens % _limit != 0) {
812 				_limit = totalTokens % _limit;
813 			}
814 
815 			tokenIds = new uint256[](_limit);
816 			for (uint256 i = 0; i < _limit; i++) {
817 				tokenIds[i] = tokenOfOwnerByIndex(_owner, _isAsc ? _offset + i : totalTokens - _offset - i - 1);
818 			}
819 		} else {
820 			totalPages = 0;
821 			tokenIds = new uint256[](0);
822 		}
823 		( , approveds, seeds, isWhales) = getTokens(tokenIds);
824 	}
825 
826 	function allMintingInfo() external view returns (uint256 ethMinted, uint256 whitelistMinted, uint256 krillMinted, uint256 currentKrillCost, uint256 whitelistExpiryTime, bool hasWhitelistExpired, uint256 openTime, bool open) {
827 		return (ethMintedTokens(), whitelistMintedTokens(), krillMintedTokens(), currentKrillMintCost(), whitelistExpiry(), whitelistExpired(), openingTime(), isOpen());
828 	}
829 
830 	function allInfoFor(address _owner) external view returns (uint256 supply, uint256 whales, uint256 ownerBalance, uint256 ownerWhales, uint256 ownerFishermenRewards, uint256 ownerWhaleRewards, uint256 ownerDailyKrill) {
831 		return (totalSupply(), totalWhales(), balanceOf(_owner), whalesOf(_owner), fishermenRewardsOf(_owner), whaleRewardsOf(_owner), ownerKrillPerDay(_owner));
832 	}
833 
834 
835 	function _mint(address _receiver) internal {
836 		require(msg.sender == tx.origin);
837 		require(totalSupply() < MAX_SUPPLY);
838 		uint256 _tokenId = info.totalSupply++;
839 		Token storage _newToken = info.list[_tokenId];
840 		_newToken.owner = _receiver;
841 		bytes32 _seed = keccak256(abi.encodePacked(_tokenId, _receiver, blockhash(block.number - 1), gasleft()));
842 		_newToken.seed = _seed;
843 		_newToken.isWhale = _tokenId < DEV_TOKENS || _tokenId % WHALE_MODULUS == 0;
844 
845 		if (_newToken.isWhale) {
846 			info.totalWhales++;
847 			info.users[_receiver].whales++;
848 			info.users[_receiver].scaledPayout += int256(info.scaledRewardsPerWhale);
849 		} else {
850 			_update(_receiver);
851 			info.users[_receiver].krillPerDay += KRILL_PER_DAY_PER_FISHERMAN;
852 		}
853 		uint256 _index = info.users[_receiver].balance++;
854 		info.users[_receiver].indexOf[_tokenId] = _index + 1;
855 		info.users[_receiver].list[_index] = _tokenId;
856 		emit Transfer(address(0x0), _receiver, _tokenId);
857 		emit Mint(_receiver, _tokenId, _seed, _newToken.isWhale);
858 	}
859 	
860 	function _transfer(address _from, address _to, uint256 _tokenId) internal {
861 		address _owner = ownerOf(_tokenId);
862 		address _approved = getApproved(_tokenId);
863 		require(_from == _owner);
864 		require(msg.sender == _owner || msg.sender == _approved || isApprovedForAll(_owner, msg.sender));
865 
866 		info.list[_tokenId].owner = _to;
867 		if (_approved != address(0x0)) {
868 			info.list[_tokenId].approved = address(0x0);
869 			emit Approval(address(0x0), address(0x0), _tokenId);
870 		}
871 
872 		if (getIsWhale(_tokenId)) {
873 			info.users[_from].whales--;
874 			info.users[_from].scaledPayout -= int256(info.scaledRewardsPerWhale);
875 			info.users[_to].whales++;
876 			info.users[_to].scaledPayout += int256(info.scaledRewardsPerWhale);
877 		} else {
878 			_update(_from);
879 			info.users[_from].krillPerDay -= KRILL_PER_DAY_PER_FISHERMAN;
880 			_update(_to);
881 			info.users[_to].krillPerDay += KRILL_PER_DAY_PER_FISHERMAN;
882 		}
883 
884 		uint256 _index = info.users[_from].indexOf[_tokenId] - 1;
885 		uint256 _moved = info.users[_from].list[info.users[_from].balance - 1];
886 		info.users[_from].list[_index] = _moved;
887 		info.users[_from].indexOf[_moved] = _index + 1;
888 		info.users[_from].balance--;
889 		delete info.users[_from].indexOf[_tokenId];
890 		uint256 _newIndex = info.users[_to].balance++;
891 		info.users[_to].indexOf[_tokenId] = _newIndex + 1;
892 		info.users[_to].list[_newIndex] = _tokenId;
893 		emit Transfer(_from, _to, _tokenId);
894 	}
895 
896 	function _update(address _owner) internal {
897 		uint256 _last = info.users[_owner].lastUpdated;
898 		if (_last < block.timestamp) {
899 			uint256 _diff = block.timestamp - _last;
900 			uint256 _rewards = ownerKrillPerDay(_owner) * _diff / 86400;
901 			uint256 _whalesCut = _rewards * WHALES_CUT / 100;
902 			info.scaledRewardsPerWhale += _whalesCut * FLOAT_SCALAR / totalWhales();
903 			emit WhalesReward(_whalesCut);
904 			info.users[_owner].lastUpdated = block.timestamp;
905 			info.users[_owner].rewards += _rewards - _whalesCut;
906 			emit Reward(_owner, _rewards - _whalesCut);
907 		}
908 	}
909 
910 
911 	function _verify(bytes32[] memory _proof, bytes32 _leaf) internal view returns (bool) {
912 		require(_leaf != merkleRoot());
913 		bytes32 _computedHash = _leaf;
914 		for (uint256 i = 0; i < _proof.length; i++) {
915 			bytes32 _proofElement = _proof[i];
916 			if (_computedHash <= _proofElement) {
917 				_computedHash = keccak256(abi.encodePacked(_computedHash, _proofElement));
918 			} else {
919 				_computedHash = keccak256(abi.encodePacked(_proofElement, _computedHash));
920 			}
921 		}
922 		return _computedHash == merkleRoot();
923 	}
924 }