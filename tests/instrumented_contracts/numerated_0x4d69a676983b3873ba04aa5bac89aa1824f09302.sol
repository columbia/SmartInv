1 pragma solidity ^0.4.21;
2 
3 //-----------------------------------------
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     emit OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   /**
63   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   uint256 totalSupply_;
92 
93   /**
94   * @dev total number of tokens in existence
95   */
96   function totalSupply() public view returns (uint256) {
97     return totalSupply_;
98   }
99 
100   /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     require(_to != address(0));
107     require(_value <= balances[msg.sender]);
108 
109     // SafeMath.sub will throw if there is not enough balance.
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     emit Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public view returns (uint256 balance) {
122     return balances[_owner];
123   }
124 
125 }
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public view returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     emit Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     emit Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(address _owner, address _spender) public view returns (uint256) {
178     return allowed[_owner][_spender];
179   }
180 
181   /**
182    * @dev Increase the amount of tokens that an owner allowed to a spender.
183    *
184    * approve should be called when allowed[_spender] == 0. To increment
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param _spender The address which will spend the funds.
189    * @param _addedValue The amount of tokens to increase the allowance by.
190    */
191   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
192     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   /**
198    * @dev Decrease the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To decrement
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _subtractedValue The amount of tokens to decrease the allowance by.
206    */
207   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 contract MintableToken is StandardToken, Ownable {
220   event Mint(address indexed to, uint256 amount);
221   event MintFinished();
222 
223   bool public mintingFinished = false;
224 
225 
226   modifier canMint() {
227     require(!mintingFinished);
228     _;
229   }
230 
231   /**
232    * @dev Function to mint tokens
233    * @param _to The address that will receive the minted tokens.
234    * @param _amount The amount of tokens to mint.
235    * @return A boolean that indicates if the operation was successful.
236    */
237   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
238     totalSupply_ = totalSupply_.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     emit Mint(_to, _amount);
241     emit Transfer(address(0), _to, _amount);
242     return true;
243   }
244 
245   /**
246    * @dev Function to stop minting new tokens.
247    * @return True if the operation was successful.
248    */
249   function finishMinting() onlyOwner canMint public returns (bool) {
250     mintingFinished = true;
251     emit MintFinished();
252     return true;
253   }
254 }
255 contract BurnableToken is MintableToken {
256 
257   event Burn(address indexed burner, uint256 value);
258 
259   /**
260    * @dev Burns a specific amount of tokens.
261    * @param _value The amount of token to be burned.
262    */
263   function burn(uint256 _value) public {
264     require(_value <= balances[msg.sender]);
265     // no need to require value <= totalSupply, since that would imply the
266     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
267 
268     address burner = msg.sender;
269     balances[burner] = balances[burner].sub(_value);
270     totalSupply_ = totalSupply_.sub(_value);
271     emit Burn(burner, _value);
272     emit Transfer(burner, address(0), _value);
273   }
274 }
275 
276 contract PPToken is BurnableToken{
277     using SafeMath for uint256;
278     
279     string public constant name = "PayPortalToken";
280     
281     string public constant symbol = "PPTL";
282     
283     uint32 public constant decimals = 18;
284     
285     uint256 public freezTime;
286     
287     address internal saleAgent;
288     
289     mapping(address => uint256) preSaleBalances;
290     
291     event PreSaleTransfer(address indexed from, address indexed to, uint256 value);
292     
293     
294     function PPToken(uint256 initialSupply, uint256 _freezTime) public{
295         require(initialSupply > 0 && now <= _freezTime);
296         totalSupply_ = initialSupply * 10 ** uint256(decimals);
297         balances[owner] = totalSupply_;
298         emit Mint(owner, totalSupply_);
299         emit Transfer(0x0, owner, totalSupply_);
300         freezTime = _freezTime;
301         saleAgent = owner;
302     }
303     /*
304     function PPToken() public{
305         uint256 initialSupply = 20000;
306         uint256 _freezTime = now + (10 minutes);
307         
308         require(initialSupply > 0 && now <= _freezTime);
309         totalSupply_ = initialSupply * 10 ** uint256(decimals);
310         balances[owner] = totalSupply_;
311         emit Mint(owner, totalSupply_);
312         emit Transfer(0x0, owner, totalSupply_);
313         freezTime = _freezTime;
314         saleAgent = owner;
315     }
316     */
317     modifier onlySaleAgent() {
318         require(msg.sender == saleAgent);
319         _;
320     }
321     
322     function burnRemain() public onlySaleAgent {
323         uint256 _remSupply = balances[owner];
324         balances[owner] = 0;
325         totalSupply_ = totalSupply_.sub(_remSupply);
326 
327         emit Burn(owner, _remSupply);
328         emit Transfer(owner, address(0), _remSupply);
329         
330         mintingFinished = true;
331         emit MintFinished();
332     }
333     
334     function setSaleAgent(address _saleAgent) public onlyOwner{
335         require(_saleAgent != address(0));
336         saleAgent = _saleAgent;
337     }
338     function setFreezTime(uint256 _freezTime) public onlyOwner{
339         freezTime = _freezTime;
340     }
341     function saleTokens(address _to, uint256 _value) public onlySaleAgent returns (bool)
342     {
343         require(_to != address(0));
344         require(_value <= balances[owner]);
345     
346         // SafeMath.sub will throw if there is not enough balance.
347         balances[owner] = balances[owner].sub(_value);
348         
349         if(now > freezTime){
350             balances[_to] = balances[_to].add(_value);
351         }
352         else{
353             preSaleBalances[_to] = preSaleBalances[_to].add(_value);
354         }
355         emit Transfer(msg.sender, _to, _value);
356         return true;
357     }
358     
359     function preSaleBalancesOf(address _owner) public view returns (uint256)
360     {
361         return preSaleBalances[_owner];
362     }
363     
364     function transferPreSaleBalance(address _to, uint256 _value)public returns (bool){
365         require(now > freezTime);
366         require(_to != address(0));
367         require(_value <= preSaleBalances[msg.sender]);
368         preSaleBalances[msg.sender] = preSaleBalances[msg.sender].sub(_value);
369         balances[_to] = balances[_to].add(_value);
370         emit Transfer(msg.sender, _to, _value);
371         return true;
372     }
373 }
374 //-----------------------------------------
375 
376 contract Crowdsale {
377   using SafeMath for uint256;
378 
379   // The token being sold
380   PPToken public token;
381 
382   // Address where funds are collected
383   address public wallet;
384 
385   // How many token units a buyer gets per wei
386   uint256 public rate;
387 
388   // Amount of wei raised
389   uint256 public weiRaised;
390 
391   /**
392    * Event for token purchase logging
393    * @param purchaser who paid for the tokens
394    * @param beneficiary who got the tokens
395    * @param value weis paid for purchase
396    * @param amount amount of tokens purchased
397    */
398   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
399 
400   /**
401    * @param _rate Number of token units a buyer gets per wei
402    * @param _wallet Address where collected funds will be forwarded to
403    * @param _token Address of the token being sold
404    */
405   function Crowdsale(uint256 _rate, address _wallet, PPToken _token) public {
406     require(_rate > 0);
407     require(_wallet != address(0));
408     require(_token != address(0));
409 
410     rate = _rate;
411     wallet = _wallet;
412     token = _token;
413   }
414 
415   // -----------------------------------------
416   // Crowdsale external interface
417   // -----------------------------------------
418 
419   /**
420    * @dev fallback function ***DO NOT OVERRIDE***
421    */
422   function () external payable {
423     buyTokens(msg.sender);
424   }
425 
426   /**
427    * @dev low level token purchase ***DO NOT OVERRIDE***
428    * @param _beneficiary Address performing the token purchase
429    */
430   function buyTokens(address _beneficiary) public payable {
431 
432     uint256 weiAmount = msg.value;
433     _preValidatePurchase(_beneficiary, weiAmount);
434 
435     // calculate token amount to be created
436     uint256 totalTokens = _getTokenAmount(weiAmount);
437 
438     // update state
439     weiRaised = weiRaised.add(weiAmount);
440 
441     _processPurchase(_beneficiary, totalTokens);
442     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, totalTokens);
443 
444     _updatePurchasingState(_beneficiary, weiAmount);
445 
446     _forwardFunds();
447     _postValidatePurchase(_beneficiary, weiAmount);
448   }
449 
450   // -----------------------------------------
451   // Internal interface (extensible)
452   // -----------------------------------------
453 
454   /**
455    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
456    * @param _beneficiary Address performing the token purchase
457    * @param _weiAmount Value in wei involved in the purchase
458    */
459   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal
460   {
461         require(_beneficiary != address(0));
462         require(_weiAmount != 0);
463   }
464   /**
465    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
466    * @param _beneficiary Address performing the token purchase
467    * @param _weiAmount Value in wei involved in the purchase
468    */
469   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal
470   {}
471 
472   /**
473    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
474    * @param _beneficiary Address performing the token purchase
475    * @param _tokenAmount Number of tokens to be emitted
476    */
477   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
478     token.transfer(_beneficiary, _tokenAmount);
479   }
480 
481   /**
482    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
483    * @param _beneficiary Address receiving the tokens
484    * @param _tokenAmount Number of tokens to be purchased
485    */
486   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
487     _deliverTokens(_beneficiary, _tokenAmount);
488   }
489 
490   /**
491    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
492    * @param _beneficiary Address receiving the tokens
493    * @param _weiAmount Value in wei involved in the purchase
494    */
495   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal
496   {}
497 
498   /**
499    * @dev Override to extend the way in which ether is converted to tokens.
500    * @param _weiAmount Value in wei to be converted into tokens
501    * @return Number of tokens that can be purchased with the specified _weiAmount
502    */
503   function _getTokenAmount(uint256 _weiAmount) internal returns (uint256)
504   {
505       uint256 tokens = _weiAmount.mul(rate);
506       return tokens;
507   }
508   /**
509    * @dev Determines how ETH is stored/forwarded on purchases.
510    */
511   function _forwardFunds() internal {
512     wallet.transfer(msg.value);
513   }
514 }
515 contract AllowanceCrowdsale is Crowdsale {
516   using SafeMath for uint256;
517 
518   address public tokenWallet;
519 
520   /**
521    * @dev Constructor, takes token wallet address. 
522    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
523    */
524   function AllowanceCrowdsale(address _tokenWallet) public {
525     require(_tokenWallet != address(0));
526     tokenWallet = _tokenWallet;
527   }
528 
529   /**
530    * @dev Checks the amount of tokens left in the allowance.
531    * @return Amount of tokens left in the allowance
532    */
533   function remainingTokens() public view returns (uint256) {
534     return token.balanceOf(tokenWallet);
535   }
536 
537   /**
538    * @dev Overrides parent behavior by transferring tokens from wallet.
539    * @param _beneficiary Token purchaser
540    * @param _tokenAmount Amount of tokens purchased
541    */
542   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
543     token.saleTokens(_beneficiary, _tokenAmount);
544   }
545 }
546 contract CappedCrowdsale is Crowdsale {
547   using SafeMath for uint256;
548 
549   uint256 public cap;
550   
551 
552   /**
553    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
554    * @param _cap Max amount of wei to be contributed
555    */
556   function CappedCrowdsale(uint256 _cap) public {
557     require(_cap > 0);
558     cap = _cap;
559   }
560 
561   /**
562    * @dev Checks whether the cap has been reached. 
563    * @return Whether the cap was reached
564    */
565   function capReached() public view returns (bool) {
566     return weiRaised >= cap;
567   }
568 
569   /**
570    * @dev Extend parent behavior requiring purchase to respect the funding cap.
571    * @param _beneficiary Token purchaser
572    * @param _weiAmount Amount of wei contributed
573    */
574   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
575     super._preValidatePurchase(_beneficiary, _weiAmount);
576     require(!capReached());
577     //require(weiRaised.add(_weiAmount) <= cap);
578   }
579 
580 }
581 contract TimedCrowdsale is Crowdsale {
582   using SafeMath for uint256;
583 
584   uint256 public openingTime;
585   uint256 public closingTime;
586 
587   /**
588    * @dev Reverts if not in crowdsale time range. 
589    */
590   modifier onlyWhileOpen {
591     require(now >= openingTime && now <= closingTime);
592     _;
593   }
594 
595   /**
596    * @dev Constructor, takes crowdsale opening and closing times.
597    * @param _openingTime Crowdsale opening time
598    * @param _closingTime Crowdsale closing time
599    */
600   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
601     require(_openingTime >= now);
602     require(_closingTime >= _openingTime);
603 
604     openingTime = _openingTime;
605     closingTime = _closingTime;
606   }
607 
608   /**
609    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
610    * @return Whether crowdsale period has elapsed
611    */
612   function hasClosed() public view returns (bool) {
613     return now > closingTime;
614   }
615   
616   /**
617    * @dev Extend parent behavior requiring to be within contributing period
618    * @param _beneficiary Token purchaser
619    * @param _weiAmount Amount of wei contributed
620    */
621   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
622     super._preValidatePurchase(_beneficiary, _weiAmount);
623   }
624 
625 }
626 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
627   using SafeMath for uint256;
628 
629   bool public isFinalized = false;
630 
631   event Finalized();
632 
633   /**
634    * @dev Must be called after crowdsale ends, to do some extra finalization
635    * work. Calls the contract's finalization function.
636    */
637   function finalize() onlyOwner public {
638     require(!isFinalized);
639     require(hasClosed());
640 
641     finalization();
642     emit Finalized();
643 
644     isFinalized = true;
645   }
646 
647   /**
648    * @dev Can be overridden to add finalization logic. The overriding function
649    * should call super.finalization() to ensure the chain of finalization is
650    * executed entirely.
651    */
652   function finalization() internal
653   {
654       
655   }
656 }
657 contract WhitelistedCrowdsale is Crowdsale, Ownable {
658 
659   mapping(address => bool) public whitelist;
660   //@dev this addres that allow add or remove adresses to whiteList.
661   address whiteListAgent;
662   
663   //@dev set to whiteListAgent address
664   function setWhiteListAgent(address _agent) public onlyOwner{
665       require(_agent != address(0));
666       whiteListAgent = _agent;
667   }
668   //@dev revert if sender is whiteListAgent
669     modifier OnlyWhiteListAgent() {
670         require(msg.sender == whiteListAgent);
671         _;
672     }
673   /**
674    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
675    */
676   modifier isWhitelisted(address _beneficiary) {
677     require(whitelist[_beneficiary]);
678     _;
679   }
680   
681   function inWhiteList(address _beneficiary) public view returns(bool){
682       return whitelist[_beneficiary];
683   }
684 
685   /**
686    * @dev Adds single address to whitelist.
687    * @param _beneficiary Address to be added to the whitelist
688    */
689   function addToWhitelist(address _beneficiary) external OnlyWhiteListAgent {
690     whitelist[_beneficiary] = true;
691   }
692   
693   /**
694    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing. 
695    * @param _beneficiaries Addresses to be added to the whitelist
696    */
697   function addManyToWhitelist(address[] _beneficiaries) external OnlyWhiteListAgent {
698     for (uint256 i = 0; i < _beneficiaries.length; i++) {
699       whitelist[_beneficiaries[i]] = true;
700     }
701   }
702 
703   /**
704    * @dev Removes single address from whitelist. 
705    * @param _beneficiary Address to be removed to the whitelist
706    */
707   function removeFromWhitelist(address _beneficiary) external OnlyWhiteListAgent {
708     whitelist[_beneficiary] = false;
709   }
710 
711   /**
712    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
713    * @param _beneficiary Token beneficiary
714    * @param _weiAmount Amount of wei contributed
715    */
716   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
717         super._preValidatePurchase(_beneficiary, _weiAmount);
718   }
719 
720 }
721 
722 contract PPTL_PrivateCrowdsale is  FinalizableCrowdsale, CappedCrowdsale, WhitelistedCrowdsale, AllowanceCrowdsale{
723     using SafeMath for uint256;
724     
725     uint256 public bonusPercent;
726     uint256 public minWeiAmount;
727     
728     /*
729     function PPTokenCrowdsale(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, uint256 _cap, PPToken _token, uint256 _goal
730     , address _bountyWallet, uint256 _bountyPercent, address _teamWallet, uint256 _teamPercent) public
731         Crowdsale(_rate, _wallet, _token)
732         CappedCrowdsale(_cap)
733         TimedCrowdsale(_openingTime, _closingTime)
734         RefundableCrowdsale(_goal)
735       {
736         //As goal needs to be met for a successful crowdsale
737         //the value needs to less or equal than a cap which is limit for accepted funds
738         require(_goal <= _cap);
739         bountyWallet = _bountyWallet;
740         bountyPercent = _bountyPercent;
741         teamWallet = _teamWallet;
742         teamPercent = _teamPercent;
743         pptoken = _token;
744       }
745     */
746     function PPTL_PrivateCrowdsale( PPToken _token) public
747         Crowdsale(500, msg.sender, _token)//(_rate, _wallet, _token)
748         CappedCrowdsale((4000 ether))
749         TimedCrowdsale(1523836800, 1525564800)//(16 Apr 2018, 06 May 2018)
750         AllowanceCrowdsale(msg.sender)
751       {
752         bonusPercent = 30;
753         minWeiAmount = 100 ether;
754       }
755       
756       function finalization() internal
757       {
758           wallet.transfer(this.balance);
759           super.finalization();
760       }
761       //@dev override for get eth only after finalization
762       function _forwardFunds() internal {
763             
764       }
765       function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
766         uint256 tokens = super._getTokenAmount(_weiAmount);
767         uint256 bonus = tokens.mul(bonusPercent).div(100);
768         
769         tokens = tokens.add(bonus);
770         return tokens;
771     }
772     
773     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
774         super._preValidatePurchase(_beneficiary, _weiAmount);
775         require(_weiAmount >= minWeiAmount);
776     }
777       
778     
779 }