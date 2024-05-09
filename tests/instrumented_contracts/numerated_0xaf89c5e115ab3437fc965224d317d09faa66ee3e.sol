1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.5;
3 
4 interface IERC721 {
5     event Transfer(
6         address indexed from,
7         address indexed to,
8         uint256 indexed tokenId
9     );
10     event Approval(
11         address indexed owner,
12         address indexed approved,
13         uint256 indexed tokenId
14     );
15     event ApprovalForAll(
16         address indexed owner,
17         address indexed operator,
18         bool approved
19     );
20 
21     function balanceOf(address owner) external view returns (uint256 balance);
22 
23     function ownerOf(uint256 tokenId) external view returns (address owner);
24 
25     function safeTransferFrom(
26         address from,
27         address to,
28         uint256 tokenId
29     ) external;
30 
31     function transferFrom(
32         address from,
33         address to,
34         uint256 tokenId
35     ) external;
36 
37     function approve(address to, uint256 tokenId) external;
38 
39     function getApproved(uint256 tokenId)
40         external
41         view
42         returns (address operator);
43 
44     function setApprovalForAll(address operator, bool _approved) external;
45 
46     function isApprovedForAll(address owner, address operator)
47         external
48         view
49         returns (bool);
50 
51     function safeTransferFrom(
52         address from,
53         address to,
54         uint256 tokenId,
55         bytes calldata data
56     ) external;
57 }
58 
59 interface IERC721Metadata {
60     function name() external view returns (string memory);
61 
62     function symbol() external view returns (string memory);
63 
64     function tokenURI(uint256 tokenId) external view returns (string memory);
65 }
66 
67 interface IERC721Receiver {
68     function onERC721Received(
69         address operator,
70         address from,
71         uint256 tokenId,
72         bytes calldata data
73     ) external returns (bytes4);
74 }
75 
76 interface IERC165 {
77     function supportsInterface(bytes4 interfaceId) external view returns (bool);
78 }
79 
80 abstract contract ERC165 is IERC165 {
81     function supportsInterface(bytes4 interfaceId)
82         public
83         view
84         virtual
85         override
86         returns (bool)
87     {
88         return interfaceId == type(IERC165).interfaceId;
89     }
90 }
91 
92 /**
93  * Based on: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
94  */
95 contract ERC721 is ERC165, IERC721 {
96     mapping(uint256 => address) private _owners;
97     mapping(address => uint256) private _balances;
98     mapping(uint256 => address) private _tokenApprovals;
99     mapping(address => mapping(address => bool)) private _operatorApprovals;
100 
101     function supportsInterface(bytes4 interfaceId)
102         public
103         view
104         virtual
105         override
106         returns (bool)
107     {
108         return
109             interfaceId == type(IERC721).interfaceId ||
110             interfaceId == type(IERC721Metadata).interfaceId ||
111             super.supportsInterface(interfaceId);
112     }
113 
114     function balanceOf(address owner)
115         public
116         view
117         virtual
118         override
119         returns (uint256)
120     {
121         require(
122             owner != address(0),
123             "ERC721: balance query for the zero address"
124         );
125         return _balances[owner];
126     }
127 
128     function ownerOf(uint256 tokenId)
129         public
130         view
131         virtual
132         override
133         returns (address)
134     {
135         address owner = _owners[tokenId];
136         require(
137             owner != address(0),
138             "ERC721: owner query for nonexistent token"
139         );
140         return owner;
141     }
142 
143     function tokenURI(uint256 tokenId)
144         public
145         view
146         virtual
147         returns (string memory)
148     {
149         require(
150             _exists(tokenId),
151             "ERC721Metadata: URI query for nonexistent token"
152         );
153 
154         string memory baseURI = _baseURI();
155         return
156             bytes(baseURI).length > 0
157                 ? string(abi.encodePacked(baseURI, tokenId))
158                 : "";
159     }
160 
161     /**
162      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
163      * in child contracts.
164      */
165     function _baseURI() internal view virtual returns (string memory) {
166         return "";
167     }
168 
169     function approve(address to, uint256 tokenId) public virtual override {
170         address owner = ERC721.ownerOf(tokenId);
171         require(to != owner, "ERC721: approval to current owner");
172 
173         require(
174             msg.sender == owner || isApprovedForAll(owner, msg.sender),
175             "ERC721: approve caller is not owner nor approved for all"
176         );
177 
178         _approve(to, tokenId);
179     }
180 
181     function getApproved(uint256 tokenId)
182         public
183         view
184         virtual
185         override
186         returns (address)
187     {
188         require(
189             _exists(tokenId),
190             "ERC721: approved query for nonexistent token"
191         );
192 
193         return _tokenApprovals[tokenId];
194     }
195 
196     function setApprovalForAll(address operator, bool approved)
197         public
198         virtual
199         override
200     {
201         require(operator != msg.sender, "ERC721: approve to caller");
202 
203         _operatorApprovals[msg.sender][operator] = approved;
204         emit ApprovalForAll(msg.sender, operator, approved);
205     }
206 
207     function isApprovedForAll(address owner, address operator)
208         public
209         view
210         virtual
211         override
212         returns (bool)
213     {
214         return _operatorApprovals[owner][operator];
215     }
216 
217     function transferFrom(
218         address from,
219         address to,
220         uint256 tokenId
221     ) public virtual override {
222         //solhint-disable-next-line max-line-length
223         require(
224             _isApprovedOrOwner(msg.sender, tokenId),
225             "ERC721: transfer caller is not owner nor approved"
226         );
227 
228         _transfer(from, to, tokenId);
229     }
230 
231     function safeTransferFrom(
232         address from,
233         address to,
234         uint256 tokenId
235     ) public virtual override {
236         safeTransferFrom(from, to, tokenId, "");
237     }
238 
239     function safeTransferFrom(
240         address from,
241         address to,
242         uint256 tokenId,
243         bytes memory _data
244     ) public virtual override {
245         require(
246             _isApprovedOrOwner(msg.sender, tokenId),
247             "ERC721: transfer caller is not owner nor approved"
248         );
249         _safeTransfer(from, to, tokenId, _data);
250     }
251 
252     function _safeTransfer(
253         address from,
254         address to,
255         uint256 tokenId,
256         bytes memory _data
257     ) internal virtual {
258         _transfer(from, to, tokenId);
259         require(
260             _checkOnERC721Received(from, to, tokenId, _data),
261             "ERC721: transfer to non ERC721Receiver implementer"
262         );
263     }
264 
265     function _exists(uint256 tokenId) internal view virtual returns (bool) {
266         return _owners[tokenId] != address(0);
267     }
268 
269     function _isApprovedOrOwner(address spender, uint256 tokenId)
270         internal
271         view
272         virtual
273         returns (bool)
274     {
275         require(
276             _exists(tokenId),
277             "ERC721: operator query for nonexistent token"
278         );
279         address owner = ERC721.ownerOf(tokenId);
280         return (spender == owner ||
281             getApproved(tokenId) == spender ||
282             isApprovedForAll(owner, spender));
283     }
284 
285     function _safeMint(address to, uint256 tokenId) internal virtual {
286         _safeMint(to, tokenId, "");
287     }
288 
289     function _safeMint(
290         address to,
291         uint256 tokenId,
292         bytes memory _data
293     ) internal virtual {
294         _mint(to, tokenId);
295         require(
296             _checkOnERC721Received(address(0), to, tokenId, _data),
297             "ERC721: transfer to non ERC721Receiver implementer"
298         );
299     }
300 
301     function _mint(address to, uint256 tokenId) internal virtual {
302         require(to != address(0), "ERC721: mint to the zero address");
303         require(!_exists(tokenId), "ERC721: token already minted");
304 
305         _balances[to] += 1;
306         _owners[tokenId] = to;
307 
308         emit Transfer(address(0), to, tokenId);
309     }
310 
311     function _burn(uint256 tokenId) internal virtual {
312         address owner = ERC721.ownerOf(tokenId);
313 
314         // Clear approvals
315         _approve(address(0), tokenId);
316 
317         _balances[owner] -= 1;
318         delete _owners[tokenId];
319 
320         emit Transfer(owner, address(0), tokenId);
321     }
322 
323     function _transfer(
324         address from,
325         address to,
326         uint256 tokenId
327     ) internal virtual {
328         require(
329             ERC721.ownerOf(tokenId) == from,
330             "ERC721: transfer of token that is not own"
331         );
332         require(to != address(0), "ERC721: transfer to the zero address");
333 
334         // Clear approvals from the previous owner
335         _approve(address(0), tokenId);
336 
337         _balances[from] -= 1;
338         _balances[to] += 1;
339         _owners[tokenId] = to;
340 
341         emit Transfer(from, to, tokenId);
342     }
343 
344     function _approve(address to, uint256 tokenId) internal virtual {
345         _tokenApprovals[tokenId] = to;
346         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
347     }
348 
349     function _checkOnERC721Received(
350         address from,
351         address to,
352         uint256 tokenId,
353         bytes memory _data
354     ) private returns (bool) {
355         if (isContract(to)) {
356             try
357                 IERC721Receiver(to).onERC721Received(
358                     msg.sender,
359                     from,
360                     tokenId,
361                     _data
362                 )
363             returns (bytes4 retval) {
364                 return retval == IERC721Receiver(to).onERC721Received.selector;
365             } catch (bytes memory reason) {
366                 if (reason.length == 0) {
367                     revert(
368                         "ERC721: transfer to non ERC721Receiver implementer"
369                     );
370                 } else {
371                     // solhint-disable-next-line no-inline-assembly
372                     assembly {
373                         revert(add(32, reason), mload(reason))
374                     }
375                 }
376             }
377         } else {
378             return true;
379         }
380     }
381 
382     // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/7f6a1666fac8ecff5dd467d0938069bc221ea9e0/contracts/utils/Address.sol
383     function isContract(address account) internal view returns (bool) {
384         uint256 size;
385         // solhint-disable-next-line no-inline-assembly
386         assembly {
387             size := extcodesize(account)
388         }
389         return size > 0;
390     }
391 }
392 
393 
394 // File contracts/Editions.sol
395 
396 
397 /**
398  * @title Editions
399  * @author MirrorXYZ
400  */
401 contract Editions is ERC721 {
402     // ============ Constants ============
403 
404     string public constant name = "Mirror Editions V2";
405     string public constant symbol = "EDITIONS_V2";
406 
407     uint256 internal constant REENTRANCY_NOT_ENTERED = 1;
408     uint256 internal constant REENTRANCY_ENTERED = 2;
409 
410     // ============ Structs ============
411 
412     struct Edition {
413         // The maximum number of tokens that can be sold.
414         uint256 quantity;
415         // The price at which each token will be sold, in ETH.
416         uint256 price;
417         // The account that will receive sales revenue.
418         address payable fundingRecipient;
419         // The number of tokens sold so far.
420         uint256 numSold;
421         // The content hash of the image being presented.
422         bytes32 contentHash;
423     }
424 
425     // A subset of Edition, for efficient production of multiple editions.
426     struct EditionTier {
427         // The maximum number of tokens that can be sold.
428         uint256 quantity;
429         // The price at which each token will be sold, in ETH.
430         uint256 price;
431         bytes32 contentHash;
432     }
433 
434     mapping(address => uint256) public fundingBalance;
435 
436     // ============ Immutable Storage ============
437 
438     // Fee updates take 2 days to take place, giving creators time to withdraw.
439     uint256 public immutable feeUpdateTimelock;
440 
441     // ============ Mutable Storage ============
442 
443     string internal baseURI;
444     // Mapping of edition id to descriptive data.
445     mapping(uint256 => Edition) public editions;
446     // Mapping of token id to edition id.
447     mapping(uint256 => uint256) public tokenToEdition;
448     // The amount of funds that have already been withdrawn for a given edition.
449     mapping(uint256 => uint256) public withdrawnForEdition;
450     // `nextTokenId` increments with each token purchased, globally across all editions.
451     uint256 private nextTokenId;
452     // Editions start at 1, in order that unsold tokens don't map to the first edition.
453     uint256 private nextEditionId = 1;
454     // Withdrawals include a fee, specified as a percentage.
455     uint16 public feePercent;
456     // The address that holds fees.
457     address payable public treasury;
458     uint256 public feesAccrued;
459     // Timelock information.
460     uint256 public nextFeeUpdateTime;
461     uint16 public nextFeePercent;
462     // Reentrancy
463     uint256 internal reentrancyStatus;
464 
465     address public owner;
466     address public nextOwner;
467 
468     // ============ Events ============
469 
470     event EditionCreated(
471         uint256 quantity,
472         uint256 price,
473         address fundingRecipient,
474         uint256 indexed editionId,
475         bytes32 contentHash
476     );
477 
478     event EditionPurchased(
479         uint256 indexed editionId,
480         uint256 indexed tokenId,
481         // `numSold` at time of purchase represents the "serial number" of the NFT.
482         uint256 numSold,
483         uint256 amountPaid,
484         // The account that paid for and received the NFT.
485         address indexed buyer
486     );
487 
488     event FundsWithdrawn(
489         address fundingRecipient,
490         uint256 amountWithdrawn,
491         uint256 feeAmount
492     );
493 
494     event OwnershipTransferred(
495         address indexed previousOwner,
496         address indexed newOwner
497     );
498 
499     event FeesWithdrawn(uint256 feesAccrued, address sender);
500 
501     event FeeUpdateQueued(uint256 newFee, address sender);
502 
503     event FeeUpdated(uint256 feePercent, address sender);
504 
505     // ============ Modifiers ============
506 
507     modifier nonReentrant() {
508         // On the first call to nonReentrant, _notEntered will be true
509         require(reentrancyStatus != REENTRANCY_ENTERED, "Reentrant call");
510 
511         // Any calls to nonReentrant after this point will fail
512         reentrancyStatus = REENTRANCY_ENTERED;
513 
514         _;
515 
516         // By storing the original value once again, a refund is triggered (see
517         // https://eips.ethereum.org/EIPS/eip-2200)
518         reentrancyStatus = REENTRANCY_NOT_ENTERED;
519     }
520 
521     modifier onlyOwner() {
522         require(isOwner(), "caller is not the owner.");
523         _;
524     }
525 
526     modifier onlyNextOwner() {
527         require(isNextOwner(), "current owner must set caller as next owner.");
528         _;
529     }
530 
531     // ============ Constructor ============
532 
533     constructor(
534         string memory baseURI_,
535         address payable treasury_,
536         uint16 initialFee,
537         uint256 feeUpdateTimelock_,
538         address owner_
539     ) {
540         baseURI = baseURI_;
541         treasury = treasury_;
542         feePercent = initialFee;
543         feeUpdateTimelock = feeUpdateTimelock_;
544         owner = owner_;
545     }
546 
547     // ============ Edition Methods ============
548 
549     function createEditionTiers(
550         EditionTier[] memory tiers,
551         address payable fundingRecipient
552     ) external nonReentrant {
553         // Execute a loop that creates editions.
554         for (uint8 i = 0; i < tiers.length; i++) {
555             uint256 quantity = tiers[i].quantity;
556             uint256 price = tiers[i].price;
557             bytes32 contentHash = tiers[i].contentHash;
558 
559             editions[nextEditionId] = Edition({
560                 quantity: quantity,
561                 price: price,
562                 fundingRecipient: fundingRecipient,
563                 numSold: 0,
564                 contentHash: contentHash
565             });
566 
567             emit EditionCreated(
568                 quantity,
569                 price,
570                 fundingRecipient,
571                 nextEditionId,
572                 contentHash
573             );
574 
575             nextEditionId++;
576         }
577     }
578 
579     function createEdition(
580         // The number of tokens that can be minted and sold.
581         uint256 quantity,
582         // The price to purchase a token.
583         uint256 price,
584         // The account that should receive the revenue.
585         address payable fundingRecipient,
586         // Content hash is emitted in the event, for UI convenience.
587         bytes32 contentHash
588     ) external nonReentrant {
589         editions[nextEditionId] = Edition({
590             quantity: quantity,
591             price: price,
592             fundingRecipient: fundingRecipient,
593             numSold: 0,
594             contentHash: contentHash
595         });
596 
597         emit EditionCreated(
598             quantity,
599             price,
600             fundingRecipient,
601             nextEditionId,
602             contentHash
603         );
604 
605         nextEditionId++;
606     }
607 
608     function buyEdition(uint256 editionId) external payable nonReentrant {
609         // Check that the edition exists. Note: this is redundant
610         // with the next check, but it is useful for clearer error messaging.
611         require(editions[editionId].quantity > 0, "Edition does not exist");
612         // Check that there are still tokens available to purchase.
613         require(
614             editions[editionId].numSold < editions[editionId].quantity,
615             "This edition is already sold out."
616         );
617         // Check that the sender is paying the correct amount.
618         require(
619             msg.value >= editions[editionId].price,
620             "Must send enough to purchase the edition."
621         );
622         // Increment the number of tokens sold for this edition.
623         editions[editionId].numSold++;
624         fundingBalance[editions[editionId].fundingRecipient] += msg.value;
625         // Mint a new token for the sender, using the `nextTokenId`.
626         _mint(msg.sender, nextTokenId);
627         // Store the mapping of token id to the edition being purchased.
628         tokenToEdition[nextTokenId] = editionId;
629 
630         emit EditionPurchased(
631             editionId,
632             nextTokenId,
633             editions[editionId].numSold,
634             msg.value,
635             msg.sender
636         );
637 
638         nextTokenId++;
639     }
640 
641     // ============ Operational Methods ============
642 
643     function withdrawFunds(address payable fundingRecipient)
644         external
645         nonReentrant
646     {
647         uint256 remaining = fundingBalance[fundingRecipient];
648         fundingBalance[fundingRecipient] = 0;
649 
650         if (feePercent > 0) {
651             // Send the amount that was remaining for the edition, to the funding recipient.
652             uint256 fee = computeFee(remaining);
653             // Allocate fee to the treasury.
654             feesAccrued += fee;
655             // Send the remainder to the funding recipient.
656             _sendFunds(fundingRecipient, remaining - fee);
657             emit FundsWithdrawn(fundingRecipient, remaining - fee, fee);
658         } else {
659             _sendFunds(fundingRecipient, remaining);
660             emit FundsWithdrawn(fundingRecipient, remaining, 0);
661         }
662     }
663 
664     function computeFee(uint256 _amount) public view returns (uint256) {
665         return (_amount * feePercent) / 100;
666     }
667 
668     // ============ Admin Methods ============
669 
670     function withdrawFees() public {
671         _sendFunds(treasury, feesAccrued);
672         emit FeesWithdrawn(feesAccrued, msg.sender);
673         feesAccrued = 0;
674     }
675 
676     function updateTreasury(address payable newTreasury) public {
677         require(msg.sender == treasury, "Only available to current treasury");
678         treasury = newTreasury;
679     }
680 
681     function queueFeeUpdate(uint16 newFee) public {
682         require(msg.sender == treasury, "Only available to treasury");
683         nextFeeUpdateTime = block.timestamp + feeUpdateTimelock;
684         nextFeePercent = newFee;
685         emit FeeUpdateQueued(newFee, msg.sender);
686     }
687 
688     function executeFeeUpdate() public {
689         require(msg.sender == treasury, "Only available to current treasury");
690         require(
691             block.timestamp >= nextFeeUpdateTime,
692             "Timelock hasn't elapsed"
693         );
694         feePercent = nextFeePercent;
695         nextFeePercent = 0;
696         nextFeeUpdateTime = 0;
697         emit FeeUpdated(feePercent, msg.sender);
698     }
699 
700     function changeBaseURI(string memory baseURI_) public onlyOwner {
701         baseURI = baseURI_;
702     }
703 
704     function isOwner() public view returns (bool) {
705         return msg.sender == owner;
706     }
707 
708     function isNextOwner() public view returns (bool) {
709         return msg.sender == nextOwner;
710     }
711 
712     function transferOwnership(address nextOwner_) external onlyOwner {
713         require(nextOwner_ != address(0), "Next owner is the zero address.");
714 
715         nextOwner = nextOwner_;
716     }
717 
718     function cancelOwnershipTransfer() external onlyOwner {
719         delete nextOwner;
720     }
721 
722     function acceptOwnership() external onlyNextOwner {
723         delete nextOwner;
724 
725         emit OwnershipTransferred(owner, msg.sender);
726 
727         owner = msg.sender;
728     }
729 
730     function renounceOwnership() external onlyOwner {
731         emit OwnershipTransferred(owner, address(0));
732         owner = address(0);
733     }
734 
735     // ============ NFT Methods ============
736 
737     // Returns e.g. https://mirror-api.com/editions/[editionId]/[tokenId]
738     function tokenURI(uint256 tokenId)
739         public
740         view
741         override
742         returns (string memory)
743     {
744         // If the token does not map to an edition, it'll be 0.
745         require(tokenToEdition[tokenId] > 0, "Token has not been sold yet");
746         // Concatenate the components, baseURI, editionId and tokenId, to create URI.
747         return
748             string(
749                 abi.encodePacked(
750                     baseURI,
751                     _toString(tokenToEdition[tokenId]),
752                     "/",
753                     _toString(tokenId)
754                 )
755             );
756     }
757 
758     // The hash of the given content for the NFT. Can be used
759     // for IPFS storage, verifying authenticity, etc.
760     function contentHash(uint256 tokenId) public view returns (bytes32) {
761         // If the token does not map to an edition, it'll be 0.
762         require(tokenToEdition[tokenId] > 0, "Token has not been sold yet");
763         // Concatenate the components, baseURI, editionId and tokenId, to create URI.
764         return editions[tokenToEdition[tokenId]].contentHash;
765     }
766 
767     // Returns e.g. https://mirror-api.com/editions/metadata
768     function contractURI() public view returns (string memory) {
769         // Concatenate the components, baseURI, editionId and tokenId, to create URI.
770         return string(abi.encodePacked(baseURI, "metadata"));
771     }
772 
773     function getRoyaltyRecipient(uint256 tokenId)
774         public
775         view
776         returns (address)
777     {
778         require(tokenToEdition[tokenId] > 0, "Token has not been minted yet");
779         return editions[tokenToEdition[tokenId]].fundingRecipient;
780     }
781 
782     function setRoyaltyRecipient(
783         uint256 editionId,
784         address payable newFundingRecipient
785     ) public {
786         require(
787             editions[editionId].fundingRecipient == msg.sender,
788             "Only current fundingRecipient can modify its value"
789         );
790 
791         editions[editionId].fundingRecipient = newFundingRecipient;
792     }
793 
794     // ============ Private Methods ============
795 
796     function _sendFunds(address payable recipient, uint256 amount) private {
797         require(
798             address(this).balance >= amount,
799             "Insufficient balance for send"
800         );
801 
802         (bool success, ) = recipient.call{value: amount}("");
803         require(success, "Unable to send value: recipient may have reverted");
804     }
805 
806     // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
807     function _toString(uint256 value) internal pure returns (string memory) {
808         // Inspired by OraclizeAPI's implementation - MIT licence
809         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
810 
811         if (value == 0) {
812             return "0";
813         }
814         uint256 temp = value;
815         uint256 digits;
816         while (temp != 0) {
817             digits++;
818             temp /= 10;
819         }
820         bytes memory buffer = new bytes(digits);
821         while (value != 0) {
822             digits -= 1;
823             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
824             value /= 10;
825         }
826         return string(buffer);
827     }
828 }