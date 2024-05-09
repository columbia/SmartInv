1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-07
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-27
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 
35 
36 
37 
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 library SafeMath {
177     /**
178      * @dev Returns the addition of two unsigned integers, with an overflow flag.
179      *
180      * _Available since v3.4._
181      */
182     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         unchecked {
184             uint256 c = a + b;
185             if (c < a) return (false, 0);
186             return (true, c);
187         }
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
192      *
193      * _Available since v3.4._
194      */
195     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
196         unchecked {
197             if (b > a) return (false, 0);
198             return (true, a - b);
199         }
200     }
201 
202     /**
203      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
204      *
205      * _Available since v3.4._
206      */
207     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
208         unchecked {
209             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
210             // benefit is lost if 'b' is also tested.
211             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
212             if (a == 0) return (true, 0);
213             uint256 c = a * b;
214             if (c / a != b) return (false, 0);
215             return (true, c);
216         }
217     }
218 
219     /**
220      * @dev Returns the division of two unsigned integers, with a division by zero flag.
221      *
222      * _Available since v3.4._
223      */
224     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             if (b == 0) return (false, 0);
227             return (true, a / b);
228         }
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             if (b == 0) return (false, 0);
239             return (true, a % b);
240         }
241     }
242 
243     /**
244      * @dev Returns the addition of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `+` operator.
248      *
249      * Requirements:
250      *
251      * - Addition cannot overflow.
252      */
253     function add(uint256 a, uint256 b) internal pure returns (uint256) {
254         return a + b;
255     }
256 
257     /**
258      * @dev Returns the subtraction of two unsigned integers, reverting on
259      * overflow (when the result is negative).
260      *
261      * Counterpart to Solidity's `-` operator.
262      *
263      * Requirements:
264      *
265      * - Subtraction cannot overflow.
266      */
267     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a - b;
269     }
270 
271     /**
272      * @dev Returns the multiplication of two unsigned integers, reverting on
273      * overflow.
274      *
275      * Counterpart to Solidity's `*` operator.
276      *
277      * Requirements:
278      *
279      * - Multiplication cannot overflow.
280      */
281     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a * b;
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers, reverting on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator.
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a / b;
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
301      * reverting when dividing by zero.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a % b;
313     }
314 
315     /**
316      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
317      * overflow (when the result is negative).
318      *
319      * CAUTION: This function is deprecated because it requires allocating memory for the error
320      * message unnecessarily. For custom revert reasons use {trySub}.
321      *
322      * Counterpart to Solidity's `-` operator.
323      *
324      * Requirements:
325      *
326      * - Subtraction cannot overflow.
327      */
328     function sub(
329         uint256 a,
330         uint256 b,
331         string memory errorMessage
332     ) internal pure returns (uint256) {
333         unchecked {
334             require(b <= a, errorMessage);
335             return a - b;
336         }
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
341      * division by zero. The result is rounded towards zero.
342      *
343      * Counterpart to Solidity's `/` operator. Note: this function uses a
344      * `revert` opcode (which leaves remaining gas untouched) while Solidity
345      * uses an invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      *
349      * - The divisor cannot be zero.
350      */
351     function div(
352         uint256 a,
353         uint256 b,
354         string memory errorMessage
355     ) internal pure returns (uint256) {
356         unchecked {
357             require(b > 0, errorMessage);
358             return a / b;
359         }
360     }
361 
362     /**
363      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
364      * reverting with custom message when dividing by zero.
365      *
366      * CAUTION: This function is deprecated because it requires allocating memory for the error
367      * message unnecessarily. For custom revert reasons use {tryMod}.
368      *
369      * Counterpart to Solidity's `%` operator. This function uses a `revert`
370      * opcode (which leaves remaining gas untouched) while Solidity uses an
371      * invalid opcode to revert (consuming all remaining gas).
372      *
373      * Requirements:
374      *
375      * - The divisor cannot be zero.
376      */
377     function mod(
378         uint256 a,
379         uint256 b,
380         string memory errorMessage
381     ) internal pure returns (uint256) {
382         unchecked {
383             require(b > 0, errorMessage);
384             return a % b;
385         }
386     }
387 }
388 
389 
390 /**
391  * @dev String operations.
392  */
393 library Strings {
394     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
395 
396     /**
397      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
398      */
399     function toString(uint256 value) internal pure returns (string memory) {
400         // Inspired by OraclizeAPI's implementation - MIT licence
401         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
402 
403         if (value == 0) {
404             return "0";
405         }
406         uint256 temp = value;
407         uint256 digits;
408         while (temp != 0) {
409             digits++;
410             temp /= 10;
411         }
412         bytes memory buffer = new bytes(digits);
413         while (value != 0) {
414             digits -= 1;
415             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
416             value /= 10;
417         }
418         return string(buffer);
419     }
420 
421     /**
422      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
423      */
424     function toHexString(uint256 value) internal pure returns (string memory) {
425         if (value == 0) {
426             return "0x00";
427         }
428         uint256 temp = value;
429         uint256 length = 0;
430         while (temp != 0) {
431             length++;
432             temp >>= 8;
433         }
434         return toHexString(value, length);
435     }
436 
437     /**
438      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
439      */
440     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
441         bytes memory buffer = new bytes(2 * length + 2);
442         buffer[0] = "0";
443         buffer[1] = "x";
444         for (uint256 i = 2 * length + 1; i > 1; --i) {
445             buffer[i] = _HEX_SYMBOLS[value & 0xf];
446             value >>= 4;
447         }
448         require(value == 0, "Strings: hex length insufficient");
449         return string(buffer);
450     }
451 }
452 
453 
454 
455 
456 /*
457  * @dev Provides information about the current execution context, including the
458  * sender of the transaction and its data. While these are generally available
459  * via msg.sender and msg.data, they should not be accessed in such a direct
460  * manner, since when dealing with meta-transactions the account sending and
461  * paying for execution may not be the actual sender (as far as an application
462  * is concerned).
463  *
464  * This contract is only required for intermediate, library-like contracts.
465  */
466 abstract contract Context {
467     function _msgSender() internal view virtual returns (address) {
468         return msg.sender;
469     }
470 
471     function _msgData() internal view virtual returns (bytes calldata) {
472         return msg.data;
473     }
474 }
475 
476 
477 
478 
479 
480 
481 
482 
483 
484 /**
485  * @dev Contract module which provides a basic access control mechanism, where
486  * there is an account (an owner) that can be granted exclusive access to
487  * specific functions.
488  *
489  * By default, the owner account will be the one that deploys the contract. This
490  * can later be changed with {transferOwnership}.
491  *
492  * This module is used through inheritance. It will make available the modifier
493  * `onlyOwner`, which can be applied to your functions to restrict their use to
494  * the owner.
495  */
496 abstract contract Ownable is Context {
497     address private _owner;
498 
499     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
500 
501     /**
502      * @dev Initializes the contract setting the deployer as the initial owner.
503      */
504     constructor() {
505         _setOwner(_msgSender());
506     }
507 
508     /**
509      * @dev Returns the address of the current owner.
510      */
511     function owner() public view virtual returns (address) {
512         return _owner;
513     }
514 
515     /**
516      * @dev Throws if called by any account other than the owner.
517      */
518     modifier onlyOwner() {
519         require(owner() == _msgSender(), "Ownable: caller is not the owner");
520         _;
521     }
522 
523     /**
524      * @dev Leaves the contract without owner. It will not be possible to call
525      * `onlyOwner` functions anymore. Can only be called by the current owner.
526      *
527      * NOTE: Renouncing ownership will leave the contract without an owner,
528      * thereby removing any functionality that is only available to the owner.
529      */
530     function renounceOwnership() public virtual onlyOwner {
531         _setOwner(address(0));
532     }
533 
534     /**
535      * @dev Transfers ownership of the contract to a new account (`newOwner`).
536      * Can only be called by the current owner.
537      */
538     function transferOwnership(address newOwner) public virtual onlyOwner {
539         require(newOwner != address(0), "Ownable: new owner is the zero address");
540         _setOwner(newOwner);
541     }
542 
543     function _setOwner(address newOwner) private {
544         address oldOwner = _owner;
545         _owner = newOwner;
546         emit OwnershipTransferred(oldOwner, newOwner);
547     }
548 }
549 
550 
551 
552 
553 
554 /**
555  * @dev Contract module that helps prevent reentrant calls to a function.
556  *
557  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
558  * available, which can be applied to functions to make sure there are no nested
559  * (reentrant) calls to them.
560  *
561  * Note that because there is a single `nonReentrant` guard, functions marked as
562  * `nonReentrant` may not call one another. This can be worked around by making
563  * those functions `private`, and then adding `external` `nonReentrant` entry
564  * points to them.
565  *
566  * TIP: If you would like to learn more about reentrancy and alternative ways
567  * to protect against it, check out our blog post
568  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
569  */
570 abstract contract ReentrancyGuard {
571     // Booleans are more expensive than uint256 or any type that takes up a full
572     // word because each write operation emits an extra SLOAD to first read the
573     // slot's contents, replace the bits taken up by the boolean, and then write
574     // back. This is the compiler's defense against contract upgrades and
575     // pointer aliasing, and it cannot be disabled.
576 
577     // The values being non-zero value makes deployment a bit more expensive,
578     // but in exchange the refund on every call to nonReentrant will be lower in
579     // amount. Since refunds are capped to a percentage of the total
580     // transaction's gas, it is best to keep them low in cases like this one, to
581     // increase the likelihood of the full refund coming into effect.
582     uint256 private constant _NOT_ENTERED = 1;
583     uint256 private constant _ENTERED = 2;
584 
585     uint256 private _status;
586 
587     constructor() {
588         _status = _NOT_ENTERED;
589     }
590 
591     /**
592      * @dev Prevents a contract from calling itself, directly or indirectly.
593      * Calling a `nonReentrant` function from another `nonReentrant`
594      * function is not supported. It is possible to prevent this from happening
595      * by making the `nonReentrant` function external, and make it call a
596      * `private` function that does the actual work.
597      */
598     modifier nonReentrant() {
599         // On the first call to nonReentrant, _notEntered will be true
600         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
601 
602         // Any calls to nonReentrant after this point will fail
603         _status = _ENTERED;
604 
605         _;
606 
607         // By storing the original value once again, a refund is triggered (see
608         // https://eips.ethereum.org/EIPS/eip-2200)
609         _status = _NOT_ENTERED;
610     }
611 }
612 
613 
614 
615 
616 
617 
618 
619 
620 
621 
622 
623 
624 
625 
626 /**
627  * @title ERC721 token receiver interface
628  * @dev Interface for any contract that wants to support safeTransfers
629  * from ERC721 asset contracts.
630  */
631 interface IERC721Receiver {
632     /**
633      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
634      * by `operator` from `from`, this function is called.
635      *
636      * It must return its Solidity selector to confirm the token transfer.
637      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
638      *
639      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
640      */
641     function onERC721Received(
642         address operator,
643         address from,
644         uint256 tokenId,
645         bytes calldata data
646     ) external returns (bytes4);
647 }
648 
649 
650 
651 
652 
653 
654 
655 /**
656  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
657  * @dev See https://eips.ethereum.org/EIPS/eip-721
658  */
659 interface IERC721Metadata is IERC721 {
660     /**
661      * @dev Returns the token collection name.
662      */
663     function name() external view returns (string memory);
664 
665     /**
666      * @dev Returns the token collection symbol.
667      */
668     function symbol() external view returns (string memory);
669 
670     /**
671      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
672      */
673     function tokenURI(uint256 tokenId) external view returns (string memory);
674 }
675 
676 
677 
678 
679 
680 /**
681  * @dev Collection of functions related to the address type
682  */
683 library Address {
684     /**
685      * @dev Returns true if `account` is a contract.
686      *
687      * [IMPORTANT]
688      * ====
689      * It is unsafe to assume that an address for which this function returns
690      * false is an externally-owned account (EOA) and not a contract.
691      *
692      * Among others, `isContract` will return false for the following
693      * types of addresses:
694      *
695      *  - an externally-owned account
696      *  - a contract in construction
697      *  - an address where a contract will be created
698      *  - an address where a contract lived, but was destroyed
699      * ====
700      */
701     function isContract(address account) internal view returns (bool) {
702         // This method relies on extcodesize, which returns 0 for contracts in
703         // construction, since the code is only stored at the end of the
704         // constructor execution.
705 
706         uint256 size;
707         assembly {
708             size := extcodesize(account)
709         }
710         return size > 0;
711     }
712 
713     /**
714      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
715      * `recipient`, forwarding all available gas and reverting on errors.
716      *
717      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
718      * of certain opcodes, possibly making contracts go over the 2300 gas limit
719      * imposed by `transfer`, making them unable to receive funds via
720      * `transfer`. {sendValue} removes this limitation.
721      *
722      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
723      *
724      * IMPORTANT: because control is transferred to `recipient`, care must be
725      * taken to not create reentrancy vulnerabilities. Consider using
726      * {ReentrancyGuard} or the
727      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
728      */
729     function sendValue(address payable recipient, uint256 amount) internal {
730         require(address(this).balance >= amount, "Address: insufficient balance");
731 
732         (bool success, ) = recipient.call{value: amount}("");
733         require(success, "Address: unable to send value, recipient may have reverted");
734     }
735 
736     /**
737      * @dev Performs a Solidity function call using a low level `call`. A
738      * plain `call` is an unsafe replacement for a function call: use this
739      * function instead.
740      *
741      * If `target` reverts with a revert reason, it is bubbled up by this
742      * function (like regular Solidity function calls).
743      *
744      * Returns the raw returned data. To convert to the expected return value,
745      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
746      *
747      * Requirements:
748      *
749      * - `target` must be a contract.
750      * - calling `target` with `data` must not revert.
751      *
752      * _Available since v3.1._
753      */
754     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
755         return functionCall(target, data, "Address: low-level call failed");
756     }
757 
758     /**
759      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
760      * `errorMessage` as a fallback revert reason when `target` reverts.
761      *
762      * _Available since v3.1._
763      */
764     function functionCall(
765         address target,
766         bytes memory data,
767         string memory errorMessage
768     ) internal returns (bytes memory) {
769         return functionCallWithValue(target, data, 0, errorMessage);
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
774      * but also transferring `value` wei to `target`.
775      *
776      * Requirements:
777      *
778      * - the calling contract must have an ETH balance of at least `value`.
779      * - the called Solidity function must be `payable`.
780      *
781      * _Available since v3.1._
782      */
783     function functionCallWithValue(
784         address target,
785         bytes memory data,
786         uint256 value
787     ) internal returns (bytes memory) {
788         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
793      * with `errorMessage` as a fallback revert reason when `target` reverts.
794      *
795      * _Available since v3.1._
796      */
797     function functionCallWithValue(
798         address target,
799         bytes memory data,
800         uint256 value,
801         string memory errorMessage
802     ) internal returns (bytes memory) {
803         require(address(this).balance >= value, "Address: insufficient balance for call");
804         require(isContract(target), "Address: call to non-contract");
805 
806         (bool success, bytes memory returndata) = target.call{value: value}(data);
807         return _verifyCallResult(success, returndata, errorMessage);
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
812      * but performing a static call.
813      *
814      * _Available since v3.3._
815      */
816     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
817         return functionStaticCall(target, data, "Address: low-level static call failed");
818     }
819 
820     /**
821      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
822      * but performing a static call.
823      *
824      * _Available since v3.3._
825      */
826     function functionStaticCall(
827         address target,
828         bytes memory data,
829         string memory errorMessage
830     ) internal view returns (bytes memory) {
831         require(isContract(target), "Address: static call to non-contract");
832 
833         (bool success, bytes memory returndata) = target.staticcall(data);
834         return _verifyCallResult(success, returndata, errorMessage);
835     }
836 
837     /**
838      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
839      * but performing a delegate call.
840      *
841      * _Available since v3.4._
842      */
843     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
844         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
845     }
846 
847     /**
848      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
849      * but performing a delegate call.
850      *
851      * _Available since v3.4._
852      */
853     function functionDelegateCall(
854         address target,
855         bytes memory data,
856         string memory errorMessage
857     ) internal returns (bytes memory) {
858         require(isContract(target), "Address: delegate call to non-contract");
859 
860         (bool success, bytes memory returndata) = target.delegatecall(data);
861         return _verifyCallResult(success, returndata, errorMessage);
862     }
863 
864     function _verifyCallResult(
865         bool success,
866         bytes memory returndata,
867         string memory errorMessage
868     ) private pure returns (bytes memory) {
869         if (success) {
870             return returndata;
871         } else {
872             // Look for revert reason and bubble it up if present
873             if (returndata.length > 0) {
874                 // The easiest way to bubble the revert reason is using memory via assembly
875 
876                 assembly {
877                     let returndata_size := mload(returndata)
878                     revert(add(32, returndata), returndata_size)
879                 }
880             } else {
881                 revert(errorMessage);
882             }
883         }
884     }
885 }
886 
887 
888 
889 
890 
891 
892 
893 
894 
895 /**
896  * @dev Implementation of the {IERC165} interface.
897  *
898  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
899  * for the additional interface id that will be supported. For example:
900  *
901  * ```solidity
902  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
903  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
904  * }
905  * ```
906  *
907  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
908  */
909 abstract contract ERC165 is IERC165 {
910     /**
911      * @dev See {IERC165-supportsInterface}.
912      */
913     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
914         return interfaceId == type(IERC165).interfaceId;
915     }
916 }
917 
918 
919 /**
920  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
921  * the Metadata extension, but not including the Enumerable extension, which is available separately as
922  * {ERC721Enumerable}.
923  */
924 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
925     using Address for address;
926     using Strings for uint256;
927 
928     // Token name
929     string private _name;
930 
931     // Token symbol
932     string private _symbol;
933 
934     // Mapping from token ID to owner address
935     mapping(uint256 => address) private _owners;
936 
937     // Mapping owner address to token count
938     mapping(address => uint256) private _balances;
939 
940     // Mapping from token ID to approved address
941     mapping(uint256 => address) private _tokenApprovals;
942 
943     // Mapping from owner to operator approvals
944     mapping(address => mapping(address => bool)) private _operatorApprovals;
945 
946     /**
947      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
948      */
949     constructor(string memory name_, string memory symbol_) {
950         _name = name_;
951         _symbol = symbol_;
952     }
953 
954     /**
955      * @dev See {IERC165-supportsInterface}.
956      */
957     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
958         return
959             interfaceId == type(IERC721).interfaceId ||
960             interfaceId == type(IERC721Metadata).interfaceId ||
961             super.supportsInterface(interfaceId);
962     }
963 
964     /**
965      * @dev See {IERC721-balanceOf}.
966      */
967     function balanceOf(address owner) public view virtual override returns (uint256) {
968         require(owner != address(0), "ERC721: balance query for the zero address");
969         return _balances[owner];
970     }
971 
972     /**
973      * @dev See {IERC721-ownerOf}.
974      */
975     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
976         address owner = _owners[tokenId];
977         require(owner != address(0), "ERC721: owner query for nonexistent token");
978         return owner;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-name}.
983      */
984     function name() public view virtual override returns (string memory) {
985         return _name;
986     }
987 
988     /**
989      * @dev See {IERC721Metadata-symbol}.
990      */
991     function symbol() public view virtual override returns (string memory) {
992         return _symbol;
993     }
994 
995     /**
996      * @dev See {IERC721Metadata-tokenURI}.
997      */
998     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
999         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1000 
1001         string memory baseURI = _baseURI();
1002         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1003     }
1004 
1005     /**
1006      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1007      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1008      * by default, can be overriden in child contracts.
1009      */
1010     function _baseURI() internal view virtual returns (string memory) {
1011         return "";
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-approve}.
1016      */
1017     function approve(address to, uint256 tokenId) public virtual override {
1018         address owner = ERC721.ownerOf(tokenId);
1019         require(to != owner, "ERC721: approval to current owner");
1020 
1021         require(
1022             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1023             "ERC721: approve caller is not owner nor approved for all"
1024         );
1025 
1026         _approve(to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-getApproved}.
1031      */
1032     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1033         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1034 
1035         return _tokenApprovals[tokenId];
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-setApprovalForAll}.
1040      */
1041     function setApprovalForAll(address operator, bool approved) public virtual override {
1042         require(operator != _msgSender(), "ERC721: approve to caller");
1043 
1044         _operatorApprovals[_msgSender()][operator] = approved;
1045         emit ApprovalForAll(_msgSender(), operator, approved);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-isApprovedForAll}.
1050      */
1051     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1052         return _operatorApprovals[owner][operator];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-transferFrom}.
1057      */
1058     function transferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) public virtual override {
1063         //solhint-disable-next-line max-line-length
1064         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1065 
1066         _transfer(from, to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-safeTransferFrom}.
1071      */
1072     function safeTransferFrom(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) public virtual override {
1077         safeTransferFrom(from, to, tokenId, "");
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-safeTransferFrom}.
1082      */
1083     function safeTransferFrom(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) public virtual override {
1089         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1090         _safeTransfer(from, to, tokenId, _data);
1091     }
1092 
1093     /**
1094      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1095      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1096      *
1097      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1098      *
1099      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1100      * implement alternative mechanisms to perform token transfer, such as signature-based.
1101      *
1102      * Requirements:
1103      *
1104      * - `from` cannot be the zero address.
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must exist and be owned by `from`.
1107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _safeTransfer(
1112         address from,
1113         address to,
1114         uint256 tokenId,
1115         bytes memory _data
1116     ) internal virtual {
1117         _transfer(from, to, tokenId);
1118         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1119     }
1120 
1121     /**
1122      * @dev Returns whether `tokenId` exists.
1123      *
1124      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1125      *
1126      * Tokens start existing when they are minted (`_mint`),
1127      * and stop existing when they are burned (`_burn`).
1128      */
1129     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1130         return _owners[tokenId] != address(0);
1131     }
1132 
1133     /**
1134      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must exist.
1139      */
1140     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1141         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1142         address owner = ERC721.ownerOf(tokenId);
1143         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1144     }
1145 
1146     /**
1147      * @dev Safely mints `tokenId` and transfers it to `to`.
1148      *
1149      * Requirements:
1150      *
1151      * - `tokenId` must not exist.
1152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function _safeMint(address to, uint256 tokenId) internal virtual {
1157         _safeMint(to, tokenId, "");
1158     }
1159 
1160     /**
1161      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1162      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1163      */
1164     function _safeMint(
1165         address to,
1166         uint256 tokenId,
1167         bytes memory _data
1168     ) internal virtual {
1169         _mint(to, tokenId);
1170         require(
1171             _checkOnERC721Received(address(0), to, tokenId, _data),
1172             "ERC721: transfer to non ERC721Receiver implementer"
1173         );
1174     }
1175 
1176     /**
1177      * @dev Mints `tokenId` and transfers it to `to`.
1178      *
1179      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1180      *
1181      * Requirements:
1182      *
1183      * - `tokenId` must not exist.
1184      * - `to` cannot be the zero address.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _mint(address to, uint256 tokenId) internal virtual {
1189         require(to != address(0), "ERC721: mint to the zero address");
1190         require(!_exists(tokenId), "ERC721: token already minted");
1191 
1192         _beforeTokenTransfer(address(0), to, tokenId);
1193 
1194         _balances[to] += 1;
1195         _owners[tokenId] = to;
1196 
1197         emit Transfer(address(0), to, tokenId);
1198     }
1199 
1200     /**
1201      * @dev Destroys `tokenId`.
1202      * The approval is cleared when the token is burned.
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must exist.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _burn(uint256 tokenId) internal virtual {
1211         address owner = ERC721.ownerOf(tokenId);
1212 
1213         _beforeTokenTransfer(owner, address(0), tokenId);
1214 
1215         // Clear approvals
1216         _approve(address(0), tokenId);
1217 
1218         _balances[owner] -= 1;
1219         delete _owners[tokenId];
1220 
1221         emit Transfer(owner, address(0), tokenId);
1222     }
1223 
1224     /**
1225      * @dev Transfers `tokenId` from `from` to `to`.
1226      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1227      *
1228      * Requirements:
1229      *
1230      * - `to` cannot be the zero address.
1231      * - `tokenId` token must be owned by `from`.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _transfer(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) internal virtual {
1240         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1241         require(to != address(0), "ERC721: transfer to the zero address");
1242 
1243         _beforeTokenTransfer(from, to, tokenId);
1244 
1245         // Clear approvals from the previous owner
1246         _approve(address(0), tokenId);
1247 
1248         _balances[from] -= 1;
1249         _balances[to] += 1;
1250         _owners[tokenId] = to;
1251 
1252         emit Transfer(from, to, tokenId);
1253     }
1254 
1255     /**
1256      * @dev Approve `to` to operate on `tokenId`
1257      *
1258      * Emits a {Approval} event.
1259      */
1260     function _approve(address to, uint256 tokenId) internal virtual {
1261         _tokenApprovals[tokenId] = to;
1262         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1267      * The call is not executed if the target address is not a contract.
1268      *
1269      * @param from address representing the previous owner of the given token ID
1270      * @param to target address that will receive the tokens
1271      * @param tokenId uint256 ID of the token to be transferred
1272      * @param _data bytes optional data to send along with the call
1273      * @return bool whether the call correctly returned the expected magic value
1274      */
1275     function _checkOnERC721Received(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory _data
1280     ) private returns (bool) {
1281         if (to.isContract()) {
1282             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1283                 return retval == IERC721Receiver(to).onERC721Received.selector;
1284             } catch (bytes memory reason) {
1285                 if (reason.length == 0) {
1286                     revert("ERC721: transfer to non ERC721Receiver implementer");
1287                 } else {
1288                     assembly {
1289                         revert(add(32, reason), mload(reason))
1290                     }
1291                 }
1292             }
1293         } else {
1294             return true;
1295         }
1296     }
1297 
1298     /**
1299      * @dev Hook that is called before any token transfer. This includes minting
1300      * and burning.
1301      *
1302      * Calling conditions:
1303      *
1304      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1305      * transferred to `to`.
1306      * - When `from` is zero, `tokenId` will be minted for `to`.
1307      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1308      * - `from` and `to` are never both zero.
1309      *
1310      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1311      */
1312     function _beforeTokenTransfer(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) internal virtual {}
1317 }
1318 
1319 
1320 
1321 
1322 
1323 
1324 
1325 /**
1326  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1327  * @dev See https://eips.ethereum.org/EIPS/eip-721
1328  */
1329 interface IERC721Enumerable is IERC721 {
1330     /**
1331      * @dev Returns the total amount of tokens stored by the contract.
1332      */
1333     function totalSupply() external view returns (uint256);
1334 
1335     /**
1336      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1337      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1338      */
1339     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1340 
1341     /**
1342      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1343      * Use along with {totalSupply} to enumerate all tokens.
1344      */
1345     function tokenByIndex(uint256 index) external view returns (uint256);
1346 }
1347 
1348 
1349 /**
1350  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1351  * enumerability of all the token ids in the contract as well as all token ids owned by each
1352  * account.
1353  */
1354 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1355     // Mapping from owner to list of owned token IDs
1356     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1357 
1358     // Mapping from token ID to index of the owner tokens list
1359     mapping(uint256 => uint256) private _ownedTokensIndex;
1360 
1361     // Array with all token ids, used for enumeration
1362     uint256[] private _allTokens;
1363 
1364     // Mapping from token id to position in the allTokens array
1365     mapping(uint256 => uint256) private _allTokensIndex;
1366 
1367     /**
1368      * @dev See {IERC165-supportsInterface}.
1369      */
1370     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1371         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1372     }
1373 
1374     /**
1375      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1376      */
1377     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1378         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1379         return _ownedTokens[owner][index];
1380     }
1381 
1382     /**
1383      * @dev See {IERC721Enumerable-totalSupply}.
1384      */
1385     function totalSupply() public view virtual override returns (uint256) {
1386         return _allTokens.length;
1387     }
1388 
1389     /**
1390      * @dev See {IERC721Enumerable-tokenByIndex}.
1391      */
1392     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1393         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1394         return _allTokens[index];
1395     }
1396 
1397     /**
1398      * @dev Hook that is called before any token transfer. This includes minting
1399      * and burning.
1400      *
1401      * Calling conditions:
1402      *
1403      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1404      * transferred to `to`.
1405      * - When `from` is zero, `tokenId` will be minted for `to`.
1406      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1407      * - `from` cannot be the zero address.
1408      * - `to` cannot be the zero address.
1409      *
1410      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1411      */
1412     function _beforeTokenTransfer(
1413         address from,
1414         address to,
1415         uint256 tokenId
1416     ) internal virtual override {
1417         super._beforeTokenTransfer(from, to, tokenId);
1418 
1419         if (from == address(0)) {
1420             _addTokenToAllTokensEnumeration(tokenId);
1421         } else if (from != to) {
1422             _removeTokenFromOwnerEnumeration(from, tokenId);
1423         }
1424         if (to == address(0)) {
1425             _removeTokenFromAllTokensEnumeration(tokenId);
1426         } else if (to != from) {
1427             _addTokenToOwnerEnumeration(to, tokenId);
1428         }
1429     }
1430 
1431     /**
1432      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1433      * @param to address representing the new owner of the given token ID
1434      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1435      */
1436     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1437         uint256 length = ERC721.balanceOf(to);
1438         _ownedTokens[to][length] = tokenId;
1439         _ownedTokensIndex[tokenId] = length;
1440     }
1441 
1442     /**
1443      * @dev Private function to add a token to this extension's token tracking data structures.
1444      * @param tokenId uint256 ID of the token to be added to the tokens list
1445      */
1446     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1447         _allTokensIndex[tokenId] = _allTokens.length;
1448         _allTokens.push(tokenId);
1449     }
1450 
1451     /**
1452      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1453      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1454      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1455      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1456      * @param from address representing the previous owner of the given token ID
1457      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1458      */
1459     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1460         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1461         // then delete the last slot (swap and pop).
1462 
1463         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1464         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1465 
1466         // When the token to delete is the last token, the swap operation is unnecessary
1467         if (tokenIndex != lastTokenIndex) {
1468             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1469 
1470             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1471             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1472         }
1473 
1474         // This also deletes the contents at the last position of the array
1475         delete _ownedTokensIndex[tokenId];
1476         delete _ownedTokens[from][lastTokenIndex];
1477     }
1478 
1479     /**
1480      * @dev Private function to remove a token from this extension's token tracking data structures.
1481      * This has O(1) time complexity, but alters the order of the _allTokens array.
1482      * @param tokenId uint256 ID of the token to be removed from the tokens list
1483      */
1484     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1485         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1486         // then delete the last slot (swap and pop).
1487 
1488         uint256 lastTokenIndex = _allTokens.length - 1;
1489         uint256 tokenIndex = _allTokensIndex[tokenId];
1490 
1491         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1492         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1493         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1494         uint256 lastTokenId = _allTokens[lastTokenIndex];
1495 
1496         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1497         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1498 
1499         // This also deletes the contents at the last position of the array
1500         delete _allTokensIndex[tokenId];
1501         _allTokens.pop();
1502     }
1503 }
1504 
1505 
1506 /**
1507  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1508  *
1509  * These functions can be used to verify that a message was signed by the holder
1510  * of the private keys of a given address.
1511  */
1512 library ECDSA {
1513     enum RecoverError {
1514         NoError,
1515         InvalidSignature,
1516         InvalidSignatureLength,
1517         InvalidSignatureS,
1518         InvalidSignatureV
1519     }
1520 
1521     function _throwError(RecoverError error) private pure {
1522         if (error == RecoverError.NoError) {
1523             return; // no error: do nothing
1524         } else if (error == RecoverError.InvalidSignature) {
1525             revert("ECDSA: invalid signature");
1526         } else if (error == RecoverError.InvalidSignatureLength) {
1527             revert("ECDSA: invalid signature length");
1528         } else if (error == RecoverError.InvalidSignatureS) {
1529             revert("ECDSA: invalid signature 's' value");
1530         } else if (error == RecoverError.InvalidSignatureV) {
1531             revert("ECDSA: invalid signature 'v' value");
1532         }
1533     }
1534 
1535     /**
1536      * @dev Returns the address that signed a hashed message (`hash`) with
1537      * `signature` or error string. This address can then be used for verification purposes.
1538      *
1539      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1540      * this function rejects them by requiring the `s` value to be in the lower
1541      * half order, and the `v` value to be either 27 or 28.
1542      *
1543      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1544      * verification to be secure: it is possible to craft signatures that
1545      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1546      * this is by receiving a hash of the original message (which may otherwise
1547      * be too long), and then calling {toEthSignedMessageHash} on it.
1548      *
1549      * Documentation for signature generation:
1550      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1551      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1552      *
1553      * _Available since v4.3._
1554      */
1555     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1556         if (signature.length == 65) {
1557             bytes32 r;
1558             bytes32 s;
1559             uint8 v;
1560             // ecrecover takes the signature parameters, and the only way to get them
1561             // currently is to use assembly.
1562             /// @solidity memory-safe-assembly
1563             assembly {
1564                 r := mload(add(signature, 0x20))
1565                 s := mload(add(signature, 0x40))
1566                 v := byte(0, mload(add(signature, 0x60)))
1567             }
1568             return tryRecover(hash, v, r, s);
1569         } else {
1570             return (address(0), RecoverError.InvalidSignatureLength);
1571         }
1572     }
1573 
1574     /**
1575      * @dev Returns the address that signed a hashed message (`hash`) with
1576      * `signature`. This address can then be used for verification purposes.
1577      *
1578      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1579      * this function rejects them by requiring the `s` value to be in the lower
1580      * half order, and the `v` value to be either 27 or 28.
1581      *
1582      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1583      * verification to be secure: it is possible to craft signatures that
1584      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1585      * this is by receiving a hash of the original message (which may otherwise
1586      * be too long), and then calling {toEthSignedMessageHash} on it.
1587      */
1588     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1589         (address recovered, RecoverError error) = tryRecover(hash, signature);
1590         _throwError(error);
1591         return recovered;
1592     }
1593 
1594     /**
1595      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1596      *
1597      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1598      *
1599      * _Available since v4.3._
1600      */
1601     function tryRecover(
1602         bytes32 hash,
1603         bytes32 r,
1604         bytes32 vs
1605     ) internal pure returns (address, RecoverError) {
1606         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1607         uint8 v = uint8((uint256(vs) >> 255) + 27);
1608         return tryRecover(hash, v, r, s);
1609     }
1610 
1611     /**
1612      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1613      *
1614      * _Available since v4.2._
1615      */
1616     function recover(
1617         bytes32 hash,
1618         bytes32 r,
1619         bytes32 vs
1620     ) internal pure returns (address) {
1621         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1622         _throwError(error);
1623         return recovered;
1624     }
1625 
1626     /**
1627      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1628      * `r` and `s` signature fields separately.
1629      *
1630      * _Available since v4.3._
1631      */
1632     function tryRecover(
1633         bytes32 hash,
1634         uint8 v,
1635         bytes32 r,
1636         bytes32 s
1637     ) internal pure returns (address, RecoverError) {
1638         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1639         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1640         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1641         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1642         //
1643         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1644         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1645         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1646         // these malleable signatures as well.
1647         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1648             return (address(0), RecoverError.InvalidSignatureS);
1649         }
1650         if (v != 27 && v != 28) {
1651             return (address(0), RecoverError.InvalidSignatureV);
1652         }
1653 
1654         // If the signature is valid (and not malleable), return the signer address
1655         address signer = ecrecover(hash, v, r, s);
1656         if (signer == address(0)) {
1657             return (address(0), RecoverError.InvalidSignature);
1658         }
1659 
1660         return (signer, RecoverError.NoError);
1661     }
1662 
1663     /**
1664      * @dev Overload of {ECDSA-recover} that receives the `v`,
1665      * `r` and `s` signature fields separately.
1666      */
1667     function recover(
1668         bytes32 hash,
1669         uint8 v,
1670         bytes32 r,
1671         bytes32 s
1672     ) internal pure returns (address) {
1673         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1674         _throwError(error);
1675         return recovered;
1676     }
1677 
1678     /**
1679      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1680      * produces hash corresponding to the one signed with the
1681      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1682      * JSON-RPC method as part of EIP-191.
1683      *
1684      * See {recover}.
1685      */
1686     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1687         // 32 is the length in bytes of hash,
1688         // enforced by the type signature above
1689         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1690     }
1691 
1692     /**
1693      * @dev Returns an Ethereum Signed Message, created from `s`. This
1694      * produces hash corresponding to the one signed with the
1695      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1696      * JSON-RPC method as part of EIP-191.
1697      *
1698      * See {recover}.
1699      */
1700     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1701         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1702     }
1703 
1704     /**
1705      * @dev Returns an Ethereum Signed Typed Data, created from a
1706      * `domainSeparator` and a `structHash`. This produces hash corresponding
1707      * to the one signed with the
1708      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1709      * JSON-RPC method as part of EIP-712.
1710      *
1711      * See {recover}.
1712      */
1713     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1714         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1715     }
1716 }
1717 
1718 /**
1719  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1720  *
1721  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1722  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1723  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1724  *
1725  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1726  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1727  * ({_hashTypedDataV4}).
1728  *
1729  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1730  * the chain id to protect against replay attacks on an eventual fork of the chain.
1731  *
1732  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1733  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1734  *
1735  * _Available since v3.4._
1736  */
1737 abstract contract EIP712 {
1738     /* solhint-disable var-name-mixedcase */
1739     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1740     // invalidate the cached domain separator if the chain id changes.
1741     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1742     uint256 private immutable _CACHED_CHAIN_ID;
1743     address private immutable _CACHED_THIS;
1744 
1745     bytes32 private immutable _HASHED_NAME;
1746     bytes32 private immutable _HASHED_VERSION;
1747     bytes32 private immutable _TYPE_HASH;
1748 
1749     /* solhint-enable var-name-mixedcase */
1750 
1751     /**
1752      * @dev Initializes the domain separator and parameter caches.
1753      *
1754      * The meaning of `name` and `version` is specified in
1755      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1756      *
1757      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1758      * - `version`: the current major version of the signing domain.
1759      *
1760      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1761      * contract upgrade].
1762      */
1763     constructor(string memory name, string memory version) {
1764         bytes32 hashedName = keccak256(bytes(name));
1765         bytes32 hashedVersion = keccak256(bytes(version));
1766         bytes32 typeHash = keccak256(
1767             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1768         );
1769         _HASHED_NAME = hashedName;
1770         _HASHED_VERSION = hashedVersion;
1771         _CACHED_CHAIN_ID = block.chainid;
1772         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1773         _CACHED_THIS = address(this);
1774         _TYPE_HASH = typeHash;
1775     }
1776 
1777     /**
1778      * @dev Returns the domain separator for the current chain.
1779      */
1780     function _domainSeparatorV4() internal view returns (bytes32) {
1781         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1782             return _CACHED_DOMAIN_SEPARATOR;
1783         } else {
1784             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1785         }
1786     }
1787 
1788     function _buildDomainSeparator(
1789         bytes32 typeHash,
1790         bytes32 nameHash,
1791         bytes32 versionHash
1792     ) private view returns (bytes32) {
1793         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1794     }
1795 
1796     /**
1797      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1798      * function returns the hash of the fully encoded EIP712 message for this domain.
1799      *
1800      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1801      *
1802      * ```solidity
1803      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1804      *     keccak256("Mail(address to,string contents)"),
1805      *     mailTo,
1806      *     keccak256(bytes(mailContents))
1807      * )));
1808      * address signer = ECDSA.recover(digest, signature);
1809      * ```
1810      */
1811     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1812         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1813     }
1814 }
1815 
1816 
1817 contract ZRXNft is ERC721Enumerable, EIP712 , ReentrancyGuard, Ownable {
1818     using SafeMath for uint256;
1819     using Strings for uint256;
1820 
1821     uint256 public mintPrice = 4800000 gwei;
1822     bool public isPreSale;
1823     bool public isPublicSale;
1824     uint256 curTokenID = 1;
1825     uint256 maxTokenID = 2048;
1826 
1827     string ipfsAddr1 = "";
1828     string ipfsAddr2 = "";
1829     address payable public vaultAddress1;
1830     address payable public vaultAddress2;
1831     bool isBlindBox = true;
1832 
1833     struct AccountParam {
1834         bool inWhiteList;
1835         uint256 claimCnt;
1836         uint256[] tokenList;
1837     }
1838     mapping(address => AccountParam) mapAccount;
1839 	
1840 
1841     // mint signer
1842     struct MintVoucher {
1843         address signer;
1844         address minter;
1845         uint256 expiration;
1846         bytes signature;
1847     }
1848     bytes32 internal constant MINTVOUCHER_HASH = keccak256("MintVoucher(address signer,address minter,uint256 expiration)");
1849     address[] public signers;
1850 
1851 
1852     constructor() ERC721("zero to infinity", "ZR_X") EIP712("ZR_X", "1") Ownable() payable {
1853         vaultAddress1 = payable(msg.sender);
1854         vaultAddress2 = payable(msg.sender);
1855     }
1856 
1857     function tokenURI(uint256 _tokenId) override public view returns (string memory) {
1858         require(_exists(_tokenId), "tokenURI: URI query for nonexistent token");
1859         
1860         string memory _tokenIdStr = Strings.toString(_tokenId);
1861         if(isBlindBox == true){
1862             return string(abi.encodePacked(ipfsAddr1, _tokenIdStr, ".json"));
1863         }
1864         else{
1865              return string(abi.encodePacked(ipfsAddr2, _tokenIdStr, ".json"));
1866         }
1867     }
1868     
1869     
1870     function mint(MintVoucher calldata voucher) public nonReentrant payable {
1871         AccountParam storage _accountParam = mapAccount[msg.sender];
1872 
1873         require(curTokenID <= maxTokenID, "All nfts have been mined");      
1874         require(_accountParam.claimCnt < 2, "claim count > 2");
1875         require(msg.value == mintPrice,  string(abi.encodePacked("claim nft require ", Strings.toString(mintPrice), " wei")));
1876 
1877         bool _allowMint = false;
1878         if(isPublicSale)
1879             _allowMint = true;
1880         else if(isPreSale)
1881         {
1882             require(verifyVoucher(voucher) , "The voucher is invalid");
1883             _allowMint = true;
1884         }
1885 
1886         require(_allowMint == true, "allowMint = false");
1887         
1888         _safeMint(_msgSender(), curTokenID);
1889         
1890         ++_accountParam.claimCnt;
1891         _accountParam.tokenList.push(curTokenID);
1892         ++curTokenID;
1893         
1894     }
1895 
1896 
1897     function addSigner(address _address) external onlyOwner {
1898         bool isExist;
1899         (isExist ,) = _isExistSigner(_address);
1900         if(!isExist){
1901             signers.push(_address);
1902         }
1903     }
1904 
1905     
1906     function removeSigner(address _address) external onlyOwner {
1907         bool isExist;
1908         uint256 index;
1909         (isExist , index) = _isExistSigner(_address);
1910         if(isExist){
1911             signers[index] = signers[signers.length - 1];
1912             signers.pop();
1913         }
1914     }
1915 
1916 
1917     function _isExistSigner(address _address) internal view returns(bool , uint256) {
1918         bool exist;
1919         uint256 index; 
1920         for(uint256 i ; i < signers.length ; i++){
1921             if(signers[i] == _address){
1922                 exist = true;
1923                 index = i;
1924             }
1925         }
1926         return (exist , index);
1927     }
1928 
1929     
1930     function isMintVoucher(MintVoucher calldata voucher) public view returns (bool) {       
1931         bytes32 _hash = _hashTypedDataV4(keccak256(abi.encode(
1932                     MINTVOUCHER_HASH,
1933                     voucher.signer,
1934                     voucher.minter,
1935                     voucher.expiration
1936                 )));
1937 
1938         return ECDSA.recover(_hash, voucher.signature) == voucher.signer;
1939     }
1940 
1941     
1942     function verifyVoucher(MintVoucher calldata voucher) public view returns (bool) {       
1943         require(isMintVoucher(voucher) , "Failed to verify the signature");
1944         bool isExist;
1945         (isExist , ) = _isExistSigner(voucher.signer);
1946         require(isExist , "The signer is invalid");
1947         require(msg.sender == voucher.minter , "Minter is not the current caller");
1948         require(voucher.expiration > block.timestamp , "The voucher has expired");
1949         return true;
1950     }
1951 
1952 
1953 
1954     function balanceOfContract() public view onlyOwner returns (uint) {
1955         return  address(this).balance;
1956     }
1957     
1958     function withdraw() public nonReentrant onlyOwner{
1959         uint256 _amount = address(this).balance;
1960         uint256 _div = SafeMath.div(_amount, 100);
1961         uint256 _amount1 =  SafeMath.mul(_div, 15);
1962         uint256 _amount2 = _amount - _amount1;
1963 
1964         (bool success1, ) = vaultAddress1.call{value: _amount1}("");
1965         require(success1, "Failed to send Ether to vaultAdrress1");
1966 
1967         (bool success2, ) = vaultAddress2.call{value: _amount2}("");
1968         require(success2, "Failed to send Ether to vaultAdrress2");
1969     }
1970     
1971     function startPreSale() public onlyOwner{
1972         isPreSale = true;
1973     }
1974 
1975     function pausedPreSale() public onlyOwner{
1976         isPreSale = false;
1977     }
1978 
1979     function startPublicSale() public onlyOwner{
1980         isPublicSale = true;
1981     }
1982 
1983     function pausedPublicSale() public onlyOwner{
1984         isPublicSale = false;
1985     }
1986 
1987     function setVaultAddress(address _vaultAddr1, address _vaultAddr2) public nonReentrant onlyOwner{
1988         vaultAddress1 = payable(_vaultAddr1);
1989         vaultAddress2 = payable(_vaultAddr2);
1990     }
1991 
1992 
1993     function setMintPrice(uint256 _mintPrice) public nonReentrant onlyOwner{
1994         mintPrice = _mintPrice;
1995     }
1996 
1997     function toggleDisplayMode() public onlyOwner{
1998         isBlindBox = !isBlindBox;
1999     }
2000 
2001     function setMetaAddress(string memory _url1, string memory _url2) public onlyOwner{
2002         ipfsAddr1 = _url1;
2003         ipfsAddr2 = _url2;
2004     }
2005 
2006     function reserve(uint _count) public onlyOwner{
2007         AccountParam storage _accountParam = mapAccount[msg.sender];
2008 
2009         for(uint _i = 0; _i < _count; ++_i)
2010         {
2011             if(curTokenID > maxTokenID){
2012               return;
2013             }
2014             _safeMint(_msgSender(), curTokenID);
2015             ++_accountParam.claimCnt;
2016             _accountParam.tokenList.push(curTokenID);
2017 
2018             ++curTokenID;
2019         }
2020     }
2021 
2022 }