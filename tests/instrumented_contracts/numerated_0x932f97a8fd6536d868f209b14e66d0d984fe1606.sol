1 /**
2  *Submitted for verification at BscScan.com on 2022-10-11
3 */
4 
5 // File: contracts/IERC1538.sol
6 
7 
8 pragma solidity ^0.8.14;
9 
10 
11 /// @title ERC1538 Transparent Contract Standard
12 /// @dev Required interface
13 ///  Note: the ERC-165 identifier for this interface is 0x61455567
14 interface IERC1538 {
15 
16     /// @dev This emits when one or a set of functions are updated in a transparent contract.
17     ///  The message string should give a short description of the change and why
18     ///  the change was made.
19     event CommitMessage(string message);
20 
21     /// @dev This emits for each function that is updated in a transparent contract.
22     ///  functionId is the bytes4 of the keccak256 of the function signature.
23     ///  oldDelegate is the delegate contract address of the old delegate contract if
24     ///  the function is being replaced or removed.
25     ///  oldDelegate is the zero value address(0) if a function is being added for the
26     ///  first time.
27     ///  newDelegate is the delegate contract address of the new delegate contract if
28     ///  the function is being added for the first time or if the function is being
29     ///  replaced.
30     ///  newDelegate is the zero value address(0) if the function is being removed.
31     event FunctionUpdate(bytes4 indexed functionId, address indexed oldDelegate, address indexed newDelegate, string functionSignature);
32 
33     /// @notice Updates functions in a transparent contract.
34     /// @dev If the value of _delegate is zero then the functions specified
35     ///  in _functionSignatures are removed.
36     ///  If the value of _delegate is a delegate contract address then the functions
37     ///  specified in _functionSignatures will be delegated to that address.
38     /// @param _delegate The address of a delegate contract to delegate to or zero
39     ///        to remove functions.
40     /// @param _functionSignatures A list of function signatures listed one after the other
41     /// @param _commitMessage A short description of the change and why it is made
42     ///        This message is passed to the CommitMessage event.
43     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) external;
44 }
45 
46 // File: contracts/ProxyBaseStorage.sol
47 
48 
49 
50 pragma solidity ^0.8.14;
51 
52 contract ProxyBaseStorage {
53 
54     //////////////////////////////////////////// VARS /////////////////////////////////////////////
55 
56     // maps functions to the delegate contracts that execute the functions.
57     // funcId => delegate contract
58     mapping(bytes4 => address) public delegates;
59 
60     // array of function signatures supported by the contract.
61     bytes[] public funcSignatures;
62 
63     // maps each function signature to its position in the funcSignatures array.
64     // signature => index+1
65     mapping(bytes => uint256) internal funcSignatureToIndex;
66 
67     // proxy address of itself, can be used for cross-delegate calls but also safety checking.
68     address proxy;
69 
70     ///////////////////////////////////////////////////////////////////////////////////////////////
71 
72 }
73 
74 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Contract module that helps prevent reentrant calls to a function.
83  *
84  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
85  * available, which can be applied to functions to make sure there are no nested
86  * (reentrant) calls to them.
87  *
88  * Note that because there is a single `nonReentrant` guard, functions marked as
89  * `nonReentrant` may not call one another. This can be worked around by making
90  * those functions `private`, and then adding `external` `nonReentrant` entry
91  * points to them.
92  *
93  * TIP: If you would like to learn more about reentrancy and alternative ways
94  * to protect against it, check out our blog post
95  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
96  */
97 abstract contract ReentrancyGuard {
98     // Booleans are more expensive than uint256 or any type that takes up a full
99     // word because each write operation emits an extra SLOAD to first read the
100     // slot's contents, replace the bits taken up by the boolean, and then write
101     // back. This is the compiler's defense against contract upgrades and
102     // pointer aliasing, and it cannot be disabled.
103 
104     // The values being non-zero value makes deployment a bit more expensive,
105     // but in exchange the refund on every call to nonReentrant will be lower in
106     // amount. Since refunds are capped to a percentage of the total
107     // transaction's gas, it is best to keep them low in cases like this one, to
108     // increase the likelihood of the full refund coming into effect.
109     uint256 private constant _NOT_ENTERED = 1;
110     uint256 private constant _ENTERED = 2;
111 
112     uint256 private _status;
113 
114     constructor() {
115         _status = _NOT_ENTERED;
116     }
117 
118     /**
119      * @dev Prevents a contract from calling itself, directly or indirectly.
120      * Calling a `nonReentrant` function from another `nonReentrant`
121      * function is not supported. It is possible to prevent this from happening
122      * by making the `nonReentrant` function external, and making it call a
123      * `private` function that does the actual work.
124      */
125     modifier nonReentrant() {
126         // On the first call to nonReentrant, _notEntered will be true
127         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
128 
129         // Any calls to nonReentrant after this point will fail
130         _status = _ENTERED;
131 
132         _;
133 
134         // By storing the original value once again, a refund is triggered (see
135         // https://eips.ethereum.org/EIPS/eip-2200)
136         _status = _NOT_ENTERED;
137     }
138 }
139 
140 // File: @openzeppelin/contracts/utils/Context.sol
141 
142 
143 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev Provides information about the current execution context, including the
149  * sender of the transaction and its data. While these are generally available
150  * via msg.sender and msg.data, they should not be accessed in such a direct
151  * manner, since when dealing with meta-transactions the account sending and
152  * paying for execution may not be the actual sender (as far as an application
153  * is concerned).
154  *
155  * This contract is only required for intermediate, library-like contracts.
156  */
157 abstract contract Context {
158     function _msgSender() internal view virtual returns (address) {
159         return msg.sender;
160     }
161 
162     function _msgData() internal view virtual returns (bytes calldata) {
163         return msg.data;
164     }
165 }
166 
167 // File: @openzeppelin/contracts/access/Ownable.sol
168 
169 
170 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * By default, the owner account will be the one that deploys the contract. This
180  * can later be changed with {transferOwnership}.
181  *
182  * This module is used through inheritance. It will make available the modifier
183  * `onlyOwner`, which can be applied to your functions to restrict their use to
184  * the owner.
185  */
186 abstract contract Ownable is Context {
187     address private _owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     /**
192      * @dev Initializes the contract setting the deployer as the initial owner.
193      */
194     constructor() {
195         _transferOwnership(_msgSender());
196     }
197 
198     /**
199      * @dev Throws if called by any account other than the owner.
200      */
201     modifier onlyOwner() {
202         _checkOwner();
203         _;
204     }
205 
206     /**
207      * @dev Returns the address of the current owner.
208      */
209     function owner() public view virtual returns (address) {
210         return _owner;
211     }
212 
213     /**
214      * @dev Throws if the sender is not the owner.
215      */
216     function _checkOwner() internal view virtual {
217         require(owner() == _msgSender(), "Ownable: caller is not the owner");
218     }
219 
220     /**
221      * @dev Leaves the contract without owner. It will not be possible to call
222      * `onlyOwner` functions anymore. Can only be called by the current owner.
223      *
224      * NOTE: Renouncing ownership will leave the contract without an owner,
225      * thereby removing any functionality that is only available to the owner.
226      */
227     function renounceOwnership() public virtual onlyOwner {
228         _transferOwnership(address(0));
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Can only be called by the current owner.
234      */
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(newOwner != address(0), "Ownable: new owner is the zero address");
237         _transferOwnership(newOwner);
238     }
239 
240     /**
241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
242      * Internal function without access restriction.
243      */
244     function _transferOwnership(address newOwner) internal virtual {
245         address oldOwner = _owner;
246         _owner = newOwner;
247         emit OwnershipTransferred(oldOwner, newOwner);
248     }
249 }
250 
251 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
252 
253 
254 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 // CAUTION
259 // This version of SafeMath should only be used with Solidity 0.8 or later,
260 // because it relies on the compiler's built in overflow checks.
261 
262 /**
263  * @dev Wrappers over Solidity's arithmetic operations.
264  *
265  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
266  * now has built in overflow checking.
267  */
268 library SafeMath {
269     /**
270      * @dev Returns the addition of two unsigned integers, with an overflow flag.
271      *
272      * _Available since v3.4._
273      */
274     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
275         unchecked {
276             uint256 c = a + b;
277             if (c < a) return (false, 0);
278             return (true, c);
279         }
280     }
281 
282     /**
283      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
284      *
285      * _Available since v3.4._
286      */
287     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
288         unchecked {
289             if (b > a) return (false, 0);
290             return (true, a - b);
291         }
292     }
293 
294     /**
295      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
296      *
297      * _Available since v3.4._
298      */
299     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         unchecked {
301             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
302             // benefit is lost if 'b' is also tested.
303             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
304             if (a == 0) return (true, 0);
305             uint256 c = a * b;
306             if (c / a != b) return (false, 0);
307             return (true, c);
308         }
309     }
310 
311     /**
312      * @dev Returns the division of two unsigned integers, with a division by zero flag.
313      *
314      * _Available since v3.4._
315      */
316     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
317         unchecked {
318             if (b == 0) return (false, 0);
319             return (true, a / b);
320         }
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
325      *
326      * _Available since v3.4._
327      */
328     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
329         unchecked {
330             if (b == 0) return (false, 0);
331             return (true, a % b);
332         }
333     }
334 
335     /**
336      * @dev Returns the addition of two unsigned integers, reverting on
337      * overflow.
338      *
339      * Counterpart to Solidity's `+` operator.
340      *
341      * Requirements:
342      *
343      * - Addition cannot overflow.
344      */
345     function add(uint256 a, uint256 b) internal pure returns (uint256) {
346         return a + b;
347     }
348 
349     /**
350      * @dev Returns the subtraction of two unsigned integers, reverting on
351      * overflow (when the result is negative).
352      *
353      * Counterpart to Solidity's `-` operator.
354      *
355      * Requirements:
356      *
357      * - Subtraction cannot overflow.
358      */
359     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
360         return a - b;
361     }
362 
363     /**
364      * @dev Returns the multiplication of two unsigned integers, reverting on
365      * overflow.
366      *
367      * Counterpart to Solidity's `*` operator.
368      *
369      * Requirements:
370      *
371      * - Multiplication cannot overflow.
372      */
373     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
374         return a * b;
375     }
376 
377     /**
378      * @dev Returns the integer division of two unsigned integers, reverting on
379      * division by zero. The result is rounded towards zero.
380      *
381      * Counterpart to Solidity's `/` operator.
382      *
383      * Requirements:
384      *
385      * - The divisor cannot be zero.
386      */
387     function div(uint256 a, uint256 b) internal pure returns (uint256) {
388         return a / b;
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * reverting when dividing by zero.
394      *
395      * Counterpart to Solidity's `%` operator. This function uses a `revert`
396      * opcode (which leaves remaining gas untouched) while Solidity uses an
397      * invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      *
401      * - The divisor cannot be zero.
402      */
403     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
404         return a % b;
405     }
406 
407     /**
408      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
409      * overflow (when the result is negative).
410      *
411      * CAUTION: This function is deprecated because it requires allocating memory for the error
412      * message unnecessarily. For custom revert reasons use {trySub}.
413      *
414      * Counterpart to Solidity's `-` operator.
415      *
416      * Requirements:
417      *
418      * - Subtraction cannot overflow.
419      */
420     function sub(
421         uint256 a,
422         uint256 b,
423         string memory errorMessage
424     ) internal pure returns (uint256) {
425         unchecked {
426             require(b <= a, errorMessage);
427             return a - b;
428         }
429     }
430 
431     /**
432      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
433      * division by zero. The result is rounded towards zero.
434      *
435      * Counterpart to Solidity's `/` operator. Note: this function uses a
436      * `revert` opcode (which leaves remaining gas untouched) while Solidity
437      * uses an invalid opcode to revert (consuming all remaining gas).
438      *
439      * Requirements:
440      *
441      * - The divisor cannot be zero.
442      */
443     function div(
444         uint256 a,
445         uint256 b,
446         string memory errorMessage
447     ) internal pure returns (uint256) {
448         unchecked {
449             require(b > 0, errorMessage);
450             return a / b;
451         }
452     }
453 
454     /**
455      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
456      * reverting with custom message when dividing by zero.
457      *
458      * CAUTION: This function is deprecated because it requires allocating memory for the error
459      * message unnecessarily. For custom revert reasons use {tryMod}.
460      *
461      * Counterpart to Solidity's `%` operator. This function uses a `revert`
462      * opcode (which leaves remaining gas untouched) while Solidity uses an
463      * invalid opcode to revert (consuming all remaining gas).
464      *
465      * Requirements:
466      *
467      * - The divisor cannot be zero.
468      */
469     function mod(
470         uint256 a,
471         uint256 b,
472         string memory errorMessage
473     ) internal pure returns (uint256) {
474         unchecked {
475             require(b > 0, errorMessage);
476             return a % b;
477         }
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
482 
483 
484 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 /**
489  * @title ERC721 token receiver interface
490  * @dev Interface for any contract that wants to support safeTransfers
491  * from ERC721 asset contracts.
492  */
493 interface IERC721Receiver {
494     /**
495      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
496      * by `operator` from `from`, this function is called.
497      *
498      * It must return its Solidity selector to confirm the token transfer.
499      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
500      *
501      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
502      */
503     function onERC721Received(
504         address operator,
505         address from,
506         uint256 tokenId,
507         bytes calldata data
508     ) external returns (bytes4);
509 }
510 
511 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 /**
519  * @dev Interface of the ERC165 standard, as defined in the
520  * https://eips.ethereum.org/EIPS/eip-165[EIP].
521  *
522  * Implementers can declare support of contract interfaces, which can then be
523  * queried by others ({ERC165Checker}).
524  *
525  * For an implementation, see {ERC165}.
526  */
527 interface IERC165 {
528     /**
529      * @dev Returns true if this contract implements the interface defined by
530      * `interfaceId`. See the corresponding
531      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
532      * to learn more about how these ids are created.
533      *
534      * This function call must use less than 30 000 gas.
535      */
536     function supportsInterface(bytes4 interfaceId) external view returns (bool);
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
540 
541 
542 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev Required interface of an ERC721 compliant contract.
548  */
549 interface IERC721 is IERC165 {
550     /**
551      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
552      */
553     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
554 
555     /**
556      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
557      */
558     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
562      */
563     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
564 
565     /**
566      * @dev Returns the number of tokens in ``owner``'s account.
567      */
568     function balanceOf(address owner) external view returns (uint256 balance);
569 
570     /**
571      * @dev Returns the owner of the `tokenId` token.
572      *
573      * Requirements:
574      *
575      * - `tokenId` must exist.
576      */
577     function ownerOf(uint256 tokenId) external view returns (address owner);
578 
579     /**
580      * @dev Safely transfers `tokenId` token from `from` to `to`.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must exist and be owned by `from`.
587      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
588      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
589      *
590      * Emits a {Transfer} event.
591      */
592     function safeTransferFrom(
593         address from,
594         address to,
595         uint256 tokenId,
596         bytes calldata data
597     ) external;
598 
599     /**
600      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
601      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must exist and be owned by `from`.
608      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
609      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
610      *
611      * Emits a {Transfer} event.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external;
618 
619     /**
620      * @dev Transfers `tokenId` token from `from` to `to`.
621      *
622      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must be owned by `from`.
629      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
630      *
631      * Emits a {Transfer} event.
632      */
633     function transferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
641      * The approval is cleared when the token is transferred.
642      *
643      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
644      *
645      * Requirements:
646      *
647      * - The caller must own the token or be an approved operator.
648      * - `tokenId` must exist.
649      *
650      * Emits an {Approval} event.
651      */
652     function approve(address to, uint256 tokenId) external;
653 
654     /**
655      * @dev Approve or remove `operator` as an operator for the caller.
656      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
657      *
658      * Requirements:
659      *
660      * - The `operator` cannot be the caller.
661      *
662      * Emits an {ApprovalForAll} event.
663      */
664     function setApprovalForAll(address operator, bool _approved) external;
665 
666     /**
667      * @dev Returns the account approved for `tokenId` token.
668      *
669      * Requirements:
670      *
671      * - `tokenId` must exist.
672      */
673     function getApproved(uint256 tokenId) external view returns (address operator);
674 
675     /**
676      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
677      *
678      * See {setApprovalForAll}
679      */
680     function isApprovedForAll(address owner, address operator) external view returns (bool);
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
692  * @dev See https://eips.ethereum.org/EIPS/eip-721
693  */
694 interface IERC721Metadata is IERC721 {
695     /**
696      * @dev Returns the token collection name.
697      */
698     function name() external view returns (string memory);
699 
700     /**
701      * @dev Returns the token collection symbol.
702      */
703     function symbol() external view returns (string memory);
704 
705     /**
706      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
707      */
708     function tokenURI(uint256 tokenId) external view returns (string memory);
709 }
710 
711 // File: @openzeppelin/contracts/utils/Address.sol
712 
713 
714 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
715 
716 pragma solidity ^0.8.1;
717 
718 /**
719  * @dev Collection of functions related to the address type
720  */
721 library Address {
722     /**
723      * @dev Returns true if `account` is a contract.
724      *
725      * [IMPORTANT]
726      * ====
727      * It is unsafe to assume that an address for which this function returns
728      * false is an externally-owned account (EOA) and not a contract.
729      *
730      * Among others, `isContract` will return false for the following
731      * types of addresses:
732      *
733      *  - an externally-owned account
734      *  - a contract in construction
735      *  - an address where a contract will be created
736      *  - an address where a contract lived, but was destroyed
737      * ====
738      *
739      * [IMPORTANT]
740      * ====
741      * You shouldn't rely on `isContract` to protect against flash loan attacks!
742      *
743      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
744      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
745      * constructor.
746      * ====
747      */
748     function isContract(address account) internal view returns (bool) {
749         // This method relies on extcodesize/address.code.length, which returns 0
750         // for contracts in construction, since the code is only stored at the end
751         // of the constructor execution.
752 
753         return account.code.length > 0;
754     }
755 
756     /**
757      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
758      * `recipient`, forwarding all available gas and reverting on errors.
759      *
760      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
761      * of certain opcodes, possibly making contracts go over the 2300 gas limit
762      * imposed by `transfer`, making them unable to receive funds via
763      * `transfer`. {sendValue} removes this limitation.
764      *
765      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
766      *
767      * IMPORTANT: because control is transferred to `recipient`, care must be
768      * taken to not create reentrancy vulnerabilities. Consider using
769      * {ReentrancyGuard} or the
770      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
771      */
772     function sendValue(address payable recipient, uint256 amount) internal {
773         require(address(this).balance >= amount, "Address: insufficient balance");
774 
775         (bool success, ) = recipient.call{value: amount}("");
776         require(success, "Address: unable to send value, recipient may have reverted");
777     }
778 
779     /**
780      * @dev Performs a Solidity function call using a low level `call`. A
781      * plain `call` is an unsafe replacement for a function call: use this
782      * function instead.
783      *
784      * If `target` reverts with a revert reason, it is bubbled up by this
785      * function (like regular Solidity function calls).
786      *
787      * Returns the raw returned data. To convert to the expected return value,
788      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
789      *
790      * Requirements:
791      *
792      * - `target` must be a contract.
793      * - calling `target` with `data` must not revert.
794      *
795      * _Available since v3.1._
796      */
797     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
798         return functionCall(target, data, "Address: low-level call failed");
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
803      * `errorMessage` as a fallback revert reason when `target` reverts.
804      *
805      * _Available since v3.1._
806      */
807     function functionCall(
808         address target,
809         bytes memory data,
810         string memory errorMessage
811     ) internal returns (bytes memory) {
812         return functionCallWithValue(target, data, 0, errorMessage);
813     }
814 
815     /**
816      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
817      * but also transferring `value` wei to `target`.
818      *
819      * Requirements:
820      *
821      * - the calling contract must have an ETH balance of at least `value`.
822      * - the called Solidity function must be `payable`.
823      *
824      * _Available since v3.1._
825      */
826     function functionCallWithValue(
827         address target,
828         bytes memory data,
829         uint256 value
830     ) internal returns (bytes memory) {
831         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
832     }
833 
834     /**
835      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
836      * with `errorMessage` as a fallback revert reason when `target` reverts.
837      *
838      * _Available since v3.1._
839      */
840     function functionCallWithValue(
841         address target,
842         bytes memory data,
843         uint256 value,
844         string memory errorMessage
845     ) internal returns (bytes memory) {
846         require(address(this).balance >= value, "Address: insufficient balance for call");
847         require(isContract(target), "Address: call to non-contract");
848 
849         (bool success, bytes memory returndata) = target.call{value: value}(data);
850         return verifyCallResult(success, returndata, errorMessage);
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
855      * but performing a static call.
856      *
857      * _Available since v3.3._
858      */
859     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
860         return functionStaticCall(target, data, "Address: low-level static call failed");
861     }
862 
863     /**
864      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
865      * but performing a static call.
866      *
867      * _Available since v3.3._
868      */
869     function functionStaticCall(
870         address target,
871         bytes memory data,
872         string memory errorMessage
873     ) internal view returns (bytes memory) {
874         require(isContract(target), "Address: static call to non-contract");
875 
876         (bool success, bytes memory returndata) = target.staticcall(data);
877         return verifyCallResult(success, returndata, errorMessage);
878     }
879 
880     /**
881      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
882      * but performing a delegate call.
883      *
884      * _Available since v3.4._
885      */
886     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
887         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
888     }
889 
890     /**
891      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
892      * but performing a delegate call.
893      *
894      * _Available since v3.4._
895      */
896     function functionDelegateCall(
897         address target,
898         bytes memory data,
899         string memory errorMessage
900     ) internal returns (bytes memory) {
901         require(isContract(target), "Address: delegate call to non-contract");
902 
903         (bool success, bytes memory returndata) = target.delegatecall(data);
904         return verifyCallResult(success, returndata, errorMessage);
905     }
906 
907     /**
908      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
909      * revert reason using the provided one.
910      *
911      * _Available since v4.3._
912      */
913     function verifyCallResult(
914         bool success,
915         bytes memory returndata,
916         string memory errorMessage
917     ) internal pure returns (bytes memory) {
918         if (success) {
919             return returndata;
920         } else {
921             // Look for revert reason and bubble it up if present
922             if (returndata.length > 0) {
923                 // The easiest way to bubble the revert reason is using memory via assembly
924                 /// @solidity memory-safe-assembly
925                 assembly {
926                     let returndata_size := mload(returndata)
927                     revert(add(32, returndata), returndata_size)
928                 }
929             } else {
930                 revert(errorMessage);
931             }
932         }
933     }
934 }
935 
936 // File: @openzeppelin/contracts/utils/Strings.sol
937 
938 
939 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
940 
941 pragma solidity ^0.8.0;
942 
943 /**
944  * @dev String operations.
945  */
946 library Strings {
947     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
948     uint8 private constant _ADDRESS_LENGTH = 20;
949 
950     /**
951      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
952      */
953     function toString(uint256 value) internal pure returns (string memory) {
954         // Inspired by OraclizeAPI's implementation - MIT licence
955         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
956 
957         if (value == 0) {
958             return "0";
959         }
960         uint256 temp = value;
961         uint256 digits;
962         while (temp != 0) {
963             digits++;
964             temp /= 10;
965         }
966         bytes memory buffer = new bytes(digits);
967         while (value != 0) {
968             digits -= 1;
969             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
970             value /= 10;
971         }
972         return string(buffer);
973     }
974 
975     /**
976      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
977      */
978     function toHexString(uint256 value) internal pure returns (string memory) {
979         if (value == 0) {
980             return "0x00";
981         }
982         uint256 temp = value;
983         uint256 length = 0;
984         while (temp != 0) {
985             length++;
986             temp >>= 8;
987         }
988         return toHexString(value, length);
989     }
990 
991     /**
992      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
993      */
994     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
995         bytes memory buffer = new bytes(2 * length + 2);
996         buffer[0] = "0";
997         buffer[1] = "x";
998         for (uint256 i = 2 * length + 1; i > 1; --i) {
999             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1000             value >>= 4;
1001         }
1002         require(value == 0, "Strings: hex length insufficient");
1003         return string(buffer);
1004     }
1005 
1006     /**
1007      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1008      */
1009     function toHexString(address addr) internal pure returns (string memory) {
1010         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1011     }
1012 }
1013 
1014 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1015 
1016 
1017 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 /**
1022  * @dev Implementation of the {IERC165} interface.
1023  *
1024  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1025  * for the additional interface id that will be supported. For example:
1026  *
1027  * ```solidity
1028  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1029  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1030  * }
1031  * ```
1032  *
1033  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1034  */
1035 abstract contract ERC165 is IERC165 {
1036     /**
1037      * @dev See {IERC165-supportsInterface}.
1038      */
1039     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1040         return interfaceId == type(IERC165).interfaceId;
1041     }
1042 }
1043 
1044 // File: contracts/ERC721A.sol
1045 
1046 
1047 
1048 pragma solidity ^0.8.14;
1049 
1050 
1051 
1052 
1053 
1054 
1055 error ApprovalCallerNotOwnerNorApproved();
1056 error ApprovalQueryForNonexistentToken();
1057 error ApproveToCaller();
1058 error ApprovalToCurrentOwner();
1059 error BalanceQueryForZeroAddress();
1060 error MintToZeroAddress();
1061 error MintZeroQuantity();
1062 error OwnerQueryForNonexistentToken();
1063 error TransferCallerNotOwnerNorApproved();
1064 error TransferFromIncorrectOwner();
1065 error TransferToNonERC721ReceiverImplementer();
1066 error TransferToZeroAddress();
1067 error URIQueryForNonexistentToken();
1068 
1069 /**
1070  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1071  * the Metadata extension. Built to optimize for lower gas during batch mints.
1072  *
1073  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1074  *
1075  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1076  *
1077  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1078  */
1079 abstract contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1080     using Address for address;
1081     using Strings for uint256;
1082 
1083     // Compiler will pack this into a single 256bit word.
1084     struct TokenOwnership {
1085         // The address of the owner.
1086         address addr;
1087         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1088         uint64 startTimestamp;
1089         // Whether the token has been burned.
1090         bool burned;
1091     }
1092 
1093     // Compiler will pack this into a single 256bit word.
1094     struct AddressData {
1095         // Realistically, 2**64-1 is more than enough.
1096         uint64 balance;
1097         // Keeps track of mint count with minimal overhead for tokenomics.
1098         uint64 numberMinted;
1099         // Keeps track of burn count with minimal overhead for tokenomics.
1100         uint64 numberBurned;
1101         // For miscellaneous variable(s) pertaining to the address
1102         // (e.g. number of whitelist mint slots used).
1103         // If there are multiple variables, please pack them into a uint64.
1104         uint64 aux;
1105     }
1106 
1107     // The tokenId of the next token to be minted.
1108     uint256 internal _currentIndex;
1109 
1110     // The number of tokens burned.
1111     uint256 internal _burnCounter;
1112 
1113     // Token name
1114     string private _name;
1115 
1116     // Token symbol
1117     string private _symbol;
1118 
1119     // Mapping from token ID to ownership details
1120     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1121     mapping(uint256 => TokenOwnership) internal _ownerships;
1122 
1123     // Mapping owner address to address data
1124     mapping(address => AddressData) internal _addressData;
1125 
1126     // Mapping from token ID to approved address
1127     mapping(uint256 => address) internal _tokenApprovals;
1128 
1129     // Mapping from owner to operator approvals
1130     mapping(address => mapping(address => bool)) internal _operatorApprovals;
1131 
1132     mapping(uint256 => uint256) public _nftLockup;
1133 
1134     mapping(address => bool) public isTransferAllowed;
1135 
1136     constructor(string memory name_, string memory symbol_) {
1137         _name = name_;
1138         _symbol = symbol_;
1139         _currentIndex = _startTokenId();
1140     }
1141 
1142     modifier  onlyTransferAllowed(address from) {
1143         require(isTransferAllowed[from],"ERC721: transfer not allowed");
1144         _;
1145     }
1146 
1147     /**
1148      * To change the starting tokenId, please override this function.
1149      */
1150     function _startTokenId() internal view virtual returns (uint256) {
1151         return 1;
1152     }
1153 
1154     /**
1155      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1156      */
1157     function totalSupply() public view returns (uint256) {
1158         // Counter underflow is impossible as _burnCounter cannot be incremented
1159         // more than _currentIndex - _startTokenId() times
1160         unchecked {
1161             return _currentIndex - _burnCounter - _startTokenId();
1162         }
1163     }
1164 
1165     /**
1166      * Returns the total amount of tokens minted in the contract.
1167      */
1168     function _totalMinted() internal view returns (uint256) {
1169         // Counter underflow is impossible as _currentIndex does not decrement,
1170         // and it is initialized to _startTokenId()
1171         unchecked {
1172             return _currentIndex - _startTokenId();
1173         }
1174     }
1175 
1176     /**
1177      * @dev See {IERC165-supportsInterface}.
1178      */
1179     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1180         return
1181             interfaceId == type(IERC721).interfaceId ||
1182             interfaceId == type(IERC721Metadata).interfaceId ||
1183             super.supportsInterface(interfaceId);
1184     }
1185     
1186 
1187     /**
1188      * @dev See {IERC721-balanceOf}.
1189      */
1190     function balanceOf(address owner) public view override returns (uint256) {
1191         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1192         return uint256(_addressData[owner].balance);
1193     }
1194 
1195     /**
1196      * Returns the number of tokens minted by `owner`.
1197      */
1198     function _numberMinted(address owner) internal view returns (uint256) {
1199         return uint256(_addressData[owner].numberMinted);
1200     }
1201 
1202     /**
1203      * Returns the number of tokens burned by or on behalf of `owner`.
1204      */
1205     function _numberBurned(address owner) internal view returns (uint256) {
1206         return uint256(_addressData[owner].numberBurned);
1207     }
1208 
1209     /**
1210      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1211      */
1212     function _getAux(address owner) internal view returns (uint64) {
1213         return _addressData[owner].aux;
1214     }
1215 
1216     /**
1217      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1218      * If there are multiple variables, please pack them into a uint64.
1219      */
1220     function _setAux(address owner, uint64 aux) internal {
1221         _addressData[owner].aux = aux;
1222     }
1223 
1224     /**
1225      * Gas spent here starts off proportional to the maximum mint batch size.
1226      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1227      */
1228     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1229         uint256 curr = tokenId;
1230 
1231         unchecked {
1232             if (_startTokenId() <= curr && curr < _currentIndex) {
1233                 TokenOwnership memory ownership = _ownerships[curr];
1234                 if (!ownership.burned) {
1235                     if (ownership.addr != address(0)) {
1236                         return ownership;
1237                     }
1238                     // Invariant:
1239                     // There will always be an ownership that has an address and is not burned
1240                     // before an ownership that does not have an address and is not burned.
1241                     // Hence, curr will not underflow.
1242                     while (true) {
1243                         curr--;
1244                         ownership = _ownerships[curr];
1245                         if (ownership.addr != address(0)) {
1246                             return ownership;
1247                         }
1248                     }
1249                 }
1250             }
1251         }
1252         revert OwnerQueryForNonexistentToken();
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-ownerOf}.
1257      */
1258     function ownerOf(uint256 tokenId) public view override returns (address) {
1259         return _ownershipOf(tokenId).addr;
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Metadata-name}.
1264      */
1265     function name() public view virtual override returns (string memory) {
1266         return _name;
1267     }
1268 
1269     /**
1270      * @dev See {IERC721Metadata-symbol}.
1271      */
1272     function symbol() public view virtual override returns (string memory) {
1273         return _symbol;
1274     }
1275 
1276     /**
1277      * @dev See {IERC721Metadata-tokenURI}.
1278      */
1279     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1280         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1281 
1282         string memory baseURI = _baseURI();
1283         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1284     }
1285 
1286     /**
1287      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1288      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1289      * by default, can be overriden in child contracts.
1290      */
1291     function _baseURI() internal view virtual returns (string memory) {
1292         return '';
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-approve}.
1297      */
1298     function approve(address to, uint256 tokenId) onlyTransferAllowed(to) public override {
1299         address owner = ERC721A.ownerOf(tokenId);
1300         if (to == owner) revert ApprovalToCurrentOwner();
1301 
1302         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1303             revert ApprovalCallerNotOwnerNorApproved();
1304         }
1305 
1306         _approve(to, tokenId, owner);
1307     }
1308 
1309     /**
1310      * @dev See {IERC721-getApproved}.
1311      */
1312     function getApproved(uint256 tokenId) public view override returns (address) {
1313         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1314 
1315         return _tokenApprovals[tokenId];
1316     }
1317 
1318     /**
1319      * @dev See {IERC721-setApprovalForAll}.
1320      */
1321     function setApprovalForAll(address operator, bool approved) onlyTransferAllowed(operator) public virtual override {
1322         if (operator == _msgSender()) revert ApproveToCaller();
1323 
1324         _operatorApprovals[_msgSender()][operator] = approved;
1325         emit ApprovalForAll(_msgSender(), operator, approved);
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-isApprovedForAll}.
1330      */
1331     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1332         return _operatorApprovals[owner][operator];
1333     }
1334 
1335 
1336     /**
1337      * @dev Returns whether `tokenId` exists.
1338      *
1339      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1340      *
1341      * Tokens start existing when they are minted (`_mint`),
1342      */
1343     function _exists(uint256 tokenId) internal view returns (bool) {
1344         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1345     }
1346 
1347     /**
1348      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1349      */
1350     function _safeMint(address to, uint256 quantity) internal returns(uint256, uint256) {
1351        return _safeMint(to, quantity, '');
1352     }
1353 
1354     /**
1355      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1356      *
1357      * Requirements:
1358      *
1359      * - If `to` refers to a smart contract, it must implement 
1360      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1361      * - `quantity` must be greater than 0.
1362      *
1363      * Emits a {Transfer} event.
1364      */
1365     function _safeMint(
1366         address to,
1367         uint256 quantity,
1368         bytes memory _data
1369     ) internal returns(uint256, uint256) {
1370         uint256 startTokenId = _currentIndex;
1371         if (to == address(0)) revert MintToZeroAddress();
1372         if (quantity == 0) revert MintZeroQuantity();
1373 
1374         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1375 
1376         // Overflows are incredibly unrealistic.
1377         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1378         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1379         unchecked {
1380             _addressData[to].balance += uint64(quantity);
1381             _addressData[to].numberMinted += uint64(quantity);
1382 
1383             _ownerships[startTokenId].addr = to;
1384             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1385 
1386             uint256 updatedIndex = startTokenId;
1387             uint256 end = updatedIndex + quantity;
1388 
1389             if (to.isContract()) {
1390                 do {
1391                     emit Transfer(address(0), to, updatedIndex);
1392                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1393                         revert TransferToNonERC721ReceiverImplementer();
1394                     }
1395                 } while (updatedIndex != end);
1396                 // Reentrancy protection
1397                 if (_currentIndex != startTokenId) revert();
1398             } else {
1399                 do {
1400                 // emit MintWithTokenURI(address(this), updatedIndex, to, "");
1401 
1402                     emit Transfer(address(0), to, updatedIndex++);
1403                 } while (updatedIndex != end);
1404             }
1405             _currentIndex = updatedIndex;
1406         }
1407         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1408         return(startTokenId,_currentIndex-1);
1409     }
1410 
1411     
1412 
1413     /**
1414      * @dev Mints `quantity` tokens and transfers them to `to`.
1415      *
1416      * Requirements:
1417      *
1418      * - `to` cannot be the zero address.
1419      * - `quantity` must be greater than 0.
1420      *
1421      * Emits a {Transfer} event.
1422      */
1423     function _mint(address to, uint256 quantity) internal {
1424         uint256 startTokenId = _currentIndex;
1425         if (to == address(0)) revert MintToZeroAddress();
1426         if (quantity == 0) revert MintZeroQuantity();
1427 
1428         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1429 
1430         // Overflows are incredibly unrealistic.
1431         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1432         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1433         unchecked {
1434             _addressData[to].balance += uint64(quantity);
1435             _addressData[to].numberMinted += uint64(quantity);
1436 
1437             _ownerships[startTokenId].addr = to;
1438             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1439 
1440             uint256 updatedIndex = startTokenId;
1441             uint256 end = updatedIndex + quantity;
1442 
1443             do {
1444                 // emit MintWithTokenURI(address(this), updatedIndex, to, "");
1445                 emit Transfer(address(0), to, updatedIndex++);
1446                 
1447             } while (updatedIndex != end);
1448 
1449             _currentIndex = updatedIndex;
1450         }
1451         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1452     }
1453 
1454      //erc721A transfer functions
1455 
1456     function transferFrom(
1457         address from,
1458         address to,
1459         uint256 tokenId
1460     )  public virtual  {
1461          require(_nftLockup[tokenId] <= block.timestamp || _nftLockup[tokenId] == 0 , "XanaLand: NFT lockup not expired yet");
1462         _transfer(from, to, tokenId);
1463     }
1464 
1465     function safeTransferFrom(
1466         address from,
1467         address to,
1468         uint256 tokenId
1469     ) public virtual  {
1470          require(_nftLockup[tokenId] <= block.timestamp || _nftLockup[tokenId] == 0 , "XanaLand: NFT lockup not expired yet");
1471         safeTransferFrom(from, to, tokenId, '');
1472     }
1473 
1474     function safeTransferFrom(
1475         address from,
1476         address to,
1477         uint256 tokenId,
1478         bytes memory _data
1479     )  public virtual  {
1480          require(_nftLockup[tokenId] <= block.timestamp || _nftLockup[tokenId] == 0 , "XanaLand: NFT lockup not expired yet");
1481         _transfer(from, to, tokenId);
1482         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1483             revert TransferToNonERC721ReceiverImplementer();
1484         }
1485     }
1486 
1487     /**
1488      * @dev Transfers `tokenId` from `from` to `to`.
1489      *
1490      * Requirements:
1491      *
1492      * - `to` cannot be the zero address.
1493      * - `tokenId` token must be owned by `from`.
1494      *
1495      * Emits a {Transfer} event.
1496      */
1497     function _transfer(
1498         address from,
1499         address to,
1500         uint256 tokenId
1501     ) onlyTransferAllowed(msg.sender) internal {
1502         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1503 
1504         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1505 
1506         bool isApprovedOrOwner = (_msgSender() == from ||
1507             isApprovedForAll(from, _msgSender()) ||
1508             getApproved(tokenId) == _msgSender());
1509 
1510         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1511         if (to == address(0)) revert TransferToZeroAddress();
1512 
1513         _beforeTokenTransfers(from, to, tokenId, 1);
1514 
1515         // Clear approvals from the previous owner
1516         _approve(address(0), tokenId, from);
1517 
1518         // Underflow of the sender's balance is impossible because we check for
1519         // ownership above and the recipient's balance can't realistically overflow.
1520         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1521         unchecked {
1522             _addressData[from].balance -= 1;
1523             _addressData[to].balance += 1;
1524 
1525             TokenOwnership storage currSlot = _ownerships[tokenId];
1526             currSlot.addr = to;
1527             currSlot.startTimestamp = uint64(block.timestamp);
1528 
1529             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1530             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1531             uint256 nextTokenId = tokenId + 1;
1532             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1533             if (nextSlot.addr == address(0)) {
1534                 // This will suffice for checking _exists(nextTokenId),
1535                 // as a burned slot cannot contain the zero address.
1536                 if (nextTokenId != _currentIndex) {
1537                     nextSlot.addr = from;
1538                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1539                 }
1540             }
1541         }
1542 
1543         emit Transfer(from, to, tokenId);
1544         _afterTokenTransfers(from, to, tokenId, 1);
1545     }
1546 
1547     /**
1548      * @dev Transfers `tokenId` from `from` to `to`.
1549      *
1550      * Requirements:
1551      *
1552      * - `to` cannot be the zero address.
1553      * - `tokenId` token must be owned by `from`.
1554      *
1555      * Emits a {Transfer} event.
1556      */
1557     function _transferAdmin(
1558         address from,
1559         address to,
1560         uint256 tokenId
1561     ) internal {
1562         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1563 
1564 
1565         if (to == address(0)) revert TransferToZeroAddress();
1566 
1567         _beforeTokenTransfers(from, to, tokenId, 1);
1568 
1569         // Clear approvals from the previous owner
1570         _approve(address(0), tokenId, from);
1571 
1572         // Underflow of the sender's balance is impossible because we check for
1573         // ownership above and the recipient's balance can't realistically overflow.
1574         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1575         unchecked {
1576             // _addressData[from].balance -= 1;
1577             _addressData[to].balance += 1;
1578 
1579             TokenOwnership storage currSlot = _ownerships[tokenId];
1580             currSlot.addr = to;
1581             currSlot.startTimestamp = uint64(block.timestamp);
1582 
1583             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1584             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1585             uint256 nextTokenId = tokenId + 1;
1586             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1587             if (nextSlot.addr == address(0)) {
1588                 // This will suffice for checking _exists(nextTokenId),
1589                 // as a burned slot cannot contain the zero address.
1590                 if (nextTokenId != _currentIndex) {
1591                     nextSlot.addr = from;
1592                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1593                 }
1594             }
1595         }
1596 
1597         emit Transfer(from, to, tokenId);
1598         _afterTokenTransfers(from, to, tokenId, 1);
1599     }
1600 
1601     /**
1602      * @dev Equivalent to `_burn(tokenId, false)`.
1603      */
1604     function _burn(uint256 tokenId) internal virtual {
1605         _burn(tokenId, false);
1606     }
1607 
1608     /**
1609      * @dev Destroys `tokenId`.
1610      * The approval is cleared when the token is burned.
1611      *
1612      * Requirements:
1613      *
1614      * - `tokenId` must exist.
1615      *
1616      * Emits a {Transfer} event.
1617      */
1618     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1619         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1620 
1621         address from = prevOwnership.addr;
1622 
1623         if (approvalCheck) {
1624             bool isApprovedOrOwner = (_msgSender() == from ||
1625                 isApprovedForAll(from, _msgSender()) ||
1626                 getApproved(tokenId) == _msgSender());
1627 
1628             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1629         }
1630 
1631         _beforeTokenTransfers(from, address(0), tokenId, 1);
1632 
1633         // Clear approvals from the previous owner
1634         _approve(address(0), tokenId, from);
1635 
1636         // Underflow of the sender's balance is impossible because we check for
1637         // ownership above and the recipient's balance can't realistically overflow.
1638         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1639         unchecked {
1640             AddressData storage addressData = _addressData[from];
1641             addressData.balance -= 1;
1642             addressData.numberBurned += 1;
1643 
1644             // Keep track of who burned the token, and the timestamp of burning.
1645             TokenOwnership storage currSlot = _ownerships[tokenId];
1646             currSlot.addr = from;
1647             currSlot.startTimestamp = uint64(block.timestamp);
1648             currSlot.burned = true;
1649 
1650             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1651             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1652             uint256 nextTokenId = tokenId + 1;
1653             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1654             if (nextSlot.addr == address(0)) {
1655                 // This will suffice for checking _exists(nextTokenId),
1656                 // as a burned slot cannot contain the zero address.
1657                 if (nextTokenId != _currentIndex) {
1658                     nextSlot.addr = from;
1659                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1660                 }
1661             }
1662         }
1663 
1664         emit Transfer(from, address(0), tokenId);
1665         _afterTokenTransfers(from, address(0), tokenId, 1);
1666 
1667         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1668         unchecked {
1669             _burnCounter++;
1670         }
1671     }
1672 
1673     /**
1674      * @dev Approve `to` to operate on `tokenId`
1675      *
1676      * Emits a {Approval} event.
1677      */
1678     function _approve(
1679         address to,
1680         uint256 tokenId,
1681         address owner
1682     ) private {
1683         _tokenApprovals[tokenId] = to;
1684         emit Approval(owner, to, tokenId);
1685     }
1686 
1687     /**
1688      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1689      *
1690      * @param from address representing the previous owner of the given token ID
1691      * @param to target address that will receive the tokens
1692      * @param tokenId uint256 ID of the token to be transferred
1693      * @param _data bytes optional data to send along with the call
1694      * @return bool whether the call correctly returned the expected magic value
1695      */
1696     function _checkContractOnERC721Received(
1697         address from,
1698         address to,
1699         uint256 tokenId,
1700         bytes memory _data
1701     ) internal returns (bool) {
1702         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1703             return retval == IERC721Receiver(to).onERC721Received.selector;
1704         } catch (bytes memory reason) {
1705             if (reason.length == 0) {
1706                 revert TransferToNonERC721ReceiverImplementer();
1707             } else {
1708                 assembly {
1709                     revert(add(32, reason), mload(reason))
1710                 }
1711             }
1712         }
1713     }
1714 
1715     /**
1716      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1717      * And also called before burning one token.
1718      *
1719      * startTokenId - the first token id to be transferred
1720      * quantity - the amount to be transferred
1721      *
1722      * Calling conditions:
1723      *
1724      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1725      * transferred to `to`.
1726      * - When `from` is zero, `tokenId` will be minted for `to`.
1727      * - When `to` is zero, `tokenId` will be burned by `from`.
1728      * - `from` and `to` are never both zero.
1729      */
1730     function _beforeTokenTransfers(
1731         address from,
1732         address to,
1733         uint256 startTokenId,
1734         uint256 quantity
1735     ) internal virtual {}
1736 
1737     /**
1738      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1739      * minting.
1740      * And also called after one token has been burned.
1741      *
1742      * startTokenId - the first token id to be transferred
1743      * quantity - the amount to be transferred
1744      *
1745      * Calling conditions:
1746      *
1747      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1748      * transferred to `to`.
1749      * - When `from` is zero, `tokenId` has been minted for `to`.
1750      * - When `to` is zero, `tokenId` has been burned by `from`.
1751      * - `from` and `to` are never both zero.
1752      */
1753     function _afterTokenTransfers(
1754         address from,
1755         address to,
1756         uint256 startTokenId,
1757         uint256 quantity
1758     ) internal virtual {}
1759      event MintWithTokenURI(address indexed collection, uint256 indexed tokenId, address minter, string tokenURI);
1760 }
1761 
1762 // File: contracts/ERC721AQueryable.sol
1763 
1764 
1765 
1766 pragma solidity ^0.8.4;
1767 
1768 error InvalidQueryRange();
1769 
1770 /**
1771  * @title ERC721A Queryable
1772  * @dev ERC721A subclass with convenience query functions.
1773  */
1774 abstract contract ERC721AQueryable is ERC721A {
1775     /**
1776      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1777      *
1778      * If the `tokenId` is out of bounds:
1779      *   - `addr` = `address(0)`
1780      *   - `startTimestamp` = `0`
1781      *   - `burned` = `false`
1782      *
1783      * If the `tokenId` is burned:
1784      *   - `addr` = `<Address of owner before token was burned>`
1785      *   - `startTimestamp` = `<Timestamp when token was burned>`
1786      *   - `burned = `true`
1787      *
1788      * Otherwise:
1789      *   - `addr` = `<Address of owner>`
1790      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1791      *   - `burned = `false`
1792      */
1793     function explicitOwnershipOf(uint256 tokenId) public view returns (TokenOwnership memory) {
1794         TokenOwnership memory ownership;
1795         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1796             return ownership;
1797         }
1798         ownership = _ownerships[tokenId];
1799         if (ownership.burned) {
1800             return ownership;
1801         }
1802         return _ownershipOf(tokenId);
1803     }
1804 
1805     /**
1806      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1807      * See {ERC721AQueryable-explicitOwnershipOf}
1808      */
1809     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory) {
1810         unchecked {
1811             uint256 tokenIdsLength = tokenIds.length;
1812             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1813             for (uint256 i; i != tokenIdsLength; ++i) {
1814                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1815             }
1816             return ownerships;
1817         }
1818     }
1819 
1820     /**
1821      * @dev Returns an array of token IDs owned by `owner`,
1822      * in the range [`start`, `stop`)
1823      * (i.e. `start <= tokenId < stop`).
1824      *
1825      * This function allows for tokens to be queried if the collection
1826      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1827      *
1828      * Requirements:
1829      *
1830      * - `start` < `stop`
1831      */
1832     function tokensOfOwnerIn(
1833         address owner,
1834         uint256 start,
1835         uint256 stop
1836     ) external view returns (uint256[] memory) {
1837         unchecked {
1838             if (start > stop) revert InvalidQueryRange();
1839             uint256 tokenIdsIdx;
1840             uint256 stopLimit = _currentIndex + 1;
1841             // Set `start = max(start, _startTokenId())`.
1842             if (start < _startTokenId()) {
1843                 start = _startTokenId();
1844             }
1845             // Set `stop = min(stop, _currentIndex)`.
1846             if (stop > stopLimit) {
1847                 stop = stopLimit;
1848             }
1849             uint256 tokenIdsMaxLength = balanceOf(owner);
1850             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1851             // to cater for cases where `balanceOf(owner)` is too big.
1852             if (start < stop) {
1853                 uint256 rangeLength = stop - start;
1854                 if (rangeLength < tokenIdsMaxLength) {
1855                     tokenIdsMaxLength = rangeLength;
1856                 }
1857             } else {
1858                 tokenIdsMaxLength = 0;
1859             }
1860             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1861             if (tokenIdsMaxLength == 0) {
1862                 return tokenIds;
1863             }
1864             // We need to call `explicitOwnershipOf(start)`,
1865             // because the slot at `start` may not be initialized.
1866             TokenOwnership memory ownership = explicitOwnershipOf(start);
1867             address currOwnershipAddr;
1868             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1869             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1870             if (!ownership.burned) {
1871                 currOwnershipAddr = ownership.addr;
1872             }
1873             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1874                 ownership = _ownerships[i];
1875                 if (ownership.burned) {
1876                     continue;
1877                 }
1878                 if (ownership.addr != address(0)) {
1879                     currOwnershipAddr = ownership.addr;
1880                 }
1881                 if (currOwnershipAddr == owner) {
1882                     tokenIds[tokenIdsIdx++] = i;
1883                 }
1884             }
1885             // Downsize the array to fit.
1886             assembly {
1887                 mstore(tokenIds, tokenIdsIdx)
1888             }
1889             return tokenIds;
1890         }
1891     }
1892 
1893     /**
1894      * @dev Returns an array of token IDs owned by `owner`.
1895      *
1896      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1897      * It is meant to be called off-chain.
1898      *
1899      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1900      * multiple smaller scans if the collection is large enough to cause
1901      * an out-of-gas error (10K pfp collections should be fine).
1902      */
1903     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1904         unchecked {
1905             uint256 tokenIdsIdx;
1906             address currOwnershipAddr;
1907             uint256 tokenIdsLength = balanceOf(owner);
1908             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1909             TokenOwnership memory ownership;
1910             for (uint256 i = _startTokenId(); tokenIdsIdx <= tokenIdsLength; ++i) {
1911                 ownership = _ownerships[i];
1912                 if (ownership.burned) {
1913                     continue;
1914                 }
1915                 if (ownership.addr != address(0)) {
1916                     currOwnershipAddr = ownership.addr;
1917                 }
1918                 if (currOwnershipAddr == owner) {
1919                     tokenIds[tokenIdsIdx++] = i;
1920                 }
1921             }
1922             return tokenIds;
1923         }
1924     }
1925 }
1926 
1927 // File: contracts/Storage.sol
1928 
1929 
1930 pragma solidity ^0.8.14;
1931 
1932 
1933 
1934 abstract contract Storage {
1935  
1936 	string public baseURI;
1937 	// settings
1938 
1939     struct whitelist{
1940         uint256 startTime;
1941         uint256 endTime;
1942         uint256 supply;
1943         uint256 sold;
1944         bytes32 root;
1945     }
1946 
1947     mapping(uint256 => whitelist) public whitelistRoot;
1948 
1949     mapping(uint256 => mapping(string => bool)) public isWhitelistFor;
1950 
1951 	uint256 public maxMint = 0;
1952 	uint256 public status = 0;
1953     struct rate {
1954         uint256 cost;
1955         uint256 total;
1956         uint256 sold;
1957         bool valid;
1958     }
1959 
1960     mapping (uint256 => mapping (string => rate)) public rates;
1961 
1962     uint256 public discount;
1963 
1964     uint256 public perTransactionLimit;
1965 
1966     mapping(uint256 => mapping(address => uint256)) public _userBought;
1967 	
1968 
1969     
1970     event _mintCommon(address userAddress, string rarity, uint size,uint256 start, uint256 end, uint amount, uint price, bool isDiscount);
1971     event _mintLand(address userAddress, string rarity, uint size, uint256 start, uint256 end,  uint amount, uint price, bool isDiscount);
1972 
1973 
1974     //modifiers
1975 
1976 	modifier checkSupply(uint256 _mintAmount, uint256 _size, string memory rarity) {
1977         uint256 s = rates[_size][rarity].sold;
1978          //Check Validity of land as per size
1979         require(rates[_size][rarity].valid, "XanaLand: Plot size not valid" );
1980            //To check if contract has started sale on not
1981         require(status != 0, "XanaLand: Sale not started yet." );
1982         require(_mintAmount > 0, "XanaLand: Amount is Zero" );
1983         require(_mintAmount <= maxMint, "XanaLand: Amount exceeded in params" );
1984         require(s + _mintAmount <= rates[_size][rarity].total, "XanaLand: Max Limit Reached for Common" );
1985 
1986         require(_mintAmount <= perTransactionLimit,  "XanaLand: Per transaction limit exceed" );
1987         delete s;
1988         _;
1989     }
1990 
1991    
1992 }
1993 
1994 // File: contracts/LandProxy.sol
1995 
1996 
1997 pragma solidity ^0.8.14;
1998 
1999 
2000 
2001 
2002 
2003 
2004 
2005 contract LandProxy is ProxyBaseStorage, IERC1538, ERC721AQueryable, Ownable, ReentrancyGuard, Storage {
2006 using Strings for uint256;
2007 
2008     constructor(
2009 	string memory _name,
2010 	string memory _symbol,
2011     address implementation
2012 	)ERC721A(_name, _symbol) {
2013 
2014         proxy = address(this);
2015         maxMint = 10000;
2016     
2017         //Adding ERC1538 updateContract function
2018         bytes memory signature = "updateContract(address,string,string)";
2019          constructorRegisterFunction(signature, proxy);
2020          bytes memory setBaseURISig = "setBaseURI(string)";
2021          constructorRegisterFunction(setBaseURISig, implementation);
2022          setBaseURISig = "mintLand(string,uint256,uint256,bytes32[],bool,uint256)";
2023          constructorRegisterFunction(setBaseURISig, implementation);
2024          setBaseURISig = "isWhitelisted(address,bytes32[],uint256,uint256,string)";
2025          constructorRegisterFunction(setBaseURISig, implementation);
2026          setBaseURISig = "setRate(uint256,uint256,uint256,string)";
2027          constructorRegisterFunction(setBaseURISig, implementation);
2028          setBaseURISig = "setSaleStatus(uint256)";
2029          constructorRegisterFunction(setBaseURISig, implementation);
2030          setBaseURISig = "calculateDiscount(uint256,string)";
2031          constructorRegisterFunction(setBaseURISig, implementation);
2032          setBaseURISig = "mintDiscountCommon(uint256,bytes32[])";
2033          constructorRegisterFunction(setBaseURISig, implementation);
2034          setBaseURISig = "freeMint(uint256,bytes32[])";
2035          constructorRegisterFunction(setBaseURISig, implementation);
2036          setBaseURISig = "setWhitelistRoot(bytes32,uint256,uint256,uint256,uint256,string[])";
2037          constructorRegisterFunction(setBaseURISig, implementation);
2038          setBaseURISig = "removeWhiteList(uint256,string)";
2039          constructorRegisterFunction(setBaseURISig, implementation);
2040          setBaseURISig = "setMaxMintAmount(uint256)";
2041          constructorRegisterFunction(setBaseURISig, implementation);
2042          setBaseURISig = "setDiscount(uint256)";
2043          constructorRegisterFunction(setBaseURISig, implementation);
2044          setBaseURISig = "setPerTransactionLimit(uint256)";
2045          constructorRegisterFunction(setBaseURISig, implementation);
2046          setBaseURISig = "setLockUp(uint256[],uint256[])";
2047          constructorRegisterFunction(setBaseURISig, implementation);
2048          setBaseURISig = "withdraw()";
2049          constructorRegisterFunction(setBaseURISig, implementation);
2050          setBaseURISig = "mintAdmin(address,uint256,uint256,string)";
2051          constructorRegisterFunction(setBaseURISig, implementation);
2052          setBaseURISig = "setTransferAllowed(address,bool)";
2053          constructorRegisterFunction(setBaseURISig, implementation);
2054 
2055 
2056 
2057         
2058     }
2059 
2060     function constructorRegisterFunction(bytes memory signature, address proxy) internal {
2061         bytes4 funcId = bytes4(keccak256(signature));
2062         delegates[funcId] = proxy;
2063         funcSignatures.push(signature);
2064         funcSignatureToIndex[signature] = funcSignatures.length;
2065        
2066         emit FunctionUpdate(funcId, address(0), proxy, string(signature));
2067         
2068         emit CommitMessage("Added ERC1538 updateContract function at contract creation");
2069     }
2070 
2071     ///////////////////////////////////////////////////////////////////////////////////////////////
2072 
2073     fallback() external payable {
2074         if (msg.sig == bytes4(0) && msg.value != uint(0)) { // skipping ethers/BNB received to delegate
2075             return;
2076         }
2077         address delegate = delegates[msg.sig];
2078         require(delegate != address(0), "Function does not exist.");
2079         assembly {
2080             let ptr := mload(0x40)
2081             calldatacopy(ptr, 0, calldatasize())
2082             let result := delegatecall(gas(), delegate, ptr, calldatasize(), 0, 0)
2083             let size := returndatasize()
2084             returndatacopy(ptr, 0, size)
2085             switch result
2086             case 0 {revert(ptr, size)}
2087             default {return (ptr, size)}
2088         }
2089     }
2090 
2091     ///////////////////////////////////////////////////////////////////////////////////////////////
2092 
2093     /// @notice Updates functions in a transparent contract.
2094     /// @dev If the value of _delegate is zero then the functions specified
2095     ///  in _functionSignatures are removed.
2096     ///  If the value of _delegate is a delegate contract address then the functions
2097     ///  specified in _functionSignatures will be delegated to that address.
2098     /// @param _delegate The address of a delegate contract to delegate to or zero
2099     /// @param _functionSignatures A list of function signatures listed one after the other
2100     /// @param _commitMessage A short description of the change and why it is made
2101     ///        This message is passed to the CommitMessage event.
2102     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) override onlyOwner external {
2103         // pos is first used to check the size of the delegate contract.
2104         // After that pos is the current memory location of _functionSignatures.
2105         // It is used to move through the characters of _functionSignatures
2106         uint256 pos;
2107         if(_delegate != address(0)) {
2108             assembly {
2109                 pos := extcodesize(_delegate)
2110             }
2111             require(pos > 0, "_delegate address is not a contract and is not address(0)");
2112         }
2113 
2114         // creates a bytes version of _functionSignatures
2115         bytes memory signatures = bytes(_functionSignatures);
2116         // stores the position in memory where _functionSignatures ends.
2117         uint256 signaturesEnd;
2118         // stores the starting position of a function signature in _functionSignatures
2119         uint256 start;
2120         assembly {
2121             pos := add(signatures,32)
2122             start := pos
2123             signaturesEnd := add(pos,mload(signatures))
2124         }
2125         // the function id of the current function signature
2126         bytes4 funcId;
2127         // the delegate address that is being replaced or address(0) if removing functions
2128         address oldDelegate;
2129         // the length of the current function signature in _functionSignatures
2130         uint256 num;
2131         // the current character in _functionSignatures
2132         uint256 char;
2133         // the position of the current function signature in the funcSignatures array
2134         uint256 index;
2135         // the last position in the funcSignatures array
2136         uint256 lastIndex;
2137         // parse the _functionSignatures string and handle each function
2138         for (; pos < signaturesEnd; pos++) {
2139             assembly {char := byte(0,mload(pos))}
2140             // 0x29 == )
2141             if (char == 0x29) {
2142                 pos++;
2143                 num = (pos - start);
2144                 start = pos;
2145                 assembly {
2146                     mstore(signatures,num)
2147                 }
2148                 funcId = bytes4(keccak256(signatures));
2149                 oldDelegate = delegates[funcId];
2150                 if(_delegate == address(0)) {
2151                     index = funcSignatureToIndex[signatures];
2152                     require(index != 0, "Function does not exist.");
2153                     index--;
2154                     lastIndex = funcSignatures.length - 1;
2155                     if (index != lastIndex) {
2156                         funcSignatures[index] = funcSignatures[lastIndex];
2157                         funcSignatureToIndex[funcSignatures[lastIndex]] = index + 1;
2158                     }
2159                     funcSignatures.pop();
2160                     delete funcSignatureToIndex[signatures];
2161                     delete delegates[funcId];
2162                     emit FunctionUpdate(funcId, oldDelegate, address(0), string(signatures));
2163                 }
2164                 else if (funcSignatureToIndex[signatures] == 0) {
2165                     require(oldDelegate == address(0), "FuncId clash.");
2166                     delegates[funcId] = _delegate;
2167                     funcSignatures.push(signatures);
2168                     funcSignatureToIndex[signatures] = funcSignatures.length;
2169                     emit FunctionUpdate(funcId, address(0), _delegate, string(signatures));
2170                 }
2171                 else if (delegates[funcId] != _delegate) {
2172                     delegates[funcId] = _delegate;
2173                     emit FunctionUpdate(funcId, oldDelegate, _delegate, string(signatures));
2174 
2175                 }
2176                 assembly {signatures := add(signatures,num)}
2177             }
2178         }
2179         emit CommitMessage(_commitMessage);
2180     }
2181 
2182    
2183 
2184  /**
2185      * @dev See {IERC721Metadata-tokenURI}.
2186      */
2187     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2188         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2189 
2190         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2191     }
2192 
2193     receive() external payable {}
2194 
2195 
2196     ///////////////////////////////////////////////////////////////////////////////////////////////
2197 
2198 }
2199 
2200 ///////////////////////////////////////////////////////////////////////////////////////////////////