1 // SPDX-License-Identifier: MIT
2 // File: contracts/SafeMath.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
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
234 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
303 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
329 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
406 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
407 
408 pragma solidity ^0.8.0;
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
430      */
431     function isContract(address account) internal view returns (bool) {
432         // This method relies on extcodesize, which returns 0 for contracts in
433         // construction, since the code is only stored at the end of the
434         // constructor execution.
435 
436         uint256 size;
437         assembly {
438             size := extcodesize(account)
439         }
440         return size > 0;
441     }
442 
443     /**
444      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
445      * `recipient`, forwarding all available gas and reverting on errors.
446      *
447      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
448      * of certain opcodes, possibly making contracts go over the 2300 gas limit
449      * imposed by `transfer`, making them unable to receive funds via
450      * `transfer`. {sendValue} removes this limitation.
451      *
452      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
453      *
454      * IMPORTANT: because control is transferred to `recipient`, care must be
455      * taken to not create reentrancy vulnerabilities. Consider using
456      * {ReentrancyGuard} or the
457      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
458      */
459     function sendValue(address payable recipient, uint256 amount) internal {
460         require(address(this).balance >= amount, "Address: insufficient balance");
461 
462         (bool success, ) = recipient.call{value: amount}("");
463         require(success, "Address: unable to send value, recipient may have reverted");
464     }
465 
466     /**
467      * @dev Performs a Solidity function call using a low level `call`. A
468      * plain `call` is an unsafe replacement for a function call: use this
469      * function instead.
470      *
471      * If `target` reverts with a revert reason, it is bubbled up by this
472      * function (like regular Solidity function calls).
473      *
474      * Returns the raw returned data. To convert to the expected return value,
475      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
476      *
477      * Requirements:
478      *
479      * - `target` must be a contract.
480      * - calling `target` with `data` must not revert.
481      *
482      * _Available since v3.1._
483      */
484     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
485         return functionCall(target, data, "Address: low-level call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
490      * `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal returns (bytes memory) {
499         return functionCallWithValue(target, data, 0, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but also transferring `value` wei to `target`.
505      *
506      * Requirements:
507      *
508      * - the calling contract must have an ETH balance of at least `value`.
509      * - the called Solidity function must be `payable`.
510      *
511      * _Available since v3.1._
512      */
513     function functionCallWithValue(
514         address target,
515         bytes memory data,
516         uint256 value
517     ) internal returns (bytes memory) {
518         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
523      * with `errorMessage` as a fallback revert reason when `target` reverts.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(
528         address target,
529         bytes memory data,
530         uint256 value,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         require(address(this).balance >= value, "Address: insufficient balance for call");
534         require(isContract(target), "Address: call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.call{value: value}(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
547         return functionStaticCall(target, data, "Address: low-level static call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(
557         address target,
558         bytes memory data,
559         string memory errorMessage
560     ) internal view returns (bytes memory) {
561         require(isContract(target), "Address: static call to non-contract");
562 
563         (bool success, bytes memory returndata) = target.staticcall(data);
564         return verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
569      * but performing a delegate call.
570      *
571      * _Available since v3.4._
572      */
573     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
574         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
579      * but performing a delegate call.
580      *
581      * _Available since v3.4._
582      */
583     function functionDelegateCall(
584         address target,
585         bytes memory data,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         require(isContract(target), "Address: delegate call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.delegatecall(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
596      * revert reason using the provided one.
597      *
598      * _Available since v4.3._
599      */
600     function verifyCallResult(
601         bool success,
602         bytes memory returndata,
603         string memory errorMessage
604     ) internal pure returns (bytes memory) {
605         if (success) {
606             return returndata;
607         } else {
608             // Look for revert reason and bubble it up if present
609             if (returndata.length > 0) {
610                 // The easiest way to bubble the revert reason is using memory via assembly
611 
612                 assembly {
613                     let returndata_size := mload(returndata)
614                     revert(add(32, returndata), returndata_size)
615                 }
616             } else {
617                 revert(errorMessage);
618             }
619         }
620     }
621 }
622 // File: contracts/IERC721Receiver.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @title ERC721 token receiver interface
631  * @dev Interface for any contract that wants to support safeTransfers
632  * from ERC721 asset contracts.
633  */
634 interface IERC721Receiver {
635     /**
636      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
637      * by `operator` from `from`, this function is called.
638      *
639      * It must return its Solidity selector to confirm the token transfer.
640      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
641      *
642      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
643      */
644     function onERC721Received(
645         address operator,
646         address from,
647         uint256 tokenId,
648         bytes calldata data
649     ) external returns (bytes4);
650 }
651 // File: contracts/IERC165.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Interface of the ERC165 standard, as defined in the
660  * https://eips.ethereum.org/EIPS/eip-165[EIP].
661  *
662  * Implementers can declare support of contract interfaces, which can then be
663  * queried by others ({ERC165Checker}).
664  *
665  * For an implementation, see {ERC165}.
666  */
667 interface IERC165 {
668     /**
669      * @dev Returns true if this contract implements the interface defined by
670      * `interfaceId`. See the corresponding
671      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
672      * to learn more about how these ids are created.
673      *
674      * This function call must use less than 30 000 gas.
675      */
676     function supportsInterface(bytes4 interfaceId) external view returns (bool);
677 }
678 // File: contracts/ERC165.sol
679 
680 
681 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @dev Implementation of the {IERC165} interface.
688  *
689  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
690  * for the additional interface id that will be supported. For example:
691  *
692  * ```solidity
693  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
695  * }
696  * ```
697  *
698  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
699  */
700 abstract contract ERC165 is IERC165 {
701     /**
702      * @dev See {IERC165-supportsInterface}.
703      */
704     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
705         return interfaceId == type(IERC165).interfaceId;
706     }
707 }
708 // File: contracts/IERC721.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @dev Required interface of an ERC721 compliant contract.
718  */
719 interface IERC721 is IERC165 {
720     /**
721      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
722      */
723     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
724 
725     /**
726      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
727      */
728     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
729 
730     /**
731      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
732      */
733     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
734 
735     /**
736      * @dev Returns the number of tokens in ``owner``'s account.
737      */
738     function balanceOf(address owner) external view returns (uint256 balance);
739 
740     /**
741      * @dev Returns the owner of the `tokenId` token.
742      *
743      * Requirements:
744      *
745      * - `tokenId` must exist.
746      */
747     function ownerOf(uint256 tokenId) external view returns (address owner);
748 
749     /**
750      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
751      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
752      *
753      * Requirements:
754      *
755      * - `from` cannot be the zero address.
756      * - `to` cannot be the zero address.
757      * - `tokenId` token must exist and be owned by `from`.
758      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
759      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
760      *
761      * Emits a {Transfer} event.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId
767     ) external;
768 
769     /**
770      * @dev Transfers `tokenId` token from `from` to `to`.
771      *
772      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
773      *
774      * Requirements:
775      *
776      * - `from` cannot be the zero address.
777      * - `to` cannot be the zero address.
778      * - `tokenId` token must be owned by `from`.
779      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
780      *
781      * Emits a {Transfer} event.
782      */
783     function transferFrom(
784         address from,
785         address to,
786         uint256 tokenId
787     ) external;
788 
789     /**
790      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
791      * The approval is cleared when the token is transferred.
792      *
793      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
794      *
795      * Requirements:
796      *
797      * - The caller must own the token or be an approved operator.
798      * - `tokenId` must exist.
799      *
800      * Emits an {Approval} event.
801      */
802     function approve(address to, uint256 tokenId) external;
803 
804     /**
805      * @dev Returns the account approved for `tokenId` token.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function getApproved(uint256 tokenId) external view returns (address operator);
812 
813     /**
814      * @dev Approve or remove `operator` as an operator for the caller.
815      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
816      *
817      * Requirements:
818      *
819      * - The `operator` cannot be the caller.
820      *
821      * Emits an {ApprovalForAll} event.
822      */
823     function setApprovalForAll(address operator, bool _approved) external;
824 
825     /**
826      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
827      *
828      * See {setApprovalForAll}
829      */
830     function isApprovedForAll(address owner, address operator) external view returns (bool);
831 
832     /**
833      * @dev Safely transfers `tokenId` token from `from` to `to`.
834      *
835      * Requirements:
836      *
837      * - `from` cannot be the zero address.
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must exist and be owned by `from`.
840      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
842      *
843      * Emits a {Transfer} event.
844      */
845     function safeTransferFrom(
846         address from,
847         address to,
848         uint256 tokenId,
849         bytes calldata data
850     ) external;
851 }
852 // File: contracts/IERC721Enumerable.sol
853 
854 
855 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
856 
857 pragma solidity ^0.8.0;
858 
859 
860 /**
861  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
862  * @dev See https://eips.ethereum.org/EIPS/eip-721
863  */
864 interface IERC721Enumerable is IERC721 {
865     /**
866      * @dev Returns the total amount of tokens stored by the contract.
867      */
868     function totalSupply() external view returns (uint256);
869 
870     /**
871      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
872      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
873      */
874     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
875 
876     /**
877      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
878      * Use along with {totalSupply} to enumerate all tokens.
879      */
880     function tokenByIndex(uint256 index) external view returns (uint256);
881 }
882 // File: contracts/IERC721Metadata.sol
883 
884 
885 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 
890 /**
891  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
892  * @dev See https://eips.ethereum.org/EIPS/eip-721
893  */
894 interface IERC721Metadata is IERC721 {
895     /**
896      * @dev Returns the token collection name.
897      */
898     function name() external view returns (string memory);
899 
900     /**
901      * @dev Returns the token collection symbol.
902      */
903     function symbol() external view returns (string memory);
904 
905     /**
906      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
907      */
908     function tokenURI(uint256 tokenId) external view returns (string memory);
909 }
910 // File: contracts/ERC721.sol
911 
912 
913 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
914 
915 pragma solidity ^0.8.0;
916 
917 
918 
919 
920 
921 
922 
923 
924 /**
925  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
926  * the Metadata extension, but not including the Enumerable extension, which is available separately as
927  * {ERC721Enumerable}.
928  */
929 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
930     using Address for address;
931     using Strings for uint256;
932 
933     // Token name
934     string private _name;
935 
936     // Token symbol
937     string private _symbol;
938 
939     // Mapping from token ID to owner address
940     mapping(uint256 => address) private _owners;
941 
942     // Mapping owner address to token count
943     mapping(address => uint256) private _balances;
944 
945     // Mapping from token ID to approved address
946     mapping(uint256 => address) private _tokenApprovals;
947 
948     // Mapping from owner to operator approvals
949     mapping(address => mapping(address => bool)) private _operatorApprovals;
950 
951     /**
952      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
953      */
954     constructor(string memory name_, string memory symbol_) {
955         _name = name_;
956         _symbol = symbol_;
957     }
958 
959     /**
960      * @dev See {IERC165-supportsInterface}.
961      */
962     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
963         return
964             interfaceId == type(IERC721).interfaceId ||
965             interfaceId == type(IERC721Metadata).interfaceId ||
966             super.supportsInterface(interfaceId);
967     }
968 
969     /**
970      * @dev See {IERC721-balanceOf}.
971      */
972     function balanceOf(address owner) public view virtual override returns (uint256) {
973         require(owner != address(0), "ERC721: balance query for the zero address");
974         return _balances[owner];
975     }
976 
977     /**
978      * @dev See {IERC721-ownerOf}.
979      */
980     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
981         address owner = _owners[tokenId];
982         require(owner != address(0), "ERC721: owner query for nonexistent token");
983         return owner;
984     }
985 
986     /**
987      * @dev See {IERC721Metadata-name}.
988      */
989     function name() public view virtual override returns (string memory) {
990         return _name;
991     }
992 
993     /**
994      * @dev See {IERC721Metadata-symbol}.
995      */
996     function symbol() public view virtual override returns (string memory) {
997         return _symbol;
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-tokenURI}.
1002      */
1003     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1004         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1005 
1006         string memory baseURI = _baseURI();
1007         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1008     }
1009 
1010     /**
1011      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1012      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1013      * by default, can be overriden in child contracts.
1014      */
1015     function _baseURI() internal view virtual returns (string memory) {
1016         return "";
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-approve}.
1021      */
1022     function approve(address to, uint256 tokenId) public virtual override {
1023         address owner = ERC721.ownerOf(tokenId);
1024         require(to != owner, "ERC721: approval to current owner");
1025 
1026         require(
1027             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1028             "ERC721: approve caller is not owner nor approved for all"
1029         );
1030 
1031         _approve(to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-getApproved}.
1036      */
1037     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1038         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1039 
1040         return _tokenApprovals[tokenId];
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-setApprovalForAll}.
1045      */
1046     function setApprovalForAll(address operator, bool approved) public virtual override {
1047         _setApprovalForAll(_msgSender(), operator, approved);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-isApprovedForAll}.
1052      */
1053     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1054         return _operatorApprovals[owner][operator];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-transferFrom}.
1059      */
1060     function transferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) public virtual override {
1065         //solhint-disable-next-line max-line-length
1066         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1067 
1068         _transfer(from, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-safeTransferFrom}.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) public virtual override {
1079         safeTransferFrom(from, to, tokenId, "");
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-safeTransferFrom}.
1084      */
1085     function safeTransferFrom(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) public virtual override {
1091         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1092         _safeTransfer(from, to, tokenId, _data);
1093     }
1094 
1095     /**
1096      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1097      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1098      *
1099      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1100      *
1101      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1102      * implement alternative mechanisms to perform token transfer, such as signature-based.
1103      *
1104      * Requirements:
1105      *
1106      * - `from` cannot be the zero address.
1107      * - `to` cannot be the zero address.
1108      * - `tokenId` token must exist and be owned by `from`.
1109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1110      *
1111      * Emits a {Transfer} event.
1112      */
1113     function _safeTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory _data
1118     ) internal virtual {
1119         _transfer(from, to, tokenId);
1120         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1121     }
1122 
1123     /**
1124      * @dev Returns whether `tokenId` exists.
1125      *
1126      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1127      *
1128      * Tokens start existing when they are minted (`_mint`),
1129      * and stop existing when they are burned (`_burn`).
1130      */
1131     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1132         return _owners[tokenId] != address(0);
1133     }
1134 
1135     /**
1136      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1137      *
1138      * Requirements:
1139      *
1140      * - `tokenId` must exist.
1141      */
1142     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1143         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1144         address owner = ERC721.ownerOf(tokenId);
1145         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1146     }
1147 
1148     /**
1149      * @dev Safely mints `tokenId` and transfers it to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `tokenId` must not exist.
1154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _safeMint(address to, uint256 tokenId) internal virtual {
1159         _safeMint(to, tokenId, "");
1160     }
1161 
1162     /**
1163      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1164      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1165      */
1166     function _safeMint(
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) internal virtual {
1171         _mint(to, tokenId);
1172         require(
1173             _checkOnERC721Received(address(0), to, tokenId, _data),
1174             "ERC721: transfer to non ERC721Receiver implementer"
1175         );
1176     }
1177 
1178     /**
1179      * @dev Mints `tokenId` and transfers it to `to`.
1180      *
1181      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must not exist.
1186      * - `to` cannot be the zero address.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _mint(address to, uint256 tokenId) internal virtual {
1191         require(to != address(0), "ERC721: mint to the zero address");
1192         require(!_exists(tokenId), "ERC721: token already minted");
1193 
1194         _beforeTokenTransfer(address(0), to, tokenId);
1195 
1196         _balances[to] += 1;
1197         _owners[tokenId] = to;
1198 
1199         emit Transfer(address(0), to, tokenId);
1200     }
1201 
1202     /**
1203      * @dev Destroys `tokenId`.
1204      * The approval is cleared when the token is burned.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function _burn(uint256 tokenId) internal virtual {
1213         address owner = ERC721.ownerOf(tokenId);
1214 
1215         _beforeTokenTransfer(owner, address(0), tokenId);
1216 
1217         // Clear approvals
1218         _approve(address(0), tokenId);
1219 
1220         _balances[owner] -= 1;
1221         delete _owners[tokenId];
1222 
1223         emit Transfer(owner, address(0), tokenId);
1224     }
1225 
1226     /**
1227      * @dev Transfers `tokenId` from `from` to `to`.
1228      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1229      *
1230      * Requirements:
1231      *
1232      * - `to` cannot be the zero address.
1233      * - `tokenId` token must be owned by `from`.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _transfer(
1238         address from,
1239         address to,
1240         uint256 tokenId
1241     ) internal virtual {
1242         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1243         require(to != address(0), "ERC721: transfer to the zero address");
1244 
1245         _beforeTokenTransfer(from, to, tokenId);
1246 
1247         // Clear approvals from the previous owner
1248         _approve(address(0), tokenId);
1249 
1250         _balances[from] -= 1;
1251         _balances[to] += 1;
1252         _owners[tokenId] = to;
1253 
1254         emit Transfer(from, to, tokenId);
1255     }
1256 
1257     /**
1258      * @dev Approve `to` to operate on `tokenId`
1259      *
1260      * Emits a {Approval} event.
1261      */
1262     function _approve(address to, uint256 tokenId) internal virtual {
1263         _tokenApprovals[tokenId] = to;
1264         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1265     }
1266 
1267     /**
1268      * @dev Approve `operator` to operate on all of `owner` tokens
1269      *
1270      * Emits a {ApprovalForAll} event.
1271      */
1272     function _setApprovalForAll(
1273         address owner,
1274         address operator,
1275         bool approved
1276     ) internal virtual {
1277         require(owner != operator, "ERC721: approve to caller");
1278         _operatorApprovals[owner][operator] = approved;
1279         emit ApprovalForAll(owner, operator, approved);
1280     }
1281 
1282     /**
1283      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1284      * The call is not executed if the target address is not a contract.
1285      *
1286      * @param from address representing the previous owner of the given token ID
1287      * @param to target address that will receive the tokens
1288      * @param tokenId uint256 ID of the token to be transferred
1289      * @param _data bytes optional data to send along with the call
1290      * @return bool whether the call correctly returned the expected magic value
1291      */
1292     function _checkOnERC721Received(
1293         address from,
1294         address to,
1295         uint256 tokenId,
1296         bytes memory _data
1297     ) private returns (bool) {
1298         if (to.isContract()) {
1299             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1300                 return retval == IERC721Receiver.onERC721Received.selector;
1301             } catch (bytes memory reason) {
1302                 if (reason.length == 0) {
1303                     revert("ERC721: transfer to non ERC721Receiver implementer");
1304                 } else {
1305                     assembly {
1306                         revert(add(32, reason), mload(reason))
1307                     }
1308                 }
1309             }
1310         } else {
1311             return true;
1312         }
1313     }
1314 
1315     /**
1316      * @dev Hook that is called before any token transfer. This includes minting
1317      * and burning.
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1325      * - `from` and `to` are never both zero.
1326      *
1327      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1328      */
1329     function _beforeTokenTransfer(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) internal virtual {}
1334 }
1335 // File: contracts/ERC721URIStorage.sol
1336 
1337 
1338 
1339 pragma solidity ^0.8.0;
1340 
1341 
1342 /**
1343  * @dev ERC721 token with storage based token URI management.
1344  */
1345 abstract contract ERC721URIStorage is ERC721 {
1346     using Strings for uint256;
1347 
1348     // Optional mapping for token URIs
1349     mapping(uint256 => string) private _tokenURIs;
1350 
1351     /**
1352      * @dev See {IERC721Metadata-tokenURI}.
1353      */
1354     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1355         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1356 
1357         string memory _tokenURI = _tokenURIs[tokenId];
1358         string memory base = _baseURI();
1359 
1360         // If there is no base URI, return the token URI.
1361         if (bytes(base).length == 0) {
1362             return _tokenURI;
1363         }
1364         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1365         if (bytes(_tokenURI).length > 0) {
1366             return string(abi.encodePacked(base, _tokenURI));
1367         }
1368 
1369         return super.tokenURI(tokenId);
1370     }
1371 
1372     /**
1373      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1374      *
1375      * Requirements:
1376      *
1377      * - `tokenId` must exist.
1378      */
1379     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1380         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1381         _tokenURIs[tokenId] = _tokenURI;
1382     }
1383 
1384     /**
1385      * @dev Destroys `tokenId`.
1386      * The approval is cleared when the token is burned.
1387      *
1388      * Requirements:
1389      *
1390      * - `tokenId` must exist.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function _burn(uint256 tokenId) internal virtual override {
1395         super._burn(tokenId);
1396 
1397         if (bytes(_tokenURIs[tokenId]).length != 0) {
1398             delete _tokenURIs[tokenId];
1399         }
1400     }
1401 }
1402 // File: contracts/ERC721Enumerable.sol
1403 
1404 
1405 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1406 
1407 pragma solidity ^0.8.0;
1408 
1409 
1410 
1411 /**
1412  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1413  * enumerability of all the token ids in the contract as well as all token ids owned by each
1414  * account.
1415  */
1416 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1417     // Mapping from owner to list of owned token IDs
1418     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1419 
1420     // Mapping from token ID to index of the owner tokens list
1421     mapping(uint256 => uint256) private _ownedTokensIndex;
1422 
1423     // Array with all token ids, used for enumeration
1424     uint256[] private _allTokens;
1425 
1426     // Mapping from token id to position in the allTokens array
1427     mapping(uint256 => uint256) private _allTokensIndex;
1428 
1429     /**
1430      * @dev See {IERC165-supportsInterface}.
1431      */
1432     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1433         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1434     }
1435 
1436     /**
1437      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1438      */
1439     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1440         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1441         return _ownedTokens[owner][index];
1442     }
1443 
1444     /**
1445      * @dev See {IERC721Enumerable-totalSupply}.
1446      */
1447     function totalSupply() public view virtual override returns (uint256) {
1448         return _allTokens.length;
1449     }
1450 
1451     /**
1452      * @dev See {IERC721Enumerable-tokenByIndex}.
1453      */
1454     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1455         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1456         return _allTokens[index];
1457     }
1458 
1459     /**
1460      * @dev Hook that is called before any token transfer. This includes minting
1461      * and burning.
1462      *
1463      * Calling conditions:
1464      *
1465      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1466      * transferred to `to`.
1467      * - When `from` is zero, `tokenId` will be minted for `to`.
1468      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1469      * - `from` cannot be the zero address.
1470      * - `to` cannot be the zero address.
1471      *
1472      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1473      */
1474     function _beforeTokenTransfer(
1475         address from,
1476         address to,
1477         uint256 tokenId
1478     ) internal virtual override {
1479         super._beforeTokenTransfer(from, to, tokenId);
1480 
1481         if (from == address(0)) {
1482             _addTokenToAllTokensEnumeration(tokenId);
1483         } else if (from != to) {
1484             _removeTokenFromOwnerEnumeration(from, tokenId);
1485         }
1486         if (to == address(0)) {
1487             _removeTokenFromAllTokensEnumeration(tokenId);
1488         } else if (to != from) {
1489             _addTokenToOwnerEnumeration(to, tokenId);
1490         }
1491     }
1492 
1493     /**
1494      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1495      * @param to address representing the new owner of the given token ID
1496      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1497      */
1498     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1499         uint256 length = ERC721.balanceOf(to);
1500         _ownedTokens[to][length] = tokenId;
1501         _ownedTokensIndex[tokenId] = length;
1502     }
1503 
1504     /**
1505      * @dev Private function to add a token to this extension's token tracking data structures.
1506      * @param tokenId uint256 ID of the token to be added to the tokens list
1507      */
1508     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1509         _allTokensIndex[tokenId] = _allTokens.length;
1510         _allTokens.push(tokenId);
1511     }
1512 
1513     /**
1514      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1515      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1516      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1517      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1518      * @param from address representing the previous owner of the given token ID
1519      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1520      */
1521     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1522         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1523         // then delete the last slot (swap and pop).
1524 
1525         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1526         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1527 
1528         // When the token to delete is the last token, the swap operation is unnecessary
1529         if (tokenIndex != lastTokenIndex) {
1530             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1531 
1532             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1533             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1534         }
1535 
1536         // This also deletes the contents at the last position of the array
1537         delete _ownedTokensIndex[tokenId];
1538         delete _ownedTokens[from][lastTokenIndex];
1539     }
1540 
1541     /**
1542      * @dev Private function to remove a token from this extension's token tracking data structures.
1543      * This has O(1) time complexity, but alters the order of the _allTokens array.
1544      * @param tokenId uint256 ID of the token to be removed from the tokens list
1545      */
1546     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1547         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1548         // then delete the last slot (swap and pop).
1549 
1550         uint256 lastTokenIndex = _allTokens.length - 1;
1551         uint256 tokenIndex = _allTokensIndex[tokenId];
1552 
1553         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1554         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1555         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1556         uint256 lastTokenId = _allTokens[lastTokenIndex];
1557 
1558         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1559         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1560 
1561         // This also deletes the contents at the last position of the array
1562         delete _allTokensIndex[tokenId];
1563         _allTokens.pop();
1564     }
1565 }
1566 // File: contracts/MadGoblins.sol
1567 
1568 
1569 // NFT Collection: Mad Goblins (MADG)
1570 
1571 pragma solidity ^0.8.0;
1572 
1573 
1574 
1575 
1576 
1577 
1578 
1579 contract MadGoblins is ERC721, ERC721Enumerable, Ownable {
1580     using SafeMath for uint256;
1581 
1582     uint256 public startingIndexBlock;
1583     uint256 public startingIndex;
1584     uint256 public MAX_GOBLINS;
1585     uint256 public REVEAL_TIMESTAMP;
1586     uint public constant maxPurchase = 10;
1587     bool public saleIsActive = false;
1588     uint256 private _reserved = 300;
1589     uint256 private _goblinPrice = 20000000000000000; //0.02 ETH
1590     string private baseURI;
1591 	string public MADG_PROVENANCE = "";
1592 
1593     constructor(uint256 maxNftSupply) ERC721("Mad Goblins", "MADG") {
1594         MAX_GOBLINS = maxNftSupply;     
1595         REVEAL_TIMESTAMP = 864000; //10 days
1596     }
1597     
1598     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1599         internal
1600         override(ERC721, ERC721Enumerable)
1601     {
1602         super._beforeTokenTransfer(from, to, tokenId);
1603     }
1604     
1605     function supportsInterface(bytes4 interfaceId)
1606         public
1607         view
1608         override(ERC721, ERC721Enumerable)
1609         returns (bool)
1610     {
1611         return super.supportsInterface(interfaceId);
1612     }
1613 
1614 	function withdraw() public onlyOwner {
1615 		uint256 balance = address(this).balance;
1616 		payable(msg.sender).transfer(balance);
1617 	}    
1618 
1619     function reserveTokens(uint256 amount) public onlyOwner {    
1620         require( amount <= _reserved, "Reserve limit reached" );
1621 
1622         uint supply = totalSupply();
1623         for (uint i; i < amount; i++) {
1624             _safeMint(msg.sender, supply + i);
1625         }
1626 
1627         _reserved -= amount;
1628     }
1629 
1630     function setPrice(uint256 _newPrice) public onlyOwner() {
1631         _goblinPrice = _newPrice;
1632     }
1633 
1634     function getPrice() public view returns (uint256){
1635         return _goblinPrice;
1636     }
1637 
1638     function mintMadGoblin(uint numberOfTokens) public payable {
1639         require(saleIsActive, "Sale must be active to mint a Mad Goblin");
1640         require(numberOfTokens <= maxPurchase, "Can only mint 10 tokens at a time");
1641         require(totalSupply().add(numberOfTokens) <= MAX_GOBLINS, "Purchase would exceed max supply of Mad Goblins");
1642         require(_goblinPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1643         
1644         for(uint i = 0; i < numberOfTokens; i++) {
1645             uint mintIndex = totalSupply();
1646             if (totalSupply() < MAX_GOBLINS) {
1647                 _safeMint(msg.sender, mintIndex);
1648             }
1649         }
1650 
1651         //We set the starting index only once all the presale time has elapsed or when the last token has sold
1652         if (startingIndexBlock == 0 && (totalSupply() == MAX_GOBLINS || block.timestamp >= REVEAL_TIMESTAMP)) {
1653             startingIndexBlock = block.number;
1654         } 
1655     }
1656 
1657     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
1658         REVEAL_TIMESTAMP = revealTimeStamp;
1659     }     
1660 
1661     function flipSaleState() public onlyOwner {
1662         saleIsActive = !saleIsActive;
1663     }    
1664 
1665     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1666         MADG_PROVENANCE = provenanceHash;
1667     }
1668 
1669     function _baseURI() internal view override returns (string memory) {
1670         return baseURI;
1671     }
1672     
1673     function setBaseURI(string memory newBaseURI) public onlyOwner {
1674         baseURI = newBaseURI;
1675     }
1676 
1677     function setStartingIndex() public {
1678         require(startingIndex == 0, "Starting index is already set");
1679         require(startingIndexBlock != 0, "Starting index block must be set");
1680         
1681         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_GOBLINS;
1682         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1683         if (block.number.sub(startingIndexBlock) > 255) {
1684             startingIndex = uint(blockhash(block.number - 1)) % MAX_GOBLINS;
1685         }
1686         // Prevent default sequence
1687         if (startingIndex == 0) {
1688             startingIndex = startingIndex.add(1);
1689         }
1690     }
1691 
1692     function emergencySetStartingIndexBlock() public onlyOwner {
1693         require(startingIndex == 0, "Starting index is already set");      
1694         startingIndexBlock = block.number;
1695     }    
1696 
1697 }