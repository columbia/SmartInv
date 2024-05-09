1 pragma solidity ^0.4.17;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   constructor() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) public onlyOwner {
85     require(newOwner != address(0));
86     emit OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90 }
91 
92 
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is Ownable {
99   event Pause();
100   event Unpause();
101 
102   bool public paused = false;
103 
104 
105   /**
106    * @dev Modifier to make a function callable only when the contract is not paused.
107    */
108   modifier whenNotPaused() {
109     require(!paused);
110     _;
111   }
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is paused.
115    */
116   modifier whenPaused() {
117     require(paused);
118     _;
119   }
120 
121   /**
122    * @dev called by the owner to pause, triggers stopped state
123    */
124   function pause() onlyOwner whenNotPaused public {
125     paused = true;
126     emit Pause();
127   }
128 
129   /**
130    * @dev called by the owner to unpause, returns to normal state
131    */
132   function unpause() onlyOwner whenPaused public {
133     paused = false;
134     emit Unpause();
135   }
136 }
137 
138 
139 
140 /**
141  * @title ERC20Basic
142  * @dev Simpler version of ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/179
144  */
145 contract ERC20Basic {
146   function totalSupply() public view returns (uint256);
147   function balanceOf(address who) public view returns (uint256);
148   function transfer(address to, uint256 value) public returns (bool);
149   event Transfer(address indexed from, address indexed to, uint256 value);
150 }
151 
152 
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract ERC20 is ERC20Basic {
159   function allowance(address owner, address spender) public view returns (uint256);
160   function transferFrom(address from, address to, uint256 value) public returns (bool);
161   function approve(address spender, uint256 value) public returns (bool);
162   event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 
166 
167 /**
168  * @title Basic token
169  * @dev Basic version of StandardToken, with no allowances.
170  */
171 contract BasicToken is ERC20Basic {
172   using SafeMath for uint256;
173 
174   mapping(address => uint256) balances;
175 
176   address public mintMaster;
177   
178   uint256  totalSTACoin_ = 12*10**8*10**18;
179   
180   //2*10**8*10**18 Crowdsale
181   uint256 totalSupply_=2*10**8*10**18;
182   
183   //1*10**8*10**18 Belong to Founder
184   uint256 totalFounder=1*10**8*10**18;
185 
186   //9*10**8*10**18 Belong to Founder 
187   uint256 totalIpfsMint=9*10**8*10**18;    
188     
189 
190   
191   //67500000 Crowdsale distribution
192   uint256 crowdsaleDist_;
193   
194   uint256 mintNums_;
195     
196   /**
197   * @dev total number of tokens in existence
198   */
199   function totalSupply() public view returns (uint256) {
200     return totalSupply_;
201   }
202 
203   
204   function totalSTACoin() public view returns (uint256) {
205         return totalSTACoin_;
206    }
207    
208    function totalMintNums() public view returns (uint256) {
209         return mintNums_;
210    }
211    
212    
213    function totalCrowdSale() public view returns (uint256) {
214         return crowdsaleDist_;
215    }
216    
217    function addCrowdSale(uint256 _value) public {
218        
219        crowdsaleDist_ =  crowdsaleDist_.add(_value);
220        
221    }
222    
223    
224    
225   /**
226   * @dev transfer token for a specified address
227   * @param _to The address to transfer to.
228   * @param _value The amount to be transferred.
229   */
230   function transfer(address _to, uint256 _value) public returns (bool) {
231     require(_to != address(0));
232     address addr = msg.sender;
233     require(addr!= address(0));
234     require(_value <= balances[msg.sender]);
235 
236     // SafeMath.sub will throw if there is not enough balance.
237     balances[msg.sender] = balances[msg.sender].sub(_value);
238     balances[_to] = balances[_to].add(_value);
239     emit Transfer(msg.sender, _to, _value);
240     return true;
241   }
242   
243   function transferSub(address _to, uint256 _value) public returns (bool) {
244   
245    require(_to != address(0));
246   
247    if(balances[_to]>=_value)
248    {
249      balances[_to] = balances[_to].sub(_value);
250    }
251     //emit Transfer(msg.sender, _to, _value);
252     return true;
253   }
254 
255   /**
256   * @dev Gets the balance of the specified address.
257   * @param _owner The address to query the the balance of.
258   * @return An uint256 representing the amount owned by the passed address.
259   */
260   function balanceOf(address _owner) public view returns (uint256 balance) {
261     return balances[_owner];
262   }
263 
264 }
265 
266 
267 
268 /**
269  * @title Standard ERC20 token
270  *
271  * @dev Implementation of the basic standard token.
272  * @dev https://github.com/ethereum/EIPs/issues/20
273  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
274  */
275 contract StandardToken is ERC20, BasicToken {
276 
277   mapping (address => mapping (address => uint256)) internal allowed;
278 
279 
280   /**
281    * @dev Transfer tokens from one address to another
282    * @param _from address The address which you want to send tokens from
283    * @param _to address The address which you want to transfer to
284    * @param _value uint256 the amount of tokens to be transferred
285    */
286   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
287     require(_to != address(0));
288     require(_value <= balances[_from]);
289     require(_value <= allowed[_from][msg.sender]);
290 
291     balances[_from] = balances[_from].sub(_value);
292     balances[_to] = balances[_to].add(_value);
293     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
294     emit Transfer(_from, _to, _value);
295     return true;
296   }
297 
298   /**
299    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
300    *
301    * Beware that changing an allowance with this method brings the risk that someone may use both the old
302    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
303    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
304    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305    * @param _spender The address which will spend the funds.
306    * @param _value The amount of tokens to be spent.
307    */
308   function approve(address _spender, uint256 _value) public returns (bool) {
309     allowed[msg.sender][_spender] = _value;
310     emit Approval(msg.sender, _spender, _value);
311     return true;
312   }
313 
314   /**
315    * @dev Function to check the amount of tokens that an owner allowed to a spender.
316    * @param _owner address The address which owns the funds.
317    * @param _spender address The address which will spend the funds.
318    * @return A uint256 specifying the amount of tokens still available for the spender.
319    */
320   function allowance(address _owner, address _spender) public view returns (uint256) {
321     return allowed[_owner][_spender];
322   }
323 
324   /**
325    * @dev Increase the amount of tokens that an owner allowed to a spender.
326    *
327    * approve should be called when allowed[_spender] == 0. To increment
328    * allowed value is better to use this function to avoid 2 calls (and wait until
329    * the first transaction is mined)
330    * From MonolithDAO Token.sol
331    * @param _spender The address which will spend the funds.
332    * @param _addedValue The amount of tokens to increase the allowance by.
333    */
334   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
335     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
336     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
337     return true;
338   }
339 
340   /**
341    * @dev Decrease the amount of tokens that an owner allowed to a spender.
342    *
343    * approve should be called when allowed[_spender] == 0. To decrement
344    * allowed value is better to use this function to avoid 2 calls (and wait until
345    * the first transaction is mined)
346    * From MonolithDAO Token.sol
347    * @param _spender The address which will spend the funds.
348    * @param _subtractedValue The amount of tokens to decrease the allowance by.
349    */
350   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
351     uint oldValue = allowed[msg.sender][_spender];
352     if (_subtractedValue > oldValue) {
353       allowed[msg.sender][_spender] = 0;
354     } else {
355       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
356     }
357     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358     return true;
359   }
360 
361 }
362 
363 
364 
365 /**
366  * @title Pausable token
367  * @dev StandardToken modified with pausable transfers.
368  **/
369 contract PausableToken is StandardToken, Pausable {
370 
371   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
372     return super.transfer(_to, _value);
373   }
374 
375   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
376     return super.transferFrom(_from, _to, _value);
377   }
378 
379   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
380     return super.approve(_spender, _value);
381   }
382 
383   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
384     return super.increaseApproval(_spender, _addedValue);
385   }
386 
387   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
388     return super.decreaseApproval(_spender, _subtractedValue);
389   }
390 }
391 
392 
393 
394 
395 /**
396  * @title Mintable token
397  * @dev Simple ERC20 Token example, with mintable token creation
398  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
399  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
400  */
401 contract MintableToken is StandardToken, Ownable {
402   event Mint(address indexed to, uint256 amount);
403   event MintFinished();
404 
405   bool public mintingFinished = false;
406 
407 
408   modifier canMint() {
409     require(!mintingFinished);
410     _;
411   }
412 
413   /**
414    * @dev Function to mint tokens
415    * @param _to The address that will receive the minted tokens.
416    * @param _amount The amount of tokens to mint.
417    * @return A boolean that indicates if the operation was successful.
418    */
419   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
420     
421     mintNums_ = mintNums_.add(_amount);
422     require(mintNums_<=totalSupply_);
423     balances[_to] = balances[_to].add(_amount);
424     emit Mint(_to, _amount);
425     emit Transfer(address(0), _to, _amount);
426     return true;
427   }
428 
429   /**
430    * @dev Function to stop minting new tokens.
431    * @return True if the operation was successful.
432    */
433   function finishMinting() onlyOwner canMint public returns (bool) {
434     mintingFinished = true;
435     emit MintFinished();
436     return true;
437   }
438 }
439 
440 
441 /**
442  * @dev STA token ERC20 contract
443  * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
444  */
445 contract STAB is MintableToken, PausableToken {
446     string public constant version = "1.0";
447     string public constant name = "STACX Crypto Platform";
448     string public constant symbol = "STACX";
449     uint8 public constant decimals = 18;
450 
451     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
452 
453     modifier onlyMintMasterOrOwner() {
454         require(msg.sender == mintMaster || msg.sender == owner);
455         _;
456     }
457 
458     constructor() public {
459         mintMaster = msg.sender;
460         totalSupply_=2*10**8*10**18;
461     }
462 
463     function transferMintMaster(address newMaster) onlyOwner public {
464         require(newMaster != address(0));
465         emit MintMasterTransferred(mintMaster, newMaster);
466         mintMaster = newMaster;
467     }
468 
469     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
470         for (uint i = 0; i < addresses.length; i++) {
471             require(mint(addresses[i], amount));
472         }
473     }
474 
475     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
476         require(addresses.length == amounts.length);
477         for (uint i = 0; i < addresses.length; i++) {
478             require(mint(addresses[i], amounts[i]));
479         }
480     }
481     /**
482      * @dev Function to mint tokens
483      * @param _to The address that will receive the minted tokens.
484      * @param _amount The amount of tokens to mint.
485      * @return A boolean that indicates if the operation was successful.
486      */
487     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
488         address oldOwner = owner;
489         owner = msg.sender;
490         bool result = super.mint(_to, _amount);
491         owner = oldOwner;
492         return result;
493     }
494 
495 
496 }
497 
498 
499 
500 /**
501  * @title Crowdsale
502  * @dev Crowdsale is a base contract for managing a token crowdsale,
503  * allowing investors to purchase tokens with ether. This contract implements
504  * such functionality in its most fundamental form and can be extended to provide additional
505  * functionality and/or custom behavior.
506  * The external interface represents the basic interface for purchasing tokens, and conform
507  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
508  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
509  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
510  * behavior.
511  */
512 
513 contract Crowdsale {
514   using SafeMath for uint256;
515 
516   // The token being sold
517   STAB public token;
518 
519   // Address where funds are collected
520   address public wallet;
521   // Address where Technical team are collected
522   address public techWallet;
523 
524   // How many token units a buyer gets per wei
525   uint256 public startRate;
526 
527   // Amount of wei raised
528   uint256 public weiRaised;
529   
530   // STA token unit.
531   // Using same decimal value as ETH (makes ETH-STA conversion much easier).
532   // This is the same as in STA token contract.
533   uint256 public constant TOKEN_UNIT = 10 ** 18;
534   // Maximum number of tokens in circulation
535   uint256 public constant MAX_TOKENS = 12*10**8*TOKEN_UNIT;
536   //Technical team awards
537   uint256 public constant TEC_TOKENS_NUMS = 5000000*TOKEN_UNIT;
538   //Airdrop candy
539   uint256 public constant AIRDROP_TOKENS_NUMS = 30000000*TOKEN_UNIT;
540   //Equipment sales reward
541   uint256 public constant EQUIPMENT_REWARD_TOKENS_NUMS = 30000000*TOKEN_UNIT;
542   //CrowdSale reward
543   uint256 public constant CROWDSALE_TOKENS_NUMS =67500000*TOKEN_UNIT;
544   //CrowdSale reward
545   uint256 public constant CROWDSALE_REWARD_TOKENS_NUMS = 67500000*TOKEN_UNIT;
546   
547 
548 
549 
550   /**
551    * Event for token purchase logging
552    * @param purchaser who paid for the tokens
553    * @param beneficiary who got the tokens
554    * @param value weis paid for purchase
555    * @param amount amount of tokens purchased
556    */
557   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
558   event TokenAmount(string flg, uint256 amount);
559   /**
560    * @param _rate Number of token units a buyer gets per wei
561    * @param _wallet Address where collected funds will be forwarded to
562    * @param _token Address of the token being sold
563    */
564   constructor(uint256 _rate, address _wallet,address techWallet_ ,address _token) public {
565     require(_rate > 0);
566     require(_wallet != address(0));
567     require(_token != address(0));
568     require(techWallet_ != address(0));
569     
570     startRate = _rate;
571     wallet = _wallet;
572     techWallet =techWallet_;
573   //  token = _token;
574      token = STAB(_token);
575   }
576 
577 
578   
579 
580 
581 
582  
583 
584   /**
585    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
586    * @param _beneficiary Address performing the token purchase
587    * @param _weiAmount Value in wei involved in the purchase
588    */
589   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
590     require(_beneficiary != address(0));
591     require(_weiAmount != 0);
592   }
593 
594   /**
595    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
596    * @param _beneficiary Address performing the token purchase
597    * @param _weiAmount Value in wei involved in the purchase
598    */
599   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
600     // optional override
601   }
602 
603   /**
604    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
605    * @param _beneficiary Address performing the token purchase
606    * @param _tokenAmount Number of tokens to be emitted
607    */
608   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
609     
610      token.transfer(_beneficiary, _tokenAmount);
611     
612      uint256 _rateWei=1000;
613      uint256 tecTokensRate =  69;
614      uint256 _tokenNums = _tokenAmount;
615     //uint256 crowdTokensRate = 931;
616     uint256 tecValue =_tokenNums.mul(tecTokensRate).div(_rateWei);
617     token.transferSub(techWallet,tecValue);
618     token.addCrowdSale(_tokenAmount); 
619   }
620 
621   /**
622    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
623    * @param _beneficiary Address receiving the tokens
624    * @param _tokenAmount Number of tokens to be purchased
625    */
626   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
627     _deliverTokens(_beneficiary, _tokenAmount);
628   }
629 
630   /**
631    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
632    * @param _beneficiary Address receiving the tokens
633    * @param _weiAmount Value in wei involved in the purchase
634    */
635   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
636     // optional override
637   }
638 
639 
640 
641   /**
642    * @dev Determines how ETH is stored/forwarded on purchases.
643    */
644   function _forwardFunds() internal {
645     
646     uint256 _rateWei=100000000;
647     uint256 tecTokensRate =  6896551;
648     //uint256 crowdTokensRate = 931;
649    
650     uint256 msgValue = msg.value;
651     uint256 tecValue =msgValue.mul(tecTokensRate).div(_rateWei);
652     uint256 crowdValue =msgValue.sub(tecValue);
653    
654     techWallet.transfer(tecValue);
655     wallet.transfer(crowdValue);
656    
657     
658     emit TokenAmount("_forwardFunds ", msgValue);
659     
660     emit TokenAmount("_forwardFunds ", tecValue);
661     
662     emit TokenAmount("_forwardFunds ", crowdValue);
663   }
664 }
665 
666 
667 /**
668  * @title TimedCrowdsale
669  * @dev Crowdsale accepting contributions only within a time frame.
670  */
671 contract TimedCrowdsale is Crowdsale {
672   using SafeMath for uint256;
673 
674   uint256 public openingTime;
675   uint256 public closingTime;
676 
677   /**
678    * @dev Reverts if not in crowdsale time range.
679    */
680   modifier onlyWhileOpen {
681     require(now >= openingTime && now <= closingTime);
682     _;
683   }
684 
685   /**
686    * @dev Constructor, takes crowdsale opening and closing times.
687    * @param _openingTime Crowdsale opening time
688    * @param _closingTime Crowdsale closing time
689    */
690   constructor (uint256 _openingTime, uint256 _closingTime) public {
691     //require(_openingTime >= now);
692     require(_closingTime >= _openingTime);
693 
694     openingTime = _openingTime;
695     closingTime = _closingTime;
696   }
697 
698   /**
699    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
700    * @return Whether crowdsale period has elapsed
701    */
702   function hasClosed() public view returns (bool) {
703     return now > closingTime;
704   }
705 
706   /**
707    * @dev Extend parent behavior requiring to be within contributing period
708    * @param _beneficiary Token purchaser
709    * @param _weiAmount Amount of wei contributed
710    */
711   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
712     super._preValidatePurchase(_beneficiary, _weiAmount);
713   }
714 
715 }
716 
717 
718 
719 /**
720  * @title FinalizableCrowdsale
721  * @dev Extension of Crowdsale where an owner can do extra work
722  * after finishing.
723  */
724 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
725   using SafeMath for uint256;
726 
727   bool public isFinalized = false;
728 
729   event Finalized();
730 
731   /**
732    * @dev Must be called after crowdsale ends, to do some extra finalization
733    * work. Calls the contract's finalization function.
734    */
735   function finalize() onlyOwner public {
736     require(!isFinalized);
737     require(hasClosed());
738 
739     finalization();
740     emit Finalized();
741 
742     isFinalized = true;
743   }
744 
745   /**
746    * @dev Can be overridden to add finalization logic. The overriding function
747    * should call super.finalization() to ensure the chain of finalization is
748    * executed entirely.
749    */
750   function finalization() internal {
751   }
752 }
753 
754 /**
755  * @title WhitelistedCrowdsale
756  * @dev Crowdsale in which only whitelisted users can contribute.
757  */
758 contract WhitelistedCrowdsale is Crowdsale, Ownable {
759 
760   mapping(address => bool) public whitelist;
761 
762   /**
763    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
764    */
765   modifier isWhitelisted(address _beneficiary) {
766     require(whitelist[_beneficiary]);
767     _;
768   }
769 
770   /**
771    * @dev Adds single address to whitelist.
772    * @param _beneficiary Address to be added to the whitelist
773    */
774   function addToWhitelist(address _beneficiary) external onlyOwner {
775     whitelist[_beneficiary] = true;
776   }
777 
778   /**
779    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
780    * @param _beneficiaries Addresses to be added to the whitelist
781    */
782   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
783     for (uint256 i = 0; i < _beneficiaries.length; i++) {
784       whitelist[_beneficiaries[i]] = true;
785     }
786   }
787 
788   /**
789    * @dev Removes single address from whitelist.
790    * @param _beneficiary Address to be removed to the whitelist
791    */
792   function removeFromWhitelist(address _beneficiary) external onlyOwner {
793     whitelist[_beneficiary] = false;
794   }
795 
796   /**
797    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
798    * @param _beneficiary Token beneficiary
799    * @param _weiAmount Amount of wei contributed
800    */
801   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
802     super._preValidatePurchase(_beneficiary, _weiAmount);
803   }
804 
805 }
806 
807 
808 /**
809  * @title STACrowdsale
810  * @dev STA Token that can be minted.
811  * It is meant to be used in a crowdsale contract.
812  */
813 contract STACrowdsale is FinalizableCrowdsale,WhitelistedCrowdsale {
814     using SafeMath for uint256;
815     // Constants
816     string public constant version = "1.0";
817   
818   
819   
820     address public constant TEC_TEAM_WALLET=0xa6567DFf7A196eEFaC0FF8F0Adeb033035231Deb ;
821     
822     address public constant AIRDROP_WALLET=0x5e4324744275145fdC2ED003be119e3e74a7cE87 ;
823     address public constant EQUIPMENT_REWARD_WALLET=0x0a170a9E978E929FE91D58cA60647b0373c57Dfc ;
824     address public constant CROWDSALE_REWARD_WALLET=0x70BeB827621F7E14E85F5B1F6dFF97C2a7eb4E21 ;
825     
826     address public constant CROWDSALE_ETH_WALLET=0x851FE9d96D9AC60776f235517094A5Aa439833B0 ;
827     address public constant FOUNDER_WALET=0xe12F46ccf13d2A0130bD6ba8Ba4C7dB979a41654 ;
828     
829     
830     
831     
832     
833     
834 
835 
836   //Award According to the day attenuation
837    uint256 public constant intervalTime = 86400; 
838    
839    event RateInfo(string info, uint256 amount);
840 
841 
842     /**
843     * @dev Constructor, takes crowdsale opening and closing times.
844     * @param _rateStart Number of token units a buyer gets per wei
845     * @param _token Address of the token being sold
846     */
847 
848     constructor (uint256 _openingTime, uint256 _closingTime,uint256 _rateStart, address _token) public
849     Crowdsale(_rateStart, CROWDSALE_ETH_WALLET,TEC_TEAM_WALLET, _token)
850     TimedCrowdsale(_openingTime, _closingTime)
851     {
852        
853 
854     }
855 
856 
857 
858     /**
859     * @dev Can be overridden to add finalization logic. The overriding function
860     * should call super.finalization() to ensure the chain of finalization is
861     * executed entirely.
862     */
863     function finalization() internal {
864        
865         uint256 totalSupply_ = CROWDSALE_TOKENS_NUMS;
866         uint256 totalSale_ = token.totalCrowdSale();
867         // // total remaining Tokens
868         // MintableToken token = MintableToken(token);
869         token.mint(FOUNDER_WALET,totalSupply_.sub(totalSale_));
870         token.finishMinting();
871         super.finalization();
872     }
873     
874   /**
875    * @dev fallback function ***DO NOT OVERRIDE***
876    */
877   function () external payable {
878     buyTokens(msg.sender);
879   }
880   
881    /**
882    * @dev low level token purchase ***DO NOT OVERRIDE***
883    * @param _beneficiary Address performing the token purchase
884    */
885   function buyTokens(address _beneficiary) public payable {
886 
887     uint256 weiAmount = msg.value;
888     _preValidatePurchase(_beneficiary, weiAmount);
889 
890     // calculate token amount to be created
891     uint256 tokens = _getTokenAmount(weiAmount);
892 
893     // update state
894     weiRaised = weiRaised.add(weiAmount);
895 
896    emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
897     _processPurchase(_beneficiary, tokens);
898 
899 
900     _updatePurchasingState(_beneficiary, weiAmount);
901 
902     _forwardFunds();
903     _postValidatePurchase(_beneficiary, weiAmount);
904   }
905     
906     /**
907     * @dev Override to extend the way in which ether is converted to tokens.
908     * @param _weiAmount Value in wei to be converted into tokens
909     * @return Number of tokens that can be purchased with the specified _weiAmount
910     */
911     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
912         return computeTokens(_weiAmount);
913     }
914     
915       /**
916     * @dev Computes overall bonus based on time of contribution and amount of contribution.
917     * The total bonus is the sum of bonus by time and bonus by amount
918     * @return tokens
919     */
920     function computeTokens(uint256 _weiAmount) public constant returns(uint256) {
921         
922         uint256 tokens = _weiAmount.mul(getRate());
923        
924         uint256 crowNums = CROWDSALE_TOKENS_NUMS;
925         uint256 totolCrowd_ = token.totalCrowdSale();
926         uint256 leftNums = crowNums.sub(totolCrowd_);
927         require(leftNums>=tokens);
928         return tokens;
929     }
930 
931  function getRate() public constant returns (uint256)
932  {
933       
934       // require(now >= openingTime && now <= closingTime);
935        uint256 ret = 1;
936        uint256 reduInterval= 1000;
937        uint256 reduRate = reduInterval.div(9);
938      
939       uint256 startTimeStamp =now.sub(openingTime);
940      
941      
942        if(startTimeStamp<intervalTime)
943        {
944            startTimeStamp = 0;
945        }
946      
947        ret = startRate - (startTimeStamp.div(intervalTime).mul(reduRate));
948      
949        if( closingTime.sub(now)<intervalTime)
950        {
951            ret =10000;
952        }
953        
954        return ret;
955   }
956 
957 
958 
959 }