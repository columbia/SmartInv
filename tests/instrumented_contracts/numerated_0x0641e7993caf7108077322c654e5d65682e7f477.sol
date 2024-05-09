1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
173 
174 
175 
176 pragma solidity ^0.8.0;
177 
178 
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
181  * @dev See https://eips.ethereum.org/EIPS/eip-721
182  */
183 interface IERC721Enumerable is IERC721 {
184     /**
185      * @dev Returns the total amount of tokens stored by the contract.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
191      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
192      */
193     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
194 
195     /**
196      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
197      * Use along with {totalSupply} to enumerate all tokens.
198      */
199     function tokenByIndex(uint256 index) external view returns (uint256);
200 }
201 
202 // File: @openzeppelin/contracts/utils/Context.sol
203 
204 
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Provides information about the current execution context, including the
210  * sender of the transaction and its data. While these are generally available
211  * via msg.sender and msg.data, they should not be accessed in such a direct
212  * manner, since when dealing with meta-transactions the account sending and
213  * paying for execution may not be the actual sender (as far as an application
214  * is concerned).
215  *
216  * This contract is only required for intermediate, library-like contracts.
217  */
218 abstract contract Context {
219     function _msgSender() internal view virtual returns (address) {
220         return msg.sender;
221     }
222 
223     function _msgData() internal view virtual returns (bytes calldata) {
224         return msg.data;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/security/Pausable.sol
229 
230 
231 
232 pragma solidity ^0.8.0;
233 
234 
235 /**
236  * @dev Contract module which allows children to implement an emergency stop
237  * mechanism that can be triggered by an authorized account.
238  *
239  * This module is used through inheritance. It will make available the
240  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
241  * the functions of your contract. Note that they will not be pausable by
242  * simply including this module, only once the modifiers are put in place.
243  */
244 abstract contract Pausable is Context {
245     /**
246      * @dev Emitted when the pause is triggered by `account`.
247      */
248     event Paused(address account);
249 
250     /**
251      * @dev Emitted when the pause is lifted by `account`.
252      */
253     event Unpaused(address account);
254 
255     bool private _paused;
256 
257     /**
258      * @dev Initializes the contract in unpaused state.
259      */
260     constructor() {
261         _paused = false;
262     }
263 
264     /**
265      * @dev Returns true if the contract is paused, and false otherwise.
266      */
267     function paused() public view virtual returns (bool) {
268         return _paused;
269     }
270 
271     /**
272      * @dev Modifier to make a function callable only when the contract is not paused.
273      *
274      * Requirements:
275      *
276      * - The contract must not be paused.
277      */
278     modifier whenNotPaused() {
279         require(!paused(), "Pausable: paused");
280         _;
281     }
282 
283     /**
284      * @dev Modifier to make a function callable only when the contract is paused.
285      *
286      * Requirements:
287      *
288      * - The contract must be paused.
289      */
290     modifier whenPaused() {
291         require(paused(), "Pausable: not paused");
292         _;
293     }
294 
295     /**
296      * @dev Triggers stopped state.
297      *
298      * Requirements:
299      *
300      * - The contract must not be paused.
301      */
302     function _pause() internal virtual whenNotPaused {
303         _paused = true;
304         emit Paused(_msgSender());
305     }
306 
307     /**
308      * @dev Returns to normal state.
309      *
310      * Requirements:
311      *
312      * - The contract must be paused.
313      */
314     function _unpause() internal virtual whenPaused {
315         _paused = false;
316         emit Unpaused(_msgSender());
317     }
318 }
319 
320 // File: @openzeppelin/contracts/utils/Counters.sol
321 
322 
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @title Counters
328  * @author Matt Condon (@shrugs)
329  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
330  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
331  *
332  * Include with `using Counters for Counters.Counter;`
333  */
334 library Counters {
335     struct Counter {
336         // This variable should never be directly accessed by users of the library: interactions must be restricted to
337         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
338         // this feature: see https://github.com/ethereum/solidity/issues/4637
339         uint256 _value; // default: 0
340     }
341 
342     function current(Counter storage counter) internal view returns (uint256) {
343         return counter._value;
344     }
345 
346     function increment(Counter storage counter) internal {
347         unchecked {
348             counter._value += 1;
349         }
350     }
351 
352     function decrement(Counter storage counter) internal {
353         uint256 value = counter._value;
354         require(value > 0, "Counter: decrement overflow");
355         unchecked {
356             counter._value = value - 1;
357         }
358     }
359 
360     function reset(Counter storage counter) internal {
361         counter._value = 0;
362     }
363 }
364 
365 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
366 
367 
368 
369 pragma solidity ^0.8.0;
370 
371 // CAUTION
372 // This version of SafeMath should only be used with Solidity 0.8 or later,
373 // because it relies on the compiler's built in overflow checks.
374 
375 /**
376  * @dev Wrappers over Solidity's arithmetic operations.
377  *
378  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
379  * now has built in overflow checking.
380  */
381 library SafeMath {
382     /**
383      * @dev Returns the addition of two unsigned integers, with an overflow flag.
384      *
385      * _Available since v3.4._
386      */
387     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         unchecked {
389             uint256 c = a + b;
390             if (c < a) return (false, 0);
391             return (true, c);
392         }
393     }
394 
395     /**
396      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
397      *
398      * _Available since v3.4._
399      */
400     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
401         unchecked {
402             if (b > a) return (false, 0);
403             return (true, a - b);
404         }
405     }
406 
407     /**
408      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
409      *
410      * _Available since v3.4._
411      */
412     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
413         unchecked {
414             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
415             // benefit is lost if 'b' is also tested.
416             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
417             if (a == 0) return (true, 0);
418             uint256 c = a * b;
419             if (c / a != b) return (false, 0);
420             return (true, c);
421         }
422     }
423 
424     /**
425      * @dev Returns the division of two unsigned integers, with a division by zero flag.
426      *
427      * _Available since v3.4._
428      */
429     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
430         unchecked {
431             if (b == 0) return (false, 0);
432             return (true, a / b);
433         }
434     }
435 
436     /**
437      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
438      *
439      * _Available since v3.4._
440      */
441     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
442         unchecked {
443             if (b == 0) return (false, 0);
444             return (true, a % b);
445         }
446     }
447 
448     /**
449      * @dev Returns the addition of two unsigned integers, reverting on
450      * overflow.
451      *
452      * Counterpart to Solidity's `+` operator.
453      *
454      * Requirements:
455      *
456      * - Addition cannot overflow.
457      */
458     function add(uint256 a, uint256 b) internal pure returns (uint256) {
459         return a + b;
460     }
461 
462     /**
463      * @dev Returns the subtraction of two unsigned integers, reverting on
464      * overflow (when the result is negative).
465      *
466      * Counterpart to Solidity's `-` operator.
467      *
468      * Requirements:
469      *
470      * - Subtraction cannot overflow.
471      */
472     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
473         return a - b;
474     }
475 
476     /**
477      * @dev Returns the multiplication of two unsigned integers, reverting on
478      * overflow.
479      *
480      * Counterpart to Solidity's `*` operator.
481      *
482      * Requirements:
483      *
484      * - Multiplication cannot overflow.
485      */
486     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
487         return a * b;
488     }
489 
490     /**
491      * @dev Returns the integer division of two unsigned integers, reverting on
492      * division by zero. The result is rounded towards zero.
493      *
494      * Counterpart to Solidity's `/` operator.
495      *
496      * Requirements:
497      *
498      * - The divisor cannot be zero.
499      */
500     function div(uint256 a, uint256 b) internal pure returns (uint256) {
501         return a / b;
502     }
503 
504     /**
505      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
506      * reverting when dividing by zero.
507      *
508      * Counterpart to Solidity's `%` operator. This function uses a `revert`
509      * opcode (which leaves remaining gas untouched) while Solidity uses an
510      * invalid opcode to revert (consuming all remaining gas).
511      *
512      * Requirements:
513      *
514      * - The divisor cannot be zero.
515      */
516     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
517         return a % b;
518     }
519 
520     /**
521      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
522      * overflow (when the result is negative).
523      *
524      * CAUTION: This function is deprecated because it requires allocating memory for the error
525      * message unnecessarily. For custom revert reasons use {trySub}.
526      *
527      * Counterpart to Solidity's `-` operator.
528      *
529      * Requirements:
530      *
531      * - Subtraction cannot overflow.
532      */
533     function sub(
534         uint256 a,
535         uint256 b,
536         string memory errorMessage
537     ) internal pure returns (uint256) {
538         unchecked {
539             require(b <= a, errorMessage);
540             return a - b;
541         }
542     }
543 
544     /**
545      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
546      * division by zero. The result is rounded towards zero.
547      *
548      * Counterpart to Solidity's `/` operator. Note: this function uses a
549      * `revert` opcode (which leaves remaining gas untouched) while Solidity
550      * uses an invalid opcode to revert (consuming all remaining gas).
551      *
552      * Requirements:
553      *
554      * - The divisor cannot be zero.
555      */
556     function div(
557         uint256 a,
558         uint256 b,
559         string memory errorMessage
560     ) internal pure returns (uint256) {
561         unchecked {
562             require(b > 0, errorMessage);
563             return a / b;
564         }
565     }
566 
567     /**
568      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
569      * reverting with custom message when dividing by zero.
570      *
571      * CAUTION: This function is deprecated because it requires allocating memory for the error
572      * message unnecessarily. For custom revert reasons use {tryMod}.
573      *
574      * Counterpart to Solidity's `%` operator. This function uses a `revert`
575      * opcode (which leaves remaining gas untouched) while Solidity uses an
576      * invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function mod(
583         uint256 a,
584         uint256 b,
585         string memory errorMessage
586     ) internal pure returns (uint256) {
587         unchecked {
588             require(b > 0, errorMessage);
589             return a % b;
590         }
591     }
592 }
593 
594 // File: @openzeppelin/contracts/access/Ownable.sol
595 
596 
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @dev Contract module which provides a basic access control mechanism, where
603  * there is an account (an owner) that can be granted exclusive access to
604  * specific functions.
605  *
606  * By default, the owner account will be the one that deploys the contract. This
607  * can later be changed with {transferOwnership}.
608  *
609  * This module is used through inheritance. It will make available the modifier
610  * `onlyOwner`, which can be applied to your functions to restrict their use to
611  * the owner.
612  */
613 abstract contract Ownable is Context {
614     address private _owner;
615 
616     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
617 
618     /**
619      * @dev Initializes the contract setting the deployer as the initial owner.
620      */
621     constructor() {
622         _setOwner(_msgSender());
623     }
624 
625     /**
626      * @dev Returns the address of the current owner.
627      */
628     function owner() public view virtual returns (address) {
629         return _owner;
630     }
631 
632     /**
633      * @dev Throws if called by any account other than the owner.
634      */
635     modifier onlyOwner() {
636         require(owner() == _msgSender(), "Ownable: caller is not the owner");
637         _;
638     }
639 
640     /**
641      * @dev Leaves the contract without owner. It will not be possible to call
642      * `onlyOwner` functions anymore. Can only be called by the current owner.
643      *
644      * NOTE: Renouncing ownership will leave the contract without an owner,
645      * thereby removing any functionality that is only available to the owner.
646      */
647     function renounceOwnership() public virtual onlyOwner {
648         _setOwner(address(0));
649     }
650 
651     /**
652      * @dev Transfers ownership of the contract to a new account (`newOwner`).
653      * Can only be called by the current owner.
654      */
655     function transferOwnership(address newOwner) public virtual onlyOwner {
656         require(newOwner != address(0), "Ownable: new owner is the zero address");
657         _setOwner(newOwner);
658     }
659 
660     function _setOwner(address newOwner) private {
661         address oldOwner = _owner;
662         _owner = newOwner;
663         emit OwnershipTransferred(oldOwner, newOwner);
664     }
665 }
666 
667 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
668 
669 
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @dev Implementation of the {IERC165} interface.
676  *
677  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
678  * for the additional interface id that will be supported. For example:
679  *
680  * ```solidity
681  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
683  * }
684  * ```
685  *
686  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
687  */
688 abstract contract ERC165 is IERC165 {
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         return interfaceId == type(IERC165).interfaceId;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/utils/Strings.sol
698 
699 
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @dev String operations.
705  */
706 library Strings {
707     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
708 
709     /**
710      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
711      */
712     function toString(uint256 value) internal pure returns (string memory) {
713         // Inspired by OraclizeAPI's implementation - MIT licence
714         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
715 
716         if (value == 0) {
717             return "0";
718         }
719         uint256 temp = value;
720         uint256 digits;
721         while (temp != 0) {
722             digits++;
723             temp /= 10;
724         }
725         bytes memory buffer = new bytes(digits);
726         while (value != 0) {
727             digits -= 1;
728             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
729             value /= 10;
730         }
731         return string(buffer);
732     }
733 
734     /**
735      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
736      */
737     function toHexString(uint256 value) internal pure returns (string memory) {
738         if (value == 0) {
739             return "0x00";
740         }
741         uint256 temp = value;
742         uint256 length = 0;
743         while (temp != 0) {
744             length++;
745             temp >>= 8;
746         }
747         return toHexString(value, length);
748     }
749 
750     /**
751      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
752      */
753     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
754         bytes memory buffer = new bytes(2 * length + 2);
755         buffer[0] = "0";
756         buffer[1] = "x";
757         for (uint256 i = 2 * length + 1; i > 1; --i) {
758             buffer[i] = _HEX_SYMBOLS[value & 0xf];
759             value >>= 4;
760         }
761         require(value == 0, "Strings: hex length insufficient");
762         return string(buffer);
763     }
764 }
765 
766 // File: @openzeppelin/contracts/utils/Address.sol
767 
768 
769 
770 pragma solidity ^0.8.0;
771 
772 /**
773  * @dev Collection of functions related to the address type
774  */
775 library Address {
776     /**
777      * @dev Returns true if `account` is a contract.
778      *
779      * [IMPORTANT]
780      * ====
781      * It is unsafe to assume that an address for which this function returns
782      * false is an externally-owned account (EOA) and not a contract.
783      *
784      * Among others, `isContract` will return false for the following
785      * types of addresses:
786      *
787      *  - an externally-owned account
788      *  - a contract in construction
789      *  - an address where a contract will be created
790      *  - an address where a contract lived, but was destroyed
791      * ====
792      */
793     function isContract(address account) internal view returns (bool) {
794         // This method relies on extcodesize, which returns 0 for contracts in
795         // construction, since the code is only stored at the end of the
796         // constructor execution.
797 
798         uint256 size;
799         assembly {
800             size := extcodesize(account)
801         }
802         return size > 0;
803     }
804 
805     /**
806      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
807      * `recipient`, forwarding all available gas and reverting on errors.
808      *
809      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
810      * of certain opcodes, possibly making contracts go over the 2300 gas limit
811      * imposed by `transfer`, making them unable to receive funds via
812      * `transfer`. {sendValue} removes this limitation.
813      *
814      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
815      *
816      * IMPORTANT: because control is transferred to `recipient`, care must be
817      * taken to not create reentrancy vulnerabilities. Consider using
818      * {ReentrancyGuard} or the
819      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
820      */
821     function sendValue(address payable recipient, uint256 amount) internal {
822         require(address(this).balance >= amount, "Address: insufficient balance");
823 
824         (bool success, ) = recipient.call{value: amount}("");
825         require(success, "Address: unable to send value, recipient may have reverted");
826     }
827 
828     /**
829      * @dev Performs a Solidity function call using a low level `call`. A
830      * plain `call` is an unsafe replacement for a function call: use this
831      * function instead.
832      *
833      * If `target` reverts with a revert reason, it is bubbled up by this
834      * function (like regular Solidity function calls).
835      *
836      * Returns the raw returned data. To convert to the expected return value,
837      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
838      *
839      * Requirements:
840      *
841      * - `target` must be a contract.
842      * - calling `target` with `data` must not revert.
843      *
844      * _Available since v3.1._
845      */
846     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
847         return functionCall(target, data, "Address: low-level call failed");
848     }
849 
850     /**
851      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
852      * `errorMessage` as a fallback revert reason when `target` reverts.
853      *
854      * _Available since v3.1._
855      */
856     function functionCall(
857         address target,
858         bytes memory data,
859         string memory errorMessage
860     ) internal returns (bytes memory) {
861         return functionCallWithValue(target, data, 0, errorMessage);
862     }
863 
864     /**
865      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
866      * but also transferring `value` wei to `target`.
867      *
868      * Requirements:
869      *
870      * - the calling contract must have an ETH balance of at least `value`.
871      * - the called Solidity function must be `payable`.
872      *
873      * _Available since v3.1._
874      */
875     function functionCallWithValue(
876         address target,
877         bytes memory data,
878         uint256 value
879     ) internal returns (bytes memory) {
880         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
881     }
882 
883     /**
884      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
885      * with `errorMessage` as a fallback revert reason when `target` reverts.
886      *
887      * _Available since v3.1._
888      */
889     function functionCallWithValue(
890         address target,
891         bytes memory data,
892         uint256 value,
893         string memory errorMessage
894     ) internal returns (bytes memory) {
895         require(address(this).balance >= value, "Address: insufficient balance for call");
896         require(isContract(target), "Address: call to non-contract");
897 
898         (bool success, bytes memory returndata) = target.call{value: value}(data);
899         return verifyCallResult(success, returndata, errorMessage);
900     }
901 
902     /**
903      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
904      * but performing a static call.
905      *
906      * _Available since v3.3._
907      */
908     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
909         return functionStaticCall(target, data, "Address: low-level static call failed");
910     }
911 
912     /**
913      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
914      * but performing a static call.
915      *
916      * _Available since v3.3._
917      */
918     function functionStaticCall(
919         address target,
920         bytes memory data,
921         string memory errorMessage
922     ) internal view returns (bytes memory) {
923         require(isContract(target), "Address: static call to non-contract");
924 
925         (bool success, bytes memory returndata) = target.staticcall(data);
926         return verifyCallResult(success, returndata, errorMessage);
927     }
928 
929     /**
930      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
931      * but performing a delegate call.
932      *
933      * _Available since v3.4._
934      */
935     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
936         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
937     }
938 
939     /**
940      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
941      * but performing a delegate call.
942      *
943      * _Available since v3.4._
944      */
945     function functionDelegateCall(
946         address target,
947         bytes memory data,
948         string memory errorMessage
949     ) internal returns (bytes memory) {
950         require(isContract(target), "Address: delegate call to non-contract");
951 
952         (bool success, bytes memory returndata) = target.delegatecall(data);
953         return verifyCallResult(success, returndata, errorMessage);
954     }
955 
956     /**
957      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
958      * revert reason using the provided one.
959      *
960      * _Available since v4.3._
961      */
962     function verifyCallResult(
963         bool success,
964         bytes memory returndata,
965         string memory errorMessage
966     ) internal pure returns (bytes memory) {
967         if (success) {
968             return returndata;
969         } else {
970             // Look for revert reason and bubble it up if present
971             if (returndata.length > 0) {
972                 // The easiest way to bubble the revert reason is using memory via assembly
973 
974                 assembly {
975                     let returndata_size := mload(returndata)
976                     revert(add(32, returndata), returndata_size)
977                 }
978             } else {
979                 revert(errorMessage);
980             }
981         }
982     }
983 }
984 
985 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
986 
987 
988 
989 pragma solidity ^0.8.0;
990 
991 
992 /**
993  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
994  * @dev See https://eips.ethereum.org/EIPS/eip-721
995  */
996 interface IERC721Metadata is IERC721 {
997     /**
998      * @dev Returns the token collection name.
999      */
1000     function name() external view returns (string memory);
1001 
1002     /**
1003      * @dev Returns the token collection symbol.
1004      */
1005     function symbol() external view returns (string memory);
1006 
1007     /**
1008      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1009      */
1010     function tokenURI(uint256 tokenId) external view returns (string memory);
1011 }
1012 
1013 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1014 
1015 
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 /**
1020  * @title ERC721 token receiver interface
1021  * @dev Interface for any contract that wants to support safeTransfers
1022  * from ERC721 asset contracts.
1023  */
1024 interface IERC721Receiver {
1025     /**
1026      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1027      * by `operator` from `from`, this function is called.
1028      *
1029      * It must return its Solidity selector to confirm the token transfer.
1030      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1031      *
1032      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1033      */
1034     function onERC721Received(
1035         address operator,
1036         address from,
1037         uint256 tokenId,
1038         bytes calldata data
1039     ) external returns (bytes4);
1040 }
1041 
1042 
1043 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1044 
1045 
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 
1056 /**
1057  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1058  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1059  * {ERC721Enumerable}.
1060  */
1061 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1062     using Address for address;
1063     using Strings for uint256;
1064 
1065     // Token name
1066     string private _name;
1067 
1068     // Token symbol
1069     string private _symbol;
1070 
1071     // Mapping from token ID to owner address
1072     mapping(uint256 => address) private _owners;
1073 
1074     // Mapping owner address to token count
1075     mapping(address => uint256) private _balances;
1076 
1077     // Mapping from token ID to approved address
1078     mapping(uint256 => address) private _tokenApprovals;
1079 
1080     // Mapping from owner to operator approvals
1081     mapping(address => mapping(address => bool)) private _operatorApprovals;
1082 
1083     /**
1084      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1085      */
1086     constructor(string memory name_, string memory symbol_) {
1087         _name = name_;
1088         _symbol = symbol_;
1089     }
1090 
1091     /**
1092      * @dev See {IERC165-supportsInterface}.
1093      */
1094     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1095         return
1096             interfaceId == type(IERC721).interfaceId ||
1097             interfaceId == type(IERC721Metadata).interfaceId ||
1098             super.supportsInterface(interfaceId);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-balanceOf}.
1103      */
1104     function balanceOf(address owner) public view virtual override returns (uint256) {
1105         require(owner != address(0), "ERC721: balance query for the zero address");
1106         return _balances[owner];
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-ownerOf}.
1111      */
1112     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1113         address owner = _owners[tokenId];
1114         require(owner != address(0), "ERC721: owner query for nonexistent token");
1115         return owner;
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Metadata-name}.
1120      */
1121     function name() public view virtual override returns (string memory) {
1122         return _name;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Metadata-symbol}.
1127      */
1128     function symbol() public view virtual override returns (string memory) {
1129         return _symbol;
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Metadata-tokenURI}.
1134      */
1135     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1136         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1137 
1138         string memory baseURI = _baseURI();
1139         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1140     }
1141 
1142     /**
1143      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1144      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1145      * by default, can be overriden in child contracts.
1146      */
1147     function _baseURI() internal view virtual returns (string memory) {
1148         return "";
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-approve}.
1153      */
1154     function approve(address to, uint256 tokenId) public virtual override {
1155         address owner = ERC721.ownerOf(tokenId);
1156         require(to != owner, "ERC721: approval to current owner");
1157 
1158         require(
1159             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1160             "ERC721: approve caller is not owner nor approved for all"
1161         );
1162 
1163         _approve(to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-getApproved}.
1168      */
1169     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1170         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1171 
1172         return _tokenApprovals[tokenId];
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-setApprovalForAll}.
1177      */
1178     function setApprovalForAll(address operator, bool approved) public virtual override {
1179         require(operator != _msgSender(), "ERC721: approve to caller");
1180 
1181         _operatorApprovals[_msgSender()][operator] = approved;
1182         emit ApprovalForAll(_msgSender(), operator, approved);
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-isApprovedForAll}.
1187      */
1188     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1189         return _operatorApprovals[owner][operator];
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-transferFrom}.
1194      */
1195     function transferFrom(
1196         address from,
1197         address to,
1198         uint256 tokenId
1199     ) public virtual override {
1200         //solhint-disable-next-line max-line-length
1201         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1202 
1203         _transfer(from, to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-safeTransferFrom}.
1208      */
1209     function safeTransferFrom(
1210         address from,
1211         address to,
1212         uint256 tokenId
1213     ) public virtual override {
1214         safeTransferFrom(from, to, tokenId, "");
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-safeTransferFrom}.
1219      */
1220     function safeTransferFrom(
1221         address from,
1222         address to,
1223         uint256 tokenId,
1224         bytes memory _data
1225     ) public virtual override {
1226         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1227         _safeTransfer(from, to, tokenId, _data);
1228     }
1229 
1230     /**
1231      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1232      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1233      *
1234      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1235      *
1236      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1237      * implement alternative mechanisms to perform token transfer, such as signature-based.
1238      *
1239      * Requirements:
1240      *
1241      * - `from` cannot be the zero address.
1242      * - `to` cannot be the zero address.
1243      * - `tokenId` token must exist and be owned by `from`.
1244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function _safeTransfer(
1249         address from,
1250         address to,
1251         uint256 tokenId,
1252         bytes memory _data
1253     ) internal virtual {
1254         _transfer(from, to, tokenId);
1255         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1256     }
1257 
1258     /**
1259      * @dev Returns whether `tokenId` exists.
1260      *
1261      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1262      *
1263      * Tokens start existing when they are minted (`_mint`),
1264      * and stop existing when they are burned (`_burn`).
1265      */
1266     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1267         return _owners[tokenId] != address(0);
1268     }
1269 
1270     /**
1271      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1272      *
1273      * Requirements:
1274      *
1275      * - `tokenId` must exist.
1276      */
1277     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1278         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1279         address owner = ERC721.ownerOf(tokenId);
1280         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1281     }
1282 
1283     /**
1284      * @dev Safely mints `tokenId` and transfers it to `to`.
1285      *
1286      * Requirements:
1287      *
1288      * - `tokenId` must not exist.
1289      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1290      *
1291      * Emits a {Transfer} event.
1292      */
1293     function _safeMint(address to, uint256 tokenId) internal virtual {
1294         _safeMint(to, tokenId, "");
1295     }
1296 
1297     /**
1298      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1299      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1300      */
1301     function _safeMint(
1302         address to,
1303         uint256 tokenId,
1304         bytes memory _data
1305     ) internal virtual {
1306         _mint(to, tokenId);
1307         require(
1308             _checkOnERC721Received(address(0), to, tokenId, _data),
1309             "ERC721: transfer to non ERC721Receiver implementer"
1310         );
1311     }
1312 
1313     /**
1314      * @dev Mints `tokenId` and transfers it to `to`.
1315      *
1316      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1317      *
1318      * Requirements:
1319      *
1320      * - `tokenId` must not exist.
1321      * - `to` cannot be the zero address.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function _mint(address to, uint256 tokenId) internal virtual {
1326         require(to != address(0), "ERC721: mint to the zero address");
1327         require(!_exists(tokenId), "ERC721: token already minted");
1328 
1329         _beforeTokenTransfer(address(0), to, tokenId);
1330 
1331         _balances[to] += 1;
1332         _owners[tokenId] = to;
1333 
1334         emit Transfer(address(0), to, tokenId);
1335     }
1336 
1337     /**
1338      * @dev Destroys `tokenId`.
1339      * The approval is cleared when the token is burned.
1340      *
1341      * Requirements:
1342      *
1343      * - `tokenId` must exist.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _burn(uint256 tokenId) internal virtual {
1348         address owner = ERC721.ownerOf(tokenId);
1349 
1350         _beforeTokenTransfer(owner, address(0), tokenId);
1351 
1352         // Clear approvals
1353         _approve(address(0), tokenId);
1354 
1355         _balances[owner] -= 1;
1356         delete _owners[tokenId];
1357 
1358         emit Transfer(owner, address(0), tokenId);
1359     }
1360 
1361     /**
1362      * @dev Transfers `tokenId` from `from` to `to`.
1363      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1364      *
1365      * Requirements:
1366      *
1367      * - `to` cannot be the zero address.
1368      * - `tokenId` token must be owned by `from`.
1369      *
1370      * Emits a {Transfer} event.
1371      */
1372     function _transfer(
1373         address from,
1374         address to,
1375         uint256 tokenId
1376     ) internal virtual {
1377         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1378         require(to != address(0), "ERC721: transfer to the zero address");
1379 
1380         _beforeTokenTransfer(from, to, tokenId);
1381 
1382         // Clear approvals from the previous owner
1383         _approve(address(0), tokenId);
1384 
1385         _balances[from] -= 1;
1386         _balances[to] += 1;
1387         _owners[tokenId] = to;
1388 
1389         emit Transfer(from, to, tokenId);
1390     }
1391 
1392     /**
1393      * @dev Approve `to` to operate on `tokenId`
1394      *
1395      * Emits a {Approval} event.
1396      */
1397     function _approve(address to, uint256 tokenId) internal virtual {
1398         _tokenApprovals[tokenId] = to;
1399         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1400     }
1401 
1402     /**
1403      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1404      * The call is not executed if the target address is not a contract.
1405      *
1406      * @param from address representing the previous owner of the given token ID
1407      * @param to target address that will receive the tokens
1408      * @param tokenId uint256 ID of the token to be transferred
1409      * @param _data bytes optional data to send along with the call
1410      * @return bool whether the call correctly returned the expected magic value
1411      */
1412     function _checkOnERC721Received(
1413         address from,
1414         address to,
1415         uint256 tokenId,
1416         bytes memory _data
1417     ) private returns (bool) {
1418         if (to.isContract()) {
1419             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1420                 return retval == IERC721Receiver.onERC721Received.selector;
1421             } catch (bytes memory reason) {
1422                 if (reason.length == 0) {
1423                     revert("ERC721: transfer to non ERC721Receiver implementer");
1424                 } else {
1425                     assembly {
1426                         revert(add(32, reason), mload(reason))
1427                     }
1428                 }
1429             }
1430         } else {
1431             return true;
1432         }
1433     }
1434 
1435     /**
1436      * @dev Hook that is called before any token transfer. This includes minting
1437      * and burning.
1438      *
1439      * Calling conditions:
1440      *
1441      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1442      * transferred to `to`.
1443      * - When `from` is zero, `tokenId` will be minted for `to`.
1444      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1445      * - `from` and `to` are never both zero.
1446      *
1447      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1448      */
1449     function _beforeTokenTransfer(
1450         address from,
1451         address to,
1452         uint256 tokenId
1453     ) internal virtual {}
1454 }
1455 
1456 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1457 
1458 
1459 
1460 pragma solidity ^0.8.0;
1461 
1462 
1463 
1464 /**
1465  * @title ERC721 Burnable Token
1466  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1467  */
1468 abstract contract ERC721Burnable is Context, ERC721 {
1469     /**
1470      * @dev Burns `tokenId`. See {ERC721-_burn}.
1471      *
1472      * Requirements:
1473      *
1474      * - The caller must own `tokenId` or be an approved operator.
1475      */
1476     function burn(uint256 tokenId) public virtual {
1477         //solhint-disable-next-line max-line-length
1478         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1479         _burn(tokenId);
1480     }
1481 }
1482 
1483 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1484 
1485 
1486 
1487 pragma solidity ^0.8.0;
1488 
1489 
1490 
1491 /**
1492  * @dev ERC721 token with pausable token transfers, minting and burning.
1493  *
1494  * Useful for scenarios such as preventing trades until the end of an evaluation
1495  * period, or having an emergency switch for freezing all token transfers in the
1496  * event of a large bug.
1497  */
1498 abstract contract ERC721Pausable is ERC721, Pausable {
1499     /**
1500      * @dev See {ERC721-_beforeTokenTransfer}.
1501      *
1502      * Requirements:
1503      *
1504      * - the contract must not be paused.
1505      */
1506     function _beforeTokenTransfer(
1507         address from,
1508         address to,
1509         uint256 tokenId
1510     ) internal virtual override {
1511         super._beforeTokenTransfer(from, to, tokenId);
1512 
1513         require(!paused(), "ERC721Pausable: token transfer while paused");
1514     }
1515 }
1516 
1517 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1518 
1519 
1520 
1521 pragma solidity ^0.8.0;
1522 
1523 
1524 
1525 /**
1526  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1527  * enumerability of all the token ids in the contract as well as all token ids owned by each
1528  * account.
1529  */
1530 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1531     // Mapping from owner to list of owned token IDs
1532     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1533 
1534     // Mapping from token ID to index of the owner tokens list
1535     mapping(uint256 => uint256) private _ownedTokensIndex;
1536 
1537     // Array with all token ids, used for enumeration
1538     uint256[] private _allTokens;
1539 
1540     // Mapping from token id to position in the allTokens array
1541     mapping(uint256 => uint256) private _allTokensIndex;
1542 
1543     /**
1544      * @dev See {IERC165-supportsInterface}.
1545      */
1546     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1547         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1548     }
1549 
1550     /**
1551      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1552      */
1553     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1554         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1555         return _ownedTokens[owner][index];
1556     }
1557 
1558     /**
1559      * @dev See {IERC721Enumerable-totalSupply}.
1560      */
1561     function totalSupply() public view virtual override returns (uint256) {
1562         return _allTokens.length;
1563     }
1564 
1565     /**
1566      * @dev See {IERC721Enumerable-tokenByIndex}.
1567      */
1568     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1569         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1570         return _allTokens[index];
1571     }
1572 
1573     /**
1574      * @dev Hook that is called before any token transfer. This includes minting
1575      * and burning.
1576      *
1577      * Calling conditions:
1578      *
1579      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1580      * transferred to `to`.
1581      * - When `from` is zero, `tokenId` will be minted for `to`.
1582      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1583      * - `from` cannot be the zero address.
1584      * - `to` cannot be the zero address.
1585      *
1586      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1587      */
1588     function _beforeTokenTransfer(
1589         address from,
1590         address to,
1591         uint256 tokenId
1592     ) internal virtual override {
1593         super._beforeTokenTransfer(from, to, tokenId);
1594 
1595         if (from == address(0)) {
1596             _addTokenToAllTokensEnumeration(tokenId);
1597         } else if (from != to) {
1598             _removeTokenFromOwnerEnumeration(from, tokenId);
1599         }
1600         if (to == address(0)) {
1601             _removeTokenFromAllTokensEnumeration(tokenId);
1602         } else if (to != from) {
1603             _addTokenToOwnerEnumeration(to, tokenId);
1604         }
1605     }
1606 
1607     /**
1608      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1609      * @param to address representing the new owner of the given token ID
1610      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1611      */
1612     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1613         uint256 length = ERC721.balanceOf(to);
1614         _ownedTokens[to][length] = tokenId;
1615         _ownedTokensIndex[tokenId] = length;
1616     }
1617 
1618     /**
1619      * @dev Private function to add a token to this extension's token tracking data structures.
1620      * @param tokenId uint256 ID of the token to be added to the tokens list
1621      */
1622     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1623         _allTokensIndex[tokenId] = _allTokens.length;
1624         _allTokens.push(tokenId);
1625     }
1626 
1627     /**
1628      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1629      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1630      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1631      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1632      * @param from address representing the previous owner of the given token ID
1633      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1634      */
1635     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1636         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1637         // then delete the last slot (swap and pop).
1638 
1639         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1640         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1641 
1642         // When the token to delete is the last token, the swap operation is unnecessary
1643         if (tokenIndex != lastTokenIndex) {
1644             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1645 
1646             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1647             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1648         }
1649 
1650         // This also deletes the contents at the last position of the array
1651         delete _ownedTokensIndex[tokenId];
1652         delete _ownedTokens[from][lastTokenIndex];
1653     }
1654 
1655     /**
1656      * @dev Private function to remove a token from this extension's token tracking data structures.
1657      * This has O(1) time complexity, but alters the order of the _allTokens array.
1658      * @param tokenId uint256 ID of the token to be removed from the tokens list
1659      */
1660     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1661         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1662         // then delete the last slot (swap and pop).
1663 
1664         uint256 lastTokenIndex = _allTokens.length - 1;
1665         uint256 tokenIndex = _allTokensIndex[tokenId];
1666 
1667         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1668         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1669         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1670         uint256 lastTokenId = _allTokens[lastTokenIndex];
1671 
1672         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1673         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1674 
1675         // This also deletes the contents at the last position of the array
1676         delete _allTokensIndex[tokenId];
1677         _allTokens.pop();
1678     }
1679 }
1680 
1681 // File: contracts/InsaneBoxKids.sol
1682 
1683 
1684 pragma solidity >=0.8.0 <0.9.0;
1685 
1686 
1687 
1688 
1689 
1690 
1691 
1692 
1693 contract InsaneBoxKids is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable {
1694     using SafeMath for uint256;
1695     using Counters for Counters.Counter;
1696 
1697     Counters.Counter private _tokenId;
1698 
1699     uint256 public constant MAX_ELEMENTS = 9500;
1700     uint256 public constant MAX_FEMALE = 500;
1701     uint256 public constant RESERVES = 25;
1702     uint256 public price = 0.05 ether;
1703     uint256 public constant MAX_BY_MINT = 10;
1704 
1705     address public constant creatorAddress = 0x2C0AE94503dFeEA20AA7B71cB9884C9B5db42CB6; // 45%
1706     address public constant devAddress = 0x75479B52c8ccBD74716fb3EA17074AAeF14c66a2;  // 25%
1707     address public constant artistAddress = 0xdcd14a1325b1fd98A275b195A60a01FDF4a10803; //  25%
1708     address public constant IBKAddress = 0x29864E60135E96Ab9D2495c0BFff5d54CF35F9e0; // 5%
1709     
1710     uint private femaleSaleTime = 1630627200; // September 2, 2021 20:00 EST
1711     uint private saleTime = 1633046400; // September 30, 2021 20:00 EST
1712     uint private preSaleTime = 1633046400; // September 30, 2021 20:00 EST
1713     uint256 private _preSaleSupply = 6;
1714     string public baseTokenURI;
1715     
1716     mapping(address => bool) addressToPreSaleEntry;
1717     mapping(address => uint256) addressToPreSaleMints;
1718     constructor(string memory baseURI) ERC721("InsaneBoxKids", "IBK") {
1719         setBaseURI(baseURI);
1720         pause(true);
1721     }
1722 
1723     modifier femaleSaleIsOpen() {
1724         require(block.timestamp >= femaleSaleTime, "Sale has not started yet.");
1725         require(totalSupply() <= MAX_FEMALE, "Female sale has ended.");
1726         if (_msgSender() != owner()) {
1727             require(!paused(), "Pausable: paused");
1728         }
1729         _;
1730     }
1731 
1732     modifier saleIsOpen {
1733         require(_totalSupply() <= MAX_ELEMENTS, "Sale end");
1734         if (_msgSender() != owner()) {
1735             require(block.timestamp >= saleTime, "Sales not open");
1736         }
1737         _;
1738     }
1739     modifier preSaleIsOpen {
1740         require(block.timestamp >= preSaleTime, "The presale has not started yet.");
1741         if (_msgSender() != owner()) {
1742             require(!paused(), "Pausable: paused");
1743         }
1744         _;
1745     }
1746     
1747     function _totalSupply() internal view returns (uint) {
1748         return _tokenId.current();
1749     }
1750     function totalMint() public view returns (uint256) {
1751         return totalSupply();
1752     }
1753     function setSaleTime(uint256 _time) public onlyOwner {
1754         saleTime = _time;
1755     }
1756     function setPreSaleTime(uint256 _time) public onlyOwner {
1757         preSaleTime = _time;
1758     }
1759     function getSaleTime() public view returns (uint256){
1760         return saleTime;
1761     }
1762      function getPreSaleTime() public view returns (uint256){
1763         return preSaleTime;
1764     }
1765     function setPreSaleSupply(uint256 _val) public onlyOwner {
1766         _preSaleSupply = _val;
1767     }
1768     function getPreSaleSupply() public view returns (uint256){
1769         return _preSaleSupply;
1770     }
1771     function setPrice(uint256 _newPrice) public onlyOwner {
1772         price = _newPrice;
1773     }
1774     function getPrice() public view returns (uint256) {
1775         return price;
1776     }
1777     function pause(bool value) public onlyOwner {
1778         if(value == true){
1779             _pause();
1780             return;
1781         }
1782         _unpause();
1783     }
1784    
1785     function addWalletToPreSale(address _address) public onlyOwner {
1786         addressToPreSaleEntry[_address] = true;
1787     }
1788     function isWalletInPreSale(address _address) public view returns (bool){
1789         return addressToPreSaleEntry[_address];
1790     }
1791     function preSaleKidsMinted(address _address) public view returns (uint256){
1792         return addressToPreSaleMints[_address];
1793     }
1794     function femaleSaleMint(uint256 _count) public payable femaleSaleIsOpen {
1795         uint256 totalSupply = totalSupply();
1796         
1797         require(totalSupply < MAX_FEMALE, "All females are already minted.");
1798         require(totalSupply + _count <= MAX_FEMALE, "This amount will exceed max supply.");
1799         require(price * _count <= msg.value, "Transaction value is too low.");
1800         require(_count <= MAX_BY_MINT, "Exceeds number");
1801         for(uint256 i = 0; i < _count; i++){
1802             _safeMint(msg.sender, totalSupply + i);
1803         }
1804 
1805     }
1806     function preSaleMint(uint256 _count) public payable preSaleIsOpen {
1807         uint256 totalSupply = totalSupply();
1808         require(_count <= _preSaleSupply, "Mint transaction exceeds the available supply.");
1809         require(addressToPreSaleEntry[msg.sender] == true, "This address does not have access to the presale.");
1810         require(addressToPreSaleMints[msg.sender] + _count <= _preSaleSupply, "Exceeds supply of available mints.");
1811         require(price * _count <= msg.value, "Transaction value too low.");
1812         
1813         for(uint i; i < _count; i++){
1814             _safeMint(msg.sender, totalSupply + i);
1815         }
1816         addressToPreSaleMints[msg.sender] += _count;
1817     }
1818     function mint(uint256 _count) public payable saleIsOpen {
1819         uint256 totalSupply = totalSupply();
1820         require(totalSupply + _count <= MAX_ELEMENTS, "Max limit");
1821         require(totalSupply <= MAX_ELEMENTS, "Sale has ended");
1822         require(_count <= MAX_BY_MINT, "Exceeds number of allowed tokens to mint.");
1823         require(msg.value >= price * _count, "Value below price");
1824 
1825         for (uint256 i = 0; i < _count; i++) {
1826             _safeMint(msg.sender, totalSupply + i);
1827         }
1828     }
1829    
1830    
1831     function _baseURI() internal view virtual override returns (string memory) {
1832         return baseTokenURI;
1833     }
1834 
1835     function setBaseURI(string memory baseURI) public onlyOwner {
1836         baseTokenURI = baseURI;
1837     }
1838 
1839     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
1840         uint256 tokenCount = balanceOf(_owner);
1841         if (tokenCount == 0){
1842             return new uint256[](0);
1843         }
1844         uint256[] memory tokensId = new uint256[](tokenCount);
1845         for (uint256 i = 0; i < tokenCount; i++) {
1846             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1847         }
1848 
1849         return tokensId;
1850     }
1851 
1852  
1853     function reserve(uint256 _count) public onlyOwner {
1854         uint256 total = totalSupply();
1855         require(total + _count <= RESERVES, "Exceeded");
1856 
1857         for (uint256 i = 0; i < _count; i++) {
1858             _safeMint(IBKAddress, total + i);
1859         }
1860     }
1861 
1862     function withdrawAll() public payable onlyOwner {
1863         uint256 balance = address(this).balance;
1864         require(balance > 0);
1865         _withdraw(devAddress, balance.mul(25).div(100));
1866         _withdraw(artistAddress, balance.mul(25).div(100));
1867         _withdraw(IBKAddress, balance.mul(5).div(100));
1868         _withdraw(creatorAddress, address(this).balance);
1869     }
1870 
1871     function _withdraw(address _address, uint256 _amount) private {
1872         (bool success, ) = _address.call{value: _amount}("");
1873         require(success, "Transfer failed.");
1874     }
1875      function _beforeTokenTransfer(
1876         address from,
1877         address to,
1878         uint256 tokenId
1879     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
1880         super._beforeTokenTransfer(from, to, tokenId);
1881     }
1882      function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1883         return super.supportsInterface(interfaceId);
1884     }
1885     
1886 }