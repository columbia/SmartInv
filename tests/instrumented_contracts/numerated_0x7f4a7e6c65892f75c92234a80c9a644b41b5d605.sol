1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Strings.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev String operations.
240  */
241 library Strings {
242     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
243 
244     /**
245      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
246      */
247     function toString(uint256 value) internal pure returns (string memory) {
248         // Inspired by OraclizeAPI's implementation - MIT licence
249         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
250 
251         if (value == 0) {
252             return "0";
253         }
254         uint256 temp = value;
255         uint256 digits;
256         while (temp != 0) {
257             digits++;
258             temp /= 10;
259         }
260         bytes memory buffer = new bytes(digits);
261         while (value != 0) {
262             digits -= 1;
263             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
264             value /= 10;
265         }
266         return string(buffer);
267     }
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
271      */
272     function toHexString(uint256 value) internal pure returns (string memory) {
273         if (value == 0) {
274             return "0x00";
275         }
276         uint256 temp = value;
277         uint256 length = 0;
278         while (temp != 0) {
279             length++;
280             temp >>= 8;
281         }
282         return toHexString(value, length);
283     }
284 
285     /**
286      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
287      */
288     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
289         bytes memory buffer = new bytes(2 * length + 2);
290         buffer[0] = "0";
291         buffer[1] = "x";
292         for (uint256 i = 2 * length + 1; i > 1; --i) {
293             buffer[i] = _HEX_SYMBOLS[value & 0xf];
294             value >>= 4;
295         }
296         require(value == 0, "Strings: hex length insufficient");
297         return string(buffer);
298     }
299 }
300 
301 // File: @openzeppelin/contracts/utils/Address.sol
302 
303 
304 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
305 
306 pragma solidity ^0.8.1;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      *
329      * [IMPORTANT]
330      * ====
331      * You shouldn't rely on `isContract` to protect against flash loan attacks!
332      *
333      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
334      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
335      * constructor.
336      * ====
337      */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies on extcodesize/address.code.length, which returns 0
340         // for contracts in construction, since the code is only stored at the end
341         // of the constructor execution.
342 
343         return account.code.length > 0;
344     }
345 
346     /**
347      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
348      * `recipient`, forwarding all available gas and reverting on errors.
349      *
350      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
351      * of certain opcodes, possibly making contracts go over the 2300 gas limit
352      * imposed by `transfer`, making them unable to receive funds via
353      * `transfer`. {sendValue} removes this limitation.
354      *
355      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
356      *
357      * IMPORTANT: because control is transferred to `recipient`, care must be
358      * taken to not create reentrancy vulnerabilities. Consider using
359      * {ReentrancyGuard} or the
360      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
361      */
362     function sendValue(address payable recipient, uint256 amount) internal {
363         require(address(this).balance >= amount, "Address: insufficient balance");
364 
365         (bool success, ) = recipient.call{value: amount}("");
366         require(success, "Address: unable to send value, recipient may have reverted");
367     }
368 
369     /**
370      * @dev Performs a Solidity function call using a low level `call`. A
371      * plain `call` is an unsafe replacement for a function call: use this
372      * function instead.
373      *
374      * If `target` reverts with a revert reason, it is bubbled up by this
375      * function (like regular Solidity function calls).
376      *
377      * Returns the raw returned data. To convert to the expected return value,
378      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
379      *
380      * Requirements:
381      *
382      * - `target` must be a contract.
383      * - calling `target` with `data` must not revert.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionCall(target, data, "Address: low-level call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
393      * `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, 0, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but also transferring `value` wei to `target`.
408      *
409      * Requirements:
410      *
411      * - the calling contract must have an ETH balance of at least `value`.
412      * - the called Solidity function must be `payable`.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         require(isContract(target), "Address: call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.call{value: value}(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
450         return functionStaticCall(target, data, "Address: low-level static call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal view returns (bytes memory) {
464         require(isContract(target), "Address: static call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.staticcall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
477         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(isContract(target), "Address: delegate call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
499      * revert reason using the provided one.
500      *
501      * _Available since v4.3._
502      */
503     function verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) internal pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @title ERC721 token receiver interface
535  * @dev Interface for any contract that wants to support safeTransfers
536  * from ERC721 asset contracts.
537  */
538 interface IERC721Receiver {
539     /**
540      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
541      * by `operator` from `from`, this function is called.
542      *
543      * It must return its Solidity selector to confirm the token transfer.
544      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
545      *
546      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
547      */
548     function onERC721Received(
549         address operator,
550         address from,
551         uint256 tokenId,
552         bytes calldata data
553     ) external returns (bytes4);
554 }
555 
556 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev Interface of the ERC165 standard, as defined in the
565  * https://eips.ethereum.org/EIPS/eip-165[EIP].
566  *
567  * Implementers can declare support of contract interfaces, which can then be
568  * queried by others ({ERC165Checker}).
569  *
570  * For an implementation, see {ERC165}.
571  */
572 interface IERC165 {
573     /**
574      * @dev Returns true if this contract implements the interface defined by
575      * `interfaceId`. See the corresponding
576      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
577      * to learn more about how these ids are created.
578      *
579      * This function call must use less than 30 000 gas.
580      */
581     function supportsInterface(bytes4 interfaceId) external view returns (bool);
582 }
583 
584 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Implementation of the {IERC165} interface.
594  *
595  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
596  * for the additional interface id that will be supported. For example:
597  *
598  * ```solidity
599  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
601  * }
602  * ```
603  *
604  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
605  */
606 abstract contract ERC165 is IERC165 {
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
611         return interfaceId == type(IERC165).interfaceId;
612     }
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 
623 /**
624  * @dev Required interface of an ERC721 compliant contract.
625  */
626 interface IERC721 is IERC165 {
627     /**
628      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
629      */
630     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
631 
632     /**
633      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
634      */
635     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
636 
637     /**
638      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
639      */
640     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
641 
642     /**
643      * @dev Returns the number of tokens in ``owner``'s account.
644      */
645     function balanceOf(address owner) external view returns (uint256 balance);
646 
647     /**
648      * @dev Returns the owner of the `tokenId` token.
649      *
650      * Requirements:
651      *
652      * - `tokenId` must exist.
653      */
654     function ownerOf(uint256 tokenId) external view returns (address owner);
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
658      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must exist and be owned by `from`.
665      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
666      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
667      *
668      * Emits a {Transfer} event.
669      */
670     function safeTransferFrom(
671         address from,
672         address to,
673         uint256 tokenId
674     ) external;
675 
676     /**
677      * @dev Transfers `tokenId` token from `from` to `to`.
678      *
679      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      *
688      * Emits a {Transfer} event.
689      */
690     function transferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) external;
695 
696     /**
697      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
698      * The approval is cleared when the token is transferred.
699      *
700      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
701      *
702      * Requirements:
703      *
704      * - The caller must own the token or be an approved operator.
705      * - `tokenId` must exist.
706      *
707      * Emits an {Approval} event.
708      */
709     function approve(address to, uint256 tokenId) external;
710 
711     /**
712      * @dev Returns the account approved for `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function getApproved(uint256 tokenId) external view returns (address operator);
719 
720     /**
721      * @dev Approve or remove `operator` as an operator for the caller.
722      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
723      *
724      * Requirements:
725      *
726      * - The `operator` cannot be the caller.
727      *
728      * Emits an {ApprovalForAll} event.
729      */
730     function setApprovalForAll(address operator, bool _approved) external;
731 
732     /**
733      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
734      *
735      * See {setApprovalForAll}
736      */
737     function isApprovedForAll(address owner, address operator) external view returns (bool);
738 
739     /**
740      * @dev Safely transfers `tokenId` token from `from` to `to`.
741      *
742      * Requirements:
743      *
744      * - `from` cannot be the zero address.
745      * - `to` cannot be the zero address.
746      * - `tokenId` token must exist and be owned by `from`.
747      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
748      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
749      *
750      * Emits a {Transfer} event.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes calldata data
757     ) external;
758 }
759 
760 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
761 
762 
763 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
770  * @dev See https://eips.ethereum.org/EIPS/eip-721
771  */
772 interface IERC721Enumerable is IERC721 {
773     /**
774      * @dev Returns the total amount of tokens stored by the contract.
775      */
776     function totalSupply() external view returns (uint256);
777 
778     /**
779      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
780      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
781      */
782     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
783 
784     /**
785      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
786      * Use along with {totalSupply} to enumerate all tokens.
787      */
788     function tokenByIndex(uint256 index) external view returns (uint256);
789 }
790 
791 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
792 
793 
794 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
795 
796 pragma solidity ^0.8.0;
797 
798 
799 /**
800  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
801  * @dev See https://eips.ethereum.org/EIPS/eip-721
802  */
803 interface IERC721Metadata is IERC721 {
804     /**
805      * @dev Returns the token collection name.
806      */
807     function name() external view returns (string memory);
808 
809     /**
810      * @dev Returns the token collection symbol.
811      */
812     function symbol() external view returns (string memory);
813 
814     /**
815      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
816      */
817     function tokenURI(uint256 tokenId) external view returns (string memory);
818 }
819 
820 // File: @openzeppelin/contracts/utils/Context.sol
821 
822 
823 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 /**
828  * @dev Provides information about the current execution context, including the
829  * sender of the transaction and its data. While these are generally available
830  * via msg.sender and msg.data, they should not be accessed in such a direct
831  * manner, since when dealing with meta-transactions the account sending and
832  * paying for execution may not be the actual sender (as far as an application
833  * is concerned).
834  *
835  * This contract is only required for intermediate, library-like contracts.
836  */
837 abstract contract Context {
838     function _msgSender() internal view virtual returns (address) {
839         return msg.sender;
840     }
841 
842     function _msgData() internal view virtual returns (bytes calldata) {
843         return msg.data;
844     }
845 }
846 
847 // File: @openzeppelin/contracts/access/Ownable.sol
848 
849 
850 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
851 
852 pragma solidity ^0.8.0;
853 
854 
855 /**
856  * @dev Contract module which provides a basic access control mechanism, where
857  * there is an account (an owner) that can be granted exclusive access to
858  * specific functions.
859  *
860  * By default, the owner account will be the one that deploys the contract. This
861  * can later be changed with {transferOwnership}.
862  *
863  * This module is used through inheritance. It will make available the modifier
864  * `onlyOwner`, which can be applied to your functions to restrict their use to
865  * the owner.
866  */
867 abstract contract Ownable is Context {
868     address private _owner;
869 
870     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
871 
872     /**
873      * @dev Initializes the contract setting the deployer as the initial owner.
874      */
875     constructor() {
876         _transferOwnership(_msgSender());
877     }
878 
879     /**
880      * @dev Returns the address of the current owner.
881      */
882     function owner() public view virtual returns (address) {
883         return _owner;
884     }
885 
886     /**
887      * @dev Throws if called by any account other than the owner.
888      */
889     modifier onlyOwner() {
890         require(owner() == _msgSender(), "Ownable: caller is not the owner");
891         _;
892     }
893 
894     /**
895      * @dev Leaves the contract without owner. It will not be possible to call
896      * `onlyOwner` functions anymore. Can only be called by the current owner.
897      *
898      * NOTE: Renouncing ownership will leave the contract without an owner,
899      * thereby removing any functionality that is only available to the owner.
900      */
901     function renounceOwnership() public virtual onlyOwner {
902         _transferOwnership(address(0));
903     }
904 
905     /**
906      * @dev Transfers ownership of the contract to a new account (`newOwner`).
907      * Can only be called by the current owner.
908      */
909     function transferOwnership(address newOwner) public virtual onlyOwner {
910         require(newOwner != address(0), "Ownable: new owner is the zero address");
911         _transferOwnership(newOwner);
912     }
913 
914     /**
915      * @dev Transfers ownership of the contract to a new account (`newOwner`).
916      * Internal function without access restriction.
917      */
918     function _transferOwnership(address newOwner) internal virtual {
919         address oldOwner = _owner;
920         _owner = newOwner;
921         emit OwnershipTransferred(oldOwner, newOwner);
922     }
923 }
924 
925 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
926 
927 
928 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
929 
930 pragma solidity ^0.8.0;
931 
932 
933 
934 
935 
936 
937 
938 
939 /**
940  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
941  * the Metadata extension, but not including the Enumerable extension, which is available separately as
942  * {ERC721Enumerable}.
943  */
944 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
945     using Address for address;
946     using Strings for uint256;
947 
948     // Token name
949     string private _name;
950 
951     // Token symbol
952     string private _symbol;
953 
954     // Mapping from token ID to owner address
955     mapping(uint256 => address) private _owners;
956 
957     // Mapping owner address to token count
958     mapping(address => uint256) private _balances;
959 
960     // Mapping from token ID to approved address
961     mapping(uint256 => address) private _tokenApprovals;
962 
963     // Mapping from owner to operator approvals
964     mapping(address => mapping(address => bool)) private _operatorApprovals;
965 
966     /**
967      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
968      */
969     constructor(string memory name_, string memory symbol_) {
970         _name = name_;
971         _symbol = symbol_;
972     }
973 
974     /**
975      * @dev See {IERC165-supportsInterface}.
976      */
977     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
978         return
979             interfaceId == type(IERC721).interfaceId ||
980             interfaceId == type(IERC721Metadata).interfaceId ||
981             super.supportsInterface(interfaceId);
982     }
983 
984     /**
985      * @dev See {IERC721-balanceOf}.
986      */
987     function balanceOf(address owner) public view virtual override returns (uint256) {
988         require(owner != address(0), "ERC721: balance query for the zero address");
989         return _balances[owner];
990     }
991 
992     /**
993      * @dev See {IERC721-ownerOf}.
994      */
995     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
996         address owner = _owners[tokenId];
997         require(owner != address(0), "ERC721: owner query for nonexistent token");
998         return owner;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-name}.
1003      */
1004     function name() public view virtual override returns (string memory) {
1005         return _name;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Metadata-symbol}.
1010      */
1011     function symbol() public view virtual override returns (string memory) {
1012         return _symbol;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-tokenURI}.
1017      */
1018     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1019         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1020 
1021         string memory baseURI = _baseURI();
1022         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1023     }
1024 
1025     /**
1026      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1027      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1028      * by default, can be overriden in child contracts.
1029      */
1030     function _baseURI() internal view virtual returns (string memory) {
1031         return "";
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-approve}.
1036      */
1037     function approve(address to, uint256 tokenId) public virtual override {
1038         address owner = ERC721.ownerOf(tokenId);
1039         require(to != owner, "ERC721: approval to current owner");
1040 
1041         require(
1042             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1043             "ERC721: approve caller is not owner nor approved for all"
1044         );
1045 
1046         _approve(to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-getApproved}.
1051      */
1052     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1053         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1054 
1055         return _tokenApprovals[tokenId];
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-setApprovalForAll}.
1060      */
1061     function setApprovalForAll(address operator, bool approved) public virtual override {
1062         _setApprovalForAll(_msgSender(), operator, approved);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-isApprovedForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         //solhint-disable-next-line max-line-length
1081         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1082 
1083         _transfer(from, to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-safeTransferFrom}.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) public virtual override {
1094         safeTransferFrom(from, to, tokenId, "");
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-safeTransferFrom}.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) public virtual override {
1106         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1107         _safeTransfer(from, to, tokenId, _data);
1108     }
1109 
1110     /**
1111      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1112      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1113      *
1114      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1115      *
1116      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1117      * implement alternative mechanisms to perform token transfer, such as signature-based.
1118      *
1119      * Requirements:
1120      *
1121      * - `from` cannot be the zero address.
1122      * - `to` cannot be the zero address.
1123      * - `tokenId` token must exist and be owned by `from`.
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _safeTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) internal virtual {
1134         _transfer(from, to, tokenId);
1135         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1136     }
1137 
1138     /**
1139      * @dev Returns whether `tokenId` exists.
1140      *
1141      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1142      *
1143      * Tokens start existing when they are minted (`_mint`),
1144      * and stop existing when they are burned (`_burn`).
1145      */
1146     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1147         return _owners[tokenId] != address(0);
1148     }
1149 
1150     /**
1151      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      */
1157     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1158         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1159         address owner = ERC721.ownerOf(tokenId);
1160         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1161     }
1162 
1163     /**
1164      * @dev Safely mints `tokenId` and transfers it to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must not exist.
1169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _safeMint(address to, uint256 tokenId) internal virtual {
1174         _safeMint(to, tokenId, "");
1175     }
1176 
1177     /**
1178      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1179      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1180      */
1181     function _safeMint(
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) internal virtual {
1186         _mint(to, tokenId);
1187         require(
1188             _checkOnERC721Received(address(0), to, tokenId, _data),
1189             "ERC721: transfer to non ERC721Receiver implementer"
1190         );
1191     }
1192 
1193     /**
1194      * @dev Mints `tokenId` and transfers it to `to`.
1195      *
1196      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must not exist.
1201      * - `to` cannot be the zero address.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _mint(address to, uint256 tokenId) internal virtual {
1206         require(to != address(0), "ERC721: mint to the zero address");
1207         require(!_exists(tokenId), "ERC721: token already minted");
1208 
1209         _beforeTokenTransfer(address(0), to, tokenId);
1210 
1211         _balances[to] += 1;
1212         _owners[tokenId] = to;
1213 
1214         emit Transfer(address(0), to, tokenId);
1215 
1216         _afterTokenTransfer(address(0), to, tokenId);
1217     }
1218 
1219     /**
1220      * @dev Destroys `tokenId`.
1221      * The approval is cleared when the token is burned.
1222      *
1223      * Requirements:
1224      *
1225      * - `tokenId` must exist.
1226      *
1227      * Emits a {Transfer} event.
1228      */
1229     function _burn(uint256 tokenId) internal virtual {
1230         address owner = ERC721.ownerOf(tokenId);
1231 
1232         _beforeTokenTransfer(owner, address(0), tokenId);
1233 
1234         // Clear approvals
1235         _approve(address(0), tokenId);
1236 
1237         _balances[owner] -= 1;
1238         delete _owners[tokenId];
1239 
1240         emit Transfer(owner, address(0), tokenId);
1241 
1242         _afterTokenTransfer(owner, address(0), tokenId);
1243     }
1244 
1245     /**
1246      * @dev Transfers `tokenId` from `from` to `to`.
1247      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1248      *
1249      * Requirements:
1250      *
1251      * - `to` cannot be the zero address.
1252      * - `tokenId` token must be owned by `from`.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _transfer(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) internal virtual {
1261         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1262         require(to != address(0), "ERC721: transfer to the zero address");
1263 
1264         _beforeTokenTransfer(from, to, tokenId);
1265 
1266         // Clear approvals from the previous owner
1267         _approve(address(0), tokenId);
1268 
1269         _balances[from] -= 1;
1270         _balances[to] += 1;
1271         _owners[tokenId] = to;
1272 
1273         emit Transfer(from, to, tokenId);
1274 
1275         _afterTokenTransfer(from, to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Approve `to` to operate on `tokenId`
1280      *
1281      * Emits a {Approval} event.
1282      */
1283     function _approve(address to, uint256 tokenId) internal virtual {
1284         _tokenApprovals[tokenId] = to;
1285         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev Approve `operator` to operate on all of `owner` tokens
1290      *
1291      * Emits a {ApprovalForAll} event.
1292      */
1293     function _setApprovalForAll(
1294         address owner,
1295         address operator,
1296         bool approved
1297     ) internal virtual {
1298         require(owner != operator, "ERC721: approve to caller");
1299         _operatorApprovals[owner][operator] = approved;
1300         emit ApprovalForAll(owner, operator, approved);
1301     }
1302 
1303     /**
1304      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1305      * The call is not executed if the target address is not a contract.
1306      *
1307      * @param from address representing the previous owner of the given token ID
1308      * @param to target address that will receive the tokens
1309      * @param tokenId uint256 ID of the token to be transferred
1310      * @param _data bytes optional data to send along with the call
1311      * @return bool whether the call correctly returned the expected magic value
1312      */
1313     function _checkOnERC721Received(
1314         address from,
1315         address to,
1316         uint256 tokenId,
1317         bytes memory _data
1318     ) private returns (bool) {
1319         if (to.isContract()) {
1320             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1321                 return retval == IERC721Receiver.onERC721Received.selector;
1322             } catch (bytes memory reason) {
1323                 if (reason.length == 0) {
1324                     revert("ERC721: transfer to non ERC721Receiver implementer");
1325                 } else {
1326                     assembly {
1327                         revert(add(32, reason), mload(reason))
1328                     }
1329                 }
1330             }
1331         } else {
1332             return true;
1333         }
1334     }
1335 
1336     /**
1337      * @dev Hook that is called before any token transfer. This includes minting
1338      * and burning.
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` will be minted for `to`.
1345      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1346      * - `from` and `to` are never both zero.
1347      *
1348      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1349      */
1350     function _beforeTokenTransfer(
1351         address from,
1352         address to,
1353         uint256 tokenId
1354     ) internal virtual {}
1355 
1356     /**
1357      * @dev Hook that is called after any transfer of tokens. This includes
1358      * minting and burning.
1359      *
1360      * Calling conditions:
1361      *
1362      * - when `from` and `to` are both non-zero.
1363      * - `from` and `to` are never both zero.
1364      *
1365      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1366      */
1367     function _afterTokenTransfer(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) internal virtual {}
1372 }
1373 
1374 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1375 
1376 
1377 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1378 
1379 pragma solidity ^0.8.0;
1380 
1381 
1382 /**
1383  * @dev ERC721 token with storage based token URI management.
1384  */
1385 abstract contract ERC721URIStorage is ERC721 {
1386     using Strings for uint256;
1387 
1388     // Optional mapping for token URIs
1389     mapping(uint256 => string) private _tokenURIs;
1390 
1391     /**
1392      * @dev See {IERC721Metadata-tokenURI}.
1393      */
1394     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1395         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1396 
1397         string memory _tokenURI = _tokenURIs[tokenId];
1398         string memory base = _baseURI();
1399 
1400         // If there is no base URI, return the token URI.
1401         if (bytes(base).length == 0) {
1402             return _tokenURI;
1403         }
1404         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1405         if (bytes(_tokenURI).length > 0) {
1406             return string(abi.encodePacked(base, _tokenURI));
1407         }
1408 
1409         return super.tokenURI(tokenId);
1410     }
1411 
1412     /**
1413      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1414      *
1415      * Requirements:
1416      *
1417      * - `tokenId` must exist.
1418      */
1419     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1420         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1421         _tokenURIs[tokenId] = _tokenURI;
1422     }
1423 
1424     /**
1425      * @dev Destroys `tokenId`.
1426      * The approval is cleared when the token is burned.
1427      *
1428      * Requirements:
1429      *
1430      * - `tokenId` must exist.
1431      *
1432      * Emits a {Transfer} event.
1433      */
1434     function _burn(uint256 tokenId) internal virtual override {
1435         super._burn(tokenId);
1436 
1437         if (bytes(_tokenURIs[tokenId]).length != 0) {
1438             delete _tokenURIs[tokenId];
1439         }
1440     }
1441 }
1442 
1443 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1444 
1445 
1446 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1447 
1448 pragma solidity ^0.8.0;
1449 
1450 
1451 
1452 /**
1453  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1454  * enumerability of all the token ids in the contract as well as all token ids owned by each
1455  * account.
1456  */
1457 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1458     // Mapping from owner to list of owned token IDs
1459     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1460 
1461     // Mapping from token ID to index of the owner tokens list
1462     mapping(uint256 => uint256) private _ownedTokensIndex;
1463 
1464     // Array with all token ids, used for enumeration
1465     uint256[] private _allTokens;
1466 
1467     // Mapping from token id to position in the allTokens array
1468     mapping(uint256 => uint256) private _allTokensIndex;
1469 
1470     /**
1471      * @dev See {IERC165-supportsInterface}.
1472      */
1473     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1474         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1475     }
1476 
1477     /**
1478      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1479      */
1480     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1481         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1482         return _ownedTokens[owner][index];
1483     }
1484 
1485     /**
1486      * @dev See {IERC721Enumerable-totalSupply}.
1487      */
1488     function totalSupply() public view virtual override returns (uint256) {
1489         return _allTokens.length;
1490     }
1491 
1492     /**
1493      * @dev See {IERC721Enumerable-tokenByIndex}.
1494      */
1495     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1496         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1497         return _allTokens[index];
1498     }
1499 
1500     /**
1501      * @dev Hook that is called before any token transfer. This includes minting
1502      * and burning.
1503      *
1504      * Calling conditions:
1505      *
1506      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1507      * transferred to `to`.
1508      * - When `from` is zero, `tokenId` will be minted for `to`.
1509      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1510      * - `from` cannot be the zero address.
1511      * - `to` cannot be the zero address.
1512      *
1513      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1514      */
1515     function _beforeTokenTransfer(
1516         address from,
1517         address to,
1518         uint256 tokenId
1519     ) internal virtual override {
1520         super._beforeTokenTransfer(from, to, tokenId);
1521 
1522         if (from == address(0)) {
1523             _addTokenToAllTokensEnumeration(tokenId);
1524         } else if (from != to) {
1525             _removeTokenFromOwnerEnumeration(from, tokenId);
1526         }
1527         if (to == address(0)) {
1528             _removeTokenFromAllTokensEnumeration(tokenId);
1529         } else if (to != from) {
1530             _addTokenToOwnerEnumeration(to, tokenId);
1531         }
1532     }
1533 
1534     /**
1535      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1536      * @param to address representing the new owner of the given token ID
1537      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1538      */
1539     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1540         uint256 length = ERC721.balanceOf(to);
1541         _ownedTokens[to][length] = tokenId;
1542         _ownedTokensIndex[tokenId] = length;
1543     }
1544 
1545     /**
1546      * @dev Private function to add a token to this extension's token tracking data structures.
1547      * @param tokenId uint256 ID of the token to be added to the tokens list
1548      */
1549     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1550         _allTokensIndex[tokenId] = _allTokens.length;
1551         _allTokens.push(tokenId);
1552     }
1553 
1554     /**
1555      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1556      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1557      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1558      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1559      * @param from address representing the previous owner of the given token ID
1560      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1561      */
1562     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1563         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1564         // then delete the last slot (swap and pop).
1565 
1566         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1567         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1568 
1569         // When the token to delete is the last token, the swap operation is unnecessary
1570         if (tokenIndex != lastTokenIndex) {
1571             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1572 
1573             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1574             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1575         }
1576 
1577         // This also deletes the contents at the last position of the array
1578         delete _ownedTokensIndex[tokenId];
1579         delete _ownedTokens[from][lastTokenIndex];
1580     }
1581 
1582     /**
1583      * @dev Private function to remove a token from this extension's token tracking data structures.
1584      * This has O(1) time complexity, but alters the order of the _allTokens array.
1585      * @param tokenId uint256 ID of the token to be removed from the tokens list
1586      */
1587     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1588         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1589         // then delete the last slot (swap and pop).
1590 
1591         uint256 lastTokenIndex = _allTokens.length - 1;
1592         uint256 tokenIndex = _allTokensIndex[tokenId];
1593 
1594         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1595         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1596         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1597         uint256 lastTokenId = _allTokens[lastTokenIndex];
1598 
1599         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1600         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1601 
1602         // This also deletes the contents at the last position of the array
1603         delete _allTokensIndex[tokenId];
1604         _allTokens.pop();
1605     }
1606 }
1607 
1608 // File: contracts/KaktusNFT.sol
1609 
1610 
1611 pragma solidity ^0.8.0;
1612 
1613 
1614 
1615 
1616 
1617 
1618 
1619 contract KaktusNFT is ERC721, ERC721Enumerable, Ownable {
1620     using Strings for uint256;
1621     using SafeMath for uint256;
1622     uint public constant maxPurchase = 3;
1623     uint256 public constant MAX_TOKENS = 10000;
1624     string public baseExtension = ".json";
1625     uint256 private _kaktusPrice = 120000000000000000; //0,12 ETH
1626     string private baseURI;
1627     bool public saleIsActive = true;
1628 
1629     
1630     constructor(
1631         string memory _name,
1632         string memory _symbol,
1633         string memory _initBaseURI
1634     ) ERC721(_name, _symbol) {
1635         setBaseURI(_initBaseURI);
1636     }
1637 
1638 
1639   function tokenURI(uint256 tokenId)
1640     public
1641     view
1642     virtual
1643     override
1644     returns (string memory)
1645   {
1646     require(
1647       _exists(tokenId),
1648       "ERC721Metadata: URI query for nonexistent token"
1649     );
1650 
1651     string memory currentBaseURI = _baseURI();
1652     return bytes(currentBaseURI).length > 0
1653         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1654         : "";
1655   }
1656 
1657     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1658     internal
1659     override(ERC721, ERC721Enumerable)
1660     {
1661         super._beforeTokenTransfer(from, to, tokenId);
1662     }
1663 
1664     function supportsInterface(bytes4 interfaceId)
1665     public
1666     view
1667     override(ERC721, ERC721Enumerable)
1668     returns (bool)
1669     {
1670         return super.supportsInterface(interfaceId);
1671     }
1672 
1673     function withdraw() public onlyOwner {
1674         uint256 balance = address(this).balance;
1675         payable(msg.sender).transfer(balance);
1676     }
1677 
1678     function setPrice(uint256 _newPrice) public onlyOwner() {
1679         _kaktusPrice = _newPrice;
1680     }
1681 
1682     function getPrice() public view returns (uint256){
1683         return _kaktusPrice;
1684     }
1685 
1686     function mintKaktus(uint numberOfTokens) public payable {
1687         require(saleIsActive, "Sale must be active to mint");
1688         require(numberOfTokens <= maxPurchase, "Can only mint 10 tokens at a time");
1689         require(totalSupply().add(numberOfTokens) <= MAX_TOKENS, "Purchase would exceed max supply");
1690         require(_kaktusPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1691 
1692         for(uint i = 0; i < numberOfTokens; i++) {
1693             uint mintIndex = totalSupply();
1694             if (totalSupply() < MAX_TOKENS) {
1695                 _safeMint(msg.sender, mintIndex + 1);
1696             }
1697         }
1698     }
1699 
1700     function _baseURI() internal view override returns (string memory) {
1701         return baseURI;
1702     }
1703 
1704     function setBaseURI(string memory newBaseURI) public onlyOwner {
1705         baseURI = newBaseURI;
1706     }
1707 
1708     function flipSaleState() public onlyOwner {
1709         saleIsActive = !saleIsActive;
1710     }
1711 }