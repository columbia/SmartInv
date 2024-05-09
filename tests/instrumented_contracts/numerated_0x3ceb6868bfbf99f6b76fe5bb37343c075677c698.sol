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
1343 // File: @openzeppelin/contracts/utils/Counters.sol
1344 
1345 
1346 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1347 
1348 pragma solidity ^0.8.0;
1349 
1350 /**
1351  * @title Counters
1352  * @author Matt Condon (@shrugs)
1353  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1354  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1355  *
1356  * Include with `using Counters for Counters.Counter;`
1357  */
1358 library Counters {
1359     struct Counter {
1360         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1361         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1362         // this feature: see https://github.com/ethereum/solidity/issues/4637
1363         uint256 _value; // default: 0
1364     }
1365 
1366     function current(Counter storage counter) internal view returns (uint256) {
1367         return counter._value;
1368     }
1369 
1370     function increment(Counter storage counter) internal {
1371         unchecked {
1372             counter._value += 1;
1373         }
1374     }
1375 
1376     function decrement(Counter storage counter) internal {
1377         uint256 value = counter._value;
1378         require(value > 0, "Counter: decrement overflow");
1379         unchecked {
1380             counter._value = value - 1;
1381         }
1382     }
1383 
1384     function reset(Counter storage counter) internal {
1385         counter._value = 0;
1386     }
1387 }
1388 
1389 // File: hardhat/console.sol
1390 
1391 
1392 pragma solidity >= 0.4.22 <0.9.0;
1393 
1394 library console {
1395 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1396 
1397 	function _sendLogPayload(bytes memory payload) private view {
1398 		uint256 payloadLength = payload.length;
1399 		address consoleAddress = CONSOLE_ADDRESS;
1400 		assembly {
1401 			let payloadStart := add(payload, 32)
1402 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1403 		}
1404 	}
1405 
1406 	function log() internal view {
1407 		_sendLogPayload(abi.encodeWithSignature("log()"));
1408 	}
1409 
1410 	function logInt(int p0) internal view {
1411 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1412 	}
1413 
1414 	function logUint(uint p0) internal view {
1415 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1416 	}
1417 
1418 	function logString(string memory p0) internal view {
1419 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1420 	}
1421 
1422 	function logBool(bool p0) internal view {
1423 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1424 	}
1425 
1426 	function logAddress(address p0) internal view {
1427 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1428 	}
1429 
1430 	function logBytes(bytes memory p0) internal view {
1431 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1432 	}
1433 
1434 	function logBytes1(bytes1 p0) internal view {
1435 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1436 	}
1437 
1438 	function logBytes2(bytes2 p0) internal view {
1439 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1440 	}
1441 
1442 	function logBytes3(bytes3 p0) internal view {
1443 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1444 	}
1445 
1446 	function logBytes4(bytes4 p0) internal view {
1447 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1448 	}
1449 
1450 	function logBytes5(bytes5 p0) internal view {
1451 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1452 	}
1453 
1454 	function logBytes6(bytes6 p0) internal view {
1455 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1456 	}
1457 
1458 	function logBytes7(bytes7 p0) internal view {
1459 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1460 	}
1461 
1462 	function logBytes8(bytes8 p0) internal view {
1463 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1464 	}
1465 
1466 	function logBytes9(bytes9 p0) internal view {
1467 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1468 	}
1469 
1470 	function logBytes10(bytes10 p0) internal view {
1471 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1472 	}
1473 
1474 	function logBytes11(bytes11 p0) internal view {
1475 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1476 	}
1477 
1478 	function logBytes12(bytes12 p0) internal view {
1479 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1480 	}
1481 
1482 	function logBytes13(bytes13 p0) internal view {
1483 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1484 	}
1485 
1486 	function logBytes14(bytes14 p0) internal view {
1487 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1488 	}
1489 
1490 	function logBytes15(bytes15 p0) internal view {
1491 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1492 	}
1493 
1494 	function logBytes16(bytes16 p0) internal view {
1495 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1496 	}
1497 
1498 	function logBytes17(bytes17 p0) internal view {
1499 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1500 	}
1501 
1502 	function logBytes18(bytes18 p0) internal view {
1503 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1504 	}
1505 
1506 	function logBytes19(bytes19 p0) internal view {
1507 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1508 	}
1509 
1510 	function logBytes20(bytes20 p0) internal view {
1511 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1512 	}
1513 
1514 	function logBytes21(bytes21 p0) internal view {
1515 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1516 	}
1517 
1518 	function logBytes22(bytes22 p0) internal view {
1519 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1520 	}
1521 
1522 	function logBytes23(bytes23 p0) internal view {
1523 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1524 	}
1525 
1526 	function logBytes24(bytes24 p0) internal view {
1527 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1528 	}
1529 
1530 	function logBytes25(bytes25 p0) internal view {
1531 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1532 	}
1533 
1534 	function logBytes26(bytes26 p0) internal view {
1535 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1536 	}
1537 
1538 	function logBytes27(bytes27 p0) internal view {
1539 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1540 	}
1541 
1542 	function logBytes28(bytes28 p0) internal view {
1543 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1544 	}
1545 
1546 	function logBytes29(bytes29 p0) internal view {
1547 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1548 	}
1549 
1550 	function logBytes30(bytes30 p0) internal view {
1551 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1552 	}
1553 
1554 	function logBytes31(bytes31 p0) internal view {
1555 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1556 	}
1557 
1558 	function logBytes32(bytes32 p0) internal view {
1559 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1560 	}
1561 
1562 	function log(uint p0) internal view {
1563 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1564 	}
1565 
1566 	function log(string memory p0) internal view {
1567 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1568 	}
1569 
1570 	function log(bool p0) internal view {
1571 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1572 	}
1573 
1574 	function log(address p0) internal view {
1575 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1576 	}
1577 
1578 	function log(uint p0, uint p1) internal view {
1579 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1580 	}
1581 
1582 	function log(uint p0, string memory p1) internal view {
1583 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1584 	}
1585 
1586 	function log(uint p0, bool p1) internal view {
1587 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1588 	}
1589 
1590 	function log(uint p0, address p1) internal view {
1591 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1592 	}
1593 
1594 	function log(string memory p0, uint p1) internal view {
1595 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1596 	}
1597 
1598 	function log(string memory p0, string memory p1) internal view {
1599 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1600 	}
1601 
1602 	function log(string memory p0, bool p1) internal view {
1603 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1604 	}
1605 
1606 	function log(string memory p0, address p1) internal view {
1607 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1608 	}
1609 
1610 	function log(bool p0, uint p1) internal view {
1611 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1612 	}
1613 
1614 	function log(bool p0, string memory p1) internal view {
1615 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1616 	}
1617 
1618 	function log(bool p0, bool p1) internal view {
1619 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1620 	}
1621 
1622 	function log(bool p0, address p1) internal view {
1623 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1624 	}
1625 
1626 	function log(address p0, uint p1) internal view {
1627 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1628 	}
1629 
1630 	function log(address p0, string memory p1) internal view {
1631 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1632 	}
1633 
1634 	function log(address p0, bool p1) internal view {
1635 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1636 	}
1637 
1638 	function log(address p0, address p1) internal view {
1639 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1640 	}
1641 
1642 	function log(uint p0, uint p1, uint p2) internal view {
1643 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1644 	}
1645 
1646 	function log(uint p0, uint p1, string memory p2) internal view {
1647 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1648 	}
1649 
1650 	function log(uint p0, uint p1, bool p2) internal view {
1651 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1652 	}
1653 
1654 	function log(uint p0, uint p1, address p2) internal view {
1655 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1656 	}
1657 
1658 	function log(uint p0, string memory p1, uint p2) internal view {
1659 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1660 	}
1661 
1662 	function log(uint p0, string memory p1, string memory p2) internal view {
1663 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1664 	}
1665 
1666 	function log(uint p0, string memory p1, bool p2) internal view {
1667 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1668 	}
1669 
1670 	function log(uint p0, string memory p1, address p2) internal view {
1671 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1672 	}
1673 
1674 	function log(uint p0, bool p1, uint p2) internal view {
1675 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1676 	}
1677 
1678 	function log(uint p0, bool p1, string memory p2) internal view {
1679 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1680 	}
1681 
1682 	function log(uint p0, bool p1, bool p2) internal view {
1683 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1684 	}
1685 
1686 	function log(uint p0, bool p1, address p2) internal view {
1687 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1688 	}
1689 
1690 	function log(uint p0, address p1, uint p2) internal view {
1691 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1692 	}
1693 
1694 	function log(uint p0, address p1, string memory p2) internal view {
1695 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1696 	}
1697 
1698 	function log(uint p0, address p1, bool p2) internal view {
1699 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1700 	}
1701 
1702 	function log(uint p0, address p1, address p2) internal view {
1703 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1704 	}
1705 
1706 	function log(string memory p0, uint p1, uint p2) internal view {
1707 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1708 	}
1709 
1710 	function log(string memory p0, uint p1, string memory p2) internal view {
1711 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1712 	}
1713 
1714 	function log(string memory p0, uint p1, bool p2) internal view {
1715 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1716 	}
1717 
1718 	function log(string memory p0, uint p1, address p2) internal view {
1719 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1720 	}
1721 
1722 	function log(string memory p0, string memory p1, uint p2) internal view {
1723 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1724 	}
1725 
1726 	function log(string memory p0, string memory p1, string memory p2) internal view {
1727 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1728 	}
1729 
1730 	function log(string memory p0, string memory p1, bool p2) internal view {
1731 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1732 	}
1733 
1734 	function log(string memory p0, string memory p1, address p2) internal view {
1735 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1736 	}
1737 
1738 	function log(string memory p0, bool p1, uint p2) internal view {
1739 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1740 	}
1741 
1742 	function log(string memory p0, bool p1, string memory p2) internal view {
1743 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1744 	}
1745 
1746 	function log(string memory p0, bool p1, bool p2) internal view {
1747 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1748 	}
1749 
1750 	function log(string memory p0, bool p1, address p2) internal view {
1751 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1752 	}
1753 
1754 	function log(string memory p0, address p1, uint p2) internal view {
1755 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1756 	}
1757 
1758 	function log(string memory p0, address p1, string memory p2) internal view {
1759 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1760 	}
1761 
1762 	function log(string memory p0, address p1, bool p2) internal view {
1763 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1764 	}
1765 
1766 	function log(string memory p0, address p1, address p2) internal view {
1767 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1768 	}
1769 
1770 	function log(bool p0, uint p1, uint p2) internal view {
1771 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1772 	}
1773 
1774 	function log(bool p0, uint p1, string memory p2) internal view {
1775 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1776 	}
1777 
1778 	function log(bool p0, uint p1, bool p2) internal view {
1779 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1780 	}
1781 
1782 	function log(bool p0, uint p1, address p2) internal view {
1783 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1784 	}
1785 
1786 	function log(bool p0, string memory p1, uint p2) internal view {
1787 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1788 	}
1789 
1790 	function log(bool p0, string memory p1, string memory p2) internal view {
1791 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1792 	}
1793 
1794 	function log(bool p0, string memory p1, bool p2) internal view {
1795 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1796 	}
1797 
1798 	function log(bool p0, string memory p1, address p2) internal view {
1799 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1800 	}
1801 
1802 	function log(bool p0, bool p1, uint p2) internal view {
1803 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1804 	}
1805 
1806 	function log(bool p0, bool p1, string memory p2) internal view {
1807 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1808 	}
1809 
1810 	function log(bool p0, bool p1, bool p2) internal view {
1811 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1812 	}
1813 
1814 	function log(bool p0, bool p1, address p2) internal view {
1815 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1816 	}
1817 
1818 	function log(bool p0, address p1, uint p2) internal view {
1819 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1820 	}
1821 
1822 	function log(bool p0, address p1, string memory p2) internal view {
1823 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1824 	}
1825 
1826 	function log(bool p0, address p1, bool p2) internal view {
1827 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1828 	}
1829 
1830 	function log(bool p0, address p1, address p2) internal view {
1831 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1832 	}
1833 
1834 	function log(address p0, uint p1, uint p2) internal view {
1835 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1836 	}
1837 
1838 	function log(address p0, uint p1, string memory p2) internal view {
1839 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1840 	}
1841 
1842 	function log(address p0, uint p1, bool p2) internal view {
1843 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1844 	}
1845 
1846 	function log(address p0, uint p1, address p2) internal view {
1847 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1848 	}
1849 
1850 	function log(address p0, string memory p1, uint p2) internal view {
1851 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1852 	}
1853 
1854 	function log(address p0, string memory p1, string memory p2) internal view {
1855 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1856 	}
1857 
1858 	function log(address p0, string memory p1, bool p2) internal view {
1859 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1860 	}
1861 
1862 	function log(address p0, string memory p1, address p2) internal view {
1863 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1864 	}
1865 
1866 	function log(address p0, bool p1, uint p2) internal view {
1867 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1868 	}
1869 
1870 	function log(address p0, bool p1, string memory p2) internal view {
1871 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1872 	}
1873 
1874 	function log(address p0, bool p1, bool p2) internal view {
1875 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1876 	}
1877 
1878 	function log(address p0, bool p1, address p2) internal view {
1879 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1880 	}
1881 
1882 	function log(address p0, address p1, uint p2) internal view {
1883 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1884 	}
1885 
1886 	function log(address p0, address p1, string memory p2) internal view {
1887 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1888 	}
1889 
1890 	function log(address p0, address p1, bool p2) internal view {
1891 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1892 	}
1893 
1894 	function log(address p0, address p1, address p2) internal view {
1895 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1896 	}
1897 
1898 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1899 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1900 	}
1901 
1902 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1903 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1904 	}
1905 
1906 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1907 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1908 	}
1909 
1910 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1911 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1912 	}
1913 
1914 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1915 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1916 	}
1917 
1918 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1919 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1920 	}
1921 
1922 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1923 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1924 	}
1925 
1926 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1927 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1928 	}
1929 
1930 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1931 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1932 	}
1933 
1934 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1935 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1936 	}
1937 
1938 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1939 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1940 	}
1941 
1942 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1943 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1944 	}
1945 
1946 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1947 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1948 	}
1949 
1950 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1951 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1952 	}
1953 
1954 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1955 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1956 	}
1957 
1958 	function log(uint p0, uint p1, address p2, address p3) internal view {
1959 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1960 	}
1961 
1962 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1963 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1964 	}
1965 
1966 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1967 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1968 	}
1969 
1970 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1971 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1972 	}
1973 
1974 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1975 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1976 	}
1977 
1978 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1979 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1980 	}
1981 
1982 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1983 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1984 	}
1985 
1986 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1987 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1988 	}
1989 
1990 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1991 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1992 	}
1993 
1994 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1995 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1996 	}
1997 
1998 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1999 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2000 	}
2001 
2002 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2003 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2004 	}
2005 
2006 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2007 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2008 	}
2009 
2010 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2011 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2012 	}
2013 
2014 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2015 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2016 	}
2017 
2018 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2019 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2020 	}
2021 
2022 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2023 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2024 	}
2025 
2026 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2027 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2028 	}
2029 
2030 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2031 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2032 	}
2033 
2034 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2035 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2036 	}
2037 
2038 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2039 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2040 	}
2041 
2042 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2043 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2044 	}
2045 
2046 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2047 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2048 	}
2049 
2050 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2051 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2052 	}
2053 
2054 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2055 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2056 	}
2057 
2058 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2059 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2060 	}
2061 
2062 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2063 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2064 	}
2065 
2066 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2067 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2068 	}
2069 
2070 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2071 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2072 	}
2073 
2074 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2075 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2076 	}
2077 
2078 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2079 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2080 	}
2081 
2082 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2083 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2084 	}
2085 
2086 	function log(uint p0, bool p1, address p2, address p3) internal view {
2087 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2088 	}
2089 
2090 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2091 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2092 	}
2093 
2094 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2095 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2096 	}
2097 
2098 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2099 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2100 	}
2101 
2102 	function log(uint p0, address p1, uint p2, address p3) internal view {
2103 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2104 	}
2105 
2106 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2107 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2108 	}
2109 
2110 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2111 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2112 	}
2113 
2114 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2115 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2116 	}
2117 
2118 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2119 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2120 	}
2121 
2122 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2123 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2124 	}
2125 
2126 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2127 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2128 	}
2129 
2130 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2131 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2132 	}
2133 
2134 	function log(uint p0, address p1, bool p2, address p3) internal view {
2135 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2136 	}
2137 
2138 	function log(uint p0, address p1, address p2, uint p3) internal view {
2139 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2140 	}
2141 
2142 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2143 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2144 	}
2145 
2146 	function log(uint p0, address p1, address p2, bool p3) internal view {
2147 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2148 	}
2149 
2150 	function log(uint p0, address p1, address p2, address p3) internal view {
2151 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2152 	}
2153 
2154 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2155 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2156 	}
2157 
2158 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2159 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2160 	}
2161 
2162 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2163 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2164 	}
2165 
2166 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2167 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2168 	}
2169 
2170 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2171 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2172 	}
2173 
2174 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2175 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2176 	}
2177 
2178 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2179 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2180 	}
2181 
2182 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2183 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2184 	}
2185 
2186 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2187 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2188 	}
2189 
2190 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2191 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2192 	}
2193 
2194 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2195 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2196 	}
2197 
2198 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2199 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2200 	}
2201 
2202 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2203 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2204 	}
2205 
2206 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2207 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2208 	}
2209 
2210 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2211 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2212 	}
2213 
2214 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2215 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2216 	}
2217 
2218 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2219 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2220 	}
2221 
2222 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2223 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2224 	}
2225 
2226 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2227 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2228 	}
2229 
2230 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2231 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2232 	}
2233 
2234 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2235 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2236 	}
2237 
2238 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2239 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2240 	}
2241 
2242 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2243 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2244 	}
2245 
2246 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2247 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2248 	}
2249 
2250 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2251 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2252 	}
2253 
2254 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2255 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2256 	}
2257 
2258 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2259 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2260 	}
2261 
2262 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2263 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2264 	}
2265 
2266 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2267 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2268 	}
2269 
2270 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2271 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2272 	}
2273 
2274 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2275 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2276 	}
2277 
2278 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2279 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2280 	}
2281 
2282 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2283 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2284 	}
2285 
2286 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2287 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2288 	}
2289 
2290 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2291 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2292 	}
2293 
2294 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2295 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2296 	}
2297 
2298 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2299 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2300 	}
2301 
2302 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2303 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2304 	}
2305 
2306 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2307 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2308 	}
2309 
2310 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2311 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2312 	}
2313 
2314 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2315 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2316 	}
2317 
2318 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2319 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2320 	}
2321 
2322 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2323 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2324 	}
2325 
2326 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2327 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2328 	}
2329 
2330 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2331 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2332 	}
2333 
2334 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2335 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2336 	}
2337 
2338 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2339 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2340 	}
2341 
2342 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2343 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2344 	}
2345 
2346 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2347 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2348 	}
2349 
2350 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2351 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2352 	}
2353 
2354 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2355 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2356 	}
2357 
2358 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2359 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2360 	}
2361 
2362 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2363 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2364 	}
2365 
2366 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2367 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2368 	}
2369 
2370 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2371 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2372 	}
2373 
2374 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2375 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2376 	}
2377 
2378 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2379 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2380 	}
2381 
2382 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2383 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2384 	}
2385 
2386 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2387 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2388 	}
2389 
2390 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2391 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2392 	}
2393 
2394 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2395 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2396 	}
2397 
2398 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2399 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2400 	}
2401 
2402 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2403 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2404 	}
2405 
2406 	function log(string memory p0, address p1, address p2, address p3) internal view {
2407 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2408 	}
2409 
2410 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2411 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2412 	}
2413 
2414 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2415 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2416 	}
2417 
2418 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2419 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2420 	}
2421 
2422 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2423 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2424 	}
2425 
2426 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2427 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2428 	}
2429 
2430 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2431 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2432 	}
2433 
2434 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2435 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2436 	}
2437 
2438 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2439 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2440 	}
2441 
2442 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2443 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2444 	}
2445 
2446 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2447 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2448 	}
2449 
2450 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2451 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2452 	}
2453 
2454 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2455 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2456 	}
2457 
2458 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2459 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2460 	}
2461 
2462 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2463 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2464 	}
2465 
2466 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2467 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2468 	}
2469 
2470 	function log(bool p0, uint p1, address p2, address p3) internal view {
2471 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2472 	}
2473 
2474 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2475 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2476 	}
2477 
2478 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2479 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2480 	}
2481 
2482 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2483 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2484 	}
2485 
2486 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2487 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2488 	}
2489 
2490 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2491 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2492 	}
2493 
2494 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2495 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2496 	}
2497 
2498 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2499 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2500 	}
2501 
2502 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2503 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2504 	}
2505 
2506 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2507 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2508 	}
2509 
2510 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2511 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2512 	}
2513 
2514 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2515 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2516 	}
2517 
2518 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2519 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2520 	}
2521 
2522 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2523 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2524 	}
2525 
2526 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2527 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2528 	}
2529 
2530 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2531 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2532 	}
2533 
2534 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2535 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2536 	}
2537 
2538 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2539 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2540 	}
2541 
2542 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2543 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2544 	}
2545 
2546 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2547 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2548 	}
2549 
2550 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2551 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2552 	}
2553 
2554 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2555 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2556 	}
2557 
2558 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2559 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2560 	}
2561 
2562 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2563 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2564 	}
2565 
2566 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2567 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2568 	}
2569 
2570 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2571 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2572 	}
2573 
2574 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2575 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2576 	}
2577 
2578 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2579 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2580 	}
2581 
2582 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2583 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2584 	}
2585 
2586 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2587 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2588 	}
2589 
2590 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2591 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2592 	}
2593 
2594 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2595 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2596 	}
2597 
2598 	function log(bool p0, bool p1, address p2, address p3) internal view {
2599 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2600 	}
2601 
2602 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2603 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2604 	}
2605 
2606 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2607 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2608 	}
2609 
2610 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2611 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2612 	}
2613 
2614 	function log(bool p0, address p1, uint p2, address p3) internal view {
2615 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2616 	}
2617 
2618 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2619 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2620 	}
2621 
2622 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2623 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2624 	}
2625 
2626 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2627 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2628 	}
2629 
2630 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2631 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2632 	}
2633 
2634 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2635 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2636 	}
2637 
2638 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2639 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2640 	}
2641 
2642 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2643 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2644 	}
2645 
2646 	function log(bool p0, address p1, bool p2, address p3) internal view {
2647 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2648 	}
2649 
2650 	function log(bool p0, address p1, address p2, uint p3) internal view {
2651 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2652 	}
2653 
2654 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2655 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2656 	}
2657 
2658 	function log(bool p0, address p1, address p2, bool p3) internal view {
2659 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2660 	}
2661 
2662 	function log(bool p0, address p1, address p2, address p3) internal view {
2663 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2664 	}
2665 
2666 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2667 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2668 	}
2669 
2670 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2671 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2672 	}
2673 
2674 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2675 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2676 	}
2677 
2678 	function log(address p0, uint p1, uint p2, address p3) internal view {
2679 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2680 	}
2681 
2682 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2683 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2684 	}
2685 
2686 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2687 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2688 	}
2689 
2690 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2691 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2692 	}
2693 
2694 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2695 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2696 	}
2697 
2698 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2699 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2700 	}
2701 
2702 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2703 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2704 	}
2705 
2706 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2707 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2708 	}
2709 
2710 	function log(address p0, uint p1, bool p2, address p3) internal view {
2711 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2712 	}
2713 
2714 	function log(address p0, uint p1, address p2, uint p3) internal view {
2715 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2716 	}
2717 
2718 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2719 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2720 	}
2721 
2722 	function log(address p0, uint p1, address p2, bool p3) internal view {
2723 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2724 	}
2725 
2726 	function log(address p0, uint p1, address p2, address p3) internal view {
2727 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2728 	}
2729 
2730 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2731 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2732 	}
2733 
2734 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2735 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2736 	}
2737 
2738 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2739 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2740 	}
2741 
2742 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2743 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2744 	}
2745 
2746 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2747 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2748 	}
2749 
2750 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2751 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2752 	}
2753 
2754 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2755 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2756 	}
2757 
2758 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2759 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2760 	}
2761 
2762 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2763 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2764 	}
2765 
2766 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2767 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2768 	}
2769 
2770 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2771 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2772 	}
2773 
2774 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2775 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2776 	}
2777 
2778 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2779 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2780 	}
2781 
2782 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2783 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2784 	}
2785 
2786 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2787 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2788 	}
2789 
2790 	function log(address p0, string memory p1, address p2, address p3) internal view {
2791 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2792 	}
2793 
2794 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2795 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2796 	}
2797 
2798 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2799 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2800 	}
2801 
2802 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2803 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2804 	}
2805 
2806 	function log(address p0, bool p1, uint p2, address p3) internal view {
2807 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2808 	}
2809 
2810 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2811 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2812 	}
2813 
2814 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2815 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2816 	}
2817 
2818 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2819 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2820 	}
2821 
2822 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2823 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2824 	}
2825 
2826 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2827 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2828 	}
2829 
2830 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2831 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2832 	}
2833 
2834 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2835 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2836 	}
2837 
2838 	function log(address p0, bool p1, bool p2, address p3) internal view {
2839 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2840 	}
2841 
2842 	function log(address p0, bool p1, address p2, uint p3) internal view {
2843 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2844 	}
2845 
2846 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2847 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2848 	}
2849 
2850 	function log(address p0, bool p1, address p2, bool p3) internal view {
2851 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2852 	}
2853 
2854 	function log(address p0, bool p1, address p2, address p3) internal view {
2855 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2856 	}
2857 
2858 	function log(address p0, address p1, uint p2, uint p3) internal view {
2859 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2860 	}
2861 
2862 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2863 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2864 	}
2865 
2866 	function log(address p0, address p1, uint p2, bool p3) internal view {
2867 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2868 	}
2869 
2870 	function log(address p0, address p1, uint p2, address p3) internal view {
2871 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2872 	}
2873 
2874 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2875 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2876 	}
2877 
2878 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2879 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2880 	}
2881 
2882 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2883 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2884 	}
2885 
2886 	function log(address p0, address p1, string memory p2, address p3) internal view {
2887 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2888 	}
2889 
2890 	function log(address p0, address p1, bool p2, uint p3) internal view {
2891 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2892 	}
2893 
2894 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2895 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2896 	}
2897 
2898 	function log(address p0, address p1, bool p2, bool p3) internal view {
2899 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2900 	}
2901 
2902 	function log(address p0, address p1, bool p2, address p3) internal view {
2903 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2904 	}
2905 
2906 	function log(address p0, address p1, address p2, uint p3) internal view {
2907 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2908 	}
2909 
2910 	function log(address p0, address p1, address p2, string memory p3) internal view {
2911 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2912 	}
2913 
2914 	function log(address p0, address p1, address p2, bool p3) internal view {
2915 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2916 	}
2917 
2918 	function log(address p0, address p1, address p2, address p3) internal view {
2919 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2920 	}
2921 
2922 }
2923 
2924 // File: v1phunks.sol
2925 
2926 
2927 
2928 /** 
2929 
2930 does NOT admit json extension in ipfs
2931 */
2932 
2933 pragma solidity ^0.8.0;
2934 
2935 
2936 
2937 
2938 
2939 
2940 contract V1Phunks is ERC721, Ownable {
2941     using Counters for Counters.Counter;
2942     using SafeMath for uint256;
2943 
2944     Counters.Counter private _tokenIds;
2945     uint256 public constant MAX_SUPPLY = 10000; //10.000 V1 Phunks
2946     uint256 public constant MAX_PER_MINT = 10;
2947     uint256 private constant MAX_RESERVED_MINTS = 500;
2948 
2949     uint256 public FREE_STAGE_MINTING= 250;
2950 
2951     uint256 private FREE_STAGE_PRICE= 0 ether;
2952 
2953     uint256 public PUBLIC_PRICE= 0.015 ether;
2954 
2955     uint256 private RESERVED_MINTS = 0;
2956     
2957 
2958     bool public paused = false;
2959     
2960     string public baseTokenURI = "ipfs://QmYxKmX5SXfGxwgrrfNvxxEXdbxaTQn9yy3JQx15p5cwgo/";
2961 
2962     constructor() ERC721("V1 Phunks", "V1PHNK") {
2963         setBaseURI(baseTokenURI);
2964         _mintSingleNFT();
2965     }
2966 
2967     function _baseURI() internal view virtual override returns (string memory) {
2968        return baseTokenURI;
2969     }
2970     
2971     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
2972         baseTokenURI = _baseTokenURI;
2973     }
2974 
2975     function mintNFTs(uint _number) public payable {
2976         uint256 totalMinted = _tokenIds.current();
2977         require(!paused, "Sale Paused") ;
2978         require(totalMinted.add(_number) <= MAX_SUPPLY - MAX_RESERVED_MINTS, "Not enough V1 Phunks remaining!");
2979         require(_number > 0 && _number <= MAX_PER_MINT, "Cannot mint specified number of V1 Phunks.");
2980         require(msg.value >= Price() * _number, "Not enough ether to purchase V1 Phunks.");
2981         
2982         for (uint i = 0; i < _number; i++) {
2983             _mintSingleNFT();
2984         }
2985     }
2986 
2987     function _mintSingleNFT() private {
2988       uint newTokenID = _tokenIds.current();
2989       _safeMint(msg.sender, newTokenID);
2990       _tokenIds.increment();
2991     }
2992     
2993     //in case ETH price gets too high; expressed in ETH x 10^18
2994     function setPrice(uint256 _price) external onlyOwner {
2995         PUBLIC_PRICE = _price;
2996     }
2997 
2998    function Price() private view returns(uint256) {
2999         uint256 totalMinted = _tokenIds.current();
3000         if ( totalMinted < FREE_STAGE_MINTING) {
3001             return FREE_STAGE_PRICE;
3002         } else {
3003             return PUBLIC_PRICE;
3004         }
3005     }
3006     
3007     function setFreeMints(uint256 freeStageNum) external onlyOwner {
3008         FREE_STAGE_MINTING = freeStageNum;
3009     }
3010 
3011      function reserveNFTs(uint256 _number) public onlyOwner {
3012         uint256 totalMinted = _tokenIds.current();
3013         require((totalMinted.add(_number)) <= MAX_SUPPLY, "Exceeds V1 Phunks supply");
3014         require(RESERVED_MINTS + _number <= MAX_RESERVED_MINTS, "Exceeds reserved V1 Phunks supply");
3015         
3016         for (uint256 i = 0; i < _number; i++) {
3017             _mintSingleNFT();
3018         }
3019         RESERVED_MINTS = RESERVED_MINTS + _number;
3020 
3021     }
3022 
3023 //Withdraw money in contract to Owner
3024     function withdraw() public payable onlyOwner {
3025      uint256 balance = address(this).balance;
3026      require(balance > 0, "No ether left to withdraw");
3027 
3028      (bool success, ) = (msg.sender).call{value: balance}("");
3029 
3030      require(success, "Transfer failed.");
3031     }
3032 
3033     function giveAway(address _to, uint256 _amount) external onlyOwner() {
3034         require( _amount + RESERVED_MINTS <= MAX_RESERVED_MINTS, "Exceeds reserved V1 Phunk supply" );
3035         uint newTokenID = _tokenIds.current();
3036         for(uint256 i; i < _amount; i++){
3037             _safeMint(_to, newTokenID);
3038             _tokenIds.increment();
3039         }
3040 
3041         RESERVED_MINTS += _amount;
3042     }
3043 
3044     function pause(bool _state) public onlyOwner {
3045         paused = _state;
3046     }
3047 
3048   function totalSupply() external view returns(uint256) {
3049         return _tokenIds.current() ;
3050     }
3051 
3052 }