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
816 // File: erc721a/contracts/ERC721A.sol
817 
818 
819 // Creator: Chiru Labs
820 
821 pragma solidity ^0.8.4;
822 
823 
824 
825 
826 
827 
828 
829 
830 error ApprovalCallerNotOwnerNorApproved();
831 error ApprovalQueryForNonexistentToken();
832 error ApproveToCaller();
833 error ApprovalToCurrentOwner();
834 error BalanceQueryForZeroAddress();
835 error MintToZeroAddress();
836 error MintZeroQuantity();
837 error OwnerQueryForNonexistentToken();
838 error TransferCallerNotOwnerNorApproved();
839 error TransferFromIncorrectOwner();
840 error TransferToNonERC721ReceiverImplementer();
841 error TransferToZeroAddress();
842 error URIQueryForNonexistentToken();
843 
844 /**
845  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
846  * the Metadata extension. Built to optimize for lower gas during batch mints.
847  *
848  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
849  *
850  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
851  *
852  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
853  */
854 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
855     using Address for address;
856     using Strings for uint256;
857 
858     // Compiler will pack this into a single 256bit word.
859     struct TokenOwnership {
860         // The address of the owner.
861         address addr;
862         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
863         uint64 startTimestamp;
864         // Whether the token has been burned.
865         bool burned;
866     }
867 
868     // Compiler will pack this into a single 256bit word.
869     struct AddressData {
870         // Realistically, 2**64-1 is more than enough.
871         uint64 balance;
872         // Keeps track of mint count with minimal overhead for tokenomics.
873         uint64 numberMinted;
874         // Keeps track of burn count with minimal overhead for tokenomics.
875         uint64 numberBurned;
876         // For miscellaneous variable(s) pertaining to the address
877         // (e.g. number of whitelist mint slots used).
878         // If there are multiple variables, please pack them into a uint64.
879         uint64 aux;
880     }
881 
882     // The tokenId of the next token to be minted.
883     uint256 internal _currentIndex;
884 
885     // The number of tokens burned.
886     uint256 internal _burnCounter;
887 
888     // Token name
889     string private _name;
890 
891     // Token symbol
892     string private _symbol;
893 
894     // Mapping from token ID to ownership details
895     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
896     mapping(uint256 => TokenOwnership) internal _ownerships;
897 
898     // Mapping owner address to address data
899     mapping(address => AddressData) private _addressData;
900 
901     // Mapping from token ID to approved address
902     mapping(uint256 => address) private _tokenApprovals;
903 
904     // Mapping from owner to operator approvals
905     mapping(address => mapping(address => bool)) private _operatorApprovals;
906 
907     constructor(string memory name_, string memory symbol_) {
908         _name = name_;
909         _symbol = symbol_;
910         _currentIndex = _startTokenId();
911     }
912 
913     /**
914      * To change the starting tokenId, please override this function.
915      */
916     function _startTokenId() internal view virtual returns (uint256) {
917         return 0;
918     }
919 
920     /**
921      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
922      */
923     function totalSupply() public view returns (uint256) {
924         // Counter underflow is impossible as _burnCounter cannot be incremented
925         // more than _currentIndex - _startTokenId() times
926         unchecked {
927             return _currentIndex - _burnCounter - _startTokenId();
928         }
929     }
930 
931     /**
932      * Returns the total amount of tokens minted in the contract.
933      */
934     function _totalMinted() internal view returns (uint256) {
935         // Counter underflow is impossible as _currentIndex does not decrement,
936         // and it is initialized to _startTokenId()
937         unchecked {
938             return _currentIndex - _startTokenId();
939         }
940     }
941 
942     /**
943      * @dev See {IERC165-supportsInterface}.
944      */
945     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
946         return
947             interfaceId == type(IERC721).interfaceId ||
948             interfaceId == type(IERC721Metadata).interfaceId ||
949             super.supportsInterface(interfaceId);
950     }
951 
952     /**
953      * @dev See {IERC721-balanceOf}.
954      */
955     function balanceOf(address owner) public view override returns (uint256) {
956         if (owner == address(0)) revert BalanceQueryForZeroAddress();
957         return uint256(_addressData[owner].balance);
958     }
959 
960     /**
961      * Returns the number of tokens minted by `owner`.
962      */
963     function _numberMinted(address owner) internal view returns (uint256) {
964         return uint256(_addressData[owner].numberMinted);
965     }
966 
967     /**
968      * Returns the number of tokens burned by or on behalf of `owner`.
969      */
970     function _numberBurned(address owner) internal view returns (uint256) {
971         return uint256(_addressData[owner].numberBurned);
972     }
973 
974     /**
975      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
976      */
977     function _getAux(address owner) internal view returns (uint64) {
978         return _addressData[owner].aux;
979     }
980 
981     /**
982      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
983      * If there are multiple variables, please pack them into a uint64.
984      */
985     function _setAux(address owner, uint64 aux) internal {
986         _addressData[owner].aux = aux;
987     }
988 
989     /**
990      * Gas spent here starts off proportional to the maximum mint batch size.
991      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
992      */
993     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
994         uint256 curr = tokenId;
995 
996         unchecked {
997             if (_startTokenId() <= curr && curr < _currentIndex) {
998                 TokenOwnership memory ownership = _ownerships[curr];
999                 if (!ownership.burned) {
1000                     if (ownership.addr != address(0)) {
1001                         return ownership;
1002                     }
1003                     // Invariant:
1004                     // There will always be an ownership that has an address and is not burned
1005                     // before an ownership that does not have an address and is not burned.
1006                     // Hence, curr will not underflow.
1007                     while (true) {
1008                         curr--;
1009                         ownership = _ownerships[curr];
1010                         if (ownership.addr != address(0)) {
1011                             return ownership;
1012                         }
1013                     }
1014                 }
1015             }
1016         }
1017         revert OwnerQueryForNonexistentToken();
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-ownerOf}.
1022      */
1023     function ownerOf(uint256 tokenId) public view override returns (address) {
1024         return _ownershipOf(tokenId).addr;
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Metadata-name}.
1029      */
1030     function name() public view virtual override returns (string memory) {
1031         return _name;
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Metadata-symbol}.
1036      */
1037     function symbol() public view virtual override returns (string memory) {
1038         return _symbol;
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Metadata-tokenURI}.
1043      */
1044     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1045         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1046 
1047         string memory baseURI = _baseURI();
1048         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1049     }
1050 
1051     /**
1052      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1053      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1054      * by default, can be overriden in child contracts.
1055      */
1056     function _baseURI() internal view virtual returns (string memory) {
1057         return '';
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-approve}.
1062      */
1063     function approve(address to, uint256 tokenId) public override {
1064         address owner = ERC721A.ownerOf(tokenId);
1065         if (to == owner) revert ApprovalToCurrentOwner();
1066 
1067         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1068             revert ApprovalCallerNotOwnerNorApproved();
1069         }
1070 
1071         _approve(to, tokenId, owner);
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-getApproved}.
1076      */
1077     function getApproved(uint256 tokenId) public view override returns (address) {
1078         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1079 
1080         return _tokenApprovals[tokenId];
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-setApprovalForAll}.
1085      */
1086     function setApprovalForAll(address operator, bool approved) public virtual override {
1087         if (operator == _msgSender()) revert ApproveToCaller();
1088 
1089         _operatorApprovals[_msgSender()][operator] = approved;
1090         emit ApprovalForAll(_msgSender(), operator, approved);
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-isApprovedForAll}.
1095      */
1096     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1097         return _operatorApprovals[owner][operator];
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-transferFrom}.
1102      */
1103     function transferFrom(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) public virtual override {
1108         _transfer(from, to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-safeTransferFrom}.
1113      */
1114     function safeTransferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) public virtual override {
1119         safeTransferFrom(from, to, tokenId, '');
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-safeTransferFrom}.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes memory _data
1130     ) public virtual override {
1131         _transfer(from, to, tokenId);
1132         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1133             revert TransferToNonERC721ReceiverImplementer();
1134         }
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
1145         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
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
1186         uint256 startTokenId = _currentIndex;
1187         if (to == address(0)) revert MintToZeroAddress();
1188         if (quantity == 0) revert MintZeroQuantity();
1189 
1190         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1191 
1192         // Overflows are incredibly unrealistic.
1193         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1194         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1195         unchecked {
1196             _addressData[to].balance += uint64(quantity);
1197             _addressData[to].numberMinted += uint64(quantity);
1198 
1199             _ownerships[startTokenId].addr = to;
1200             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1201 
1202             uint256 updatedIndex = startTokenId;
1203             uint256 end = updatedIndex + quantity;
1204 
1205             if (safe && to.isContract()) {
1206                 do {
1207                     emit Transfer(address(0), to, updatedIndex);
1208                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1209                         revert TransferToNonERC721ReceiverImplementer();
1210                     }
1211                 } while (updatedIndex != end);
1212                 // Reentrancy protection
1213                 if (_currentIndex != startTokenId) revert();
1214             } else {
1215                 do {
1216                     emit Transfer(address(0), to, updatedIndex++);
1217                 } while (updatedIndex != end);
1218             }
1219             _currentIndex = updatedIndex;
1220         }
1221         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1222     }
1223 
1224     /**
1225      * @dev Transfers `tokenId` from `from` to `to`.
1226      *
1227      * Requirements:
1228      *
1229      * - `to` cannot be the zero address.
1230      * - `tokenId` token must be owned by `from`.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _transfer(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) private {
1239         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1240 
1241         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1242 
1243         bool isApprovedOrOwner = (_msgSender() == from ||
1244             isApprovedForAll(from, _msgSender()) ||
1245             getApproved(tokenId) == _msgSender());
1246 
1247         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1248         if (to == address(0)) revert TransferToZeroAddress();
1249 
1250         _beforeTokenTransfers(from, to, tokenId, 1);
1251 
1252         // Clear approvals from the previous owner
1253         _approve(address(0), tokenId, from);
1254 
1255         // Underflow of the sender's balance is impossible because we check for
1256         // ownership above and the recipient's balance can't realistically overflow.
1257         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1258         unchecked {
1259             _addressData[from].balance -= 1;
1260             _addressData[to].balance += 1;
1261 
1262             TokenOwnership storage currSlot = _ownerships[tokenId];
1263             currSlot.addr = to;
1264             currSlot.startTimestamp = uint64(block.timestamp);
1265 
1266             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1267             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1268             uint256 nextTokenId = tokenId + 1;
1269             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1270             if (nextSlot.addr == address(0)) {
1271                 // This will suffice for checking _exists(nextTokenId),
1272                 // as a burned slot cannot contain the zero address.
1273                 if (nextTokenId != _currentIndex) {
1274                     nextSlot.addr = from;
1275                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1276                 }
1277             }
1278         }
1279 
1280         emit Transfer(from, to, tokenId);
1281         _afterTokenTransfers(from, to, tokenId, 1);
1282     }
1283 
1284     /**
1285      * @dev This is equivalent to _burn(tokenId, false)
1286      */
1287     function _burn(uint256 tokenId) internal virtual {
1288         _burn(tokenId, false);
1289     }
1290 
1291     /**
1292      * @dev Destroys `tokenId`.
1293      * The approval is cleared when the token is burned.
1294      *
1295      * Requirements:
1296      *
1297      * - `tokenId` must exist.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1302         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1303 
1304         address from = prevOwnership.addr;
1305 
1306         if (approvalCheck) {
1307             bool isApprovedOrOwner = (_msgSender() == from ||
1308                 isApprovedForAll(from, _msgSender()) ||
1309                 getApproved(tokenId) == _msgSender());
1310 
1311             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1312         }
1313 
1314         _beforeTokenTransfers(from, address(0), tokenId, 1);
1315 
1316         // Clear approvals from the previous owner
1317         _approve(address(0), tokenId, from);
1318 
1319         // Underflow of the sender's balance is impossible because we check for
1320         // ownership above and the recipient's balance can't realistically overflow.
1321         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1322         unchecked {
1323             AddressData storage addressData = _addressData[from];
1324             addressData.balance -= 1;
1325             addressData.numberBurned += 1;
1326 
1327             // Keep track of who burned the token, and the timestamp of burning.
1328             TokenOwnership storage currSlot = _ownerships[tokenId];
1329             currSlot.addr = from;
1330             currSlot.startTimestamp = uint64(block.timestamp);
1331             currSlot.burned = true;
1332 
1333             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1334             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1335             uint256 nextTokenId = tokenId + 1;
1336             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1337             if (nextSlot.addr == address(0)) {
1338                 // This will suffice for checking _exists(nextTokenId),
1339                 // as a burned slot cannot contain the zero address.
1340                 if (nextTokenId != _currentIndex) {
1341                     nextSlot.addr = from;
1342                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1343                 }
1344             }
1345         }
1346 
1347         emit Transfer(from, address(0), tokenId);
1348         _afterTokenTransfers(from, address(0), tokenId, 1);
1349 
1350         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1351         unchecked {
1352             _burnCounter++;
1353         }
1354     }
1355 
1356     /**
1357      * @dev Approve `to` to operate on `tokenId`
1358      *
1359      * Emits a {Approval} event.
1360      */
1361     function _approve(
1362         address to,
1363         uint256 tokenId,
1364         address owner
1365     ) private {
1366         _tokenApprovals[tokenId] = to;
1367         emit Approval(owner, to, tokenId);
1368     }
1369 
1370     /**
1371      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1372      *
1373      * @param from address representing the previous owner of the given token ID
1374      * @param to target address that will receive the tokens
1375      * @param tokenId uint256 ID of the token to be transferred
1376      * @param _data bytes optional data to send along with the call
1377      * @return bool whether the call correctly returned the expected magic value
1378      */
1379     function _checkContractOnERC721Received(
1380         address from,
1381         address to,
1382         uint256 tokenId,
1383         bytes memory _data
1384     ) private returns (bool) {
1385         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1386             return retval == IERC721Receiver(to).onERC721Received.selector;
1387         } catch (bytes memory reason) {
1388             if (reason.length == 0) {
1389                 revert TransferToNonERC721ReceiverImplementer();
1390             } else {
1391                 assembly {
1392                     revert(add(32, reason), mload(reason))
1393                 }
1394             }
1395         }
1396     }
1397 
1398     /**
1399      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1400      * And also called before burning one token.
1401      *
1402      * startTokenId - the first token id to be transferred
1403      * quantity - the amount to be transferred
1404      *
1405      * Calling conditions:
1406      *
1407      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1408      * transferred to `to`.
1409      * - When `from` is zero, `tokenId` will be minted for `to`.
1410      * - When `to` is zero, `tokenId` will be burned by `from`.
1411      * - `from` and `to` are never both zero.
1412      */
1413     function _beforeTokenTransfers(
1414         address from,
1415         address to,
1416         uint256 startTokenId,
1417         uint256 quantity
1418     ) internal virtual {}
1419 
1420     /**
1421      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1422      * minting.
1423      * And also called after one token has been burned.
1424      *
1425      * startTokenId - the first token id to be transferred
1426      * quantity - the amount to be transferred
1427      *
1428      * Calling conditions:
1429      *
1430      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1431      * transferred to `to`.
1432      * - When `from` is zero, `tokenId` has been minted for `to`.
1433      * - When `to` is zero, `tokenId` has been burned by `from`.
1434      * - `from` and `to` are never both zero.
1435      */
1436     function _afterTokenTransfers(
1437         address from,
1438         address to,
1439         uint256 startTokenId,
1440         uint256 quantity
1441     ) internal virtual {}
1442 }
1443 
1444 // File: @openzeppelin/contracts/security/Pausable.sol
1445 
1446 
1447 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1448 
1449 pragma solidity ^0.8.0;
1450 
1451 
1452 /**
1453  * @dev Contract module which allows children to implement an emergency stop
1454  * mechanism that can be triggered by an authorized account.
1455  *
1456  * This module is used through inheritance. It will make available the
1457  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1458  * the functions of your contract. Note that they will not be pausable by
1459  * simply including this module, only once the modifiers are put in place.
1460  */
1461 abstract contract Pausable is Context {
1462     /**
1463      * @dev Emitted when the pause is triggered by `account`.
1464      */
1465     event Paused(address account);
1466 
1467     /**
1468      * @dev Emitted when the pause is lifted by `account`.
1469      */
1470     event Unpaused(address account);
1471 
1472     bool private _paused;
1473 
1474     /**
1475      * @dev Initializes the contract in unpaused state.
1476      */
1477     constructor() {
1478         _paused = false;
1479     }
1480 
1481     /**
1482      * @dev Returns true if the contract is paused, and false otherwise.
1483      */
1484     function paused() public view virtual returns (bool) {
1485         return _paused;
1486     }
1487 
1488     /**
1489      * @dev Modifier to make a function callable only when the contract is not paused.
1490      *
1491      * Requirements:
1492      *
1493      * - The contract must not be paused.
1494      */
1495     modifier whenNotPaused() {
1496         require(!paused(), "Pausable: paused");
1497         _;
1498     }
1499 
1500     /**
1501      * @dev Modifier to make a function callable only when the contract is paused.
1502      *
1503      * Requirements:
1504      *
1505      * - The contract must be paused.
1506      */
1507     modifier whenPaused() {
1508         require(paused(), "Pausable: not paused");
1509         _;
1510     }
1511 
1512     /**
1513      * @dev Triggers stopped state.
1514      *
1515      * Requirements:
1516      *
1517      * - The contract must not be paused.
1518      */
1519     function _pause() internal virtual whenNotPaused {
1520         _paused = true;
1521         emit Paused(_msgSender());
1522     }
1523 
1524     /**
1525      * @dev Returns to normal state.
1526      *
1527      * Requirements:
1528      *
1529      * - The contract must be paused.
1530      */
1531     function _unpause() internal virtual whenPaused {
1532         _paused = false;
1533         emit Unpaused(_msgSender());
1534     }
1535 }
1536 
1537 // File: @openzeppelin/contracts/access/Ownable.sol
1538 
1539 
1540 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1541 
1542 pragma solidity ^0.8.0;
1543 
1544 
1545 /**
1546  * @dev Contract module which provides a basic access control mechanism, where
1547  * there is an account (an owner) that can be granted exclusive access to
1548  * specific functions.
1549  *
1550  * By default, the owner account will be the one that deploys the contract. This
1551  * can later be changed with {transferOwnership}.
1552  *
1553  * This module is used through inheritance. It will make available the modifier
1554  * `onlyOwner`, which can be applied to your functions to restrict their use to
1555  * the owner.
1556  */
1557 abstract contract Ownable is Context {
1558     address private _owner;
1559 
1560     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1561 
1562     /**
1563      * @dev Initializes the contract setting the deployer as the initial owner.
1564      */
1565     constructor() {
1566         _transferOwnership(_msgSender());
1567     }
1568 
1569     /**
1570      * @dev Returns the address of the current owner.
1571      */
1572     function owner() public view virtual returns (address) {
1573         return _owner;
1574     }
1575 
1576     /**
1577      * @dev Throws if called by any account other than the owner.
1578      */
1579     modifier onlyOwner() {
1580         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1581         _;
1582     }
1583 
1584     /**
1585      * @dev Leaves the contract without owner. It will not be possible to call
1586      * `onlyOwner` functions anymore. Can only be called by the current owner.
1587      *
1588      * NOTE: Renouncing ownership will leave the contract without an owner,
1589      * thereby removing any functionality that is only available to the owner.
1590      */
1591     function renounceOwnership() public virtual onlyOwner {
1592         _transferOwnership(address(0));
1593     }
1594 
1595     /**
1596      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1597      * Can only be called by the current owner.
1598      */
1599     function transferOwnership(address newOwner) public virtual onlyOwner {
1600         require(newOwner != address(0), "Ownable: new owner is the zero address");
1601         _transferOwnership(newOwner);
1602     }
1603 
1604     /**
1605      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1606      * Internal function without access restriction.
1607      */
1608     function _transferOwnership(address newOwner) internal virtual {
1609         address oldOwner = _owner;
1610         _owner = newOwner;
1611         emit OwnershipTransferred(oldOwner, newOwner);
1612     }
1613 }
1614 
1615 // File: HarrysContract.sol
1616 
1617 //SPDX-License-Identifier: MIT
1618 pragma solidity ^0.8.11;
1619 
1620 
1621 
1622 
1623 
1624 contract HarrysContract is ERC721A, Ownable, Pausable {
1625     using SafeMath for uint256;
1626 
1627     event PermanentURI(string _value, uint256 indexed _id);
1628     mapping(address => uint) private _mintings;
1629 
1630     uint public constant MAX_SUPPLY = 555;
1631     uint public constant PRICE = 1e15; //0.005 ETH
1632     uint public constant MAX_PER_MINT = 5;
1633     uint public constant MAX_PER_WALLET = 15;
1634 
1635     string public _contractBaseURI= "https://gateway.pinata.cloud/ipfs/QmVvU8tXUGsWBwY1KWBPN4cSjRxTLF5NLj6YeUYH6euq9R/";
1636     
1637     
1638     constructor() ERC721A("Harrys Hammer Club", "HARRYS") {
1639     }
1640     modifier callerIsUser(){
1641         require(tx.origin == msg.sender, "Harry's Hammer Club :: Cannot be called by a contract");
1642         _;
1643     }
1644 
1645     function mint(uint256 quantity) external payable callerIsUser {
1646         require(quantity > 0, "Harry's Hammer Club :: Quantity cannot be zero");
1647         uint totalMinted = totalSupply();
1648         require(quantity <= MAX_PER_MINT, "Harry's Hammer Club :: Cannot mint that many at once");
1649         require((mintedBy(msg.sender) + quantity) <= MAX_PER_WALLET, "Harry's Hammer Club :: The limit of minting per address is exceeded");
1650         require(totalMinted.add(quantity) < MAX_SUPPLY, "Harry's Hammer Club :: Not enough NFTs left to mint");
1651         require(PRICE * quantity <= msg.value, "Harry's Hammer Club :: Insufficient funds sent");
1652 
1653         _safeMint(msg.sender, quantity);
1654         lockMetadata(quantity);
1655         _mintings[msg.sender] += quantity;
1656     }
1657 
1658     function mintedBy(address addr) public view returns(uint) {
1659         return _mintings[addr];
1660     }
1661 
1662     function lockMetadata(uint256 quantity) internal {
1663         for (uint256 i = quantity; i > 0; i--) {
1664             uint256 tid = totalSupply() - i;
1665             emit PermanentURI(tokenURI(tid), tid);
1666         }
1667     }
1668 
1669     function withdraw() public onlyOwner {
1670         uint balance = address(this).balance;
1671 
1672         payable(msg.sender).transfer(balance);
1673     }
1674 
1675     // OpenSea metadata initialization
1676     function contractURI() public pure returns (string memory) {
1677         return "";
1678     }
1679 
1680     function _baseURI() internal view override returns (string memory) {
1681         return _contractBaseURI;
1682     }
1683 
1684 }