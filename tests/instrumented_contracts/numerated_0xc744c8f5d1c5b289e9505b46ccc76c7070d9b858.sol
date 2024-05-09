1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-01
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-07
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 
35 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
36 
37 
38 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 
113 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.6.0
114 
115 
116 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 // CAUTION
121 // This version of SafeMath should only be used with Solidity 0.8 or later,
122 // because it relies on the compiler's built in overflow checks.
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations.
126  *
127  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
128  * now has built in overflow checking.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         unchecked {
138             uint256 c = a + b;
139             if (c < a) return (false, 0);
140             return (true, c);
141         }
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
146      *
147      * _Available since v3.4._
148      */
149     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
150         unchecked {
151             if (b > a) return (false, 0);
152             return (true, a - b);
153         }
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         unchecked {
163             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164             // benefit is lost if 'b' is also tested.
165             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166             if (a == 0) return (true, 0);
167             uint256 c = a * b;
168             if (c / a != b) return (false, 0);
169             return (true, c);
170         }
171     }
172 
173     /**
174      * @dev Returns the division of two unsigned integers, with a division by zero flag.
175      *
176      * _Available since v3.4._
177      */
178     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
179         unchecked {
180             if (b == 0) return (false, 0);
181             return (true, a / b);
182         }
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
187      *
188      * _Available since v3.4._
189      */
190     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
191         unchecked {
192             if (b == 0) return (false, 0);
193             return (true, a % b);
194         }
195     }
196 
197     /**
198      * @dev Returns the addition of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `+` operator.
202      *
203      * Requirements:
204      *
205      * - Addition cannot overflow.
206      */
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a + b;
209     }
210 
211     /**
212      * @dev Returns the subtraction of two unsigned integers, reverting on
213      * overflow (when the result is negative).
214      *
215      * Counterpart to Solidity's `-` operator.
216      *
217      * Requirements:
218      *
219      * - Subtraction cannot overflow.
220      */
221     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a - b;
223     }
224 
225     /**
226      * @dev Returns the multiplication of two unsigned integers, reverting on
227      * overflow.
228      *
229      * Counterpart to Solidity's `*` operator.
230      *
231      * Requirements:
232      *
233      * - Multiplication cannot overflow.
234      */
235     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a * b;
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers, reverting on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator.
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(uint256 a, uint256 b) internal pure returns (uint256) {
250         return a / b;
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * reverting when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         return a % b;
267     }
268 
269     /**
270      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
271      * overflow (when the result is negative).
272      *
273      * CAUTION: This function is deprecated because it requires allocating memory for the error
274      * message unnecessarily. For custom revert reasons use {trySub}.
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         unchecked {
288             require(b <= a, errorMessage);
289             return a - b;
290         }
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
295      * division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function div(
306         uint256 a,
307         uint256 b,
308         string memory errorMessage
309     ) internal pure returns (uint256) {
310         unchecked {
311             require(b > 0, errorMessage);
312             return a / b;
313         }
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * reverting with custom message when dividing by zero.
319      *
320      * CAUTION: This function is deprecated because it requires allocating memory for the error
321      * message unnecessarily. For custom revert reasons use {tryMod}.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(
332         uint256 a,
333         uint256 b,
334         string memory errorMessage
335     ) internal pure returns (uint256) {
336         unchecked {
337             require(b > 0, errorMessage);
338             return a % b;
339         }
340     }
341 }
342 
343 
344 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev Interface of the ERC165 standard, as defined in the
353  * https://eips.ethereum.org/EIPS/eip-165[EIP].
354  *
355  * Implementers can declare support of contract interfaces, which can then be
356  * queried by others ({ERC165Checker}).
357  *
358  * For an implementation, see {ERC165}.
359  */
360 interface IERC165 {
361     /**
362      * @dev Returns true if this contract implements the interface defined by
363      * `interfaceId`. See the corresponding
364      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
365      * to learn more about how these ids are created.
366      *
367      * This function call must use less than 30 000 gas.
368      */
369     function supportsInterface(bytes4 interfaceId) external view returns (bool);
370 }
371 
372 
373 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
374 
375 
376 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev Required interface of an ERC721 compliant contract.
382  */
383 interface IERC721 is IERC165 {
384     /**
385      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
391      */
392     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
396      */
397     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
398 
399     /**
400      * @dev Returns the number of tokens in ``owner``'s account.
401      */
402     function balanceOf(address owner) external view returns (uint256 balance);
403 
404     /**
405      * @dev Returns the owner of the `tokenId` token.
406      *
407      * Requirements:
408      *
409      * - `tokenId` must exist.
410      */
411     function ownerOf(uint256 tokenId) external view returns (address owner);
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`.
415      *
416      * Requirements:
417      *
418      * - `from` cannot be the zero address.
419      * - `to` cannot be the zero address.
420      * - `tokenId` token must exist and be owned by `from`.
421      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
422      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
423      *
424      * Emits a {Transfer} event.
425      */
426     function safeTransferFrom(
427         address from,
428         address to,
429         uint256 tokenId,
430         bytes calldata data
431     ) external;
432 
433     /**
434      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
435      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Transfers `tokenId` token from `from` to `to`.
455      *
456      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must be owned by `from`.
463      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
464      *
465      * Emits a {Transfer} event.
466      */
467     function transferFrom(
468         address from,
469         address to,
470         uint256 tokenId
471     ) external;
472 
473     /**
474      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
475      * The approval is cleared when the token is transferred.
476      *
477      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
478      *
479      * Requirements:
480      *
481      * - The caller must own the token or be an approved operator.
482      * - `tokenId` must exist.
483      *
484      * Emits an {Approval} event.
485      */
486     function approve(address to, uint256 tokenId) external;
487 
488     /**
489      * @dev Approve or remove `operator` as an operator for the caller.
490      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
491      *
492      * Requirements:
493      *
494      * - The `operator` cannot be the caller.
495      *
496      * Emits an {ApprovalForAll} event.
497      */
498     function setApprovalForAll(address operator, bool _approved) external;
499 
500     /**
501      * @dev Returns the account approved for `tokenId` token.
502      *
503      * Requirements:
504      *
505      * - `tokenId` must exist.
506      */
507     function getApproved(uint256 tokenId) external view returns (address operator);
508 
509     /**
510      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
511      *
512      * See {setApprovalForAll}
513      */
514     function isApprovedForAll(address owner, address operator) external view returns (bool);
515 }
516 
517 
518 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
519 
520 
521 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Contract module that helps prevent reentrant calls to a function.
527  *
528  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
529  * available, which can be applied to functions to make sure there are no nested
530  * (reentrant) calls to them.
531  *
532  * Note that because there is a single `nonReentrant` guard, functions marked as
533  * `nonReentrant` may not call one another. This can be worked around by making
534  * those functions `private`, and then adding `external` `nonReentrant` entry
535  * points to them.
536  *
537  * TIP: If you would like to learn more about reentrancy and alternative ways
538  * to protect against it, check out our blog post
539  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
540  */
541 abstract contract ReentrancyGuard {
542     // Booleans are more expensive than uint256 or any type that takes up a full
543     // word because each write operation emits an extra SLOAD to first read the
544     // slot's contents, replace the bits taken up by the boolean, and then write
545     // back. This is the compiler's defense against contract upgrades and
546     // pointer aliasing, and it cannot be disabled.
547 
548     // The values being non-zero value makes deployment a bit more expensive,
549     // but in exchange the refund on every call to nonReentrant will be lower in
550     // amount. Since refunds are capped to a percentage of the total
551     // transaction's gas, it is best to keep them low in cases like this one, to
552     // increase the likelihood of the full refund coming into effect.
553     uint256 private constant _NOT_ENTERED = 1;
554     uint256 private constant _ENTERED = 2;
555 
556     uint256 private _status;
557 
558     constructor() {
559         _status = _NOT_ENTERED;
560     }
561 
562     /**
563      * @dev Prevents a contract from calling itself, directly or indirectly.
564      * Calling a `nonReentrant` function from another `nonReentrant`
565      * function is not supported. It is possible to prevent this from happening
566      * by making the `nonReentrant` function external, and making it call a
567      * `private` function that does the actual work.
568      */
569     modifier nonReentrant() {
570         // On the first call to nonReentrant, _notEntered will be true
571         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
572 
573         // Any calls to nonReentrant after this point will fail
574         _status = _ENTERED;
575 
576         _;
577 
578         // By storing the original value once again, a refund is triggered (see
579         // https://eips.ethereum.org/EIPS/eip-2200)
580         _status = _NOT_ENTERED;
581     }
582 }
583 
584 
585 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
586 
587 
588 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @title ERC721 token receiver interface
594  * @dev Interface for any contract that wants to support safeTransfers
595  * from ERC721 asset contracts.
596  */
597 interface IERC721Receiver {
598     /**
599      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
600      * by `operator` from `from`, this function is called.
601      *
602      * It must return its Solidity selector to confirm the token transfer.
603      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
604      *
605      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
606      */
607     function onERC721Received(
608         address operator,
609         address from,
610         uint256 tokenId,
611         bytes calldata data
612     ) external returns (bytes4);
613 }
614 
615 
616 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 /**
624  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
625  * @dev See https://eips.ethereum.org/EIPS/eip-721
626  */
627 interface IERC721Metadata is IERC721 {
628     /**
629      * @dev Returns the token collection name.
630      */
631     function name() external view returns (string memory);
632 
633     /**
634      * @dev Returns the token collection symbol.
635      */
636     function symbol() external view returns (string memory);
637 
638     /**
639      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
640      */
641     function tokenURI(uint256 tokenId) external view returns (string memory);
642 }
643 
644 
645 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
646 
647 
648 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
649 
650 pragma solidity ^0.8.1;
651 
652 /**
653  * @dev Collection of functions related to the address type
654  */
655 library Address {
656     /**
657      * @dev Returns true if `account` is a contract.
658      *
659      * [IMPORTANT]
660      * ====
661      * It is unsafe to assume that an address for which this function returns
662      * false is an externally-owned account (EOA) and not a contract.
663      *
664      * Among others, `isContract` will return false for the following
665      * types of addresses:
666      *
667      *  - an externally-owned account
668      *  - a contract in construction
669      *  - an address where a contract will be created
670      *  - an address where a contract lived, but was destroyed
671      * ====
672      *
673      * [IMPORTANT]
674      * ====
675      * You shouldn't rely on `isContract` to protect against flash loan attacks!
676      *
677      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
678      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
679      * constructor.
680      * ====
681      */
682     function isContract(address account) internal view returns (bool) {
683         // This method relies on extcodesize/address.code.length, which returns 0
684         // for contracts in construction, since the code is only stored at the end
685         // of the constructor execution.
686 
687         return account.code.length > 0;
688     }
689 
690     /**
691      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
692      * `recipient`, forwarding all available gas and reverting on errors.
693      *
694      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
695      * of certain opcodes, possibly making contracts go over the 2300 gas limit
696      * imposed by `transfer`, making them unable to receive funds via
697      * `transfer`. {sendValue} removes this limitation.
698      *
699      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
700      *
701      * IMPORTANT: because control is transferred to `recipient`, care must be
702      * taken to not create reentrancy vulnerabilities. Consider using
703      * {ReentrancyGuard} or the
704      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
705      */
706     function sendValue(address payable recipient, uint256 amount) internal {
707         require(address(this).balance >= amount, "Address: insufficient balance");
708 
709         (bool success, ) = recipient.call{value: amount}("");
710         require(success, "Address: unable to send value, recipient may have reverted");
711     }
712 
713     /**
714      * @dev Performs a Solidity function call using a low level `call`. A
715      * plain `call` is an unsafe replacement for a function call: use this
716      * function instead.
717      *
718      * If `target` reverts with a revert reason, it is bubbled up by this
719      * function (like regular Solidity function calls).
720      *
721      * Returns the raw returned data. To convert to the expected return value,
722      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
723      *
724      * Requirements:
725      *
726      * - `target` must be a contract.
727      * - calling `target` with `data` must not revert.
728      *
729      * _Available since v3.1._
730      */
731     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
732         return functionCall(target, data, "Address: low-level call failed");
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
737      * `errorMessage` as a fallback revert reason when `target` reverts.
738      *
739      * _Available since v3.1._
740      */
741     function functionCall(
742         address target,
743         bytes memory data,
744         string memory errorMessage
745     ) internal returns (bytes memory) {
746         return functionCallWithValue(target, data, 0, errorMessage);
747     }
748 
749     /**
750      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
751      * but also transferring `value` wei to `target`.
752      *
753      * Requirements:
754      *
755      * - the calling contract must have an ETH balance of at least `value`.
756      * - the called Solidity function must be `payable`.
757      *
758      * _Available since v3.1._
759      */
760     function functionCallWithValue(
761         address target,
762         bytes memory data,
763         uint256 value
764     ) internal returns (bytes memory) {
765         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
766     }
767 
768     /**
769      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
770      * with `errorMessage` as a fallback revert reason when `target` reverts.
771      *
772      * _Available since v3.1._
773      */
774     function functionCallWithValue(
775         address target,
776         bytes memory data,
777         uint256 value,
778         string memory errorMessage
779     ) internal returns (bytes memory) {
780         require(address(this).balance >= value, "Address: insufficient balance for call");
781         require(isContract(target), "Address: call to non-contract");
782 
783         (bool success, bytes memory returndata) = target.call{value: value}(data);
784         return verifyCallResult(success, returndata, errorMessage);
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
789      * but performing a static call.
790      *
791      * _Available since v3.3._
792      */
793     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
794         return functionStaticCall(target, data, "Address: low-level static call failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
799      * but performing a static call.
800      *
801      * _Available since v3.3._
802      */
803     function functionStaticCall(
804         address target,
805         bytes memory data,
806         string memory errorMessage
807     ) internal view returns (bytes memory) {
808         require(isContract(target), "Address: static call to non-contract");
809 
810         (bool success, bytes memory returndata) = target.staticcall(data);
811         return verifyCallResult(success, returndata, errorMessage);
812     }
813 
814     /**
815      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
816      * but performing a delegate call.
817      *
818      * _Available since v3.4._
819      */
820     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
821         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
822     }
823 
824     /**
825      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
826      * but performing a delegate call.
827      *
828      * _Available since v3.4._
829      */
830     function functionDelegateCall(
831         address target,
832         bytes memory data,
833         string memory errorMessage
834     ) internal returns (bytes memory) {
835         require(isContract(target), "Address: delegate call to non-contract");
836 
837         (bool success, bytes memory returndata) = target.delegatecall(data);
838         return verifyCallResult(success, returndata, errorMessage);
839     }
840 
841     /**
842      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
843      * revert reason using the provided one.
844      *
845      * _Available since v4.3._
846      */
847     function verifyCallResult(
848         bool success,
849         bytes memory returndata,
850         string memory errorMessage
851     ) internal pure returns (bytes memory) {
852         if (success) {
853             return returndata;
854         } else {
855             // Look for revert reason and bubble it up if present
856             if (returndata.length > 0) {
857                 // The easiest way to bubble the revert reason is using memory via assembly
858 
859                 assembly {
860                     let returndata_size := mload(returndata)
861                     revert(add(32, returndata), returndata_size)
862                 }
863             } else {
864                 revert(errorMessage);
865             }
866         }
867     }
868 }
869 
870 
871 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
872 
873 
874 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
875 
876 pragma solidity ^0.8.0;
877 
878 /**
879  * @dev String operations.
880  */
881 library Strings {
882     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
883 
884     /**
885      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
886      */
887     function toString(uint256 value) internal pure returns (string memory) {
888         // Inspired by OraclizeAPI's implementation - MIT licence
889         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
890 
891         if (value == 0) {
892             return "0";
893         }
894         uint256 temp = value;
895         uint256 digits;
896         while (temp != 0) {
897             digits++;
898             temp /= 10;
899         }
900         bytes memory buffer = new bytes(digits);
901         while (value != 0) {
902             digits -= 1;
903             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
904             value /= 10;
905         }
906         return string(buffer);
907     }
908 
909     /**
910      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
911      */
912     function toHexString(uint256 value) internal pure returns (string memory) {
913         if (value == 0) {
914             return "0x00";
915         }
916         uint256 temp = value;
917         uint256 length = 0;
918         while (temp != 0) {
919             length++;
920             temp >>= 8;
921         }
922         return toHexString(value, length);
923     }
924 
925     /**
926      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
927      */
928     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
929         bytes memory buffer = new bytes(2 * length + 2);
930         buffer[0] = "0";
931         buffer[1] = "x";
932         for (uint256 i = 2 * length + 1; i > 1; --i) {
933             buffer[i] = _HEX_SYMBOLS[value & 0xf];
934             value >>= 4;
935         }
936         require(value == 0, "Strings: hex length insufficient");
937         return string(buffer);
938     }
939 }
940 
941 
942 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
943 
944 
945 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
946 
947 pragma solidity ^0.8.0;
948 
949 /**
950  * @dev Implementation of the {IERC165} interface.
951  *
952  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
953  * for the additional interface id that will be supported. For example:
954  *
955  * ```solidity
956  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
957  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
958  * }
959  * ```
960  *
961  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
962  */
963 abstract contract ERC165 is IERC165 {
964     /**
965      * @dev See {IERC165-supportsInterface}.
966      */
967     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
968         return interfaceId == type(IERC165).interfaceId;
969     }
970 }
971 
972 
973 // File contracts/ERC721A.sol
974 
975 
976 // Creator: Chiru Labs
977 
978 pragma solidity ^0.8.0;
979 /**
980  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
981  * the Metadata extension. Built to optimize for lower gas during batch mints.
982  *
983  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
984  *
985  * Does not support burning tokens to address(0).
986  *
987  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
988  */
989 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
990     using Address for address;
991     using Strings for uint256;
992 
993     struct TokenOwnership {
994         address addr;
995         uint64 startTimestamp;
996     }
997 
998     struct AddressData {
999         uint128 balance;
1000         uint128 numberMinted;
1001     }
1002 
1003     uint256 internal currentIndex;
1004 
1005     // Token name
1006     string private _name;
1007 
1008     // Token symbol
1009     string private _symbol;
1010 
1011     // Mapping from token ID to ownership details
1012     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1013     mapping(uint256 => TokenOwnership) internal _ownerships;
1014 
1015     // Mapping owner address to address data
1016     mapping(address => AddressData) private _addressData;
1017 
1018     // Mapping from token ID to approved address
1019     mapping(uint256 => address) private _tokenApprovals;
1020 
1021     // Mapping from owner to operator approvals
1022     mapping(address => mapping(address => bool)) private _operatorApprovals;
1023 
1024     constructor(string memory name_, string memory symbol_) {
1025         _name = name_;
1026         _symbol = symbol_;
1027     }
1028 
1029     function totalSupply() public view returns (uint256) {
1030         return currentIndex;
1031     }
1032 
1033     /**
1034      * @dev See {IERC165-supportsInterface}.
1035      */
1036     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1037         return
1038         interfaceId == type(IERC721).interfaceId ||
1039         interfaceId == type(IERC721Metadata).interfaceId ||
1040         super.supportsInterface(interfaceId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-balanceOf}.
1045      */
1046     function balanceOf(address owner) public view override returns (uint256) {
1047         require(owner != address(0), 'ERC721A: balance query for the zero address');
1048         return uint256(_addressData[owner].balance);
1049     }
1050 
1051     function _numberMinted(address owner) internal view returns (uint256) {
1052         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1053         return uint256(_addressData[owner].numberMinted);
1054     }
1055 
1056     /**
1057      * Gas spent here starts off proportional to the maximum mint batch size.
1058      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1059      */
1060     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1061         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1062 
1063     unchecked {
1064         for (uint256 curr = tokenId; curr >= 0; curr--) {
1065             TokenOwnership memory ownership = _ownerships[curr];
1066             if (ownership.addr != address(0)) {
1067                 return ownership;
1068             }
1069         }
1070     }
1071 
1072         revert('ERC721A: unable to determine the owner of token');
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-ownerOf}.
1077      */
1078     function ownerOf(uint256 tokenId) public view override returns (address) {
1079         return ownershipOf(tokenId).addr;
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Metadata-name}.
1084      */
1085     function name() public view virtual override returns (string memory) {
1086         return _name;
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Metadata-symbol}.
1091      */
1092     function symbol() public view virtual override returns (string memory) {
1093         return _symbol;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Metadata-tokenURI}.
1098      */
1099     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1100         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1101 
1102         string memory baseURI = _baseURI();
1103         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1104     }
1105 
1106     /**
1107      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1108      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1109      * by default, can be overriden in child contracts.
1110      */
1111     function _baseURI() internal view virtual returns (string memory) {
1112         return '';
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-approve}.
1117      */
1118     function approve(address to, uint256 tokenId) public override {
1119         address owner = ERC721A.ownerOf(tokenId);
1120         require(to != owner, 'ERC721A: approval to current owner');
1121 
1122         require(
1123             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1124             'ERC721A: approve caller is not owner nor approved for all'
1125         );
1126 
1127         _approve(to, tokenId, owner);
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-getApproved}.
1132      */
1133     function getApproved(uint256 tokenId) public view override returns (address) {
1134         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1135 
1136         return _tokenApprovals[tokenId];
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-setApprovalForAll}.
1141      */
1142     function setApprovalForAll(address operator, bool approved) public override {
1143         require(operator != _msgSender(), 'ERC721A: approve to caller');
1144 
1145         _operatorApprovals[_msgSender()][operator] = approved;
1146         emit ApprovalForAll(_msgSender(), operator, approved);
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-isApprovedForAll}.
1151      */
1152     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1153         return _operatorApprovals[owner][operator];
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-transferFrom}.
1158      */
1159     function transferFrom(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) public override {
1164         _transfer(from, to, tokenId);
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-safeTransferFrom}.
1169      */
1170     function safeTransferFrom(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) public override {
1175         safeTransferFrom(from, to, tokenId, '');
1176     }
1177 
1178     /**
1179      * @dev See {IERC721-safeTransferFrom}.
1180      */
1181     function safeTransferFrom(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes memory _data
1186     ) public override {
1187         _transfer(from, to, tokenId);
1188         require(
1189             _checkOnERC721Received(from, to, tokenId, _data),
1190             'ERC721A: transfer to non ERC721Receiver implementer'
1191         );
1192     }
1193 
1194     /**
1195      * @dev Returns whether `tokenId` exists.
1196      *
1197      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1198      *
1199      * Tokens start existing when they are minted (`_mint`),
1200      */
1201     function _exists(uint256 tokenId) internal view returns (bool) {
1202         return tokenId < currentIndex;
1203     }
1204 
1205     function _safeMint(address to, uint256 quantity) internal {
1206         _safeMint(to, quantity, '');
1207     }
1208 
1209     /**
1210      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1211      *
1212      * Requirements:
1213      *
1214      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1215      * - `quantity` must be greater than 0.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _safeMint(
1220         address to,
1221         uint256 quantity,
1222         bytes memory _data
1223     ) internal {
1224         _mint(to, quantity, _data, true);
1225     }
1226 
1227     /**
1228      * @dev Mints `quantity` tokens and transfers them to `to`.
1229      *
1230      * Requirements:
1231      *
1232      * - `to` cannot be the zero address.
1233      * - `quantity` must be greater than 0.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _mint(
1238         address to,
1239         uint256 quantity,
1240         bytes memory _data,
1241         bool safe
1242     ) internal {
1243         uint256 startTokenId = currentIndex;
1244         require(to != address(0), 'ERC721A: mint to the zero address');
1245         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1246 
1247         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1248 
1249         // Overflows are incredibly unrealistic.
1250         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1251         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1252     unchecked {
1253         _addressData[to].balance += uint128(quantity);
1254         _addressData[to].numberMinted += uint128(quantity);
1255 
1256         _ownerships[startTokenId].addr = to;
1257         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1258 
1259         uint256 updatedIndex = startTokenId;
1260 
1261         for (uint256 i; i < quantity; i++) {
1262             emit Transfer(address(0), to, updatedIndex);
1263             if (safe) {
1264                 require(
1265                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1266                     'ERC721A: transfer to non ERC721Receiver implementer'
1267                 );
1268             }
1269 
1270             updatedIndex++;
1271         }
1272 
1273         currentIndex = updatedIndex;
1274     }
1275 
1276         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1277     }
1278 
1279     /**
1280      * @dev Transfers `tokenId` from `from` to `to`.
1281      *
1282      * Requirements:
1283      *
1284      * - `to` cannot be the zero address.
1285      * - `tokenId` token must be owned by `from`.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _transfer(
1290         address from,
1291         address to,
1292         uint256 tokenId
1293     ) private {
1294         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1295 
1296         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1297         getApproved(tokenId) == _msgSender() ||
1298         isApprovedForAll(prevOwnership.addr, _msgSender()));
1299 
1300         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1301 
1302         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1303         require(to != address(0), 'ERC721A: transfer to the zero address');
1304 
1305         _beforeTokenTransfers(from, to, tokenId, 1);
1306 
1307         // Clear approvals from the previous owner
1308         _approve(address(0), tokenId, prevOwnership.addr);
1309 
1310         // Underflow of the sender's balance is impossible because we check for
1311         // ownership above and the recipient's balance can't realistically overflow.
1312         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1313     unchecked {
1314         _addressData[from].balance -= 1;
1315         _addressData[to].balance += 1;
1316 
1317         _ownerships[tokenId].addr = to;
1318         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1319 
1320         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1321         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1322         uint256 nextTokenId = tokenId + 1;
1323         if (_ownerships[nextTokenId].addr == address(0)) {
1324             if (_exists(nextTokenId)) {
1325                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1326                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1327             }
1328         }
1329     }
1330 
1331         emit Transfer(from, to, tokenId);
1332         _afterTokenTransfers(from, to, tokenId, 1);
1333     }
1334 
1335     /**
1336      * @dev Approve `to` to operate on `tokenId`
1337      *
1338      * Emits a {Approval} event.
1339      */
1340     function _approve(
1341         address to,
1342         uint256 tokenId,
1343         address owner
1344     ) private {
1345         _tokenApprovals[tokenId] = to;
1346         emit Approval(owner, to, tokenId);
1347     }
1348 
1349     /**
1350      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1351      * The call is not executed if the target address is not a contract.
1352      *
1353      * @param from address representing the previous owner of the given token ID
1354      * @param to target address that will receive the tokens
1355      * @param tokenId uint256 ID of the token to be transferred
1356      * @param _data bytes optional data to send along with the call
1357      * @return bool whether the call correctly returned the expected magic value
1358      */
1359     function _checkOnERC721Received(
1360         address from,
1361         address to,
1362         uint256 tokenId,
1363         bytes memory _data
1364     ) private returns (bool) {
1365         if (to.isContract()) {
1366             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1367                 return retval == IERC721Receiver(to).onERC721Received.selector;
1368             } catch (bytes memory reason) {
1369                 if (reason.length == 0) {
1370                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1371                 } else {
1372                     assembly {
1373                         revert(add(32, reason), mload(reason))
1374                     }
1375                 }
1376             }
1377         } else {
1378             return true;
1379         }
1380     }
1381 
1382     /**
1383      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1384      *
1385      * startTokenId - the first token id to be transferred
1386      * quantity - the amount to be transferred
1387      *
1388      * Calling conditions:
1389      *
1390      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1391      * transferred to `to`.
1392      * - When `from` is zero, `tokenId` will be minted for `to`.
1393      */
1394     function _beforeTokenTransfers(
1395         address from,
1396         address to,
1397         uint256 startTokenId,
1398         uint256 quantity
1399     ) internal virtual {}
1400 
1401     /**
1402      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1403      * minting.
1404      *
1405      * startTokenId - the first token id to be transferred
1406      * quantity - the amount to be transferred
1407      *
1408      * Calling conditions:
1409      *
1410      * - when `from` and `to` are both non-zero.
1411      * - `from` and `to` are never both zero.
1412      */
1413     function _afterTokenTransfers(
1414         address from,
1415         address to,
1416         uint256 startTokenId,
1417         uint256 quantity
1418     ) internal virtual {}
1419 }
1420 
1421 pragma solidity ^0.8.0;
1422 contract pabloslolXmoonpepes is Ownable, ERC721A, ReentrancyGuard {
1423     using SafeMath for uint256;
1424    
1425     bool public isHoldersActive = false;
1426 
1427     bool public isPublicActive = false;
1428 
1429     uint256 public constant MAX_SUPPLY = 969;
1430 
1431     uint256 public maxCountPerAccount = 1; 
1432     
1433     uint256 public priceHolder = 0 ether;
1434 
1435     uint256 public pricePublic = 0.01 ether;
1436 
1437     string private _tokenBaseURI = "";
1438 
1439     mapping(address => uint256) public minted;
1440 
1441     modifier onlyHoldersActive() {
1442         require(isHoldersActive && totalSupply() < MAX_SUPPLY, 'not active');
1443         _;
1444     }
1445 
1446     modifier onlyPublicActive() {
1447         require(isPublicActive && totalSupply() < MAX_SUPPLY, 'not active');
1448         _;
1449     }
1450 
1451     constructor() ERC721A("pabloslol X moonpepes", "pabloslol X moonpepes") {
1452     }
1453 
1454     function ownerMint(uint256 numberOfTokens) external payable onlyOwner nonReentrant() {
1455         require(numberOfTokens > 0, "zero count");
1456         require(msg.value >= priceHolder, "insufficient funds");
1457         require(numberOfTokens <= MAX_SUPPLY.sub(totalSupply()), "not enough nfts");
1458 
1459         minted[msg.sender] = minted[msg.sender].add(numberOfTokens);
1460 
1461         _safeMint(msg.sender, numberOfTokens);
1462     }
1463 
1464     function freeMint(uint256 numberOfTokens) external payable onlyHoldersActive nonReentrant() {
1465         require(numberOfTokens > 0, "zero count");
1466         require(msg.value >= priceHolder, "insufficient funds");
1467         require(numberOfTokens <= MAX_SUPPLY.sub(totalSupply()), "not enough nfts");
1468         require(numberOfTokens.add(minted[msg.sender]) <= maxCountPerAccount, "already max minted");
1469         require(
1470             IERC721(0xd3605059c3cE9fACf625Fa72D727508B7b7F280F).balanceOf(msg.sender) >= 10 || IERC721(0x02F74badcE458387ECAef9b1F229afB5678E9AAd).balanceOf(msg.sender) >= 20,
1471             "no nft"
1472         );
1473 
1474         minted[msg.sender] = minted[msg.sender].add(numberOfTokens);
1475 
1476         _safeMint(msg.sender, numberOfTokens);
1477     }
1478 
1479     function publicMint(uint256 numberOfTokens) external payable onlyPublicActive nonReentrant() {
1480         require(numberOfTokens > 0, "zero count");
1481         require(msg.value >= pricePublic, "insufficient funds");
1482         require(numberOfTokens <= MAX_SUPPLY.sub(totalSupply()), "not enough nfts");
1483         require(numberOfTokens.add(minted[msg.sender]) <= maxCountPerAccount, "already max minted");
1484         
1485         minted[msg.sender] = minted[msg.sender].add(numberOfTokens);
1486 
1487         _safeMint(msg.sender, numberOfTokens);
1488     }
1489 
1490     function _baseURI() internal view override returns (string memory) {
1491         return _tokenBaseURI;
1492     }
1493 
1494     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory)
1495     {
1496         return super.tokenURI(tokenId);
1497     }
1498     
1499     /////////////////////////////////////////////////////////////
1500     //////////////////   Admin Functions ////////////////////////
1501     /////////////////////////////////////////////////////////////
1502     function startSaleHolder() external onlyOwner {
1503         isHoldersActive = true;
1504     }
1505 
1506     function endSaleHolder() external onlyOwner {
1507         isHoldersActive = false;
1508     }
1509 
1510     function startSalePublic() external onlyOwner {
1511         isPublicActive = true;
1512     }
1513 
1514     function endSalePublic() external onlyOwner {
1515         isPublicActive = false;
1516     }
1517 
1518     function setPrice(uint256 _priceHolder, uint256 _pricePublic) external onlyOwner {
1519         priceHolder = _priceHolder;
1520         pricePublic = _pricePublic;
1521     }
1522 
1523     function setMaxMintPerAddr(uint256 _count) external onlyOwner {
1524         maxCountPerAccount = _count;
1525     }
1526 
1527     function setTokenBaseURI(string memory URI) external onlyOwner {
1528         _tokenBaseURI = URI;
1529     }
1530 
1531     function withdraw() external onlyOwner nonReentrant {
1532         uint256 balance = address(this).balance;
1533         Address.sendValue(payable(owner()), balance);
1534     }
1535 
1536     receive() external payable {}
1537 }