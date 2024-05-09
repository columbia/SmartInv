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
269 // File: contracts/libs/SafeTransfer.sol
270 
271 /**
272 * @dev Library to perform transfer for ERC20 tokens.
273 * Not all the tokens transfer method has a return value (bool) neither revert for insufficient funds or 
274 * unathorized _value
275 */
276 library SafeTransfer {
277     /**
278     * @dev Transfer token for a specified address
279     * @param _token erc20 The address of the ERC20 contract
280     * @param _to address The address which you want to transfer to
281     * @param _value uint256 the _value of tokens to be transferred
282     */
283     function safeTransfer(IERC20 _token, address _to, uint256 _value) internal returns (bool) {
284         uint256 prevBalance = _token.balanceOf(address(this));
285 
286         require(prevBalance >= _value, "Insufficient funds");
287 
288         _token.transfer(_to, _value);
289 
290         require(prevBalance - _value == _token.balanceOf(address(this)), "Transfer failed");
291 
292         return true;
293     }
294 
295     /**
296     * @dev Transfer tokens from one address to another
297     * @param _token erc20 The address of the ERC20 contract
298     * @param _from address The address which you want to send tokens from
299     * @param _to address The address which you want to transfer to
300     * @param _value uint256 the _value of tokens to be transferred
301     */
302     function safeTransferFrom(
303         IERC20 _token,
304         address _from,
305         address _to, 
306         uint256 _value
307     ) internal returns (bool) 
308     {
309         uint256 prevBalance = _token.balanceOf(_from);
310 
311         require(prevBalance >= _value, "Insufficient funds");
312         require(_token.allowance(_from, address(this)) >= _value, "Insufficient allowance");
313 
314         _token.transferFrom(_from, _to, _value);
315 
316         require(prevBalance - _value == _token.balanceOf(_from), "Transfer failed");
317 
318         return true;
319     }
320 }
321 
322 // File: contracts/dex/ITokenConverter.sol
323 
324 contract ITokenConverter {    
325     using SafeMath for uint256;
326 
327     /**
328     * @dev Makes a simple ERC20 -> ERC20 token trade
329     * @param _srcToken - IERC20 token
330     * @param _destToken - IERC20 token 
331     * @param _srcAmount - uint256 amount to be converted
332     * @param _destAmount - uint256 amount to get after conversion
333     * @return uint256 for the change. 0 if there is no change
334     */
335     function convert(
336         IERC20 _srcToken,
337         IERC20 _destToken,
338         uint256 _srcAmount,
339         uint256 _destAmount
340         ) external returns (uint256);
341 
342     /**
343     * @dev Get exchange rate and slippage rate. 
344     * Note that these returned values are in 18 decimals regardless of the destination token's decimals.
345     * @param _srcToken - IERC20 token
346     * @param _destToken - IERC20 token 
347     * @param _srcAmount - uint256 amount to be converted
348     * @return uint256 of the expected rate
349     * @return uint256 of the slippage rate
350     */
351     function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint256 _srcAmount) 
352         public view returns(uint256 expectedRate, uint256 slippageRate);
353 }
354 
355 // File: contracts/auction/LANDAuctionStorage.sol
356 
357 /**
358 * @title ERC20 Interface with burn
359 * @dev IERC20 imported in ItokenConverter.sol
360 */
361 contract ERC20 is IERC20 {
362     function burn(uint256 _value) public;
363 }
364 
365 
366 /**
367 * @title Interface for contracts conforming to ERC-721
368 */
369 contract LANDRegistry {
370     function assignMultipleParcels(int[] x, int[] y, address beneficiary) external;
371 }
372 
373 
374 contract LANDAuctionStorage {
375     uint256 constant public PERCENTAGE_OF_TOKEN_BALANCE = 5;
376     uint256 constant public MAX_DECIMALS = 18;
377 
378     enum Status { created, finished }
379 
380     struct Func {
381         uint256 slope;
382         uint256 base;
383         uint256 limit;
384     }
385 
386     struct Token {
387         uint256 decimals;
388         bool shouldBurnTokens;
389         bool shouldForwardTokens;
390         address forwardTarget;
391         bool isAllowed;
392     }
393 
394     uint256 public conversionFee = 105;
395     uint256 public totalBids = 0;
396     Status public status;
397     uint256 public gasPriceLimit;
398     uint256 public landsLimitPerBid;
399     ERC20 public manaToken;
400     LANDRegistry public landRegistry;
401     ITokenConverter public dex;
402     mapping (address => Token) public tokensAllowed;
403     uint256 public totalManaBurned = 0;
404     uint256 public totalLandsBidded = 0;
405     uint256 public startTime;
406     uint256 public endTime;
407 
408     Func[] internal curves;
409     uint256 internal initialPrice;
410     uint256 internal endPrice;
411     uint256 internal duration;
412 
413     event AuctionCreated(
414       address indexed _caller,
415       uint256 _startTime,
416       uint256 _duration,
417       uint256 _initialPrice,
418       uint256 _endPrice
419     );
420 
421     event BidConversion(
422       uint256 _bidId,
423       address indexed _token,
424       uint256 _requiredManaAmountToBurn,
425       uint256 _amountOfTokenConverted,
426       uint256 _requiredTokenBalance
427     );
428 
429     event BidSuccessful(
430       uint256 _bidId,
431       address indexed _beneficiary,
432       address indexed _token,
433       uint256 _pricePerLandInMana,
434       uint256 _manaAmountToBurn,
435       int[] _xs,
436       int[] _ys
437     );
438 
439     event AuctionFinished(
440       address indexed _caller,
441       uint256 _time,
442       uint256 _pricePerLandInMana
443     );
444 
445     event TokenBurned(
446       uint256 _bidId,
447       address indexed _token,
448       uint256 _total
449     );
450 
451     event TokenTransferred(
452       uint256 _bidId,
453       address indexed _token,
454       address indexed _to,
455       uint256 _total
456     );
457 
458     event LandsLimitPerBidChanged(
459       address indexed _caller,
460       uint256 _oldLandsLimitPerBid, 
461       uint256 _landsLimitPerBid
462     );
463 
464     event GasPriceLimitChanged(
465       address indexed _caller,
466       uint256 _oldGasPriceLimit,
467       uint256 _gasPriceLimit
468     );
469 
470     event DexChanged(
471       address indexed _caller,
472       address indexed _oldDex,
473       address indexed _dex
474     );
475 
476     event TokenAllowed(
477       address indexed _caller,
478       address indexed _address,
479       uint256 _decimals,
480       bool _shouldBurnTokens,
481       bool _shouldForwardTokens,
482       address indexed _forwardTarget
483     );
484 
485     event TokenDisabled(
486       address indexed _caller,
487       address indexed _address
488     );
489 
490     event ConversionFeeChanged(
491       address indexed _caller,
492       uint256 _oldConversionFee,
493       uint256 _conversionFee
494     );
495 }
496 
497 // File: contracts/auction/LANDAuction.sol
498 
499 contract LANDAuction is Ownable, LANDAuctionStorage {
500     using SafeMath for uint256;
501     using Address for address;
502     using SafeTransfer for ERC20;
503 
504     /**
505     * @dev Constructor of the contract.
506     * Note that the last value of _xPoints will be the total duration and
507     * the first value of _yPoints will be the initial price and the last value will be the endPrice
508     * @param _xPoints - uint256[] of seconds
509     * @param _yPoints - uint256[] of prices
510     * @param _startTime - uint256 timestamp in seconds when the auction will start
511     * @param _landsLimitPerBid - uint256 LAND limit for a single bid
512     * @param _gasPriceLimit - uint256 gas price limit for a single bid
513     * @param _manaToken - address of the MANA token
514     * @param _landRegistry - address of the LANDRegistry
515     * @param _dex - address of the Dex to convert ERC20 tokens allowed to MANA
516     */
517     constructor(
518         uint256[] _xPoints, 
519         uint256[] _yPoints, 
520         uint256 _startTime,
521         uint256 _landsLimitPerBid,
522         uint256 _gasPriceLimit,
523         ERC20 _manaToken,
524         LANDRegistry _landRegistry,
525         address _dex
526     ) public {
527         require(
528             PERCENTAGE_OF_TOKEN_BALANCE == 5, 
529             "Balance of tokens required should be equal to 5%"
530         );
531         // Initialize owneable
532         Ownable.initialize(msg.sender);
533 
534         // Schedule auction
535         require(_startTime > block.timestamp, "Started time should be after now");
536         startTime = _startTime;
537 
538         // Set LANDRegistry
539         require(
540             address(_landRegistry).isContract(),
541             "The LANDRegistry token address must be a deployed contract"
542         );
543         landRegistry = _landRegistry;
544 
545         setDex(_dex);
546 
547         // Set MANAToken
548         allowToken(
549             address(_manaToken), 
550             18,
551             true, 
552             false, 
553             address(0)
554         );
555         manaToken = _manaToken;
556 
557         // Set total duration of the auction
558         duration = _xPoints[_xPoints.length - 1];
559         require(duration > 1 days, "The duration should be greater than 1 day");
560 
561         // Set Curve
562         _setCurve(_xPoints, _yPoints);
563 
564         // Set limits
565         setLandsLimitPerBid(_landsLimitPerBid);
566         setGasPriceLimit(_gasPriceLimit);
567         
568         // Initialize status
569         status = Status.created;      
570 
571         emit AuctionCreated(
572             msg.sender,
573             startTime,
574             duration,
575             initialPrice, 
576             endPrice
577         );
578     }
579 
580     /**
581     * @dev Make a bid for LANDs
582     * @param _xs - uint256[] x values for the LANDs to bid
583     * @param _ys - uint256[] y values for the LANDs to bid
584     * @param _beneficiary - address beneficiary for the LANDs to bid
585     * @param _fromToken - token used to bid
586     */
587     function bid(
588         int[] _xs, 
589         int[] _ys, 
590         address _beneficiary, 
591         ERC20 _fromToken
592     )
593         external 
594     {
595         _validateBidParameters(
596             _xs, 
597             _ys, 
598             _beneficiary, 
599             _fromToken
600         );
601         
602         uint256 bidId = _getBidId();
603         uint256 bidPriceInMana = _xs.length.mul(getCurrentPrice());
604         uint256 manaAmountToBurn = bidPriceInMana;
605 
606         if (address(_fromToken) != address(manaToken)) {
607             require(
608                 address(dex).isContract(), 
609                 "Paying with other tokens has been disabled"
610             );
611             // Convert from the other token to MANA. The amount to be burned might be smaller
612             // because 5% will be burned or forwarded without converting it to MANA.
613             manaAmountToBurn = _convertSafe(bidId, _fromToken, bidPriceInMana);
614         } else {
615             // Transfer MANA to this contract
616             require(
617                 _fromToken.safeTransferFrom(msg.sender, address(this), bidPriceInMana),
618                 "Insuficient balance or unauthorized amount (transferFrom failed)"
619             );
620         }
621 
622         // Process funds (burn or forward them)
623         _processFunds(bidId, _fromToken);
624 
625         // Assign LANDs to the beneficiary user
626         landRegistry.assignMultipleParcels(_xs, _ys, _beneficiary);
627 
628         emit BidSuccessful(
629             bidId,
630             _beneficiary,
631             _fromToken,
632             getCurrentPrice(),
633             manaAmountToBurn,
634             _xs,
635             _ys
636         );  
637 
638         // Update stats
639         _updateStats(_xs.length, manaAmountToBurn);        
640     }
641 
642     /** 
643     * @dev Validate bid function params
644     * @param _xs - int[] x values for the LANDs to bid
645     * @param _ys - int[] y values for the LANDs to bid
646     * @param _beneficiary - address beneficiary for the LANDs to bid
647     * @param _fromToken - token used to bid
648     */
649     function _validateBidParameters(
650         int[] _xs, 
651         int[] _ys, 
652         address _beneficiary, 
653         ERC20 _fromToken
654     ) internal view 
655     {
656         require(startTime <= block.timestamp, "The auction has not started");
657         require(
658             status == Status.created && 
659             block.timestamp.sub(startTime) <= duration, 
660             "The auction has finished"
661         );
662         require(tx.gasprice <= gasPriceLimit, "Gas price limit exceeded");
663         require(_beneficiary != address(0), "The beneficiary could not be the 0 address");
664         require(_xs.length > 0, "You should bid for at least one LAND");
665         require(_xs.length <= landsLimitPerBid, "LAND limit exceeded");
666         require(_xs.length == _ys.length, "X values length should be equal to Y values length");
667         require(tokensAllowed[address(_fromToken)].isAllowed, "Token not allowed");
668         for (uint256 i = 0; i < _xs.length; i++) {
669             require(
670                 -150 <= _xs[i] && _xs[i] <= 150 && -150 <= _ys[i] && _ys[i] <= 150,
671                 "The coordinates should be inside bounds -150 & 150"
672             );
673         }
674     }
675 
676     /**
677     * @dev Current LAND price. 
678     * Note that if the auction has not started returns the initial price and when
679     * the auction is finished return the endPrice
680     * @return uint256 current LAND price
681     */
682     function getCurrentPrice() public view returns (uint256) { 
683         // If the auction has not started returns initialPrice
684         if (startTime == 0 || startTime >= block.timestamp) {
685             return initialPrice;
686         }
687 
688         // If the auction has finished returns endPrice
689         uint256 timePassed = block.timestamp - startTime;
690         if (timePassed >= duration) {
691             return endPrice;
692         }
693 
694         return _getPrice(timePassed);
695     }
696 
697     /**
698     * @dev Convert allowed token to MANA and transfer the change in the original token
699     * Note that we will use the slippageRate cause it has a 3% buffer and a deposit of 5% to cover
700     * the conversion fee.
701     * @param _bidId - uint256 of the bid Id
702     * @param _fromToken - ERC20 token to be converted
703     * @param _bidPriceInMana - uint256 of the total amount in MANA
704     * @return uint256 of the total amount of MANA to burn
705     */
706     function _convertSafe(
707         uint256 _bidId,
708         ERC20 _fromToken,
709         uint256 _bidPriceInMana
710     ) internal returns (uint256 requiredManaAmountToBurn)
711     {
712         requiredManaAmountToBurn = _bidPriceInMana;
713         Token memory fromToken = tokensAllowed[address(_fromToken)];
714 
715         uint256 bidPriceInManaPlusSafetyMargin = _bidPriceInMana.mul(conversionFee).div(100);
716 
717         // Get rate
718         uint256 tokenRate = getRate(manaToken, _fromToken, bidPriceInManaPlusSafetyMargin);
719 
720         // Check if contract should burn or transfer some tokens
721         uint256 requiredTokenBalance = 0;
722         
723         if (fromToken.shouldBurnTokens || fromToken.shouldForwardTokens) {
724             requiredTokenBalance = _calculateRequiredTokenBalance(requiredManaAmountToBurn, tokenRate);
725             requiredManaAmountToBurn = _calculateRequiredManaAmount(_bidPriceInMana);
726         }
727 
728         // Calculate the amount of _fromToken to be converted
729         uint256 tokensToConvertPlusSafetyMargin = bidPriceInManaPlusSafetyMargin
730             .mul(tokenRate)
731             .div(10 ** 18);
732 
733         // Normalize to _fromToken decimals
734         if (MAX_DECIMALS > fromToken.decimals) {
735             requiredTokenBalance = _normalizeDecimals(
736                 fromToken.decimals, 
737                 requiredTokenBalance
738             );
739             tokensToConvertPlusSafetyMargin = _normalizeDecimals(
740                 fromToken.decimals,
741                 tokensToConvertPlusSafetyMargin
742             );
743         }
744 
745         // Retrieve tokens from the sender to this contract
746         require(
747             _fromToken.safeTransferFrom(msg.sender, address(this), tokensToConvertPlusSafetyMargin),
748             "Transfering the totalPrice in token to LANDAuction contract failed"
749         );
750         
751         // Calculate the total tokens to convert
752         uint256 finalTokensToConvert = tokensToConvertPlusSafetyMargin.sub(requiredTokenBalance);
753 
754         // Approve amount of _fromToken owned by contract to be used by dex contract
755         require(_fromToken.approve(address(dex), finalTokensToConvert), "Error approve");
756 
757         // Convert _fromToken to MANA
758         uint256 change = dex.convert(
759                 _fromToken,
760                 manaToken,
761                 finalTokensToConvert,
762                 requiredManaAmountToBurn
763         );
764 
765        // Return change in _fromToken to sender
766         if (change > 0) {
767             // Return the change of src token
768             require(
769                 _fromToken.safeTransfer(msg.sender, change),
770                 "Transfering the change to sender failed"
771             );
772         }
773 
774         // Remove approval of _fromToken owned by contract to be used by dex contract
775         require(_fromToken.approve(address(dex), 0), "Error remove approval");
776 
777         emit BidConversion(
778             _bidId,
779             address(_fromToken),
780             requiredManaAmountToBurn,
781             tokensToConvertPlusSafetyMargin.sub(change),
782             requiredTokenBalance
783         );
784     }
785 
786     /**
787     * @dev Get exchange rate
788     * @param _srcToken - IERC20 token
789     * @param _destToken - IERC20 token 
790     * @param _srcAmount - uint256 amount to be converted
791     * @return uint256 of the rate
792     */
793     function getRate(
794         IERC20 _srcToken, 
795         IERC20 _destToken, 
796         uint256 _srcAmount
797     ) public view returns (uint256 rate) 
798     {
799         (rate,) = dex.getExpectedRate(_srcToken, _destToken, _srcAmount);
800     }
801 
802     /** 
803     * @dev Calculate the amount of tokens to process
804     * @param _totalPrice - uint256 price to calculate percentage to process
805     * @param _tokenRate - rate to calculate the amount of tokens
806     * @return uint256 of the amount of tokens required
807     */
808     function _calculateRequiredTokenBalance(
809         uint256 _totalPrice,
810         uint256 _tokenRate
811     ) 
812     internal pure returns (uint256) 
813     {
814         return _totalPrice.mul(_tokenRate)
815             .div(10 ** 18)
816             .mul(PERCENTAGE_OF_TOKEN_BALANCE)
817             .div(100);
818     }
819 
820     /** 
821     * @dev Calculate the total price in MANA
822     * Note that PERCENTAGE_OF_TOKEN_BALANCE will be always less than 100
823     * @param _totalPrice - uint256 price to calculate percentage to keep
824     * @return uint256 of the new total price in MANA
825     */
826     function _calculateRequiredManaAmount(
827         uint256 _totalPrice
828     ) 
829     internal pure returns (uint256)
830     {
831         return _totalPrice.mul(100 - PERCENTAGE_OF_TOKEN_BALANCE).div(100);
832     }
833 
834     /**
835     * @dev Burn or forward the MANA and other tokens earned
836     * Note that as we will transfer or burn tokens from other contracts.
837     * We should burn MANA first to avoid a possible re-entrancy
838     * @param _bidId - uint256 of the bid Id
839     * @param _token - ERC20 token
840     */
841     function _processFunds(uint256 _bidId, ERC20 _token) internal {
842         // Burn MANA
843         _burnTokens(_bidId, manaToken);
844 
845         // Burn or forward token if it is not MANA
846         Token memory token = tokensAllowed[address(_token)];
847         if (_token != manaToken) {
848             if (token.shouldBurnTokens) {
849                 _burnTokens(_bidId, _token);
850             }
851             if (token.shouldForwardTokens) {
852                 _forwardTokens(_bidId, token.forwardTarget, _token);
853             }   
854         }
855     }
856 
857     /**
858     * @dev LAND price based on time
859     * Note that will select the function to calculate based on the time
860     * It should return endPrice if _time < duration
861     * @param _time - uint256 time passed before reach duration
862     * @return uint256 price for the given time
863     */
864     function _getPrice(uint256 _time) internal view returns (uint256) {
865         for (uint256 i = 0; i < curves.length; i++) {
866             Func storage func = curves[i];
867             if (_time < func.limit) {
868                 return func.base.sub(func.slope.mul(_time));
869             }
870         }
871         revert("Invalid time");
872     }
873 
874     /** 
875     * @dev Burn tokens
876     * @param _bidId - uint256 of the bid Id
877     * @param _token - ERC20 token
878     */
879     function _burnTokens(uint256 _bidId, ERC20 _token) private {
880         uint256 balance = _token.balanceOf(address(this));
881 
882         // Check if balance is valid
883         require(balance > 0, "Balance to burn should be > 0");
884         
885         _token.burn(balance);
886 
887         emit TokenBurned(_bidId, address(_token), balance);
888 
889         // Check if balance of the auction contract is empty
890         balance = _token.balanceOf(address(this));
891         require(balance == 0, "Burn token failed");
892     }
893 
894     /** 
895     * @dev Forward tokens
896     * @param _bidId - uint256 of the bid Id
897     * @param _address - address to send the tokens to
898     * @param _token - ERC20 token
899     */
900     function _forwardTokens(uint256 _bidId, address _address, ERC20 _token) private {
901         uint256 balance = _token.balanceOf(address(this));
902 
903         // Check if balance is valid
904         require(balance > 0, "Balance to burn should be > 0");
905         
906         _token.safeTransfer(_address, balance);
907 
908         emit TokenTransferred(
909             _bidId, 
910             address(_token), 
911             _address,balance
912         );
913 
914         // Check if balance of the auction contract is empty
915         balance = _token.balanceOf(address(this));
916         require(balance == 0, "Transfer token failed");
917     }
918 
919     /**
920     * @dev Set conversion fee rate
921     * @param _fee - uint256 for the new conversion rate
922     */
923     function setConversionFee(uint256 _fee) external onlyOwner {
924         require(_fee < 200 && _fee >= 100, "Conversion fee should be >= 100 and < 200");
925         emit ConversionFeeChanged(msg.sender, conversionFee, _fee);
926         conversionFee = _fee;
927     }
928 
929     /**
930     * @dev Finish auction 
931     */
932     function finishAuction() public onlyOwner {
933         require(status != Status.finished, "The auction is finished");
934 
935         uint256 currentPrice = getCurrentPrice();
936 
937         status = Status.finished;
938         endTime = block.timestamp;
939 
940         emit AuctionFinished(msg.sender, block.timestamp, currentPrice);
941     }
942 
943     /**
944     * @dev Set LAND for the auction
945     * @param _landsLimitPerBid - uint256 LAND limit for a single id
946     */
947     function setLandsLimitPerBid(uint256 _landsLimitPerBid) public onlyOwner {
948         require(_landsLimitPerBid > 0, "The LAND limit should be greater than 0");
949         emit LandsLimitPerBidChanged(msg.sender, landsLimitPerBid, _landsLimitPerBid);
950         landsLimitPerBid = _landsLimitPerBid;
951     }
952 
953     /**
954     * @dev Set gas price limit for the auction
955     * @param _gasPriceLimit - uint256 gas price limit for a single bid
956     */
957     function setGasPriceLimit(uint256 _gasPriceLimit) public onlyOwner {
958         require(_gasPriceLimit > 0, "The gas price should be greater than 0");
959         emit GasPriceLimitChanged(msg.sender, gasPriceLimit, _gasPriceLimit);
960         gasPriceLimit = _gasPriceLimit;
961     }
962 
963     /**
964     * @dev Set dex to convert ERC20
965     * @param _dex - address of the token converter
966     */
967     function setDex(address _dex) public onlyOwner {
968         require(_dex != address(dex), "The dex is the current");
969         if (_dex != address(0)) {
970             require(_dex.isContract(), "The dex address must be a deployed contract");
971         }
972         emit DexChanged(msg.sender, dex, _dex);
973         dex = ITokenConverter(_dex);
974     }
975 
976     /**
977     * @dev Allow ERC20 to to be used for bidding
978     * Note that if _shouldBurnTokens and _shouldForwardTokens are false, we 
979     * will convert the total amount of the ERC20 to MANA
980     * @param _address - address of the ERC20 Token
981     * @param _decimals - uint256 of the number of decimals
982     * @param _shouldBurnTokens - boolean whether we should burn funds
983     * @param _shouldForwardTokens - boolean whether we should transferred funds
984     * @param _forwardTarget - address where the funds will be transferred
985     */
986     function allowToken(
987         address _address,
988         uint256 _decimals,
989         bool _shouldBurnTokens,
990         bool _shouldForwardTokens,
991         address _forwardTarget
992     ) 
993     public onlyOwner 
994     {
995         require(
996             _address.isContract(),
997             "Tokens allowed should be a deployed ERC20 contract"
998         );
999         require(
1000             _decimals > 0 && _decimals <= MAX_DECIMALS,
1001             "Decimals should be greather than 0 and less or equal to 18"
1002         );
1003         require(
1004             !(_shouldBurnTokens && _shouldForwardTokens),
1005             "The token should be either burned or transferred"
1006         );
1007         require(
1008             !_shouldForwardTokens || 
1009             (_shouldForwardTokens && _forwardTarget.isContract()),
1010             "The token should be transferred to a deployed contract"
1011         );
1012 
1013         require(
1014             _forwardTarget != address(this) && _forwardTarget != _address, 
1015             "The forward target should be different from  this contract and the erc20 token"
1016         );
1017         
1018         require(!tokensAllowed[_address].isAllowed, "The ERC20 token is already allowed");
1019 
1020         tokensAllowed[_address] = Token({
1021             decimals: _decimals,
1022             shouldBurnTokens: _shouldBurnTokens,
1023             shouldForwardTokens: _shouldForwardTokens,
1024             forwardTarget: _forwardTarget,
1025             isAllowed: true
1026         });
1027 
1028         emit TokenAllowed(
1029             msg.sender, 
1030             _address, 
1031             _decimals,
1032             _shouldBurnTokens,
1033             _shouldForwardTokens,
1034             _forwardTarget
1035         );
1036     }
1037 
1038     /**
1039     * @dev Disable ERC20 to to be used for bidding
1040     * @param _address - address of the ERC20 Token
1041     */
1042     function disableToken(address _address) public onlyOwner {
1043         require(
1044             tokensAllowed[_address].isAllowed,
1045             "The ERC20 token is already disabled"
1046         );
1047         delete tokensAllowed[_address];
1048         emit TokenDisabled(msg.sender, _address);
1049     }
1050 
1051     /** 
1052     * @dev Create a combined function.
1053     * note that we will set N - 1 function combinations based on N points (x,y)
1054     * @param _xPoints - uint256[] of x values
1055     * @param _yPoints - uint256[] of y values
1056     */
1057     function _setCurve(uint256[] _xPoints, uint256[] _yPoints) internal {
1058         uint256 pointsLength = _xPoints.length;
1059         require(pointsLength == _yPoints.length, "Points should have the same length");
1060         for (uint256 i = 0; i < pointsLength - 1; i++) {
1061             uint256 x1 = _xPoints[i];
1062             uint256 x2 = _xPoints[i + 1];
1063             uint256 y1 = _yPoints[i];
1064             uint256 y2 = _yPoints[i + 1];
1065             require(x1 < x2, "X points should increase");
1066             require(y1 > y2, "Y points should decrease");
1067             (uint256 base, uint256 slope) = _getFunc(
1068                 x1, 
1069                 x2, 
1070                 y1, 
1071                 y2
1072             );
1073             curves.push(Func({
1074                 base: base,
1075                 slope: slope,
1076                 limit: x2
1077             }));
1078         }
1079 
1080         initialPrice = _yPoints[0];
1081         endPrice = _yPoints[pointsLength - 1];
1082     }
1083 
1084     /**
1085     * @dev Calculate base and slope for the given points
1086     * It is a linear function y = ax - b. But The slope should be negative.
1087     * As we want to avoid negative numbers in favor of using uints we use it as: y = b - ax
1088     * Based on two points (x1; x2) and (y1; y2)
1089     * base = (x2 * y1) - (x1 * y2) / (x2 - x1)
1090     * slope = (y1 - y2) / (x2 - x1) to avoid negative maths
1091     * @param _x1 - uint256 x1 value
1092     * @param _x2 - uint256 x2 value
1093     * @param _y1 - uint256 y1 value
1094     * @param _y2 - uint256 y2 value
1095     * @return uint256 for the base
1096     * @return uint256 for the slope
1097     */
1098     function _getFunc(
1099         uint256 _x1,
1100         uint256 _x2,
1101         uint256 _y1, 
1102         uint256 _y2
1103     ) internal pure returns (uint256 base, uint256 slope) 
1104     {
1105         base = ((_x2.mul(_y1)).sub(_x1.mul(_y2))).div(_x2.sub(_x1));
1106         slope = (_y1.sub(_y2)).div(_x2.sub(_x1));
1107     }
1108 
1109     /**
1110     * @dev Return bid id
1111     * @return uint256 of the bid id
1112     */
1113     function _getBidId() private view returns (uint256) {
1114         return totalBids;
1115     }
1116 
1117     /** 
1118     * @dev Normalize to _fromToken decimals
1119     * @param _decimals - uint256 of _fromToken decimals
1120     * @param _value - uint256 of the amount to normalize
1121     */
1122     function _normalizeDecimals(
1123         uint256 _decimals, 
1124         uint256 _value
1125     ) 
1126     internal pure returns (uint256 _result) 
1127     {
1128         _result = _value.div(10**MAX_DECIMALS.sub(_decimals));
1129     }
1130 
1131     /** 
1132     * @dev Update stats. It will update the following stats:
1133     * - totalBids
1134     * - totalLandsBidded
1135     * - totalManaBurned
1136     * @param _landsBidded - uint256 of the number of LAND bidded
1137     * @param _manaAmountBurned - uint256 of the amount of MANA burned
1138     */
1139     function _updateStats(uint256 _landsBidded, uint256 _manaAmountBurned) private {
1140         totalBids = totalBids.add(1);
1141         totalLandsBidded = totalLandsBidded.add(_landsBidded);
1142         totalManaBurned = totalManaBurned.add(_manaAmountBurned);
1143     }
1144 }