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
673 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
674 
675 
676 
677 pragma solidity ^0.8.0;
678 
679 
680 /**
681  * @dev Implementation of the {IERC165} interface.
682  *
683  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
684  * for the additional interface id that will be supported. For example:
685  *
686  * ```solidity
687  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
689  * }
690  * ```
691  *
692  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
693  */
694 abstract contract ERC165 is IERC165 {
695     /**
696      * @dev See {IERC165-supportsInterface}.
697      */
698     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699         return interfaceId == type(IERC165).interfaceId;
700     }
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
704 
705 
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @dev Required interface of an ERC721 compliant contract.
712  */
713 interface IERC721 is IERC165 {
714     /**
715      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
716      */
717     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
718 
719     /**
720      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
721      */
722     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
723 
724     /**
725      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
726      */
727     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
728 
729     /**
730      * @dev Returns the number of tokens in ``owner``'s account.
731      */
732     function balanceOf(address owner) external view returns (uint256 balance);
733 
734     /**
735      * @dev Returns the owner of the `tokenId` token.
736      *
737      * Requirements:
738      *
739      * - `tokenId` must exist.
740      */
741     function ownerOf(uint256 tokenId) external view returns (address owner);
742 
743     /**
744      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
745      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
746      *
747      * Requirements:
748      *
749      * - `from` cannot be the zero address.
750      * - `to` cannot be the zero address.
751      * - `tokenId` token must exist and be owned by `from`.
752      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
753      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
754      *
755      * Emits a {Transfer} event.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) external;
762 
763     /**
764      * @dev Transfers `tokenId` token from `from` to `to`.
765      *
766      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must be owned by `from`.
773      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
774      *
775      * Emits a {Transfer} event.
776      */
777     function transferFrom(
778         address from,
779         address to,
780         uint256 tokenId
781     ) external;
782 
783     /**
784      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
785      * The approval is cleared when the token is transferred.
786      *
787      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
788      *
789      * Requirements:
790      *
791      * - The caller must own the token or be an approved operator.
792      * - `tokenId` must exist.
793      *
794      * Emits an {Approval} event.
795      */
796     function approve(address to, uint256 tokenId) external;
797 
798     /**
799      * @dev Returns the account approved for `tokenId` token.
800      *
801      * Requirements:
802      *
803      * - `tokenId` must exist.
804      */
805     function getApproved(uint256 tokenId) external view returns (address operator);
806 
807     /**
808      * @dev Approve or remove `operator` as an operator for the caller.
809      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
810      *
811      * Requirements:
812      *
813      * - The `operator` cannot be the caller.
814      *
815      * Emits an {ApprovalForAll} event.
816      */
817     function setApprovalForAll(address operator, bool _approved) external;
818 
819     /**
820      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
821      *
822      * See {setApprovalForAll}
823      */
824     function isApprovedForAll(address owner, address operator) external view returns (bool);
825 
826     /**
827      * @dev Safely transfers `tokenId` token from `from` to `to`.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must exist and be owned by `from`.
834      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
836      *
837      * Emits a {Transfer} event.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId,
843         bytes calldata data
844     ) external;
845 }
846 
847 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
848 
849 
850 
851 pragma solidity ^0.8.0;
852 
853 
854 /**
855  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
856  * @dev See https://eips.ethereum.org/EIPS/eip-721
857  */
858 interface IERC721Enumerable is IERC721 {
859     /**
860      * @dev Returns the total amount of tokens stored by the contract.
861      */
862     function totalSupply() external view returns (uint256);
863 
864     /**
865      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
866      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
867      */
868     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
869 
870     /**
871      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
872      * Use along with {totalSupply} to enumerate all tokens.
873      */
874     function tokenByIndex(uint256 index) external view returns (uint256);
875 }
876 
877 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
878 
879 
880 
881 pragma solidity ^0.8.0;
882 
883 
884 /**
885  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
886  * @dev See https://eips.ethereum.org/EIPS/eip-721
887  */
888 interface IERC721Metadata is IERC721 {
889     /**
890      * @dev Returns the token collection name.
891      */
892     function name() external view returns (string memory);
893 
894     /**
895      * @dev Returns the token collection symbol.
896      */
897     function symbol() external view returns (string memory);
898 
899     /**
900      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
901      */
902     function tokenURI(uint256 tokenId) external view returns (string memory);
903 }
904 
905 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
906 
907 
908 
909 pragma solidity ^0.8.0;
910 
911 
912 
913 
914 
915 
916 
917 
918 /**
919  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
920  * the Metadata extension, but not including the Enumerable extension, which is available separately as
921  * {ERC721Enumerable}.
922  */
923 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
924     using Address for address;
925     using Strings for uint256;
926 
927     // Token name
928     string private _name;
929 
930     // Token symbol
931     string private _symbol;
932 
933     // Mapping from token ID to owner address
934     mapping(uint256 => address) private _owners;
935 
936     // Mapping owner address to token count
937     mapping(address => uint256) private _balances;
938 
939     // Mapping from token ID to approved address
940     mapping(uint256 => address) private _tokenApprovals;
941 
942     // Mapping from owner to operator approvals
943     mapping(address => mapping(address => bool)) private _operatorApprovals;
944 
945     /**
946      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
947      */
948     constructor(string memory name_, string memory symbol_) {
949         _name = name_;
950         _symbol = symbol_;
951     }
952 
953     /**
954      * @dev See {IERC165-supportsInterface}.
955      */
956     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
957         return
958             interfaceId == type(IERC721).interfaceId ||
959             interfaceId == type(IERC721Metadata).interfaceId ||
960             super.supportsInterface(interfaceId);
961     }
962 
963     /**
964      * @dev See {IERC721-balanceOf}.
965      */
966     function balanceOf(address owner) public view virtual override returns (uint256) {
967         require(owner != address(0), "ERC721: balance query for the zero address");
968         return _balances[owner];
969     }
970 
971     /**
972      * @dev See {IERC721-ownerOf}.
973      */
974     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
975         address owner = _owners[tokenId];
976         require(owner != address(0), "ERC721: owner query for nonexistent token");
977         return owner;
978     }
979 
980     /**
981      * @dev See {IERC721Metadata-name}.
982      */
983     function name() public view virtual override returns (string memory) {
984         return _name;
985     }
986 
987     /**
988      * @dev See {IERC721Metadata-symbol}.
989      */
990     function symbol() public view virtual override returns (string memory) {
991         return _symbol;
992     }
993 
994     /**
995      * @dev See {IERC721Metadata-tokenURI}.
996      */
997     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
998         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
999 
1000         string memory baseURI = _baseURI();
1001         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1002     }
1003 
1004     /**
1005      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1006      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1007      * by default, can be overriden in child contracts.
1008      */
1009     function _baseURI() internal view virtual returns (string memory) {
1010         return "";
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-approve}.
1015      */
1016     function approve(address to, uint256 tokenId) public virtual override {
1017         address owner = ERC721.ownerOf(tokenId);
1018         require(to != owner, "ERC721: approval to current owner");
1019 
1020         require(
1021             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1022             "ERC721: approve caller is not owner nor approved for all"
1023         );
1024 
1025         _approve(to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-getApproved}.
1030      */
1031     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1032         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1033 
1034         return _tokenApprovals[tokenId];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-setApprovalForAll}.
1039      */
1040     function setApprovalForAll(address operator, bool approved) public virtual override {
1041         require(operator != _msgSender(), "ERC721: approve to caller");
1042 
1043         _operatorApprovals[_msgSender()][operator] = approved;
1044         emit ApprovalForAll(_msgSender(), operator, approved);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-isApprovedForAll}.
1049      */
1050     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1051         return _operatorApprovals[owner][operator];
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-transferFrom}.
1056      */
1057     function transferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) public virtual override {
1062         //solhint-disable-next-line max-line-length
1063         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1064 
1065         _transfer(from, to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-safeTransferFrom}.
1070      */
1071     function safeTransferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) public virtual override {
1076         safeTransferFrom(from, to, tokenId, "");
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-safeTransferFrom}.
1081      */
1082     function safeTransferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) public virtual override {
1088         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1089         _safeTransfer(from, to, tokenId, _data);
1090     }
1091 
1092     /**
1093      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1094      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1095      *
1096      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1097      *
1098      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1099      * implement alternative mechanisms to perform token transfer, such as signature-based.
1100      *
1101      * Requirements:
1102      *
1103      * - `from` cannot be the zero address.
1104      * - `to` cannot be the zero address.
1105      * - `tokenId` token must exist and be owned by `from`.
1106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _safeTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId,
1114         bytes memory _data
1115     ) internal virtual {
1116         _transfer(from, to, tokenId);
1117         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1118     }
1119 
1120     /**
1121      * @dev Returns whether `tokenId` exists.
1122      *
1123      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1124      *
1125      * Tokens start existing when they are minted (`_mint`),
1126      * and stop existing when they are burned (`_burn`).
1127      */
1128     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1129         return _owners[tokenId] != address(0);
1130     }
1131 
1132     /**
1133      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1134      *
1135      * Requirements:
1136      *
1137      * - `tokenId` must exist.
1138      */
1139     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1140         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1141         address owner = ERC721.ownerOf(tokenId);
1142         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1143     }
1144 
1145     /**
1146      * @dev Safely mints `tokenId` and transfers it to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must not exist.
1151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _safeMint(address to, uint256 tokenId) internal virtual {
1156         _safeMint(to, tokenId, "");
1157     }
1158 
1159     /**
1160      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1161      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1162      */
1163     function _safeMint(
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) internal virtual {
1168         _mint(to, tokenId);
1169         require(
1170             _checkOnERC721Received(address(0), to, tokenId, _data),
1171             "ERC721: transfer to non ERC721Receiver implementer"
1172         );
1173     }
1174 
1175     /**
1176      * @dev Mints `tokenId` and transfers it to `to`.
1177      *
1178      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1179      *
1180      * Requirements:
1181      *
1182      * - `tokenId` must not exist.
1183      * - `to` cannot be the zero address.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _mint(address to, uint256 tokenId) internal virtual {
1188         require(to != address(0), "ERC721: mint to the zero address");
1189         require(!_exists(tokenId), "ERC721: token already minted");
1190 
1191         _beforeTokenTransfer(address(0), to, tokenId);
1192 
1193         _balances[to] += 1;
1194         _owners[tokenId] = to;
1195 
1196         emit Transfer(address(0), to, tokenId);
1197     }
1198 
1199     /**
1200      * @dev Destroys `tokenId`.
1201      * The approval is cleared when the token is burned.
1202      *
1203      * Requirements:
1204      *
1205      * - `tokenId` must exist.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _burn(uint256 tokenId) internal virtual {
1210         address owner = ERC721.ownerOf(tokenId);
1211 
1212         _beforeTokenTransfer(owner, address(0), tokenId);
1213 
1214         // Clear approvals
1215         _approve(address(0), tokenId);
1216 
1217         _balances[owner] -= 1;
1218         delete _owners[tokenId];
1219 
1220         emit Transfer(owner, address(0), tokenId);
1221     }
1222 
1223     /**
1224      * @dev Transfers `tokenId` from `from` to `to`.
1225      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1226      *
1227      * Requirements:
1228      *
1229      * - `to` cannot be the zero address.
1230      * - `tokenId` token must be owned by `from`.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _transfer(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) internal virtual {
1239         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1240         require(to != address(0), "ERC721: transfer to the zero address");
1241 
1242         _beforeTokenTransfer(from, to, tokenId);
1243 
1244         // Clear approvals from the previous owner
1245         _approve(address(0), tokenId);
1246 
1247         _balances[from] -= 1;
1248         _balances[to] += 1;
1249         _owners[tokenId] = to;
1250 
1251         emit Transfer(from, to, tokenId);
1252     }
1253 
1254     /**
1255      * @dev Approve `to` to operate on `tokenId`
1256      *
1257      * Emits a {Approval} event.
1258      */
1259     function _approve(address to, uint256 tokenId) internal virtual {
1260         _tokenApprovals[tokenId] = to;
1261         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1262     }
1263 
1264     /**
1265      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1266      * The call is not executed if the target address is not a contract.
1267      *
1268      * @param from address representing the previous owner of the given token ID
1269      * @param to target address that will receive the tokens
1270      * @param tokenId uint256 ID of the token to be transferred
1271      * @param _data bytes optional data to send along with the call
1272      * @return bool whether the call correctly returned the expected magic value
1273      */
1274     function _checkOnERC721Received(
1275         address from,
1276         address to,
1277         uint256 tokenId,
1278         bytes memory _data
1279     ) private returns (bool) {
1280         if (to.isContract()) {
1281             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1282                 return retval == IERC721Receiver.onERC721Received.selector;
1283             } catch (bytes memory reason) {
1284                 if (reason.length == 0) {
1285                     revert("ERC721: transfer to non ERC721Receiver implementer");
1286                 } else {
1287                     assembly {
1288                         revert(add(32, reason), mload(reason))
1289                     }
1290                 }
1291             }
1292         } else {
1293             return true;
1294         }
1295     }
1296 
1297     /**
1298      * @dev Hook that is called before any token transfer. This includes minting
1299      * and burning.
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1307      * - `from` and `to` are never both zero.
1308      *
1309      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1310      */
1311     function _beforeTokenTransfer(
1312         address from,
1313         address to,
1314         uint256 tokenId
1315     ) internal virtual {}
1316 }
1317 
1318 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1319 
1320 
1321 
1322 pragma solidity ^0.8.0;
1323 
1324 
1325 
1326 /**
1327  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1328  * enumerability of all the token ids in the contract as well as all token ids owned by each
1329  * account.
1330  */
1331 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1332     // Mapping from owner to list of owned token IDs
1333     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1334 
1335     // Mapping from token ID to index of the owner tokens list
1336     mapping(uint256 => uint256) private _ownedTokensIndex;
1337 
1338     // Array with all token ids, used for enumeration
1339     uint256[] private _allTokens;
1340 
1341     // Mapping from token id to position in the allTokens array
1342     mapping(uint256 => uint256) private _allTokensIndex;
1343 
1344     /**
1345      * @dev See {IERC165-supportsInterface}.
1346      */
1347     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1348         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1349     }
1350 
1351     /**
1352      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1353      */
1354     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1355         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1356         return _ownedTokens[owner][index];
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Enumerable-totalSupply}.
1361      */
1362     function totalSupply() public view virtual override returns (uint256) {
1363         return _allTokens.length;
1364     }
1365 
1366     /**
1367      * @dev See {IERC721Enumerable-tokenByIndex}.
1368      */
1369     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1370         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1371         return _allTokens[index];
1372     }
1373 
1374     /**
1375      * @dev Hook that is called before any token transfer. This includes minting
1376      * and burning.
1377      *
1378      * Calling conditions:
1379      *
1380      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1381      * transferred to `to`.
1382      * - When `from` is zero, `tokenId` will be minted for `to`.
1383      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1384      * - `from` cannot be the zero address.
1385      * - `to` cannot be the zero address.
1386      *
1387      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1388      */
1389     function _beforeTokenTransfer(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) internal virtual override {
1394         super._beforeTokenTransfer(from, to, tokenId);
1395 
1396         if (from == address(0)) {
1397             _addTokenToAllTokensEnumeration(tokenId);
1398         } else if (from != to) {
1399             _removeTokenFromOwnerEnumeration(from, tokenId);
1400         }
1401         if (to == address(0)) {
1402             _removeTokenFromAllTokensEnumeration(tokenId);
1403         } else if (to != from) {
1404             _addTokenToOwnerEnumeration(to, tokenId);
1405         }
1406     }
1407 
1408     /**
1409      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1410      * @param to address representing the new owner of the given token ID
1411      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1412      */
1413     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1414         uint256 length = ERC721.balanceOf(to);
1415         _ownedTokens[to][length] = tokenId;
1416         _ownedTokensIndex[tokenId] = length;
1417     }
1418 
1419     /**
1420      * @dev Private function to add a token to this extension's token tracking data structures.
1421      * @param tokenId uint256 ID of the token to be added to the tokens list
1422      */
1423     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1424         _allTokensIndex[tokenId] = _allTokens.length;
1425         _allTokens.push(tokenId);
1426     }
1427 
1428     /**
1429      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1430      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1431      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1432      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1433      * @param from address representing the previous owner of the given token ID
1434      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1435      */
1436     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1437         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1438         // then delete the last slot (swap and pop).
1439 
1440         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1441         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1442 
1443         // When the token to delete is the last token, the swap operation is unnecessary
1444         if (tokenIndex != lastTokenIndex) {
1445             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1446 
1447             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1448             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1449         }
1450 
1451         // This also deletes the contents at the last position of the array
1452         delete _ownedTokensIndex[tokenId];
1453         delete _ownedTokens[from][lastTokenIndex];
1454     }
1455 
1456     /**
1457      * @dev Private function to remove a token from this extension's token tracking data structures.
1458      * This has O(1) time complexity, but alters the order of the _allTokens array.
1459      * @param tokenId uint256 ID of the token to be removed from the tokens list
1460      */
1461     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1462         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1463         // then delete the last slot (swap and pop).
1464 
1465         uint256 lastTokenIndex = _allTokens.length - 1;
1466         uint256 tokenIndex = _allTokensIndex[tokenId];
1467 
1468         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1469         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1470         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1471         uint256 lastTokenId = _allTokens[lastTokenIndex];
1472 
1473         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1474         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1475 
1476         // This also deletes the contents at the last position of the array
1477         delete _allTokensIndex[tokenId];
1478         _allTokens.pop();
1479     }
1480 }
1481 
1482 // File: contracts/Limah.sol
1483 
1484 
1485 pragma solidity ^0.8.0;
1486 
1487 
1488 
1489 
1490 
1491 
1492 contract Limah is ERC721, ERC721Enumerable, Ownable {
1493     using SafeMath for uint256;
1494     using SafeMath for uint64;
1495     
1496     uint256 public constant maxSupply = 555;
1497     uint256 public constant reservedCount = 13;
1498     uint256 private _price = 0.1 ether;
1499     uint256 private _reservedClaimed = 0;
1500     uint256 public currentMintId = 1;
1501 
1502     bool private _saleStarted;
1503     bool private _presaleStarted;
1504     string public baseURI;
1505     mapping(address => uint256) public whitelistBalance;
1506     mapping(address => uint256) public whitelistMinted;
1507     mapping(uint256 => uint64) public metadata;
1508 
1509     event Minted(address account, uint256 amount, uint256 cost);
1510     event PresaleMinted(address account, uint256 amount, uint256 cost);
1511 
1512     constructor() ERC721("LIMAH", "LIMH") {
1513         _saleStarted = false;
1514         _presaleStarted = false;
1515 
1516         whitelistBalance[0xBcc462c488F8DA534aF98F0f2E529CDed02D9CB5] = 4;
1517         whitelistBalance[0x8e258E1Aa12b8f165B69f760575b90d877AfE9b6] = 3;
1518         whitelistBalance[0xE39CB1c2f6dC891A1685ee411B4D36827e4F860E] = 1;
1519         whitelistBalance[0x881475210E75b814D5b711090a064942b6f30605] = 1;
1520         whitelistBalance[0x74E094Be60Be8DB1e39a0b2aB395b888b478B6De] = 3;
1521         whitelistBalance[0x149884b699FE3E1b042f85fA3B54843EB689b2d4] = 3;
1522         whitelistBalance[0x62756BEdC2c98f80cE83E45BC9f8062345b65d8e] = 4;
1523         whitelistBalance[0x80965566ceDc9b9C8aeDa24bbc12e44eb476dEf6] = 2;
1524         whitelistBalance[0xE4Abc24b5A6732a8945A85B768B4a3120CB2E37C] = 1;
1525         whitelistBalance[0x3c64DA143Bf741A3fa833Dd46900d28EFE8893B3] = 5;
1526         whitelistBalance[0x1024A91b5Ba768601e2bf4f28D2458885652cFa4] = 4;
1527         whitelistBalance[0x4003EC66153c090ed649CE822E30CaBa11727527] = 2;
1528         whitelistBalance[0xBc68c859fc8Ea2de63C60F236688dEE448C8B70e] = 1;
1529         whitelistBalance[0x1Ce7A7F4a2af7c690A7CBEce89e919753E409aDD] = 2;
1530         whitelistBalance[0xfb9699DE6f7eFc7F7D64A40852a68602ac7ef403] = 1;
1531         whitelistBalance[0x6D21b1D31A6Aa760F396729D85460e2F887B8764] = 1;
1532         whitelistBalance[0xa65f5eBFfd31ed58cC3CD5c96B2989B9F58d637C] = 1;
1533         whitelistBalance[0x098753abA8de1e88Fb32E045Ed8eba66735E6391] = 1;
1534         whitelistBalance[0x8Dfa76A3E8f290e6224b93BeBA163B90449B0e38] = 7;
1535         whitelistBalance[0xb1877ec8638a32F68e5DcCeA1202570CbB096357] = 6;
1536         whitelistBalance[0xcC4CCA9F8A1739Ac629acf8761ce4F3720764a96] = 1;
1537         whitelistBalance[0x0e53dbb8d5d58D957480FE522258353408D1d2a6] = 2;
1538         whitelistBalance[0x126438c3A64DA4eF5a8dde07366270367310f855] = 1;
1539         whitelistBalance[0x9a7eE28B4d734378f34c617C488cD8C5805C3B84] = 1;
1540         whitelistBalance[0x7B59793aD075e4ce1e35181054759C080B8D965D] = 4;
1541         whitelistBalance[0x52C8fe1c30a22AF561B1bF1e1D6a476b37d61c68] = 1;
1542         whitelistBalance[0xcE7DEb8fc70838F019a33797e1D2A5De8B7Ae2cC] = 2;
1543         whitelistBalance[0xF0C81C3d9102DDaD3568312d11738C902aB355C2] = 1;
1544         whitelistBalance[0xC60F2319eEC9B91ac6428055eeD38A946014571D] = 3;
1545         whitelistBalance[0xBB46314634470eD16eeDBE16F301DFE074091375] = 1;
1546         whitelistBalance[0xb6332Be30366Ef76174eFD011c471893c86FC36b] = 1;
1547         whitelistBalance[0x4C33294c13C5e783dd1d28c9844950B33d4DE9a0] = 1;
1548         whitelistBalance[0xc39253C74D2454e8ceBF5d8C6a219505bbe8744a] = 2;
1549         whitelistBalance[0xdF01F73C69b1adBdb74798E531EC08DC1C136d49] = 1;
1550         whitelistBalance[0xB7c6d7406e2F370290111A585D1a7A76B86C8776] = 1;
1551         whitelistBalance[0xA14964479Ebf9cD336011ad80652b08CD83dFE3A] = 2;
1552         whitelistBalance[0x27D998A81b5510Ed61D94aFDAA747e9719b45d0B] = 2;
1553         whitelistBalance[0xC653501899b8740379A3BA78EfD242ca93f76D7A] = 3;
1554         whitelistBalance[0xdD88E38cD55CD5F7e3AA4ce6C28fb73bFddbF0E7] = 1;
1555         whitelistBalance[0x815C187c70Ef6F52c0C9EDc6bb28a619E14057d3] = 2;
1556         whitelistBalance[0xCC75F6166E230CBBE484d534bBB0cC546366DC7D] = 1;
1557         whitelistBalance[0x943bCc065c6a09d8aA26C71F72Af4cdC137D1f84] = 1;
1558         whitelistBalance[0x0701d19c4D9364b69Ca001061aE3eD169a40691B] = 1;
1559         whitelistBalance[0x599eC7E5449E41a0204A0ed17daa1059Ee2C5F28] = 1;
1560         whitelistBalance[0xa9c5b41605f51f3Ba6aeb62258b0DF9B9384d8A1] = 1;
1561         whitelistBalance[0xC585d35FB8C9D136d6443A30FD88CCbb5F4CB86D] = 4;
1562         whitelistBalance[0xD9Bf0EF73403C9DC9490af5c6A2F6f7516286F32] = 1;
1563         whitelistBalance[0x02CBDB002D578b2b83b73b9f6019FADF39fFf6b6] = 1;
1564         whitelistBalance[0x09bC19CD33faF805E55b708C2dB3De87979B3950] = 1;
1565         whitelistBalance[0x532a2707D598d7Ae6B02eF0e0BA897DaF44b1603] = 1;
1566         whitelistBalance[0xC683915268E712F9960Ce59736a32119165Cc962] = 2;
1567         whitelistBalance[0xfDC4364C13E2c892De20Ab2Acb9a80534DE493Fc] = 1;
1568         whitelistBalance[0x248AfBEc09C971372278C1052253E4c308d5430C] = 1;
1569         whitelistBalance[0xb7bB1C09b6fB19e94ac700867ff35FbEd354C1BD] = 3;
1570         whitelistBalance[0x461e76A4fE9f27605d4097A646837c32F1ccc31c] = 1;
1571         whitelistBalance[0xFa46fB8d0a991ac62bD83E1Db1Fe8aba51ef6dd2] = 1;
1572         whitelistBalance[0x1F0Da8D6c0F517c2a67a3F34D1BBebfbD07B6236] = 1;
1573         whitelistBalance[0x83c20F72736E86EA3C64994b38B5102c78120324] = 2;
1574         whitelistBalance[0xbDE914699063F6EA14951AF723D2F13c822bF4ad] = 1;
1575         whitelistBalance[0x33569c101562e1fAF5b24581057E5cEE4c8288D7] = 1;
1576         whitelistBalance[0x15E875bD7De4C3d1F57a9837c411a30ff5f12B38] = 2;
1577         whitelistBalance[0x5078110476Cd2Aa096160F2D988aE80aEaFB5Ae4] = 2;
1578         whitelistBalance[0x2176426a886cbA262308Ba916cC3532B3b1ce06a] = 3;
1579         whitelistBalance[0xea40b0f6BA2aD77fF2FedAe98Ca67EaefCBCBE4A] = 5;
1580         whitelistBalance[0x42f34449209059717e6C48eD0110783A7df82abF] = 8;
1581         whitelistBalance[0x28411D470fc1B40E52AcccF47e43D39e815FfBf0] = 2;
1582         whitelistBalance[0xf7520F1D4D96Da54cF0F938f3f4D33e4bd276453] = 1;
1583         whitelistBalance[0x01dB485f57Dc000E761b85641F78C9D212A2eEaB] = 2;
1584         whitelistBalance[0x00668bd79Ede077B99BbE1C4db59418bC333d4Cf] = 2;
1585         whitelistBalance[0x3ef13C577311Fd6736B23525bC5E3E95060716Fe] = 2;
1586         whitelistBalance[0x05fc3A360944Ba03aBB2bBCcE275F89c96cB1385] = 3;
1587         whitelistBalance[0xD19d92c23Be2c965825f31462F3d8D1f84C17BFc] = 2;
1588         whitelistBalance[0x5482b90E0F59Fb4a926f7FFe9DB9EADE142CF86D] = 1;
1589         whitelistBalance[0x7Da3236aF88181a8AB8bd3929f17EfAD5417DF3A] = 1;
1590         whitelistBalance[0x92B57222582EfB77295454340529c411021c7Bc5] = 2;
1591         whitelistBalance[0x66b19A1241FD54fE74dD8E40B7df8C419492e423] = 1;
1592         whitelistBalance[0x94F0FaA3c83C9Bc78b675dDeA82fcB982fa89690] = 2;
1593         whitelistBalance[0x95e62E8FF84ed8456fDc9739eE4A9597Bb6E4c1f] = 1;
1594         whitelistBalance[0xBE837e4a956cC8118A013563a9E291D8D4D4b8B4] = 1;
1595         whitelistBalance[0xE84b1B9593865cb14846908910bb4B9a85746770] = 1;
1596         whitelistBalance[0x6eF2376fA6e12Dabb3a3ED0Fb44E4ff29847Af68] = 3;
1597         whitelistBalance[0x460b26B95b251B477e2bc52aB731C70F42299adC] = 1;
1598         whitelistBalance[0x3ebFdE946baD00D005A7Abb94bcab866fE11E84F] = 1;
1599         whitelistBalance[0xb7fa496E5166b39a114f5DeF4ae38015b977FeC8] = 1;
1600         whitelistBalance[0x3943b578D00D61b622Fd99AB6F16921e54F7612b] = 1;
1601         whitelistBalance[0x3E4D97C22571C5Ff22f0DAaBDa2d3835E67738EB] = 1;
1602         whitelistBalance[0xd561ba5bdBFEA7A39bF073b7520a7273bc767131] = 1;
1603         whitelistBalance[0xAB00e849A18b2ae3381c8895Cf4b15494CA27561] = 1;
1604         whitelistBalance[0xc2bd956DcaC8268ca78F55d6b33BbA92EEac443D] = 1;
1605         whitelistBalance[0x89097a0A657e42627E05f33DF494dE7f10123651] = 1;
1606         whitelistBalance[0x6ab615CF8deCFc488186E54066Fc10589C9293A3] = 2;
1607         whitelistBalance[0x2DBd479974967b8a0717d8B84c2172D8b26Cdf44] = 8;
1608         whitelistBalance[0xaee2Ae13EBf81d38df5a9Ed7013E80EA3f72e39b] = 4;
1609         whitelistBalance[0x0B4338671b26d40e1177A8A0f64D75f253f15e05] = 1;
1610         whitelistBalance[0x6007dC12910639e692b50E3dAc02747eF6048dB2] = 1;
1611         whitelistBalance[0x2cb9AE536fc474159b95dF01c5a708CAcD9F84B2] = 1;
1612         whitelistBalance[0xbA3df119299a11EA9cFeBC2801a8Bf0102A2bE3d] = 1;
1613         whitelistBalance[0x34Ba3E288c3674e73ab9D3B1B75EE064628d72c6] = 1;
1614         whitelistBalance[0x3AEf5d2384298DB7C7F711224221F229E43cBbA7] = 1;
1615         whitelistBalance[0x7430EA2c3b2F2468Bba97C2B1CCa33f42Af2e57c] = 1;
1616         whitelistBalance[0x115406837DE7D8194421126De6Fa7dc90bDe1663] = 3;
1617         whitelistBalance[0x693e1AEa486c80D34124C6dC3eddDd325A41ABE9] = 1;
1618         whitelistBalance[0x8eE6D1daE8eCeA729bD40a6F3BEde58bF048eD9e] = 2;
1619         whitelistBalance[0xd0c31E46C73B386432A3DdF768587df604dD52BE] = 1;
1620         whitelistBalance[0x2d408F3160B15F09Df792eFCb395B828d3E55a95] = 1;
1621         whitelistBalance[0xcB748f312b8e0557587862225697AAe325052f7D] = 1;
1622         whitelistBalance[0x18655651F4DFA30dA7E47852265db731C3059E1b] = 2;
1623         whitelistBalance[0x1168a0Ac3f249a011a3A52C662591d6383a91d97] = 1;
1624         whitelistBalance[0x45698cdCC733cBA4f8B1150C2f580587adF1Df92] = 3;
1625         whitelistBalance[0xd3745F1ba3c0280F0Fb3456676dE2Fa714d1fcb7] = 1;
1626         whitelistBalance[0x9DDf691De5e1F4f7764262Be936B61f46d9f9d70] = 1;
1627         whitelistBalance[0x100e4F6D92965C2f2dEc3A08ACeb63A8de69c99D] = 2;
1628         whitelistBalance[0x3E7898c5851635D5212B07F0124a15a2d3C547EB] = 3;
1629         whitelistBalance[0x4e1c52008b0cd3bE1819745695E85Ffe3B9494B0] = 1;
1630         whitelistBalance[0x33494fB9B491B1328c90BE2c926B6A5080AbAfDA] = 4;
1631         whitelistBalance[0xB7D9945166e3DA89ee4c0947230753d656D116a5] = 2;
1632         whitelistBalance[0x403156966d0593770846e72dCBec871F93ef1224] = 6;
1633         whitelistBalance[0x1d4B9b250B1Bd41DAA35d94BF9204Ec1b0494eE3] = 2;
1634         whitelistBalance[0xEbD56361441B416a788086e47F48599593fcFE4F] = 1;
1635         whitelistBalance[0x93EFEC89Db80176895b2C7a4E00aF808BBc69239] = 1;
1636         whitelistBalance[0x2668B4B69c57624B0dc7453250f841B726a456CF] = 1;
1637         whitelistBalance[0x4D010eeB7ec813AE5520D4cC7Bdb975ba2bFd2a1] = 1;
1638         whitelistBalance[0xFF0aD4e2C7F60D2303812Cbc73c20F890b339925] = 1;
1639         whitelistBalance[0x38623FA88e3d8D85945C2512Abf3f001a9edB492] = 1;
1640         whitelistBalance[0xcD61ecC765040389b81dAc23b67B091160E9BF39] = 1;
1641         whitelistBalance[0x20B4E6cAbA712F520D9A3A309D8c0b0DA801a212] = 2;
1642         whitelistBalance[0x84274ff96A1928FEb3c1cC2260f962B377a3d53F] = 1;
1643         whitelistBalance[0x5080A71235d51F1E1F2F7C720810766Dc5FB15C1] = 1;
1644         whitelistBalance[0x4EB4a5718A685c788B650c944834ba574Db508C4] = 1;
1645         whitelistBalance[0x5FE7Ff8Dc6082b6b0812c5A4b23A3B7B40D26747] = 1;
1646         whitelistBalance[0x85C6F217D0375E5dC7b249B5bC12577B051bf417] = 1;
1647         whitelistBalance[0x3a4f4a3B4D965058701f0fb2611Acbc89a11996E] = 1;
1648         whitelistBalance[0x2A76F7Df64889A1f20F5b6Aa87eBfFA9A38AB925] = 1;
1649         whitelistBalance[0x9B24349Ad2e4d0a2dcE6376b75A823D9b0C9774C] = 2;
1650         whitelistBalance[0x4D77536a1B90C30F1fBcaeF8817160f663Da1DE0] = 3;
1651         whitelistBalance[0x1d06ef1CF5059370ecd6bE3A4ACa223fE5973E02] = 1;
1652         whitelistBalance[0xEAfAA1405A1BaC58D2C3dCefe6A07467Bcd7fEbE] = 1;
1653         whitelistBalance[0xc4fF126aEC164409B9c2269D34A79E53C39C8A56] = 5;
1654         whitelistBalance[0xd781a9158edFd5AEA767F5cfC3Db97482C722157] = 1;
1655         whitelistBalance[0x3ddfB199288F7a439dfFEdc03AE9Bc02FaFC63F6] = 1;
1656         whitelistBalance[0x6c66F4cA90c023bc04461ef19e67B06bfC3d0a53] = 1;
1657         whitelistBalance[0x1a60DfB071B039c6e33dcb3220891C83DA72c1be] = 1;
1658         whitelistBalance[0xc72f40a397453051349F73cf2E2a04Fac06E37a3] = 1;
1659         whitelistBalance[0x5689676A2c9C796375e01784F9B42723536Da2B2] = 1;
1660         whitelistBalance[0x1986F4BCc6b78d40e499E928a910DD7bde857734] = 1;
1661         whitelistBalance[0xcB1dAC0C1a5F87dc410a56F0F82E7E3A56bE1499] = 1;
1662         whitelistBalance[0x97e2B1efF9eF076635eB2983702e6b74d1D509B9] = 1;
1663         whitelistBalance[0xa4362e88E1444DF62fC85d15F7eC333f0664442C] = 1;
1664         whitelistBalance[0xB3f6Ea7b8A2ccE43D78d5637D2f0cA2c806439D0] = 1;
1665         whitelistBalance[0x3Eb92F230B33bD8d98cc060A76a7e7d77819a21A] = 3;
1666         whitelistBalance[0xBe769b04627613C8F3b30aBE20E6458c1DCB239B] = 1;
1667         whitelistBalance[0xd6cc8BF1a2bDF94BE558A40B2A665a46c94211B6] = 2;
1668         whitelistBalance[0x110772F7472B56A1aB844051260B9416FE30245b] = 2;
1669         whitelistBalance[0xD41c564db35DA12D9d25944b88Cc22468B0D45DC] = 1;
1670         whitelistBalance[0x34A4Dd196Ab83166c8C9935D5A6f60f2a02a905a] = 1;
1671         whitelistBalance[0x7D602b32acD5942A619f49e104b20C0553c93405] = 2;
1672         whitelistBalance[0x007C9c7e7ed7cD83F1A38cFd747f28E6894ab9f6] = 1;
1673         whitelistBalance[0xbA72224300dD0CCFeF418FEe7865017ABEB876a7] = 2;
1674         whitelistBalance[0x738A1f6d79e592f726efaA3B8beF81797F408119] = 1;
1675         whitelistBalance[0x36E058332aE39efaD2315776B9c844E30d07388B] = 1;
1676         whitelistBalance[0x4a7AFc64E298876FcB8F6AA7D44Ef3C91fCBC291] = 1;
1677         whitelistBalance[0x4D9B5696a8afeD6b65F92B1B86ccf90c7561aE56] = 2;
1678         whitelistBalance[0x0060263198Fe57F4e9eb4B9EE02E1c40cCf6d13E] = 1;
1679         whitelistBalance[0x11e6AA7D1D74Cb4A3056e8943372b94D1127D26c] = 1;
1680         whitelistBalance[0x2C6602c1200F08eb57CC06eaDa1C215cfd7D0b7C] = 1;
1681         whitelistBalance[0xe4A974E499e8767A13894635C45F7389b1FFc5Dd] = 1;
1682         whitelistBalance[0xdcfd6D6e63F15A391D96D1b76575Ae39Ad6965D9] = 4;
1683         whitelistBalance[0x08Cdbd22a584F0fa78474FD1724c664D62C65FD9] = 1;
1684         whitelistBalance[0xcc4b0a5b8De07B69cE5936FBbFeE6BDfb0A30F77] = 1;
1685         whitelistBalance[0x5968d383DeB7636FB68C91915c516499Fa2ddcD0] = 1;
1686         whitelistBalance[0x7eC8676CA6BDDB54455b806B9ef39c6D8ee51766] = 1;
1687         whitelistBalance[0x177580556eD986Cee01012C6115823208Ef584B8] = 1;
1688         whitelistBalance[0xB1af684799C96F5C740786bE59DC834ff8Ef5add] = 1;
1689         whitelistBalance[0x5fFd0B2EB25e29DBf94Ee7cB8F7b90d2b2fbbc53] = 1;
1690         whitelistBalance[0xE3873F3D9E13880f9c508f47cbBF9e065a67265B] = 1;
1691         whitelistBalance[0x322e128453EFd91a4c131761d9d535fF6E0CCd90] = 1;
1692         whitelistBalance[0xB21027569dDaE670aA521Ed90d6ECb5dE515e8d4] = 1;
1693         whitelistBalance[0xd70676Cfa67Abc65A8C39f049d62EEA30E3080CF] = 1;
1694         whitelistBalance[0x8889c07205749DB6d38673f9248d720b0c07955f] = 1;
1695         whitelistBalance[0x004768E08805AB5ece646a65C8Ba492C3AD71E4a] = 1;
1696         whitelistBalance[0xBb739eE04F0cC2Db984cd47EAd003F4c183CF19a] = 1;
1697         whitelistBalance[0xa80e8CB880b7fA0ad1EAa609eDD8f1CDDd21aF42] = 1;
1698         whitelistBalance[0xcA147eb37135B667B14792bc4C3Cc57389F574AA] = 1;
1699         whitelistBalance[0x440d55a1867958dA7C8FD88A5e163a85Fd739eFA] = 1;
1700         whitelistBalance[0xd544CEBA36DEF08e68c56976576AcC974DE54F7b] = 1;
1701         whitelistBalance[0x29f316885886bE6357FC1411478D4C291021A0AA] = 1;
1702         whitelistBalance[0x6634f9d0c6B7fB5764312bD0c91556F51e67E544] = 1;
1703         whitelistBalance[0x7a501E2a432d44013DD9575e73Ed551A88fc0184] = 1;
1704         whitelistBalance[0xBbcd652CF371b59CE9A063183AA44D377f4467E8] = 2;
1705         whitelistBalance[0x2e44F49552C0C8e93f60318520760f619c03615F] = 1;
1706         whitelistBalance[0x86776Ae9783C634C6AEe6cdA878C8f35a5571333] = 1;
1707         whitelistBalance[0xAcDBC51Dd3bbDC46C447E0A2EDaC8A713dEB1907] = 1;
1708         whitelistBalance[0x6D8Df15FD3dC3505a4010CaC6937De159d68081C] = 1;
1709         whitelistBalance[0xd3e9AF5B0C1FC2edD6A7907076cd9C79e67DE6aC] = 1;
1710         whitelistBalance[0x0923A3931599b5B08f91E62b1894053ca75455A9] = 1;
1711         whitelistBalance[0x2168B2295E912A27c0015BaD9F09F090EBcE1a99] = 1;
1712         whitelistBalance[0xF898F063d22a994bA6943D50A96C2dbC0Bd9218c] = 1;
1713         whitelistBalance[0x321f3BFA19354BD9F56CFDA97bcCf3a7C21D1621] = 1;
1714         whitelistBalance[0xbaCD6723bDc567E134603AA35E5c479411477d52] = 1;
1715         whitelistBalance[0x104F0BE994C32231934e64EeF299bC8866288a5f] = 1;
1716         whitelistBalance[0x167AE6231bd8E564F969482bc34A00D91B7Fe37c] = 1;
1717         whitelistBalance[0x646e72181602114e7eE02F963D13539cf056ce1e] = 1;
1718         whitelistBalance[0xF4164FC650e2C59D1580Fc1c2C9E792087865D56] = 1;
1719         whitelistBalance[0xCD546c340b8c0bA679eBbECA1ABB8C2E4528b6E5] = 1;
1720         whitelistBalance[0xcdF660aeEB6DBdDba0C096d1FAfCb41D60f9A88B] = 1;
1721     }
1722 
1723     modifier whenSaleStarted() {
1724         require(_saleStarted);
1725         _;
1726     }
1727 
1728     modifier whenPresaleStarted() {
1729         require(_presaleStarted);
1730         _;
1731     }
1732 
1733     function presaleMint(uint256 amount) external payable whenPresaleStarted {
1734         uint256 preSaleAllowance = whitelistBalance[msg.sender] - whitelistMinted[msg.sender];
1735         require(amount * _price <= msg.value, "Inconsistent amount sent!");
1736         require(preSaleAllowance >= amount, "Address does not own enough nfts from first collection");
1737 
1738         for (uint256 i = 0; i < amount; i++) {
1739             _safeMint(msg.sender, currentMintId);
1740             currentMintId++;
1741             whitelistMinted[msg.sender] = whitelistMinted[msg.sender] + 1;
1742         }
1743 
1744         emit PresaleMinted(msg.sender, amount, msg.value);
1745     }
1746 
1747     function mint(uint256 amount) external payable whenSaleStarted {
1748         require(amount < 3, "You cannot mint more than 2 Tokens at once!");
1749         require(
1750             currentMintId + amount <= maxSupply + 1,
1751             "Not enough Tokens left."
1752         );
1753         require(amount * _price <= msg.value, "Inconsistent amount sent!");
1754 
1755         for (uint256 i = 0; i < amount; i++) {
1756             _safeMint(msg.sender, currentMintId);
1757             currentMintId++;
1758         }
1759         
1760         emit Minted(msg.sender, amount, msg.value);
1761     }
1762 
1763     function togglePresaleStarted() external onlyOwner {
1764         _presaleStarted = !_presaleStarted;
1765     }
1766 
1767     function presaleStarted() public view returns (bool) {
1768         return _presaleStarted;
1769     }
1770 
1771     function toggleSaleStarted() external onlyOwner {
1772         _saleStarted = !_saleStarted;
1773     }
1774 
1775     function saleStarted() public view returns (bool) {
1776         return _saleStarted;
1777     }
1778 
1779     function setBaseURI(string memory _URI) external onlyOwner {
1780         baseURI = _URI;
1781     }
1782 
1783     function _baseURI() internal view override(ERC721) returns (string memory) {
1784         return baseURI;
1785     }
1786 
1787     // Make it possible to change the price: just in case
1788     function setPrice(uint256 _newPrice) external onlyOwner {
1789         _price = _newPrice;
1790     }
1791 
1792     function getPrice() public view returns (uint256) {
1793         return _price;
1794     }
1795 
1796     function getReservedLeft() public view returns (uint256) {
1797         return reservedCount - _reservedClaimed;
1798     }
1799 
1800     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1801         uint256 tokenCount = balanceOf(_owner);
1802 
1803         uint256[] memory tokensId = new uint256[](tokenCount);
1804         for (uint256 i; i < tokenCount; i++) {
1805             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1806         }
1807         return tokensId;
1808     }
1809 
1810     function claimReserved(uint256 _number, address _receiver) external onlyOwner {
1811         require(
1812             _number + _reservedClaimed <= reservedCount,
1813             "That would exceed the max reserved."
1814         );
1815 
1816         for (uint256 i = 0; i < _number; i++) {
1817             _safeMint(_receiver, currentMintId);
1818             currentMintId++;
1819             _reservedClaimed++;
1820         }
1821 
1822         _reservedClaimed = _reservedClaimed + _number;
1823     }
1824 
1825     function withdraw() public onlyOwner {
1826         payable(msg.sender).transfer(address(this).balance);
1827     }
1828 
1829     function _beforeTokenTransfer(
1830         address from,
1831         address to,
1832         uint256 tokenId
1833     ) internal override(ERC721, ERC721Enumerable) {
1834         super._beforeTokenTransfer(from, to, tokenId);
1835     }
1836 
1837     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1838         return super.supportsInterface(interfaceId);
1839     }
1840     
1841     function updateWhitelistAllowance(address newAddress, uint256 amount) public onlyOwner {
1842         whitelistBalance[newAddress] = amount;
1843     }
1844     
1845     function getWhitelistAllowance(address userAddress) public  view  returns (uint256)  {
1846         return whitelistBalance[userAddress];
1847     } 
1848     
1849     function getPresaleAllowance(address userAddress) public view returns (uint256) {
1850         return whitelistBalance[userAddress] - whitelistMinted[userAddress];
1851     }
1852     
1853     function getTokensRemaining () public view returns (uint256) {
1854         return maxSupply - currentMintId + 1;
1855     }
1856 }