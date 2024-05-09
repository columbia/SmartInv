1 pragma solidity 0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public constant returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124 
125     uint256 _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue)
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue)
177     returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 contract MintableToken is StandardToken, Ownable {
191   event Mint(address indexed to, uint256 amount);
192   event MintFinished();
193 
194   bool public mintingFinished = false;
195 
196 
197   modifier canMint() {
198     require(!mintingFinished);
199     _;
200   }
201 
202   /**
203    * @dev Function to mint tokens
204    * @param _to The address that will receive the minted tokens.
205    * @param _amount The amount of tokens to mint.
206    * @return A boolean that indicates if the operation was successful.
207    */
208   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
209     totalSupply = totalSupply.add(_amount);
210     balances[_to] = balances[_to].add(_amount);
211     Mint(_to, _amount);
212     Transfer(0x0, _to, _amount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner public returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225 }
226 
227 contract IDealToken {
228     function spend(address _from, uint256 _value) returns (bool success);
229 }
230 
231 contract DealToken is MintableToken, IDealToken {
232     string public constant name = "Deal Token";
233     string public constant symbol = "DEAL";
234     uint8 public constant decimals = 0;
235 
236     uint256 public totalTokensBurnt = 0;
237 
238     event TokensSpent(address indexed _from, uint256 _value);
239 
240     /**
241      * @dev - Empty constructor
242      */
243     function DealToken() public { }
244 
245     /**
246      * @dev - Function that allows foreground contract to spend (burn) the tokens.
247      * @param _from - Account to withdraw from.
248      * @param _value - Number of tokens to withdraw.
249      * @return - A boolean that indicates if the operation was successful.
250      */
251     function spend(address _from, uint256 _value) public returns (bool) {
252         require(_value > 0);
253 
254         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
255             return false;
256         }
257 
258         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259         balances[_from] = balances[_from].sub(_value);
260         totalTokensBurnt = totalTokensBurnt.add(_value);
261         totalSupply = totalSupply.sub(_value);
262         TokensSpent(_from, _value);
263         return true;
264     }
265 
266     /**
267      * @dev - Allow another contract to spend some tokens on your behalf
268      * @param _spender - Contract that will spend the tokens
269      * @param _value - Amount of tokens to spend
270      * @param _extraData - Additional data to pass to the receiveApproval
271      * @return -  A boolean that indicates if the operation was successful.
272      */
273     function approveAndCall(ITokenRecipient _spender, uint256 _value, bytes _extraData) public returns (bool) {
274         allowed[msg.sender][_spender] = _value;
275         Approval(msg.sender, _spender, _value);
276         _spender.receiveApproval(msg.sender, _value, this, _extraData);
277         return true;
278     }
279 }
280 
281 contract IForeground {
282     function payConversionFromTransaction(uint256 _promotionID, address _recipientAddress, uint256 _transactionAmount) external payable;
283     function createNewDynamicPaymentAddress(uint256 _promotionID, address referrer) external;
284     function calculateTotalDue(uint256 _promotionID, uint256 _transactionAmount) public constant returns (uint256 _totalPayment);
285 }
286 
287 contract IForegroundEnabledContract {
288    function receiveEtherFromForegroundAddress(address _originatingAddress, address _relayedFromAddress, uint256 _promotionID, address _referrer) public payable;
289 }
290 
291 contract ForegroundCaller is IForegroundEnabledContract {
292     IForeground public foreground;
293 
294     function ForegroundCaller(IForeground _foreground) public {
295         foreground = _foreground;
296     }
297 
298     //This event is useful for testing whether a contract has implemented Foreground correctly
299     //It can even be used prior to the implementing contract going live
300     event EtherReceivedFromRelay(address indexed _originatingAddress, uint256 indexed _promotionID, address indexed _referrer);
301     event ForegroundPaymentResult(bool _success, uint256 indexed _promotionID, address indexed _referrer, uint256 _value);
302     event ContractFunded(address indexed _sender, uint256 _value);
303 
304     //Note: we don't use the "relayedFromAddress" variable here, but it seems like it should still be part of the API
305     function receiveEtherFromForegroundAddress(address _originatingAddress, address _relayedFromAddress, uint256 _promotionID, address _referrer) public payable {
306         //NOTE: available Ether may be less than msg.value after this call
307         //NOTE: originatingAddress indicates the true sender of the funds at this point, not msg.sender
308         EtherReceivedFromRelay(_originatingAddress, _promotionID, _referrer);
309 
310         uint256 _amountSpent = receiveEtherFromRelayAddress(_originatingAddress, msg.value);
311 
312         //NOTE: This makes a call to an external contract (Foreground), but does not use .call -- this seems unavoidable
313         uint256 _paymentToForeground = foreground.calculateTotalDue(_promotionID, _amountSpent);
314         //NOTE: Using .call in order to swallow any exceptions
315         bool _success = foreground.call.gas(1000000).value(_paymentToForeground)(bytes4(keccak256("payConversionFromTransaction(uint256,address,uint256)")), _promotionID, _referrer, _amountSpent);
316         ForegroundPaymentResult(_success, _promotionID, _referrer, msg.value);
317     }
318 
319     //Abstract function to be implemented by advertiser's contract
320     function receiveEtherFromRelayAddress(address _originatingAddress, uint256 _amount) internal returns(uint256 _amountSpent);
321 
322     //Function allows for additional funds to be added to the contract (without purchasing tokens)
323     function fundContract() payable {
324         ContractFunded(msg.sender, msg.value);
325     }
326 }
327 
328 contract ForegroundTokenSale is Ownable, ForegroundCaller {
329     using SafeMath for uint256;
330 
331     uint256 public publicTokenCap;
332     uint256 public baseTokenPrice;
333     uint256 public currentTokenPrice;
334 
335     uint256 public priceStepDuration;
336 
337     uint256 public numberOfParticipants;
338     uint256 public maxSaleBalance;
339     uint256 public minSaleBalance;
340     uint256 public saleBalance;
341     uint256 public tokenBalance;
342 
343     uint256 public startBlock;
344     uint256 public endBlock;
345 
346     address public saleWalletAddress;
347 
348     address public devTeamTokenAddress;
349     address public partnershipsTokenAddress;
350     address public incentiveTokenAddress;
351     address public bountyTokenAddress;
352 
353     bool public saleSuspended = false;
354 
355     DealToken public dealToken;
356     SaleState public state;
357 
358     mapping (address => PurchaseDetails) public purchases;
359 
360     struct PurchaseDetails {
361         uint256 tokenBalance;
362         uint256 weiBalance;
363     }
364 
365     enum SaleState {Prepared, Deployed, Configured, Started, Ended, Finalized, Refunding}
366 
367     event TokenPurchased(address indexed buyer, uint256 tokenPrice, uint256 txAmount, uint256 actualPurchaseAmount, uint256 refundedAmount, uint256 tokensPurchased);
368     event SaleStarted();
369     event SaleEnded();
370     event Claimed(address indexed owner, uint256 tokensClaimed);
371     event Refunded(address indexed buyer, uint256 amountRefunded);
372 
373     /**
374      * @dev - modifier that evaluates which state the sale should be in. Functions that use this modifier cannot be constant due to potential state change
375      */
376     modifier evaluateSaleState {
377         require(saleSuspended == false);
378 
379         if (state == SaleState.Configured && block.number >= startBlock) {
380             state = SaleState.Started;
381             SaleStarted();
382         }
383 
384         if (state == SaleState.Started) {
385             setCurrentPrice();
386         }
387 
388         if (state == SaleState.Started && (block.number > endBlock || saleBalance == maxSaleBalance || maxSaleBalance.sub(saleBalance) < currentTokenPrice)) {
389             endSale();
390         }
391 
392         if (state == SaleState.Ended) {
393             finalizeSale();
394         }
395         _;
396     }
397 
398     /**
399      * @dev - Constructor for the Foreground token sale contract
400      * @param _publicTokenCap - Max number of tokens made available to the public
401      * @param _tokenFloor - Min number of tokens to be sold to be considered a successful sale
402      * @param _tokenRate - Initial price per token
403      * @param _foreground - Address of the Foreground contract that gets passed on to ForegroundCaller
404      */
405     function ForegroundTokenSale(
406         uint256 _publicTokenCap,
407         uint256 _tokenFloor,
408         uint256 _tokenRate,
409         IForeground _foreground
410     )
411         public
412         ForegroundCaller(_foreground)
413     {
414         require(_publicTokenCap > 0);
415         require(_tokenFloor < _publicTokenCap);
416         require(_tokenRate > 0);
417 
418         publicTokenCap = _publicTokenCap;
419         baseTokenPrice = _tokenRate;
420         currentTokenPrice = _tokenRate;
421 
422         dealToken = new DealToken();
423         maxSaleBalance = publicTokenCap.mul(currentTokenPrice);
424         minSaleBalance = _tokenFloor.mul(currentTokenPrice);
425         state = SaleState.Deployed;
426     }
427 
428     /**
429      * @dev - Default payable function. Will result in tokens being purchased
430      */
431     function() public payable {
432         purchaseToken(msg.sender, msg.value);
433     }
434 
435     /**
436      * @dev - Configure specific params of the sale. Can only be called once
437      * @param _startBlock - Block the sale should start at
438      * @param _endBlock - Block the sale should end at
439      * @param _wallet - Sale wallet address - funds will be transferred here once sale is done
440      * @param _stepDuration - How many blocks to wait to increase price
441      * @param _devAddress - Address for the tokens distributed for Foreground development purposes
442      * @param _partnershipAddress - Address for the tokens distributed for Foreground partnerships
443      * @param _incentiveAddress - Address for the tokens distributed for Foreground incentives
444      * @param _bountyAddress - Address for the tokens distributed for Foreground bounties
445      */
446     function configureSale(
447         uint256 _startBlock,
448         uint256 _endBlock,
449         address _wallet,
450         uint256 _stepDuration,
451         address _devAddress,
452         address _partnershipAddress,
453         address _incentiveAddress,
454         address _bountyAddress
455     )
456         external
457         onlyOwner
458     {
459         require(_startBlock >= block.number);
460         require(_endBlock >= _startBlock);
461         require(state == SaleState.Deployed);
462         require(_wallet != 0x0);
463         require(_stepDuration > 0);
464         require(_devAddress != 0x0);
465         require(_partnershipAddress != 0x0);
466         require(_incentiveAddress != 0x0);
467         require(_bountyAddress != 0x0);
468 
469         state = SaleState.Configured;
470         startBlock = _startBlock;
471         endBlock = _endBlock;
472         saleWalletAddress = _wallet;
473         priceStepDuration = _stepDuration;
474         devTeamTokenAddress = _devAddress;
475         partnershipsTokenAddress = _partnershipAddress;
476         incentiveTokenAddress = _incentiveAddress;
477         bountyTokenAddress = _bountyAddress;
478     }
479 
480     /**
481      * @dev - Claim tokens once sale is over
482      */
483     function claimToken()
484         external
485         evaluateSaleState
486     {
487         require(state == SaleState.Finalized);
488         require(purchases[msg.sender].tokenBalance > 0);
489 
490         uint256 _tokensPurchased = purchases[msg.sender].tokenBalance;
491         purchases[msg.sender].tokenBalance = 0;
492         purchases[msg.sender].weiBalance = 0;
493 
494         /* Transfer the tokens */
495         dealToken.transfer(msg.sender, _tokensPurchased);
496         Claimed(msg.sender, _tokensPurchased);
497     }
498 
499     /**
500      * @dev - Claim a refund if the token sale did not reach its minimum value
501      */
502     function claimRefund()
503         external
504     {
505         require(state == SaleState.Refunding);
506 
507         uint256 _amountToRefund = purchases[msg.sender].weiBalance;
508         require(_amountToRefund > 0);
509         purchases[msg.sender].weiBalance = 0;
510         purchases[msg.sender].tokenBalance = 0;
511         msg.sender.transfer(_amountToRefund);
512         Refunded(msg.sender, _amountToRefund);
513     }
514 
515     /**
516      * @dev - Ability for contract owner to suspend the sale if necessary
517      * @param _suspend - Boolean value to indicate whether the sale is suspended or not
518      */
519     function suspendSale(bool _suspend)
520         external
521         onlyOwner
522     {
523         saleSuspended = _suspend;
524     }
525 
526     /**
527      * @dev - Returns the correct sale state based on the current block number
528      * @return - current sale state and current sale price
529      */
530     function updateLatestSaleState()
531         external
532         evaluateSaleState
533         returns (uint256)
534     {
535         return uint256(state);
536     }
537 
538     /**
539      * @dev - Purchase a DEAL token. Sale must be in the correct state
540      * @param _recipient - address to assign the purchased tokens to
541      * @param _amount - eth value of tokens to be purchased
542      */
543     function purchaseToken(address _recipient, uint256 _amount)
544         internal
545         evaluateSaleState
546         returns (uint256)
547     {
548         require(state == SaleState.Started);
549         require(_amount >= currentTokenPrice);
550 
551         uint256 _saleRemainingBalance = maxSaleBalance.sub(saleBalance);
552         bool _shouldEndSale = false;
553 
554         /* Ensure purchaseAmount buys exact amount of tokens, refund the rest immediately */
555         uint256 _amountToRefund = _amount % currentTokenPrice;
556         uint256 _purchaseAmount = _amount.sub(_amountToRefund);
557 
558         /* This purchase will push us over the max balance - so refund that amount that is over */
559         if (_saleRemainingBalance < _purchaseAmount) {
560             uint256 _endOfSaleRefund = _saleRemainingBalance % currentTokenPrice;
561             _amountToRefund = _amountToRefund.add(_purchaseAmount.sub(_saleRemainingBalance).add(_endOfSaleRefund));
562             _purchaseAmount = _saleRemainingBalance.sub(_endOfSaleRefund);
563             _shouldEndSale = true;
564         }
565 
566         /* Count the number of unique participants */
567         if (purchases[_recipient].tokenBalance == 0) {
568             numberOfParticipants = numberOfParticipants.add(1);
569         }
570 
571         uint256 _tokensPurchased = _purchaseAmount.div(currentTokenPrice);
572         purchases[_recipient].tokenBalance = purchases[_recipient].tokenBalance.add(_tokensPurchased);
573         purchases[_recipient].weiBalance = purchases[_recipient].weiBalance.add(_purchaseAmount);
574         saleBalance = saleBalance.add(_purchaseAmount);
575         tokenBalance = tokenBalance.add(_tokensPurchased);
576 
577         if (_purchaseAmount == _saleRemainingBalance || _shouldEndSale) {
578             endSale();
579         }
580 
581         /* Refund amounts due if there are any */
582         if (_amountToRefund > 0) {
583             _recipient.transfer(_amountToRefund);
584         }
585 
586         TokenPurchased(_recipient, currentTokenPrice, msg.value, _purchaseAmount, _amountToRefund, _tokensPurchased);
587         return _purchaseAmount;
588     }
589 
590     /**
591      * @dev - Implementation of Foreground function to receive payment
592      * @param _originatingAddress - address to assign the purchased tokens to
593      * @param _amount - eth value of tokens to be purchased
594      * @return - The actual amount spent to buy tokens after taking sale state and refunds into account
595      */
596     function receiveEtherFromRelayAddress(address _originatingAddress, uint256 _amount)
597         internal
598         returns (uint256)
599     {
600         return purchaseToken(_originatingAddress, _amount);
601     }
602 
603     /**
604      * @dev - Internal function to calculate and store the current token price based on block number
605      */
606     function setCurrentPrice() internal {
607         uint256 _saleBlockNo = block.number - startBlock;
608         uint256 _numIncreases = _saleBlockNo.div(priceStepDuration);
609 
610         if (_numIncreases == 0)
611             currentTokenPrice = baseTokenPrice;
612         else if (_numIncreases == 1)
613             currentTokenPrice = 0.06 ether;
614         else if (_numIncreases == 2)
615             currentTokenPrice = 0.065 ether;
616         else if (_numIncreases == 3)
617             currentTokenPrice = 0.07 ether;
618         else if (_numIncreases >= 4)
619             currentTokenPrice = 0.08 ether;
620     }
621 
622     /**
623      * @dev - Sale end condition reached, determine if sale was successful and set state accordingly
624      */
625     function endSale() internal {
626         /* If we didn't reach the min value - set state to refund so that funds can reclaimed by sale participants */
627         if (saleBalance < minSaleBalance) {
628             state = SaleState.Refunding;
629         } else {
630             state = SaleState.Ended;
631             /* Mint the tokens and distribute internally */
632             mintTokens();
633         }
634         SaleEnded();
635     }
636 
637     /**
638      * @dev - Mints tokens and distributes pre-allocated tokens to Foreground addresses
639      */
640     function mintTokens() internal {
641         uint256 _totalTokens = (tokenBalance.mul(10 ** 18)).div(74).mul(100);
642 
643         /* Mint the tokens and assign them all to the TokenSaleContract for distribution */
644         dealToken.mint(address(this), _totalTokens.div(10 ** 18));
645 
646         /* Distribute non public tokens */
647         dealToken.transfer(devTeamTokenAddress, (_totalTokens.mul(10).div(100)).div(10 ** 18));
648         dealToken.transfer(partnershipsTokenAddress, (_totalTokens.mul(10).div(100)).div(10 ** 18));
649         dealToken.transfer(incentiveTokenAddress, (_totalTokens.mul(4).div(100)).div(10 ** 18));
650         dealToken.transfer(bountyTokenAddress, (_totalTokens.mul(2).div(100)).div(10 ** 18));
651 
652         /* Finish minting so that no more tokens can be minted */
653         dealToken.finishMinting();
654     }
655 
656     /**
657      * @dev - Finalizes the sale transfers the contract balance to the sale wallet.
658      */
659     function finalizeSale() internal {
660         state = SaleState.Finalized;
661         /* Transfer contract balance to sale wallet */
662         saleWalletAddress.transfer(this.balance);
663     }
664 }
665 
666 contract ITokenRecipient {
667 	function receiveApproval(address _from, uint _value, address _token, bytes _extraData);
668 }