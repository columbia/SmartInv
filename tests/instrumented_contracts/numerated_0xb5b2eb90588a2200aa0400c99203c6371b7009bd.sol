1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ownership/Ownable.sol
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
47 // File: contracts/InvestedProvider.sol
48 
49 contract InvestedProvider is Ownable {
50 
51   uint public invested;
52 
53 }
54 
55 // File: contracts/math/SafeMath.sol
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63     if (a == 0) {
64       return 0;
65     }
66     uint256 c = a * b;
67     assert(c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 // File: contracts/token/ERC20Basic.sol
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   uint256 public totalSupply;
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 // File: contracts/token/BasicToken.sol
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[msg.sender]);
123 
124     // SafeMath.sub will throw if there is not enough balance.
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     Transfer(msg.sender, _to, _value);
128     return true;
129   }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param _owner The address to query the the balance of.
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136   function balanceOf(address _owner) public view returns (uint256 balance) {
137     return balances[_owner];
138   }
139 
140 }
141 
142 // File: contracts/token/ERC20.sol
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 // File: contracts/token/StandardToken.sol
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 // File: contracts/MintableToken.sol
253 
254 contract MintableToken is StandardToken, Ownable {
255 
256   event Mint(address indexed to, uint256 amount);
257 
258   event MintFinished();
259 
260   bool public mintingFinished = false;
261 
262   address public saleAgent;
263 
264   modifier notLocked() {
265     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
266     _;
267   }
268 
269   function setSaleAgent(address newSaleAgnet) public {
270     require(msg.sender == saleAgent || msg.sender == owner);
271     saleAgent = newSaleAgnet;
272   }
273 
274   function mint(address _to, uint256 _amount) public returns (bool) {
275     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
276     
277     totalSupply = totalSupply.add(_amount);
278     balances[_to] = balances[_to].add(_amount);
279     Mint(_to, _amount);
280     return true;
281   }
282 
283   /**
284    * @dev Function to stop minting new tokens.
285    * @return True if the operation was successful.
286    */
287   function finishMinting() public returns (bool) {
288     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
289     mintingFinished = true;
290     MintFinished();
291     return true;
292   }
293 
294   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
295     return super.transfer(_to, _value);
296   }
297 
298   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
299     return super.transferFrom(from, to, value);
300   }
301 
302 }
303 
304 // File: contracts/PercentRateProvider.sol
305 
306 contract PercentRateProvider is Ownable {
307 
308   uint public percentRate = 100;
309 
310   function setPercentRate(uint newPercentRate) public onlyOwner {
311     percentRate = newPercentRate;
312   }
313 
314 }
315 
316 // File: contracts/RetrieveTokensFeature.sol
317 
318 contract RetrieveTokensFeature is Ownable {
319 
320   function retrieveTokens(address to, address anotherToken) public onlyOwner {
321     ERC20 alienToken = ERC20(anotherToken);
322     alienToken.transfer(to, alienToken.balanceOf(this));
323   }
324 
325 }
326 
327 // File: contracts/WalletProvider.sol
328 
329 contract WalletProvider is Ownable {
330 
331   address public wallet;
332 
333   function setWallet(address newWallet) public onlyOwner {
334     wallet = newWallet;
335   }
336 
337 }
338 
339 // File: contracts/CommonSale.sol
340 
341 contract CommonSale is InvestedProvider, WalletProvider, PercentRateProvider, RetrieveTokensFeature {
342 
343   using SafeMath for uint;
344 
345   address public directMintAgent;
346 
347   uint public price;
348 
349   uint public start;
350 
351   uint public minInvestedLimit;
352 
353   MintableToken public token;
354 
355   uint public hardcap;
356 
357   modifier isUnderHardcap() {
358     require(invested < hardcap);
359     _;
360   }
361 
362   function setHardcap(uint newHardcap) public onlyOwner {
363     hardcap = newHardcap;
364   }
365 
366   modifier onlyDirectMintAgentOrOwner() {
367     require(directMintAgent == msg.sender || owner == msg.sender);
368     _;
369   }
370 
371   modifier minInvestLimited(uint value) {
372     require(value >= minInvestedLimit);
373     _;
374   }
375 
376   function setStart(uint newStart) public onlyOwner {
377     start = newStart;
378   }
379 
380   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
381     minInvestedLimit = newMinInvestedLimit;
382   }
383 
384   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
385     directMintAgent = newDirectMintAgent;
386   }
387 
388   function setPrice(uint newPrice) public onlyOwner {
389     price = newPrice;
390   }
391 
392   function setToken(address newToken) public onlyOwner {
393     token = MintableToken(newToken);
394   }
395 
396   function calculateTokens(uint _invested) internal returns(uint);
397 
398   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
399     mintTokens(to, tokens);
400   }
401 
402   function mintTokens(address to, uint tokens) internal {
403     token.mint(this, tokens);
404     token.transfer(to, tokens);
405   }
406 
407   function endSaleDate() public view returns(uint);
408 
409   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
410     return mintTokensByETH(to, _invested);
411   }
412 
413   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
414     invested = invested.add(_invested);
415     uint tokens = calculateTokens(_invested);
416     mintTokens(to, tokens);
417     return tokens;
418   }
419 
420   function fallback() internal minInvestLimited(msg.value) returns(uint) {
421     require(now >= start && now < endSaleDate());
422     wallet.transfer(msg.value);
423     return mintTokensByETH(msg.sender, msg.value);
424   }
425 
426   function () public payable {
427     fallback();
428   }
429 
430 }
431 
432 // File: contracts/FreezeTokensWallet.sol
433 
434 contract FreezeTokensWallet is Ownable {
435 
436   using SafeMath for uint256;
437 
438   MintableToken public token;
439 
440   bool public started;
441 
442   uint public startLockPeriod = 180 days;
443 
444   uint public period = 360 days;
445 
446   uint public duration = 90 days;
447 
448   uint public startUnlock;
449 
450   uint public retrievedTokens;
451 
452   uint public startBalance;
453 
454   modifier notStarted() {
455     require(!started);
456     _;
457   }
458 
459   function setPeriod(uint newPeriod) public onlyOwner notStarted {
460     period = newPeriod * 1 days;
461   }
462 
463   function setDuration(uint newDuration) public onlyOwner notStarted {
464     duration = newDuration * 1 days;
465   }
466 
467   function setStartLockPeriod(uint newStartLockPeriod) public onlyOwner notStarted {
468     startLockPeriod = newStartLockPeriod * 1 days;
469   }
470 
471   function setToken(address newToken) public onlyOwner notStarted {
472     token = MintableToken(newToken);
473   }
474 
475   function start() public onlyOwner notStarted {
476     startUnlock = now + startLockPeriod;
477     retrievedTokens = 0;
478     startBalance = token.balanceOf(this);
479     started = true;
480   }
481 
482   function retrieveTokens(address to) public onlyOwner {
483     require(started && now >= startUnlock);
484     if (now >= startUnlock + period) {
485       token.transfer(to, token.balanceOf(this));
486     } else {
487       uint parts = period.div(duration);
488       uint tokensByPart = startBalance.div(parts);
489       uint timeSinceStart = now.sub(startUnlock);
490       uint pastParts = timeSinceStart.div(duration);
491       uint tokensToRetrieveSinceStart = pastParts.mul(tokensByPart);
492       uint tokensToRetrieve = tokensToRetrieveSinceStart.sub(retrievedTokens);
493       if(tokensToRetrieve > 0) {
494         retrievedTokens = retrievedTokens.add(tokensToRetrieve);
495         token.transfer(to, tokensToRetrieve);
496       }
497     }
498   }
499 }
500 
501 // File: contracts/StagedCrowdsale.sol
502 
503 contract StagedCrowdsale is Ownable {
504 
505   using SafeMath for uint;
506 
507   struct Milestone {
508     uint period;
509     uint bonus;
510   }
511 
512   uint public totalPeriod;
513 
514   Milestone[] public milestones;
515 
516   function milestonesCount() public view returns(uint) {
517     return milestones.length;
518   }
519 
520   function addMilestone(uint period, uint bonus) public onlyOwner {
521     require(period > 0);
522     milestones.push(Milestone(period, bonus));
523     totalPeriod = totalPeriod.add(period);
524   }
525 
526   function removeMilestone(uint8 number) public onlyOwner {
527     require(number < milestones.length);
528     Milestone storage milestone = milestones[number];
529     totalPeriod = totalPeriod.sub(milestone.period);
530 
531     delete milestones[number];
532 
533     for (uint i = number; i < milestones.length - 1; i++) {
534       milestones[i] = milestones[i+1];
535     }
536 
537     milestones.length--;
538   }
539 
540   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
541     require(number < milestones.length);
542     Milestone storage milestone = milestones[number];
543 
544     totalPeriod = totalPeriod.sub(milestone.period);
545 
546     milestone.period = period;
547     milestone.bonus = bonus;
548 
549     totalPeriod = totalPeriod.add(period);
550   }
551 
552   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
553     require(numberAfter < milestones.length);
554 
555     totalPeriod = totalPeriod.add(period);
556 
557     milestones.length++;
558 
559     for (uint i = milestones.length - 2; i > numberAfter; i--) {
560       milestones[i + 1] = milestones[i];
561     }
562 
563     milestones[numberAfter + 1] = Milestone(period, bonus);
564   }
565 
566   function clearMilestones() public onlyOwner {
567     require(milestones.length > 0);
568     for (uint i = 0; i < milestones.length; i++) {
569       delete milestones[i];
570     }
571     milestones.length -= milestones.length;
572     totalPeriod = 0;
573   }
574 
575   function lastSaleDate(uint start) public view returns(uint) {
576     return start + totalPeriod * 1 days;
577   }
578 
579   function currentMilestone(uint start) public view returns(uint) {
580     uint previousDate = start;
581     for(uint i=0; i < milestones.length; i++) {
582       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
583         return i;
584       }
585       previousDate = previousDate.add(milestones[i].period * 1 days);
586     }
587     revert();
588   }
589 
590 }
591 
592 // File: contracts/ValueBonusFeature.sol
593 
594 contract ValueBonusFeature is PercentRateProvider {
595 
596   using SafeMath for uint;
597 
598   bool public activeValueBonus = true;
599 
600   struct ValueBonus {
601     uint from;
602     uint bonus;
603   }
604 
605   ValueBonus[] public valueBonuses;
606 
607   modifier checkPrevBonus(uint number, uint from, uint bonus) {
608     if(number > 0 && number < valueBonuses.length) {
609       ValueBonus storage valueBonus = valueBonuses[number - 1];
610       require(valueBonus.from < from && valueBonus.bonus < bonus);
611     }
612     _;
613   }
614 
615   modifier checkNextBonus(uint number, uint from, uint bonus) {
616     if(number + 1 < valueBonuses.length) {
617       ValueBonus storage valueBonus = valueBonuses[number + 1];
618       require(valueBonus.from > from && valueBonus.bonus > bonus);
619     }
620     _;
621   }
622 
623   function setActiveValueBonus(bool newActiveValueBonus) public onlyOwner {
624     activeValueBonus = newActiveValueBonus;
625   }
626 
627   function addValueBonus(uint from, uint bonus) public onlyOwner checkPrevBonus(valueBonuses.length - 1, from, bonus) {
628     valueBonuses.push(ValueBonus(from, bonus));
629   }
630 
631   function getValueBonusTokens(uint tokens, uint invested) public view returns(uint) {
632     uint valueBonus = getValueBonus(invested);
633     if(valueBonus == 0) {
634       return 0;
635     }
636     return tokens.mul(valueBonus).div(percentRate);
637   }
638 
639   function getValueBonus(uint value) public view returns(uint) {
640     uint bonus = 0;
641     if(activeValueBonus) {
642       for(uint i = 0; i < valueBonuses.length; i++) {
643         if(value >= valueBonuses[i].from) {
644           bonus = valueBonuses[i].bonus;
645         } else {
646           return bonus;
647         }
648       }
649     }
650     return bonus;
651   }
652 
653   function removeValueBonus(uint8 number) public onlyOwner {
654     require(number < valueBonuses.length);
655 
656     delete valueBonuses[number];
657 
658     for (uint i = number; i < valueBonuses.length - 1; i++) {
659       valueBonuses[i] = valueBonuses[i+1];
660     }
661 
662     valueBonuses.length--;
663   }
664 
665   function changeValueBonus(uint8 number, uint from, uint bonus) public onlyOwner checkPrevBonus(number, from, bonus) checkNextBonus(number, from, bonus) {
666     require(number < valueBonuses.length);
667     ValueBonus storage valueBonus = valueBonuses[number];
668     valueBonus.from = from;
669     valueBonus.bonus = bonus;
670   }
671 
672   function insertValueBonus(uint8 numberAfter, uint from, uint bonus) public onlyOwner checkPrevBonus(numberAfter, from, bonus) checkNextBonus(numberAfter, from, bonus) {
673     require(numberAfter < valueBonuses.length);
674 
675     valueBonuses.length++;
676 
677     for (uint i = valueBonuses.length - 2; i > numberAfter; i--) {
678       valueBonuses[i + 1] = valueBonuses[i];
679     }
680 
681     valueBonuses[numberAfter + 1] = ValueBonus(from, bonus);
682   }
683 
684   function clearValueBonuses() public onlyOwner {
685     require(valueBonuses.length > 0);
686     for (uint i = 0; i < valueBonuses.length; i++) {
687       delete valueBonuses[i];
688     }
689     valueBonuses.length = 0;
690   }
691 
692 }
693 
694 // File: contracts/ICO.sol
695 
696 contract ICO is ValueBonusFeature, StagedCrowdsale, CommonSale {
697 
698   FreezeTokensWallet public teamTokensWallet;
699 
700   address public bountyTokensWallet;
701 
702   address public reservedTokensWallet;
703 
704   uint public teamTokensPercent;
705 
706   uint public bountyTokensPercent;
707 
708   uint public reservedTokensPercent;
709 
710   function setTeamTokensPercent(uint newTeamTokensPercent) public onlyOwner {
711     teamTokensPercent = newTeamTokensPercent;
712   }
713 
714   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
715     bountyTokensPercent = newBountyTokensPercent;
716   }
717 
718   function setReservedTokensPercent(uint newReservedTokensPercent) public onlyOwner {
719     reservedTokensPercent = newReservedTokensPercent;
720   }
721 
722   function setTeamTokensWallet(address newTeamTokensWallet) public onlyOwner {
723     teamTokensWallet = FreezeTokensWallet(newTeamTokensWallet);
724   }
725 
726   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
727     bountyTokensWallet = newBountyTokensWallet;
728   }
729 
730   function setReservedTokensWallet(address newReservedTokensWallet) public onlyOwner {
731     reservedTokensWallet = newReservedTokensWallet;
732   }
733 
734   function calculateTokens(uint _invested) internal returns(uint) {
735     uint milestoneIndex = currentMilestone(start);
736     Milestone storage milestone = milestones[milestoneIndex];
737     uint tokens = _invested.mul(price).div(1 ether);
738     uint valueBonusTokens = getValueBonusTokens(tokens, _invested);
739     if(milestone.bonus > 0) {
740       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
741     }
742     return tokens.add(valueBonusTokens);
743   }
744 
745   function finish() public onlyOwner {
746     uint summaryTokensPercent = bountyTokensPercent.add(teamTokensPercent).add(reservedTokensPercent);
747     uint mintedTokens = token.totalSupply();
748     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
749     uint foundersTokens = allTokens.mul(teamTokensPercent).div(percentRate);
750     uint bountyTokens = allTokens.mul(bountyTokensPercent).div(percentRate);
751     uint reservedTokens = allTokens.mul(reservedTokensPercent).div(percentRate);
752     mintTokens(teamTokensWallet, foundersTokens);
753     mintTokens(bountyTokensWallet, bountyTokens);
754     mintTokens(reservedTokensWallet, reservedTokens);
755     token.finishMinting();
756     teamTokensWallet.start();
757     teamTokensWallet.transferOwnership(owner);
758   }
759 
760   function endSaleDate() public view returns(uint) {
761     return lastSaleDate(start);
762   }
763 
764 }