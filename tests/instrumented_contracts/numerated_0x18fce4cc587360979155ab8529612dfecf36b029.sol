1 // File: contracts/ISpacePunksTreasureKeys.sol
2 
3 
4 pragma solidity 0.8.7;
5 
6 interface ISpacePunksTreasureKeys {
7   function burnKeyForAddress(uint256 typeId, address burnTokenAddress) external;
8   function balanceOf(address account, uint256 id) external view returns (uint256);
9 }
10 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
11 
12 
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Contract module that helps prevent reentrant calls to a function.
18  *
19  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
20  * available, which can be applied to functions to make sure there are no nested
21  * (reentrant) calls to them.
22  *
23  * Note that because there is a single `nonReentrant` guard, functions marked as
24  * `nonReentrant` may not call one another. This can be worked around by making
25  * those functions `private`, and then adding `external` `nonReentrant` entry
26  * points to them.
27  *
28  * TIP: If you would like to learn more about reentrancy and alternative ways
29  * to protect against it, check out our blog post
30  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
31  */
32 abstract contract ReentrancyGuard {
33     // Booleans are more expensive than uint256 or any type that takes up a full
34     // word because each write operation emits an extra SLOAD to first read the
35     // slot's contents, replace the bits taken up by the boolean, and then write
36     // back. This is the compiler's defense against contract upgrades and
37     // pointer aliasing, and it cannot be disabled.
38 
39     // The values being non-zero value makes deployment a bit more expensive,
40     // but in exchange the refund on every call to nonReentrant will be lower in
41     // amount. Since refunds are capped to a percentage of the total
42     // transaction's gas, it is best to keep them low in cases like this one, to
43     // increase the likelihood of the full refund coming into effect.
44     uint256 private constant _NOT_ENTERED = 1;
45     uint256 private constant _ENTERED = 2;
46 
47     uint256 private _status;
48 
49     constructor() {
50         _status = _NOT_ENTERED;
51     }
52 
53     /**
54      * @dev Prevents a contract from calling itself, directly or indirectly.
55      * Calling a `nonReentrant` function from another `nonReentrant`
56      * function is not supported. It is possible to prevent this from happening
57      * by making the `nonReentrant` function external, and make it call a
58      * `private` function that does the actual work.
59      */
60     modifier nonReentrant() {
61         // On the first call to nonReentrant, _notEntered will be true
62         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
63 
64         // Any calls to nonReentrant after this point will fail
65         _status = _ENTERED;
66 
67         _;
68 
69         // By storing the original value once again, a refund is triggered (see
70         // https://eips.ethereum.org/EIPS/eip-2200)
71         _status = _NOT_ENTERED;
72     }
73 }
74 
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 
103 // File: @openzeppelin/contracts/security/Pausable.sol
104 
105 
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Contract module which allows children to implement an emergency stop
112  * mechanism that can be triggered by an authorized account.
113  *
114  * This module is used through inheritance. It will make available the
115  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
116  * the functions of your contract. Note that they will not be pausable by
117  * simply including this module, only once the modifiers are put in place.
118  */
119 abstract contract Pausable is Context {
120     /**
121      * @dev Emitted when the pause is triggered by `account`.
122      */
123     event Paused(address account);
124 
125     /**
126      * @dev Emitted when the pause is lifted by `account`.
127      */
128     event Unpaused(address account);
129 
130     bool private _paused;
131 
132     /**
133      * @dev Initializes the contract in unpaused state.
134      */
135     constructor() {
136         _paused = false;
137     }
138 
139     /**
140      * @dev Returns true if the contract is paused, and false otherwise.
141      */
142     function paused() public view virtual returns (bool) {
143         return _paused;
144     }
145 
146     /**
147      * @dev Modifier to make a function callable only when the contract is not paused.
148      *
149      * Requirements:
150      *
151      * - The contract must not be paused.
152      */
153     modifier whenNotPaused() {
154         require(!paused(), "Pausable: paused");
155         _;
156     }
157 
158     /**
159      * @dev Modifier to make a function callable only when the contract is paused.
160      *
161      * Requirements:
162      *
163      * - The contract must be paused.
164      */
165     modifier whenPaused() {
166         require(paused(), "Pausable: not paused");
167         _;
168     }
169 
170     /**
171      * @dev Triggers stopped state.
172      *
173      * Requirements:
174      *
175      * - The contract must not be paused.
176      */
177     function _pause() internal virtual whenNotPaused {
178         _paused = true;
179         emit Paused(_msgSender());
180     }
181 
182     /**
183      * @dev Returns to normal state.
184      *
185      * Requirements:
186      *
187      * - The contract must be paused.
188      */
189     function _unpause() internal virtual whenPaused {
190         _paused = false;
191         emit Unpaused(_msgSender());
192     }
193 }
194 
195 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
196 
197 
198 
199 pragma solidity ^0.8.0;
200 
201 // CAUTION
202 // This version of SafeMath should only be used with Solidity 0.8 or later,
203 // because it relies on the compiler's built in overflow checks.
204 
205 /**
206  * @dev Wrappers over Solidity's arithmetic operations.
207  *
208  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
209  * now has built in overflow checking.
210  */
211 library SafeMath {
212     /**
213      * @dev Returns the addition of two unsigned integers, with an overflow flag.
214      *
215      * _Available since v3.4._
216      */
217     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
218         unchecked {
219             uint256 c = a + b;
220             if (c < a) return (false, 0);
221             return (true, c);
222         }
223     }
224 
225     /**
226      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
227      *
228      * _Available since v3.4._
229      */
230     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
231         unchecked {
232             if (b > a) return (false, 0);
233             return (true, a - b);
234         }
235     }
236 
237     /**
238      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
239      *
240      * _Available since v3.4._
241      */
242     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
243         unchecked {
244             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
245             // benefit is lost if 'b' is also tested.
246             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
247             if (a == 0) return (true, 0);
248             uint256 c = a * b;
249             if (c / a != b) return (false, 0);
250             return (true, c);
251         }
252     }
253 
254     /**
255      * @dev Returns the division of two unsigned integers, with a division by zero flag.
256      *
257      * _Available since v3.4._
258      */
259     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             if (b == 0) return (false, 0);
262             return (true, a / b);
263         }
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
268      *
269      * _Available since v3.4._
270      */
271     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
272         unchecked {
273             if (b == 0) return (false, 0);
274             return (true, a % b);
275         }
276     }
277 
278     /**
279      * @dev Returns the addition of two unsigned integers, reverting on
280      * overflow.
281      *
282      * Counterpart to Solidity's `+` operator.
283      *
284      * Requirements:
285      *
286      * - Addition cannot overflow.
287      */
288     function add(uint256 a, uint256 b) internal pure returns (uint256) {
289         return a + b;
290     }
291 
292     /**
293      * @dev Returns the subtraction of two unsigned integers, reverting on
294      * overflow (when the result is negative).
295      *
296      * Counterpart to Solidity's `-` operator.
297      *
298      * Requirements:
299      *
300      * - Subtraction cannot overflow.
301      */
302     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a - b;
304     }
305 
306     /**
307      * @dev Returns the multiplication of two unsigned integers, reverting on
308      * overflow.
309      *
310      * Counterpart to Solidity's `*` operator.
311      *
312      * Requirements:
313      *
314      * - Multiplication cannot overflow.
315      */
316     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
317         return a * b;
318     }
319 
320     /**
321      * @dev Returns the integer division of two unsigned integers, reverting on
322      * division by zero. The result is rounded towards zero.
323      *
324      * Counterpart to Solidity's `/` operator.
325      *
326      * Requirements:
327      *
328      * - The divisor cannot be zero.
329      */
330     function div(uint256 a, uint256 b) internal pure returns (uint256) {
331         return a / b;
332     }
333 
334     /**
335      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
336      * reverting when dividing by zero.
337      *
338      * Counterpart to Solidity's `%` operator. This function uses a `revert`
339      * opcode (which leaves remaining gas untouched) while Solidity uses an
340      * invalid opcode to revert (consuming all remaining gas).
341      *
342      * Requirements:
343      *
344      * - The divisor cannot be zero.
345      */
346     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
347         return a % b;
348     }
349 
350     /**
351      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
352      * overflow (when the result is negative).
353      *
354      * CAUTION: This function is deprecated because it requires allocating memory for the error
355      * message unnecessarily. For custom revert reasons use {trySub}.
356      *
357      * Counterpart to Solidity's `-` operator.
358      *
359      * Requirements:
360      *
361      * - Subtraction cannot overflow.
362      */
363     function sub(
364         uint256 a,
365         uint256 b,
366         string memory errorMessage
367     ) internal pure returns (uint256) {
368         unchecked {
369             require(b <= a, errorMessage);
370             return a - b;
371         }
372     }
373 
374     /**
375      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
376      * division by zero. The result is rounded towards zero.
377      *
378      * Counterpart to Solidity's `/` operator. Note: this function uses a
379      * `revert` opcode (which leaves remaining gas untouched) while Solidity
380      * uses an invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function div(
387         uint256 a,
388         uint256 b,
389         string memory errorMessage
390     ) internal pure returns (uint256) {
391         unchecked {
392             require(b > 0, errorMessage);
393             return a / b;
394         }
395     }
396 
397     /**
398      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
399      * reverting with custom message when dividing by zero.
400      *
401      * CAUTION: This function is deprecated because it requires allocating memory for the error
402      * message unnecessarily. For custom revert reasons use {tryMod}.
403      *
404      * Counterpart to Solidity's `%` operator. This function uses a `revert`
405      * opcode (which leaves remaining gas untouched) while Solidity uses an
406      * invalid opcode to revert (consuming all remaining gas).
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function mod(
413         uint256 a,
414         uint256 b,
415         string memory errorMessage
416     ) internal pure returns (uint256) {
417         unchecked {
418             require(b > 0, errorMessage);
419             return a % b;
420         }
421     }
422 }
423 
424 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
425 
426 
427 
428 pragma solidity ^0.8.0;
429 
430 
431 
432 
433 /**
434  * @title PaymentSplitter
435  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
436  * that the Ether will be split in this way, since it is handled transparently by the contract.
437  *
438  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
439  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
440  * an amount proportional to the percentage of total shares they were assigned.
441  *
442  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
443  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
444  * function.
445  */
446 contract PaymentSplitter is Context {
447     event PayeeAdded(address account, uint256 shares);
448     event PaymentReleased(address to, uint256 amount);
449     event PaymentReceived(address from, uint256 amount);
450 
451     uint256 private _totalShares;
452     uint256 private _totalReleased;
453 
454     mapping(address => uint256) private _shares;
455     mapping(address => uint256) private _released;
456     address[] private _payees;
457 
458     /**
459      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
460      * the matching position in the `shares` array.
461      *
462      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
463      * duplicates in `payees`.
464      */
465     constructor(address[] memory payees, uint256[] memory shares_) payable {
466         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
467         require(payees.length > 0, "PaymentSplitter: no payees");
468 
469         for (uint256 i = 0; i < payees.length; i++) {
470             _addPayee(payees[i], shares_[i]);
471         }
472     }
473 
474     /**
475      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
476      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
477      * reliability of the events, and not the actual splitting of Ether.
478      *
479      * To learn more about this see the Solidity documentation for
480      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
481      * functions].
482      */
483     receive() external payable virtual {
484         emit PaymentReceived(_msgSender(), msg.value);
485     }
486 
487     /**
488      * @dev Getter for the total shares held by payees.
489      */
490     function totalShares() public view returns (uint256) {
491         return _totalShares;
492     }
493 
494     /**
495      * @dev Getter for the total amount of Ether already released.
496      */
497     function totalReleased() public view returns (uint256) {
498         return _totalReleased;
499     }
500 
501     /**
502      * @dev Getter for the amount of shares held by an account.
503      */
504     function shares(address account) public view returns (uint256) {
505         return _shares[account];
506     }
507 
508     /**
509      * @dev Getter for the amount of Ether already released to a payee.
510      */
511     function released(address account) public view returns (uint256) {
512         return _released[account];
513     }
514 
515     /**
516      * @dev Getter for the address of the payee number `index`.
517      */
518     function payee(uint256 index) public view returns (address) {
519         return _payees[index];
520     }
521 
522     /**
523      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
524      * total shares and their previous withdrawals.
525      */
526     function release(address payable account) public virtual {
527         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
528 
529         uint256 totalReceived = address(this).balance + _totalReleased;
530         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
531 
532         require(payment != 0, "PaymentSplitter: account is not due payment");
533 
534         _released[account] = _released[account] + payment;
535         _totalReleased = _totalReleased + payment;
536 
537         Address.sendValue(account, payment);
538         emit PaymentReleased(account, payment);
539     }
540 
541     /**
542      * @dev Add a new payee to the contract.
543      * @param account The address of the payee to add.
544      * @param shares_ The number of shares owned by the payee.
545      */
546     function _addPayee(address account, uint256 shares_) private {
547         require(account != address(0), "PaymentSplitter: account is the zero address");
548         require(shares_ > 0, "PaymentSplitter: shares are 0");
549         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
550 
551         _payees.push(account);
552         _shares[account] = shares_;
553         _totalShares = _totalShares + shares_;
554         emit PayeeAdded(account, shares_);
555     }
556 }
557 
558 // File: @openzeppelin/contracts/access/Ownable.sol
559 
560 
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @dev Contract module which provides a basic access control mechanism, where
567  * there is an account (an owner) that can be granted exclusive access to
568  * specific functions.
569  *
570  * By default, the owner account will be the one that deploys the contract. This
571  * can later be changed with {transferOwnership}.
572  *
573  * This module is used through inheritance. It will make available the modifier
574  * `onlyOwner`, which can be applied to your functions to restrict their use to
575  * the owner.
576  */
577 abstract contract Ownable is Context {
578     address private _owner;
579 
580     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
581 
582     /**
583      * @dev Initializes the contract setting the deployer as the initial owner.
584      */
585     constructor() {
586         _setOwner(_msgSender());
587     }
588 
589     /**
590      * @dev Returns the address of the current owner.
591      */
592     function owner() public view virtual returns (address) {
593         return _owner;
594     }
595 
596     /**
597      * @dev Throws if called by any account other than the owner.
598      */
599     modifier onlyOwner() {
600         require(owner() == _msgSender(), "Ownable: caller is not the owner");
601         _;
602     }
603 
604     /**
605      * @dev Leaves the contract without owner. It will not be possible to call
606      * `onlyOwner` functions anymore. Can only be called by the current owner.
607      *
608      * NOTE: Renouncing ownership will leave the contract without an owner,
609      * thereby removing any functionality that is only available to the owner.
610      */
611     function renounceOwnership() public virtual onlyOwner {
612         _setOwner(address(0));
613     }
614 
615     /**
616      * @dev Transfers ownership of the contract to a new account (`newOwner`).
617      * Can only be called by the current owner.
618      */
619     function transferOwnership(address newOwner) public virtual onlyOwner {
620         require(newOwner != address(0), "Ownable: new owner is the zero address");
621         _setOwner(newOwner);
622     }
623 
624     function _setOwner(address newOwner) private {
625         address oldOwner = _owner;
626         _owner = newOwner;
627         emit OwnershipTransferred(oldOwner, newOwner);
628     }
629 }
630 
631 
632 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
633 
634 
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Interface of the ERC165 standard, as defined in the
640  * https://eips.ethereum.org/EIPS/eip-165[EIP].
641  *
642  * Implementers can declare support of contract interfaces, which can then be
643  * queried by others ({ERC165Checker}).
644  *
645  * For an implementation, see {ERC165}.
646  */
647 interface IERC165 {
648     /**
649      * @dev Returns true if this contract implements the interface defined by
650      * `interfaceId`. See the corresponding
651      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
652      * to learn more about how these ids are created.
653      *
654      * This function call must use less than 30 000 gas.
655      */
656     function supportsInterface(bytes4 interfaceId) external view returns (bool);
657 }
658 
659 
660 
661 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
662 
663 
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @dev Required interface of an ERC721 compliant contract.
670  */
671 interface IERC721 is IERC165 {
672     /**
673      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
674      */
675     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
676 
677     /**
678      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
679      */
680     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
681 
682     /**
683      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
684      */
685     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
686 
687     /**
688      * @dev Returns the number of tokens in ``owner``'s account.
689      */
690     function balanceOf(address owner) external view returns (uint256 balance);
691 
692     /**
693      * @dev Returns the owner of the `tokenId` token.
694      *
695      * Requirements:
696      *
697      * - `tokenId` must exist.
698      */
699     function ownerOf(uint256 tokenId) external view returns (address owner);
700 
701     /**
702      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
703      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) external;
720 
721     /**
722      * @dev Transfers `tokenId` token from `from` to `to`.
723      *
724      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
725      *
726      * Requirements:
727      *
728      * - `from` cannot be the zero address.
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must be owned by `from`.
731      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
732      *
733      * Emits a {Transfer} event.
734      */
735     function transferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) external;
740 
741     /**
742      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
743      * The approval is cleared when the token is transferred.
744      *
745      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
746      *
747      * Requirements:
748      *
749      * - The caller must own the token or be an approved operator.
750      * - `tokenId` must exist.
751      *
752      * Emits an {Approval} event.
753      */
754     function approve(address to, uint256 tokenId) external;
755 
756     /**
757      * @dev Returns the account approved for `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function getApproved(uint256 tokenId) external view returns (address operator);
764 
765     /**
766      * @dev Approve or remove `operator` as an operator for the caller.
767      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
768      *
769      * Requirements:
770      *
771      * - The `operator` cannot be the caller.
772      *
773      * Emits an {ApprovalForAll} event.
774      */
775     function setApprovalForAll(address operator, bool _approved) external;
776 
777     /**
778      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
779      *
780      * See {setApprovalForAll}
781      */
782     function isApprovedForAll(address owner, address operator) external view returns (bool);
783 
784     /**
785      * @dev Safely transfers `tokenId` token from `from` to `to`.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
794      *
795      * Emits a {Transfer} event.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId,
801         bytes calldata data
802     ) external;
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
835 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
836 
837 
838 
839 pragma solidity ^0.8.0;
840 
841 
842 /**
843  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
844  * @dev See https://eips.ethereum.org/EIPS/eip-721
845  */
846 interface IERC721Metadata is IERC721 {
847     /**
848      * @dev Returns the token collection name.
849      */
850     function name() external view returns (string memory);
851 
852     /**
853      * @dev Returns the token collection symbol.
854      */
855     function symbol() external view returns (string memory);
856 
857     /**
858      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
859      */
860     function tokenURI(uint256 tokenId) external view returns (string memory);
861 }
862 
863 
864 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
865 
866 pragma solidity ^0.8.0;
867 
868 /**
869  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
870  * the Metadata extension, but not including the Enumerable extension, which is available separately as
871  * {ERC721Enumerable}.
872  */
873 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
874     using Address for address;
875     using Strings for uint256;
876 
877     // Token name
878     string private _name;
879 
880     // Token symbol
881     string private _symbol;
882 
883     // Mapping from token ID to owner address
884     mapping(uint256 => address) private _owners;
885 
886     // Mapping owner address to token count
887     mapping(address => uint256) private _balances;
888 
889     // Mapping from token ID to approved address
890     mapping(uint256 => address) private _tokenApprovals;
891 
892     // Mapping from owner to operator approvals
893     mapping(address => mapping(address => bool)) private _operatorApprovals;
894 
895     /**
896      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
897      */
898     constructor(string memory name_, string memory symbol_) {
899         _name = name_;
900         _symbol = symbol_;
901     }
902 
903     /**
904      * @dev See {IERC165-supportsInterface}.
905      */
906     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
907         return
908             interfaceId == type(IERC721).interfaceId ||
909             interfaceId == type(IERC721Metadata).interfaceId ||
910             super.supportsInterface(interfaceId);
911     }
912 
913     /**
914      * @dev See {IERC721-balanceOf}.
915      */
916     function balanceOf(address owner) public view virtual override returns (uint256) {
917         require(owner != address(0), "ERC721: balance query for the zero address");
918         return _balances[owner];
919     }
920 
921     /**
922      * @dev See {IERC721-ownerOf}.
923      */
924     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
925         address owner = _owners[tokenId];
926         require(owner != address(0), "ERC721: owner query for nonexistent token");
927         return owner;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-name}.
932      */
933     function name() public view virtual override returns (string memory) {
934         return _name;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-symbol}.
939      */
940     function symbol() public view virtual override returns (string memory) {
941         return _symbol;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-tokenURI}.
946      */
947     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
948         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
949 
950         string memory baseURI = _baseURI();
951         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
952     }
953 
954     /**
955      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
956      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
957      * by default, can be overriden in child contracts.
958      */
959     function _baseURI() internal view virtual returns (string memory) {
960         return "";
961     }
962 
963     /**
964      * @dev See {IERC721-approve}.
965      */
966     function approve(address to, uint256 tokenId) public virtual override {
967         address owner = ERC721.ownerOf(tokenId);
968         require(to != owner, "ERC721: approval to current owner");
969 
970         require(
971             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
972             "ERC721: approve caller is not owner nor approved for all"
973         );
974 
975         _approve(to, tokenId);
976     }
977 
978     /**
979      * @dev See {IERC721-getApproved}.
980      */
981     function getApproved(uint256 tokenId) public view virtual override returns (address) {
982         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
983 
984         return _tokenApprovals[tokenId];
985     }
986 
987     /**
988      * @dev See {IERC721-setApprovalForAll}.
989      */
990     function setApprovalForAll(address operator, bool approved) public virtual override {
991         require(operator != _msgSender(), "ERC721: approve to caller");
992 
993         _operatorApprovals[_msgSender()][operator] = approved;
994         emit ApprovalForAll(_msgSender(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-isApprovedForAll}.
999      */
1000     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1001         return _operatorApprovals[owner][operator];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-transferFrom}.
1006      */
1007     function transferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         //solhint-disable-next-line max-line-length
1013         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1014 
1015         _transfer(from, to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         safeTransferFrom(from, to, tokenId, "");
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) public virtual override {
1038         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1039         _safeTransfer(from, to, tokenId, _data);
1040     }
1041 
1042     /**
1043      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1044      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1045      *
1046      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1047      *
1048      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1049      * implement alternative mechanisms to perform token transfer, such as signature-based.
1050      *
1051      * Requirements:
1052      *
1053      * - `from` cannot be the zero address.
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must exist and be owned by `from`.
1056      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _safeTransfer(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) internal virtual {
1066         _transfer(from, to, tokenId);
1067         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1068     }
1069 
1070     /**
1071      * @dev Returns whether `tokenId` exists.
1072      *
1073      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1074      *
1075      * Tokens start existing when they are minted (`_mint`),
1076      * and stop existing when they are burned (`_burn`).
1077      */
1078     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1079         return _owners[tokenId] != address(0);
1080     }
1081 
1082     /**
1083      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must exist.
1088      */
1089     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1090         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1091         address owner = ERC721.ownerOf(tokenId);
1092         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1093     }
1094 
1095     /**
1096      * @dev Safely mints `tokenId` and transfers it to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must not exist.
1101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _safeMint(address to, uint256 tokenId) internal virtual {
1106         _safeMint(to, tokenId, "");
1107     }
1108 
1109     /**
1110      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1111      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1112      */
1113     function _safeMint(
1114         address to,
1115         uint256 tokenId,
1116         bytes memory _data
1117     ) internal virtual {
1118         _mint(to, tokenId);
1119         require(
1120             _checkOnERC721Received(address(0), to, tokenId, _data),
1121             "ERC721: transfer to non ERC721Receiver implementer"
1122         );
1123     }
1124 
1125     /**
1126      * @dev Mints `tokenId` and transfers it to `to`.
1127      *
1128      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1129      *
1130      * Requirements:
1131      *
1132      * - `tokenId` must not exist.
1133      * - `to` cannot be the zero address.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _mint(address to, uint256 tokenId) internal virtual {
1138         require(to != address(0), "ERC721: mint to the zero address");
1139         require(!_exists(tokenId), "ERC721: token already minted");
1140 
1141         _beforeTokenTransfer(address(0), to, tokenId);
1142 
1143         _balances[to] += 1;
1144         _owners[tokenId] = to;
1145 
1146         emit Transfer(address(0), to, tokenId);
1147     }
1148 
1149     /**
1150      * @dev Destroys `tokenId`.
1151      * The approval is cleared when the token is burned.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _burn(uint256 tokenId) internal virtual {
1160         address owner = ERC721.ownerOf(tokenId);
1161 
1162         _beforeTokenTransfer(owner, address(0), tokenId);
1163 
1164         // Clear approvals
1165         _approve(address(0), tokenId);
1166 
1167         _balances[owner] -= 1;
1168         delete _owners[tokenId];
1169 
1170         emit Transfer(owner, address(0), tokenId);
1171     }
1172 
1173     /**
1174      * @dev Transfers `tokenId` from `from` to `to`.
1175      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1176      *
1177      * Requirements:
1178      *
1179      * - `to` cannot be the zero address.
1180      * - `tokenId` token must be owned by `from`.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _transfer(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) internal virtual {
1189         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1190         require(to != address(0), "ERC721: transfer to the zero address");
1191 
1192         _beforeTokenTransfer(from, to, tokenId);
1193 
1194         // Clear approvals from the previous owner
1195         _approve(address(0), tokenId);
1196 
1197         _balances[from] -= 1;
1198         _balances[to] += 1;
1199         _owners[tokenId] = to;
1200 
1201         emit Transfer(from, to, tokenId);
1202     }
1203 
1204     /**
1205      * @dev Approve `to` to operate on `tokenId`
1206      *
1207      * Emits a {Approval} event.
1208      */
1209     function _approve(address to, uint256 tokenId) internal virtual {
1210         _tokenApprovals[tokenId] = to;
1211         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1212     }
1213 
1214     /**
1215      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1216      * The call is not executed if the target address is not a contract.
1217      *
1218      * @param from address representing the previous owner of the given token ID
1219      * @param to target address that will receive the tokens
1220      * @param tokenId uint256 ID of the token to be transferred
1221      * @param _data bytes optional data to send along with the call
1222      * @return bool whether the call correctly returned the expected magic value
1223      */
1224     function _checkOnERC721Received(
1225         address from,
1226         address to,
1227         uint256 tokenId,
1228         bytes memory _data
1229     ) private returns (bool) {
1230         if (to.isContract()) {
1231             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1232                 return retval == IERC721Receiver.onERC721Received.selector;
1233             } catch (bytes memory reason) {
1234                 if (reason.length == 0) {
1235                     revert("ERC721: transfer to non ERC721Receiver implementer");
1236                 } else {
1237                     assembly {
1238                         revert(add(32, reason), mload(reason))
1239                     }
1240                 }
1241             }
1242         } else {
1243             return true;
1244         }
1245     }
1246 
1247     /**
1248      * @dev Hook that is called before any token transfer. This includes minting
1249      * and burning.
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` will be minted for `to`.
1256      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1257      * - `from` and `to` are never both zero.
1258      *
1259      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1260      */
1261     function _beforeTokenTransfer(
1262         address from,
1263         address to,
1264         uint256 tokenId
1265     ) internal virtual {}
1266 }
1267 
1268 
1269 
1270 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1271 
1272 
1273 
1274 pragma solidity ^0.8.0;
1275 
1276 
1277 /**
1278  * @dev ERC721 token with storage based token URI management.
1279  */
1280 abstract contract ERC721URIStorage is ERC721 {
1281     using Strings for uint256;
1282 
1283     // Optional mapping for token URIs
1284     mapping(uint256 => string) private _tokenURIs;
1285 
1286     /**
1287      * @dev See {IERC721Metadata-tokenURI}.
1288      */
1289     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1290         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1291 
1292         string memory _tokenURI = _tokenURIs[tokenId];
1293         string memory base = _baseURI();
1294 
1295         // If there is no base URI, return the token URI.
1296         if (bytes(base).length == 0) {
1297             return _tokenURI;
1298         }
1299         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1300         if (bytes(_tokenURI).length > 0) {
1301             return string(abi.encodePacked(base, _tokenURI));
1302         }
1303 
1304         return super.tokenURI(tokenId);
1305     }
1306 
1307     /**
1308      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1309      *
1310      * Requirements:
1311      *
1312      * - `tokenId` must exist.
1313      */
1314     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1315         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1316         _tokenURIs[tokenId] = _tokenURI;
1317     }
1318 
1319     /**
1320      * @dev Destroys `tokenId`.
1321      * The approval is cleared when the token is burned.
1322      *
1323      * Requirements:
1324      *
1325      * - `tokenId` must exist.
1326      *
1327      * Emits a {Transfer} event.
1328      */
1329     function _burn(uint256 tokenId) internal virtual override {
1330         super._burn(tokenId);
1331 
1332         if (bytes(_tokenURIs[tokenId]).length != 0) {
1333             delete _tokenURIs[tokenId];
1334         }
1335     }
1336 }
1337 
1338 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1339 
1340 
1341 
1342 pragma solidity ^0.8.0;
1343 
1344 
1345 /**
1346  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1347  * @dev See https://eips.ethereum.org/EIPS/eip-721
1348  */
1349 interface IERC721Enumerable is IERC721 {
1350     /**
1351      * @dev Returns the total amount of tokens stored by the contract.
1352      */
1353     function totalSupply() external view returns (uint256);
1354 
1355     /**
1356      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1357      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1358      */
1359     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1360 
1361     /**
1362      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1363      * Use along with {totalSupply} to enumerate all tokens.
1364      */
1365     function tokenByIndex(uint256 index) external view returns (uint256);
1366 }
1367 
1368 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1369 
1370 
1371 
1372 pragma solidity ^0.8.0;
1373 
1374 
1375 
1376 /**
1377  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1378  * enumerability of all the token ids in the contract as well as all token ids owned by each
1379  * account.
1380  */
1381 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1382     // Mapping from owner to list of owned token IDs
1383     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1384 
1385     // Mapping from token ID to index of the owner tokens list
1386     mapping(uint256 => uint256) private _ownedTokensIndex;
1387 
1388     // Array with all token ids, used for enumeration
1389     uint256[] private _allTokens;
1390 
1391     // Mapping from token id to position in the allTokens array
1392     mapping(uint256 => uint256) private _allTokensIndex;
1393 
1394     /**
1395      * @dev See {IERC165-supportsInterface}.
1396      */
1397     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1398         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1399     }
1400 
1401     /**
1402      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1403      */
1404     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1405         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1406         return _ownedTokens[owner][index];
1407     }
1408 
1409     /**
1410      * @dev See {IERC721Enumerable-totalSupply}.
1411      */
1412     function totalSupply() public view virtual override returns (uint256) {
1413         return _allTokens.length;
1414     }
1415 
1416     /**
1417      * @dev See {IERC721Enumerable-tokenByIndex}.
1418      */
1419     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1420         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1421         return _allTokens[index];
1422     }
1423 
1424     /**
1425      * @dev Hook that is called before any token transfer. This includes minting
1426      * and burning.
1427      *
1428      * Calling conditions:
1429      *
1430      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1431      * transferred to `to`.
1432      * - When `from` is zero, `tokenId` will be minted for `to`.
1433      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1434      * - `from` cannot be the zero address.
1435      * - `to` cannot be the zero address.
1436      *
1437      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1438      */
1439     function _beforeTokenTransfer(
1440         address from,
1441         address to,
1442         uint256 tokenId
1443     ) internal virtual override {
1444         super._beforeTokenTransfer(from, to, tokenId);
1445 
1446         if (from == address(0)) {
1447             _addTokenToAllTokensEnumeration(tokenId);
1448         } else if (from != to) {
1449             _removeTokenFromOwnerEnumeration(from, tokenId);
1450         }
1451         if (to == address(0)) {
1452             _removeTokenFromAllTokensEnumeration(tokenId);
1453         } else if (to != from) {
1454             _addTokenToOwnerEnumeration(to, tokenId);
1455         }
1456     }
1457 
1458     /**
1459      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1460      * @param to address representing the new owner of the given token ID
1461      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1462      */
1463     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1464         uint256 length = ERC721.balanceOf(to);
1465         _ownedTokens[to][length] = tokenId;
1466         _ownedTokensIndex[tokenId] = length;
1467     }
1468 
1469     /**
1470      * @dev Private function to add a token to this extension's token tracking data structures.
1471      * @param tokenId uint256 ID of the token to be added to the tokens list
1472      */
1473     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1474         _allTokensIndex[tokenId] = _allTokens.length;
1475         _allTokens.push(tokenId);
1476     }
1477 
1478     /**
1479      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1480      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1481      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1482      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1483      * @param from address representing the previous owner of the given token ID
1484      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1485      */
1486     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1487         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1488         // then delete the last slot (swap and pop).
1489 
1490         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1491         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1492 
1493         // When the token to delete is the last token, the swap operation is unnecessary
1494         if (tokenIndex != lastTokenIndex) {
1495             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1496 
1497             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1498             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1499         }
1500 
1501         // This also deletes the contents at the last position of the array
1502         delete _ownedTokensIndex[tokenId];
1503         delete _ownedTokens[from][lastTokenIndex];
1504     }
1505 
1506     /**
1507      * @dev Private function to remove a token from this extension's token tracking data structures.
1508      * This has O(1) time complexity, but alters the order of the _allTokens array.
1509      * @param tokenId uint256 ID of the token to be removed from the tokens list
1510      */
1511     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1512         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1513         // then delete the last slot (swap and pop).
1514 
1515         uint256 lastTokenIndex = _allTokens.length - 1;
1516         uint256 tokenIndex = _allTokensIndex[tokenId];
1517 
1518         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1519         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1520         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1521         uint256 lastTokenId = _allTokens[lastTokenIndex];
1522 
1523         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1524         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1525 
1526         // This also deletes the contents at the last position of the array
1527         delete _allTokensIndex[tokenId];
1528         _allTokens.pop();
1529     }
1530 }
1531 
1532 
1533 // File: @openzeppelin/contracts/utils/Strings.sol
1534 
1535 
1536 pragma solidity ^0.8.0;
1537 
1538 /**
1539  * @dev String operations.
1540  */
1541 library Strings {
1542     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1543 
1544     /**
1545      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1546      */
1547     function toString(uint256 value) internal pure returns (string memory) {
1548         // Inspired by OraclizeAPI's implementation - MIT licence
1549         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1550 
1551         if (value == 0) {
1552             return "0";
1553         }
1554         uint256 temp = value;
1555         uint256 digits;
1556         while (temp != 0) {
1557             digits++;
1558             temp /= 10;
1559         }
1560         bytes memory buffer = new bytes(digits);
1561         while (value != 0) {
1562             digits -= 1;
1563             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1564             value /= 10;
1565         }
1566         return string(buffer);
1567     }
1568 
1569     /**
1570      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1571      */
1572     function toHexString(uint256 value) internal pure returns (string memory) {
1573         if (value == 0) {
1574             return "0x00";
1575         }
1576         uint256 temp = value;
1577         uint256 length = 0;
1578         while (temp != 0) {
1579             length++;
1580             temp >>= 8;
1581         }
1582         return toHexString(value, length);
1583     }
1584 
1585     /**
1586      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1587      */
1588     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1589         bytes memory buffer = new bytes(2 * length + 2);
1590         buffer[0] = "0";
1591         buffer[1] = "x";
1592         for (uint256 i = 2 * length + 1; i > 1; --i) {
1593             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1594             value >>= 4;
1595         }
1596         require(value == 0, "Strings: hex length insufficient");
1597         return string(buffer);
1598     }
1599 }
1600 
1601 // File: @openzeppelin/contracts/utils/Address.sol
1602 
1603 
1604 
1605 pragma solidity ^0.8.0;
1606 
1607 /**
1608  * @dev Collection of functions related to the address type
1609  */
1610 library Address {
1611     /**
1612      * @dev Returns true if `account` is a contract.
1613      *
1614      * [IMPORTANT]
1615      * ====
1616      * It is unsafe to assume that an address for which this function returns
1617      * false is an externally-owned account (EOA) and not a contract.
1618      *
1619      * Among others, `isContract` will return false for the following
1620      * types of addresses:
1621      *
1622      *  - an externally-owned account
1623      *  - a contract in construction
1624      *  - an address where a contract will be created
1625      *  - an address where a contract lived, but was destroyed
1626      * ====
1627      */
1628     function isContract(address account) internal view returns (bool) {
1629         // This method relies on extcodesize, which returns 0 for contracts in
1630         // construction, since the code is only stored at the end of the
1631         // constructor execution.
1632 
1633         uint256 size;
1634         assembly {
1635             size := extcodesize(account)
1636         }
1637         return size > 0;
1638     }
1639 
1640     /**
1641      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1642      * `recipient`, forwarding all available gas and reverting on errors.
1643      *
1644      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1645      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1646      * imposed by `transfer`, making them unable to receive funds via
1647      * `transfer`. {sendValue} removes this limitation.
1648      *
1649      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1650      *
1651      * IMPORTANT: because control is transferred to `recipient`, care must be
1652      * taken to not create reentrancy vulnerabilities. Consider using
1653      * {ReentrancyGuard} or the
1654      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1655      */
1656     function sendValue(address payable recipient, uint256 amount) internal {
1657         require(address(this).balance >= amount, "Address: insufficient balance");
1658 
1659         (bool success, ) = recipient.call{value: amount}("");
1660         require(success, "Address: unable to send value, recipient may have reverted");
1661     }
1662 
1663     /**
1664      * @dev Performs a Solidity function call using a low level `call`. A
1665      * plain `call` is an unsafe replacement for a function call: use this
1666      * function instead.
1667      *
1668      * If `target` reverts with a revert reason, it is bubbled up by this
1669      * function (like regular Solidity function calls).
1670      *
1671      * Returns the raw returned data. To convert to the expected return value,
1672      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1673      *
1674      * Requirements:
1675      *
1676      * - `target` must be a contract.
1677      * - calling `target` with `data` must not revert.
1678      *
1679      * _Available since v3.1._
1680      */
1681     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1682         return functionCall(target, data, "Address: low-level call failed");
1683     }
1684 
1685     /**
1686      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1687      * `errorMessage` as a fallback revert reason when `target` reverts.
1688      *
1689      * _Available since v3.1._
1690      */
1691     function functionCall(
1692         address target,
1693         bytes memory data,
1694         string memory errorMessage
1695     ) internal returns (bytes memory) {
1696         return functionCallWithValue(target, data, 0, errorMessage);
1697     }
1698 
1699     /**
1700      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1701      * but also transferring `value` wei to `target`.
1702      *
1703      * Requirements:
1704      *
1705      * - the calling contract must have an ETH balance of at least `value`.
1706      * - the called Solidity function must be `payable`.
1707      *
1708      * _Available since v3.1._
1709      */
1710     function functionCallWithValue(
1711         address target,
1712         bytes memory data,
1713         uint256 value
1714     ) internal returns (bytes memory) {
1715         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1716     }
1717 
1718     /**
1719      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1720      * with `errorMessage` as a fallback revert reason when `target` reverts.
1721      *
1722      * _Available since v3.1._
1723      */
1724     function functionCallWithValue(
1725         address target,
1726         bytes memory data,
1727         uint256 value,
1728         string memory errorMessage
1729     ) internal returns (bytes memory) {
1730         require(address(this).balance >= value, "Address: insufficient balance for call");
1731         require(isContract(target), "Address: call to non-contract");
1732 
1733         (bool success, bytes memory returndata) = target.call{value: value}(data);
1734         return verifyCallResult(success, returndata, errorMessage);
1735     }
1736 
1737     /**
1738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1739      * but performing a static call.
1740      *
1741      * _Available since v3.3._
1742      */
1743     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1744         return functionStaticCall(target, data, "Address: low-level static call failed");
1745     }
1746 
1747     /**
1748      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1749      * but performing a static call.
1750      *
1751      * _Available since v3.3._
1752      */
1753     function functionStaticCall(
1754         address target,
1755         bytes memory data,
1756         string memory errorMessage
1757     ) internal view returns (bytes memory) {
1758         require(isContract(target), "Address: static call to non-contract");
1759 
1760         (bool success, bytes memory returndata) = target.staticcall(data);
1761         return verifyCallResult(success, returndata, errorMessage);
1762     }
1763 
1764     /**
1765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1766      * but performing a delegate call.
1767      *
1768      * _Available since v3.4._
1769      */
1770     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1771         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1772     }
1773 
1774     /**
1775      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1776      * but performing a delegate call.
1777      *
1778      * _Available since v3.4._
1779      */
1780     function functionDelegateCall(
1781         address target,
1782         bytes memory data,
1783         string memory errorMessage
1784     ) internal returns (bytes memory) {
1785         require(isContract(target), "Address: delegate call to non-contract");
1786 
1787         (bool success, bytes memory returndata) = target.delegatecall(data);
1788         return verifyCallResult(success, returndata, errorMessage);
1789     }
1790 
1791     /**
1792      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1793      * revert reason using the provided one.
1794      *
1795      * _Available since v4.3._
1796      */
1797     function verifyCallResult(
1798         bool success,
1799         bytes memory returndata,
1800         string memory errorMessage
1801     ) internal pure returns (bytes memory) {
1802         if (success) {
1803             return returndata;
1804         } else {
1805             // Look for revert reason and bubble it up if present
1806             if (returndata.length > 0) {
1807                 // The easiest way to bubble the revert reason is using memory via assembly
1808 
1809                 assembly {
1810                     let returndata_size := mload(returndata)
1811                     revert(add(32, returndata), returndata_size)
1812                 }
1813             } else {
1814                 revert(errorMessage);
1815             }
1816         }
1817     }
1818 }
1819 
1820 
1821 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1822 
1823 pragma solidity ^0.8.0;
1824 
1825 /**
1826  * @title ERC721 token receiver interface
1827  * @dev Interface for any contract that wants to support safeTransfers
1828  * from ERC721 asset contracts.
1829  */
1830 interface IERC721Receiver {
1831     /**
1832      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1833      * by `operator` from `from`, this function is called.
1834      *
1835      * It must return its Solidity selector to confirm the token transfer.
1836      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1837      *
1838      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1839      */
1840     function onERC721Received(
1841         address operator,
1842         address from,
1843         uint256 tokenId,
1844         bytes calldata data
1845     ) external returns (bytes4);
1846 }
1847 
1848 
1849 
1850 
1851 
1852 
1853 // File: contracts/LlamasNFT.sol
1854 
1855 
1856 pragma solidity ^0.8.7;
1857 
1858 
1859 // This is built on top of the spacepunks.club smart contract.
1860 contract LLamasNFT is ERC721, ERC721URIStorage, ERC721Enumerable, Ownable, Pausable, PaymentSplitter, ReentrancyGuard {
1861   using SafeMath for uint256;
1862 
1863   // Max limit of existing tokens
1864   uint256 public constant TOKEN_LIMIT = 10000;
1865   uint256 public constant TREASURE_KEYS_LIMIT = 600;
1866 
1867   // Linear price of 1 token
1868   uint256 private _tokenPrice;
1869 
1870   // Maximum amount of tokens to be bought in one transaction / mint
1871   uint256 private _maxTokensAtOnce = 20;
1872 
1873   // flag for public sale - sale where anybody can buy multiple tokens
1874   bool public publicSale = false;
1875 
1876   // flag for team sale - sale where team can buy before currect amount of existing tokens is < 100
1877   bool public teamSale = false;
1878 
1879   // random nonce/seed
1880   uint internal nonce = 0;
1881 
1882   // list of existing ids of tokens
1883   uint[TOKEN_LIMIT] internal indices;
1884 
1885   // mapping of addreses available to buy in teamSale phase
1886   mapping(address => bool) private _teamSaleAddresses;
1887 
1888   // split of shares when withdrawing eth from contract
1889   uint256[] private _teamShares = [95, 5];
1890   address[] private _team = [0xb76655Be2bCb0976a382fe76d8B23871BF01c0c4, 0x10Ed692665Cbe4AA26332d9484765e61dCbFC8a5];
1891 
1892   // Minting with SPC Treasure Keys
1893   address private _treasureKeys; // TODO: Set the value before deployment.
1894 
1895   function setTreasureKeys(address value) external onlyOwner {
1896     _treasureKeys = value;
1897   }
1898 
1899   function mintWithTreasureKey() external nonReentrant {
1900     ISpacePunksTreasureKeys keys = ISpacePunksTreasureKeys(_treasureKeys);
1901 
1902     require(keys.balanceOf(msg.sender, 5) > 0, "SPC Treasure Keys: must own at least one key");
1903 
1904     keys.burnKeyForAddress(5, msg.sender);
1905     _mintWithRandomTokenId(msg.sender);
1906   }
1907 
1908   constructor()
1909     PaymentSplitter(_team, _teamShares)
1910     ERC721("LLamas", "BLL")
1911   {
1912     // sets the token price in wei
1913     setTokenPrice(70000000000000000);
1914 
1915     // sets the team addresses flags in array
1916     _teamSaleAddresses[0xb76655Be2bCb0976a382fe76d8B23871BF01c0c4] = true;
1917   }
1918 
1919 
1920   // Required overrides from parent contracts
1921   function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
1922     super._burn(tokenId);
1923   }
1924 
1925   // return of metadata json uri
1926   function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
1927     return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
1928   }
1929 
1930   // Required overrides from parent contracts
1931   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1932     super._beforeTokenTransfer(from, to, tokenId);
1933   }
1934 
1935   // Required overrides from parent contracts
1936   function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1937     return super.supportsInterface(interfaceId);
1938   }
1939 
1940 
1941   // _tokenPrice getter
1942   function getTokenPrice() public view returns(uint256) {
1943     return _tokenPrice;
1944   }
1945 
1946 
1947   // _tokenPrice setter
1948   function setTokenPrice(uint256 _price) public onlyOwner {
1949     _tokenPrice = _price;
1950   }
1951 
1952   // _paused - pause toggles availability of certain methods that are extending "whenNotPaused" or "whenPaused"
1953   function togglePaused() public onlyOwner {
1954     if (paused()) {
1955       _unpause();
1956     } else {
1957       _pause();
1958     }
1959   }
1960 
1961 
1962   // _maxTokensAtOnce getter
1963   function getMaxTokensAtOnce() public view returns (uint256) {
1964     return _maxTokensAtOnce;
1965   }
1966 
1967   // _maxTokensAtOnce setter
1968   function setMaxTokensAtOnce(uint256 _count) public onlyOwner {
1969     _maxTokensAtOnce = _count;
1970   }
1971 
1972 
1973   // enables public sale and sets max token in tx for 20
1974   function enablePublicSale() public onlyOwner {
1975     publicSale = true;
1976     setMaxTokensAtOnce(20);
1977   }
1978 
1979   // disables public sale
1980   function disablePublicSale() public onlyOwner {
1981     publicSale = false;
1982     setMaxTokensAtOnce(1);
1983   }
1984 
1985   // toggles teamSale
1986   function toggleTeamSale() public onlyOwner {
1987     teamSale = !teamSale;
1988   }
1989 
1990 
1991   // Token URIs base
1992   function _baseURI() internal override pure returns (string memory) {
1993     return "ipfs://QmWPzChN8ucQDtK79D3AAYmZBTFcrxSVkkRSoRX1fXNYvY/";
1994   }
1995 
1996   // Pick a random index
1997   function randomIndex() internal returns (uint256) {
1998     uint256 totalSize = TOKEN_LIMIT - totalSupply();
1999     uint256 index = uint(keccak256(abi.encodePacked(nonce, msg.sender, block.difficulty, block.timestamp))) % totalSize;
2000     uint256 value = 0;
2001 
2002     if (indices[index] != 0) {
2003       value = indices[index];
2004     } else {
2005       value = index;
2006     }
2007 
2008     if (indices[totalSize - 1] == 0) {
2009       indices[index] = totalSize - 1;
2010     } else {
2011       indices[index] = indices[totalSize - 1];
2012     }
2013 
2014     nonce++;
2015 
2016     return value.add(1);
2017   }
2018 
2019 
2020   // Minting single or multiple tokens
2021   function _mintWithRandomTokenId(address _to) private {
2022     uint _tokenID = randomIndex();
2023     _safeMint(_to, _tokenID);
2024   }
2025 
2026   // public method for minting multiple tokens if public sale is enable
2027   function mintPublicMultipleTokens(uint256 _amount) public payable nonReentrant whenNotPaused {
2028     require(totalSupply().add(_amount) <= TOKEN_LIMIT - TREASURE_KEYS_LIMIT, "Purchase would exceed max supply of Llamas");
2029     require(publicSale, "Public sale must be active to mint multiple tokens at once");
2030     require(_amount <= _maxTokensAtOnce, "Too many tokens at once");
2031     require(getTokenPrice().mul(_amount) == msg.value, "Insufficient funds to purchase");
2032 
2033     for(uint256 i = 0; i < _amount; i++) {
2034       _mintWithRandomTokenId(msg.sender);
2035     }
2036   }
2037 
2038   // public method for teammembers for minting multiple tokens if teamsale is enabled and existing tokens amount are less than 100
2039   function mintTeamMultipleTokens(uint256 _amount) public payable nonReentrant {
2040     require(totalSupply().add(_amount) <= TOKEN_LIMIT - TREASURE_KEYS_LIMIT, "Purchase would exceed max supply of Llamas");
2041     require(teamSale, "Team sale must be active to mint as a team member");
2042     require(totalSupply() < 100, "Exceeded tokens allocation for team members");
2043     require(_teamSaleAddresses[address(msg.sender)], "Not a team member");
2044 
2045     for(uint256 i = 0; i < _amount; i++) {
2046       _mintWithRandomTokenId(msg.sender);
2047     }
2048   }
2049 }