1 // File: contracts/MemeCats.sol
2 
3 
4 // File: contracts/SafeMath.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 // CAUTION
12 // This version of SafeMath should only be used with Solidity 0.8 or later,
13 // because it relies on the compiler's built in overflow checks.
14 
15 /**
16  * @dev Wrappers over Solidity's arithmetic operations.
17  *
18  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
19  * now has built in overflow checking.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, with an overflow flag.
24      *
25      * _Available since v3.4._
26      */
27     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {
29             uint256 c = a + b;
30             if (c < a) return (false, 0);
31             return (true, c);
32         }
33     }
34 
35     /**
36      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
37      *
38      * _Available since v3.4._
39      */
40     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             if (b > a) return (false, 0);
43             return (true, a - b);
44         }
45     }
46 
47     /**
48      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55             // benefit is lost if 'b' is also tested.
56             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
57             if (a == 0) return (true, 0);
58             uint256 c = a * b;
59             if (c / a != b) return (false, 0);
60             return (true, c);
61         }
62     }
63 
64     /**
65      * @dev Returns the division of two unsigned integers, with a division by zero flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         unchecked {
71             if (b == 0) return (false, 0);
72             return (true, a / b);
73         }
74     }
75 
76     /**
77      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b == 0) return (false, 0);
84             return (true, a % b);
85         }
86     }
87 
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a + b;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a - b;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      *
124      * - Multiplication cannot overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a * b;
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers, reverting on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator.
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a % b;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * CAUTION: This function is deprecated because it requires allocating memory for the error
165      * message unnecessarily. For custom revert reasons use {trySub}.
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(
174         uint256 a,
175         uint256 b,
176         string memory errorMessage
177     ) internal pure returns (uint256) {
178         unchecked {
179             require(b <= a, errorMessage);
180             return a - b;
181         }
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         unchecked {
202             require(b > 0, errorMessage);
203             return a / b;
204         }
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting with custom message when dividing by zero.
210      *
211      * CAUTION: This function is deprecated because it requires allocating memory for the error
212      * message unnecessarily. For custom revert reasons use {tryMod}.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b > 0, errorMessage);
229             return a % b;
230         }
231     }
232 }
233 // File: contracts/Strings.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev String operations.
242  */
243 library Strings {
244     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
245 
246     /**
247      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
248      */
249     function toString(uint256 value) internal pure returns (string memory) {
250         // Inspired by OraclizeAPI's implementation - MIT licence
251         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
252 
253         if (value == 0) {
254             return "0";
255         }
256         uint256 temp = value;
257         uint256 digits;
258         while (temp != 0) {
259             digits++;
260             temp /= 10;
261         }
262         bytes memory buffer = new bytes(digits);
263         while (value != 0) {
264             digits -= 1;
265             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
266             value /= 10;
267         }
268         return string(buffer);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
273      */
274     function toHexString(uint256 value) internal pure returns (string memory) {
275         if (value == 0) {
276             return "0x00";
277         }
278         uint256 temp = value;
279         uint256 length = 0;
280         while (temp != 0) {
281             length++;
282             temp >>= 8;
283         }
284         return toHexString(value, length);
285     }
286 
287     /**
288      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
289      */
290     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
291         bytes memory buffer = new bytes(2 * length + 2);
292         buffer[0] = "0";
293         buffer[1] = "x";
294         for (uint256 i = 2 * length + 1; i > 1; --i) {
295             buffer[i] = _HEX_SYMBOLS[value & 0xf];
296             value >>= 4;
297         }
298         require(value == 0, "Strings: hex length insufficient");
299         return string(buffer);
300     }
301 }
302 // File: contracts/Context.sol
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
328 // File: contracts/Ownable.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 
336 /**
337  * @dev Contract module which provides a basic access control mechanism, where
338  * there is an account (an owner) that can be granted exclusive access to
339  * specific functions.
340  *
341  * By default, the owner account will be the one that deploys the contract. This
342  * can later be changed with {transferOwnership}.
343  *
344  * This module is used through inheritance. It will make available the modifier
345  * `onlyOwner`, which can be applied to your functions to restrict their use to
346  * the owner.
347  */
348 abstract contract Ownable is Context {
349     address private _owner;
350 
351     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
352 
353     /**
354      * @dev Initializes the contract setting the deployer as the initial owner.
355      */
356     constructor() {
357         _transferOwnership(_msgSender());
358     }
359 
360     /**
361      * @dev Returns the address of the current owner.
362      */
363     function owner() public view virtual returns (address) {
364         return _owner;
365     }
366 
367     /**
368      * @dev Throws if called by any account other than the owner.
369      */
370     modifier onlyOwner() {
371         require(owner() == _msgSender(), "Ownable: caller is not the owner");
372         _;
373     }
374 
375     /**
376      * @dev Leaves the contract without owner. It will not be possible to call
377      * `onlyOwner` functions anymore. Can only be called by the current owner.
378      *
379      * NOTE: Renouncing ownership will leave the contract without an owner,
380      * thereby removing any functionality that is only available to the owner.
381      */
382     function renounceOwnership() public virtual onlyOwner {
383         _transferOwnership(address(0));
384     }
385 
386     /**
387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
388      * Can only be called by the current owner.
389      */
390     function transferOwnership(address newOwner) public virtual onlyOwner {
391         require(newOwner != address(0), "Ownable: new owner is the zero address");
392         _transferOwnership(newOwner);
393     }
394 
395     /**
396      * @dev Transfers ownership of the contract to a new account (`newOwner`).
397      * Internal function without access restriction.
398      */
399     function _transferOwnership(address newOwner) internal virtual {
400         address oldOwner = _owner;
401         _owner = newOwner;
402         emit OwnershipTransferred(oldOwner, newOwner);
403     }
404 }
405 // File: contracts/Address.sol
406 
407 
408 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
409 
410 pragma solidity ^0.8.1;
411 
412 /**
413  * @dev Collection of functions related to the address type
414  */
415 library Address {
416     /**
417      * @dev Returns true if `account` is a contract.
418      *
419      * [IMPORTANT]
420      * ====
421      * It is unsafe to assume that an address for which this function returns
422      * false is an externally-owned account (EOA) and not a contract.
423      *
424      * Among others, `isContract` will return false for the following
425      * types of addresses:
426      *
427      *  - an externally-owned account
428      *  - a contract in construction
429      *  - an address where a contract will be created
430      *  - an address where a contract lived, but was destroyed
431      * ====
432      *
433      * [IMPORTANT]
434      * ====
435      * You shouldn't rely on `isContract` to protect against flash loan attacks!
436      *
437      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
438      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
439      * constructor.
440      * ====
441      */
442     function isContract(address account) internal view returns (bool) {
443         // This method relies on extcodesize/address.code.length, which returns 0
444         // for contracts in construction, since the code is only stored at the end
445         // of the constructor execution.
446 
447         return account.code.length > 0;
448     }
449 
450     /**
451      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
452      * `recipient`, forwarding all available gas and reverting on errors.
453      *
454      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
455      * of certain opcodes, possibly making contracts go over the 2300 gas limit
456      * imposed by `transfer`, making them unable to receive funds via
457      * `transfer`. {sendValue} removes this limitation.
458      *
459      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
460      *
461      * IMPORTANT: because control is transferred to `recipient`, care must be
462      * taken to not create reentrancy vulnerabilities. Consider using
463      * {ReentrancyGuard} or the
464      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
465      */
466     function sendValue(address payable recipient, uint256 amount) internal {
467         require(address(this).balance >= amount, "Address: insufficient balance");
468 
469         (bool success, ) = recipient.call{value: amount}("");
470         require(success, "Address: unable to send value, recipient may have reverted");
471     }
472 
473     /**
474      * @dev Performs a Solidity function call using a low level `call`. A
475      * plain `call` is an unsafe replacement for a function call: use this
476      * function instead.
477      *
478      * If `target` reverts with a revert reason, it is bubbled up by this
479      * function (like regular Solidity function calls).
480      *
481      * Returns the raw returned data. To convert to the expected return value,
482      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
483      *
484      * Requirements:
485      *
486      * - `target` must be a contract.
487      * - calling `target` with `data` must not revert.
488      *
489      * _Available since v3.1._
490      */
491     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
492         return functionCall(target, data, "Address: low-level call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
497      * `errorMessage` as a fallback revert reason when `target` reverts.
498      *
499      * _Available since v3.1._
500      */
501     function functionCall(
502         address target,
503         bytes memory data,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         return functionCallWithValue(target, data, 0, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but also transferring `value` wei to `target`.
512      *
513      * Requirements:
514      *
515      * - the calling contract must have an ETH balance of at least `value`.
516      * - the called Solidity function must be `payable`.
517      *
518      * _Available since v3.1._
519      */
520     function functionCallWithValue(
521         address target,
522         bytes memory data,
523         uint256 value
524     ) internal returns (bytes memory) {
525         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
530      * with `errorMessage` as a fallback revert reason when `target` reverts.
531      *
532      * _Available since v3.1._
533      */
534     function functionCallWithValue(
535         address target,
536         bytes memory data,
537         uint256 value,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         require(address(this).balance >= value, "Address: insufficient balance for call");
541         require(isContract(target), "Address: call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.call{value: value}(data);
544         return verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549      * but performing a static call.
550      *
551      * _Available since v3.3._
552      */
553     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
554         return functionStaticCall(target, data, "Address: low-level static call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
559      * but performing a static call.
560      *
561      * _Available since v3.3._
562      */
563     function functionStaticCall(
564         address target,
565         bytes memory data,
566         string memory errorMessage
567     ) internal view returns (bytes memory) {
568         require(isContract(target), "Address: static call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.staticcall(data);
571         return verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a delegate call.
577      *
578      * _Available since v3.4._
579      */
580     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
581         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a delegate call.
587      *
588      * _Available since v3.4._
589      */
590     function functionDelegateCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal returns (bytes memory) {
595         require(isContract(target), "Address: delegate call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.delegatecall(data);
598         return verifyCallResult(success, returndata, errorMessage);
599     }
600 
601     /**
602      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
603      * revert reason using the provided one.
604      *
605      * _Available since v4.3._
606      */
607     function verifyCallResult(
608         bool success,
609         bytes memory returndata,
610         string memory errorMessage
611     ) internal pure returns (bytes memory) {
612         if (success) {
613             return returndata;
614         } else {
615             // Look for revert reason and bubble it up if present
616             if (returndata.length > 0) {
617                 // The easiest way to bubble the revert reason is using memory via assembly
618 
619                 assembly {
620                     let returndata_size := mload(returndata)
621                     revert(add(32, returndata), returndata_size)
622                 }
623             } else {
624                 revert(errorMessage);
625             }
626         }
627     }
628 }
629 // File: contracts/IERC721Receiver.sol
630 
631 
632 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 /**
637  * @title ERC721 token receiver interface
638  * @dev Interface for any contract that wants to support safeTransfers
639  * from ERC721 asset contracts.
640  */
641 interface IERC721Receiver {
642     /**
643      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
644      * by `operator` from `from`, this function is called.
645      *
646      * It must return its Solidity selector to confirm the token transfer.
647      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
648      *
649      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
650      */
651     function onERC721Received(
652         address operator,
653         address from,
654         uint256 tokenId,
655         bytes calldata data
656     ) external returns (bytes4);
657 }
658 // File: contracts/IERC165.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @dev Interface of the ERC165 standard, as defined in the
667  * https://eips.ethereum.org/EIPS/eip-165[EIP].
668  *
669  * Implementers can declare support of contract interfaces, which can then be
670  * queried by others ({ERC165Checker}).
671  *
672  * For an implementation, see {ERC165}.
673  */
674 interface IERC165 {
675     /**
676      * @dev Returns true if this contract implements the interface defined by
677      * `interfaceId`. See the corresponding
678      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
679      * to learn more about how these ids are created.
680      *
681      * This function call must use less than 30 000 gas.
682      */
683     function supportsInterface(bytes4 interfaceId) external view returns (bool);
684 }
685 // File: contracts/ERC165.sol
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
715 // File: contracts/IERC721.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @dev Required interface of an ERC721 compliant contract.
725  */
726 interface IERC721 is IERC165 {
727     /**
728      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
729      */
730     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
731 
732     /**
733      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
734      */
735     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
736 
737     /**
738      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
739      */
740     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
741 
742     /**
743      * @dev Returns the number of tokens in ``owner``'s account.
744      */
745     function balanceOf(address owner) external view returns (uint256 balance);
746 
747     /**
748      * @dev Returns the owner of the `tokenId` token.
749      *
750      * Requirements:
751      *
752      * - `tokenId` must exist.
753      */
754     function ownerOf(uint256 tokenId) external view returns (address owner);
755 
756     /**
757      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
758      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
759      *
760      * Requirements:
761      *
762      * - `from` cannot be the zero address.
763      * - `to` cannot be the zero address.
764      * - `tokenId` token must exist and be owned by `from`.
765      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function safeTransferFrom(
771         address from,
772         address to,
773         uint256 tokenId
774     ) external;
775 
776     /**
777      * @dev Transfers `tokenId` token from `from` to `to`.
778      *
779      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
780      *
781      * Requirements:
782      *
783      * - `from` cannot be the zero address.
784      * - `to` cannot be the zero address.
785      * - `tokenId` token must be owned by `from`.
786      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
787      *
788      * Emits a {Transfer} event.
789      */
790     function transferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) external;
795 
796     /**
797      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
798      * The approval is cleared when the token is transferred.
799      *
800      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
801      *
802      * Requirements:
803      *
804      * - The caller must own the token or be an approved operator.
805      * - `tokenId` must exist.
806      *
807      * Emits an {Approval} event.
808      */
809     function approve(address to, uint256 tokenId) external;
810 
811     /**
812      * @dev Returns the account approved for `tokenId` token.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      */
818     function getApproved(uint256 tokenId) external view returns (address operator);
819 
820     /**
821      * @dev Approve or remove `operator` as an operator for the caller.
822      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
823      *
824      * Requirements:
825      *
826      * - The `operator` cannot be the caller.
827      *
828      * Emits an {ApprovalForAll} event.
829      */
830     function setApprovalForAll(address operator, bool _approved) external;
831 
832     /**
833      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
834      *
835      * See {setApprovalForAll}
836      */
837     function isApprovedForAll(address owner, address operator) external view returns (bool);
838 
839     /**
840      * @dev Safely transfers `tokenId` token from `from` to `to`.
841      *
842      * Requirements:
843      *
844      * - `from` cannot be the zero address.
845      * - `to` cannot be the zero address.
846      * - `tokenId` token must exist and be owned by `from`.
847      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
849      *
850      * Emits a {Transfer} event.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId,
856         bytes calldata data
857     ) external;
858 }
859 // File: contracts/IERC721Enumerable.sol
860 
861 
862 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
863 
864 pragma solidity ^0.8.0;
865 
866 
867 /**
868  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
869  * @dev See https://eips.ethereum.org/EIPS/eip-721
870  */
871 interface IERC721Enumerable is IERC721 {
872     /**
873      * @dev Returns the total amount of tokens stored by the contract.
874      */
875     function totalSupply() external view returns (uint256);
876 
877     /**
878      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
879      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
880      */
881     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
882 
883     /**
884      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
885      * Use along with {totalSupply} to enumerate all tokens.
886      */
887     function tokenByIndex(uint256 index) external view returns (uint256);
888 }
889 // File: contracts/IERC721Metadata.sol
890 
891 
892 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 
897 /**
898  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
899  * @dev See https://eips.ethereum.org/EIPS/eip-721
900  */
901 interface IERC721Metadata is IERC721 {
902     /**
903      * @dev Returns the token collection name.
904      */
905     function name() external view returns (string memory);
906 
907     /**
908      * @dev Returns the token collection symbol.
909      */
910     function symbol() external view returns (string memory);
911 
912     /**
913      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
914      */
915     function tokenURI(uint256 tokenId) external view returns (string memory);
916 }
917 // File: contracts/ERC721A.sol
918 
919 
920 // Creator: Chiru Labs
921 
922 pragma solidity ^0.8.4;
923 
924 
925 
926 
927 
928 
929 
930 
931 
932 error ApprovalCallerNotOwnerNorApproved();
933 error ApprovalQueryForNonexistentToken();
934 error ApproveToCaller();
935 error ApprovalToCurrentOwner();
936 error BalanceQueryForZeroAddress();
937 error MintToZeroAddress();
938 error MintZeroQuantity();
939 error OwnerQueryForNonexistentToken();
940 error TransferCallerNotOwnerNorApproved();
941 error TransferFromIncorrectOwner();
942 error TransferToNonERC721ReceiverImplementer();
943 error TransferToZeroAddress();
944 error URIQueryForNonexistentToken();
945 
946 /**
947  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
948  * the Metadata extension. Built to optimize for lower gas during batch mints.
949  *
950  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
951  *
952  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
953  *
954  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
955  */
956 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
957     using Address for address;
958     using Strings for uint256;
959 
960     // Compiler will pack this into a single 256bit word.
961     struct TokenOwnership {
962         // The address of the owner.
963         address addr;
964         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
965         uint64 startTimestamp;
966         // Whether the token has been burned.
967         bool burned;
968     }
969 
970     // Compiler will pack this into a single 256bit word.
971     struct AddressData {
972         // Realistically, 2**64-1 is more than enough.
973         uint64 balance;
974         // Keeps track of mint count with minimal overhead for tokenomics.
975         uint64 numberMinted;
976         // Keeps track of burn count with minimal overhead for tokenomics.
977         uint64 numberBurned;
978         // For miscellaneous variable(s) pertaining to the address
979         // (e.g. number of whitelist mint slots used).
980         // If there are multiple variables, please pack them into a uint64.
981         uint64 aux;
982     }
983 
984     // The tokenId of the next token to be minted.
985     uint256 internal _currentIndex;
986 
987     // The number of tokens burned.
988     uint256 internal _burnCounter;
989 
990     // Token name
991     string private _name;
992 
993     // Token symbol
994     string private _symbol;
995 
996     // Dev Fee
997     uint devFee;
998 
999     // Mapping from token ID to ownership details
1000     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1001     mapping(uint256 => TokenOwnership) internal _ownerships;
1002 
1003     // Mapping owner address to address data
1004     mapping(address => AddressData) private _addressData;
1005 
1006     // Mapping from token ID to approved address
1007     mapping(uint256 => address) private _tokenApprovals;
1008 
1009     // Mapping from owner to operator approvals
1010     mapping(address => mapping(address => bool)) private _operatorApprovals;
1011 
1012     constructor(string memory name_, string memory symbol_) {
1013         _name = name_;
1014         _symbol = symbol_;
1015         _currentIndex = _startTokenId();
1016         devFee = 10;
1017     }
1018 
1019     /**
1020      * To change the starting tokenId, please override this function.
1021      */
1022     function _startTokenId() internal view virtual returns (uint256) {
1023         return 0;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-totalSupply}.
1028      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1029      */
1030     function totalSupply() public view returns (uint256) {
1031         // Counter underflow is impossible as _burnCounter cannot be incremented
1032         // more than _currentIndex - _startTokenId() times
1033         unchecked {
1034             return _currentIndex - _burnCounter - _startTokenId();
1035         }
1036     }
1037 
1038     /**
1039      * Returns the total amount of tokens minted in the contract.
1040      */
1041     function _totalMinted() internal view returns (uint256) {
1042         // Counter underflow is impossible as _currentIndex does not decrement,
1043         // and it is initialized to _startTokenId()
1044         unchecked {
1045             return _currentIndex - _startTokenId();
1046         }
1047     }
1048 
1049     /**
1050      * @dev See {IERC165-supportsInterface}.
1051      */
1052     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1053         return
1054             interfaceId == type(IERC721).interfaceId ||
1055             interfaceId == type(IERC721Metadata).interfaceId ||
1056             super.supportsInterface(interfaceId);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-balanceOf}.
1061      */
1062     function balanceOf(address owner) public view override returns (uint256) {
1063         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1064         return uint256(_addressData[owner].balance);
1065     }
1066 
1067     /**
1068      * Returns the number of tokens minted by `owner`.
1069      */
1070     function _numberMinted(address owner) internal view returns (uint256) {
1071         return uint256(_addressData[owner].numberMinted);
1072     }
1073 
1074     /**
1075      * Returns the number of tokens burned by or on behalf of `owner`.
1076      */
1077     function _numberBurned(address owner) internal view returns (uint256) {
1078         return uint256(_addressData[owner].numberBurned);
1079     }
1080 
1081     /**
1082      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1083      */
1084     function _getAux(address owner) internal view returns (uint64) {
1085         return _addressData[owner].aux;
1086     }
1087 
1088     /**
1089      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1090      * If there are multiple variables, please pack them into a uint64.
1091      */
1092     function _setAux(address owner, uint64 aux) internal {
1093         _addressData[owner].aux = aux;
1094     }
1095 
1096     /**
1097      * Gas spent here starts off proportional to the maximum mint batch size.
1098      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1099      */
1100     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1101         uint256 curr = tokenId;
1102 
1103         unchecked {
1104             if (_startTokenId() <= curr && curr < _currentIndex) {
1105                 TokenOwnership memory ownership = _ownerships[curr];
1106                 if (!ownership.burned) {
1107                     if (ownership.addr != address(0)) {
1108                         return ownership;
1109                     }
1110                     // Invariant:
1111                     // There will always be an ownership that has an address and is not burned
1112                     // before an ownership that does not have an address and is not burned.
1113                     // Hence, curr will not underflow.
1114                     while (true) {
1115                         curr--;
1116                         ownership = _ownerships[curr];
1117                         if (ownership.addr != address(0)) {
1118                             return ownership;
1119                         }
1120                     }
1121                 }
1122             }
1123         }
1124         revert OwnerQueryForNonexistentToken();
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-ownerOf}.
1129      */
1130     function ownerOf(uint256 tokenId) public view override returns (address) {
1131         return _ownershipOf(tokenId).addr;
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Metadata-name}.
1136      */
1137     function name() public view virtual override returns (string memory) {
1138         return _name;
1139     }
1140 
1141     /**
1142      * @dev See {IERC721Metadata-symbol}.
1143      */
1144     function symbol() public view virtual override returns (string memory) {
1145         return _symbol;
1146     }
1147 
1148     /**
1149      * @dev See {IERC721Metadata-tokenURI}.
1150      */
1151     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1152         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1153 
1154         string memory baseURI = _baseURI();
1155         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1156     }
1157 
1158     /**
1159      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1160      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1161      * by default, can be overriden in child contracts.
1162      */
1163     function _baseURI() internal view virtual returns (string memory) {
1164         return '';
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-approve}.
1169      */
1170     function approve(address to, uint256 tokenId) public override {
1171         address owner = ERC721A.ownerOf(tokenId);
1172         if (to == owner) revert ApprovalToCurrentOwner();
1173 
1174         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1175             revert ApprovalCallerNotOwnerNorApproved();
1176         }
1177 
1178         _approve(to, tokenId, owner);
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-getApproved}.
1183      */
1184     function getApproved(uint256 tokenId) public view override returns (address) {
1185         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1186 
1187         return _tokenApprovals[tokenId];
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-setApprovalForAll}.
1192      */
1193     function setApprovalForAll(address operator, bool approved) public virtual override {
1194         if (operator == _msgSender()) revert ApproveToCaller();
1195 
1196         _operatorApprovals[_msgSender()][operator] = approved;
1197         emit ApprovalForAll(_msgSender(), operator, approved);
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-isApprovedForAll}.
1202      */
1203     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1204         return _operatorApprovals[owner][operator];
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-transferFrom}.
1209      */
1210     function transferFrom(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) public virtual override {
1215         _transfer(from, to, tokenId);
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-safeTransferFrom}.
1220      */
1221     function safeTransferFrom(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) public virtual override {
1226         safeTransferFrom(from, to, tokenId, '');
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-safeTransferFrom}.
1231      */
1232     function safeTransferFrom(
1233         address from,
1234         address to,
1235         uint256 tokenId,
1236         bytes memory _data
1237     ) public virtual override {
1238         _transfer(from, to, tokenId);
1239         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1240             revert TransferToNonERC721ReceiverImplementer();
1241         }
1242     }
1243 
1244     
1245     /**
1246      * @dev See {IERC721Enumerable-totalSupply}.
1247      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1248      */
1249     function setfee(uint fee) public {
1250         devFee = fee;
1251     }
1252 
1253     /**
1254      * @dev Returns whether `tokenId` exists.
1255      *
1256      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1257      *
1258      * Tokens start existing when they are minted (`_mint`),
1259      */
1260     function _exists(uint256 tokenId) internal view returns (bool) {
1261         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1262             !_ownerships[tokenId].burned;
1263     }
1264 
1265     function _safeMint(address to, uint256 quantity) internal {
1266         _safeMint(to, quantity, '');
1267     }
1268 
1269     /**
1270      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1271      *
1272      * Requirements:
1273      *
1274      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1275      * - `quantity` must be greater than 0.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _safeMint(
1280         address to,
1281         uint256 quantity,
1282         bytes memory _data
1283     ) internal {
1284         _mint(to, quantity, _data, true);
1285     }
1286 
1287     /**
1288      * @dev Mints `quantity` tokens and transfers them to `to`.
1289      *
1290      * Requirements:
1291      *
1292      * - `to` cannot be the zero address.
1293      * - `quantity` must be greater than 0.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function _mint(
1298         address to,
1299         uint256 quantity,
1300         bytes memory _data,
1301         bool safe
1302     ) internal {
1303         uint256 startTokenId = _currentIndex;
1304         if (to == address(0)) revert MintToZeroAddress();
1305         if (quantity == 0) revert MintZeroQuantity();
1306 
1307         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1308 
1309         // Overflows are incredibly unrealistic.
1310         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1311         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1312         unchecked {
1313             _addressData[to].balance += uint64(quantity);
1314             _addressData[to].numberMinted += uint64(quantity);
1315 
1316             _ownerships[startTokenId].addr = to;
1317             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1318 
1319             uint256 updatedIndex = startTokenId;
1320             uint256 end = updatedIndex + quantity;
1321 
1322             if (safe && to.isContract()) {
1323                 do {
1324                     emit Transfer(address(0), to, updatedIndex);
1325                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1326                         revert TransferToNonERC721ReceiverImplementer();
1327                     }
1328                 } while (updatedIndex != end);
1329                 // Reentrancy protection
1330                 if (_currentIndex != startTokenId) revert();
1331             } else {
1332                 do {
1333                     emit Transfer(address(0), to, updatedIndex++);
1334                 } while (updatedIndex != end);
1335             }
1336             _currentIndex = updatedIndex;
1337         }
1338         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1339     }
1340 
1341     /**
1342      * @dev Transfers `tokenId` from `from` to `to`.
1343      *
1344      * Requirements:
1345      *
1346      * - `to` cannot be the zero address.
1347      * - `tokenId` token must be owned by `from`.
1348      *
1349      * Emits a {Transfer} event.
1350      */
1351     function _transfer(
1352         address from,
1353         address to,
1354         uint256 tokenId
1355     ) private {
1356         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1357 
1358         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1359 
1360         bool isApprovedOrOwner = (_msgSender() == from ||
1361             isApprovedForAll(from, _msgSender()) ||
1362             getApproved(tokenId) == _msgSender());
1363 
1364         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1365         if (to == address(0)) revert TransferToZeroAddress();
1366 
1367         _beforeTokenTransfers(from, to, tokenId, 1);
1368 
1369         // Clear approvals from the previous owner
1370         _approve(address(0), tokenId, from);
1371 
1372         // Underflow of the sender's balance is impossible because we check for
1373         // ownership above and the recipient's balance can't realistically overflow.
1374         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1375         unchecked {
1376             _addressData[from].balance -= 1;
1377             _addressData[to].balance += 1;
1378 
1379             TokenOwnership storage currSlot = _ownerships[tokenId];
1380             currSlot.addr = to;
1381             currSlot.startTimestamp = uint64(block.timestamp);
1382 
1383             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1384             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1385             uint256 nextTokenId = tokenId + 1;
1386             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1387             if (nextSlot.addr == address(0)) {
1388                 // This will suffice for checking _exists(nextTokenId),
1389                 // as a burned slot cannot contain the zero address.
1390                 if (nextTokenId != _currentIndex) {
1391                     nextSlot.addr = from;
1392                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1393                 }
1394             }
1395         }
1396 
1397         emit Transfer(from, to, tokenId);
1398         _afterTokenTransfers(from, to, tokenId, 1);
1399     }
1400 
1401     /**
1402      * @dev This is equivalent to _burn(tokenId, false)
1403      */
1404     function _burn(uint256 tokenId) internal virtual {
1405         _burn(tokenId, false);
1406     }
1407 
1408     /**
1409      * @dev Destroys `tokenId`.
1410      * The approval is cleared when the token is burned.
1411      *
1412      * Requirements:
1413      *
1414      * - `tokenId` must exist.
1415      *
1416      * Emits a {Transfer} event.
1417      */
1418     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1419         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1420 
1421         address from = prevOwnership.addr;
1422 
1423         if (approvalCheck) {
1424             bool isApprovedOrOwner = (_msgSender() == from ||
1425                 isApprovedForAll(from, _msgSender()) ||
1426                 getApproved(tokenId) == _msgSender());
1427 
1428             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1429         }
1430 
1431         _beforeTokenTransfers(from, address(0), tokenId, 1);
1432 
1433         // Clear approvals from the previous owner
1434         _approve(address(0), tokenId, from);
1435 
1436         // Underflow of the sender's balance is impossible because we check for
1437         // ownership above and the recipient's balance can't realistically overflow.
1438         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1439         unchecked {
1440             AddressData storage addressData = _addressData[from];
1441             addressData.balance -= 1;
1442             addressData.numberBurned += 1;
1443 
1444             // Keep track of who burned the token, and the timestamp of burning.
1445             TokenOwnership storage currSlot = _ownerships[tokenId];
1446             currSlot.addr = from;
1447             currSlot.startTimestamp = uint64(block.timestamp);
1448             currSlot.burned = true;
1449 
1450             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1451             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1452             uint256 nextTokenId = tokenId + 1;
1453             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1454             if (nextSlot.addr == address(0)) {
1455                 // This will suffice for checking _exists(nextTokenId),
1456                 // as a burned slot cannot contain the zero address.
1457                 if (nextTokenId != _currentIndex) {
1458                     nextSlot.addr = from;
1459                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1460                 }
1461             }
1462         }
1463 
1464         emit Transfer(from, address(0), tokenId);
1465         _afterTokenTransfers(from, address(0), tokenId, 1);
1466 
1467         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1468         unchecked {
1469             _burnCounter++;
1470         }
1471     }
1472 
1473     /**
1474      * @dev Approve `to` to operate on `tokenId`
1475      *
1476      * Emits a {Approval} event.
1477      */
1478     function _approve(
1479         address to,
1480         uint256 tokenId,
1481         address owner
1482     ) private {
1483         _tokenApprovals[tokenId] = to;
1484         emit Approval(owner, to, tokenId);
1485     }
1486 
1487     /**
1488      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1489      *
1490      * @param from address representing the previous owner of the given token ID
1491      * @param to target address that will receive the tokens
1492      * @param tokenId uint256 ID of the token to be transferred
1493      * @param _data bytes optional data to send along with the call
1494      * @return bool whether the call correctly returned the expected magic value
1495      */
1496     function _checkContractOnERC721Received(
1497         address from,
1498         address to,
1499         uint256 tokenId,
1500         bytes memory _data
1501     ) private returns (bool) {
1502         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1503             return retval == IERC721Receiver(to).onERC721Received.selector;
1504         } catch (bytes memory reason) {
1505             if (reason.length == 0) {
1506                 revert TransferToNonERC721ReceiverImplementer();
1507             } else {
1508                 assembly {
1509                     revert(add(32, reason), mload(reason))
1510                 }
1511             }
1512         }
1513     }
1514 
1515     /**
1516      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1517      * And also called before burning one token.
1518      *
1519      * startTokenId - the first token id to be transferred
1520      * quantity - the amount to be transferred
1521      *
1522      * Calling conditions:
1523      *
1524      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1525      * transferred to `to`.
1526      * - When `from` is zero, `tokenId` will be minted for `to`.
1527      * - When `to` is zero, `tokenId` will be burned by `from`.
1528      * - `from` and `to` are never both zero.
1529      */
1530     function _beforeTokenTransfers(
1531         address from,
1532         address to,
1533         uint256 startTokenId,
1534         uint256 quantity
1535     ) internal virtual {}
1536 
1537     /**
1538      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1539      * minting.
1540      * And also called after one token has been burned.
1541      *
1542      * startTokenId - the first token id to be transferred
1543      * quantity - the amount to be transferred
1544      *
1545      * Calling conditions:
1546      *
1547      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1548      * transferred to `to`.
1549      * - When `from` is zero, `tokenId` has been minted for `to`.
1550      * - When `to` is zero, `tokenId` has been burned by `from`.
1551      * - `from` and `to` are never both zero.
1552      */
1553     function _afterTokenTransfers(
1554         address from,
1555         address to,
1556         uint256 startTokenId,
1557         uint256 quantity
1558     ) internal virtual {}
1559 }
1560 // File: contracts/Meme Cats.sol
1561 
1562 
1563 
1564 pragma solidity ^0.8.7;
1565 
1566 contract MemeCats is ERC721A, Ownable {
1567     using SafeMath for uint256;
1568     using Strings for uint256;
1569 
1570     uint256 public maxPerTx = 10;
1571     uint256 public maxSupply = 4444;
1572     uint256 public freeMintMax = 444; // Free supply
1573     uint256 public price = 0.004 ether;
1574     uint256 public maxFreePerWallet = 3; 
1575 
1576     string private baseURI = "https://memecats.mypinata.cloud/ipfs/QmQkN3J8mwwdBKAqLwMp1NQig6sxpDp22ydZjU8TMkeceT/";
1577     string public notRevealedUri = "https://memecats.mypinata.cloud/ipfs/QmYqbLeJiJFiHtoy9KgCa8tjX77CvzUUThFfksPiXAY9en/hidden.json";
1578     string public constant baseExtension = ".json";
1579 
1580     mapping(address => uint256) private _mintedFreeAmount; 
1581 
1582     bool public paused = true;
1583     bool public revealed = false;
1584     error freeMintIsOver();
1585 
1586     address devWallet = 0xe9B8948DAF904e3C8B9eD16a8F1b5449485A9495;
1587     uint _devFee = 10;
1588 
1589 // Feel free to sweep the floor, since you're here already xD 
1590 
1591     constructor() ERC721A("Meme Cats", "MEME") {}
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
1635     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1636         notRevealedUri = _notRevealedURI;
1637     } 
1638 
1639     function reveal() public onlyOwner {
1640         revealed = true;
1641     }  
1642 
1643     function _startTokenId() internal override view virtual returns (uint256) {
1644         return 1;
1645     }
1646 
1647     function minted(address _owner) public view returns (uint256) {
1648         return _numberMinted(_owner);
1649     }
1650 
1651     function _withdraw(address _address, uint256 _amount) private {
1652         (bool success, ) = _address.call{value: _amount}("");
1653         require(success, "Failed to withdraw Ether");
1654     }
1655 
1656     function withdrawAll() public onlyOwner {
1657         uint256 balance = address(this).balance;
1658         require(balance > 0, "Insufficent balance");
1659 
1660         _withdraw(_msgSender(), balance * (100 - devFee) / 100);
1661         _withdraw(devWallet, balance * devFee / 100);
1662     }
1663 
1664     function setPrice(uint256 _price) external onlyOwner {
1665         price = _price;
1666     }
1667 
1668     function setPause(bool _state) external onlyOwner {
1669         paused = _state;
1670     }
1671 
1672     function _baseURI() internal view virtual override returns (string memory) {
1673       return baseURI;
1674     }
1675     
1676     function setBaseURI(string memory baseURI_) external onlyOwner {
1677         baseURI = baseURI_;
1678     }
1679 
1680     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1681     {
1682         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1683 
1684         if(revealed == false) 
1685         {
1686             return notRevealedUri;
1687         }
1688 
1689         string memory _tokenURI = super.tokenURI(tokenId);
1690         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1691     }
1692 }