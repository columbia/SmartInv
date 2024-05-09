1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-07
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.6.0
110 
111 
112 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 // CAUTION
117 // This version of SafeMath should only be used with Solidity 0.8 or later,
118 // because it relies on the compiler's built in overflow checks.
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations.
122  *
123  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
124  * now has built in overflow checking.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, with an overflow flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         unchecked {
134             uint256 c = a + b;
135             if (c < a) return (false, 0);
136             return (true, c);
137         }
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
142      *
143      * _Available since v3.4._
144      */
145     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             if (b > a) return (false, 0);
148             return (true, a - b);
149         }
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         unchecked {
159             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160             // benefit is lost if 'b' is also tested.
161             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162             if (a == 0) return (true, 0);
163             uint256 c = a * b;
164             if (c / a != b) return (false, 0);
165             return (true, c);
166         }
167     }
168 
169     /**
170      * @dev Returns the division of two unsigned integers, with a division by zero flag.
171      *
172      * _Available since v3.4._
173      */
174     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
175         unchecked {
176             if (b == 0) return (false, 0);
177             return (true, a / b);
178         }
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         unchecked {
188             if (b == 0) return (false, 0);
189             return (true, a % b);
190         }
191     }
192 
193     /**
194      * @dev Returns the addition of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `+` operator.
198      *
199      * Requirements:
200      *
201      * - Addition cannot overflow.
202      */
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a + b;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a - b;
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `*` operator.
226      *
227      * Requirements:
228      *
229      * - Multiplication cannot overflow.
230      */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a * b;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers, reverting on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator.
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(uint256 a, uint256 b) internal pure returns (uint256) {
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         return a % b;
263     }
264 
265     /**
266      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
267      * overflow (when the result is negative).
268      *
269      * CAUTION: This function is deprecated because it requires allocating memory for the error
270      * message unnecessarily. For custom revert reasons use {trySub}.
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      *
276      * - Subtraction cannot overflow.
277      */
278     function sub(
279         uint256 a,
280         uint256 b,
281         string memory errorMessage
282     ) internal pure returns (uint256) {
283         unchecked {
284             require(b <= a, errorMessage);
285             return a - b;
286         }
287     }
288 
289     /**
290      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
291      * division by zero. The result is rounded towards zero.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function div(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         unchecked {
307             require(b > 0, errorMessage);
308             return a / b;
309         }
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * reverting with custom message when dividing by zero.
315      *
316      * CAUTION: This function is deprecated because it requires allocating memory for the error
317      * message unnecessarily. For custom revert reasons use {tryMod}.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function mod(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a % b;
335         }
336     }
337 }
338 
339 
340 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Interface of the ERC165 standard, as defined in the
349  * https://eips.ethereum.org/EIPS/eip-165[EIP].
350  *
351  * Implementers can declare support of contract interfaces, which can then be
352  * queried by others ({ERC165Checker}).
353  *
354  * For an implementation, see {ERC165}.
355  */
356 interface IERC165 {
357     /**
358      * @dev Returns true if this contract implements the interface defined by
359      * `interfaceId`. See the corresponding
360      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
361      * to learn more about how these ids are created.
362      *
363      * This function call must use less than 30 000 gas.
364      */
365     function supportsInterface(bytes4 interfaceId) external view returns (bool);
366 }
367 
368 
369 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
370 
371 
372 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Required interface of an ERC721 compliant contract.
378  */
379 interface IERC721 is IERC165 {
380     /**
381      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
382      */
383     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
384 
385     /**
386      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
387      */
388     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
389 
390     /**
391      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
392      */
393     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
394 
395     /**
396      * @dev Returns the number of tokens in ``owner``'s account.
397      */
398     function balanceOf(address owner) external view returns (uint256 balance);
399 
400     /**
401      * @dev Returns the owner of the `tokenId` token.
402      *
403      * Requirements:
404      *
405      * - `tokenId` must exist.
406      */
407     function ownerOf(uint256 tokenId) external view returns (address owner);
408 
409     /**
410      * @dev Safely transfers `tokenId` token from `from` to `to`.
411      *
412      * Requirements:
413      *
414      * - `from` cannot be the zero address.
415      * - `to` cannot be the zero address.
416      * - `tokenId` token must exist and be owned by `from`.
417      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
418      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
419      *
420      * Emits a {Transfer} event.
421      */
422     function safeTransferFrom(
423         address from,
424         address to,
425         uint256 tokenId,
426         bytes calldata data
427     ) external;
428 
429     /**
430      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
431      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `tokenId` token must exist and be owned by `from`.
438      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
440      *
441      * Emits a {Transfer} event.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId
447     ) external;
448 
449     /**
450      * @dev Transfers `tokenId` token from `from` to `to`.
451      *
452      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must be owned by `from`.
459      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
460      *
461      * Emits a {Transfer} event.
462      */
463     function transferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) external;
468 
469     /**
470      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
471      * The approval is cleared when the token is transferred.
472      *
473      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
474      *
475      * Requirements:
476      *
477      * - The caller must own the token or be an approved operator.
478      * - `tokenId` must exist.
479      *
480      * Emits an {Approval} event.
481      */
482     function approve(address to, uint256 tokenId) external;
483 
484     /**
485      * @dev Approve or remove `operator` as an operator for the caller.
486      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
487      *
488      * Requirements:
489      *
490      * - The `operator` cannot be the caller.
491      *
492      * Emits an {ApprovalForAll} event.
493      */
494     function setApprovalForAll(address operator, bool _approved) external;
495 
496     /**
497      * @dev Returns the account approved for `tokenId` token.
498      *
499      * Requirements:
500      *
501      * - `tokenId` must exist.
502      */
503     function getApproved(uint256 tokenId) external view returns (address operator);
504 
505     /**
506      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
507      *
508      * See {setApprovalForAll}
509      */
510     function isApprovedForAll(address owner, address operator) external view returns (bool);
511 }
512 
513 
514 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Contract module that helps prevent reentrant calls to a function.
523  *
524  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
525  * available, which can be applied to functions to make sure there are no nested
526  * (reentrant) calls to them.
527  *
528  * Note that because there is a single `nonReentrant` guard, functions marked as
529  * `nonReentrant` may not call one another. This can be worked around by making
530  * those functions `private`, and then adding `external` `nonReentrant` entry
531  * points to them.
532  *
533  * TIP: If you would like to learn more about reentrancy and alternative ways
534  * to protect against it, check out our blog post
535  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
536  */
537 abstract contract ReentrancyGuard {
538     // Booleans are more expensive than uint256 or any type that takes up a full
539     // word because each write operation emits an extra SLOAD to first read the
540     // slot's contents, replace the bits taken up by the boolean, and then write
541     // back. This is the compiler's defense against contract upgrades and
542     // pointer aliasing, and it cannot be disabled.
543 
544     // The values being non-zero value makes deployment a bit more expensive,
545     // but in exchange the refund on every call to nonReentrant will be lower in
546     // amount. Since refunds are capped to a percentage of the total
547     // transaction's gas, it is best to keep them low in cases like this one, to
548     // increase the likelihood of the full refund coming into effect.
549     uint256 private constant _NOT_ENTERED = 1;
550     uint256 private constant _ENTERED = 2;
551 
552     uint256 private _status;
553 
554     constructor() {
555         _status = _NOT_ENTERED;
556     }
557 
558     /**
559      * @dev Prevents a contract from calling itself, directly or indirectly.
560      * Calling a `nonReentrant` function from another `nonReentrant`
561      * function is not supported. It is possible to prevent this from happening
562      * by making the `nonReentrant` function external, and making it call a
563      * `private` function that does the actual work.
564      */
565     modifier nonReentrant() {
566         // On the first call to nonReentrant, _notEntered will be true
567         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
568 
569         // Any calls to nonReentrant after this point will fail
570         _status = _ENTERED;
571 
572         _;
573 
574         // By storing the original value once again, a refund is triggered (see
575         // https://eips.ethereum.org/EIPS/eip-2200)
576         _status = _NOT_ENTERED;
577     }
578 }
579 
580 
581 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
582 
583 
584 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @title ERC721 token receiver interface
590  * @dev Interface for any contract that wants to support safeTransfers
591  * from ERC721 asset contracts.
592  */
593 interface IERC721Receiver {
594     /**
595      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
596      * by `operator` from `from`, this function is called.
597      *
598      * It must return its Solidity selector to confirm the token transfer.
599      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
600      *
601      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
602      */
603     function onERC721Received(
604         address operator,
605         address from,
606         uint256 tokenId,
607         bytes calldata data
608     ) external returns (bytes4);
609 }
610 
611 
612 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
621  * @dev See https://eips.ethereum.org/EIPS/eip-721
622  */
623 interface IERC721Metadata is IERC721 {
624     /**
625      * @dev Returns the token collection name.
626      */
627     function name() external view returns (string memory);
628 
629     /**
630      * @dev Returns the token collection symbol.
631      */
632     function symbol() external view returns (string memory);
633 
634     /**
635      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
636      */
637     function tokenURI(uint256 tokenId) external view returns (string memory);
638 }
639 
640 
641 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
642 
643 
644 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
645 
646 pragma solidity ^0.8.1;
647 
648 /**
649  * @dev Collection of functions related to the address type
650  */
651 library Address {
652     /**
653      * @dev Returns true if `account` is a contract.
654      *
655      * [IMPORTANT]
656      * ====
657      * It is unsafe to assume that an address for which this function returns
658      * false is an externally-owned account (EOA) and not a contract.
659      *
660      * Among others, `isContract` will return false for the following
661      * types of addresses:
662      *
663      *  - an externally-owned account
664      *  - a contract in construction
665      *  - an address where a contract will be created
666      *  - an address where a contract lived, but was destroyed
667      * ====
668      *
669      * [IMPORTANT]
670      * ====
671      * You shouldn't rely on `isContract` to protect against flash loan attacks!
672      *
673      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
674      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
675      * constructor.
676      * ====
677      */
678     function isContract(address account) internal view returns (bool) {
679         // This method relies on extcodesize/address.code.length, which returns 0
680         // for contracts in construction, since the code is only stored at the end
681         // of the constructor execution.
682 
683         return account.code.length > 0;
684     }
685 
686     /**
687      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
688      * `recipient`, forwarding all available gas and reverting on errors.
689      *
690      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
691      * of certain opcodes, possibly making contracts go over the 2300 gas limit
692      * imposed by `transfer`, making them unable to receive funds via
693      * `transfer`. {sendValue} removes this limitation.
694      *
695      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
696      *
697      * IMPORTANT: because control is transferred to `recipient`, care must be
698      * taken to not create reentrancy vulnerabilities. Consider using
699      * {ReentrancyGuard} or the
700      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
701      */
702     function sendValue(address payable recipient, uint256 amount) internal {
703         require(address(this).balance >= amount, "Address: insufficient balance");
704 
705         (bool success, ) = recipient.call{value: amount}("");
706         require(success, "Address: unable to send value, recipient may have reverted");
707     }
708 
709     /**
710      * @dev Performs a Solidity function call using a low level `call`. A
711      * plain `call` is an unsafe replacement for a function call: use this
712      * function instead.
713      *
714      * If `target` reverts with a revert reason, it is bubbled up by this
715      * function (like regular Solidity function calls).
716      *
717      * Returns the raw returned data. To convert to the expected return value,
718      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
719      *
720      * Requirements:
721      *
722      * - `target` must be a contract.
723      * - calling `target` with `data` must not revert.
724      *
725      * _Available since v3.1._
726      */
727     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
728         return functionCall(target, data, "Address: low-level call failed");
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
733      * `errorMessage` as a fallback revert reason when `target` reverts.
734      *
735      * _Available since v3.1._
736      */
737     function functionCall(
738         address target,
739         bytes memory data,
740         string memory errorMessage
741     ) internal returns (bytes memory) {
742         return functionCallWithValue(target, data, 0, errorMessage);
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
747      * but also transferring `value` wei to `target`.
748      *
749      * Requirements:
750      *
751      * - the calling contract must have an ETH balance of at least `value`.
752      * - the called Solidity function must be `payable`.
753      *
754      * _Available since v3.1._
755      */
756     function functionCallWithValue(
757         address target,
758         bytes memory data,
759         uint256 value
760     ) internal returns (bytes memory) {
761         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
766      * with `errorMessage` as a fallback revert reason when `target` reverts.
767      *
768      * _Available since v3.1._
769      */
770     function functionCallWithValue(
771         address target,
772         bytes memory data,
773         uint256 value,
774         string memory errorMessage
775     ) internal returns (bytes memory) {
776         require(address(this).balance >= value, "Address: insufficient balance for call");
777         require(isContract(target), "Address: call to non-contract");
778 
779         (bool success, bytes memory returndata) = target.call{value: value}(data);
780         return verifyCallResult(success, returndata, errorMessage);
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
785      * but performing a static call.
786      *
787      * _Available since v3.3._
788      */
789     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
790         return functionStaticCall(target, data, "Address: low-level static call failed");
791     }
792 
793     /**
794      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
795      * but performing a static call.
796      *
797      * _Available since v3.3._
798      */
799     function functionStaticCall(
800         address target,
801         bytes memory data,
802         string memory errorMessage
803     ) internal view returns (bytes memory) {
804         require(isContract(target), "Address: static call to non-contract");
805 
806         (bool success, bytes memory returndata) = target.staticcall(data);
807         return verifyCallResult(success, returndata, errorMessage);
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
812      * but performing a delegate call.
813      *
814      * _Available since v3.4._
815      */
816     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
817         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
818     }
819 
820     /**
821      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
822      * but performing a delegate call.
823      *
824      * _Available since v3.4._
825      */
826     function functionDelegateCall(
827         address target,
828         bytes memory data,
829         string memory errorMessage
830     ) internal returns (bytes memory) {
831         require(isContract(target), "Address: delegate call to non-contract");
832 
833         (bool success, bytes memory returndata) = target.delegatecall(data);
834         return verifyCallResult(success, returndata, errorMessage);
835     }
836 
837     /**
838      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
839      * revert reason using the provided one.
840      *
841      * _Available since v4.3._
842      */
843     function verifyCallResult(
844         bool success,
845         bytes memory returndata,
846         string memory errorMessage
847     ) internal pure returns (bytes memory) {
848         if (success) {
849             return returndata;
850         } else {
851             // Look for revert reason and bubble it up if present
852             if (returndata.length > 0) {
853                 // The easiest way to bubble the revert reason is using memory via assembly
854 
855                 assembly {
856                     let returndata_size := mload(returndata)
857                     revert(add(32, returndata), returndata_size)
858                 }
859             } else {
860                 revert(errorMessage);
861             }
862         }
863     }
864 }
865 
866 
867 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
868 
869 
870 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
871 
872 pragma solidity ^0.8.0;
873 
874 /**
875  * @dev String operations.
876  */
877 library Strings {
878     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
879 
880     /**
881      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
882      */
883     function toString(uint256 value) internal pure returns (string memory) {
884         // Inspired by OraclizeAPI's implementation - MIT licence
885         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
886 
887         if (value == 0) {
888             return "0";
889         }
890         uint256 temp = value;
891         uint256 digits;
892         while (temp != 0) {
893             digits++;
894             temp /= 10;
895         }
896         bytes memory buffer = new bytes(digits);
897         while (value != 0) {
898             digits -= 1;
899             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
900             value /= 10;
901         }
902         return string(buffer);
903     }
904 
905     /**
906      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
907      */
908     function toHexString(uint256 value) internal pure returns (string memory) {
909         if (value == 0) {
910             return "0x00";
911         }
912         uint256 temp = value;
913         uint256 length = 0;
914         while (temp != 0) {
915             length++;
916             temp >>= 8;
917         }
918         return toHexString(value, length);
919     }
920 
921     /**
922      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
923      */
924     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
925         bytes memory buffer = new bytes(2 * length + 2);
926         buffer[0] = "0";
927         buffer[1] = "x";
928         for (uint256 i = 2 * length + 1; i > 1; --i) {
929             buffer[i] = _HEX_SYMBOLS[value & 0xf];
930             value >>= 4;
931         }
932         require(value == 0, "Strings: hex length insufficient");
933         return string(buffer);
934     }
935 }
936 
937 
938 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
939 
940 
941 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
942 
943 pragma solidity ^0.8.0;
944 
945 /**
946  * @dev Implementation of the {IERC165} interface.
947  *
948  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
949  * for the additional interface id that will be supported. For example:
950  *
951  * ```solidity
952  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
953  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
954  * }
955  * ```
956  *
957  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
958  */
959 abstract contract ERC165 is IERC165 {
960     /**
961      * @dev See {IERC165-supportsInterface}.
962      */
963     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
964         return interfaceId == type(IERC165).interfaceId;
965     }
966 }
967 
968 
969 // File contracts/ERC721A.sol
970 
971 
972 // Creator: Chiru Labs
973 
974 pragma solidity ^0.8.0;
975 /**
976  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
977  * the Metadata extension. Built to optimize for lower gas during batch mints.
978  *
979  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
980  *
981  * Does not support burning tokens to address(0).
982  *
983  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
984  */
985 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
986     using Address for address;
987     using Strings for uint256;
988 
989     struct TokenOwnership {
990         address addr;
991         uint64 startTimestamp;
992     }
993 
994     struct AddressData {
995         uint128 balance;
996         uint128 numberMinted;
997     }
998 
999     uint256 internal currentIndex;
1000 
1001     // Token name
1002     string private _name;
1003 
1004     // Token symbol
1005     string private _symbol;
1006 
1007     // Mapping from token ID to ownership details
1008     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1009     mapping(uint256 => TokenOwnership) internal _ownerships;
1010 
1011     // Mapping owner address to address data
1012     mapping(address => AddressData) private _addressData;
1013 
1014     // Mapping from token ID to approved address
1015     mapping(uint256 => address) private _tokenApprovals;
1016 
1017     // Mapping from owner to operator approvals
1018     mapping(address => mapping(address => bool)) private _operatorApprovals;
1019 
1020     constructor(string memory name_, string memory symbol_) {
1021         _name = name_;
1022         _symbol = symbol_;
1023     }
1024 
1025     function totalSupply() public view returns (uint256) {
1026         return currentIndex;
1027     }
1028 
1029     /**
1030      * @dev See {IERC165-supportsInterface}.
1031      */
1032     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1033         return
1034         interfaceId == type(IERC721).interfaceId ||
1035         interfaceId == type(IERC721Metadata).interfaceId ||
1036         super.supportsInterface(interfaceId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-balanceOf}.
1041      */
1042     function balanceOf(address owner) public view override returns (uint256) {
1043         require(owner != address(0), 'ERC721A: balance query for the zero address');
1044         return uint256(_addressData[owner].balance);
1045     }
1046 
1047     function _numberMinted(address owner) internal view returns (uint256) {
1048         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1049         return uint256(_addressData[owner].numberMinted);
1050     }
1051 
1052     /**
1053      * Gas spent here starts off proportional to the maximum mint batch size.
1054      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1055      */
1056     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1057         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1058 
1059     unchecked {
1060         for (uint256 curr = tokenId; curr >= 0; curr--) {
1061             TokenOwnership memory ownership = _ownerships[curr];
1062             if (ownership.addr != address(0)) {
1063                 return ownership;
1064             }
1065         }
1066     }
1067 
1068         revert('ERC721A: unable to determine the owner of token');
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-ownerOf}.
1073      */
1074     function ownerOf(uint256 tokenId) public view override returns (address) {
1075         return ownershipOf(tokenId).addr;
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-name}.
1080      */
1081     function name() public view virtual override returns (string memory) {
1082         return _name;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-symbol}.
1087      */
1088     function symbol() public view virtual override returns (string memory) {
1089         return _symbol;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Metadata-tokenURI}.
1094      */
1095     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1096         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1097 
1098         string memory baseURI = _baseURI();
1099         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1100     }
1101 
1102     /**
1103      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1104      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1105      * by default, can be overriden in child contracts.
1106      */
1107     function _baseURI() internal view virtual returns (string memory) {
1108         return '';
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-approve}.
1113      */
1114     function approve(address to, uint256 tokenId) public override {
1115         address owner = ERC721A.ownerOf(tokenId);
1116         require(to != owner, 'ERC721A: approval to current owner');
1117 
1118         require(
1119             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1120             'ERC721A: approve caller is not owner nor approved for all'
1121         );
1122 
1123         _approve(to, tokenId, owner);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-getApproved}.
1128      */
1129     function getApproved(uint256 tokenId) public view override returns (address) {
1130         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1131 
1132         return _tokenApprovals[tokenId];
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-setApprovalForAll}.
1137      */
1138     function setApprovalForAll(address operator, bool approved) public override {
1139         require(operator != _msgSender(), 'ERC721A: approve to caller');
1140 
1141         _operatorApprovals[_msgSender()][operator] = approved;
1142         emit ApprovalForAll(_msgSender(), operator, approved);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-isApprovedForAll}.
1147      */
1148     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1149         return _operatorApprovals[owner][operator];
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-transferFrom}.
1154      */
1155     function transferFrom(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) public override {
1160         _transfer(from, to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-safeTransferFrom}.
1165      */
1166     function safeTransferFrom(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) public override {
1171         safeTransferFrom(from, to, tokenId, '');
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-safeTransferFrom}.
1176      */
1177     function safeTransferFrom(
1178         address from,
1179         address to,
1180         uint256 tokenId,
1181         bytes memory _data
1182     ) public override {
1183         _transfer(from, to, tokenId);
1184         require(
1185             _checkOnERC721Received(from, to, tokenId, _data),
1186             'ERC721A: transfer to non ERC721Receiver implementer'
1187         );
1188     }
1189 
1190     /**
1191      * @dev Returns whether `tokenId` exists.
1192      *
1193      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1194      *
1195      * Tokens start existing when they are minted (`_mint`),
1196      */
1197     function _exists(uint256 tokenId) internal view returns (bool) {
1198         return tokenId < currentIndex;
1199     }
1200 
1201     function _safeMint(address to, uint256 quantity) internal {
1202         _safeMint(to, quantity, '');
1203     }
1204 
1205     /**
1206      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _safeMint(
1216         address to,
1217         uint256 quantity,
1218         bytes memory _data
1219     ) internal {
1220         _mint(to, quantity, _data, true);
1221     }
1222 
1223     /**
1224      * @dev Mints `quantity` tokens and transfers them to `to`.
1225      *
1226      * Requirements:
1227      *
1228      * - `to` cannot be the zero address.
1229      * - `quantity` must be greater than 0.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _mint(
1234         address to,
1235         uint256 quantity,
1236         bytes memory _data,
1237         bool safe
1238     ) internal {
1239         uint256 startTokenId = currentIndex;
1240         require(to != address(0), 'ERC721A: mint to the zero address');
1241         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1242 
1243         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1244 
1245         // Overflows are incredibly unrealistic.
1246         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1247         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1248     unchecked {
1249         _addressData[to].balance += uint128(quantity);
1250         _addressData[to].numberMinted += uint128(quantity);
1251 
1252         _ownerships[startTokenId].addr = to;
1253         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1254 
1255         uint256 updatedIndex = startTokenId;
1256 
1257         for (uint256 i; i < quantity; i++) {
1258             emit Transfer(address(0), to, updatedIndex);
1259             if (safe) {
1260                 require(
1261                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1262                     'ERC721A: transfer to non ERC721Receiver implementer'
1263                 );
1264             }
1265 
1266             updatedIndex++;
1267         }
1268 
1269         currentIndex = updatedIndex;
1270     }
1271 
1272         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1273     }
1274 
1275     /**
1276      * @dev Transfers `tokenId` from `from` to `to`.
1277      *
1278      * Requirements:
1279      *
1280      * - `to` cannot be the zero address.
1281      * - `tokenId` token must be owned by `from`.
1282      *
1283      * Emits a {Transfer} event.
1284      */
1285     function _transfer(
1286         address from,
1287         address to,
1288         uint256 tokenId
1289     ) private {
1290         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1291 
1292         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1293         getApproved(tokenId) == _msgSender() ||
1294         isApprovedForAll(prevOwnership.addr, _msgSender()));
1295 
1296         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1297 
1298         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1299         require(to != address(0), 'ERC721A: transfer to the zero address');
1300 
1301         _beforeTokenTransfers(from, to, tokenId, 1);
1302 
1303         // Clear approvals from the previous owner
1304         _approve(address(0), tokenId, prevOwnership.addr);
1305 
1306         // Underflow of the sender's balance is impossible because we check for
1307         // ownership above and the recipient's balance can't realistically overflow.
1308         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1309     unchecked {
1310         _addressData[from].balance -= 1;
1311         _addressData[to].balance += 1;
1312 
1313         _ownerships[tokenId].addr = to;
1314         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1315 
1316         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1317         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1318         uint256 nextTokenId = tokenId + 1;
1319         if (_ownerships[nextTokenId].addr == address(0)) {
1320             if (_exists(nextTokenId)) {
1321                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1322                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1323             }
1324         }
1325     }
1326 
1327         emit Transfer(from, to, tokenId);
1328         _afterTokenTransfers(from, to, tokenId, 1);
1329     }
1330 
1331     /**
1332      * @dev Approve `to` to operate on `tokenId`
1333      *
1334      * Emits a {Approval} event.
1335      */
1336     function _approve(
1337         address to,
1338         uint256 tokenId,
1339         address owner
1340     ) private {
1341         _tokenApprovals[tokenId] = to;
1342         emit Approval(owner, to, tokenId);
1343     }
1344 
1345     /**
1346      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1347      * The call is not executed if the target address is not a contract.
1348      *
1349      * @param from address representing the previous owner of the given token ID
1350      * @param to target address that will receive the tokens
1351      * @param tokenId uint256 ID of the token to be transferred
1352      * @param _data bytes optional data to send along with the call
1353      * @return bool whether the call correctly returned the expected magic value
1354      */
1355     function _checkOnERC721Received(
1356         address from,
1357         address to,
1358         uint256 tokenId,
1359         bytes memory _data
1360     ) private returns (bool) {
1361         if (to.isContract()) {
1362             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1363                 return retval == IERC721Receiver(to).onERC721Received.selector;
1364             } catch (bytes memory reason) {
1365                 if (reason.length == 0) {
1366                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1367                 } else {
1368                     assembly {
1369                         revert(add(32, reason), mload(reason))
1370                     }
1371                 }
1372             }
1373         } else {
1374             return true;
1375         }
1376     }
1377 
1378     /**
1379      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1380      *
1381      * startTokenId - the first token id to be transferred
1382      * quantity - the amount to be transferred
1383      *
1384      * Calling conditions:
1385      *
1386      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1387      * transferred to `to`.
1388      * - When `from` is zero, `tokenId` will be minted for `to`.
1389      */
1390     function _beforeTokenTransfers(
1391         address from,
1392         address to,
1393         uint256 startTokenId,
1394         uint256 quantity
1395     ) internal virtual {}
1396 
1397     /**
1398      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1399      * minting.
1400      *
1401      * startTokenId - the first token id to be transferred
1402      * quantity - the amount to be transferred
1403      *
1404      * Calling conditions:
1405      *
1406      * - when `from` and `to` are both non-zero.
1407      * - `from` and `to` are never both zero.
1408      */
1409     function _afterTokenTransfers(
1410         address from,
1411         address to,
1412         uint256 startTokenId,
1413         uint256 quantity
1414     ) internal virtual {}
1415 }
1416 
1417 pragma solidity ^0.8.0;
1418 contract evilpablos is Ownable, ERC721A, ReentrancyGuard {
1419     using SafeMath for uint256;
1420    
1421     bool private _isActive = false;
1422 
1423     uint256 public constant MAX_SUPPLY = 6666;
1424 
1425     uint256 public maxCountPerAccount = 25; 
1426     
1427     uint256 public price = 0 ether;
1428 
1429     string private _tokenBaseURI = "ipfs://Qmd75U3aXUKLK3FFoeGy7kqHN41iLG8PbxS34EpLLbrr3B/";
1430 
1431     mapping(address => uint256) public minted;
1432 
1433     modifier onlyActive() {
1434         require(_isActive && totalSupply() < MAX_SUPPLY, 'not active');
1435         _;
1436     }
1437 
1438     constructor() ERC721A("evilpablos", "evilpablos") {
1439     }
1440 
1441     function mint(uint256 numberOfTokens) external payable onlyActive nonReentrant() {
1442         require(numberOfTokens > 0, "zero count");
1443         require(numberOfTokens <= MAX_SUPPLY.sub(totalSupply()), "not enough nfts");
1444         require(numberOfTokens.add(minted[msg.sender]) <= maxCountPerAccount, "already max minted");
1445         
1446         minted[msg.sender] = minted[msg.sender].add(numberOfTokens);
1447 
1448         _safeMint(msg.sender, numberOfTokens);
1449     }
1450 
1451     function _baseURI() internal view override returns (string memory) {
1452         return _tokenBaseURI;
1453     }
1454 
1455     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory)
1456     {
1457         return super.tokenURI(tokenId);
1458     }
1459 
1460     
1461     /////////////////////////////////////////////////////////////
1462     //////////////////   Admin Functions ////////////////////////
1463     /////////////////////////////////////////////////////////////
1464     function startSale() external onlyOwner {
1465         _isActive = true;
1466     }
1467 
1468     function endSale() external onlyOwner {
1469         _isActive = false;
1470     }
1471 
1472     function setPrice(uint256 _price) external onlyOwner {
1473         price = _price;
1474     }
1475 
1476     function setMaxMintPerAddr(uint256 _count) external onlyOwner {
1477         maxCountPerAccount = _count;
1478     }
1479 
1480     function setTokenBaseURI(string memory URI) external onlyOwner {
1481         _tokenBaseURI = URI;
1482     }
1483 
1484     function withdraw() external onlyOwner nonReentrant {
1485         uint256 balance = address(this).balance;
1486         Address.sendValue(payable(owner()), balance);
1487     }
1488 
1489     receive() external payable {}
1490 }