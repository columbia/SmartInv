1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 
6 
7 // Part: Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         assembly {
37             size := extcodesize(account)
38         }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             // Look for revert reason and bubble it up if present
208             if (returndata.length > 0) {
209                 // The easiest way to bubble the revert reason is using memory via assembly
210 
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 // Part: Base64
223 
224 /// [MIT License]
225 /// @title Base64
226 /// @notice Provides a function for encoding some bytes in base64
227 /// @author Brecht Devos <brecht@loopring.org>
228 library Base64 {
229     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
230 
231     /// @notice Encodes some bytes to the base64 representation
232     function encode(bytes memory data) internal pure returns (string memory) {
233         uint256 len = data.length;
234         if (len == 0) return "";
235 
236         // multiply by 4/3 rounded up
237         uint256 encodedLen = 4 * ((len + 2) / 3);
238 
239         // Add some extra buffer at the end
240         bytes memory result = new bytes(encodedLen + 32);
241 
242         bytes memory table = TABLE;
243 
244         assembly {
245             let tablePtr := add(table, 1)
246             let resultPtr := add(result, 32)
247 
248             for {
249                 let i := 0
250             } lt(i, len) {
251 
252             } {
253                 i := add(i, 3)
254                 let input := and(mload(add(data, i)), 0xffffff)
255 
256                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
257                 out := shl(8, out)
258                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
259                 out := shl(8, out)
260                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
261                 out := shl(8, out)
262                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
263                 out := shl(224, out)
264 
265                 mstore(resultPtr, out)
266 
267                 resultPtr := add(resultPtr, 4)
268             }
269 
270             switch mod(len, 3)
271             case 1 {
272                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
273             }
274             case 2 {
275                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
276             }
277 
278             mstore(result, encodedLen)
279         }
280 
281         return string(result);
282     }
283 }
284 
285 // Part: Context
286 
287 /**
288  * @dev Provides information about the current execution context, including the
289  * sender of the transaction and its data. While these are generally available
290  * via msg.sender and msg.data, they should not be accessed in such a direct
291  * manner, since when dealing with meta-transactions the account sending and
292  * paying for execution may not be the actual sender (as far as an application
293  * is concerned).
294  *
295  * This contract is only required for intermediate, library-like contracts.
296  */
297 abstract contract Context {
298     function _msgSender() internal view virtual returns (address) {
299         return msg.sender;
300     }
301 
302     function _msgData() internal view virtual returns (bytes calldata) {
303         return msg.data;
304     }
305 }
306 
307 // Part: Counters
308 
309 /**
310  * @title Counters
311  * @author Matt Condon (@shrugs)
312  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
313  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
314  *
315  * Include with `using Counters for Counters.Counter;`
316  */
317 library Counters {
318     struct Counter {
319         // This variable should never be directly accessed by users of the library: interactions must be restricted to
320         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
321         // this feature: see https://github.com/ethereum/solidity/issues/4637
322         uint256 _value; // default: 0
323     }
324 
325     function current(Counter storage counter) internal view returns (uint256) {
326         return counter._value;
327     }
328 
329     function increment(Counter storage counter) internal {
330         unchecked {
331             counter._value += 1;
332         }
333     }
334 
335     function decrement(Counter storage counter) internal {
336         uint256 value = counter._value;
337         require(value > 0, "Counter: decrement overflow");
338         unchecked {
339             counter._value = value - 1;
340         }
341     }
342 
343     function reset(Counter storage counter) internal {
344         counter._value = 0;
345     }
346 }
347 
348 // Part: IERC165
349 
350 /**
351  * @dev Interface of the ERC165 standard, as defined in the
352  * https://eips.ethereum.org/EIPS/eip-165[EIP].
353  *
354  * Implementers can declare support of contract interfaces, which can then be
355  * queried by others ({ERC165Checker}).
356  *
357  * For an implementation, see {ERC165}.
358  */
359 interface IERC165 {
360     /**
361      * @dev Returns true if this contract implements the interface defined by
362      * `interfaceId`. See the corresponding
363      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
364      * to learn more about how these ids are created.
365      *
366      * This function call must use less than 30 000 gas.
367      */
368     function supportsInterface(bytes4 interfaceId) external view returns (bool);
369 }
370 
371 // Part: IERC721Receiver
372 
373 /**
374  * @title ERC721 token receiver interface
375  * @dev Interface for any contract that wants to support safeTransfers
376  * from ERC721 asset contracts.
377  */
378 interface IERC721Receiver {
379     /**
380      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
381      * by `operator` from `from`, this function is called.
382      *
383      * It must return its Solidity selector to confirm the token transfer.
384      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
385      *
386      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
387      */
388     function onERC721Received(
389         address operator,
390         address from,
391         uint256 tokenId,
392         bytes calldata data
393     ) external returns (bytes4);
394 }
395 
396 // Part: SafeMath
397 
398 // CAUTION
399 // This version of SafeMath should only be used with Solidity 0.8 or later,
400 // because it relies on the compiler's built in overflow checks.
401 
402 /**
403  * @dev Wrappers over Solidity's arithmetic operations.
404  *
405  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
406  * now has built in overflow checking.
407  */
408 library SafeMath {
409     /**
410      * @dev Returns the addition of two unsigned integers, with an overflow flag.
411      *
412      * _Available since v3.4._
413      */
414     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
415         unchecked {
416             uint256 c = a + b;
417             if (c < a) return (false, 0);
418             return (true, c);
419         }
420     }
421 
422     /**
423      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
424      *
425      * _Available since v3.4._
426      */
427     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
428         unchecked {
429             if (b > a) return (false, 0);
430             return (true, a - b);
431         }
432     }
433 
434     /**
435      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
436      *
437      * _Available since v3.4._
438      */
439     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
440         unchecked {
441             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
442             // benefit is lost if 'b' is also tested.
443             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
444             if (a == 0) return (true, 0);
445             uint256 c = a * b;
446             if (c / a != b) return (false, 0);
447             return (true, c);
448         }
449     }
450 
451     /**
452      * @dev Returns the division of two unsigned integers, with a division by zero flag.
453      *
454      * _Available since v3.4._
455      */
456     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
457         unchecked {
458             if (b == 0) return (false, 0);
459             return (true, a / b);
460         }
461     }
462 
463     /**
464      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
465      *
466      * _Available since v3.4._
467      */
468     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
469         unchecked {
470             if (b == 0) return (false, 0);
471             return (true, a % b);
472         }
473     }
474 
475     /**
476      * @dev Returns the addition of two unsigned integers, reverting on
477      * overflow.
478      *
479      * Counterpart to Solidity's `+` operator.
480      *
481      * Requirements:
482      *
483      * - Addition cannot overflow.
484      */
485     function add(uint256 a, uint256 b) internal pure returns (uint256) {
486         return a + b;
487     }
488 
489     /**
490      * @dev Returns the subtraction of two unsigned integers, reverting on
491      * overflow (when the result is negative).
492      *
493      * Counterpart to Solidity's `-` operator.
494      *
495      * Requirements:
496      *
497      * - Subtraction cannot overflow.
498      */
499     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
500         return a - b;
501     }
502 
503     /**
504      * @dev Returns the multiplication of two unsigned integers, reverting on
505      * overflow.
506      *
507      * Counterpart to Solidity's `*` operator.
508      *
509      * Requirements:
510      *
511      * - Multiplication cannot overflow.
512      */
513     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
514         return a * b;
515     }
516 
517     /**
518      * @dev Returns the integer division of two unsigned integers, reverting on
519      * division by zero. The result is rounded towards zero.
520      *
521      * Counterpart to Solidity's `/` operator.
522      *
523      * Requirements:
524      *
525      * - The divisor cannot be zero.
526      */
527     function div(uint256 a, uint256 b) internal pure returns (uint256) {
528         return a / b;
529     }
530 
531     /**
532      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
533      * reverting when dividing by zero.
534      *
535      * Counterpart to Solidity's `%` operator. This function uses a `revert`
536      * opcode (which leaves remaining gas untouched) while Solidity uses an
537      * invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
544         return a % b;
545     }
546 
547     /**
548      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
549      * overflow (when the result is negative).
550      *
551      * CAUTION: This function is deprecated because it requires allocating memory for the error
552      * message unnecessarily. For custom revert reasons use {trySub}.
553      *
554      * Counterpart to Solidity's `-` operator.
555      *
556      * Requirements:
557      *
558      * - Subtraction cannot overflow.
559      */
560     function sub(
561         uint256 a,
562         uint256 b,
563         string memory errorMessage
564     ) internal pure returns (uint256) {
565         unchecked {
566             require(b <= a, errorMessage);
567             return a - b;
568         }
569     }
570 
571     /**
572      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
573      * division by zero. The result is rounded towards zero.
574      *
575      * Counterpart to Solidity's `/` operator. Note: this function uses a
576      * `revert` opcode (which leaves remaining gas untouched) while Solidity
577      * uses an invalid opcode to revert (consuming all remaining gas).
578      *
579      * Requirements:
580      *
581      * - The divisor cannot be zero.
582      */
583     function div(
584         uint256 a,
585         uint256 b,
586         string memory errorMessage
587     ) internal pure returns (uint256) {
588         unchecked {
589             require(b > 0, errorMessage);
590             return a / b;
591         }
592     }
593 
594     /**
595      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
596      * reverting with custom message when dividing by zero.
597      *
598      * CAUTION: This function is deprecated because it requires allocating memory for the error
599      * message unnecessarily. For custom revert reasons use {tryMod}.
600      *
601      * Counterpart to Solidity's `%` operator. This function uses a `revert`
602      * opcode (which leaves remaining gas untouched) while Solidity uses an
603      * invalid opcode to revert (consuming all remaining gas).
604      *
605      * Requirements:
606      *
607      * - The divisor cannot be zero.
608      */
609     function mod(
610         uint256 a,
611         uint256 b,
612         string memory errorMessage
613     ) internal pure returns (uint256) {
614         unchecked {
615             require(b > 0, errorMessage);
616             return a % b;
617         }
618     }
619 }
620 
621 // Part: Strings
622 
623 /**
624  * @dev String operations.
625  */
626 library Strings {
627     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
628 
629     /**
630      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
631      */
632     function toString(uint256 value) internal pure returns (string memory) {
633         // Inspired by OraclizeAPI's implementation - MIT licence
634         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
635 
636         if (value == 0) {
637             return "0";
638         }
639         uint256 temp = value;
640         uint256 digits;
641         while (temp != 0) {
642             digits++;
643             temp /= 10;
644         }
645         bytes memory buffer = new bytes(digits);
646         while (value != 0) {
647             digits -= 1;
648             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
649             value /= 10;
650         }
651         return string(buffer);
652     }
653 
654     /**
655      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
656      */
657     function toHexString(uint256 value) internal pure returns (string memory) {
658         if (value == 0) {
659             return "0x00";
660         }
661         uint256 temp = value;
662         uint256 length = 0;
663         while (temp != 0) {
664             length++;
665             temp >>= 8;
666         }
667         return toHexString(value, length);
668     }
669 
670     /**
671      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
672      */
673     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
674         bytes memory buffer = new bytes(2 * length + 2);
675         buffer[0] = "0";
676         buffer[1] = "x";
677         for (uint256 i = 2 * length + 1; i > 1; --i) {
678             buffer[i] = _HEX_SYMBOLS[value & 0xf];
679             value >>= 4;
680         }
681         require(value == 0, "Strings: hex length insufficient");
682         return string(buffer);
683     }
684 }
685 
686 // Part: ERC165
687 
688 /**
689  * @dev Implementation of the {IERC165} interface.
690  *
691  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
692  * for the additional interface id that will be supported. For example:
693  *
694  * ```solidity
695  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
696  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
697  * }
698  * ```
699  *
700  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
701  */
702 abstract contract ERC165 is IERC165 {
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707         return interfaceId == type(IERC165).interfaceId;
708     }
709 }
710 
711 // Part: IERC721
712 
713 /**
714  * @dev Required interface of an ERC721 compliant contract.
715  */
716 interface IERC721 is IERC165 {
717     /**
718      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
719      */
720     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
721 
722     /**
723      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
724      */
725     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
726 
727     /**
728      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
729      */
730     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
731 
732     /**
733      * @dev Returns the number of tokens in ``owner``'s account.
734      */
735     function balanceOf(address owner) external view returns (uint256 balance);
736 
737     /**
738      * @dev Returns the owner of the `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function ownerOf(uint256 tokenId) external view returns (address owner);
745 
746     /**
747      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
748      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
749      *
750      * Requirements:
751      *
752      * - `from` cannot be the zero address.
753      * - `to` cannot be the zero address.
754      * - `tokenId` token must exist and be owned by `from`.
755      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
756      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
757      *
758      * Emits a {Transfer} event.
759      */
760     function safeTransferFrom(
761         address from,
762         address to,
763         uint256 tokenId
764     ) external;
765 
766     /**
767      * @dev Transfers `tokenId` token from `from` to `to`.
768      *
769      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must be owned by `from`.
776      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
777      *
778      * Emits a {Transfer} event.
779      */
780     function transferFrom(
781         address from,
782         address to,
783         uint256 tokenId
784     ) external;
785 
786     /**
787      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
788      * The approval is cleared when the token is transferred.
789      *
790      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
791      *
792      * Requirements:
793      *
794      * - The caller must own the token or be an approved operator.
795      * - `tokenId` must exist.
796      *
797      * Emits an {Approval} event.
798      */
799     function approve(address to, uint256 tokenId) external;
800 
801     /**
802      * @dev Returns the account approved for `tokenId` token.
803      *
804      * Requirements:
805      *
806      * - `tokenId` must exist.
807      */
808     function getApproved(uint256 tokenId) external view returns (address operator);
809 
810     /**
811      * @dev Approve or remove `operator` as an operator for the caller.
812      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
813      *
814      * Requirements:
815      *
816      * - The `operator` cannot be the caller.
817      *
818      * Emits an {ApprovalForAll} event.
819      */
820     function setApprovalForAll(address operator, bool _approved) external;
821 
822     /**
823      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
824      *
825      * See {setApprovalForAll}
826      */
827     function isApprovedForAll(address owner, address operator) external view returns (bool);
828 
829     /**
830      * @dev Safely transfers `tokenId` token from `from` to `to`.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must exist and be owned by `from`.
837      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
838      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
839      *
840      * Emits a {Transfer} event.
841      */
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId,
846         bytes calldata data
847     ) external;
848 }
849 
850 // Part: Ownable
851 
852 /**
853  * @dev Contract module which provides a basic access control mechanism, where
854  * there is an account (an owner) that can be granted exclusive access to
855  * specific functions.
856  *
857  * By default, the owner account will be the one that deploys the contract. This
858  * can later be changed with {transferOwnership}.
859  *
860  * This module is used through inheritance. It will make available the modifier
861  * `onlyOwner`, which can be applied to your functions to restrict their use to
862  * the owner.
863  */
864 abstract contract Ownable is Context {
865     address private _owner;
866 
867     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
868 
869     /**
870      * @dev Initializes the contract setting the deployer as the initial owner.
871      */
872     constructor() {
873         _setOwner(_msgSender());
874     }
875 
876     /**
877      * @dev Returns the address of the current owner.
878      */
879     function owner() public view virtual returns (address) {
880         return _owner;
881     }
882 
883     /**
884      * @dev Throws if called by any account other than the owner.
885      */
886     modifier onlyOwner() {
887         require(owner() == _msgSender(), "Ownable: caller is not the owner");
888         _;
889     }
890 
891     /**
892      * @dev Leaves the contract without owner. It will not be possible to call
893      * `onlyOwner` functions anymore. Can only be called by the current owner.
894      *
895      * NOTE: Renouncing ownership will leave the contract without an owner,
896      * thereby removing any functionality that is only available to the owner.
897      */
898     function renounceOwnership() public virtual onlyOwner {
899         _setOwner(address(0));
900     }
901 
902     /**
903      * @dev Transfers ownership of the contract to a new account (`newOwner`).
904      * Can only be called by the current owner.
905      */
906     function transferOwnership(address newOwner) public virtual onlyOwner {
907         require(newOwner != address(0), "Ownable: new owner is the zero address");
908         _setOwner(newOwner);
909     }
910 
911     function _setOwner(address newOwner) private {
912         address oldOwner = _owner;
913         _owner = newOwner;
914         emit OwnershipTransferred(oldOwner, newOwner);
915     }
916 }
917 
918 // Part: IERC721Enumerable
919 
920 /**
921  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
922  * @dev See https://eips.ethereum.org/EIPS/eip-721
923  */
924 interface IERC721Enumerable is IERC721 {
925     /**
926      * @dev Returns the total amount of tokens stored by the contract.
927      */
928     function totalSupply() external view returns (uint256);
929 
930     /**
931      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
932      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
933      */
934     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
935 
936     /**
937      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
938      * Use along with {totalSupply} to enumerate all tokens.
939      */
940     function tokenByIndex(uint256 index) external view returns (uint256);
941 }
942 
943 // Part: IERC721Metadata
944 
945 /**
946  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
947  * @dev See https://eips.ethereum.org/EIPS/eip-721
948  */
949 interface IERC721Metadata is IERC721 {
950     /**
951      * @dev Returns the token collection name.
952      */
953     function name() external view returns (string memory);
954 
955     /**
956      * @dev Returns the token collection symbol.
957      */
958     function symbol() external view returns (string memory);
959 
960     /**
961      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
962      */
963     function tokenURI(uint256 tokenId) external view returns (string memory);
964 }
965 
966 // Part: ERC721
967 
968 /**
969  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
970  * the Metadata extension, but not including the Enumerable extension, which is available separately as
971  * {ERC721Enumerable}.
972  */
973 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
974     using Address for address;
975     using Strings for uint256;
976 
977     // Token name
978     string private _name;
979 
980     // Token symbol
981     string private _symbol;
982 
983     // Mapping from token ID to owner address
984     mapping(uint256 => address) private _owners;
985 
986     // Mapping owner address to token count
987     mapping(address => uint256) private _balances;
988 
989     // Mapping from token ID to approved address
990     mapping(uint256 => address) private _tokenApprovals;
991 
992     // Mapping from owner to operator approvals
993     mapping(address => mapping(address => bool)) private _operatorApprovals;
994 
995     /**
996      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
997      */
998     constructor(string memory name_, string memory symbol_) {
999         _name = name_;
1000         _symbol = symbol_;
1001     }
1002 
1003     /**
1004      * @dev See {IERC165-supportsInterface}.
1005      */
1006     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1007         return
1008             interfaceId == type(IERC721).interfaceId ||
1009             interfaceId == type(IERC721Metadata).interfaceId ||
1010             super.supportsInterface(interfaceId);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-balanceOf}.
1015      */
1016     function balanceOf(address owner) public view virtual override returns (uint256) {
1017         require(owner != address(0), "ERC721: balance query for the zero address");
1018         return _balances[owner];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-ownerOf}.
1023      */
1024     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1025         address owner = _owners[tokenId];
1026         require(owner != address(0), "ERC721: owner query for nonexistent token");
1027         return owner;
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Metadata-name}.
1032      */
1033     function name() public view virtual override returns (string memory) {
1034         return _name;
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Metadata-symbol}.
1039      */
1040     function symbol() public view virtual override returns (string memory) {
1041         return _symbol;
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Metadata-tokenURI}.
1046      */
1047     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1048         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1049 
1050         string memory baseURI = _baseURI();
1051         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1052     }
1053 
1054     /**
1055      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1056      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1057      * by default, can be overriden in child contracts.
1058      */
1059     function _baseURI() internal view virtual returns (string memory) {
1060         return "";
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-approve}.
1065      */
1066     function approve(address to, uint256 tokenId) public virtual override {
1067         address owner = ERC721.ownerOf(tokenId);
1068         require(to != owner, "ERC721: approval to current owner");
1069 
1070         require(
1071             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1072             "ERC721: approve caller is not owner nor approved for all"
1073         );
1074 
1075         _approve(to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-getApproved}.
1080      */
1081     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1082         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1083 
1084         return _tokenApprovals[tokenId];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-setApprovalForAll}.
1089      */
1090     function setApprovalForAll(address operator, bool approved) public virtual override {
1091         require(operator != _msgSender(), "ERC721: approve to caller");
1092 
1093         _operatorApprovals[_msgSender()][operator] = approved;
1094         emit ApprovalForAll(_msgSender(), operator, approved);
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-isApprovedForAll}.
1099      */
1100     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1101         return _operatorApprovals[owner][operator];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-transferFrom}.
1106      */
1107     function transferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) public virtual override {
1112         //solhint-disable-next-line max-line-length
1113         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1114 
1115         _transfer(from, to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-safeTransferFrom}.
1120      */
1121     function safeTransferFrom(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) public virtual override {
1126         safeTransferFrom(from, to, tokenId, "");
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-safeTransferFrom}.
1131      */
1132     function safeTransferFrom(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) public virtual override {
1138         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1139         _safeTransfer(from, to, tokenId, _data);
1140     }
1141 
1142     /**
1143      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1144      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1145      *
1146      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1147      *
1148      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1149      * implement alternative mechanisms to perform token transfer, such as signature-based.
1150      *
1151      * Requirements:
1152      *
1153      * - `from` cannot be the zero address.
1154      * - `to` cannot be the zero address.
1155      * - `tokenId` token must exist and be owned by `from`.
1156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1157      *
1158      * Emits a {Transfer} event.
1159      */
1160     function _safeTransfer(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) internal virtual {
1166         _transfer(from, to, tokenId);
1167         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1168     }
1169 
1170     /**
1171      * @dev Returns whether `tokenId` exists.
1172      *
1173      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1174      *
1175      * Tokens start existing when they are minted (`_mint`),
1176      * and stop existing when they are burned (`_burn`).
1177      */
1178     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1179         return _owners[tokenId] != address(0);
1180     }
1181 
1182     /**
1183      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must exist.
1188      */
1189     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1190         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1191         address owner = ERC721.ownerOf(tokenId);
1192         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1193     }
1194 
1195     /**
1196      * @dev Safely mints `tokenId` and transfers it to `to`.
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must not exist.
1201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _safeMint(address to, uint256 tokenId) internal virtual {
1206         _safeMint(to, tokenId, "");
1207     }
1208 
1209     /**
1210      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1211      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1212      */
1213     function _safeMint(
1214         address to,
1215         uint256 tokenId,
1216         bytes memory _data
1217     ) internal virtual {
1218         _mint(to, tokenId);
1219         require(
1220             _checkOnERC721Received(address(0), to, tokenId, _data),
1221             "ERC721: transfer to non ERC721Receiver implementer"
1222         );
1223     }
1224 
1225     /**
1226      * @dev Mints `tokenId` and transfers it to `to`.
1227      *
1228      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must not exist.
1233      * - `to` cannot be the zero address.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _mint(address to, uint256 tokenId) internal virtual {
1238         require(to != address(0), "ERC721: mint to the zero address");
1239         require(!_exists(tokenId), "ERC721: token already minted");
1240 
1241         _beforeTokenTransfer(address(0), to, tokenId);
1242 
1243         _balances[to] += 1;
1244         _owners[tokenId] = to;
1245 
1246         emit Transfer(address(0), to, tokenId);
1247     }
1248 
1249     /**
1250      * @dev Destroys `tokenId`.
1251      * The approval is cleared when the token is burned.
1252      *
1253      * Requirements:
1254      *
1255      * - `tokenId` must exist.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _burn(uint256 tokenId) internal virtual {
1260         address owner = ERC721.ownerOf(tokenId);
1261 
1262         _beforeTokenTransfer(owner, address(0), tokenId);
1263 
1264         // Clear approvals
1265         _approve(address(0), tokenId);
1266 
1267         _balances[owner] -= 1;
1268         delete _owners[tokenId];
1269 
1270         emit Transfer(owner, address(0), tokenId);
1271     }
1272 
1273     /**
1274      * @dev Transfers `tokenId` from `from` to `to`.
1275      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1276      *
1277      * Requirements:
1278      *
1279      * - `to` cannot be the zero address.
1280      * - `tokenId` token must be owned by `from`.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _transfer(
1285         address from,
1286         address to,
1287         uint256 tokenId
1288     ) internal virtual {
1289         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1290         require(to != address(0), "ERC721: transfer to the zero address");
1291 
1292         _beforeTokenTransfer(from, to, tokenId);
1293 
1294         // Clear approvals from the previous owner
1295         _approve(address(0), tokenId);
1296 
1297         _balances[from] -= 1;
1298         _balances[to] += 1;
1299         _owners[tokenId] = to;
1300 
1301         emit Transfer(from, to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev Approve `to` to operate on `tokenId`
1306      *
1307      * Emits a {Approval} event.
1308      */
1309     function _approve(address to, uint256 tokenId) internal virtual {
1310         _tokenApprovals[tokenId] = to;
1311         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1312     }
1313 
1314     /**
1315      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1316      * The call is not executed if the target address is not a contract.
1317      *
1318      * @param from address representing the previous owner of the given token ID
1319      * @param to target address that will receive the tokens
1320      * @param tokenId uint256 ID of the token to be transferred
1321      * @param _data bytes optional data to send along with the call
1322      * @return bool whether the call correctly returned the expected magic value
1323      */
1324     function _checkOnERC721Received(
1325         address from,
1326         address to,
1327         uint256 tokenId,
1328         bytes memory _data
1329     ) private returns (bool) {
1330         if (to.isContract()) {
1331             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1332                 return retval == IERC721Receiver.onERC721Received.selector;
1333             } catch (bytes memory reason) {
1334                 if (reason.length == 0) {
1335                     revert("ERC721: transfer to non ERC721Receiver implementer");
1336                 } else {
1337                     assembly {
1338                         revert(add(32, reason), mload(reason))
1339                     }
1340                 }
1341             }
1342         } else {
1343             return true;
1344         }
1345     }
1346 
1347     /**
1348      * @dev Hook that is called before any token transfer. This includes minting
1349      * and burning.
1350      *
1351      * Calling conditions:
1352      *
1353      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1354      * transferred to `to`.
1355      * - When `from` is zero, `tokenId` will be minted for `to`.
1356      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1357      * - `from` and `to` are never both zero.
1358      *
1359      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1360      */
1361     function _beforeTokenTransfer(
1362         address from,
1363         address to,
1364         uint256 tokenId
1365     ) internal virtual {}
1366 }
1367 
1368 // Part: ERC721Enumerable
1369 
1370 /**
1371  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1372  * enumerability of all the token ids in the contract as well as all token ids owned by each
1373  * account.
1374  */
1375 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1376     // Mapping from owner to list of owned token IDs
1377     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1378 
1379     // Mapping from token ID to index of the owner tokens list
1380     mapping(uint256 => uint256) private _ownedTokensIndex;
1381 
1382     // Array with all token ids, used for enumeration
1383     uint256[] private _allTokens;
1384 
1385     // Mapping from token id to position in the allTokens array
1386     mapping(uint256 => uint256) private _allTokensIndex;
1387 
1388     /**
1389      * @dev See {IERC165-supportsInterface}.
1390      */
1391     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1392         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1393     }
1394 
1395     /**
1396      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1397      */
1398     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1399         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1400         return _ownedTokens[owner][index];
1401     }
1402 
1403     /**
1404      * @dev See {IERC721Enumerable-totalSupply}.
1405      */
1406     function totalSupply() public view virtual override returns (uint256) {
1407         return _allTokens.length;
1408     }
1409 
1410     /**
1411      * @dev See {IERC721Enumerable-tokenByIndex}.
1412      */
1413     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1414         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1415         return _allTokens[index];
1416     }
1417 
1418     /**
1419      * @dev Hook that is called before any token transfer. This includes minting
1420      * and burning.
1421      *
1422      * Calling conditions:
1423      *
1424      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1425      * transferred to `to`.
1426      * - When `from` is zero, `tokenId` will be minted for `to`.
1427      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1428      * - `from` cannot be the zero address.
1429      * - `to` cannot be the zero address.
1430      *
1431      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1432      */
1433     function _beforeTokenTransfer(
1434         address from,
1435         address to,
1436         uint256 tokenId
1437     ) internal virtual override {
1438         super._beforeTokenTransfer(from, to, tokenId);
1439 
1440         if (from == address(0)) {
1441             _addTokenToAllTokensEnumeration(tokenId);
1442         } else if (from != to) {
1443             _removeTokenFromOwnerEnumeration(from, tokenId);
1444         }
1445         if (to == address(0)) {
1446             _removeTokenFromAllTokensEnumeration(tokenId);
1447         } else if (to != from) {
1448             _addTokenToOwnerEnumeration(to, tokenId);
1449         }
1450     }
1451 
1452     /**
1453      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1454      * @param to address representing the new owner of the given token ID
1455      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1456      */
1457     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1458         uint256 length = ERC721.balanceOf(to);
1459         _ownedTokens[to][length] = tokenId;
1460         _ownedTokensIndex[tokenId] = length;
1461     }
1462 
1463     /**
1464      * @dev Private function to add a token to this extension's token tracking data structures.
1465      * @param tokenId uint256 ID of the token to be added to the tokens list
1466      */
1467     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1468         _allTokensIndex[tokenId] = _allTokens.length;
1469         _allTokens.push(tokenId);
1470     }
1471 
1472     /**
1473      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1474      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1475      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1476      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1477      * @param from address representing the previous owner of the given token ID
1478      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1479      */
1480     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1481         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1482         // then delete the last slot (swap and pop).
1483 
1484         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1485         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1486 
1487         // When the token to delete is the last token, the swap operation is unnecessary
1488         if (tokenIndex != lastTokenIndex) {
1489             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1490 
1491             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1492             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1493         }
1494 
1495         // This also deletes the contents at the last position of the array
1496         delete _ownedTokensIndex[tokenId];
1497         delete _ownedTokens[from][lastTokenIndex];
1498     }
1499 
1500     /**
1501      * @dev Private function to remove a token from this extension's token tracking data structures.
1502      * This has O(1) time complexity, but alters the order of the _allTokens array.
1503      * @param tokenId uint256 ID of the token to be removed from the tokens list
1504      */
1505     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1506         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1507         // then delete the last slot (swap and pop).
1508 
1509         uint256 lastTokenIndex = _allTokens.length - 1;
1510         uint256 tokenIndex = _allTokensIndex[tokenId];
1511 
1512         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1513         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1514         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1515         uint256 lastTokenId = _allTokens[lastTokenIndex];
1516 
1517         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1518         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1519 
1520         // This also deletes the contents at the last position of the array
1521         delete _allTokensIndex[tokenId];
1522         _allTokens.pop();
1523     }
1524 }
1525 
1526 // File: seasides.sol
1527 
1528 contract OnChainSeasidesNight is ERC721, ERC721Enumerable, Ownable {
1529     using Counters for Counters.Counter;
1530     using SafeMath for uint256;
1531 
1532     Counters.Counter private _tokenIdCounter;
1533     uint private constant maxTokensPerTransaction = 30;
1534     uint256 private tokenPrice = 30000000000000000; //0.03 ETH
1535     uint256 private constant nftsNumber = 3333;
1536     uint256 private constant nftsPublicNumber = 3300;
1537     
1538     constructor() ERC721("OnChainSeasides Night", "OSN") {
1539         _tokenIdCounter.increment();
1540     }
1541     
1542 
1543      function toString(uint256 value) internal pure returns (string memory) {
1544     // Inspired by OraclizeAPI's implementation - MIT license
1545     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1546 
1547         if (value == 0) {
1548             return "0";
1549         }
1550         uint256 temp = value;
1551         uint256 digits;
1552         while (temp != 0) {
1553             digits++;
1554             temp /= 10;
1555         }
1556         bytes memory buffer = new bytes(digits);
1557         while (value != 0) {
1558             digits -= 1;
1559             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1560             value /= 10;
1561         }
1562         return string(buffer);
1563     }
1564     function safeMint(address to) public onlyOwner {
1565         _safeMint(to, _tokenIdCounter.current());
1566         _tokenIdCounter.increment();
1567     }
1568 
1569     // The following functions are overrides required by Solidity.
1570 
1571     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1572         internal
1573         override(ERC721, ERC721Enumerable)
1574     {
1575         super._beforeTokenTransfer(from, to, tokenId);
1576     }
1577 
1578     function supportsInterface(bytes4 interfaceId)
1579         public
1580         view
1581         override(ERC721, ERC721Enumerable)
1582         returns (bool)
1583     {
1584         return super.supportsInterface(interfaceId);
1585     }
1586     
1587     function random(string memory input) internal pure returns (uint256) {
1588         return uint256(keccak256(abi.encodePacked(input)));
1589     }
1590     
1591     function toHashCode(uint256 value) internal pure returns (string memory) {
1592         if (value == 0) {
1593             return "000000";
1594         }
1595         uint256 i;
1596 
1597         bytes memory buffer = "000000";
1598         for(i=6;i>0;i--) {
1599             if (value % 16 < 10)
1600                 buffer[i-1] = bytes1(uint8(48 + uint256(value % 16)));
1601             else
1602                 buffer[i-1] = bytes1(uint8(55 + uint256(value % 16)));
1603 
1604             value /= 16;
1605         }
1606         return string(buffer);
1607     }
1608     
1609     function getGrass(uint256 value, uint256 is_mirror) public pure returns (string memory) {
1610         uint256 i;
1611         uint256 prt;
1612         int256 sym;
1613         uint256 pos;
1614         uint256 seed;
1615         uint256 ps;
1616         uint256 psx;
1617 
1618         uint256 finale=1;
1619 
1620         bytes memory buffer = new bytes(250);
1621 
1622         uint256[6] memory gtypes;
1623 
1624         gtypes[0] = 563891157643448204000202434637890680663763947839870365052682593692495482209;
1625         gtypes[1] = 1002862760941180669446230775124823108274825368678245159754096610961814;
1626         gtypes[2] = 563871000271014004664722370698789260236686074535032282236861359775136052288;
1627         gtypes[3] = 1003329826285104973259814183739832352502149867278345049274004408492605;
1628         gtypes[4] = 564017709498396033660054424834310877655732749413952956046917965314005819035;
1629         gtypes[5] = 1002137238139483205643623885946750710585681910777426838629649942020236;
1630 
1631 
1632         finale = 0;
1633         seed = gtypes[value*2-2];
1634 
1635     
1636         for(psx=ps=pos=i=0;i<70;i++) {
1637             prt = seed / (750 ** ps++);
1638             sym = int256(prt % 750);
1639             if (sym == 749) {
1640                 if (finale == 1)
1641                     break;
1642                     
1643                 finale = 1;
1644                 seed = gtypes[value*2-1];
1645                 ps=0;
1646                 continue;
1647             }
1648             
1649             if (psx%2==0) {
1650                 
1651                 if (is_mirror==1)
1652                     sym = 400 - sym;
1653                 else
1654                     sym += 550;
1655                   
1656                 if (i>0)
1657                     buffer[pos++] = ' ';
1658             } else {
1659                 if (i>0)
1660                     buffer[pos++] = ',';
1661                 sym += 500;
1662     
1663             }
1664             
1665             if (sym<0) {
1666                 sym=-sym;
1667                 buffer[pos++] = bytes1(uint8(45));
1668     
1669             }
1670                 
1671             if (sym<10)
1672                 buffer[pos++] = bytes1(uint8(48 + uint256(sym % 10)));
1673             else if (sym<100) {
1674                 buffer[pos++] = bytes1(uint8(48 + uint256(sym / 10)));
1675                 buffer[pos++] = bytes1(uint8(48 + uint256(sym % 10)));
1676             } else if (sym<1000) {
1677                 buffer[pos++] = bytes1(uint8(48 + uint256(sym / 100)));
1678                 buffer[pos++] = bytes1(uint8(48 + uint256((sym / 10)%10)));
1679                 buffer[pos++] = bytes1(uint8(48 + uint256(sym % 10)));  
1680             } else {
1681                 buffer[pos++] = bytes1(uint8(48 + uint256(sym / 1000)));
1682                 buffer[pos++] = bytes1(uint8(48 + uint256((sym / 100)%10)));
1683                 buffer[pos++] = bytes1(uint8(48 + uint256((sym / 10)%10)));
1684                 buffer[pos++] = bytes1(uint8(48 + uint256(sym % 10)));  
1685             }
1686             psx++;
1687     
1688         }
1689         
1690         bytes memory buffer2 = new bytes(pos);
1691         for(i=0;i<pos;i++)
1692             buffer2[i] = buffer[i];
1693 
1694         return string(buffer2);
1695     }
1696     
1697     function getShip(uint256 value, uint dir, uint is_mirror) internal pure returns (string memory) {
1698         uint256 i;
1699         uint256 prt;
1700         uint256 sym;
1701         uint256 pos;
1702         uint256 seed;
1703         uint256 ps;
1704 
1705         uint256 finale=1;
1706 
1707         bytes memory buffer = new bytes(300);
1708 
1709         uint256[10] memory stypes;
1710 
1711         stypes[0] = 4039953958419306012627391607069051694356360220713754655043968660016;
1712         stypes[1] = 63106266081136485859406661386793985037851232673778661;
1713         stypes[2] = 161568093605294050650559196328221936718722000674656809180508552713619040;
1714         stypes[3] = 63096482884095845761084638724950672236119832596577537;
1715         stypes[4] = 6461049781969783938359086369026346968766711308334899858451023002616666897676;
1716         stypes[5] = 63120086296825990194702960480301658791387552688699008;
1717         stypes[6] = 161512793322334258241850556133413063336821761930288295517787616106338882;
1718         stypes[7] = 986070141659197590531764122903072004020;
1719         stypes[8] = 161390119281273703232398765386984498139365471992159755174679367096177400;
1720         stypes[9] = 100972004999646208506838990436000093602246360157725215130052251;
1721         if (value < 7) {
1722             seed = stypes[value-1];
1723         } else {
1724             finale = 0;
1725             seed = stypes[value==7?6:8];
1726         }
1727 
1728         uint256 shift_y = is_mirror==1 ? 560 : 460;
1729         for(ps=pos=i=0;i<70;i++) {
1730             prt = seed / (200 ** ps++);
1731             sym = prt % 200;
1732             if (sym == 150) {
1733                 if (finale == 1)
1734                     break;
1735                     
1736                 finale = 1;
1737                 seed = stypes[value==7?7:9];
1738                 ps=0;
1739                 continue;
1740             }
1741             
1742     
1743             
1744             
1745             if (ps%2==0) {
1746                 if (is_mirror==1)
1747                     sym = 1000 - (sym + 320);
1748                 else
1749                     sym = sym + shift_y;
1750                     
1751                 if (i>0)
1752                     buffer[pos++] = ',';
1753             } else {
1754     
1755                 if (dir == 1)
1756                     sym += 100;
1757                 else
1758                     sym = 1000 - (sym + 100);
1759                     
1760                 if (i>0)
1761                     buffer[pos++] = ' ';
1762             }
1763                 
1764             if (sym<10)
1765                 buffer[pos++] = bytes1(uint8(48 + uint256(sym % 10)));
1766             else if (sym<100) {
1767                 buffer[pos++] = bytes1(uint8(48 + uint256(sym / 10)));
1768                 buffer[pos++] = bytes1(uint8(48 + uint256(sym % 10)));
1769             } else {
1770                 buffer[pos++] = bytes1(uint8(48 + uint256(sym / 100)));
1771                 buffer[pos++] = bytes1(uint8(48 + uint256((sym / 10)%10)));
1772                 buffer[pos++] = bytes1(uint8(48 + uint256(sym % 10)));  
1773             }
1774     
1775         }
1776 
1777         bytes memory buffer2 = new bytes(pos);
1778         for(i=0;i<pos;i++)
1779             buffer2[i] = buffer[i];
1780 
1781         return string(buffer2);
1782         }
1783 
1784     
1785     function getPalm(uint256 num) internal pure returns (string memory) {
1786         string[4] memory palm;
1787         palm[0]='M-137,104C-32,27,573,28,762,263 C582,95,180,57,23,87c105-7,598,17,757,244 c-60-74-241-182-524-212c241,55,435,181,475,265 C587,207,260,141,220,133c18,4,375,100,461,262 C504,164,19,125-4,123c141,15,524,86,641,281 C493,229,162,170,122,163c141,51,245,127,273,197 C340,270,68,139-39,146c139,51,242,127,269,196 C117,195-84,150-84,150L-758,97L-137,104z';
1788         palm[1]='M-144,304c9-106,334-319,580-175 C236,41-2,150-67,232c52-44,331-195,555-47 c-77-45-241-78-410-5c162-35,344,8,417,70 C307,140,92,197,65,204c12-2,263-42,407,72 c-236-144-520-8-534-1C24,239,273,167,455,301 C270,193,57,257,31,265c107-3,209,27,267,80 C214,284-11,263-65,308c106-3,207,28,264,80 C48,296-87,326-87,326L-533,433L-144,304z';
1789         palm[2]='M173,299c80-78,288-143,525-156c123-6,235,2,323,22 c11,1,21,2,32,4c-87-30-205-48-339-49c-210-0-400,43-495,107 c84-74,293-128,528-127c217,0,395,47,466,114l435,66 c0,0-500-18-509-26c-175,21-328,81-402,151c56-69,193-132,358-163 c-15-2-30-4-47-5c-22,1-46,2-70,5C796,262,636,324,560,396 c56-70,195-133,362-164c-44,0-91,3-139,8 c-213,23-400,87-490,161c76-82,282-158,521-184 c92-10,179-11,255-5c-0-0-0-0-0-0c-89-14-204-14-330,1 C524,241,338,309,250,384c75-83,280-163,519-193 c21-2,42-4,63-6c-45,1-92,5-141,11c-213,27-400,95-488,170 c75-83,280-163,519-193c26-3,53-6,78-8c-42-1-87-1-133,0 C454,175,265,230,173,299z';
1790         palm[3]='M1086,14C982-63,415-11,256,269C412,64,785-11,934,9 c-99,0-559,70-690,339c50-88,212-225,474-283 c-221,82-393,240-424,339C415,191,716,89,753,77 c-16,6-344,144-412,334C490,136,941,50,963,47 C832,76,478,189,384,418c120-210,426-305,463-316 c-128,69-220,164-241,245c44-106,289-276,391-277 c-126,69-217,163-237,243c94-175,279-243,279-243l438-99L1086,14z';
1791         return palm[num-1];
1792     }
1793     
1794     function getGround(uint256 num) internal pure returns (string memory) {
1795         string[7] memory ground;
1796         ground[0] = '-30,898,-1357,1016,1298,1016';
1797         ground[1] = '-11,927,431,952,663,921,845,945,1043,934,1043,1011,-8,1011';
1798         ground[2] = '-11,927,156,912,222,941,284,931,1043,934,1043,1011,-8,1011';
1799         ground[3] = '-11,927,425,969,875,952,1046,880,1043,934,1043,1011,-8,1011';
1800         ground[4] = '-12,962,136,940,239,960,648,966,951,931,1041,938,1043,1011,-8,1011';
1801         ground[5] = '894,933,722,948,666,900,666,900,664,890,646,890,645,900,482,900,481,890,462,890,461,900,461,900,364,967,247,961,102,946,-9,912,-12,1007,1039,1007,1043,930';
1802         ground[6] = '800,951,1014,927,1039,1007,-12,1007,-10,940,81,941,175,962,647,927';
1803         return ground[num-1];
1804     }
1805     
1806     function getSun(uint256 num) internal pure returns (string memory) {
1807         uint256 suns;
1808 
1809         suns = 712316151692331099684323100692331075717224135713226117576244139582262105;
1810         if (num > 0)
1811             suns = suns / (1000 ** (num*3));
1812         string memory output = string(abi.encodePacked('cx="',toString((suns/1000000)%1000),'" cy="',toString((suns/1000)%1000),  '" r="',toString(suns%1000),'"'));
1813         
1814         return output;
1815     }
1816 
1817 
1818     function getMoon(uint256 num) internal pure returns (string memory) {
1819         uint256 moons;
1820 
1821         moons = 712316151692331099684323100692331075717224135713226117576244139582262105;
1822         if (num > 0)
1823             moons = moons / (1000 ** (num*3));
1824         
1825         string memory output = string(abi.encodePacked('cx="',toString((moons/1000000)%1000+100),'" cy="',toString((moons/1000)%1000),  '" r="',toString(moons%1000-50),'"'));
1826         
1827         return output;
1828     }
1829     
1830     function getTwinMoon(uint256 num) internal pure returns (string memory) {
1831         uint256 moons;
1832 
1833         moons = 712316151692331099684323100692331075717224135713226117576244139582262105;
1834         if (num > 0)
1835             moons = moons / (1000 ** (num*3));
1836         
1837         string memory output = string(abi.encodePacked('cx="',toString((moons/1000000)%1000-200),'" cy="',toString((moons/1000)%1000),  '" r="',toString(moons%1000-100),'"'));
1838         
1839         return output;
1840     }
1841     
1842      
1843 
1844      function tokenURI(uint256 tokenId) pure public override(ERC721)  returns (string memory) {
1845         uint256[16] memory xtypes;
1846         string[5] memory colors;
1847         string[28] memory parts;
1848         string[8] memory mount1;
1849         string[8] memory mount2;
1850         uint256[10] memory params;
1851         uint256 pos;
1852         uint256 moonpos;
1853 
1854         uint256 rand = random(string(abi.encodePacked('SeasidesNight',toString(tokenId))));
1855 
1856         params[0] = 1 + ((rand/10) % 8);// ship
1857         params[1] = 1 + (rand/100) % 2; // dir
1858         params[2] = 35;
1859         params[3] = 1 + ((rand/1000000) % 8); // mounts
1860         params[4] = 1 + ((rand/100000000) % 6); // grass
1861         params[5] = 1 + ((rand/1000000000) % 4); // palm
1862         params[6] = 1 + ((rand/10000000000) % 7); // ground
1863         params[7] = 1 + ((rand/100000000000) % 4); // sun
1864         params[8] = 1 + ((rand/10000) % 37); // pallette
1865         params[9] = 1 + ((rand/1000000000000) % 10); // lottery
1866         
1867         mount1[0] = '78,444 -494,478 651,478';
1868         mount1[1] = '999,392 865,417 806,420 743,451 529,478 1468,478';
1869         mount1[2] = '463,449 403,457 351,431 177,478 681,478';
1870         mount1[3] = '1004,457 848,464 760,450 608,455 419,433 320,454 135,409 -8,424 -8,478 1004,478';
1871         mount1[4] = '226,422 177,414 83,344 -8,367 -12,478 328,478';
1872         mount1[5] = '999,392 865,417 806,420 743,451 529,478 1468,478';
1873         mount1[6] = '564,443 463,457 375,478 793,478 721,467 612,414';
1874         mount1[7] = '1013,420 853,410 732,441 637,431 608,446 390,466 240,457 186,430 94,447 -16,420 -87,478 1016,478';
1875         
1876         mount2[0] = '162,392 -307,478 632,478';
1877         mount2[1] = '';
1878         mount2[2] = '';
1879         mount2[3] = '';
1880         mount2[4] = '991,410 826,454 611,478 1262,478';
1881         mount2[5] = '';
1882         mount2[6] = '156,438 47,478 321,478 214,461';
1883         mount2[7] = '';
1884         
1885         xtypes[0] = 5165462586977505248984271025794477445148782908573069521325498340212639;
1886         xtypes[1] = 490024044101034400102396419179934085738779419751960710510484619019681904;
1887         xtypes[2] = 4043991994607814950473362577238312297018937036519365143342896853810329;
1888         xtypes[3] = 1379064599573736476104814799994272434465744258265921437097553789059202;
1889         xtypes[4] = 6056088629583070600596400423476580059718415009582353316298341503465113;
1890         xtypes[5] = 138040297937156288773826099078203347749133755730926697092887565253488215;
1891         xtypes[6] = 1763486549546207954426324916291393168705773800679768336312337964145309337;
1892         xtypes[7] = 948653233183009513098268805292360185252612190882203913941189109236825;
1893         xtypes[8] = 1765596160030049122294337924707755907300568572202546387173451426705702110;
1894         xtypes[9] = 571213962168160818623884462797953331024439701527741670201332697661529;
1895         xtypes[10] = 1759945423641250114310949500884067660757318022344968985317724270290468863;
1896         xtypes[11] = 634962523324887909409742165431514640856016078396772822011217464449368064;
1897         xtypes[12] = 1318233657466206738337996551415773989873200879281323137549919882303230302;
1898         xtypes[13] = 20786449684869734852663949139680728584860474635680334261919687729872949;
1899         xtypes[14] = 321076936879265745525548114627410433723373509773187045336;
1900     
1901         pos = (params[2]-1) * 4;
1902         colors[0] = toHashCode(xtypes[pos/10] / (16777216 ** (pos%10)) % 16777216);
1903     
1904         pos = (params[2]-1) * 4 + 1;
1905         colors[1] = toHashCode(xtypes[pos/10] / (16777216 ** (pos%10)) % 16777216);
1906         
1907         pos = (params[2]-1) * 4 + 2;
1908         colors[2] = toHashCode(xtypes[pos/10] / (16777216 ** (pos%10)) % 16777216);
1909         
1910         pos = (params[2]-1) * 4 + 3;
1911         colors[3] = toHashCode(xtypes[pos/10] / (16777216 ** (pos%10)) % 16777216);
1912         
1913         moonpos = (params[8]-1) * 4;
1914         colors[4] = toHashCode(xtypes[moonpos/10] / (16777216 ** (moonpos%10)) % 16777216);
1915 
1916         parts[0] = '<svg width="1000px" height="1000px" viewBox="0 0 1000 1000" version="1.1" xmlns="http://www.w3.org/2000/svg"> <linearGradient id="SkyGradient" gradientUnits="userSpaceOnUse" x1="500.001" y1="999.8105" x2="500.0009" y2="4.882813e-004"> <stop offset="0.5604" style="stop-color:#'; // 2
1917         parts[1] = '"/> <stop offset="1" style="stop-color:#'; // 3
1918         parts[2] = '"/> </linearGradient> <rect x="0.001" fill="url(#SkyGradient)" width="1000" height="999.811"/> <polygon opacity="0.15" fill="#'; // 3
1919         parts[3] = string(abi.encodePacked('" points="',mount2[params[3]-1],'"/> <polygon opacity="0.1" fill="#')); // 3
1920         parts[4] = string(abi.encodePacked('" points="',mount1[params[3]-1],'"/> <rect x="0" y="478" opacity="0.2" fill="#')); // 3
1921         parts[5] = '" width="1000" height="734.531"/> <rect x="0" y="563.156" opacity="0.3" fill="#'; // 3
1922         parts[6] = '" width="1000" height="649.315"/> <g> <path xmlns="http://www.w3.org/2000/svg" opacity="0.55" fill="#'; // 3
1923         parts[7] = '" d="M8087,687c-158,0-320-3.15-469-3 c-293,0-616,10-701,10c-261,0-600-17-809-17 c-118,0-246,11-376,11c-158,0-320-10-469-10 c-293,0-379,10-574,10c-195,0-331-11-540-11 c-118,0-246,11-376,11c-158,0-320-10-469-10 c-293,0-616,17-701,17c-261,0-600-12-809-12 c-118,0-246,12-376,12c-103,0-263-9-469-9 c-92,0-181,2-260,2c-171,0-304,0-362,0c-261,0-330-0-330-0 v525l9053-6V688C9039,688,8217,687,8087,687z"/> <animateMotion path="M 0 0 L -8050 20 Z" dur="6s" repeatCount="indefinite" /> </g> <g> <path xmlns="http://www.w3.org/2000/svg" fill="#'; // 3
1924         parts[8] = '" d="M8097,846c-158,0-319-7-470-7c-285,0-443,20-651,20 c-172,0-353-5-449-9c-101-4-247-20-413-20c-116,0-243,26-373,26 c-158,0-320-31-471-31c-285,0-352,36-560,36c-172,0-390-31-556-31 c-116,0-243,26-373,26c-158,0-320-31-471-31c-285,0-442,35-650,35 c-172,0-353-5-449-9c-101-4-247-20-413-20c-116,0-245,25-375,25 c-158,0-322-13-474-13c-107,0-197,2-277,3c-133,1-243,0-372,0 c-172,0-308-0-308-0v364h9053V846C9038,846,8227,846,8097,846z"/> <animateMotion path="M 0 0 L -8050 40 Z" dur="6s" repeatCount="indefinite" /> </g> <g> <polygon fill="#'; // 3
1925         parts[9] =  string(abi.encodePacked('" points="',getShip(params[0],params[1],0), '"/> <polygon opacity="0.2" fill="#')); // 3
1926         parts[10] = string(abi.encodePacked('" points="',getShip(params[0],params[1],1),'"/> <animateMotion path="m 0 0 h ',(params[1]==1 ? '':'-'),'5000" dur="8s" repeatCount="indefinite" /> </g>'));
1927         parts[17] = string(abi.encodePacked('<radialGradient id="SunGradient" ',getSun(params[7]*2-2),' gradientUnits="userSpaceOnUse"> <stop offset="0.7604" style="stop-color:#')); // 1
1928         parts[11] = '"/> <stop offset="0.9812" style="stop-color:#'; // 2
1929         parts[12] = '"/> </radialGradient>';
1930         parts[17] = '';
1931         parts[11] = '';
1932         parts[12] = '';
1933         parts[22] = '<circle opacity="0.7" fill="#'; // 2
1934         parts[23] = string(abi.encodePacked('" ',getMoon(params[7]*2-1),'/>')); 
1935         if (params[9] == 1){
1936             parts[24] = '<circle opacity="0.5" fill="#'; // 2
1937             parts[25] = string(abi.encodePacked('" ',getTwinMoon(params[7]*2-1),'/>'));
1938             }
1939         else{
1940             parts[24] = '';
1941             parts[25] = '';
1942             }
1943         parts[14] = '';
1944         parts[15] = '';
1945         parts[16] = '';
1946         parts[20] = '';
1947         parts[21] = '';
1948         parts[19] = '</svg> ';
1949 
1950         string memory output = string(abi.encodePacked(parts[0],colors[1],parts[1],colors[2]));
1951          output = string(abi.encodePacked(output,parts[2],colors[2],parts[3] ));
1952          output = string(abi.encodePacked(output,colors[2],parts[4],colors[2] ));
1953          output = string(abi.encodePacked(output,parts[5],colors[2],parts[6] ));
1954          output = string(abi.encodePacked(output,colors[2],parts[7],colors[2] ));
1955          output = string(abi.encodePacked(output,parts[8],colors[2],parts[9] ));
1956          output = string(abi.encodePacked(output,colors[2],parts[10],parts[17],colors[0] ));
1957          output = string(abi.encodePacked(output,parts[11],colors[1],parts[12] ));
1958          output = string(abi.encodePacked(output,parts[18],colors[1],parts[13],parts[22],colors[4],parts[23]));
1959          output = string(abi.encodePacked(output,parts[24],colors[4],parts[25],parts[20],colors[3],parts[15]));
1960          output = string(abi.encodePacked(output,getGround(params[6]), parts[16], parts[19]));
1961 
1962         string[11] memory aparts;
1963         aparts[0] = '[{ "trait_type": "Ship", "value": "';
1964         aparts[1] = toString(params[0]);
1965         aparts[4] = '" }, { "trait_type": "Hills", "value": "';
1966         aparts[5] = toString(params[3]);
1967         aparts[6] = '" }, { "trait_type": "Moon Color", "value": "';
1968         aparts[7] = toString(params[8]);
1969         aparts[8] = '" }, { "trait_type": "Coast", "value": "';
1970         aparts[9] = toString(params[6]);
1971         aparts[10] = '" }]';
1972         
1973         string memory strparams = string(abi.encodePacked(aparts[0], aparts[1], aparts[4], aparts[5]));
1974         strparams = string(abi.encodePacked(strparams, aparts[6], aparts[7], aparts[8], aparts[9], aparts[10]));
1975 
1976         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "OnChainSeasides Night", "description": "Ruthless, cruel, dangerous night of metaverse seasides. No grass, No palms, Extremely surfy. Completely generated OnChain.", "attributes":', strparams,', "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1977         output = string(abi.encodePacked('data:application/json;base64,', json));
1978 
1979         return output;
1980     }
1981     
1982     function claim() public  {
1983         require(_tokenIdCounter.current() <= 333, "Tokens number to mint exceeds number of public tokens");
1984         _safeMint(msg.sender, _tokenIdCounter.current());
1985         _tokenIdCounter.increment();
1986 
1987     }
1988     
1989     function withdraw() public onlyOwner {
1990         uint balance = address(this).balance;
1991         payable(msg.sender).transfer(balance);
1992     }
1993 
1994     function BuyNFTs(uint tokensNumber) public payable {
1995         require(tokensNumber > 0, "Wrong amount");
1996         require(tokensNumber <= maxTokensPerTransaction, "Max tokens per transaction number exceeded");
1997         require(_tokenIdCounter.current().add(tokensNumber) <= nftsPublicNumber, "Tokens number to mint exceeds number of public tokens");
1998         require(tokenPrice.mul(tokensNumber) <= msg.value, "Ether value sent is too low");
1999 
2000         for(uint i = 0; i < tokensNumber; i++) {
2001             _safeMint(msg.sender, _tokenIdCounter.current());
2002             _tokenIdCounter.increment();
2003         }
2004     }
2005 }
