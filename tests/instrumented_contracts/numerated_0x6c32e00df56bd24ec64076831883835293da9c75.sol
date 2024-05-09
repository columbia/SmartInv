1 // SPDX-License-Identifier: MIT
2 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
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
232 // File: openzeppelin-solidity/contracts/utils/Strings.sol
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
302 // File: openzeppelin-solidity/contracts/utils/Context.sol
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
329 // File: openzeppelin-solidity/contracts/access/Ownable.sol
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
407 // File: openzeppelin-solidity/contracts/utils/Address.sol
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
632 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
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
662 // File: openzeppelin-solidity/contracts/utils/introspection/IERC165.sol
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
690 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
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
721 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
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
866 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Enumerable.sol
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
897 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Metadata.sol
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
929 // Creator: Chiru Labs
930 
931 pragma solidity ^0.8.4;
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
942 error ApprovalQueryForNonexistentToken();
943 error ApproveToCaller();
944 error ApprovalToCurrentOwner();
945 error BalanceQueryForZeroAddress();
946 error MintedQueryForZeroAddress();
947 error BurnedQueryForZeroAddress();
948 error MintToZeroAddress();
949 error MintZeroQuantity();
950 error OwnerIndexOutOfBounds();
951 error OwnerQueryForNonexistentToken();
952 error TokenIndexOutOfBounds();
953 error TransferCallerNotOwnerNorApproved();
954 error TransferFromIncorrectOwner();
955 error TransferToNonERC721ReceiverImplementer();
956 error TransferToZeroAddress();
957 error URIQueryForNonexistentToken();
958 
959 /**
960  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
961  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
962  *
963  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
964  *
965  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
966  *
967  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
968  */
969 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
970     using Address for address;
971     using Strings for uint256;
972 
973     // Compiler will pack this into a single 256bit word.
974     struct TokenOwnership {
975         // The address of the owner.
976         address addr;
977         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
978         uint64 startTimestamp;
979         // Whether the token has been burned.
980         bool burned;
981     }
982 
983     // Compiler will pack this into a single 256bit word.
984     struct AddressData {
985         // Realistically, 2**64-1 is more than enough.
986         uint64 balance;
987         // Keeps track of mint count with minimal overhead for tokenomics.
988         uint64 numberMinted;
989         // Keeps track of burn count with minimal overhead for tokenomics.
990         uint64 numberBurned;
991     }
992 
993     // Compiler will pack the following 
994     // _currentIndex and _burnCounter into a single 256bit word.
995     
996     // The tokenId of the next token to be minted.
997     uint128 internal _currentIndex;
998 
999     // The number of tokens burned.
1000     uint128 internal _burnCounter;
1001 
1002     // Token name
1003     string private _name;
1004 
1005     // Token symbol
1006     string private _symbol;
1007 
1008     // Mapping from token ID to ownership details
1009     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1010     mapping(uint256 => TokenOwnership) internal _ownerships;
1011 
1012     // Mapping owner address to address data
1013     mapping(address => AddressData) private _addressData;
1014 
1015     // Mapping from token ID to approved address
1016     mapping(uint256 => address) private _tokenApprovals;
1017 
1018     // Mapping from owner to operator approvals
1019     mapping(address => mapping(address => bool)) private _operatorApprovals;
1020 
1021     constructor(string memory name_, string memory symbol_) {
1022         _name = name_;
1023         _symbol = symbol_;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-totalSupply}.
1028      */
1029     function totalSupply() public view override returns (uint256) {
1030         // Counter underflow is impossible as _burnCounter cannot be incremented
1031         // more than _currentIndex times
1032         unchecked {
1033             return _currentIndex - _burnCounter;    
1034         }
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Enumerable-tokenByIndex}.
1039      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1040      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1041      */
1042     function tokenByIndex(uint256 index) public view override returns (uint256) {
1043         uint256 numMintedSoFar = _currentIndex;
1044         uint256 tokenIdsIdx;
1045 
1046         // Counter overflow is impossible as the loop breaks when
1047         // uint256 i is equal to another uint256 numMintedSoFar.
1048         unchecked {
1049             for (uint256 i; i < numMintedSoFar; i++) {
1050                 TokenOwnership memory ownership = _ownerships[i];
1051                 if (!ownership.burned) {
1052                     if (tokenIdsIdx == index) {
1053                         return i;
1054                     }
1055                     tokenIdsIdx++;
1056                 }
1057             }
1058         }
1059         revert TokenIndexOutOfBounds();
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1064      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1065      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1066      */
1067     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1068         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1069         uint256 numMintedSoFar = _currentIndex;
1070         uint256 tokenIdsIdx;
1071         address currOwnershipAddr;
1072 
1073         // Counter overflow is impossible as the loop breaks when
1074         // uint256 i is equal to another uint256 numMintedSoFar.
1075         unchecked {
1076             for (uint256 i; i < numMintedSoFar; i++) {
1077                 TokenOwnership memory ownership = _ownerships[i];
1078                 if (ownership.burned) {
1079                     continue;
1080                 }
1081                 if (ownership.addr != address(0)) {
1082                     currOwnershipAddr = ownership.addr;
1083                 }
1084                 if (currOwnershipAddr == owner) {
1085                     if (tokenIdsIdx == index) {
1086                         return i;
1087                     }
1088                     tokenIdsIdx++;
1089                 }
1090             }
1091         }
1092 
1093         // Execution should never reach this point.
1094         revert();
1095     }
1096 
1097     /**
1098      * @dev See {IERC165-supportsInterface}.
1099      */
1100     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1101         return
1102             interfaceId == type(IERC721).interfaceId ||
1103             interfaceId == type(IERC721Metadata).interfaceId ||
1104             interfaceId == type(IERC721Enumerable).interfaceId ||
1105             super.supportsInterface(interfaceId);
1106     }
1107 
1108     /**
1109      * @dev See {IERC721-balanceOf}.
1110      */
1111     function balanceOf(address owner) public view override returns (uint256) {
1112         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1113         return uint256(_addressData[owner].balance);
1114     }
1115 
1116     function _numberMinted(address owner) internal view returns (uint256) {
1117         if (owner == address(0)) revert MintedQueryForZeroAddress();
1118         return uint256(_addressData[owner].numberMinted);
1119     }
1120 
1121     function _numberBurned(address owner) internal view returns (uint256) {
1122         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1123         return uint256(_addressData[owner].numberBurned);
1124     }
1125 
1126     /**
1127      * Gas spent here starts off proportional to the maximum mint batch size.
1128      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1129      */
1130     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1131         uint256 curr = tokenId;
1132 
1133         unchecked {
1134             if (curr < _currentIndex) {
1135                 TokenOwnership memory ownership = _ownerships[curr];
1136                 if (!ownership.burned) {
1137                     if (ownership.addr != address(0)) {
1138                         return ownership;
1139                     }
1140                     // Invariant: 
1141                     // There will always be an ownership that has an address and is not burned 
1142                     // before an ownership that does not have an address and is not burned.
1143                     // Hence, curr will not underflow.
1144                     while (true) {
1145                         curr--;
1146                         ownership = _ownerships[curr];
1147                         if (ownership.addr != address(0)) {
1148                             return ownership;
1149                         }
1150                     }
1151                 }
1152             }
1153         }
1154         revert OwnerQueryForNonexistentToken();
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-ownerOf}.
1159      */
1160     function ownerOf(uint256 tokenId) public view override returns (address) {
1161         return ownershipOf(tokenId).addr;
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Metadata-name}.
1166      */
1167     function name() public view virtual override returns (string memory) {
1168         return _name;
1169     }
1170 
1171     /**
1172      * @dev See {IERC721Metadata-symbol}.
1173      */
1174     function symbol() public view virtual override returns (string memory) {
1175         return _symbol;
1176     }
1177 
1178     /**
1179      * @dev See {IERC721Metadata-tokenURI}.
1180      */
1181     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1182         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1183 
1184         string memory baseURI = _baseURI();
1185         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1186     }
1187 
1188     /**
1189      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1190      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1191      * by default, can be overriden in child contracts.
1192      */
1193     function _baseURI() internal view virtual returns (string memory) {
1194         return '';
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-approve}.
1199      */
1200     function approve(address to, uint256 tokenId) public override {
1201         address owner = ERC721A.ownerOf(tokenId);
1202         if (to == owner) revert ApprovalToCurrentOwner();
1203 
1204         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1205             revert ApprovalCallerNotOwnerNorApproved();
1206         }
1207 
1208         _approve(to, tokenId, owner);
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-getApproved}.
1213      */
1214     function getApproved(uint256 tokenId) public view override returns (address) {
1215         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1216 
1217         return _tokenApprovals[tokenId];
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-setApprovalForAll}.
1222      */
1223     function setApprovalForAll(address operator, bool approved) public override {
1224         if (operator == _msgSender()) revert ApproveToCaller();
1225 
1226         _operatorApprovals[_msgSender()][operator] = approved;
1227         emit ApprovalForAll(_msgSender(), operator, approved);
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-isApprovedForAll}.
1232      */
1233     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1234         return _operatorApprovals[owner][operator];
1235     }
1236 
1237     /**
1238      * @dev See {IERC721-transferFrom}.
1239      */
1240     function transferFrom(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) public virtual override {
1245         _transfer(from, to, tokenId);
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-safeTransferFrom}.
1250      */
1251     function safeTransferFrom(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) public virtual override {
1256         safeTransferFrom(from, to, tokenId, '');
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-safeTransferFrom}.
1261      */
1262     function safeTransferFrom(
1263         address from,
1264         address to,
1265         uint256 tokenId,
1266         bytes memory _data
1267     ) public virtual override {
1268         _transfer(from, to, tokenId);
1269         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1270             revert TransferToNonERC721ReceiverImplementer();
1271         }
1272     }
1273 
1274     /**
1275      * @dev Returns whether `tokenId` exists.
1276      *
1277      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1278      *
1279      * Tokens start existing when they are minted (`_mint`),
1280      */
1281     function _exists(uint256 tokenId) internal view returns (bool) {
1282         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1283     }
1284 
1285     function _safeMint(address to, uint256 quantity) internal {
1286         _safeMint(to, quantity, '');
1287     }
1288 
1289     /**
1290      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1291      *
1292      * Requirements:
1293      *
1294      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1295      * - `quantity` must be greater than 0.
1296      *
1297      * Emits a {Transfer} event.
1298      */
1299     function _safeMint(
1300         address to,
1301         uint256 quantity,
1302         bytes memory _data
1303     ) internal {
1304         _mint(to, quantity, _data, true);
1305     }
1306 
1307     /**
1308      * @dev Mints `quantity` tokens and transfers them to `to`.
1309      *
1310      * Requirements:
1311      *
1312      * - `to` cannot be the zero address.
1313      * - `quantity` must be greater than 0.
1314      *
1315      * Emits a {Transfer} event.
1316      */
1317     function _mint(
1318         address to,
1319         uint256 quantity,
1320         bytes memory _data,
1321         bool safe
1322     ) internal {
1323         uint256 startTokenId = _currentIndex;
1324         if (to == address(0)) revert MintToZeroAddress();
1325         if (quantity == 0) revert MintZeroQuantity();
1326 
1327         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1328 
1329         // Overflows are incredibly unrealistic.
1330         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1331         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1332         unchecked {
1333             _addressData[to].balance += uint64(quantity);
1334             _addressData[to].numberMinted += uint64(quantity);
1335 
1336             _ownerships[startTokenId].addr = to;
1337             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1338 
1339             uint256 updatedIndex = startTokenId;
1340 
1341             for (uint256 i; i < quantity; i++) {
1342                 emit Transfer(address(0), to, updatedIndex);
1343                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1344                     revert TransferToNonERC721ReceiverImplementer();
1345                 }
1346                 updatedIndex++;
1347             }
1348 
1349             _currentIndex = uint128(updatedIndex);
1350         }
1351         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1352     }
1353 
1354     /**
1355      * @dev Transfers `tokenId` from `from` to `to`.
1356      *
1357      * Requirements:
1358      *
1359      * - `to` cannot be the zero address.
1360      * - `tokenId` token must be owned by `from`.
1361      *
1362      * Emits a {Transfer} event.
1363      */
1364     function _transfer(
1365         address from,
1366         address to,
1367         uint256 tokenId
1368     ) private {
1369         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1370 
1371         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1372             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1373             getApproved(tokenId) == _msgSender());
1374 
1375         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1376         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1377         if (to == address(0)) revert TransferToZeroAddress();
1378 
1379         _beforeTokenTransfers(from, to, tokenId, 1);
1380 
1381         // Clear approvals from the previous owner
1382         _approve(address(0), tokenId, prevOwnership.addr);
1383 
1384         // Underflow of the sender's balance is impossible because we check for
1385         // ownership above and the recipient's balance can't realistically overflow.
1386         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1387         unchecked {
1388             _addressData[from].balance -= 1;
1389             _addressData[to].balance += 1;
1390 
1391             _ownerships[tokenId].addr = to;
1392             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1393 
1394             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1395             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1396             uint256 nextTokenId = tokenId + 1;
1397             if (_ownerships[nextTokenId].addr == address(0)) {
1398                 // This will suffice for checking _exists(nextTokenId),
1399                 // as a burned slot cannot contain the zero address.
1400                 if (nextTokenId < _currentIndex) {
1401                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1402                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1403                 }
1404             }
1405         }
1406 
1407         emit Transfer(from, to, tokenId);
1408         _afterTokenTransfers(from, to, tokenId, 1);
1409     }
1410 
1411     /**
1412      * @dev Destroys `tokenId`.
1413      * The approval is cleared when the token is burned.
1414      *
1415      * Requirements:
1416      *
1417      * - `tokenId` must exist.
1418      *
1419      * Emits a {Transfer} event.
1420      */
1421     function _burn(uint256 tokenId) internal virtual {
1422         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1423 
1424         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1425 
1426         // Clear approvals from the previous owner
1427         _approve(address(0), tokenId, prevOwnership.addr);
1428 
1429         // Underflow of the sender's balance is impossible because we check for
1430         // ownership above and the recipient's balance can't realistically overflow.
1431         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1432         unchecked {
1433             _addressData[prevOwnership.addr].balance -= 1;
1434             _addressData[prevOwnership.addr].numberBurned += 1;
1435 
1436             // Keep track of who burned the token, and the timestamp of burning.
1437             _ownerships[tokenId].addr = prevOwnership.addr;
1438             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1439             _ownerships[tokenId].burned = true;
1440 
1441             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1442             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1443             uint256 nextTokenId = tokenId + 1;
1444             if (_ownerships[nextTokenId].addr == address(0)) {
1445                 // This will suffice for checking _exists(nextTokenId),
1446                 // as a burned slot cannot contain the zero address.
1447                 if (nextTokenId < _currentIndex) {
1448                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1449                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1450                 }
1451             }
1452         }
1453 
1454         emit Transfer(prevOwnership.addr, address(0), tokenId);
1455         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1456 
1457         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1458         unchecked { 
1459             _burnCounter++;
1460         }
1461     }
1462 
1463     /**
1464      * @dev Approve `to` to operate on `tokenId`
1465      *
1466      * Emits a {Approval} event.
1467      */
1468     function _approve(
1469         address to,
1470         uint256 tokenId,
1471         address owner
1472     ) private {
1473         _tokenApprovals[tokenId] = to;
1474         emit Approval(owner, to, tokenId);
1475     }
1476 
1477     /**
1478      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1479      * The call is not executed if the target address is not a contract.
1480      *
1481      * @param from address representing the previous owner of the given token ID
1482      * @param to target address that will receive the tokens
1483      * @param tokenId uint256 ID of the token to be transferred
1484      * @param _data bytes optional data to send along with the call
1485      * @return bool whether the call correctly returned the expected magic value
1486      */
1487     function _checkOnERC721Received(
1488         address from,
1489         address to,
1490         uint256 tokenId,
1491         bytes memory _data
1492     ) private returns (bool) {
1493         if (to.isContract()) {
1494             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1495                 return retval == IERC721Receiver(to).onERC721Received.selector;
1496             } catch (bytes memory reason) {
1497                 if (reason.length == 0) {
1498                     revert TransferToNonERC721ReceiverImplementer();
1499                 } else {
1500                     assembly {
1501                         revert(add(32, reason), mload(reason))
1502                     }
1503                 }
1504             }
1505         } else {
1506             return true;
1507         }
1508     }
1509 
1510     /**
1511      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1512      * And also called before burning one token.
1513      *
1514      * startTokenId - the first token id to be transferred
1515      * quantity - the amount to be transferred
1516      *
1517      * Calling conditions:
1518      *
1519      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1520      * transferred to `to`.
1521      * - When `from` is zero, `tokenId` will be minted for `to`.
1522      * - When `to` is zero, `tokenId` will be burned by `from`.
1523      * - `from` and `to` are never both zero.
1524      */
1525     function _beforeTokenTransfers(
1526         address from,
1527         address to,
1528         uint256 startTokenId,
1529         uint256 quantity
1530     ) internal virtual {}
1531 
1532     /**
1533      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1534      * minting.
1535      * And also called after one token has been burned.
1536      *
1537      * startTokenId - the first token id to be transferred
1538      * quantity - the amount to be transferred
1539      *
1540      * Calling conditions:
1541      *
1542      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1543      * transferred to `to`.
1544      * - When `from` is zero, `tokenId` has been minted for `to`.
1545      * - When `to` is zero, `tokenId` has been burned by `from`.
1546      * - `from` and `to` are never both zero.
1547      */
1548     function _afterTokenTransfers(
1549         address from,
1550         address to,
1551         uint256 startTokenId,
1552         uint256 quantity
1553     ) internal virtual {}
1554 }
1555 // File: contracts/Goopies.sol
1556 
1557 
1558 
1559 pragma solidity ^0.8.4;
1560 
1561 
1562 
1563 
1564 
1565 contract OwnableDelegateProxy {}
1566 
1567 contract ProxyRegistry {
1568     mapping(address => OwnableDelegateProxy) public proxies;
1569 }
1570 
1571 contract Goopies is ERC721A, Ownable {
1572     using SafeMath for uint256;
1573     using Strings for uint256;
1574     uint256 public constant maxSupply = 2000;
1575     uint256 public constant freeMints = 1600;
1576     uint256 public constant maxFreeMintsPerWallet = 40;
1577     uint256 public reservedAssets = 0;
1578     uint256 public maxPurchase = 20;
1579     uint256 public _price = 0.01 ether;
1580     string public _baseTokenURI;
1581     string public _uriSuffix = ".json";
1582     bool public isSaleActive;
1583     address proxyRegistryAddress;
1584 
1585     mapping (uint256 => string) private _tokenURIs;
1586     mapping (address => uint256) private freeMintsWallet;
1587 
1588     constructor(string memory baseURI, address _proxyRegistryAddress) ERC721A("Goopies", "GOOP") {
1589         setBaseURI(baseURI);
1590         isSaleActive = false;
1591         proxyRegistryAddress = _proxyRegistryAddress;
1592     }
1593 
1594     function mintNFT(uint256 numAssets) external payable {
1595         require(isSaleActive, "Sale is not active!");
1596         require(numAssets >= 0 && numAssets <= maxPurchase,
1597             "You can only mint 20 assets at a time!");
1598         require(totalSupply().add(numAssets) <= maxSupply - reservedAssets,
1599             "Not enough assets available...");
1600 
1601         if(totalSupply().add(numAssets) > freeMints){
1602             require(msg.value >= _price.mul(numAssets),
1603                 "Not enough ETH for this purchase!");
1604         }else{
1605             require(totalSupply().add(numAssets) <= freeMints,
1606                 "You would exceed the number of free mints");
1607             require(freeMintsWallet[msg.sender].add(numAssets) <= maxFreeMintsPerWallet, 
1608                 "You can only mint 40 assets for free!");
1609             freeMintsWallet[msg.sender] += numAssets;
1610         }
1611         _safeMint(msg.sender, numAssets);
1612     }
1613 
1614 
1615     function assetOfOwner(address _owner) external view returns(uint256[] memory) {
1616         uint256 tokenCount = balanceOf(_owner);
1617         if (tokenCount == 0) {
1618             return new uint256[](0);
1619         } else {
1620             uint256[] memory tokensId = new uint256[](tokenCount);
1621             for (uint256 i = 0; i < tokenCount; i++){
1622                 tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1623             }
1624             return tokensId;
1625         }
1626     }
1627 
1628     function setPrice(uint256 newPrice) public onlyOwner {
1629         _price = newPrice;
1630     }
1631 
1632     function flipSaleState() public onlyOwner {
1633         isSaleActive = !isSaleActive;
1634     }
1635 
1636     function _baseURI() internal view virtual override returns (string memory) {
1637         return _baseTokenURI;
1638     }
1639 
1640     function setBaseURI(string memory baseURI) public onlyOwner {
1641         _baseTokenURI = baseURI;
1642     }
1643     function setUriSuffix(string memory uriSuffix) public onlyOwner {
1644         _uriSuffix = uriSuffix;
1645     }
1646 
1647     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1648         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1649 
1650         string memory baseURI = _baseURI();
1651         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), _uriSuffix)) : "";
1652     }
1653 
1654     function mintNFTS(address _to, uint256 _amount) external onlyOwner() {
1655         require(totalSupply().add(_amount) <= maxSupply - reservedAssets,
1656             "Hold up! You would buy more assets than available...");
1657         _safeMint(_to, _amount);  
1658     }
1659 
1660     function withdrawAll() public onlyOwner {
1661         uint256 balance = address(this).balance;
1662         require(payable(msg.sender).send(balance),
1663             "Withdraw did not work...");
1664     }
1665 
1666     function isApprovedForAll(address owner, address operator) override public view returns(bool){
1667         // Whitelist OpenSea proxy contract for easy trading.
1668         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1669         if (address(proxyRegistry.proxies(owner)) == operator) {
1670             return true;
1671         }
1672 
1673         return super.isApprovedForAll(owner, operator);
1674     }
1675 
1676     function setProxyRegistryAddress(address proxyAddress) external onlyOwner {
1677         proxyRegistryAddress = proxyAddress;
1678     }
1679 }