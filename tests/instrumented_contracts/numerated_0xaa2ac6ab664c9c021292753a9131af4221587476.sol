1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) returns (bool);
52   function approve(address spender, uint256 value) returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances. 
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) returns (bool) {
71     require(_to != address(0));
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of. 
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
110     require(_to != address(0));
111 
112     var _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) returns (bool) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151   
152   /**
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until 
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval (address _spender, uint _addedValue) 
159     returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval (address _spender, uint _subtractedValue) 
166     returns (bool success) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 /**
180  * @title Ownable
181  * @dev The Ownable contract has an owner address, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Ownable {
185   address public owner;
186 
187 
188   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191   /**
192    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193    * account.
194    */
195   function Ownable() {
196     owner = msg.sender;
197   }
198 
199 
200   /**
201    * @dev Throws if called by any account other than the owner.
202    */
203   modifier onlyOwner() {
204     require(msg.sender == owner);
205     _;
206   }
207 
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) onlyOwner {
214     require(newOwner != address(0));      
215     OwnershipTransferred(owner, newOwner);
216     owner = newOwner;
217   }
218 
219 }
220 
221 /**
222  * @title Mintable token
223  * @dev Simple ERC20 Token example, with mintable token creation
224  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
225  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
226  */
227 
228 contract MintableToken is StandardToken, Ownable {
229   event Mint(address indexed to, uint256 amount);
230   event MintFinished();
231 
232   bool public mintingFinished = false;
233 
234 
235   modifier canMint() {
236     require(!mintingFinished);
237     _;
238   }
239 
240   /**
241    * @dev Function to mint tokens
242    * @param _to The address that will receive the minted tokens.
243    * @param _amount The amount of tokens to mint.
244    * @return A boolean that indicates if the operation was successful.
245    */
246   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
247     totalSupply = totalSupply.add(_amount);
248     balances[_to] = balances[_to].add(_amount);
249     Mint(_to, _amount);
250     Transfer(0x0, _to, _amount);
251     return true;
252   }
253 
254   /**
255    * @dev Function to stop minting new tokens.
256    * @return True if the operation was successful.
257    */
258   function finishMinting() onlyOwner returns (bool) {
259     mintingFinished = true;
260     MintFinished();
261     return true;
262   }
263 }
264 
265 
266 /**
267  * @title Crowdsale
268  * @dev Crowdsale is a base contract for managing a token crowdsale.
269  * Crowdsales have a start and end blocks, where investors can make
270  * token purchases and the crowdsale will assign them tokens based
271  * on a token per ETH rate. Funds collected are forwarded to a wallet
272  * as they arrive.
273  */
274 contract Crowdsale {
275   using SafeMath for uint256;
276   // The token being sold
277   MintableToken public token;
278 
279   // start and end blocks where investments are allowed (both inclusive)
280   uint256 public startBlock;
281   uint256 public endBlock;
282 
283   // address where funds are collected
284   address public wallet;
285 
286   // amount of raised money in wei
287   uint256 public weiRaised;
288 
289   // how many token units a buyer gets per wei
290   uint256 public rate;
291 
292 
293   /**
294    * event for token purchase logging
295    * @param purchaser who paid for the tokens
296    * @param beneficiary who got the tokens
297    * @param value weis paid for purchase
298    * @param amount amount of tokens purchased
299    */
300   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
301 
302 
303   function Crowdsale(uint256 _startBlock, uint256 _endBlock, address _wallet) {
304     require(_startBlock >= block.number);
305     require(_endBlock >= _startBlock);
306     require(_wallet != 0x0);
307 
308     token = createTokenContract();
309     startBlock = _startBlock;
310     endBlock = _endBlock;
311     wallet = _wallet;
312   }
313 
314   // creates the token to be sold.
315   // override this method to have crowdsale of a specific mintable token.
316   function createTokenContract() internal returns (MintableToken) {
317     return new MintableToken();
318   }
319 
320 
321   // fallback function can be used to buy tokens
322   function () payable {
323     buyTokens(msg.sender);
324   }
325 
326 
327   // low level token purchase function
328   function buyTokens(address beneficiary) public payable {
329     require(beneficiary != 0x0);
330     require(validPurchase());
331 
332     uint256 weiAmount = msg.value;
333 
334     // calculate token amount to be created
335     uint256 tokens = weiAmount.mul(rate);
336 
337     // update state
338     weiRaised = weiRaised.add(weiAmount);
339 
340     token.mint(beneficiary, tokens);
341     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
342 
343     forwardFunds();
344   }
345 
346 
347   // send ether to the fund collection wallet
348   // override to create custom fund forwarding mechanisms
349   function forwardFunds() internal {
350     wallet.transfer(msg.value);
351   }
352 
353   // @return true if the transaction can buy tokens
354   function validPurchase() internal constant returns (bool) {
355     bool withinPeriod = block.number >= startBlock && block.number <= endBlock;
356     bool nonZeroPurchase = msg.value != 0;
357     return withinPeriod && nonZeroPurchase;
358   }
359 
360   // @return true if crowdsale event has ended
361   function hasEnded() public constant returns (bool) {
362     return block.number > endBlock;
363   }
364 
365 
366 }
367 
368 
369 /**
370  * @title CappedCrowdsale
371  * @dev Extension of Crowsdale with a max amount of funds raised
372  */
373 contract CappedCrowdsale is Crowdsale {
374   using SafeMath for uint256;
375 
376   uint256 public cap;
377 
378   function CappedCrowdsale(uint256 _cap) {
379     require(_cap > 0);
380     cap = _cap;
381   }
382 
383   // overriding Crowdsale#validPurchase to add extra cap logic
384   // @return true if investors can buy at the moment
385   function validPurchase() internal constant returns (bool) {
386     bool withinCap = weiRaised.add(msg.value) <= cap;
387     return super.validPurchase() && withinCap;
388   }
389 
390   // overriding Crowdsale#hasEnded to add cap logic
391   // @return true if crowdsale event has ended
392   function hasEnded() public constant returns (bool) {
393     bool capReached = weiRaised >= cap;
394     return super.hasEnded() || capReached;
395   }
396 
397 }
398 
399 /**
400  * @title RefundVault
401  * @dev This contract is used for storing funds while a crowdsale
402  * is in progress. Supports refunding the money if crowdsale fails,
403  * and forwarding it if crowdsale is successful.
404  */
405 contract RefundVault is Ownable {
406   using SafeMath for uint256;
407 
408   enum State { Active, Refunding, Closed }
409 
410   mapping (address => uint256) public deposited;
411   address public wallet;
412   State public state;
413 
414   event Closed();
415   event RefundsEnabled();
416   event Refunded(address indexed beneficiary, uint256 weiAmount);
417 
418   function RefundVault(address _wallet) {
419     require(_wallet != 0x0);
420     wallet = _wallet;
421     state = State.Active;
422   }
423 
424   function deposit(address investor) onlyOwner payable {
425     require(state == State.Active);
426     deposited[investor] = deposited[investor].add(msg.value);
427   }
428 
429   function close() onlyOwner {
430     require(state == State.Active);
431     state = State.Closed;
432     Closed();
433     wallet.transfer(this.balance);
434   }
435 
436   function enableRefunds() onlyOwner {
437     require(state == State.Active);
438     state = State.Refunding;
439     RefundsEnabled();
440   }
441 
442   function refund(address investor) {
443     require(state == State.Refunding);
444     uint256 depositedValue = deposited[investor];
445     deposited[investor] = 0;
446     investor.transfer(depositedValue);
447     Refunded(investor, depositedValue);
448   }
449 }
450 
451 /**
452  * @title FinalizableCrowdsale
453  * @dev Extension of Crowsdale where an owner can do extra work
454  * after finishing. 
455  */
456 contract FinalizableCrowdsale is Crowdsale, Ownable {
457   using SafeMath for uint256;
458 
459   bool public isFinalized = false;
460 
461   event Finalized();
462 
463   /**
464    * @dev Must be called after crowdsale ends, to do some extra finalization
465    * work. Calls the contract's finalization function.
466    */
467   function finalize() onlyOwner {
468     require(!isFinalized);
469     require(hasEnded());
470 
471     finalization();
472     Finalized();
473     
474     isFinalized = true;
475   }
476 
477   /**
478    * @dev Can be overriden to add finalization logic. The overriding function
479    * should call super.finalization() to ensure the chain of finalization is
480    * executed entirely.
481    */
482   function finalization() internal {
483   }
484 }
485 
486 /**
487  * @title RefundableCrowdsale
488  * @dev Extension of Crowdsale contract that adds a funding goal, and
489  * the possibility of users getting a refund if goal is not met.
490  * Uses a RefundVault as the crowdsale's vault.
491  */
492 contract RefundableCrowdsale is FinalizableCrowdsale {
493   using SafeMath for uint256;
494 
495   // minimum amount of funds to be raised in weis
496   uint256 public goal;
497 
498   // refund vault used to hold funds while crowdsale is running
499   RefundVault public vault;
500 
501   function RefundableCrowdsale(uint256 _goal) {
502     require(_goal > 0);
503     vault = new RefundVault(wallet);
504     goal = _goal;
505   }
506 
507   // We're overriding the fund forwarding from Crowdsale.
508   // In addition to sending the funds, we want to call
509   // the RefundVault deposit function
510   function forwardFunds() internal {
511     vault.deposit.value(msg.value)(msg.sender);
512   }
513 
514   // if crowdsale is unsuccessful, investors can claim refunds here
515   function claimRefund() {
516     require(isFinalized);
517     require(!goalReached());
518 
519     vault.refund(msg.sender);
520   }
521 
522   // vault finalization task, called when owner calls finalize()
523   function finalization() internal {
524     if (goalReached()) {
525       vault.close();
526     } else {
527       vault.enableRefunds();
528     }
529 
530     super.finalization();
531   }
532 
533   function goalReached() public constant returns (bool) {
534     return weiRaised >= goal;
535   }
536 
537 }
538 
539 contract GlobCoinToken is MintableToken {
540   using SafeMath for uint256;
541   string public constant name = "GlobCoin Crypto Platform";
542   string public constant symbol = "GCP";
543   uint8 public constant decimals = 18;
544 
545   modifier onlyMintingFinished() {
546     require(mintingFinished == true);
547     _;
548   }
549   /// @dev Same ERC20 behavior, but require the token to be unlocked
550   /// @param _spender address The address which will spend the funds.
551   /// @param _value uint256 The amount of tokens to be spent.
552   function approve(address _spender, uint256 _value) public onlyMintingFinished returns (bool) {
553       return super.approve(_spender, _value);
554   }
555 
556   /// @dev Same ERC20 behavior, but require the token to be unlocked
557   /// @param _to address The address to transfer to.
558   /// @param _value uint256 The amount to be transferred.
559   function transfer(address _to, uint256 _value) public onlyMintingFinished returns (bool) {
560       return super.transfer(_to, _value);
561   }
562 
563   /// @dev Same ERC20 behavior, but require the token to be unlocked
564   /// @param _from address The address which you want to send tokens from.
565   /// @param _to address The address which you want to transfer to.
566   /// @param _value uint256 the amount of tokens to be transferred.
567   function transferFrom(address _from, address _to, uint256 _value) public onlyMintingFinished returns (bool) {
568     return super.transferFrom(_from, _to, _value);
569   }
570 
571 }
572 
573 contract GlobCoinTokenSale is CappedCrowdsale, RefundableCrowdsale {
574 
575   //Start of the Actual crowdsale. Starblock is the start of the presale.
576   uint256 startSale;
577 
578   // Presale Rate per wei ~30% bonus over rate1
579   uint256 public constant PRESALERATE =  170;
580 
581   // new rates
582   uint256 public constant RATE1 =  130;
583   uint256 public constant RATE2 =  120;
584   uint256 public constant RATE3 =  110;
585   uint256 public constant RATE4 =  100;
586 
587 
588   // Cap per tier for bonus in wei.
589   uint256 public constant TIER1 =  10000000000000000000000;
590   uint256 public constant TIER2 =  25000000000000000000000;
591   uint256 public constant TIER3 =  50000000000000000000000;
592 
593   //Presale
594   uint256 public weiRaisedPreSale;
595   uint256 public presaleCap;
596 
597   function GlobCoinTokenSale(uint256 _startBlock,uint256 _startSale, uint256 _endBlock, uint256 _goal,uint256 _presaleCap, uint256 _cap, address _wallet) CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startBlock, _endBlock, _wallet) {
598     require(_goal <= _cap);
599     require(_startSale > _startBlock);
600     require(_endBlock > _startSale);
601     require(_presaleCap > 0);
602     require(_presaleCap < _cap);
603 
604     startSale = _startSale;
605     presaleCap = _presaleCap;
606   }
607 
608   function createTokenContract() internal returns (MintableToken) {
609     return new GlobCoinToken();
610   }
611 
612   //white listed address
613   mapping (address => bool) public whiteListedAddress;
614   mapping (address => bool) public whiteListedAddressPresale;
615 
616   modifier onlyPresaleWhitelisted() {
617     require( isWhitelistedPresale(msg.sender) ) ;
618     _;
619   }
620 
621   modifier onlyWhitelisted() {
622     require( isWhitelisted(msg.sender) || isWhitelistedPresale(msg.sender) ) ;
623     _;
624   }
625 
626   /**
627    * @dev Add a list of address to be whitelisted for the crowdsale only.
628    * @param _users , the list of user Address. Tested for out of gas until 200 addresses.
629    */
630   function whitelistAddresses( address[] _users) onlyOwner {
631     for( uint i = 0 ; i < _users.length ; i++ ) {
632       whiteListedAddress[_users[i]] = true;
633     }
634   }
635 
636   function unwhitelistAddress( address _users) onlyOwner {
637     whiteListedAddress[_users] = false;
638   }
639 
640   /**
641    * @dev Add a list of address to be whitelisted for the Presale And sale.
642    * @param _users , the list of user Address. Tested for out of gas until 200 addresses.
643    */
644   function whitelistAddressesPresale( address[] _users) onlyOwner {
645     for( uint i = 0 ; i < _users.length ; i++ ) {
646       whiteListedAddressPresale[_users[i]] = true;
647     }
648   }
649 
650   function unwhitelistAddressPresale( address _users) onlyOwner {
651     whiteListedAddressPresale[_users] = false;
652   }
653 
654   function isWhitelisted(address _user) public constant returns (bool) {
655     return whiteListedAddress[_user];
656   }
657 
658   function isWhitelistedPresale(address _user) public constant returns (bool) {
659     return whiteListedAddressPresale[_user];
660   }
661 
662   function () payable {
663     if (validPurchasePresale()){
664       buyTokensPresale(msg.sender);
665     } else {
666       buyTokens(msg.sender);
667     }
668   }
669 
670   function buyTokens(address beneficiary) payable onlyWhitelisted {
671     require(beneficiary != 0x0);
672     require(validPurchase());
673 
674     uint256 weiAmount = msg.value;
675     uint256 tokens = calculateTokenAmount(weiAmount);
676     weiRaised = weiRaised.add(weiAmount);
677 
678     token.mint(beneficiary, tokens);
679     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
680     forwardFunds();
681   }
682 
683   function buyTokensPresale(address beneficiary) payable onlyPresaleWhitelisted {
684     require(beneficiary != 0x0);
685     require(validPurchasePresale());
686 
687     uint256 weiAmount = msg.value;
688     uint256 tokens = weiAmount.mul(PRESALERATE);
689     weiRaisedPreSale = weiRaisedPreSale.add(weiAmount);
690 
691     token.mint(beneficiary, tokens);
692     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
693     forwardFunds();
694   }
695 
696   // calculate the amount of token the user is getting - can overlap on multiple tiers.
697   function calculateTokenAmount(uint256 weiAmount) internal returns (uint256){
698     uint256 amountToBuy = weiAmount;
699     uint256 amountTokenBought;
700     uint256 currentWeiRaised = weiRaised;
701      if (currentWeiRaised < TIER1 && amountToBuy > 0) {
702        var (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,TIER1,RATE1,currentWeiRaised);
703        amountTokenBought = amountTokenBought.add(amountBoughtInTier);
704        currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
705        amountToBuy = amountLeftTobuy;
706      }
707      if (currentWeiRaised < TIER2 && amountToBuy > 0) {
708       (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,TIER2,RATE2,currentWeiRaised);
709       amountTokenBought = amountTokenBought.add(amountBoughtInTier);
710       currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
711       amountToBuy = amountLeftTobuy;
712      }
713      if (currentWeiRaised < TIER3 && amountToBuy > 0) {
714       (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,TIER3,RATE3,currentWeiRaised);
715       amountTokenBought = amountTokenBought.add(amountBoughtInTier);
716       currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
717       amountToBuy = amountLeftTobuy;
718      }
719     if ( currentWeiRaised < cap && amountToBuy > 0) {
720       (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,cap,RATE4,currentWeiRaised);
721       amountTokenBought = amountTokenBought.add(amountBoughtInTier);
722       currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
723       amountToBuy = amountLeftTobuy;
724     }
725     return amountTokenBought;
726   }
727 
728   // calculate the amount of token within a tier.
729   function calculateAmountPerTier(uint256 amountToBuy,uint256 tier,uint256 rate,uint256 currentWeiRaised) internal returns (uint256,uint256) {
730     uint256 amountAvailable = tier.sub(currentWeiRaised);
731     if ( amountToBuy > amountAvailable ) {
732       uint256 amountBoughtInTier = amountAvailable.mul(rate);
733       amountToBuy = amountToBuy.sub(amountAvailable);
734       return (amountBoughtInTier,amountToBuy);
735     } else {
736       amountBoughtInTier = amountToBuy.mul(rate);
737       return (amountBoughtInTier,0);
738     }
739   }
740 
741   function finalization() internal {
742     if (goalReached()) {
743       //Globcoin gets 100% of the amount of tokens created through the crowdsale. (50% of the total token)
744       uint256 totalSupply = token.totalSupply();
745       token.mint(wallet, totalSupply);
746       token.finishMinting();
747     }
748     super.finalization();
749   }
750 
751   // Override of the validPurchase function so that the new sale periode start at StartSale instead of Startblock.
752   function validPurchase() internal constant returns (bool) {
753     bool withinPeriod = block.number >= startSale && block.number <= endBlock;
754     bool nonZeroPurchase = msg.value != 0;
755     bool withinCap = weiRaised.add(msg.value) <= cap;
756     return withinCap && withinPeriod && nonZeroPurchase;
757   }
758 
759   // Sale period start at StartBlock until the sale Start ( startSale )
760   function validPurchasePresale() internal constant returns (bool) {
761     bool withinPeriod = block.number >= startBlock && block.number < startSale;
762     bool nonZeroPurchase = msg.value != 0;
763     bool withinCap = weiRaisedPreSale.add(msg.value) <= presaleCap;
764     return withinPeriod && nonZeroPurchase && withinCap;
765   }
766 
767   // Override of the goalReached function so that the goal take into account the token raised during the Presale.
768   function goalReached() public constant returns (bool) {
769     uint256 totalWeiRaised = weiRaisedPreSale.add(weiRaised);
770     return totalWeiRaised >= goal || super.goalReached();
771   }
772 
773 }