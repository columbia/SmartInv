1 pragma solidity 0.4.18;
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
47 // File: contracts/NextSaleAgentFeature.sol
48 
49 contract NextSaleAgentFeature is Ownable {
50 
51   address public nextSaleAgent;
52 
53   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
54     nextSaleAgent = newNextSaleAgent;
55   }
56 
57 }
58 
59 // File: contracts/DevWallet.sol
60 
61 contract DevWallet {
62 
63   uint public date = 1525255200;
64   uint public limit = 4500000000000000000;
65   address public wallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
66 
67   function withdraw() public {
68     require(now >= date);
69     wallet.transfer(this.balance);
70   }
71 
72   function () public payable {}
73 
74 }
75 
76 // File: contracts/PercentRateProvider.sol
77 
78 contract PercentRateProvider is Ownable {
79 
80   uint public percentRate = 100;
81 
82   function setPercentRate(uint newPercentRate) public onlyOwner {
83     percentRate = newPercentRate;
84   }
85 
86 }
87 
88 // File: contracts/math/SafeMath.sol
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     if (a == 0) {
97       return 0;
98     }
99     uint256 c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 // File: contracts/token/ERC20Basic.sol
124 
125 /**
126  * @title ERC20Basic
127  * @dev Simpler version of ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/179
129  */
130 contract ERC20Basic {
131   uint256 public totalSupply;
132   function balanceOf(address who) public view returns (uint256);
133   function transfer(address to, uint256 value) public returns (bool);
134   event Transfer(address indexed from, address indexed to, uint256 value);
135 }
136 
137 // File: contracts/token/BasicToken.sol
138 
139 /**
140  * @title Basic token
141  * @dev Basic version of StandardToken, with no allowances.
142  */
143 contract BasicToken is ERC20Basic {
144   using SafeMath for uint256;
145 
146   mapping(address => uint256) balances;
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[msg.sender]);
156 
157     // SafeMath.sub will throw if there is not enough balance.
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) public view returns (uint256 balance) {
170     return balances[_owner];
171   }
172 
173 }
174 
175 // File: contracts/token/ERC20.sol
176 
177 /**
178  * @title ERC20 interface
179  * @dev see https://github.com/ethereum/EIPs/issues/20
180  */
181 contract ERC20 is ERC20Basic {
182   function allowance(address owner, address spender) public view returns (uint256);
183   function transferFrom(address from, address to, uint256 value) public returns (bool);
184   function approve(address spender, uint256 value) public returns (bool);
185   event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 // File: contracts/token/StandardToken.sol
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/ethereum/EIPs/issues/20
195  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[_from]);
211     require(_value <= allowed[_from][msg.sender]);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 // File: contracts/MintableToken.sol
286 
287 contract MintableToken is StandardToken, Ownable {
288 
289   event Mint(address indexed to, uint256 amount);
290 
291   event MintFinished();
292 
293   bool public mintingFinished = false;
294 
295   address public saleAgent;
296 
297   function setSaleAgent(address newSaleAgnet) public {
298     require(msg.sender == saleAgent || msg.sender == owner);
299     saleAgent = newSaleAgnet;
300   }
301 
302   function mint(address _to, uint256 _amount) public returns (bool) {
303     require(msg.sender == saleAgent && !mintingFinished);
304     totalSupply = totalSupply.add(_amount);
305     balances[_to] = balances[_to].add(_amount);
306     Mint(_to, _amount);
307     return true;
308   }
309 
310   /**
311    * @dev Function to stop minting new tokens.
312    * @return True if the operation was successful.
313    */
314   function finishMinting() public returns (bool) {
315     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
316     mintingFinished = true;
317     MintFinished();
318     return true;
319   }
320 
321 }
322 
323 // File: contracts/REPUToken.sol
324 
325 contract REPUToken is MintableToken {
326 
327   string public constant name = 'REPU';
328 
329   string public constant symbol = 'REPU';
330 
331   uint32 public constant decimals = 18;
332 
333 }
334 
335 // File: contracts/CommonSale.sol
336 
337 contract CommonSale is PercentRateProvider {
338 
339   using SafeMath for uint;
340 
341   address public wallet;
342 
343   address public directMintAgent;
344 
345   uint public price;
346 
347   uint public start;
348 
349   uint public minInvestedLimit;
350 
351   REPUToken public token;
352 
353   DevWallet public devWallet;
354 
355   bool public devWalletLocked;
356 
357   uint public hardcap;
358 
359   uint public invested;
360 
361   modifier isUnderHardcap() {
362     require(invested < hardcap);
363     _;
364   }
365 
366   function setHardcap(uint newHardcap) public onlyOwner {
367     hardcap = newHardcap;
368   }
369 
370   modifier onlyDirectMintAgentOrOwner() {
371     require(directMintAgent == msg.sender || owner == msg.sender);
372     _;
373   }
374 
375   modifier minInvestLimited(uint value) {
376     require(value >= minInvestedLimit);
377     _;
378   }
379 
380   function setStart(uint newStart) public onlyOwner {
381     start = newStart;
382   }
383 
384   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
385     minInvestedLimit = newMinInvestedLimit;
386   }
387 
388   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
389     directMintAgent = newDirectMintAgent;
390   }
391 
392   function setWallet(address newWallet) public onlyOwner {
393     wallet = newWallet;
394   }
395 
396   function setPrice(uint newPrice) public onlyOwner {
397     price = newPrice;
398   }
399 
400   function setToken(address newToken) public onlyOwner {
401     token = REPUToken(newToken);
402   }
403 
404   function setDevWallet(address newDevWallet) public onlyOwner {
405     require(!devWalletLocked);
406     devWallet = DevWallet(newDevWallet);
407     devWalletLocked = true;
408   }
409 
410   function calculateTokens(uint _invested) internal returns(uint);
411 
412   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
413     mintTokens(to, tokens);
414   }
415 
416   function mintTokens(address to, uint tokens) internal {
417     token.mint(this, tokens);
418     token.transfer(to, tokens);
419   }
420 
421   function endSaleDate() public view returns(uint);
422 
423   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
424     return mintTokensByETH(to, _invested);
425   }
426 
427   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
428     invested = invested.add(_invested);
429     uint tokens = calculateTokens(_invested);
430     mintTokens(to, tokens);
431     return tokens;
432   }
433 
434   function devWithdraw() internal {
435     uint received = devWallet.balance;
436     uint limit = devWallet.limit();
437     if (received < limit) {
438       uint shouldSend = limit.sub(received);
439       uint value;
440       if (msg.value < shouldSend) {
441         value = msg.value;
442       } else {
443         value = shouldSend;
444       }
445       devWallet.transfer(value);
446     }
447   }
448 
449   function fallback() internal minInvestLimited(msg.value) returns(uint) {
450     require(now >= start && now < endSaleDate());
451     if (devWallet != address(0)) {
452       devWithdraw();
453     }
454     wallet.transfer(this.balance);
455     return mintTokensByETH(msg.sender, msg.value);
456   }
457 
458   function () public payable {
459     fallback();
460   }
461 
462 }
463 
464 // File: contracts/RetrieveTokensFeature.sol
465 
466 contract RetrieveTokensFeature is Ownable {
467 
468   function retrieveTokens(address to, address anotherToken) public onlyOwner {
469     ERC20 alienToken = ERC20(anotherToken);
470     alienToken.transfer(to, alienToken.balanceOf(this));
471   }
472 
473 }
474 
475 // File: contracts/ValueBonusFeature.sol
476 
477 contract ValueBonusFeature is PercentRateProvider {
478 
479   using SafeMath for uint;
480 
481   struct ValueBonus {
482     uint from;
483     uint bonus;
484   }
485 
486   ValueBonus[] public valueBonuses;
487 
488   function addValueBonus(uint from, uint bonus) public onlyOwner {
489     valueBonuses.push(ValueBonus(from, bonus));
490   }
491 
492   function getValueBonusTokens(uint tokens, uint _invested) public view returns(uint) {
493     uint valueBonus = getValueBonus(_invested);
494     if (valueBonus == 0) {
495       return 0;
496     }
497     return tokens.mul(valueBonus).div(percentRate);
498   }
499 
500   function getValueBonus(uint value) public view returns(uint) {
501     uint bonus = 0;
502     for (uint i = 0; i < valueBonuses.length; i++) {
503       if (value >= valueBonuses[i].from) {
504         bonus = valueBonuses[i].bonus;
505       } else {
506         return bonus;
507       }
508     }
509     return bonus;
510   }
511 
512 }
513 
514 // File: contracts/REPUCommonSale.sol
515 
516 contract REPUCommonSale is ValueBonusFeature, RetrieveTokensFeature, CommonSale {
517 
518 
519 }
520 
521 // File: contracts/StagedCrowdsale.sol
522 
523 contract StagedCrowdsale is Ownable {
524 
525   using SafeMath for uint;
526 
527   struct Milestone {
528     uint period;
529     uint bonus;
530   }
531 
532   uint public totalPeriod;
533 
534   Milestone[] public milestones;
535 
536   function milestonesCount() public view returns(uint) {
537     return milestones.length;
538   }
539 
540   function addMilestone(uint period, uint bonus) public onlyOwner {
541     require(period > 0);
542     milestones.push(Milestone(period, bonus));
543     totalPeriod = totalPeriod.add(period);
544   }
545 
546   function removeMilestone(uint8 number) public onlyOwner {
547     require(number < milestones.length);
548     Milestone storage milestone = milestones[number];
549     totalPeriod = totalPeriod.sub(milestone.period);
550 
551     delete milestones[number];
552 
553     for (uint i = number; i < milestones.length - 1; i++) {
554       milestones[i] = milestones[i+1];
555     }
556 
557     milestones.length--;
558   }
559 
560   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
561     require(number < milestones.length);
562     Milestone storage milestone = milestones[number];
563 
564     totalPeriod = totalPeriod.sub(milestone.period);
565 
566     milestone.period = period;
567     milestone.bonus = bonus;
568 
569     totalPeriod = totalPeriod.add(period);
570   }
571 
572   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
573     require(numberAfter < milestones.length);
574 
575     totalPeriod = totalPeriod.add(period);
576 
577     milestones.length++;
578 
579     for (uint i = milestones.length - 2; i > numberAfter; i--) {
580       milestones[i + 1] = milestones[i];
581     }
582 
583     milestones[numberAfter + 1] = Milestone(period, bonus);
584   }
585 
586   function clearMilestones() public onlyOwner {
587     require(milestones.length > 0);
588     for (uint i = 0; i < milestones.length; i++) {
589       delete milestones[i];
590     }
591     milestones.length -= milestones.length;
592     totalPeriod = 0;
593   }
594 
595   function lastSaleDate(uint start) public view returns(uint) {
596     return start + totalPeriod * 1 days;
597   }
598 
599   function currentMilestone(uint start) public view returns(uint) {
600     uint previousDate = start;
601     for (uint i = 0; i < milestones.length; i++) {
602       if (now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
603         return i;
604       }
605       previousDate = previousDate.add(milestones[i].period * 1 days);
606     }
607     revert();
608   }
609 
610 }
611 
612 // File: contracts/Mainsale.sol
613 
614 contract Mainsale is StagedCrowdsale, REPUCommonSale {
615 
616   address public foundersTokensWallet;
617 
618   address public advisorsTokensWallet;
619 
620   address public bountyTokensWallet;
621 
622   address public lotteryTokensWallet;
623 
624   uint public foundersTokensPercent;
625 
626   uint public advisorsTokensPercent;
627 
628   uint public bountyTokensPercent;
629 
630   uint public lotteryTokensPercent;
631 
632   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
633     foundersTokensPercent = newFoundersTokensPercent;
634   }
635 
636   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner {
637     advisorsTokensPercent = newAdvisorsTokensPercent;
638   }
639 
640   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
641     bountyTokensPercent = newBountyTokensPercent;
642   }
643 
644   function setLotteryTokensPercent(uint newLotteryTokensPercent) public onlyOwner {
645     lotteryTokensPercent = newLotteryTokensPercent;
646   }
647 
648   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
649     foundersTokensWallet = newFoundersTokensWallet;
650   }
651 
652   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner {
653     advisorsTokensWallet = newAdvisorsTokensWallet;
654   }
655 
656   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
657     bountyTokensWallet = newBountyTokensWallet;
658   }
659 
660   function setLotteryTokensWallet(address newLotteryTokensWallet) public onlyOwner {
661     lotteryTokensWallet = newLotteryTokensWallet;
662   }
663 
664   function calculateTokens(uint _invested) internal returns(uint) {
665     uint milestoneIndex = currentMilestone(start);
666     Milestone storage milestone = milestones[milestoneIndex];
667     uint tokens = _invested.mul(price).div(1 ether);
668     uint valueBonusTokens = getValueBonusTokens(tokens, _invested);
669     if (milestone.bonus > 0) {
670       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
671     }
672     return tokens.add(valueBonusTokens);
673   }
674 
675   function finish() public onlyOwner {
676     uint summaryTokensPercent = bountyTokensPercent.add(foundersTokensPercent).add(advisorsTokensPercent).add(lotteryTokensPercent);
677     uint mintedTokens = token.totalSupply();
678     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
679     uint foundersTokens = allTokens.mul(foundersTokensPercent).div(percentRate);
680     uint advisorsTokens = allTokens.mul(advisorsTokensPercent).div(percentRate);
681     uint bountyTokens = allTokens.mul(bountyTokensPercent).div(percentRate);
682     uint lotteryTokens = allTokens.mul(lotteryTokensPercent).div(percentRate);
683     mintTokens(foundersTokensWallet, foundersTokens);
684     mintTokens(advisorsTokensWallet, advisorsTokens);
685     mintTokens(bountyTokensWallet, bountyTokens);
686     mintTokens(lotteryTokensWallet, lotteryTokens);
687     token.finishMinting();
688   }
689 
690   function endSaleDate() public view returns(uint) {
691     return lastSaleDate(start);
692   }
693 
694 }
695 
696 // File: contracts/Presale.sol
697 
698 contract Presale is NextSaleAgentFeature, StagedCrowdsale, REPUCommonSale {
699 
700   function calculateTokens(uint _invested) internal returns(uint) {
701     uint milestoneIndex = currentMilestone(start);
702     Milestone storage milestone = milestones[milestoneIndex];
703     uint tokens = _invested.mul(price).div(1 ether);
704     uint valueBonusTokens = getValueBonusTokens(tokens, _invested);
705     if (milestone.bonus > 0) {
706       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
707     }
708     return tokens.add(valueBonusTokens);
709   }
710 
711   function finish() public onlyOwner {
712     token.setSaleAgent(nextSaleAgent);
713   }
714 
715   function endSaleDate() public view returns(uint) {
716     return lastSaleDate(start);
717   }
718 
719 }
720 
721 // File: contracts/ClosedRound.sol
722 
723 contract ClosedRound is NextSaleAgentFeature, REPUCommonSale {
724 
725   uint public maxLimit; 
726 
727   uint public end;
728 
729   function calculateTokens(uint _invested) internal returns(uint) {
730     uint tokens = _invested.mul(price).div(1 ether);
731     return tokens.add(getValueBonusTokens(tokens, _invested));
732   }
733 
734   function setMaxLimit(uint newMaxLimit) public onlyOwner {
735     maxLimit = newMaxLimit;
736   }
737 
738   function setEnd(uint newEnd) public onlyOwner {
739     end = newEnd;
740   }
741 
742   function finish() public onlyOwner {
743     token.setSaleAgent(nextSaleAgent);
744   }
745 
746   function fallback() internal returns(uint) {
747     require(msg.value <= maxLimit);
748     return super.fallback();
749   }
750 
751   function endSaleDate() public view returns(uint) {
752     return end;
753   }
754 
755 }
756 
757 // File: contracts/Configurator.sol
758 
759 contract Configurator is Ownable {
760 
761   REPUToken public token;
762 
763   ClosedRound public closedRound;
764 
765   Presale public presale;
766 
767   Mainsale public mainsale;
768 
769   DevWallet public devWallet;
770 
771   function deploy() public onlyOwner {
772     token = new REPUToken();
773     closedRound = new ClosedRound();
774     presale = new Presale();
775     mainsale = new Mainsale();
776     devWallet = new DevWallet();
777     
778     token.transferOwnership(owner);
779     presale.transferOwnership(owner);
780     mainsale.transferOwnership(owner);
781  }
782 
783 }