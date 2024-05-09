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
291         _token.transfer(_to, _value);
292 
293         require(prevBalance - _value == _token.balanceOf(address(this)), "Transfer failed");
294 
295         return true;
296     }
297 
298     /**
299     * @dev Transfer tokens from one address to another
300     * @param _token erc20 The address of the ERC20 contract
301     * @param _from address The address which you want to send tokens from
302     * @param _to address The address which you want to transfer to
303     * @param _value uint256 the _value of tokens to be transferred
304     */
305     function safeTransferFrom(
306         IERC20 _token,
307         address _from,
308         address _to, 
309         uint256 _value
310     ) internal returns (bool) 
311     {
312         uint256 prevBalance = _token.balanceOf(_from);
313 
314         require(prevBalance >= _value, "Insufficient funds");
315         require(_token.allowance(_from, address(this)) >= _value, "Insufficient allowance");
316 
317         _token.transferFrom(_from, _to, _value);
318 
319         require(prevBalance - _value == _token.balanceOf(_from), "Transfer failed");
320 
321         return true;
322     }
323 
324    /**
325    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
326    *
327    * Beware that changing an allowance with this method brings the risk that someone may use both the old
328    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
329    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
330    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
331    * 
332    * @param _token erc20 The address of the ERC20 contract
333    * @param _spender The address which will spend the funds.
334    * @param _value The amount of tokens to be spent.
335    */
336     function safeApprove(IERC20 _token, address _spender, uint256 _value) internal returns (bool) {
337         bool success = address(_token).call(abi.encodeWithSelector(
338             _token.approve.selector,
339             _spender,
340             _value
341         )); 
342 
343         if (!success) {
344             return false;
345         }
346 
347         require(_token.allowance(address(this), _spender) == _value, "Approve failed");
348 
349         return true;
350     }
351 
352    /** 
353    * @dev Clear approval
354    * Note that if 0 is not a valid value it will be set to 1.
355    * @param _token erc20 The address of the ERC20 contract
356    * @param _spender The address which will spend the funds.
357    */
358     function clearApprove(IERC20 _token, address _spender) internal returns (bool) {
359         bool success = safeApprove(_token, _spender, 0);
360 
361         if (!success) {
362             return safeApprove(_token, _spender, 1);
363         }
364 
365         return true;
366     }
367 }
368 
369 // File: contracts/dex/ITokenConverter.sol
370 
371 contract ITokenConverter {    
372     using SafeMath for uint256;
373 
374     /**
375     * @dev Makes a simple ERC20 -> ERC20 token trade
376     * @param _srcToken - IERC20 token
377     * @param _destToken - IERC20 token 
378     * @param _srcAmount - uint256 amount to be converted
379     * @param _destAmount - uint256 amount to get after conversion
380     * @return uint256 for the change. 0 if there is no change
381     */
382     function convert(
383         IERC20 _srcToken,
384         IERC20 _destToken,
385         uint256 _srcAmount,
386         uint256 _destAmount
387         ) external returns (uint256);
388 
389     /**
390     * @dev Get exchange rate and slippage rate. 
391     * Note that these returned values are in 18 decimals regardless of the destination token's decimals.
392     * @param _srcToken - IERC20 token
393     * @param _destToken - IERC20 token 
394     * @param _srcAmount - uint256 amount to be converted
395     * @return uint256 of the expected rate
396     * @return uint256 of the slippage rate
397     */
398     function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint256 _srcAmount) 
399         public view returns(uint256 expectedRate, uint256 slippageRate);
400 }
401 
402 // File: contracts/auction/LANDAuctionStorage.sol
403 
404 /**
405 * @title ERC20 Interface with burn
406 * @dev IERC20 imported in ItokenConverter.sol
407 */
408 contract ERC20 is IERC20 {
409     function burn(uint256 _value) public;
410 }
411 
412 
413 /**
414 * @title Interface for contracts conforming to ERC-721
415 */
416 contract LANDRegistry {
417     function assignMultipleParcels(int[] x, int[] y, address beneficiary) external;
418 }
419 
420 
421 contract LANDAuctionStorage {
422     uint256 constant public PERCENTAGE_OF_TOKEN_BALANCE = 5;
423     uint256 constant public MAX_DECIMALS = 18;
424 
425     enum Status { created, finished }
426 
427     struct Func {
428         uint256 slope;
429         uint256 base;
430         uint256 limit;
431     }
432 
433     struct Token {
434         uint256 decimals;
435         bool shouldBurnTokens;
436         bool shouldForwardTokens;
437         address forwardTarget;
438         bool isAllowed;
439     }
440 
441     uint256 public conversionFee = 105;
442     uint256 public totalBids = 0;
443     Status public status;
444     uint256 public gasPriceLimit;
445     uint256 public landsLimitPerBid;
446     ERC20 public manaToken;
447     LANDRegistry public landRegistry;
448     ITokenConverter public dex;
449     mapping (address => Token) public tokensAllowed;
450     uint256 public totalManaBurned = 0;
451     uint256 public totalLandsBidded = 0;
452     uint256 public startTime;
453     uint256 public endTime;
454 
455     Func[] internal curves;
456     uint256 internal initialPrice;
457     uint256 internal endPrice;
458     uint256 internal duration;
459 
460     event AuctionCreated(
461       address indexed _caller,
462       uint256 _startTime,
463       uint256 _duration,
464       uint256 _initialPrice,
465       uint256 _endPrice
466     );
467 
468     event BidConversion(
469       uint256 _bidId,
470       address indexed _token,
471       uint256 _requiredManaAmountToBurn,
472       uint256 _amountOfTokenConverted,
473       uint256 _requiredTokenBalance
474     );
475 
476     event BidSuccessful(
477       uint256 _bidId,
478       address indexed _beneficiary,
479       address indexed _token,
480       uint256 _pricePerLandInMana,
481       uint256 _manaAmountToBurn,
482       int[] _xs,
483       int[] _ys
484     );
485 
486     event AuctionFinished(
487       address indexed _caller,
488       uint256 _time,
489       uint256 _pricePerLandInMana
490     );
491 
492     event TokenBurned(
493       uint256 _bidId,
494       address indexed _token,
495       uint256 _total
496     );
497 
498     event TokenTransferred(
499       uint256 _bidId,
500       address indexed _token,
501       address indexed _to,
502       uint256 _total
503     );
504 
505     event LandsLimitPerBidChanged(
506       address indexed _caller,
507       uint256 _oldLandsLimitPerBid, 
508       uint256 _landsLimitPerBid
509     );
510 
511     event GasPriceLimitChanged(
512       address indexed _caller,
513       uint256 _oldGasPriceLimit,
514       uint256 _gasPriceLimit
515     );
516 
517     event DexChanged(
518       address indexed _caller,
519       address indexed _oldDex,
520       address indexed _dex
521     );
522 
523     event TokenAllowed(
524       address indexed _caller,
525       address indexed _address,
526       uint256 _decimals,
527       bool _shouldBurnTokens,
528       bool _shouldForwardTokens,
529       address indexed _forwardTarget
530     );
531 
532     event TokenDisabled(
533       address indexed _caller,
534       address indexed _address
535     );
536 
537     event ConversionFeeChanged(
538       address indexed _caller,
539       uint256 _oldConversionFee,
540       uint256 _conversionFee
541     );
542 }
543 
544 // File: contracts/auction/LANDAuction.sol
545 
546 contract LANDAuction is Ownable, LANDAuctionStorage {
547     using SafeMath for uint256;
548     using Address for address;
549     using SafeERC20 for ERC20;
550 
551     /**
552     * @dev Constructor of the contract.
553     * Note that the last value of _xPoints will be the total duration and
554     * the first value of _yPoints will be the initial price and the last value will be the endPrice
555     * @param _xPoints - uint256[] of seconds
556     * @param _yPoints - uint256[] of prices
557     * @param _startTime - uint256 timestamp in seconds when the auction will start
558     * @param _landsLimitPerBid - uint256 LAND limit for a single bid
559     * @param _gasPriceLimit - uint256 gas price limit for a single bid
560     * @param _manaToken - address of the MANA token
561     * @param _landRegistry - address of the LANDRegistry
562     * @param _dex - address of the Dex to convert ERC20 tokens allowed to MANA
563     */
564     constructor(
565         uint256[] _xPoints, 
566         uint256[] _yPoints, 
567         uint256 _startTime,
568         uint256 _landsLimitPerBid,
569         uint256 _gasPriceLimit,
570         ERC20 _manaToken,
571         LANDRegistry _landRegistry,
572         address _dex
573     ) public {
574         require(
575             PERCENTAGE_OF_TOKEN_BALANCE == 5, 
576             "Balance of tokens required should be equal to 5%"
577         );
578         // Initialize owneable
579         Ownable.initialize(msg.sender);
580 
581         // Schedule auction
582         require(_startTime > block.timestamp, "Started time should be after now");
583         startTime = _startTime;
584 
585         // Set LANDRegistry
586         require(
587             address(_landRegistry).isContract(),
588             "The LANDRegistry token address must be a deployed contract"
589         );
590         landRegistry = _landRegistry;
591 
592         setDex(_dex);
593 
594         // Set MANAToken
595         allowToken(
596             address(_manaToken), 
597             18,
598             true, 
599             false, 
600             address(0)
601         );
602         manaToken = _manaToken;
603 
604         // Set total duration of the auction
605         duration = _xPoints[_xPoints.length - 1];
606         require(duration > 1 days, "The duration should be greater than 1 day");
607 
608         // Set Curve
609         _setCurve(_xPoints, _yPoints);
610 
611         // Set limits
612         setLandsLimitPerBid(_landsLimitPerBid);
613         setGasPriceLimit(_gasPriceLimit);
614         
615         // Initialize status
616         status = Status.created;      
617 
618         emit AuctionCreated(
619             msg.sender,
620             startTime,
621             duration,
622             initialPrice, 
623             endPrice
624         );
625     }
626 
627     /**
628     * @dev Make a bid for LANDs
629     * @param _xs - uint256[] x values for the LANDs to bid
630     * @param _ys - uint256[] y values for the LANDs to bid
631     * @param _beneficiary - address beneficiary for the LANDs to bid
632     * @param _fromToken - token used to bid
633     */
634     function bid(
635         int[] _xs, 
636         int[] _ys, 
637         address _beneficiary, 
638         ERC20 _fromToken
639     )
640         external 
641     {
642         _validateBidParameters(
643             _xs, 
644             _ys, 
645             _beneficiary, 
646             _fromToken
647         );
648         
649         uint256 bidId = _getBidId();
650         uint256 bidPriceInMana = _xs.length.mul(getCurrentPrice());
651         uint256 manaAmountToBurn = bidPriceInMana;
652 
653         if (address(_fromToken) != address(manaToken)) {
654             require(
655                 address(dex).isContract(), 
656                 "Paying with other tokens has been disabled"
657             );
658             // Convert from the other token to MANA. The amount to be burned might be smaller
659             // because 5% will be burned or forwarded without converting it to MANA.
660             manaAmountToBurn = _convertSafe(bidId, _fromToken, bidPriceInMana);
661         } else {
662             // Transfer MANA to this contract
663             require(
664                 _fromToken.safeTransferFrom(msg.sender, address(this), bidPriceInMana),
665                 "Insuficient balance or unauthorized amount (transferFrom failed)"
666             );
667         }
668 
669         // Process funds (burn or forward them)
670         _processFunds(bidId, _fromToken);
671 
672         // Assign LANDs to the beneficiary user
673         landRegistry.assignMultipleParcels(_xs, _ys, _beneficiary);
674 
675         emit BidSuccessful(
676             bidId,
677             _beneficiary,
678             _fromToken,
679             getCurrentPrice(),
680             manaAmountToBurn,
681             _xs,
682             _ys
683         );  
684 
685         // Update stats
686         _updateStats(_xs.length, manaAmountToBurn);        
687     }
688 
689     /** 
690     * @dev Validate bid function params
691     * @param _xs - int[] x values for the LANDs to bid
692     * @param _ys - int[] y values for the LANDs to bid
693     * @param _beneficiary - address beneficiary for the LANDs to bid
694     * @param _fromToken - token used to bid
695     */
696     function _validateBidParameters(
697         int[] _xs, 
698         int[] _ys, 
699         address _beneficiary, 
700         ERC20 _fromToken
701     ) internal view 
702     {
703         require(startTime <= block.timestamp, "The auction has not started");
704         require(
705             status == Status.created && 
706             block.timestamp.sub(startTime) <= duration, 
707             "The auction has finished"
708         );
709         require(tx.gasprice <= gasPriceLimit, "Gas price limit exceeded");
710         require(_beneficiary != address(0), "The beneficiary could not be the 0 address");
711         require(_xs.length > 0, "You should bid for at least one LAND");
712         require(_xs.length <= landsLimitPerBid, "LAND limit exceeded");
713         require(_xs.length == _ys.length, "X values length should be equal to Y values length");
714         require(tokensAllowed[address(_fromToken)].isAllowed, "Token not allowed");
715         for (uint256 i = 0; i < _xs.length; i++) {
716             require(
717                 -150 <= _xs[i] && _xs[i] <= 150 && -150 <= _ys[i] && _ys[i] <= 150,
718                 "The coordinates should be inside bounds -150 & 150"
719             );
720         }
721     }
722 
723     /**
724     * @dev Current LAND price. 
725     * Note that if the auction has not started returns the initial price and when
726     * the auction is finished return the endPrice
727     * @return uint256 current LAND price
728     */
729     function getCurrentPrice() public view returns (uint256) { 
730         // If the auction has not started returns initialPrice
731         if (startTime == 0 || startTime >= block.timestamp) {
732             return initialPrice;
733         }
734 
735         // If the auction has finished returns endPrice
736         uint256 timePassed = block.timestamp - startTime;
737         if (timePassed >= duration) {
738             return endPrice;
739         }
740 
741         return _getPrice(timePassed);
742     }
743 
744     /**
745     * @dev Convert allowed token to MANA and transfer the change in the original token
746     * Note that we will use the slippageRate cause it has a 3% buffer and a deposit of 5% to cover
747     * the conversion fee.
748     * @param _bidId - uint256 of the bid Id
749     * @param _fromToken - ERC20 token to be converted
750     * @param _bidPriceInMana - uint256 of the total amount in MANA
751     * @return uint256 of the total amount of MANA to burn
752     */
753     function _convertSafe(
754         uint256 _bidId,
755         ERC20 _fromToken,
756         uint256 _bidPriceInMana
757     ) internal returns (uint256 requiredManaAmountToBurn)
758     {
759         requiredManaAmountToBurn = _bidPriceInMana;
760         Token memory fromToken = tokensAllowed[address(_fromToken)];
761 
762         uint256 bidPriceInManaPlusSafetyMargin = _bidPriceInMana.mul(conversionFee).div(100);
763 
764         // Get rate
765         uint256 tokenRate = getRate(manaToken, _fromToken, bidPriceInManaPlusSafetyMargin);
766 
767         // Check if contract should burn or transfer some tokens
768         uint256 requiredTokenBalance = 0;
769         
770         if (fromToken.shouldBurnTokens || fromToken.shouldForwardTokens) {
771             requiredTokenBalance = _calculateRequiredTokenBalance(requiredManaAmountToBurn, tokenRate);
772             requiredManaAmountToBurn = _calculateRequiredManaAmount(_bidPriceInMana);
773         }
774 
775         // Calculate the amount of _fromToken to be converted
776         uint256 tokensToConvertPlusSafetyMargin = bidPriceInManaPlusSafetyMargin
777             .mul(tokenRate)
778             .div(10 ** 18);
779 
780         // Normalize to _fromToken decimals
781         if (MAX_DECIMALS > fromToken.decimals) {
782             requiredTokenBalance = _normalizeDecimals(
783                 fromToken.decimals, 
784                 requiredTokenBalance
785             );
786             tokensToConvertPlusSafetyMargin = _normalizeDecimals(
787                 fromToken.decimals,
788                 tokensToConvertPlusSafetyMargin
789             );
790         }
791 
792         // Retrieve tokens from the sender to this contract
793         require(
794             _fromToken.safeTransferFrom(msg.sender, address(this), tokensToConvertPlusSafetyMargin),
795             "Transfering the totalPrice in token to LANDAuction contract failed"
796         );
797         
798         // Calculate the total tokens to convert
799         uint256 finalTokensToConvert = tokensToConvertPlusSafetyMargin.sub(requiredTokenBalance);
800 
801         // Approve amount of _fromToken owned by contract to be used by dex contract
802         require(_fromToken.safeApprove(address(dex), finalTokensToConvert), "Error approve");
803 
804         // Convert _fromToken to MANA
805         uint256 change = dex.convert(
806                 _fromToken,
807                 manaToken,
808                 finalTokensToConvert,
809                 requiredManaAmountToBurn
810         );
811 
812        // Return change in _fromToken to sender
813         if (change > 0) {
814             // Return the change of src token
815             require(
816                 _fromToken.safeTransfer(msg.sender, change),
817                 "Transfering the change to sender failed"
818             );
819         }
820 
821         // Remove approval of _fromToken owned by contract to be used by dex contract
822         require(_fromToken.clearApprove(address(dex)), "Error remove approval");
823 
824         emit BidConversion(
825             _bidId,
826             address(_fromToken),
827             requiredManaAmountToBurn,
828             tokensToConvertPlusSafetyMargin.sub(change),
829             requiredTokenBalance
830         );
831     }
832 
833     /**
834     * @dev Get exchange rate
835     * @param _srcToken - IERC20 token
836     * @param _destToken - IERC20 token 
837     * @param _srcAmount - uint256 amount to be converted
838     * @return uint256 of the rate
839     */
840     function getRate(
841         IERC20 _srcToken, 
842         IERC20 _destToken, 
843         uint256 _srcAmount
844     ) public view returns (uint256 rate) 
845     {
846         (rate,) = dex.getExpectedRate(_srcToken, _destToken, _srcAmount);
847     }
848 
849     /** 
850     * @dev Calculate the amount of tokens to process
851     * @param _totalPrice - uint256 price to calculate percentage to process
852     * @param _tokenRate - rate to calculate the amount of tokens
853     * @return uint256 of the amount of tokens required
854     */
855     function _calculateRequiredTokenBalance(
856         uint256 _totalPrice,
857         uint256 _tokenRate
858     ) 
859     internal pure returns (uint256) 
860     {
861         return _totalPrice.mul(_tokenRate)
862             .div(10 ** 18)
863             .mul(PERCENTAGE_OF_TOKEN_BALANCE)
864             .div(100);
865     }
866 
867     /** 
868     * @dev Calculate the total price in MANA
869     * Note that PERCENTAGE_OF_TOKEN_BALANCE will be always less than 100
870     * @param _totalPrice - uint256 price to calculate percentage to keep
871     * @return uint256 of the new total price in MANA
872     */
873     function _calculateRequiredManaAmount(
874         uint256 _totalPrice
875     ) 
876     internal pure returns (uint256)
877     {
878         return _totalPrice.mul(100 - PERCENTAGE_OF_TOKEN_BALANCE).div(100);
879     }
880 
881     /**
882     * @dev Burn or forward the MANA and other tokens earned
883     * Note that as we will transfer or burn tokens from other contracts.
884     * We should burn MANA first to avoid a possible re-entrancy
885     * @param _bidId - uint256 of the bid Id
886     * @param _token - ERC20 token
887     */
888     function _processFunds(uint256 _bidId, ERC20 _token) internal {
889         // Burn MANA
890         _burnTokens(_bidId, manaToken);
891 
892         // Burn or forward token if it is not MANA
893         Token memory token = tokensAllowed[address(_token)];
894         if (_token != manaToken) {
895             if (token.shouldBurnTokens) {
896                 _burnTokens(_bidId, _token);
897             }
898             if (token.shouldForwardTokens) {
899                 _forwardTokens(_bidId, token.forwardTarget, _token);
900             }   
901         }
902     }
903 
904     /**
905     * @dev LAND price based on time
906     * Note that will select the function to calculate based on the time
907     * It should return endPrice if _time < duration
908     * @param _time - uint256 time passed before reach duration
909     * @return uint256 price for the given time
910     */
911     function _getPrice(uint256 _time) internal view returns (uint256) {
912         for (uint256 i = 0; i < curves.length; i++) {
913             Func storage func = curves[i];
914             if (_time < func.limit) {
915                 return func.base.sub(func.slope.mul(_time));
916             }
917         }
918         revert("Invalid time");
919     }
920 
921     /** 
922     * @dev Burn tokens
923     * @param _bidId - uint256 of the bid Id
924     * @param _token - ERC20 token
925     */
926     function _burnTokens(uint256 _bidId, ERC20 _token) private {
927         uint256 balance = _token.balanceOf(address(this));
928 
929         // Check if balance is valid
930         require(balance > 0, "Balance to burn should be > 0");
931         
932         _token.burn(balance);
933 
934         emit TokenBurned(_bidId, address(_token), balance);
935 
936         // Check if balance of the auction contract is empty
937         balance = _token.balanceOf(address(this));
938         require(balance == 0, "Burn token failed");
939     }
940 
941     /** 
942     * @dev Forward tokens
943     * @param _bidId - uint256 of the bid Id
944     * @param _address - address to send the tokens to
945     * @param _token - ERC20 token
946     */
947     function _forwardTokens(uint256 _bidId, address _address, ERC20 _token) private {
948         uint256 balance = _token.balanceOf(address(this));
949 
950         // Check if balance is valid
951         require(balance > 0, "Balance to burn should be > 0");
952         
953         _token.safeTransfer(_address, balance);
954 
955         emit TokenTransferred(
956             _bidId, 
957             address(_token), 
958             _address,balance
959         );
960 
961         // Check if balance of the auction contract is empty
962         balance = _token.balanceOf(address(this));
963         require(balance == 0, "Transfer token failed");
964     }
965 
966     /**
967     * @dev Set conversion fee rate
968     * @param _fee - uint256 for the new conversion rate
969     */
970     function setConversionFee(uint256 _fee) external onlyOwner {
971         require(_fee < 200 && _fee >= 100, "Conversion fee should be >= 100 and < 200");
972         emit ConversionFeeChanged(msg.sender, conversionFee, _fee);
973         conversionFee = _fee;
974     }
975 
976     /**
977     * @dev Finish auction 
978     */
979     function finishAuction() public onlyOwner {
980         require(status != Status.finished, "The auction is finished");
981 
982         uint256 currentPrice = getCurrentPrice();
983 
984         status = Status.finished;
985         endTime = block.timestamp;
986 
987         emit AuctionFinished(msg.sender, block.timestamp, currentPrice);
988     }
989 
990     /**
991     * @dev Set LAND for the auction
992     * @param _landsLimitPerBid - uint256 LAND limit for a single id
993     */
994     function setLandsLimitPerBid(uint256 _landsLimitPerBid) public onlyOwner {
995         require(_landsLimitPerBid > 0, "The LAND limit should be greater than 0");
996         emit LandsLimitPerBidChanged(msg.sender, landsLimitPerBid, _landsLimitPerBid);
997         landsLimitPerBid = _landsLimitPerBid;
998     }
999 
1000     /**
1001     * @dev Set gas price limit for the auction
1002     * @param _gasPriceLimit - uint256 gas price limit for a single bid
1003     */
1004     function setGasPriceLimit(uint256 _gasPriceLimit) public onlyOwner {
1005         require(_gasPriceLimit > 0, "The gas price should be greater than 0");
1006         emit GasPriceLimitChanged(msg.sender, gasPriceLimit, _gasPriceLimit);
1007         gasPriceLimit = _gasPriceLimit;
1008     }
1009 
1010     /**
1011     * @dev Set dex to convert ERC20
1012     * @param _dex - address of the token converter
1013     */
1014     function setDex(address _dex) public onlyOwner {
1015         require(_dex != address(dex), "The dex is the current");
1016         if (_dex != address(0)) {
1017             require(_dex.isContract(), "The dex address must be a deployed contract");
1018         }
1019         emit DexChanged(msg.sender, dex, _dex);
1020         dex = ITokenConverter(_dex);
1021     }
1022 
1023     /**
1024     * @dev Allow ERC20 to to be used for bidding
1025     * Note that if _shouldBurnTokens and _shouldForwardTokens are false, we 
1026     * will convert the total amount of the ERC20 to MANA
1027     * @param _address - address of the ERC20 Token
1028     * @param _decimals - uint256 of the number of decimals
1029     * @param _shouldBurnTokens - boolean whether we should burn funds
1030     * @param _shouldForwardTokens - boolean whether we should transferred funds
1031     * @param _forwardTarget - address where the funds will be transferred
1032     */
1033     function allowToken(
1034         address _address,
1035         uint256 _decimals,
1036         bool _shouldBurnTokens,
1037         bool _shouldForwardTokens,
1038         address _forwardTarget
1039     ) 
1040     public onlyOwner 
1041     {
1042         require(
1043             _address.isContract(),
1044             "Tokens allowed should be a deployed ERC20 contract"
1045         );
1046         require(
1047             _decimals > 0 && _decimals <= MAX_DECIMALS,
1048             "Decimals should be greather than 0 and less or equal to 18"
1049         );
1050         require(
1051             !(_shouldBurnTokens && _shouldForwardTokens),
1052             "The token should be either burned or transferred"
1053         );
1054         require(
1055             !_shouldForwardTokens || 
1056             (_shouldForwardTokens && _forwardTarget != address(0)),
1057             "The token should be transferred to a deployed contract"
1058         );
1059         require(
1060             _forwardTarget != address(this) && _forwardTarget != _address, 
1061             "The forward target should be different from  this contract and the erc20 token"
1062         );
1063         
1064         require(!tokensAllowed[_address].isAllowed, "The ERC20 token is already allowed");
1065 
1066         tokensAllowed[_address] = Token({
1067             decimals: _decimals,
1068             shouldBurnTokens: _shouldBurnTokens,
1069             shouldForwardTokens: _shouldForwardTokens,
1070             forwardTarget: _forwardTarget,
1071             isAllowed: true
1072         });
1073 
1074         emit TokenAllowed(
1075             msg.sender, 
1076             _address, 
1077             _decimals,
1078             _shouldBurnTokens,
1079             _shouldForwardTokens,
1080             _forwardTarget
1081         );
1082     }
1083 
1084     /**
1085     * @dev Disable ERC20 to to be used for bidding
1086     * @param _address - address of the ERC20 Token
1087     */
1088     function disableToken(address _address) public onlyOwner {
1089         require(
1090             tokensAllowed[_address].isAllowed,
1091             "The ERC20 token is already disabled"
1092         );
1093         delete tokensAllowed[_address];
1094         emit TokenDisabled(msg.sender, _address);
1095     }
1096 
1097     /** 
1098     * @dev Create a combined function.
1099     * note that we will set N - 1 function combinations based on N points (x,y)
1100     * @param _xPoints - uint256[] of x values
1101     * @param _yPoints - uint256[] of y values
1102     */
1103     function _setCurve(uint256[] _xPoints, uint256[] _yPoints) internal {
1104         uint256 pointsLength = _xPoints.length;
1105         require(pointsLength == _yPoints.length, "Points should have the same length");
1106         for (uint256 i = 0; i < pointsLength - 1; i++) {
1107             uint256 x1 = _xPoints[i];
1108             uint256 x2 = _xPoints[i + 1];
1109             uint256 y1 = _yPoints[i];
1110             uint256 y2 = _yPoints[i + 1];
1111             require(x1 < x2, "X points should increase");
1112             require(y1 > y2, "Y points should decrease");
1113             (uint256 base, uint256 slope) = _getFunc(
1114                 x1, 
1115                 x2, 
1116                 y1, 
1117                 y2
1118             );
1119             curves.push(Func({
1120                 base: base,
1121                 slope: slope,
1122                 limit: x2
1123             }));
1124         }
1125 
1126         initialPrice = _yPoints[0];
1127         endPrice = _yPoints[pointsLength - 1];
1128     }
1129 
1130     /**
1131     * @dev Calculate base and slope for the given points
1132     * It is a linear function y = ax - b. But The slope should be negative.
1133     * As we want to avoid negative numbers in favor of using uints we use it as: y = b - ax
1134     * Based on two points (x1; x2) and (y1; y2)
1135     * base = (x2 * y1) - (x1 * y2) / (x2 - x1)
1136     * slope = (y1 - y2) / (x2 - x1) to avoid negative maths
1137     * @param _x1 - uint256 x1 value
1138     * @param _x2 - uint256 x2 value
1139     * @param _y1 - uint256 y1 value
1140     * @param _y2 - uint256 y2 value
1141     * @return uint256 for the base
1142     * @return uint256 for the slope
1143     */
1144     function _getFunc(
1145         uint256 _x1,
1146         uint256 _x2,
1147         uint256 _y1, 
1148         uint256 _y2
1149     ) internal pure returns (uint256 base, uint256 slope) 
1150     {
1151         base = ((_x2.mul(_y1)).sub(_x1.mul(_y2))).div(_x2.sub(_x1));
1152         slope = (_y1.sub(_y2)).div(_x2.sub(_x1));
1153     }
1154 
1155     /**
1156     * @dev Return bid id
1157     * @return uint256 of the bid id
1158     */
1159     function _getBidId() private view returns (uint256) {
1160         return totalBids;
1161     }
1162 
1163     /** 
1164     * @dev Normalize to _fromToken decimals
1165     * @param _decimals - uint256 of _fromToken decimals
1166     * @param _value - uint256 of the amount to normalize
1167     */
1168     function _normalizeDecimals(
1169         uint256 _decimals, 
1170         uint256 _value
1171     ) 
1172     internal pure returns (uint256 _result) 
1173     {
1174         _result = _value.div(10**MAX_DECIMALS.sub(_decimals));
1175     }
1176 
1177     /** 
1178     * @dev Update stats. It will update the following stats:
1179     * - totalBids
1180     * - totalLandsBidded
1181     * - totalManaBurned
1182     * @param _landsBidded - uint256 of the number of LAND bidded
1183     * @param _manaAmountBurned - uint256 of the amount of MANA burned
1184     */
1185     function _updateStats(uint256 _landsBidded, uint256 _manaAmountBurned) private {
1186         totalBids = totalBids.add(1);
1187         totalLandsBidded = totalLandsBidded.add(_landsBidded);
1188         totalManaBurned = totalManaBurned.add(_manaAmountBurned);
1189     }
1190 }