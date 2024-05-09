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
19 interface IGenArtInterfaceV2 {
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
41     function getRandomChoice(uint256[] memory choices, uint256 seed)
42         external
43         view
44         returns (uint256);
45 
46     function balanceOf(address _owner) external view returns (uint256);
47 
48     function ownerOf(uint256 _membershipId) external view returns (address);
49 }
50 
51 /**
52  * @dev Provides information about the current execution context, including the
53  * sender of the transaction and its data. While these are generally available
54  * via msg.sender and msg.data, they should not be accessed in such a direct
55  * manner, since when dealing with meta-transactions the account sending and
56  * paying for execution may not be the actual sender (as far as an application
57  * is concerned).
58  *
59  * This contract is only required for intermediate, library-like contracts.
60  */
61 abstract contract Context {
62     function _msgSender() internal view virtual returns (address) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view virtual returns (bytes calldata) {
67         return msg.data;
68     }
69 }
70 
71 /**
72  * @dev Contract module which provides a basic access control mechanism, where
73  * there is an account (an owner) that can be granted exclusive access to
74  * specific functions.
75  *
76  * By default, the owner account will be the one that deploys the contract. This
77  * can later be changed with {transferOwnership}.
78  *
79  * This module is used through inheritance. It will make available the modifier
80  * `onlyOwner`, which can be applied to your functions to restrict their use to
81  * the owner.
82  */
83 abstract contract Ownable is Context {
84     address private _owner;
85 
86     event OwnershipTransferred(
87         address indexed previousOwner,
88         address indexed newOwner
89     );
90 
91     /**
92      * @dev Initializes the contract setting the deployer as the initial owner.
93      */
94     constructor() {
95         _setOwner(_msgSender());
96     }
97 
98     /**
99      * @dev Returns the address of the current owner.
100      */
101     function owner() public view virtual returns (address) {
102         return _owner;
103     }
104 
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108     modifier onlyOwner() {
109         require(owner() == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Can only be called by the current owner.
116      */
117     function transferOwnership(address newOwner) public virtual onlyOwner {
118         require(
119             newOwner != address(0),
120             "Ownable: new owner is the zero address"
121         );
122         _setOwner(newOwner);
123     }
124 
125     function _setOwner(address newOwner) private {
126         address oldOwner = _owner;
127         _owner = newOwner;
128         emit OwnershipTransferred(oldOwner, newOwner);
129     }
130 }
131 
132 /**
133  * @title Counters
134  * @author Matt Condon (@shrugs)
135  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
136  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
137  *
138  * Include with `using Counters for Counters.Counter;`
139  */
140 library Counters {
141     struct Counter {
142         // This variable should never be directly accessed by users of the library: interactions must be restricted to
143         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
144         // this feature: see https://github.com/ethereum/solidity/issues/4637
145         uint256 _value; // default: 0
146     }
147 
148     function current(Counter storage counter) internal view returns (uint256) {
149         return counter._value;
150     }
151 
152     function increment(Counter storage counter) internal {
153         unchecked {
154             counter._value += 1;
155         }
156     }
157 
158     function decrement(Counter storage counter) internal {
159         uint256 value = counter._value;
160         require(value > 0, "Counter: decrement overflow");
161         unchecked {
162             counter._value = value - 1;
163         }
164     }
165 
166     function reset(Counter storage counter) internal {
167         counter._value = 10000;
168     }
169 }
170 
171 /**
172  * @dev String operations.
173  */
174 library Strings {
175     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
179      */
180     function toString(uint256 value) internal pure returns (string memory) {
181         // Inspired by OraclizeAPI's implementation - MIT licence
182         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
183 
184         if (value == 0) {
185             return "0";
186         }
187         uint256 temp = value;
188         uint256 digits;
189         while (temp != 0) {
190             digits++;
191             temp /= 10;
192         }
193         bytes memory buffer = new bytes(digits);
194         while (value != 0) {
195             digits -= 1;
196             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
197             value /= 10;
198         }
199         return string(buffer);
200     }
201 }
202 
203 /**
204  * @dev Collection of functions related to the address type
205  */
206 library Address {
207     /**
208      * @dev Returns true if `account` is a contract.
209      *
210      * [IMPORTANT]
211      * ====
212      * It is unsafe to assume that an address for which this function returns
213      * false is an externally-owned account (EOA) and not a contract.
214      *
215      * Among others, `isContract` will return false for the following
216      * types of addresses:
217      *
218      *  - an externally-owned account
219      *  - a contract in construction
220      *  - an address where a contract will be created
221      *  - an address where a contract lived, but was destroyed
222      * ====
223      */
224     function isContract(address account) internal view returns (bool) {
225         // This method relies on extcodesize, which returns 0 for contracts in
226         // construction, since the code is only stored at the end of the
227         // constructor execution.
228 
229         uint256 size;
230         assembly {
231             size := extcodesize(account)
232         }
233         return size > 0;
234     }
235 }
236 
237 // CAUTION
238 // This version of SafeMath should only be used with Solidity 0.8 or later,
239 // because it relies on the compiler's built in overflow checks.
240 
241 /**
242  * @dev Wrappers over Solidity's arithmetic operations.
243  *
244  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
245  * now has built in overflow checking.
246  */
247 library SafeMath {
248     /**
249      * @dev Returns the addition of two unsigned integers, with an overflow flag.
250      *
251      * _Available since v3.4._
252      */
253     function tryAdd(uint256 a, uint256 b)
254         internal
255         pure
256         returns (bool, uint256)
257     {
258         unchecked {
259             uint256 c = a + b;
260             if (c < a) return (false, 0);
261             return (true, c);
262         }
263     }
264 
265     /**
266      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
267      *
268      * _Available since v3.4._
269      */
270     function trySub(uint256 a, uint256 b)
271         internal
272         pure
273         returns (bool, uint256)
274     {
275         unchecked {
276             if (b > a) return (false, 0);
277             return (true, a - b);
278         }
279     }
280 
281     /**
282      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
283      *
284      * _Available since v3.4._
285      */
286     function tryMul(uint256 a, uint256 b)
287         internal
288         pure
289         returns (bool, uint256)
290     {
291         unchecked {
292             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
293             // benefit is lost if 'b' is also tested.
294             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
295             if (a == 0) return (true, 0);
296             uint256 c = a * b;
297             if (c / a != b) return (false, 0);
298             return (true, c);
299         }
300     }
301 
302     /**
303      * @dev Returns the division of two unsigned integers, with a division by zero flag.
304      *
305      * _Available since v3.4._
306      */
307     function tryDiv(uint256 a, uint256 b)
308         internal
309         pure
310         returns (bool, uint256)
311     {
312         unchecked {
313             if (b == 0) return (false, 0);
314             return (true, a / b);
315         }
316     }
317 
318     /**
319      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
320      *
321      * _Available since v3.4._
322      */
323     function tryMod(uint256 a, uint256 b)
324         internal
325         pure
326         returns (bool, uint256)
327     {
328         unchecked {
329             if (b == 0) return (false, 0);
330             return (true, a % b);
331         }
332     }
333 
334     /**
335      * @dev Returns the addition of two unsigned integers, reverting on
336      * overflow.
337      *
338      * Counterpart to Solidity's `+` operator.
339      *
340      * Requirements:
341      *
342      * - Addition cannot overflow.
343      */
344     function add(uint256 a, uint256 b) internal pure returns (uint256) {
345         return a + b;
346     }
347 
348     /**
349      * @dev Returns the subtraction of two unsigned integers, reverting on
350      * overflow (when the result is negative).
351      *
352      * Counterpart to Solidity's `-` operator.
353      *
354      * Requirements:
355      *
356      * - Subtraction cannot overflow.
357      */
358     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
359         return a - b;
360     }
361 
362     /**
363      * @dev Returns the multiplication of two unsigned integers, reverting on
364      * overflow.
365      *
366      * Counterpart to Solidity's `*` operator.
367      *
368      * Requirements:
369      *
370      * - Multiplication cannot overflow.
371      */
372     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
373         return a * b;
374     }
375 
376     /**
377      * @dev Returns the integer division of two unsigned integers, reverting on
378      * division by zero. The result is rounded towards zero.
379      *
380      * Counterpart to Solidity's `/` operator.
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function div(uint256 a, uint256 b) internal pure returns (uint256) {
387         return a / b;
388     }
389 
390     /**
391      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
392      * reverting when dividing by zero.
393      *
394      * Counterpart to Solidity's `%` operator. This function uses a `revert`
395      * opcode (which leaves remaining gas untouched) while Solidity uses an
396      * invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      *
400      * - The divisor cannot be zero.
401      */
402     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
403         return a % b;
404     }
405 
406     /**
407      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
408      * overflow (when the result is negative).
409      *
410      * CAUTION: This function is deprecated because it requires allocating memory for the error
411      * message unnecessarily. For custom revert reasons use {trySub}.
412      *
413      * Counterpart to Solidity's `-` operator.
414      *
415      * Requirements:
416      *
417      * - Subtraction cannot overflow.
418      */
419     function sub(
420         uint256 a,
421         uint256 b,
422         string memory errorMessage
423     ) internal pure returns (uint256) {
424         unchecked {
425             require(b <= a, errorMessage);
426             return a - b;
427         }
428     }
429 
430     /**
431      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
432      * division by zero. The result is rounded towards zero.
433      *
434      * Counterpart to Solidity's `/` operator. Note: this function uses a
435      * `revert` opcode (which leaves remaining gas untouched) while Solidity
436      * uses an invalid opcode to revert (consuming all remaining gas).
437      *
438      * Requirements:
439      *
440      * - The divisor cannot be zero.
441      */
442     function div(
443         uint256 a,
444         uint256 b,
445         string memory errorMessage
446     ) internal pure returns (uint256) {
447         unchecked {
448             require(b > 0, errorMessage);
449             return a / b;
450         }
451     }
452 
453     /**
454      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
455      * reverting with custom message when dividing by zero.
456      *
457      * CAUTION: This function is deprecated because it requires allocating memory for the error
458      * message unnecessarily. For custom revert reasons use {tryMod}.
459      *
460      * Counterpart to Solidity's `%` operator. This function uses a `revert`
461      * opcode (which leaves remaining gas untouched) while Solidity uses an
462      * invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function mod(
469         uint256 a,
470         uint256 b,
471         string memory errorMessage
472     ) internal pure returns (uint256) {
473         unchecked {
474             require(b > 0, errorMessage);
475             return a % b;
476         }
477     }
478 }
479 
480 /**
481  * @dev Interface of the ERC20 standard as defined in the EIP.
482  */
483 interface IERC20 {
484     /**
485      * @dev Returns the amount of tokens in existence.
486      */
487     function totalSupply() external view returns (uint256);
488 
489     /**
490      * @dev Returns the amount of tokens owned by `account`.
491      */
492     function balanceOf(address account) external view returns (uint256);
493 
494     /**
495      * @dev Moves `amount` tokens from the caller's account to `recipient`.
496      *
497      * Returns a boolean value indicating whether the operation succeeded.
498      *
499      * Emits a {Transfer} event.
500      */
501     function transfer(address recipient, uint256 amount)
502         external
503         returns (bool);
504 
505     /**
506      * @dev Returns the remaining number of tokens that `spender` will be
507      * allowed to spend on behalf of `owner` through {transferFrom}. This is
508      * zero by default.
509      *
510      * This value changes when {approve} or {transferFrom} are called.
511      */
512     function allowance(address owner, address spender)
513         external
514         view
515         returns (uint256);
516 
517     /**
518      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
519      *
520      * Returns a boolean value indicating whether the operation succeeded.
521      *
522      * IMPORTANT: Beware that changing an allowance with this method brings the risk
523      * that someone may use both the old and the new allowance by unfortunate
524      * transaction ordering. One possible solution to mitigate this race
525      * condition is to first reduce the spender's allowance to 0 and set the
526      * desired value afterwards:
527      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
528      *
529      * Emits an {Approval} event.
530      */
531     function approve(address spender, uint256 amount) external returns (bool);
532 
533     /**
534      * @dev Moves `amount` tokens from `sender` to `recipient` using the
535      * allowance mechanism. `amount` is then deducted from the caller's
536      * allowance.
537      *
538      * Returns a boolean value indicating whether the operation succeeded.
539      *
540      * Emits a {Transfer} event.
541      */
542     function transferFrom(
543         address sender,
544         address recipient,
545         uint256 amount
546     ) external returns (bool);
547 
548     /**
549      * @dev Emitted when `value` tokens are moved from one account (`from`) to
550      * another (`to`).
551      *
552      * Note that `value` may be zero.
553      */
554     event Transfer(address indexed from, address indexed to, uint256 value);
555 
556     /**
557      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
558      * a call to {approve}. `value` is the new allowance.
559      */
560     event Approval(
561         address indexed owner,
562         address indexed spender,
563         uint256 value
564     );
565 }
566 
567 /**
568  * @title ERC721 token receiver interface
569  * @dev Interface for any contract that wants to support safeTransfers
570  * from ERC721 asset contracts.
571  */
572 interface IERC721Receiver {
573     /**
574      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
575      * by `operator` from `from`, this function is called.
576      *
577      * It must return its Solidity selector to confirm the token transfer.
578      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
579      *
580      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
581      */
582     function onERC721Received(
583         address operator,
584         address from,
585         uint256 tokenId,
586         bytes calldata data
587     ) external returns (bytes4);
588 }
589 
590 /**
591  * @dev Interface of the ERC165 standard, as defined in the
592  * https://eips.ethereum.org/EIPS/eip-165[EIP].
593  *
594  * Implementers can declare support of contract interfaces, which can then be
595  * queried by others ({ERC165Checker}).
596  *
597  * For an implementation, see {ERC165}.
598  */
599 interface IERC165 {
600     /**
601      * @dev Returns true if this contract implements the interface defined by
602      * `interfaceId`. See the corresponding
603      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
604      * to learn more about how these ids are created.
605      *
606      * This function call must use less than 30 000 gas.
607      */
608     function supportsInterface(bytes4 interfaceId) external view returns (bool);
609 }
610 
611 /**
612  * @dev Implementation of the {IERC165} interface.
613  *
614  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
615  * for the additional interface id that will be supported. For example:
616  *
617  * ```solidity
618  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
619  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
620  * }
621  * ```
622  *
623  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
624  */
625 abstract contract ERC165 is IERC165 {
626     /**
627      * @dev See {IERC165-supportsInterface}.
628      */
629     function supportsInterface(bytes4 interfaceId)
630         public
631         view
632         virtual
633         override
634         returns (bool)
635     {
636         return interfaceId == type(IERC165).interfaceId;
637     }
638 }
639 
640 /**
641  * @dev Required interface of an ERC721 compliant contract.
642  */
643 interface IERC721 is IERC165 {
644     /**
645      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
646      */
647     event Transfer(
648         address indexed from,
649         address indexed to,
650         uint256 indexed tokenId
651     );
652 
653     /**
654      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
655      */
656     event Approval(
657         address indexed owner,
658         address indexed approved,
659         uint256 indexed tokenId
660     );
661 
662     /**
663      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
664      */
665     event ApprovalForAll(
666         address indexed owner,
667         address indexed operator,
668         bool approved
669     );
670 
671     /**
672      * @dev Returns the number of tokens in ``owner``'s account.
673      */
674     function balanceOf(address owner) external view returns (uint256 balance);
675 
676     /**
677      * @dev Returns the owner of the `tokenId` token.
678      *
679      * Requirements:
680      *
681      * - `tokenId` must exist.
682      */
683     function ownerOf(uint256 tokenId) external view returns (address owner);
684 
685     /**
686      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
687      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
688      *
689      * Requirements:
690      *
691      * - `from` cannot be the zero address.
692      * - `to` cannot be the zero address.
693      * - `tokenId` token must exist and be owned by `from`.
694      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
696      *
697      * Emits a {Transfer} event.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId
703     ) external;
704 
705     /**
706      * @dev Transfers `tokenId` token from `from` to `to`.
707      *
708      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
709      *
710      * Requirements:
711      *
712      * - `from` cannot be the zero address.
713      * - `to` cannot be the zero address.
714      * - `tokenId` token must be owned by `from`.
715      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
716      *
717      * Emits a {Transfer} event.
718      */
719     function transferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) external;
724 
725     /**
726      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
727      * The approval is cleared when the token is transferred.
728      *
729      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
730      *
731      * Requirements:
732      *
733      * - The caller must own the token or be an approved operator.
734      * - `tokenId` must exist.
735      *
736      * Emits an {Approval} event.
737      */
738     function approve(address to, uint256 tokenId) external;
739 
740     /**
741      * @dev Returns the account approved for `tokenId` token.
742      *
743      * Requirements:
744      *
745      * - `tokenId` must exist.
746      */
747     function getApproved(uint256 tokenId)
748         external
749         view
750         returns (address operator);
751 
752     /**
753      * @dev Approve or remove `operator` as an operator for the caller.
754      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
755      *
756      * Requirements:
757      *
758      * - The `operator` cannot be the caller.
759      *
760      * Emits an {ApprovalForAll} event.
761      */
762     function setApprovalForAll(address operator, bool _approved) external;
763 
764     /**
765      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
766      *
767      * See {setApprovalForAll}
768      */
769     function isApprovedForAll(address owner, address operator)
770         external
771         view
772         returns (bool);
773 
774     /**
775      * @dev Safely transfers `tokenId` token from `from` to `to`.
776      *
777      * Requirements:
778      *
779      * - `from` cannot be the zero address.
780      * - `to` cannot be the zero address.
781      * - `tokenId` token must exist and be owned by `from`.
782      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
783      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
784      *
785      * Emits a {Transfer} event.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes calldata data
792     ) external;
793 }
794 
795 /**
796  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
797  * @dev See https://eips.ethereum.org/EIPS/eip-721
798  */
799 interface IERC721Enumerable is IERC721 {
800     /**
801      * @dev Returns the total amount of tokens stored by the contract.
802      */
803     function totalSupply() external view returns (uint256);
804 
805     /**
806      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
807      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
808      */
809     function tokenOfOwnerByIndex(address owner, uint256 index)
810         external
811         view
812         returns (uint256 tokenId);
813 
814     /**
815      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
816      * Use along with {totalSupply} to enumerate all tokens.
817      */
818     function tokenByIndex(uint256 index) external view returns (uint256);
819 }
820 
821 /**
822  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
823  * @dev See https://eips.ethereum.org/EIPS/eip-721
824  */
825 interface IERC721Metadata is IERC721 {
826     /**
827      * @dev Returns the token collection name.
828      */
829     function name() external view returns (string memory);
830 
831     /**
832      * @dev Returns the token collection symbol.
833      */
834     function symbol() external view returns (string memory);
835 
836     /**
837      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
838      */
839     function tokenURI(uint256 tokenId) external view returns (string memory);
840 }
841 
842 /**
843  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
844  * the Metadata extension, but not including the Enumerable extension, which is available separately as
845  * {ERC721Enumerable}.
846  */
847 
848 /**
849  * GEN.ART Collection Drop Contract ERC721 Implementation
850  */
851 
852 contract GenArtCollectionDrop is
853     Context,
854     ERC165,
855     IERC721,
856     IERC721Metadata,
857     IERC721Enumerable,
858     Ownable
859 {
860     using Address for address;
861     using Strings for uint256;
862     using Counters for Counters.Counter;
863     using SafeMath for uint256;
864 
865     struct CollectionGroup {
866         uint256 tier;
867         uint256 price;
868         uint256 priceGen;
869         uint256[] collections;
870     }
871 
872     struct Collection {
873         uint256 group;
874         uint256 invocations;
875         uint256 maxInvocations;
876         string script;
877         string script_type;
878         uint256 artistPercentage;
879         address artist;
880     }
881 
882     event Mint(address to, uint256 collectionId, uint256 tokenId, bytes32 hash);
883     mapping(uint256 => Collection) private _collectionsMap;
884     mapping(uint256 => CollectionGroup) private _collectionGroupsMap;
885 
886     // Mapping collectionId to membershipId and total mints
887     mapping(uint256 => mapping(uint256 => uint256)) private _collectionsMintMap;
888 
889     mapping(uint256 => bytes32) private _tokenIdToHashMap;
890     mapping(uint256 => uint256) private _tokenIdToCollectionIdMap;
891     Counters.Counter private _collectionIdCounter;
892     IGenArtInterfaceV2 private _genArtInterface;
893     uint256 private nonce;
894     // Token name
895     string private _name;
896 
897     // Token symbol
898     string private _symbol;
899 
900     // Base URI
901     string private _baseURI;
902 
903     // Mapping from token ID to owner address
904     mapping(uint256 => address) private _owners;
905 
906     // Mapping owner address to token count
907     mapping(address => uint256) private _balances;
908 
909     // Mapping from token ID to approved address
910     mapping(uint256 => address) private _tokenApprovals;
911 
912     // Mapping from owner to operator approvals
913     mapping(address => mapping(address => bool)) private _operatorApprovals;
914 
915     // Mapping from owner to list of owned token IDs
916     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
917 
918     // Mapping from token ID to index of the owner tokens list
919     mapping(uint256 => uint256) private _ownedTokensIndex;
920 
921     // Array with all token ids, used for enumeration
922     uint256[] private _allTokens;
923 
924     // Mapping from token id to position in the allTokens array
925     mapping(uint256 => uint256) private _allTokensIndex;
926 
927     /**
928      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
929      */
930     constructor(
931         string memory name_,
932         string memory symbol_,
933         string memory uri_,
934         address genArtInterfaceAddress_
935     ) {
936         _name = name_;
937         _symbol = symbol_;
938         _baseURI = uri_;
939         _genArtInterface = IGenArtInterfaceV2(genArtInterfaceAddress_);
940         _collectionIdCounter.reset();
941     }
942 
943     modifier onlyArtist(uint256 _collectionId) {
944         require(
945             _collectionsMap[_collectionId].artist == _msgSender(),
946             "GenArtCollectionDrop: only artist can call this function"
947         );
948         _;
949     }
950 
951     function withdraw(uint256 value) public onlyOwner {
952         address _owner = owner();
953         payable(_owner).transfer(value);
954     }
955 
956     function createGenCollectionGroup(
957         uint256 _groupId,
958         uint256 _tier,
959         uint256 _price,
960         uint256 _priceGen
961     ) public onlyOwner {
962         uint256[] memory _collections;
963         _collectionGroupsMap[_groupId] = CollectionGroup({
964             tier: _tier,
965             price: _price,
966             priceGen: _priceGen,
967             collections: _collections
968         });
969     }
970 
971     function createGenCollection(
972         address _artist,
973         uint256 _artistPercentage,
974         uint256 _maxInvocations,
975         uint256 _groupId,
976         string memory _script,
977         string memory _script_type
978     ) public onlyOwner {
979         uint256 _collectionId = _collectionIdCounter.current();
980 
981         _collectionsMap[_collectionId] = Collection({
982             group: _groupId,
983             invocations: 0,
984             maxInvocations: _maxInvocations,
985             script: _script,
986             script_type: _script_type,
987             artistPercentage: _artistPercentage,
988             artist: _artist
989         });
990         _collectionGroupsMap[_groupId].collections.push(_collectionId);
991         _collectionIdCounter.increment();
992     }
993 
994     function checkMint(
995         address _sender,
996         uint256 _groupId,
997         uint256 _membershipId,
998         uint256 _amount
999     ) internal view returns (uint256[] memory) {
1000        
1001         require(
1002             _collectionGroupsMap[_groupId].tier != 0,
1003             "GenArtCollectionDrop: incorrect collection id"
1004         );
1005         uint256 counter;
1006         uint256[] memory collectionIds = new uint256[](10);
1007         uint256 remainingInvocations;
1008         for (
1009             uint256 i = 0;
1010             i < _collectionGroupsMap[_groupId].collections.length;
1011             i++
1012         ) {
1013             uint256 invocations = _collectionsMap[
1014                 _collectionGroupsMap[_groupId].collections[i]
1015             ].maxInvocations -
1016                 _collectionsMap[_collectionGroupsMap[_groupId].collections[i]]
1017                     .invocations;
1018             if (invocations > 0) {
1019                 collectionIds[counter] = _collectionGroupsMap[_groupId]
1020                     .collections[i];
1021                 counter++;
1022             }
1023             remainingInvocations += invocations;
1024         }
1025         uint256[] memory slicedCollectionIds = new uint256[](counter);
1026         for (uint256 j = 0; j < slicedCollectionIds.length; j++) {
1027             slicedCollectionIds[j] = collectionIds[j];
1028         }
1029         require(
1030             collectionIds.length > 0 && remainingInvocations >= _amount,
1031             "GenArtCollectionDrop: max invocations reached"
1032         );
1033 
1034         address _membershipOwner = _genArtInterface.ownerOf(_membershipId);
1035         require(
1036             _membershipOwner == _sender,
1037             "GenArtCollectionDrop: sender must be membership owner"
1038         );
1039         bool _isGoldMember = _genArtInterface.isGoldToken(_membershipId);
1040         uint256 _tier = _isGoldMember ? 2 : 1;
1041         require(
1042             _collectionGroupsMap[_groupId].tier == 3 ||
1043                 _collectionGroupsMap[_groupId].tier == _tier,
1044             "GenArtCollectionDrop: no valid membership"
1045         );
1046         uint256 maxMint = getAllowedMintForMembership(_groupId, _membershipId);
1047         require(
1048             maxMint >= _amount,
1049             "GenArtCollectionDrop: no mints available"
1050         );
1051 
1052         return slicedCollectionIds;
1053     }
1054 
1055     function checkFunds(
1056         uint256 _groupId,
1057         uint256 _value,
1058         uint256 _amount,
1059         bool _isEthPayment
1060     ) internal view {
1061         if (_isEthPayment) {
1062             require(
1063                 _collectionGroupsMap[_groupId].price.mul(_amount) <= _value,
1064                 "GenArtCollectionDrop: incorrect amount sent"
1065             );
1066         } else {
1067             require(
1068                 _collectionGroupsMap[_groupId].priceGen.mul(_amount) <= _value,
1069                 "GenArtCollectionDrop: insufficient $GEN balance"
1070             );
1071         }
1072     }
1073 
1074     function mint(
1075         address _to,
1076         uint256 _groupId,
1077         uint256 _membershipId
1078     ) public payable {
1079         uint256[] memory collectionIds = checkMint(
1080             msg.sender,
1081             _groupId,
1082             _membershipId,
1083             1
1084         );
1085         checkFunds(_groupId, msg.value, 1, true);
1086         updateMintState(_groupId, _membershipId, 1);
1087         uint256 _collectionId = _mintOne(_to, collectionIds);
1088         splitFunds(msg.sender, _groupId, _collectionId, 1, true);
1089     }
1090 
1091     function mintGen(
1092         address _to,
1093         uint256 _groupId,
1094         uint256 _membershipId
1095     ) public {
1096         bool _genAllowed = _genArtInterface.genAllowed();
1097         require(
1098             _genAllowed,
1099             "GenArtCollectionDrop: Mint with $GENART not allowed"
1100         );
1101         uint256 balance = _genArtInterface.balanceOf(msg.sender);
1102         uint256[] memory collectionIds = checkMint(
1103             msg.sender,
1104             _groupId,
1105             _membershipId,
1106             1
1107         );
1108         checkFunds(_groupId, balance, 1, false);
1109         updateMintState(_groupId, _membershipId, 1);
1110         uint256 _collectionId = _mintOne(_to, collectionIds);
1111         splitFunds(msg.sender, _groupId, _collectionId, 1, false);
1112     }
1113 
1114     function mintMany(
1115         address _to,
1116         uint256 _groupId,
1117         uint256 _membershipId,
1118         uint256 _amount
1119     ) public payable {
1120         checkFunds(_groupId, msg.value, _amount, true);
1121         for (uint256 i = 0; i < _amount; i++) {
1122             mint(_to, _groupId, _membershipId);
1123         }
1124     }
1125 
1126     function mintManyGen(
1127         address _to,
1128         uint256 _groupId,
1129         uint256 _membershipId,
1130         uint256 _amount
1131     ) public {
1132         bool _genAllowed = _genArtInterface.genAllowed();
1133         require(
1134             _genAllowed,
1135             "GenArtCollectionDrop: Mint with $GENART not allowed"
1136         );
1137         uint256 balance = _genArtInterface.balanceOf(msg.sender);
1138         checkFunds(_groupId, balance, _amount, false);
1139 
1140         for (uint256 i = 0; i < _amount; i++) {
1141             mintGen(_to, _groupId, _membershipId);
1142         }
1143     }
1144 
1145     function _mintOne(address _to, uint256[] memory _collectionIds)
1146         internal
1147         virtual
1148         returns (uint256)
1149     {
1150         uint256 _collectionId = _genArtInterface.getRandomChoice(
1151             _collectionIds,
1152             nonce
1153         );
1154         nonce++;
1155         uint256 invocation = _collectionsMap[_collectionId].invocations + 1;
1156         uint256 _tokenId = _collectionId * 100_000 + invocation;
1157         _collectionsMap[_collectionId].invocations = invocation;
1158 
1159         bytes32 hash = keccak256(
1160             abi.encodePacked(invocation, block.number, block.timestamp, _to)
1161         );
1162         _tokenIdToHashMap[_tokenId] = hash;
1163         _tokenIdToCollectionIdMap[_tokenId] = _collectionId;
1164 
1165         _safeMint(_to, _tokenId);
1166 
1167         emit Mint(_to, _collectionId, _tokenId, hash);
1168 
1169         return _collectionId;
1170     }
1171 
1172     function splitFunds(
1173         address _sender,
1174         uint256 _groupId,
1175         uint256 _collectionId,
1176         uint256 _amount,
1177         bool _isEthPayment
1178     ) internal virtual {
1179         uint256 value = _isEthPayment
1180             ? _collectionGroupsMap[_groupId].price.mul(_amount)
1181             : _collectionGroupsMap[_groupId].priceGen.mul(_amount);
1182         address _owner = owner();
1183         uint256 artistReward = (value *
1184             _collectionsMap[_collectionId].artistPercentage) / 100;
1185         if (_isEthPayment) {
1186             payable(_collectionsMap[_collectionId].artist).transfer(
1187                 artistReward
1188             );
1189         } else {
1190             _genArtInterface.transferFrom(
1191                 _sender,
1192                 _owner,
1193                 value - artistReward
1194             );
1195             _genArtInterface.transferFrom(
1196                 _sender,
1197                 _collectionsMap[_collectionId].artist,
1198                 artistReward
1199             );
1200         }
1201     }
1202 
1203     function getAllowedMintForMembership(uint256 _group, uint256 _membershipId)
1204         public
1205         view
1206         returns (uint256)
1207     {
1208         uint256 maxMint = _collectionGroupsMap[_group].tier == 2
1209             ? 1
1210             : _genArtInterface.getMaxMintForMembership(_membershipId);
1211         return maxMint - _collectionsMintMap[_group][_membershipId];
1212     }
1213 
1214     function updateMintState(
1215         uint256 _group,
1216         uint256 _membershipId,
1217         uint256 _amount
1218     ) internal virtual {
1219         _collectionsMintMap[_group][_membershipId] =
1220             _collectionsMintMap[_group][_membershipId] +
1221             _amount;
1222     }
1223 
1224     function updateArtistAddress(uint256 _collectionId, address _artist)
1225         public
1226         onlyArtist(_collectionId)
1227     {
1228         _collectionsMap[_collectionId].artist = _artist;
1229     }
1230 
1231     function updateScript(uint256 _collectionId, string memory _script)
1232         public
1233         onlyOwner
1234     {
1235         _collectionsMap[_collectionId].script = _script;
1236     }
1237 
1238     function upgradeGenArtInterfaceContract(address _genArtInterfaceAddress)
1239         public
1240         onlyOwner
1241     {
1242         _genArtInterface = IGenArtInterfaceV2(_genArtInterfaceAddress);
1243     }
1244 
1245     function updatePrice(
1246         uint256 _groupId,
1247         uint256 _price,
1248         uint256 _priceGen
1249     ) public onlyOwner {
1250         _collectionGroupsMap[_groupId].price = _price;
1251         _collectionGroupsMap[_groupId].priceGen = _priceGen;
1252     }
1253 
1254     function getTokensByOwner(address _owner)
1255         public
1256         view
1257         returns (uint256[] memory)
1258     {
1259         uint256 tokenCount = balanceOf(_owner);
1260         uint256[] memory tokenIds = new uint256[](tokenCount);
1261         for (uint256 i; i < tokenCount; i++) {
1262             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1263         }
1264 
1265         return tokenIds;
1266     }
1267 
1268     // /**
1269     //  * @dev See {IERC165-supportsInterface}.
1270     //  */
1271     function supportsInterface(bytes4 interfaceId)
1272         public
1273         view
1274         virtual
1275         override(ERC165, IERC165)
1276         returns (bool)
1277     {
1278         return
1279             interfaceId == type(IERC721).interfaceId ||
1280             interfaceId == type(IERC721Metadata).interfaceId ||
1281             interfaceId == type(IERC721Enumerable).interfaceId ||
1282             super.supportsInterface(interfaceId);
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-balanceOf}.
1287      */
1288     function balanceOf(address owner)
1289         public
1290         view
1291         virtual
1292         override
1293         returns (uint256)
1294     {
1295         require(
1296             owner != address(0),
1297             "ERC721: balance query for the zero address"
1298         );
1299         return _balances[owner];
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-ownerOf}.
1304      */
1305     function ownerOf(uint256 tokenId)
1306         public
1307         view
1308         virtual
1309         override
1310         returns (address)
1311     {
1312         address owner = _owners[tokenId];
1313         require(
1314             owner != address(0),
1315             "ERC721: owner query for nonexistent token"
1316         );
1317         return owner;
1318     }
1319 
1320     /**
1321      * @dev See {IERC721Metadata-name}.
1322      */
1323     function name() public view virtual override returns (string memory) {
1324         return _name;
1325     }
1326 
1327     /**
1328      * @dev See {IERC721Metadata-symbol}.
1329      */
1330     function symbol() public view virtual override returns (string memory) {
1331         return _symbol;
1332     }
1333 
1334     /**
1335      * @dev See {IERC721Metadata-tokenURI}.
1336      */
1337     function tokenURI(uint256 tokenId)
1338         public
1339         view
1340         virtual
1341         override
1342         returns (string memory)
1343     {
1344         require(
1345             _exists(tokenId),
1346             "ERC721Metadata: URI query for nonexistent token"
1347         );
1348 
1349         // string memory baseURI_ = baseURI();
1350         return
1351             bytes(_baseURI).length > 0
1352                 ? string(abi.encodePacked(_baseURI, tokenId.toString()))
1353                 : "";
1354     }
1355 
1356     /**
1357      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1358      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1359      * by default, can be overriden in child contracts.
1360      */
1361     function baseURI() internal view virtual returns (string memory) {
1362         return _baseURI;
1363     }
1364 
1365     /**
1366      * @dev Internal function to set the base URI for all token IDs. It is
1367      * automatically added as a prefix to the value returned in {tokenURI},
1368      * or to the token ID if {tokenURI} is empty.
1369      */
1370     function setBaseURI(string memory baseURI_) public onlyOwner {
1371         _baseURI = baseURI_;
1372     }
1373 
1374     /**
1375      * @dev See {IERC721-approve}.
1376      */
1377     function approve(address to, uint256 tokenId) public virtual override {
1378         address owner = GenArtCollectionDrop.ownerOf(tokenId);
1379         require(to != owner, "ERC721: approval to current owner");
1380 
1381         require(
1382             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1383             "ERC721: approve caller is not owner nor approved for all"
1384         );
1385 
1386         _approve(to, tokenId);
1387     }
1388 
1389     /**
1390      * @dev See {IERC721-getApproved}.
1391      */
1392     function getApproved(uint256 tokenId)
1393         public
1394         view
1395         virtual
1396         override
1397         returns (address)
1398     {
1399         require(
1400             _exists(tokenId),
1401             "ERC721: approved query for nonexistent token"
1402         );
1403 
1404         return _tokenApprovals[tokenId];
1405     }
1406 
1407     /**
1408      * @dev See {IERC721-setApprovalForAll}.
1409      */
1410     function setApprovalForAll(address operator, bool approved)
1411         public
1412         virtual
1413         override
1414     {
1415         require(operator != _msgSender(), "ERC721: approve to caller");
1416 
1417         _operatorApprovals[_msgSender()][operator] = approved;
1418         emit ApprovalForAll(_msgSender(), operator, approved);
1419     }
1420 
1421     /**
1422      * @dev See {IERC721-isApprovedForAll}.
1423      */
1424     function isApprovedForAll(address owner, address operator)
1425         public
1426         view
1427         virtual
1428         override
1429         returns (bool)
1430     {
1431         return _operatorApprovals[owner][operator];
1432     }
1433 
1434     /**
1435      * @dev See {IERC721-transferFrom}.
1436      */
1437     function transferFrom(
1438         address from,
1439         address to,
1440         uint256 tokenId
1441     ) public virtual override {
1442         //solhint-disable-next-line max-line-length
1443         require(
1444             _isApprovedOrOwner(_msgSender(), tokenId),
1445             "ERC721: transfer caller is not owner nor approved"
1446         );
1447 
1448         _transfer(from, to, tokenId);
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-safeTransferFrom}.
1453      */
1454     function safeTransferFrom(
1455         address from,
1456         address to,
1457         uint256 tokenId
1458     ) public virtual override {
1459         safeTransferFrom(from, to, tokenId, "");
1460     }
1461 
1462     /**
1463      * @dev See {IERC721-safeTransferFrom}.
1464      */
1465     function safeTransferFrom(
1466         address from,
1467         address to,
1468         uint256 tokenId,
1469         bytes memory _data
1470     ) public virtual override {
1471         require(
1472             _isApprovedOrOwner(_msgSender(), tokenId),
1473             "ERC721: transfer caller is not owner nor approved"
1474         );
1475         _safeTransfer(from, to, tokenId, _data);
1476     }
1477 
1478     /**
1479      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1480      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1481      *
1482      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1483      *
1484      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1485      * implement alternative mechanisms to perform token transfer, such as signature-based.
1486      *
1487      * Requirements:
1488      *
1489      * - `from` cannot be the zero address.
1490      * - `to` cannot be the zero address.
1491      * - `tokenId` token must exist and be owned by `from`.
1492      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1493      *
1494      * Emits a {Transfer} event.
1495      */
1496     function _safeTransfer(
1497         address from,
1498         address to,
1499         uint256 tokenId,
1500         bytes memory _data
1501     ) internal virtual {
1502         _transfer(from, to, tokenId);
1503         require(
1504             _checkOnERC721Received(from, to, tokenId, _data),
1505             "ERC721: transfer to non ERC721Receiver implementer"
1506         );
1507     }
1508 
1509     /**
1510      * @dev Returns whether `tokenId` exists.
1511      *
1512      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1513      *
1514      * Tokens start existing when they are minted (`_mint`),
1515      * and stop existing when they are burned (`_burn`).
1516      */
1517     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1518         return _owners[tokenId] != address(0);
1519     }
1520 
1521     /**
1522      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1523      *
1524      * Requirements:
1525      *
1526      * - `tokenId` must exist.
1527      */
1528     function _isApprovedOrOwner(address spender, uint256 tokenId)
1529         internal
1530         view
1531         virtual
1532         returns (bool)
1533     {
1534         require(
1535             _exists(tokenId),
1536             "ERC721: operator query for nonexistent token"
1537         );
1538         address owner = GenArtCollectionDrop.ownerOf(tokenId);
1539         return (spender == owner ||
1540             getApproved(tokenId) == spender ||
1541             isApprovedForAll(owner, spender));
1542     }
1543 
1544     /**
1545      * @dev Safely mints `tokenId` and transfers it to `to`.
1546      *
1547      * Requirements:
1548      *
1549      * - `tokenId` must not exist.
1550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1551      *
1552      * Emits a {Transfer} event.
1553      */
1554     function _safeMint(address to, uint256 tokenId) internal virtual {
1555         _safeMint(to, tokenId, "");
1556     }
1557 
1558     /**
1559      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1560      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1561      */
1562     function _safeMint(
1563         address to,
1564         uint256 tokenId,
1565         bytes memory _data
1566     ) internal virtual {
1567         _mint(to, tokenId);
1568         require(
1569             _checkOnERC721Received(address(0), to, tokenId, _data),
1570             "ERC721: transfer to non ERC721Receiver implementer"
1571         );
1572     }
1573 
1574     /**
1575      * @dev Mints `tokenId` and transfers it to `to`.
1576      *
1577      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1578      *
1579      * Requirements:
1580      *
1581      * - `tokenId` must not exist.
1582      * - `to` cannot be the zero address.
1583      *
1584      * Emits a {Transfer} event.
1585      */
1586     function _mint(address to, uint256 tokenId) internal virtual {
1587         require(to != address(0), "ERC721: mint to the zero address");
1588         require(!_exists(tokenId), "ERC721: token already minted");
1589 
1590         _beforeTokenTransfer(address(0), to, tokenId);
1591 
1592         _balances[to] += 1;
1593         _owners[tokenId] = to;
1594 
1595         emit Transfer(address(0), to, tokenId);
1596     }
1597 
1598     /**
1599      * @dev Destroys `tokenId`.
1600      * The approval is cleared when the token is burned.
1601      *
1602      * Requirements:
1603      *
1604      * - `tokenId` must exist.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function burn(uint256 tokenId) public {
1609         address owner = GenArtCollectionDrop.ownerOf(tokenId);
1610         require(
1611             _msgSender() == owner,
1612             "GenArtCollectionDrop: only token owner can burn"
1613         );
1614         _beforeTokenTransfer(owner, address(0), tokenId);
1615         // Clear approvals
1616         _approve(address(0), tokenId);
1617 
1618         _balances[owner] -= 1;
1619         delete _owners[tokenId];
1620 
1621         emit Transfer(owner, address(0), tokenId);
1622     }
1623 
1624     /**
1625      * @dev Transfers `tokenId` from `from` to `to`.
1626      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1627      *
1628      * Requirements:
1629      *
1630      * - `to` cannot be the zero address.
1631      * - `tokenId` token must be owned by `from`.
1632      *
1633      * Emits a {Transfer} event.
1634      */
1635     function _transfer(
1636         address from,
1637         address to,
1638         uint256 tokenId
1639     ) internal virtual {
1640         require(
1641             GenArtCollectionDrop.ownerOf(tokenId) == from,
1642             "ERC721: transfer of token that is not own"
1643         );
1644         require(to != address(0), "ERC721: transfer to the zero address");
1645 
1646         _beforeTokenTransfer(from, to, tokenId);
1647 
1648         // Clear approvals from the previous owner
1649         _approve(address(0), tokenId);
1650 
1651         _balances[from] -= 1;
1652         _balances[to] += 1;
1653         _owners[tokenId] = to;
1654 
1655         emit Transfer(from, to, tokenId);
1656     }
1657 
1658     /**
1659      * @dev Approve `to` to operate on `tokenId`
1660      *
1661      * Emits a {Approval} event.
1662      */
1663     function _approve(address to, uint256 tokenId) internal virtual {
1664         _tokenApprovals[tokenId] = to;
1665         emit Approval(GenArtCollectionDrop.ownerOf(tokenId), to, tokenId);
1666     }
1667 
1668     /**
1669      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1670      * The call is not executed if the target address is not a contract.
1671      *
1672      * @param from address representing the previous owner of the given token ID
1673      * @param to target address that will receive the tokens
1674      * @param tokenId uint256 ID of the token to be transferred
1675      * @param _data bytes optional data to send along with the call
1676      * @return bool whether the call correctly returned the expected magic value
1677      */
1678     function _checkOnERC721Received(
1679         address from,
1680         address to,
1681         uint256 tokenId,
1682         bytes memory _data
1683     ) private returns (bool) {
1684         if (to.isContract()) {
1685             try
1686                 IERC721Receiver(to).onERC721Received(
1687                     _msgSender(),
1688                     from,
1689                     tokenId,
1690                     _data
1691                 )
1692             returns (bytes4 retval) {
1693                 return retval == IERC721Receiver.onERC721Received.selector;
1694             } catch (bytes memory reason) {
1695                 if (reason.length == 0) {
1696                     revert(
1697                         "ERC721: transfer to non ERC721Receiver implementer"
1698                     );
1699                 } else {
1700                     assembly {
1701                         revert(add(32, reason), mload(reason))
1702                     }
1703                 }
1704             }
1705         } else {
1706             return true;
1707         }
1708     }
1709 
1710     /**
1711      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1712      */
1713     function tokenOfOwnerByIndex(address owner, uint256 index)
1714         public
1715         view
1716         virtual
1717         override
1718         returns (uint256)
1719     {
1720         require(
1721             index < GenArtCollectionDrop.balanceOf(owner),
1722             "ERC721Enumerable: owner index out of bounds"
1723         );
1724         return _ownedTokens[owner][index];
1725     }
1726 
1727     /**
1728      * @dev See {IERC721Enumerable-totalSupply}.
1729      */
1730     function totalSupply() public view virtual override returns (uint256) {
1731         return _allTokens.length;
1732     }
1733 
1734     /**
1735      * @dev See {IERC721Enumerable-tokenByIndex}.
1736      */
1737     function tokenByIndex(uint256 index)
1738         public
1739         view
1740         virtual
1741         override
1742         returns (uint256)
1743     {
1744         require(
1745             index < GenArtCollectionDrop.totalSupply(),
1746             "ERC721Enumerable: global index out of bounds"
1747         );
1748         return _allTokens[index];
1749     }
1750 
1751     /**
1752      * @dev Hook that is called before any token transfer. This includes minting
1753      * and burning.
1754      *
1755      * Calling conditions:
1756      *
1757      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1758      * transferred to `to`.
1759      * - When `from` is zero, `tokenId` will be minted for `to`.
1760      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1761      * - `from` cannot be the zero address.
1762      * - `to` cannot be the zero address.
1763      *
1764      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1765      */
1766     function _beforeTokenTransfer(
1767         address from,
1768         address to,
1769         uint256 tokenId
1770     ) internal virtual {
1771         if (from == address(0)) {
1772             _addTokenToAllTokensEnumeration(tokenId);
1773         } else if (from != to) {
1774             _removeTokenFromOwnerEnumeration(from, tokenId);
1775         }
1776         if (to == address(0)) {
1777             _removeTokenFromAllTokensEnumeration(tokenId);
1778         } else if (to != from) {
1779             _addTokenToOwnerEnumeration(to, tokenId);
1780         }
1781     }
1782 
1783     /**
1784      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1785      * @param to address representing the new owner of the given token ID
1786      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1787      */
1788     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1789         uint256 length = GenArtCollectionDrop.balanceOf(to);
1790         _ownedTokens[to][length] = tokenId;
1791         _ownedTokensIndex[tokenId] = length;
1792     }
1793 
1794     /**
1795      * @dev Private function to add a token to this extension's token tracking data structures.
1796      * @param tokenId uint256 ID of the token to be added to the tokens list
1797      */
1798     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1799         _allTokensIndex[tokenId] = _allTokens.length;
1800         _allTokens.push(tokenId);
1801     }
1802 
1803     /**
1804      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1805      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1806      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1807      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1808      * @param from address representing the previous owner of the given token ID
1809      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1810      */
1811     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1812         private
1813     {
1814         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1815         // then delete the last slot (swap and pop).
1816 
1817         uint256 lastTokenIndex = GenArtCollectionDrop.balanceOf(from) - 1;
1818         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1819 
1820         // When the token to delete is the last token, the swap operation is unnecessary
1821         if (tokenIndex != lastTokenIndex) {
1822             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1823 
1824             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1825             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1826         }
1827 
1828         // This also deletes the contents at the last position of the array
1829         delete _ownedTokensIndex[tokenId];
1830         delete _ownedTokens[from][lastTokenIndex];
1831     }
1832 
1833     /**
1834      * @dev Private function to remove a token from this extension's token tracking data structures.
1835      * This has O(1) time complexity, but alters the order of the _allTokens array.
1836      * @param tokenId uint256 ID of the token to be removed from the tokens list
1837      */
1838     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1839         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1840         // then delete the last slot (swap and pop).
1841 
1842         uint256 lastTokenIndex = _allTokens.length - 1;
1843         uint256 tokenIndex = _allTokensIndex[tokenId];
1844 
1845         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1846         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1847         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1848         uint256 lastTokenId = _allTokens[lastTokenIndex];
1849 
1850         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1851         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1852 
1853         // This also deletes the contents at the last position of the array
1854         delete _allTokensIndex[tokenId];
1855         _allTokens.pop();
1856     }
1857 }