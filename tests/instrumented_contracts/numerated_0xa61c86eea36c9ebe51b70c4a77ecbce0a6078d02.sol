1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() public {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 
15   function transferOwnership(address newOwner) public onlyOwner {
16     if (newOwner != address(0)) {
17       owner = newOwner;
18     }
19   }
20 }
21 
22 contract Pausable is Ownable {
23   event Pause();
24   event Unpause();
25 
26   bool public paused = false;
27 
28   modifier whenNotPaused() {
29     require(!paused);
30     _;
31   }
32 
33   modifier whenPaused {
34     require(paused);
35     _;
36   }
37 
38   function pause() public onlyOwner whenNotPaused returns (bool) {
39     paused = true;
40     Pause();
41     return true;
42   }
43 
44   function unpause() public onlyOwner whenPaused returns (bool) {
45     paused = false;
46     Unpause();
47     return true;
48   }
49 }
50 
51 contract TrueloveAccessControl {
52   event ContractUpgrade(address newContract);
53 
54   address public ceoAddress;
55   address public cfoAddress;
56   address public cooAddress;
57 
58   bool public paused = false;
59 
60   modifier onlyCEO() {
61     require(msg.sender == ceoAddress);
62     _;
63   }
64 
65   modifier onlyCFO() {
66     require(msg.sender == cfoAddress);
67     _;
68   }
69 
70   modifier onlyCOO() {
71     require(msg.sender == cooAddress);
72     _;
73   }
74 
75   modifier onlyCLevel() {
76     require(
77       msg.sender == cooAddress ||
78       msg.sender == ceoAddress ||
79       msg.sender == cfoAddress
80     );
81     _;
82   }
83 
84   function setCEO(address _newCEO) external onlyCEO {
85     require(_newCEO != address(0));
86 
87     ceoAddress = _newCEO;
88   }
89 
90   function setCFO(address _newCFO) external onlyCEO {
91     require(_newCFO != address(0));
92 
93     cfoAddress = _newCFO;
94   }
95 
96   function setCOO(address _newCOO) external onlyCEO {
97     require(_newCOO != address(0));
98 
99     cooAddress = _newCOO;
100   }
101 
102   modifier whenNotPaused() {
103     require(!paused);
104     _;
105   }
106 
107   modifier whenPaused {
108     require(paused);
109     _;
110   }
111 
112   function pause() external onlyCLevel whenNotPaused {
113     paused = true;
114   }
115 
116   function unpause() public onlyCEO whenPaused {
117     paused = false;
118   }
119 }
120 
121 contract TrueloveBase is TrueloveAccessControl {
122 	Diamond[] diamonds;
123 	mapping (uint256 => address) public diamondIndexToOwner;
124 	mapping (address => uint256) ownershipTokenCount;
125 	mapping (uint256 => address) public diamondIndexToApproved;
126 
127 	mapping (address => uint256) public flowerBalances;
128 
129 	struct Diamond {
130 		bytes24 model;
131 		uint16 year;
132 		uint16 no;
133 		uint activateAt;
134 	}
135 
136 	struct Model {
137 		bytes24 model;
138 		uint current;
139 		uint total;
140 		uint16 year;
141 		uint256 price;
142 	}
143 
144 	Model diamond1;
145 	Model diamond2;
146 	Model diamond3;
147 	Model flower;
148 
149 	uint sendGiftPrice;
150 	uint beginSaleTime;
151 	uint nextSaleTime;
152 	uint registerPrice;
153 
154 	DiamondAuction public diamondAuction;
155 	FlowerAuction public flowerAuction;
156 
157 	function TrueloveBase() internal {
158 		sendGiftPrice = 0.001 ether; // MARK: Modify it
159 		registerPrice = 0.01 ether; // MARK: Modify it
160 		_setVars();
161 
162 		diamond1 = Model({model: "OnlyOne", current: 0, total: 1, year: 2018, price: 1000 ether}); // MARK: Modify it
163 		diamond2 = Model({model: "Eternity2018", current: 0, total: 5, year: 2018, price: 50 ether}); // MARK: Modify it
164 		diamond3 = Model({model: "Memorial", current: 0, total: 1000, year: 2018, price: 1 ether}); // MARK: Modify it
165 		flower = Model({model: "MySassyGirl", current: 0, total: 10000000, year: 2018, price: 0.01 ether}); // MARK: Modify it
166 	}
167 
168 	function _setVars() internal {
169 		beginSaleTime = now;
170 		nextSaleTime = beginSaleTime + 300 days; // MARK: Modify it
171 	}
172 
173 	function setSendGiftPrice(uint _sendGiftPrice) external onlyCOO {
174 		sendGiftPrice = _sendGiftPrice;
175 	}
176 
177 	function setRegisterPrice(uint _registerPrice) external onlyCOO {
178 		registerPrice = _registerPrice;
179 	}
180 
181 	function _getModel(uint _index) internal view returns(Model storage) {
182 		if (_index == 1) {
183 			return diamond1;
184 		} else if (_index == 2) {
185 			return diamond2;
186 		} else if (_index == 3) {
187 			return diamond3;
188 		} else if (_index == 4) {
189 			return flower;
190 		}
191 		revert();
192 	}
193 	function getModel(uint _index) external view returns(
194 		bytes24 model,
195 		uint current,
196 		uint total,
197 		uint16 year,
198 		uint256 price
199 	) {
200 		Model storage _model = _getModel(_index);
201 		model = _model.model;
202 		current = _model.current;
203 		total = _model.total;
204 		year = _model.year;
205 		price = _model.price;
206 	}
207 }
208 
209 contract EIP20Interface {
210     /* This is a slight change to the ERC20 base standard.
211     function totalSupply() constant returns (uint256 supply);
212     is replaced with:
213     uint256 public totalSupply;
214     This automatically creates a getter function for the totalSupply.
215     This is moved to the base contract since public getter functions are not
216     currently recognised as an implementation of the matching abstract
217     function by the compiler.
218     */
219     /// total amount of tokens
220     uint256 public flowerTotalSupply;
221 
222     /// @param _owner The address from which the balance will be retrieved
223     /// @return The balance
224     function balanceOfFlower(address _owner) public view returns (uint256 balance);
225 
226     /// @notice send `_value` token to `_to` from `msg.sender`
227     /// @param _to The address of the recipient
228     /// @param _value The amount of token to be transferred
229     /// @return Whether the transfer was successful or not
230     function transferFlower(address _to, uint256 _value) public returns (bool success);
231 
232     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
233     /// @param _from The address of the sender
234     /// @param _to The address of the recipient
235     /// @param _value The amount of token to be transferred
236     /// @return Whether the transfer was successful or not
237     function transferFromFlower(address _from, address _to, uint256 _value) public returns (bool success);
238 
239     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
240     /// @param _spender The address of the account able to transfer the tokens
241     /// @param _value The amount of tokens to be approved for transfer
242     /// @return Whether the approval was successful or not
243     function approveFlower(address _spender, uint256 _value) public returns (bool success);
244 
245     /// @param _owner The address of the account owning tokens
246     /// @param _spender The address of the account able to transfer the tokens
247     /// @return Amount of remaining tokens allowed to spent
248     function allowanceFlower(address _owner, address _spender) public view returns (uint256 remaining);
249 
250     // solhint-disable-next-line no-simple-event-func-name  
251     event TransferFlower(address from, address to, uint256 value); 
252     event ApprovalFlower(address owner, address spender, uint256 value);
253 
254     function supportsEIP20Interface(bytes4 _interfaceID) external view returns (bool);
255 }
256 contract ERC721 {
257     // Required methods
258     function totalSupply() public view returns (uint256 total);
259     function balanceOf(address _owner) public view returns (uint256 balance);
260     function ownerOf(uint256 _tokenId) external view returns (address owner);
261     function approve(address _to, uint256 _tokenId) external;
262     function transfer(address _to, uint256 _tokenId) external;
263     function transferFrom(address _from, address _to, uint256 _tokenId) external;
264 
265     // Events
266     event Transfer(address from, address to, uint256 tokenId);
267     event Approval(address owner, address approved, uint256 tokenId);
268 
269     // Optional
270     // function name() public view returns (string name);
271     // function symbol() public view returns (string symbol);
272     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
273     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
274 
275     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
276     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
277 }
278 
279 contract ERC721Metadata {
280 	function getMetadata(uint256 _tokenId, string) public pure returns (bytes32[4] buffer, uint256 count) {
281 		if (_tokenId == 1) {
282 			buffer[0] = "Hello World! :D";
283 			count = 15;
284 		} else if (_tokenId == 2) {
285 			buffer[0] = "I would definitely choose a medi";
286 			buffer[1] = "um length string.";
287 			count = 49;
288 		} else if (_tokenId == 3) {
289 			buffer[0] = "Lorem ipsum dolor sit amet, mi e";
290 			buffer[1] = "st accumsan dapibus augue lorem,";
291 			buffer[2] = " tristique vestibulum id, libero";
292 			buffer[3] = " suscipit varius sapien aliquam.";
293 			count = 128;
294 		}
295 	}
296 }
297 
298 contract TrueloveOwnership is TrueloveBase, ERC721 {
299 	string public constant name = "CryptoTruelove";
300 	string public constant symbol = "CT";
301 
302 	// The contract that will return kitty metadata
303 	ERC721Metadata public erc721Metadata;
304 
305 	bytes4 constant InterfaceSignature_ERC165 = bytes4(0x9a20483d);
306 			// bytes4(keccak256("supportsInterface(bytes4)"));
307 
308 	bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
309 			// bytes4(keccak256("name()")) ^
310 			// bytes4(keccak256("symbol()")) ^
311 			// bytes4(keccak256("totalSupply()")) ^
312 			// bytes4(keccak256("balanceOf(address)")) ^
313 			// bytes4(keccak256("ownerOf(uint256)")) ^
314 			// bytes4(keccak256("approve(address,uint256)")) ^
315 			// bytes4(keccak256("transfer(address,uint256)")) ^
316 			// bytes4(keccak256("transferFrom(address,address,uint256)")) ^
317 			// bytes4(keccak256("tokensOfOwner(address)")) ^
318 			// bytes4(keccak256("tokenMetadata(uint256,string)"));
319 
320 	/// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
321 	///  Returns true for any standardized interfaces implemented by this contract. We implement
322 	///  ERC-165 (obviously!) and ERC-721.
323 	function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
324 		// DEBUG ONLY
325 		//require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
326 
327 		return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
328 	}
329 
330 	function setMetadataAddress(address _contractAddress) public onlyCEO {
331 		erc721Metadata = ERC721Metadata(_contractAddress);
332 	}
333 
334 	function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
335 			return diamondIndexToOwner[_tokenId] == _claimant;
336 	}
337 
338 	function _transfer(address _from, address _to, uint256 _tokenId) internal {
339 		ownershipTokenCount[_to]++;
340 		diamondIndexToOwner[_tokenId] = _to;
341 		if (_from != address(0)) {
342 			ownershipTokenCount[_from]--;
343 			delete diamondIndexToApproved[_tokenId];
344 		}
345 		Transfer(_from, _to, _tokenId);
346 	}
347 
348 	function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
349 			return diamondIndexToApproved[_tokenId] == _claimant;
350 	}
351 
352 	function _approve(uint256 _tokenId, address _approved) internal {
353 			diamondIndexToApproved[_tokenId] = _approved;
354 	}
355 
356 	/// @notice Returns the number of Kitties owned by a specific address.
357 	/// @param _owner The owner address to check.
358 	/// @dev Required for ERC-721 compliance
359 	function balanceOf(address _owner) public view returns (uint256 count) {
360 			return ownershipTokenCount[_owner];
361 	}
362 
363 	function transfer(
364 			address _to,
365 			uint256 _tokenId
366 	)
367 			external
368 			whenNotPaused
369 	{
370 			require(_to != address(0));
371 			require(_to != address(this));
372 			require(_to != address(diamondAuction));
373 			require(_owns(msg.sender, _tokenId));
374 
375 			_transfer(msg.sender, _to, _tokenId);
376 	}
377 
378 	function approve(
379 			address _to,
380 			uint256 _tokenId
381 	)
382 			external
383 			whenNotPaused
384 	{
385 			require(_owns(msg.sender, _tokenId));
386 
387 			_approve(_tokenId, _to);
388 
389 			Approval(msg.sender, _to, _tokenId);
390 	}
391 
392 	function transferFrom(
393 			address _from,
394 			address _to,
395 			uint256 _tokenId
396 	)
397 			external
398 			whenNotPaused
399 	{
400 			require(_to != address(0));
401 			require(_to != address(this));
402 			require(_approvedFor(msg.sender, _tokenId));
403 			require(_owns(_from, _tokenId));
404 
405 			_transfer(_from, _to, _tokenId);
406 	}
407 
408 	function totalSupply() public view returns (uint) {
409 			return diamonds.length - 1;
410 	}
411 
412 	function ownerOf(uint256 _tokenId)
413 			external
414 			view
415 			returns (address owner)
416 	{
417 			owner = diamondIndexToOwner[_tokenId];
418 
419 			require(owner != address(0));
420 	}
421 
422 	/// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
423 	///  expensive (it walks the entire Kitty array looking for cats belonging to owner),
424 	///  but it also returns a dynamic array, which is only supported for web3 calls, and
425 	///  not contract-to-contract calls.
426 	function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
427 			uint256 tokenCount = balanceOf(_owner);
428 
429 			if (tokenCount == 0) {
430 					// Return an empty array
431 					return new uint256[](0);
432 			} else {
433 					uint256[] memory result = new uint256[](tokenCount);
434 					uint256 totalDiamonds = totalSupply();
435 					uint256 resultIndex = 0;
436 
437 					uint256 diamondId;
438 
439 					for (diamondId = 1; diamondId <= totalDiamonds; diamondId++) {
440 							if (diamondIndexToOwner[diamondId] == _owner) {
441 									result[resultIndex] = diamondId;
442 									resultIndex++;
443 							}
444 					}
445 
446 					return result;
447 			}
448 	}
449 
450 	function _memcpy(uint _dest, uint _src, uint _len) private pure {
451 			// Copy word-length chunks while possible
452 			for(; _len >= 32; _len -= 32) {
453 					assembly {
454 							mstore(_dest, mload(_src))
455 					}
456 					_dest += 32;
457 					_src += 32;
458 			}
459 
460 			// Copy remaining bytes
461 			uint256 mask = 256 ** (32 - _len) - 1;
462 			assembly {
463 					let srcpart := and(mload(_src), not(mask))
464 					let destpart := and(mload(_dest), mask)
465 					mstore(_dest, or(destpart, srcpart))
466 			}
467 	}
468 
469 	function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private pure returns (string) {
470 			var outputString = new string(_stringLength);
471 			uint256 outputPtr;
472 			uint256 bytesPtr;
473 
474 			assembly {
475 					outputPtr := add(outputString, 32)
476 					bytesPtr := _rawBytes
477 			}
478 
479 			_memcpy(outputPtr, bytesPtr, _stringLength);
480 
481 			return outputString;
482 	}
483 
484 	function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
485 			require(erc721Metadata != address(0));
486 			bytes32[4] memory buffer;
487 			uint256 count;
488 			(buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
489 
490 			return _toString(buffer, count);
491 	}
492 
493 	function getDiamond(uint256 _id)
494 		external
495 		view
496 		returns (
497 		bytes24 model,
498 		uint16 year,
499 		uint16 no,
500 		uint activateAt
501 	) {
502 		Diamond storage diamond = diamonds[_id];
503 
504 		model = diamond.model;
505 		year = diamond.year;
506 		no = diamond.no;
507 		activateAt = diamond.activateAt;
508 	}
509 }
510 
511 contract TrueloveFlowerOwnership is TrueloveBase, EIP20Interface {
512 	uint256 constant private MAX_UINT256 = 2**256 - 1;
513 	mapping (address => mapping (address => uint256)) public flowerAllowed;
514 
515 	bytes4 constant EIP20InterfaceSignature = bytes4(0x98474109);
516 		// bytes4(keccak256("balanceOfFlower(address)")) ^
517 		// bytes4(keccak256("approveFlower(address,uint256)")) ^
518 		// bytes4(keccak256("transferFlower(address,uint256)")) ^
519 		// bytes4(keccak256("transferFromFlower(address,address,uint256)"));
520 
521 	function supportsEIP20Interface(bytes4 _interfaceID) external view returns (bool) {
522 		return _interfaceID == EIP20InterfaceSignature;
523 	}
524 
525 	function _transferFlower(address _from, address _to, uint256 _value) internal returns (bool success) {
526 		if (_from != address(0)) {
527 			require(flowerBalances[_from] >= _value);
528 			flowerBalances[_from] -= _value;
529 		}
530 		flowerBalances[_to] += _value;
531 		TransferFlower(_from, _to, _value);
532 		return true;
533 	}
534 
535 	function transferFlower(address _to, uint256 _value) public returns (bool success) {
536 		require(flowerBalances[msg.sender] >= _value);
537 		flowerBalances[msg.sender] -= _value;
538 		flowerBalances[_to] += _value;
539 		TransferFlower(msg.sender, _to, _value);
540 		return true;
541 	}
542 
543 	function transferFromFlower(address _from, address _to, uint256 _value) public returns (bool success) {
544 		uint256 allowance = flowerAllowed[_from][msg.sender];
545 		require(flowerBalances[_from] >= _value && allowance >= _value);
546 		flowerBalances[_to] += _value;
547 		flowerBalances[_from] -= _value;
548 		if (allowance < MAX_UINT256) {
549 			flowerAllowed[_from][msg.sender] -= _value;
550 		}
551 		TransferFlower(_from, _to, _value);
552 		return true;
553 	}
554 
555 	function balanceOfFlower(address _owner) public view returns (uint256 balance) {
556 		return flowerBalances[_owner];
557 	}
558 
559 	function approveFlower(address _spender, uint256 _value) public returns (bool success) {
560 		flowerAllowed[msg.sender][_spender] = _value;
561 		ApprovalFlower(msg.sender, _spender, _value);
562 		return true;
563 	}
564 
565 	function allowanceFlower(address _owner, address _spender) public view returns (uint256 remaining) {
566 		return flowerAllowed[_owner][_spender];
567 	}
568 
569 	function _addFlower(uint256 _amount) internal {
570 		flower.current += _amount;
571 		flowerTotalSupply += _amount;
572 	}
573 }
574 
575 contract TrueloveNextSale is TrueloveOwnership, TrueloveFlowerOwnership {
576 	uint256 constant REMAINING_AMOUNT = 50000; // MARK: Modify it
577 
578 	function TrueloveNextSale() internal {
579 		_giveRemainingFlower();
580 	}
581 
582 	function openNextSale(uint256 _diamond1Price, bytes24 _diamond2Model, uint256 _diamond2Price, bytes24 _flowerModel, uint256 _flowerPrice)
583 		external onlyCOO
584 		{
585 		require(now >= nextSaleTime);
586 
587 		_setVars();
588 		diamond1.price = _diamond1Price;
589 		_openSaleDiamond2(_diamond2Model, _diamond2Price);
590 		_openSaleFlower(_flowerModel, _flowerPrice);
591 		_giveRemainingFlower();
592 	}
593 
594 	function _openSaleDiamond2(bytes24 _diamond2Model, uint256 _diamond2Price) private {
595 		diamond2.model = _diamond2Model;
596 		diamond2.current = 0;
597 		diamond2.year++;
598 		diamond2.price = _diamond2Price;
599 	}
600 
601 	function _openSaleFlower(bytes24 _flowerModel, uint256 _flowerPrice) private {
602 		flower.model = _flowerModel;
603 		flower.current = 0;
604 		flower.year++;
605 		flower.price = _flowerPrice;
606 		flower.total = 1000000; // MARK: Modify it
607 	}
608 
609 	function _giveRemainingFlower() internal {
610 		_transferFlower(0, msg.sender, REMAINING_AMOUNT);
611 		_addFlower(REMAINING_AMOUNT);
612 	}
613 }
614 
615 contract TrueloveRegistration is TrueloveNextSale {
616 	mapping (address => RegistrationRight) public registrationRights;
617 	mapping (bytes32 => Registration) public registrations;
618 
619 	struct RegistrationRight {
620 		bool able;
621 		bool used;
622 	}
623 
624 	struct Registration {
625 		bool signed;
626 		string secret; // including both names
627 		string topSecret; // including SSN and birthdate
628 	}
629 
630 	function giveRegistration(address _addr) external onlyCOO {
631 		if (registrationRights[_addr].able == false) {
632 			registrationRights[_addr].able = true;
633 		} else {
634 			revert();
635 		}
636 	}
637 
638 	function buyRegistration() external payable whenNotPaused {
639 		require(registerPrice <= msg.value);
640 		if (registrationRights[msg.sender].able == false) {
641 			registrationRights[msg.sender].able = true;
642 		} else {
643 			revert();
644 		}
645 	}
646 
647 	function _giveSenderRegistration() internal {
648 		if (registrationRights[msg.sender].able == false) {
649 			registrationRights[msg.sender].able = true;
650 		}
651 	}
652 
653 	function getRegistrationRight(address _addr) external view returns (bool able, bool used) {
654 		able = registrationRights[_addr].able;
655 		used = registrationRights[_addr].used;
656 	}
657 
658 	function getRegistration(bytes32 _unique) external view returns (bool signed, string secret, string topSecret) {
659 		signed = registrations[_unique].signed;
660 		secret = registrations[_unique].secret;
661 		topSecret = registrations[_unique].topSecret;
662 	}
663 
664 	function signTruelove(bytes32 _registerID, string _secret, string _topSecret) public {
665 		require(registrationRights[msg.sender].able == true);
666 		require(registrationRights[msg.sender].used == false);
667 		registrationRights[msg.sender].used = true;
668 		_signTruelove(_registerID, _secret, _topSecret);
669 	}
670 
671 	function signTrueloveByCOO(bytes32 _registerID, string _secret, string _topSecret) external onlyCOO {
672 		_signTruelove(_registerID, _secret, _topSecret);
673 	}
674 
675 	function _signTruelove(bytes32 _registerID, string _secret, string _topSecret) internal {
676 		require(registrations[_registerID].signed == false);
677 
678 		registrations[_registerID].signed = true;
679 		registrations[_registerID].secret = _secret;
680 		registrations[_registerID].topSecret = _topSecret;
681 	}
682 }
683 
684 contract TrueloveShop is TrueloveRegistration {
685 	function buyDiamond(uint _index) external payable whenNotPaused returns(uint256) {
686 		require(_index == 1 || _index == 2 || _index == 3);
687 		Model storage model = _getModel(_index);
688 
689 		require(model.current < model.total);
690 		require(model.price <= msg.value);
691 		_giveSenderRegistration();
692 
693 		uint256 newDiamondId = diamonds.push(Diamond({model: model.model, year: model.year, no: uint16(model.current + 1), activateAt: 0})) - 1;
694 		_transfer(0, msg.sender, newDiamondId);
695 		
696 		model.current++;
697 		return newDiamondId;
698 	}
699 
700 	function buyFlower(uint _amount) external payable whenNotPaused {
701 		require(flower.current + _amount < flower.total);
702 		uint256 price = currentFlowerPrice();
703 		require(price * _amount <= msg.value);
704 		_giveSenderRegistration();
705 
706 		_transferFlower(0, msg.sender, _amount);
707 		_addFlower(_amount);
708 	}
709 
710 	function currentFlowerPrice() public view returns(uint256) {
711 		if (flower.current < 100000 + REMAINING_AMOUNT) { // MARK: Modify it
712 			return flower.price;
713 		} else if (flower.current < 300000 + REMAINING_AMOUNT) { // MARK: Modify it
714 			return flower.price * 4;
715 		} else {
716 			return flower.price * 10;
717 		}
718 	}
719 }
720 contract TrueloveDelivery is TrueloveShop {
721 	enum GiftType { Diamond, Flower }
722 
723 	event GiftSend(uint indexed index, address indexed receiver, address indexed from, bytes32 registerID, string letter, bytes16 date,
724 		GiftType gtype,
725 		bytes24 model,
726 		uint16 year,
727 		uint16 no,
728 		uint amount
729 		);
730 
731 	uint public giftSendIndex = 1;
732 	
733 	modifier sendCheck(bytes32 _registerID) {
734     require(sendGiftPrice <= msg.value);
735 		require(registrations[_registerID].signed);
736     _;
737   }
738 
739 	function signSendDiamond(bytes32 _registerID, string _secret, string _topSecret, address _truelove, string _letter, bytes16 _date, uint _tokenId) external payable {
740 		signTruelove(_registerID, _secret, _topSecret);
741 		sendDiamond(_truelove, _registerID, _letter, _date, _tokenId);
742 	}
743 
744 	function sendDiamond(address _truelove, bytes32 _registerID, string _letter, bytes16 _date, uint _tokenId) public payable sendCheck(_registerID) {
745 		require(_owns(msg.sender, _tokenId));
746 		require(now > diamonds[_tokenId].activateAt);
747 		
748 		_transfer(msg.sender, _truelove, _tokenId);
749 		
750 		diamonds[_tokenId].activateAt = now + 3 days;
751 
752 		GiftSend(giftSendIndex, _truelove, msg.sender, _registerID, _letter, _date,
753 			GiftType.Diamond,
754 			diamonds[_tokenId].model,
755 			diamonds[_tokenId].year,
756 			diamonds[_tokenId].no,
757 			1
758 			);
759 		giftSendIndex++;
760 	}
761 
762 	function signSendFlower(bytes32 _registerID, string _secret, string _topSecret, address _truelove, string _letter, bytes16 _date, uint _amount) external payable {
763 		signTruelove(_registerID, _secret, _topSecret);
764 		sendFlower(_truelove, _registerID, _letter, _date, _amount);
765 	}
766 
767 	function sendFlower(address _truelove, bytes32 _registerID, string _letter, bytes16 _date, uint _amount) public payable sendCheck(_registerID) {
768 		require(flowerBalances[msg.sender] >= _amount);
769 
770 		flowerBalances[msg.sender] -= _amount;
771 		flowerBalances[_truelove] += (_amount * 9 / 10);
772 
773 		GiftSend(giftSendIndex, _truelove, msg.sender, _registerID, _letter, _date,
774 			GiftType.Flower,
775 			flower.model,
776 			flower.year,
777 			0,
778 			_amount
779 			);
780 		giftSendIndex++;
781 	}
782 }
783 
784 contract TrueloveAuction is TrueloveDelivery {
785 	function setDiamondAuctionAddress(address _address) external onlyCEO {
786 		DiamondAuction candidateContract = DiamondAuction(_address);
787 
788 		// NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
789 		require(candidateContract.isDiamondAuction());
790 		diamondAuction = candidateContract;
791 	}
792 
793 	function createDiamondAuction(
794 		uint256 _tokenId,
795 		uint256 _startingPrice,
796 		uint256 _endingPrice,
797 		uint256 _duration
798 	)
799 		external
800 		whenNotPaused
801 	{
802 		require(_owns(msg.sender, _tokenId));
803 		// require(!isPregnant(_tokenId));
804 		_approve(_tokenId, diamondAuction);
805 		diamondAuction.createAuction(
806 			_tokenId,
807 			_startingPrice,
808 			_endingPrice,
809 			_duration,
810 			msg.sender
811 		);
812 	}
813 
814 	function setFlowerAuctionAddress(address _address) external onlyCEO {
815 		FlowerAuction candidateContract = FlowerAuction(_address);
816 
817 		// NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
818 		require(candidateContract.isFlowerAuction());
819 		flowerAuction = candidateContract;
820 	}
821 
822 	function createFlowerAuction(
823 		uint256 _amount,
824 		uint256 _startingPrice,
825 		uint256 _endingPrice,
826 		uint256 _duration
827 	)
828 		external
829 		whenNotPaused
830 	{
831 		approveFlower(flowerAuction, _amount);
832 		flowerAuction.createAuction(
833 			_amount,
834 			_startingPrice,
835 			_endingPrice,
836 			_duration,
837 			msg.sender
838 		);
839 	}
840 
841 	function withdrawAuctionBalances() external onlyCLevel {
842 		diamondAuction.withdrawBalance();
843 		flowerAuction.withdrawBalance();
844 	}
845 }
846 
847 contract TrueloveCore is TrueloveAuction {
848 	address public newContractAddress;
849 
850 	event Transfer(address from, address to, uint256 tokenId);
851 	event Approval(address owner, address approved, uint256 tokenId);
852 
853 	event TransferFlower(address from, address to, uint256 value); 
854 	event ApprovalFlower(address owner, address spender, uint256 value);
855 
856 	event GiftSend(uint indexed index, address indexed receiver, address indexed from, bytes32 registerID, string letter, bytes16 date,
857 		GiftType gtype,
858 		bytes24 model,
859 		uint16 year,
860 		uint16 no,
861 		uint amount
862 		);
863 		
864 	function TrueloveCore() public {
865 		ceoAddress = msg.sender;
866 		cooAddress = msg.sender;
867 	}
868 
869 	function setNewAddress(address _v2Address) external onlyCEO whenPaused {
870     newContractAddress = _v2Address;
871     ContractUpgrade(_v2Address);
872   }
873 
874   function() external payable {
875     require(
876       msg.sender == address(diamondAuction) ||
877       msg.sender == address(flowerAuction)
878     );
879   }
880 	function withdrawBalance(uint256 amount) external onlyCFO {
881 		cfoAddress.transfer(amount);
882 	}
883 }
884 
885 contract ClockAuctionBase {
886 
887     // Represents an auction on an NFT
888     struct Auction {
889         // Current owner of NFT
890         address seller;
891         // Price (in wei) at beginning of auction
892         uint128 startingPrice;
893         // Price (in wei) at end of auction
894         uint128 endingPrice;
895         // Duration (in seconds) of auction
896         uint64 duration;
897         // Time when auction started
898         // NOTE: 0 if this auction has been concluded
899         uint64 startedAt;
900     }
901 
902     // Reference to contract tracking NFT ownership
903     ERC721 public nonFungibleContract;
904 
905     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
906     // Values 0-10,000 map to 0%-100%
907     uint256 public ownerCut;
908 
909     // Map from token ID to their corresponding auction.
910     mapping (uint256 => Auction) tokenIdToAuction;
911 
912     event AuctionCreated(uint256 indexed tokenId, address indexed seller, uint256 startingPrice, uint256 endingPrice, uint256 duration);
913     event AuctionSuccessful(uint256 indexed tokenId, uint256 totalPrice, address winner);
914     event AuctionCancelled(uint256 indexed tokenId);
915 
916     /// @dev Returns true if the claimant owns the token.
917     /// @param _claimant - Address claiming to own the token.
918     /// @param _tokenId - ID of token whose ownership to verify.
919     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
920         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
921     }
922 
923     /// @dev Escrows the NFT, assigning ownership to this contract.
924     /// Throws if the escrow fails.
925     /// @param _owner - Current owner address of token to escrow.
926     /// @param _tokenId - ID of token whose approval to verify.
927     function _escrow(address _owner, uint256 _tokenId) internal {
928         // it will throw if transfer fails
929         nonFungibleContract.transferFrom(_owner, this, _tokenId);
930     }
931 
932     /// @dev Transfers an NFT owned by this contract to another address.
933     /// Returns true if the transfer succeeds.
934     /// @param _receiver - Address to transfer NFT to.
935     /// @param _tokenId - ID of token to transfer.
936     function _transfer(address _receiver, uint256 _tokenId) internal {
937         // it will throw if transfer fails
938         nonFungibleContract.transfer(_receiver, _tokenId);
939     }
940 
941     /// @dev Adds an auction to the list of open auctions. Also fires the
942     ///  AuctionCreated event.
943     /// @param _tokenId The ID of the token to be put on auction.
944     /// @param _auction Auction to add.
945     function _addAuction(uint256 _tokenId, Auction _auction) internal {
946         // Require that all auctions have a duration of
947         // at least one minute. (Keeps our math from getting hairy!)
948         require(_auction.duration >= 1 minutes);
949 
950         tokenIdToAuction[_tokenId] = _auction;
951 
952         AuctionCreated(
953             uint256(_tokenId),
954             _auction.seller,
955             uint256(_auction.startingPrice),
956             uint256(_auction.endingPrice),
957             uint256(_auction.duration)
958         );
959     }
960 
961     /// @dev Cancels an auction unconditionally.
962     function _cancelAuction(uint256 _tokenId, address _seller) internal {
963         _removeAuction(_tokenId);
964         _transfer(_seller, _tokenId);
965         AuctionCancelled(_tokenId);
966     }
967 
968     /// @dev Computes the price and transfers winnings.
969     /// Does NOT transfer ownership of token.
970     function _bid(uint256 _tokenId, uint256 _bidAmount)
971         internal
972         returns (uint256)
973     {
974         // Get a reference to the auction struct
975         Auction storage auction = tokenIdToAuction[_tokenId];
976 
977         // Explicitly check that this auction is currently live.
978         // (Because of how Ethereum mappings work, we can't just count
979         // on the lookup above failing. An invalid _tokenId will just
980         // return an auction object that is all zeros.)
981         require(_isOnAuction(auction));
982 
983         // Check that the bid is greater than or equal to the current price
984         uint256 price = _currentPrice(auction);
985         require(_bidAmount >= price);
986 
987         // Grab a reference to the seller before the auction struct
988         // gets deleted.
989         address seller = auction.seller;
990 
991         // The bid is good! Remove the auction before sending the fees
992         // to the sender so we can't have a reentrancy attack.
993         _removeAuction(_tokenId);
994 
995         // Transfer proceeds to seller (if there are any!)
996         if (price > 0) {
997             // Calculate the auctioneer's cut.
998             // (NOTE: _computeCut() is guaranteed to return a
999             // value <= price, so this subtraction can't go negative.)
1000             uint256 auctioneerCut = _computeCut(price);
1001             uint256 sellerProceeds = price - auctioneerCut;
1002 
1003             // NOTE: Doing a transfer() in the middle of a complex
1004             // method like this is generally discouraged because of
1005             // reentrancy attacks and DoS attacks if the seller is
1006             // a contract with an invalid fallback function. We explicitly
1007             // guard against reentrancy attacks by removing the auction
1008             // before calling transfer(), and the only thing the seller
1009             // can DoS is the sale of their own asset! (And if it's an
1010             // accident, they can call cancelAuction(). )
1011             seller.transfer(sellerProceeds);
1012         }
1013 
1014         // Calculate any excess funds included with the bid. If the excess
1015         // is anything worth worrying about, transfer it back to bidder.
1016         // NOTE: We checked above that the bid amount is greater than or
1017         // equal to the price so this cannot underflow.
1018         uint256 bidExcess = _bidAmount - price;
1019 
1020         // Return the funds. Similar to the previous transfer, this is
1021         // not susceptible to a re-entry attack because the auction is
1022         // removed before any transfers occur.
1023         msg.sender.transfer(bidExcess);
1024 
1025         // Tell the world!
1026         AuctionSuccessful(_tokenId, price, msg.sender);
1027 
1028         return price;
1029     }
1030 
1031     /// @dev Removes an auction from the list of open auctions.
1032     /// @param _tokenId - ID of NFT on auction.
1033     function _removeAuction(uint256 _tokenId) internal {
1034         delete tokenIdToAuction[_tokenId];
1035     }
1036 
1037     /// @dev Returns true if the NFT is on auction.
1038     /// @param _auction - Auction to check.
1039     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1040         return (_auction.startedAt > 0);
1041     }
1042 
1043     /// @dev Returns current price of an NFT on auction. Broken into two
1044     ///  functions (this one, that computes the duration from the auction
1045     ///  structure, and the other that does the price computation) so we
1046     ///  can easily test that the price computation works correctly.
1047     function _currentPrice(Auction storage _auction)
1048         internal
1049         view
1050         returns (uint256)
1051     {
1052         uint256 secondsPassed = 0;
1053 
1054         // A bit of insurance against negative values (or wraparound).
1055         // Probably not necessary (since Ethereum guarnatees that the
1056         // now variable doesn't ever go backwards).
1057         if (now > _auction.startedAt) {
1058             secondsPassed = now - _auction.startedAt;
1059         }
1060 
1061         return _computeCurrentPrice(
1062             _auction.startingPrice,
1063             _auction.endingPrice,
1064             _auction.duration,
1065             secondsPassed
1066         );
1067     }
1068 
1069     /// @dev Computes the current price of an auction. Factored out
1070     ///  from _currentPrice so we can run extensive unit tests.
1071     ///  When testing, make this function public and turn on
1072     ///  `Current price computation` test suite.
1073     function _computeCurrentPrice(
1074         uint256 _startingPrice,
1075         uint256 _endingPrice,
1076         uint256 _duration,
1077         uint256 _secondsPassed
1078     )
1079         internal
1080         pure
1081         returns (uint256)
1082     {
1083         // NOTE: We don't use SafeMath (or similar) in this function because
1084         //  all of our public functions carefully cap the maximum values for
1085         //  time (at 64-bits) and currency (at 128-bits). _duration is
1086         //  also known to be non-zero (see the require() statement in
1087         //  _addAuction())
1088         if (_secondsPassed >= _duration) {
1089             // We've reached the end of the dynamic pricing portion
1090             // of the auction, just return the end price.
1091             return _endingPrice;
1092         } else {
1093             // Starting price can be higher than ending price (and often is!), so
1094             // this delta can be negative.
1095             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1096 
1097             // This multiplication can't overflow, _secondsPassed will easily fit within
1098             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
1099             // will always fit within 256-bits.
1100             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1101 
1102             // currentPriceChange can be negative, but if so, will have a magnitude
1103             // less that _startingPrice. Thus, this result will always end up positive.
1104             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1105 
1106             return uint256(currentPrice);
1107         }
1108     }
1109 
1110     /// @dev Computes owner's cut of a sale.
1111     /// @param _price - Sale price of NFT.
1112     function _computeCut(uint256 _price) internal view returns (uint256) {
1113         // NOTE: We don't use SafeMath (or similar) in this function because
1114         //  all of our entry functions carefully cap the maximum values for
1115         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1116         //  statement in the ClockAuction constructor). The result of this
1117         //  function is always guaranteed to be <= _price.
1118         return _price * ownerCut / 10000;
1119     }
1120 
1121 }
1122 
1123 
1124 
1125 contract ClockAuction is Pausable, ClockAuctionBase {
1126 
1127     /// @dev The ERC-165 interface signature for ERC-721.
1128     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1129     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1130     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1131 
1132     /// @dev Constructor creates a reference to the NFT ownership contract
1133     ///  and verifies the owner cut is in the valid range.
1134     /// @param _nftAddress - address of a deployed contract implementing
1135     ///  the Nonfungible Interface.
1136     /// @param _cut - percent cut the owner takes on each auction, must be
1137     ///  between 0-10,000.
1138     function ClockAuction(address _nftAddress, uint256 _cut) public {
1139         require(_cut <= 10000);
1140         ownerCut = _cut;
1141 
1142         ERC721 candidateContract = ERC721(_nftAddress);
1143         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1144         nonFungibleContract = candidateContract;
1145     }
1146 
1147     /// @dev Remove all Ether from the contract, which is the owner's cuts
1148     ///  as well as any Ether sent directly to the contract address.
1149     ///  Always transfers to the NFT contract, but can be called either by
1150     ///  the owner or the NFT contract.
1151     function withdrawBalance() external {
1152         address nftAddress = address(nonFungibleContract);
1153 
1154         require(
1155             msg.sender == owner ||
1156             msg.sender == nftAddress
1157         );
1158         // We are using this boolean method to make sure that even if one fails it will still work
1159         // bool res = nftAddress.send(this.balance);
1160         nftAddress.send(this.balance);
1161     }
1162 
1163     /// @dev Creates and begins a new auction.
1164     /// @param _tokenId - ID of token to auction, sender must be owner.
1165     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1166     /// @param _endingPrice - Price of item (in wei) at end of auction.
1167     /// @param _duration - Length of time to move between starting
1168     ///  price and ending price (in seconds).
1169     /// @param _seller - Seller, if not the message sender
1170     function createAuction(
1171         uint256 _tokenId,
1172         uint256 _startingPrice,
1173         uint256 _endingPrice,
1174         uint256 _duration,
1175         address _seller
1176     )
1177         external
1178         whenNotPaused
1179     {
1180         // Sanity check that no inputs overflow how many bits we've allocated
1181         // to store them in the auction struct.
1182         require(_startingPrice == uint256(uint128(_startingPrice)));
1183         require(_endingPrice == uint256(uint128(_endingPrice)));
1184         require(_duration == uint256(uint64(_duration)));
1185 
1186         require(_owns(msg.sender, _tokenId));
1187         _escrow(msg.sender, _tokenId);
1188         Auction memory auction = Auction(
1189             _seller,
1190             uint128(_startingPrice),
1191             uint128(_endingPrice),
1192             uint64(_duration),
1193             uint64(now)
1194         );
1195         _addAuction(_tokenId, auction);
1196     }
1197 
1198     /// @dev Bids on an open auction, completing the auction and transferring
1199     ///  ownership of the NFT if enough Ether is supplied.
1200     /// @param _tokenId - ID of token to bid on.
1201     function bid(uint256 _tokenId)
1202         external
1203         payable
1204         whenNotPaused
1205     {
1206         // _bid will throw if the bid or funds transfer fails
1207         _bid(_tokenId, msg.value);
1208         _transfer(msg.sender, _tokenId);
1209     }
1210 
1211     /// @dev Cancels an auction that hasn't been won yet.
1212     ///  Returns the NFT to original owner.
1213     /// @notice This is a state-modifying function that can
1214     ///  be called while the contract is paused.
1215     /// @param _tokenId - ID of token on auction
1216     function cancelAuction(uint256 _tokenId)
1217         external
1218     {
1219         Auction storage auction = tokenIdToAuction[_tokenId];
1220         require(_isOnAuction(auction));
1221         address seller = auction.seller;
1222         require(msg.sender == seller);
1223         _cancelAuction(_tokenId, seller);
1224     }
1225 
1226     /// @dev Cancels an auction when the contract is paused.
1227     ///  Only the owner may do this, and NFTs are returned to
1228     ///  the seller. This should only be used in emergencies.
1229     /// @param _tokenId - ID of the NFT on auction to cancel.
1230     function cancelAuctionWhenPaused(uint256 _tokenId)
1231         whenPaused
1232         onlyOwner
1233         external
1234     {
1235         Auction storage auction = tokenIdToAuction[_tokenId];
1236         require(_isOnAuction(auction));
1237         _cancelAuction(_tokenId, auction.seller);
1238     }
1239 
1240     /// @dev Returns auction info for an NFT on auction.
1241     /// @param _tokenId - ID of NFT on auction.
1242     function getAuction(uint256 _tokenId)
1243         external
1244         view
1245         returns
1246     (
1247         address seller,
1248         uint256 startingPrice,
1249         uint256 endingPrice,
1250         uint256 duration,
1251         uint256 startedAt
1252     ) {
1253         Auction storage auction = tokenIdToAuction[_tokenId];
1254         require(_isOnAuction(auction));
1255         return (
1256             auction.seller,
1257             auction.startingPrice,
1258             auction.endingPrice,
1259             auction.duration,
1260             auction.startedAt
1261         );
1262     }
1263 
1264     /// @dev Returns the current price of an auction.
1265     /// @param _tokenId - ID of the token price we are checking.
1266     function getCurrentPrice(uint256 _tokenId)
1267         external
1268         view
1269         returns (uint256)
1270     {
1271         Auction storage auction = tokenIdToAuction[_tokenId];
1272         require(_isOnAuction(auction));
1273         return _currentPrice(auction);
1274     }
1275 
1276 }
1277 
1278 contract DiamondAuction is ClockAuction {
1279 
1280     // @dev Sanity check that allows us to ensure that we are pointing to the
1281     //  right auction in our setSaleAuctionAddress() call.
1282     bool public isDiamondAuction = true;
1283 
1284     event AuctionCreated(uint256 indexed tokenId, address indexed seller, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1285     event AuctionSuccessful(uint256 indexed tokenId, uint256 totalPrice, address winner);
1286     event AuctionCancelled(uint256 indexed tokenId);
1287     
1288     // Delegate constructor
1289     function DiamondAuction(address _nftAddr) public
1290         ClockAuction(_nftAddr, 0) {}
1291 
1292     /// @dev Creates and begins a new auction.
1293     /// @param _tokenId - ID of token to auction, sender must be owner.
1294     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1295     /// @param _endingPrice - Price of item (in wei) at end of auction.
1296     /// @param _duration - Length of auction (in seconds).
1297     /// @param _seller - Seller, if not the message sender
1298     function createAuction(
1299         uint256 _tokenId,
1300         uint256 _startingPrice,
1301         uint256 _endingPrice,
1302         uint256 _duration,
1303         address _seller
1304     )
1305         external
1306     {
1307         // Sanity check that no inputs overflow how many bits we've allocated
1308         // to store them in the auction struct.
1309         require(_startingPrice == uint256(uint128(_startingPrice)));
1310         require(_endingPrice == uint256(uint128(_endingPrice)));
1311         require(_duration == uint256(uint64(_duration)));
1312 
1313         require(msg.sender == address(nonFungibleContract));
1314         _escrow(_seller, _tokenId);
1315         Auction memory auction = Auction(
1316             _seller,
1317             uint128(_startingPrice),
1318             uint128(_endingPrice),
1319             uint64(_duration),
1320             uint64(now)
1321         );
1322         _addAuction(_tokenId, auction);
1323     }
1324 
1325     /// @dev Updates lastSalePrice if seller is the nft contract
1326     /// Otherwise, works the same as default bid method.
1327     function bid(uint256 _tokenId)
1328         external
1329         payable
1330     {
1331         // _bid verifies token ID size
1332         tokenIdToAuction[_tokenId].seller;
1333         _bid(_tokenId, msg.value);
1334         _transfer(msg.sender, _tokenId);
1335     }
1336 
1337 }
1338 
1339 contract FlowerAuction is Pausable {
1340     struct Auction {
1341         address seller;
1342         uint256 amount;
1343         uint128 startingPrice;
1344         uint128 endingPrice;
1345         uint64 duration;
1346         uint64 startedAt;
1347     }
1348 
1349     EIP20Interface public tokenContract;
1350 
1351     uint256 public ownerCut;
1352 
1353     mapping (uint256 => Auction) auctions;
1354     mapping (address => uint256) sellerToAuction;
1355     uint256 public currentAuctionId;
1356 
1357     event AuctionCreated(uint256 indexed auctionId, address indexed seller, uint256 amount, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1358     event AuctionSuccessful(uint256 indexed auctionId, uint256 amount, address winner);
1359     event AuctionSoldOut(uint256 indexed auctionId);
1360     event AuctionCancelled(uint256 indexed auctionId);
1361 
1362     bytes4 constant InterfaceSignature_EIP20 = bytes4(0x98474109);
1363 
1364     bool public isFlowerAuction = true;
1365 
1366     function FlowerAuction(address _nftAddress) public {
1367         ownerCut = 0;
1368 
1369         EIP20Interface candidateContract = EIP20Interface(_nftAddress);
1370         require(candidateContract.supportsEIP20Interface(InterfaceSignature_EIP20));
1371         tokenContract = candidateContract;
1372     }
1373 
1374     function createAuction(
1375         uint256 _amount,
1376         uint256 _startingPrice,
1377         uint256 _endingPrice,
1378         uint256 _duration,
1379         address _seller
1380     )
1381         external
1382     {
1383         require(_startingPrice == uint256(uint128(_startingPrice)));
1384         require(_endingPrice == uint256(uint128(_endingPrice)));
1385         require(_duration == uint256(uint64(_duration)));
1386 
1387         require(msg.sender == address(tokenContract));
1388         _escrow(_seller, _amount);
1389         Auction memory auction = Auction(
1390             _seller,
1391             _amount,
1392             uint128(_startingPrice),
1393             uint128(_endingPrice),
1394             uint64(_duration),
1395             uint64(now)
1396         );
1397         _addAuction(auction);
1398     }
1399 
1400     function bid(uint256 _auctionId, uint256 _amount)
1401         external
1402         payable
1403     {
1404         _bid(_auctionId, _amount, msg.value);
1405         _transfer(msg.sender, _amount);
1406     }
1407 
1408 
1409 
1410 
1411     function withdrawBalance() external {
1412         address nftAddress = address(tokenContract);
1413 
1414         require(
1415             msg.sender == owner ||
1416             msg.sender == nftAddress
1417         );
1418         nftAddress.send(this.balance);
1419     }
1420 
1421 
1422     function cancelAuction(uint256 _auctionId)
1423         external
1424     {
1425         Auction storage auction = auctions[_auctionId];
1426         require(_isOnAuction(auction));
1427         address seller = auction.seller;
1428         require(msg.sender == seller);
1429         _cancelAuction(_auctionId, seller);
1430     }
1431 
1432     function cancelAuctionWhenPaused(uint256 _auctionId)
1433         whenPaused
1434         onlyOwner
1435         external
1436     {
1437         Auction storage auction = auctions[_auctionId];
1438         require(_isOnAuction(auction));
1439         _cancelAuction(_auctionId, auction.seller);
1440     }
1441 
1442     function getAuction(uint256 _auctionId)
1443         external
1444         view
1445         returns
1446     (
1447         address seller,
1448         uint256 amount,
1449         uint256 startingPrice,
1450         uint256 endingPrice,
1451         uint256 duration,
1452         uint256 startedAt
1453     ) {
1454         Auction storage auction = auctions[_auctionId];
1455         require(_isOnAuction(auction));
1456         return (
1457             auction.seller,
1458             auction.amount,
1459             auction.startingPrice,
1460             auction.endingPrice,
1461             auction.duration,
1462             auction.startedAt
1463         );
1464     }
1465 
1466     function getCurrentPrice(uint256 _auctionId)
1467         external
1468         view
1469         returns (uint256)
1470     {
1471         Auction storage auction = auctions[_auctionId];
1472         require(_isOnAuction(auction));
1473         return _currentPrice(auction);
1474     }
1475 
1476 
1477 
1478 
1479 
1480     function _escrow(address _owner, uint256 _amount) internal {
1481         tokenContract.transferFromFlower(_owner, this, _amount);
1482     }
1483 
1484     function _transfer(address _receiver, uint256 _amount) internal {
1485         tokenContract.transferFlower(_receiver, _amount);
1486     }
1487 
1488     function _addAuction(Auction _auction) internal {
1489         require(_auction.duration >= 1 minutes);
1490 
1491         currentAuctionId++;
1492         auctions[currentAuctionId] = _auction;
1493         sellerToAuction[_auction.seller] = currentAuctionId;
1494 
1495         AuctionCreated(
1496             currentAuctionId,
1497             _auction.seller,
1498             _auction.amount,
1499             uint256(_auction.startingPrice),
1500             uint256(_auction.endingPrice),
1501             uint256(_auction.duration)
1502         );
1503     }
1504 
1505     function _cancelAuction(uint256 _auctionId, address _seller) internal {
1506         uint256 amount = auctions[_auctionId].amount;
1507         delete sellerToAuction[auctions[_auctionId].seller];
1508         delete auctions[_auctionId];
1509         _transfer(_seller, amount);
1510         AuctionCancelled(_auctionId);
1511     }
1512 
1513     function _bid(uint256 _auctionId, uint256 _amount, uint256 _bidAmount)
1514         internal
1515         returns (uint256)
1516     {
1517         Auction storage auction = auctions[_auctionId];
1518         require(_isOnAuction(auction));
1519         uint256 price = _currentPrice(auction);
1520         uint256 totalPrice = price * _amount;
1521         require(_bidAmount >= totalPrice);
1522         auction.amount -= _amount;
1523 
1524         address seller = auction.seller;
1525 
1526         if (totalPrice > 0) {
1527             uint256 auctioneerCut = _computeCut(totalPrice);
1528             uint256 sellerProceeds = totalPrice - auctioneerCut;
1529             seller.transfer(sellerProceeds);
1530         }
1531         uint256 bidExcess = _bidAmount - totalPrice;
1532         msg.sender.transfer(bidExcess);
1533 
1534         if (auction.amount == 0) {
1535             AuctionSoldOut(_auctionId);
1536             delete auctions[_auctionId];
1537         } else {
1538             AuctionSuccessful(_auctionId, _amount, msg.sender);
1539         }
1540 
1541         return totalPrice;
1542     }
1543 
1544     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1545         return (_auction.startedAt > 0);
1546     }
1547 
1548     function _currentPrice(Auction storage _auction)
1549         internal
1550         view
1551         returns (uint256)
1552     {
1553         uint256 secondsPassed = 0;
1554 
1555         if (now > _auction.startedAt) {
1556             secondsPassed = now - _auction.startedAt;
1557         }
1558 
1559         return _computeCurrentPrice(
1560             _auction.startingPrice,
1561             _auction.endingPrice,
1562             _auction.duration,
1563             secondsPassed
1564         );
1565     }
1566 
1567     function _computeCurrentPrice(
1568         uint256 _startingPrice,
1569         uint256 _endingPrice,
1570         uint256 _duration,
1571         uint256 _secondsPassed
1572     )
1573         internal
1574         pure
1575         returns (uint256)
1576     {
1577         if (_secondsPassed >= _duration) {
1578             return _endingPrice;
1579         } else {
1580             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1581             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1582             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1583             return uint256(currentPrice);
1584         }
1585     }
1586 
1587     function _computeCut(uint256 _price) internal view returns (uint256) {
1588         return _price * ownerCut / 10000;
1589     }
1590 
1591 }