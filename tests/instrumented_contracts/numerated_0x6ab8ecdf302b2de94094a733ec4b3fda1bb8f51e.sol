1 //  ____  _     _      _  __   ____  _     ____  ____    _      _____ _____ 
2 // /  __\/ \ /\/ \  /|/ |/ /  /  __\/ \ /\/  __\/ ___\  / \  /|/    //__ __\
3 // |  \/|| | ||| |\ |||   /   |  \/|| | |||  \/||    \  | |\ |||  __\  / \  
4 // |  __/| \_/|| | \|||   \   |  __/| \_/||  __/\___ |  | | \||| |     | |  
5 // \_/   \____/\_/  \|\_|\_\  \_/   \____/\_/   \____/  \_/  \|\_/     \_/  
6                                                                          
7 
8 /**
9  *Submitted for verification at Etherscan.io on 2022-02-28
10 */
11 
12 // SPDX-License-Identifier: GPL-3.0
13 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
14 
15 
16 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 // CAUTION
21 // This version of SafeMath should only be used with Solidity 0.8 or later,
22 // because it relies on the compiler's built in overflow checks.
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations.
26  *
27  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
28  * now has built in overflow checking.
29  */
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             uint256 c = a + b;
39             if (c < a) return (false, 0);
40             return (true, c);
41         }
42     }
43 
44     /**
45      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             if (b > a) return (false, 0);
52             return (true, a - b);
53         }
54     }
55 
56     /**
57      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64             // benefit is lost if 'b' is also tested.
65             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66             if (a == 0) return (true, 0);
67             uint256 c = a * b;
68             if (c / a != b) return (false, 0);
69             return (true, c);
70         }
71     }
72 
73     /**
74      * @dev Returns the division of two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a / b);
82         }
83     }
84 
85     /**
86      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             if (b == 0) return (false, 0);
93             return (true, a % b);
94         }
95     }
96 
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a + b;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a - b;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      *
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a * b;
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers, reverting on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator.
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a / b;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * reverting when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a % b;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * CAUTION: This function is deprecated because it requires allocating memory for the error
174      * message unnecessarily. For custom revert reasons use {trySub}.
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(
183         uint256 a,
184         uint256 b,
185         string memory errorMessage
186     ) internal pure returns (uint256) {
187         unchecked {
188             require(b <= a, errorMessage);
189             return a - b;
190         }
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(
206         uint256 a,
207         uint256 b,
208         string memory errorMessage
209     ) internal pure returns (uint256) {
210         unchecked {
211             require(b > 0, errorMessage);
212             return a / b;
213         }
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * reverting with custom message when dividing by zero.
219      *
220      * CAUTION: This function is deprecated because it requires allocating memory for the error
221      * message unnecessarily. For custom revert reasons use {tryMod}.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         unchecked {
237             require(b > 0, errorMessage);
238             return a % b;
239         }
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Strings.sol
244 
245 
246 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev String operations.
252  */
253 library Strings {
254     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
255 
256     /**
257      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
258      */
259     function toString(uint256 value) internal pure returns (string memory) {
260         // Inspired by OraclizeAPI's implementation - MIT licence
261         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
262 
263         if (value == 0) {
264             return "0";
265         }
266         uint256 temp = value;
267         uint256 digits;
268         while (temp != 0) {
269             digits++;
270             temp /= 10;
271         }
272         bytes memory buffer = new bytes(digits);
273         while (value != 0) {
274             digits -= 1;
275             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
276             value /= 10;
277         }
278         return string(buffer);
279     }
280 
281     /**
282      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
283      */
284     function toHexString(uint256 value) internal pure returns (string memory) {
285         if (value == 0) {
286             return "0x00";
287         }
288         uint256 temp = value;
289         uint256 length = 0;
290         while (temp != 0) {
291             length++;
292             temp >>= 8;
293         }
294         return toHexString(value, length);
295     }
296 
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
299      */
300     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
301         bytes memory buffer = new bytes(2 * length + 2);
302         buffer[0] = "0";
303         buffer[1] = "x";
304         for (uint256 i = 2 * length + 1; i > 1; --i) {
305             buffer[i] = _HEX_SYMBOLS[value & 0xf];
306             value >>= 4;
307         }
308         require(value == 0, "Strings: hex length insufficient");
309         return string(buffer);
310     }
311 }
312 
313 // File: @openzeppelin/contracts/utils/Context.sol
314 
315 
316 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Provides information about the current execution context, including the
322  * sender of the transaction and its data. While these are generally available
323  * via msg.sender and msg.data, they should not be accessed in such a direct
324  * manner, since when dealing with meta-transactions the account sending and
325  * paying for execution may not be the actual sender (as far as an application
326  * is concerned).
327  *
328  * This contract is only required for intermediate, library-like contracts.
329  */
330 abstract contract Context {
331     function _msgSender() internal view virtual returns (address) {
332         return msg.sender;
333     }
334 
335     function _msgData() internal view virtual returns (bytes calldata) {
336         return msg.data;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/access/Ownable.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 
348 /**
349  * @dev Contract module which provides a basic access control mechanism, where
350  * there is an account (an owner) that can be granted exclusive access to
351  * specific functions.
352  *
353  * By default, the owner account will be the one that deploys the contract. This
354  * can later be changed with {transferOwnership}.
355  *
356  * This module is used through inheritance. It will make available the modifier
357  * `onlyOwner`, which can be applied to your functions to restrict their use to
358  * the owner.
359  */
360 abstract contract Ownable is Context {
361     address private _owner;
362 
363     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
364 
365     /**
366      * @dev Initializes the contract setting the deployer as the initial owner.
367      */
368     constructor() {
369         _transferOwnership(_msgSender());
370     }
371 
372     /**
373      * @dev Returns the address of the current owner.
374      */
375     function owner() public view virtual returns (address) {
376         return _owner;
377     }
378 
379     /**
380      * @dev Throws if called by any account other than the owner.
381      */
382     modifier onlyOwner() {
383         require(owner() == _msgSender(), "Ownable: caller is not the owner");
384         _;
385     }
386 
387     /**
388      * @dev Leaves the contract without owner. It will not be possible to call
389      * `onlyOwner` functions anymore. Can only be called by the current owner.
390      *
391      * NOTE: Renouncing ownership will leave the contract without an owner,
392      * thereby removing any functionality that is only available to the owner.
393      */
394     function renounceOwnership() public virtual onlyOwner {
395         _transferOwnership(address(0));
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Can only be called by the current owner.
401      */
402     function transferOwnership(address newOwner) public virtual onlyOwner {
403         require(newOwner != address(0), "Ownable: new owner is the zero address");
404         _transferOwnership(newOwner);
405     }
406 
407     /**
408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
409      * Internal function without access restriction.
410      */
411     function _transferOwnership(address newOwner) internal virtual {
412         address oldOwner = _owner;
413         _owner = newOwner;
414         emit OwnershipTransferred(oldOwner, newOwner);
415     }
416 }
417 
418 // File: @openzeppelin/contracts/utils/Address.sol
419 
420 
421 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
422 
423 pragma solidity ^0.8.1;
424 
425 /**
426  * @dev Collection of functions related to the address type
427  */
428 library Address {
429     /**
430      * @dev Returns true if `account` is a contract.
431      *
432      * [IMPORTANT]
433      * ====
434      * It is unsafe to assume that an address for which this function returns
435      * false is an externally-owned account (EOA) and not a contract.
436      *
437      * Among others, `isContract` will return false for the following
438      * types of addresses:
439      *
440      *  - an externally-owned account
441      *  - a contract in construction
442      *  - an address where a contract will be created
443      *  - an address where a contract lived, but was destroyed
444      * ====
445      *
446      * [IMPORTANT]
447      * ====
448      * You shouldn't rely on `isContract` to protect against flash loan attacks!
449      *
450      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
451      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
452      * constructor.
453      * ====
454      */
455     function isContract(address account) internal view returns (bool) {
456         // This method relies on extcodesize/address.code.length, which returns 0
457         // for contracts in construction, since the code is only stored at the end
458         // of the constructor execution.
459 
460         return account.code.length > 0;
461     }
462 
463     /**
464      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
465      * `recipient`, forwarding all available gas and reverting on errors.
466      *
467      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
468      * of certain opcodes, possibly making contracts go over the 2300 gas limit
469      * imposed by `transfer`, making them unable to receive funds via
470      * `transfer`. {sendValue} removes this limitation.
471      *
472      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
473      *
474      * IMPORTANT: because control is transferred to `recipient`, care must be
475      * taken to not create reentrancy vulnerabilities. Consider using
476      * {ReentrancyGuard} or the
477      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
478      */
479     function sendValue(address payable recipient, uint256 amount) internal {
480         require(address(this).balance >= amount, "Address: insufficient balance");
481 
482         (bool success, ) = recipient.call{value: amount}("");
483         require(success, "Address: unable to send value, recipient may have reverted");
484     }
485 
486     /**
487      * @dev Performs a Solidity function call using a low level `call`. A
488      * plain `call` is an unsafe replacement for a function call: use this
489      * function instead.
490      *
491      * If `target` reverts with a revert reason, it is bubbled up by this
492      * function (like regular Solidity function calls).
493      *
494      * Returns the raw returned data. To convert to the expected return value,
495      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
496      *
497      * Requirements:
498      *
499      * - `target` must be a contract.
500      * - calling `target` with `data` must not revert.
501      *
502      * _Available since v3.1._
503      */
504     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
505         return functionCall(target, data, "Address: low-level call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
510      * `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         return functionCallWithValue(target, data, 0, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but also transferring `value` wei to `target`.
525      *
526      * Requirements:
527      *
528      * - the calling contract must have an ETH balance of at least `value`.
529      * - the called Solidity function must be `payable`.
530      *
531      * _Available since v3.1._
532      */
533     function functionCallWithValue(
534         address target,
535         bytes memory data,
536         uint256 value
537     ) internal returns (bytes memory) {
538         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
543      * with `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(
548         address target,
549         bytes memory data,
550         uint256 value,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         require(address(this).balance >= value, "Address: insufficient balance for call");
554         require(isContract(target), "Address: call to non-contract");
555 
556         (bool success, bytes memory returndata) = target.call{value: value}(data);
557         return verifyCallResult(success, returndata, errorMessage);
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
562      * but performing a static call.
563      *
564      * _Available since v3.3._
565      */
566     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
567         return functionStaticCall(target, data, "Address: low-level static call failed");
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
572      * but performing a static call.
573      *
574      * _Available since v3.3._
575      */
576     function functionStaticCall(
577         address target,
578         bytes memory data,
579         string memory errorMessage
580     ) internal view returns (bytes memory) {
581         require(isContract(target), "Address: static call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.staticcall(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a delegate call.
590      *
591      * _Available since v3.4._
592      */
593     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
594         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
599      * but performing a delegate call.
600      *
601      * _Available since v3.4._
602      */
603     function functionDelegateCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         require(isContract(target), "Address: delegate call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.delegatecall(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
616      * revert reason using the provided one.
617      *
618      * _Available since v4.3._
619      */
620     function verifyCallResult(
621         bool success,
622         bytes memory returndata,
623         string memory errorMessage
624     ) internal pure returns (bytes memory) {
625         if (success) {
626             return returndata;
627         } else {
628             // Look for revert reason and bubble it up if present
629             if (returndata.length > 0) {
630                 // The easiest way to bubble the revert reason is using memory via assembly
631 
632                 assembly {
633                     let returndata_size := mload(returndata)
634                     revert(add(32, returndata), returndata_size)
635                 }
636             } else {
637                 revert(errorMessage);
638             }
639         }
640     }
641 }
642 
643 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
644 
645 
646 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 /**
651  * @title ERC721 token receiver interface
652  * @dev Interface for any contract that wants to support safeTransfers
653  * from ERC721 asset contracts.
654  */
655 interface IERC721Receiver {
656     /**
657      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
658      * by `operator` from `from`, this function is called.
659      *
660      * It must return its Solidity selector to confirm the token transfer.
661      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
662      *
663      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
664      */
665     function onERC721Received(
666         address operator,
667         address from,
668         uint256 tokenId,
669         bytes calldata data
670     ) external returns (bytes4);
671 }
672 
673 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
677 
678 pragma solidity ^0.8.0;
679 
680 /**
681  * @dev Interface of the ERC165 standard, as defined in the
682  * https://eips.ethereum.org/EIPS/eip-165[EIP].
683  *
684  * Implementers can declare support of contract interfaces, which can then be
685  * queried by others ({ERC165Checker}).
686  *
687  * For an implementation, see {ERC165}.
688  */
689 interface IERC165 {
690     /**
691      * @dev Returns true if this contract implements the interface defined by
692      * `interfaceId`. See the corresponding
693      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
694      * to learn more about how these ids are created.
695      *
696      * This function call must use less than 30 000 gas.
697      */
698     function supportsInterface(bytes4 interfaceId) external view returns (bool);
699 }
700 
701 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @dev Implementation of the {IERC165} interface.
711  *
712  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
713  * for the additional interface id that will be supported. For example:
714  *
715  * ```solidity
716  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
718  * }
719  * ```
720  *
721  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
722  */
723 abstract contract ERC165 is IERC165 {
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
728         return interfaceId == type(IERC165).interfaceId;
729     }
730 }
731 
732 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
733 
734 
735 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 
740 /**
741  * @dev Required interface of an ERC721 compliant contract.
742  */
743 interface IERC721 is IERC165 {
744     /**
745      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
746      */
747     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
748 
749     /**
750      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
751      */
752     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
753 
754     /**
755      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
756      */
757     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
758 
759     /**
760      * @dev Returns the number of tokens in ``owner``'s account.
761      */
762     function balanceOf(address owner) external view returns (uint256 balance);
763 
764     /**
765      * @dev Returns the owner of the `tokenId` token.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      */
771     function ownerOf(uint256 tokenId) external view returns (address owner);
772 
773     /**
774      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
775      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
776      *
777      * Requirements:
778      *
779      * - `from` cannot be the zero address.
780      * - `to` cannot be the zero address.
781      * - `tokenId` token must exist and be owned by `from`.
782      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
783      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
784      *
785      * Emits a {Transfer} event.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) external;
792 
793     /**
794      * @dev Transfers `tokenId` token from `from` to `to`.
795      *
796      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must be owned by `from`.
803      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
804      *
805      * Emits a {Transfer} event.
806      */
807     function transferFrom(
808         address from,
809         address to,
810         uint256 tokenId
811     ) external;
812 
813     /**
814      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
815      * The approval is cleared when the token is transferred.
816      *
817      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
818      *
819      * Requirements:
820      *
821      * - The caller must own the token or be an approved operator.
822      * - `tokenId` must exist.
823      *
824      * Emits an {Approval} event.
825      */
826     function approve(address to, uint256 tokenId) external;
827 
828     /**
829      * @dev Returns the account approved for `tokenId` token.
830      *
831      * Requirements:
832      *
833      * - `tokenId` must exist.
834      */
835     function getApproved(uint256 tokenId) external view returns (address operator);
836 
837     /**
838      * @dev Approve or remove `operator` as an operator for the caller.
839      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
840      *
841      * Requirements:
842      *
843      * - The `operator` cannot be the caller.
844      *
845      * Emits an {ApprovalForAll} event.
846      */
847     function setApprovalForAll(address operator, bool _approved) external;
848 
849     /**
850      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
851      *
852      * See {setApprovalForAll}
853      */
854     function isApprovedForAll(address owner, address operator) external view returns (bool);
855 
856     /**
857      * @dev Safely transfers `tokenId` token from `from` to `to`.
858      *
859      * Requirements:
860      *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must exist and be owned by `from`.
864      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866      *
867      * Emits a {Transfer} event.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes calldata data
874     ) external;
875 }
876 
877 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
878 
879 
880 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
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
899     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
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
911 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
912 
913 pragma solidity ^0.8.0;
914 
915 
916 /**
917  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
918  * @dev See https://eips.ethereum.org/EIPS/eip-721
919  */
920 interface IERC721Metadata is IERC721 {
921     /**
922      * @dev Returns the token collection name.
923      */
924     function name() external view returns (string memory);
925 
926     /**
927      * @dev Returns the token collection symbol.
928      */
929     function symbol() external view returns (string memory);
930 
931     /**
932      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
933      */
934     function tokenURI(uint256 tokenId) external view returns (string memory);
935 }
936 
937 // File: contracts/ERC721A.sol
938 
939 
940 
941 pragma solidity ^0.8.10;
942 
943 
944 
945 
946 
947 
948 
949 
950 
951 /**
952  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
953  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
954  *
955  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
956  *
957  * Does not support burning tokens to address(0).
958  */
959 contract ERC721A is
960   Context,
961   ERC165,
962   IERC721,
963   IERC721Metadata,
964   IERC721Enumerable
965 {
966   using Address for address;
967   using Strings for uint256;
968 
969   struct TokenOwnership {
970     address addr;
971     uint64 startTimestamp;
972   }
973 
974   struct AddressData {
975     uint128 balance;
976     uint128 numberMinted;
977   }
978 
979   uint256 private currentIndex = 1;
980 
981   uint256 public immutable maxBatchSize;
982 
983   // Token name
984   string private _name;
985 
986   // Token symbol
987   string private _symbol;
988 
989   // Mapping from token ID to ownership details
990   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
991   mapping(uint256 => TokenOwnership) private _ownerships;
992 
993   // Mapping owner address to address data
994   mapping(address => AddressData) private _addressData;
995 
996   // Mapping from token ID to approved address
997   mapping(uint256 => address) private _tokenApprovals;
998 
999   // Mapping from owner to operator approvals
1000   mapping(address => mapping(address => bool)) private _operatorApprovals;
1001 
1002   /**
1003    * @dev
1004    * `maxBatchSize` refers to how much a minter can mint at a time.
1005    */
1006   constructor(
1007     string memory name_,
1008     string memory symbol_,
1009     uint256 maxBatchSize_
1010   ) {
1011     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1012     _name = name_;
1013     _symbol = symbol_;
1014     maxBatchSize = maxBatchSize_;
1015   }
1016 
1017   /**
1018    * @dev See {IERC721Enumerable-totalSupply}.
1019    */
1020   function totalSupply() public view override returns (uint256) {
1021     return currentIndex - 1;
1022   }
1023 
1024   /**
1025    * @dev See {IERC721Enumerable-tokenByIndex}.
1026    */
1027   function tokenByIndex(uint256 index) public view override returns (uint256) {
1028     require(index < totalSupply(), "ERC721A: global index out of bounds");
1029     return index;
1030   }
1031 
1032   /**
1033    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1034    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1035    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1036    */
1037   function tokenOfOwnerByIndex(address owner, uint256 index)
1038     public
1039     view
1040     override
1041     returns (uint256)
1042   {
1043     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1044     uint256 numMintedSoFar = totalSupply();
1045     uint256 tokenIdsIdx = 0;
1046     address currOwnershipAddr = address(0);
1047     for (uint256 i = 0; i < numMintedSoFar; i++) {
1048       TokenOwnership memory ownership = _ownerships[i];
1049       if (ownership.addr != address(0)) {
1050         currOwnershipAddr = ownership.addr;
1051       }
1052       if (currOwnershipAddr == owner) {
1053         if (tokenIdsIdx == index) {
1054           return i;
1055         }
1056         tokenIdsIdx++;
1057       }
1058     }
1059     revert("ERC721A: unable to get token of owner by index");
1060   }
1061 
1062   /**
1063    * @dev See {IERC165-supportsInterface}.
1064    */
1065   function supportsInterface(bytes4 interfaceId)
1066     public
1067     view
1068     virtual
1069     override(ERC165, IERC165)
1070     returns (bool)
1071   {
1072     return
1073       interfaceId == type(IERC721).interfaceId ||
1074       interfaceId == type(IERC721Metadata).interfaceId ||
1075       interfaceId == type(IERC721Enumerable).interfaceId ||
1076       super.supportsInterface(interfaceId);
1077   }
1078 
1079   /**
1080    * @dev See {IERC721-balanceOf}.
1081    */
1082   function balanceOf(address owner) public view override returns (uint256) {
1083     require(owner != address(0), "ERC721A: balance query for the zero address");
1084     return uint256(_addressData[owner].balance);
1085   }
1086 
1087   function _numberMinted(address owner) internal view returns (uint256) {
1088     require(
1089       owner != address(0),
1090       "ERC721A: number minted query for the zero address"
1091     );
1092     return uint256(_addressData[owner].numberMinted);
1093   }
1094 
1095   function ownershipOf(uint256 tokenId)
1096     internal
1097     view
1098     returns (TokenOwnership memory)
1099   {
1100     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1101 
1102     uint256 lowestTokenToCheck;
1103     if (tokenId >= maxBatchSize) {
1104       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1105     }
1106 
1107     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1108       TokenOwnership memory ownership = _ownerships[curr];
1109       if (ownership.addr != address(0)) {
1110         return ownership;
1111       }
1112     }
1113 
1114     revert("ERC721A: unable to determine the owner of token");
1115   }
1116 
1117   /**
1118    * @dev See {IERC721-ownerOf}.
1119    */
1120   function ownerOf(uint256 tokenId) public view override returns (address) {
1121     return ownershipOf(tokenId).addr;
1122   }
1123 
1124   /**
1125    * @dev See {IERC721Metadata-name}.
1126    */
1127   function name() public view virtual override returns (string memory) {
1128     return _name;
1129   }
1130 
1131   /**
1132    * @dev See {IERC721Metadata-symbol}.
1133    */
1134   function symbol() public view virtual override returns (string memory) {
1135     return _symbol;
1136   }
1137 
1138   /**
1139    * @dev See {IERC721Metadata-tokenURI}.
1140    */
1141   function tokenURI(uint256 tokenId)
1142     public
1143     view
1144     virtual
1145     override
1146     returns (string memory)
1147   {
1148     require(
1149       _exists(tokenId),
1150       "ERC721Metadata: URI query for nonexistent token"
1151     );
1152 
1153     string memory baseURI = _baseURI();
1154     return
1155       bytes(baseURI).length > 0
1156         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1157         : "";
1158   }
1159 
1160   /**
1161    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1162    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1163    * by default, can be overriden in child contracts.
1164    */
1165   function _baseURI() internal view virtual returns (string memory) {
1166     return "";
1167   }
1168 
1169   /**
1170    * @dev See {IERC721-approve}.
1171    */
1172   function approve(address to, uint256 tokenId) public override {
1173     address owner = ERC721A.ownerOf(tokenId);
1174     require(to != owner, "ERC721A: approval to current owner");
1175 
1176     require(
1177       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1178       "ERC721A: approve caller is not owner nor approved for all"
1179     );
1180 
1181     _approve(to, tokenId, owner);
1182   }
1183 
1184   /**
1185    * @dev See {IERC721-getApproved}.
1186    */
1187   function getApproved(uint256 tokenId) public view override returns (address) {
1188     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1189 
1190     return _tokenApprovals[tokenId];
1191   }
1192 
1193   /**
1194    * @dev See {IERC721-setApprovalForAll}.
1195    */
1196   function setApprovalForAll(address operator, bool approved) public override {
1197     require(operator != _msgSender(), "ERC721A: approve to caller");
1198 
1199     _operatorApprovals[_msgSender()][operator] = approved;
1200     emit ApprovalForAll(_msgSender(), operator, approved);
1201   }
1202 
1203   /**
1204    * @dev See {IERC721-isApprovedForAll}.
1205    */
1206   function isApprovedForAll(address owner, address operator)
1207     public
1208     view
1209     virtual
1210     override
1211     returns (bool)
1212   {
1213     return _operatorApprovals[owner][operator];
1214   }
1215 
1216   /**
1217    * @dev See {IERC721-transferFrom}.
1218    */
1219   function transferFrom(
1220     address from,
1221     address to,
1222     uint256 tokenId
1223   ) public override {
1224     _transfer(from, to, tokenId);
1225   }
1226 
1227   /**
1228    * @dev See {IERC721-safeTransferFrom}.
1229    */
1230   function safeTransferFrom(
1231     address from,
1232     address to,
1233     uint256 tokenId
1234   ) public override {
1235     safeTransferFrom(from, to, tokenId, "");
1236   }
1237 
1238   /**
1239    * @dev See {IERC721-safeTransferFrom}.
1240    */
1241   function safeTransferFrom(
1242     address from,
1243     address to,
1244     uint256 tokenId,
1245     bytes memory _data
1246   ) public override {
1247     _transfer(from, to, tokenId);
1248     require(
1249       _checkOnERC721Received(from, to, tokenId, _data),
1250       "ERC721A: transfer to non ERC721Receiver implementer"
1251     );
1252   }
1253 
1254   /**
1255    * @dev Returns whether `tokenId` exists.
1256    *
1257    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1258    *
1259    * Tokens start existing when they are minted (`_mint`),
1260    */
1261   function _exists(uint256 tokenId) internal view returns (bool) {
1262     return tokenId < currentIndex;
1263   }
1264 
1265   function _safeMint(address to, uint256 quantity) internal {
1266     _safeMint(to, quantity, "");
1267   }
1268 
1269   /**
1270    * @dev Mints `quantity` tokens and transfers them to `to`.
1271    *
1272    * Requirements:
1273    *
1274    * - `to` cannot be the zero address.
1275    * - `quantity` cannot be larger than the max batch size.
1276    *
1277    * Emits a {Transfer} event.
1278    */
1279   function _safeMint(
1280     address to,
1281     uint256 quantity,
1282     bytes memory _data
1283   ) internal {
1284     uint256 startTokenId = currentIndex;
1285     require(to != address(0), "ERC721A: mint to the zero address");
1286     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1287     require(!_exists(startTokenId), "ERC721A: token already minted");
1288     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1289 
1290     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1291 
1292     AddressData memory addressData = _addressData[to];
1293     _addressData[to] = AddressData(
1294       addressData.balance + uint128(quantity),
1295       addressData.numberMinted + uint128(quantity)
1296     );
1297     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1298 
1299     uint256 updatedIndex = startTokenId;
1300 
1301     for (uint256 i = 0; i < quantity; i++) {
1302       emit Transfer(address(0), to, updatedIndex);
1303       require(
1304         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1305         "ERC721A: transfer to non ERC721Receiver implementer"
1306       );
1307       updatedIndex++;
1308     }
1309 
1310     currentIndex = updatedIndex;
1311     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1312   }
1313 
1314   /**
1315    * @dev Transfers `tokenId` from `from` to `to`.
1316    *
1317    * Requirements:
1318    *
1319    * - `to` cannot be the zero address.
1320    * - `tokenId` token must be owned by `from`.
1321    *
1322    * Emits a {Transfer} event.
1323    */
1324   function _transfer(
1325     address from,
1326     address to,
1327     uint256 tokenId
1328   ) private {
1329     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1330 
1331     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1332       getApproved(tokenId) == _msgSender() ||
1333       isApprovedForAll(prevOwnership.addr, _msgSender()));
1334 
1335     require(
1336       isApprovedOrOwner,
1337       "ERC721A: transfer caller is not owner nor approved"
1338     );
1339 
1340     require(
1341       prevOwnership.addr == from,
1342       "ERC721A: transfer from incorrect owner"
1343     );
1344     require(to != address(0), "ERC721A: transfer to the zero address");
1345 
1346     _beforeTokenTransfers(from, to, tokenId, 1);
1347 
1348     // Clear approvals from the previous owner
1349     _approve(address(0), tokenId, prevOwnership.addr);
1350 
1351     _addressData[from].balance -= 1;
1352     _addressData[to].balance += 1;
1353     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1354 
1355     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1356     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1357     uint256 nextTokenId = tokenId + 1;
1358     if (_ownerships[nextTokenId].addr == address(0)) {
1359       if (_exists(nextTokenId)) {
1360         _ownerships[nextTokenId] = TokenOwnership(
1361           prevOwnership.addr,
1362           prevOwnership.startTimestamp
1363         );
1364       }
1365     }
1366 
1367     emit Transfer(from, to, tokenId);
1368     _afterTokenTransfers(from, to, tokenId, 1);
1369   }
1370 
1371   /**
1372    * @dev Approve `to` to operate on `tokenId`
1373    *
1374    * Emits a {Approval} event.
1375    */
1376   function _approve(
1377     address to,
1378     uint256 tokenId,
1379     address owner
1380   ) private {
1381     _tokenApprovals[tokenId] = to;
1382     emit Approval(owner, to, tokenId);
1383   }
1384 
1385   uint256 public nextOwnerToExplicitlySet = 0;
1386 
1387   /**
1388    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1389    */
1390   function _setOwnersExplicit(uint256 quantity) internal {
1391     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1392     require(quantity > 0, "quantity must be nonzero");
1393     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1394     if (endIndex > currentIndex - 1) {
1395       endIndex = currentIndex - 1;
1396     }
1397     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1398     require(_exists(endIndex), "not enough minted yet for this cleanup");
1399     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1400       if (_ownerships[i].addr == address(0)) {
1401         TokenOwnership memory ownership = ownershipOf(i);
1402         _ownerships[i] = TokenOwnership(
1403           ownership.addr,
1404           ownership.startTimestamp
1405         );
1406       }
1407     }
1408     nextOwnerToExplicitlySet = endIndex + 1;
1409   }
1410 
1411   /**
1412    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1413    * The call is not executed if the target address is not a contract.
1414    *
1415    * @param from address representing the previous owner of the given token ID
1416    * @param to target address that will receive the tokens
1417    * @param tokenId uint256 ID of the token to be transferred
1418    * @param _data bytes optional data to send along with the call
1419    * @return bool whether the call correctly returned the expected magic value
1420    */
1421   function _checkOnERC721Received(
1422     address from,
1423     address to,
1424     uint256 tokenId,
1425     bytes memory _data
1426   ) private returns (bool) {
1427     if (to.isContract()) {
1428       try
1429         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1430       returns (bytes4 retval) {
1431         return retval == IERC721Receiver(to).onERC721Received.selector;
1432       } catch (bytes memory reason) {
1433         if (reason.length == 0) {
1434           revert("ERC721A: transfer to non ERC721Receiver implementer");
1435         } else {
1436           assembly {
1437             revert(add(32, reason), mload(reason))
1438           }
1439         }
1440       }
1441     } else {
1442       return true;
1443     }
1444   }
1445 
1446   /**
1447    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1448    *
1449    * startTokenId - the first token id to be transferred
1450    * quantity - the amount to be transferred
1451    *
1452    * Calling conditions:
1453    *
1454    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1455    * transferred to `to`.
1456    * - When `from` is zero, `tokenId` will be minted for `to`.
1457    */
1458   function _beforeTokenTransfers(
1459     address from,
1460     address to,
1461     uint256 startTokenId,
1462     uint256 quantity
1463   ) internal virtual {}
1464 
1465   /**
1466    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1467    * minting.
1468    *
1469    * startTokenId - the first token id to be transferred
1470    * quantity - the amount to be transferred
1471    *
1472    * Calling conditions:
1473    *
1474    * - when `from` and `to` are both non-zero.
1475    * - `from` and `to` are never both zero.
1476    */
1477   function _afterTokenTransfers(
1478     address from,
1479     address to,
1480     uint256 startTokenId,
1481     uint256 quantity
1482   ) internal virtual {}
1483 }
1484 // File: contracts/PunkPups.sol
1485 
1486 
1487 pragma solidity >=0.7.0 <0.9.0;
1488 
1489 
1490 
1491 
1492 
1493 contract PunkPupsNFT is ERC721A, Ownable {
1494   using Strings for uint256;
1495 
1496   string public baseURI;
1497   string public baseExtension = ".json";
1498   uint256 public cost = 0.00 ether;
1499   uint256 public maxSupply = 7777;
1500   uint256 public maxsize = 20 ; // max mint per tx
1501   bool public paused = false;
1502 
1503   constructor() ERC721A("Punk Pups NFT", "Punk Pups NFT", maxsize) {
1504     setBaseURI("ipfs://QmSxP9arhuFHkSmzVK5QFKMBFuiwVxss7NN96xWfpmynAW/");
1505   }
1506 
1507   // internal
1508   function _baseURI() internal view virtual override returns (string memory) {
1509     return baseURI;
1510   }
1511 
1512   // public
1513   function mint(uint256 tokens) public payable {
1514     require(!paused, "Punk Pups: oops contract is paused");
1515     uint256 supply = totalSupply();
1516     require(tokens > 0, "Punk Pups: need to mint at least 1 NFT");
1517     require(tokens <= maxsize, "Punk Pups: max mint amount per tx exceeded");
1518     require(supply + tokens <= maxSupply, "Punk Pups: We Sold Out!!");
1519     if (supply < 500) {
1520       require(msg.value >= 0 * tokens, "Punk Pups: It's Free Mint");
1521     } else {
1522 
1523     require(msg.value >= cost * tokens, "Punk Pups: insufficient funds");
1524     }
1525 
1526       _safeMint(_msgSender(), tokens);
1527     
1528   }
1529 
1530 
1531 
1532   /// @dev use it for giveaway and mint for yourself
1533      function gift(uint256 _mintAmount, address destination) public onlyOwner {
1534     require(_mintAmount > 0, "need to mint at least 1 NFT");
1535     uint256 supply = totalSupply();
1536     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1537 
1538       _safeMint(destination, _mintAmount);
1539     
1540   }
1541 
1542   
1543 
1544 
1545   function walletOfOwner(address _owner)
1546     public
1547     view
1548     returns (uint256[] memory)
1549   {
1550     uint256 ownerTokenCount = balanceOf(_owner);
1551     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1552     for (uint256 i; i < ownerTokenCount; i++) {
1553       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1554     }
1555     return tokenIds;
1556   }
1557 
1558   function tokenURI(uint256 tokenId)
1559     public
1560     view
1561     virtual
1562     override
1563     returns (string memory)
1564   {
1565     require(
1566       _exists(tokenId),
1567       "ERC721AMetadata: URI query for nonexistent token"
1568     );
1569     
1570 
1571     string memory currentBaseURI = _baseURI();
1572     return bytes(currentBaseURI).length > 0
1573         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1574         : "";
1575   }
1576 
1577   //only owner
1578 
1579   function setCost(uint256 _newCost) public onlyOwner {
1580     cost = _newCost;
1581   }
1582 
1583     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1584     maxSupply = _newsupply;
1585   }
1586 
1587 
1588   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1589     baseURI = _newBaseURI;
1590   }
1591 
1592   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1593     baseExtension = _newBaseExtension;
1594   }
1595   
1596 
1597   function pause(bool _state) public onlyOwner {
1598     paused = _state;
1599   }
1600  
1601   function withdraw() public onlyOwner {
1602     (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1603     require(success);
1604   }
1605 
1606   
1607 }