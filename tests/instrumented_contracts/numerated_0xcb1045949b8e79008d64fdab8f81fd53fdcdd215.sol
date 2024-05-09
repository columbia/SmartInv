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
323         _token.transferFrom(_from, _to, _value);
324 
325         require(prevBalance - _value == _token.balanceOf(_from), "Transfer failed");
326 
327         return true;
328     }
329 
330    /**
331    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
332    *
333    * Beware that changing an allowance with this method brings the risk that someone may use both the old
334    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
335    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
336    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
337    * 
338    * @param _token erc20 The address of the ERC20 contract
339    * @param _spender The address which will spend the funds.
340    * @param _value The amount of tokens to be spent.
341    */
342     function safeApprove(IERC20 _token, address _spender, uint256 _value) internal returns (bool) {
343         bool success = address(_token).call(abi.encodeWithSelector(
344             _token.approve.selector,
345             _spender,
346             _value
347         )); 
348 
349         if (!success) {
350             return false;
351         }
352 
353         require(_token.allowance(address(this), _spender) == _value, "Approve failed");
354 
355         return true;
356     }
357 
358    /** 
359    * @dev Clear approval
360    * Note that if 0 is not a valid value it will be set to 1.
361    * @param _token erc20 The address of the ERC20 contract
362    * @param _spender The address which will spend the funds.
363    */
364     function clearApprove(IERC20 _token, address _spender) internal returns (bool) {
365         bool success = safeApprove(_token, _spender, 0);
366 
367         if (!success) {
368             return safeApprove(_token, _spender, 1);
369         }
370 
371         return true;
372     }
373 }
374 
375 // File: contracts/dex/ITokenConverter.sol
376 
377 contract ITokenConverter {    
378     using SafeMath for uint256;
379 
380     /**
381     * @dev Makes a simple ERC20 -> ERC20 token trade
382     * @param _srcToken - IERC20 token
383     * @param _destToken - IERC20 token 
384     * @param _srcAmount - uint256 amount to be converted
385     * @param _destAmount - uint256 amount to get after conversion
386     * @return uint256 for the change. 0 if there is no change
387     */
388     function convert(
389         IERC20 _srcToken,
390         IERC20 _destToken,
391         uint256 _srcAmount,
392         uint256 _destAmount
393         ) external returns (uint256);
394 
395     /**
396     * @dev Get exchange rate and slippage rate. 
397     * Note that these returned values are in 18 decimals regardless of the destination token's decimals.
398     * @param _srcToken - IERC20 token
399     * @param _destToken - IERC20 token 
400     * @param _srcAmount - uint256 amount to be converted
401     * @return uint256 of the expected rate
402     * @return uint256 of the slippage rate
403     */
404     function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint256 _srcAmount) 
405         public view returns(uint256 expectedRate, uint256 slippageRate);
406 }
407 
408 // File: contracts/auction/LANDAuctionStorage.sol
409 
410 /**
411 * @title ERC20 Interface with burn
412 * @dev IERC20 imported in ItokenConverter.sol
413 */
414 contract ERC20 is IERC20 {
415     function burn(uint256 _value) public;
416 }
417 
418 
419 /**
420 * @title Interface for contracts conforming to ERC-721
421 */
422 contract LANDRegistry {
423     function assignMultipleParcels(int[] x, int[] y, address beneficiary) external;
424 }
425 
426 
427 contract LANDAuctionStorage {
428     uint256 constant public PERCENTAGE_OF_TOKEN_BALANCE = 5;
429     uint256 constant public MAX_DECIMALS = 18;
430 
431     enum Status { created, finished }
432 
433     struct Func {
434         uint256 slope;
435         uint256 base;
436         uint256 limit;
437     }
438 
439     struct Token {
440         uint256 decimals;
441         bool shouldBurnTokens;
442         bool shouldForwardTokens;
443         address forwardTarget;
444         bool isAllowed;
445     }
446 
447     uint256 public conversionFee = 105;
448     uint256 public totalBids = 0;
449     Status public status;
450     uint256 public gasPriceLimit;
451     uint256 public landsLimitPerBid;
452     ERC20 public manaToken;
453     LANDRegistry public landRegistry;
454     ITokenConverter public dex;
455     mapping (address => Token) public tokensAllowed;
456     uint256 public totalManaBurned = 0;
457     uint256 public totalLandsBidded = 0;
458     uint256 public startTime;
459     uint256 public endTime;
460 
461     Func[] internal curves;
462     uint256 internal initialPrice;
463     uint256 internal endPrice;
464     uint256 internal duration;
465 
466     event AuctionCreated(
467       address indexed _caller,
468       uint256 _startTime,
469       uint256 _duration,
470       uint256 _initialPrice,
471       uint256 _endPrice
472     );
473 
474     event BidConversion(
475       uint256 _bidId,
476       address indexed _token,
477       uint256 _requiredManaAmountToBurn,
478       uint256 _amountOfTokenConverted,
479       uint256 _requiredTokenBalance
480     );
481 
482     event BidSuccessful(
483       uint256 _bidId,
484       address indexed _beneficiary,
485       address indexed _token,
486       uint256 _pricePerLandInMana,
487       uint256 _manaAmountToBurn,
488       int[] _xs,
489       int[] _ys
490     );
491 
492     event AuctionFinished(
493       address indexed _caller,
494       uint256 _time,
495       uint256 _pricePerLandInMana
496     );
497 
498     event TokenBurned(
499       uint256 _bidId,
500       address indexed _token,
501       uint256 _total
502     );
503 
504     event TokenTransferred(
505       uint256 _bidId,
506       address indexed _token,
507       address indexed _to,
508       uint256 _total
509     );
510 
511     event LandsLimitPerBidChanged(
512       address indexed _caller,
513       uint256 _oldLandsLimitPerBid, 
514       uint256 _landsLimitPerBid
515     );
516 
517     event GasPriceLimitChanged(
518       address indexed _caller,
519       uint256 _oldGasPriceLimit,
520       uint256 _gasPriceLimit
521     );
522 
523     event DexChanged(
524       address indexed _caller,
525       address indexed _oldDex,
526       address indexed _dex
527     );
528 
529     event TokenAllowed(
530       address indexed _caller,
531       address indexed _address,
532       uint256 _decimals,
533       bool _shouldBurnTokens,
534       bool _shouldForwardTokens,
535       address indexed _forwardTarget
536     );
537 
538     event TokenDisabled(
539       address indexed _caller,
540       address indexed _address
541     );
542 
543     event ConversionFeeChanged(
544       address indexed _caller,
545       uint256 _oldConversionFee,
546       uint256 _conversionFee
547     );
548 }
549 
550 // File: contracts/auction/LANDAuction.sol
551 
552 contract LANDAuction is Ownable, LANDAuctionStorage {
553     using SafeMath for uint256;
554     using Address for address;
555     using SafeERC20 for ERC20;
556 
557     /**
558     * @dev Constructor of the contract.
559     * Note that the last value of _xPoints will be the total duration and
560     * the first value of _yPoints will be the initial price and the last value will be the endPrice
561     * @param _xPoints - uint256[] of seconds
562     * @param _yPoints - uint256[] of prices
563     * @param _startTime - uint256 timestamp in seconds when the auction will start
564     * @param _landsLimitPerBid - uint256 LAND limit for a single bid
565     * @param _gasPriceLimit - uint256 gas price limit for a single bid
566     * @param _manaToken - address of the MANA token
567     * @param _landRegistry - address of the LANDRegistry
568     * @param _dex - address of the Dex to convert ERC20 tokens allowed to MANA
569     */
570     constructor(
571         uint256[] _xPoints, 
572         uint256[] _yPoints, 
573         uint256 _startTime,
574         uint256 _landsLimitPerBid,
575         uint256 _gasPriceLimit,
576         ERC20 _manaToken,
577         LANDRegistry _landRegistry,
578         address _dex
579     ) public {
580         require(
581             PERCENTAGE_OF_TOKEN_BALANCE == 5, 
582             "Balance of tokens required should be equal to 5%"
583         );
584         // Initialize owneable
585         Ownable.initialize(msg.sender);
586 
587         // Schedule auction
588         require(_startTime > block.timestamp, "Started time should be after now");
589         startTime = _startTime;
590 
591         // Set LANDRegistry
592         require(
593             address(_landRegistry).isContract(),
594             "The LANDRegistry token address must be a deployed contract"
595         );
596         landRegistry = _landRegistry;
597 
598         setDex(_dex);
599 
600         // Set MANAToken
601         allowToken(
602             address(_manaToken), 
603             18,
604             true, 
605             false, 
606             address(0)
607         );
608         manaToken = _manaToken;
609 
610         // Set total duration of the auction
611         duration = _xPoints[_xPoints.length - 1];
612         require(duration > 1 days, "The duration should be greater than 1 day");
613 
614         // Set Curve
615         _setCurve(_xPoints, _yPoints);
616 
617         // Set limits
618         setLandsLimitPerBid(_landsLimitPerBid);
619         setGasPriceLimit(_gasPriceLimit);
620         
621         // Initialize status
622         status = Status.created;      
623 
624         emit AuctionCreated(
625             msg.sender,
626             startTime,
627             duration,
628             initialPrice, 
629             endPrice
630         );
631     }
632 
633     /**
634     * @dev Make a bid for LANDs
635     * @param _xs - uint256[] x values for the LANDs to bid
636     * @param _ys - uint256[] y values for the LANDs to bid
637     * @param _beneficiary - address beneficiary for the LANDs to bid
638     * @param _fromToken - token used to bid
639     */
640     function bid(
641         int[] _xs, 
642         int[] _ys, 
643         address _beneficiary, 
644         ERC20 _fromToken
645     )
646         external 
647     {
648         _validateBidParameters(
649             _xs, 
650             _ys, 
651             _beneficiary, 
652             _fromToken
653         );
654         
655         uint256 bidId = _getBidId();
656         uint256 bidPriceInMana = _xs.length.mul(getCurrentPrice());
657         uint256 manaAmountToBurn = bidPriceInMana;
658 
659         if (address(_fromToken) != address(manaToken)) {
660             require(
661                 address(dex).isContract(), 
662                 "Paying with other tokens has been disabled"
663             );
664             // Convert from the other token to MANA. The amount to be burned might be smaller
665             // because 5% will be burned or forwarded without converting it to MANA.
666             manaAmountToBurn = _convertSafe(bidId, _fromToken, bidPriceInMana);
667         } else {
668             // Transfer MANA to this contract
669             require(
670                 _fromToken.safeTransferFrom(msg.sender, address(this), bidPriceInMana),
671                 "Insuficient balance or unauthorized amount (transferFrom failed)"
672             );
673         }
674 
675         // Process funds (burn or forward them)
676         _processFunds(bidId, _fromToken);
677 
678         // Assign LANDs to the beneficiary user
679         landRegistry.assignMultipleParcels(_xs, _ys, _beneficiary);
680 
681         emit BidSuccessful(
682             bidId,
683             _beneficiary,
684             _fromToken,
685             getCurrentPrice(),
686             manaAmountToBurn,
687             _xs,
688             _ys
689         );  
690 
691         // Update stats
692         _updateStats(_xs.length, manaAmountToBurn);        
693     }
694 
695     /** 
696     * @dev Validate bid function params
697     * @param _xs - int[] x values for the LANDs to bid
698     * @param _ys - int[] y values for the LANDs to bid
699     * @param _beneficiary - address beneficiary for the LANDs to bid
700     * @param _fromToken - token used to bid
701     */
702     function _validateBidParameters(
703         int[] _xs, 
704         int[] _ys, 
705         address _beneficiary, 
706         ERC20 _fromToken
707     ) internal view 
708     {
709         require(startTime <= block.timestamp, "The auction has not started");
710         require(
711             status == Status.created && 
712             block.timestamp.sub(startTime) <= duration, 
713             "The auction has finished"
714         );
715         require(tx.gasprice <= gasPriceLimit, "Gas price limit exceeded");
716         require(_beneficiary != address(0), "The beneficiary could not be the 0 address");
717         require(_xs.length > 0, "You should bid for at least one LAND");
718         require(_xs.length <= landsLimitPerBid, "LAND limit exceeded");
719         require(_xs.length == _ys.length, "X values length should be equal to Y values length");
720         require(tokensAllowed[address(_fromToken)].isAllowed, "Token not allowed");
721         for (uint256 i = 0; i < _xs.length; i++) {
722             require(
723                 -150 <= _xs[i] && _xs[i] <= 150 && -150 <= _ys[i] && _ys[i] <= 150,
724                 "The coordinates should be inside bounds -150 & 150"
725             );
726         }
727     }
728 
729     /**
730     * @dev Current LAND price. 
731     * Note that if the auction has not started returns the initial price and when
732     * the auction is finished return the endPrice
733     * @return uint256 current LAND price
734     */
735     function getCurrentPrice() public view returns (uint256) { 
736         // If the auction has not started returns initialPrice
737         if (startTime == 0 || startTime >= block.timestamp) {
738             return initialPrice;
739         }
740 
741         // If the auction has finished returns endPrice
742         uint256 timePassed = block.timestamp - startTime;
743         if (timePassed >= duration) {
744             return endPrice;
745         }
746 
747         return _getPrice(timePassed);
748     }
749 
750     /**
751     * @dev Convert allowed token to MANA and transfer the change in the original token
752     * Note that we will use the slippageRate cause it has a 3% buffer and a deposit of 5% to cover
753     * the conversion fee.
754     * @param _bidId - uint256 of the bid Id
755     * @param _fromToken - ERC20 token to be converted
756     * @param _bidPriceInMana - uint256 of the total amount in MANA
757     * @return uint256 of the total amount of MANA to burn
758     */
759     function _convertSafe(
760         uint256 _bidId,
761         ERC20 _fromToken,
762         uint256 _bidPriceInMana
763     ) internal returns (uint256 requiredManaAmountToBurn)
764     {
765         requiredManaAmountToBurn = _bidPriceInMana;
766         Token memory fromToken = tokensAllowed[address(_fromToken)];
767 
768         uint256 bidPriceInManaPlusSafetyMargin = _bidPriceInMana.mul(conversionFee).div(100);
769 
770         // Get rate
771         uint256 tokenRate = getRate(manaToken, _fromToken, bidPriceInManaPlusSafetyMargin);
772 
773         // Check if contract should burn or transfer some tokens
774         uint256 requiredTokenBalance = 0;
775         
776         if (fromToken.shouldBurnTokens || fromToken.shouldForwardTokens) {
777             requiredTokenBalance = _calculateRequiredTokenBalance(requiredManaAmountToBurn, tokenRate);
778             requiredManaAmountToBurn = _calculateRequiredManaAmount(_bidPriceInMana);
779         }
780 
781         // Calculate the amount of _fromToken to be converted
782         uint256 tokensToConvertPlusSafetyMargin = bidPriceInManaPlusSafetyMargin
783             .mul(tokenRate)
784             .div(10 ** 18);
785 
786         // Normalize to _fromToken decimals
787         if (MAX_DECIMALS > fromToken.decimals) {
788             requiredTokenBalance = _normalizeDecimals(
789                 fromToken.decimals, 
790                 requiredTokenBalance
791             );
792             tokensToConvertPlusSafetyMargin = _normalizeDecimals(
793                 fromToken.decimals,
794                 tokensToConvertPlusSafetyMargin
795             );
796         }
797 
798         // Retrieve tokens from the sender to this contract
799         require(
800             _fromToken.safeTransferFrom(msg.sender, address(this), tokensToConvertPlusSafetyMargin),
801             "Transfering the totalPrice in token to LANDAuction contract failed"
802         );
803         
804         // Calculate the total tokens to convert
805         uint256 finalTokensToConvert = tokensToConvertPlusSafetyMargin.sub(requiredTokenBalance);
806 
807         // Approve amount of _fromToken owned by contract to be used by dex contract
808         require(_fromToken.safeApprove(address(dex), finalTokensToConvert), "Error approve");
809 
810         // Convert _fromToken to MANA
811         uint256 change = dex.convert(
812                 _fromToken,
813                 manaToken,
814                 finalTokensToConvert,
815                 requiredManaAmountToBurn
816         );
817 
818        // Return change in _fromToken to sender
819         if (change > 0) {
820             // Return the change of src token
821             require(
822                 _fromToken.safeTransfer(msg.sender, change),
823                 "Transfering the change to sender failed"
824             );
825         }
826 
827         // Remove approval of _fromToken owned by contract to be used by dex contract
828         require(_fromToken.clearApprove(address(dex)), "Error remove approval");
829 
830         emit BidConversion(
831             _bidId,
832             address(_fromToken),
833             requiredManaAmountToBurn,
834             tokensToConvertPlusSafetyMargin.sub(change),
835             requiredTokenBalance
836         );
837     }
838 
839     /**
840     * @dev Get exchange rate
841     * @param _srcToken - IERC20 token
842     * @param _destToken - IERC20 token 
843     * @param _srcAmount - uint256 amount to be converted
844     * @return uint256 of the rate
845     */
846     function getRate(
847         IERC20 _srcToken, 
848         IERC20 _destToken, 
849         uint256 _srcAmount
850     ) public view returns (uint256 rate) 
851     {
852         (rate,) = dex.getExpectedRate(_srcToken, _destToken, _srcAmount);
853     }
854 
855     /** 
856     * @dev Calculate the amount of tokens to process
857     * @param _totalPrice - uint256 price to calculate percentage to process
858     * @param _tokenRate - rate to calculate the amount of tokens
859     * @return uint256 of the amount of tokens required
860     */
861     function _calculateRequiredTokenBalance(
862         uint256 _totalPrice,
863         uint256 _tokenRate
864     ) 
865     internal pure returns (uint256) 
866     {
867         return _totalPrice.mul(_tokenRate)
868             .div(10 ** 18)
869             .mul(PERCENTAGE_OF_TOKEN_BALANCE)
870             .div(100);
871     }
872 
873     /** 
874     * @dev Calculate the total price in MANA
875     * Note that PERCENTAGE_OF_TOKEN_BALANCE will be always less than 100
876     * @param _totalPrice - uint256 price to calculate percentage to keep
877     * @return uint256 of the new total price in MANA
878     */
879     function _calculateRequiredManaAmount(
880         uint256 _totalPrice
881     ) 
882     internal pure returns (uint256)
883     {
884         return _totalPrice.mul(100 - PERCENTAGE_OF_TOKEN_BALANCE).div(100);
885     }
886 
887     /**
888     * @dev Burn or forward the MANA and other tokens earned
889     * Note that as we will transfer or burn tokens from other contracts.
890     * We should burn MANA first to avoid a possible re-entrancy
891     * @param _bidId - uint256 of the bid Id
892     * @param _token - ERC20 token
893     */
894     function _processFunds(uint256 _bidId, ERC20 _token) internal {
895         // Burn MANA
896         _burnTokens(_bidId, manaToken);
897 
898         // Burn or forward token if it is not MANA
899         Token memory token = tokensAllowed[address(_token)];
900         if (_token != manaToken) {
901             if (token.shouldBurnTokens) {
902                 _burnTokens(_bidId, _token);
903             }
904             if (token.shouldForwardTokens) {
905                 _forwardTokens(_bidId, token.forwardTarget, _token);
906             }   
907         }
908     }
909 
910     /**
911     * @dev LAND price based on time
912     * Note that will select the function to calculate based on the time
913     * It should return endPrice if _time < duration
914     * @param _time - uint256 time passed before reach duration
915     * @return uint256 price for the given time
916     */
917     function _getPrice(uint256 _time) internal view returns (uint256) {
918         for (uint256 i = 0; i < curves.length; i++) {
919             Func storage func = curves[i];
920             if (_time < func.limit) {
921                 return func.base.sub(func.slope.mul(_time));
922             }
923         }
924         revert("Invalid time");
925     }
926 
927     /** 
928     * @dev Burn tokens
929     * @param _bidId - uint256 of the bid Id
930     * @param _token - ERC20 token
931     */
932     function _burnTokens(uint256 _bidId, ERC20 _token) private {
933         uint256 balance = _token.balanceOf(address(this));
934 
935         // Check if balance is valid
936         require(balance > 0, "Balance to burn should be > 0");
937         
938         _token.burn(balance);
939 
940         emit TokenBurned(_bidId, address(_token), balance);
941 
942         // Check if balance of the auction contract is empty
943         balance = _token.balanceOf(address(this));
944         require(balance == 0, "Burn token failed");
945     }
946 
947     /** 
948     * @dev Forward tokens
949     * @param _bidId - uint256 of the bid Id
950     * @param _address - address to send the tokens to
951     * @param _token - ERC20 token
952     */
953     function _forwardTokens(uint256 _bidId, address _address, ERC20 _token) private {
954         uint256 balance = _token.balanceOf(address(this));
955 
956         // Check if balance is valid
957         require(balance > 0, "Balance to burn should be > 0");
958         
959         _token.safeTransfer(_address, balance);
960 
961         emit TokenTransferred(
962             _bidId, 
963             address(_token), 
964             _address,balance
965         );
966 
967         // Check if balance of the auction contract is empty
968         balance = _token.balanceOf(address(this));
969         require(balance == 0, "Transfer token failed");
970     }
971 
972     /**
973     * @dev Set conversion fee rate
974     * @param _fee - uint256 for the new conversion rate
975     */
976     function setConversionFee(uint256 _fee) external onlyOwner {
977         require(_fee < 200 && _fee >= 100, "Conversion fee should be >= 100 and < 200");
978         emit ConversionFeeChanged(msg.sender, conversionFee, _fee);
979         conversionFee = _fee;
980     }
981 
982     /**
983     * @dev Finish auction 
984     */
985     function finishAuction() public onlyOwner {
986         require(status != Status.finished, "The auction is finished");
987 
988         uint256 currentPrice = getCurrentPrice();
989 
990         status = Status.finished;
991         endTime = block.timestamp;
992 
993         emit AuctionFinished(msg.sender, block.timestamp, currentPrice);
994     }
995 
996     /**
997     * @dev Set LAND for the auction
998     * @param _landsLimitPerBid - uint256 LAND limit for a single id
999     */
1000     function setLandsLimitPerBid(uint256 _landsLimitPerBid) public onlyOwner {
1001         require(_landsLimitPerBid > 0, "The LAND limit should be greater than 0");
1002         emit LandsLimitPerBidChanged(msg.sender, landsLimitPerBid, _landsLimitPerBid);
1003         landsLimitPerBid = _landsLimitPerBid;
1004     }
1005 
1006     /**
1007     * @dev Set gas price limit for the auction
1008     * @param _gasPriceLimit - uint256 gas price limit for a single bid
1009     */
1010     function setGasPriceLimit(uint256 _gasPriceLimit) public onlyOwner {
1011         require(_gasPriceLimit > 0, "The gas price should be greater than 0");
1012         emit GasPriceLimitChanged(msg.sender, gasPriceLimit, _gasPriceLimit);
1013         gasPriceLimit = _gasPriceLimit;
1014     }
1015 
1016     /**
1017     * @dev Set dex to convert ERC20
1018     * @param _dex - address of the token converter
1019     */
1020     function setDex(address _dex) public onlyOwner {
1021         require(_dex != address(dex), "The dex is the current");
1022         if (_dex != address(0)) {
1023             require(_dex.isContract(), "The dex address must be a deployed contract");
1024         }
1025         emit DexChanged(msg.sender, dex, _dex);
1026         dex = ITokenConverter(_dex);
1027     }
1028 
1029     /**
1030     * @dev Allow ERC20 to to be used for bidding
1031     * Note that if _shouldBurnTokens and _shouldForwardTokens are false, we 
1032     * will convert the total amount of the ERC20 to MANA
1033     * @param _address - address of the ERC20 Token
1034     * @param _decimals - uint256 of the number of decimals
1035     * @param _shouldBurnTokens - boolean whether we should burn funds
1036     * @param _shouldForwardTokens - boolean whether we should transferred funds
1037     * @param _forwardTarget - address where the funds will be transferred
1038     */
1039     function allowToken(
1040         address _address,
1041         uint256 _decimals,
1042         bool _shouldBurnTokens,
1043         bool _shouldForwardTokens,
1044         address _forwardTarget
1045     ) 
1046     public onlyOwner 
1047     {
1048         require(
1049             _address.isContract(),
1050             "Tokens allowed should be a deployed ERC20 contract"
1051         );
1052         require(
1053             _decimals > 0 && _decimals <= MAX_DECIMALS,
1054             "Decimals should be greather than 0 and less or equal to 18"
1055         );
1056         require(
1057             !(_shouldBurnTokens && _shouldForwardTokens),
1058             "The token should be either burned or transferred"
1059         );
1060         require(
1061             !_shouldForwardTokens || 
1062             (_shouldForwardTokens && _forwardTarget != address(0)),
1063             "The token should be transferred to a deployed contract"
1064         );
1065         require(
1066             _forwardTarget != address(this) && _forwardTarget != _address, 
1067             "The forward target should be different from  this contract and the erc20 token"
1068         );
1069         
1070         require(!tokensAllowed[_address].isAllowed, "The ERC20 token is already allowed");
1071 
1072         tokensAllowed[_address] = Token({
1073             decimals: _decimals,
1074             shouldBurnTokens: _shouldBurnTokens,
1075             shouldForwardTokens: _shouldForwardTokens,
1076             forwardTarget: _forwardTarget,
1077             isAllowed: true
1078         });
1079 
1080         emit TokenAllowed(
1081             msg.sender, 
1082             _address, 
1083             _decimals,
1084             _shouldBurnTokens,
1085             _shouldForwardTokens,
1086             _forwardTarget
1087         );
1088     }
1089 
1090     /**
1091     * @dev Disable ERC20 to to be used for bidding
1092     * @param _address - address of the ERC20 Token
1093     */
1094     function disableToken(address _address) public onlyOwner {
1095         require(
1096             tokensAllowed[_address].isAllowed,
1097             "The ERC20 token is already disabled"
1098         );
1099         delete tokensAllowed[_address];
1100         emit TokenDisabled(msg.sender, _address);
1101     }
1102 
1103     /** 
1104     * @dev Create a combined function.
1105     * note that we will set N - 1 function combinations based on N points (x,y)
1106     * @param _xPoints - uint256[] of x values
1107     * @param _yPoints - uint256[] of y values
1108     */
1109     function _setCurve(uint256[] _xPoints, uint256[] _yPoints) internal {
1110         uint256 pointsLength = _xPoints.length;
1111         require(pointsLength == _yPoints.length, "Points should have the same length");
1112         for (uint256 i = 0; i < pointsLength - 1; i++) {
1113             uint256 x1 = _xPoints[i];
1114             uint256 x2 = _xPoints[i + 1];
1115             uint256 y1 = _yPoints[i];
1116             uint256 y2 = _yPoints[i + 1];
1117             require(x1 < x2, "X points should increase");
1118             require(y1 > y2, "Y points should decrease");
1119             (uint256 base, uint256 slope) = _getFunc(
1120                 x1, 
1121                 x2, 
1122                 y1, 
1123                 y2
1124             );
1125             curves.push(Func({
1126                 base: base,
1127                 slope: slope,
1128                 limit: x2
1129             }));
1130         }
1131 
1132         initialPrice = _yPoints[0];
1133         endPrice = _yPoints[pointsLength - 1];
1134     }
1135 
1136     /**
1137     * @dev Calculate base and slope for the given points
1138     * It is a linear function y = ax - b. But The slope should be negative.
1139     * As we want to avoid negative numbers in favor of using uints we use it as: y = b - ax
1140     * Based on two points (x1; x2) and (y1; y2)
1141     * base = (x2 * y1) - (x1 * y2) / (x2 - x1)
1142     * slope = (y1 - y2) / (x2 - x1) to avoid negative maths
1143     * @param _x1 - uint256 x1 value
1144     * @param _x2 - uint256 x2 value
1145     * @param _y1 - uint256 y1 value
1146     * @param _y2 - uint256 y2 value
1147     * @return uint256 for the base
1148     * @return uint256 for the slope
1149     */
1150     function _getFunc(
1151         uint256 _x1,
1152         uint256 _x2,
1153         uint256 _y1, 
1154         uint256 _y2
1155     ) internal pure returns (uint256 base, uint256 slope) 
1156     {
1157         base = ((_x2.mul(_y1)).sub(_x1.mul(_y2))).div(_x2.sub(_x1));
1158         slope = (_y1.sub(_y2)).div(_x2.sub(_x1));
1159     }
1160 
1161     /**
1162     * @dev Return bid id
1163     * @return uint256 of the bid id
1164     */
1165     function _getBidId() private view returns (uint256) {
1166         return totalBids;
1167     }
1168 
1169     /** 
1170     * @dev Normalize to _fromToken decimals
1171     * @param _decimals - uint256 of _fromToken decimals
1172     * @param _value - uint256 of the amount to normalize
1173     */
1174     function _normalizeDecimals(
1175         uint256 _decimals, 
1176         uint256 _value
1177     ) 
1178     internal pure returns (uint256 _result) 
1179     {
1180         _result = _value.div(10**MAX_DECIMALS.sub(_decimals));
1181     }
1182 
1183     /** 
1184     * @dev Update stats. It will update the following stats:
1185     * - totalBids
1186     * - totalLandsBidded
1187     * - totalManaBurned
1188     * @param _landsBidded - uint256 of the number of LAND bidded
1189     * @param _manaAmountBurned - uint256 of the amount of MANA burned
1190     */
1191     function _updateStats(uint256 _landsBidded, uint256 _manaAmountBurned) private {
1192         totalBids = totalBids.add(1);
1193         totalLandsBidded = totalLandsBidded.add(_landsBidded);
1194         totalManaBurned = totalManaBurned.add(_manaAmountBurned);
1195     }
1196 }