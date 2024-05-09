1 // SPDX-License-Identifier: GPL-3.0
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
410 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
411 
412 pragma solidity ^0.8.1;
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
434      *
435      * [IMPORTANT]
436      * ====
437      * You shouldn't rely on `isContract` to protect against flash loan attacks!
438      *
439      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
440      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
441      * constructor.
442      * ====
443      */
444     function isContract(address account) internal view returns (bool) {
445         // This method relies on extcodesize/address.code.length, which returns 0
446         // for contracts in construction, since the code is only stored at the end
447         // of the constructor execution.
448 
449         return account.code.length > 0;
450     }
451 
452     /**
453      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
454      * `recipient`, forwarding all available gas and reverting on errors.
455      *
456      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
457      * of certain opcodes, possibly making contracts go over the 2300 gas limit
458      * imposed by `transfer`, making them unable to receive funds via
459      * `transfer`. {sendValue} removes this limitation.
460      *
461      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
462      *
463      * IMPORTANT: because control is transferred to `recipient`, care must be
464      * taken to not create reentrancy vulnerabilities. Consider using
465      * {ReentrancyGuard} or the
466      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
467      */
468     function sendValue(address payable recipient, uint256 amount) internal {
469         require(address(this).balance >= amount, "Address: insufficient balance");
470 
471         (bool success, ) = recipient.call{value: amount}("");
472         require(success, "Address: unable to send value, recipient may have reverted");
473     }
474 
475     /**
476      * @dev Performs a Solidity function call using a low level `call`. A
477      * plain `call` is an unsafe replacement for a function call: use this
478      * function instead.
479      *
480      * If `target` reverts with a revert reason, it is bubbled up by this
481      * function (like regular Solidity function calls).
482      *
483      * Returns the raw returned data. To convert to the expected return value,
484      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
485      *
486      * Requirements:
487      *
488      * - `target` must be a contract.
489      * - calling `target` with `data` must not revert.
490      *
491      * _Available since v3.1._
492      */
493     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
494         return functionCall(target, data, "Address: low-level call failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
499      * `errorMessage` as a fallback revert reason when `target` reverts.
500      *
501      * _Available since v3.1._
502      */
503     function functionCall(
504         address target,
505         bytes memory data,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, 0, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but also transferring `value` wei to `target`.
514      *
515      * Requirements:
516      *
517      * - the calling contract must have an ETH balance of at least `value`.
518      * - the called Solidity function must be `payable`.
519      *
520      * _Available since v3.1._
521      */
522     function functionCallWithValue(
523         address target,
524         bytes memory data,
525         uint256 value
526     ) internal returns (bytes memory) {
527         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
532      * with `errorMessage` as a fallback revert reason when `target` reverts.
533      *
534      * _Available since v3.1._
535      */
536     function functionCallWithValue(
537         address target,
538         bytes memory data,
539         uint256 value,
540         string memory errorMessage
541     ) internal returns (bytes memory) {
542         require(address(this).balance >= value, "Address: insufficient balance for call");
543         require(isContract(target), "Address: call to non-contract");
544 
545         (bool success, bytes memory returndata) = target.call{value: value}(data);
546         return verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
556         return functionStaticCall(target, data, "Address: low-level static call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
561      * but performing a static call.
562      *
563      * _Available since v3.3._
564      */
565     function functionStaticCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal view returns (bytes memory) {
570         require(isContract(target), "Address: static call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.staticcall(data);
573         return verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but performing a delegate call.
579      *
580      * _Available since v3.4._
581      */
582     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
583         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal returns (bytes memory) {
597         require(isContract(target), "Address: delegate call to non-contract");
598 
599         (bool success, bytes memory returndata) = target.delegatecall(data);
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
605      * revert reason using the provided one.
606      *
607      * _Available since v4.3._
608      */
609     function verifyCallResult(
610         bool success,
611         bytes memory returndata,
612         string memory errorMessage
613     ) internal pure returns (bytes memory) {
614         if (success) {
615             return returndata;
616         } else {
617             // Look for revert reason and bubble it up if present
618             if (returndata.length > 0) {
619                 // The easiest way to bubble the revert reason is using memory via assembly
620 
621                 assembly {
622                     let returndata_size := mload(returndata)
623                     revert(add(32, returndata), returndata_size)
624                 }
625             } else {
626                 revert(errorMessage);
627             }
628         }
629     }
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @title ERC721 token receiver interface
641  * @dev Interface for any contract that wants to support safeTransfers
642  * from ERC721 asset contracts.
643  */
644 interface IERC721Receiver {
645     /**
646      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
647      * by `operator` from `from`, this function is called.
648      *
649      * It must return its Solidity selector to confirm the token transfer.
650      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
651      *
652      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
653      */
654     function onERC721Received(
655         address operator,
656         address from,
657         uint256 tokenId,
658         bytes calldata data
659     ) external returns (bytes4);
660 }
661 
662 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 /**
670  * @dev Interface of the ERC165 standard, as defined in the
671  * https://eips.ethereum.org/EIPS/eip-165[EIP].
672  *
673  * Implementers can declare support of contract interfaces, which can then be
674  * queried by others ({ERC165Checker}).
675  *
676  * For an implementation, see {ERC165}.
677  */
678 interface IERC165 {
679     /**
680      * @dev Returns true if this contract implements the interface defined by
681      * `interfaceId`. See the corresponding
682      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
683      * to learn more about how these ids are created.
684      *
685      * This function call must use less than 30 000 gas.
686      */
687     function supportsInterface(bytes4 interfaceId) external view returns (bool);
688 }
689 
690 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @dev Implementation of the {IERC165} interface.
700  *
701  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
702  * for the additional interface id that will be supported. For example:
703  *
704  * ```solidity
705  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
706  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
707  * }
708  * ```
709  *
710  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
711  */
712 abstract contract ERC165 is IERC165 {
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717         return interfaceId == type(IERC165).interfaceId;
718     }
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @dev Required interface of an ERC721 compliant contract.
731  */
732 interface IERC721 is IERC165 {
733     /**
734      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
735      */
736     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
737 
738     /**
739      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
740      */
741     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
742 
743     /**
744      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
745      */
746     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
747 
748     /**
749      * @dev Returns the number of tokens in ``owner``'s account.
750      */
751     function balanceOf(address owner) external view returns (uint256 balance);
752 
753     /**
754      * @dev Returns the owner of the `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function ownerOf(uint256 tokenId) external view returns (address owner);
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * Requirements:
767      *
768      * - `from` cannot be the zero address.
769      * - `to` cannot be the zero address.
770      * - `tokenId` token must exist and be owned by `from`.
771      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) external;
781 
782     /**
783      * @dev Transfers `tokenId` token from `from` to `to`.
784      *
785      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must be owned by `from`.
792      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
793      *
794      * Emits a {Transfer} event.
795      */
796     function transferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) external;
801 
802     /**
803      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
804      * The approval is cleared when the token is transferred.
805      *
806      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
807      *
808      * Requirements:
809      *
810      * - The caller must own the token or be an approved operator.
811      * - `tokenId` must exist.
812      *
813      * Emits an {Approval} event.
814      */
815     function approve(address to, uint256 tokenId) external;
816 
817     /**
818      * @dev Returns the account approved for `tokenId` token.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function getApproved(uint256 tokenId) external view returns (address operator);
825 
826     /**
827      * @dev Approve or remove `operator` as an operator for the caller.
828      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
829      *
830      * Requirements:
831      *
832      * - The `operator` cannot be the caller.
833      *
834      * Emits an {ApprovalForAll} event.
835      */
836     function setApprovalForAll(address operator, bool _approved) external;
837 
838     /**
839      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
840      *
841      * See {setApprovalForAll}
842      */
843     function isApprovedForAll(address owner, address operator) external view returns (bool);
844 
845     /**
846      * @dev Safely transfers `tokenId` token from `from` to `to`.
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must exist and be owned by `from`.
853      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
855      *
856      * Emits a {Transfer} event.
857      */
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 tokenId,
862         bytes calldata data
863     ) external;
864 }
865 
866 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
867 
868 
869 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
870 
871 pragma solidity ^0.8.0;
872 
873 
874 /**
875  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
876  * @dev See https://eips.ethereum.org/EIPS/eip-721
877  */
878 interface IERC721Enumerable is IERC721 {
879     /**
880      * @dev Returns the total amount of tokens stored by the contract.
881      */
882     function totalSupply() external view returns (uint256);
883 
884     /**
885      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
886      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
887      */
888     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
889 
890     /**
891      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
892      * Use along with {totalSupply} to enumerate all tokens.
893      */
894     function tokenByIndex(uint256 index) external view returns (uint256);
895 }
896 
897 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
898 
899 
900 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
901 
902 pragma solidity ^0.8.0;
903 
904 
905 /**
906  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
907  * @dev See https://eips.ethereum.org/EIPS/eip-721
908  */
909 interface IERC721Metadata is IERC721 {
910     /**
911      * @dev Returns the token collection name.
912      */
913     function name() external view returns (string memory);
914 
915     /**
916      * @dev Returns the token collection symbol.
917      */
918     function symbol() external view returns (string memory);
919 
920     /**
921      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
922      */
923     function tokenURI(uint256 tokenId) external view returns (string memory);
924 }
925 
926 // File: contracts/ERC721A.sol
927 
928 
929 
930 pragma solidity ^0.8.10;
931 
932 
933 
934 
935 
936 
937 
938 
939 
940 /**
941  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
942  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
943  *
944  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
945  *
946  * Does not support burning tokens to address(0).
947  */
948 contract ERC721A is
949   Context,
950   ERC165,
951   IERC721,
952   IERC721Metadata,
953   IERC721Enumerable
954 {
955   using Address for address;
956   using Strings for uint256;
957 
958   struct TokenOwnership {
959     address addr;
960     uint64 startTimestamp;
961   }
962 
963   struct AddressData {
964     uint128 balance;
965     uint128 numberMinted;
966   }
967 
968   uint256 private currentIndex = 1;
969 
970   uint256 public immutable maxBatchSize;
971 
972   // Token name
973   string private _name;
974 
975   // Token symbol
976   string private _symbol;
977 
978   // Mapping from token ID to ownership details
979   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
980   mapping(uint256 => TokenOwnership) private _ownerships;
981 
982   // Mapping owner address to address data
983   mapping(address => AddressData) private _addressData;
984 
985   // Mapping from token ID to approved address
986   mapping(uint256 => address) private _tokenApprovals;
987 
988   // Mapping from owner to operator approvals
989   mapping(address => mapping(address => bool)) private _operatorApprovals;
990 
991   /**
992    * @dev
993    * `maxBatchSize` refers to how much a minter can mint at a time.
994    */
995   constructor(
996     string memory name_,
997     string memory symbol_,
998     uint256 maxBatchSize_
999   ) {
1000     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1001     _name = name_;
1002     _symbol = symbol_;
1003     maxBatchSize = maxBatchSize_;
1004   }
1005 
1006   /**
1007    * @dev See {IERC721Enumerable-totalSupply}.
1008    */
1009   function totalSupply() public view override returns (uint256) {
1010     return currentIndex - 1;
1011   }
1012 
1013   /**
1014    * @dev See {IERC721Enumerable-tokenByIndex}.
1015    */
1016   function tokenByIndex(uint256 index) public view override returns (uint256) {
1017     require(index < totalSupply(), "ERC721A: global index out of bounds");
1018     return index;
1019   }
1020 
1021   /**
1022    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1023    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1024    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1025    */
1026   function tokenOfOwnerByIndex(address owner, uint256 index)
1027     public
1028     view
1029     override
1030     returns (uint256)
1031   {
1032     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1033     uint256 numMintedSoFar = totalSupply();
1034     uint256 tokenIdsIdx = 0;
1035     address currOwnershipAddr = address(0);
1036     for (uint256 i = 0; i < numMintedSoFar; i++) {
1037       TokenOwnership memory ownership = _ownerships[i];
1038       if (ownership.addr != address(0)) {
1039         currOwnershipAddr = ownership.addr;
1040       }
1041       if (currOwnershipAddr == owner) {
1042         if (tokenIdsIdx == index) {
1043           return i;
1044         }
1045         tokenIdsIdx++;
1046       }
1047     }
1048     revert("ERC721A: unable to get token of owner by index");
1049   }
1050 
1051   /**
1052    * @dev See {IERC165-supportsInterface}.
1053    */
1054   function supportsInterface(bytes4 interfaceId)
1055     public
1056     view
1057     virtual
1058     override(ERC165, IERC165)
1059     returns (bool)
1060   {
1061     return
1062       interfaceId == type(IERC721).interfaceId ||
1063       interfaceId == type(IERC721Metadata).interfaceId ||
1064       interfaceId == type(IERC721Enumerable).interfaceId ||
1065       super.supportsInterface(interfaceId);
1066   }
1067 
1068   /**
1069    * @dev See {IERC721-balanceOf}.
1070    */
1071   function balanceOf(address owner) public view override returns (uint256) {
1072     require(owner != address(0), "ERC721A: balance query for the zero address");
1073     return uint256(_addressData[owner].balance);
1074   }
1075 
1076   function _numberMinted(address owner) internal view returns (uint256) {
1077     require(
1078       owner != address(0),
1079       "ERC721A: number minted query for the zero address"
1080     );
1081     return uint256(_addressData[owner].numberMinted);
1082   }
1083 
1084   function ownershipOf(uint256 tokenId)
1085     internal
1086     view
1087     returns (TokenOwnership memory)
1088   {
1089     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1090 
1091     uint256 lowestTokenToCheck;
1092     if (tokenId >= maxBatchSize) {
1093       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1094     }
1095 
1096     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1097       TokenOwnership memory ownership = _ownerships[curr];
1098       if (ownership.addr != address(0)) {
1099         return ownership;
1100       }
1101     }
1102 
1103     revert("ERC721A: unable to determine the owner of token");
1104   }
1105 
1106   /**
1107    * @dev See {IERC721-ownerOf}.
1108    */
1109   function ownerOf(uint256 tokenId) public view override returns (address) {
1110     return ownershipOf(tokenId).addr;
1111   }
1112 
1113   /**
1114    * @dev See {IERC721Metadata-name}.
1115    */
1116   function name() public view virtual override returns (string memory) {
1117     return _name;
1118   }
1119 
1120   /**
1121    * @dev See {IERC721Metadata-symbol}.
1122    */
1123   function symbol() public view virtual override returns (string memory) {
1124     return _symbol;
1125   }
1126 
1127   /**
1128    * @dev See {IERC721Metadata-tokenURI}.
1129    */
1130   function tokenURI(uint256 tokenId)
1131     public
1132     view
1133     virtual
1134     override
1135     returns (string memory)
1136   {
1137     require(
1138       _exists(tokenId),
1139       "ERC721Metadata: URI query for nonexistent token"
1140     );
1141 
1142     string memory baseURI = _baseURI();
1143     return
1144       bytes(baseURI).length > 0
1145         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1146         : "";
1147   }
1148 
1149   /**
1150    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1151    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1152    * by default, can be overriden in child contracts.
1153    */
1154   function _baseURI() internal view virtual returns (string memory) {
1155     return "";
1156   }
1157 
1158   /**
1159    * @dev See {IERC721-approve}.
1160    */
1161   function approve(address to, uint256 tokenId) public override {
1162     address owner = ERC721A.ownerOf(tokenId);
1163     require(to != owner, "ERC721A: approval to current owner");
1164 
1165     require(
1166       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1167       "ERC721A: approve caller is not owner nor approved for all"
1168     );
1169 
1170     _approve(to, tokenId, owner);
1171   }
1172 
1173   /**
1174    * @dev See {IERC721-getApproved}.
1175    */
1176   function getApproved(uint256 tokenId) public view override returns (address) {
1177     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1178 
1179     return _tokenApprovals[tokenId];
1180   }
1181 
1182   /**
1183    * @dev See {IERC721-setApprovalForAll}.
1184    */
1185   function setApprovalForAll(address operator, bool approved) public override {
1186     require(operator != _msgSender(), "ERC721A: approve to caller");
1187 
1188     _operatorApprovals[_msgSender()][operator] = approved;
1189     emit ApprovalForAll(_msgSender(), operator, approved);
1190   }
1191 
1192   /**
1193    * @dev See {IERC721-isApprovedForAll}.
1194    */
1195   function isApprovedForAll(address owner, address operator)
1196     public
1197     view
1198     virtual
1199     override
1200     returns (bool)
1201   {
1202     return _operatorApprovals[owner][operator];
1203   }
1204 
1205   /**
1206    * @dev See {IERC721-transferFrom}.
1207    */
1208   function transferFrom(
1209     address from,
1210     address to,
1211     uint256 tokenId
1212   ) public override {
1213     _transfer(from, to, tokenId);
1214   }
1215 
1216   /**
1217    * @dev See {IERC721-safeTransferFrom}.
1218    */
1219   function safeTransferFrom(
1220     address from,
1221     address to,
1222     uint256 tokenId
1223   ) public override {
1224     safeTransferFrom(from, to, tokenId, "");
1225   }
1226 
1227   /**
1228    * @dev See {IERC721-safeTransferFrom}.
1229    */
1230   function safeTransferFrom(
1231     address from,
1232     address to,
1233     uint256 tokenId,
1234     bytes memory _data
1235   ) public override {
1236     _transfer(from, to, tokenId);
1237     require(
1238       _checkOnERC721Received(from, to, tokenId, _data),
1239       "ERC721A: transfer to non ERC721Receiver implementer"
1240     );
1241   }
1242 
1243   /**
1244    * @dev Returns whether `tokenId` exists.
1245    *
1246    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1247    *
1248    * Tokens start existing when they are minted (`_mint`),
1249    */
1250   function _exists(uint256 tokenId) internal view returns (bool) {
1251     return tokenId < currentIndex;
1252   }
1253 
1254   function _safeMint(address to, uint256 quantity) internal {
1255     _safeMint(to, quantity, "");
1256   }
1257 
1258   /**
1259    * @dev Mints `quantity` tokens and transfers them to `to`.
1260    *
1261    * Requirements:
1262    *
1263    * - `to` cannot be the zero address.
1264    * - `quantity` cannot be larger than the max batch size.
1265    *
1266    * Emits a {Transfer} event.
1267    */
1268   function _safeMint(
1269     address to,
1270     uint256 quantity,
1271     bytes memory _data
1272   ) internal {
1273     uint256 startTokenId = currentIndex;
1274     require(to != address(0), "ERC721A: mint to the zero address");
1275     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1276     require(!_exists(startTokenId), "ERC721A: token already minted");
1277     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1278 
1279     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1280 
1281     AddressData memory addressData = _addressData[to];
1282     _addressData[to] = AddressData(
1283       addressData.balance + uint128(quantity),
1284       addressData.numberMinted + uint128(quantity)
1285     );
1286     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1287 
1288     uint256 updatedIndex = startTokenId;
1289 
1290     for (uint256 i = 0; i < quantity; i++) {
1291       emit Transfer(address(0), to, updatedIndex);
1292       require(
1293         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1294         "ERC721A: transfer to non ERC721Receiver implementer"
1295       );
1296       updatedIndex++;
1297     }
1298 
1299     currentIndex = updatedIndex;
1300     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1301   }
1302 
1303   /**
1304    * @dev Transfers `tokenId` from `from` to `to`.
1305    *
1306    * Requirements:
1307    *
1308    * - `to` cannot be the zero address.
1309    * - `tokenId` token must be owned by `from`.
1310    *
1311    * Emits a {Transfer} event.
1312    */
1313   function _transfer(
1314     address from,
1315     address to,
1316     uint256 tokenId
1317   ) private {
1318     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1319 
1320     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1321       getApproved(tokenId) == _msgSender() ||
1322       isApprovedForAll(prevOwnership.addr, _msgSender()));
1323 
1324     require(
1325       isApprovedOrOwner,
1326       "ERC721A: transfer caller is not owner nor approved"
1327     );
1328 
1329     require(
1330       prevOwnership.addr == from,
1331       "ERC721A: transfer from incorrect owner"
1332     );
1333     require(to != address(0), "ERC721A: transfer to the zero address");
1334 
1335     _beforeTokenTransfers(from, to, tokenId, 1);
1336 
1337     // Clear approvals from the previous owner
1338     _approve(address(0), tokenId, prevOwnership.addr);
1339 
1340     _addressData[from].balance -= 1;
1341     _addressData[to].balance += 1;
1342     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1343 
1344     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1345     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1346     uint256 nextTokenId = tokenId + 1;
1347     if (_ownerships[nextTokenId].addr == address(0)) {
1348       if (_exists(nextTokenId)) {
1349         _ownerships[nextTokenId] = TokenOwnership(
1350           prevOwnership.addr,
1351           prevOwnership.startTimestamp
1352         );
1353       }
1354     }
1355 
1356     emit Transfer(from, to, tokenId);
1357     _afterTokenTransfers(from, to, tokenId, 1);
1358   }
1359 
1360   /**
1361    * @dev Approve `to` to operate on `tokenId`
1362    *
1363    * Emits a {Approval} event.
1364    */
1365   function _approve(
1366     address to,
1367     uint256 tokenId,
1368     address owner
1369   ) private {
1370     _tokenApprovals[tokenId] = to;
1371     emit Approval(owner, to, tokenId);
1372   }
1373 
1374   uint256 public nextOwnerToExplicitlySet = 0;
1375 
1376   /**
1377    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1378    */
1379   function _setOwnersExplicit(uint256 quantity) internal {
1380     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1381     require(quantity > 0, "quantity must be nonzero");
1382     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1383     if (endIndex > currentIndex - 1) {
1384       endIndex = currentIndex - 1;
1385     }
1386     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1387     require(_exists(endIndex), "not enough minted yet for this cleanup");
1388     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1389       if (_ownerships[i].addr == address(0)) {
1390         TokenOwnership memory ownership = ownershipOf(i);
1391         _ownerships[i] = TokenOwnership(
1392           ownership.addr,
1393           ownership.startTimestamp
1394         );
1395       }
1396     }
1397     nextOwnerToExplicitlySet = endIndex + 1;
1398   }
1399 
1400   /**
1401    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1402    * The call is not executed if the target address is not a contract.
1403    *
1404    * @param from address representing the previous owner of the given token ID
1405    * @param to target address that will receive the tokens
1406    * @param tokenId uint256 ID of the token to be transferred
1407    * @param _data bytes optional data to send along with the call
1408    * @return bool whether the call correctly returned the expected magic value
1409    */
1410   function _checkOnERC721Received(
1411     address from,
1412     address to,
1413     uint256 tokenId,
1414     bytes memory _data
1415   ) private returns (bool) {
1416     if (to.isContract()) {
1417       try
1418         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1419       returns (bytes4 retval) {
1420         return retval == IERC721Receiver(to).onERC721Received.selector;
1421       } catch (bytes memory reason) {
1422         if (reason.length == 0) {
1423           revert("ERC721A: transfer to non ERC721Receiver implementer");
1424         } else {
1425           assembly {
1426             revert(add(32, reason), mload(reason))
1427           }
1428         }
1429       }
1430     } else {
1431       return true;
1432     }
1433   }
1434 
1435   /**
1436    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1437    *
1438    * startTokenId - the first token id to be transferred
1439    * quantity - the amount to be transferred
1440    *
1441    * Calling conditions:
1442    *
1443    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1444    * transferred to `to`.
1445    * - When `from` is zero, `tokenId` will be minted for `to`.
1446    */
1447   function _beforeTokenTransfers(
1448     address from,
1449     address to,
1450     uint256 startTokenId,
1451     uint256 quantity
1452   ) internal virtual {}
1453 
1454   /**
1455    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1456    * minting.
1457    *
1458    * startTokenId - the first token id to be transferred
1459    * quantity - the amount to be transferred
1460    *
1461    * Calling conditions:
1462    *
1463    * - when `from` and `to` are both non-zero.
1464    * - `from` and `to` are never both zero.
1465    */
1466   function _afterTokenTransfers(
1467     address from,
1468     address to,
1469     uint256 startTokenId,
1470     uint256 quantity
1471   ) internal virtual {}
1472 }
1473 // File: contracts/FF.sol
1474 
1475 
1476 
1477 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
1478 
1479 
1480 
1481 pragma solidity >=0.7.0 <0.9.0;
1482 
1483 
1484 
1485 
1486 
1487 contract FFMfers is ERC721A, Ownable {
1488   using Strings for uint256;
1489 
1490   string public baseURI;
1491   string public baseExtension = ".json";
1492   uint256 public cost = 0.0069 ether;
1493   uint256 public maxSupply = 6969;
1494   uint256 public maxsize = 20 ; // max mint per tx
1495   bool public paused = false;
1496 
1497   constructor() ERC721A("FFMfers", "FFMfers", maxsize) {
1498     setBaseURI("ipfs://QmUbdwPuafxtR7wvEmd5xpheTn2f1tNuaGcwvrMioPUs5C/");
1499   }
1500 
1501   // internal
1502   function _baseURI() internal view virtual override returns (string memory) {
1503     return baseURI;
1504   }
1505 
1506   // public
1507   function mint(uint256 tokens) public payable {
1508     require(!paused, "FFMfers: oops contract is paused");
1509     uint256 supply = totalSupply();
1510     require(tokens > 0, "FFMfers: need to mint at least 1 NFT");
1511     require(tokens <= maxsize, "FFMfers: max mint amount per tx exceeded");
1512     require(supply + tokens <= maxSupply, "FFMfers: We Soldout");
1513     if (supply < 500) {
1514       require(msg.value >= 0 * tokens, "FFMfers: It's Free Mint");
1515     } else {
1516 
1517     require(msg.value >= cost * tokens, "FFMfers: insufficient funds");
1518     }
1519 
1520       _safeMint(_msgSender(), tokens);
1521     
1522   }
1523 
1524 
1525 
1526   /// @dev use it for giveaway and mint for yourself
1527      function gift(uint256 _mintAmount, address destination) public onlyOwner {
1528     require(_mintAmount > 0, "need to mint at least 1 NFT");
1529     uint256 supply = totalSupply();
1530     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1531 
1532       _safeMint(destination, _mintAmount);
1533     
1534   }
1535 
1536   
1537 
1538 
1539   function walletOfOwner(address _owner)
1540     public
1541     view
1542     returns (uint256[] memory)
1543   {
1544     uint256 ownerTokenCount = balanceOf(_owner);
1545     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1546     for (uint256 i; i < ownerTokenCount; i++) {
1547       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1548     }
1549     return tokenIds;
1550   }
1551 
1552   function tokenURI(uint256 tokenId)
1553     public
1554     view
1555     virtual
1556     override
1557     returns (string memory)
1558   {
1559     require(
1560       _exists(tokenId),
1561       "ERC721AMetadata: URI query for nonexistent token"
1562     );
1563     
1564 
1565     string memory currentBaseURI = _baseURI();
1566     return bytes(currentBaseURI).length > 0
1567         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1568         : "";
1569   }
1570 
1571   //only owner
1572 
1573   function setCost(uint256 _newCost) public onlyOwner {
1574     cost = _newCost;
1575   }
1576 
1577     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1578     maxSupply = _newsupply;
1579   }
1580 
1581 
1582   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1583     baseURI = _newBaseURI;
1584   }
1585 
1586   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1587     baseExtension = _newBaseExtension;
1588   }
1589   
1590 
1591   function pause(bool _state) public onlyOwner {
1592     paused = _state;
1593   }
1594  
1595   function withdraw() public payable onlyOwner {
1596     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1597     require(success);
1598   }
1599 }