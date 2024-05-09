1 // File: contracts/interfaces/IERC20.sol
2 // SPDX-License-Identifier: AGPL-3.0
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the token decimals.
14      */
15     function decimals() external view returns (uint8);
16 
17     /**
18      * @dev Returns the token symbol.
19      */
20     function symbol() external view returns (string memory);
21 
22     /**
23      * @dev Returns the token name.
24      */
25     function name() external view returns (string memory);
26 
27     /**
28      * @dev Returns the bep token owner. (This is a BEP-20 token specific.)
29      */
30     function getOwner() external view returns (address);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount)
45         external
46         returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address _owner, address spender)
56         external
57         view
58         returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(
104         address indexed owner,
105         address indexed spender,
106         uint256 value
107     );
108 }
109 
110 // File: contracts/interfaces/IBurnableToken.sol
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 
115 interface IBurnableToken is IERC20 {
116     function mint(address target, uint256 amount) external returns (bool);
117 
118     function burn(uint256 amount) external returns (bool);
119 
120     function mintable() external returns (bool);
121 }
122 
123 // File: contracts/interfaces/ISwapContract.sol
124 
125 pragma solidity >=0.6.0 <0.8.0;
126 
127 interface ISwapContract {
128     function singleTransferERC20(
129         address _destToken,
130         address _to,
131         uint256 _amount,
132         uint256 _totalSwapped,
133         uint256 _rewardsAmount,
134         bytes32[] memory _redeemedFloatTxIds
135     ) external returns (bool);
136 
137     function multiTransferERC20TightlyPacked(
138         address _destToken,
139         bytes32[] memory _addressesAndAmounts,
140         uint256 _totalSwapped,
141         uint256 _rewardsAmount,
142         bytes32[] memory _redeemedFloatTxIds
143     ) external returns (bool);
144 
145     function collectSwapFeesForBTC(
146         address _destToken,
147         uint256 _incomingAmount,
148         uint256 _minerFee,
149         uint256 _rewardsAmount
150     ) external returns (bool);
151 
152     function recordIncomingFloat(
153         address _token,
154         bytes32 _addressesAndAmountOfFloat,
155         bool _zerofee,
156         bytes32 _txid
157     ) external returns (bool);
158 
159     function recordOutcomingFloat(
160         address _token,
161         bytes32 _addressesAndAmountOfLPtoken,
162         uint256 _minerFee,
163         bytes32 _txid
164     ) external returns (bool);
165 
166     function distributeNodeRewards() external returns (bool);
167 
168     function recordUTXOSweepMinerFee(uint256 _minerFee, bytes32 _txid)
169         external
170         returns (bool);
171 
172     function churn(
173         address _newOwner,
174         bytes32[] memory _rewardAddressAndAmounts,
175         bool[] memory _isRemoved,
176         uint8 _churnedInCount,
177         uint8 _tssThreshold,
178         uint8 _nodeRewardsRatio,
179         uint8 _withdrawalFeeBPS
180     ) external returns (bool);
181 
182     function isTxUsed(bytes32 _txid) external view returns (bool);
183 
184     function getCurrentPriceLP() external view returns (uint256);
185 
186     function getDepositFeeRate(address _token, uint256 _amountOfFloat)
187         external
188         view
189         returns (uint256);
190 
191     function getFloatReserve(address _tokenA, address _tokenB)
192         external
193         returns (uint256 reserveA, uint256 reserveB);
194 
195     function getActiveNodes() external returns (bytes32[] memory);
196 }
197 
198 // File: @openzeppelin/contracts/GSN/Context.sol
199 
200 
201 pragma solidity >=0.6.0 <0.8.0;
202 
203 /*
204  * @dev Provides information about the current execution context, including the
205  * sender of the transaction and its data. While these are generally available
206  * via msg.sender and msg.data, they should not be accessed in such a direct
207  * manner, since when dealing with GSN meta-transactions the account sending and
208  * paying for execution may not be the actual sender (as far as an application
209  * is concerned).
210  *
211  * This contract is only required for intermediate, library-like contracts.
212  */
213 abstract contract Context {
214     function _msgSender() internal view virtual returns (address payable) {
215         return msg.sender;
216     }
217 
218     function _msgData() internal view virtual returns (bytes memory) {
219         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
220         return msg.data;
221     }
222 }
223 
224 // File: @openzeppelin/contracts/access/Ownable.sol
225 
226 
227 pragma solidity >=0.6.0 <0.8.0;
228 
229 /**
230  * @dev Contract module which provides a basic access control mechanism, where
231  * there is an account (an owner) that can be granted exclusive access to
232  * specific functions.
233  *
234  * By default, the owner account will be the one that deploys the contract. This
235  * can later be changed with {transferOwnership}.
236  *
237  * This module is used through inheritance. It will make available the modifier
238  * `onlyOwner`, which can be applied to your functions to restrict their use to
239  * the owner.
240  */
241 abstract contract Ownable is Context {
242     address private _owner;
243 
244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
245 
246     /**
247      * @dev Initializes the contract setting the deployer as the initial owner.
248      */
249     constructor () internal {
250         address msgSender = _msgSender();
251         _owner = msgSender;
252         emit OwnershipTransferred(address(0), msgSender);
253     }
254 
255     /**
256      * @dev Returns the address of the current owner.
257      */
258     function owner() public view returns (address) {
259         return _owner;
260     }
261 
262     /**
263      * @dev Throws if called by any account other than the owner.
264      */
265     modifier onlyOwner() {
266         require(_owner == _msgSender(), "Ownable: caller is not the owner");
267         _;
268     }
269 
270     /**
271      * @dev Leaves the contract without owner. It will not be possible to call
272      * `onlyOwner` functions anymore. Can only be called by the current owner.
273      *
274      * NOTE: Renouncing ownership will leave the contract without an owner,
275      * thereby removing any functionality that is only available to the owner.
276      */
277     function renounceOwnership() public virtual onlyOwner {
278         emit OwnershipTransferred(_owner, address(0));
279         _owner = address(0);
280     }
281 
282     /**
283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
284      * Can only be called by the current owner.
285      */
286     function transferOwnership(address newOwner) public virtual onlyOwner {
287         require(newOwner != address(0), "Ownable: new owner is the zero address");
288         emit OwnershipTransferred(_owner, newOwner);
289         _owner = newOwner;
290     }
291 }
292 
293 // File: @openzeppelin/contracts/math/SafeMath.sol
294 
295 
296 pragma solidity >=0.6.0 <0.8.0;
297 
298 /**
299  * @dev Wrappers over Solidity's arithmetic operations with added overflow
300  * checks.
301  *
302  * Arithmetic operations in Solidity wrap on overflow. This can easily result
303  * in bugs, because programmers usually assume that an overflow raises an
304  * error, which is the standard behavior in high level programming languages.
305  * `SafeMath` restores this intuition by reverting the transaction when an
306  * operation overflows.
307  *
308  * Using this library instead of the unchecked operations eliminates an entire
309  * class of bugs, so it's recommended to use it always.
310  */
311 library SafeMath {
312     /**
313      * @dev Returns the addition of two unsigned integers, reverting on
314      * overflow.
315      *
316      * Counterpart to Solidity's `+` operator.
317      *
318      * Requirements:
319      *
320      * - Addition cannot overflow.
321      */
322     function add(uint256 a, uint256 b) internal pure returns (uint256) {
323         uint256 c = a + b;
324         require(c >= a, "SafeMath: addition overflow");
325 
326         return c;
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
340         return sub(a, b, "SafeMath: subtraction overflow");
341     }
342 
343     /**
344      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
345      * overflow (when the result is negative).
346      *
347      * Counterpart to Solidity's `-` operator.
348      *
349      * Requirements:
350      *
351      * - Subtraction cannot overflow.
352      */
353     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
354         require(b <= a, errorMessage);
355         uint256 c = a - b;
356 
357         return c;
358     }
359 
360     /**
361      * @dev Returns the multiplication of two unsigned integers, reverting on
362      * overflow.
363      *
364      * Counterpart to Solidity's `*` operator.
365      *
366      * Requirements:
367      *
368      * - Multiplication cannot overflow.
369      */
370     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
371         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
372         // benefit is lost if 'b' is also tested.
373         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
374         if (a == 0) {
375             return 0;
376         }
377 
378         uint256 c = a * b;
379         require(c / a == b, "SafeMath: multiplication overflow");
380 
381         return c;
382     }
383 
384     /**
385      * @dev Returns the integer division of two unsigned integers. Reverts on
386      * division by zero. The result is rounded towards zero.
387      *
388      * Counterpart to Solidity's `/` operator. Note: this function uses a
389      * `revert` opcode (which leaves remaining gas untouched) while Solidity
390      * uses an invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      *
394      * - The divisor cannot be zero.
395      */
396     function div(uint256 a, uint256 b) internal pure returns (uint256) {
397         return div(a, b, "SafeMath: division by zero");
398     }
399 
400     /**
401      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
402      * division by zero. The result is rounded towards zero.
403      *
404      * Counterpart to Solidity's `/` operator. Note: this function uses a
405      * `revert` opcode (which leaves remaining gas untouched) while Solidity
406      * uses an invalid opcode to revert (consuming all remaining gas).
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
413         require(b > 0, errorMessage);
414         uint256 c = a / b;
415         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
416 
417         return c;
418     }
419 
420     /**
421      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
422      * Reverts when dividing by zero.
423      *
424      * Counterpart to Solidity's `%` operator. This function uses a `revert`
425      * opcode (which leaves remaining gas untouched) while Solidity uses an
426      * invalid opcode to revert (consuming all remaining gas).
427      *
428      * Requirements:
429      *
430      * - The divisor cannot be zero.
431      */
432     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
433         return mod(a, b, "SafeMath: modulo by zero");
434     }
435 
436     /**
437      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
438      * Reverts with custom message when dividing by zero.
439      *
440      * Counterpart to Solidity's `%` operator. This function uses a `revert`
441      * opcode (which leaves remaining gas untouched) while Solidity uses an
442      * invalid opcode to revert (consuming all remaining gas).
443      *
444      * Requirements:
445      *
446      * - The divisor cannot be zero.
447      */
448     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
449         require(b != 0, errorMessage);
450         return a % b;
451     }
452 }
453 
454 // File: contracts/SwapContract.sol
455 
456 pragma solidity >=0.6.0 <0.8.0;
457 
458 
459 
460 
461 
462 
463 contract SwapContract is Ownable, ISwapContract {
464     using SafeMath for uint256;
465 
466     address public WBTC_ADDR;
467     address public lpToken;
468 
469     mapping(address => bool) public whitelist;
470 
471     uint8 public churnedInCount;
472     uint8 public tssThreshold;
473     uint8 public nodeRewardsRatio;
474     uint8 public depositFeesBPS;
475     uint8 public withdrawalFeeBPS;
476     uint256 public lockedLPTokensForNode;
477     uint256 public feesLPTokensForNode;
478     uint256 public initialExchangeRate;
479 
480     uint256 private priceDecimals;
481     uint256 private lpDecimals;
482 
483     mapping(address => uint256) private floatAmountOf;
484     mapping(bytes32 => bool) private used;
485     // Node lists
486     mapping(address => bytes32) private nodes;
487     mapping(address => bool) private isInList;
488     address[] private nodeAddrs;
489 
490     /**
491      * Events
492      */
493 
494     event Swap(address from, address to, uint256 amount);
495 
496     event RewardsCollection(
497         address feesToken,
498         uint256 rewards,
499         uint256 amountLPTokensForNode,
500         uint256 currentPriceLP
501     );
502 
503     event IssueLPTokensForFloat(
504         address to,
505         uint256 amountOfFloat,
506         uint256 amountOfLP,
507         uint256 currentPriceLP,
508         uint256 depositFees,
509         bytes32 txid
510     );
511 
512     event BurnLPTokensForFloat(
513         address token,
514         uint256 amountOfLP,
515         uint256 amountOfFloat,
516         uint256 currentPriceLP,
517         uint256 withdrawal,
518         bytes32 txid
519     );
520 
521     modifier priceCheck() {
522         uint256 beforePrice = getCurrentPriceLP();
523         _;
524         require(getCurrentPriceLP() >= beforePrice, "Invalid LPT price");
525     }
526 
527     constructor(
528         address _lpToken,
529         address _wbtc,
530         uint256 _existingBTCFloat
531     ) public {
532         // Set lpToken address
533         lpToken = _lpToken;
534         // Set initial lpDecimals of LP token
535         lpDecimals = 10**IERC20(lpToken).decimals();
536         // Set WBTC address
537         WBTC_ADDR = _wbtc;
538         // Set nodeRewardsRatio
539         nodeRewardsRatio = 66;
540         // Set depositFeesBPS
541         depositFeesBPS = 50;
542         // Set withdrawalFeeBPS
543         withdrawalFeeBPS = 20;
544         // Set priceDecimals
545         priceDecimals = 10**8;
546         // Set initialExchangeRate
547         initialExchangeRate = priceDecimals;
548         // Set lockedLPTokensForNode
549         lockedLPTokensForNode = 0;
550         // Set feesLPTokensForNode
551         feesLPTokensForNode = 0;
552         // Set whitelist addresses
553         whitelist[WBTC_ADDR] = true;
554         whitelist[lpToken] = true;
555         whitelist[address(0)] = true;
556         floatAmountOf[address(0)] = _existingBTCFloat;
557     }
558 
559     /**
560      * Transfer part
561      */
562 
563     /// @dev singleTransferERC20 sends tokens from contract.
564     /// @param _destToken The address of target token.
565     /// @param _to The address of recipient.
566     /// @param _amount The amount of tokens.
567     /// @param _totalSwapped The amount of swap.
568     /// @param _rewardsAmount The fees that should be paid.
569     /// @param _redeemedFloatTxIds The txids which is for recording.
570     function singleTransferERC20(
571         address _destToken,
572         address _to,
573         uint256 _amount,
574         uint256 _totalSwapped,
575         uint256 _rewardsAmount,
576         bytes32[] memory _redeemedFloatTxIds
577     ) external override onlyOwner returns (bool) {
578         require(whitelist[_destToken], "_destToken is not whitelisted");
579         require(
580             _destToken != address(0),
581             "_destToken should not be address(0)"
582         );
583         address _feesToken = address(0);
584         if (_totalSwapped > 0) {
585             _swap(address(0), WBTC_ADDR, _totalSwapped);
586         } else if (_totalSwapped == 0) {
587             _feesToken = WBTC_ADDR;
588         }
589         if (_destToken == lpToken) {
590             _feesToken = lpToken;
591         }
592         _rewardsCollection(_feesToken, _rewardsAmount);
593         _addUsedTxs(_redeemedFloatTxIds);
594         require(IERC20(_destToken).transfer(_to, _amount));
595         return true;
596     }
597 
598     /// @dev multiTransferERC20TightlyPacked sends tokens from contract.
599     /// @param _destToken The address of target token.
600     /// @param _addressesAndAmounts The address of recipient and amount.
601     /// @param _totalSwapped The amount of swap.
602     /// @param _rewardsAmount The fees that should be paid.
603     /// @param _redeemedFloatTxIds The txids which is for recording.
604     function multiTransferERC20TightlyPacked(
605         address _destToken,
606         bytes32[] memory _addressesAndAmounts,
607         uint256 _totalSwapped,
608         uint256 _rewardsAmount,
609         bytes32[] memory _redeemedFloatTxIds
610     ) external override onlyOwner returns (bool) {
611         require(whitelist[_destToken], "_destToken is not whitelisted");
612         require(
613             _destToken != address(0),
614             "_destToken should not be address(0)"
615         );
616         address _feesToken = address(0);
617         if (_totalSwapped > 0) {
618             _swap(address(0), WBTC_ADDR, _totalSwapped);
619         } else if (_totalSwapped == 0) {
620             _feesToken = WBTC_ADDR;
621         }
622         if (_destToken == lpToken) {
623             _feesToken = lpToken;
624         }
625         _rewardsCollection(_feesToken, _rewardsAmount);
626         _addUsedTxs(_redeemedFloatTxIds);
627         for (uint256 i = 0; i < _addressesAndAmounts.length; i++) {
628             require(
629                 IERC20(_destToken).transfer(
630                     address(uint160(uint256(_addressesAndAmounts[i]))),
631                     uint256(uint96(bytes12(_addressesAndAmounts[i])))
632                 ),
633                 "Batch transfer error"
634             );
635         }
636         return true;
637     }
638 
639     /// @dev collectSwapFeesForBTC collects fees in the case of swap WBTC to BTC.
640     /// @param _destToken The address of target token.
641     /// @param _incomingAmount The spent amount. (WBTC)
642     /// @param _minerFee The miner fees of BTC transaction.
643     /// @param _rewardsAmount The fees that should be paid.
644     function collectSwapFeesForBTC(
645         address _destToken,
646         uint256 _incomingAmount,
647         uint256 _minerFee,
648         uint256 _rewardsAmount
649     ) external override onlyOwner returns (bool) {
650         require(_destToken == address(0), "_destToken should be address(0)");
651         address _feesToken = WBTC_ADDR;
652         if (_incomingAmount > 0) {
653             uint256 swapAmount = _incomingAmount.sub(_rewardsAmount).sub(
654                 _minerFee
655             );
656             _swap(WBTC_ADDR, address(0), swapAmount.add(_minerFee));
657         } else if (_incomingAmount == 0) {
658             _feesToken = address(0);
659         }
660         _rewardsCollection(_feesToken, _rewardsAmount);
661         return true;
662     }
663 
664     /**
665      * Float part
666      */
667 
668     /// @dev recordIncomingFloat mints LP token.
669     /// @param _token The address of target token.
670     /// @param _addressesAndAmountOfFloat The address of recipient and amount.
671     /// @param _zerofee The flag to accept zero fees.
672     /// @param _txid The txids which is for recording.
673     function recordIncomingFloat(
674         address _token,
675         bytes32 _addressesAndAmountOfFloat,
676         bool _zerofee,
677         bytes32 _txid
678     ) external override onlyOwner priceCheck returns (bool) {
679         require(whitelist[_token], "_token is invalid");
680         require(
681             _issueLPTokensForFloat(
682                 _token,
683                 _addressesAndAmountOfFloat,
684                 _zerofee,
685                 _txid
686             )
687         );
688         return true;
689     }
690 
691     /// @dev recordOutcomingFloat burns LP token.
692     /// @param _token The address of target token.
693     /// @param _addressesAndAmountOfLPtoken The address of recipient and amount.
694     /// @param _minerFee The miner fees of BTC transaction.
695     /// @param _txid The txid which is for recording.
696     function recordOutcomingFloat(
697         address _token,
698         bytes32 _addressesAndAmountOfLPtoken,
699         uint256 _minerFee,
700         bytes32 _txid
701     ) external override onlyOwner priceCheck returns (bool) {
702         require(whitelist[_token], "_token is invalid");
703         require(
704             _burnLPTokensForFloat(
705                 _token,
706                 _addressesAndAmountOfLPtoken,
707                 _minerFee,
708                 _txid
709             )
710         );
711         return true;
712     }
713 
714     /// @dev distributeNodeRewards sends rewards for Nodes.
715     function distributeNodeRewards() external override returns (bool) {
716         // Reduce Gas
717         uint256 rewardLPTsForNodes = lockedLPTokensForNode.add(
718             feesLPTokensForNode
719         );
720         require(
721             rewardLPTsForNodes > 0,
722             "totalRewardLPsForNode is not positive"
723         );
724         bytes32[] memory nodeList = getActiveNodes();
725         uint256 totalStaked = 0;
726         for (uint256 i = 0; i < nodeList.length; i++) {
727             totalStaked = totalStaked.add(
728                 uint256(uint96(bytes12(nodeList[i])))
729             );
730         }
731         IBurnableToken(lpToken).mint(address(this), lockedLPTokensForNode);
732         for (uint256 i = 0; i < nodeList.length; i++) {
733             IBurnableToken(lpToken).transfer(
734                 address(uint160(uint256(nodeList[i]))),
735                 rewardLPTsForNodes
736                     .mul(uint256(uint96(bytes12(nodeList[i]))))
737                     .div(totalStaked)
738             );
739         }
740         lockedLPTokensForNode = 0;
741         feesLPTokensForNode = 0;
742         return true;
743     }
744 
745     /**
746      * Life cycle part
747      */
748 
749     /// @dev recordUTXOSweepMinerFee reduces float amount by collected miner fees.
750     /// @param _minerFee The miner fees of BTC transaction.
751     /// @param _txid The txid which is for recording.
752     function recordUTXOSweepMinerFee(uint256 _minerFee, bytes32 _txid)
753         public
754         override
755         onlyOwner
756         returns (bool)
757     {
758         require(!isTxUsed(_txid), "The txid is already used");
759         floatAmountOf[address(0)] = floatAmountOf[address(0)].sub(
760             _minerFee,
761             "BTC float amount insufficient"
762         );
763         _addUsedTx(_txid);
764         return true;
765     }
766 
767     /// @dev churn transfers contract ownership and set variables of the next TSS validator set.
768     /// @param _newOwner The address of new Owner.
769     /// @param _rewardAddressAndAmounts The reward addresses and amounts.
770     /// @param _isRemoved The flags to remove node.
771     /// @param _churnedInCount The number of next party size of TSS group.
772     /// @param _tssThreshold The number of next threshold.
773     /// @param _nodeRewardsRatio The number of rewards ratio for node owners
774     /// @param _withdrawalFeeBPS The amount of wthdrawal fees.
775     function churn(
776         address _newOwner,
777         bytes32[] memory _rewardAddressAndAmounts,
778         bool[] memory _isRemoved,
779         uint8 _churnedInCount,
780         uint8 _tssThreshold,
781         uint8 _nodeRewardsRatio,
782         uint8 _withdrawalFeeBPS
783     ) external override onlyOwner returns (bool) {
784         require(
785             _tssThreshold >= tssThreshold && _tssThreshold <= 2**8 - 1,
786             "_tssThreshold should be >= tssThreshold"
787         );
788         require(
789             _churnedInCount >= _tssThreshold + uint8(1),
790             "n should be >= t+1"
791         );
792         require(
793             _nodeRewardsRatio >= 0 && _nodeRewardsRatio <= 100,
794             "_nodeRewardsRatio is not valid"
795         );
796         require(
797             _withdrawalFeeBPS >= 0 && _withdrawalFeeBPS <= 100,
798             "_withdrawalFeeBPS is invalid"
799         );
800         require(
801             _rewardAddressAndAmounts.length == _isRemoved.length,
802             "_rewardAddressAndAmounts and _isRemoved length is not match"
803         );
804         transferOwnership(_newOwner);
805         // Update active node list
806         for (uint256 i = 0; i < _rewardAddressAndAmounts.length; i++) {
807             (address newNode, ) = _splitToValues(_rewardAddressAndAmounts[i]);
808             _addNode(newNode, _rewardAddressAndAmounts[i], _isRemoved[i]);
809         }
810         bytes32[] memory nodeList = getActiveNodes();
811         if (nodeList.length > 100) {
812             revert("Stored node size should be <= 100");
813         }
814         churnedInCount = _churnedInCount;
815         tssThreshold = _tssThreshold;
816         nodeRewardsRatio = _nodeRewardsRatio;
817         withdrawalFeeBPS = _withdrawalFeeBPS;
818         return true;
819     }
820 
821     /// @dev isTxUsed sends rewards for Nodes.
822     /// @param _txid The txid which is for recording.
823     function isTxUsed(bytes32 _txid) public override view returns (bool) {
824         return used[_txid];
825     }
826 
827     /// @dev getCurrentPriceLP returns the current exchange rate of LP token.
828     function getCurrentPriceLP()
829         public
830         override
831         view
832         returns (uint256 nowPrice)
833     {
834         (uint256 reserveA, uint256 reserveB) = getFloatReserve(
835             address(0),
836             WBTC_ADDR
837         );
838         uint256 totalLPs = IBurnableToken(lpToken).totalSupply();
839         // decimals of totalReserved == 8, lpDecimals == 8, decimals of rate == 8
840         nowPrice = totalLPs == 0
841             ? initialExchangeRate
842             : (reserveA.add(reserveB)).mul(lpDecimals).div(
843                 totalLPs.add(lockedLPTokensForNode)
844             );
845         return nowPrice;
846     }
847 
848     /// @dev getDepositFeeRate returns deposit fees rate
849     /// @param _token The address of target token.
850     /// @param _amountOfFloat The amount of float.
851     function getDepositFeeRate(address _token, uint256 _amountOfFloat)
852         public
853         override
854         view
855         returns (uint256 depositFeeRate)
856     {
857         uint8 isFlip = _checkFlips(_token, _amountOfFloat);
858         if (isFlip == 1) {
859             depositFeeRate = _token == WBTC_ADDR ? depositFeesBPS : 0;
860         } else if (isFlip == 2) {
861             depositFeeRate = _token == address(0) ? depositFeesBPS : 0;
862         }
863     }
864 
865     /// @dev getFloatReserve returns float reserves
866     /// @param _tokenA The address of target tokenA.
867     /// @param _tokenB The address of target tokenB.
868     function getFloatReserve(address _tokenA, address _tokenB)
869         public
870         override
871         view
872         returns (uint256 reserveA, uint256 reserveB)
873     {
874         (reserveA, reserveB) = (floatAmountOf[_tokenA], floatAmountOf[_tokenB]);
875     }
876 
877     /// @dev getActiveNodes returns active nodes list (stakes and amount)
878     function getActiveNodes() public override view returns (bytes32[] memory) {
879         uint256 nodeCount = 0;
880         uint256 count = 0;
881         // Seek all nodes
882         for (uint256 i = 0; i < nodeAddrs.length; i++) {
883             if (nodes[nodeAddrs[i]] != 0x0) {
884                 nodeCount = nodeCount.add(1);
885             }
886         }
887         bytes32[] memory _nodes = new bytes32[](nodeCount);
888         for (uint256 i = 0; i < nodeAddrs.length; i++) {
889             if (nodes[nodeAddrs[i]] != 0x0) {
890                 _nodes[count] = nodes[nodeAddrs[i]];
891                 count = count.add(1);
892             }
893         }
894         return _nodes;
895     }
896 
897     /// @dev _issueLPTokensForFloat
898     /// @param _token The address of target token.
899     /// @param _transaction The recevier address and amount.
900     /// @param _zerofee The flag to accept zero fees.
901     /// @param _txid The txid which is for recording.
902     function _issueLPTokensForFloat(
903         address _token,
904         bytes32 _transaction,
905         bool _zerofee,
906         bytes32 _txid
907     ) internal returns (bool) {
908         require(!isTxUsed(_txid), "The txid is already used");
909         require(_transaction != 0x0, "The transaction is not valid");
910         // Define target address which is recorded on the tx data (20 bytes)
911         // Define amountOfFloat which is recorded top on tx data (12 bytes)
912         (address to, uint256 amountOfFloat) = _splitToValues(_transaction);
913         // Calculate the amount of LP token
914         uint256 nowPrice = getCurrentPriceLP();
915         uint256 amountOfLP = amountOfFloat.mul(priceDecimals).div(nowPrice);
916         uint256 depositFeeRate = getDepositFeeRate(_token, amountOfFloat);
917         uint256 depositFees = depositFeeRate != 0
918             ? amountOfLP.mul(depositFeeRate).div(10000)
919             : 0;
920 
921         if (_zerofee && depositFees != 0) {
922             revert();
923         }
924         // Send LP tokens to LP
925         IBurnableToken(lpToken).mint(to, amountOfLP.sub(depositFees));
926         // Add deposit fees
927         lockedLPTokensForNode = lockedLPTokensForNode.add(depositFees);
928         // Add float amount
929         _addFloat(_token, amountOfFloat);
930         _addUsedTx(_txid);
931         emit IssueLPTokensForFloat(
932             to,
933             amountOfFloat,
934             amountOfLP,
935             nowPrice,
936             depositFees,
937             _txid
938         );
939         return true;
940     }
941 
942     /// @dev _burnLPTokensForFloat
943     /// @param _token The address of target token.
944     /// @param _transaction The address of sender and amount.
945     /// @param _minerFee The miner fees of BTC transaction.
946     /// @param _txid The txid which is for recording.
947     function _burnLPTokensForFloat(
948         address _token,
949         bytes32 _transaction,
950         uint256 _minerFee,
951         bytes32 _txid
952     ) internal returns (bool) {
953         require(!isTxUsed(_txid), "The txid is already used");
954         require(_transaction != 0x0, "The transaction is not valid");
955         // Define target address which is recorded on the tx data (20bytes)
956         // Define amountLP which is recorded top on tx data (12bytes)
957         (address to, uint256 amountOfLP) = _splitToValues(_transaction);
958         // Calculate the amount of LP token
959         uint256 nowPrice = getCurrentPriceLP();
960         // Calculate the amountOfFloat
961         uint256 amountOfFloat = amountOfLP.mul(nowPrice).div(priceDecimals);
962         uint256 withdrawalFees = amountOfFloat.mul(withdrawalFeeBPS).div(10000);
963         require(
964             amountOfFloat.sub(withdrawalFees) >= _minerFee,
965             "Error: amountOfFloat.sub(withdrawalFees) < _minerFee"
966         );
967         uint256 withdrawal = amountOfFloat.sub(withdrawalFees).sub(_minerFee);
968         (uint256 reserveA, uint256 reserveB) = getFloatReserve(
969             address(0),
970             WBTC_ADDR
971         );
972         if (_token == address(0)) {
973             require(
974                 reserveA >= amountOfFloat.sub(withdrawalFees),
975                 "The float balance insufficient."
976             );
977         } else if (_token == WBTC_ADDR) {
978             require(
979                 reserveB >= amountOfFloat.sub(withdrawalFees),
980                 "The float balance insufficient."
981             );
982         }
983         // Collect fees before remove float
984         _rewardsCollection(_token, withdrawalFees);
985         // Remove float amount
986         _removeFloat(_token, amountOfFloat);
987         // Add txid for recording.
988         _addUsedTx(_txid);
989         // WBTC transfer if token address is WBTC_ADDR
990         if (_token == WBTC_ADDR) {
991             // _minerFee should be zero
992             require(
993                 IERC20(_token).transfer(to, withdrawal),
994                 "WBTC balance insufficient"
995             );
996         }
997         // Burn LP tokens
998         require(IBurnableToken(lpToken).burn(amountOfLP));
999         emit BurnLPTokensForFloat(
1000             to,
1001             amountOfLP,
1002             amountOfFloat,
1003             nowPrice,
1004             withdrawal,
1005             _txid
1006         );
1007         return true;
1008     }
1009 
1010     /// @dev _checkFlips checks whether the fees are activated.
1011     /// @param _token The address of target token.
1012     /// @param _amountOfFloat The amount of float.
1013     function _checkFlips(address _token, uint256 _amountOfFloat)
1014         internal
1015         view
1016         returns (uint8)
1017     {
1018         (uint256 reserveA, uint256 reserveB) = getFloatReserve(
1019             address(0),
1020             WBTC_ADDR
1021         );
1022         uint256 threshold = reserveA
1023             .add(reserveB)
1024             .add(_amountOfFloat)
1025             .mul(2)
1026             .div(3);
1027         if (_token == WBTC_ADDR && reserveB.add(_amountOfFloat) >= threshold) {
1028             return 1; // BTC float insufficient
1029         }
1030         if (_token == address(0) && reserveA.add(_amountOfFloat) >= threshold) {
1031             return 2; // WBTC float insufficient
1032         }
1033         return 0;
1034     }
1035 
1036     /// @dev _addFloat updates one side of the float.
1037     /// @param _token The address of target token.
1038     /// @param _amount The amount of float.
1039     function _addFloat(address _token, uint256 _amount) internal {
1040         floatAmountOf[_token] = floatAmountOf[_token].add(_amount);
1041     }
1042 
1043     /// @dev _removeFloat remove one side of the float.
1044     /// @param _token The address of target token.
1045     /// @param _amount The amount of float.
1046     function _removeFloat(address _token, uint256 _amount) internal {
1047         floatAmountOf[_token] = floatAmountOf[_token].sub(
1048             _amount,
1049             "_removeFloat: float amount insufficient"
1050         );
1051     }
1052 
1053     /// @dev _swap collects swap amount to change float.
1054     /// @param _sourceToken The address of source token
1055     /// @param _destToken The address of target token.
1056     /// @param _swapAmount The amount of swap.
1057     function _swap(
1058         address _sourceToken,
1059         address _destToken,
1060         uint256 _swapAmount
1061     ) internal {
1062         floatAmountOf[_destToken] = floatAmountOf[_destToken].sub(
1063             _swapAmount,
1064             "_swap: float amount insufficient"
1065         );
1066         floatAmountOf[_sourceToken] = floatAmountOf[_sourceToken].add(
1067             _swapAmount
1068         );
1069         emit Swap(_sourceToken, _destToken, _swapAmount);
1070     }
1071 
1072     /// @dev _rewardsCollection collects tx rewards.
1073     /// @param _feesToken The token address for collection fees.
1074     /// @param _rewardsAmount The amount of rewards.
1075     function _rewardsCollection(address _feesToken, uint256 _rewardsAmount)
1076         internal
1077     {
1078         if (_rewardsAmount == 0) return;
1079         if (_feesToken == lpToken) {
1080             feesLPTokensForNode = feesLPTokensForNode.add(_rewardsAmount);
1081             emit RewardsCollection(_feesToken, _rewardsAmount, 0, 0);
1082             return;
1083         }
1084         // Get current LP token price.
1085         uint256 nowPrice = getCurrentPriceLP();
1086         // Add all fees into pool
1087         floatAmountOf[_feesToken] = floatAmountOf[_feesToken].add(
1088             _rewardsAmount
1089         );
1090         uint256 amountForNodes = _rewardsAmount.mul(nodeRewardsRatio).div(100);
1091         // Alloc LP tokens for nodes as fees
1092         uint256 amountLPTokensForNode = amountForNodes.mul(priceDecimals).div(
1093             nowPrice
1094         );
1095         // Add minted LP tokens for Nodes
1096         lockedLPTokensForNode = lockedLPTokensForNode.add(
1097             amountLPTokensForNode
1098         );
1099         emit RewardsCollection(
1100             _feesToken,
1101             _rewardsAmount,
1102             amountLPTokensForNode,
1103             nowPrice
1104         );
1105     }
1106 
1107     /// @dev _addUsedTx updates txid list which is spent. (single hash)
1108     /// @param _txid The array of txid.
1109     function _addUsedTx(bytes32 _txid) internal {
1110         used[_txid] = true;
1111     }
1112 
1113     /// @dev _addUsedTxs updates txid list which is spent. (multiple hashes)
1114     /// @param _txids The array of txid.
1115     function _addUsedTxs(bytes32[] memory _txids) internal {
1116         for (uint256 i = 0; i < _txids.length; i++) {
1117             used[_txids[i]] = true;
1118         }
1119     }
1120 
1121     /// @dev _addNode updates a staker's info.
1122     /// @param _addr The address of staker.
1123     /// @param _data The data of staker.
1124     /// @param _remove The flag to remove node.
1125     function _addNode(
1126         address _addr,
1127         bytes32 _data,
1128         bool _remove
1129     ) internal returns (bool) {
1130         if (_remove) {
1131             delete nodes[_addr];
1132             return true;
1133         }
1134         if (!isInList[_addr]) {
1135             nodeAddrs.push(_addr);
1136             isInList[_addr] = true;
1137         }
1138         if (nodes[_addr] == 0x0) {
1139             nodes[_addr] = _data;
1140         }
1141         return true;
1142     }
1143 
1144     /// @dev _splitToValues returns address and amount of staked SWINGBYs
1145     /// @param _data The info of a staker.
1146     function _splitToValues(bytes32 _data)
1147         internal
1148         pure
1149         returns (address, uint256)
1150     {
1151         return (
1152             address(uint160(uint256(_data))),
1153             uint256(uint96(bytes12(_data)))
1154         );
1155     }
1156 
1157     /// @dev The contract doesn't allow receiving Ether.
1158     fallback() external {
1159         revert();
1160     }
1161 }