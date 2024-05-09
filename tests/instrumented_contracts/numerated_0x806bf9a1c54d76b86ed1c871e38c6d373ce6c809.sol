1 // File: IBurnable.sol
2 
3 //SPDX-License-Identifier: MIT
4 pragma solidity 0.8.10;
5 
6 interface IBurnable {
7 
8     function burn(
9         uint256 id
10     ) external;
11 
12     function batchBurn(
13         uint256[] memory ids
14     ) external;
15 
16     function ownerOf(uint tokenId) external returns(address);
17 
18 }
19 // File: @openzeppelin/contracts/utils/Strings.sol
20 
21 
22 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
34      */
35     function toString(uint256 value) internal pure returns (string memory) {
36         // Inspired by OraclizeAPI's implementation - MIT licence
37         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
38 
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
59      */
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
75      */
76     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
77         bytes memory buffer = new bytes(2 * length + 2);
78         buffer[0] = "0";
79         buffer[1] = "x";
80         for (uint256 i = 2 * length + 1; i > 1; --i) {
81             buffer[i] = _HEX_SYMBOLS[value & 0xf];
82             value >>= 4;
83         }
84         require(value == 0, "Strings: hex length insufficient");
85         return string(buffer);
86     }
87 }
88 
89 // File: @openzeppelin/contracts/utils/Address.sol
90 
91 
92 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
93 
94 pragma solidity ^0.8.1;
95 
96 /**
97  * @dev Collection of functions related to the address type
98  */
99 library Address {
100     /**
101      * @dev Returns true if `account` is a contract.
102      *
103      * [IMPORTANT]
104      * ====
105      * It is unsafe to assume that an address for which this function returns
106      * false is an externally-owned account (EOA) and not a contract.
107      *
108      * Among others, `isContract` will return false for the following
109      * types of addresses:
110      *
111      *  - an externally-owned account
112      *  - a contract in construction
113      *  - an address where a contract will be created
114      *  - an address where a contract lived, but was destroyed
115      * ====
116      *
117      * [IMPORTANT]
118      * ====
119      * You shouldn't rely on `isContract` to protect against flash loan attacks!
120      *
121      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
122      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
123      * constructor.
124      * ====
125      */
126     function isContract(address account) internal view returns (bool) {
127         // This method relies on extcodesize/address.code.length, which returns 0
128         // for contracts in construction, since the code is only stored at the end
129         // of the constructor execution.
130 
131         return account.code.length > 0;
132     }
133 
134     /**
135      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
136      * `recipient`, forwarding all available gas and reverting on errors.
137      *
138      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
139      * of certain opcodes, possibly making contracts go over the 2300 gas limit
140      * imposed by `transfer`, making them unable to receive funds via
141      * `transfer`. {sendValue} removes this limitation.
142      *
143      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
144      *
145      * IMPORTANT: because control is transferred to `recipient`, care must be
146      * taken to not create reentrancy vulnerabilities. Consider using
147      * {ReentrancyGuard} or the
148      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
149      */
150     function sendValue(address payable recipient, uint256 amount) internal {
151         require(address(this).balance >= amount, "Address: insufficient balance");
152 
153         (bool success, ) = recipient.call{value: amount}("");
154         require(success, "Address: unable to send value, recipient may have reverted");
155     }
156 
157     /**
158      * @dev Performs a Solidity function call using a low level `call`. A
159      * plain `call` is an unsafe replacement for a function call: use this
160      * function instead.
161      *
162      * If `target` reverts with a revert reason, it is bubbled up by this
163      * function (like regular Solidity function calls).
164      *
165      * Returns the raw returned data. To convert to the expected return value,
166      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
167      *
168      * Requirements:
169      *
170      * - `target` must be a contract.
171      * - calling `target` with `data` must not revert.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
176         return functionCall(target, data, "Address: low-level call failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
181      * `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, 0, errorMessage);
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
195      * but also transferring `value` wei to `target`.
196      *
197      * Requirements:
198      *
199      * - the calling contract must have an ETH balance of at least `value`.
200      * - the called Solidity function must be `payable`.
201      *
202      * _Available since v3.1._
203      */
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value
208     ) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
214      * with `errorMessage` as a fallback revert reason when `target` reverts.
215      *
216      * _Available since v3.1._
217      */
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(address(this).balance >= value, "Address: insufficient balance for call");
225         require(isContract(target), "Address: call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.call{value: value}(data);
228         return verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
238         return functionStaticCall(target, data, "Address: low-level static call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(
248         address target,
249         bytes memory data,
250         string memory errorMessage
251     ) internal view returns (bytes memory) {
252         require(isContract(target), "Address: static call to non-contract");
253 
254         (bool success, bytes memory returndata) = target.staticcall(data);
255         return verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         require(isContract(target), "Address: delegate call to non-contract");
280 
281         (bool success, bytes memory returndata) = target.delegatecall(data);
282         return verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
287      * revert reason using the provided one.
288      *
289      * _Available since v4.3._
290      */
291     function verifyCallResult(
292         bool success,
293         bytes memory returndata,
294         string memory errorMessage
295     ) internal pure returns (bytes memory) {
296         if (success) {
297             return returndata;
298         } else {
299             // Look for revert reason and bubble it up if present
300             if (returndata.length > 0) {
301                 // The easiest way to bubble the revert reason is using memory via assembly
302 
303                 assembly {
304                     let returndata_size := mload(returndata)
305                     revert(add(32, returndata), returndata_size)
306                 }
307             } else {
308                 revert(errorMessage);
309             }
310         }
311     }
312 }
313 
314 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
315 
316 
317 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @title ERC721 token receiver interface
323  * @dev Interface for any contract that wants to support safeTransfers
324  * from ERC721 asset contracts.
325  */
326 interface IERC721Receiver {
327     /**
328      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
329      * by `operator` from `from`, this function is called.
330      *
331      * It must return its Solidity selector to confirm the token transfer.
332      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
333      *
334      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
335      */
336     function onERC721Received(
337         address operator,
338         address from,
339         uint256 tokenId,
340         bytes calldata data
341     ) external returns (bytes4);
342 }
343 
344 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev Interface of the ERC165 standard, as defined in the
353  * https://eips.ethereum.org/EIPS/eip-165[EIP].
354  *
355  * Implementers can declare support of contract interfaces, which can then be
356  * queried by others ({ERC165Checker}).
357  *
358  * For an implementation, see {ERC165}.
359  */
360 interface IERC165 {
361     /**
362      * @dev Returns true if this contract implements the interface defined by
363      * `interfaceId`. See the corresponding
364      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
365      * to learn more about how these ids are created.
366      *
367      * This function call must use less than 30 000 gas.
368      */
369     function supportsInterface(bytes4 interfaceId) external view returns (bool);
370 }
371 
372 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 
380 /**
381  * @dev Implementation of the {IERC165} interface.
382  *
383  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
384  * for the additional interface id that will be supported. For example:
385  *
386  * ```solidity
387  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
388  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
389  * }
390  * ```
391  *
392  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
393  */
394 abstract contract ERC165 is IERC165 {
395     /**
396      * @dev See {IERC165-supportsInterface}.
397      */
398     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
399         return interfaceId == type(IERC165).interfaceId;
400     }
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
404 
405 
406 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 
411 /**
412  * @dev Required interface of an ERC721 compliant contract.
413  */
414 interface IERC721 is IERC165 {
415     /**
416      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
417      */
418     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
419 
420     /**
421      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
422      */
423     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
424 
425     /**
426      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
427      */
428     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
429 
430     /**
431      * @dev Returns the number of tokens in ``owner``'s account.
432      */
433     function balanceOf(address owner) external view returns (uint256 balance);
434 
435     /**
436      * @dev Returns the owner of the `tokenId` token.
437      *
438      * Requirements:
439      *
440      * - `tokenId` must exist.
441      */
442     function ownerOf(uint256 tokenId) external view returns (address owner);
443 
444     /**
445      * @dev Safely transfers `tokenId` token from `from` to `to`.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must exist and be owned by `from`.
452      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
454      *
455      * Emits a {Transfer} event.
456      */
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId,
461         bytes calldata data
462     ) external;
463 
464     /**
465      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
466      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must exist and be owned by `from`.
473      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
474      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
475      *
476      * Emits a {Transfer} event.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId
482     ) external;
483 
484     /**
485      * @dev Transfers `tokenId` token from `from` to `to`.
486      *
487      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
488      *
489      * Requirements:
490      *
491      * - `from` cannot be the zero address.
492      * - `to` cannot be the zero address.
493      * - `tokenId` token must be owned by `from`.
494      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
495      *
496      * Emits a {Transfer} event.
497      */
498     function transferFrom(
499         address from,
500         address to,
501         uint256 tokenId
502     ) external;
503 
504     /**
505      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
506      * The approval is cleared when the token is transferred.
507      *
508      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
509      *
510      * Requirements:
511      *
512      * - The caller must own the token or be an approved operator.
513      * - `tokenId` must exist.
514      *
515      * Emits an {Approval} event.
516      */
517     function approve(address to, uint256 tokenId) external;
518 
519     /**
520      * @dev Approve or remove `operator` as an operator for the caller.
521      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
522      *
523      * Requirements:
524      *
525      * - The `operator` cannot be the caller.
526      *
527      * Emits an {ApprovalForAll} event.
528      */
529     function setApprovalForAll(address operator, bool _approved) external;
530 
531     /**
532      * @dev Returns the account approved for `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function getApproved(uint256 tokenId) external view returns (address operator);
539 
540     /**
541      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
542      *
543      * See {setApprovalForAll}
544      */
545     function isApprovedForAll(address owner, address operator) external view returns (bool);
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
549 
550 
551 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
558  * @dev See https://eips.ethereum.org/EIPS/eip-721
559  */
560 interface IERC721Enumerable is IERC721 {
561     /**
562      * @dev Returns the total amount of tokens stored by the contract.
563      */
564     function totalSupply() external view returns (uint256);
565 
566     /**
567      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
568      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
569      */
570     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
571 
572     /**
573      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
574      * Use along with {totalSupply} to enumerate all tokens.
575      */
576     function tokenByIndex(uint256 index) external view returns (uint256);
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
580 
581 
582 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
589  * @dev See https://eips.ethereum.org/EIPS/eip-721
590  */
591 interface IERC721Metadata is IERC721 {
592     /**
593      * @dev Returns the token collection name.
594      */
595     function name() external view returns (string memory);
596 
597     /**
598      * @dev Returns the token collection symbol.
599      */
600     function symbol() external view returns (string memory);
601 
602     /**
603      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
604      */
605     function tokenURI(uint256 tokenId) external view returns (string memory);
606 }
607 
608 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
609 
610 
611 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 // CAUTION
616 // This version of SafeMath should only be used with Solidity 0.8 or later,
617 // because it relies on the compiler's built in overflow checks.
618 
619 /**
620  * @dev Wrappers over Solidity's arithmetic operations.
621  *
622  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
623  * now has built in overflow checking.
624  */
625 library SafeMath {
626     /**
627      * @dev Returns the addition of two unsigned integers, with an overflow flag.
628      *
629      * _Available since v3.4._
630      */
631     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
632         unchecked {
633             uint256 c = a + b;
634             if (c < a) return (false, 0);
635             return (true, c);
636         }
637     }
638 
639     /**
640      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
641      *
642      * _Available since v3.4._
643      */
644     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             if (b > a) return (false, 0);
647             return (true, a - b);
648         }
649     }
650 
651     /**
652      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
653      *
654      * _Available since v3.4._
655      */
656     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
657         unchecked {
658             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
659             // benefit is lost if 'b' is also tested.
660             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
661             if (a == 0) return (true, 0);
662             uint256 c = a * b;
663             if (c / a != b) return (false, 0);
664             return (true, c);
665         }
666     }
667 
668     /**
669      * @dev Returns the division of two unsigned integers, with a division by zero flag.
670      *
671      * _Available since v3.4._
672      */
673     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
674         unchecked {
675             if (b == 0) return (false, 0);
676             return (true, a / b);
677         }
678     }
679 
680     /**
681      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
682      *
683      * _Available since v3.4._
684      */
685     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
686         unchecked {
687             if (b == 0) return (false, 0);
688             return (true, a % b);
689         }
690     }
691 
692     /**
693      * @dev Returns the addition of two unsigned integers, reverting on
694      * overflow.
695      *
696      * Counterpart to Solidity's `+` operator.
697      *
698      * Requirements:
699      *
700      * - Addition cannot overflow.
701      */
702     function add(uint256 a, uint256 b) internal pure returns (uint256) {
703         return a + b;
704     }
705 
706     /**
707      * @dev Returns the subtraction of two unsigned integers, reverting on
708      * overflow (when the result is negative).
709      *
710      * Counterpart to Solidity's `-` operator.
711      *
712      * Requirements:
713      *
714      * - Subtraction cannot overflow.
715      */
716     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
717         return a - b;
718     }
719 
720     /**
721      * @dev Returns the multiplication of two unsigned integers, reverting on
722      * overflow.
723      *
724      * Counterpart to Solidity's `*` operator.
725      *
726      * Requirements:
727      *
728      * - Multiplication cannot overflow.
729      */
730     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
731         return a * b;
732     }
733 
734     /**
735      * @dev Returns the integer division of two unsigned integers, reverting on
736      * division by zero. The result is rounded towards zero.
737      *
738      * Counterpart to Solidity's `/` operator.
739      *
740      * Requirements:
741      *
742      * - The divisor cannot be zero.
743      */
744     function div(uint256 a, uint256 b) internal pure returns (uint256) {
745         return a / b;
746     }
747 
748     /**
749      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
750      * reverting when dividing by zero.
751      *
752      * Counterpart to Solidity's `%` operator. This function uses a `revert`
753      * opcode (which leaves remaining gas untouched) while Solidity uses an
754      * invalid opcode to revert (consuming all remaining gas).
755      *
756      * Requirements:
757      *
758      * - The divisor cannot be zero.
759      */
760     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
761         return a % b;
762     }
763 
764     /**
765      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
766      * overflow (when the result is negative).
767      *
768      * CAUTION: This function is deprecated because it requires allocating memory for the error
769      * message unnecessarily. For custom revert reasons use {trySub}.
770      *
771      * Counterpart to Solidity's `-` operator.
772      *
773      * Requirements:
774      *
775      * - Subtraction cannot overflow.
776      */
777     function sub(
778         uint256 a,
779         uint256 b,
780         string memory errorMessage
781     ) internal pure returns (uint256) {
782         unchecked {
783             require(b <= a, errorMessage);
784             return a - b;
785         }
786     }
787 
788     /**
789      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
790      * division by zero. The result is rounded towards zero.
791      *
792      * Counterpart to Solidity's `/` operator. Note: this function uses a
793      * `revert` opcode (which leaves remaining gas untouched) while Solidity
794      * uses an invalid opcode to revert (consuming all remaining gas).
795      *
796      * Requirements:
797      *
798      * - The divisor cannot be zero.
799      */
800     function div(
801         uint256 a,
802         uint256 b,
803         string memory errorMessage
804     ) internal pure returns (uint256) {
805         unchecked {
806             require(b > 0, errorMessage);
807             return a / b;
808         }
809     }
810 
811     /**
812      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
813      * reverting with custom message when dividing by zero.
814      *
815      * CAUTION: This function is deprecated because it requires allocating memory for the error
816      * message unnecessarily. For custom revert reasons use {tryMod}.
817      *
818      * Counterpart to Solidity's `%` operator. This function uses a `revert`
819      * opcode (which leaves remaining gas untouched) while Solidity uses an
820      * invalid opcode to revert (consuming all remaining gas).
821      *
822      * Requirements:
823      *
824      * - The divisor cannot be zero.
825      */
826     function mod(
827         uint256 a,
828         uint256 b,
829         string memory errorMessage
830     ) internal pure returns (uint256) {
831         unchecked {
832             require(b > 0, errorMessage);
833             return a % b;
834         }
835     }
836 }
837 
838 // File: @openzeppelin/contracts/utils/Context.sol
839 
840 
841 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
842 
843 pragma solidity ^0.8.0;
844 
845 /**
846  * @dev Provides information about the current execution context, including the
847  * sender of the transaction and its data. While these are generally available
848  * via msg.sender and msg.data, they should not be accessed in such a direct
849  * manner, since when dealing with meta-transactions the account sending and
850  * paying for execution may not be the actual sender (as far as an application
851  * is concerned).
852  *
853  * This contract is only required for intermediate, library-like contracts.
854  */
855 abstract contract Context {
856     function _msgSender() internal view virtual returns (address) {
857         return msg.sender;
858     }
859 
860     function _msgData() internal view virtual returns (bytes calldata) {
861         return msg.data;
862     }
863 }
864 
865 // File: ERC721A.sol
866 
867 
868 // Creator: Chiru Labs
869 
870 pragma solidity ^0.8.0;
871 
872 
873 
874 
875 
876 
877 
878 
879 
880 /**
881  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
882  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
883  *
884  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
885  *
886  * Does not support burning tokens to address(0).
887  *
888  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
889  */
890 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
891     using Address for address;
892     using Strings for uint256;
893 
894     struct TokenOwnership {
895         address addr;
896         uint64 startTimestamp;
897     }
898 
899     struct AddressData {
900         uint128 balance;
901         uint128 numberMinted;
902     }
903 
904     uint256 internal currentIndex;
905 
906     // Token name
907     string private _name;
908 
909     // Token symbol
910     string private _symbol;
911 
912     // Mapping from token ID to ownership details
913     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
914     mapping(uint256 => TokenOwnership) internal _ownerships;
915 
916     // Mapping owner address to address data
917     mapping(address => AddressData) private _addressData;
918 
919     // Mapping from token ID to approved address
920     mapping(uint256 => address) private _tokenApprovals;
921 
922     // Mapping from owner to operator approvals
923     mapping(address => mapping(address => bool)) private _operatorApprovals;
924 
925     constructor(string memory name_, string memory symbol_) {
926         _name = name_;
927         _symbol = symbol_;
928     }
929 
930     /**
931      * @dev See {IERC721Enumerable-totalSupply}.
932      */
933     function totalSupply() public view override returns (uint256) {
934         return currentIndex;
935     }
936 
937     /**
938      * @dev See {IERC721Enumerable-tokenByIndex}.
939      */
940     function tokenByIndex(uint256 index) public view override returns (uint256) {
941         require(index < totalSupply(), 'ERC721A: global index out of bounds');
942         return index;
943     }
944 
945     /**
946      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
947      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
948      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
949      */
950     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
951         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
952         uint256 numMintedSoFar = totalSupply();
953         uint256 tokenIdsIdx;
954         address currOwnershipAddr;
955 
956         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
957         unchecked {
958             for (uint256 i; i < numMintedSoFar; i++) {
959                 TokenOwnership memory ownership = _ownerships[i];
960                 if (ownership.addr != address(0)) {
961                     currOwnershipAddr = ownership.addr;
962                 }
963                 if (currOwnershipAddr == owner) {
964                     if (tokenIdsIdx == index) {
965                         return i;
966                     }
967                     tokenIdsIdx++;
968                 }
969             }
970         }
971 
972         revert('ERC721A: unable to get token of owner by index');
973     }
974 
975     /**
976      * @dev See {IERC165-supportsInterface}.
977      */
978     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
979         return
980             interfaceId == type(IERC721).interfaceId ||
981             interfaceId == type(IERC721Metadata).interfaceId ||
982             interfaceId == type(IERC721Enumerable).interfaceId ||
983             super.supportsInterface(interfaceId);
984     }
985 
986     /**
987      * @dev See {IERC721-balanceOf}.
988      */
989     function balanceOf(address owner) public view override returns (uint256) {
990         require(owner != address(0), 'ERC721A: balance query for the zero address');
991         return uint256(_addressData[owner].balance);
992     }
993 
994     function _numberMinted(address owner) internal view returns (uint256) {
995         require(owner != address(0), 'ERC721A: number minted query for the zero address');
996         return uint256(_addressData[owner].numberMinted);
997     }
998 
999     /**
1000      * Gas spent here starts off proportional to the maximum mint batch size.
1001      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1002      */
1003     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1004         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1005 
1006         unchecked {
1007             for (uint256 curr = tokenId; curr >= 0; curr--) {
1008                 TokenOwnership memory ownership = _ownerships[curr];
1009                 if (ownership.addr != address(0)) {
1010                     return ownership;
1011                 }
1012             }
1013         }
1014 
1015         revert('ERC721A: unable to determine the owner of token');
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-ownerOf}.
1020      */
1021     function ownerOf(uint256 tokenId) public view override returns (address) {
1022         return ownershipOf(tokenId).addr;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Metadata-name}.
1027      */
1028     function name() public view virtual override returns (string memory) {
1029         return _name;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Metadata-symbol}.
1034      */
1035     function symbol() public view virtual override returns (string memory) {
1036         return _symbol;
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Metadata-tokenURI}.
1041      */
1042     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1043         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1044 
1045         string memory baseURI = _baseURI();
1046         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1047     }
1048 
1049     /**
1050      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1051      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1052      * by default, can be overriden in child contracts.
1053      */
1054     function _baseURI() internal view virtual returns (string memory) {
1055         return '';
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-approve}.
1060      */
1061     function approve(address to, uint256 tokenId) public override {
1062         address owner = ERC721A.ownerOf(tokenId);
1063         require(to != owner, 'ERC721A: approval to current owner');
1064 
1065         require(
1066             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1067             'ERC721A: approve caller is not owner nor approved for all'
1068         );
1069 
1070         _approve(to, tokenId, owner);
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-getApproved}.
1075      */
1076     function getApproved(uint256 tokenId) public view override returns (address) {
1077         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1078 
1079         return _tokenApprovals[tokenId];
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-setApprovalForAll}.
1084      */
1085     function setApprovalForAll(address operator, bool approved) public override {
1086         require(operator != _msgSender(), 'ERC721A: approve to caller');
1087 
1088         _operatorApprovals[_msgSender()][operator] = approved;
1089         emit ApprovalForAll(_msgSender(), operator, approved);
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-isApprovedForAll}.
1094      */
1095     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1096         return _operatorApprovals[owner][operator];
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-transferFrom}.
1101      */
1102     function transferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public override {
1107         _transfer(from, to, tokenId);
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-safeTransferFrom}.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) public override {
1118         safeTransferFrom(from, to, tokenId, '');
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-safeTransferFrom}.
1123      */
1124     function safeTransferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId,
1128         bytes memory _data
1129     ) public override {
1130         _transfer(from, to, tokenId);
1131         require(
1132             _checkOnERC721Received(from, to, tokenId, _data),
1133             'ERC721A: transfer to non ERC721Receiver implementer'
1134         );
1135     }
1136 
1137     /**
1138      * @dev Returns whether `tokenId` exists.
1139      *
1140      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1141      *
1142      * Tokens start existing when they are minted (`_mint`),
1143      */
1144     function _exists(uint256 tokenId) internal view returns (bool) {
1145         return tokenId < currentIndex;
1146     }
1147 
1148     function _safeMint(address to, uint256 quantity) internal {
1149         _safeMint(to, quantity, '');
1150     }
1151 
1152     /**
1153      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1158      * - `quantity` must be greater than 0.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _safeMint(
1163         address to,
1164         uint256 quantity,
1165         bytes memory _data
1166     ) internal {
1167         _mint(to, quantity, _data, true);
1168     }
1169 
1170     /**
1171      * @dev Mints `quantity` tokens and transfers them to `to`.
1172      *
1173      * Requirements:
1174      *
1175      * - `to` cannot be the zero address.
1176      * - `quantity` must be greater than 0.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _mint(
1181         address to,
1182         uint256 quantity,
1183         bytes memory _data,
1184         bool safe
1185     ) internal {
1186         uint256 startTokenId = currentIndex;
1187         require(to != address(0), 'ERC721A: mint to the zero address');
1188         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1189 
1190         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1191 
1192         // Overflows are incredibly unrealistic.
1193         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1194         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1195         unchecked {
1196             _addressData[to].balance += uint128(quantity);
1197             _addressData[to].numberMinted += uint128(quantity);
1198 
1199             _ownerships[startTokenId].addr = to;
1200             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1201 
1202             uint256 updatedIndex = startTokenId;
1203 
1204             for (uint256 i; i < quantity; i++) {
1205                 emit Transfer(address(0), to, updatedIndex);
1206                 if (safe) {
1207                     require(
1208                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1209                         'ERC721A: transfer to non ERC721Receiver implementer'
1210                     );
1211                 }
1212 
1213                 updatedIndex++;
1214             }
1215 
1216             currentIndex = updatedIndex;
1217         }
1218 
1219         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1220     }
1221 
1222     /**
1223      * @dev Transfers `tokenId` from `from` to `to`.
1224      *
1225      * Requirements:
1226      *
1227      * - `to` cannot be the zero address.
1228      * - `tokenId` token must be owned by `from`.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _transfer(
1233         address from,
1234         address to,
1235         uint256 tokenId
1236     ) private {
1237         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1238 
1239         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1240             getApproved(tokenId) == _msgSender() ||
1241             isApprovedForAll(prevOwnership.addr, _msgSender()));
1242 
1243         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1244 
1245         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1246         require(to != address(0), 'ERC721A: transfer to the zero address');
1247 
1248         _beforeTokenTransfers(from, to, tokenId, 1);
1249 
1250         // Clear approvals from the previous owner
1251         _approve(address(0), tokenId, prevOwnership.addr);
1252 
1253         // Underflow of the sender's balance is impossible because we check for
1254         // ownership above and the recipient's balance can't realistically overflow.
1255         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1256         unchecked {
1257             _addressData[from].balance -= 1;
1258             _addressData[to].balance += 1;
1259 
1260             _ownerships[tokenId].addr = to;
1261             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1262 
1263             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1264             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1265             uint256 nextTokenId = tokenId + 1;
1266             if (_ownerships[nextTokenId].addr == address(0)) {
1267                 if (_exists(nextTokenId)) {
1268                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1269                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1270                 }
1271             }
1272         }
1273 
1274         emit Transfer(from, to, tokenId);
1275         _afterTokenTransfers(from, to, tokenId, 1);
1276     }
1277 
1278     /**
1279      * @dev Approve `to` to operate on `tokenId`
1280      *
1281      * Emits a {Approval} event.
1282      */
1283     function _approve(
1284         address to,
1285         uint256 tokenId,
1286         address owner
1287     ) private {
1288         _tokenApprovals[tokenId] = to;
1289         emit Approval(owner, to, tokenId);
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
1310                 return retval == IERC721Receiver(to).onERC721Received.selector;
1311             } catch (bytes memory reason) {
1312                 if (reason.length == 0) {
1313                     revert('ERC721A: transfer to non ERC721Receiver implementer');
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
1326      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1327      *
1328      * startTokenId - the first token id to be transferred
1329      * quantity - the amount to be transferred
1330      *
1331      * Calling conditions:
1332      *
1333      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1334      * transferred to `to`.
1335      * - When `from` is zero, `tokenId` will be minted for `to`.
1336      */
1337     function _beforeTokenTransfers(
1338         address from,
1339         address to,
1340         uint256 startTokenId,
1341         uint256 quantity
1342     ) internal virtual {}
1343 
1344     /**
1345      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1346      * minting.
1347      *
1348      * startTokenId - the first token id to be transferred
1349      * quantity - the amount to be transferred
1350      *
1351      * Calling conditions:
1352      *
1353      * - when `from` and `to` are both non-zero.
1354      * - `from` and `to` are never both zero.
1355      */
1356     function _afterTokenTransfers(
1357         address from,
1358         address to,
1359         uint256 startTokenId,
1360         uint256 quantity
1361     ) internal virtual {}
1362 }
1363 // File: @openzeppelin/contracts/security/Pausable.sol
1364 
1365 
1366 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1367 
1368 pragma solidity ^0.8.0;
1369 
1370 
1371 /**
1372  * @dev Contract module which allows children to implement an emergency stop
1373  * mechanism that can be triggered by an authorized account.
1374  *
1375  * This module is used through inheritance. It will make available the
1376  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1377  * the functions of your contract. Note that they will not be pausable by
1378  * simply including this module, only once the modifiers are put in place.
1379  */
1380 abstract contract Pausable is Context {
1381     /**
1382      * @dev Emitted when the pause is triggered by `account`.
1383      */
1384     event Paused(address account);
1385 
1386     /**
1387      * @dev Emitted when the pause is lifted by `account`.
1388      */
1389     event Unpaused(address account);
1390 
1391     bool private _paused;
1392 
1393     /**
1394      * @dev Initializes the contract in unpaused state.
1395      */
1396     constructor() {
1397         _paused = false;
1398     }
1399 
1400     /**
1401      * @dev Returns true if the contract is paused, and false otherwise.
1402      */
1403     function paused() public view virtual returns (bool) {
1404         return _paused;
1405     }
1406 
1407     /**
1408      * @dev Modifier to make a function callable only when the contract is not paused.
1409      *
1410      * Requirements:
1411      *
1412      * - The contract must not be paused.
1413      */
1414     modifier whenNotPaused() {
1415         require(!paused(), "Pausable: paused");
1416         _;
1417     }
1418 
1419     /**
1420      * @dev Modifier to make a function callable only when the contract is paused.
1421      *
1422      * Requirements:
1423      *
1424      * - The contract must be paused.
1425      */
1426     modifier whenPaused() {
1427         require(paused(), "Pausable: not paused");
1428         _;
1429     }
1430 
1431     /**
1432      * @dev Triggers stopped state.
1433      *
1434      * Requirements:
1435      *
1436      * - The contract must not be paused.
1437      */
1438     function _pause() internal virtual whenNotPaused {
1439         _paused = true;
1440         emit Paused(_msgSender());
1441     }
1442 
1443     /**
1444      * @dev Returns to normal state.
1445      *
1446      * Requirements:
1447      *
1448      * - The contract must be paused.
1449      */
1450     function _unpause() internal virtual whenPaused {
1451         _paused = false;
1452         emit Unpaused(_msgSender());
1453     }
1454 }
1455 
1456 // File: @openzeppelin/contracts/access/Ownable.sol
1457 
1458 
1459 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1460 
1461 pragma solidity ^0.8.0;
1462 
1463 
1464 /**
1465  * @dev Contract module which provides a basic access control mechanism, where
1466  * there is an account (an owner) that can be granted exclusive access to
1467  * specific functions.
1468  *
1469  * By default, the owner account will be the one that deploys the contract. This
1470  * can later be changed with {transferOwnership}.
1471  *
1472  * This module is used through inheritance. It will make available the modifier
1473  * `onlyOwner`, which can be applied to your functions to restrict their use to
1474  * the owner.
1475  */
1476 abstract contract Ownable is Context {
1477     address private _owner;
1478 
1479     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1480 
1481     /**
1482      * @dev Initializes the contract setting the deployer as the initial owner.
1483      */
1484     constructor() {
1485         _transferOwnership(_msgSender());
1486     }
1487 
1488     /**
1489      * @dev Returns the address of the current owner.
1490      */
1491     function owner() public view virtual returns (address) {
1492         return _owner;
1493     }
1494 
1495     /**
1496      * @dev Throws if called by any account other than the owner.
1497      */
1498     modifier onlyOwner() {
1499         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1500         _;
1501     }
1502 
1503     /**
1504      * @dev Leaves the contract without owner. It will not be possible to call
1505      * `onlyOwner` functions anymore. Can only be called by the current owner.
1506      *
1507      * NOTE: Renouncing ownership will leave the contract without an owner,
1508      * thereby removing any functionality that is only available to the owner.
1509      */
1510     function renounceOwnership() public virtual onlyOwner {
1511         _transferOwnership(address(0));
1512     }
1513 
1514     /**
1515      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1516      * Can only be called by the current owner.
1517      */
1518     function transferOwnership(address newOwner) public virtual onlyOwner {
1519         require(newOwner != address(0), "Ownable: new owner is the zero address");
1520         _transferOwnership(newOwner);
1521     }
1522 
1523     /**
1524      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1525      * Internal function without access restriction.
1526      */
1527     function _transferOwnership(address newOwner) internal virtual {
1528         address oldOwner = _owner;
1529         _owner = newOwner;
1530         emit OwnershipTransferred(oldOwner, newOwner);
1531     }
1532 }
1533 
1534 // File: MutantFlies.sol
1535 
1536 pragma solidity ^0.8.10;
1537 
1538 contract MutantFlies is ERC721A, Ownable {
1539 
1540     address immutable canContract = 0xF26c762a9Fb1757050871DbDbd4fD6062eabFF5d;
1541 
1542     address immutable flyTrapContract = 0xF177e1cb08628e9338E01A3015F3ca8978413612;
1543 
1544     //BaseURI
1545     string public baseURI = "ipfs://default";
1546 
1547     //Max Public Supply
1548     uint public maxPublicMint = 1255;
1549 
1550     //Max Burn Supply
1551     uint public maxBurnMint = 4300;
1552 
1553     //Max Per TX
1554     uint public maxMintPerTxn = 50;
1555 
1556     //price
1557     uint256 public price = 0.06 ether;
1558 
1559     //TrackPublic
1560     uint public numPublicMinted = 0;
1561 
1562     //TrackBurned
1563     uint public numBurnMinted = 0;
1564 
1565     //public Active?
1566     bool public isPublicMint = false;
1567 
1568     //paused
1569     bool public paused = true;
1570 
1571     constructor(string memory _name, string memory _symbol) ERC721A(_name, _symbol) {
1572 
1573     }
1574 
1575     /*--------------READ and WRITE FUNCTIONS--------------*/
1576 
1577     function burnMint(uint[] calldata nftTokenIds, bool _flyTrap) external {
1578 
1579         IBurnable burnableContract;
1580         uint amount;
1581 
1582         uint length = nftTokenIds.length;
1583 
1584         require(amount + numBurnMinted <= maxBurnMint, "All Mutation Burn Mints Claimed");
1585 
1586         require(paused == false, "Minting is paused");
1587 
1588         if(_flyTrap) {
1589             burnableContract = IBurnable(flyTrapContract);
1590             amount = (7 * length);
1591         } else {
1592             burnableContract = IBurnable(canContract);
1593             amount = length;
1594         }
1595 
1596         for(uint i = 0; i < length;) {
1597 
1598             require(burnableContract.ownerOf(nftTokenIds[i]) == msg.sender, "user doesn't own this nft");
1599 
1600             unchecked {
1601                 ++i;
1602             }
1603         }
1604 
1605         burnableContract.batchBurn(nftTokenIds);
1606 
1607         numBurnMinted += amount;
1608 
1609         _safeMint(msg.sender, amount, "");
1610 
1611     }
1612 
1613     function publicMint(uint amount) external payable {
1614 
1615         require(isPublicMint == true, "Minting isn't public");
1616 
1617         require(paused == false, "Minting is paused");
1618 
1619         require(amount + numPublicMinted <= maxPublicMint, "Trying to mint more than max");
1620 
1621         require(amount < maxMintPerTxn, "Cant mint as much per txn");
1622 
1623         require(msg.value == price * amount, "Invalid amount sent");
1624 
1625         numPublicMinted += amount;
1626 
1627         _mint(msg.sender, amount, "", true);
1628 
1629     }
1630 
1631     function _baseURI() internal view override returns (string memory) {
1632         return baseURI;
1633     }
1634 
1635     function setBaseURI(string calldata _uri) external onlyOwner {
1636 
1637         baseURI = _uri;
1638 
1639     }
1640 
1641     function setPubicMint(bool _value) external onlyOwner {
1642 
1643         isPublicMint = _value;
1644 
1645     }
1646 
1647     function setPrice(uint256 _price) external onlyOwner {
1648 
1649         price = _price;
1650 
1651     }
1652 
1653     function setMaxPublicMint(uint256 _maxPublicMint) external onlyOwner {
1654 
1655         maxPublicMint = _maxPublicMint;
1656 
1657     }
1658 
1659     function setMaxBurnMint(uint256 _maxBurnMint) external onlyOwner {
1660 
1661         maxBurnMint = _maxBurnMint;
1662 
1663     }
1664 
1665     function setMaxMintPerTxn(uint256 _maxMintPerTxn) external onlyOwner {
1666 
1667         maxMintPerTxn = _maxMintPerTxn;
1668 
1669     }
1670 
1671     function pause(bool _paused) external onlyOwner {
1672 
1673         paused = _paused;
1674 
1675     }
1676 
1677     function withdraw() public payable onlyOwner {
1678         (bool success, ) = payable(msg.sender).call{
1679             value: address(this).balance
1680         }("");
1681         require(success);
1682     }
1683 }