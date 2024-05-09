1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.0
27 
28 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         _checkOwner();
61         _;
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if the sender is not the owner.
73      */
74     function _checkOwner() internal view virtual {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 
110 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.7.0
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
340 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
341 
342 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Interface of the ERC165 standard, as defined in the
348  * https://eips.ethereum.org/EIPS/eip-165[EIP].
349  *
350  * Implementers can declare support of contract interfaces, which can then be
351  * queried by others ({ERC165Checker}).
352  *
353  * For an implementation, see {ERC165}.
354  */
355 interface IERC165 {
356     /**
357      * @dev Returns true if this contract implements the interface defined by
358      * `interfaceId`. See the corresponding
359      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
360      * to learn more about how these ids are created.
361      *
362      * This function call must use less than 30 000 gas.
363      */
364     function supportsInterface(bytes4 interfaceId) external view returns (bool);
365 }
366 
367 
368 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.0
369 
370 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Required interface of an ERC721 compliant contract.
376  */
377 interface IERC721 is IERC165 {
378     /**
379      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
380      */
381     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
382 
383     /**
384      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
385      */
386     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
387 
388     /**
389      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
390      */
391     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
392 
393     /**
394      * @dev Returns the number of tokens in ``owner``'s account.
395      */
396     function balanceOf(address owner) external view returns (uint256 balance);
397 
398     /**
399      * @dev Returns the owner of the `tokenId` token.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must exist.
404      */
405     function ownerOf(uint256 tokenId) external view returns (address owner);
406 
407     /**
408      * @dev Safely transfers `tokenId` token from `from` to `to`.
409      *
410      * Requirements:
411      *
412      * - `from` cannot be the zero address.
413      * - `to` cannot be the zero address.
414      * - `tokenId` token must exist and be owned by `from`.
415      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
417      *
418      * Emits a {Transfer} event.
419      */
420     function safeTransferFrom(
421         address from,
422         address to,
423         uint256 tokenId,
424         bytes calldata data
425     ) external;
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
429      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must exist and be owned by `from`.
436      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Transfers `tokenId` token from `from` to `to`.
449      *
450      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
458      *
459      * Emits a {Transfer} event.
460      */
461     function transferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) external;
466 
467     /**
468      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
469      * The approval is cleared when the token is transferred.
470      *
471      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
472      *
473      * Requirements:
474      *
475      * - The caller must own the token or be an approved operator.
476      * - `tokenId` must exist.
477      *
478      * Emits an {Approval} event.
479      */
480     function approve(address to, uint256 tokenId) external;
481 
482     /**
483      * @dev Approve or remove `operator` as an operator for the caller.
484      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
485      *
486      * Requirements:
487      *
488      * - The `operator` cannot be the caller.
489      *
490      * Emits an {ApprovalForAll} event.
491      */
492     function setApprovalForAll(address operator, bool _approved) external;
493 
494     /**
495      * @dev Returns the account approved for `tokenId` token.
496      *
497      * Requirements:
498      *
499      * - `tokenId` must exist.
500      */
501     function getApproved(uint256 tokenId) external view returns (address operator);
502 
503     /**
504      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
505      *
506      * See {setApprovalForAll}
507      */
508     function isApprovedForAll(address owner, address operator) external view returns (bool);
509 }
510 
511 
512 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.0
513 
514 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 /**
519  * @dev Contract module that helps prevent reentrant calls to a function.
520  *
521  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
522  * available, which can be applied to functions to make sure there are no nested
523  * (reentrant) calls to them.
524  *
525  * Note that because there is a single `nonReentrant` guard, functions marked as
526  * `nonReentrant` may not call one another. This can be worked around by making
527  * those functions `private`, and then adding `external` `nonReentrant` entry
528  * points to them.
529  *
530  * TIP: If you would like to learn more about reentrancy and alternative ways
531  * to protect against it, check out our blog post
532  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
533  */
534 abstract contract ReentrancyGuard {
535     // Booleans are more expensive than uint256 or any type that takes up a full
536     // word because each write operation emits an extra SLOAD to first read the
537     // slot's contents, replace the bits taken up by the boolean, and then write
538     // back. This is the compiler's defense against contract upgrades and
539     // pointer aliasing, and it cannot be disabled.
540 
541     // The values being non-zero value makes deployment a bit more expensive,
542     // but in exchange the refund on every call to nonReentrant will be lower in
543     // amount. Since refunds are capped to a percentage of the total
544     // transaction's gas, it is best to keep them low in cases like this one, to
545     // increase the likelihood of the full refund coming into effect.
546     uint256 private constant _NOT_ENTERED = 1;
547     uint256 private constant _ENTERED = 2;
548 
549     uint256 private _status;
550 
551     constructor() {
552         _status = _NOT_ENTERED;
553     }
554 
555     /**
556      * @dev Prevents a contract from calling itself, directly or indirectly.
557      * Calling a `nonReentrant` function from another `nonReentrant`
558      * function is not supported. It is possible to prevent this from happening
559      * by making the `nonReentrant` function external, and making it call a
560      * `private` function that does the actual work.
561      */
562     modifier nonReentrant() {
563         // On the first call to nonReentrant, _notEntered will be true
564         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
565 
566         // Any calls to nonReentrant after this point will fail
567         _status = _ENTERED;
568 
569         _;
570 
571         // By storing the original value once again, a refund is triggered (see
572         // https://eips.ethereum.org/EIPS/eip-2200)
573         _status = _NOT_ENTERED;
574     }
575 }
576 
577 
578 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.0
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
608 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.0
609 
610 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
616  * @dev See https://eips.ethereum.org/EIPS/eip-721
617  */
618 interface IERC721Metadata is IERC721 {
619     /**
620      * @dev Returns the token collection name.
621      */
622     function name() external view returns (string memory);
623 
624     /**
625      * @dev Returns the token collection symbol.
626      */
627     function symbol() external view returns (string memory);
628 
629     /**
630      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
631      */
632     function tokenURI(uint256 tokenId) external view returns (string memory);
633 }
634 
635 
636 // File @openzeppelin/contracts/utils/Address.sol@v4.7.0
637 
638 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
639 
640 pragma solidity ^0.8.1;
641 
642 /**
643  * @dev Collection of functions related to the address type
644  */
645 library Address {
646     /**
647      * @dev Returns true if `account` is a contract.
648      *
649      * [IMPORTANT]
650      * ====
651      * It is unsafe to assume that an address for which this function returns
652      * false is an externally-owned account (EOA) and not a contract.
653      *
654      * Among others, `isContract` will return false for the following
655      * types of addresses:
656      *
657      *  - an externally-owned account
658      *  - a contract in construction
659      *  - an address where a contract will be created
660      *  - an address where a contract lived, but was destroyed
661      * ====
662      *
663      * [IMPORTANT]
664      * ====
665      * You shouldn't rely on `isContract` to protect against flash loan attacks!
666      *
667      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
668      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
669      * constructor.
670      * ====
671      */
672     function isContract(address account) internal view returns (bool) {
673         // This method relies on extcodesize/address.code.length, which returns 0
674         // for contracts in construction, since the code is only stored at the end
675         // of the constructor execution.
676 
677         return account.code.length > 0;
678     }
679 
680     /**
681      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
682      * `recipient`, forwarding all available gas and reverting on errors.
683      *
684      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
685      * of certain opcodes, possibly making contracts go over the 2300 gas limit
686      * imposed by `transfer`, making them unable to receive funds via
687      * `transfer`. {sendValue} removes this limitation.
688      *
689      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
690      *
691      * IMPORTANT: because control is transferred to `recipient`, care must be
692      * taken to not create reentrancy vulnerabilities. Consider using
693      * {ReentrancyGuard} or the
694      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
695      */
696     function sendValue(address payable recipient, uint256 amount) internal {
697         require(address(this).balance >= amount, "Address: insufficient balance");
698 
699         (bool success, ) = recipient.call{value: amount}("");
700         require(success, "Address: unable to send value, recipient may have reverted");
701     }
702 
703     /**
704      * @dev Performs a Solidity function call using a low level `call`. A
705      * plain `call` is an unsafe replacement for a function call: use this
706      * function instead.
707      *
708      * If `target` reverts with a revert reason, it is bubbled up by this
709      * function (like regular Solidity function calls).
710      *
711      * Returns the raw returned data. To convert to the expected return value,
712      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
713      *
714      * Requirements:
715      *
716      * - `target` must be a contract.
717      * - calling `target` with `data` must not revert.
718      *
719      * _Available since v3.1._
720      */
721     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
722         return functionCall(target, data, "Address: low-level call failed");
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
727      * `errorMessage` as a fallback revert reason when `target` reverts.
728      *
729      * _Available since v3.1._
730      */
731     function functionCall(
732         address target,
733         bytes memory data,
734         string memory errorMessage
735     ) internal returns (bytes memory) {
736         return functionCallWithValue(target, data, 0, errorMessage);
737     }
738 
739     /**
740      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
741      * but also transferring `value` wei to `target`.
742      *
743      * Requirements:
744      *
745      * - the calling contract must have an ETH balance of at least `value`.
746      * - the called Solidity function must be `payable`.
747      *
748      * _Available since v3.1._
749      */
750     function functionCallWithValue(
751         address target,
752         bytes memory data,
753         uint256 value
754     ) internal returns (bytes memory) {
755         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
756     }
757 
758     /**
759      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
760      * with `errorMessage` as a fallback revert reason when `target` reverts.
761      *
762      * _Available since v3.1._
763      */
764     function functionCallWithValue(
765         address target,
766         bytes memory data,
767         uint256 value,
768         string memory errorMessage
769     ) internal returns (bytes memory) {
770         require(address(this).balance >= value, "Address: insufficient balance for call");
771         require(isContract(target), "Address: call to non-contract");
772 
773         (bool success, bytes memory returndata) = target.call{value: value}(data);
774         return verifyCallResult(success, returndata, errorMessage);
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
779      * but performing a static call.
780      *
781      * _Available since v3.3._
782      */
783     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
784         return functionStaticCall(target, data, "Address: low-level static call failed");
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
789      * but performing a static call.
790      *
791      * _Available since v3.3._
792      */
793     function functionStaticCall(
794         address target,
795         bytes memory data,
796         string memory errorMessage
797     ) internal view returns (bytes memory) {
798         require(isContract(target), "Address: static call to non-contract");
799 
800         (bool success, bytes memory returndata) = target.staticcall(data);
801         return verifyCallResult(success, returndata, errorMessage);
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
806      * but performing a delegate call.
807      *
808      * _Available since v3.4._
809      */
810     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
811         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
812     }
813 
814     /**
815      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
816      * but performing a delegate call.
817      *
818      * _Available since v3.4._
819      */
820     function functionDelegateCall(
821         address target,
822         bytes memory data,
823         string memory errorMessage
824     ) internal returns (bytes memory) {
825         require(isContract(target), "Address: delegate call to non-contract");
826 
827         (bool success, bytes memory returndata) = target.delegatecall(data);
828         return verifyCallResult(success, returndata, errorMessage);
829     }
830 
831     /**
832      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
833      * revert reason using the provided one.
834      *
835      * _Available since v4.3._
836      */
837     function verifyCallResult(
838         bool success,
839         bytes memory returndata,
840         string memory errorMessage
841     ) internal pure returns (bytes memory) {
842         if (success) {
843             return returndata;
844         } else {
845             // Look for revert reason and bubble it up if present
846             if (returndata.length > 0) {
847                 // The easiest way to bubble the revert reason is using memory via assembly
848                 /// @solidity memory-safe-assembly
849                 assembly {
850                     let returndata_size := mload(returndata)
851                     revert(add(32, returndata), returndata_size)
852                 }
853             } else {
854                 revert(errorMessage);
855             }
856         }
857     }
858 }
859 
860 
861 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.0
862 
863 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
864 
865 pragma solidity ^0.8.0;
866 
867 /**
868  * @dev String operations.
869  */
870 library Strings {
871     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
872     uint8 private constant _ADDRESS_LENGTH = 20;
873 
874     /**
875      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
876      */
877     function toString(uint256 value) internal pure returns (string memory) {
878         // Inspired by OraclizeAPI's implementation - MIT licence
879         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
880 
881         if (value == 0) {
882             return "0";
883         }
884         uint256 temp = value;
885         uint256 digits;
886         while (temp != 0) {
887             digits++;
888             temp /= 10;
889         }
890         bytes memory buffer = new bytes(digits);
891         while (value != 0) {
892             digits -= 1;
893             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
894             value /= 10;
895         }
896         return string(buffer);
897     }
898 
899     /**
900      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
901      */
902     function toHexString(uint256 value) internal pure returns (string memory) {
903         if (value == 0) {
904             return "0x00";
905         }
906         uint256 temp = value;
907         uint256 length = 0;
908         while (temp != 0) {
909             length++;
910             temp >>= 8;
911         }
912         return toHexString(value, length);
913     }
914 
915     /**
916      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
917      */
918     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
919         bytes memory buffer = new bytes(2 * length + 2);
920         buffer[0] = "0";
921         buffer[1] = "x";
922         for (uint256 i = 2 * length + 1; i > 1; --i) {
923             buffer[i] = _HEX_SYMBOLS[value & 0xf];
924             value >>= 4;
925         }
926         require(value == 0, "Strings: hex length insufficient");
927         return string(buffer);
928     }
929 
930     /**
931      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
932      */
933     function toHexString(address addr) internal pure returns (string memory) {
934         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
935     }
936 }
937 
938 
939 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.0
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
971 // Creator: Chiru Labs
972 
973 pragma solidity ^0.8.0;
974 /**
975  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
976  * the Metadata extension. Built to optimize for lower gas during batch mints.
977  *
978  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
979  *
980  * Does not support burning tokens to address(0).
981  *
982  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
983  */
984 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
985     using Address for address;
986     using Strings for uint256;
987 
988     struct TokenOwnership {
989         address addr;
990         uint64 startTimestamp;
991     }
992 
993     struct AddressData {
994         uint128 balance;
995         uint128 numberMinted;
996     }
997 
998     uint256 internal currentIndex;
999 
1000     // Token name
1001     string private _name;
1002 
1003     // Token symbol
1004     string private _symbol;
1005 
1006     // Mapping from token ID to ownership details
1007     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1008     mapping(uint256 => TokenOwnership) internal _ownerships;
1009 
1010     // Mapping owner address to address data
1011     mapping(address => AddressData) private _addressData;
1012 
1013     // Mapping from token ID to approved address
1014     mapping(uint256 => address) private _tokenApprovals;
1015 
1016     // Mapping from owner to operator approvals
1017     mapping(address => mapping(address => bool)) private _operatorApprovals;
1018 
1019     constructor(string memory name_, string memory symbol_) {
1020         _name = name_;
1021         _symbol = symbol_;
1022     }
1023 
1024     function totalSupply() public view returns (uint256) {
1025         return currentIndex;
1026     }
1027 
1028     /**
1029      * @dev See {IERC165-supportsInterface}.
1030      */
1031     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1032         return
1033         interfaceId == type(IERC721).interfaceId ||
1034         interfaceId == type(IERC721Metadata).interfaceId ||
1035         super.supportsInterface(interfaceId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-balanceOf}.
1040      */
1041     function balanceOf(address owner) public view override returns (uint256) {
1042         require(owner != address(0), 'ERC721A: balance query for the zero address');
1043         return uint256(_addressData[owner].balance);
1044     }
1045 
1046     function _numberMinted(address owner) internal view returns (uint256) {
1047         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1048         return uint256(_addressData[owner].numberMinted);
1049     }
1050 
1051     /**
1052      * Gas spent here starts off proportional to the maximum mint batch size.
1053      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1054      */
1055     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1056         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1057 
1058     unchecked {
1059         for (uint256 curr = tokenId; curr >= 0; curr--) {
1060             TokenOwnership memory ownership = _ownerships[curr];
1061             if (ownership.addr != address(0)) {
1062                 return ownership;
1063             }
1064         }
1065     }
1066 
1067         revert('ERC721A: unable to determine the owner of token');
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-ownerOf}.
1072      */
1073     function ownerOf(uint256 tokenId) public view override returns (address) {
1074         return ownershipOf(tokenId).addr;
1075     }
1076 
1077     /**
1078      * @dev See {IERC721Metadata-name}.
1079      */
1080     function name() public view virtual override returns (string memory) {
1081         return _name;
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Metadata-symbol}.
1086      */
1087     function symbol() public view virtual override returns (string memory) {
1088         return _symbol;
1089     }
1090 
1091     /**
1092      * @dev See {IERC721Metadata-tokenURI}.
1093      */
1094     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1095         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1096 
1097         string memory baseURI = _baseURI();
1098         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1099     }
1100 
1101     /**
1102      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1103      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1104      * by default, can be overriden in child contracts.
1105      */
1106     function _baseURI() internal view virtual returns (string memory) {
1107         return '';
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-approve}.
1112      */
1113     function approve(address to, uint256 tokenId) public override {
1114         address owner = ERC721A.ownerOf(tokenId);
1115         require(to != owner, 'ERC721A: approval to current owner');
1116 
1117         require(
1118             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1119             'ERC721A: approve caller is not owner nor approved for all'
1120         );
1121 
1122         _approve(to, tokenId, owner);
1123     }
1124 
1125     /**
1126      * @dev See {IERC721-getApproved}.
1127      */
1128     function getApproved(uint256 tokenId) public view override returns (address) {
1129         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1130 
1131         return _tokenApprovals[tokenId];
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-setApprovalForAll}.
1136      */
1137     function setApprovalForAll(address operator, bool approved) public override {
1138         require(operator != _msgSender(), 'ERC721A: approve to caller');
1139 
1140         _operatorApprovals[_msgSender()][operator] = approved;
1141         emit ApprovalForAll(_msgSender(), operator, approved);
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-isApprovedForAll}.
1146      */
1147     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1148         return _operatorApprovals[owner][operator];
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-transferFrom}.
1153      */
1154     function transferFrom(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) public override {
1159         _transfer(from, to, tokenId);
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-safeTransferFrom}.
1164      */
1165     function safeTransferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) public override {
1170         safeTransferFrom(from, to, tokenId, '');
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-safeTransferFrom}.
1175      */
1176     function safeTransferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId,
1180         bytes memory _data
1181     ) public override {
1182         _transfer(from, to, tokenId);
1183         require(
1184             _checkOnERC721Received(from, to, tokenId, _data),
1185             'ERC721A: transfer to non ERC721Receiver implementer'
1186         );
1187     }
1188 
1189     /**
1190      * @dev Returns whether `tokenId` exists.
1191      *
1192      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1193      *
1194      * Tokens start existing when they are minted (`_mint`),
1195      */
1196     function _exists(uint256 tokenId) internal view returns (bool) {
1197         return tokenId < currentIndex;
1198     }
1199 
1200     function _safeMint(address to, uint256 quantity) internal {
1201         _safeMint(to, quantity, '');
1202     }
1203 
1204     /**
1205      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1206      *
1207      * Requirements:
1208      *
1209      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1210      * - `quantity` must be greater than 0.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _safeMint(
1215         address to,
1216         uint256 quantity,
1217         bytes memory _data
1218     ) internal {
1219         _mint(to, quantity, _data, true);
1220     }
1221 
1222     /**
1223      * @dev Mints `quantity` tokens and transfers them to `to`.
1224      *
1225      * Requirements:
1226      *
1227      * - `to` cannot be the zero address.
1228      * - `quantity` must be greater than 0.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _mint(
1233         address to,
1234         uint256 quantity,
1235         bytes memory _data,
1236         bool safe
1237     ) internal {
1238         uint256 startTokenId = currentIndex;
1239         require(to != address(0), 'ERC721A: mint to the zero address');
1240         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1241 
1242         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1243 
1244         // Overflows are incredibly unrealistic.
1245         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1246         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1247     unchecked {
1248         _addressData[to].balance += uint128(quantity);
1249         _addressData[to].numberMinted += uint128(quantity);
1250 
1251         _ownerships[startTokenId].addr = to;
1252         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1253 
1254         uint256 updatedIndex = startTokenId;
1255 
1256         for (uint256 i; i < quantity; i++) {
1257             emit Transfer(address(0), to, updatedIndex);
1258             if (safe) {
1259                 require(
1260                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1261                     'ERC721A: transfer to non ERC721Receiver implementer'
1262                 );
1263             }
1264 
1265             updatedIndex++;
1266         }
1267 
1268         currentIndex = updatedIndex;
1269     }
1270 
1271         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1272     }
1273 
1274     /**
1275      * @dev Transfers `tokenId` from `from` to `to`.
1276      *
1277      * Requirements:
1278      *
1279      * - `to` cannot be the zero address.
1280      * - `tokenId` token must be owned by `from`.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _transfer(
1285         address from,
1286         address to,
1287         uint256 tokenId
1288     ) private {
1289         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1290 
1291         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1292         getApproved(tokenId) == _msgSender() ||
1293         isApprovedForAll(prevOwnership.addr, _msgSender()));
1294 
1295         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1296 
1297         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1298         require(to != address(0), 'ERC721A: transfer to the zero address');
1299 
1300         _beforeTokenTransfers(from, to, tokenId, 1);
1301 
1302         // Clear approvals from the previous owner
1303         _approve(address(0), tokenId, prevOwnership.addr);
1304 
1305         // Underflow of the sender's balance is impossible because we check for
1306         // ownership above and the recipient's balance can't realistically overflow.
1307         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1308     unchecked {
1309         _addressData[from].balance -= 1;
1310         _addressData[to].balance += 1;
1311 
1312         _ownerships[tokenId].addr = to;
1313         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1314 
1315         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1316         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1317         uint256 nextTokenId = tokenId + 1;
1318         if (_ownerships[nextTokenId].addr == address(0)) {
1319             if (_exists(nextTokenId)) {
1320                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1321                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1322             }
1323         }
1324     }
1325 
1326         emit Transfer(from, to, tokenId);
1327         _afterTokenTransfers(from, to, tokenId, 1);
1328     }
1329 
1330     /**
1331      * @dev Approve `to` to operate on `tokenId`
1332      *
1333      * Emits a {Approval} event.
1334      */
1335     function _approve(
1336         address to,
1337         uint256 tokenId,
1338         address owner
1339     ) private {
1340         _tokenApprovals[tokenId] = to;
1341         emit Approval(owner, to, tokenId);
1342     }
1343 
1344     /**
1345      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1346      * The call is not executed if the target address is not a contract.
1347      *
1348      * @param from address representing the previous owner of the given token ID
1349      * @param to target address that will receive the tokens
1350      * @param tokenId uint256 ID of the token to be transferred
1351      * @param _data bytes optional data to send along with the call
1352      * @return bool whether the call correctly returned the expected magic value
1353      */
1354     function _checkOnERC721Received(
1355         address from,
1356         address to,
1357         uint256 tokenId,
1358         bytes memory _data
1359     ) private returns (bool) {
1360         if (to.isContract()) {
1361             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1362                 return retval == IERC721Receiver(to).onERC721Received.selector;
1363             } catch (bytes memory reason) {
1364                 if (reason.length == 0) {
1365                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1366                 } else {
1367                     assembly {
1368                         revert(add(32, reason), mload(reason))
1369                     }
1370                 }
1371             }
1372         } else {
1373             return true;
1374         }
1375     }
1376 
1377     /**
1378      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1379      *
1380      * startTokenId - the first token id to be transferred
1381      * quantity - the amount to be transferred
1382      *
1383      * Calling conditions:
1384      *
1385      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1386      * transferred to `to`.
1387      * - When `from` is zero, `tokenId` will be minted for `to`.
1388      */
1389     function _beforeTokenTransfers(
1390         address from,
1391         address to,
1392         uint256 startTokenId,
1393         uint256 quantity
1394     ) internal virtual {}
1395 
1396     /**
1397      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1398      * minting.
1399      *
1400      * startTokenId - the first token id to be transferred
1401      * quantity - the amount to be transferred
1402      *
1403      * Calling conditions:
1404      *
1405      * - when `from` and `to` are both non-zero.
1406      * - `from` and `to` are never both zero.
1407      */
1408     function _afterTokenTransfers(
1409         address from,
1410         address to,
1411         uint256 startTokenId,
1412         uint256 quantity
1413     ) internal virtual {}
1414 }
1415 
1416 pragma solidity ^0.8.0;
1417 contract gawdH8sNFTees is Ownable, ERC721A, ReentrancyGuard {
1418     using SafeMath for uint256;
1419    
1420     bool private _isActive = false;
1421 
1422     uint256 public constant MAX_SUPPLY = 5022;
1423 
1424     uint256 public maxCountPerAccount = 2; 
1425     
1426     uint256 public price = 0 ether;
1427 
1428     string private _tokenBaseURI = "";
1429 
1430     mapping(address => uint256) public minted;
1431 
1432     modifier onlyActive() {
1433         require(_isActive && totalSupply() < MAX_SUPPLY, 'not active');
1434         _;
1435     }
1436 
1437     constructor() ERC721A("gawdH8sNFTees", "gawdH8sNFTees") {
1438     }
1439 
1440     function mint(uint256 numberOfTokens) external payable onlyActive nonReentrant() {
1441         require(numberOfTokens != 0, "zero count");
1442         require(numberOfTokens <= MAX_SUPPLY.sub(totalSupply()), "not enough nfts");
1443         require(numberOfTokens.add(minted[msg.sender]) <= maxCountPerAccount, "already max minted");
1444         
1445         minted[msg.sender] = minted[msg.sender].add(numberOfTokens);
1446 
1447         _safeMint(msg.sender, numberOfTokens);
1448     }
1449 
1450     function _baseURI() internal view override returns (string memory) {
1451         return _tokenBaseURI;
1452     }
1453 
1454     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory)
1455     {
1456         return super.tokenURI(tokenId);
1457     }
1458 
1459     
1460     /////////////////////////////////////////////////////////////
1461     //////////////////   Admin Functions ////////////////////////
1462     /////////////////////////////////////////////////////////////
1463     function startSale() external onlyOwner {
1464         _isActive = true;
1465     }
1466 
1467     function endSale() external onlyOwner {
1468         _isActive = false;
1469     }
1470 
1471     function setPrice(uint256 _price) external onlyOwner {
1472         price = _price;
1473     }
1474 
1475     function setMaxMintPerAddr(uint256 _count) external onlyOwner {
1476         maxCountPerAccount = _count;
1477     }
1478 
1479     function setTokenBaseURI(string memory URI) external onlyOwner {
1480         _tokenBaseURI = URI;
1481     }
1482 
1483     function withdraw() external onlyOwner nonReentrant {
1484         uint256 balance = address(this).balance;
1485         Address.sendValue(payable(owner()), balance);
1486     }
1487 
1488     receive() external payable {}
1489 }