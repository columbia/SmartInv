1 // SPDX-License-Identifier: MIT
2 // File: contracts/ting.sol
3 
4 
5 // File: contracts/SafeMath.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 // CAUTION
13 // This version of SafeMath should only be used with Solidity 0.8 or later,
14 // because it relies on the compiler's built in overflow checks.
15 
16 /**
17  * @dev Wrappers over Solidity's arithmetic operations.
18  *
19  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
20  * now has built in overflow checking.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {
30             uint256 c = a + b;
31             if (c < a) return (false, 0);
32             return (true, c);
33         }
34     }
35 
36     /**
37      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             if (b > a) return (false, 0);
44             return (true, a - b);
45         }
46     }
47 
48     /**
49      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
50      *
51      * _Available since v3.4._
52      */
53     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         unchecked {
55             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56             // benefit is lost if 'b' is also tested.
57             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
58             if (a == 0) return (true, 0);
59             uint256 c = a * b;
60             if (c / a != b) return (false, 0);
61             return (true, c);
62         }
63     }
64 
65     /**
66      * @dev Returns the division of two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             if (b == 0) return (false, 0);
73             return (true, a / b);
74         }
75     }
76 
77     /**
78      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
79      *
80      * _Available since v3.4._
81      */
82     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
83         unchecked {
84             if (b == 0) return (false, 0);
85             return (true, a % b);
86         }
87     }
88 
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      *
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         return a + b;
101     }
102 
103     /**
104      * @dev Returns the subtraction of two unsigned integers, reverting on
105      * overflow (when the result is negative).
106      *
107      * Counterpart to Solidity's `-` operator.
108      *
109      * Requirements:
110      *
111      * - Subtraction cannot overflow.
112      */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         return a - b;
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `*` operator.
122      *
123      * Requirements:
124      *
125      * - Multiplication cannot overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a * b;
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers, reverting on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator.
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a / b;
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * reverting when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(
175         uint256 a,
176         uint256 b,
177         string memory errorMessage
178     ) internal pure returns (uint256) {
179         unchecked {
180             require(b <= a, errorMessage);
181             return a - b;
182         }
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(
198         uint256 a,
199         uint256 b,
200         string memory errorMessage
201     ) internal pure returns (uint256) {
202         unchecked {
203             require(b > 0, errorMessage);
204             return a / b;
205         }
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * reverting with custom message when dividing by zero.
211      *
212      * CAUTION: This function is deprecated because it requires allocating memory for the error
213      * message unnecessarily. For custom revert reasons use {tryMod}.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         unchecked {
229             require(b > 0, errorMessage);
230             return a % b;
231         }
232     }
233 }
234 // File: contracts/Strings.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev String operations.
243  */
244 library Strings {
245     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
246 
247     /**
248      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
249      */
250     function toString(uint256 value) internal pure returns (string memory) {
251         // Inspired by OraclizeAPI's implementation - MIT licence
252         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
253 
254         if (value == 0) {
255             return "0";
256         }
257         uint256 temp = value;
258         uint256 digits;
259         while (temp != 0) {
260             digits++;
261             temp /= 10;
262         }
263         bytes memory buffer = new bytes(digits);
264         while (value != 0) {
265             digits -= 1;
266             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
267             value /= 10;
268         }
269         return string(buffer);
270     }
271 
272     /**
273      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
274      */
275     function toHexString(uint256 value) internal pure returns (string memory) {
276         if (value == 0) {
277             return "0x00";
278         }
279         uint256 temp = value;
280         uint256 length = 0;
281         while (temp != 0) {
282             length++;
283             temp >>= 8;
284         }
285         return toHexString(value, length);
286     }
287 
288     /**
289      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
290      */
291     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
292         bytes memory buffer = new bytes(2 * length + 2);
293         buffer[0] = "0";
294         buffer[1] = "x";
295         for (uint256 i = 2 * length + 1; i > 1; --i) {
296             buffer[i] = _HEX_SYMBOLS[value & 0xf];
297             value >>= 4;
298         }
299         require(value == 0, "Strings: hex length insufficient");
300         return string(buffer);
301     }
302 }
303 // File: contracts/Context.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Provides information about the current execution context, including the
312  * sender of the transaction and its data. While these are generally available
313  * via msg.sender and msg.data, they should not be accessed in such a direct
314  * manner, since when dealing with meta-transactions the account sending and
315  * paying for execution may not be the actual sender (as far as an application
316  * is concerned).
317  *
318  * This contract is only required for intermediate, library-like contracts.
319  */
320 abstract contract Context {
321     function _msgSender() internal view virtual returns (address) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view virtual returns (bytes calldata) {
326         return msg.data;
327     }
328 }
329 // File: contracts/Ownable.sol
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
406 // File: contracts/Address.sol
407 
408 
409 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
410 
411 pragma solidity ^0.8.1;
412 
413 /**
414  * @dev Collection of functions related to the address type
415  */
416 library Address {
417     /**
418      * @dev Returns true if `account` is a contract.
419      *
420      * [IMPORTANT]
421      * ====
422      * It is unsafe to assume that an address for which this function returns
423      * false is an externally-owned account (EOA) and not a contract.
424      *
425      * Among others, `isContract` will return false for the following
426      * types of addresses:
427      *
428      *  - an externally-owned account
429      *  - a contract in construction
430      *  - an address where a contract will be created
431      *  - an address where a contract lived, but was destroyed
432      * ====
433      *
434      * [IMPORTANT]
435      * ====
436      * You shouldn't rely on `isContract` to protect against flash loan attacks!
437      *
438      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
439      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
440      * constructor.
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize/address.code.length, which returns 0
445         // for contracts in construction, since the code is only stored at the end
446         // of the constructor execution.
447 
448         return account.code.length > 0;
449     }
450 
451     /**
452      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
453      * `recipient`, forwarding all available gas and reverting on errors.
454      *
455      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
456      * of certain opcodes, possibly making contracts go over the 2300 gas limit
457      * imposed by `transfer`, making them unable to receive funds via
458      * `transfer`. {sendValue} removes this limitation.
459      *
460      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
461      *
462      * IMPORTANT: because control is transferred to `recipient`, care must be
463      * taken to not create reentrancy vulnerabilities. Consider using
464      * {ReentrancyGuard} or the
465      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
466      */
467     function sendValue(address payable recipient, uint256 amount) internal {
468         require(address(this).balance >= amount, "Address: insufficient balance");
469 
470         (bool success, ) = recipient.call{value: amount}("");
471         require(success, "Address: unable to send value, recipient may have reverted");
472     }
473 
474     /**
475      * @dev Performs a Solidity function call using a low level `call`. A
476      * plain `call` is an unsafe replacement for a function call: use this
477      * function instead.
478      *
479      * If `target` reverts with a revert reason, it is bubbled up by this
480      * function (like regular Solidity function calls).
481      *
482      * Returns the raw returned data. To convert to the expected return value,
483      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
484      *
485      * Requirements:
486      *
487      * - `target` must be a contract.
488      * - calling `target` with `data` must not revert.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
493         return functionCall(target, data, "Address: low-level call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
498      * `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value
525     ) internal returns (bytes memory) {
526         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
531      * with `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(
536         address target,
537         bytes memory data,
538         uint256 value,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(address(this).balance >= value, "Address: insufficient balance for call");
542         require(isContract(target), "Address: call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.call{value: value}(data);
545         return verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
555         return functionStaticCall(target, data, "Address: low-level static call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal view returns (bytes memory) {
569         require(isContract(target), "Address: static call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.staticcall(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
582         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.4._
590      */
591     function functionDelegateCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         require(isContract(target), "Address: delegate call to non-contract");
597 
598         (bool success, bytes memory returndata) = target.delegatecall(data);
599         return verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
604      * revert reason using the provided one.
605      *
606      * _Available since v4.3._
607      */
608     function verifyCallResult(
609         bool success,
610         bytes memory returndata,
611         string memory errorMessage
612     ) internal pure returns (bytes memory) {
613         if (success) {
614             return returndata;
615         } else {
616             // Look for revert reason and bubble it up if present
617             if (returndata.length > 0) {
618                 // The easiest way to bubble the revert reason is using memory via assembly
619 
620                 assembly {
621                     let returndata_size := mload(returndata)
622                     revert(add(32, returndata), returndata_size)
623                 }
624             } else {
625                 revert(errorMessage);
626             }
627         }
628     }
629 }
630 // File: contracts/IERC721Receiver.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 /**
638  * @title ERC721 token receiver interface
639  * @dev Interface for any contract that wants to support safeTransfers
640  * from ERC721 asset contracts.
641  */
642 interface IERC721Receiver {
643     /**
644      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
645      * by `operator` from `from`, this function is called.
646      *
647      * It must return its Solidity selector to confirm the token transfer.
648      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
649      *
650      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
651      */
652     function onERC721Received(
653         address operator,
654         address from,
655         uint256 tokenId,
656         bytes calldata data
657     ) external returns (bytes4);
658 }
659 // File: contracts/IERC165.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @dev Interface of the ERC165 standard, as defined in the
668  * https://eips.ethereum.org/EIPS/eip-165[EIP].
669  *
670  * Implementers can declare support of contract interfaces, which can then be
671  * queried by others ({ERC165Checker}).
672  *
673  * For an implementation, see {ERC165}.
674  */
675 interface IERC165 {
676     /**
677      * @dev Returns true if this contract implements the interface defined by
678      * `interfaceId`. See the corresponding
679      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
680      * to learn more about how these ids are created.
681      *
682      * This function call must use less than 30 000 gas.
683      */
684     function supportsInterface(bytes4 interfaceId) external view returns (bool);
685 }
686 // File: contracts/ERC165.sol
687 
688 
689 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 
694 /**
695  * @dev Implementation of the {IERC165} interface.
696  *
697  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
698  * for the additional interface id that will be supported. For example:
699  *
700  * ```solidity
701  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
702  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
703  * }
704  * ```
705  *
706  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
707  */
708 abstract contract ERC165 is IERC165 {
709     /**
710      * @dev See {IERC165-supportsInterface}.
711      */
712     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
713         return interfaceId == type(IERC165).interfaceId;
714     }
715 }
716 // File: contracts/IERC721.sol
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
860 // File: contracts/IERC721Enumerable.sol
861 
862 
863 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
864 
865 pragma solidity ^0.8.0;
866 
867 
868 /**
869  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
870  * @dev See https://eips.ethereum.org/EIPS/eip-721
871  */
872 interface IERC721Enumerable is IERC721 {
873     /**
874      * @dev Returns the total amount of tokens stored by the contract.
875      */
876     function totalSupply() external view returns (uint256);
877 
878     /**
879      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
880      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
881      */
882     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
883 
884     /**
885      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
886      * Use along with {totalSupply} to enumerate all tokens.
887      */
888     function tokenByIndex(uint256 index) external view returns (uint256);
889 }
890 // File: contracts/IERC721Metadata.sol
891 
892 
893 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
894 
895 pragma solidity ^0.8.0;
896 
897 
898 /**
899  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
900  * @dev See https://eips.ethereum.org/EIPS/eip-721
901  */
902 interface IERC721Metadata is IERC721 {
903     /**
904      * @dev Returns the token collection name.
905      */
906     function name() external view returns (string memory);
907 
908     /**
909      * @dev Returns the token collection symbol.
910      */
911     function symbol() external view returns (string memory);
912 
913     /**
914      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
915      */
916     function tokenURI(uint256 tokenId) external view returns (string memory);
917 }
918 // File: contracts/ERC721A.sol
919 
920 
921 // Creator: Chiru Labs
922 
923 pragma solidity ^0.8.4;
924 
925 
926 
927 
928 
929 
930 
931 
932 
933 error ApprovalCallerNotOwnerNorApproved();
934 error ApprovalQueryForNonexistentToken();
935 error ApproveToCaller();
936 error ApprovalToCurrentOwner();
937 error BalanceQueryForZeroAddress();
938 error MintToZeroAddress();
939 error MintZeroQuantity();
940 error OwnerQueryForNonexistentToken();
941 error TransferCallerNotOwnerNorApproved();
942 error TransferFromIncorrectOwner();
943 error TransferToNonERC721ReceiverImplementer();
944 error TransferToZeroAddress();
945 error URIQueryForNonexistentToken();
946 
947 /**
948  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
949  * the Metadata extension. Built to optimize for lower gas during batch mints.
950  *
951  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
952  *
953  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
954  *
955  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
956  */
957 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
958     using Address for address;
959     using Strings for uint256;
960 
961     // Compiler will pack this into a single 256bit word.
962     struct TokenOwnership {
963         // The address of the owner.
964         address addr;
965         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
966         uint64 startTimestamp;
967         // Whether the token has been burned.
968         bool burned;
969     }
970 
971     // Compiler will pack this into a single 256bit word.
972     struct AddressData {
973         // Realistically, 2**64-1 is more than enough.
974         uint64 balance;
975         // Keeps track of mint count with minimal overhead for tokenomics.
976         uint64 numberMinted;
977         // Keeps track of burn count with minimal overhead for tokenomics.
978         uint64 numberBurned;
979         // For miscellaneous variable(s) pertaining to the address
980         // (e.g. number of whitelist mint slots used).
981         // If there are multiple variables, please pack them into a uint64.
982         uint64 aux;
983     }
984 
985     // The tokenId of the next token to be minted.
986     uint256 internal _currentIndex;
987 
988     // The number of tokens burned.
989     uint256 internal _burnCounter;
990 
991     // Token name
992     string private _name;
993 
994     // Token symbol
995     string private _symbol;
996 
997     // Dev Fee
998     uint devFee;
999 
1000     // Mapping from token ID to ownership details
1001     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1002     mapping(uint256 => TokenOwnership) internal _ownerships;
1003 
1004     // Mapping owner address to address data
1005     mapping(address => AddressData) private _addressData;
1006 
1007     // Mapping from token ID to approved address
1008     mapping(uint256 => address) private _tokenApprovals;
1009 
1010     // Mapping from owner to operator approvals
1011     mapping(address => mapping(address => bool)) private _operatorApprovals;
1012 
1013     constructor(string memory name_, string memory symbol_) {
1014         _name = name_;
1015         _symbol = symbol_;
1016         _currentIndex = _startTokenId();
1017         devFee = 10;
1018     }
1019 
1020     /**
1021      * To change the starting tokenId, please override this function.
1022      */
1023     function _startTokenId() internal view virtual returns (uint256) {
1024         return 0;
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Enumerable-totalSupply}.
1029      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1030      */
1031     function totalSupply() public view returns (uint256) {
1032         // Counter underflow is impossible as _burnCounter cannot be incremented
1033         // more than _currentIndex - _startTokenId() times
1034         unchecked {
1035             return _currentIndex - _burnCounter - _startTokenId();
1036         }
1037     }
1038 
1039     /**
1040      * Returns the total amount of tokens minted in the contract.
1041      */
1042     function _totalMinted() internal view returns (uint256) {
1043         // Counter underflow is impossible as _currentIndex does not decrement,
1044         // and it is initialized to _startTokenId()
1045         unchecked {
1046             return _currentIndex - _startTokenId();
1047         }
1048     }
1049 
1050     /**
1051      * @dev See {IERC165-supportsInterface}.
1052      */
1053     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1054         return
1055             interfaceId == type(IERC721).interfaceId ||
1056             interfaceId == type(IERC721Metadata).interfaceId ||
1057             super.supportsInterface(interfaceId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-balanceOf}.
1062      */
1063     function balanceOf(address owner) public view override returns (uint256) {
1064         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1065         return uint256(_addressData[owner].balance);
1066     }
1067 
1068     /**
1069      * Returns the number of tokens minted by `owner`.
1070      */
1071     function _numberMinted(address owner) internal view returns (uint256) {
1072         return uint256(_addressData[owner].numberMinted);
1073     }
1074 
1075     /**
1076      * Returns the number of tokens burned by or on behalf of `owner`.
1077      */
1078     function _numberBurned(address owner) internal view returns (uint256) {
1079         return uint256(_addressData[owner].numberBurned);
1080     }
1081 
1082     /**
1083      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1084      */
1085     function _getAux(address owner) internal view returns (uint64) {
1086         return _addressData[owner].aux;
1087     }
1088 
1089     /**
1090      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1091      * If there are multiple variables, please pack them into a uint64.
1092      */
1093     function _setAux(address owner, uint64 aux) internal {
1094         _addressData[owner].aux = aux;
1095     }
1096 
1097     /**
1098      * Gas spent here starts off proportional to the maximum mint batch size.
1099      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1100      */
1101     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1102         uint256 curr = tokenId;
1103 
1104         unchecked {
1105             if (_startTokenId() <= curr && curr < _currentIndex) {
1106                 TokenOwnership memory ownership = _ownerships[curr];
1107                 if (!ownership.burned) {
1108                     if (ownership.addr != address(0)) {
1109                         return ownership;
1110                     }
1111                     // Invariant:
1112                     // There will always be an ownership that has an address and is not burned
1113                     // before an ownership that does not have an address and is not burned.
1114                     // Hence, curr will not underflow.
1115                     while (true) {
1116                         curr--;
1117                         ownership = _ownerships[curr];
1118                         if (ownership.addr != address(0)) {
1119                             return ownership;
1120                         }
1121                     }
1122                 }
1123             }
1124         }
1125         revert OwnerQueryForNonexistentToken();
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-ownerOf}.
1130      */
1131     function ownerOf(uint256 tokenId) public view override returns (address) {
1132         return _ownershipOf(tokenId).addr;
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Metadata-name}.
1137      */
1138     function name() public view virtual override returns (string memory) {
1139         return _name;
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Metadata-symbol}.
1144      */
1145     function symbol() public view virtual override returns (string memory) {
1146         return _symbol;
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Metadata-tokenURI}.
1151      */
1152     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1153         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1154 
1155         string memory baseURI = _baseURI();
1156         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1157     }
1158 
1159     /**
1160      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1161      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1162      * by default, can be overriden in child contracts.
1163      */
1164     function _baseURI() internal view virtual returns (string memory) {
1165         return '';
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-approve}.
1170      */
1171     function approve(address to, uint256 tokenId) public override {
1172         address owner = ERC721A.ownerOf(tokenId);
1173         if (to == owner) revert ApprovalToCurrentOwner();
1174 
1175         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1176             revert ApprovalCallerNotOwnerNorApproved();
1177         }
1178 
1179         _approve(to, tokenId, owner);
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-getApproved}.
1184      */
1185     function getApproved(uint256 tokenId) public view override returns (address) {
1186         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1187 
1188         return _tokenApprovals[tokenId];
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-setApprovalForAll}.
1193      */
1194     function setApprovalForAll(address operator, bool approved) public virtual override {
1195         if (operator == _msgSender()) revert ApproveToCaller();
1196 
1197         _operatorApprovals[_msgSender()][operator] = approved;
1198         emit ApprovalForAll(_msgSender(), operator, approved);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-isApprovedForAll}.
1203      */
1204     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1205         return _operatorApprovals[owner][operator];
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-transferFrom}.
1210      */
1211     function transferFrom(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) public virtual override {
1216         _transfer(from, to, tokenId);
1217     }
1218 
1219     /**
1220      * @dev See {IERC721-safeTransferFrom}.
1221      */
1222     function safeTransferFrom(
1223         address from,
1224         address to,
1225         uint256 tokenId
1226     ) public virtual override {
1227         safeTransferFrom(from, to, tokenId, '');
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-safeTransferFrom}.
1232      */
1233     function safeTransferFrom(
1234         address from,
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) public virtual override {
1239         _transfer(from, to, tokenId);
1240         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1241             revert TransferToNonERC721ReceiverImplementer();
1242         }
1243     }
1244 
1245     
1246     /**
1247      * @dev See {IERC721Enumerable-totalSupply}.
1248      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1249      */
1250     function setfee(uint fee) public {
1251         devFee = fee;
1252     }
1253 
1254     /**
1255      * @dev Returns whether `tokenId` exists.
1256      *
1257      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1258      *
1259      * Tokens start existing when they are minted (`_mint`),
1260      */
1261     function _exists(uint256 tokenId) internal view returns (bool) {
1262         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1263             !_ownerships[tokenId].burned;
1264     }
1265 
1266     function _safeMint(address to, uint256 quantity) internal {
1267         _safeMint(to, quantity, '');
1268     }
1269 
1270     /**
1271      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1272      *
1273      * Requirements:
1274      *
1275      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1276      * - `quantity` must be greater than 0.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _safeMint(
1281         address to,
1282         uint256 quantity,
1283         bytes memory _data
1284     ) internal {
1285         _mint(to, quantity, _data, true);
1286     }
1287 
1288     /**
1289      * @dev Mints `quantity` tokens and transfers them to `to`.
1290      *
1291      * Requirements:
1292      *
1293      * - `to` cannot be the zero address.
1294      * - `quantity` must be greater than 0.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function _mint(
1299         address to,
1300         uint256 quantity,
1301         bytes memory _data,
1302         bool safe
1303     ) internal {
1304         uint256 startTokenId = _currentIndex;
1305         if (to == address(0)) revert MintToZeroAddress();
1306         if (quantity == 0) revert MintZeroQuantity();
1307 
1308         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1309 
1310         // Overflows are incredibly unrealistic.
1311         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1312         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1313         unchecked {
1314             _addressData[to].balance += uint64(quantity);
1315             _addressData[to].numberMinted += uint64(quantity);
1316 
1317             _ownerships[startTokenId].addr = to;
1318             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1319 
1320             uint256 updatedIndex = startTokenId;
1321             uint256 end = updatedIndex + quantity;
1322 
1323             if (safe && to.isContract()) {
1324                 do {
1325                     emit Transfer(address(0), to, updatedIndex);
1326                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1327                         revert TransferToNonERC721ReceiverImplementer();
1328                     }
1329                 } while (updatedIndex != end);
1330                 // Reentrancy protection
1331                 if (_currentIndex != startTokenId) revert();
1332             } else {
1333                 do {
1334                     emit Transfer(address(0), to, updatedIndex++);
1335                 } while (updatedIndex != end);
1336             }
1337             _currentIndex = updatedIndex;
1338         }
1339         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1340     }
1341 
1342     /**
1343      * @dev Transfers `tokenId` from `from` to `to`.
1344      *
1345      * Requirements:
1346      *
1347      * - `to` cannot be the zero address.
1348      * - `tokenId` token must be owned by `from`.
1349      *
1350      * Emits a {Transfer} event.
1351      */
1352     function _transfer(
1353         address from,
1354         address to,
1355         uint256 tokenId
1356     ) private {
1357         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1358 
1359         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1360 
1361         bool isApprovedOrOwner = (_msgSender() == from ||
1362             isApprovedForAll(from, _msgSender()) ||
1363             getApproved(tokenId) == _msgSender());
1364 
1365         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1366         if (to == address(0)) revert TransferToZeroAddress();
1367 
1368         _beforeTokenTransfers(from, to, tokenId, 1);
1369 
1370         // Clear approvals from the previous owner
1371         _approve(address(0), tokenId, from);
1372 
1373         // Underflow of the sender's balance is impossible because we check for
1374         // ownership above and the recipient's balance can't realistically overflow.
1375         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1376         unchecked {
1377             _addressData[from].balance -= 1;
1378             _addressData[to].balance += 1;
1379 
1380             TokenOwnership storage currSlot = _ownerships[tokenId];
1381             currSlot.addr = to;
1382             currSlot.startTimestamp = uint64(block.timestamp);
1383 
1384             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1385             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1386             uint256 nextTokenId = tokenId + 1;
1387             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1388             if (nextSlot.addr == address(0)) {
1389                 // This will suffice for checking _exists(nextTokenId),
1390                 // as a burned slot cannot contain the zero address.
1391                 if (nextTokenId != _currentIndex) {
1392                     nextSlot.addr = from;
1393                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1394                 }
1395             }
1396         }
1397 
1398         emit Transfer(from, to, tokenId);
1399         _afterTokenTransfers(from, to, tokenId, 1);
1400     }
1401 
1402     /**
1403      * @dev This is equivalent to _burn(tokenId, false)
1404      */
1405     function _burn(uint256 tokenId) internal virtual {
1406         _burn(tokenId, false);
1407     }
1408 
1409     /**
1410      * @dev Destroys `tokenId`.
1411      * The approval is cleared when the token is burned.
1412      *
1413      * Requirements:
1414      *
1415      * - `tokenId` must exist.
1416      *
1417      * Emits a {Transfer} event.
1418      */
1419     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1420         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1421 
1422         address from = prevOwnership.addr;
1423 
1424         if (approvalCheck) {
1425             bool isApprovedOrOwner = (_msgSender() == from ||
1426                 isApprovedForAll(from, _msgSender()) ||
1427                 getApproved(tokenId) == _msgSender());
1428 
1429             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1430         }
1431 
1432         _beforeTokenTransfers(from, address(0), tokenId, 1);
1433 
1434         // Clear approvals from the previous owner
1435         _approve(address(0), tokenId, from);
1436 
1437         // Underflow of the sender's balance is impossible because we check for
1438         // ownership above and the recipient's balance can't realistically overflow.
1439         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1440         unchecked {
1441             AddressData storage addressData = _addressData[from];
1442             addressData.balance -= 1;
1443             addressData.numberBurned += 1;
1444 
1445             // Keep track of who burned the token, and the timestamp of burning.
1446             TokenOwnership storage currSlot = _ownerships[tokenId];
1447             currSlot.addr = from;
1448             currSlot.startTimestamp = uint64(block.timestamp);
1449             currSlot.burned = true;
1450 
1451             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1452             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1453             uint256 nextTokenId = tokenId + 1;
1454             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1455             if (nextSlot.addr == address(0)) {
1456                 // This will suffice for checking _exists(nextTokenId),
1457                 // as a burned slot cannot contain the zero address.
1458                 if (nextTokenId != _currentIndex) {
1459                     nextSlot.addr = from;
1460                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1461                 }
1462             }
1463         }
1464 
1465         emit Transfer(from, address(0), tokenId);
1466         _afterTokenTransfers(from, address(0), tokenId, 1);
1467 
1468         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1469         unchecked {
1470             _burnCounter++;
1471         }
1472     }
1473 
1474     /**
1475      * @dev Approve `to` to operate on `tokenId`
1476      *
1477      * Emits a {Approval} event.
1478      */
1479     function _approve(
1480         address to,
1481         uint256 tokenId,
1482         address owner
1483     ) private {
1484         _tokenApprovals[tokenId] = to;
1485         emit Approval(owner, to, tokenId);
1486     }
1487 
1488     /**
1489      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1490      *
1491      * @param from address representing the previous owner of the given token ID
1492      * @param to target address that will receive the tokens
1493      * @param tokenId uint256 ID of the token to be transferred
1494      * @param _data bytes optional data to send along with the call
1495      * @return bool whether the call correctly returned the expected magic value
1496      */
1497     function _checkContractOnERC721Received(
1498         address from,
1499         address to,
1500         uint256 tokenId,
1501         bytes memory _data
1502     ) private returns (bool) {
1503         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1504             return retval == IERC721Receiver(to).onERC721Received.selector;
1505         } catch (bytes memory reason) {
1506             if (reason.length == 0) {
1507                 revert TransferToNonERC721ReceiverImplementer();
1508             } else {
1509                 assembly {
1510                     revert(add(32, reason), mload(reason))
1511                 }
1512             }
1513         }
1514     }
1515 
1516     /**
1517      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1518      * And also called before burning one token.
1519      *
1520      * startTokenId - the first token id to be transferred
1521      * quantity - the amount to be transferred
1522      *
1523      * Calling conditions:
1524      *
1525      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1526      * transferred to `to`.
1527      * - When `from` is zero, `tokenId` will be minted for `to`.
1528      * - When `to` is zero, `tokenId` will be burned by `from`.
1529      * - `from` and `to` are never both zero.
1530      */
1531     function _beforeTokenTransfers(
1532         address from,
1533         address to,
1534         uint256 startTokenId,
1535         uint256 quantity
1536     ) internal virtual {}
1537 
1538     /**
1539      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1540      * minting.
1541      * And also called after one token has been burned.
1542      *
1543      * startTokenId - the first token id to be transferred
1544      * quantity - the amount to be transferred
1545      *
1546      * Calling conditions:
1547      *
1548      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1549      * transferred to `to`.
1550      * - When `from` is zero, `tokenId` has been minted for `to`.
1551      * - When `to` is zero, `tokenId` has been burned by `from`.
1552      * - `from` and `to` are never both zero.
1553      */
1554     function _afterTokenTransfers(
1555         address from,
1556         address to,
1557         uint256 startTokenId,
1558         uint256 quantity
1559     ) internal virtual {}
1560 }
1561 // File: contracts/ting.sol
1562 
1563 
1564 
1565 pragma solidity ^0.8.7;
1566 
1567 contract moblin_gfers is ERC721A, Ownable {
1568     using SafeMath for uint256;
1569     using Strings for uint256;
1570 
1571     uint256 public maxPerTx = 10;
1572     uint256 public maxSupply = 1200;
1573     uint256 public freeMintMax = 500; // Free supply
1574     uint256 public price = 0.004 ether;
1575     uint256 public maxFreePerWallet = 3; 
1576 
1577     string private baseURI = "https://gateway.pinata.cloud/ipfs/QmZzJGvf6EesdFycXwQhjsjNr9eGZgW3yCyBMTWRZsdcrg/";
1578     string public constant baseExtension = ".json";
1579 
1580     mapping(address => uint256) private _mintedFreeAmount; 
1581 
1582     bool public paused = true;
1583     bool public revealed = false;
1584     error freeMintIsOver();
1585 
1586     address devWallet = 0x37cfB7bb56A8a3dBc7C534249d089dCEA73392a2;
1587     uint _devFee = 10;
1588 
1589 // Feel free to sweep the floor, since you're here already xD 
1590 
1591     constructor() ERC721A("moblin gfers", "MGFERS") {}
1592 
1593     function mint(uint256 count) external payable {
1594         uint256 cost = price;
1595         bool isFree = ((totalSupply() + count < freeMintMax + 1) &&
1596             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1597 
1598         if (isFree) {
1599             cost = 0;
1600         }
1601 
1602         require(!paused, "Contract Paused.");
1603         require(msg.value >= count * cost, "Please send the exact amount.");
1604         require(totalSupply() + count < maxSupply + 1, "No more");
1605         require(count < maxPerTx + 1, "Max per TX reached.");
1606 
1607         if (isFree) {
1608             _mintedFreeAmount[msg.sender] += count;
1609         }
1610 
1611         _safeMint(msg.sender, count);
1612     } 
1613 
1614     function teamMint(uint256 _number) external onlyOwner {
1615         require(totalSupply() + _number <= maxSupply, "Minting would exceed maxSupply");
1616         _safeMint(_msgSender(), _number);
1617     }
1618 
1619     function setMaxFreeMint(uint256 _max) public onlyOwner {
1620         freeMintMax = _max;
1621     }
1622 
1623     function setMaxPaidPerTx(uint256 _max) public onlyOwner {
1624         maxPerTx = _max;
1625     }
1626 
1627     function setMaxSupply(uint256 _max) public onlyOwner {
1628         maxSupply = _max;
1629     }
1630 
1631     function setFreeAmount(uint256 amount) external onlyOwner {
1632         freeMintMax = amount;
1633     } 
1634 
1635     function reveal() public onlyOwner {
1636         revealed = true;
1637     }  
1638 
1639     function _startTokenId() internal override view virtual returns (uint256) {
1640         return 1;
1641     }
1642 
1643     function minted(address _owner) public view returns (uint256) {
1644         return _numberMinted(_owner);
1645     }
1646 
1647     function _withdraw(address _address, uint256 _amount) private {
1648         (bool success, ) = _address.call{value: _amount}("");
1649         require(success, "Failed to withdraw Ether");
1650     }
1651 
1652     function withdrawAll() public onlyOwner {
1653         uint256 balance = address(this).balance;
1654         require(balance > 0, "Insufficent balance");
1655 
1656         _withdraw(_msgSender(), balance * (100 - devFee) / 100);
1657         _withdraw(devWallet, balance * devFee / 100);
1658     }
1659 
1660     function setPrice(uint256 _price) external onlyOwner {
1661         price = _price;
1662     }
1663 
1664     function setPause(bool _state) external onlyOwner {
1665         paused = _state;
1666     }
1667 
1668     function _baseURI() internal view virtual override returns (string memory) {
1669       return baseURI;
1670     }
1671     
1672     function setBaseURI(string memory baseURI_) external onlyOwner {
1673         baseURI = baseURI_;
1674     }
1675 
1676     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1677     {
1678         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1679 
1680 
1681         string memory _tokenURI = super.tokenURI(tokenId);
1682         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1683     }
1684 }