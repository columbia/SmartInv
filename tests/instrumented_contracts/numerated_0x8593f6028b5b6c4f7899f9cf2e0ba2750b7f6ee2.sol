1 /*
2 
3   Copyright 2018 bZeroX, LLC
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.24;
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (a == 0) {
35       return 0;
36     }
37 
38     c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     // uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return a / b;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77   address public owner;
78 
79 
80   event OwnershipRenounced(address indexed previousOwner);
81   event OwnershipTransferred(
82     address indexed previousOwner,
83     address indexed newOwner
84   );
85 
86 
87   /**
88    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89    * account.
90    */
91   constructor() public {
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to relinquish control of the contract.
105    */
106   function renounceOwnership() public onlyOwner {
107     emit OwnershipRenounced(owner);
108     owner = address(0);
109   }
110 
111   /**
112    * @dev Allows the current owner to transfer control of the contract to a newOwner.
113    * @param _newOwner The address to transfer ownership to.
114    */
115   function transferOwnership(address _newOwner) public onlyOwner {
116     _transferOwnership(_newOwner);
117   }
118 
119   /**
120    * @dev Transfers control of the contract to a newOwner.
121    * @param _newOwner The address to transfer ownership to.
122    */
123   function _transferOwnership(address _newOwner) internal {
124     require(_newOwner != address(0));
125     emit OwnershipTransferred(owner, _newOwner);
126     owner = _newOwner;
127   }
128 }
129 
130 // This provides a gatekeeping modifier for functions that can only be used by the bZx contract
131 // Since it inherits Ownable provides typical ownership functionality with a slight modification to the transferOwnership function
132 // Setting owner and bZxContractAddress to the same address is not supported.
133 contract BZxOwnable is Ownable {
134 
135     address public bZxContractAddress;
136 
137     event BZxOwnershipTransferred(address indexed previousBZxContract, address indexed newBZxContract);
138 
139     // modifier reverts if bZxContractAddress isn't set
140     modifier onlyBZx() {
141         require(msg.sender == bZxContractAddress, "only bZx contracts can call this function");
142         _;
143     }
144 
145     /**
146     * @dev Allows the current owner to transfer the bZx contract owner to a new contract address
147     * @param newBZxContractAddress The bZx contract address to transfer ownership to.
148     */
149     function transferBZxOwnership(address newBZxContractAddress) public onlyOwner {
150         require(newBZxContractAddress != address(0) && newBZxContractAddress != owner, "transferBZxOwnership::unauthorized");
151         emit BZxOwnershipTransferred(bZxContractAddress, newBZxContractAddress);
152         bZxContractAddress = newBZxContractAddress;
153     }
154 
155     /**
156     * @dev Allows the current owner to transfer control of the contract to a newOwner.
157     * @param newOwner The address to transfer ownership to.
158     * This overrides transferOwnership in Ownable to prevent setting the new owner the same as the bZxContract
159     */
160     function transferOwnership(address newOwner) public onlyOwner {
161         require(newOwner != address(0) && newOwner != bZxContractAddress, "transferOwnership::unauthorized");
162         emit OwnershipTransferred(owner, newOwner);
163         owner = newOwner;
164     }
165 }
166 
167 contract GasRefunder {
168     using SafeMath for uint256;
169 
170     // If true, uses the "transfer" method, which throws on failure, reverting state.
171     // If false, a failed "send" won't throw, and fails silently.
172     // Note that a throw will prevent a GasRefund event.
173     bool public throwOnGasRefundFail = false;
174 
175     struct GasData {
176         address payer;
177         uint gasUsed;
178         bool isPaid;
179     }
180 
181     event GasRefund(address payer, uint gasUsed, uint currentGasPrice, uint refundAmount, bool refundSuccess);
182 
183     modifier refundsGas(address payer, uint gasPrice, uint gasUsed, uint percentMultiplier)
184     {
185         _;
186         calculateAndSendRefund(
187             payer,
188             gasUsed,
189             gasPrice,
190             percentMultiplier
191         );
192     }
193 
194     modifier refundsGasAfterCollection(address payer, uint gasPrice, uint percentMultiplier)
195     {
196         uint startingGas = gasleft();
197         _;
198         calculateAndSendRefund(
199             payer,
200             startingGas,
201             gasPrice,
202             percentMultiplier
203         );
204     }
205 
206     function calculateAndSendRefund(
207         address payer,
208         uint gasUsed,
209         uint gasPrice,
210         uint percentMultiplier)
211         internal
212     {
213 
214         if (gasUsed == 0 || gasPrice == 0)
215             return;
216 
217         gasUsed = gasUsed - gasleft();
218 
219         sendRefund(
220             payer,
221             gasUsed,
222             gasPrice,
223             percentMultiplier
224         );
225     }
226 
227     function sendRefund(
228         address payer,
229         uint gasUsed,
230         uint gasPrice,
231         uint percentMultiplier)
232         internal
233         returns (bool)
234     {
235         if (percentMultiplier == 0) // 0 percentMultiplier not allowed
236             percentMultiplier = 100;
237         
238         uint refundAmount = gasUsed.mul(gasPrice).mul(percentMultiplier).div(100);
239 
240         if (throwOnGasRefundFail) {
241             payer.transfer(refundAmount);
242             emit GasRefund(
243                 payer,
244                 gasUsed,
245                 gasPrice,
246                 refundAmount,
247                 true
248             );
249         } else {
250             emit GasRefund(
251                 payer,
252                 gasUsed,
253                 gasPrice,
254                 refundAmount,
255                 payer.send(refundAmount)
256             );
257         }
258 
259         return true;
260     }
261 
262 }
263 
264 // supports a single EMA calculated for the inheriting contract
265 contract EMACollector {
266 
267     uint public emaValue; // the last ema calculated
268     uint public emaPeriods; // averaging periods for EMA calculation
269 
270     modifier updatesEMA(uint value) {
271         _;
272         updateEMA(value);
273     }
274 
275     function updateEMA(uint value) 
276         internal {
277         /*
278             Multiplier: 2 / (emaPeriods + 1)
279             EMA: (LastestValue - PreviousEMA) * Multiplier + PreviousEMA 
280         */
281 
282         require(emaPeriods >= 2, "emaPeriods < 2");
283 
284         // calculate new EMA
285         emaValue = 
286             SafeMath.sub(
287                 SafeMath.add(
288                     value / (emaPeriods + 1) * 2,
289                     emaValue
290                 ),
291                 emaValue / (emaPeriods + 1) * 2
292             );
293     }
294 }
295 
296 /**
297  * @title ERC20Basic
298  * @dev Simpler version of ERC20 interface
299  * @dev see https://github.com/ethereum/EIPs/issues/179
300  */
301 contract ERC20Basic {
302   function totalSupply() public view returns (uint256);
303   function balanceOf(address who) public view returns (uint256);
304   function transfer(address to, uint256 value) public returns (bool);
305   event Transfer(address indexed from, address indexed to, uint256 value);
306 }
307 
308 /**
309  * @title ERC20 interface
310  * @dev see https://github.com/ethereum/EIPs/issues/20
311  */
312 contract ERC20 is ERC20Basic {
313   function allowance(address owner, address spender)
314     public view returns (uint256);
315 
316   function transferFrom(address from, address to, uint256 value)
317     public returns (bool);
318 
319   function approve(address spender, uint256 value) public returns (bool);
320   event Approval(
321     address indexed owner,
322     address indexed spender,
323     uint256 value
324   );
325 }
326 
327 /**
328  * @title EIP20/ERC20 interface
329  * @dev see https://github.com/ethereum/EIPs/issues/20
330  */
331 contract EIP20 is ERC20 {
332     string public name;
333     uint8 public decimals;
334     string public symbol;
335 }
336 
337 interface NonCompliantEIP20 {
338     function transfer(address _to, uint _value) external;
339     function transferFrom(address _from, address _to, uint _value) external;
340     function approve(address _spender, uint _value) external;
341 }
342 
343 /**
344  * @title EIP20/ERC20 wrapper that will support noncompliant ERC20s
345  * @dev see https://github.com/ethereum/EIPs/issues/20
346  * @dev see https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
347  */
348 contract EIP20Wrapper {
349 
350     function eip20Transfer(
351         address token,
352         address to,
353         uint256 value)
354         internal
355         returns (bool result) {
356 
357         NonCompliantEIP20(token).transfer(to, value);
358 
359         assembly {
360             switch returndatasize()   
361             case 0 {                        // non compliant ERC20
362                 result := not(0)            // result is true
363             }
364             case 32 {                       // compliant ERC20
365                 returndatacopy(0, 0, 32) 
366                 result := mload(0)          // result == returndata of external call
367             }
368             default {                       // not an not an ERC20 token
369                 revert(0, 0) 
370             }
371         }
372 
373         require(result, "eip20Transfer failed");
374     }
375 
376     function eip20TransferFrom(
377         address token,
378         address from,
379         address to,
380         uint256 value)
381         internal
382         returns (bool result) {
383 
384         NonCompliantEIP20(token).transferFrom(from, to, value);
385 
386         assembly {
387             switch returndatasize()   
388             case 0 {                        // non compliant ERC20
389                 result := not(0)            // result is true
390             }
391             case 32 {                       // compliant ERC20
392                 returndatacopy(0, 0, 32) 
393                 result := mload(0)          // result == returndata of external call
394             }
395             default {                       // not an not an ERC20 token
396                 revert(0, 0) 
397             }
398         }
399 
400         require(result, "eip20TransferFrom failed");
401     }
402 
403     function eip20Approve(
404         address token,
405         address spender,
406         uint256 value)
407         internal
408         returns (bool result) {
409 
410         NonCompliantEIP20(token).approve(spender, value);
411 
412         assembly {
413             switch returndatasize()   
414             case 0 {                        // non compliant ERC20
415                 result := not(0)            // result is true
416             }
417             case 32 {                       // compliant ERC20
418                 returndatacopy(0, 0, 32) 
419                 result := mload(0)          // result == returndata of external call
420             }
421             default {                       // not an not an ERC20 token
422                 revert(0, 0) 
423             }
424         }
425 
426         require(result, "eip20Approve failed");
427     }
428 }
429 
430 interface OracleInterface {
431 
432     /// @dev Called by bZx after a loan order is taken
433     /// @param loanOrderHash A unique hash representing the loan order
434     /// @param taker The taker of the loan order
435     /// @param gasUsed The initial used gas, collected in a modifier in bZx, for optional gas refunds
436     /// @return Successful execution of the function
437     function didTakeOrder(
438         bytes32 loanOrderHash,
439         address taker,
440         uint gasUsed)
441         external
442         returns (bool);
443 
444     /// @dev Called by bZx after a position token is traded
445     /// @param loanOrderHash A unique hash representing the loan order
446     /// @param trader The trader doing the trade
447     /// @param tradeTokenAddress The token that was bought in the trade
448     /// @param tradeTokenAmount The amount of token that was bought
449     /// @param gasUsed The initial used gas, collected in a modifier in bZx, for optional gas refunds
450     /// @return Successful execution of the function
451     function didTradePosition(
452         bytes32 loanOrderHash,
453         address trader,
454         address tradeTokenAddress,
455         uint tradeTokenAmount,
456         uint gasUsed)
457         external
458         returns (bool);
459 
460     /// @dev Called by bZx after interest should be paid to a lender
461     /// @dev Assume the interest token has already been transfered to
462     /// @dev this contract before this function is called.
463     /// @param loanOrderHash A unique hash representing the loan order
464     /// @param trader The trader
465     /// @param lender The lender
466     /// @param interestTokenAddress The token that will be paid for interest
467     /// @param amountOwed The amount interest to pay
468     /// @param convert A boolean indicating if the interest should be converted to Ether
469     /// @param gasUsed The initial used gas, collected in a modifier in bZx, for optional gas refunds
470     /// @return Successful execution of the function
471     function didPayInterest(
472         bytes32 loanOrderHash,
473         address trader,
474         address lender,
475         address interestTokenAddress,
476         uint amountOwed,
477         bool convert,
478         uint gasUsed)
479         external
480         returns (bool);
481 
482     /// @dev Called by bZx after a borrower has deposited additional collateral
483     /// @dev token for an open loan
484     /// @param loanOrderHash A unique hash representing the loan order.
485     /// @param borrower The borrower
486     /// @param gasUsed The initial used gas, collected in a modifier in bZx, for optional gas refunds
487     /// @return Successful execution of the function
488     function didDepositCollateral(
489         bytes32 loanOrderHash,
490         address borrower,
491         uint gasUsed)
492         external
493         returns (bool);
494 
495     /// @dev Called by bZx after a borrower has withdrawn excess collateral
496     /// @dev token for an open loan
497     /// @param loanOrderHash A unique hash representing the loan order.
498     /// @param borrower The borrower
499     /// @param gasUsed The initial used gas, collected in a modifier in bZx, for optional gas refunds
500     /// @return Successful execution of the function
501     function didWithdrawCollateral(
502         bytes32 loanOrderHash,
503         address borrower,
504         uint gasUsed)
505         external
506         returns (bool);
507 
508     /// @dev Called by bZx after a borrower has changed the collateral token
509     /// @dev used for an open loan
510     /// @param loanOrderHash A unique hash representing the loan order
511     /// @param borrower The borrower
512     /// @param gasUsed The initial used gas, collected in a modifier in bZx, for optional gas refunds
513     /// @return Successful execution of the function
514     function didChangeCollateral(
515         bytes32 loanOrderHash,
516         address borrower,
517         uint gasUsed)
518         external
519         returns (bool);
520 
521     /// @dev Called by bZx after a borrower has withdraw their profits, if any
522     /// @dev used for an open loan
523     /// @param loanOrderHash A unique hash representing the loan order
524     /// @param borrower The borrower
525     /// @param gasUsed The initial used gas, collected in a modifier in bZx, for optional gas refunds
526     /// @return Successful execution of the function
527     function didWithdrawProfit(
528         bytes32 loanOrderHash,
529         address borrower,
530         uint profitOrLoss,
531         uint gasUsed)
532         external
533         returns (bool);
534 
535     /// @dev Called by bZx after a loan is closed
536     /// @param loanOrderHash A unique hash representing the loan order.
537     /// @param loanCloser The user that closed the loan
538     /// @param isLiquidation A boolean indicating if the loan was closed due to liquidation
539     /// @param gasUsed The initial used gas, collected in a modifier in bZx, for optional gas refunds
540     /// @return Successful execution of the function
541     function didCloseLoan(
542         bytes32 loanOrderHash,
543         address loanCloser,
544         bool isLiquidation,
545         uint gasUsed)
546         external
547         returns (bool);
548 
549     /// @dev Places a manual on-chain trade with a liquidity provider
550     /// @param sourceTokenAddress The token being sold
551     /// @param destTokenAddress The token being bought
552     /// @param sourceTokenAmount The amount of token being sold
553     /// @return The amount of destToken bought
554     function doManualTrade(
555         address sourceTokenAddress,
556         address destTokenAddress,
557         uint sourceTokenAmount)
558         external
559         returns (uint);
560 
561     /// @dev Places an automatic on-chain trade with a liquidity provider
562     /// @param sourceTokenAddress The token being sold
563     /// @param destTokenAddress The token being bought
564     /// @param sourceTokenAmount The amount of token being sold
565     /// @return The amount of destToken bought
566     function doTrade(
567         address sourceTokenAddress,
568         address destTokenAddress,
569         uint sourceTokenAmount)
570         external
571         returns (uint);
572 
573     /// @dev Verifies a position has fallen below margin maintenance
574     /// @dev then liquidates the position on-chain
575     /// @param loanTokenAddress The token that was loaned
576     /// @param positionTokenAddress The token in the current position (could also be the loanToken)
577     /// @param collateralTokenAddress The token used for collateral
578     /// @param loanTokenAmount The amount of loan token
579     /// @param positionTokenAmount The amount of position token
580     /// @param collateralTokenAmount The amount of collateral token
581     /// @param maintenanceMarginAmount The maintenance margin amount from the loan
582     /// @return The amount of destToken bought
583     function verifyAndLiquidate(
584         address loanTokenAddress,
585         address positionTokenAddress,
586         address collateralTokenAddress,
587         uint loanTokenAmount,
588         uint positionTokenAmount,
589         uint collateralTokenAmount,
590         uint maintenanceMarginAmount)
591         external
592         returns (uint);
593 
594     /// @dev Liquidates collateral to cover loan losses
595     /// @param collateralTokenAddress The collateral token
596     /// @param loanTokenAddress The loan token
597     /// @param collateralTokenAmountUsable The total amount of collateral usable to cover losses
598     /// @param loanTokenAmountNeeded The amount of loan token needed to cover losses
599     /// @param initialMarginAmount The initial margin amount set for the loan
600     /// @param maintenanceMarginAmount The maintenance margin amount set for the loan
601     /// @return The amount of destToken bought
602     function doTradeofCollateral(
603         address collateralTokenAddress,
604         address loanTokenAddress,
605         uint collateralTokenAmountUsable,
606         uint loanTokenAmountNeeded,
607         uint initialMarginAmount,
608         uint maintenanceMarginAmount)
609         external
610         returns (uint, uint);
611 
612     /// @dev Checks if a position has fallen below margin
613     /// @dev maintenance and should be liquidated
614     /// @param loanOrderHash A unique hash representing the loan order
615     /// @param trader The address of the trader
616     /// @param loanTokenAddress The token that was loaned
617     /// @param positionTokenAddress The token in the current position (could also be the loanToken)
618     /// @param collateralTokenAddress The token used for collateral
619     /// @param loanTokenAmount The amount of loan token
620     /// @param positionTokenAmount The amount of position token
621     /// @param collateralTokenAmount The amount of collateral token
622     /// @param maintenanceMarginAmount The maintenance margin amount from the loan
623     /// @return Returns True if the trade should be liquidated immediately
624     function shouldLiquidate(
625         bytes32 loanOrderHash,
626         address trader,
627         address loanTokenAddress,
628         address positionTokenAddress,
629         address collateralTokenAddress,
630         uint loanTokenAmount,
631         uint positionTokenAmount,
632         uint collateralTokenAmount,
633         uint maintenanceMarginAmount)
634         external
635         view
636         returns (bool);
637 
638     /// @dev Gets the trade price of the ERC-20 token pair
639     /// @param sourceTokenAddress Token being sold
640     /// @param destTokenAddress Token being bought
641     /// @return The trade rate
642     function getTradeRate(
643         address sourceTokenAddress,
644         address destTokenAddress)
645         external
646         view 
647         returns (uint);
648 
649     /// @dev Returns the profit/loss data for the current position
650     /// @param positionTokenAddress The token in the current position (could also be the loanToken)
651     /// @param loanTokenAddress The token that was loaned
652     /// @param positionTokenAmount The amount of position token
653     /// @param loanTokenAmount The amount of loan token
654     /// @return isProfit, profitOrLoss (denominated in positionToken)
655     function getProfitOrLoss(
656         address positionTokenAddress,
657         address loanTokenAddress,
658         uint positionTokenAmount,
659         uint loanTokenAmount)
660         external
661         view
662         returns (bool isProfit, uint profitOrLoss);
663 
664     /// @dev Returns the current margin level for this particular loan/position
665     /// @param loanTokenAddress The token that was loaned
666     /// @param positionTokenAddress The token in the current position (could also be the loanToken)
667     /// @param collateralTokenAddress The token used for collateral
668     /// @param loanTokenAmount The amount of loan token
669     /// @param positionTokenAmount The amount of position token
670     /// @param collateralTokenAmount The amount of collateral token
671     /// @return The current margin amount (a percentage -> i.e. 54350000000000000000 == 54.35%)
672     function getCurrentMarginAmount(
673         address loanTokenAddress,
674         address positionTokenAddress,
675         address collateralTokenAddress,
676         uint loanTokenAmount,
677         uint positionTokenAmount,
678         uint collateralTokenAmount)
679         external
680         view
681         returns (uint);
682 
683     /// @dev Checks if the ERC20 token pair is supported by the oracle
684     /// @param sourceTokenAddress Token being sold
685     /// @param destTokenAddress Token being bought
686     /// @param sourceTokenAmount Amount of token being sold
687     /// @return True if price discovery and trading is supported
688     function isTradeSupported(
689         address sourceTokenAddress,
690         address destTokenAddress,
691         uint sourceTokenAmount)
692         external
693         view 
694         returns (bool);
695 }
696 
697 interface WETH_Interface {
698     function deposit() external payable;
699     function withdraw(uint wad) external;
700 }
701 
702 interface KyberNetwork_Interface {
703     /// @notice use token address ETH_TOKEN_ADDRESS for ether
704     /// @dev makes a trade between src and dest token and send dest token to destAddress
705     /// @param src Src token
706     /// @param srcAmount amount of src tokens
707     /// @param dest   Destination token
708     /// @param destAddress Address to send tokens to
709     /// @param maxDestAmount A limit on the amount of dest tokens
710     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
711     /// @param walletId is the wallet ID to send part of the fees
712     /// @return amount of actual dest tokens
713     function trade(
714         address src,
715         uint srcAmount,
716         address dest,
717         address destAddress,
718         uint maxDestAmount,
719         uint minConversionRate,
720         address walletId
721     )
722         external
723         payable
724         returns(uint);
725 
726     /// @notice use token address ETH_TOKEN_ADDRESS for ether
727     function getExpectedRate(
728         address src,
729         address dest,
730         uint srcQty) 
731         external 
732         view 
733         returns (uint expectedRate, uint slippageRate);
734 }
735 
736 contract BZxOracle is OracleInterface, EIP20Wrapper, EMACollector, GasRefunder, BZxOwnable {
737     using SafeMath for uint256;
738 
739     // this is the value the Kyber portal uses when setting a very high maximum number
740     uint internal constant MAX_FOR_KYBER = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
741 
742     address internal constant KYBER_ETH_TOKEN_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
743 
744     // Percentage of interest retained as fee
745     // This will always be between 0 and 100
746     uint public interestFeePercent = 10;
747 
748     // Percentage of liquidation level that will trigger a liquidation of positions
749     // This can never be less than 100
750     uint public liquidationThresholdPercent = 105;
751 
752     // Percentage of gas refund paid to non-bounty hunters
753     uint public gasRewardPercent = 10;
754 
755     // Percentage of gas refund paid to bounty hunters after successfully liquidating a position
756     uint public bountyRewardPercent = 110;
757 
758     // A threshold of minimum initial margin for loan to be insured by the guarantee fund
759     // A value of 0 indicates that no threshold exists for this parameter.
760     uint public minInitialMarginAmount = 0;
761 
762     // A threshold of minimum maintenance margin for loan to be insured by the guarantee fund
763     // A value of 0 indicates that no threshold exists for this parameter.
764     uint public minMaintenanceMarginAmount = 25;
765 
766     bool public isManualTradingAllowed = true;
767 
768     address public vaultContract;
769     address public kyberContract;
770     address public wethContract;
771     address public bZRxTokenContract;
772 
773     mapping (bytes32 => GasData[]) public gasRefunds; // mapping of loanOrderHash to array of GasData
774 
775     constructor(
776         address _vaultContract,
777         address _kyberContract,
778         address _wethContract,
779         address _bZRxTokenContract)
780         public
781         payable
782     {
783         vaultContract = _vaultContract;
784         kyberContract = _kyberContract;
785         wethContract = _wethContract;
786         bZRxTokenContract = _bZRxTokenContract;
787 
788         // settings for EMACollector
789         emaValue = 20 * 10**9 wei; // set an initial price average for gas (20 gwei)
790         emaPeriods = 10; // set periods to use for EMA calculation
791     }
792 
793     // The contract needs to be able to receive Ether from Kyber trades
794     function() public payable {}
795 
796     // standard functions
797     function didTakeOrder(
798         bytes32 loanOrderHash,
799         address taker,
800         uint gasUsed)
801         public
802         onlyBZx
803         updatesEMA(tx.gasprice)
804         returns (bool)
805     {
806         gasRefunds[loanOrderHash].push(GasData({
807             payer: taker,
808             gasUsed: gasUsed.sub(gasleft()),
809             isPaid: false
810         }));
811 
812         return true;
813     }
814 
815     function didTradePosition(
816         bytes32 /* loanOrderHash */,
817         address /* trader */,
818         address /* tradeTokenAddress */,
819         uint /* tradeTokenAmount */,
820         uint /* gasUsed */)
821         public
822         onlyBZx
823         updatesEMA(tx.gasprice)
824         returns (bool)
825     {
826         return true;
827     }
828 
829     function didPayInterest(
830         bytes32 /* loanOrderHash */,
831         address /* trader */,
832         address lender,
833         address interestTokenAddress,
834         uint amountOwed,
835         bool convert,
836         uint /* gasUsed */)
837         public
838         onlyBZx
839         updatesEMA(tx.gasprice)
840         returns (bool)
841     {
842         uint interestFee = amountOwed.mul(interestFeePercent).div(100);
843 
844         // Transfers the interest to the lender, less the interest fee.
845         // The fee is retained by the oracle.
846         if (!_transferToken(
847             interestTokenAddress,
848             lender,
849             amountOwed.sub(interestFee))) {
850             revert("BZxOracle::didPayInterest: _transferToken failed");
851         }
852 
853         if (interestTokenAddress == wethContract) {
854             // interest paid in WETH is withdrawn to Ether
855             WETH_Interface(wethContract).withdraw(interestFee);
856         } else if (convert && interestTokenAddress != bZRxTokenContract) {
857             // interest paid in BZRX is retained as is, other tokens are sold for Ether
858             _doTradeForEth(
859                 interestTokenAddress,
860                 interestFee,
861                 this // BZxOracle receives the Ether proceeds
862             );
863         }
864 
865         return true;
866     }
867 
868     function didDepositCollateral(
869         bytes32 /* loanOrderHash */,
870         address /* borrower */,
871         uint /* gasUsed */)
872         public
873         onlyBZx
874         updatesEMA(tx.gasprice)
875         returns (bool)
876     {
877         return true;
878     }
879 
880     function didWithdrawCollateral(
881         bytes32 /* loanOrderHash */,
882         address /* borrower */,
883         uint /* gasUsed */)
884         public
885         onlyBZx
886         updatesEMA(tx.gasprice)
887         returns (bool)
888     {
889         return true;
890     }
891 
892     function didChangeCollateral(
893         bytes32 /* loanOrderHash */,
894         address /* borrower */,
895         uint /* gasUsed */)
896         public
897         onlyBZx
898         updatesEMA(tx.gasprice)
899         returns (bool)
900     {
901         return true;
902     }
903 
904     function didWithdrawProfit(
905         bytes32 /* loanOrderHash */,
906         address /* borrower */,
907         uint /* profitOrLoss */,
908         uint /* gasUsed */)
909         public
910         onlyBZx
911         updatesEMA(tx.gasprice)
912         returns (bool)
913     {
914         return true;
915     }
916 
917     function didCloseLoan(
918         bytes32 loanOrderHash,
919         address loanCloser,
920         bool isLiquidation,
921         uint gasUsed)
922         public
923         onlyBZx
924         //refundsGas(taker, emaValue, gasUsed, 0) // refunds based on collected gas price EMA
925         updatesEMA(tx.gasprice)
926         returns (bool)
927     {
928         // sends gas refunds owed from earlier transactions
929         for (uint i=0; i < gasRefunds[loanOrderHash].length; i++) {
930             GasData storage gasData = gasRefunds[loanOrderHash][i];
931             if (!gasData.isPaid) {
932                 if (sendRefund(
933                     gasData.payer,
934                     gasData.gasUsed,
935                     emaValue,
936                     gasRewardPercent))               
937                         gasData.isPaid = true;
938             }
939         }
940 
941         // sends gas and bounty reward to bounty hunter
942         if (isLiquidation) {
943             calculateAndSendRefund(
944                 loanCloser,
945                 gasUsed,
946                 emaValue,
947                 bountyRewardPercent);
948         }
949         
950         return true;
951     }
952 
953     function doManualTrade(
954         address sourceTokenAddress,
955         address destTokenAddress,
956         uint sourceTokenAmount)
957         public
958         onlyBZx
959         returns (uint destTokenAmount)
960     {
961         if (isManualTradingAllowed) {
962             destTokenAmount = _doTrade(
963                 sourceTokenAddress,
964                 destTokenAddress,
965                 sourceTokenAmount,
966                 MAX_FOR_KYBER); // no limit on the dest amount
967         }
968         else {
969             revert("Manual trading is disabled.");
970         }
971     }
972 
973     function doTrade(
974         address sourceTokenAddress,
975         address destTokenAddress,
976         uint sourceTokenAmount)
977         public
978         onlyBZx
979         returns (uint destTokenAmount)
980     {
981         destTokenAmount = _doTrade(
982             sourceTokenAddress,
983             destTokenAddress,
984             sourceTokenAmount,
985             MAX_FOR_KYBER); // no limit on the dest amount
986     }
987 
988     function verifyAndLiquidate(
989         address loanTokenAddress,
990         address positionTokenAddress,
991         address collateralTokenAddress,
992         uint loanTokenAmount,
993         uint positionTokenAmount,
994         uint collateralTokenAmount,
995         uint maintenanceMarginAmount)
996         public
997         onlyBZx
998         returns (uint destTokenAmount)
999     {
1000         if (!shouldLiquidate(
1001             0x0,
1002             0x0,
1003             loanTokenAddress,
1004             positionTokenAddress,
1005             collateralTokenAddress,
1006             loanTokenAmount,
1007             positionTokenAmount,
1008             collateralTokenAmount,
1009             maintenanceMarginAmount)) {
1010             return 0;
1011         }
1012         
1013         destTokenAmount = _doTrade(
1014             positionTokenAddress,
1015             loanTokenAddress,
1016             positionTokenAmount,
1017             MAX_FOR_KYBER); // no limit on the dest amount
1018     }
1019 
1020     function doTradeofCollateral(
1021         address collateralTokenAddress,
1022         address loanTokenAddress,
1023         uint collateralTokenAmountUsable,
1024         uint loanTokenAmountNeeded,
1025         uint initialMarginAmount,
1026         uint maintenanceMarginAmount)
1027         public
1028         onlyBZx
1029         returns (uint loanTokenAmountCovered, uint collateralTokenAmountUsed)
1030     {
1031         uint collateralTokenBalance = EIP20(collateralTokenAddress).balanceOf.gas(4999)(this); // Changes to state require at least 5000 gas
1032         if (collateralTokenBalance < collateralTokenAmountUsable) { // sanity check
1033             revert("BZxOracle::doTradeofCollateral: collateralTokenBalance < collateralTokenAmountUsable");
1034         }
1035 
1036         loanTokenAmountCovered = _doTrade(
1037             collateralTokenAddress,
1038             loanTokenAddress,
1039             collateralTokenAmountUsable,
1040             loanTokenAmountNeeded);
1041 
1042         collateralTokenAmountUsed = collateralTokenBalance.sub(EIP20(collateralTokenAddress).balanceOf.gas(4999)(this)); // Changes to state require at least 5000 gas
1043         
1044         if (collateralTokenAmountUsed < collateralTokenAmountUsable) {
1045             // send unused collateral token back to the vault
1046             if (!_transferToken(
1047                 collateralTokenAddress,
1048                 vaultContract,
1049                 collateralTokenAmountUsable.sub(collateralTokenAmountUsed))) {
1050                 revert("BZxOracle::doTradeofCollateral: _transferToken failed");
1051             }
1052         }
1053 
1054         if (loanTokenAmountCovered < loanTokenAmountNeeded) {
1055             // cover losses with insurance if applicable
1056             if ((minInitialMarginAmount == 0 || initialMarginAmount >= minInitialMarginAmount) &&
1057                 (minMaintenanceMarginAmount == 0 || maintenanceMarginAmount >= minMaintenanceMarginAmount)) {
1058                 
1059                 loanTokenAmountCovered = loanTokenAmountCovered.add(
1060                     _doTradeWithEth(
1061                         loanTokenAddress,
1062                         loanTokenAmountNeeded.sub(loanTokenAmountCovered),
1063                         vaultContract
1064                 ));
1065             }
1066         }
1067     }
1068 
1069     /*
1070     * Public View functions
1071     */
1072 
1073     function shouldLiquidate(
1074         bytes32 /* loanOrderHash */,
1075         address /* trader */,
1076         address loanTokenAddress,
1077         address positionTokenAddress,
1078         address collateralTokenAddress,
1079         uint loanTokenAmount,
1080         uint positionTokenAmount,
1081         uint collateralTokenAmount,
1082         uint maintenanceMarginAmount)
1083         public
1084         view
1085         returns (bool)
1086     {
1087         return (
1088             getCurrentMarginAmount(
1089                 loanTokenAddress,
1090                 positionTokenAddress,
1091                 collateralTokenAddress,
1092                 loanTokenAmount,
1093                 positionTokenAmount,
1094                 collateralTokenAmount).div(maintenanceMarginAmount).div(10**16) <= (liquidationThresholdPercent)
1095             );
1096     } 
1097 
1098     function isTradeSupported(
1099         address sourceTokenAddress,
1100         address destTokenAddress,
1101         uint sourceTokenAmount)
1102         public
1103         view 
1104         returns (bool)
1105     {
1106         (uint rate, uint slippage) = _getExpectedRate(
1107             sourceTokenAddress,
1108             destTokenAddress,
1109             sourceTokenAmount);
1110         
1111         if (rate > 0 && (sourceTokenAmount == 0 || slippage > 0))
1112             return true;
1113         else
1114             return false;
1115     }
1116 
1117     function getTradeRate(
1118         address sourceTokenAddress,
1119         address destTokenAddress)
1120         public
1121         view 
1122         returns (uint rate)
1123     {
1124         (rate,) = _getExpectedRate(
1125             sourceTokenAddress,
1126             destTokenAddress,
1127             0);
1128     }
1129 
1130     // returns bool isProfit, uint profitOrLoss
1131     // the position's profit/loss denominated in positionToken
1132     function getProfitOrLoss(
1133         address positionTokenAddress,
1134         address loanTokenAddress,
1135         uint positionTokenAmount,
1136         uint loanTokenAmount)
1137         public
1138         view
1139         returns (bool isProfit, uint profitOrLoss)
1140     {
1141         uint loanToPositionAmount;
1142         if (positionTokenAddress == loanTokenAddress) {
1143             loanToPositionAmount = loanTokenAmount;
1144         } else {
1145             (uint positionToLoanRate,) = _getExpectedRate(
1146                 positionTokenAddress,
1147                 loanTokenAddress,
1148                 0);
1149             if (positionToLoanRate == 0) {
1150                 return;
1151             }
1152             loanToPositionAmount = loanTokenAmount.mul(10**18).div(positionToLoanRate);
1153         }
1154 
1155         if (positionTokenAmount > loanToPositionAmount) {
1156             isProfit = true;
1157             profitOrLoss = positionTokenAmount - loanToPositionAmount;
1158         } else {
1159             isProfit = false;
1160             profitOrLoss = loanToPositionAmount - positionTokenAmount;
1161         }
1162     }
1163 
1164     /// @return The current margin amount (a percentage -> i.e. 54350000000000000000 == 54.35%)
1165     function getCurrentMarginAmount(
1166         address loanTokenAddress,
1167         address positionTokenAddress,
1168         address collateralTokenAddress,
1169         uint loanTokenAmount,
1170         uint positionTokenAmount,
1171         uint collateralTokenAmount)
1172         public
1173         view
1174         returns (uint)
1175     {
1176         uint collateralToLoanAmount;
1177         if (collateralTokenAddress == loanTokenAddress) {
1178             collateralToLoanAmount = collateralTokenAmount;
1179         } else {
1180             (uint collateralToLoanRate,) = _getExpectedRate(
1181                 collateralTokenAddress,
1182                 loanTokenAddress,
1183                 0);
1184             if (collateralToLoanRate == 0) {
1185                 return 0;
1186             }
1187             collateralToLoanAmount = collateralTokenAmount.mul(collateralToLoanRate).div(10**18);
1188         }
1189 
1190         uint positionToLoanAmount;
1191         if (positionTokenAddress == loanTokenAddress) {
1192             positionToLoanAmount = positionTokenAmount;
1193         } else {
1194             (uint positionToLoanRate,) = _getExpectedRate(
1195                 positionTokenAddress,
1196                 loanTokenAddress,
1197                 0);
1198             if (positionToLoanRate == 0) {
1199                 return 0;
1200             }
1201             positionToLoanAmount = positionTokenAmount.mul(positionToLoanRate).div(10**18);
1202         }
1203 
1204         return collateralToLoanAmount.add(positionToLoanAmount).sub(loanTokenAmount).mul(10**20).div(loanTokenAmount);
1205     }
1206 
1207     /*
1208     * Owner functions
1209     */
1210 
1211     function setInterestFeePercent(
1212         uint newRate) 
1213         public
1214         onlyOwner
1215     {
1216         require(newRate != interestFeePercent && newRate >= 0 && newRate <= 100);
1217         interestFeePercent = newRate;
1218     }
1219 
1220     function setLiquidationThresholdPercent(
1221         uint newValue) 
1222         public
1223         onlyOwner
1224     {
1225         require(newValue != liquidationThresholdPercent && liquidationThresholdPercent >= 100);
1226         liquidationThresholdPercent = newValue;
1227     }
1228 
1229     function setGasRewardPercent(
1230         uint newValue) 
1231         public
1232         onlyOwner
1233     {
1234         require(newValue != gasRewardPercent);
1235         gasRewardPercent = newValue;
1236     }
1237 
1238     function setBountyRewardPercent(
1239         uint newValue) 
1240         public
1241         onlyOwner
1242     {
1243         require(newValue != bountyRewardPercent);
1244         bountyRewardPercent = newValue;
1245     }
1246 
1247     function setMarginThresholds(
1248         uint newInitialMargin,
1249         uint newMaintenanceMargin) 
1250         public
1251         onlyOwner
1252     {
1253         require(newInitialMargin >= newMaintenanceMargin);
1254         minInitialMarginAmount = newInitialMargin;
1255         minMaintenanceMarginAmount = newMaintenanceMargin;
1256     }
1257 
1258     function setManualTradingAllowed (
1259         bool _isManualTradingAllowed)
1260         public
1261         onlyOwner
1262     {
1263         if (isManualTradingAllowed != _isManualTradingAllowed)
1264             isManualTradingAllowed = _isManualTradingAllowed;
1265     }
1266 
1267     function setVaultContractAddress(
1268         address newAddress) 
1269         public
1270         onlyOwner
1271     {
1272         require(newAddress != vaultContract && newAddress != address(0));
1273         vaultContract = newAddress;
1274     }
1275 
1276     function setKyberContractAddress(
1277         address newAddress) 
1278         public
1279         onlyOwner
1280     {
1281         require(newAddress != kyberContract && newAddress != address(0));
1282         kyberContract = newAddress;
1283     }
1284 
1285     function setWethContractAddress(
1286         address newAddress) 
1287         public
1288         onlyOwner
1289     {
1290         require(newAddress != wethContract && newAddress != address(0));
1291         wethContract = newAddress;
1292     }
1293 
1294     function setBZRxTokenContractAddress(
1295         address newAddress) 
1296         public
1297         onlyOwner
1298     {
1299         require(newAddress != bZRxTokenContract && newAddress != address(0));
1300         bZRxTokenContract = newAddress;
1301     }
1302 
1303     function setEMAPeriods (
1304         uint _newEMAPeriods)
1305         public
1306         onlyOwner {
1307         require(_newEMAPeriods > 1 && _newEMAPeriods != emaPeriods);
1308         emaPeriods = _newEMAPeriods;
1309     }
1310 
1311     function transferEther(
1312         address to,
1313         uint value)
1314         public
1315         onlyOwner
1316         returns (bool)
1317     {
1318         uint amount = value;
1319         if (amount > address(this).balance) {
1320             amount = address(this).balance;
1321         }
1322 
1323         return (to.send(amount));
1324     }
1325 
1326     function transferToken(
1327         address tokenAddress,
1328         address to,
1329         uint value)
1330         public
1331         onlyOwner
1332         returns (bool)
1333     {
1334         return (_transferToken(
1335             tokenAddress,
1336             to,
1337             value
1338         ));
1339     }
1340 
1341     /*
1342     * Internal functions
1343     */
1344 
1345     // ref: https://github.com/KyberNetwork/smart-contracts/blob/master/integration.md#rate-query
1346     function _getExpectedRate(
1347         address sourceTokenAddress,
1348         address destTokenAddress,
1349         uint sourceTokenAmount)
1350         internal
1351         view 
1352         returns (uint expectedRate, uint slippageRate)
1353     {
1354         if (sourceTokenAddress == destTokenAddress) {
1355             expectedRate = 10**18;
1356             slippageRate = 0;
1357         } else {
1358             if (sourceTokenAddress == wethContract) {
1359                 (expectedRate, slippageRate) = KyberNetwork_Interface(kyberContract).getExpectedRate(
1360                     KYBER_ETH_TOKEN_ADDRESS,
1361                     destTokenAddress, 
1362                     sourceTokenAmount
1363                 );
1364             } else if (destTokenAddress == wethContract) {
1365                 (expectedRate, slippageRate) = KyberNetwork_Interface(kyberContract).getExpectedRate(
1366                     sourceTokenAddress,
1367                     KYBER_ETH_TOKEN_ADDRESS,
1368                     sourceTokenAmount
1369                 );
1370             } else {
1371                 (uint sourceToEther, uint sourceToEtherSlippage) = KyberNetwork_Interface(kyberContract).getExpectedRate(
1372                     sourceTokenAddress,
1373                     KYBER_ETH_TOKEN_ADDRESS,
1374                     sourceTokenAmount
1375                 );
1376                 if (sourceTokenAmount > 0) {
1377                     sourceTokenAmount = sourceTokenAmount.mul(sourceToEther).div(10**18);
1378                 }
1379 
1380                 (uint etherToDest, uint etherToDestSlippage) = KyberNetwork_Interface(kyberContract).getExpectedRate(
1381                     KYBER_ETH_TOKEN_ADDRESS,
1382                     destTokenAddress,
1383                     sourceTokenAmount
1384                 );
1385 
1386                 expectedRate = sourceToEther.mul(etherToDest).div(10**18);
1387                 slippageRate = sourceToEtherSlippage.mul(etherToDestSlippage).div(10**18);
1388             }
1389         }
1390     }
1391 
1392     function _doTrade(
1393         address sourceTokenAddress,
1394         address destTokenAddress,
1395         uint sourceTokenAmount,
1396         uint maxDestTokenAmount)
1397         internal
1398         returns (uint destTokenAmount)
1399     {
1400         if (sourceTokenAddress == destTokenAddress) {
1401             if (maxDestTokenAmount < MAX_FOR_KYBER) {
1402                 destTokenAmount = maxDestTokenAmount;
1403             } else {
1404                 destTokenAmount = sourceTokenAmount;
1405             }
1406         } else {
1407             if (sourceTokenAddress == wethContract) {
1408                 WETH_Interface(wethContract).withdraw(sourceTokenAmount);
1409 
1410                 destTokenAmount = KyberNetwork_Interface(kyberContract).trade
1411                     .value(sourceTokenAmount)( // send Ether along 
1412                     KYBER_ETH_TOKEN_ADDRESS,
1413                     sourceTokenAmount,
1414                     destTokenAddress,
1415                     vaultContract, // bZxVault recieves the destToken
1416                     maxDestTokenAmount,
1417                     0, // no min coversation rate
1418                     address(0)
1419                 );
1420             } else if (destTokenAddress == wethContract) {
1421                 // re-up the Kyber spend approval if needed
1422                 if (EIP20(sourceTokenAddress).allowance.gas(4999)(this, kyberContract) < 
1423                     MAX_FOR_KYBER) {
1424                     
1425                     eip20Approve(
1426                         sourceTokenAddress,
1427                         kyberContract,
1428                         MAX_FOR_KYBER);
1429                 }
1430 
1431                 destTokenAmount = KyberNetwork_Interface(kyberContract).trade(
1432                     sourceTokenAddress,
1433                     sourceTokenAmount,
1434                     KYBER_ETH_TOKEN_ADDRESS,
1435                     this, // BZxOracle receives the Ether proceeds
1436                     maxDestTokenAmount,
1437                     0, // no min coversation rate
1438                     address(0)
1439                 );
1440 
1441                 WETH_Interface(wethContract).deposit.value(destTokenAmount)();
1442 
1443                 if (!_transferToken(
1444                     destTokenAddress,
1445                     vaultContract,
1446                     destTokenAmount)) {
1447                     revert("BZxOracle::_doTrade: _transferToken failed");
1448                 }
1449             } else {
1450                 // re-up the Kyber spend approval if needed
1451                 if (EIP20(sourceTokenAddress).allowance.gas(4999)(this, kyberContract) < 
1452                     MAX_FOR_KYBER) {
1453                     
1454                     eip20Approve(
1455                         sourceTokenAddress,
1456                         kyberContract,
1457                         MAX_FOR_KYBER);
1458                 }
1459                 
1460                 uint maxDestEtherAmount = maxDestTokenAmount;
1461                 if (maxDestTokenAmount < MAX_FOR_KYBER) {
1462                     uint etherToDest;
1463                     (etherToDest,) = KyberNetwork_Interface(kyberContract).getExpectedRate(
1464                         KYBER_ETH_TOKEN_ADDRESS,
1465                         destTokenAddress, 
1466                         0
1467                     );
1468                     maxDestEtherAmount = maxDestTokenAmount.mul(10**18).div(etherToDest);
1469                 }
1470 
1471                 uint destEtherAmount = KyberNetwork_Interface(kyberContract).trade(
1472                     sourceTokenAddress,
1473                     sourceTokenAmount,
1474                     KYBER_ETH_TOKEN_ADDRESS,
1475                     this, // BZxOracle receives the Ether proceeds
1476                     maxDestEtherAmount,
1477                     0, // no min coversation rate
1478                     address(0)
1479                 );
1480 
1481                 destTokenAmount = KyberNetwork_Interface(kyberContract).trade
1482                     .value(destEtherAmount)( // send Ether along 
1483                     KYBER_ETH_TOKEN_ADDRESS,
1484                     destEtherAmount,
1485                     destTokenAddress,
1486                     vaultContract, // bZxVault recieves the destToken
1487                     maxDestTokenAmount,
1488                     0, // no min coversation rate
1489                     address(0)
1490                 );
1491             }
1492         }
1493     }
1494 
1495     function _doTradeForEth(
1496         address sourceTokenAddress,
1497         uint sourceTokenAmount,
1498         address receiver)
1499         internal
1500         returns (uint)
1501     {
1502         // re-up the Kyber spend approval if needed
1503         if (EIP20(sourceTokenAddress).allowance.gas(4999)(this, kyberContract) < 
1504             MAX_FOR_KYBER) {
1505 
1506             eip20Approve(
1507                 sourceTokenAddress,
1508                 kyberContract,
1509                 MAX_FOR_KYBER);
1510         }
1511         
1512         // bytes4(keccak256("trade(address,uint256,address,address,uint256,uint256,address)")) = 0xcb3c28c7
1513         bool result = kyberContract.call
1514             .gas(gasleft())(
1515             0xcb3c28c7,
1516             sourceTokenAddress,
1517             sourceTokenAmount,
1518             KYBER_ETH_TOKEN_ADDRESS,
1519             receiver,
1520             MAX_FOR_KYBER, // no limit on the dest amount
1521             0, // no min coversation rate
1522             address(0)
1523         );
1524 
1525         assembly {
1526             let size := returndatasize
1527             let ptr := mload(0x40)
1528             returndatacopy(ptr, 0, size)
1529             switch result
1530             case 0 { return(0, 0x20) }
1531             default { return(ptr, size) }
1532         }
1533     }
1534 
1535     function _doTradeWithEth(
1536         address destTokenAddress,
1537         uint destTokenAmountNeeded,
1538         address receiver)
1539         internal
1540         returns (uint)
1541     {
1542         uint etherToDest;
1543         (etherToDest,) = KyberNetwork_Interface(kyberContract).getExpectedRate(
1544             KYBER_ETH_TOKEN_ADDRESS,
1545             destTokenAddress, 
1546             0
1547         );
1548 
1549         // calculate amount of ETH to use with a 5% buffer (unused ETH is returned by Kyber)
1550         uint ethToSend = destTokenAmountNeeded.mul(10**18).div(etherToDest).mul(105).div(100);
1551         if (ethToSend > address(this).balance) {
1552             ethToSend = address(this).balance;
1553         }
1554 
1555         // bytes4(keccak256("trade(address,uint256,address,address,uint256,uint256,address)")) = 0xcb3c28c7
1556         bool result = kyberContract.call
1557             .gas(gasleft())
1558             .value(ethToSend)( // send Ether along 
1559             0xcb3c28c7,
1560             KYBER_ETH_TOKEN_ADDRESS,
1561             ethToSend,
1562             destTokenAddress,
1563             receiver,
1564             destTokenAmountNeeded,
1565             0, // no min coversation rate
1566             address(0)
1567         );
1568 
1569         assembly {
1570             let size := returndatasize
1571             let ptr := mload(0x40)
1572             returndatacopy(ptr, 0, size)
1573             switch result
1574             case 0 { return(0, 0x20) }
1575             default { return(ptr, size) }
1576         }
1577     }
1578 
1579     function _transferToken(
1580         address tokenAddress,
1581         address to,
1582         uint value)
1583         internal
1584         returns (bool)
1585     {
1586         eip20Transfer(
1587             tokenAddress,
1588             to,
1589             value);
1590 
1591         return true;
1592     }
1593 }