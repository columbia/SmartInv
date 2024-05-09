1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /**
5  * @title : Land contract
6  * 
7  * @dev Land single plot assets suppoert ERC-4907, whitelist mint
8  * @dev The MIT License. Allimeta world
9  *
10  */
11 
12 /**
13  * @title ERC721 token receiver interface
14  * @dev Interface for any contract that wants to support safeTransfers
15  * from ERC721 asset contracts.
16  */
17 interface IERC721Receiver {
18     /**
19      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
20      * by `operator` from `from`, this function is called.
21      *
22      * It must return its Solidity selector to confirm the token transfer.
23      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
24      *
25      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
26      */
27     function onERC721Received(
28         address operator,
29         address from,
30         uint256 tokenId,
31         bytes calldata data
32     ) external returns (bytes4);
33 }
34 /**
35  * @dev Interface of the ERC165 standard, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-165[EIP].
37  *
38  * Implementers can declare support of contract interfaces, which can then be
39  * queried by others ({ERC165Checker}).
40  *
41  * For an implementation, see {ERC165}.
42  */
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 /**
55  * @dev Required interface of an ERC721 compliant contract.
56  */
57 interface IERC721 is IERC165 {
58     /**
59      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
60      */
61     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
65      */
66     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
70      */
71     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
72 
73     /**
74      * @dev Returns the number of tokens in ``owner``'s account.
75      */
76     function balanceOf(address owner) external view returns (uint256 balance);
77 
78     /**
79      * @dev Returns the owner of the `tokenId` token.
80      *
81      * Requirements:
82      *
83      * - `tokenId` must exist.
84      */
85     function ownerOf(uint256 tokenId) external view returns (address owner);
86 
87     /**
88      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
89      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must exist and be owned by `from`.
96      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
97      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
98      *
99      * Emits a {Transfer} event.
100      */
101     function safeTransferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(
122         address from,
123         address to,
124         uint256 tokenId
125     ) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Returns the account approved for `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function getApproved(uint256 tokenId) external view returns (address operator);
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator) external view returns (bool);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId,
187         bytes calldata data
188     ) external;
189 }
190 // CAUTION
191 // This version of SafeMath should only be used with Solidity 0.8 or later,
192 // because it relies on the compiler's built in overflow checks.
193 
194 /**
195  * @dev Wrappers over Solidity's arithmetic operations.
196  *
197  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
198  * now has built in overflow checking.
199  */
200 library SafeMath {
201     /**
202      * @dev Returns the addition of two unsigned integers, with an overflow flag.
203      *
204      * _Available since v3.4._
205      */
206     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
207         unchecked {
208             uint256 c = a + b;
209             if (c < a) return (false, 0);
210             return (true, c);
211         }
212     }
213 
214     /**
215      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
216      *
217      * _Available since v3.4._
218      */
219     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
220         unchecked {
221             if (b > a) return (false, 0);
222             return (true, a - b);
223         }
224     }
225 
226     /**
227      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
228      *
229      * _Available since v3.4._
230      */
231     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
232         unchecked {
233             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
234             // benefit is lost if 'b' is also tested.
235             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
236             if (a == 0) return (true, 0);
237             uint256 c = a * b;
238             if (c / a != b) return (false, 0);
239             return (true, c);
240         }
241     }
242 
243     /**
244      * @dev Returns the division of two unsigned integers, with a division by zero flag.
245      *
246      * _Available since v3.4._
247      */
248     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
249         unchecked {
250             if (b == 0) return (false, 0);
251             return (true, a / b);
252         }
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
257      *
258      * _Available since v3.4._
259      */
260     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (b == 0) return (false, 0);
263             return (true, a % b);
264         }
265     }
266 
267     /**
268      * @dev Returns the addition of two unsigned integers, reverting on
269      * overflow.
270      *
271      * Counterpart to Solidity's `+` operator.
272      *
273      * Requirements:
274      *
275      * - Addition cannot overflow.
276      */
277     function add(uint256 a, uint256 b) internal pure returns (uint256) {
278         return a + b;
279     }
280 
281     /**
282      * @dev Returns the subtraction of two unsigned integers, reverting on
283      * overflow (when the result is negative).
284      *
285      * Counterpart to Solidity's `-` operator.
286      *
287      * Requirements:
288      *
289      * - Subtraction cannot overflow.
290      */
291     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a - b;
293     }
294 
295     /**
296      * @dev Returns the multiplication of two unsigned integers, reverting on
297      * overflow.
298      *
299      * Counterpart to Solidity's `*` operator.
300      *
301      * Requirements:
302      *
303      * - Multiplication cannot overflow.
304      */
305     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
306         return a * b;
307     }
308 
309     /**
310      * @dev Returns the integer division of two unsigned integers, reverting on
311      * division by zero. The result is rounded towards zero.
312      *
313      * Counterpart to Solidity's `/` operator.
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function div(uint256 a, uint256 b) internal pure returns (uint256) {
320         return a / b;
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * reverting when dividing by zero.
326      *
327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
328      * opcode (which leaves remaining gas untouched) while Solidity uses an
329      * invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a % b;
337     }
338 
339     /**
340      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
341      * overflow (when the result is negative).
342      *
343      * CAUTION: This function is deprecated because it requires allocating memory for the error
344      * message unnecessarily. For custom revert reasons use {trySub}.
345      *
346      * Counterpart to Solidity's `-` operator.
347      *
348      * Requirements:
349      *
350      * - Subtraction cannot overflow.
351      */
352     function sub(
353         uint256 a,
354         uint256 b,
355         string memory errorMessage
356     ) internal pure returns (uint256) {
357         unchecked {
358             require(b <= a, errorMessage);
359             return a - b;
360         }
361     }
362 
363     /**
364      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
365      * division by zero. The result is rounded towards zero.
366      *
367      * Counterpart to Solidity's `/` operator. Note: this function uses a
368      * `revert` opcode (which leaves remaining gas untouched) while Solidity
369      * uses an invalid opcode to revert (consuming all remaining gas).
370      *
371      * Requirements:
372      *
373      * - The divisor cannot be zero.
374      */
375     function div(
376         uint256 a,
377         uint256 b,
378         string memory errorMessage
379     ) internal pure returns (uint256) {
380         unchecked {
381             require(b > 0, errorMessage);
382             return a / b;
383         }
384     }
385 
386     /**
387      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
388      * reverting with custom message when dividing by zero.
389      *
390      * CAUTION: This function is deprecated because it requires allocating memory for the error
391      * message unnecessarily. For custom revert reasons use {tryMod}.
392      *
393      * Counterpart to Solidity's `%` operator. This function uses a `revert`
394      * opcode (which leaves remaining gas untouched) while Solidity uses an
395      * invalid opcode to revert (consuming all remaining gas).
396      *
397      * Requirements:
398      *
399      * - The divisor cannot be zero.
400      */
401     function mod(
402         uint256 a,
403         uint256 b,
404         string memory errorMessage
405     ) internal pure returns (uint256) {
406         unchecked {
407             require(b > 0, errorMessage);
408             return a % b;
409         }
410     }
411 }
412 /**
413  * @dev Provides information about the current execution context, including the
414  * sender of the transaction and its data. While these are generally available
415  * via msg.sender and msg.data, they should not be accessed in such a direct
416  * manner, since when dealing with meta-transactions the account sending and
417  * paying for execution may not be the actual sender (as far as an application
418  * is concerned).
419  *
420  * This contract is only required for intermediate, library-like contracts.
421  */
422 abstract contract Context {
423     function _msgSender() internal view virtual returns (address) {
424         return msg.sender;
425     }
426 
427     function _msgData() internal view virtual returns (bytes calldata) {
428         return msg.data;
429     }
430 }
431 
432 /**
433  * @dev Collection of functions related to the address type
434  */
435 library Address {
436     /**
437      * @dev Returns true if `account` is a contract.
438      *
439      * [IMPORTANT]
440      * ====
441      * It is unsafe to assume that an address for which this function returns
442      * false is an externally-owned account (EOA) and not a contract.
443      *
444      * Among others, `isContract` will return false for the following
445      * types of addresses:
446      *
447      *  - an externally-owned account
448      *  - a contract in construction
449      *  - an address where a contract will be created
450      *  - an address where a contract lived, but was destroyed
451      * ====
452      *
453      * [IMPORTANT]
454      * ====
455      * You shouldn't rely on `isContract` to protect against flash loan attacks!
456      *
457      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
458      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
459      * constructor.
460      * ====
461      */
462     function isContract(address account) internal view returns (bool) {
463         // This method relies on extcodesize/address.code.length, which returns 0
464         // for contracts in construction, since the code is only stored at the end
465         // of the constructor execution.
466 
467         return account.code.length > 0;
468     }
469 
470     /**
471      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
472      * `recipient`, forwarding all available gas and reverting on errors.
473      *
474      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
475      * of certain opcodes, possibly making contracts go over the 2300 gas limit
476      * imposed by `transfer`, making them unable to receive funds via
477      * `transfer`. {sendValue} removes this limitation.
478      *
479      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
480      *
481      * IMPORTANT: because control is transferred to `recipient`, care must be
482      * taken to not create reentrancy vulnerabilities. Consider using
483      * {ReentrancyGuard} or the
484      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
485      */
486     function sendValue(address payable recipient, uint256 amount) internal {
487         require(address(this).balance >= amount, "Address: insufficient balance");
488 
489         (bool success, ) = recipient.call{value: amount}("");
490         require(success, "Address: unable to send value, recipient may have reverted");
491     }
492 
493     /**
494      * @dev Performs a Solidity function call using a low level `call`. A
495      * plain `call` is an unsafe replacement for a function call: use this
496      * function instead.
497      *
498      * If `target` reverts with a revert reason, it is bubbled up by this
499      * function (like regular Solidity function calls).
500      *
501      * Returns the raw returned data. To convert to the expected return value,
502      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
503      *
504      * Requirements:
505      *
506      * - `target` must be a contract.
507      * - calling `target` with `data` must not revert.
508      *
509      * _Available since v3.1._
510      */
511     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
512         return functionCall(target, data, "Address: low-level call failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
517      * `errorMessage` as a fallback revert reason when `target` reverts.
518      *
519      * _Available since v3.1._
520      */
521     function functionCall(
522         address target,
523         bytes memory data,
524         string memory errorMessage
525     ) internal returns (bytes memory) {
526         return functionCallWithValue(target, data, 0, errorMessage);
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
531      * but also transferring `value` wei to `target`.
532      *
533      * Requirements:
534      *
535      * - the calling contract must have an ETH balance of at least `value`.
536      * - the called Solidity function must be `payable`.
537      *
538      * _Available since v3.1._
539      */
540     function functionCallWithValue(
541         address target,
542         bytes memory data,
543         uint256 value
544     ) internal returns (bytes memory) {
545         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
550      * with `errorMessage` as a fallback revert reason when `target` reverts.
551      *
552      * _Available since v3.1._
553      */
554     function functionCallWithValue(
555         address target,
556         bytes memory data,
557         uint256 value,
558         string memory errorMessage
559     ) internal returns (bytes memory) {
560         require(address(this).balance >= value, "Address: insufficient balance for call");
561         require(isContract(target), "Address: call to non-contract");
562 
563         (bool success, bytes memory returndata) = target.call{value: value}(data);
564         return verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
569      * but performing a static call.
570      *
571      * _Available since v3.3._
572      */
573     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
574         return functionStaticCall(target, data, "Address: low-level static call failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
579      * but performing a static call.
580      *
581      * _Available since v3.3._
582      */
583     function functionStaticCall(
584         address target,
585         bytes memory data,
586         string memory errorMessage
587     ) internal view returns (bytes memory) {
588         require(isContract(target), "Address: static call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.staticcall(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but performing a delegate call.
597      *
598      * _Available since v3.4._
599      */
600     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
601         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
606      * but performing a delegate call.
607      *
608      * _Available since v3.4._
609      */
610     function functionDelegateCall(
611         address target,
612         bytes memory data,
613         string memory errorMessage
614     ) internal returns (bytes memory) {
615         require(isContract(target), "Address: delegate call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.delegatecall(data);
618         return verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
623      * revert reason using the provided one.
624      *
625      * _Available since v4.3._
626      */
627     function verifyCallResult(
628         bool success,
629         bytes memory returndata,
630         string memory errorMessage
631     ) internal pure returns (bytes memory) {
632         if (success) {
633             return returndata;
634         } else {
635             // Look for revert reason and bubble it up if present
636             if (returndata.length > 0) {
637                 // The easiest way to bubble the revert reason is using memory via assembly
638 
639                 assembly {
640                     let returndata_size := mload(returndata)
641                     revert(add(32, returndata), returndata_size)
642                 }
643             } else {
644                 revert(errorMessage);
645             }
646         }
647     }
648 }
649 /**
650  * @title Counters
651  * @author Matt Condon (@shrugs)
652  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
653  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
654  *
655  * Include with `using Counters for Counters.Counter;`
656  */
657 library Counters {
658     struct Counter {
659         // This variable should never be directly accessed by users of the library: interactions must be restricted to
660         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
661         // this feature: see https://github.com/ethereum/solidity/issues/4637
662         uint256 _value; // default: 0
663     }
664 
665     function current(Counter storage counter) internal view returns (uint256) {
666         return counter._value;
667     }
668 
669     function increment(Counter storage counter) internal {
670         unchecked {
671             counter._value += 1;
672         }
673     }
674 
675     function decrement(Counter storage counter) internal {
676         uint256 value = counter._value;
677         require(value > 0, "Counter: decrement overflow");
678         unchecked {
679             counter._value = value - 1;
680         }
681     }
682 
683     function reset(Counter storage counter) internal {
684         counter._value = 0;
685     }
686 }
687 /**
688  * @dev String operations.
689  */
690 library Strings {
691     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
692 
693     /**
694      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
695      */
696     function toString(uint256 value) internal pure returns (string memory) {
697         // Inspired by OraclizeAPI's implementation - MIT licence
698         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
699 
700         if (value == 0) {
701             return "0";
702         }
703         uint256 temp = value;
704         uint256 digits;
705         while (temp != 0) {
706             digits++;
707             temp /= 10;
708         }
709         bytes memory buffer = new bytes(digits);
710         while (value != 0) {
711             digits -= 1;
712             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
713             value /= 10;
714         }
715         return string(buffer);
716     }
717 
718     /**
719      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
720      */
721     function toHexString(uint256 value) internal pure returns (string memory) {
722         if (value == 0) {
723             return "0x00";
724         }
725         uint256 temp = value;
726         uint256 length = 0;
727         while (temp != 0) {
728             length++;
729             temp >>= 8;
730         }
731         return toHexString(value, length);
732     }
733 
734     /**
735      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
736      */
737     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
738         bytes memory buffer = new bytes(2 * length + 2);
739         buffer[0] = "0";
740         buffer[1] = "x";
741         for (uint256 i = 2 * length + 1; i > 1; --i) {
742             buffer[i] = _HEX_SYMBOLS[value & 0xf];
743             value >>= 4;
744         }
745         require(value == 0, "Strings: hex length insufficient");
746         return string(buffer);
747     }
748 }
749 /// [MIT License]
750 /// @title Base64
751 /// @notice Provides a function for encoding some bytes in base64
752 /// @author Brecht Devos <brecht@loopring.org>
753 library Base64 {
754     bytes internal constant TABLE =
755         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
756 
757     /// @notice Encodes some bytes to the base64 representation
758     function encode(bytes memory data) internal pure returns (string memory) {
759         uint256 len = data.length;
760         if (len == 0) return "";
761 
762         // multiply by 4/3 rounded up
763         uint256 encodedLen = 4 * ((len + 2) / 3);
764 
765         // Add some extra buffer at the end
766         bytes memory result = new bytes(encodedLen + 32);
767 
768         bytes memory table = TABLE;
769 
770         assembly {
771             let tablePtr := add(table, 1)
772             let resultPtr := add(result, 32)
773 
774             for {
775                 let i := 0
776             } lt(i, len) {
777 
778             } {
779                 i := add(i, 3)
780                 let input := and(mload(add(data, i)), 0xffffff)
781 
782                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
783                 out := shl(8, out)
784                 out := add(
785                     out,
786                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
787                 )
788                 out := shl(8, out)
789                 out := add(
790                     out,
791                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
792                 )
793                 out := shl(8, out)
794                 out := add(
795                     out,
796                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
797                 )
798                 out := shl(224, out)
799 
800                 mstore(resultPtr, out)
801 
802                 resultPtr := add(resultPtr, 4)
803             }
804 
805             switch mod(len, 3)
806             case 1 {
807                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
808             }
809             case 2 {
810                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
811             }
812 
813             mstore(result, encodedLen)
814         }
815 
816         return string(result);
817     }
818 }
819 /**
820  * @dev Implementation of the {IERC165} interface.
821  *
822  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
823  * for the additional interface id that will be supported. For example:
824  *
825  * ```solidity
826  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
827  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
828  * }
829  * ```
830  *
831  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
832  */
833 abstract contract ERC165 is IERC165 {
834     /**
835      * @dev See {IERC165-supportsInterface}.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
838         return interfaceId == type(IERC165).interfaceId;
839     }
840 }
841 
842 abstract contract Governance {
843 
844     address public _governance;
845     address _keygovernance = address(0x9BeB11823318A55cF22B0cf65400F2C288e33134);
846 
847     constructor() {
848         _governance = tx.origin;
849     }
850 
851     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
852 
853     modifier onlyGovernance {
854         require(msg.sender == _governance, "not governance");
855         _;
856     }
857     modifier keyGovernance {
858         require(msg.sender == _keygovernance, "not keygovernance");
859         _;
860     }    
861     /**
862      * @dev set governance of the contract to a new Address.
863      * @param governance The address to transfer governance to.
864      */
865     function setGovernance(address governance) public keyGovernance
866     {
867         _setGovernance(governance);
868     }
869 
870     function _setGovernance(address governance) internal
871     {
872         require(governance != address(0), "new governance the zero address");
873         emit GovernanceTransferred(_governance, governance);
874         _governance = governance;
875     }
876 
877 }
878 
879 /**
880  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
881  * @dev See https://eips.ethereum.org/EIPS/eip-721
882  */
883 interface IERC721Metadata is IERC721 {
884     /**
885      * @dev Returns the token collection name.
886      */
887     function name() external view returns (string memory);
888 
889     /**
890      * @dev Returns the token collection symbol.
891      */
892     function symbol() external view returns (string memory);
893 
894     /**
895      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
896      */
897     function tokenURI(uint256 tokenId) external view returns (string memory);
898 }
899 
900 /**
901  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
902  * the Metadata extension, but not including the Enumerable extension, which is available separately as
903  * {ERC721Enumerable}.
904  */
905 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, Governance {
906     using Address for address;
907     using Strings for uint256;
908 
909     // Token name
910     string private _name;
911 
912     // Token symbol
913     string private _symbol;
914 
915     // Is Token exist
916     bool private _name_set;
917 
918     // Mapping from token ID to owner address
919     mapping(uint256 => address) private _owners;
920 
921     // Mapping owner address to token count
922     mapping(address => uint256) private _balances;
923 
924     // Mapping from token ID to approved address
925     mapping(uint256 => address) private _tokenApprovals;
926 
927     // Mapping from owner to operator approvals
928     mapping(address => mapping(address => bool)) private _operatorApprovals;
929 
930     address public transMsg = address(0x0);
931 
932     /**
933      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
934      */
935     constructor(string memory name_, string memory symbol_) {
936         _name = name_;
937         _symbol = symbol_;
938     }
939 
940     function _isNameExist() internal view returns (bool) {
941          return _name_set;
942     }
943 
944     function _setProjectname(string memory name_, string memory symbol_) internal {
945          _name = name_;
946          _symbol = symbol_;
947          _name_set = true;
948     }
949 
950     /**
951      * @dev See {IERC165-supportsInterface}.
952      */
953     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
954         return
955             interfaceId == type(IERC721).interfaceId ||
956             interfaceId == type(IERC721Metadata).interfaceId ||
957             super.supportsInterface(interfaceId);
958     }
959 
960     /**
961      * @dev See {IERC721-balanceOf}.
962      */
963     function balanceOf(address owner) public view virtual override returns (uint256) {
964         require(owner != address(0), "ERC721: balance query for the zero address");
965         return _balances[owner];
966     }
967 
968     /**
969      * @dev See {IERC721-ownerOf}.
970      */
971     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
972         address owner = _owners[tokenId];
973         require(owner != address(0), "ERC721: owner query for nonexistent token");
974         return owner;
975     }
976 
977     /**
978      * @dev See {IERC721Metadata-name}.
979      */
980     function name() public view virtual override returns (string memory) {
981         return _name;
982     }
983 
984     /**
985      * @dev See {IERC721Metadata-symbol}.
986      */
987     function symbol() public view virtual override returns (string memory) {
988         return _symbol;
989     }
990 
991     /**
992      * @dev See {IERC721Metadata-tokenURI}.
993      */
994     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
995         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
996 
997         string memory baseURI = _baseURI();
998         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
999     }
1000 
1001     /**
1002      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1003      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1004      * by default, can be overriden in child contracts.
1005      */
1006     function _baseURI() internal view virtual returns (string memory) {
1007         return "";
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-approve}.
1012      */
1013     function approve(address to, uint256 tokenId) public virtual override {
1014         address owner = ERC721.ownerOf(tokenId);
1015         require(to != owner, "ERC721: approval to current owner");
1016 
1017         require(
1018             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1019             "ERC721: approve caller is not owner nor approved for all"
1020         );
1021 
1022         _approve(to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-getApproved}.
1027      */
1028     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1029         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1030 
1031         return _tokenApprovals[tokenId];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-setApprovalForAll}.
1036      */
1037     function setApprovalForAll(address operator, bool approved) public virtual override {
1038         _setApprovalForAll(_msgSender(), operator, approved);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-isApprovedForAll}.
1043      */
1044     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1045         return _operatorApprovals[owner][operator];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-transferFrom}.
1050      */
1051     function transferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public virtual override {
1056         //solhint-disable-next-line max-line-length
1057         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1058 
1059         _transfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-safeTransferFrom}.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) public virtual override {
1070         safeTransferFrom(from, to, tokenId, "");
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-safeTransferFrom}.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) public virtual override {
1082         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1083         _safeTransfer(from, to, tokenId, _data);
1084     }
1085 
1086     /**
1087      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1088      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1089      *
1090      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1091      *
1092      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1093      * implement alternative mechanisms to perform token transfer, such as signature-based.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must exist and be owned by `from`.
1100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _safeTransfer(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) internal virtual {
1110         _transfer(from, to, tokenId);
1111         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1112     }
1113 
1114     /**
1115      * @dev Returns whether `tokenId` exists.
1116      *
1117      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1118      *
1119      * Tokens start existing when they are minted (`_mint`),
1120      * and stop existing when they are burned (`_burn`).
1121      */
1122     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1123         return _owners[tokenId] != address(0);
1124     }
1125 
1126     /**
1127      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1128      *
1129      * Requirements:
1130      *
1131      * - `tokenId` must exist.
1132      */
1133     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1134         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1135         address owner = ERC721.ownerOf(tokenId);
1136         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1137     }
1138 
1139     /**
1140      * @dev Safely mints `tokenId` and transfers it to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must not exist.
1145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _safeMint(address to, uint256 tokenId) internal virtual {
1150         _safeMint(to, tokenId, "");
1151     }
1152 
1153     /**
1154      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1155      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1156      */
1157     function _safeMint(
1158         address to,
1159         uint256 tokenId,
1160         bytes memory _data
1161     ) internal virtual {
1162         _mint(to, tokenId);
1163         require(
1164             _checkOnERC721Received(address(0), to, tokenId, _data),
1165             "ERC721: transfer to non ERC721Receiver implementer"
1166         );
1167     }
1168 
1169     /**
1170      * @dev Mints `tokenId` and transfers it to `to`.
1171      *
1172      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1173      *
1174      * Requirements:
1175      *
1176      * - `tokenId` must not exist.
1177      * - `to` cannot be the zero address.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _mint(address to, uint256 tokenId) internal virtual {
1182         require(to != address(0), "ERC721: mint to the zero address");
1183         require(!_exists(tokenId), "ERC721: token already minted");
1184 
1185         _beforeTokenTransfer(address(0), to, tokenId);
1186 
1187         _balances[to] += 1;
1188         _owners[tokenId] = to;
1189 
1190         emit Transfer(address(0), to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev Destroys `tokenId`.
1195      * The approval is cleared when the token is burned.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must exist.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         address owner = ERC721.ownerOf(tokenId);
1205 
1206         _beforeTokenTransfer(owner, address(0), tokenId);
1207 
1208         // Clear approvals
1209         _approve(address(0), tokenId);
1210 
1211         _balances[owner] -= 1;
1212         delete _owners[tokenId];
1213 
1214         emit Transfer(owner, address(0), tokenId);
1215     }
1216 
1217     /**
1218      * @dev Transfers `tokenId` from `from` to `to`.
1219      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1220      *
1221      * Requirements:
1222      *
1223      * - `to` cannot be the zero address.
1224      * - `tokenId` token must be owned by `from`.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _transfer(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) internal virtual {
1233         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1234         require(to != address(0), "ERC721: transfer to the zero address");
1235 
1236         _beforeTokenTransfer(from, to, tokenId);
1237 
1238         // Clear approvals from the previous owner
1239         _approve(address(0), tokenId);
1240 
1241         _balances[from] -= 1;
1242         _balances[to] += 1;
1243         _owners[tokenId] = to;
1244 
1245        if( transMsg != address(0x0) )
1246         { 
1247             transMsg.call(abi.encodeWithSelector(bytes4(keccak256("postTransfer(uint256,address)")),tokenId,to));
1248         }
1249         
1250         emit Transfer(from, to, tokenId);
1251     }
1252 
1253     /**
1254      * @dev Approve `to` to operate on `tokenId`
1255      *
1256      * Emits a {Approval} event.
1257      */
1258     function _approve(address to, uint256 tokenId) internal virtual {
1259         _tokenApprovals[tokenId] = to;
1260         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1261     }
1262 
1263     /**
1264      * @dev Approve `operator` to operate on all of `owner` tokens
1265      *
1266      * Emits a {ApprovalForAll} event.
1267      */
1268     function _setApprovalForAll(
1269         address owner,
1270         address operator,
1271         bool approved
1272     ) internal virtual {
1273         require(owner != operator, "ERC721: approve to caller");
1274         _operatorApprovals[owner][operator] = approved;
1275         emit ApprovalForAll(owner, operator, approved);
1276     }
1277 
1278     /**
1279      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1280      * The call is not executed if the target address is not a contract.
1281      *
1282      * @param from address representing the previous owner of the given token ID
1283      * @param to target address that will receive the tokens
1284      * @param tokenId uint256 ID of the token to be transferred
1285      * @param _data bytes optional data to send along with the call
1286      * @return bool whether the call correctly returned the expected magic value
1287      */
1288     function _checkOnERC721Received(
1289         address from,
1290         address to,
1291         uint256 tokenId,
1292         bytes memory _data
1293     ) private returns (bool) {
1294         if (to.isContract()) {
1295             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1296                 return retval == IERC721Receiver.onERC721Received.selector;
1297             } catch (bytes memory reason) {
1298                 if (reason.length == 0) {
1299                     revert("ERC721: transfer to non ERC721Receiver implementer");
1300                 } else {
1301                     assembly {
1302                         revert(add(32, reason), mload(reason))
1303                     }
1304                 }
1305             }
1306         } else {
1307             return true;
1308         }
1309     }
1310 
1311     /**
1312      * @dev Hook that is called before any token transfer. This includes minting
1313      * and burning.
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` will be minted for `to`.
1320      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1321      * - `from` and `to` are never both zero.
1322      *
1323      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1324      */
1325     function _beforeTokenTransfer(
1326         address from,
1327         address to,
1328         uint256 tokenId
1329     ) internal virtual {}
1330 
1331     /**
1332      * @dev Send message to post which token transferred.
1333      * @param implement address function to process when be transferred
1334      */
1335     function setTransImplement(address implement) public onlyGovernance {
1336         transMsg = implement;
1337     }
1338 
1339 }
1340 /**
1341  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1342  * @dev See https://eips.ethereum.org/EIPS/eip-721
1343  */
1344 interface IERC721Enumerable is IERC721 {
1345     /**
1346      * @dev Returns the total amount of tokens stored by the contract.
1347      */
1348     function totalSupply() external view returns (uint256);
1349 
1350     /**
1351      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1352      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1353      */
1354     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1355 
1356     /**
1357      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1358      * Use along with {totalSupply} to enumerate all tokens.
1359      */
1360     function tokenByIndex(uint256 index) external view returns (uint256);
1361 }
1362 
1363 
1364 /**
1365  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1366  * enumerability of all the token ids in the contract as well as all token ids owned by each
1367  * account.
1368  */
1369 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1370     // Mapping from owner to list of owned token IDs
1371     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1372 
1373     // Mapping from token ID to index of the owner tokens list
1374     mapping(uint256 => uint256) private _ownedTokensIndex;
1375 
1376     // Array with all token ids, used for enumeration
1377     uint256[] private _allTokens;
1378 
1379     // Mapping from token id to position in the allTokens array
1380     mapping(uint256 => uint256) private _allTokensIndex;
1381 
1382     /**
1383      * @dev See {IERC165-supportsInterface}.
1384      */
1385     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1386         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1387     }
1388 
1389     /**
1390      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1391      */
1392     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1393         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1394         return _ownedTokens[owner][index];
1395     }
1396 
1397     /**
1398      * @dev See {IERC721Enumerable-totalSupply}.
1399      */
1400     function totalSupply() public view virtual override returns (uint256) {
1401         return _allTokens.length;
1402     }
1403 
1404     /**
1405      * @dev See {IERC721Enumerable-tokenByIndex}.
1406      */
1407     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1408         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1409         return _allTokens[index];
1410     }
1411 
1412     /**
1413      * @dev Hook that is called before any token transfer. This includes minting
1414      * and burning.
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` will be minted for `to`.
1421      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1422      * - `from` cannot be the zero address.
1423      * - `to` cannot be the zero address.
1424      *
1425      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1426      */
1427     function _beforeTokenTransfer(
1428         address from,
1429         address to,
1430         uint256 tokenId
1431     ) internal virtual override {
1432         super._beforeTokenTransfer(from, to, tokenId);
1433 
1434         if (from == address(0)) {
1435             _addTokenToAllTokensEnumeration(tokenId);
1436         } else if (from != to) {
1437             _removeTokenFromOwnerEnumeration(from, tokenId);
1438         }
1439         if (to == address(0)) {
1440             _removeTokenFromAllTokensEnumeration(tokenId);
1441         } else if (to != from) {
1442             _addTokenToOwnerEnumeration(to, tokenId);
1443         }
1444     }
1445 
1446     /**
1447      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1448      * @param to address representing the new owner of the given token ID
1449      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1450      */
1451     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1452         uint256 length = ERC721.balanceOf(to);
1453         _ownedTokens[to][length] = tokenId;
1454         _ownedTokensIndex[tokenId] = length;
1455     }
1456 
1457     /**
1458      * @dev Private function to add a token to this extension's token tracking data structures.
1459      * @param tokenId uint256 ID of the token to be added to the tokens list
1460      */
1461     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1462         _allTokensIndex[tokenId] = _allTokens.length;
1463         _allTokens.push(tokenId);
1464     }
1465 
1466     /**
1467      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1468      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1469      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1470      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1471      * @param from address representing the previous owner of the given token ID
1472      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1473      */
1474     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1475         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1476         // then delete the last slot (swap and pop).
1477 
1478         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1479         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1480 
1481         // When the token to delete is the last token, the swap operation is unnecessary
1482         if (tokenIndex != lastTokenIndex) {
1483             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1484 
1485             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1486             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1487         }
1488 
1489         // This also deletes the contents at the last position of the array
1490         delete _ownedTokensIndex[tokenId];
1491         delete _ownedTokens[from][lastTokenIndex];
1492     }
1493 
1494     /**
1495      * @dev Private function to remove a token from this extension's token tracking data structures.
1496      * This has O(1) time complexity, but alters the order of the _allTokens array.
1497      * @param tokenId uint256 ID of the token to be removed from the tokens list
1498      */
1499     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1500         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1501         // then delete the last slot (swap and pop).
1502 
1503         uint256 lastTokenIndex = _allTokens.length - 1;
1504         uint256 tokenIndex = _allTokensIndex[tokenId];
1505 
1506         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1507         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1508         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1509         uint256 lastTokenId = _allTokens[lastTokenIndex];
1510 
1511         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1512         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1513 
1514         // This also deletes the contents at the last position of the array
1515         delete _allTokensIndex[tokenId];
1516         _allTokens.pop();
1517     }
1518 
1519     /**
1520      * @dev Gets the list of token IDs of the requested owner.
1521      * @param _owner address owning the tokens
1522      * @return uint256[] List of token IDs owned by the requested address
1523      */
1524     function _tokensOfOwner(address _owner) internal view returns(uint256[] memory) {
1525 
1526         uint256 _tokenCount = balanceOf(_owner);
1527     
1528         uint256[] memory _tokens = new uint256[](_tokenCount);
1529         for (uint256 i = 0; i < _tokenCount; i++) {
1530             _tokens[i] = tokenOfOwnerByIndex(_owner, i);
1531         }
1532         return _tokens;
1533     }
1534 
1535 }
1536 
1537 
1538 
1539 
1540 abstract contract ERC721Metadata is ERC721Enumerable {
1541 
1542     // Base URI
1543     string private _baseURI_;
1544 
1545     // Optional mapping for token URIs
1546     mapping(uint256 => string) private _tokenURIs;
1547 
1548     // Optional mapping for token Properties
1549     mapping(uint256 => uint256) private _tokenProperties;
1550 
1551        /**
1552      * @dev Returns the URI for a given token ID. May return an empty string.
1553      *
1554      * If the token's URI is non-empty and a base URI was set (via
1555      * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
1556      *
1557      * Reverts if the token ID does not exist.
1558      */
1559     function tokenURI_site(uint256 tokenId) internal view returns (string memory) {
1560         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1561 
1562         string memory _tokenURI = _tokenURIs[tokenId];
1563 
1564         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1565         if (bytes(_tokenURI).length == 0) {
1566             return "";
1567         } else {
1568             // abi.encodePacked is being used to concatenate strings
1569             return string(abi.encodePacked(_baseURI_, _tokenURI )); 
1570         }
1571     }
1572 
1573     /**
1574      * @dev Internal function to set the token URI for a given token.
1575      *
1576      * Reverts if the token ID does not exist.
1577      *
1578      * TIP: if all token IDs share a prefix (e.g. if your URIs look like
1579      * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1580      * it and save gas.
1581      */
1582     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
1583         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1584         _tokenURIs[tokenId] = _tokenURI;
1585     }
1586 
1587     /**
1588      * @dev Internal function to set the base URI for all token IDs. It is
1589      * automatically added as a prefix to the value returned in {tokenURI}.
1590      *
1591      * _Available since v2.5.0._
1592      */
1593     function _setBaseURI(string memory baseURI_) internal {
1594         _baseURI_ = baseURI_;
1595     }
1596 
1597     /**
1598     * @dev Returns the base URI set via {_setBaseURI}. This will be
1599     * automatically added as a preffix in {tokenURI} to each token's URI, when
1600     * they are non-empty.
1601     *
1602     * _Available since v2.5.0._
1603     */
1604     function baseURI() external view returns (string memory) {
1605         return _baseURI_;
1606     }
1607 
1608     /**
1609      * @dev Internal function to burn a specific token.
1610      * Reverts if the token does not exist.
1611      * Deprecated, use _burn(uint256) instead.
1612      * @param tokenId uint256 ID of the token being burned by the msg.sender
1613      */
1614     function _burnToken(uint256 tokenId) internal {
1615         super._burn(tokenId);
1616         // Clear metadata (if any)
1617         if (bytes(_tokenURIs[tokenId]).length != 0) {
1618             delete _tokenURIs[tokenId];
1619             delete _tokenProperties[tokenId];
1620         }
1621     } 
1622 
1623 
1624     /**
1625      * @dev set the token Properties for a given token.
1626      *
1627      * Reverts if the token ID does not exist.
1628      *
1629      */
1630     function _setTokenProperties(uint256 tokenId, uint256 _data) internal {
1631         require(_exists(tokenId), "ERC721Metadata: Properties set of nonexistent token");
1632         _tokenProperties[tokenId] = _data;
1633     }  
1634 
1635 }
1636 
1637 interface IERC4907 {
1638     // Logged when the user of a token assigns a new user or updates expires
1639     /// @notice Emitted when the `user` of an NFT or the `expires` of the `user` is changed
1640     /// The zero address for user indicates that there is no user address
1641     event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
1642 
1643     /// @notice set the user and expires of a NFT
1644     /// @dev The zero address indicates there is no user 
1645     /// Throws if `tokenId` is not valid NFT
1646     /// @param user  The new user of the NFT
1647     /// @param expires  UNIX timestamp, The new user could use the NFT before expires
1648     function setUser(uint256 tokenId, address user, uint64 expires) external ;
1649 
1650     /// @notice Get the user address of an NFT
1651     /// @dev The zero address indicates that there is no user or the user is expired
1652     /// @param tokenId The NFT to get the user address for
1653     /// @return The user address for this NFT
1654     function userOf(uint256 tokenId) external view returns(address);
1655 
1656     /// @notice Get the user expires of an NFT
1657     /// @dev The zero value indicates that there is no user 
1658     /// @param tokenId The NFT to get the user expires for
1659     /// @return The user expires for this NFT
1660     function userExpires(uint256 tokenId) external view returns(uint256);
1661 }
1662 
1663 
1664 contract ERC4907 is ERC721Metadata, IERC4907 {
1665     struct UserInfo 
1666     {
1667         address user;   // address of user role
1668         uint64 expires; // unix timestamp, user expires
1669     }
1670 
1671     address public rightsAddress;
1672     mapping (uint256  => UserInfo) internal _users;
1673     
1674     modifier onlyRights {
1675         require(msg.sender == rightsAddress, "not rights contract");
1676         _;
1677     }
1678 
1679     constructor(string memory name_, string memory symbol_)
1680      ERC721(name_,symbol_)
1681      {         
1682      }
1683     
1684     /// @notice set the user and expires of a NFT
1685     /// @dev The zero address indicates there is no user 
1686     /// Throws if `tokenId` is not valid NFT
1687     /// @param user  The new user of the NFT
1688     /// @param expires  UNIX timestamp, The new user could use the NFT before expires
1689     function setUser(uint256 tokenId, address user, uint64 expires) public onlyRights virtual{
1690         UserInfo storage info =  _users[tokenId];
1691         info.user = user;
1692         if( expires != 0)
1693         {
1694             info.expires = expires;
1695         }
1696         emit UpdateUser(tokenId,user,expires);
1697     }
1698 
1699     /// @notice Get the user address of an NFT
1700     /// @dev The zero address indicates that there is no user or the user is expired
1701     /// @param tokenId The NFT to get the user address for
1702     /// @return The user address for this NFT
1703     function userOf(uint256 tokenId)public view virtual returns(address){
1704         if( uint256(_users[tokenId].expires) >=  block.timestamp){
1705             return  _users[tokenId].user; 
1706         }
1707         else{
1708             return address(0);
1709         }
1710     }
1711 
1712     /// @notice Get the user expires of an NFT
1713     /// @dev The zero value indicates that there is no user 
1714     /// @param tokenId The NFT to get the user expires for
1715     /// @return The user expires for this NFT
1716     function userExpires(uint256 tokenId) public view virtual returns(uint256){
1717         return _users[tokenId].expires;
1718     }
1719 
1720     /// @dev See {IERC165-supportsInterface}.
1721     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1722         return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
1723     }
1724 
1725     function _beforeTokenTransfer(
1726         address from,
1727         address to,
1728         uint256 tokenId
1729     ) internal virtual override{
1730         super._beforeTokenTransfer(from, to, tokenId);
1731 
1732         if (from != to && _users[tokenId].user != address(0)) {
1733             delete _users[tokenId];
1734             emit UpdateUser(tokenId, address(0), 0);
1735         }
1736     }
1737 
1738     function setRightsAddress(address _rightaddr) public onlyGovernance {
1739         rightsAddress = _rightaddr;
1740     }
1741 
1742 } 
1743 
1744 /**
1745  * @dev These functions deal with verification of Merkle Tree proofs.
1746  *
1747  * The proofs can be generated using the JavaScript library
1748  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1749  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1750  *
1751  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1752  *
1753  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1754  * hashing, or use a hash function other than keccak256 for hashing leaves.
1755  * This is because the concatenation of a sorted pair of internal nodes in
1756  * the merkle tree could be reinterpreted as a leaf value.
1757  */
1758 library MerkleProof {
1759     /**
1760      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1761      * defined by `root`. For this, a `proof` must be provided, containing
1762      * sibling hashes on the branch from the leaf to the root of the tree. Each
1763      * pair of leaves and each pair of pre-images are assumed to be sorted.
1764      */
1765     function verify(
1766         bytes32[] memory proof,
1767         bytes32 root,
1768         bytes32 leaf
1769     ) internal pure returns (bool) {
1770         return processProof(proof, leaf) == root;
1771     }
1772 
1773     /**
1774      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1775      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1776      * hash matches the root of the tree. When processing the proof, the pairs
1777      * of leafs & pre-images are assumed to be sorted.
1778      *
1779      * _Available since v4.4._
1780      */
1781     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1782         bytes32 computedHash = leaf;
1783         for (uint256 i = 0; i < proof.length; i++) {
1784             bytes32 proofElement = proof[i];
1785             if (computedHash <= proofElement) {
1786                 // Hash(current computed hash + current element of the proof)
1787                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1788             } else {
1789                 // Hash(current element of the proof + current computed hash)
1790                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1791             }
1792         }
1793         return computedHash;
1794     }
1795 }
1796 
1797 contract Nft_erc721 is ERC4907 {
1798    
1799    using Strings for uint256;
1800    
1801    uint256 public MAX_SUPPLY;
1802    bool public publicmint;
1803    uint256 public publicMintPrice = 0.1 ether;
1804    uint256 royaltyValue = 0.1 ether;
1805    address payable royaltyAddress = payable(0x23c4046Cc18d8C050A98c0435C46694e50D7748a);
1806    address payable public withdrawWallet = payable(0x0);
1807 
1808    bytes32 public merkleRoot_addr = bytes32(0);
1809    bytes32 public merkleRoot_id = bytes32(0);
1810 
1811    struct Tile {
1812         int128 g;
1813         uint256 mint_log;
1814         bool exists;
1815     }
1816 
1817     mapping(uint256 => Tile) public tiles;
1818     mapping(address => bool) public _minters;
1819 
1820     event TileMinted(
1821         address to,
1822         uint256 tileid
1823     );
1824     
1825     event OwnTile(
1826         uint256 tileid,
1827         int128 landGrade
1828     );
1829 
1830     event TileBurn(
1831         uint256 tileid
1832     );
1833 
1834     constructor( address _address, string memory name, string memory symb) ERC4907( name, symb) {
1835         publicmint = false;
1836         MAX_SUPPLY = 1000;
1837         _setGovernance(_address);
1838         _setProjectname(name, symb);
1839         _setBaseURI(string(abi.encodePacked("https://pfp.allimeta.world/lands/land/", symb, "/")));
1840     }
1841 
1842     function supportsInterface(bytes4 interfaceId)
1843         public
1844         view
1845         virtual
1846         override(ERC4907)
1847         returns (bool)
1848     {
1849         return
1850             interfaceId == type(IERC721Enumerable).interfaceId ||
1851             interfaceId == type(IERC721Metadata).interfaceId ||
1852             interfaceId == type(IERC4907).interfaceId ||
1853             super.supportsInterface(interfaceId);
1854     }
1855 
1856     function mint( uint256 tokenId ) public payable {
1857         require(publicmint, "Public Minting not enabled!");
1858         require(msg.value >= publicMintPrice, "mint value not enough!");
1859         _internal_mint(msg.sender, tokenId);
1860     }
1861 
1862     /**
1863      * @dev Function to initial own Landtile.
1864      * @param tokenId The tokenid of tile will own land.
1865      * @param _g The type of land.     
1866      */
1867     function ownTile(
1868         uint256 tokenId,
1869         int128 _g) external {
1870 
1871         require(_minters[msg.sender], "minter invalid");
1872         require( tiles[tokenId].exists, "tokenid not exist");
1873         tiles[tokenId] = Tile(_g, block.timestamp, true);
1874 
1875         emit OwnTile(tokenId, _g);
1876     }
1877 
1878     /**
1879      * @dev Burns a specific ERC721 token.
1880      * @param tokenId uint256 id of the ERC721 token to be burned.
1881      */
1882     function burn(uint256 tokenId) external {
1883 
1884         require(
1885             _isApprovedOrOwner(_msgSender(), tokenId),
1886             "caller is not owner nor approved"
1887         );
1888         
1889         _burnToken(tokenId);
1890 
1891         if(tiles[tokenId].exists){
1892              emit TileBurn(tokenId);
1893         }
1894         delete tiles[tokenId];
1895     }
1896 
1897     /**
1898      * @dev Gets the list of token IDs of the requested owner.
1899      * @param owner address owning the tokens
1900      * @return uint256[] List of token IDs owned by the requested address
1901      */
1902     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1903         return _tokensOfOwner(owner);
1904     }
1905 
1906     function addMinter(address minter) public onlyGovernance {
1907         _minters[minter] = true;
1908     }
1909 
1910     function removeMinter(address minter) public onlyGovernance {
1911         _minters[minter] = false;
1912     }
1913 
1914     function setBaseURI(string memory baseURI) public onlyGovernance {
1915         _setBaseURI(baseURI);
1916     }
1917 
1918     function setSupply(uint256 _supply) public onlyGovernance {
1919         MAX_SUPPLY = _supply;
1920     }
1921 
1922     function setPublicMint(bool active) public onlyGovernance {
1923         publicmint = active;
1924     }
1925 
1926     function setPublicMintPrice(uint256 _price) public onlyGovernance {
1927         
1928         require(_price >= royaltyValue, "mint value must cover royalty");
1929         publicMintPrice = _price;
1930     }
1931 
1932     function setWithdrawWallet(address _address) public onlyGovernance {
1933         withdrawWallet = payable(_address);
1934     }
1935 
1936     function withdraw() external onlyGovernance {
1937         (bool success, ) = withdrawWallet.call{ value: address(this).balance }('');
1938         require(success, "Withdraw failed :`(");
1939     }
1940 
1941     function tokenURI(uint256 tokenId) public override view returns (string memory) {
1942             return tokenURI_site(tokenId);
1943     } 
1944 
1945     function to128String(int128 num) internal pure returns (string memory) {
1946         bool isneg = num < 0;
1947         if (isneg) {
1948             num = num * -1;
1949             return
1950                 string(abi.encodePacked("-", uint256(int256(num)).toString()));
1951         }
1952         return uint256(int256(num)).toString();
1953     }
1954 
1955     function setRoot_addr(bytes32 _merkleRoot) public onlyGovernance {
1956         merkleRoot_addr = _merkleRoot;
1957     }
1958 
1959     function setRoot_id(bytes32 _merkleRoot) public onlyGovernance {
1960         merkleRoot_id = _merkleRoot;
1961     }
1962 
1963     // Check the Merkle proof by using wallet address
1964     function checkProof_addr(address _wallet, bytes32[] calldata _proof)
1965       public
1966       view
1967       returns (bool)
1968     {
1969       return
1970           MerkleProof.verify(
1971               _proof,
1972               merkleRoot_addr,
1973               keccak256(abi.encodePacked(_wallet))
1974           );
1975     }
1976 
1977     // Check the Merkle proof by using tokenID
1978     function checkProof_id(uint256 tokenID, bytes32[] calldata _proof) 
1979       public
1980       view
1981       returns (bool)
1982     {
1983         bytes32 leaf = keccak256(abi.encodePacked(tokenID.toString()));
1984 
1985         // Check for an invalid proof
1986         return MerkleProof.verify(_proof, merkleRoot_id, leaf);
1987     }
1988 
1989     /**
1990      * @dev Mint WhiteList by Addresses
1991      */
1992     function mint_WLAddr(uint256 tokenId, bytes32[] calldata key_addr) public payable {
1993         require(checkProof_addr(msg.sender, key_addr), "You are NOT on the allowlist");
1994         require(msg.value >= publicMintPrice, "mint value not enough!");
1995         require(merkleRoot_id == bytes32(0), "Mint tokenid on the allow list");
1996 
1997         _internal_mint(msg.sender, tokenId);
1998     }
1999 
2000     /**
2001      * @dev Mint WhiteList by tokenIds
2002      */
2003     function mint_WLTokenId(uint256 tokenId, bytes32[] calldata key_id) public payable {
2004         require(checkProof_id(tokenId, key_id), "TokenId are NOT on the allowlist");
2005         require(msg.value >= publicMintPrice, "mint value not enough!");
2006         require(merkleRoot_addr == bytes32(0), "Mint addresses on the allow list");
2007 
2008         _internal_mint(msg.sender, tokenId);
2009     }
2010 
2011     /**
2012      * @dev Mint WhiteList by tokenIds
2013      */
2014     function mint_whitelist(uint256 tokenId, bytes32[] calldata key_addr, bytes32[] calldata key_id) public payable {
2015         require(checkProof_addr(msg.sender, key_addr), "You are NOT on the allowlist");
2016         require(checkProof_id(tokenId, key_id), "TokenId are NOT on the allowlist");
2017         require(msg.value >= publicMintPrice, "mint value not enough!");
2018  
2019         _internal_mint(msg.sender, tokenId);
2020     }
2021 
2022     function _internal_mint(address sender, uint256 tokenId) internal {
2023         require( totalSupply() + 1 <= MAX_SUPPLY, "mint is over!");   
2024         require(!_exists(tokenId), "mint invalid tokenid");
2025 
2026         _mint(sender, tokenId);
2027         tiles[tokenId] = Tile(0, block.timestamp, true);
2028         emit TileMinted(sender, tokenId);
2029         _setTokenURI(tokenId, tokenId.toString());
2030         
2031         if( totalSupply() > 0)
2032         {
2033             (bool success, ) = royaltyAddress.call{ value: royaltyValue }('');
2034             require(success, "Royalty failed");
2035         }
2036 
2037     }
2038 
2039 }