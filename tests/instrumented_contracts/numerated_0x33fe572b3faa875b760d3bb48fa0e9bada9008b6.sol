1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title Crowdsale
213  * @dev Crowdsale is a base contract for managing a token crowdsale,
214  * allowing investors to purchase tokens with ether. This contract implements
215  * such functionality in its most fundamental form and can be extended to provide additional
216  * functionality and/or custom behavior.
217  * The external interface represents the basic interface for purchasing tokens, and conform
218  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
219  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
220  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
221  * behavior.
222  */
223 contract Crowdsale {
224   using SafeMath for uint256;
225 
226   // The token being sold
227   ERC20 public token;
228 
229   // Address where funds are collected
230   address public wallet;
231 
232   // How many token units a buyer gets per wei
233   uint256 public rate;
234 
235   // Amount of wei raised
236   uint256 public weiRaised;
237 
238   /**
239    * Event for token purchase logging
240    * @param purchaser who paid for the tokens
241    * @param beneficiary who got the tokens
242    * @param value weis paid for purchase
243    * @param amount amount of tokens purchased
244    */
245   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
246 
247   /**
248    * @param _rate Number of token units a buyer gets per wei
249    * @param _wallet Address where collected funds will be forwarded to
250    * @param _token Address of the token being sold
251    */
252   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
253     require(_rate > 0);
254     require(_wallet != address(0));
255     require(_token != address(0));
256 
257     rate = _rate;
258     wallet = _wallet;
259     token = _token;
260   }
261 
262   // -----------------------------------------
263   // Crowdsale external interface
264   // -----------------------------------------
265 
266   /**
267    * @dev fallback function ***DO NOT OVERRIDE***
268    */
269   function () external payable {
270     buyTokens(msg.sender);
271   }
272 
273   /**
274    * @dev low level token purchase ***DO NOT OVERRIDE***
275    * @param _beneficiary Address performing the token purchase
276    */
277   function buyTokens(address _beneficiary) public payable {
278 
279     uint256 weiAmount = msg.value;
280     _preValidatePurchase(_beneficiary, weiAmount);
281 
282     // calculate token amount to be created
283     uint256 tokens = _getTokenAmount(weiAmount);
284 
285     // update state
286     weiRaised = weiRaised.add(weiAmount);
287 
288     _processPurchase(_beneficiary, tokens);
289     emit TokenPurchase(
290       msg.sender,
291       _beneficiary,
292       weiAmount,
293       tokens
294     );
295 
296     _updatePurchasingState(_beneficiary, weiAmount);
297 
298     _forwardFunds();
299     _postValidatePurchase(_beneficiary, weiAmount);
300   }
301 
302   // -----------------------------------------
303   // Internal interface (extensible)
304   // -----------------------------------------
305 
306   /**
307    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
308    * @param _beneficiary Address performing the token purchase
309    * @param _weiAmount Value in wei involved in the purchase
310    */
311   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
312     require(_beneficiary != address(0));
313     require(_weiAmount != 0);
314   }
315 
316   /**
317    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
318    * @param _beneficiary Address performing the token purchase
319    * @param _weiAmount Value in wei involved in the purchase
320    */
321   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
322     // optional override
323   }
324 
325   /**
326    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
327    * @param _beneficiary Address performing the token purchase
328    * @param _tokenAmount Number of tokens to be emitted
329    */
330   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
331     token.transfer(_beneficiary, _tokenAmount);
332   }
333 
334   /**
335    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
336    * @param _beneficiary Address receiving the tokens
337    * @param _tokenAmount Number of tokens to be purchased
338    */
339   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
340     _deliverTokens(_beneficiary, _tokenAmount);
341   }
342 
343   /**
344    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
345    * @param _beneficiary Address receiving the tokens
346    * @param _weiAmount Value in wei involved in the purchase
347    */
348   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
349     // optional override
350   }
351 
352   /**
353    * @dev Override to extend the way in which ether is converted to tokens.
354    * @param _weiAmount Value in wei to be converted into tokens
355    * @return Number of tokens that can be purchased with the specified _weiAmount
356    */
357   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
358     return _weiAmount.mul(rate);
359   }
360 
361   /**
362    * @dev Determines how ETH is stored/forwarded on purchases.
363    */
364   function _forwardFunds() internal {
365     wallet.transfer(msg.value);
366   }
367 }
368 
369 /**
370  * @title MultiOwnable
371  */
372 contract MultiOwnable {
373   address public root;
374   mapping (address => address) public owners; // owner => parent of owner
375   
376   /**
377   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
378   * account.
379   */
380   constructor() public {
381     root = msg.sender;
382     owners[root] = root;
383   }
384   
385   /**
386   * @dev Throws if called by any account other than the owner.
387   */
388   modifier onlyOwner() {
389     require(owners[msg.sender] != 0);
390     _;
391   }
392   
393   /**
394   * @dev Adding new owners
395   */
396   function newOwner(address _owner) onlyOwner external returns (bool) {
397     require(_owner != 0);
398     owners[_owner] = msg.sender;
399     return true;
400   }
401   
402   /**
403     * @dev Deleting owners
404     */
405   function deleteOwner(address _owner) onlyOwner external returns (bool) {
406     require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
407     owners[_owner] = 0;
408     return true;
409   }
410 }
411 
412 /**
413  * @title WhitelistedCrowdsale
414  * @dev Crowdsale in which only whitelisted users can contribute.
415  */
416 contract WhitelistedCrowdsale is Crowdsale, MultiOwnable {
417 
418   mapping(address => bool) public whitelist;
419 
420   /**
421    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
422    */
423   modifier isWhitelisted(address _beneficiary) {
424     require(whitelist[_beneficiary]);
425     _;
426   }
427 
428   /**
429    * @dev Adds single address to whitelist.
430    * @param _beneficiary Address to be added to the whitelist
431    */
432   function addToWhitelist(address _beneficiary) external onlyOwner {
433     whitelist[_beneficiary] = true;
434   }
435 
436   /**
437    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
438    * @param _beneficiaries Addresses to be added to the whitelist
439    */
440   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
441     for (uint256 i = 0; i < _beneficiaries.length; i++) {
442       whitelist[_beneficiaries[i]] = true;
443     }
444   }
445 
446   /**
447    * @dev Removes single address from whitelist.
448    * @param _beneficiary Address to be removed to the whitelist
449    */
450   function removeFromWhitelist(address _beneficiary) external onlyOwner {
451     whitelist[_beneficiary] = false;
452   }
453 
454   /**
455    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
456    * @param _beneficiary Token beneficiary
457    * @param _weiAmount Amount of wei contributed
458    */
459   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
460     super._preValidatePurchase(_beneficiary, _weiAmount);
461   }
462 
463 }
464 
465 /**
466  * @title IndividuallyCappedCrowdsale
467  * @dev Crowdsale with per-user caps.
468  */
469 contract IndividuallyCappedCrowdsale is Crowdsale {
470   using SafeMath for uint256;
471 
472   mapping(address => uint256) public contributions;
473   uint256 public individualCap;
474 
475   constructor(uint256 _individualCap) public {
476     individualCap = _individualCap;
477   }
478 
479   /**
480    * @dev Returns the cap per a user.
481    * @return Current cap for individual user
482    */
483   function getUserCap() public view returns (uint256) {
484     return individualCap;
485   }
486 
487   /**
488    * @dev Returns the amount contributed so far by a sepecific user.
489    * @param _beneficiary Address of contributor
490    * @return User contribution so far
491    */
492   function getUserContribution(address _beneficiary) public view returns (uint256) {
493     return contributions[_beneficiary];
494   }
495 
496   /**
497    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
498    * @param _beneficiary Token purchaser
499    * @param _weiAmount Amount of wei contributed
500    */
501   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
502     super._preValidatePurchase(_beneficiary, _weiAmount);
503     require(contributions[_beneficiary].add(_weiAmount) <= individualCap);
504   }
505 
506   /**
507    * @dev Extend parent behavior to update user contributions
508    * @param _beneficiary Token purchaser
509    * @param _weiAmount Amount of wei contributed
510    */
511   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
512     super._updatePurchasingState(_beneficiary, _weiAmount);
513     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
514   }
515 
516 }
517 
518 /**
519  * @title Mintable token
520  * @dev Simple ERC20 Token example, with mintable token creation
521  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
522  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
523  */
524 contract MintableToken is StandardToken, MultiOwnable {
525   event Mint(address indexed to, uint256 amount);
526   event MintFinished();
527 
528   bool public mintingFinished = false;
529 
530 
531   modifier canMint() {
532     require(!mintingFinished);
533     _;
534   }
535 
536   /**
537    * @dev Function to mint tokens
538    * @param _to The address that will receive the minted tokens.
539    * @param _amount The amount of tokens to mint.
540    * @return A boolean that indicates if the operation was successful.
541    */
542   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
543     totalSupply_ = totalSupply_.add(_amount);
544     balances[_to] = balances[_to].add(_amount);
545     emit Mint(_to, _amount);
546     emit Transfer(address(0), _to, _amount);
547     return true;
548   }
549 
550   /**
551    * @dev Function to stop minting new tokens.
552    * @return True if the operation was successful.
553    */
554   function finishMinting() onlyOwner canMint public returns (bool) {
555     mintingFinished = true;
556     emit MintFinished();
557     return true;
558   }
559 }
560 
561 /**
562  * @title Burnable Token
563  * @dev Token that can be irreversibly burned (destroyed).
564  */
565 contract BurnableToken is BasicToken {
566 
567   event Burn(address indexed burner, uint256 value);
568 
569   /**
570    * @dev Burns a specific amount of tokens.
571    * @param _value The amount of token to be burned.
572    */
573   function burn(uint256 _value) public {
574     _burn(msg.sender, _value);
575   }
576 
577   function _burn(address _who, uint256 _value) internal {
578     require(_value <= balances[_who]);
579     // no need to require value <= totalSupply, since that would imply the
580     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
581 
582     balances[_who] = balances[_who].sub(_value);
583     totalSupply_ = totalSupply_.sub(_value);
584     emit Burn(_who, _value);
585     emit Transfer(_who, address(0), _value);
586   }
587 }
588 
589 /**
590  * @title Basic token
591  * @dev Basic version of StandardToken, with no allowances.
592  */
593 contract Blacklisted is MultiOwnable {
594 
595   mapping(address => bool) public blacklist;
596 
597   /**
598   * @dev Throws if called by any account other than the owner.
599   */
600   modifier notBlacklisted() {
601     require(blacklist[msg.sender] == false);
602     _;
603   }
604 
605   /**
606    * @dev Adds single address to blacklist.
607    * @param _villain Address to be added to the blacklist
608    */
609   function addToBlacklist(address _villain) external onlyOwner {
610     blacklist[_villain] = true;
611   }
612 
613   /**
614    * @dev Adds list of addresses to blacklist. Not overloaded due to limitations with truffle testing.
615    * @param _villains Addresses to be added to the blacklist
616    */
617   function addManyToBlacklist(address[] _villains) external onlyOwner {
618     for (uint256 i = 0; i < _villains.length; i++) {
619       blacklist[_villains[i]] = true;
620     }
621   }
622 
623   /**
624    * @dev Removes single address from blacklist.
625    * @param _villain Address to be removed to the blacklist
626    */
627   function removeFromBlacklist(address _villain) external onlyOwner {
628     blacklist[_villain] = false;
629   }
630 }
631 
632 
633 contract HUMToken is MintableToken, BurnableToken, Blacklisted {
634 
635   string public constant name = "HUMToken"; // solium-disable-line uppercase
636   string public constant symbol = "HUM"; // solium-disable-line uppercase
637   uint8 public constant decimals = 18; // solium-disable-line uppercase, // 18 decimals is the strongly suggested default, avoid changing it
638 
639   uint256 public constant INITIAL_SUPPLY = 2500 * 1000 * 1000 * (10 ** uint256(decimals)); // 2,500,000,000 HUM
640 
641   bool public isUnlocked = false;
642   
643   /**
644    * @dev Constructor that gives msg.sender all of existing tokens.
645    */
646   constructor(address _wallet) public {
647     totalSupply_ = INITIAL_SUPPLY;
648     balances[_wallet] = INITIAL_SUPPLY;
649     emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
650   }
651 
652   modifier onlyTransferable() {
653     require(isUnlocked || owners[msg.sender] != 0);
654     _;
655   }
656 
657   function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
658       return super.transferFrom(_from, _to, _value);
659   }
660 
661   function transfer(address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
662       return super.transfer(_to, _value);
663   }
664   
665   function unlockTransfer() public onlyOwner {
666       isUnlocked = true;
667   }
668   
669   function lockTransfer() public onlyOwner {
670       isUnlocked = false;
671   }
672 
673 }
674 
675 contract HUMPresale is WhitelistedCrowdsale, IndividuallyCappedCrowdsale {
676   
677   uint256 public constant minimum = 100000000000000000; // 0.1 ether
678   bool public isOnSale = false;
679 
680   mapping(address => uint256) public bonusTokens;
681   uint256 public bonusPercent;
682   address[] public contributors;
683 
684   event DistrubuteBonusTokens(address indexed sender);
685   event Withdraw(address indexed _from, uint256 _amount);
686 
687   constructor (
688     uint256 _rate,
689     uint256 _bonusPercent,
690     address _wallet,
691     HUMToken _token,
692     uint256 _individualCapEther
693   ) 
694     public
695     Crowdsale(_rate, _wallet, _token)
696     IndividuallyCappedCrowdsale(_individualCapEther.mul(10 ** 18))
697   { 
698     bonusPercent = _bonusPercent;
699   }
700 
701   function modifyTokenPrice(uint256 _rate) public onlyOwner {
702     rate = _rate;
703   }
704 
705   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
706     super._processPurchase(_beneficiary, _tokenAmount);
707 
708     if (bonusPercent > 0) {
709       if (contributions[_beneficiary] == 0) {
710         contributors.push(_beneficiary);
711       }
712       bonusTokens[_beneficiary] = bonusTokens[_beneficiary].add(_tokenAmount.mul(bonusPercent).div(1000));
713     }
714   }
715 
716   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
717     super._preValidatePurchase(_beneficiary, _weiAmount);
718 
719     bool isOverMinimum = _weiAmount >= minimum;
720   
721     require(isOverMinimum && isOnSale);
722   }
723 
724   function openSale() public onlyOwner {
725     require(!isOnSale);
726 
727     isOnSale = true;
728   }
729 
730   function closeSale() public onlyOwner {
731     require(isOnSale);
732 
733     if (token.balanceOf(this) > 0) {
734       withdrawToken();
735     }
736 
737     isOnSale = false;
738   }
739 
740   function withdrawToken() public onlyOwner {
741     uint256 balanceOfThis = token.balanceOf(this);
742     token.transfer(wallet, balanceOfThis);
743     emit Withdraw(wallet, balanceOfThis);
744   }
745 
746   function distributeBonusTokens() public onlyOwner {
747     require(!isOnSale);
748 
749     for (uint i = 0; i < contributors.length; i++) {
750       if (bonusTokens[contributors[i]] > 0) {
751         token.transferFrom(wallet, contributors[i], bonusTokens[contributors[i]]);
752         bonusTokens[contributors[i]] = 0;
753       }
754     }
755 
756     emit DistrubuteBonusTokens(msg.sender);
757   }
758 
759   function getContributors() public view onlyOwner returns(address[]) {
760     return contributors;
761   }
762 
763   /// @dev get addresses who has bonus tokens
764   /// @return Returns array of addresses.
765   function getBonusList() public view onlyOwner returns(address[]) {
766     address[] memory contributorsTmp = new address[](contributors.length);
767     uint count = 0;
768     uint i;
769 
770     for (i = 0; i < contributors.length; i++) {
771       if (bonusTokens[contributors[i]] > 0) {
772         contributorsTmp[count] = contributors[i];
773         count += 1;
774       }
775     }
776     
777     address[] memory _bonusList = new address[](count);
778     for (i = 0; i < count; i++) {
779       _bonusList[i] = contributorsTmp[i];
780     }
781 
782     return _bonusList;
783   }
784 
785   /// @dev distribute bonus tokens to addresses who has bonus tokens
786   /// @param _bonusList array of addresses who has bonus tokens.
787   function distributeBonusTokensByList(address[] _bonusList) public onlyOwner {
788     require(!isOnSale);
789 
790     for (uint i = 0; i < _bonusList.length; i++) {
791       if (bonusTokens[_bonusList[i]] > 0) {
792         token.transferFrom(wallet, _bonusList[i], bonusTokens[_bonusList[i]]);
793         bonusTokens[_bonusList[i]] = 0;
794       }
795     }
796 
797     emit DistrubuteBonusTokens(msg.sender);
798   }
799 
800 }