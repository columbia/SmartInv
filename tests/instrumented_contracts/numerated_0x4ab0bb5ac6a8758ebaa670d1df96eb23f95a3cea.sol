1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/math/SafeMath.sol
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
230 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/Strings.sol
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
299 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/Context.sol
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
325 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/access/Ownable.sol
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
398 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/Address.sol
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
617 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/token/ERC721/IERC721Receiver.sol
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
646 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/introspection/IERC165.sol
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
673 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/introspection/ERC165.sol
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
703 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/token/ERC721/IERC721.sol
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
847 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/token/ERC721/extensions/IERC721Metadata.sol
848 
849 
850 
851 pragma solidity ^0.8.0;
852 
853 
854 /**
855  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
856  * @dev See https://eips.ethereum.org/EIPS/eip-721
857  */
858 interface IERC721Metadata is IERC721 {
859     /**
860      * @dev Returns the token collection name.
861      */
862     function name() external view returns (string memory);
863 
864     /**
865      * @dev Returns the token collection symbol.
866      */
867     function symbol() external view returns (string memory);
868 
869     /**
870      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
871      */
872     function tokenURI(uint256 tokenId) external view returns (string memory);
873 }
874 
875 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/token/ERC721/ERC721.sol
876 
877 
878 
879 pragma solidity ^0.8.0;
880 
881 
882 
883 
884 
885 
886 
887 
888 /**
889  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
890  * the Metadata extension, but not including the Enumerable extension, which is available separately as
891  * {ERC721Enumerable}.
892  */
893 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
894     using Address for address;
895     using Strings for uint256;
896 
897     // Token name
898     string private _name;
899 
900     // Token symbol
901     string private _symbol;
902 
903     // Mapping from token ID to owner address
904     mapping(uint256 => address) private _owners;
905 
906     // Mapping owner address to token count
907     mapping(address => uint256) private _balances;
908 
909     // Mapping from token ID to approved address
910     mapping(uint256 => address) private _tokenApprovals;
911 
912     // Mapping from owner to operator approvals
913     mapping(address => mapping(address => bool)) private _operatorApprovals;
914 
915     /**
916      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
917      */
918     constructor(string memory name_, string memory symbol_) {
919         _name = name_;
920         _symbol = symbol_;
921     }
922 
923     /**
924      * @dev See {IERC165-supportsInterface}.
925      */
926     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
927         return
928             interfaceId == type(IERC721).interfaceId ||
929             interfaceId == type(IERC721Metadata).interfaceId ||
930             super.supportsInterface(interfaceId);
931     }
932 
933     /**
934      * @dev See {IERC721-balanceOf}.
935      */
936     function balanceOf(address owner) public view virtual override returns (uint256) {
937         require(owner != address(0), "ERC721: balance query for the zero address");
938         return _balances[owner];
939     }
940 
941     /**
942      * @dev See {IERC721-ownerOf}.
943      */
944     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
945         address owner = _owners[tokenId];
946         require(owner != address(0), "ERC721: owner query for nonexistent token");
947         return owner;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-name}.
952      */
953     function name() public view virtual override returns (string memory) {
954         return _name;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-symbol}.
959      */
960     function symbol() public view virtual override returns (string memory) {
961         return _symbol;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-tokenURI}.
966      */
967     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
968         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
969 
970         string memory baseURI = _baseURI();
971         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
972     }
973 
974     /**
975      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
976      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
977      * by default, can be overriden in child contracts.
978      */
979     function _baseURI() internal view virtual returns (string memory) {
980         return "";
981     }
982 
983     /**
984      * @dev See {IERC721-approve}.
985      */
986     function approve(address to, uint256 tokenId) public virtual override {
987         address owner = ERC721.ownerOf(tokenId);
988         require(to != owner, "ERC721: approval to current owner");
989 
990         require(
991             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
992             "ERC721: approve caller is not owner nor approved for all"
993         );
994 
995         _approve(to, tokenId);
996     }
997 
998     /**
999      * @dev See {IERC721-getApproved}.
1000      */
1001     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1002         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1003 
1004         return _tokenApprovals[tokenId];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-setApprovalForAll}.
1009      */
1010     function setApprovalForAll(address operator, bool approved) public virtual override {
1011         require(operator != _msgSender(), "ERC721: approve to caller");
1012 
1013         _operatorApprovals[_msgSender()][operator] = approved;
1014         emit ApprovalForAll(_msgSender(), operator, approved);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-isApprovedForAll}.
1019      */
1020     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1021         return _operatorApprovals[owner][operator];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-transferFrom}.
1026      */
1027     function transferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         //solhint-disable-next-line max-line-length
1033         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1034 
1035         _transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         safeTransferFrom(from, to, tokenId, "");
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) public virtual override {
1058         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1059         _safeTransfer(from, to, tokenId, _data);
1060     }
1061 
1062     /**
1063      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1064      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1065      *
1066      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1067      *
1068      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1069      * implement alternative mechanisms to perform token transfer, such as signature-based.
1070      *
1071      * Requirements:
1072      *
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must exist and be owned by `from`.
1076      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeTransfer(
1081         address from,
1082         address to,
1083         uint256 tokenId,
1084         bytes memory _data
1085     ) internal virtual {
1086         _transfer(from, to, tokenId);
1087         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1088     }
1089 
1090     /**
1091      * @dev Returns whether `tokenId` exists.
1092      *
1093      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1094      *
1095      * Tokens start existing when they are minted (`_mint`),
1096      * and stop existing when they are burned (`_burn`).
1097      */
1098     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1099         return _owners[tokenId] != address(0);
1100     }
1101 
1102     /**
1103      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      */
1109     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1110         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1111         address owner = ERC721.ownerOf(tokenId);
1112         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1113     }
1114 
1115     /**
1116      * @dev Safely mints `tokenId` and transfers it to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must not exist.
1121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _safeMint(address to, uint256 tokenId) internal virtual {
1126         _safeMint(to, tokenId, "");
1127     }
1128 
1129     /**
1130      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1131      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1132      */
1133     function _safeMint(
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) internal virtual {
1138         _mint(to, tokenId);
1139         require(
1140             _checkOnERC721Received(address(0), to, tokenId, _data),
1141             "ERC721: transfer to non ERC721Receiver implementer"
1142         );
1143     }
1144 
1145     /**
1146      * @dev Mints `tokenId` and transfers it to `to`.
1147      *
1148      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1149      *
1150      * Requirements:
1151      *
1152      * - `tokenId` must not exist.
1153      * - `to` cannot be the zero address.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _mint(address to, uint256 tokenId) internal virtual {
1158         require(to != address(0), "ERC721: mint to the zero address");
1159         require(!_exists(tokenId), "ERC721: token already minted");
1160 
1161         _beforeTokenTransfer(address(0), to, tokenId);
1162 
1163         _balances[to] += 1;
1164         _owners[tokenId] = to;
1165 
1166         emit Transfer(address(0), to, tokenId);
1167     }
1168 
1169     /**
1170      * @dev Destroys `tokenId`.
1171      * The approval is cleared when the token is burned.
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must exist.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _burn(uint256 tokenId) internal virtual {
1180         address owner = ERC721.ownerOf(tokenId);
1181 
1182         _beforeTokenTransfer(owner, address(0), tokenId);
1183 
1184         // Clear approvals
1185         _approve(address(0), tokenId);
1186 
1187         _balances[owner] -= 1;
1188         delete _owners[tokenId];
1189 
1190         emit Transfer(owner, address(0), tokenId);
1191     }
1192 
1193     /**
1194      * @dev Transfers `tokenId` from `from` to `to`.
1195      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1196      *
1197      * Requirements:
1198      *
1199      * - `to` cannot be the zero address.
1200      * - `tokenId` token must be owned by `from`.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _transfer(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) internal virtual {
1209         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1210         require(to != address(0), "ERC721: transfer to the zero address");
1211 
1212         _beforeTokenTransfer(from, to, tokenId);
1213 
1214         // Clear approvals from the previous owner
1215         _approve(address(0), tokenId);
1216 
1217         _balances[from] -= 1;
1218         _balances[to] += 1;
1219         _owners[tokenId] = to;
1220 
1221         emit Transfer(from, to, tokenId);
1222     }
1223 
1224     /**
1225      * @dev Approve `to` to operate on `tokenId`
1226      *
1227      * Emits a {Approval} event.
1228      */
1229     function _approve(address to, uint256 tokenId) internal virtual {
1230         _tokenApprovals[tokenId] = to;
1231         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1236      * The call is not executed if the target address is not a contract.
1237      *
1238      * @param from address representing the previous owner of the given token ID
1239      * @param to target address that will receive the tokens
1240      * @param tokenId uint256 ID of the token to be transferred
1241      * @param _data bytes optional data to send along with the call
1242      * @return bool whether the call correctly returned the expected magic value
1243      */
1244     function _checkOnERC721Received(
1245         address from,
1246         address to,
1247         uint256 tokenId,
1248         bytes memory _data
1249     ) private returns (bool) {
1250         if (to.isContract()) {
1251             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1252                 return retval == IERC721Receiver.onERC721Received.selector;
1253             } catch (bytes memory reason) {
1254                 if (reason.length == 0) {
1255                     revert("ERC721: transfer to non ERC721Receiver implementer");
1256                 } else {
1257                     assembly {
1258                         revert(add(32, reason), mload(reason))
1259                     }
1260                 }
1261             }
1262         } else {
1263             return true;
1264         }
1265     }
1266 
1267     /**
1268      * @dev Hook that is called before any token transfer. This includes minting
1269      * and burning.
1270      *
1271      * Calling conditions:
1272      *
1273      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1274      * transferred to `to`.
1275      * - When `from` is zero, `tokenId` will be minted for `to`.
1276      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1277      * - `from` and `to` are never both zero.
1278      *
1279      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1280      */
1281     function _beforeTokenTransfer(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) internal virtual {}
1286 }
1287 
1288 // File: contracts/PunkBatz.sol
1289 
1290 
1291 pragma solidity ^0.8.8;
1292 
1293 contract PunkBatz is Ownable, ERC721 {
1294     using SafeMath for uint256;
1295 
1296   uint public constant supplyLimit = 2999;
1297   uint256 public totalSupply;
1298   bool public publicSaleActive = true;
1299   string public baseURI;
1300   uint public maxPerTransaction = 10; //Max per transaction
1301   uint256 public tokenPrice = 49000000000000000;
1302 
1303   constructor(string memory name, string memory symbol, string memory baseURIinput)
1304     ERC721(name, symbol)
1305   {
1306       baseURI = baseURIinput;
1307   }
1308 
1309   function _baseURI() internal view override returns (string memory) {
1310     return baseURI;
1311   }
1312 
1313   function setBaseURI(string calldata newBaseUri) external onlyOwner {
1314     baseURI = newBaseUri;
1315   }
1316 
1317   function togglePublicSaleActive() external onlyOwner {
1318     publicSaleActive = !publicSaleActive;
1319   }
1320 
1321   function freeMint(uint256 numberOfTokens) public {
1322     require(totalSupply <= 2500, "free supply reached");
1323     require(publicSaleActive == true, "Sale is Paused.");
1324     require(numberOfTokens <= maxPerTransaction, "invalid token count");
1325 
1326     uint256 newId = totalSupply;
1327 
1328         for (uint i = 0; i < numberOfTokens; i++) {
1329         newId+=1;
1330         _safeMint(msg.sender, newId);
1331         }
1332     
1333     totalSupply = newId;
1334   }
1335 
1336   function buy(uint _count) public payable{
1337     require(_count <= maxPerTransaction, "invalid token count");
1338     require(tokenPrice.mul(_count) <= msg.value,"Ether value sent is not correct");
1339     require(publicSaleActive == true, "Sale is Paused.");
1340     require((totalSupply + _count) <= supplyLimit, "supply reached");
1341 
1342     uint256 newId = totalSupply;
1343 
1344         for(uint i = 0; i < _count; i++){
1345             newId+=1;
1346             _safeMint(msg.sender, newId);
1347         }
1348 
1349     totalSupply = newId;
1350     }
1351 
1352   function changePrice(uint256 newPrice) public onlyOwner {
1353         tokenPrice = newPrice;
1354     }
1355 
1356   function withdraw() public onlyOwner {
1357         uint256 balance = address(this).balance;
1358         payable(msg.sender).transfer(balance);
1359     }
1360 }