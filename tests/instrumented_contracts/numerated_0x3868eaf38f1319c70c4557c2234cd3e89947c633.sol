1 pragma solidity 0.4.20;
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
12 	address public owner = 0x045dCD3419273C8BF7ca88563Fc25725Acf93Ae9;
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
34 		* @dev modifier to allow actions only when the contract IS paused
35 		*/
36 	modifier whenNotPaused() {
37 		require(!paused);
38 		_;
39 	}
40 
41 	/**
42 		* @dev modifier to allow actions only when the contract IS NOT paused
43 		*/
44 	modifier whenPaused() {
45 		require(paused);
46 		_;
47 	}
48 
49 	/**
50 		* @dev called by the owner to pause, triggers stopped state
51 		*/
52 	function pause() public onlyOwner whenNotPaused {
53 		paused = true;
54 		Pause();
55 	}
56 
57 	/**
58 		* @dev called by the owner to unpause, returns to normal state
59 		*/
60 	function unpause() public onlyOwner whenPaused {
61 		paused = false;
62 		Unpause();
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
150 		Transfer(from, to, tokenId);
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
164 		CreateItem(newItemId, typeId, model, manufacturer, rarity, now, amount, owner);
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
193 	ERC721Metadata public erc721Metadata;
194 
195 	bytes4 constant InterfaceSignature_ERC165 =
196 	bytes4(keccak256('supportsInterface(bytes4)'));
197 
198 	bytes4 constant InterfaceSignature_ERC721 =
199 	bytes4(keccak256('name()')) ^
200 	bytes4(keccak256('symbol()')) ^
201 	bytes4(keccak256('totalSupply()')) ^
202 	bytes4(keccak256('balanceOf(address)')) ^
203 	bytes4(keccak256('ownerOf(uint)')) ^
204 	bytes4(keccak256('approve(address,uint)')) ^
205 	bytes4(keccak256('transfer(address,uint)')) ^
206 	bytes4(keccak256('transferFrom(address,address,uint)')) ^
207 	bytes4(keccak256('tokensOfOwner(address)')) ^
208 	bytes4(keccak256('tokenMetadata(uint,string)'));
209 
210 	function supportsInterface(bytes4 contractID) external view returns (bool)
211 	{
212 		return ((contractID == InterfaceSignature_ERC165) || (contractID == InterfaceSignature_ERC721));
213 	}
214 
215 	function setMetadataAddress(address contractAddress) public onlyOwner {
216 		erc721Metadata = ERC721Metadata(contractAddress);
217 	}
218 
219 	function _owns(address claimant, uint tokenId) internal view returns (bool) {
220 		return itemIndexToOwner[tokenId] == claimant;
221 	}
222 
223 	function _approvedFor(address claimant, uint tokenId) internal view returns (bool) {
224 		return itemIndexToApproved[tokenId] == claimant;
225 	}
226 
227 	function _approve(uint tokenId, address approved) internal {
228 		itemIndexToApproved[tokenId] = approved;
229 	}
230 
231 	function balanceOf(address owner) public view returns (uint count) {
232 		return ownershipTokenCount[owner];
233 	}
234 
235 	function transfer(address to, uint tokenId) public {
236 		require(to != address(0));
237 		require(_owns(msg.sender, tokenId));
238 		require(!_owns(to, tokenId));
239 		_transfer(msg.sender, to, tokenId);
240 	}
241 
242 	function approve(address to, uint tokenId) external {
243 		require(_owns(msg.sender, tokenId));
244 		_approve(tokenId, to);
245 		Approval(msg.sender, to, tokenId);
246 	}
247 
248 	function transferFrom(address from, address to, uint tokenId) external {
249 		require(to != address(0));
250 		require(to != address(this));
251 		require(_approvedFor(msg.sender, tokenId));
252 		require(_owns(from, tokenId));
253 		_transfer(from, to, tokenId);
254 	}
255 
256 	function totalSupply() public view returns (uint) {
257 		return items.length;
258 	}
259 
260 	function ownerOf(uint tokenId) external view returns (address owner)   {
261 		owner = itemIndexToOwner[tokenId];
262 
263 		require(owner != address(0));
264 	}
265 
266 	/// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
267 	///  This method is licenced under the Apache License.
268 	///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
269 	function _memcpy(uint _dest, uint _src, uint _len) private pure {
270 		// Copy word-length chunks while possible
271 		for (; _len >= 32; _len -= 32) {
272 			assembly {
273 				mstore(_dest, mload(_src))
274 			}
275 			_dest += 32;
276 			_src += 32;
277 		}
278 
279 		// Copy remaining bytes
280 		uint mask = 256 ** (32 - _len) - 1;
281 		assembly {
282 			let srcpart := and(mload(_src), not(mask))
283 			let destpart := and(mload(_dest), mask)
284 			mstore(_dest, or(destpart, srcpart))
285 		}
286 	}
287 
288 	/// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
289 	///  This method is licenced under the Apache License.
290 	///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
291 	function _toString(bytes32[4] _rawBytes, uint _stringLength) private pure returns (string) {
292 		var outputString = new string(_stringLength);
293 		uint outputPtr;
294 		uint bytesPtr;
295 
296 		assembly {
297 			outputPtr := add(outputString, 32)
298 			bytesPtr := _rawBytes
299 		}
300 
301 		_memcpy(outputPtr, bytesPtr, _stringLength);
302 
303 		return outputString;
304 	}
305 
306 	/// @notice Returns a URI pointing to a metadata package for this token conforming to
307 	///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
308 	/// @param _tokenId The ID number of the Kitty whose metadata should be returned.
309 	function tokenMetadata(uint _tokenId, string _preferredTransport) public view returns (string infoUrl) {
310 		require(erc721Metadata != address(0));
311 		bytes32[4] memory buffer;
312 		uint count;
313 		(buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
314 
315 		return _toString(buffer, count);
316 	}
317 }
318 
319 contract CryptoversePreorder is CryptoversePreorderBonusAssets {
320 
321 	ERC20 public vrc;
322 	ERC20 public vcx;
323 
324 	address public vrcWallet;
325 	address public vcxWallet;
326 
327 	uint public vrcCount;
328 	uint public vcxCount;
329 
330 	uint public weiRaised;
331 
332 	uint public constant minInvest = 100 ether;
333 
334 	uint public constant target = 10000 ether;
335 
336 	uint public constant hardCap = 50000 ether;
337 
338 	uint public startTime = 1519153200; // 20 February 2018 19:00 UTC
339 
340 	uint public endTime = startTime + 60 days;
341 
342 	uint public targetTime = 0;
343 
344 	mapping(address => uint) public contributorBalance;
345 
346 	address[] public contributors;
347 
348 	event Purchase(address indexed contributor, uint weiAmount);
349 
350 	function() public payable {
351 		buyTokens(msg.sender);
352 	}
353 
354 	function createSaiLimitedEdition(uint weiAmount, address contributor) private {
355 		createItem(ItemType.SaiHead, ItemModel.M442_1, ItemManufacturer.Satoshipowered, ItemRarity.Epic, weiAmount, contributor);
356 		createItem(ItemType.SaiBody, ItemModel.M442_1, ItemManufacturer.Satoshipowered, ItemRarity.Epic, weiAmount, contributor);
357 		createItem(ItemType.SaiEarrings, ItemModel.V1_1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
358 	}
359 
360 	function createSaiCollectorsEdition(uint weiAmount, address contributor) private {
361 		createItem(ItemType.SaiHead, ItemModel.V2_1, ItemManufacturer.Satoshipowered, ItemRarity.Legendary, weiAmount, contributor);
362 		createItem(ItemType.SaiBody, ItemModel.V2_1, ItemManufacturer.Satoshipowered, ItemRarity.Legendary, weiAmount, contributor);
363 		createItem(ItemType.SaiEarrings, ItemModel.V1_1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
364 	}
365 
366 	function createSaiFoundersEdition(uint weiAmount, address contributor) private {
367 		createItem(ItemType.SaiHead, ItemModel.V1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
368 		createItem(ItemType.SaiBody, ItemModel.V1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
369 		createItem(ItemType.SaiEarrings, ItemModel.V1_1, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
370 	}
371 
372 	function createVRCBox(ItemModel model, uint weiAmount, address contributor) private {
373 		createItem(ItemType.VRCBox, model, ItemManufacturer.Satoshipowered, ItemRarity.Legendary, weiAmount, contributor);
374 	}
375 
376 	function createVCXVault(uint weiAmount, address contributor) private {
377 		createItem(ItemType.VCXVault, ItemModel.EA, ItemManufacturer.Satoshipowered, ItemRarity.Unique, weiAmount, contributor);
378 	}
379 
380 	function createMechBTC(uint weiAmount, address contributor) private {
381 		createItem(ItemType.MechHead, ItemModel.NC01, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
382 		createItem(ItemType.MechBody, ItemModel.NC01, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
383 		createItem(ItemType.MechLegs, ItemModel.NC01, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
384 		createItem(ItemType.MechRailgun, ItemModel.BG, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
385 		createItem(ItemType.MechMachineGun, ItemModel.BC, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
386 		createItem(ItemType.MechRocketLauncher, ItemModel.BD, ItemManufacturer.BTC, ItemRarity.Epic, weiAmount, contributor);
387 	}
388 
389 	function createMechVRC(uint weiAmount, address contributor) private {
390 		createItem(ItemType.MechHead, ItemModel.MK1, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
391 		createItem(ItemType.MechBody, ItemModel.MK1, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
392 		createItem(ItemType.MechLegs, ItemModel.MK1, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
393 		createItem(ItemType.MechRailgun, ItemModel.Q3, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
394 		createItem(ItemType.MechMachineGun, ItemModel.DES1, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
395 		createItem(ItemType.MechRocketLauncher, ItemModel.DRL, ItemManufacturer.VRC, ItemRarity.Legendary, weiAmount, contributor);
396 	}
397 
398 	function createMechETH(uint weiAmount, address contributor) private {
399 		createItem(ItemType.MechHead, ItemModel.V1, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
400 		createItem(ItemType.MechBody, ItemModel.V1, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
401 		createItem(ItemType.MechLegs, ItemModel.V1, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
402 		createItem(ItemType.MechRailgun, ItemModel.TRFL405, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
403 		createItem(ItemType.MechMachineGun, ItemModel.PlasmaS, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
404 		createItem(ItemType.MechRocketLauncher, ItemModel.Casper, ItemManufacturer.ETH, ItemRarity.Unique, weiAmount, contributor);
405 	}
406 
407 	function buyTokens(address contributor) public whenNotPaused payable {
408 		require(startTime <= now && now <= endTime);
409 		require(contributor != address(0));
410 
411 		uint weiAmount = msg.value;
412 
413 		require(weiAmount >= minInvest);
414 
415 		weiRaised += weiAmount;
416 
417 		require(weiRaised <= hardCap);
418 
419 		if (weiRaised >= target && targetTime == 0) {
420 			targetTime = now;
421 			endTime = targetTime + 2 weeks;
422 		}
423 
424 		Purchase(contributor, weiAmount);
425 
426 		if (contributorBalance[contributor] == 0) contributors.push(contributor);
427 		contributorBalance[contributor] += weiAmount;
428 
429 		if (weiAmount < 500 ether) {
430 
431 			createSaiLimitedEdition(weiAmount, contributor);
432 			createVRCBox(ItemModel.Kilo, weiAmount, contributor);
433 			createVCXVault(weiAmount, contributor);
434 
435 		} else if (weiAmount < 1000 ether) {
436 
437 			createSaiLimitedEdition(weiAmount, contributor);
438 			createMechBTC(weiAmount, contributor);
439 			createVRCBox(ItemModel.Mega, weiAmount, contributor);
440 			createVCXVault(weiAmount, contributor);
441 
442 		} else if (weiAmount < 2500 ether) {
443 
444 			createSaiCollectorsEdition(weiAmount, contributor);
445 			createMechBTC(weiAmount, contributor);
446 			createMechVRC(weiAmount, contributor);
447 			createVRCBox(ItemModel.Giga, weiAmount, contributor);
448 			createVCXVault(weiAmount, contributor);
449 
450 		} else if (weiAmount < 5000 ether) {
451 
452 			createSaiCollectorsEdition(weiAmount, contributor);
453 			createMechBTC(weiAmount, contributor);
454 			createMechVRC(weiAmount, contributor);
455 			createVRCBox(ItemModel.Tera, weiAmount, contributor);
456 			createVCXVault(weiAmount, contributor);
457 
458 		} else if (weiAmount < 9000 ether) {
459 
460 			createSaiFoundersEdition(weiAmount, contributor);
461 			createMechBTC(weiAmount, contributor);
462 			createMechVRC(weiAmount, contributor);
463 			createVRCBox(ItemModel.Peta, weiAmount, contributor);
464 			createVCXVault(weiAmount, contributor);
465 
466 		} else if (weiAmount >= 9000 ether) {
467 
468 			createSaiFoundersEdition(weiAmount, contributor);
469 			createMechBTC(weiAmount, contributor);
470 			createMechVRC(weiAmount, contributor);
471 			createMechETH(weiAmount, contributor);
472 			createVRCBox(ItemModel.Exa, weiAmount, contributor);
473 			createVCXVault(weiAmount, contributor);
474 
475 		}
476 	}
477 
478 	function withdrawal(uint amount) public onlyOwner {
479 		owner.transfer(amount);
480 	}
481 
482 	function contributorsCount() public view returns (uint){
483 		return contributors.length;
484 	}
485 
486 	function setVRC(address _vrc, address _vrcWallet, uint _vrcCount) public onlyOwner {
487 		require(_vrc != address(0));
488 		require(_vrcWallet != address(0));
489 		require(_vrcCount > 0);
490 
491 		vrc = ERC20(_vrc);
492 		vrcWallet = _vrcWallet;
493 		vrcCount = _vrcCount;
494 	}
495 
496 	function setVCX(address _vcx, address _vcxWallet, uint _vcxCount) public onlyOwner {
497 		require(_vcx != address(0));
498 		require(_vcxWallet != address(0));
499 		require(_vcxCount > 0);
500 
501 		vcx = ERC20(_vcx);
502 		vcxWallet = _vcxWallet;
503 		vcxCount = _vcxCount;
504 	}
505 
506 	function getBoxes(address contributor) public view returns (uint[] boxes) {
507 		uint tokenCount = balanceOf(contributor);
508 
509 		if (tokenCount == 0) {
510 			return new uint[](0);
511 		} else {
512 			uint[] memory _boxes = new uint[](tokenCount);
513 			uint totalItems = totalSupply();
514 			uint n = 0;
515 
516 			for (uint itemId = 0; itemId < totalItems; itemId++) {
517 				if (itemIndexToOwner[itemId] == contributor && isBoxItemId(itemId)) {
518 					_boxes[n++] = itemId;
519 				}
520 			}
521 
522 			boxes = new uint[](n);
523 
524 			for (uint i = 0; i < n; i++) {
525 				boxes[i] = _boxes[i];
526 			}
527 			return boxes;
528 		}
529 	}
530 
531 	function isBox(Item item) private pure returns (bool){
532 		return item.typeId == ItemType.VRCBox || item.typeId == ItemType.VCXVault;
533 	}
534 
535 	function isBoxItemId(uint itemId) public view returns (bool){
536 		return isBox(items[itemId]);
537 	} 
538 
539 	function openBoxes(uint[] itemIds) public {
540 		for (uint i = 0; i < itemIds.length; i++) {
541 			uint itemId = itemIds[i];
542 			Item storage item = items[itemId];
543 			require(isBox(item));
544 
545 			transfer(this, itemId);
546 
547 			if (item.typeId == ItemType.VRCBox) {
548 				vrc.transferFrom(vrcWallet, msg.sender, item.amount * vrcCount / weiRaised);
549 			} else {
550 				vcx.transferFrom(vcxWallet, msg.sender, item.amount * vcxCount / weiRaised);
551 			}
552 		}
553 	}
554 }