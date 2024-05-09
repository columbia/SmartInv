1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply_ = totalSupply_.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
310 
311 /**
312  * @title Capped token
313  * @dev Mintable token with a token cap.
314  */
315 contract CappedToken is MintableToken {
316 
317   uint256 public cap;
318 
319   function CappedToken(uint256 _cap) public {
320     require(_cap > 0);
321     cap = _cap;
322   }
323 
324   /**
325    * @dev Function to mint tokens
326    * @param _to The address that will receive the minted tokens.
327    * @param _amount The amount of tokens to mint.
328    * @return A boolean that indicates if the operation was successful.
329    */
330   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
331     require(totalSupply_.add(_amount) <= cap);
332 
333     return super.mint(_to, _amount);
334   }
335 
336 }
337 
338 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
339 
340 /**
341  * @title Pausable
342  * @dev Base contract which allows children to implement an emergency stop mechanism.
343  */
344 contract Pausable is Ownable {
345   event Pause();
346   event Unpause();
347 
348   bool public paused = false;
349 
350 
351   /**
352    * @dev Modifier to make a function callable only when the contract is not paused.
353    */
354   modifier whenNotPaused() {
355     require(!paused);
356     _;
357   }
358 
359   /**
360    * @dev Modifier to make a function callable only when the contract is paused.
361    */
362   modifier whenPaused() {
363     require(paused);
364     _;
365   }
366 
367   /**
368    * @dev called by the owner to pause, triggers stopped state
369    */
370   function pause() onlyOwner whenNotPaused public {
371     paused = true;
372     Pause();
373   }
374 
375   /**
376    * @dev called by the owner to unpause, returns to normal state
377    */
378   function unpause() onlyOwner whenPaused public {
379     paused = false;
380     Unpause();
381   }
382 }
383 
384 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
385 
386 /**
387  * @title Pausable token
388  * @dev StandardToken modified with pausable transfers.
389  **/
390 contract PausableToken is StandardToken, Pausable {
391 
392   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
393     return super.transfer(_to, _value);
394   }
395 
396   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
397     return super.transferFrom(_from, _to, _value);
398   }
399 
400   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
401     return super.approve(_spender, _value);
402   }
403 
404   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
405     return super.increaseApproval(_spender, _addedValue);
406   }
407 
408   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
409     return super.decreaseApproval(_spender, _subtractedValue);
410   }
411 }
412 
413 // File: contracts/MeshToken.sol
414 
415 /**
416  * CappedToken token is Mintable token with a max cap on totalSupply that can ever be minted.
417  * PausableToken overrides all transfers methods and adds a modifier to check if paused is set to false.
418  */
419 contract MeshToken is CappedToken, PausableToken {
420   string public name = "Pluto Token";
421   string public symbol = "PLUTO";
422   uint256 public decimals = 18;
423   uint256 public cap = 129498559 ether;
424 
425   /**
426    * @dev variable to keep track of what addresses are allowed to call transfer functions when token is paused.
427    */
428   mapping (address => bool) public allowedTransfers;
429 
430   /*------------------------------------constructor------------------------------------*/
431   /**
432    * @dev constructor for mesh token
433    */
434   function MeshToken() CappedToken(cap) public {
435     paused = true;
436   }
437 
438   /*------------------------------------overridden methods------------------------------------*/
439   /**
440    * @dev Overridder modifier to allow exceptions for pausing for a given address
441    * This modifier is added to all transfer methods by PausableToken and only allows if paused is set to false.
442    * With this override the function allows either if paused is set to false or msg.sender is allowedTransfers during the pause as well.
443    */
444   modifier whenNotPaused() {
445     require(!paused || allowedTransfers[msg.sender]);
446     _;
447   }
448 
449   /**
450    * @dev overriding Pausable#pause method to do nothing
451    * Paused is set to true in the constructor itself, making the token non-transferrable on deploy.
452    * once unpaused the contract cannot be paused again.
453    * adding this to limit owner's ability to pause the token in future.
454    */
455   function pause() onlyOwner whenNotPaused public {}
456 
457   /**
458    * @dev modifier created to prevent short address attack problems.
459    * solution based on this blog post https://blog.coinfabrik.com/smart-contract-short-address-attack-mitigation-failure
460    */
461   modifier onlyPayloadSize(uint size) {
462     assert(msg.data.length >= size + 4);
463     _;
464   }
465 
466   /**
467    * @dev overriding transfer method to include the onlyPayloadSize check modifier
468    */
469   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
470     return super.transfer(_to, _value);
471   }
472 
473   /**
474    * @dev overriding transferFrom method to include the onlyPayloadSize check modifier
475    */
476   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
477     return super.transferFrom(_from, _to, _value);
478   }
479 
480   /**
481    * @dev overriding approve method to include the onlyPayloadSize check modifier
482    */
483   function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
484     return super.approve(_spender, _value);
485   }
486 
487   /**
488    * @dev overriding increaseApproval method to include the onlyPayloadSize check modifier
489    */
490   function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2 * 32) public returns (bool) {
491     return super.increaseApproval(_spender, _addedValue);
492   }
493 
494   /**
495    * @dev overriding decreaseApproval method to include the onlyPayloadSize check modifier
496    */
497   function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2 * 32) public returns (bool) {
498     return super.decreaseApproval(_spender, _subtractedValue);
499   }
500 
501   /**
502    * @dev overriding mint method to include the onlyPayloadSize check modifier
503    */
504   function mint(address _to, uint256 _amount) onlyOwner canMint onlyPayloadSize(2 * 32) public returns (bool) {
505     return super.mint(_to, _amount);
506   }
507 
508   /*------------------------------------new methods------------------------------------*/
509 
510   /**
511    * @dev method to updated allowedTransfers for an address
512    * @param _address that needs to be updated
513    * @param _allowedTransfers indicating if transfers are allowed or not
514    * @return boolean indicating function success.
515    */
516   function updateAllowedTransfers(address _address, bool _allowedTransfers)
517   external
518   onlyOwner
519   returns (bool)
520   {
521     // don't allow owner to change this for themselves
522     // otherwise whenNotPaused will not work as expected for owner,
523     // therefore prohibiting them from calling pause/unpause.
524     require(_address != owner);
525 
526     allowedTransfers[_address] = _allowedTransfers;
527     return true;
528   }
529 }
530 
531 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
532 
533 /**
534  * @title Crowdsale
535  * @dev Crowdsale is a base contract for managing a token crowdsale.
536  * Crowdsales have a start and end timestamps, where investors can make
537  * token purchases and the crowdsale will assign them tokens based
538  * on a token per ETH rate. Funds collected are forwarded to a wallet
539  * as they arrive. The contract requires a MintableToken that will be
540  * minted as contributions arrive, note that the crowdsale contract
541  * must be owner of the token in order to be able to mint it.
542  */
543 contract Crowdsale {
544   using SafeMath for uint256;
545 
546   // The token being sold
547   MintableToken public token;
548 
549   // start and end timestamps where investments are allowed (both inclusive)
550   uint256 public startTime;
551   uint256 public endTime;
552 
553   // address where funds are collected
554   address public wallet;
555 
556   // how many token units a buyer gets per wei
557   uint256 public rate;
558 
559   // amount of raised money in wei
560   uint256 public weiRaised;
561 
562   /**
563    * event for token purchase logging
564    * @param purchaser who paid for the tokens
565    * @param beneficiary who got the tokens
566    * @param value weis paid for purchase
567    * @param amount amount of tokens purchased
568    */
569   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
570 
571 
572   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public {
573     require(_startTime >= now);
574     require(_endTime >= _startTime);
575     require(_rate > 0);
576     require(_wallet != address(0));
577     require(_token != address(0));
578 
579     startTime = _startTime;
580     endTime = _endTime;
581     rate = _rate;
582     wallet = _wallet;
583     token = _token;
584   }
585 
586   // fallback function can be used to buy tokens
587   function () external payable {
588     buyTokens(msg.sender);
589   }
590 
591   // low level token purchase function
592   function buyTokens(address beneficiary) public payable {
593     require(beneficiary != address(0));
594     require(validPurchase());
595 
596     uint256 weiAmount = msg.value;
597 
598     // calculate token amount to be created
599     uint256 tokens = getTokenAmount(weiAmount);
600 
601     // update state
602     weiRaised = weiRaised.add(weiAmount);
603 
604     token.mint(beneficiary, tokens);
605     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
606 
607     forwardFunds();
608   }
609 
610   // @return true if crowdsale event has ended
611   function hasEnded() public view returns (bool) {
612     return now > endTime;
613   }
614 
615   // Override this method to have a way to add business logic to your crowdsale when buying
616   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
617     return weiAmount.mul(rate);
618   }
619 
620   // send ether to the fund collection wallet
621   // override to create custom fund forwarding mechanisms
622   function forwardFunds() internal {
623     wallet.transfer(msg.value);
624   }
625 
626   // @return true if the transaction can buy tokens
627   function validPurchase() internal view returns (bool) {
628     bool withinPeriod = now >= startTime && now <= endTime;
629     bool nonZeroPurchase = msg.value != 0;
630     return withinPeriod && nonZeroPurchase;
631   }
632 
633 }
634 
635 // File: zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
636 
637 /**
638  * @title CappedCrowdsale
639  * @dev Extension of Crowdsale with a max amount of funds raised
640  */
641 contract CappedCrowdsale is Crowdsale {
642   using SafeMath for uint256;
643 
644   uint256 public cap;
645 
646   function CappedCrowdsale(uint256 _cap) public {
647     require(_cap > 0);
648     cap = _cap;
649   }
650 
651   // overriding Crowdsale#hasEnded to add cap logic
652   // @return true if crowdsale event has ended
653   function hasEnded() public view returns (bool) {
654     bool capReached = weiRaised >= cap;
655     return capReached || super.hasEnded();
656   }
657 
658   // overriding Crowdsale#validPurchase to add extra cap logic
659   // @return true if investors can buy at the moment
660   function validPurchase() internal view returns (bool) {
661     bool withinCap = weiRaised.add(msg.value) <= cap;
662     return withinCap && super.validPurchase();
663   }
664 
665 }
666 
667 // File: contracts/MeshCrowdsale.sol
668 
669 /**
670  * CappedCrowdsale limits the total number of wei that can be collected in the sale.
671  */
672 contract MeshCrowdsale is CappedCrowdsale, Ownable {
673 
674   using SafeMath for uint256;
675 
676   /**
677    * @dev weiLimits keeps track of amount of wei that can be contibuted by an address.
678    */
679   mapping (address => uint256) public weiLimits;
680 
681   /**
682    * @dev weiContributions keeps track of amount of wei that are contibuted by an address.
683    */
684   mapping (address => uint256) public weiContributions;
685 
686   /**
687    * @dev whitelistingAgents keeps track of who is allowed to call the setLimit method
688    */
689   mapping (address => bool) public whitelistingAgents;
690 
691   /**
692    * @dev minimumContribution keeps track of what should be the minimum contribution required per address
693    */
694   uint256 public minimumContribution;
695 
696   /**
697    * @dev variable to keep track of beneficiaries for which we need to mint the tokens directly
698    */
699   address[] public beneficiaries;
700 
701   /**
702    * @dev variable to keep track of amount of tokens to mint for beneficiaries
703    */
704   uint256[] public beneficiaryAmounts;
705 
706   /**
707    * @dev variable to keep track of if predefined tokens have been minted
708    */
709   bool public mintingFinished;
710   /*---------------------------------constructor---------------------------------*/
711 
712   /**
713    * @dev Constructor for MeshCrowdsale contract
714    */
715   function MeshCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap, uint256 _minimumContribution, MeshToken _token, address[] _beneficiaries, uint256[] _beneficiaryAmounts)
716   CappedCrowdsale(_cap)
717   Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
718   public
719   {
720     require(_beneficiaries.length == _beneficiaryAmounts.length);
721     beneficiaries = _beneficiaries;
722     beneficiaryAmounts = _beneficiaryAmounts;
723     mintingFinished = false;
724 
725     minimumContribution = _minimumContribution;
726   }
727 
728   /*---------------------------------overridden methods---------------------------------*/
729 
730   /**
731    * overriding Crowdsale#buyTokens to keep track of wei contributed per address
732    */
733   function buyTokens(address beneficiary) public payable {
734     weiContributions[msg.sender] = weiContributions[msg.sender].add(msg.value);
735     super.buyTokens(beneficiary);
736   }
737 
738   /**
739    * overriding CappedCrowdsale#validPurchase to add extra contribution limit logic
740    * @return true if investors can buy at the moment
741    */
742   function validPurchase() internal view returns (bool) {
743     bool withinLimit = weiContributions[msg.sender] <= weiLimits[msg.sender];
744     bool atleastMinimumContribution = weiContributions[msg.sender] >= minimumContribution;
745     return atleastMinimumContribution && withinLimit && super.validPurchase();
746   }
747 
748 
749 
750   /*---------------------------------new methods---------------------------------*/
751 
752 
753   /**
754    * @dev Allows owner to add / remove whitelistingAgents
755    * @param _address that is being allowed or removed from whitelisting addresses
756    * @param _value boolean indicating if address is whitelisting agent or not
757    */
758   function setWhitelistingAgent(address _address, bool _value) external onlyOwner {
759     whitelistingAgents[_address] = _value;
760   }
761 
762   /**
763    * @dev Allows the current owner to update contribution limits
764    * @param _addresses whose contribution limits should be changed
765    * @param _weiLimit new contribution limit
766    */
767   function setLimit(address[] _addresses, uint256 _weiLimit) external {
768     require(whitelistingAgents[msg.sender] == true);
769 
770     for (uint i = 0; i < _addresses.length; i++) {
771       address _address = _addresses[i];
772 
773       // only allow changing the limit to be greater than current contribution
774       if(_weiLimit >= weiContributions[_address]) {
775         weiLimits[_address] = _weiLimit;
776       }
777     }
778   }
779 
780   /**
781    * @dev Allows the current owner to change the ETH to token generation rate.
782    * @param _rate indicating the new token generation rate.
783    */
784   function setRate(uint256 _rate) external onlyOwner {
785     // make sure the crowdsale has not started
786     require(weiRaised == 0 && now <= startTime);
787 
788     // make sure new rate is greater than 0
789     require(_rate > 0);
790 
791     rate = _rate;
792   }
793 
794 
795   /**
796    * @dev Allows the current owner to change the crowdsale cap.
797    * @param _cap indicating the new crowdsale cap.
798    */
799   function setCap(uint256 _cap) external onlyOwner {
800     // make sure the crowdsale has not started
801     require(weiRaised == 0 && now <= startTime);
802 
803     // make sure new cap is greater than 0
804     require(_cap > 0);
805 
806     cap = _cap;
807   }
808 
809   /**
810    * @dev Allows the current owner to change the required minimum contribution.
811    * @param _minimumContribution indicating the minimum required contribution.
812    */
813   function setMinimumContribution(uint256 _minimumContribution) external onlyOwner {
814     minimumContribution = _minimumContribution;
815   }
816 
817   /*
818    * @dev Function to perform minting to predefined beneficiaries once crowdsale has started
819    * can be called by only once and by owner only
820    */
821   function mintPredefinedTokens() external onlyOwner {
822     // prevent owner from minting twice
823     require(!mintingFinished);
824 
825     // make sure the crowdsale has started
826     require(weiRaised > 0);
827 
828     // loop through the list and call mint on token directly
829     // this minting does not affect any crowdsale numbers
830     for (uint i = 0; i < beneficiaries.length; i++) {
831       if (beneficiaries[i] != address(0) && token.balanceOf(beneficiaries[i]) == 0) {
832         token.mint(beneficiaries[i], beneficiaryAmounts[i]);
833       }
834     }
835     // set it at the end, making sure all transactions have been completed with the gas
836     mintingFinished = true;
837   }
838 
839   /*---------------------------------proxy methods for token when owned by contract---------------------------------*/
840   /**
841    * @dev Allows the current owner to transfer token control back to contract owner
842    */
843   function transferTokenOwnership() external onlyOwner {
844     token.transferOwnership(owner);
845   }
846 }