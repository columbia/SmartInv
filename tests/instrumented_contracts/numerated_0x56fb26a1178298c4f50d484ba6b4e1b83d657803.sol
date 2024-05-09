1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _setOwner(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _setOwner(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _setOwner(newOwner);
85     }
86 
87     function _setOwner(address newOwner) private {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations.
97  *
98  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
99  * now has built in overflow checking.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, with an overflow flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         unchecked {
109             uint256 c = a + b;
110             if (c < a) return (false, 0);
111             return (true, c);
112         }
113     }
114 
115     /**
116      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
117      *
118      * _Available since v3.4._
119      */
120     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
121         unchecked {
122             if (b > a) return (false, 0);
123             return (true, a - b);
124         }
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         unchecked {
134             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135             // benefit is lost if 'b' is also tested.
136             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
137             if (a == 0) return (true, 0);
138             uint256 c = a * b;
139             if (c / a != b) return (false, 0);
140             return (true, c);
141         }
142     }
143 
144     /**
145      * @dev Returns the division of two unsigned integers, with a division by zero flag.
146      *
147      * _Available since v3.4._
148      */
149     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
150         unchecked {
151             if (b == 0) return (false, 0);
152             return (true, a / b);
153         }
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         unchecked {
163             if (b == 0) return (false, 0);
164             return (true, a % b);
165         }
166     }
167 
168     /**
169      * @dev Returns the addition of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `+` operator.
173      *
174      * Requirements:
175      *
176      * - Addition cannot overflow.
177      */
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a + b;
180     }
181 
182     /**
183      * @dev Returns the subtraction of two unsigned integers, reverting on
184      * overflow (when the result is negative).
185      *
186      * Counterpart to Solidity's `-` operator.
187      *
188      * Requirements:
189      *
190      * - Subtraction cannot overflow.
191      */
192     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
193         return a - b;
194     }
195 
196     /**
197      * @dev Returns the multiplication of two unsigned integers, reverting on
198      * overflow.
199      *
200      * Counterpart to Solidity's `*` operator.
201      *
202      * Requirements:
203      *
204      * - Multiplication cannot overflow.
205      */
206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207         return a * b;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers, reverting on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator.
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         return a / b;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * reverting when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return a % b;
238     }
239 
240     /**
241      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
242      * overflow (when the result is negative).
243      *
244      * CAUTION: This function is deprecated because it requires allocating memory for the error
245      * message unnecessarily. For custom revert reasons use {trySub}.
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(
254         uint256 a,
255         uint256 b,
256         string memory errorMessage
257     ) internal pure returns (uint256) {
258         unchecked {
259             require(b <= a, errorMessage);
260             return a - b;
261         }
262     }
263 
264     /**
265      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
266      * division by zero. The result is rounded towards zero.
267      *
268      * Counterpart to Solidity's `/` operator. Note: this function uses a
269      * `revert` opcode (which leaves remaining gas untouched) while Solidity
270      * uses an invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function div(
277         uint256 a,
278         uint256 b,
279         string memory errorMessage
280     ) internal pure returns (uint256) {
281         unchecked {
282             require(b > 0, errorMessage);
283             return a / b;
284         }
285     }
286 
287     /**
288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289      * reverting with custom message when dividing by zero.
290      *
291      * CAUTION: This function is deprecated because it requires allocating memory for the error
292      * message unnecessarily. For custom revert reasons use {tryMod}.
293      *
294      * Counterpart to Solidity's `%` operator. This function uses a `revert`
295      * opcode (which leaves remaining gas untouched) while Solidity uses an
296      * invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      *
300      * - The divisor cannot be zero.
301      */
302     function mod(
303         uint256 a,
304         uint256 b,
305         string memory errorMessage
306     ) internal pure returns (uint256) {
307         unchecked {
308             require(b > 0, errorMessage);
309             return a % b;
310         }
311     }
312 }
313 
314 /**
315  * @dev Interface of the ERC165 standard, as defined in the
316  * https://eips.ethereum.org/EIPS/eip-165[EIP].
317  *
318  * Implementers can declare support of contract interfaces, which can then be
319  * queried by others ({ERC165Checker}).
320  *
321  * For an implementation, see {ERC165}.
322  */
323 interface IERC165 {
324     /**
325      * @dev Returns true if this contract implements the interface defined by
326      * `interfaceId`. See the corresponding
327      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
328      * to learn more about how these ids are created.
329      *
330      * This function call must use less than 30 000 gas.
331      */
332     function supportsInterface(bytes4 interfaceId) external view returns (bool);
333 }
334 
335 /**
336  * @dev Required interface of an ERC721 compliant contract.
337  */
338 interface IERC721 is IERC165 {
339     /**
340      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
341      */
342     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
343 
344     /**
345      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
346      */
347     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
348 
349     /**
350      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
351      */
352     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
353 
354     /**
355      * @dev Returns the number of tokens in ``owner``'s account.
356      */
357     function balanceOf(address owner) external view returns (uint256 balance);
358 
359     /**
360      * @dev Returns the owner of the `tokenId` token.
361      *
362      * Requirements:
363      *
364      * - `tokenId` must exist.
365      */
366     function ownerOf(uint256 tokenId) external view returns (address owner);
367 
368     /**
369      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
370      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
371      *
372      * Requirements:
373      *
374      * - `from` cannot be the zero address.
375      * - `to` cannot be the zero address.
376      * - `tokenId` token must exist and be owned by `from`.
377      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
378      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
379      *
380      * Emits a {Transfer} event.
381      */
382     function safeTransferFrom(
383         address from,
384         address to,
385         uint256 tokenId
386     ) external;
387 
388     /**
389      * @dev Transfers `tokenId` token from `from` to `to`.
390      *
391      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
392      *
393      * Requirements:
394      *
395      * - `from` cannot be the zero address.
396      * - `to` cannot be the zero address.
397      * - `tokenId` token must be owned by `from`.
398      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transferFrom(
403         address from,
404         address to,
405         uint256 tokenId
406     ) external;
407 
408     /**
409      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
410      * The approval is cleared when the token is transferred.
411      *
412      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
413      *
414      * Requirements:
415      *
416      * - The caller must own the token or be an approved operator.
417      * - `tokenId` must exist.
418      *
419      * Emits an {Approval} event.
420      */
421     function approve(address to, uint256 tokenId) external;
422 
423     /**
424      * @dev Returns the account approved for `tokenId` token.
425      *
426      * Requirements:
427      *
428      * - `tokenId` must exist.
429      */
430     function getApproved(uint256 tokenId) external view returns (address operator);
431 
432     /**
433      * @dev Approve or remove `operator` as an operator for the caller.
434      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
435      *
436      * Requirements:
437      *
438      * - The `operator` cannot be the caller.
439      *
440      * Emits an {ApprovalForAll} event.
441      */
442     function setApprovalForAll(address operator, bool _approved) external;
443 
444     /**
445      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
446      *
447      * See {setApprovalForAll}
448      */
449     function isApprovedForAll(address owner, address operator) external view returns (bool);
450 
451     /**
452      * @dev Safely transfers `tokenId` token from `from` to `to`.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must exist and be owned by `from`.
459      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId,
468         bytes calldata data
469     ) external;
470 }
471 
472 
473 /**
474  * @title ERC721 token receiver interface
475  * @dev Interface for any contract that wants to support safeTransfers
476  * from ERC721 asset contracts.
477  */
478 interface IERC721Receiver {
479     /**
480      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
481      * by `operator` from `from`, this function is called.
482      *
483      * It must return its Solidity selector to confirm the token transfer.
484      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
485      *
486      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
487      */
488     function onERC721Received(
489         address operator,
490         address from,
491         uint256 tokenId,
492         bytes calldata data
493     ) external returns (bytes4);
494 }
495 
496 
497 /**
498  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
499  * @dev See https://eips.ethereum.org/EIPS/eip-721
500  */
501 interface IERC721Metadata is IERC721 {
502     /**
503      * @dev Returns the token collection name.
504      */
505     function name() external view returns (string memory);
506 
507     /**
508      * @dev Returns the token collection symbol.
509      */
510     function symbol() external view returns (string memory);
511 
512     /**
513      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
514      */
515     function tokenURI(uint256 tokenId) external view returns (string memory);
516 }
517 
518 
519 /**
520  * @dev Collection of functions related to the address type
521  */
522 library Address {
523     /**
524      * @dev Returns true if `account` is a contract.
525      *
526      * [IMPORTANT]
527      * ====
528      * It is unsafe to assume that an address for which this function returns
529      * false is an externally-owned account (EOA) and not a contract.
530      *
531      * Among others, `isContract` will return false for the following
532      * types of addresses:
533      *
534      *  - an externally-owned account
535      *  - a contract in construction
536      *  - an address where a contract will be created
537      *  - an address where a contract lived, but was destroyed
538      * ====
539      */
540     function isContract(address account) internal view returns (bool) {
541         // This method relies on extcodesize, which returns 0 for contracts in
542         // construction, since the code is only stored at the end of the
543         // constructor execution.
544 
545         uint256 size;
546         assembly {
547             size := extcodesize(account)
548         }
549         return size > 0;
550     }
551 
552     /**
553      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
554      * `recipient`, forwarding all available gas and reverting on errors.
555      *
556      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
557      * of certain opcodes, possibly making contracts go over the 2300 gas limit
558      * imposed by `transfer`, making them unable to receive funds via
559      * `transfer`. {sendValue} removes this limitation.
560      *
561      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
562      *
563      * IMPORTANT: because control is transferred to `recipient`, care must be
564      * taken to not create reentrancy vulnerabilities. Consider using
565      * {ReentrancyGuard} or the
566      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
567      */
568     function sendValue(address payable recipient, uint256 amount) internal {
569         require(address(this).balance >= amount, "Address: insufficient balance");
570 
571         (bool success, ) = recipient.call{value: amount}("");
572         require(success, "Address: unable to send value, recipient may have reverted");
573     }
574 
575     /**
576      * @dev Performs a Solidity function call using a low level `call`. A
577      * plain `call` is an unsafe replacement for a function call: use this
578      * function instead.
579      *
580      * If `target` reverts with a revert reason, it is bubbled up by this
581      * function (like regular Solidity function calls).
582      *
583      * Returns the raw returned data. To convert to the expected return value,
584      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
585      *
586      * Requirements:
587      *
588      * - `target` must be a contract.
589      * - calling `target` with `data` must not revert.
590      *
591      * _Available since v3.1._
592      */
593     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
594         return functionCall(target, data, "Address: low-level call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
599      * `errorMessage` as a fallback revert reason when `target` reverts.
600      *
601      * _Available since v3.1._
602      */
603     function functionCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         return functionCallWithValue(target, data, 0, errorMessage);
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
613      * but also transferring `value` wei to `target`.
614      *
615      * Requirements:
616      *
617      * - the calling contract must have an ETH balance of at least `value`.
618      * - the called Solidity function must be `payable`.
619      *
620      * _Available since v3.1._
621      */
622     function functionCallWithValue(
623         address target,
624         bytes memory data,
625         uint256 value
626     ) internal returns (bytes memory) {
627         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
632      * with `errorMessage` as a fallback revert reason when `target` reverts.
633      *
634      * _Available since v3.1._
635      */
636     function functionCallWithValue(
637         address target,
638         bytes memory data,
639         uint256 value,
640         string memory errorMessage
641     ) internal returns (bytes memory) {
642         require(address(this).balance >= value, "Address: insufficient balance for call");
643         require(isContract(target), "Address: call to non-contract");
644 
645         (bool success, bytes memory returndata) = target.call{value: value}(data);
646         return verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
651      * but performing a static call.
652      *
653      * _Available since v3.3._
654      */
655     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
656         return functionStaticCall(target, data, "Address: low-level static call failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
661      * but performing a static call.
662      *
663      * _Available since v3.3._
664      */
665     function functionStaticCall(
666         address target,
667         bytes memory data,
668         string memory errorMessage
669     ) internal view returns (bytes memory) {
670         require(isContract(target), "Address: static call to non-contract");
671 
672         (bool success, bytes memory returndata) = target.staticcall(data);
673         return verifyCallResult(success, returndata, errorMessage);
674     }
675 
676     /**
677      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
678      * but performing a delegate call.
679      *
680      * _Available since v3.4._
681      */
682     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
683         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
688      * but performing a delegate call.
689      *
690      * _Available since v3.4._
691      */
692     function functionDelegateCall(
693         address target,
694         bytes memory data,
695         string memory errorMessage
696     ) internal returns (bytes memory) {
697         require(isContract(target), "Address: delegate call to non-contract");
698 
699         (bool success, bytes memory returndata) = target.delegatecall(data);
700         return verifyCallResult(success, returndata, errorMessage);
701     }
702 
703     /**
704      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
705      * revert reason using the provided one.
706      *
707      * _Available since v4.3._
708      */
709     function verifyCallResult(
710         bool success,
711         bytes memory returndata,
712         string memory errorMessage
713     ) internal pure returns (bytes memory) {
714         if (success) {
715             return returndata;
716         } else {
717             // Look for revert reason and bubble it up if present
718             if (returndata.length > 0) {
719                 // The easiest way to bubble the revert reason is using memory via assembly
720 
721                 assembly {
722                     let returndata_size := mload(returndata)
723                     revert(add(32, returndata), returndata_size)
724                 }
725             } else {
726                 revert(errorMessage);
727             }
728         }
729     }
730 }
731 
732 
733 /**
734  * @dev String operations.
735  */
736 library Strings {
737     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
738 
739     /**
740      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
741      */
742     function toString(uint256 value) internal pure returns (string memory) {
743         // Inspired by OraclizeAPI's implementation - MIT licence
744         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
745 
746         if (value == 0) {
747             return "0";
748         }
749         uint256 temp = value;
750         uint256 digits;
751         while (temp != 0) {
752             digits++;
753             temp /= 10;
754         }
755         bytes memory buffer = new bytes(digits);
756         while (value != 0) {
757             digits -= 1;
758             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
759             value /= 10;
760         }
761         return string(buffer);
762     }
763 
764     /**
765      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
766      */
767     function toHexString(uint256 value) internal pure returns (string memory) {
768         if (value == 0) {
769             return "0x00";
770         }
771         uint256 temp = value;
772         uint256 length = 0;
773         while (temp != 0) {
774             length++;
775             temp >>= 8;
776         }
777         return toHexString(value, length);
778     }
779 
780     /**
781      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
782      */
783     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
784         bytes memory buffer = new bytes(2 * length + 2);
785         buffer[0] = "0";
786         buffer[1] = "x";
787         for (uint256 i = 2 * length + 1; i > 1; --i) {
788             buffer[i] = _HEX_SYMBOLS[value & 0xf];
789             value >>= 4;
790         }
791         require(value == 0, "Strings: hex length insufficient");
792         return string(buffer);
793     }
794 }
795 
796 /**
797  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
798  * the optional functions; to access them see {ERC20Detailed}.
799  */
800 interface IERC20 {
801     /**
802      * @dev Returns the amount of tokens in existence.
803      */
804     function totalSupply() external view returns (uint256);
805 
806     /**
807      * @dev Returns the amount of tokens owned by `account`.
808      */
809     function balanceOf(address account) external view returns (uint256);
810 
811     /**
812      * @dev Moves `amount` tokens from the caller's account to `recipient`.
813      *
814      * Returns a boolean value indicating whether the operation succeeded.
815      *
816      * Emits a {Transfer} event.
817      */
818     function transfer(address recipient, uint256 amount) external returns (bool);
819 
820     /**
821      * @dev Returns the remaining number of tokens that `spender` will be
822      * allowed to spend on behalf of `owner` through {transferFrom}. This is
823      * zero by default.
824      *
825      * This value changes when {approve} or {transferFrom} are called.
826      */
827     function allowance(address owner, address spender) external view returns (uint256);
828 
829     /**
830      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
831      *
832      * Returns a boolean value indicating whether the operation succeeded.
833      *
834      * IMPORTANT: Beware that changing an allowance with this method brings the risk
835      * that someone may use both the old and the new allowance by unfortunate
836      * transaction ordering. One possible solution to mitigate this race
837      * condition is to first reduce the spender's allowance to 0 and set the
838      * desired value afterwards:
839      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
840      *
841      * Emits an {Approval} event.
842      */
843     function approve(address spender, uint256 amount) external returns (bool);
844 
845     /**
846      * @dev Moves `amount` tokens from `sender` to `recipient` using the
847      * allowance mechanism. `amount` is then deducted from the caller's
848      * allowance.
849      *
850      * Returns a boolean value indicating whether the operation succeeded.
851      *
852      * Emits a {Transfer} event.
853      */
854     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
855 
856     /**
857      * @dev Emitted when `value` tokens are moved from one account (`from`) to
858      * another (`to`).
859      *
860      * Note that `value` may be zero.
861      */
862     event Transfer(address indexed from, address indexed to, uint256 value);
863 
864     /**
865      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
866      * a call to {approve}. `value` is the new allowance.
867      */
868     event Approval(address indexed owner, address indexed spender, uint256 value);
869 }
870 
871 /**
872  * @dev Implementation of the {IERC165} interface.
873  *
874  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
875  * for the additional interface id that will be supported. For example:
876  *
877  * ```solidity
878  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
879  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
880  * }
881  * ```
882  *
883  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
884  */
885 abstract contract ERC165 is IERC165 {
886     /**
887      * @dev See {IERC165-supportsInterface}.
888      */
889     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
890         return interfaceId == type(IERC165).interfaceId;
891     }
892 }
893 
894 
895 /**
896  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
897  * the Metadata extension, but not including the Enumerable extension, which is available separately as
898  * {ERC721Enumerable}.
899  */
900 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
901     using Address for address;
902     using Strings for uint256;
903 
904     // Token name
905     string private _name;
906 
907     // Token symbol
908     string private _symbol;
909 
910     // Mapping from token ID to owner address
911     mapping(uint256 => address) private _owners;
912 
913     // Mapping owner address to token count
914     mapping(address => uint256) private _balances;
915 
916     // Mapping from token ID to approved address
917     mapping(uint256 => address) private _tokenApprovals;
918 
919     // Mapping from owner to operator approvals
920     mapping(address => mapping(address => bool)) private _operatorApprovals;
921 
922     /**
923      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
924      */
925     constructor(string memory name_, string memory symbol_) {
926         _name = name_;
927         _symbol = symbol_;
928     }
929 
930     /**
931      * @dev See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
934         return
935             interfaceId == type(IERC721).interfaceId ||
936             interfaceId == type(IERC721Metadata).interfaceId ||
937             super.supportsInterface(interfaceId);
938     }
939 
940     /**
941      * @dev See {IERC721-balanceOf}.
942      */
943     function balanceOf(address owner) public view virtual override returns (uint256) {
944         require(owner != address(0), "ERC721: balance query for the zero address");
945         return _balances[owner];
946     }
947 
948     /**
949      * @dev See {IERC721-ownerOf}.
950      */
951     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
952         address owner = _owners[tokenId];
953         require(owner != address(0), "ERC721: owner query for nonexistent token");
954         return owner;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-name}.
959      */
960     function name() public view virtual override returns (string memory) {
961         return _name;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-symbol}.
966      */
967     function symbol() public view virtual override returns (string memory) {
968         return _symbol;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-tokenURI}.
973      */
974     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
975         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
976 
977         string memory baseURI = _baseURI();
978         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
979     }
980 
981     /**
982      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
983      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
984      * by default, can be overriden in child contracts.
985      */
986     function _baseURI() internal view virtual returns (string memory) {
987         return "";
988     }
989 
990     /**
991      * @dev See {IERC721-approve}.
992      */
993     function approve(address to, uint256 tokenId) public virtual override {
994         address owner = ERC721.ownerOf(tokenId);
995         require(to != owner, "ERC721: approval to current owner");
996 
997         require(
998             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
999             "ERC721: approve caller is not owner nor approved for all"
1000         );
1001 
1002         _approve(to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-getApproved}.
1007      */
1008     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1009         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1010 
1011         return _tokenApprovals[tokenId];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-setApprovalForAll}.
1016      */
1017     function setApprovalForAll(address operator, bool approved) public virtual override {
1018         require(operator != _msgSender(), "ERC721: approve to caller");
1019 
1020         _operatorApprovals[_msgSender()][operator] = approved;
1021         emit ApprovalForAll(_msgSender(), operator, approved);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-isApprovedForAll}.
1026      */
1027     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1028         return _operatorApprovals[owner][operator];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-transferFrom}.
1033      */
1034     function transferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) public virtual override {
1039         //solhint-disable-next-line max-line-length
1040         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1041 
1042         _transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-safeTransferFrom}.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) public virtual override {
1053         safeTransferFrom(from, to, tokenId, "");
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-safeTransferFrom}.
1058      */
1059     function safeTransferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId,
1063         bytes memory _data
1064     ) public virtual override {
1065         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1066         _safeTransfer(from, to, tokenId, _data);
1067     }
1068 
1069     /**
1070      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1071      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1072      *
1073      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1074      *
1075      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1076      * implement alternative mechanisms to perform token transfer, such as signature-based.
1077      *
1078      * Requirements:
1079      *
1080      * - `from` cannot be the zero address.
1081      * - `to` cannot be the zero address.
1082      * - `tokenId` token must exist and be owned by `from`.
1083      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _safeTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) internal virtual {
1093         _transfer(from, to, tokenId);
1094         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1095     }
1096 
1097     /**
1098      * @dev Returns whether `tokenId` exists.
1099      *
1100      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1101      *
1102      * Tokens start existing when they are minted (`_mint`),
1103      * and stop existing when they are burned (`_burn`).
1104      */
1105     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1106         return _owners[tokenId] != address(0);
1107     }
1108 
1109     /**
1110      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must exist.
1115      */
1116     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1117         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1118         address owner = ERC721.ownerOf(tokenId);
1119         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1120     }
1121 
1122     /**
1123      * @dev Safely mints `tokenId` and transfers it to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must not exist.
1128      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _safeMint(address to, uint256 tokenId) internal virtual {
1133         _safeMint(to, tokenId, "");
1134     }
1135 
1136     /**
1137      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1138      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1139      */
1140     function _safeMint(
1141         address to,
1142         uint256 tokenId,
1143         bytes memory _data
1144     ) internal virtual {
1145         _mint(to, tokenId);
1146         require(
1147             _checkOnERC721Received(address(0), to, tokenId, _data),
1148             "ERC721: transfer to non ERC721Receiver implementer"
1149         );
1150     }
1151 
1152     /**
1153      * @dev Mints `tokenId` and transfers it to `to`.
1154      *
1155      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must not exist.
1160      * - `to` cannot be the zero address.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _mint(address to, uint256 tokenId) internal virtual {
1165         require(to != address(0), "ERC721: mint to the zero address");
1166         require(!_exists(tokenId), "ERC721: token already minted");
1167 
1168         _beforeTokenTransfer(address(0), to, tokenId);
1169 
1170         _balances[to] += 1;
1171         _owners[tokenId] = to;
1172 
1173         emit Transfer(address(0), to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev Destroys `tokenId`.
1178      * The approval is cleared when the token is burned.
1179      *
1180      * Requirements:
1181      *
1182      * - `tokenId` must exist.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function _burn(uint256 tokenId) internal virtual {
1187         address owner = ERC721.ownerOf(tokenId);
1188 
1189         _beforeTokenTransfer(owner, address(0), tokenId);
1190 
1191         // Clear approvals
1192         _approve(address(0), tokenId);
1193 
1194         _balances[owner] -= 1;
1195         delete _owners[tokenId];
1196 
1197         emit Transfer(owner, address(0), tokenId);
1198     }
1199 
1200     /**
1201      * @dev Transfers `tokenId` from `from` to `to`.
1202      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1203      *
1204      * Requirements:
1205      *
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must be owned by `from`.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _transfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) internal virtual {
1216         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1217         require(to != address(0), "ERC721: transfer to the zero address");
1218 
1219         _beforeTokenTransfer(from, to, tokenId);
1220 
1221         // Clear approvals from the previous owner
1222         _approve(address(0), tokenId);
1223 
1224         _balances[from] -= 1;
1225         _balances[to] += 1;
1226         _owners[tokenId] = to;
1227 
1228         emit Transfer(from, to, tokenId);
1229     }
1230 
1231     /**
1232      * @dev Approve `to` to operate on `tokenId`
1233      *
1234      * Emits a {Approval} event.
1235      */
1236     function _approve(address to, uint256 tokenId) internal virtual {
1237         _tokenApprovals[tokenId] = to;
1238         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1239     }
1240 
1241     /**
1242      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1243      * The call is not executed if the target address is not a contract.
1244      *
1245      * @param from address representing the previous owner of the given token ID
1246      * @param to target address that will receive the tokens
1247      * @param tokenId uint256 ID of the token to be transferred
1248      * @param _data bytes optional data to send along with the call
1249      * @return bool whether the call correctly returned the expected magic value
1250      */
1251     function _checkOnERC721Received(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) private returns (bool) {
1257         if (to.isContract()) {
1258             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1259                 return retval == IERC721Receiver.onERC721Received.selector;
1260             } catch (bytes memory reason) {
1261                 if (reason.length == 0) {
1262                     revert("ERC721: transfer to non ERC721Receiver implementer");
1263                 } else {
1264                     assembly {
1265                         revert(add(32, reason), mload(reason))
1266                     }
1267                 }
1268             }
1269         } else {
1270             return true;
1271         }
1272     }
1273 
1274     /**
1275      * @dev Hook that is called before any token transfer. This includes minting
1276      * and burning.
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` will be minted for `to`.
1283      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1284      * - `from` and `to` are never both zero.
1285      *
1286      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1287      */
1288     function _beforeTokenTransfer(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) internal virtual {}
1293 }
1294 
1295 
1296 /**
1297  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1298  * @dev See https://eips.ethereum.org/EIPS/eip-721
1299  */
1300 interface IERC721Enumerable is IERC721 {
1301     /**
1302      * @dev Returns the total amount of tokens stored by the contract.
1303      */
1304     function totalSupply() external view returns (uint256);
1305 
1306     /**
1307      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1308      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1309      */
1310     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1311 
1312     /**
1313      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1314      * Use along with {totalSupply} to enumerate all tokens.
1315      */
1316     function tokenByIndex(uint256 index) external view returns (uint256);
1317 }
1318 
1319 /**
1320  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1321  * enumerability of all the token ids in the contract as well as all token ids owned by each
1322  * account.
1323  */
1324 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1325     // Mapping from owner to list of owned token IDs
1326     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1327 
1328     // Mapping from token ID to index of the owner tokens list
1329     mapping(uint256 => uint256) private _ownedTokensIndex;
1330 
1331     // Array with all token ids, used for enumeration
1332     uint256[] private _allTokens;
1333 
1334     // Mapping from token id to position in the allTokens array
1335     mapping(uint256 => uint256) private _allTokensIndex;
1336 
1337     /**
1338      * @dev See {IERC165-supportsInterface}.
1339      */
1340     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1341         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1342     }
1343 
1344     /**
1345      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1346      */
1347     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1348         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1349         return _ownedTokens[owner][index];
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Enumerable-totalSupply}.
1354      */
1355     function totalSupply() public view virtual override returns (uint256) {
1356         return _allTokens.length;
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Enumerable-tokenByIndex}.
1361      */
1362     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1363         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1364         return _allTokens[index];
1365     }
1366 
1367     /**
1368      * @dev Hook that is called before any token transfer. This includes minting
1369      * and burning.
1370      *
1371      * Calling conditions:
1372      *
1373      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1374      * transferred to `to`.
1375      * - When `from` is zero, `tokenId` will be minted for `to`.
1376      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1377      * - `from` cannot be the zero address.
1378      * - `to` cannot be the zero address.
1379      *
1380      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1381      */
1382     function _beforeTokenTransfer(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) internal virtual override {
1387         super._beforeTokenTransfer(from, to, tokenId);
1388 
1389         if (from == address(0)) {
1390             _addTokenToAllTokensEnumeration(tokenId);
1391         } else if (from != to) {
1392             _removeTokenFromOwnerEnumeration(from, tokenId);
1393         }
1394         if (to == address(0)) {
1395             _removeTokenFromAllTokensEnumeration(tokenId);
1396         } else if (to != from) {
1397             _addTokenToOwnerEnumeration(to, tokenId);
1398         }
1399     }
1400 
1401     /**
1402      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1403      * @param to address representing the new owner of the given token ID
1404      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1405      */
1406     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1407         uint256 length = ERC721.balanceOf(to);
1408         _ownedTokens[to][length] = tokenId;
1409         _ownedTokensIndex[tokenId] = length;
1410     }
1411 
1412     /**
1413      * @dev Private function to add a token to this extension's token tracking data structures.
1414      * @param tokenId uint256 ID of the token to be added to the tokens list
1415      */
1416     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1417         _allTokensIndex[tokenId] = _allTokens.length;
1418         _allTokens.push(tokenId);
1419     }
1420 
1421     /**
1422      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1423      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1424      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1425      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1426      * @param from address representing the previous owner of the given token ID
1427      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1428      */
1429     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1430         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1431         // then delete the last slot (swap and pop).
1432 
1433         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1434         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1435 
1436         // When the token to delete is the last token, the swap operation is unnecessary
1437         if (tokenIndex != lastTokenIndex) {
1438             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1439 
1440             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1441             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1442         }
1443 
1444         // This also deletes the contents at the last position of the array
1445         delete _ownedTokensIndex[tokenId];
1446         delete _ownedTokens[from][lastTokenIndex];
1447     }
1448 
1449     /**
1450      * @dev Private function to remove a token from this extension's token tracking data structures.
1451      * This has O(1) time complexity, but alters the order of the _allTokens array.
1452      * @param tokenId uint256 ID of the token to be removed from the tokens list
1453      */
1454     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1455         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1456         // then delete the last slot (swap and pop).
1457 
1458         uint256 lastTokenIndex = _allTokens.length - 1;
1459         uint256 tokenIndex = _allTokensIndex[tokenId];
1460 
1461         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1462         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1463         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1464         uint256 lastTokenId = _allTokens[lastTokenIndex];
1465 
1466         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1467         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1468 
1469         // This also deletes the contents at the last position of the array
1470         delete _allTokensIndex[tokenId];
1471         _allTokens.pop();
1472     }
1473 }
1474 
1475 contract DesktopStatusSystemsLimited is ERC721Enumerable, Ownable {
1476     
1477     using SafeMath for uint256;
1478     
1479     bool public mintingActive;
1480     uint256 public mintingPrice = .08 ether;
1481     uint256 public mintingPerTxLimit = 20;
1482     uint256 public mintingStartTimestamp;
1483     mapping(address => uint256) public numPurchased;
1484 
1485     uint256 public maxSupply = 11111;
1486     address public creator = 0x26e76280F0C4477726B8a1Dd9AC4996c5c7bADf8;
1487     
1488     string public baseURI;
1489     
1490     
1491     constructor(uint256 mintingStart, string memory _uri) ERC721("Desktop Statue Systems Limited", "DSSL") {
1492         mintingActive = false;
1493         mintingStartTimestamp = mintingStart;
1494         baseURI = _uri;
1495     }
1496     
1497     function amtPurchased(address buyer) public view returns (uint256){
1498         return numPurchased[buyer];
1499     }
1500 
1501     function mint(uint256 _amount) public payable {
1502         require(mintingActive == true, "Minting is currently inactive");
1503         require(mintingStartTimestamp <= block.timestamp, "Sale not started yet");
1504         require(_amount <= mintingPerTxLimit, "Amount exceeded tx limit");
1505         require(totalSupply().add(_amount) <= maxSupply, "This tx would exceed max supply");
1506         require(msg.value >= mintingPrice.mul(_amount), "Not enough ETH sent");
1507         require(amtPurchased(msg.sender) + _amount <= mintingPerTxLimit, "Cannot buy: Exceeds purchase limit!");
1508         uint256 tsupply = totalSupply();
1509 
1510         for(uint256 i = 0; i < _amount; i++) {
1511             _safeMint(msg.sender, tsupply + i);
1512         }
1513         numPurchased[msg.sender] += _amount;
1514     }
1515     
1516     function adminMint(address receiver, uint256 _amount) public onlyOwner {
1517         require(totalSupply().add(_amount) <= maxSupply, "This tx would exceed max supply");
1518         
1519         uint256 tsupply = totalSupply();
1520         for(uint256 i = 0; i < _amount; i++) {
1521             _safeMint(receiver, tsupply + i);
1522         }
1523         
1524     }
1525     
1526 
1527     /**
1528     * Set Base URI
1529     */
1530     function setBaseURI(string memory newBaseURI) public onlyOwner {
1531         baseURI = newBaseURI;
1532     }
1533     
1534     /**
1535      * Get the metadata for a given tokenId
1536      */
1537     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1538         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1539 
1540         return bytes(baseURI).length > 0
1541             ? string(abi.encodePacked(baseURI, Strings.toString(tokenId + 1), ".json"))
1542             : "";
1543     }
1544     
1545     function setMintingPrice(uint256 newMintingPrice) public onlyOwner {
1546         mintingPrice = newMintingPrice;
1547     }
1548 
1549     function setMintingActive(bool newMintingState) public onlyOwner {
1550         mintingActive = newMintingState;
1551     }
1552     
1553     function setMintingStart(uint256 mintingStart) public onlyOwner {
1554         mintingStartTimestamp = mintingStart;
1555     }
1556 
1557     function setMintingPerTxLimit(uint256 mintLimit) public onlyOwner {
1558         mintingPerTxLimit = mintLimit;
1559     }
1560     
1561     /**
1562      * Withdraw all funds from contract (Owner only)
1563      */
1564     function withdrawFunds(address recipient) public onlyOwner {
1565         uint toCreator = address(this).balance.div(10);
1566         payable(creator).transfer(toCreator);
1567         payable(recipient).transfer(address(this).balance);
1568     }
1569 
1570     function withdrawTokens(address _token,address _to,uint256 _amount) public onlyOwner {
1571         IERC20 token = IERC20(_token);
1572         token.transfer(_to, _amount);
1573     }
1574 }