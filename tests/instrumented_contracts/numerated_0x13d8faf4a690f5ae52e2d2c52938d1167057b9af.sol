1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 pragma abicoder v2;
5 
6 
7 // 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // 
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _transferOwnership(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Internal function without access restriction.
93      */
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 // 
102 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
103 /**
104  * @title Counters
105  * @author Matt Condon (@shrugs)
106  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
107  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
108  *
109  * Include with `using Counters for Counters.Counter;`
110  */
111 library Counters {
112     struct Counter {
113         // This variable should never be directly accessed by users of the library: interactions must be restricted to
114         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
115         // this feature: see https://github.com/ethereum/solidity/issues/4637
116         uint256 _value; // default: 0
117     }
118 
119     function current(Counter storage counter) internal view returns (uint256) {
120         return counter._value;
121     }
122 
123     function increment(Counter storage counter) internal {
124         unchecked {
125             counter._value += 1;
126         }
127     }
128 
129     function decrement(Counter storage counter) internal {
130         uint256 value = counter._value;
131         require(value > 0, "Counter: decrement overflow");
132         unchecked {
133             counter._value = value - 1;
134         }
135     }
136 
137     function reset(Counter storage counter) internal {
138         counter._value = 0;
139     }
140 }
141 
142 // 
143 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
144 /**
145  * @dev Contract module which allows children to implement an emergency stop
146  * mechanism that can be triggered by an authorized account.
147  *
148  * This module is used through inheritance. It will make available the
149  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
150  * the functions of your contract. Note that they will not be pausable by
151  * simply including this module, only once the modifiers are put in place.
152  */
153 abstract contract Pausable is Context {
154     /**
155      * @dev Emitted when the pause is triggered by `account`.
156      */
157     event Paused(address account);
158 
159     /**
160      * @dev Emitted when the pause is lifted by `account`.
161      */
162     event Unpaused(address account);
163 
164     bool private _paused;
165 
166     /**
167      * @dev Initializes the contract in unpaused state.
168      */
169     constructor() {
170         _paused = false;
171     }
172 
173     /**
174      * @dev Returns true if the contract is paused, and false otherwise.
175      */
176     function paused() public view virtual returns (bool) {
177         return _paused;
178     }
179 
180     /**
181      * @dev Modifier to make a function callable only when the contract is not paused.
182      *
183      * Requirements:
184      *
185      * - The contract must not be paused.
186      */
187     modifier whenNotPaused() {
188         require(!paused(), "Pausable: paused");
189         _;
190     }
191 
192     /**
193      * @dev Modifier to make a function callable only when the contract is paused.
194      *
195      * Requirements:
196      *
197      * - The contract must be paused.
198      */
199     modifier whenPaused() {
200         require(paused(), "Pausable: not paused");
201         _;
202     }
203 
204     /**
205      * @dev Triggers stopped state.
206      *
207      * Requirements:
208      *
209      * - The contract must not be paused.
210      */
211     function _pause() internal virtual whenNotPaused {
212         _paused = true;
213         emit Paused(_msgSender());
214     }
215 
216     /**
217      * @dev Returns to normal state.
218      *
219      * Requirements:
220      *
221      * - The contract must be paused.
222      */
223     function _unpause() internal virtual whenPaused {
224         _paused = false;
225         emit Unpaused(_msgSender());
226     }
227 }
228 
229 // 
230 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
231 // CAUTION
232 // This version of SafeMath should only be used with Solidity 0.8 or later,
233 // because it relies on the compiler's built in overflow checks.
234 /**
235  * @dev Wrappers over Solidity's arithmetic operations.
236  *
237  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
238  * now has built in overflow checking.
239  */
240 library SafeMath {
241     /**
242      * @dev Returns the addition of two unsigned integers, with an overflow flag.
243      *
244      * _Available since v3.4._
245      */
246     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         unchecked {
248             uint256 c = a + b;
249             if (c < a) return (false, 0);
250             return (true, c);
251         }
252     }
253 
254     /**
255      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
256      *
257      * _Available since v3.4._
258      */
259     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             if (b > a) return (false, 0);
262             return (true, a - b);
263         }
264     }
265 
266     /**
267      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
268      *
269      * _Available since v3.4._
270      */
271     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
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
288     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
289         unchecked {
290             if (b == 0) return (false, 0);
291             return (true, a / b);
292         }
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
297      *
298      * _Available since v3.4._
299      */
300     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
301         unchecked {
302             if (b == 0) return (false, 0);
303             return (true, a % b);
304         }
305     }
306 
307     /**
308      * @dev Returns the addition of two unsigned integers, reverting on
309      * overflow.
310      *
311      * Counterpart to Solidity's `+` operator.
312      *
313      * Requirements:
314      *
315      * - Addition cannot overflow.
316      */
317     function add(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a + b;
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting on
323      * overflow (when the result is negative).
324      *
325      * Counterpart to Solidity's `-` operator.
326      *
327      * Requirements:
328      *
329      * - Subtraction cannot overflow.
330      */
331     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332         return a - b;
333     }
334 
335     /**
336      * @dev Returns the multiplication of two unsigned integers, reverting on
337      * overflow.
338      *
339      * Counterpart to Solidity's `*` operator.
340      *
341      * Requirements:
342      *
343      * - Multiplication cannot overflow.
344      */
345     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
346         return a * b;
347     }
348 
349     /**
350      * @dev Returns the integer division of two unsigned integers, reverting on
351      * division by zero. The result is rounded towards zero.
352      *
353      * Counterpart to Solidity's `/` operator.
354      *
355      * Requirements:
356      *
357      * - The divisor cannot be zero.
358      */
359     function div(uint256 a, uint256 b) internal pure returns (uint256) {
360         return a / b;
361     }
362 
363     /**
364      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
365      * reverting when dividing by zero.
366      *
367      * Counterpart to Solidity's `%` operator. This function uses a `revert`
368      * opcode (which leaves remaining gas untouched) while Solidity uses an
369      * invalid opcode to revert (consuming all remaining gas).
370      *
371      * Requirements:
372      *
373      * - The divisor cannot be zero.
374      */
375     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
376         return a % b;
377     }
378 
379     /**
380      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
381      * overflow (when the result is negative).
382      *
383      * CAUTION: This function is deprecated because it requires allocating memory for the error
384      * message unnecessarily. For custom revert reasons use {trySub}.
385      *
386      * Counterpart to Solidity's `-` operator.
387      *
388      * Requirements:
389      *
390      * - Subtraction cannot overflow.
391      */
392     function sub(
393         uint256 a,
394         uint256 b,
395         string memory errorMessage
396     ) internal pure returns (uint256) {
397         unchecked {
398             require(b <= a, errorMessage);
399             return a - b;
400         }
401     }
402 
403     /**
404      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
405      * division by zero. The result is rounded towards zero.
406      *
407      * Counterpart to Solidity's `/` operator. Note: this function uses a
408      * `revert` opcode (which leaves remaining gas untouched) while Solidity
409      * uses an invalid opcode to revert (consuming all remaining gas).
410      *
411      * Requirements:
412      *
413      * - The divisor cannot be zero.
414      */
415     function div(
416         uint256 a,
417         uint256 b,
418         string memory errorMessage
419     ) internal pure returns (uint256) {
420         unchecked {
421             require(b > 0, errorMessage);
422             return a / b;
423         }
424     }
425 
426     /**
427      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
428      * reverting with custom message when dividing by zero.
429      *
430      * CAUTION: This function is deprecated because it requires allocating memory for the error
431      * message unnecessarily. For custom revert reasons use {tryMod}.
432      *
433      * Counterpart to Solidity's `%` operator. This function uses a `revert`
434      * opcode (which leaves remaining gas untouched) while Solidity uses an
435      * invalid opcode to revert (consuming all remaining gas).
436      *
437      * Requirements:
438      *
439      * - The divisor cannot be zero.
440      */
441     function mod(
442         uint256 a,
443         uint256 b,
444         string memory errorMessage
445     ) internal pure returns (uint256) {
446         unchecked {
447             require(b > 0, errorMessage);
448             return a % b;
449         }
450     }
451 }
452 
453 // 
454 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
455 /**
456  * @title ERC721 token receiver interface
457  * @dev Interface for any contract that wants to support safeTransfers
458  * from ERC721 asset contracts.
459  */
460 interface IERC721Receiver {
461     /**
462      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
463      * by `operator` from `from`, this function is called.
464      *
465      * It must return its Solidity selector to confirm the token transfer.
466      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
467      *
468      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
469      */
470     function onERC721Received(
471         address operator,
472         address from,
473         uint256 tokenId,
474         bytes calldata data
475     ) external returns (bytes4);
476 }
477 
478 // 
479 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
480 /**
481  * @dev Interface of the ERC165 standard, as defined in the
482  * https://eips.ethereum.org/EIPS/eip-165[EIP].
483  *
484  * Implementers can declare support of contract interfaces, which can then be
485  * queried by others ({ERC165Checker}).
486  *
487  * For an implementation, see {ERC165}.
488  */
489 interface IERC165 {
490     /**
491      * @dev Returns true if this contract implements the interface defined by
492      * `interfaceId`. See the corresponding
493      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
494      * to learn more about how these ids are created.
495      *
496      * This function call must use less than 30 000 gas.
497      */
498     function supportsInterface(bytes4 interfaceId) external view returns (bool);
499 }
500 
501 // 
502 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
503 /**
504  * @dev _Available since v3.1._
505  */
506 interface IERC1155Receiver is IERC165 {
507     /**
508      * @dev Handles the receipt of a single ERC1155 token type. This function is
509      * called at the end of a `safeTransferFrom` after the balance has been updated.
510      *
511      * NOTE: To accept the transfer, this must return
512      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
513      * (i.e. 0xf23a6e61, or its own function selector).
514      *
515      * @param operator The address which initiated the transfer (i.e. msg.sender)
516      * @param from The address which previously owned the token
517      * @param id The ID of the token being transferred
518      * @param value The amount of tokens being transferred
519      * @param data Additional data with no specified format
520      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
521      */
522     function onERC1155Received(
523         address operator,
524         address from,
525         uint256 id,
526         uint256 value,
527         bytes calldata data
528     ) external returns (bytes4);
529 
530     /**
531      * @dev Handles the receipt of a multiple ERC1155 token types. This function
532      * is called at the end of a `safeBatchTransferFrom` after the balances have
533      * been updated.
534      *
535      * NOTE: To accept the transfer(s), this must return
536      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
537      * (i.e. 0xbc197c81, or its own function selector).
538      *
539      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
540      * @param from The address which previously owned the token
541      * @param ids An array containing ids of each token being transferred (order and length must match values array)
542      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
543      * @param data Additional data with no specified format
544      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
545      */
546     function onERC1155BatchReceived(
547         address operator,
548         address from,
549         uint256[] calldata ids,
550         uint256[] calldata values,
551         bytes calldata data
552     ) external returns (bytes4);
553 }
554 
555 // 
556 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
557 /**
558  * @dev Contract module that helps prevent reentrant calls to a function.
559  *
560  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
561  * available, which can be applied to functions to make sure there are no nested
562  * (reentrant) calls to them.
563  *
564  * Note that because there is a single `nonReentrant` guard, functions marked as
565  * `nonReentrant` may not call one another. This can be worked around by making
566  * those functions `private`, and then adding `external` `nonReentrant` entry
567  * points to them.
568  *
569  * TIP: If you would like to learn more about reentrancy and alternative ways
570  * to protect against it, check out our blog post
571  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
572  */
573 abstract contract ReentrancyGuard {
574     // Booleans are more expensive than uint256 or any type that takes up a full
575     // word because each write operation emits an extra SLOAD to first read the
576     // slot's contents, replace the bits taken up by the boolean, and then write
577     // back. This is the compiler's defense against contract upgrades and
578     // pointer aliasing, and it cannot be disabled.
579 
580     // The values being non-zero value makes deployment a bit more expensive,
581     // but in exchange the refund on every call to nonReentrant will be lower in
582     // amount. Since refunds are capped to a percentage of the total
583     // transaction's gas, it is best to keep them low in cases like this one, to
584     // increase the likelihood of the full refund coming into effect.
585     uint256 private constant _NOT_ENTERED = 1;
586     uint256 private constant _ENTERED = 2;
587 
588     uint256 private _status;
589 
590     constructor() {
591         _status = _NOT_ENTERED;
592     }
593 
594     /**
595      * @dev Prevents a contract from calling itself, directly or indirectly.
596      * Calling a `nonReentrant` function from another `nonReentrant`
597      * function is not supported. It is possible to prevent this from happening
598      * by making the `nonReentrant` function external, and making it call a
599      * `private` function that does the actual work.
600      */
601     modifier nonReentrant() {
602         // On the first call to nonReentrant, _notEntered will be true
603         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
604 
605         // Any calls to nonReentrant after this point will fail
606         _status = _ENTERED;
607 
608         _;
609 
610         // By storing the original value once again, a refund is triggered (see
611         // https://eips.ethereum.org/EIPS/eip-2200)
612         _status = _NOT_ENTERED;
613     }
614 }
615 
616 // 
617 //Interface
618 abstract contract ERC20Interface {
619   function transferFrom(address from, address to, uint256 tokenId) public virtual;
620   function transfer(address recipient, uint256 amount) public virtual;
621 }
622 
623 abstract contract ERC721Interface {
624   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual;
625   function balanceOf(address owner) public virtual view returns (uint256 balance) ;
626 }
627 
628 abstract contract ERC1155Interface {
629   function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public virtual;
630 }
631 
632 abstract contract customInterface {
633   function bridgeSafeTransferFrom(address dapp, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public virtual;
634 }
635 
636 contract BatchSwap is Ownable, Pausable, ReentrancyGuard, IERC721Receiver, IERC1155Receiver {
637     address constant ERC20      = 0x90b7cf88476cc99D295429d4C1Bb1ff52448abeE;
638     address constant ERC721     = 0x58874d2951524F7f851bbBE240f0C3cF0b992d79;
639     address constant ERC1155    = 0xEDfdd7266667D48f3C9aB10194C3d325813d8c39;
640 
641     address public TRADESQUAD = 0xdbD4264248e2f814838702E0CB3015AC3a7157a1;
642     address payable public VAULT = payable(0x48c45a687173ec396353cD1E507B26Fa4F6Ff6D9);
643 
644     mapping (address => address) dappRelations;
645 
646     mapping (address => bool) whiteList;
647     
648     using Counters for Counters.Counter;
649     using SafeMath for uint256;
650 
651     uint256 constant secs = 86400;
652     
653     Counters.Counter private _swapIds;
654 
655     // Flag for the createSwap
656     bool private swapFlag;
657     
658     // Swap Struct
659     struct swapStruct {
660         address dapp;
661         address typeStd;
662         uint256[] tokenId;
663         uint256[] blc;
664         bytes data;
665     }
666     
667     // Swap Status
668     enum swapStatus { Opened, Closed, Cancelled }
669     
670     // SwapIntent Struct
671     struct swapIntent {
672         uint256 id;
673         address payable addressOne;
674         uint256 valueOne;
675         address payable addressTwo;
676         uint256 valueTwo;
677         uint256 swapStart;
678         uint256 swapEnd;
679         uint256 swapFee;
680         swapStatus status;
681     }
682     
683     // NFT Mapping
684     mapping(uint256 => swapStruct[]) nftsOne;
685     mapping(uint256 => swapStruct[]) nftsTwo;
686 
687     // Struct Payment
688     struct paymentStruct {
689         bool status;
690         uint256 value;
691     }
692     
693     // Mapping key/value for get the swap infos
694     mapping (address => swapIntent[]) swapList;
695     mapping (uint256 => uint256) swapMatch;
696     
697     // Struct for the payment rules
698     paymentStruct payment;
699 
700     // Checks
701     mapping(uint256 => address) checksCreator;
702     mapping(uint256 => address) checksCounterparty;
703     
704     
705     // Events
706     event swapEvent(address indexed _creator, uint256 indexed time, swapStatus indexed _status, uint256 _swapId, address _swapCounterPart);
707     event paymentReceived(address indexed _payer, uint256 _value);
708 
709     receive() external payable { 
710         emit paymentReceived(msg.sender, msg.value);
711     }
712     
713     // Create Swap
714     function createSwapIntent(swapIntent memory _swapIntent, swapStruct[] memory _nftsOne, swapStruct[] memory _nftsTwo) payable public whenNotPaused nonReentrant {
715         if(payment.status) {
716             if(ERC721Interface(TRADESQUAD).balanceOf(msg.sender)==0) {
717                 require(msg.value>=payment.value.add(_swapIntent.valueOne), "Not enought WEI for handle the transaction");
718                 _swapIntent.swapFee = getWeiPayValueAmount() ;
719             }
720             else {
721                 require(msg.value>=_swapIntent.valueOne, "Not enought WEI for handle the transaction");
722                 _swapIntent.swapFee = 0 ;
723             }
724         }
725         else
726             require(msg.value>=_swapIntent.valueOne, "Not enought WEI for handle the transaction");
727 
728         _swapIntent.addressOne = payable(msg.sender);
729         _swapIntent.id = _swapIds.current();
730         checksCreator[_swapIntent.id] = _swapIntent.addressOne ;
731         checksCounterparty[_swapIntent.id] = _swapIntent.addressTwo ;
732         _swapIntent.swapStart = block.timestamp;
733         _swapIntent.swapEnd = 0;
734         _swapIntent.status = swapStatus.Opened ;
735 
736         swapMatch[_swapIds.current()] = swapList[msg.sender].length;
737         swapList[msg.sender].push(_swapIntent);
738         
739         uint256 i;
740         for(i=0; i<_nftsOne.length; i++)
741             nftsOne[_swapIntent.id].push(_nftsOne[i]);
742             
743         for(i=0; i<_nftsTwo.length; i++)
744             nftsTwo[_swapIntent.id].push(_nftsTwo[i]);
745         
746         for(i=0; i<nftsOne[_swapIntent.id].length; i++) {
747             require(whiteList[nftsOne[_swapIntent.id][i].dapp], "A DAPP is not handled by the system");
748             if(nftsOne[_swapIntent.id][i].typeStd == ERC20) {
749                 ERC20Interface(nftsOne[_swapIntent.id][i].dapp).transferFrom(_swapIntent.addressOne, address(this), nftsOne[_swapIntent.id][i].blc[0]);
750             }
751             else if(nftsOne[_swapIntent.id][i].typeStd == ERC721) {
752                 ERC721Interface(nftsOne[_swapIntent.id][i].dapp).safeTransferFrom(_swapIntent.addressOne, address(this), nftsOne[_swapIntent.id][i].tokenId[0], nftsOne[_swapIntent.id][i].data);
753             }
754             else if(nftsOne[_swapIntent.id][i].typeStd == ERC1155) {
755                 ERC1155Interface(nftsOne[_swapIntent.id][i].dapp).safeBatchTransferFrom(_swapIntent.addressOne, address(this), nftsOne[_swapIntent.id][i].tokenId, nftsOne[_swapIntent.id][i].blc, nftsOne[_swapIntent.id][i].data);
756             }
757             else {
758                 customInterface(dappRelations[nftsOne[_swapIntent.id][i].dapp]).bridgeSafeTransferFrom(nftsOne[_swapIntent.id][i].dapp, _swapIntent.addressOne, dappRelations[nftsOne[_swapIntent.id][i].dapp], nftsOne[_swapIntent.id][i].tokenId, nftsOne[_swapIntent.id][i].blc, nftsOne[_swapIntent.id][i].data);
759             }
760         }
761 
762         emit swapEvent(msg.sender, (block.timestamp-(block.timestamp%secs)), _swapIntent.status, _swapIntent.id, _swapIntent.addressTwo);
763         _swapIds.increment();
764     }
765     
766     // Close the swap
767     function closeSwapIntent(address _swapCreator, uint256 _swapId) payable public whenNotPaused nonReentrant {
768         require(checksCounterparty[_swapId] == msg.sender, "You're not the interested counterpart");    
769         require(swapList[_swapCreator][swapMatch[_swapId]].status == swapStatus.Opened, "Swap Status is not opened");
770         require(swapList[_swapCreator][swapMatch[_swapId]].addressTwo == msg.sender, "You're not the interested counterpart"); 
771 
772         if(payment.status) {
773             if(ERC721Interface(TRADESQUAD).balanceOf(msg.sender)==0) {
774                 require(msg.value>=payment.value.add(swapList[_swapCreator][swapMatch[_swapId]].valueTwo), "Not enought WEI for handle the transaction");
775                 // Move the fees to the vault
776                 if(payment.value.add(swapList[_swapCreator][swapMatch[_swapId]].swapFee) > 0)
777                     VAULT.transfer(payment.value.add(swapList[_swapCreator][swapMatch[_swapId]].swapFee));
778             }
779             else {
780                 require(msg.value>=swapList[_swapCreator][swapMatch[_swapId]].valueTwo, "Not enought WEI for handle the transaction");
781                 if(swapList[_swapCreator][swapMatch[_swapId]].swapFee>0)
782                     VAULT.transfer(swapList[_swapCreator][swapMatch[_swapId]].swapFee);
783             }
784         }
785         else
786             require(msg.value>=swapList[_swapCreator][swapMatch[_swapId]].valueTwo, "Not enought WEI for handle the transaction");
787         
788         swapList[_swapCreator][swapMatch[_swapId]].addressTwo = payable(msg.sender);
789         swapList[_swapCreator][swapMatch[_swapId]].swapEnd = block.timestamp;
790         swapList[_swapCreator][swapMatch[_swapId]].status = swapStatus.Closed;
791         
792         //From Owner 1 to Owner 2
793         uint256 i;
794         for(i=0; i<nftsOne[_swapId].length; i++) {
795             require(whiteList[nftsOne[_swapId][i].dapp], "A DAPP is not handled by the system");
796             if(nftsOne[_swapId][i].typeStd == ERC20) {
797                 ERC20Interface(nftsOne[_swapId][i].dapp).transfer(swapList[_swapCreator][swapMatch[_swapId]].addressTwo, nftsOne[_swapId][i].blc[0]);
798             }
799             else if(nftsOne[_swapId][i].typeStd == ERC721) {
800                 ERC721Interface(nftsOne[_swapId][i].dapp).safeTransferFrom(address(this), swapList[_swapCreator][swapMatch[_swapId]].addressTwo, nftsOne[_swapId][i].tokenId[0], nftsOne[_swapId][i].data);
801             }
802             else if(nftsOne[_swapId][i].typeStd == ERC1155) {
803                 ERC1155Interface(nftsOne[_swapId][i].dapp).safeBatchTransferFrom(address(this), swapList[_swapCreator][swapMatch[_swapId]].addressTwo, nftsOne[_swapId][i].tokenId, nftsOne[_swapId][i].blc, nftsOne[_swapId][i].data);
804             }
805             else {
806                 customInterface(dappRelations[nftsOne[_swapId][i].dapp]).bridgeSafeTransferFrom(nftsOne[_swapId][i].dapp, dappRelations[nftsOne[_swapId][i].dapp], swapList[_swapCreator][swapMatch[_swapId]].addressTwo, nftsOne[_swapId][i].tokenId, nftsOne[_swapId][i].blc, nftsOne[_swapId][i].data);
807             }
808         }
809         if(swapList[_swapCreator][swapMatch[_swapId]].valueOne > 0)
810             swapList[_swapCreator][swapMatch[_swapId]].addressTwo.transfer(swapList[_swapCreator][swapMatch[_swapId]].valueOne);
811         
812         //From Owner 2 to Owner 1
813         for(i=0; i<nftsTwo[_swapId].length; i++) {
814             require(whiteList[nftsTwo[_swapId][i].dapp], "A DAPP is not handled by the system");
815             if(nftsTwo[_swapId][i].typeStd == ERC20) {
816                 ERC20Interface(nftsTwo[_swapId][i].dapp).transferFrom(swapList[_swapCreator][swapMatch[_swapId]].addressTwo, swapList[_swapCreator][swapMatch[_swapId]].addressOne, nftsTwo[_swapId][i].blc[0]);
817             }
818             else if(nftsTwo[_swapId][i].typeStd == ERC721) {
819                 ERC721Interface(nftsTwo[_swapId][i].dapp).safeTransferFrom(swapList[_swapCreator][swapMatch[_swapId]].addressTwo, swapList[_swapCreator][swapMatch[_swapId]].addressOne, nftsTwo[_swapId][i].tokenId[0], nftsTwo[_swapId][i].data);
820             }
821             else if(nftsTwo[_swapId][i].typeStd == ERC1155) {
822                 ERC1155Interface(nftsTwo[_swapId][i].dapp).safeBatchTransferFrom(swapList[_swapCreator][swapMatch[_swapId]].addressTwo, swapList[_swapCreator][swapMatch[_swapId]].addressOne, nftsTwo[_swapId][i].tokenId, nftsTwo[_swapId][i].blc, nftsTwo[_swapId][i].data);
823             }
824             else {
825                 customInterface(dappRelations[nftsTwo[_swapId][i].dapp]).bridgeSafeTransferFrom(nftsTwo[_swapId][i].dapp, swapList[_swapCreator][swapMatch[_swapId]].addressTwo, swapList[_swapCreator][swapMatch[_swapId]].addressOne, nftsTwo[_swapId][i].tokenId, nftsTwo[_swapId][i].blc, nftsTwo[_swapId][i].data);
826             }
827         }
828         if(swapList[_swapCreator][swapMatch[_swapId]].valueTwo>0)
829             swapList[_swapCreator][swapMatch[_swapId]].addressOne.transfer(swapList[_swapCreator][swapMatch[_swapId]].valueTwo);
830 
831         emit swapEvent(msg.sender, (block.timestamp-(block.timestamp%secs)), swapStatus.Closed, _swapId, _swapCreator);
832     }
833 
834     // Cancel Swap
835     function cancelSwapIntent(uint256 _swapId) public nonReentrant {
836         require(checksCreator[_swapId] == msg.sender, "You're not the interested counterpart");
837         require(swapList[msg.sender][swapMatch[_swapId]].addressOne == msg.sender, "You're not the interested counterpart");   
838         require(swapList[msg.sender][swapMatch[_swapId]].status == swapStatus.Opened, "Swap Status is not opened");
839 
840         //Rollback
841         if(swapList[msg.sender][swapMatch[_swapId]].swapFee>0)
842             payable(msg.sender).transfer(swapList[msg.sender][swapMatch[_swapId]].swapFee);
843         uint256 i;
844         for(i=0; i<nftsOne[_swapId].length; i++) {
845             if(nftsOne[_swapId][i].typeStd == ERC20) {
846                 ERC20Interface(nftsOne[_swapId][i].dapp).transfer(swapList[msg.sender][swapMatch[_swapId]].addressOne, nftsOne[_swapId][i].blc[0]);
847             }
848             else if(nftsOne[_swapId][i].typeStd == ERC721) {
849                 ERC721Interface(nftsOne[_swapId][i].dapp).safeTransferFrom(address(this), swapList[msg.sender][swapMatch[_swapId]].addressOne, nftsOne[_swapId][i].tokenId[0], nftsOne[_swapId][i].data);
850             }
851             else if(nftsOne[_swapId][i].typeStd == ERC1155) {
852                 ERC1155Interface(nftsOne[_swapId][i].dapp).safeBatchTransferFrom(address(this), swapList[msg.sender][swapMatch[_swapId]].addressOne, nftsOne[_swapId][i].tokenId, nftsOne[_swapId][i].blc, nftsOne[_swapId][i].data);
853             }
854             else {
855                 customInterface(dappRelations[nftsOne[_swapId][i].dapp]).bridgeSafeTransferFrom(nftsOne[_swapId][i].dapp, dappRelations[nftsOne[_swapId][i].dapp], swapList[msg.sender][swapMatch[_swapId]].addressOne, nftsOne[_swapId][i].tokenId, nftsOne[_swapId][i].blc, nftsOne[_swapId][i].data);
856             }
857         }
858 
859         if(swapList[msg.sender][swapMatch[_swapId]].valueOne > 0)
860             swapList[msg.sender][swapMatch[_swapId]].addressOne.transfer(swapList[msg.sender][swapMatch[_swapId]].valueOne);
861 
862         swapList[msg.sender][swapMatch[_swapId]].swapEnd = block.timestamp;
863         swapList[msg.sender][swapMatch[_swapId]].status = swapStatus.Cancelled;
864         emit swapEvent(msg.sender, (block.timestamp-(block.timestamp%secs)), swapStatus.Cancelled, _swapId, address(0));
865     }
866 
867     // Set Trade Squad address
868     function setTradeSquadAddress(address _tradeSquad) public onlyOwner {
869         TRADESQUAD = _tradeSquad ;
870     }
871 
872     // Set Vault address
873     function setVaultAddress(address payable _vault) public onlyOwner {
874         VAULT = _vault ;
875     }
876 
877     // Handle dapp relations for the bridges
878     function setDappRelation(address _dapp, address _customInterface) public onlyOwner {
879         dappRelations[_dapp] = _customInterface;
880     }
881 
882     // Handle the whitelist
883     function setWhitelist(address[] memory _dapp, bool _status) public onlyOwner {
884         uint256 i;
885         for(i=0; i< _dapp.length; i++) {
886             whiteList[_dapp[i]] = _status;
887         }
888     }
889 
890     // Edit CounterPart Address
891     function editCounterPart(uint256 _swapId, address payable _counterPart) public {
892         require(checksCreator[_swapId] == msg.sender, "You're not the interested counterpart");
893         require(msg.sender == swapList[msg.sender][swapMatch[_swapId]].addressOne, "Message sender must be the swap creator");
894         checksCounterparty[_swapId] = _counterPart;
895         swapList[msg.sender][swapMatch[_swapId]].addressTwo = _counterPart;
896     }
897 
898     // Set the payment
899     function setPayment(bool _status, uint256 _value) public onlyOwner whenNotPaused {
900         payment.status = _status;
901         payment.value = _value * (1 wei);
902     }
903 
904     // Pause / Unpause the contract
905     function pauseContract(bool _paused) public onlyOwner {
906         _paused?_pause():_unpause();
907     }
908 
909     // Get whitelist status of an address
910     function getWhiteList(address _address) public view returns(bool) {
911         return whiteList[_address];
912     }
913 
914     // Get Trade fees
915     function getWeiPayValueAmount() public view returns(uint256) {
916         return payment.value;
917     }
918 
919     // Get swap infos
920     function getSwapIntentByAddress(address _creator, uint256 _swapId) public view returns(swapIntent memory) {
921         return swapList[_creator][swapMatch[_swapId]];
922     }
923     
924     // Get swapStructLength
925     function getSwapStructSize(uint256 _swapId, bool _nfts) public view returns(uint256) {
926         if(_nfts)
927             return nftsOne[_swapId].length ;
928         else
929             return nftsTwo[_swapId].length ;
930     }
931 
932     // Get swapStruct
933     function getSwapStruct(uint256 _swapId, bool _nfts, uint256 _index) public view returns(swapStruct memory) {
934         if(_nfts)
935             return nftsOne[_swapId][_index] ;
936         else
937             return nftsTwo[_swapId][_index] ;
938     }
939 
940     //Interface IERC721/IERC1155
941     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external override returns (bytes4) {
942         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
943     }
944     function onERC1155Received(address operator, address from, uint256 id, uint256 value, bytes calldata data) external override returns (bytes4) {
945         return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
946     }
947     function onERC1155BatchReceived(address operator, address from, uint256[] calldata id, uint256[] calldata value, bytes calldata data) external override returns (bytes4) {
948         return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
949     }
950     function supportsInterface(bytes4 interfaceID) public view virtual override returns (bool) {
951         return  interfaceID == 0x01ffc9a7 || interfaceID == 0x4e2312e0;
952     }
953 }