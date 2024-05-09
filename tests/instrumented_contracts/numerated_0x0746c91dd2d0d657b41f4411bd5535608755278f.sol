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
289     
290     function PPToken(uint256 initialSupply, uint256 _freezTime) public{
291         require(initialSupply > 0 && now <= _freezTime);
292         totalSupply_ = initialSupply * 10 ** uint256(decimals);
293         balances[owner] = totalSupply_;
294         emit Mint(owner, totalSupply_);
295         emit Transfer(0x0, owner, totalSupply_);
296         freezTime = _freezTime;
297         saleAgent = owner;
298     }
299 
300     modifier onlySaleAgent() {
301         require(msg.sender == saleAgent);
302         _;
303     }
304     
305     function burnRemain() public onlySaleAgent {
306         uint256 _remSupply = balances[owner];
307         balances[owner] = 0;
308         totalSupply_ = totalSupply_.sub(_remSupply);
309 
310         emit Burn(owner, _remSupply);
311         emit Transfer(owner, address(0), _remSupply);
312         
313         mintingFinished = true;
314         emit MintFinished();
315     }
316     
317     function setSaleAgent(address _saleAgent) public onlyOwner{
318         require(_saleAgent != address(0));
319         saleAgent = _saleAgent;
320     }
321     
322     function setFreezTime(uint256 _freezTime) public onlyOwner{
323         require(_freezTime <= 1531699200);//16 july 2018
324         freezTime = _freezTime;
325     }
326     
327     function saleTokens(address _to, uint256 _value) public onlySaleAgent returns (bool){
328         require(_to != address(0));
329         require(_value <= balances[owner]);
330     
331         // SafeMath.sub will throw if there is not enough balance.
332         balances[owner] = balances[owner].sub(_value);
333         balances[_to] = balances[_to].add(_value);
334         
335         emit Transfer(owner, _to, _value);
336         
337         return true;
338     }
339     function hasPastFreezTime() public view returns(bool){
340         return now >= freezTime;
341     }
342     
343     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
344         require(hasPastFreezTime());
345         return super.transferFrom(_from, _to, _value);
346     }
347     
348     function transfer(address _to, uint256 _value) public returns (bool) {
349         require(hasPastFreezTime());
350         return super.transfer(_to, _value);
351     }
352 }
353 //-----------------------------------------
354 
355 contract Crowdsale {
356   using SafeMath for uint256;
357 
358   // The token being sold
359   PPToken public token;
360 
361   // Address where funds are collected
362   address public wallet;
363 
364   // How many token units a buyer gets per wei
365   uint256 public rate;
366 
367   // Amount of wei raised
368   uint256 public weiRaised;
369 
370   /**
371    * Event for token purchase logging
372    * @param purchaser who paid for the tokens
373    * @param beneficiary who got the tokens
374    * @param value weis paid for purchase
375    * @param amount amount of tokens purchased
376    */
377   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
378 
379   /**
380    * @param _rate Number of token units a buyer gets per wei
381    * @param _wallet Address where collected funds will be forwarded to
382    * @param _token Address of the token being sold
383    */
384   function Crowdsale(uint256 _rate, address _wallet, PPToken _token) public {
385     require(_rate > 0);
386     require(_wallet != address(0));
387     require(_token != address(0));
388 
389     rate = _rate;
390     wallet = _wallet;
391     token = _token;
392   }
393 
394   // -----------------------------------------
395   // Crowdsale external interface
396   // -----------------------------------------
397 
398   /**
399    * @dev fallback function ***DO NOT OVERRIDE***
400    */
401   function () external payable {
402     buyTokens(msg.sender);
403   }
404 
405   /**
406    * @dev low level token purchase ***DO NOT OVERRIDE***
407    * @param _beneficiary Address performing the token purchase
408    */
409   function buyTokens(address _beneficiary) public payable {
410 
411     uint256 weiAmount = msg.value;
412     _preValidatePurchase(_beneficiary, weiAmount);
413 
414     // calculate token amount to be created
415     uint256 totalTokens = _getTokenAmount(weiAmount);
416 
417     // update state
418     weiRaised = weiRaised.add(weiAmount);
419 
420     _processPurchase(_beneficiary, totalTokens);
421     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, totalTokens);
422 
423     _updatePurchasingState(_beneficiary, weiAmount);
424 
425     _forwardFunds();
426     _postValidatePurchase(_beneficiary, weiAmount);
427   }
428 
429   // -----------------------------------------
430   // Internal interface (extensible)
431   // -----------------------------------------
432 
433   /**
434    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
435    * @param _beneficiary Address performing the token purchase
436    * @param _weiAmount Value in wei involved in the purchase
437    */
438   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal
439   {}
440   /**
441    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
442    * @param _beneficiary Address performing the token purchase
443    * @param _weiAmount Value in wei involved in the purchase
444    */
445   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal
446   {}
447 
448   /**
449    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
450    * @param _beneficiary Address performing the token purchase
451    * @param _tokenAmount Number of tokens to be emitted
452    */
453   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
454     token.transfer(_beneficiary, _tokenAmount);
455   }
456 
457   /**
458    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
459    * @param _beneficiary Address receiving the tokens
460    * @param _tokenAmount Number of tokens to be purchased
461    */
462   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
463     _deliverTokens(_beneficiary, _tokenAmount);
464   }
465 
466   /**
467    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
468    * @param _beneficiary Address receiving the tokens
469    * @param _weiAmount Value in wei involved in the purchase
470    */
471   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal
472   {}
473 
474   /**
475    * @dev Override to extend the way in which ether is converted to tokens.
476    * @param _weiAmount Value in wei to be converted into tokens
477    * @return Number of tokens that can be purchased with the specified _weiAmount
478    */
479   function _getTokenAmount(uint256 _weiAmount) internal returns (uint256)
480   {
481       uint256 tokens = _weiAmount.mul(rate);
482       return tokens;
483   }
484   /**
485    * @dev Determines how ETH is stored/forwarded on purchases.
486    */
487   function _forwardFunds() internal {
488     wallet.transfer(msg.value);
489   }
490 }
491 contract AllowanceCrowdsale is Crowdsale {
492   using SafeMath for uint256;
493 
494   address public tokenWallet;
495 
496   /**
497    * @dev Constructor, takes token wallet address. 
498    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
499    */
500   function AllowanceCrowdsale(address _tokenWallet) public {
501     require(_tokenWallet != address(0));
502     tokenWallet = _tokenWallet;
503   }
504 
505   /**
506    * @dev Checks the amount of tokens left in the allowance.
507    * @return Amount of tokens left in the allowance
508    */
509   function remainingTokens() public view returns (uint256) {
510     return token.balanceOf(tokenWallet);
511   }
512 
513   /**
514    * @dev Overrides parent behavior by transferring tokens from wallet.
515    * @param _beneficiary Token purchaser
516    * @param _tokenAmount Amount of tokens purchased
517    */
518   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
519     token.saleTokens(_beneficiary, _tokenAmount);
520   }
521 }
522 contract CappedCrowdsale is Crowdsale {
523   using SafeMath for uint256;
524 
525   uint256 public cap;
526   
527 
528   /**
529    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
530    * @param _cap Max amount of wei to be contributed
531    */
532   function CappedCrowdsale(uint256 _cap) public {
533     require(_cap > 0);
534     cap = _cap;
535   }
536 
537   /**
538    * @dev Checks whether the cap has been reached. 
539    * @return Whether the cap was reached
540    */
541   function capReached() public view returns (bool) {
542     return weiRaised >= cap;
543   }
544 
545   /**
546    * @dev Extend parent behavior requiring purchase to respect the funding cap.
547    * @param _beneficiary Token purchaser
548    * @param _weiAmount Amount of wei contributed
549    */
550   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
551     super._preValidatePurchase(_beneficiary, _weiAmount);
552     require(_beneficiary != address(0));
553     require(_weiAmount != 0);
554     //require(!capReached());
555     require(weiRaised.add(_weiAmount) <= cap);
556   }
557 
558 }
559 contract TimedCrowdsale is Crowdsale {
560   using SafeMath for uint256;
561 
562   uint256 public openingTime;
563   uint256 public closingTime;
564 
565   /**
566    * @dev Reverts if not in crowdsale time range. 
567    */
568   modifier onlyWhileOpen {
569     require(now >= openingTime && now <= closingTime);
570     _;
571   }
572 
573   /**
574    * @dev Constructor, takes crowdsale opening and closing times.
575    * @param _openingTime Crowdsale opening time
576    * @param _closingTime Crowdsale closing time
577    */
578   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
579     require(_openingTime >= now);
580     require(_closingTime >= _openingTime);
581 
582     openingTime = _openingTime;
583     closingTime = _closingTime;
584   }
585 
586   /**
587    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
588    * @return Whether crowdsale period has elapsed
589    */
590   function hasClosed() public view returns (bool) {
591     return now > closingTime;
592   }
593   
594   /**
595    * @dev Extend parent behavior requiring to be within contributing period
596    * @param _beneficiary Token purchaser
597    * @param _weiAmount Amount of wei contributed
598    */
599   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
600     super._preValidatePurchase(_beneficiary, _weiAmount);
601   }
602 
603 }
604 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
605   using SafeMath for uint256;
606 
607   bool public isFinalized = false;
608 
609   event Finalized();
610 
611   /**
612    * @dev Must be called after crowdsale ends, to do some extra finalization
613    * work. Calls the contract's finalization function.
614    */
615   function finalize() onlyOwner public {
616     require(!isFinalized);
617     require(hasClosed());
618 
619     finalization();
620     emit Finalized();
621 
622     isFinalized = true;
623   }
624 
625   /**
626    * @dev Can be overridden to add finalization logic. The overriding function
627    * should call super.finalization() to ensure the chain of finalization is
628    * executed entirely.
629    */
630   function finalization() internal
631   {
632       
633   }
634 }
635 contract RefundVault is Ownable {
636   using SafeMath for uint256;
637 
638   enum State { Active, Refunding, Closed }
639 
640   mapping (address => uint256) public deposited;
641   address public wallet;
642   State public state;
643 
644   event Closed();
645   event RefundsEnabled();
646   event Refunded(address indexed beneficiary, uint256 weiAmount);
647 
648   /**
649    * @param _wallet Vault address
650    */
651   function RefundVault(address _wallet) public {
652     require(_wallet != address(0));
653     wallet = _wallet;
654     state = State.Active;
655   }
656 
657   /**
658    * @param investor Investor address
659    */
660   function deposit(address investor) onlyOwner public payable {
661     require(state == State.Active);
662     deposited[investor] = deposited[investor].add(msg.value);
663   }
664   function depositAdvisor(address _advWallet, uint256 _amount) onlyOwner public{
665       require(state == State.Active);
666       _advWallet.transfer(_amount);
667   }
668   function depositOf(address investor) public view returns(uint256){
669       return deposited[investor];
670   }
671 
672   function close() onlyOwner public {
673     require(state == State.Active);
674     state = State.Closed;
675     wallet.transfer(this.balance);
676     emit Closed();
677   }
678 
679   function enableRefunds() onlyOwner public {
680     require(state == State.Active);
681     state = State.Refunding;
682     emit RefundsEnabled();
683   }
684 
685   /**
686    * @param investor Investor address
687    */
688   function refund(address investor) public {
689     require(state == State.Refunding);
690     uint256 depositedValue = deposited[investor];
691     deposited[investor] = 0;
692     investor.transfer(depositedValue);
693     emit Refunded(investor, depositedValue);
694   }
695 }
696 
697 contract StagebleCrowdsale is FinalizableCrowdsale{
698     using SafeMath for uint256;
699     
700     mapping (uint256 => mapping (string => uint256)) internal stage;
701     uint256 internal countStages;
702     
703     function StagebleCrowdsale() public {
704         stage[0]["bonus"] = 30;
705         stage[0]["cap"] = (rate * (6000 ether)); // rate * (6000 ether)
706         stage[0]["tranmin"] = (1 ether);
707         stage[0]["closeTime"] = 1529280000;//18.06.2018 - 1529280000
708         
709         stage[1]["bonus"] = 20;
710         stage[1]["cap"] = (rate * (6000 ether)); // rate * (6000 ether)
711         stage[1]["tranmin"] = (1 ether)/10;
712         stage[1]["closeTime"] = 1529884800;//25.06.2018 - 1529884800
713         
714         stage[2]["bonus"] = 10;
715         stage[2]["cap"] = (rate * (6000 ether));// rate * (6000 ether)
716         stage[2]["tranmin"] = (1 ether)/10;
717         stage[2]["closeTime"] = 1531094400;//09.07.2018 - 1531094400
718         
719         stage[3]["bonus"] = 0;
720         stage[3]["cap"] = token.totalSupply();
721         stage[3]["tranmin"] = 0;
722         stage[3]["closeTime"] = closingTime;
723         
724         countStages = 4;
725     }
726 
727     function getStageBonus(uint256 _index) public view returns(uint256){
728         return stage[_index]["bonus"];
729     }
730     function getStageAvailableTokens(uint256 _index) public view returns(uint256){
731         return stage[_index]["cap"];
732     }
733     function getStageMinWeiAmount(uint256 _index) public view returns(uint256){
734         return stage[_index]["tranmin"];
735     }
736     function getStageClosingTime(uint256 _index) public view returns(uint256){
737         return stage[_index]["closeTime"];
738     }
739     function getCurrentStageIndex() public view returns(uint256){
740         return _getInStageIndex();
741     }
742     function getCountStages() public view returns(uint256){
743         return countStages;
744     }
745 
746     function _getBonus(uint256 _stageIndex, uint256 _leftcap) internal returns(uint256){
747         uint256 bonuses = 0;
748         if(_stageIndex < countStages)
749         {
750             if(stage[_stageIndex]["cap"] >= _leftcap)
751             {
752                 if(stage[_stageIndex]["bonus"] > 0)
753                 {
754                     bonuses = bonuses.add(_leftcap.mul(stage[_stageIndex]["bonus"]).div(100));
755                 }
756                 stage[_stageIndex]["cap"] = stage[_stageIndex]["cap"].sub(_leftcap);
757             }
758             else
759             {
760                 _leftcap = _leftcap.sub(stage[_stageIndex]["cap"]);
761                 if(stage[_stageIndex]["cap"] > 0)
762                 {
763                     if(stage[_stageIndex]["bonus"] > 0)
764                     {
765                         bonuses = bonuses.add(stage[_stageIndex]["cap"].mul(stage[_stageIndex]["bonus"]).div(100));
766                     }
767                     stage[_stageIndex]["cap"] = 0;
768                 }
769                 bonuses = bonuses.add(_getBonus(_stageIndex.add(1), _leftcap));
770             }
771         }
772         return bonuses;
773     }
774     function _isInStage(uint256 _stageIndex) internal view returns (bool){
775         return now < stage[_stageIndex]["closeTime"] && stage[_stageIndex]["cap"] > 0;
776     }
777     function _getInStageIndex () internal view returns(uint256){
778         uint256 _index = 0;
779         while(_index < countStages)
780         {
781             if(_isInStage(_index))
782                 return _index;
783             _index = _index.add(1);
784         }
785         return countStages.sub(1);
786     }
787     
788     function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
789         uint256 tokens = super._getTokenAmount(_weiAmount);
790         tokens = tokens.add(_getBonus(_getInStageIndex(), tokens));
791         return tokens;
792     }
793     
794     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
795         super._preValidatePurchase(_beneficiary, _weiAmount);
796         uint256 _index = _getInStageIndex();
797         if(stage[_index]["tranmin"] > 0)
798             require(stage[_index]["tranmin"] <= _weiAmount);
799     }
800 
801 }
802 
803 contract RefundableCrowdsale is StagebleCrowdsale {
804   using SafeMath for uint256;
805 
806   // minimum amount of funds to be raised in weis
807   uint256 public goal;
808 
809   // refund vault used to hold funds while crowdsale is running
810   RefundVault public vault;
811   
812   address advWallet;
813   uint256 advPercent;
814   bool advIsCalc = false;
815 
816   /**
817    * @dev Constructor, creates RefundVault. 
818    * @param _goal Funding goal
819    */
820   function RefundableCrowdsale(uint256 _goal, uint256 _advPercent) public {
821     require(_goal > 0);
822     vault = new RefundVault(wallet);
823     goal = _goal;
824     advPercent = _advPercent;
825   }
826 
827   /**
828    * @dev Investors can claim refunds here if crowdsale is unsuccessful
829    */
830   function claimRefund() public {
831     require(isFinalized);
832     require(!goalReached());
833 
834     vault.refund(msg.sender);
835   }
836 
837   /**
838    * @dev Checks whether funding goal was reached. 
839    * @return Whether funding goal was reached
840    */
841   function goalReached() public view returns (bool) {
842     return weiRaised >= goal;
843   }
844 
845   /**
846    * @dev vault finalization task, called when owner calls finalize()
847    */
848   function finalization() internal {
849     if (goalReached()) {
850         vault.close();
851     } else {
852       vault.enableRefunds();
853     }
854 
855     super.finalization();
856   }
857 
858   /**
859    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
860    */
861   function _forwardFunds() internal {
862     vault.deposit.value(msg.value)(msg.sender);
863     if(!advIsCalc &&_getInStageIndex () > 0 && goalReached() && advWallet != address(0))
864     {
865         //Send ETH to advisor, after to stage 1
866         uint256 advAmount = 0;
867         advIsCalc = true;
868         advAmount = weiRaised.mul(advPercent).div(100);
869         vault.depositAdvisor(advWallet, advAmount);
870     }
871   }
872   
873   function onlyOwnerSetAdvWallet(address _advWallet) public onlyOwner{
874       require(_advWallet != address(0));
875       advWallet = _advWallet;
876   }
877   function onlyOwnerGetAdvWallet() onlyOwner public view returns(address){
878           return advWallet;
879     }
880 
881 }
882 
883 
884 
885 contract PPTokenCrowdsale is CappedCrowdsale, RefundableCrowdsale, AllowanceCrowdsale{
886     using SafeMath for uint256;
887     
888     address bountyWallet;
889     uint256 bountyPercent;
890     
891     address teamWallet;
892     uint256 teamPercent;
893     
894     address companyWallet;
895     uint256 companyPercent;
896     
897     function PPTokenCrowdsale( PPToken _token) public
898         Crowdsale(500, msg.sender, _token)//(_rate, _wallet, _token)
899         CappedCrowdsale((24000 ether))//(_cap)24000 ether
900         TimedCrowdsale(1526860800, 1531699200)//(1526860800, 1531699200)
901         RefundableCrowdsale((3000 ether), 5)//3000 ether, 5%
902         AllowanceCrowdsale(msg.sender)
903       {
904         bountyPercent = 5;
905         teamPercent = 15;
906         companyPercent = 10;
907       }
908       
909       
910       function finalize() onlyOwner public {
911           require(bountyWallet != address(0));
912           require(teamWallet != address(0));
913           require(companyWallet != address(0));
914           super.finalize();
915           uint256 _totalSupplyRem = token.totalSupply().sub(token.balanceOf(msg.sender));
916           
917           uint256 _bountyTokens = _totalSupplyRem.mul(bountyPercent).div(100);
918           require(token.saleTokens(bountyWallet, _bountyTokens));
919           
920           uint256 _teamTokens = _totalSupplyRem.mul(teamPercent).div(100);
921           require(token.saleTokens(teamWallet, _teamTokens));
922           
923           uint256 _companyTokens = _totalSupplyRem.mul(companyPercent).div(100);
924           require(token.saleTokens(companyWallet, _companyTokens));
925           
926           token.burnRemain();
927       }
928       
929       function onlyOwnerSetBountyWallet(address _wallet) onlyOwner public{
930           bountyWallet = _wallet;
931       }
932       function onlyOwnerGetBountyWallet() onlyOwner public view returns(address){
933           return bountyWallet;
934       }
935       function onlyOwnerSetTeamWallet(address _wallet) onlyOwner public{
936           teamWallet = _wallet;
937       }
938       function onlyOwnerGetTeamWallet() onlyOwner public view returns(address){
939           return teamWallet;
940       }
941       function onlyOwnerSetCompanyWallet(address _wallet) onlyOwner public{
942           companyWallet = _wallet;
943       }
944       function onlyOwnerGetCompanyWallet() onlyOwner public view returns(address){
945           return companyWallet;
946       }
947 }