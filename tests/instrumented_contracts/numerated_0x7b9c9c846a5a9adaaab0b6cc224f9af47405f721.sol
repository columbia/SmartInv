1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * ██████╗  ██████╗  ██████╗ ██████╗ ██╗     ███████╗    ███████╗██████╗ ██╗███████╗███╗   ██╗██████╗ ███████╗
5  * ██╔══██╗██╔═══██╗██╔═══██╗██╔══██╗██║     ██╔════╝    ██╔════╝██╔══██╗██║██╔════╝████╗  ██║██╔══██╗██╔════╝
6  * ██║  ██║██║   ██║██║   ██║██║  ██║██║     █████╗      █████╗  ██████╔╝██║█████╗  ██╔██╗ ██║██║  ██║███████╗
7  * ██║  ██║██║   ██║██║   ██║██║  ██║██║     ██╔══╝      ██╔══╝  ██╔══██╗██║██╔══╝  ██║╚██╗██║██║  ██║╚════██║
8  * ██████╔╝╚██████╔╝╚██████╔╝██████╔╝███████╗███████╗    ██║     ██║  ██║██║███████╗██║ ╚████║██████╔╝███████║
9  * ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝╚══════╝    ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
10  *
11  * This amazing collection consists of 3,353 NFTs, combining a mixture of curated 2D and 3D beautiful characters! 
12  * From this 3,353, 2D collection, there will be limited numbers of rare 1 to 1 "3D" Friends available! 
13  * As a project, our goal is to be much different by way of choosing a "community first" approach and offering more value than anyone else!
14  */
15 
16 pragma solidity 0.8.11;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 /**
39  * @title Counters
40  * @author Matt Condon (@shrugs)
41  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
42  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
43  *
44  * Include with `using Counters for Counters.Counter;`
45  */
46 library Counters {
47     struct Counter {
48         // This variable should never be directly accessed by users of the library: interactions must be restricted to
49         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
50         // this feature: see https://github.com/ethereum/solidity/issues/4637
51         uint256 _value; // default: 0
52     }
53 
54     function current(Counter storage counter) internal view returns (uint256) {
55         return counter._value;
56     }
57 
58     function increment(Counter storage counter) internal {
59         unchecked {
60             counter._value += 1;
61         }
62     }
63 
64     function decrement(Counter storage counter) internal {
65         uint256 value = counter._value;
66         require(value > 0, "Counter: decrement overflow");
67         unchecked {
68             counter._value = value - 1;
69         }
70     }
71 
72     function reset(Counter storage counter) internal {
73         counter._value = 0;
74     }
75 }
76 
77 /**
78  * @dev String operations.
79  */
80 library Strings {
81     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87         // Inspired by OraclizeAPI's implementation - MIT licence
88         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
89 
90         if (value == 0) {
91             return "0";
92         }
93         uint256 temp = value;
94         uint256 digits;
95         while (temp != 0) {
96             digits++;
97             temp /= 10;
98         }
99         bytes memory buffer = new bytes(digits);
100         while (value != 0) {
101             digits -= 1;
102             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
103             value /= 10;
104         }
105         return string(buffer);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
110      */
111     function toHexString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0x00";
114         }
115         uint256 temp = value;
116         uint256 length = 0;
117         while (temp != 0) {
118             length++;
119             temp >>= 8;
120         }
121         return toHexString(value, length);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
126      */
127     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
128         bytes memory buffer = new bytes(2 * length + 2);
129         buffer[0] = "0";
130         buffer[1] = "x";
131         for (uint256 i = 2 * length + 1; i > 1; --i) {
132             buffer[i] = _HEX_SYMBOLS[value & 0xf];
133             value >>= 4;
134         }
135         require(value == 0, "Strings: hex length insufficient");
136         return string(buffer);
137     }
138 }
139 
140 /**
141  * @dev Wrappers over Solidity's arithmetic operations.
142  *
143  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
144  * now has built in overflow checking.
145  */
146 library SafeMath {
147     /**
148      * @dev Returns the addition of two unsigned integers, with an overflow flag.
149      *
150      * _Available since v3.4._
151      */
152     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         unchecked {
154             uint256 c = a + b;
155             if (c < a) return (false, 0);
156             return (true, c);
157         }
158     }
159 
160     /**
161      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
162      *
163      * _Available since v3.4._
164      */
165     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         unchecked {
167             if (b > a) return (false, 0);
168             return (true, a - b);
169         }
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
174      *
175      * _Available since v3.4._
176      */
177     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
178         unchecked {
179             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180             // benefit is lost if 'b' is also tested.
181             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182             if (a == 0) return (true, 0);
183             uint256 c = a * b;
184             if (c / a != b) return (false, 0);
185             return (true, c);
186         }
187     }
188 
189     /**
190      * @dev Returns the division of two unsigned integers, with a division by zero flag.
191      *
192      * _Available since v3.4._
193      */
194     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
195         unchecked {
196             if (b == 0) return (false, 0);
197             return (true, a / b);
198         }
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
203      *
204      * _Available since v3.4._
205      */
206     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
207         unchecked {
208             if (b == 0) return (false, 0);
209             return (true, a % b);
210         }
211     }
212 
213     /**
214      * @dev Returns the addition of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `+` operator.
218      *
219      * Requirements:
220      *
221      * - Addition cannot overflow.
222      */
223     function add(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a + b;
225     }
226 
227     /**
228      * @dev Returns the subtraction of two unsigned integers, reverting on
229      * overflow (when the result is negative).
230      *
231      * Counterpart to Solidity's `-` operator.
232      *
233      * Requirements:
234      *
235      * - Subtraction cannot overflow.
236      */
237     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238         return a - b;
239     }
240 
241     /**
242      * @dev Returns the multiplication of two unsigned integers, reverting on
243      * overflow.
244      *
245      * Counterpart to Solidity's `*` operator.
246      *
247      * Requirements:
248      *
249      * - Multiplication cannot overflow.
250      */
251     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a * b;
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers, reverting on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator.
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         return a / b;
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * reverting when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a % b;
283     }
284 
285     /**
286      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
287      * overflow (when the result is negative).
288      *
289      * CAUTION: This function is deprecated because it requires allocating memory for the error
290      * message unnecessarily. For custom revert reasons use {trySub}.
291      *
292      * Counterpart to Solidity's `-` operator.
293      *
294      * Requirements:
295      *
296      * - Subtraction cannot overflow.
297      */
298     function sub(
299         uint256 a,
300         uint256 b,
301         string memory errorMessage
302     ) internal pure returns (uint256) {
303         unchecked {
304             require(b <= a, errorMessage);
305             return a - b;
306         }
307     }
308 
309     /**
310      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
311      * division by zero. The result is rounded towards zero.
312      *
313      * Counterpart to Solidity's `/` operator. Note: this function uses a
314      * `revert` opcode (which leaves remaining gas untouched) while Solidity
315      * uses an invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function div(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         unchecked {
327             require(b > 0, errorMessage);
328             return a / b;
329         }
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
334      * reverting with custom message when dividing by zero.
335      *
336      * CAUTION: This function is deprecated because it requires allocating memory for the error
337      * message unnecessarily. For custom revert reasons use {tryMod}.
338      *
339      * Counterpart to Solidity's `%` operator. This function uses a `revert`
340      * opcode (which leaves remaining gas untouched) while Solidity uses an
341      * invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      *
345      * - The divisor cannot be zero.
346      */
347     function mod(
348         uint256 a,
349         uint256 b,
350         string memory errorMessage
351     ) internal pure returns (uint256) {
352         unchecked {
353             require(b > 0, errorMessage);
354             return a % b;
355         }
356     }
357 }
358 
359 /**
360  * @dev Interface of the ERC165 standard, as defined in the
361  * https://eips.ethereum.org/EIPS/eip-165[EIP].
362  *
363  * Implementers can declare support of contract interfaces, which can then be
364  * queried by others ({ERC165Checker}).
365  *
366  * For an implementation, see {ERC165}.
367  */
368 interface IERC165 {
369     /**
370      * @dev Returns true if this contract implements the interface defined by
371      * `interfaceId`. See the corresponding
372      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
373      * to learn more about how these ids are created.
374      *
375      * This function call must use less than 30 000 gas.
376      */
377     function supportsInterface(bytes4 interfaceId) external view returns (bool);
378 }
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
403 /**
404  * @dev Collection of functions related to the address type
405  */
406 library Address {
407     /**
408      * @dev Returns true if `account` is a contract.
409      *
410      * [IMPORTANT]
411      * ====
412      * It is unsafe to assume that an address for which this function returns
413      * false is an externally-owned account (EOA) and not a contract.
414      *
415      * Among others, `isContract` will return false for the following
416      * types of addresses:
417      *
418      *  - an externally-owned account
419      *  - a contract in construction
420      *  - an address where a contract will be created
421      *  - an address where a contract lived, but was destroyed
422      * ====
423      */
424     function isContract(address account) internal view returns (bool) {
425         // This method relies on extcodesize, which returns 0 for contracts in
426         // construction, since the code is only stored at the end of the
427         // constructor execution.
428 
429         uint256 size;
430         assembly {
431             size := extcodesize(account)
432         }
433         return size > 0;
434     }
435 
436     /**
437      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
438      * `recipient`, forwarding all available gas and reverting on errors.
439      *
440      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
441      * of certain opcodes, possibly making contracts go over the 2300 gas limit
442      * imposed by `transfer`, making them unable to receive funds via
443      * `transfer`. {sendValue} removes this limitation.
444      *
445      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
446      *
447      * IMPORTANT: because control is transferred to `recipient`, care must be
448      * taken to not create reentrancy vulnerabilities. Consider using
449      * {ReentrancyGuard} or the
450      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
451      */
452     function sendValue(address payable recipient, uint256 amount) internal {
453         require(address(this).balance >= amount, "Address: insufficient balance");
454 
455         (bool success, ) = recipient.call{value: amount}("");
456         require(success, "Address: unable to send value, recipient may have reverted");
457     }
458 
459     /**
460      * @dev Performs a Solidity function call using a low level `call`. A
461      * plain `call` is an unsafe replacement for a function call: use this
462      * function instead.
463      *
464      * If `target` reverts with a revert reason, it is bubbled up by this
465      * function (like regular Solidity function calls).
466      *
467      * Returns the raw returned data. To convert to the expected return value,
468      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
469      *
470      * Requirements:
471      *
472      * - `target` must be a contract.
473      * - calling `target` with `data` must not revert.
474      *
475      * _Available since v3.1._
476      */
477     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
478         return functionCall(target, data, "Address: low-level call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
483      * `errorMessage` as a fallback revert reason when `target` reverts.
484      *
485      * _Available since v3.1._
486      */
487     function functionCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         return functionCallWithValue(target, data, 0, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but also transferring `value` wei to `target`.
498      *
499      * Requirements:
500      *
501      * - the calling contract must have an ETH balance of at least `value`.
502      * - the called Solidity function must be `payable`.
503      *
504      * _Available since v3.1._
505      */
506     function functionCallWithValue(
507         address target,
508         bytes memory data,
509         uint256 value
510     ) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
516      * with `errorMessage` as a fallback revert reason when `target` reverts.
517      *
518      * _Available since v3.1._
519      */
520     function functionCallWithValue(
521         address target,
522         bytes memory data,
523         uint256 value,
524         string memory errorMessage
525     ) internal returns (bytes memory) {
526         require(address(this).balance >= value, "Address: insufficient balance for call");
527         require(isContract(target), "Address: call to non-contract");
528 
529         (bool success, bytes memory returndata) = target.call{value: value}(data);
530         return verifyCallResult(success, returndata, errorMessage);
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
535      * but performing a static call.
536      *
537      * _Available since v3.3._
538      */
539     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
540         return functionStaticCall(target, data, "Address: low-level static call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
545      * but performing a static call.
546      *
547      * _Available since v3.3._
548      */
549     function functionStaticCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal view returns (bytes memory) {
554         require(isContract(target), "Address: static call to non-contract");
555 
556         (bool success, bytes memory returndata) = target.staticcall(data);
557         return verifyCallResult(success, returndata, errorMessage);
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
562      * but performing a delegate call.
563      *
564      * _Available since v3.4._
565      */
566     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
567         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
572      * but performing a delegate call.
573      *
574      * _Available since v3.4._
575      */
576     function functionDelegateCall(
577         address target,
578         bytes memory data,
579         string memory errorMessage
580     ) internal returns (bytes memory) {
581         require(isContract(target), "Address: delegate call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.delegatecall(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
589      * revert reason using the provided one.
590      *
591      * _Available since v4.3._
592      */
593     function verifyCallResult(
594         bool success,
595         bytes memory returndata,
596         string memory errorMessage
597     ) internal pure returns (bytes memory) {
598         if (success) {
599             return returndata;
600         } else {
601             // Look for revert reason and bubble it up if present
602             if (returndata.length > 0) {
603                 // The easiest way to bubble the revert reason is using memory via assembly
604 
605                 assembly {
606                     let returndata_size := mload(returndata)
607                     revert(add(32, returndata), returndata_size)
608                 }
609             } else {
610                 revert(errorMessage);
611             }
612         }
613     }
614 }
615 
616 /**
617  * @dev Required interface of an ERC721 compliant contract.
618  */
619 interface IERC721 is IERC165 {
620     /**
621      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
622      */
623     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
624 
625     /**
626      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
627      */
628     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
629 
630     /**
631      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
632      */
633     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
634 
635     /**
636      * @dev Returns the number of tokens in ``owner``'s account.
637      */
638     function balanceOf(address owner) external view returns (uint256 balance);
639 
640     /**
641      * @dev Returns the owner of the `tokenId` token.
642      *
643      * Requirements:
644      *
645      * - `tokenId` must exist.
646      */
647     function ownerOf(uint256 tokenId) external view returns (address owner);
648 
649     /**
650      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
651      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must exist and be owned by `from`.
658      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
659      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
660      *
661      * Emits a {Transfer} event.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId
667     ) external;
668 
669     /**
670      * @dev Transfers `tokenId` token from `from` to `to`.
671      *
672      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
673      *
674      * Requirements:
675      *
676      * - `from` cannot be the zero address.
677      * - `to` cannot be the zero address.
678      * - `tokenId` token must be owned by `from`.
679      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
680      *
681      * Emits a {Transfer} event.
682      */
683     function transferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) external;
688 
689     /**
690      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
691      * The approval is cleared when the token is transferred.
692      *
693      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
694      *
695      * Requirements:
696      *
697      * - The caller must own the token or be an approved operator.
698      * - `tokenId` must exist.
699      *
700      * Emits an {Approval} event.
701      */
702     function approve(address to, uint256 tokenId) external;
703 
704     /**
705      * @dev Returns the account approved for `tokenId` token.
706      *
707      * Requirements:
708      *
709      * - `tokenId` must exist.
710      */
711     function getApproved(uint256 tokenId) external view returns (address operator);
712 
713     /**
714      * @dev Approve or remove `operator` as an operator for the caller.
715      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
716      *
717      * Requirements:
718      *
719      * - The `operator` cannot be the caller.
720      *
721      * Emits an {ApprovalForAll} event.
722      */
723     function setApprovalForAll(address operator, bool _approved) external;
724 
725     /**
726      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
727      *
728      * See {setApprovalForAll}
729      */
730     function isApprovedForAll(address owner, address operator) external view returns (bool);
731 
732     /**
733      * @dev Safely transfers `tokenId` token from `from` to `to`.
734      *
735      * Requirements:
736      *
737      * - `from` cannot be the zero address.
738      * - `to` cannot be the zero address.
739      * - `tokenId` token must exist and be owned by `from`.
740      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
741      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
742      *
743      * Emits a {Transfer} event.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId,
749         bytes calldata data
750     ) external;
751 }
752 
753 /**
754  * @dev Contract module which allows children to implement an emergency stop
755  * mechanism that can be triggered by an authorized account.
756  *
757  * This module is used through inheritance. It will make available the
758  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
759  * the functions of your contract. Note that they will not be pausable by
760  * simply including this module, only once the modifiers are put in place.
761  */
762 abstract contract Pausable is Context {
763     /**
764      * @dev Emitted when the pause is triggered by `account`.
765      */
766     event Paused(address account);
767 
768     /**
769      * @dev Emitted when the pause is lifted by `account`.
770      */
771     event Unpaused(address account);
772 
773     bool private _paused;
774 
775     /**
776      * @dev Initializes the contract in unpaused state.
777      */
778     constructor() {
779         _paused = false;
780     }
781 
782     /**
783      * @dev Returns true if the contract is paused, and false otherwise.
784      */
785     function paused() public view virtual returns (bool) {
786         return _paused;
787     }
788 
789     /**
790      * @dev Modifier to make a function callable only when the contract is not paused.
791      *
792      * Requirements:
793      *
794      * - The contract must not be paused.
795      */
796     modifier whenNotPaused() {
797         require(!paused(), "Pausable: paused");
798         _;
799     }
800 
801     /**
802      * @dev Modifier to make a function callable only when the contract is paused.
803      *
804      * Requirements:
805      *
806      * - The contract must be paused.
807      */
808     modifier whenPaused() {
809         require(paused(), "Pausable: not paused");
810         _;
811     }
812 
813     /**
814      * @dev Triggers stopped state.
815      *
816      * Requirements:
817      *
818      * - The contract must not be paused.
819      */
820     function _pause() internal virtual whenNotPaused {
821         _paused = true;
822         emit Paused(_msgSender());
823     }
824 
825     /**
826      * @dev Returns to normal state.
827      *
828      * Requirements:
829      *
830      * - The contract must be paused.
831      */
832     function _unpause() internal virtual whenPaused {
833         _paused = false;
834         emit Unpaused(_msgSender());
835     }
836 }
837 
838 /**
839  * @dev Contract module which provides a basic access control mechanism, where
840  * there is an account (an owner) that can be granted exclusive access to
841  * specific functions.
842  *
843  * By default, the owner account will be the one that deploys the contract. This
844  * can later be changed with {transferOwnership}.
845  *
846  * This module is used through inheritance. It will make available the modifier
847  * `onlyOwner`, which can be applied to your functions to restrict their use to
848  * the owner.
849  */
850 abstract contract Ownable is Context {
851     address private _owner;
852 
853     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
854 
855     /**
856      * @dev Initializes the contract setting the deployer as the initial owner.
857      */
858     constructor() {
859         _transferOwnership(_msgSender());
860     }
861 
862     /**
863      * @dev Returns the address of the current owner.
864      */
865     function owner() public view virtual returns (address) {
866         return _owner;
867     }
868 
869     /**
870      * @dev Throws if called by any account other than the owner.
871      */
872     modifier onlyOwner() {
873         require(owner() == _msgSender(), "Ownable: caller is not the owner");
874         _;
875     }
876 
877     /**
878      * @dev Leaves the contract without owner. It will not be possible to call
879      * `onlyOwner` functions anymore. Can only be called by the current owner.
880      *
881      * NOTE: Renouncing ownership will leave the contract without an owner,
882      * thereby removing any functionality that is only available to the owner.
883      */
884     function renounceOwnership() public virtual onlyOwner {
885         _transferOwnership(address(0));
886     }
887 
888     /**
889      * @dev Transfers ownership of the contract to a new account (`newOwner`).
890      * Can only be called by the current owner.
891      */
892     function transferOwnership(address newOwner) public virtual onlyOwner {
893         require(newOwner != address(0), "Ownable: new owner is the zero address");
894         _transferOwnership(newOwner);
895     }
896 
897     /**
898      * @dev Transfers ownership of the contract to a new account (`newOwner`).
899      * Internal function without access restriction.
900      */
901     function _transferOwnership(address newOwner) internal virtual {
902         address oldOwner = _owner;
903         _owner = newOwner;
904         emit OwnershipTransferred(oldOwner, newOwner);
905     }
906 }
907 
908 /**
909  * @title ERC721 token receiver interface
910  * @dev Interface for any contract that wants to support safeTransfers
911  * from ERC721 asset contracts.
912  */
913 interface IERC721Receiver {
914     /**
915      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
916      * by `operator` from `from`, this function is called.
917      *
918      * It must return its Solidity selector to confirm the token transfer.
919      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
920      *
921      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
922      */
923     function onERC721Received(
924         address operator,
925         address from,
926         uint256 tokenId,
927         bytes calldata data
928     ) external returns (bytes4);
929 }
930 
931 /**
932  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
933  * @dev See https://eips.ethereum.org/EIPS/eip-721
934  */
935 interface IERC721Enumerable is IERC721 {
936     /**
937      * @dev Returns the total amount of tokens stored by the contract.
938      */
939     function totalSupply() external view returns (uint256);
940 
941     /**
942      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
943      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
944      */
945     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
946 
947     /**
948      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
949      * Use along with {totalSupply} to enumerate all tokens.
950      */
951     function tokenByIndex(uint256 index) external view returns (uint256);
952 }
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
975 /**
976  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
977  * the Metadata extension, but not including the Enumerable extension, which is available separately as
978  * {ERC721Enumerable}.
979  */
980 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
981     using Address for address;
982     using Strings for uint256;
983 
984     // Token name
985     string private _name;
986 
987     // Token symbol
988     string private _symbol;
989 
990     // Mapping from token ID to owner address
991     mapping(uint256 => address) private _owners;
992 
993     // Mapping owner address to token count
994     mapping(address => uint256) private _balances;
995 
996     // Mapping from token ID to approved address
997     mapping(uint256 => address) private _tokenApprovals;
998 
999     // Mapping from owner to operator approvals
1000     mapping(address => mapping(address => bool)) private _operatorApprovals;
1001 
1002     /**
1003      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1004      */
1005     constructor(string memory name_, string memory symbol_) {
1006         _name = name_;
1007         _symbol = symbol_;
1008     }
1009 
1010     /**
1011      * @dev See {IERC165-supportsInterface}.
1012      */
1013     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1014         return
1015             interfaceId == type(IERC721).interfaceId ||
1016             interfaceId == type(IERC721Metadata).interfaceId ||
1017             super.supportsInterface(interfaceId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-balanceOf}.
1022      */
1023     function balanceOf(address owner) public view virtual override returns (uint256) {
1024         require(owner != address(0), "ERC721: balance query for the zero address");
1025         return _balances[owner];
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-ownerOf}.
1030      */
1031     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1032         address owner = _owners[tokenId];
1033         require(owner != address(0), "ERC721: owner query for nonexistent token");
1034         return owner;
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Metadata-name}.
1039      */
1040     function name() public view virtual override returns (string memory) {
1041         return _name;
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Metadata-symbol}.
1046      */
1047     function symbol() public view virtual override returns (string memory) {
1048         return _symbol;
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Metadata-tokenURI}.
1053      */
1054     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1055         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1056 
1057         string memory baseURI = _baseURI();
1058         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1059     }
1060 
1061     /**
1062      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1063      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1064      * by default, can be overriden in child contracts.
1065      */
1066     function _baseURI() internal view virtual returns (string memory) {
1067         return "";
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-approve}.
1072      */
1073     function approve(address to, uint256 tokenId) public virtual override {
1074         address owner = ERC721.ownerOf(tokenId);
1075         require(to != owner, "ERC721: approval to current owner");
1076 
1077         require(
1078             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1079             "ERC721: approve caller is not owner nor approved for all"
1080         );
1081 
1082         _approve(to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-getApproved}.
1087      */
1088     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1089         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1090 
1091         return _tokenApprovals[tokenId];
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-setApprovalForAll}.
1096      */
1097     function setApprovalForAll(address operator, bool approved) public virtual override {
1098         _setApprovalForAll(_msgSender(), operator, approved);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-isApprovedForAll}.
1103      */
1104     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1105         return _operatorApprovals[owner][operator];
1106     }
1107 
1108     /**
1109      * @dev See {IERC721-transferFrom}.
1110      */
1111     function transferFrom(
1112         address from,
1113         address to,
1114         uint256 tokenId
1115     ) public virtual override {
1116         //solhint-disable-next-line max-line-length
1117         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1118 
1119         _transfer(from, to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-safeTransferFrom}.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) public virtual override {
1130         safeTransferFrom(from, to, tokenId, "");
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-safeTransferFrom}.
1135      */
1136     function safeTransferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes memory _data
1141     ) public virtual override {
1142         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1143         _safeTransfer(from, to, tokenId, _data);
1144     }
1145 
1146     /**
1147      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1148      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1149      *
1150      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1151      *
1152      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1153      * implement alternative mechanisms to perform token transfer, such as signature-based.
1154      *
1155      * Requirements:
1156      *
1157      * - `from` cannot be the zero address.
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must exist and be owned by `from`.
1160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _safeTransfer(
1165         address from,
1166         address to,
1167         uint256 tokenId,
1168         bytes memory _data
1169     ) internal virtual {
1170         _transfer(from, to, tokenId);
1171         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1172     }
1173 
1174     /**
1175      * @dev Returns whether `tokenId` exists.
1176      *
1177      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1178      *
1179      * Tokens start existing when they are minted (`_mint`),
1180      * and stop existing when they are burned (`_burn`).
1181      */
1182     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1183         return _owners[tokenId] != address(0);
1184     }
1185 
1186     /**
1187      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1188      *
1189      * Requirements:
1190      *
1191      * - `tokenId` must exist.
1192      */
1193     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1194         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1195         address owner = ERC721.ownerOf(tokenId);
1196         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1197     }
1198 
1199     /**
1200      * @dev Safely mints `tokenId` and transfers it to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must not exist.
1205      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _safeMint(address to, uint256 tokenId) internal virtual {
1210         _safeMint(to, tokenId, "");
1211     }
1212 
1213     /**
1214      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1215      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1216      */
1217     function _safeMint(
1218         address to,
1219         uint256 tokenId,
1220         bytes memory _data
1221     ) internal virtual {
1222         _mint(to, tokenId);
1223         require(
1224             _checkOnERC721Received(address(0), to, tokenId, _data),
1225             "ERC721: transfer to non ERC721Receiver implementer"
1226         );
1227     }
1228 
1229     /**
1230      * @dev Mints `tokenId` and transfers it to `to`.
1231      *
1232      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must not exist.
1237      * - `to` cannot be the zero address.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _mint(address to, uint256 tokenId) internal virtual {
1242         require(to != address(0), "ERC721: mint to the zero address");
1243         require(!_exists(tokenId), "ERC721: token already minted");
1244 
1245         _beforeTokenTransfer(address(0), to, tokenId);
1246 
1247         _balances[to] += 1;
1248         _owners[tokenId] = to;
1249 
1250         emit Transfer(address(0), to, tokenId);
1251     }
1252 
1253     /**
1254      * @dev Destroys `tokenId`.
1255      * The approval is cleared when the token is burned.
1256      *
1257      * Requirements:
1258      *
1259      * - `tokenId` must exist.
1260      *
1261      * Emits a {Transfer} event.
1262      */
1263     function _burn(uint256 tokenId) internal virtual {
1264         address owner = ERC721.ownerOf(tokenId);
1265 
1266         _beforeTokenTransfer(owner, address(0), tokenId);
1267 
1268         // Clear approvals
1269         _approve(address(0), tokenId);
1270 
1271         _balances[owner] -= 1;
1272         delete _owners[tokenId];
1273 
1274         emit Transfer(owner, address(0), tokenId);
1275     }
1276 
1277     /**
1278      * @dev Transfers `tokenId` from `from` to `to`.
1279      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1280      *
1281      * Requirements:
1282      *
1283      * - `to` cannot be the zero address.
1284      * - `tokenId` token must be owned by `from`.
1285      *
1286      * Emits a {Transfer} event.
1287      */
1288     function _transfer(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) internal virtual {
1293         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1294         require(to != address(0), "ERC721: transfer to the zero address");
1295 
1296         _beforeTokenTransfer(from, to, tokenId);
1297 
1298         // Clear approvals from the previous owner
1299         _approve(address(0), tokenId);
1300 
1301         _balances[from] -= 1;
1302         _balances[to] += 1;
1303         _owners[tokenId] = to;
1304 
1305         emit Transfer(from, to, tokenId);
1306     }
1307 
1308     /**
1309      * @dev Approve `to` to operate on `tokenId`
1310      *
1311      * Emits a {Approval} event.
1312      */
1313     function _approve(address to, uint256 tokenId) internal virtual {
1314         _tokenApprovals[tokenId] = to;
1315         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1316     }
1317 
1318     /**
1319      * @dev Approve `operator` to operate on all of `owner` tokens
1320      *
1321      * Emits a {ApprovalForAll} event.
1322      */
1323     function _setApprovalForAll(
1324         address owner,
1325         address operator,
1326         bool approved
1327     ) internal virtual {
1328         require(owner != operator, "ERC721: approve to caller");
1329         _operatorApprovals[owner][operator] = approved;
1330         emit ApprovalForAll(owner, operator, approved);
1331     }
1332 
1333     /**
1334      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1335      * The call is not executed if the target address is not a contract.
1336      *
1337      * @param from address representing the previous owner of the given token ID
1338      * @param to target address that will receive the tokens
1339      * @param tokenId uint256 ID of the token to be transferred
1340      * @param _data bytes optional data to send along with the call
1341      * @return bool whether the call correctly returned the expected magic value
1342      */
1343     function _checkOnERC721Received(
1344         address from,
1345         address to,
1346         uint256 tokenId,
1347         bytes memory _data
1348     ) private returns (bool) {
1349         if (to.isContract()) {
1350             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1351                 return retval == IERC721Receiver.onERC721Received.selector;
1352             } catch (bytes memory reason) {
1353                 if (reason.length == 0) {
1354                     revert("ERC721: transfer to non ERC721Receiver implementer");
1355                 } else {
1356                     assembly {
1357                         revert(add(32, reason), mload(reason))
1358                     }
1359                 }
1360             }
1361         } else {
1362             return true;
1363         }
1364     }
1365 
1366     /**
1367      * @dev Hook that is called before any token transfer. This includes minting
1368      * and burning.
1369      *
1370      * Calling conditions:
1371      *
1372      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1373      * transferred to `to`.
1374      * - When `from` is zero, `tokenId` will be minted for `to`.
1375      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1376      * - `from` and `to` are never both zero.
1377      *
1378      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1379      */
1380     function _beforeTokenTransfer(
1381         address from,
1382         address to,
1383         uint256 tokenId
1384     ) internal virtual {}
1385 }
1386 
1387 /**
1388  * @title ERC721 Burnable Token
1389  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1390  */
1391 abstract contract ERC721Burnable is Context, ERC721 {
1392     /**
1393      * @dev Burns `tokenId`. See {ERC721-_burn}.
1394      *
1395      * Requirements:
1396      *
1397      * - The caller must own `tokenId` or be an approved operator.
1398      */
1399     function burn(uint256 tokenId) public virtual {
1400         //solhint-disable-next-line max-line-length
1401         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1402         _burn(tokenId);
1403     }
1404 }
1405 
1406 /**
1407  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1408  * enumerability of all the token ids in the contract as well as all token ids owned by each
1409  * account.
1410  */
1411 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1412     // Mapping from owner to list of owned token IDs
1413     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1414 
1415     // Mapping from token ID to index of the owner tokens list
1416     mapping(uint256 => uint256) private _ownedTokensIndex;
1417 
1418     // Array with all token ids, used for enumeration
1419     uint256[] private _allTokens;
1420 
1421     // Mapping from token id to position in the allTokens array
1422     mapping(uint256 => uint256) private _allTokensIndex;
1423 
1424     /**
1425      * @dev See {IERC165-supportsInterface}.
1426      */
1427     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1428         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1433      */
1434     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1435         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1436         return _ownedTokens[owner][index];
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Enumerable-totalSupply}.
1441      */
1442     function totalSupply() public view virtual override returns (uint256) {
1443         return _allTokens.length;
1444     }
1445 
1446     /**
1447      * @dev See {IERC721Enumerable-tokenByIndex}.
1448      */
1449     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1450         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1451         return _allTokens[index];
1452     }
1453 
1454     /**
1455      * @dev Hook that is called before any token transfer. This includes minting
1456      * and burning.
1457      *
1458      * Calling conditions:
1459      *
1460      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1461      * transferred to `to`.
1462      * - When `from` is zero, `tokenId` will be minted for `to`.
1463      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1464      * - `from` cannot be the zero address.
1465      * - `to` cannot be the zero address.
1466      *
1467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1468      */
1469     function _beforeTokenTransfer(
1470         address from,
1471         address to,
1472         uint256 tokenId
1473     ) internal virtual override {
1474         super._beforeTokenTransfer(from, to, tokenId);
1475 
1476         if (from == address(0)) {
1477             _addTokenToAllTokensEnumeration(tokenId);
1478         } else if (from != to) {
1479             _removeTokenFromOwnerEnumeration(from, tokenId);
1480         }
1481         if (to == address(0)) {
1482             _removeTokenFromAllTokensEnumeration(tokenId);
1483         } else if (to != from) {
1484             _addTokenToOwnerEnumeration(to, tokenId);
1485         }
1486     }
1487 
1488     /**
1489      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1490      * @param to address representing the new owner of the given token ID
1491      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1492      */
1493     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1494         uint256 length = ERC721.balanceOf(to);
1495         _ownedTokens[to][length] = tokenId;
1496         _ownedTokensIndex[tokenId] = length;
1497     }
1498 
1499     /**
1500      * @dev Private function to add a token to this extension's token tracking data structures.
1501      * @param tokenId uint256 ID of the token to be added to the tokens list
1502      */
1503     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1504         _allTokensIndex[tokenId] = _allTokens.length;
1505         _allTokens.push(tokenId);
1506     }
1507 
1508     /**
1509      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1510      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1511      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1512      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1513      * @param from address representing the previous owner of the given token ID
1514      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1515      */
1516     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1517         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1518         // then delete the last slot (swap and pop).
1519 
1520         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1521         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1522 
1523         // When the token to delete is the last token, the swap operation is unnecessary
1524         if (tokenIndex != lastTokenIndex) {
1525             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1526 
1527             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1528             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1529         }
1530 
1531         // This also deletes the contents at the last position of the array
1532         delete _ownedTokensIndex[tokenId];
1533         delete _ownedTokens[from][lastTokenIndex];
1534     }
1535 
1536     /**
1537      * @dev Private function to remove a token from this extension's token tracking data structures.
1538      * This has O(1) time complexity, but alters the order of the _allTokens array.
1539      * @param tokenId uint256 ID of the token to be removed from the tokens list
1540      */
1541     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1542         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1543         // then delete the last slot (swap and pop).
1544 
1545         uint256 lastTokenIndex = _allTokens.length - 1;
1546         uint256 tokenIndex = _allTokensIndex[tokenId];
1547 
1548         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1549         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1550         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1551         uint256 lastTokenId = _allTokens[lastTokenIndex];
1552 
1553         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1554         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1555 
1556         // This also deletes the contents at the last position of the array
1557         delete _allTokensIndex[tokenId];
1558         _allTokens.pop();
1559     }
1560 }
1561 
1562 /**
1563  * @dev ERC721 token with pausable token transfers, minting and burning.
1564  *
1565  * Useful for scenarios such as preventing trades until the end of an evaluation
1566  * period, or having an emergency switch for freezing all token transfers in the
1567  * event of a large bug.
1568  */
1569 abstract contract ERC721Pausable is ERC721, Ownable, Pausable {
1570     /**
1571      * @dev See {ERC721-_beforeTokenTransfer}.
1572      *
1573      * Requirements:
1574      *
1575      * - the contract must not be paused.
1576      */
1577     function _beforeTokenTransfer(
1578         address from,
1579         address to,
1580         uint256 tokenId
1581     ) internal virtual override {
1582         super._beforeTokenTransfer(from, to, tokenId);
1583         if (_msgSender() != owner()) {
1584             require(!paused(), "ERC721Pausable: token transfer while paused");
1585         }
1586     }
1587 }
1588 
1589 contract DoodleFriends is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable {
1590     using SafeMath for uint256;
1591     using Counters for Counters.Counter;
1592 
1593     Counters.Counter private _tokenIdTracker;
1594 
1595     bool public SALE_OPEN = false;
1596 
1597     uint256 private constant MAX_SUPPLY = 3353; // 3353 Doodle Friends
1598     uint256 private constant MAX_MINT_LIMITED = 3; // 3 batch mint max
1599     uint256 private constant MAX_MINT_UNLIMITED = 3353; // unlimited batch mint
1600 
1601     uint256 private constant PRICE_WHITELIST_ONE = 0.06 ether; // Stage One for Whitelist
1602     uint256 private constant PRICE_WHITELIST_TWO = 0.07 ether; // Stage Two for Whitelist
1603     uint256 private constant PRICE_PUBLIC = 0.08 ether; // Public Sale Price
1604 
1605     uint256 private _price;
1606     uint256 private _maxMint;
1607 
1608     mapping(uint256 => bool) private _isOccupiedId;
1609     uint256[] private _occupiedList;
1610 
1611     string private baseTokenURI;
1612 
1613     address private devWallet = payable(0x18236675fE58640dc2e9dDFfC478eC2EEea6Ca52); // Developer Wallet Address
1614     address private fundWallet = payable(0x269D13DaF86aec35e9bD12684B027CbA597360f1); // Owner Fund Wallet Address
1615 
1616     event DoodleFriendSummoned(address to, uint256 indexed id);
1617 
1618     modifier saleIsOpen {
1619         if (_msgSender() != owner()) {
1620             require(SALE_OPEN == true, "SALES: Please wait a big longer before buying Doodle Friends ;)");
1621         }
1622         require(_totalSupply() <= MAX_SUPPLY, "SALES: Sale end");
1623 
1624         if (_msgSender() != owner()) {
1625             require(!paused(), "PAUSABLE: Paused");
1626         }
1627         _;
1628     }
1629 
1630     constructor (string memory baseURI) ERC721("The Real Doodle Friends", "RealDoodleFriends") {
1631         setBaseURI(baseURI);
1632     }
1633 
1634     function mint(address payable _to, uint256[] memory _ids) public payable saleIsOpen {
1635         uint256 total = _totalSupply();
1636         uint256 maxNFTSupply = MAX_SUPPLY;
1637         uint256 maxMintCount = _maxMint;
1638         uint256 price = _price;
1639 
1640         require(total + _ids.length <= maxNFTSupply, "MINT: Current count exceeds maximum element count.");
1641         require(total <= maxNFTSupply, "MINT: Please go to the Opensea to buy Doodle Friends.");
1642         require(_ids.length <= maxMintCount, "MINT: Current count exceeds maximum mint count.");
1643         require(msg.value >= price * _ids.length, "MINT: Current value is below the sales price of Doodle Friends");
1644 
1645         for (uint256 i = 0; i < _ids.length; i++) {
1646             require(_isOccupiedId[_ids[i]] == false, "MINT: Those ids already have been used for other customers");
1647         }
1648 
1649         for (uint256 i = 0; i < _ids.length; i++) {
1650             _mintAnElement(_to, _ids[i]);
1651         }
1652     }
1653 
1654     function _mintAnElement(address payable _to, uint256 _id) private {
1655         _tokenIdTracker.increment();
1656         _safeMint(_to, _id);
1657         _isOccupiedId[_id] = true;
1658         _occupiedList.push(_id);
1659 
1660         emit DoodleFriendSummoned(_to, _id);
1661     }
1662 
1663     function startWhitelistOne() public onlyOwner {
1664         SALE_OPEN = true;
1665 
1666         _price = PRICE_WHITELIST_ONE;
1667         _maxMint = MAX_MINT_LIMITED;
1668     }
1669 
1670     function startWhitelistTwo() public onlyOwner {
1671         SALE_OPEN = true;
1672 
1673         _price = PRICE_WHITELIST_TWO;
1674         _maxMint = MAX_MINT_UNLIMITED;
1675     }
1676 
1677     function startPublicSale() public onlyOwner {
1678         SALE_OPEN = true;
1679 
1680         _price = PRICE_PUBLIC;
1681         _maxMint = MAX_MINT_UNLIMITED;
1682     }
1683 
1684     function flipSaleState() public onlyOwner {
1685         SALE_OPEN = !SALE_OPEN;
1686     }
1687 
1688     function setBaseURI(string memory baseURI) public onlyOwner {
1689         baseTokenURI = baseURI;
1690     }
1691 
1692     function setNewPrice(uint256 _newPrice) public onlyOwner {
1693         _price = _newPrice;
1694     }
1695 
1696     function _baseURI() internal view virtual override returns (string memory) {
1697         return baseTokenURI;
1698     }
1699 
1700     function _totalSupply() internal view returns (uint256) {
1701         return _tokenIdTracker.current();
1702     }
1703 
1704     function getPrice() public view returns (uint256) {
1705         return _price;
1706     }
1707 
1708     function maxSupply() public pure returns (uint256) {
1709         return MAX_SUPPLY;
1710     }
1711 
1712     function occupiedList() public view returns (uint256[] memory) {
1713         return _occupiedList;
1714     }
1715 
1716     function maxMint() public view returns (uint256) {
1717         return _maxMint;
1718     }
1719 
1720     function raised() public view returns (uint256) {
1721         return address(this).balance;
1722     }
1723 
1724     function getTokenIdsOfWallet(address _owner) external view returns (uint256[] memory) {
1725         uint256 tokenCount = balanceOf(_owner);
1726 
1727         uint256[] memory tokensId = new uint256[](tokenCount);
1728 
1729         for (uint256 i = 0; i < tokenCount; i++) {
1730             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1731         }
1732 
1733         return tokensId;
1734     }
1735 
1736     function withdrawAll() public payable onlyOwner {
1737         uint256 totalBalance = address(this).balance;
1738         require(totalBalance > 0, "WITHDRAW: No balance in contract");
1739 
1740         uint256 devBalance = totalBalance / 10; // 10% of total sale
1741         uint256 ownerBalance = totalBalance - devBalance; // 90% of total sale
1742 
1743         _widthdraw(devWallet, devBalance);
1744         _widthdraw(fundWallet, ownerBalance);
1745     }
1746 
1747     function _widthdraw(address _address, uint256 _amount) private {
1748         (bool success, ) = _address.call{value: _amount}("");
1749         require(success, "WITHDRAW: Transfer failed.");
1750     }
1751 
1752     function _beforeTokenTransfer(
1753         address from,
1754         address to,
1755         uint256 tokenId
1756     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
1757         super._beforeTokenTransfer(from, to, tokenId);
1758     }
1759 
1760     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1761         return super.supportsInterface(interfaceId);
1762     }
1763 }