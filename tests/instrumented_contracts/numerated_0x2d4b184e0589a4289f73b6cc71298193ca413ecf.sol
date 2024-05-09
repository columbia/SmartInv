1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor() {
25         _setOwner(_msgSender());
26     }
27 
28     /**
29      * @dev Returns the address of the current owner.
30      */
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     /**
44      * @dev Leaves the contract without owner. It will not be possible to call
45      * `onlyOwner` functions anymore. Can only be called by the current owner.
46      *
47      * NOTE: Renouncing ownership will leave the contract without an owner,
48      * thereby removing any functionality that is only available to the owner.
49      */
50     function renounceOwnership() public virtual onlyOwner {
51         _setOwner(address(0));
52     }
53 
54     /**
55      * @dev Transfers ownership of the contract to a new account (`newOwner`).
56      * Can only be called by the current owner.
57      */
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         _setOwner(newOwner);
61     }
62 
63     function _setOwner(address newOwner) private {
64         address oldOwner = _owner;
65         _owner = newOwner;
66         emit OwnershipTransferred(oldOwner, newOwner);
67     }
68 }
69 
70 abstract contract Pausable is Context {
71     /**
72      * @dev Emitted when the pause is triggered by `account`.
73      */
74     event Paused(address account);
75 
76     /**
77      * @dev Emitted when the pause is lifted by `account`.
78      */
79     event Unpaused(address account);
80 
81     bool private _paused;
82 
83     /**
84      * @dev Initializes the contract in unpaused state.
85      */
86     constructor() {
87         _paused = false;
88     }
89 
90     /**
91      * @dev Returns true if the contract is paused, and false otherwise.
92      */
93     function paused() public view virtual returns (bool) {
94         return _paused;
95     }
96 
97     /**
98      * @dev Modifier to make a function callable only when the contract is not paused.
99      *
100      * Requirements:
101      *
102      * - The contract must not be paused.
103      */
104     modifier whenNotPaused() {
105         require(!paused(), "Pausable: paused");
106         _;
107     }
108 
109     /**
110      * @dev Modifier to make a function callable only when the contract is paused.
111      *
112      * Requirements:
113      *
114      * - The contract must be paused.
115      */
116     modifier whenPaused() {
117         require(paused(), "Pausable: not paused");
118         _;
119     }
120 
121     /**
122      * @dev Triggers stopped state.
123      *
124      * Requirements:
125      *
126      * - The contract must not be paused.
127      */
128     function _pause() internal virtual whenNotPaused {
129         _paused = true;
130         emit Paused(_msgSender());
131     }
132 
133     /**
134      * @dev Returns to normal state.
135      *
136      * Requirements:
137      *
138      * - The contract must be paused.
139      */
140     function _unpause() internal virtual whenPaused {
141         _paused = false;
142         emit Unpaused(_msgSender());
143     }
144 }
145 
146 library Strings {
147     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
151      */
152     function toString(uint256 value) internal pure returns (string memory) {
153         // Inspired by OraclizeAPI's implementation - MIT licence
154         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
155 
156         if (value == 0) {
157             return "0";
158         }
159         uint256 temp = value;
160         uint256 digits;
161         while (temp != 0) {
162             digits++;
163             temp /= 10;
164         }
165         bytes memory buffer = new bytes(digits);
166         while (value != 0) {
167             digits -= 1;
168             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
169             value /= 10;
170         }
171         return string(buffer);
172     }
173 
174     /**
175      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
176      */
177     function toHexString(uint256 value) internal pure returns (string memory) {
178         if (value == 0) {
179             return "0x00";
180         }
181         uint256 temp = value;
182         uint256 length = 0;
183         while (temp != 0) {
184             length++;
185             temp >>= 8;
186         }
187         return toHexString(value, length);
188     }
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
192      */
193     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
194         bytes memory buffer = new bytes(2 * length + 2);
195         buffer[0] = "0";
196         buffer[1] = "x";
197         for (uint256 i = 2 * length + 1; i > 1; --i) {
198             buffer[i] = _HEX_SYMBOLS[value & 0xf];
199             value >>= 4;
200         }
201         require(value == 0, "Strings: hex length insufficient");
202         return string(buffer);
203     }
204 }
205 
206 
207 library SafeMath {
208     /**
209      * @dev Returns the addition of two unsigned integers, with an overflow flag.
210      *
211      * _Available since v3.4._
212      */
213     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
214         unchecked {
215             uint256 c = a + b;
216             if (c < a) return (false, 0);
217             return (true, c);
218         }
219     }
220 
221     /**
222      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
223      *
224      * _Available since v3.4._
225      */
226     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             if (b > a) return (false, 0);
229             return (true, a - b);
230         }
231     }
232 
233     /**
234      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
235      *
236      * _Available since v3.4._
237      */
238     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
239         unchecked {
240             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
241             // benefit is lost if 'b' is also tested.
242             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
243             if (a == 0) return (true, 0);
244             uint256 c = a * b;
245             if (c / a != b) return (false, 0);
246             return (true, c);
247         }
248     }
249 
250     /**
251      * @dev Returns the division of two unsigned integers, with a division by zero flag.
252      *
253      * _Available since v3.4._
254      */
255     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             if (b == 0) return (false, 0);
258             return (true, a / b);
259         }
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
264      *
265      * _Available since v3.4._
266      */
267     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (b == 0) return (false, 0);
270             return (true, a % b);
271         }
272     }
273 
274     /**
275      * @dev Returns the addition of two unsigned integers, reverting on
276      * overflow.
277      *
278      * Counterpart to Solidity's `+` operator.
279      *
280      * Requirements:
281      *
282      * - Addition cannot overflow.
283      */
284     function add(uint256 a, uint256 b) internal pure returns (uint256) {
285         return a + b;
286     }
287 
288     /**
289      * @dev Returns the subtraction of two unsigned integers, reverting on
290      * overflow (when the result is negative).
291      *
292      * Counterpart to Solidity's `-` operator.
293      *
294      * Requirements:
295      *
296      * - Subtraction cannot overflow.
297      */
298     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a - b;
300     }
301 
302     /**
303      * @dev Returns the multiplication of two unsigned integers, reverting on
304      * overflow.
305      *
306      * Counterpart to Solidity's `*` operator.
307      *
308      * Requirements:
309      *
310      * - Multiplication cannot overflow.
311      */
312     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
313         return a * b;
314     }
315 
316     /**
317      * @dev Returns the integer division of two unsigned integers, reverting on
318      * division by zero. The result is rounded towards zero.
319      *
320      * Counterpart to Solidity's `/` operator.
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function div(uint256 a, uint256 b) internal pure returns (uint256) {
327         return a / b;
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * reverting when dividing by zero.
333      *
334      * Counterpart to Solidity's `%` operator. This function uses a `revert`
335      * opcode (which leaves remaining gas untouched) while Solidity uses an
336      * invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      *
340      * - The divisor cannot be zero.
341      */
342     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a % b;
344     }
345 
346     /**
347      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
348      * overflow (when the result is negative).
349      *
350      * CAUTION: This function is deprecated because it requires allocating memory for the error
351      * message unnecessarily. For custom revert reasons use {trySub}.
352      *
353      * Counterpart to Solidity's `-` operator.
354      *
355      * Requirements:
356      *
357      * - Subtraction cannot overflow.
358      */
359     function sub(
360         uint256 a,
361         uint256 b,
362         string memory errorMessage
363     ) internal pure returns (uint256) {
364         unchecked {
365             require(b <= a, errorMessage);
366             return a - b;
367         }
368     }
369 
370     /**
371      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
372      * division by zero. The result is rounded towards zero.
373      *
374      * Counterpart to Solidity's `/` operator. Note: this function uses a
375      * `revert` opcode (which leaves remaining gas untouched) while Solidity
376      * uses an invalid opcode to revert (consuming all remaining gas).
377      *
378      * Requirements:
379      *
380      * - The divisor cannot be zero.
381      */
382     function div(
383         uint256 a,
384         uint256 b,
385         string memory errorMessage
386     ) internal pure returns (uint256) {
387         unchecked {
388             require(b > 0, errorMessage);
389             return a / b;
390         }
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
395      * reverting with custom message when dividing by zero.
396      *
397      * CAUTION: This function is deprecated because it requires allocating memory for the error
398      * message unnecessarily. For custom revert reasons use {tryMod}.
399      *
400      * Counterpart to Solidity's `%` operator. This function uses a `revert`
401      * opcode (which leaves remaining gas untouched) while Solidity uses an
402      * invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function mod(
409         uint256 a,
410         uint256 b,
411         string memory errorMessage
412     ) internal pure returns (uint256) {
413         unchecked {
414             require(b > 0, errorMessage);
415             return a % b;
416         }
417     }
418 }
419 
420 /**
421  * @dev Interface of the ERC165 standard, as defined in the
422  * https://eips.ethereum.org/EIPS/eip-165[EIP].
423  *
424  * Implementers can declare support of contract interfaces, which can then be
425  * queried by others ({ERC165Checker}).
426  *
427  * For an implementation, see {ERC165}.
428  */
429 interface IERC165 {
430     /**
431      * @dev Returns true if this contract implements the interface defined by
432      * `interfaceId`. See the corresponding
433      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
434      * to learn more about how these ids are created.
435      *
436      * This function call must use less than 30 000 gas.
437      */
438     function supportsInterface(bytes4 interfaceId) external view returns (bool);
439 }
440 
441 
442 /**
443  * @dev Implementation of the {IERC165} interface.
444  *
445  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
446  * for the additional interface id that will be supported. For example:
447  *
448  * ```solidity
449  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
450  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
451  * }
452  * ```
453  *
454  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
455  */
456 abstract contract ERC165 is IERC165 {
457     /**
458      * @dev See {IERC165-supportsInterface}.
459      */
460     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
461         return interfaceId == type(IERC165).interfaceId;
462     }
463 }
464 
465 library Counters {
466     struct Counter {
467         // This variable should never be directly accessed by users of the library: interactions must be restricted to
468         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
469         // this feature: see https://github.com/ethereum/solidity/issues/4637
470         uint256 _value; // default: 0
471     }
472 
473     function current(Counter storage counter) internal view returns (uint256) {
474         return counter._value;
475     }
476 
477     function increment(Counter storage counter) internal {
478         unchecked {
479             counter._value += 1;
480         }
481     }
482 
483     function decrement(Counter storage counter) internal {
484         uint256 value = counter._value;
485         require(value > 0, "Counter: decrement overflow");
486         unchecked {
487             counter._value = value - 1;
488         }
489     }
490 
491     function reset(Counter storage counter) internal {
492         counter._value = 0;
493     }
494 }
495 
496 library Address {
497     /**
498      * @dev Returns true if `account` is a contract.
499      *
500      * [IMPORTANT]
501      * ====
502      * It is unsafe to assume that an address for which this function returns
503      * false is an externally-owned account (EOA) and not a contract.
504      *
505      * Among others, `isContract` will return false for the following
506      * types of addresses:
507      *
508      *  - an externally-owned account
509      *  - a contract in construction
510      *  - an address where a contract will be created
511      *  - an address where a contract lived, but was destroyed
512      * ====
513      */
514     function isContract(address account) internal view returns (bool) {
515         // This method relies on extcodesize, which returns 0 for contracts in
516         // construction, since the code is only stored at the end of the
517         // constructor execution.
518 
519         uint256 size;
520         assembly {
521             size := extcodesize(account)
522         }
523         return size > 0;
524     }
525 
526     /**
527      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
528      * `recipient`, forwarding all available gas and reverting on errors.
529      *
530      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
531      * of certain opcodes, possibly making contracts go over the 2300 gas limit
532      * imposed by `transfer`, making them unable to receive funds via
533      * `transfer`. {sendValue} removes this limitation.
534      *
535      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
536      *
537      * IMPORTANT: because control is transferred to `recipient`, care must be
538      * taken to not create reentrancy vulnerabilities. Consider using
539      * {ReentrancyGuard} or the
540      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
541      */
542     function sendValue(address payable recipient, uint256 amount) internal {
543         require(address(this).balance >= amount, "Address: insufficient balance");
544 
545         (bool success, ) = recipient.call{value: amount}("");
546         require(success, "Address: unable to send value, recipient may have reverted");
547     }
548 
549     /**
550      * @dev Performs a Solidity function call using a low level `call`. A
551      * plain `call` is an unsafe replacement for a function call: use this
552      * function instead.
553      *
554      * If `target` reverts with a revert reason, it is bubbled up by this
555      * function (like regular Solidity function calls).
556      *
557      * Returns the raw returned data. To convert to the expected return value,
558      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
559      *
560      * Requirements:
561      *
562      * - `target` must be a contract.
563      * - calling `target` with `data` must not revert.
564      *
565      * _Available since v3.1._
566      */
567     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
568         return functionCall(target, data, "Address: low-level call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
573      * `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCall(
578         address target,
579         bytes memory data,
580         string memory errorMessage
581     ) internal returns (bytes memory) {
582         return functionCallWithValue(target, data, 0, errorMessage);
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
587      * but also transferring `value` wei to `target`.
588      *
589      * Requirements:
590      *
591      * - the calling contract must have an ETH balance of at least `value`.
592      * - the called Solidity function must be `payable`.
593      *
594      * _Available since v3.1._
595      */
596     function functionCallWithValue(
597         address target,
598         bytes memory data,
599         uint256 value
600     ) internal returns (bytes memory) {
601         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
606      * with `errorMessage` as a fallback revert reason when `target` reverts.
607      *
608      * _Available since v3.1._
609      */
610     function functionCallWithValue(
611         address target,
612         bytes memory data,
613         uint256 value,
614         string memory errorMessage
615     ) internal returns (bytes memory) {
616         require(address(this).balance >= value, "Address: insufficient balance for call");
617         require(isContract(target), "Address: call to non-contract");
618 
619         (bool success, bytes memory returndata) = target.call{value: value}(data);
620         return _verifyCallResult(success, returndata, errorMessage);
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
625      * but performing a static call.
626      *
627      * _Available since v3.3._
628      */
629     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
630         return functionStaticCall(target, data, "Address: low-level static call failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
635      * but performing a static call.
636      *
637      * _Available since v3.3._
638      */
639     function functionStaticCall(
640         address target,
641         bytes memory data,
642         string memory errorMessage
643     ) internal view returns (bytes memory) {
644         require(isContract(target), "Address: static call to non-contract");
645 
646         (bool success, bytes memory returndata) = target.staticcall(data);
647         return _verifyCallResult(success, returndata, errorMessage);
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
652      * but performing a delegate call.
653      *
654      * _Available since v3.4._
655      */
656     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
657         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
658     }
659 
660     /**
661      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
662      * but performing a delegate call.
663      *
664      * _Available since v3.4._
665      */
666     function functionDelegateCall(
667         address target,
668         bytes memory data,
669         string memory errorMessage
670     ) internal returns (bytes memory) {
671         require(isContract(target), "Address: delegate call to non-contract");
672 
673         (bool success, bytes memory returndata) = target.delegatecall(data);
674         return _verifyCallResult(success, returndata, errorMessage);
675     }
676 
677     function _verifyCallResult(
678         bool success,
679         bytes memory returndata,
680         string memory errorMessage
681     ) private pure returns (bytes memory) {
682         if (success) {
683             return returndata;
684         } else {
685             // Look for revert reason and bubble it up if present
686             if (returndata.length > 0) {
687                 // The easiest way to bubble the revert reason is using memory via assembly
688 
689                 assembly {
690                     let returndata_size := mload(returndata)
691                     revert(add(32, returndata), returndata_size)
692                 }
693             } else {
694                 revert(errorMessage);
695             }
696         }
697     }
698 }
699 
700 interface IERC721Receiver {
701     /**
702      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
703      * by `operator` from `from`, this function is called.
704      *
705      * It must return its Solidity selector to confirm the token transfer.
706      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
707      *
708      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
709      */
710     function onERC721Received(
711         address operator,
712         address from,
713         uint256 tokenId,
714         bytes calldata data
715     ) external returns (bytes4);
716 }
717 
718 interface IERC721 is IERC165 {
719     /**
720      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
721      */
722     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
723 
724     /**
725      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
726      */
727     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
728 
729     /**
730      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
731      */
732     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
733 
734     /**
735      * @dev Returns the number of tokens in ``owner``'s account.
736      */
737     function balanceOf(address owner) external view returns (uint256 balance);
738 
739     /**
740      * @dev Returns the owner of the `tokenId` token.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function ownerOf(uint256 tokenId) external view returns (address owner);
747 
748     /**
749      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
750      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
751      *
752      * Requirements:
753      *
754      * - `from` cannot be the zero address.
755      * - `to` cannot be the zero address.
756      * - `tokenId` token must exist and be owned by `from`.
757      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
758      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
759      *
760      * Emits a {Transfer} event.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) external;
767 
768     /**
769      * @dev Transfers `tokenId` token from `from` to `to`.
770      *
771      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must be owned by `from`.
778      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
779      *
780      * Emits a {Transfer} event.
781      */
782     function transferFrom(
783         address from,
784         address to,
785         uint256 tokenId
786     ) external;
787 
788     /**
789      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
790      * The approval is cleared when the token is transferred.
791      *
792      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
793      *
794      * Requirements:
795      *
796      * - The caller must own the token or be an approved operator.
797      * - `tokenId` must exist.
798      *
799      * Emits an {Approval} event.
800      */
801     function approve(address to, uint256 tokenId) external;
802 
803     /**
804      * @dev Returns the account approved for `tokenId` token.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must exist.
809      */
810     function getApproved(uint256 tokenId) external view returns (address operator);
811 
812     /**
813      * @dev Approve or remove `operator` as an operator for the caller.
814      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
815      *
816      * Requirements:
817      *
818      * - The `operator` cannot be the caller.
819      *
820      * Emits an {ApprovalForAll} event.
821      */
822     function setApprovalForAll(address operator, bool _approved) external;
823 
824     /**
825      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
826      *
827      * See {setApprovalForAll}
828      */
829     function isApprovedForAll(address owner, address operator) external view returns (bool);
830 
831     /**
832      * @dev Safely transfers `tokenId` token from `from` to `to`.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must exist and be owned by `from`.
839      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
840      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
841      *
842      * Emits a {Transfer} event.
843      */
844     function safeTransferFrom(
845         address from,
846         address to,
847         uint256 tokenId,
848         bytes calldata data
849     ) external;
850 }
851 
852 interface IERC721Metadata is IERC721 {
853     /**
854      * @dev Returns the token collection name.
855      */
856     function name() external view returns (string memory);
857 
858     /**
859      * @dev Returns the token collection symbol.
860      */
861     function symbol() external view returns (string memory);
862 
863     /**
864      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
865      */
866     function tokenURI(uint256 tokenId) external view returns (string memory);
867 }
868 
869 interface IERC721Enumerable is IERC721 {
870     /**
871      * @dev Returns the total amount of tokens stored by the contract.
872      */
873     function totalSupply() external view returns (uint256);
874 
875     /**
876      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
877      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
878      */
879     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
880 
881     /**
882      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
883      * Use along with {totalSupply} to enumerate all tokens.
884      */
885     function tokenByIndex(uint256 index) external view returns (uint256);
886 }
887 
888 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
889     using Address for address;
890     using Strings for uint256;
891 
892     // Token name
893     string private _name;
894 
895     // Token symbol
896     string private _symbol;
897 
898     // Mapping from token ID to owner address
899     mapping(uint256 => address) private _owners;
900 
901     // Mapping owner address to token count
902     mapping(address => uint256) private _balances;
903 
904     // Mapping from token ID to approved address
905     mapping(uint256 => address) private _tokenApprovals;
906 
907     // Mapping from owner to operator approvals
908     mapping(address => mapping(address => bool)) private _operatorApprovals;
909 
910     /**
911      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
912      */
913     constructor(string memory name_, string memory symbol_) {
914         _name = name_;
915         _symbol = symbol_;
916     }
917 
918     /**
919      * @dev See {IERC165-supportsInterface}.
920      */
921     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
922         return
923             interfaceId == type(IERC721).interfaceId ||
924             interfaceId == type(IERC721Metadata).interfaceId ||
925             super.supportsInterface(interfaceId);
926     }
927 
928     /**
929      * @dev See {IERC721-balanceOf}.
930      */
931     function balanceOf(address owner) public view virtual override returns (uint256) {
932         require(owner != address(0), "ERC721: balance query for the zero address");
933         return _balances[owner];
934     }
935 
936     /**
937      * @dev See {IERC721-ownerOf}.
938      */
939     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
940         address owner = _owners[tokenId];
941         require(owner != address(0), "ERC721: owner query for nonexistent token");
942         return owner;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-name}.
947      */
948     function name() public view virtual override returns (string memory) {
949         return _name;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-symbol}.
954      */
955     function symbol() public view virtual override returns (string memory) {
956         return _symbol;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-tokenURI}.
961      */
962     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
963         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
964 
965         string memory baseURI = _baseURI();
966         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : "";
967     }
968 
969     /**
970      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
971      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
972      * by default, can be overriden in child contracts.
973      */
974     function _baseURI() internal view virtual returns (string memory) {
975         return "";
976     }
977 
978     /**
979      * @dev See {IERC721-approve}.
980      */
981     function approve(address to, uint256 tokenId) public virtual override {
982         address owner = ERC721.ownerOf(tokenId);
983         require(to != owner, "ERC721: approval to current owner");
984 
985         require(
986             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
987             "ERC721: approve caller is not owner nor approved for all"
988         );
989 
990         _approve(to, tokenId);
991     }
992 
993     /**
994      * @dev See {IERC721-getApproved}.
995      */
996     function getApproved(uint256 tokenId) public view virtual override returns (address) {
997         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
998 
999         return _tokenApprovals[tokenId];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-setApprovalForAll}.
1004      */
1005     function setApprovalForAll(address operator, bool approved) public virtual override {
1006         require(operator != _msgSender(), "ERC721: approve to caller");
1007 
1008         _operatorApprovals[_msgSender()][operator] = approved;
1009         emit ApprovalForAll(_msgSender(), operator, approved);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-isApprovedForAll}.
1014      */
1015     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1016         return _operatorApprovals[owner][operator];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-transferFrom}.
1021      */
1022     function transferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public virtual override {
1027         //solhint-disable-next-line max-line-length
1028         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1029 
1030         _transfer(from, to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         safeTransferFrom(from, to, tokenId, "");
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) public virtual override {
1053         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1054         _safeTransfer(from, to, tokenId, _data);
1055     }
1056 
1057     /**
1058      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1059      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1060      *
1061      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1062      *
1063      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1064      * implement alternative mechanisms to perform token transfer, such as signature-based.
1065      *
1066      * Requirements:
1067      *
1068      * - `from` cannot be the zero address.
1069      * - `to` cannot be the zero address.
1070      * - `tokenId` token must exist and be owned by `from`.
1071      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _safeTransfer(
1076         address from,
1077         address to,
1078         uint256 tokenId,
1079         bytes memory _data
1080     ) internal virtual {
1081         _transfer(from, to, tokenId);
1082         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1083     }
1084 
1085     /**
1086      * @dev Returns whether `tokenId` exists.
1087      *
1088      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1089      *
1090      * Tokens start existing when they are minted (`_mint`),
1091      * and stop existing when they are burned (`_burn`).
1092      */
1093     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1094         return _owners[tokenId] != address(0);
1095     }
1096 
1097     /**
1098      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1099      *
1100      * Requirements:
1101      *
1102      * - `tokenId` must exist.
1103      */
1104     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1105         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1106         address owner = ERC721.ownerOf(tokenId);
1107         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1108     }
1109 
1110     /**
1111      * @dev Safely mints `tokenId` and transfers it to `to`.
1112      *
1113      * Requirements:
1114      *
1115      * - `tokenId` must not exist.
1116      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _safeMint(address to, uint256 tokenId) internal virtual {
1121         _safeMint(to, tokenId, "");
1122     }
1123 
1124     /**
1125      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1126      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1127      */
1128     function _safeMint(
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) internal virtual {
1133         _mint(to, tokenId);
1134         require(
1135             _checkOnERC721Received(address(0), to, tokenId, _data),
1136             "ERC721: transfer to non ERC721Receiver implementer"
1137         );
1138     }
1139 
1140     /**
1141      * @dev Mints `tokenId` and transfers it to `to`.
1142      *
1143      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1144      *
1145      * Requirements:
1146      *
1147      * - `tokenId` must not exist.
1148      * - `to` cannot be the zero address.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _mint(address to, uint256 tokenId) internal virtual {
1153         require(to != address(0), "ERC721: mint to the zero address");
1154         require(!_exists(tokenId), "ERC721: token already minted");
1155 
1156         _beforeTokenTransfer(address(0), to, tokenId);
1157 
1158         _balances[to] += 1;
1159         _owners[tokenId] = to;
1160 
1161         emit Transfer(address(0), to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev Destroys `tokenId`.
1166      * The approval is cleared when the token is burned.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _burn(uint256 tokenId) internal virtual {
1175         address owner = ERC721.ownerOf(tokenId);
1176 
1177         _beforeTokenTransfer(owner, address(0), tokenId);
1178 
1179         // Clear approvals
1180         _approve(address(0), tokenId);
1181 
1182         _balances[owner] -= 1;
1183         delete _owners[tokenId];
1184 
1185         emit Transfer(owner, address(0), tokenId);
1186     }
1187 
1188     /**
1189      * @dev Transfers `tokenId` from `from` to `to`.
1190      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1191      *
1192      * Requirements:
1193      *
1194      * - `to` cannot be the zero address.
1195      * - `tokenId` token must be owned by `from`.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function _transfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) internal virtual {
1204         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1205         require(to != address(0), "ERC721: transfer to the zero address");
1206 
1207         _beforeTokenTransfer(from, to, tokenId);
1208 
1209         // Clear approvals from the previous owner
1210         _approve(address(0), tokenId);
1211 
1212         _balances[from] -= 1;
1213         _balances[to] += 1;
1214         _owners[tokenId] = to;
1215 
1216         emit Transfer(from, to, tokenId);
1217     }
1218 
1219     /**
1220      * @dev Approve `to` to operate on `tokenId`
1221      *
1222      * Emits a {Approval} event.
1223      */
1224     function _approve(address to, uint256 tokenId) internal virtual {
1225         _tokenApprovals[tokenId] = to;
1226         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1227     }
1228 
1229     /**
1230      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1231      * The call is not executed if the target address is not a contract.
1232      *
1233      * @param from address representing the previous owner of the given token ID
1234      * @param to target address that will receive the tokens
1235      * @param tokenId uint256 ID of the token to be transferred
1236      * @param _data bytes optional data to send along with the call
1237      * @return bool whether the call correctly returned the expected magic value
1238      */
1239     function _checkOnERC721Received(
1240         address from,
1241         address to,
1242         uint256 tokenId,
1243         bytes memory _data
1244     ) private returns (bool) {
1245         if (to.isContract()) {
1246             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1247                 return retval == IERC721Receiver(to).onERC721Received.selector;
1248             } catch (bytes memory reason) {
1249                 if (reason.length == 0) {
1250                     revert("ERC721: transfer to non ERC721Receiver implementer");
1251                 } else {
1252                     assembly {
1253                         revert(add(32, reason), mload(reason))
1254                     }
1255                 }
1256             }
1257         } else {
1258             return true;
1259         }
1260     }
1261 
1262     /**
1263      * @dev Hook that is called before any token transfer. This includes minting
1264      * and burning.
1265      *
1266      * Calling conditions:
1267      *
1268      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1269      * transferred to `to`.
1270      * - When `from` is zero, `tokenId` will be minted for `to`.
1271      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1272      * - `from` and `to` are never both zero.
1273      *
1274      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1275      */
1276     function _beforeTokenTransfer(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) internal virtual {}
1281 }
1282 
1283 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1284     // Mapping from owner to list of owned token IDs
1285     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1286 
1287     // Mapping from token ID to index of the owner tokens list
1288     mapping(uint256 => uint256) private _ownedTokensIndex;
1289 
1290     // Array with all token ids, used for enumeration
1291     uint256[] private _allTokens;
1292 
1293     // Mapping from token id to position in the allTokens array
1294     mapping(uint256 => uint256) private _allTokensIndex;
1295 
1296     /**
1297      * @dev See {IERC165-supportsInterface}.
1298      */
1299     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1300         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1301     }
1302 
1303     /**
1304      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1305      */
1306     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1307         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1308         return _ownedTokens[owner][index];
1309     }
1310 
1311     /**
1312      * @dev See {IERC721Enumerable-totalSupply}.
1313      */
1314     function totalSupply() public view virtual override returns (uint256) {
1315         return _allTokens.length;
1316     }
1317 
1318     /**
1319      * @dev See {IERC721Enumerable-tokenByIndex}.
1320      */
1321     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1322         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1323         return _allTokens[index];
1324     }
1325 
1326     /**
1327      * @dev Hook that is called before any token transfer. This includes minting
1328      * and burning.
1329      *
1330      * Calling conditions:
1331      *
1332      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1333      * transferred to `to`.
1334      * - When `from` is zero, `tokenId` will be minted for `to`.
1335      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1336      * - `from` cannot be the zero address.
1337      * - `to` cannot be the zero address.
1338      *
1339      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1340      */
1341     function _beforeTokenTransfer(
1342         address from,
1343         address to,
1344         uint256 tokenId
1345     ) internal virtual override {
1346         super._beforeTokenTransfer(from, to, tokenId);
1347 
1348         if (from == address(0)) {
1349             _addTokenToAllTokensEnumeration(tokenId);
1350         } else if (from != to) {
1351             _removeTokenFromOwnerEnumeration(from, tokenId);
1352         }
1353         if (to == address(0)) {
1354             _removeTokenFromAllTokensEnumeration(tokenId);
1355         } else if (to != from) {
1356             _addTokenToOwnerEnumeration(to, tokenId);
1357         }
1358     }
1359 
1360     /**
1361      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1362      * @param to address representing the new owner of the given token ID
1363      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1364      */
1365     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1366         uint256 length = ERC721.balanceOf(to);
1367         _ownedTokens[to][length] = tokenId;
1368         _ownedTokensIndex[tokenId] = length;
1369     }
1370 
1371     /**
1372      * @dev Private function to add a token to this extension's token tracking data structures.
1373      * @param tokenId uint256 ID of the token to be added to the tokens list
1374      */
1375     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1376         _allTokensIndex[tokenId] = _allTokens.length;
1377         _allTokens.push(tokenId);
1378     }
1379 
1380     /**
1381      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1382      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1383      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1384      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1385      * @param from address representing the previous owner of the given token ID
1386      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1387      */
1388     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1389         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1390         // then delete the last slot (swap and pop).
1391 
1392         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1393         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1394 
1395         // When the token to delete is the last token, the swap operation is unnecessary
1396         if (tokenIndex != lastTokenIndex) {
1397             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1398 
1399             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1400             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1401         }
1402 
1403         // This also deletes the contents at the last position of the array
1404         delete _ownedTokensIndex[tokenId];
1405         delete _ownedTokens[from][lastTokenIndex];
1406     }
1407 
1408     /**
1409      * @dev Private function to remove a token from this extension's token tracking data structures.
1410      * This has O(1) time complexity, but alters the order of the _allTokens array.
1411      * @param tokenId uint256 ID of the token to be removed from the tokens list
1412      */
1413     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1414         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1415         // then delete the last slot (swap and pop).
1416 
1417         uint256 lastTokenIndex = _allTokens.length - 1;
1418         uint256 tokenIndex = _allTokensIndex[tokenId];
1419 
1420         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1421         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1422         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1423         uint256 lastTokenId = _allTokens[lastTokenIndex];
1424 
1425         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1426         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1427 
1428         // This also deletes the contents at the last position of the array
1429         delete _allTokensIndex[tokenId];
1430         _allTokens.pop();
1431     }
1432 }
1433 
1434 abstract contract ERC721Burnable is Context, ERC721 {
1435     /**
1436      * @dev Burns `tokenId`. See {ERC721-_burn}.
1437      *
1438      * Requirements:
1439      *
1440      * - The caller must own `tokenId` or be an approved operator.
1441      */
1442     function burn(uint256 tokenId) public virtual {
1443         //solhint-disable-next-line max-line-length
1444         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1445         _burn(tokenId);
1446     }
1447 }
1448 
1449 abstract contract ERC721Pausable is ERC721, Ownable, Pausable {
1450     /**
1451      * @dev See {ERC721-_beforeTokenTransfer}.
1452      *
1453      * Requirements:
1454      *
1455      * - the contract must not be paused.
1456      */
1457     function _beforeTokenTransfer(
1458         address from,
1459         address to,
1460         uint256 tokenId
1461     ) internal virtual override {
1462         super._beforeTokenTransfer(from, to, tokenId);
1463         if (_msgSender() != owner()) {
1464             require(!paused(), "ERC721Pausable: token transfer while paused");
1465         }
1466     }
1467 }
1468 
1469 contract KodachiUnMasked is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable {
1470     using SafeMath for uint256;
1471     using Counters for Counters.Counter;
1472 
1473     Counters.Counter private _tokenIdTracker;
1474 
1475     uint256 public constant MAX_ELEMENTS = 369;
1476     uint256 public constant PRICE = 145 * 10**15;
1477     string public baseTokenURI;
1478 
1479     constructor(string memory baseURI) ERC721("Kodachi unMasked", "Kodachi_unMasked") {
1480         setBaseURI(baseURI);
1481         pause(true);
1482     }
1483 
1484     modifier saleIsOpen {
1485         require(_totalSupply() <= MAX_ELEMENTS, "Sale end");
1486         if (_msgSender() != owner()) {
1487             require(!paused(), "Pausable: paused");
1488         }
1489         _;
1490     }
1491     function _totalSupply() internal view returns (uint) {
1492         return _tokenIdTracker.current();
1493     }
1494     function totalMint() public view returns (uint256) {
1495         return _totalSupply();
1496     }
1497     function mint(address _to, uint256 _count) public payable saleIsOpen {
1498         uint256 total = _totalSupply();
1499         require(total + _count <= MAX_ELEMENTS, "Max limit");
1500         require(total <= MAX_ELEMENTS, "Sale end");
1501         require(msg.value >= price(_count), "Value below price");
1502 
1503         for (uint256 i = 0; i < _count; i++) {
1504             _mintAnElement(_to);
1505         }
1506     }
1507 
1508     function adminMint(address _to, uint256 _count) external onlyOwner {
1509         uint256 total = _totalSupply();
1510         require(total + _count <= MAX_ELEMENTS, "Max limit");
1511         require(total <= MAX_ELEMENTS, "Sale end");
1512 
1513         for (uint256 i = 0; i < _count; i++) {
1514             _mintAnElement(_to);
1515         }
1516     }
1517 
1518     
1519     function _mintAnElement(address _to) private {
1520         uint id = _totalSupply() + 1;
1521         _tokenIdTracker.increment();
1522         _safeMint(_to, id);
1523     }
1524     function price(uint256 _count) public pure returns (uint256) {
1525         return PRICE.mul(_count);
1526     }
1527 
1528     function _baseURI() internal view virtual override returns (string memory) {
1529         return baseTokenURI;
1530     }
1531 
1532     function setBaseURI(string memory baseURI) public onlyOwner {
1533         baseTokenURI = baseURI;
1534     }
1535 
1536     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
1537         uint256 tokenCount = balanceOf(_owner);
1538 
1539         uint256[] memory tokensId = new uint256[](tokenCount);
1540         for (uint256 i = 0; i < tokenCount; i++) {
1541             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1542         }
1543 
1544         return tokensId;
1545     }
1546 
1547     function pause(bool val) public onlyOwner {
1548         if (val == true) {
1549             _pause();
1550             return;
1551         }
1552         _unpause();
1553     }
1554 
1555     function withdrawAll() public payable onlyOwner {
1556         uint256 balance = address(this).balance;
1557         require(balance > 0, "Insufficient balance");
1558         _widthdraw(owner(), balance);
1559     }
1560 
1561     function _widthdraw(address _address, uint256 _amount) private {
1562         (bool success, ) = _address.call{value: _amount}("");
1563         require(success, "Transfer failed.");
1564     }
1565 
1566     function _beforeTokenTransfer(
1567         address from,
1568         address to,
1569         uint256 tokenId
1570     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
1571         super._beforeTokenTransfer(from, to, tokenId);
1572     }
1573 
1574     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1575         return super.supportsInterface(interfaceId);
1576     }
1577     
1578 }