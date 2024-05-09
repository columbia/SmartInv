1 pragma solidity ^0.4.24;
2 
3 // File: zos-lib/contracts/Initializable.sol
4 
5 /**
6  * @title Initializable
7  *
8  * @dev Helper contract to support initializer functions. To use it, replace
9  * the constructor with a function that has the `initializer` modifier.
10  * WARNING: Unlike constructors, initializer functions must be manually
11  * invoked. This applies both to deploying an Initializable contract, as well
12  * as extending an Initializable contract via inheritance.
13  * WARNING: When used with inheritance, manual care must be taken to not invoke
14  * a parent initializer twice, or ensure that all initializers are idempotent,
15  * because this is not dealt with automatically as with constructors.
16  */
17 contract Initializable {
18 
19   /**
20    * @dev Indicates that the contract has been initialized.
21    */
22   bool private initialized;
23 
24   /**
25    * @dev Indicates that the contract is in the process of being initialized.
26    */
27   bool private initializing;
28 
29   /**
30    * @dev Modifier to use in the initializer function of a contract.
31    */
32   modifier initializer() {
33     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
34 
35     bool wasInitializing = initializing;
36     initializing = true;
37     initialized = true;
38 
39     _;
40 
41     initializing = wasInitializing;
42   }
43 
44   /// @dev Returns true if and only if the function is running in the constructor
45   function isConstructor() private view returns (bool) {
46     // extcodesize checks the size of the code stored in an address, and
47     // address returns the current address. Since the code is still not
48     // deployed when running a constructor, any checks on its code size will
49     // yield zero, making it an effective way to detect if a contract is
50     // under construction or not.
51     uint256 cs;
52     assembly { cs := extcodesize(address) }
53     return cs == 0;
54   }
55 
56   // Reserved storage space to allow for layout changes in the future.
57   uint256[50] private ______gap;
58 }
59 
60 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable is Initializable {
68   address private _owner;
69 
70 
71   event OwnershipRenounced(address indexed previousOwner);
72   event OwnershipTransferred(
73     address indexed previousOwner,
74     address indexed newOwner
75   );
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function initialize(address sender) public initializer {
83     _owner = sender;
84   }
85 
86   /**
87    * @return the address of the owner.
88    */
89   function owner() public view returns(address) {
90     return _owner;
91   }
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(isOwner());
98     _;
99   }
100 
101   /**
102    * @return true if `msg.sender` is the owner of the contract.
103    */
104   function isOwner() public view returns(bool) {
105     return msg.sender == _owner;
106   }
107 
108   /**
109    * @dev Allows the current owner to relinquish control of the contract.
110    * @notice Renouncing to ownership will leave the contract without an owner.
111    * It will not be possible to call the functions with the `onlyOwner`
112    * modifier anymore.
113    */
114   function renounceOwnership() public onlyOwner {
115     emit OwnershipRenounced(_owner);
116     _owner = address(0);
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) public onlyOwner {
124     _transferOwnership(newOwner);
125   }
126 
127   /**
128    * @dev Transfers control of the contract to a newOwner.
129    * @param newOwner The address to transfer ownership to.
130    */
131   function _transferOwnership(address newOwner) internal {
132     require(newOwner != address(0));
133     emit OwnershipTransferred(_owner, newOwner);
134     _owner = newOwner;
135   }
136 
137   uint256[50] private ______gap;
138 }
139 
140 // File: openzeppelin-eth/contracts/math/SafeMath.sol
141 
142 /**
143  * @title SafeMath
144  * @dev Math operations with safety checks that revert on error
145  */
146 library SafeMath {
147 
148   /**
149   * @dev Multiplies two numbers, reverts on overflow.
150   */
151   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153     // benefit is lost if 'b' is also tested.
154     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
155     if (a == 0) {
156       return 0;
157     }
158 
159     uint256 c = a * b;
160     require(c / a == b);
161 
162     return c;
163   }
164 
165   /**
166   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
167   */
168   function div(uint256 a, uint256 b) internal pure returns (uint256) {
169     require(b > 0); // Solidity only automatically asserts when dividing by 0
170     uint256 c = a / b;
171     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172 
173     return c;
174   }
175 
176   /**
177   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
178   */
179   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180     require(b <= a);
181     uint256 c = a - b;
182 
183     return c;
184   }
185 
186   /**
187   * @dev Adds two numbers, reverts on overflow.
188   */
189   function add(uint256 a, uint256 b) internal pure returns (uint256) {
190     uint256 c = a + b;
191     require(c >= a);
192 
193     return c;
194   }
195 
196   /**
197   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
198   * reverts when dividing by zero.
199   */
200   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
201     require(b != 0);
202     return a % b;
203   }
204 }
205 
206 // File: openzeppelin-eth/contracts/utils/Address.sol
207 
208 /**
209  * Utility library of inline functions on addresses
210  */
211 library Address {
212 
213   /**
214    * Returns whether the target address is a contract
215    * @dev This function will return false if invoked during the constructor of a contract,
216    * as the code is not actually created until after the constructor finishes.
217    * @param account address of the account to check
218    * @return whether the target address is a contract
219    */
220   function isContract(address account) internal view returns (bool) {
221     uint256 size;
222     // XXX Currently there is no better way to check if there is a contract in an address
223     // than to check the size of the code at that address.
224     // See https://ethereum.stackexchange.com/a/14016/36603
225     // for more details about how this works.
226     // TODO Check this again before the Serenity release, because all addresses will be
227     // contracts then.
228     // solium-disable-next-line security/no-inline-assembly
229     assembly { size := extcodesize(account) }
230     return size > 0;
231   }
232 }
233 
234 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
235 
236 /**
237  * @title ERC20 interface
238  * @dev see https://github.com/ethereum/EIPs/issues/20
239  */
240 interface IERC20 {
241   function totalSupply() external view returns (uint256);
242 
243   function balanceOf(address who) external view returns (uint256);
244 
245   function allowance(address owner, address spender)
246     external view returns (uint256);
247 
248   function transfer(address to, uint256 value) external returns (bool);
249 
250   function approve(address spender, uint256 value)
251     external returns (bool);
252 
253   function transferFrom(address from, address to, uint256 value)
254     external returns (bool);
255 
256   event Transfer(
257     address indexed from,
258     address indexed to,
259     uint256 value
260   );
261 
262   event Approval(
263     address indexed owner,
264     address indexed spender,
265     uint256 value
266   );
267 }
268 
269 // File: contracts/libs/SafeERC20.sol
270 
271 /**
272 * @dev Library to perform safe calls to standard method for ERC20 tokens.
273 * Transfers : transfer methods could have a return value (bool), revert for insufficient funds or
274 * unathorized value.
275 *
276 * Approve: approve method could has a return value (bool) or does not accept 0 as a valid value (BNB token).
277 * The common strategy used to clean approvals.
278 */
279 library SafeERC20 {
280     /**
281     * @dev Transfer token for a specified address
282     * @param _token erc20 The address of the ERC20 contract
283     * @param _to address The address which you want to transfer to
284     * @param _value uint256 the _value of tokens to be transferred
285     */
286     function safeTransfer(IERC20 _token, address _to, uint256 _value) internal returns (bool) {
287         uint256 prevBalance = _token.balanceOf(address(this));
288 
289         require(prevBalance >= _value, "Insufficient funds");
290 
291         bool success = address(_token).call(
292             abi.encodeWithSignature("transfer(address,uint256)", _to, _value)
293         );
294 
295         if (!success) {
296             return false;
297         }
298 
299         require(prevBalance - _value == _token.balanceOf(address(this)), "Transfer failed");
300 
301         return true;
302     }
303 
304     /**
305     * @dev Transfer tokens from one address to another
306     * @param _token erc20 The address of the ERC20 contract
307     * @param _from address The address which you want to send tokens from
308     * @param _to address The address which you want to transfer to
309     * @param _value uint256 the _value of tokens to be transferred
310     */
311     function safeTransferFrom(
312         IERC20 _token,
313         address _from,
314         address _to, 
315         uint256 _value
316     ) internal returns (bool) 
317     {
318         uint256 prevBalance = _token.balanceOf(_from);
319 
320         require(prevBalance >= _value, "Insufficient funds");
321         require(_token.allowance(_from, address(this)) >= _value, "Insufficient allowance");
322 
323         bool success = address(_token).call(
324             abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value)
325         );
326 
327         if (!success) {
328             return false;
329         }
330 
331         require(prevBalance - _value == _token.balanceOf(_from), "Transfer failed");
332 
333         return true;
334     }
335 
336    /**
337    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
338    *
339    * Beware that changing an allowance with this method brings the risk that someone may use both the old
340    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
341    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
342    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
343    * 
344    * @param _token erc20 The address of the ERC20 contract
345    * @param _spender The address which will spend the funds.
346    * @param _value The amount of tokens to be spent.
347    */
348     function safeApprove(IERC20 _token, address _spender, uint256 _value) internal returns (bool) {
349         bool success = address(_token).call(
350             abi.encodeWithSignature("approve(address,uint256)",_spender, _value)
351         ); 
352 
353         if (!success) {
354             return false;
355         }
356 
357         require(_token.allowance(address(this), _spender) == _value, "Approve failed");
358 
359         return true;
360     }
361 
362    /** 
363    * @dev Clear approval
364    * Note that if 0 is not a valid value it will be set to 1.
365    * @param _token erc20 The address of the ERC20 contract
366    * @param _spender The address which will spend the funds.
367    */
368     function clearApprove(IERC20 _token, address _spender) internal returns (bool) {
369         bool success = safeApprove(_token, _spender, 0);
370 
371         if (!success) {
372             return safeApprove(_token, _spender, 1);
373         }
374 
375         return true;
376     }
377 }
378 
379 // File: contracts/dex/ITokenConverter.sol
380 
381 contract ITokenConverter {    
382     using SafeMath for uint256;
383 
384     /**
385     * @dev Makes a simple ERC20 -> ERC20 token trade
386     * @param _srcToken - IERC20 token
387     * @param _destToken - IERC20 token 
388     * @param _srcAmount - uint256 amount to be converted
389     * @param _destAmount - uint256 amount to get after conversion
390     * @return uint256 for the change. 0 if there is no change
391     */
392     function convert(
393         IERC20 _srcToken,
394         IERC20 _destToken,
395         uint256 _srcAmount,
396         uint256 _destAmount
397         ) external returns (uint256);
398 
399     /**
400     * @dev Get exchange rate and slippage rate. 
401     * Note that these returned values are in 18 decimals regardless of the destination token's decimals.
402     * @param _srcToken - IERC20 token
403     * @param _destToken - IERC20 token 
404     * @param _srcAmount - uint256 amount to be converted
405     * @return uint256 of the expected rate
406     * @return uint256 of the slippage rate
407     */
408     function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint256 _srcAmount) 
409         public view returns(uint256 expectedRate, uint256 slippageRate);
410 }
411 
412 // File: contracts/auction/LANDAuctionStorage.sol
413 
414 /**
415 * @title ERC20 Interface with burn
416 * @dev IERC20 imported in ItokenConverter.sol
417 */
418 contract ERC20 is IERC20 {
419     function burn(uint256 _value) public;
420 }
421 
422 
423 /**
424 * @title Interface for contracts conforming to ERC-721
425 */
426 contract LANDRegistry {
427     function assignMultipleParcels(int[] x, int[] y, address beneficiary) external;
428 }
429 
430 
431 contract LANDAuctionStorage {
432     uint256 constant public PERCENTAGE_OF_TOKEN_BALANCE = 5;
433     uint256 constant public MAX_DECIMALS = 18;
434 
435     enum Status { created, finished }
436 
437     struct Func {
438         uint256 slope;
439         uint256 base;
440         uint256 limit;
441     }
442 
443     struct Token {
444         uint256 decimals;
445         bool shouldBurnTokens;
446         bool shouldForwardTokens;
447         address forwardTarget;
448         bool isAllowed;
449     }
450 
451     uint256 public conversionFee = 105;
452     uint256 public totalBids = 0;
453     Status public status;
454     uint256 public gasPriceLimit;
455     uint256 public landsLimitPerBid;
456     ERC20 public manaToken;
457     LANDRegistry public landRegistry;
458     ITokenConverter public dex;
459     mapping (address => Token) public tokensAllowed;
460     uint256 public totalManaBurned = 0;
461     uint256 public totalLandsBidded = 0;
462     uint256 public startTime;
463     uint256 public endTime;
464 
465     Func[] internal curves;
466     uint256 internal initialPrice;
467     uint256 internal endPrice;
468     uint256 internal duration;
469 
470     event AuctionCreated(
471       address indexed _caller,
472       uint256 _startTime,
473       uint256 _duration,
474       uint256 _initialPrice,
475       uint256 _endPrice
476     );
477 
478     event BidConversion(
479       uint256 _bidId,
480       address indexed _token,
481       uint256 _requiredManaAmountToBurn,
482       uint256 _amountOfTokenConverted,
483       uint256 _requiredTokenBalance
484     );
485 
486     event BidSuccessful(
487       uint256 _bidId,
488       address indexed _beneficiary,
489       address indexed _token,
490       uint256 _pricePerLandInMana,
491       uint256 _manaAmountToBurn,
492       int[] _xs,
493       int[] _ys
494     );
495 
496     event AuctionFinished(
497       address indexed _caller,
498       uint256 _time,
499       uint256 _pricePerLandInMana
500     );
501 
502     event TokenBurned(
503       uint256 _bidId,
504       address indexed _token,
505       uint256 _total
506     );
507 
508     event TokenTransferred(
509       uint256 _bidId,
510       address indexed _token,
511       address indexed _to,
512       uint256 _total
513     );
514 
515     event LandsLimitPerBidChanged(
516       address indexed _caller,
517       uint256 _oldLandsLimitPerBid, 
518       uint256 _landsLimitPerBid
519     );
520 
521     event GasPriceLimitChanged(
522       address indexed _caller,
523       uint256 _oldGasPriceLimit,
524       uint256 _gasPriceLimit
525     );
526 
527     event DexChanged(
528       address indexed _caller,
529       address indexed _oldDex,
530       address indexed _dex
531     );
532 
533     event TokenAllowed(
534       address indexed _caller,
535       address indexed _address,
536       uint256 _decimals,
537       bool _shouldBurnTokens,
538       bool _shouldForwardTokens,
539       address indexed _forwardTarget
540     );
541 
542     event TokenDisabled(
543       address indexed _caller,
544       address indexed _address
545     );
546 
547     event ConversionFeeChanged(
548       address indexed _caller,
549       uint256 _oldConversionFee,
550       uint256 _conversionFee
551     );
552 }
553 
554 // File: contracts/auction/LANDAuction.sol
555 
556 contract LANDAuction is Ownable, LANDAuctionStorage {
557     using SafeMath for uint256;
558     using Address for address;
559     using SafeERC20 for ERC20;
560 
561     /**
562     * @dev Constructor of the contract.
563     * Note that the last value of _xPoints will be the total duration and
564     * the first value of _yPoints will be the initial price and the last value will be the endPrice
565     * @param _xPoints - uint256[] of seconds
566     * @param _yPoints - uint256[] of prices
567     * @param _startTime - uint256 timestamp in seconds when the auction will start
568     * @param _landsLimitPerBid - uint256 LAND limit for a single bid
569     * @param _gasPriceLimit - uint256 gas price limit for a single bid
570     * @param _manaToken - address of the MANA token
571     * @param _landRegistry - address of the LANDRegistry
572     * @param _dex - address of the Dex to convert ERC20 tokens allowed to MANA
573     */
574     constructor(
575         uint256[] _xPoints, 
576         uint256[] _yPoints, 
577         uint256 _startTime,
578         uint256 _landsLimitPerBid,
579         uint256 _gasPriceLimit,
580         ERC20 _manaToken,
581         LANDRegistry _landRegistry,
582         address _dex
583     ) public {
584         require(
585             PERCENTAGE_OF_TOKEN_BALANCE == 5, 
586             "Balance of tokens required should be equal to 5%"
587         );
588         // Initialize owneable
589         Ownable.initialize(msg.sender);
590 
591         // Schedule auction
592         require(_startTime > block.timestamp, "Started time should be after now");
593         startTime = _startTime;
594 
595         // Set LANDRegistry
596         require(
597             address(_landRegistry).isContract(),
598             "The LANDRegistry token address must be a deployed contract"
599         );
600         landRegistry = _landRegistry;
601 
602         setDex(_dex);
603 
604         // Set MANAToken
605         allowToken(
606             address(_manaToken), 
607             18,
608             true, 
609             false, 
610             address(0)
611         );
612         manaToken = _manaToken;
613 
614         // Set total duration of the auction
615         duration = _xPoints[_xPoints.length - 1];
616         require(duration > 1 days, "The duration should be greater than 1 day");
617 
618         // Set Curve
619         _setCurve(_xPoints, _yPoints);
620 
621         // Set limits
622         setLandsLimitPerBid(_landsLimitPerBid);
623         setGasPriceLimit(_gasPriceLimit);
624         
625         // Initialize status
626         status = Status.created;      
627 
628         emit AuctionCreated(
629             msg.sender,
630             startTime,
631             duration,
632             initialPrice, 
633             endPrice
634         );
635     }
636 
637     /**
638     * @dev Make a bid for LANDs
639     * @param _xs - uint256[] x values for the LANDs to bid
640     * @param _ys - uint256[] y values for the LANDs to bid
641     * @param _beneficiary - address beneficiary for the LANDs to bid
642     * @param _fromToken - token used to bid
643     */
644     function bid(
645         int[] _xs, 
646         int[] _ys, 
647         address _beneficiary, 
648         ERC20 _fromToken
649     )
650         external 
651     {
652         _validateBidParameters(
653             _xs, 
654             _ys, 
655             _beneficiary, 
656             _fromToken
657         );
658         
659         uint256 bidId = _getBidId();
660         uint256 bidPriceInMana = _xs.length.mul(getCurrentPrice());
661         uint256 manaAmountToBurn = bidPriceInMana;
662 
663         if (address(_fromToken) != address(manaToken)) {
664             require(
665                 address(dex).isContract(), 
666                 "Paying with other tokens has been disabled"
667             );
668             // Convert from the other token to MANA. The amount to be burned might be smaller
669             // because 5% will be burned or forwarded without converting it to MANA.
670             manaAmountToBurn = _convertSafe(bidId, _fromToken, bidPriceInMana);
671         } else {
672             // Transfer MANA to this contract
673             require(
674                 _fromToken.safeTransferFrom(msg.sender, address(this), bidPriceInMana),
675                 "Insuficient balance or unauthorized amount (transferFrom failed)"
676             );
677         }
678 
679         // Process funds (burn or forward them)
680         _processFunds(bidId, _fromToken);
681 
682         // Assign LANDs to the beneficiary user
683         landRegistry.assignMultipleParcels(_xs, _ys, _beneficiary);
684 
685         emit BidSuccessful(
686             bidId,
687             _beneficiary,
688             _fromToken,
689             getCurrentPrice(),
690             manaAmountToBurn,
691             _xs,
692             _ys
693         );  
694 
695         // Update stats
696         _updateStats(_xs.length, manaAmountToBurn);        
697     }
698 
699     /** 
700     * @dev Validate bid function params
701     * @param _xs - int[] x values for the LANDs to bid
702     * @param _ys - int[] y values for the LANDs to bid
703     * @param _beneficiary - address beneficiary for the LANDs to bid
704     * @param _fromToken - token used to bid
705     */
706     function _validateBidParameters(
707         int[] _xs, 
708         int[] _ys, 
709         address _beneficiary, 
710         ERC20 _fromToken
711     ) internal view 
712     {
713         require(startTime <= block.timestamp, "The auction has not started");
714         require(
715             status == Status.created && 
716             block.timestamp.sub(startTime) <= duration, 
717             "The auction has finished"
718         );
719         require(tx.gasprice <= gasPriceLimit, "Gas price limit exceeded");
720         require(_beneficiary != address(0), "The beneficiary could not be the 0 address");
721         require(_xs.length > 0, "You should bid for at least one LAND");
722         require(_xs.length <= landsLimitPerBid, "LAND limit exceeded");
723         require(_xs.length == _ys.length, "X values length should be equal to Y values length");
724         require(tokensAllowed[address(_fromToken)].isAllowed, "Token not allowed");
725         for (uint256 i = 0; i < _xs.length; i++) {
726             require(
727                 -150 <= _xs[i] && _xs[i] <= 150 && -150 <= _ys[i] && _ys[i] <= 150,
728                 "The coordinates should be inside bounds -150 & 150"
729             );
730         }
731     }
732 
733     /**
734     * @dev Current LAND price. 
735     * Note that if the auction has not started returns the initial price and when
736     * the auction is finished return the endPrice
737     * @return uint256 current LAND price
738     */
739     function getCurrentPrice() public view returns (uint256) { 
740         // If the auction has not started returns initialPrice
741         if (startTime == 0 || startTime >= block.timestamp) {
742             return initialPrice;
743         }
744 
745         // If the auction has finished returns endPrice
746         uint256 timePassed = block.timestamp - startTime;
747         if (timePassed >= duration) {
748             return endPrice;
749         }
750 
751         return _getPrice(timePassed);
752     }
753 
754     /**
755     * @dev Convert allowed token to MANA and transfer the change in the original token
756     * Note that we will use the slippageRate cause it has a 3% buffer and a deposit of 5% to cover
757     * the conversion fee.
758     * @param _bidId - uint256 of the bid Id
759     * @param _fromToken - ERC20 token to be converted
760     * @param _bidPriceInMana - uint256 of the total amount in MANA
761     * @return uint256 of the total amount of MANA to burn
762     */
763     function _convertSafe(
764         uint256 _bidId,
765         ERC20 _fromToken,
766         uint256 _bidPriceInMana
767     ) internal returns (uint256 requiredManaAmountToBurn)
768     {
769         requiredManaAmountToBurn = _bidPriceInMana;
770         Token memory fromToken = tokensAllowed[address(_fromToken)];
771 
772         uint256 bidPriceInManaPlusSafetyMargin = _bidPriceInMana.mul(conversionFee).div(100);
773 
774         // Get rate
775         uint256 tokenRate = getRate(manaToken, _fromToken, bidPriceInManaPlusSafetyMargin);
776 
777         // Check if contract should burn or transfer some tokens
778         uint256 requiredTokenBalance = 0;
779         
780         if (fromToken.shouldBurnTokens || fromToken.shouldForwardTokens) {
781             requiredTokenBalance = _calculateRequiredTokenBalance(requiredManaAmountToBurn, tokenRate);
782             requiredManaAmountToBurn = _calculateRequiredManaAmount(_bidPriceInMana);
783         }
784 
785         // Calculate the amount of _fromToken to be converted
786         uint256 tokensToConvertPlusSafetyMargin = bidPriceInManaPlusSafetyMargin
787             .mul(tokenRate)
788             .div(10 ** 18);
789 
790         // Normalize to _fromToken decimals
791         if (MAX_DECIMALS > fromToken.decimals) {
792             requiredTokenBalance = _normalizeDecimals(
793                 fromToken.decimals, 
794                 requiredTokenBalance
795             );
796             tokensToConvertPlusSafetyMargin = _normalizeDecimals(
797                 fromToken.decimals,
798                 tokensToConvertPlusSafetyMargin
799             );
800         }
801 
802         // Retrieve tokens from the sender to this contract
803         require(
804             _fromToken.safeTransferFrom(msg.sender, address(this), tokensToConvertPlusSafetyMargin),
805             "Transfering the totalPrice in token to LANDAuction contract failed"
806         );
807         
808         // Calculate the total tokens to convert
809         uint256 finalTokensToConvert = tokensToConvertPlusSafetyMargin.sub(requiredTokenBalance);
810 
811         // Approve amount of _fromToken owned by contract to be used by dex contract
812         require(_fromToken.safeApprove(address(dex), finalTokensToConvert), "Error approve");
813 
814         // Convert _fromToken to MANA
815         uint256 change = dex.convert(
816                 _fromToken,
817                 manaToken,
818                 finalTokensToConvert,
819                 requiredManaAmountToBurn
820         );
821 
822        // Return change in _fromToken to sender
823         if (change > 0) {
824             // Return the change of src token
825             require(
826                 _fromToken.safeTransfer(msg.sender, change),
827                 "Transfering the change to sender failed"
828             );
829         }
830 
831         // Remove approval of _fromToken owned by contract to be used by dex contract
832         require(_fromToken.clearApprove(address(dex)), "Error clear approval");
833 
834         emit BidConversion(
835             _bidId,
836             address(_fromToken),
837             requiredManaAmountToBurn,
838             tokensToConvertPlusSafetyMargin.sub(change),
839             requiredTokenBalance
840         );
841     }
842 
843     /**
844     * @dev Get exchange rate
845     * @param _srcToken - IERC20 token
846     * @param _destToken - IERC20 token 
847     * @param _srcAmount - uint256 amount to be converted
848     * @return uint256 of the rate
849     */
850     function getRate(
851         IERC20 _srcToken, 
852         IERC20 _destToken, 
853         uint256 _srcAmount
854     ) public view returns (uint256 rate) 
855     {
856         (rate,) = dex.getExpectedRate(_srcToken, _destToken, _srcAmount);
857     }
858 
859     /** 
860     * @dev Calculate the amount of tokens to process
861     * @param _totalPrice - uint256 price to calculate percentage to process
862     * @param _tokenRate - rate to calculate the amount of tokens
863     * @return uint256 of the amount of tokens required
864     */
865     function _calculateRequiredTokenBalance(
866         uint256 _totalPrice,
867         uint256 _tokenRate
868     ) 
869     internal pure returns (uint256) 
870     {
871         return _totalPrice.mul(_tokenRate)
872             .div(10 ** 18)
873             .mul(PERCENTAGE_OF_TOKEN_BALANCE)
874             .div(100);
875     }
876 
877     /** 
878     * @dev Calculate the total price in MANA
879     * Note that PERCENTAGE_OF_TOKEN_BALANCE will be always less than 100
880     * @param _totalPrice - uint256 price to calculate percentage to keep
881     * @return uint256 of the new total price in MANA
882     */
883     function _calculateRequiredManaAmount(
884         uint256 _totalPrice
885     ) 
886     internal pure returns (uint256)
887     {
888         return _totalPrice.mul(100 - PERCENTAGE_OF_TOKEN_BALANCE).div(100);
889     }
890 
891     /**
892     * @dev Burn or forward the MANA and other tokens earned
893     * Note that as we will transfer or burn tokens from other contracts.
894     * We should burn MANA first to avoid a possible re-entrancy
895     * @param _bidId - uint256 of the bid Id
896     * @param _token - ERC20 token
897     */
898     function _processFunds(uint256 _bidId, ERC20 _token) internal {
899         // Burn MANA
900         _burnTokens(_bidId, manaToken);
901 
902         // Burn or forward token if it is not MANA
903         Token memory token = tokensAllowed[address(_token)];
904         if (_token != manaToken) {
905             if (token.shouldBurnTokens) {
906                 _burnTokens(_bidId, _token);
907             }
908             if (token.shouldForwardTokens) {
909                 _forwardTokens(_bidId, token.forwardTarget, _token);
910             }   
911         }
912     }
913 
914     /**
915     * @dev LAND price based on time
916     * Note that will select the function to calculate based on the time
917     * It should return endPrice if _time < duration
918     * @param _time - uint256 time passed before reach duration
919     * @return uint256 price for the given time
920     */
921     function _getPrice(uint256 _time) internal view returns (uint256) {
922         for (uint256 i = 0; i < curves.length; i++) {
923             Func storage func = curves[i];
924             if (_time < func.limit) {
925                 return func.base.sub(func.slope.mul(_time));
926             }
927         }
928         revert("Invalid time");
929     }
930 
931     /** 
932     * @dev Burn tokens
933     * @param _bidId - uint256 of the bid Id
934     * @param _token - ERC20 token
935     */
936     function _burnTokens(uint256 _bidId, ERC20 _token) private {
937         uint256 balance = _token.balanceOf(address(this));
938 
939         // Check if balance is valid
940         require(balance > 0, "Balance to burn should be > 0");
941         
942         _token.burn(balance);
943 
944         emit TokenBurned(_bidId, address(_token), balance);
945 
946         // Check if balance of the auction contract is empty
947         balance = _token.balanceOf(address(this));
948         require(balance == 0, "Burn token failed");
949     }
950 
951     /** 
952     * @dev Forward tokens
953     * @param _bidId - uint256 of the bid Id
954     * @param _address - address to send the tokens to
955     * @param _token - ERC20 token
956     */
957     function _forwardTokens(uint256 _bidId, address _address, ERC20 _token) private {
958         uint256 balance = _token.balanceOf(address(this));
959 
960         // Check if balance is valid
961         require(balance > 0, "Balance to burn should be > 0");
962         
963         _token.safeTransfer(_address, balance);
964 
965         emit TokenTransferred(
966             _bidId, 
967             address(_token), 
968             _address,balance
969         );
970 
971         // Check if balance of the auction contract is empty
972         balance = _token.balanceOf(address(this));
973         require(balance == 0, "Transfer token failed");
974     }
975 
976     /**
977     * @dev Set conversion fee rate
978     * @param _fee - uint256 for the new conversion rate
979     */
980     function setConversionFee(uint256 _fee) external onlyOwner {
981         require(_fee < 200 && _fee >= 100, "Conversion fee should be >= 100 and < 200");
982         emit ConversionFeeChanged(msg.sender, conversionFee, _fee);
983         conversionFee = _fee;
984     }
985 
986     /**
987     * @dev Finish auction 
988     */
989     function finishAuction() public onlyOwner {
990         require(status != Status.finished, "The auction is finished");
991 
992         uint256 currentPrice = getCurrentPrice();
993 
994         status = Status.finished;
995         endTime = block.timestamp;
996 
997         emit AuctionFinished(msg.sender, block.timestamp, currentPrice);
998     }
999 
1000     /**
1001     * @dev Set LAND for the auction
1002     * @param _landsLimitPerBid - uint256 LAND limit for a single id
1003     */
1004     function setLandsLimitPerBid(uint256 _landsLimitPerBid) public onlyOwner {
1005         require(_landsLimitPerBid > 0, "The LAND limit should be greater than 0");
1006         emit LandsLimitPerBidChanged(msg.sender, landsLimitPerBid, _landsLimitPerBid);
1007         landsLimitPerBid = _landsLimitPerBid;
1008     }
1009 
1010     /**
1011     * @dev Set gas price limit for the auction
1012     * @param _gasPriceLimit - uint256 gas price limit for a single bid
1013     */
1014     function setGasPriceLimit(uint256 _gasPriceLimit) public onlyOwner {
1015         require(_gasPriceLimit > 0, "The gas price should be greater than 0");
1016         emit GasPriceLimitChanged(msg.sender, gasPriceLimit, _gasPriceLimit);
1017         gasPriceLimit = _gasPriceLimit;
1018     }
1019 
1020     /**
1021     * @dev Set dex to convert ERC20
1022     * @param _dex - address of the token converter
1023     */
1024     function setDex(address _dex) public onlyOwner {
1025         require(_dex != address(dex), "The dex is the current");
1026         if (_dex != address(0)) {
1027             require(_dex.isContract(), "The dex address must be a deployed contract");
1028         }
1029         emit DexChanged(msg.sender, dex, _dex);
1030         dex = ITokenConverter(_dex);
1031     }
1032 
1033     /**
1034     * @dev Allow ERC20 to to be used for bidding
1035     * Note that if _shouldBurnTokens and _shouldForwardTokens are false, we 
1036     * will convert the total amount of the ERC20 to MANA
1037     * @param _address - address of the ERC20 Token
1038     * @param _decimals - uint256 of the number of decimals
1039     * @param _shouldBurnTokens - boolean whether we should burn funds
1040     * @param _shouldForwardTokens - boolean whether we should transferred funds
1041     * @param _forwardTarget - address where the funds will be transferred
1042     */
1043     function allowToken(
1044         address _address,
1045         uint256 _decimals,
1046         bool _shouldBurnTokens,
1047         bool _shouldForwardTokens,
1048         address _forwardTarget
1049     ) 
1050     public onlyOwner 
1051     {
1052         require(
1053             _address.isContract(),
1054             "Tokens allowed should be a deployed ERC20 contract"
1055         );
1056         require(
1057             _decimals > 0 && _decimals <= MAX_DECIMALS,
1058             "Decimals should be greather than 0 and less or equal to 18"
1059         );
1060         require(
1061             !(_shouldBurnTokens && _shouldForwardTokens),
1062             "The token should be either burned or transferred"
1063         );
1064         require(
1065             !_shouldForwardTokens || 
1066             (_shouldForwardTokens && _forwardTarget != address(0)),
1067             "The token should be transferred to a deployed contract"
1068         );
1069         require(
1070             _forwardTarget != address(this) && _forwardTarget != _address, 
1071             "The forward target should be different from  this contract and the erc20 token"
1072         );
1073         
1074         require(!tokensAllowed[_address].isAllowed, "The ERC20 token is already allowed");
1075 
1076         tokensAllowed[_address] = Token({
1077             decimals: _decimals,
1078             shouldBurnTokens: _shouldBurnTokens,
1079             shouldForwardTokens: _shouldForwardTokens,
1080             forwardTarget: _forwardTarget,
1081             isAllowed: true
1082         });
1083 
1084         emit TokenAllowed(
1085             msg.sender, 
1086             _address, 
1087             _decimals,
1088             _shouldBurnTokens,
1089             _shouldForwardTokens,
1090             _forwardTarget
1091         );
1092     }
1093 
1094     /**
1095     * @dev Disable ERC20 to to be used for bidding
1096     * @param _address - address of the ERC20 Token
1097     */
1098     function disableToken(address _address) public onlyOwner {
1099         require(
1100             tokensAllowed[_address].isAllowed,
1101             "The ERC20 token is already disabled"
1102         );
1103         delete tokensAllowed[_address];
1104         emit TokenDisabled(msg.sender, _address);
1105     }
1106 
1107     /** 
1108     * @dev Create a combined function.
1109     * note that we will set N - 1 function combinations based on N points (x,y)
1110     * @param _xPoints - uint256[] of x values
1111     * @param _yPoints - uint256[] of y values
1112     */
1113     function _setCurve(uint256[] _xPoints, uint256[] _yPoints) internal {
1114         uint256 pointsLength = _xPoints.length;
1115         require(pointsLength == _yPoints.length, "Points should have the same length");
1116         for (uint256 i = 0; i < pointsLength - 1; i++) {
1117             uint256 x1 = _xPoints[i];
1118             uint256 x2 = _xPoints[i + 1];
1119             uint256 y1 = _yPoints[i];
1120             uint256 y2 = _yPoints[i + 1];
1121             require(x1 < x2, "X points should increase");
1122             require(y1 > y2, "Y points should decrease");
1123             (uint256 base, uint256 slope) = _getFunc(
1124                 x1, 
1125                 x2, 
1126                 y1, 
1127                 y2
1128             );
1129             curves.push(Func({
1130                 base: base,
1131                 slope: slope,
1132                 limit: x2
1133             }));
1134         }
1135 
1136         initialPrice = _yPoints[0];
1137         endPrice = _yPoints[pointsLength - 1];
1138     }
1139 
1140     /**
1141     * @dev Calculate base and slope for the given points
1142     * It is a linear function y = ax - b. But The slope should be negative.
1143     * As we want to avoid negative numbers in favor of using uints we use it as: y = b - ax
1144     * Based on two points (x1; x2) and (y1; y2)
1145     * base = (x2 * y1) - (x1 * y2) / (x2 - x1)
1146     * slope = (y1 - y2) / (x2 - x1) to avoid negative maths
1147     * @param _x1 - uint256 x1 value
1148     * @param _x2 - uint256 x2 value
1149     * @param _y1 - uint256 y1 value
1150     * @param _y2 - uint256 y2 value
1151     * @return uint256 for the base
1152     * @return uint256 for the slope
1153     */
1154     function _getFunc(
1155         uint256 _x1,
1156         uint256 _x2,
1157         uint256 _y1, 
1158         uint256 _y2
1159     ) internal pure returns (uint256 base, uint256 slope) 
1160     {
1161         base = ((_x2.mul(_y1)).sub(_x1.mul(_y2))).div(_x2.sub(_x1));
1162         slope = (_y1.sub(_y2)).div(_x2.sub(_x1));
1163     }
1164 
1165     /**
1166     * @dev Return bid id
1167     * @return uint256 of the bid id
1168     */
1169     function _getBidId() private view returns (uint256) {
1170         return totalBids;
1171     }
1172 
1173     /** 
1174     * @dev Normalize to _fromToken decimals
1175     * @param _decimals - uint256 of _fromToken decimals
1176     * @param _value - uint256 of the amount to normalize
1177     */
1178     function _normalizeDecimals(
1179         uint256 _decimals, 
1180         uint256 _value
1181     ) 
1182     internal pure returns (uint256 _result) 
1183     {
1184         _result = _value.div(10**MAX_DECIMALS.sub(_decimals));
1185     }
1186 
1187     /** 
1188     * @dev Update stats. It will update the following stats:
1189     * - totalBids
1190     * - totalLandsBidded
1191     * - totalManaBurned
1192     * @param _landsBidded - uint256 of the number of LAND bidded
1193     * @param _manaAmountBurned - uint256 of the amount of MANA burned
1194     */
1195     function _updateStats(uint256 _landsBidded, uint256 _manaAmountBurned) private {
1196         totalBids = totalBids.add(1);
1197         totalLandsBidded = totalLandsBidded.add(_landsBidded);
1198         totalManaBurned = totalManaBurned.add(_manaAmountBurned);
1199     }
1200 }