1 pragma solidity 0.4.19;
2 contract Ownable {
3   address public owner;
4 
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8 
9   /**
10    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11    * account.
12    */
13   function Ownable() public {
14     owner = msg.sender;
15   }
16 
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) public onlyOwner {
30     require(newOwner != address(0));
31     OwnershipTransferred(owner, newOwner);
32     owner = newOwner;
33   }
34 }
35 
36 
37 contract ERC20Basic {
38   function totalSupply() public view returns (uint256);
39   function balanceOf(address who) public view returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) public view returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   uint256 totalSupply_;
56 
57   /**
58   * @dev total number of tokens in existence
59   */
60   function totalSupply() public view returns (uint256) {
61     return totalSupply_;
62   }
63 
64   /**
65   * @dev transfer token for a specified address
66   * @param _to The address to transfer to.
67   * @param _value The amount to be transferred.
68   */
69   function transfer(address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[msg.sender]);
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
85   function balanceOf(address _owner) public view returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 contract StandardToken is ERC20, BasicToken {
91 
92   mapping (address => mapping (address => uint256)) internal allowed;
93 
94 
95   /**
96    * @dev Transfer tokens from one address to another
97    * @param _from address The address which you want to send tokens from
98    * @param _to address The address which you want to transfer to
99    * @param _value uint256 the amount of tokens to be transferred
100    */
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[_from]);
104     require(_value <= allowed[_from][msg.sender]);
105 
106     balances[_from] = balances[_from].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
115    *
116    * Beware that changing an allowance with this method brings the risk that someone may use both the old
117    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
118    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
119    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120    * @param _spender The address which will spend the funds.
121    * @param _value The amount of tokens to be spent.
122    */
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) public view returns (uint256) {
136     return allowed[_owner][_spender];
137   }
138 
139   /**
140    * @dev Increase the amount of tokens that an owner allowed to a spender.
141    *
142    * approve should be called when allowed[_spender] == 0. To increment
143    * allowed value is better to use this function to avoid 2 calls (and wait until
144    * the first transaction is mined)
145    * From MonolithDAO Token.sol
146    * @param _spender The address which will spend the funds.
147    * @param _addedValue The amount of tokens to increase the allowance by.
148    */
149   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
150     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154 
155   /**
156    * @dev Decrease the amount of tokens that an owner allowed to a spender.
157    *
158    * approve should be called when allowed[_spender] == 0. To decrement
159    * allowed value is better to use this function to avoid 2 calls (and wait until
160    * the first transaction is mined)
161    * From MonolithDAO Token.sol
162    * @param _spender The address which will spend the funds.
163    * @param _subtractedValue The amount of tokens to decrease the allowance by.
164    */
165   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 contract MintableToken is StandardToken, Ownable {
178   event Mint(address indexed to, uint256 amount);
179   event MintFinished();
180 
181   bool public mintingFinished = false;
182 
183 
184   modifier canMint() {
185     require(!mintingFinished);
186     _;
187   }
188 
189   /**
190    * @dev Function to mint tokens
191    * @param _to The address that will receive the minted tokens.
192    * @param _amount The amount of tokens to mint.
193    * @return A boolean that indicates if the operation was successful.
194    */
195   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
196     totalSupply_ = totalSupply_.add(_amount);
197     balances[_to] = balances[_to].add(_amount);
198     Mint(_to, _amount);
199     Transfer(address(0), _to, _amount);
200     return true;
201   }
202 
203   /**
204    * @dev Function to stop minting new tokens.
205    * @return True if the operation was successful.
206    */
207   function finishMinting() onlyOwner canMint public returns (bool) {
208     mintingFinished = true;
209     MintFinished();
210     return true;
211   }
212 }
213 contract CappedToken is MintableToken {
214 
215   uint256 public cap;
216 
217   function CappedToken(uint256 _cap) public {
218     require(_cap > 0);
219     cap = _cap;
220   }
221 
222   /**
223    * @dev Function to mint tokens
224    * @param _to The address that will receive the minted tokens.
225    * @param _amount The amount of tokens to mint.
226    * @return A boolean that indicates if the operation was successful.
227    */
228   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
229     require(totalSupply_.add(_amount) <= cap);
230 
231     return super.mint(_to, _amount);
232   }
233 
234 }
235 contract TokenVesting is Ownable {
236   using SafeMath for uint256;
237   using SafeERC20 for ERC20Basic;
238 
239   event Released(uint256 amount);
240   event Revoked();
241 
242   // beneficiary of tokens after they are released
243   address public beneficiary;
244 
245   uint256 public cliff;
246   uint256 public start;
247   uint256 public duration;
248 
249   bool public revocable;
250 
251   mapping (address => uint256) public released;
252   mapping (address => bool) public revoked;
253 
254   /**
255    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
256    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
257    * of the balance will have vested.
258    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
259    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
260    * @param _duration duration in seconds of the period in which the tokens will vest
261    * @param _revocable whether the vesting is revocable or not
262    */
263   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
264     require(_beneficiary != address(0));
265     require(_cliff <= _duration);
266 
267     beneficiary = _beneficiary;
268     revocable = _revocable;
269     duration = _duration;
270     cliff = _start.add(_cliff);
271     start = _start;
272   }
273 
274   /**
275    * @notice Transfers vested tokens to beneficiary.
276    * @param token ERC20 token which is being vested
277    */
278   function release(ERC20Basic token) public {
279     uint256 unreleased = releasableAmount(token);
280 
281     require(unreleased > 0);
282 
283     released[token] = released[token].add(unreleased);
284 
285     token.safeTransfer(beneficiary, unreleased);
286 
287     Released(unreleased);
288   }
289 
290   /**
291    * @notice Allows the owner to revoke the vesting. Tokens already vested
292    * remain in the contract, the rest are returned to the owner.
293    * @param token ERC20 token which is being vested
294    */
295   function revoke(ERC20Basic token) public onlyOwner {
296     require(revocable);
297     require(!revoked[token]);
298 
299     uint256 balance = token.balanceOf(this);
300 
301     uint256 unreleased = releasableAmount(token);
302     uint256 refund = balance.sub(unreleased);
303 
304     revoked[token] = true;
305 
306     token.safeTransfer(owner, refund);
307 
308     Revoked();
309   }
310 
311   /**
312    * @dev Calculates the amount that has already vested but hasn't been released yet.
313    * @param token ERC20 token which is being vested
314    */
315   function releasableAmount(ERC20Basic token) public view returns (uint256) {
316     return vestedAmount(token).sub(released[token]);
317   }
318 
319   /**
320    * @dev Calculates the amount that has already vested.
321    * @param token ERC20 token which is being vested
322    */
323   function vestedAmount(ERC20Basic token) public view returns (uint256) {
324     uint256 currentBalance = token.balanceOf(this);
325     uint256 totalBalance = currentBalance.add(released[token]);
326 
327     if (now < cliff) {
328       return 0;
329     } else if (now >= start.add(duration) || revoked[token]) {
330       return totalBalance;
331     } else {
332       return totalBalance.mul(now.sub(start)).div(duration);
333     }
334   }
335 }
336 contract TokenTimelock {
337   using SafeERC20 for ERC20Basic;
338 
339   // ERC20 basic token contract being held
340   ERC20Basic public token;
341 
342   // beneficiary of tokens after they are released
343   address public beneficiary;
344 
345   // timestamp when token release is enabled
346   uint256 public releaseTime;
347 
348   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
349     require(_releaseTime > now);
350     token = _token;
351     beneficiary = _beneficiary;
352     releaseTime = _releaseTime;
353   }
354 
355   /**
356    * @notice Transfers tokens held by timelock to beneficiary.
357    */
358   function release() public {
359     require(now >= releaseTime);
360 
361     uint256 amount = token.balanceOf(this);
362     require(amount > 0);
363 
364     token.safeTransfer(beneficiary, amount);
365   }
366 }
367 
368 
369 
370 
371 contract NebulaToken is CappedToken{
372     using SafeMath for uint256;
373     string public constant name = "Nebula AI Token";
374     string public constant symbol = "NBAI";
375     uint8 public constant decimals = 18;
376 
377     bool public pvt_plmt_set;
378     uint256 public pvt_plmt_max_in_Wei;
379     uint256 public pvt_plmt_remaining_in_Wei;
380     uint256 public pvt_plmt_token_generated;
381 
382     TokenVesting public foundation_vesting_contract;
383     uint256 public token_unlock_time = 1524887999; //April 27th 2018 23:59:59 GMT-4:00, 7 days after completion
384 
385     mapping(address => TokenTimelock[]) public time_locked_reclaim_addresses;
386 
387     //vesting starts on April 21th 2018 00:00 GMT-4:00
388     //vesting duration is 3 years
389     function NebulaToken() CappedToken(6700000000 * 1 ether) public{
390         uint256 foundation_held = cap.mul(55).div(100);//55% fixed for early investors, partners, nebula internal and foundation
391         address foundation_beneficiary_wallet = 0xD86FCe1890bf98fC086b264a66cA96C7E3B03B40;//multisig wallet
392         foundation_vesting_contract = new TokenVesting(foundation_beneficiary_wallet, 1524283200, 0, 3 years, false);
393         assert(mint(foundation_vesting_contract, foundation_held));
394         FoundationTokenGenerated(foundation_vesting_contract, foundation_beneficiary_wallet, foundation_held);
395     }
396 
397     //Crowdsale contract mints and stores tokens in time locked contracts during crowdsale.
398     //Ownership is transferred back to the owner of crowdsale contract once crowdsale is finished(finalize())
399     function create_public_sale_token(address _beneficiary, uint256 _token_amount) external onlyOwner returns(bool){
400         assert(mint_time_locked_token(_beneficiary, _token_amount) != address(0));
401         return true;
402     }
403 
404     //@dev Can only set once
405     function set_private_sale_total(uint256 _pvt_plmt_max_in_Wei) external onlyOwner returns(bool){
406         require(!pvt_plmt_set && _pvt_plmt_max_in_Wei >= 5000 ether);//_pvt_plmt_max_in_wei is minimum the soft cap
407         pvt_plmt_set = true;
408         pvt_plmt_max_in_Wei = _pvt_plmt_max_in_Wei;
409         pvt_plmt_remaining_in_Wei = pvt_plmt_max_in_Wei;
410         PrivateSalePlacementLimitSet(pvt_plmt_max_in_Wei);
411     }
412     /**
413      * Private sale distributor
414      * private sale total is set once, irreversible and not modifiable
415      * Once this amount in wei is reduced to 0, no more token can be generated as private sale!
416      * Maximum token generated by private sale is pvt_plmt_max_in_Wei * 125000 (discount upper limit)
417      * Note 1, Private sale limit is the balance of private sale fond wallet balance as of 23:59 UTC March 29th 2019
418      * Note 2, no ether is transferred to neither the crowdsale contract nor this one for private sale
419      * totalSupply_ = pvt_plmt_token_generated + foundation_held + weiRaised * 100000
420      * _beneficiary: private sale buyer address
421      * _wei_amount: amount in wei that the buyer bought
422      * _rate: rate that the private sale buyer has agreed with NebulaAi
423      */
424     function distribute_private_sale_fund(address _beneficiary, uint256 _wei_amount, uint256 _rate) public onlyOwner returns(bool){
425         require(pvt_plmt_set && _beneficiary != address(0) && pvt_plmt_remaining_in_Wei >= _wei_amount && _rate >= 100000 && _rate <= 125000);
426 
427         pvt_plmt_remaining_in_Wei = pvt_plmt_remaining_in_Wei.sub(_wei_amount);//remove from limit
428         uint256 _token_amount = _wei_amount.mul(_rate); //calculate token amount to be generated
429         pvt_plmt_token_generated = pvt_plmt_token_generated.add(_token_amount);//add generated amount to total private sale token
430 
431         //Mint token if unlocked time has been reached, directly mint to beneficiary, else create time locked contract
432         address _ret;
433         if(now < token_unlock_time) assert((_ret = mint_time_locked_token(_beneficiary, _token_amount))!=address(0));
434         else assert(mint(_beneficiary, _token_amount));
435 
436         PrivateSaleTokenGenerated(_ret, _beneficiary, _token_amount);
437         return true;
438     }
439     //used for private and public sale to create time locked contract before lock release time
440     //Note: TokenTimelock constructor will throw after token unlock time is reached
441     function mint_time_locked_token(address _beneficiary, uint256 _token_amount) internal returns(TokenTimelock _locked){
442         _locked = new TokenTimelock(this, _beneficiary, token_unlock_time);
443         time_locked_reclaim_addresses[_beneficiary].push(_locked);
444         assert(mint(_locked, _token_amount));
445     }
446 
447     //Release all tokens held by time locked contracts to the beneficiary address stored in the contract
448     //Note: requirement is checked in time lock contract
449     function release_all(address _beneficiary) external returns(bool){
450         require(time_locked_reclaim_addresses[_beneficiary].length > 0);
451         TokenTimelock[] memory _locks = time_locked_reclaim_addresses[_beneficiary];
452         for(uint256 i = 0 ; i < _locks.length; ++i) _locks[i].release();
453         return true;
454     }
455 
456     //override to add a checker
457     function finishMinting() onlyOwner canMint public returns (bool){
458         require(pvt_plmt_set && pvt_plmt_remaining_in_Wei == 0);
459         super.finishMinting();
460     }
461 
462     function get_time_locked_contract_size(address _owner) external view returns(uint256){
463         return time_locked_reclaim_addresses[_owner].length;
464     }
465 
466     event PrivateSaleTokenGenerated(address indexed _time_locked, address indexed _beneficiary, uint256 _amount);
467     event FoundationTokenGenerated(address indexed _vesting, address indexed _beneficiary, uint256 _amount);
468     event PrivateSalePlacementLimitSet(uint256 _limit);
469     function () public payable{revert();}//This contract is not payable
470 }
471 
472 contract Crowdsale {
473   using SafeMath for uint256;
474 
475   // The token being sold
476   ERC20 public token;
477 
478   // Address where funds are collected
479   address public wallet;
480 
481   // How many token units a buyer gets per wei
482   uint256 public rate;
483 
484   // Amount of wei raised
485   uint256 public weiRaised;
486 
487   /**
488    * Event for token purchase logging
489    * @param purchaser who paid for the tokens
490    * @param beneficiary who got the tokens
491    * @param value weis paid for purchase
492    * @param amount amount of tokens purchased
493    */
494   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
495 
496   /**
497    * @param _rate Number of token units a buyer gets per wei
498    * @param _wallet Address where collected funds will be forwarded to
499    * @param _token Address of the token being sold
500    */
501   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
502     require(_rate > 0);
503     require(_wallet != address(0));
504     require(_token != address(0));
505 
506     rate = _rate;
507     wallet = _wallet;
508     token = _token;
509   }
510 
511   // -----------------------------------------
512   // Crowdsale external interface
513   // -----------------------------------------
514 
515   /**
516    * @dev fallback function ***DO NOT OVERRIDE***
517    */
518   function () external payable {
519     buyTokens(msg.sender);
520   }
521 
522   /**
523    * @dev low level token purchase ***DO NOT OVERRIDE***
524    * @param _beneficiary Address performing the token purchase
525    */
526   function buyTokens(address _beneficiary) public payable {
527 
528     uint256 weiAmount = msg.value;
529     _preValidatePurchase(_beneficiary, weiAmount);
530 
531     // calculate token amount to be created
532     uint256 tokens = _getTokenAmount(weiAmount);
533 
534     // update state
535     weiRaised = weiRaised.add(weiAmount);
536 
537     _processPurchase(_beneficiary, tokens);
538     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
539 
540     _updatePurchasingState(_beneficiary, weiAmount);
541 
542     _forwardFunds();
543     _postValidatePurchase(_beneficiary, weiAmount);
544   }
545 
546   // -----------------------------------------
547   // Internal interface (extensible)
548   // -----------------------------------------
549 
550   /**
551    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
552    * @param _beneficiary Address performing the token purchase
553    * @param _weiAmount Value in wei involved in the purchase
554    */
555   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
556     require(_beneficiary != address(0));
557     require(_weiAmount != 0);
558   }
559 
560   /**
561    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
562    * @param _beneficiary Address performing the token purchase
563    * @param _weiAmount Value in wei involved in the purchase
564    */
565   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
566     // optional override
567   }
568 
569   /**
570    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
571    * @param _beneficiary Address performing the token purchase
572    * @param _tokenAmount Number of tokens to be emitted
573    */
574   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
575     token.transfer(_beneficiary, _tokenAmount);
576   }
577 
578   /**
579    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
580    * @param _beneficiary Address receiving the tokens
581    * @param _tokenAmount Number of tokens to be purchased
582    */
583   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
584     _deliverTokens(_beneficiary, _tokenAmount);
585   }
586 
587   /**
588    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
589    * @param _beneficiary Address receiving the tokens
590    * @param _weiAmount Value in wei involved in the purchase
591    */
592   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
593     // optional override
594   }
595 
596   /**
597    * @dev Override to extend the way in which ether is converted to tokens.
598    * @param _weiAmount Value in wei to be converted into tokens
599    * @return Number of tokens that can be purchased with the specified _weiAmount
600    */
601   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
602     return _weiAmount.mul(rate);
603   }
604 
605   /**
606    * @dev Determines how ETH is stored/forwarded on purchases.
607    */
608   function _forwardFunds() internal {
609     wallet.transfer(msg.value);
610   }
611 }
612 
613 contract TimedCrowdsale is Crowdsale {
614   using SafeMath for uint256;
615 
616   uint256 public openingTime;
617   uint256 public closingTime;
618 
619   /**
620    * @dev Reverts if not in crowdsale time range. 
621    */
622   modifier onlyWhileOpen {
623     require(now >= openingTime && now <= closingTime);
624     _;
625   }
626 
627   /**
628    * @dev Constructor, takes crowdsale opening and closing times.
629    * @param _openingTime Crowdsale opening time
630    * @param _closingTime Crowdsale closing time
631    */
632   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
633     require(_openingTime >= now);
634     require(_closingTime >= _openingTime);
635 
636     openingTime = _openingTime;
637     closingTime = _closingTime;
638   }
639 
640   /**
641    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
642    * @return Whether crowdsale period has elapsed
643    */
644   function hasClosed() public view returns (bool) {
645     return now > closingTime;
646   }
647   
648   /**
649    * @dev Extend parent behavior requiring to be within contributing period
650    * @param _beneficiary Token purchaser
651    * @param _weiAmount Amount of wei contributed
652    */
653   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
654     super._preValidatePurchase(_beneficiary, _weiAmount);
655   }
656 
657 }
658 
659 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
660   using SafeMath for uint256;
661 
662   bool public isFinalized = false;
663 
664   event Finalized();
665 
666   /**
667    * @dev Must be called after crowdsale ends, to do some extra finalization
668    * work. Calls the contract's finalization function.
669    */
670   function finalize() onlyOwner public {
671     require(!isFinalized);
672     require(hasClosed());
673 
674     finalization();
675     Finalized();
676 
677     isFinalized = true;
678   }
679 
680   /**
681    * @dev Can be overridden to add finalization logic. The overriding function
682    * should call super.finalization() to ensure the chain of finalization is
683    * executed entirely.
684    */
685   function finalization() internal {
686   }
687 }
688 contract CappedCrowdsale is Crowdsale {
689   using SafeMath for uint256;
690 
691   uint256 public cap;
692 
693   /**
694    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
695    * @param _cap Max amount of wei to be contributed
696    */
697   function CappedCrowdsale(uint256 _cap) public {
698     require(_cap > 0);
699     cap = _cap;
700   }
701 
702   /**
703    * @dev Checks whether the cap has been reached. 
704    * @return Whether the cap was reached
705    */
706   function capReached() public view returns (bool) {
707     return weiRaised >= cap;
708   }
709 
710   /**
711    * @dev Extend parent behavior requiring purchase to respect the funding cap.
712    * @param _beneficiary Token purchaser
713    * @param _weiAmount Amount of wei contributed
714    */
715   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
716     super._preValidatePurchase(_beneficiary, _weiAmount);
717     require(weiRaised.add(_weiAmount) <= cap);
718   }
719 
720 }
721 
722 contract IndividuallyCappedCrowdsale is Crowdsale, Ownable {
723   using SafeMath for uint256;
724 
725   mapping(address => uint256) public contributions;
726   mapping(address => uint256) public caps;
727 
728   /**
729    * @dev Sets a specific user's maximum contribution.
730    * @param _beneficiary Address to be capped
731    * @param _cap Wei limit for individual contribution
732    */
733   function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {
734     caps[_beneficiary] = _cap;
735   }
736 
737   /**
738    * @dev Sets a group of users' maximum contribution.
739    * @param _beneficiaries List of addresses to be capped
740    * @param _cap Wei limit for individual contribution
741    */
742   function setGroupCap(address[] _beneficiaries, uint256 _cap) external onlyOwner {
743     for (uint256 i = 0; i < _beneficiaries.length; i++) {
744       caps[_beneficiaries[i]] = _cap;
745     }
746   }
747 
748   /**
749    * @dev Returns the cap of a specific user. 
750    * @param _beneficiary Address whose cap is to be checked
751    * @return Current cap for individual user
752    */
753   function getUserCap(address _beneficiary) public view returns (uint256) {
754     return caps[_beneficiary];
755   }
756 
757   /**
758    * @dev Returns the amount contributed so far by a sepecific user.
759    * @param _beneficiary Address of contributor
760    * @return User contribution so far
761    */
762   function getUserContribution(address _beneficiary) public view returns (uint256) {
763     return contributions[_beneficiary];
764   }
765 
766   /**
767    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
768    * @param _beneficiary Token purchaser
769    * @param _weiAmount Amount of wei contributed
770    */
771   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
772     super._preValidatePurchase(_beneficiary, _weiAmount);
773     require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
774   }
775 
776   /**
777    * @dev Extend parent behavior to update user contributions
778    * @param _beneficiary Token purchaser
779    * @param _weiAmount Amount of wei contributed
780    */
781   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
782     super._updatePurchasingState(_beneficiary, _weiAmount);
783     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
784   }
785 
786 }
787 contract NebulaCrowdsale is CappedCrowdsale, FinalizableCrowdsale, IndividuallyCappedCrowdsale{
788 
789     function NebulaCrowdsale(
790         NebulaToken _token
791     )
792     public
793     Crowdsale(100000, 0xD86FCe1890bf98fC086b264a66cA96C7E3B03B40, _token)
794     CappedCrowdsale(20000 ether)
795     TimedCrowdsale(1522681200, 1524283199)
796     {}
797 
798     /**
799      * @dev Extend parent behavior requiring purchase lower and upper limit
800      * @param _beneficiary Token purchaser
801      * @param _weiAmount Amount of wei contributed
802      */
803     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
804         super._preValidatePurchase(_beneficiary, _weiAmount);
805         require(msg.value>=0.1 ether && msg.value <= 50 ether);
806     }
807 
808     //@dev Overrides delivery by minting tokens upon purchase and store in the time locked contract.
809     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
810         require(NebulaToken(token).create_public_sale_token(_beneficiary, _tokenAmount));
811     }
812 
813     //@dev Overrides to add finalization logic. The overriding function does not need to call super.finalization()
814     //This is the only finalization function
815     function finalization() internal {
816         NebulaToken _nebula_token = NebulaToken(token);
817         if(_nebula_token.pvt_plmt_set() && _nebula_token.pvt_plmt_remaining_in_Wei() == 0) {
818             _nebula_token.finishMinting();
819         }
820         _nebula_token.transferOwnership(owner);//transfer ownership back to original owner
821     }
822 
823     //getter
824     function hasStarted() public view returns(bool){
825         return now > openingTime;
826     }
827 
828     function get_time_locked_contract(uint256 _index) public view returns(address){
829         return NebulaToken(token).time_locked_reclaim_addresses(msg.sender, _index);
830     }
831     //call to release all tokens after token unlock time
832     function release_all() public returns(bool){
833         return NebulaToken(token).release_all(msg.sender);
834     }
835 }
836 
837 library SafeMath {
838 
839   /**
840   * @dev Multiplies two numbers, throws on overflow.
841   */
842   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
843     if (a == 0) {
844       return 0;
845     }
846     uint256 c = a * b;
847     assert(c / a == b);
848     return c;
849   }
850 
851   /**
852   * @dev Integer division of two numbers, truncating the quotient.
853   */
854   function div(uint256 a, uint256 b) internal pure returns (uint256) {
855     // assert(b > 0); // Solidity automatically throws when dividing by 0
856     uint256 c = a / b;
857     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
858     return c;
859   }
860 
861   /**
862   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
863   */
864   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
865     assert(b <= a);
866     return a - b;
867   }
868 
869   /**
870   * @dev Adds two numbers, throws on overflow.
871   */
872   function add(uint256 a, uint256 b) internal pure returns (uint256) {
873     uint256 c = a + b;
874     assert(c >= a);
875     return c;
876   }
877 }
878 library SafeERC20 {
879   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
880     assert(token.transfer(to, value));
881   }
882 
883   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
884     assert(token.transferFrom(from, to, value));
885   }
886 
887   function safeApprove(ERC20 token, address spender, uint256 value) internal {
888     assert(token.approve(spender, value));
889   }
890 }