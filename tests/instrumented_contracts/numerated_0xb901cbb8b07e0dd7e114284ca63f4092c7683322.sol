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
424 // File: contracts\Whitelist.sol
425 
426 contract Whitelist is Ownable {
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
438             allowedAddresses[_addresses[i]] = true;
439             count++;
440             WhitelistUpdated(block.timestamp, "Added", _addresses[i], count);
441         }        
442     }
443 
444     function removeFromWhitelist(address[] _addresses) public onlyOwner {
445         for (uint i = 0; i < _addresses.length; i++) {
446             allowedAddresses[_addresses[i]] = false;
447             count--;
448             WhitelistUpdated(block.timestamp, "Removed", _addresses[i], count);
449         }         
450     }
451     
452     function isWhitelisted() public whitelisted constant returns (bool) {
453         return true;
454     }
455 
456     function addressIsWhitelisted(address _address) public constant returns (bool) {
457         return allowedAddresses[_address];
458     }
459 
460     function getAddressCount() public constant returns (uint) {
461         return count;
462     }
463 
464     event WhitelistUpdated(uint timestamp, string operation, address indexed member, uint totalAddresses);
465 }
466 
467 // File: contracts\zeppelin\crowdsale\Crowdsale.sol
468 
469 /**
470  * @title Crowdsale
471  * @dev Crowdsale is a base contract for managing a token crowdsale.
472  * Crowdsales have a start and end timestamps, where investors can make
473  * token purchases and the crowdsale will assign them tokens based
474  * on a token per ETH rate. Funds collected are forwarded to a wallet
475  * as they arrive.
476  */
477 contract Crowdsale {
478   using SafeMath for uint256;
479 
480   // The token being sold
481   MintableToken public token;
482 
483   // start and end timestamps where investments are allowed (both inclusive)
484   uint256 public startTime;
485   uint256 public endTime;
486 
487   // address where funds are collected
488   address public wallet;
489 
490   // how many token units a buyer gets per wei
491   uint256 public rate;
492 
493   // amount of raised money in wei
494   uint256 public weiRaised;
495 
496   /**
497    * event for token purchase logging
498    * @param purchaser who paid for the tokens
499    * @param beneficiary who got the tokens
500    * @param value weis paid for purchase
501    * @param amount amount of tokens purchased
502    */
503   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
504 
505 
506   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
507     require(_startTime >= now);
508     require(_endTime >= _startTime);
509     require(_rate > 0);
510     require(_wallet != address(0));
511 
512     token = createTokenContract();
513     startTime = _startTime;
514     endTime = _endTime;
515     rate = _rate;
516     wallet = _wallet;
517   }
518 
519   // creates the token to be sold.
520   // override this method to have crowdsale of a specific mintable token.
521   function createTokenContract() internal returns (MintableToken) {
522     return new MintableToken();
523   }
524 
525   // fallback function can be used to buy tokens
526   function () external payable {
527     buyTokens(msg.sender);
528   }
529 
530   // low level token purchase function
531   function buyTokens(address beneficiary) public payable {
532     require(beneficiary != address(0));
533     require(validPurchase());
534 
535     uint256 weiAmount = msg.value;
536 
537     // calculate token amount to be created
538     uint256 tokens = weiAmount.mul(rate);
539 
540     // update state
541     weiRaised = weiRaised.add(weiAmount);
542 
543     token.mint(beneficiary, tokens);
544     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
545 
546     forwardFunds();
547   }
548 
549   // send ether to the fund collection wallet
550   // override to create custom fund forwarding mechanisms
551   function forwardFunds() internal {
552     wallet.transfer(msg.value);
553   }
554 
555   // @return true if the transaction can buy tokens
556   function validPurchase() internal  returns (bool) {
557     bool withinPeriod = now >= startTime && now <= endTime;
558     bool nonZeroPurchase = msg.value != 0;
559     return withinPeriod && nonZeroPurchase;
560   }
561 
562   // @return true if crowdsale event has started
563   function hasStarted() public constant returns (bool) {
564     return now >= startTime;
565   }
566 
567   // @return true if crowdsale event has ended
568   function hasEnded() public view returns (bool) {
569     return now > endTime;
570   }
571 
572   // @return current timestamp
573   function currentTime() public constant returns(uint256) { 
574     return now;
575   }
576 }
577 
578 // File: contracts\zeppelin\crowdsale\CappedCrowdsale.sol
579 
580 /**
581  * @title CappedCrowdsale
582  * @dev Extension of Crowdsale with a max amount of funds raised
583  */
584 contract CappedCrowdsale is Crowdsale {
585   using SafeMath for uint256;
586 
587   uint256 public cap;
588 
589   function CappedCrowdsale(uint256 _cap) public {
590     require(_cap > 0);
591     cap = _cap;
592   }
593 
594   // overriding Crowdsale#validPurchase to add extra cap logic
595   // @return true if investors can buy at the moment
596   function validPurchase() internal  returns (bool) {
597     bool withinCap = weiRaised.add(msg.value) <= cap;
598     return super.validPurchase() && withinCap;
599   }
600 
601   // overriding Crowdsale#hasEnded to add cap logic
602   // @return true if crowdsale event has ended
603   function hasEnded() public view returns (bool) {
604     bool capReached = weiRaised >= cap;
605     return super.hasEnded() || capReached;
606   }
607 
608 }
609 
610 // File: contracts\BlockportPresale.sol
611 
612 /// @title Blockport Token - Token code for our Blockport.nl Project
613 /// @author Jan Bolhuis, Wesley van Heije
614 //  Version 3, december 2017
615 //  Based on Openzeppelin with an aye on the Pillarproject code.
616 //
617 //  There will be a presale cap of 6.400.000 BPT Tokens
618 //  Minimum presale investment in Ether will be set at the start; calculated on a weekly avarage for an amount of ~ 1000 Euro
619 //  Unsold presale tokens will be burnt
620 //  Presale rate has a 33% bonus to the crowdsale to compensate the extra risk. This is implemented by setting the rate on the presale and Crowdsale contacts.
621 //  The total supply of tokens (pre-sale + crowdsale) will be 49,600,000 BPT
622 //  Minimum crowdsale investment will be 0.1 ether
623 //  Mac cap for the crowdsale is 43,200,000 BPT
624 //
625 
626 contract BlockportPresale is CappedCrowdsale, Whitelist, Pausable {
627 
628     address public tokenAddress;
629     uint256 public minimalInvestmentInWei = 1.7 ether;       // Is to be set when setting the rate
630 
631     BlockportToken public bpToken;
632 
633     event InitialRateChange(uint256 rate, uint256 cap, uint256 minimalInvestment);
634 
635     // Initialise contract with parapametrs
636     //@notice Function to initialise the token with configurable parameters. 
637     //@param ` _cap - max number ot tokens available for the presale
638     //@param ' _startTime - this is the place to adapt the presale period
639     //@param ` _endTime - this is the place to adapt the presale period
640     //@param ` rate - initial presale rate.
641     //@param ` _wallet - Multisig wallet the investments are being send to during presale
642     //@param ` _tokenAddress - Token to be used, created outside the prsale contract  
643     function BlockportPresale(uint256 _cap, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _tokenAddress) 
644         CappedCrowdsale(_cap) 
645         Crowdsale(_startTime, _endTime, _rate, _wallet) public {
646             tokenAddress = _tokenAddress;
647             token = createTokenContract();
648         }
649 
650     //@notice Function to cast the Capped (&mintable) token provided with the constructor to a blockporttoken that is mintabletoken.
651     // This is a workaround to surpass an issue that Mintabletoken functions are not accessible in this contract.
652     // We did not want to change the Openzeppelin code and we did not have the time for an extensive drill down.
653     function createTokenContract() internal returns (MintableToken) {
654         bpToken = BlockportToken(tokenAddress);
655         return BlockportToken(tokenAddress);
656     }
657 
658     // overriding Crowdsale#validPurchase to add extra cap logic
659     // @return true if investors can buy at the moment
660     function validPurchase() internal returns (bool) {
661         bool minimalInvested = msg.value >= minimalInvestmentInWei;
662         bool whitelisted = addressIsWhitelisted(msg.sender);
663 
664         return super.validPurchase() && minimalInvested && !paused && whitelisted;
665     }
666 
667     //@notice Function sets the token conversion rate in this contract
668     //@param ` __rateInWei - Price of 1 Blockport token in Wei. 
669     //@param ` __capInWei - Cap of the Presale in Wei. 
670     //@param ` __minimalInvestmentInWei - Minimal investment in Wei. 
671     function setRate(uint256 _rateInWei, uint256 _capInWei, uint256 _minimalInvestmentInWei) public onlyOwner returns (bool) { 
672         require(startTime >= block.timestamp); // can't update anymore if sale already started
673         require(_rateInWei > 0);
674         require(_capInWei > 0);
675         require(_minimalInvestmentInWei > 0);
676 
677         rate = _rateInWei;
678         cap = _capInWei;
679         minimalInvestmentInWei = _minimalInvestmentInWei;
680 
681         InitialRateChange(rate, cap, minimalInvestmentInWei);
682         return true;
683     }
684 
685     //@notice Function sets the token owner to contract owner
686     function resetTokenOwnership() onlyOwner public { 
687         bpToken.transferOwnership(owner);
688     }
689 }