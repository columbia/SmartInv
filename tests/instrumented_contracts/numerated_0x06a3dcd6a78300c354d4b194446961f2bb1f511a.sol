1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Contract module that helps prevent reentrant calls to a function.
108  *
109  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
110  * available, which can be applied to functions to make sure there are no nested
111  * (reentrant) calls to them.
112  *
113  * Note that because there is a single `nonReentrant` guard, functions marked as
114  * `nonReentrant` may not call one another. This can be worked around by making
115  * those functions `private`, and then adding `external` `nonReentrant` entry
116  * points to them.
117  *
118  * TIP: If you would like to learn more about reentrancy and alternative ways
119  * to protect against it, check out our blog post
120  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
121  */
122 abstract contract ReentrancyGuard {
123     // Booleans are more expensive than uint256 or any type that takes up a full
124     // word because each write operation emits an extra SLOAD to first read the
125     // slot's contents, replace the bits taken up by the boolean, and then write
126     // back. This is the compiler's defense against contract upgrades and
127     // pointer aliasing, and it cannot be disabled.
128 
129     // The values being non-zero value makes deployment a bit more expensive,
130     // but in exchange the refund on every call to nonReentrant will be lower in
131     // amount. Since refunds are capped to a percentage of the total
132     // transaction's gas, it is best to keep them low in cases like this one, to
133     // increase the likelihood of the full refund coming into effect.
134     uint256 private constant _NOT_ENTERED = 1;
135     uint256 private constant _ENTERED = 2;
136 
137     uint256 private _status;
138 
139     constructor() {
140         _status = _NOT_ENTERED;
141     }
142 
143     /**
144      * @dev Prevents a contract from calling itself, directly or indirectly.
145      * Calling a `nonReentrant` function from another `nonReentrant`
146      * function is not supported. It is possible to prevent this from happening
147      * by making the `nonReentrant` function external, and make it call a
148      * `private` function that does the actual work.
149      */
150     modifier nonReentrant() {
151         // On the first call to nonReentrant, _notEntered will be true
152         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
153 
154         // Any calls to nonReentrant after this point will fail
155         _status = _ENTERED;
156 
157         _;
158 
159         // By storing the original value once again, a refund is triggered (see
160         // https://eips.ethereum.org/EIPS/eip-2200)
161         _status = _NOT_ENTERED;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
166 
167 
168 
169 pragma solidity ^0.8.0;
170 
171 // CAUTION
172 // This version of SafeMath should only be used with Solidity 0.8 or later,
173 // because it relies on the compiler's built in overflow checks.
174 
175 /**
176  * @dev Wrappers over Solidity's arithmetic operations.
177  *
178  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
179  * now has built in overflow checking.
180  */
181 library SafeMath {
182     /**
183      * @dev Returns the addition of two unsigned integers, with an overflow flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
188         unchecked {
189             uint256 c = a + b;
190             if (c < a) return (false, 0);
191             return (true, c);
192         }
193     }
194 
195     /**
196      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
197      *
198      * _Available since v3.4._
199      */
200     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         unchecked {
202             if (b > a) return (false, 0);
203             return (true, a - b);
204         }
205     }
206 
207     /**
208      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
209      *
210      * _Available since v3.4._
211      */
212     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
213         unchecked {
214             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
215             // benefit is lost if 'b' is also tested.
216             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
217             if (a == 0) return (true, 0);
218             uint256 c = a * b;
219             if (c / a != b) return (false, 0);
220             return (true, c);
221         }
222     }
223 
224     /**
225      * @dev Returns the division of two unsigned integers, with a division by zero flag.
226      *
227      * _Available since v3.4._
228      */
229     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
230         unchecked {
231             if (b == 0) return (false, 0);
232             return (true, a / b);
233         }
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
238      *
239      * _Available since v3.4._
240      */
241     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         unchecked {
243             if (b == 0) return (false, 0);
244             return (true, a % b);
245         }
246     }
247 
248     /**
249      * @dev Returns the addition of two unsigned integers, reverting on
250      * overflow.
251      *
252      * Counterpart to Solidity's `+` operator.
253      *
254      * Requirements:
255      *
256      * - Addition cannot overflow.
257      */
258     function add(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a + b;
260     }
261 
262     /**
263      * @dev Returns the subtraction of two unsigned integers, reverting on
264      * overflow (when the result is negative).
265      *
266      * Counterpart to Solidity's `-` operator.
267      *
268      * Requirements:
269      *
270      * - Subtraction cannot overflow.
271      */
272     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273         return a - b;
274     }
275 
276     /**
277      * @dev Returns the multiplication of two unsigned integers, reverting on
278      * overflow.
279      *
280      * Counterpart to Solidity's `*` operator.
281      *
282      * Requirements:
283      *
284      * - Multiplication cannot overflow.
285      */
286     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
287         return a * b;
288     }
289 
290     /**
291      * @dev Returns the integer division of two unsigned integers, reverting on
292      * division by zero. The result is rounded towards zero.
293      *
294      * Counterpart to Solidity's `/` operator.
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting when dividing by zero.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         return a % b;
318     }
319 
320     /**
321      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
322      * overflow (when the result is negative).
323      *
324      * CAUTION: This function is deprecated because it requires allocating memory for the error
325      * message unnecessarily. For custom revert reasons use {trySub}.
326      *
327      * Counterpart to Solidity's `-` operator.
328      *
329      * Requirements:
330      *
331      * - Subtraction cannot overflow.
332      */
333     function sub(
334         uint256 a,
335         uint256 b,
336         string memory errorMessage
337     ) internal pure returns (uint256) {
338         unchecked {
339             require(b <= a, errorMessage);
340             return a - b;
341         }
342     }
343 
344     /**
345      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
346      * division by zero. The result is rounded towards zero.
347      *
348      * Counterpart to Solidity's `/` operator. Note: this function uses a
349      * `revert` opcode (which leaves remaining gas untouched) while Solidity
350      * uses an invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function div(
357         uint256 a,
358         uint256 b,
359         string memory errorMessage
360     ) internal pure returns (uint256) {
361         unchecked {
362             require(b > 0, errorMessage);
363             return a / b;
364         }
365     }
366 
367     /**
368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
369      * reverting with custom message when dividing by zero.
370      *
371      * CAUTION: This function is deprecated because it requires allocating memory for the error
372      * message unnecessarily. For custom revert reasons use {tryMod}.
373      *
374      * Counterpart to Solidity's `%` operator. This function uses a `revert`
375      * opcode (which leaves remaining gas untouched) while Solidity uses an
376      * invalid opcode to revert (consuming all remaining gas).
377      *
378      * Requirements:
379      *
380      * - The divisor cannot be zero.
381      */
382     function mod(
383         uint256 a,
384         uint256 b,
385         string memory errorMessage
386     ) internal pure returns (uint256) {
387         unchecked {
388             require(b > 0, errorMessage);
389             return a % b;
390         }
391     }
392 }
393 
394 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
395 
396 
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev Interface of the ERC20 standard as defined in the EIP.
402  */
403 interface IERC20 {
404     /**
405      * @dev Returns the amount of tokens in existence.
406      */
407     function totalSupply() external view returns (uint256);
408 
409     /**
410      * @dev Returns the amount of tokens owned by `account`.
411      */
412     function balanceOf(address account) external view returns (uint256);
413 
414     /**
415      * @dev Moves `amount` tokens from the caller's account to `recipient`.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transfer(address recipient, uint256 amount) external returns (bool);
422 
423     /**
424      * @dev Returns the remaining number of tokens that `spender` will be
425      * allowed to spend on behalf of `owner` through {transferFrom}. This is
426      * zero by default.
427      *
428      * This value changes when {approve} or {transferFrom} are called.
429      */
430     function allowance(address owner, address spender) external view returns (uint256);
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
434      *
435      * Returns a boolean value indicating whether the operation succeeded.
436      *
437      * IMPORTANT: Beware that changing an allowance with this method brings the risk
438      * that someone may use both the old and the new allowance by unfortunate
439      * transaction ordering. One possible solution to mitigate this race
440      * condition is to first reduce the spender's allowance to 0 and set the
441      * desired value afterwards:
442      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
443      *
444      * Emits an {Approval} event.
445      */
446     function approve(address spender, uint256 amount) external returns (bool);
447 
448     /**
449      * @dev Moves `amount` tokens from `sender` to `recipient` using the
450      * allowance mechanism. `amount` is then deducted from the caller's
451      * allowance.
452      *
453      * Returns a boolean value indicating whether the operation succeeded.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transferFrom(
458         address sender,
459         address recipient,
460         uint256 amount
461     ) external returns (bool);
462 
463     /**
464      * @dev Emitted when `value` tokens are moved from one account (`from`) to
465      * another (`to`).
466      *
467      * Note that `value` may be zero.
468      */
469     event Transfer(address indexed from, address indexed to, uint256 value);
470 
471     /**
472      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
473      * a call to {approve}. `value` is the new allowance.
474      */
475     event Approval(address indexed owner, address indexed spender, uint256 value);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
479 
480 
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev Interface of the ERC165 standard, as defined in the
486  * https://eips.ethereum.org/EIPS/eip-165[EIP].
487  *
488  * Implementers can declare support of contract interfaces, which can then be
489  * queried by others ({ERC165Checker}).
490  *
491  * For an implementation, see {ERC165}.
492  */
493 interface IERC165 {
494     /**
495      * @dev Returns true if this contract implements the interface defined by
496      * `interfaceId`. See the corresponding
497      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
498      * to learn more about how these ids are created.
499      *
500      * This function call must use less than 30 000 gas.
501      */
502     function supportsInterface(bytes4 interfaceId) external view returns (bool);
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
506 
507 
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Required interface of an ERC1155 compliant contract, as defined in the
514  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
515  *
516  * _Available since v3.1._
517  */
518 interface IERC1155 is IERC165 {
519     /**
520      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
521      */
522     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
523 
524     /**
525      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
526      * transfers.
527      */
528     event TransferBatch(
529         address indexed operator,
530         address indexed from,
531         address indexed to,
532         uint256[] ids,
533         uint256[] values
534     );
535 
536     /**
537      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
538      * `approved`.
539      */
540     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
541 
542     /**
543      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
544      *
545      * If an {URI} event was emitted for `id`, the standard
546      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
547      * returned by {IERC1155MetadataURI-uri}.
548      */
549     event URI(string value, uint256 indexed id);
550 
551     /**
552      * @dev Returns the amount of tokens of token type `id` owned by `account`.
553      *
554      * Requirements:
555      *
556      * - `account` cannot be the zero address.
557      */
558     function balanceOf(address account, uint256 id) external view returns (uint256);
559 
560     /**
561      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
562      *
563      * Requirements:
564      *
565      * - `accounts` and `ids` must have the same length.
566      */
567     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
568         external
569         view
570         returns (uint256[] memory);
571 
572     /**
573      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
574      *
575      * Emits an {ApprovalForAll} event.
576      *
577      * Requirements:
578      *
579      * - `operator` cannot be the caller.
580      */
581     function setApprovalForAll(address operator, bool approved) external;
582 
583     /**
584      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
585      *
586      * See {setApprovalForAll}.
587      */
588     function isApprovedForAll(address account, address operator) external view returns (bool);
589 
590     /**
591      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
592      *
593      * Emits a {TransferSingle} event.
594      *
595      * Requirements:
596      *
597      * - `to` cannot be the zero address.
598      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
599      * - `from` must have a balance of tokens of type `id` of at least `amount`.
600      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
601      * acceptance magic value.
602      */
603     function safeTransferFrom(
604         address from,
605         address to,
606         uint256 id,
607         uint256 amount,
608         bytes calldata data
609     ) external;
610 
611     /**
612      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
613      *
614      * Emits a {TransferBatch} event.
615      *
616      * Requirements:
617      *
618      * - `ids` and `amounts` must have the same length.
619      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
620      * acceptance magic value.
621      */
622     function safeBatchTransferFrom(
623         address from,
624         address to,
625         uint256[] calldata ids,
626         uint256[] calldata amounts,
627         bytes calldata data
628     ) external;
629 }
630 
631 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
632 
633 
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @dev Required interface of an ERC721 compliant contract.
640  */
641 interface IERC721 is IERC165 {
642     /**
643      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
644      */
645     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
646 
647     /**
648      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
649      */
650     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
651 
652     /**
653      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
654      */
655     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
656 
657     /**
658      * @dev Returns the number of tokens in ``owner``'s account.
659      */
660     function balanceOf(address owner) external view returns (uint256 balance);
661 
662     /**
663      * @dev Returns the owner of the `tokenId` token.
664      *
665      * Requirements:
666      *
667      * - `tokenId` must exist.
668      */
669     function ownerOf(uint256 tokenId) external view returns (address owner);
670 
671     /**
672      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
673      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must exist and be owned by `from`.
680      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
681      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
682      *
683      * Emits a {Transfer} event.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId
689     ) external;
690 
691     /**
692      * @dev Transfers `tokenId` token from `from` to `to`.
693      *
694      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
695      *
696      * Requirements:
697      *
698      * - `from` cannot be the zero address.
699      * - `to` cannot be the zero address.
700      * - `tokenId` token must be owned by `from`.
701      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
702      *
703      * Emits a {Transfer} event.
704      */
705     function transferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) external;
710 
711     /**
712      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
713      * The approval is cleared when the token is transferred.
714      *
715      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
716      *
717      * Requirements:
718      *
719      * - The caller must own the token or be an approved operator.
720      * - `tokenId` must exist.
721      *
722      * Emits an {Approval} event.
723      */
724     function approve(address to, uint256 tokenId) external;
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
736      * @dev Approve or remove `operator` as an operator for the caller.
737      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
738      *
739      * Requirements:
740      *
741      * - The `operator` cannot be the caller.
742      *
743      * Emits an {ApprovalForAll} event.
744      */
745     function setApprovalForAll(address operator, bool _approved) external;
746 
747     /**
748      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
749      *
750      * See {setApprovalForAll}
751      */
752     function isApprovedForAll(address owner, address operator) external view returns (bool);
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`.
756      *
757      * Requirements:
758      *
759      * - `from` cannot be the zero address.
760      * - `to` cannot be the zero address.
761      * - `tokenId` token must exist and be owned by `from`.
762      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
763      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
764      *
765      * Emits a {Transfer} event.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes calldata data
772     ) external;
773 }
774 
775 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
776 
777 
778 
779 pragma solidity ^0.8.0;
780 
781 
782 /**
783  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
784  * @dev See https://eips.ethereum.org/EIPS/eip-721
785  */
786 interface IERC721Enumerable is IERC721 {
787     /**
788      * @dev Returns the total amount of tokens stored by the contract.
789      */
790     function totalSupply() external view returns (uint256);
791 
792     /**
793      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
794      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
795      */
796     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
797 
798     /**
799      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
800      * Use along with {totalSupply} to enumerate all tokens.
801      */
802     function tokenByIndex(uint256 index) external view returns (uint256);
803 }
804 
805 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
806 
807 
808 
809 pragma solidity ^0.8.0;
810 
811 
812 /**
813  * @dev Implementation of the {IERC165} interface.
814  *
815  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
816  * for the additional interface id that will be supported. For example:
817  *
818  * ```solidity
819  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
820  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
821  * }
822  * ```
823  *
824  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
825  */
826 abstract contract ERC165 is IERC165 {
827     /**
828      * @dev See {IERC165-supportsInterface}.
829      */
830     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
831         return interfaceId == type(IERC165).interfaceId;
832     }
833 }
834 
835 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
836 
837 
838 
839 pragma solidity ^0.8.0;
840 
841 
842 /**
843  * @dev _Available since v3.1._
844  */
845 interface IERC1155Receiver is IERC165 {
846     /**
847         @dev Handles the receipt of a single ERC1155 token type. This function is
848         called at the end of a `safeTransferFrom` after the balance has been updated.
849         To accept the transfer, this must return
850         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
851         (i.e. 0xf23a6e61, or its own function selector).
852         @param operator The address which initiated the transfer (i.e. msg.sender)
853         @param from The address which previously owned the token
854         @param id The ID of the token being transferred
855         @param value The amount of tokens being transferred
856         @param data Additional data with no specified format
857         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
858     */
859     function onERC1155Received(
860         address operator,
861         address from,
862         uint256 id,
863         uint256 value,
864         bytes calldata data
865     ) external returns (bytes4);
866 
867     /**
868         @dev Handles the receipt of a multiple ERC1155 token types. This function
869         is called at the end of a `safeBatchTransferFrom` after the balances have
870         been updated. To accept the transfer(s), this must return
871         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
872         (i.e. 0xbc197c81, or its own function selector).
873         @param operator The address which initiated the batch transfer (i.e. msg.sender)
874         @param from The address which previously owned the token
875         @param ids An array containing ids of each token being transferred (order and length must match values array)
876         @param values An array containing amounts of each token being transferred (order and length must match ids array)
877         @param data Additional data with no specified format
878         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
879     */
880     function onERC1155BatchReceived(
881         address operator,
882         address from,
883         uint256[] calldata ids,
884         uint256[] calldata values,
885         bytes calldata data
886     ) external returns (bytes4);
887 }
888 
889 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
890 
891 
892 
893 pragma solidity ^0.8.0;
894 
895 
896 
897 /**
898  * @dev _Available since v3.1._
899  */
900 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
901     /**
902      * @dev See {IERC165-supportsInterface}.
903      */
904     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
905         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
906     }
907 }
908 
909 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol
910 
911 
912 
913 pragma solidity ^0.8.0;
914 
915 
916 /**
917  * @dev _Available since v3.1._
918  */
919 contract ERC1155Holder is ERC1155Receiver {
920     function onERC1155Received(
921         address,
922         address,
923         uint256,
924         uint256,
925         bytes memory
926     ) public virtual override returns (bytes4) {
927         return this.onERC1155Received.selector;
928     }
929 
930     function onERC1155BatchReceived(
931         address,
932         address,
933         uint256[] memory,
934         uint256[] memory,
935         bytes memory
936     ) public virtual override returns (bytes4) {
937         return this.onERC1155BatchReceived.selector;
938     }
939 }
940 
941 // File: a.sol
942 
943 
944 pragma solidity ^0.8.7;
945 
946 
947 
948 
949 contract CointoolMultisender is ERC1155Holder, ReentrancyGuard, Ownable {
950 
951   using SafeMath for uint256;
952 
953   address payable public feeReceiver;
954   uint256 public ethFee;
955   uint256 public array_limit;
956 
957 
958   bytes emptyData = bytes("");
959 
960 
961   constructor()  {
962     ethFee = 0.05 ether;
963     feeReceiver =payable(msg.sender);
964     array_limit = 200;
965   }
966 
967 
968     function arrayLimit() public view returns(uint256) {
969         return array_limit;
970     }
971 
972     function currentFee(address _customer) public view returns(uint256) {
973         if(_customer == address(0x0)){
974             return 0;
975         }
976         return  ethFee;
977     }
978 
979 
980   // Internal function to send ERC721 or ERC20 tokens
981   // Using transferFrom means we don't implement ERC721 Receiver
982   function _send721Or20(address tokenAddress, address from, address to, uint256 amountOrId) internal {
983     IERC721(tokenAddress).transferFrom(from, to, amountOrId);
984   }
985 
986 
987 
988   // Direct senders
989 
990   // Normal multisend: sends a batch of ERC721 or ERC20 to a list of addresses
991   function multisendToken(
992     address tokenAddress,
993     address[] calldata userAddresses,
994     uint256[] calldata amountsOrIds
995    ) external payable nonReentrant {
996     require((userAddresses.length == amountsOrIds.length), "diff lengths");
997     for (uint256 i = 0; i < userAddresses.length; i++) {
998       _send721Or20(tokenAddress, msg.sender, userAddresses[i], amountsOrIds[i]);
999     }
1000   }
1001 
1002 // ERC721 targeted multisend: sends a batch of ERC721 or ERC20s to a list of ERC721 ID holders
1003   function send721Or20To721Ids(
1004     address[] calldata erc721Addresses,
1005     uint256[] calldata receiverIds,
1006     uint256[] calldata amountsOrIds,
1007     address tokenAddress) external payable nonReentrant {
1008     require((erc721Addresses.length == receiverIds.length), "diff lengths");
1009     require((erc721Addresses.length == amountsOrIds.length), "diff lengths");
1010     for (uint256 i = 0; i < receiverIds.length; i++) {
1011       IERC721Enumerable erc721 = IERC721Enumerable(erc721Addresses[i]);
1012       _send721Or20(tokenAddress, msg.sender, erc721.ownerOf(receiverIds[i]), amountsOrIds[i]);
1013     }
1014   }
1015 
1016   // Send ERC-1155 to a batch of addresses
1017   function send1155ToAddresses(
1018     address[] calldata userAddresses,
1019     uint256[] calldata tokenIds,
1020     uint256[] calldata amounts,
1021     address tokenAddress) external payable nonReentrant {
1022     require((userAddresses.length == amounts.length), "diff lengths");
1023     require((userAddresses.length == tokenIds.length), "diff lengths");
1024     for (uint256 i = 0; i < userAddresses.length; i++) {
1025       IERC1155(tokenAddress).safeTransferFrom(msg.sender, userAddresses[i], tokenIds[i], amounts[i], emptyData);
1026     }
1027   }
1028 
1029   // Send ERC-1155 to a list of ERC721 ID holders
1030   function send1155To721Ids(
1031     address[] calldata erc721Addresses,
1032     uint256[] calldata erc721Ids,
1033     uint256[] calldata tokenIds,
1034     uint256[] calldata amounts,
1035     address tokenAddress) external payable nonReentrant {
1036     require((erc721Addresses.length == erc721Ids.length), "diff lengths");
1037     require((erc721Addresses.length == amounts.length), "diff lengths");
1038     require((erc721Addresses.length == tokenIds.length), "diff lengths");
1039     for (uint256 i = 0; i < erc721Addresses.length; i++) {
1040       IERC1155(tokenAddress).safeTransferFrom(msg.sender, IERC721(erc721Addresses[i]).ownerOf(erc721Ids[i]), tokenIds[i], amounts[i], emptyData);
1041     }
1042   }
1043 
1044 
1045 
1046 
1047 
1048   // OWNER FUNCTIONS
1049 
1050   function setFeeReceiver(address payable a) public onlyOwner {
1051     feeReceiver = a;
1052   }
1053 
1054   function setEthFee(uint256 f) public onlyOwner {
1055     ethFee = f;
1056   }
1057   
1058     function claimTokens(address _token) public onlyOwner {
1059         if (_token == address(0x0)) {
1060              feeReceiver.transfer(address(this).balance);
1061             return;
1062         }
1063         IERC20 erc20token = IERC20(_token);
1064         uint256 balance = erc20token.balanceOf(address(this));
1065         erc20token.transfer(feeReceiver, balance);
1066     }
1067    
1068   
1069   
1070 
1071 }