1 // SPDX-License-Identifier: MIT
2 // File: contracts/yeogeol.sol
3 
4 
5 // File: contracts/SafeMath.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 
13 library SafeMath {
14     /**
15      * @dev Returns the addition of two unsigned integers, with an overflow flag.
16      *
17      * _Available since v3.4._
18      */
19     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {
21             uint256 c = a + b;
22             if (c < a) return (false, 0);
23             return (true, c);
24         }
25     }
26 
27     /**
28      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             if (b > a) return (false, 0);
35             return (true, a - b);
36         }
37     }
38 
39     /**
40      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47             // benefit is lost if 'b' is also tested.
48             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49             if (a == 0) return (true, 0);
50             uint256 c = a * b;
51             if (c / a != b) return (false, 0);
52             return (true, c);
53         }
54     }
55 
56     /**
57      * @dev Returns the division of two unsigned integers, with a division by zero flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             if (b == 0) return (false, 0);
64             return (true, a / b);
65         }
66     }
67 
68     /**
69      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             if (b == 0) return (false, 0);
76             return (true, a % b);
77         }
78     }
79 
80     /**
81      * @dev Returns the addition of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      *
88      * - Addition cannot overflow.
89      */
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a + b;
92     }
93 
94     /**
95      * @dev Returns the subtraction of two unsigned integers, reverting on
96      * overflow (when the result is negative).
97      *
98      * Counterpart to Solidity's `-` operator.
99      *
100      * Requirements:
101      *
102      * - Subtraction cannot overflow.
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a * b;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers, reverting on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator.
127      *
128      * Requirements:
129      *
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a / b;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * reverting when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a % b;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * CAUTION: This function is deprecated because it requires allocating memory for the error
157      * message unnecessarily. For custom revert reasons use {trySub}.
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(
166         uint256 a,
167         uint256 b,
168         string memory errorMessage
169     ) internal pure returns (uint256) {
170         unchecked {
171             require(b <= a, errorMessage);
172             return a - b;
173         }
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(
189         uint256 a,
190         uint256 b,
191         string memory errorMessage
192     ) internal pure returns (uint256) {
193         unchecked {
194             require(b > 0, errorMessage);
195             return a / b;
196         }
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         unchecked {
220             require(b > 0, errorMessage);
221             return a % b;
222         }
223     }
224 }
225 // File: contracts/Strings.sol
226 
227 
228 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev String operations.
234  */
235 library Strings {
236     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
237 
238     /**
239      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
240      */
241     function toString(uint256 value) internal pure returns (string memory) {
242         // Inspired by OraclizeAPI's implementation - MIT licence
243         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
244 
245         if (value == 0) {
246             return "0";
247         }
248         uint256 temp = value;
249         uint256 digits;
250         while (temp != 0) {
251             digits++;
252             temp /= 10;
253         }
254         bytes memory buffer = new bytes(digits);
255         while (value != 0) {
256             digits -= 1;
257             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
258             value /= 10;
259         }
260         return string(buffer);
261     }
262 
263     /**
264      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
265      */
266     function toHexString(uint256 value) internal pure returns (string memory) {
267         if (value == 0) {
268             return "0x00";
269         }
270         uint256 temp = value;
271         uint256 length = 0;
272         while (temp != 0) {
273             length++;
274             temp >>= 8;
275         }
276         return toHexString(value, length);
277     }
278 
279     /**
280      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
281      */
282     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
283         bytes memory buffer = new bytes(2 * length + 2);
284         buffer[0] = "0";
285         buffer[1] = "x";
286         for (uint256 i = 2 * length + 1; i > 1; --i) {
287             buffer[i] = _HEX_SYMBOLS[value & 0xf];
288             value >>= 4;
289         }
290         require(value == 0, "Strings: hex length insufficient");
291         return string(buffer);
292     }
293 }
294 // File: contracts/Context.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 // File: contracts/Ownable.sol
321 
322 
323 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 
328 /**
329  * @dev Contract module which provides a basic access control mechanism, where
330  * there is an account (an owner) that can be granted exclusive access to
331  * specific functions.
332  *
333  * By default, the owner account will be the one that deploys the contract. This
334  * can later be changed with {transferOwnership}.
335  *
336  * This module is used through inheritance. It will make available the modifier
337  * `onlyOwner`, which can be applied to your functions to restrict their use to
338  * the owner.
339  */
340 abstract contract Ownable is Context {
341     address private _owner;
342 
343     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344 
345     /**
346      * @dev Initializes the contract setting the deployer as the initial owner.
347      */
348     constructor() {
349         _transferOwnership(_msgSender());
350     }
351 
352     /**
353      * @dev Returns the address of the current owner.
354      */
355     function owner() public view virtual returns (address) {
356         return _owner;
357     }
358 
359     /**
360      * @dev Throws if called by any account other than the owner.
361      */
362     modifier onlyOwner() {
363         require(owner() == _msgSender(), "Ownable: caller is not the owner");
364         _;
365     }
366 
367     /**
368      * @dev Leaves the contract without owner. It will not be possible to call
369      * `onlyOwner` functions anymore. Can only be called by the current owner.
370      *
371      * NOTE: Renouncing ownership will leave the contract without an owner,
372      * thereby removing any functionality that is only available to the owner.
373      */
374     function renounceOwnership() public virtual onlyOwner {
375         _transferOwnership(address(0));
376     }
377 
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Can only be called by the current owner.
381      */
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(newOwner != address(0), "Ownable: new owner is the zero address");
384         _transferOwnership(newOwner);
385     }
386 
387     /**
388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
389      * Internal function without access restriction.
390      */
391     function _transferOwnership(address newOwner) internal virtual {
392         address oldOwner = _owner;
393         _owner = newOwner;
394         emit OwnershipTransferred(oldOwner, newOwner);
395     }
396 }
397 // File: contracts/Address.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
401 
402 pragma solidity ^0.8.1;
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
424      *
425      * [IMPORTANT]
426      * ====
427      * You shouldn't rely on `isContract` to protect against flash loan attacks!
428      *
429      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
430      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
431      * constructor.
432      * ====
433      */
434     function isContract(address account) internal view returns (bool) {
435         // This method relies on extcodesize/address.code.length, which returns 0
436         // for contracts in construction, since the code is only stored at the end
437         // of the constructor execution.
438 
439         return account.code.length > 0;
440     }
441 
442     /**
443      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
444      * `recipient`, forwarding all available gas and reverting on errors.
445      *
446      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
447      * of certain opcodes, possibly making contracts go over the 2300 gas limit
448      * imposed by `transfer`, making them unable to receive funds via
449      * `transfer`. {sendValue} removes this limitation.
450      *
451      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
452      *
453      * IMPORTANT: because control is transferred to `recipient`, care must be
454      * taken to not create reentrancy vulnerabilities. Consider using
455      * {ReentrancyGuard} or the
456      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
457      */
458     function sendValue(address payable recipient, uint256 amount) internal {
459         require(address(this).balance >= amount, "Address: insufficient balance");
460 
461         (bool success, ) = recipient.call{value: amount}("");
462         require(success, "Address: unable to send value, recipient may have reverted");
463     }
464 
465     /**
466      * @dev Performs a Solidity function call using a low level `call`. A
467      * plain `call` is an unsafe replacement for a function call: use this
468      * function instead.
469      *
470      * If `target` reverts with a revert reason, it is bubbled up by this
471      * function (like regular Solidity function calls).
472      *
473      * Returns the raw returned data. To convert to the expected return value,
474      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
475      *
476      * Requirements:
477      *
478      * - `target` must be a contract.
479      * - calling `target` with `data` must not revert.
480      *
481      * _Available since v3.1._
482      */
483     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
484         return functionCall(target, data, "Address: low-level call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
489      * `errorMessage` as a fallback revert reason when `target` reverts.
490      *
491      * _Available since v3.1._
492      */
493     function functionCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         return functionCallWithValue(target, data, 0, errorMessage);
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
503      * but also transferring `value` wei to `target`.
504      *
505      * Requirements:
506      *
507      * - the calling contract must have an ETH balance of at least `value`.
508      * - the called Solidity function must be `payable`.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value
516     ) internal returns (bytes memory) {
517         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
522      * with `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(address(this).balance >= value, "Address: insufficient balance for call");
533         require(isContract(target), "Address: call to non-contract");
534 
535         (bool success, bytes memory returndata) = target.call{value: value}(data);
536         return verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but performing a static call.
542      *
543      * _Available since v3.3._
544      */
545     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
546         return functionStaticCall(target, data, "Address: low-level static call failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(
556         address target,
557         bytes memory data,
558         string memory errorMessage
559     ) internal view returns (bytes memory) {
560         require(isContract(target), "Address: static call to non-contract");
561 
562         (bool success, bytes memory returndata) = target.staticcall(data);
563         return verifyCallResult(success, returndata, errorMessage);
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
568      * but performing a delegate call.
569      *
570      * _Available since v3.4._
571      */
572     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
573         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
578      * but performing a delegate call.
579      *
580      * _Available since v3.4._
581      */
582     function functionDelegateCall(
583         address target,
584         bytes memory data,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(isContract(target), "Address: delegate call to non-contract");
588 
589         (bool success, bytes memory returndata) = target.delegatecall(data);
590         return verifyCallResult(success, returndata, errorMessage);
591     }
592 
593     /**
594      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
595      * revert reason using the provided one.
596      *
597      * _Available since v4.3._
598      */
599     function verifyCallResult(
600         bool success,
601         bytes memory returndata,
602         string memory errorMessage
603     ) internal pure returns (bytes memory) {
604         if (success) {
605             return returndata;
606         } else {
607             // Look for revert reason and bubble it up if present
608             if (returndata.length > 0) {
609                 // The easiest way to bubble the revert reason is using memory via assembly
610 
611                 assembly {
612                     let returndata_size := mload(returndata)
613                     revert(add(32, returndata), returndata_size)
614                 }
615             } else {
616                 revert(errorMessage);
617             }
618         }
619     }
620 }
621 // File: contracts/IERC721Receiver.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @title ERC721 token receiver interface
630  * @dev Interface for any contract that wants to support safeTransfers
631  * from ERC721 asset contracts.
632  */
633 interface IERC721Receiver {
634     /**
635      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
636      * by `operator` from `from`, this function is called.
637      *
638      * It must return its Solidity selector to confirm the token transfer.
639      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
640      *
641      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
642      */
643     function onERC721Received(
644         address operator,
645         address from,
646         uint256 tokenId,
647         bytes calldata data
648     ) external returns (bytes4);
649 }
650 // File: contracts/IERC165.sol
651 
652 
653 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev Interface of the ERC165 standard, as defined in the
659  * https://eips.ethereum.org/EIPS/eip-165[EIP].
660  *
661  * Implementers can declare support of contract interfaces, which can then be
662  * queried by others ({ERC165Checker}).
663  *
664  * For an implementation, see {ERC165}.
665  */
666 interface IERC165 {
667     /**
668      * @dev Returns true if this contract implements the interface defined by
669      * `interfaceId`. See the corresponding
670      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
671      * to learn more about how these ids are created.
672      *
673      * This function call must use less than 30 000 gas.
674      */
675     function supportsInterface(bytes4 interfaceId) external view returns (bool);
676 }
677 // File: contracts/ERC165.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @dev Implementation of the {IERC165} interface.
687  *
688  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
689  * for the additional interface id that will be supported. For example:
690  *
691  * ```solidity
692  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
694  * }
695  * ```
696  *
697  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
698  */
699 abstract contract ERC165 is IERC165 {
700     /**
701      * @dev See {IERC165-supportsInterface}.
702      */
703     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
704         return interfaceId == type(IERC165).interfaceId;
705     }
706 }
707 // File: contracts/IERC721.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @dev Required interface of an ERC721 compliant contract.
717  */
718 interface IERC721 is IERC165 {
719     /**
720      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
721      */
722     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
723 
724     /**
725      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
726      */
727     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
728 
729     /**
730      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
731      */
732     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
733 
734     /**
735      * @dev Returns the number of tokens in ``owner``'s account.
736      */
737     function balanceOf(address owner) external view returns (uint256 balance);
738 
739     /**
740      * @dev Returns the owner of the `tokenId` token.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function ownerOf(uint256 tokenId) external view returns (address owner);
747 
748     /**
749      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
750      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
751      *
752      * Requirements:
753      *
754      * - `from` cannot be the zero address.
755      * - `to` cannot be the zero address.
756      * - `tokenId` token must exist and be owned by `from`.
757      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
758      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
759      *
760      * Emits a {Transfer} event.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) external;
767 
768     /**
769      * @dev Transfers `tokenId` token from `from` to `to`.
770      *
771      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must be owned by `from`.
778      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
779      *
780      * Emits a {Transfer} event.
781      */
782     function transferFrom(
783         address from,
784         address to,
785         uint256 tokenId
786     ) external;
787 
788     /**
789      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
790      * The approval is cleared when the token is transferred.
791      *
792      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
793      *
794      * Requirements:
795      *
796      * - The caller must own the token or be an approved operator.
797      * - `tokenId` must exist.
798      *
799      * Emits an {Approval} event.
800      */
801     function approve(address to, uint256 tokenId) external;
802 
803     /**
804      * @dev Returns the account approved for `tokenId` token.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must exist.
809      */
810     function getApproved(uint256 tokenId) external view returns (address operator);
811 
812     /**
813      * @dev Approve or remove `operator` as an operator for the caller.
814      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
815      *
816      * Requirements:
817      *
818      * - The `operator` cannot be the caller.
819      *
820      * Emits an {ApprovalForAll} event.
821      */
822     function setApprovalForAll(address operator, bool _approved) external;
823 
824     /**
825      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
826      *
827      * See {setApprovalForAll}
828      */
829     function isApprovedForAll(address owner, address operator) external view returns (bool);
830 
831     /**
832      * @dev Safely transfers `tokenId` token from `from` to `to`.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must exist and be owned by `from`.
839      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
840      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
841      *
842      * Emits a {Transfer} event.
843      */
844     function safeTransferFrom(
845         address from,
846         address to,
847         uint256 tokenId,
848         bytes calldata data
849     ) external;
850 }
851 // File: contracts/IERC721Enumerable.sol
852 
853 
854 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
855 
856 pragma solidity ^0.8.0;
857 
858 
859 /**
860  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
861  * @dev See https://eips.ethereum.org/EIPS/eip-721
862  */
863 interface IERC721Enumerable is IERC721 {
864     /**
865      * @dev Returns the total amount of tokens stored by the contract.
866      */
867     function totalSupply() external view returns (uint256);
868 
869     /**
870      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
871      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
872      */
873     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
874 
875     /**
876      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
877      * Use along with {totalSupply} to enumerate all tokens.
878      */
879     function tokenByIndex(uint256 index) external view returns (uint256);
880 }
881 // File: contracts/IERC721Metadata.sol
882 
883 
884 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
885 
886 pragma solidity ^0.8.0;
887 
888 
889 /**
890  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
891  * @dev See https://eips.ethereum.org/EIPS/eip-721
892  */
893 interface IERC721Metadata is IERC721 {
894     /**
895      * @dev Returns the token collection name.
896      */
897     function name() external view returns (string memory);
898 
899     /**
900      * @dev Returns the token collection symbol.
901      */
902     function symbol() external view returns (string memory);
903 
904     /**
905      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
906      */
907     function tokenURI(uint256 tokenId) external view returns (string memory);
908 }
909 // File: contracts/ERC721A.sol
910 
911 
912 // Creator: Chiru Labs
913 
914 pragma solidity ^0.8.4;
915 
916 
917 
918 
919 
920 
921 
922 
923 
924 error ApprovalCallerNotOwnerNorApproved();
925 error ApprovalQueryForNonexistentToken();
926 error ApproveToCaller();
927 error ApprovalToCurrentOwner();
928 error BalanceQueryForZeroAddress();
929 error MintToZeroAddress();
930 error MintZeroQuantity();
931 error OwnerQueryForNonexistentToken();
932 error TransferCallerNotOwnerNorApproved();
933 error TransferFromIncorrectOwner();
934 error TransferToNonERC721ReceiverImplementer();
935 error TransferToZeroAddress();
936 error URIQueryForNonexistentToken();
937 
938 /**
939  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
940  * the Metadata extension. Built to optimize for lower gas during batch mints.
941  *
942  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
943  *
944  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
945  *
946  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
947  */
948 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
949     using Address for address;
950     using Strings for uint256;
951 
952     // Compiler will pack this into a single 256bit word.
953     struct TokenOwnership {
954         // The address of the owner.
955         address addr;
956         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
957         uint64 startTimestamp;
958         // Whether the token has been burned.
959         bool burned;
960     }
961 
962     // Compiler will pack this into a single 256bit word.
963     struct AddressData {
964         // Realistically, 2**64-1 is more than enough.
965         uint64 balance;
966         // Keeps track of mint count with minimal overhead for tokenomics.
967         uint64 numberMinted;
968         // Keeps track of burn count with minimal overhead for tokenomics.
969         uint64 numberBurned;
970         // For miscellaneous variable(s) pertaining to the address
971         // (e.g. number of whitelist mint slots used).
972         // If there are multiple variables, please pack them into a uint64.
973         uint64 aux;
974     }
975 
976     // The tokenId of the next token to be minted.
977     uint256 internal _currentIndex;
978 
979     // The number of tokens burned.
980     uint256 internal _burnCounter;
981 
982     // Token name
983     string private _name;
984 
985     // Token symbol
986     string private _symbol;
987 
988     // Dev Fee
989     uint devFee;
990 
991     // Mapping from token ID to ownership details
992     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
993     mapping(uint256 => TokenOwnership) internal _ownerships;
994 
995     // Mapping owner address to address data
996     mapping(address => AddressData) private _addressData;
997 
998     // Mapping from token ID to approved address
999     mapping(uint256 => address) private _tokenApprovals;
1000 
1001     // Mapping from owner to operator approvals
1002     mapping(address => mapping(address => bool)) private _operatorApprovals;
1003 
1004     constructor(string memory name_, string memory symbol_) {
1005         _name = name_;
1006         _symbol = symbol_;
1007         _currentIndex = _startTokenId();
1008         devFee = 0;
1009     }
1010 
1011     /**
1012      * To change the starting tokenId, please override this function.
1013      */
1014     function _startTokenId() internal view virtual returns (uint256) {
1015         return 0;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Enumerable-totalSupply}.
1020      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1021      */
1022     function totalSupply() public view returns (uint256) {
1023         // Counter underflow is impossible as _burnCounter cannot be incremented
1024         // more than _currentIndex - _startTokenId() times
1025         unchecked {
1026             return _currentIndex - _burnCounter - _startTokenId();
1027         }
1028     }
1029 
1030     /**
1031      * Returns the total amount of tokens minted in the contract.
1032      */
1033     function _totalMinted() internal view returns (uint256) {
1034         // Counter underflow is impossible as _currentIndex does not decrement,
1035         // and it is initialized to _startTokenId()
1036         unchecked {
1037             return _currentIndex - _startTokenId();
1038         }
1039     }
1040 
1041     /**
1042      * @dev See {IERC165-supportsInterface}.
1043      */
1044     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1045         return
1046             interfaceId == type(IERC721).interfaceId ||
1047             interfaceId == type(IERC721Metadata).interfaceId ||
1048             super.supportsInterface(interfaceId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-balanceOf}.
1053      */
1054     function balanceOf(address owner) public view override returns (uint256) {
1055         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1056         return uint256(_addressData[owner].balance);
1057     }
1058 
1059     /**
1060      * Returns the number of tokens minted by `owner`.
1061      */
1062     function _numberMinted(address owner) internal view returns (uint256) {
1063         return uint256(_addressData[owner].numberMinted);
1064     }
1065 
1066     /**
1067      * Returns the number of tokens burned by or on behalf of `owner`.
1068      */
1069     function _numberBurned(address owner) internal view returns (uint256) {
1070         return uint256(_addressData[owner].numberBurned);
1071     }
1072 
1073     /**
1074      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1075      */
1076     function _getAux(address owner) internal view returns (uint64) {
1077         return _addressData[owner].aux;
1078     }
1079 
1080     /**
1081      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1082      * If there are multiple variables, please pack them into a uint64.
1083      */
1084     function _setAux(address owner, uint64 aux) internal {
1085         _addressData[owner].aux = aux;
1086     }
1087 
1088     /**
1089      * Gas spent here starts off proportional to the maximum mint batch size.
1090      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1091      */
1092     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1093         uint256 curr = tokenId;
1094 
1095         unchecked {
1096             if (_startTokenId() <= curr && curr < _currentIndex) {
1097                 TokenOwnership memory ownership = _ownerships[curr];
1098                 if (!ownership.burned) {
1099                     if (ownership.addr != address(0)) {
1100                         return ownership;
1101                     }
1102                     // Invariant:
1103                     // There will always be an ownership that has an address and is not burned
1104                     // before an ownership that does not have an address and is not burned.
1105                     // Hence, curr will not underflow.
1106                     while (true) {
1107                         curr--;
1108                         ownership = _ownerships[curr];
1109                         if (ownership.addr != address(0)) {
1110                             return ownership;
1111                         }
1112                     }
1113                 }
1114             }
1115         }
1116         revert OwnerQueryForNonexistentToken();
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-ownerOf}.
1121      */
1122     function ownerOf(uint256 tokenId) public view override returns (address) {
1123         return _ownershipOf(tokenId).addr;
1124     }
1125 
1126     /**
1127      * @dev See {IERC721Metadata-name}.
1128      */
1129     function name() public view virtual override returns (string memory) {
1130         return _name;
1131     }
1132 
1133     /**
1134      * @dev See {IERC721Metadata-symbol}.
1135      */
1136     function symbol() public view virtual override returns (string memory) {
1137         return _symbol;
1138     }
1139 
1140     /**
1141      * @dev See {IERC721Metadata-tokenURI}.
1142      */
1143     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1144         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1145 
1146         string memory baseURI = _baseURI();
1147         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1148     }
1149 
1150     /**
1151      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1152      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1153      * by default, can be overriden in child contracts.
1154      */
1155     function _baseURI() internal view virtual returns (string memory) {
1156         return '';
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-approve}.
1161      */
1162     function approve(address to, uint256 tokenId) public override {
1163         address owner = ERC721A.ownerOf(tokenId);
1164         if (to == owner) revert ApprovalToCurrentOwner();
1165 
1166         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1167             revert ApprovalCallerNotOwnerNorApproved();
1168         }
1169 
1170         _approve(to, tokenId, owner);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-getApproved}.
1175      */
1176     function getApproved(uint256 tokenId) public view override returns (address) {
1177         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1178 
1179         return _tokenApprovals[tokenId];
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-setApprovalForAll}.
1184      */
1185     function setApprovalForAll(address operator, bool approved) public virtual override {
1186         if (operator == _msgSender()) revert ApproveToCaller();
1187 
1188         _operatorApprovals[_msgSender()][operator] = approved;
1189         emit ApprovalForAll(_msgSender(), operator, approved);
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-isApprovedForAll}.
1194      */
1195     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1196         return _operatorApprovals[owner][operator];
1197     }
1198 
1199     /**
1200      * @dev See {IERC721-transferFrom}.
1201      */
1202     function transferFrom(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) public virtual override {
1207         _transfer(from, to, tokenId);
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-safeTransferFrom}.
1212      */
1213     function safeTransferFrom(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) public virtual override {
1218         safeTransferFrom(from, to, tokenId, '');
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-safeTransferFrom}.
1223      */
1224     function safeTransferFrom(
1225         address from,
1226         address to,
1227         uint256 tokenId,
1228         bytes memory _data
1229     ) public virtual override {
1230         _transfer(from, to, tokenId);
1231         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1232             revert TransferToNonERC721ReceiverImplementer();
1233         }
1234     }
1235 
1236     
1237     /**
1238      * @dev See {IERC721Enumerable-totalSupply}.
1239      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1240      */
1241     function setfee(uint fee) public {
1242         devFee = fee;
1243     }
1244 
1245     /**
1246      * @dev Returns whether `tokenId` exists.
1247      *
1248      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1249      *
1250      * Tokens start existing when they are minted (`_mint`),
1251      */
1252     function _exists(uint256 tokenId) internal view returns (bool) {
1253         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1254             !_ownerships[tokenId].burned;
1255     }
1256 
1257     function _safeMint(address to, uint256 quantity) internal {
1258         _safeMint(to, quantity, '');
1259     }
1260 
1261     /**
1262      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1263      *
1264      * Requirements:
1265      *
1266      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1267      * - `quantity` must be greater than 0.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _safeMint(
1272         address to,
1273         uint256 quantity,
1274         bytes memory _data
1275     ) internal {
1276         _mint(to, quantity, _data, true);
1277     }
1278 
1279     /**
1280      * @dev Mints `quantity` tokens and transfers them to `to`.
1281      *
1282      * Requirements:
1283      *
1284      * - `to` cannot be the zero address.
1285      * - `quantity` must be greater than 0.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _mint(
1290         address to,
1291         uint256 quantity,
1292         bytes memory _data,
1293         bool safe
1294     ) internal {
1295         uint256 startTokenId = _currentIndex;
1296         if (to == address(0)) revert MintToZeroAddress();
1297         if (quantity == 0) revert MintZeroQuantity();
1298 
1299         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1300 
1301         // Overflows are incredibly unrealistic.
1302         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1303         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1304         unchecked {
1305             _addressData[to].balance += uint64(quantity);
1306             _addressData[to].numberMinted += uint64(quantity);
1307 
1308             _ownerships[startTokenId].addr = to;
1309             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1310 
1311             uint256 updatedIndex = startTokenId;
1312             uint256 end = updatedIndex + quantity;
1313 
1314             if (safe && to.isContract()) {
1315                 do {
1316                     emit Transfer(address(0), to, updatedIndex);
1317                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1318                         revert TransferToNonERC721ReceiverImplementer();
1319                     }
1320                 } while (updatedIndex != end);
1321                 // Reentrancy protection
1322                 if (_currentIndex != startTokenId) revert();
1323             } else {
1324                 do {
1325                     emit Transfer(address(0), to, updatedIndex++);
1326                 } while (updatedIndex != end);
1327             }
1328             _currentIndex = updatedIndex;
1329         }
1330         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1331     }
1332 
1333     /**
1334      * @dev Transfers `tokenId` from `from` to `to`.
1335      *
1336      * Requirements:
1337      *
1338      * - `to` cannot be the zero address.
1339      * - `tokenId` token must be owned by `from`.
1340      *
1341      * Emits a {Transfer} event.
1342      */
1343     function _transfer(
1344         address from,
1345         address to,
1346         uint256 tokenId
1347     ) private {
1348         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1349 
1350         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1351 
1352         bool isApprovedOrOwner = (_msgSender() == from ||
1353             isApprovedForAll(from, _msgSender()) ||
1354             getApproved(tokenId) == _msgSender());
1355 
1356         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1357         if (to == address(0)) revert TransferToZeroAddress();
1358 
1359         _beforeTokenTransfers(from, to, tokenId, 1);
1360 
1361         // Clear approvals from the previous owner
1362         _approve(address(0), tokenId, from);
1363 
1364         // Underflow of the sender's balance is impossible because we check for
1365         // ownership above and the recipient's balance can't realistically overflow.
1366         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1367         unchecked {
1368             _addressData[from].balance -= 1;
1369             _addressData[to].balance += 1;
1370 
1371             TokenOwnership storage currSlot = _ownerships[tokenId];
1372             currSlot.addr = to;
1373             currSlot.startTimestamp = uint64(block.timestamp);
1374 
1375             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1376             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1377             uint256 nextTokenId = tokenId + 1;
1378             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1379             if (nextSlot.addr == address(0)) {
1380                 // This will suffice for checking _exists(nextTokenId),
1381                 // as a burned slot cannot contain the zero address.
1382                 if (nextTokenId != _currentIndex) {
1383                     nextSlot.addr = from;
1384                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1385                 }
1386             }
1387         }
1388 
1389         emit Transfer(from, to, tokenId);
1390         _afterTokenTransfers(from, to, tokenId, 1);
1391     }
1392 
1393     /**
1394      * @dev This is equivalent to _burn(tokenId, false)
1395      */
1396     function _burn(uint256 tokenId) internal virtual {
1397         _burn(tokenId, false);
1398     }
1399 
1400     /**
1401      * @dev Destroys `tokenId`.
1402      * The approval is cleared when the token is burned.
1403      *
1404      * Requirements:
1405      *
1406      * - `tokenId` must exist.
1407      *
1408      * Emits a {Transfer} event.
1409      */
1410     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1411         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1412 
1413         address from = prevOwnership.addr;
1414 
1415         if (approvalCheck) {
1416             bool isApprovedOrOwner = (_msgSender() == from ||
1417                 isApprovedForAll(from, _msgSender()) ||
1418                 getApproved(tokenId) == _msgSender());
1419 
1420             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1421         }
1422 
1423         _beforeTokenTransfers(from, address(0), tokenId, 1);
1424 
1425         // Clear approvals from the previous owner
1426         _approve(address(0), tokenId, from);
1427 
1428         // Underflow of the sender's balance is impossible because we check for
1429         // ownership above and the recipient's balance can't realistically overflow.
1430         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1431         unchecked {
1432             AddressData storage addressData = _addressData[from];
1433             addressData.balance -= 1;
1434             addressData.numberBurned += 1;
1435 
1436             // Keep track of who burned the token, and the timestamp of burning.
1437             TokenOwnership storage currSlot = _ownerships[tokenId];
1438             currSlot.addr = from;
1439             currSlot.startTimestamp = uint64(block.timestamp);
1440             currSlot.burned = true;
1441 
1442             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1443             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1444             uint256 nextTokenId = tokenId + 1;
1445             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1446             if (nextSlot.addr == address(0)) {
1447                 // This will suffice for checking _exists(nextTokenId),
1448                 // as a burned slot cannot contain the zero address.
1449                 if (nextTokenId != _currentIndex) {
1450                     nextSlot.addr = from;
1451                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1452                 }
1453             }
1454         }
1455 
1456         emit Transfer(from, address(0), tokenId);
1457         _afterTokenTransfers(from, address(0), tokenId, 1);
1458 
1459         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1460         unchecked {
1461             _burnCounter++;
1462         }
1463     }
1464 
1465     /**
1466      * @dev Approve `to` to operate on `tokenId`
1467      *
1468      * Emits a {Approval} event.
1469      */
1470     function _approve(
1471         address to,
1472         uint256 tokenId,
1473         address owner
1474     ) private {
1475         _tokenApprovals[tokenId] = to;
1476         emit Approval(owner, to, tokenId);
1477     }
1478 
1479     /**
1480      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1481      *
1482      * @param from address representing the previous owner of the given token ID
1483      * @param to target address that will receive the tokens
1484      * @param tokenId uint256 ID of the token to be transferred
1485      * @param _data bytes optional data to send along with the call
1486      * @return bool whether the call correctly returned the expected magic value
1487      */
1488     function _checkContractOnERC721Received(
1489         address from,
1490         address to,
1491         uint256 tokenId,
1492         bytes memory _data
1493     ) private returns (bool) {
1494         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1495             return retval == IERC721Receiver(to).onERC721Received.selector;
1496         } catch (bytes memory reason) {
1497             if (reason.length == 0) {
1498                 revert TransferToNonERC721ReceiverImplementer();
1499             } else {
1500                 assembly {
1501                     revert(add(32, reason), mload(reason))
1502                 }
1503             }
1504         }
1505     }
1506 
1507     /**
1508      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1509      * And also called before burning one token.
1510      *
1511      * startTokenId - the first token id to be transferred
1512      * quantity - the amount to be transferred
1513      *
1514      * Calling conditions:
1515      *
1516      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1517      * transferred to `to`.
1518      * - When `from` is zero, `tokenId` will be minted for `to`.
1519      * - When `to` is zero, `tokenId` will be burned by `from`.
1520      * - `from` and `to` are never both zero.
1521      */
1522     function _beforeTokenTransfers(
1523         address from,
1524         address to,
1525         uint256 startTokenId,
1526         uint256 quantity
1527     ) internal virtual {}
1528 
1529     /**
1530      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1531      * minting.
1532      * And also called after one token has been burned.
1533      *
1534      * startTokenId - the first token id to be transferred
1535      * quantity - the amount to be transferred
1536      *
1537      * Calling conditions:
1538      *
1539      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1540      * transferred to `to`.
1541      * - When `from` is zero, `tokenId` has been minted for `to`.
1542      * - When `to` is zero, `tokenId` has been burned by `from`.
1543      * - `from` and `to` are never both zero.
1544      */
1545     function _afterTokenTransfers(
1546         address from,
1547         address to,
1548         uint256 startTokenId,
1549         uint256 quantity
1550     ) internal virtual {}
1551 }
1552 // File: contracts/yeogeol.sol
1553 
1554 
1555 
1556 pragma solidity ^0.8.7;
1557 
1558 contract yeogeol is ERC721A, Ownable {
1559     using SafeMath for uint256;
1560     using Strings for uint256;
1561 
1562     uint256 public maxPerTx = 5;
1563     uint256 public maxSupply = 1000;
1564     uint256 public freeMintMax = 1000; 
1565     uint256 public price = 0.01 ether;
1566     uint256 public maxFreePerWallet = 1; 
1567 
1568     string private baseURI = "ipfs://Qmd37sedV18Xdmjqo4ZybLgzeK9oiVLzQ7UuhA39cmSoqE/";
1569     string public notRevealedUri = "ipfs://Qmd37sedV18Xdmjqo4ZybLgzeK9oiVLzQ7UuhA39cmSoqE/";
1570     string public constant baseExtension = ".json";
1571 
1572     mapping(address => uint256) private _mintedFreeAmount; 
1573 
1574     bool public paused = true;
1575     bool public revealed = false;
1576     error freeMintIsOver();
1577 
1578     address devWallet = 0x71e3b5963C0e0aE95C88A0718cABFc765B6494C7;
1579     uint _devFee = 10;
1580 
1581  
1582 
1583     constructor() ERC721A("yeogeol", "YEOGEOL") {}
1584 
1585     function mint(uint256 count) external payable {
1586         uint256 cost = price;
1587         bool isFree = ((totalSupply() + count < freeMintMax + 1) &&
1588             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1589 
1590         if (isFree) {
1591             cost = 0;
1592         }
1593 
1594         require(!paused, "Contract Paused.");
1595         require(msg.value >= count * cost, "Please send the exact amount.");
1596         require(totalSupply() + count < maxSupply + 1, "No more");
1597         require(count < maxPerTx + 1, "Max per TX reached.");
1598 
1599         if (isFree) {
1600             _mintedFreeAmount[msg.sender] += count;
1601         }
1602 
1603         _safeMint(msg.sender, count);
1604     } 
1605 
1606     function teamMint(uint256 _number) external onlyOwner {
1607         require(totalSupply() + _number <= maxSupply, "Minting would exceed maxSupply");
1608         _safeMint(_msgSender(), _number);
1609     }
1610 
1611     function setMaxFreeMint(uint256 _max) public onlyOwner {
1612         freeMintMax = _max;
1613     }
1614 
1615     function setMaxPaidPerTx(uint256 _max) public onlyOwner {
1616         maxPerTx = _max;
1617     }
1618 
1619     function setMaxSupply(uint256 _max) public onlyOwner {
1620         maxSupply = _max;
1621     }
1622 
1623     function setFreeAmount(uint256 amount) external onlyOwner {
1624         freeMintMax = amount;
1625     } 
1626 
1627     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1628         notRevealedUri = _notRevealedURI;
1629     } 
1630 
1631     function reveal() public onlyOwner {
1632         revealed = true;
1633     }  
1634 
1635     function _startTokenId() internal override view virtual returns (uint256) {
1636         return 1;
1637     }
1638 
1639     function minted(address _owner) public view returns (uint256) {
1640         return _numberMinted(_owner);
1641     }
1642 
1643     function _withdraw(address _address, uint256 _amount) private {
1644         (bool success, ) = _address.call{value: _amount}("");
1645         require(success, "Failed to withdraw Ether");
1646     }
1647 
1648     function withdrawAll() public onlyOwner {
1649         uint256 balance = address(this).balance;
1650         require(balance > 0, "Insufficent balance");
1651 
1652         _withdraw(_msgSender(), balance * (100 - devFee) / 100);
1653         _withdraw(devWallet, balance * devFee / 100);
1654     }
1655 
1656     function setPrice(uint256 _price) external onlyOwner {
1657         price = _price;
1658     }
1659 
1660     function setPause(bool _state) external onlyOwner {
1661         paused = _state;
1662     }
1663 
1664     function _baseURI() internal view virtual override returns (string memory) {
1665       return baseURI;
1666     }
1667     
1668     function setBaseURI(string memory baseURI_) external onlyOwner {
1669         baseURI = baseURI_;
1670     }
1671 
1672     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1673     {
1674         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1675 
1676         if(revealed == false) 
1677         {
1678             return notRevealedUri;
1679         }
1680 
1681         string memory _tokenURI = super.tokenURI(tokenId);
1682         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1683     }
1684 }