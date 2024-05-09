1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
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
64 
65 
66 
67 
68 
69 /**
70  * @title SafeERC20
71  * @dev Wrappers around ERC20 operations that throw on failure.
72  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
73  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
74  */
75 library SafeERC20 {
76   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
77     assert(token.transfer(to, value));
78   }
79 
80   function safeTransferFrom(
81     ERC20 token,
82     address from,
83     address to,
84     uint256 value
85   )
86     internal
87   {
88     assert(token.transferFrom(from, to, value));
89   }
90 
91   function safeApprove(ERC20 token, address spender, uint256 value) internal {
92     assert(token.approve(spender, value));
93   }
94 }
95 
96 
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109 
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   function Ownable() public {
115     owner = msg.sender;
116   }
117 
118   /**
119    * @dev Throws if called by any account other than the owner.
120    */
121   modifier onlyOwner() {
122     require(msg.sender == owner);
123     _;
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     require(newOwner != address(0));
132     emit OwnershipTransferred(owner, newOwner);
133     owner = newOwner;
134   }
135 
136 }
137 
138 
139 
140 
141 
142 
143 
144 
145 
146 
147 
148 
149 
150 
151 
152 /**
153  * @title Basic token
154  * @dev Basic version of StandardToken, with no allowances.
155  */
156 contract BasicToken is ERC20Basic {
157   using SafeMath for uint256;
158 
159   mapping(address => uint256) balances;
160 
161   uint256 totalSupply_;
162 
163   /**
164   * @dev total number of tokens in existence
165   */
166   function totalSupply() public view returns (uint256) {
167     return totalSupply_;
168   }
169 
170   /**
171   * @dev transfer token for a specified address
172   * @param _to The address to transfer to.
173   * @param _value The amount to be transferred.
174   */
175   function transfer(address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[msg.sender]);
178 
179     balances[msg.sender] = balances[msg.sender].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     emit Transfer(msg.sender, _to, _value);
182     return true;
183   }
184 
185   /**
186   * @dev Gets the balance of the specified address.
187   * @param _owner The address to query the the balance of.
188   * @return An uint256 representing the amount owned by the passed address.
189   */
190   function balanceOf(address _owner) public view returns (uint256) {
191     return balances[_owner];
192   }
193 
194 }
195 
196 
197 
198 /**
199  * @title ERC20 interface
200  * @dev see https://github.com/ethereum/EIPs/issues/20
201  */
202 contract ERC20 is ERC20Basic {
203   function allowance(address owner, address spender) public view returns (uint256);
204   function transferFrom(address from, address to, uint256 value) public returns (bool);
205   function approve(address spender, uint256 value) public returns (bool);
206   event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 
210 
211 
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * @dev https://github.com/ethereum/EIPs/issues/20
218  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is ERC20, BasicToken {
221 
222   mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232     require(_to != address(0));
233     require(_value <= balances[_from]);
234     require(_value <= allowed[_from][msg.sender]);
235 
236     balances[_from] = balances[_from].sub(_value);
237     balances[_to] = balances[_to].add(_value);
238     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239     emit Transfer(_from, _to, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245    *
246    * Beware that changing an allowance with this method brings the risk that someone may use both the old
247    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250    * @param _spender The address which will spend the funds.
251    * @param _value The amount of tokens to be spent.
252    */
253   function approve(address _spender, uint256 _value) public returns (bool) {
254     allowed[msg.sender][_spender] = _value;
255     emit Approval(msg.sender, _spender, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Function to check the amount of tokens that an owner allowed to a spender.
261    * @param _owner address The address which owns the funds.
262    * @param _spender address The address which will spend the funds.
263    * @return A uint256 specifying the amount of tokens still available for the spender.
264    */
265   function allowance(address _owner, address _spender) public view returns (uint256) {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
280     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To decrement
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _subtractedValue The amount of tokens to decrease the allowance by.
294    */
295   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 
309 
310 
311 /**
312  * @title Mintable token
313  * @dev Simple ERC20 Token example, with mintable token creation
314  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
315  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
316  */
317 contract MintableToken is StandardToken, Ownable {
318   event Mint(address indexed to, uint256 amount);
319   event MintFinished();
320 
321   bool public mintingFinished = false;
322 
323 
324   modifier canMint() {
325     require(!mintingFinished);
326     _;
327   }
328 
329   /**
330    * @dev Function to mint tokens
331    * @param _to The address that will receive the minted tokens.
332    * @param _amount The amount of tokens to mint.
333    * @return A boolean that indicates if the operation was successful.
334    */
335   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
336     totalSupply_ = totalSupply_.add(_amount);
337     balances[_to] = balances[_to].add(_amount);
338     emit Mint(_to, _amount);
339     emit Transfer(address(0), _to, _amount);
340     return true;
341   }
342 
343   /**
344    * @dev Function to stop minting new tokens.
345    * @return True if the operation was successful.
346    */
347   function finishMinting() onlyOwner canMint public returns (bool) {
348     mintingFinished = true;
349     emit MintFinished();
350     return true;
351   }
352 }
353 
354 
355 
356 
357 
358 
359 
360 
361 
362 
363 /**
364  * @title Pausable
365  * @dev Base contract which allows children to implement an emergency stop mechanism.
366  */
367 contract Pausable is Ownable {
368   event Pause();
369   event Unpause();
370 
371   bool public paused = false;
372 
373 
374   /**
375    * @dev Modifier to make a function callable only when the contract is not paused.
376    */
377   modifier whenNotPaused() {
378     require(!paused);
379     _;
380   }
381 
382   /**
383    * @dev Modifier to make a function callable only when the contract is paused.
384    */
385   modifier whenPaused() {
386     require(paused);
387     _;
388   }
389 
390   /**
391    * @dev called by the owner to pause, triggers stopped state
392    */
393   function pause() onlyOwner whenNotPaused public {
394     paused = true;
395     emit Pause();
396   }
397 
398   /**
399    * @dev called by the owner to unpause, returns to normal state
400    */
401   function unpause() onlyOwner whenPaused public {
402     paused = false;
403     emit Unpause();
404   }
405 }
406 
407 
408 
409 /**
410  * @title Pausable token
411  * @dev StandardToken modified with pausable transfers.
412  **/
413 contract PausableToken is StandardToken, Pausable {
414 
415   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
416     return super.transfer(_to, _value);
417   }
418 
419   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
420     return super.transferFrom(_from, _to, _value);
421   }
422 
423   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
424     return super.approve(_spender, _value);
425   }
426 
427   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
428     return super.increaseApproval(_spender, _addedValue);
429   }
430 
431   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
432     return super.decreaseApproval(_spender, _subtractedValue);
433   }
434 }
435 
436 
437 contract LittlePhilCoin is MintableToken, PausableToken {
438     string public name = "Little Phil Coin";
439     string public symbol = "LPC";
440     uint8 public decimals = 18;
441 
442     constructor () public {
443         // Pause token on creation and only unpause after ICO
444         pause();
445     }
446 
447 }
448 
449 
450 
451 
452 
453 
454 
455 
456 
457 
458 
459 /**
460  * @title Crowdsale
461  * @dev Crowdsale is a base contract for managing a token crowdsale,
462  * allowing investors to purchase tokens with ether. This contract implements
463  * such functionality in its most fundamental form and can be extended to provide additional
464  * functionality and/or custom behavior.
465  * The external interface represents the basic interface for purchasing tokens, and conform
466  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
467  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
468  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
469  * behavior.
470  */
471 contract Crowdsale {
472   using SafeMath for uint256;
473 
474   // The token being sold
475   ERC20 public token;
476 
477   // Address where funds are collected
478   address public wallet;
479 
480   // How many token units a buyer gets per wei
481   uint256 public rate;
482 
483   // Amount of wei raised
484   uint256 public weiRaised;
485 
486   /**
487    * Event for token purchase logging
488    * @param purchaser who paid for the tokens
489    * @param beneficiary who got the tokens
490    * @param value weis paid for purchase
491    * @param amount amount of tokens purchased
492    */
493   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
494 
495   /**
496    * @param _rate Number of token units a buyer gets per wei
497    * @param _wallet Address where collected funds will be forwarded to
498    * @param _token Address of the token being sold
499    */
500   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
501     require(_rate > 0);
502     require(_wallet != address(0));
503     require(_token != address(0));
504 
505     rate = _rate;
506     wallet = _wallet;
507     token = _token;
508   }
509 
510   // -----------------------------------------
511   // Crowdsale external interface
512   // -----------------------------------------
513 
514   /**
515    * @dev fallback function ***DO NOT OVERRIDE***
516    */
517   function () external payable {
518     buyTokens(msg.sender);
519   }
520 
521   /**
522    * @dev low level token purchase ***DO NOT OVERRIDE***
523    * @param _beneficiary Address performing the token purchase
524    */
525   function buyTokens(address _beneficiary) public payable {
526 
527     uint256 weiAmount = msg.value;
528     _preValidatePurchase(_beneficiary, weiAmount);
529 
530     // calculate token amount to be created
531     uint256 tokens = _getTokenAmount(weiAmount);
532 
533     // update state
534     weiRaised = weiRaised.add(weiAmount);
535 
536     _processPurchase(_beneficiary, tokens);
537     emit TokenPurchase(
538       msg.sender,
539       _beneficiary,
540       weiAmount,
541       tokens
542     );
543 
544     _updatePurchasingState(_beneficiary, weiAmount);
545 
546     _forwardFunds();
547     _postValidatePurchase(_beneficiary, weiAmount);
548   }
549 
550   // -----------------------------------------
551   // Internal interface (extensible)
552   // -----------------------------------------
553 
554   /**
555    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
556    * @param _beneficiary Address performing the token purchase
557    * @param _weiAmount Value in wei involved in the purchase
558    */
559   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
560     require(_beneficiary != address(0));
561     require(_weiAmount != 0);
562   }
563 
564   /**
565    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
566    * @param _beneficiary Address performing the token purchase
567    * @param _weiAmount Value in wei involved in the purchase
568    */
569   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
570     // optional override
571   }
572 
573   /**
574    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
575    * @param _beneficiary Address performing the token purchase
576    * @param _tokenAmount Number of tokens to be emitted
577    */
578   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
579     token.transfer(_beneficiary, _tokenAmount);
580   }
581 
582   /**
583    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
584    * @param _beneficiary Address receiving the tokens
585    * @param _tokenAmount Number of tokens to be purchased
586    */
587   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
588     _deliverTokens(_beneficiary, _tokenAmount);
589   }
590 
591   /**
592    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
593    * @param _beneficiary Address receiving the tokens
594    * @param _weiAmount Value in wei involved in the purchase
595    */
596   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
597     // optional override
598   }
599 
600   /**
601    * @dev Override to extend the way in which ether is converted to tokens.
602    * @param _weiAmount Value in wei to be converted into tokens
603    * @return Number of tokens that can be purchased with the specified _weiAmount
604    */
605   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
606     return _weiAmount.mul(rate);
607   }
608 
609   /**
610    * @dev Determines how ETH is stored/forwarded on purchases.
611    */
612   function _forwardFunds() internal {
613     wallet.transfer(msg.value);
614   }
615 }
616 
617 
618 
619 
620 
621 
622 /**
623  * @title TokenTimelock
624  * @dev TokenTimelock is a token holder contract that will allow a
625  * beneficiary to extract the tokens after a given release time
626  */
627 contract TokenTimelock {
628   using SafeERC20 for ERC20Basic;
629 
630   // ERC20 basic token contract being held
631   ERC20Basic public token;
632 
633   // beneficiary of tokens after they are released
634   address public beneficiary;
635 
636   // timestamp when token release is enabled
637   uint256 public releaseTime;
638 
639   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
640     // solium-disable-next-line security/no-block-members
641     require(_releaseTime > block.timestamp);
642     token = _token;
643     beneficiary = _beneficiary;
644     releaseTime = _releaseTime;
645   }
646 
647   /**
648    * @notice Transfers tokens held by timelock to beneficiary.
649    */
650   function release() public {
651     // solium-disable-next-line security/no-block-members
652     require(block.timestamp >= releaseTime);
653 
654     uint256 amount = token.balanceOf(this);
655     require(amount > 0);
656 
657     token.safeTransfer(beneficiary, amount);
658   }
659 }
660 
661 
662 
663 contract InitialSupplyCrowdsale is Crowdsale, Ownable {
664 
665     using SafeMath for uint256;
666 
667     uint256 public constant decimals = 18;
668 
669     // Wallet properties
670     address public companyWallet;
671     address public teamWallet;
672     address public projectWallet;
673     address public advisorWallet;
674     address public bountyWallet;
675     address public airdropWallet;
676 
677     // Team locked tokens
678     TokenTimelock public teamTimeLock1;
679     TokenTimelock public teamTimeLock2;
680 
681     // Reserved tokens
682     uint256 public constant companyTokens    = SafeMath.mul(150000000, (10 ** decimals));
683     uint256 public constant teamTokens       = SafeMath.mul(150000000, (10 ** decimals));
684     uint256 public constant projectTokens    = SafeMath.mul(150000000, (10 ** decimals));
685     uint256 public constant advisorTokens    = SafeMath.mul(100000000, (10 ** decimals));
686     uint256 public constant bountyTokens     = SafeMath.mul(30000000, (10 ** decimals));
687     uint256 public constant airdropTokens    = SafeMath.mul(20000000, (10 ** decimals));
688 
689     bool private isInitialised = false;
690 
691     constructor(
692         address[6] _wallets
693     ) public {
694         address _companyWallet  = _wallets[0];
695         address _teamWallet     = _wallets[1];
696         address _projectWallet  = _wallets[2];
697         address _advisorWallet  = _wallets[3];
698         address _bountyWallet   = _wallets[4];
699         address _airdropWallet  = _wallets[5];
700 
701         require(_companyWallet != address(0));
702         require(_teamWallet != address(0));
703         require(_projectWallet != address(0));
704         require(_advisorWallet != address(0));
705         require(_bountyWallet != address(0));
706         require(_airdropWallet != address(0));
707 
708         // Set reserved wallets
709         companyWallet = _companyWallet;
710         teamWallet = _teamWallet;
711         projectWallet = _projectWallet;
712         advisorWallet = _advisorWallet;
713         bountyWallet = _bountyWallet;
714         airdropWallet = _airdropWallet;
715 
716         // Lock team tokens in wallet over time periods
717         teamTimeLock1 = new TokenTimelock(token, teamWallet, uint64(now + 182 days));
718         teamTimeLock2 = new TokenTimelock(token, teamWallet, uint64(now + 365 days));
719     }
720 
721     /**
722      * Function: Distribute initial token supply
723      */
724     function setupInitialSupply() internal onlyOwner {
725         require(isInitialised == false);
726         uint256 teamTokensSplit = teamTokens.mul(50).div(100);
727 
728         // Distribute tokens to reserved wallets
729         LittlePhilCoin(token).mint(companyWallet, companyTokens);
730         LittlePhilCoin(token).mint(projectWallet, projectTokens);
731         LittlePhilCoin(token).mint(advisorWallet, advisorTokens);
732         LittlePhilCoin(token).mint(bountyWallet, bountyTokens);
733         LittlePhilCoin(token).mint(airdropWallet, airdropTokens);
734         LittlePhilCoin(token).mint(address(teamTimeLock1), teamTokensSplit);
735         LittlePhilCoin(token).mint(address(teamTimeLock2), teamTokensSplit);
736 
737         isInitialised = true;
738     }
739 
740 }
741 
742 
743 
744 
745 
746 
747 /**
748  * @title WhitelistedCrowdsale
749  * @dev Crowdsale in which only whitelisted users can contribute.
750  */
751 contract WhitelistedCrowdsale is Crowdsale, Ownable {
752 
753   mapping(address => bool) public whitelist;
754 
755   /**
756    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
757    */
758   modifier isWhitelisted(address _beneficiary) {
759     require(whitelist[_beneficiary]);
760     _;
761   }
762 
763   /**
764    * @dev Adds single address to whitelist.
765    * @param _beneficiary Address to be added to the whitelist
766    */
767   function addToWhitelist(address _beneficiary) external onlyOwner {
768     whitelist[_beneficiary] = true;
769   }
770 
771   /**
772    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
773    * @param _beneficiaries Addresses to be added to the whitelist
774    */
775   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
776     for (uint256 i = 0; i < _beneficiaries.length; i++) {
777       whitelist[_beneficiaries[i]] = true;
778     }
779   }
780 
781   /**
782    * @dev Removes single address from whitelist.
783    * @param _beneficiary Address to be removed to the whitelist
784    */
785   function removeFromWhitelist(address _beneficiary) external onlyOwner {
786     whitelist[_beneficiary] = false;
787   }
788 
789   /**
790    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
791    * @param _beneficiary Token beneficiary
792    * @param _weiAmount Amount of wei contributed
793    */
794   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
795     super._preValidatePurchase(_beneficiary, _weiAmount);
796   }
797 
798 }
799 
800 
801 
802 
803 
804 
805 
806 /**
807  * @title MintedCrowdsale
808  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
809  * Token ownership should be transferred to MintedCrowdsale for minting.
810  */
811 contract MintedCrowdsale is Crowdsale {
812 
813   /**
814    * @dev Overrides delivery by minting tokens upon purchase.
815    * @param _beneficiary Token purchaser
816    * @param _tokenAmount Number of tokens to be minted
817    */
818   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
819     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
820   }
821 }
822 
823 
824 
825 
826 
827 
828 
829 
830 
831 
832 
833 
834 /**
835  * @title CappedCrowdsale
836  * @dev Crowdsale with a limit for total contributions.
837  */
838 contract CappedCrowdsale is Crowdsale {
839   using SafeMath for uint256;
840 
841   uint256 public cap;
842 
843   /**
844    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
845    * @param _cap Max amount of wei to be contributed
846    */
847   function CappedCrowdsale(uint256 _cap) public {
848     require(_cap > 0);
849     cap = _cap;
850   }
851 
852   /**
853    * @dev Checks whether the cap has been reached.
854    * @return Whether the cap was reached
855    */
856   function capReached() public view returns (bool) {
857     return weiRaised >= cap;
858   }
859 
860   /**
861    * @dev Extend parent behavior requiring purchase to respect the funding cap.
862    * @param _beneficiary Token purchaser
863    * @param _weiAmount Amount of wei contributed
864    */
865   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
866     super._preValidatePurchase(_beneficiary, _weiAmount);
867     require(weiRaised.add(_weiAmount) <= cap);
868   }
869 
870 }
871 
872 
873 
874 /**
875  * @title TokenCappedCrowdsale
876  * @dev Crowdsale with a limit for total minted tokens.
877  */
878 contract TokenCappedCrowdsale is Crowdsale {
879     using SafeMath for uint256;
880 
881     uint256 public tokenCap = 0;
882 
883     // Amount of LPC raised
884     uint256 public tokensRaised = 0;
885 
886     // event for manual refund of cap overflow
887     event CapOverflow(address indexed sender, uint256 weiAmount, uint256 receivedTokens, uint256 date);
888 
889     /**
890      * Checks whether the tokenCap has been reached.
891      * @return Whether the tokenCap was reached
892      */
893     function capReached() public view returns (bool) {
894         return tokensRaised >= tokenCap;
895     }
896 
897     /**
898      * Accumulate the purchased tokens to the total raised
899      */
900     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
901         require(_beneficiary != address(0));
902         super._updatePurchasingState(_beneficiary, _weiAmount);
903         uint256 purchasedTokens = _getTokenAmount(_weiAmount);
904         tokensRaised = tokensRaised.add(purchasedTokens);
905 
906         if(capReached()) {
907             // manual process unused eth amount to sender
908             emit CapOverflow(_beneficiary, _weiAmount, purchasedTokens, now);
909         }
910     }
911 
912 }
913 
914 
915 
916 
917 /**
918  * @title TieredCrowdsale
919  * @dev Extension of Crowdsale contract that decreases the number of LPC tokens purchases dependent on the current number of tokens sold.
920  */
921 contract TieredCrowdsale is TokenCappedCrowdsale, Ownable {
922 
923     using SafeMath for uint256;
924 
925     /**
926     SalesState enum for use in state machine to manage sales rates
927     */
928     enum SaleState {
929         Initial,              // All contract initialization calls
930         PrivateSale,          // Private sale for industy and closed group investors
931         FinalisedPrivateSale, // Close private sale
932         PreSale,              // Pre sale ICO (40% bonus LPC hard-capped at 180 million tokens)
933         FinalisedPreSale,     // Close presale
934         PublicSaleTier1,      // Tier 1 ICO public sale (30% bonus LPC capped at 85 million tokens)
935         PublicSaleTier2,      // Tier 2 ICO public sale (20% bonus LPC capped at 65 million tokens)
936         PublicSaleTier3,      // Tier 3 ICO public sale (10% bonus LPC capped at 45 million tokens)
937         PublicSaleTier4,      // Tier 4 ICO public sale (standard rate capped at 25 million tokens)
938         FinalisedPublicSale,  // Close public sale
939         Closed                // ICO has finished, all tokens must have been claimed
940     }
941     SaleState public state = SaleState.Initial;
942 
943     struct TierConfig {
944         string stateName;
945         uint256 tierRatePercentage;
946         uint256 hardCap;
947     }
948 
949     mapping(bytes32 => TierConfig) private tierConfigs;
950 
951     // event for manual refund of cap overflow
952     event IncrementTieredState(string stateName);
953 
954     /**
955     * checks the state when validating a purchase
956     */
957     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
958         require(_beneficiary != address(0));
959         super._preValidatePurchase(_beneficiary, _weiAmount);
960         require(
961             state == SaleState.PrivateSale ||
962             state == SaleState.PreSale ||
963             state == SaleState.PublicSaleTier1 ||
964             state == SaleState.PublicSaleTier2 ||
965             state == SaleState.PublicSaleTier3 ||
966             state == SaleState.PublicSaleTier4
967         );
968     }
969 
970     /**
971     * @dev Constructor
972     * Caveat emptor: this base contract is intended for inheritance by the Little Phil crowdsale only
973     */
974     constructor() public {
975         // setup the map of bonus-rates for each SaleState tier
976         createSalesTierConfigMap();
977     }
978 
979     /**
980     * @dev Overrides parent method taking into account variable rate (as a percentage).
981     * @param _weiAmount The value in wei to be converted into tokens
982     * @return The number of tokens _weiAmount wei will buy at present time.
983     */
984     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
985         uint256 currentTierRate = getCurrentTierRatePercentage();
986 
987         uint256 requestedTokenAmount = _weiAmount.mul(rate).mul(currentTierRate).div(100);
988 
989         uint256 remainingTokens = tokenCap.sub(tokensRaised);
990 
991         // return number of LPC to provide
992         if(requestedTokenAmount > remainingTokens ) {
993             return remainingTokens;
994         }
995 
996         return requestedTokenAmount;
997     }
998 
999     /**
1000     * @dev setup the map of bonus-rates (as a percentage) and total hardCap for each SaleState tier
1001     * to be called by the constructor.
1002     */
1003     function createSalesTierConfigMap() private {
1004 
1005         tierConfigs [keccak256(SaleState.Initial)] = TierConfig({
1006             stateName: "Initial",
1007             tierRatePercentage:0,
1008             hardCap: 0
1009         });
1010         tierConfigs [keccak256(SaleState.PrivateSale)] = TierConfig({
1011             stateName: "PrivateSale",
1012             tierRatePercentage:100,
1013             hardCap: SafeMath.mul(400000000, (10 ** 18))
1014         });
1015         tierConfigs [keccak256(SaleState.FinalisedPrivateSale)] = TierConfig({
1016             stateName: "FinalisedPrivateSale",
1017             tierRatePercentage:0,
1018             hardCap: 0
1019         });
1020         tierConfigs [keccak256(SaleState.PreSale)] = TierConfig({
1021             stateName: "PreSale",
1022             tierRatePercentage:140,
1023             hardCap: SafeMath.mul(180000000, (10 ** 18))
1024         });
1025         tierConfigs [keccak256(SaleState.FinalisedPreSale)] = TierConfig({
1026             stateName: "FinalisedPreSale",
1027             tierRatePercentage:0,
1028             hardCap: 0
1029         });
1030         tierConfigs [keccak256(SaleState.PublicSaleTier1)] = TierConfig({
1031             stateName: "PublicSaleTier1",
1032             tierRatePercentage:130,
1033             hardCap: SafeMath.mul(265000000, (10 ** 18))
1034         });
1035         tierConfigs [keccak256(SaleState.PublicSaleTier2)] = TierConfig({
1036             stateName: "PublicSaleTier2",
1037             tierRatePercentage:120,
1038             hardCap: SafeMath.mul(330000000, (10 ** 18))
1039         });
1040         tierConfigs [keccak256(SaleState.PublicSaleTier3)] = TierConfig({
1041             stateName: "PublicSaleTier3",
1042             tierRatePercentage:110,
1043             hardCap: SafeMath.mul(375000000, (10 ** 18))
1044         });
1045         tierConfigs [keccak256(SaleState.PublicSaleTier4)] = TierConfig({
1046             stateName: "PublicSaleTier4",
1047             tierRatePercentage:100,
1048             hardCap: SafeMath.mul(400000000, (10 ** 18))
1049         });
1050         tierConfigs [keccak256(SaleState.FinalisedPublicSale)] = TierConfig({
1051             stateName: "FinalisedPublicSale",
1052             tierRatePercentage:0,
1053             hardCap: 0
1054         });
1055         tierConfigs [keccak256(SaleState.Closed)] = TierConfig({
1056             stateName: "Closed",
1057             tierRatePercentage:0,
1058             hardCap: SafeMath.mul(400000000, (10 ** 18))
1059         });
1060 
1061     }
1062 
1063     /**
1064     * @dev get the current bonus-rate for the current SaleState
1065     * @return the current rate as a percentage (e.g. 140 = 140% bonus)
1066     */
1067     function getCurrentTierRatePercentage() public view returns (uint256) {
1068         return tierConfigs[keccak256(state)].tierRatePercentage;
1069     }
1070 
1071     /**
1072     * @dev get the current hardCap for the current SaleState
1073     * @return the current hardCap
1074     */
1075     function getCurrentTierHardcap() public view returns (uint256) {
1076         return tierConfigs[keccak256(state)].hardCap;
1077     }
1078 
1079     /**
1080     * @dev only allow the owner to modify the current SaleState
1081     */
1082     function setState(uint256 _state) onlyOwner public {
1083         state = SaleState(_state);
1084 
1085         // update cap when state changes
1086         tokenCap = getCurrentTierHardcap();
1087 
1088         if(state == SaleState.Closed) {
1089             crowdsaleClosed();
1090         }
1091     }
1092 
1093     function getState() public view returns (string) {
1094         return tierConfigs[keccak256(state)].stateName;
1095     }
1096 
1097     /**
1098     * @dev only allow onwer to modify the current SaleState
1099     */
1100     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
1101         require(_beneficiary != address(0));
1102         super._updatePurchasingState(_beneficiary, _weiAmount);
1103 
1104         if(capReached()) {
1105             if(state == SaleState.PrivateSale) {
1106                 state = SaleState.FinalisedPrivateSale;
1107                 tokenCap = getCurrentTierHardcap();
1108                 emit IncrementTieredState(getState());
1109             }
1110             else if(state == SaleState.PreSale) {
1111                 state = SaleState.FinalisedPreSale;
1112                 tokenCap = getCurrentTierHardcap();
1113                 emit IncrementTieredState(getState());
1114             }
1115             else if(state == SaleState.PublicSaleTier1) {
1116                 state = SaleState.PublicSaleTier2;
1117                 tokenCap = getCurrentTierHardcap();
1118                 emit IncrementTieredState(getState());
1119             }
1120             else if(state == SaleState.PublicSaleTier2) {
1121                 state = SaleState.PublicSaleTier3;
1122                 tokenCap = getCurrentTierHardcap();
1123                 emit IncrementTieredState(getState());
1124             }
1125             else if(state == SaleState.PublicSaleTier3) {
1126                 state = SaleState.PublicSaleTier4;
1127                 tokenCap = getCurrentTierHardcap();
1128                 emit IncrementTieredState(getState());
1129             }
1130             else if(state == SaleState.PublicSaleTier4) {
1131                 state = SaleState.FinalisedPublicSale;
1132                 tokenCap = getCurrentTierHardcap();
1133                 emit IncrementTieredState(getState());
1134             }
1135 
1136         }
1137 
1138     }
1139 
1140     /**
1141      * Override for extensions that require an internal notification when the crowdsale has closed
1142      */
1143     function crowdsaleClosed () internal {
1144         // optional override
1145     }
1146 
1147 }
1148 
1149 
1150 
1151 
1152 
1153 /* solium-disable security/no-block-members */
1154 
1155 
1156 
1157 
1158 
1159 
1160 
1161 
1162 
1163 /**
1164  * @title TokenVesting
1165  * @dev A token holder contract that can release its token balance gradually like a
1166  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
1167  * owner.
1168  */
1169 contract TokenVesting is Ownable {
1170   using SafeMath for uint256;
1171   using SafeERC20 for ERC20Basic;
1172 
1173   event Released(uint256 amount);
1174   event Revoked();
1175 
1176   // beneficiary of tokens after they are released
1177   address public beneficiary;
1178 
1179   uint256 public cliff;
1180   uint256 public start;
1181   uint256 public duration;
1182 
1183   bool public revocable;
1184 
1185   mapping (address => uint256) public released;
1186   mapping (address => bool) public revoked;
1187 
1188   /**
1189    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
1190    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
1191    * of the balance will have vested.
1192    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
1193    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
1194    * @param _duration duration in seconds of the period in which the tokens will vest
1195    * @param _revocable whether the vesting is revocable or not
1196    */
1197   function TokenVesting(
1198     address _beneficiary,
1199     uint256 _start,
1200     uint256 _cliff,
1201     uint256 _duration,
1202     bool _revocable
1203   )
1204     public
1205   {
1206     require(_beneficiary != address(0));
1207     require(_cliff <= _duration);
1208 
1209     beneficiary = _beneficiary;
1210     revocable = _revocable;
1211     duration = _duration;
1212     cliff = _start.add(_cliff);
1213     start = _start;
1214   }
1215 
1216   /**
1217    * @notice Transfers vested tokens to beneficiary.
1218    * @param token ERC20 token which is being vested
1219    */
1220   function release(ERC20Basic token) public {
1221     uint256 unreleased = releasableAmount(token);
1222 
1223     require(unreleased > 0);
1224 
1225     released[token] = released[token].add(unreleased);
1226 
1227     token.safeTransfer(beneficiary, unreleased);
1228 
1229     emit Released(unreleased);
1230   }
1231 
1232   /**
1233    * @notice Allows the owner to revoke the vesting. Tokens already vested
1234    * remain in the contract, the rest are returned to the owner.
1235    * @param token ERC20 token which is being vested
1236    */
1237   function revoke(ERC20Basic token) public onlyOwner {
1238     require(revocable);
1239     require(!revoked[token]);
1240 
1241     uint256 balance = token.balanceOf(this);
1242 
1243     uint256 unreleased = releasableAmount(token);
1244     uint256 refund = balance.sub(unreleased);
1245 
1246     revoked[token] = true;
1247 
1248     token.safeTransfer(owner, refund);
1249 
1250     emit Revoked();
1251   }
1252 
1253   /**
1254    * @dev Calculates the amount that has already vested but hasn't been released yet.
1255    * @param token ERC20 token which is being vested
1256    */
1257   function releasableAmount(ERC20Basic token) public view returns (uint256) {
1258     return vestedAmount(token).sub(released[token]);
1259   }
1260 
1261   /**
1262    * @dev Calculates the amount that has already vested.
1263    * @param token ERC20 token which is being vested
1264    */
1265   function vestedAmount(ERC20Basic token) public view returns (uint256) {
1266     uint256 currentBalance = token.balanceOf(this);
1267     uint256 totalBalance = currentBalance.add(released[token]);
1268 
1269     if (block.timestamp < cliff) {
1270       return 0;
1271     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
1272       return totalBalance;
1273     } else {
1274       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
1275     }
1276   }
1277 }
1278 
1279 
1280 
1281 contract TokenVestingCrowdsale is Crowdsale, Ownable {
1282 
1283     function addBeneficiaryVestor(
1284             address beneficiaryWallet,
1285             uint256 tokenAmount,
1286             uint256 vestingEpocStart,
1287             uint256 cliffInSeconds,
1288             uint256 vestingEpocEnd
1289         ) external onlyOwner {
1290         TokenVesting newVault = new TokenVesting(
1291             beneficiaryWallet,
1292             vestingEpocStart,
1293             cliffInSeconds,
1294             vestingEpocEnd,
1295             false
1296         );
1297         LittlePhilCoin(token).mint(address(newVault), tokenAmount);
1298     }
1299 
1300     function releaseVestingTokens(address vaultAddress) external onlyOwner {
1301         TokenVesting(vaultAddress).release(token);
1302     }
1303 
1304 }
1305 
1306 contract LittlePhilCrowdsale is MintedCrowdsale, TieredCrowdsale, InitialSupplyCrowdsale, WhitelistedCrowdsale, TokenVestingCrowdsale {
1307 
1308     /**
1309     * Event for rate-change logging
1310     * @param rate the new ETH-to_LPC exchange rate
1311     */
1312     event NewRate(uint256 rate);
1313 
1314     // Constructor
1315     constructor(
1316         uint256 _rate,
1317         address _fundsWallet,
1318         address[6] _wallets,
1319         LittlePhilCoin _token
1320     ) public
1321     Crowdsale(_rate, _fundsWallet, _token)
1322     InitialSupplyCrowdsale(_wallets) {}
1323 
1324     // Sets up the initial balances
1325     // This must be called after ownership of the token is transferred to the crowdsale
1326     function setupInitialState() external onlyOwner {
1327         setupInitialSupply();
1328     }
1329 
1330     // Ownership management
1331     function transferTokenOwnership(address _newOwner) external onlyOwner {
1332         require(_newOwner != address(0));
1333         // I assume the crowdsale contract holds a reference to the token contract.
1334         LittlePhilCoin(token).transferOwnership(_newOwner);
1335     }
1336 
1337     // Called at the end of the crowdsale when it is eneded
1338     function crowdsaleClosed () internal {
1339         uint256 remainingTokens = tokenCap.sub(tokensRaised);
1340         _deliverTokens(airdropWallet, remainingTokens);
1341         LittlePhilCoin(token).finishMinting();
1342     }
1343 
1344     /**
1345     * checks the state when validating a purchase
1346     */
1347     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1348         require(_beneficiary != address(0));
1349         super._preValidatePurchase(_beneficiary, _weiAmount);
1350         require(_weiAmount >= 500000000000000000);
1351     }
1352 
1353     /**
1354      * @dev sets (updates) the ETH-to-LPC exchange rate
1355      * @param _rate ate that will applied to ETH to derive how many LPC to mint
1356      * does not affect, nor influenced by the bonus rates based on the current tier.
1357      */
1358     function setRate(int _rate) public onlyOwner {
1359         require(_rate > 0);
1360         rate = uint256(_rate);
1361         emit NewRate(rate);
1362     }
1363 
1364      /**
1365       * @dev allows for minting from owner account
1366       */
1367     function mintForPrivateFiat(address _beneficiary, uint256 _weiAmount) public onlyOwner {
1368         require(_beneficiary != address(0));
1369         // require(_weiAmount > 0);
1370         _preValidatePurchase(_beneficiary, _weiAmount);
1371 
1372         // calculate token amount to be created
1373         uint256 tokens = _getTokenAmount(_weiAmount);
1374 
1375         // update state
1376         weiRaised = weiRaised.add(_weiAmount);
1377         tokensRaised = tokensRaised.add(tokens);
1378 
1379         if(capReached()) {
1380             // manual process unused eth amount to sender
1381             emit CapOverflow(_beneficiary, _weiAmount, tokens, now);
1382             emit IncrementTieredState(getState());
1383         }
1384 
1385         _processPurchase(_beneficiary, tokens);
1386         emit TokenPurchase(
1387             msg.sender,
1388             _beneficiary,
1389             _weiAmount,
1390             tokens
1391         );
1392 
1393         _updatePurchasingState(_beneficiary, _weiAmount);
1394 
1395         _forwardFunds();
1396     }
1397 
1398 }