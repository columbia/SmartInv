1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.6;
3 
4 interface Receiver {
5 	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns (bytes4);
6 }
7 
8 contract Metadata {
9 	string public name = "Yat NFT";
10 	string public symbol = "Yats";
11 	function contractURI() external pure returns (string memory) {
12 		return "https://a.y.at/nft_transfers/contract/";
13 	}
14 	function baseTokenURI() public pure returns (string memory) {
15 		return "https://a.y.at/nft_transfers/metadata/";
16 	}
17 	function tokenURI(uint256 _tokenId) external pure returns (string memory) {
18 		bytes memory _base = bytes(baseTokenURI());
19 		uint256 _digits = 1;
20 		uint256 _n = _tokenId;
21 		while (_n > 9) {
22 			_n /= 10;
23 			_digits++;
24 		}
25 		bytes memory _uri = new bytes(_base.length + _digits);
26 		for (uint256 i = 0; i < _uri.length; i++) {
27 			if (i < _base.length) {
28 				_uri[i] = _base[i];
29 			} else {
30 				uint256 _dec = (_tokenId / (10**(_uri.length - i - 1))) % 10;
31 				_uri[i] = bytes1(uint8(_dec) + 48);
32 			}
33 		}
34 		return string(_uri);
35 	}
36 }
37 
38 contract YAT {
39 
40 	address constant private USE_GLOBAL_SIGNER = address(type(uint160).max);
41 
42 	struct User {
43 		uint256 balance;
44 		mapping(uint256 => uint256) list;
45 		mapping(address => bool) approved;
46 		mapping(uint256 => uint256) indexOf;
47 	}
48 
49 	struct Token {
50 		address owner;
51 		address cosigner;
52 		address approved;
53 		address pointsTo;
54 		address resolvesTo;
55 		string token;
56 		uint256 records;
57 		mapping(uint256 => bytes32) keys;
58 		mapping(bytes32 => string) values;
59 		mapping(bytes32 => uint256) indexOf;
60 		uint256 nonce;
61 	}
62 
63 	struct Info {
64 		uint256 totalSupply;
65 		mapping(uint256 => Token) list;
66 		mapping(bytes32 => uint256) idOf;
67 		mapping(bytes32 => string) dictionary;
68 		mapping(address => string) resolve;
69 		mapping(address => User) users;
70 		Metadata metadata;
71 		address owner;
72 		address signer;
73 	}
74 	Info private info;
75 
76 	mapping(bytes4 => bool) public supportsInterface;
77 
78 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
79 	event Transfer(address indexed from, address indexed to, bytes32 indexed tokenHash, string token);
80 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
81 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
82 
83 	event Mint(bytes32 indexed tokenHash, uint256 indexed tokenId, address indexed account, string token);
84 	event Burn(bytes32 indexed tokenHash, uint256 indexed tokenId, address indexed account, string token);
85 	event RecordUpdated(bytes32 indexed tokenHash, address indexed manager, bytes32 indexed keyHash, string token, string key, string value);
86 	event RecordAdded(bytes32 indexed tokenHash, address indexed manager, bytes32 indexed keyHash, string token, string key);
87 	event RecordDeleted(bytes32 indexed tokenHash, address indexed manager, bytes32 indexed keyHash, string token, string key);
88 
89 
90 	modifier _onlyOwner() {
91 		require(msg.sender == owner());
92 		_;
93 	}
94 
95 	modifier _onlyTokenOwner(uint256 _tokenId) {
96 		require(msg.sender == ownerOf(_tokenId));
97 		_;
98 	}
99 
100 	modifier _onlyTokenOwnerOrCosigner(uint256 _tokenId) {
101 		require(msg.sender == ownerOf(_tokenId) || msg.sender == cosignerOf(_tokenId));
102 		_;
103 	}
104 
105 
106 	constructor(address _signer) {
107 		info.metadata = new Metadata();
108 		info.owner = msg.sender;
109 		info.signer = _signer;
110 		supportsInterface[0x01ffc9a7] = true; // ERC-165
111 		supportsInterface[0x80ac58cd] = true; // ERC-721
112 		supportsInterface[0x5b5e139f] = true; // Metadata
113 		supportsInterface[0x780e9d63] = true; // Enumerable
114 	}
115 
116 	function setOwner(address _owner) external _onlyOwner {
117 		info.owner = _owner;
118 	}
119 
120 	function setSigner(address _signer) external _onlyOwner {
121 		info.signer = _signer;
122 	}
123 
124 	function setMetadata(Metadata _metadata) external _onlyOwner {
125 		info.metadata = _metadata;
126 	}
127 
128 
129 	function mint(string calldata _token, address _account, uint256 _expiry, bytes memory _signature) external {
130 		require(block.timestamp < _expiry);
131 		require(_verifyMint(_token, _account, _expiry, _signature));
132 		_mint(_token, _account);
133 	}
134 
135 	/**
136      *  "Soft-burns" the NFT by transferring the token to the contract address.
137     **/
138 	function burn(uint256 _tokenId) external _onlyTokenOwner(_tokenId) {
139 		_transfer(msg.sender, address(this), _tokenId);
140 		emit Burn(hashOf(tokenOf(_tokenId)), _tokenId, msg.sender, tokenOf(_tokenId));
141 	}
142 	
143 	function setCosigner(address _cosigner, uint256 _tokenId) public _onlyTokenOwner(_tokenId) {
144 		info.list[_tokenId].cosigner = _cosigner;
145 	}
146 
147 	function resetCosigner(uint256 _tokenId) external {
148 		setCosigner(USE_GLOBAL_SIGNER, _tokenId);
149 	}
150 
151 	function revokeCosigner(uint256 _tokenId) external {
152 		setCosigner(address(0x0), _tokenId);
153 	}
154 	
155 	function setPointsTo(address _pointsTo, uint256 _tokenId) public _onlyTokenOwner(_tokenId) {
156 		info.list[_tokenId].pointsTo = _pointsTo;
157 	}
158 	
159 	function resolveTo(address _resolvesTo, uint256 _tokenId) public _onlyTokenOwner(_tokenId) {
160 		_updateResolvesTo(_resolvesTo, _tokenId);
161 	}
162 
163 	function unresolve(uint256 _tokenId) external {
164 		resolveTo(address(0x0), _tokenId);
165 	}
166 
167 	function updateRecord(uint256 _tokenId, string memory _key, string memory _value, bytes memory _signature) external {
168 		require(_verifyRecordUpdate(_tokenId, _key, _value, info.list[_tokenId].nonce++, _signature));
169 		_updateRecord(_tokenId, _key, _value);
170 	}
171 
172 	function updateRecord(uint256 _tokenId, string memory _key, string memory _value) public _onlyTokenOwnerOrCosigner(_tokenId) {
173 		_updateRecord(_tokenId, _key, _value);
174 	}
175 
176 	function deleteRecord(uint256 _tokenId, string memory _key) external {
177 		updateRecord(_tokenId, _key, "");
178 	}
179 
180 	function deleteAllRecords(uint256 _tokenId) external _onlyTokenOwnerOrCosigner(_tokenId) {
181 		_deleteAllRecords(_tokenId);
182 	}
183 	
184 	function approve(address _approved, uint256 _tokenId) external _onlyTokenOwner(_tokenId) {
185 		info.list[_tokenId].approved = _approved;
186 		emit Approval(msg.sender, _approved, _tokenId);
187 	}
188 
189 	function setApprovalForAll(address _operator, bool _approved) external {
190 		info.users[msg.sender].approved[_operator] = _approved;
191 		emit ApprovalForAll(msg.sender, _operator, _approved);
192 	}
193 
194 	function transferFrom(address _from, address _to, uint256 _tokenId) external {
195 		_transfer(_from, _to, _tokenId);
196 	}
197 
198 	function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
199 		safeTransferFrom(_from, _to, _tokenId, "");
200 	}
201 
202 	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public {
203 		_transfer(_from, _to, _tokenId);
204 		uint32 _size;
205 		assembly {
206 			_size := extcodesize(_to)
207 		}
208 		if (_size > 0) {
209 			require(Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) == 0x150b7a02);
210 		}
211 	}
212 
213 
214 	function name() external view returns (string memory) {
215 		return info.metadata.name();
216 	}
217 
218 	function symbol() external view returns (string memory) {
219 		return info.metadata.symbol();
220 	}
221 
222 	function contractURI() external view returns (string memory) {
223 		return info.metadata.contractURI();
224 	}
225 
226 	function baseTokenURI() external view returns (string memory) {
227 		return info.metadata.baseTokenURI();
228 	}
229 
230 	function tokenURI(uint256 _tokenId) external view returns (string memory) {
231 		return info.metadata.tokenURI(_tokenId);
232 	}
233 
234 	function owner() public view returns (address) {
235 		return info.owner;
236 	}
237 
238 	function signer() public view returns (address) {
239 		return info.signer;
240 	}
241 
242 	function totalSupply() public view returns (uint256) {
243 		return info.totalSupply;
244 	}
245 
246 	function balanceOf(address _owner) public view returns (uint256) {
247 		return info.users[_owner].balance;
248 	}
249 
250 	function resolve(address _account) public view returns (string memory) {
251 		return info.resolve[_account];
252 	}
253 
254 	function reverseResolve(string memory _token) public view returns (address) {
255 		return info.list[idOf(_token)].resolvesTo;
256 	}
257 
258 	function hashOf(string memory _token) public pure returns (bytes32) {
259 		return keccak256(abi.encodePacked(_token));
260 	}
261 
262 	function idOf(string memory _token) public view returns (uint256) {
263 		bytes32 _hash = hashOf(_token);
264 		require(info.idOf[_hash] != 0);
265 		return info.idOf[_hash] - 1;
266 	}
267 
268 	function tokenOf(uint256 _tokenId) public view returns (string memory) {
269 		require(_tokenId < totalSupply());
270 		return info.list[_tokenId].token;
271 	}
272 
273 	function ownerOf(uint256 _tokenId) public view returns (address) {
274 		require(_tokenId < totalSupply());
275 		return info.list[_tokenId].owner;
276 	}
277 
278 	function cosignerOf(uint256 _tokenId) public view returns (address) {
279 		require(_tokenId < totalSupply());
280 		address _cosigner = info.list[_tokenId].cosigner;
281 		if (_cosigner == USE_GLOBAL_SIGNER) {
282 			_cosigner = signer();
283 		}
284 		return _cosigner;
285 	}
286 
287 	function pointsTo(uint256 _tokenId) public view returns (address) {
288 		require(_tokenId < totalSupply());
289 		return info.list[_tokenId].pointsTo;
290 	}
291 
292 	function nonceOf(uint256 _tokenId) public view returns (uint256) {
293 		require(_tokenId < totalSupply());
294 		return info.list[_tokenId].nonce;
295 	}
296 
297 	function recordsOf(uint256 _tokenId) public view returns (uint256) {
298 		require(_tokenId < totalSupply());
299 		return info.list[_tokenId].records;
300 	}
301 
302 	function getApproved(uint256 _tokenId) public view returns (address) {
303 		require(_tokenId < totalSupply());
304 		return info.list[_tokenId].approved;
305 	}
306 
307 	function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
308 		return info.users[_owner].approved[_operator];
309 	}
310 
311 	function tokenByIndex(uint256 _index) public view returns (uint256) {
312 		require(_index < totalSupply());
313 		return _index;
314 	}
315 
316 	function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
317 		require(_index < balanceOf(_owner));
318 		return info.users[_owner].list[_index];
319 	}
320 
321 	function getKey(bytes32 _hash) public view returns (string memory) {
322 		return info.dictionary[_hash];
323 	}
324 
325 	function getRecord(string memory _token, string memory _key) public view returns (string memory) {
326 		return getRecord(idOf(_token), _key);
327 	}
328 
329 	function getRecord(uint256 _tokenId, string memory _key) public view returns (string memory) {
330 		bytes32 _hash = keccak256(abi.encodePacked(_key));
331 		return getRecord(_tokenId, _hash);
332 	}
333 
334 	function getRecord(uint256 _tokenId, bytes32 _hash) public view returns (string memory) {
335 		require(_tokenId < totalSupply());
336 		return info.list[_tokenId].values[_hash];
337 	}
338 
339 	function getFullRecord(uint256 _tokenId, bytes32 _hash) public view returns (string memory, string memory) {
340 		return (getKey(_hash), getRecord(_tokenId, _hash));
341 	}
342 
343 	function getRecords(uint256 _tokenId, bytes32[] memory _hashes) public view returns (bytes32[] memory values, bool[] memory trimmed) {
344 		require(_tokenId < totalSupply());
345 		uint256 _length = _hashes.length;
346 		values = new bytes32[](_length);
347 		trimmed = new bool[](_length);
348 		for (uint256 i = 0; i < _length; i++) {
349 			string memory _value = info.list[_tokenId].values[_hashes[i]];
350 			values[i] = _stringToBytes32(_value);
351 			trimmed[i] = bytes(_value).length > 32;
352 		}
353 	}
354 
355 	function getRecordsTable(uint256 _tokenId, uint256 _limit, uint256 _page, bool _isAsc) public view returns (bytes32[] memory hashes, bytes32[] memory keys, bool[] memory keysTrimmed, bytes32[] memory values, bool[] memory valuesTrimmed, uint256 totalRecords, uint256 totalPages) {
356 		require(_limit > 0);
357 		totalRecords = recordsOf(_tokenId);
358 
359 		if (totalRecords > 0) {
360 			totalPages = (totalRecords / _limit) + (totalRecords % _limit == 0 ? 0 : 1);
361 			require(_page < totalPages);
362 
363 			uint256 _offset = _limit * _page;
364 			if (_page == totalPages - 1 && totalRecords % _limit != 0) {
365 				_limit = totalRecords % _limit;
366 			}
367 
368 			hashes = new bytes32[](_limit);
369 			keys = new bytes32[](_limit);
370 			keysTrimmed = new bool[](_limit);
371 			for (uint256 i = 0; i < _limit; i++) {
372 				hashes[i] = info.list[_tokenId].keys[_isAsc ? _offset + i : totalRecords - _offset - i - 1];
373 				string memory _key = getKey(hashes[i]);
374 				keys[i] = _stringToBytes32(_key);
375 				keysTrimmed[i] = bytes(_key).length > 32;
376 			}
377 		} else {
378 			totalPages = 0;
379 			hashes = new bytes32[](0);
380 			keys = new bytes32[](0);
381 			keysTrimmed = new bool[](0);
382 		}
383 		(values, valuesTrimmed) = getRecords(_tokenId, hashes);
384 	}
385 
386 	function getYAT(string memory _token) public view returns (uint256 tokenId, address tokenOwner, address tokenCosigner, address pointer, address approved, uint256 nonce, uint256 records) {
387 		tokenId = idOf(_token);
388 		( , tokenOwner, tokenCosigner, pointer, approved, nonce, records) = getYAT(tokenId);
389 	}
390 
391 	function getYAT(uint256 _tokenId) public view returns (string memory token, address tokenOwner, address tokenCosigner, address pointer, address approved, uint256 nonce, uint256 records) {
392 		return (tokenOf(_tokenId), ownerOf(_tokenId), cosignerOf(_tokenId), pointsTo(_tokenId), getApproved(_tokenId), nonceOf(_tokenId), recordsOf(_tokenId));
393 	}
394 
395 	function getYATs(uint256[] memory _tokenIds) public view returns (bytes32[] memory tokens, address[] memory owners, address[] memory cosigners, address[] memory pointers, address[] memory approveds) {
396 		uint256 _length = _tokenIds.length;
397 		tokens = new bytes32[](_length);
398 		owners = new address[](_length);
399 		cosigners = new address[](_length);
400 		pointers = new address[](_length);
401 		approveds = new address[](_length);
402 		for (uint256 i = 0; i < _length; i++) {
403 			string memory _token;
404 			(_token, owners[i], cosigners[i], pointers[i], approveds[i], , ) = getYAT(_tokenIds[i]);
405 			tokens[i] = _stringToBytes32(_token);
406 		}
407 	}
408 
409 	function getYATsTable(uint256 _limit, uint256 _page, bool _isAsc) public view returns (uint256[] memory tokenIds, bytes32[] memory tokens, address[] memory owners, address[] memory cosigners, address[] memory pointers, address[] memory approveds, uint256 totalYATs, uint256 totalPages) {
410 		require(_limit > 0);
411 		totalYATs = totalSupply();
412 
413 		if (totalYATs > 0) {
414 			totalPages = (totalYATs / _limit) + (totalYATs % _limit == 0 ? 0 : 1);
415 			require(_page < totalPages);
416 
417 			uint256 _offset = _limit * _page;
418 			if (_page == totalPages - 1 && totalYATs % _limit != 0) {
419 				_limit = totalYATs % _limit;
420 			}
421 
422 			tokenIds = new uint256[](_limit);
423 			for (uint256 i = 0; i < _limit; i++) {
424 				tokenIds[i] = tokenByIndex(_isAsc ? _offset + i : totalYATs - _offset - i - 1);
425 			}
426 		} else {
427 			totalPages = 0;
428 			tokenIds = new uint256[](0);
429 		}
430 		(tokens, owners, cosigners, pointers, approveds) = getYATs(tokenIds);
431 	}
432 
433 	function getOwnerYATsTable(address _owner, uint256 _limit, uint256 _page, bool _isAsc) public view returns (uint256[] memory tokenIds, bytes32[] memory tokens, address[] memory cosigners, address[] memory pointers, address[] memory approveds, uint256 totalYATs, uint256 totalPages) {
434 		require(_limit > 0);
435 		totalYATs = balanceOf(_owner);
436 
437 		if (totalYATs > 0) {
438 			totalPages = (totalYATs / _limit) + (totalYATs % _limit == 0 ? 0 : 1);
439 			require(_page < totalPages);
440 
441 			uint256 _offset = _limit * _page;
442 			if (_page == totalPages - 1 && totalYATs % _limit != 0) {
443 				_limit = totalYATs % _limit;
444 			}
445 
446 			tokenIds = new uint256[](_limit);
447 			for (uint256 i = 0; i < _limit; i++) {
448 				tokenIds[i] = tokenOfOwnerByIndex(_owner, _isAsc ? _offset + i : totalYATs - _offset - i - 1);
449 			}
450 		} else {
451 			totalPages = 0;
452 			tokenIds = new uint256[](0);
453 		}
454 		(tokens, , cosigners, pointers, approveds) = getYATs(tokenIds);
455 	}
456 
457 	function allInfoFor(address _owner) external view returns (uint256 supply, uint256 ownerBalance) {
458 		return (totalSupply(), balanceOf(_owner));
459 	}
460 
461 
462 	function _mint(string memory _token, address _account) internal {
463 		uint256 _tokenId;
464 		bytes32 _hash = hashOf(_token);
465 		if (info.idOf[_hash] == 0) {
466 			_tokenId = info.totalSupply++;
467 			info.idOf[_hash] = _tokenId + 1;
468 			Token storage _newToken = info.list[_tokenId];
469 			_newToken.owner = _account;
470 			_newToken.cosigner = USE_GLOBAL_SIGNER;
471 			_newToken.token = _token;
472 			uint256 _index = info.users[_account].balance++;
473 			info.users[_account].indexOf[_tokenId] = _index + 1;
474 			info.users[_account].list[_index] = _tokenId;
475 			emit Transfer(address(0x0), _account, _tokenId);
476 			emit Transfer(address(0x0), _account, _hash, _token);
477 		} else {
478 			_tokenId = idOf(_token);
479 			info.list[_tokenId].approved = msg.sender;
480 			_transfer(address(this), _account, _tokenId);
481 		}
482 		emit Mint(_hash, _tokenId, _account, _token);
483 	}
484 	
485 	function _transfer(address _from, address _to, uint256 _tokenId) internal {
486 		address _owner = ownerOf(_tokenId);
487 		address _approved = getApproved(_tokenId);
488 		require(_from == _owner);
489 		require(msg.sender == _owner || msg.sender == _approved || isApprovedForAll(_owner, msg.sender));
490 
491 		info.list[_tokenId].owner = _to;
492 		info.list[_tokenId].cosigner = USE_GLOBAL_SIGNER;
493 		info.list[_tokenId].pointsTo = _to;
494 		if (_approved != address(0x0)) {
495 			info.list[_tokenId].approved = address(0x0);
496 			emit Approval(_to, address(0x0), _tokenId);
497 		}
498 		_updateResolvesTo(address(0x0), _tokenId);
499 		_deleteAllRecords(_tokenId);
500 
501 		uint256 _index = info.users[_from].indexOf[_tokenId] - 1;
502 		uint256 _moved = info.users[_from].list[info.users[_from].balance - 1];
503 		info.users[_from].list[_index] = _moved;
504 		info.users[_from].indexOf[_moved] = _index + 1;
505 		info.users[_from].balance--;
506 		delete info.users[_from].indexOf[_tokenId];
507 		uint256 _newIndex = info.users[_to].balance++;
508 		info.users[_to].indexOf[_tokenId] = _newIndex + 1;
509 		info.users[_to].list[_newIndex] = _tokenId;
510 		emit Transfer(_from, _to, _tokenId);
511 		emit Transfer(_from, _to, hashOf(tokenOf(_tokenId)), tokenOf(_tokenId));
512 	}
513 
514 	function _updateResolvesTo(address _resolvesTo, uint256 _tokenId) internal {
515 		if (_resolvesTo == address(0x0)) {
516 			delete info.resolve[info.list[_tokenId].resolvesTo];
517 			info.list[_tokenId].resolvesTo = _resolvesTo;
518 		} else {
519 			require(bytes(resolve(_resolvesTo)).length == 0);
520 			require(info.list[_tokenId].resolvesTo == address(0x0));
521 			info.resolve[_resolvesTo] = tokenOf(_tokenId);
522 			info.list[_tokenId].resolvesTo = _resolvesTo;
523 		}
524 	}
525 
526 	function _updateRecord(uint256 _tokenId, string memory _key, string memory _value) internal {
527 		require(bytes(_key).length > 0);
528 		bytes32 _hash = keccak256(abi.encodePacked(_key));
529 		if (bytes(getKey(_hash)).length == 0) {
530 			info.dictionary[_hash] = _key;
531 		}
532 
533 		Token storage _token = info.list[_tokenId];
534 		if (bytes(_value).length == 0) {
535 			_deleteRecord(_tokenId, _key, _hash);
536 		} else {
537 			if (_token.indexOf[_hash] == 0) {
538 				uint256 _index = _token.records++;
539 				_token.indexOf[_hash] = _index + 1;
540 				_token.keys[_index] = _hash;
541 				emit RecordAdded(hashOf(tokenOf(_tokenId)), msg.sender, hashOf(_key), tokenOf(_tokenId), _key);
542 			}
543 			_token.values[_hash] = _value;
544 		}
545 		emit RecordUpdated(hashOf(tokenOf(_tokenId)), msg.sender, hashOf(_key), tokenOf(_tokenId), _key, _value);
546 	}
547 
548 	function _deleteRecord(uint256 _tokenId, string memory _key, bytes32 _hash) internal {
549 		Token storage _token = info.list[_tokenId];
550 		require(_token.indexOf[_hash] != 0);
551 		uint256 _index = _token.indexOf[_hash] - 1;
552 		bytes32 _moved = _token.keys[_token.records - 1];
553 		_token.keys[_index] = _moved;
554 		_token.indexOf[_moved] = _index + 1;
555 		_token.records--;
556 		delete _token.indexOf[_hash];
557 		delete _token.values[_hash];
558 		emit RecordDeleted(hashOf(tokenOf(_tokenId)), msg.sender, hashOf(_key), tokenOf(_tokenId), _key);
559 	}
560 
561 	function _deleteAllRecords(uint256 _tokenId) internal {
562 		Token storage _token = info.list[_tokenId];
563 		while (_token.records > 0) {
564 			bytes32 _hash = _token.keys[_token.records - 1];
565 			_deleteRecord(_tokenId, getKey(_hash), _hash);
566 		}
567 	}
568 
569 
570 	function _getEthSignedMessageHash(bytes32 _messageHash) internal pure returns (bytes32) {
571 		return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
572 	}
573 
574 	function _splitSignature(bytes memory _signature) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
575 		require(_signature.length == 65);
576 		assembly {
577 			r := mload(add(_signature, 32))
578 			s := mload(add(_signature, 64))
579 			v := byte(0, mload(add(_signature, 96)))
580 		}
581 	}
582 
583 	function _recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) internal pure returns (address) {
584 		(bytes32 r, bytes32 s, uint8 v) = _splitSignature(_signature);
585 		return ecrecover(_ethSignedMessageHash, v, r, s);
586 	}
587 
588 	function _verifyMint(string calldata _token, address _account, uint256 _expiry, bytes memory _signature) internal view returns (bool) {
589 		bytes32 _hash = keccak256(abi.encodePacked("yatNFT", _token, _account, _expiry));
590 		return _recoverSigner(_getEthSignedMessageHash(_hash), _signature) == signer();
591 	}
592 
593 	function _verifyRecordUpdate(uint256 _tokenId, string memory _key, string memory _value, uint256 _nonce, bytes memory _signature) internal view returns (bool) {
594 		bytes32 _hash = keccak256(abi.encodePacked(_tokenId, _key, _value, _nonce));
595 		address _signer = _recoverSigner(_getEthSignedMessageHash(_hash), _signature);
596 		return _signer == ownerOf(_tokenId) || _signer == cosignerOf(_tokenId);
597 	}
598 
599 	function _stringToBytes32(string memory _in) internal pure returns (bytes32 out) {
600 		if (bytes(_in).length == 0) {
601 			return 0x0;
602 		}
603 		assembly {
604 			out := mload(add(_in, 32))
605 		}
606 	}
607 }