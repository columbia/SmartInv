1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.6;
3 
4 /*
5 
6  +++      .  .      +++ 
7  +@++++   .  .   ++++@+ 
8  ++++@+.        .+@++++ 
9    .+++   ++++   +++.   
10           +@@+          
11 . .   . +++@@+++ .   . .
12 .       +@++++@+       .
13      ++++++  ++++++     
14      +@+        +@+     
15 .    ++++      ++++    .
16    .  +@+      +@+  .   
17   .  .+++.    .+++.  .  
18  . .   .        .   . . 
19     .    .    .    .    
20    .   ..      ..   .   
21  .                    . 
22 
23 Project INK
24 Collect generative inkblot art inspired by the Rorschach test.
25 
26 Website: https://project.ink/
27 Created by sol_dev
28 
29 */
30 
31 interface Receiver {
32 	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns (bytes4);
33 }
34 
35 contract Metadata {
36 	string public name = "Project INK";
37 	string public symbol = "INK";
38 	function contractURI() external pure returns (string memory) {
39 		return "https://api.project.ink/metadata";
40 	}
41 	function baseTokenURI() public pure returns (string memory) {
42 		return "https://api.project.ink/token/metadata/";
43 	}
44 	function tokenURI(uint256 _tokenId) external pure returns (string memory) {
45 		bytes memory _base = bytes(baseTokenURI());
46 		uint256 _digits = 1;
47 		uint256 _n = _tokenId;
48 		while (_n > 9) {
49 			_n /= 10;
50 			_digits++;
51 		}
52 		bytes memory _uri = new bytes(_base.length + _digits);
53 		for (uint256 i = 0; i < _uri.length; i++) {
54 			if (i < _base.length) {
55 				_uri[i] = _base[i];
56 			} else {
57 				uint256 _dec = (_tokenId / (10**(_uri.length - i - 1))) % 10;
58 				_uri[i] = bytes1(uint8(_dec) + 48);
59 			}
60 		}
61 		return string(_uri);
62 	}
63 }
64 
65 contract ProjectINK {
66 
67 	uint256 constant public MAX_NAME_LENGTH = 32;
68 	uint256 constant public MAX_SUPPLY = 1921;
69 	uint256 constant public MINT_COST = 0.05 ether;
70 
71 	struct User {
72 		uint256 balance;
73 		mapping(uint256 => uint256) list;
74 		mapping(address => bool) approved;
75 		mapping(uint256 => uint256) indexOf;
76 	}
77 
78 	struct Token {
79 		address owner;
80 		address approved;
81 		bytes32 seed;
82 		string name;
83 	}
84 
85 	struct Info {
86 		uint256 totalSupply;
87 		mapping(uint256 => Token) list;
88 		mapping(address => User) users;
89 		Metadata metadata;
90 		address owner;
91 	}
92 	Info private info;
93 
94 	mapping(bytes4 => bool) public supportsInterface;
95 
96 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
97 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
98 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
99 
100 	event Mint(address indexed owner, uint256 indexed tokenId, bytes32 seed);
101 	event Rename(address indexed owner, uint256 indexed tokenId, string name);
102 
103 
104 	modifier _onlyOwner() {
105 		require(msg.sender == owner());
106 		_;
107 	}
108 
109 
110 	constructor() {
111 		info.metadata = new Metadata();
112 		info.owner = msg.sender;
113 		supportsInterface[0x01ffc9a7] = true; // ERC-165
114 		supportsInterface[0x80ac58cd] = true; // ERC-721
115 		supportsInterface[0x5b5e139f] = true; // Metadata
116 		supportsInterface[0x780e9d63] = true; // Enumerable
117 
118 		for (uint256 i = 0; i < 10; i++) {
119 			_mint();
120 		}
121 	}
122 
123 	function setOwner(address _owner) external _onlyOwner {
124 		info.owner = _owner;
125 	}
126 
127 	function setMetadata(Metadata _metadata) external _onlyOwner {
128 		info.metadata = _metadata;
129 	}
130 
131 	function ownerWithdraw() external _onlyOwner {
132 		uint256 _balance = address(this).balance;
133 		require(_balance > 0);
134 		payable(msg.sender).transfer(_balance);
135 	}
136 
137 	
138 	receive() external payable {
139 		mintMany(msg.value / MINT_COST);
140 	}
141 	
142 	function mint() external payable {
143 		mintMany(1);
144 	}
145 
146 	function mintMany(uint256 _tokens) public payable {
147 		require(_tokens > 0);
148 		uint256 _cost = _tokens * MINT_COST;
149 		require(msg.value >= _cost);
150 		for (uint256 i = 0; i < _tokens; i++) {
151 			_mint();
152 		}
153 		if (msg.value > _cost) {
154 			payable(msg.sender).transfer(msg.value - _cost);
155 		}
156 	}
157 	
158 	function rename(uint256 _tokenId, string calldata _newName) external {
159 		require(bytes(_newName).length <= MAX_NAME_LENGTH);
160 		require(msg.sender == ownerOf(_tokenId));
161 		info.list[_tokenId].name = _newName;
162 		emit Rename(msg.sender, _tokenId, _newName);
163 	}
164 	
165 	function approve(address _approved, uint256 _tokenId) external {
166 		require(msg.sender == ownerOf(_tokenId));
167 		info.list[_tokenId].approved = _approved;
168 		emit Approval(msg.sender, _approved, _tokenId);
169 	}
170 
171 	function setApprovalForAll(address _operator, bool _approved) external {
172 		info.users[msg.sender].approved[_operator] = _approved;
173 		emit ApprovalForAll(msg.sender, _operator, _approved);
174 	}
175 
176 	function transferFrom(address _from, address _to, uint256 _tokenId) external {
177 		_transfer(_from, _to, _tokenId);
178 	}
179 
180 	function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
181 		safeTransferFrom(_from, _to, _tokenId, "");
182 	}
183 
184 	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public {
185 		_transfer(_from, _to, _tokenId);
186 		uint32 _size;
187 		assembly {
188 			_size := extcodesize(_to)
189 		}
190 		if (_size > 0) {
191 			require(Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) == 0x150b7a02);
192 		}
193 	}
194 
195 
196 	function name() external view returns (string memory) {
197 		return info.metadata.name();
198 	}
199 
200 	function symbol() external view returns (string memory) {
201 		return info.metadata.symbol();
202 	}
203 
204 	function contractURI() external view returns (string memory) {
205 		return info.metadata.contractURI();
206 	}
207 
208 	function baseTokenURI() external view returns (string memory) {
209 		return info.metadata.baseTokenURI();
210 	}
211 
212 	function tokenURI(uint256 _tokenId) external view returns (string memory) {
213 		return info.metadata.tokenURI(_tokenId);
214 	}
215 
216 	function owner() public view returns (address) {
217 		return info.owner;
218 	}
219 
220 	function totalSupply() public view returns (uint256) {
221 		return info.totalSupply;
222 	}
223 
224 	function balanceOf(address _owner) public view returns (uint256) {
225 		return info.users[_owner].balance;
226 	}
227 
228 	function ownerOf(uint256 _tokenId) public view returns (address) {
229 		require(_tokenId < totalSupply());
230 		return info.list[_tokenId].owner;
231 	}
232 
233 	function getApproved(uint256 _tokenId) public view returns (address) {
234 		require(_tokenId < totalSupply());
235 		return info.list[_tokenId].approved;
236 	}
237 
238 	function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
239 		return info.users[_owner].approved[_operator];
240 	}
241 
242 	function getSeed(uint256 _tokenId) public view returns (bytes32) {
243 		require(_tokenId < totalSupply());
244 		return info.list[_tokenId].seed;
245 	}
246 
247 	function getName(uint256 _tokenId) public view returns (string memory) {
248 		require(_tokenId < totalSupply());
249 		return info.list[_tokenId].name;
250 	}
251 
252 	function tokenByIndex(uint256 _index) public view returns (uint256) {
253 		require(_index < totalSupply());
254 		return _index;
255 	}
256 
257 	function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
258 		require(_index < balanceOf(_owner));
259 		return info.users[_owner].list[_index];
260 	}
261 
262 	function getINK(uint256 _tokenId) public view returns (address tokenOwner, address approved, bytes32 seed, string memory tokenName) {
263 		return (ownerOf(_tokenId), getApproved(_tokenId), getSeed(_tokenId), getName(_tokenId));
264 	}
265 
266 	function getINKs(uint256[] memory _tokenIds) public view returns (address[] memory owners, address[] memory approveds, bytes32[] memory seeds, bytes32[] memory names) {
267 		uint256 _length = _tokenIds.length;
268 		owners = new address[](_length);
269 		approveds = new address[](_length);
270 		seeds = new bytes32[](_length);
271 		names = new bytes32[](_length);
272 		for (uint256 i = 0; i < _length; i++) {
273 			string memory _name;
274 			(owners[i], approveds[i], seeds[i], _name) = getINK(_tokenIds[i]);
275 			names[i] = _stringToBytes32(_name);
276 		}
277 	}
278 
279 	function getINKsTable(uint256 _limit, uint256 _page, bool _isAsc) public view returns (uint256[] memory tokenIds, address[] memory owners, address[] memory approveds, bytes32[] memory seeds, bytes32[] memory names, uint256 totalINKs, uint256 totalPages) {
280 		require(_limit > 0);
281 		totalINKs = totalSupply();
282 
283 		if (totalINKs > 0) {
284 			totalPages = (totalINKs / _limit) + (totalINKs % _limit == 0 ? 0 : 1);
285 			require(_page < totalPages);
286 
287 			uint256 _offset = _limit * _page;
288 			if (_page == totalPages - 1 && totalINKs % _limit != 0) {
289 				_limit = totalINKs % _limit;
290 			}
291 
292 			tokenIds = new uint256[](_limit);
293 			for (uint256 i = 0; i < _limit; i++) {
294 				tokenIds[i] = tokenByIndex(_isAsc ? _offset + i : totalINKs - _offset - i - 1);
295 			}
296 		} else {
297 			totalPages = 0;
298 			tokenIds = new uint256[](0);
299 		}
300 		(owners, approveds, seeds, names) = getINKs(tokenIds);
301 	}
302 
303 	function getOwnerINKsTable(address _owner, uint256 _limit, uint256 _page, bool _isAsc) public view returns (uint256[] memory tokenIds, address[] memory approveds, bytes32[] memory seeds, bytes32[] memory names, uint256 totalINKs, uint256 totalPages) {
304 		require(_limit > 0);
305 		totalINKs = balanceOf(_owner);
306 
307 		if (totalINKs > 0) {
308 			totalPages = (totalINKs / _limit) + (totalINKs % _limit == 0 ? 0 : 1);
309 			require(_page < totalPages);
310 
311 			uint256 _offset = _limit * _page;
312 			if (_page == totalPages - 1 && totalINKs % _limit != 0) {
313 				_limit = totalINKs % _limit;
314 			}
315 
316 			tokenIds = new uint256[](_limit);
317 			for (uint256 i = 0; i < _limit; i++) {
318 				tokenIds[i] = tokenOfOwnerByIndex(_owner, _isAsc ? _offset + i : totalINKs - _offset - i - 1);
319 			}
320 		} else {
321 			totalPages = 0;
322 			tokenIds = new uint256[](0);
323 		}
324 		( , approveds, seeds, names) = getINKs(tokenIds);
325 	}
326 
327 	function allInfoFor(address _owner) external view returns (uint256 supply, uint256 ownerBalance) {
328 		return (totalSupply(), balanceOf(_owner));
329 	}
330 
331 
332 	function _mint() internal {
333 		require(totalSupply() < MAX_SUPPLY);
334 		uint256 _tokenId = info.totalSupply++;
335 		Token storage _newToken = info.list[_tokenId];
336 		_newToken.owner = msg.sender;
337 		bytes32 _seed = keccak256(abi.encodePacked(_tokenId, msg.sender, blockhash(block.number - 1), gasleft()));
338 		_newToken.seed = _seed;
339 		uint256 _index = info.users[msg.sender].balance++;
340 		info.users[msg.sender].indexOf[_tokenId] = _index + 1;
341 		info.users[msg.sender].list[_index] = _tokenId;
342 		emit Transfer(address(0x0), msg.sender, _tokenId);
343 		emit Mint(msg.sender, _tokenId, _seed);
344 	}
345 	
346 	function _transfer(address _from, address _to, uint256 _tokenId) internal {
347 		address _owner = ownerOf(_tokenId);
348 		address _approved = getApproved(_tokenId);
349 		require(_from == _owner);
350 		require(msg.sender == _owner || msg.sender == _approved || isApprovedForAll(_owner, msg.sender));
351 
352 		info.list[_tokenId].owner = _to;
353 		if (_approved != address(0x0)) {
354 			info.list[_tokenId].approved = address(0x0);
355 			emit Approval(address(0x0), address(0x0), _tokenId);
356 		}
357 
358 		uint256 _index = info.users[_from].indexOf[_tokenId] - 1;
359 		uint256 _moved = info.users[_from].list[info.users[_from].balance - 1];
360 		info.users[_from].list[_index] = _moved;
361 		info.users[_from].indexOf[_moved] = _index + 1;
362 		info.users[_from].balance--;
363 		delete info.users[_from].indexOf[_tokenId];
364 		uint256 _newIndex = info.users[_to].balance++;
365 		info.users[_to].indexOf[_tokenId] = _newIndex + 1;
366 		info.users[_to].list[_newIndex] = _tokenId;
367 		emit Transfer(_from, _to, _tokenId);
368 	}
369 
370 
371 	function _stringToBytes32(string memory _in) internal pure returns (bytes32 out) {
372 		if (bytes(_in).length == 0) {
373 			return 0x0;
374 		}
375 		assembly {
376 			out := mload(add(_in, 32))
377 		}
378 	}
379 }