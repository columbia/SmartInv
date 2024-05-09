1 // SPDX-License-Identifier: None
2 /*
3 ░██████╗███╗░░░███╗░█████╗░██╗░░░░░██████╗░██╗░░░██╗███╗░░██╗██╗░░██╗░██████╗
4 ██╔════╝████╗░████║██╔══██╗██║░░░░░██╔══██╗██║░░░██║████╗░██║██║░██╔╝██╔════╝
5 ╚█████╗░██╔████╔██║██║░░██║██║░░░░░██████╔╝██║░░░██║██╔██╗██║█████═╝░╚█████╗░
6 ░╚═══██╗██║╚██╔╝██║██║░░██║██║░░░░░██╔═══╝░██║░░░██║██║╚████║██╔═██╗░░╚═══██╗
7 ██████╔╝██║░╚═╝░██║╚█████╔╝███████╗██║░░░░░╚██████╔╝██║░╚███║██║░╚██╗██████╔╝
8 ╚═════╝░╚═╝░░░░░╚═╝░╚════╝░╚══════╝╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═════╝░  
9 */
10 
11 interface IERC165 {
12 function supportsInterface(bytes4 interfaceId) external view returns (bool);
13 }
14 
15 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
16 pragma solidity ^0.8.0;
17 /**
18  * @dev Required interface of an ERC721 compliant contract.
19  */
20 interface IERC721 is IERC165 {
21     /**
22      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
23      */
24     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
25 
26     /**
27      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
28      */
29     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
30 
31     /**
32      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
33      */
34     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
35 
36     /**
37      * @dev Returns the number of tokens in ``owner``'s account.
38      */
39     function balanceOf(address owner) external view returns (uint256 balance);
40 
41     /**
42      * @dev Returns the owner of the `tokenId` token.
43      *
44      * Requirements:
45      *
46      * - `tokenId` must exist.
47      */
48     function ownerOf(uint256 tokenId) external view returns (address owner);
49 
50     /**
51      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
52      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
53      *
54      * Requirements:
55      *
56      * - `from` cannot be the zero address.
57      * - `to` cannot be the zero address.
58      * - `tokenId` token must exist and be owned by `from`.
59      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
60      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
61      *
62      * Emits a {Transfer} event.
63      */
64     function safeTransferFrom(
65         address from,
66         address to,
67         uint256 tokenId
68     ) external;
69 
70     /**
71      * @dev Transfers `tokenId` token from `from` to `to`.
72      *
73      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must be owned by `from`.
80      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
92      * The approval is cleared when the token is transferred.
93      *
94      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
95      *
96      * Requirements:
97      *
98      * - The caller must own the token or be an approved operator.
99      * - `tokenId` must exist.
100      *
101      * Emits an {Approval} event.
102      */
103     function approve(address to, uint256 tokenId) external;
104 
105     /**
106      * @dev Returns the account approved for `tokenId` token.
107      *
108      * Requirements:
109      *
110      * - `tokenId` must exist.
111      */
112     function getApproved(uint256 tokenId) external view returns (address operator);
113 
114     /**
115      * @dev Approve or remove `operator` as an operator for the caller.
116      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
117      *
118      * Requirements:
119      *
120      * - The `operator` cannot be the caller.
121      *
122      * Emits an {ApprovalForAll} event.
123      */
124     function setApprovalForAll(address operator, bool _approved) external;
125 
126     /**
127      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
128      *
129      * See {setApprovalForAll}
130      */
131     function isApprovedForAll(address owner, address operator) external view returns (bool);
132 
133     /**
134      * @dev Safely transfers `tokenId` token from `from` to `to`.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must exist and be owned by `from`.
141      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143      *
144      * Emits a {Transfer} event.
145      */
146     function safeTransferFrom(
147         address from,
148         address to,
149         uint256 tokenId,
150         bytes calldata data
151     ) external;
152 }
153 
154 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
155 pragma solidity ^0.8.0;
156 /**
157  * @dev Implementation of the {IERC165} interface.
158  *
159  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
160  * for the additional interface id that will be supported. For example:
161  *
162  * ```solidity
163  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
164  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
165  * }
166  * ```
167  *
168  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
169  */
170 abstract contract ERC165 is IERC165 {
171     /**
172      * @dev See {IERC165-supportsInterface}.
173      */
174     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
175         return interfaceId == type(IERC165).interfaceId;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/utils/Strings.sol
180 
181 
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev String operations.
187  */
188 library Strings {
189     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
193      */
194     function toString(uint256 value) internal pure returns (string memory) {
195         // Inspired by OraclizeAPI's implementation - MIT licence
196         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
197 
198         if (value == 0) {
199             return "0";
200         }
201         uint256 temp = value;
202         uint256 digits;
203         while (temp != 0) {
204             digits++;
205             temp /= 10;
206         }
207         bytes memory buffer = new bytes(digits);
208         while (value != 0) {
209             digits -= 1;
210             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
211             value /= 10;
212         }
213         return string(buffer);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
218      */
219     function toHexString(uint256 value) internal pure returns (string memory) {
220         if (value == 0) {
221             return "0x00";
222         }
223         uint256 temp = value;
224         uint256 length = 0;
225         while (temp != 0) {
226             length++;
227             temp >>= 8;
228         }
229         return toHexString(value, length);
230     }
231 
232     /**
233      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
234      */
235     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
236         bytes memory buffer = new bytes(2 * length + 2);
237         buffer[0] = "0";
238         buffer[1] = "x";
239         for (uint256 i = 2 * length + 1; i > 1; --i) {
240             buffer[i] = _HEX_SYMBOLS[value & 0xf];
241             value >>= 4;
242         }
243         require(value == 0, "Strings: hex length insufficient");
244         return string(buffer);
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize, which returns 0 for contracts in
277         // construction, since the code is only stored at the end of the
278         // constructor execution.
279 
280         uint256 size;
281         assembly {
282             size := extcodesize(account)
283         }
284         return size > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         (bool success, ) = recipient.call{value: amount}("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain `call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(address(this).balance >= value, "Address: insufficient balance for call");
378         require(isContract(target), "Address: call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.call{value: value}(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
391         return functionStaticCall(target, data, "Address: low-level static call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.staticcall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.delegatecall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
440      * revert reason using the provided one.
441      *
442      * _Available since v4.3._
443      */
444     function verifyCallResult(
445         bool success,
446         bytes memory returndata,
447         string memory errorMessage
448     ) internal pure returns (bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
468 
469 
470 
471 pragma solidity ^0.8.0;
472 
473 
474 /**
475  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
476  * @dev See https://eips.ethereum.org/EIPS/eip-721
477  */
478 interface IERC721Metadata is IERC721 {
479     /**
480      * @dev Returns the token collection name.
481      */
482     function name() external view returns (string memory);
483 
484     /**
485      * @dev Returns the token collection symbol.
486      */
487     function symbol() external view returns (string memory);
488 
489     /**
490      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
491      */
492     function tokenURI(uint256 tokenId) external view returns (string memory);
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
496 
497 
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @title ERC721 token receiver interface
503  * @dev Interface for any contract that wants to support safeTransfers
504  * from ERC721 asset contracts.
505  */
506 interface IERC721Receiver {
507     /**
508      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
509      * by `operator` from `from`, this function is called.
510      *
511      * It must return its Solidity selector to confirm the token transfer.
512      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
513      *
514      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
515      */
516     function onERC721Received(
517         address operator,
518         address from,
519         uint256 tokenId,
520         bytes calldata data
521     ) external returns (bytes4);
522 }
523 
524 // File: @openzeppelin/contracts/utils/Context.sol
525 pragma solidity ^0.8.0;
526 /**
527  * @dev Provides information about the current execution context, including the
528  * sender of the transaction and its data. While these are generally available
529  * via msg.sender and msg.data, they should not be accessed in such a direct
530  * manner, since when dealing with meta-transactions the account sending and
531  * paying for execution may not be the actual sender (as far as an application
532  * is concerned).
533  *
534  * This contract is only required for intermediate, library-like contracts.
535  */
536 abstract contract Context {
537     function _msgSender() internal view virtual returns (address) {
538         return msg.sender;
539     }
540 
541     function _msgData() internal view virtual returns (bytes calldata) {
542         return msg.data;
543     }
544 }
545 
546 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 // CAUTION
551 // This version of SafeMath should only be used with Solidity 0.8 or later,
552 // because it relies on the compiler's built in overflow checks.
553 
554 /**
555  * @dev Wrappers over Solidity's arithmetic operations.
556  *
557  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
558  * now has built in overflow checking.
559  */
560 library SafeMath {
561     /**
562      * @dev Returns the addition of two unsigned integers, with an overflow flag.
563      *
564      * _Available since v3.4._
565      */
566     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
567         unchecked {
568             uint256 c = a + b;
569             if (c < a) return (false, 0);
570             return (true, c);
571         }
572     }
573 
574     /**
575      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
576      *
577      * _Available since v3.4._
578      */
579     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
580         unchecked {
581             if (b > a) return (false, 0);
582             return (true, a - b);
583         }
584     }
585 
586     /**
587      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
588      *
589      * _Available since v3.4._
590      */
591     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
592         unchecked {
593             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
594             // benefit is lost if 'b' is also tested.
595             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
596             if (a == 0) return (true, 0);
597             uint256 c = a * b;
598             if (c / a != b) return (false, 0);
599             return (true, c);
600         }
601     }
602 
603     /**
604      * @dev Returns the division of two unsigned integers, with a division by zero flag.
605      *
606      * _Available since v3.4._
607      */
608     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
609         unchecked {
610             if (b == 0) return (false, 0);
611             return (true, a / b);
612         }
613     }
614 
615     /**
616      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
617      *
618      * _Available since v3.4._
619      */
620     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
621         unchecked {
622             if (b == 0) return (false, 0);
623             return (true, a % b);
624         }
625     }
626 
627     /**
628      * @dev Returns the addition of two unsigned integers, reverting on
629      * overflow.
630      *
631      * Counterpart to Solidity's `+` operator.
632      *
633      * Requirements:
634      *
635      * - Addition cannot overflow.
636      */
637     function add(uint256 a, uint256 b) internal pure returns (uint256) {
638         return a + b;
639     }
640 
641     /**
642      * @dev Returns the subtraction of two unsigned integers, reverting on
643      * overflow (when the result is negative).
644      *
645      * Counterpart to Solidity's `-` operator.
646      *
647      * Requirements:
648      *
649      * - Subtraction cannot overflow.
650      */
651     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
652         return a - b;
653     }
654 
655     /**
656      * @dev Returns the multiplication of two unsigned integers, reverting on
657      * overflow.
658      *
659      * Counterpart to Solidity's `*` operator.
660      *
661      * Requirements:
662      *
663      * - Multiplication cannot overflow.
664      */
665     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
666         return a * b;
667     }
668 
669     /**
670      * @dev Returns the integer division of two unsigned integers, reverting on
671      * division by zero. The result is rounded towards zero.
672      *
673      * Counterpart to Solidity's `/` operator.
674      *
675      * Requirements:
676      *
677      * - The divisor cannot be zero.
678      */
679     function div(uint256 a, uint256 b) internal pure returns (uint256) {
680         return a / b;
681     }
682 
683     /**
684      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
685      * reverting when dividing by zero.
686      *
687      * Counterpart to Solidity's `%` operator. This function uses a `revert`
688      * opcode (which leaves remaining gas untouched) while Solidity uses an
689      * invalid opcode to revert (consuming all remaining gas).
690      *
691      * Requirements:
692      *
693      * - The divisor cannot be zero.
694      */
695     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
696         return a % b;
697     }
698 
699     /**
700      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
701      * overflow (when the result is negative).
702      *
703      * CAUTION: This function is deprecated because it requires allocating memory for the error
704      * message unnecessarily. For custom revert reasons use {trySub}.
705      *
706      * Counterpart to Solidity's `-` operator.
707      *
708      * Requirements:
709      *
710      * - Subtraction cannot overflow.
711      */
712     function sub(
713         uint256 a,
714         uint256 b,
715         string memory errorMessage
716     ) internal pure returns (uint256) {
717         unchecked {
718             require(b <= a, errorMessage);
719             return a - b;
720         }
721     }
722 
723     /**
724      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
725      * division by zero. The result is rounded towards zero.
726      *
727      * Counterpart to Solidity's `/` operator. Note: this function uses a
728      * `revert` opcode (which leaves remaining gas untouched) while Solidity
729      * uses an invalid opcode to revert (consuming all remaining gas).
730      *
731      * Requirements:
732      *
733      * - The divisor cannot be zero.
734      */
735     function div(
736         uint256 a,
737         uint256 b,
738         string memory errorMessage
739     ) internal pure returns (uint256) {
740         unchecked {
741             require(b > 0, errorMessage);
742             return a / b;
743         }
744     }
745 
746     /**
747      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
748      * reverting with custom message when dividing by zero.
749      *
750      * CAUTION: This function is deprecated because it requires allocating memory for the error
751      * message unnecessarily. For custom revert reasons use {tryMod}.
752      *
753      * Counterpart to Solidity's `%` operator. This function uses a `revert`
754      * opcode (which leaves remaining gas untouched) while Solidity uses an
755      * invalid opcode to revert (consuming all remaining gas).
756      *
757      * Requirements:
758      *
759      * - The divisor cannot be zero.
760      */
761     function mod(
762         uint256 a,
763         uint256 b,
764         string memory errorMessage
765     ) internal pure returns (uint256) {
766         unchecked {
767             require(b > 0, errorMessage);
768             return a % b;
769         }
770     }
771 }
772 
773 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
774 
775 pragma solidity ^0.8.0;
776 
777 /**
778  * @title Counters
779  * @author Matt Condon (@shrugs)
780  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
781  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
782  *
783  * Include with `using Counters for Counters.Counter;`
784  */
785 library Counters {
786     struct Counter {
787         // This variable should never be directly accessed by users of the library: interactions must be restricted to
788         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
789         // this feature: see https://github.com/ethereum/solidity/issues/4637
790         uint256 _value; // default: 0
791     }
792 
793     function current(Counter storage counter) internal view returns (uint256) {
794         return counter._value;
795     }
796 
797     function increment(Counter storage counter) internal {
798         unchecked {
799             counter._value += 1;
800         }
801     }
802 
803     function decrement(Counter storage counter) internal {
804         uint256 value = counter._value;
805         require(value > 0, "Counter: decrement overflow");
806         unchecked {
807             counter._value = value - 1;
808         }
809     }
810 
811     function reset(Counter storage counter) internal {
812         counter._value = 0;
813     }
814 }
815 
816 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
817 pragma solidity ^0.8.0;
818 /**
819  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
820  * the Metadata extension, but not including the Enumerable extension, which is available separately as
821  * {ERC721Enumerable}.
822  */
823 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
824     using Address for address;
825     using Strings for uint256;
826 
827     // Token name
828     string private _name;
829 
830     // Token symbol
831     string private _symbol;
832 
833     // Mapping from token ID to owner address
834     mapping(uint256 => address) private _owners;
835 
836     // Mapping owner address to token count
837     mapping(address => uint256) private _balances;
838 
839     // Mapping from token ID to approved address
840     mapping(uint256 => address) private _tokenApprovals;
841 
842     // Mapping from owner to operator approvals
843     mapping(address => mapping(address => bool)) private _operatorApprovals;
844 
845     /**
846      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
847      */
848     constructor(string memory name_, string memory symbol_) {
849         _name = name_;
850         _symbol = symbol_;
851     }
852 
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
857         return
858             interfaceId == type(IERC721).interfaceId ||
859             interfaceId == type(IERC721Metadata).interfaceId ||
860             super.supportsInterface(interfaceId);
861     }
862 
863     /**
864      * @dev See {IERC721-balanceOf}.
865      */
866     function balanceOf(address owner) public view virtual override returns (uint256) {
867         require(owner != address(0), "ERC721: balance query for the zero address");
868         return _balances[owner];
869     }
870 
871     /**
872      * @dev See {IERC721-ownerOf}.
873      */
874     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
875         address owner = _owners[tokenId];
876         require(owner != address(0), "ERC721: owner query for nonexistent token");
877         return owner;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-name}.
882      */
883     function name() public view virtual override returns (string memory) {
884         return _name;
885     }
886 
887     /**
888      * @dev See {IERC721Metadata-symbol}.
889      */
890     function symbol() public view virtual override returns (string memory) {
891         return _symbol;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-tokenURI}.
896      */
897     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
898         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
899 
900         string memory baseURI = _baseURI();
901         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
902     }
903 
904     /**
905      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
906      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
907      * by default, can be overriden in child contracts.
908      */
909     function _baseURI() internal view virtual returns (string memory) {
910         return "";
911     }
912 
913     /**
914      * @dev See {IERC721-approve}.
915      */
916     function approve(address to, uint256 tokenId) public virtual override {
917         address owner = ERC721.ownerOf(tokenId);
918         require(to != owner, "ERC721: approval to current owner");
919 
920         require(
921             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
922             "ERC721: approve caller is not owner nor approved for all"
923         );
924 
925         _approve(to, tokenId);
926     }
927 
928     /**
929      * @dev See {IERC721-getApproved}.
930      */
931     function getApproved(uint256 tokenId) public view virtual override returns (address) {
932         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
933 
934         return _tokenApprovals[tokenId];
935     }
936 
937     /**
938      * @dev See {IERC721-setApprovalForAll}.
939      */
940     function setApprovalForAll(address operator, bool approved) public virtual override {
941         require(operator != _msgSender(), "ERC721: approve to caller");
942 
943         _operatorApprovals[_msgSender()][operator] = approved;
944         emit ApprovalForAll(_msgSender(), operator, approved);
945     }
946 
947     /**
948      * @dev See {IERC721-isApprovedForAll}.
949      */
950     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
951         return _operatorApprovals[owner][operator];
952     }
953 
954     /**
955      * @dev See {IERC721-transferFrom}.
956      */
957     function transferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         //solhint-disable-next-line max-line-length
963         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
964 
965         _transfer(from, to, tokenId);
966     }
967 
968     /**
969      * @dev See {IERC721-safeTransferFrom}.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId
975     ) public virtual override {
976         safeTransferFrom(from, to, tokenId, "");
977     }
978 
979     /**
980      * @dev See {IERC721-safeTransferFrom}.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) public virtual override {
988         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
989         _safeTransfer(from, to, tokenId, _data);
990     }
991 
992     /**
993      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
994      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
995      *
996      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
997      *
998      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
999      * implement alternative mechanisms to perform token transfer, such as signature-based.
1000      *
1001      * Requirements:
1002      *
1003      * - `from` cannot be the zero address.
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must exist and be owned by `from`.
1006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _safeTransfer(
1011         address from,
1012         address to,
1013         uint256 tokenId,
1014         bytes memory _data
1015     ) internal virtual {
1016         _transfer(from, to, tokenId);
1017         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1018     }
1019 
1020     /**
1021      * @dev Returns whether `tokenId` exists.
1022      *
1023      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1024      *
1025      * Tokens start existing when they are minted (`_mint`),
1026      * and stop existing when they are burned (`_burn`).
1027      */
1028     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1029         return _owners[tokenId] != address(0);
1030     }
1031 
1032     /**
1033      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must exist.
1038      */
1039     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1040         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1041         address owner = ERC721.ownerOf(tokenId);
1042         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1043     }
1044 
1045     /**
1046      * @dev Safely mints `tokenId` and transfers it to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - `tokenId` must not exist.
1051      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _safeMint(address to, uint256 tokenId) internal virtual {
1056         _safeMint(to, tokenId, "");
1057     }
1058 
1059     /**
1060      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1061      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1062      */
1063     function _safeMint(
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) internal virtual {
1068         _mint(to, tokenId);
1069         require(
1070             _checkOnERC721Received(address(0), to, tokenId, _data),
1071             "ERC721: transfer to non ERC721Receiver implementer"
1072         );
1073     }
1074 
1075     /**
1076      * @dev Mints `tokenId` and transfers it to `to`.
1077      *
1078      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must not exist.
1083      * - `to` cannot be the zero address.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _mint(address to, uint256 tokenId) internal virtual {
1088         require(to != address(0), "ERC721: mint to the zero address");
1089         require(!_exists(tokenId), "ERC721: token already minted");
1090 
1091         _beforeTokenTransfer(address(0), to, tokenId);
1092 
1093         _balances[to] += 1;
1094         _owners[tokenId] = to;
1095 
1096         emit Transfer(address(0), to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev Destroys `tokenId`.
1101      * The approval is cleared when the token is burned.
1102      *
1103      * Requirements:
1104      *
1105      * - `tokenId` must exist.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _burn(uint256 tokenId) internal virtual {
1110         address owner = ERC721.ownerOf(tokenId);
1111 
1112         _beforeTokenTransfer(owner, address(0), tokenId);
1113 
1114         // Clear approvals
1115         _approve(address(0), tokenId);
1116 
1117         _balances[owner] -= 1;
1118         delete _owners[tokenId];
1119 
1120         emit Transfer(owner, address(0), tokenId);
1121     }
1122 
1123     /**
1124      * @dev Transfers `tokenId` from `from` to `to`.
1125      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must be owned by `from`.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _transfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) internal virtual {
1139         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1140         require(to != address(0), "ERC721: transfer to the zero address");
1141 
1142         _beforeTokenTransfer(from, to, tokenId);
1143 
1144         // Clear approvals from the previous owner
1145         _approve(address(0), tokenId);
1146 
1147         _balances[from] -= 1;
1148         _balances[to] += 1;
1149         _owners[tokenId] = to;
1150 
1151         emit Transfer(from, to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev Approve `to` to operate on `tokenId`
1156      *
1157      * Emits a {Approval} event.
1158      */
1159     function _approve(address to, uint256 tokenId) internal virtual {
1160         _tokenApprovals[tokenId] = to;
1161         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1166      * The call is not executed if the target address is not a contract.
1167      *
1168      * @param from address representing the previous owner of the given token ID
1169      * @param to target address that will receive the tokens
1170      * @param tokenId uint256 ID of the token to be transferred
1171      * @param _data bytes optional data to send along with the call
1172      * @return bool whether the call correctly returned the expected magic value
1173      */
1174     function _checkOnERC721Received(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) private returns (bool) {
1180         if (to.isContract()) {
1181             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1182                 return retval == IERC721Receiver.onERC721Received.selector;
1183             } catch (bytes memory reason) {
1184                 if (reason.length == 0) {
1185                     revert("ERC721: transfer to non ERC721Receiver implementer");
1186                 } else {
1187                     assembly {
1188                         revert(add(32, reason), mload(reason))
1189                     }
1190                 }
1191             }
1192         } else {
1193             return true;
1194         }
1195     }
1196 
1197     /**
1198      * @dev Hook that is called before any token transfer. This includes minting
1199      * and burning.
1200      *
1201      * Calling conditions:
1202      *
1203      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1204      * transferred to `to`.
1205      * - When `from` is zero, `tokenId` will be minted for `to`.
1206      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1207      * - `from` and `to` are never both zero.
1208      *
1209      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1210      */
1211     function _beforeTokenTransfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) internal virtual {}
1216 }
1217 
1218 
1219 
1220 // File: @openzeppelin/contracts/access/Ownable.sol
1221 pragma solidity ^0.8.0;
1222 /**
1223  * @dev Contract module which provides a basic access control mechanism, where
1224  * there is an account (an owner) that can be granted exclusive access to
1225  * specific functions.
1226  *
1227  * By default, the owner account will be the one that deploys the contract. This
1228  * can later be changed with {transferOwnership}.
1229  *
1230  * This module is used through inheritance. It will make available the modifier
1231  * `onlyOwner`, which can be applied to your functions to restrict their use to
1232  * the owner.
1233  */
1234 abstract contract Ownable is Context {
1235     address private _owner;
1236 
1237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1238 
1239     /**
1240      * @dev Initializes the contract setting the deployer as the initial owner.
1241      */
1242     constructor() {
1243         _setOwner(_msgSender());
1244     }
1245 
1246     /**
1247      * @dev Returns the address of the current owner.
1248      */
1249     function owner() public view virtual returns (address) {
1250         return _owner;
1251     }
1252 
1253     /**
1254      * @dev Throws if called by any account other than the owner.
1255      */
1256     modifier onlyOwner() {
1257         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1258         _;
1259     }
1260 
1261     /**
1262      * @dev Leaves the contract without owner. It will not be possible to call
1263      * `onlyOwner` functions anymore. Can only be called by the current owner.
1264      *
1265      * NOTE: Renouncing ownership will leave the contract without an owner,
1266      * thereby removing any functionality that is only available to the owner.
1267      */
1268     function renounceOwnership() public virtual onlyOwner {
1269         _setOwner(address(0));
1270     }
1271 
1272     /**
1273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1274      * Can only be called by the current owner.
1275      */
1276     function transferOwnership(address newOwner) public virtual onlyOwner {
1277         require(newOwner != address(0), "Ownable: new owner is the zero address");
1278         _setOwner(newOwner);
1279     }
1280 
1281     function _setOwner(address newOwner) private {
1282         address oldOwner = _owner;
1283         _owner = newOwner;
1284         emit OwnershipTransferred(oldOwner, newOwner);
1285     }
1286 }
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 contract Smol is Ownable, ERC721 {
1291   
1292   using SafeMath for uint256;
1293   using Counters for Counters.Counter;
1294   Counters.Counter private _tokenIdCounter;
1295   
1296   uint256 public mintPrice = .01 ether;
1297   uint256 public maxSupply = 3333;
1298   uint256 public freeMintAmount = 666;
1299   uint256 private mintLimit = 3;
1300   string private baseURI;
1301   bool public publicSaleState = false;
1302   bool public revealed = false;
1303   string private base_URI_tail = ".json";
1304   string private hiddenURI = "ipfs://Qmc9sSJVnFgDPmbJz1fLiYmHsMoTWTaDWxkwadV49WgvuB/hidden.json";
1305 
1306   constructor() ERC721("SmolPunks", "SMOL") { 
1307   }
1308 
1309   function _hiddenURI() internal view returns (string memory) {
1310     return hiddenURI;
1311   }
1312   
1313   function _baseURI() internal view override returns (string memory) {
1314     return baseURI;
1315   }
1316 
1317   function setBaseURI(string calldata newBaseURI) external onlyOwner {
1318       baseURI = newBaseURI;
1319   }
1320 
1321   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1322     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1323     if(revealed == false) {
1324         return hiddenURI; 
1325     }
1326   string memory currentBaseURI = _baseURI();
1327   return string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), base_URI_tail));
1328   }  
1329 
1330   function reveal() public onlyOwner returns(bool) {
1331     revealed = !revealed;
1332     return revealed;
1333   }
1334       
1335   function changeStatePublicSale() public onlyOwner returns(bool) {
1336     publicSaleState = !publicSaleState;
1337     return publicSaleState;
1338   }
1339 
1340   function mint(uint numberOfTokens) external payable {
1341     require(publicSaleState, "Sale is not active");
1342     require(_tokenIdCounter.current() <= maxSupply, "Not enough tokens left");
1343     require(numberOfTokens <= mintLimit, "Too many tokens for one transaction");
1344     if(_tokenIdCounter.current() >= freeMintAmount){
1345         require(msg.value >= mintPrice.mul(numberOfTokens), "Insufficient payment");
1346     }
1347     mintInternal(msg.sender, numberOfTokens);
1348   }
1349  
1350   function mintInternal(address wallet, uint amount) internal {
1351     uint currentTokenSupply = _tokenIdCounter.current();
1352     require(currentTokenSupply.add(amount) <= maxSupply, "Not enough tokens left");
1353         for(uint i = 0; i< amount; i++){
1354         currentTokenSupply++;
1355         _safeMint(wallet, currentTokenSupply);
1356         _tokenIdCounter.increment();
1357     }
1358   }
1359   
1360   function reserve(uint256 numberOfTokens) external onlyOwner {
1361     mintInternal(msg.sender, numberOfTokens);
1362   }
1363   function setfreeAmount(uint16 _newFreeMints) public onlyOwner() {
1364     freeMintAmount = _newFreeMints;
1365   }
1366 
1367   function totalSupply() public view returns (uint){
1368     return _tokenIdCounter.current();
1369   }
1370 
1371   function withdraw() public onlyOwner {
1372     require(address(this).balance > 0, "No balance to withdraw");
1373     payable(owner()).transfer(address(this).balance); 
1374     }
1375 }