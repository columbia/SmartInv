1 pragma solidity ^0.4.13;
2 
3 // File: contracts\zeppelin\ownership\Ownable.sol
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
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts\zeppelin\math\SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal  returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal  returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal  returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal  returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: contracts\zeppelin\token\ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public  returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts\zeppelin\token\BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public  returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: contracts\zeppelin\token\ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public  returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: contracts\zeppelin\token\StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     return BasicToken.transfer(_to, _value);
168   }
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(address _owner, address _spender) public  returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    */
220   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227     uint oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue > oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 // File: contracts\zeppelin\token\MintableToken.sol
240 
241 /**
242  * @title Mintable token
243  * @dev Simple ERC20 Token example, with mintable token creation
244  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
245  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
246  */
247 
248 contract MintableToken is StandardToken, Ownable {
249   event Mint(address indexed to, uint256 amount);
250   event MintFinished();
251 
252   bool public mintingFinished = false;
253 
254 
255   modifier canMint() {
256     require(!mintingFinished);
257     _;
258   }
259 
260   /**
261    * @dev Function to mint tokens
262    * @param _to The address that will receive the minted tokens.
263    * @param _amount The amount of tokens to mint.
264    * @return A boolean that indicates if the operation was successful.
265    */
266   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
267     totalSupply = totalSupply.add(_amount);
268     balances[_to] = balances[_to].add(_amount);
269     Mint(_to, _amount);
270     Transfer(address(0), _to, _amount);
271     return true;
272   }
273 
274   /**
275    * @dev Function to stop minting new tokens.
276    * @return True if the operation was successful.
277    */
278   function finishMinting() onlyOwner canMint public returns (bool) {
279     mintingFinished = true;
280     MintFinished();
281     return true;
282   }
283 }
284 
285 // File: contracts\zeppelin\token\CappedToken.sol
286 
287 /**
288  * @title Capped token
289  * @dev Mintable token with a token cap.
290  */
291 
292 contract CappedToken is MintableToken {
293 
294   uint256 public cap;
295 
296   function CappedToken(uint256 _cap) public {
297     require(_cap > 0);
298     cap = _cap;
299   }
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    */
307   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
308     require(totalSupply.add(_amount) <= cap);
309 
310     return super.mint(_to, _amount);
311   }
312 
313 }
314 
315 // File: contracts\zeppelin\lifecycle\Pausable.sol
316 
317 /**
318  * @title Pausable
319  * @dev Base contract which allows children to implement an emergency stop mechanism.
320  */
321 contract Pausable is Ownable {
322   event Pause();
323   event Unpause();
324 
325   bool public paused = false;
326 
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is not paused.
330    */
331   modifier whenNotPaused() {
332     require(!paused);
333     _;
334   }
335 
336   /**
337    * @dev Modifier to make a function callable only when the contract is paused.
338    */
339   modifier whenPaused() {
340     require(paused);
341     _;
342   }
343 
344   /**
345    * @dev called by the owner to pause, triggers stopped state
346    */
347   function pause() onlyOwner whenNotPaused public {
348     paused = true;
349     Pause();
350   }
351 
352   /**
353    * @dev called by the owner to unpause, returns to normal state
354    */
355   function unpause() onlyOwner whenPaused public {
356     paused = false;
357     Unpause();
358   }
359 }
360 
361 // File: contracts\zeppelin\token\PausableToken.sol
362 
363 /**
364  * @title Pausable token
365  *
366  * @dev StandardToken modified with pausable transfers.
367  **/
368 
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
392 // File: contracts\BlockportToken.sol
393 
394 /// @title Blockport Token - Token code for our Blockport.nl Project
395 /// @author Jan Bolhuis, Wesley van Heije
396 //  Version 3, december 2017
397 //  This version is completely based on the Openzeppelin Solidity framework.
398 //
399 //  There will be a presale cap of 6.400.000 BPT Tokens
400 //  Minimum presale investment in Ether will be set at the start in the Presale contract; calculated on a weekly avarage for an amount of ~ 1000 Euro
401 //  Unsold presale tokens will be burnt, implemented as mintbale token as such that only sold tokens are minted.
402 //  Presale rate has a 33% bonus to the crowdsale to compensate the extra risk
403 //  The total supply of tokens (pre-sale + crowdsale) will be 49,600,000 BPT
404 //  Minimum crowdsale investment will be 0.1 ether
405 //  Mac cap for the crowdsale is 43,200,000 BPT
406 //  There is no bonus scheme for the crowdsale
407 //  Unsold Crowsdale tokens will be burnt, implemented as mintbale token as such that only sold tokens are minted.
408 //  On the amount tokens sold an additional 40% will be minted; this will be allocated to the Blockport company(20%) and the Blockport team(20%)
409 //  BPT tokens will be tradable straigt after the finalization of the crowdsale. This is implemented by being a pausable token that is unpaused at Crowdsale finalisation.
410 
411 
412 contract BlockportToken is CappedToken, PausableToken {
413 
414     string public constant name                 = "Blockport Token";
415     string public constant symbol               = "BPT";
416     uint public constant decimals               = 18;
417 
418     function BlockportToken(uint256 _totalSupply) 
419         CappedToken(_totalSupply) public {
420             paused = true;
421     }
422 }
423 
424 // File: contracts\CrowdsaleWhitelist.sol
425 
426 contract CrowdsaleWhitelist is Ownable {
427     
428     mapping(address => bool) allowedAddresses;
429     uint count = 0;
430     
431     modifier whitelisted() {
432         require(allowedAddresses[msg.sender] == true);
433         _;
434     }
435 
436     function addToWhitelist(address[] _addresses) public onlyOwner {
437         for (uint i = 0; i < _addresses.length; i++) {
438             if (allowedAddresses[_addresses[i]]) { 
439                 continue;
440             }
441 
442             allowedAddresses[_addresses[i]] = true;
443             count++;
444         }
445 
446         WhitelistUpdated(block.timestamp, "Added", count);  
447     }
448 
449     function removeFromWhitelist(address[] _addresses) public onlyOwner {
450         for (uint i = 0; i < _addresses.length; i++) {
451             if (!allowedAddresses[_addresses[i]]) { 
452                 continue;
453             }
454 
455             allowedAddresses[_addresses[i]] = false;
456             count--;
457         }
458         
459         WhitelistUpdated(block.timestamp, "Removed", count);        
460     }
461     
462     function isWhitelisted() public whitelisted constant returns (bool) {
463         return true;
464     }
465 
466     function addressIsWhitelisted(address _address) public constant returns (bool) {
467         return allowedAddresses[_address];
468     }
469 
470     function getAddressCount() public constant returns (uint) {
471         return count;
472     }
473 
474     event WhitelistUpdated(uint timestamp, string operation, uint totalAddresses);
475 }
476 
477 // File: contracts\zeppelin\crowdsale\Crowdsale.sol
478 
479 /**
480  * @title Crowdsale
481  * @dev Crowdsale is a base contract for managing a token crowdsale.
482  * Crowdsales have a start and end timestamps, where investors can make
483  * token purchases and the crowdsale will assign them tokens based
484  * on a token per ETH rate. Funds collected are forwarded to a wallet
485  * as they arrive.
486  */
487 contract Crowdsale {
488   using SafeMath for uint256;
489 
490   // The token being sold
491   MintableToken public token;
492 
493   // start and end timestamps where investments are allowed (both inclusive)
494   uint256 public startTime;
495   uint256 public endTime;
496 
497   // address where funds are collected
498   address public wallet;
499 
500   // how many token units a buyer gets per wei
501   uint256 public rate;
502 
503   // amount of raised money in wei
504   uint256 public weiRaised;
505 
506   /**
507    * event for token purchase logging
508    * @param purchaser who paid for the tokens
509    * @param beneficiary who got the tokens
510    * @param value weis paid for purchase
511    * @param amount amount of tokens purchased
512    */
513   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
514 
515 
516   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
517     require(_startTime >= now);
518     require(_endTime >= _startTime);
519     require(_rate > 0);
520     require(_wallet != address(0));
521 
522     token = createTokenContract();
523     startTime = _startTime;
524     endTime = _endTime;
525     rate = _rate;
526     wallet = _wallet;
527   }
528 
529   // creates the token to be sold.
530   // override this method to have crowdsale of a specific mintable token.
531   function createTokenContract() internal returns (MintableToken) {
532     return new MintableToken();
533   }
534 
535   // fallback function can be used to buy tokens
536   function () external payable {
537     buyTokens(msg.sender);
538   }
539 
540   // low level token purchase function
541   function buyTokens(address beneficiary) public payable {
542     require(beneficiary != address(0));
543     require(validPurchase());
544 
545     uint256 weiAmount = msg.value;
546 
547     // calculate token amount to be created
548     uint256 tokens = weiAmount.mul(rate);
549 
550     // update state
551     weiRaised = weiRaised.add(weiAmount);
552 
553     token.mint(beneficiary, tokens);
554     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
555 
556     forwardFunds();
557   }
558 
559   // send ether to the fund collection wallet
560   // override to create custom fund forwarding mechanisms
561   function forwardFunds() internal {
562     wallet.transfer(msg.value);
563   }
564 
565   // @return true if the transaction can buy tokens
566   function validPurchase() internal  returns (bool) {
567     bool withinPeriod = now >= startTime && now <= endTime;
568     bool nonZeroPurchase = msg.value != 0;
569     return withinPeriod && nonZeroPurchase;
570   }
571 
572   // @return true if crowdsale event has started
573   function hasStarted() public constant returns (bool) {
574     return now >= startTime;
575   }
576 
577   // @return true if crowdsale event has ended
578   function hasEnded() public view returns (bool) {
579     return now > endTime;
580   }
581 
582   // @return current timestamp
583   function currentTime() public constant returns(uint256) { 
584     return now;
585   }
586 }
587 
588 // File: contracts\zeppelin\crowdsale\CappedCrowdsale.sol
589 
590 /**
591  * @title CappedCrowdsale
592  * @dev Extension of Crowdsale with a max amount of funds raised
593  */
594 contract CappedCrowdsale is Crowdsale {
595   using SafeMath for uint256;
596 
597   uint256 public cap;
598 
599   function CappedCrowdsale(uint256 _cap) public {
600     require(_cap > 0);
601     cap = _cap;
602   }
603 
604   // overriding Crowdsale#validPurchase to add extra cap logic
605   // @return true if investors can buy at the moment
606   function validPurchase() internal  returns (bool) {
607     bool withinCap = weiRaised.add(msg.value) <= cap;
608     return super.validPurchase() && withinCap;
609   }
610 
611   // overriding Crowdsale#hasEnded to add cap logic
612   // @return true if crowdsale event has ended
613   function hasEnded() public view returns (bool) {
614     bool capReached = weiRaised >= cap;
615     return super.hasEnded() || capReached;
616   }
617 
618 }
619 
620 // File: contracts\zeppelin\crowdsale\FinalizableCrowdsale.sol
621 
622 /**
623  * @title FinalizableCrowdsale
624  * @dev Extension of Crowdsale where an owner can do extra work
625  * after finishing.
626  */
627 contract FinalizableCrowdsale is Crowdsale, Ownable {
628   using SafeMath for uint256;
629 
630   bool public isFinalized = false;
631 
632   event Finalized();
633 
634   /**
635    * @dev Must be called after crowdsale ends, to do some extra finalization
636    * work. Calls the contract's finalization function.
637    */
638   function finalize() onlyOwner public {
639     require(!isFinalized);
640 
641     finalization();
642     Finalized();
643 
644     isFinalized = true;
645   }
646 
647   /**
648    * @dev Can be overridden to add finalization logic. The overriding function
649    * should call super.finalization() to ensure the chain of finalization is
650    * executed entirely.
651    */
652   function finalization() internal {
653   }
654 }
655 
656 // File: contracts\BlockportCrowdsale.sol
657 
658 /// @title Blockport Token - Token code for our Blockport.nl Project
659 /// @author Jan Bolhuis, Wesley van Heije
660 //  Version 3, January 2018
661 //  Based on Openzeppelin framework
662 //
663 //  The Crowdsale will start after the presale which had a cap of 6.400.000 BPT Tokens
664 //  Minimum presale investment in Ether will be set at the start; calculated on a weekly avarage for an amount of ~ 1000 Euro
665 //  Unsold presale tokens will be burnt. Implemented by using MintedToken.
666 //  There is no bonus in the Crowdsale.
667 //  The total supply of tokens (pre-sale + crowdsale) will be 49,600,000 BPT
668 //  Minimum crowdsale investment will be 0.1 ether
669 //  Mac cap for the crowdsale is 43,200,000 BPT
670 // 
671 //  
672 contract BlockportCrowdsale is CappedCrowdsale, FinalizableCrowdsale, CrowdsaleWhitelist, Pausable {
673     using SafeMath for uint256;
674 
675     address public tokenAddress;
676     address public teamVault;
677     address public companyVault;
678     uint256 public minimalInvestmentInWei = 0.1 ether;
679     uint256 public maxInvestmentInWei = 50 ether;
680     
681     mapping (address => uint256) internal invested;
682 
683     BlockportToken public bpToken;
684 
685     // Events for this contract
686     event InitialRateChange(uint256 rate, uint256 cap);
687     event InitialDateChange(uint256 startTime, uint256 endTime);
688 
689     // Initialise contract with parapametrs
690     //@notice Function to initialise the token with configurable parameters. 
691     //@param ` _cap - max number ot tokens available for the presale
692     //@param ` _goal - goal can be set, below this value the Crowdsale becomes refundable
693     //@param ' _startTime - this is the place to adapt the presale period
694     //@param ` _endTime - this is the place to adapt the presale period
695     //@param ` rate - initial presale rate.
696     //@param ` _wallet - Multisig wallet the investments are being send to during presale
697     //@param ` _tokenAddress - Token to be used, created outside the prsale contract  
698     //@param ` _teamVault - Ether send to this contract will be stored  at this multisig wallet
699     function BlockportCrowdsale(uint256 _cap, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _tokenAddress, address _teamVault, address _companyVault) 
700         CappedCrowdsale(_cap)
701         Crowdsale(_startTime, _endTime, _rate, _wallet) public {
702             require(_tokenAddress != address(0));
703             require(_teamVault != address(0));
704             require(_companyVault != address(0));
705             
706             tokenAddress = _tokenAddress;
707             token = createTokenContract();
708             teamVault = _teamVault;
709             companyVault = _companyVault;
710     }
711 
712     //@notice Function to cast the Capped (&mintable) token provided with the constructor to a blockporttoken that is mintabletoken.
713     // This is a workaround to surpass an issue that Mintabletoken functions are not accessible in this contract.
714     // We did not want to change the Openzeppelin code and we did not have the time for an extensive drill down.
715     function createTokenContract() internal returns (MintableToken) {
716         bpToken = BlockportToken(tokenAddress);
717         return BlockportToken(tokenAddress);
718     }
719 
720     // low level token purchase function
721     function buyTokens(address beneficiary) public payable {
722         invested[msg.sender] += msg.value;
723         super.buyTokens(beneficiary);
724     }
725 
726     // overriding Crowdsale#validPurchase to add extra cap logic
727     // @return true if investors can buy at the moment
728     function validPurchase() internal returns (bool) {
729         bool moreThanMinimalInvestment = msg.value >= minimalInvestmentInWei;
730         bool whitelisted = addressIsWhitelisted(msg.sender);
731         bool lessThanMaxInvestment = invested[msg.sender] <= maxInvestmentInWei;
732 
733         return super.validPurchase() && moreThanMinimalInvestment && lessThanMaxInvestment && !paused && whitelisted;
734     }
735 
736     //@notice Function overidden function will finanalise the Crowdsale
737     // Additional tokens are allocated to the team and to the company, adding 40% in total to tokens already sold. 
738     // After calling this function the blockporttoken gan be tranfered / traded by the holders of this token.
739     function finalization() internal {
740         uint256 totalSupply = token.totalSupply();
741         uint256 twentyPercentAllocation = totalSupply.div(5);
742 
743         // mint tokens for the foundation
744         token.mint(teamVault, twentyPercentAllocation);
745         token.mint(companyVault, twentyPercentAllocation);
746 
747         token.finishMinting();              // No more tokens can be added from now
748         bpToken.unpause();                  // ERC20 transfer functions will work after this so trading can start.
749         super.finalization();               // finalise up in the tree
750         
751         bpToken.transferOwnership(owner);   // transfer token Ownership back to original owner
752     }
753 
754     //@notice Function sets the token conversion rate in this contract
755     //@param ` __rateInWei - Price of 1 Blockport token in Wei. 
756     //@param ` __capInWei - Price of 1 Blockport token in Wei. 
757     function setRate(uint256 _rateInWei, uint256 _capInWei) public onlyOwner returns (bool) { 
758         require(startTime > block.timestamp);
759         require(_rateInWei > 0);
760         require(_capInWei > 0);
761 
762         rate = _rateInWei;
763         cap = _capInWei;
764 
765         InitialRateChange(rate, cap);
766         return true;
767     }
768 
769     //@notice Function sets start and end date/time for this Crowdsale. Can be called multiple times
770     //@param ' _startTime - this is the place to adapt the presale period
771     //@param ` _endTime - this is the place to adapt the presale period
772     function setCrowdsaleDates(uint256 _startTime, uint256 _endTime) public onlyOwner returns (bool) { 
773         require(startTime > block.timestamp); // current startTime in the future
774         require(_startTime >= now);
775         require(_endTime >= _startTime);
776 
777         startTime = _startTime;
778         endTime = _endTime;
779 
780         InitialDateChange(startTime, endTime);
781         return true;
782     }
783 
784     //@notice Function sets the token owner to contract owner
785     function resetTokenOwnership() onlyOwner public { 
786         bpToken.transferOwnership(owner);
787     }
788 
789 }