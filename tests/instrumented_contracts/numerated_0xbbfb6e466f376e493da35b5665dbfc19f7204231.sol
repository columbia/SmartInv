1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * GEN.ART Collection Contract
6  */
7 
8 interface IGenArt {
9     function getTokensByOwner(address owner)
10         external
11         view
12         returns (uint256[] memory);
13 
14     function ownerOf(uint256 tokenId) external view returns (address);
15 
16     function isGoldToken(uint256 _tokenId) external view returns (bool);
17 }
18 
19 interface IGenArtInterface {
20     function getMaxMintForMembership(uint256 _membershipId)
21         external
22         view
23         returns (uint256);
24 
25     function getMaxMintForOwner(address owner) external view returns (uint256);
26 
27     function upgradeGenArtTokenContract(address _genArtTokenAddress) external;
28 
29     function setAllowGen(bool allow) external;
30 
31     function genAllowed() external view returns (bool);
32 
33     function isGoldToken(uint256 _membershipId) external view returns (bool);
34 
35     function transferFrom(
36         address _from,
37         address _to,
38         uint256 _amount
39     ) external;
40 
41     function balanceOf(address _owner) external view returns (uint256);
42 
43     function ownerOf(uint256 _membershipId) external view returns (address);
44 }
45 
46 /**
47  * @dev Provides information about the current execution context, including the
48  * sender of the transaction and its data. While these are generally available
49  * via msg.sender and msg.data, they should not be accessed in such a direct
50  * manner, since when dealing with meta-transactions the account sending and
51  * paying for execution may not be the actual sender (as far as an application
52  * is concerned).
53  *
54  * This contract is only required for intermediate, library-like contracts.
55  */
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view virtual returns (bytes calldata) {
62         return msg.data;
63     }
64 }
65 
66 /**
67  * @dev Contract module which provides a basic access control mechanism, where
68  * there is an account (an owner) that can be granted exclusive access to
69  * specific functions.
70  *
71  * By default, the owner account will be the one that deploys the contract. This
72  * can later be changed with {transferOwnership}.
73  *
74  * This module is used through inheritance. It will make available the modifier
75  * `onlyOwner`, which can be applied to your functions to restrict their use to
76  * the owner.
77  */
78 abstract contract Ownable is Context {
79     address private _owner;
80 
81     event OwnershipTransferred(
82         address indexed previousOwner,
83         address indexed newOwner
84     );
85 
86     /**
87      * @dev Initializes the contract setting the deployer as the initial owner.
88      */
89     constructor() {
90         _setOwner(_msgSender());
91     }
92 
93     /**
94      * @dev Returns the address of the current owner.
95      */
96     function owner() public view virtual returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(owner() == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Can only be called by the current owner.
111      */
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(
114             newOwner != address(0),
115             "Ownable: new owner is the zero address"
116         );
117         _setOwner(newOwner);
118     }
119 
120     function _setOwner(address newOwner) private {
121         address oldOwner = _owner;
122         _owner = newOwner;
123         emit OwnershipTransferred(oldOwner, newOwner);
124     }
125 }
126 
127 /**
128  * @title Counters
129  * @author Matt Condon (@shrugs)
130  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
131  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
132  *
133  * Include with `using Counters for Counters.Counter;`
134  */
135 library Counters {
136     struct Counter {
137         // This variable should never be directly accessed by users of the library: interactions must be restricted to
138         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
139         // this feature: see https://github.com/ethereum/solidity/issues/4637
140         uint256 _value; // default: 0
141     }
142 
143     function current(Counter storage counter) internal view returns (uint256) {
144         return counter._value;
145     }
146 
147     function increment(Counter storage counter) internal {
148         unchecked {
149             counter._value += 1;
150         }
151     }
152 
153     function decrement(Counter storage counter) internal {
154         uint256 value = counter._value;
155         require(value > 0, "Counter: decrement overflow");
156         unchecked {
157             counter._value = value - 1;
158         }
159     }
160 
161     function reset(Counter storage counter) internal {
162         counter._value = 0;
163     }
164 }
165 
166 /**
167  * @dev String operations.
168  */
169 library Strings {
170     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
171 
172     /**
173      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
174      */
175     function toString(uint256 value) internal pure returns (string memory) {
176         // Inspired by OraclizeAPI's implementation - MIT licence
177         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
178 
179         if (value == 0) {
180             return "0";
181         }
182         uint256 temp = value;
183         uint256 digits;
184         while (temp != 0) {
185             digits++;
186             temp /= 10;
187         }
188         bytes memory buffer = new bytes(digits);
189         while (value != 0) {
190             digits -= 1;
191             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
192             value /= 10;
193         }
194         return string(buffer);
195     }
196 }
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      */
219     function isContract(address account) internal view returns (bool) {
220         // This method relies on extcodesize, which returns 0 for contracts in
221         // construction, since the code is only stored at the end of the
222         // constructor execution.
223 
224         uint256 size;
225         assembly {
226             size := extcodesize(account)
227         }
228         return size > 0;
229     }
230 }
231 
232 // CAUTION
233 // This version of SafeMath should only be used with Solidity 0.8 or later,
234 // because it relies on the compiler's built in overflow checks.
235 
236 /**
237  * @dev Wrappers over Solidity's arithmetic operations.
238  *
239  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
240  * now has built in overflow checking.
241  */
242 library SafeMath {
243     /**
244      * @dev Returns the addition of two unsigned integers, with an overflow flag.
245      *
246      * _Available since v3.4._
247      */
248     function tryAdd(uint256 a, uint256 b)
249         internal
250         pure
251         returns (bool, uint256)
252     {
253         unchecked {
254             uint256 c = a + b;
255             if (c < a) return (false, 0);
256             return (true, c);
257         }
258     }
259 
260     /**
261      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
262      *
263      * _Available since v3.4._
264      */
265     function trySub(uint256 a, uint256 b)
266         internal
267         pure
268         returns (bool, uint256)
269     {
270         unchecked {
271             if (b > a) return (false, 0);
272             return (true, a - b);
273         }
274     }
275 
276     /**
277      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
278      *
279      * _Available since v3.4._
280      */
281     function tryMul(uint256 a, uint256 b)
282         internal
283         pure
284         returns (bool, uint256)
285     {
286         unchecked {
287             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
288             // benefit is lost if 'b' is also tested.
289             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
290             if (a == 0) return (true, 0);
291             uint256 c = a * b;
292             if (c / a != b) return (false, 0);
293             return (true, c);
294         }
295     }
296 
297     /**
298      * @dev Returns the division of two unsigned integers, with a division by zero flag.
299      *
300      * _Available since v3.4._
301      */
302     function tryDiv(uint256 a, uint256 b)
303         internal
304         pure
305         returns (bool, uint256)
306     {
307         unchecked {
308             if (b == 0) return (false, 0);
309             return (true, a / b);
310         }
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
315      *
316      * _Available since v3.4._
317      */
318     function tryMod(uint256 a, uint256 b)
319         internal
320         pure
321         returns (bool, uint256)
322     {
323         unchecked {
324             if (b == 0) return (false, 0);
325             return (true, a % b);
326         }
327     }
328 
329     /**
330      * @dev Returns the addition of two unsigned integers, reverting on
331      * overflow.
332      *
333      * Counterpart to Solidity's `+` operator.
334      *
335      * Requirements:
336      *
337      * - Addition cannot overflow.
338      */
339     function add(uint256 a, uint256 b) internal pure returns (uint256) {
340         return a + b;
341     }
342 
343     /**
344      * @dev Returns the subtraction of two unsigned integers, reverting on
345      * overflow (when the result is negative).
346      *
347      * Counterpart to Solidity's `-` operator.
348      *
349      * Requirements:
350      *
351      * - Subtraction cannot overflow.
352      */
353     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
354         return a - b;
355     }
356 
357     /**
358      * @dev Returns the multiplication of two unsigned integers, reverting on
359      * overflow.
360      *
361      * Counterpart to Solidity's `*` operator.
362      *
363      * Requirements:
364      *
365      * - Multiplication cannot overflow.
366      */
367     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
368         return a * b;
369     }
370 
371     /**
372      * @dev Returns the integer division of two unsigned integers, reverting on
373      * division by zero. The result is rounded towards zero.
374      *
375      * Counterpart to Solidity's `/` operator.
376      *
377      * Requirements:
378      *
379      * - The divisor cannot be zero.
380      */
381     function div(uint256 a, uint256 b) internal pure returns (uint256) {
382         return a / b;
383     }
384 
385     /**
386      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
387      * reverting when dividing by zero.
388      *
389      * Counterpart to Solidity's `%` operator. This function uses a `revert`
390      * opcode (which leaves remaining gas untouched) while Solidity uses an
391      * invalid opcode to revert (consuming all remaining gas).
392      *
393      * Requirements:
394      *
395      * - The divisor cannot be zero.
396      */
397     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
398         return a % b;
399     }
400 
401     /**
402      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
403      * overflow (when the result is negative).
404      *
405      * CAUTION: This function is deprecated because it requires allocating memory for the error
406      * message unnecessarily. For custom revert reasons use {trySub}.
407      *
408      * Counterpart to Solidity's `-` operator.
409      *
410      * Requirements:
411      *
412      * - Subtraction cannot overflow.
413      */
414     function sub(
415         uint256 a,
416         uint256 b,
417         string memory errorMessage
418     ) internal pure returns (uint256) {
419         unchecked {
420             require(b <= a, errorMessage);
421             return a - b;
422         }
423     }
424 
425     /**
426      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
427      * division by zero. The result is rounded towards zero.
428      *
429      * Counterpart to Solidity's `/` operator. Note: this function uses a
430      * `revert` opcode (which leaves remaining gas untouched) while Solidity
431      * uses an invalid opcode to revert (consuming all remaining gas).
432      *
433      * Requirements:
434      *
435      * - The divisor cannot be zero.
436      */
437     function div(
438         uint256 a,
439         uint256 b,
440         string memory errorMessage
441     ) internal pure returns (uint256) {
442         unchecked {
443             require(b > 0, errorMessage);
444             return a / b;
445         }
446     }
447 
448     /**
449      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
450      * reverting with custom message when dividing by zero.
451      *
452      * CAUTION: This function is deprecated because it requires allocating memory for the error
453      * message unnecessarily. For custom revert reasons use {tryMod}.
454      *
455      * Counterpart to Solidity's `%` operator. This function uses a `revert`
456      * opcode (which leaves remaining gas untouched) while Solidity uses an
457      * invalid opcode to revert (consuming all remaining gas).
458      *
459      * Requirements:
460      *
461      * - The divisor cannot be zero.
462      */
463     function mod(
464         uint256 a,
465         uint256 b,
466         string memory errorMessage
467     ) internal pure returns (uint256) {
468         unchecked {
469             require(b > 0, errorMessage);
470             return a % b;
471         }
472     }
473 }
474 
475 /**
476  * @dev Interface of the ERC20 standard as defined in the EIP.
477  */
478 interface IERC20 {
479     /**
480      * @dev Returns the amount of tokens in existence.
481      */
482     function totalSupply() external view returns (uint256);
483 
484     /**
485      * @dev Returns the amount of tokens owned by `account`.
486      */
487     function balanceOf(address account) external view returns (uint256);
488 
489     /**
490      * @dev Moves `amount` tokens from the caller's account to `recipient`.
491      *
492      * Returns a boolean value indicating whether the operation succeeded.
493      *
494      * Emits a {Transfer} event.
495      */
496     function transfer(address recipient, uint256 amount)
497         external
498         returns (bool);
499 
500     /**
501      * @dev Returns the remaining number of tokens that `spender` will be
502      * allowed to spend on behalf of `owner` through {transferFrom}. This is
503      * zero by default.
504      *
505      * This value changes when {approve} or {transferFrom} are called.
506      */
507     function allowance(address owner, address spender)
508         external
509         view
510         returns (uint256);
511 
512     /**
513      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
514      *
515      * Returns a boolean value indicating whether the operation succeeded.
516      *
517      * IMPORTANT: Beware that changing an allowance with this method brings the risk
518      * that someone may use both the old and the new allowance by unfortunate
519      * transaction ordering. One possible solution to mitigate this race
520      * condition is to first reduce the spender's allowance to 0 and set the
521      * desired value afterwards:
522      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
523      *
524      * Emits an {Approval} event.
525      */
526     function approve(address spender, uint256 amount) external returns (bool);
527 
528     /**
529      * @dev Moves `amount` tokens from `sender` to `recipient` using the
530      * allowance mechanism. `amount` is then deducted from the caller's
531      * allowance.
532      *
533      * Returns a boolean value indicating whether the operation succeeded.
534      *
535      * Emits a {Transfer} event.
536      */
537     function transferFrom(
538         address sender,
539         address recipient,
540         uint256 amount
541     ) external returns (bool);
542 
543     /**
544      * @dev Emitted when `value` tokens are moved from one account (`from`) to
545      * another (`to`).
546      *
547      * Note that `value` may be zero.
548      */
549     event Transfer(address indexed from, address indexed to, uint256 value);
550 
551     /**
552      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
553      * a call to {approve}. `value` is the new allowance.
554      */
555     event Approval(
556         address indexed owner,
557         address indexed spender,
558         uint256 value
559     );
560 }
561 
562 /**
563  * @title ERC721 token receiver interface
564  * @dev Interface for any contract that wants to support safeTransfers
565  * from ERC721 asset contracts.
566  */
567 interface IERC721Receiver {
568     /**
569      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
570      * by `operator` from `from`, this function is called.
571      *
572      * It must return its Solidity selector to confirm the token transfer.
573      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
574      *
575      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
576      */
577     function onERC721Received(
578         address operator,
579         address from,
580         uint256 tokenId,
581         bytes calldata data
582     ) external returns (bytes4);
583 }
584 
585 /**
586  * @dev Interface of the ERC165 standard, as defined in the
587  * https://eips.ethereum.org/EIPS/eip-165[EIP].
588  *
589  * Implementers can declare support of contract interfaces, which can then be
590  * queried by others ({ERC165Checker}).
591  *
592  * For an implementation, see {ERC165}.
593  */
594 interface IERC165 {
595     /**
596      * @dev Returns true if this contract implements the interface defined by
597      * `interfaceId`. See the corresponding
598      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
599      * to learn more about how these ids are created.
600      *
601      * This function call must use less than 30 000 gas.
602      */
603     function supportsInterface(bytes4 interfaceId) external view returns (bool);
604 }
605 
606 /**
607  * @dev Implementation of the {IERC165} interface.
608  *
609  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
610  * for the additional interface id that will be supported. For example:
611  *
612  * ```solidity
613  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
615  * }
616  * ```
617  *
618  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
619  */
620 abstract contract ERC165 is IERC165 {
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId)
625         public
626         view
627         virtual
628         override
629         returns (bool)
630     {
631         return interfaceId == type(IERC165).interfaceId;
632     }
633 }
634 
635 /**
636  * @dev Required interface of an ERC721 compliant contract.
637  */
638 interface IERC721 is IERC165 {
639     /**
640      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
641      */
642     event Transfer(
643         address indexed from,
644         address indexed to,
645         uint256 indexed tokenId
646     );
647 
648     /**
649      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
650      */
651     event Approval(
652         address indexed owner,
653         address indexed approved,
654         uint256 indexed tokenId
655     );
656 
657     /**
658      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
659      */
660     event ApprovalForAll(
661         address indexed owner,
662         address indexed operator,
663         bool approved
664     );
665 
666     /**
667      * @dev Returns the number of tokens in ``owner``'s account.
668      */
669     function balanceOf(address owner) external view returns (uint256 balance);
670 
671     /**
672      * @dev Returns the owner of the `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function ownerOf(uint256 tokenId) external view returns (address owner);
679 
680     /**
681      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
682      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must exist and be owned by `from`.
689      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
690      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
691      *
692      * Emits a {Transfer} event.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) external;
699 
700     /**
701      * @dev Transfers `tokenId` token from `from` to `to`.
702      *
703      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must be owned by `from`.
710      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
711      *
712      * Emits a {Transfer} event.
713      */
714     function transferFrom(
715         address from,
716         address to,
717         uint256 tokenId
718     ) external;
719 
720     /**
721      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
722      * The approval is cleared when the token is transferred.
723      *
724      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
725      *
726      * Requirements:
727      *
728      * - The caller must own the token or be an approved operator.
729      * - `tokenId` must exist.
730      *
731      * Emits an {Approval} event.
732      */
733     function approve(address to, uint256 tokenId) external;
734 
735     /**
736      * @dev Returns the account approved for `tokenId` token.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function getApproved(uint256 tokenId)
743         external
744         view
745         returns (address operator);
746 
747     /**
748      * @dev Approve or remove `operator` as an operator for the caller.
749      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
750      *
751      * Requirements:
752      *
753      * - The `operator` cannot be the caller.
754      *
755      * Emits an {ApprovalForAll} event.
756      */
757     function setApprovalForAll(address operator, bool _approved) external;
758 
759     /**
760      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
761      *
762      * See {setApprovalForAll}
763      */
764     function isApprovedForAll(address owner, address operator)
765         external
766         view
767         returns (bool);
768 
769     /**
770      * @dev Safely transfers `tokenId` token from `from` to `to`.
771      *
772      * Requirements:
773      *
774      * - `from` cannot be the zero address.
775      * - `to` cannot be the zero address.
776      * - `tokenId` token must exist and be owned by `from`.
777      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function safeTransferFrom(
783         address from,
784         address to,
785         uint256 tokenId,
786         bytes calldata data
787     ) external;
788 }
789 
790 /**
791  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
792  * @dev See https://eips.ethereum.org/EIPS/eip-721
793  */
794 interface IERC721Enumerable is IERC721 {
795     /**
796      * @dev Returns the total amount of tokens stored by the contract.
797      */
798     function totalSupply() external view returns (uint256);
799 
800     /**
801      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
802      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
803      */
804     function tokenOfOwnerByIndex(address owner, uint256 index)
805         external
806         view
807         returns (uint256 tokenId);
808 
809     /**
810      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
811      * Use along with {totalSupply} to enumerate all tokens.
812      */
813     function tokenByIndex(uint256 index) external view returns (uint256);
814 }
815 
816 /**
817  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
818  * @dev See https://eips.ethereum.org/EIPS/eip-721
819  */
820 interface IERC721Metadata is IERC721 {
821     /**
822      * @dev Returns the token collection name.
823      */
824     function name() external view returns (string memory);
825 
826     /**
827      * @dev Returns the token collection symbol.
828      */
829     function symbol() external view returns (string memory);
830 
831     /**
832      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
833      */
834     function tokenURI(uint256 tokenId) external view returns (string memory);
835 }
836 
837 /**
838  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
839  * the Metadata extension, but not including the Enumerable extension, which is available separately as
840  * {ERC721Enumerable}.
841  */
842 
843 contract GenArtCollection is
844     Context,
845     ERC165,
846     IERC721,
847     IERC721Metadata,
848     IERC721Enumerable,
849     Ownable
850 {
851     using Address for address;
852     using Strings for uint256;
853     using Counters for Counters.Counter;
854     using SafeMath for uint256;
855 
856     struct Collection {
857         uint256 tier;
858         uint256 invocations;
859         uint256 maxInvocations;
860         string script;
861         uint256 price;
862         uint256 priceGen;
863         uint256 artistPercentage;
864         address artist;
865     }
866 
867     event Mint(address to, uint256 collectionId, uint256 tokenId, bytes32 hash);
868 
869     // IGenArtMintState _genArtMintState;
870     mapping(uint256 => Collection) private _collectionsMap;
871 
872     // Mapping collectionId to membershipId and total mints
873     mapping(uint256 => mapping(uint256 => uint256)) private _collectionsMintMap;
874 
875     mapping(uint256 => bytes32) private _tokenIdToHashMap;
876     mapping(uint256 => uint256) private _tokenIdToCollectionIdMap;
877     Counters.Counter private _collectionIdCounter;
878     IGenArtInterface private _genArtInterface;
879 
880     // Token name
881     string private _name;
882 
883     // Token symbol
884     string private _symbol;
885 
886     // Base URI
887     string private _baseURI;
888 
889     // Mapping from token ID to owner address
890     mapping(uint256 => address) private _owners;
891 
892     // Mapping owner address to token count
893     mapping(address => uint256) private _balances;
894 
895     // Mapping from token ID to approved address
896     mapping(uint256 => address) private _tokenApprovals;
897 
898     // Mapping from owner to operator approvals
899     mapping(address => mapping(address => bool)) private _operatorApprovals;
900 
901     // Mapping from owner to list of owned token IDs
902     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
903 
904     // Mapping from token ID to index of the owner tokens list
905     mapping(uint256 => uint256) private _ownedTokensIndex;
906 
907     // Array with all token ids, used for enumeration
908     uint256[] private _allTokens;
909 
910     // Mapping from token id to position in the allTokens array
911     mapping(uint256 => uint256) private _allTokensIndex;
912 
913     /**
914      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
915      */
916     constructor(
917         string memory name_,
918         string memory symbol_,
919         string memory uri_,
920         address genArtInterfaceAddress_
921     ) {
922         _name = name_;
923         _symbol = symbol_;
924         _baseURI = uri_;
925         _genArtInterface = IGenArtInterface(genArtInterfaceAddress_);
926         _collectionIdCounter.increment();
927     }
928 
929     modifier onlyArtist(uint256 _collectionId) {
930         require(
931             _collectionsMap[_collectionId].artist == _msgSender(),
932             "GenArtCollection: only artist can call this function"
933         );
934         _;
935     }
936 
937     function withdraw(uint256 value) public onlyOwner {
938         address _owner = owner();
939         payable(_owner).transfer(value);
940     }
941 
942     function createGenCollection(
943         address _artist,
944         uint256 _artistPercentage,
945         uint256 _price,
946         uint256 _priceGen,
947         uint256 _maxInvocations,
948         uint256 _tier,
949         string memory _script
950     ) public onlyOwner {
951         uint256 _collectionId = _collectionIdCounter.current();
952 
953         _collectionsMap[_collectionId] = Collection({
954             tier: _tier,
955             invocations: 0,
956             maxInvocations: _maxInvocations,
957             script: _script,
958             price: _price,
959             priceGen: _priceGen,
960             artistPercentage: _artistPercentage,
961             artist: _artist
962         });
963 
964         _collectionIdCounter.increment();
965     }
966 
967     function checkMint(
968         address _sender,
969         uint256 _collectionId,
970         uint256 _membershipId,
971         uint256 _value,
972         uint256 _amount,
973         bool _isEthPayment
974     ) internal virtual {
975         require(
976             _collectionsMap[_collectionId].tier != 0,
977             "GenArtCollection: incorrect collection id"
978         );
979         require(
980             _collectionsMap[_collectionId].invocations <
981                 _collectionsMap[_collectionId].maxInvocations,
982             "GenArtCollection: max invocations was reached"
983         );
984         address _membershipOwner = _genArtInterface.ownerOf(_membershipId);
985         require(
986             _membershipOwner == _sender,
987             "GenArtCollection: sender must be membership owner"
988         );
989         bool _isGoldMember = _genArtInterface.isGoldToken(_membershipId);
990         uint256 _tier = _isGoldMember ? 2 : 1;
991         require(
992             _collectionsMap[_collectionId].tier == 3 ||
993                 _collectionsMap[_collectionId].tier == _tier,
994             "GenArtCollection: no valid membership"
995         );
996         uint256 maxMint = getAllowedMintForMembership(
997             _collectionId,
998             _membershipId
999         );
1000         require(
1001             maxMint >= _amount,
1002             "GenArtCollection: no mints avaliable"
1003         );
1004         if (_isEthPayment) {
1005             require(
1006                 _collectionsMap[_collectionId].price.mul(_amount) <= _value,
1007                 "GenArtCollection: incorrect amount sent"
1008             );
1009         } else {
1010             require(
1011                 _collectionsMap[_collectionId].priceGen.mul(_amount) <= _value,
1012                 "GenArtCollection: insufficient $GEN balance"
1013             );
1014         }
1015     }
1016 
1017     function mint(
1018         address _to,
1019         uint256 _collectionId,
1020         uint256 _membershipId
1021     ) public payable {
1022         checkMint(msg.sender, _collectionId, _membershipId, msg.value, 1, true);
1023         updateMintState(_collectionId, _membershipId, 1);
1024         _mintOne(_to, _collectionId);
1025         splitFunds(msg.sender, _collectionId, 1, true);
1026     }
1027 
1028     function mintGen(
1029         address _to,
1030         uint256 _collectionId,
1031         uint256 _membershipId
1032     ) public {
1033         bool _genAllowed = _genArtInterface.genAllowed();
1034         require(_genAllowed, "Mint with $GENART not allowed");
1035         uint256 balance = _genArtInterface.balanceOf(msg.sender);
1036         checkMint(msg.sender, _collectionId, _membershipId, balance, 1, false);
1037         updateMintState(_collectionId, _membershipId, 1);
1038         _mintOne(_to, _collectionId);
1039         splitFunds(msg.sender, _collectionId, 1, false);
1040     }
1041 
1042     function mintMany(
1043         address _to,
1044         uint256 _collectionId,
1045         uint256 _membershipId,
1046         uint256 _amount
1047     ) public payable {
1048         checkMint(
1049             msg.sender,
1050             _collectionId,
1051             _membershipId,
1052             msg.value,
1053             _amount,
1054             true
1055         );
1056         updateMintState(_collectionId, _membershipId, _amount);
1057         _mintMany(_to, _collectionId, _amount);
1058         splitFunds(msg.sender, _collectionId, _amount, true);
1059     }
1060 
1061     function mintManyGen(
1062         address _to,
1063         uint256 _collectionId,
1064         uint256 _membershipId,
1065         uint256 _amount
1066     ) public {
1067         bool _genAllowed = _genArtInterface.genAllowed();
1068         require(_genAllowed, "Mint with $GENART not allowed");
1069         uint256 balance = _genArtInterface.balanceOf(msg.sender);
1070         checkMint(
1071             msg.sender,
1072             _collectionId,
1073             _membershipId,
1074             balance,
1075             _amount,
1076             false
1077         );
1078         updateMintState(_collectionId, _membershipId, _amount);
1079         _mintMany(_to, _collectionId, _amount);
1080         splitFunds(msg.sender, _collectionId, _amount, false);
1081     }
1082 
1083     function _mintMany(
1084         address _to,
1085         uint256 _collectionId,
1086         uint256 _amount
1087     ) internal virtual {
1088         for (uint256 i = 0; i < _amount; i++) {
1089             _mintOne(_to, _collectionId);
1090         }
1091     }
1092 
1093     function _mintOne(address _to, uint256 _collectionId) internal virtual {
1094         uint256 invocation = _collectionsMap[_collectionId].invocations + 1;
1095         uint256 _tokenId = _collectionId * 100000 + invocation;
1096         _collectionsMap[_collectionId].invocations = invocation;
1097 
1098         bytes32 hash = keccak256(
1099             abi.encodePacked(invocation, block.number, block.difficulty, _to)
1100         );
1101         _tokenIdToHashMap[_tokenId] = hash;
1102         _tokenIdToCollectionIdMap[_tokenId] = _collectionId;
1103 
1104         _safeMint(_to, _tokenId);
1105 
1106         emit Mint(_to, _collectionId, _tokenId, hash);
1107     }
1108 
1109     function splitFunds(
1110         address _sender,
1111         uint256 _collectionId,
1112         uint256 _amount,
1113         bool _isEthPayment
1114     ) internal virtual {
1115         uint256 value = _isEthPayment
1116             ? _collectionsMap[_collectionId].price.mul(_amount)
1117             : _collectionsMap[_collectionId].priceGen.mul(_amount);
1118         address _owner = owner();
1119         uint256 artistReward = (value *
1120             _collectionsMap[_collectionId].artistPercentage) / 100;
1121         if (_isEthPayment) {
1122             payable(_collectionsMap[_collectionId].artist).transfer(
1123                 artistReward
1124             );
1125         } else {
1126             _genArtInterface.transferFrom(
1127                 _sender,
1128                 _owner,
1129                 value - artistReward
1130             );
1131             _genArtInterface.transferFrom(
1132                 _sender,
1133                 _collectionsMap[_collectionId].artist,
1134                 artistReward
1135             );
1136         }
1137     }
1138 
1139     function burn(uint256 _tokenId) public {
1140         _burn(_tokenId);
1141     }
1142 
1143     function getAllowedMintForMembership(
1144         uint256 _collectionId,
1145         uint256 _membershipId
1146     ) public view returns (uint256) {
1147         uint256 maxMint = _genArtInterface.getMaxMintForMembership(
1148             _membershipId
1149         );
1150         return maxMint - _collectionsMintMap[_collectionId][_membershipId];
1151     }
1152 
1153     function updateMintState(
1154         uint256 _collectionId,
1155         uint256 _membershipId,
1156         uint256 _amount
1157     ) internal virtual {
1158         _collectionsMintMap[_collectionId][_membershipId] =
1159             _collectionsMintMap[_collectionId][_membershipId] +
1160             _amount;
1161     }
1162 
1163     function updateArtistAddress(uint256 _collectionId, address _artist)
1164         public
1165         onlyArtist(_collectionId)
1166     {
1167         _collectionsMap[_collectionId].artist = _artist;
1168     }
1169 
1170     function updateMaxInvocations(
1171         uint256 _collectionId,
1172         uint256 _maxInvocations
1173     ) public onlyOwner {
1174         _collectionsMap[_collectionId].maxInvocations = _maxInvocations;
1175     }
1176 
1177     function updateScript(uint256 _collectionId, string memory _script)
1178         public
1179         onlyOwner
1180     {
1181         _collectionsMap[_collectionId].script = _script;
1182     }
1183 
1184     function upgradeGenArtInterfaceContract(address _genArtInterfaceAddress)
1185         public
1186         onlyOwner
1187     {
1188         _genArtInterface = IGenArtInterface(_genArtInterfaceAddress);
1189     }
1190 
1191     function updatePrice(
1192         uint256 _collectionId,
1193         uint256 _price,
1194         uint256 _priceGen
1195     ) public onlyOwner {
1196         _collectionsMap[_collectionId].price = _price;
1197         _collectionsMap[_collectionId].priceGen = _priceGen;
1198     }
1199 
1200     function getCollectionInfo(uint256 _collectionId)
1201         public
1202         view
1203         returns (
1204             uint256 invocations,
1205             uint256 maxInvocations,
1206             string memory script,
1207             uint256 price,
1208             uint256 priceGen,
1209             address artist,
1210             uint256 artistPercentage
1211         )
1212     {
1213         require(
1214             _collectionsMap[_collectionId].tier != 0,
1215             "GenArtCollection: invalid collection id"
1216         );
1217 
1218         return (
1219             _collectionsMap[_collectionId].invocations,
1220             _collectionsMap[_collectionId].maxInvocations,
1221             _collectionsMap[_collectionId].script,
1222             _collectionsMap[_collectionId].price,
1223             _collectionsMap[_collectionId].priceGen,
1224             _collectionsMap[_collectionId].artist,
1225             _collectionsMap[_collectionId].artistPercentage
1226         );
1227     }
1228 
1229     function getTokenInfo(uint256 _tokenId)
1230         public
1231         view
1232         returns (
1233             uint256,
1234             uint256,
1235             address,
1236             bytes32
1237         )
1238     {
1239         _exists(_tokenId);
1240         bytes32 hash = _tokenIdToHashMap[_tokenId];
1241         uint256 _collectionId = _tokenIdToCollectionIdMap[_tokenId];
1242         address owner = GenArtCollection.ownerOf(_tokenId);
1243 
1244         return (_tokenId, _collectionId, owner, hash);
1245     }
1246 
1247     function getTokensByOwner(address _owner)
1248         public
1249         view
1250         returns (uint256[] memory)
1251     {
1252         uint256 tokenCount = balanceOf(_owner);
1253         uint256[] memory tokenIds = new uint256[](tokenCount);
1254         for (uint256 i; i < tokenCount; i++) {
1255             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1256         }
1257 
1258         return tokenIds;
1259     }
1260 
1261     /**
1262      * @dev See {IERC165-supportsInterface}.
1263      */
1264     function supportsInterface(bytes4 interfaceId)
1265         public
1266         view
1267         virtual
1268         override(ERC165, IERC165)
1269         returns (bool)
1270     {
1271         return
1272             interfaceId == type(IERC721).interfaceId ||
1273             interfaceId == type(IERC721Metadata).interfaceId ||
1274             interfaceId == type(IERC721Enumerable).interfaceId ||
1275             super.supportsInterface(interfaceId);
1276     }
1277 
1278     /**
1279      * @dev See {IERC721-balanceOf}.
1280      */
1281     function balanceOf(address owner)
1282         public
1283         view
1284         virtual
1285         override
1286         returns (uint256)
1287     {
1288         require(
1289             owner != address(0),
1290             "ERC721: balance query for the zero address"
1291         );
1292         return _balances[owner];
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-ownerOf}.
1297      */
1298     function ownerOf(uint256 tokenId)
1299         public
1300         view
1301         virtual
1302         override
1303         returns (address)
1304     {
1305         address owner = _owners[tokenId];
1306         require(
1307             owner != address(0),
1308             "ERC721: owner query for nonexistent token"
1309         );
1310         return owner;
1311     }
1312 
1313     /**
1314      * @dev See {IERC721Metadata-name}.
1315      */
1316     function name() public view virtual override returns (string memory) {
1317         return _name;
1318     }
1319 
1320     /**
1321      * @dev See {IERC721Metadata-symbol}.
1322      */
1323     function symbol() public view virtual override returns (string memory) {
1324         return _symbol;
1325     }
1326 
1327     /**
1328      * @dev See {IERC721Metadata-tokenURI}.
1329      */
1330     function tokenURI(uint256 tokenId)
1331         public
1332         view
1333         virtual
1334         override
1335         returns (string memory)
1336     {
1337         require(
1338             _exists(tokenId),
1339             "ERC721Metadata: URI query for nonexistent token"
1340         );
1341 
1342         string memory baseURI_ = baseURI();
1343         return
1344             bytes(baseURI_).length > 0
1345                 ? string(abi.encodePacked(baseURI_, tokenId.toString()))
1346                 : "";
1347     }
1348 
1349     /**
1350      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1351      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1352      * by default, can be overriden in child contracts.
1353      */
1354     function baseURI() internal view virtual returns (string memory) {
1355         return _baseURI;
1356     }
1357 
1358     /**
1359      * @dev Internal function to set the base URI for all token IDs. It is
1360      * automatically added as a prefix to the value returned in {tokenURI},
1361      * or to the token ID if {tokenURI} is empty.
1362      */
1363     function setBaseURI(string memory baseURI_) public onlyOwner {
1364         _baseURI = baseURI_;
1365     }
1366 
1367     /**
1368      * @dev See {IERC721-approve}.
1369      */
1370     function approve(address to, uint256 tokenId) public virtual override {
1371         address owner = GenArtCollection.ownerOf(tokenId);
1372         require(to != owner, "ERC721: approval to current owner");
1373 
1374         require(
1375             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1376             "ERC721: approve caller is not owner nor approved for all"
1377         );
1378 
1379         _approve(to, tokenId);
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-getApproved}.
1384      */
1385     function getApproved(uint256 tokenId)
1386         public
1387         view
1388         virtual
1389         override
1390         returns (address)
1391     {
1392         require(
1393             _exists(tokenId),
1394             "ERC721: approved query for nonexistent token"
1395         );
1396 
1397         return _tokenApprovals[tokenId];
1398     }
1399 
1400     /**
1401      * @dev See {IERC721-setApprovalForAll}.
1402      */
1403     function setApprovalForAll(address operator, bool approved)
1404         public
1405         virtual
1406         override
1407     {
1408         require(operator != _msgSender(), "ERC721: approve to caller");
1409 
1410         _operatorApprovals[_msgSender()][operator] = approved;
1411         emit ApprovalForAll(_msgSender(), operator, approved);
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-isApprovedForAll}.
1416      */
1417     function isApprovedForAll(address owner, address operator)
1418         public
1419         view
1420         virtual
1421         override
1422         returns (bool)
1423     {
1424         return _operatorApprovals[owner][operator];
1425     }
1426 
1427     /**
1428      * @dev See {IERC721-transferFrom}.
1429      */
1430     function transferFrom(
1431         address from,
1432         address to,
1433         uint256 tokenId
1434     ) public virtual override {
1435         //solhint-disable-next-line max-line-length
1436         require(
1437             _isApprovedOrOwner(_msgSender(), tokenId),
1438             "ERC721: transfer caller is not owner nor approved"
1439         );
1440 
1441         _transfer(from, to, tokenId);
1442     }
1443 
1444     /**
1445      * @dev See {IERC721-safeTransferFrom}.
1446      */
1447     function safeTransferFrom(
1448         address from,
1449         address to,
1450         uint256 tokenId
1451     ) public virtual override {
1452         safeTransferFrom(from, to, tokenId, "");
1453     }
1454 
1455     /**
1456      * @dev See {IERC721-safeTransferFrom}.
1457      */
1458     function safeTransferFrom(
1459         address from,
1460         address to,
1461         uint256 tokenId,
1462         bytes memory _data
1463     ) public virtual override {
1464         require(
1465             _isApprovedOrOwner(_msgSender(), tokenId),
1466             "ERC721: transfer caller is not owner nor approved"
1467         );
1468         _safeTransfer(from, to, tokenId, _data);
1469     }
1470 
1471     /**
1472      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1473      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1474      *
1475      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1476      *
1477      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1478      * implement alternative mechanisms to perform token transfer, such as signature-based.
1479      *
1480      * Requirements:
1481      *
1482      * - `from` cannot be the zero address.
1483      * - `to` cannot be the zero address.
1484      * - `tokenId` token must exist and be owned by `from`.
1485      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function _safeTransfer(
1490         address from,
1491         address to,
1492         uint256 tokenId,
1493         bytes memory _data
1494     ) internal virtual {
1495         _transfer(from, to, tokenId);
1496         require(
1497             _checkOnERC721Received(from, to, tokenId, _data),
1498             "ERC721: transfer to non ERC721Receiver implementer"
1499         );
1500     }
1501 
1502     /**
1503      * @dev Returns whether `tokenId` exists.
1504      *
1505      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1506      *
1507      * Tokens start existing when they are minted (`_mint`),
1508      * and stop existing when they are burned (`_burn`).
1509      */
1510     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1511         return _owners[tokenId] != address(0);
1512     }
1513 
1514     /**
1515      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1516      *
1517      * Requirements:
1518      *
1519      * - `tokenId` must exist.
1520      */
1521     function _isApprovedOrOwner(address spender, uint256 tokenId)
1522         internal
1523         view
1524         virtual
1525         returns (bool)
1526     {
1527         require(
1528             _exists(tokenId),
1529             "ERC721: operator query for nonexistent token"
1530         );
1531         address owner = GenArtCollection.ownerOf(tokenId);
1532         return (spender == owner ||
1533             getApproved(tokenId) == spender ||
1534             isApprovedForAll(owner, spender));
1535     }
1536 
1537     /**
1538      * @dev Safely mints `tokenId` and transfers it to `to`.
1539      *
1540      * Requirements:
1541      *
1542      * - `tokenId` must not exist.
1543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1544      *
1545      * Emits a {Transfer} event.
1546      */
1547     function _safeMint(address to, uint256 tokenId) internal virtual {
1548         _safeMint(to, tokenId, "");
1549     }
1550 
1551     /**
1552      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1553      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1554      */
1555     function _safeMint(
1556         address to,
1557         uint256 tokenId,
1558         bytes memory _data
1559     ) internal virtual {
1560         _mint(to, tokenId);
1561         require(
1562             _checkOnERC721Received(address(0), to, tokenId, _data),
1563             "ERC721: transfer to non ERC721Receiver implementer"
1564         );
1565     }
1566 
1567     /**
1568      * @dev Mints `tokenId` and transfers it to `to`.
1569      *
1570      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1571      *
1572      * Requirements:
1573      *
1574      * - `tokenId` must not exist.
1575      * - `to` cannot be the zero address.
1576      *
1577      * Emits a {Transfer} event.
1578      */
1579     function _mint(address to, uint256 tokenId) internal virtual {
1580         require(to != address(0), "ERC721: mint to the zero address");
1581         require(!_exists(tokenId), "ERC721: token already minted");
1582 
1583         _beforeTokenTransfer(address(0), to, tokenId);
1584 
1585         _balances[to] += 1;
1586         _owners[tokenId] = to;
1587 
1588         emit Transfer(address(0), to, tokenId);
1589     }
1590 
1591     /**
1592      * @dev Destroys `tokenId`.
1593      * The approval is cleared when the token is burned.
1594      *
1595      * Requirements:
1596      *
1597      * - `tokenId` must exist.
1598      *
1599      * Emits a {Transfer} event.
1600      */
1601     function _burn(uint256 tokenId) internal virtual {
1602         address owner = GenArtCollection.ownerOf(tokenId);
1603         require(
1604             _msgSender() == owner,
1605             "GenArtCollection: only token owner can burn"
1606         );
1607         _beforeTokenTransfer(owner, address(0), tokenId);
1608         // Clear approvals
1609         _approve(address(0), tokenId);
1610 
1611         _balances[owner] -= 1;
1612         delete _owners[tokenId];
1613 
1614         emit Transfer(owner, address(0), tokenId);
1615     }
1616 
1617     /**
1618      * @dev Transfers `tokenId` from `from` to `to`.
1619      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1620      *
1621      * Requirements:
1622      *
1623      * - `to` cannot be the zero address.
1624      * - `tokenId` token must be owned by `from`.
1625      *
1626      * Emits a {Transfer} event.
1627      */
1628     function _transfer(
1629         address from,
1630         address to,
1631         uint256 tokenId
1632     ) internal virtual {
1633         require(
1634             GenArtCollection.ownerOf(tokenId) == from,
1635             "ERC721: transfer of token that is not own"
1636         );
1637         require(to != address(0), "ERC721: transfer to the zero address");
1638 
1639         _beforeTokenTransfer(from, to, tokenId);
1640 
1641         // Clear approvals from the previous owner
1642         _approve(address(0), tokenId);
1643 
1644         _balances[from] -= 1;
1645         _balances[to] += 1;
1646         _owners[tokenId] = to;
1647 
1648         emit Transfer(from, to, tokenId);
1649     }
1650 
1651     /**
1652      * @dev Approve `to` to operate on `tokenId`
1653      *
1654      * Emits a {Approval} event.
1655      */
1656     function _approve(address to, uint256 tokenId) internal virtual {
1657         _tokenApprovals[tokenId] = to;
1658         emit Approval(GenArtCollection.ownerOf(tokenId), to, tokenId);
1659     }
1660 
1661     /**
1662      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1663      * The call is not executed if the target address is not a contract.
1664      *
1665      * @param from address representing the previous owner of the given token ID
1666      * @param to target address that will receive the tokens
1667      * @param tokenId uint256 ID of the token to be transferred
1668      * @param _data bytes optional data to send along with the call
1669      * @return bool whether the call correctly returned the expected magic value
1670      */
1671     function _checkOnERC721Received(
1672         address from,
1673         address to,
1674         uint256 tokenId,
1675         bytes memory _data
1676     ) private returns (bool) {
1677         if (to.isContract()) {
1678             try
1679                 IERC721Receiver(to).onERC721Received(
1680                     _msgSender(),
1681                     from,
1682                     tokenId,
1683                     _data
1684                 )
1685             returns (bytes4 retval) {
1686                 return retval == IERC721Receiver.onERC721Received.selector;
1687             } catch (bytes memory reason) {
1688                 if (reason.length == 0) {
1689                     revert(
1690                         "ERC721: transfer to non ERC721Receiver implementer"
1691                     );
1692                 } else {
1693                     assembly {
1694                         revert(add(32, reason), mload(reason))
1695                     }
1696                 }
1697             }
1698         } else {
1699             return true;
1700         }
1701     }
1702 
1703     /**
1704      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1705      */
1706     function tokenOfOwnerByIndex(address owner, uint256 index)
1707         public
1708         view
1709         virtual
1710         override
1711         returns (uint256)
1712     {
1713         require(
1714             index < GenArtCollection.balanceOf(owner),
1715             "ERC721Enumerable: owner index out of bounds"
1716         );
1717         return _ownedTokens[owner][index];
1718     }
1719 
1720     /**
1721      * @dev See {IERC721Enumerable-totalSupply}.
1722      */
1723     function totalSupply() public view virtual override returns (uint256) {
1724         return _allTokens.length;
1725     }
1726 
1727     /**
1728      * @dev See {IERC721Enumerable-tokenByIndex}.
1729      */
1730     function tokenByIndex(uint256 index)
1731         public
1732         view
1733         virtual
1734         override
1735         returns (uint256)
1736     {
1737         require(
1738             index < GenArtCollection.totalSupply(),
1739             "ERC721Enumerable: global index out of bounds"
1740         );
1741         return _allTokens[index];
1742     }
1743 
1744     /**
1745      * @dev Hook that is called before any token transfer. This includes minting
1746      * and burning.
1747      *
1748      * Calling conditions:
1749      *
1750      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1751      * transferred to `to`.
1752      * - When `from` is zero, `tokenId` will be minted for `to`.
1753      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1754      * - `from` cannot be the zero address.
1755      * - `to` cannot be the zero address.
1756      *
1757      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1758      */
1759     function _beforeTokenTransfer(
1760         address from,
1761         address to,
1762         uint256 tokenId
1763     ) internal virtual {
1764         if (from == address(0)) {
1765             _addTokenToAllTokensEnumeration(tokenId);
1766         } else if (from != to) {
1767             _removeTokenFromOwnerEnumeration(from, tokenId);
1768         }
1769         if (to == address(0)) {
1770             _removeTokenFromAllTokensEnumeration(tokenId);
1771         } else if (to != from) {
1772             _addTokenToOwnerEnumeration(to, tokenId);
1773         }
1774     }
1775 
1776     /**
1777      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1778      * @param to address representing the new owner of the given token ID
1779      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1780      */
1781     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1782         uint256 length = GenArtCollection.balanceOf(to);
1783         _ownedTokens[to][length] = tokenId;
1784         _ownedTokensIndex[tokenId] = length;
1785     }
1786 
1787     /**
1788      * @dev Private function to add a token to this extension's token tracking data structures.
1789      * @param tokenId uint256 ID of the token to be added to the tokens list
1790      */
1791     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1792         _allTokensIndex[tokenId] = _allTokens.length;
1793         _allTokens.push(tokenId);
1794     }
1795 
1796     /**
1797      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1798      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1799      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1800      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1801      * @param from address representing the previous owner of the given token ID
1802      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1803      */
1804     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1805         private
1806     {
1807         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1808         // then delete the last slot (swap and pop).
1809 
1810         uint256 lastTokenIndex = GenArtCollection.balanceOf(from) - 1;
1811         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1812 
1813         // When the token to delete is the last token, the swap operation is unnecessary
1814         if (tokenIndex != lastTokenIndex) {
1815             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1816 
1817             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1818             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1819         }
1820 
1821         // This also deletes the contents at the last position of the array
1822         delete _ownedTokensIndex[tokenId];
1823         delete _ownedTokens[from][lastTokenIndex];
1824     }
1825 
1826     /**
1827      * @dev Private function to remove a token from this extension's token tracking data structures.
1828      * This has O(1) time complexity, but alters the order of the _allTokens array.
1829      * @param tokenId uint256 ID of the token to be removed from the tokens list
1830      */
1831     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1832         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1833         // then delete the last slot (swap and pop).
1834 
1835         uint256 lastTokenIndex = _allTokens.length - 1;
1836         uint256 tokenIndex = _allTokensIndex[tokenId];
1837 
1838         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1839         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1840         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1841         uint256 lastTokenId = _allTokens[lastTokenIndex];
1842 
1843         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1844         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1845 
1846         // This also deletes the contents at the last position of the array
1847         delete _allTokensIndex[tokenId];
1848         _allTokens.pop();
1849     }
1850 }