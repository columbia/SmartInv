1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/utils/Strings.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev String operations.
238  */
239 library Strings {
240     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
241 
242     /**
243      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
244      */
245     function toString(uint256 value) internal pure returns (string memory) {
246         // Inspired by OraclizeAPI's implementation - MIT licence
247         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
248 
249         if (value == 0) {
250             return "0";
251         }
252         uint256 temp = value;
253         uint256 digits;
254         while (temp != 0) {
255             digits++;
256             temp /= 10;
257         }
258         bytes memory buffer = new bytes(digits);
259         while (value != 0) {
260             digits -= 1;
261             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
262             value /= 10;
263         }
264         return string(buffer);
265     }
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
269      */
270     function toHexString(uint256 value) internal pure returns (string memory) {
271         if (value == 0) {
272             return "0x00";
273         }
274         uint256 temp = value;
275         uint256 length = 0;
276         while (temp != 0) {
277             length++;
278             temp >>= 8;
279         }
280         return toHexString(value, length);
281     }
282 
283     /**
284      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
285      */
286     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
287         bytes memory buffer = new bytes(2 * length + 2);
288         buffer[0] = "0";
289         buffer[1] = "x";
290         for (uint256 i = 2 * length + 1; i > 1; --i) {
291             buffer[i] = _HEX_SYMBOLS[value & 0xf];
292             value >>= 4;
293         }
294         require(value == 0, "Strings: hex length insufficient");
295         return string(buffer);
296     }
297 }
298 
299 // File: @openzeppelin/contracts/utils/Context.sol
300 
301 
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @dev Provides information about the current execution context, including the
307  * sender of the transaction and its data. While these are generally available
308  * via msg.sender and msg.data, they should not be accessed in such a direct
309  * manner, since when dealing with meta-transactions the account sending and
310  * paying for execution may not be the actual sender (as far as an application
311  * is concerned).
312  *
313  * This contract is only required for intermediate, library-like contracts.
314  */
315 abstract contract Context {
316     function _msgSender() internal view virtual returns (address) {
317         return msg.sender;
318     }
319 
320     function _msgData() internal view virtual returns (bytes calldata) {
321         return msg.data;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/access/Ownable.sol
326 
327 
328 
329 pragma solidity ^0.8.0;
330 
331 
332 /**
333  * @dev Contract module which provides a basic access control mechanism, where
334  * there is an account (an owner) that can be granted exclusive access to
335  * specific functions.
336  *
337  * By default, the owner account will be the one that deploys the contract. This
338  * can later be changed with {transferOwnership}.
339  *
340  * This module is used through inheritance. It will make available the modifier
341  * `onlyOwner`, which can be applied to your functions to restrict their use to
342  * the owner.
343  */
344 abstract contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
348 
349     /**
350      * @dev Initializes the contract setting the deployer as the initial owner.
351      */
352     constructor() {
353         _setOwner(_msgSender());
354     }
355 
356     /**
357      * @dev Returns the address of the current owner.
358      */
359     function owner() public view virtual returns (address) {
360         return _owner;
361     }
362 
363     /**
364      * @dev Throws if called by any account other than the owner.
365      */
366     modifier onlyOwner() {
367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
368         _;
369     }
370 
371     /**
372      * @dev Leaves the contract without owner. It will not be possible to call
373      * `onlyOwner` functions anymore. Can only be called by the current owner.
374      *
375      * NOTE: Renouncing ownership will leave the contract without an owner,
376      * thereby removing any functionality that is only available to the owner.
377      */
378     function renounceOwnership() public virtual onlyOwner {
379         _setOwner(address(0));
380     }
381 
382     /**
383      * @dev Transfers ownership of the contract to a new account (`newOwner`).
384      * Can only be called by the current owner.
385      */
386     function transferOwnership(address newOwner) public virtual onlyOwner {
387         require(newOwner != address(0), "Ownable: new owner is the zero address");
388         _setOwner(newOwner);
389     }
390 
391     function _setOwner(address newOwner) private {
392         address oldOwner = _owner;
393         _owner = newOwner;
394         emit OwnershipTransferred(oldOwner, newOwner);
395     }
396 }
397 
398 // File: @openzeppelin/contracts/utils/Address.sol
399 
400 
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @dev Collection of functions related to the address type
406  */
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * [IMPORTANT]
412      * ====
413      * It is unsafe to assume that an address for which this function returns
414      * false is an externally-owned account (EOA) and not a contract.
415      *
416      * Among others, `isContract` will return false for the following
417      * types of addresses:
418      *
419      *  - an externally-owned account
420      *  - a contract in construction
421      *  - an address where a contract will be created
422      *  - an address where a contract lived, but was destroyed
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies on extcodesize, which returns 0 for contracts in
427         // construction, since the code is only stored at the end of the
428         // constructor execution.
429 
430         uint256 size;
431         assembly {
432             size := extcodesize(account)
433         }
434         return size > 0;
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         (bool success, ) = recipient.call{value: amount}("");
457         require(success, "Address: unable to send value, recipient may have reverted");
458     }
459 
460     /**
461      * @dev Performs a Solidity function call using a low level `call`. A
462      * plain `call` is an unsafe replacement for a function call: use this
463      * function instead.
464      *
465      * If `target` reverts with a revert reason, it is bubbled up by this
466      * function (like regular Solidity function calls).
467      *
468      * Returns the raw returned data. To convert to the expected return value,
469      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
470      *
471      * Requirements:
472      *
473      * - `target` must be a contract.
474      * - calling `target` with `data` must not revert.
475      *
476      * _Available since v3.1._
477      */
478     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionCall(target, data, "Address: low-level call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484      * `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, 0, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but also transferring `value` wei to `target`.
499      *
500      * Requirements:
501      *
502      * - the calling contract must have an ETH balance of at least `value`.
503      * - the called Solidity function must be `payable`.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
517      * with `errorMessage` as a fallback revert reason when `target` reverts.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         require(address(this).balance >= value, "Address: insufficient balance for call");
528         require(isContract(target), "Address: call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.call{value: value}(data);
531         return verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a static call.
537      *
538      * _Available since v3.3._
539      */
540     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
541         return functionStaticCall(target, data, "Address: low-level static call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal view returns (bytes memory) {
555         require(isContract(target), "Address: static call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.staticcall(data);
558         return verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but performing a delegate call.
564      *
565      * _Available since v3.4._
566      */
567     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
568         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
573      * but performing a delegate call.
574      *
575      * _Available since v3.4._
576      */
577     function functionDelegateCall(
578         address target,
579         bytes memory data,
580         string memory errorMessage
581     ) internal returns (bytes memory) {
582         require(isContract(target), "Address: delegate call to non-contract");
583 
584         (bool success, bytes memory returndata) = target.delegatecall(data);
585         return verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
590      * revert reason using the provided one.
591      *
592      * _Available since v4.3._
593      */
594     function verifyCallResult(
595         bool success,
596         bytes memory returndata,
597         string memory errorMessage
598     ) internal pure returns (bytes memory) {
599         if (success) {
600             return returndata;
601         } else {
602             // Look for revert reason and bubble it up if present
603             if (returndata.length > 0) {
604                 // The easiest way to bubble the revert reason is using memory via assembly
605 
606                 assembly {
607                     let returndata_size := mload(returndata)
608                     revert(add(32, returndata), returndata_size)
609                 }
610             } else {
611                 revert(errorMessage);
612             }
613         }
614     }
615 }
616 
617 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
618 
619 
620 
621 pragma solidity ^0.8.0;
622 
623 /**
624  * @title ERC721 token receiver interface
625  * @dev Interface for any contract that wants to support safeTransfers
626  * from ERC721 asset contracts.
627  */
628 interface IERC721Receiver {
629     /**
630      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
631      * by `operator` from `from`, this function is called.
632      *
633      * It must return its Solidity selector to confirm the token transfer.
634      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
635      *
636      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
637      */
638     function onERC721Received(
639         address operator,
640         address from,
641         uint256 tokenId,
642         bytes calldata data
643     ) external returns (bytes4);
644 }
645 
646 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
647 
648 
649 
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @dev Interface of the ERC165 standard, as defined in the
654  * https://eips.ethereum.org/EIPS/eip-165[EIP].
655  *
656  * Implementers can declare support of contract interfaces, which can then be
657  * queried by others ({ERC165Checker}).
658  *
659  * For an implementation, see {ERC165}.
660  */
661 interface IERC165 {
662     /**
663      * @dev Returns true if this contract implements the interface defined by
664      * `interfaceId`. See the corresponding
665      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
666      * to learn more about how these ids are created.
667      *
668      * This function call must use less than 30 000 gas.
669      */
670     function supportsInterface(bytes4 interfaceId) external view returns (bool);
671 }
672 
673 // File: @openzeppelin/contracts/interfaces/IERC165.sol
674 
675 
676 
677 pragma solidity ^0.8.0;
678 
679 
680 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
681 
682 
683 
684 pragma solidity ^0.8.0;
685 
686 
687 /**
688  * @dev Interface for the NFT Royalty Standard
689  */
690 interface IERC2981 is IERC165 {
691     /**
692      * @dev Called with the sale price to determine how much royalty is owed and to whom.
693      * @param tokenId - the NFT asset queried for royalty information
694      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
695      * @return receiver - address of who should be sent the royalty payment
696      * @return royaltyAmount - the royalty payment amount for `salePrice`
697      */
698     function royaltyInfo(uint256 tokenId, uint256 salePrice)
699         external
700         view
701         returns (address receiver, uint256 royaltyAmount);
702 }
703 
704 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
705 
706 
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @dev Implementation of the {IERC165} interface.
713  *
714  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
715  * for the additional interface id that will be supported. For example:
716  *
717  * ```solidity
718  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
720  * }
721  * ```
722  *
723  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
724  */
725 abstract contract ERC165 is IERC165 {
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
730         return interfaceId == type(IERC165).interfaceId;
731     }
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
735 
736 
737 
738 pragma solidity ^0.8.0;
739 
740 
741 /**
742  * @dev Required interface of an ERC721 compliant contract.
743  */
744 interface IERC721 is IERC165 {
745     /**
746      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
747      */
748     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
749 
750     /**
751      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
752      */
753     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
754 
755     /**
756      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
757      */
758     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
759 
760     /**
761      * @dev Returns the number of tokens in ``owner``'s account.
762      */
763     function balanceOf(address owner) external view returns (uint256 balance);
764 
765     /**
766      * @dev Returns the owner of the `tokenId` token.
767      *
768      * Requirements:
769      *
770      * - `tokenId` must exist.
771      */
772     function ownerOf(uint256 tokenId) external view returns (address owner);
773 
774     /**
775      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
776      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must exist and be owned by `from`.
783      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
784      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
785      *
786      * Emits a {Transfer} event.
787      */
788     function safeTransferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) external;
793 
794     /**
795      * @dev Transfers `tokenId` token from `from` to `to`.
796      *
797      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
798      *
799      * Requirements:
800      *
801      * - `from` cannot be the zero address.
802      * - `to` cannot be the zero address.
803      * - `tokenId` token must be owned by `from`.
804      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
805      *
806      * Emits a {Transfer} event.
807      */
808     function transferFrom(
809         address from,
810         address to,
811         uint256 tokenId
812     ) external;
813 
814     /**
815      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
816      * The approval is cleared when the token is transferred.
817      *
818      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
819      *
820      * Requirements:
821      *
822      * - The caller must own the token or be an approved operator.
823      * - `tokenId` must exist.
824      *
825      * Emits an {Approval} event.
826      */
827     function approve(address to, uint256 tokenId) external;
828 
829     /**
830      * @dev Returns the account approved for `tokenId` token.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      */
836     function getApproved(uint256 tokenId) external view returns (address operator);
837 
838     /**
839      * @dev Approve or remove `operator` as an operator for the caller.
840      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
841      *
842      * Requirements:
843      *
844      * - The `operator` cannot be the caller.
845      *
846      * Emits an {ApprovalForAll} event.
847      */
848     function setApprovalForAll(address operator, bool _approved) external;
849 
850     /**
851      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
852      *
853      * See {setApprovalForAll}
854      */
855     function isApprovedForAll(address owner, address operator) external view returns (bool);
856 
857     /**
858      * @dev Safely transfers `tokenId` token from `from` to `to`.
859      *
860      * Requirements:
861      *
862      * - `from` cannot be the zero address.
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must exist and be owned by `from`.
865      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
866      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
867      *
868      * Emits a {Transfer} event.
869      */
870     function safeTransferFrom(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes calldata data
875     ) external;
876 }
877 
878 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
879 
880 
881 
882 pragma solidity ^0.8.0;
883 
884 
885 /**
886  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
887  * @dev See https://eips.ethereum.org/EIPS/eip-721
888  */
889 interface IERC721Enumerable is IERC721 {
890     /**
891      * @dev Returns the total amount of tokens stored by the contract.
892      */
893     function totalSupply() external view returns (uint256);
894 
895     /**
896      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
897      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
898      */
899     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
900 
901     /**
902      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
903      * Use along with {totalSupply} to enumerate all tokens.
904      */
905     function tokenByIndex(uint256 index) external view returns (uint256);
906 }
907 
908 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
909 
910 
911 
912 pragma solidity ^0.8.0;
913 
914 
915 /**
916  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
917  * @dev See https://eips.ethereum.org/EIPS/eip-721
918  */
919 interface IERC721Metadata is IERC721 {
920     /**
921      * @dev Returns the token collection name.
922      */
923     function name() external view returns (string memory);
924 
925     /**
926      * @dev Returns the token collection symbol.
927      */
928     function symbol() external view returns (string memory);
929 
930     /**
931      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
932      */
933     function tokenURI(uint256 tokenId) external view returns (string memory);
934 }
935 
936 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
937 
938 
939 
940 pragma solidity ^0.8.0;
941 
942 
943 
944 
945 
946 
947 
948 
949 /**
950  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
951  * the Metadata extension, but not including the Enumerable extension, which is available separately as
952  * {ERC721Enumerable}.
953  */
954 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
955     using Address for address;
956     using Strings for uint256;
957 
958     // Token name
959     string private _name;
960 
961     // Token symbol
962     string private _symbol;
963 
964     // Mapping from token ID to owner address
965     mapping(uint256 => address) private _owners;
966 
967     // Mapping owner address to token count
968     mapping(address => uint256) private _balances;
969 
970     // Mapping from token ID to approved address
971     mapping(uint256 => address) private _tokenApprovals;
972 
973     // Mapping from owner to operator approvals
974     mapping(address => mapping(address => bool)) private _operatorApprovals;
975 
976     /**
977      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
978      */
979     constructor(string memory name_, string memory symbol_) {
980         _name = name_;
981         _symbol = symbol_;
982     }
983 
984     /**
985      * @dev See {IERC165-supportsInterface}.
986      */
987     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
988         return
989             interfaceId == type(IERC721).interfaceId ||
990             interfaceId == type(IERC721Metadata).interfaceId ||
991             super.supportsInterface(interfaceId);
992     }
993 
994     /**
995      * @dev See {IERC721-balanceOf}.
996      */
997     function balanceOf(address owner) public view virtual override returns (uint256) {
998         require(owner != address(0), "ERC721: balance query for the zero address");
999         return _balances[owner];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-ownerOf}.
1004      */
1005     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1006         address owner = _owners[tokenId];
1007         require(owner != address(0), "ERC721: owner query for nonexistent token");
1008         return owner;
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-name}.
1013      */
1014     function name() public view virtual override returns (string memory) {
1015         return _name;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-symbol}.
1020      */
1021     function symbol() public view virtual override returns (string memory) {
1022         return _symbol;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Metadata-tokenURI}.
1027      */
1028     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1029         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1030 
1031         string memory baseURI = _baseURI();
1032         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1033     }
1034 
1035     /**
1036      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1037      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1038      * by default, can be overriden in child contracts.
1039      */
1040     function _baseURI() internal view virtual returns (string memory) {
1041         return "";
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-approve}.
1046      */
1047     function approve(address to, uint256 tokenId) public virtual override {
1048         address owner = ERC721.ownerOf(tokenId);
1049         require(to != owner, "ERC721: approval to current owner");
1050 
1051         require(
1052             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1053             "ERC721: approve caller is not owner nor approved for all"
1054         );
1055 
1056         _approve(to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-getApproved}.
1061      */
1062     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1063         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1064 
1065         return _tokenApprovals[tokenId];
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-setApprovalForAll}.
1070      */
1071     function setApprovalForAll(address operator, bool approved) public virtual override {
1072         require(operator != _msgSender(), "ERC721: approve to caller");
1073 
1074         _operatorApprovals[_msgSender()][operator] = approved;
1075         emit ApprovalForAll(_msgSender(), operator, approved);
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-isApprovedForAll}.
1080      */
1081     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1082         return _operatorApprovals[owner][operator];
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-transferFrom}.
1087      */
1088     function transferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) public virtual override {
1093         //solhint-disable-next-line max-line-length
1094         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1095 
1096         _transfer(from, to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-safeTransferFrom}.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         safeTransferFrom(from, to, tokenId, "");
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-safeTransferFrom}.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory _data
1118     ) public virtual override {
1119         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1120         _safeTransfer(from, to, tokenId, _data);
1121     }
1122 
1123     /**
1124      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1125      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1126      *
1127      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1128      *
1129      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1130      * implement alternative mechanisms to perform token transfer, such as signature-based.
1131      *
1132      * Requirements:
1133      *
1134      * - `from` cannot be the zero address.
1135      * - `to` cannot be the zero address.
1136      * - `tokenId` token must exist and be owned by `from`.
1137      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _safeTransfer(
1142         address from,
1143         address to,
1144         uint256 tokenId,
1145         bytes memory _data
1146     ) internal virtual {
1147         _transfer(from, to, tokenId);
1148         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1149     }
1150 
1151     /**
1152      * @dev Returns whether `tokenId` exists.
1153      *
1154      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1155      *
1156      * Tokens start existing when they are minted (`_mint`),
1157      * and stop existing when they are burned (`_burn`).
1158      */
1159     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1160         return _owners[tokenId] != address(0);
1161     }
1162 
1163     /**
1164      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must exist.
1169      */
1170     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1171         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1172         address owner = ERC721.ownerOf(tokenId);
1173         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1174     }
1175 
1176     /**
1177      * @dev Safely mints `tokenId` and transfers it to `to`.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must not exist.
1182      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function _safeMint(address to, uint256 tokenId) internal virtual {
1187         _safeMint(to, tokenId, "");
1188     }
1189 
1190     /**
1191      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1192      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1193      */
1194     function _safeMint(
1195         address to,
1196         uint256 tokenId,
1197         bytes memory _data
1198     ) internal virtual {
1199         _mint(to, tokenId);
1200         require(
1201             _checkOnERC721Received(address(0), to, tokenId, _data),
1202             "ERC721: transfer to non ERC721Receiver implementer"
1203         );
1204     }
1205 
1206     /**
1207      * @dev Mints `tokenId` and transfers it to `to`.
1208      *
1209      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must not exist.
1214      * - `to` cannot be the zero address.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _mint(address to, uint256 tokenId) internal virtual {
1219         require(to != address(0), "ERC721: mint to the zero address");
1220         require(!_exists(tokenId), "ERC721: token already minted");
1221 
1222         _beforeTokenTransfer(address(0), to, tokenId);
1223 
1224         _balances[to] += 1;
1225         _owners[tokenId] = to;
1226 
1227         emit Transfer(address(0), to, tokenId);
1228     }
1229 
1230     /**
1231      * @dev Destroys `tokenId`.
1232      * The approval is cleared when the token is burned.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must exist.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _burn(uint256 tokenId) internal virtual {
1241         address owner = ERC721.ownerOf(tokenId);
1242 
1243         _beforeTokenTransfer(owner, address(0), tokenId);
1244 
1245         // Clear approvals
1246         _approve(address(0), tokenId);
1247 
1248         _balances[owner] -= 1;
1249         delete _owners[tokenId];
1250 
1251         emit Transfer(owner, address(0), tokenId);
1252     }
1253 
1254     /**
1255      * @dev Transfers `tokenId` from `from` to `to`.
1256      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1257      *
1258      * Requirements:
1259      *
1260      * - `to` cannot be the zero address.
1261      * - `tokenId` token must be owned by `from`.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _transfer(
1266         address from,
1267         address to,
1268         uint256 tokenId
1269     ) internal virtual {
1270         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1271         require(to != address(0), "ERC721: transfer to the zero address");
1272 
1273         _beforeTokenTransfer(from, to, tokenId);
1274 
1275         // Clear approvals from the previous owner
1276         _approve(address(0), tokenId);
1277 
1278         _balances[from] -= 1;
1279         _balances[to] += 1;
1280         _owners[tokenId] = to;
1281 
1282         emit Transfer(from, to, tokenId);
1283     }
1284 
1285     /**
1286      * @dev Approve `to` to operate on `tokenId`
1287      *
1288      * Emits a {Approval} event.
1289      */
1290     function _approve(address to, uint256 tokenId) internal virtual {
1291         _tokenApprovals[tokenId] = to;
1292         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1293     }
1294 
1295     /**
1296      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1297      * The call is not executed if the target address is not a contract.
1298      *
1299      * @param from address representing the previous owner of the given token ID
1300      * @param to target address that will receive the tokens
1301      * @param tokenId uint256 ID of the token to be transferred
1302      * @param _data bytes optional data to send along with the call
1303      * @return bool whether the call correctly returned the expected magic value
1304      */
1305     function _checkOnERC721Received(
1306         address from,
1307         address to,
1308         uint256 tokenId,
1309         bytes memory _data
1310     ) private returns (bool) {
1311         if (to.isContract()) {
1312             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1313                 return retval == IERC721Receiver.onERC721Received.selector;
1314             } catch (bytes memory reason) {
1315                 if (reason.length == 0) {
1316                     revert("ERC721: transfer to non ERC721Receiver implementer");
1317                 } else {
1318                     assembly {
1319                         revert(add(32, reason), mload(reason))
1320                     }
1321                 }
1322             }
1323         } else {
1324             return true;
1325         }
1326     }
1327 
1328     /**
1329      * @dev Hook that is called before any token transfer. This includes minting
1330      * and burning.
1331      *
1332      * Calling conditions:
1333      *
1334      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1335      * transferred to `to`.
1336      * - When `from` is zero, `tokenId` will be minted for `to`.
1337      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1338      * - `from` and `to` are never both zero.
1339      *
1340      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1341      */
1342     function _beforeTokenTransfer(
1343         address from,
1344         address to,
1345         uint256 tokenId
1346     ) internal virtual {}
1347 }
1348 
1349 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1350 
1351 
1352 
1353 pragma solidity ^0.8.0;
1354 
1355 
1356 
1357 /**
1358  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1359  * enumerability of all the token ids in the contract as well as all token ids owned by each
1360  * account.
1361  */
1362 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1363     // Mapping from owner to list of owned token IDs
1364     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1365 
1366     // Mapping from token ID to index of the owner tokens list
1367     mapping(uint256 => uint256) private _ownedTokensIndex;
1368 
1369     // Array with all token ids, used for enumeration
1370     uint256[] private _allTokens;
1371 
1372     // Mapping from token id to position in the allTokens array
1373     mapping(uint256 => uint256) private _allTokensIndex;
1374 
1375     /**
1376      * @dev See {IERC165-supportsInterface}.
1377      */
1378     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1379         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1380     }
1381 
1382     /**
1383      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1384      */
1385     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1386         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1387         return _ownedTokens[owner][index];
1388     }
1389 
1390     /**
1391      * @dev See {IERC721Enumerable-totalSupply}.
1392      */
1393     function totalSupply() public view virtual override returns (uint256) {
1394         return _allTokens.length;
1395     }
1396 
1397     /**
1398      * @dev See {IERC721Enumerable-tokenByIndex}.
1399      */
1400     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1401         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1402         return _allTokens[index];
1403     }
1404 
1405     /**
1406      * @dev Hook that is called before any token transfer. This includes minting
1407      * and burning.
1408      *
1409      * Calling conditions:
1410      *
1411      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1412      * transferred to `to`.
1413      * - When `from` is zero, `tokenId` will be minted for `to`.
1414      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1415      * - `from` cannot be the zero address.
1416      * - `to` cannot be the zero address.
1417      *
1418      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1419      */
1420     function _beforeTokenTransfer(
1421         address from,
1422         address to,
1423         uint256 tokenId
1424     ) internal virtual override {
1425         super._beforeTokenTransfer(from, to, tokenId);
1426 
1427         if (from == address(0)) {
1428             _addTokenToAllTokensEnumeration(tokenId);
1429         } else if (from != to) {
1430             _removeTokenFromOwnerEnumeration(from, tokenId);
1431         }
1432         if (to == address(0)) {
1433             _removeTokenFromAllTokensEnumeration(tokenId);
1434         } else if (to != from) {
1435             _addTokenToOwnerEnumeration(to, tokenId);
1436         }
1437     }
1438 
1439     /**
1440      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1441      * @param to address representing the new owner of the given token ID
1442      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1443      */
1444     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1445         uint256 length = ERC721.balanceOf(to);
1446         _ownedTokens[to][length] = tokenId;
1447         _ownedTokensIndex[tokenId] = length;
1448     }
1449 
1450     /**
1451      * @dev Private function to add a token to this extension's token tracking data structures.
1452      * @param tokenId uint256 ID of the token to be added to the tokens list
1453      */
1454     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1455         _allTokensIndex[tokenId] = _allTokens.length;
1456         _allTokens.push(tokenId);
1457     }
1458 
1459     /**
1460      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1461      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1462      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1463      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1464      * @param from address representing the previous owner of the given token ID
1465      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1466      */
1467     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1468         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1469         // then delete the last slot (swap and pop).
1470 
1471         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1472         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1473 
1474         // When the token to delete is the last token, the swap operation is unnecessary
1475         if (tokenIndex != lastTokenIndex) {
1476             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1477 
1478             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1479             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1480         }
1481 
1482         // This also deletes the contents at the last position of the array
1483         delete _ownedTokensIndex[tokenId];
1484         delete _ownedTokens[from][lastTokenIndex];
1485     }
1486 
1487     /**
1488      * @dev Private function to remove a token from this extension's token tracking data structures.
1489      * This has O(1) time complexity, but alters the order of the _allTokens array.
1490      * @param tokenId uint256 ID of the token to be removed from the tokens list
1491      */
1492     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1493         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1494         // then delete the last slot (swap and pop).
1495 
1496         uint256 lastTokenIndex = _allTokens.length - 1;
1497         uint256 tokenIndex = _allTokensIndex[tokenId];
1498 
1499         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1500         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1501         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1502         uint256 lastTokenId = _allTokens[lastTokenIndex];
1503 
1504         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1505         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1506 
1507         // This also deletes the contents at the last position of the array
1508         delete _allTokensIndex[tokenId];
1509         _allTokens.pop();
1510     }
1511 }
1512 
1513 // File: contracts/MettiLandscape.sol
1514 
1515 
1516 // ███    ███ ███████ ████████ ████████ ██     ██       █████  ███    ██ ██████  ███████  ██████  █████  ██████  ███████ 
1517 // ████  ████ ██         ██       ██    ██     ██      ██   ██ ████   ██ ██   ██ ██      ██      ██   ██ ██   ██ ██      
1518 // ██ ████ ██ █████      ██       ██    ██     ██      ███████ ██ ██  ██ ██   ██ ███████ ██      ███████ ██████  █████   
1519 // ██  ██  ██ ██         ██       ██    ██     ██      ██   ██ ██  ██ ██ ██   ██      ██ ██      ██   ██ ██      ██      
1520 // ██      ██ ███████    ██       ██    ██     ███████ ██   ██ ██   ████ ██████  ███████  ██████ ██   ██ ██      ███████ 
1521 //
1522 // ██████  ██    ██ 
1523 // ██   ██  ██  ██  
1524 // ██████    ████   
1525 // ██   ██    ██    
1526 // ██████     ██    
1527 //
1528 // ██████  ██    ██ ███    ███ ██████   █████  ███    ███ ███████ ████████ ████████ ██ 
1529 // ██   ██ ██    ██ ████  ████ ██   ██ ██   ██ ████  ████ ██         ██       ██    ██ 
1530 // ██████  ██    ██ ██ ████ ██ ██████  ███████ ██ ████ ██ █████      ██       ██    ██ 
1531 // ██      ██    ██ ██  ██  ██ ██      ██   ██ ██  ██  ██ ██         ██       ██    ██ 
1532 // ██       ██████  ██      ██ ██      ██   ██ ██      ██ ███████    ██       ██    ██ 
1533 
1534 //Metti Landscape (MSCAPE) is a fine art banner NFT collection from artist Pumpametti. This is the genesis NFT banner collection from the artist. 
1535 //Reveal of Metti Landscape will happen on Oct 25th,2021, 5pm EST.
1536 
1537 //Lifetime free mint for Pumpametti holders
1538 //0.03 eth per mint for Pettametti holders
1539 //0.04 eth per mint for Standametti holders
1540 
1541 //Only 1 Metti Landscape per transaction
1542 
1543 //For Pumpa holders please select "PumpaFirstChoiceVIPMint"
1544 //For Petta holders please select "PettaVernissageMint"
1545 //For Standa holders please select "StandaPrivateMint"
1546 
1547 //No public mint, you have to own a Metti to mint a Metti Landscape
1548 //Only mint from contract
1549 
1550 //https://pumpametti.com/
1551 
1552 //SPDX-License-Identifier: MIT
1553 
1554 pragma solidity ^0.8.0;
1555 
1556 interface PumpaInterface {
1557     function ownerOf(uint256 tokenId) external view returns (address owner);
1558     function balanceOf(address owner) external view returns (uint256 balance);
1559     function tokenOfOwnerByIndex(address owner, uint256 index)
1560         external
1561         view
1562         returns (uint256 tokenId);
1563 }
1564 
1565 interface PettaInterface {
1566     function ownerOf(uint256 tokenId) external view returns (address owner);
1567     function balanceOf(address owner) external view returns (uint256 balance);
1568     function tokenOfOwnerByIndex(address owner, uint256 index)
1569         external
1570         view
1571         returns (uint256 tokenId);
1572 }
1573 
1574 interface StandaInterface {
1575     function ownerOf(uint256 tokenId) external view returns (address owner);
1576     function balanceOf(address owner) external view returns (uint256 balance);
1577     function tokenOfOwnerByIndex(address owner, uint256 index)
1578         external
1579         view
1580         returns (uint256 tokenId);
1581 }
1582 
1583 
1584 
1585 
1586 
1587 contract MettiLandscape is ERC721Enumerable, Ownable, IERC2981 {
1588   using Strings for uint256;
1589   using SafeMath for uint256;
1590  
1591   string public baseURI;
1592   string public baseExtension = ".json";
1593   string public notRevealedUri;
1594   uint256 public cost = 0.05 ether;
1595   uint256 public maxPumpaSupply = 300;
1596   uint256 public maxPettaStandaSupply = 1700;
1597   uint256 public maxMintAmount = 1;
1598   bool public paused = false;
1599   bool public revealed = false;
1600   
1601   uint16 internal royalty = 700; // base 10000, 7%
1602   uint16 public constant BASE = 10000;
1603 
1604   address public PumpaAddress = 0x09646c5c1e42ede848A57d6542382C32f2877164;
1605   PumpaInterface PumpaContract = PumpaInterface(PumpaAddress);
1606   uint public PumpaOwnersSupplyMinted = 0;
1607   uint public PettaStandaSupplyMinted = 0;
1608 
1609   address public PettaAddress = 0x52474FBF6b678a280d0C69F2314d6d95548b3DAF;
1610   PettaInterface PettaContract = PettaInterface(PettaAddress);
1611 
1612   address public StandaAddress = 0xFC6Bc5D50912354e89bAd4daBf053Bca2d7Cd817;
1613   StandaInterface StandaContract = StandaInterface(StandaAddress);
1614 
1615   constructor( 
1616     string memory _initBaseURI,
1617     string memory _initNotRevealedUri
1618   ) ERC721("Metti Landscape", "MSCAPE") {
1619     setBaseURI(_initBaseURI);
1620     setNotRevealedURI(_initNotRevealedUri);
1621   }
1622 
1623   // internal
1624   function _baseURI() internal view virtual override returns (string memory) {
1625     return baseURI;
1626   }
1627 
1628   function PumpaFirstChoiceVIPMint(uint PumpaId) public payable {
1629     require(PumpaId > 0 && PumpaId <= 300, "Token ID invalid");
1630     require(PumpaContract.ownerOf(PumpaId) == msg.sender, "Not the owner of this Pumpa");
1631 
1632     _safeMint(msg.sender, PumpaId);
1633   }
1634 
1635   function PettaVernissageMint(uint PettaId, uint _mintAmount) public payable {
1636     require(PettaContract.ownerOf(PettaId) == msg.sender, "Not the owner of this Petta");
1637     require(msg.value >= 0.03 ether * _mintAmount);
1638     require(!paused);
1639     require(_mintAmount > 0);
1640     require(_mintAmount <= maxMintAmount);
1641     require(PettaStandaSupplyMinted + _mintAmount <= maxPettaStandaSupply, "No more PettaStanda supply left");
1642 
1643     for (uint256 i = 1; i <= _mintAmount; i++) {
1644       _safeMint(msg.sender, maxPumpaSupply + PettaStandaSupplyMinted + i);
1645     }
1646     PettaStandaSupplyMinted = PettaStandaSupplyMinted + _mintAmount;
1647 }
1648 
1649   function StandaPrivateMint(uint StandaId, uint _mintAmount) public payable {
1650     require(StandaContract.ownerOf(StandaId) == msg.sender, "Not the owner of this Standa");
1651     require(msg.value >= 0.04 ether * _mintAmount);
1652     require(!paused);
1653     require(_mintAmount > 0);
1654     require(_mintAmount <= maxMintAmount);
1655     require(PettaStandaSupplyMinted + _mintAmount <= maxPettaStandaSupply, "No more PettaStanda supply left");
1656 
1657     for (uint256 i = 1; i <= _mintAmount; i++) {
1658       _safeMint(msg.sender, maxPumpaSupply + PettaStandaSupplyMinted + i);
1659     }
1660     PettaStandaSupplyMinted = PettaStandaSupplyMinted + _mintAmount;
1661   }
1662 
1663   function tokenURI(uint256 tokenId)
1664     public
1665     view
1666     virtual
1667     override
1668     returns (string memory)
1669   {
1670     require(
1671       _exists(tokenId),
1672       "ERC721Metadata: URI query for nonexistent token"
1673     );
1674     
1675     if(revealed == false) {
1676         return notRevealedUri;
1677     }
1678 
1679     string memory currentBaseURI = _baseURI();
1680     return bytes(currentBaseURI).length > 0
1681         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1682         : "";
1683   }
1684   
1685   //onlyOwner
1686   
1687   function reveal() public onlyOwner {
1688       revealed = true;
1689   }
1690   
1691   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1692     baseURI = _newBaseURI;
1693   }
1694 
1695   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1696     baseExtension = _newBaseExtension;
1697   }
1698   
1699   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1700     notRevealedUri = _notRevealedURI;
1701   }
1702 
1703   function pause(bool _state) public onlyOwner {
1704     paused = _state;
1705   }
1706   
1707   function royaltyInfo(uint256, uint256 _salePrice)
1708         external
1709         view
1710         override
1711         returns (address receiver, uint256 royaltyAmount)
1712     {
1713         return (address(this), (_salePrice * royalty) / BASE);
1714     }
1715 
1716   function setRoyalty(uint16 _royalty) public virtual onlyOwner {
1717         require(_royalty >= 0 && _royalty <= 1000, 'Royalty must be between 0% and 10%.');
1718 
1719         royalty = _royalty;
1720     }
1721 
1722   function withdraw() public payable onlyOwner {
1723     require(payable(msg.sender).send(address(this).balance));
1724   }
1725   
1726 }