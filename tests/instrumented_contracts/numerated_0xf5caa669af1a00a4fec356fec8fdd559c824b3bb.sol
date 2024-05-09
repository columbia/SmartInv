1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold.
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126 
127   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   function Ownable() {
135     owner = msg.sender;
136   }
137 
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address newOwner) onlyOwner public {
153     require(newOwner != address(0));
154     OwnershipTransferred(owner, newOwner);
155     owner = newOwner;
156   }
157 
158 }
159 
160 contract FinalizableCrowdsale is Crowdsale, Ownable {
161   using SafeMath for uint256;
162 
163   bool public isFinalized = false;
164 
165   event Finalized();
166 
167   /**
168    * @dev Must be called after crowdsale ends, to do some extra finalization
169    * work. Calls the contract's finalization function.
170    */
171   function finalize() onlyOwner public {
172     require(!isFinalized);
173     require(hasEnded());
174 
175     finalization();
176     Finalized();
177 
178     isFinalized = true;
179   }
180 
181   /**
182    * @dev Can be overridden to add finalization logic. The overriding function
183    * should call super.finalization() to ensure the chain of finalization is
184    * executed entirely.
185    */
186   function finalization() internal {
187   }
188 }
189 
190 contract RefundVault is Ownable {
191   using SafeMath for uint256;
192 
193   enum State { Active, Refunding, Closed }
194 
195   mapping (address => uint256) public deposited;
196   address public wallet;
197   State public state;
198 
199   event Closed();
200   event RefundsEnabled();
201   event Refunded(address indexed beneficiary, uint256 weiAmount);
202 
203   function RefundVault(address _wallet) {
204     require(_wallet != 0x0);
205     wallet = _wallet;
206     state = State.Active;
207   }
208 
209   function deposit(address investor) onlyOwner public payable {
210     require(state == State.Active);
211     deposited[investor] = deposited[investor].add(msg.value);
212   }
213 
214   function close() onlyOwner public {
215     require(state == State.Active);
216     state = State.Closed;
217     Closed();
218     wallet.transfer(this.balance);
219   }
220 
221   function enableRefunds() onlyOwner public {
222     require(state == State.Active);
223     state = State.Refunding;
224     RefundsEnabled();
225   }
226 
227   function refund(address investor) public {
228     require(state == State.Refunding);
229     uint256 depositedValue = deposited[investor];
230     deposited[investor] = 0;
231     investor.transfer(depositedValue);
232     Refunded(investor, depositedValue);
233   }
234 }
235 
236 contract RefundableCrowdsale is FinalizableCrowdsale {
237   using SafeMath for uint256;
238 
239   // minimum amount of funds to be raised in weis
240   uint256 public goal;
241 
242   // refund vault used to hold funds while crowdsale is running
243   RefundVault public vault;
244 
245   function RefundableCrowdsale(uint256 _goal) {
246     require(_goal > 0);
247     vault = new RefundVault(wallet);
248     goal = _goal;
249   }
250 
251   // We're overriding the fund forwarding from Crowdsale.
252   // In addition to sending the funds, we want to call
253   // the RefundVault deposit function
254   function forwardFunds() internal {
255     vault.deposit.value(msg.value)(msg.sender);
256   }
257 
258   // if crowdsale is unsuccessful, investors can claim refunds here
259   function claimRefund() public {
260     require(isFinalized);
261     require(!goalReached());
262 
263     vault.refund(msg.sender);
264   }
265 
266   // vault finalization task, called when owner calls finalize()
267   function finalization() internal {
268     if (goalReached()) {
269       vault.close();
270     } else {
271       vault.enableRefunds();
272     }
273 
274     super.finalization();
275   }
276 
277   function goalReached() public constant returns (bool) {
278     return weiRaised >= goal;
279   }
280 
281 }
282 
283 contract Pausable is Ownable {
284   event Pause();
285   event Unpause();
286 
287   bool public paused = false;
288 
289 
290   /**
291    * @dev Modifier to make a function callable only when the contract is not paused.
292    */
293   modifier whenNotPaused() {
294     require(!paused);
295     _;
296   }
297 
298   /**
299    * @dev Modifier to make a function callable only when the contract is paused.
300    */
301   modifier whenPaused() {
302     require(paused);
303     _;
304   }
305 
306   /**
307    * @dev called by the owner to pause, triggers stopped state
308    */
309   function pause() onlyOwner whenNotPaused public {
310     paused = true;
311     Pause();
312   }
313 
314   /**
315    * @dev called by the owner to unpause, returns to normal state
316    */
317   function unpause() onlyOwner whenPaused public {
318     paused = false;
319     Unpause();
320   }
321 }
322 
323 contract ERC20Basic {
324   uint256 public totalSupply;
325   function balanceOf(address who) public constant returns (uint256);
326   function transfer(address to, uint256 value) public returns (bool);
327   event Transfer(address indexed from, address indexed to, uint256 value);
328 }
329 
330 contract BasicToken is ERC20Basic {
331   using SafeMath for uint256;
332 
333   mapping(address => uint256) balances;
334 
335   /**
336   * @dev transfer token for a specified address
337   * @param _to The address to transfer to.
338   * @param _value The amount to be transferred.
339   */
340   function transfer(address _to, uint256 _value) public returns (bool) {
341     require(_to != address(0));
342 
343     // SafeMath.sub will throw if there is not enough balance.
344     balances[msg.sender] = balances[msg.sender].sub(_value);
345     balances[_to] = balances[_to].add(_value);
346     Transfer(msg.sender, _to, _value);
347     return true;
348   }
349 
350   /**
351   * @dev Gets the balance of the specified address.
352   * @param _owner The address to query the the balance of.
353   * @return An uint256 representing the amount owned by the passed address.
354   */
355   function balanceOf(address _owner) public constant returns (uint256 balance) {
356     return balances[_owner];
357   }
358 
359 }
360 
361 contract ERC20 is ERC20Basic {
362   function allowance(address owner, address spender) public constant returns (uint256);
363   function transferFrom(address from, address to, uint256 value) public returns (bool);
364   function approve(address spender, uint256 value) public returns (bool);
365   event Approval(address indexed owner, address indexed spender, uint256 value);
366 }
367 
368 contract StandardToken is ERC20, BasicToken {
369 
370   mapping (address => mapping (address => uint256)) allowed;
371 
372 
373   /**
374    * @dev Transfer tokens from one address to another
375    * @param _from address The address which you want to send tokens from
376    * @param _to address The address which you want to transfer to
377    * @param _value uint256 the amount of tokens to be transferred
378    */
379   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
380     require(_to != address(0));
381 
382     uint256 _allowance = allowed[_from][msg.sender];
383 
384     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
385     // require (_value <= _allowance);
386 
387     balances[_from] = balances[_from].sub(_value);
388     balances[_to] = balances[_to].add(_value);
389     allowed[_from][msg.sender] = _allowance.sub(_value);
390     Transfer(_from, _to, _value);
391     return true;
392   }
393 
394   /**
395    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
396    *
397    * Beware that changing an allowance with this method brings the risk that someone may use both the old
398    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
399    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
400    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
401    * @param _spender The address which will spend the funds.
402    * @param _value The amount of tokens to be spent.
403    */
404   function approve(address _spender, uint256 _value) public returns (bool) {
405     allowed[msg.sender][_spender] = _value;
406     Approval(msg.sender, _spender, _value);
407     return true;
408   }
409 
410   /**
411    * @dev Function to check the amount of tokens that an owner allowed to a spender.
412    * @param _owner address The address which owns the funds.
413    * @param _spender address The address which will spend the funds.
414    * @return A uint256 specifying the amount of tokens still available for the spender.
415    */
416   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
417     return allowed[_owner][_spender];
418   }
419 
420   /**
421    * approve should be called when allowed[_spender] == 0. To increment
422    * allowed value is better to use this function to avoid 2 calls (and wait until
423    * the first transaction is mined)
424    * From MonolithDAO Token.sol
425    */
426   function increaseApproval (address _spender, uint _addedValue)
427     returns (bool success) {
428     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
429     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
430     return true;
431   }
432 
433   function decreaseApproval (address _spender, uint _subtractedValue)
434     returns (bool success) {
435     uint oldValue = allowed[msg.sender][_spender];
436     if (_subtractedValue > oldValue) {
437       allowed[msg.sender][_spender] = 0;
438     } else {
439       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
440     }
441     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
442     return true;
443   }
444 
445 }
446 
447 contract BurnableToken is StandardToken {
448 
449     event Burn(address indexed burner, uint256 value);
450 
451     /**
452      * @dev Burns a specific amount of tokens.
453      * @param _value The amount of token to be burned.
454      */
455     function burn(uint256 _value) public {
456         require(_value > 0);
457 
458         address burner = msg.sender;
459         balances[burner] = balances[burner].sub(_value);
460         totalSupply = totalSupply.sub(_value);
461         Burn(burner, _value);
462     }
463 }
464 
465 contract MintableToken is StandardToken, Ownable {
466   event Mint(address indexed to, uint256 amount);
467   event MintFinished();
468 
469   bool public mintingFinished = false;
470 
471 
472   modifier canMint() {
473     require(!mintingFinished);
474     _;
475   }
476 
477   /**
478    * @dev Function to mint tokens
479    * @param _to The address that will receive the minted tokens.
480    * @param _amount The amount of tokens to mint.
481    * @return A boolean that indicates if the operation was successful.
482    */
483   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
484     totalSupply = totalSupply.add(_amount);
485     balances[_to] = balances[_to].add(_amount);
486     Mint(_to, _amount);
487     Transfer(0x0, _to, _amount);
488     return true;
489   }
490 
491   /**
492    * @dev Function to stop minting new tokens.
493    * @return True if the operation was successful.
494    */
495   function finishMinting() onlyOwner public returns (bool) {
496     mintingFinished = true;
497     MintFinished();
498     return true;
499   }
500 }
501 
502 contract PausableToken is StandardToken, Pausable {
503 
504   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
505     return super.transfer(_to, _value);
506   }
507 
508   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
509     return super.transferFrom(_from, _to, _value);
510   }
511 
512   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
513     return super.approve(_spender, _value);
514   }
515 
516   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
517     return super.increaseApproval(_spender, _addedValue);
518   }
519 
520   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
521     return super.decreaseApproval(_spender, _subtractedValue);
522   }
523 }
524 
525 contract StampifyToken is MintableToken, PausableToken, BurnableToken {  
526 
527     string public constant name = "Stampify Token";
528     string public constant symbol = "STAMP";
529     uint8 public constant decimals = 18;
530 
531     function StampifyToken() {
532         pause();
533     }
534 }
535 
536 contract TokenCappedCrowdsale is Crowdsale {
537     using SafeMath for uint256;
538 
539     uint256 public cap;
540     uint256 public tokenSold;
541 
542     function TokenCappedCrowdsale(uint256 _cap) {
543         require(_cap > 0);
544         cap = _cap;
545     }
546 
547     // low level token purchase function
548     function buyTokens(address beneficiary) public payable {
549         require(beneficiary != 0x0);
550         require(validPurchase());
551 
552         uint256 weiAmount = msg.value;
553 
554         // calculate token amount to be created
555         uint256 tokens = weiToTokens(weiAmount, now);
556         require(tokenSold.add(tokens) <= cap);
557         
558         // update state
559         weiRaised = weiRaised.add(weiAmount);
560         tokenSold = tokenSold.add(tokens);
561 
562         token.mint(beneficiary, tokens);
563         TokenPurchase(
564             msg.sender,
565             beneficiary,
566             weiAmount,
567             tokens);
568 
569         forwardFunds();
570     }
571 
572     function weiToTokens(uint256 weiAmount, uint256 time) internal returns (uint256) {
573         uint256 _rate = getRate(time);
574         return weiAmount.mul(_rate);
575     }
576 
577     // low level get rate function
578     // override to create custom rate function, like giving bonus for early contributors or whitelist addresses
579     function getRate(uint256 time) internal returns (uint256) {
580         return rate;
581     }
582 
583     // overriding Crowdsale#hasEnded to add cap logic
584     // @return true if crowdsale event has ended
585     function hasEnded() public constant returns (bool) {
586         bool capReached = tokenSold >= cap;
587         return super.hasEnded() || capReached;
588     }
589 }
590 
591 contract StampifyTokenSale is TokenCappedCrowdsale, RefundableCrowdsale, Pausable {
592     using SafeMath for uint256;
593 
594     // Constants
595     uint256 constant private BIG_BUYER_THRESHOLD = 40 * 10**18; // 40 ETH
596     uint256 constant public RESERVE_AMOUNT = 25000000 * 10**18; // 25M STAMPS
597 
598     // Modifiers
599     modifier isValidDataString(uint256 weiAmount, bytes data) {
600         if (weiAmount > BIG_BUYER_THRESHOLD) {
601             require(bytesToBytes32(data) == dataWhitelist[1]);
602         } else {
603             require(bytesToBytes32(data) == dataWhitelist[0]);
604         }
605         _;
606     }
607 
608     // Data types
609     struct TeamMember {
610         address wallet; // Address of team member's wallet
611         address vault;   // Address of token timelock vault
612         uint64 shareDiv; // Divisor to be used to get member's token share
613     }
614     
615     // Private
616     uint64[4] private salePeriods;
617     bytes32[2] private dataWhitelist;
618     uint8 private numTeamMembers;
619     mapping (uint => address) private memberLookup;
620 
621     // Public
622     mapping (address => TeamMember) public teamMembers;  // founders & contributors vaults (beneficiary,vault) + Org's multisig
623 
624     function StampifyTokenSale(
625         uint256 _startTime,
626         uint256 _endTime,
627         uint256 _rate,
628         uint256 _goal,
629         uint256 _cap,
630         address _wallet,
631         uint64[4] _salePeriods,
632         bytes32[2] _dataWhitelist
633       )
634       TokenCappedCrowdsale(_cap)
635       FinalizableCrowdsale()
636       RefundableCrowdsale(_goal)
637       Crowdsale(_startTime, _endTime, _rate, _wallet)
638     {
639         require(_goal.mul(_rate) <= _cap);
640 
641         for (uint8 i = 0; i < _salePeriods.length; i++) {
642             require(_salePeriods[i] > 0);
643         }
644         salePeriods = _salePeriods;
645         dataWhitelist = _dataWhitelist;
646     }
647 
648     function createTokenContract() internal returns (MintableToken) {
649         return new StampifyToken();
650     }
651 
652     function () whenNotPaused isValidDataString(msg.value, msg.data) payable {
653         super.buyTokens(msg.sender);
654     }
655 
656     // low level token purchase function
657     function buyTokens(address beneficiary) whenNotPaused isValidDataString(msg.value, msg.data) public payable {
658         super.buyTokens(beneficiary);
659     }
660 
661     // gamification
662     function getRate(uint256 time) internal returns (uint256) {
663         if (time <= salePeriods[0]) {
664             return 750;
665         }
666         
667         if (time <= salePeriods[1]) {
668             return 600;
669         }
670 
671         if (time <= salePeriods[2]) {
672             return 575;
673         }
674 
675         if (time <= salePeriods[3]) {
676             return 525;
677         }
678 
679         return rate;
680     }
681 
682     function setTeamVault(address _wallet, address _vault, uint64 _shareDiv) onlyOwner public returns (bool) {
683         require(now < startTime); // Only before sale starts !
684         require(_wallet != address(0));
685         require(_vault != address(0));
686         require(_shareDiv > 0);
687 
688         require(numTeamMembers + 1 <= 8);
689 
690         memberLookup[numTeamMembers] = _wallet;
691         teamMembers[_wallet] = TeamMember(_wallet, _vault, _shareDiv);
692         numTeamMembers++;
693 
694         return true;
695     }
696 
697     function getTeamVault(address _wallet) constant public returns (address) {
698         require(_wallet != address(0));
699         return teamMembers[_wallet].vault;
700     }
701 
702     function finalization() internal {
703         if (goalReached()) {
704             bool capReached = tokenSold >= cap;
705             if (!capReached) {
706                 uint256 tokenUnsold = cap.sub(tokenSold);
707                 // Mint unsold tokens to sale's address & burn them immediately
708                 require(token.mint(this, tokenUnsold));
709                 StampifyToken(token).burn(tokenUnsold);
710             }
711           
712             uint256 tokenReserved = RESERVE_AMOUNT;
713           
714             for (uint8 i = 0; i < numTeamMembers; i++) {
715                 TeamMember memory member = teamMembers[memberLookup[i]];
716                 if (member.vault != address(0)) {
717                     var tokenAmount = tokenSold.div(member.shareDiv);
718                     require(token.mint(member.vault, tokenAmount));
719                     tokenReserved = tokenReserved.sub(tokenAmount);
720                 }
721             }
722 
723             // Allocate remaining reserve to multisig wallet
724             require(token.mint(wallet, tokenReserved));
725 
726             // Finish token minting & unpause transfers
727             require(token.finishMinting());
728             StampifyToken(token).unpause();
729         }
730 
731         super.finalization();
732     }
733 
734     function bytesToBytes32(bytes memory source) returns (bytes32 result) {
735         if (source.length == 0) {
736             return 0x0;
737         }
738 
739         assembly {
740             result := mload(add(source, 32))
741         }
742     }
743 }