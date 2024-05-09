1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 
6 /**
7  * @dev Collection of functions related to the address type
8  */
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      * ====
26      */
27     function isContract(address account) internal view returns (bool) {
28         // This method relies on extcodesize, which returns 0 for contracts in
29         // construction, since the code is only stored at the end of the
30         // constructor execution.
31 
32         uint256 size;
33         assembly {
34             size := extcodesize(account)
35         }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         (bool success, ) = recipient.call{value: amount}("");
59         require(success, "Address: unable to send value, recipient may have reverted");
60     }
61 
62     /**
63      * @dev Performs a Solidity function call using a low level `call`. A
64      * plain `call` is an unsafe replacement for a function call: use this
65      * function instead.
66      *
67      * If `target` reverts with a revert reason, it is bubbled up by this
68      * function (like regular Solidity function calls).
69      *
70      * Returns the raw returned data. To convert to the expected return value,
71      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
72      *
73      * Requirements:
74      *
75      * - `target` must be a contract.
76      * - calling `target` with `data` must not revert.
77      *
78      * _Available since v3.1._
79      */
80     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
81         return functionCall(target, data, "Address: low-level call failed");
82     }
83 
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(
91         address target,
92         bytes memory data,
93         string memory errorMessage
94     ) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
100      * but also transferring `value` wei to `target`.
101      *
102      * Requirements:
103      *
104      * - the calling contract must have an ETH balance of at least `value`.
105      * - the called Solidity function must be `payable`.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint256 value
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
119      * with `errorMessage` as a fallback revert reason when `target` reverts.
120      *
121      * _Available since v3.1._
122      */
123     function functionCallWithValue(
124         address target,
125         bytes memory data,
126         uint256 value,
127         string memory errorMessage
128     ) internal returns (bytes memory) {
129         require(address(this).balance >= value, "Address: insufficient balance for call");
130         require(isContract(target), "Address: call to non-contract");
131 
132         (bool success, bytes memory returndata) = target.call{value: value}(data);
133         return _verifyCallResult(success, returndata, errorMessage);
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
138      * but performing a static call.
139      *
140      * _Available since v3.3._
141      */
142     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
143         return functionStaticCall(target, data, "Address: low-level static call failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(
153         address target,
154         bytes memory data,
155         string memory errorMessage
156     ) internal view returns (bytes memory) {
157         require(isContract(target), "Address: static call to non-contract");
158 
159         (bool success, bytes memory returndata) = target.staticcall(data);
160         return _verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but performing a delegate call.
166      *
167      * _Available since v3.4._
168      */
169     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         require(isContract(target), "Address: delegate call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.delegatecall(data);
187         return _verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     function _verifyCallResult(
191         bool success,
192         bytes memory returndata,
193         string memory errorMessage
194     ) private pure returns (bytes memory) {
195         if (success) {
196             return returndata;
197         } else {
198             // Look for revert reason and bubble it up if present
199             if (returndata.length > 0) {
200                 // The easiest way to bubble the revert reason is using memory via assembly
201 
202                 assembly {
203                     let returndata_size := mload(returndata)
204                     revert(add(32, returndata), returndata_size)
205                 }
206             } else {
207                 revert(errorMessage);
208             }
209         }
210     }
211 }
212 
213 
214 
215 
216 
217 
218 
219 /*
220  * @dev Provides information about the current execution context, including the
221  * sender of the transaction and its data. While these are generally available
222  * via msg.sender and msg.data, they should not be accessed in such a direct
223  * manner, since when dealing with meta-transactions the account sending and
224  * paying for execution may not be the actual sender (as far as an application
225  * is concerned).
226  *
227  * This contract is only required for intermediate, library-like contracts.
228  */
229 abstract contract Context {
230     function _msgSender() internal view virtual returns (address) {
231         return msg.sender;
232     }
233 
234     function _msgData() internal view virtual returns (bytes calldata) {
235         return msg.data;
236     }
237 }
238 
239 
240 
241 
242 
243 
244 
245 /**
246  * @title Counters
247  * @author Matt Condon (@shrugs)
248  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
249  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
250  *
251  * Include with `using Counters for Counters.Counter;`
252  */
253 library Counters {
254     struct Counter {
255         // This variable should never be directly accessed by users of the library: interactions must be restricted to
256         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
257         // this feature: see https://github.com/ethereum/solidity/issues/4637
258         uint256 _value; // default: 0
259     }
260 
261     function current(Counter storage counter) internal view returns (uint256) {
262         return counter._value;
263     }
264 
265     function increment(Counter storage counter) internal {
266         unchecked {
267             counter._value += 1;
268         }
269     }
270 
271     function decrement(Counter storage counter) internal {
272         uint256 value = counter._value;
273         require(value > 0, "Counter: decrement overflow");
274         unchecked {
275             counter._value = value - 1;
276         }
277     }
278 
279     function reset(Counter storage counter) internal {
280         counter._value = 0;
281     }
282 }
283 
284 
285 
286 
287 
288 
289 
290 /**
291  * @dev Interface of the ERC165 standard, as defined in the
292  * https://eips.ethereum.org/EIPS/eip-165[EIP].
293  *
294  * Implementers can declare support of contract interfaces, which can then be
295  * queried by others ({ERC165Checker}).
296  *
297  * For an implementation, see {ERC165}.
298  */
299 interface IERC165 {
300     /**
301      * @dev Returns true if this contract implements the interface defined by
302      * `interfaceId`. See the corresponding
303      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
304      * to learn more about how these ids are created.
305      *
306      * This function call must use less than 30 000 gas.
307      */
308     function supportsInterface(bytes4 interfaceId) external view returns (bool);
309 }
310 
311 
312 
313 
314 
315 
316 
317 /**
318  * @title ERC721 token receiver interface
319  * @dev Interface for any contract that wants to support safeTransfers
320  * from ERC721 asset contracts.
321  */
322 interface IERC721Receiver {
323     /**
324      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
325      * by `operator` from `from`, this function is called.
326      *
327      * It must return its Solidity selector to confirm the token transfer.
328      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
329      *
330      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
331      */
332     function onERC721Received(
333         address operator,
334         address from,
335         uint256 tokenId,
336         bytes calldata data
337     ) external returns (bytes4);
338 }
339 
340 
341 
342 
343 
344 
345 
346 /**
347  * @dev Contract module that helps prevent reentrant calls to a function.
348  *
349  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
350  * available, which can be applied to functions to make sure there are no nested
351  * (reentrant) calls to them.
352  *
353  * Note that because there is a single `nonReentrant` guard, functions marked as
354  * `nonReentrant` may not call one another. This can be worked around by making
355  * those functions `private`, and then adding `external` `nonReentrant` entry
356  * points to them.
357  *
358  * TIP: If you would like to learn more about reentrancy and alternative ways
359  * to protect against it, check out our blog post
360  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
361  */
362 abstract contract ReentrancyGuard {
363     // Booleans are more expensive than uint256 or any type that takes up a full
364     // word because each write operation emits an extra SLOAD to first read the
365     // slot's contents, replace the bits taken up by the boolean, and then write
366     // back. This is the compiler's defense against contract upgrades and
367     // pointer aliasing, and it cannot be disabled.
368 
369     // The values being non-zero value makes deployment a bit more expensive,
370     // but in exchange the refund on every call to nonReentrant will be lower in
371     // amount. Since refunds are capped to a percentage of the total
372     // transaction's gas, it is best to keep them low in cases like this one, to
373     // increase the likelihood of the full refund coming into effect.
374     uint256 private constant _NOT_ENTERED = 1;
375     uint256 private constant _ENTERED = 2;
376 
377     uint256 private _status;
378 
379     constructor() {
380         _status = _NOT_ENTERED;
381     }
382 
383     /**
384      * @dev Prevents a contract from calling itself, directly or indirectly.
385      * Calling a `nonReentrant` function from another `nonReentrant`
386      * function is not supported. It is possible to prevent this from happening
387      * by making the `nonReentrant` function external, and make it call a
388      * `private` function that does the actual work.
389      */
390     modifier nonReentrant() {
391         // On the first call to nonReentrant, _notEntered will be true
392         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
393 
394         // Any calls to nonReentrant after this point will fail
395         _status = _ENTERED;
396 
397         _;
398 
399         // By storing the original value once again, a refund is triggered (see
400         // https://eips.ethereum.org/EIPS/eip-2200)
401         _status = _NOT_ENTERED;
402     }
403 }
404 
405 
406 
407 
408 
409 
410 
411 // CAUTION
412 // This version of SafeMath should only be used with Solidity 0.8 or later,
413 // because it relies on the compiler's built in overflow checks.
414 
415 /**
416  * @dev Wrappers over Solidity's arithmetic operations.
417  *
418  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
419  * now has built in overflow checking.
420  */
421 library SafeMath {
422     /**
423      * @dev Returns the addition of two unsigned integers, with an overflow flag.
424      *
425      * _Available since v3.4._
426      */
427     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
428         unchecked {
429             uint256 c = a + b;
430             if (c < a) return (false, 0);
431             return (true, c);
432         }
433     }
434 
435     /**
436      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
437      *
438      * _Available since v3.4._
439      */
440     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
441         unchecked {
442             if (b > a) return (false, 0);
443             return (true, a - b);
444         }
445     }
446 
447     /**
448      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
449      *
450      * _Available since v3.4._
451      */
452     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
453         unchecked {
454             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
455             // benefit is lost if 'b' is also tested.
456             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
457             if (a == 0) return (true, 0);
458             uint256 c = a * b;
459             if (c / a != b) return (false, 0);
460             return (true, c);
461         }
462     }
463 
464     /**
465      * @dev Returns the division of two unsigned integers, with a division by zero flag.
466      *
467      * _Available since v3.4._
468      */
469     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
470         unchecked {
471             if (b == 0) return (false, 0);
472             return (true, a / b);
473         }
474     }
475 
476     /**
477      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
478      *
479      * _Available since v3.4._
480      */
481     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
482         unchecked {
483             if (b == 0) return (false, 0);
484             return (true, a % b);
485         }
486     }
487 
488     /**
489      * @dev Returns the addition of two unsigned integers, reverting on
490      * overflow.
491      *
492      * Counterpart to Solidity's `+` operator.
493      *
494      * Requirements:
495      *
496      * - Addition cannot overflow.
497      */
498     function add(uint256 a, uint256 b) internal pure returns (uint256) {
499         return a + b;
500     }
501 
502     /**
503      * @dev Returns the subtraction of two unsigned integers, reverting on
504      * overflow (when the result is negative).
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
513         return a - b;
514     }
515 
516     /**
517      * @dev Returns the multiplication of two unsigned integers, reverting on
518      * overflow.
519      *
520      * Counterpart to Solidity's `*` operator.
521      *
522      * Requirements:
523      *
524      * - Multiplication cannot overflow.
525      */
526     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
527         return a * b;
528     }
529 
530     /**
531      * @dev Returns the integer division of two unsigned integers, reverting on
532      * division by zero. The result is rounded towards zero.
533      *
534      * Counterpart to Solidity's `/` operator.
535      *
536      * Requirements:
537      *
538      * - The divisor cannot be zero.
539      */
540     function div(uint256 a, uint256 b) internal pure returns (uint256) {
541         return a / b;
542     }
543 
544     /**
545      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
546      * reverting when dividing by zero.
547      *
548      * Counterpart to Solidity's `%` operator. This function uses a `revert`
549      * opcode (which leaves remaining gas untouched) while Solidity uses an
550      * invalid opcode to revert (consuming all remaining gas).
551      *
552      * Requirements:
553      *
554      * - The divisor cannot be zero.
555      */
556     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
557         return a % b;
558     }
559 
560     /**
561      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
562      * overflow (when the result is negative).
563      *
564      * CAUTION: This function is deprecated because it requires allocating memory for the error
565      * message unnecessarily. For custom revert reasons use {trySub}.
566      *
567      * Counterpart to Solidity's `-` operator.
568      *
569      * Requirements:
570      *
571      * - Subtraction cannot overflow.
572      */
573     function sub(
574         uint256 a,
575         uint256 b,
576         string memory errorMessage
577     ) internal pure returns (uint256) {
578         unchecked {
579             require(b <= a, errorMessage);
580             return a - b;
581         }
582     }
583 
584     /**
585      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
586      * division by zero. The result is rounded towards zero.
587      *
588      * Counterpart to Solidity's `/` operator. Note: this function uses a
589      * `revert` opcode (which leaves remaining gas untouched) while Solidity
590      * uses an invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function div(
597         uint256 a,
598         uint256 b,
599         string memory errorMessage
600     ) internal pure returns (uint256) {
601         unchecked {
602             require(b > 0, errorMessage);
603             return a / b;
604         }
605     }
606 
607     /**
608      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
609      * reverting with custom message when dividing by zero.
610      *
611      * CAUTION: This function is deprecated because it requires allocating memory for the error
612      * message unnecessarily. For custom revert reasons use {tryMod}.
613      *
614      * Counterpart to Solidity's `%` operator. This function uses a `revert`
615      * opcode (which leaves remaining gas untouched) while Solidity uses an
616      * invalid opcode to revert (consuming all remaining gas).
617      *
618      * Requirements:
619      *
620      * - The divisor cannot be zero.
621      */
622     function mod(
623         uint256 a,
624         uint256 b,
625         string memory errorMessage
626     ) internal pure returns (uint256) {
627         unchecked {
628             require(b > 0, errorMessage);
629             return a % b;
630         }
631     }
632 }
633 
634 
635 
636 
637 
638 
639 
640 /**
641  * @dev String operations.
642  */
643 library Strings {
644     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
645 
646     /**
647      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
648      */
649     function toString(uint256 value) internal pure returns (string memory) {
650         // Inspired by OraclizeAPI's implementation - MIT licence
651         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
652 
653         if (value == 0) {
654             return "0";
655         }
656         uint256 temp = value;
657         uint256 digits;
658         while (temp != 0) {
659             digits++;
660             temp /= 10;
661         }
662         bytes memory buffer = new bytes(digits);
663         while (value != 0) {
664             digits -= 1;
665             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
666             value /= 10;
667         }
668         return string(buffer);
669     }
670 
671     /**
672      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
673      */
674     function toHexString(uint256 value) internal pure returns (string memory) {
675         if (value == 0) {
676             return "0x00";
677         }
678         uint256 temp = value;
679         uint256 length = 0;
680         while (temp != 0) {
681             length++;
682             temp >>= 8;
683         }
684         return toHexString(value, length);
685     }
686 
687     /**
688      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
689      */
690     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
691         bytes memory buffer = new bytes(2 * length + 2);
692         buffer[0] = "0";
693         buffer[1] = "x";
694         for (uint256 i = 2 * length + 1; i > 1; --i) {
695             buffer[i] = _HEX_SYMBOLS[value & 0xf];
696             value >>= 4;
697         }
698         require(value == 0, "Strings: hex length insufficient");
699         return string(buffer);
700     }
701 }
702 
703 
704 
705 
706 
707 
708 
709 /**
710  * @dev Implementation of the {IERC165} interface.
711  *
712  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
713  * for the additional interface id that will be supported. For example:
714  *
715  * ```solidity
716  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
718  * }
719  * ```
720  *
721  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
722  */
723 abstract contract ERC165 is IERC165 {
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
728         return interfaceId == type(IERC165).interfaceId;
729     }
730 }
731 
732 // Part: IERC721
733 
734 // Part: IERC721
735 
736 // Part: IERC721
737 
738 /**
739  * @dev Required interface of an ERC721 compliant contract.
740  */
741 interface IERC721 is IERC165 {
742     /**
743      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
744      */
745     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
746 
747     /**
748      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
749      */
750     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
751 
752     /**
753      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
754      */
755     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
756 
757     /**
758      * @dev Returns the number of tokens in ``owner``'s account.
759      */
760     function balanceOf(address owner) external view returns (uint256 balance);
761 
762     /**
763      * @dev Returns the owner of the `tokenId` token.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must exist.
768      */
769     function ownerOf(uint256 tokenId) external view returns (address owner);
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
773      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
774      *
775      * Requirements:
776      *
777      * - `from` cannot be the zero address.
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must exist and be owned by `from`.
780      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) external;
790 
791     /**
792      * @dev Transfers `tokenId` token from `from` to `to`.
793      *
794      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
795      *
796      * Requirements:
797      *
798      * - `from` cannot be the zero address.
799      * - `to` cannot be the zero address.
800      * - `tokenId` token must be owned by `from`.
801      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
802      *
803      * Emits a {Transfer} event.
804      */
805     function transferFrom(
806         address from,
807         address to,
808         uint256 tokenId
809     ) external;
810 
811     /**
812      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
813      * The approval is cleared when the token is transferred.
814      *
815      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
816      *
817      * Requirements:
818      *
819      * - The caller must own the token or be an approved operator.
820      * - `tokenId` must exist.
821      *
822      * Emits an {Approval} event.
823      */
824     function approve(address to, uint256 tokenId) external;
825 
826     /**
827      * @dev Returns the account approved for `tokenId` token.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must exist.
832      */
833     function getApproved(uint256 tokenId) external view returns (address operator);
834 
835     /**
836      * @dev Approve or remove `operator` as an operator for the caller.
837      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
838      *
839      * Requirements:
840      *
841      * - The `operator` cannot be the caller.
842      *
843      * Emits an {ApprovalForAll} event.
844      */
845     function setApprovalForAll(address operator, bool _approved) external;
846 
847     /**
848      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
849      *
850      * See {setApprovalForAll}
851      */
852     function isApprovedForAll(address owner, address operator) external view returns (bool);
853 
854     /**
855      * @dev Safely transfers `tokenId` token from `from` to `to`.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must exist and be owned by `from`.
862      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes calldata data
872     ) external;
873 }
874 
875 
876 
877 
878 
879 
880 
881 /**
882  * @dev Contract module which provides a basic access control mechanism, where
883  * there is an account (an owner) that can be granted exclusive access to
884  * specific functions.
885  *
886  * By default, the owner account will be the one that deploys the contract. This
887  * can later be changed with {transferOwnership}.
888  *
889  * This module is used through inheritance. It will make available the modifier
890  * `onlyOwner`, which can be applied to your functions to restrict their use to
891  * the owner.
892  */
893 abstract contract Ownable is Context {
894     address private _owner;
895 
896     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
897 
898     /**
899      * @dev Initializes the contract setting the deployer as the initial owner.
900      */
901     constructor() {
902         _setOwner(_msgSender());
903     }
904 
905     /**
906      * @dev Returns the address of the current owner.
907      */
908     function owner() public view virtual returns (address) {
909         return _owner;
910     }
911 
912     /**
913      * @dev Throws if called by any account other than the owner.
914      */
915     modifier onlyOwner() {
916         require(owner() == _msgSender(), "Ownable: caller is not the owner");
917         _;
918     }
919 
920     /**
921      * @dev Leaves the contract without owner. It will not be possible to call
922      * `onlyOwner` functions anymore. Can only be called by the current owner.
923      *
924      * NOTE: Renouncing ownership will leave the contract without an owner,
925      * thereby removing any functionality that is only available to the owner.
926      */
927     function renounceOwnership() public virtual onlyOwner {
928         _setOwner(address(0));
929     }
930 
931     /**
932      * @dev Transfers ownership of the contract to a new account (`newOwner`).
933      * Can only be called by the current owner.
934      */
935     function transferOwnership(address newOwner) public virtual onlyOwner {
936         require(newOwner != address(0), "Ownable: new owner is the zero address");
937         _setOwner(newOwner);
938     }
939 
940 
941     function _setOwner(address newOwner) private {
942         address oldOwner = _owner;
943         _owner = newOwner;
944         emit OwnershipTransferred(oldOwner, newOwner);
945     }
946 }
947 
948 
949 
950 
951 
952 
953 
954 /**
955  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
956  * @dev See https://eips.ethereum.org/EIPS/eip-721
957  */
958 interface IERC721Metadata is IERC721 {
959     /**
960      * @dev Returns the token collection name.
961      */
962     function name() external view returns (string memory);
963 
964     /**
965      * @dev Returns the token collection symbol.
966      */
967     function symbol() external view returns (string memory);
968 
969     /**
970      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
971      */
972     function tokenURI(uint256 tokenId) external view returns (string memory);
973 }
974 
975 
976 
977 
978 
979 
980 
981 /**
982  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
983  * the Metadata extension, but not including the Enumerable extension, which is available separately as
984  * {ERC721Enumerable}.
985  */
986 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
987     using Address for address;
988     using Strings for uint256;
989 
990     // Token name
991     string private _name;
992 
993     // Token symbol
994     string private _symbol;
995 
996     // Mapping from token ID to owner address
997     mapping(uint256 => address) private _owners;
998 
999     // Mapping owner address to token count
1000     mapping(address => uint256) private _balances;
1001 
1002     // Mapping from token ID to approved address
1003     mapping(uint256 => address) private _tokenApprovals;
1004 
1005     // Mapping from owner to operator approvals
1006     mapping(address => mapping(address => bool)) private _operatorApprovals;
1007 
1008     /**
1009      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1010      */
1011     constructor(string memory name_, string memory symbol_) {
1012         _name = name_;
1013         _symbol = symbol_;
1014     }
1015 
1016     /**
1017      * @dev See {IERC165-supportsInterface}.
1018      */
1019     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1020         return
1021             interfaceId == type(IERC721).interfaceId ||
1022             interfaceId == type(IERC721Metadata).interfaceId ||
1023             super.supportsInterface(interfaceId);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-balanceOf}.
1028      */
1029     function balanceOf(address owner) public view virtual override returns (uint256) {
1030         require(owner != address(0), "ERC721: balance query for the zero address");
1031         return _balances[owner];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-ownerOf}.
1036      */
1037     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1038         address owner = _owners[tokenId];
1039         require(owner != address(0), "ERC721: owner query for nonexistent token");
1040         return owner;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Metadata-name}.
1045      */
1046     function name() public view virtual override returns (string memory) {
1047         return _name;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Metadata-symbol}.
1052      */
1053     function symbol() public view virtual override returns (string memory) {
1054         return _symbol;
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Metadata-tokenURI}.
1059      */
1060     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1061         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1062 
1063         string memory baseURI = _baseURI();
1064         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1065     }
1066 
1067 
1068     /**
1069      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1070      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1071      * by default, can be overriden in child contracts.
1072      */
1073     function _baseURI() internal view virtual returns (string memory) {
1074         return "";
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-approve}.
1079      */
1080     function approve(address to, uint256 tokenId) public virtual override {
1081         address owner = ERC721.ownerOf(tokenId);
1082         require(to != owner, "ERC721: approval to current owner");
1083 
1084         require(
1085             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1086             "ERC721: approve caller is not owner nor approved for all"
1087         );
1088 
1089         _approve(to, tokenId);
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-getApproved}.
1094      */
1095     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1096         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1097 
1098         return _tokenApprovals[tokenId];
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-setApprovalForAll}.
1103      */
1104     function setApprovalForAll(address operator, bool approved) public virtual override {
1105         require(operator != _msgSender(), "ERC721: approve to caller");
1106 
1107         _operatorApprovals[_msgSender()][operator] = approved;
1108         emit ApprovalForAll(_msgSender(), operator, approved);
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-isApprovedForAll}.
1113      */
1114     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1115         return _operatorApprovals[owner][operator];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-transferFrom}.
1120      */
1121     function transferFrom(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) public virtual override {
1126         //solhint-disable-next-line max-line-length
1127         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1128 
1129         _transfer(from, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-safeTransferFrom}.
1134      */
1135     function safeTransferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) public virtual override {
1140         safeTransferFrom(from, to, tokenId, "");
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-safeTransferFrom}.
1145      */
1146     function safeTransferFrom(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) public virtual override {
1152         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1153         _safeTransfer(from, to, tokenId, _data);
1154     }
1155 
1156     /**
1157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1159      *
1160      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1161      *
1162      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1163      * implement alternative mechanisms to perform token transfer, such as signature-based.
1164      *
1165      * Requirements:
1166      *
1167      * - `from` cannot be the zero address.
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must exist and be owned by `from`.
1170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _safeTransfer(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) internal virtual {
1180         _transfer(from, to, tokenId);
1181         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1182     }
1183 
1184     /**
1185      * @dev Returns whether `tokenId` exists.
1186      *
1187      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1188      *
1189      * Tokens start existing when they are minted (`_mint`),
1190      * and stop existing when they are burned (`_burn`).
1191      */
1192     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1193         return _owners[tokenId] != address(0);
1194     }
1195 
1196     /**
1197      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1198      *
1199      * Requirements:
1200      *
1201      * - `tokenId` must exist.
1202      */
1203     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1204         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1205         address owner = ERC721.ownerOf(tokenId);
1206         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1207     }
1208 
1209     /**
1210      * @dev Safely mints `tokenId` and transfers it to `to`.
1211      *
1212      * Requirements:
1213      *
1214      * - `tokenId` must not exist.
1215      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _safeMint(address to, uint256 tokenId) internal virtual {
1220         _safeMint(to, tokenId, "");
1221     }
1222 
1223     /**
1224      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1225      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1226      */
1227     function _safeMint(
1228         address to,
1229         uint256 tokenId,
1230         bytes memory _data
1231     ) internal virtual {
1232         _mint(to, tokenId);
1233         require(
1234             _checkOnERC721Received(address(0), to, tokenId, _data),
1235             "ERC721: transfer to non ERC721Receiver implementer"
1236         );
1237     }
1238 
1239     /**
1240      * @dev Mints `tokenId` and transfers it to `to`.
1241      *
1242      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1243      *
1244      * Requirements:
1245      *
1246      * - `tokenId` must not exist.
1247      * - `to` cannot be the zero address.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _mint(address to, uint256 tokenId) internal virtual {
1252         require(to != address(0), "ERC721: mint to the zero address");
1253         require(!_exists(tokenId), "ERC721: token already minted");
1254 
1255         _beforeTokenTransfer(address(0), to, tokenId);
1256 
1257         _balances[to] += 1;
1258         _owners[tokenId] = to;
1259 
1260         emit Transfer(address(0), to, tokenId);
1261     }
1262 
1263     /**
1264      * @dev Destroys `tokenId`.
1265      * The approval is cleared when the token is burned.
1266      *
1267      * Requirements:
1268      *
1269      * - `tokenId` must exist.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function _burn(uint256 tokenId) internal virtual {
1274         address owner = ERC721.ownerOf(tokenId);
1275 
1276         _beforeTokenTransfer(owner, address(0), tokenId);
1277 
1278         // Clear approvals
1279         _approve(address(0), tokenId);
1280 
1281         _balances[owner] -= 1;
1282         delete _owners[tokenId];
1283 
1284         emit Transfer(owner, address(0), tokenId);
1285     }
1286 
1287     /**
1288      * @dev Transfers `tokenId` from `from` to `to`.
1289      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1290      *
1291      * Requirements:
1292      *
1293      * - `to` cannot be the zero address.
1294      * - `tokenId` token must be owned by `from`.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function _transfer(
1299         address from,
1300         address to,
1301         uint256 tokenId
1302     ) internal virtual {
1303         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1304         require(to != address(0), "ERC721: transfer to the zero address");
1305 
1306         _beforeTokenTransfer(from, to, tokenId);
1307 
1308         // Clear approvals from the previous owner
1309         _approve(address(0), tokenId);
1310 
1311         _balances[from] -= 1;
1312         _balances[to] += 1;
1313         _owners[tokenId] = to;
1314 
1315         emit Transfer(from, to, tokenId);
1316     }
1317 
1318     /**
1319      * @dev Approve `to` to operate on `tokenId`
1320      *
1321      * Emits a {Approval} event.
1322      */
1323     function _approve(address to, uint256 tokenId) internal virtual {
1324         _tokenApprovals[tokenId] = to;
1325         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1326     }
1327 
1328     /**
1329      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1330      * The call is not executed if the target address is not a contract.
1331      *
1332      * @param from address representing the previous owner of the given token ID
1333      * @param to target address that will receive the tokens
1334      * @param tokenId uint256 ID of the token to be transferred
1335      * @param _data bytes optional data to send along with the call
1336      * @return bool whether the call correctly returned the expected magic value
1337      */
1338     function _checkOnERC721Received(
1339         address from,
1340         address to,
1341         uint256 tokenId,
1342         bytes memory _data
1343     ) private returns (bool) {
1344         if (to.isContract()) {
1345             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1346                 return retval == IERC721Receiver(to).onERC721Received.selector;
1347             } catch (bytes memory reason) {
1348                 if (reason.length == 0) {
1349                     revert("ERC721: transfer to non ERC721Receiver implementer");
1350                 } else {
1351                     assembly {
1352                         revert(add(32, reason), mload(reason))
1353                     }
1354                 }
1355             }
1356         } else {
1357             return true;
1358         }
1359     }
1360 
1361     /**
1362      * @dev Hook that is called before any token transfer. This includes minting
1363      * and burning.
1364      *
1365      * Calling conditions:
1366      *
1367      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1368      * transferred to `to`.
1369      * - When `from` is zero, `tokenId` will be minted for `to`.
1370      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1371      * - `from` and `to` are never both zero.
1372      *
1373      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1374      */
1375     function _beforeTokenTransfer(
1376         address from,
1377         address to,
1378         uint256 tokenId
1379     ) internal virtual {}
1380 }
1381 
1382 
1383 contract DentalFrens is ERC721, Ownable, ReentrancyGuard {
1384   using Counters for Counters.Counter;
1385   using SafeMath for uint256;
1386   Counters.Counter public _tokenIds;
1387   uint256 public _mintCost = 0.02 ether;
1388   uint256 public _maxSupply = 10000;
1389   bool public _isPublicMintEnabled = false;
1390   string public _baseTokenURI = "";
1391   
1392   /**
1393   * @dev Initializes the contract setting the `tokenName` and `symbol` of the nft, `cost` of each mint call, and maximum `supply` of the nft.
1394   * Note: `cost` is in wei. 
1395   */
1396   constructor() ERC721("Dental Frens", "DentalFrens") {
1397   }
1398 
1399     /*
1400     * Pause sale if active, make active if paused
1401     */
1402   function flipSaleState() public onlyOwner {
1403     _isPublicMintEnabled = !_isPublicMintEnabled;
1404   }
1405 
1406   /**
1407   * @dev Mint `count` tokens if requirements are satisfied.
1408   * 
1409   */
1410   function mintTokens(uint256 count)
1411   public
1412   payable
1413   nonReentrant{
1414     require(_isPublicMintEnabled, "Mint disabled");
1415     require(count > 0 && count <= 10, "Max 10 per tx");
1416     require(count.add(_tokenIds.current()) < _maxSupply, "Exceeds max supply");
1417     require(owner() == msg.sender || msg.value >= _mintCost.mul(count),
1418            "Ether value sent is below the price");
1419     for(uint i=0; i<count; i++){
1420         _mint(msg.sender);
1421      }
1422   }
1423 
1424 
1425   /**
1426   * @dev Update the cost to mint a token.
1427   * Can only be called by the current owner.
1428   */
1429   function setCost(uint256 cost) public onlyOwner{
1430     _mintCost = cost;
1431   }
1432 
1433   /**
1434   * @dev Update the max supply.
1435   * Can only be called by the current owner.
1436   */
1437   function setMaxSupply(uint256 max) public onlyOwner{
1438     _maxSupply = max;
1439   }
1440 
1441   function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
1442     _baseTokenURI = __baseTokenURI;
1443   }
1444 
1445 
1446   /**
1447   * @dev Transfers contract balance to contract owner.
1448   * Can only be called by the current owner.
1449   */
1450   function withdraw() public onlyOwner{
1451     payable(owner()).transfer(address(this).balance);
1452   }
1453   
1454   
1455 
1456   /**
1457   * @dev Used by public mint functions and by owner functions.
1458   * Can only be called internally by other functions.
1459   */
1460   function _mint(address to) internal virtual returns (uint256){
1461     _tokenIds.increment();
1462     uint256 id = _tokenIds.current();
1463     _safeMint(to, id);
1464 
1465     return id;
1466   }
1467 
1468   function getCost() public view returns (uint256){
1469     return _mintCost;
1470   }
1471   function totalSupply() public view returns (uint256){
1472     return _maxSupply;
1473   }
1474   function getCurrentSupply() public view returns (uint256){
1475     return _tokenIds.current();
1476   }
1477   function getMintStatus() public view returns (bool) {
1478     return _isPublicMintEnabled;
1479   }
1480 
1481   /**
1482   * @dev Returns a URI for a given token ID's metadata
1483   */
1484   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1485     return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId), ".json"));
1486   }
1487 
1488 }