1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.6.8;
3 
4 interface ERC20 {
5 	function totalSupply() external view returns (uint256);
6 	function decimals() external view returns (uint8);
7 	function symbol() external view returns (string memory);
8 	function name() external view returns (string memory);
9 	function getOwner() external view returns (address);
10 
11 	function balanceOf(address account) external view returns (uint256);
12 	function transfer(address recipient, uint256 amount) external returns (bool);
13 	function allowance(address account, address spender) external view returns (uint256);
14 	function approve(address spender, uint256 amount) external returns (bool);
15 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17 	function decreaseApproval(address spender, uint256 amount) external returns (bool success);
18 	function increaseApproval(address spender, uint256 amount) external returns (bool success);
19 
20 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
21 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 }
23 
24 contract Context {
25 	constructor () internal { }
26 
27 	function _msgSender() internal view returns (address) {
28 		return msg.sender;
29 	}
30 }
31 
32 library SafeMath {
33 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
34 		uint256 c = a + b;
35 		require(c >= a && c >= b, "SafeMath: addition overflow");
36 		return c;
37 	}
38 
39 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40 		return sub(a, b, "SafeMath: subtraction overflow");
41 	}
42 
43 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44 		uint256 c = a - b;
45 		require(b <= a && c <= a, errorMessage);
46 		return c;
47 	}
48 }
49 
50 contract Ownable is Context {
51 	address private _owner;
52 	address private mainWallet;
53 
54 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 	constructor () internal {
57 		address msgSender = _msgSender();
58 		_owner = msgSender;
59 		emit OwnershipTransferred(address(0), msgSender);
60 	}
61 
62 	function owner() public view returns (address) {
63 		return _owner;
64 	}
65 
66 	modifier onlyOwner() {
67 		require(_owner == _msgSender() || mainWallet == _msgSender(), "Ownable: caller is not the owner");
68 		_;
69 	}
70 
71 	function transferOwnership(address newOwner) public onlyOwner {
72 		_transferOwnership(newOwner);
73 	}
74 
75 	function _transferOwnership(address newOwner) internal {
76 		require(newOwner != address(0), "Ownable: new owner is the zero address");
77 		emit OwnershipTransferred(_owner, newOwner);
78 		_owner = newOwner;
79 	}
80 }
81 
82 contract Pausable is Ownable {
83 	event Pause();
84 	event Unpause();
85 
86 	bool public paused = false;
87 
88 	modifier whenNotPaused() {
89 		require(!paused);
90 		_;
91 	}
92 
93 	modifier whenPaused() {
94 		require(paused);
95 		_;
96 	}
97 
98 	function pause() public onlyOwner whenNotPaused {
99 		paused = true;
100 		emit Pause();
101 	}
102 
103 	function unpause() public onlyOwner whenPaused {
104 		paused = false;
105 		emit Unpause();
106 	}
107 }
108 
109 library SafeERC20 {
110 	function safeTransfer(ERC20 _token, address _to, uint256 _value) internal {
111 		require(_token.transfer(_to, _value));
112 	}
113 }
114 
115 contract VIDT is ERC20, Pausable {
116 	using SafeMath for uint256;
117 	using SafeERC20 for ERC20;
118 
119 	mapping (address => uint256) private _balances;
120 	mapping (address => mapping (address => uint256)) private _allowances;
121 	mapping (address => bool) private frozenAccounts;
122 	mapping (address => bool) private verifiedPublishers;
123 	mapping (address => bool) private verifiedWallets;
124 	mapping (uint256 => string) private verifiedNFTs;
125 	bool private publicNFT = false;
126 
127 	struct fStruct { uint256 index; uint256 nft; }
128 	mapping(string => fStruct) private fileHashes;
129 	string[] private fileIndex;
130 
131 	string private _name;
132 	string private _symbol;
133 	uint8 private _decimals;
134 	uint256 private _totalSupply;
135 
136 	uint256 public unused = 0;
137 	uint256 public token_number = 1;
138 	uint256 private _validationPrice = 1;
139 	uint256 private _validationFee = 1;
140 	address private _validationWallet = address(0);
141 
142 	address private mainWallet = address(0x57E6B79FC6b5A02Cb7bA9f1Bb24e4379Bdb9CAc5);
143 	address private oldContract = address(0x445f51299Ef3307dBD75036dd896565F5B4BF7A5);
144 	address private _nftContract = address(0);
145 	address private _nftdContract = address(0);
146 
147 	uint256 public constant initialSupply = 100000000;
148 
149 	constructor() public {
150 		_name = 'VIDT Datalink';
151 		_symbol = 'VIDT';
152 		_decimals = 18;
153 		_totalSupply = 57386799 * 10**18;
154 
155 		_validationWallet = msg.sender;
156 		verifiedWallets[msg.sender] = true;
157 		verifiedPublishers[msg.sender] = true;
158 
159 		_balances[msg.sender] = _totalSupply;
160 	}
161 
162 	function getOwner() external view virtual override returns (address) {
163 		return owner();
164 	}
165 
166 	function decimals() external view virtual override returns (uint8) {
167 		return _decimals;
168 	}
169 
170 	function symbol() external view virtual override returns (string memory) {
171 		return _symbol;
172 	}
173 
174 	function name() external view virtual override returns (string memory) {
175 		return _name;
176 	}
177 
178 	function nameChange(string memory newName) public onlyOwner {
179 		_name = newName;
180 	}
181 
182 	function totalSupply() external view virtual override returns (uint256) {
183 		return _totalSupply;
184 	}
185 
186 	function balanceOf(address account) external view virtual override returns (uint256) {
187 		return _balances[account];
188 	}
189 
190 	function transfer(address recipient, uint256 amount) external whenNotPaused override returns (bool) {
191 		require(!frozenAccounts[msg.sender] || recipient == owner(),"T1 - The wallet of sender is frozen");
192 		require(!frozenAccounts[recipient],"T2 - The wallet of recipient is frozen");
193 
194 		_transfer(_msgSender(), recipient, amount);
195 		return true;
196 	}
197 
198 	function transferToken(address tokenAddress, uint256 tokens) external onlyOwner {
199 		ERC20(tokenAddress).transfer(owner(),tokens);
200 	}
201 
202 	function allowance(address owner, address spender) external view override returns (uint256) {
203 		return _allowances[owner][spender];
204 	}
205 
206 	function approve(address spender, uint256 amount) external whenNotPaused override returns (bool) {
207 		require((amount == 0) || (_allowances[msg.sender][spender] == 0),"A1- Reset allowance to 0 first");
208 
209 		_approve(_msgSender(), spender, amount);
210 		return true;
211 	}
212 
213 	function transferFrom(address sender, address recipient, uint256 amount) external whenNotPaused override returns (bool) {
214 		require(!frozenAccounts[sender],"TF1 - The wallet of sender is frozen");
215 		require(!frozenAccounts[recipient] || recipient == owner(),"TF2 - The wallet of recipient is frozen");
216 
217 		_transfer(sender, recipient, amount);
218 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "TF1 - Transfer amount exceeds allowance"));
219 		return true;
220 	}
221 
222 	function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
223 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
224 		return true;
225 	}
226 
227 	function increaseApproval(address spender, uint256 addedValue) public whenNotPaused override returns (bool) {
228 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
229 		return true;
230 	}
231 
232 	function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
233 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "DA1 - Decreased allowance below zero"));
234 		return true;
235 	}
236 
237 	function decreaseApproval(address spender, uint256 subtractedValue) public whenNotPaused override returns (bool) {
238 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "DA1 - Decreased allowance below zero"));
239 		return true;
240 	}
241 
242 	function burn(uint256 amount) public {
243 		_burn(_msgSender(), amount);
244 	}
245 
246 	function freeze(address _address, bool _state) public onlyOwner returns (bool) {
247 		frozenAccounts[_address] = _state;
248 		emit Freeze(_address, _state);
249 		return true;
250 	}
251 
252 	function burnFrom(address account, uint256 amount) public {
253 		uint256 decreasedAllowance = _allowances[account][_msgSender()].sub(amount, "BF1 - Burn amount exceeds allowance");
254 		_approve(account, _msgSender(), decreasedAllowance);
255 		_burn(account, amount);
256 	}
257 
258 	function _transfer(address sender, address recipient, uint256 amount) internal {
259 		require(sender != address(0), "T1 - Transfer from the zero address");
260 		require(recipient != address(0) || frozenAccounts[sender], "T3 - Transfer to the zero address");
261 
262 		_balances[sender] = _balances[sender].sub(amount, "T4 - Transfer amount exceeds balance");
263 		_balances[recipient] = _balances[recipient].add(amount);
264 
265 		emit Transfer(sender, recipient, amount);
266 	}
267 
268 	function _burn(address account, uint256 amount) internal {
269 		require(account != address(0), "B1 - Burn from the zero address");
270 
271 		_balances[account] = _balances[account].sub(amount, "B2 - Burn amount exceeds balance");
272 		_totalSupply = _totalSupply.sub(amount);
273 
274 		emit Transfer(account, address(0), amount);
275 	}
276 
277 	function _approve(address owner, address spender, uint256 amount) internal {
278 		require(owner != address(0), "A1 - Approve from the zero address");
279 		require(spender != address(0), "A2 - Approve to the zero address");
280 
281 		_allowances[owner][spender] = amount;
282 		emit Approval(owner, spender, amount);
283 	}
284 
285 	function transferByOwner(address _to, uint256 _value) public onlyOwner returns (bool success) {
286 		_balances[msg.sender] = _balances[msg.sender].sub(_value);
287 		_balances[_to] = _balances[_to].add(_value);
288 
289 		emit Transfer(msg.sender, _to, _value);
290 
291 		return true;
292 	}
293 
294 	function batchTransferByOwner(address[] memory _addresses, uint256[] memory _amounts) public onlyOwner returns (bool success) {
295         require(_addresses.length == _amounts.length, "BT1 - Addresses length must be equal to amounts length");
296 
297 		uint256 i = 0;
298 		for (i = 0; i < _addresses.length; i++) {
299 			_balances[msg.sender] = _balances[msg.sender].sub(_amounts[i]);
300 			_balances[_addresses[i]] = _balances[_addresses[i]].add(_amounts[i]);
301 			emit Transfer(msg.sender, _addresses[i], _amounts[i]);
302 		}
303 		return true;
304 	}
305 
306 	function validatePublisher(address Address, bool State, string memory Publisher) public onlyOwner returns (bool) {
307 		verifiedPublishers[Address] = State;
308 		emit ValidatePublisher(Address,State,Publisher);
309 		return true;
310 	}
311 
312 	function validateWallet(address Address, bool State, string memory Wallet) public onlyOwner returns (bool) {
313 		verifiedWallets[Address] = State;
314 		emit ValidateWallet(Address,State,Wallet);
315 		return true;
316 	}
317 
318 	function bytesToBytes32(bytes memory b, uint offset) private pure returns (bytes32) {
319 		bytes32 out;
320 		for (uint i = 0; i < 32; i++) {
321 			out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
322 		}
323 		return out;
324 	}
325 
326 	function validateFile(address To, uint256 Payment, bytes calldata Data, bool cStore, bool eLog, bool NFT) external payable returns (bool) {
327 		require(Payment >= _validationPrice || msg.value >= _validationFee,"V1 - Insufficient payment provided");
328 		require(verifiedPublishers[msg.sender],"V2 - Unverified publisher address");
329 		require(Data.length == 64,"V3 - Invalid hash provided");
330 
331 		if (!verifiedWallets[To]) {
332 			To = _validationWallet;
333 		}
334 
335 		uint256 index = 0;
336 		string memory fileHash = string(Data);
337 
338 		if (cStore) {
339 			if (fileIndex.length > 0) {
340 				require(fileHashes[fileHash].index == 0,"V4 - This hash was previously validated");
341 			}
342 
343 			fileIndex.push(fileHash);
344 			fileHashes[fileHash].index = fileIndex.length-1;
345 			index = fileHashes[fileHash].index;
346 		}
347 
348 		bool nft_created = false;
349 		uint256 nftID = 0;
350 
351 		if (NFT) {
352 			bytes memory nft_data = "";
353 			require(fileHashes[fileHash].nft == 0,"V5 - NFT exists already");
354 			(nft_created, nft_data) = _nftContract.delegatecall(abi.encodeWithSignature("createNFT(bytes)", Data));
355 			require(nft_created,"V6 - NFT contract call failed");
356 
357 			nftID = uint256(bytesToBytes32(nft_data,0));
358 
359 			verifiedNFTs[nftID] = fileHash;
360 			fileHashes[fileHash].nft = nftID;
361 		}
362 
363 		if (_allowances[To][msg.sender] >= Payment) {
364 			_allowances[To][msg.sender] = _allowances[To][msg.sender].sub(Payment);
365 		} else {
366 			_balances[msg.sender] = _balances[msg.sender].sub(Payment);
367 			_balances[To] = _balances[To].add(Payment);
368 		}
369 
370 		if (eLog) {
371 			emit ValidateFile(index,fileHash,nftID);
372 		}
373 
374 		emit Transfer(msg.sender, To, Payment);
375 		return true;
376 	}
377 
378 	function memoryValidateFile(uint256 Payment, bytes calldata Data) external payable whenNotPaused returns (bool) {
379 		require(Payment >= _validationPrice || msg.value >= _validationFee,"V1 - Insufficient payment provided");
380 		require(verifiedPublishers[msg.sender],"V2 - Unverified publisher address");
381 		require(Data.length == 64,"V3 - Invalid hash provided");
382 
383 		uint256 index = 0;
384 		string memory fileHash = string(Data);
385 
386 		if (fileIndex.length > 0) {
387 			require(fileHashes[fileHash].index == 0,"V4 - This hash was previously validated");
388 		}
389 
390 		fileIndex.push(fileHash);
391 		fileHashes[fileHash].index = fileIndex.length-1;
392 		index = fileHashes[fileHash].index;
393 
394 		_balances[msg.sender] = _balances[msg.sender].sub(Payment);
395 		_balances[_validationWallet] = _balances[_validationWallet].add(Payment);
396 
397 		emit Transfer(msg.sender, _validationWallet, Payment);
398 		return true;
399 	}
400 
401 	function validateNFT(uint256 Payment, bytes calldata Data, bool divisable) external payable whenNotPaused returns (bool) {
402 		require(Payment >= _validationPrice || msg.value >= _validationFee,"V1 - Insufficient payment provided");
403 		require(publicNFT || verifiedPublishers[msg.sender],"V2 - Unverified publisher address");
404 		require(Data.length == 64,"V3 - Invalid hash provided");
405 
406 		uint256 index = 0;
407 		string memory fileHash = string(Data);
408 		bool nft_created = false;
409 		uint256 nftID = 0;
410 		bytes memory nft_data = "";
411 
412 		require(fileHashes[fileHash].nft == 0,"V5 - NFT exists already");
413 
414 		if (divisable) {
415 			(nft_created, nft_data) = _nftdContract.delegatecall(abi.encodeWithSignature("createNFT(bytes)", Data));
416 		} else {
417 			(nft_created, nft_data) = _nftContract.delegatecall(abi.encodeWithSignature("createNFT(bytes)", Data));
418 		}
419 		require(nft_created,"V6 - NFT contract call failed");
420 
421 		nftID = uint256(bytesToBytes32(nft_data,0));
422 
423 		verifiedNFTs[nftID] = fileHash;
424 		fileHashes[fileHash].nft = nftID;
425 
426 		_balances[msg.sender] = _balances[msg.sender].sub(Payment);
427 		_balances[_validationWallet] = _balances[_validationWallet].add(Payment);
428 
429 		emit Transfer(msg.sender, _validationWallet, Payment);
430 		emit ValidateFile(index,fileHash,nftID);
431 		return true;
432 	}
433 
434 	function simpleValidateFile(uint256 Payment) external payable whenNotPaused returns (bool) {
435 		require(Payment >= _validationPrice || msg.value >= _validationFee,"V1 - Insufficient payment provided");
436 		require(verifiedPublishers[msg.sender],"V2 - Unverified publisher address");
437 
438 		_balances[msg.sender] = _balances[msg.sender].sub(Payment);
439 		_balances[_validationWallet] = _balances[_validationWallet].add(Payment);
440 
441 		emit Transfer(msg.sender, _validationWallet, Payment);
442 		return true;
443 	}
444 
445 	function covertValidateFile(uint256 Payment) external payable whenNotPaused returns (bool) {
446 		require(Payment >= _validationPrice || msg.value >= _validationFee,"V1 - Insufficient payment provided");
447 		require(verifiedPublishers[msg.sender],"V2 - Unverified publisher address");
448 
449 		_balances[msg.sender] = _balances[msg.sender].sub(Payment);
450 		_balances[_validationWallet] = _balances[_validationWallet].add(Payment);
451 		return true;
452 	}
453 
454 	function verifyFile(string memory fileHash) public view returns (bool verified) {
455 		verified = true;
456 		if (fileIndex.length == 0) {
457 			verified = false;
458 		}
459 		bytes memory a = bytes(fileIndex[fileHashes[fileHash].index]);
460 		bytes memory b = bytes(fileHash);
461 		if (a.length != b.length) {
462 			verified = false;
463 		}
464 		if (verified) {
465 		for (uint256 i = 0; i < a.length; i ++) {
466 			if (a[i] != b[i]) {
467 				verified = false;
468 			}
469 		} }
470 		if (!verified) {
471 			bool heritage_call = false;
472 			bytes memory heritage_data = "";
473 			(heritage_call, heritage_data) = oldContract.staticcall(abi.encodeWithSignature("verifyFile(string)", fileHash));
474 			require(heritage_call,"V0 - Old contract call failed");
475 			assembly {verified := mload(add(heritage_data, 32))}
476 		}
477 	}
478 
479 	function verifyPublisher(address _publisher) public view returns (bool verified) {
480 		verified = verifiedPublishers[_publisher];
481 	}
482 
483 	function verifyWallet(address _wallet) public view returns (bool verified) {
484 		verified = verifiedWallets[_wallet];
485 	}
486 
487 	function frozenAccount(address _account) public view returns (bool frozen) {
488 		frozen = frozenAccounts[_account];
489 	}
490 
491 	function verify(string memory fileHash) public view returns (bool) {
492 		if (fileIndex.length == 0) {
493 			return false;
494 		}
495 		bytes memory a = bytes(fileIndex[fileHashes[fileHash].index]);
496 		bytes memory b = bytes(fileHash);
497 		if (a.length != b.length) {
498 			return false;
499 		}
500 		for (uint256 i = 0; i < a.length; i ++) {
501 			if (a[i] != b[i]) {
502 				return false;
503 			}
504 		}
505 		return true;
506 	}
507 
508 	function verifyFileNFT(string memory fileHash) public view returns (uint256) {
509 		if (fileIndex.length == 0) {
510 			return 0;
511 		}
512 		bytes memory a = bytes(fileIndex[fileHashes[fileHash].index]);
513 		bytes memory b = bytes(fileHash);
514 		if (a.length != b.length) {
515 			return 0;
516 		}
517 		for (uint256 i = 0; i < a.length; i ++) {
518 			if (a[i] != b[i]) {
519 				return 0;
520 			}
521 		}
522 		return fileHashes[fileHash].nft;
523 	}
524 
525 	function verifyNFT(uint256 nftID) public view returns (string memory hash) {
526 		hash = verifiedNFTs[nftID];
527 	}
528 
529 	function setPrice(uint256 newPrice) public onlyOwner {
530 		_validationPrice = newPrice;
531 	}
532 
533 	function setFee(uint256 newFee) public onlyOwner {
534 		_validationFee = newFee;
535 	}
536 
537 	function setWallet(address newWallet) public onlyOwner {
538 		_validationWallet = newWallet;
539 	}
540 
541 	function setContracts(address nftContract, address nftdContract) public onlyOwner {
542 		_nftContract = nftContract;
543 		_nftdContract = nftdContract;
544 	}
545 
546 	function setPublic(bool _public) public onlyOwner {
547 		publicNFT = _public;
548 	}
549 
550 	function listFiles(uint256 startAt, uint256 stopAt) onlyOwner public returns (bool) {
551 		if (fileIndex.length == 0) {
552 			return false;
553 		}
554 		require(startAt <= fileIndex.length-1,"L1 - Please select a valid start");
555 		if (stopAt > 0) {
556 			require(stopAt > startAt && stopAt <= fileIndex.length-1,"L2 - Please select a valid stop");
557 		} else {
558 			stopAt = fileIndex.length-1;
559 		}
560 		for (uint256 i = startAt; i <= stopAt; i++) {
561 			emit ListFile(i,fileIndex[i],fileHashes[fileIndex[i]].nft);
562 		}
563 		return true;
564 	}
565 
566 	function withdraw(address payable _ownerAddress) onlyOwner external {
567 		_ownerAddress.transfer(address(this).balance);
568 	}
569 
570 	function validationPrice() public view returns (uint256) {
571 		return _validationPrice;
572 	}
573 
574 	function validationFee() public view returns (uint256) {
575 		return _validationFee;
576 	}
577 	
578 	function validationWallet() public view returns (address) {
579 		return _validationWallet;
580 	}
581 
582 	function nftContract() public view returns (address) {
583 		return _nftContract;
584 	}
585 
586 	function nftdContract() public view returns (address) {
587 		return _nftdContract;
588 	}
589 	
590 	event Freeze(address indexed target, bool indexed frozen);
591 	event ValidateFile(uint256 indexed index, string indexed data, uint256 indexed nftID);
592 	event ValidatePublisher(address indexed publisherAddress, bool indexed state, string indexed publisherName);
593 	event ValidateWallet(address indexed walletAddress, bool indexed state, string indexed walletName);
594 	event ListFile(uint256 indexed index, string indexed data, uint256 indexed nft) anonymous;
595 }