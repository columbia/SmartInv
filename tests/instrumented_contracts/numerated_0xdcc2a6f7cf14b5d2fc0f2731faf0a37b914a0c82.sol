1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
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
300 
301 // File: @openzeppelin/contracts/utils/Context.sol
302 
303 
304 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
331 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
409 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
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
629 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
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
659 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
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
687 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
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
718 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
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
860 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
861 
862 
863 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
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
882     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
883 
884     /**
885      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
886      * Use along with {totalSupply} to enumerate all tokens.
887      */
888     function tokenByIndex(uint256 index) external view returns (uint256);
889 }
890 
891 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
892 
893 
894 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
895 
896 pragma solidity ^0.8.0;
897 
898 
899 /**
900  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
901  * @dev See https://eips.ethereum.org/EIPS/eip-721
902  */
903 interface IERC721Metadata is IERC721 {
904     /**
905      * @dev Returns the token collection name.
906      */
907     function name() external view returns (string memory);
908 
909     /**
910      * @dev Returns the token collection symbol.
911      */
912     function symbol() external view returns (string memory);
913 
914     /**
915      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
916      */
917     function tokenURI(uint256 tokenId) external view returns (string memory);
918 }
919 
920 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
921 
922 
923 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 
928 
929 
930 
931 
932 
933 
934 /**
935  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
936  * the Metadata extension, but not including the Enumerable extension, which is available separately as
937  * {ERC721Enumerable}.
938  */
939 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
940     using Address for address;
941     using Strings for uint256;
942 
943     // Token name
944     string private _name;
945 
946     // Token symbol
947     string private _symbol;
948 
949     // Mapping from token ID to owner address
950     mapping(uint256 => address) private _owners;
951 
952     // Mapping owner address to token count
953     mapping(address => uint256) private _balances;
954 
955     // Mapping from token ID to approved address
956     mapping(uint256 => address) private _tokenApprovals;
957 
958     // Mapping from owner to operator approvals
959     mapping(address => mapping(address => bool)) private _operatorApprovals;
960 
961     /**
962      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
963      */
964     constructor(string memory name_, string memory symbol_) {
965         _name = name_;
966         _symbol = symbol_;
967     }
968 
969     /**
970      * @dev See {IERC165-supportsInterface}.
971      */
972     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
973         return
974             interfaceId == type(IERC721).interfaceId ||
975             interfaceId == type(IERC721Metadata).interfaceId ||
976             super.supportsInterface(interfaceId);
977     }
978 
979     /**
980      * @dev See {IERC721-balanceOf}.
981      */
982     function balanceOf(address owner) public view virtual override returns (uint256) {
983         require(owner != address(0), "ERC721: balance query for the zero address");
984         return _balances[owner];
985     }
986 
987     /**
988      * @dev See {IERC721-ownerOf}.
989      */
990     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
991         address owner = _owners[tokenId];
992         require(owner != address(0), "ERC721: owner query for nonexistent token");
993         return owner;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-name}.
998      */
999     function name() public view virtual override returns (string memory) {
1000         return _name;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-symbol}.
1005      */
1006     function symbol() public view virtual override returns (string memory) {
1007         return _symbol;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-tokenURI}.
1012      */
1013     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1014         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1015 
1016         string memory baseURI = _baseURI();
1017         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1018     }
1019 
1020     /**
1021      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1022      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1023      * by default, can be overriden in child contracts.
1024      */
1025     function _baseURI() internal view virtual returns (string memory) {
1026         return "";
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-approve}.
1031      */
1032     function approve(address to, uint256 tokenId) public virtual override {
1033         address owner = ERC721.ownerOf(tokenId);
1034         require(to != owner, "ERC721: approval to current owner");
1035 
1036         require(
1037             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1038             "ERC721: approve caller is not owner nor approved for all"
1039         );
1040 
1041         _approve(to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-getApproved}.
1046      */
1047     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1048         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1049 
1050         return _tokenApprovals[tokenId];
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-setApprovalForAll}.
1055      */
1056     function setApprovalForAll(address operator, bool approved) public virtual override {
1057         _setApprovalForAll(_msgSender(), operator, approved);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-isApprovedForAll}.
1062      */
1063     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1064         return _operatorApprovals[owner][operator];
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-transferFrom}.
1069      */
1070     function transferFrom(
1071         address from,
1072         address to,
1073         uint256 tokenId
1074     ) public virtual override {
1075         //solhint-disable-next-line max-line-length
1076         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1077 
1078         _transfer(from, to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-safeTransferFrom}.
1083      */
1084     function safeTransferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) public virtual override {
1089         safeTransferFrom(from, to, tokenId, "");
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-safeTransferFrom}.
1094      */
1095     function safeTransferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) public virtual override {
1101         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1102         _safeTransfer(from, to, tokenId, _data);
1103     }
1104 
1105     /**
1106      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1107      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1108      *
1109      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1110      *
1111      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1112      * implement alternative mechanisms to perform token transfer, such as signature-based.
1113      *
1114      * Requirements:
1115      *
1116      * - `from` cannot be the zero address.
1117      * - `to` cannot be the zero address.
1118      * - `tokenId` token must exist and be owned by `from`.
1119      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _safeTransfer(
1124         address from,
1125         address to,
1126         uint256 tokenId,
1127         bytes memory _data
1128     ) internal virtual {
1129         _transfer(from, to, tokenId);
1130         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1131     }
1132 
1133     /**
1134      * @dev Returns whether `tokenId` exists.
1135      *
1136      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1137      *
1138      * Tokens start existing when they are minted (`_mint`),
1139      * and stop existing when they are burned (`_burn`).
1140      */
1141     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1142         return _owners[tokenId] != address(0);
1143     }
1144 
1145     /**
1146      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must exist.
1151      */
1152     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1153         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1154         address owner = ERC721.ownerOf(tokenId);
1155         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1156     }
1157 
1158     /**
1159      * @dev Safely mints `tokenId` and transfers it to `to`.
1160      *
1161      * Requirements:
1162      *
1163      * - `tokenId` must not exist.
1164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _safeMint(address to, uint256 tokenId) internal virtual {
1169         _safeMint(to, tokenId, "");
1170     }
1171 
1172     /**
1173      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1174      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1175      */
1176     function _safeMint(
1177         address to,
1178         uint256 tokenId,
1179         bytes memory _data
1180     ) internal virtual {
1181         _mint(to, tokenId);
1182         require(
1183             _checkOnERC721Received(address(0), to, tokenId, _data),
1184             "ERC721: transfer to non ERC721Receiver implementer"
1185         );
1186     }
1187 
1188     /**
1189      * @dev Mints `tokenId` and transfers it to `to`.
1190      *
1191      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1192      *
1193      * Requirements:
1194      *
1195      * - `tokenId` must not exist.
1196      * - `to` cannot be the zero address.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _mint(address to, uint256 tokenId) internal virtual {
1201         require(to != address(0), "ERC721: mint to the zero address");
1202         require(!_exists(tokenId), "ERC721: token already minted");
1203 
1204         _beforeTokenTransfer(address(0), to, tokenId);
1205 
1206         _balances[to] += 1;
1207         _owners[tokenId] = to;
1208 
1209         emit Transfer(address(0), to, tokenId);
1210     }
1211 
1212     /**
1213      * @dev Destroys `tokenId`.
1214      * The approval is cleared when the token is burned.
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must exist.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _burn(uint256 tokenId) internal virtual {
1223         address owner = ERC721.ownerOf(tokenId);
1224 
1225         _beforeTokenTransfer(owner, address(0), tokenId);
1226 
1227         // Clear approvals
1228         _approve(address(0), tokenId);
1229 
1230         _balances[owner] -= 1;
1231         delete _owners[tokenId];
1232 
1233         emit Transfer(owner, address(0), tokenId);
1234     }
1235 
1236     /**
1237      * @dev Transfers `tokenId` from `from` to `to`.
1238      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1239      *
1240      * Requirements:
1241      *
1242      * - `to` cannot be the zero address.
1243      * - `tokenId` token must be owned by `from`.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _transfer(
1248         address from,
1249         address to,
1250         uint256 tokenId
1251     ) internal virtual {
1252         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1253         require(to != address(0), "ERC721: transfer to the zero address");
1254 
1255         _beforeTokenTransfer(from, to, tokenId);
1256 
1257         // Clear approvals from the previous owner
1258         _approve(address(0), tokenId);
1259 
1260         _balances[from] -= 1;
1261         _balances[to] += 1;
1262         _owners[tokenId] = to;
1263 
1264         emit Transfer(from, to, tokenId);
1265     }
1266 
1267     /**
1268      * @dev Approve `to` to operate on `tokenId`
1269      *
1270      * Emits a {Approval} event.
1271      */
1272     function _approve(address to, uint256 tokenId) internal virtual {
1273         _tokenApprovals[tokenId] = to;
1274         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1275     }
1276 
1277     /**
1278      * @dev Approve `operator` to operate on all of `owner` tokens
1279      *
1280      * Emits a {ApprovalForAll} event.
1281      */
1282     function _setApprovalForAll(
1283         address owner,
1284         address operator,
1285         bool approved
1286     ) internal virtual {
1287         require(owner != operator, "ERC721: approve to caller");
1288         _operatorApprovals[owner][operator] = approved;
1289         emit ApprovalForAll(owner, operator, approved);
1290     }
1291 
1292     /**
1293      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1294      * The call is not executed if the target address is not a contract.
1295      *
1296      * @param from address representing the previous owner of the given token ID
1297      * @param to target address that will receive the tokens
1298      * @param tokenId uint256 ID of the token to be transferred
1299      * @param _data bytes optional data to send along with the call
1300      * @return bool whether the call correctly returned the expected magic value
1301      */
1302     function _checkOnERC721Received(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) private returns (bool) {
1308         if (to.isContract()) {
1309             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1310                 return retval == IERC721Receiver.onERC721Received.selector;
1311             } catch (bytes memory reason) {
1312                 if (reason.length == 0) {
1313                     revert("ERC721: transfer to non ERC721Receiver implementer");
1314                 } else {
1315                     assembly {
1316                         revert(add(32, reason), mload(reason))
1317                     }
1318                 }
1319             }
1320         } else {
1321             return true;
1322         }
1323     }
1324 
1325     /**
1326      * @dev Hook that is called before any token transfer. This includes minting
1327      * and burning.
1328      *
1329      * Calling conditions:
1330      *
1331      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1332      * transferred to `to`.
1333      * - When `from` is zero, `tokenId` will be minted for `to`.
1334      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1335      * - `from` and `to` are never both zero.
1336      *
1337      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1338      */
1339     function _beforeTokenTransfer(
1340         address from,
1341         address to,
1342         uint256 tokenId
1343     ) internal virtual {}
1344 }
1345 
1346 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1347 
1348 
1349 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 
1354 
1355 /**
1356  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1357  * enumerability of all the token ids in the contract as well as all token ids owned by each
1358  * account.
1359  */
1360 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1361     // Mapping from owner to list of owned token IDs
1362     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1363 
1364     // Mapping from token ID to index of the owner tokens list
1365     mapping(uint256 => uint256) private _ownedTokensIndex;
1366 
1367     // Array with all token ids, used for enumeration
1368     uint256[] private _allTokens;
1369 
1370     // Mapping from token id to position in the allTokens array
1371     mapping(uint256 => uint256) private _allTokensIndex;
1372 
1373     /**
1374      * @dev See {IERC165-supportsInterface}.
1375      */
1376     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1377         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1378     }
1379 
1380     /**
1381      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1382      */
1383     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1384         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1385         return _ownedTokens[owner][index];
1386     }
1387 
1388     /**
1389      * @dev See {IERC721Enumerable-totalSupply}.
1390      */
1391     function totalSupply() public view virtual override returns (uint256) {
1392         return _allTokens.length;
1393     }
1394 
1395     /**
1396      * @dev See {IERC721Enumerable-tokenByIndex}.
1397      */
1398     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1399         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1400         return _allTokens[index];
1401     }
1402 
1403     /**
1404      * @dev Hook that is called before any token transfer. This includes minting
1405      * and burning.
1406      *
1407      * Calling conditions:
1408      *
1409      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1410      * transferred to `to`.
1411      * - When `from` is zero, `tokenId` will be minted for `to`.
1412      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1413      * - `from` cannot be the zero address.
1414      * - `to` cannot be the zero address.
1415      *
1416      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1417      */
1418     function _beforeTokenTransfer(
1419         address from,
1420         address to,
1421         uint256 tokenId
1422     ) internal virtual override {
1423         super._beforeTokenTransfer(from, to, tokenId);
1424 
1425         if (from == address(0)) {
1426             _addTokenToAllTokensEnumeration(tokenId);
1427         } else if (from != to) {
1428             _removeTokenFromOwnerEnumeration(from, tokenId);
1429         }
1430         if (to == address(0)) {
1431             _removeTokenFromAllTokensEnumeration(tokenId);
1432         } else if (to != from) {
1433             _addTokenToOwnerEnumeration(to, tokenId);
1434         }
1435     }
1436 
1437     /**
1438      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1439      * @param to address representing the new owner of the given token ID
1440      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1441      */
1442     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1443         uint256 length = ERC721.balanceOf(to);
1444         _ownedTokens[to][length] = tokenId;
1445         _ownedTokensIndex[tokenId] = length;
1446     }
1447 
1448     /**
1449      * @dev Private function to add a token to this extension's token tracking data structures.
1450      * @param tokenId uint256 ID of the token to be added to the tokens list
1451      */
1452     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1453         _allTokensIndex[tokenId] = _allTokens.length;
1454         _allTokens.push(tokenId);
1455     }
1456 
1457     /**
1458      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1459      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1460      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1461      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1462      * @param from address representing the previous owner of the given token ID
1463      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1464      */
1465     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1466         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1467         // then delete the last slot (swap and pop).
1468 
1469         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1470         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1471 
1472         // When the token to delete is the last token, the swap operation is unnecessary
1473         if (tokenIndex != lastTokenIndex) {
1474             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1475 
1476             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1477             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1478         }
1479 
1480         // This also deletes the contents at the last position of the array
1481         delete _ownedTokensIndex[tokenId];
1482         delete _ownedTokens[from][lastTokenIndex];
1483     }
1484 
1485     /**
1486      * @dev Private function to remove a token from this extension's token tracking data structures.
1487      * This has O(1) time complexity, but alters the order of the _allTokens array.
1488      * @param tokenId uint256 ID of the token to be removed from the tokens list
1489      */
1490     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1491         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1492         // then delete the last slot (swap and pop).
1493 
1494         uint256 lastTokenIndex = _allTokens.length - 1;
1495         uint256 tokenIndex = _allTokensIndex[tokenId];
1496 
1497         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1498         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1499         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1500         uint256 lastTokenId = _allTokens[lastTokenIndex];
1501 
1502         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1503         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1504 
1505         // This also deletes the contents at the last position of the array
1506         delete _allTokensIndex[tokenId];
1507         _allTokens.pop();
1508     }
1509 }
1510 
1511 // File: contracts/Noodles.sol
1512 
1513 
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 
1518 
1519 
1520 contract Noodles is ERC721Enumerable, Ownable {
1521   using Strings for uint256;
1522   using SafeMath for uint256;
1523 
1524   //NFT Parameters
1525   string private baseURI;
1526   string private baseExtension = ".json";
1527   string private notRevealedUri;
1528   uint256 public cost;
1529   uint256 public maxMintAmount;
1530   bool public paused = true;
1531   bool public revealed = false;
1532 
1533   //sale states:
1534   //stage 0: init
1535   //stage 1: free mint
1536   //stage 2: pre-sale
1537   //stage 3: public sale
1538 
1539   uint8 public mintState;
1540 
1541   //stage 1: free mint
1542   mapping(address => uint8) public addressFreeMintsAvailable;
1543 
1544   //stage 2: presale mint
1545   mapping(address => uint8) public addressWLMintsAvailable;
1546 
1547   constructor() ERC721("Noodles", "NOODS") {}
1548 
1549   // internal
1550   function _baseURI() internal view virtual override returns (string memory) {
1551     return baseURI;
1552   }
1553 
1554   // public
1555   function mint(uint8 _mintAmount) public payable {
1556     uint256 supply = totalSupply();
1557     require(!paused, "contract is paused");
1558     require(_mintAmount > 0, "You have to mint at least 1 NFT!"); //must mint at least 1    
1559     require(mintState <= 3, "Minting is finished!"); //only 3 states
1560     require(_mintAmount <= maxMintAmount, "Exceeded maximum NFT purchase");
1561     require(cost * _mintAmount <= msg.value, "Insufficient funds!"); //not enough ETH
1562 
1563     if (mintState == 1){
1564       //free mint of 1 with 833 spots
1565           require(supply + _mintAmount <= 836, "Total Free supply exceeded!");
1566           require(addressFreeMintsAvailable[msg.sender] >= _mintAmount , "Max NFTs exceeded");
1567           addressFreeMintsAvailable[msg.sender] -= _mintAmount;
1568     }
1569 
1570     else if (mintState == 2){
1571       //WL mint of 1, 2, or 3 addresses whitelisted
1572           require(supply + _mintAmount <= 4436, "Total whitelist supply exceeded!");
1573           require(addressWLMintsAvailable[msg.sender] >= _mintAmount , "Max NFTs exceeded");
1574           addressWLMintsAvailable[msg.sender] -= _mintAmount;
1575     }
1576 
1577     else if (mintState ==3){
1578       //public mint
1579           require(supply + _mintAmount <= 5555);
1580     }
1581 
1582     else {
1583       assert(false);
1584     }
1585 
1586     for (uint256 i = 1; i <= _mintAmount; i++) {
1587       _safeMint(msg.sender, supply + i);
1588 
1589     }
1590   }
1591 
1592   function reserve(uint256 n) public onlyOwner {
1593     uint supply = totalSupply();
1594       for (uint256 i = 1; i <= n; i++) {
1595           _safeMint(msg.sender, supply + i);
1596       }
1597   }
1598 
1599   function tokenURI(uint256 tokenId)public view virtual override returns (string memory) {
1600     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1601     
1602     if(revealed == false) {
1603         return notRevealedUri;
1604     }
1605 
1606     string memory currentBaseURI = _baseURI();
1607     return bytes(currentBaseURI).length > 0
1608         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1609         : "";
1610   }
1611 
1612   //only owner
1613   function reveal() public onlyOwner {
1614       revealed = true;
1615   }
1616 
1617    function setState(uint8 _state)public onlyOwner{
1618        mintState = _state;
1619 
1620      //free mint
1621      if (mintState==1){
1622         cost=0 ether;
1623         maxMintAmount=1;
1624       }       
1625      //whitelist 
1626      if (mintState==2){
1627         cost=0.05 ether;
1628         maxMintAmount=3;
1629       }
1630     //public
1631     if (mintState==3){
1632         cost=0.05 ether;
1633         maxMintAmount = 10;
1634       }
1635    }
1636   
1637   function unpause() public onlyOwner{
1638       paused = false;
1639   }
1640 
1641   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1642     baseURI = _newBaseURI;
1643   }
1644 
1645   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1646     notRevealedUri = _notRevealedURI;
1647   }
1648 
1649   function addFreeMintUsers(address[] calldata _users) public onlyOwner {
1650     for (uint i=0;i<_users.length;i++){
1651       addressFreeMintsAvailable[_users[i]] = 1;
1652     }
1653   }
1654 
1655   function addWhitelistUsers(address[] calldata _users) public onlyOwner {
1656     for (uint i=0;i<_users.length;i++){
1657       addressWLMintsAvailable[_users[i]] = 3;
1658     }
1659   }
1660 
1661   function withdraw() public payable onlyOwner {
1662     //20% payment split
1663     (bool hs, ) = payable(0xC35f3F92A9F27A157B309a9656CfEA30E5C9cCe3).call{value: address(this).balance * 20 / 100}("");
1664     require(hs);
1665 
1666     (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
1667     require(os);
1668   }
1669 
1670 }