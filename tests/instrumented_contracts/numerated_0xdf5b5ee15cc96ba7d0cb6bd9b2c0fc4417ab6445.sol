1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.6;
3 
4 interface IERC721 {
5     function balanceOf(address owner) external view returns (uint256 balance);
6 
7     function ownerOf(uint256 tokenId) external view returns (address owner);
8 
9     function safeTransferFrom(
10         address from,
11         address to,
12         uint256 tokenId
13     ) external;
14 
15     function transferFrom(
16         address from,
17         address to,
18         uint256 tokenId
19     ) external;
20 
21     function approve(address to, uint256 tokenId) external;
22 
23     function getApproved(uint256 tokenId)
24         external
25         view
26         returns (address operator);
27 
28     function setApprovalForAll(address operator, bool _approved) external;
29 
30     function isApprovedForAll(address owner, address operator)
31         external
32         view
33         returns (bool);
34 
35     function safeTransferFrom(
36         address from,
37         address to,
38         uint256 tokenId,
39         bytes calldata data
40     ) external;
41 }
42 
43 interface IERC721Events {
44     event Transfer(
45         address indexed from,
46         address indexed to,
47         uint256 indexed tokenId
48     );
49     event Approval(
50         address indexed owner,
51         address indexed approved,
52         uint256 indexed tokenId
53     );
54     event ApprovalForAll(
55         address indexed owner,
56         address indexed operator,
57         bool approved
58     );
59 }
60 
61 interface IERC721Metadata {
62     function name() external view returns (string memory);
63 
64     function symbol() external view returns (string memory);
65 
66     function tokenURI(uint256 tokenId) external view returns (string memory);
67 }
68 
69 interface IERC721Receiver {
70     function onERC721Received(
71         address operator,
72         address from,
73         uint256 tokenId,
74         bytes calldata data
75     ) external returns (bytes4);
76 }
77 
78 interface IERC165 {
79     function supportsInterface(bytes4 interfaceId) external view returns (bool);
80 }
81 
82 abstract contract ERC165 is IERC165 {
83     function supportsInterface(bytes4 interfaceId)
84         public
85         view
86         virtual
87         override
88         returns (bool)
89     {
90         return interfaceId == type(IERC165).interfaceId;
91     }
92 }
93 
94 /**
95  * Based on: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
96  */
97 contract ERC721 is ERC165, IERC721, IERC721Events {
98     mapping(uint256 => address) private _owners;
99     mapping(address => uint256) private _balances;
100     mapping(uint256 => address) private _tokenApprovals;
101     mapping(address => mapping(address => bool)) private _operatorApprovals;
102 
103     function supportsInterface(bytes4 interfaceId)
104         public
105         view
106         virtual
107         override
108         returns (bool)
109     {
110         return
111             interfaceId == type(IERC721).interfaceId ||
112             interfaceId == type(IERC721Metadata).interfaceId ||
113             super.supportsInterface(interfaceId);
114     }
115 
116     function balanceOf(address owner)
117         public
118         view
119         virtual
120         override
121         returns (uint256)
122     {
123         require(
124             owner != address(0),
125             "ERC721: balance query for the zero address"
126         );
127         return _balances[owner];
128     }
129 
130     function ownerOf(uint256 tokenId)
131         public
132         view
133         virtual
134         override
135         returns (address)
136     {
137         address owner = _owners[tokenId];
138         require(
139             owner != address(0),
140             "ERC721: owner query for nonexistent token"
141         );
142         return owner;
143     }
144 
145     function tokenURI(uint256 tokenId)
146         public
147         view
148         virtual
149         returns (string memory)
150     {
151         require(
152             _exists(tokenId),
153             "ERC721Metadata: URI query for nonexistent token"
154         );
155 
156         string memory baseURI = _baseURI();
157         return
158             bytes(baseURI).length > 0
159                 ? string(abi.encodePacked(baseURI, tokenId))
160                 : "";
161     }
162 
163     /**
164      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
165      * in child contracts.
166      */
167     function _baseURI() internal view virtual returns (string memory) {
168         return "";
169     }
170 
171     function approve(address to, uint256 tokenId) public virtual override {
172         address owner = ERC721.ownerOf(tokenId);
173         require(to != owner, "ERC721: approval to current owner");
174 
175         require(
176             msg.sender == owner || isApprovedForAll(owner, msg.sender),
177             "ERC721: approve caller is not owner nor approved for all"
178         );
179 
180         _approve(to, tokenId);
181     }
182 
183     function getApproved(uint256 tokenId)
184         public
185         view
186         virtual
187         override
188         returns (address)
189     {
190         require(
191             _exists(tokenId),
192             "ERC721: approved query for nonexistent token"
193         );
194 
195         return _tokenApprovals[tokenId];
196     }
197 
198     function setApprovalForAll(address operator, bool approved)
199         public
200         virtual
201         override
202     {
203         require(operator != msg.sender, "ERC721: approve to caller");
204 
205         _operatorApprovals[msg.sender][operator] = approved;
206         emit ApprovalForAll(msg.sender, operator, approved);
207     }
208 
209     function isApprovedForAll(address owner, address operator)
210         public
211         view
212         virtual
213         override
214         returns (bool)
215     {
216         return _operatorApprovals[owner][operator];
217     }
218 
219     function transferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) public virtual override {
224         //solhint-disable-next-line max-line-length
225         require(
226             _isApprovedOrOwner(msg.sender, tokenId),
227             "ERC721: transfer caller is not owner nor approved"
228         );
229 
230         _transfer(from, to, tokenId);
231     }
232 
233     function safeTransferFrom(
234         address from,
235         address to,
236         uint256 tokenId
237     ) public virtual override {
238         safeTransferFrom(from, to, tokenId, "");
239     }
240 
241     function safeTransferFrom(
242         address from,
243         address to,
244         uint256 tokenId,
245         bytes memory _data
246     ) public virtual override {
247         require(
248             _isApprovedOrOwner(msg.sender, tokenId),
249             "ERC721: transfer caller is not owner nor approved"
250         );
251         _safeTransfer(from, to, tokenId, _data);
252     }
253 
254     function _safeTransfer(
255         address from,
256         address to,
257         uint256 tokenId,
258         bytes memory _data
259     ) internal virtual {
260         _transfer(from, to, tokenId);
261         require(
262             _checkOnERC721Received(from, to, tokenId, _data),
263             "ERC721: transfer to non ERC721Receiver implementer"
264         );
265     }
266 
267     function _exists(uint256 tokenId) internal view virtual returns (bool) {
268         return _owners[tokenId] != address(0);
269     }
270 
271     function _isApprovedOrOwner(address spender, uint256 tokenId)
272         internal
273         view
274         virtual
275         returns (bool)
276     {
277         require(
278             _exists(tokenId),
279             "ERC721: operator query for nonexistent token"
280         );
281         address owner = ERC721.ownerOf(tokenId);
282         return (spender == owner ||
283             getApproved(tokenId) == spender ||
284             isApprovedForAll(owner, spender));
285     }
286 
287     function _safeMint(address to, uint256 tokenId) internal virtual {
288         _safeMint(to, tokenId, "");
289     }
290 
291     function _safeMint(
292         address to,
293         uint256 tokenId,
294         bytes memory _data
295     ) internal virtual {
296         _mint(to, tokenId);
297         require(
298             _checkOnERC721Received(address(0), to, tokenId, _data),
299             "ERC721: transfer to non ERC721Receiver implementer"
300         );
301     }
302 
303     function _mint(address to, uint256 tokenId) internal virtual {
304         require(to != address(0), "ERC721: mint to the zero address");
305         require(!_exists(tokenId), "ERC721: token already minted");
306 
307         _balances[to] += 1;
308         _owners[tokenId] = to;
309 
310         emit Transfer(address(0), to, tokenId);
311     }
312 
313     function _burn(uint256 tokenId) internal virtual {
314         address owner = ERC721.ownerOf(tokenId);
315 
316         // Clear approvals
317         _approve(address(0), tokenId);
318 
319         _balances[owner] -= 1;
320         delete _owners[tokenId];
321 
322         emit Transfer(owner, address(0), tokenId);
323     }
324 
325     function _transfer(
326         address from,
327         address to,
328         uint256 tokenId
329     ) internal virtual {
330         require(
331             ERC721.ownerOf(tokenId) == from,
332             "ERC721: transfer of token that is not own"
333         );
334         require(to != address(0), "ERC721: transfer to the zero address");
335 
336         // Clear approvals from the previous owner
337         _approve(address(0), tokenId);
338 
339         _balances[from] -= 1;
340         _balances[to] += 1;
341         _owners[tokenId] = to;
342 
343         emit Transfer(from, to, tokenId);
344     }
345 
346     function _approve(address to, uint256 tokenId) internal virtual {
347         _tokenApprovals[tokenId] = to;
348         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
349     }
350 
351     function _checkOnERC721Received(
352         address from,
353         address to,
354         uint256 tokenId,
355         bytes memory _data
356     ) private returns (bool) {
357         if (isContract(to)) {
358             try
359                 IERC721Receiver(to).onERC721Received(
360                     msg.sender,
361                     from,
362                     tokenId,
363                     _data
364                 )
365             returns (bytes4 retval) {
366                 return retval == IERC721Receiver(to).onERC721Received.selector;
367             } catch (bytes memory reason) {
368                 if (reason.length == 0) {
369                     revert(
370                         "ERC721: transfer to non ERC721Receiver implementer"
371                     );
372                 } else {
373                     // solhint-disable-next-line no-inline-assembly
374                     assembly {
375                         revert(add(32, reason), mload(reason))
376                     }
377                 }
378             }
379         } else {
380             return true;
381         }
382     }
383 
384     // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/7f6a1666fac8ecff5dd467d0938069bc221ea9e0/contracts/utils/Address.sol
385     function isContract(address account) internal view returns (bool) {
386         uint256 size;
387         // solhint-disable-next-line no-inline-assembly
388         assembly {
389             size := extcodesize(account)
390         }
391         return size > 0;
392     }
393 }
394 
395 interface ITreasuryConfig {
396     function treasury() external returns (address payable);
397 
398     function distributionModel() external returns (address);
399 }
400 
401 interface IMirrorTreasury {
402     function transferFunds(address payable to, uint256 value) external;
403 
404     function transferERC20(
405         address token,
406         address to,
407         uint256 value
408     ) external;
409 
410     function contributeWithTributary(address tributary) external payable;
411 
412     function contribute(uint256 amount) external payable;
413 }
414 
415 contract Ownable {
416     address public owner;
417     address private nextOwner;
418 
419     event OwnershipTransferred(
420         address indexed previousOwner,
421         address indexed newOwner
422     );
423 
424     // modifiers
425 
426     modifier onlyOwner() {
427         require(isOwner(), "caller is not the owner.");
428         _;
429     }
430 
431     modifier onlyNextOwner() {
432         require(isNextOwner(), "current owner must set caller as next owner.");
433         _;
434     }
435 
436     /**
437      * @dev Initialize contract by setting transaction submitter as initial owner.
438      */
439     constructor(address owner_) {
440         owner = owner_;
441         emit OwnershipTransferred(address(0), owner);
442     }
443 
444     /**
445      * @dev Initiate ownership transfer by setting nextOwner.
446      */
447     function transferOwnership(address nextOwner_) external onlyOwner {
448         require(nextOwner_ != address(0), "Next owner is the zero address.");
449 
450         nextOwner = nextOwner_;
451     }
452 
453     /**
454      * @dev Cancel ownership transfer by deleting nextOwner.
455      */
456     function cancelOwnershipTransfer() external onlyOwner {
457         delete nextOwner;
458     }
459 
460     /**
461      * @dev Accepts ownership transfer by setting owner.
462      */
463     function acceptOwnership() external onlyNextOwner {
464         delete nextOwner;
465 
466         owner = msg.sender;
467 
468         emit OwnershipTransferred(owner, msg.sender);
469     }
470 
471     /**
472      * @dev Renounce ownership by setting owner to zero address.
473      */
474     function renounceOwnership() external onlyOwner {
475         owner = address(0);
476 
477         emit OwnershipTransferred(owner, address(0));
478     }
479 
480     /**
481      * @dev Returns true if the caller is the current owner.
482      */
483     function isOwner() public view returns (bool) {
484         return msg.sender == owner;
485     }
486 
487     /**
488      * @dev Returns true if the caller is the next owner.
489      */
490     function isNextOwner() public view returns (bool) {
491         return msg.sender == nextOwner;
492     }
493 }
494 
495 interface IGovernable {
496     function changeGovernor(address governor_) external;
497 
498     function isGovernor() external view returns (bool);
499 
500     function governor() external view returns (address);
501 }
502 
503 contract Governable is Ownable, IGovernable {
504     // ============ Mutable Storage ============
505 
506     // Mirror governance contract.
507     address public override governor;
508 
509     // ============ Modifiers ============
510 
511     modifier onlyGovernance() {
512         require(isOwner() || isGovernor(), "caller is not governance");
513         _;
514     }
515 
516     modifier onlyGovernor() {
517         require(isGovernor(), "caller is not governor");
518         _;
519     }
520 
521     // ============ Constructor ============
522 
523     constructor(address owner_) Ownable(owner_) {}
524 
525     // ============ Administration ============
526 
527     function changeGovernor(address governor_) public override onlyGovernance {
528         governor = governor_;
529     }
530 
531     // ============ Utility Functions ============
532 
533     function isGovernor() public view override returns (bool) {
534         return msg.sender == governor;
535     }
536 }
537 
538 /**
539  * @title SingletonEditions
540  * @author MirrorXYZ
541  */
542 contract SingletonEditions is ERC721, Governable {
543     // ============ Constants ============
544 
545     string public constant name = "Mirror Editions V3";
546     string public constant symbol = "EDITIONS_V3";
547 
548     uint256 internal constant REENTRANCY_NOT_ENTERED = 1;
549     uint256 internal constant REENTRANCY_ENTERED = 2;
550 
551     // ============ Immutable Storage ============
552 
553     address public immutable treasuryConfig;
554     uint256 public immutable feePercent = 250;
555 
556     // ============ Structs ============
557 
558     struct Edition {
559         // The maximum number of tokens that can be sold.
560         uint256 quantity;
561         // The price at which each token will be sold, in ETH.
562         uint256 price;
563         // The account that will receive sales revenue.
564         address payable fundingRecipient;
565         // The number of tokens sold so far.
566         uint256 numSold;
567         // The content hash of the image being presented.
568         bytes32 contentHash;
569     }
570 
571     // A subset of Edition, for efficient production of multiple editions.
572     struct EditionTier {
573         // The maximum number of tokens that can be sold.
574         uint256 quantity;
575         // The price at which each token will be sold, in ETH.
576         uint256 price;
577         bytes32 contentHash;
578     }
579 
580     mapping(address => uint256) public fundingBalance;
581 
582     // ============ Mutable Storage ============
583 
584     string internal baseURI;
585     // Mapping of edition id to descriptive data.
586     mapping(uint256 => Edition) public editions;
587     // Mapping of token id to edition id.
588     mapping(uint256 => uint256) public tokenToEdition;
589     // The amount of funds that have already been withdrawn for a given edition.
590     mapping(uint256 => uint256) public withdrawnForEdition;
591     // `nextTokenId` increments with each token purchased, globally across all editions.
592     uint256 private nextTokenId;
593     // Editions start at 1, in order that unsold tokens don't map to the first edition.
594     uint256 private nextEditionId = 1;
595     // Reentrancy
596     uint256 internal reentrancyStatus;
597 
598     // ============ Events ============
599 
600     event EditionCreated(
601         uint256 quantity,
602         uint256 price,
603         address fundingRecipient,
604         uint256 indexed editionId,
605         bytes32 contentHash
606     );
607 
608     event EditionPurchased(
609         uint256 indexed editionId,
610         uint256 indexed tokenId,
611         // `numSold` at time of purchase represents the "serial number" of the NFT.
612         uint256 numSold,
613         uint256 amountPaid,
614         // The account that paid for and received the NFT.
615         address indexed buyer
616     );
617 
618     event FundsWithdrawn(
619         address fundingRecipient,
620         uint256 amountWithdrawn,
621         uint256 feeAmount
622     );
623 
624     // ============ Modifiers ============
625 
626     modifier nonReentrant() {
627         // On the first call to nonReentrant, _notEntered will be true
628         require(reentrancyStatus != REENTRANCY_ENTERED, "Reentrant call");
629         // Any calls to nonReentrant after this point will fail
630         reentrancyStatus = REENTRANCY_ENTERED;
631         _;
632         // By storing the original value once again, a refund is triggered (see
633         // https://eips.ethereum.org/EIPS/eip-2200)
634         reentrancyStatus = REENTRANCY_NOT_ENTERED;
635     }
636 
637     // ============ Constructor ============
638 
639     constructor(
640         string memory baseURI_,
641         address owner_,
642         address treasuryConfig_
643     ) Governable(owner_) {
644         baseURI = baseURI_;
645         owner = owner_;
646         treasuryConfig = treasuryConfig_;
647     }
648 
649     // ============ Edition Methods ============
650 
651     function createEditionTiers(
652         EditionTier[] memory tiers,
653         address payable fundingRecipient
654     ) external nonReentrant {
655         // Execute a loop that creates editions.
656         for (uint8 i = 0; i < tiers.length; i++) {
657             uint256 quantity = tiers[i].quantity;
658             uint256 price = tiers[i].price;
659             bytes32 contentHash_ = tiers[i].contentHash;
660 
661             editions[nextEditionId] = Edition({
662                 quantity: quantity,
663                 price: price,
664                 fundingRecipient: fundingRecipient,
665                 numSold: 0,
666                 contentHash: contentHash_
667             });
668 
669             emit EditionCreated(
670                 quantity,
671                 price,
672                 fundingRecipient,
673                 nextEditionId,
674                 contentHash_
675             );
676 
677             nextEditionId++;
678         }
679     }
680 
681     function createEdition(
682         // The number of tokens that can be minted and sold.
683         uint256 quantity,
684         // The price to purchase a token.
685         uint256 price,
686         // The account that should receive the revenue.
687         address payable fundingRecipient,
688         // Content hash is emitted in the event, for UI convenience.
689         bytes32 contentHash_
690     ) external nonReentrant {
691         editions[nextEditionId] = Edition({
692             quantity: quantity,
693             price: price,
694             fundingRecipient: fundingRecipient,
695             numSold: 0,
696             contentHash: contentHash_
697         });
698 
699         emit EditionCreated(
700             quantity,
701             price,
702             fundingRecipient,
703             nextEditionId,
704             contentHash_
705         );
706 
707         nextEditionId++;
708     }
709 
710     function buyEdition(uint256 editionId) external payable nonReentrant {
711         // Check that the edition exists. Note: this is redundant
712         // with the next check, but it is useful for clearer error messaging.
713         require(editions[editionId].quantity > 0, "Edition does not exist");
714         // Check that there are still tokens available to purchase.
715         require(
716             editions[editionId].numSold < editions[editionId].quantity,
717             "This edition is already sold out."
718         );
719         // Check that the sender is paying the correct amount.
720         require(
721             msg.value >= editions[editionId].price,
722             "Must send enough to purchase the edition."
723         );
724         // Increment the number of tokens sold for this edition.
725         editions[editionId].numSold++;
726         fundingBalance[editions[editionId].fundingRecipient] += msg.value;
727         // Mint a new token for the sender, using the `nextTokenId`.
728         _mint(msg.sender, nextTokenId);
729         // Store the mapping of token id to the edition being purchased.
730         tokenToEdition[nextTokenId] = editionId;
731 
732         emit EditionPurchased(
733             editionId,
734             nextTokenId,
735             editions[editionId].numSold,
736             msg.value,
737             msg.sender
738         );
739 
740         nextTokenId++;
741     }
742 
743     // ============ Operational Methods ============
744 
745     function withdrawFunds(address payable fundingRecipient)
746         external
747         nonReentrant
748     {
749         uint256 balance = fundingBalance[fundingRecipient];
750         fundingBalance[fundingRecipient] = 0;
751 
752         // Send the amount that was remaining for the edition, to the funding recipient.
753         uint256 fee = computeFee(balance);
754         balance -= fee;
755         // Send fee to the treasury.
756         IMirrorTreasury(ITreasuryConfig(treasuryConfig).treasury())
757             .contributeWithTributary{value: fee}(fundingRecipient);
758         // Send the remainder to the funding recipient.
759         _sendFunds(fundingRecipient, balance);
760         emit FundsWithdrawn(fundingRecipient, balance, fee);
761     }
762 
763     function computeFee(uint256 _amount) public pure returns (uint256) {
764         return (_amount * feePercent) / 10000;
765     }
766 
767     // ============ Admin Methods ============
768 
769     function changeBaseURI(string memory baseURI_) public onlyGovernance {
770         baseURI = baseURI_;
771     }
772 
773     // ============ NFT Methods ============
774 
775     // Returns e.g. https://mirror-api.com/editions/[editionId]/[tokenId]
776     function tokenURI(uint256 tokenId)
777         public
778         view
779         override
780         returns (string memory)
781     {
782         // If the token does not map to an edition, it'll be 0.
783         require(tokenToEdition[tokenId] > 0, "Token has not been sold yet");
784         // Concatenate the components, baseURI, editionId and tokenId, to create URI.
785         return
786             string(
787                 abi.encodePacked(
788                     baseURI,
789                     _toString(tokenToEdition[tokenId]),
790                     "/",
791                     _toString(tokenId)
792                 )
793             );
794     }
795 
796     // The hash of the given content for the NFT. Can be used
797     // for IPFS storage, verifying authenticity, etc.
798     function contentHash(uint256 tokenId) public view returns (bytes32) {
799         // If the token does not map to an edition, it'll be 0.
800         require(tokenToEdition[tokenId] > 0, "Token has not been sold yet");
801         // Concatenate the components, baseURI, editionId and tokenId, to create URI.
802         return editions[tokenToEdition[tokenId]].contentHash;
803     }
804 
805     // Returns e.g. https://mirror-api.com/editions/metadata
806     function contractURI() public view returns (string memory) {
807         // Concatenate the components, baseURI, editionId and tokenId, to create URI.
808         return string(abi.encodePacked(baseURI, "metadata"));
809     }
810 
811     function getRoyaltyRecipient(uint256 tokenId)
812         public
813         view
814         returns (address)
815     {
816         require(tokenToEdition[tokenId] > 0, "Token has not been minted yet");
817         return editions[tokenToEdition[tokenId]].fundingRecipient;
818     }
819 
820     function setRoyaltyRecipient(
821         uint256 editionId,
822         address payable newFundingRecipient
823     ) public {
824         require(
825             editions[editionId].fundingRecipient == msg.sender,
826             "Only current fundingRecipient can modify its value"
827         );
828 
829         editions[editionId].fundingRecipient = newFundingRecipient;
830     }
831 
832     // ============ Private Methods ============
833 
834     function _sendFunds(address payable recipient, uint256 amount) private {
835         require(
836             address(this).balance >= amount,
837             "Insufficient balance for send"
838         );
839 
840         (bool success, ) = recipient.call{value: amount}("");
841         require(success, "Unable to send value: recipient may have reverted");
842     }
843 
844     // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
845     function _toString(uint256 value) internal pure returns (string memory) {
846         // Inspired by OraclizeAPI's implementation - MIT licence
847         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
848 
849         if (value == 0) {
850             return "0";
851         }
852         uint256 temp = value;
853         uint256 digits;
854         while (temp != 0) {
855             digits++;
856             temp /= 10;
857         }
858         bytes memory buffer = new bytes(digits);
859         while (value != 0) {
860             digits -= 1;
861             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
862             value /= 10;
863         }
864         return string(buffer);
865     }
866 }