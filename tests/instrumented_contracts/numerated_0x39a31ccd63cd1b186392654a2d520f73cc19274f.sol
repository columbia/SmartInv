1 pragma solidity 0.4.24;
2 
3 contract ERC20 {
4 	function balanceOf(address who) public view returns (uint256);
5 
6 	function transfer(address to, uint256 value) public returns (bool);
7 
8 	function transferFrom(address _from, address _to, uint _value) external returns (bool);
9 }
10 
11 contract Ownable {
12 	address public owner = 0x345aCaFA4314Bc2479a3aA7cCf8eb47f223C1d0e;
13 
14 	modifier onlyOwner() {
15 		require(msg.sender == owner);
16 		_;
17 	}
18 }
19 
20 
21 /**
22  * @title Pausable
23  * @dev Base contract which allows children to implement an emergency stop mechanism.
24  */
25 contract Pausable is Ownable {
26 	event Pause();
27 
28 	event Unpause();
29 
30 	bool public paused = false;
31 
32 
33 	/**
34         * @dev modifier to allow actions only when the contract IS paused
35         */
36 	modifier whenNotPaused() {
37 		require(!paused);
38 		_;
39 	}
40 
41 	/**
42         * @dev modifier to allow actions only when the contract IS NOT paused
43         */
44 	modifier whenPaused() {
45 		require(paused);
46 		_;
47 	}
48 
49 	/**
50         * @dev called by the owner to pause, triggers stopped state
51         */
52 	function pause() public onlyOwner whenNotPaused {
53 		paused = true;
54 		emit Pause();
55 	}
56 
57 	/**
58         * @dev called by the owner to unpause, returns to normal state
59         */
60 	function unpause() public onlyOwner whenPaused {
61 		paused = false;
62 		emit Unpause();
63 	}
64 }
65 
66 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
67 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
68 contract ERC721 {
69 	// Required methods
70 	function totalSupply() public view returns (uint total);
71 
72 	function balanceOf(address owner) public view returns (uint balance);
73 
74 	function ownerOf(uint tokenId) external view returns (address owner);
75 
76 	function approve(address to, uint tokenId) external;
77 
78 	function transfer(address to, uint tokenId) public;
79 
80 	function transferFrom(address from, address to, uint tokenId) external;
81 
82 	// Events
83 	event Transfer(address indexed from, address indexed to, uint tokenId);
84 	event Approval(address indexed owner, address indexed approved, uint tokenId);
85 
86 	// Optional
87 	function name() public view returns (string);
88 
89 	function symbol() public view returns (string);
90 
91 	function tokensOfOwner(address owner) external view returns (uint[] tokenIds);
92 
93 	function tokenMetadata(uint tokenId, string preferredTransport) public view returns (string infoUrl);
94 
95 	// ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
96 	function supportsInterface(bytes4 contractID) external view returns (bool);
97 }
98 
99 
100 contract ERC721Metadata {
101 	function getMetadata(uint tokenId, string preferredTransport) public view returns (bytes32[4] buffer, uint count);
102 }
103 
104 contract CryptoversePreorderBonusAssets is Pausable, ERC721 {
105 
106 	struct Item {
107 		ItemType typeId;
108 		ItemModel model;
109 		ItemManufacturer manufacturer;
110 		ItemRarity rarity;
111 		uint createTime;
112 		uint amount;
113 	}
114 
115 	enum ItemType {VRCBox, VCXVault, SaiHead, SaiBody, SaiEarrings, MechHead, MechBody, MechLegs, MechRailgun, MechMachineGun, MechRocketLauncher}
116 
117 	enum ItemModel {NC01, MK1, V1, V1_1, V2_1, M442_1, BG, Q3, TRFL405, BC, DES1, PlasmaS, BD, DRL, Casper, Kilo, Mega, Giga, Tera, Peta, Exa, EA}
118 
119 	enum ItemManufacturer {BTC, VRC, ETH, Satoshipowered}
120 
121 	enum ItemRarity {Common, Uncommon, Rare, Superior, Epic, Legendary, Unique}
122 
123 	function name() public view returns (string){
124 		return "Cryptoverse Preorder Bonus Assets";
125 	}
126 
127 	function symbol() public view returns (string){
128 		return "CPBA";
129 	}
130 
131 	Item[] public items;
132 
133 	mapping(uint => address) public itemIndexToOwner;
134 
135 	mapping(address => uint) public ownershipTokenCount;
136 
137 	mapping(uint => address) public itemIndexToApproved;
138 
139 	function reclaimToken(ERC20 token) external onlyOwner {
140 		uint256 balance = token.balanceOf(this);
141 		token.transfer(owner, balance);
142 	}
143 
144 	function _transfer(address from, address to, uint tokenId) internal {
145 		ownershipTokenCount[from]--;
146 		ownershipTokenCount[to]++;
147 		itemIndexToOwner[tokenId] = to;
148 		delete itemIndexToApproved[tokenId];
149 
150 		emit Transfer(from, to, tokenId);
151 	}
152 
153 	event CreateItem(uint id, ItemType typeId, ItemModel model, ItemManufacturer manufacturer, ItemRarity rarity, uint createTime, uint amount, address indexed owner);
154 
155 	function createItem(ItemType typeId, ItemModel model, ItemManufacturer manufacturer, ItemRarity rarity, uint amount, address owner) internal returns (uint) {
156 		require(owner != address(0));
157 
158 		Item memory item = Item(typeId, model, manufacturer, rarity, now, amount);
159 
160 		uint newItemId = items.length;
161 
162 		items.push(item);
163 
164 		emit CreateItem(newItemId, typeId, model, manufacturer, rarity, now, amount, owner);
165 
166 		ownershipTokenCount[owner]++;
167 		itemIndexToOwner[newItemId] = owner;
168 
169 		return newItemId;
170 	}
171 
172 	function tokensOfOwner(address owner) external view returns (uint[] ownerTokens) {
173 		uint tokenCount = balanceOf(owner);
174 
175 		if (tokenCount == 0) {
176 			return new uint[](0);
177 		} else {
178 			ownerTokens = new uint[](tokenCount);
179 			uint totalItems = totalSupply();
180 			uint resultIndex = 0;
181 
182 			for (uint itemId = 0; itemId < totalItems; itemId++) {
183 				if (itemIndexToOwner[itemId] == owner) {
184 					ownerTokens[resultIndex] = itemId;
185 					resultIndex++;
186 				}
187 			}
188 
189 			return ownerTokens;
190 		}
191 	}
192 
193 	function tokensInfoOfOwner(address owner) external view returns (uint[] ownerTokens) {
194 		uint tokenCount = balanceOf(owner);
195 
196 		if (tokenCount == 0) {
197 			return new uint[](0);
198 		} else {
199 			ownerTokens = new uint[](tokenCount * 7);
200 			uint totalItems = totalSupply();
201 			uint k = 0;
202 
203 			for (uint itemId = 0; itemId < totalItems; itemId++) {
204 				if (itemIndexToOwner[itemId] == owner) {
205 					Item item = items[itemId];
206 					ownerTokens[k++] = itemId;
207 					ownerTokens[k++] = uint(item.typeId);
208 					ownerTokens[k++] = uint(item.model);
209 					ownerTokens[k++] = uint(item.manufacturer);
210 					ownerTokens[k++] = uint(item.rarity);
211 					ownerTokens[k++] = item.createTime;
212 					ownerTokens[k++] = item.amount;
213 				}
214 			}
215 
216 			return ownerTokens;
217 		}
218 	}
219 
220 	function tokenInfo(uint itemId) external view returns (uint[] ownerTokens) {
221 		ownerTokens = new uint[](7);
222 		uint k = 0;
223 
224 		Item item = items[itemId];
225 		ownerTokens[k++] = itemId;
226 		ownerTokens[k++] = uint(item.typeId);
227 		ownerTokens[k++] = uint(item.model);
228 		ownerTokens[k++] = uint(item.manufacturer);
229 		ownerTokens[k++] = uint(item.rarity);
230 		ownerTokens[k++] = item.createTime;
231 		ownerTokens[k++] = item.amount;
232 	}
233 
234 	ERC721Metadata public erc721Metadata;
235 
236 	bytes4 constant InterfaceSignature_ERC165 =
237 	bytes4(keccak256('supportsInterface(bytes4)'));
238 
239 	bytes4 constant InterfaceSignature_ERC721 =
240 	bytes4(keccak256('name()')) ^
241 	bytes4(keccak256('symbol()')) ^
242 	bytes4(keccak256('totalSupply()')) ^
243 	bytes4(keccak256('balanceOf(address)')) ^
244 	bytes4(keccak256('ownerOf(uint)')) ^
245 	bytes4(keccak256('approve(address,uint)')) ^
246 	bytes4(keccak256('transfer(address,uint)')) ^
247 	bytes4(keccak256('transferFrom(address,address,uint)')) ^
248 	bytes4(keccak256('tokensOfOwner(address)')) ^
249 	bytes4(keccak256('tokenMetadata(uint,string)'));
250 
251 	function supportsInterface(bytes4 contractID) external view returns (bool)
252 	{
253 		return ((contractID == InterfaceSignature_ERC165) || (contractID == InterfaceSignature_ERC721));
254 	}
255 
256 	function setMetadataAddress(address contractAddress) public onlyOwner {
257 		erc721Metadata = ERC721Metadata(contractAddress);
258 	}
259 
260 	function _owns(address claimant, uint tokenId) internal view returns (bool) {
261 		return itemIndexToOwner[tokenId] == claimant;
262 	}
263 
264 	function _approvedFor(address claimant, uint tokenId) internal view returns (bool) {
265 		return itemIndexToApproved[tokenId] == claimant;
266 	}
267 
268 	function _approve(uint tokenId, address approved) internal {
269 		itemIndexToApproved[tokenId] = approved;
270 	}
271 
272 	function balanceOf(address owner) public view returns (uint count) {
273 		return ownershipTokenCount[owner];
274 	}
275 
276 	function transfer(address to, uint tokenId) public {
277 		require(to != address(0));
278 		require(_owns(msg.sender, tokenId));
279 		require(!_owns(to, tokenId));
280 		_transfer(msg.sender, to, tokenId);
281 	}
282 
283 	function approve(address to, uint tokenId) external {
284 		require(_owns(msg.sender, tokenId));
285 		_approve(tokenId, to);
286 		emit Approval(msg.sender, to, tokenId);
287 	}
288 
289 	function transferFrom(address from, address to, uint tokenId) external {
290 		require(to != address(0));
291 		require(to != address(this));
292 		require(_approvedFor(msg.sender, tokenId));
293 		require(_owns(from, tokenId));
294 		_transfer(from, to, tokenId);
295 	}
296 
297 	function totalSupply() public view returns (uint) {
298 		return items.length;
299 	}
300 
301 	function ownerOf(uint tokenId) external view returns (address owner)   {
302 		owner = itemIndexToOwner[tokenId];
303 
304 		require(owner != address(0));
305 	}
306 
307 	/// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
308 	///  This method is licenced under the Apache License.
309 	///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
310 	function _memcpy(uint _dest, uint _src, uint _len) private pure {
311 		// Copy word-length chunks while possible
312 		for (; _len >= 32; _len -= 32) {
313 			assembly {
314 				mstore(_dest, mload(_src))
315 			}
316 			_dest += 32;
317 			_src += 32;
318 		}
319 
320 		// Copy remaining bytes
321 		uint mask = 256 ** (32 - _len) - 1;
322 		assembly {
323 			let srcpart := and(mload(_src), not(mask))
324 			let destpart := and(mload(_dest), mask)
325 			mstore(_dest, or(destpart, srcpart))
326 		}
327 	}
328 
329 	/// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
330 	///  This method is licenced under the Apache License.
331 	///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
332 	function _toString(bytes32[4] _rawBytes, uint _stringLength) private pure returns (string) {
333 		var outputString = new string(_stringLength);
334 		uint outputPtr;
335 		uint bytesPtr;
336 
337 		assembly {
338 			outputPtr := add(outputString, 32)
339 			bytesPtr := _rawBytes
340 		}
341 
342 		_memcpy(outputPtr, bytesPtr, _stringLength);
343 
344 		return outputString;
345 	}
346 
347 	/// @notice Returns a URI pointing to a metadata package for this token conforming to
348 	///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
349 	/// @param _tokenId The ID number of the Kitty whose metadata should be returned.
350 	function tokenMetadata(uint _tokenId, string _preferredTransport) public view returns (string infoUrl) {
351 		require(erc721Metadata != address(0));
352 		bytes32[4] memory buffer;
353 		uint count;
354 		(buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
355 
356 		return _toString(buffer, count);
357 	}
358 }
359 
360 contract CryptoversePreorder is CryptoversePreorderBonusAssets {
361 
362 	ERC20 public vrc;
363 	ERC20 public vcx;
364 
365 	address public vrcWallet;
366 	address public vcxWallet;
367 
368 	uint public vrcCount;
369 	uint public vcxCount;
370 
371 	uint public weiRaised;
372 
373 	uint public constant minInvest = 0.1 ether;
374 
375 	uint public contributorsCompleteCount;
376 
377 	mapping(address => uint) public contributorBalance;
378 	mapping(address => bool) public contributorComplete;
379 	mapping(address => uint) public contributorWhiteListTime;
380 
381 	uint public constant hardCap = 50000 ether;
382 
383 	address[] public contributors;
384 
385 	event Purchase(address indexed contributor, uint weiAmount);
386 
387 	function() public payable {
388 		buyTokens(msg.sender);
389 	}
390 
391 	function createSaiLimitedEdition(uint weiAmount, address contributor) private {
392 		createItem(ItemType.SaiHead, ItemModel.M442_1, ItemManufacturer.Satoshipowered, ItemRarity.Epic, weiAmount, contributor);
393 		createItem(ItemType.SaiBody, ItemModel.M442_1, ItemManufacturer.Satoshipowered, ItemRarity.Epic, weiAmount, contributor);
394 		createItem(ItemType.SaiEarrings, ItemModel.V1_1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
395 	}
396 
397 	function createSaiCollectorsEdition(uint weiAmount, address contributor) private {
398 		createItem(ItemType.SaiHead, ItemModel.V2_1, ItemManufacturer.Satoshipowered, ItemRarity.Legendary, weiAmount, contributor);
399 		createItem(ItemType.SaiBody, ItemModel.V2_1, ItemManufacturer.Satoshipowered, ItemRarity.Legendary, weiAmount, contributor);
400 		createItem(ItemType.SaiEarrings, ItemModel.V1_1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
401 	}
402 
403 	function createSaiFoundersEdition(uint weiAmount, address contributor) private {
404 		createItem(ItemType.SaiHead, ItemModel.V1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
405 		createItem(ItemType.SaiBody, ItemModel.V1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
406 		createItem(ItemType.SaiEarrings, ItemModel.V1_1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
407 	}
408 
409 	function createVRCBox(ItemModel model, uint weiAmount, address contributor) private {
410 		createItem(ItemType.VRCBox, model, ItemManufacturer.Satoshipowered, ItemRarity.Legendary, weiAmount, contributor);
411 	}
412 
413 	function createVCXVault(uint weiAmount, address contributor) private {
414 		createItem(ItemType.VCXVault, ItemModel.EA, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
415 	}
416 
417 	function createMechBTC(uint weiAmount, address contributor) private {
418 		createItem(ItemType.MechHead, ItemModel.NC01, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
419 		createItem(ItemType.MechBody, ItemModel.NC01, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
420 		createItem(ItemType.MechLegs, ItemModel.NC01, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
421 		createItem(ItemType.MechRailgun, ItemModel.BG, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
422 		createItem(ItemType.MechMachineGun, ItemModel.BC, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
423 		createItem(ItemType.MechRocketLauncher, ItemModel.BD, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
424 	}
425 
426 	function createMechVRC(uint weiAmount, address contributor) private {
427 		createItem(ItemType.MechHead, ItemModel.MK1, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
428 		createItem(ItemType.MechBody, ItemModel.MK1, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
429 		createItem(ItemType.MechLegs, ItemModel.MK1, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
430 		createItem(ItemType.MechRailgun, ItemModel.Q3, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
431 		createItem(ItemType.MechMachineGun, ItemModel.DES1, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
432 		createItem(ItemType.MechRocketLauncher, ItemModel.DRL, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
433 	}
434 
435 	function createMechETH(uint weiAmount, address contributor) private {
436 		createItem(ItemType.MechHead, ItemModel.V1, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
437 		createItem(ItemType.MechBody, ItemModel.V1, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
438 		createItem(ItemType.MechLegs, ItemModel.V1, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
439 		createItem(ItemType.MechRailgun, ItemModel.TRFL405, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
440 		createItem(ItemType.MechMachineGun, ItemModel.PlasmaS, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
441 		createItem(ItemType.MechRocketLauncher, ItemModel.Casper, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
442 	}
443 
444 	function buyTokens(address contributor) public whenNotPaused payable {
445 		require(contributor != address(0));
446 
447 		uint weiAmount = msg.value;
448 
449 		require(weiAmount >= minInvest);
450 
451 		weiRaised += weiAmount;
452 
453 		require(weiRaised <= hardCap);
454 
455 		emit Purchase(contributor, weiAmount);
456 
457 		if (contributorBalance[contributor] == 0) {
458 			contributors.push(contributor);
459 			contributorBalance[contributor] += weiAmount;
460 			contributorWhiteListTime[contributor] = now;
461 		} else {
462 			require(!contributorComplete[contributor]);
463 			require(weiAmount >= contributorBalance[contributor] * 99);
464 
465 			bool hasBonus = (now - contributorWhiteListTime[contributor]) < 72 hours;
466 
467 			contributorBalance[contributor] += weiAmount;
468 			sendTokens(contributorBalance[contributor], contributor, hasBonus);
469 
470 			contributorComplete[contributor] = true;
471 			contributorsCompleteCount++;
472 		}
473 	}
474 
475 	function sendTokens(uint balance, address contributor, bool hasBonus) private {
476 
477 		if (balance < 40 ether) {
478 			createMechBTC(balance, contributor);
479 			createSaiLimitedEdition(balance, contributor);
480 			createVRCBox(ItemModel.Kilo, balance, contributor);
481 			createVCXVault(balance, contributor);
482 
483 		} else if (balance < 100 ether) {
484 			createMechBTC(balance, contributor);
485 			createMechVRC(balance, contributor);
486 			createSaiLimitedEdition(balance, contributor);
487 
488 			createVRCBox(ItemModel.Mega, hasBonus ? (balance * 105 / 100) : balance, contributor);
489 			createVCXVault(balance, contributor);
490 
491 		} else if (balance < 500 ether) {
492 			createMechBTC(balance, contributor);
493 			createMechVRC(balance, contributor);
494 			createMechETH(balance, contributor);
495 			createSaiCollectorsEdition(balance, contributor);
496 
497 			createVRCBox(ItemModel.Giga, hasBonus ? (balance * 110 / 100) : balance, contributor);
498 			createVCXVault(balance, contributor);
499 
500 		} else if (balance < 1000 ether) {
501 
502 			createMechBTC(balance, contributor);
503 			createMechVRC(balance, contributor);
504 			createMechETH(balance, contributor);
505 			createSaiCollectorsEdition(balance, contributor);
506 
507 			createVRCBox(ItemModel.Tera, hasBonus ? (balance * 115 / 100) : balance, contributor);
508 			createVCXVault(balance, contributor);
509 
510 		} else if (balance < 5000 ether) {
511 
512 			createMechBTC(balance, contributor);
513 			createMechVRC(balance, contributor);
514 			createMechETH(balance, contributor);
515 			createSaiFoundersEdition(balance, contributor);
516 
517 
518 			createVRCBox(ItemModel.Peta, hasBonus ? (balance * 120 / 100) : balance, contributor);
519 			createVCXVault(balance, contributor);
520 
521 		} else if (balance >= 5000 ether) {
522 
523 			createMechBTC(balance, contributor);
524 			createMechVRC(balance, contributor);
525 			createMechETH(balance, contributor);
526 			createSaiFoundersEdition(balance, contributor);
527 
528 
529 			createVRCBox(ItemModel.Exa, hasBonus ? (balance * 135 / 100) : balance, contributor);
530 			createVCXVault(balance, contributor);
531 
532 		}
533 	}
534 
535 	function withdrawal(uint amount) public onlyOwner {
536 		owner.transfer(amount);
537 	}
538 
539 	function contributorsCount() public view returns (uint){
540 		return contributors.length;
541 	}
542 
543 	function setVRC(address _vrc, address _vrcWallet, uint _vrcCount) public onlyOwner {
544 		require(_vrc != address(0));
545 		require(_vrcWallet != address(0));
546 		require(_vrcCount > 0);
547 
548 		vrc = ERC20(_vrc);
549 		vrcWallet = _vrcWallet;
550 		vrcCount = _vrcCount;
551 	}
552 
553 	function setVCX(address _vcx, address _vcxWallet, uint _vcxCount) public onlyOwner {
554 		require(_vcx != address(0));
555 		require(_vcxWallet != address(0));
556 		require(_vcxCount > 0);
557 
558 		vcx = ERC20(_vcx);
559 		vcxWallet = _vcxWallet;
560 		vcxCount = _vcxCount;
561 	}
562 
563 	function getBoxes(address contributor) public view returns (uint[] boxes) {
564 		uint tokenCount = balanceOf(contributor);
565 
566 		if (tokenCount == 0) {
567 			return new uint[](0);
568 		} else {
569 			uint[] memory _boxes = new uint[](tokenCount);
570 			uint totalItems = totalSupply();
571 			uint n = 0;
572 
573 			for (uint itemId = 0; itemId < totalItems; itemId++) {
574 				if (itemIndexToOwner[itemId] == contributor && isBoxItemId(itemId)) {
575 					_boxes[n++] = itemId;
576 				}
577 			}
578 
579 			boxes = new uint[](n);
580 
581 			for (uint i = 0; i < n; i++) {
582 				boxes[i] = _boxes[i];
583 			}
584 			return boxes;
585 		}
586 	}
587 
588 	function isBox(Item item) private pure returns (bool){
589 		return item.typeId == ItemType.VRCBox || item.typeId == ItemType.VCXVault;
590 	}
591 
592 	function isBoxItemId(uint itemId) public view returns (bool){
593 		return isBox(items[itemId]);
594 	}
595 
596 	function openBoxes(uint[] itemIds) public {
597 		for (uint i = 0; i < itemIds.length; i++) {
598 			uint itemId = itemIds[i];
599 			Item storage item = items[itemId];
600 			require(isBox(item));
601 
602 			transfer(this, itemId);
603 
604 			if (item.typeId == ItemType.VRCBox) {
605 				vrc.transferFrom(vrcWallet, msg.sender, item.amount * vrcCount / weiRaised);
606 			} else {
607 				vcx.transferFrom(vcxWallet, msg.sender, item.amount * vcxCount / weiRaised);
608 			}
609 		}
610 	}
611 }