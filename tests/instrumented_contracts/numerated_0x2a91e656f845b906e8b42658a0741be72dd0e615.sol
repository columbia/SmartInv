1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // Gold Saucer Auction by 0xInuarashi
5 // Project: Gangster All Star
6 
7 ///////////////////////////////////////////////////////
8 /////                   Ownable                   /////
9 ///////////////////////////////////////////////////////
10 
11 abstract contract Ownable {
12     address public owner;
13     constructor() { owner = msg.sender; }
14     modifier onlyOwner { require(owner == msg.sender, "Not Owner!"); _; }
15     function transferOwnership(address new_) external onlyOwner { owner = new_; }
16 }
17 
18 ///////////////////////////////////////////////////////
19 /////             Payable Governance              /////
20 ///////////////////////////////////////////////////////
21 
22 abstract contract PayableGovernance is Ownable {
23     // Special Access
24     address public payableGovernanceSetter;
25     constructor() payable { payableGovernanceSetter = msg.sender; }
26     modifier onlyPayableGovernanceSetter {
27         require(msg.sender == payableGovernanceSetter, 
28             "PayableGovernance: Caller is not Setter!"); _; }
29     function reouncePayableGovernancePermissions() public onlyPayableGovernanceSetter {
30         payableGovernanceSetter = address(0x0); }
31 
32     // Receivable Fallback
33     event Received(address from, uint amount);
34     receive() external payable { emit Received(msg.sender, msg.value); }
35 
36     // Required Variables
37     address payable[] internal _payableGovernanceAddresses;
38     uint256[] internal _payableGovernanceShares;    
39     mapping(address => bool) public addressToEmergencyUnlocked;
40 
41     // Withdraw Functionality
42     function _withdraw(address payable address_, uint256 amount_) internal {
43         (bool success, ) = payable(address_).call{value: amount_}("");
44         require(success, "Transfer failed");
45     }
46 
47     // Governance Functions
48     function setPayableGovernanceShareholders(address payable[] memory addresses_,
49     uint256[] memory shares_) public onlyPayableGovernanceSetter {
50         require(_payableGovernanceAddresses.length == 0 
51             && _payableGovernanceShares.length == 0, 
52             "Payable Governance already set! To set again, reset first!");
53         require(addresses_.length == shares_.length, 
54             "Address and Shares length mismatch!");
55 
56         uint256 _totalShares;
57         
58         for (uint256 i = 0; i < addresses_.length; i++) {
59             _totalShares += shares_[i];
60             _payableGovernanceAddresses.push(addresses_[i]);
61             _payableGovernanceShares.push(shares_[i]);
62         }
63         require(_totalShares == 1000, "Total Shares is not 1000!");
64     }
65     function resetPayableGovernanceShareholders() public onlyPayableGovernanceSetter {
66         while (_payableGovernanceAddresses.length != 0) {
67             _payableGovernanceAddresses.pop(); }
68         while (_payableGovernanceShares.length != 0) {
69             _payableGovernanceShares.pop(); }
70     }
71 
72     // Governance View Functions
73     function balance() public view returns (uint256) {
74         return address(this).balance;
75     }
76     function payableGovernanceAddresses() public view 
77     returns (address payable[] memory) {
78         return _payableGovernanceAddresses;
79     }
80     function payableGovernanceShares() public view returns (uint256[] memory) {
81         return _payableGovernanceShares;
82     }
83 
84     // Withdraw Functions
85     function withdrawEther() public onlyOwner {
86         // require that there has been payable governance set.
87         require(_payableGovernanceAddresses.length > 0 
88             && _payableGovernanceShares.length > 0, 
89             "Payable governance not set yet!");
90          // this should never happen
91         require(_payableGovernanceAddresses.length 
92             == _payableGovernanceShares.length, 
93             "Payable governance length mismatch!");
94         
95         // now, we check that the governance shares equal to 1000.
96         uint256 _totalPayableShares;
97         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
98             _totalPayableShares += _payableGovernanceShares[i]; }
99         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
100         
101         // // now, we start the withdrawal process if all conditionals pass
102         // store current balance in local memory
103         uint256 _totalETH = address(this).balance; 
104 
105         // withdraw loop for payable governance
106         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
107             uint256 _ethToWithdraw = ((_totalETH * _payableGovernanceShares[i]) / 1000);
108             _withdraw(_payableGovernanceAddresses[i], _ethToWithdraw);
109         }
110     }
111 
112     function viewWithdrawAmounts() public view onlyOwner returns (uint256[] memory) {
113         // require that there has been payable governance set.
114         require(_payableGovernanceAddresses.length > 0 
115             && _payableGovernanceShares.length > 0, 
116             "Payable governance not set yet!");
117          // this should never happen
118         require(_payableGovernanceAddresses.length 
119             == _payableGovernanceShares.length, 
120             "Payable governance length mismatch!");
121         
122         // now, we check that the governance shares equal to 1000.
123         uint256 _totalPayableShares;
124         for (uint256 i = 0; i < _payableGovernanceShares.length; i++) {
125             _totalPayableShares += _payableGovernanceShares[i]; }
126         require(_totalPayableShares == 1000, "Payable Governance Shares is not 1000!");
127         
128         // // now, we start the array creation process if all conditionals pass
129         // store current balance in local memory and instantiate array for input
130         uint256 _totalETH = address(this).balance; 
131         uint256[] memory _withdrawals = new uint256[] 
132             (_payableGovernanceAddresses.length + 2);
133 
134         // array creation loop for payable governance values 
135         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
136             _withdrawals[i] = ( (_totalETH * _payableGovernanceShares[i]) / 1000 );
137         }
138         
139         // push two last array spots as total eth and added eths of withdrawals
140         _withdrawals[_payableGovernanceAddresses.length] = _totalETH;
141         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
142             _withdrawals[_payableGovernanceAddresses.length + 1] += _withdrawals[i]; }
143 
144         // return the final array data
145         return _withdrawals;
146     }
147 
148     // Shareholder Governance
149     modifier onlyShareholder {
150         bool _isShareholder;
151         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
152             if (msg.sender == _payableGovernanceAddresses[i]) {
153                 _isShareholder = true;
154             }
155         }
156         require(_isShareholder, "You are not a shareholder!");
157         _;
158     }
159     function unlockEmergencyFunctionsAsShareholder() public onlyShareholder {
160         addressToEmergencyUnlocked[msg.sender] = true;
161     }
162 
163     // Emergency Functions
164     modifier onlyEmergency {
165         for (uint256 i = 0; i < _payableGovernanceAddresses.length; i++) {
166             require(addressToEmergencyUnlocked[_payableGovernanceAddresses[i]],
167                 "Emergency Functions are not unlocked!");
168         }
169         _;
170     }
171     function emergencyWithdrawEther() public onlyOwner onlyEmergency {
172         _withdraw(payable(msg.sender), address(this).balance);
173     }
174 
175     // Proxy Padding
176     bytes32[50] private proxyPadding;
177 }
178 
179 ///////////////////////////////////////////////////////
180 /////                Bucket Auction               /////
181 ///////////////////////////////////////////////////////
182 
183 interface iGasEvo {
184     function mintAsController(address to_, uint256 amount_) external;
185 }
186 
187 contract BucketAuction is Ownable {
188 
189     /** @dev Note: There is no ETH Withdrawal function here! Add it yourself! */ 
190 
191     /** @dev implementation: here is a basic withdrawal using Ownable
192     
193     function ownerWithdraw() external onlyOwner {
194         _sendETH(payable(msg.sender), address(this).balance);
195     }
196     */
197 
198     // Interface and Constructor
199     iGasEvo public GasEvo;
200     constructor(address gasEvo_) { GasEvo = iGasEvo(gasEvo_); }
201     function O_setGasEvo(address gasEvo_) external onlyOwner { 
202         GasEvo = iGasEvo(gasEvo_); }
203 
204     // Events
205     event Bid(address bidder, uint256 bidAmount, uint256 bidderTotal,
206         uint256 bucketTotal);
207     event FinalPriceSet(address setter, uint256 finalPrice);
208 
209     // Testing Events
210     event RefundProcessed(address indexed bidder, uint256 refundAmount);
211     event MintProcessed(address indexed bidder, uint256 mintAmount);
212     
213     // Fixed Configurations
214     uint256 public immutable minCommit = 0.1 ether;
215 
216     // Global Variables
217     uint256 public finalPrice;
218 
219     // Structs
220     struct BidData {
221         uint232 commitment;
222         uint16 totalMinted;
223         bool refundClaimed;
224     }
225 
226     // Mappings
227     mapping(address => BidData) public userToBidData;
228 
229     // Bool Triggers
230     bool public biddingActive;
231 
232     // Administrative Functions
233     function O_setBiddingActive(bool bool_) external onlyOwner { biddingActive = bool_; }
234     function O_setFinalPrice(uint256 finalPrice_) external onlyOwner {
235         require(!biddingActive, "Bidding is active!");
236         finalPrice = finalPrice_;
237         emit FinalPriceSet(msg.sender, finalPrice_);
238     }
239     // Administrative Process of Commits
240     function O_processCommits(address[] calldata bidders_) external onlyOwner {
241         _processCommits(bidders_);
242     }
243 
244     // Internal Calculators
245     function _calMintsFromCommitment(uint256 commitment_, uint256 finalPrice_)
246     internal pure returns (uint256) {
247         return commitment_ / finalPrice_;
248     }
249     function _calRemainderFromCommitment(uint256 commitment_, uint256 finalPrice_)
250     internal pure returns (uint256) {
251         return commitment_ % finalPrice_;
252     }
253 
254     // Internal Processing 
255     function _sendETH(address to_, uint256 amount_) internal {
256         (bool success, ) = to_.call{value: amount_}("");
257         require(success, "Transfer failed");
258     }
259 
260     /** @dev edgeCases:
261      *  Case 1: Refunds fail, breaking the processing
262      *  Solution 1: OwnerMint NFTs + Manual Refund after all processing has finished
263      *  
264      *  Case 2: Mints fail, breaking the processing
265      *  Solution 2: OwnerMint NFTs + Manual Refund after all processing has finished
266      * 
267      *  Case 3: Reentrancy on _internalProcessRefund
268      *  Solution 3: CEI of setting refundClaimed will break the reentrancy attack
269      *
270      *  Case 4: Reentrancy on _internalProcessMint
271      *  Solution 4: CEI of setting totalMinted will break the reentrancy attack
272      *              but even better, just use a normal _mint instead of _safeMint
273     */
274     function _internalProcessRefund(address bidder_, uint256 refundAmount_) internal {
275         userToBidData[bidder_].refundClaimed = true;
276         if (refundAmount_ != 0) { _sendETH(bidder_, refundAmount_); }
277         emit RefundProcessed(bidder_, refundAmount_);
278     }
279     function _internalProcessMint(address bidder_, uint256 mintAmount_) internal {
280         uint16 _mintAmount = uint16(mintAmount_);
281         userToBidData[bidder_].totalMinted += _mintAmount;
282         /** @dev implementation:
283          *  minting code goes here
284         */
285         GasEvo.mintAsController(bidder_, mintAmount_);
286 
287         emit MintProcessed(bidder_, mintAmount_);
288     }
289     function _internalProcessCommit(address bidder_, uint256 finalPrice_) internal {
290         BidData memory _BidData = userToBidData[bidder_];
291         uint256 _commitment = uint256(_BidData.commitment);
292         uint256 _eligibleRefunds = _calRemainderFromCommitment(_commitment, finalPrice_);
293         uint256 _eligibleMints = _calMintsFromCommitment(_commitment, finalPrice_);
294 
295         if (!_BidData.refundClaimed) {
296             _internalProcessRefund(bidder_, _eligibleRefunds);
297         }
298 
299         if (_eligibleMints > _BidData.totalMinted) {
300             uint256 _remainingMints = _eligibleMints - _BidData.totalMinted;
301             _internalProcessMint(bidder_, _remainingMints);
302         }
303     }
304     function _processCommits(address[] calldata bidders_) internal {
305         uint256 _finalPrice = finalPrice;
306         require(_finalPrice != 0, "Final Price not set!");
307         for (uint256 i; i < bidders_.length;) {
308             _internalProcessCommit(bidders_[i], _finalPrice);
309             unchecked { ++i; }
310         }
311     }
312 
313     // Public Bidding Function
314     function bid() public virtual payable {
315         // Require bidding to be active
316         require(biddingActive, "Bidding is not active!");
317         // Require EOA only
318         require(msg.sender == tx.origin, "No Smart Contracts!");
319         // Modulus for Cleaner Bids
320         require(msg.value % 1000000000000000 == 0, 
321             "Please bid with a minimum decimal of 0.001 ETH!");
322         require(msg.value > 0, 
323             "Please bid with msg.value!");
324         
325         // Load the current commitment value from mapping to memory
326         uint256 _currentCommitment = userToBidData[msg.sender].commitment;
327         
328         // Calculate thew new commitment based on the bid
329         uint256 _newCommitment = _currentCommitment + msg.value;
330 
331         // Make sure the new commitment is higher than the minimum commitment
332         require(_newCommitment >= minCommit, "Commitment below minimum!");
333 
334         // Store the new commitment value
335         userToBidData[msg.sender].commitment = uint232(_newCommitment);
336 
337         // Emit Event for Data Parsing and Analysis
338         emit Bid(msg.sender, msg.value, _newCommitment, address(this).balance);
339     }
340 
341     // Public View Functions
342     function getEligibleMints(address bidder_) public view returns (uint256) {
343         require(finalPrice != 0, "Final Price not set!");
344 
345         uint256 _eligibleMints = _calMintsFromCommitment(
346             userToBidData[bidder_].commitment, finalPrice);
347         uint256 _alreadyMinted = userToBidData[bidder_].totalMinted;
348 
349         return (_eligibleMints - _alreadyMinted);
350     }
351     function getRefundAmount(address bidder_) public view returns (uint256) {
352         require(finalPrice != 0, "Final Price not set!");
353 
354         uint256 _remainder = _calRemainderFromCommitment(
355             userToBidData[bidder_].commitment, finalPrice);
356         
357         return !userToBidData[bidder_].refundClaimed ? _remainder : 0;
358     }
359     function queryCommitments(address[] calldata bidders_) external 
360     view returns (BidData[] memory) {
361         uint256 l = bidders_.length;
362         BidData[] memory _BidDatas = new BidData[] (l);
363         for (uint256 i; i < l;) {
364             _BidDatas[i] = userToBidData[bidders_[i]];
365             unchecked { ++i; }
366         }
367         return _BidDatas;
368     }
369 
370     // Proxy Padding
371     bytes32[50] private proxyPadding;
372 }
373 
374 ///////////////////////////////////////////////////////
375 /////                 ERC1155-Like                /////
376 ///////////////////////////////////////////////////////
377 
378 interface ERC1155TokenReceiver {
379     function onERC1155Received(address operator_, address from_, uint256 id_,
380         uint256 amount_, bytes calldata data_) external returns (bytes4);
381     function onERC1155BatchReceived(address operator_, address from_,
382         uint256[] calldata ids_, uint256[] calldata amounts_, bytes calldata data_)
383         external returns (bytes4);
384 }
385 
386 abstract contract GoldSaucerChip is Ownable {
387     
388     // Events
389     event TransferSingle(address indexed operator_, address indexed from_, 
390     address indexed to_, uint256 id_, uint256 amount_);
391     event TransferBatch(address indexed operator_, address indexed from_, 
392     address indexed to_, uint256[] ids_, uint256[] amounts_);
393     event ApprovalForAll(address indexed owner_, address indexed operator_, 
394     bool approved_);
395     event URI(string value_, uint256 indexed id_);
396 
397     // Mappings
398 
399     // mapping(address => mapping(uint256 => uint256)) public balanceOf;
400     mapping(address => mapping(address => bool)) public isApprovedForAll;
401 
402     // Base Info
403     string public name; 
404     string public symbol; 
405 
406     // Setting Name and Symbol (Missing in ERC1155 Generally)
407     constructor(string memory name_, string memory symbol_) {
408         name = name_; 
409         symbol = symbol_; 
410     }
411 
412     function balanceOf(address owner_, uint256 id_) public view virtual returns (uint256) {
413         /** @dev implementation:
414          *  we override this into the parent contract
415          */
416         // // We only return a phantom balance using ID 1
417         // if (id_ != 1) return 0;
418         // return userToBidData[owner_].commitment > 0 ? 1 : 0;
419     }
420 
421     function balanceOfBatch(address[] memory addresses_, uint256[] memory ids_) 
422     public virtual view returns (uint256[] memory) {
423         require(addresses_.length == ids_.length,
424             "ERC1155: accounts and ids length mismatch!");
425         uint256[] memory _balances = new uint256[](addresses_.length);
426         for (uint256 i = 0; i < addresses_.length; i++) {
427             _balances[i] = balanceOf(addresses_[i], ids_[i]);
428         }
429         return _balances;
430     }
431     
432     // URI Display Type Setting (Default to ERC721 Style)
433         // 1 - ERC1155 Style
434         // 2 - ERC721 Style
435         // 3 - Mapping Style
436     uint256 public URIType = 2; 
437     function _setURIType(uint256 uriType_) internal virtual {
438         URIType = uriType_;
439     }
440     function O_setURIType(uint256 uriType_) external onlyOwner {
441         _setURIType(uriType_);
442     }
443 
444     // ERC1155 URI
445     string public _uri;
446     function _setURI(string memory uri_) internal virtual { _uri = uri_; }
447     function O_setURI(string calldata uri_) external onlyOwner { _setURI(uri_); }
448     
449     // ERC721 URI (Override)
450     string internal baseTokenURI; 
451     string internal baseTokenURI_EXT;
452 
453     function _setBaseTokenURI(string memory uri_) internal virtual { 
454         baseTokenURI = uri_; }
455     function _setBaseTokenURI_EXT(string memory ext_) internal virtual {
456         baseTokenURI_EXT = ext_; }
457     function O_setBaseTokenURI(string calldata uri_) external onlyOwner {
458         _setBaseTokenURI(uri_); }
459     function O_setBaseTokenURI_EXT(string calldata ext_) external onlyOwner {
460         _setBaseTokenURI_EXT(ext_); }
461     function _toString(uint256 value_) internal pure returns (string memory) {
462         if (value_ == 0) { return "0"; }
463         uint256 _iterate = value_; uint256 _digits;
464         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
465         bytes memory _buffer = new bytes(_digits);
466         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(
467             48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
468         return string(_buffer); // return string converted bytes of value_
469     }
470 
471     // Mapping Style URI (Override)
472     mapping(uint256 => string) public tokenIdToURI;
473     
474     function _setURIOfToken(uint256 id_, string memory uri_) internal virtual {
475         tokenIdToURI[id_] = uri_; }
476     function O_setURIOfToken(uint256 id_, string calldata uri_) external onlyOwner {
477         _setURIOfToken(id_, uri_); }
478 
479 
480     // URI (0xInuarashi Version)
481     function uri(uint256 id_) public virtual view returns (string memory) {
482         // ERC1155
483         if (URIType == 1) return _uri;
484         // ERC721
485         else if (URIType == 2) return 
486             string(abi.encodePacked(baseTokenURI, _toString(id_), baseTokenURI_EXT));
487         // Mapping 
488         else if (URIType == 3) return tokenIdToURI[id_];
489         else return "";
490     }
491     function tokenURI(uint256 id_) public virtual view returns (string memory) {
492         return uri(id_);
493     }
494 
495     // Internal Logics
496     function _isSameLength(uint256 a, uint256 b) internal pure returns (bool) {
497         return a == b;
498     }
499     function _isApprovedOrOwner(address from_) internal view returns (bool) {
500         return msg.sender == from_ 
501             || isApprovedForAll[from_][msg.sender];
502     }
503     function _ERC1155Supported(address from_, address to_, uint256 id_,
504     uint256 amount_, bytes memory data_) internal {
505         require(to_.code.length == 0 ? to_ != address(0) :
506             ERC1155TokenReceiver(to_).onERC1155Received(
507                 msg.sender, from_, id_, amount_, data_) ==
508             ERC1155TokenReceiver.onERC1155Received.selector,
509                 "_ERC1155Supported(): Unsupported Recipient!"
510         );
511     }
512     function _ERC1155BatchSupported(address from_, address to_, uint256[] memory ids_,
513     uint256[] memory amounts_, bytes memory data_) internal {
514         require(to_.code.length == 0 ? to_ != address(0) :
515             ERC1155TokenReceiver(to_).onERC1155BatchReceived(
516                 msg.sender, from_, ids_, amounts_, data_) ==
517             ERC1155TokenReceiver.onERC1155BatchReceived.selector,
518                 "_ERC1155BatchSupported(): Unsupported Recipient!"
519         );
520     }
521 
522     // ERC1155 Logics
523     function setApprovalForAll(address operator_, bool approved_) public virtual {
524         // isApprovedForAll[msg.sender][operator_] = approved_;
525         // emit ApprovalForAll(msg.sender, operator_, approved_);
526 
527         require(!approved_, "SBT: Soulbound");
528         require(operator_ == address(0), "SBT: Soulbound");
529     }
530 
531     function safeTransferFrom(address from_, address to_, uint256 id_, 
532     uint256 amount_, bytes memory data_) public virtual {
533         // require(_isApprovedOrOwner(from_));
534         
535         // balanceOf[from_][id_] -= amount_;
536         // balanceOf[to_][id_] += amount_;
537 
538         // emit TransferSingle(msg.sender, from_, to_, id_, amount_);
539 
540         // _ERC1155Supported(from_, to_, id_, amount_, data_);
541 
542         require(amount_ == 0, "SBT: Soulbound");
543         require(from_ == address(0), "SBT: Soulbound");
544         require(to_ == address(0), "SBT: Soulbound");
545         require(id_ == 0, "SBT: Soulbound");
546         require(data_.length == 0, "SBT: Soulbound");
547     }
548     function safeBatchTransferFrom(address from_, address to_, uint256[] memory ids_,
549     uint256[] memory amounts_, bytes memory data_) public virtual {
550         // require(_isSameLength(ids_.length, amounts_.length));
551         // require(_isApprovedOrOwner(from_));
552 
553         // for (uint256 i = 0; i < ids_.length; i++) {
554         //     balanceOf[from_][ids_[i]] -= amounts_[i];
555         //     balanceOf[to_][ids_[i]] += amounts_[i];
556         // }
557 
558         // emit TransferBatch(msg.sender, from_, to_, ids_, amounts_);
559 
560         // _ERC1155BatchSupported(from_, to_, ids_, amounts_, data_);
561 
562         require(amounts_.length == 0, "SBT: Soulbound");
563         require(from_ == address(0), "SBT: Soulbound");
564         require(to_ == address(0), "SBT: Soulbound");
565         require(ids_.length == 0, "SBT: Soulbound");
566         require(data_.length == 0, "SBT: Soulbound");
567     }
568 
569     // Phantom Mint
570     function _phantomMintGoldSaucerChip(address to_) internal {
571         emit TransferSingle(msg.sender, address(0), to_, 1, 1);
572         
573         // we dont need to make this callback as we're just emitting an event
574         // _ERC1155Supported(address(0), to_, 1, 1, ""); 
575     }
576 
577     // ERC165 Logic
578     function supportsInterface(bytes4 interfaceId_) public pure virtual returns (bool) {
579         return 
580         interfaceId_ == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
581         interfaceId_ == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
582         interfaceId_ == 0x0e89341c;   // ERC165 Interface ID for ERC1155MetadataURI
583     }
584 
585     // Proxy Padding
586     bytes32[50] private proxyPadding;
587 }
588 
589 ///////////////////////////////////////////////////////
590 /////             MerkleAllowlistAmount           /////
591 ///////////////////////////////////////////////////////
592 
593 abstract contract MerkleAllowlistAmount {
594     bytes32 internal _merkleRoot;
595     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
596         _merkleRoot = merkleRoot_;
597     }
598     function isAllowlisted(address address_, bytes32[] memory proof_,
599     uint256 amount_) public view returns (bool) {
600         bytes32 _leaf = keccak256(abi.encodePacked(address_, amount_));
601         for (uint256 i = 0; i < proof_.length; i++) {
602             _leaf = _leaf < proof_[i] ? 
603             keccak256(abi.encodePacked(_leaf, proof_[i])) : 
604             keccak256(abi.encodePacked(proof_[i], _leaf));
605         }
606         return _leaf == _merkleRoot;
607     }
608 }
609 
610 contract GoldSaucerAuction is Ownable, PayableGovernance,
611 BucketAuction, GoldSaucerChip, MerkleAllowlistAmount {
612 
613     // Constructor to set the name, symbol, and gasEvo address
614     constructor(address gasEvo_) 
615     GoldSaucerChip("Gold Saucer Chip", "GSCHIP") 
616     BucketAuction(gasEvo_)
617     {}
618     
619     // Overrides of Functions (ERC1155 / GoldSaucerChip)
620     function balanceOf(address owner_, uint256 id_) public view override returns (uint256) {
621         // We only return a phantom balance using ID 1
622         if (id_ != 1) return 0;
623         return  userToBidData[owner_].commitment > 0 ? 1 :
624                 addressToAllowlistMinted[owner_] > 0 ? 1 : 0;
625     }
626 
627     // Overrides of Functions (BucketAuction)
628     function bid() public override payable {
629         BucketAuction.bid();
630     }
631 
632     // Allowlist 
633     event GangMint(address indexed minter, uint256 mintAmount, 
634         uint256 newTotalMintAmount, uint256 proofMintAmount);
635     
636     uint256 public totalAllowlistsMinted;
637     uint256 public allowlistMintPrice;
638     bool public allowlistMintEnabled;
639     
640     mapping(address => uint256) public addressToAllowlistMinted;
641 
642     function O_setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
643         _setMerkleRoot(merkleRoot_); }
644     function O_setAllowListMintEnabled(bool bool_) external onlyOwner {
645         allowlistMintEnabled = bool_; }
646     function O_setAllowlistMintPrice(uint256 price_) external onlyOwner {
647         allowlistMintPrice = price_; }
648 
649     function gangMint(uint256 mintAmount_, bytes32[] calldata proof_, 
650     uint256 proofMintAmount_) external payable {
651         // AllowlistMint must be enabled
652         require(allowlistMintEnabled, "Gang Mint not enabled yet!");
653         // Allowlist price must be over 0
654         require(allowlistMintPrice != 0, "Allowlist price not set!");
655         // No smart contracts
656         require(msg.sender == tx.origin, "No Smart Contracts!");
657         // Merkleproof Checking
658         require(isAllowlisted(msg.sender, proof_, proofMintAmount_),
659             "You are not allowlisted for this amount!");
660         
661         // Eligible Amount Checking
662         uint256 _alreadyMinted = addressToAllowlistMinted[msg.sender];
663         uint256 _requestedMint = mintAmount_;
664         uint256 _newTotalMint = _alreadyMinted + _requestedMint;
665         require(proofMintAmount_ >= _newTotalMint, "Not enough mints remaining!");
666 
667         // Pricing Calculation and Checking
668         uint256 _bidRemainders = getRefundAmount(msg.sender);
669         uint256 _totalMintCost = allowlistMintPrice * _requestedMint;
670 
671         if (_bidRemainders > _totalMintCost) {
672             userToBidData[msg.sender].commitment -= uint232(_totalMintCost);
673         }
674 
675         else {
676             require(_totalMintCost == (_bidRemainders + msg.value),
677                 "Invalid value sent!");
678 
679             if (_bidRemainders != 0) {
680                 userToBidData[msg.sender].refundClaimed = true;
681             }
682         }
683 
684         // Add requestedMint to addressToAllowlistMinted tracker
685         addressToAllowlistMinted[msg.sender] += _requestedMint;
686 
687         // Emit the Mint event
688         emit GangMint(msg.sender, _requestedMint, _newTotalMint, proofMintAmount_);
689     }
690 
691     // Initialize Chips
692     function initializeGoldSaucerChips(address[] calldata addresses_) 
693     external onlyOwner {
694         uint256 l = addresses_.length;
695         for (uint256 i; i < l;) {
696             _phantomMintGoldSaucerChip(addresses_[i]);
697             unchecked{++i;}
698         }    
699     }
700 
701     // Front-End Function
702     function getMintPriceForUser(address minter_, uint256 mintAmount_) public view 
703     returns (uint256) {
704         uint256 _refundAmount = getRefundAmount(minter_);
705         uint256 _totalPrice = allowlistMintPrice * mintAmount_;
706         return (_refundAmount >= _totalPrice) ? 
707         0 :
708         (_totalPrice - _refundAmount);
709     }
710 
711     // Proxy Padding
712     // bytes32[50] private proxyPadding;
713 
714 }