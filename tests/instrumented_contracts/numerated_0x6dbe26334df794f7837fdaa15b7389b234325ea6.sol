1 // File: eip712/ContextMixin.sol
2 
3 
4 pragma solidity ^0.8.7;
5 /**
6  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/ContextMixin.sol
7  */
8 abstract contract ContextMixin {
9     function msgSender()
10         internal
11         view
12         returns (address payable sender)
13     {
14         if (msg.sender == address(this)) {
15             bytes memory array = msg.data;
16             uint256 index = msg.data.length;
17             assembly {
18                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
19                 sender := and(
20                     mload(add(array, index)),
21                     0xffffffffffffffffffffffffffffffffffffffff
22                 )
23             }
24         } else {
25             sender = payable(msg.sender);
26         }
27         return sender;
28     }
29 }
30 // File: eip712/Initializable.sol
31 
32 
33 pragma solidity ^0.8.7;
34 /**
35  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/Initializable.sol
36  */
37 contract Initializable {
38     bool inited = false;
39 
40     modifier initializer() {
41         require(!inited, "already inited");
42         _;
43         inited = true;
44     }
45 }
46 // File: eip712/EIP712Base.sol
47 
48 
49 pragma solidity ^0.8.7;
50 
51 
52 /**
53  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/EIP712Base.sol
54  */
55 contract EIP712Base is Initializable {
56     struct EIP712Domain {
57         string name;
58         string version;
59         address verifyingContract;
60         bytes32 salt;
61     }
62 
63     string public constant ERC712_VERSION = "1";
64 
65     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
66         keccak256(
67             bytes(
68                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
69             )
70         );
71     bytes32 internal domainSeperator;
72 
73     // supposed to be called once while initializing.
74     // one of the contractsa that inherits this contract follows proxy pattern
75     // so it is not possible to do this in a constructor
76     function _initializeEIP712(string memory name) internal initializer {
77         _setDomainSeperator(name);
78     }
79 
80     function _setDomainSeperator(string memory name) internal {
81         domainSeperator = keccak256(
82             abi.encode(
83                 EIP712_DOMAIN_TYPEHASH,
84                 keccak256(bytes(name)),
85                 keccak256(bytes(ERC712_VERSION)),
86                 address(this),
87                 bytes32(getChainId())
88             )
89         );
90     }
91 
92     function getDomainSeperator() public view returns (bytes32) {
93         return domainSeperator;
94     }
95 
96     function getChainId() public view returns (uint256) {
97         uint256 id;
98         assembly {
99             id := chainid()
100         }
101         return id;
102     }
103 
104     /**
105      * Accept message hash and returns hash message in EIP712 compatible form
106      * So that it can be used to recover signer from signature signed using EIP712 formatted data
107      * https://eips.ethereum.org/EIPS/eip-712
108      * "\\x19" makes the encoding deterministic
109      * "\\x01" is the version byte to make it compatible to EIP-191
110      */
111     function toTypedMessageHash(bytes32 messageHash)
112         internal
113         view
114         returns (bytes32)
115     {
116         return
117             keccak256(
118                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
119             );
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
124 
125 
126 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 // CAUTION
131 // This version of SafeMath should only be used with Solidity 0.8 or later,
132 // because it relies on the compiler's built in overflow checks.
133 
134 /**
135  * @dev Wrappers over Solidity's arithmetic operations.
136  *
137  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
138  * now has built in overflow checking.
139  */
140 library SafeMath {
141     /**
142      * @dev Returns the addition of two unsigned integers, with an overflow flag.
143      *
144      * _Available since v3.4._
145      */
146     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         unchecked {
148             uint256 c = a + b;
149             if (c < a) return (false, 0);
150             return (true, c);
151         }
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
156      *
157      * _Available since v3.4._
158      */
159     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         unchecked {
161             if (b > a) return (false, 0);
162             return (true, a - b);
163         }
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         unchecked {
173             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174             // benefit is lost if 'b' is also tested.
175             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176             if (a == 0) return (true, 0);
177             uint256 c = a * b;
178             if (c / a != b) return (false, 0);
179             return (true, c);
180         }
181     }
182 
183     /**
184      * @dev Returns the division of two unsigned integers, with a division by zero flag.
185      *
186      * _Available since v3.4._
187      */
188     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
189         unchecked {
190             if (b == 0) return (false, 0);
191             return (true, a / b);
192         }
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
197      *
198      * _Available since v3.4._
199      */
200     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         unchecked {
202             if (b == 0) return (false, 0);
203             return (true, a % b);
204         }
205     }
206 
207     /**
208      * @dev Returns the addition of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `+` operator.
212      *
213      * Requirements:
214      *
215      * - Addition cannot overflow.
216      */
217     function add(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a + b;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      *
229      * - Subtraction cannot overflow.
230      */
231     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a - b;
233     }
234 
235     /**
236      * @dev Returns the multiplication of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `*` operator.
240      *
241      * Requirements:
242      *
243      * - Multiplication cannot overflow.
244      */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
246         return a * b;
247     }
248 
249     /**
250      * @dev Returns the integer division of two unsigned integers, reverting on
251      * division by zero. The result is rounded towards zero.
252      *
253      * Counterpart to Solidity's `/` operator.
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function div(uint256 a, uint256 b) internal pure returns (uint256) {
260         return a / b;
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * reverting when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
276         return a % b;
277     }
278 
279     /**
280      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
281      * overflow (when the result is negative).
282      *
283      * CAUTION: This function is deprecated because it requires allocating memory for the error
284      * message unnecessarily. For custom revert reasons use {trySub}.
285      *
286      * Counterpart to Solidity's `-` operator.
287      *
288      * Requirements:
289      *
290      * - Subtraction cannot overflow.
291      */
292     function sub(
293         uint256 a,
294         uint256 b,
295         string memory errorMessage
296     ) internal pure returns (uint256) {
297         unchecked {
298             require(b <= a, errorMessage);
299             return a - b;
300         }
301     }
302 
303     /**
304      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
305      * division by zero. The result is rounded towards zero.
306      *
307      * Counterpart to Solidity's `/` operator. Note: this function uses a
308      * `revert` opcode (which leaves remaining gas untouched) while Solidity
309      * uses an invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function div(
316         uint256 a,
317         uint256 b,
318         string memory errorMessage
319     ) internal pure returns (uint256) {
320         unchecked {
321             require(b > 0, errorMessage);
322             return a / b;
323         }
324     }
325 
326     /**
327      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
328      * reverting with custom message when dividing by zero.
329      *
330      * CAUTION: This function is deprecated because it requires allocating memory for the error
331      * message unnecessarily. For custom revert reasons use {tryMod}.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      *
339      * - The divisor cannot be zero.
340      */
341     function mod(
342         uint256 a,
343         uint256 b,
344         string memory errorMessage
345     ) internal pure returns (uint256) {
346         unchecked {
347             require(b > 0, errorMessage);
348             return a % b;
349         }
350     }
351 }
352 
353 // File: eip712/NativeMetaTransaction.sol
354 
355 
356 
357 pragma solidity ^0.8.0;
358 
359 
360 
361 contract NativeMetaTransaction is EIP712Base {
362     using SafeMath for uint256;
363     bytes32 private constant META_TRANSACTION_TYPEHASH =
364         keccak256(
365             bytes(
366                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
367             )
368         );
369     event MetaTransactionExecuted(
370         address userAddress,
371         address payable relayerAddress,
372         bytes functionSignature
373     );
374     mapping(address => uint256) nonces;
375 
376     /*
377      * Meta transaction structure.
378      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
379      * He should call the desired function directly in that case.
380      */
381     struct MetaTransaction {
382         uint256 nonce;
383         address from;
384         bytes functionSignature;
385     }
386 
387     function executeMetaTransaction(
388         address userAddress,
389         bytes memory functionSignature,
390         bytes32 sigR,
391         bytes32 sigS,
392         uint8 sigV
393     ) public payable returns (bytes memory) {
394         MetaTransaction memory metaTx = MetaTransaction({
395             nonce: nonces[userAddress],
396             from: userAddress,
397             functionSignature: functionSignature
398         });
399 
400         require(
401             verify(userAddress, metaTx, sigR, sigS, sigV),
402             "Signer and signature do not match"
403         );
404 
405         // increase nonce for user (to avoid re-use)
406         nonces[userAddress] = nonces[userAddress].add(1);
407 
408         emit MetaTransactionExecuted(
409             userAddress,
410             payable(msg.sender),
411             functionSignature
412         );
413 
414         // Append userAddress and relayer address at the end to extract it from calling context
415         (bool success, bytes memory returnData) = address(this).call(
416             abi.encodePacked(functionSignature, userAddress)
417         );
418         require(success, "Function call not successful");
419 
420         return returnData;
421     }
422 
423     function executeMetaTransactionWithExternalNonce(
424         address userAddress,
425         bytes memory functionSignature,
426         bytes32 sigR,
427         bytes32 sigS,
428         uint8 sigV,
429         uint256 userNonce
430     ) public payable returns (bytes memory) {
431         MetaTransaction memory metaTx = MetaTransaction({
432             nonce: userNonce,
433             from: userAddress,
434             functionSignature: functionSignature
435         });
436 
437         require(
438             verify(userAddress, metaTx, sigR, sigS, sigV),
439             "Signer and signature do not match"
440         );
441         require(userNonce == nonces[userAddress]);
442         // increase nonce for user (to avoid re-use)
443         nonces[userAddress] = userNonce.add(1);
444 
445         emit MetaTransactionExecuted(
446             userAddress,
447             payable(msg.sender),
448             functionSignature
449         );
450 
451         // Append userAddress and relayer address at the end to extract it from calling context
452         (bool success, bytes memory returnData) = address(this).call(
453             abi.encodePacked(functionSignature, userAddress)
454         );
455         require(success, string(returnData));
456 
457         return returnData;
458     }
459 
460     function hashMetaTransaction(MetaTransaction memory metaTx)
461         internal
462         pure
463         returns (bytes32)
464     {
465         return
466             keccak256(
467                 abi.encode(
468                     META_TRANSACTION_TYPEHASH,
469                     metaTx.nonce,
470                     metaTx.from,
471                     keccak256(metaTx.functionSignature)
472                 )
473             );
474     }
475 
476     function getNonce(address user) public view returns (uint256 nonce) {
477         nonce = nonces[user];
478     }
479 
480     function verify(
481         address signer,
482         MetaTransaction memory metaTx,
483         bytes32 sigR,
484         bytes32 sigS,
485         uint8 sigV
486     ) internal view returns (bool) {
487         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
488         return
489             signer ==
490             ecrecover(
491                 toTypedMessageHash(hashMetaTransaction(metaTx)),
492                 sigV,
493                 sigR,
494                 sigS
495             );
496     }
497 }
498 
499 // File: erc721a/contracts/IERC721A.sol
500 
501 
502 // ERC721A Contracts v4.0.0
503 // Creator: Chiru Labs
504 
505 pragma solidity ^0.8.4;
506 
507 /**
508  * @dev Interface of an ERC721A compliant contract.
509  */
510 interface IERC721A {
511     /**
512      * The caller must own the token or be an approved operator.
513      */
514     error ApprovalCallerNotOwnerNorApproved();
515 
516     /**
517      * The token does not exist.
518      */
519     error ApprovalQueryForNonexistentToken();
520 
521     /**
522      * The caller cannot approve to their own address.
523      */
524     error ApproveToCaller();
525 
526     /**
527      * The caller cannot approve to the current owner.
528      */
529     error ApprovalToCurrentOwner();
530 
531     /**
532      * Cannot query the balance for the zero address.
533      */
534     error BalanceQueryForZeroAddress();
535 
536     /**
537      * Cannot mint to the zero address.
538      */
539     error MintToZeroAddress();
540 
541     /**
542      * The quantity of tokens minted must be more than zero.
543      */
544     error MintZeroQuantity();
545 
546     /**
547      * The token does not exist.
548      */
549     error OwnerQueryForNonexistentToken();
550 
551     /**
552      * The caller must own the token or be an approved operator.
553      */
554     error TransferCallerNotOwnerNorApproved();
555 
556     /**
557      * The token must be owned by `from`.
558      */
559     error TransferFromIncorrectOwner();
560 
561     /**
562      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
563      */
564     error TransferToNonERC721ReceiverImplementer();
565 
566     /**
567      * Cannot transfer to the zero address.
568      */
569     error TransferToZeroAddress();
570 
571     /**
572      * The token does not exist.
573      */
574     error URIQueryForNonexistentToken();
575 
576     struct TokenOwnership {
577         // The address of the owner.
578         address addr;
579         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
580         uint64 startTimestamp;
581         // Whether the token has been burned.
582         bool burned;
583     }
584 
585     /**
586      * @dev Returns the total amount of tokens stored by the contract.
587      *
588      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
589      */
590     function totalSupply() external view returns (uint256);
591 
592     // ==============================
593     //            IERC165
594     // ==============================
595 
596     /**
597      * @dev Returns true if this contract implements the interface defined by
598      * `interfaceId`. See the corresponding
599      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
600      * to learn more about how these ids are created.
601      *
602      * This function call must use less than 30 000 gas.
603      */
604     function supportsInterface(bytes4 interfaceId) external view returns (bool);
605 
606     // ==============================
607     //            IERC721
608     // ==============================
609 
610     /**
611      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
612      */
613     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
614 
615     /**
616      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
617      */
618     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
619 
620     /**
621      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
622      */
623     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
624 
625     /**
626      * @dev Returns the number of tokens in ``owner``'s account.
627      */
628     function balanceOf(address owner) external view returns (uint256 balance);
629 
630     /**
631      * @dev Returns the owner of the `tokenId` token.
632      *
633      * Requirements:
634      *
635      * - `tokenId` must exist.
636      */
637     function ownerOf(uint256 tokenId) external view returns (address owner);
638 
639     /**
640      * @dev Safely transfers `tokenId` token from `from` to `to`.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must exist and be owned by `from`.
647      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
648      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
649      *
650      * Emits a {Transfer} event.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 tokenId,
656         bytes calldata data
657     ) external;
658 
659     /**
660      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
661      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must exist and be owned by `from`.
668      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
669      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
670      *
671      * Emits a {Transfer} event.
672      */
673     function safeTransferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) external;
678 
679     /**
680      * @dev Transfers `tokenId` token from `from` to `to`.
681      *
682      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must be owned by `from`.
689      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
690      *
691      * Emits a {Transfer} event.
692      */
693     function transferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) external;
698 
699     /**
700      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
701      * The approval is cleared when the token is transferred.
702      *
703      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
704      *
705      * Requirements:
706      *
707      * - The caller must own the token or be an approved operator.
708      * - `tokenId` must exist.
709      *
710      * Emits an {Approval} event.
711      */
712     function approve(address to, uint256 tokenId) external;
713 
714     /**
715      * @dev Approve or remove `operator` as an operator for the caller.
716      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
717      *
718      * Requirements:
719      *
720      * - The `operator` cannot be the caller.
721      *
722      * Emits an {ApprovalForAll} event.
723      */
724     function setApprovalForAll(address operator, bool _approved) external;
725 
726     /**
727      * @dev Returns the account approved for `tokenId` token.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function getApproved(uint256 tokenId) external view returns (address operator);
734 
735     /**
736      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
737      *
738      * See {setApprovalForAll}
739      */
740     function isApprovedForAll(address owner, address operator) external view returns (bool);
741 
742     // ==============================
743     //        IERC721Metadata
744     // ==============================
745 
746     /**
747      * @dev Returns the token collection name.
748      */
749     function name() external view returns (string memory);
750 
751     /**
752      * @dev Returns the token collection symbol.
753      */
754     function symbol() external view returns (string memory);
755 
756     /**
757      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
758      */
759     function tokenURI(uint256 tokenId) external view returns (string memory);
760 }
761 
762 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
763 
764 
765 // ERC721A Contracts v4.0.0
766 // Creator: Chiru Labs
767 
768 pragma solidity ^0.8.4;
769 
770 
771 /**
772  * @dev Interface of an ERC721AQueryable compliant contract.
773  */
774 interface IERC721AQueryable is IERC721A {
775     /**
776      * Invalid query range (`start` >= `stop`).
777      */
778     error InvalidQueryRange();
779 
780     /**
781      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
782      *
783      * If the `tokenId` is out of bounds:
784      *   - `addr` = `address(0)`
785      *   - `startTimestamp` = `0`
786      *   - `burned` = `false`
787      *
788      * If the `tokenId` is burned:
789      *   - `addr` = `<Address of owner before token was burned>`
790      *   - `startTimestamp` = `<Timestamp when token was burned>`
791      *   - `burned = `true`
792      *
793      * Otherwise:
794      *   - `addr` = `<Address of owner>`
795      *   - `startTimestamp` = `<Timestamp of start of ownership>`
796      *   - `burned = `false`
797      */
798     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
799 
800     /**
801      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
802      * See {ERC721AQueryable-explicitOwnershipOf}
803      */
804     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
805 
806     /**
807      * @dev Returns an array of token IDs owned by `owner`,
808      * in the range [`start`, `stop`)
809      * (i.e. `start <= tokenId < stop`).
810      *
811      * This function allows for tokens to be queried if the collection
812      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
813      *
814      * Requirements:
815      *
816      * - `start` < `stop`
817      */
818     function tokensOfOwnerIn(
819         address owner,
820         uint256 start,
821         uint256 stop
822     ) external view returns (uint256[] memory);
823 
824     /**
825      * @dev Returns an array of token IDs owned by `owner`.
826      *
827      * This function scans the ownership mapping and is O(totalSupply) in complexity.
828      * It is meant to be called off-chain.
829      *
830      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
831      * multiple smaller scans if the collection is large enough to cause
832      * an out-of-gas error (10K pfp collections should be fine).
833      */
834     function tokensOfOwner(address owner) external view returns (uint256[] memory);
835 }
836 
837 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
838 
839 
840 // ERC721A Contracts v4.0.0
841 // Creator: Chiru Labs
842 
843 pragma solidity ^0.8.4;
844 
845 
846 /**
847  * @dev Interface of an ERC721ABurnable compliant contract.
848  */
849 interface IERC721ABurnable is IERC721A {
850     /**
851      * @dev Burns `tokenId`. See {ERC721A-_burn}.
852      *
853      * Requirements:
854      *
855      * - The caller must own `tokenId` or be an approved operator.
856      */
857     function burn(uint256 tokenId) external;
858 }
859 
860 // File: erc721a/contracts/ERC721A.sol
861 
862 
863 // ERC721A Contracts v4.0.0
864 // Creator: Chiru Labs
865 
866 pragma solidity ^0.8.4;
867 
868 
869 /**
870  * @dev ERC721 token receiver interface.
871  */
872 interface ERC721A__IERC721Receiver {
873     function onERC721Received(
874         address operator,
875         address from,
876         uint256 tokenId,
877         bytes calldata data
878     ) external returns (bytes4);
879 }
880 
881 /**
882  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
883  * the Metadata extension. Built to optimize for lower gas during batch mints.
884  *
885  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
886  *
887  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
888  *
889  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
890  */
891 contract ERC721A is IERC721A {
892     // Mask of an entry in packed address data.
893     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
894 
895     // The bit position of `numberMinted` in packed address data.
896     uint256 private constant BITPOS_NUMBER_MINTED = 64;
897 
898     // The bit position of `numberBurned` in packed address data.
899     uint256 private constant BITPOS_NUMBER_BURNED = 128;
900 
901     // The bit position of `aux` in packed address data.
902     uint256 private constant BITPOS_AUX = 192;
903 
904     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
905     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
906 
907     // The bit position of `startTimestamp` in packed ownership.
908     uint256 private constant BITPOS_START_TIMESTAMP = 160;
909 
910     // The bit mask of the `burned` bit in packed ownership.
911     uint256 private constant BITMASK_BURNED = 1 << 224;
912     
913     // The bit position of the `nextInitialized` bit in packed ownership.
914     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
915 
916     // The bit mask of the `nextInitialized` bit in packed ownership.
917     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
918 
919     // The tokenId of the next token to be minted.
920     uint256 private _currentIndex;
921 
922     // The number of tokens burned.
923     uint256 private _burnCounter;
924 
925     // Token name
926     string private _name;
927 
928     // Token symbol
929     string private _symbol;
930 
931     // Mapping from token ID to ownership details
932     // An empty struct value does not necessarily mean the token is unowned.
933     // See `_packedOwnershipOf` implementation for details.
934     //
935     // Bits Layout:
936     // - [0..159]   `addr`
937     // - [160..223] `startTimestamp`
938     // - [224]      `burned`
939     // - [225]      `nextInitialized`
940     mapping(uint256 => uint256) private _packedOwnerships;
941 
942     // Mapping owner address to address data.
943     //
944     // Bits Layout:
945     // - [0..63]    `balance`
946     // - [64..127]  `numberMinted`
947     // - [128..191] `numberBurned`
948     // - [192..255] `aux`
949     mapping(address => uint256) private _packedAddressData;
950 
951     // Mapping from token ID to approved address.
952     mapping(uint256 => address) private _tokenApprovals;
953 
954     // Mapping from owner to operator approvals
955     mapping(address => mapping(address => bool)) private _operatorApprovals;
956 
957     constructor(string memory name_, string memory symbol_) {
958         _name = name_;
959         _symbol = symbol_;
960         _currentIndex = _startTokenId();
961     }
962 
963     /**
964      * @dev Returns the starting token ID. 
965      * To change the starting token ID, please override this function.
966      */
967     function _startTokenId() internal view virtual returns (uint256) {
968         return 0;
969     }
970 
971     /**
972      * @dev Returns the next token ID to be minted.
973      */
974     function _nextTokenId() internal view returns (uint256) {
975         return _currentIndex;
976     }
977 
978     /**
979      * @dev Returns the total number of tokens in existence.
980      * Burned tokens will reduce the count. 
981      * To get the total number of tokens minted, please see `_totalMinted`.
982      */
983     function totalSupply() public view override returns (uint256) {
984         // Counter underflow is impossible as _burnCounter cannot be incremented
985         // more than `_currentIndex - _startTokenId()` times.
986         unchecked {
987             return _currentIndex - _burnCounter - _startTokenId();
988         }
989     }
990 
991     /**
992      * @dev Returns the total amount of tokens minted in the contract.
993      */
994     function _totalMinted() internal view returns (uint256) {
995         // Counter underflow is impossible as _currentIndex does not decrement,
996         // and it is initialized to `_startTokenId()`
997         unchecked {
998             return _currentIndex - _startTokenId();
999         }
1000     }
1001 
1002     /**
1003      * @dev Returns the total number of tokens burned.
1004      */
1005     function _totalBurned() internal view returns (uint256) {
1006         return _burnCounter;
1007     }
1008 
1009     /**
1010      * @dev See {IERC165-supportsInterface}.
1011      */
1012     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1013         // The interface IDs are constants representing the first 4 bytes of the XOR of
1014         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1015         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1016         return
1017             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1018             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1019             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-balanceOf}.
1024      */
1025     function balanceOf(address owner) public view override returns (uint256) {
1026         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1027         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1028     }
1029 
1030     /**
1031      * Returns the number of tokens minted by `owner`.
1032      */
1033     function _numberMinted(address owner) internal view returns (uint256) {
1034         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1035     }
1036 
1037     /**
1038      * Returns the number of tokens burned by or on behalf of `owner`.
1039      */
1040     function _numberBurned(address owner) internal view returns (uint256) {
1041         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1042     }
1043 
1044     /**
1045      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1046      */
1047     function _getAux(address owner) internal view returns (uint64) {
1048         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1049     }
1050 
1051     /**
1052      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1053      * If there are multiple variables, please pack them into a uint64.
1054      */
1055     function _setAux(address owner, uint64 aux) internal {
1056         uint256 packed = _packedAddressData[owner];
1057         uint256 auxCasted;
1058         assembly { // Cast aux without masking.
1059             auxCasted := aux
1060         }
1061         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1062         _packedAddressData[owner] = packed;
1063     }
1064 
1065     /**
1066      * Returns the packed ownership data of `tokenId`.
1067      */
1068     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1069         uint256 curr = tokenId;
1070 
1071         unchecked {
1072             if (_startTokenId() <= curr)
1073                 if (curr < _currentIndex) {
1074                     uint256 packed = _packedOwnerships[curr];
1075                     // If not burned.
1076                     if (packed & BITMASK_BURNED == 0) {
1077                         // Invariant:
1078                         // There will always be an ownership that has an address and is not burned
1079                         // before an ownership that does not have an address and is not burned.
1080                         // Hence, curr will not underflow.
1081                         //
1082                         // We can directly compare the packed value.
1083                         // If the address is zero, packed is zero.
1084                         while (packed == 0) {
1085                             packed = _packedOwnerships[--curr];
1086                         }
1087                         return packed;
1088                     }
1089                 }
1090         }
1091         revert OwnerQueryForNonexistentToken();
1092     }
1093 
1094     /**
1095      * Returns the unpacked `TokenOwnership` struct from `packed`.
1096      */
1097     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1098         ownership.addr = address(uint160(packed));
1099         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1100         ownership.burned = packed & BITMASK_BURNED != 0;
1101     }
1102 
1103     /**
1104      * Returns the unpacked `TokenOwnership` struct at `index`.
1105      */
1106     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1107         return _unpackedOwnership(_packedOwnerships[index]);
1108     }
1109 
1110     /**
1111      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1112      */
1113     function _initializeOwnershipAt(uint256 index) internal {
1114         if (_packedOwnerships[index] == 0) {
1115             _packedOwnerships[index] = _packedOwnershipOf(index);
1116         }
1117     }
1118 
1119     /**
1120      * Gas spent here starts off proportional to the maximum mint batch size.
1121      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1122      */
1123     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1124         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-ownerOf}.
1129      */
1130     function ownerOf(uint256 tokenId) public view override returns (address) {
1131         return address(uint160(_packedOwnershipOf(tokenId)));
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Metadata-name}.
1136      */
1137     function name() public view virtual override returns (string memory) {
1138         return _name;
1139     }
1140 
1141     /**
1142      * @dev See {IERC721Metadata-symbol}.
1143      */
1144     function symbol() public view virtual override returns (string memory) {
1145         return _symbol;
1146     }
1147 
1148     /**
1149      * @dev See {IERC721Metadata-tokenURI}.
1150      */
1151     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1152         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1153 
1154         string memory baseURI = _baseURI();
1155         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1156     }
1157 
1158     /**
1159      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1160      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1161      * by default, can be overriden in child contracts.
1162      */
1163     function _baseURI() internal view virtual returns (string memory) {
1164         return '';
1165     }
1166 
1167     /**
1168      * @dev Casts the address to uint256 without masking.
1169      */
1170     function _addressToUint256(address value) private pure returns (uint256 result) {
1171         assembly {
1172             result := value
1173         }
1174     }
1175 
1176     /**
1177      * @dev Casts the boolean to uint256 without branching.
1178      */
1179     function _boolToUint256(bool value) private pure returns (uint256 result) {
1180         assembly {
1181             result := value
1182         }
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-approve}.
1187      */
1188     function approve(address to, uint256 tokenId) public override {
1189         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1190         if (to == owner) revert ApprovalToCurrentOwner();
1191 
1192         if (_msgSenderERC721A() != owner)
1193             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1194                 revert ApprovalCallerNotOwnerNorApproved();
1195             }
1196 
1197         _tokenApprovals[tokenId] = to;
1198         emit Approval(owner, to, tokenId);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-getApproved}.
1203      */
1204     function getApproved(uint256 tokenId) public view override returns (address) {
1205         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1206 
1207         return _tokenApprovals[tokenId];
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-setApprovalForAll}.
1212      */
1213     function setApprovalForAll(address operator, bool approved) public virtual override {
1214         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1215 
1216         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1217         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-isApprovedForAll}.
1222      */
1223     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1224         return _operatorApprovals[owner][operator];
1225     }
1226 
1227     /**
1228      * @dev See {IERC721-transferFrom}.
1229      */
1230     function transferFrom(
1231         address from,
1232         address to,
1233         uint256 tokenId
1234     ) public virtual override {
1235         _transfer(from, to, tokenId);
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-safeTransferFrom}.
1240      */
1241     function safeTransferFrom(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) public virtual override {
1246         safeTransferFrom(from, to, tokenId, '');
1247     }
1248 
1249     /**
1250      * @dev See {IERC721-safeTransferFrom}.
1251      */
1252     function safeTransferFrom(
1253         address from,
1254         address to,
1255         uint256 tokenId,
1256         bytes memory _data
1257     ) public virtual override {
1258         _transfer(from, to, tokenId);
1259         if (to.code.length != 0)
1260             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1261                 revert TransferToNonERC721ReceiverImplementer();
1262             }
1263     }
1264 
1265     /**
1266      * @dev Returns whether `tokenId` exists.
1267      *
1268      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1269      *
1270      * Tokens start existing when they are minted (`_mint`),
1271      */
1272     function _exists(uint256 tokenId) internal view returns (bool) {
1273         return
1274             _startTokenId() <= tokenId &&
1275             tokenId < _currentIndex && // If within bounds,
1276             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1277     }
1278 
1279     /**
1280      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1281      */
1282     function _safeMint(address to, uint256 quantity) internal {
1283         _safeMint(to, quantity, '');
1284     }
1285 
1286     /**
1287      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1288      *
1289      * Requirements:
1290      *
1291      * - If `to` refers to a smart contract, it must implement
1292      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1293      * - `quantity` must be greater than 0.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function _safeMint(
1298         address to,
1299         uint256 quantity,
1300         bytes memory _data
1301     ) internal {
1302         uint256 startTokenId = _currentIndex;
1303         if (to == address(0)) revert MintToZeroAddress();
1304         if (quantity == 0) revert MintZeroQuantity();
1305 
1306         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1307 
1308         // Overflows are incredibly unrealistic.
1309         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1310         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1311         unchecked {
1312             // Updates:
1313             // - `balance += quantity`.
1314             // - `numberMinted += quantity`.
1315             //
1316             // We can directly add to the balance and number minted.
1317             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1318 
1319             // Updates:
1320             // - `address` to the owner.
1321             // - `startTimestamp` to the timestamp of minting.
1322             // - `burned` to `false`.
1323             // - `nextInitialized` to `quantity == 1`.
1324             _packedOwnerships[startTokenId] =
1325                 _addressToUint256(to) |
1326                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1327                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1328 
1329             uint256 updatedIndex = startTokenId;
1330             uint256 end = updatedIndex + quantity;
1331 
1332             if (to.code.length != 0) {
1333                 do {
1334                     emit Transfer(address(0), to, updatedIndex);
1335                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1336                         revert TransferToNonERC721ReceiverImplementer();
1337                     }
1338                 } while (updatedIndex < end);
1339                 // Reentrancy protection
1340                 if (_currentIndex != startTokenId) revert();
1341             } else {
1342                 do {
1343                     emit Transfer(address(0), to, updatedIndex++);
1344                 } while (updatedIndex < end);
1345             }
1346             _currentIndex = updatedIndex;
1347         }
1348         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1349     }
1350 
1351     /**
1352      * @dev Mints `quantity` tokens and transfers them to `to`.
1353      *
1354      * Requirements:
1355      *
1356      * - `to` cannot be the zero address.
1357      * - `quantity` must be greater than 0.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _mint(address to, uint256 quantity) internal {
1362         uint256 startTokenId = _currentIndex;
1363         if (to == address(0)) revert MintToZeroAddress();
1364         if (quantity == 0) revert MintZeroQuantity();
1365 
1366         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1367 
1368         // Overflows are incredibly unrealistic.
1369         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1370         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1371         unchecked {
1372             // Updates:
1373             // - `balance += quantity`.
1374             // - `numberMinted += quantity`.
1375             //
1376             // We can directly add to the balance and number minted.
1377             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1378 
1379             // Updates:
1380             // - `address` to the owner.
1381             // - `startTimestamp` to the timestamp of minting.
1382             // - `burned` to `false`.
1383             // - `nextInitialized` to `quantity == 1`.
1384             _packedOwnerships[startTokenId] =
1385                 _addressToUint256(to) |
1386                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1387                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1388 
1389             uint256 updatedIndex = startTokenId;
1390             uint256 end = updatedIndex + quantity;
1391 
1392             do {
1393                 emit Transfer(address(0), to, updatedIndex++);
1394             } while (updatedIndex < end);
1395 
1396             _currentIndex = updatedIndex;
1397         }
1398         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1399     }
1400 
1401     /**
1402      * @dev Transfers `tokenId` from `from` to `to`.
1403      *
1404      * Requirements:
1405      *
1406      * - `to` cannot be the zero address.
1407      * - `tokenId` token must be owned by `from`.
1408      *
1409      * Emits a {Transfer} event.
1410      */
1411     function _transfer(
1412         address from,
1413         address to,
1414         uint256 tokenId
1415     ) private {
1416         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1417 
1418         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1419 
1420         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1421             isApprovedForAll(from, _msgSenderERC721A()) ||
1422             getApproved(tokenId) == _msgSenderERC721A());
1423 
1424         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1425         if (to == address(0)) revert TransferToZeroAddress();
1426 
1427         _beforeTokenTransfers(from, to, tokenId, 1);
1428 
1429         // Clear approvals from the previous owner.
1430         delete _tokenApprovals[tokenId];
1431 
1432         // Underflow of the sender's balance is impossible because we check for
1433         // ownership above and the recipient's balance can't realistically overflow.
1434         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1435         unchecked {
1436             // We can directly increment and decrement the balances.
1437             --_packedAddressData[from]; // Updates: `balance -= 1`.
1438             ++_packedAddressData[to]; // Updates: `balance += 1`.
1439 
1440             // Updates:
1441             // - `address` to the next owner.
1442             // - `startTimestamp` to the timestamp of transfering.
1443             // - `burned` to `false`.
1444             // - `nextInitialized` to `true`.
1445             _packedOwnerships[tokenId] =
1446                 _addressToUint256(to) |
1447                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1448                 BITMASK_NEXT_INITIALIZED;
1449 
1450             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1451             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1452                 uint256 nextTokenId = tokenId + 1;
1453                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1454                 if (_packedOwnerships[nextTokenId] == 0) {
1455                     // If the next slot is within bounds.
1456                     if (nextTokenId != _currentIndex) {
1457                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1458                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1459                     }
1460                 }
1461             }
1462         }
1463 
1464         emit Transfer(from, to, tokenId);
1465         _afterTokenTransfers(from, to, tokenId, 1);
1466     }
1467 
1468     /**
1469      * @dev Equivalent to `_burn(tokenId, false)`.
1470      */
1471     function _burn(uint256 tokenId) internal virtual {
1472         _burn(tokenId, false);
1473     }
1474 
1475     /**
1476      * @dev Destroys `tokenId`.
1477      * The approval is cleared when the token is burned.
1478      *
1479      * Requirements:
1480      *
1481      * - `tokenId` must exist.
1482      *
1483      * Emits a {Transfer} event.
1484      */
1485     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1486         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1487 
1488         address from = address(uint160(prevOwnershipPacked));
1489 
1490         if (approvalCheck) {
1491             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1492                 isApprovedForAll(from, _msgSenderERC721A()) ||
1493                 getApproved(tokenId) == _msgSenderERC721A());
1494 
1495             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1496         }
1497 
1498         _beforeTokenTransfers(from, address(0), tokenId, 1);
1499 
1500         // Clear approvals from the previous owner.
1501         delete _tokenApprovals[tokenId];
1502 
1503         // Underflow of the sender's balance is impossible because we check for
1504         // ownership above and the recipient's balance can't realistically overflow.
1505         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1506         unchecked {
1507             // Updates:
1508             // - `balance -= 1`.
1509             // - `numberBurned += 1`.
1510             //
1511             // We can directly decrement the balance, and increment the number burned.
1512             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1513             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1514 
1515             // Updates:
1516             // - `address` to the last owner.
1517             // - `startTimestamp` to the timestamp of burning.
1518             // - `burned` to `true`.
1519             // - `nextInitialized` to `true`.
1520             _packedOwnerships[tokenId] =
1521                 _addressToUint256(from) |
1522                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1523                 BITMASK_BURNED | 
1524                 BITMASK_NEXT_INITIALIZED;
1525 
1526             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1527             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1528                 uint256 nextTokenId = tokenId + 1;
1529                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1530                 if (_packedOwnerships[nextTokenId] == 0) {
1531                     // If the next slot is within bounds.
1532                     if (nextTokenId != _currentIndex) {
1533                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1534                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1535                     }
1536                 }
1537             }
1538         }
1539 
1540         emit Transfer(from, address(0), tokenId);
1541         _afterTokenTransfers(from, address(0), tokenId, 1);
1542 
1543         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1544         unchecked {
1545             _burnCounter++;
1546         }
1547     }
1548 
1549     /**
1550      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1551      *
1552      * @param from address representing the previous owner of the given token ID
1553      * @param to target address that will receive the tokens
1554      * @param tokenId uint256 ID of the token to be transferred
1555      * @param _data bytes optional data to send along with the call
1556      * @return bool whether the call correctly returned the expected magic value
1557      */
1558     function _checkContractOnERC721Received(
1559         address from,
1560         address to,
1561         uint256 tokenId,
1562         bytes memory _data
1563     ) private returns (bool) {
1564         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1565             bytes4 retval
1566         ) {
1567             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1568         } catch (bytes memory reason) {
1569             if (reason.length == 0) {
1570                 revert TransferToNonERC721ReceiverImplementer();
1571             } else {
1572                 assembly {
1573                     revert(add(32, reason), mload(reason))
1574                 }
1575             }
1576         }
1577     }
1578 
1579     /**
1580      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1581      * And also called before burning one token.
1582      *
1583      * startTokenId - the first token id to be transferred
1584      * quantity - the amount to be transferred
1585      *
1586      * Calling conditions:
1587      *
1588      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1589      * transferred to `to`.
1590      * - When `from` is zero, `tokenId` will be minted for `to`.
1591      * - When `to` is zero, `tokenId` will be burned by `from`.
1592      * - `from` and `to` are never both zero.
1593      */
1594     function _beforeTokenTransfers(
1595         address from,
1596         address to,
1597         uint256 startTokenId,
1598         uint256 quantity
1599     ) internal virtual {}
1600 
1601     /**
1602      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1603      * minting.
1604      * And also called after one token has been burned.
1605      *
1606      * startTokenId - the first token id to be transferred
1607      * quantity - the amount to be transferred
1608      *
1609      * Calling conditions:
1610      *
1611      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1612      * transferred to `to`.
1613      * - When `from` is zero, `tokenId` has been minted for `to`.
1614      * - When `to` is zero, `tokenId` has been burned by `from`.
1615      * - `from` and `to` are never both zero.
1616      */
1617     function _afterTokenTransfers(
1618         address from,
1619         address to,
1620         uint256 startTokenId,
1621         uint256 quantity
1622     ) internal virtual {}
1623 
1624     /**
1625      * @dev Returns the message sender (defaults to `msg.sender`).
1626      *
1627      * If you are writing GSN compatible contracts, you need to override this function.
1628      */
1629     function _msgSenderERC721A() internal view virtual returns (address) {
1630         return msg.sender;
1631     }
1632 
1633     /**
1634      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1635      */
1636     function _toString(uint256 value) internal pure returns (string memory ptr) {
1637         assembly {
1638             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1639             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1640             // We will need 1 32-byte word to store the length, 
1641             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1642             ptr := add(mload(0x40), 128)
1643             // Update the free memory pointer to allocate.
1644             mstore(0x40, ptr)
1645 
1646             // Cache the end of the memory to calculate the length later.
1647             let end := ptr
1648 
1649             // We write the string from the rightmost digit to the leftmost digit.
1650             // The following is essentially a do-while loop that also handles the zero case.
1651             // Costs a bit more than early returning for the zero case,
1652             // but cheaper in terms of deployment and overall runtime costs.
1653             for { 
1654                 // Initialize and perform the first pass without check.
1655                 let temp := value
1656                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1657                 ptr := sub(ptr, 1)
1658                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1659                 mstore8(ptr, add(48, mod(temp, 10)))
1660                 temp := div(temp, 10)
1661             } temp { 
1662                 // Keep dividing `temp` until zero.
1663                 temp := div(temp, 10)
1664             } { // Body of the for loop.
1665                 ptr := sub(ptr, 1)
1666                 mstore8(ptr, add(48, mod(temp, 10)))
1667             }
1668             
1669             let length := sub(end, ptr)
1670             // Move the pointer 32 bytes leftwards to make room for the length.
1671             ptr := sub(ptr, 32)
1672             // Store the length.
1673             mstore(ptr, length)
1674         }
1675     }
1676 }
1677 
1678 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1679 
1680 
1681 // ERC721A Contracts v4.0.0
1682 // Creator: Chiru Labs
1683 
1684 pragma solidity ^0.8.4;
1685 
1686 
1687 
1688 /**
1689  * @title ERC721A Queryable
1690  * @dev ERC721A subclass with convenience query functions.
1691  */
1692 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1693     /**
1694      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1695      *
1696      * If the `tokenId` is out of bounds:
1697      *   - `addr` = `address(0)`
1698      *   - `startTimestamp` = `0`
1699      *   - `burned` = `false`
1700      *
1701      * If the `tokenId` is burned:
1702      *   - `addr` = `<Address of owner before token was burned>`
1703      *   - `startTimestamp` = `<Timestamp when token was burned>`
1704      *   - `burned = `true`
1705      *
1706      * Otherwise:
1707      *   - `addr` = `<Address of owner>`
1708      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1709      *   - `burned = `false`
1710      */
1711     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1712         TokenOwnership memory ownership;
1713         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1714             return ownership;
1715         }
1716         ownership = _ownershipAt(tokenId);
1717         if (ownership.burned) {
1718             return ownership;
1719         }
1720         return _ownershipOf(tokenId);
1721     }
1722 
1723     /**
1724      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1725      * See {ERC721AQueryable-explicitOwnershipOf}
1726      */
1727     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1728         unchecked {
1729             uint256 tokenIdsLength = tokenIds.length;
1730             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1731             for (uint256 i; i != tokenIdsLength; ++i) {
1732                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1733             }
1734             return ownerships;
1735         }
1736     }
1737 
1738     /**
1739      * @dev Returns an array of token IDs owned by `owner`,
1740      * in the range [`start`, `stop`)
1741      * (i.e. `start <= tokenId < stop`).
1742      *
1743      * This function allows for tokens to be queried if the collection
1744      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1745      *
1746      * Requirements:
1747      *
1748      * - `start` < `stop`
1749      */
1750     function tokensOfOwnerIn(
1751         address owner,
1752         uint256 start,
1753         uint256 stop
1754     ) external view override returns (uint256[] memory) {
1755         unchecked {
1756             if (start >= stop) revert InvalidQueryRange();
1757             uint256 tokenIdsIdx;
1758             uint256 stopLimit = _nextTokenId();
1759             // Set `start = max(start, _startTokenId())`.
1760             if (start < _startTokenId()) {
1761                 start = _startTokenId();
1762             }
1763             // Set `stop = min(stop, stopLimit)`.
1764             if (stop > stopLimit) {
1765                 stop = stopLimit;
1766             }
1767             uint256 tokenIdsMaxLength = balanceOf(owner);
1768             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1769             // to cater for cases where `balanceOf(owner)` is too big.
1770             if (start < stop) {
1771                 uint256 rangeLength = stop - start;
1772                 if (rangeLength < tokenIdsMaxLength) {
1773                     tokenIdsMaxLength = rangeLength;
1774                 }
1775             } else {
1776                 tokenIdsMaxLength = 0;
1777             }
1778             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1779             if (tokenIdsMaxLength == 0) {
1780                 return tokenIds;
1781             }
1782             // We need to call `explicitOwnershipOf(start)`,
1783             // because the slot at `start` may not be initialized.
1784             TokenOwnership memory ownership = explicitOwnershipOf(start);
1785             address currOwnershipAddr;
1786             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1787             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1788             if (!ownership.burned) {
1789                 currOwnershipAddr = ownership.addr;
1790             }
1791             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1792                 ownership = _ownershipAt(i);
1793                 if (ownership.burned) {
1794                     continue;
1795                 }
1796                 if (ownership.addr != address(0)) {
1797                     currOwnershipAddr = ownership.addr;
1798                 }
1799                 if (currOwnershipAddr == owner) {
1800                     tokenIds[tokenIdsIdx++] = i;
1801                 }
1802             }
1803             // Downsize the array to fit.
1804             assembly {
1805                 mstore(tokenIds, tokenIdsIdx)
1806             }
1807             return tokenIds;
1808         }
1809     }
1810 
1811     /**
1812      * @dev Returns an array of token IDs owned by `owner`.
1813      *
1814      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1815      * It is meant to be called off-chain.
1816      *
1817      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1818      * multiple smaller scans if the collection is large enough to cause
1819      * an out-of-gas error (10K pfp collections should be fine).
1820      */
1821     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1822         unchecked {
1823             uint256 tokenIdsIdx;
1824             address currOwnershipAddr;
1825             uint256 tokenIdsLength = balanceOf(owner);
1826             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1827             TokenOwnership memory ownership;
1828             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1829                 ownership = _ownershipAt(i);
1830                 if (ownership.burned) {
1831                     continue;
1832                 }
1833                 if (ownership.addr != address(0)) {
1834                     currOwnershipAddr = ownership.addr;
1835                 }
1836                 if (currOwnershipAddr == owner) {
1837                     tokenIds[tokenIdsIdx++] = i;
1838                 }
1839             }
1840             return tokenIds;
1841         }
1842     }
1843 }
1844 
1845 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1846 
1847 
1848 // ERC721A Contracts v4.0.0
1849 // Creator: Chiru Labs
1850 
1851 pragma solidity ^0.8.4;
1852 
1853 
1854 
1855 /**
1856  * @title ERC721A Burnable Token
1857  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1858  */
1859 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1860     /**
1861      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1862      *
1863      * Requirements:
1864      *
1865      * - The caller must own `tokenId` or be an approved operator.
1866      */
1867     function burn(uint256 tokenId) public virtual override {
1868         _burn(tokenId, true);
1869     }
1870 }
1871 
1872 // File: @openzeppelin/contracts/utils/Address.sol
1873 
1874 
1875 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1876 
1877 pragma solidity ^0.8.1;
1878 
1879 /**
1880  * @dev Collection of functions related to the address type
1881  */
1882 library Address {
1883     /**
1884      * @dev Returns true if `account` is a contract.
1885      *
1886      * [IMPORTANT]
1887      * ====
1888      * It is unsafe to assume that an address for which this function returns
1889      * false is an externally-owned account (EOA) and not a contract.
1890      *
1891      * Among others, `isContract` will return false for the following
1892      * types of addresses:
1893      *
1894      *  - an externally-owned account
1895      *  - a contract in construction
1896      *  - an address where a contract will be created
1897      *  - an address where a contract lived, but was destroyed
1898      * ====
1899      *
1900      * [IMPORTANT]
1901      * ====
1902      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1903      *
1904      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1905      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1906      * constructor.
1907      * ====
1908      */
1909     function isContract(address account) internal view returns (bool) {
1910         // This method relies on extcodesize/address.code.length, which returns 0
1911         // for contracts in construction, since the code is only stored at the end
1912         // of the constructor execution.
1913 
1914         return account.code.length > 0;
1915     }
1916 
1917     /**
1918      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1919      * `recipient`, forwarding all available gas and reverting on errors.
1920      *
1921      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1922      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1923      * imposed by `transfer`, making them unable to receive funds via
1924      * `transfer`. {sendValue} removes this limitation.
1925      *
1926      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1927      *
1928      * IMPORTANT: because control is transferred to `recipient`, care must be
1929      * taken to not create reentrancy vulnerabilities. Consider using
1930      * {ReentrancyGuard} or the
1931      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1932      */
1933     function sendValue(address payable recipient, uint256 amount) internal {
1934         require(address(this).balance >= amount, "Address: insufficient balance");
1935 
1936         (bool success, ) = recipient.call{value: amount}("");
1937         require(success, "Address: unable to send value, recipient may have reverted");
1938     }
1939 
1940     /**
1941      * @dev Performs a Solidity function call using a low level `call`. A
1942      * plain `call` is an unsafe replacement for a function call: use this
1943      * function instead.
1944      *
1945      * If `target` reverts with a revert reason, it is bubbled up by this
1946      * function (like regular Solidity function calls).
1947      *
1948      * Returns the raw returned data. To convert to the expected return value,
1949      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1950      *
1951      * Requirements:
1952      *
1953      * - `target` must be a contract.
1954      * - calling `target` with `data` must not revert.
1955      *
1956      * _Available since v3.1._
1957      */
1958     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1959         return functionCall(target, data, "Address: low-level call failed");
1960     }
1961 
1962     /**
1963      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1964      * `errorMessage` as a fallback revert reason when `target` reverts.
1965      *
1966      * _Available since v3.1._
1967      */
1968     function functionCall(
1969         address target,
1970         bytes memory data,
1971         string memory errorMessage
1972     ) internal returns (bytes memory) {
1973         return functionCallWithValue(target, data, 0, errorMessage);
1974     }
1975 
1976     /**
1977      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1978      * but also transferring `value` wei to `target`.
1979      *
1980      * Requirements:
1981      *
1982      * - the calling contract must have an ETH balance of at least `value`.
1983      * - the called Solidity function must be `payable`.
1984      *
1985      * _Available since v3.1._
1986      */
1987     function functionCallWithValue(
1988         address target,
1989         bytes memory data,
1990         uint256 value
1991     ) internal returns (bytes memory) {
1992         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1993     }
1994 
1995     /**
1996      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1997      * with `errorMessage` as a fallback revert reason when `target` reverts.
1998      *
1999      * _Available since v3.1._
2000      */
2001     function functionCallWithValue(
2002         address target,
2003         bytes memory data,
2004         uint256 value,
2005         string memory errorMessage
2006     ) internal returns (bytes memory) {
2007         require(address(this).balance >= value, "Address: insufficient balance for call");
2008         require(isContract(target), "Address: call to non-contract");
2009 
2010         (bool success, bytes memory returndata) = target.call{value: value}(data);
2011         return verifyCallResult(success, returndata, errorMessage);
2012     }
2013 
2014     /**
2015      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2016      * but performing a static call.
2017      *
2018      * _Available since v3.3._
2019      */
2020     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2021         return functionStaticCall(target, data, "Address: low-level static call failed");
2022     }
2023 
2024     /**
2025      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2026      * but performing a static call.
2027      *
2028      * _Available since v3.3._
2029      */
2030     function functionStaticCall(
2031         address target,
2032         bytes memory data,
2033         string memory errorMessage
2034     ) internal view returns (bytes memory) {
2035         require(isContract(target), "Address: static call to non-contract");
2036 
2037         (bool success, bytes memory returndata) = target.staticcall(data);
2038         return verifyCallResult(success, returndata, errorMessage);
2039     }
2040 
2041     /**
2042      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2043      * but performing a delegate call.
2044      *
2045      * _Available since v3.4._
2046      */
2047     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2048         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2049     }
2050 
2051     /**
2052      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2053      * but performing a delegate call.
2054      *
2055      * _Available since v3.4._
2056      */
2057     function functionDelegateCall(
2058         address target,
2059         bytes memory data,
2060         string memory errorMessage
2061     ) internal returns (bytes memory) {
2062         require(isContract(target), "Address: delegate call to non-contract");
2063 
2064         (bool success, bytes memory returndata) = target.delegatecall(data);
2065         return verifyCallResult(success, returndata, errorMessage);
2066     }
2067 
2068     /**
2069      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2070      * revert reason using the provided one.
2071      *
2072      * _Available since v4.3._
2073      */
2074     function verifyCallResult(
2075         bool success,
2076         bytes memory returndata,
2077         string memory errorMessage
2078     ) internal pure returns (bytes memory) {
2079         if (success) {
2080             return returndata;
2081         } else {
2082             // Look for revert reason and bubble it up if present
2083             if (returndata.length > 0) {
2084                 // The easiest way to bubble the revert reason is using memory via assembly
2085 
2086                 assembly {
2087                     let returndata_size := mload(returndata)
2088                     revert(add(32, returndata), returndata_size)
2089                 }
2090             } else {
2091                 revert(errorMessage);
2092             }
2093         }
2094     }
2095 }
2096 
2097 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2098 
2099 
2100 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2101 
2102 pragma solidity ^0.8.0;
2103 
2104 /**
2105  * @title ERC721 token receiver interface
2106  * @dev Interface for any contract that wants to support safeTransfers
2107  * from ERC721 asset contracts.
2108  */
2109 interface IERC721Receiver {
2110     /**
2111      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2112      * by `operator` from `from`, this function is called.
2113      *
2114      * It must return its Solidity selector to confirm the token transfer.
2115      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2116      *
2117      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2118      */
2119     function onERC721Received(
2120         address operator,
2121         address from,
2122         uint256 tokenId,
2123         bytes calldata data
2124     ) external returns (bytes4);
2125 }
2126 
2127 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2128 
2129 
2130 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2131 
2132 pragma solidity ^0.8.0;
2133 
2134 /**
2135  * @dev Interface of the ERC165 standard, as defined in the
2136  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2137  *
2138  * Implementers can declare support of contract interfaces, which can then be
2139  * queried by others ({ERC165Checker}).
2140  *
2141  * For an implementation, see {ERC165}.
2142  */
2143 interface IERC165 {
2144     /**
2145      * @dev Returns true if this contract implements the interface defined by
2146      * `interfaceId`. See the corresponding
2147      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2148      * to learn more about how these ids are created.
2149      *
2150      * This function call must use less than 30 000 gas.
2151      */
2152     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2153 }
2154 
2155 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2156 
2157 
2158 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
2159 
2160 pragma solidity ^0.8.0;
2161 
2162 
2163 /**
2164  * @dev Required interface of an ERC721 compliant contract.
2165  */
2166 interface IERC721 is IERC165 {
2167     /**
2168      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2169      */
2170     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2171 
2172     /**
2173      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2174      */
2175     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2176 
2177     /**
2178      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2179      */
2180     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2181 
2182     /**
2183      * @dev Returns the number of tokens in ``owner``'s account.
2184      */
2185     function balanceOf(address owner) external view returns (uint256 balance);
2186 
2187     /**
2188      * @dev Returns the owner of the `tokenId` token.
2189      *
2190      * Requirements:
2191      *
2192      * - `tokenId` must exist.
2193      */
2194     function ownerOf(uint256 tokenId) external view returns (address owner);
2195 
2196     /**
2197      * @dev Safely transfers `tokenId` token from `from` to `to`.
2198      *
2199      * Requirements:
2200      *
2201      * - `from` cannot be the zero address.
2202      * - `to` cannot be the zero address.
2203      * - `tokenId` token must exist and be owned by `from`.
2204      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2205      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2206      *
2207      * Emits a {Transfer} event.
2208      */
2209     function safeTransferFrom(
2210         address from,
2211         address to,
2212         uint256 tokenId,
2213         bytes calldata data
2214     ) external;
2215 
2216     /**
2217      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2218      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2219      *
2220      * Requirements:
2221      *
2222      * - `from` cannot be the zero address.
2223      * - `to` cannot be the zero address.
2224      * - `tokenId` token must exist and be owned by `from`.
2225      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
2226      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2227      *
2228      * Emits a {Transfer} event.
2229      */
2230     function safeTransferFrom(
2231         address from,
2232         address to,
2233         uint256 tokenId
2234     ) external;
2235 
2236     /**
2237      * @dev Transfers `tokenId` token from `from` to `to`.
2238      *
2239      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2240      *
2241      * Requirements:
2242      *
2243      * - `from` cannot be the zero address.
2244      * - `to` cannot be the zero address.
2245      * - `tokenId` token must be owned by `from`.
2246      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2247      *
2248      * Emits a {Transfer} event.
2249      */
2250     function transferFrom(
2251         address from,
2252         address to,
2253         uint256 tokenId
2254     ) external;
2255 
2256     /**
2257      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2258      * The approval is cleared when the token is transferred.
2259      *
2260      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2261      *
2262      * Requirements:
2263      *
2264      * - The caller must own the token or be an approved operator.
2265      * - `tokenId` must exist.
2266      *
2267      * Emits an {Approval} event.
2268      */
2269     function approve(address to, uint256 tokenId) external;
2270 
2271     /**
2272      * @dev Approve or remove `operator` as an operator for the caller.
2273      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2274      *
2275      * Requirements:
2276      *
2277      * - The `operator` cannot be the caller.
2278      *
2279      * Emits an {ApprovalForAll} event.
2280      */
2281     function setApprovalForAll(address operator, bool _approved) external;
2282 
2283     /**
2284      * @dev Returns the account approved for `tokenId` token.
2285      *
2286      * Requirements:
2287      *
2288      * - `tokenId` must exist.
2289      */
2290     function getApproved(uint256 tokenId) external view returns (address operator);
2291 
2292     /**
2293      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2294      *
2295      * See {setApprovalForAll}
2296      */
2297     function isApprovedForAll(address owner, address operator) external view returns (bool);
2298 }
2299 
2300 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2301 
2302 
2303 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2304 
2305 pragma solidity ^0.8.0;
2306 
2307 
2308 /**
2309  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2310  * @dev See https://eips.ethereum.org/EIPS/eip-721
2311  */
2312 interface IERC721Metadata is IERC721 {
2313     /**
2314      * @dev Returns the token collection name.
2315      */
2316     function name() external view returns (string memory);
2317 
2318     /**
2319      * @dev Returns the token collection symbol.
2320      */
2321     function symbol() external view returns (string memory);
2322 
2323     /**
2324      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2325      */
2326     function tokenURI(uint256 tokenId) external view returns (string memory);
2327 }
2328 
2329 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2330 
2331 
2332 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2333 
2334 pragma solidity ^0.8.0;
2335 
2336 
2337 /**
2338  * @dev Implementation of the {IERC165} interface.
2339  *
2340  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2341  * for the additional interface id that will be supported. For example:
2342  *
2343  * ```solidity
2344  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2345  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2346  * }
2347  * ```
2348  *
2349  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2350  */
2351 abstract contract ERC165 is IERC165 {
2352     /**
2353      * @dev See {IERC165-supportsInterface}.
2354      */
2355     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2356         return interfaceId == type(IERC165).interfaceId;
2357     }
2358 }
2359 
2360 // File: @openzeppelin/contracts/utils/Strings.sol
2361 
2362 
2363 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
2364 
2365 pragma solidity ^0.8.0;
2366 
2367 /**
2368  * @dev String operations.
2369  */
2370 library Strings {
2371     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2372 
2373     /**
2374      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2375      */
2376     function toString(uint256 value) internal pure returns (string memory) {
2377         // Inspired by OraclizeAPI's implementation - MIT licence
2378         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2379 
2380         if (value == 0) {
2381             return "0";
2382         }
2383         uint256 temp = value;
2384         uint256 digits;
2385         while (temp != 0) {
2386             digits++;
2387             temp /= 10;
2388         }
2389         bytes memory buffer = new bytes(digits);
2390         while (value != 0) {
2391             digits -= 1;
2392             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2393             value /= 10;
2394         }
2395         return string(buffer);
2396     }
2397 
2398     /**
2399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2400      */
2401     function toHexString(uint256 value) internal pure returns (string memory) {
2402         if (value == 0) {
2403             return "0x00";
2404         }
2405         uint256 temp = value;
2406         uint256 length = 0;
2407         while (temp != 0) {
2408             length++;
2409             temp >>= 8;
2410         }
2411         return toHexString(value, length);
2412     }
2413 
2414     /**
2415      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2416      */
2417     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2418         bytes memory buffer = new bytes(2 * length + 2);
2419         buffer[0] = "0";
2420         buffer[1] = "x";
2421         for (uint256 i = 2 * length + 1; i > 1; --i) {
2422             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2423             value >>= 4;
2424         }
2425         require(value == 0, "Strings: hex length insufficient");
2426         return string(buffer);
2427     }
2428 }
2429 
2430 // File: @openzeppelin/contracts/access/IAccessControl.sol
2431 
2432 
2433 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
2434 
2435 pragma solidity ^0.8.0;
2436 
2437 /**
2438  * @dev External interface of AccessControl declared to support ERC165 detection.
2439  */
2440 interface IAccessControl {
2441     /**
2442      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
2443      *
2444      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
2445      * {RoleAdminChanged} not being emitted signaling this.
2446      *
2447      * _Available since v3.1._
2448      */
2449     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
2450 
2451     /**
2452      * @dev Emitted when `account` is granted `role`.
2453      *
2454      * `sender` is the account that originated the contract call, an admin role
2455      * bearer except when using {AccessControl-_setupRole}.
2456      */
2457     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
2458 
2459     /**
2460      * @dev Emitted when `account` is revoked `role`.
2461      *
2462      * `sender` is the account that originated the contract call:
2463      *   - if using `revokeRole`, it is the admin role bearer
2464      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
2465      */
2466     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
2467 
2468     /**
2469      * @dev Returns `true` if `account` has been granted `role`.
2470      */
2471     function hasRole(bytes32 role, address account) external view returns (bool);
2472 
2473     /**
2474      * @dev Returns the admin role that controls `role`. See {grantRole} and
2475      * {revokeRole}.
2476      *
2477      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
2478      */
2479     function getRoleAdmin(bytes32 role) external view returns (bytes32);
2480 
2481     /**
2482      * @dev Grants `role` to `account`.
2483      *
2484      * If `account` had not been already granted `role`, emits a {RoleGranted}
2485      * event.
2486      *
2487      * Requirements:
2488      *
2489      * - the caller must have ``role``'s admin role.
2490      */
2491     function grantRole(bytes32 role, address account) external;
2492 
2493     /**
2494      * @dev Revokes `role` from `account`.
2495      *
2496      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2497      *
2498      * Requirements:
2499      *
2500      * - the caller must have ``role``'s admin role.
2501      */
2502     function revokeRole(bytes32 role, address account) external;
2503 
2504     /**
2505      * @dev Revokes `role` from the calling account.
2506      *
2507      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2508      * purpose is to provide a mechanism for accounts to lose their privileges
2509      * if they are compromised (such as when a trusted device is misplaced).
2510      *
2511      * If the calling account had been granted `role`, emits a {RoleRevoked}
2512      * event.
2513      *
2514      * Requirements:
2515      *
2516      * - the caller must be `account`.
2517      */
2518     function renounceRole(bytes32 role, address account) external;
2519 }
2520 
2521 // File: @openzeppelin/contracts/utils/Context.sol
2522 
2523 
2524 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2525 
2526 pragma solidity ^0.8.0;
2527 
2528 /**
2529  * @dev Provides information about the current execution context, including the
2530  * sender of the transaction and its data. While these are generally available
2531  * via msg.sender and msg.data, they should not be accessed in such a direct
2532  * manner, since when dealing with meta-transactions the account sending and
2533  * paying for execution may not be the actual sender (as far as an application
2534  * is concerned).
2535  *
2536  * This contract is only required for intermediate, library-like contracts.
2537  */
2538 abstract contract Context {
2539     function _msgSender() internal view virtual returns (address) {
2540         return msg.sender;
2541     }
2542 
2543     function _msgData() internal view virtual returns (bytes calldata) {
2544         return msg.data;
2545     }
2546 }
2547 
2548 // File: @openzeppelin/contracts/security/Pausable.sol
2549 
2550 
2551 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
2552 
2553 pragma solidity ^0.8.0;
2554 
2555 
2556 /**
2557  * @dev Contract module which allows children to implement an emergency stop
2558  * mechanism that can be triggered by an authorized account.
2559  *
2560  * This module is used through inheritance. It will make available the
2561  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2562  * the functions of your contract. Note that they will not be pausable by
2563  * simply including this module, only once the modifiers are put in place.
2564  */
2565 abstract contract Pausable is Context {
2566     /**
2567      * @dev Emitted when the pause is triggered by `account`.
2568      */
2569     event Paused(address account);
2570 
2571     /**
2572      * @dev Emitted when the pause is lifted by `account`.
2573      */
2574     event Unpaused(address account);
2575 
2576     bool private _paused;
2577 
2578     /**
2579      * @dev Initializes the contract in unpaused state.
2580      */
2581     constructor() {
2582         _paused = false;
2583     }
2584 
2585     /**
2586      * @dev Returns true if the contract is paused, and false otherwise.
2587      */
2588     function paused() public view virtual returns (bool) {
2589         return _paused;
2590     }
2591 
2592     /**
2593      * @dev Modifier to make a function callable only when the contract is not paused.
2594      *
2595      * Requirements:
2596      *
2597      * - The contract must not be paused.
2598      */
2599     modifier whenNotPaused() {
2600         require(!paused(), "Pausable: paused");
2601         _;
2602     }
2603 
2604     /**
2605      * @dev Modifier to make a function callable only when the contract is paused.
2606      *
2607      * Requirements:
2608      *
2609      * - The contract must be paused.
2610      */
2611     modifier whenPaused() {
2612         require(paused(), "Pausable: not paused");
2613         _;
2614     }
2615 
2616     /**
2617      * @dev Triggers stopped state.
2618      *
2619      * Requirements:
2620      *
2621      * - The contract must not be paused.
2622      */
2623     function _pause() internal virtual whenNotPaused {
2624         _paused = true;
2625         emit Paused(_msgSender());
2626     }
2627 
2628     /**
2629      * @dev Returns to normal state.
2630      *
2631      * Requirements:
2632      *
2633      * - The contract must be paused.
2634      */
2635     function _unpause() internal virtual whenPaused {
2636         _paused = false;
2637         emit Unpaused(_msgSender());
2638     }
2639 }
2640 
2641 // File: nft/ERC721APausable.sol
2642 
2643 
2644 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
2645 
2646 pragma solidity ^0.8.0;
2647 
2648 
2649 
2650 /**
2651  * @dev ERC721 token with pausable token transfers, minting and burning.
2652  *
2653  * Useful for scenarios such as preventing trades until the end of an evaluation
2654  * period, or having an emergency switch for freezing all token transfers in the
2655  * event of a large bug.
2656  */
2657 abstract contract ERC721APausable is ERC721A, Pausable {
2658     /**
2659      * @dev See {ERC721A-_beforeTokenTransfers}.
2660      *
2661      * Requirements:
2662      *
2663      * - the contract must not be paused.
2664      */
2665     function _beforeTokenTransfers(
2666         address from,
2667         address to,
2668         uint256 startTokenId,
2669         uint256 quantity
2670     ) internal virtual override(ERC721A) {
2671         super._beforeTokenTransfers(from, to, startTokenId, quantity);
2672         require(!paused(), "ERC721APausable: token transfer while paused");
2673     }
2674 }
2675 
2676 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2677 
2678 
2679 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
2680 
2681 pragma solidity ^0.8.0;
2682 
2683 
2684 
2685 
2686 
2687 
2688 
2689 
2690 /**
2691  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2692  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2693  * {ERC721Enumerable}.
2694  */
2695 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2696     using Address for address;
2697     using Strings for uint256;
2698 
2699     // Token name
2700     string private _name;
2701 
2702     // Token symbol
2703     string private _symbol;
2704 
2705     // Mapping from token ID to owner address
2706     mapping(uint256 => address) private _owners;
2707 
2708     // Mapping owner address to token count
2709     mapping(address => uint256) private _balances;
2710 
2711     // Mapping from token ID to approved address
2712     mapping(uint256 => address) private _tokenApprovals;
2713 
2714     // Mapping from owner to operator approvals
2715     mapping(address => mapping(address => bool)) private _operatorApprovals;
2716 
2717     /**
2718      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2719      */
2720     constructor(string memory name_, string memory symbol_) {
2721         _name = name_;
2722         _symbol = symbol_;
2723     }
2724 
2725     /**
2726      * @dev See {IERC165-supportsInterface}.
2727      */
2728     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2729         return
2730             interfaceId == type(IERC721).interfaceId ||
2731             interfaceId == type(IERC721Metadata).interfaceId ||
2732             super.supportsInterface(interfaceId);
2733     }
2734 
2735     /**
2736      * @dev See {IERC721-balanceOf}.
2737      */
2738     function balanceOf(address owner) public view virtual override returns (uint256) {
2739         require(owner != address(0), "ERC721: balance query for the zero address");
2740         return _balances[owner];
2741     }
2742 
2743     /**
2744      * @dev See {IERC721-ownerOf}.
2745      */
2746     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2747         address owner = _owners[tokenId];
2748         require(owner != address(0), "ERC721: owner query for nonexistent token");
2749         return owner;
2750     }
2751 
2752     /**
2753      * @dev See {IERC721Metadata-name}.
2754      */
2755     function name() public view virtual override returns (string memory) {
2756         return _name;
2757     }
2758 
2759     /**
2760      * @dev See {IERC721Metadata-symbol}.
2761      */
2762     function symbol() public view virtual override returns (string memory) {
2763         return _symbol;
2764     }
2765 
2766     /**
2767      * @dev See {IERC721Metadata-tokenURI}.
2768      */
2769     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2770         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2771 
2772         string memory baseURI = _baseURI();
2773         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2774     }
2775 
2776     /**
2777      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2778      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2779      * by default, can be overridden in child contracts.
2780      */
2781     function _baseURI() internal view virtual returns (string memory) {
2782         return "";
2783     }
2784 
2785     /**
2786      * @dev See {IERC721-approve}.
2787      */
2788     function approve(address to, uint256 tokenId) public virtual override {
2789         address owner = ERC721.ownerOf(tokenId);
2790         require(to != owner, "ERC721: approval to current owner");
2791 
2792         require(
2793             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2794             "ERC721: approve caller is not owner nor approved for all"
2795         );
2796 
2797         _approve(to, tokenId);
2798     }
2799 
2800     /**
2801      * @dev See {IERC721-getApproved}.
2802      */
2803     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2804         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2805 
2806         return _tokenApprovals[tokenId];
2807     }
2808 
2809     /**
2810      * @dev See {IERC721-setApprovalForAll}.
2811      */
2812     function setApprovalForAll(address operator, bool approved) public virtual override {
2813         _setApprovalForAll(_msgSender(), operator, approved);
2814     }
2815 
2816     /**
2817      * @dev See {IERC721-isApprovedForAll}.
2818      */
2819     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2820         return _operatorApprovals[owner][operator];
2821     }
2822 
2823     /**
2824      * @dev See {IERC721-transferFrom}.
2825      */
2826     function transferFrom(
2827         address from,
2828         address to,
2829         uint256 tokenId
2830     ) public virtual override {
2831         //solhint-disable-next-line max-line-length
2832         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2833 
2834         _transfer(from, to, tokenId);
2835     }
2836 
2837     /**
2838      * @dev See {IERC721-safeTransferFrom}.
2839      */
2840     function safeTransferFrom(
2841         address from,
2842         address to,
2843         uint256 tokenId
2844     ) public virtual override {
2845         safeTransferFrom(from, to, tokenId, "");
2846     }
2847 
2848     /**
2849      * @dev See {IERC721-safeTransferFrom}.
2850      */
2851     function safeTransferFrom(
2852         address from,
2853         address to,
2854         uint256 tokenId,
2855         bytes memory _data
2856     ) public virtual override {
2857         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2858         _safeTransfer(from, to, tokenId, _data);
2859     }
2860 
2861     /**
2862      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2863      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2864      *
2865      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2866      *
2867      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2868      * implement alternative mechanisms to perform token transfer, such as signature-based.
2869      *
2870      * Requirements:
2871      *
2872      * - `from` cannot be the zero address.
2873      * - `to` cannot be the zero address.
2874      * - `tokenId` token must exist and be owned by `from`.
2875      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2876      *
2877      * Emits a {Transfer} event.
2878      */
2879     function _safeTransfer(
2880         address from,
2881         address to,
2882         uint256 tokenId,
2883         bytes memory _data
2884     ) internal virtual {
2885         _transfer(from, to, tokenId);
2886         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2887     }
2888 
2889     /**
2890      * @dev Returns whether `tokenId` exists.
2891      *
2892      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2893      *
2894      * Tokens start existing when they are minted (`_mint`),
2895      * and stop existing when they are burned (`_burn`).
2896      */
2897     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2898         return _owners[tokenId] != address(0);
2899     }
2900 
2901     /**
2902      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2903      *
2904      * Requirements:
2905      *
2906      * - `tokenId` must exist.
2907      */
2908     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2909         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2910         address owner = ERC721.ownerOf(tokenId);
2911         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2912     }
2913 
2914     /**
2915      * @dev Safely mints `tokenId` and transfers it to `to`.
2916      *
2917      * Requirements:
2918      *
2919      * - `tokenId` must not exist.
2920      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2921      *
2922      * Emits a {Transfer} event.
2923      */
2924     function _safeMint(address to, uint256 tokenId) internal virtual {
2925         _safeMint(to, tokenId, "");
2926     }
2927 
2928     /**
2929      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2930      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2931      */
2932     function _safeMint(
2933         address to,
2934         uint256 tokenId,
2935         bytes memory _data
2936     ) internal virtual {
2937         _mint(to, tokenId);
2938         require(
2939             _checkOnERC721Received(address(0), to, tokenId, _data),
2940             "ERC721: transfer to non ERC721Receiver implementer"
2941         );
2942     }
2943 
2944     /**
2945      * @dev Mints `tokenId` and transfers it to `to`.
2946      *
2947      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2948      *
2949      * Requirements:
2950      *
2951      * - `tokenId` must not exist.
2952      * - `to` cannot be the zero address.
2953      *
2954      * Emits a {Transfer} event.
2955      */
2956     function _mint(address to, uint256 tokenId) internal virtual {
2957         require(to != address(0), "ERC721: mint to the zero address");
2958         require(!_exists(tokenId), "ERC721: token already minted");
2959 
2960         _beforeTokenTransfer(address(0), to, tokenId);
2961 
2962         _balances[to] += 1;
2963         _owners[tokenId] = to;
2964 
2965         emit Transfer(address(0), to, tokenId);
2966 
2967         _afterTokenTransfer(address(0), to, tokenId);
2968     }
2969 
2970     /**
2971      * @dev Destroys `tokenId`.
2972      * The approval is cleared when the token is burned.
2973      *
2974      * Requirements:
2975      *
2976      * - `tokenId` must exist.
2977      *
2978      * Emits a {Transfer} event.
2979      */
2980     function _burn(uint256 tokenId) internal virtual {
2981         address owner = ERC721.ownerOf(tokenId);
2982 
2983         _beforeTokenTransfer(owner, address(0), tokenId);
2984 
2985         // Clear approvals
2986         _approve(address(0), tokenId);
2987 
2988         _balances[owner] -= 1;
2989         delete _owners[tokenId];
2990 
2991         emit Transfer(owner, address(0), tokenId);
2992 
2993         _afterTokenTransfer(owner, address(0), tokenId);
2994     }
2995 
2996     /**
2997      * @dev Transfers `tokenId` from `from` to `to`.
2998      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2999      *
3000      * Requirements:
3001      *
3002      * - `to` cannot be the zero address.
3003      * - `tokenId` token must be owned by `from`.
3004      *
3005      * Emits a {Transfer} event.
3006      */
3007     function _transfer(
3008         address from,
3009         address to,
3010         uint256 tokenId
3011     ) internal virtual {
3012         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3013         require(to != address(0), "ERC721: transfer to the zero address");
3014 
3015         _beforeTokenTransfer(from, to, tokenId);
3016 
3017         // Clear approvals from the previous owner
3018         _approve(address(0), tokenId);
3019 
3020         _balances[from] -= 1;
3021         _balances[to] += 1;
3022         _owners[tokenId] = to;
3023 
3024         emit Transfer(from, to, tokenId);
3025 
3026         _afterTokenTransfer(from, to, tokenId);
3027     }
3028 
3029     /**
3030      * @dev Approve `to` to operate on `tokenId`
3031      *
3032      * Emits a {Approval} event.
3033      */
3034     function _approve(address to, uint256 tokenId) internal virtual {
3035         _tokenApprovals[tokenId] = to;
3036         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3037     }
3038 
3039     /**
3040      * @dev Approve `operator` to operate on all of `owner` tokens
3041      *
3042      * Emits a {ApprovalForAll} event.
3043      */
3044     function _setApprovalForAll(
3045         address owner,
3046         address operator,
3047         bool approved
3048     ) internal virtual {
3049         require(owner != operator, "ERC721: approve to caller");
3050         _operatorApprovals[owner][operator] = approved;
3051         emit ApprovalForAll(owner, operator, approved);
3052     }
3053 
3054     /**
3055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3056      * The call is not executed if the target address is not a contract.
3057      *
3058      * @param from address representing the previous owner of the given token ID
3059      * @param to target address that will receive the tokens
3060      * @param tokenId uint256 ID of the token to be transferred
3061      * @param _data bytes optional data to send along with the call
3062      * @return bool whether the call correctly returned the expected magic value
3063      */
3064     function _checkOnERC721Received(
3065         address from,
3066         address to,
3067         uint256 tokenId,
3068         bytes memory _data
3069     ) private returns (bool) {
3070         if (to.isContract()) {
3071             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
3072                 return retval == IERC721Receiver.onERC721Received.selector;
3073             } catch (bytes memory reason) {
3074                 if (reason.length == 0) {
3075                     revert("ERC721: transfer to non ERC721Receiver implementer");
3076                 } else {
3077                     assembly {
3078                         revert(add(32, reason), mload(reason))
3079                     }
3080                 }
3081             }
3082         } else {
3083             return true;
3084         }
3085     }
3086 
3087     /**
3088      * @dev Hook that is called before any token transfer. This includes minting
3089      * and burning.
3090      *
3091      * Calling conditions:
3092      *
3093      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3094      * transferred to `to`.
3095      * - When `from` is zero, `tokenId` will be minted for `to`.
3096      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3097      * - `from` and `to` are never both zero.
3098      *
3099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3100      */
3101     function _beforeTokenTransfer(
3102         address from,
3103         address to,
3104         uint256 tokenId
3105     ) internal virtual {}
3106 
3107     /**
3108      * @dev Hook that is called after any transfer of tokens. This includes
3109      * minting and burning.
3110      *
3111      * Calling conditions:
3112      *
3113      * - when `from` and `to` are both non-zero.
3114      * - `from` and `to` are never both zero.
3115      *
3116      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3117      */
3118     function _afterTokenTransfer(
3119         address from,
3120         address to,
3121         uint256 tokenId
3122     ) internal virtual {}
3123 }
3124 
3125 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
3126 
3127 
3128 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
3129 
3130 pragma solidity ^0.8.0;
3131 
3132 
3133 
3134 /**
3135  * @dev ERC721 token with pausable token transfers, minting and burning.
3136  *
3137  * Useful for scenarios such as preventing trades until the end of an evaluation
3138  * period, or having an emergency switch for freezing all token transfers in the
3139  * event of a large bug.
3140  */
3141 abstract contract ERC721Pausable is ERC721, Pausable {
3142     /**
3143      * @dev See {ERC721-_beforeTokenTransfer}.
3144      *
3145      * Requirements:
3146      *
3147      * - the contract must not be paused.
3148      */
3149     function _beforeTokenTransfer(
3150         address from,
3151         address to,
3152         uint256 tokenId
3153     ) internal virtual override {
3154         super._beforeTokenTransfer(from, to, tokenId);
3155 
3156         require(!paused(), "ERC721Pausable: token transfer while paused");
3157     }
3158 }
3159 
3160 // File: @openzeppelin/contracts/access/AccessControl.sol
3161 
3162 
3163 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
3164 
3165 pragma solidity ^0.8.0;
3166 
3167 
3168 
3169 
3170 
3171 /**
3172  * @dev Contract module that allows children to implement role-based access
3173  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
3174  * members except through off-chain means by accessing the contract event logs. Some
3175  * applications may benefit from on-chain enumerability, for those cases see
3176  * {AccessControlEnumerable}.
3177  *
3178  * Roles are referred to by their `bytes32` identifier. These should be exposed
3179  * in the external API and be unique. The best way to achieve this is by
3180  * using `public constant` hash digests:
3181  *
3182  * ```
3183  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
3184  * ```
3185  *
3186  * Roles can be used to represent a set of permissions. To restrict access to a
3187  * function call, use {hasRole}:
3188  *
3189  * ```
3190  * function foo() public {
3191  *     require(hasRole(MY_ROLE, msg.sender));
3192  *     ...
3193  * }
3194  * ```
3195  *
3196  * Roles can be granted and revoked dynamically via the {grantRole} and
3197  * {revokeRole} functions. Each role has an associated admin role, and only
3198  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
3199  *
3200  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
3201  * that only accounts with this role will be able to grant or revoke other
3202  * roles. More complex role relationships can be created by using
3203  * {_setRoleAdmin}.
3204  *
3205  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
3206  * grant and revoke this role. Extra precautions should be taken to secure
3207  * accounts that have been granted it.
3208  */
3209 abstract contract AccessControl is Context, IAccessControl, ERC165 {
3210     struct RoleData {
3211         mapping(address => bool) members;
3212         bytes32 adminRole;
3213     }
3214 
3215     mapping(bytes32 => RoleData) private _roles;
3216 
3217     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
3218 
3219     /**
3220      * @dev Modifier that checks that an account has a specific role. Reverts
3221      * with a standardized message including the required role.
3222      *
3223      * The format of the revert reason is given by the following regular expression:
3224      *
3225      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
3226      *
3227      * _Available since v4.1._
3228      */
3229     modifier onlyRole(bytes32 role) {
3230         _checkRole(role);
3231         _;
3232     }
3233 
3234     /**
3235      * @dev See {IERC165-supportsInterface}.
3236      */
3237     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3238         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
3239     }
3240 
3241     /**
3242      * @dev Returns `true` if `account` has been granted `role`.
3243      */
3244     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
3245         return _roles[role].members[account];
3246     }
3247 
3248     /**
3249      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
3250      * Overriding this function changes the behavior of the {onlyRole} modifier.
3251      *
3252      * Format of the revert message is described in {_checkRole}.
3253      *
3254      * _Available since v4.6._
3255      */
3256     function _checkRole(bytes32 role) internal view virtual {
3257         _checkRole(role, _msgSender());
3258     }
3259 
3260     /**
3261      * @dev Revert with a standard message if `account` is missing `role`.
3262      *
3263      * The format of the revert reason is given by the following regular expression:
3264      *
3265      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
3266      */
3267     function _checkRole(bytes32 role, address account) internal view virtual {
3268         if (!hasRole(role, account)) {
3269             revert(
3270                 string(
3271                     abi.encodePacked(
3272                         "AccessControl: account ",
3273                         Strings.toHexString(uint160(account), 20),
3274                         " is missing role ",
3275                         Strings.toHexString(uint256(role), 32)
3276                     )
3277                 )
3278             );
3279         }
3280     }
3281 
3282     /**
3283      * @dev Returns the admin role that controls `role`. See {grantRole} and
3284      * {revokeRole}.
3285      *
3286      * To change a role's admin, use {_setRoleAdmin}.
3287      */
3288     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
3289         return _roles[role].adminRole;
3290     }
3291 
3292     /**
3293      * @dev Grants `role` to `account`.
3294      *
3295      * If `account` had not been already granted `role`, emits a {RoleGranted}
3296      * event.
3297      *
3298      * Requirements:
3299      *
3300      * - the caller must have ``role``'s admin role.
3301      */
3302     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3303         _grantRole(role, account);
3304     }
3305 
3306     /**
3307      * @dev Revokes `role` from `account`.
3308      *
3309      * If `account` had been granted `role`, emits a {RoleRevoked} event.
3310      *
3311      * Requirements:
3312      *
3313      * - the caller must have ``role``'s admin role.
3314      */
3315     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3316         _revokeRole(role, account);
3317     }
3318 
3319     /**
3320      * @dev Revokes `role` from the calling account.
3321      *
3322      * Roles are often managed via {grantRole} and {revokeRole}: this function's
3323      * purpose is to provide a mechanism for accounts to lose their privileges
3324      * if they are compromised (such as when a trusted device is misplaced).
3325      *
3326      * If the calling account had been revoked `role`, emits a {RoleRevoked}
3327      * event.
3328      *
3329      * Requirements:
3330      *
3331      * - the caller must be `account`.
3332      */
3333     function renounceRole(bytes32 role, address account) public virtual override {
3334         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
3335 
3336         _revokeRole(role, account);
3337     }
3338 
3339     /**
3340      * @dev Grants `role` to `account`.
3341      *
3342      * If `account` had not been already granted `role`, emits a {RoleGranted}
3343      * event. Note that unlike {grantRole}, this function doesn't perform any
3344      * checks on the calling account.
3345      *
3346      * [WARNING]
3347      * ====
3348      * This function should only be called from the constructor when setting
3349      * up the initial roles for the system.
3350      *
3351      * Using this function in any other way is effectively circumventing the admin
3352      * system imposed by {AccessControl}.
3353      * ====
3354      *
3355      * NOTE: This function is deprecated in favor of {_grantRole}.
3356      */
3357     function _setupRole(bytes32 role, address account) internal virtual {
3358         _grantRole(role, account);
3359     }
3360 
3361     /**
3362      * @dev Sets `adminRole` as ``role``'s admin role.
3363      *
3364      * Emits a {RoleAdminChanged} event.
3365      */
3366     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
3367         bytes32 previousAdminRole = getRoleAdmin(role);
3368         _roles[role].adminRole = adminRole;
3369         emit RoleAdminChanged(role, previousAdminRole, adminRole);
3370     }
3371 
3372     /**
3373      * @dev Grants `role` to `account`.
3374      *
3375      * Internal function without access restriction.
3376      */
3377     function _grantRole(bytes32 role, address account) internal virtual {
3378         if (!hasRole(role, account)) {
3379             _roles[role].members[account] = true;
3380             emit RoleGranted(role, account, _msgSender());
3381         }
3382     }
3383 
3384     /**
3385      * @dev Revokes `role` from `account`.
3386      *
3387      * Internal function without access restriction.
3388      */
3389     function _revokeRole(bytes32 role, address account) internal virtual {
3390         if (hasRole(role, account)) {
3391             _roles[role].members[account] = false;
3392             emit RoleRevoked(role, account, _msgSender());
3393         }
3394     }
3395 }
3396 
3397 // File: @openzeppelin/contracts/access/Ownable.sol
3398 
3399 
3400 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
3401 
3402 pragma solidity ^0.8.0;
3403 
3404 
3405 /**
3406  * @dev Contract module which provides a basic access control mechanism, where
3407  * there is an account (an owner) that can be granted exclusive access to
3408  * specific functions.
3409  *
3410  * By default, the owner account will be the one that deploys the contract. This
3411  * can later be changed with {transferOwnership}.
3412  *
3413  * This module is used through inheritance. It will make available the modifier
3414  * `onlyOwner`, which can be applied to your functions to restrict their use to
3415  * the owner.
3416  */
3417 abstract contract Ownable is Context {
3418     address private _owner;
3419 
3420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3421 
3422     /**
3423      * @dev Initializes the contract setting the deployer as the initial owner.
3424      */
3425     constructor() {
3426         _transferOwnership(_msgSender());
3427     }
3428 
3429     /**
3430      * @dev Returns the address of the current owner.
3431      */
3432     function owner() public view virtual returns (address) {
3433         return _owner;
3434     }
3435 
3436     /**
3437      * @dev Throws if called by any account other than the owner.
3438      */
3439     modifier onlyOwner() {
3440         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3441         _;
3442     }
3443 
3444     /**
3445      * @dev Leaves the contract without owner. It will not be possible to call
3446      * `onlyOwner` functions anymore. Can only be called by the current owner.
3447      *
3448      * NOTE: Renouncing ownership will leave the contract without an owner,
3449      * thereby removing any functionality that is only available to the owner.
3450      */
3451     function renounceOwnership() public virtual onlyOwner {
3452         _transferOwnership(address(0));
3453     }
3454 
3455     /**
3456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3457      * Can only be called by the current owner.
3458      */
3459     function transferOwnership(address newOwner) public virtual onlyOwner {
3460         require(newOwner != address(0), "Ownable: new owner is the zero address");
3461         _transferOwnership(newOwner);
3462     }
3463 
3464     /**
3465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3466      * Internal function without access restriction.
3467      */
3468     function _transferOwnership(address newOwner) internal virtual {
3469         address oldOwner = _owner;
3470         _owner = newOwner;
3471         emit OwnershipTransferred(oldOwner, newOwner);
3472     }
3473 }
3474 
3475 // File: @openzeppelin/contracts/utils/Counters.sol
3476 
3477 
3478 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
3479 
3480 pragma solidity ^0.8.0;
3481 
3482 /**
3483  * @title Counters
3484  * @author Matt Condon (@shrugs)
3485  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
3486  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
3487  *
3488  * Include with `using Counters for Counters.Counter;`
3489  */
3490 library Counters {
3491     struct Counter {
3492         // This variable should never be directly accessed by users of the library: interactions must be restricted to
3493         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
3494         // this feature: see https://github.com/ethereum/solidity/issues/4637
3495         uint256 _value; // default: 0
3496     }
3497 
3498     function current(Counter storage counter) internal view returns (uint256) {
3499         return counter._value;
3500     }
3501 
3502     function increment(Counter storage counter) internal {
3503         unchecked {
3504             counter._value += 1;
3505         }
3506     }
3507 
3508     function decrement(Counter storage counter) internal {
3509         uint256 value = counter._value;
3510         require(value > 0, "Counter: decrement overflow");
3511         unchecked {
3512             counter._value = value - 1;
3513         }
3514     }
3515 
3516     function reset(Counter storage counter) internal {
3517         counter._value = 0;
3518     }
3519 }
3520 
3521 // File: nft/NFTERC721A.sol
3522 
3523 
3524 pragma solidity ^0.8.7;
3525 
3526 
3527 
3528 
3529 
3530 
3531 
3532 
3533 
3534 
3535 
3536 contract NFTERC721A is
3537     ERC721A,
3538     ERC721ABurnable,
3539     ERC721AQueryable,
3540     ERC721APausable,
3541     AccessControl,
3542     Ownable,
3543     ContextMixin,
3544     NativeMetaTransaction
3545 {
3546     // Create a new role identifier for the minter role
3547     bytes32 public constant MINER_ROLE = keccak256("MINER_ROLE");
3548     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
3549     // using Counters for Counters.Counter;
3550     // Counters.Counter private currentTokenId;
3551     /// @dev Base token URI used as a prefix by tokenURI().
3552     string private baseTokenURI;
3553     string private collectionURI;
3554 
3555     // uint256 public constant TOTAL_SUPPLY = 10800;
3556 
3557     constructor() ERC721A("SONNY-BOOT", "HM-SON-BOOT") {
3558         _initializeEIP712("SONNY-BOOT");
3559         baseTokenURI = "https://cdn.nftstar.com/hm-son-boot/metadata/";
3560         collectionURI = "https://cdn.nftstar.com/hm-son-boot/meta-son-heung-min.json";
3561         // Grant the contract deployer the default admin role: it will be able to grant and revoke any roles
3562         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
3563         _setupRole(MINER_ROLE, _msgSender());
3564         _setupRole(PAUSER_ROLE, _msgSender());
3565     }
3566 
3567     // function totalSupply() public view returns (uint256) {
3568     //     return TOTAL_SUPPLY;
3569     // }
3570 
3571     // function remaining() public view returns (uint256) {
3572     //     return TOTAL_SUPPLY - _totalMinted();
3573     // }
3574 
3575     function mintTo(address to) public onlyRole(MINER_ROLE) {
3576         _mint(to, 1);
3577     }
3578 
3579     function mint(address to, uint256 quantity) public onlyRole(MINER_ROLE) {
3580         _safeMint(to, quantity);
3581     }
3582 
3583     /**
3584      * tokensOfOwner
3585      */
3586     // function ownerTokens(address owner) public view returns (uint256[] memory) {
3587     //     return tokensOfOwner(owner);
3588     // }
3589 
3590     /**
3591      * @dev Pauses all token transfers.
3592      *
3593      * See {ERC721Pausable} and {Pausable-_pause}.
3594      *
3595      * Requirements:
3596      *
3597      * - the caller must have the `PAUSER_ROLE`.
3598      */
3599     function pause() public virtual {
3600         require(
3601             hasRole(PAUSER_ROLE, _msgSender()),
3602             "NFT: must have pauser role to pause"
3603         );
3604         _pause();
3605     }
3606 
3607     /**
3608      * @dev Unpauses all token transfers.
3609      *
3610      * See {ERC721Pausable} and {Pausable-_unpause}.
3611      *
3612      * Requirements:
3613      *
3614      * - the caller must have the `PAUSER_ROLE`.
3615      */
3616     function unpause() public virtual {
3617         require(
3618             hasRole(PAUSER_ROLE, _msgSender()),
3619             "NFT: must have pauser role to unpause"
3620         );
3621         _unpause();
3622     }
3623 
3624     function current() public view returns (uint256) {
3625         return _totalMinted();
3626     }
3627 
3628     function _startTokenId() internal pure override returns (uint256) {
3629         return 1;
3630     }
3631 
3632     function contractURI() public view returns (string memory) {
3633         return collectionURI;
3634     }
3635 
3636     function setContractURI(string memory _contractURI) public onlyOwner {
3637         collectionURI = _contractURI;
3638     }
3639 
3640     /// @dev Returns an URI for a given token ID
3641     function _baseURI() internal view virtual override returns (string memory) {
3642         return baseTokenURI;
3643     }
3644 
3645     /// @dev Sets the base token URI prefix.
3646     function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
3647         baseTokenURI = _baseTokenURI;
3648     }
3649 
3650     function transferRoleAdmin(address newDefaultAdmin)
3651         external
3652         onlyRole(DEFAULT_ADMIN_ROLE)
3653     {
3654         _setupRole(DEFAULT_ADMIN_ROLE, newDefaultAdmin);
3655     }
3656 
3657     /**
3658      * @dev See {IERC165-supportsInterface}.
3659      */
3660     function supportsInterface(bytes4 interfaceId)
3661         public
3662         view
3663         virtual
3664         override(AccessControl, ERC721A)
3665         returns (bool)
3666     {
3667         return
3668             super.supportsInterface(interfaceId) ||
3669             ERC721A.supportsInterface(interfaceId);
3670     }
3671 
3672     function _beforeTokenTransfers(
3673         address from,
3674         address to,
3675         uint256 startTokenId,
3676         uint256 quantity
3677     ) internal virtual override(ERC721A, ERC721APausable) {
3678         super._beforeTokenTransfers(from, to, startTokenId, quantity);
3679     }
3680 
3681     function _msgSender()
3682         internal
3683         view
3684         virtual
3685         override
3686         returns (address sender)
3687     {
3688         return ContextMixin.msgSender();
3689     }
3690 }