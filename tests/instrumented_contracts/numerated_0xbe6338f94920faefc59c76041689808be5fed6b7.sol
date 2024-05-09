1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Strings.sol
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
300 
301 // File: @openzeppelin/contracts/utils/Context.sol
302 
303 
304 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 /**
309  * @dev Provides information about the current execution context, including the
310  * sender of the transaction and its data. While these are generally available
311  * via msg.sender and msg.data, they should not be accessed in such a direct
312  * manner, since when dealing with meta-transactions the account sending and
313  * paying for execution may not be the actual sender (as far as an application
314  * is concerned).
315  *
316  * This contract is only required for intermediate, library-like contracts.
317  */
318 abstract contract Context {
319     function _msgSender() internal view virtual returns (address) {
320         return msg.sender;
321     }
322 
323     function _msgData() internal view virtual returns (bytes calldata) {
324         return msg.data;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/access/Ownable.sol
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
405 
406 // File: @openzeppelin/contracts/utils/Address.sol
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
630 
631 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
632 
633 
634 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @title ERC721 token receiver interface
640  * @dev Interface for any contract that wants to support safeTransfers
641  * from ERC721 asset contracts.
642  */
643 interface IERC721Receiver {
644     /**
645      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
646      * by `operator` from `from`, this function is called.
647      *
648      * It must return its Solidity selector to confirm the token transfer.
649      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
650      *
651      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
652      */
653     function onERC721Received(
654         address operator,
655         address from,
656         uint256 tokenId,
657         bytes calldata data
658     ) external returns (bytes4);
659 }
660 
661 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @dev Interface of the ERC165 standard, as defined in the
670  * https://eips.ethereum.org/EIPS/eip-165[EIP].
671  *
672  * Implementers can declare support of contract interfaces, which can then be
673  * queried by others ({ERC165Checker}).
674  *
675  * For an implementation, see {ERC165}.
676  */
677 interface IERC165 {
678     /**
679      * @dev Returns true if this contract implements the interface defined by
680      * `interfaceId`. See the corresponding
681      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
682      * to learn more about how these ids are created.
683      *
684      * This function call must use less than 30 000 gas.
685      */
686     function supportsInterface(bytes4 interfaceId) external view returns (bool);
687 }
688 
689 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @dev Implementation of the {IERC165} interface.
699  *
700  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
701  * for the additional interface id that will be supported. For example:
702  *
703  * ```solidity
704  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
705  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
706  * }
707  * ```
708  *
709  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
710  */
711 abstract contract ERC165 is IERC165 {
712     /**
713      * @dev See {IERC165-supportsInterface}.
714      */
715     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
716         return interfaceId == type(IERC165).interfaceId;
717     }
718 }
719 
720 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
721 
722 
723 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 
728 /**
729  * @dev Required interface of an ERC721 compliant contract.
730  */
731 interface IERC721 is IERC165 {
732     /**
733      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
734      */
735     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
736 
737     /**
738      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
739      */
740     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
741 
742     /**
743      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
744      */
745     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
746 
747     /**
748      * @dev Returns the number of tokens in ``owner``'s account.
749      */
750     function balanceOf(address owner) external view returns (uint256 balance);
751 
752     /**
753      * @dev Returns the owner of the `tokenId` token.
754      *
755      * Requirements:
756      *
757      * - `tokenId` must exist.
758      */
759     function ownerOf(uint256 tokenId) external view returns (address owner);
760 
761     /**
762      * @dev Safely transfers `tokenId` token from `from` to `to`.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `tokenId` token must exist and be owned by `from`.
769      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes calldata data
779     ) external;
780 
781     /**
782      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
783      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) external;
800 
801     /**
802      * @dev Transfers `tokenId` token from `from` to `to`.
803      *
804      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must be owned by `from`.
811      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
812      *
813      * Emits a {Transfer} event.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external;
820 
821     /**
822      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
823      * The approval is cleared when the token is transferred.
824      *
825      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
826      *
827      * Requirements:
828      *
829      * - The caller must own the token or be an approved operator.
830      * - `tokenId` must exist.
831      *
832      * Emits an {Approval} event.
833      */
834     function approve(address to, uint256 tokenId) external;
835 
836     /**
837      * @dev Approve or remove `operator` as an operator for the caller.
838      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
839      *
840      * Requirements:
841      *
842      * - The `operator` cannot be the caller.
843      *
844      * Emits an {ApprovalForAll} event.
845      */
846     function setApprovalForAll(address operator, bool _approved) external;
847 
848     /**
849      * @dev Returns the account approved for `tokenId` token.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function getApproved(uint256 tokenId) external view returns (address operator);
856 
857     /**
858      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
859      *
860      * See {setApprovalForAll}
861      */
862     function isApprovedForAll(address owner, address operator) external view returns (bool);
863 }
864 
865 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
866 
867 
868 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 
873 /**
874  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
875  * @dev See https://eips.ethereum.org/EIPS/eip-721
876  */
877 interface IERC721Enumerable is IERC721 {
878     /**
879      * @dev Returns the total amount of tokens stored by the contract.
880      */
881     function totalSupply() external view returns (uint256);
882 
883     /**
884      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
885      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
886      */
887     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
888 
889     /**
890      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
891      * Use along with {totalSupply} to enumerate all tokens.
892      */
893     function tokenByIndex(uint256 index) external view returns (uint256);
894 }
895 
896 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
897 
898 
899 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
900 
901 pragma solidity ^0.8.0;
902 
903 
904 /**
905  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
906  * @dev See https://eips.ethereum.org/EIPS/eip-721
907  */
908 interface IERC721Metadata is IERC721 {
909     /**
910      * @dev Returns the token collection name.
911      */
912     function name() external view returns (string memory);
913 
914     /**
915      * @dev Returns the token collection symbol.
916      */
917     function symbol() external view returns (string memory);
918 
919     /**
920      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
921      */
922     function tokenURI(uint256 tokenId) external view returns (string memory);
923 }
924 
925 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
926 
927 
928 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
929 
930 pragma solidity ^0.8.0;
931 
932 
933 
934 
935 
936 
937 
938 
939 /**
940  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
941  * the Metadata extension, but not including the Enumerable extension, which is available separately as
942  * {ERC721Enumerable}.
943  */
944 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
945     using Address for address;
946     using Strings for uint256;
947 
948     // Token name
949     string private _name;
950 
951     // Token symbol
952     string private _symbol;
953 
954     // Mapping from token ID to owner address
955     mapping(uint256 => address) private _owners;
956 
957     // Mapping owner address to token count
958     mapping(address => uint256) private _balances;
959 
960     // Mapping from token ID to approved address
961     mapping(uint256 => address) private _tokenApprovals;
962 
963     // Mapping from owner to operator approvals
964     mapping(address => mapping(address => bool)) private _operatorApprovals;
965 
966     /**
967      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
968      */
969     constructor(string memory name_, string memory symbol_) {
970         _name = name_;
971         _symbol = symbol_;
972     }
973 
974     /**
975      * @dev See {IERC165-supportsInterface}.
976      */
977     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
978         return
979             interfaceId == type(IERC721).interfaceId ||
980             interfaceId == type(IERC721Metadata).interfaceId ||
981             super.supportsInterface(interfaceId);
982     }
983 
984     /**
985      * @dev See {IERC721-balanceOf}.
986      */
987     function balanceOf(address owner) public view virtual override returns (uint256) {
988         require(owner != address(0), "ERC721: balance query for the zero address");
989         return _balances[owner];
990     }
991 
992     /**
993      * @dev See {IERC721-ownerOf}.
994      */
995     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
996         address owner = _owners[tokenId];
997         require(owner != address(0), "ERC721: owner query for nonexistent token");
998         return owner;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-name}.
1003      */
1004     function name() public view virtual override returns (string memory) {
1005         return _name;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Metadata-symbol}.
1010      */
1011     function symbol() public view virtual override returns (string memory) {
1012         return _symbol;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-tokenURI}.
1017      */
1018     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1019         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1020 
1021         string memory baseURI = _baseURI();
1022         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1023     }
1024 
1025     /**
1026      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1027      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1028      * by default, can be overridden in child contracts.
1029      */
1030     function _baseURI() internal view virtual returns (string memory) {
1031         return "";
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-approve}.
1036      */
1037     function approve(address to, uint256 tokenId) public virtual override {
1038         address owner = ERC721.ownerOf(tokenId);
1039         require(to != owner, "ERC721: approval to current owner");
1040 
1041         require(
1042             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1043             "ERC721: approve caller is not owner nor approved for all"
1044         );
1045 
1046         _approve(to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-getApproved}.
1051      */
1052     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1053         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1054 
1055         return _tokenApprovals[tokenId];
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-setApprovalForAll}.
1060      */
1061     function setApprovalForAll(address operator, bool approved) public virtual override {
1062         _setApprovalForAll(_msgSender(), operator, approved);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-isApprovedForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         //solhint-disable-next-line max-line-length
1081         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1082 
1083         _transfer(from, to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-safeTransferFrom}.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) public virtual override {
1094         safeTransferFrom(from, to, tokenId, "");
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-safeTransferFrom}.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) public virtual override {
1106         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1107         _safeTransfer(from, to, tokenId, _data);
1108     }
1109 
1110     /**
1111      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1112      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1113      *
1114      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1115      *
1116      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1117      * implement alternative mechanisms to perform token transfer, such as signature-based.
1118      *
1119      * Requirements:
1120      *
1121      * - `from` cannot be the zero address.
1122      * - `to` cannot be the zero address.
1123      * - `tokenId` token must exist and be owned by `from`.
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _safeTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) internal virtual {
1134         _transfer(from, to, tokenId);
1135         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1136     }
1137 
1138     /**
1139      * @dev Returns whether `tokenId` exists.
1140      *
1141      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1142      *
1143      * Tokens start existing when they are minted (`_mint`),
1144      * and stop existing when they are burned (`_burn`).
1145      */
1146     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1147         return _owners[tokenId] != address(0);
1148     }
1149 
1150     /**
1151      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      */
1157     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1158         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1159         address owner = ERC721.ownerOf(tokenId);
1160         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1161     }
1162 
1163     /**
1164      * @dev Safely mints `tokenId` and transfers it to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must not exist.
1169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _safeMint(address to, uint256 tokenId) internal virtual {
1174         _safeMint(to, tokenId, "");
1175     }
1176 
1177     /**
1178      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1179      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1180      */
1181     function _safeMint(
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) internal virtual {
1186         _mint(to, tokenId);
1187         require(
1188             _checkOnERC721Received(address(0), to, tokenId, _data),
1189             "ERC721: transfer to non ERC721Receiver implementer"
1190         );
1191     }
1192 
1193     /**
1194      * @dev Mints `tokenId` and transfers it to `to`.
1195      *
1196      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must not exist.
1201      * - `to` cannot be the zero address.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _mint(address to, uint256 tokenId) internal virtual {
1206         require(to != address(0), "ERC721: mint to the zero address");
1207         require(!_exists(tokenId), "ERC721: token already minted");
1208 
1209         _beforeTokenTransfer(address(0), to, tokenId);
1210 
1211         _balances[to] += 1;
1212         _owners[tokenId] = to;
1213 
1214         emit Transfer(address(0), to, tokenId);
1215 
1216         _afterTokenTransfer(address(0), to, tokenId);
1217     }
1218 
1219     /**
1220      * @dev Destroys `tokenId`.
1221      * The approval is cleared when the token is burned.
1222      *
1223      * Requirements:
1224      *
1225      * - `tokenId` must exist.
1226      *
1227      * Emits a {Transfer} event.
1228      */
1229     function _burn(uint256 tokenId) internal virtual {
1230         address owner = ERC721.ownerOf(tokenId);
1231 
1232         _beforeTokenTransfer(owner, address(0), tokenId);
1233 
1234         // Clear approvals
1235         _approve(address(0), tokenId);
1236 
1237         _balances[owner] -= 1;
1238         delete _owners[tokenId];
1239 
1240         emit Transfer(owner, address(0), tokenId);
1241 
1242         _afterTokenTransfer(owner, address(0), tokenId);
1243     }
1244 
1245     /**
1246      * @dev Transfers `tokenId` from `from` to `to`.
1247      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1248      *
1249      * Requirements:
1250      *
1251      * - `to` cannot be the zero address.
1252      * - `tokenId` token must be owned by `from`.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _transfer(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) internal virtual {
1261         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1262         require(to != address(0), "ERC721: transfer to the zero address");
1263 
1264         _beforeTokenTransfer(from, to, tokenId);
1265 
1266         // Clear approvals from the previous owner
1267         _approve(address(0), tokenId);
1268 
1269         _balances[from] -= 1;
1270         _balances[to] += 1;
1271         _owners[tokenId] = to;
1272 
1273         emit Transfer(from, to, tokenId);
1274 
1275         _afterTokenTransfer(from, to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Approve `to` to operate on `tokenId`
1280      *
1281      * Emits a {Approval} event.
1282      */
1283     function _approve(address to, uint256 tokenId) internal virtual {
1284         _tokenApprovals[tokenId] = to;
1285         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev Approve `operator` to operate on all of `owner` tokens
1290      *
1291      * Emits a {ApprovalForAll} event.
1292      */
1293     function _setApprovalForAll(
1294         address owner,
1295         address operator,
1296         bool approved
1297     ) internal virtual {
1298         require(owner != operator, "ERC721: approve to caller");
1299         _operatorApprovals[owner][operator] = approved;
1300         emit ApprovalForAll(owner, operator, approved);
1301     }
1302 
1303     /**
1304      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1305      * The call is not executed if the target address is not a contract.
1306      *
1307      * @param from address representing the previous owner of the given token ID
1308      * @param to target address that will receive the tokens
1309      * @param tokenId uint256 ID of the token to be transferred
1310      * @param _data bytes optional data to send along with the call
1311      * @return bool whether the call correctly returned the expected magic value
1312      */
1313     function _checkOnERC721Received(
1314         address from,
1315         address to,
1316         uint256 tokenId,
1317         bytes memory _data
1318     ) private returns (bool) {
1319         if (to.isContract()) {
1320             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1321                 return retval == IERC721Receiver.onERC721Received.selector;
1322             } catch (bytes memory reason) {
1323                 if (reason.length == 0) {
1324                     revert("ERC721: transfer to non ERC721Receiver implementer");
1325                 } else {
1326                     assembly {
1327                         revert(add(32, reason), mload(reason))
1328                     }
1329                 }
1330             }
1331         } else {
1332             return true;
1333         }
1334     }
1335 
1336     /**
1337      * @dev Hook that is called before any token transfer. This includes minting
1338      * and burning.
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` will be minted for `to`.
1345      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1346      * - `from` and `to` are never both zero.
1347      *
1348      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1349      */
1350     function _beforeTokenTransfer(
1351         address from,
1352         address to,
1353         uint256 tokenId
1354     ) internal virtual {}
1355 
1356     /**
1357      * @dev Hook that is called after any transfer of tokens. This includes
1358      * minting and burning.
1359      *
1360      * Calling conditions:
1361      *
1362      * - when `from` and `to` are both non-zero.
1363      * - `from` and `to` are never both zero.
1364      *
1365      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1366      */
1367     function _afterTokenTransfer(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) internal virtual {}
1372 }
1373 
1374 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1375 
1376 
1377 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1378 
1379 pragma solidity ^0.8.0;
1380 
1381 
1382 
1383 /**
1384  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1385  * enumerability of all the token ids in the contract as well as all token ids owned by each
1386  * account.
1387  */
1388 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1389     // Mapping from owner to list of owned token IDs
1390     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1391 
1392     // Mapping from token ID to index of the owner tokens list
1393     mapping(uint256 => uint256) private _ownedTokensIndex;
1394 
1395     // Array with all token ids, used for enumeration
1396     uint256[] private _allTokens;
1397 
1398     // Mapping from token id to position in the allTokens array
1399     mapping(uint256 => uint256) private _allTokensIndex;
1400 
1401     /**
1402      * @dev See {IERC165-supportsInterface}.
1403      */
1404     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1405         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1406     }
1407 
1408     /**
1409      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1410      */
1411     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1412         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1413         return _ownedTokens[owner][index];
1414     }
1415 
1416     /**
1417      * @dev See {IERC721Enumerable-totalSupply}.
1418      */
1419     function totalSupply() public view virtual override returns (uint256) {
1420         return _allTokens.length;
1421     }
1422 
1423     /**
1424      * @dev See {IERC721Enumerable-tokenByIndex}.
1425      */
1426     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1427         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1428         return _allTokens[index];
1429     }
1430 
1431     /**
1432      * @dev Hook that is called before any token transfer. This includes minting
1433      * and burning.
1434      *
1435      * Calling conditions:
1436      *
1437      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1438      * transferred to `to`.
1439      * - When `from` is zero, `tokenId` will be minted for `to`.
1440      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1441      * - `from` cannot be the zero address.
1442      * - `to` cannot be the zero address.
1443      *
1444      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1445      */
1446     function _beforeTokenTransfer(
1447         address from,
1448         address to,
1449         uint256 tokenId
1450     ) internal virtual override {
1451         super._beforeTokenTransfer(from, to, tokenId);
1452 
1453         if (from == address(0)) {
1454             _addTokenToAllTokensEnumeration(tokenId);
1455         } else if (from != to) {
1456             _removeTokenFromOwnerEnumeration(from, tokenId);
1457         }
1458         if (to == address(0)) {
1459             _removeTokenFromAllTokensEnumeration(tokenId);
1460         } else if (to != from) {
1461             _addTokenToOwnerEnumeration(to, tokenId);
1462         }
1463     }
1464 
1465     /**
1466      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1467      * @param to address representing the new owner of the given token ID
1468      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1469      */
1470     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1471         uint256 length = ERC721.balanceOf(to);
1472         _ownedTokens[to][length] = tokenId;
1473         _ownedTokensIndex[tokenId] = length;
1474     }
1475 
1476     /**
1477      * @dev Private function to add a token to this extension's token tracking data structures.
1478      * @param tokenId uint256 ID of the token to be added to the tokens list
1479      */
1480     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1481         _allTokensIndex[tokenId] = _allTokens.length;
1482         _allTokens.push(tokenId);
1483     }
1484 
1485     /**
1486      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1487      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1488      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1489      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1490      * @param from address representing the previous owner of the given token ID
1491      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1492      */
1493     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1494         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1495         // then delete the last slot (swap and pop).
1496 
1497         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1498         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1499 
1500         // When the token to delete is the last token, the swap operation is unnecessary
1501         if (tokenIndex != lastTokenIndex) {
1502             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1503 
1504             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1505             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1506         }
1507 
1508         // This also deletes the contents at the last position of the array
1509         delete _ownedTokensIndex[tokenId];
1510         delete _ownedTokens[from][lastTokenIndex];
1511     }
1512 
1513     /**
1514      * @dev Private function to remove a token from this extension's token tracking data structures.
1515      * This has O(1) time complexity, but alters the order of the _allTokens array.
1516      * @param tokenId uint256 ID of the token to be removed from the tokens list
1517      */
1518     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1519         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1520         // then delete the last slot (swap and pop).
1521 
1522         uint256 lastTokenIndex = _allTokens.length - 1;
1523         uint256 tokenIndex = _allTokensIndex[tokenId];
1524 
1525         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1526         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1527         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1528         uint256 lastTokenId = _allTokens[lastTokenIndex];
1529 
1530         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1531         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1532 
1533         // This also deletes the contents at the last position of the array
1534         delete _allTokensIndex[tokenId];
1535         _allTokens.pop();
1536     }
1537 }
1538 
1539 // File: contracts/PokerGo.sol
1540 
1541 
1542 
1543 pragma solidity 0.8.13;
1544 
1545 
1546 
1547 
1548 
1549 contract PokerGO is ERC721Enumerable, Ownable
1550 {
1551     using Strings for uint256;
1552     using SafeMath for uint256;
1553 
1554     uint256 public nextTokenId = 1;
1555 
1556     uint256 public constant MAX_SUPPLY = 1326;
1557 
1558     // Public sale
1559     uint256 public PRICE = 0.10 ether;
1560     uint256 public publicsaleStartDate;
1561     mapping (address => uint256) public minted;
1562     mapping (address => uint256) public p1minted;
1563     mapping (address => uint256) public p2minted;
1564     mapping (address => uint256) public freeminted;
1565     mapping (address => uint256) private _canFreeMint;
1566 
1567 
1568     // Pre-sale
1569     uint256 public phase1StartDate;
1570     uint256 public phase2StartDate;
1571     mapping (address => bool) public isWhitelisted;
1572 
1573     uint256 public revealDate;
1574 
1575     string public baseTokenURI;
1576     string public baseExtension = ".json";
1577     string public unrevealedURI;
1578 
1579     address payable public payments;
1580 
1581 
1582 
1583     constructor(string memory baseURI, uint256 _phase1StartDate, uint256 _phase2StartDate, uint256 _publicsaleStartDate, string memory _unrevealedURI, uint256 _revealDate,address _payments, address[] memory _freeAddress, uint256[] memory _canMinttotal) ERC721("PokerGO Genesis NFT Collection", "PGNFT") {
1584         require(_payments != address(0), "Account is the zero address");
1585         require(_freeAddress.length == _canMinttotal.length, "Address and number length mismatch");
1586         require(_freeAddress.length > 0, "No Free Mint Address");
1587 
1588         for (uint256 i = 0; i < _freeAddress.length; i++) {
1589             
1590             _addFreeMint(_freeAddress[i], _canMinttotal[i]);
1591         }
1592         setBaseURI(baseURI);
1593         setUnrevealedURI(_unrevealedURI);
1594         phase1StartDate = _phase1StartDate;
1595         phase2StartDate = _phase2StartDate;
1596         publicsaleStartDate = _publicsaleStartDate;
1597         revealDate = _revealDate;
1598         payments = payable(_payments);
1599     }
1600     function _addFreeMint(address account, uint256 canminttotal_) private {
1601         require(account != address(0), "Account is the zero address");
1602         require(canminttotal_ > 0, "Cannot Free Mint 0 NFT");
1603         require(_canFreeMint[account] == 0, "Account already has shares");
1604         _canFreeMint[account] = canminttotal_;
1605     }
1606 
1607     function _baseURI() internal view virtual override returns (string memory) {
1608         if (block.timestamp < revealDate) {
1609             return unrevealedURI;
1610         }
1611         return baseTokenURI;
1612     }
1613 
1614     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1615         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1616         
1617         if (block.timestamp < revealDate) {
1618             return string(abi.encodePacked(unrevealedURI, tokenId.toString(), baseExtension));
1619         }
1620         
1621         else {
1622             string memory baseURI = _baseURI();
1623             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension)) : "";
1624         }    
1625     }
1626 
1627     function mint(uint256 _count) public payable {
1628         uint256 totalMinted = nextTokenId;
1629         require(totalMinted.add(_count) <= MAX_SUPPLY + 1, "Not enough NFTs left");
1630         require(_count > 0, "Cannot mint 0 NFTs");
1631         if (_canFreeMint[msg.sender]-freeminted[msg.sender]>0)
1632         {
1633             
1634             freeminted[msg.sender] += _count;
1635             require(freeminted[msg.sender] <= _canFreeMint[msg.sender], string(abi.encodePacked("Address can't mint more than ", _canFreeMint[msg.sender].toString(), " NFTs in Free mint")));
1636             for (uint256 i = 0; i < _count; i++) {
1637                 _mintNFT();
1638             }  
1639         } else {
1640 
1641             require(block.timestamp > phase1StartDate, "Sale not started yet");
1642             //require(block.timestamp > phase2StartDate, "Phase 2 Sale not started yet");
1643             require(msg.value >= calculatePrice(_count),"Not enough ethereum to purchase NFTs");
1644             
1645             if  (block.timestamp > publicsaleStartDate) {
1646                 minted[msg.sender] += _count;
1647                 require(minted[msg.sender] <= 10, "Address can't mint more than 10 NFTs in Public sale");
1648             } else if (block.timestamp > phase2StartDate) {
1649                 require(isWhitelisted[msg.sender], "Address is not whitelisted");
1650                 p2minted[msg.sender] += _count;
1651                 require(p2minted[msg.sender] <= 5, "Address can't mint more than 5 NFTs in Phase 2 sale");
1652             } else if (block.timestamp > phase1StartDate) {
1653                 require(isWhitelisted[msg.sender], "Address is not whitelisted");
1654                 p1minted[msg.sender] += _count;
1655                 require(p1minted[msg.sender] <= 2, "Address can't mint more than 2 NFTs in Phase 1 sale");
1656             } 
1657             for (uint256 i = 0; i < _count; i++) {
1658                 _mintNFT();
1659             }
1660         }
1661     }
1662 
1663 
1664     function calculatePrice(uint256 _count) public view returns(uint256) {
1665         return _count * PRICE;
1666     }
1667 
1668     function _mintNFT() private {
1669         uint256 tokenId = nextTokenId;
1670         _safeMint(msg.sender, tokenId, '');
1671         nextTokenId = tokenId + 1;
1672     }
1673 
1674     // Owner functions
1675 
1676     function withdraw() public payable onlyOwner {
1677         uint256 balance = address(this).balance;
1678         require(balance > 0, "No ethereum left to withdraw");
1679 
1680         (bool success, ) = payable(payments).call{value: balance}("");
1681         require(success, "Transfer failed.");
1682     }
1683 
1684     function setPhase2StartDate(uint256 _endDate) external onlyOwner {
1685         phase2StartDate = _endDate;
1686     }
1687 
1688     function setPhase1StartDate(uint256 _startDate) external onlyOwner {
1689         phase1StartDate = _startDate;
1690     }
1691 
1692     function setPublicSaleStartDate(uint256 _publicsaleStartDate) external onlyOwner {
1693         publicsaleStartDate = _publicsaleStartDate;
1694     }
1695 
1696     function addToWhitelist(address[] memory _addresses) external onlyOwner {
1697         for (uint256 i = 0;i < _addresses.length;i++) {
1698             require(_addresses[i] != address(0), "Account is the zero address");
1699             isWhitelisted[_addresses[i]] = true;
1700         }
1701     }
1702 
1703     function removeFromWhitelist (address[] memory _addresses) external onlyOwner {
1704         for (uint256 i = 0;i < _addresses.length;i++) {
1705             isWhitelisted[_addresses[i]] = false;
1706         }
1707     }
1708 
1709     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1710         baseTokenURI = _baseTokenURI;
1711     }
1712 
1713     function setUnrevealedURI(string memory _unrevealedURI) public onlyOwner {
1714         unrevealedURI = _unrevealedURI;
1715     }
1716 
1717     function setRevealDate(uint256 _revealDate) public onlyOwner {
1718         revealDate = _revealDate;
1719     }
1720 }