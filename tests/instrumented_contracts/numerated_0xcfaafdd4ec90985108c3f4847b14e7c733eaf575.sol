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
711 		if (flower.current < 10 + REMAINING_AMOUNT) { // MARK: Modify it
712 			return flower.price;
713 		} else if (flower.current < 30 + REMAINING_AMOUNT) { // MARK: Modify it
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
865 		paused = true;
866 
867 		ceoAddress = msg.sender;
868 		cooAddress = msg.sender;
869 	}
870 
871 	function setNewAddress(address _v2Address) external onlyCEO whenPaused {
872     newContractAddress = _v2Address;
873     ContractUpgrade(_v2Address);
874   }
875 
876   function() external payable {
877     require(
878       msg.sender == address(diamondAuction) ||
879       msg.sender == address(flowerAuction)
880     );
881   }
882 	function withdrawBalance(uint256 amount) external onlyCFO {
883 		cfoAddress.transfer(amount);
884 	}
885 }
886 
887 contract ClockAuctionBase {
888 
889     // Represents an auction on an NFT
890     struct Auction {
891         // Current owner of NFT
892         address seller;
893         // Price (in wei) at beginning of auction
894         uint128 startingPrice;
895         // Price (in wei) at end of auction
896         uint128 endingPrice;
897         // Duration (in seconds) of auction
898         uint64 duration;
899         // Time when auction started
900         // NOTE: 0 if this auction has been concluded
901         uint64 startedAt;
902     }
903 
904     // Reference to contract tracking NFT ownership
905     ERC721 public nonFungibleContract;
906 
907     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
908     // Values 0-10,000 map to 0%-100%
909     uint256 public ownerCut;
910 
911     // Map from token ID to their corresponding auction.
912     mapping (uint256 => Auction) tokenIdToAuction;
913 
914     event AuctionCreated(uint256 indexed tokenId, address indexed seller, uint256 startingPrice, uint256 endingPrice, uint256 duration);
915     event AuctionSuccessful(uint256 indexed tokenId, uint256 totalPrice, address winner);
916     event AuctionCancelled(uint256 indexed tokenId);
917 
918     /// @dev Returns true if the claimant owns the token.
919     /// @param _claimant - Address claiming to own the token.
920     /// @param _tokenId - ID of token whose ownership to verify.
921     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
922         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
923     }
924 
925     /// @dev Escrows the NFT, assigning ownership to this contract.
926     /// Throws if the escrow fails.
927     /// @param _owner - Current owner address of token to escrow.
928     /// @param _tokenId - ID of token whose approval to verify.
929     function _escrow(address _owner, uint256 _tokenId) internal {
930         // it will throw if transfer fails
931         nonFungibleContract.transferFrom(_owner, this, _tokenId);
932     }
933 
934     /// @dev Transfers an NFT owned by this contract to another address.
935     /// Returns true if the transfer succeeds.
936     /// @param _receiver - Address to transfer NFT to.
937     /// @param _tokenId - ID of token to transfer.
938     function _transfer(address _receiver, uint256 _tokenId) internal {
939         // it will throw if transfer fails
940         nonFungibleContract.transfer(_receiver, _tokenId);
941     }
942 
943     /// @dev Adds an auction to the list of open auctions. Also fires the
944     ///  AuctionCreated event.
945     /// @param _tokenId The ID of the token to be put on auction.
946     /// @param _auction Auction to add.
947     function _addAuction(uint256 _tokenId, Auction _auction) internal {
948         // Require that all auctions have a duration of
949         // at least one minute. (Keeps our math from getting hairy!)
950         require(_auction.duration >= 1 minutes);
951 
952         tokenIdToAuction[_tokenId] = _auction;
953 
954         AuctionCreated(
955             uint256(_tokenId),
956             _auction.seller,
957             uint256(_auction.startingPrice),
958             uint256(_auction.endingPrice),
959             uint256(_auction.duration)
960         );
961     }
962 
963     /// @dev Cancels an auction unconditionally.
964     function _cancelAuction(uint256 _tokenId, address _seller) internal {
965         _removeAuction(_tokenId);
966         _transfer(_seller, _tokenId);
967         AuctionCancelled(_tokenId);
968     }
969 
970     /// @dev Computes the price and transfers winnings.
971     /// Does NOT transfer ownership of token.
972     function _bid(uint256 _tokenId, uint256 _bidAmount)
973         internal
974         returns (uint256)
975     {
976         // Get a reference to the auction struct
977         Auction storage auction = tokenIdToAuction[_tokenId];
978 
979         // Explicitly check that this auction is currently live.
980         // (Because of how Ethereum mappings work, we can't just count
981         // on the lookup above failing. An invalid _tokenId will just
982         // return an auction object that is all zeros.)
983         require(_isOnAuction(auction));
984 
985         // Check that the bid is greater than or equal to the current price
986         uint256 price = _currentPrice(auction);
987         require(_bidAmount >= price);
988 
989         // Grab a reference to the seller before the auction struct
990         // gets deleted.
991         address seller = auction.seller;
992 
993         // The bid is good! Remove the auction before sending the fees
994         // to the sender so we can't have a reentrancy attack.
995         _removeAuction(_tokenId);
996 
997         // Transfer proceeds to seller (if there are any!)
998         if (price > 0) {
999             // Calculate the auctioneer's cut.
1000             // (NOTE: _computeCut() is guaranteed to return a
1001             // value <= price, so this subtraction can't go negative.)
1002             uint256 auctioneerCut = _computeCut(price);
1003             uint256 sellerProceeds = price - auctioneerCut;
1004 
1005             // NOTE: Doing a transfer() in the middle of a complex
1006             // method like this is generally discouraged because of
1007             // reentrancy attacks and DoS attacks if the seller is
1008             // a contract with an invalid fallback function. We explicitly
1009             // guard against reentrancy attacks by removing the auction
1010             // before calling transfer(), and the only thing the seller
1011             // can DoS is the sale of their own asset! (And if it's an
1012             // accident, they can call cancelAuction(). )
1013             seller.transfer(sellerProceeds);
1014         }
1015 
1016         // Calculate any excess funds included with the bid. If the excess
1017         // is anything worth worrying about, transfer it back to bidder.
1018         // NOTE: We checked above that the bid amount is greater than or
1019         // equal to the price so this cannot underflow.
1020         uint256 bidExcess = _bidAmount - price;
1021 
1022         // Return the funds. Similar to the previous transfer, this is
1023         // not susceptible to a re-entry attack because the auction is
1024         // removed before any transfers occur.
1025         msg.sender.transfer(bidExcess);
1026 
1027         // Tell the world!
1028         AuctionSuccessful(_tokenId, price, msg.sender);
1029 
1030         return price;
1031     }
1032 
1033     /// @dev Removes an auction from the list of open auctions.
1034     /// @param _tokenId - ID of NFT on auction.
1035     function _removeAuction(uint256 _tokenId) internal {
1036         delete tokenIdToAuction[_tokenId];
1037     }
1038 
1039     /// @dev Returns true if the NFT is on auction.
1040     /// @param _auction - Auction to check.
1041     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1042         return (_auction.startedAt > 0);
1043     }
1044 
1045     /// @dev Returns current price of an NFT on auction. Broken into two
1046     ///  functions (this one, that computes the duration from the auction
1047     ///  structure, and the other that does the price computation) so we
1048     ///  can easily test that the price computation works correctly.
1049     function _currentPrice(Auction storage _auction)
1050         internal
1051         view
1052         returns (uint256)
1053     {
1054         uint256 secondsPassed = 0;
1055 
1056         // A bit of insurance against negative values (or wraparound).
1057         // Probably not necessary (since Ethereum guarnatees that the
1058         // now variable doesn't ever go backwards).
1059         if (now > _auction.startedAt) {
1060             secondsPassed = now - _auction.startedAt;
1061         }
1062 
1063         return _computeCurrentPrice(
1064             _auction.startingPrice,
1065             _auction.endingPrice,
1066             _auction.duration,
1067             secondsPassed
1068         );
1069     }
1070 
1071     /// @dev Computes the current price of an auction. Factored out
1072     ///  from _currentPrice so we can run extensive unit tests.
1073     ///  When testing, make this function public and turn on
1074     ///  `Current price computation` test suite.
1075     function _computeCurrentPrice(
1076         uint256 _startingPrice,
1077         uint256 _endingPrice,
1078         uint256 _duration,
1079         uint256 _secondsPassed
1080     )
1081         internal
1082         pure
1083         returns (uint256)
1084     {
1085         // NOTE: We don't use SafeMath (or similar) in this function because
1086         //  all of our public functions carefully cap the maximum values for
1087         //  time (at 64-bits) and currency (at 128-bits). _duration is
1088         //  also known to be non-zero (see the require() statement in
1089         //  _addAuction())
1090         if (_secondsPassed >= _duration) {
1091             // We've reached the end of the dynamic pricing portion
1092             // of the auction, just return the end price.
1093             return _endingPrice;
1094         } else {
1095             // Starting price can be higher than ending price (and often is!), so
1096             // this delta can be negative.
1097             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1098 
1099             // This multiplication can't overflow, _secondsPassed will easily fit within
1100             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
1101             // will always fit within 256-bits.
1102             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1103 
1104             // currentPriceChange can be negative, but if so, will have a magnitude
1105             // less that _startingPrice. Thus, this result will always end up positive.
1106             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1107 
1108             return uint256(currentPrice);
1109         }
1110     }
1111 
1112     /// @dev Computes owner's cut of a sale.
1113     /// @param _price - Sale price of NFT.
1114     function _computeCut(uint256 _price) internal view returns (uint256) {
1115         // NOTE: We don't use SafeMath (or similar) in this function because
1116         //  all of our entry functions carefully cap the maximum values for
1117         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1118         //  statement in the ClockAuction constructor). The result of this
1119         //  function is always guaranteed to be <= _price.
1120         return _price * ownerCut / 10000;
1121     }
1122 
1123 }
1124 
1125 
1126 
1127 contract ClockAuction is Pausable, ClockAuctionBase {
1128 
1129     /// @dev The ERC-165 interface signature for ERC-721.
1130     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1131     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1132     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1133 
1134     /// @dev Constructor creates a reference to the NFT ownership contract
1135     ///  and verifies the owner cut is in the valid range.
1136     /// @param _nftAddress - address of a deployed contract implementing
1137     ///  the Nonfungible Interface.
1138     /// @param _cut - percent cut the owner takes on each auction, must be
1139     ///  between 0-10,000.
1140     function ClockAuction(address _nftAddress, uint256 _cut) public {
1141         require(_cut <= 10000);
1142         ownerCut = _cut;
1143 
1144         ERC721 candidateContract = ERC721(_nftAddress);
1145         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1146         nonFungibleContract = candidateContract;
1147     }
1148 
1149     /// @dev Remove all Ether from the contract, which is the owner's cuts
1150     ///  as well as any Ether sent directly to the contract address.
1151     ///  Always transfers to the NFT contract, but can be called either by
1152     ///  the owner or the NFT contract.
1153     function withdrawBalance() external {
1154         address nftAddress = address(nonFungibleContract);
1155 
1156         require(
1157             msg.sender == owner ||
1158             msg.sender == nftAddress
1159         );
1160         // We are using this boolean method to make sure that even if one fails it will still work
1161         // bool res = nftAddress.send(this.balance);
1162         nftAddress.send(this.balance);
1163     }
1164 
1165     /// @dev Creates and begins a new auction.
1166     /// @param _tokenId - ID of token to auction, sender must be owner.
1167     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1168     /// @param _endingPrice - Price of item (in wei) at end of auction.
1169     /// @param _duration - Length of time to move between starting
1170     ///  price and ending price (in seconds).
1171     /// @param _seller - Seller, if not the message sender
1172     function createAuction(
1173         uint256 _tokenId,
1174         uint256 _startingPrice,
1175         uint256 _endingPrice,
1176         uint256 _duration,
1177         address _seller
1178     )
1179         external
1180         whenNotPaused
1181     {
1182         // Sanity check that no inputs overflow how many bits we've allocated
1183         // to store them in the auction struct.
1184         require(_startingPrice == uint256(uint128(_startingPrice)));
1185         require(_endingPrice == uint256(uint128(_endingPrice)));
1186         require(_duration == uint256(uint64(_duration)));
1187 
1188         require(_owns(msg.sender, _tokenId));
1189         _escrow(msg.sender, _tokenId);
1190         Auction memory auction = Auction(
1191             _seller,
1192             uint128(_startingPrice),
1193             uint128(_endingPrice),
1194             uint64(_duration),
1195             uint64(now)
1196         );
1197         _addAuction(_tokenId, auction);
1198     }
1199 
1200     /// @dev Bids on an open auction, completing the auction and transferring
1201     ///  ownership of the NFT if enough Ether is supplied.
1202     /// @param _tokenId - ID of token to bid on.
1203     function bid(uint256 _tokenId)
1204         external
1205         payable
1206         whenNotPaused
1207     {
1208         // _bid will throw if the bid or funds transfer fails
1209         _bid(_tokenId, msg.value);
1210         _transfer(msg.sender, _tokenId);
1211     }
1212 
1213     /// @dev Cancels an auction that hasn't been won yet.
1214     ///  Returns the NFT to original owner.
1215     /// @notice This is a state-modifying function that can
1216     ///  be called while the contract is paused.
1217     /// @param _tokenId - ID of token on auction
1218     function cancelAuction(uint256 _tokenId)
1219         external
1220     {
1221         Auction storage auction = tokenIdToAuction[_tokenId];
1222         require(_isOnAuction(auction));
1223         address seller = auction.seller;
1224         require(msg.sender == seller);
1225         _cancelAuction(_tokenId, seller);
1226     }
1227 
1228     /// @dev Cancels an auction when the contract is paused.
1229     ///  Only the owner may do this, and NFTs are returned to
1230     ///  the seller. This should only be used in emergencies.
1231     /// @param _tokenId - ID of the NFT on auction to cancel.
1232     function cancelAuctionWhenPaused(uint256 _tokenId)
1233         whenPaused
1234         onlyOwner
1235         external
1236     {
1237         Auction storage auction = tokenIdToAuction[_tokenId];
1238         require(_isOnAuction(auction));
1239         _cancelAuction(_tokenId, auction.seller);
1240     }
1241 
1242     /// @dev Returns auction info for an NFT on auction.
1243     /// @param _tokenId - ID of NFT on auction.
1244     function getAuction(uint256 _tokenId)
1245         external
1246         view
1247         returns
1248     (
1249         address seller,
1250         uint256 startingPrice,
1251         uint256 endingPrice,
1252         uint256 duration,
1253         uint256 startedAt
1254     ) {
1255         Auction storage auction = tokenIdToAuction[_tokenId];
1256         require(_isOnAuction(auction));
1257         return (
1258             auction.seller,
1259             auction.startingPrice,
1260             auction.endingPrice,
1261             auction.duration,
1262             auction.startedAt
1263         );
1264     }
1265 
1266     /// @dev Returns the current price of an auction.
1267     /// @param _tokenId - ID of the token price we are checking.
1268     function getCurrentPrice(uint256 _tokenId)
1269         external
1270         view
1271         returns (uint256)
1272     {
1273         Auction storage auction = tokenIdToAuction[_tokenId];
1274         require(_isOnAuction(auction));
1275         return _currentPrice(auction);
1276     }
1277 
1278 }
1279 
1280 contract DiamondAuction is ClockAuction {
1281 
1282     // @dev Sanity check that allows us to ensure that we are pointing to the
1283     //  right auction in our setSaleAuctionAddress() call.
1284     bool public isDiamondAuction = true;
1285 
1286     event AuctionCreated(uint256 indexed tokenId, address indexed seller, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1287     event AuctionSuccessful(uint256 indexed tokenId, uint256 totalPrice, address winner);
1288     event AuctionCancelled(uint256 indexed tokenId);
1289     
1290     // Delegate constructor
1291     function DiamondAuction(address _nftAddr) public
1292         ClockAuction(_nftAddr, 0) {}
1293 
1294     /// @dev Creates and begins a new auction.
1295     /// @param _tokenId - ID of token to auction, sender must be owner.
1296     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1297     /// @param _endingPrice - Price of item (in wei) at end of auction.
1298     /// @param _duration - Length of auction (in seconds).
1299     /// @param _seller - Seller, if not the message sender
1300     function createAuction(
1301         uint256 _tokenId,
1302         uint256 _startingPrice,
1303         uint256 _endingPrice,
1304         uint256 _duration,
1305         address _seller
1306     )
1307         external
1308     {
1309         // Sanity check that no inputs overflow how many bits we've allocated
1310         // to store them in the auction struct.
1311         require(_startingPrice == uint256(uint128(_startingPrice)));
1312         require(_endingPrice == uint256(uint128(_endingPrice)));
1313         require(_duration == uint256(uint64(_duration)));
1314 
1315         require(msg.sender == address(nonFungibleContract));
1316         _escrow(_seller, _tokenId);
1317         Auction memory auction = Auction(
1318             _seller,
1319             uint128(_startingPrice),
1320             uint128(_endingPrice),
1321             uint64(_duration),
1322             uint64(now)
1323         );
1324         _addAuction(_tokenId, auction);
1325     }
1326 
1327     /// @dev Updates lastSalePrice if seller is the nft contract
1328     /// Otherwise, works the same as default bid method.
1329     function bid(uint256 _tokenId)
1330         external
1331         payable
1332     {
1333         // _bid verifies token ID size
1334         tokenIdToAuction[_tokenId].seller;
1335         _bid(_tokenId, msg.value);
1336         _transfer(msg.sender, _tokenId);
1337     }
1338 
1339 }
1340 
1341 contract FlowerAuction is Pausable {
1342     struct Auction {
1343         address seller;
1344         uint256 amount;
1345         uint128 startingPrice;
1346         uint128 endingPrice;
1347         uint64 duration;
1348         uint64 startedAt;
1349     }
1350 
1351     EIP20Interface public tokenContract;
1352 
1353     uint256 public ownerCut;
1354 
1355     mapping (uint256 => Auction) auctions;
1356     mapping (address => uint256) sellerToAuction;
1357     uint256 public currentAuctionId;
1358 
1359     event AuctionCreated(uint256 indexed auctionId, address indexed seller, uint256 amount, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1360     event AuctionSuccessful(uint256 indexed auctionId, uint256 amount, address winner);
1361     event AuctionSoldOut(uint256 indexed auctionId);
1362     event AuctionCancelled(uint256 indexed auctionId);
1363 
1364     bytes4 constant InterfaceSignature_EIP20 = bytes4(0x98474109);
1365 
1366     bool public isFlowerAuction = true;
1367 
1368     function FlowerAuction(address _nftAddress) public {
1369         ownerCut = 0;
1370 
1371         EIP20Interface candidateContract = EIP20Interface(_nftAddress);
1372         require(candidateContract.supportsEIP20Interface(InterfaceSignature_EIP20));
1373         tokenContract = candidateContract;
1374     }
1375 
1376     function createAuction(
1377         uint256 _amount,
1378         uint256 _startingPrice,
1379         uint256 _endingPrice,
1380         uint256 _duration,
1381         address _seller
1382     )
1383         external
1384     {
1385         require(_startingPrice == uint256(uint128(_startingPrice)));
1386         require(_endingPrice == uint256(uint128(_endingPrice)));
1387         require(_duration == uint256(uint64(_duration)));
1388 
1389         require(msg.sender == address(tokenContract));
1390         _escrow(_seller, _amount);
1391         Auction memory auction = Auction(
1392             _seller,
1393             _amount,
1394             uint128(_startingPrice),
1395             uint128(_endingPrice),
1396             uint64(_duration),
1397             uint64(now)
1398         );
1399         _addAuction(auction);
1400     }
1401 
1402     function bid(uint256 _auctionId, uint256 _amount)
1403         external
1404         payable
1405     {
1406         _bid(_auctionId, _amount, msg.value);
1407         _transfer(msg.sender, _amount);
1408     }
1409 
1410 
1411 
1412 
1413     function withdrawBalance() external {
1414         address nftAddress = address(tokenContract);
1415 
1416         require(
1417             msg.sender == owner ||
1418             msg.sender == nftAddress
1419         );
1420         nftAddress.send(this.balance);
1421     }
1422 
1423 
1424     function cancelAuction(uint256 _auctionId)
1425         external
1426     {
1427         Auction storage auction = auctions[_auctionId];
1428         require(_isOnAuction(auction));
1429         address seller = auction.seller;
1430         require(msg.sender == seller);
1431         _cancelAuction(_auctionId, seller);
1432     }
1433 
1434     function cancelAuctionWhenPaused(uint256 _auctionId)
1435         whenPaused
1436         onlyOwner
1437         external
1438     {
1439         Auction storage auction = auctions[_auctionId];
1440         require(_isOnAuction(auction));
1441         _cancelAuction(_auctionId, auction.seller);
1442     }
1443 
1444     function getAuction(uint256 _auctionId)
1445         external
1446         view
1447         returns
1448     (
1449         address seller,
1450         uint256 amount,
1451         uint256 startingPrice,
1452         uint256 endingPrice,
1453         uint256 duration,
1454         uint256 startedAt
1455     ) {
1456         Auction storage auction = auctions[_auctionId];
1457         require(_isOnAuction(auction));
1458         return (
1459             auction.seller,
1460             auction.amount,
1461             auction.startingPrice,
1462             auction.endingPrice,
1463             auction.duration,
1464             auction.startedAt
1465         );
1466     }
1467 
1468     function getCurrentPrice(uint256 _auctionId)
1469         external
1470         view
1471         returns (uint256)
1472     {
1473         Auction storage auction = auctions[_auctionId];
1474         require(_isOnAuction(auction));
1475         return _currentPrice(auction);
1476     }
1477 
1478 
1479 
1480 
1481 
1482     function _escrow(address _owner, uint256 _amount) internal {
1483         tokenContract.transferFromFlower(_owner, this, _amount);
1484     }
1485 
1486     function _transfer(address _receiver, uint256 _amount) internal {
1487         tokenContract.transferFlower(_receiver, _amount);
1488     }
1489 
1490     function _addAuction(Auction _auction) internal {
1491         require(_auction.duration >= 1 minutes);
1492 
1493         currentAuctionId++;
1494         auctions[currentAuctionId] = _auction;
1495         sellerToAuction[_auction.seller] = currentAuctionId;
1496 
1497         AuctionCreated(
1498             currentAuctionId,
1499             _auction.seller,
1500             _auction.amount,
1501             uint256(_auction.startingPrice),
1502             uint256(_auction.endingPrice),
1503             uint256(_auction.duration)
1504         );
1505     }
1506 
1507     function _cancelAuction(uint256 _auctionId, address _seller) internal {
1508         uint256 amount = auctions[_auctionId].amount;
1509         delete sellerToAuction[auctions[_auctionId].seller];
1510         delete auctions[_auctionId];
1511         _transfer(_seller, amount);
1512         AuctionCancelled(_auctionId);
1513     }
1514 
1515     function _bid(uint256 _auctionId, uint256 _amount, uint256 _bidAmount)
1516         internal
1517         returns (uint256)
1518     {
1519         Auction storage auction = auctions[_auctionId];
1520         require(_isOnAuction(auction));
1521         uint256 price = _currentPrice(auction);
1522         uint256 totalPrice = price * _amount;
1523         require(_bidAmount >= totalPrice);
1524         auction.amount -= _amount;
1525 
1526         address seller = auction.seller;
1527 
1528         if (totalPrice > 0) {
1529             uint256 auctioneerCut = _computeCut(totalPrice);
1530             uint256 sellerProceeds = totalPrice - auctioneerCut;
1531             seller.transfer(sellerProceeds);
1532         }
1533         uint256 bidExcess = _bidAmount - totalPrice;
1534         msg.sender.transfer(bidExcess);
1535 
1536         if (auction.amount == 0) {
1537             AuctionSoldOut(_auctionId);
1538             delete auctions[_auctionId];
1539         } else {
1540             AuctionSuccessful(_auctionId, _amount, msg.sender);
1541         }
1542 
1543         return totalPrice;
1544     }
1545 
1546     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1547         return (_auction.startedAt > 0);
1548     }
1549 
1550     function _currentPrice(Auction storage _auction)
1551         internal
1552         view
1553         returns (uint256)
1554     {
1555         uint256 secondsPassed = 0;
1556 
1557         if (now > _auction.startedAt) {
1558             secondsPassed = now - _auction.startedAt;
1559         }
1560 
1561         return _computeCurrentPrice(
1562             _auction.startingPrice,
1563             _auction.endingPrice,
1564             _auction.duration,
1565             secondsPassed
1566         );
1567     }
1568 
1569     function _computeCurrentPrice(
1570         uint256 _startingPrice,
1571         uint256 _endingPrice,
1572         uint256 _duration,
1573         uint256 _secondsPassed
1574     )
1575         internal
1576         pure
1577         returns (uint256)
1578     {
1579         if (_secondsPassed >= _duration) {
1580             return _endingPrice;
1581         } else {
1582             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1583             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1584             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1585             return uint256(currentPrice);
1586         }
1587     }
1588 
1589     function _computeCut(uint256 _price) internal view returns (uint256) {
1590         return _price * ownerCut / 10000;
1591     }
1592 
1593 }