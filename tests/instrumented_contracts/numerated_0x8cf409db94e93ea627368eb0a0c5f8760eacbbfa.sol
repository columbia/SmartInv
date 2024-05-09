1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16   function _msgSender() internal virtual view returns (address payable) {
17     return msg.sender;
18   }
19 
20   function _msgData() internal virtual view returns (bytes memory) {
21     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22     return msg.data;
23   }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 pragma solidity ^0.6.0;
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 contract Ownable is Context {
43   address private _owner;
44 
45   event OwnershipTransferred(
46     address indexed previousOwner,
47     address indexed newOwner
48   );
49 
50   /**
51    * @dev Initializes the contract setting the deployer as the initial owner.
52    */
53   constructor() internal {
54     address msgSender = _msgSender();
55     _owner = msgSender;
56     emit OwnershipTransferred(address(0), msgSender);
57   }
58 
59   /**
60    * @dev Returns the address of the current owner.
61    */
62   function owner() public view returns (address) {
63     return _owner;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
71     _;
72   }
73 
74   /**
75    * @dev Leaves the contract without owner. It will not be possible to call
76    * `onlyOwner` functions anymore. Can only be called by the current owner.
77    *
78    * NOTE: Renouncing ownership will leave the contract without an owner,
79    * thereby removing any functionality that is only available to the owner.
80    */
81   function renounceOwnership() public virtual onlyOwner {
82     emit OwnershipTransferred(_owner, address(0));
83     _owner = address(0);
84   }
85 
86   /**
87    * @dev Transfers ownership of the contract to a new account (`newOwner`).
88    * Can only be called by the current owner.
89    */
90   function transferOwnership(address newOwner) public virtual onlyOwner {
91     require(newOwner != address(0), 'Ownable: new owner is the zero address');
92     emit OwnershipTransferred(_owner, newOwner);
93     _owner = newOwner;
94   }
95 }
96 
97 // File: @openzeppelin/contracts/math/SafeMath.sol
98 
99 pragma solidity ^0.6.0;
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115   /**
116    * @dev Returns the addition of two unsigned integers, reverting on
117    * overflow.
118    *
119    * Counterpart to Solidity's `+` operator.
120    *
121    * Requirements:
122    *
123    * - Addition cannot overflow.
124    */
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     require(c >= a, 'SafeMath: addition overflow');
128 
129     return c;
130   }
131 
132   /**
133    * @dev Returns the subtraction of two unsigned integers, reverting on
134    * overflow (when the result is negative).
135    *
136    * Counterpart to Solidity's `-` operator.
137    *
138    * Requirements:
139    *
140    * - Subtraction cannot overflow.
141    */
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     return sub(a, b, 'SafeMath: subtraction overflow');
144   }
145 
146   /**
147    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148    * overflow (when the result is negative).
149    *
150    * Counterpart to Solidity's `-` operator.
151    *
152    * Requirements:
153    *
154    * - Subtraction cannot overflow.
155    */
156   function sub(
157     uint256 a,
158     uint256 b,
159     string memory errorMessage
160   ) internal pure returns (uint256) {
161     require(b <= a, errorMessage);
162     uint256 c = a - b;
163 
164     return c;
165   }
166 
167   /**
168    * @dev Returns the multiplication of two unsigned integers, reverting on
169    * overflow.
170    *
171    * Counterpart to Solidity's `*` operator.
172    *
173    * Requirements:
174    *
175    * - Multiplication cannot overflow.
176    */
177   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179     // benefit is lost if 'b' is also tested.
180     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181     if (a == 0) {
182       return 0;
183     }
184 
185     uint256 c = a * b;
186     require(c / a == b, 'SafeMath: multiplication overflow');
187 
188     return c;
189   }
190 
191   /**
192    * @dev Returns the integer division of two unsigned integers. Reverts on
193    * division by zero. The result is rounded towards zero.
194    *
195    * Counterpart to Solidity's `/` operator. Note: this function uses a
196    * `revert` opcode (which leaves remaining gas untouched) while Solidity
197    * uses an invalid opcode to revert (consuming all remaining gas).
198    *
199    * Requirements:
200    *
201    * - The divisor cannot be zero.
202    */
203   function div(uint256 a, uint256 b) internal pure returns (uint256) {
204     return div(a, b, 'SafeMath: division by zero');
205   }
206 
207   /**
208    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209    * division by zero. The result is rounded towards zero.
210    *
211    * Counterpart to Solidity's `/` operator. Note: this function uses a
212    * `revert` opcode (which leaves remaining gas untouched) while Solidity
213    * uses an invalid opcode to revert (consuming all remaining gas).
214    *
215    * Requirements:
216    *
217    * - The divisor cannot be zero.
218    */
219   function div(
220     uint256 a,
221     uint256 b,
222     string memory errorMessage
223   ) internal pure returns (uint256) {
224     require(b > 0, errorMessage);
225     uint256 c = a / b;
226     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228     return c;
229   }
230 
231   /**
232    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233    * Reverts when dividing by zero.
234    *
235    * Counterpart to Solidity's `%` operator. This function uses a `revert`
236    * opcode (which leaves remaining gas untouched) while Solidity uses an
237    * invalid opcode to revert (consuming all remaining gas).
238    *
239    * Requirements:
240    *
241    * - The divisor cannot be zero.
242    */
243   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244     return mod(a, b, 'SafeMath: modulo by zero');
245   }
246 
247   /**
248    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249    * Reverts with custom message when dividing by zero.
250    *
251    * Counterpart to Solidity's `%` operator. This function uses a `revert`
252    * opcode (which leaves remaining gas untouched) while Solidity uses an
253    * invalid opcode to revert (consuming all remaining gas).
254    *
255    * Requirements:
256    *
257    * - The divisor cannot be zero.
258    */
259   function mod(
260     uint256 a,
261     uint256 b,
262     string memory errorMessage
263   ) internal pure returns (uint256) {
264     require(b != 0, errorMessage);
265     return a % b;
266   }
267 }
268 // File: contracts/utils/Roles.sol
269 
270 pragma solidity >=0.6.0;
271 
272 /**
273  * @title Roles
274  * @dev Library for managing addresses assigned to a Role.
275  */
276 library Roles {
277     struct Role {
278         mapping(address => bool) bearer;
279     }
280 
281     /**
282      * @dev Give an account access to this role.
283      */
284     function add(Role storage role, address account) internal {
285         require(!has(role, account), "Roles: account already has role");
286         role.bearer[account] = true;
287     }
288 
289     /**
290      * @dev Remove an account's access to this role.
291      */
292     function remove(Role storage role, address account) internal {
293         require(has(role, account), "Roles: account does not have role");
294         role.bearer[account] = false;
295     }
296 
297     /**
298      * @dev Check if an account has this role.
299      * @return bool
300      */
301     function has(Role storage role, address account)
302         internal
303         view
304         returns (bool)
305     {
306         require(account != address(0), "Roles: account is the zero address");
307         return role.bearer[account];
308     }
309 }
310 
311 // File: @openzeppelin/contracts/introspection/IERC165.sol
312 
313 pragma solidity ^0.6.0;
314 
315 /**
316  * @dev Interface of the ERC165 standard, as defined in the
317  * https://eips.ethereum.org/EIPS/eip-165[EIP].
318  *
319  * Implementers can declare support of contract interfaces, which can then be
320  * queried by others ({ERC165Checker}).
321  *
322  * For an implementation, see {ERC165}.
323  */
324 interface IERC165 {
325   /**
326    * @dev Returns true if this contract implements the interface defined by
327    * `interfaceId`. See the corresponding
328    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
329    * to learn more about how these ids are created.
330    *
331    * This function call must use less than 30 000 gas.
332    */
333   function supportsInterface(bytes4 interfaceId) external view returns (bool);
334 }
335 
336 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
337 
338 pragma solidity ^0.6.2;
339 
340 /**
341  * @dev Required interface of an ERC1155 compliant contract, as defined in the
342  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
343  *
344  * _Available since v3.1._
345  */
346 interface IERC1155 is IERC165 {
347   /**
348    * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
349    */
350   event TransferSingle(
351     address indexed operator,
352     address indexed from,
353     address indexed to,
354     uint256 id,
355     uint256 value
356   );
357 
358   /**
359    * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
360    * transfers.
361    */
362   event TransferBatch(
363     address indexed operator,
364     address indexed from,
365     address indexed to,
366     uint256[] ids,
367     uint256[] values
368   );
369 
370   /**
371    * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
372    * `approved`.
373    */
374   event ApprovalForAll(
375     address indexed account,
376     address indexed operator,
377     bool approved
378   );
379 
380   /**
381    * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
382    *
383    * If an {URI} event was emitted for `id`, the standard
384    * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
385    * returned by {IERC1155MetadataURI-uri}.
386    */
387   event URI(string value, uint256 indexed id);
388 
389   /**
390    * @dev Returns the amount of tokens of token type `id` owned by `account`.
391    *
392    * Requirements:
393    *
394    * - `account` cannot be the zero address.
395    */
396   function balanceOf(address account, uint256 id)
397     external
398     view
399     returns (uint256);
400 
401   /**
402    * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
403    *
404    * Requirements:
405    *
406    * - `accounts` and `ids` must have the same length.
407    */
408   function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
409     external
410     view
411     returns (uint256[] memory);
412 
413   /**
414    * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
415    *
416    * Emits an {ApprovalForAll} event.
417    *
418    * Requirements:
419    *
420    * - `operator` cannot be the caller.
421    */
422   function setApprovalForAll(address operator, bool approved) external;
423 
424   /**
425    * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
426    *
427    * See {setApprovalForAll}.
428    */
429   function isApprovedForAll(address account, address operator)
430     external
431     view
432     returns (bool);
433 
434   /**
435    * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
436    *
437    * Emits a {TransferSingle} event.
438    *
439    * Requirements:
440    *
441    * - `to` cannot be the zero address.
442    * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
443    * - `from` must have a balance of tokens of type `id` of at least `amount`.
444    * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
445    * acceptance magic value.
446    */
447   function safeTransferFrom(
448     address from,
449     address to,
450     uint256 id,
451     uint256 amount,
452     bytes calldata data
453   ) external;
454 
455   /**
456    * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
457    *
458    * Emits a {TransferBatch} event.
459    *
460    * Requirements:
461    *
462    * - `ids` and `amounts` must have the same length.
463    * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
464    * acceptance magic value.
465    */
466   function safeBatchTransferFrom(
467     address from,
468     address to,
469     uint256[] calldata ids,
470     uint256[] calldata amounts,
471     bytes calldata data
472   ) external;
473 }
474 
475 // File: contracts/ToshiDojo.sol
476 
477 
478 
479 pragma solidity >=0.6.0;
480 pragma experimental ABIEncoderV2;
481 
482 interface ToshimonMinter {
483   function safeTransferFrom(
484     address _from,
485     address _to,
486     uint256 _id,
487     uint256 _amount,
488     bytes calldata _data
489   ) external;
490 
491   function safeBatchTransferFrom(
492     address _from,
493     address _to,
494     uint256[] calldata _ids,
495     uint256[] calldata _amounts,
496     bytes calldata _data
497   ) external;
498 
499   function setApprovalForAll(address _operator, bool _approved) external;
500 
501   function isApprovedForAll(address _owner, address _operator)
502     external
503     view
504     returns (bool isOperator);
505 
506   function balanceOf(address _owner, uint256 _id)
507     external
508     view
509     returns (uint256);
510 
511   function totalSupply(uint256 _id) external view returns (uint256);
512 
513   function tokenMaxSupply(uint256 _id) external view returns (uint256);
514 
515   function burn(
516     address _account,
517     uint256 _id,
518     uint256 _amount
519   ) external;
520 
521   function mint(
522     address _to,
523     uint256 _id,
524     uint256 _quantity,
525     bytes memory _data
526   ) external;
527   function mintBatch(address user, uint256[] calldata ids, uint256[] calldata amounts)
528         external;
529 }
530 
531 interface ToshiCoin {
532   function totalSupply() external view returns (uint256);
533 
534   function totalClaimed() external view returns (uint256);
535 
536   function addClaimed(uint256 _amount) external;
537 
538   function setClaimed(uint256 _amount) external;
539 
540   function transfer(address receiver, uint256 numTokens)
541     external
542     returns (bool);
543 
544   function transferFrom(
545     address owner,
546     address buyer,
547     uint256 numTokens
548   ) external returns (bool);
549 
550   function balanceOf(address owner) external view returns (uint256);
551 
552   function mint(address _to, uint256 _amount) external;
553 
554   function burn(address _account, uint256 value) external;
555 }
556 
557 
558 contract ToshiDojo is Ownable {
559   using SafeMath for uint256;
560 
561   ToshimonMinter public toshimonMinter;
562   ToshiCoin public toshiCoin;
563   uint256 public minterPackId;
564   uint256 public packPriceInToshiCoin;
565   uint256 public packsPurchased;
566   uint256 public packsRedeemed;
567   bytes private prevHash;
568 
569   uint256[] public probabilities;
570   uint256[][] public cardRanges;
571   uint256[] public probabilitiesRare;
572   uint256[][] public cardRangesRare; 
573 
574 
575   event Redeemed(
576     address indexed _user,
577     uint256[] indexed _cardIds,
578     uint256[] indexed _quantities
579   );
580 
581   constructor() public {
582     toshimonMinter = ToshimonMinter(0xd2d2a84f0eB587F70E181A0C4B252c2c053f80cB);
583     toshiCoin = ToshiCoin(0x3EEfF4487F64bF73cd9D99e83D837B0Ef1F58247);
584     minterPackId = 0;
585     packPriceInToshiCoin = 1000000000000000000;
586     prevHash = abi.encodePacked(block.timestamp, msg.sender);
587     probabilities = [350,600,780,930,980,995,1000];
588     cardRanges = [[uint256(1),uint256(102)],[uint256(103),uint256(180)],[uint256(181),uint256(226)],[uint256(227),uint256(248)],[uint256(249),uint256(258)],[uint256(259),uint256(263)],[uint256(264),uint256(264)]];
589     probabilitiesRare = [700,930,980,995,1000];
590     cardRangesRare = [[265,291],[292,307],[308,310],[311,311],[312,312]];
591 
592 
593   }
594 
595   modifier onlyEOA() {
596     require(msg.sender == tx.origin, 'Not eoa');
597     _;
598   }
599 
600   function setMinterPackId(uint256 _minterPackId) external onlyOwner {
601     minterPackId = _minterPackId;
602   }
603 
604 
605   function setPackPriceInToshiCoin(uint256 _packPriceInToshiCoin)
606     external
607     onlyOwner
608   {
609     packPriceInToshiCoin = _packPriceInToshiCoin;
610   }
611 
612   function tokenMaxSupply(uint256 _cardId) external view returns (uint256) {
613     return toshimonMinter.tokenMaxSupply(_cardId);
614   }
615 
616   function totalSupply(uint256 _cardId) external view returns (uint256) {
617     return toshimonMinter.totalSupply(_cardId);
618   }
619 
620 
621   function addPack(
622     uint256[] memory _probabilities,
623     uint256[][] memory _cardRanges,
624     uint256[] memory _probabilitiesRare,
625     uint256[][] memory _cardRangesRare
626     
627   ) public onlyOwner {
628     require(_probabilities.length > 0, 'probabilities cannot be empty');
629     require(_cardRanges.length > 0, 'cardRanges cannot be empty');
630     require(_probabilitiesRare.length > 0, 'probabilities rare cannot be empty');
631     require(_cardRangesRare.length > 0, 'cardRanges rare cannot be empty');
632 
633 
634     probabilities = _probabilities;
635     cardRanges = _cardRanges;
636     probabilitiesRare = _probabilitiesRare;
637     cardRangesRare = _cardRangesRare;
638 
639 
640   }
641 
642   function updateprobabilities(uint256[] memory _probabilities)
643     external
644     onlyOwner
645   {
646     probabilities = _probabilities;
647   }
648 
649   function updateCardRanges(uint256[][] memory _cardRanges)
650     external
651     onlyOwner
652   {
653     cardRanges = _cardRanges;
654   }
655     function updateProbabilitiesRare(uint256[] memory _probabilitiesRare)
656     external
657     onlyOwner
658   {
659     probabilitiesRare = _probabilitiesRare;
660   }
661 
662   function updateCardRangesRare(uint256[][] memory _cardRangesRare)
663     external
664     onlyOwner
665   {
666     cardRangesRare = _cardRangesRare;
667   }
668 
669 
670 
671 
672 
673   // Purchase one or more card packs for the price in ToshiCoin
674   function purchasePack(uint256 amount) public {
675     require(packPriceInToshiCoin > 0, 'Pack does not exist');
676     require(
677       toshiCoin.balanceOf(msg.sender) >= packPriceInToshiCoin.mul(amount),
678       'Not enough toshiCoin for pack'
679     );
680 
681     toshiCoin.burn(msg.sender, packPriceInToshiCoin.mul(amount));
682     packsPurchased = packsPurchased.add(amount);
683     toshimonMinter.mint(msg.sender, minterPackId, amount, '');
684   }
685   
686   // Redeem a random card pack (Not callable by contract, to prevent exploits on RNG)
687 
688   function redeemPack(uint256 _packsToRedeem) external {
689      require(
690       toshimonMinter.balanceOf(msg.sender, minterPackId) >= _packsToRedeem,
691       'Not enough pack tokens'
692     );
693 
694     toshimonMinter.burn(msg.sender, minterPackId, _packsToRedeem);
695 
696     uint256 probability;
697     uint256 max;
698     uint256 min; 
699     uint256[] memory _cardsToMint = new uint256[](312);
700     uint256[] memory _cardsToMintCount = new uint256[](312);
701     uint256 cardIdWon;
702     uint256 rng = _rngSimple(_rng());
703 
704 
705     for (uint256 i = 0; i < _packsToRedeem; ++i) {
706 
707       for (uint256 j = 0; j < 7; ++j) {
708           probability = rng % 1000;
709           for (uint256 _probIndex = 0; _probIndex < probabilities.length; ++_probIndex) {
710             if(probability < probabilities[_probIndex]){
711               max = cardRanges[_probIndex][1];
712               min = cardRanges[_probIndex][0];
713               break;
714             }
715           }
716           rng = _rngSimple(rng);
717           cardIdWon = (rng % (max + 1 - min)) + min;
718           _cardsToMint[cardIdWon - 1] = cardIdWon;
719           _cardsToMintCount[cardIdWon - 1] = _cardsToMintCount[cardIdWon - 1] + 1;
720       }
721       
722       // run for rare packs start
723       probability = rng % 1000;
724       for (uint256 _probIndex = 0; _probIndex < probabilitiesRare.length; ++_probIndex) {
725         if(probability < probabilitiesRare[_probIndex]){
726           max = cardRangesRare[_probIndex][1];
727           min = cardRangesRare[_probIndex][0];
728           break;
729         }
730       }
731       rng = _rngSimple(rng);
732       cardIdWon = (rng % (max + 1 - min)) + min;
733       _cardsToMint[cardIdWon - 1] = cardIdWon;
734       _cardsToMintCount[cardIdWon - 1] = _cardsToMintCount[cardIdWon - 1] + 1;
735     }
736     
737     
738     emit Redeemed(msg.sender,_cardsToMint,_cardsToMintCount);
739     toshimonMinter.mintBatch(msg.sender,_cardsToMint,_cardsToMintCount);
740   }
741   
742   
743   // Utility function to check if a value is inside an array
744   function _isInArray(uint256 _value, uint256[] memory _array)
745     internal
746     pure
747     returns (bool)
748   {
749     uint256 length = _array.length;
750     for (uint256 i = 0; i < length; ++i) {
751       if (_array[i] == _value) {
752         return true;
753       }
754     }
755 
756     return false;
757   }
758 
759 
760   // This is a pseudo random function, but considering the fact that redeem function is not callable by contract,
761   // and the fact that ToshiCoin is not transferable, this should be enough to protect us from an attack
762   // I would only expect a miner to be able to exploit this, and the attack cost would not be worth it in our case
763   function _rng() internal returns (uint256) {
764     bytes32 ret = keccak256(prevHash);
765     prevHash = abi.encodePacked(ret,block.coinbase,msg.sender);
766     return uint256(ret);
767   }
768   function _rngSimple(uint256 seed) internal pure returns (uint256) {
769 
770     return uint256(keccak256(abi.encodePacked(seed)));
771   }
772 }