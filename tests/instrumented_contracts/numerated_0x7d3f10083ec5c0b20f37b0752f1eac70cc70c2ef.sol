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
267     require(msg.sender == saleAgent && !mintingFinished);
268     totalSupply = totalSupply.add(_amount);
269     balances[_to] = balances[_to].add(_amount);
270     Mint(_to, _amount);
271     return true;
272   }
273 
274   /**
275    * @dev Function to stop minting new tokens.
276    * @return True if the operation was successful.
277    */
278   function finishMinting() public returns (bool) {
279     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
280     mintingFinished = true;
281     MintFinished();
282     return true;
283   }
284 
285   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
286     return super.transfer(_to, _value);
287   }
288 
289   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
290     return super.transferFrom(from, to, value);
291   }
292 
293 }
294 
295 // File: contracts/FABAToken.sol
296 
297 contract FABAToken is MintableToken {
298 
299   string public constant name = "FABA";
300 
301   string public constant symbol = "FABA";
302 
303   uint32 public constant decimals = 18;
304 
305 }
306 
307 // File: contracts/PercentRateProvider.sol
308 
309 contract PercentRateProvider is Ownable {
310 
311   uint public percentRate = 100;
312 
313   function setPercentRate(uint newPercentRate) public onlyOwner {
314     percentRate = newPercentRate;
315   }
316 
317 }
318 
319 // File: contracts/CommonSale.sol
320 
321 contract CommonSale is PercentRateProvider {
322 
323   using SafeMath for uint;
324 
325   address public wallet;
326 
327   address public directMintAgent;
328 
329   uint public price;
330 
331   uint public start;
332 
333   uint public minInvestedLimit;
334 
335   FABAToken public token;
336 
337   uint public hardcap;
338 
339   uint public invested;
340 
341   modifier isUnderHardcap() {
342     require(invested < hardcap);
343     _;
344   }
345 
346   function setHardcap(uint newHardcap) public onlyOwner {
347     hardcap = newHardcap;
348   }
349 
350   modifier onlyDirectMintAgentOrOwner() {
351     require(directMintAgent == msg.sender || owner == msg.sender);
352     _;
353   }
354 
355   modifier minInvestLimited(uint value) {
356     require(value >= minInvestedLimit);
357     _;
358   }
359 
360   function setStart(uint newStart) public onlyOwner {
361     start = newStart;
362   }
363 
364   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
365     minInvestedLimit = newMinInvestedLimit;
366   }
367 
368   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
369     directMintAgent = newDirectMintAgent;
370   }
371 
372   function setWallet(address newWallet) public onlyOwner {
373     wallet = newWallet;
374   }
375 
376   function setPrice(uint newPrice) public onlyOwner {
377     price = newPrice;
378   }
379 
380   function setToken(address newToken) public onlyOwner {
381     token = FABAToken(newToken);
382   }
383 
384   function calculateTokens(uint _invested) internal returns(uint);
385 
386   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
387     mintTokens(to, tokens);
388   }
389 
390   function mintTokens(address to, uint tokens) internal {
391     token.mint(this, tokens);
392     token.transfer(to, tokens);
393   }
394 
395   function endSaleDate() public view returns(uint);
396 
397   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
398     return mintTokensByETH(to, _invested);
399   }
400 
401   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
402     invested = invested.add(_invested);
403     uint tokens = calculateTokens(_invested);
404     mintTokens(to, tokens);
405     return tokens;
406   }
407 
408   function fallback() internal minInvestLimited(msg.value) returns(uint) {
409     require(now >= start && now < endSaleDate());
410     wallet.transfer(msg.value);
411     return mintTokensByETH(msg.sender, msg.value);
412   }
413 
414   function () public payable {
415     fallback();
416   }
417 
418 }
419 
420 // File: contracts/InputAddressFeature.sol
421 
422 contract InputAddressFeature {
423 
424   function bytesToAddress(bytes source) internal pure returns(address) {
425     uint result;
426     uint mul = 1;
427     for(uint i = 20; i > 0; i--) {
428       result += uint8(source[i-1])*mul;
429       mul = mul*256;
430     }
431     return address(result);
432   }
433 
434   function getInputAddress() internal pure returns(address) {
435     if(msg.data.length == 20) {
436       return bytesToAddress(bytes(msg.data));
437     }
438     return address(0);
439   }
440 
441 }
442 
443 // File: contracts/ReferersRewardFeature.sol
444 
445 contract ReferersRewardFeature is InputAddressFeature, CommonSale {
446 
447   uint public refererPercent;
448 
449   uint public referalsMinInvestLimit;
450 
451   function setReferalsMinInvestLimit(uint newRefereralsMinInvestLimit) public onlyOwner {
452     referalsMinInvestLimit = newRefereralsMinInvestLimit;
453   }
454 
455   function setRefererPercent(uint newRefererPercent) public onlyOwner {
456     refererPercent = newRefererPercent;
457   }
458 
459   function fallback() internal returns(uint) {
460     uint tokens = super.fallback();
461     if(msg.value >= referalsMinInvestLimit) {
462       address referer = getInputAddress();
463       if(referer != address(0)) {
464         require(referer != address(token) && referer != msg.sender && referer != address(this));
465         mintTokens(referer, tokens.mul(refererPercent).div(percentRate));
466       }
467     }
468     return tokens;
469   }
470 
471 }
472 
473 // File: contracts/RetrieveTokensFeature.sol
474 
475 contract RetrieveTokensFeature is Ownable {
476 
477   function retrieveTokens(address to, address anotherToken) public onlyOwner {
478     ERC20 alienToken = ERC20(anotherToken);
479     alienToken.transfer(to, alienToken.balanceOf(this));
480   }
481 
482 }
483 
484 // File: contracts/ValueBonusFeature.sol
485 
486 contract ValueBonusFeature is PercentRateProvider {
487 
488   using SafeMath for uint;
489 
490   struct ValueBonus {
491     uint from;
492     uint bonus;
493   }
494 
495   ValueBonus[] public valueBonuses;
496 
497   function addValueBonus(uint from, uint bonus) public onlyOwner {
498     valueBonuses.push(ValueBonus(from, bonus));
499   }
500 
501   function getValueBonusTokens(uint tokens, uint _invested) public view returns(uint) {
502     uint valueBonus = getValueBonus(_invested);
503     if(valueBonus == 0) {
504       return 0;
505     }
506     return tokens.mul(valueBonus).div(percentRate);
507   }
508 
509   function getValueBonus(uint value) public view returns(uint) {
510     uint bonus = 0;
511     for(uint i = 0; i < valueBonuses.length; i++) {
512       if(value >= valueBonuses[i].from) {
513         bonus = valueBonuses[i].bonus;
514       } else {
515         return bonus;
516       }
517     }
518     return bonus;
519   }
520 
521 }
522 
523 // File: contracts/FABACommonSale.sol
524 
525 contract FABACommonSale is ValueBonusFeature, RetrieveTokensFeature, ReferersRewardFeature {
526 
527 
528 }
529 
530 // File: contracts/StagedCrowdsale.sol
531 
532 contract StagedCrowdsale is Ownable {
533 
534   using SafeMath for uint;
535 
536   struct Milestone {
537     uint period;
538     uint bonus;
539   }
540 
541   uint public totalPeriod;
542 
543   Milestone[] public milestones;
544 
545   function milestonesCount() public view returns(uint) {
546     return milestones.length;
547   }
548 
549   function addMilestone(uint period, uint bonus) public onlyOwner {
550     require(period > 0);
551     milestones.push(Milestone(period, bonus));
552     totalPeriod = totalPeriod.add(period);
553   }
554 
555   function removeMilestone(uint8 number) public onlyOwner {
556     require(number < milestones.length);
557     Milestone storage milestone = milestones[number];
558     totalPeriod = totalPeriod.sub(milestone.period);
559 
560     delete milestones[number];
561 
562     for (uint i = number; i < milestones.length - 1; i++) {
563       milestones[i] = milestones[i+1];
564     }
565 
566     milestones.length--;
567   }
568 
569   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
570     require(number < milestones.length);
571     Milestone storage milestone = milestones[number];
572 
573     totalPeriod = totalPeriod.sub(milestone.period);
574 
575     milestone.period = period;
576     milestone.bonus = bonus;
577 
578     totalPeriod = totalPeriod.add(period);
579   }
580 
581   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
582     require(numberAfter < milestones.length);
583 
584     totalPeriod = totalPeriod.add(period);
585 
586     milestones.length++;
587 
588     for (uint i = milestones.length - 2; i > numberAfter; i--) {
589       milestones[i + 1] = milestones[i];
590     }
591 
592     milestones[numberAfter + 1] = Milestone(period, bonus);
593   }
594 
595   function clearMilestones() public onlyOwner {
596     require(milestones.length > 0);
597     for (uint i = 0; i < milestones.length; i++) {
598       delete milestones[i];
599     }
600     milestones.length -= milestones.length;
601     totalPeriod = 0;
602   }
603 
604   function lastSaleDate(uint start) public view returns(uint) {
605     return start + totalPeriod * 1 days;
606   }
607 
608   function currentMilestone(uint start) public view returns(uint) {
609     uint previousDate = start;
610     for(uint i=0; i < milestones.length; i++) {
611       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
612         return i;
613       }
614       previousDate = previousDate.add(milestones[i].period * 1 days);
615     }
616     revert();
617   }
618 
619 }
620 
621 // File: contracts/Mainsale.sol
622 
623 contract Mainsale is StagedCrowdsale, FABACommonSale {
624 
625   address public FABAcompanyTokensWallet;
626   
627   address public SoftwareTokensWallet;
628   
629   address public ReservesForExchangeTokensWallet;
630  
631   address public MentorsTokensWallet;
632 
633   address public bountyTokensWallet;
634 
635   uint public FABAcompanyTokensPercent;
636   
637   uint public SoftwareTokensPercent;
638   
639   uint public ReservesForExchangeTokensPercent;
640   
641   uint public bountyTokensPercent;
642   
643   uint public MentorsTokensPercent;
644   
645   
646    function setSoftwareTokensPercent(uint newSoftwareTokensPercent) public onlyOwner {
647    SoftwareTokensPercent = newSoftwareTokensPercent;
648   }
649    function setReservesForExchangeTokensPercent(uint newReservesForExchangeTokensPercent) public onlyOwner {
650    ReservesForExchangeTokensPercent = newReservesForExchangeTokensPercent;
651   }
652    
653   
654   function setFABAcompanyTokensPercent(uint newFABAcompanyTokensPercent) public onlyOwner {
655     FABAcompanyTokensPercent = newFABAcompanyTokensPercent;
656   }
657   function setMentorsTokensPercent(uint newMentorsTokensPercent) public onlyOwner {
658     MentorsTokensPercent = newMentorsTokensPercent;
659   }
660 
661  function setSoftwareTokensWallet(address newSoftwareTokensWallet) public onlyOwner {
662     SoftwareTokensWallet = newSoftwareTokensWallet;
663   }
664   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
665     bountyTokensPercent = newBountyTokensPercent;
666   }
667  
668   function setFABAcompanyTokensWallet(address newFABAcompanyTokensWallet) public onlyOwner {
669     FABAcompanyTokensWallet = newFABAcompanyTokensWallet;
670   }
671 
672  function setReservesForExchangeTokensWallet(address newReservesForExchangeTokensWallet) public onlyOwner {
673    ReservesForExchangeTokensWallet = newReservesForExchangeTokensWallet;
674   }
675   
676 
677   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
678     bountyTokensWallet = newBountyTokensWallet;
679   }
680   function setMentorsTokensWallet(address newMentorsTokensWallet) public onlyOwner {
681     MentorsTokensWallet = newMentorsTokensWallet;
682   }
683 
684   function calculateTokens(uint _invested) internal returns(uint) {
685     uint milestoneIndex = currentMilestone(start);
686     Milestone storage milestone = milestones[milestoneIndex];
687     uint tokens = _invested.mul(price).div(1 ether);
688     uint valueBonusTokens = getValueBonusTokens(tokens, _invested);
689     if(milestone.bonus > 0) {
690       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
691     }
692     return tokens.add(valueBonusTokens);
693   }
694 
695   function finish() public onlyOwner {
696     uint summaryTokensPercent = bountyTokensPercent.add(FABAcompanyTokensPercent).add(MentorsTokensPercent).add(ReservesForExchangeTokensPercent).add(SoftwareTokensPercent);
697     uint mintedTokens = token.totalSupply();
698     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
699     uint SoftwareTokens = allTokens.mul(SoftwareTokensPercent).div(percentRate);
700     uint FABAcompanyTokens = allTokens.mul(FABAcompanyTokensPercent).div(percentRate);
701     uint ReservesForExchangeTokens = allTokens.mul(ReservesForExchangeTokensPercent).div(percentRate);
702     uint MentorsTokens = allTokens.mul(MentorsTokensPercent).div(percentRate);
703     uint bountyTokens = allTokens.mul(bountyTokensPercent).div(percentRate);
704     mintTokens(ReservesForExchangeTokensWallet, ReservesForExchangeTokens);
705     mintTokens(FABAcompanyTokensWallet, FABAcompanyTokens);
706     mintTokens(SoftwareTokensWallet, SoftwareTokens);
707     mintTokens(bountyTokensWallet, bountyTokens);
708     mintTokens(MentorsTokensWallet, MentorsTokens);
709     token.finishMinting();
710   }
711 
712   function endSaleDate() public view returns(uint) {
713     return lastSaleDate(start);
714   }
715 
716 }
717 
718 // File: contracts/Presale.sol
719 
720 contract Presale is FABACommonSale {
721 
722   Mainsale public mainsale;
723 
724   uint public period;
725 
726   function calculateTokens(uint _invested) internal returns(uint) {
727     uint tokens = _invested.mul(price).div(1 ether);
728     return tokens.add(getValueBonusTokens(tokens, _invested));
729   }
730 
731   function setPeriod(uint newPeriod) public onlyOwner {
732     period = newPeriod;
733   }
734 
735   function setMainsale(address newMainsale) public onlyOwner {
736     mainsale = Mainsale(newMainsale);
737   }
738 
739   function finish() public onlyOwner {
740     token.setSaleAgent(mainsale);
741   }
742 
743   function endSaleDate() public view returns(uint) {
744     return start.add(period * 1 days);
745   }
746 
747 }
748 
749 // File: contracts/Configurator.sol
750 
751 contract Configurator is Ownable {
752 
753  FABAToken public token;
754 
755   Presale public presale;
756 
757   Mainsale public mainsale;
758 
759   function deploy() public onlyOwner {
760     //owner = 0x83Af3226ca6d215F31dC0Baa0D969C06A1E5db3b;
761 
762     token = new FABAToken();
763 
764     presale = new Presale();
765 
766     presale.setWallet(0x83Af3226ca6d215F31dC0Baa0D969C06A1E5db3b);
767     presale.setStart(1524009600);
768     presale.setPeriod(14);
769     presale.setPrice(730000000000000000000);
770     presale.setHardcap(600000000000000000000);
771     token.setSaleAgent(presale);
772     commonConfigure(presale, token);
773 
774     mainsale = new Mainsale();
775 
776     mainsale.addMilestone(14,20);
777     mainsale.addMilestone(14,10);
778     mainsale.addMilestone(14,0);
779 	
780   
781       
782     mainsale.setPrice(520000000000000000000);
783     mainsale.setWallet(0x83Af3226ca6d215F31dC0Baa0D969C06A1E5db3b);
784     mainsale.setReservesForExchangeTokensWallet(0x83Af3226ca6d215F31dC0Baa0D969C06A1E5db3b);
785     mainsale.setFABAcompanyTokensWallet(0x96E187bdD7d817275aD45688BF85CD966A80A428);
786     mainsale.setBountyTokensWallet(0x83Af3226ca6d215F31dC0Baa0D969C06A1E5db3b);
787     mainsale.setMentorsTokensWallet(0x66CeD6f10d77ae5F8dd7811824EF71ebC0c8aEFf);
788     mainsale.setSoftwareTokensWallet(0x83Af3226ca6d215F31dC0Baa0D969C06A1E5db3b);
789     mainsale.setStart(1525219200);
790     mainsale.setHardcap(173000000000000000000000);
791    
792     mainsale.setReservesForExchangeTokensPercent(2);
793     mainsale.setFABAcompanyTokensPercent(20);
794     mainsale.setMentorsTokensPercent(10);
795     mainsale.setBountyTokensPercent(5);
796     mainsale.setSoftwareTokensPercent(1);
797     commonConfigure(mainsale, token);
798 	
799     presale.setMainsale(mainsale);
800 
801     token.transferOwnership(owner);
802     presale.transferOwnership(owner);
803     mainsale.transferOwnership(owner);
804   }
805 
806   function commonConfigure(address saleAddress, address _token) internal {
807      FABACommonSale  sale = FABACommonSale (saleAddress);
808      sale.addValueBonus(1000000000000000000,0);
809      sale.setReferalsMinInvestLimit(500000000000000000);
810      sale.setRefererPercent(15);
811      sale.setMinInvestedLimit(500000000000000000);
812      sale.setToken(_token);
813   }
814 
815 }
816 //Token owners will be paid a share of profits from the sale of stakes in the invested companies. Profits will be paid in ETH.
817 //Tokens will be distributed within 8 weeks after ICO