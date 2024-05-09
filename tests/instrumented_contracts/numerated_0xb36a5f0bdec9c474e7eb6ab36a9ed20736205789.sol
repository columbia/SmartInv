1 /*
2 
3  ██████╗ ███████╗████████╗
4 ██╔═══██╗██╔════╝╚══██╔══╝
5 ██║   ██║███████╗   ██║   
6 ██║   ██║╚════██║   ██║   
7 ╚██████╔╝███████║   ██║   
8  ╚═════╝ ╚══════╝   ╚═╝    
9 
10 Opensea Traders
11 An ERC-20 and NFT airdrop for everyone that traded via Opensea in Q1 2021.
12 
13 Website: https://openseatraders.io/
14 Created by sol_dev
15 
16 */
17 pragma solidity ^0.5.17;
18 
19 interface Receiver {
20 	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns (bytes4);
21 }
22 
23 interface Callable {
24 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
25 }
26 
27 interface Router {
28 	function WETH() external pure returns (address);
29 	function factory() external pure returns (address);
30 }
31 
32 interface Factory {
33 	function createPair(address, address) external returns (address);
34 }
35 
36 interface Pair {
37 	function token0() external view returns (address);
38 	function totalSupply() external view returns (uint256);
39 	function balanceOf(address) external view returns (uint256);
40 	function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
41 }
42 
43 contract Metadata {
44 	string public name = "Opensea Traders NFT";
45 	string public symbol = "OSTNFT";
46 	function contractURI() external pure returns (string memory) {
47 		return "https://api.openseatraders.io/metadata";
48 	}
49 	function baseTokenURI() public pure returns (string memory) {
50 		return "https://api.openseatraders.io/token/";
51 	}
52 	function tokenURI(uint256 _tokenId) external pure returns (string memory) {
53 		bytes memory _base = bytes(baseTokenURI());
54 		uint256 _digits = 1;
55 		uint256 _n = _tokenId;
56 		while (_n > 9) {
57 			_n /= 10;
58 			_digits++;
59 		}
60 		bytes memory _uri = new bytes(_base.length + _digits);
61 		for (uint256 i = 0; i < _uri.length; i++) {
62 			if (i < _base.length) {
63 				_uri[i] = _base[i];
64 			} else {
65 				uint256 _dec = (_tokenId / (10**(_uri.length - i - 1))) % 10;
66 				_uri[i] = byte(uint8(_dec) + 48);
67 			}
68 		}
69 		return string(_uri);
70 	}
71 }
72 
73 contract OST {
74 
75 	uint256 constant private UINT_MAX = uint256(-1);
76 
77 	string constant public name = "Opensea Traders";
78 	string constant public symbol = "OST";
79 	uint8 constant public decimals = 18;
80 
81 	struct User {
82 		uint256 balance;
83 		mapping(address => uint256) allowance;
84 	}
85 
86 	struct Info {
87 		uint256 totalSupply;
88 		mapping(address => User) users;
89 		Router router;
90 		Pair pair;
91 		address controller;
92 		bool weth0;
93 	}
94 	Info private info;
95 
96 
97 	event Transfer(address indexed from, address indexed to, uint256 tokens);
98 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
99 
100 
101 	constructor() public {
102 		info.router = Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
103 		info.pair = Pair(Factory(info.router.factory()).createPair(info.router.WETH(), address(this)));
104 		info.weth0 = info.pair.token0() == info.router.WETH();
105 		info.controller = msg.sender;
106 	}
107 
108 	function mint(address _receiver, uint256 _amount) external {
109 		require(msg.sender == info.controller);
110 		info.totalSupply += _amount;
111 		info.users[_receiver].balance += _amount;
112 		emit Transfer(address(0x0), _receiver, _amount);
113 	}
114 
115 
116 	function transfer(address _to, uint256 _tokens) external returns (bool) {
117 		return _transfer(msg.sender, _to, _tokens);
118 	}
119 
120 	function approve(address _spender, uint256 _tokens) external returns (bool) {
121 		info.users[msg.sender].allowance[_spender] = _tokens;
122 		emit Approval(msg.sender, _spender, _tokens);
123 		return true;
124 	}
125 
126 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
127 		uint256 _allowance = allowance(_from, msg.sender);
128 		require(_allowance >= _tokens);
129 		if (_allowance != UINT_MAX) {
130 			info.users[_from].allowance[msg.sender] -= _tokens;
131 		}
132 		return _transfer(_from, _to, _tokens);
133 	}
134 
135 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
136 		_transfer(msg.sender, _to, _tokens);
137 		uint32 _size;
138 		assembly {
139 			_size := extcodesize(_to)
140 		}
141 		if (_size > 0) {
142 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
143 		}
144 		return true;
145 	}
146 	
147 
148 	function totalSupply() public view returns (uint256) {
149 		return info.totalSupply;
150 	}
151 
152 	function balanceOf(address _user) public view returns (uint256) {
153 		return info.users[_user].balance;
154 	}
155 
156 	function allowance(address _user, address _spender) public view returns (uint256) {
157 		return info.users[_user].allowance[_spender];
158 	}
159 
160 	function allInfoFor(address _user) external view returns (uint256 totalTokens, uint256 totalLPTokens, uint256 wethReserve, uint256 ostReserve, uint256 userBalance, uint256 userLPBalance) {
161 		totalTokens = totalSupply();
162 		totalLPTokens = info.pair.totalSupply();
163 		(uint256 _res0, uint256 _res1, ) = info.pair.getReserves();
164 		wethReserve = info.weth0 ? _res0 : _res1;
165 		ostReserve = info.weth0 ? _res1 : _res0;
166 		userBalance = balanceOf(_user);
167 		userLPBalance = info.pair.balanceOf(_user);
168 	}
169 
170 
171 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
172 		require(balanceOf(_from) >= _tokens);
173 		info.users[_from].balance -= _tokens;
174 		info.users[_to].balance += _tokens;
175 		emit Transfer(_from, _to, _tokens);
176 		return true;
177 	}
178 }
179 
180 contract OpenseaTraders {
181 
182 	struct User {
183 		uint256[] list;
184 		mapping(address => bool) approved;
185 		mapping(uint256 => uint256) indexOf;
186 	}
187 
188 	struct Token {
189 		address owner;
190 		address approved;
191 	}
192 
193 	struct Info {
194 		bytes32 merkleRoot;
195 		uint256 totalSupply;
196 		mapping(uint256 => uint256) claimedBitMap;
197 		mapping(uint256 => Token) list;
198 		mapping(address => User) users;
199 		OST ost;
200 		Metadata metadata;
201 		address owner;
202 	}
203 	Info private info;
204 
205 	mapping(bytes4 => bool) public supportsInterface;
206 
207 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
208 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
209 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
210 
211 	event Claimed(uint256 indexed index, address indexed account, uint256 indexed tokenId);
212 
213 
214 	constructor(bytes32 _merkleRoot) public {
215 		info.ost = new OST();
216 		info.metadata = new Metadata();
217 		info.owner = msg.sender;
218 		info.merkleRoot = _merkleRoot;
219 		supportsInterface[0x01ffc9a7] = true; // ERC-165
220 		supportsInterface[0x80ac58cd] = true; // ERC-721
221 		supportsInterface[0x5b5e139f] = true; // Metadata
222 		supportsInterface[0x780e9d63] = true; // Enumerable
223 
224 		// Developer Bonus
225 		info.ost.mint(msg.sender, 1e22); // 10,000 OST
226 		_mint(msg.sender);
227 	}
228 
229 	function setOwner(address _owner) external {
230 		require(msg.sender == info.owner);
231 		info.owner = _owner;
232 	}
233 
234 	function setMetadata(Metadata _metadata) external {
235 		require(msg.sender == info.owner);
236 		info.metadata = _metadata;
237 	}
238 
239 
240 	function claim(uint256 _index, address _account, uint256 _amount, bytes32[] calldata _merkleProof) external {
241 		require(!isClaimed(_index));
242 		bytes32 _node = keccak256(abi.encodePacked(_index, _account, _amount));
243 		require(_verify(_merkleProof, _node));
244 		uint256 _claimedWordIndex = _index / 256;
245 		uint256 _claimedBitIndex = _index % 256;
246 		info.claimedBitMap[_claimedWordIndex] = info.claimedBitMap[_claimedWordIndex] | (1 << _claimedBitIndex);
247 		info.ost.mint(_account, _amount);
248 		uint256 _tokenId = _mint(_account);
249 		emit Claimed(_index, _account, _tokenId);
250 	}
251 	
252 	function approve(address _approved, uint256 _tokenId) external {
253 		require(msg.sender == ownerOf(_tokenId));
254 		info.list[_tokenId].approved = _approved;
255 		emit Approval(msg.sender, _approved, _tokenId);
256 	}
257 
258 	function setApprovalForAll(address _operator, bool _approved) external {
259 		info.users[msg.sender].approved[_operator] = _approved;
260 		emit ApprovalForAll(msg.sender, _operator, _approved);
261 	}
262 
263 	function transferFrom(address _from, address _to, uint256 _tokenId) external {
264 		_transfer(_from, _to, _tokenId);
265 	}
266 
267 	function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
268 		safeTransferFrom(_from, _to, _tokenId, "");
269 	}
270 
271 	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public {
272 		_transfer(_from, _to, _tokenId);
273 		uint32 _size;
274 		assembly {
275 			_size := extcodesize(_to)
276 		}
277 		if (_size > 0) {
278 			require(Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) == 0x150b7a02);
279 		}
280 	}
281 
282 
283 	function name() external view returns (string memory) {
284 		return info.metadata.name();
285 	}
286 
287 	function symbol() external view returns (string memory) {
288 		return info.metadata.symbol();
289 	}
290 
291 	function contractURI() external view returns (string memory) {
292 		return info.metadata.contractURI();
293 	}
294 
295 	function baseTokenURI() external view returns (string memory) {
296 		return info.metadata.baseTokenURI();
297 	}
298 
299 	function tokenURI(uint256 _tokenId) external view returns (string memory) {
300 		return info.metadata.tokenURI(_tokenId);
301 	}
302 
303 	function ostAddress() external view returns (address) {
304 		return address(info.ost);
305 	}
306 
307 	function owner() public view returns (address) {
308 		return info.owner;
309 	}
310 
311 	function totalSupply() public view returns (uint256) {
312 		return info.totalSupply;
313 	}
314 
315 	function balanceOf(address _owner) public view returns (uint256) {
316 		return info.users[_owner].list.length;
317 	}
318 
319 	function ownerOf(uint256 _tokenId) public view returns (address) {
320 		require(_tokenId != 0 && _tokenId <= totalSupply());
321 		return info.list[_tokenId].owner;
322 	}
323 
324 	function getApproved(uint256 _tokenId) public view returns (address) {
325 		require(_tokenId != 0 && _tokenId <= totalSupply());
326 		return info.list[_tokenId].approved;
327 	}
328 
329 	function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
330 		return info.users[_owner].approved[_operator];
331 	}
332 
333 	function tokenByIndex(uint256 _index) public view returns (uint256) {
334 		require(_index < totalSupply());
335 		return _index;
336 	}
337 
338 	function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
339 		require(_index < balanceOf(_owner));
340 		return info.users[_owner].list[_index];
341 	}
342 
343 	function isClaimed(uint256 _index) public view returns (bool) {
344 		uint256 _claimedWordIndex = _index / 256;
345 		uint256 _claimedBitIndex = _index % 256;
346 		uint256 _claimedWord = info.claimedBitMap[_claimedWordIndex];
347 		uint256 _mask = (1 << _claimedBitIndex);
348 		return _claimedWord & _mask == _mask;
349 	}
350 
351 	function getToken(uint256 _tokenId) public view returns (address tokenOwner, address approved) {
352 		return (ownerOf(_tokenId), getApproved(_tokenId));
353 	}
354 
355 	function getTokens(uint256[] memory _tokenIds) public view returns (address[] memory owners, address[] memory approveds) {
356 		uint256 _length = _tokenIds.length;
357 		owners = new address[](_length);
358 		approveds = new address[](_length);
359 		for (uint256 i = 0; i < _length; i++) {
360 			(owners[i], approveds[i]) = getToken(_tokenIds[i]);
361 		}
362 	}
363 
364 	function getTokensTable(uint256 _limit, uint256 _page, bool _isAsc) public view returns (uint256[] memory tokenIds, address[] memory owners, address[] memory approveds, uint256 totalTokens, uint256 totalPages) {
365 		require(_limit > 0);
366 		totalTokens = totalSupply();
367 
368 		if (totalTokens > 0) {
369 			totalPages = (totalTokens / _limit) + (totalTokens % _limit == 0 ? 0 : 1);
370 			require(_page < totalPages);
371 
372 			uint256 _offset = _limit * _page;
373 			if (_page == totalPages - 1 && totalTokens % _limit != 0) {
374 				_limit = totalTokens % _limit;
375 			}
376 
377 			tokenIds = new uint256[](_limit);
378 			for (uint256 i = 0; i < _limit; i++) {
379 				tokenIds[i] = tokenByIndex(_isAsc ? _offset + i : totalTokens - _offset - i - 1);
380 			}
381 		} else {
382 			totalPages = 0;
383 			tokenIds = new uint256[](0);
384 		}
385 		(owners, approveds) = getTokens(tokenIds);
386 	}
387 
388 	function getOwnerTokensTable(address _owner, uint256 _limit, uint256 _page, bool _isAsc) public view returns (uint256[] memory tokenIds, address[] memory approveds, uint256 totalTokens, uint256 totalPages) {
389 		require(_limit > 0);
390 		totalTokens = balanceOf(_owner);
391 
392 		if (totalTokens > 0) {
393 			totalPages = (totalTokens / _limit) + (totalTokens % _limit == 0 ? 0 : 1);
394 			require(_page < totalPages);
395 
396 			uint256 _offset = _limit * _page;
397 			if (_page == totalPages - 1 && totalTokens % _limit != 0) {
398 				_limit = totalTokens % _limit;
399 			}
400 
401 			tokenIds = new uint256[](_limit);
402 			for (uint256 i = 0; i < _limit; i++) {
403 				tokenIds[i] = tokenOfOwnerByIndex(_owner, _isAsc ? _offset + i : totalTokens - _offset - i - 1);
404 			}
405 		} else {
406 			totalPages = 0;
407 			tokenIds = new uint256[](0);
408 		}
409 		( , approveds) = getTokens(tokenIds);
410 	}
411 
412 	function allInfoFor(address _owner) external view returns (uint256 supply, uint256 ownerBalance) {
413 		return (totalSupply(), balanceOf(_owner));
414 	}
415 
416 
417 	function _mint(address _receiver) internal returns (uint256 tokenId) {
418 		tokenId = totalSupply();
419 		info.totalSupply++;
420 		info.list[tokenId].owner = _receiver;
421 		info.users[_receiver].indexOf[tokenId] = info.users[_receiver].list.push(tokenId);
422 		emit Transfer(address(0x0), _receiver, tokenId);
423 	}
424 	
425 	function _transfer(address _from, address _to, uint256 _tokenId) internal {
426 		(address _owner, address _approved) = getToken(_tokenId);
427 		require(_from == _owner);
428 		require(msg.sender == _owner || msg.sender == _approved || isApprovedForAll(_owner, msg.sender));
429 
430 		info.list[_tokenId].owner = _to;
431 		if (_approved != address(0x0)) {
432 			info.list[_tokenId].approved = address(0x0);
433 			emit Approval(address(0x0), address(0x0), _tokenId);
434 		}
435 
436 		uint256 _index = info.users[_from].indexOf[_tokenId] - 1;
437 		uint256 _moved = info.users[_from].list[info.users[_from].list.length - 1];
438 		info.users[_from].list[_index] = _moved;
439 		info.users[_from].indexOf[_moved] = _index + 1;
440 		info.users[_from].list.length--;
441 		delete info.users[_from].indexOf[_tokenId];
442 		info.users[_to].indexOf[_tokenId] = info.users[_to].list.push(_tokenId);
443 		emit Transfer(_from, _to, _tokenId);
444 	}
445 
446 	function _verify(bytes32[] memory _proof, bytes32 _leaf) internal view returns (bool) {
447 		bytes32 _computedHash = _leaf;
448 		for (uint256 i = 0; i < _proof.length; i++) {
449 			bytes32 _proofElement = _proof[i];
450 			if (_computedHash <= _proofElement) {
451 				_computedHash = keccak256(abi.encodePacked(_computedHash, _proofElement));
452 			} else {
453 				_computedHash = keccak256(abi.encodePacked(_proofElement, _computedHash));
454 			}
455 		}
456 		return _computedHash == info.merkleRoot;
457 	}
458 }