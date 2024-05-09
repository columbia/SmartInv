1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title MultiOwnable
5  */
6 contract MultiOwnable {
7   address public root;
8   mapping (address => address) public owners; // owner => parent of owner
9   
10   /**
11   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12   * account.
13   */
14   constructor() public {
15     root = msg.sender;
16     owners[root] = root;
17   }
18   
19   /**
20   * @dev Throws if called by any account other than the owner.
21   */
22   modifier onlyOwner() {
23     require(owners[msg.sender] != 0);
24     _;
25   }
26   
27   /**
28   * @dev Adding new owners
29   */
30   function newOwner(address _owner) onlyOwner external returns (bool) {
31     require(_owner != 0);
32     owners[_owner] = msg.sender;
33     return true;
34   }
35   
36   /**
37     * @dev Deleting owners
38     */
39   function deleteOwner(address _owner) onlyOwner external returns (bool) {
40     require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
41     owners[_owner] = 0;
42     return true;
43   }
44 }
45 
46 
47 
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
61 
62 
63 
64 
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) public view returns (uint256);
72   function transferFrom(address from, address to, uint256 value) public returns (bool);
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 
79 
80 
81 
82 /**
83  * @title SafeMath
84  * @dev Math operations with safety checks that throw on error
85  */
86 library SafeMath {
87 
88   /**
89   * @dev Multiplies two numbers, throws on overflow.
90   */
91   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92     if (a == 0) {
93       return 0;
94     }
95     uint256 c = a * b;
96     assert(c / a == b);
97     return c;
98   }
99 
100   /**
101   * @dev Integer division of two numbers, truncating the quotient.
102   */
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     // assert(b > 0); // Solidity automatically throws when dividing by 0
105     // uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107     return a / b;
108   }
109 
110   /**
111   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
112   */
113   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   /**
119   * @dev Adds two numbers, throws on overflow.
120   */
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 
129 
130 
131 
132 
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic {
138   using SafeMath for uint256;
139 
140   mapping(address => uint256) balances;
141 
142   uint256 totalSupply_;
143 
144   /**
145   * @dev total number of tokens in existence
146   */
147   function totalSupply() public view returns (uint256) {
148     return totalSupply_;
149   }
150 
151   /**
152   * @dev transfer token for a specified address
153   * @param _to The address to transfer to.
154   * @param _value The amount to be transferred.
155   */
156   function transfer(address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[msg.sender]);
159 
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     emit Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param _owner The address to query the the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address _owner) public view returns (uint256 balance) {
172     return balances[_owner];
173   }
174 
175 }
176 
177 
178 
179 
180 
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * @dev https://github.com/ethereum/EIPs/issues/20
187  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract StandardToken is ERC20, BasicToken {
190 
191   mapping (address => mapping (address => uint256)) internal allowed;
192 
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208     emit Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214    *
215    * Beware that changing an allowance with this method brings the risk that someone may use both the old
216    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    * @param _spender The address which will spend the funds.
220    * @param _value The amount of tokens to be spent.
221    */
222   function approve(address _spender, uint256 _value) public returns (bool) {
223     allowed[msg.sender][_spender] = _value;
224     emit Approval(msg.sender, _spender, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Function to check the amount of tokens that an owner allowed to a spender.
230    * @param _owner address The address which owns the funds.
231    * @param _spender address The address which will spend the funds.
232    * @return A uint256 specifying the amount of tokens still available for the spender.
233    */
234   function allowance(address _owner, address _spender) public view returns (uint256) {
235     return allowed[_owner][_spender];
236   }
237 
238   /**
239    * @dev Increase the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _addedValue The amount of tokens to increase the allowance by.
247    */
248   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
249     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To decrement
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _subtractedValue The amount of tokens to decrease the allowance by.
263    */
264   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 
278 
279 
280 
281 
282 /**
283  * @title Mintable token
284  * @dev Simple ERC20 Token example, with mintable token creation
285  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
286  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
287  */
288 contract MintableToken is StandardToken, MultiOwnable {
289   event Mint(address indexed to, uint256 amount);
290   event MintFinished();
291 
292   bool public mintingFinished = false;
293 
294 
295   modifier canMint() {
296     require(!mintingFinished);
297     _;
298   }
299 
300   /**
301    * @dev Function to mint tokens
302    * @param _to The address that will receive the minted tokens.
303    * @param _amount The amount of tokens to mint.
304    * @return A boolean that indicates if the operation was successful.
305    */
306   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
307     totalSupply_ = totalSupply_.add(_amount);
308     balances[_to] = balances[_to].add(_amount);
309     emit Mint(_to, _amount);
310     emit Transfer(address(0), _to, _amount);
311     return true;
312   }
313 
314   /**
315    * @dev Function to stop minting new tokens.
316    * @return True if the operation was successful.
317    */
318   function finishMinting() onlyOwner canMint public returns (bool) {
319     mintingFinished = true;
320     emit MintFinished();
321     return true;
322   }
323 }
324 
325 
326 
327 
328 
329 
330 /**
331  * @title Burnable Token
332  * @dev Token that can be irreversibly burned (destroyed).
333  */
334 contract BurnableToken is BasicToken {
335 
336   event Burn(address indexed burner, uint256 value);
337 
338   /**
339    * @dev Burns a specific amount of tokens.
340    * @param _value The amount of token to be burned.
341    */
342   function burn(uint256 _value) public {
343     _burn(msg.sender, _value);
344   }
345 
346   function _burn(address _who, uint256 _value) internal {
347     require(_value <= balances[_who]);
348     // no need to require value <= totalSupply, since that would imply the
349     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
350 
351     balances[_who] = balances[_who].sub(_value);
352     totalSupply_ = totalSupply_.sub(_value);
353     emit Burn(_who, _value);
354     emit Transfer(_who, address(0), _value);
355   }
356 }
357 
358 
359 
360 
361 
362 
363 /**
364  * @title HUMToken
365  * @dev ERC20 HUMToken.
366  * Note they can later distribute these tokens as they wish using `transfer` and other
367  * `StandardToken` functions.
368  */
369 contract HUMToken is MintableToken, BurnableToken {
370 
371   string public constant name = "HUMToken"; // solium-disable-line uppercase
372   string public constant symbol = "HUM"; // solium-disable-line uppercase
373   uint8 public constant decimals = 18; // solium-disable-line uppercase, // 18 decimals is the strongly suggested default, avoid changing it
374 
375   uint256 public constant INITIAL_SUPPLY = 2500 * 1000 * 1000 * (10 ** uint256(decimals)); // 2,500,000,000 HUM
376 
377   bool public isUnlocked = false;
378   
379   /**
380    * @dev Constructor that gives msg.sender all of existing tokens.
381    */
382   constructor(address _wallet) public {
383     totalSupply_ = INITIAL_SUPPLY;
384     balances[_wallet] = INITIAL_SUPPLY;
385     emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
386   }
387 
388   modifier onlyTransferable() {
389     require(isUnlocked || owners[msg.sender] != 0);
390     _;
391   }
392 
393   function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable returns (bool) {
394       return super.transferFrom(_from, _to, _value);
395   }
396 
397   function transfer(address _to, uint256 _value) public onlyTransferable returns (bool) {
398       return super.transfer(_to, _value);
399   }
400   
401   function unlockTransfer() public onlyOwner {
402       isUnlocked = true;
403   }
404 
405 }
406 
407 
408 
409 
410 
411 
412 /**
413  * @title Crowdsale
414  * @dev Crowdsale is a base contract for managing a token crowdsale,
415  * allowing investors to purchase tokens with ether. This contract implements
416  * such functionality in its most fundamental form and can be extended to provide additional
417  * functionality and/or custom behavior.
418  * The external interface represents the basic interface for purchasing tokens, and conform
419  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
420  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
421  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
422  * behavior.
423  */
424 contract Crowdsale {
425   using SafeMath for uint256;
426 
427   // The token being sold
428   ERC20 public token;
429 
430   // Address where funds are collected
431   address public wallet;
432 
433   // How many token units a buyer gets per wei
434   uint256 public rate;
435 
436   // Amount of wei raised
437   uint256 public weiRaised;
438 
439   /**
440    * Event for token purchase logging
441    * @param purchaser who paid for the tokens
442    * @param beneficiary who got the tokens
443    * @param value weis paid for purchase
444    * @param amount amount of tokens purchased
445    */
446   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
447 
448   /**
449    * @param _rate Number of token units a buyer gets per wei
450    * @param _wallet Address where collected funds will be forwarded to
451    * @param _token Address of the token being sold
452    */
453   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
454     require(_rate > 0);
455     require(_wallet != address(0));
456     require(_token != address(0));
457 
458     rate = _rate;
459     wallet = _wallet;
460     token = _token;
461   }
462 
463   // -----------------------------------------
464   // Crowdsale external interface
465   // -----------------------------------------
466 
467   /**
468    * @dev fallback function ***DO NOT OVERRIDE***
469    */
470   function () external payable {
471     buyTokens(msg.sender);
472   }
473 
474   /**
475    * @dev low level token purchase ***DO NOT OVERRIDE***
476    * @param _beneficiary Address performing the token purchase
477    */
478   function buyTokens(address _beneficiary) public payable {
479 
480     uint256 weiAmount = msg.value;
481     _preValidatePurchase(_beneficiary, weiAmount);
482 
483     // calculate token amount to be created
484     uint256 tokens = _getTokenAmount(weiAmount);
485 
486     // update state
487     weiRaised = weiRaised.add(weiAmount);
488 
489     _processPurchase(_beneficiary, tokens);
490     emit TokenPurchase(
491       msg.sender,
492       _beneficiary,
493       weiAmount,
494       tokens
495     );
496 
497     _updatePurchasingState(_beneficiary, weiAmount);
498 
499     _forwardFunds();
500     _postValidatePurchase(_beneficiary, weiAmount);
501   }
502 
503   // -----------------------------------------
504   // Internal interface (extensible)
505   // -----------------------------------------
506 
507   /**
508    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
509    * @param _beneficiary Address performing the token purchase
510    * @param _weiAmount Value in wei involved in the purchase
511    */
512   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
513     require(_beneficiary != address(0));
514     require(_weiAmount != 0);
515   }
516 
517   /**
518    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
519    * @param _beneficiary Address performing the token purchase
520    * @param _weiAmount Value in wei involved in the purchase
521    */
522   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
523     // optional override
524   }
525 
526   /**
527    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
528    * @param _beneficiary Address performing the token purchase
529    * @param _tokenAmount Number of tokens to be emitted
530    */
531   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
532     token.transfer(_beneficiary, _tokenAmount);
533   }
534 
535   /**
536    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
537    * @param _beneficiary Address receiving the tokens
538    * @param _tokenAmount Number of tokens to be purchased
539    */
540   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
541     _deliverTokens(_beneficiary, _tokenAmount);
542   }
543 
544   /**
545    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
546    * @param _beneficiary Address receiving the tokens
547    * @param _weiAmount Value in wei involved in the purchase
548    */
549   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
550     // optional override
551   }
552 
553   /**
554    * @dev Override to extend the way in which ether is converted to tokens.
555    * @param _weiAmount Value in wei to be converted into tokens
556    * @return Number of tokens that can be purchased with the specified _weiAmount
557    */
558   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
559     return _weiAmount.mul(rate);
560   }
561 
562   /**
563    * @dev Determines how ETH is stored/forwarded on purchases.
564    */
565   function _forwardFunds() internal {
566     wallet.transfer(msg.value);
567   }
568 }
569 
570 
571 
572 
573 
574 
575 /**
576  * @title IndividuallyCappedCrowdsale
577  * @dev Crowdsale with per-user caps.
578  */
579 contract IndividuallyCappedCrowdsale is Crowdsale {
580   using SafeMath for uint256;
581 
582   mapping(address => uint256) public contributions;
583   uint256 public individualCap;
584 
585   constructor(uint256 _individualCap) public {
586     individualCap = _individualCap;
587   }
588 
589   /**
590    * @dev Returns the cap per a user.
591    * @return Current cap for individual user
592    */
593   function getUserCap() public view returns (uint256) {
594     return individualCap;
595   }
596 
597   /**
598    * @dev Returns the amount contributed so far by a sepecific user.
599    * @param _beneficiary Address of contributor
600    * @return User contribution so far
601    */
602   function getUserContribution(address _beneficiary) public view returns (uint256) {
603     return contributions[_beneficiary];
604   }
605 
606   /**
607    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
608    * @param _beneficiary Token purchaser
609    * @param _weiAmount Amount of wei contributed
610    */
611   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
612     super._preValidatePurchase(_beneficiary, _weiAmount);
613     require(contributions[_beneficiary].add(_weiAmount) <= individualCap);
614   }
615 
616   /**
617    * @dev Extend parent behavior to update user contributions
618    * @param _beneficiary Token purchaser
619    * @param _weiAmount Amount of wei contributed
620    */
621   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
622     super._updatePurchasingState(_beneficiary, _weiAmount);
623     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
624   }
625 
626 }
627 
628 
629 
630 
631 
632 
633 /**
634  * @title WhitelistedCrowdsale
635  * @dev Crowdsale in which only whitelisted users can contribute.
636  */
637 contract WhitelistedCrowdsale is Crowdsale, MultiOwnable {
638 
639   mapping(address => bool) public whitelist;
640 
641   /**
642    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
643    */
644   modifier isWhitelisted(address _beneficiary) {
645     require(whitelist[_beneficiary]);
646     _;
647   }
648 
649   /**
650    * @dev Adds single address to whitelist.
651    * @param _beneficiary Address to be added to the whitelist
652    */
653   function addToWhitelist(address _beneficiary) external onlyOwner {
654     whitelist[_beneficiary] = true;
655   }
656 
657   /**
658    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
659    * @param _beneficiaries Addresses to be added to the whitelist
660    */
661   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
662     for (uint256 i = 0; i < _beneficiaries.length; i++) {
663       whitelist[_beneficiaries[i]] = true;
664     }
665   }
666 
667   /**
668    * @dev Removes single address from whitelist.
669    * @param _beneficiary Address to be removed to the whitelist
670    */
671   function removeFromWhitelist(address _beneficiary) external onlyOwner {
672     whitelist[_beneficiary] = false;
673   }
674 
675   /**
676    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
677    * @param _beneficiary Token beneficiary
678    * @param _weiAmount Amount of wei contributed
679    */
680   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
681     super._preValidatePurchase(_beneficiary, _weiAmount);
682   }
683 
684 }
685 
686 
687 
688 
689 
690 
691 contract HUMPresale is WhitelistedCrowdsale, IndividuallyCappedCrowdsale {
692   
693   uint256 public constant minimum = 100000000000000000; // 0.1 ether
694   bool public isOnSale = false;
695 
696   mapping(address => uint256) public bonusTokens;
697   uint256 public bonusPercent;
698   address[] public contributors;
699 
700   event DistrubuteBonusTokens(address indexed sender);
701   event Withdraw(address indexed _from, uint256 _amount);
702 
703   constructor (
704     uint256 _rate,
705     uint256 _bonusPercent,
706     address _wallet,
707     HUMToken _token,
708     uint256 _individualCapEther
709   ) 
710     public
711     Crowdsale(_rate, _wallet, _token)
712     IndividuallyCappedCrowdsale(_individualCapEther.mul(10 ** 18))
713   { 
714     bonusPercent = _bonusPercent;
715   }
716 
717   function modifyTokenPrice(uint256 _rate) public onlyOwner {
718     rate = _rate;
719   }
720 
721   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
722     super._processPurchase(_beneficiary, _tokenAmount);
723 
724     if (bonusPercent > 0) {
725       if (contributions[_beneficiary] == 0) {
726         contributors.push(_beneficiary);
727       }
728       bonusTokens[_beneficiary] = bonusTokens[_beneficiary].add(_tokenAmount.mul(bonusPercent).div(1000));
729     }
730   }
731 
732   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
733     super._preValidatePurchase(_beneficiary, _weiAmount);
734 
735     bool isOverMinimum = _weiAmount >= minimum;
736   
737     require(isOverMinimum && isOnSale);
738   }
739 
740   function openSale() public onlyOwner {
741     require(!isOnSale);
742 
743     isOnSale = true;
744   }
745 
746   function closeSale() public onlyOwner {
747     require(isOnSale);
748 
749     if (token.balanceOf(this) > 0) {
750       withdrawToken();
751     }
752 
753     isOnSale = false;
754   }
755 
756   function withdrawToken() public onlyOwner {
757     uint256 balanceOfThis = token.balanceOf(this);
758     token.transfer(wallet, balanceOfThis);
759     emit Withdraw(wallet, balanceOfThis);
760   }
761 
762   function distributeBonusTokens() public onlyOwner {
763     require(!isOnSale);
764 
765     for (uint i = 0; i < contributors.length; i++) {
766       if (bonusTokens[contributors[i]] > 0) {
767         token.transferFrom(wallet, contributors[i], bonusTokens[contributors[i]]);
768         bonusTokens[contributors[i]] = 0;
769       }
770     }
771 
772     emit DistrubuteBonusTokens(msg.sender);
773   }
774 
775   function getContributors() public view onlyOwner returns(address[]) {
776     return contributors;
777   }
778 
779   /// @dev get addresses who has bonus tokens
780   /// @return Returns array of addresses.
781   function getBonusList() public view onlyOwner returns(address[]) {
782     address[] memory contributorsTmp = new address[](contributors.length);
783     uint count = 0;
784     uint i;
785 
786     for (i = 0; i < contributors.length; i++) {
787       if (bonusTokens[contributors[i]] > 0) {
788         contributorsTmp[count] = contributors[i];
789         count += 1;
790       }
791     }
792     
793     address[] memory _bonusList = new address[](count);
794     for (i = 0; i < count; i++) {
795       _bonusList[i] = contributorsTmp[i];
796     }
797 
798     return _bonusList;
799   }
800 
801   /// @dev distribute bonus tokens to addresses who has bonus tokens
802   /// @param _bonusList array of addresses who has bonus tokens.
803   function distributeBonusTokensByList(address[] _bonusList) public onlyOwner {
804     require(!isOnSale);
805 
806     for (uint i = 0; i < _bonusList.length; i++) {
807       if (bonusTokens[_bonusList[i]] > 0) {
808         token.transferFrom(wallet, _bonusList[i], bonusTokens[_bonusList[i]]);
809         bonusTokens[_bonusList[i]] = 0;
810       }
811     }
812 
813     emit DistrubuteBonusTokens(msg.sender);
814   }
815 
816 }