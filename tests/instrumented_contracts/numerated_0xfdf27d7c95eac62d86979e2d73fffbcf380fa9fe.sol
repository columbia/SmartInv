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
411 pragma solidity ^0.8.0;
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
433      */
434     function isContract(address account) internal view returns (bool) {
435         // This method relies on extcodesize, which returns 0 for contracts in
436         // construction, since the code is only stored at the end of the
437         // constructor execution.
438 
439         uint256 size;
440         assembly {
441             size := extcodesize(account)
442         }
443         return size > 0;
444     }
445 
446     /**
447      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
448      * `recipient`, forwarding all available gas and reverting on errors.
449      *
450      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
451      * of certain opcodes, possibly making contracts go over the 2300 gas limit
452      * imposed by `transfer`, making them unable to receive funds via
453      * `transfer`. {sendValue} removes this limitation.
454      *
455      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
456      *
457      * IMPORTANT: because control is transferred to `recipient`, care must be
458      * taken to not create reentrancy vulnerabilities. Consider using
459      * {ReentrancyGuard} or the
460      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
461      */
462     function sendValue(address payable recipient, uint256 amount) internal {
463         require(address(this).balance >= amount, "Address: insufficient balance");
464 
465         (bool success, ) = recipient.call{value: amount}("");
466         require(success, "Address: unable to send value, recipient may have reverted");
467     }
468 
469     /**
470      * @dev Performs a Solidity function call using a low level `call`. A
471      * plain `call` is an unsafe replacement for a function call: use this
472      * function instead.
473      *
474      * If `target` reverts with a revert reason, it is bubbled up by this
475      * function (like regular Solidity function calls).
476      *
477      * Returns the raw returned data. To convert to the expected return value,
478      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
479      *
480      * Requirements:
481      *
482      * - `target` must be a contract.
483      * - calling `target` with `data` must not revert.
484      *
485      * _Available since v3.1._
486      */
487     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
488         return functionCall(target, data, "Address: low-level call failed");
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
493      * `errorMessage` as a fallback revert reason when `target` reverts.
494      *
495      * _Available since v3.1._
496      */
497     function functionCall(
498         address target,
499         bytes memory data,
500         string memory errorMessage
501     ) internal returns (bytes memory) {
502         return functionCallWithValue(target, data, 0, errorMessage);
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
507      * but also transferring `value` wei to `target`.
508      *
509      * Requirements:
510      *
511      * - the calling contract must have an ETH balance of at least `value`.
512      * - the called Solidity function must be `payable`.
513      *
514      * _Available since v3.1._
515      */
516     function functionCallWithValue(
517         address target,
518         bytes memory data,
519         uint256 value
520     ) internal returns (bytes memory) {
521         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
526      * with `errorMessage` as a fallback revert reason when `target` reverts.
527      *
528      * _Available since v3.1._
529      */
530     function functionCallWithValue(
531         address target,
532         bytes memory data,
533         uint256 value,
534         string memory errorMessage
535     ) internal returns (bytes memory) {
536         require(address(this).balance >= value, "Address: insufficient balance for call");
537         require(isContract(target), "Address: call to non-contract");
538 
539         (bool success, bytes memory returndata) = target.call{value: value}(data);
540         return verifyCallResult(success, returndata, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but performing a static call.
546      *
547      * _Available since v3.3._
548      */
549     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
550         return functionStaticCall(target, data, "Address: low-level static call failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
555      * but performing a static call.
556      *
557      * _Available since v3.3._
558      */
559     function functionStaticCall(
560         address target,
561         bytes memory data,
562         string memory errorMessage
563     ) internal view returns (bytes memory) {
564         require(isContract(target), "Address: static call to non-contract");
565 
566         (bool success, bytes memory returndata) = target.staticcall(data);
567         return verifyCallResult(success, returndata, errorMessage);
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
572      * but performing a delegate call.
573      *
574      * _Available since v3.4._
575      */
576     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
577         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
582      * but performing a delegate call.
583      *
584      * _Available since v3.4._
585      */
586     function functionDelegateCall(
587         address target,
588         bytes memory data,
589         string memory errorMessage
590     ) internal returns (bytes memory) {
591         require(isContract(target), "Address: delegate call to non-contract");
592 
593         (bool success, bytes memory returndata) = target.delegatecall(data);
594         return verifyCallResult(success, returndata, errorMessage);
595     }
596 
597     /**
598      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
599      * revert reason using the provided one.
600      *
601      * _Available since v4.3._
602      */
603     function verifyCallResult(
604         bool success,
605         bytes memory returndata,
606         string memory errorMessage
607     ) internal pure returns (bytes memory) {
608         if (success) {
609             return returndata;
610         } else {
611             // Look for revert reason and bubble it up if present
612             if (returndata.length > 0) {
613                 // The easiest way to bubble the revert reason is using memory via assembly
614 
615                 assembly {
616                     let returndata_size := mload(returndata)
617                     revert(add(32, returndata), returndata_size)
618                 }
619             } else {
620                 revert(errorMessage);
621             }
622         }
623     }
624 }
625 
626 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @title ERC721 token receiver interface
635  * @dev Interface for any contract that wants to support safeTransfers
636  * from ERC721 asset contracts.
637  */
638 interface IERC721Receiver {
639     /**
640      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
641      * by `operator` from `from`, this function is called.
642      *
643      * It must return its Solidity selector to confirm the token transfer.
644      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
645      *
646      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
647      */
648     function onERC721Received(
649         address operator,
650         address from,
651         uint256 tokenId,
652         bytes calldata data
653     ) external returns (bytes4);
654 }
655 
656 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
683 
684 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @dev Implementation of the {IERC165} interface.
694  *
695  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
696  * for the additional interface id that will be supported. For example:
697  *
698  * ```solidity
699  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
700  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
701  * }
702  * ```
703  *
704  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
705  */
706 abstract contract ERC165 is IERC165 {
707     /**
708      * @dev See {IERC165-supportsInterface}.
709      */
710     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
711         return interfaceId == type(IERC165).interfaceId;
712     }
713 }
714 
715 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
859 
860 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
861 
862 
863 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
864 
865 pragma solidity ^0.8.0;
866 
867 
868 /**
869  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
870  * @dev See https://eips.ethereum.org/EIPS/eip-721
871  */
872 interface IERC721Metadata is IERC721 {
873     /**
874      * @dev Returns the token collection name.
875      */
876     function name() external view returns (string memory);
877 
878     /**
879      * @dev Returns the token collection symbol.
880      */
881     function symbol() external view returns (string memory);
882 
883     /**
884      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
885      */
886     function tokenURI(uint256 tokenId) external view returns (string memory);
887 }
888 
889 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
890 
891 
892 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 
897 
898 
899 
900 
901 
902 
903 /**
904  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
905  * the Metadata extension, but not including the Enumerable extension, which is available separately as
906  * {ERC721Enumerable}.
907  */
908 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
909     using Address for address;
910     using Strings for uint256;
911 
912     // Token name
913     string private _name;
914 
915     // Token symbol
916     string private _symbol;
917 
918     // Mapping from token ID to owner address
919     mapping(uint256 => address) private _owners;
920 
921     // Mapping owner address to token count
922     mapping(address => uint256) private _balances;
923 
924     // Mapping from token ID to approved address
925     mapping(uint256 => address) private _tokenApprovals;
926 
927     // Mapping from owner to operator approvals
928     mapping(address => mapping(address => bool)) private _operatorApprovals;
929 
930     /**
931      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
932      */
933     constructor(string memory name_, string memory symbol_) {
934         _name = name_;
935         _symbol = symbol_;
936     }
937 
938     /**
939      * @dev See {IERC165-supportsInterface}.
940      */
941     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
942         return
943             interfaceId == type(IERC721).interfaceId ||
944             interfaceId == type(IERC721Metadata).interfaceId ||
945             super.supportsInterface(interfaceId);
946     }
947 
948     /**
949      * @dev See {IERC721-balanceOf}.
950      */
951     function balanceOf(address owner) public view virtual override returns (uint256) {
952         require(owner != address(0), "ERC721: balance query for the zero address");
953         return _balances[owner];
954     }
955 
956     /**
957      * @dev See {IERC721-ownerOf}.
958      */
959     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
960         address owner = _owners[tokenId];
961         require(owner != address(0), "ERC721: owner query for nonexistent token");
962         return owner;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-name}.
967      */
968     function name() public view virtual override returns (string memory) {
969         return _name;
970     }
971 
972     /**
973      * @dev See {IERC721Metadata-symbol}.
974      */
975     function symbol() public view virtual override returns (string memory) {
976         return _symbol;
977     }
978 
979     /**
980      * @dev See {IERC721Metadata-tokenURI}.
981      */
982     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
983         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
984 
985         string memory baseURI = _baseURI();
986         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
987     }
988 
989     /**
990      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
991      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
992      * by default, can be overriden in child contracts.
993      */
994     function _baseURI() internal view virtual returns (string memory) {
995         return "";
996     }
997 
998     /**
999      * @dev See {IERC721-approve}.
1000      */
1001     function approve(address to, uint256 tokenId) public virtual override {
1002         address owner = ERC721.ownerOf(tokenId);
1003         require(to != owner, "ERC721: approval to current owner");
1004 
1005         require(
1006             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1007             "ERC721: approve caller is not owner nor approved for all"
1008         );
1009 
1010         _approve(to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-getApproved}.
1015      */
1016     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1017         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1018 
1019         return _tokenApprovals[tokenId];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-setApprovalForAll}.
1024      */
1025     function setApprovalForAll(address operator, bool approved) public virtual override {
1026         _setApprovalForAll(_msgSender(), operator, approved);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-isApprovedForAll}.
1031      */
1032     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1033         return _operatorApprovals[owner][operator];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-transferFrom}.
1038      */
1039     function transferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         //solhint-disable-next-line max-line-length
1045         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1046 
1047         _transfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-safeTransferFrom}.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) public virtual override {
1058         safeTransferFrom(from, to, tokenId, "");
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-safeTransferFrom}.
1063      */
1064     function safeTransferFrom(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) public virtual override {
1070         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1071         _safeTransfer(from, to, tokenId, _data);
1072     }
1073 
1074     /**
1075      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1076      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1077      *
1078      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1079      *
1080      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1081      * implement alternative mechanisms to perform token transfer, such as signature-based.
1082      *
1083      * Requirements:
1084      *
1085      * - `from` cannot be the zero address.
1086      * - `to` cannot be the zero address.
1087      * - `tokenId` token must exist and be owned by `from`.
1088      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _safeTransfer(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) internal virtual {
1098         _transfer(from, to, tokenId);
1099         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1100     }
1101 
1102     /**
1103      * @dev Returns whether `tokenId` exists.
1104      *
1105      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1106      *
1107      * Tokens start existing when they are minted (`_mint`),
1108      * and stop existing when they are burned (`_burn`).
1109      */
1110     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1111         return _owners[tokenId] != address(0);
1112     }
1113 
1114     /**
1115      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1116      *
1117      * Requirements:
1118      *
1119      * - `tokenId` must exist.
1120      */
1121     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1122         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1123         address owner = ERC721.ownerOf(tokenId);
1124         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1125     }
1126 
1127     /**
1128      * @dev Safely mints `tokenId` and transfers it to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - `tokenId` must not exist.
1133      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _safeMint(address to, uint256 tokenId) internal virtual {
1138         _safeMint(to, tokenId, "");
1139     }
1140 
1141     /**
1142      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1143      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1144      */
1145     function _safeMint(
1146         address to,
1147         uint256 tokenId,
1148         bytes memory _data
1149     ) internal virtual {
1150         _mint(to, tokenId);
1151         require(
1152             _checkOnERC721Received(address(0), to, tokenId, _data),
1153             "ERC721: transfer to non ERC721Receiver implementer"
1154         );
1155     }
1156 
1157     /**
1158      * @dev Mints `tokenId` and transfers it to `to`.
1159      *
1160      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1161      *
1162      * Requirements:
1163      *
1164      * - `tokenId` must not exist.
1165      * - `to` cannot be the zero address.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _mint(address to, uint256 tokenId) internal virtual {
1170         require(to != address(0), "ERC721: mint to the zero address");
1171         require(!_exists(tokenId), "ERC721: token already minted");
1172 
1173         _beforeTokenTransfer(address(0), to, tokenId);
1174 
1175         _balances[to] += 1;
1176         _owners[tokenId] = to;
1177 
1178         emit Transfer(address(0), to, tokenId);
1179     }
1180 
1181     /**
1182      * @dev Destroys `tokenId`.
1183      * The approval is cleared when the token is burned.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must exist.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _burn(uint256 tokenId) internal virtual {
1192         address owner = ERC721.ownerOf(tokenId);
1193 
1194         _beforeTokenTransfer(owner, address(0), tokenId);
1195 
1196         // Clear approvals
1197         _approve(address(0), tokenId);
1198 
1199         _balances[owner] -= 1;
1200         delete _owners[tokenId];
1201 
1202         emit Transfer(owner, address(0), tokenId);
1203     }
1204 
1205     /**
1206      * @dev Transfers `tokenId` from `from` to `to`.
1207      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1208      *
1209      * Requirements:
1210      *
1211      * - `to` cannot be the zero address.
1212      * - `tokenId` token must be owned by `from`.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _transfer(
1217         address from,
1218         address to,
1219         uint256 tokenId
1220     ) internal virtual {
1221         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1222         require(to != address(0), "ERC721: transfer to the zero address");
1223 
1224         _beforeTokenTransfer(from, to, tokenId);
1225 
1226         // Clear approvals from the previous owner
1227         _approve(address(0), tokenId);
1228 
1229         _balances[from] -= 1;
1230         _balances[to] += 1;
1231         _owners[tokenId] = to;
1232 
1233         emit Transfer(from, to, tokenId);
1234     }
1235 
1236     /**
1237      * @dev Approve `to` to operate on `tokenId`
1238      *
1239      * Emits a {Approval} event.
1240      */
1241     function _approve(address to, uint256 tokenId) internal virtual {
1242         _tokenApprovals[tokenId] = to;
1243         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1244     }
1245 
1246     /**
1247      * @dev Approve `operator` to operate on all of `owner` tokens
1248      *
1249      * Emits a {ApprovalForAll} event.
1250      */
1251     function _setApprovalForAll(
1252         address owner,
1253         address operator,
1254         bool approved
1255     ) internal virtual {
1256         require(owner != operator, "ERC721: approve to caller");
1257         _operatorApprovals[owner][operator] = approved;
1258         emit ApprovalForAll(owner, operator, approved);
1259     }
1260 
1261     /**
1262      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1263      * The call is not executed if the target address is not a contract.
1264      *
1265      * @param from address representing the previous owner of the given token ID
1266      * @param to target address that will receive the tokens
1267      * @param tokenId uint256 ID of the token to be transferred
1268      * @param _data bytes optional data to send along with the call
1269      * @return bool whether the call correctly returned the expected magic value
1270      */
1271     function _checkOnERC721Received(
1272         address from,
1273         address to,
1274         uint256 tokenId,
1275         bytes memory _data
1276     ) private returns (bool) {
1277         if (to.isContract()) {
1278             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1279                 return retval == IERC721Receiver.onERC721Received.selector;
1280             } catch (bytes memory reason) {
1281                 if (reason.length == 0) {
1282                     revert("ERC721: transfer to non ERC721Receiver implementer");
1283                 } else {
1284                     assembly {
1285                         revert(add(32, reason), mload(reason))
1286                     }
1287                 }
1288             }
1289         } else {
1290             return true;
1291         }
1292     }
1293 
1294     /**
1295      * @dev Hook that is called before any token transfer. This includes minting
1296      * and burning.
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` will be minted for `to`.
1303      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1304      * - `from` and `to` are never both zero.
1305      *
1306      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1307      */
1308     function _beforeTokenTransfer(
1309         address from,
1310         address to,
1311         uint256 tokenId
1312     ) internal virtual {}
1313 }
1314 
1315 // File: contracts/LEN.sol
1316 
1317 //"SPDX-License-Identifier: UNLICENSED"
1318 pragma solidity ^0.8.7;
1319 pragma experimental ABIEncoderV2;
1320 
1321 
1322 
1323 
1324 /*
1325 * $$$$$$$\                            $$$$$$$\                      $$\       
1326 * $$  __$$\                           $$  __$$\                     $$ |      
1327 * $$ |  $$ |$$\   $$\ $$\   $$\       $$ |  $$ |$$\   $$\ $$$$$$$\  $$ |  $$\ 
1328 * $$$$$$$\ |$$ |  $$ |$$ |  $$ |      $$$$$$$  |$$ |  $$ |$$  __$$\ $$ | $$  |
1329 * $$  __$$\ $$ |  $$ |$$ |  $$ |      $$  ____/ $$ |  $$ |$$ |  $$ |$$$$$$  / 
1330 * $$ |  $$ |$$ |  $$ |$$ |  $$ |      $$ |      $$ |  $$ |$$ |  $$ |$$  _$$<  
1331 * $$$$$$$  |\$$$$$$  |\$$$$$$$ |      $$ |      \$$$$$$  |$$ |  $$ |$$ | \$$\ 
1332 * \_______/  \______/  \____$$ |      \__|       \______/ \__|  \__|\__|  \__|
1333 *                     $$\   $$ |                                              
1334 *                     \$$$$$$  |                                              
1335 *                      \______/             -> https://opensea.io/collection/low-effort-punks                                 
1336 *                                            - LamboWhale & WhaleGoddess
1337 */
1338 
1339 /* Thanks to Nouns DAO for the inspiration. nouns.wtf */
1340 
1341 contract SimpleCollectible is ERC721, Ownable {
1342     using SafeMath for uint256;
1343     uint256 public tokenCounter;
1344 
1345     uint256 private _salePrice = .01 ether; // .01 ETH
1346 
1347     uint256 private _maxPerTx = 70; // Set to one higher than actual, to save gas on <= checks.
1348 
1349     uint256 public _totalSupply = 5635; 
1350 
1351     string private _baseTokenURI;
1352     bool private paused; 
1353     
1354     address private WG = 0x1B3FEA07590E63Ce68Cb21951f3C133a35032473;
1355     address private LW = 0x01e0d267E922C33469a97ec60753f93C6A4C15Ff;
1356     
1357     constructor () ERC721 ("Low Effort Nouns","LEN")  {
1358         setBaseURI("https://gateway.pinata.cloud/ipfs/QmYtC928MTEf5bksypYYejwrV6xMHaA6ZubfzR3tmW2GC9");
1359         tokenCounter = 0;
1360     }
1361 
1362     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1363         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1364         return string(abi.encodePacked(getBaseURI(), Strings.toString(tokenId), ".json"));
1365     }
1366     function mintCollectibles(uint256 _count) public payable {
1367         require(!paused, "Sale is not yet open");
1368         require(_count < _maxPerTx, "Cant mint more than mintMax");
1369         require((_count + tokenCounter) <= _totalSupply, "Ran out of NFTs for sale! Sry!");
1370         require(msg.value >= (_salePrice * _count), "Ether value sent is not correct");
1371 
1372         createCollectibles(msg.sender, _count);
1373     }
1374 
1375 	function mintWithWGPass(address _user) public {
1376 	    require(msg.sender == address(0x1B7c412E7D83Daf1Bf13bb0DbAc471C71AfaC9af), "Only the mint pass contract may call this function");
1377         require((1 + tokenCounter) <= _totalSupply, "Ran out of NFTs for sale! Sry!");
1378         
1379         createCollectibles(_user, 1);
1380 	}
1381 
1382     function ownerMint(uint256 _count, address _user) public onlyOwner {
1383         require((_count + tokenCounter) <= _totalSupply, "Ran out of NFTs for presale! Sry!");
1384 
1385         createCollectibles(_user, _count);
1386     }
1387 
1388     function createCollectibles(address _user, uint256 _count) private {
1389         for(uint i = 0; i < _count; i++) {
1390             createCollectible(_user);
1391         }
1392     }
1393 
1394     function createCollectible(address _user) private {
1395             _safeMint(_user, tokenCounter);
1396             tokenCounter = tokenCounter + 1;
1397     }
1398     
1399     function maxMintsPerTransaction() public view returns (uint) {
1400         return _maxPerTx - 1; //_maxPerTx is off by 1 for require checks in HOF Mint. Allows use of < instead of <=, less gas
1401     }
1402 
1403     function toggleSaleState() public onlyOwner {
1404         paused = !paused;
1405     }
1406     
1407     function getSalePrice() private view returns (uint){
1408         return _salePrice;
1409     }
1410     
1411     function setBaseURI(string memory baseURI) public onlyOwner {
1412         _baseTokenURI = baseURI;
1413     }
1414 
1415     function getBaseURI() public view returns (string memory){
1416         return _baseTokenURI;
1417     }
1418     function withdrawAll() public onlyOwner {
1419         uint256 bal = address(this).balance;
1420         payable(WG).transfer(bal.div(100).mul(5));
1421         payable(LW).transfer(address(this).balance);
1422     }
1423 }