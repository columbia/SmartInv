1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   uint256 totalSupply_;
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256 balance) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     emit Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     emit Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 /**
215  * @title Crowdsale
216  * @dev Crowdsale is a base contract for managing a token crowdsale,
217  * allowing investors to purchase tokens with ether. This contract implements
218  * such functionality in its most fundamental form and can be extended to provide additional
219  * functionality and/or custom behavior.
220  * The external interface represents the basic interface for purchasing tokens, and conform
221  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
222  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
223  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
224  * behavior.
225  */
226 contract Crowdsale {
227   using SafeMath for uint256;
228 
229   // The token being sold
230   ERC20 public token;
231 
232   // Address where funds are collected
233   address public wallet;
234 
235   // How many token units a buyer gets per wei
236   uint256 public rate;
237 
238   // Amount of wei raised
239   uint256 public weiRaised;
240 
241   /**
242    * Event for token purchase logging
243    * @param purchaser who paid for the tokens
244    * @param beneficiary who got the tokens
245    * @param value weis paid for purchase
246    * @param amount amount of tokens purchased
247    */
248   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
249 
250   /**
251    * @param _rate Number of token units a buyer gets per wei
252    * @param _wallet Address where collected funds will be forwarded to
253    * @param _token Address of the token being sold
254    */
255   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
256     require(_rate > 0);
257     require(_wallet != address(0));
258     require(_token != address(0));
259 
260     rate = _rate;
261     wallet = _wallet;
262     token = _token;
263   }
264 
265   // -----------------------------------------
266   // Crowdsale external interface
267   // -----------------------------------------
268 
269   /**
270    * @dev fallback function ***DO NOT OVERRIDE***
271    */
272   function () external payable {
273     buyTokens(msg.sender);
274   }
275 
276   /**
277    * @dev low level token purchase ***DO NOT OVERRIDE***
278    * @param _beneficiary Address performing the token purchase
279    */
280   function buyTokens(address _beneficiary) public payable {
281 
282     uint256 weiAmount = msg.value;
283     _preValidatePurchase(_beneficiary, weiAmount);
284 
285     // calculate token amount to be created
286     uint256 tokens = _getTokenAmount(weiAmount);
287 
288     // update state
289     weiRaised = weiRaised.add(weiAmount);
290 
291     _processPurchase(_beneficiary, tokens);
292     emit TokenPurchase(
293       msg.sender,
294       _beneficiary,
295       weiAmount,
296       tokens
297     );
298 
299     _updatePurchasingState(_beneficiary, weiAmount);
300 
301     _forwardFunds();
302     _postValidatePurchase(_beneficiary, weiAmount);
303   }
304 
305   // -----------------------------------------
306   // Internal interface (extensible)
307   // -----------------------------------------
308 
309   /**
310    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
311    * @param _beneficiary Address performing the token purchase
312    * @param _weiAmount Value in wei involved in the purchase
313    */
314   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
315     require(_beneficiary != address(0));
316     require(_weiAmount != 0);
317   }
318 
319   /**
320    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
321    * @param _beneficiary Address performing the token purchase
322    * @param _weiAmount Value in wei involved in the purchase
323    */
324   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
325     // optional override
326   }
327 
328   /**
329    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
330    * @param _beneficiary Address performing the token purchase
331    * @param _tokenAmount Number of tokens to be emitted
332    */
333   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
334     token.transfer(_beneficiary, _tokenAmount);
335   }
336 
337   /**
338    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
339    * @param _beneficiary Address receiving the tokens
340    * @param _tokenAmount Number of tokens to be purchased
341    */
342   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
343     _deliverTokens(_beneficiary, _tokenAmount);
344   }
345 
346   /**
347    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
348    * @param _beneficiary Address receiving the tokens
349    * @param _weiAmount Value in wei involved in the purchase
350    */
351   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
352     // optional override
353   }
354 
355   /**
356    * @dev Override to extend the way in which ether is converted to tokens.
357    * @param _weiAmount Value in wei to be converted into tokens
358    * @return Number of tokens that can be purchased with the specified _weiAmount
359    */
360   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
361     return _weiAmount.mul(rate);
362   }
363 
364   /**
365    * @dev Determines how ETH is stored/forwarded on purchases.
366    */
367   function _forwardFunds() internal {
368     wallet.transfer(msg.value);
369   }
370 }
371 
372 /**
373  * @title MultiOwnable
374  */
375 contract MultiOwnable {
376   address public root;
377   mapping (address => address) public owners; // owner => parent of owner
378   
379   /**
380   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
381   * account.
382   */
383   constructor() public {
384     root = msg.sender;
385     owners[root] = root;
386   }
387   
388   /**
389   * @dev Throws if called by any account other than the owner.
390   */
391   modifier onlyOwner() {
392     require(owners[msg.sender] != 0);
393     _;
394   }
395   
396   /**
397   * @dev Adding new owners
398   */
399   function newOwner(address _owner) onlyOwner external returns (bool) {
400     require(_owner != 0);
401     owners[_owner] = msg.sender;
402     return true;
403   }
404   
405   /**
406     * @dev Deleting owners
407     */
408   function deleteOwner(address _owner) onlyOwner external returns (bool) {
409     require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
410     owners[_owner] = 0;
411     return true;
412   }
413 }
414 
415 /**
416  * @title WhitelistedCrowdsale
417  * @dev Crowdsale in which only whitelisted users can contribute.
418  */
419 contract WhitelistedCrowdsale is Crowdsale, MultiOwnable {
420 
421   mapping(address => bool) public whitelist;
422 
423   /**
424    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
425    */
426   modifier isWhitelisted(address _beneficiary) {
427     require(whitelist[_beneficiary]);
428     _;
429   }
430 
431   /**
432    * @dev Adds single address to whitelist.
433    * @param _beneficiary Address to be added to the whitelist
434    */
435   function addToWhitelist(address _beneficiary) external onlyOwner {
436     whitelist[_beneficiary] = true;
437   }
438 
439   /**
440    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
441    * @param _beneficiaries Addresses to be added to the whitelist
442    */
443   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
444     for (uint256 i = 0; i < _beneficiaries.length; i++) {
445       whitelist[_beneficiaries[i]] = true;
446     }
447   }
448 
449   /**
450    * @dev Removes single address from whitelist.
451    * @param _beneficiary Address to be removed to the whitelist
452    */
453   function removeFromWhitelist(address _beneficiary) external onlyOwner {
454     whitelist[_beneficiary] = false;
455   }
456 
457   /**
458    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
459    * @param _beneficiary Token beneficiary
460    * @param _weiAmount Amount of wei contributed
461    */
462   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
463     super._preValidatePurchase(_beneficiary, _weiAmount);
464   }
465 
466 }
467 
468 /**
469  * @title IndividuallyCappedCrowdsale
470  * @dev Crowdsale with per-user caps.
471  */
472 contract IndividuallyCappedCrowdsale is Crowdsale {
473   using SafeMath for uint256;
474 
475   mapping(address => uint256) public contributions;
476   uint256 public individualCap;
477 
478   constructor(uint256 _individualCap) public {
479     individualCap = _individualCap;
480   }
481 
482   /**
483    * @dev Returns the cap per a user.
484    * @return Current cap for individual user
485    */
486   function getUserCap() public view returns (uint256) {
487     return individualCap;
488   }
489 
490   /**
491    * @dev Returns the amount contributed so far by a sepecific user.
492    * @param _beneficiary Address of contributor
493    * @return User contribution so far
494    */
495   function getUserContribution(address _beneficiary) public view returns (uint256) {
496     return contributions[_beneficiary];
497   }
498 
499   /**
500    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
501    * @param _beneficiary Token purchaser
502    * @param _weiAmount Amount of wei contributed
503    */
504   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
505     super._preValidatePurchase(_beneficiary, _weiAmount);
506     require(contributions[_beneficiary].add(_weiAmount) <= individualCap);
507   }
508 
509   /**
510    * @dev Extend parent behavior to update user contributions
511    * @param _beneficiary Token purchaser
512    * @param _weiAmount Amount of wei contributed
513    */
514   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
515     super._updatePurchasingState(_beneficiary, _weiAmount);
516     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
517   }
518 
519 }
520 
521 /**
522  * @title Mintable token
523  * @dev Simple ERC20 Token example, with mintable token creation
524  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
525  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
526  */
527 contract MintableToken is StandardToken, MultiOwnable {
528   event Mint(address indexed to, uint256 amount);
529   event MintFinished();
530 
531   bool public mintingFinished = false;
532 
533 
534   modifier canMint() {
535     require(!mintingFinished);
536     _;
537   }
538 
539   /**
540    * @dev Function to mint tokens
541    * @param _to The address that will receive the minted tokens.
542    * @param _amount The amount of tokens to mint.
543    * @return A boolean that indicates if the operation was successful.
544    */
545   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
546     totalSupply_ = totalSupply_.add(_amount);
547     balances[_to] = balances[_to].add(_amount);
548     emit Mint(_to, _amount);
549     emit Transfer(address(0), _to, _amount);
550     return true;
551   }
552 
553   /**
554    * @dev Function to stop minting new tokens.
555    * @return True if the operation was successful.
556    */
557   function finishMinting() onlyOwner canMint public returns (bool) {
558     mintingFinished = true;
559     emit MintFinished();
560     return true;
561   }
562 }
563 
564 /**
565  * @title Burnable Token
566  * @dev Token that can be irreversibly burned (destroyed).
567  */
568 contract BurnableToken is BasicToken {
569 
570   event Burn(address indexed burner, uint256 value);
571 
572   /**
573    * @dev Burns a specific amount of tokens.
574    * @param _value The amount of token to be burned.
575    */
576   function burn(uint256 _value) public {
577     _burn(msg.sender, _value);
578   }
579 
580   function _burn(address _who, uint256 _value) internal {
581     require(_value <= balances[_who]);
582     // no need to require value <= totalSupply, since that would imply the
583     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
584 
585     balances[_who] = balances[_who].sub(_value);
586     totalSupply_ = totalSupply_.sub(_value);
587     emit Burn(_who, _value);
588     emit Transfer(_who, address(0), _value);
589   }
590 }
591 
592 /**
593  * @title Basic token
594  * @dev Basic version of StandardToken, with no allowances.
595  */
596 contract Blacklisted is MultiOwnable {
597 
598   mapping(address => bool) public blacklist;
599 
600   /**
601   * @dev Throws if called by any account other than the owner.
602   */
603   modifier notBlacklisted() {
604     require(blacklist[msg.sender] == false);
605     _;
606   }
607 
608   /**
609    * @dev Adds single address to blacklist.
610    * @param _villain Address to be added to the blacklist
611    */
612   function addToBlacklist(address _villain) external onlyOwner {
613     blacklist[_villain] = true;
614   }
615 
616   /**
617    * @dev Adds list of addresses to blacklist. Not overloaded due to limitations with truffle testing.
618    * @param _villains Addresses to be added to the blacklist
619    */
620   function addManyToBlacklist(address[] _villains) external onlyOwner {
621     for (uint256 i = 0; i < _villains.length; i++) {
622       blacklist[_villains[i]] = true;
623     }
624   }
625 
626   /**
627    * @dev Removes single address from blacklist.
628    * @param _villain Address to be removed to the blacklist
629    */
630   function removeFromBlacklist(address _villain) external onlyOwner {
631     blacklist[_villain] = false;
632   }
633 }
634 
635 
636 contract HUMToken is MintableToken, BurnableToken, Blacklisted {
637 
638   string public constant name = "HUMToken"; // solium-disable-line uppercase
639   string public constant symbol = "HUM"; // solium-disable-line uppercase
640   uint8 public constant decimals = 18; // solium-disable-line uppercase, // 18 decimals is the strongly suggested default, avoid changing it
641 
642   uint256 public constant INITIAL_SUPPLY = 2500 * 1000 * 1000 * (10 ** uint256(decimals)); // 2,500,000,000 HUM
643 
644   bool public isUnlocked = false;
645   
646   /**
647    * @dev Constructor that gives msg.sender all of existing tokens.
648    */
649   constructor(address _wallet) public {
650     totalSupply_ = INITIAL_SUPPLY;
651     balances[_wallet] = INITIAL_SUPPLY;
652     emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
653   }
654 
655   modifier onlyTransferable() {
656     require(isUnlocked || owners[msg.sender] != 0);
657     _;
658   }
659 
660   function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
661       return super.transferFrom(_from, _to, _value);
662   }
663 
664   function transfer(address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
665       return super.transfer(_to, _value);
666   }
667   
668   function unlockTransfer() public onlyOwner {
669       isUnlocked = true;
670   }
671   
672   function lockTransfer() public onlyOwner {
673       isUnlocked = false;
674   }
675 
676 }
677 
678 contract HUMPresale is WhitelistedCrowdsale, IndividuallyCappedCrowdsale {
679   
680   uint256 public constant minimum = 100000000000000000; // 0.1 ether
681   bool public isOnSale = false;
682 
683   mapping(address => uint256) public bonusTokens;
684   uint256 public bonusPercent;
685   address[] public contributors;
686 
687   event DistrubuteBonusTokens(address indexed sender);
688   event Withdraw(address indexed _from, uint256 _amount);
689 
690   constructor (
691     uint256 _rate,
692     uint256 _bonusPercent,
693     address _wallet,
694     HUMToken _token,
695     uint256 _individualCapEther
696   ) 
697     public
698     Crowdsale(_rate, _wallet, _token)
699     IndividuallyCappedCrowdsale(_individualCapEther.mul(10 ** 18))
700   { 
701     bonusPercent = _bonusPercent;
702   }
703 
704   function modifyTokenPrice(uint256 _rate) public onlyOwner {
705     rate = _rate;
706   }
707 
708   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
709     super._processPurchase(_beneficiary, _tokenAmount);
710 
711     if (bonusPercent > 0) {
712       if (contributions[_beneficiary] == 0) {
713         contributors.push(_beneficiary);
714       }
715       bonusTokens[_beneficiary] = bonusTokens[_beneficiary].add(_tokenAmount.mul(bonusPercent).div(1000));
716     }
717   }
718 
719   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
720     super._preValidatePurchase(_beneficiary, _weiAmount);
721 
722     bool isOverMinimum = _weiAmount >= minimum;
723   
724     require(isOverMinimum && isOnSale);
725   }
726 
727   function openSale() public onlyOwner {
728     require(!isOnSale);
729 
730     isOnSale = true;
731   }
732 
733   function closeSale() public onlyOwner {
734     require(isOnSale);
735 
736     if (token.balanceOf(this) > 0) {
737       withdrawToken();
738     }
739 
740     isOnSale = false;
741   }
742 
743   function withdrawToken() public onlyOwner {
744     uint256 balanceOfThis = token.balanceOf(this);
745     token.transfer(wallet, balanceOfThis);
746     emit Withdraw(wallet, balanceOfThis);
747   }
748 
749   function distributeBonusTokens() public onlyOwner {
750     require(!isOnSale);
751 
752     for (uint i = 0; i < contributors.length; i++) {
753       if (bonusTokens[contributors[i]] > 0) {
754         token.transferFrom(wallet, contributors[i], bonusTokens[contributors[i]]);
755         bonusTokens[contributors[i]] = 0;
756       }
757     }
758 
759     emit DistrubuteBonusTokens(msg.sender);
760   }
761 
762   function getContributors() public view onlyOwner returns(address[]) {
763     return contributors;
764   }
765 
766   /// @dev get addresses who has bonus tokens
767   /// @return Returns array of addresses.
768   function getBonusList() public view onlyOwner returns(address[]) {
769     address[] memory contributorsTmp = new address[](contributors.length);
770     uint count = 0;
771     uint i;
772 
773     for (i = 0; i < contributors.length; i++) {
774       if (bonusTokens[contributors[i]] > 0) {
775         contributorsTmp[count] = contributors[i];
776         count += 1;
777       }
778     }
779     
780     address[] memory _bonusList = new address[](count);
781     for (i = 0; i < count; i++) {
782       _bonusList[i] = contributorsTmp[i];
783     }
784 
785     return _bonusList;
786   }
787 
788   /// @dev distribute bonus tokens to addresses who has bonus tokens
789   /// @param _bonusList array of addresses who has bonus tokens.
790   function distributeBonusTokensByList(address[] _bonusList) public onlyOwner {
791     require(!isOnSale);
792 
793     for (uint i = 0; i < _bonusList.length; i++) {
794       if (bonusTokens[_bonusList[i]] > 0) {
795         token.transferFrom(wallet, _bonusList[i], bonusTokens[_bonusList[i]]);
796         bonusTokens[_bonusList[i]] = 0;
797       }
798     }
799 
800     emit DistrubuteBonusTokens(msg.sender);
801   }
802 
803 }