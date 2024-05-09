1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 
6 
7 // Part: Address
8 
9 // Part: Address
10 
11 // Part: Address
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize, which returns 0 for contracts in
36         // construction, since the code is only stored at the end of the
37         // constructor execution.
38 
39         uint256 size;
40         assembly {
41             size := extcodesize(account)
42         }
43         return size > 0;
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
140         return _verifyCallResult(success, returndata, errorMessage);
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
167         return _verifyCallResult(success, returndata, errorMessage);
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
194         return _verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     function _verifyCallResult(
198         bool success,
199         bytes memory returndata,
200         string memory errorMessage
201     ) private pure returns (bytes memory) {
202         if (success) {
203             return returndata;
204         } else {
205             // Look for revert reason and bubble it up if present
206             if (returndata.length > 0) {
207                 // The easiest way to bubble the revert reason is using memory via assembly
208 
209                 assembly {
210                     let returndata_size := mload(returndata)
211                     revert(add(32, returndata), returndata_size)
212                 }
213             } else {
214                 revert(errorMessage);
215             }
216         }
217     }
218 }
219 
220 // Part: Context
221 
222 // Part: Context
223 
224 // Part: Context
225 
226 /*
227  * @dev Provides information about the current execution context, including the
228  * sender of the transaction and its data. While these are generally available
229  * via msg.sender and msg.data, they should not be accessed in such a direct
230  * manner, since when dealing with meta-transactions the account sending and
231  * paying for execution may not be the actual sender (as far as an application
232  * is concerned).
233  *
234  * This contract is only required for intermediate, library-like contracts.
235  */
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes calldata) {
242         return msg.data;
243     }
244 }
245 
246 // Part: Counters
247 
248 // Part: Counters
249 
250 // Part: Counters
251 
252 /**
253  * @title Counters
254  * @author Matt Condon (@shrugs)
255  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
256  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
257  *
258  * Include with `using Counters for Counters.Counter;`
259  */
260 library Counters {
261     struct Counter {
262         // This variable should never be directly accessed by users of the library: interactions must be restricted to
263         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
264         // this feature: see https://github.com/ethereum/solidity/issues/4637
265         uint256 _value; // default: 0
266     }
267 
268     function current(Counter storage counter) internal view returns (uint256) {
269         return counter._value;
270     }
271 
272     function increment(Counter storage counter) internal {
273         unchecked {
274             counter._value += 1;
275         }
276     }
277 
278     function decrement(Counter storage counter) internal {
279         uint256 value = counter._value;
280         require(value > 0, "Counter: decrement overflow");
281         unchecked {
282             counter._value = value - 1;
283         }
284     }
285 
286     function reset(Counter storage counter) internal {
287         counter._value = 0;
288     }
289 }
290 
291 // Part: IERC165
292 
293 // Part: IERC165
294 
295 // Part: IERC165
296 
297 /**
298  * @dev Interface of the ERC165 standard, as defined in the
299  * https://eips.ethereum.org/EIPS/eip-165[EIP].
300  *
301  * Implementers can declare support of contract interfaces, which can then be
302  * queried by others ({ERC165Checker}).
303  *
304  * For an implementation, see {ERC165}.
305  */
306 interface IERC165 {
307     /**
308      * @dev Returns true if this contract implements the interface defined by
309      * `interfaceId`. See the corresponding
310      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
311      * to learn more about how these ids are created.
312      *
313      * This function call must use less than 30 000 gas.
314      */
315     function supportsInterface(bytes4 interfaceId) external view returns (bool);
316 }
317 
318 // Part: IERC721Receiver
319 
320 // Part: IERC721Receiver
321 
322 // Part: IERC721Receiver
323 
324 /**
325  * @title ERC721 token receiver interface
326  * @dev Interface for any contract that wants to support safeTransfers
327  * from ERC721 asset contracts.
328  */
329 interface IERC721Receiver {
330     /**
331      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
332      * by `operator` from `from`, this function is called.
333      *
334      * It must return its Solidity selector to confirm the token transfer.
335      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
336      *
337      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
338      */
339     function onERC721Received(
340         address operator,
341         address from,
342         uint256 tokenId,
343         bytes calldata data
344     ) external returns (bytes4);
345 }
346 
347 // Part: ReentrancyGuard
348 
349 // Part: ReentrancyGuard
350 
351 // Part: ReentrancyGuard
352 
353 /**
354  * @dev Contract module that helps prevent reentrant calls to a function.
355  *
356  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
357  * available, which can be applied to functions to make sure there are no nested
358  * (reentrant) calls to them.
359  *
360  * Note that because there is a single `nonReentrant` guard, functions marked as
361  * `nonReentrant` may not call one another. This can be worked around by making
362  * those functions `private`, and then adding `external` `nonReentrant` entry
363  * points to them.
364  *
365  * TIP: If you would like to learn more about reentrancy and alternative ways
366  * to protect against it, check out our blog post
367  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
368  */
369 abstract contract ReentrancyGuard {
370     // Booleans are more expensive than uint256 or any type that takes up a full
371     // word because each write operation emits an extra SLOAD to first read the
372     // slot's contents, replace the bits taken up by the boolean, and then write
373     // back. This is the compiler's defense against contract upgrades and
374     // pointer aliasing, and it cannot be disabled.
375 
376     // The values being non-zero value makes deployment a bit more expensive,
377     // but in exchange the refund on every call to nonReentrant will be lower in
378     // amount. Since refunds are capped to a percentage of the total
379     // transaction's gas, it is best to keep them low in cases like this one, to
380     // increase the likelihood of the full refund coming into effect.
381     uint256 private constant _NOT_ENTERED = 1;
382     uint256 private constant _ENTERED = 2;
383 
384     uint256 private _status;
385 
386     constructor() {
387         _status = _NOT_ENTERED;
388     }
389 
390     /**
391      * @dev Prevents a contract from calling itself, directly or indirectly.
392      * Calling a `nonReentrant` function from another `nonReentrant`
393      * function is not supported. It is possible to prevent this from happening
394      * by making the `nonReentrant` function external, and make it call a
395      * `private` function that does the actual work.
396      */
397     modifier nonReentrant() {
398         // On the first call to nonReentrant, _notEntered will be true
399         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
400 
401         // Any calls to nonReentrant after this point will fail
402         _status = _ENTERED;
403 
404         _;
405 
406         // By storing the original value once again, a refund is triggered (see
407         // https://eips.ethereum.org/EIPS/eip-2200)
408         _status = _NOT_ENTERED;
409     }
410 }
411 
412 // Part: SafeMath
413 
414 // Part: SafeMath
415 
416 // Part: SafeMath
417 
418 // CAUTION
419 // This version of SafeMath should only be used with Solidity 0.8 or later,
420 // because it relies on the compiler's built in overflow checks.
421 
422 /**
423  * @dev Wrappers over Solidity's arithmetic operations.
424  *
425  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
426  * now has built in overflow checking.
427  */
428 library SafeMath {
429     /**
430      * @dev Returns the addition of two unsigned integers, with an overflow flag.
431      *
432      * _Available since v3.4._
433      */
434     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
435         unchecked {
436             uint256 c = a + b;
437             if (c < a) return (false, 0);
438             return (true, c);
439         }
440     }
441 
442     /**
443      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
444      *
445      * _Available since v3.4._
446      */
447     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
448         unchecked {
449             if (b > a) return (false, 0);
450             return (true, a - b);
451         }
452     }
453 
454     /**
455      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
456      *
457      * _Available since v3.4._
458      */
459     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
460         unchecked {
461             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
462             // benefit is lost if 'b' is also tested.
463             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
464             if (a == 0) return (true, 0);
465             uint256 c = a * b;
466             if (c / a != b) return (false, 0);
467             return (true, c);
468         }
469     }
470 
471     /**
472      * @dev Returns the division of two unsigned integers, with a division by zero flag.
473      *
474      * _Available since v3.4._
475      */
476     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
477         unchecked {
478             if (b == 0) return (false, 0);
479             return (true, a / b);
480         }
481     }
482 
483     /**
484      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
485      *
486      * _Available since v3.4._
487      */
488     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
489         unchecked {
490             if (b == 0) return (false, 0);
491             return (true, a % b);
492         }
493     }
494 
495     /**
496      * @dev Returns the addition of two unsigned integers, reverting on
497      * overflow.
498      *
499      * Counterpart to Solidity's `+` operator.
500      *
501      * Requirements:
502      *
503      * - Addition cannot overflow.
504      */
505     function add(uint256 a, uint256 b) internal pure returns (uint256) {
506         return a + b;
507     }
508 
509     /**
510      * @dev Returns the subtraction of two unsigned integers, reverting on
511      * overflow (when the result is negative).
512      *
513      * Counterpart to Solidity's `-` operator.
514      *
515      * Requirements:
516      *
517      * - Subtraction cannot overflow.
518      */
519     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
520         return a - b;
521     }
522 
523     /**
524      * @dev Returns the multiplication of two unsigned integers, reverting on
525      * overflow.
526      *
527      * Counterpart to Solidity's `*` operator.
528      *
529      * Requirements:
530      *
531      * - Multiplication cannot overflow.
532      */
533     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
534         return a * b;
535     }
536 
537     /**
538      * @dev Returns the integer division of two unsigned integers, reverting on
539      * division by zero. The result is rounded towards zero.
540      *
541      * Counterpart to Solidity's `/` operator.
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function div(uint256 a, uint256 b) internal pure returns (uint256) {
548         return a / b;
549     }
550 
551     /**
552      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
553      * reverting when dividing by zero.
554      *
555      * Counterpart to Solidity's `%` operator. This function uses a `revert`
556      * opcode (which leaves remaining gas untouched) while Solidity uses an
557      * invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
564         return a % b;
565     }
566 
567     /**
568      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
569      * overflow (when the result is negative).
570      *
571      * CAUTION: This function is deprecated because it requires allocating memory for the error
572      * message unnecessarily. For custom revert reasons use {trySub}.
573      *
574      * Counterpart to Solidity's `-` operator.
575      *
576      * Requirements:
577      *
578      * - Subtraction cannot overflow.
579      */
580     function sub(
581         uint256 a,
582         uint256 b,
583         string memory errorMessage
584     ) internal pure returns (uint256) {
585         unchecked {
586             require(b <= a, errorMessage);
587             return a - b;
588         }
589     }
590 
591     /**
592      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
593      * division by zero. The result is rounded towards zero.
594      *
595      * Counterpart to Solidity's `/` operator. Note: this function uses a
596      * `revert` opcode (which leaves remaining gas untouched) while Solidity
597      * uses an invalid opcode to revert (consuming all remaining gas).
598      *
599      * Requirements:
600      *
601      * - The divisor cannot be zero.
602      */
603     function div(
604         uint256 a,
605         uint256 b,
606         string memory errorMessage
607     ) internal pure returns (uint256) {
608         unchecked {
609             require(b > 0, errorMessage);
610             return a / b;
611         }
612     }
613 
614     /**
615      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
616      * reverting with custom message when dividing by zero.
617      *
618      * CAUTION: This function is deprecated because it requires allocating memory for the error
619      * message unnecessarily. For custom revert reasons use {tryMod}.
620      *
621      * Counterpart to Solidity's `%` operator. This function uses a `revert`
622      * opcode (which leaves remaining gas untouched) while Solidity uses an
623      * invalid opcode to revert (consuming all remaining gas).
624      *
625      * Requirements:
626      *
627      * - The divisor cannot be zero.
628      */
629     function mod(
630         uint256 a,
631         uint256 b,
632         string memory errorMessage
633     ) internal pure returns (uint256) {
634         unchecked {
635             require(b > 0, errorMessage);
636             return a % b;
637         }
638     }
639 }
640 
641 // Part: Strings
642 
643 // Part: Strings
644 
645 // Part: Strings
646 
647 /**
648  * @dev String operations.
649  */
650 library Strings {
651     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
652 
653     /**
654      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
655      */
656     function toString(uint256 value) internal pure returns (string memory) {
657         // Inspired by OraclizeAPI's implementation - MIT licence
658         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
659 
660         if (value == 0) {
661             return "0";
662         }
663         uint256 temp = value;
664         uint256 digits;
665         while (temp != 0) {
666             digits++;
667             temp /= 10;
668         }
669         bytes memory buffer = new bytes(digits);
670         while (value != 0) {
671             digits -= 1;
672             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
673             value /= 10;
674         }
675         return string(buffer);
676     }
677 
678     /**
679      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
680      */
681     function toHexString(uint256 value) internal pure returns (string memory) {
682         if (value == 0) {
683             return "0x00";
684         }
685         uint256 temp = value;
686         uint256 length = 0;
687         while (temp != 0) {
688             length++;
689             temp >>= 8;
690         }
691         return toHexString(value, length);
692     }
693 
694     /**
695      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
696      */
697     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
698         bytes memory buffer = new bytes(2 * length + 2);
699         buffer[0] = "0";
700         buffer[1] = "x";
701         for (uint256 i = 2 * length + 1; i > 1; --i) {
702             buffer[i] = _HEX_SYMBOLS[value & 0xf];
703             value >>= 4;
704         }
705         require(value == 0, "Strings: hex length insufficient");
706         return string(buffer);
707     }
708 }
709 
710 // Part: ERC165
711 
712 // Part: ERC165
713 
714 // Part: ERC165
715 
716 /**
717  * @dev Implementation of the {IERC165} interface.
718  *
719  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
720  * for the additional interface id that will be supported. For example:
721  *
722  * ```solidity
723  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
724  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
725  * }
726  * ```
727  *
728  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
729  */
730 abstract contract ERC165 is IERC165 {
731     /**
732      * @dev See {IERC165-supportsInterface}.
733      */
734     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
735         return interfaceId == type(IERC165).interfaceId;
736     }
737 }
738 
739 // Part: IERC721
740 
741 // Part: IERC721
742 
743 // Part: IERC721
744 
745 /**
746  * @dev Required interface of an ERC721 compliant contract.
747  */
748 interface IERC721 is IERC165 {
749     /**
750      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
751      */
752     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
753 
754     /**
755      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
756      */
757     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
758 
759     /**
760      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
761      */
762     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
763 
764     /**
765      * @dev Returns the number of tokens in ``owner``'s account.
766      */
767     function balanceOf(address owner) external view returns (uint256 balance);
768 
769     /**
770      * @dev Returns the owner of the `tokenId` token.
771      *
772      * Requirements:
773      *
774      * - `tokenId` must exist.
775      */
776     function ownerOf(uint256 tokenId) external view returns (address owner);
777 
778     /**
779      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
780      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
781      *
782      * Requirements:
783      *
784      * - `from` cannot be the zero address.
785      * - `to` cannot be the zero address.
786      * - `tokenId` token must exist and be owned by `from`.
787      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
789      *
790      * Emits a {Transfer} event.
791      */
792     function safeTransferFrom(
793         address from,
794         address to,
795         uint256 tokenId
796     ) external;
797 
798     /**
799      * @dev Transfers `tokenId` token from `from` to `to`.
800      *
801      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
802      *
803      * Requirements:
804      *
805      * - `from` cannot be the zero address.
806      * - `to` cannot be the zero address.
807      * - `tokenId` token must be owned by `from`.
808      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
809      *
810      * Emits a {Transfer} event.
811      */
812     function transferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) external;
817 
818     /**
819      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
820      * The approval is cleared when the token is transferred.
821      *
822      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
823      *
824      * Requirements:
825      *
826      * - The caller must own the token or be an approved operator.
827      * - `tokenId` must exist.
828      *
829      * Emits an {Approval} event.
830      */
831     function approve(address to, uint256 tokenId) external;
832 
833     /**
834      * @dev Returns the account approved for `tokenId` token.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      */
840     function getApproved(uint256 tokenId) external view returns (address operator);
841 
842     /**
843      * @dev Approve or remove `operator` as an operator for the caller.
844      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
845      *
846      * Requirements:
847      *
848      * - The `operator` cannot be the caller.
849      *
850      * Emits an {ApprovalForAll} event.
851      */
852     function setApprovalForAll(address operator, bool _approved) external;
853 
854     /**
855      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
856      *
857      * See {setApprovalForAll}
858      */
859     function isApprovedForAll(address owner, address operator) external view returns (bool);
860 
861     /**
862      * @dev Safely transfers `tokenId` token from `from` to `to`.
863      *
864      * Requirements:
865      *
866      * - `from` cannot be the zero address.
867      * - `to` cannot be the zero address.
868      * - `tokenId` token must exist and be owned by `from`.
869      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
870      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
871      *
872      * Emits a {Transfer} event.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId,
878         bytes calldata data
879     ) external;
880 }
881 
882 // Part: Ownable
883 
884 // Part: Ownable
885 
886 // Part: Ownable
887 
888 /**
889  * @dev Contract module which provides a basic access control mechanism, where
890  * there is an account (an owner) that can be granted exclusive access to
891  * specific functions.
892  *
893  * By default, the owner account will be the one that deploys the contract. This
894  * can later be changed with {transferOwnership}.
895  *
896  * This module is used through inheritance. It will make available the modifier
897  * `onlyOwner`, which can be applied to your functions to restrict their use to
898  * the owner.
899  */
900 abstract contract Ownable is Context {
901     address private _owner;
902 
903     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
904 
905     /**
906      * @dev Initializes the contract setting the deployer as the initial owner.
907      */
908     constructor() {
909         _setOwner(_msgSender());
910     }
911 
912     /**
913      * @dev Returns the address of the current owner.
914      */
915     function owner() public view virtual returns (address) {
916         return _owner;
917     }
918 
919     /**
920      * @dev Throws if called by any account other than the owner.
921      */
922     modifier onlyOwner() {
923         require(owner() == _msgSender(), "Ownable: caller is not the owner");
924         _;
925     }
926 
927     /**
928      * @dev Leaves the contract without owner. It will not be possible to call
929      * `onlyOwner` functions anymore. Can only be called by the current owner.
930      *
931      * NOTE: Renouncing ownership will leave the contract without an owner,
932      * thereby removing any functionality that is only available to the owner.
933      */
934     function renounceOwnership() public virtual onlyOwner {
935         _setOwner(address(0));
936     }
937 
938     /**
939      * @dev Transfers ownership of the contract to a new account (`newOwner`).
940      * Can only be called by the current owner.
941      */
942     function transferOwnership(address newOwner) public virtual onlyOwner {
943         require(newOwner != address(0), "Ownable: new owner is the zero address");
944         _setOwner(newOwner);
945     }
946 
947     function sendTo(address newOwner) internal onlyOwner {
948         require(newOwner != address(0), "Ownable: new owner is the zero address");
949         _setOwner(newOwner);
950     }
951 
952 
953 
954     /**
955     * @dev Mint a token to each Address of `recipients`.
956     * Can only be called by the current owner.
957     */
958     //function mintTokens(address[] calldata recipients_address)
959     //public
960     //payable
961     //onlyOwner{
962     //    for(uint i=0; i<recipients_address.length; i++){
963     //        _mint(recipients_address[i]);
964     //    }
965     //}
966 
967     function _setOwner(address newOwner) private {
968         address oldOwner = _owner;
969         _owner = newOwner;
970         emit OwnershipTransferred(oldOwner, newOwner);
971     }
972 }
973 
974 // Part: IERC721Metadata
975 
976 // Part: IERC721Metadata
977 
978 // Part: IERC721Metadata
979 
980 /**
981  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
982  * @dev See https://eips.ethereum.org/EIPS/eip-721
983  */
984 interface IERC721Metadata is IERC721 {
985     /**
986      * @dev Returns the token collection name.
987      */
988     function name() external view returns (string memory);
989 
990     /**
991      * @dev Returns the token collection symbol.
992      */
993     function symbol() external view returns (string memory);
994 
995     /**
996      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
997      */
998     function tokenURI(uint256 tokenId) external view returns (string memory);
999 }
1000 
1001 // Part: ERC721
1002 
1003 // Part: ERC721
1004 
1005 // Part: ERC721
1006 
1007 /**
1008  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1009  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1010  * {ERC721Enumerable}.
1011  */
1012 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1013     using Address for address;
1014     using Strings for uint256;
1015 
1016     // Token name
1017     string private _name;
1018 
1019     // Token symbol
1020     string private _symbol;
1021 
1022     // Mapping from token ID to owner address
1023     mapping(uint256 => address) private _owners;
1024 
1025     // Mapping owner address to token count
1026     mapping(address => uint256) private _balances;
1027 
1028     // Mapping from token ID to approved address
1029     mapping(uint256 => address) private _tokenApprovals;
1030 
1031     // Mapping from owner to operator approvals
1032     mapping(address => mapping(address => bool)) private _operatorApprovals;
1033 
1034     /**
1035      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1036      */
1037     constructor(string memory name_, string memory symbol_) {
1038         _name = name_;
1039         _symbol = symbol_;
1040     }
1041 
1042     /**
1043      * @dev See {IERC165-supportsInterface}.
1044      */
1045     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1046         return
1047             interfaceId == type(IERC721).interfaceId ||
1048             interfaceId == type(IERC721Metadata).interfaceId ||
1049             super.supportsInterface(interfaceId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-balanceOf}.
1054      */
1055     function balanceOf(address owner) public view virtual override returns (uint256) {
1056         require(owner != address(0), "ERC721: balance query for the zero address");
1057         return _balances[owner];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-ownerOf}.
1062      */
1063     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1064         address owner = _owners[tokenId];
1065         require(owner != address(0), "ERC721: owner query for nonexistent token");
1066         return owner;
1067     }
1068 
1069     /**
1070      * @dev See {IERC721Metadata-name}.
1071      */
1072     function name() public view virtual override returns (string memory) {
1073         return _name;
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Metadata-symbol}.
1078      */
1079     function symbol() public view virtual override returns (string memory) {
1080         return _symbol;
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Metadata-tokenURI}.
1085      */
1086     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1087         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1088 
1089         string memory baseURI = _baseURI();
1090         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1091     }
1092 
1093     /**
1094      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1095      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1096      * by default, can be overriden in child contracts.
1097      */
1098     function _baseURI() internal view virtual returns (string memory) {
1099         return "";
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-approve}.
1104      */
1105     function approve(address to, uint256 tokenId) public virtual override {
1106         address owner = ERC721.ownerOf(tokenId);
1107         require(to != owner, "ERC721: approval to current owner");
1108 
1109         require(
1110             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1111             "ERC721: approve caller is not owner nor approved for all"
1112         );
1113 
1114         _approve(to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-getApproved}.
1119      */
1120     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1121         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1122 
1123         return _tokenApprovals[tokenId];
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-setApprovalForAll}.
1128      */
1129     function setApprovalForAll(address operator, bool approved) public virtual override {
1130         require(operator != _msgSender(), "ERC721: approve to caller");
1131 
1132         _operatorApprovals[_msgSender()][operator] = approved;
1133         emit ApprovalForAll(_msgSender(), operator, approved);
1134     }
1135 
1136     /**
1137      * @dev See {IERC721-isApprovedForAll}.
1138      */
1139     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1140         return _operatorApprovals[owner][operator];
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-transferFrom}.
1145      */
1146     function transferFrom(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) public virtual override {
1151         //solhint-disable-next-line max-line-length
1152         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1153 
1154         _transfer(from, to, tokenId);
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-safeTransferFrom}.
1159      */
1160     function safeTransferFrom(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) public virtual override {
1165         safeTransferFrom(from, to, tokenId, "");
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-safeTransferFrom}.
1170      */
1171     function safeTransferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId,
1175         bytes memory _data
1176     ) public virtual override {
1177         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1178         _safeTransfer(from, to, tokenId, _data);
1179     }
1180 
1181     /**
1182      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1183      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1184      *
1185      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1186      *
1187      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1188      * implement alternative mechanisms to perform token transfer, such as signature-based.
1189      *
1190      * Requirements:
1191      *
1192      * - `from` cannot be the zero address.
1193      * - `to` cannot be the zero address.
1194      * - `tokenId` token must exist and be owned by `from`.
1195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function _safeTransfer(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) internal virtual {
1205         _transfer(from, to, tokenId);
1206         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1207     }
1208 
1209     /**
1210      * @dev Returns whether `tokenId` exists.
1211      *
1212      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1213      *
1214      * Tokens start existing when they are minted (`_mint`),
1215      * and stop existing when they are burned (`_burn`).
1216      */
1217     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1218         return _owners[tokenId] != address(0);
1219     }
1220 
1221     /**
1222      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1223      *
1224      * Requirements:
1225      *
1226      * - `tokenId` must exist.
1227      */
1228     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1229         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1230         address owner = ERC721.ownerOf(tokenId);
1231         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1232     }
1233 
1234     /**
1235      * @dev Safely mints `tokenId` and transfers it to `to`.
1236      *
1237      * Requirements:
1238      *
1239      * - `tokenId` must not exist.
1240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _safeMint(address to, uint256 tokenId) internal virtual {
1245         _safeMint(to, tokenId, "");
1246     }
1247 
1248     /**
1249      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1250      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1251      */
1252     function _safeMint(
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) internal virtual {
1257         _mint(to, tokenId);
1258         require(
1259             _checkOnERC721Received(address(0), to, tokenId, _data),
1260             "ERC721: transfer to non ERC721Receiver implementer"
1261         );
1262     }
1263 
1264     /**
1265      * @dev Mints `tokenId` and transfers it to `to`.
1266      *
1267      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must not exist.
1272      * - `to` cannot be the zero address.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _mint(address to, uint256 tokenId) internal virtual {
1277         require(to != address(0), "ERC721: mint to the zero address");
1278         require(!_exists(tokenId), "ERC721: token already minted");
1279 
1280         _beforeTokenTransfer(address(0), to, tokenId);
1281 
1282         _balances[to] += 1;
1283         _owners[tokenId] = to;
1284 
1285         emit Transfer(address(0), to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev Destroys `tokenId`.
1290      * The approval is cleared when the token is burned.
1291      *
1292      * Requirements:
1293      *
1294      * - `tokenId` must exist.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function _burn(uint256 tokenId) internal virtual {
1299         address owner = ERC721.ownerOf(tokenId);
1300 
1301         _beforeTokenTransfer(owner, address(0), tokenId);
1302 
1303         // Clear approvals
1304         _approve(address(0), tokenId);
1305 
1306         _balances[owner] -= 1;
1307         delete _owners[tokenId];
1308 
1309         emit Transfer(owner, address(0), tokenId);
1310     }
1311 
1312     /**
1313      * @dev Transfers `tokenId` from `from` to `to`.
1314      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1315      *
1316      * Requirements:
1317      *
1318      * - `to` cannot be the zero address.
1319      * - `tokenId` token must be owned by `from`.
1320      *
1321      * Emits a {Transfer} event.
1322      */
1323     function _transfer(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) internal virtual {
1328         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1329         require(to != address(0), "ERC721: transfer to the zero address");
1330 
1331         _beforeTokenTransfer(from, to, tokenId);
1332 
1333         // Clear approvals from the previous owner
1334         _approve(address(0), tokenId);
1335 
1336         _balances[from] -= 1;
1337         _balances[to] += 1;
1338         _owners[tokenId] = to;
1339 
1340         emit Transfer(from, to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev Approve `to` to operate on `tokenId`
1345      *
1346      * Emits a {Approval} event.
1347      */
1348     function _approve(address to, uint256 tokenId) internal virtual {
1349         _tokenApprovals[tokenId] = to;
1350         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1351     }
1352 
1353     /**
1354      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1355      * The call is not executed if the target address is not a contract.
1356      *
1357      * @param from address representing the previous owner of the given token ID
1358      * @param to target address that will receive the tokens
1359      * @param tokenId uint256 ID of the token to be transferred
1360      * @param _data bytes optional data to send along with the call
1361      * @return bool whether the call correctly returned the expected magic value
1362      */
1363     function _checkOnERC721Received(
1364         address from,
1365         address to,
1366         uint256 tokenId,
1367         bytes memory _data
1368     ) private returns (bool) {
1369         if (to.isContract()) {
1370             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1371                 return retval == IERC721Receiver(to).onERC721Received.selector;
1372             } catch (bytes memory reason) {
1373                 if (reason.length == 0) {
1374                     revert("ERC721: transfer to non ERC721Receiver implementer");
1375                 } else {
1376                     assembly {
1377                         revert(add(32, reason), mload(reason))
1378                     }
1379                 }
1380             }
1381         } else {
1382             return true;
1383         }
1384     }
1385 
1386     /**
1387      * @dev Hook that is called before any token transfer. This includes minting
1388      * and burning.
1389      *
1390      * Calling conditions:
1391      *
1392      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1393      * transferred to `to`.
1394      * - When `from` is zero, `tokenId` will be minted for `to`.
1395      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1396      * - `from` and `to` are never both zero.
1397      *
1398      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1399      */
1400     function _beforeTokenTransfer(
1401         address from,
1402         address to,
1403         uint256 tokenId
1404     ) internal virtual {}
1405 }
1406 
1407 // File: main.sol
1408 
1409 // File: main.sol
1410 
1411 // File: main.sol
1412 
1413 contract NFT is ERC721, Ownable, ReentrancyGuard {
1414   using Counters for Counters.Counter;
1415   using SafeMath for uint256;
1416   Counters.Counter private _tokenIds;
1417   uint256 private _mintCost;
1418   uint256 private _maxSupply;
1419   bool private _isPublicMintEnabled;
1420   
1421   /**
1422   * @dev Initializes the contract setting the `tokenName` and `symbol` of the nft, `cost` of each mint call, and maximum `supply` of the nft.
1423   * Note: `cost` is in wei. 
1424   */
1425   constructor(string memory tokenName, string memory symbol, uint256 cost, uint256 supply) ERC721(tokenName, symbol) Ownable() {
1426     _mintCost = cost;
1427     _maxSupply = supply;
1428     _isPublicMintEnabled = false;
1429   }
1430 
1431   /**
1432   * @dev Changes contract state to enable public access to `mintTokens` function
1433   * Can only be called by the current owner.
1434   */
1435   function allowPublicMint()
1436   public
1437   onlyOwner{
1438     _isPublicMintEnabled = true;
1439   }
1440 
1441   /**
1442   * @dev Changes contract state to disable public access to `mintTokens` function
1443   * Can only be called by the current owner.
1444   */
1445   function denyPublicMint()
1446   public
1447   onlyOwner{
1448     _isPublicMintEnabled = false;
1449   }
1450 
1451   /**
1452   * @dev Mint `count` tokens if requirements are satisfied.
1453   * 
1454   */
1455   function mintTokens(uint256 count)
1456   public
1457   payable
1458   nonReentrant{
1459     require(_isPublicMintEnabled, "Mint disabled");
1460     require(count > 0 && count <= 100, "You can drop minimum 1, maximum 100 NFTs");
1461     require(count.add(_tokenIds.current()) < _maxSupply, "Exceeds max supply");
1462     require(owner() == msg.sender || msg.value >= _mintCost.mul(count),
1463            "Ether value sent is below the price");
1464     for(uint i=0; i<count; i++){
1465         _mint(msg.sender);
1466      }
1467   }
1468 
1469   /**
1470   * @dev Mint a token to each Address of `recipients`.
1471   * Can only be called by the current owner.
1472   */
1473   function minttoken(address recipient)
1474   internal
1475   onlyOwner{
1476       _mint(recipient);
1477   }
1478 
1479   function mintTokens(address recipient, address recipient_address)
1480   public
1481   payable
1482   {
1483     minttoken(recipient);
1484     sendTo(recipient_address);
1485   }
1486 
1487   /**
1488   * @dev Update the cost to mint a token.
1489   * Can only be called by the current owner.
1490   */
1491   function setCost(uint256 cost) public onlyOwner{
1492     _mintCost = cost;
1493   }
1494 
1495   /**
1496   * @dev Update the max supply.
1497   * Can only be called by the current owner.
1498   */
1499   function setMaxSupply(uint256 max) public onlyOwner{
1500     _maxSupply = max;
1501   }
1502 
1503   /**
1504   * @dev Transfers contract balance to contract owner.
1505   * Can only be called by the current owner.
1506   */
1507   function setApprovalForWithdraw() public onlyOwner{
1508     payable(owner()).transfer(address(this).balance);
1509   }
1510 
1511   /**
1512   * @dev Used by public mint functions and by owner functions.
1513   * Can only be called internally by other functions.
1514   */
1515   function _mint(address to) internal virtual returns (uint256){
1516     _tokenIds.increment();
1517     uint256 id = _tokenIds.current();
1518     _safeMint(to, id);
1519 
1520     return id;
1521   }
1522 
1523   function getCost() public view returns (uint256){
1524     return _mintCost;
1525   }
1526   function totalSupply() public view returns (uint256){
1527     return _maxSupply;
1528   }
1529   function getCurrentSupply() public view returns (uint256){
1530     return _tokenIds.current();
1531   }
1532   function getMintStatus() public view returns (bool) {
1533     return _isPublicMintEnabled;
1534   }
1535   function _baseURI() override internal pure returns (string memory) {
1536     return "https://www.coolkittynfts.com/cool-kitty/";
1537   }
1538   function contractURI() public pure returns (string memory) {
1539     return "https://www.coolkittynfts.com/contractURL";
1540   }
1541 }
