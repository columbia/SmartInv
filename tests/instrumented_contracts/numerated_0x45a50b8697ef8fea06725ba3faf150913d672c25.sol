1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Approve or remove `operator` as an operator for the caller.
433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Enumerable is IERC721 {
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     /**
479      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
480      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
481      */
482     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
483 
484     /**
485      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
486      * Use along with {totalSupply} to enumerate all tokens.
487      */
488     function tokenByIndex(uint256 index) external view returns (uint256);
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 // File: @openzeppelin/contracts/utils/Strings.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev String operations.
529  */
530 library Strings {
531     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
535      */
536     function toString(uint256 value) internal pure returns (string memory) {
537         // Inspired by OraclizeAPI's implementation - MIT licence
538         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
539 
540         if (value == 0) {
541             return "0";
542         }
543         uint256 temp = value;
544         uint256 digits;
545         while (temp != 0) {
546             digits++;
547             temp /= 10;
548         }
549         bytes memory buffer = new bytes(digits);
550         while (value != 0) {
551             digits -= 1;
552             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
553             value /= 10;
554         }
555         return string(buffer);
556     }
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
560      */
561     function toHexString(uint256 value) internal pure returns (string memory) {
562         if (value == 0) {
563             return "0x00";
564         }
565         uint256 temp = value;
566         uint256 length = 0;
567         while (temp != 0) {
568             length++;
569             temp >>= 8;
570         }
571         return toHexString(value, length);
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
576      */
577     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
578         bytes memory buffer = new bytes(2 * length + 2);
579         buffer[0] = "0";
580         buffer[1] = "x";
581         for (uint256 i = 2 * length + 1; i > 1; --i) {
582             buffer[i] = _HEX_SYMBOLS[value & 0xf];
583             value >>= 4;
584         }
585         require(value == 0, "Strings: hex length insufficient");
586         return string(buffer);
587     }
588 }
589 
590 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
591 
592 
593 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 // CAUTION
598 // This version of SafeMath should only be used with Solidity 0.8 or later,
599 // because it relies on the compiler's built in overflow checks.
600 
601 /**
602  * @dev Wrappers over Solidity's arithmetic operations.
603  *
604  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
605  * now has built in overflow checking.
606  */
607 library SafeMath {
608     /**
609      * @dev Returns the addition of two unsigned integers, with an overflow flag.
610      *
611      * _Available since v3.4._
612      */
613     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
614         unchecked {
615             uint256 c = a + b;
616             if (c < a) return (false, 0);
617             return (true, c);
618         }
619     }
620 
621     /**
622      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
623      *
624      * _Available since v3.4._
625      */
626     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
627         unchecked {
628             if (b > a) return (false, 0);
629             return (true, a - b);
630         }
631     }
632 
633     /**
634      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
635      *
636      * _Available since v3.4._
637      */
638     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
639         unchecked {
640             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
641             // benefit is lost if 'b' is also tested.
642             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
643             if (a == 0) return (true, 0);
644             uint256 c = a * b;
645             if (c / a != b) return (false, 0);
646             return (true, c);
647         }
648     }
649 
650     /**
651      * @dev Returns the division of two unsigned integers, with a division by zero flag.
652      *
653      * _Available since v3.4._
654      */
655     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
656         unchecked {
657             if (b == 0) return (false, 0);
658             return (true, a / b);
659         }
660     }
661 
662     /**
663      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
664      *
665      * _Available since v3.4._
666      */
667     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
668         unchecked {
669             if (b == 0) return (false, 0);
670             return (true, a % b);
671         }
672     }
673 
674     /**
675      * @dev Returns the addition of two unsigned integers, reverting on
676      * overflow.
677      *
678      * Counterpart to Solidity's `+` operator.
679      *
680      * Requirements:
681      *
682      * - Addition cannot overflow.
683      */
684     function add(uint256 a, uint256 b) internal pure returns (uint256) {
685         return a + b;
686     }
687 
688     /**
689      * @dev Returns the subtraction of two unsigned integers, reverting on
690      * overflow (when the result is negative).
691      *
692      * Counterpart to Solidity's `-` operator.
693      *
694      * Requirements:
695      *
696      * - Subtraction cannot overflow.
697      */
698     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
699         return a - b;
700     }
701 
702     /**
703      * @dev Returns the multiplication of two unsigned integers, reverting on
704      * overflow.
705      *
706      * Counterpart to Solidity's `*` operator.
707      *
708      * Requirements:
709      *
710      * - Multiplication cannot overflow.
711      */
712     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
713         return a * b;
714     }
715 
716     /**
717      * @dev Returns the integer division of two unsigned integers, reverting on
718      * division by zero. The result is rounded towards zero.
719      *
720      * Counterpart to Solidity's `/` operator.
721      *
722      * Requirements:
723      *
724      * - The divisor cannot be zero.
725      */
726     function div(uint256 a, uint256 b) internal pure returns (uint256) {
727         return a / b;
728     }
729 
730     /**
731      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
732      * reverting when dividing by zero.
733      *
734      * Counterpart to Solidity's `%` operator. This function uses a `revert`
735      * opcode (which leaves remaining gas untouched) while Solidity uses an
736      * invalid opcode to revert (consuming all remaining gas).
737      *
738      * Requirements:
739      *
740      * - The divisor cannot be zero.
741      */
742     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
743         return a % b;
744     }
745 
746     /**
747      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
748      * overflow (when the result is negative).
749      *
750      * CAUTION: This function is deprecated because it requires allocating memory for the error
751      * message unnecessarily. For custom revert reasons use {trySub}.
752      *
753      * Counterpart to Solidity's `-` operator.
754      *
755      * Requirements:
756      *
757      * - Subtraction cannot overflow.
758      */
759     function sub(
760         uint256 a,
761         uint256 b,
762         string memory errorMessage
763     ) internal pure returns (uint256) {
764         unchecked {
765             require(b <= a, errorMessage);
766             return a - b;
767         }
768     }
769 
770     /**
771      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
772      * division by zero. The result is rounded towards zero.
773      *
774      * Counterpart to Solidity's `/` operator. Note: this function uses a
775      * `revert` opcode (which leaves remaining gas untouched) while Solidity
776      * uses an invalid opcode to revert (consuming all remaining gas).
777      *
778      * Requirements:
779      *
780      * - The divisor cannot be zero.
781      */
782     function div(
783         uint256 a,
784         uint256 b,
785         string memory errorMessage
786     ) internal pure returns (uint256) {
787         unchecked {
788             require(b > 0, errorMessage);
789             return a / b;
790         }
791     }
792 
793     /**
794      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
795      * reverting with custom message when dividing by zero.
796      *
797      * CAUTION: This function is deprecated because it requires allocating memory for the error
798      * message unnecessarily. For custom revert reasons use {tryMod}.
799      *
800      * Counterpart to Solidity's `%` operator. This function uses a `revert`
801      * opcode (which leaves remaining gas untouched) while Solidity uses an
802      * invalid opcode to revert (consuming all remaining gas).
803      *
804      * Requirements:
805      *
806      * - The divisor cannot be zero.
807      */
808     function mod(
809         uint256 a,
810         uint256 b,
811         string memory errorMessage
812     ) internal pure returns (uint256) {
813         unchecked {
814             require(b > 0, errorMessage);
815             return a % b;
816         }
817     }
818 }
819 
820 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
821 
822 
823 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 /**
828  * @dev These functions deal with verification of Merkle Trees proofs.
829  *
830  * The proofs can be generated using the JavaScript library
831  * https://github.com/miguelmota/merkletreejs[merkletreejs].
832  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
833  *
834  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
835  *
836  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
837  * hashing, or use a hash function other than keccak256 for hashing leaves.
838  * This is because the concatenation of a sorted pair of internal nodes in
839  * the merkle tree could be reinterpreted as a leaf value.
840  */
841 library MerkleProof {
842     /**
843      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
844      * defined by `root`. For this, a `proof` must be provided, containing
845      * sibling hashes on the branch from the leaf to the root of the tree. Each
846      * pair of leaves and each pair of pre-images are assumed to be sorted.
847      */
848     function verify(
849         bytes32[] memory proof,
850         bytes32 root,
851         bytes32 leaf
852     ) internal pure returns (bool) {
853         return processProof(proof, leaf) == root;
854     }
855 
856     /**
857      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
858      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
859      * hash matches the root of the tree. When processing the proof, the pairs
860      * of leafs & pre-images are assumed to be sorted.
861      *
862      * _Available since v4.4._
863      */
864     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
865         bytes32 computedHash = leaf;
866         for (uint256 i = 0; i < proof.length; i++) {
867             bytes32 proofElement = proof[i];
868             if (computedHash <= proofElement) {
869                 // Hash(current computed hash + current element of the proof)
870                 computedHash = _efficientHash(computedHash, proofElement);
871             } else {
872                 // Hash(current element of the proof + current computed hash)
873                 computedHash = _efficientHash(proofElement, computedHash);
874             }
875         }
876         return computedHash;
877     }
878 
879     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
880         assembly {
881             mstore(0x00, a)
882             mstore(0x20, b)
883             value := keccak256(0x00, 0x40)
884         }
885     }
886 }
887 
888 // File: @openzeppelin/contracts/utils/Context.sol
889 
890 
891 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 /**
896  * @dev Provides information about the current execution context, including the
897  * sender of the transaction and its data. While these are generally available
898  * via msg.sender and msg.data, they should not be accessed in such a direct
899  * manner, since when dealing with meta-transactions the account sending and
900  * paying for execution may not be the actual sender (as far as an application
901  * is concerned).
902  *
903  * This contract is only required for intermediate, library-like contracts.
904  */
905 abstract contract Context {
906     function _msgSender() internal view virtual returns (address) {
907         return msg.sender;
908     }
909 
910     function _msgData() internal view virtual returns (bytes calldata) {
911         return msg.data;
912     }
913 }
914 
915 // File: contracts/ERC721A.sol
916 
917 
918 
919 pragma solidity ^0.8.0;
920 
921 
922 
923 
924 
925 
926 
927 
928 
929 /**
930  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
931  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
932  *
933  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
934  *
935  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
936  *
937  * Does not support burning tokens to address(0).
938  */
939 contract ERC721A is
940   Context,
941   ERC165,
942   IERC721,
943   IERC721Metadata,
944   IERC721Enumerable
945 {
946   using Address for address;
947   using Strings for uint256;
948 
949   struct TokenOwnership {
950     address addr;
951     uint64 startTimestamp;
952   }
953 
954   struct AddressData {
955     uint128 balance;
956     uint128 numberMinted;
957   }
958 
959   uint256 private currentIndex = 0;
960 
961   uint256 internal immutable collectionSize;
962   uint256 internal immutable maxBatchSize;
963 
964   // Token name
965   string private _name;
966 
967   // Token symbol
968   string private _symbol;
969 
970   // Mapping from token ID to ownership details
971   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
972   mapping(uint256 => TokenOwnership) private _ownerships;
973 
974   // Mapping owner address to address data
975   mapping(address => AddressData) private _addressData;
976 
977   // Mapping from token ID to approved address
978   mapping(uint256 => address) private _tokenApprovals;
979 
980   // Mapping from owner to operator approvals
981   mapping(address => mapping(address => bool)) private _operatorApprovals;
982 
983   /**
984    * @dev
985    * `maxBatchSize` refers to how much a minter can mint at a time.
986    * `collectionSize_` refers to how many tokens are in the collection.
987    */
988   constructor(
989     string memory name_,
990     string memory symbol_,
991     uint256 maxBatchSize_,
992     uint256 collectionSize_
993   ) {
994     require(
995       collectionSize_ > 0,
996       "ERC721A: collection must have a nonzero supply"
997     );
998     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
999     _name = name_;
1000     _symbol = symbol_;
1001     maxBatchSize = maxBatchSize_;
1002     collectionSize = collectionSize_;
1003   }
1004 
1005   /**
1006    * @dev See {IERC721Enumerable-totalSupply}.
1007    */
1008   function totalSupply() public view override returns (uint256) {
1009     return currentIndex;
1010   }
1011 
1012   /**
1013    * @dev See {IERC721Enumerable-tokenByIndex}.
1014    */
1015   function tokenByIndex(uint256 index) public view override returns (uint256) {
1016     require(index < totalSupply(), "ERC721A: global index out of bounds");
1017     return index;
1018   }
1019 
1020   /**
1021    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1022    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1023    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1024    */
1025   function tokenOfOwnerByIndex(address owner, uint256 index)
1026     public
1027     view
1028     override
1029     returns (uint256)
1030   {
1031     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1032     uint256 numMintedSoFar = totalSupply();
1033     uint256 tokenIdsIdx = 0;
1034     address currOwnershipAddr = address(0);
1035     for (uint256 i = 0; i < numMintedSoFar; i++) {
1036       TokenOwnership memory ownership = _ownerships[i];
1037       if (ownership.addr != address(0)) {
1038         currOwnershipAddr = ownership.addr;
1039       }
1040       if (currOwnershipAddr == owner) {
1041         if (tokenIdsIdx == index) {
1042           return i;
1043         }
1044         tokenIdsIdx++;
1045       }
1046     }
1047     revert("ERC721A: unable to get token of owner by index");
1048   }
1049 
1050   /**
1051    * @dev See {IERC165-supportsInterface}.
1052    */
1053   function supportsInterface(bytes4 interfaceId)
1054     public
1055     view
1056     virtual
1057     override(ERC165, IERC165)
1058     returns (bool)
1059   {
1060     return
1061       interfaceId == type(IERC721).interfaceId ||
1062       interfaceId == type(IERC721Metadata).interfaceId ||
1063       interfaceId == type(IERC721Enumerable).interfaceId ||
1064       super.supportsInterface(interfaceId);
1065   }
1066 
1067   /**
1068    * @dev See {IERC721-balanceOf}.
1069    */
1070   function balanceOf(address owner) public view override returns (uint256) {
1071     require(owner != address(0), "ERC721A: balance query for the zero address");
1072     return uint256(_addressData[owner].balance);
1073   }
1074 
1075   function _numberMinted(address owner) internal view returns (uint256) {
1076     require(
1077       owner != address(0),
1078       "ERC721A: number minted query for the zero address"
1079     );
1080     return uint256(_addressData[owner].numberMinted);
1081   }
1082 
1083   function ownershipOf(uint256 tokenId)
1084     internal
1085     view
1086     returns (TokenOwnership memory)
1087   {
1088     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1089 
1090     uint256 lowestTokenToCheck;
1091     if (tokenId >= maxBatchSize) {
1092       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1093     }
1094 
1095     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1096       TokenOwnership memory ownership = _ownerships[curr];
1097       if (ownership.addr != address(0)) {
1098         return ownership;
1099       }
1100     }
1101 
1102     revert("ERC721A: unable to determine the owner of token");
1103   }
1104 
1105   /**
1106    * @dev See {IERC721-ownerOf}.
1107    */
1108   function ownerOf(uint256 tokenId) public view override returns (address) {
1109     return ownershipOf(tokenId).addr;
1110   }
1111 
1112   /**
1113    * @dev See {IERC721Metadata-name}.
1114    */
1115   function name() public view virtual override returns (string memory) {
1116     return _name;
1117   }
1118 
1119   /**
1120    * @dev See {IERC721Metadata-symbol}.
1121    */
1122   function symbol() public view virtual override returns (string memory) {
1123     return _symbol;
1124   }
1125 
1126   /**
1127    * @dev See {IERC721Metadata-tokenURI}.
1128    */
1129   function tokenURI(uint256 tokenId)
1130     public
1131     view
1132     virtual
1133     override
1134     returns (string memory)
1135   {
1136     require(
1137       _exists(tokenId),
1138       "ERC721Metadata: URI query for nonexistent token"
1139     );
1140 
1141     string memory baseURI = _baseURI();
1142     return
1143       bytes(baseURI).length > 0
1144         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1145         : "";
1146   }
1147 
1148   /**
1149    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1150    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1151    * by default, can be overriden in child contracts.
1152    */
1153   function _baseURI() internal view virtual returns (string memory) {
1154     return "";
1155   }
1156 
1157   /**
1158    * @dev See {IERC721-approve}.
1159    */
1160   function approve(address to, uint256 tokenId) public override {
1161     address owner = ERC721A.ownerOf(tokenId);
1162     require(to != owner, "ERC721A: approval to current owner");
1163 
1164     require(
1165       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1166       "ERC721A: approve caller is not owner nor approved for all"
1167     );
1168 
1169     _approve(to, tokenId, owner);
1170   }
1171 
1172   /**
1173    * @dev See {IERC721-getApproved}.
1174    */
1175   function getApproved(uint256 tokenId) public view override returns (address) {
1176     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1177 
1178     return _tokenApprovals[tokenId];
1179   }
1180 
1181   /**
1182    * @dev See {IERC721-setApprovalForAll}.
1183    */
1184   function setApprovalForAll(address operator, bool approved) public override {
1185     require(operator != _msgSender(), "ERC721A: approve to caller");
1186 
1187     _operatorApprovals[_msgSender()][operator] = approved;
1188     emit ApprovalForAll(_msgSender(), operator, approved);
1189   }
1190 
1191   /**
1192    * @dev See {IERC721-isApprovedForAll}.
1193    */
1194   function isApprovedForAll(address owner, address operator)
1195     public
1196     view
1197     virtual
1198     override
1199     returns (bool)
1200   {
1201     return _operatorApprovals[owner][operator];
1202   }
1203 
1204   /**
1205    * @dev See {IERC721-transferFrom}.
1206    */
1207   function transferFrom(
1208     address from,
1209     address to,
1210     uint256 tokenId
1211   ) public override {
1212     _transfer(from, to, tokenId);
1213   }
1214 
1215   /**
1216    * @dev See {IERC721-safeTransferFrom}.
1217    */
1218   function safeTransferFrom(
1219     address from,
1220     address to,
1221     uint256 tokenId
1222   ) public override {
1223     safeTransferFrom(from, to, tokenId, "");
1224   }
1225 
1226   /**
1227    * @dev See {IERC721-safeTransferFrom}.
1228    */
1229   function safeTransferFrom(
1230     address from,
1231     address to,
1232     uint256 tokenId,
1233     bytes memory _data
1234   ) public override {
1235     _transfer(from, to, tokenId);
1236     require(
1237       _checkOnERC721Received(from, to, tokenId, _data),
1238       "ERC721A: transfer to non ERC721Receiver implementer"
1239     );
1240   }
1241 
1242   /**
1243    * @dev Returns whether `tokenId` exists.
1244    *
1245    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1246    *
1247    * Tokens start existing when they are minted (`_mint`),
1248    */
1249   function _exists(uint256 tokenId) internal view returns (bool) {
1250     return tokenId < currentIndex;
1251   }
1252 
1253   function _safeMint(address to, uint256 quantity) internal {
1254     _safeMint(to, quantity, "");
1255   }
1256 
1257   /**
1258    * @dev Mints `quantity` tokens and transfers them to `to`.
1259    *
1260    * Requirements:
1261    *
1262    * - there must be `quantity` tokens remaining unminted in the total collection.
1263    * - `to` cannot be the zero address.
1264    * - `quantity` cannot be larger than the max batch size.
1265    *
1266    * Emits a {Transfer} event.
1267    */
1268   function _safeMint(
1269     address to,
1270     uint256 quantity,
1271     bytes memory _data
1272   ) internal {
1273     uint256 startTokenId = currentIndex;
1274     require(to != address(0), "ERC721A: mint to the zero address");
1275     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1276     require(!_exists(startTokenId), "ERC721A: token already minted");
1277     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1278 
1279     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1280 
1281     AddressData memory addressData = _addressData[to];
1282     _addressData[to] = AddressData(
1283       addressData.balance + uint128(quantity),
1284       addressData.numberMinted + uint128(quantity)
1285     );
1286     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1287 
1288     uint256 updatedIndex = startTokenId;
1289 
1290     for (uint256 i = 0; i < quantity; i++) {
1291       emit Transfer(address(0), to, updatedIndex);
1292       require(
1293         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1294         "ERC721A: transfer to non ERC721Receiver implementer"
1295       );
1296       updatedIndex++;
1297     }
1298 
1299     currentIndex = updatedIndex;
1300     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1301   }
1302 
1303   /**
1304    * @dev Transfers `tokenId` from `from` to `to`.
1305    *
1306    * Requirements:
1307    *
1308    * - `to` cannot be the zero address.
1309    * - `tokenId` token must be owned by `from`.
1310    *
1311    * Emits a {Transfer} event.
1312    */
1313   function _transfer(
1314     address from,
1315     address to,
1316     uint256 tokenId
1317   ) private {
1318     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1319 
1320     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1321       getApproved(tokenId) == _msgSender() ||
1322       isApprovedForAll(prevOwnership.addr, _msgSender()));
1323 
1324     require(
1325       isApprovedOrOwner,
1326       "ERC721A: transfer caller is not owner nor approved"
1327     );
1328 
1329     require(
1330       prevOwnership.addr == from,
1331       "ERC721A: transfer from incorrect owner"
1332     );
1333     require(to != address(0), "ERC721A: transfer to the zero address");
1334 
1335     _beforeTokenTransfers(from, to, tokenId, 1);
1336 
1337     // Clear approvals from the previous owner
1338     _approve(address(0), tokenId, prevOwnership.addr);
1339 
1340     _addressData[from].balance -= 1;
1341     _addressData[to].balance += 1;
1342     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1343 
1344     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1345     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1346     uint256 nextTokenId = tokenId + 1;
1347     if (_ownerships[nextTokenId].addr == address(0)) {
1348       if (_exists(nextTokenId)) {
1349         _ownerships[nextTokenId] = TokenOwnership(
1350           prevOwnership.addr,
1351           prevOwnership.startTimestamp
1352         );
1353       }
1354     }
1355 
1356     emit Transfer(from, to, tokenId);
1357     _afterTokenTransfers(from, to, tokenId, 1);
1358   }
1359 
1360   /**
1361    * @dev Approve `to` to operate on `tokenId`
1362    *
1363    * Emits a {Approval} event.
1364    */
1365   function _approve(
1366     address to,
1367     uint256 tokenId,
1368     address owner
1369   ) private {
1370     _tokenApprovals[tokenId] = to;
1371     emit Approval(owner, to, tokenId);
1372   }
1373 
1374   uint256 public nextOwnerToExplicitlySet = 0;
1375 
1376   /**
1377    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1378    */
1379   function _setOwnersExplicit(uint256 quantity) internal {
1380     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1381     require(quantity > 0, "quantity must be nonzero");
1382     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1383     if (endIndex > collectionSize - 1) {
1384       endIndex = collectionSize - 1;
1385     }
1386     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1387     require(_exists(endIndex), "not enough minted yet for this cleanup");
1388     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1389       if (_ownerships[i].addr == address(0)) {
1390         TokenOwnership memory ownership = ownershipOf(i);
1391         _ownerships[i] = TokenOwnership(
1392           ownership.addr,
1393           ownership.startTimestamp
1394         );
1395       }
1396     }
1397     nextOwnerToExplicitlySet = endIndex + 1;
1398   }
1399 
1400   /**
1401    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1402    * The call is not executed if the target address is not a contract.
1403    *
1404    * @param from address representing the previous owner of the given token ID
1405    * @param to target address that will receive the tokens
1406    * @param tokenId uint256 ID of the token to be transferred
1407    * @param _data bytes optional data to send along with the call
1408    * @return bool whether the call correctly returned the expected magic value
1409    */
1410   function _checkOnERC721Received(
1411     address from,
1412     address to,
1413     uint256 tokenId,
1414     bytes memory _data
1415   ) private returns (bool) {
1416     if (to.isContract()) {
1417       try
1418         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1419       returns (bytes4 retval) {
1420         return retval == IERC721Receiver(to).onERC721Received.selector;
1421       } catch (bytes memory reason) {
1422         if (reason.length == 0) {
1423           revert("ERC721A: transfer to non ERC721Receiver implementer");
1424         } else {
1425           assembly {
1426             revert(add(32, reason), mload(reason))
1427           }
1428         }
1429       }
1430     } else {
1431       return true;
1432     }
1433   }
1434 
1435   /**
1436    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1437    *
1438    * startTokenId - the first token id to be transferred
1439    * quantity - the amount to be transferred
1440    *
1441    * Calling conditions:
1442    *
1443    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1444    * transferred to `to`.
1445    * - When `from` is zero, `tokenId` will be minted for `to`.
1446    */
1447   function _beforeTokenTransfers(
1448     address from,
1449     address to,
1450     uint256 startTokenId,
1451     uint256 quantity
1452   ) internal virtual {}
1453 
1454   /**
1455    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1456    * minting.
1457    *
1458    * startTokenId - the first token id to be transferred
1459    * quantity - the amount to be transferred
1460    *
1461    * Calling conditions:
1462    *
1463    * - when `from` and `to` are both non-zero.
1464    * - `from` and `to` are never both zero.
1465    */
1466   function _afterTokenTransfers(
1467     address from,
1468     address to,
1469     uint256 startTokenId,
1470     uint256 quantity
1471   ) internal virtual {}
1472 }
1473 
1474 // File: @openzeppelin/contracts/access/Ownable.sol
1475 
1476 
1477 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1478 
1479 pragma solidity ^0.8.0;
1480 
1481 
1482 /**
1483  * @dev Contract module which provides a basic access control mechanism, where
1484  * there is an account (an owner) that can be granted exclusive access to
1485  * specific functions.
1486  *
1487  * By default, the owner account will be the one that deploys the contract. This
1488  * can later be changed with {transferOwnership}.
1489  *
1490  * This module is used through inheritance. It will make available the modifier
1491  * `onlyOwner`, which can be applied to your functions to restrict their use to
1492  * the owner.
1493  */
1494 abstract contract Ownable is Context {
1495     address private _owner;
1496 
1497     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1498 
1499     /**
1500      * @dev Initializes the contract setting the deployer as the initial owner.
1501      */
1502     constructor() {
1503         _transferOwnership(_msgSender());
1504     }
1505 
1506     /**
1507      * @dev Returns the address of the current owner.
1508      */
1509     function owner() public view virtual returns (address) {
1510         return _owner;
1511     }
1512 
1513     /**
1514      * @dev Throws if called by any account other than the owner.
1515      */
1516     modifier onlyOwner() {
1517         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1518         _;
1519     }
1520 
1521     /**
1522      * @dev Leaves the contract without owner. It will not be possible to call
1523      * `onlyOwner` functions anymore. Can only be called by the current owner.
1524      *
1525      * NOTE: Renouncing ownership will leave the contract without an owner,
1526      * thereby removing any functionality that is only available to the owner.
1527      */
1528     function renounceOwnership() public virtual onlyOwner {
1529         _transferOwnership(address(0));
1530     }
1531 
1532     /**
1533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1534      * Can only be called by the current owner.
1535      */
1536     function transferOwnership(address newOwner) public virtual onlyOwner {
1537         require(newOwner != address(0), "Ownable: new owner is the zero address");
1538         _transferOwnership(newOwner);
1539     }
1540 
1541     /**
1542      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1543      * Internal function without access restriction.
1544      */
1545     function _transferOwnership(address newOwner) internal virtual {
1546         address oldOwner = _owner;
1547         _owner = newOwner;
1548         emit OwnershipTransferred(oldOwner, newOwner);
1549     }
1550 }
1551 
1552 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1553 
1554 
1555 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1556 
1557 pragma solidity ^0.8.0;
1558 
1559 /**
1560  * @dev Contract module that helps prevent reentrant calls to a function.
1561  *
1562  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1563  * available, which can be applied to functions to make sure there are no nested
1564  * (reentrant) calls to them.
1565  *
1566  * Note that because there is a single `nonReentrant` guard, functions marked as
1567  * `nonReentrant` may not call one another. This can be worked around by making
1568  * those functions `private`, and then adding `external` `nonReentrant` entry
1569  * points to them.
1570  *
1571  * TIP: If you would like to learn more about reentrancy and alternative ways
1572  * to protect against it, check out our blog post
1573  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1574  */
1575 abstract contract ReentrancyGuard {
1576     // Booleans are more expensive than uint256 or any type that takes up a full
1577     // word because each write operation emits an extra SLOAD to first read the
1578     // slot's contents, replace the bits taken up by the boolean, and then write
1579     // back. This is the compiler's defense against contract upgrades and
1580     // pointer aliasing, and it cannot be disabled.
1581 
1582     // The values being non-zero value makes deployment a bit more expensive,
1583     // but in exchange the refund on every call to nonReentrant will be lower in
1584     // amount. Since refunds are capped to a percentage of the total
1585     // transaction's gas, it is best to keep them low in cases like this one, to
1586     // increase the likelihood of the full refund coming into effect.
1587     uint256 private constant _NOT_ENTERED = 1;
1588     uint256 private constant _ENTERED = 2;
1589 
1590     uint256 private _status;
1591 
1592     constructor() {
1593         _status = _NOT_ENTERED;
1594     }
1595 
1596     /**
1597      * @dev Prevents a contract from calling itself, directly or indirectly.
1598      * Calling a `nonReentrant` function from another `nonReentrant`
1599      * function is not supported. It is possible to prevent this from happening
1600      * by making the `nonReentrant` function external, and making it call a
1601      * `private` function that does the actual work.
1602      */
1603     modifier nonReentrant() {
1604         // On the first call to nonReentrant, _notEntered will be true
1605         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1606 
1607         // Any calls to nonReentrant after this point will fail
1608         _status = _ENTERED;
1609 
1610         _;
1611 
1612         // By storing the original value once again, a refund is triggered (see
1613         // https://eips.ethereum.org/EIPS/eip-2200)
1614         _status = _NOT_ENTERED;
1615     }
1616 }
1617 
1618 // File: contracts/CoffeeCentral.sol
1619 
1620 
1621 pragma solidity ^0.8.0;
1622 
1623 // SPDX-License-Identifier: MIT
1624 
1625 
1626 contract CoffeeCentral is ReentrancyGuard, Ownable, ERC721A{
1627 
1628 
1629     using Strings for uint256;
1630     using SafeMath for uint256;
1631 
1632     bytes32 public merkleRoot;
1633 
1634     uint256 constant public maxNFT = 3333;
1635  
1636     address payable private community = payable(0xbA7aF85144e6b291d573C54844F2b72131e321EE);  //46%
1637     address payable private papa = payable(0xB64c5058C3D395F074EBF78a19c9b556885369B4);  //15%
1638     address payable private sonny = payable(0x87c56882216A3Ae8d2A1530b1A413dA144a721C1 ); //15%
1639     address payable private zee = payable(0xBFe37A45B9DDd6ff170FF15090d35BFE6eCCb475 ); //2.5%
1640     address payable private reid = payable(0x840D6cf4A07C3e2D1A8a814194805e18f3451528); //5.5%
1641     address payable private dev = payable(0xc98205d77a98be4378D56165959A990Da8c30735);  //16%
1642 
1643     mapping(address => uint256 ) public presaleClaim;
1644 
1645    
1646     bool public activePublic;
1647     bool public activePresale;
1648 
1649     uint256 public whiteListPrice = 0;
1650     uint256 public publicPrice = 0;
1651 
1652     string private _prefixURI;
1653 
1654     event Activate(bool activepresale,bool activepublic);
1655     event SetMerkleRoot(bytes32 merkleRoot);
1656     event SetPublicPrice(uint256 publicPrice);
1657     event SetWhitelistPrice(uint256 whitelistPrice);
1658 
1659     /* royalties */
1660     uint256 private _royaltyBps;
1661     address payable private _royaltyRecipient;
1662 
1663     bytes4 private constant _INTERFACE_ID_ROYALTIES = 0xbb3bafd6; //bytes4(keccak256('getRoyalties(uint256)')) == 0xbb3bafd6
1664     bytes4 private constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x2a55205a; //bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
1665     bytes4 private constant _INTERFACE_ID_ROYALTIES_RARIBLE = 0xb7799584;
1666 
1667     struct Reward {
1668         address recipient;
1669         uint256 amount;
1670     }
1671 
1672     constructor(bytes32 _merkleRoot) ERC721A("CoffeeCentral", "CoffeeCentral", 10, 3333){
1673 
1674         _royaltyRecipient = payable(msg.sender);
1675         _royaltyBps = 250;
1676         merkleRoot = _merkleRoot;
1677         _prefixURI = "ipfs://QmS2Q32epE9mvGNvvSZYQSKahKBjsG7BNhvFset8ro8KKL/";
1678     }
1679 
1680     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1681         merkleRoot = _merkleRoot;
1682 
1683         emit SetMerkleRoot(merkleRoot);
1684     }
1685 
1686     function setPublicPrice(uint256 _publicPrice) external onlyOwner {
1687         publicPrice = _publicPrice;
1688         emit SetPublicPrice(publicPrice);
1689     }
1690 
1691      function setWhitelistPrice(uint256 _whitelistPrice) external onlyOwner {
1692         whiteListPrice = _whitelistPrice;
1693         emit SetWhitelistPrice(whiteListPrice);
1694     }
1695 
1696     /**
1697      * @dev Activate mint
1698      */
1699     function activate(bool _activePresale, bool _activePublic) external onlyOwner{
1700 
1701         activePublic = _activePublic;
1702         activePresale = _activePresale;
1703 
1704         emit Activate(activePresale,activePublic);
1705     }
1706 
1707 
1708     function setPrefixURI(string calldata uri) external onlyOwner {
1709         _prefixURI = uri;
1710     }
1711 
1712     function tokenURI(uint256 tokenId) public view override returns(string memory) {
1713         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1714         return string(abi.encodePacked(_prefixURI, tokenId.toString()));
1715     }
1716 
1717     function PresaleMint(
1718         uint256 amount,
1719         bytes32[] calldata merkleProof
1720     ) public payable nonReentrant {
1721 
1722         require(msg.sender == tx.origin, "NOT EOA");
1723 
1724         require(activePresale && !activePublic,"InactivePresale");
1725 
1726         require(amount > 0 && amount <= 5, "Bad amount");
1727         require(whiteListPrice.mul(amount) <= msg.value, "Ether value sent is not correct");
1728         require(totalSupply() + amount <= maxNFT, "Too many Claimed");
1729         require(presaleClaim[msg.sender] + amount <= 5, "Too many Presale Claimed");
1730 
1731         bytes32 node = keccak256(abi.encodePacked(msg.sender));
1732         require(
1733             MerkleProof.verify(merkleProof, merkleRoot, node),
1734             "MerkleDistributor: Invalid proof."
1735         );
1736 
1737         presaleClaim[msg.sender]  += amount;
1738 
1739         _safeMint(msg.sender, amount);
1740     }
1741 
1742 
1743     function publicMint(uint256 amount) public payable nonReentrant{
1744 
1745         require(msg.sender == tx.origin, "NOT EOA");
1746 
1747         require(!activePresale && activePublic, "InactivePublic");
1748 
1749         require(amount > 0 && amount <= 10, "bad amount");
1750         require(publicPrice.mul(amount) <= msg.value, "Ether value sent is not correct");
1751         require(totalSupply() + amount <= maxNFT, "Too many Claimed");
1752 
1753         _safeMint(msg.sender, amount);
1754     }
1755 
1756     function giftMint(address[] memory _addrs, uint[] memory _amount) public onlyOwner{
1757         uint totalQuantity = 0;
1758         
1759         for(uint i = 0; i < _addrs.length; i ++){
1760             totalQuantity += _amount[i];
1761         }
1762 
1763         require( totalSupply() + totalQuantity <= maxNFT, "Max Limit");
1764 
1765         for(uint i = 0; i < _addrs.length; i ++){
1766             _safeMint(_addrs[i], _amount[i]);
1767         }
1768     }
1769 
1770     function rewardCoffeeNFTS(Reward[] memory rewards) external onlyOwner {
1771         require(!activePresale && !activePublic, "All Inactive");
1772         for (uint i = 0; i < rewards.length; i++) {
1773             require(totalSupply() + rewards[i].amount <= maxNFT, "Too many Claimed");
1774 
1775             _safeMint(rewards[i].recipient, rewards[i].amount);
1776         }
1777     }
1778 
1779     /**
1780      * @dev See {IERC165-supportsInterface}.
1781      */
1782     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A) returns (bool) {
1783         return ERC721A.supportsInterface(interfaceId) || interfaceId == _INTERFACE_ID_ROYALTIES
1784                || interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981 || interfaceId == _INTERFACE_ID_ROYALTIES_RARIBLE;
1785     }
1786 
1787      /**
1788      * ROYALTIES implem: check EIP-2981 https://eips.ethereum.org/EIPS/eip-2981
1789      **/
1790 
1791     function updateRoyalties(address payable recipient, uint256 bps) external onlyOwner {
1792         _royaltyRecipient = recipient;
1793         _royaltyBps = bps;
1794     }
1795 
1796     function getRoyalties(uint256) external view returns (address payable[] memory recipients, uint256[] memory bps) {
1797         if (_royaltyRecipient != address(0x0)) {
1798             recipients = new address payable[](1);
1799             recipients[0] = _royaltyRecipient;
1800             bps = new uint256[](1);
1801             bps[0] = _royaltyBps;
1802         }
1803         return (recipients, bps);
1804     }
1805 
1806     function getFeeRecipients(uint256) external view returns (address payable[] memory recipients) {
1807         if (_royaltyRecipient != address(0x0)) {
1808             recipients = new address payable[](1);
1809             recipients[0] = _royaltyRecipient;
1810         }
1811         return recipients;
1812     }
1813 
1814     function getFeeBps(uint256) external view returns (uint[] memory bps) {
1815         if (_royaltyRecipient != address(0x0)) {
1816             bps = new uint256[](1);
1817             bps[0] = _royaltyBps;
1818         }
1819         return bps;
1820     }
1821 
1822     function royaltyInfo(uint256, uint256 value) external view returns (address, uint256) {
1823         return (_royaltyRecipient, value*_royaltyBps/10000);
1824     }
1825 
1826     function sendFund(address Addr, uint256 Share) internal {
1827           (bool success, ) = Addr.call{value: Share}("");
1828           require(success, "Withdrawal failed"); 
1829     }
1830 
1831     function withdraw() external onlyOwner {
1832        require(address(this).balance > 0, "No balance to withdraw");
1833         
1834         uint papaShare = address(this).balance.mul(15000).div(100000);
1835         uint sonnyShare = address(this).balance.mul(15000).div(100000);
1836         uint zeeShare = address(this).balance.mul(2500).div(100000);
1837         uint reidShare = address(this).balance.mul(5500).div(100000);
1838         uint devShare = address(this).balance.mul(16000).div(100000);
1839     
1840         sendFund(papa, papaShare);
1841         sendFund(sonny, sonnyShare);
1842         sendFund(zee, zeeShare);
1843         sendFund(reid, reidShare);
1844         sendFund(dev, devShare);
1845 
1846         sendFund(community, address(this).balance);
1847     }
1848 
1849 }