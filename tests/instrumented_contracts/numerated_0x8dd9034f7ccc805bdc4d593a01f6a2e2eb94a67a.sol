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
47 // File: contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts/token/BasicToken.sol
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
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: contracts/token/StandardToken.sol
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
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: contracts/MintableToken.sol
245 
246 contract MintableToken is StandardToken, Ownable {
247 
248   event Mint(address indexed to, uint256 amount);
249 
250   event MintFinished();
251 
252   bool public mintingFinished = false;
253 
254   address public saleAgent;
255 
256   modifier notLocked() {
257     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
258     _;
259   }
260 
261   function setSaleAgent(address newSaleAgnet) public {
262     require(msg.sender == saleAgent || msg.sender == owner);
263     saleAgent = newSaleAgnet;
264   }
265 
266   function mint(address _to, uint256 _amount) public returns (bool) {
267     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
268     
269     totalSupply = totalSupply.add(_amount);
270     balances[_to] = balances[_to].add(_amount);
271     Mint(_to, _amount);
272     return true;
273   }
274 
275   /**
276    * @dev Function to stop minting new tokens.
277    * @return True if the operation was successful.
278    */
279   function finishMinting() public returns (bool) {
280     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
281     mintingFinished = true;
282     MintFinished();
283     return true;
284   }
285 
286   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
287     return super.transfer(_to, _value);
288   }
289 
290   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
291     return super.transferFrom(from, to, value);
292   }
293 
294 }
295 
296 // File: contracts/FreezeTokensWallet.sol
297 
298 contract FreezeTokensWallet is Ownable {
299 
300   using SafeMath for uint256;
301 
302   MintableToken public token;
303 
304   bool public started;
305 
306   uint public startLockPeriod = 180 days;
307 
308   uint public period = 360 days;
309 
310   uint public duration = 90 days;
311 
312   uint public startUnlock;
313 
314   uint public retrievedTokens;
315 
316   uint public startBalance;
317 
318   modifier notStarted() {
319     require(!started);
320     _;
321   }
322 
323   function setPeriod(uint newPeriod) public onlyOwner notStarted {
324     period = newPeriod * 1 days;
325   }
326 
327   function setDuration(uint newDuration) public onlyOwner notStarted {
328     duration = newDuration * 1 days;
329   }
330 
331   function setStartLockPeriod(uint newStartLockPeriod) public onlyOwner notStarted {
332     startLockPeriod = newStartLockPeriod * 1 days;
333   }
334 
335   function setToken(address newToken) public onlyOwner notStarted {
336     token = MintableToken(newToken);
337   }
338 
339   function start() public onlyOwner notStarted {
340     startUnlock = now + startLockPeriod;
341     retrievedTokens = 0;
342     startBalance = token.balanceOf(this);
343     started = true;
344   }
345 
346   function retrieveTokens(address to) public onlyOwner {
347     require(started && now >= startUnlock);
348     if (now >= startUnlock + period) {
349       token.transfer(to, token.balanceOf(this));
350     } else {
351       uint parts = period.div(duration);
352       uint tokensByPart = startBalance.div(parts);
353       uint timeSinceStart = now.sub(startUnlock);
354       uint pastParts = timeSinceStart.div(duration);
355       uint tokensToRetrieveSinceStart = pastParts.mul(tokensByPart);
356       uint tokensToRetrieve = tokensToRetrieveSinceStart.sub(retrievedTokens);
357       if(tokensToRetrieve > 0) {
358         retrievedTokens = retrievedTokens.add(tokensToRetrieve);
359         token.transfer(to, tokensToRetrieve);
360       }
361     }
362   }
363 }
364 
365 // File: contracts/InvestedProvider.sol
366 
367 contract InvestedProvider is Ownable {
368 
369   uint public invested;
370 
371 }
372 
373 // File: contracts/PercentRateProvider.sol
374 
375 contract PercentRateProvider is Ownable {
376 
377   uint public percentRate = 100;
378 
379   function setPercentRate(uint newPercentRate) public onlyOwner {
380     percentRate = newPercentRate;
381   }
382 
383 }
384 
385 // File: contracts/RetrieveTokensFeature.sol
386 
387 contract RetrieveTokensFeature is Ownable {
388 
389   function retrieveTokens(address to, address anotherToken) public onlyOwner {
390     ERC20 alienToken = ERC20(anotherToken);
391     alienToken.transfer(to, alienToken.balanceOf(this));
392   }
393 
394 }
395 
396 // File: contracts/WalletProvider.sol
397 
398 contract WalletProvider is Ownable {
399 
400   address public wallet;
401 
402   function setWallet(address newWallet) public onlyOwner {
403     wallet = newWallet;
404   }
405 
406 }
407 
408 // File: contracts/CommonSale.sol
409 
410 contract CommonSale is InvestedProvider, WalletProvider, PercentRateProvider, RetrieveTokensFeature {
411 
412   using SafeMath for uint;
413 
414   address public directMintAgent;
415 
416   uint public price;
417 
418   uint public start;
419 
420   uint public minInvestedLimit;
421 
422   MintableToken public token;
423 
424   uint public hardcap;
425 
426   modifier isUnderHardcap() {
427     require(invested < hardcap);
428     _;
429   }
430 
431   function setHardcap(uint newHardcap) public onlyOwner {
432     hardcap = newHardcap;
433   }
434 
435   modifier onlyDirectMintAgentOrOwner() {
436     require(directMintAgent == msg.sender || owner == msg.sender);
437     _;
438   }
439 
440   modifier minInvestLimited(uint value) {
441     require(value >= minInvestedLimit);
442     _;
443   }
444 
445   function setStart(uint newStart) public onlyOwner {
446     start = newStart;
447   }
448 
449   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
450     minInvestedLimit = newMinInvestedLimit;
451   }
452 
453   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
454     directMintAgent = newDirectMintAgent;
455   }
456 
457   function setPrice(uint newPrice) public onlyOwner {
458     price = newPrice;
459   }
460 
461   function setToken(address newToken) public onlyOwner {
462     token = MintableToken(newToken);
463   }
464 
465   function calculateTokens(uint _invested) internal returns(uint);
466 
467   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
468     mintTokens(to, tokens);
469   }
470 
471   function mintTokens(address to, uint tokens) internal {
472     token.mint(this, tokens);
473     token.transfer(to, tokens);
474   }
475 
476   function endSaleDate() public view returns(uint);
477 
478   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
479     return mintTokensByETH(to, _invested);
480   }
481 
482   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
483     invested = invested.add(_invested);
484     uint tokens = calculateTokens(_invested);
485     mintTokens(to, tokens);
486     return tokens;
487   }
488 
489   function fallback() internal minInvestLimited(msg.value) returns(uint) {
490     require(now >= start && now < endSaleDate());
491     wallet.transfer(msg.value);
492     return mintTokensByETH(msg.sender, msg.value);
493   }
494 
495   function () public payable {
496     fallback();
497   }
498 
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
765 
766 // File: contracts/NextSaleAgentFeature.sol
767 
768 contract NextSaleAgentFeature is Ownable {
769 
770   address public nextSaleAgent;
771 
772   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
773     nextSaleAgent = newNextSaleAgent;
774   }
775 
776 }
777 
778 // File: contracts/PreICO.sol
779 
780 contract PreICO is NextSaleAgentFeature, CommonSale {
781 
782   uint public period;
783 
784   function calculateTokens(uint _invested) internal returns(uint) {
785     return _invested.mul(price).div(1 ether);
786   }
787 
788   function setPeriod(uint newPeriod) public onlyOwner {
789     period = newPeriod;
790   }
791 
792   function finish() public onlyOwner {
793     token.setSaleAgent(nextSaleAgent);
794   }
795 
796   function endSaleDate() public view returns(uint) {
797     return start.add(period * 1 days);
798   }
799   
800   function fallback() internal minInvestLimited(msg.value) returns(uint) {
801     require(now >= start && now < endSaleDate());
802     wallet.transfer(msg.value);
803     return mintTokensByETH(msg.sender, msg.value);
804   }
805   
806 }
807 
808 // File: contracts/ReceivingContractCallback.sol
809 
810 contract ReceivingContractCallback {
811 
812   function tokenFallback(address _from, uint _value) public;
813 
814 }
815 
816 // File: contracts/UBCoinToken.sol
817 
818 contract UBCoinToken is MintableToken {
819 
820   string public constant name = "UBCoin";
821 
822   string public constant symbol = "UBC";
823 
824   uint32 public constant decimals = 18;
825 
826   mapping(address => bool)  public registeredCallbacks;
827 
828   function transfer(address _to, uint256 _value) public returns (bool) {
829     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
830   }
831 
832   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
833     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
834   }
835 
836   function registerCallback(address callback) public onlyOwner {
837     registeredCallbacks[callback] = true;
838   }
839 
840   function deregisterCallback(address callback) public onlyOwner {
841     registeredCallbacks[callback] = false;
842   }
843 
844   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
845     if (result && registeredCallbacks[to]) {
846       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
847       targetCallback.tokenFallback(from, value);
848     }
849     return result;
850   }
851 
852 }
853 
854 // File: contracts/MigrationConfigurator.sol
855 
856 /**
857  * How to migrate:
858  * 1. deploy
859  * 2. call deploy
860  * 3. token.setSaleAgent(new ito)
861  */
862 contract MigrationConfigurator is Ownable {
863 
864   MintableToken public token = MintableToken(0x2D3E7D4870a51b918919E7B851FE19983E4c38d5);
865 
866   ICO public ico;
867 
868   FreezeTokensWallet public teamTokensWallet;
869 
870   function setToken(address newAddress) public onlyOwner {
871     token = MintableToken(newAddress);
872   }
873 
874   function deploy() public onlyOwner {
875     ico = new ICO();
876 
877     ico.addMilestone(20, 40);
878     ico.addMilestone(20, 25);
879     ico.addMilestone(20, 20);
880     ico.addMilestone(20, 15);
881     ico.addMilestone(20, 8);
882     ico.addMilestone(4, 0);
883     ico.addValueBonus(20000000000000000000,50);
884     ico.addValueBonus(50000000000000000000,65);
885     ico.addValueBonus(300000000000000000000,80);
886     ico.setMinInvestedLimit(100000000000000000);
887     ico.setToken(token);
888     ico.setPrice(14286000000000000000000);
889     ico.setWallet(0x5FB78D8B8f1161731BC80eF93CBcfccc5783356F);
890     ico.setBountyTokensWallet(0xdAA156b6eA6b9737eA20c68Db4040B1182E487B6);
891     ico.setReservedTokensWallet(0xE1D1898660469797B22D348Ff67d54643d848295);
892     ico.setStart(1522627200); // 02 Apr 2018 00:00:00 GMT
893     ico.setHardcap(96000000000000000000000);
894     ico.setTeamTokensPercent(12);
895     ico.setBountyTokensPercent(4);
896     ico.setReservedTokensPercent(34);
897 
898     teamTokensWallet = new FreezeTokensWallet();
899     teamTokensWallet.setStartLockPeriod(180);
900     teamTokensWallet.setPeriod(360);
901     teamTokensWallet.setDuration(90);
902     teamTokensWallet.setToken(token);
903     teamTokensWallet.transferOwnership(ico);
904 
905     ico.setTeamTokensWallet(teamTokensWallet);
906 
907     address manager = 0xF1f94bAD54C8827C3B53754ad7dAa0FF5DCD527d;
908 
909     ico.transferOwnership(manager);
910   }
911 
912 }