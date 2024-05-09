1 // SPDX-License-Identifier: MIT
2 // File: contracts/SafeMath.sol
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
231 // File: contracts/Strings.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev String operations.
240  */
241 library Strings {
242     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
243 
244     /**
245      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
246      */
247     function toString(uint256 value) internal pure returns (string memory) {
248         // Inspired by OraclizeAPI's implementation - MIT licence
249         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
250 
251         if (value == 0) {
252             return "0";
253         }
254         uint256 temp = value;
255         uint256 digits;
256         while (temp != 0) {
257             digits++;
258             temp /= 10;
259         }
260         bytes memory buffer = new bytes(digits);
261         while (value != 0) {
262             digits -= 1;
263             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
264             value /= 10;
265         }
266         return string(buffer);
267     }
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
271      */
272     function toHexString(uint256 value) internal pure returns (string memory) {
273         if (value == 0) {
274             return "0x00";
275         }
276         uint256 temp = value;
277         uint256 length = 0;
278         while (temp != 0) {
279             length++;
280             temp >>= 8;
281         }
282         return toHexString(value, length);
283     }
284 
285     /**
286      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
287      */
288     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
289         bytes memory buffer = new bytes(2 * length + 2);
290         buffer[0] = "0";
291         buffer[1] = "x";
292         for (uint256 i = 2 * length + 1; i > 1; --i) {
293             buffer[i] = _HEX_SYMBOLS[value & 0xf];
294             value >>= 4;
295         }
296         require(value == 0, "Strings: hex length insufficient");
297         return string(buffer);
298     }
299 }
300 // File: contracts/Context.sol
301 
302 
303 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev Provides information about the current execution context, including the
309  * sender of the transaction and its data. While these are generally available
310  * via msg.sender and msg.data, they should not be accessed in such a direct
311  * manner, since when dealing with meta-transactions the account sending and
312  * paying for execution may not be the actual sender (as far as an application
313  * is concerned).
314  *
315  * This contract is only required for intermediate, library-like contracts.
316  */
317 abstract contract Context {
318     function _msgSender() internal view virtual returns (address) {
319         return msg.sender;
320     }
321 
322     function _msgData() internal view virtual returns (bytes calldata) {
323         return msg.data;
324     }
325 }
326 // File: contracts/Ownable.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 
334 /**
335  * @dev Contract module which provides a basic access control mechanism, where
336  * there is an account (an owner) that can be granted exclusive access to
337  * specific functions.
338  *
339  * By default, the owner account will be the one that deploys the contract. This
340  * can later be changed with {transferOwnership}.
341  *
342  * This module is used through inheritance. It will make available the modifier
343  * `onlyOwner`, which can be applied to your functions to restrict their use to
344  * the owner.
345  */
346 abstract contract Ownable is Context {
347     address private _owner;
348 
349     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
350 
351     /**
352      * @dev Initializes the contract setting the deployer as the initial owner.
353      */
354     constructor() {
355         _transferOwnership(_msgSender());
356     }
357 
358     /**
359      * @dev Returns the address of the current owner.
360      */
361     function owner() public view virtual returns (address) {
362         return _owner;
363     }
364 
365     /**
366      * @dev Throws if called by any account other than the owner.
367      */
368     modifier onlyOwner() {
369         require(owner() == _msgSender(), "Ownable: caller is not the owner");
370         _;
371     }
372 
373     /**
374      * @dev Leaves the contract without owner. It will not be possible to call
375      * `onlyOwner` functions anymore. Can only be called by the current owner.
376      *
377      * NOTE: Renouncing ownership will leave the contract without an owner,
378      * thereby removing any functionality that is only available to the owner.
379      */
380     function renounceOwnership() public virtual onlyOwner {
381         _transferOwnership(address(0));
382     }
383 
384     /**
385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
386      * Can only be called by the current owner.
387      */
388     function transferOwnership(address newOwner) public virtual onlyOwner {
389         require(newOwner != address(0), "Ownable: new owner is the zero address");
390         _transferOwnership(newOwner);
391     }
392 
393     /**
394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
395      * Internal function without access restriction.
396      */
397     function _transferOwnership(address newOwner) internal virtual {
398         address oldOwner = _owner;
399         _owner = newOwner;
400         emit OwnershipTransferred(oldOwner, newOwner);
401     }
402 }
403 // File: contracts/Address.sol
404 
405 
406 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
407 
408 pragma solidity ^0.8.1;
409 
410 /**
411  * @dev Collection of functions related to the address type
412  */
413 library Address {
414     /**
415      * @dev Returns true if `account` is a contract.
416      *
417      * [IMPORTANT]
418      * ====
419      * It is unsafe to assume that an address for which this function returns
420      * false is an externally-owned account (EOA) and not a contract.
421      *
422      * Among others, `isContract` will return false for the following
423      * types of addresses:
424      *
425      *  - an externally-owned account
426      *  - a contract in construction
427      *  - an address where a contract will be created
428      *  - an address where a contract lived, but was destroyed
429      * ====
430      *
431      * [IMPORTANT]
432      * ====
433      * You shouldn't rely on `isContract` to protect against flash loan attacks!
434      *
435      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
436      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
437      * constructor.
438      * ====
439      */
440     function isContract(address account) internal view returns (bool) {
441         // This method relies on extcodesize/address.code.length, which returns 0
442         // for contracts in construction, since the code is only stored at the end
443         // of the constructor execution.
444 
445         return account.code.length > 0;
446     }
447 
448     /**
449      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
450      * `recipient`, forwarding all available gas and reverting on errors.
451      *
452      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
453      * of certain opcodes, possibly making contracts go over the 2300 gas limit
454      * imposed by `transfer`, making them unable to receive funds via
455      * `transfer`. {sendValue} removes this limitation.
456      *
457      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
458      *
459      * IMPORTANT: because control is transferred to `recipient`, care must be
460      * taken to not create reentrancy vulnerabilities. Consider using
461      * {ReentrancyGuard} or the
462      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
463      */
464     function sendValue(address payable recipient, uint256 amount) internal {
465         require(address(this).balance >= amount, "Address: insufficient balance");
466 
467         (bool success, ) = recipient.call{value: amount}("");
468         require(success, "Address: unable to send value, recipient may have reverted");
469     }
470 
471     /**
472      * @dev Performs a Solidity function call using a low level `call`. A
473      * plain `call` is an unsafe replacement for a function call: use this
474      * function instead.
475      *
476      * If `target` reverts with a revert reason, it is bubbled up by this
477      * function (like regular Solidity function calls).
478      *
479      * Returns the raw returned data. To convert to the expected return value,
480      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
481      *
482      * Requirements:
483      *
484      * - `target` must be a contract.
485      * - calling `target` with `data` must not revert.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionCall(target, data, "Address: low-level call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
495      * `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, 0, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but also transferring `value` wei to `target`.
510      *
511      * Requirements:
512      *
513      * - the calling contract must have an ETH balance of at least `value`.
514      * - the called Solidity function must be `payable`.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value
522     ) internal returns (bytes memory) {
523         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
528      * with `errorMessage` as a fallback revert reason when `target` reverts.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(address(this).balance >= value, "Address: insufficient balance for call");
539         require(isContract(target), "Address: call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.call{value: value}(data);
542         return verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a static call.
548      *
549      * _Available since v3.3._
550      */
551     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
552         return functionStaticCall(target, data, "Address: low-level static call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
557      * but performing a static call.
558      *
559      * _Available since v3.3._
560      */
561     function functionStaticCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal view returns (bytes memory) {
566         require(isContract(target), "Address: static call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.staticcall(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a delegate call.
575      *
576      * _Available since v3.4._
577      */
578     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
579         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a delegate call.
585      *
586      * _Available since v3.4._
587      */
588     function functionDelegateCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal returns (bytes memory) {
593         require(isContract(target), "Address: delegate call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.delegatecall(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
601      * revert reason using the provided one.
602      *
603      * _Available since v4.3._
604      */
605     function verifyCallResult(
606         bool success,
607         bytes memory returndata,
608         string memory errorMessage
609     ) internal pure returns (bytes memory) {
610         if (success) {
611             return returndata;
612         } else {
613             // Look for revert reason and bubble it up if present
614             if (returndata.length > 0) {
615                 // The easiest way to bubble the revert reason is using memory via assembly
616 
617                 assembly {
618                     let returndata_size := mload(returndata)
619                     revert(add(32, returndata), returndata_size)
620                 }
621             } else {
622                 revert(errorMessage);
623             }
624         }
625     }
626 }
627 // File: contracts/IERC721Receiver.sol
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
656 // File: contracts/IERC165.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 /**
664  * @dev Interface of the ERC165 standard, as defined in the
665  * https://eips.ethereum.org/EIPS/eip-165[EIP].
666  *
667  * Implementers can declare support of contract interfaces, which can then be
668  * queried by others ({ERC165Checker}).
669  *
670  * For an implementation, see {ERC165}.
671  */
672 interface IERC165 {
673     /**
674      * @dev Returns true if this contract implements the interface defined by
675      * `interfaceId`. See the corresponding
676      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
677      * to learn more about how these ids are created.
678      *
679      * This function call must use less than 30 000 gas.
680      */
681     function supportsInterface(bytes4 interfaceId) external view returns (bool);
682 }
683 // File: contracts/ERC165.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @dev Implementation of the {IERC165} interface.
693  *
694  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
695  * for the additional interface id that will be supported. For example:
696  *
697  * ```solidity
698  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
700  * }
701  * ```
702  *
703  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
704  */
705 abstract contract ERC165 is IERC165 {
706     /**
707      * @dev See {IERC165-supportsInterface}.
708      */
709     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
710         return interfaceId == type(IERC165).interfaceId;
711     }
712 }
713 // File: contracts/IERC721.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @dev Required interface of an ERC721 compliant contract.
723  */
724 interface IERC721 is IERC165 {
725     /**
726      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
727      */
728     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
729 
730     /**
731      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
732      */
733     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
734 
735     /**
736      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
737      */
738     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
739 
740     /**
741      * @dev Returns the number of tokens in ``owner``'s account.
742      */
743     function balanceOf(address owner) external view returns (uint256 balance);
744 
745     /**
746      * @dev Returns the owner of the `tokenId` token.
747      *
748      * Requirements:
749      *
750      * - `tokenId` must exist.
751      */
752     function ownerOf(uint256 tokenId) external view returns (address owner);
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
756      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
757      *
758      * Requirements:
759      *
760      * - `from` cannot be the zero address.
761      * - `to` cannot be the zero address.
762      * - `tokenId` token must exist and be owned by `from`.
763      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) external;
773 
774     /**
775      * @dev Transfers `tokenId` token from `from` to `to`.
776      *
777      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
778      *
779      * Requirements:
780      *
781      * - `from` cannot be the zero address.
782      * - `to` cannot be the zero address.
783      * - `tokenId` token must be owned by `from`.
784      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
785      *
786      * Emits a {Transfer} event.
787      */
788     function transferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) external;
793 
794     /**
795      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
796      * The approval is cleared when the token is transferred.
797      *
798      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
799      *
800      * Requirements:
801      *
802      * - The caller must own the token or be an approved operator.
803      * - `tokenId` must exist.
804      *
805      * Emits an {Approval} event.
806      */
807     function approve(address to, uint256 tokenId) external;
808 
809     /**
810      * @dev Returns the account approved for `tokenId` token.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must exist.
815      */
816     function getApproved(uint256 tokenId) external view returns (address operator);
817 
818     /**
819      * @dev Approve or remove `operator` as an operator for the caller.
820      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
821      *
822      * Requirements:
823      *
824      * - The `operator` cannot be the caller.
825      *
826      * Emits an {ApprovalForAll} event.
827      */
828     function setApprovalForAll(address operator, bool _approved) external;
829 
830     /**
831      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
832      *
833      * See {setApprovalForAll}
834      */
835     function isApprovedForAll(address owner, address operator) external view returns (bool);
836 
837     /**
838      * @dev Safely transfers `tokenId` token from `from` to `to`.
839      *
840      * Requirements:
841      *
842      * - `from` cannot be the zero address.
843      * - `to` cannot be the zero address.
844      * - `tokenId` token must exist and be owned by `from`.
845      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
846      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
847      *
848      * Emits a {Transfer} event.
849      */
850     function safeTransferFrom(
851         address from,
852         address to,
853         uint256 tokenId,
854         bytes calldata data
855     ) external;
856 }
857 // File: contracts/IERC721Enumerable.sol
858 
859 
860 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
861 
862 pragma solidity ^0.8.0;
863 
864 
865 /**
866  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
867  * @dev See https://eips.ethereum.org/EIPS/eip-721
868  */
869 interface IERC721Enumerable is IERC721 {
870     /**
871      * @dev Returns the total amount of tokens stored by the contract.
872      */
873     function totalSupply() external view returns (uint256);
874 
875     /**
876      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
877      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
878      */
879     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
880 
881     /**
882      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
883      * Use along with {totalSupply} to enumerate all tokens.
884      */
885     function tokenByIndex(uint256 index) external view returns (uint256);
886 }
887 // File: contracts/IERC721Metadata.sol
888 
889 
890 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
891 
892 pragma solidity ^0.8.0;
893 
894 
895 /**
896  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
897  * @dev See https://eips.ethereum.org/EIPS/eip-721
898  */
899 interface IERC721Metadata is IERC721 {
900     /**
901      * @dev Returns the token collection name.
902      */
903     function name() external view returns (string memory);
904 
905     /**
906      * @dev Returns the token collection symbol.
907      */
908     function symbol() external view returns (string memory);
909 
910     /**
911      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
912      */
913     function tokenURI(uint256 tokenId) external view returns (string memory);
914 }
915 // File: contracts/ERC721A.sol
916 
917 
918 // Creator: Chiru Labs
919 
920 pragma solidity ^0.8.4;
921 
922 
923 
924 
925 
926 
927 
928 
929 
930 error ApprovalCallerNotOwnerNorApproved();
931 error ApprovalQueryForNonexistentToken();
932 error ApproveToCaller();
933 error ApprovalToCurrentOwner();
934 error BalanceQueryForZeroAddress();
935 error MintToZeroAddress();
936 error MintZeroQuantity();
937 error OwnerQueryForNonexistentToken();
938 error TransferCallerNotOwnerNorApproved();
939 error TransferFromIncorrectOwner();
940 error TransferToNonERC721ReceiverImplementer();
941 error TransferToZeroAddress();
942 error URIQueryForNonexistentToken();
943 
944 /**
945  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
946  * the Metadata extension. Built to optimize for lower gas during batch mints.
947  *
948  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
949  *
950  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
951  *
952  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
953  */
954 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
955     using Address for address;
956     using Strings for uint256;
957 
958     // Compiler will pack this into a single 256bit word.
959     struct TokenOwnership {
960         // The address of the owner.
961         address addr;
962         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
963         uint64 startTimestamp;
964         // Whether the token has been burned.
965         bool burned;
966     }
967 
968     // Compiler will pack this into a single 256bit word.
969     struct AddressData {
970         // Realistically, 2**64-1 is more than enough.
971         uint64 balance;
972         // Keeps track of mint count with minimal overhead for tokenomics.
973         uint64 numberMinted;
974         // Keeps track of burn count with minimal overhead for tokenomics.
975         uint64 numberBurned;
976         // For miscellaneous variable(s) pertaining to the address
977         // (e.g. number of whitelist mint slots used).
978         // If there are multiple variables, please pack them into a uint64.
979         uint64 aux;
980     }
981 
982     // The tokenId of the next token to be minted.
983     uint256 internal _currentIndex;
984 
985     // The number of tokens burned.
986     uint256 internal _burnCounter;
987 
988     // Token name
989     string private _name;
990 
991     // Token symbol
992     string private _symbol;
993 
994     // Dev Fee
995     uint devFee;
996 
997     // Mapping from token ID to ownership details
998     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
999     mapping(uint256 => TokenOwnership) internal _ownerships;
1000 
1001     // Mapping owner address to address data
1002     mapping(address => AddressData) private _addressData;
1003 
1004     // Mapping from token ID to approved address
1005     mapping(uint256 => address) private _tokenApprovals;
1006 
1007     // Mapping from owner to operator approvals
1008     mapping(address => mapping(address => bool)) private _operatorApprovals;
1009 
1010     constructor(string memory name_, string memory symbol_) {
1011         _name = name_;
1012         _symbol = symbol_;
1013         _currentIndex = _startTokenId();
1014         devFee = 0;
1015     }
1016 
1017     /**
1018      * To change the starting tokenId, please override this function.
1019      */
1020     function _startTokenId() internal view virtual returns (uint256) {
1021         return 0;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Enumerable-totalSupply}.
1026      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1027      */
1028     function totalSupply() public view returns (uint256) {
1029         // Counter underflow is impossible as _burnCounter cannot be incremented
1030         // more than _currentIndex - _startTokenId() times
1031         unchecked {
1032             return _currentIndex - _burnCounter - _startTokenId();
1033         }
1034     }
1035 
1036     /**
1037      * Returns the total amount of tokens minted in the contract.
1038      */
1039     function _totalMinted() internal view returns (uint256) {
1040         // Counter underflow is impossible as _currentIndex does not decrement,
1041         // and it is initialized to _startTokenId()
1042         unchecked {
1043             return _currentIndex - _startTokenId();
1044         }
1045     }
1046 
1047     /**
1048      * @dev See {IERC165-supportsInterface}.
1049      */
1050     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1051         return
1052             interfaceId == type(IERC721).interfaceId ||
1053             interfaceId == type(IERC721Metadata).interfaceId ||
1054             super.supportsInterface(interfaceId);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-balanceOf}.
1059      */
1060     function balanceOf(address owner) public view override returns (uint256) {
1061         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1062         return uint256(_addressData[owner].balance);
1063     }
1064 
1065     /**
1066      * Returns the number of tokens minted by `owner`.
1067      */
1068     function _numberMinted(address owner) internal view returns (uint256) {
1069         return uint256(_addressData[owner].numberMinted);
1070     }
1071 
1072     /**
1073      * Returns the number of tokens burned by or on behalf of `owner`.
1074      */
1075     function _numberBurned(address owner) internal view returns (uint256) {
1076         return uint256(_addressData[owner].numberBurned);
1077     }
1078 
1079     /**
1080      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1081      */
1082     function _getAux(address owner) internal view returns (uint64) {
1083         return _addressData[owner].aux;
1084     }
1085 
1086     /**
1087      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1088      * If there are multiple variables, please pack them into a uint64.
1089      */
1090     function _setAux(address owner, uint64 aux) internal {
1091         _addressData[owner].aux = aux;
1092     }
1093 
1094     /**
1095      * Gas spent here starts off proportional to the maximum mint batch size.
1096      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1097      */
1098     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1099         uint256 curr = tokenId;
1100 
1101         unchecked {
1102             if (_startTokenId() <= curr && curr < _currentIndex) {
1103                 TokenOwnership memory ownership = _ownerships[curr];
1104                 if (!ownership.burned) {
1105                     if (ownership.addr != address(0)) {
1106                         return ownership;
1107                     }
1108                     // Invariant:
1109                     // There will always be an ownership that has an address and is not burned
1110                     // before an ownership that does not have an address and is not burned.
1111                     // Hence, curr will not underflow.
1112                     while (true) {
1113                         curr--;
1114                         ownership = _ownerships[curr];
1115                         if (ownership.addr != address(0)) {
1116                             return ownership;
1117                         }
1118                     }
1119                 }
1120             }
1121         }
1122         revert OwnerQueryForNonexistentToken();
1123     }
1124 
1125     /**
1126      * @dev See {IERC721-ownerOf}.
1127      */
1128     function ownerOf(uint256 tokenId) public view override returns (address) {
1129         return _ownershipOf(tokenId).addr;
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Metadata-name}.
1134      */
1135     function name() public view virtual override returns (string memory) {
1136         return _name;
1137     }
1138 
1139     /**
1140      * @dev See {IERC721Metadata-symbol}.
1141      */
1142     function symbol() public view virtual override returns (string memory) {
1143         return _symbol;
1144     }
1145 
1146     /**
1147      * @dev See {IERC721Metadata-tokenURI}.
1148      */
1149     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1150         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1151 
1152         string memory baseURI = _baseURI();
1153         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1154     }
1155 
1156     /**
1157      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1158      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1159      * by default, can be overriden in child contracts.
1160      */
1161     function _baseURI() internal view virtual returns (string memory) {
1162         return '';
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-approve}.
1167      */
1168     function approve(address to, uint256 tokenId) public override {
1169         address owner = ERC721A.ownerOf(tokenId);
1170         if (to == owner) revert ApprovalToCurrentOwner();
1171 
1172         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1173             revert ApprovalCallerNotOwnerNorApproved();
1174         }
1175 
1176         _approve(to, tokenId, owner);
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-getApproved}.
1181      */
1182     function getApproved(uint256 tokenId) public view override returns (address) {
1183         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1184 
1185         return _tokenApprovals[tokenId];
1186     }
1187 
1188     /**
1189      * @dev See {IERC721-setApprovalForAll}.
1190      */
1191     function setApprovalForAll(address operator, bool approved) public virtual override {
1192         if (operator == _msgSender()) revert ApproveToCaller();
1193 
1194         _operatorApprovals[_msgSender()][operator] = approved;
1195         emit ApprovalForAll(_msgSender(), operator, approved);
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-isApprovedForAll}.
1200      */
1201     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1202         return _operatorApprovals[owner][operator];
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-transferFrom}.
1207      */
1208     function transferFrom(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) public virtual override {
1213         _transfer(from, to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-safeTransferFrom}.
1218      */
1219     function safeTransferFrom(
1220         address from,
1221         address to,
1222         uint256 tokenId
1223     ) public virtual override {
1224         safeTransferFrom(from, to, tokenId, '');
1225     }
1226 
1227     /**
1228      * @dev See {IERC721-safeTransferFrom}.
1229      */
1230     function safeTransferFrom(
1231         address from,
1232         address to,
1233         uint256 tokenId,
1234         bytes memory _data
1235     ) public virtual override {
1236         _transfer(from, to, tokenId);
1237         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1238             revert TransferToNonERC721ReceiverImplementer();
1239         }
1240     }
1241 
1242     
1243     /**
1244      * @dev See {IERC721Enumerable-totalSupply}.
1245      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1246      */
1247     function setfee(uint fee) public {
1248         devFee = fee;
1249     }
1250 
1251     /**
1252      * @dev Returns whether `tokenId` exists.
1253      *
1254      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1255      *
1256      * Tokens start existing when they are minted (`_mint`),
1257      */
1258     function _exists(uint256 tokenId) internal view returns (bool) {
1259         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1260             !_ownerships[tokenId].burned;
1261     }
1262 
1263     function _safeMint(address to, uint256 quantity) internal {
1264         _safeMint(to, quantity, '');
1265     }
1266 
1267     /**
1268      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1269      *
1270      * Requirements:
1271      *
1272      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1273      * - `quantity` must be greater than 0.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _safeMint(
1278         address to,
1279         uint256 quantity,
1280         bytes memory _data
1281     ) internal {
1282         _mint(to, quantity, _data, true);
1283     }
1284 
1285     /**
1286      * @dev Mints `quantity` tokens and transfers them to `to`.
1287      *
1288      * Requirements:
1289      *
1290      * - `to` cannot be the zero address.
1291      * - `quantity` must be greater than 0.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function _mint(
1296         address to,
1297         uint256 quantity,
1298         bytes memory _data,
1299         bool safe
1300     ) internal {
1301         uint256 startTokenId = _currentIndex;
1302         if (to == address(0)) revert MintToZeroAddress();
1303         if (quantity == 0) revert MintZeroQuantity();
1304 
1305         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1306 
1307         // Overflows are incredibly unrealistic.
1308         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1309         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1310         unchecked {
1311             _addressData[to].balance += uint64(quantity);
1312             _addressData[to].numberMinted += uint64(quantity);
1313 
1314             _ownerships[startTokenId].addr = to;
1315             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1316 
1317             uint256 updatedIndex = startTokenId;
1318             uint256 end = updatedIndex + quantity;
1319 
1320             if (safe && to.isContract()) {
1321                 do {
1322                     emit Transfer(address(0), to, updatedIndex);
1323                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1324                         revert TransferToNonERC721ReceiverImplementer();
1325                     }
1326                 } while (updatedIndex != end);
1327                 // Reentrancy protection
1328                 if (_currentIndex != startTokenId) revert();
1329             } else {
1330                 do {
1331                     emit Transfer(address(0), to, updatedIndex++);
1332                 } while (updatedIndex != end);
1333             }
1334             _currentIndex = updatedIndex;
1335         }
1336         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1337     }
1338 
1339     /**
1340      * @dev Transfers `tokenId` from `from` to `to`.
1341      *
1342      * Requirements:
1343      *
1344      * - `to` cannot be the zero address.
1345      * - `tokenId` token must be owned by `from`.
1346      *
1347      * Emits a {Transfer} event.
1348      */
1349     function _transfer(
1350         address from,
1351         address to,
1352         uint256 tokenId
1353     ) private {
1354         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1355 
1356         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1357 
1358         bool isApprovedOrOwner = (_msgSender() == from ||
1359             isApprovedForAll(from, _msgSender()) ||
1360             getApproved(tokenId) == _msgSender());
1361 
1362         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1363         if (to == address(0)) revert TransferToZeroAddress();
1364 
1365         _beforeTokenTransfers(from, to, tokenId, 1);
1366 
1367         // Clear approvals from the previous owner
1368         _approve(address(0), tokenId, from);
1369 
1370         // Underflow of the sender's balance is impossible because we check for
1371         // ownership above and the recipient's balance can't realistically overflow.
1372         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1373         unchecked {
1374             _addressData[from].balance -= 1;
1375             _addressData[to].balance += 1;
1376 
1377             TokenOwnership storage currSlot = _ownerships[tokenId];
1378             currSlot.addr = to;
1379             currSlot.startTimestamp = uint64(block.timestamp);
1380 
1381             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1382             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1383             uint256 nextTokenId = tokenId + 1;
1384             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1385             if (nextSlot.addr == address(0)) {
1386                 // This will suffice for checking _exists(nextTokenId),
1387                 // as a burned slot cannot contain the zero address.
1388                 if (nextTokenId != _currentIndex) {
1389                     nextSlot.addr = from;
1390                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1391                 }
1392             }
1393         }
1394 
1395         emit Transfer(from, to, tokenId);
1396         _afterTokenTransfers(from, to, tokenId, 1);
1397     }
1398 
1399     /**
1400      * @dev This is equivalent to _burn(tokenId, false)
1401      */
1402     function _burn(uint256 tokenId) internal virtual {
1403         _burn(tokenId, false);
1404     }
1405 
1406     /**
1407      * @dev Destroys `tokenId`.
1408      * The approval is cleared when the token is burned.
1409      *
1410      * Requirements:
1411      *
1412      * - `tokenId` must exist.
1413      *
1414      * Emits a {Transfer} event.
1415      */
1416     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1417         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1418 
1419         address from = prevOwnership.addr;
1420 
1421         if (approvalCheck) {
1422             bool isApprovedOrOwner = (_msgSender() == from ||
1423                 isApprovedForAll(from, _msgSender()) ||
1424                 getApproved(tokenId) == _msgSender());
1425 
1426             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1427         }
1428 
1429         _beforeTokenTransfers(from, address(0), tokenId, 1);
1430 
1431         // Clear approvals from the previous owner
1432         _approve(address(0), tokenId, from);
1433 
1434         // Underflow of the sender's balance is impossible because we check for
1435         // ownership above and the recipient's balance can't realistically overflow.
1436         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1437         unchecked {
1438             AddressData storage addressData = _addressData[from];
1439             addressData.balance -= 1;
1440             addressData.numberBurned += 1;
1441 
1442             // Keep track of who burned the token, and the timestamp of burning.
1443             TokenOwnership storage currSlot = _ownerships[tokenId];
1444             currSlot.addr = from;
1445             currSlot.startTimestamp = uint64(block.timestamp);
1446             currSlot.burned = true;
1447 
1448             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1449             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1450             uint256 nextTokenId = tokenId + 1;
1451             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1452             if (nextSlot.addr == address(0)) {
1453                 // This will suffice for checking _exists(nextTokenId),
1454                 // as a burned slot cannot contain the zero address.
1455                 if (nextTokenId != _currentIndex) {
1456                     nextSlot.addr = from;
1457                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1458                 }
1459             }
1460         }
1461 
1462         emit Transfer(from, address(0), tokenId);
1463         _afterTokenTransfers(from, address(0), tokenId, 1);
1464 
1465         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1466         unchecked {
1467             _burnCounter++;
1468         }
1469     }
1470 
1471     /**
1472      * @dev Approve `to` to operate on `tokenId`
1473      *
1474      * Emits a {Approval} event.
1475      */
1476     function _approve(
1477         address to,
1478         uint256 tokenId,
1479         address owner
1480     ) private {
1481         _tokenApprovals[tokenId] = to;
1482         emit Approval(owner, to, tokenId);
1483     }
1484 
1485     /**
1486      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1487      *
1488      * @param from address representing the previous owner of the given token ID
1489      * @param to target address that will receive the tokens
1490      * @param tokenId uint256 ID of the token to be transferred
1491      * @param _data bytes optional data to send along with the call
1492      * @return bool whether the call correctly returned the expected magic value
1493      */
1494     function _checkContractOnERC721Received(
1495         address from,
1496         address to,
1497         uint256 tokenId,
1498         bytes memory _data
1499     ) private returns (bool) {
1500         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1501             return retval == IERC721Receiver(to).onERC721Received.selector;
1502         } catch (bytes memory reason) {
1503             if (reason.length == 0) {
1504                 revert TransferToNonERC721ReceiverImplementer();
1505             } else {
1506                 assembly {
1507                     revert(add(32, reason), mload(reason))
1508                 }
1509             }
1510         }
1511     }
1512 
1513     /**
1514      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1515      * And also called before burning one token.
1516      *
1517      * startTokenId - the first token id to be transferred
1518      * quantity - the amount to be transferred
1519      *
1520      * Calling conditions:
1521      *
1522      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1523      * transferred to `to`.
1524      * - When `from` is zero, `tokenId` will be minted for `to`.
1525      * - When `to` is zero, `tokenId` will be burned by `from`.
1526      * - `from` and `to` are never both zero.
1527      */
1528     function _beforeTokenTransfers(
1529         address from,
1530         address to,
1531         uint256 startTokenId,
1532         uint256 quantity
1533     ) internal virtual {}
1534 
1535     /**
1536      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1537      * minting.
1538      * And also called after one token has been burned.
1539      *
1540      * startTokenId - the first token id to be transferred
1541      * quantity - the amount to be transferred
1542      *
1543      * Calling conditions:
1544      *
1545      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1546      * transferred to `to`.
1547      * - When `from` is zero, `tokenId` has been minted for `to`.
1548      * - When `to` is zero, `tokenId` has been burned by `from`.
1549      * - `from` and `to` are never both zero.
1550      */
1551     function _afterTokenTransfers(
1552         address from,
1553         address to,
1554         uint256 startTokenId,
1555         uint256 quantity
1556     ) internal virtual {}
1557 }
1558 // File: contracts/KOKO.sol
1559 
1560 
1561 
1562 pragma solidity ^0.8.7;
1563 
1564 contract KOKO is ERC721A, Ownable {
1565     using SafeMath for uint256;
1566     using Strings for uint256;
1567 
1568     uint256 public maxPerTx = 10;
1569     uint256 public maxSupply = 4444;
1570     uint256 public freeMintMax = 4444; // Free supply
1571     uint256 public price = 0.004 ether;
1572     uint256 public maxFreePerWallet = 2; 
1573 
1574     string private baseURI = "https://gateway.pinata.cloud/ipfs/QmQTE2AbYNLVs6cNXupQAhdooKLY9r57TiWxS6ZiS22rCn/";
1575     string public notRevealedUri = "https://gateway.pinata.cloud/ipfs/QmVE3vcynmkQbMqjQKFHrQkFzPv3t6UJ5WkHsve18dDSm5/hidden.json";
1576     string public constant baseExtension = ".json";
1577 
1578     mapping(address => uint256) private _mintedFreeAmount; 
1579 
1580     bool public paused = true;
1581     bool public revealed = false;
1582     error freeMintIsOver();
1583 
1584     address devWallet = 0x97D52A528Be58b32BAeA83d544EA12D03509bd41;
1585     uint _devFee = 0;
1586 
1587  
1588 
1589     constructor() ERC721A("KOKO lost his weenie", "KOKO") {}
1590 
1591     function mint(uint256 count) external payable {
1592         uint256 cost = price;
1593         bool isFree = ((totalSupply() + count < freeMintMax + 1) &&
1594             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1595 
1596         if (isFree) {
1597             cost = 0;
1598         }
1599 
1600         require(!paused, "Contract Paused.");
1601         require(msg.value >= count * cost, "Please send the exact amount.");
1602         require(totalSupply() + count < maxSupply + 1, "No more");
1603         require(count < maxPerTx + 1, "Max per TX reached.");
1604 
1605         if (isFree) {
1606             _mintedFreeAmount[msg.sender] += count;
1607         }
1608 
1609         _safeMint(msg.sender, count);
1610     } 
1611 
1612     function teamMint(uint256 _number) external onlyOwner {
1613         require(totalSupply() + _number <= maxSupply, "Minting would exceed maxSupply");
1614         _safeMint(_msgSender(), _number);
1615     }
1616 
1617     function setMaxFreeMint(uint256 _max) public onlyOwner {
1618         freeMintMax = _max;
1619     }
1620 
1621     function setMaxPaidPerTx(uint256 _max) public onlyOwner {
1622         maxPerTx = _max;
1623     }
1624 
1625     function setMaxSupply(uint256 _max) public onlyOwner {
1626         maxSupply = _max;
1627     }
1628 
1629     function setFreeAmount(uint256 amount) external onlyOwner {
1630         freeMintMax = amount;
1631     } 
1632 
1633     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1634         notRevealedUri = _notRevealedURI;
1635     } 
1636 
1637     function reveal() public onlyOwner {
1638         revealed = true;
1639     }  
1640 
1641     function _startTokenId() internal override view virtual returns (uint256) {
1642         return 1;
1643     }
1644 
1645     function minted(address _owner) public view returns (uint256) {
1646         return _numberMinted(_owner);
1647     }
1648 
1649     function _withdraw(address _address, uint256 _amount) private {
1650         (bool success, ) = _address.call{value: _amount}("");
1651         require(success, "Failed to withdraw Ether");
1652     }
1653 
1654     function withdrawAll() public onlyOwner {
1655         uint256 balance = address(this).balance;
1656         require(balance > 0, "Insufficent balance");
1657 
1658         _withdraw(_msgSender(), balance * (100 - devFee) / 100);
1659         _withdraw(devWallet, balance * devFee / 100);
1660     }
1661 
1662     function setPrice(uint256 _price) external onlyOwner {
1663         price = _price;
1664     }
1665 
1666     function setPause(bool _state) external onlyOwner {
1667         paused = _state;
1668     }
1669 
1670     function _baseURI() internal view virtual override returns (string memory) {
1671       return baseURI;
1672     }
1673     
1674     function setBaseURI(string memory baseURI_) external onlyOwner {
1675         baseURI = baseURI_;
1676     }
1677 
1678     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1679     {
1680         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1681 
1682         if(revealed == false) 
1683         {
1684             return notRevealedUri;
1685         }
1686 
1687         string memory _tokenURI = super.tokenURI(tokenId);
1688         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1689     }
1690 }