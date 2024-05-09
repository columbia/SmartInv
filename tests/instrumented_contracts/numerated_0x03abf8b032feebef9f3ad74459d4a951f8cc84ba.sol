1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) onlyOwner {
71     require(newOwner != address(0));      
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) constant returns (uint256);
86   function transfer(address to, uint256 value) returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) constant returns (uint256);
96   function transferFrom(address from, address to, uint256 value) returns (bool);
97   function approve(address spender, uint256 value) returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances. 
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) returns (bool) {
118     require(_to != address(0));
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of. 
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) constant returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
158     require(_to != address(0));
159 
160     var _allowance = allowed[_from][msg.sender];
161 
162     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
163     // require (_value <= _allowance);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = _allowance.sub(_value);
168     Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) returns (bool) {
178 
179     // To change the approve amount you first have to reduce the addresses`
180     //  allowance to zero by calling `approve(_spender, 0)` if it is not
181     //  already 0 to mitigate the race condition described here:
182     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
184 
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
197     return allowed[_owner][_spender];
198   }
199   
200   /**
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until 
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    */
206   function increaseApproval (address _spender, uint _addedValue) 
207     returns (bool success) {
208     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213   function decreaseApproval (address _spender, uint _subtractedValue) 
214     returns (bool success) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 /**
228  * @title Mintable token
229  * @dev Simple ERC20 Token example, with mintable token creation
230  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
231  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
232  */
233 
234 contract MintableToken is StandardToken, Ownable {
235   event Mint(address indexed to, uint256 amount);
236   event MintFinished();
237 
238   bool public mintingFinished = false;
239 
240 
241   modifier canMint() {
242     require(!mintingFinished);
243     _;
244   }
245 
246   /**
247    * @dev Function to mint tokens
248    * @param _to The address that will receive the minted tokens.
249    * @param _amount The amount of tokens to mint.
250    * @return A boolean that indicates if the operation was successful.
251    */
252   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
253     totalSupply = totalSupply.add(_amount);
254     balances[_to] = balances[_to].add(_amount);
255     Mint(_to, _amount);
256     Transfer(0x0, _to, _amount);
257     return true;
258   }
259 
260   /**
261    * @dev Function to stop minting new tokens.
262    * @return True if the operation was successful.
263    */
264   function finishMinting() onlyOwner returns (bool) {
265     mintingFinished = true;
266     MintFinished();
267     return true;
268   }
269 }
270 
271 
272 /**
273  * @title Crowdsale
274  * @dev Crowdsale is a base contract for managing a token crowdsale.
275  * Crowdsales have a start and end blocks, where investors can make
276  * token purchases and the crowdsale will assign them tokens based
277  * on a token per ETH rate. Funds collected are forwarded to a wallet
278  * as they arrive.
279  */
280 contract Crowdsale {
281   using SafeMath for uint256;
282   // The token being sold
283   MintableToken public token;
284 
285   // start and end blocks where investments are allowed (both inclusive)
286   uint256 public startBlock;
287   uint256 public endBlock;
288 
289   // address where funds are collected
290   address public wallet;
291 
292   // amount of raised money in wei
293   uint256 public weiRaised;
294 
295   // how many token units a buyer gets per wei
296   uint256 public rate;
297 
298 
299   /**
300    * event for token purchase logging
301    * @param purchaser who paid for the tokens
302    * @param beneficiary who got the tokens
303    * @param value weis paid for purchase
304    * @param amount amount of tokens purchased
305    */
306   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
307 
308 
309   function Crowdsale(uint256 _startBlock, uint256 _endBlock, address _wallet) {
310     require(_startBlock >= block.number);
311     require(_endBlock >= _startBlock);
312     require(_wallet != 0x0);
313 
314     token = createTokenContract();
315     startBlock = _startBlock;
316     endBlock = _endBlock;
317     wallet = _wallet;
318   }
319 
320   // creates the token to be sold.
321   // override this method to have crowdsale of a specific mintable token.
322   function createTokenContract() internal returns (MintableToken) {
323     return new MintableToken();
324   }
325 
326 
327   // fallback function can be used to buy tokens
328   function () payable {
329     buyTokens(msg.sender);
330   }
331 
332 
333   // low level token purchase function
334   function buyTokens(address beneficiary) public payable {
335     require(beneficiary != 0x0);
336     require(validPurchase());
337 
338     uint256 weiAmount = msg.value;
339 
340     // calculate token amount to be created
341     uint256 tokens = weiAmount.mul(rate);
342 
343     // update state
344     weiRaised = weiRaised.add(weiAmount);
345 
346     token.mint(beneficiary, tokens);
347     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
348 
349     forwardFunds();
350   }
351 
352 
353   // send ether to the fund collection wallet
354   // override to create custom fund forwarding mechanisms
355   function forwardFunds() internal {
356     wallet.transfer(msg.value);
357   }
358 
359   // @return true if the transaction can buy tokens
360   function validPurchase() internal constant returns (bool) {
361     bool withinPeriod = block.number >= startBlock && block.number <= endBlock;
362     bool nonZeroPurchase = msg.value != 0;
363     return withinPeriod && nonZeroPurchase;
364   }
365 
366   // @return true if crowdsale event has ended
367   function hasEnded() public constant returns (bool) {
368     return block.number > endBlock;
369   }
370 
371 
372 }
373 
374 
375 /**
376  * @title CappedCrowdsale
377  * @dev Extension of Crowsdale with a max amount of funds raised
378  */
379 contract CappedCrowdsale is Crowdsale {
380   using SafeMath for uint256;
381 
382   uint256 public cap;
383 
384   function CappedCrowdsale(uint256 _cap) {
385     require(_cap > 0);
386     cap = _cap;
387   }
388 
389   // overriding Crowdsale#validPurchase to add extra cap logic
390   // @return true if investors can buy at the moment
391   function validPurchase() internal constant returns (bool) {
392     bool withinCap = weiRaised.add(msg.value) <= cap;
393     return super.validPurchase() && withinCap;
394   }
395 
396   // overriding Crowdsale#hasEnded to add cap logic
397   // @return true if crowdsale event has ended
398   function hasEnded() public constant returns (bool) {
399     bool capReached = weiRaised >= cap;
400     return super.hasEnded() || capReached;
401   }
402 
403 }
404 
405 /**
406  * @title FinalizableCrowdsale
407  * @dev Extension of Crowsdale where an owner can do extra work
408  * after finishing. 
409  */
410 contract FinalizableCrowdsale is Crowdsale, Ownable {
411   using SafeMath for uint256;
412 
413   bool public isFinalized = false;
414 
415   event Finalized();
416 
417   /**
418    * @dev Must be called after crowdsale ends, to do some extra finalization
419    * work. Calls the contract's finalization function.
420    */
421   function finalize() onlyOwner {
422     require(!isFinalized);
423     require(hasEnded());
424 
425     finalization();
426     Finalized();
427     
428     isFinalized = true;
429   }
430 
431   /**
432    * @dev Can be overriden to add finalization logic. The overriding function
433    * should call super.finalization() to ensure the chain of finalization is
434    * executed entirely.
435    */
436   function finalization() internal {
437   }
438 }
439 
440 
441 /**
442  * @title RefundVault
443  * @dev This contract is used for storing funds while a crowdsale
444  * is in progress. Supports refunding the money if crowdsale fails,
445  * and forwarding it if crowdsale is successful.
446  */
447 contract RefundVault is Ownable {
448   using SafeMath for uint256;
449 
450   enum State { Active, Refunding, Closed }
451 
452   mapping (address => uint256) public deposited;
453   address public wallet;
454   State public state;
455 
456   event Closed();
457   event RefundsEnabled();
458   event Refunded(address indexed beneficiary, uint256 weiAmount);
459 
460   function RefundVault(address _wallet) {
461     require(_wallet != 0x0);
462     wallet = _wallet;
463     state = State.Active;
464   }
465 
466   function deposit(address investor) onlyOwner payable {
467     require(state == State.Active);
468     deposited[investor] = deposited[investor].add(msg.value);
469   }
470 
471   function close() onlyOwner {
472     require(state == State.Active);
473     state = State.Closed;
474     Closed();
475     wallet.transfer(this.balance);
476   }
477 
478   function enableRefunds() onlyOwner {
479     require(state == State.Active);
480     state = State.Refunding;
481     RefundsEnabled();
482   }
483 
484   function refund(address investor) {
485     require(state == State.Refunding);
486     uint256 depositedValue = deposited[investor];
487     deposited[investor] = 0;
488     investor.transfer(depositedValue);
489     Refunded(investor, depositedValue);
490   }
491 }
492 
493 
494 /**
495  * @title RefundableCrowdsale
496  * @dev Extension of Crowdsale contract that adds a funding goal, and
497  * the possibility of users getting a refund if goal is not met.
498  * Uses a RefundVault as the crowdsale's vault.
499  */
500 contract RefundableCrowdsale is FinalizableCrowdsale {
501   using SafeMath for uint256;
502 
503   // minimum amount of funds to be raised in weis
504   uint256 public goal;
505 
506   // refund vault used to hold funds while crowdsale is running
507   RefundVault public vault;
508 
509   function RefundableCrowdsale(uint256 _goal) {
510     require(_goal > 0);
511     vault = new RefundVault(wallet);
512     goal = _goal;
513   }
514 
515   // We're overriding the fund forwarding from Crowdsale.
516   // In addition to sending the funds, we want to call
517   // the RefundVault deposit function
518   function forwardFunds() internal {
519     vault.deposit.value(msg.value)(msg.sender);
520   }
521 
522   // if crowdsale is unsuccessful, investors can claim refunds here
523   function claimRefund() {
524     require(isFinalized);
525     require(!goalReached());
526 
527     vault.refund(msg.sender);
528   }
529 
530   // vault finalization task, called when owner calls finalize()
531   function finalization() internal {
532     if (goalReached()) {
533       vault.close();
534     } else {
535       vault.enableRefunds();
536     }
537 
538     super.finalization();
539   }
540 
541   function goalReached() public constant returns (bool) {
542     return weiRaised >= goal;
543   }
544 
545 }
546 
547 contract GlobCoinToken is MintableToken {
548   using SafeMath for uint256;
549   string public constant name = "GlobCoin Crypto Platform";
550   string public constant symbol = "GCP";
551   uint8 public constant decimals = 18;
552 
553   modifier onlyMintingFinished() {
554     require(mintingFinished == true);
555     _;
556   }
557   /// @dev Same ERC20 behavior, but require the token to be unlocked
558   /// @param _spender address The address which will spend the funds.
559   /// @param _value uint256 The amount of tokens to be spent.
560   function approve(address _spender, uint256 _value) public onlyMintingFinished returns (bool) {
561       return super.approve(_spender, _value);
562   }
563 
564   /// @dev Same ERC20 behavior, but require the token to be unlocked
565   /// @param _to address The address to transfer to.
566   /// @param _value uint256 The amount to be transferred.
567   function transfer(address _to, uint256 _value) public onlyMintingFinished returns (bool) {
568       return super.transfer(_to, _value);
569   }
570 
571   /// @dev Same ERC20 behavior, but require the token to be unlocked
572   /// @param _from address The address which you want to send tokens from.
573   /// @param _to address The address which you want to transfer to.
574   /// @param _value uint256 the amount of tokens to be transferred.
575   function transferFrom(address _from, address _to, uint256 _value) public onlyMintingFinished returns (bool) {
576     return super.transferFrom(_from, _to, _value);
577   }
578 
579 }
580 
581 contract GlobcoinTokenSale is CappedCrowdsale, RefundableCrowdsale {
582 
583   //Start of the Actual crowdsale. Starblock is the start of the presale.
584   uint256 public startSale;
585   uint256 public endPresale;
586 
587   // Presale Rate per wei ~30% bonus over rate1
588   uint256 public constant PRESALERATE = 17000;
589 
590   // new rates
591   uint256 public constant RATE1 = 13000;
592   uint256 public constant RATE2 = 12000;
593   uint256 public constant RATE3 = 11000;
594   uint256 public constant RATE4 = 10000;
595 
596 
597   // Cap per tier for bonus in wei.
598   uint256 public constant TIER1 =  3000000000000000000000;
599   uint256 public constant TIER2 =  5000000000000000000000;
600   uint256 public constant TIER3 =  7500000000000000000000;
601 
602   //Presale
603   uint256 public weiRaisedPreSale;
604   uint256 public presaleCap;
605 
606   function GlobcoinTokenSale(uint256 _startBlock, uint256 _endPresale, uint256 _startSale, uint256 _endBlock, uint256 _goal,uint256 _presaleCap, uint256 _cap, address _wallet) public
607   CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startBlock, _endBlock, _wallet) {
608     require(_goal <= _cap);
609     require(_startSale > _startBlock);
610     require(_endBlock > _startSale);
611     require(_presaleCap > 0);
612     require(_presaleCap <= _cap);
613 
614     startSale = _startSale;
615     endPresale = _endPresale;
616     presaleCap = _presaleCap;
617   }
618 
619   function createTokenContract() internal returns (MintableToken) {
620     return new GlobCoinToken();
621   }
622 
623   //white listed address
624   mapping (address => bool) public whiteListedAddress;
625   mapping (address => bool) public whiteListedAddressPresale;
626 
627   modifier onlyPresaleWhitelisted() {
628     require( isWhitelistedPresale(msg.sender) ) ;
629     _;
630   }
631 
632   modifier onlyWhitelisted() {
633     require( isWhitelisted(msg.sender) || isWhitelistedPresale(msg.sender) ) ;
634     _;
635   }
636 
637   /**
638    * @dev Add a list of address to be whitelisted for the crowdsale only.
639    * @param _users , the list of user Address. Tested for out of gas until 200 addresses.
640    */
641   function whitelistAddresses( address[] _users) onlyOwner {
642     for( uint i = 0 ; i < _users.length ; i++ ) {
643       whiteListedAddress[_users[i]] = true;
644     }
645   }
646 
647   function unwhitelistAddress( address _users) onlyOwner {
648     whiteListedAddress[_users] = false;
649   }
650 
651   /**
652    * @dev Add a list of address to be whitelisted for the Presale And sale.
653    * @param _users , the list of user Address. Tested for out of gas until 200 addresses.
654    */
655   function whitelistAddressesPresale( address[] _users) onlyOwner {
656     for( uint i = 0 ; i < _users.length ; i++ ) {
657       whiteListedAddressPresale[_users[i]] = true;
658     }
659   }
660 
661   function unwhitelistAddressPresale( address _users) onlyOwner {
662     whiteListedAddressPresale[_users] = false;
663   }
664 
665   function isWhitelisted(address _user) public constant returns (bool) {
666     return whiteListedAddress[_user];
667   }
668 
669   function isWhitelistedPresale(address _user) public constant returns (bool) {
670     return whiteListedAddressPresale[_user];
671   }
672 
673   function () payable {
674     if (validPurchasePresale()){
675       buyTokensPresale(msg.sender);
676     } else {
677       buyTokens(msg.sender);
678     }
679   }
680 
681   function buyTokens(address beneficiary) payable onlyWhitelisted {
682     require(beneficiary != 0x0);
683     require(validPurchase());
684 
685     uint256 weiAmount = msg.value;
686     uint256 tokens = calculateTokenAmount(weiAmount);
687     weiRaised = weiRaised.add(weiAmount);
688 
689     token.mint(beneficiary, tokens);
690     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
691     forwardFunds();
692   }
693 
694   function buyTokensPresale(address beneficiary) payable onlyPresaleWhitelisted {
695     require(beneficiary != 0x0);
696     require(validPurchasePresale());
697 
698     uint256 weiAmount = msg.value;
699     uint256 tokens = weiAmount.mul(PRESALERATE);
700     weiRaisedPreSale = weiRaisedPreSale.add(weiAmount);
701 
702     token.mint(beneficiary, tokens);
703     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
704     forwardFunds();
705   }
706 
707   // calculate the amount of token the user is getting - can overlap on multiple tiers.
708   function calculateTokenAmount(uint256 weiAmount) internal returns (uint256){
709     uint256 amountToBuy = weiAmount;
710     uint256 amountTokenBought;
711     uint256 currentWeiRaised = weiRaised;
712      if (currentWeiRaised < TIER1 && amountToBuy > 0) {
713        var (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,TIER1,RATE1,currentWeiRaised);
714        amountTokenBought = amountTokenBought.add(amountBoughtInTier);
715        currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
716        amountToBuy = amountLeftTobuy;
717      }
718      if (currentWeiRaised < TIER2 && amountToBuy > 0) {
719       (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,TIER2,RATE2,currentWeiRaised);
720       amountTokenBought = amountTokenBought.add(amountBoughtInTier);
721       currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
722       amountToBuy = amountLeftTobuy;
723      }
724      if (currentWeiRaised < TIER3 && amountToBuy > 0) {
725       (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,TIER3,RATE3,currentWeiRaised);
726       amountTokenBought = amountTokenBought.add(amountBoughtInTier);
727       currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
728       amountToBuy = amountLeftTobuy;
729      }
730     if ( currentWeiRaised < cap && amountToBuy > 0) {
731       (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,cap,RATE4,currentWeiRaised);
732       amountTokenBought = amountTokenBought.add(amountBoughtInTier);
733       currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
734       amountToBuy = amountLeftTobuy;
735     }
736     return amountTokenBought;
737   }
738 
739   // calculate the amount of token within a tier.
740   function calculateAmountPerTier(uint256 amountToBuy,uint256 tier,uint256 rate,uint256 currentWeiRaised) internal returns (uint256,uint256) {
741     uint256 amountAvailable = tier.sub(currentWeiRaised);
742     if ( amountToBuy > amountAvailable ) {
743       uint256 amountBoughtInTier = amountAvailable.mul(rate);
744       amountToBuy = amountToBuy.sub(amountAvailable);
745       return (amountBoughtInTier,amountToBuy);
746     } else {
747       amountBoughtInTier = amountToBuy.mul(rate);
748       return (amountBoughtInTier,0);
749     }
750   }
751 
752   function finalization() internal {
753     if (goalReached()) {
754       //Globcoin gets 60% of the amount of the total token supply
755       uint256 totalSupply = token.totalSupply();
756       // total supply
757       token.mint(wallet, totalSupply);
758       // 50% of tokens generated during crowdsale to make it 60% for GC
759       token.mint(wallet, totalSupply.div(2));
760       token.finishMinting();
761     }
762     super.finalization();
763   }
764 
765   // Override of the validPurchase function so that the new sale periode start at StartSale instead of Startblock.
766   function validPurchase() internal constant returns (bool) {
767     bool withinPeriod = block.number >= startSale && block.number <= endBlock;
768     bool nonZeroPurchase = msg.value != 0;
769     uint256 totalWeiRaised = weiRaisedPreSale.add(weiRaised);
770     bool withinCap = totalWeiRaised.add(msg.value) <= cap;
771     return withinCap && withinPeriod && nonZeroPurchase;
772   }
773 
774   // Sale period start at StartBlock until the sale Start ( startSale )
775   function validPurchasePresale() internal constant returns (bool) {
776     bool withinPeriod = (block.number >= startBlock) && (block.number <= endPresale);
777     bool nonZeroPurchase = msg.value != 0;
778     bool withinCap = weiRaisedPreSale.add(msg.value) <= presaleCap;
779     return withinPeriod && nonZeroPurchase && withinCap;
780   }
781 
782   // Override of the goalReached function so that the goal take into account the token raised during the Presale.
783   function goalReached() public constant returns (bool) {
784     uint256 totalWeiRaised = weiRaisedPreSale.add(weiRaised);
785     return totalWeiRaised >= goal || super.goalReached();
786   }
787 
788 }