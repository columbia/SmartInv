1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
428      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
468      * The approval is cleared when the token is transferred.
469      *
470      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
471      *
472      * Requirements:
473      *
474      * - The caller must own the token or be an approved operator.
475      * - `tokenId` must exist.
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address to, uint256 tokenId) external;
480 
481     /**
482      * @dev Returns the account approved for `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function getApproved(uint256 tokenId) external view returns (address operator);
489 
490     /**
491      * @dev Approve or remove `operator` as an operator for the caller.
492      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
493      *
494      * Requirements:
495      *
496      * - The `operator` cannot be the caller.
497      *
498      * Emits an {ApprovalForAll} event.
499      */
500     function setApprovalForAll(address operator, bool _approved) external;
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes calldata data
527     ) external;
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Metadata is IERC721 {
543     /**
544      * @dev Returns the token collection name.
545      */
546     function name() external view returns (string memory);
547 
548     /**
549      * @dev Returns the token collection symbol.
550      */
551     function symbol() external view returns (string memory);
552 
553     /**
554      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
555      */
556     function tokenURI(uint256 tokenId) external view returns (string memory);
557 }
558 
559 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 // CAUTION
567 // This version of SafeMath should only be used with Solidity 0.8 or later,
568 // because it relies on the compiler's built in overflow checks.
569 
570 /**
571  * @dev Wrappers over Solidity's arithmetic operations.
572  *
573  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
574  * now has built in overflow checking.
575  */
576 library SafeMath {
577     /**
578      * @dev Returns the addition of two unsigned integers, with an overflow flag.
579      *
580      * _Available since v3.4._
581      */
582     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
583         unchecked {
584             uint256 c = a + b;
585             if (c < a) return (false, 0);
586             return (true, c);
587         }
588     }
589 
590     /**
591      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
592      *
593      * _Available since v3.4._
594      */
595     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
596         unchecked {
597             if (b > a) return (false, 0);
598             return (true, a - b);
599         }
600     }
601 
602     /**
603      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
604      *
605      * _Available since v3.4._
606      */
607     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
610             // benefit is lost if 'b' is also tested.
611             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
612             if (a == 0) return (true, 0);
613             uint256 c = a * b;
614             if (c / a != b) return (false, 0);
615             return (true, c);
616         }
617     }
618 
619     /**
620      * @dev Returns the division of two unsigned integers, with a division by zero flag.
621      *
622      * _Available since v3.4._
623      */
624     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
625         unchecked {
626             if (b == 0) return (false, 0);
627             return (true, a / b);
628         }
629     }
630 
631     /**
632      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
633      *
634      * _Available since v3.4._
635      */
636     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
637         unchecked {
638             if (b == 0) return (false, 0);
639             return (true, a % b);
640         }
641     }
642 
643     /**
644      * @dev Returns the addition of two unsigned integers, reverting on
645      * overflow.
646      *
647      * Counterpart to Solidity's `+` operator.
648      *
649      * Requirements:
650      *
651      * - Addition cannot overflow.
652      */
653     function add(uint256 a, uint256 b) internal pure returns (uint256) {
654         return a + b;
655     }
656 
657     /**
658      * @dev Returns the subtraction of two unsigned integers, reverting on
659      * overflow (when the result is negative).
660      *
661      * Counterpart to Solidity's `-` operator.
662      *
663      * Requirements:
664      *
665      * - Subtraction cannot overflow.
666      */
667     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
668         return a - b;
669     }
670 
671     /**
672      * @dev Returns the multiplication of two unsigned integers, reverting on
673      * overflow.
674      *
675      * Counterpart to Solidity's `*` operator.
676      *
677      * Requirements:
678      *
679      * - Multiplication cannot overflow.
680      */
681     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
682         return a * b;
683     }
684 
685     /**
686      * @dev Returns the integer division of two unsigned integers, reverting on
687      * division by zero. The result is rounded towards zero.
688      *
689      * Counterpart to Solidity's `/` operator.
690      *
691      * Requirements:
692      *
693      * - The divisor cannot be zero.
694      */
695     function div(uint256 a, uint256 b) internal pure returns (uint256) {
696         return a / b;
697     }
698 
699     /**
700      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
701      * reverting when dividing by zero.
702      *
703      * Counterpart to Solidity's `%` operator. This function uses a `revert`
704      * opcode (which leaves remaining gas untouched) while Solidity uses an
705      * invalid opcode to revert (consuming all remaining gas).
706      *
707      * Requirements:
708      *
709      * - The divisor cannot be zero.
710      */
711     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
712         return a % b;
713     }
714 
715     /**
716      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
717      * overflow (when the result is negative).
718      *
719      * CAUTION: This function is deprecated because it requires allocating memory for the error
720      * message unnecessarily. For custom revert reasons use {trySub}.
721      *
722      * Counterpart to Solidity's `-` operator.
723      *
724      * Requirements:
725      *
726      * - Subtraction cannot overflow.
727      */
728     function sub(
729         uint256 a,
730         uint256 b,
731         string memory errorMessage
732     ) internal pure returns (uint256) {
733         unchecked {
734             require(b <= a, errorMessage);
735             return a - b;
736         }
737     }
738 
739     /**
740      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
741      * division by zero. The result is rounded towards zero.
742      *
743      * Counterpart to Solidity's `/` operator. Note: this function uses a
744      * `revert` opcode (which leaves remaining gas untouched) while Solidity
745      * uses an invalid opcode to revert (consuming all remaining gas).
746      *
747      * Requirements:
748      *
749      * - The divisor cannot be zero.
750      */
751     function div(
752         uint256 a,
753         uint256 b,
754         string memory errorMessage
755     ) internal pure returns (uint256) {
756         unchecked {
757             require(b > 0, errorMessage);
758             return a / b;
759         }
760     }
761 
762     /**
763      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
764      * reverting with custom message when dividing by zero.
765      *
766      * CAUTION: This function is deprecated because it requires allocating memory for the error
767      * message unnecessarily. For custom revert reasons use {tryMod}.
768      *
769      * Counterpart to Solidity's `%` operator. This function uses a `revert`
770      * opcode (which leaves remaining gas untouched) while Solidity uses an
771      * invalid opcode to revert (consuming all remaining gas).
772      *
773      * Requirements:
774      *
775      * - The divisor cannot be zero.
776      */
777     function mod(
778         uint256 a,
779         uint256 b,
780         string memory errorMessage
781     ) internal pure returns (uint256) {
782         unchecked {
783             require(b > 0, errorMessage);
784             return a % b;
785         }
786     }
787 }
788 
789 // File: @openzeppelin/contracts/utils/Context.sol
790 
791 
792 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
793 
794 pragma solidity ^0.8.0;
795 
796 /**
797  * @dev Provides information about the current execution context, including the
798  * sender of the transaction and its data. While these are generally available
799  * via msg.sender and msg.data, they should not be accessed in such a direct
800  * manner, since when dealing with meta-transactions the account sending and
801  * paying for execution may not be the actual sender (as far as an application
802  * is concerned).
803  *
804  * This contract is only required for intermediate, library-like contracts.
805  */
806 abstract contract Context {
807     function _msgSender() internal view virtual returns (address) {
808         return msg.sender;
809     }
810 
811     function _msgData() internal view virtual returns (bytes calldata) {
812         return msg.data;
813     }
814 }
815 
816 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
817 
818 
819 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
820 
821 pragma solidity ^0.8.0;
822 
823 
824 
825 
826 
827 
828 
829 
830 /**
831  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
832  * the Metadata extension, but not including the Enumerable extension, which is available separately as
833  * {ERC721Enumerable}.
834  */
835 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
836     using Address for address;
837     using Strings for uint256;
838 
839     // Token name
840     string private _name;
841 
842     // Token symbol
843     string private _symbol;
844 
845     // Mapping from token ID to owner address
846     mapping(uint256 => address) private _owners;
847 
848     // Mapping owner address to token count
849     mapping(address => uint256) private _balances;
850 
851     // Mapping from token ID to approved address
852     mapping(uint256 => address) private _tokenApprovals;
853 
854     // Mapping from owner to operator approvals
855     mapping(address => mapping(address => bool)) private _operatorApprovals;
856 
857     /**
858      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
859      */
860     constructor(string memory name_, string memory symbol_) {
861         _name = name_;
862         _symbol = symbol_;
863     }
864 
865     /**
866      * @dev See {IERC165-supportsInterface}.
867      */
868     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
869         return
870             interfaceId == type(IERC721).interfaceId ||
871             interfaceId == type(IERC721Metadata).interfaceId ||
872             super.supportsInterface(interfaceId);
873     }
874 
875     /**
876      * @dev See {IERC721-balanceOf}.
877      */
878     function balanceOf(address owner) public view virtual override returns (uint256) {
879         require(owner != address(0), "ERC721: balance query for the zero address");
880         return _balances[owner];
881     }
882 
883     /**
884      * @dev See {IERC721-ownerOf}.
885      */
886     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
887         address owner = _owners[tokenId];
888         require(owner != address(0), "ERC721: owner query for nonexistent token");
889         return owner;
890     }
891 
892     /**
893      * @dev See {IERC721Metadata-name}.
894      */
895     function name() public view virtual override returns (string memory) {
896         return _name;
897     }
898 
899     /**
900      * @dev See {IERC721Metadata-symbol}.
901      */
902     function symbol() public view virtual override returns (string memory) {
903         return _symbol;
904     }
905 
906     /**
907      * @dev See {IERC721Metadata-tokenURI}.
908      */
909     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
910         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
911 
912         string memory baseURI = _baseURI();
913         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
914     }
915 
916     /**
917      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
918      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
919      * by default, can be overriden in child contracts.
920      */
921     function _baseURI() internal view virtual returns (string memory) {
922         return "";
923     }
924 
925     /**
926      * @dev See {IERC721-approve}.
927      */
928     function approve(address to, uint256 tokenId) public virtual override {
929         address owner = ERC721.ownerOf(tokenId);
930         require(to != owner, "ERC721: approval to current owner");
931 
932         require(
933             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
934             "ERC721: approve caller is not owner nor approved for all"
935         );
936 
937         _approve(to, tokenId);
938     }
939 
940     /**
941      * @dev See {IERC721-getApproved}.
942      */
943     function getApproved(uint256 tokenId) public view virtual override returns (address) {
944         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
945 
946         return _tokenApprovals[tokenId];
947     }
948 
949     /**
950      * @dev See {IERC721-setApprovalForAll}.
951      */
952     function setApprovalForAll(address operator, bool approved) public virtual override {
953         _setApprovalForAll(_msgSender(), operator, approved);
954     }
955 
956     /**
957      * @dev See {IERC721-isApprovedForAll}.
958      */
959     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
960         return _operatorApprovals[owner][operator];
961     }
962 
963     /**
964      * @dev See {IERC721-transferFrom}.
965      */
966     function transferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         //solhint-disable-next-line max-line-length
972         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
973 
974         _transfer(from, to, tokenId);
975     }
976 
977     /**
978      * @dev See {IERC721-safeTransferFrom}.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId
984     ) public virtual override {
985         safeTransferFrom(from, to, tokenId, "");
986     }
987 
988     /**
989      * @dev See {IERC721-safeTransferFrom}.
990      */
991     function safeTransferFrom(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) public virtual override {
997         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
998         _safeTransfer(from, to, tokenId, _data);
999     }
1000 
1001     /**
1002      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1003      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1004      *
1005      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1006      *
1007      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1008      * implement alternative mechanisms to perform token transfer, such as signature-based.
1009      *
1010      * Requirements:
1011      *
1012      * - `from` cannot be the zero address.
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must exist and be owned by `from`.
1015      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _safeTransfer(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) internal virtual {
1025         _transfer(from, to, tokenId);
1026         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1027     }
1028 
1029     /**
1030      * @dev Returns whether `tokenId` exists.
1031      *
1032      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1033      *
1034      * Tokens start existing when they are minted (`_mint`),
1035      * and stop existing when they are burned (`_burn`).
1036      */
1037     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1038         return _owners[tokenId] != address(0);
1039     }
1040 
1041     /**
1042      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1043      *
1044      * Requirements:
1045      *
1046      * - `tokenId` must exist.
1047      */
1048     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1049         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1050         address owner = ERC721.ownerOf(tokenId);
1051         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1052     }
1053 
1054     /**
1055      * @dev Safely mints `tokenId` and transfers it to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must not exist.
1060      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _safeMint(address to, uint256 tokenId) internal virtual {
1065         _safeMint(to, tokenId, "");
1066     }
1067 
1068     /**
1069      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1070      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1071      */
1072     function _safeMint(
1073         address to,
1074         uint256 tokenId,
1075         bytes memory _data
1076     ) internal virtual {
1077         _mint(to, tokenId);
1078         require(
1079             _checkOnERC721Received(address(0), to, tokenId, _data),
1080             "ERC721: transfer to non ERC721Receiver implementer"
1081         );
1082     }
1083 
1084     /**
1085      * @dev Mints `tokenId` and transfers it to `to`.
1086      *
1087      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must not exist.
1092      * - `to` cannot be the zero address.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _mint(address to, uint256 tokenId) internal virtual {
1097         require(to != address(0), "ERC721: mint to the zero address");
1098         require(!_exists(tokenId), "ERC721: token already minted");
1099 
1100         _beforeTokenTransfer(address(0), to, tokenId);
1101 
1102         _balances[to] += 1;
1103         _owners[tokenId] = to;
1104 
1105         emit Transfer(address(0), to, tokenId);
1106 
1107         _afterTokenTransfer(address(0), to, tokenId);
1108     }
1109 
1110     /**
1111      * @dev Destroys `tokenId`.
1112      * The approval is cleared when the token is burned.
1113      *
1114      * Requirements:
1115      *
1116      * - `tokenId` must exist.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _burn(uint256 tokenId) internal virtual {
1121         address owner = ERC721.ownerOf(tokenId);
1122 
1123         _beforeTokenTransfer(owner, address(0), tokenId);
1124 
1125         // Clear approvals
1126         _approve(address(0), tokenId);
1127 
1128         _balances[owner] -= 1;
1129         delete _owners[tokenId];
1130 
1131         emit Transfer(owner, address(0), tokenId);
1132 
1133         _afterTokenTransfer(owner, address(0), tokenId);
1134     }
1135 
1136     /**
1137      * @dev Transfers `tokenId` from `from` to `to`.
1138      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `tokenId` token must be owned by `from`.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _transfer(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) internal virtual {
1152         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1153         require(to != address(0), "ERC721: transfer to the zero address");
1154 
1155         _beforeTokenTransfer(from, to, tokenId);
1156 
1157         // Clear approvals from the previous owner
1158         _approve(address(0), tokenId);
1159 
1160         _balances[from] -= 1;
1161         _balances[to] += 1;
1162         _owners[tokenId] = to;
1163 
1164         emit Transfer(from, to, tokenId);
1165 
1166         _afterTokenTransfer(from, to, tokenId);
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
1180      * @dev Approve `operator` to operate on all of `owner` tokens
1181      *
1182      * Emits a {ApprovalForAll} event.
1183      */
1184     function _setApprovalForAll(
1185         address owner,
1186         address operator,
1187         bool approved
1188     ) internal virtual {
1189         require(owner != operator, "ERC721: approve to caller");
1190         _operatorApprovals[owner][operator] = approved;
1191         emit ApprovalForAll(owner, operator, approved);
1192     }
1193 
1194     /**
1195      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1196      * The call is not executed if the target address is not a contract.
1197      *
1198      * @param from address representing the previous owner of the given token ID
1199      * @param to target address that will receive the tokens
1200      * @param tokenId uint256 ID of the token to be transferred
1201      * @param _data bytes optional data to send along with the call
1202      * @return bool whether the call correctly returned the expected magic value
1203      */
1204     function _checkOnERC721Received(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) private returns (bool) {
1210         if (to.isContract()) {
1211             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1212                 return retval == IERC721Receiver.onERC721Received.selector;
1213             } catch (bytes memory reason) {
1214                 if (reason.length == 0) {
1215                     revert("ERC721: transfer to non ERC721Receiver implementer");
1216                 } else {
1217                     assembly {
1218                         revert(add(32, reason), mload(reason))
1219                     }
1220                 }
1221             }
1222         } else {
1223             return true;
1224         }
1225     }
1226 
1227     /**
1228      * @dev Hook that is called before any token transfer. This includes minting
1229      * and burning.
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1237      * - `from` and `to` are never both zero.
1238      *
1239      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1240      */
1241     function _beforeTokenTransfer(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) internal virtual {}
1246 
1247     /**
1248      * @dev Hook that is called after any transfer of tokens. This includes
1249      * minting and burning.
1250      *
1251      * Calling conditions:
1252      *
1253      * - when `from` and `to` are both non-zero.
1254      * - `from` and `to` are never both zero.
1255      *
1256      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1257      */
1258     function _afterTokenTransfer(
1259         address from,
1260         address to,
1261         uint256 tokenId
1262     ) internal virtual {}
1263 }
1264 
1265 // File: @openzeppelin/contracts/access/Ownable.sol
1266 
1267 
1268 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1269 
1270 pragma solidity ^0.8.0;
1271 
1272 
1273 /**
1274  * @dev Contract module which provides a basic access control mechanism, where
1275  * there is an account (an owner) that can be granted exclusive access to
1276  * specific functions.
1277  *
1278  * By default, the owner account will be the one that deploys the contract. This
1279  * can later be changed with {transferOwnership}.
1280  *
1281  * This module is used through inheritance. It will make available the modifier
1282  * `onlyOwner`, which can be applied to your functions to restrict their use to
1283  * the owner.
1284  */
1285 abstract contract Ownable is Context {
1286     address private _owner;
1287 
1288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1289 
1290     /**
1291      * @dev Initializes the contract setting the deployer as the initial owner.
1292      */
1293     constructor() {
1294         _transferOwnership(_msgSender());
1295     }
1296 
1297     /**
1298      * @dev Returns the address of the current owner.
1299      */
1300     function owner() public view virtual returns (address) {
1301         return _owner;
1302     }
1303 
1304     /**
1305      * @dev Throws if called by any account other than the owner.
1306      */
1307     modifier onlyOwner() {
1308         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1309         _;
1310     }
1311 
1312     /**
1313      * @dev Leaves the contract without owner. It will not be possible to call
1314      * `onlyOwner` functions anymore. Can only be called by the current owner.
1315      *
1316      * NOTE: Renouncing ownership will leave the contract without an owner,
1317      * thereby removing any functionality that is only available to the owner.
1318      */
1319     function renounceOwnership() public virtual onlyOwner {
1320         _transferOwnership(address(0));
1321     }
1322 
1323     /**
1324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1325      * Can only be called by the current owner.
1326      */
1327     function transferOwnership(address newOwner) public virtual onlyOwner {
1328         require(newOwner != address(0), "Ownable: new owner is the zero address");
1329         _transferOwnership(newOwner);
1330     }
1331 
1332     /**
1333      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1334      * Internal function without access restriction.
1335      */
1336     function _transferOwnership(address newOwner) internal virtual {
1337         address oldOwner = _owner;
1338         _owner = newOwner;
1339         emit OwnershipTransferred(oldOwner, newOwner);
1340     }
1341 }
1342 
1343 // File: contracts/Vitaliks.sol
1344 
1345 
1346 
1347 pragma solidity >=0.8.0;
1348 
1349 
1350 
1351 
1352 contract Vitaliks is ERC721, Ownable {
1353     using SafeMath for uint256;
1354     using Strings for uint256;
1355 
1356     string baseURI;
1357     string public baseExtension = ".json";
1358     uint256 public MAX_VITALIKS;
1359     uint256 public latestNewVitalikForSale;
1360 
1361     struct Vitalik {
1362         address owner;
1363         bool currentlyForSale;
1364         uint price;
1365         uint timesSold;
1366     }
1367 
1368     mapping (uint => Vitalik) public vitaliks;
1369     mapping (address => uint[]) public vitalikOwnersHistory;
1370     
1371     mapping (uint256 => address) public idToOwner;
1372     mapping (uint256 => address) public idToApproval;
1373     mapping (address => uint256) public ownerToNFTokenCount;
1374     mapping (address => mapping (address => bool)) public ownerToOperators;
1375 
1376     constructor(string memory name, string memory symbol, string memory initBaseURI, uint256 maxNFTSupply) ERC721(name, symbol) {
1377         setBaseURI(initBaseURI);
1378         MAX_VITALIKS = maxNFTSupply;
1379         latestNewVitalikForSale = 1;
1380         vitaliks[1].currentlyForSale = true;
1381         vitaliks[1].price = (10**16)*1;
1382     }
1383 
1384     // Internal Functions
1385     function _baseURI() internal view virtual override returns (string memory) {
1386         return baseURI;
1387     }
1388 
1389     function _tokenExists(uint256 tokenId) internal view virtual returns (bool) {
1390         return idToOwner[tokenId] != address(0);
1391     }
1392 
1393     modifier canTransfer(uint256 _tokenId) {
1394         address tokenOwner = idToOwner[_tokenId];
1395         require(
1396             tokenOwner == msg.sender
1397             || idToApproval[_tokenId] == msg.sender
1398             || ownerToOperators[tokenOwner][msg.sender]
1399         );
1400         _;
1401     }
1402 
1403     modifier validNFToken(uint256 _tokenId) {
1404         address tokenOwner = getVitalikOwner(_tokenId);
1405         require(tokenOwner != address(0));
1406         _;
1407     }
1408 
1409     function _addNFToken(address _to, uint256 _tokenId) internal virtual {
1410         require(idToOwner[_tokenId] == address(0));
1411 
1412         idToOwner[_tokenId] = _to;
1413         ownerToNFTokenCount[_to]++;
1414     }
1415 
1416     function _mint(address _to, uint256 _tokenId) internal virtual override {
1417         require(_to != address(0));
1418         require(idToOwner[_tokenId] == address(0));
1419 
1420         _addNFToken(_to, _tokenId);
1421 
1422         emit Transfer(address(0), _to, _tokenId);
1423     }
1424 
1425     function _clearApproval(uint256 _tokenId) private {
1426         if (idToApproval[_tokenId] != address(0)) {
1427             delete idToApproval[_tokenId];
1428         }
1429     }
1430 
1431     function _removeNFToken(address _from, uint256 _tokenId) internal virtual {
1432         require(idToOwner[_tokenId] == _from);
1433         ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from]--;
1434         delete idToOwner[_tokenId];
1435     }
1436 
1437     function _transfer(address _to, uint256 _tokenId) internal {
1438         address from = idToOwner[_tokenId];
1439         _clearApproval(_tokenId);
1440 
1441         _removeNFToken(from, _tokenId);
1442         _addNFToken(_to, _tokenId);
1443         
1444         vitaliks[_tokenId].owner = _to;
1445 
1446         emit Transfer(from, _to, _tokenId);
1447     }
1448 
1449     function _safeTransferFrom(address _from, address _to, uint256 _tokenId) private canTransfer(_tokenId) validNFToken(_tokenId) {
1450         address tokenOwner = getVitalikOwner(_tokenId);
1451         require(tokenOwner == _from);
1452         require(_to != address(0));
1453 
1454         _transfer(_to, _tokenId);
1455     }
1456 
1457     // Public Functions
1458     function getVitalikInfo (uint vitalikNumber) public view returns (address, bool, uint, uint) {
1459         return (vitaliks[vitalikNumber].owner, vitaliks[vitalikNumber].currentlyForSale, vitaliks[vitalikNumber].price, vitaliks[vitalikNumber].timesSold);
1460     }
1461     
1462     function getVitalikOwner (uint vitalikNumber) public view returns (address) {
1463         return (vitaliks[vitalikNumber].owner);
1464     }
1465     
1466     function getVitalikOwnerHistory (address _address) public view returns (uint[] memory ownersHistory) {
1467         ownersHistory = vitalikOwnersHistory[_address];
1468     }
1469 
1470     function buyVitalik (uint vitalikNumber) public payable {
1471         require(vitaliks[vitalikNumber].currentlyForSale == true);
1472         require(msg.value == vitaliks[vitalikNumber].price);
1473         require(vitalikNumber <= MAX_VITALIKS);
1474 
1475         vitaliks[vitalikNumber].timesSold++;
1476         vitalikOwnersHistory[msg.sender].push(vitalikNumber);
1477         vitaliks[vitalikNumber].currentlyForSale = false;
1478 
1479         if (vitalikNumber != latestNewVitalikForSale) {
1480             address currentVitalikOwner = getVitalikOwner(vitalikNumber);
1481             payable(currentVitalikOwner).transfer(vitaliks[vitalikNumber].price);
1482             idToApproval[vitalikNumber] = msg.sender;
1483             _safeTransferFrom(currentVitalikOwner, msg.sender, vitalikNumber);
1484         } else {
1485             vitaliks[vitalikNumber].owner = msg.sender;
1486             
1487             if (latestNewVitalikForSale < MAX_VITALIKS) {
1488                 latestNewVitalikForSale++;
1489                 vitaliks[latestNewVitalikForSale].price = SafeMath.add(SafeMath.div(SafeMath.mul(SafeMath.mul(vitaliks[vitalikNumber].price, 10**6), 3624), 10**12), vitaliks[vitalikNumber].price);
1490                 vitaliks[latestNewVitalikForSale].currentlyForSale = true;
1491             }
1492 
1493             _mint(msg.sender, vitalikNumber);
1494         }
1495     }
1496 
1497     function sellVitalik (uint vitalikNumber, uint price) public {
1498         require(msg.sender == vitaliks[vitalikNumber].owner);
1499         require(price > 0);
1500         
1501         vitaliks[vitalikNumber].price = price;
1502         vitaliks[vitalikNumber].currentlyForSale = true;
1503     }
1504 
1505     function giftVitalik (uint vitalikNumber, address receiver) public {
1506         require(msg.sender == vitaliks[vitalikNumber].owner);
1507         require(receiver != address(0));
1508 
1509         vitalikOwnersHistory[receiver].push(vitalikNumber);
1510         _safeTransferFrom(msg.sender, receiver, vitalikNumber);
1511     }
1512     
1513     function dontSellVitalik (uint vitalikNumber) public {
1514         require(msg.sender == vitaliks[vitalikNumber].owner);
1515         
1516         vitaliks[vitalikNumber].currentlyForSale = false;
1517     }
1518     
1519     function tokenURI(uint256 tokenId)
1520         public
1521         view
1522         virtual
1523         override
1524         returns (string memory) {
1525             require(
1526                 _tokenExists(tokenId),
1527                 "ERC721Metadata: URI query for nonexistent token"
1528             );
1529 
1530             string memory currentBaseURI = _baseURI();
1531             return bytes(currentBaseURI).length > 0
1532                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1533                 : "";
1534         }
1535 
1536     // Owner Functions
1537     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1538         baseURI = _newBaseURI;
1539     }
1540 
1541     function withdraw() public onlyOwner {
1542         uint balance = address(this).balance;
1543         payable(msg.sender).transfer(balance);
1544     }
1545 
1546     function checkBalance() public view onlyOwner returns (uint) {
1547         uint balance = address(this).balance;
1548         return balance;
1549     }
1550 }