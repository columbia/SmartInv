1 pragma solidity ^0.4.15;
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
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold.
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126 
127   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   function Ownable() {
135     owner = msg.sender;
136   }
137 
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address newOwner) onlyOwner public {
153     require(newOwner != address(0));
154     OwnershipTransferred(owner, newOwner);
155     owner = newOwner;
156   }
157 
158 }
159 
160 contract FinalizableCrowdsale is Crowdsale, Ownable {
161   using SafeMath for uint256;
162 
163   bool public isFinalized = false;
164 
165   event Finalized();
166 
167   /**
168    * @dev Must be called after crowdsale ends, to do some extra finalization
169    * work. Calls the contract's finalization function.
170    */
171   function finalize() onlyOwner public {
172     require(!isFinalized);
173     require(hasEnded());
174 
175     finalization();
176     Finalized();
177 
178     isFinalized = true;
179   }
180 
181   /**
182    * @dev Can be overridden to add finalization logic. The overriding function
183    * should call super.finalization() to ensure the chain of finalization is
184    * executed entirely.
185    */
186   function finalization() internal {
187   }
188 }
189 
190 contract Pausable is Ownable {
191   event Pause();
192   event Unpause();
193 
194   bool public paused = false;
195 
196 
197   /**
198    * @dev Modifier to make a function callable only when the contract is not paused.
199    */
200   modifier whenNotPaused() {
201     require(!paused);
202     _;
203   }
204 
205   /**
206    * @dev Modifier to make a function callable only when the contract is paused.
207    */
208   modifier whenPaused() {
209     require(paused);
210     _;
211   }
212 
213   /**
214    * @dev called by the owner to pause, triggers stopped state
215    */
216   function pause() onlyOwner whenNotPaused public {
217     paused = true;
218     Pause();
219   }
220 
221   /**
222    * @dev called by the owner to unpause, returns to normal state
223    */
224   function unpause() onlyOwner whenPaused public {
225     paused = false;
226     Unpause();
227   }
228 }
229 
230 contract Contactable is Ownable{
231 
232     string public contactInformation;
233 
234     /**
235      * @dev Allows the owner to set a string with their contact information.
236      * @param info The contact information to attach to the contract.
237      */
238     function setContactInformation(string info) onlyOwner public {
239          contactInformation = info;
240      }
241 }
242 
243 contract HasNoContracts is Ownable {
244 
245   /**
246    * @dev Reclaim ownership of Ownable contracts
247    * @param contractAddr The address of the Ownable to be reclaimed.
248    */
249   function reclaimContract(address contractAddr) external onlyOwner {
250     Ownable contractInst = Ownable(contractAddr);
251     contractInst.transferOwnership(owner);
252   }
253 }
254 
255 contract HasNoEther is Ownable {
256 
257   /**
258   * @dev Constructor that rejects incoming Ether
259   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
260   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
261   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
262   * we could use assembly to access msg.value.
263   */
264   function HasNoEther() payable {
265     require(msg.value == 0);
266   }
267 
268   /**
269    * @dev Disallows direct send by settings a default function without the `payable` flag.
270    */
271   function() external {
272   }
273 
274   /**
275    * @dev Transfer all Ether held by the contract to the owner.
276    */
277   function reclaimEther() external onlyOwner {
278     assert(owner.send(this.balance));
279   }
280 }
281 
282 contract ERC20Basic {
283   uint256 public totalSupply;
284   function balanceOf(address who) public constant returns (uint256);
285   function transfer(address to, uint256 value) public returns (bool);
286   event Transfer(address indexed from, address indexed to, uint256 value);
287 }
288 
289 contract BasicToken is ERC20Basic {
290   using SafeMath for uint256;
291 
292   mapping(address => uint256) balances;
293 
294   /**
295   * @dev transfer token for a specified address
296   * @param _to The address to transfer to.
297   * @param _value The amount to be transferred.
298   */
299   function transfer(address _to, uint256 _value) public returns (bool) {
300     require(_to != address(0));
301 
302     // SafeMath.sub will throw if there is not enough balance.
303     balances[msg.sender] = balances[msg.sender].sub(_value);
304     balances[_to] = balances[_to].add(_value);
305     Transfer(msg.sender, _to, _value);
306     return true;
307   }
308 
309   /**
310   * @dev Gets the balance of the specified address.
311   * @param _owner The address to query the the balance of.
312   * @return An uint256 representing the amount owned by the passed address.
313   */
314   function balanceOf(address _owner) public constant returns (uint256 balance) {
315     return balances[_owner];
316   }
317 
318 }
319 
320 contract ERC20 is ERC20Basic {
321   function allowance(address owner, address spender) public constant returns (uint256);
322   function transferFrom(address from, address to, uint256 value) public returns (bool);
323   function approve(address spender, uint256 value) public returns (bool);
324   event Approval(address indexed owner, address indexed spender, uint256 value);
325 }
326 
327 library SafeERC20 {
328   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
329     assert(token.transfer(to, value));
330   }
331 
332   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
333     assert(token.transferFrom(from, to, value));
334   }
335 
336   function safeApprove(ERC20 token, address spender, uint256 value) internal {
337     assert(token.approve(spender, value));
338   }
339 }
340 
341 contract CanReclaimToken is Ownable {
342   using SafeERC20 for ERC20Basic;
343 
344   /**
345    * @dev Reclaim all ERC20Basic compatible tokens
346    * @param token ERC20Basic The address of the token contract
347    */
348   function reclaimToken(ERC20Basic token) external onlyOwner {
349     uint256 balance = token.balanceOf(this);
350     token.safeTransfer(owner, balance);
351   }
352 
353 }
354 
355 contract HasNoTokens is CanReclaimToken {
356 
357  /**
358   * @dev Reject all ERC23 compatible tokens
359   * @param from_ address The address that is transferring the tokens
360   * @param value_ uint256 the amount of the specified token
361   * @param data_ Bytes The data passed from the caller.
362   */
363   function tokenFallback(address from_, uint256 value_, bytes data_) external {
364     revert();
365   }
366 
367 }
368 
369 contract StandardToken is ERC20, BasicToken {
370 
371   mapping (address => mapping (address => uint256)) allowed;
372 
373 
374   /**
375    * @dev Transfer tokens from one address to another
376    * @param _from address The address which you want to send tokens from
377    * @param _to address The address which you want to transfer to
378    * @param _value uint256 the amount of tokens to be transferred
379    */
380   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
381     require(_to != address(0));
382 
383     uint256 _allowance = allowed[_from][msg.sender];
384 
385     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
386     // require (_value <= _allowance);
387 
388     balances[_from] = balances[_from].sub(_value);
389     balances[_to] = balances[_to].add(_value);
390     allowed[_from][msg.sender] = _allowance.sub(_value);
391     Transfer(_from, _to, _value);
392     return true;
393   }
394 
395   /**
396    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
397    *
398    * Beware that changing an allowance with this method brings the risk that someone may use both the old
399    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
400    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
401    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402    * @param _spender The address which will spend the funds.
403    * @param _value The amount of tokens to be spent.
404    */
405   function approve(address _spender, uint256 _value) public returns (bool) {
406     allowed[msg.sender][_spender] = _value;
407     Approval(msg.sender, _spender, _value);
408     return true;
409   }
410 
411   /**
412    * @dev Function to check the amount of tokens that an owner allowed to a spender.
413    * @param _owner address The address which owns the funds.
414    * @param _spender address The address which will spend the funds.
415    * @return A uint256 specifying the amount of tokens still available for the spender.
416    */
417   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
418     return allowed[_owner][_spender];
419   }
420 
421   /**
422    * approve should be called when allowed[_spender] == 0. To increment
423    * allowed value is better to use this function to avoid 2 calls (and wait until
424    * the first transaction is mined)
425    * From MonolithDAO Token.sol
426    */
427   function increaseApproval (address _spender, uint _addedValue)
428     returns (bool success) {
429     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
430     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
431     return true;
432   }
433 
434   function decreaseApproval (address _spender, uint _subtractedValue)
435     returns (bool success) {
436     uint oldValue = allowed[msg.sender][_spender];
437     if (_subtractedValue > oldValue) {
438       allowed[msg.sender][_spender] = 0;
439     } else {
440       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
441     }
442     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
443     return true;
444   }
445 
446 }
447 
448 contract MintableToken is StandardToken, Ownable {
449   event Mint(address indexed to, uint256 amount);
450   event MintFinished();
451 
452   bool public mintingFinished = false;
453 
454 
455   modifier canMint() {
456     require(!mintingFinished);
457     _;
458   }
459 
460   /**
461    * @dev Function to mint tokens
462    * @param _to The address that will receive the minted tokens.
463    * @param _amount The amount of tokens to mint.
464    * @return A boolean that indicates if the operation was successful.
465    */
466   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
467     totalSupply = totalSupply.add(_amount);
468     balances[_to] = balances[_to].add(_amount);
469     Mint(_to, _amount);
470     Transfer(0x0, _to, _amount);
471     return true;
472   }
473 
474   /**
475    * @dev Function to stop minting new tokens.
476    * @return True if the operation was successful.
477    */
478   function finishMinting() onlyOwner public returns (bool) {
479     mintingFinished = true;
480     MintFinished();
481     return true;
482   }
483 }
484 
485 contract PausableToken is StandardToken, Pausable {
486 
487   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
488     return super.transfer(_to, _value);
489   }
490 
491   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
492     return super.transferFrom(_from, _to, _value);
493   }
494 
495   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
496     return super.approve(_spender, _value);
497   }
498 
499   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
500     return super.increaseApproval(_spender, _addedValue);
501   }
502 
503   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
504     return super.decreaseApproval(_spender, _subtractedValue);
505   }
506 }
507 
508 contract FlipCrowdsale is Contactable, Pausable, HasNoContracts, HasNoTokens, FinalizableCrowdsale {
509     using SafeMath for uint256;
510 
511     uint256 public tokensSold = 0;
512 
513     // ignore the Crowdsale.rate and dynamically compute rate based on other factors (e.g. purchase amount, time, etc)
514     function FlipCrowdsale(MintableToken _token, uint256 _startTime, uint256 _endTime, address _ethWallet)
515     Ownable()
516     Pausable()
517     Contactable()
518     HasNoTokens()
519     HasNoContracts()
520     Crowdsale(_startTime, _endTime, 1, _ethWallet)
521     FinalizableCrowdsale()
522     {
523         // deployment must set token.owner = FlipCrowdsale.address to allow minting
524         token = _token;
525         contactInformation = 'https://tokensale.gameflip.com/';
526     }
527 
528     function setWallet(address _wallet) onlyOwner public {
529         require(_wallet != 0x0);
530         wallet = _wallet;
531     }
532 
533     // over-ridden low level token purchase function so that we
534     // can control the token-per-wei exchange rate dynamically
535     function buyTokens(address beneficiary) public payable whenNotPaused {
536         require(beneficiary != 0x0);
537         require(validPurchase());
538 
539         uint256 weiAmount = msg.value;
540 
541         // calculate token amount to be created
542         uint256 tokens = applyExchangeRate(weiAmount);
543 
544         // update state
545         weiRaised = weiRaised.add(weiAmount);
546         tokensSold = tokensSold.add(tokens);
547 
548         token.mint(beneficiary, tokens);
549         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
550 
551         forwardFunds();
552     }
553 
554     function tokenTransferOwnership(address newOwner) public onlyOwner {
555         require(hasEnded());
556         token.transferOwnership(newOwner);
557     }
558 
559     /**
560     * @dev Allows the current owner to transfer control of the contract to a newOwner.
561     * @param newOwner The address to transfer ownership to.
562     */
563     function transferOwnership(address newOwner) onlyOwner public {
564         // do not allow self ownership
565         require(newOwner != address(this));
566         super.transferOwnership(newOwner);
567     }
568 
569     // overriding Crowdsale#hasEnded to add cap logic
570     // @return true if crowdsale event has ended
571     function hasEnded() public constant returns (bool) {
572         bool capReached = tokensRemaining() == 0;
573         return super.hasEnded() || capReached;
574     }
575 
576     // sub-classes must override to control tokens sales cap
577     function tokensRemaining() constant public returns (uint256);
578 
579 
580     /*
581      * internal functions
582      */
583     function createTokenContract() internal returns (MintableToken) {
584         return token;
585     }
586 
587     // sub-classes must override to customize token-per-wei exchange rate
588     function applyExchangeRate(uint256 _wei) constant internal returns (uint256);
589 
590     /**
591        * @dev Can be overridden to add finalization logic. The overriding function
592        * should call super.finalization() to ensure the chain of finalization is
593        * executed entirely.
594        */
595     function finalization() internal {
596         // if we own the token, pass ownership to our owner when finalized
597         if(address(token) != address(0) && token.owner() == address(this) && owner != address(0)) {
598             token.transferOwnership(owner);
599         }
600         super.finalization();
601     }
602 }
603 
604 contract FlipToken is Contactable, HasNoTokens, HasNoEther, MintableToken, PausableToken {
605 
606     string public constant name = "FLIP Token";
607     string public constant symbol = "FLP";
608     uint8 public constant decimals = 18;
609 
610     uint256 public constant ONE_TOKENS = (10 ** uint256(decimals));
611     uint256 public constant MILLION_TOKENS = (10**6) * ONE_TOKENS;
612     uint256 public constant TOTAL_TOKENS = 100 * MILLION_TOKENS;
613 
614     function FlipToken()
615     Ownable()
616     Contactable()
617     HasNoTokens()
618     HasNoEther()
619     MintableToken()
620     PausableToken()
621     {
622         contactInformation = 'https://tokensale.gameflip.com/';
623     }
624 
625     // cap minting so that totalSupply <= TOTAL_TOKENS
626     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
627         require(totalSupply.add(_amount) <= TOTAL_TOKENS);
628         return super.mint(_to, _amount);
629     }
630 
631 
632     /**
633     * @dev Allows the current owner to transfer control of the contract to a newOwner.
634     * @param newOwner The address to transfer ownership to.
635     */
636     function transferOwnership(address newOwner) onlyOwner public {
637         // do not allow self ownership
638         require(newOwner != address(this));
639         super.transferOwnership(newOwner);
640     }
641 }
642 
643 contract PreSale is FlipCrowdsale {
644     using SafeMath for uint256;
645 
646     uint256 public constant PRESALE_TOKEN_CAP = 238 * (10**4) * (10 ** uint256(18)); // 2.38 million tokens
647     uint256 public minPurchaseAmt = 3 ether;
648 
649     function PreSale(MintableToken _token, uint256 _startTime, uint256 _endTime, address _ethWallet)
650     FlipCrowdsale(_token, _startTime, _endTime, _ethWallet)
651     {
652     }
653 
654     function setMinPurchaseAmt(uint256 _wei) onlyOwner public {
655         require(_wei >= 0);
656         minPurchaseAmt = _wei;
657     }
658 
659     function tokensRemaining() constant public returns (uint256) {
660         return PRESALE_TOKEN_CAP.sub(tokensSold);
661     }
662 
663     /*
664      * internal functions
665      */
666 
667     function applyExchangeRate(uint256 _wei) constant internal returns (uint256) {
668         // white paper (6.3 Token Pre-Sale) specifies rates based on purchase value
669         // those values here hard-coded here
670         require(_wei >= minPurchaseAmt);
671         uint256 tokens;
672         if(_wei >= 5000 ether) {
673             tokens = _wei.mul(340);
674         } else if(_wei >= 3000 ether) {
675             tokens = _wei.mul(320);
676         } else if(_wei >= 1000 ether) {
677             tokens = _wei.mul(300);
678         } else if(_wei >= 100 ether) {
679             tokens = _wei.mul(280);
680         } else {
681             tokens = _wei.mul(260);
682         }
683         // check token cap
684         uint256 remaining = tokensRemaining();
685         require(remaining >= tokens);
686         // if remaining tokens cannot be purchased (at min rate) then gift to current buyer ... it's a sellout!
687         uint256 min_tokens_purchasable = minPurchaseAmt.mul(260);
688         remaining = remaining.sub(tokens);
689         if(remaining < min_tokens_purchasable) {
690             tokens = tokens.add(remaining);
691         }
692         return tokens;
693     }
694 
695 }
696 
697 contract PrivateSale is PreSale {
698     using SafeMath for uint256;
699 
700     uint256 public constant TOKEN_CAP = 158 * (10**4) * (10 ** uint256(18)); // 1.58 million tokens
701 
702     function PrivateSale(MintableToken _token, uint256 _startTime, uint256 _endTime, address _ethWallet)
703     PreSale(_token, _startTime, _endTime, _ethWallet)
704     {
705         minPurchaseAmt = 100 ether;
706     }
707 
708     function tokensRemaining() constant public returns (uint256) {
709         return TOKEN_CAP.sub(tokensSold);
710     }
711 
712 }