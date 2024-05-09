1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations.
6  *
7  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
8  * now has built in overflow checking.
9  */
10 library SafeMath {
11     /**
12      * @dev Returns the addition of two unsigned integers, with an overflow flag.
13      *
14      * _Available since v3.4._
15      */
16     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
17         unchecked {
18             uint256 c = a + b;
19             if (c < a) return (false, 0);
20             return (true, c);
21         }
22     }
23 
24     /**
25      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
26      *
27      * _Available since v3.4._
28      */
29     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {
31             if (b > a) return (false, 0);
32             return (true, a - b);
33         }
34     }
35 
36     /**
37      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44             // benefit is lost if 'b' is also tested.
45             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
46             if (a == 0) return (true, 0);
47             uint256 c = a * b;
48             if (c / a != b) return (false, 0);
49             return (true, c);
50         }
51     }
52 
53     /**
54      * @dev Returns the division of two unsigned integers, with a division by zero flag.
55      *
56      * _Available since v3.4._
57      */
58     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b == 0) return (false, 0);
61             return (true, a / b);
62         }
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             if (b == 0) return (false, 0);
73             return (true, a % b);
74         }
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         return a + b;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a - b;
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `*` operator.
110      *
111      * Requirements:
112      *
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a * b;
117     }
118 
119     /**
120      * @dev Returns the integer division of two unsigned integers, reverting on
121      * division by zero. The result is rounded towards zero.
122      *
123      * Counterpart to Solidity's `/` operator.
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a / b;
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
135      * reverting when dividing by zero.
136      *
137      * Counterpart to Solidity's `%` operator. This function uses a `revert`
138      * opcode (which leaves remaining gas untouched) while Solidity uses an
139      * invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a % b;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * CAUTION: This function is deprecated because it requires allocating memory for the error
154      * message unnecessarily. For custom revert reasons use {trySub}.
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(
163         uint256 a,
164         uint256 b,
165         string memory errorMessage
166     ) internal pure returns (uint256) {
167         unchecked {
168             require(b <= a, errorMessage);
169             return a - b;
170         }
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(
186         uint256 a,
187         uint256 b,
188         string memory errorMessage
189     ) internal pure returns (uint256) {
190         unchecked {
191             require(b > 0, errorMessage);
192             return a / b;
193         }
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting with custom message when dividing by zero.
199      *
200      * CAUTION: This function is deprecated because it requires allocating memory for the error
201      * message unnecessarily. For custom revert reasons use {tryMod}.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(
212         uint256 a,
213         uint256 b,
214         string memory errorMessage
215     ) internal pure returns (uint256) {
216         unchecked {
217             require(b > 0, errorMessage);
218             return a % b;
219         }
220     }
221 }
222 
223 /**
224  * @dev Interface of the ERC165 standard, as defined in the
225  * https://eips.ethereum.org/EIPS/eip-165[EIP].
226  *
227  * Implementers can declare support of contract interfaces, which can then be
228  * queried by others ({ERC165Checker}).
229  *
230  * For an implementation, see {ERC165}.
231  */
232 interface IERC165 {
233     /**
234      * @dev Returns true if this contract implements the interface defined by
235      * `interfaceId`. See the corresponding
236      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
237      * to learn more about how these ids are created.
238      *
239      * This function call must use less than 30 000 gas.
240      */
241     function supportsInterface(bytes4 interfaceId) external view returns (bool);
242 }
243 
244 /**
245  * @dev Required interface of an ERC721 compliant contract.
246  */
247 interface IERC721 is IERC165 {
248     /**
249      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
252 
253     /**
254      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
255      */
256     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
257 
258     /**
259      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
260      */
261     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
262 
263     /**
264      * @dev Returns the number of tokens in ``owner``'s account.
265      */
266     function balanceOf(address owner) external view returns (uint256 balance);
267 
268     /**
269      * @dev Returns the owner of the `tokenId` token.
270      *
271      * Requirements:
272      *
273      * - `tokenId` must exist.
274      */
275     function ownerOf(uint256 tokenId) external view returns (address owner);
276 
277     /**
278      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
279      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
280      *
281      * Requirements:
282      *
283      * - `from` cannot be the zero address.
284      * - `to` cannot be the zero address.
285      * - `tokenId` token must exist and be owned by `from`.
286      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
287      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
288      *
289      * Emits a {Transfer} event.
290      */
291     function safeTransferFrom(
292         address from,
293         address to,
294         uint256 tokenId
295     ) external;
296 
297     /**
298      * @dev Transfers `tokenId` token from `from` to `to`.
299      *
300      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
301      *
302      * Requirements:
303      *
304      * - `from` cannot be the zero address.
305      * - `to` cannot be the zero address.
306      * - `tokenId` token must be owned by `from`.
307      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
308      *
309      * Emits a {Transfer} event.
310      */
311     function transferFrom(
312         address from,
313         address to,
314         uint256 tokenId
315     ) external;
316 
317     /**
318      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
319      * The approval is cleared when the token is transferred.
320      *
321      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
322      *
323      * Requirements:
324      *
325      * - The caller must own the token or be an approved operator.
326      * - `tokenId` must exist.
327      *
328      * Emits an {Approval} event.
329      */
330     function approve(address to, uint256 tokenId) external;
331 
332     /**
333      * @dev Returns the account approved for `tokenId` token.
334      *
335      * Requirements:
336      *
337      * - `tokenId` must exist.
338      */
339     function getApproved(uint256 tokenId) external view returns (address operator);
340 
341     /**
342      * @dev Approve or remove `operator` as an operator for the caller.
343      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
344      *
345      * Requirements:
346      *
347      * - The `operator` cannot be the caller.
348      *
349      * Emits an {ApprovalForAll} event.
350      */
351     function setApprovalForAll(address operator, bool _approved) external;
352 
353     /**
354      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
355      *
356      * See {setApprovalForAll}
357      */
358     function isApprovedForAll(address owner, address operator) external view returns (bool);
359 
360     /**
361      * @dev Safely transfers `tokenId` token from `from` to `to`.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `tokenId` token must exist and be owned by `from`.
368      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
369      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
370      *
371      * Emits a {Transfer} event.
372      */
373     function safeTransferFrom(
374         address from,
375         address to,
376         uint256 tokenId,
377         bytes calldata data
378     ) external;
379 }
380 
381 /**
382  * @dev String operations.
383  */
384 library Strings {
385     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
386 
387     /**
388      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
389      */
390     function toString(uint256 value) internal pure returns (string memory) {
391         // Inspired by OraclizeAPI's implementation - MIT licence
392         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
393 
394         if (value == 0) {
395             return "0";
396         }
397         uint256 temp = value;
398         uint256 digits;
399         while (temp != 0) {
400             digits++;
401             temp /= 10;
402         }
403         bytes memory buffer = new bytes(digits);
404         while (value != 0) {
405             digits -= 1;
406             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
407             value /= 10;
408         }
409         return string(buffer);
410     }
411 
412     /**
413      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
414      */
415     function toHexString(uint256 value) internal pure returns (string memory) {
416         if (value == 0) {
417             return "0x00";
418         }
419         uint256 temp = value;
420         uint256 length = 0;
421         while (temp != 0) {
422             length++;
423             temp >>= 8;
424         }
425         return toHexString(value, length);
426     }
427 
428     /**
429      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
430      */
431     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
432         bytes memory buffer = new bytes(2 * length + 2);
433         buffer[0] = "0";
434         buffer[1] = "x";
435         for (uint256 i = 2 * length + 1; i > 1; --i) {
436             buffer[i] = _HEX_SYMBOLS[value & 0xf];
437             value >>= 4;
438         }
439         require(value == 0, "Strings: hex length insufficient");
440         return string(buffer);
441     }
442 }
443 
444 /*
445  * @dev Provides information about the current execution context, including the
446  * sender of the transaction and its data. While these are generally available
447  * via msg.sender and msg.data, they should not be accessed in such a direct
448  * manner, since when dealing with meta-transactions the account sending and
449  * paying for execution may not be the actual sender (as far as an application
450  * is concerned).
451  *
452  * This contract is only required for intermediate, library-like contracts.
453  */
454 abstract contract Context {
455     function _msgSender() internal view virtual returns (address) {
456         return msg.sender;
457     }
458 
459     function _msgData() internal view virtual returns (bytes calldata) {
460         return msg.data;
461     }
462 }
463 
464 /**
465  * @dev Contract module which provides a basic access control mechanism, where
466  * there is an account (an owner) that can be granted exclusive access to
467  * specific functions.
468  *
469  * By default, the owner account will be the one that deploys the contract. This
470  * can later be changed with {transferOwnership}.
471  *
472  * This module is used through inheritance. It will make available the modifier
473  * `onlyOwner`, which can be applied to your functions to restrict their use to
474  * the owner.
475  */
476 abstract contract Ownable is Context {
477     address private _owner;
478 
479     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
480 
481     /**
482      * @dev Initializes the contract setting the deployer as the initial owner.
483      */
484     constructor() {
485         _setOwner(_msgSender());
486     }
487 
488     /**
489      * @dev Returns the address of the current owner.
490      */
491     function owner() public view virtual returns (address) {
492         return _owner;
493     }
494 
495     /**
496      * @dev Throws if called by any account other than the owner.
497      */
498     modifier onlyOwner() {
499         require(owner() == _msgSender(), "Ownable: caller is not the owner");
500         _;
501     }
502 
503     /**
504      * @dev Leaves the contract without owner. It will not be possible to call
505      * `onlyOwner` functions anymore. Can only be called by the current owner.
506      *
507      * NOTE: Renouncing ownership will leave the contract without an owner,
508      * thereby removing any functionality that is only available to the owner.
509      */
510     function renounceOwnership() public virtual onlyOwner {
511         _setOwner(address(0));
512     }
513 
514     /**
515      * @dev Transfers ownership of the contract to a new account (`newOwner`).
516      * Can only be called by the current owner.
517      */
518     function transferOwnership(address newOwner) public virtual onlyOwner {
519         require(newOwner != address(0), "Ownable: new owner is the zero address");
520         _setOwner(newOwner);
521     }
522 
523     function _setOwner(address newOwner) private {
524         address oldOwner = _owner;
525         _owner = newOwner;
526         emit OwnershipTransferred(oldOwner, newOwner);
527     }
528 }
529 
530 /**
531  * @title ERC721 token receiver interface
532  * @dev Interface for any contract that wants to support safeTransfers
533  * from ERC721 asset contracts.
534  */
535 interface IERC721Receiver {
536     /**
537      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
538      * by `operator` from `from`, this function is called.
539      *
540      * It must return its Solidity selector to confirm the token transfer.
541      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
542      *
543      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
544      */
545     function onERC721Received(
546         address operator,
547         address from,
548         uint256 tokenId,
549         bytes calldata data
550     ) external returns (bytes4);
551 }
552 
553 /**
554  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
555  * @dev See https://eips.ethereum.org/EIPS/eip-721
556  */
557 interface IERC721Metadata is IERC721 {
558     /**
559      * @dev Returns the token collection name.
560      */
561     function name() external view returns (string memory);
562 
563     /**
564      * @dev Returns the token collection symbol.
565      */
566     function symbol() external view returns (string memory);
567 
568     /**
569      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
570      */
571     function tokenURI(uint256 tokenId) external view returns (string memory);
572 }
573 
574 /**
575  * @dev Collection of functions related to the address type
576  */
577 library Address {
578     /**
579      * @dev Returns true if `account` is a contract.
580      *
581      * [IMPORTANT]
582      * ====
583      * It is unsafe to assume that an address for which this function returns
584      * false is an externally-owned account (EOA) and not a contract.
585      *
586      * Among others, `isContract` will return false for the following
587      * types of addresses:
588      *
589      *  - an externally-owned account
590      *  - a contract in construction
591      *  - an address where a contract will be created
592      *  - an address where a contract lived, but was destroyed
593      * ====
594      */
595     function isContract(address account) internal view returns (bool) {
596         // This method relies on extcodesize, which returns 0 for contracts in
597         // construction, since the code is only stored at the end of the
598         // constructor execution.
599 
600         uint256 size;
601         assembly {
602             size := extcodesize(account)
603         }
604         return size > 0;
605     }
606 
607     /**
608      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
609      * `recipient`, forwarding all available gas and reverting on errors.
610      *
611      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
612      * of certain opcodes, possibly making contracts go over the 2300 gas limit
613      * imposed by `transfer`, making them unable to receive funds via
614      * `transfer`. {sendValue} removes this limitation.
615      *
616      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
617      *
618      * IMPORTANT: because control is transferred to `recipient`, care must be
619      * taken to not create reentrancy vulnerabilities. Consider using
620      * {ReentrancyGuard} or the
621      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
622      */
623     function sendValue(address payable recipient, uint256 amount) internal {
624         require(address(this).balance >= amount, "Address: insufficient balance");
625 
626         (bool success, ) = recipient.call{value: amount}("");
627         require(success, "Address: unable to send value, recipient may have reverted");
628     }
629 
630     /**
631      * @dev Performs a Solidity function call using a low level `call`. A
632      * plain `call` is an unsafe replacement for a function call: use this
633      * function instead.
634      *
635      * If `target` reverts with a revert reason, it is bubbled up by this
636      * function (like regular Solidity function calls).
637      *
638      * Returns the raw returned data. To convert to the expected return value,
639      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
640      *
641      * Requirements:
642      *
643      * - `target` must be a contract.
644      * - calling `target` with `data` must not revert.
645      *
646      * _Available since v3.1._
647      */
648     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
649         return functionCall(target, data, "Address: low-level call failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
654      * `errorMessage` as a fallback revert reason when `target` reverts.
655      *
656      * _Available since v3.1._
657      */
658     function functionCall(
659         address target,
660         bytes memory data,
661         string memory errorMessage
662     ) internal returns (bytes memory) {
663         return functionCallWithValue(target, data, 0, errorMessage);
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
668      * but also transferring `value` wei to `target`.
669      *
670      * Requirements:
671      *
672      * - the calling contract must have an ETH balance of at least `value`.
673      * - the called Solidity function must be `payable`.
674      *
675      * _Available since v3.1._
676      */
677     function functionCallWithValue(
678         address target,
679         bytes memory data,
680         uint256 value
681     ) internal returns (bytes memory) {
682         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
687      * with `errorMessage` as a fallback revert reason when `target` reverts.
688      *
689      * _Available since v3.1._
690      */
691     function functionCallWithValue(
692         address target,
693         bytes memory data,
694         uint256 value,
695         string memory errorMessage
696     ) internal returns (bytes memory) {
697         require(address(this).balance >= value, "Address: insufficient balance for call");
698         require(isContract(target), "Address: call to non-contract");
699 
700         (bool success, bytes memory returndata) = target.call{value: value}(data);
701         return _verifyCallResult(success, returndata, errorMessage);
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
706      * but performing a static call.
707      *
708      * _Available since v3.3._
709      */
710     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
711         return functionStaticCall(target, data, "Address: low-level static call failed");
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
716      * but performing a static call.
717      *
718      * _Available since v3.3._
719      */
720     function functionStaticCall(
721         address target,
722         bytes memory data,
723         string memory errorMessage
724     ) internal view returns (bytes memory) {
725         require(isContract(target), "Address: static call to non-contract");
726 
727         (bool success, bytes memory returndata) = target.staticcall(data);
728         return _verifyCallResult(success, returndata, errorMessage);
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
733      * but performing a delegate call.
734      *
735      * _Available since v3.4._
736      */
737     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
738         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
743      * but performing a delegate call.
744      *
745      * _Available since v3.4._
746      */
747     function functionDelegateCall(
748         address target,
749         bytes memory data,
750         string memory errorMessage
751     ) internal returns (bytes memory) {
752         require(isContract(target), "Address: delegate call to non-contract");
753 
754         (bool success, bytes memory returndata) = target.delegatecall(data);
755         return _verifyCallResult(success, returndata, errorMessage);
756     }
757 
758     function _verifyCallResult(
759         bool success,
760         bytes memory returndata,
761         string memory errorMessage
762     ) private pure returns (bytes memory) {
763         if (success) {
764             return returndata;
765         } else {
766             // Look for revert reason and bubble it up if present
767             if (returndata.length > 0) {
768                 // The easiest way to bubble the revert reason is using memory via assembly
769 
770                 assembly {
771                     let returndata_size := mload(returndata)
772                     revert(add(32, returndata), returndata_size)
773                 }
774             } else {
775                 revert(errorMessage);
776             }
777         }
778     }
779 }
780 
781 /**
782  * @dev Implementation of the {IERC165} interface.
783  *
784  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
785  * for the additional interface id that will be supported. For example:
786  *
787  * ```solidity
788  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
789  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
790  * }
791  * ```
792  *
793  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
794  */
795 abstract contract ERC165 is IERC165 {
796     /**
797      * @dev See {IERC165-supportsInterface}.
798      */
799     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
800         return interfaceId == type(IERC165).interfaceId;
801     }
802 }
803 
804 /**
805  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
806  * the Metadata extension, but not including the Enumerable extension, which is available separately as
807  * {ERC721Enumerable}.
808  */
809 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
810     using Address for address;
811     using Strings for uint256;
812 
813     // Token name
814     string private _name;
815 
816     // Token symbol
817     string private _symbol;
818 
819     // Mapping from token ID to owner address
820     mapping(uint256 => address) private _owners;
821 
822     // Mapping owner address to token count
823     mapping(address => uint256) private _balances;
824 
825     // Mapping from token ID to approved address
826     mapping(uint256 => address) private _tokenApprovals;
827 
828     // Mapping from owner to operator approvals
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831     /**
832      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
833      */
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837     }
838 
839     /**
840      * @dev See {IERC165-supportsInterface}.
841      */
842     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
843         return
844             interfaceId == type(IERC721).interfaceId ||
845             interfaceId == type(IERC721Metadata).interfaceId ||
846             super.supportsInterface(interfaceId);
847     }
848 
849     /**
850      * @dev See {IERC721-balanceOf}.
851      */
852     function balanceOf(address owner) public view virtual override returns (uint256) {
853         require(owner != address(0), "ERC721: balance query for the zero address");
854         return _balances[owner];
855     }
856 
857     /**
858      * @dev See {IERC721-ownerOf}.
859      */
860     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
861         address owner = _owners[tokenId];
862         require(owner != address(0), "ERC721: owner query for nonexistent token");
863         return owner;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-name}.
868      */
869     function name() public view virtual override returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-symbol}.
875      */
876     function symbol() public view virtual override returns (string memory) {
877         return _symbol;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-tokenURI}.
882      */
883     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
884         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
885 
886         string memory baseURI = _baseURI();
887         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
888     }
889 
890     /**
891      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
892      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
893      * by default, can be overriden in child contracts.
894      */
895     function _baseURI() internal view virtual returns (string memory) {
896         return "";
897     }
898 
899     /**
900      * @dev See {IERC721-approve}.
901      */
902     function approve(address to, uint256 tokenId) public virtual override {
903         address owner = ERC721.ownerOf(tokenId);
904         require(to != owner, "ERC721: approval to current owner");
905 
906         require(
907             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
908             "ERC721: approve caller is not owner nor approved for all"
909         );
910 
911         _approve(to, tokenId);
912     }
913 
914     /**
915      * @dev See {IERC721-getApproved}.
916      */
917     function getApproved(uint256 tokenId) public view virtual override returns (address) {
918         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
919 
920         return _tokenApprovals[tokenId];
921     }
922 
923     /**
924      * @dev See {IERC721-setApprovalForAll}.
925      */
926     function setApprovalForAll(address operator, bool approved) public virtual override {
927         require(operator != _msgSender(), "ERC721: approve to caller");
928 
929         _operatorApprovals[_msgSender()][operator] = approved;
930         emit ApprovalForAll(_msgSender(), operator, approved);
931     }
932 
933     /**
934      * @dev See {IERC721-isApprovedForAll}.
935      */
936     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev See {IERC721-transferFrom}.
942      */
943     function transferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         //solhint-disable-next-line max-line-length
949         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
950 
951         _transfer(from, to, tokenId);
952     }
953 
954     /**
955      * @dev See {IERC721-safeTransferFrom}.
956      */
957     function safeTransferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         safeTransferFrom(from, to, tokenId, "");
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) public virtual override {
974         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
975         _safeTransfer(from, to, tokenId, _data);
976     }
977 
978     /**
979      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
980      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
981      *
982      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
983      *
984      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
985      * implement alternative mechanisms to perform token transfer, such as signature-based.
986      *
987      * Requirements:
988      *
989      * - `from` cannot be the zero address.
990      * - `to` cannot be the zero address.
991      * - `tokenId` token must exist and be owned by `from`.
992      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _safeTransfer(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) internal virtual {
1002         _transfer(from, to, tokenId);
1003         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1004     }
1005 
1006     /**
1007      * @dev Returns whether `tokenId` exists.
1008      *
1009      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1010      *
1011      * Tokens start existing when they are minted (`_mint`),
1012      * and stop existing when they are burned (`_burn`).
1013      */
1014     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1015         return _owners[tokenId] != address(0);
1016     }
1017 
1018     /**
1019      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must exist.
1024      */
1025     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1026         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1027         address owner = ERC721.ownerOf(tokenId);
1028         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1029     }
1030 
1031     /**
1032      * @dev Safely mints `tokenId` and transfers it to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must not exist.
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _safeMint(address to, uint256 tokenId) internal virtual {
1042         _safeMint(to, tokenId, "");
1043     }
1044 
1045     /**
1046      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1047      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1048      */
1049     function _safeMint(
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) internal virtual {
1054         _mint(to, tokenId);
1055         require(
1056             _checkOnERC721Received(address(0), to, tokenId, _data),
1057             "ERC721: transfer to non ERC721Receiver implementer"
1058         );
1059     }
1060 
1061     /**
1062      * @dev Mints `tokenId` and transfers it to `to`.
1063      *
1064      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must not exist.
1069      * - `to` cannot be the zero address.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(address to, uint256 tokenId) internal virtual {
1074         require(to != address(0), "ERC721: mint to the zero address");
1075         require(!_exists(tokenId), "ERC721: token already minted");
1076 
1077         _beforeTokenTransfer(address(0), to, tokenId);
1078 
1079         _balances[to] += 1;
1080         _owners[tokenId] = to;
1081 
1082         emit Transfer(address(0), to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Destroys `tokenId`.
1087      * The approval is cleared when the token is burned.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _burn(uint256 tokenId) internal virtual {
1096         address owner = ERC721.ownerOf(tokenId);
1097 
1098         _beforeTokenTransfer(owner, address(0), tokenId);
1099 
1100         // Clear approvals
1101         _approve(address(0), tokenId);
1102 
1103         _balances[owner] -= 1;
1104         delete _owners[tokenId];
1105 
1106         emit Transfer(owner, address(0), tokenId);
1107     }
1108 
1109     /**
1110      * @dev Transfers `tokenId` from `from` to `to`.
1111      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must be owned by `from`.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _transfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) internal virtual {
1125         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1126         require(to != address(0), "ERC721: transfer to the zero address");
1127 
1128         _beforeTokenTransfer(from, to, tokenId);
1129 
1130         // Clear approvals from the previous owner
1131         _approve(address(0), tokenId);
1132 
1133         _balances[from] -= 1;
1134         _balances[to] += 1;
1135         _owners[tokenId] = to;
1136 
1137         emit Transfer(from, to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Approve `to` to operate on `tokenId`
1142      *
1143      * Emits a {Approval} event.
1144      */
1145     function _approve(address to, uint256 tokenId) internal virtual {
1146         _tokenApprovals[tokenId] = to;
1147         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1148     }
1149 
1150     /**
1151      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1152      * The call is not executed if the target address is not a contract.
1153      *
1154      * @param from address representing the previous owner of the given token ID
1155      * @param to target address that will receive the tokens
1156      * @param tokenId uint256 ID of the token to be transferred
1157      * @param _data bytes optional data to send along with the call
1158      * @return bool whether the call correctly returned the expected magic value
1159      */
1160     function _checkOnERC721Received(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) private returns (bool) {
1166         if (to.isContract()) {
1167             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1168                 return retval == IERC721Receiver(to).onERC721Received.selector;
1169             } catch (bytes memory reason) {
1170                 if (reason.length == 0) {
1171                     revert("ERC721: transfer to non ERC721Receiver implementer");
1172                 } else {
1173                     assembly {
1174                         revert(add(32, reason), mload(reason))
1175                     }
1176                 }
1177             }
1178         } else {
1179             return true;
1180         }
1181     }
1182 
1183     /**
1184      * @dev Hook that is called before any token transfer. This includes minting
1185      * and burning.
1186      *
1187      * Calling conditions:
1188      *
1189      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1190      * transferred to `to`.
1191      * - When `from` is zero, `tokenId` will be minted for `to`.
1192      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1193      * - `from` and `to` are never both zero.
1194      *
1195      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1196      */
1197     function _beforeTokenTransfer(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) internal virtual {}
1202 }
1203 
1204 /**
1205  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1206  * @dev See https://eips.ethereum.org/EIPS/eip-721
1207  */
1208 interface IERC721Enumerable is IERC721 {
1209     /**
1210      * @dev Returns the total amount of tokens stored by the contract.
1211      */
1212     function totalSupply() external view returns (uint256);
1213 
1214     /**
1215      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1216      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1217      */
1218     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1219 
1220     /**
1221      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1222      * Use along with {totalSupply} to enumerate all tokens.
1223      */
1224     function tokenByIndex(uint256 index) external view returns (uint256);
1225 }
1226 
1227 
1228 /**
1229  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1230  * enumerability of all the token ids in the contract as well as all token ids owned by each
1231  * account.
1232  */
1233 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1234     // Mapping from owner to list of owned token IDs
1235     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1236 
1237     // Mapping from token ID to index of the owner tokens list
1238     mapping(uint256 => uint256) private _ownedTokensIndex;
1239 
1240     // Array with all token ids, used for enumeration
1241     uint256[] private _allTokens;
1242 
1243     // Mapping from token id to position in the allTokens array
1244     mapping(uint256 => uint256) private _allTokensIndex;
1245 
1246     /**
1247      * @dev See {IERC165-supportsInterface}.
1248      */
1249     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1250         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1255      */
1256     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1257         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1258         return _ownedTokens[owner][index];
1259     }
1260 
1261     /**
1262      * @dev See {IERC721Enumerable-totalSupply}.
1263      */
1264     function totalSupply() public view virtual override returns (uint256) {
1265         return _allTokens.length;
1266     }
1267 
1268     /**
1269      * @dev See {IERC721Enumerable-tokenByIndex}.
1270      */
1271     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1272         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1273         return _allTokens[index];
1274     }
1275 
1276     /**
1277      * @dev Hook that is called before any token transfer. This includes minting
1278      * and burning.
1279      *
1280      * Calling conditions:
1281      *
1282      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1283      * transferred to `to`.
1284      * - When `from` is zero, `tokenId` will be minted for `to`.
1285      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1286      * - `from` cannot be the zero address.
1287      * - `to` cannot be the zero address.
1288      *
1289      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1290      */
1291     function _beforeTokenTransfer(
1292         address from,
1293         address to,
1294         uint256 tokenId
1295     ) internal virtual override {
1296         super._beforeTokenTransfer(from, to, tokenId);
1297 
1298         if (from == address(0)) {
1299             _addTokenToAllTokensEnumeration(tokenId);
1300         } else if (from != to) {
1301             _removeTokenFromOwnerEnumeration(from, tokenId);
1302         }
1303         if (to == address(0)) {
1304             _removeTokenFromAllTokensEnumeration(tokenId);
1305         } else if (to != from) {
1306             _addTokenToOwnerEnumeration(to, tokenId);
1307         }
1308     }
1309 
1310     /**
1311      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1312      * @param to address representing the new owner of the given token ID
1313      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1314      */
1315     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1316         uint256 length = ERC721.balanceOf(to);
1317         _ownedTokens[to][length] = tokenId;
1318         _ownedTokensIndex[tokenId] = length;
1319     }
1320 
1321     /**
1322      * @dev Private function to add a token to this extension's token tracking data structures.
1323      * @param tokenId uint256 ID of the token to be added to the tokens list
1324      */
1325     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1326         _allTokensIndex[tokenId] = _allTokens.length;
1327         _allTokens.push(tokenId);
1328     }
1329 
1330     /**
1331      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1332      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1333      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1334      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1335      * @param from address representing the previous owner of the given token ID
1336      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1337      */
1338     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1339         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1340         // then delete the last slot (swap and pop).
1341 
1342         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1343         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1344 
1345         // When the token to delete is the last token, the swap operation is unnecessary
1346         if (tokenIndex != lastTokenIndex) {
1347             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1348 
1349             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1350             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1351         }
1352 
1353         // This also deletes the contents at the last position of the array
1354         delete _ownedTokensIndex[tokenId];
1355         delete _ownedTokens[from][lastTokenIndex];
1356     }
1357 
1358     /**
1359      * @dev Private function to remove a token from this extension's token tracking data structures.
1360      * This has O(1) time complexity, but alters the order of the _allTokens array.
1361      * @param tokenId uint256 ID of the token to be removed from the tokens list
1362      */
1363     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1364         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1365         // then delete the last slot (swap and pop).
1366 
1367         uint256 lastTokenIndex = _allTokens.length - 1;
1368         uint256 tokenIndex = _allTokensIndex[tokenId];
1369 
1370         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1371         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1372         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1373         uint256 lastTokenId = _allTokens[lastTokenIndex];
1374 
1375         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1376         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1377 
1378         // This also deletes the contents at the last position of the array
1379         delete _allTokensIndex[tokenId];
1380         _allTokens.pop();
1381     }
1382 }
1383 
1384 interface NInterface {
1385     function ownerOf(uint256 tokenId) external view returns (address owner);
1386     function balanceOf(address owner) external view returns (uint256 balance);
1387     function tokenOfOwnerByIndex(address owner, uint256 index)
1388         external
1389         view
1390         returns (uint256 tokenId);
1391 }
1392 
1393 contract LostPixels is ERC721, ERC721Enumerable, Ownable {
1394 
1395     string public PROVENANCE;
1396     uint256 public constant tokenPrice = 12345000000000000; // 0.012345 ETH
1397     uint256 public MAX_TOKENS = 3333;
1398     bool public saleIsActive = false;
1399 
1400     address public nAddress = 0x05a46f1E545526FB803FF974C790aCeA34D1f2D6;
1401     NInterface nContract = NInterface(nAddress);
1402 
1403     string private _baseURIextended;
1404 
1405     constructor() ERC721("Lost Pixels For N", "LPXN") {
1406     }
1407 
1408     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1409         super._beforeTokenTransfer(from, to, tokenId);
1410     }
1411 
1412     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1413         return super.supportsInterface(interfaceId);
1414     }
1415 
1416     function setBaseURI(string memory baseURI_) external onlyOwner() {
1417         _baseURIextended = baseURI_;
1418     }
1419 
1420     function _baseURI() internal view virtual override returns (string memory) {
1421         return _baseURIextended;
1422     }
1423 
1424     function setProvenance(string memory provenance) public onlyOwner {
1425         PROVENANCE = provenance;
1426     }
1427 
1428     function flipSaleState() public onlyOwner {
1429         saleIsActive = !saleIsActive;
1430     }
1431 
1432     function mintToken(uint tokenId) public payable {
1433         require(saleIsActive, "Sale must be active to mint tokens");
1434         require(totalSupply() + 1 <= MAX_TOKENS, "Max supply reached");
1435         require(tokenPrice <= msg.value, "Payment too low, try 0.012345 eth");
1436         require(nContract.balanceOf(msg.sender) > 0, "Must own an N to mint token");
1437         require(nContract.ownerOf(tokenId) == msg.sender, "Must own the N to mint token");
1438 
1439         _safeMint(msg.sender, tokenId);
1440     }
1441 
1442     function withdraw() public onlyOwner {
1443         uint balance = address(this).balance;
1444         payable(msg.sender).transfer(balance);
1445     }
1446 
1447 }