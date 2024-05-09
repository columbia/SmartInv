1 // SPDX-License-Identifier: MIT
2 
3 /////////////////////////////////////////////////////////////////////////////
4 /////////////////////////////////////////////////////////////////////////////
5 ////                                                                     ////
6 ////                                                                     ////
7 ////                                                                     ////
8 ////                                                                     ////
9 ////                                                                     ////
10 ////                                                                     ////
11 ////                //////////                //////////                 ////
12 ////                //////////                //////////                 ////
13 ////                ////  ////                ////  ////                 ////
14 ////                //////////                //////////                 ////
15 ////                //////////                //////////                 ////
16 ////                                                                     ////
17 ////                                                                     ////
18 ////                                                                     ////
19 ////                                                                     ////
20 ////                                                                     ////
21 ////                                                                     ////
22 ////                                                                     ////
23 ////                                                                     ////
24 ////                //////                          ////                 ////
25 ////                //////                          ////                 //// 
26 ////                ////////////////////////////////////                 ////
27 ////                ////////////////////////////////////                 ////
28 ////                                                                     ////
29 ////                                                                     ////
30 ////                                                                     ////
31 ////                                                                     ////
32 ////                                                                     ////
33 /////////////////////////////////////////////////////////////////////////////
34 /////////////////////////////////////////////////////////////////////////////
35 
36 // FomoBotz is 10101 unique botz algorithmically created and now zipping around the metaverse.
37 
38 
39 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
40 
41 
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Interface of the ERC165 standard, as defined in the
47  * https://eips.ethereum.org/EIPS/eip-165[EIP].
48  *
49  * Implementers can declare support of contract interfaces, which can then be
50  * queried by others ({ERC165Checker}).
51  *
52  * For an implementation, see {ERC165}.
53  */
54 interface IERC165 {
55     /**
56      * @dev Returns true if this contract implements the interface defined by
57      * `interfaceId`. See the corresponding
58      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
59      * to learn more about how these ids are created.
60      *
61      * This function call must use less than 30 000 gas.
62      */
63     function supportsInterface(bytes4 interfaceId) external view returns (bool);
64 }
65 
66 // File: @openzeppelin/contracts/utils/Context.sol
67 
68 
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev Provides information about the current execution context, including the
74  * sender of the transaction and its data. While these are generally available
75  * via msg.sender and msg.data, they should not be accessed in such a direct
76  * manner, since when dealing with meta-transactions the account sending and
77  * paying for execution may not be the actual sender (as far as an application
78  * is concerned).
79  *
80  * This contract is only required for intermediate, library-like contracts.
81  */
82 abstract contract Context {
83     function _msgSender() internal view virtual returns (address) {
84         return msg.sender;
85     }
86 
87     function _msgData() internal view virtual returns (bytes calldata) {
88         return msg.data;
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/Counters.sol
93 
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @title Counters
99  * @author Matt Condon (@shrugs)
100  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
101  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
102  *
103  * Include with `using Counters for Counters.Counter;`
104  */
105 library Counters {
106     struct Counter {
107         // This variable should never be directly accessed by users of the library: interactions must be restricted to
108         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
109         // this feature: see https://github.com/ethereum/solidity/issues/4637
110         uint256 _value; // default: 0
111     }
112 
113     function current(Counter storage counter) internal view returns (uint256) {
114         return counter._value;
115     }
116 
117     function increment(Counter storage counter) internal {
118         unchecked {
119             counter._value += 1;
120         }
121     }
122 
123     function decrement(Counter storage counter) internal {
124         uint256 value = counter._value;
125         require(value > 0, "Counter: decrement overflow");
126         unchecked {
127             counter._value = value - 1;
128         }
129     }
130 
131     function reset(Counter storage counter) internal {
132         counter._value = 0;
133     }
134 }
135 
136 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
137 
138 
139 
140 pragma solidity ^0.8.0;
141 
142 // CAUTION
143 // This version of SafeMath should only be used with Solidity 0.8 or later,
144 // because it relies on the compiler's built in overflow checks.
145 
146 /**
147  * @dev Wrappers over Solidity's arithmetic operations.
148  *
149  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
150  * now has built in overflow checking.
151  */
152 library SafeMath {
153     /**
154      * @dev Returns the addition of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         unchecked {
160             uint256 c = a + b;
161             if (c < a) return (false, 0);
162             return (true, c);
163         }
164     }
165 
166     /**
167      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
168      *
169      * _Available since v3.4._
170      */
171     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         unchecked {
173             if (b > a) return (false, 0);
174             return (true, a - b);
175         }
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         unchecked {
185             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186             // benefit is lost if 'b' is also tested.
187             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188             if (a == 0) return (true, 0);
189             uint256 c = a * b;
190             if (c / a != b) return (false, 0);
191             return (true, c);
192         }
193     }
194 
195     /**
196      * @dev Returns the division of two unsigned integers, with a division by zero flag.
197      *
198      * _Available since v3.4._
199      */
200     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         unchecked {
202             if (b == 0) return (false, 0);
203             return (true, a / b);
204         }
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
209      *
210      * _Available since v3.4._
211      */
212     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
213         unchecked {
214             if (b == 0) return (false, 0);
215             return (true, a % b);
216         }
217     }
218 
219     /**
220      * @dev Returns the addition of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `+` operator.
224      *
225      * Requirements:
226      *
227      * - Addition cannot overflow.
228      */
229     function add(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a + b;
231     }
232 
233     /**
234      * @dev Returns the subtraction of two unsigned integers, reverting on
235      * overflow (when the result is negative).
236      *
237      * Counterpart to Solidity's `-` operator.
238      *
239      * Requirements:
240      *
241      * - Subtraction cannot overflow.
242      */
243     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a - b;
245     }
246 
247     /**
248      * @dev Returns the multiplication of two unsigned integers, reverting on
249      * overflow.
250      *
251      * Counterpart to Solidity's `*` operator.
252      *
253      * Requirements:
254      *
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         return a * b;
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers, reverting on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator.
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return a / b;
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * reverting when dividing by zero.
278      *
279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
280      * opcode (which leaves remaining gas untouched) while Solidity uses an
281      * invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a % b;
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
293      * overflow (when the result is negative).
294      *
295      * CAUTION: This function is deprecated because it requires allocating memory for the error
296      * message unnecessarily. For custom revert reasons use {trySub}.
297      *
298      * Counterpart to Solidity's `-` operator.
299      *
300      * Requirements:
301      *
302      * - Subtraction cannot overflow.
303      */
304     function sub(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b <= a, errorMessage);
311             return a - b;
312         }
313     }
314 
315     /**
316      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
317      * division by zero. The result is rounded towards zero.
318      *
319      * Counterpart to Solidity's `/` operator. Note: this function uses a
320      * `revert` opcode (which leaves remaining gas untouched) while Solidity
321      * uses an invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function div(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a / b;
335         }
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * reverting with custom message when dividing by zero.
341      *
342      * CAUTION: This function is deprecated because it requires allocating memory for the error
343      * message unnecessarily. For custom revert reasons use {tryMod}.
344      *
345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
346      * opcode (which leaves remaining gas untouched) while Solidity uses an
347      * invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function mod(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         unchecked {
359             require(b > 0, errorMessage);
360             return a % b;
361         }
362     }
363 }
364 
365 // File: @openzeppelin/contracts/access/Ownable.sol
366 
367 
368 
369 pragma solidity ^0.8.0;
370 
371 
372 /**
373  * @dev Contract module which provides a basic access control mechanism, where
374  * there is an account (an owner) that can be granted exclusive access to
375  * specific functions.
376  *
377  * By default, the owner account will be the one that deploys the contract. This
378  * can later be changed with {transferOwnership}.
379  *
380  * This module is used through inheritance. It will make available the modifier
381  * `onlyOwner`, which can be applied to your functions to restrict their use to
382  * the owner.
383  */
384 abstract contract Ownable is Context {
385     address private _owner;
386 
387     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
388 
389     /**
390      * @dev Initializes the contract setting the deployer as the initial owner.
391      */
392     constructor() {
393         _setOwner(_msgSender());
394     }
395 
396     /**
397      * @dev Returns the address of the current owner.
398      */
399     function owner() public view virtual returns (address) {
400         return _owner;
401     }
402 
403     /**
404      * @dev Throws if called by any account other than the owner.
405      */
406     modifier onlyOwner() {
407         require(owner() == _msgSender(), "Ownable: caller is not the owner");
408         _;
409     }
410 
411     /**
412      * @dev Leaves the contract without owner. It will not be possible to call
413      * `onlyOwner` functions anymore. Can only be called by the current owner.
414      *
415      * NOTE: Renouncing ownership will leave the contract without an owner,
416      * thereby removing any functionality that is only available to the owner.
417      */
418     function renounceOwnership() public virtual onlyOwner {
419         _setOwner(address(0));
420     }
421 
422     /**
423      * @dev Transfers ownership of the contract to a new account (`newOwner`).
424      * Can only be called by the current owner.
425      */
426     function transferOwnership(address newOwner) public virtual onlyOwner {
427         require(newOwner != address(0), "Ownable: new owner is the zero address");
428         _setOwner(newOwner);
429     }
430 
431     function _setOwner(address newOwner) private {
432         address oldOwner = _owner;
433         _owner = newOwner;
434         emit OwnershipTransferred(oldOwner, newOwner);
435     }
436 }
437 
438 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
439 
440 
441 
442 pragma solidity ^0.8.0;
443 
444 
445 /**
446  * @dev Implementation of the {IERC165} interface.
447  *
448  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
449  * for the additional interface id that will be supported. For example:
450  *
451  * ```solidity
452  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
453  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
454  * }
455  * ```
456  *
457  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
458  */
459 abstract contract ERC165 is IERC165 {
460     /**
461      * @dev See {IERC165-supportsInterface}.
462      */
463     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
464         return interfaceId == type(IERC165).interfaceId;
465     }
466 }
467 
468 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
469 
470 
471 
472 pragma solidity ^0.8.0;
473 
474 
475 /**
476  * @dev Required interface of an ERC721 compliant contract.
477  */
478 interface IERC721 is IERC165 {
479     /**
480      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
481      */
482     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
483 
484     /**
485      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
486      */
487     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
488 
489     /**
490      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
491      */
492     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
493 
494     /**
495      * @dev Returns the number of tokens in ``owner``'s account.
496      */
497     function balanceOf(address owner) external view returns (uint256 balance);
498 
499     /**
500      * @dev Returns the owner of the `tokenId` token.
501      *
502      * Requirements:
503      *
504      * - `tokenId` must exist.
505      */
506     function ownerOf(uint256 tokenId) external view returns (address owner);
507 
508     /**
509      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
510      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId
526     ) external;
527 
528     /**
529      * @dev Transfers `tokenId` token from `from` to `to`.
530      *
531      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
532      *
533      * Requirements:
534      *
535      * - `from` cannot be the zero address.
536      * - `to` cannot be the zero address.
537      * - `tokenId` token must be owned by `from`.
538      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
539      *
540      * Emits a {Transfer} event.
541      */
542     function transferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) external;
547 
548     /**
549      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
550      * The approval is cleared when the token is transferred.
551      *
552      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
553      *
554      * Requirements:
555      *
556      * - The caller must own the token or be an approved operator.
557      * - `tokenId` must exist.
558      *
559      * Emits an {Approval} event.
560      */
561     function approve(address to, uint256 tokenId) external;
562 
563     /**
564      * @dev Returns the account approved for `tokenId` token.
565      *
566      * Requirements:
567      *
568      * - `tokenId` must exist.
569      */
570     function getApproved(uint256 tokenId) external view returns (address operator);
571 
572     /**
573      * @dev Approve or remove `operator` as an operator for the caller.
574      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
575      *
576      * Requirements:
577      *
578      * - The `operator` cannot be the caller.
579      *
580      * Emits an {ApprovalForAll} event.
581      */
582     function setApprovalForAll(address operator, bool _approved) external;
583 
584     /**
585      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
586      *
587      * See {setApprovalForAll}
588      */
589     function isApprovedForAll(address owner, address operator) external view returns (bool);
590 
591     /**
592      * @dev Safely transfers `tokenId` token from `from` to `to`.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must exist and be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
601      *
602      * Emits a {Transfer} event.
603      */
604     function safeTransferFrom(
605         address from,
606         address to,
607         uint256 tokenId,
608         bytes calldata data
609     ) external;
610 }
611 
612 // File: @openzeppelin/contracts/utils/Strings.sol
613 
614 
615 
616 pragma solidity ^0.8.0;
617 
618 /**
619  * @dev String operations.
620  */
621 library Strings {
622     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
623 
624     /**
625      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
626      */
627     function toString(uint256 value) internal pure returns (string memory) {
628         // Inspired by OraclizeAPI's implementation - MIT licence
629         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
630 
631         if (value == 0) {
632             return "0";
633         }
634         uint256 temp = value;
635         uint256 digits;
636         while (temp != 0) {
637             digits++;
638             temp /= 10;
639         }
640         bytes memory buffer = new bytes(digits);
641         while (value != 0) {
642             digits -= 1;
643             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
644             value /= 10;
645         }
646         return string(buffer);
647     }
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
651      */
652     function toHexString(uint256 value) internal pure returns (string memory) {
653         if (value == 0) {
654             return "0x00";
655         }
656         uint256 temp = value;
657         uint256 length = 0;
658         while (temp != 0) {
659             length++;
660             temp >>= 8;
661         }
662         return toHexString(value, length);
663     }
664 
665     /**
666      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
667      */
668     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
669         bytes memory buffer = new bytes(2 * length + 2);
670         buffer[0] = "0";
671         buffer[1] = "x";
672         for (uint256 i = 2 * length + 1; i > 1; --i) {
673             buffer[i] = _HEX_SYMBOLS[value & 0xf];
674             value >>= 4;
675         }
676         require(value == 0, "Strings: hex length insufficient");
677         return string(buffer);
678     }
679 }
680 
681 
682 
683 // File: @openzeppelin/contracts/utils/Address.sol
684 
685 
686 
687 pragma solidity ^0.8.0;
688 
689 /**
690  * @dev Collection of functions related to the address type
691  */
692 library Address {
693     /**
694      * @dev Returns true if `account` is a contract.
695      *
696      * [IMPORTANT]
697      * ====
698      * It is unsafe to assume that an address for which this function returns
699      * false is an externally-owned account (EOA) and not a contract.
700      *
701      * Among others, `isContract` will return false for the following
702      * types of addresses:
703      *
704      *  - an externally-owned account
705      *  - a contract in construction
706      *  - an address where a contract will be created
707      *  - an address where a contract lived, but was destroyed
708      * ====
709      */
710     function isContract(address account) internal view returns (bool) {
711         // This method relies on extcodesize, which returns 0 for contracts in
712         // construction, since the code is only stored at the end of the
713         // constructor execution.
714 
715         uint256 size;
716         assembly {
717             size := extcodesize(account)
718         }
719         return size > 0;
720     }
721 
722     /**
723      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
724      * `recipient`, forwarding all available gas and reverting on errors.
725      *
726      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
727      * of certain opcodes, possibly making contracts go over the 2300 gas limit
728      * imposed by `transfer`, making them unable to receive funds via
729      * `transfer`. {sendValue} removes this limitation.
730      *
731      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
732      *
733      * IMPORTANT: because control is transferred to `recipient`, care must be
734      * taken to not create reentrancy vulnerabilities. Consider using
735      * {ReentrancyGuard} or the
736      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
737      */
738     function sendValue(address payable recipient, uint256 amount) internal {
739         require(address(this).balance >= amount, "Address: insufficient balance");
740 
741         (bool success, ) = recipient.call{value: amount}("");
742         require(success, "Address: unable to send value, recipient may have reverted");
743     }
744 
745     /**
746      * @dev Performs a Solidity function call using a low level `call`. A
747      * plain `call` is an unsafe replacement for a function call: use this
748      * function instead.
749      *
750      * If `target` reverts with a revert reason, it is bubbled up by this
751      * function (like regular Solidity function calls).
752      *
753      * Returns the raw returned data. To convert to the expected return value,
754      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
755      *
756      * Requirements:
757      *
758      * - `target` must be a contract.
759      * - calling `target` with `data` must not revert.
760      *
761      * _Available since v3.1._
762      */
763     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
764         return functionCall(target, data, "Address: low-level call failed");
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
769      * `errorMessage` as a fallback revert reason when `target` reverts.
770      *
771      * _Available since v3.1._
772      */
773     function functionCall(
774         address target,
775         bytes memory data,
776         string memory errorMessage
777     ) internal returns (bytes memory) {
778         return functionCallWithValue(target, data, 0, errorMessage);
779     }
780 
781     /**
782      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
783      * but also transferring `value` wei to `target`.
784      *
785      * Requirements:
786      *
787      * - the calling contract must have an ETH balance of at least `value`.
788      * - the called Solidity function must be `payable`.
789      *
790      * _Available since v3.1._
791      */
792     function functionCallWithValue(
793         address target,
794         bytes memory data,
795         uint256 value
796     ) internal returns (bytes memory) {
797         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
802      * with `errorMessage` as a fallback revert reason when `target` reverts.
803      *
804      * _Available since v3.1._
805      */
806     function functionCallWithValue(
807         address target,
808         bytes memory data,
809         uint256 value,
810         string memory errorMessage
811     ) internal returns (bytes memory) {
812         require(address(this).balance >= value, "Address: insufficient balance for call");
813         require(isContract(target), "Address: call to non-contract");
814 
815         (bool success, bytes memory returndata) = target.call{value: value}(data);
816         return verifyCallResult(success, returndata, errorMessage);
817     }
818 
819     /**
820      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
821      * but performing a static call.
822      *
823      * _Available since v3.3._
824      */
825     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
826         return functionStaticCall(target, data, "Address: low-level static call failed");
827     }
828 
829     /**
830      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
831      * but performing a static call.
832      *
833      * _Available since v3.3._
834      */
835     function functionStaticCall(
836         address target,
837         bytes memory data,
838         string memory errorMessage
839     ) internal view returns (bytes memory) {
840         require(isContract(target), "Address: static call to non-contract");
841 
842         (bool success, bytes memory returndata) = target.staticcall(data);
843         return verifyCallResult(success, returndata, errorMessage);
844     }
845 
846     /**
847      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
848      * but performing a delegate call.
849      *
850      * _Available since v3.4._
851      */
852     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
853         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
854     }
855 
856     /**
857      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
858      * but performing a delegate call.
859      *
860      * _Available since v3.4._
861      */
862     function functionDelegateCall(
863         address target,
864         bytes memory data,
865         string memory errorMessage
866     ) internal returns (bytes memory) {
867         require(isContract(target), "Address: delegate call to non-contract");
868 
869         (bool success, bytes memory returndata) = target.delegatecall(data);
870         return verifyCallResult(success, returndata, errorMessage);
871     }
872 
873     /**
874      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
875      * revert reason using the provided one.
876      *
877      * _Available since v4.3._
878      */
879     function verifyCallResult(
880         bool success,
881         bytes memory returndata,
882         string memory errorMessage
883     ) internal pure returns (bytes memory) {
884         if (success) {
885             return returndata;
886         } else {
887             // Look for revert reason and bubble it up if present
888             if (returndata.length > 0) {
889                 // The easiest way to bubble the revert reason is using memory via assembly
890 
891                 assembly {
892                     let returndata_size := mload(returndata)
893                     revert(add(32, returndata), returndata_size)
894                 }
895             } else {
896                 revert(errorMessage);
897             }
898         }
899     }
900 }
901 
902 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
903 
904 
905 
906 pragma solidity ^0.8.0;
907 
908 
909 /**
910  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
911  * @dev See https://eips.ethereum.org/EIPS/eip-721
912  */
913 interface IERC721Metadata is IERC721 {
914     /**
915      * @dev Returns the token collection name.
916      */
917     function name() external view returns (string memory);
918 
919     /**
920      * @dev Returns the token collection symbol.
921      */
922     function symbol() external view returns (string memory);
923 
924     /**
925      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
926      */
927     function tokenURI(uint256 tokenId) external view returns (string memory);
928 }
929 
930 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
931 
932 
933 
934 pragma solidity ^0.8.0;
935 
936 /**
937  * @title ERC721 token receiver interface
938  * @dev Interface for any contract that wants to support safeTransfers
939  * from ERC721 asset contracts.
940  */
941 interface IERC721Receiver {
942     /**
943      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
944      * by `operator` from `from`, this function is called.
945      *
946      * It must return its Solidity selector to confirm the token transfer.
947      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
948      *
949      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
950      */
951     function onERC721Received(
952         address operator,
953         address from,
954         uint256 tokenId,
955         bytes calldata data
956     ) external returns (bytes4);
957 }
958 
959 
960 
961 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
962 
963 
964 
965 pragma solidity ^0.8.0;
966 
967 
968 
969 
970 
971 
972 
973 
974 /**
975  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
976  * the Metadata extension, but not including the Enumerable extension, which is available separately as
977  * {ERC721Enumerable}.
978  */
979 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
980     using Address for address;
981     using Strings for uint256;
982 
983     // Token name
984     string private _name;
985 
986     // Token symbol
987     string private _symbol;
988 
989     // Mapping from token ID to owner address
990     mapping(uint256 => address) private _owners;
991 
992     // Mapping owner address to token count
993     mapping(address => uint256) private _balances;
994 
995     // Mapping from token ID to approved address
996     mapping(uint256 => address) private _tokenApprovals;
997 
998     // Mapping from owner to operator approvals
999     mapping(address => mapping(address => bool)) private _operatorApprovals;
1000 
1001     /**
1002      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1003      */
1004     constructor(string memory name_, string memory symbol_) {
1005         _name = name_;
1006         _symbol = symbol_;
1007     }
1008 
1009     /**
1010      * @dev See {IERC165-supportsInterface}.
1011      */
1012     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1013         return
1014             interfaceId == type(IERC721).interfaceId ||
1015             interfaceId == type(IERC721Metadata).interfaceId ||
1016             super.supportsInterface(interfaceId);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-balanceOf}.
1021      */
1022     function balanceOf(address owner) public view virtual override returns (uint256) {
1023         require(owner != address(0), "ERC721: balance query for the zero address");
1024         return _balances[owner];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-ownerOf}.
1029      */
1030     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1031         address owner = _owners[tokenId];
1032         require(owner != address(0), "ERC721: owner query for nonexistent token");
1033         return owner;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Metadata-name}.
1038      */
1039     function name() public view virtual override returns (string memory) {
1040         return _name;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Metadata-symbol}.
1045      */
1046     function symbol() public view virtual override returns (string memory) {
1047         return _symbol;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Metadata-tokenURI}.
1052      */
1053     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1054         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1055 
1056         string memory baseURI = _baseURI();
1057         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1058     }
1059 
1060     /**
1061      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1062      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1063      * by default, can be overriden in child contracts.
1064      */
1065     function _baseURI() internal view virtual returns (string memory) {
1066         return "";
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-approve}.
1071      */
1072     function approve(address to, uint256 tokenId) public virtual override {
1073         address owner = ERC721.ownerOf(tokenId);
1074         require(to != owner, "ERC721: approval to current owner");
1075 
1076         require(
1077             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1078             "ERC721: approve caller is not owner nor approved for all"
1079         );
1080 
1081         _approve(to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-getApproved}.
1086      */
1087     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1088         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1089 
1090         return _tokenApprovals[tokenId];
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-setApprovalForAll}.
1095      */
1096     function setApprovalForAll(address operator, bool approved) public virtual override {
1097         require(operator != _msgSender(), "ERC721: approve to caller");
1098 
1099         _operatorApprovals[_msgSender()][operator] = approved;
1100         emit ApprovalForAll(_msgSender(), operator, approved);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-isApprovedForAll}.
1105      */
1106     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1107         return _operatorApprovals[owner][operator];
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-transferFrom}.
1112      */
1113     function transferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) public virtual override {
1118         //solhint-disable-next-line max-line-length
1119         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1120 
1121         _transfer(from, to, tokenId);
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-safeTransferFrom}.
1126      */
1127     function safeTransferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) public virtual override {
1132         safeTransferFrom(from, to, tokenId, "");
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-safeTransferFrom}.
1137      */
1138     function safeTransferFrom(
1139         address from,
1140         address to,
1141         uint256 tokenId,
1142         bytes memory _data
1143     ) public virtual override {
1144         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1145         _safeTransfer(from, to, tokenId, _data);
1146     }
1147 
1148     /**
1149      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1150      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1151      *
1152      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1153      *
1154      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1155      * implement alternative mechanisms to perform token transfer, such as signature-based.
1156      *
1157      * Requirements:
1158      *
1159      * - `from` cannot be the zero address.
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must exist and be owned by `from`.
1162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function _safeTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes memory _data
1171     ) internal virtual {
1172         _transfer(from, to, tokenId);
1173         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1174     }
1175 
1176     /**
1177      * @dev Returns whether `tokenId` exists.
1178      *
1179      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1180      *
1181      * Tokens start existing when they are minted (`_mint`),
1182      * and stop existing when they are burned (`_burn`).
1183      */
1184     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1185         return _owners[tokenId] != address(0);
1186     }
1187 
1188     /**
1189      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must exist.
1194      */
1195     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1196         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1197         address owner = ERC721.ownerOf(tokenId);
1198         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1199     }
1200 
1201     /**
1202      * @dev Safely mints `tokenId` and transfers it to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must not exist.
1207      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _safeMint(address to, uint256 tokenId) internal virtual {
1212         _safeMint(to, tokenId, "");
1213     }
1214 
1215     /**
1216      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1217      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1218      */
1219     function _safeMint(
1220         address to,
1221         uint256 tokenId,
1222         bytes memory _data
1223     ) internal virtual {
1224         _mint(to, tokenId);
1225         require(
1226             _checkOnERC721Received(address(0), to, tokenId, _data),
1227             "ERC721: transfer to non ERC721Receiver implementer"
1228         );
1229     }
1230 
1231     /**
1232      * @dev Mints `tokenId` and transfers it to `to`.
1233      *
1234      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1235      *
1236      * Requirements:
1237      *
1238      * - `tokenId` must not exist.
1239      * - `to` cannot be the zero address.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _mint(address to, uint256 tokenId) internal virtual {
1244         require(to != address(0), "ERC721: mint to the zero address");
1245         require(!_exists(tokenId), "ERC721: token already minted");
1246 
1247         _beforeTokenTransfer(address(0), to, tokenId);
1248 
1249         _balances[to] += 1;
1250         _owners[tokenId] = to;
1251 
1252         emit Transfer(address(0), to, tokenId);
1253     }
1254 
1255     /**
1256      * @dev Destroys `tokenId`.
1257      * The approval is cleared when the token is burned.
1258      *
1259      * Requirements:
1260      *
1261      * - `tokenId` must exist.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _burn(uint256 tokenId) internal virtual {
1266         address owner = ERC721.ownerOf(tokenId);
1267 
1268         _beforeTokenTransfer(owner, address(0), tokenId);
1269 
1270         // Clear approvals
1271         _approve(address(0), tokenId);
1272 
1273         _balances[owner] -= 1;
1274         delete _owners[tokenId];
1275 
1276         emit Transfer(owner, address(0), tokenId);
1277     }
1278 
1279     /**
1280      * @dev Transfers `tokenId` from `from` to `to`.
1281      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1282      *
1283      * Requirements:
1284      *
1285      * - `to` cannot be the zero address.
1286      * - `tokenId` token must be owned by `from`.
1287      *
1288      * Emits a {Transfer} event.
1289      */
1290     function _transfer(
1291         address from,
1292         address to,
1293         uint256 tokenId
1294     ) internal virtual {
1295         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1296         require(to != address(0), "ERC721: transfer to the zero address");
1297 
1298         _beforeTokenTransfer(from, to, tokenId);
1299 
1300         // Clear approvals from the previous owner
1301         _approve(address(0), tokenId);
1302 
1303         _balances[from] -= 1;
1304         _balances[to] += 1;
1305         _owners[tokenId] = to;
1306 
1307         emit Transfer(from, to, tokenId);
1308     }
1309 
1310     /**
1311      * @dev Approve `to` to operate on `tokenId`
1312      *
1313      * Emits a {Approval} event.
1314      */
1315     function _approve(address to, uint256 tokenId) internal virtual {
1316         _tokenApprovals[tokenId] = to;
1317         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1318     }
1319 
1320     /**
1321      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1322      * The call is not executed if the target address is not a contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         if (to.isContract()) {
1337             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1338                 return retval == IERC721Receiver.onERC721Received.selector;
1339             } catch (bytes memory reason) {
1340                 if (reason.length == 0) {
1341                     revert("ERC721: transfer to non ERC721Receiver implementer");
1342                 } else {
1343                     assembly {
1344                         revert(add(32, reason), mload(reason))
1345                     }
1346                 }
1347             }
1348         } else {
1349             return true;
1350         }
1351     }
1352 
1353     /**
1354      * @dev Hook that is called before any token transfer. This includes minting
1355      * and burning.
1356      *
1357      * Calling conditions:
1358      *
1359      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1360      * transferred to `to`.
1361      * - When `from` is zero, `tokenId` will be minted for `to`.
1362      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1363      * - `from` and `to` are never both zero.
1364      *
1365      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1366      */
1367     function _beforeTokenTransfer(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) internal virtual {}
1372 }
1373 
1374 // File: contracts/FomoBotz.sol
1375 
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 /////////////////////////////////////////////////////////////////////////////
1380 /////////////////////////////////////////////////////////////////////////////
1381 ////                                                                     ////
1382 ////                                                                     ////
1383 ////                                                                     ////
1384 ////                                                                     ////
1385 ////                                                                     ////
1386 ////                                                                     ////
1387 ////                //////////                //////////                 ////
1388 ////                //////////                //////////                 ////
1389 ////                ////  ////                ////  ////                 ////
1390 ////                //////////                //////////                 ////
1391 ////                //////////                //////////                 ////
1392 ////                                                                     ////
1393 ////                                                                     ////
1394 ////                                                                     ////
1395 ////                                                                     ////
1396 ////                                                                     ////
1397 ////                                                                     ////
1398 ////                                                                     ////
1399 ////                                                                     ////
1400 ////                //////                          ////                 ////
1401 ////                //////                          ////                 //// 
1402 ////                ////////////////////////////////////                 ////
1403 ////                ////////////////////////////////////                 ////
1404 ////                                                                     ////
1405 ////                                                                     ////
1406 ////                                                                     ////
1407 ////                                                                     ////
1408 ////                                                                     ////
1409 /////////////////////////////////////////////////////////////////////////////
1410 /////////////////////////////////////////////////////////////////////////////
1411 
1412 // EtherBotz is 10101 unique botz algorithmically created and now zipping around the metaverse.
1413 
1414 
1415 
1416 
1417 
1418 
1419 contract FomoBotz is ERC721, Ownable {
1420     using Strings for uint256;
1421     using SafeMath for uint256;
1422     using Counters for Counters.Counter;
1423 
1424     Counters.Counter private _tokenIdTracker;
1425 
1426     uint256 public constant MAX_FREE = 2222;
1427     uint256 public constant MAX_FREE_MINT = 20;
1428     
1429     uint256 public constant MAX_LEVEL_ONE = 4444;
1430     uint256 public constant LEVEL_ONE_PRICE = 1 * 10**16;
1431     
1432     uint256 public constant MAX_LEVEL_TWO = 6666;
1433     uint256 public constant LEVEL_TWO_PRICE = 2 * 10**16;
1434     
1435     uint256 public constant MAX_LEVEL_THREE = 8888;
1436     uint256 public constant LEVEL_THREE_PRICE = 4 * 10**16;
1437     
1438     uint256 public constant MAX_ELEMENTS = 10101;    
1439     uint256 public constant LEVEL_FOUR_PRICE = 8 * 10**16;
1440     
1441     address
1442         public constant creatorAddress = 0x8da85fD2DB9B6fA63B9d7dDbf8267d8293bfa7aE;
1443 
1444     event CreateBot(uint256 indexed id);
1445 
1446     constructor() public ERC721("FomoBotz", "BOTZ") {}
1447 
1448     modifier saleIsOpen {
1449         require(_totalSupply() <= MAX_ELEMENTS, "Sale end");
1450         _;
1451     }
1452 
1453     function totalSupply() public view returns (uint256) {
1454         return _tokenIdTracker.current();
1455     }
1456 
1457     function _totalSupply() internal view returns (uint256) {
1458         return _tokenIdTracker.current();
1459     }
1460 
1461     function totalMint() public view returns (uint256) {
1462         return _totalSupply();
1463     }
1464 
1465     function mintFree(address _to, uint256 _count) public payable saleIsOpen {
1466         uint256 total = _totalSupply();
1467         require(total + _count <= MAX_FREE, "Max limit");
1468         require(total <= MAX_FREE, "Sale end");
1469         require(_count <= MAX_FREE_MINT, "Exceeds number");
1470         require(
1471             balanceOf(msg.sender) < 20,
1472             "only 20 free token per address allowed"
1473         );
1474 
1475         for (uint256 i = 0; i < _count; i++) {
1476             _mintAnElement(_to);
1477         }
1478     }
1479     
1480     function mintLevelOne(address _to, uint256 _count) public payable saleIsOpen {
1481         uint256 total = _totalSupply();
1482         require(total + _count <= MAX_LEVEL_ONE, "Max limit");
1483         require(total <= MAX_LEVEL_ONE, "Sale end");
1484         require(msg.value >= priceLevelOne(_count), "Value below price");
1485 
1486         for (uint256 i = 0; i < _count; i++) {
1487             _mintAnElement(_to);
1488         }
1489     }
1490     
1491     function mintLevelTwo(address _to, uint256 _count) public payable saleIsOpen {
1492         uint256 total = _totalSupply();
1493         require(total + _count <= MAX_LEVEL_TWO, "Max limit");
1494         require(total <= MAX_LEVEL_TWO, "Sale end");
1495         require(msg.value >= priceLevelTwo(_count), "Value below price");
1496 
1497         for (uint256 i = 0; i < _count; i++) {
1498             _mintAnElement(_to);
1499         }
1500     }
1501     
1502     function mintLevelThree(address _to, uint256 _count) public payable saleIsOpen {
1503         uint256 total = _totalSupply();
1504         require(total + _count <= MAX_LEVEL_THREE, "Max limit");
1505         require(total <= MAX_LEVEL_THREE, "Sale end");
1506         require(msg.value >= priceLevelThree(_count), "Value below price");
1507 
1508         for (uint256 i = 0; i < _count; i++) {
1509             _mintAnElement(_to);
1510         }
1511     }
1512     
1513     function mintLevelFour(address _to, uint256 _count) public payable saleIsOpen {
1514         uint256 total = _totalSupply();
1515         require(total + _count <= MAX_ELEMENTS, "Max limit");
1516         require(total <= MAX_ELEMENTS, "Sale end");
1517         require(msg.value >= priceLevelFour(_count), "Value below price");
1518 
1519         for (uint256 i = 0; i < _count; i++) {
1520             _mintAnElement(_to);
1521         }
1522     }
1523 
1524     function _mintAnElement(address _to) private {
1525         uint256 id = _totalSupply();
1526         _tokenIdTracker.increment();
1527         _safeMint(_to, id);
1528         emit CreateBot(id);
1529     }
1530 
1531     function priceLevelOne(uint256 _count) public pure returns (uint256) {
1532         return LEVEL_ONE_PRICE.mul(_count);
1533     }
1534     
1535     function priceLevelTwo(uint256 _count) public pure returns (uint256) {
1536         return LEVEL_TWO_PRICE.mul(_count);
1537     }
1538     
1539     function priceLevelThree(uint256 _count) public pure returns (uint256) {
1540         return LEVEL_THREE_PRICE.mul(_count);
1541     }
1542     
1543    function priceLevelFour(uint256 _count) public pure returns (uint256) {
1544         return LEVEL_FOUR_PRICE.mul(_count);
1545     }
1546 
1547     /**
1548      * @dev Returns an URI for a given token ID
1549      */
1550     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1551         string memory botzUri = "https://gateway.pinata.cloud/ipfs/QmPgjT8UsAy11sCcjpYBFs1hRWRctBgQ3Z5Hq7MeNkcSrU/";
1552         return string(abi.encodePacked(botzUri, _tokenId.toString()));
1553     }
1554 
1555     function withdrawAll() public payable onlyOwner {
1556         uint256 balance = address(this).balance;
1557         require(balance > 0);
1558         _widthdraw(creatorAddress, address(this).balance);
1559     }
1560 
1561     function _widthdraw(address _address, uint256 _amount) private {
1562         (bool success, ) = _address.call{value: _amount}("");
1563         require(success, "Transfer failed.");
1564     }
1565 }