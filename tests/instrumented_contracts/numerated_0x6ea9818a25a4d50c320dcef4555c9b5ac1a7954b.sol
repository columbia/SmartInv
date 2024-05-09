1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-07
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Address.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Collection of functions related to the address type
84  */
85 library Address {
86     /**
87      * @dev Returns true if `account` is a contract.
88      *
89      * [IMPORTANT]
90      * ====
91      * It is unsafe to assume that an address for which this function returns
92      * false is an externally-owned account (EOA) and not a contract.
93      *
94      * Among others, `isContract` will return false for the following
95      * types of addresses:
96      *
97      *  - an externally-owned account
98      *  - a contract in construction
99      *  - an address where a contract will be created
100      *  - an address where a contract lived, but was destroyed
101      * ====
102      */
103     function isContract(address account) internal view returns (bool) {
104         // This method relies on extcodesize, which returns 0 for contracts in
105         // construction, since the code is only stored at the end of the
106         // constructor execution.
107 
108         uint256 size;
109         assembly {
110             size := extcodesize(account)
111         }
112         return size > 0;
113     }
114 
115     /**
116      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
117      * `recipient`, forwarding all available gas and reverting on errors.
118      *
119      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
120      * of certain opcodes, possibly making contracts go over the 2300 gas limit
121      * imposed by `transfer`, making them unable to receive funds via
122      * `transfer`. {sendValue} removes this limitation.
123      *
124      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
125      *
126      * IMPORTANT: because control is transferred to `recipient`, care must be
127      * taken to not create reentrancy vulnerabilities. Consider using
128      * {ReentrancyGuard} or the
129      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
130      */
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         (bool success, ) = recipient.call{value: amount}("");
135         require(success, "Address: unable to send value, recipient may have reverted");
136     }
137 
138     /**
139      * @dev Performs a Solidity function call using a low level `call`. A
140      * plain `call` is an unsafe replacement for a function call: use this
141      * function instead.
142      *
143      * If `target` reverts with a revert reason, it is bubbled up by this
144      * function (like regular Solidity function calls).
145      *
146      * Returns the raw returned data. To convert to the expected return value,
147      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
148      *
149      * Requirements:
150      *
151      * - `target` must be a contract.
152      * - calling `target` with `data` must not revert.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
162      * `errorMessage` as a fallback revert reason when `target` reverts.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(address(this).balance >= value, "Address: insufficient balance for call");
206         require(isContract(target), "Address: call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.call{value: value}(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but performing a static call.
215      *
216      * _Available since v3.3._
217      */
218     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
219         return functionStaticCall(target, data, "Address: low-level static call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal view returns (bytes memory) {
233         require(isContract(target), "Address: static call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.staticcall(data);
236         return verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a delegate call.
242      *
243      * _Available since v3.4._
244      */
245     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(isContract(target), "Address: delegate call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.delegatecall(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
268      * revert reason using the provided one.
269      *
270      * _Available since v4.3._
271      */
272     function verifyCallResult(
273         bool success,
274         bytes memory returndata,
275         string memory errorMessage
276     ) internal pure returns (bytes memory) {
277         if (success) {
278             return returndata;
279         } else {
280             // Look for revert reason and bubble it up if present
281             if (returndata.length > 0) {
282                 // The easiest way to bubble the revert reason is using memory via assembly
283 
284                 assembly {
285                     let returndata_size := mload(returndata)
286                     revert(add(32, returndata), returndata_size)
287                 }
288             } else {
289                 revert(errorMessage);
290             }
291         }
292     }
293 }
294 
295 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @title ERC721 token receiver interface
304  * @dev Interface for any contract that wants to support safeTransfers
305  * from ERC721 asset contracts.
306  */
307 interface IERC721Receiver {
308     /**
309      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
310      * by `operator` from `from`, this function is called.
311      *
312      * It must return its Solidity selector to confirm the token transfer.
313      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
314      *
315      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
316      */
317     function onERC721Received(
318         address operator,
319         address from,
320         uint256 tokenId,
321         bytes calldata data
322     ) external returns (bytes4);
323 }
324 
325 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC165 standard, as defined in the
334  * https://eips.ethereum.org/EIPS/eip-165[EIP].
335  *
336  * Implementers can declare support of contract interfaces, which can then be
337  * queried by others ({ERC165Checker}).
338  *
339  * For an implementation, see {ERC165}.
340  */
341 interface IERC165 {
342     /**
343      * @dev Returns true if this contract implements the interface defined by
344      * `interfaceId`. See the corresponding
345      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
346      * to learn more about how these ids are created.
347      *
348      * This function call must use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 }
352 
353 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 
361 /**
362  * @dev Implementation of the {IERC165} interface.
363  *
364  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
365  * for the additional interface id that will be supported. For example:
366  *
367  * ```solidity
368  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
369  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
370  * }
371  * ```
372  *
373  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
374  */
375 abstract contract ERC165 is IERC165 {
376     /**
377      * @dev See {IERC165-supportsInterface}.
378      */
379     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
380         return interfaceId == type(IERC165).interfaceId;
381     }
382 }
383 
384 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 
392 /**
393  * @dev Required interface of an ERC721 compliant contract.
394  */
395 interface IERC721 is IERC165 {
396     /**
397      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
398      */
399     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
400 
401     /**
402      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
403      */
404     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
408      */
409     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
410 
411     /**
412      * @dev Returns the number of tokens in ``owner``'s account.
413      */
414     function balanceOf(address owner) external view returns (uint256 balance);
415 
416     /**
417      * @dev Returns the owner of the `tokenId` token.
418      *
419      * Requirements:
420      *
421      * - `tokenId` must exist.
422      */
423     function ownerOf(uint256 tokenId) external view returns (address owner);
424 
425     /**
426      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
427      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Transfers `tokenId` token from `from` to `to`.
447      *
448      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must be owned by `from`.
455      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
456      *
457      * Emits a {Transfer} event.
458      */
459     function transferFrom(
460         address from,
461         address to,
462         uint256 tokenId
463     ) external;
464 
465     /**
466      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
467      * The approval is cleared when the token is transferred.
468      *
469      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
470      *
471      * Requirements:
472      *
473      * - The caller must own the token or be an approved operator.
474      * - `tokenId` must exist.
475      *
476      * Emits an {Approval} event.
477      */
478     function approve(address to, uint256 tokenId) external;
479 
480     /**
481      * @dev Returns the account approved for `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function getApproved(uint256 tokenId) external view returns (address operator);
488 
489     /**
490      * @dev Approve or remove `operator` as an operator for the caller.
491      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
492      *
493      * Requirements:
494      *
495      * - The `operator` cannot be the caller.
496      *
497      * Emits an {ApprovalForAll} event.
498      */
499     function setApprovalForAll(address operator, bool _approved) external;
500 
501     /**
502      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
503      *
504      * See {setApprovalForAll}
505      */
506     function isApprovedForAll(address owner, address operator) external view returns (bool);
507 
508     /**
509      * @dev Safely transfers `tokenId` token from `from` to `to`.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must exist and be owned by `from`.
516      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
518      *
519      * Emits a {Transfer} event.
520      */
521     function safeTransferFrom(
522         address from,
523         address to,
524         uint256 tokenId,
525         bytes calldata data
526     ) external;
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
530 
531 
532 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
539  * @dev See https://eips.ethereum.org/EIPS/eip-721
540  */
541 interface IERC721Enumerable is IERC721 {
542     /**
543      * @dev Returns the total amount of tokens stored by the contract.
544      */
545     function totalSupply() external view returns (uint256);
546 
547     /**
548      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
549      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
550      */
551     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
552 
553     /**
554      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
555      * Use along with {totalSupply} to enumerate all tokens.
556      */
557     function tokenByIndex(uint256 index) external view returns (uint256);
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
570  * @dev See https://eips.ethereum.org/EIPS/eip-721
571  */
572 interface IERC721Metadata is IERC721 {
573     /**
574      * @dev Returns the token collection name.
575      */
576     function name() external view returns (string memory);
577 
578     /**
579      * @dev Returns the token collection symbol.
580      */
581     function symbol() external view returns (string memory);
582 
583     /**
584      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
585      */
586     function tokenURI(uint256 tokenId) external view returns (string memory);
587 }
588 
589 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 // CAUTION
597 // This version of SafeMath should only be used with Solidity 0.8 or later,
598 // because it relies on the compiler's built in overflow checks.
599 
600 /**
601  * @dev Wrappers over Solidity's arithmetic operations.
602  *
603  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
604  * now has built in overflow checking.
605  */
606 library SafeMath {
607     /**
608      * @dev Returns the addition of two unsigned integers, with an overflow flag.
609      *
610      * _Available since v3.4._
611      */
612     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
613         unchecked {
614             uint256 c = a + b;
615             if (c < a) return (false, 0);
616             return (true, c);
617         }
618     }
619 
620     /**
621      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
622      *
623      * _Available since v3.4._
624      */
625     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
626         unchecked {
627             if (b > a) return (false, 0);
628             return (true, a - b);
629         }
630     }
631 
632     /**
633      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
634      *
635      * _Available since v3.4._
636      */
637     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
638         unchecked {
639             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
640             // benefit is lost if 'b' is also tested.
641             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
642             if (a == 0) return (true, 0);
643             uint256 c = a * b;
644             if (c / a != b) return (false, 0);
645             return (true, c);
646         }
647     }
648 
649     /**
650      * @dev Returns the division of two unsigned integers, with a division by zero flag.
651      *
652      * _Available since v3.4._
653      */
654     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
655         unchecked {
656             if (b == 0) return (false, 0);
657             return (true, a / b);
658         }
659     }
660 
661     /**
662      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
663      *
664      * _Available since v3.4._
665      */
666     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
667         unchecked {
668             if (b == 0) return (false, 0);
669             return (true, a % b);
670         }
671     }
672 
673     /**
674      * @dev Returns the addition of two unsigned integers, reverting on
675      * overflow.
676      *
677      * Counterpart to Solidity's `+` operator.
678      *
679      * Requirements:
680      *
681      * - Addition cannot overflow.
682      */
683     function add(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a + b;
685     }
686 
687     /**
688      * @dev Returns the subtraction of two unsigned integers, reverting on
689      * overflow (when the result is negative).
690      *
691      * Counterpart to Solidity's `-` operator.
692      *
693      * Requirements:
694      *
695      * - Subtraction cannot overflow.
696      */
697     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
698         return a - b;
699     }
700 
701     /**
702      * @dev Returns the multiplication of two unsigned integers, reverting on
703      * overflow.
704      *
705      * Counterpart to Solidity's `*` operator.
706      *
707      * Requirements:
708      *
709      * - Multiplication cannot overflow.
710      */
711     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
712         return a * b;
713     }
714 
715     /**
716      * @dev Returns the integer division of two unsigned integers, reverting on
717      * division by zero. The result is rounded towards zero.
718      *
719      * Counterpart to Solidity's `/` operator.
720      *
721      * Requirements:
722      *
723      * - The divisor cannot be zero.
724      */
725     function div(uint256 a, uint256 b) internal pure returns (uint256) {
726         return a / b;
727     }
728 
729     /**
730      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
731      * reverting when dividing by zero.
732      *
733      * Counterpart to Solidity's `%` operator. This function uses a `revert`
734      * opcode (which leaves remaining gas untouched) while Solidity uses an
735      * invalid opcode to revert (consuming all remaining gas).
736      *
737      * Requirements:
738      *
739      * - The divisor cannot be zero.
740      */
741     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
742         return a % b;
743     }
744 
745     /**
746      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
747      * overflow (when the result is negative).
748      *
749      * CAUTION: This function is deprecated because it requires allocating memory for the error
750      * message unnecessarily. For custom revert reasons use {trySub}.
751      *
752      * Counterpart to Solidity's `-` operator.
753      *
754      * Requirements:
755      *
756      * - Subtraction cannot overflow.
757      */
758     function sub(
759         uint256 a,
760         uint256 b,
761         string memory errorMessage
762     ) internal pure returns (uint256) {
763         unchecked {
764             require(b <= a, errorMessage);
765             return a - b;
766         }
767     }
768 
769     /**
770      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
771      * division by zero. The result is rounded towards zero.
772      *
773      * Counterpart to Solidity's `/` operator. Note: this function uses a
774      * `revert` opcode (which leaves remaining gas untouched) while Solidity
775      * uses an invalid opcode to revert (consuming all remaining gas).
776      *
777      * Requirements:
778      *
779      * - The divisor cannot be zero.
780      */
781     function div(
782         uint256 a,
783         uint256 b,
784         string memory errorMessage
785     ) internal pure returns (uint256) {
786         unchecked {
787             require(b > 0, errorMessage);
788             return a / b;
789         }
790     }
791 
792     /**
793      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
794      * reverting with custom message when dividing by zero.
795      *
796      * CAUTION: This function is deprecated because it requires allocating memory for the error
797      * message unnecessarily. For custom revert reasons use {tryMod}.
798      *
799      * Counterpart to Solidity's `%` operator. This function uses a `revert`
800      * opcode (which leaves remaining gas untouched) while Solidity uses an
801      * invalid opcode to revert (consuming all remaining gas).
802      *
803      * Requirements:
804      *
805      * - The divisor cannot be zero.
806      */
807     function mod(
808         uint256 a,
809         uint256 b,
810         string memory errorMessage
811     ) internal pure returns (uint256) {
812         unchecked {
813             require(b > 0, errorMessage);
814             return a % b;
815         }
816     }
817 }
818 
819 // File: @openzeppelin/contracts/utils/Context.sol
820 
821 
822 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
823 
824 pragma solidity ^0.8.0;
825 
826 /**
827  * @dev Provides information about the current execution context, including the
828  * sender of the transaction and its data. While these are generally available
829  * via msg.sender and msg.data, they should not be accessed in such a direct
830  * manner, since when dealing with meta-transactions the account sending and
831  * paying for execution may not be the actual sender (as far as an application
832  * is concerned).
833  *
834  * This contract is only required for intermediate, library-like contracts.
835  */
836 abstract contract Context {
837     function _msgSender() internal view virtual returns (address) {
838         return msg.sender;
839     }
840 
841     function _msgData() internal view virtual returns (bytes calldata) {
842         return msg.data;
843     }
844 }
845 
846 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
847 
848 
849 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
850 
851 pragma solidity ^0.8.0;
852 
853 
854 
855 
856 
857 
858 
859 
860 /**
861  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
862  * the Metadata extension, but not including the Enumerable extension, which is available separately as
863  * {ERC721Enumerable}.
864  */
865 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
866     using Address for address;
867     using Strings for uint256;
868 
869     // Token name
870     string private _name;
871 
872     // Token symbol
873     string private _symbol;
874 
875     // Mapping from token ID to owner address
876     mapping(uint256 => address) private _owners;
877 
878     // Mapping owner address to token count
879     mapping(address => uint256) private _balances;
880 
881     // Mapping from token ID to approved address
882     mapping(uint256 => address) private _tokenApprovals;
883 
884     // Mapping from owner to operator approvals
885     mapping(address => mapping(address => bool)) private _operatorApprovals;
886 
887     /**
888      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
889      */
890     constructor(string memory name_, string memory symbol_) {
891         _name = name_;
892         _symbol = symbol_;
893     }
894 
895     /**
896      * @dev See {IERC165-supportsInterface}.
897      */
898     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
899         return
900             interfaceId == type(IERC721).interfaceId ||
901             interfaceId == type(IERC721Metadata).interfaceId ||
902             super.supportsInterface(interfaceId);
903     }
904 
905     /**
906      * @dev See {IERC721-balanceOf}.
907      */
908     function balanceOf(address owner) public view virtual override returns (uint256) {
909         require(owner != address(0), "ERC721: balance query for the zero address");
910         return _balances[owner];
911     }
912 
913     /**
914      * @dev See {IERC721-ownerOf}.
915      */
916     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
917         address owner = _owners[tokenId];
918         require(owner != address(0), "ERC721: owner query for nonexistent token");
919         return owner;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-name}.
924      */
925     function name() public view virtual override returns (string memory) {
926         return _name;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-symbol}.
931      */
932     function symbol() public view virtual override returns (string memory) {
933         return _symbol;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-tokenURI}.
938      */
939     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
940         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
941 
942         string memory baseURI = _baseURI();
943         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
944     }
945 
946     /**
947      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
948      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
949      * by default, can be overriden in child contracts.
950      */
951     function _baseURI() internal view virtual returns (string memory) {
952         return "";
953     }
954 
955     /**
956      * @dev See {IERC721-approve}.
957      */
958     function approve(address to, uint256 tokenId) public virtual override {
959         address owner = ERC721.ownerOf(tokenId);
960         require(to != owner, "ERC721: approval to current owner");
961 
962         require(
963             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
964             "ERC721: approve caller is not owner nor approved for all"
965         );
966 
967         _approve(to, tokenId);
968     }
969 
970     /**
971      * @dev See {IERC721-getApproved}.
972      */
973     function getApproved(uint256 tokenId) public view virtual override returns (address) {
974         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
975 
976         return _tokenApprovals[tokenId];
977     }
978 
979     /**
980      * @dev See {IERC721-setApprovalForAll}.
981      */
982     function setApprovalForAll(address operator, bool approved) public virtual override {
983         _setApprovalForAll(_msgSender(), operator, approved);
984     }
985 
986     /**
987      * @dev See {IERC721-isApprovedForAll}.
988      */
989     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
990         return _operatorApprovals[owner][operator];
991     }
992 
993     /**
994      * @dev See {IERC721-transferFrom}.
995      */
996     function transferFrom(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) public virtual override {
1001         //solhint-disable-next-line max-line-length
1002         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1003 
1004         _transfer(from, to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-safeTransferFrom}.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         safeTransferFrom(from, to, tokenId, "");
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId,
1025         bytes memory _data
1026     ) public virtual override {
1027         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1028         _safeTransfer(from, to, tokenId, _data);
1029     }
1030 
1031     /**
1032      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1033      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1034      *
1035      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1036      *
1037      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1038      * implement alternative mechanisms to perform token transfer, such as signature-based.
1039      *
1040      * Requirements:
1041      *
1042      * - `from` cannot be the zero address.
1043      * - `to` cannot be the zero address.
1044      * - `tokenId` token must exist and be owned by `from`.
1045      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _safeTransfer(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) internal virtual {
1055         _transfer(from, to, tokenId);
1056         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1057     }
1058 
1059     /**
1060      * @dev Returns whether `tokenId` exists.
1061      *
1062      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1063      *
1064      * Tokens start existing when they are minted (`_mint`),
1065      * and stop existing when they are burned (`_burn`).
1066      */
1067     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1068         return _owners[tokenId] != address(0);
1069     }
1070 
1071     /**
1072      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      */
1078     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1079         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1080         address owner = ERC721.ownerOf(tokenId);
1081         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1082     }
1083 
1084     /**
1085      * @dev Safely mints `tokenId` and transfers it to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must not exist.
1090      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _safeMint(address to, uint256 tokenId) internal virtual {
1095         _safeMint(to, tokenId, "");
1096     }
1097 
1098     /**
1099      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1100      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1101      */
1102     function _safeMint(
1103         address to,
1104         uint256 tokenId,
1105         bytes memory _data
1106     ) internal virtual {
1107         _mint(to, tokenId);
1108         require(
1109             _checkOnERC721Received(address(0), to, tokenId, _data),
1110             "ERC721: transfer to non ERC721Receiver implementer"
1111         );
1112     }
1113 
1114     /**
1115      * @dev Mints `tokenId` and transfers it to `to`.
1116      *
1117      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1118      *
1119      * Requirements:
1120      *
1121      * - `tokenId` must not exist.
1122      * - `to` cannot be the zero address.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _mint(address to, uint256 tokenId) internal virtual {
1127         require(to != address(0), "ERC721: mint to the zero address");
1128         require(!_exists(tokenId), "ERC721: token already minted");
1129 
1130         _beforeTokenTransfer(address(0), to, tokenId);
1131 
1132         _balances[to] += 1;
1133         _owners[tokenId] = to;
1134 
1135         emit Transfer(address(0), to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Destroys `tokenId`.
1140      * The approval is cleared when the token is burned.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must exist.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _burn(uint256 tokenId) internal virtual {
1149         address owner = ERC721.ownerOf(tokenId);
1150 
1151         _beforeTokenTransfer(owner, address(0), tokenId);
1152 
1153         // Clear approvals
1154         _approve(address(0), tokenId);
1155 
1156         _balances[owner] -= 1;
1157         delete _owners[tokenId];
1158 
1159         emit Transfer(owner, address(0), tokenId);
1160     }
1161 
1162     /**
1163      * @dev Transfers `tokenId` from `from` to `to`.
1164      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must be owned by `from`.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _transfer(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) internal virtual {
1178         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1179         require(to != address(0), "ERC721: transfer to the zero address");
1180 
1181         _beforeTokenTransfer(from, to, tokenId);
1182 
1183         // Clear approvals from the previous owner
1184         _approve(address(0), tokenId);
1185 
1186         _balances[from] -= 1;
1187         _balances[to] += 1;
1188         _owners[tokenId] = to;
1189 
1190         emit Transfer(from, to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev Approve `to` to operate on `tokenId`
1195      *
1196      * Emits a {Approval} event.
1197      */
1198     function _approve(address to, uint256 tokenId) internal virtual {
1199         _tokenApprovals[tokenId] = to;
1200         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1201     }
1202 
1203     /**
1204      * @dev Approve `operator` to operate on all of `owner` tokens
1205      *
1206      * Emits a {ApprovalForAll} event.
1207      */
1208     function _setApprovalForAll(
1209         address owner,
1210         address operator,
1211         bool approved
1212     ) internal virtual {
1213         require(owner != operator, "ERC721: approve to caller");
1214         _operatorApprovals[owner][operator] = approved;
1215         emit ApprovalForAll(owner, operator, approved);
1216     }
1217 
1218     /**
1219      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1220      * The call is not executed if the target address is not a contract.
1221      *
1222      * @param from address representing the previous owner of the given token ID
1223      * @param to target address that will receive the tokens
1224      * @param tokenId uint256 ID of the token to be transferred
1225      * @param _data bytes optional data to send along with the call
1226      * @return bool whether the call correctly returned the expected magic value
1227      */
1228     function _checkOnERC721Received(
1229         address from,
1230         address to,
1231         uint256 tokenId,
1232         bytes memory _data
1233     ) private returns (bool) {
1234         if (to.isContract()) {
1235             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1236                 return retval == IERC721Receiver.onERC721Received.selector;
1237             } catch (bytes memory reason) {
1238                 if (reason.length == 0) {
1239                     revert("ERC721: transfer to non ERC721Receiver implementer");
1240                 } else {
1241                     assembly {
1242                         revert(add(32, reason), mload(reason))
1243                     }
1244                 }
1245             }
1246         } else {
1247             return true;
1248         }
1249     }
1250 
1251     /**
1252      * @dev Hook that is called before any token transfer. This includes minting
1253      * and burning.
1254      *
1255      * Calling conditions:
1256      *
1257      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1258      * transferred to `to`.
1259      * - When `from` is zero, `tokenId` will be minted for `to`.
1260      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1261      * - `from` and `to` are never both zero.
1262      *
1263      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1264      */
1265     function _beforeTokenTransfer(
1266         address from,
1267         address to,
1268         uint256 tokenId
1269     ) internal virtual {}
1270 }
1271 
1272 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1273 
1274 
1275 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1276 
1277 pragma solidity ^0.8.0;
1278 
1279 
1280 
1281 /**
1282  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1283  * enumerability of all the token ids in the contract as well as all token ids owned by each
1284  * account.
1285  */
1286 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1287     // Mapping from owner to list of owned token IDs
1288     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1289 
1290     // Mapping from token ID to index of the owner tokens list
1291     mapping(uint256 => uint256) private _ownedTokensIndex;
1292 
1293     // Array with all token ids, used for enumeration
1294     uint256[] private _allTokens;
1295 
1296     // Mapping from token id to position in the allTokens array
1297     mapping(uint256 => uint256) private _allTokensIndex;
1298 
1299     /**
1300      * @dev See {IERC165-supportsInterface}.
1301      */
1302     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1303         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1304     }
1305 
1306     /**
1307      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1308      */
1309     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1310         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1311         return _ownedTokens[owner][index];
1312     }
1313 
1314     /**
1315      * @dev See {IERC721Enumerable-totalSupply}.
1316      */
1317     function totalSupply() public view virtual override returns (uint256) {
1318         return _allTokens.length;
1319     }
1320 
1321     /**
1322      * @dev See {IERC721Enumerable-tokenByIndex}.
1323      */
1324     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1325         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1326         return _allTokens[index];
1327     }
1328 
1329     /**
1330      * @dev Hook that is called before any token transfer. This includes minting
1331      * and burning.
1332      *
1333      * Calling conditions:
1334      *
1335      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1336      * transferred to `to`.
1337      * - When `from` is zero, `tokenId` will be minted for `to`.
1338      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1339      * - `from` cannot be the zero address.
1340      * - `to` cannot be the zero address.
1341      *
1342      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1343      */
1344     function _beforeTokenTransfer(
1345         address from,
1346         address to,
1347         uint256 tokenId
1348     ) internal virtual override {
1349         super._beforeTokenTransfer(from, to, tokenId);
1350 
1351         if (from == address(0)) {
1352             _addTokenToAllTokensEnumeration(tokenId);
1353         } else if (from != to) {
1354             _removeTokenFromOwnerEnumeration(from, tokenId);
1355         }
1356         if (to == address(0)) {
1357             _removeTokenFromAllTokensEnumeration(tokenId);
1358         } else if (to != from) {
1359             _addTokenToOwnerEnumeration(to, tokenId);
1360         }
1361     }
1362 
1363     /**
1364      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1365      * @param to address representing the new owner of the given token ID
1366      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1367      */
1368     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1369         uint256 length = ERC721.balanceOf(to);
1370         _ownedTokens[to][length] = tokenId;
1371         _ownedTokensIndex[tokenId] = length;
1372     }
1373 
1374     /**
1375      * @dev Private function to add a token to this extension's token tracking data structures.
1376      * @param tokenId uint256 ID of the token to be added to the tokens list
1377      */
1378     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1379         _allTokensIndex[tokenId] = _allTokens.length;
1380         _allTokens.push(tokenId);
1381     }
1382 
1383     /**
1384      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1385      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1386      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1387      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1388      * @param from address representing the previous owner of the given token ID
1389      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1390      */
1391     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1392         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1393         // then delete the last slot (swap and pop).
1394 
1395         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1396         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1397 
1398         // When the token to delete is the last token, the swap operation is unnecessary
1399         if (tokenIndex != lastTokenIndex) {
1400             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1401 
1402             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1403             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1404         }
1405 
1406         // This also deletes the contents at the last position of the array
1407         delete _ownedTokensIndex[tokenId];
1408         delete _ownedTokens[from][lastTokenIndex];
1409     }
1410 
1411     /**
1412      * @dev Private function to remove a token from this extension's token tracking data structures.
1413      * This has O(1) time complexity, but alters the order of the _allTokens array.
1414      * @param tokenId uint256 ID of the token to be removed from the tokens list
1415      */
1416     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1417         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1418         // then delete the last slot (swap and pop).
1419 
1420         uint256 lastTokenIndex = _allTokens.length - 1;
1421         uint256 tokenIndex = _allTokensIndex[tokenId];
1422 
1423         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1424         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1425         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1426         uint256 lastTokenId = _allTokens[lastTokenIndex];
1427 
1428         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1429         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1430 
1431         // This also deletes the contents at the last position of the array
1432         delete _allTokensIndex[tokenId];
1433         _allTokens.pop();
1434     }
1435 }
1436 
1437 // File: @openzeppelin/contracts/access/Ownable.sol
1438 
1439 
1440 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1441 
1442 pragma solidity ^0.8.0;
1443 
1444 
1445 /**
1446  * @dev Contract module which provides a basic access control mechanism, where
1447  * there is an account (an owner) that can be granted exclusive access to
1448  * specific functions.
1449  *
1450  * By default, the owner account will be the one that deploys the contract. This
1451  * can later be changed with {transferOwnership}.
1452  *
1453  * This module is used through inheritance. It will make available the modifier
1454  * `onlyOwner`, which can be applied to your functions to restrict their use to
1455  * the owner.
1456  */
1457 abstract contract Ownable is Context {
1458     address private _owner;
1459 
1460     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1461 
1462     /**
1463      * @dev Initializes the contract setting the deployer as the initial owner.
1464      */
1465     constructor() {
1466         _transferOwnership(_msgSender());
1467     }
1468 
1469     /**
1470      * @dev Returns the address of the current owner.
1471      */
1472     function owner() public view virtual returns (address) {
1473         return _owner;
1474     }
1475 
1476     /**
1477      * @dev Throws if called by any account other than the owner.
1478      */
1479     modifier onlyOwner() {
1480         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1481         _;
1482     }
1483 
1484     /**
1485      * @dev Leaves the contract without owner. It will not be possible to call
1486      * `onlyOwner` functions anymore. Can only be called by the current owner.
1487      *
1488      * NOTE: Renouncing ownership will leave the contract without an owner,
1489      * thereby removing any functionality that is only available to the owner.
1490      */
1491     function renounceOwnership() public virtual onlyOwner {
1492         _transferOwnership(address(0));
1493     }
1494 
1495     /**
1496      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1497      * Can only be called by the current owner.
1498      */
1499     function transferOwnership(address newOwner) public virtual onlyOwner {
1500         require(newOwner != address(0), "Ownable: new owner is the zero address");
1501         _transferOwnership(newOwner);
1502     }
1503 
1504     /**
1505      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1506      * Internal function without access restriction.
1507      */
1508     function _transferOwnership(address newOwner) internal virtual {
1509         address oldOwner = _owner;
1510         _owner = newOwner;
1511         emit OwnershipTransferred(oldOwner, newOwner);
1512     }
1513 }
1514 
1515 // File: @openzeppelin/contracts/utils/Counters.sol
1516 
1517 
1518 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1519 
1520 pragma solidity ^0.8.0;
1521 
1522 /**
1523  * @title Counters
1524  * @author Matt Condon (@shrugs)
1525  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1526  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1527  *
1528  * Include with `using Counters for Counters.Counter;`
1529  */
1530 library Counters {
1531     struct Counter {
1532         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1533         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1534         // this feature: see https://github.com/ethereum/solidity/issues/4637
1535         uint256 _value; // default: 0
1536     }
1537 
1538     function current(Counter storage counter) internal view returns (uint256) {
1539         return counter._value;
1540     }
1541 
1542     function increment(Counter storage counter) internal {
1543         unchecked {
1544             counter._value += 1;
1545         }
1546     }
1547 
1548     function decrement(Counter storage counter) internal {
1549         uint256 value = counter._value;
1550         require(value > 0, "Counter: decrement overflow");
1551         unchecked {
1552             counter._value = value - 1;
1553         }
1554     }
1555 
1556     function reset(Counter storage counter) internal {
1557         counter._value = 0;
1558     }
1559 }
1560 
1561 // File: contracts/LegendsOnTheBlock.sol
1562 
1563 //SPDX-License-Identifier: MIT
1564 pragma solidity ^0.8.4;
1565 
1566 
1567 
1568 
1569 
1570 contract LegendsOnTheBlock is Ownable, ERC721Enumerable {
1571     using SafeMath for uint256;
1572     using Counters for Counters.Counter;
1573 
1574     Counters.Counter private _tokenIds;
1575 
1576     uint public constant MAX_SUPPLY = 1230;
1577     uint public constant MAX_PER_MINT = 3;
1578 
1579     string public baseTokenURI;
1580 
1581     bool public saleIsActive = false;
1582     uint public price = 0.0442 ether;
1583 
1584     mapping(address => bool) freeMintDone;
1585 
1586     constructor(string memory baseURI) ERC721("Legends On The Block", "LOTB") {
1587         setBaseURI(baseURI);
1588     }
1589 
1590     // Reserve a few NFTs
1591     function reserveNfts(uint _count, address _to) public onlyOwner {
1592         uint totalMinted = _tokenIds.current();
1593 
1594         require(totalMinted.add(_count) < MAX_SUPPLY, "Not enough NFTs left to reserve");
1595 
1596         for (uint i = 0; i < _count; i++) {
1597             _mintSingleNft(_to);
1598         }
1599     }
1600 
1601     // Override empty _baseURI function 
1602     function _baseURI() internal view virtual override returns (string memory) {
1603         return baseTokenURI;
1604     }
1605 
1606     // Allow owner to set baseTokenURI
1607     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1608         baseTokenURI = _baseTokenURI;
1609     }
1610 
1611     // Set Sale state
1612     function setSaleState(bool _activeState) public onlyOwner {
1613         saleIsActive = _activeState;
1614     }
1615 
1616     // Update price
1617     function updatePrice(uint _newPrice) public onlyOwner {
1618         price = _newPrice;
1619     }
1620 
1621     // Check if free mint is done
1622     function isFreeMintDone(address wAddress) public view returns (bool) {
1623         return freeMintDone[wAddress];
1624     }
1625 
1626     // Mint NFTs
1627     function mintNft(uint _count) public payable {
1628         uint totalMinted = _tokenIds.current();
1629         uint cost = 0;
1630 
1631         if (freeMintDone[msg.sender]) {
1632             cost = price.mul(_count);
1633         }
1634         else {
1635             cost = price.mul(_count - 1);
1636             freeMintDone[msg.sender] = true;
1637         }
1638 
1639         require(totalMinted.add(_count) <= MAX_SUPPLY, "Not enough NFTs left!");
1640         require(_count >0 && _count <= MAX_PER_MINT, "Cannot mint specified number of NFTs.");
1641         require(saleIsActive, "Sale is not currently active!");
1642         require(msg.value >= cost, "Not enough ether to purchase NFTs.");
1643 
1644         for (uint i = 0; i < _count; i++) {
1645             _mintSingleNft(msg.sender);
1646         }
1647     }
1648 
1649     // Mint a single NFT
1650     function _mintSingleNft(address _to) private {
1651         _tokenIds.increment();
1652         uint newTokenID = _tokenIds.current();
1653         _safeMint(_to, newTokenID);
1654     }
1655 
1656     // Withdraw ether
1657     function withdraw() public onlyOwner {
1658         uint balance = address(this).balance;
1659         require(balance > 0, "No ether left to withdraw");
1660 
1661         (bool success, ) = (msg.sender).call{value: balance}("");
1662         require(success, "Transfer failed.");
1663     }
1664 
1665     // Get tokens of an owner
1666     function tokensOfOwner(address _owner) external view returns (uint[] memory) {
1667 
1668         uint tokenCount = balanceOf(_owner);
1669         uint[] memory tokensId = new uint256[](tokenCount);
1670 
1671         for (uint i = 0; i < tokenCount; i++) {
1672             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1673         }
1674         return tokensId;
1675     }
1676 }