1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-28
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0
6 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 // CAUTION
14 // This version of SafeMath should only be used with Solidity 0.8 or later,
15 // because it relies on the compiler's built in overflow checks.
16 
17 /**
18  * @dev Wrappers over Solidity's arithmetic operations.
19  *
20  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
21  * now has built in overflow checking.
22  */
23 library SafeMath {
24     /**
25      * @dev Returns the addition of two unsigned integers, with an overflow flag.
26      *
27      * _Available since v3.4._
28      */
29     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {
31             uint256 c = a + b;
32             if (c < a) return (false, 0);
33             return (true, c);
34         }
35     }
36 
37     /**
38      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
39      *
40      * _Available since v3.4._
41      */
42     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {
44             if (b > a) return (false, 0);
45             return (true, a - b);
46         }
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
57             // benefit is lost if 'b' is also tested.
58             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
59             if (a == 0) return (true, 0);
60             uint256 c = a * b;
61             if (c / a != b) return (false, 0);
62             return (true, c);
63         }
64     }
65 
66     /**
67      * @dev Returns the division of two unsigned integers, with a division by zero flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         unchecked {
73             if (b == 0) return (false, 0);
74             return (true, a / b);
75         }
76     }
77 
78     /**
79      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
80      *
81      * _Available since v3.4._
82      */
83     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
84         unchecked {
85             if (b == 0) return (false, 0);
86             return (true, a % b);
87         }
88     }
89 
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      *
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         return a + b;
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, reverting on
106      * overflow (when the result is negative).
107      *
108      * Counterpart to Solidity's `-` operator.
109      *
110      * Requirements:
111      *
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return a - b;
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `*` operator.
123      *
124      * Requirements:
125      *
126      * - Multiplication cannot overflow.
127      */
128     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129         return a * b;
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers, reverting on
134      * division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator.
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function div(uint256 a, uint256 b) internal pure returns (uint256) {
143         return a / b;
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * reverting when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a % b;
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * CAUTION: This function is deprecated because it requires allocating memory for the error
167      * message unnecessarily. For custom revert reasons use {trySub}.
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      *
173      * - Subtraction cannot overflow.
174      */
175     function sub(
176         uint256 a,
177         uint256 b,
178         string memory errorMessage
179     ) internal pure returns (uint256) {
180         unchecked {
181             require(b <= a, errorMessage);
182             return a - b;
183         }
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(
199         uint256 a,
200         uint256 b,
201         string memory errorMessage
202     ) internal pure returns (uint256) {
203         unchecked {
204             require(b > 0, errorMessage);
205             return a / b;
206         }
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * reverting with custom message when dividing by zero.
212      *
213      * CAUTION: This function is deprecated because it requires allocating memory for the error
214      * message unnecessarily. For custom revert reasons use {tryMod}.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(
225         uint256 a,
226         uint256 b,
227         string memory errorMessage
228     ) internal pure returns (uint256) {
229         unchecked {
230             require(b > 0, errorMessage);
231             return a % b;
232         }
233     }
234 }
235 
236 // File: @openzeppelin/contracts/utils/Strings.sol
237 
238 
239 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev String operations.
245  */
246 library Strings {
247     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
248 
249     /**
250      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
251      */
252     function toString(uint256 value) internal pure returns (string memory) {
253         // Inspired by OraclizeAPI's implementation - MIT licence
254         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
255 
256         if (value == 0) {
257             return "0";
258         }
259         uint256 temp = value;
260         uint256 digits;
261         while (temp != 0) {
262             digits++;
263             temp /= 10;
264         }
265         bytes memory buffer = new bytes(digits);
266         while (value != 0) {
267             digits -= 1;
268             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
269             value /= 10;
270         }
271         return string(buffer);
272     }
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
276      */
277     function toHexString(uint256 value) internal pure returns (string memory) {
278         if (value == 0) {
279             return "0x00";
280         }
281         uint256 temp = value;
282         uint256 length = 0;
283         while (temp != 0) {
284             length++;
285             temp >>= 8;
286         }
287         return toHexString(value, length);
288     }
289 
290     /**
291      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
292      */
293     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
294         bytes memory buffer = new bytes(2 * length + 2);
295         buffer[0] = "0";
296         buffer[1] = "x";
297         for (uint256 i = 2 * length + 1; i > 1; --i) {
298             buffer[i] = _HEX_SYMBOLS[value & 0xf];
299             value >>= 4;
300         }
301         require(value == 0, "Strings: hex length insufficient");
302         return string(buffer);
303     }
304 }
305 
306 // File: @openzeppelin/contracts/utils/Context.sol
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Provides information about the current execution context, including the
315  * sender of the transaction and its data. While these are generally available
316  * via msg.sender and msg.data, they should not be accessed in such a direct
317  * manner, since when dealing with meta-transactions the account sending and
318  * paying for execution may not be the actual sender (as far as an application
319  * is concerned).
320  *
321  * This contract is only required for intermediate, library-like contracts.
322  */
323 abstract contract Context {
324     function _msgSender() internal view virtual returns (address) {
325         return msg.sender;
326     }
327 
328     function _msgData() internal view virtual returns (bytes calldata) {
329         return msg.data;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/access/Ownable.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Contract module which provides a basic access control mechanism, where
343  * there is an account (an owner) that can be granted exclusive access to
344  * specific functions.
345  *
346  * By default, the owner account will be the one that deploys the contract. This
347  * can later be changed with {transferOwnership}.
348  *
349  * This module is used through inheritance. It will make available the modifier
350  * `onlyOwner`, which can be applied to your functions to restrict their use to
351  * the owner.
352  */
353 abstract contract Ownable is Context {
354     address private _owner;
355 
356     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
357 
358     /**
359      * @dev Initializes the contract setting the deployer as the initial owner.
360      */
361     constructor() {
362         _transferOwnership(_msgSender());
363     }
364 
365     /**
366      * @dev Returns the address of the current owner.
367      */
368     function owner() public view virtual returns (address) {
369         return _owner;
370     }
371 
372     /**
373      * @dev Throws if called by any account other than the owner.
374      */
375     modifier onlyOwner() {
376         require(owner() == _msgSender(), "Ownable: caller is not the owner");
377         _;
378     }
379 
380     /**
381      * @dev Leaves the contract without owner. It will not be possible to call
382      * `onlyOwner` functions anymore. Can only be called by the current owner.
383      *
384      * NOTE: Renouncing ownership will leave the contract without an owner,
385      * thereby removing any functionality that is only available to the owner.
386      */
387     function renounceOwnership() public virtual onlyOwner {
388         _transferOwnership(address(0));
389     }
390 
391     /**
392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
393      * Can only be called by the current owner.
394      */
395     function transferOwnership(address newOwner) public virtual onlyOwner {
396         require(newOwner != address(0), "Ownable: new owner is the zero address");
397         _transferOwnership(newOwner);
398     }
399 
400     /**
401      * @dev Transfers ownership of the contract to a new account (`newOwner`).
402      * Internal function without access restriction.
403      */
404     function _transferOwnership(address newOwner) internal virtual {
405         address oldOwner = _owner;
406         _owner = newOwner;
407         emit OwnershipTransferred(oldOwner, newOwner);
408     }
409 }
410 
411 // File: @openzeppelin/contracts/utils/Address.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
415 
416 pragma solidity ^0.8.1;
417 
418 /**
419  * @dev Collection of functions related to the address type
420  */
421 library Address {
422     /**
423      * @dev Returns true if `account` is a contract.
424      *
425      * [IMPORTANT]
426      * ====
427      * It is unsafe to assume that an address for which this function returns
428      * false is an externally-owned account (EOA) and not a contract.
429      *
430      * Among others, `isContract` will return false for the following
431      * types of addresses:
432      *
433      *  - an externally-owned account
434      *  - a contract in construction
435      *  - an address where a contract will be created
436      *  - an address where a contract lived, but was destroyed
437      * ====
438      *
439      * [IMPORTANT]
440      * ====
441      * You shouldn't rely on `isContract` to protect against flash loan attacks!
442      *
443      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
444      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
445      * constructor.
446      * ====
447      */
448     function isContract(address account) internal view returns (bool) {
449         // This method relies on extcodesize/address.code.length, which returns 0
450         // for contracts in construction, since the code is only stored at the end
451         // of the constructor execution.
452 
453         return account.code.length > 0;
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      */
472     function sendValue(address payable recipient, uint256 amount) internal {
473         require(address(this).balance >= amount, "Address: insufficient balance");
474 
475         (bool success, ) = recipient.call{value: amount}("");
476         require(success, "Address: unable to send value, recipient may have reverted");
477     }
478 
479     /**
480      * @dev Performs a Solidity function call using a low level `call`. A
481      * plain `call` is an unsafe replacement for a function call: use this
482      * function instead.
483      *
484      * If `target` reverts with a revert reason, it is bubbled up by this
485      * function (like regular Solidity function calls).
486      *
487      * Returns the raw returned data. To convert to the expected return value,
488      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
489      *
490      * Requirements:
491      *
492      * - `target` must be a contract.
493      * - calling `target` with `data` must not revert.
494      *
495      * _Available since v3.1._
496      */
497     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
498         return functionCall(target, data, "Address: low-level call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
503      * `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, 0, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but also transferring `value` wei to `target`.
518      *
519      * Requirements:
520      *
521      * - the calling contract must have an ETH balance of at least `value`.
522      * - the called Solidity function must be `payable`.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
536      * with `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCallWithValue(
541         address target,
542         bytes memory data,
543         uint256 value,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(address(this).balance >= value, "Address: insufficient balance for call");
547         require(isContract(target), "Address: call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.call{value: value}(data);
550         return verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a static call.
556      *
557      * _Available since v3.3._
558      */
559     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
560         return functionStaticCall(target, data, "Address: low-level static call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal view returns (bytes memory) {
574         require(isContract(target), "Address: static call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.staticcall(data);
577         return verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a delegate call.
583      *
584      * _Available since v3.4._
585      */
586     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
587         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a delegate call.
593      *
594      * _Available since v3.4._
595      */
596     function functionDelegateCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal returns (bytes memory) {
601         require(isContract(target), "Address: delegate call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.delegatecall(data);
604         return verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
609      * revert reason using the provided one.
610      *
611      * _Available since v4.3._
612      */
613     function verifyCallResult(
614         bool success,
615         bytes memory returndata,
616         string memory errorMessage
617     ) internal pure returns (bytes memory) {
618         if (success) {
619             return returndata;
620         } else {
621             // Look for revert reason and bubble it up if present
622             if (returndata.length > 0) {
623                 // The easiest way to bubble the revert reason is using memory via assembly
624 
625                 assembly {
626                     let returndata_size := mload(returndata)
627                     revert(add(32, returndata), returndata_size)
628                 }
629             } else {
630                 revert(errorMessage);
631             }
632         }
633     }
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @title ERC721 token receiver interface
645  * @dev Interface for any contract that wants to support safeTransfers
646  * from ERC721 asset contracts.
647  */
648 interface IERC721Receiver {
649     /**
650      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
651      * by `operator` from `from`, this function is called.
652      *
653      * It must return its Solidity selector to confirm the token transfer.
654      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
655      *
656      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
657      */
658     function onERC721Received(
659         address operator,
660         address from,
661         uint256 tokenId,
662         bytes calldata data
663     ) external returns (bytes4);
664 }
665 
666 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Interface of the ERC165 standard, as defined in the
675  * https://eips.ethereum.org/EIPS/eip-165[EIP].
676  *
677  * Implementers can declare support of contract interfaces, which can then be
678  * queried by others ({ERC165Checker}).
679  *
680  * For an implementation, see {ERC165}.
681  */
682 interface IERC165 {
683     /**
684      * @dev Returns true if this contract implements the interface defined by
685      * `interfaceId`. See the corresponding
686      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
687      * to learn more about how these ids are created.
688      *
689      * This function call must use less than 30 000 gas.
690      */
691     function supportsInterface(bytes4 interfaceId) external view returns (bool);
692 }
693 
694 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 
702 /**
703  * @dev Implementation of the {IERC165} interface.
704  *
705  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
706  * for the additional interface id that will be supported. For example:
707  *
708  * ```solidity
709  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
710  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
711  * }
712  * ```
713  *
714  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
715  */
716 abstract contract ERC165 is IERC165 {
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
721         return interfaceId == type(IERC165).interfaceId;
722     }
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
726 
727 
728 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 
733 /**
734  * @dev Required interface of an ERC721 compliant contract.
735  */
736 interface IERC721 is IERC165 {
737     /**
738      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
739      */
740     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
741 
742     /**
743      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
744      */
745     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
746 
747     /**
748      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
749      */
750     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
751 
752     /**
753      * @dev Returns the number of tokens in ``owner``'s account.
754      */
755     function balanceOf(address owner) external view returns (uint256 balance);
756 
757     /**
758      * @dev Returns the owner of the `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function ownerOf(uint256 tokenId) external view returns (address owner);
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
768      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must exist and be owned by `from`.
775      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId
784     ) external;
785 
786     /**
787      * @dev Transfers `tokenId` token from `from` to `to`.
788      *
789      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must be owned by `from`.
796      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
797      *
798      * Emits a {Transfer} event.
799      */
800     function transferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external;
805 
806     /**
807      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
808      * The approval is cleared when the token is transferred.
809      *
810      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
811      *
812      * Requirements:
813      *
814      * - The caller must own the token or be an approved operator.
815      * - `tokenId` must exist.
816      *
817      * Emits an {Approval} event.
818      */
819     function approve(address to, uint256 tokenId) external;
820 
821     /**
822      * @dev Returns the account approved for `tokenId` token.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      */
828     function getApproved(uint256 tokenId) external view returns (address operator);
829 
830     /**
831      * @dev Approve or remove `operator` as an operator for the caller.
832      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
833      *
834      * Requirements:
835      *
836      * - The `operator` cannot be the caller.
837      *
838      * Emits an {ApprovalForAll} event.
839      */
840     function setApprovalForAll(address operator, bool _approved) external;
841 
842     /**
843      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
844      *
845      * See {setApprovalForAll}
846      */
847     function isApprovedForAll(address owner, address operator) external view returns (bool);
848 
849     /**
850      * @dev Safely transfers `tokenId` token from `from` to `to`.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must exist and be owned by `from`.
857      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859      *
860      * Emits a {Transfer} event.
861      */
862     function safeTransferFrom(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes calldata data
867     ) external;
868 }
869 
870 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
871 
872 
873 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
874 
875 pragma solidity ^0.8.0;
876 
877 
878 /**
879  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
880  * @dev See https://eips.ethereum.org/EIPS/eip-721
881  */
882 interface IERC721Enumerable is IERC721 {
883     /**
884      * @dev Returns the total amount of tokens stored by the contract.
885      */
886     function totalSupply() external view returns (uint256);
887 
888     /**
889      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
890      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
891      */
892     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
893 
894     /**
895      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
896      * Use along with {totalSupply} to enumerate all tokens.
897      */
898     function tokenByIndex(uint256 index) external view returns (uint256);
899 }
900 
901 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
902 
903 
904 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
905 
906 pragma solidity ^0.8.0;
907 
908 
909 /**
910  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
911  * @dev See https://eips.ethereum.org/EIPS/eip-721
912  */
913 interface IERC721Metadata is IERC721 {
914     /**
915      * @dev Returns the token collection name.
916      */
917     function name() external view returns (string memory);
918 
919     /**
920      * @dev Returns the token collection symbol.
921      */
922     function symbol() external view returns (string memory);
923 
924     /**
925      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
926      */
927     function tokenURI(uint256 tokenId) external view returns (string memory);
928 }
929 
930 // File: contracts/ERC721A.sol
931 
932 
933 
934 pragma solidity ^0.8.10;
935 
936 
937 
938 
939 
940 
941 
942 
943 
944 /**
945  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
946  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
947  *
948  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
949  *
950  * Does not support burning tokens to address(0).
951  */
952 contract ERC721A is
953   Context,
954   ERC165,
955   IERC721,
956   IERC721Metadata,
957   IERC721Enumerable
958 {
959   using Address for address;
960   using Strings for uint256;
961 
962   struct TokenOwnership {
963     address addr;
964     uint64 startTimestamp;
965   }
966 
967   struct AddressData {
968     uint128 balance;
969     uint128 numberMinted;
970   }
971 
972   uint256 private currentIndex = 1;
973 
974   uint256 public immutable maxBatchSize;
975 
976   // Token name
977   string private _name;
978 
979   // Token symbol
980   string private _symbol;
981 
982   // Mapping from token ID to ownership details
983   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
984   mapping(uint256 => TokenOwnership) private _ownerships;
985 
986   // Mapping owner address to address data
987   mapping(address => AddressData) private _addressData;
988 
989   // Mapping from token ID to approved address
990   mapping(uint256 => address) private _tokenApprovals;
991 
992   // Mapping from owner to operator approvals
993   mapping(address => mapping(address => bool)) private _operatorApprovals;
994 
995   /**
996    * @dev
997    * `maxBatchSize` refers to how much a minter can mint at a time.
998    */
999   constructor(
1000     string memory name_,
1001     string memory symbol_,
1002     uint256 maxBatchSize_
1003   ) {
1004     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1005     _name = name_;
1006     _symbol = symbol_;
1007     maxBatchSize = maxBatchSize_;
1008   }
1009 
1010   /**
1011    * @dev See {IERC721Enumerable-totalSupply}.
1012    */
1013   function totalSupply() public view override returns (uint256) {
1014     return currentIndex - 1;
1015   }
1016 
1017   /**
1018    * @dev See {IERC721Enumerable-tokenByIndex}.
1019    */
1020   function tokenByIndex(uint256 index) public view override returns (uint256) {
1021     require(index < totalSupply(), "ERC721A: global index out of bounds");
1022     return index;
1023   }
1024 
1025   /**
1026    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1027    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1028    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1029    */
1030   function tokenOfOwnerByIndex(address owner, uint256 index)
1031     public
1032     view
1033     override
1034     returns (uint256)
1035   {
1036     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1037     uint256 numMintedSoFar = totalSupply();
1038     uint256 tokenIdsIdx = 0;
1039     address currOwnershipAddr = address(0);
1040     for (uint256 i = 0; i < numMintedSoFar; i++) {
1041       TokenOwnership memory ownership = _ownerships[i];
1042       if (ownership.addr != address(0)) {
1043         currOwnershipAddr = ownership.addr;
1044       }
1045       if (currOwnershipAddr == owner) {
1046         if (tokenIdsIdx == index) {
1047           return i;
1048         }
1049         tokenIdsIdx++;
1050       }
1051     }
1052     revert("ERC721A: unable to get token of owner by index");
1053   }
1054 
1055   /**
1056    * @dev See {IERC165-supportsInterface}.
1057    */
1058   function supportsInterface(bytes4 interfaceId)
1059     public
1060     view
1061     virtual
1062     override(ERC165, IERC165)
1063     returns (bool)
1064   {
1065     return
1066       interfaceId == type(IERC721).interfaceId ||
1067       interfaceId == type(IERC721Metadata).interfaceId ||
1068       interfaceId == type(IERC721Enumerable).interfaceId ||
1069       super.supportsInterface(interfaceId);
1070   }
1071 
1072   /**
1073    * @dev See {IERC721-balanceOf}.
1074    */
1075   function balanceOf(address owner) public view override returns (uint256) {
1076     require(owner != address(0), "ERC721A: balance query for the zero address");
1077     return uint256(_addressData[owner].balance);
1078   }
1079 
1080   function _numberMinted(address owner) internal view returns (uint256) {
1081     require(
1082       owner != address(0),
1083       "ERC721A: number minted query for the zero address"
1084     );
1085     return uint256(_addressData[owner].numberMinted);
1086   }
1087 
1088   function ownershipOf(uint256 tokenId)
1089     internal
1090     view
1091     returns (TokenOwnership memory)
1092   {
1093     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1094 
1095     uint256 lowestTokenToCheck;
1096     if (tokenId >= maxBatchSize) {
1097       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1098     }
1099 
1100     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1101       TokenOwnership memory ownership = _ownerships[curr];
1102       if (ownership.addr != address(0)) {
1103         return ownership;
1104       }
1105     }
1106 
1107     revert("ERC721A: unable to determine the owner of token");
1108   }
1109 
1110   /**
1111    * @dev See {IERC721-ownerOf}.
1112    */
1113   function ownerOf(uint256 tokenId) public view override returns (address) {
1114     return ownershipOf(tokenId).addr;
1115   }
1116 
1117   /**
1118    * @dev See {IERC721Metadata-name}.
1119    */
1120   function name() public view virtual override returns (string memory) {
1121     return _name;
1122   }
1123 
1124   /**
1125    * @dev See {IERC721Metadata-symbol}.
1126    */
1127   function symbol() public view virtual override returns (string memory) {
1128     return _symbol;
1129   }
1130 
1131   /**
1132    * @dev See {IERC721Metadata-tokenURI}.
1133    */
1134   function tokenURI(uint256 tokenId)
1135     public
1136     view
1137     virtual
1138     override
1139     returns (string memory)
1140   {
1141     require(
1142       _exists(tokenId),
1143       "ERC721Metadata: URI query for nonexistent token"
1144     );
1145 
1146     string memory baseURI = _baseURI();
1147     return
1148       bytes(baseURI).length > 0
1149         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1150         : "";
1151   }
1152 
1153   /**
1154    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1155    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1156    * by default, can be overriden in child contracts.
1157    */
1158   function _baseURI() internal view virtual returns (string memory) {
1159     return "";
1160   }
1161 
1162   /**
1163    * @dev See {IERC721-approve}.
1164    */
1165   function approve(address to, uint256 tokenId) public override {
1166     address owner = ERC721A.ownerOf(tokenId);
1167     require(to != owner, "ERC721A: approval to current owner");
1168 
1169     require(
1170       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1171       "ERC721A: approve caller is not owner nor approved for all"
1172     );
1173 
1174     _approve(to, tokenId, owner);
1175   }
1176 
1177   /**
1178    * @dev See {IERC721-getApproved}.
1179    */
1180   function getApproved(uint256 tokenId) public view override returns (address) {
1181     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1182 
1183     return _tokenApprovals[tokenId];
1184   }
1185 
1186   /**
1187    * @dev See {IERC721-setApprovalForAll}.
1188    */
1189   function setApprovalForAll(address operator, bool approved) public override {
1190     require(operator != _msgSender(), "ERC721A: approve to caller");
1191 
1192     _operatorApprovals[_msgSender()][operator] = approved;
1193     emit ApprovalForAll(_msgSender(), operator, approved);
1194   }
1195 
1196   /**
1197    * @dev See {IERC721-isApprovedForAll}.
1198    */
1199   function isApprovedForAll(address owner, address operator)
1200     public
1201     view
1202     virtual
1203     override
1204     returns (bool)
1205   {
1206     return _operatorApprovals[owner][operator];
1207   }
1208 
1209   /**
1210    * @dev See {IERC721-transferFrom}.
1211    */
1212   function transferFrom(
1213     address from,
1214     address to,
1215     uint256 tokenId
1216   ) public override {
1217     _transfer(from, to, tokenId);
1218   }
1219 
1220   /**
1221    * @dev See {IERC721-safeTransferFrom}.
1222    */
1223   function safeTransferFrom(
1224     address from,
1225     address to,
1226     uint256 tokenId
1227   ) public override {
1228     safeTransferFrom(from, to, tokenId, "");
1229   }
1230 
1231   /**
1232    * @dev See {IERC721-safeTransferFrom}.
1233    */
1234   function safeTransferFrom(
1235     address from,
1236     address to,
1237     uint256 tokenId,
1238     bytes memory _data
1239   ) public override {
1240     _transfer(from, to, tokenId);
1241     require(
1242       _checkOnERC721Received(from, to, tokenId, _data),
1243       "ERC721A: transfer to non ERC721Receiver implementer"
1244     );
1245   }
1246 
1247   /**
1248    * @dev Returns whether `tokenId` exists.
1249    *
1250    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1251    *
1252    * Tokens start existing when they are minted (`_mint`),
1253    */
1254   function _exists(uint256 tokenId) internal view returns (bool) {
1255     return tokenId < currentIndex;
1256   }
1257 
1258   function _safeMint(address to, uint256 quantity) internal {
1259     _safeMint(to, quantity, "");
1260   }
1261 
1262   /**
1263    * @dev Mints `quantity` tokens and transfers them to `to`.
1264    *
1265    * Requirements:
1266    *
1267    * - `to` cannot be the zero address.
1268    * - `quantity` cannot be larger than the max batch size.
1269    *
1270    * Emits a {Transfer} event.
1271    */
1272   function _safeMint(
1273     address to,
1274     uint256 quantity,
1275     bytes memory _data
1276   ) internal {
1277     uint256 startTokenId = currentIndex;
1278     require(to != address(0), "ERC721A: mint to the zero address");
1279     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1280     require(!_exists(startTokenId), "ERC721A: token already minted");
1281     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1282 
1283     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1284 
1285     AddressData memory addressData = _addressData[to];
1286     _addressData[to] = AddressData(
1287       addressData.balance + uint128(quantity),
1288       addressData.numberMinted + uint128(quantity)
1289     );
1290     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1291 
1292     uint256 updatedIndex = startTokenId;
1293 
1294     for (uint256 i = 0; i < quantity; i++) {
1295       emit Transfer(address(0), to, updatedIndex);
1296       require(
1297         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1298         "ERC721A: transfer to non ERC721Receiver implementer"
1299       );
1300       updatedIndex++;
1301     }
1302 
1303     currentIndex = updatedIndex;
1304     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1305   }
1306 
1307   /**
1308    * @dev Transfers `tokenId` from `from` to `to`.
1309    *
1310    * Requirements:
1311    *
1312    * - `to` cannot be the zero address.
1313    * - `tokenId` token must be owned by `from`.
1314    *
1315    * Emits a {Transfer} event.
1316    */
1317   function _transfer(
1318     address from,
1319     address to,
1320     uint256 tokenId
1321   ) private {
1322     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1323 
1324     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1325       getApproved(tokenId) == _msgSender() ||
1326       isApprovedForAll(prevOwnership.addr, _msgSender()));
1327 
1328     require(
1329       isApprovedOrOwner,
1330       "ERC721A: transfer caller is not owner nor approved"
1331     );
1332 
1333     require(
1334       prevOwnership.addr == from,
1335       "ERC721A: transfer from incorrect owner"
1336     );
1337     require(to != address(0), "ERC721A: transfer to the zero address");
1338 
1339     _beforeTokenTransfers(from, to, tokenId, 1);
1340 
1341     // Clear approvals from the previous owner
1342     _approve(address(0), tokenId, prevOwnership.addr);
1343 
1344     _addressData[from].balance -= 1;
1345     _addressData[to].balance += 1;
1346     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1347 
1348     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1349     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1350     uint256 nextTokenId = tokenId + 1;
1351     if (_ownerships[nextTokenId].addr == address(0)) {
1352       if (_exists(nextTokenId)) {
1353         _ownerships[nextTokenId] = TokenOwnership(
1354           prevOwnership.addr,
1355           prevOwnership.startTimestamp
1356         );
1357       }
1358     }
1359 
1360     emit Transfer(from, to, tokenId);
1361     _afterTokenTransfers(from, to, tokenId, 1);
1362   }
1363 
1364   /**
1365    * @dev Approve `to` to operate on `tokenId`
1366    *
1367    * Emits a {Approval} event.
1368    */
1369   function _approve(
1370     address to,
1371     uint256 tokenId,
1372     address owner
1373   ) private {
1374     _tokenApprovals[tokenId] = to;
1375     emit Approval(owner, to, tokenId);
1376   }
1377 
1378   uint256 public nextOwnerToExplicitlySet = 0;
1379 
1380   /**
1381    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1382    */
1383   function _setOwnersExplicit(uint256 quantity) internal {
1384     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1385     require(quantity > 0, "quantity must be nonzero");
1386     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1387     if (endIndex > currentIndex - 1) {
1388       endIndex = currentIndex - 1;
1389     }
1390     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1391     require(_exists(endIndex), "not enough minted yet for this cleanup");
1392     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1393       if (_ownerships[i].addr == address(0)) {
1394         TokenOwnership memory ownership = ownershipOf(i);
1395         _ownerships[i] = TokenOwnership(
1396           ownership.addr,
1397           ownership.startTimestamp
1398         );
1399       }
1400     }
1401     nextOwnerToExplicitlySet = endIndex + 1;
1402   }
1403 
1404   /**
1405    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1406    * The call is not executed if the target address is not a contract.
1407    *
1408    * @param from address representing the previous owner of the given token ID
1409    * @param to target address that will receive the tokens
1410    * @param tokenId uint256 ID of the token to be transferred
1411    * @param _data bytes optional data to send along with the call
1412    * @return bool whether the call correctly returned the expected magic value
1413    */
1414   function _checkOnERC721Received(
1415     address from,
1416     address to,
1417     uint256 tokenId,
1418     bytes memory _data
1419   ) private returns (bool) {
1420     if (to.isContract()) {
1421       try
1422         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1423       returns (bytes4 retval) {
1424         return retval == IERC721Receiver(to).onERC721Received.selector;
1425       } catch (bytes memory reason) {
1426         if (reason.length == 0) {
1427           revert("ERC721A: transfer to non ERC721Receiver implementer");
1428         } else {
1429           assembly {
1430             revert(add(32, reason), mload(reason))
1431           }
1432         }
1433       }
1434     } else {
1435       return true;
1436     }
1437   }
1438 
1439   /**
1440    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1441    *
1442    * startTokenId - the first token id to be transferred
1443    * quantity - the amount to be transferred
1444    *
1445    * Calling conditions:
1446    *
1447    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1448    * transferred to `to`.
1449    * - When `from` is zero, `tokenId` will be minted for `to`.
1450    */
1451   function _beforeTokenTransfers(
1452     address from,
1453     address to,
1454     uint256 startTokenId,
1455     uint256 quantity
1456   ) internal virtual {}
1457 
1458   /**
1459    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1460    * minting.
1461    *
1462    * startTokenId - the first token id to be transferred
1463    * quantity - the amount to be transferred
1464    *
1465    * Calling conditions:
1466    *
1467    * - when `from` and `to` are both non-zero.
1468    * - `from` and `to` are never both zero.
1469    */
1470   function _afterTokenTransfers(
1471     address from,
1472     address to,
1473     uint256 startTokenId,
1474     uint256 quantity
1475   ) internal virtual {}
1476 }
1477 // File: contracts/RumbleKL.sol
1478 
1479 
1480 
1481 //Developer: AFO
1482 
1483 
1484 
1485 pragma solidity >=0.7.0 <0.9.0;
1486 
1487 
1488 
1489 
1490 
1491 contract RumbleKL is ERC721A, Ownable {
1492   using Strings for uint256;
1493 
1494   string public baseURI;
1495   string public baseExtension = ".json";
1496   uint256 public cost = 0.0069 ether;
1497   uint256 public maxSupply = 10000;
1498   uint256 public maxsize = 20 ; // max mint per tx
1499   bool public paused = false;
1500 
1501   constructor() ERC721A("0xRumbleKL", "0xRumbleKL", maxsize) {
1502     setBaseURI("ipfs://QmWixQ1Q6yGEEA4wuVs92nMKt7gZSoyXBNJ2ReaMDPvm38/");
1503   }
1504 
1505   // internal
1506   function _baseURI() internal view virtual override returns (string memory) {
1507     return baseURI;
1508   }
1509 
1510   // public
1511   function mint(uint256 tokens) public payable {
1512     require(!paused, "0xRumbleKL: oops contract is paused");
1513     uint256 supply = totalSupply();
1514     require(tokens > 0, "0xRumbleKL: need to mint at least 1 NFT");
1515     require(tokens <= maxsize, "0xRumbleKL: max mint amount per tx exceeded");
1516     require(supply + tokens <= maxSupply, "0xRumbleKL: We Sold Out!!");
1517     if (supply < 500) {
1518       require(msg.value >= 0 * tokens, "0xRumbleKL: It's Free Mint");
1519     } else {
1520 
1521     require(msg.value >= cost * tokens, "0xRumbleKL: insufficient funds");
1522     }
1523 
1524       _safeMint(_msgSender(), tokens);
1525     
1526   }
1527 
1528 
1529 
1530   /// @dev use it for giveaway and mint for yourself
1531      function gift(uint256 _mintAmount, address destination) public onlyOwner {
1532     require(_mintAmount > 0, "need to mint at least 1 NFT");
1533     uint256 supply = totalSupply();
1534     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1535 
1536       _safeMint(destination, _mintAmount);
1537     
1538   }
1539 
1540   
1541 
1542 
1543   function walletOfOwner(address _owner)
1544     public
1545     view
1546     returns (uint256[] memory)
1547   {
1548     uint256 ownerTokenCount = balanceOf(_owner);
1549     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1550     for (uint256 i; i < ownerTokenCount; i++) {
1551       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1552     }
1553     return tokenIds;
1554   }
1555 
1556   function tokenURI(uint256 tokenId)
1557     public
1558     view
1559     virtual
1560     override
1561     returns (string memory)
1562   {
1563     require(
1564       _exists(tokenId),
1565       "ERC721AMetadata: URI query for nonexistent token"
1566     );
1567     
1568 
1569     string memory currentBaseURI = _baseURI();
1570     return bytes(currentBaseURI).length > 0
1571         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1572         : "";
1573   }
1574 
1575   //only owner
1576 
1577   function setCost(uint256 _newCost) public onlyOwner {
1578     cost = _newCost;
1579   }
1580 
1581     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1582     maxSupply = _newsupply;
1583   }
1584 
1585 
1586   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1587     baseURI = _newBaseURI;
1588   }
1589 
1590   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1591     baseExtension = _newBaseExtension;
1592   }
1593   
1594 
1595   function pause(bool _state) public onlyOwner {
1596     paused = _state;
1597   }
1598  
1599   function withdraw() public onlyOwner {
1600     (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1601     require(success);
1602   }
1603 
1604   
1605 }