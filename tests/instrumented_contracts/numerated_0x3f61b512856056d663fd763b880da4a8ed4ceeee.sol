1 pragma solidity ^0.4.15;
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
21   function Ownable() {
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
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   uint256 public totalSupply;
56   function balanceOf(address who) public constant returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 // File: zeppelin-solidity/contracts/token/ERC20.sol
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public constant returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 // File: zeppelin-solidity/contracts/token/SafeERC20.sol
75 
76 /**
77  * @title SafeERC20
78  * @dev Wrappers around ERC20 operations that throw on failure.
79  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
80  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
81  */
82 library SafeERC20 {
83   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
84     assert(token.transfer(to, value));
85   }
86 
87   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
88     assert(token.transferFrom(from, to, value));
89   }
90 
91   function safeApprove(ERC20 token, address spender, uint256 value) internal {
92     assert(token.approve(spender, value));
93   }
94 }
95 
96 // File: contracts/TokenTimelock.sol
97 
98 // This code was based on: https://github.com/OpenZeppelin/zeppelin-solidity.
99 // Change the releaseTime type from uint64 to uint265 and add the valid KYC flag
100 pragma solidity ^0.4.15;
101 
102 
103 
104 
105 
106 /**
107  * @title TokenTimelock
108  * @dev TokenTimelock is a token holder contract that will allow a
109  * beneficiary to extract the tokens after a given release time and KYC valid.
110  */
111 contract TokenTimelock is Ownable {
112   using SafeERC20 for ERC20Basic;
113 
114   // ERC20 basic token contract being held
115   ERC20Basic public token;
116 
117   // beneficiary of tokens after they are released
118   address public beneficiary;
119 
120   // timestamp when token release is enabled
121   uint256 public releaseTime;
122 
123   // KYC valid
124   bool public kycValid = false;
125 
126   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
127     require(_releaseTime > now);
128     token = _token;
129     beneficiary = _beneficiary;
130     releaseTime = _releaseTime;
131   }
132 
133   /**
134     * @notice Transfers tokens held by timelock to beneficiary.
135     */
136   function release() public {
137     require(now >= releaseTime);
138     require(kycValid);
139 
140     uint256 amount = token.balanceOf(this);
141     require(amount > 0);
142 
143     token.safeTransfer(beneficiary, amount);
144   }
145 
146   function setValidKYC(bool _valid) public onlyOwner {
147     kycValid = _valid;
148   }
149 }
150 
151 // File: zeppelin-solidity/contracts/math/SafeMath.sol
152 
153 /**
154  * @title SafeMath
155  * @dev Math operations with safety checks that throw on error
156  */
157 library SafeMath {
158   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
159     uint256 c = a * b;
160     assert(a == 0 || c / a == b);
161     return c;
162   }
163 
164   function div(uint256 a, uint256 b) internal constant returns (uint256) {
165     // assert(b > 0); // Solidity automatically throws when dividing by 0
166     uint256 c = a / b;
167     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168     return c;
169   }
170 
171   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
172     assert(b <= a);
173     return a - b;
174   }
175 
176   function add(uint256 a, uint256 b) internal constant returns (uint256) {
177     uint256 c = a + b;
178     assert(c >= a);
179     return c;
180   }
181 }
182 
183 // File: zeppelin-solidity/contracts/token/BasicToken.sol
184 
185 /**
186  * @title Basic token
187  * @dev Basic version of StandardToken, with no allowances.
188  */
189 contract BasicToken is ERC20Basic {
190   using SafeMath for uint256;
191 
192   mapping(address => uint256) balances;
193 
194   /**
195   * @dev transfer token for a specified address
196   * @param _to The address to transfer to.
197   * @param _value The amount to be transferred.
198   */
199   function transfer(address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0));
201 
202     // SafeMath.sub will throw if there is not enough balance.
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     Transfer(msg.sender, _to, _value);
206     return true;
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint256 representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) public constant returns (uint256 balance) {
215     return balances[_owner];
216   }
217 
218 }
219 
220 // File: zeppelin-solidity/contracts/token/StandardToken.sol
221 
222 /**
223  * @title Standard ERC20 token
224  *
225  * @dev Implementation of the basic standard token.
226  * @dev https://github.com/ethereum/EIPs/issues/20
227  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
228  */
229 contract StandardToken is ERC20, BasicToken {
230 
231   mapping (address => mapping (address => uint256)) allowed;
232 
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242 
243     uint256 _allowance = allowed[_from][msg.sender];
244 
245     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
246     // require (_value <= _allowance);
247 
248     balances[_from] = balances[_from].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     allowed[_from][msg.sender] = _allowance.sub(_value);
251     Transfer(_from, _to, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257    *
258    * Beware that changing an allowance with this method brings the risk that someone may use both the old
259    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
260    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
261    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262    * @param _spender The address which will spend the funds.
263    * @param _value The amount of tokens to be spent.
264    */
265   function approve(address _spender, uint256 _value) public returns (bool) {
266     allowed[msg.sender][_spender] = _value;
267     Approval(msg.sender, _spender, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Function to check the amount of tokens that an owner allowed to a spender.
273    * @param _owner address The address which owns the funds.
274    * @param _spender address The address which will spend the funds.
275    * @return A uint256 specifying the amount of tokens still available for the spender.
276    */
277   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
278     return allowed[_owner][_spender];
279   }
280 
281   /**
282    * approve should be called when allowed[_spender] == 0. To increment
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    */
287   function increaseApproval (address _spender, uint _addedValue)
288     returns (bool success) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   function decreaseApproval (address _spender, uint _subtractedValue)
295     returns (bool success) {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 // File: zeppelin-solidity/contracts/token/MintableToken.sol
309 
310 /**
311  * @title Mintable token
312  * @dev Simple ERC20 Token example, with mintable token creation
313  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
314  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
315  */
316 
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
336     totalSupply = totalSupply.add(_amount);
337     balances[_to] = balances[_to].add(_amount);
338     Mint(_to, _amount);
339     Transfer(0x0, _to, _amount);
340     return true;
341   }
342 
343   /**
344    * @dev Function to stop minting new tokens.
345    * @return True if the operation was successful.
346    */
347   function finishMinting() onlyOwner public returns (bool) {
348     mintingFinished = true;
349     MintFinished();
350     return true;
351   }
352 }
353 
354 // File: contracts/TutellusToken.sol
355 
356 /**
357  * @title Tutellus Token
358  * @author Javier Ortiz
359  *
360  * @dev ERC20 Tutellus Token (TUT)
361  */
362 contract TutellusToken is MintableToken {
363    string public name = "Tutellus";
364    string public symbol = "TUT";
365    uint8 public decimals = 18;
366 }
367 
368 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
369 
370 /**
371  * @title Crowdsale
372  * @dev Crowdsale is a base contract for managing a token crowdsale.
373  * Crowdsales have a start and end timestamps, where investors can make
374  * token purchases and the crowdsale will assign them tokens based
375  * on a token per ETH rate. Funds collected are forwarded to a wallet
376  * as they arrive.
377  */
378 contract Crowdsale {
379   using SafeMath for uint256;
380 
381   // The token being sold
382   MintableToken public token;
383 
384   // start and end timestamps where investments are allowed (both inclusive)
385   uint256 public startTime;
386   uint256 public endTime;
387 
388   // address where funds are collected
389   address public wallet;
390 
391   // how many token units a buyer gets per wei
392   uint256 public rate;
393 
394   // amount of raised money in wei
395   uint256 public weiRaised;
396 
397   /**
398    * event for token purchase logging
399    * @param purchaser who paid for the tokens
400    * @param beneficiary who got the tokens
401    * @param value weis paid for purchase
402    * @param amount amount of tokens purchased
403    */
404   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
405 
406 
407   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
408     require(_startTime >= now);
409     require(_endTime >= _startTime);
410     require(_rate > 0);
411     require(_wallet != 0x0);
412 
413     token = createTokenContract();
414     startTime = _startTime;
415     endTime = _endTime;
416     rate = _rate;
417     wallet = _wallet;
418   }
419 
420   // creates the token to be sold.
421   // override this method to have crowdsale of a specific mintable token.
422   function createTokenContract() internal returns (MintableToken) {
423     return new MintableToken();
424   }
425 
426 
427   // fallback function can be used to buy tokens
428   function () payable {
429     buyTokens(msg.sender);
430   }
431 
432   // low level token purchase function
433   function buyTokens(address beneficiary) public payable {
434     require(beneficiary != 0x0);
435     require(validPurchase());
436 
437     uint256 weiAmount = msg.value;
438 
439     // calculate token amount to be created
440     uint256 tokens = weiAmount.mul(rate);
441 
442     // update state
443     weiRaised = weiRaised.add(weiAmount);
444 
445     token.mint(beneficiary, tokens);
446     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
447 
448     forwardFunds();
449   }
450 
451   // send ether to the fund collection wallet
452   // override to create custom fund forwarding mechanisms
453   function forwardFunds() internal {
454     wallet.transfer(msg.value);
455   }
456 
457   // @return true if the transaction can buy tokens
458   function validPurchase() internal constant returns (bool) {
459     bool withinPeriod = now >= startTime && now <= endTime;
460     bool nonZeroPurchase = msg.value != 0;
461     return withinPeriod && nonZeroPurchase;
462   }
463 
464   // @return true if crowdsale event has ended
465   function hasEnded() public constant returns (bool) {
466     return now > endTime;
467   }
468 
469 
470 }
471 
472 // File: zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
473 
474 /**
475  * @title CappedCrowdsale
476  * @dev Extension of Crowdsale with a max amount of funds raised
477  */
478 contract CappedCrowdsale is Crowdsale {
479   using SafeMath for uint256;
480 
481   uint256 public cap;
482 
483   function CappedCrowdsale(uint256 _cap) {
484     require(_cap > 0);
485     cap = _cap;
486   }
487 
488   // overriding Crowdsale#validPurchase to add extra cap logic
489   // @return true if investors can buy at the moment
490   function validPurchase() internal constant returns (bool) {
491     bool withinCap = weiRaised.add(msg.value) <= cap;
492     return super.validPurchase() && withinCap;
493   }
494 
495   // overriding Crowdsale#hasEnded to add cap logic
496   // @return true if crowdsale event has ended
497   function hasEnded() public constant returns (bool) {
498     bool capReached = weiRaised >= cap;
499     return super.hasEnded() || capReached;
500   }
501 
502 }
503 
504 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
505 
506 /**
507  * @title FinalizableCrowdsale
508  * @dev Extension of Crowdsale where an owner can do extra work
509  * after finishing.
510  */
511 contract FinalizableCrowdsale is Crowdsale, Ownable {
512   using SafeMath for uint256;
513 
514   bool public isFinalized = false;
515 
516   event Finalized();
517 
518   /**
519    * @dev Must be called after crowdsale ends, to do some extra finalization
520    * work. Calls the contract's finalization function.
521    */
522   function finalize() onlyOwner public {
523     require(!isFinalized);
524     require(hasEnded());
525 
526     finalization();
527     Finalized();
528 
529     isFinalized = true;
530   }
531 
532   /**
533    * @dev Can be overridden to add finalization logic. The overriding function
534    * should call super.finalization() to ensure the chain of finalization is
535    * executed entirely.
536    */
537   function finalization() internal {
538   }
539 }
540 
541 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
542 
543 /**
544  * @title Pausable
545  * @dev Base contract which allows children to implement an emergency stop mechanism.
546  */
547 contract Pausable is Ownable {
548   event Pause();
549   event Unpause();
550 
551   bool public paused = false;
552 
553 
554   /**
555    * @dev Modifier to make a function callable only when the contract is not paused.
556    */
557   modifier whenNotPaused() {
558     require(!paused);
559     _;
560   }
561 
562   /**
563    * @dev Modifier to make a function callable only when the contract is paused.
564    */
565   modifier whenPaused() {
566     require(paused);
567     _;
568   }
569 
570   /**
571    * @dev called by the owner to pause, triggers stopped state
572    */
573   function pause() onlyOwner whenNotPaused public {
574     paused = true;
575     Pause();
576   }
577 
578   /**
579    * @dev called by the owner to unpause, returns to normal state
580    */
581   function unpause() onlyOwner whenPaused public {
582     paused = false;
583     Unpause();
584   }
585 }
586 
587 // File: contracts/TutellusCrowdsale.sol
588 
589 /**
590  * @title TutellusCrowdsale
591  *
592  * @dev Crowdsale for the Tutellus.io ICO.
593  *
594  * Upon finalization the pool and the team's wallet are mined. It must be
595  * finalized once all the backers (including the vesting ones) have made
596  * their contributions.
597  */
598 contract TutellusCrowdsale is CappedCrowdsale, FinalizableCrowdsale, Pausable {
599     event ConditionsAdded(address indexed beneficiary, uint256 rate);
600     
601     mapping(address => uint256) public conditions;
602 
603     mapping(address => address) public timelocksContracts;
604 
605     uint256 salePercent = 60;   // Percent of TUTs for sale
606     uint256 poolPercent = 30;   // Percent of TUTs for pool
607     uint256 teamPercent = 10;   // Percent of TUTs for team
608 
609     uint256 vestingLimit = 700 ether;
610     uint256 specialLimit = 300 ether;
611 
612     uint256 minPreICO = 10 ether;
613     uint256 minICO = 0.5 ether;
614 
615     address teamTimelock;   //Team TokenTimelock.
616 
617     function TutellusCrowdsale(
618         uint256 _startTime,
619         uint256 _endTime,
620         uint256 _cap,
621         address _wallet,
622         address _teamTimelock,
623         address _tokenAddress
624     )
625         CappedCrowdsale(_cap)
626         Crowdsale(_startTime, _endTime, 1000, _wallet)
627     {
628         require(_teamTimelock != address(0));
629         teamTimelock = _teamTimelock;
630 
631         if (_tokenAddress != address(0)) {
632             token = TutellusToken(_tokenAddress);
633         }
634     }
635 
636     function addSpecialRateConditions(address _address, uint256 _rate) public onlyOwner {
637         require(_address != address(0));
638         require(_rate > 0);
639 
640         conditions[_address] = _rate;
641         ConditionsAdded(_address, _rate);
642     }
643 
644     // Returns TUTs rate per 1 ETH depending on current time
645     function getRateByTime() public constant returns (uint256) {
646         uint256 timeNow = now;
647         if (timeNow > (startTime + 11 weeks)) {
648             return 1000;
649         } else if (timeNow > (startTime + 10 weeks)) {
650             return 1050; // + 5%
651         } else if (timeNow > (startTime + 9 weeks)) {
652             return 1100; // + 10%
653         } else if (timeNow > (startTime + 8 weeks)) {
654             return 1200; // + 20%
655         } else if (timeNow > (startTime + 6 weeks)) {
656             return 1350; // + 35%
657         } else if (timeNow > (startTime + 4 weeks)) {
658             return 1400; // + 40%
659         } else if (timeNow > (startTime + 2 weeks)) {
660             return 1450; // + 45%
661         } else {
662             return 1500; // + 50%
663         }
664     }
665 
666     function getTimelock(address _address) public constant returns(address) {
667         return timelocksContracts[_address];
668     }
669 
670     function getValidTimelock(address _address) internal returns(address) {
671         address timelockAddress = getTimelock(_address);
672         // check, if not have already one
673         if (timelockAddress == address(0)) {
674             timelockAddress = new TokenTimelock(token, _address, endTime);
675             timelocksContracts[_address] = timelockAddress;
676         }
677         return timelockAddress;
678     }
679 
680     function buyTokens(address beneficiary) whenNotPaused public payable {
681         require(beneficiary != address(0));
682         require(msg.value >= minICO && msg.value <= vestingLimit);
683         require(validPurchase());
684 
685         uint256 rate;
686         address contractAddress;
687 
688         if (conditions[beneficiary] != 0) {
689             require(msg.value >= specialLimit);
690             rate = conditions[beneficiary];
691         } else {
692             rate = getRateByTime();
693             if (rate > 1200) {
694                 require(msg.value >= minPreICO);
695             }
696         }
697 
698         contractAddress = getValidTimelock(beneficiary);
699 
700         mintTokens(rate, contractAddress, beneficiary);
701     }
702 
703     function mintTokens(uint _rate, address _address, address beneficiary) internal {
704         uint256 weiAmount = msg.value;
705 
706         // calculate token amount to be created
707         uint256 tokens = weiAmount.mul(_rate);
708 
709         // update state
710         weiRaised = weiRaised.add(weiAmount);
711 
712         token.mint(_address, tokens);
713         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
714 
715         forwardFunds();
716     }
717 
718     // Calculate the Tokens in percent over de tokens generated
719     function poolTokensByPercent(uint256 _percent) internal returns(uint256) {
720         return token.totalSupply().mul(_percent).div(salePercent);
721     }
722 
723     // Method to mint the team and pool tokens
724     function finalization() internal {
725         uint256 tokensPool = poolTokensByPercent(poolPercent);
726         uint256 tokensTeam = poolTokensByPercent(teamPercent);
727 
728         token.mint(wallet, tokensPool);
729         token.mint(teamTimelock, tokensTeam);
730     }
731 
732     function createTokenContract() internal returns (MintableToken) {
733         return new TutellusToken();
734     }
735 }