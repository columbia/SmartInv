1 pragma solidity 0.4.15;
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
47 // File: contracts/Authorizable.sol
48 
49 contract Authorizable is Ownable {
50     event LogAccess(address authAddress);
51     event Grant(address authAddress, bool grant);
52 
53     mapping(address => bool) public auth;
54 
55     modifier authorized() {
56         LogAccess(msg.sender);
57         require(auth[msg.sender]);
58         _;
59     }
60 
61     function authorize(address _address) onlyOwner public {
62         Grant(_address, true);
63         auth[_address] = true;
64     }
65 
66     function unauthorize(address _address) onlyOwner public {
67         Grant(_address, false);
68         auth[_address] = false;
69     }
70 }
71 
72 // File: zeppelin-solidity/contracts/math/SafeMath.sol
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
80     uint256 c = a * b;
81     assert(a == 0 || c / a == b);
82     return c;
83   }
84 
85   function div(uint256 a, uint256 b) internal constant returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   function add(uint256 a, uint256 b) internal constant returns (uint256) {
98     uint256 c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   uint256 public totalSupply;
113   function balanceOf(address who) public constant returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 // File: zeppelin-solidity/contracts/token/BasicToken.sol
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   /**
130   * @dev transfer token for a specified address
131   * @param _to The address to transfer to.
132   * @param _value The amount to be transferred.
133   */
134   function transfer(address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136 
137     // SafeMath.sub will throw if there is not enough balance.
138     balances[msg.sender] = balances[msg.sender].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     Transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of.
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) public constant returns (uint256 balance) {
150     return balances[_owner];
151   }
152 
153 }
154 
155 // File: zeppelin-solidity/contracts/token/ERC20.sol
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender) public constant returns (uint256);
163   function transferFrom(address from, address to, uint256 value) public returns (bool);
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 // File: zeppelin-solidity/contracts/token/StandardToken.sol
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189     require(_to != address(0));
190 
191     uint256 _allowance = allowed[_from][msg.sender];
192 
193     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
194     // require (_value <= _allowance);
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = _allowance.sub(_value);
199     Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    *
206    * Beware that changing an allowance with this method brings the risk that someone may use both the old
207    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifying the amount of tokens still available for the spender.
224    */
225   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * approve should be called when allowed[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    */
235   function increaseApproval (address _spender, uint _addedValue)
236     returns (bool success) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   function decreaseApproval (address _spender, uint _subtractedValue)
243     returns (bool success) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 // File: zeppelin-solidity/contracts/token/MintableToken.sol
257 
258 /**
259  * @title Mintable token
260  * @dev Simple ERC20 Token example, with mintable token creation
261  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
262  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
263  */
264 
265 contract MintableToken is StandardToken, Ownable {
266   event Mint(address indexed to, uint256 amount);
267   event MintFinished();
268 
269   bool public mintingFinished = false;
270 
271 
272   modifier canMint() {
273     require(!mintingFinished);
274     _;
275   }
276 
277   /**
278    * @dev Function to mint tokens
279    * @param _to The address that will receive the minted tokens.
280    * @param _amount The amount of tokens to mint.
281    * @return A boolean that indicates if the operation was successful.
282    */
283   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
284     totalSupply = totalSupply.add(_amount);
285     balances[_to] = balances[_to].add(_amount);
286     Mint(_to, _amount);
287     Transfer(0x0, _to, _amount);
288     return true;
289   }
290 
291   /**
292    * @dev Function to stop minting new tokens.
293    * @return True if the operation was successful.
294    */
295   function finishMinting() onlyOwner public returns (bool) {
296     mintingFinished = true;
297     MintFinished();
298     return true;
299   }
300 }
301 
302 // File: contracts/TutellusToken.sol
303 
304 /**
305  * @title Tutellus Token
306  * @author Javier Ortiz
307  *
308  * @dev ERC20 Tutellus Token (TUT)
309  */
310 contract TutellusToken is MintableToken {
311    string public name = "Tutellus";
312    string public symbol = "TUT";
313    uint8 public decimals = 18;
314 }
315 
316 // File: contracts/TutellusLockerVault.sol
317 
318 contract TutellusLockerVault is Authorizable {
319     event Deposit(address indexed _address, uint256 _amount);
320     event Verify(address indexed _address);
321     event Release(address indexed _address);
322 
323     uint256 releaseTime;
324     TutellusToken token;
325 
326     mapping(address => uint256) public amounts;
327     mapping(address => bool) public verified;
328 
329     function TutellusLockerVault(
330         uint256 _releaseTime, 
331         address _token
332     ) public 
333     {
334         require(_releaseTime > now);
335         require(_token != address(0));
336         
337         releaseTime = _releaseTime;
338         token = TutellusToken(_token);
339     }
340 
341     function verify(address _address) authorized public {
342         require(_address != address(0));
343         
344         verified[_address] = true;
345         Verify(_address);
346     }
347 
348     function deposit(address _address, uint256 _amount) authorized public {
349         require(_address != address(0));
350         require(_amount > 0);
351 
352         amounts[_address] += _amount;
353         Deposit(_address, _amount);
354     }
355 
356     function release() public returns(bool) {
357         require(now >= releaseTime);
358         require(verified[msg.sender]);
359 
360         uint256 amount = amounts[msg.sender];
361         if (amount > 0) {
362             amounts[msg.sender] = 0;
363             if (!token.transfer(msg.sender, amount)) {
364                 amounts[msg.sender] = amount;
365                 return false;
366             }
367             Release(msg.sender);
368         }
369         return true;
370     }
371 }
372 
373 // File: contracts/TutellusVault.sol
374 
375 contract TutellusVault is Authorizable {
376     event VaultMint(address indexed authAddress);
377 
378     TutellusToken public token;
379 
380     function TutellusVault() public {
381         token = new TutellusToken();
382     }
383 
384     function mint(address _to, uint256 _amount) authorized public returns (bool) {
385         require(_to != address(0));
386         require(_amount >= 0);
387 
388         VaultMint(msg.sender);
389         return token.mint(_to, _amount);
390     }
391 }
392 
393 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
394 
395 /**
396  * @title Crowdsale
397  * @dev Crowdsale is a base contract for managing a token crowdsale.
398  * Crowdsales have a start and end timestamps, where investors can make
399  * token purchases and the crowdsale will assign them tokens based
400  * on a token per ETH rate. Funds collected are forwarded to a wallet
401  * as they arrive.
402  */
403 contract Crowdsale {
404   using SafeMath for uint256;
405 
406   // The token being sold
407   MintableToken public token;
408 
409   // start and end timestamps where investments are allowed (both inclusive)
410   uint256 public startTime;
411   uint256 public endTime;
412 
413   // address where funds are collected
414   address public wallet;
415 
416   // how many token units a buyer gets per wei
417   uint256 public rate;
418 
419   // amount of raised money in wei
420   uint256 public weiRaised;
421 
422   /**
423    * event for token purchase logging
424    * @param purchaser who paid for the tokens
425    * @param beneficiary who got the tokens
426    * @param value weis paid for purchase
427    * @param amount amount of tokens purchased
428    */
429   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
430 
431 
432   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
433     require(_startTime >= now);
434     require(_endTime >= _startTime);
435     require(_rate > 0);
436     require(_wallet != 0x0);
437 
438     token = createTokenContract();
439     startTime = _startTime;
440     endTime = _endTime;
441     rate = _rate;
442     wallet = _wallet;
443   }
444 
445   // creates the token to be sold.
446   // override this method to have crowdsale of a specific mintable token.
447   function createTokenContract() internal returns (MintableToken) {
448     return new MintableToken();
449   }
450 
451 
452   // fallback function can be used to buy tokens
453   function () payable {
454     buyTokens(msg.sender);
455   }
456 
457   // low level token purchase function
458   function buyTokens(address beneficiary) public payable {
459     require(beneficiary != 0x0);
460     require(validPurchase());
461 
462     uint256 weiAmount = msg.value;
463 
464     // calculate token amount to be created
465     uint256 tokens = weiAmount.mul(rate);
466 
467     // update state
468     weiRaised = weiRaised.add(weiAmount);
469 
470     token.mint(beneficiary, tokens);
471     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
472 
473     forwardFunds();
474   }
475 
476   // send ether to the fund collection wallet
477   // override to create custom fund forwarding mechanisms
478   function forwardFunds() internal {
479     wallet.transfer(msg.value);
480   }
481 
482   // @return true if the transaction can buy tokens
483   function validPurchase() internal constant returns (bool) {
484     bool withinPeriod = now >= startTime && now <= endTime;
485     bool nonZeroPurchase = msg.value != 0;
486     return withinPeriod && nonZeroPurchase;
487   }
488 
489   // @return true if crowdsale event has ended
490   function hasEnded() public constant returns (bool) {
491     return now > endTime;
492   }
493 
494 
495 }
496 
497 // File: zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
498 
499 /**
500  * @title CappedCrowdsale
501  * @dev Extension of Crowdsale with a max amount of funds raised
502  */
503 contract CappedCrowdsale is Crowdsale {
504   using SafeMath for uint256;
505 
506   uint256 public cap;
507 
508   function CappedCrowdsale(uint256 _cap) {
509     require(_cap > 0);
510     cap = _cap;
511   }
512 
513   // overriding Crowdsale#validPurchase to add extra cap logic
514   // @return true if investors can buy at the moment
515   function validPurchase() internal constant returns (bool) {
516     bool withinCap = weiRaised.add(msg.value) <= cap;
517     return super.validPurchase() && withinCap;
518   }
519 
520   // overriding Crowdsale#hasEnded to add cap logic
521   // @return true if crowdsale event has ended
522   function hasEnded() public constant returns (bool) {
523     bool capReached = weiRaised >= cap;
524     return super.hasEnded() || capReached;
525   }
526 
527 }
528 
529 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
530 
531 /**
532  * @title FinalizableCrowdsale
533  * @dev Extension of Crowdsale where an owner can do extra work
534  * after finishing.
535  */
536 contract FinalizableCrowdsale is Crowdsale, Ownable {
537   using SafeMath for uint256;
538 
539   bool public isFinalized = false;
540 
541   event Finalized();
542 
543   /**
544    * @dev Must be called after crowdsale ends, to do some extra finalization
545    * work. Calls the contract's finalization function.
546    */
547   function finalize() onlyOwner public {
548     require(!isFinalized);
549     require(hasEnded());
550 
551     finalization();
552     Finalized();
553 
554     isFinalized = true;
555   }
556 
557   /**
558    * @dev Can be overridden to add finalization logic. The overriding function
559    * should call super.finalization() to ensure the chain of finalization is
560    * executed entirely.
561    */
562   function finalization() internal {
563   }
564 }
565 
566 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
567 
568 /**
569  * @title Pausable
570  * @dev Base contract which allows children to implement an emergency stop mechanism.
571  */
572 contract Pausable is Ownable {
573   event Pause();
574   event Unpause();
575 
576   bool public paused = false;
577 
578 
579   /**
580    * @dev Modifier to make a function callable only when the contract is not paused.
581    */
582   modifier whenNotPaused() {
583     require(!paused);
584     _;
585   }
586 
587   /**
588    * @dev Modifier to make a function callable only when the contract is paused.
589    */
590   modifier whenPaused() {
591     require(paused);
592     _;
593   }
594 
595   /**
596    * @dev called by the owner to pause, triggers stopped state
597    */
598   function pause() onlyOwner whenNotPaused public {
599     paused = true;
600     Pause();
601   }
602 
603   /**
604    * @dev called by the owner to unpause, returns to normal state
605    */
606   function unpause() onlyOwner whenPaused public {
607     paused = false;
608     Unpause();
609   }
610 }
611 
612 // File: contracts/TutellusCrowdsale.sol
613 
614 /**
615  * @title TutellusCrowdsale
616  *
617  * @dev Crowdsale for the Tutellus.io ICO.
618  *
619  * Upon finalization the pool and the team's wallet are mined. It must be
620  * finalized once all the backers (including the vesting ones) have made
621  * their contributions.
622  */
623 contract TutellusCrowdsale is CappedCrowdsale, FinalizableCrowdsale, Pausable {
624     event ConditionsAdded(address indexed beneficiary, uint256 rate);
625     
626     mapping(address => uint256) public conditions;
627 
628     uint256 salePercent = 60;   // Percent of TUTs for sale
629     uint256 poolPercent = 30;   // Percent of TUTs for pool
630     uint256 teamPercent = 10;   // Percent of TUTs for team
631 
632     uint256 vestingLimit; // 400 ether;
633     uint256 specialLimit; // 200 ether;
634 
635     uint256 minPreICO; // 5 ether;
636     uint256 minICO; // 0.05 ether;
637 
638     uint256 unitTimeSecs; //86400 secs;
639 
640     address teamTimelock; //Team TokenTimelock.
641 
642     TutellusVault vault;
643     TutellusLockerVault locker;
644 
645     function TutellusCrowdsale(
646         uint256 _startTime,
647         uint256 _endTime,
648         uint256 _cap,
649         address _wallet,
650         address _teamTimelock,
651         address _tutellusVault,
652         address _lockerVault,
653         uint256 _vestingLimit,
654         uint256 _specialLimit,
655         uint256 _minPreICO,
656         uint256 _minICO,
657         uint256 _unitTimeSecs
658     )
659         CappedCrowdsale(_cap)
660         Crowdsale(_startTime, _endTime, 1000, _wallet)
661     {
662         require(_teamTimelock != address(0));
663         require(_tutellusVault != address(0));
664         require(_vestingLimit > _specialLimit);
665         require(_minPreICO > _minICO);
666         require(_unitTimeSecs > 0);
667 
668         teamTimelock = _teamTimelock;
669         vault = TutellusVault(_tutellusVault);
670         token = MintableToken(vault.token());
671 
672         locker = TutellusLockerVault(_lockerVault);
673 
674         vestingLimit = _vestingLimit;
675         specialLimit = _specialLimit;
676         minPreICO = _minPreICO;
677         minICO = _minICO;
678         unitTimeSecs = _unitTimeSecs;
679     }
680 
681     function addSpecialRateConditions(address _address, uint256 _rate) public onlyOwner {
682         require(_address != address(0));
683         require(_rate > 0);
684 
685         conditions[_address] = _rate;
686         ConditionsAdded(_address, _rate);
687     }
688 
689     // Returns TUTs rate per 1 ETH depending on current time
690     function getRateByTime() public constant returns (uint256) {
691         uint256 timeNow = now;
692         if (timeNow > (startTime + 94 * unitTimeSecs)) {
693             return 1500;
694         } else if (timeNow > (startTime + 87 * unitTimeSecs)) {
695             return 1575; // + 5%
696         } else if (timeNow > (startTime + 80 * unitTimeSecs)) {
697             return 1650; // + 10%
698         } else if (timeNow > (startTime + 73 * unitTimeSecs)) {
699             return 1800; // + 20%
700         } else if (timeNow > (startTime + 56 * unitTimeSecs)) {
701             return 2025; // + 35%
702         } else if (timeNow > (startTime + 42 * unitTimeSecs)) {
703             return 2100; // + 40%
704         } else if (timeNow > (startTime + 28 * unitTimeSecs)) {
705             return 2175; // + 45%
706         } else {
707             return 2250; // + 50%
708         }
709     }
710 
711     function buyTokens(address beneficiary) whenNotPaused public payable {
712         require(beneficiary != address(0));
713         require(msg.value >= minICO && msg.value <= vestingLimit);
714         require(validPurchase());
715 
716         uint256 senderRate;
717 
718         if (conditions[beneficiary] != 0) {
719             require(msg.value >= specialLimit);
720             senderRate = conditions[beneficiary];
721         } else {
722             senderRate = getRateByTime();
723             if (senderRate > 1800) {
724                 require(msg.value >= minPreICO);
725             }
726         }
727 
728         uint256 weiAmount = msg.value;
729         // calculate token amount to be created
730         uint256 tokens = weiAmount.mul(senderRate);
731         // update state
732         weiRaised = weiRaised.add(weiAmount);
733 
734         locker.deposit(beneficiary, tokens);
735         vault.mint(locker, tokens);
736         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
737 
738         forwardFunds();
739     }
740 
741     // Calculate the Tokens in percent over de tokens generated
742     function poolTokensByPercent(uint256 _percent) internal returns(uint256) {
743         return token.totalSupply().mul(_percent).div(salePercent);
744     }
745 
746     // Method to mint the team and pool tokens
747     function finalization() internal {
748         uint256 tokensPool = poolTokensByPercent(poolPercent);
749         uint256 tokensTeam = poolTokensByPercent(teamPercent);
750 
751         vault.mint(wallet, tokensPool);
752         vault.mint(teamTimelock, tokensTeam);
753     }
754 
755     function createTokenContract() internal returns (MintableToken) {}
756 }