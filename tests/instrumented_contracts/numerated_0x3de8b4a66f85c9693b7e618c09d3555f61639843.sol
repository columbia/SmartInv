1 /**
2  *Submitted for verification at BscScan.com on 2021-09-13
3 */
4 
5 // SPDX-License-Identifier: None
6 
7 pragma solidity ^0.8.4;
8 
9 
10 interface IERC165 {
11     /**
12      * @dev Returns true if this contract implements the interface defined by
13      * `interfaceId`. See the corresponding
14      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
15      * to learn more about how these ids are created.
16      *
17      * This function call must use less than 30 000 gas.
18      */
19     function supportsInterface(bytes4 interfaceId) external view returns (bool);
20 }
21 
22 
23 /**
24  * @dev Required interface of an ERC721 compliant contract.
25  */
26 interface IERC721 is IERC165 {
27     /**
28      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
29      */
30     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
31 
32     /**
33      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
34      */
35     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
39      */
40     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
41 
42     /**
43      * @dev Returns the number of tokens in ``owner``'s account.
44      */
45     function balanceOf(address owner) external view returns (uint256 balance);
46 
47     /**
48      * @dev Returns the owner of the `tokenId` token.
49      *
50      * Requirements:
51      *
52      * - `tokenId` must exist.
53      */
54     function ownerOf(uint256 tokenId) external view returns (address owner);
55 
56     /**
57      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
58      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
59      *
60      * Requirements:
61      *
62      * - `from` cannot be the zero address.
63      * - `to` cannot be the zero address.
64      * - `tokenId` token must exist and be owned by `from`.
65      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
66      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
67      *
68      * Emits a {Transfer} event.
69      */
70     function safeTransferFrom(
71         address from,
72         address to,
73         uint256 tokenId
74     ) external;
75 
76     /**
77      * @dev Transfers `tokenId` token from `from` to `to`.
78      *
79      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must be owned by `from`.
86      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address from,
92         address to,
93         uint256 tokenId
94     ) external;
95 
96     /**
97      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
98      * The approval is cleared when the token is transferred.
99      *
100      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
101      *
102      * Requirements:
103      *
104      * - The caller must own the token or be an approved operator.
105      * - `tokenId` must exist.
106      *
107      * Emits an {Approval} event.
108      */
109     function approve(address to, uint256 tokenId) external;
110 
111     /**
112      * @dev Returns the account approved for `tokenId` token.
113      *
114      * Requirements:
115      *
116      * - `tokenId` must exist.
117      */
118     function getApproved(uint256 tokenId) external view returns (address operator);
119 
120     /**
121      * @dev Approve or remove `operator` as an operator for the caller.
122      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
123      *
124      * Requirements:
125      *
126      * - The `operator` cannot be the caller.
127      *
128      * Emits an {ApprovalForAll} event.
129      */
130     function setApprovalForAll(address operator, bool _approved) external;
131 
132     /**
133      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
134      *
135      * See {setApprovalForAll}
136      */
137     function isApprovedForAll(address owner, address operator) external view returns (bool);
138 
139     /**
140      * @dev Safely transfers `tokenId` token from `from` to `to`.
141      *
142      * Requirements:
143      *
144      * - `from` cannot be the zero address.
145      * - `to` cannot be the zero address.
146      * - `tokenId` token must exist and be owned by `from`.
147      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
148      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
149      *
150      * Emits a {Transfer} event.
151      */
152     function safeTransferFrom(
153         address from,
154         address to,
155         uint256 tokenId,
156         bytes calldata data
157     ) external;
158 }
159 
160 
161 library SafeMath {
162     /**
163      * @dev Returns the addition of two unsigned integers, with an overflow flag.
164      *
165      * _Available since v3.4._
166      */
167     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         unchecked {
169             uint256 c = a + b;
170             if (c < a) return (false, 0);
171             return (true, c);
172         }
173     }
174 
175     /**
176      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
177      *
178      * _Available since v3.4._
179      */
180     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
181         unchecked {
182             if (b > a) return (false, 0);
183             return (true, a - b);
184         }
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
189      *
190      * _Available since v3.4._
191      */
192     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
193         unchecked {
194             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195             // benefit is lost if 'b' is also tested.
196             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197             if (a == 0) return (true, 0);
198             uint256 c = a * b;
199             if (c / a != b) return (false, 0);
200             return (true, c);
201         }
202     }
203 
204     /**
205      * @dev Returns the division of two unsigned integers, with a division by zero flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         unchecked {
211             if (b == 0) return (false, 0);
212             return (true, a / b);
213         }
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
218      *
219      * _Available since v3.4._
220      */
221     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         unchecked {
223             if (b == 0) return (false, 0);
224             return (true, a % b);
225         }
226     }
227 
228     /**
229      * @dev Returns the addition of two unsigned integers, reverting on
230      * overflow.
231      *
232      * Counterpart to Solidity's `+` operator.
233      *
234      * Requirements:
235      *
236      * - Addition cannot overflow.
237      */
238     function add(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a + b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting on
244      * overflow (when the result is negative).
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      *
250      * - Subtraction cannot overflow.
251      */
252     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253         return a - b;
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, reverting on
258      * overflow.
259      *
260      * Counterpart to Solidity's `*` operator.
261      *
262      * Requirements:
263      *
264      * - Multiplication cannot overflow.
265      */
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a * b;
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers, reverting on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator.
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a / b;
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * reverting when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a % b;
298     }
299 
300     /**
301      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
302      * overflow (when the result is negative).
303      *
304      * CAUTION: This function is deprecated because it requires allocating memory for the error
305      * message unnecessarily. For custom revert reasons use {trySub}.
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      *
311      * - Subtraction cannot overflow.
312      */
313     function sub(
314         uint256 a,
315         uint256 b,
316         string memory errorMessage
317     ) internal pure returns (uint256) {
318         unchecked {
319             require(b <= a, errorMessage);
320             return a - b;
321         }
322     }
323 
324     /**
325      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
326      * division by zero. The result is rounded towards zero.
327      *
328      * Counterpart to Solidity's `/` operator. Note: this function uses a
329      * `revert` opcode (which leaves remaining gas untouched) while Solidity
330      * uses an invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      *
334      * - The divisor cannot be zero.
335      */
336     function div(
337         uint256 a,
338         uint256 b,
339         string memory errorMessage
340     ) internal pure returns (uint256) {
341         unchecked {
342             require(b > 0, errorMessage);
343             return a / b;
344         }
345     }
346 
347     /**
348      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
349      * reverting with custom message when dividing by zero.
350      *
351      * CAUTION: This function is deprecated because it requires allocating memory for the error
352      * message unnecessarily. For custom revert reasons use {tryMod}.
353      *
354      * Counterpart to Solidity's `%` operator. This function uses a `revert`
355      * opcode (which leaves remaining gas untouched) while Solidity uses an
356      * invalid opcode to revert (consuming all remaining gas).
357      *
358      * Requirements:
359      *
360      * - The divisor cannot be zero.
361      */
362     function mod(
363         uint256 a,
364         uint256 b,
365         string memory errorMessage
366     ) internal pure returns (uint256) {
367         unchecked {
368             require(b > 0, errorMessage);
369             return a % b;
370         }
371     }
372 }
373 
374 
375 /**
376  * @dev Provides information about the current execution context, including the
377  * sender of the transaction and its data. While these are generally available
378  * via msg.sender and msg.data, they should not be accessed in such a direct
379  * manner, since when dealing with meta-transactions the account sending and
380  * paying for execution may not be the actual sender (as far as an application
381  * is concerned).
382  *
383  * This contract is only required for intermediate, library-like contracts.
384  */
385 abstract contract Context {
386     function _msgSender() internal view virtual returns (address) {
387         return msg.sender;
388     }
389 
390     function _msgData() internal view virtual returns (bytes calldata) {
391         return msg.data;
392     }
393 }
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 abstract contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor() {
416         _setOwner(_msgSender());
417     }
418 
419     /**
420      * @dev Returns the address of the current owner.
421      */
422     function owner() public view virtual returns (address) {
423         return _owner;
424     }
425 
426     /**
427      * @dev Throws if called by any account other than the owner.
428      */
429     modifier onlyOwner() {
430         require(owner() == _msgSender(), "Ownable: caller is not the owner");
431         _;
432     }
433 
434     /**
435      * @dev Leaves the contract without owner. It will not be possible to call
436      * `onlyOwner` functions anymore. Can only be called by the current owner.
437      *
438      * NOTE: Renouncing ownership will leave the contract without an owner,
439      * thereby removing any functionality that is only available to the owner.
440      */
441     function renounceOwnership() public virtual onlyOwner {
442         _setOwner(address(0));
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(newOwner != address(0), "Ownable: new owner is the zero address");
451         _setOwner(newOwner);
452     }
453 
454     function _setOwner(address newOwner) private {
455         address oldOwner = _owner;
456         _owner = newOwner;
457         emit OwnershipTransferred(oldOwner, newOwner);
458     }
459 }
460 
461 
462 // import "./IERC165.sol";
463 
464 /**
465  * @dev Implementation of the {IERC165} interface.
466  *
467  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
468  * for the additional interface id that will be supported. For example:
469  *
470  * ```solidity
471  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
473  * }
474  * ```
475  *
476  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
477  */
478 abstract contract ERC165 is IERC165 {
479     /**
480      * @dev See {IERC165-supportsInterface}.
481      */
482     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483         return interfaceId == type(IERC165).interfaceId;
484     }
485 }
486 
487 
488 /**
489  * @dev String operations.
490  */
491 library Strings {
492     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
493 
494     /**
495      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
496      */
497     function toString(uint256 value) internal pure returns (string memory) {
498         // Inspired by OraclizeAPI's implementation - MIT licence
499         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
500 
501         if (value == 0) {
502             return "0";
503         }
504         uint256 temp = value;
505         uint256 digits;
506         while (temp != 0) {
507             digits++;
508             temp /= 10;
509         }
510         bytes memory buffer = new bytes(digits);
511         while (value != 0) {
512             digits -= 1;
513             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
514             value /= 10;
515         }
516         return string(buffer);
517     }
518 
519     /**
520      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
521      */
522     function toHexString(uint256 value) internal pure returns (string memory) {
523         if (value == 0) {
524             return "0x00";
525         }
526         uint256 temp = value;
527         uint256 length = 0;
528         while (temp != 0) {
529             length++;
530             temp >>= 8;
531         }
532         return toHexString(value, length);
533     }
534 
535     /**
536      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
537      */
538     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
539         bytes memory buffer = new bytes(2 * length + 2);
540         buffer[0] = "0";
541         buffer[1] = "x";
542         for (uint256 i = 2 * length + 1; i > 1; --i) {
543             buffer[i] = _HEX_SYMBOLS[value & 0xf];
544             value >>= 4;
545         }
546         require(value == 0, "Strings: hex length insufficient");
547         return string(buffer);
548     }
549 }
550 
551 
552 
553 
554 
555 
556 
557 /**
558  * @dev Collection of functions related to the address type
559  */
560 library Address {
561     /**
562      * @dev Returns true if `account` is a contract.
563      *
564      * [IMPORTANT]
565      * ====
566      * It is unsafe to assume that an address for which this function returns
567      * false is an externally-owned account (EOA) and not a contract.
568      *
569      * Among others, `isContract` will return false for the following
570      * types of addresses:
571      *
572      *  - an externally-owned account
573      *  - a contract in construction
574      *  - an address where a contract will be created
575      *  - an address where a contract lived, but was destroyed
576      * ====
577      */
578     function isContract(address account) internal view returns (bool) {
579         // This method relies on extcodesize, which returns 0 for contracts in
580         // construction, since the code is only stored at the end of the
581         // constructor execution.
582 
583         uint256 size;
584         assembly {
585             size := extcodesize(account)
586         }
587         return size > 0;
588     }
589 
590     /**
591      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
592      * `recipient`, forwarding all available gas and reverting on errors.
593      *
594      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
595      * of certain opcodes, possibly making contracts go over the 2300 gas limit
596      * imposed by `transfer`, making them unable to receive funds via
597      * `transfer`. {sendValue} removes this limitation.
598      *
599      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
600      *
601      * IMPORTANT: because control is transferred to `recipient`, care must be
602      * taken to not create reentrancy vulnerabilities. Consider using
603      * {ReentrancyGuard} or the
604      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
605      */
606     function sendValue(address payable recipient, uint256 amount) internal {
607         require(address(this).balance >= amount, "Address: insufficient balance");
608 
609         (bool success, ) = recipient.call{value: amount}("");
610         require(success, "Address: unable to send value, recipient may have reverted");
611     }
612 
613     /**
614      * @dev Performs a Solidity function call using a low level `call`. A
615      * plain `call` is an unsafe replacement for a function call: use this
616      * function instead.
617      *
618      * If `target` reverts with a revert reason, it is bubbled up by this
619      * function (like regular Solidity function calls).
620      *
621      * Returns the raw returned data. To convert to the expected return value,
622      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
623      *
624      * Requirements:
625      *
626      * - `target` must be a contract.
627      * - calling `target` with `data` must not revert.
628      *
629      * _Available since v3.1._
630      */
631     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
632         return functionCall(target, data, "Address: low-level call failed");
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
637      * `errorMessage` as a fallback revert reason when `target` reverts.
638      *
639      * _Available since v3.1._
640      */
641     function functionCall(
642         address target,
643         bytes memory data,
644         string memory errorMessage
645     ) internal returns (bytes memory) {
646         return functionCallWithValue(target, data, 0, errorMessage);
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
651      * but also transferring `value` wei to `target`.
652      *
653      * Requirements:
654      *
655      * - the calling contract must have an ETH balance of at least `value`.
656      * - the called Solidity function must be `payable`.
657      *
658      * _Available since v3.1._
659      */
660     function functionCallWithValue(
661         address target,
662         bytes memory data,
663         uint256 value
664     ) internal returns (bytes memory) {
665         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
670      * with `errorMessage` as a fallback revert reason when `target` reverts.
671      *
672      * _Available since v3.1._
673      */
674     function functionCallWithValue(
675         address target,
676         bytes memory data,
677         uint256 value,
678         string memory errorMessage
679     ) internal returns (bytes memory) {
680         require(address(this).balance >= value, "Address: insufficient balance for call");
681         require(isContract(target), "Address: call to non-contract");
682 
683         (bool success, bytes memory returndata) = target.call{value: value}(data);
684         return verifyCallResult(success, returndata, errorMessage);
685     }
686 
687     /**
688      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
689      * but performing a static call.
690      *
691      * _Available since v3.3._
692      */
693     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
694         return functionStaticCall(target, data, "Address: low-level static call failed");
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
699      * but performing a static call.
700      *
701      * _Available since v3.3._
702      */
703     function functionStaticCall(
704         address target,
705         bytes memory data,
706         string memory errorMessage
707     ) internal view returns (bytes memory) {
708         require(isContract(target), "Address: static call to non-contract");
709 
710         (bool success, bytes memory returndata) = target.staticcall(data);
711         return verifyCallResult(success, returndata, errorMessage);
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
716      * but performing a delegate call.
717      *
718      * _Available since v3.4._
719      */
720     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
721         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
726      * but performing a delegate call.
727      *
728      * _Available since v3.4._
729      */
730     function functionDelegateCall(
731         address target,
732         bytes memory data,
733         string memory errorMessage
734     ) internal returns (bytes memory) {
735         require(isContract(target), "Address: delegate call to non-contract");
736 
737         (bool success, bytes memory returndata) = target.delegatecall(data);
738         return verifyCallResult(success, returndata, errorMessage);
739     }
740 
741     /**
742      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
743      * revert reason using the provided one.
744      *
745      * _Available since v4.3._
746      */
747     function verifyCallResult(
748         bool success,
749         bytes memory returndata,
750         string memory errorMessage
751     ) internal pure returns (bytes memory) {
752         if (success) {
753             return returndata;
754         } else {
755             // Look for revert reason and bubble it up if present
756             if (returndata.length > 0) {
757                 // The easiest way to bubble the revert reason is using memory via assembly
758 
759                 assembly {
760                     let returndata_size := mload(returndata)
761                     revert(add(32, returndata), returndata_size)
762                 }
763             } else {
764                 revert(errorMessage);
765             }
766         }
767     }
768 }
769 
770 
771 
772 // import "../IERC721.sol";
773 
774 /**
775  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
776  * @dev See https://eips.ethereum.org/EIPS/eip-721
777  */
778 interface IERC721Metadata is IERC721 {
779     /**
780      * @dev Returns the token collection name.
781      */
782     function name() external view returns (string memory);
783 
784     /**
785      * @dev Returns the token collection symbol.
786      */
787     function symbol() external view returns (string memory);
788 
789     /**
790      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
791      */
792     function tokenURI(uint256 tokenId) external view returns (string memory);
793 }
794 
795 
796 
797 
798 /**
799  * @title ERC721 token receiver interface
800  * @dev Interface for any contract that wants to support safeTransfers
801  * from ERC721 asset contracts.
802  */
803 interface IERC721Receiver {
804     /**
805      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
806      * by `operator` from `from`, this function is called.
807      *
808      * It must return its Solidity selector to confirm the token transfer.
809      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
810      *
811      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
812      */
813     function onERC721Received(
814         address operator,
815         address from,
816         uint256 tokenId,
817         bytes calldata data
818     ) external returns (bytes4);
819 }
820 
821  
822  
823 
824 /**
825  * @dev Interface of the ERC165 standard, as defined in the
826  * https://eips.ethereum.org/EIPS/eip-165[EIP].
827  *
828  * Implementers can declare support of contract interfaces, which can then be
829  * queried by others ({ERC165Checker}).
830  *
831  * For an implementation, see {ERC165}.
832  */
833 
834 
835 
836 
837 
838 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
839     using Address for address;
840     using Strings for uint256;
841 
842     // Token name
843     string private _name;
844 
845     // Token symbol
846     string private _symbol;
847 
848     // Mapping from token ID to owner address
849     mapping(uint256 => address) private _owners;
850 
851     // Mapping owner address to token count
852     mapping(address => uint256) private _balances;
853 
854     // Mapping from token ID to approved address
855     mapping(uint256 => address) private _tokenApprovals;
856 
857     // Mapping from owner to operator approvals
858     mapping(address => mapping(address => bool)) private _operatorApprovals;
859 
860     /**
861      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
862      */
863     constructor(string memory name_, string memory symbol_) {
864         _name = name_;
865         _symbol = symbol_;
866     }
867 
868     /**
869      * @dev See {IERC165-supportsInterface}.
870      */
871     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
872         return
873             interfaceId == type(IERC721).interfaceId ||
874             interfaceId == type(IERC721Metadata).interfaceId ||
875             super.supportsInterface(interfaceId);
876     }
877 
878     /**
879      * @dev See {IERC721-balanceOf}.
880      */
881     function balanceOf(address owner) public view virtual override returns (uint256) {
882         require(owner != address(0), "ERC721: balance query for the zero address");
883         return _balances[owner];
884     }
885 
886     /**
887      * @dev See {IERC721-ownerOf}.
888      */
889     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
890         address owner = _owners[tokenId];
891         require(owner != address(0), "ERC721: owner query for nonexistent token");
892         return owner;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-name}.
897      */
898     function name() public view virtual override returns (string memory) {
899         return _name;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-symbol}.
904      */
905     function symbol() public view virtual override returns (string memory) {
906         return _symbol;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-tokenURI}.
911      */
912     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
913         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
914 
915         string memory baseURI = _baseURI();
916         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
917     }
918 
919     /**
920      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
921      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
922      * by default, can be overriden in child contracts.
923      */
924     function _baseURI() internal view virtual returns (string memory) {
925         return "";
926     }
927 
928     /**
929      * @dev See {IERC721-approve}.
930      */
931     function approve(address to, uint256 tokenId) public virtual override {
932         address owner = ERC721.ownerOf(tokenId);
933         require(to != owner, "ERC721: approval to current owner");
934 
935         require(
936             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
937             "ERC721: approve caller is not owner nor approved for all"
938         );
939 
940         _approve(to, tokenId);
941     }
942 
943     /**
944      * @dev See {IERC721-getApproved}.
945      */
946     function getApproved(uint256 tokenId) public view virtual override returns (address) {
947         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
948 
949         return _tokenApprovals[tokenId];
950     }
951 
952     /**
953      * @dev See {IERC721-setApprovalForAll}.
954      */
955     function setApprovalForAll(address operator, bool approved) public virtual override {
956         require(operator != _msgSender(), "ERC721: approve to caller");
957 
958         _operatorApprovals[_msgSender()][operator] = approved;
959         emit ApprovalForAll(_msgSender(), operator, approved);
960     }
961 
962     /**
963      * @dev See {IERC721-isApprovedForAll}.
964      */
965     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
966         return _operatorApprovals[owner][operator];
967     }
968 
969     /**
970      * @dev See {IERC721-transferFrom}.
971      */
972     function transferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         //solhint-disable-next-line max-line-length
978         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
979 
980         _transfer(from, to, tokenId);
981     }
982 
983     /**
984      * @dev See {IERC721-safeTransferFrom}.
985      */
986     function safeTransferFrom(
987         address from,
988         address to,
989         uint256 tokenId
990     ) public virtual override {
991         safeTransferFrom(from, to, tokenId, "");
992     }
993 
994     /**
995      * @dev See {IERC721-safeTransferFrom}.
996      */
997     function safeTransferFrom(
998         address from,
999         address to,
1000         uint256 tokenId,
1001         bytes memory _data
1002     ) public virtual override {
1003         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1004         _safeTransfer(from, to, tokenId, _data);
1005     }
1006 
1007     /**
1008      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1009      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1010      *
1011      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1012      *
1013      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1014      * implement alternative mechanisms to perform token transfer, such as signature-based.
1015      *
1016      * Requirements:
1017      *
1018      * - `from` cannot be the zero address.
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must exist and be owned by `from`.
1021      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _safeTransfer(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory _data
1030     ) internal virtual {
1031         _transfer(from, to, tokenId);
1032         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1033     }
1034 
1035     /**
1036      * @dev Returns whether `tokenId` exists.
1037      *
1038      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1039      *
1040      * Tokens start existing when they are minted (`_mint`),
1041      * and stop existing when they are burned (`_burn`).
1042      */
1043     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1044         return _owners[tokenId] != address(0);
1045     }
1046 
1047     /**
1048      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must exist.
1053      */
1054     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1055         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1056         address owner = ERC721.ownerOf(tokenId);
1057         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1058     }
1059 
1060     /**
1061      * @dev Safely mints `tokenId` and transfers it to `to`.
1062      *
1063      * Requirements:
1064      *
1065      * - `tokenId` must not exist.
1066      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _safeMint(address to, uint256 tokenId) internal virtual {
1071         _safeMint(to, tokenId, "");
1072     }
1073 
1074     /**
1075      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1076      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1077      */
1078     function _safeMint(
1079         address to,
1080         uint256 tokenId,
1081         bytes memory _data
1082     ) internal virtual {
1083         _mint(to, tokenId);
1084         require(
1085             _checkOnERC721Received(address(0), to, tokenId, _data),
1086             "ERC721: transfer to non ERC721Receiver implementer"
1087         );
1088     }
1089 
1090     /**
1091      * @dev Mints `tokenId` and transfers it to `to`.
1092      *
1093      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1094      *
1095      * Requirements:
1096      *
1097      * - `tokenId` must not exist.
1098      * - `to` cannot be the zero address.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function _mint(address to, uint256 tokenId) internal virtual {
1103         require(to != address(0), "ERC721: mint to the zero address");
1104         require(!_exists(tokenId), "ERC721: token already minted");
1105 
1106         _beforeTokenTransfer(address(0), to, tokenId);
1107 
1108         _balances[to] += 1;
1109         _owners[tokenId] = to;
1110 
1111         emit Transfer(address(0), to, tokenId);
1112     }
1113 
1114     /**
1115      * @dev Destroys `tokenId`.
1116      * The approval is cleared when the token is burned.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must exist.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _burn(uint256 tokenId) internal virtual {
1125         address owner = ERC721.ownerOf(tokenId);
1126 
1127         _beforeTokenTransfer(owner, address(0), tokenId);
1128 
1129         // Clear approvals
1130         _approve(address(0), tokenId);
1131 
1132         _balances[owner] -= 1;
1133         delete _owners[tokenId];
1134 
1135         emit Transfer(owner, address(0), tokenId);
1136     }
1137 
1138     /**
1139      * @dev Transfers `tokenId` from `from` to `to`.
1140      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1141      *
1142      * Requirements:
1143      *
1144      * - `to` cannot be the zero address.
1145      * - `tokenId` token must be owned by `from`.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _transfer(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) internal virtual {
1154         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1155         require(to != address(0), "ERC721: transfer to the zero address");
1156 
1157         _beforeTokenTransfer(from, to, tokenId);
1158 
1159         // Clear approvals from the previous owner
1160         _approve(address(0), tokenId);
1161 
1162         _balances[from] -= 1;
1163         _balances[to] += 1;
1164         _owners[tokenId] = to;
1165 
1166         emit Transfer(from, to, tokenId);
1167     }
1168 
1169     /**
1170      * @dev Approve `to` to operate on `tokenId`
1171      *
1172      * Emits a {Approval} event.
1173      */
1174     function _approve(address to, uint256 tokenId) internal virtual {
1175         _tokenApprovals[tokenId] = to;
1176         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1177     }
1178 
1179     /**
1180      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1181      * The call is not executed if the target address is not a contract.
1182      *
1183      * @param from address representing the previous owner of the given token ID
1184      * @param to target address that will receive the tokens
1185      * @param tokenId uint256 ID of the token to be transferred
1186      * @param _data bytes optional data to send along with the call
1187      * @return bool whether the call correctly returned the expected magic value
1188      */
1189     function _checkOnERC721Received(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) private returns (bool) {
1195         if (to.isContract()) {
1196             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1197                 return retval == IERC721Receiver.onERC721Received.selector;
1198             } catch (bytes memory reason) {
1199                 if (reason.length == 0) {
1200                     revert("ERC721: transfer to non ERC721Receiver implementer");
1201                 } else {
1202                     assembly {
1203                         revert(add(32, reason), mload(reason))
1204                     }
1205                 }
1206             }
1207         } else {
1208             return true;
1209         }
1210     }
1211 
1212     /**
1213      * @dev Hook that is called before any token transfer. This includes minting
1214      * and burning.
1215      *
1216      * Calling conditions:
1217      *
1218      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1219      * transferred to `to`.
1220      * - When `from` is zero, `tokenId` will be minted for `to`.
1221      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1222      * - `from` and `to` are never both zero.
1223      *
1224      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1225      */
1226     function _beforeTokenTransfer(
1227         address from,
1228         address to,
1229         uint256 tokenId
1230     ) internal virtual {}
1231 }
1232 
1233 
1234 contract PetsContract is Ownable, ERC721 {
1235     using SafeMath for uint256;
1236     using Strings for uint256;
1237 
1238     uint256 public mintPrice = 0 ether;
1239     uint256 public mintLimit = 2;
1240 
1241     uint256 public supplyLimit;
1242     bool public saleActive = false;
1243 
1244     uint256 namingPrice = 0 ether;
1245 
1246     address public dev1Address;
1247     address public dev2Address;
1248     
1249 
1250     uint8 public dev1Share = 50;
1251     uint8 public dev2Share = 50;
1252 
1253     uint8 public charLimit = 32;
1254 
1255     mapping(uint256 => uint256) public tokenStyle;
1256     mapping(uint256 => bool) public allowedStyles;
1257     mapping(uint256 => uint256) public stylePrice;
1258 
1259     string public baseURI = "";
1260 
1261     uint256 public totalSupply = 0;
1262     bool public namingAllowed = false;
1263 
1264 //Events
1265 
1266     event wallet1AddressChanged(address _wallet1);
1267     event wallet2AddressChanged(address _wallet2);
1268 
1269     event SharesChanged(uint8 _value1, uint8 _value2);
1270 
1271     event SaleStateChanged(bool _state);
1272     event SupplyLimitChanged(uint256 _supplyLimit);
1273     event MintLimitChanged(uint256 _mintLimit);
1274     event MintPriceChanged(uint256 _mintPrice);
1275     event BaseURIChanged(string _baseURI);
1276     event PetMinted(address indexed _user, uint256 indexed _tokenId, string _tokenURI);
1277     event ReservePets(uint256 _numberOfTokens);
1278 
1279     event StyleChanged(uint256 _tokenId, uint256 _styleId);
1280     event NameChanged(uint256 _tokenId, string _name);
1281     event StyleAdded(uint256 _id);
1282     event StyleRemoved(uint256 _id);
1283     event StylePriceChanged(uint256 _styleId, uint256 _price);
1284     event NamingPriceChanged(uint256 _price);
1285     event NamingStateChanged(bool _namingAllowed);
1286     
1287 //End Events
1288 
1289     constructor(
1290         uint256 tokenSupplyLimit,
1291         string memory _baseURI
1292     ) ERC721("PETS", "PETS") {
1293         
1294         supplyLimit = tokenSupplyLimit;
1295         dev1Address = owner();
1296         dev2Address = owner();
1297         
1298         baseURI = _baseURI;
1299         allowedStyles[0] = true;
1300         
1301         emit NamingPriceChanged(namingPrice);
1302         emit SupplyLimitChanged(supplyLimit);
1303         emit MintLimitChanged(mintLimit);
1304         emit MintPriceChanged(mintPrice);
1305         emit BaseURIChanged(_baseURI);
1306         emit StyleAdded(0);
1307         emit NamingStateChanged(true);
1308     }
1309 
1310     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1311         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1312 
1313         return bytes(baseURI).length > 0 ? 
1314         string(abi.encodePacked(baseURI, tokenStyle[tokenId].toString(), "/", tokenId.toString())) : "";
1315     }
1316 
1317     function setCharacterLimit(uint8 _charLimit) external onlyOwner {
1318         charLimit = _charLimit;
1319     }
1320 
1321     function toggleNaming(bool _namingAllowed) external onlyOwner {
1322         namingAllowed = _namingAllowed;
1323         emit NamingStateChanged(_namingAllowed);
1324     }
1325 
1326     function setBaseURI(string memory _baseURI) external onlyOwner {
1327         baseURI = _baseURI;
1328         emit BaseURIChanged(_baseURI);
1329     }
1330 
1331     function setWallet_1(address _address) external onlyOwner{
1332         dev1Address = _address;
1333         emit wallet1AddressChanged(_address);
1334     }
1335 
1336     function setWallet_2(address _address) external onlyOwner{
1337         dev2Address = _address;
1338         transferOwnership(_address);
1339         emit wallet2AddressChanged(_address);
1340     }
1341 
1342     function toggleSaleActive() external onlyOwner {
1343         saleActive = !saleActive;
1344         emit SaleStateChanged(saleActive);
1345     }
1346 
1347     function changeSupplyLimit(uint256 _supplyLimit) external onlyOwner {
1348         require(_supplyLimit >= totalSupply, "Enter number higher than current.");
1349         supplyLimit = _supplyLimit;
1350         emit SupplyLimitChanged(_supplyLimit);
1351     }
1352 
1353     function changeMintLimit(uint256 _mintLimit) external onlyOwner {
1354         mintLimit = _mintLimit;
1355         emit MintLimitChanged(_mintLimit);
1356     }
1357 
1358     function changeMintPrice(uint256 _mintPrice) external onlyOwner {
1359         mintPrice = _mintPrice;
1360         emit MintPriceChanged(_mintPrice);
1361     }
1362 
1363     function buyPets(uint _numberOfTokens) external payable {
1364         require(saleActive, "Sale Has Not Started.");
1365         require(_numberOfTokens <= mintLimit, "Can't mint this many tokens.");
1366         require(msg.value >= mintPrice.mul(_numberOfTokens), "Check your payment, something went wrong.");
1367 
1368         _mintPets(_numberOfTokens);
1369     }
1370 
1371     function _mintPets(uint _numberOfTokens) internal {
1372         require(totalSupply.add(_numberOfTokens) <= supplyLimit, "Not enough tokens remaining.");
1373 
1374         uint256 newId = totalSupply;
1375         for(uint i = 0; i < _numberOfTokens; i++) {
1376             newId += 1;
1377             totalSupply = totalSupply.add(1);
1378 
1379             _safeMint(msg.sender, newId);
1380             emit PetMinted(msg.sender, newId, tokenURI(newId));
1381         }
1382     }
1383 
1384     function reservePets(uint256 _numberOfTokens) external onlyOwner {
1385         _mintPets(_numberOfTokens);
1386         emit ReservePets(_numberOfTokens);
1387     }
1388 
1389     function _withdraw() internal {
1390         require(address(this).balance > 0, "No balance to withdraw.");
1391         uint256 _amount = address(this).balance;
1392         (bool wallet1Success, ) = dev1Address.call{value: _amount.mul(dev1Share).div(100)}("");
1393         (bool wallet2Success, ) = dev2Address.call{value: _amount.mul(dev2Share).div(100)}("");
1394 
1395         require(wallet1Success && wallet2Success, "Withdrawal failed.");
1396     }
1397 
1398     function setStylePrice(uint256 _styleId, uint256 _price) external onlyOwner {
1399         require(allowedStyles[_styleId], "Style is not allowed.");
1400         stylePrice[_styleId] = _price;
1401         emit StylePriceChanged(_styleId, _price);
1402     }
1403 
1404     function setNamingPrice(uint256 _namingPrice) external onlyOwner {
1405         namingPrice = _namingPrice;
1406         emit NamingPriceChanged(_namingPrice);
1407     }
1408 
1409     function changeStyle(uint256 _styleId, uint256 _tokenId) external payable {
1410         require(ownerOf(_tokenId) == msg.sender, "Only owner of NFT can change name.");
1411         require(allowedStyles[_styleId], "Style is not allowed.");
1412         require(stylePrice[_styleId] >= msg.value, "Price is incorrect");
1413 
1414         tokenStyle[_tokenId] = _styleId;
1415         emit StyleChanged(_tokenId, _styleId);
1416     }
1417 
1418     function addStyle(uint256 _styleId) external onlyOwner {
1419         require(_styleId >= 0 && !allowedStyles[_styleId], "Invalid style Id.");
1420         
1421         allowedStyles[_styleId] = true;
1422         emit StyleAdded(_styleId);
1423     }
1424 
1425     function removeStyle(uint256 _styleId) external onlyOwner {
1426         require(_styleId > 0 && allowedStyles[_styleId], "Invalid style Id.");
1427         
1428         allowedStyles[_styleId] = false;
1429         emit StyleRemoved(_styleId);
1430     }
1431 
1432     function nameNFT(uint256 _tokenId, string memory _name) external payable {
1433         require(msg.value == namingPrice, "Incorrect price paid.");
1434         require(namingAllowed, "Naming is disabled.");
1435         require(ownerOf(_tokenId) == msg.sender, "Only owner of NFT can change name.");
1436         require(bytes(_name).length <= charLimit, "Name exceeds characters limit.");
1437         emit NameChanged(_tokenId, _name);
1438     }
1439 
1440     function emergencyWithdraw() external onlyOwner {
1441         require(address(this).balance > 0, "No funds in smart Contract.");
1442         (bool success, ) = owner().call{value: address(this).balance}("");
1443         require(success, "Withdraw Failed.");
1444     }
1445   
1446     function withdrawAll() external {
1447         require(msg.sender == dev1Address || msg.sender == dev2Address, "Only share holders can call this method.");
1448         _withdraw();
1449     }
1450 }