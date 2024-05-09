1 /*
2  ___ _ _    _    _ _      
3 | _ (_) |__| |__(_) |_ ___
4 |   / | '_ \ '_ \ |  _(_-<
5 |_|_\_|_.__/_.__/_|\__/__/
6 A unique set of 1,000 collectable and tradable frog themed NFTs.
7 
8 Website: https://ribbits.xyz/
9 Created by sol_dev
10 
11 */
12 pragma solidity ^0.5.17;
13 
14 interface Receiver {
15 	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns (bytes4);
16 }
17 
18 interface Callable {
19 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
20 }
21 
22 interface Router {
23 	function WETH() external pure returns (address);
24 	function factory() external pure returns (address);
25 }
26 
27 interface Factory {
28 	function createPair(address, address) external returns (address);
29 }
30 
31 interface Pair {
32 	function token0() external view returns (address);
33 	function totalSupply() external view returns (uint256);
34 	function balanceOf(address) external view returns (uint256);
35 	function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
36 }
37 
38 contract Metadata {
39 	string public name = "Ribbits";
40 	string public symbol = "RBT";
41 	function contractURI() external pure returns (string memory) {
42 		return "https://api.ribbits.xyz/metadata";
43 	}
44 	function baseTokenURI() public pure returns (string memory) {
45 		return "https://api.ribbits.xyz/ribbit/metadata/";
46 	}
47 	function tokenURI(uint256 _tokenId) external pure returns (string memory) {
48 		bytes memory _base = bytes(baseTokenURI());
49 		uint256 _digits = 1;
50 		uint256 _n = _tokenId;
51 		while (_n > 9) {
52 			_n /= 10;
53 			_digits++;
54 		}
55 		bytes memory _uri = new bytes(_base.length + _digits);
56 		for (uint256 i = 0; i < _uri.length; i++) {
57 			if (i < _base.length) {
58 				_uri[i] = _base[i];
59 			} else {
60 				uint256 _dec = (_tokenId / (10**(_uri.length - i - 1))) % 10;
61 				_uri[i] = byte(uint8(_dec) + 48);
62 			}
63 		}
64 		return string(_uri);
65 	}
66 }
67 
68 contract WrappedRibbits {
69 
70 	uint256 constant private UINT_MAX = uint256(-1);
71 
72 	string constant public name = "Wrapped Ribbits";
73 	string constant public symbol = "wRBT";
74 	uint8 constant public decimals = 18;
75 
76 	struct User {
77 		uint256 balance;
78 		mapping(address => uint256) allowance;
79 	}
80 
81 	struct Info {
82 		uint256 totalSupply;
83 		mapping(address => User) users;
84 		Router router;
85 		Pair pair;
86 		Ribbits ribbits;
87 		bool weth0;
88 	}
89 	Info private info;
90 
91 
92 	event Transfer(address indexed from, address indexed to, uint256 tokens);
93 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
94 
95 
96 	constructor(Ribbits _ribbits) public {
97 		info.router = Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
98 		info.pair = Pair(Factory(info.router.factory()).createPair(info.router.WETH(), address(this)));
99 		info.weth0 = info.pair.token0() == info.router.WETH();
100 		info.ribbits = _ribbits;
101 	}
102 
103 	function wrap(uint256[] calldata _tokenIds) external {
104 		uint256 _count = _tokenIds.length;
105 		require(_count > 0);
106 		for (uint256 i = 0; i < _count; i++) {
107 			info.ribbits.transferFrom(msg.sender, address(this), _tokenIds[i]);
108 		}
109 		uint256 _amount = _count * 1e18;
110 		info.totalSupply += _amount;
111 		info.users[msg.sender].balance += _amount;
112 		emit Transfer(address(0x0), msg.sender, _amount);
113 	}
114 
115 	function unwrap(uint256[] calldata _tokenIds) external returns (uint256 totalUnwrapped) {
116 		uint256 _count = _tokenIds.length;
117 		require(balanceOf(msg.sender) >= _count * 1e18);
118 		totalUnwrapped = 0;
119 		for (uint256 i = 0; i < _count; i++) {
120 			if (info.ribbits.ownerOf(_tokenIds[i]) == address(this)) {
121 				info.ribbits.transferFrom(address(this), msg.sender, _tokenIds[i]);
122 				totalUnwrapped++;
123 			}
124 		}
125 		require(totalUnwrapped > 0);
126 		uint256 _cost = totalUnwrapped * 1e18;
127 		info.totalSupply -= _cost;
128 		info.users[msg.sender].balance -= _cost;
129 		emit Transfer(msg.sender, address(0x0), _cost);
130 	}
131 
132 	function transfer(address _to, uint256 _tokens) external returns (bool) {
133 		return _transfer(msg.sender, _to, _tokens);
134 	}
135 
136 	function approve(address _spender, uint256 _tokens) external returns (bool) {
137 		info.users[msg.sender].allowance[_spender] = _tokens;
138 		emit Approval(msg.sender, _spender, _tokens);
139 		return true;
140 	}
141 
142 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
143 		uint256 _allowance = allowance(_from, msg.sender);
144 		require(_allowance >= _tokens);
145 		if (_allowance != UINT_MAX) {
146 			info.users[_from].allowance[msg.sender] -= _tokens;
147 		}
148 		return _transfer(_from, _to, _tokens);
149 	}
150 
151 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
152 		_transfer(msg.sender, _to, _tokens);
153 		uint32 _size;
154 		assembly {
155 			_size := extcodesize(_to)
156 		}
157 		if (_size > 0) {
158 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
159 		}
160 		return true;
161 	}
162 	
163 
164 	function totalSupply() public view returns (uint256) {
165 		return info.totalSupply;
166 	}
167 
168 	function balanceOf(address _user) public view returns (uint256) {
169 		return info.users[_user].balance;
170 	}
171 
172 	function allowance(address _user, address _spender) public view returns (uint256) {
173 		return info.users[_user].allowance[_spender];
174 	}
175 
176 	function allInfoFor(address _user) external view returns (uint256 totalTokens, uint256 totalLPTokens, uint256 wethReserve, uint256 wrbtReserve, uint256 userRibbits, bool userApproved, uint256 userBalance, uint256 userLPBalance) {
177 		totalTokens = totalSupply();
178 		totalLPTokens = info.pair.totalSupply();
179 		(uint256 _res0, uint256 _res1, ) = info.pair.getReserves();
180 		wethReserve = info.weth0 ? _res0 : _res1;
181 		wrbtReserve = info.weth0 ? _res1 : _res0;
182 		userRibbits = info.ribbits.balanceOf(_user);
183 		userApproved = info.ribbits.isApprovedForAll(_user, address(this));
184 		userBalance = balanceOf(_user);
185 		userLPBalance = info.pair.balanceOf(_user);
186 	}
187 
188 
189 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
190 		require(balanceOf(_from) >= _tokens);
191 		info.users[_from].balance -= _tokens;
192 		info.users[_to].balance += _tokens;
193 		emit Transfer(_from, _to, _tokens);
194 		return true;
195 	}
196 }
197 
198 contract Ribbits {
199 
200 	uint256 constant private MAX_NAME_LENGTH = 32;
201 	uint256 constant private TOTAL_RIBBITS = 1000;
202 	uint256 constant private CLAIM_COST = 0.1 ether;
203 
204 	struct User {
205 		uint256[] list;
206 		mapping(address => bool) approved;
207 		mapping(uint256 => uint256) indexOf;
208 	}
209 
210 	struct Ribbit {
211 		bool claimed;
212 		address owner;
213 		address approved;
214 		string name;
215 	}
216 
217 	struct Info {
218 		mapping(uint256 => Ribbit) list;
219 		mapping(address => User) users;
220 		Metadata metadata;
221 		address owner;
222 	}
223 	Info private info;
224 
225 	mapping(bytes4 => bool) public supportsInterface;
226 
227 	string constant public compositeHash = "11df1dfb29760fdf721b68137825ebbf350a69f92ac50a922088f0240e62e0d3";
228 
229 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
230 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
231 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
232 
233 	event Rename(address indexed owner, uint256 indexed tokenId, string name);
234 
235 
236 	constructor() public {
237 		info.metadata = new Metadata();
238 		info.owner = msg.sender;
239 		supportsInterface[0x01ffc9a7] = true; // ERC-165
240 		supportsInterface[0x80ac58cd] = true; // ERC-721
241 		supportsInterface[0x5b5e139f] = true; // Metadata
242 		supportsInterface[0x780e9d63] = true; // Enumerable
243 
244 		// Initial Claims
245 		address _receiver = msg.sender;
246 		_claim(77,  _receiver);
247 		_claim(114, _receiver);
248 		_claim(168, _receiver);
249 		_claim(172, _receiver);
250 		_claim(173, _receiver);
251 		_claim(210, _receiver);
252 		_claim(275, _receiver);
253 		_claim(285, _receiver);
254 		_claim(595, _receiver);
255 		_claim(726, _receiver);
256 
257 		_receiver = 0xcb4BfcF57aee5e8ad825Cde1012fEe1cC62d8e4c;
258 		_claim(368, _receiver);
259 		_claim(737, _receiver);
260 		_claim(751, _receiver);
261 		_claim(895, _receiver);
262 		_claim(49,  _receiver);
263 		_claim(242, _receiver);
264 		_claim(391, _receiver);
265 
266 		_receiver = 0x8F83Eb7ABb2bCf57347298d9BF09A2d284190643;
267 		_claim(534, _receiver);
268 		_claim(729, _receiver);
269 		_claim(35,  _receiver);
270 		_claim(55,  _receiver);
271 		_claim(68,  _receiver);
272 		_claim(621, _receiver);
273 		_claim(796, _receiver);
274 		_claim(971, _receiver);
275 		_claim(167, _receiver);
276 		_claim(152, _receiver);
277 		_claim(202, _receiver);
278 		_claim(205, _receiver);
279 		_claim(221, _receiver);
280 		_claim(283, _receiver);
281 		_claim(299, _receiver);
282 		_claim(309, _receiver);
283 		_claim(325, _receiver);
284 		_claim(341, _receiver);
285 		_claim(367, _receiver);
286 		_claim(393, _receiver);
287 		_claim(405, _receiver);
288 		_claim(452, _receiver);
289 		_claim(485, _receiver);
290 		_claim(507, _receiver);
291 		_claim(526, _receiver);
292 		_claim(542, _receiver);
293 		_claim(609, _receiver);
294 		_claim(723, _receiver);
295 		_claim(500, _receiver);
296 		_claim(16,  _receiver);
297 		_claim(46,  _receiver);
298 		_claim(79,  _receiver);
299 
300 		_claim(822, 0xACE5BeedDDc24dec659eeEcb21A3C21F5576e3C9);
301 		_claim(934, 0xface14522b18BE412e9DB0E1570Be94Cb9af0A88);
302 		_claim(894, 0xFADE7bB65A1e06D11B3F099b225ddC7C8Ae65967);
303 		_claim(946, 0xC0015CfE8C0e00423E2D84853E5A9052EdcdF8b2);
304 		_claim(957, 0xce1179C2e69edBaCaB52485a75C0Ae4a979b0919);
305 		_claim(712, 0xea5e37c75383331a1de5b7f7f1a93Ef080b319Be);
306 		_claim(539, 0xD1CEbD1Ad772c8A6dD05eCdFA0ae776a9266032c);
307 		_claim(549, 0xFEED4873Ab0D642dD4b694EdA6FF90cD732fE4C9);
308 		_claim(364, 0xCafe59428b2946FBc128fd6C36cb1Ec1443AeD6C);
309 		_claim(166, 0xb01d89cb608b46a9EB697ee11e2df6313BCbEb20);
310 		_claim(547, 0x1eadc5E9A94e61BFe4819274aBBEE1e23805bA38);
311 		_claim(515, 0xF01D2ba4F31161Bb89e7Ab3cf443AaA38426dC65);
312 		_claim(612, 0xF00Da17Fd777Bf2ae536816C016fF1593F9CDDC3);
313 	}
314 
315 	function setOwner(address _owner) external {
316 		require(msg.sender == info.owner);
317 		info.owner = _owner;
318 	}
319 
320 	function setMetadata(Metadata _metadata) external {
321 		require(msg.sender == info.owner);
322 		info.metadata = _metadata;
323 	}
324 
325 	function ownerWithdraw() external {
326 		require(msg.sender == info.owner);
327 		uint256 _balance = address(this).balance;
328 		require(_balance > 0);
329 		msg.sender.transfer(_balance);
330 	}
331 
332 
333 	function claim(uint256 _tokenId) external payable {
334 		claimFor(_tokenId, msg.sender);
335 	}
336 
337 	function claimFor(uint256 _tokenId, address _receiver) public payable {
338 		uint256[] memory _tokenIds = new uint256[](1);
339 		address[] memory _receivers = new address[](1);
340 		_tokenIds[0] = _tokenId;
341 		_receivers[0] = _receiver;
342 		claimManyFor(_tokenIds, _receivers);
343 	}
344 
345 	function claimMany(uint256[] calldata _tokenIds) external payable returns (uint256) {
346 		uint256 _count = _tokenIds.length;
347 		address[] memory _receivers = new address[](_count);
348 		for (uint256 i = 0; i < _count; i++) {
349 			_receivers[i] = msg.sender;
350 		}
351 		return claimManyFor(_tokenIds, _receivers);
352 	}
353 
354 	function claimManyFor(uint256[] memory _tokenIds, address[] memory _receivers) public payable returns (uint256 totalClaimed) {
355 		uint256 _count = _tokenIds.length;
356 		require(_count > 0 && _count == _receivers.length);
357 		require(msg.value >= CLAIM_COST * _count);
358 		totalClaimed = 0;
359 		for (uint256 i = 0; i < _count; i++) {
360 			if (!getClaimed(_tokenIds[i])) {
361 				_claim(_tokenIds[i], _receivers[i]);
362 				totalClaimed++;
363 			}
364 		}
365 		require(totalClaimed > 0);
366 		uint256 _cost = CLAIM_COST * totalClaimed;
367 		if (msg.value > _cost) {
368 			msg.sender.transfer(msg.value - _cost);
369 		}
370 	}
371 
372 	function rename(uint256 _tokenId, string calldata _newName) external {
373 		require(bytes(_newName).length <= MAX_NAME_LENGTH);
374 		require(msg.sender == ownerOf(_tokenId));
375 		info.list[_tokenId].name = _newName;
376 		emit Rename(msg.sender, _tokenId, _newName);
377 	}
378 
379 	function approve(address _approved, uint256 _tokenId) external {
380 		require(msg.sender == ownerOf(_tokenId));
381 		info.list[_tokenId].approved = _approved;
382 		emit Approval(msg.sender, _approved, _tokenId);
383 	}
384 
385 	function setApprovalForAll(address _operator, bool _approved) external {
386 		info.users[msg.sender].approved[_operator] = _approved;
387 		emit ApprovalForAll(msg.sender, _operator, _approved);
388 	}
389 
390 	function transferFrom(address _from, address _to, uint256 _tokenId) external {
391 		_transfer(_from, _to, _tokenId);
392 	}
393 
394 	function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
395 		safeTransferFrom(_from, _to, _tokenId, "");
396 	}
397 
398 	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public {
399 		_transfer(_from, _to, _tokenId);
400 		uint32 _size;
401 		assembly {
402 			_size := extcodesize(_to)
403 		}
404 		if (_size > 0) {
405 			require(Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) == 0x150b7a02);
406 		}
407 	}
408 
409 
410 	function name() external view returns (string memory) {
411 		return info.metadata.name();
412 	}
413 
414 	function symbol() external view returns (string memory) {
415 		return info.metadata.symbol();
416 	}
417 
418 	function contractURI() external view returns (string memory) {
419 		return info.metadata.contractURI();
420 	}
421 
422 	function baseTokenURI() external view returns (string memory) {
423 		return info.metadata.baseTokenURI();
424 	}
425 
426 	function tokenURI(uint256 _tokenId) external view returns (string memory) {
427 		return info.metadata.tokenURI(_tokenId);
428 	}
429 
430 	function owner() public view returns (address) {
431 		return info.owner;
432 	}
433 
434 	function totalSupply() public pure returns (uint256) {
435 		return TOTAL_RIBBITS;
436 	}
437 
438 	function balanceOf(address _owner) public view returns (uint256) {
439 		return info.users[_owner].list.length;
440 	}
441 
442 	function ownerOf(uint256 _tokenId) public view returns (address) {
443 		require(_tokenId < totalSupply());
444 		return info.list[_tokenId].owner;
445 	}
446 
447 	function getApproved(uint256 _tokenId) public view returns (address) {
448 		require(_tokenId < totalSupply());
449 		return info.list[_tokenId].approved;
450 	}
451 
452 	function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
453 		return info.users[_owner].approved[_operator];
454 	}
455 
456 	function getName(uint256 _tokenId) public view returns (string memory) {
457 		require(_tokenId < totalSupply());
458 		return info.list[_tokenId].name;
459 	}
460 
461 	function getClaimed(uint256 _tokenId) public view returns (bool) {
462 		require(_tokenId < totalSupply());
463 		return info.list[_tokenId].claimed;
464 	}
465 
466 	function tokenByIndex(uint256 _index) external pure returns (uint256) {
467 		require(_index < totalSupply());
468 		return _index;
469 	}
470 
471 	function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
472 		require(_index < balanceOf(_owner));
473 		return info.users[_owner].list[_index];
474 	}
475 
476 	function getRibbit(uint256 _tokenId) public view returns (address tokenOwner, address approved, string memory tokenName, bool claimed) {
477 		return (ownerOf(_tokenId), getApproved(_tokenId), getName(_tokenId), getClaimed(_tokenId));
478 	}
479 
480 	function getRibbits(uint256[] memory _tokenIds) public view returns (address[] memory owners, address[] memory approveds, bool[] memory claimeds) {
481 		uint256 _length = _tokenIds.length;
482 		owners = new address[](_length);
483 		approveds = new address[](_length);
484 		claimeds = new bool[](_length);
485 		for (uint256 i = 0; i < _length; i++) {
486 			(owners[i], approveds[i], , claimeds[i]) = getRibbit(_tokenIds[i]);
487 		}
488 	}
489 
490 	function getRibbitsTable(uint256 _limit, uint256 _page, bool _isAsc) public view returns (uint256[] memory tokenIds, address[] memory owners, address[] memory approveds, bool[] memory claimeds, uint256 totalRibbits, uint256 totalPages) {
491 		require(_limit > 0);
492 		totalRibbits = totalSupply();
493 
494 		if (totalRibbits > 0) {
495 			totalPages = (totalRibbits / _limit) + (totalRibbits % _limit == 0 ? 0 : 1);
496 			require(_page < totalPages);
497 
498 			uint256 _offset = _limit * _page;
499 			if (_page == totalPages - 1 && totalRibbits % _limit != 0) {
500 				_limit = totalRibbits % _limit;
501 			}
502 
503 			tokenIds = new uint256[](_limit);
504 			for (uint256 i = 0; i < _limit; i++) {
505 				tokenIds[i] = (_isAsc ? _offset + i : totalRibbits - _offset - i - 1);
506 			}
507 		} else {
508 			totalPages = 0;
509 			tokenIds = new uint256[](0);
510 		}
511 		(owners, approveds, claimeds) = getRibbits(tokenIds);
512 	}
513 
514 	function getOwnerRibbitsTable(address _owner, uint256 _limit, uint256 _page, bool _isAsc) public view returns (uint256[] memory tokenIds, address[] memory approveds, uint256 totalRibbits, uint256 totalPages) {
515 		require(_limit > 0);
516 		totalRibbits = balanceOf(_owner);
517 
518 		if (totalRibbits > 0) {
519 			totalPages = (totalRibbits / _limit) + (totalRibbits % _limit == 0 ? 0 : 1);
520 			require(_page < totalPages);
521 
522 			uint256 _offset = _limit * _page;
523 			if (_page == totalPages - 1 && totalRibbits % _limit != 0) {
524 				_limit = totalRibbits % _limit;
525 			}
526 
527 			tokenIds = new uint256[](_limit);
528 			for (uint256 i = 0; i < _limit; i++) {
529 				tokenIds[i] = tokenOfOwnerByIndex(_owner, _isAsc ? _offset + i : totalRibbits - _offset - i - 1);
530 			}
531 		} else {
532 			totalPages = 0;
533 			tokenIds = new uint256[](0);
534 		}
535 		( , approveds, ) = getRibbits(tokenIds);
536 	}
537 
538 	function allClaimeds() external view returns (bool[] memory claimeds) {
539 		uint256 _length = totalSupply();
540 		claimeds = new bool[](_length);
541 		for (uint256 i = 0; i < _length; i++) {
542 			claimeds[i] = getClaimed(i);
543 		}
544 	}
545 
546 	function allInfoFor(address _owner) external view returns (uint256 supply, uint256 ownerBalance) {
547 		return (totalSupply(), balanceOf(_owner));
548 	}
549 
550 
551 	function _transfer(address _from, address _to, uint256 _tokenId) internal {
552 		(address _owner, address _approved, , ) = getRibbit(_tokenId);
553 		require(_from == _owner);
554 		require(msg.sender == _owner || msg.sender == _approved || isApprovedForAll(_owner, msg.sender));
555 
556 		info.list[_tokenId].owner = _to;
557 		if (_approved != address(0x0)) {
558 			info.list[_tokenId].approved = address(0x0);
559 			emit Approval(address(0x0), address(0x0), _tokenId);
560 		}
561 
562 		uint256 _index = info.users[_from].indexOf[_tokenId] - 1;
563 		uint256 _movedRibbit = info.users[_from].list[info.users[_from].list.length - 1];
564 		info.users[_from].list[_index] = _movedRibbit;
565 		info.users[_from].indexOf[_movedRibbit] = _index + 1;
566 		info.users[_from].list.length--;
567 		delete info.users[_from].indexOf[_tokenId];
568 		info.users[_to].indexOf[_tokenId] = info.users[_to].list.push(_tokenId);
569 		emit Transfer(_from, _to, _tokenId);
570 	}
571 
572 	function _claim(uint256 _tokenId, address _receiver) internal {
573 		require(!getClaimed(_tokenId));
574 		info.list[_tokenId].claimed = true;
575 		info.list[_tokenId].owner = _receiver;
576 		info.users[_receiver].indexOf[_tokenId] = info.users[_receiver].list.push(_tokenId);
577 		emit Transfer(address(0x0), _receiver, _tokenId);
578 	}
579 }