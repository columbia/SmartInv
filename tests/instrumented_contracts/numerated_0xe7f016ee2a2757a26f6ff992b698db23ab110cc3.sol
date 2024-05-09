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
269 // File: contracts/dex/ITokenConverter.sol
270 
271 contract ITokenConverter {    
272     using SafeMath for uint256;
273 
274     /**
275     * @dev Makes a simple ERC20 -> ERC20 token trade
276     * @param _srcToken - IERC20 token
277     * @param _destToken - IERC20 token 
278     * @param _srcAmount - uint256 amount to be converted
279     * @param _destAmount - uint256 amount to get after conversion
280     * @return uint256 for the change. 0 if there is no change
281     */
282     function convert(
283         IERC20 _srcToken,
284         IERC20 _destToken,
285         uint256 _srcAmount,
286         uint256 _destAmount
287         ) external payable returns (uint256);
288 
289     /**
290     * @dev Get exchange rate and slippage rate. 
291     * Note that these returned values are in 18 decimals regardless of the destination token's decimals.
292     * @param _srcToken - IERC20 token
293     * @param _destToken - IERC20 token 
294     * @param _srcAmount - uint256 amount to be converted
295     * @return uint256 of the expected rate
296     * @return uint256 of the slippage rate
297     */
298     function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint256 _srcAmount) 
299         public view returns(uint256 expectedRate, uint256 slippageRate);
300 }
301 
302 // File: contracts/auction/LANDAuctionStorage.sol
303 
304 /**
305 * @title ERC20 Interface with burn
306 * @dev IERC20 imported in ItokenConverter.sol
307 */
308 contract ERC20 is IERC20 {
309     function burn(uint256 _value) public;
310 }
311 
312 
313 /**
314 * @title Interface for contracts conforming to ERC-721
315 */
316 contract LANDRegistry {
317     function assignMultipleParcels(int[] x, int[] y, address beneficiary) external;
318 }
319 
320 
321 contract LANDAuctionStorage {
322     uint256 constant public PERCENTAGE_OF_TOKEN_TO_KEEP = 5;
323     uint256 constant public MAX_DECIMALS = 18;
324 
325     enum Status { created, finished }
326 
327     struct Func {
328         uint256 slope;
329         uint256 base;
330         uint256 limit;
331     }
332 
333     struct Token {
334         uint256 decimals;
335         bool shouldBurnTokens;
336         bool shouldForwardTokens;
337         address forwardTarget;
338         bool isAllowed;
339     }
340 
341     uint256 public conversionFee = 105;
342     uint256 public totalBids = 0;
343     Status public status;
344     uint256 public gasPriceLimit;
345     uint256 public landsLimitPerBid;
346     ERC20 public manaToken;
347     LANDRegistry public landRegistry;
348     ITokenConverter public dex;
349     mapping (address => Token) public tokensAllowed;
350     uint256 public totalManaBurned = 0;
351     uint256 public totalLandsBidded = 0;
352     uint256 public startTime;
353     uint256 public endTime;
354 
355     Func[] internal curves;
356     uint256 internal initialPrice;
357     uint256 internal endPrice;
358     uint256 internal duration;
359 
360     event AuctionCreated(
361       address indexed _caller,
362       uint256 _startTime,
363       uint256 _duration,
364       uint256 _initialPrice,
365       uint256 _endPrice
366     );
367 
368     event BidConversion(
369       uint256 _bidId,
370       address indexed _token,
371       uint256 _requiredManaAmountToBurn,
372       uint256 _amountOfTokenConverted,
373       uint256 _requiredTokenBalance
374     );
375 
376     event BidSuccessful(
377       uint256 _bidId,
378       address indexed _beneficiary,
379       address indexed _token,
380       uint256 _pricePerLandInMana,
381       uint256 _manaAmountToBurn,
382       int[] _xs,
383       int[] _ys
384     );
385 
386     event AuctionFinished(
387       address indexed _caller,
388       uint256 _time,
389       uint256 _pricePerLandInMana
390     );
391 
392     event TokenBurned(
393       uint256 _bidId,
394       address indexed _token,
395       uint256 _total
396     );
397 
398     event TokenTransferred(
399       uint256 _bidId,
400       address indexed _token,
401       address indexed _to,
402       uint256 _total
403     );
404 
405     event LandsLimitPerBidChanged(
406       address indexed _caller,
407       uint256 _oldLandsLimitPerBid, 
408       uint256 _landsLimitPerBid
409     );
410 
411     event GasPriceLimitChanged(
412       address indexed _caller,
413       uint256 _oldGasPriceLimit,
414       uint256 _gasPriceLimit
415     );
416 
417     event DexChanged(
418       address indexed _caller,
419       address indexed _oldDex,
420       address indexed _dex
421     );
422 
423     event TokenAllowed(
424       address indexed _caller,
425       address indexed _address,
426       uint256 _decimals,
427       bool _shouldBurnTokens,
428       bool _shouldForwardTokens,
429       address indexed _forwardTarget
430     );
431 
432     event TokenDisabled(
433       address indexed _caller,
434       address indexed _address
435     );
436 
437     event ConversionFeeChanged(
438       address indexed _caller,
439       uint256 _oldConversionFee,
440       uint256 _conversionFee
441     );
442 }
443 
444 // File: contracts/auction/LANDAuction.sol
445 
446 contract LANDAuction is Ownable, LANDAuctionStorage {
447     using SafeMath for uint256;
448     using Address for address;
449 
450     /**
451     * @dev Constructor of the contract.
452     * Note that the last value of _xPoints will be the total duration and
453     * the first value of _yPoints will be the initial price and the last value will be the endPrice
454     * @param _xPoints - uint256[] of seconds
455     * @param _yPoints - uint256[] of prices
456     * @param _startTime - uint256 timestamp in seconds when the auction will start
457     * @param _landsLimitPerBid - uint256 LAND limit for a single bid
458     * @param _gasPriceLimit - uint256 gas price limit for a single bid
459     * @param _manaToken - address of the MANA token
460     * @param _landRegistry - address of the LANDRegistry
461     * @param _dex - address of the Dex to convert ERC20 tokens allowed to MANA
462     */
463     constructor(
464         uint256[] _xPoints, 
465         uint256[] _yPoints, 
466         uint256 _startTime,
467         uint256 _landsLimitPerBid,
468         uint256 _gasPriceLimit,
469         ERC20 _manaToken,
470         LANDRegistry _landRegistry,
471         address _dex
472     ) public {
473         // Initialize owneable
474         Ownable.initialize(msg.sender);
475 
476         // Schedule auction
477         require(_startTime > block.timestamp, "Started time should be after now");
478         startTime = _startTime;
479 
480         // Set LANDRegistry
481         require(
482             address(_landRegistry).isContract(),
483             "The LANDRegistry token address must be a deployed contract"
484         );
485         landRegistry = _landRegistry;
486 
487         setDex(_dex);
488 
489         // Set MANAToken
490         allowToken(
491             address(_manaToken), 
492             18,
493             true, 
494             false, 
495             address(0)
496         );
497         manaToken = _manaToken;
498 
499         // Set total duration of the auction
500         duration = _xPoints[_xPoints.length - 1];
501         require(duration > 24 * 60 * 60, "The duration should be greater than 1 day");
502 
503         // Set Curve
504         _setCurve(_xPoints, _yPoints);
505 
506         // Set limits
507         setLandsLimitPerBid(_landsLimitPerBid);
508         setGasPriceLimit(_gasPriceLimit);
509         
510         // Initialize status
511         status = Status.created;      
512 
513         emit AuctionCreated(
514             msg.sender,
515             startTime,
516             duration,
517             initialPrice, 
518             endPrice
519         );
520     }
521 
522     /**
523     * @dev Make a bid for LANDs
524     * @param _xs - uint256[] x values for the LANDs to bid
525     * @param _ys - uint256[] y values for the LANDs to bid
526     * @param _beneficiary - address beneficiary for the LANDs to bid
527     * @param _fromToken - token used to bid
528     */
529     function bid(
530         int[] _xs, 
531         int[] _ys, 
532         address _beneficiary, 
533         ERC20 _fromToken
534     )
535         external 
536     {
537         _validateBidParameters(
538             _xs, 
539             _ys, 
540             _beneficiary, 
541             _fromToken
542         );
543         
544         uint256 bidId = _getBidId();
545         uint256 bidPriceInMana = _xs.length.mul(getCurrentPrice());
546         uint256 manaAmountToBurn = bidPriceInMana;
547 
548         if (address(_fromToken) != address(manaToken)) {
549             require(
550                 address(dex).isContract(), 
551                 "Paying with other tokens has been disabled"
552             );
553             // Convert from the other token to MANA. The amount to be burned might be smaller
554             // because 5% will be burned or forwarded without converting it to MANA.
555             manaAmountToBurn = _convertSafe(bidId, _fromToken, bidPriceInMana);
556         } else {
557             // Transfer MANA to this contract
558             require(
559                 _fromToken.transferFrom(msg.sender, address(this), bidPriceInMana),
560                 "Insuficient balance or unauthorized amount (transferFrom failed)"
561             );
562         }
563 
564         // Process funds (burn or forward them)
565         _processFunds(bidId, _fromToken);
566 
567         // Assign LANDs to the beneficiary user
568         for (uint i = 0; i < _xs.length; i++) {
569             require(
570                 -150 <= _xs[i] && _xs[i] <= 150 && -150 <= _ys[i] && _ys[i] <= 150,
571                 "The coordinates should be inside bounds -150 & 150"
572             );
573         }
574         landRegistry.assignMultipleParcels(_xs, _ys, _beneficiary);
575 
576         emit BidSuccessful(
577             bidId,
578             _beneficiary,
579             _fromToken,
580             getCurrentPrice(),
581             manaAmountToBurn,
582             _xs,
583             _ys
584         );  
585 
586         // Update stats
587         _updateStats(_xs.length, manaAmountToBurn);        
588     }
589 
590     /** 
591     * @dev Validate bid function params
592     * @param _xs - uint256[] x values for the LANDs to bid
593     * @param _ys - uint256[] y values for the LANDs to bid
594     * @param _beneficiary - address beneficiary for the LANDs to bid
595     * @param _fromToken - token used to bid
596     */
597     function _validateBidParameters(
598         int[] _xs, 
599         int[] _ys, 
600         address _beneficiary, 
601         ERC20 _fromToken
602     ) internal view 
603     {
604         require(startTime <= block.timestamp, "The auction has not started");
605         require(
606             status == Status.created && 
607             block.timestamp.sub(startTime) <= duration, 
608             "The auction has finished"
609         );
610         require(tx.gasprice <= gasPriceLimit, "Gas price limit exceeded");
611         require(_beneficiary != address(0), "The beneficiary could not be the 0 address");
612         require(_xs.length > 0, "You should bid for at least one LAND");
613         require(_xs.length <= landsLimitPerBid, "LAND limit exceeded");
614         require(_xs.length == _ys.length, "X values length should be equal to Y values length");
615         require(tokensAllowed[address(_fromToken)].isAllowed, "Token not allowed");
616     }
617 
618     /**
619     * @dev Current LAND price. 
620     * Note that if the auction has not started returns the initial price and when
621     * the auction is finished return the endPrice
622     * @return uint256 current LAND price
623     */
624     function getCurrentPrice() public view returns (uint256) { 
625         // If the auction has not started returns initialPrice
626         if (startTime == 0 || startTime >= block.timestamp) {
627             return initialPrice;
628         }
629 
630         // If the auction has finished returns endPrice
631         uint256 timePassed = block.timestamp - startTime;
632         if (timePassed >= duration) {
633             return endPrice;
634         }
635 
636         return _getPrice(timePassed);
637     }
638 
639     /**
640     * @dev Convert allowed token to MANA and transfer the change in the original token
641     * Note that we will use the slippageRate cause it has a 3% buffer and a deposit of 5% to cover
642     * the conversion fee.
643     * @param _bidId - uint256 of the bid Id
644     * @param _fromToken - ERC20 token to be converted
645     * @param _bidPriceInMana - uint256 of the total amount in MANA
646     * @return uint256 of the total amount of MANA to burn
647     */
648     function _convertSafe(
649         uint256 _bidId,
650         ERC20 _fromToken,
651         uint256 _bidPriceInMana
652     ) internal returns (uint256 requiredManaAmountToBurn)
653     {
654         requiredManaAmountToBurn = _bidPriceInMana;
655         Token memory fromToken = tokensAllowed[address(_fromToken)];
656 
657         uint bidPriceInManaPlusSafetyMargin = _bidPriceInMana.mul(conversionFee).div(100);
658 
659         // Get rate
660         uint256 tokenRate = getRate(manaToken, _fromToken, bidPriceInManaPlusSafetyMargin);
661 
662         // Check if contract should burn or transfer some tokens
663         uint256 requiredTokenBalance = 0;
664         
665         if (fromToken.shouldBurnTokens || fromToken.shouldForwardTokens) {
666             requiredTokenBalance = _calculateRequiredTokenBalance(requiredManaAmountToBurn, tokenRate);
667             requiredManaAmountToBurn = _calculateRequiredManaAmount(_bidPriceInMana);
668         }
669 
670         // Calculate the amount of _fromToken to be converted
671         uint256 tokensToConvertPlusSafetyMargin = bidPriceInManaPlusSafetyMargin
672             .mul(tokenRate)
673             .div(10 ** 18);
674 
675         // Normalize to _fromToken decimals
676         if (MAX_DECIMALS > fromToken.decimals) {
677             requiredTokenBalance = _normalizeDecimals(
678                 fromToken.decimals, 
679                 requiredTokenBalance
680             );
681             tokensToConvertPlusSafetyMargin = _normalizeDecimals(
682                 fromToken.decimals,
683                 tokensToConvertPlusSafetyMargin
684             );
685         }
686 
687         // Retrieve tokens from the sender to this contract
688         require(
689             _fromToken.transferFrom(msg.sender, address(this), tokensToConvertPlusSafetyMargin),
690             "Transfering the totalPrice in token to LANDAuction contract failed"
691         );
692         
693         // Calculate the total tokens to convert
694         uint256 finalTokensToConvert = tokensToConvertPlusSafetyMargin.sub(requiredTokenBalance);
695 
696         // Approve amount of _fromToken owned by contract to be used by dex contract
697         require(_fromToken.approve(address(dex), finalTokensToConvert), "Error approve");
698 
699         // Convert _fromToken to MANA
700         uint256 change = dex.convert(
701                 _fromToken,
702                 manaToken,
703                 finalTokensToConvert,
704                 requiredManaAmountToBurn
705         );
706 
707        // Return change in _fromToken to sender
708         if (change > 0) {
709             // Return the change of src token
710             require(
711                 _fromToken.transfer(msg.sender, change),
712                 "Transfering the change to sender failed"
713             );
714         }
715 
716         // Remove approval of _fromToken owned by contract to be used by dex contract
717         require(_fromToken.approve(address(dex), 0), "Error remove approval");
718 
719         emit BidConversion(
720             _bidId,
721             address(_fromToken),
722             requiredManaAmountToBurn,
723             tokensToConvertPlusSafetyMargin.sub(change),
724             requiredTokenBalance
725         );
726     }
727 
728     /**
729     * @dev Get exchange rate
730     * @param _srcToken - IERC20 token
731     * @param _destToken - IERC20 token 
732     * @param _srcAmount - uint256 amount to be converted
733     * @return uint256 of the rate
734     */
735     function getRate(
736         IERC20 _srcToken, 
737         IERC20 _destToken, 
738         uint256 _srcAmount
739     ) public view returns (uint256 rate) 
740     {
741         (, rate) = dex.getExpectedRate(_srcToken, _destToken, _srcAmount);
742     }
743 
744     /** 
745     * @dev Calculate the amount of tokens to process
746     * @param _totalPrice - uint256 price to calculate percentage to process
747     * @param _tokenRate - rate to calculate the amount of tokens
748     * @return uint256 of the amount of tokens required
749     */
750     function _calculateRequiredTokenBalance(
751         uint256 _totalPrice,
752         uint256 _tokenRate
753     ) 
754     internal pure returns (uint256) 
755     {
756         return _totalPrice.mul(_tokenRate)
757             .div(10 ** 18)
758             .mul(PERCENTAGE_OF_TOKEN_TO_KEEP)
759             .div(100);
760     }
761 
762     /** 
763     * @dev Calculate the total price in MANA
764     * Note that PERCENTAGE_OF_TOKEN_TO_KEEP will be always less than 100
765     * @param _totalPrice - uint256 price to calculate percentage to keep
766     * @return uint256 of the new total price in MANA
767     */
768     function _calculateRequiredManaAmount(
769         uint256 _totalPrice
770     ) 
771     internal pure returns (uint256)
772     {
773         return _totalPrice.mul(100 - PERCENTAGE_OF_TOKEN_TO_KEEP).div(100);
774     }
775 
776     /**
777     * @dev Burn or forward the MANA and other tokens earned
778     * Note that as we will transfer or burn tokens from other contracts.
779     * We should burn MANA first to avoid a possible re-entrancy
780     * @param _bidId - uint256 of the bid Id
781     * @param _token - ERC20 token
782     */
783     function _processFunds(uint256 _bidId, ERC20 _token) internal {
784         // Burn MANA
785         _burnTokens(_bidId, manaToken);
786 
787         // Burn or forward token if it is not MANA
788         Token memory token = tokensAllowed[address(_token)];
789         if (_token != manaToken) {
790             if (token.shouldBurnTokens) {
791                 _burnTokens(_bidId, _token);
792             }
793             if (token.shouldForwardTokens) {
794                 _forwardTokens(_bidId, token.forwardTarget, _token);
795             }   
796         }
797     }
798 
799     /**
800     * @dev LAND price based on time
801     * Note that will select the function to calculate based on the time
802     * It should return endPrice if _time < duration
803     * @param _time - uint256 time passed before reach duration
804     * @return uint256 price for the given time
805     */
806     function _getPrice(uint256 _time) internal view returns (uint256) {
807         for (uint i = 0; i < curves.length; i++) {
808             Func memory func = curves[i];
809             if (_time < func.limit) {
810                 return func.base.sub(func.slope.mul(_time));
811             }
812         }
813         revert("Invalid time");
814     }
815 
816     /** 
817     * @dev Burn tokens
818     * @param _bidId - uint256 of the bid Id
819     * @param _token - ERC20 token
820     */
821     function _burnTokens(uint256 _bidId, ERC20 _token) private {
822         uint256 balance = _token.balanceOf(address(this));
823 
824         // Check if balance is valid
825         require(balance > 0, "Balance to burn should be > 0");
826         
827         _token.burn(balance);
828 
829         emit TokenBurned(_bidId, address(_token), balance);
830 
831         // Check if balance of the auction contract is empty
832         balance = _token.balanceOf(address(this));
833         require(balance == 0, "Burn token failed");
834     }
835 
836     /** 
837     * @dev Forward tokens
838     * @param _bidId - uint256 of the bid Id
839     * @param _address - address to send the tokens to
840     * @param _token - ERC20 token
841     */
842     function _forwardTokens(uint256 _bidId, address _address, ERC20 _token) private {
843         uint256 balance = _token.balanceOf(address(this));
844 
845         // Check if balance is valid
846         require(balance > 0, "Balance to burn should be > 0");
847         
848         _token.transfer(_address, balance);
849 
850         emit TokenTransferred(
851             _bidId, 
852             address(_token), 
853             _address,balance
854         );
855 
856         // Check if balance of the auction contract is empty
857         balance = _token.balanceOf(address(this));
858         require(balance == 0, "Transfer token failed");
859     }
860 
861     /**
862     * @dev Set conversion fee rate
863     * @param _fee - uint256 for the new conversion rate
864     */
865     function setConversionFee(uint256 _fee) external onlyOwner {
866         require(_fee < 200 && _fee >= 100, "Conversion fee should be >= 100 and < 200");
867         emit ConversionFeeChanged(msg.sender, conversionFee, _fee);
868         conversionFee = _fee;
869     }
870 
871     /**
872     * @dev Finish auction 
873     */
874     function finishAuction() public onlyOwner {
875         require(status != Status.finished, "The auction is finished");
876 
877         uint256 currentPrice = getCurrentPrice();
878 
879         status = Status.finished;
880         endTime = block.timestamp;
881 
882         emit AuctionFinished(msg.sender, block.timestamp, currentPrice);
883     }
884 
885     /**
886     * @dev Set LAND for the auction
887     * @param _landsLimitPerBid - uint256 LAND limit for a single id
888     */
889     function setLandsLimitPerBid(uint256 _landsLimitPerBid) public onlyOwner {
890         require(_landsLimitPerBid > 0, "The LAND limit should be greater than 0");
891         emit LandsLimitPerBidChanged(msg.sender, landsLimitPerBid, _landsLimitPerBid);
892         landsLimitPerBid = _landsLimitPerBid;
893     }
894 
895     /**
896     * @dev Set gas price limit for the auction
897     * @param _gasPriceLimit - uint256 gas price limit for a single bid
898     */
899     function setGasPriceLimit(uint256 _gasPriceLimit) public onlyOwner {
900         require(_gasPriceLimit > 0, "The gas price should be greater than 0");
901         emit GasPriceLimitChanged(msg.sender, gasPriceLimit, _gasPriceLimit);
902         gasPriceLimit = _gasPriceLimit;
903     }
904 
905     /**
906     * @dev Set dex to convert ERC20
907     * @param _dex - address of the token converter
908     */
909     function setDex(address _dex) public onlyOwner {
910         require(_dex != address(dex), "The dex is the current");
911         if (_dex != address(0)) {
912             require(_dex.isContract(), "The dex address must be a deployed contract");
913         }
914         emit DexChanged(msg.sender, dex, _dex);
915         dex = ITokenConverter(_dex);
916     }
917 
918     /**
919     * @dev Allow ERC20 to to be used for bidding
920     * @param _address - address of the ERC20 Token
921     * @param _decimals - uint256 of the number of decimals
922     * @param _shouldBurnTokens - boolean whether we should burn funds
923     * @param _shouldForwardTokens - boolean whether we should transferred funds
924     * @param _forwardTarget - address where the funds will be transferred
925     */
926     function allowToken(
927         address _address,
928         uint256 _decimals,
929         bool _shouldBurnTokens,
930         bool _shouldForwardTokens,
931         address _forwardTarget
932     ) 
933     public onlyOwner 
934     {
935         require(
936             _address.isContract(),
937             "Tokens allowed should be a deployed ERC20 contract"
938         );
939         require(
940             _decimals > 0 && _decimals <= MAX_DECIMALS,
941             "Decimals should be greather than 0 and less or equal to 18"
942         );
943         require(
944             !(_shouldBurnTokens && _shouldForwardTokens),
945             "The token should be either burned or transferred"
946         );
947         require(
948             !_shouldForwardTokens || 
949             (_shouldForwardTokens && _forwardTarget.isContract()),
950             "The token should be transferred to a deployed contract"
951         );
952         require(!tokensAllowed[_address].isAllowed, "The ERC20 token is already allowed");
953 
954         tokensAllowed[_address] = Token({
955             decimals: _decimals,
956             shouldBurnTokens: _shouldBurnTokens,
957             shouldForwardTokens: _shouldForwardTokens,
958             forwardTarget: _forwardTarget,
959             isAllowed: true
960         });
961 
962         emit TokenAllowed(
963             msg.sender, 
964             _address, 
965             _decimals,
966             _shouldBurnTokens,
967             _shouldForwardTokens,
968             _forwardTarget
969         );
970     }
971 
972     /**
973     * @dev Disable ERC20 to to be used for bidding
974     * @param _address - address of the ERC20 Token
975     */
976     function disableToken(address _address) public onlyOwner {
977         require(
978             tokensAllowed[_address].isAllowed,
979             "The ERC20 token is already disabled"
980         );
981         delete tokensAllowed[_address];
982         emit TokenDisabled(msg.sender, _address);
983     }
984 
985     /** 
986     * @dev Create a combined function.
987     * note that we will set N - 1 function combinations based on N points (x,y)
988     * @param _xPoints - uint256[] of x values
989     * @param _yPoints - uint256[] of y values
990     */
991     function _setCurve(uint256[] _xPoints, uint256[] _yPoints) internal {
992         uint256 pointsLength = _xPoints.length;
993         require(pointsLength == _yPoints.length, "Points should have the same length");
994         for (uint i = 0; i < pointsLength - 1; i++) {
995             uint256 x1 = _xPoints[i];
996             uint256 x2 = _xPoints[i + 1];
997             uint256 y1 = _yPoints[i];
998             uint256 y2 = _yPoints[i + 1];
999             require(x1 < x2, "X points should increase");
1000             require(y1 > y2, "Y points should decrease");
1001             (uint256 base, uint256 slope) = _getFunc(
1002                 x1, 
1003                 x2, 
1004                 y1, 
1005                 y2
1006             );
1007             curves.push(Func({
1008                 base: base,
1009                 slope: slope,
1010                 limit: x2
1011             }));
1012         }
1013 
1014         initialPrice = _yPoints[0];
1015         endPrice = _yPoints[pointsLength - 1];
1016     }
1017 
1018     /**
1019     * @dev Calculate base and slope for the given points
1020     * It is a linear function y = ax - b. But The slope should be negative.
1021     * As we want to avoid negative numbers in favor of using uints we use it as: y = b - ax
1022     * Based on two points (x1; x2) and (y1; y2)
1023     * base = (x2 * y1) - (x1 * y2) / x2 - x1
1024     * slope = (y1 - y2) / (x2 - x1) to avoid negative maths
1025     * @param _x1 - uint256 x1 value
1026     * @param _x2 - uint256 x2 value
1027     * @param _y1 - uint256 y1 value
1028     * @param _y2 - uint256 y2 value
1029     * @return uint256 for the base
1030     * @return uint256 for the slope
1031     */
1032     function _getFunc(
1033         uint256 _x1,
1034         uint256 _x2,
1035         uint256 _y1, 
1036         uint256 _y2
1037     ) internal pure returns (uint256 base, uint256 slope) 
1038     {
1039         base = ((_x2.mul(_y1)).sub(_x1.mul(_y2))).div(_x2.sub(_x1));
1040         slope = (_y1.sub(_y2)).div(_x2.sub(_x1));
1041     }
1042 
1043     /**
1044     * @dev Return bid id
1045     * @return uint256 of the bid id
1046     */
1047     function _getBidId() private view returns (uint256) {
1048         return totalBids;
1049     }
1050 
1051     /** 
1052     * @dev Normalize to _fromToken decimals
1053     * @param _decimals - uint256 of _fromToken decimals
1054     * @param _value - uint256 of the amount to normalize
1055     */
1056     function _normalizeDecimals(
1057         uint256 _decimals, 
1058         uint256 _value
1059     ) 
1060     internal pure returns (uint256 _result) 
1061     {
1062         _result = _value.div(10**MAX_DECIMALS.sub(_decimals));
1063     }
1064 
1065     /** 
1066     * @dev Update stats. It will update the following stats:
1067     * - totalBids
1068     * - totalLandsBidded
1069     * - totalManaBurned
1070     * @param _landsBidded - uint256 of the number of LAND bidded
1071     * @param _manaAmountBurned - uint256 of the amount of MANA burned
1072     */
1073     function _updateStats(uint256 _landsBidded, uint256 _manaAmountBurned) private {
1074         totalBids = totalBids.add(1);
1075         totalLandsBidded = totalLandsBidded.add(_landsBidded);
1076         totalManaBurned = totalManaBurned.add(_manaAmountBurned);
1077     }
1078 }