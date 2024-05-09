1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
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
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
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
409 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
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
634 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
651      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
723 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
762      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
763      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must exist and be owned by `from`.
770      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
771      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
772      *
773      * Emits a {Transfer} event.
774      */
775     function safeTransferFrom(
776         address from,
777         address to,
778         uint256 tokenId
779     ) external;
780 
781     /**
782      * @dev Transfers `tokenId` token from `from` to `to`.
783      *
784      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
785      *
786      * Requirements:
787      *
788      * - `from` cannot be the zero address.
789      * - `to` cannot be the zero address.
790      * - `tokenId` token must be owned by `from`.
791      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
792      *
793      * Emits a {Transfer} event.
794      */
795     function transferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) external;
800 
801     /**
802      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
803      * The approval is cleared when the token is transferred.
804      *
805      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
806      *
807      * Requirements:
808      *
809      * - The caller must own the token or be an approved operator.
810      * - `tokenId` must exist.
811      *
812      * Emits an {Approval} event.
813      */
814     function approve(address to, uint256 tokenId) external;
815 
816     /**
817      * @dev Returns the account approved for `tokenId` token.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must exist.
822      */
823     function getApproved(uint256 tokenId) external view returns (address operator);
824 
825     /**
826      * @dev Approve or remove `operator` as an operator for the caller.
827      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
828      *
829      * Requirements:
830      *
831      * - The `operator` cannot be the caller.
832      *
833      * Emits an {ApprovalForAll} event.
834      */
835     function setApprovalForAll(address operator, bool _approved) external;
836 
837     /**
838      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
839      *
840      * See {setApprovalForAll}
841      */
842     function isApprovedForAll(address owner, address operator) external view returns (bool);
843 
844     /**
845      * @dev Safely transfers `tokenId` token from `from` to `to`.
846      *
847      * Requirements:
848      *
849      * - `from` cannot be the zero address.
850      * - `to` cannot be the zero address.
851      * - `tokenId` token must exist and be owned by `from`.
852      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
853      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
854      *
855      * Emits a {Transfer} event.
856      */
857     function safeTransferFrom(
858         address from,
859         address to,
860         uint256 tokenId,
861         bytes calldata data
862     ) external;
863 }
864 
865 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
866 
867 
868 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
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
887     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
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
925 // File: ERC721A/contracts/ERC721A.sol
926 
927 
928 // Creator: Chiru Labs
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
939 
940 /**
941  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
942  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
943  *
944  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
945  *
946  * Does not support burning tokens to address(0).
947  *
948  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
949  */
950 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
951     using Address for address;
952     using Strings for uint256;
953 
954     struct TokenOwnership {
955         address addr;
956         uint64 startTimestamp;
957     }
958 
959     struct AddressData {
960         uint128 balance;
961         uint128 numberMinted;
962     }
963 
964     uint256 internal currentIndex = 0;
965 
966     // Token name
967     string private _name;
968 
969     // Token symbol
970     string private _symbol;
971 
972     // Mapping from token ID to ownership details
973     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
974     mapping(uint256 => TokenOwnership) internal _ownerships;
975 
976     // Mapping owner address to address data
977     mapping(address => AddressData) private _addressData;
978 
979     // Mapping from token ID to approved address
980     mapping(uint256 => address) private _tokenApprovals;
981 
982     // Mapping from owner to operator approvals
983     mapping(address => mapping(address => bool)) private _operatorApprovals;
984 
985     constructor(string memory name_, string memory symbol_) {
986         _name = name_;
987         _symbol = symbol_;
988     }
989 
990     /**
991      * @dev See {IERC721Enumerable-totalSupply}.
992      */
993     function totalSupply() public view override returns (uint256) {
994         return currentIndex;
995     }
996 
997     /**
998      * @dev See {IERC721Enumerable-tokenByIndex}.
999      */
1000     function tokenByIndex(uint256 index) public view override returns (uint256) {
1001         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1002         return index;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1007      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1008      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1009      */
1010     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1011         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1012         uint256 numMintedSoFar = totalSupply();
1013         uint256 tokenIdsIdx = 0;
1014         address currOwnershipAddr = address(0);
1015         for (uint256 i = 0; i < numMintedSoFar; i++) {
1016             TokenOwnership memory ownership = _ownerships[i];
1017             if (ownership.addr != address(0)) {
1018                 currOwnershipAddr = ownership.addr;
1019             }
1020             if (currOwnershipAddr == owner) {
1021                 if (tokenIdsIdx == index) {
1022                     return i;
1023                 }
1024                 tokenIdsIdx++;
1025             }
1026         }
1027         revert('ERC721A: unable to get token of owner by index');
1028     }
1029 
1030     /**
1031      * @dev See {IERC165-supportsInterface}.
1032      */
1033     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1034         return
1035             interfaceId == type(IERC721).interfaceId ||
1036             interfaceId == type(IERC721Metadata).interfaceId ||
1037             interfaceId == type(IERC721Enumerable).interfaceId ||
1038             super.supportsInterface(interfaceId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-balanceOf}.
1043      */
1044     function balanceOf(address owner) public view override returns (uint256) {
1045         require(owner != address(0), 'ERC721A: balance query for the zero address');
1046         return uint256(_addressData[owner].balance);
1047     }
1048 
1049     function _numberMinted(address owner) internal view returns (uint256) {
1050         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1051         return uint256(_addressData[owner].numberMinted);
1052     }
1053 
1054     /**
1055      * Gas spent here starts off proportional to the maximum mint batch size.
1056      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1057      */
1058     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1059         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1060 
1061         for (uint256 curr = tokenId; ; curr--) {
1062             TokenOwnership memory ownership = _ownerships[curr];
1063             if (ownership.addr != address(0)) {
1064                 return ownership;
1065             }
1066         }
1067 
1068         revert('ERC721A: unable to determine the owner of token');
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-ownerOf}.
1073      */
1074     function ownerOf(uint256 tokenId) public view override returns (address) {
1075         return ownershipOf(tokenId).addr;
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-name}.
1080      */
1081     function name() public view virtual override returns (string memory) {
1082         return _name;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-symbol}.
1087      */
1088     function symbol() public view virtual override returns (string memory) {
1089         return _symbol;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Metadata-tokenURI}.
1094      */
1095     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1096         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1097 
1098         string memory baseURI = _baseURI();
1099         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1100     }
1101 
1102     /**
1103      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1104      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1105      * by default, can be overriden in child contracts.
1106      */
1107     function _baseURI() internal view virtual returns (string memory) {
1108         return '';
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-approve}.
1113      */
1114     function approve(address to, uint256 tokenId) public override {
1115         address owner = ERC721A.ownerOf(tokenId);
1116         require(to != owner, 'ERC721A: approval to current owner');
1117 
1118         require(
1119             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1120             'ERC721A: approve caller is not owner nor approved for all'
1121         );
1122 
1123         _approve(to, tokenId, owner);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-getApproved}.
1128      */
1129     function getApproved(uint256 tokenId) public view override returns (address) {
1130         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1131 
1132         return _tokenApprovals[tokenId];
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-setApprovalForAll}.
1137      */
1138     function setApprovalForAll(address operator, bool approved) public override {
1139         require(operator != _msgSender(), 'ERC721A: approve to caller');
1140 
1141         _operatorApprovals[_msgSender()][operator] = approved;
1142         emit ApprovalForAll(_msgSender(), operator, approved);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-isApprovedForAll}.
1147      */
1148     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1149         return _operatorApprovals[owner][operator];
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-transferFrom}.
1154      */
1155     function transferFrom(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) public override {
1160         _transfer(from, to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-safeTransferFrom}.
1165      */
1166     function safeTransferFrom(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) public override {
1171         safeTransferFrom(from, to, tokenId, '');
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-safeTransferFrom}.
1176      */
1177     function safeTransferFrom(
1178         address from,
1179         address to,
1180         uint256 tokenId,
1181         bytes memory _data
1182     ) public override {
1183         _transfer(from, to, tokenId);
1184         require(
1185             _checkOnERC721Received(from, to, tokenId, _data),
1186             'ERC721A: transfer to non ERC721Receiver implementer'
1187         );
1188     }
1189 
1190     /**
1191      * @dev Returns whether `tokenId` exists.
1192      *
1193      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1194      *
1195      * Tokens start existing when they are minted (`_mint`),
1196      */
1197     function _exists(uint256 tokenId) internal view returns (bool) {
1198         return tokenId < currentIndex;
1199     }
1200 
1201     function _safeMint(address to, uint256 quantity) internal {
1202         _safeMint(to, quantity, '');
1203     }
1204 
1205     /**
1206      * @dev Mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _safeMint(
1216         address to,
1217         uint256 quantity,
1218         bytes memory _data
1219     ) internal {
1220         uint256 startTokenId = currentIndex;
1221         require(to != address(0), 'ERC721A: mint to the zero address');
1222         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1223         require(!_exists(startTokenId), 'ERC721A: token already minted');
1224         require(quantity > 0, 'ERC721A: quantity must be greater than 0');
1225 
1226         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1227 
1228         _addressData[to].balance += uint128(quantity);
1229         _addressData[to].numberMinted += uint128(quantity);
1230 
1231         _ownerships[startTokenId].addr = to;
1232         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1233 
1234         uint256 updatedIndex = startTokenId;
1235 
1236         for (uint256 i = 0; i < quantity; i++) {
1237             emit Transfer(address(0), to, updatedIndex);
1238             require(
1239                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1240                 'ERC721A: transfer to non ERC721Receiver implementer'
1241             );
1242             updatedIndex++;
1243         }
1244 
1245         currentIndex = updatedIndex;
1246         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1247     }
1248 
1249     /**
1250      * @dev Transfers `tokenId` from `from` to `to`.
1251      *
1252      * Requirements:
1253      *
1254      * - `to` cannot be the zero address.
1255      * - `tokenId` token must be owned by `from`.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _transfer(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) private {
1264         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1265 
1266         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1267             getApproved(tokenId) == _msgSender() ||
1268             isApprovedForAll(prevOwnership.addr, _msgSender()));
1269 
1270         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1271 
1272         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1273         require(to != address(0), 'ERC721A: transfer to the zero address');
1274 
1275         _beforeTokenTransfers(from, to, tokenId, 1);
1276 
1277         // Clear approvals from the previous owner
1278         _approve(address(0), tokenId, prevOwnership.addr);
1279 
1280         // Underflow of the sender's balance is impossible because we check for
1281         // ownership above and the recipient's balance can't realistically overflow.
1282         unchecked {
1283             _addressData[from].balance -= 1;
1284             _addressData[to].balance += 1;
1285         }
1286 
1287         _ownerships[tokenId].addr = to;
1288         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1289 
1290         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1291         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1292         uint256 nextTokenId = tokenId + 1;
1293         if (_ownerships[nextTokenId].addr == address(0)) {
1294             if (_exists(nextTokenId)) {
1295                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1296                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1297             }
1298         }
1299 
1300         emit Transfer(from, to, tokenId);
1301         _afterTokenTransfers(from, to, tokenId, 1);
1302     }
1303 
1304     /**
1305      * @dev Approve `to` to operate on `tokenId`
1306      *
1307      * Emits a {Approval} event.
1308      */
1309     function _approve(
1310         address to,
1311         uint256 tokenId,
1312         address owner
1313     ) private {
1314         _tokenApprovals[tokenId] = to;
1315         emit Approval(owner, to, tokenId);
1316     }
1317 
1318     /**
1319      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1320      * The call is not executed if the target address is not a contract.
1321      *
1322      * @param from address representing the previous owner of the given token ID
1323      * @param to target address that will receive the tokens
1324      * @param tokenId uint256 ID of the token to be transferred
1325      * @param _data bytes optional data to send along with the call
1326      * @return bool whether the call correctly returned the expected magic value
1327      */
1328     function _checkOnERC721Received(
1329         address from,
1330         address to,
1331         uint256 tokenId,
1332         bytes memory _data
1333     ) private returns (bool) {
1334         if (to.isContract()) {
1335             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1336                 return retval == IERC721Receiver(to).onERC721Received.selector;
1337             } catch (bytes memory reason) {
1338                 if (reason.length == 0) {
1339                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1340                 } else {
1341                     assembly {
1342                         revert(add(32, reason), mload(reason))
1343                     }
1344                 }
1345             }
1346         } else {
1347             return true;
1348         }
1349     }
1350 
1351     /**
1352      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1353      *
1354      * startTokenId - the first token id to be transferred
1355      * quantity - the amount to be transferred
1356      *
1357      * Calling conditions:
1358      *
1359      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1360      * transferred to `to`.
1361      * - When `from` is zero, `tokenId` will be minted for `to`.
1362      */
1363     function _beforeTokenTransfers(
1364         address from,
1365         address to,
1366         uint256 startTokenId,
1367         uint256 quantity
1368     ) internal virtual {}
1369 
1370     /**
1371      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1372      * minting.
1373      *
1374      * startTokenId - the first token id to be transferred
1375      * quantity - the amount to be transferred
1376      *
1377      * Calling conditions:
1378      *
1379      * - when `from` and `to` are both non-zero.
1380      * - `from` and `to` are never both zero.
1381      */
1382     function _afterTokenTransfers(
1383         address from,
1384         address to,
1385         uint256 startTokenId,
1386         uint256 quantity
1387     ) internal virtual {}
1388 }
1389 // File: FloydiesContract2.sol
1390 
1391 
1392 pragma solidity ^0.8.0;
1393 
1394 
1395 
1396 contract GenerativeFloydiesV2 is ERC721A, Ownable {
1397   using SafeMath for uint256;
1398 
1399     uint128 public constant MAX_SUPPLY = 5000;
1400     uint128 public constant MAX_PURCHASE = 50;
1401     uint256 public constant TOKEN_PRICE = 0.008 ether;
1402 
1403     bool public saleStatus = true;
1404     string private _baseTokenURI;
1405 
1406    constructor(string memory baseURI) ERC721A("Generative Floydies 2", "FLGV2") {
1407     _baseTokenURI = baseURI;
1408     //Re-mints
1409     _safeMint(0x507E52947402Ee329C998943134cFb59cecB3AB2, 8); //0-7
1410     _safeMint(0x3979Bf6F519d4452E83F82B709F1bF1F97ad1a88, 5); //8-12
1411     _safeMint(0x7C4a7d85623CdF7bBf67ceaf2b862E3028Fe9aCb, 1); //13
1412     _safeMint(0x02E765dDea5fF25a2dAC1006cf09f0Cc1AfDDA8c, 1); //14
1413     _safeMint(0x05B9B8D4F708f94176c330501C8E61f3017447b9, 1); //15
1414     _safeMint(0x704bd11A1fFb457e95186FDFe6B2Ba963aFB4c4d, 1); //16
1415     _safeMint(0x799A9275EE3904CC9d6a9A8a04a401ef8aaCFedA, 4); //17-20
1416     _safeMint(0x6390Ec87849F5cd003Fee1Ed9142F23C0c833277, 1); //21
1417     _safeMint(0x507E52947402Ee329C998943134cFb59cecB3AB2, 1); //22
1418     _safeMint(0xDa754c0Db6d130bcc196b7FCD013175F5A42FaF3, 3); //22-25
1419     _safeMint(0xB3b1A4EB7d3Ab8283af4aeDb9952e2F42D1C4A6D, 10); //26-35
1420     _safeMint(0xB5B4a1378e98f73683884E240734BEE3cF195fFD, 3); //36-38
1421     _safeMint(0x4E97DfaEc8e11f43eE3fB326148E603F283eb43E, 2); //39-40
1422     _safeMint(0xe5963480aCE624A003cb1645C75eF468d7d533C5, 5); //41-45
1423     _safeMint(0xe25c3fc737089ea15d10e8159dF8a8E7923413a0, 1); //46
1424     _safeMint(0x15B925A76f88b18AE1CF2263E7b4Cd6e9Ebffa2C, 2); //47-48
1425     _safeMint(0xb425E0716de4c85e973F88f1b68deE82f909ED72, 1); //49
1426     _safeMint(0xAed4134fb4F2F007ae9Cb0Df7AfcFdE8B770FCDC, 2); //50-51
1427     _safeMint(0xc6ed19804420c42E5c98d2Dd6c49adDa1deB6a15, 1); //52
1428     _safeMint(0xd68df74e496d3243bFd27821664998Dabd3dF3fb, 1); //53
1429     _safeMint(0x4aC88DFA5E0D3488F5537597d64677F460CC5F11, 3); //54-56
1430     _safeMint(0x507E52947402Ee329C998943134cFb59cecB3AB2, 1); //57
1431     _safeMint(0x8228C60f778bFEd1c8d31EF779323fa6fEb53eba, 1); //58
1432     _safeMint(0xBc32959ad4D52B248A8876748414791eA6a8Cc3d, 3); //59-61
1433     _safeMint(0xC33B76C77a5fe806bECF04742a057Bf25264faBe, 1); //62
1434     _safeMint(0x8054DA59cCFfAde428Ac2751845aB44969d95d0a, 1); //63
1435     _safeMint(0x480f0c2958dF72AD9a28073052BD13C6D985Ff8F, 1); //64
1436     _safeMint(0x75909d460c9dF289Ea15Ed082cD72dd54068E650, 10); //65-74
1437     _safeMint(0x8bE7fC0d077cEb3366B92D6bf5EAB052821d107b, 1); //75
1438     _safeMint(0x1A22F009Dd0C2d7127c1816dfC6Fa1E1acC28E34, 2); //76-77
1439     _safeMint(0xC33B76C77a5fe806bECF04742a057Bf25264faBe, 1); //78
1440     _safeMint(0x18622da87351Ff40c2bdF43a24Bcc8fb9d022507, 1); //79
1441     _safeMint(0xe485e0E28F59EB2D7AfCeA159AC130070F6D314a, 1); //80
1442     _safeMint(0x348C8038fA9B6Ccad7b0c9b28C55315A64fc3343, 3); //81-83
1443     _safeMint(0x1a4984Be14d3D42f09384503d20F14c04Bb13586, 1); //84
1444     _safeMint(0x9BFF216e4a01D871bcf4aBfe3a7522E37A730817, 1); //85
1445     _safeMint(0xFb32f9B707951BAd108Dc29b93FF7B59F232deE0, 3); //86-88
1446     _safeMint(0x4Ea6bE3239df771aC0B388455850759dEFb82d02, 3); //89-91
1447     _safeMint(0x71204C4F1ca66ADd0A4ADb061D30CDa922533dE9, 2); //92-93
1448     _safeMint(0x1a4984Be14d3D42f09384503d20F14c04Bb13586, 1); //94
1449     _safeMint(0x6462bff7Bc9DebBa43542560FEEb1A1aCfE86bDe, 1); //95
1450     _safeMint(0xceaF64b3F2B9c7c931151B763E17Dc321574a424, 5); //96-100
1451     _safeMint(0x1d78A68746B33bccD0bDD542F6eE47175c239587, 2); //101-102
1452     _safeMint(0x9239e291942AF64988c041967327000832B95580, 1); //103
1453     _safeMint(0xbBfCD953c886Ec99176cD9A8462e28D79229C0ac, 1); //104
1454     _safeMint(0x50F34E958cb16f634bc8B7C0eA810248cCF28a6E, 1); //105
1455     _safeMint(0x5e2d64F5A8Bf3feF89FAD021f86d9597E82d0085, 1); //106
1456     _safeMint(0x41d91fecD7e7fcd490A438a7F4b7129191e9ad4f, 10); //107-116
1457     _safeMint(0x1a4984Be14d3D42f09384503d20F14c04Bb13586, 1); //117
1458     _safeMint(0x9935B60426F2504acEC9D8E71F2bB1692d3868Fd, 1); //118
1459     _safeMint(0x3aDb733356BBEf0aFAC9BAA66CEbCcDf466Caa45, 1); //119
1460     _safeMint(0x8C66e109C7361C39Ce250f2eD5dcDbeAC8331c80, 4); //120-123
1461     _safeMint(0xAD0d4DD3df16374bbb041dd5d7c439FAc28C49FE, 1); //124
1462     _safeMint(0x0c9EC5f066300bB193100ae8519Cb31392a32480, 1); //125
1463     _safeMint(0x91f8b8b8641fb8E52b1F51cd3C60817feCC1c6BA, 1); //126
1464     _safeMint(0x228C728c22D3160c44692da11947E76bE56DCcdA, 1); //127
1465     _safeMint(0xCAA1c4c4E563493858B3E3254c6b69e626703Ec4, 2); //128 + extra
1466     //Extra mints
1467     
1468     _safeMint(0x3979Bf6F519d4452E83F82B709F1bF1F97ad1a88, 8); //8-12
1469     _safeMint(0x7C4a7d85623CdF7bBf67ceaf2b862E3028Fe9aCb, 1); //13
1470     _safeMint(0x02E765dDea5fF25a2dAC1006cf09f0Cc1AfDDA8c, 1); //14
1471     _safeMint(0x05B9B8D4F708f94176c330501C8E61f3017447b9, 1); //15
1472     _safeMint(0x704bd11A1fFb457e95186FDFe6B2Ba963aFB4c4d, 1); //16
1473     _safeMint(0x799A9275EE3904CC9d6a9A8a04a401ef8aaCFedA, 7); //17-20
1474     _safeMint(0x6390Ec87849F5cd003Fee1Ed9142F23C0c833277, 1); //21
1475     
1476     _safeMint(0xDa754c0Db6d130bcc196b7FCD013175F5A42FaF3, 3); //22-25
1477     _safeMint(0xB3b1A4EB7d3Ab8283af4aeDb9952e2F42D1C4A6D, 15); //26-35
1478     _safeMint(0xB5B4a1378e98f73683884E240734BEE3cF195fFD, 5); //36-38
1479     _safeMint(0x4E97DfaEc8e11f43eE3fB326148E603F283eb43E, 3); //39-40
1480     _safeMint(0xe5963480aCE624A003cb1645C75eF468d7d533C5, 8); //41-45
1481     _safeMint(0xe25c3fc737089ea15d10e8159dF8a8E7923413a0, 1); //46
1482     _safeMint(0x15B925A76f88b18AE1CF2263E7b4Cd6e9Ebffa2C, 3); //47-48
1483     _safeMint(0xb425E0716de4c85e973F88f1b68deE82f909ED72, 1); //49
1484     _safeMint(0xAed4134fb4F2F007ae9Cb0Df7AfcFdE8B770FCDC, 3); //50-51
1485     _safeMint(0xc6ed19804420c42E5c98d2Dd6c49adDa1deB6a15, 1); //52
1486     _safeMint(0xd68df74e496d3243bFd27821664998Dabd3dF3fb, 1); //53
1487     _safeMint(0x4aC88DFA5E0D3488F5537597d64677F460CC5F11, 4); //54-56
1488    
1489     _safeMint(0x8228C60f778bFEd1c8d31EF779323fa6fEb53eba, 1); //58
1490     _safeMint(0xBc32959ad4D52B248A8876748414791eA6a8Cc3d, 4); //59-61
1491     _safeMint(0xC33B76C77a5fe806bECF04742a057Bf25264faBe, 2); //62
1492     _safeMint(0x8054DA59cCFfAde428Ac2751845aB44969d95d0a, 1); //63
1493     _safeMint(0x480f0c2958dF72AD9a28073052BD13C6D985Ff8F, 1); //64
1494     _safeMint(0x75909d460c9dF289Ea15Ed082cD72dd54068E650, 15); //65-74
1495     _safeMint(0x8bE7fC0d077cEb3366B92D6bf5EAB052821d107b, 1); //75
1496     _safeMint(0x1A22F009Dd0C2d7127c1816dfC6Fa1E1acC28E34, 3); //76-77
1497     
1498     _safeMint(0x18622da87351Ff40c2bdF43a24Bcc8fb9d022507, 1); //79
1499     _safeMint(0xe485e0E28F59EB2D7AfCeA159AC130070F6D314a, 1); //80
1500     _safeMint(0x348C8038fA9B6Ccad7b0c9b28C55315A64fc3343, 4); //81-83
1501     _safeMint(0x1a4984Be14d3D42f09384503d20F14c04Bb13586, 3); //84
1502     _safeMint(0x9BFF216e4a01D871bcf4aBfe3a7522E37A730817, 1); //85
1503     _safeMint(0xFb32f9B707951BAd108Dc29b93FF7B59F232deE0, 3); //86-88
1504     _safeMint(0x4Ea6bE3239df771aC0B388455850759dEFb82d02, 5); //89-91
1505     _safeMint(0x71204C4F1ca66ADd0A4ADb061D30CDa922533dE9, 3); //92-93
1506     
1507     _safeMint(0x6462bff7Bc9DebBa43542560FEEb1A1aCfE86bDe, 1); //95
1508     _safeMint(0xceaF64b3F2B9c7c931151B763E17Dc321574a424, 8); //96-100
1509     _safeMint(0x1d78A68746B33bccD0bDD542F6eE47175c239587, 3); //101-102
1510     _safeMint(0x9239e291942AF64988c041967327000832B95580, 1); //103
1511     _safeMint(0xbBfCD953c886Ec99176cD9A8462e28D79229C0ac, 1); //104
1512     _safeMint(0x50F34E958cb16f634bc8B7C0eA810248cCF28a6E, 1); //105
1513     _safeMint(0x5e2d64F5A8Bf3feF89FAD021f86d9597E82d0085, 1); //106
1514     _safeMint(0x41d91fecD7e7fcd490A438a7F4b7129191e9ad4f, 15); //107-116
1515     
1516     _safeMint(0x9935B60426F2504acEC9D8E71F2bB1692d3868Fd, 1); //118
1517     _safeMint(0x3aDb733356BBEf0aFAC9BAA66CEbCcDf466Caa45, 1); //119
1518     _safeMint(0x8C66e109C7361C39Ce250f2eD5dcDbeAC8331c80, 6); //120-123
1519     _safeMint(0xAD0d4DD3df16374bbb041dd5d7c439FAc28C49FE, 1); //124
1520     _safeMint(0x0c9EC5f066300bB193100ae8519Cb31392a32480, 1); //125
1521     _safeMint(0x91f8b8b8641fb8E52b1F51cd3C60817feCC1c6BA, 1); //126
1522     _safeMint(0x228C728c22D3160c44692da11947E76bE56DCcdA, 1); 
1523     }
1524     
1525   modifier callerIsUser() {
1526         require(tx.origin == msg.sender, "The caller is another contract");
1527         _;
1528     }
1529 
1530 function mintFloydie(uint256 numberOfTokens) public payable callerIsUser {
1531         require(saleStatus, "Sale must be active to mint a token");
1532         require(
1533             numberOfTokens <= MAX_PURCHASE,
1534             "Each wallet can only mint 50 tokens at a time"
1535         );
1536         uint256 targetTotalSupply = totalSupply().add(numberOfTokens);
1537         require(
1538             targetTotalSupply <= MAX_SUPPLY,
1539             "Purchase would exceed max supply of tokens"
1540         );
1541         uint256 totalCost = TOKEN_PRICE.mul(numberOfTokens);
1542         require(totalCost <= msg.value, "Ether value sent is too low");
1543 
1544         _safeMint(msg.sender, numberOfTokens);
1545 
1546         if (msg.value > totalCost) {
1547             payable(msg.sender).transfer(msg.value - totalCost);
1548         }
1549     }
1550 
1551 
1552 function setSaleStatus(bool newSaleStatus) external onlyOwner {
1553         saleStatus = newSaleStatus;
1554     }
1555 
1556 function _baseURI() internal view virtual override returns (string memory) {
1557         return _baseTokenURI;
1558     }
1559 
1560     function setBaseURI(string calldata baseURI) external onlyOwner {
1561         _baseTokenURI = baseURI;
1562     }
1563  
1564 function withdraw(address payable recipient) public onlyOwner {
1565         uint256 balance = address(this).balance;
1566         recipient.transfer(balance);
1567       }
1568 
1569 
1570 }