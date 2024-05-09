1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
28 
29 
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
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
55         _transferOwnership(_msgSender());
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
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 
105 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.6.0
106 
107 
108 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 // CAUTION
113 // This version of SafeMath should only be used with Solidity 0.8 or later,
114 // because it relies on the compiler's built in overflow checks.
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations.
118  *
119  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
120  * now has built in overflow checking.
121  */
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, with an overflow flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         unchecked {
130             uint256 c = a + b;
131             if (c < a) return (false, 0);
132             return (true, c);
133         }
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
138      *
139      * _Available since v3.4._
140      */
141     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         unchecked {
143             if (b > a) return (false, 0);
144             return (true, a - b);
145         }
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         unchecked {
155             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156             // benefit is lost if 'b' is also tested.
157             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158             if (a == 0) return (true, 0);
159             uint256 c = a * b;
160             if (c / a != b) return (false, 0);
161             return (true, c);
162         }
163     }
164 
165     /**
166      * @dev Returns the division of two unsigned integers, with a division by zero flag.
167      *
168      * _Available since v3.4._
169      */
170     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
171         unchecked {
172             if (b == 0) return (false, 0);
173             return (true, a / b);
174         }
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
179      *
180      * _Available since v3.4._
181      */
182     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         unchecked {
184             if (b == 0) return (false, 0);
185             return (true, a % b);
186         }
187     }
188 
189     /**
190      * @dev Returns the addition of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `+` operator.
194      *
195      * Requirements:
196      *
197      * - Addition cannot overflow.
198      */
199     function add(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a + b;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      *
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a - b;
215     }
216 
217     /**
218      * @dev Returns the multiplication of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `*` operator.
222      *
223      * Requirements:
224      *
225      * - Multiplication cannot overflow.
226      */
227     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
228         return a * b;
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers, reverting on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator.
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function div(uint256 a, uint256 b) internal pure returns (uint256) {
242         return a / b;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * reverting when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258         return a % b;
259     }
260 
261     /**
262      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
263      * overflow (when the result is negative).
264      *
265      * CAUTION: This function is deprecated because it requires allocating memory for the error
266      * message unnecessarily. For custom revert reasons use {trySub}.
267      *
268      * Counterpart to Solidity's `-` operator.
269      *
270      * Requirements:
271      *
272      * - Subtraction cannot overflow.
273      */
274     function sub(
275         uint256 a,
276         uint256 b,
277         string memory errorMessage
278     ) internal pure returns (uint256) {
279         unchecked {
280             require(b <= a, errorMessage);
281             return a - b;
282         }
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a / b;
305         }
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * reverting with custom message when dividing by zero.
311      *
312      * CAUTION: This function is deprecated because it requires allocating memory for the error
313      * message unnecessarily. For custom revert reasons use {tryMod}.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(
324         uint256 a,
325         uint256 b,
326         string memory errorMessage
327     ) internal pure returns (uint256) {
328         unchecked {
329             require(b > 0, errorMessage);
330             return a % b;
331         }
332     }
333 }
334 
335 
336 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Interface of the ERC165 standard, as defined in the
345  * https://eips.ethereum.org/EIPS/eip-165[EIP].
346  *
347  * Implementers can declare support of contract interfaces, which can then be
348  * queried by others ({ERC165Checker}).
349  *
350  * For an implementation, see {ERC165}.
351  */
352 interface IERC165 {
353     /**
354      * @dev Returns true if this contract implements the interface defined by
355      * `interfaceId`. See the corresponding
356      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
357      * to learn more about how these ids are created.
358      *
359      * This function call must use less than 30 000 gas.
360      */
361     function supportsInterface(bytes4 interfaceId) external view returns (bool);
362 }
363 
364 
365 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
366 
367 
368 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 /**
373  * @dev Required interface of an ERC721 compliant contract.
374  */
375 interface IERC721 is IERC165 {
376     /**
377      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
383      */
384     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
388      */
389     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
390 
391     /**
392      * @dev Returns the number of tokens in ``owner``'s account.
393      */
394     function balanceOf(address owner) external view returns (uint256 balance);
395 
396     /**
397      * @dev Returns the owner of the `tokenId` token.
398      *
399      * Requirements:
400      *
401      * - `tokenId` must exist.
402      */
403     function ownerOf(uint256 tokenId) external view returns (address owner);
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must exist and be owned by `from`.
413      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
414      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
415      *
416      * Emits a {Transfer} event.
417      */
418     function safeTransferFrom(
419         address from,
420         address to,
421         uint256 tokenId,
422         bytes calldata data
423     ) external;
424 
425     /**
426      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
427      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Transfers `tokenId` token from `from` to `to`.
447      *
448      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must be owned by `from`.
455      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
456      *
457      * Emits a {Transfer} event.
458      */
459     function transferFrom(
460         address from,
461         address to,
462         uint256 tokenId
463     ) external;
464 
465     /**
466      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
467      * The approval is cleared when the token is transferred.
468      *
469      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
470      *
471      * Requirements:
472      *
473      * - The caller must own the token or be an approved operator.
474      * - `tokenId` must exist.
475      *
476      * Emits an {Approval} event.
477      */
478     function approve(address to, uint256 tokenId) external;
479 
480     /**
481      * @dev Approve or remove `operator` as an operator for the caller.
482      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
483      *
484      * Requirements:
485      *
486      * - The `operator` cannot be the caller.
487      *
488      * Emits an {ApprovalForAll} event.
489      */
490     function setApprovalForAll(address operator, bool _approved) external;
491 
492     /**
493      * @dev Returns the account approved for `tokenId` token.
494      *
495      * Requirements:
496      *
497      * - `tokenId` must exist.
498      */
499     function getApproved(uint256 tokenId) external view returns (address operator);
500 
501     /**
502      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
503      *
504      * See {setApprovalForAll}
505      */
506     function isApprovedForAll(address owner, address operator) external view returns (bool);
507 }
508 
509 
510 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev Contract module that helps prevent reentrant calls to a function.
519  *
520  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
521  * available, which can be applied to functions to make sure there are no nested
522  * (reentrant) calls to them.
523  *
524  * Note that because there is a single `nonReentrant` guard, functions marked as
525  * `nonReentrant` may not call one another. This can be worked around by making
526  * those functions `private`, and then adding `external` `nonReentrant` entry
527  * points to them.
528  *
529  * TIP: If you would like to learn more about reentrancy and alternative ways
530  * to protect against it, check out our blog post
531  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
532  */
533 abstract contract ReentrancyGuard {
534     // Booleans are more expensive than uint256 or any type that takes up a full
535     // word because each write operation emits an extra SLOAD to first read the
536     // slot's contents, replace the bits taken up by the boolean, and then write
537     // back. This is the compiler's defense against contract upgrades and
538     // pointer aliasing, and it cannot be disabled.
539 
540     // The values being non-zero value makes deployment a bit more expensive,
541     // but in exchange the refund on every call to nonReentrant will be lower in
542     // amount. Since refunds are capped to a percentage of the total
543     // transaction's gas, it is best to keep them low in cases like this one, to
544     // increase the likelihood of the full refund coming into effect.
545     uint256 private constant _NOT_ENTERED = 1;
546     uint256 private constant _ENTERED = 2;
547 
548     uint256 private _status;
549 
550     constructor() {
551         _status = _NOT_ENTERED;
552     }
553 
554     /**
555      * @dev Prevents a contract from calling itself, directly or indirectly.
556      * Calling a `nonReentrant` function from another `nonReentrant`
557      * function is not supported. It is possible to prevent this from happening
558      * by making the `nonReentrant` function external, and making it call a
559      * `private` function that does the actual work.
560      */
561     modifier nonReentrant() {
562         // On the first call to nonReentrant, _notEntered will be true
563         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
564 
565         // Any calls to nonReentrant after this point will fail
566         _status = _ENTERED;
567 
568         _;
569 
570         // By storing the original value once again, a refund is triggered (see
571         // https://eips.ethereum.org/EIPS/eip-2200)
572         _status = _NOT_ENTERED;
573     }
574 }
575 
576 
577 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
578 
579 
580 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 /**
585  * @title ERC721 token receiver interface
586  * @dev Interface for any contract that wants to support safeTransfers
587  * from ERC721 asset contracts.
588  */
589 interface IERC721Receiver {
590     /**
591      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
592      * by `operator` from `from`, this function is called.
593      *
594      * It must return its Solidity selector to confirm the token transfer.
595      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
596      *
597      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
598      */
599     function onERC721Received(
600         address operator,
601         address from,
602         uint256 tokenId,
603         bytes calldata data
604     ) external returns (bytes4);
605 }
606 
607 
608 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
617  * @dev See https://eips.ethereum.org/EIPS/eip-721
618  */
619 interface IERC721Metadata is IERC721 {
620     /**
621      * @dev Returns the token collection name.
622      */
623     function name() external view returns (string memory);
624 
625     /**
626      * @dev Returns the token collection symbol.
627      */
628     function symbol() external view returns (string memory);
629 
630     /**
631      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
632      */
633     function tokenURI(uint256 tokenId) external view returns (string memory);
634 }
635 
636 
637 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
638 
639 
640 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
641 
642 pragma solidity ^0.8.1;
643 
644 /**
645  * @dev Collection of functions related to the address type
646  */
647 library Address {
648     /**
649      * @dev Returns true if `account` is a contract.
650      *
651      * [IMPORTANT]
652      * ====
653      * It is unsafe to assume that an address for which this function returns
654      * false is an externally-owned account (EOA) and not a contract.
655      *
656      * Among others, `isContract` will return false for the following
657      * types of addresses:
658      *
659      *  - an externally-owned account
660      *  - a contract in construction
661      *  - an address where a contract will be created
662      *  - an address where a contract lived, but was destroyed
663      * ====
664      *
665      * [IMPORTANT]
666      * ====
667      * You shouldn't rely on `isContract` to protect against flash loan attacks!
668      *
669      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
670      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
671      * constructor.
672      * ====
673      */
674     function isContract(address account) internal view returns (bool) {
675         // This method relies on extcodesize/address.code.length, which returns 0
676         // for contracts in construction, since the code is only stored at the end
677         // of the constructor execution.
678 
679         return account.code.length > 0;
680     }
681 
682     /**
683      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
684      * `recipient`, forwarding all available gas and reverting on errors.
685      *
686      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
687      * of certain opcodes, possibly making contracts go over the 2300 gas limit
688      * imposed by `transfer`, making them unable to receive funds via
689      * `transfer`. {sendValue} removes this limitation.
690      *
691      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
692      *
693      * IMPORTANT: because control is transferred to `recipient`, care must be
694      * taken to not create reentrancy vulnerabilities. Consider using
695      * {ReentrancyGuard} or the
696      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
697      */
698     function sendValue(address payable recipient, uint256 amount) internal {
699         require(address(this).balance >= amount, "Address: insufficient balance");
700 
701         (bool success, ) = recipient.call{value: amount}("");
702         require(success, "Address: unable to send value, recipient may have reverted");
703     }
704 
705     /**
706      * @dev Performs a Solidity function call using a low level `call`. A
707      * plain `call` is an unsafe replacement for a function call: use this
708      * function instead.
709      *
710      * If `target` reverts with a revert reason, it is bubbled up by this
711      * function (like regular Solidity function calls).
712      *
713      * Returns the raw returned data. To convert to the expected return value,
714      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
715      *
716      * Requirements:
717      *
718      * - `target` must be a contract.
719      * - calling `target` with `data` must not revert.
720      *
721      * _Available since v3.1._
722      */
723     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
724         return functionCall(target, data, "Address: low-level call failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
729      * `errorMessage` as a fallback revert reason when `target` reverts.
730      *
731      * _Available since v3.1._
732      */
733     function functionCall(
734         address target,
735         bytes memory data,
736         string memory errorMessage
737     ) internal returns (bytes memory) {
738         return functionCallWithValue(target, data, 0, errorMessage);
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
743      * but also transferring `value` wei to `target`.
744      *
745      * Requirements:
746      *
747      * - the calling contract must have an ETH balance of at least `value`.
748      * - the called Solidity function must be `payable`.
749      *
750      * _Available since v3.1._
751      */
752     function functionCallWithValue(
753         address target,
754         bytes memory data,
755         uint256 value
756     ) internal returns (bytes memory) {
757         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
762      * with `errorMessage` as a fallback revert reason when `target` reverts.
763      *
764      * _Available since v3.1._
765      */
766     function functionCallWithValue(
767         address target,
768         bytes memory data,
769         uint256 value,
770         string memory errorMessage
771     ) internal returns (bytes memory) {
772         require(address(this).balance >= value, "Address: insufficient balance for call");
773         require(isContract(target), "Address: call to non-contract");
774 
775         (bool success, bytes memory returndata) = target.call{value: value}(data);
776         return verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a static call.
782      *
783      * _Available since v3.3._
784      */
785     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
786         return functionStaticCall(target, data, "Address: low-level static call failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
791      * but performing a static call.
792      *
793      * _Available since v3.3._
794      */
795     function functionStaticCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal view returns (bytes memory) {
800         require(isContract(target), "Address: static call to non-contract");
801 
802         (bool success, bytes memory returndata) = target.staticcall(data);
803         return verifyCallResult(success, returndata, errorMessage);
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
808      * but performing a delegate call.
809      *
810      * _Available since v3.4._
811      */
812     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
813         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
818      * but performing a delegate call.
819      *
820      * _Available since v3.4._
821      */
822     function functionDelegateCall(
823         address target,
824         bytes memory data,
825         string memory errorMessage
826     ) internal returns (bytes memory) {
827         require(isContract(target), "Address: delegate call to non-contract");
828 
829         (bool success, bytes memory returndata) = target.delegatecall(data);
830         return verifyCallResult(success, returndata, errorMessage);
831     }
832 
833     /**
834      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
835      * revert reason using the provided one.
836      *
837      * _Available since v4.3._
838      */
839     function verifyCallResult(
840         bool success,
841         bytes memory returndata,
842         string memory errorMessage
843     ) internal pure returns (bytes memory) {
844         if (success) {
845             return returndata;
846         } else {
847             // Look for revert reason and bubble it up if present
848             if (returndata.length > 0) {
849                 // The easiest way to bubble the revert reason is using memory via assembly
850 
851                 assembly {
852                     let returndata_size := mload(returndata)
853                     revert(add(32, returndata), returndata_size)
854                 }
855             } else {
856                 revert(errorMessage);
857             }
858         }
859     }
860 }
861 
862 
863 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
864 
865 
866 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
867 
868 pragma solidity ^0.8.0;
869 
870 /**
871  * @dev String operations.
872  */
873 library Strings {
874     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
875 
876     /**
877      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
878      */
879     function toString(uint256 value) internal pure returns (string memory) {
880         // Inspired by OraclizeAPI's implementation - MIT licence
881         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
882 
883         if (value == 0) {
884             return "0";
885         }
886         uint256 temp = value;
887         uint256 digits;
888         while (temp != 0) {
889             digits++;
890             temp /= 10;
891         }
892         bytes memory buffer = new bytes(digits);
893         while (value != 0) {
894             digits -= 1;
895             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
896             value /= 10;
897         }
898         return string(buffer);
899     }
900 
901     /**
902      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
903      */
904     function toHexString(uint256 value) internal pure returns (string memory) {
905         if (value == 0) {
906             return "0x00";
907         }
908         uint256 temp = value;
909         uint256 length = 0;
910         while (temp != 0) {
911             length++;
912             temp >>= 8;
913         }
914         return toHexString(value, length);
915     }
916 
917     /**
918      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
919      */
920     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
921         bytes memory buffer = new bytes(2 * length + 2);
922         buffer[0] = "0";
923         buffer[1] = "x";
924         for (uint256 i = 2 * length + 1; i > 1; --i) {
925             buffer[i] = _HEX_SYMBOLS[value & 0xf];
926             value >>= 4;
927         }
928         require(value == 0, "Strings: hex length insufficient");
929         return string(buffer);
930     }
931 }
932 
933 
934 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
935 
936 
937 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 /**
942  * @dev Implementation of the {IERC165} interface.
943  *
944  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
945  * for the additional interface id that will be supported. For example:
946  *
947  * ```solidity
948  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
949  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
950  * }
951  * ```
952  *
953  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
954  */
955 abstract contract ERC165 is IERC165 {
956     /**
957      * @dev See {IERC165-supportsInterface}.
958      */
959     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
960         return interfaceId == type(IERC165).interfaceId;
961     }
962 }
963 
964 
965 // File contracts/ERC721A.sol
966 
967 
968 // Creator: Chiru Labs
969 
970 pragma solidity ^0.8.0;
971 /**
972  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
973  * the Metadata extension. Built to optimize for lower gas during batch mints.
974  *
975  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
976  *
977  * Does not support burning tokens to address(0).
978  *
979  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
980  */
981 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
982     using Address for address;
983     using Strings for uint256;
984 
985     struct TokenOwnership {
986         address addr;
987         uint64 startTimestamp;
988     }
989 
990     struct AddressData {
991         uint128 balance;
992         uint128 numberMinted;
993     }
994 
995     uint256 internal currentIndex;
996 
997     // Token name
998     string private _name;
999 
1000     // Token symbol
1001     string private _symbol;
1002 
1003     // Mapping from token ID to ownership details
1004     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1005     mapping(uint256 => TokenOwnership) internal _ownerships;
1006 
1007     // Mapping owner address to address data
1008     mapping(address => AddressData) private _addressData;
1009 
1010     // Mapping from token ID to approved address
1011     mapping(uint256 => address) private _tokenApprovals;
1012 
1013     // Mapping from owner to operator approvals
1014     mapping(address => mapping(address => bool)) private _operatorApprovals;
1015 
1016     constructor(string memory name_, string memory symbol_) {
1017         _name = name_;
1018         _symbol = symbol_;
1019     }
1020 
1021     function totalSupply() public view returns (uint256) {
1022         return currentIndex;
1023     }
1024 
1025     /**
1026      * @dev See {IERC165-supportsInterface}.
1027      */
1028     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1029         return
1030         interfaceId == type(IERC721).interfaceId ||
1031         interfaceId == type(IERC721Metadata).interfaceId ||
1032         super.supportsInterface(interfaceId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-balanceOf}.
1037      */
1038     function balanceOf(address owner) public view override returns (uint256) {
1039         require(owner != address(0), 'ERC721A: balance query for the zero address');
1040         return uint256(_addressData[owner].balance);
1041     }
1042 
1043     function _numberMinted(address owner) internal view returns (uint256) {
1044         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1045         return uint256(_addressData[owner].numberMinted);
1046     }
1047 
1048     /**
1049      * Gas spent here starts off proportional to the maximum mint batch size.
1050      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1051      */
1052     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1053         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1054 
1055     unchecked {
1056         for (uint256 curr = tokenId; curr >= 0; curr--) {
1057             TokenOwnership memory ownership = _ownerships[curr];
1058             if (ownership.addr != address(0)) {
1059                 return ownership;
1060             }
1061         }
1062     }
1063 
1064         revert('ERC721A: unable to determine the owner of token');
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-ownerOf}.
1069      */
1070     function ownerOf(uint256 tokenId) public view override returns (address) {
1071         return ownershipOf(tokenId).addr;
1072     }
1073 
1074     /**
1075      * @dev See {IERC721Metadata-name}.
1076      */
1077     function name() public view virtual override returns (string memory) {
1078         return _name;
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Metadata-symbol}.
1083      */
1084     function symbol() public view virtual override returns (string memory) {
1085         return _symbol;
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Metadata-tokenURI}.
1090      */
1091     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1092         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1093 
1094         string memory baseURI = _baseURI();
1095         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1096     }
1097 
1098     /**
1099      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1100      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1101      * by default, can be overriden in child contracts.
1102      */
1103     function _baseURI() internal view virtual returns (string memory) {
1104         return '';
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-approve}.
1109      */
1110     function approve(address to, uint256 tokenId) public override {
1111         address owner = ERC721A.ownerOf(tokenId);
1112         require(to != owner, 'ERC721A: approval to current owner');
1113 
1114         require(
1115             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1116             'ERC721A: approve caller is not owner nor approved for all'
1117         );
1118 
1119         _approve(to, tokenId, owner);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-getApproved}.
1124      */
1125     function getApproved(uint256 tokenId) public view override returns (address) {
1126         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1127 
1128         return _tokenApprovals[tokenId];
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-setApprovalForAll}.
1133      */
1134     function setApprovalForAll(address operator, bool approved) public override {
1135         require(operator != _msgSender(), 'ERC721A: approve to caller');
1136 
1137         _operatorApprovals[_msgSender()][operator] = approved;
1138         emit ApprovalForAll(_msgSender(), operator, approved);
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-isApprovedForAll}.
1143      */
1144     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1145         return _operatorApprovals[owner][operator];
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-transferFrom}.
1150      */
1151     function transferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) public override {
1156         _transfer(from, to, tokenId);
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-safeTransferFrom}.
1161      */
1162     function safeTransferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public override {
1167         safeTransferFrom(from, to, tokenId, '');
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-safeTransferFrom}.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) public override {
1179         _transfer(from, to, tokenId);
1180         require(
1181             _checkOnERC721Received(from, to, tokenId, _data),
1182             'ERC721A: transfer to non ERC721Receiver implementer'
1183         );
1184     }
1185 
1186     /**
1187      * @dev Returns whether `tokenId` exists.
1188      *
1189      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1190      *
1191      * Tokens start existing when they are minted (`_mint`),
1192      */
1193     function _exists(uint256 tokenId) internal view returns (bool) {
1194         return tokenId < currentIndex;
1195     }
1196 
1197     function _safeMint(address to, uint256 quantity) internal {
1198         _safeMint(to, quantity, '');
1199     }
1200 
1201     /**
1202      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1207      * - `quantity` must be greater than 0.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _safeMint(
1212         address to,
1213         uint256 quantity,
1214         bytes memory _data
1215     ) internal {
1216         _mint(to, quantity, _data, true);
1217     }
1218 
1219     /**
1220      * @dev Mints `quantity` tokens and transfers them to `to`.
1221      *
1222      * Requirements:
1223      *
1224      * - `to` cannot be the zero address.
1225      * - `quantity` must be greater than 0.
1226      *
1227      * Emits a {Transfer} event.
1228      */
1229     function _mint(
1230         address to,
1231         uint256 quantity,
1232         bytes memory _data,
1233         bool safe
1234     ) internal {
1235         uint256 startTokenId = currentIndex;
1236         require(to != address(0), 'ERC721A: mint to the zero address');
1237         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1238 
1239         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1240 
1241         // Overflows are incredibly unrealistic.
1242         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1243         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1244     unchecked {
1245         _addressData[to].balance += uint128(quantity);
1246         _addressData[to].numberMinted += uint128(quantity);
1247 
1248         _ownerships[startTokenId].addr = to;
1249         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1250 
1251         uint256 updatedIndex = startTokenId;
1252 
1253         for (uint256 i; i < quantity; i++) {
1254             emit Transfer(address(0), to, updatedIndex);
1255             if (safe) {
1256                 require(
1257                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1258                     'ERC721A: transfer to non ERC721Receiver implementer'
1259                 );
1260             }
1261 
1262             updatedIndex++;
1263         }
1264 
1265         currentIndex = updatedIndex;
1266     }
1267 
1268         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1269     }
1270 
1271     /**
1272      * @dev Transfers `tokenId` from `from` to `to`.
1273      *
1274      * Requirements:
1275      *
1276      * - `to` cannot be the zero address.
1277      * - `tokenId` token must be owned by `from`.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _transfer(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) private {
1286         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1287 
1288         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1289         getApproved(tokenId) == _msgSender() ||
1290         isApprovedForAll(prevOwnership.addr, _msgSender()));
1291 
1292         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1293 
1294         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1295         require(to != address(0), 'ERC721A: transfer to the zero address');
1296 
1297         _beforeTokenTransfers(from, to, tokenId, 1);
1298 
1299         // Clear approvals from the previous owner
1300         _approve(address(0), tokenId, prevOwnership.addr);
1301 
1302         // Underflow of the sender's balance is impossible because we check for
1303         // ownership above and the recipient's balance can't realistically overflow.
1304         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1305     unchecked {
1306         _addressData[from].balance -= 1;
1307         _addressData[to].balance += 1;
1308 
1309         _ownerships[tokenId].addr = to;
1310         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1311 
1312         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1313         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1314         uint256 nextTokenId = tokenId + 1;
1315         if (_ownerships[nextTokenId].addr == address(0)) {
1316             if (_exists(nextTokenId)) {
1317                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1318                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1319             }
1320         }
1321     }
1322 
1323         emit Transfer(from, to, tokenId);
1324         _afterTokenTransfers(from, to, tokenId, 1);
1325     }
1326 
1327     /**
1328      * @dev Approve `to` to operate on `tokenId`
1329      *
1330      * Emits a {Approval} event.
1331      */
1332     function _approve(
1333         address to,
1334         uint256 tokenId,
1335         address owner
1336     ) private {
1337         _tokenApprovals[tokenId] = to;
1338         emit Approval(owner, to, tokenId);
1339     }
1340 
1341     /**
1342      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1343      * The call is not executed if the target address is not a contract.
1344      *
1345      * @param from address representing the previous owner of the given token ID
1346      * @param to target address that will receive the tokens
1347      * @param tokenId uint256 ID of the token to be transferred
1348      * @param _data bytes optional data to send along with the call
1349      * @return bool whether the call correctly returned the expected magic value
1350      */
1351     function _checkOnERC721Received(
1352         address from,
1353         address to,
1354         uint256 tokenId,
1355         bytes memory _data
1356     ) private returns (bool) {
1357         if (to.isContract()) {
1358             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1359                 return retval == IERC721Receiver(to).onERC721Received.selector;
1360             } catch (bytes memory reason) {
1361                 if (reason.length == 0) {
1362                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1363                 } else {
1364                     assembly {
1365                         revert(add(32, reason), mload(reason))
1366                     }
1367                 }
1368             }
1369         } else {
1370             return true;
1371         }
1372     }
1373 
1374     /**
1375      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1376      *
1377      * startTokenId - the first token id to be transferred
1378      * quantity - the amount to be transferred
1379      *
1380      * Calling conditions:
1381      *
1382      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1383      * transferred to `to`.
1384      * - When `from` is zero, `tokenId` will be minted for `to`.
1385      */
1386     function _beforeTokenTransfers(
1387         address from,
1388         address to,
1389         uint256 startTokenId,
1390         uint256 quantity
1391     ) internal virtual {}
1392 
1393     /**
1394      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1395      * minting.
1396      *
1397      * startTokenId - the first token id to be transferred
1398      * quantity - the amount to be transferred
1399      *
1400      * Calling conditions:
1401      *
1402      * - when `from` and `to` are both non-zero.
1403      * - `from` and `to` are never both zero.
1404      */
1405     function _afterTokenTransfers(
1406         address from,
1407         address to,
1408         uint256 startTokenId,
1409         uint256 quantity
1410     ) internal virtual {}
1411 }
1412 
1413 pragma solidity ^0.8.0;
1414 contract Pablos is Ownable, ERC721A, ReentrancyGuard {
1415     using SafeMath for uint256;
1416    
1417     bool private _isActive = false;
1418 
1419     uint256 public constant MAX_SUPPLY = 10000;
1420 
1421     uint256 public maxCountPerAccount = 2; 
1422     
1423     uint256 public price = 0 ether;
1424 
1425     string private _tokenBaseURI = "";
1426 
1427     mapping(address => uint256) public minted;
1428 
1429     modifier onlyActive() {
1430         require(_isActive && totalSupply() < MAX_SUPPLY, 'not active');
1431         _;
1432     }
1433 
1434     constructor() ERC721A("Pablos", "Pablos") {
1435     }
1436 
1437     function mint(uint256 numberOfTokens) external payable onlyActive nonReentrant() {
1438         require(numberOfTokens > 0, "zero count");
1439         require(numberOfTokens <= MAX_SUPPLY.sub(totalSupply()), "not enough nfts");
1440         require(numberOfTokens.add(minted[msg.sender]) <= maxCountPerAccount, "already max minted");
1441         
1442         minted[msg.sender] = minted[msg.sender].add(numberOfTokens);
1443 
1444         _safeMint(msg.sender, numberOfTokens);
1445     }
1446 
1447     function _baseURI() internal view override returns (string memory) {
1448         return _tokenBaseURI;
1449     }
1450 
1451     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory)
1452     {
1453         return super.tokenURI(tokenId);
1454     }
1455 
1456     
1457     /////////////////////////////////////////////////////////////
1458     //////////////////   Admin Functions ////////////////////////
1459     /////////////////////////////////////////////////////////////
1460     function startSale() external onlyOwner {
1461         _isActive = true;
1462     }
1463 
1464     function endSale() external onlyOwner {
1465         _isActive = false;
1466     }
1467 
1468     function setPrice(uint256 _price) external onlyOwner {
1469         price = _price;
1470     }
1471 
1472     function setMaxMintPerAddr(uint256 _count) external onlyOwner {
1473         maxCountPerAccount = _count;
1474     }
1475 
1476     function setTokenBaseURI(string memory URI) external onlyOwner {
1477         _tokenBaseURI = URI;
1478     }
1479 
1480     function withdraw() external onlyOwner nonReentrant {
1481         uint256 balance = address(this).balance;
1482         Address.sendValue(payable(owner()), balance);
1483     }
1484 
1485     receive() external payable {}
1486 }