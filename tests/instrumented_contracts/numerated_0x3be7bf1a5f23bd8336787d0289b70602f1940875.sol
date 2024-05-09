1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.16;
3 
4 interface ERC20 {
5 	function totalSupply() external view returns (uint256);
6 	function decimals() external view returns (uint8);
7 	function symbol() external view returns (string memory);
8 	function name() external view returns (string memory);
9 
10 	function balanceOf(address account) external view returns (uint256);
11 	function transfer(address recipient, uint256 amount) external returns (bool);
12 	function allowance(address account, address spender) external view returns (uint256);
13 	function approve(address spender, uint256 amount) external returns (bool);
14 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 
16 	function increaseAllowance(address spender, uint256 amount) external returns (bool success);
17 	function decreaseAllowance(address spender, uint256 amount) external returns (bool success);
18 
19 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
20 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 }
22 
23 contract Context {
24 	constructor () { }
25 
26 	function _msgSender() internal view returns (address) {
27 		return msg.sender;
28 	}
29 }
30 
31 library SafeMath {
32 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
33 		uint256 c = a + b;
34 		require(c >= a && c >= b, "SafeMath: addition overflow");
35 		return c;
36 	}
37 
38 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39 		return sub(a, b, "SafeMath: subtraction overflow");
40 	}
41 
42 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43 		uint256 c = a - b;
44 		require(b <= a && c <= a, errorMessage);
45 		return c;
46 	}
47 }
48 
49 contract Controllable is Context {
50 	mapping (address => bool) public controllers;
51 	event ControllerAdded(address indexed _new);
52 	event ControllerRemoved(address indexed _old);
53 
54 	constructor () {
55 		address msgSender = _msgSender();
56 		controllers[msgSender] = true;
57 		emit ControllerAdded(msgSender);
58 	}
59 
60 	modifier onlyController() {
61 		require(controllers[_msgSender()], "Controllable: caller is not a controller");
62 		_;
63 	}
64 
65 	function addController(address _address) external onlyController {
66 		controllers[_address] = true;
67 		emit ControllerAdded(_address);
68 	}
69 
70 	function removeController(address _address) external onlyController {
71 		delete controllers[_address];
72 		emit ControllerRemoved(_address);
73 	}
74 }
75 
76 library SafeERC20 {
77 	function safeTransfer(ERC20 _token, address _to, uint256 _value) internal {
78 		require(_token.transfer(_to, _value),"STF1 - Safe transfer failed");
79 	}
80 }
81 
82 contract VIDT is ERC20, Controllable {
83 	using SafeMath for uint256;
84 	using SafeERC20 for ERC20;
85 
86 	mapping (address => uint256) private _balances;
87 	mapping (address => mapping (address => uint256)) private _allowances;
88 	mapping (uint256 => string) private verifiedNFTs;
89 
90 	struct FileStruct { uint256 index; uint256 nft; }
91 	mapping(string => FileStruct) private fileHashes;
92 	string[] private fileIndex;
93 
94 	string private constant NAME = 'VIDT DAO';
95 	string private constant SYMBOL = 'VIDT';
96 	uint8 private constant _decimals = 18;
97 	uint256 private _totalSupply = 1e27;
98 
99 	uint256 private _validationPrice = 1 * 10**18;
100 	uint256 private _validationFee = 1 * 10**18;
101 	address private _validationWallet;
102 
103 	address private constant LEGACY_CONTRACT = address(0xfeF4185594457050cC9c23980d301908FE057Bb1);
104 	address private _nftContract;
105 	address private _nftdContract;
106 
107 	event ValidateFile(uint256 indexed index, string indexed data, uint256 indexed nftID);
108 	event ValidateNFT(string indexed data, uint256 indexed nftID);
109 	event ListFile(uint256 indexed index, string indexed data, uint256 indexed nft) anonymous;
110 	event NewPrice(uint256 indexed newPrice);
111 	event NewFee(uint256 indexed newFee);
112 	event NewWallet(address indexed newWallet);
113 	event NewContracts(address indexed new_nftContract, address indexed new_nftdContract);
114 
115 	constructor() {
116 		_validationWallet = msg.sender;
117 		_balances[msg.sender] = _totalSupply;
118 		fileIndex.push('');
119 		fileHashes[''].index = 0;
120 	}
121 
122 	function decimals() external view virtual override returns (uint8) {
123 		return _decimals;
124 	}
125 
126 	function symbol() external view virtual override returns (string memory) {
127 		return SYMBOL;
128 	}
129 
130 	function name() external view virtual override returns (string memory) {
131 		return NAME;
132 	}
133 
134 	function totalSupply() external view virtual override returns (uint256) {
135 		return _totalSupply;
136 	}
137 
138 	function balanceOf(address account) external view virtual override returns (uint256) {
139 		return _balances[account];
140 	}
141 
142 	function transfer(address recipient, uint256 amount) external override returns (bool) {
143 		_transfer(_msgSender(), recipient, amount);
144 		return true;
145 	}
146 
147 	function transferToken(address tokenAddress, uint256 tokens) external returns (bool) {
148 		return ERC20(tokenAddress).transfer(_validationWallet,tokens);
149 	}
150 
151 	function allowance(address owner, address spender) external view override returns (uint256) {
152 		return _allowances[owner][spender];
153 	}
154 
155 	function approve(address spender, uint256 amount) external override returns (bool) {
156 		require((amount == 0) || (_allowances[msg.sender][spender] == 0),"A1- Reset allowance to 0 first");
157 		_approve(_msgSender(), spender, amount);
158 		return true;
159 	}
160 
161 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
162 		_transfer(sender, recipient, amount);
163 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "TF1 - Transfer amount exceeds allowance"));
164 		return true;
165 	}
166 
167 	function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
168 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
169 		return true;
170 	}
171 
172 	function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
173 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "DA1 - Decreased allowance below zero"));
174 		return true;
175 	}
176 
177 	function burn(uint256 amount) external {
178 		_burn(_msgSender(), amount);
179 	}
180 
181 	function burnFrom(address account, uint256 amount) external {
182 		uint256 decreasedAllowance = _allowances[account][_msgSender()].sub(amount, "BF1 - Burn amount exceeds allowance");
183 		_approve(account, _msgSender(), decreasedAllowance);
184 		_burn(account, amount);
185 	}
186 
187 	function _transfer(address sender, address recipient, uint256 amount) internal {
188 		require(sender != address(0), "T1 - Transfer from the zero address");
189 		require(recipient != address(0), "T3 - Transfer to the zero address");
190 
191 		_balances[sender] = _balances[sender].sub(amount, "T4 - Transfer amount exceeds balance");
192 		_balances[recipient] = _balances[recipient].add(amount);
193 
194 		emit Transfer(sender, recipient, amount);
195 	}
196 
197 	function _burn(address account, uint256 amount) internal {
198 		require(account != address(0), "B1 - Burn from the zero address");
199 
200 		_balances[account] = _balances[account].sub(amount, "B2 - Burn amount exceeds balance");
201 		_totalSupply = _totalSupply.sub(amount);
202 
203 		emit Transfer(account, address(0), amount);
204 	}
205 
206 	function _approve(address owner, address spender, uint256 amount) internal {
207 		require(owner != address(0), "A1 - Approve from the zero address");
208 		require(spender != address(0), "A2 - Approve to the zero address");
209 
210 		_allowances[owner][spender] = amount;
211 		emit Approval(owner, spender, amount);
212 	}
213 
214 	function bytesToBytes32(bytes memory b, uint offset) private pure returns (bytes32) {
215 		bytes32 out;
216 		for (uint i = 0; i < 32; i++) {
217 			out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
218 		}
219 		return out;
220 	}
221 
222 	function validateFile(uint256 Payment, bytes calldata Data, bool cStore, bool eLog, bool NFT) external payable returns (bool) {
223 		require(Payment >= _validationPrice || msg.value >= _validationFee,"V1 - Insufficient payment provided");
224 		require(Data.length == 64,"V3 - Invalid hash provided");
225 
226 		uint256 index;
227 		string calldata fileHash = string(Data);
228 
229 		if (cStore) {
230 			if (fileIndex.length > 0) {
231 				require(fileHashes[fileHash].index == 0,"V4 - This hash was previously validated");
232 			}
233 
234 			fileIndex.push(fileHash);
235 			fileHashes[fileHash].index = fileIndex.length-1;
236 			index = fileHashes[fileHash].index;
237 		}
238 
239 		bool nft_created = false;
240 		uint256 nftID;
241 
242 		if (NFT) {
243 			bytes memory nft_data = "";
244 			require(fileHashes[fileHash].nft == 0,"V5 - NFT exists already");
245 			(nft_created, nft_data) = _nftContract.delegatecall(abi.encodeWithSignature("createNFT(bytes)", Data));
246 			require(nft_created,"V6 - NFT contract call failed");
247 
248 			nftID = uint256(bytesToBytes32(nft_data,0));
249 
250 			require(nftID > 0 && bytes(verifiedNFTs[nftID]).length == 0,"V7 - Not a valid NFT ID");
251 
252 			verifiedNFTs[nftID] = fileHash;
253 			fileHashes[fileHash].nft = nftID;
254 
255 			emit ValidateNFT(fileHash,nftID);
256 		}
257 
258 		if (_allowances[_validationWallet][msg.sender] >= Payment) {
259 			_allowances[_validationWallet][msg.sender] = _allowances[_validationWallet][msg.sender].sub(Payment);
260 		} else {
261 			_balances[msg.sender] = _balances[msg.sender].sub(Payment);
262 			_balances[_validationWallet] = _balances[_validationWallet].add(Payment);
263 		}
264 
265 		if (eLog) {
266 			emit ValidateFile(index,fileHash,nftID);
267 		}
268 
269 		emit Transfer(msg.sender, _validationWallet, Payment);
270 		return true;
271 	}
272 
273 	function memoryValidateFile(uint256 Payment, bytes calldata Data) external payable returns (bool) {
274 		require(Payment >= _validationPrice || msg.value >= _validationFee,"V1 - Insufficient payment provided");
275 		require(Data.length == 64,"V3 - Invalid hash provided");
276 
277 		uint256 index;
278 		string calldata fileHash = string(Data);
279 
280 		if (fileIndex.length > 0) {
281 			require(fileHashes[fileHash].index == 0,"V4 - This hash was previously validated");
282 		}
283 
284 		fileIndex.push(fileHash);
285 		fileHashes[fileHash].index = fileIndex.length-1;
286 		index = fileHashes[fileHash].index;
287 
288 		if (_allowances[_validationWallet][msg.sender] >= Payment) {
289 			_allowances[_validationWallet][msg.sender] = _allowances[_validationWallet][msg.sender].sub(Payment);
290 		} else {
291 			_balances[msg.sender] = _balances[msg.sender].sub(Payment);
292 			_balances[_validationWallet] = _balances[_validationWallet].add(Payment);
293 		}
294 
295 		emit Transfer(msg.sender, _validationWallet, Payment);
296 		return true;
297 	}
298 
299 	function validateNFT(uint256 Payment, bytes calldata Data, bool divisable) external payable returns (bool) {
300 		require(Payment >= _validationPrice || msg.value >= _validationFee,"V1 - Insufficient payment provided");
301 		require(Data.length == 64,"V3 - Invalid hash provided");
302 
303 		string calldata fileHash = string(Data);
304 		bool nft_created = false;
305 		uint256 nftID;
306 		bytes memory nft_data = "";
307 
308 		require(fileHashes[fileHash].nft == 0,"V5 - NFT exists already");
309 
310 		if (divisable) {
311 			(nft_created, nft_data) = _nftdContract.delegatecall(abi.encodeWithSignature("createNFT(bytes)", Data));
312 		} else {
313 			(nft_created, nft_data) = _nftContract.delegatecall(abi.encodeWithSignature("createNFT(bytes)", Data));
314 		}
315 		require(nft_created,"V6 - NFT contract call failed");
316 
317 		nftID = uint256(bytesToBytes32(nft_data,0));
318 
319 		require(nftID > 0 && bytes(verifiedNFTs[nftID]).length == 0,"V7 - Not a valid NFT ID");
320 
321 		verifiedNFTs[nftID] = fileHash;
322 		fileHashes[fileHash].nft = nftID;
323 
324 		if (_allowances[_validationWallet][msg.sender] >= Payment) {
325 			_allowances[_validationWallet][msg.sender] = _allowances[_validationWallet][msg.sender].sub(Payment);
326 		} else {
327 			_balances[msg.sender] = _balances[msg.sender].sub(Payment);
328 			_balances[_validationWallet] = _balances[_validationWallet].add(Payment);
329 		}
330 
331 		emit Transfer(msg.sender, _validationWallet, Payment);
332 		emit ValidateNFT(fileHash,nftID);
333 		return true;
334 	}
335 
336 	function simpleValidateFile(bytes calldata Data) external returns (string calldata) {
337 		require(Data.length == 64,"V3 - Invalid hash provided");
338 		string calldata fileHash = string(Data);
339 
340 		_balances[msg.sender] = _balances[msg.sender].sub(_validationPrice);
341 		_balances[_validationWallet] = _balances[_validationWallet].add(_validationPrice);
342 
343 		emit Transfer(msg.sender, _validationWallet, _validationFee);
344 		return fileHash;
345 	}
346 
347 	function verifyFile(string memory fileHash) external view returns (bool verified) {
348 		verified = true;
349 		if (fileIndex.length == 1) {
350 			verified = false;
351 		}
352 		bytes memory a = bytes(fileIndex[fileHashes[fileHash].index]);
353 		bytes memory b = bytes(fileHash);
354 		if (a.length != b.length) {
355 			verified = false;
356 		}
357 		if (verified) {
358 		for (uint256 i = 0; i < a.length; i ++) {
359 			if (a[i] != b[i]) {
360 				verified = false;
361 				break;
362 			}
363 		} }
364 		if (!verified) {
365 			bool heritage_call = false;
366 			bytes memory heritage_data = "";
367 			(heritage_call, heritage_data) = LEGACY_CONTRACT.staticcall(abi.encodeWithSignature("verifyFile(string)", fileHash));
368 			require(heritage_call,"V0 - Legacy contract call failed");
369 			assembly {verified := mload(add(heritage_data, 32))}
370 		}
371 	}
372 
373 	function verify(string memory fileHash) external view returns (bool) {
374 		if (fileIndex.length == 1) {
375 			return false;
376 		}
377 		bytes memory a = bytes(fileIndex[fileHashes[fileHash].index]);
378 		bytes memory b = bytes(fileHash);
379 		if (a.length != b.length) {
380 			return false;
381 		}
382 		for (uint256 i = 0; i < a.length; i ++) {
383 			if (a[i] != b[i]) {
384 				return false;
385 			}
386 		}
387 		return true;
388 	}
389 
390 	function verifyFileNFT(string memory fileHash) external view returns (uint256) {
391 		if (fileIndex.length == 1) {
392 			return 0;
393 		}
394 		bytes memory a = bytes(fileIndex[fileHashes[fileHash].index]);
395 		bytes memory b = bytes(fileHash);
396 		if (a.length != b.length) {
397 			return 0;
398 		}
399 		for (uint256 i = 0; i < a.length; i ++) {
400 			if (a[i] != b[i]) {
401 				return 0;
402 			}
403 		}
404 		return fileHashes[fileHash].nft;
405 	}
406 
407 	function verifyNFT(uint256 nftID) external view returns (string memory hash) {
408 		hash = verifiedNFTs[nftID];
409 	}
410 
411 	function setPrice(uint256 _newPrice) external onlyController {
412 		_validationPrice = _newPrice;
413 		emit NewPrice(_newPrice);
414 	}
415 
416 	function setFee(uint256 _newFee) external onlyController {
417 		_validationFee = _newFee;
418 		emit NewFee(_newFee);
419 	}
420 
421 	function setWallet(address _newWallet) external onlyController {
422 		require(_newWallet != address(0),"SW1 - Cannot set wallet to zero address");
423 		_validationWallet = _newWallet;
424 		emit NewWallet(_newWallet);
425 	}
426 
427 	function setContracts(address new_nftContract, address new_nftdContract) external onlyController {
428 		require(new_nftContract != address(0) && new_nftdContract != address(0),"SC1 - Cannot set wallet to zero address");
429 		_nftContract = new_nftContract;
430 		_nftdContract = new_nftdContract;
431 		emit NewContracts(new_nftContract,new_nftdContract);
432 	}
433 
434 	function listFiles(uint256 startAt, uint256 stopAt) onlyController public returns (bool) {
435 		if (fileIndex.length == 1) {
436 			return false;
437 		}
438 		require(startAt <= fileIndex.length-1,"L1 - Please select a valid start");
439 		if (stopAt > 0) {
440 			require(stopAt > startAt && stopAt <= fileIndex.length-1,"L2 - Please select a valid stop");
441 		} else {
442 			stopAt = fileIndex.length-1;
443 		}
444 		for (uint256 i = startAt; i <= stopAt; i++) {
445 			emit ListFile(i,fileIndex[i],fileHashes[fileIndex[i]].nft);
446 		}
447 		return true;
448 	}
449 
450 	function withdraw(uint256 amount) external {
451 		require(address(this).balance >= amount, "W1 - Insufficient balance");
452 		(bool success, ) = payable(_validationWallet).call{ value: amount }("");
453 		require(success, "W2 - Unable to send value, recipient may have reverted");
454 	}
455 
456 	function validationPrice() external view returns (uint256) {
457 		return _validationPrice;
458 	}
459 
460 	function validationFee() external view returns (uint256) {
461 		return _validationFee;
462 	}
463 
464 	function validationWallet() external view returns (address) {
465 		return _validationWallet;
466 	}
467 
468 	function nftContract() external view returns (address) {
469 		return _nftContract;
470 	}
471 
472 	function nftdContract() external view returns (address) {
473 		return _nftdContract;
474 	}
475 }