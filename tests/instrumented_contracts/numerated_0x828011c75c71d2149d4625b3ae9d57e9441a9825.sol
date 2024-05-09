1 // SPDX-License-Identifier: unlicensed
2 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b <= a, errorMessage);
178             return a - b;
179         }
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a / b;
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/Strings.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev String operations.
241  */
242 library Strings {
243     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
244 
245     /**
246      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
247      */
248     function toString(uint256 value) internal pure returns (string memory) {
249         // Inspired by OraclizeAPI's implementation - MIT licence
250         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
251 
252         if (value == 0) {
253             return "0";
254         }
255         uint256 temp = value;
256         uint256 digits;
257         while (temp != 0) {
258             digits++;
259             temp /= 10;
260         }
261         bytes memory buffer = new bytes(digits);
262         while (value != 0) {
263             digits -= 1;
264             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
265             value /= 10;
266         }
267         return string(buffer);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
272      */
273     function toHexString(uint256 value) internal pure returns (string memory) {
274         if (value == 0) {
275             return "0x00";
276         }
277         uint256 temp = value;
278         uint256 length = 0;
279         while (temp != 0) {
280             length++;
281             temp >>= 8;
282         }
283         return toHexString(value, length);
284     }
285 
286     /**
287      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
288      */
289     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
290         bytes memory buffer = new bytes(2 * length + 2);
291         buffer[0] = "0";
292         buffer[1] = "x";
293         for (uint256 i = 2 * length + 1; i > 1; --i) {
294             buffer[i] = _HEX_SYMBOLS[value & 0xf];
295             value >>= 4;
296         }
297         require(value == 0, "Strings: hex length insufficient");
298         return string(buffer);
299     }
300 }
301 
302 // File: @openzeppelin/contracts/utils/Context.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Provides information about the current execution context, including the
311  * sender of the transaction and its data. While these are generally available
312  * via msg.sender and msg.data, they should not be accessed in such a direct
313  * manner, since when dealing with meta-transactions the account sending and
314  * paying for execution may not be the actual sender (as far as an application
315  * is concerned).
316  *
317  * This contract is only required for intermediate, library-like contracts.
318  */
319 abstract contract Context {
320     function _msgSender() internal view virtual returns (address) {
321         return msg.sender;
322     }
323 
324     function _msgData() internal view virtual returns (bytes calldata) {
325         return msg.data;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/access/Ownable.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 
337 /**
338  * @dev Contract module which provides a basic access control mechanism, where
339  * there is an account (an owner) that can be granted exclusive access to
340  * specific functions.
341  *
342  * By default, the owner account will be the one that deploys the contract. This
343  * can later be changed with {transferOwnership}.
344  *
345  * This module is used through inheritance. It will make available the modifier
346  * `onlyOwner`, which can be applied to your functions to restrict their use to
347  * the owner.
348  */
349 abstract contract Ownable is Context {
350     address private _owner;
351 
352     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
353 
354     /**
355      * @dev Initializes the contract setting the deployer as the initial owner.
356      */
357     constructor() {
358         _transferOwnership(_msgSender());
359     }
360 
361     /**
362      * @dev Returns the address of the current owner.
363      */
364     function owner() public view virtual returns (address) {
365         return _owner;
366     }
367 
368     /**
369      * @dev Throws if called by any account other than the owner.
370      */
371     modifier onlyOwner() {
372         require(owner() == _msgSender(), "Ownable: caller is not the owner");
373         _;
374     }
375 
376     /**
377      * @dev Leaves the contract without owner. It will not be possible to call
378      * `onlyOwner` functions anymore. Can only be called by the current owner.
379      *
380      * NOTE: Renouncing ownership will leave the contract without an owner,
381      * thereby removing any functionality that is only available to the owner.
382      */
383     function renounceOwnership() public virtual onlyOwner {
384         _transferOwnership(address(0));
385     }
386 
387     /**
388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
389      * Can only be called by the current owner.
390      */
391     function transferOwnership(address newOwner) public virtual onlyOwner {
392         require(newOwner != address(0), "Ownable: new owner is the zero address");
393         _transferOwnership(newOwner);
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      * Internal function without access restriction.
399      */
400     function _transferOwnership(address newOwner) internal virtual {
401         address oldOwner = _owner;
402         _owner = newOwner;
403         emit OwnershipTransferred(oldOwner, newOwner);
404     }
405 }
406 
407 // File: @openzeppelin/contracts/utils/Address.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @dev Collection of functions related to the address type
416  */
417 library Address {
418     /**
419      * @dev Returns true if `account` is a contract.
420      *
421      * [IMPORTANT]
422      * ====
423      * It is unsafe to assume that an address for which this function returns
424      * false is an externally-owned account (EOA) and not a contract.
425      *
426      * Among others, `isContract` will return false for the following
427      * types of addresses:
428      *
429      *  - an externally-owned account
430      *  - a contract in construction
431      *  - an address where a contract will be created
432      *  - an address where a contract lived, but was destroyed
433      * ====
434      */
435     function isContract(address account) internal view returns (bool) {
436         // This method relies on extcodesize, which returns 0 for contracts in
437         // construction, since the code is only stored at the end of the
438         // constructor execution.
439 
440         uint256 size;
441         assembly {
442             size := extcodesize(account)
443         }
444         return size > 0;
445     }
446 
447     /**
448      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
449      * `recipient`, forwarding all available gas and reverting on errors.
450      *
451      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
452      * of certain opcodes, possibly making contracts go over the 2300 gas limit
453      * imposed by `transfer`, making them unable to receive funds via
454      * `transfer`. {sendValue} removes this limitation.
455      *
456      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
457      *
458      * IMPORTANT: because control is transferred to `recipient`, care must be
459      * taken to not create reentrancy vulnerabilities. Consider using
460      * {ReentrancyGuard} or the
461      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
462      */
463     function sendValue(address payable recipient, uint256 amount) internal {
464         require(address(this).balance >= amount, "Address: insufficient balance");
465 
466         (bool success, ) = recipient.call{value: amount}("");
467         require(success, "Address: unable to send value, recipient may have reverted");
468     }
469 
470     /**
471      * @dev Performs a Solidity function call using a low level `call`. A
472      * plain `call` is an unsafe replacement for a function call: use this
473      * function instead.
474      *
475      * If `target` reverts with a revert reason, it is bubbled up by this
476      * function (like regular Solidity function calls).
477      *
478      * Returns the raw returned data. To convert to the expected return value,
479      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
480      *
481      * Requirements:
482      *
483      * - `target` must be a contract.
484      * - calling `target` with `data` must not revert.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
489         return functionCall(target, data, "Address: low-level call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
494      * `errorMessage` as a fallback revert reason when `target` reverts.
495      *
496      * _Available since v3.1._
497      */
498     function functionCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, 0, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but also transferring `value` wei to `target`.
509      *
510      * Requirements:
511      *
512      * - the calling contract must have an ETH balance of at least `value`.
513      * - the called Solidity function must be `payable`.
514      *
515      * _Available since v3.1._
516      */
517     function functionCallWithValue(
518         address target,
519         bytes memory data,
520         uint256 value
521     ) internal returns (bytes memory) {
522         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
527      * with `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(
532         address target,
533         bytes memory data,
534         uint256 value,
535         string memory errorMessage
536     ) internal returns (bytes memory) {
537         require(address(this).balance >= value, "Address: insufficient balance for call");
538         require(isContract(target), "Address: call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.call{value: value}(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
551         return functionStaticCall(target, data, "Address: low-level static call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
556      * but performing a static call.
557      *
558      * _Available since v3.3._
559      */
560     function functionStaticCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal view returns (bytes memory) {
565         require(isContract(target), "Address: static call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.staticcall(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but performing a delegate call.
574      *
575      * _Available since v3.4._
576      */
577     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
578         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(
588         address target,
589         bytes memory data,
590         string memory errorMessage
591     ) internal returns (bytes memory) {
592         require(isContract(target), "Address: delegate call to non-contract");
593 
594         (bool success, bytes memory returndata) = target.delegatecall(data);
595         return verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
600      * revert reason using the provided one.
601      *
602      * _Available since v4.3._
603      */
604     function verifyCallResult(
605         bool success,
606         bytes memory returndata,
607         string memory errorMessage
608     ) internal pure returns (bytes memory) {
609         if (success) {
610             return returndata;
611         } else {
612             // Look for revert reason and bubble it up if present
613             if (returndata.length > 0) {
614                 // The easiest way to bubble the revert reason is using memory via assembly
615 
616                 assembly {
617                     let returndata_size := mload(returndata)
618                     revert(add(32, returndata), returndata_size)
619                 }
620             } else {
621                 revert(errorMessage);
622             }
623         }
624     }
625 }
626 
627 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @title ERC721 token receiver interface
636  * @dev Interface for any contract that wants to support safeTransfers
637  * from ERC721 asset contracts.
638  */
639 interface IERC721Receiver {
640     /**
641      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
642      * by `operator` from `from`, this function is called.
643      *
644      * It must return its Solidity selector to confirm the token transfer.
645      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
646      *
647      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
648      */
649     function onERC721Received(
650         address operator,
651         address from,
652         uint256 tokenId,
653         bytes calldata data
654     ) external returns (bytes4);
655 }
656 
657 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
658 
659 
660 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @dev Interface of the ERC165 standard, as defined in the
666  * https://eips.ethereum.org/EIPS/eip-165[EIP].
667  *
668  * Implementers can declare support of contract interfaces, which can then be
669  * queried by others ({ERC165Checker}).
670  *
671  * For an implementation, see {ERC165}.
672  */
673 interface IERC165 {
674     /**
675      * @dev Returns true if this contract implements the interface defined by
676      * `interfaceId`. See the corresponding
677      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
678      * to learn more about how these ids are created.
679      *
680      * This function call must use less than 30 000 gas.
681      */
682     function supportsInterface(bytes4 interfaceId) external view returns (bool);
683 }
684 
685 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 /**
694  * @dev Implementation of the {IERC165} interface.
695  *
696  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
697  * for the additional interface id that will be supported. For example:
698  *
699  * ```solidity
700  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
701  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
702  * }
703  * ```
704  *
705  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
706  */
707 abstract contract ERC165 is IERC165 {
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
712         return interfaceId == type(IERC165).interfaceId;
713     }
714 }
715 
716 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
717 
718 
719 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 
724 /**
725  * @dev Required interface of an ERC721 compliant contract.
726  */
727 interface IERC721 is IERC165 {
728     /**
729      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
730      */
731     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
732 
733     /**
734      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
735      */
736     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
737 
738     /**
739      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
740      */
741     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
742 
743     /**
744      * @dev Returns the number of tokens in ``owner``'s account.
745      */
746     function balanceOf(address owner) external view returns (uint256 balance);
747 
748     /**
749      * @dev Returns the owner of the `tokenId` token.
750      *
751      * Requirements:
752      *
753      * - `tokenId` must exist.
754      */
755     function ownerOf(uint256 tokenId) external view returns (address owner);
756 
757     /**
758      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
759      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must exist and be owned by `from`.
766      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
768      *
769      * Emits a {Transfer} event.
770      */
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) external;
776 
777     /**
778      * @dev Transfers `tokenId` token from `from` to `to`.
779      *
780      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
781      *
782      * Requirements:
783      *
784      * - `from` cannot be the zero address.
785      * - `to` cannot be the zero address.
786      * - `tokenId` token must be owned by `from`.
787      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
788      *
789      * Emits a {Transfer} event.
790      */
791     function transferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) external;
796 
797     /**
798      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
799      * The approval is cleared when the token is transferred.
800      *
801      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
802      *
803      * Requirements:
804      *
805      * - The caller must own the token or be an approved operator.
806      * - `tokenId` must exist.
807      *
808      * Emits an {Approval} event.
809      */
810     function approve(address to, uint256 tokenId) external;
811 
812     /**
813      * @dev Returns the account approved for `tokenId` token.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function getApproved(uint256 tokenId) external view returns (address operator);
820 
821     /**
822      * @dev Approve or remove `operator` as an operator for the caller.
823      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
824      *
825      * Requirements:
826      *
827      * - The `operator` cannot be the caller.
828      *
829      * Emits an {ApprovalForAll} event.
830      */
831     function setApprovalForAll(address operator, bool _approved) external;
832 
833     /**
834      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
835      *
836      * See {setApprovalForAll}
837      */
838     function isApprovedForAll(address owner, address operator) external view returns (bool);
839 
840     /**
841      * @dev Safely transfers `tokenId` token from `from` to `to`.
842      *
843      * Requirements:
844      *
845      * - `from` cannot be the zero address.
846      * - `to` cannot be the zero address.
847      * - `tokenId` token must exist and be owned by `from`.
848      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
849      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
850      *
851      * Emits a {Transfer} event.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId,
857         bytes calldata data
858     ) external;
859 }
860 
861 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
862 
863 
864 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
865 
866 pragma solidity ^0.8.0;
867 
868 
869 /**
870  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
871  * @dev See https://eips.ethereum.org/EIPS/eip-721
872  */
873 interface IERC721Enumerable is IERC721 {
874     /**
875      * @dev Returns the total amount of tokens stored by the contract.
876      */
877     function totalSupply() external view returns (uint256);
878 
879     /**
880      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
881      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
882      */
883     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
884 
885     /**
886      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
887      * Use along with {totalSupply} to enumerate all tokens.
888      */
889     function tokenByIndex(uint256 index) external view returns (uint256);
890 }
891 
892 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
893 
894 
895 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 
900 /**
901  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
902  * @dev See https://eips.ethereum.org/EIPS/eip-721
903  */
904 interface IERC721Metadata is IERC721 {
905     /**
906      * @dev Returns the token collection name.
907      */
908     function name() external view returns (string memory);
909 
910     /**
911      * @dev Returns the token collection symbol.
912      */
913     function symbol() external view returns (string memory);
914 
915     /**
916      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
917      */
918     function tokenURI(uint256 tokenId) external view returns (string memory);
919 }
920 
921 // File: ERC721A/ERC721A.sol
922 
923 
924 
925 // Creator: Chiru Labs
926 
927 
928 
929 pragma solidity ^0.8.4;
930 
931 
932 
933 
934 
935 
936 
937 
938 
939 
940 
941 error ApprovalCallerNotOwnerNorApproved();
942 
943 error ApprovalQueryForNonexistentToken();
944 
945 error ApproveToCaller();
946 
947 error ApprovalToCurrentOwner();
948 
949 error BalanceQueryForZeroAddress();
950 
951 error MintedQueryForZeroAddress();
952 
953 error BurnedQueryForZeroAddress();
954 
955 error AuxQueryForZeroAddress();
956 
957 error MintToZeroAddress();
958 
959 error MintZeroQuantity();
960 
961 error OwnerIndexOutOfBounds();
962 
963 error OwnerQueryForNonexistentToken();
964 
965 error TokenIndexOutOfBounds();
966 
967 error TransferCallerNotOwnerNorApproved();
968 
969 error TransferFromIncorrectOwner();
970 
971 error TransferToNonERC721ReceiverImplementer();
972 
973 error TransferToZeroAddress();
974 
975 error URIQueryForNonexistentToken();
976 
977 
978 
979 /**
980 
981  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
982 
983  * the Metadata extension. Built to optimize for lower gas during batch mints.
984 
985  *
986 
987  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
988 
989  *
990 
991  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
992 
993  *
994 
995  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
996 
997  */
998 
999 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1000 
1001     using Address for address;
1002 
1003     using Strings for uint256;
1004 
1005 
1006 
1007     // Compiler will pack this into a single 256bit word.
1008 
1009     struct TokenOwnership {
1010 
1011         // The address of the owner.
1012 
1013         address addr;
1014 
1015         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1016 
1017         uint64 startTimestamp;
1018 
1019         // Whether the token has been burned.
1020 
1021         bool burned;
1022 
1023     }
1024 
1025 
1026 
1027     // Compiler will pack this into a single 256bit word.
1028 
1029     struct AddressData {
1030 
1031         // Realistically, 2**64-1 is more than enough.
1032 
1033         uint64 balance;
1034 
1035         // Keeps track of mint count with minimal overhead for tokenomics.
1036 
1037         uint64 numberMinted;
1038 
1039         // Keeps track of burn count with minimal overhead for tokenomics.
1040 
1041         uint64 numberBurned;
1042 
1043         // For miscellaneous variable(s) pertaining to the address
1044 
1045         // (e.g. number of whitelist mint slots used).
1046 
1047         // If there are multiple variables, please pack them into a uint64.
1048 
1049         uint64 aux;
1050 
1051     }
1052 
1053 
1054 
1055     // The tokenId of the next token to be minted.
1056 
1057     uint256 internal _currentIndex;
1058 
1059 
1060 
1061     // The number of tokens burned.
1062 
1063     uint256 internal _burnCounter;
1064 
1065 
1066 
1067     // Token name
1068 
1069     string private _name;
1070 
1071 
1072 
1073     // Token symbol
1074 
1075     string private _symbol;
1076 
1077 
1078 
1079     // Mapping from token ID to ownership details
1080 
1081     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1082 
1083     mapping(uint256 => TokenOwnership) internal _ownerships;
1084 
1085 
1086 
1087     // Mapping owner address to address data
1088 
1089     mapping(address => AddressData) private _addressData;
1090 
1091 
1092 
1093     // Mapping from token ID to approved address
1094 
1095     mapping(uint256 => address) private _tokenApprovals;
1096 
1097 
1098 
1099     // Mapping from owner to operator approvals
1100 
1101     mapping(address => mapping(address => bool)) private _operatorApprovals;
1102 
1103 
1104 
1105     constructor(string memory name_, string memory symbol_) {
1106 
1107         _name = name_;
1108 
1109         _symbol = symbol_;
1110 
1111         _currentIndex = _startTokenId();
1112 
1113     }
1114 
1115 
1116 
1117     /**
1118 
1119      * To change the starting tokenId, please override this function.
1120 
1121      */
1122 
1123     function _startTokenId() internal view virtual returns (uint256) {
1124 
1125         return 0;
1126 
1127     }
1128 
1129 
1130 
1131     /**
1132 
1133      * @dev See {IERC721Enumerable-totalSupply}.
1134 
1135      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1136 
1137      */
1138 
1139     function totalSupply() public view returns (uint256) {
1140 
1141         // Counter underflow is impossible as _burnCounter cannot be incremented
1142 
1143         // more than _currentIndex - _startTokenId() times
1144 
1145         unchecked {
1146 
1147             return _currentIndex - _burnCounter - _startTokenId();
1148 
1149         }
1150 
1151     }
1152 
1153 
1154 
1155     /**
1156 
1157      * Returns the total amount of tokens minted in the contract.
1158 
1159      */
1160 
1161     function _totalMinted() internal view returns (uint256) {
1162 
1163         // Counter underflow is impossible as _currentIndex does not decrement,
1164 
1165         // and it is initialized to _startTokenId()
1166 
1167         unchecked {
1168 
1169             return _currentIndex - _startTokenId();
1170 
1171         }
1172 
1173     }
1174 
1175 
1176 
1177     /**
1178 
1179      * @dev See {IERC165-supportsInterface}.
1180 
1181      */
1182 
1183     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1184 
1185         return
1186 
1187             interfaceId == type(IERC721).interfaceId ||
1188 
1189             interfaceId == type(IERC721Metadata).interfaceId ||
1190 
1191             super.supportsInterface(interfaceId);
1192 
1193     }
1194 
1195 
1196 
1197     /**
1198 
1199      * @dev See {IERC721-balanceOf}.
1200 
1201      */
1202 
1203     function balanceOf(address owner) public view override returns (uint256) {
1204 
1205         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1206 
1207         return uint256(_addressData[owner].balance);
1208 
1209     }
1210 
1211 
1212 
1213     /**
1214 
1215      * Returns the number of tokens minted by `owner`.
1216 
1217      */
1218 
1219     function _numberMinted(address owner) internal view returns (uint256) {
1220 
1221         if (owner == address(0)) revert MintedQueryForZeroAddress();
1222 
1223         return uint256(_addressData[owner].numberMinted);
1224 
1225     }
1226 
1227 
1228 
1229     /**
1230 
1231      * Returns the number of tokens burned by or on behalf of `owner`.
1232 
1233      */
1234 
1235     function _numberBurned(address owner) internal view returns (uint256) {
1236 
1237         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1238 
1239         return uint256(_addressData[owner].numberBurned);
1240 
1241     }
1242 
1243 
1244 
1245     /**
1246 
1247      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1248 
1249      */
1250 
1251     function _getAux(address owner) internal view returns (uint64) {
1252 
1253         if (owner == address(0)) revert AuxQueryForZeroAddress();
1254 
1255         return _addressData[owner].aux;
1256 
1257     }
1258 
1259 
1260 
1261     /**
1262 
1263      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1264 
1265      * If there are multiple variables, please pack them into a uint64.
1266 
1267      */
1268 
1269     function _setAux(address owner, uint64 aux) internal {
1270 
1271         if (owner == address(0)) revert AuxQueryForZeroAddress();
1272 
1273         _addressData[owner].aux = aux;
1274 
1275     }
1276 
1277 
1278 
1279     /**
1280 
1281      * Gas spent here starts off proportional to the maximum mint batch size.
1282 
1283      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1284 
1285      */
1286 
1287     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1288 
1289         uint256 curr = tokenId;
1290 
1291 
1292 
1293         unchecked {
1294 
1295             if (_startTokenId() <= curr && curr < _currentIndex) {
1296 
1297                 TokenOwnership memory ownership = _ownerships[curr];
1298 
1299                 if (!ownership.burned) {
1300 
1301                     if (ownership.addr != address(0)) {
1302 
1303                         return ownership;
1304 
1305                     }
1306 
1307                     // Invariant:
1308 
1309                     // There will always be an ownership that has an address and is not burned
1310 
1311                     // before an ownership that does not have an address and is not burned.
1312 
1313                     // Hence, curr will not underflow.
1314 
1315                     while (true) {
1316 
1317                         curr--;
1318 
1319                         ownership = _ownerships[curr];
1320 
1321                         if (ownership.addr != address(0)) {
1322 
1323                             return ownership;
1324 
1325                         }
1326 
1327                     }
1328 
1329                 }
1330 
1331             }
1332 
1333         }
1334 
1335         revert OwnerQueryForNonexistentToken();
1336 
1337     }
1338 
1339 
1340 
1341     /**
1342 
1343      * @dev See {IERC721-ownerOf}.
1344 
1345      */
1346 
1347     function ownerOf(uint256 tokenId) public view override returns (address) {
1348 
1349         return ownershipOf(tokenId).addr;
1350 
1351     }
1352 
1353 
1354 
1355     /**
1356 
1357      * @dev See {IERC721Metadata-name}.
1358 
1359      */
1360 
1361     function name() public view virtual override returns (string memory) {
1362 
1363         return _name;
1364 
1365     }
1366 
1367 
1368 
1369     /**
1370 
1371      * @dev See {IERC721Metadata-symbol}.
1372 
1373      */
1374 
1375     function symbol() public view virtual override returns (string memory) {
1376 
1377         return _symbol;
1378 
1379     }
1380 
1381 
1382 
1383     /**
1384 
1385      * @dev See {IERC721Metadata-tokenURI}.
1386 
1387      */
1388 
1389     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1390 
1391         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1392 
1393 
1394 
1395         string memory baseURI = _baseURI();
1396 
1397         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1398 
1399     }
1400 
1401 
1402 
1403     /**
1404 
1405      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1406 
1407      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1408 
1409      * by default, can be overriden in child contracts.
1410 
1411      */
1412 
1413     function _baseURI() internal view virtual returns (string memory) {
1414 
1415         return '';
1416 
1417     }
1418 
1419 
1420 
1421     /**
1422 
1423      * @dev See {IERC721-approve}.
1424 
1425      */
1426 
1427     function approve(address to, uint256 tokenId) public override {
1428 
1429         address owner = ERC721A.ownerOf(tokenId);
1430 
1431         if (to == owner) revert ApprovalToCurrentOwner();
1432 
1433 
1434 
1435         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1436 
1437             revert ApprovalCallerNotOwnerNorApproved();
1438 
1439         }
1440 
1441 
1442 
1443         _approve(to, tokenId, owner);
1444 
1445     }
1446 
1447 
1448 
1449     /**
1450 
1451      * @dev See {IERC721-getApproved}.
1452 
1453      */
1454 
1455     function getApproved(uint256 tokenId) public view override returns (address) {
1456 
1457         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1458 
1459 
1460 
1461         return _tokenApprovals[tokenId];
1462 
1463     }
1464 
1465 
1466 
1467     /**
1468 
1469      * @dev See {IERC721-setApprovalForAll}.
1470 
1471      */
1472 
1473     function setApprovalForAll(address operator, bool approved) public virtual override {
1474 
1475         if (operator == _msgSender()) revert ApproveToCaller();
1476 
1477 
1478 
1479         _operatorApprovals[_msgSender()][operator] = approved;
1480 
1481         emit ApprovalForAll(_msgSender(), operator, approved);
1482 
1483     }
1484 
1485 
1486 
1487     /**
1488 
1489      * @dev See {IERC721-isApprovedForAll}.
1490 
1491      */
1492 
1493     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1494 
1495         return _operatorApprovals[owner][operator];
1496 
1497     }
1498 
1499 
1500 
1501     /**
1502 
1503      * @dev See {IERC721-transferFrom}.
1504 
1505      */
1506 
1507     function transferFrom(
1508 
1509         address from,
1510 
1511         address to,
1512 
1513         uint256 tokenId
1514 
1515     ) public virtual override {
1516 
1517         _transfer(from, to, tokenId);
1518 
1519     }
1520 
1521 
1522 
1523     /**
1524 
1525      * @dev See {IERC721-safeTransferFrom}.
1526 
1527      */
1528 
1529     function safeTransferFrom(
1530 
1531         address from,
1532 
1533         address to,
1534 
1535         uint256 tokenId
1536 
1537     ) public virtual override {
1538 
1539         safeTransferFrom(from, to, tokenId, '');
1540 
1541     }
1542 
1543 
1544 
1545     /**
1546 
1547      * @dev See {IERC721-safeTransferFrom}.
1548 
1549      */
1550 
1551     function safeTransferFrom(
1552 
1553         address from,
1554 
1555         address to,
1556 
1557         uint256 tokenId,
1558 
1559         bytes memory _data
1560 
1561     ) public virtual override {
1562 
1563         _transfer(from, to, tokenId);
1564 
1565         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1566 
1567             revert TransferToNonERC721ReceiverImplementer();
1568 
1569         }
1570 
1571     }
1572 
1573 
1574 
1575     /**
1576 
1577      * @dev Returns whether `tokenId` exists.
1578 
1579      *
1580 
1581      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1582 
1583      *
1584 
1585      * Tokens start existing when they are minted (`_mint`),
1586 
1587      */
1588 
1589     function _exists(uint256 tokenId) internal view returns (bool) {
1590 
1591         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1592 
1593             !_ownerships[tokenId].burned;
1594 
1595     }
1596 
1597 
1598 
1599     function _safeMint(address to, uint256 quantity) internal {
1600 
1601         _safeMint(to, quantity, '');
1602 
1603     }
1604 
1605 
1606 
1607     /**
1608 
1609      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1610 
1611      *
1612 
1613      * Requirements:
1614 
1615      *
1616 
1617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1618 
1619      * - `quantity` must be greater than 0.
1620 
1621      *
1622 
1623      * Emits a {Transfer} event.
1624 
1625      */
1626 
1627     function _safeMint(
1628 
1629         address to,
1630 
1631         uint256 quantity,
1632 
1633         bytes memory _data
1634 
1635     ) internal {
1636 
1637         _mint(to, quantity, _data, true);
1638 
1639     }
1640 
1641 
1642 
1643     /**
1644 
1645      * @dev Mints `quantity` tokens and transfers them to `to`.
1646 
1647      *
1648 
1649      * Requirements:
1650 
1651      *
1652 
1653      * - `to` cannot be the zero address.
1654 
1655      * - `quantity` must be greater than 0.
1656 
1657      *
1658 
1659      * Emits a {Transfer} event.
1660 
1661      */
1662 
1663     function _mint(
1664 
1665         address to,
1666 
1667         uint256 quantity,
1668 
1669         bytes memory _data,
1670 
1671         bool safe
1672 
1673     ) internal {
1674 
1675         uint256 startTokenId = _currentIndex;
1676 
1677         if (to == address(0)) revert MintToZeroAddress();
1678 
1679         if (quantity == 0) revert MintZeroQuantity();
1680 
1681 
1682 
1683         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1684 
1685 
1686 
1687         // Overflows are incredibly unrealistic.
1688 
1689         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1690 
1691         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1692 
1693         unchecked {
1694 
1695             _addressData[to].balance += uint64(quantity);
1696 
1697             _addressData[to].numberMinted += uint64(quantity);
1698 
1699 
1700 
1701             _ownerships[startTokenId].addr = to;
1702 
1703             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1704 
1705 
1706 
1707             uint256 updatedIndex = startTokenId;
1708 
1709             uint256 end = updatedIndex + quantity;
1710 
1711 
1712 
1713             if (safe && to.isContract()) {
1714 
1715                 do {
1716 
1717                     emit Transfer(address(0), to, updatedIndex);
1718 
1719                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1720 
1721                         revert TransferToNonERC721ReceiverImplementer();
1722 
1723                     }
1724 
1725                 } while (updatedIndex != end);
1726 
1727                 // Reentrancy protection
1728 
1729                 if (_currentIndex != startTokenId) revert();
1730 
1731             } else {
1732 
1733                 do {
1734 
1735                     emit Transfer(address(0), to, updatedIndex++);
1736 
1737                 } while (updatedIndex != end);
1738 
1739             }
1740 
1741             _currentIndex = updatedIndex;
1742 
1743         }
1744 
1745         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1746 
1747     }
1748 
1749 
1750 
1751     /**
1752 
1753      * @dev Transfers `tokenId` from `from` to `to`.
1754 
1755      *
1756 
1757      * Requirements:
1758 
1759      *
1760 
1761      * - `to` cannot be the zero address.
1762 
1763      * - `tokenId` token must be owned by `from`.
1764 
1765      *
1766 
1767      * Emits a {Transfer} event.
1768 
1769      */
1770 
1771     function _transfer(
1772 
1773         address from,
1774 
1775         address to,
1776 
1777         uint256 tokenId
1778 
1779     ) private {
1780 
1781         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1782 
1783 
1784 
1785         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1786 
1787             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1788 
1789             getApproved(tokenId) == _msgSender());
1790 
1791 
1792 
1793         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1794 
1795         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1796 
1797         if (to == address(0)) revert TransferToZeroAddress();
1798 
1799 
1800 
1801         _beforeTokenTransfers(from, to, tokenId, 1);
1802 
1803 
1804 
1805         // Clear approvals from the previous owner
1806 
1807         _approve(address(0), tokenId, prevOwnership.addr);
1808 
1809 
1810 
1811         // Underflow of the sender's balance is impossible because we check for
1812 
1813         // ownership above and the recipient's balance can't realistically overflow.
1814 
1815         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1816 
1817         unchecked {
1818 
1819             _addressData[from].balance -= 1;
1820 
1821             _addressData[to].balance += 1;
1822 
1823 
1824 
1825             _ownerships[tokenId].addr = to;
1826 
1827             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1828 
1829 
1830 
1831             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1832 
1833             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1834 
1835             uint256 nextTokenId = tokenId + 1;
1836 
1837             if (_ownerships[nextTokenId].addr == address(0)) {
1838 
1839                 // This will suffice for checking _exists(nextTokenId),
1840 
1841                 // as a burned slot cannot contain the zero address.
1842 
1843                 if (nextTokenId < _currentIndex) {
1844 
1845                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1846 
1847                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1848 
1849                 }
1850 
1851             }
1852 
1853         }
1854 
1855 
1856 
1857         emit Transfer(from, to, tokenId);
1858 
1859         _afterTokenTransfers(from, to, tokenId, 1);
1860 
1861     }
1862 
1863 
1864 
1865     /**
1866 
1867      * @dev Destroys `tokenId`.
1868 
1869      * The approval is cleared when the token is burned.
1870 
1871      *
1872 
1873      * Requirements:
1874 
1875      *
1876 
1877      * - `tokenId` must exist.
1878 
1879      *
1880 
1881      * Emits a {Transfer} event.
1882 
1883      */
1884 
1885     function _burn(uint256 tokenId) internal virtual {
1886 
1887         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1888 
1889 
1890 
1891         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1892 
1893 
1894 
1895         // Clear approvals from the previous owner
1896 
1897         _approve(address(0), tokenId, prevOwnership.addr);
1898 
1899 
1900 
1901         // Underflow of the sender's balance is impossible because we check for
1902 
1903         // ownership above and the recipient's balance can't realistically overflow.
1904 
1905         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1906 
1907         unchecked {
1908 
1909             _addressData[prevOwnership.addr].balance -= 1;
1910 
1911             _addressData[prevOwnership.addr].numberBurned += 1;
1912 
1913 
1914 
1915             // Keep track of who burned the token, and the timestamp of burning.
1916 
1917             _ownerships[tokenId].addr = prevOwnership.addr;
1918 
1919             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1920 
1921             _ownerships[tokenId].burned = true;
1922 
1923 
1924 
1925             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1926 
1927             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1928 
1929             uint256 nextTokenId = tokenId + 1;
1930 
1931             if (_ownerships[nextTokenId].addr == address(0)) {
1932 
1933                 // This will suffice for checking _exists(nextTokenId),
1934 
1935                 // as a burned slot cannot contain the zero address.
1936 
1937                 if (nextTokenId < _currentIndex) {
1938 
1939                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1940 
1941                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1942 
1943                 }
1944 
1945             }
1946 
1947         }
1948 
1949 
1950 
1951         emit Transfer(prevOwnership.addr, address(0), tokenId);
1952 
1953         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1954 
1955 
1956 
1957         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1958 
1959         unchecked {
1960 
1961             _burnCounter++;
1962 
1963         }
1964 
1965     }
1966 
1967 
1968 
1969     /**
1970 
1971      * @dev Approve `to` to operate on `tokenId`
1972 
1973      *
1974 
1975      * Emits a {Approval} event.
1976 
1977      */
1978 
1979     function _approve(
1980 
1981         address to,
1982 
1983         uint256 tokenId,
1984 
1985         address owner
1986 
1987     ) private {
1988 
1989         _tokenApprovals[tokenId] = to;
1990 
1991         emit Approval(owner, to, tokenId);
1992 
1993     }
1994 
1995 
1996 
1997     /**
1998 
1999      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2000 
2001      *
2002 
2003      * @param from address representing the previous owner of the given token ID
2004 
2005      * @param to target address that will receive the tokens
2006 
2007      * @param tokenId uint256 ID of the token to be transferred
2008 
2009      * @param _data bytes optional data to send along with the call
2010 
2011      * @return bool whether the call correctly returned the expected magic value
2012 
2013      */
2014 
2015     function _checkContractOnERC721Received(
2016 
2017         address from,
2018 
2019         address to,
2020 
2021         uint256 tokenId,
2022 
2023         bytes memory _data
2024 
2025     ) private returns (bool) {
2026 
2027         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2028 
2029             return retval == IERC721Receiver(to).onERC721Received.selector;
2030 
2031         } catch (bytes memory reason) {
2032 
2033             if (reason.length == 0) {
2034 
2035                 revert TransferToNonERC721ReceiverImplementer();
2036 
2037             } else {
2038 
2039                 assembly {
2040 
2041                     revert(add(32, reason), mload(reason))
2042 
2043                 }
2044 
2045             }
2046 
2047         }
2048 
2049     }
2050 
2051 
2052 
2053     /**
2054 
2055      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2056 
2057      * And also called before burning one token.
2058 
2059      *
2060 
2061      * startTokenId - the first token id to be transferred
2062 
2063      * quantity - the amount to be transferred
2064 
2065      *
2066 
2067      * Calling conditions:
2068 
2069      *
2070 
2071      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2072 
2073      * transferred to `to`.
2074 
2075      * - When `from` is zero, `tokenId` will be minted for `to`.
2076 
2077      * - When `to` is zero, `tokenId` will be burned by `from`.
2078 
2079      * - `from` and `to` are never both zero.
2080 
2081      */
2082 
2083     function _beforeTokenTransfers(
2084 
2085         address from,
2086 
2087         address to,
2088 
2089         uint256 startTokenId,
2090 
2091         uint256 quantity
2092 
2093     ) internal virtual {}
2094 
2095 
2096 
2097     /**
2098 
2099      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2100 
2101      * minting.
2102 
2103      * And also called after one token has been burned.
2104 
2105      *
2106 
2107      * startTokenId - the first token id to be transferred
2108 
2109      * quantity - the amount to be transferred
2110 
2111      *
2112 
2113      * Calling conditions:
2114 
2115      *
2116 
2117      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2118 
2119      * transferred to `to`.
2120 
2121      * - When `from` is zero, `tokenId` has been minted for `to`.
2122 
2123      * - When `to` is zero, `tokenId` has been burned by `from`.
2124 
2125      * - `from` and `to` are never both zero.
2126 
2127      */
2128 
2129     function _afterTokenTransfers(
2130 
2131         address from,
2132 
2133         address to,
2134 
2135         uint256 startTokenId,
2136 
2137         uint256 quantity
2138 
2139     ) internal virtual {}
2140 
2141 }
2142 
2143 
2144 // File: contracts/MutantWolfPack.sol
2145 
2146 
2147 
2148 pragma solidity 0.8.10;
2149 
2150 
2151 
2152 
2153 
2154 
2155 contract MutantWolfPack is Ownable, ERC721A{
2156 
2157     using Strings for uint256;
2158 
2159     using SafeMath for uint256;
2160 
2161 
2162 
2163     //Configuration  //editable
2164 
2165     bool       public isFreemint;
2166 
2167     bool       public isPublicSale;
2168 
2169 
2170 
2171     uint256    public max_supply              = 3000;
2172 
2173 
2174 
2175     uint256    public freemint_qty            = 300;
2176 
2177     uint256    public reserved_qty            = 20;
2178 
2179 
2180 
2181     uint256    public maxMintsPerTransaction  = 5;
2182 
2183     uint256    public freeMintPerWallet       = 2;
2184 
2185 
2186 
2187     uint256    public publicsale_price        = 0.025 ether;
2188 
2189     
2190 
2191     address    public proxyRegistryAddress;
2192 
2193     address    public signer;
2194 
2195 
2196 
2197     string     public baseExtension           = "";
2198 
2199     string     private __baseURI;
2200 
2201 
2202 
2203     //Distribution //editable
2204 
2205     uint256 public lastIndexPrimary;
2206 
2207     uint256 public lastIndexTeam;
2208 
2209 
2210 
2211     mapping(uint256 => uint256) public percentage;
2212 
2213     mapping(uint256 => address) public recipient;
2214 
2215 
2216 
2217     //DB
2218 
2219     mapping(address => uint256) public mintedOnFreemint;
2220 
2221 
2222 
2223     event Mint(address indexed sender, uint256 indexed type_mint, uint256 timestamp);
2224 
2225     
2226 
2227     constructor(
2228 
2229         string memory ___baseURI,
2230 
2231         address _signer,
2232 
2233         address _proxyRegistryAddress,
2234 
2235 
2236 
2237         uint256[] memory _primaryPercentage,
2238 
2239         address[] memory _primaryReceipient,
2240 
2241         uint256[] memory _split,
2242 
2243         address[] memory _addressTeam
2244 
2245     )
2246 
2247     ERC721A("Mutant Wolf Pack", "MWP")
2248 
2249     {
2250 
2251         __baseURI = ___baseURI;
2252 
2253         signer = _signer;
2254 
2255         proxyRegistryAddress = _proxyRegistryAddress;
2256 
2257 
2258 
2259         _setDistribution(
2260 
2261             _primaryPercentage,
2262 
2263             _primaryReceipient,
2264 
2265             _split,
2266 
2267             _addressTeam
2268 
2269         );
2270 
2271     }    
2272 
2273 
2274 
2275     //General Part
2276 
2277     function _startTokenId() internal view virtual override returns (uint256) {
2278 
2279         return 1;
2280 
2281     }
2282 
2283     
2284 
2285     function _baseURI() internal view virtual override returns (string memory) {
2286 
2287         return __baseURI;
2288 
2289     }
2290 
2291     
2292 
2293     function baseURI() public view returns(string memory){
2294 
2295         return _baseURI();
2296 
2297     }
2298 
2299     
2300 
2301     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
2302 
2303         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2304 
2305 
2306 
2307         string memory ___baseURI = _baseURI();
2308 
2309         return bytes(___baseURI).length > 0 ? string(abi.encodePacked(___baseURI, _tokenId.toString(), baseExtension)) : "";
2310 
2311     }
2312 
2313 
2314 
2315     //Set Configuration Part
2316 
2317     //1
2318 
2319     function setBaseURI(string memory _baseURIArg) external onlyOwner {
2320 
2321         __baseURI = _baseURIArg;
2322 
2323     }
2324 
2325 
2326 
2327     //2
2328 
2329     function setMaxSupply(uint _maxSupply) external onlyOwner {
2330 
2331         max_supply = _maxSupply;
2332 
2333     }
2334 
2335 
2336 
2337     //3
2338 
2339     function setMaxMintsPerTransaction(uint _maxMintsPerTransaction) external onlyOwner {
2340 
2341         maxMintsPerTransaction = _maxMintsPerTransaction;
2342 
2343     }
2344 
2345 
2346 
2347     //4
2348 
2349     function setSigner(address _signer) external onlyOwner {
2350 
2351         signer = _signer;
2352 
2353     }
2354 
2355     
2356 
2357     //5
2358 
2359     function setBaseExtension(string memory _baseExt) external onlyOwner {
2360 
2361         baseExtension =  _baseExt;
2362 
2363     }
2364 
2365 
2366 
2367     //6
2368 
2369     function setPublicSaleActive() external onlyOwner{
2370 
2371         if(isPublicSale == false){
2372 
2373             isPublicSale = true;
2374 
2375         }
2376 
2377         else{
2378 
2379             isPublicSale = false;
2380 
2381         }
2382 
2383     }
2384 
2385     
2386 
2387     //7
2388 
2389     function setProxy(address _proxy) external onlyOwner {
2390 
2391         proxyRegistryAddress =  _proxy;
2392 
2393     }
2394 
2395 
2396 
2397     //8
2398 
2399     function setPublicSalePrice(uint256 _price) external onlyOwner{
2400 
2401         publicsale_price = _price;
2402 
2403     }
2404 
2405 
2406 
2407     //9
2408 
2409     function setFreeMintLimit(uint256 _limit) external onlyOwner{
2410 
2411         freeMintPerWallet = _limit;
2412 
2413     }
2414 
2415 
2416 
2417     //10
2418 
2419     function setFreeMintQTY(uint256 _qty) external onlyOwner{
2420 
2421         freemint_qty = _qty;
2422 
2423     }
2424 
2425 
2426 
2427     //11
2428 
2429     function setReservedQTY(uint256 _qty) external onlyOwner{
2430 
2431         reserved_qty = _qty;
2432 
2433     }
2434 
2435 
2436 
2437     //12
2438 
2439     function setFreeMintActive() external onlyOwner{
2440 
2441         if(isFreemint == false){
2442 
2443             isFreemint = true;
2444 
2445         }
2446 
2447         else{
2448 
2449             isFreemint = false;
2450 
2451         }
2452 
2453     }
2454 
2455 
2456 
2457     //13
2458 
2459     function setDistribution(
2460 
2461         uint256[] memory _primaryPercentage,
2462 
2463         address[] memory _primaryReceipient,
2464 
2465         uint256[] memory _split,
2466 
2467         address[] memory _addressTeam
2468 
2469     ) external onlyOwner{
2470 
2471         _setDistribution(
2472 
2473             _primaryPercentage,
2474 
2475             _primaryReceipient,
2476 
2477             _split,
2478 
2479             _addressTeam
2480 
2481         );
2482 
2483     }
2484 
2485 
2486 
2487     //Internal
2488 
2489     function _setDistribution(
2490 
2491         uint256[] memory _primaryPercentage,
2492 
2493         address[] memory _primaryReceipient,
2494 
2495         uint256[] memory _split,
2496 
2497         address[] memory _addressTeam
2498 
2499     ) internal {
2500 
2501         require(
2502 
2503             _primaryPercentage.length == _primaryReceipient.length &&
2504 
2505             _split.length == _addressTeam.length, "length must same"
2506 
2507         );
2508 
2509 
2510 
2511         for(uint256 i=0; i< _primaryPercentage.length; i++){
2512 
2513             percentage[i+1] = _primaryPercentage[i];
2514 
2515             recipient[i+1] = _primaryReceipient[i];
2516 
2517         }
2518 
2519         lastIndexPrimary = _primaryPercentage.length;
2520 
2521 
2522 
2523         for(uint256 i=0; i< _split.length; i++){
2524 
2525             percentage[lastIndexPrimary +1 +i] = _split[i];
2526 
2527             recipient[lastIndexPrimary +1 +i] = _addressTeam[i];
2528 
2529         }
2530 
2531         lastIndexTeam = lastIndexPrimary + _split.length;
2532 
2533     }
2534 
2535 
2536 
2537     //Mint Part
2538 
2539     //Mint Internal
2540 
2541     function _mintNFT(address _to, uint256 _amount) internal {
2542 
2543         _safeMint(_to, _amount);
2544 
2545     }
2546 
2547 
2548 
2549     //Public Sale Mint
2550 
2551     function publicSaleMint(uint256 _amount) external payable{
2552 
2553         require(_amount > 0 , "amount must not zero");
2554 
2555         require(isPublicSale == true, "Public sale is not active");
2556 
2557         require(_amount <= maxMintsPerTransaction, "Max mints per transaction constraint violation");
2558 
2559         require(msg.value == _amount * publicsale_price, "Wrong Ether Value For Public Sale");
2560 
2561 
2562 
2563         require(totalSupply() + reserved_qty + freemint_qty + _amount <= max_supply, "Tokens supply reached limit");
2564 
2565         _mintNFT(msg.sender, _amount);
2566 
2567 
2568 
2569         emit Mint(msg.sender, 1, block.timestamp);
2570 
2571     }
2572 
2573 
2574 
2575     //Public sale and free mint
2576 
2577     function publicWithFreeMint(uint256 _amountTotal, uint256 _amountFree, bytes memory _signature) external payable{
2578 
2579         require(_amountTotal > 0 && _amountFree > 0 && _amountTotal > _amountFree, "all amount must not zero");
2580 
2581         require(recoverSigner(prefixed(keccak256(abi.encodePacked(
2582 
2583                                     msg.sender,
2584 
2585                                     _amountTotal,
2586 
2587                                     _amountFree,
2588 
2589                                     mintedOnFreemint[msg.sender],
2590 
2591                                     uint8(1)
2592 
2593                             ))), _signature)== signer, "You have not access for minting");
2594 
2595         require(isFreemint == true && isPublicSale == true, "Public sale and Free mint must active");
2596 
2597 
2598 
2599         //free part
2600 
2601         require(_amountFree <= freemint_qty, "Freemint Supply Not Enough For Minting");
2602 
2603         require(mintedOnFreemint[msg.sender] + _amountFree <= freeMintPerWallet, "Max mints for free mint constraint violation");
2604 
2605 
2606 
2607         //public part
2608 
2609         require(_amountTotal <= maxMintsPerTransaction, "Max mints per transaction constraint violation");
2610 
2611         require(msg.value == (_amountTotal.sub(_amountFree)) * publicsale_price, "Wrong Ether Value For Public Sale");
2612 
2613         require(totalSupply() + reserved_qty + freemint_qty + _amountTotal <= max_supply, "Tokens supply reached limit");
2614 
2615 
2616 
2617         freemint_qty-=_amountFree; //1
2618 
2619         mintedOnFreemint[msg.sender] += _amountFree; //2
2620 
2621         
2622 
2623         _mintNFT(msg.sender, _amountTotal);
2624 
2625 
2626 
2627         emit Mint(msg.sender, 2, block.timestamp);
2628 
2629     }
2630 
2631 
2632 
2633     //Free Mint
2634 
2635     function freeMint(uint256 _amount, bytes memory _signature) external {
2636 
2637         require(_amount > 0 , "amount must not zero");
2638 
2639         require(recoverSigner(prefixed(keccak256(abi.encodePacked(
2640 
2641                                     msg.sender,
2642 
2643                                     _amount,
2644 
2645                                     mintedOnFreemint[msg.sender],
2646 
2647                                     uint8(2)
2648 
2649                             ))), _signature)== signer, "You have not access for minting");
2650 
2651 
2652 
2653         require(isFreemint == true, "Free mint is not active");
2654 
2655         require(_amount <= freemint_qty, "Freemint Supply Not Enough For Minting");
2656 
2657         require(mintedOnFreemint[msg.sender] + _amount <= freeMintPerWallet, "Max mints for free mint constraint violation");
2658 
2659         
2660 
2661         freemint_qty-=_amount; //1
2662 
2663         mintedOnFreemint[msg.sender] += _amount; //2
2664 
2665         
2666 
2667         _mintNFT(msg.sender, _amount);
2668 
2669 
2670 
2671         emit Mint(msg.sender, 3, block.timestamp);
2672 
2673     }
2674 
2675 
2676 
2677     //Reserved Mint
2678 
2679     function reservedMint(address[] memory _to, uint256[] memory _amount) external onlyOwner{
2680 
2681         require(_to.length == _amount.length, "must same length");
2682 
2683         uint reserved = reserved_qty;
2684 
2685         for(uint i=0; i<_to.length; i++){
2686 
2687             require(_amount[i] <= reserved ,"Reserved supply reached limit");
2688 
2689             _mintNFT(_to[i],_amount[i]);
2690 
2691             reserved-= _amount[i];
2692 
2693         }
2694 
2695         reserved_qty=reserved;
2696 
2697 
2698 
2699         emit Mint(msg.sender, 4, block.timestamp);
2700 
2701     }
2702 
2703 
2704 
2705     //Withdraw Part
2706 
2707     function withdraw() external onlyOwner{
2708 
2709         uint256 balance = address(this).balance;
2710 
2711         uint256 percent100 = 100*(10**18);
2712 
2713 
2714 
2715         uint teamvalue = balance;
2716 
2717         uint256 sentValue;
2718 
2719 
2720 
2721         //primary distribution
2722 
2723         for(uint256 j=0; j<lastIndexPrimary; j++){
2724 
2725             sentValue = (percentage[j+1].mul(balance)).div(percent100);
2726 
2727             _sent(recipient[j+1], sentValue);
2728 
2729             teamvalue = teamvalue.sub(sentValue);
2730 
2731         }
2732 
2733 
2734 
2735         //team distribution
2736 
2737         balance = teamvalue;
2738 
2739         for(uint256 i=lastIndexPrimary; i<lastIndexTeam; i++){
2740 
2741             if(i != lastIndexTeam-1){
2742 
2743                 sentValue = (percentage[i+1].mul(teamvalue)).div(percent100);
2744 
2745                 balance = balance.sub(sentValue);
2746 
2747             }
2748 
2749             else{
2750 
2751                 sentValue= balance;
2752 
2753             }
2754 
2755             _sent(recipient[i+1], sentValue);
2756 
2757         }
2758 
2759     }
2760 
2761 
2762 
2763     function _sent(address _to, uint256 _value) private returns (bool){
2764 
2765         (bool sent,) =payable(_to).call{value: _value}("");
2766 
2767         return sent;
2768 
2769     }
2770 
2771 
2772 
2773 
2774 
2775     //signature part
2776 
2777     function prefixed(bytes32 hash) internal pure returns (bytes32) {
2778 
2779         return keccak256(abi.encodePacked(
2780 
2781         '\x19Ethereum Signed Message:\n32', 
2782 
2783         hash
2784 
2785         ));
2786 
2787     }
2788 
2789 
2790 
2791     function recoverSigner(bytes32 message, bytes memory sig)
2792 
2793         internal
2794 
2795         pure
2796 
2797         returns (address)
2798 
2799     {
2800 
2801         uint8 v;
2802 
2803         bytes32 r;
2804 
2805         bytes32 s;
2806 
2807     
2808 
2809         (v, r, s) = splitSignature(sig);
2810 
2811     
2812 
2813         return ecrecover(message, v, r, s);
2814 
2815     }
2816 
2817 
2818 
2819     function splitSignature(bytes memory sig)
2820 
2821         internal
2822 
2823         pure
2824 
2825         returns (uint8, bytes32, bytes32)
2826 
2827     {
2828 
2829         require(sig.length == 65);
2830 
2831     
2832 
2833         bytes32 r;
2834 
2835         bytes32 s;
2836 
2837         uint8 v;
2838 
2839     
2840 
2841         assembly {
2842 
2843             // first 32 bytes, after the length prefix
2844 
2845             r := mload(add(sig, 32))
2846 
2847             // second 32 bytes
2848 
2849             s := mload(add(sig, 64))
2850 
2851             // final byte (first byte of the next 32 bytes)
2852 
2853             v := byte(0, mload(add(sig, 96)))
2854 
2855         }
2856 
2857     
2858 
2859         return (v, r, s);
2860 
2861     }
2862 
2863 
2864 
2865     //Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings
2866 
2867     function isApprovedForAll(address owner, address operator)
2868 
2869         override
2870 
2871         public
2872 
2873         view
2874 
2875         returns (bool)
2876 
2877     {
2878 
2879         // Whitelist OpenSea proxy contract for easy trading.
2880 
2881         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
2882 
2883         if (address(proxyRegistry.proxies(owner)) == operator) {
2884 
2885             return true;
2886 
2887         }
2888 
2889 
2890 
2891         return super.isApprovedForAll(owner, operator);
2892 
2893     }
2894 
2895 }
2896 
2897 
2898 
2899 contract OwnableDelegateProxy { }
2900 
2901 contract ProxyRegistry {
2902 
2903     mapping(address => OwnableDelegateProxy) public proxies;
2904 
2905 }