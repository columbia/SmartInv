1 //.:::.     .........  ...     ...       ....    ...     ....     ...        ...       
2 //  .*@@@@@@@*.  @@@@@@@@@: #@@@-  :@@#       #@@*   +@@%    =@@@@=    #@@+      =@@%       
3 //  @@@*. .+##*  @@@+::::.  #@@@@#::@@#       #@@#:::*@@%   .@@%%@@:   #@@+      =@@%       
4 // :@@@: +%%%%#  @@@@@@@@=  #@@%@@@%@@#       #@@@@@@@@@%   %@@:-@@%   #@@+      =@@%       
5 //  @@@*.:-#@@@  @@@+.....  #@@-:#@@@@#       #@@#...+@@%  *@@@##@@@*  #@@*::::: =@@@:::::  
6 //  :#@@@@@@#@@  @@@@@@@@@- #@@-  -@@@#       #@@*   +@@% -@@@====@@@= #@@@@@@@@ =@@@@@@@@= 
7 //     .::.  ..  .........  ...     ...       ....    ... ....    .... .........  ........
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.0;
11 
12 interface IGenHallInterface {
13     function upgradeGenHallTokenContract(address _genHallTokenAddress) external;
14 
15     function setAllowGen(bool allow) external;
16 
17     function genAllowed() external view returns (bool);
18 
19     function getMembershipTier(uint256 _membershipId) external view returns (uint256);
20 
21     function transferFrom(
22         address _from,
23         address _to,
24         uint256 _amount
25     ) external;
26 
27     function balanceOf(address _owner) external view returns (uint256);
28 
29     function ownerOf(uint256 _membershipId) external view returns (address);
30 }
31 
32 /**
33  * @dev Provides information about the current execution context, including the
34  * sender of the transaction and its data. While these are generally available
35  * via msg.sender and msg.data, they should not be accessed in such a direct
36  * manner, since when dealing with meta-transactions the account sending and
37  * paying for execution may not be the actual sender (as far as an application
38  * is concerned).
39  *
40  * This contract is only required for intermediate, library-like contracts.
41  */
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 
47     function _msgData() internal view virtual returns (bytes calldata) {
48         return msg.data;
49     }
50 }
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(
68         address indexed previousOwner,
69         address indexed newOwner
70     );
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor() {
76         _setOwner(_msgSender());
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(
100             newOwner != address(0),
101             "Ownable: new owner is the zero address"
102         );
103         _setOwner(newOwner);
104     }
105 
106     function _setOwner(address newOwner) private {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 /**
114  * @title Counters
115  * @author Matt Condon (@shrugs)
116  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
117  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
118  *
119  * Include with `using Counters for Counters.Counter;`
120  */
121 library Counters {
122     struct Counter {
123         // This variable should never be directly accessed by users of the library: interactions must be restricted to
124         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
125         // this feature: see https://github.com/ethereum/solidity/issues/4637
126         uint256 _value; // default: 0
127     }
128 
129     function current(Counter storage counter) internal view returns (uint256) {
130         return counter._value;
131     }
132 
133     function increment(Counter storage counter) internal {
134         unchecked {
135             counter._value += 1;
136         }
137     }
138 
139     function decrement(Counter storage counter) internal {
140         uint256 value = counter._value;
141         require(value > 0, "Counter: decrement overflow");
142         unchecked {
143             counter._value = value - 1;
144         }
145     }
146 
147     function reset(Counter storage counter) internal {
148         counter._value = 0;
149     }
150 }
151 
152 /**
153  * @dev String operations.
154  */
155 library Strings {
156     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
160      */
161     function toString(uint256 value) internal pure returns (string memory) {
162         // Inspired by OraclizeAPI's implementation - MIT licence
163         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
164 
165         if (value == 0) {
166             return "0";
167         }
168         uint256 temp = value;
169         uint256 digits;
170         while (temp != 0) {
171             digits++;
172             temp /= 10;
173         }
174         bytes memory buffer = new bytes(digits);
175         while (value != 0) {
176             digits -= 1;
177             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
178             value /= 10;
179         }
180         return string(buffer);
181     }
182 }
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      */
205     function isContract(address account) internal view returns (bool) {
206         // This method relies on extcodesize, which returns 0 for contracts in
207         // construction, since the code is only stored at the end of the
208         // constructor execution.
209 
210         uint256 size;
211         assembly {
212             size := extcodesize(account)
213         }
214         return size > 0;
215     }
216 }
217 
218 // CAUTION
219 // This version of SafeMath should only be used with Solidity 0.8 or later,
220 // because it relies on the compiler's built in overflow checks.
221 
222 /**
223  * @dev Wrappers over Solidity's arithmetic operations.
224  *
225  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
226  * now has built in overflow checking.
227  */
228 library SafeMath {
229     /**
230      * @dev Returns the addition of two unsigned integers, with an overflow flag.
231      *
232      * _Available since v3.4._
233      */
234     function tryAdd(uint256 a, uint256 b)
235         internal
236         pure
237         returns (bool, uint256)
238     {
239         unchecked {
240             uint256 c = a + b;
241             if (c < a) return (false, 0);
242             return (true, c);
243         }
244     }
245 
246     /**
247      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
248      *
249      * _Available since v3.4._
250      */
251     function trySub(uint256 a, uint256 b)
252         internal
253         pure
254         returns (bool, uint256)
255     {
256         unchecked {
257             if (b > a) return (false, 0);
258             return (true, a - b);
259         }
260     }
261 
262     /**
263      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
264      *
265      * _Available since v3.4._
266      */
267     function tryMul(uint256 a, uint256 b)
268         internal
269         pure
270         returns (bool, uint256)
271     {
272         unchecked {
273             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
274             // benefit is lost if 'b' is also tested.
275             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
276             if (a == 0) return (true, 0);
277             uint256 c = a * b;
278             if (c / a != b) return (false, 0);
279             return (true, c);
280         }
281     }
282 
283     /**
284      * @dev Returns the division of two unsigned integers, with a division by zero flag.
285      *
286      * _Available since v3.4._
287      */
288     function tryDiv(uint256 a, uint256 b)
289         internal
290         pure
291         returns (bool, uint256)
292     {
293         unchecked {
294             if (b == 0) return (false, 0);
295             return (true, a / b);
296         }
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
301      *
302      * _Available since v3.4._
303      */
304     function tryMod(uint256 a, uint256 b)
305         internal
306         pure
307         returns (bool, uint256)
308     {
309         unchecked {
310             if (b == 0) return (false, 0);
311             return (true, a % b);
312         }
313     }
314 
315     /**
316      * @dev Returns the addition of two unsigned integers, reverting on
317      * overflow.
318      *
319      * Counterpart to Solidity's `+` operator.
320      *
321      * Requirements:
322      *
323      * - Addition cannot overflow.
324      */
325     function add(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a + b;
327     }
328 
329     /**
330      * @dev Returns the subtraction of two unsigned integers, reverting on
331      * overflow (when the result is negative).
332      *
333      * Counterpart to Solidity's `-` operator.
334      *
335      * Requirements:
336      *
337      * - Subtraction cannot overflow.
338      */
339     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
340         return a - b;
341     }
342 
343     /**
344      * @dev Returns the multiplication of two unsigned integers, reverting on
345      * overflow.
346      *
347      * Counterpart to Solidity's `*` operator.
348      *
349      * Requirements:
350      *
351      * - Multiplication cannot overflow.
352      */
353     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
354         return a * b;
355     }
356 
357     /**
358      * @dev Returns the integer division of two unsigned integers, reverting on
359      * division by zero. The result is rounded towards zero.
360      *
361      * Counterpart to Solidity's `/` operator.
362      *
363      * Requirements:
364      *
365      * - The divisor cannot be zero.
366      */
367     function div(uint256 a, uint256 b) internal pure returns (uint256) {
368         return a / b;
369     }
370 
371     /**
372      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
373      * reverting when dividing by zero.
374      *
375      * Counterpart to Solidity's `%` operator. This function uses a `revert`
376      * opcode (which leaves remaining gas untouched) while Solidity uses an
377      * invalid opcode to revert (consuming all remaining gas).
378      *
379      * Requirements:
380      *
381      * - The divisor cannot be zero.
382      */
383     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
384         return a % b;
385     }
386 
387     /**
388      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
389      * overflow (when the result is negative).
390      *
391      * CAUTION: This function is deprecated because it requires allocating memory for the error
392      * message unnecessarily. For custom revert reasons use {trySub}.
393      *
394      * Counterpart to Solidity's `-` operator.
395      *
396      * Requirements:
397      *
398      * - Subtraction cannot overflow.
399      */
400     function sub(
401         uint256 a,
402         uint256 b,
403         string memory errorMessage
404     ) internal pure returns (uint256) {
405         unchecked {
406             require(b <= a, errorMessage);
407             return a - b;
408         }
409     }
410 
411     /**
412      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
413      * division by zero. The result is rounded towards zero.
414      *
415      * Counterpart to Solidity's `/` operator. Note: this function uses a
416      * `revert` opcode (which leaves remaining gas untouched) while Solidity
417      * uses an invalid opcode to revert (consuming all remaining gas).
418      *
419      * Requirements:
420      *
421      * - The divisor cannot be zero.
422      */
423     function div(
424         uint256 a,
425         uint256 b,
426         string memory errorMessage
427     ) internal pure returns (uint256) {
428         unchecked {
429             require(b > 0, errorMessage);
430             return a / b;
431         }
432     }
433 
434     /**
435      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
436      * reverting with custom message when dividing by zero.
437      *
438      * CAUTION: This function is deprecated because it requires allocating memory for the error
439      * message unnecessarily. For custom revert reasons use {tryMod}.
440      *
441      * Counterpart to Solidity's `%` operator. This function uses a `revert`
442      * opcode (which leaves remaining gas untouched) while Solidity uses an
443      * invalid opcode to revert (consuming all remaining gas).
444      *
445      * Requirements:
446      *
447      * - The divisor cannot be zero.
448      */
449     function mod(
450         uint256 a,
451         uint256 b,
452         string memory errorMessage
453     ) internal pure returns (uint256) {
454         unchecked {
455             require(b > 0, errorMessage);
456             return a % b;
457         }
458     }
459 }
460 
461 /**
462  * @dev Interface of the ERC20 standard as defined in the EIP.
463  */
464 interface IERC20 {
465     /**
466      * @dev Returns the amount of tokens in existence.
467      */
468     function totalSupply() external view returns (uint256);
469 
470     /**
471      * @dev Returns the amount of tokens owned by `account`.
472      */
473     function balanceOf(address account) external view returns (uint256);
474 
475     /**
476      * @dev Moves `amount` tokens from the caller's account to `recipient`.
477      *
478      * Returns a boolean value indicating whether the operation succeeded.
479      *
480      * Emits a {Transfer} event.
481      */
482     function transfer(address recipient, uint256 amount)
483         external
484         returns (bool);
485 
486     /**
487      * @dev Returns the remaining number of tokens that `spender` will be
488      * allowed to spend on behalf of `owner` through {transferFrom}. This is
489      * zero by default.
490      *
491      * This value changes when {approve} or {transferFrom} are called.
492      */
493     function allowance(address owner, address spender)
494         external
495         view
496         returns (uint256);
497 
498     /**
499      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
500      *
501      * Returns a boolean value indicating whether the operation succeeded.
502      *
503      * IMPORTANT: Beware that changing an allowance with this method brings the risk
504      * that someone may use both the old and the new allowance by unfortunate
505      * transaction ordering. One possible solution to mitigate this race
506      * condition is to first reduce the spender's allowance to 0 and set the
507      * desired value afterwards:
508      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
509      *
510      * Emits an {Approval} event.
511      */
512     function approve(address spender, uint256 amount) external returns (bool);
513 
514     /**
515      * @dev Moves `amount` tokens from `sender` to `recipient` using the
516      * allowance mechanism. `amount` is then deducted from the caller's
517      * allowance.
518      *
519      * Returns a boolean value indicating whether the operation succeeded.
520      *
521      * Emits a {Transfer} event.
522      */
523     function transferFrom(
524         address sender,
525         address recipient,
526         uint256 amount
527     ) external returns (bool);
528 
529     /**
530      * @dev Emitted when `value` tokens are moved from one account (`from`) to
531      * another (`to`).
532      *
533      * Note that `value` may be zero.
534      */
535     event Transfer(address indexed from, address indexed to, uint256 value);
536 
537     /**
538      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
539      * a call to {approve}. `value` is the new allowance.
540      */
541     event Approval(
542         address indexed owner,
543         address indexed spender,
544         uint256 value
545     );
546 }
547 
548 /**
549  * @title ERC721 token receiver interface
550  * @dev Interface for any contract that wants to support safeTransfers
551  * from ERC721 asset contracts.
552  */
553 interface IERC721Receiver {
554     /**
555      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
556      * by `operator` from `from`, this function is called.
557      *
558      * It must return its Solidity selector to confirm the token transfer.
559      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
560      *
561      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
562      */
563     function onERC721Received(
564         address operator,
565         address from,
566         uint256 tokenId,
567         bytes calldata data
568     ) external returns (bytes4);
569 }
570 
571 /**
572  * @dev Interface of the ERC165 standard, as defined in the
573  * https://eips.ethereum.org/EIPS/eip-165[EIP].
574  *
575  * Implementers can declare support of contract interfaces, which can then be
576  * queried by others ({ERC165Checker}).
577  *
578  * For an implementation, see {ERC165}.
579  */
580 interface IERC165 {
581     /**
582      * @dev Returns true if this contract implements the interface defined by
583      * `interfaceId`. See the corresponding
584      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
585      * to learn more about how these ids are created.
586      *
587      * This function call must use less than 30 000 gas.
588      */
589     function supportsInterface(bytes4 interfaceId) external view returns (bool);
590 }
591 
592 /**
593  * @dev Implementation of the {IERC165} interface.
594  *
595  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
596  * for the additional interface id that will be supported. For example:
597  *
598  * ```solidity
599  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
601  * }
602  * ```
603  *
604  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
605  */
606 abstract contract ERC165 is IERC165 {
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId)
611         public
612         view
613         virtual
614         override
615         returns (bool)
616     {
617         return interfaceId == type(IERC165).interfaceId;
618     }
619 }
620 
621 /**
622  * @dev Required interface of an ERC721 compliant contract.
623  */
624 interface IERC721 is IERC165 {
625     /**
626      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
627      */
628     event Transfer(
629         address indexed from,
630         address indexed to,
631         uint256 indexed tokenId
632     );
633 
634     /**
635      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
636      */
637     event Approval(
638         address indexed owner,
639         address indexed approved,
640         uint256 indexed tokenId
641     );
642 
643     /**
644      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
645      */
646     event ApprovalForAll(
647         address indexed owner,
648         address indexed operator,
649         bool approved
650     );
651 
652     /**
653      * @dev Returns the number of tokens in ``owner``'s account.
654      */
655     function balanceOf(address owner) external view returns (uint256 balance);
656 
657     /**
658      * @dev Returns the owner of the `tokenId` token.
659      *
660      * Requirements:
661      *
662      * - `tokenId` must exist.
663      */
664     function ownerOf(uint256 tokenId) external view returns (address owner);
665 
666     /**
667      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
668      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
669      *
670      * Requirements:
671      *
672      * - `from` cannot be the zero address.
673      * - `to` cannot be the zero address.
674      * - `tokenId` token must exist and be owned by `from`.
675      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
676      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
677      *
678      * Emits a {Transfer} event.
679      */
680     function safeTransferFrom(
681         address from,
682         address to,
683         uint256 tokenId
684     ) external;
685 
686     /**
687      * @dev Transfers `tokenId` token from `from` to `to`.
688      *
689      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must be owned by `from`.
696      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
697      *
698      * Emits a {Transfer} event.
699      */
700     function transferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) external;
705 
706     /**
707      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
708      * The approval is cleared when the token is transferred.
709      *
710      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
711      *
712      * Requirements:
713      *
714      * - The caller must own the token or be an approved operator.
715      * - `tokenId` must exist.
716      *
717      * Emits an {Approval} event.
718      */
719     function approve(address to, uint256 tokenId) external;
720 
721     /**
722      * @dev Returns the account approved for `tokenId` token.
723      *
724      * Requirements:
725      *
726      * - `tokenId` must exist.
727      */
728     function getApproved(uint256 tokenId)
729         external
730         view
731         returns (address operator);
732 
733     /**
734      * @dev Approve or remove `operator` as an operator for the caller.
735      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
736      *
737      * Requirements:
738      *
739      * - The `operator` cannot be the caller.
740      *
741      * Emits an {ApprovalForAll} event.
742      */
743     function setApprovalForAll(address operator, bool _approved) external;
744 
745     /**
746      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
747      *
748      * See {setApprovalForAll}
749      */
750     function isApprovedForAll(address owner, address operator)
751         external
752         view
753         returns (bool);
754 
755     /**
756      * @dev Safely transfers `tokenId` token from `from` to `to`.
757      *
758      * Requirements:
759      *
760      * - `from` cannot be the zero address.
761      * - `to` cannot be the zero address.
762      * - `tokenId` token must exist and be owned by `from`.
763      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes calldata data
773     ) external;
774 }
775 
776 /**
777  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
778  * @dev See https://eips.ethereum.org/EIPS/eip-721
779  */
780 interface IERC721Enumerable is IERC721 {
781     /**
782      * @dev Returns the total amount of tokens stored by the contract.
783      */
784     function totalSupply() external view returns (uint256);
785 
786     /**
787      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
788      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
789      */
790     function tokenOfOwnerByIndex(address owner, uint256 index)
791         external
792         view
793         returns (uint256 tokenId);
794 
795     /**
796      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
797      * Use along with {totalSupply} to enumerate all tokens.
798      */
799     function tokenByIndex(uint256 index) external view returns (uint256);
800 }
801 
802 /**
803  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
804  * @dev See https://eips.ethereum.org/EIPS/eip-721
805  */
806 interface IERC721Metadata is IERC721 {
807     /**
808      * @dev Returns the token collection name.
809      */
810     function name() external view returns (string memory);
811 
812     /**
813      * @dev Returns the token collection symbol.
814      */
815     function symbol() external view returns (string memory);
816 
817     /**
818      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
819      */
820     function tokenURI(uint256 tokenId) external view returns (string memory);
821 }
822 
823 /**
824  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
825  * the Metadata extension, but not including the Enumerable extension, which is available separately as
826  * {ERC721Enumerable}.
827  */
828 
829 contract GenHallCollection is
830     Context,
831     ERC165,
832     IERC721,
833     IERC721Metadata,
834     IERC721Enumerable,
835     Ownable
836 {
837     using Address for address;
838     using Strings for uint256;
839     using Counters for Counters.Counter;
840     using SafeMath for uint256;
841 
842     struct Collection {
843         bool active;
844         uint256 tier;
845         uint256 invocations;
846         uint256 maxInvocations;
847         uint256 maxMint;
848         bool requiresMembership;
849         string script;
850         uint256 price;
851         uint256 priceGen;
852         uint256 artistPercentage;
853         uint256 artistRewards;
854         address artist;
855         mapping(address => uint256) collaboratorPercentages;
856         mapping(address => uint256) collaboratorShares;
857         address[] collaborators;
858         uint256[] maxMintPerMembershipTier;
859         uint256 maxMintPerTransaction;
860     }
861 
862     event Mint(address to, uint256 collectionId, uint256 tokenId, bytes32 hash);
863 
864     // IGenHallMintState _genHallMintState;
865     mapping(uint256 => Collection) private _collectionsMap;
866 
867     // Mapping collectionId to membershipId and total mints
868     mapping(uint256 => mapping(uint256 => uint256)) private _collectionsMembershipMintMap;
869     mapping(uint256 => mapping(address => uint256)) private _collectionsMintMap;
870 
871     mapping(uint256 => bytes32) private _tokenIdToHashMap;
872     mapping(uint256 => uint256) private _tokenIdToCollectionIdMap;
873     Counters.Counter private _collectionIdCounter;
874     IGenHallInterface private _genHallInterface;
875 
876     function getCurrentCounter() public view returns(uint256) {
877         return _collectionIdCounter.current();
878     }
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
918         string memory symbol_
919     ) {
920         _name = name_;
921         _symbol = symbol_;
922         _collectionIdCounter.increment();
923     }
924 
925     modifier onlyArtist(uint256 _collectionId) {
926         require(
927             _collectionsMap[_collectionId].artist == _msgSender(),
928             "GenHallCollection: only artist can call this function"
929         );
930         _;
931     }
932 
933     modifier onlyCollaborator(uint256 _collectionId) {
934         require(
935             _collectionsMap[_collectionId].collaboratorPercentages[_msgSender()] > 0,
936             "GenHallCollection: only collaborators can call this function"
937         );
938         _;
939     }
940 
941     function setMembershipRequired(uint256 _collectionId, bool membershipRequired) public onlyOwner {
942         _collectionsMap[_collectionId].requiresMembership = membershipRequired;
943     }
944 
945     function getMembershipRequired(uint256 _collectionId) public view returns(bool){
946         return _collectionsMap[_collectionId].requiresMembership;
947     }
948 
949     function setCollectionActive(uint256 _collectionId, bool active) public onlyOwner {
950         _collectionsMap[_collectionId].active = active;
951     }
952 
953     function isCollectionActive(uint256 _collectionId) public view returns(bool){
954         return _collectionsMap[_collectionId].active;
955     }
956 
957     function getArtistRewards(uint256 _collectionId) public view returns(uint256) {
958         return _collectionsMap[_collectionId].artistRewards;
959     }
960 
961     function getArtistPercentage(uint256 _collectionId) public view returns(uint256) {
962         return _collectionsMap[_collectionId].artistPercentage;
963     }
964 
965     function withdrawArtist(uint256 _collectionId) public onlyArtist(_collectionId) {
966         uint256 withdrawAmount = _collectionsMap[_collectionId].artistRewards;
967 
968         _collectionsMap[_collectionId].artistRewards = 0;
969 
970         payable(_msgSender()).transfer(withdrawAmount);
971     }
972 
973     function getCollaboratorShares(uint256 _collectionId, address _collaboratorAddress) public view returns(uint256) {
974         return _collectionsMap[_collectionId].collaboratorShares[_collaboratorAddress];
975     }
976 
977     function getCollaboratorPercentage(uint256 _collectionId, address _collaboratorAddress) public view returns(uint256) {
978         return _collectionsMap[_collectionId].collaboratorPercentages[_collaboratorAddress];
979     }
980 
981     function withdrawCollaborator(uint256 _collectionId) public onlyCollaborator(_collectionId) {
982         uint256 withdrawAmount = _collectionsMap[_collectionId].collaboratorShares[_msgSender()];
983 
984         _collectionsMap[_collectionId].collaboratorShares[_msgSender()] = 0;
985 
986         payable(_msgSender()).transfer(withdrawAmount);
987     }
988 
989     function createCollection(
990         address _artist,
991         uint256 _artistPercentage,
992         uint256 _price,
993         uint256 _priceGen,
994         uint256 _maxInvocations,
995         uint256 _maxMint,
996         bool _requiresMembership,
997         address[] memory _collaborators,
998         uint256[] memory _collaboratorPercentages,
999         uint256 _maxMintPerTransaction
1000     ) public onlyOwner {
1001         uint256 _collectionId = _collectionIdCounter.current();
1002 
1003         Collection storage collection = _collectionsMap[_collectionId];
1004 
1005         collection.active = false;
1006         collection.tier = 1;
1007         collection.maxMintPerMembershipTier = [1];
1008         collection.invocations = 0;
1009         collection.maxInvocations = _maxInvocations;
1010         collection.maxMint = _maxMint;
1011         collection.requiresMembership = _requiresMembership;
1012         collection.price = _price;
1013         collection.priceGen = _priceGen;
1014         collection.artistPercentage = _artistPercentage;
1015         collection.artist = _artist;
1016         collection.collaborators = _collaborators;
1017         collection.maxMintPerTransaction = _maxMintPerTransaction;
1018 
1019         uint256 sharesPercentageTotal = _artistPercentage;
1020 
1021         for (uint i = 0; i < collection.collaborators.length; i++) {
1022             sharesPercentageTotal += _collaboratorPercentages[i];
1023             collection.collaboratorPercentages[collection.collaborators[i]] =
1024                 _collaboratorPercentages[i];
1025         }
1026 
1027         require(sharesPercentageTotal == 100, "The shares percentages (artist + collaborators) must add up to 100");
1028 
1029         _collectionIdCounter.increment();
1030     }
1031 
1032     function updateMaxMint(uint256 _collectionId, uint256 _maxMint) public onlyOwner {
1033         _collectionsMap[_collectionId].maxMint = _maxMint;
1034     }
1035 
1036     function updateTier(uint256 _collectionId, uint256 _tier) public onlyOwner {
1037         _collectionsMap[_collectionId].tier = _tier;
1038     }
1039 
1040     function updateMaxMintPerMembershipTier(uint256 _collectionId, uint256[] memory _maxMintPerMembershipTier) public onlyOwner {
1041         _collectionsMap[_collectionId].maxMintPerMembershipTier = _maxMintPerMembershipTier;
1042     }
1043 
1044     function checkMint(
1045         address _sender,
1046         uint256 _collectionId,
1047         uint256 _membershipId,
1048         uint256 _value,
1049         uint256 _amount,
1050         bool _isEthPayment
1051     ) internal virtual {
1052         require(
1053             _collectionsMap[_collectionId].active == true,
1054             "GenHallCollection: the collection is still not active, and thus cannot be minted"
1055         );
1056 
1057         require(
1058             _collectionsMap[_collectionId].invocations <
1059                 _collectionsMap[_collectionId].maxInvocations,
1060             "GenHallCollection: max invocations was reached"
1061         );
1062 
1063         require(
1064             _amount <= _collectionsMap[_collectionId].maxMintPerTransaction,
1065             "GenHallCollection: mint amount is over max mint per transaction"
1066         );
1067 
1068         uint256 avaliableMints = _collectionsMap[_collectionId].maxMint;
1069 
1070         if (_collectionsMap[_collectionId].requiresMembership) {
1071             address _membershipOwner = _genHallInterface.ownerOf(_membershipId);
1072             require(
1073                 _membershipOwner == _sender,
1074                 "GenHallCollection: sender must be membership owner"
1075             );
1076             uint256 _tier = _genHallInterface.getMembershipTier(_membershipId);
1077             require(
1078                 _tier >= _collectionsMap[_collectionId].tier,
1079                 "GenHallCollection: no valid membership"
1080             );
1081             avaliableMints = getAllowedMintForMembership(
1082                 _collectionId,
1083                 _membershipId
1084             );
1085         }
1086         else{
1087             avaliableMints = _collectionsMap[_collectionId].maxMint - _collectionsMintMap[_collectionId][_msgSender()];
1088         }
1089 
1090         require(
1091             avaliableMints >= _amount,
1092             "GenHallCollection: not enough mints avaliable for your allowance"
1093         );
1094         if (_isEthPayment) {
1095             require(
1096                 _collectionsMap[_collectionId].price * _amount <= _value,
1097                 "GenHallCollection: incorrect amount sent"
1098             );
1099         } else {
1100             require(
1101                 _collectionsMap[_collectionId].priceGen * _amount <= _value,
1102                 "GenHallCollection: insufficient $GENHALL balance"
1103             );
1104         }
1105     }
1106 
1107     function mint(
1108         address _to,
1109         uint256 _collectionId,
1110         uint256 _membershipId
1111     ) public payable {
1112         checkMint(_msgSender(), _collectionId, _membershipId, msg.value, 1, true);
1113         updateMintState(_collectionId, _membershipId, 1);
1114         _mintOne(_to, _collectionId);
1115         splitFunds(_msgSender(), _collectionId, 1, true);
1116     }
1117 
1118     function mintGen(
1119         address _to,
1120         uint256 _collectionId,
1121         uint256 _membershipId
1122     ) public {
1123         bool _genAllowed = _genHallInterface.genAllowed();
1124         require(_genAllowed, "Mint with $GENHALL not allowed");
1125         uint256 balance = _genHallInterface.balanceOf(_msgSender());
1126         checkMint(_msgSender(), _collectionId, _membershipId, balance, 1, false);
1127         updateMintState(_collectionId, _membershipId, 1);
1128         _mintOne(_to, _collectionId);
1129         splitFunds(_msgSender(), _collectionId, 1, false);
1130     }
1131 
1132     function mintMany(
1133         address _to,
1134         uint256 _collectionId,
1135         uint256 _membershipId,
1136         uint256 _amount
1137     ) public payable {
1138         checkMint(
1139             _msgSender(),
1140             _collectionId,
1141             _membershipId,
1142             msg.value,
1143             _amount,
1144             true
1145         );
1146         updateMintState(_collectionId, _membershipId, _amount);
1147         _mintMany(_to, _collectionId, _amount);
1148         splitFunds(_msgSender(), _collectionId, _amount, true);
1149     }
1150 
1151     function mintManyGen(
1152         address _to,
1153         uint256 _collectionId,
1154         uint256 _membershipId,
1155         uint256 _amount
1156     ) public {
1157         bool _genAllowed = _genHallInterface.genAllowed();
1158         require(_genAllowed, "Mint with $GENHALL not allowed");
1159         uint256 balance = _genHallInterface.balanceOf(_msgSender());
1160         checkMint(
1161             _msgSender(),
1162             _collectionId,
1163             _membershipId,
1164             balance,
1165             _amount,
1166             false
1167         );
1168         updateMintState(_collectionId, _membershipId, _amount);
1169         _mintMany(_to, _collectionId, _amount);
1170         splitFunds(_msgSender(), _collectionId, _amount, false);
1171     }
1172 
1173     function _mintMany(
1174         address _to,
1175         uint256 _collectionId,
1176         uint256 _amount
1177     ) internal virtual {
1178         for (uint256 i = 0; i < _amount; i++) {
1179             _mintOne(_to, _collectionId);
1180         }
1181     }
1182 
1183     function _mintOne(address _to, uint256 _collectionId) internal virtual {
1184         uint256 invocation = _collectionsMap[_collectionId].invocations + 1;
1185         uint256 _tokenId = _collectionId * 100000 + invocation;
1186         _collectionsMap[_collectionId].invocations = invocation;
1187 
1188         bytes32 hash = keccak256(
1189             abi.encodePacked(invocation, block.number, block.difficulty, _to)
1190         );
1191         _tokenIdToHashMap[_tokenId] = hash;
1192         _tokenIdToCollectionIdMap[_tokenId] = _collectionId;
1193 
1194         _safeMint(_to, _tokenId);
1195 
1196         emit Mint(_to, _collectionId, _tokenId, hash);
1197     }
1198 
1199     function splitFunds(
1200         address _sender,
1201         uint256 _collectionId,
1202         uint256 _amount,
1203         bool _isEthPayment
1204     ) internal virtual {
1205         uint256 value = _isEthPayment
1206             ? _collectionsMap[_collectionId].price * _amount
1207             : _collectionsMap[_collectionId].priceGen * _amount;
1208         address _owner = owner();
1209         uint256 artistReward = (value *
1210             _collectionsMap[_collectionId].artistPercentage) / 100;
1211 
1212         if (_isEthPayment) {
1213             _collectionsMap[_collectionId].artistRewards += artistReward;
1214 
1215             for (uint i = 0; i < _collectionsMap[_collectionId].collaborators.length; i++) {
1216                 uint256 collaboratorShare = (value *
1217                     _collectionsMap[_collectionId].collaboratorPercentages[_collectionsMap[_collectionId].collaborators[i]]) / 100;
1218 
1219                 _collectionsMap[_collectionId].collaboratorShares[_collectionsMap[_collectionId].collaborators[i]] += collaboratorShare;
1220             }
1221         } else {
1222             // handle collaborators
1223             uint256 collaboratorSharesTotal = 0;
1224             for (uint i = 0; i < _collectionsMap[_collectionId].collaborators.length; i++) {
1225                 uint256 collaboratorShare = (value *
1226                     _collectionsMap[_collectionId].collaboratorPercentages[_collectionsMap[_collectionId].collaborators[i]]) / 100;
1227                 _genHallInterface.transferFrom(
1228                     _sender,
1229                     _collectionsMap[_collectionId].collaborators[i],
1230                     collaboratorShare
1231                 );
1232                 collaboratorSharesTotal += collaboratorShare;
1233             }
1234 
1235             // handle artist
1236             _genHallInterface.transferFrom(
1237                 _sender,
1238                 _collectionsMap[_collectionId].artist,
1239                 artistReward
1240             );
1241 
1242             // finally, handle owner who gets remaining
1243             _genHallInterface.transferFrom(
1244                 _sender,
1245                 _owner,
1246                 value - artistReward - collaboratorSharesTotal
1247             );
1248         }
1249     }
1250 
1251     function burn(uint256 _tokenId) public {
1252         _burn(_tokenId);
1253     }
1254 
1255     function getMaxMintPerTransaction(uint256 _collectionId) public view returns(uint256){
1256         return _collectionsMap[_collectionId].maxMintPerTransaction;
1257     }
1258 
1259     function getMaxMintForMembership(
1260         uint256 _collectionId,
1261         uint256 _membershipId
1262     ) public view returns (uint256) {
1263         uint256 _tier = _genHallInterface.getMembershipTier(_membershipId);
1264 
1265         return _tier < _collectionsMap[_collectionId].maxMintPerMembershipTier.length ?
1266             _collectionsMap[_collectionId].maxMintPerMembershipTier[_tier] :
1267             _collectionsMap[_collectionId].maxMintPerMembershipTier[_collectionsMap[_collectionId].maxMintPerMembershipTier.length - 1];
1268     }
1269 
1270     function getMembershipTier(uint256 _membershipId) public view returns(uint256) {
1271         return _genHallInterface.getMembershipTier(_membershipId);
1272     }
1273 
1274     function getAllowedMintForMembership(
1275         uint256 _collectionId,
1276         uint256 _membershipId
1277     ) public view returns (uint256) {
1278         return getMaxMintForMembership(_collectionId, _membershipId) - _collectionsMembershipMintMap[_collectionId][_membershipId];
1279     }
1280 
1281     function getMaxMintForNonMembership(uint256 _collectionId) public view returns(uint256) {
1282         return _collectionsMap[_collectionId].maxMint;
1283     }
1284 
1285     function remainingNonMembershipMint(uint256 _collectionId) public view returns(uint256) {
1286         return _collectionsMap[_collectionId].maxMint - _collectionsMintMap[_collectionId][_msgSender()];
1287     }
1288 
1289     function updateMintState(
1290         uint256 _collectionId,
1291         uint256 _membershipId,
1292         uint256 _amount
1293     ) internal virtual {
1294         if (_collectionsMap[_collectionId].requiresMembership) {
1295             _collectionsMembershipMintMap[_collectionId][_membershipId] =
1296                 _collectionsMembershipMintMap[_collectionId][_membershipId] +
1297                 _amount;
1298         } else {
1299             _collectionsMintMap[_collectionId][_msgSender()] =
1300                 _collectionsMintMap[_collectionId][_msgSender()] +
1301                 _amount;
1302         }
1303     }
1304 
1305     function updateArtistAddress(uint256 _collectionId, address _artist)
1306         public
1307         onlyArtist(_collectionId)
1308     {
1309         _collectionsMap[_collectionId].artist = _artist;
1310     }
1311 
1312     function updateMaxInvocations(
1313         uint256 _collectionId,
1314         uint256 _maxInvocations
1315     ) public onlyOwner {
1316         _collectionsMap[_collectionId].maxInvocations = _maxInvocations;
1317     }
1318 
1319     function updateScript(uint256 _collectionId, string memory _script)
1320         public
1321         onlyOwner
1322     {
1323         _collectionsMap[_collectionId].script = _script;
1324     }
1325 
1326     function upgradeGenHallInterfaceContract(address _genHallInterfaceAddress)
1327         public
1328         onlyOwner
1329     {
1330         _genHallInterface = IGenHallInterface(_genHallInterfaceAddress);
1331     }
1332 
1333     function updatePrice(
1334         uint256 _collectionId,
1335         uint256 _price,
1336         uint256 _priceGen
1337     ) public onlyOwner {
1338         _collectionsMap[_collectionId].price = _price;
1339         _collectionsMap[_collectionId].priceGen = _priceGen;
1340     }
1341 
1342     function getCollectionInfo(uint256 _collectionId)
1343         public
1344         view
1345         returns (
1346             uint256 invocations,
1347             uint256 maxInvocations,
1348             uint256 price,
1349             uint256 priceGen,
1350             address artist,
1351             uint256 artistPercentage,
1352             bool requiresMembership
1353         )
1354     {
1355         return (
1356             _collectionsMap[_collectionId].invocations,
1357             _collectionsMap[_collectionId].maxInvocations,
1358             _collectionsMap[_collectionId].price,
1359             _collectionsMap[_collectionId].priceGen,
1360             _collectionsMap[_collectionId].artist,
1361             _collectionsMap[_collectionId].artistPercentage,
1362             _collectionsMap[_collectionId].requiresMembership
1363         );
1364     }
1365 
1366     function getTokenInfo(uint256 _tokenId)
1367         public
1368         view
1369         returns (
1370             uint256,
1371             uint256,
1372             address,
1373             bytes32
1374         )
1375     {
1376         _exists(_tokenId);
1377         bytes32 hash = _tokenIdToHashMap[_tokenId];
1378         uint256 _collectionId = _tokenIdToCollectionIdMap[_tokenId];
1379         address owner = GenHallCollection.ownerOf(_tokenId);
1380 
1381         return (_tokenId, _collectionId, owner, hash);
1382     }
1383 
1384     function getTokensByOwner(address _owner)
1385         public
1386         view
1387         returns (uint256[] memory)
1388     {
1389         uint256 tokenCount = balanceOf(_owner);
1390         uint256[] memory tokenIds = new uint256[](tokenCount);
1391         for (uint256 i; i < tokenCount; i++) {
1392             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1393         }
1394 
1395         return tokenIds;
1396     }
1397 
1398     /**
1399      * @dev See {IERC165-supportsInterface}.
1400      */
1401     function supportsInterface(bytes4 interfaceId)
1402         public
1403         view
1404         virtual
1405         override(ERC165, IERC165)
1406         returns (bool)
1407     {
1408         return
1409             interfaceId == type(IERC721).interfaceId ||
1410             interfaceId == type(IERC721Metadata).interfaceId ||
1411             interfaceId == type(IERC721Enumerable).interfaceId ||
1412             super.supportsInterface(interfaceId);
1413     }
1414 
1415     /**
1416      * @dev See {IERC721-balanceOf}.
1417      */
1418     function balanceOf(address owner)
1419         public
1420         view
1421         virtual
1422         override
1423         returns (uint256)
1424     {
1425         require(
1426             owner != address(0),
1427             "ERC721: balance query for the zero address"
1428         );
1429         return _balances[owner];
1430     }
1431 
1432     /**
1433      * @dev See {IERC721-ownerOf}.
1434      */
1435     function ownerOf(uint256 tokenId)
1436         public
1437         view
1438         virtual
1439         override
1440         returns (address)
1441     {
1442         address owner = _owners[tokenId];
1443         require(
1444             owner != address(0),
1445             "ERC721: owner query for nonexistent token"
1446         );
1447         return owner;
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Metadata-name}.
1452      */
1453     function name() public view virtual override returns (string memory) {
1454         return _name;
1455     }
1456 
1457     /**
1458      * @dev See {IERC721Metadata-symbol}.
1459      */
1460     function symbol() public view virtual override returns (string memory) {
1461         return _symbol;
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Metadata-tokenURI}.
1466      */
1467     function tokenURI(uint256 tokenId)
1468         public
1469         view
1470         virtual
1471         override
1472         returns (string memory)
1473     {
1474         require(
1475             _exists(tokenId),
1476             "ERC721Metadata: URI query for nonexistent token"
1477         );
1478 
1479         string memory baseURI_ = baseURI();
1480         return
1481             bytes(baseURI_).length > 0
1482                 ? string(abi.encodePacked(baseURI_, tokenId.toString()))
1483                 : "";
1484     }
1485 
1486     /**
1487      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1488      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1489      * by default, can be overriden in child contracts.
1490      */
1491     function baseURI() internal view virtual returns (string memory) {
1492         return _baseURI;
1493     }
1494 
1495     /**
1496      * @dev Internal function to set the base URI for all token IDs. It is
1497      * automatically added as a prefix to the value returned in {tokenURI},
1498      * or to the token ID if {tokenURI} is empty.
1499      */
1500     function setBaseURI(string memory baseURI_) public onlyOwner {
1501         _baseURI = baseURI_;
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-approve}.
1506      */
1507     function approve(address to, uint256 tokenId) public virtual override {
1508         address owner = GenHallCollection.ownerOf(tokenId);
1509         require(to != owner, "ERC721: approval to current owner");
1510 
1511         require(
1512             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1513             "ERC721: approve caller is not owner nor approved for all"
1514         );
1515 
1516         _approve(to, tokenId);
1517     }
1518 
1519     /**
1520      * @dev See {IERC721-getApproved}.
1521      */
1522     function getApproved(uint256 tokenId)
1523         public
1524         view
1525         virtual
1526         override
1527         returns (address)
1528     {
1529         require(
1530             _exists(tokenId),
1531             "ERC721: approved query for nonexistent token"
1532         );
1533 
1534         return _tokenApprovals[tokenId];
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-setApprovalForAll}.
1539      */
1540     function setApprovalForAll(address operator, bool approved)
1541         public
1542         virtual
1543         override
1544     {
1545         require(operator != _msgSender(), "ERC721: approve to caller");
1546 
1547         _operatorApprovals[_msgSender()][operator] = approved;
1548         emit ApprovalForAll(_msgSender(), operator, approved);
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-isApprovedForAll}.
1553      */
1554     function isApprovedForAll(address owner, address operator)
1555         public
1556         view
1557         virtual
1558         override
1559         returns (bool)
1560     {
1561         return _operatorApprovals[owner][operator];
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-transferFrom}.
1566      */
1567     function transferFrom(
1568         address from,
1569         address to,
1570         uint256 tokenId
1571     ) public virtual override {
1572         //solhint-disable-next-line max-line-length
1573         require(
1574             _isApprovedOrOwner(_msgSender(), tokenId),
1575             "ERC721: transfer caller is not owner nor approved"
1576         );
1577 
1578         _transfer(from, to, tokenId);
1579     }
1580 
1581     /**
1582      * @dev See {IERC721-safeTransferFrom}.
1583      */
1584     function safeTransferFrom(
1585         address from,
1586         address to,
1587         uint256 tokenId
1588     ) public virtual override {
1589         safeTransferFrom(from, to, tokenId, "");
1590     }
1591 
1592     /**
1593      * @dev See {IERC721-safeTransferFrom}.
1594      */
1595     function safeTransferFrom(
1596         address from,
1597         address to,
1598         uint256 tokenId,
1599         bytes memory _data
1600     ) public virtual override {
1601         require(
1602             _isApprovedOrOwner(_msgSender(), tokenId),
1603             "ERC721: transfer caller is not owner nor approved"
1604         );
1605         _safeTransfer(from, to, tokenId, _data);
1606     }
1607 
1608     /**
1609      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1610      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1611      *
1612      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1613      *
1614      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1615      * implement alternative mechanisms to perform token transfer, such as signature-based.
1616      *
1617      * Requirements:
1618      *
1619      * - `from` cannot be the zero address.
1620      * - `to` cannot be the zero address.
1621      * - `tokenId` token must exist and be owned by `from`.
1622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1623      *
1624      * Emits a {Transfer} event.
1625      */
1626     function _safeTransfer(
1627         address from,
1628         address to,
1629         uint256 tokenId,
1630         bytes memory _data
1631     ) internal virtual {
1632         _transfer(from, to, tokenId);
1633         require(
1634             _checkOnERC721Received(from, to, tokenId, _data),
1635             "ERC721: transfer to non ERC721Receiver implementer"
1636         );
1637     }
1638 
1639     /**
1640      * @dev Returns whether `tokenId` exists.
1641      *
1642      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1643      *
1644      * Tokens start existing when they are minted (`_mint`),
1645      * and stop existing when they are burned (`_burn`).
1646      */
1647     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1648         return _owners[tokenId] != address(0);
1649     }
1650 
1651     /**
1652      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1653      *
1654      * Requirements:
1655      *
1656      * - `tokenId` must exist.
1657      */
1658     function _isApprovedOrOwner(address spender, uint256 tokenId)
1659         internal
1660         view
1661         virtual
1662         returns (bool)
1663     {
1664         require(
1665             _exists(tokenId),
1666             "ERC721: operator query for nonexistent token"
1667         );
1668         address owner = GenHallCollection.ownerOf(tokenId);
1669         return (spender == owner ||
1670             getApproved(tokenId) == spender ||
1671             isApprovedForAll(owner, spender));
1672     }
1673 
1674     /**
1675      * @dev Safely mints `tokenId` and transfers it to `to`.
1676      *
1677      * Requirements:
1678      *
1679      * - `tokenId` must not exist.
1680      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function _safeMint(address to, uint256 tokenId) internal virtual {
1685         _safeMint(to, tokenId, "");
1686     }
1687 
1688     /**
1689      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1690      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1691      */
1692     function _safeMint(
1693         address to,
1694         uint256 tokenId,
1695         bytes memory _data
1696     ) internal virtual {
1697         _mint(to, tokenId);
1698         require(
1699             _checkOnERC721Received(address(0), to, tokenId, _data),
1700             "ERC721: transfer to non ERC721Receiver implementer"
1701         );
1702     }
1703 
1704     /**
1705      * @dev Mints `tokenId` and transfers it to `to`.
1706      *
1707      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1708      *
1709      * Requirements:
1710      *
1711      * - `tokenId` must not exist.
1712      * - `to` cannot be the zero address.
1713      *
1714      * Emits a {Transfer} event.
1715      */
1716     function _mint(address to, uint256 tokenId) internal virtual {
1717         require(to != address(0), "ERC721: mint to the zero address");
1718         require(!_exists(tokenId), "ERC721: token already minted");
1719 
1720         _beforeTokenTransfer(address(0), to, tokenId);
1721 
1722         _balances[to] += 1;
1723         _owners[tokenId] = to;
1724 
1725         emit Transfer(address(0), to, tokenId);
1726     }
1727 
1728     /**
1729      * @dev Destroys `tokenId`.
1730      * The approval is cleared when the token is burned.
1731      *
1732      * Requirements:
1733      *
1734      * - `tokenId` must exist.
1735      *
1736      * Emits a {Transfer} event.
1737      */
1738     function _burn(uint256 tokenId) internal virtual {
1739         address owner = GenHallCollection.ownerOf(tokenId);
1740         require(
1741             _msgSender() == owner,
1742             "GenHallCollection: only token owner can burn"
1743         );
1744         _beforeTokenTransfer(owner, address(0), tokenId);
1745         // Clear approvals
1746         _approve(address(0), tokenId);
1747 
1748         _balances[owner] -= 1;
1749         delete _owners[tokenId];
1750 
1751         emit Transfer(owner, address(0), tokenId);
1752     }
1753 
1754     /**
1755      * @dev Transfers `tokenId` from `from` to `to`.
1756      *  As opposed to {transferFrom}, this imposes no restrictions on _msgSender().
1757      *
1758      * Requirements:
1759      *
1760      * - `to` cannot be the zero address.
1761      * - `tokenId` token must be owned by `from`.
1762      *
1763      * Emits a {Transfer} event.
1764      */
1765     function _transfer(
1766         address from,
1767         address to,
1768         uint256 tokenId
1769     ) internal virtual {
1770         require(
1771             GenHallCollection.ownerOf(tokenId) == from,
1772             "ERC721: transfer of token that is not own"
1773         );
1774         require(to != address(0), "ERC721: transfer to the zero address");
1775 
1776         _beforeTokenTransfer(from, to, tokenId);
1777 
1778         // Clear approvals from the previous owner
1779         _approve(address(0), tokenId);
1780 
1781         _balances[from] -= 1;
1782         _balances[to] += 1;
1783         _owners[tokenId] = to;
1784 
1785         emit Transfer(from, to, tokenId);
1786     }
1787 
1788     /**
1789      * @dev Approve `to` to operate on `tokenId`
1790      *
1791      * Emits a {Approval} event.
1792      */
1793     function _approve(address to, uint256 tokenId) internal virtual {
1794         _tokenApprovals[tokenId] = to;
1795         emit Approval(GenHallCollection.ownerOf(tokenId), to, tokenId);
1796     }
1797 
1798     /**
1799      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1800      * The call is not executed if the target address is not a contract.
1801      *
1802      * @param from address representing the previous owner of the given token ID
1803      * @param to target address that will receive the tokens
1804      * @param tokenId uint256 ID of the token to be transferred
1805      * @param _data bytes optional data to send along with the call
1806      * @return bool whether the call correctly returned the expected magic value
1807      */
1808     function _checkOnERC721Received(
1809         address from,
1810         address to,
1811         uint256 tokenId,
1812         bytes memory _data
1813     ) private returns (bool) {
1814         if (to.isContract()) {
1815             try
1816                 IERC721Receiver(to).onERC721Received(
1817                     _msgSender(),
1818                     from,
1819                     tokenId,
1820                     _data
1821                 )
1822             returns (bytes4 retval) {
1823                 return retval == IERC721Receiver.onERC721Received.selector;
1824             } catch (bytes memory reason) {
1825                 if (reason.length == 0) {
1826                     revert(
1827                         "ERC721: transfer to non ERC721Receiver implementer"
1828                     );
1829                 } else {
1830                     assembly {
1831                         revert(add(32, reason), mload(reason))
1832                     }
1833                 }
1834             }
1835         } else {
1836             return true;
1837         }
1838     }
1839 
1840     /**
1841      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1842      */
1843     function tokenOfOwnerByIndex(address owner, uint256 index)
1844         public
1845         view
1846         virtual
1847         override
1848         returns (uint256)
1849     {
1850         require(
1851             index < GenHallCollection.balanceOf(owner),
1852             "ERC721Enumerable: owner index out of bounds"
1853         );
1854         return _ownedTokens[owner][index];
1855     }
1856 
1857     /**
1858      * @dev See {IERC721Enumerable-totalSupply}.
1859      */
1860     function totalSupply() public view virtual override returns (uint256) {
1861         return _allTokens.length;
1862     }
1863 
1864     /**
1865      * @dev See {IERC721Enumerable-tokenByIndex}.
1866      */
1867     function tokenByIndex(uint256 index)
1868         public
1869         view
1870         virtual
1871         override
1872         returns (uint256)
1873     {
1874         require(
1875             index < GenHallCollection.totalSupply(),
1876             "ERC721Enumerable: global index out of bounds"
1877         );
1878         return _allTokens[index];
1879     }
1880 
1881     /**
1882      * @dev Hook that is called before any token transfer. This includes minting
1883      * and burning.
1884      *
1885      * Calling conditions:
1886      *
1887      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1888      * transferred to `to`.
1889      * - When `from` is zero, `tokenId` will be minted for `to`.
1890      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1891      * - `from` cannot be the zero address.
1892      * - `to` cannot be the zero address.
1893      *
1894      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1895      */
1896     function _beforeTokenTransfer(
1897         address from,
1898         address to,
1899         uint256 tokenId
1900     ) internal virtual {
1901         if (from == address(0)) {
1902             _addTokenToAllTokensEnumeration(tokenId);
1903         } else if (from != to) {
1904             _removeTokenFromOwnerEnumeration(from, tokenId);
1905         }
1906         if (to == address(0)) {
1907             _removeTokenFromAllTokensEnumeration(tokenId);
1908         } else if (to != from) {
1909             _addTokenToOwnerEnumeration(to, tokenId);
1910         }
1911     }
1912 
1913     /**
1914      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1915      * @param to address representing the new owner of the given token ID
1916      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1917      */
1918     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1919         uint256 length = GenHallCollection.balanceOf(to);
1920         _ownedTokens[to][length] = tokenId;
1921         _ownedTokensIndex[tokenId] = length;
1922     }
1923 
1924     /**
1925      * @dev Private function to add a token to this extension's token tracking data structures.
1926      * @param tokenId uint256 ID of the token to be added to the tokens list
1927      */
1928     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1929         _allTokensIndex[tokenId] = _allTokens.length;
1930         _allTokens.push(tokenId);
1931     }
1932 
1933     /**
1934      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1935      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1936      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1937      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1938      * @param from address representing the previous owner of the given token ID
1939      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1940      */
1941     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1942         private
1943     {
1944         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1945         // then delete the last slot (swap and pop).
1946 
1947         uint256 lastTokenIndex = GenHallCollection.balanceOf(from) - 1;
1948         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1949 
1950         // When the token to delete is the last token, the swap operation is unnecessary
1951         if (tokenIndex != lastTokenIndex) {
1952             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1953 
1954             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1955             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1956         }
1957 
1958         // This also deletes the contents at the last position of the array
1959         delete _ownedTokensIndex[tokenId];
1960         delete _ownedTokens[from][lastTokenIndex];
1961     }
1962 
1963     /**
1964      * @dev Private function to remove a token from this extension's token tracking data structures.
1965      * This has O(1) time complexity, but alters the order of the _allTokens array.
1966      * @param tokenId uint256 ID of the token to be removed from the tokens list
1967      */
1968     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1969         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1970         // then delete the last slot (swap and pop).
1971 
1972         uint256 lastTokenIndex = _allTokens.length - 1;
1973         uint256 tokenIndex = _allTokensIndex[tokenId];
1974 
1975         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1976         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1977         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1978         uint256 lastTokenId = _allTokens[lastTokenIndex];
1979 
1980         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1981         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1982 
1983         // This also deletes the contents at the last position of the array
1984         delete _allTokensIndex[tokenId];
1985         _allTokens.pop();
1986     }
1987 }