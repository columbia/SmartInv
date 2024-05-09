1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
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
45 contract ReceivingContractCallback {
46 
47   function tokenFallback(address _from, uint _value) public;
48 
49 }
50 
51 
52 contract RetrieveTokensFeature is Ownable {
53 
54   function retrieveTokens(address to, address anotherToken) public onlyOwner {
55     ERC20 alienToken = ERC20(anotherToken);
56     alienToken.transfer(to, alienToken.balanceOf(this));
57   }
58 
59 }
60 
61 
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69     if (a == 0) {
70       return 0;
71     }
72     uint256 c = a * b;
73     assert(c / a == b);
74     return c;
75   }
76 
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return c;
82   }
83 
84   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85     assert(b <= a);
86     return a - b;
87   }
88 
89   function add(uint256 a, uint256 b) internal pure returns (uint256) {
90     uint256 c = a + b;
91     assert(c >= a);
92     return c;
93   }
94 }
95 
96 
97 /**
98  * @title ERC20Basic
99  * @dev Simpler version of ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/179
101  */
102 contract ERC20Basic {
103   uint256 public totalSupply;
104   function balanceOf(address who) public view returns (uint256);
105   function transfer(address to, uint256 value) public returns (bool);
106   event Transfer(address indexed from, address indexed to, uint256 value);
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     // SafeMath.sub will throw if there is not enough balance.
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
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
210   function allowance(address _owner, address _spender) public view returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    *
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To decrement
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _subtractedValue The amount of tokens to decrease the allowance by.
239    */
240   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241     uint oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251 }
252 
253 contract MintableToken is StandardToken, Ownable {
254 
255   event Mint(address indexed to, uint256 amount);
256 
257   event MintFinished();
258 
259   bool public mintingFinished = false;
260 
261   address public saleAgent;
262 
263   address public unlockedAddress;
264 
265   function setUnlockedAddress(address newUnlockedAddress) public onlyOwner {
266     unlockedAddress = newUnlockedAddress;
267   }
268 
269   modifier notLocked() {
270     require(msg.sender == owner || msg.sender == saleAgent || msg.sender == unlockedAddress || mintingFinished);
271     _;
272   }
273 
274   function setSaleAgent(address newSaleAgnet) public {
275     require(msg.sender == saleAgent || msg.sender == owner);
276     saleAgent = newSaleAgnet;
277   }
278 
279   function mint(address _to, uint256 _amount) public returns (bool) {
280     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
281     
282     totalSupply = totalSupply.add(_amount);
283     balances[_to] = balances[_to].add(_amount);
284     Mint(_to, _amount);
285     return true;
286   }
287 
288   /**
289    * @dev Function to stop minting new tokens.
290    * @return True if the operation was successful.
291    */
292   function finishMinting() public returns (bool) {
293     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
294     mintingFinished = true;
295     MintFinished();
296     return true;
297   }
298 
299   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
300     return super.transfer(_to, _value);
301   }
302 
303   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
304     return super.transferFrom(from, to, value);
305   }
306 
307 }
308 
309 
310 contract NextSaleAgentFeature is Ownable {
311 
312   address public nextSaleAgent;
313 
314   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
315     nextSaleAgent = newNextSaleAgent;
316   }
317 
318 }
319 
320 contract PercentRateProvider is Ownable {
321 
322   uint public percentRate = 100;
323 
324   function setPercentRate(uint newPercentRate) public onlyOwner {
325     percentRate = newPercentRate;
326   }
327 
328 }
329 
330 
331 contract WalletProvider is Ownable {
332 
333   address public wallet;
334 
335   function setWallet(address newWallet) public onlyOwner {
336     wallet = newWallet;
337   }
338 
339 }
340 
341 
342 
343 contract InputAddressFeature {
344 
345   function bytesToAddress(bytes source) internal pure returns(address) {
346     uint result;
347     uint mul = 1;
348     for(uint i = 20; i > 0; i--) {
349       result += uint8(source[i-1])*mul;
350       mul = mul*256;
351     }
352     return address(result);
353   }
354 
355   function getInputAddress() internal pure returns(address) {
356     if(msg.data.length == 20) {
357       return bytesToAddress(bytes(msg.data));
358     }
359     return address(0);
360   }
361 
362 }
363 
364 contract InvestedProvider is Ownable {
365 
366   uint public invested;
367 
368 }
369 
370 
371 contract StagedCrowdsale is Ownable {
372 
373   using SafeMath for uint;
374 
375   struct Milestone {
376     uint period;
377     uint bonus;
378   }
379 
380   uint public totalPeriod;
381 
382   Milestone[] public milestones;
383 
384   function milestonesCount() public view returns(uint) {
385     return milestones.length;
386   }
387 
388   function addMilestone(uint period, uint bonus) public onlyOwner {
389     require(period > 0);
390     milestones.push(Milestone(period, bonus));
391     totalPeriod = totalPeriod.add(period);
392   }
393 
394   function removeMilestone(uint8 number) public onlyOwner {
395     require(number < milestones.length);
396     Milestone storage milestone = milestones[number];
397     totalPeriod = totalPeriod.sub(milestone.period);
398 
399     delete milestones[number];
400 
401     for (uint i = number; i < milestones.length - 1; i++) {
402       milestones[i] = milestones[i+1];
403     }
404 
405     milestones.length--;
406   }
407 
408   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
409     require(number < milestones.length);
410     Milestone storage milestone = milestones[number];
411 
412     totalPeriod = totalPeriod.sub(milestone.period);
413 
414     milestone.period = period;
415     milestone.bonus = bonus;
416 
417     totalPeriod = totalPeriod.add(period);
418   }
419 
420   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
421     require(numberAfter < milestones.length);
422 
423     totalPeriod = totalPeriod.add(period);
424 
425     milestones.length++;
426 
427     for (uint i = milestones.length - 2; i > numberAfter; i--) {
428       milestones[i + 1] = milestones[i];
429     }
430 
431     milestones[numberAfter + 1] = Milestone(period, bonus);
432   }
433 
434   function clearMilestones() public onlyOwner {
435     require(milestones.length > 0);
436     for (uint i = 0; i < milestones.length; i++) {
437       delete milestones[i];
438     }
439     milestones.length -= milestones.length;
440     totalPeriod = 0;
441   }
442 
443   function lastSaleDate(uint start) public view returns(uint) {
444     return start + totalPeriod * 1 days;
445   }
446 
447   function currentMilestone(uint start) public view returns(uint) {
448     uint previousDate = start;
449     for(uint i=0; i < milestones.length; i++) {
450       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
451         return i;
452       }
453       previousDate = previousDate.add(milestones[i].period * 1 days);
454     }
455     revert();
456   }
457 
458 }
459 
460 contract CommonSale is InvestedProvider, WalletProvider, PercentRateProvider, RetrieveTokensFeature {
461 
462   using SafeMath for uint;
463 
464   address public directMintAgent;
465 
466   uint public price;
467 
468   uint public start;
469 
470   uint public minInvestedLimit;
471 
472   MintableToken public token;
473 
474   uint public hardcap;
475 
476   modifier isUnderHardcap() {
477     require(invested < hardcap);
478     _;
479   }
480 
481   function setHardcap(uint newHardcap) public onlyOwner {
482     hardcap = newHardcap;
483   }
484 
485   modifier onlyDirectMintAgentOrOwner() {
486     require(directMintAgent == msg.sender || owner == msg.sender);
487     _;
488   }
489 
490   modifier minInvestLimited(uint value) {
491     require(value >= minInvestedLimit);
492     _;
493   }
494 
495   function setStart(uint newStart) public onlyOwner {
496     start = newStart;
497   }
498 
499   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
500     minInvestedLimit = newMinInvestedLimit;
501   }
502 
503   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
504     directMintAgent = newDirectMintAgent;
505   }
506 
507   function setPrice(uint newPrice) public onlyOwner {
508     price = newPrice;
509   }
510 
511   function setToken(address newToken) public onlyOwner {
512     token = MintableToken(newToken);
513   }
514 
515   function calculateTokens(uint _invested) internal returns(uint);
516 
517   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
518     mintTokens(to, tokens);
519   }
520 
521   function mintTokens(address to, uint tokens) internal {
522     token.mint(this, tokens);
523     token.transfer(to, tokens);
524   }
525 
526   function endSaleDate() public view returns(uint);
527 
528   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
529     return mintTokensByETH(to, _invested);
530   }
531 
532   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
533     invested = invested.add(_invested);
534     uint tokens = calculateTokens(_invested);
535     mintTokens(to, tokens);
536     return tokens;
537   }
538 
539   function fallback() internal minInvestLimited(msg.value) returns(uint) {
540     require(now >= start && now < endSaleDate());
541     wallet.transfer(msg.value);
542     return mintTokensByETH(msg.sender, msg.value);
543   }
544 
545   function () public payable {
546     fallback();
547   }
548 
549 }
550 
551 
552 contract ReferersRewardFeature is InputAddressFeature, CommonSale {
553 
554   uint public refererPercent;
555 
556   uint public referalsMinInvestLimit;
557 
558   function setReferalsMinInvestLimit(uint newRefereralsMinInvestLimit) public onlyOwner {
559     referalsMinInvestLimit = newRefereralsMinInvestLimit;
560   }
561 
562   function setRefererPercent(uint newRefererPercent) public onlyOwner {
563     refererPercent = newRefererPercent;
564   }
565 
566   function fallback() internal returns(uint) {
567     uint tokens = super.fallback();
568     if(msg.value >= referalsMinInvestLimit) {
569       address referer = getInputAddress();
570       if(referer != address(0)) {
571         require(referer != address(token) && referer != msg.sender && referer != address(this));
572         mintTokens(referer, tokens.mul(refererPercent).div(percentRate));
573       }
574     }
575     return tokens;
576   }
577 
578 }
579 
580 contract ReferersCommonSale is RetrieveTokensFeature, ReferersRewardFeature {
581 
582 
583 }
584 
585 
586 contract AssembledCommonSale is StagedCrowdsale, ReferersCommonSale {
587 
588   function calculateTokens(uint _invested) internal returns(uint) {
589     uint milestoneIndex = currentMilestone(start);
590     Milestone storage milestone = milestones[milestoneIndex];
591     uint tokens = _invested.mul(price).div(1 ether);
592     if(milestone.bonus > 0) {
593       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
594     }
595     return tokens;
596   }
597 
598   function endSaleDate() public view returns(uint) {
599     return lastSaleDate(start);
600   }
601 
602 }
603 
604 contract CallbackTest is ReceivingContractCallback {
605   
606   address public from;
607   uint public value;
608   
609   function tokenFallback(address _from, uint _value) public
610   {
611     from = _from;
612     value = _value;
613   }
614 
615 }
616 
617 contract SoftcapFeature is InvestedProvider, WalletProvider {
618 
619   using SafeMath for uint;
620 
621   mapping(address => uint) public balances;
622 
623   bool public softcapAchieved;
624 
625   bool public refundOn;
626 
627   uint public softcap;
628 
629   uint public constant devLimit = 4500000000000000000;
630 
631   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
632 
633   function setSoftcap(uint newSoftcap) public onlyOwner {
634     softcap = newSoftcap;
635   }
636 
637   function withdraw() public {
638     require(msg.sender == owner || msg.sender == devWallet);
639     require(softcapAchieved);
640     devWallet.transfer(devLimit);
641     wallet.transfer(this.balance);
642   }
643 
644   function updateBalance(address to, uint amount) internal {
645     balances[to] = balances[to].add(amount);
646     if (!softcapAchieved && invested >= softcap) {
647       softcapAchieved = true;
648     }
649   }
650 
651   function refund() public {
652     require(refundOn && balances[msg.sender] > 0);
653     uint value = balances[msg.sender];
654     balances[msg.sender] = 0;
655     msg.sender.transfer(value);
656   }
657 
658   function updateRefundState() internal returns(bool) {
659     if (!softcapAchieved) {
660       refundOn = true;
661     }
662     return refundOn;
663   }
664 
665 }
666 
667 
668 
669 
670 contract Configurator is Ownable {
671 
672   MintableToken public token;
673 
674   PreITO public preITO;
675 
676   ITO public ito;
677 
678   function deploy() public onlyOwner {
679 
680     token = new GeseToken();
681 
682     preITO = new PreITO();
683 
684     preITO.setWallet(0xa86780383E35De330918D8e4195D671140A60A74);
685     preITO.setStart(1526342400);
686     preITO.setPeriod(15);
687     preITO.setPrice(786700);
688     preITO.setMinInvestedLimit(100000000000000000);
689     preITO.setHardcap(3818000000000000000000);
690     preITO.setSoftcap(3640000000000000000000);
691     preITO.setReferalsMinInvestLimit(100000000000000000);
692     preITO.setRefererPercent(5);
693     preITO.setToken(token);
694 
695     token.setSaleAgent(preITO);
696 
697     ito = new ITO();
698 
699     ito.setWallet(0x98882D176234AEb736bbBDB173a8D24794A3b085);
700     ito.setStart(1527811200);
701     ito.addMilestone(5, 33);
702     ito.addMilestone(5, 18);
703     ito.addMilestone(5, 11);
704     ito.addMilestone(5, 5);
705     ito.addMilestone(10, 0);
706     ito.setPrice(550000);
707     ito.setMinInvestedLimit(100000000000000000);
708     ito.setHardcap(49090000000000000000000);
709     ito.setBountyTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
710     ito.setAdvisorsTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
711     ito.setTeamTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
712     ito.setReservedTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
713     ito.setBountyTokensPercent(5);
714     ito.setAdvisorsTokensPercent(10);
715     ito.setTeamTokensPercent(10);
716     ito.setReservedTokensPercent(10);
717     ito.setReferalsMinInvestLimit(100000000000000000);
718     ito.setRefererPercent(5);
719     ito.setToken(token);
720 
721     preITO.setNextSaleAgent(ito);
722 
723     address manager = 0x675eDE27cafc8Bd07bFCDa6fEF6ac25031c74766;
724 
725     token.transferOwnership(manager);
726     preITO.transferOwnership(manager);
727     ito.transferOwnership(manager);
728   }
729 
730 }
731 
732 contract ERC20Cutted {
733     
734   function balanceOf(address who) public constant returns (uint256);
735   
736   function transfer(address to, uint256 value) public returns (bool);
737   
738 }
739 
740 contract GeseToken is MintableToken {
741 
742   string public constant name = "Gese";
743 
744   string public constant symbol = "GSE";
745 
746   uint32 public constant decimals = 2;
747 
748   mapping(address => bool)  public registeredCallbacks;
749 
750   function transfer(address _to, uint256 _value) public returns (bool) {
751     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
752   }
753 
754   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
755     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
756   }
757 
758   function registerCallback(address callback) public onlyOwner {
759     registeredCallbacks[callback] = true;
760   }
761 
762   function deregisterCallback(address callback) public onlyOwner {
763     registeredCallbacks[callback] = false;
764   }
765 
766   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
767     if (result && registeredCallbacks[to]) {
768       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
769       targetCallback.tokenFallback(from, value);
770     }
771     return result;
772   }
773 
774 }
775 
776 contract ITO is AssembledCommonSale {
777 
778   address public bountyTokensWallet;
779 
780   address public advisorsTokensWallet;
781   
782   address public teamTokensWallet;
783 
784   address public reservedTokensWallet;
785 
786   uint public bountyTokensPercent;
787   
788   uint public advisorsTokensPercent;
789 
790   uint public teamTokensPercent;
791 
792   uint public reservedTokensPercent;
793 
794   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
795     bountyTokensPercent = newBountyTokensPercent;
796   }
797   
798   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner {
799     advisorsTokensPercent = newAdvisorsTokensPercent;
800   }
801 
802   function setTeamTokensPercent(uint newTeamTokensPercent) public onlyOwner {
803     teamTokensPercent = newTeamTokensPercent;
804   }
805 
806   function setReservedTokensPercent(uint newReservedTokensPercent) public onlyOwner {
807     reservedTokensPercent = newReservedTokensPercent;
808   }
809 
810   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
811     bountyTokensWallet = newBountyTokensWallet;
812   }
813 
814   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner {
815     advisorsTokensWallet = newAdvisorsTokensWallet;
816   }
817 
818   function setTeamTokensWallet(address newTeamTokensWallet) public onlyOwner {
819     teamTokensWallet = newTeamTokensWallet;
820   }
821 
822   function setReservedTokensWallet(address newReservedTokensWallet) public onlyOwner {
823     reservedTokensWallet = newReservedTokensWallet;
824   }
825 
826   function finish() public onlyOwner {
827     uint summaryTokensPercent = bountyTokensPercent.add(advisorsTokensPercent).add(teamTokensPercent).add(reservedTokensPercent);
828     uint mintedTokens = token.totalSupply();
829     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
830     uint advisorsTokens = allTokens.mul(advisorsTokensPercent).div(percentRate);
831     uint bountyTokens = allTokens.mul(bountyTokensPercent).div(percentRate);
832     uint teamTokens = allTokens.mul(teamTokensPercent).div(percentRate);
833     uint reservedTokens = allTokens.mul(reservedTokensPercent).div(percentRate);
834     mintTokens(advisorsTokensWallet, advisorsTokens);
835     mintTokens(bountyTokensWallet, bountyTokens);
836     mintTokens(teamTokensWallet, teamTokens);
837     mintTokens(reservedTokensWallet, reservedTokens);
838     token.finishMinting();
839   }
840 
841 }
842 
843 contract PreITO is NextSaleAgentFeature, SoftcapFeature, ReferersCommonSale {
844 
845   uint public period;
846 
847   function calculateTokens(uint _invested) internal returns(uint) {
848     return _invested.mul(price).div(1 ether);
849   }
850 
851   function setPeriod(uint newPeriod) public onlyOwner {
852     period = newPeriod;
853   }
854 
855   function endSaleDate() public view returns(uint) {
856     return start.add(period * 1 days);
857   }
858   
859   function mintTokensByETH(address to, uint _invested) internal returns(uint) {
860     uint _tokens = super.mintTokensByETH(to, _invested);
861     updateBalance(to, _invested);
862     return _tokens;
863   }
864 
865   function finish() public onlyOwner {
866     if (updateRefundState()) {
867       token.finishMinting();
868     } else {
869       withdraw();
870       token.setSaleAgent(nextSaleAgent);
871     }
872   }
873 
874   function fallback() internal minInvestLimited(msg.value) returns(uint) {
875     require(now >= start && now < endSaleDate());
876     uint tokens = mintTokensByETH(msg.sender, msg.value);
877     if(msg.value >= referalsMinInvestLimit) {
878       address referer = getInputAddress();
879       if(referer != address(0)) {
880         require(referer != address(token) && referer != msg.sender && referer != address(this));
881         mintTokens(referer, tokens.mul(refererPercent).div(percentRate));
882       }
883     }
884     return tokens;
885   }
886 
887 }
888 
889 
890 contract TestConfigurator is Ownable {
891   GeseToken public token;
892   PreITO public preITO;
893   ITO public ito;
894 
895   function setToken(address _token) public onlyOwner {
896     token = GeseToken(_token);
897   }
898 
899   function setPreITO(address _preITO) public onlyOwner {
900     preITO = PreITO(_preITO);
901   }
902 
903   function setITO(address _ito) public onlyOwner {
904     ito = ITO(_ito);
905   }
906 
907   function deploy() public onlyOwner {
908     preITO.setWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
909     preITO.setStart(1522108800);
910     preITO.setPeriod(15);
911     preITO.setPrice(786700);
912     preITO.setMinInvestedLimit(100000000000000000);
913     preITO.setHardcap(3818000000000000000000);
914     preITO.setSoftcap(3640000000000000000000);
915     preITO.setReferalsMinInvestLimit(100000000000000000);
916     preITO.setRefererPercent(5);
917     preITO.setToken(token);
918 
919     token.setSaleAgent(preITO);
920     preITO.setNextSaleAgent(ito);
921 
922     ito.setStart(1522108800);
923     ito.addMilestone(5, 33);
924     ito.addMilestone(5, 18);
925     ito.addMilestone(5, 11);
926     ito.addMilestone(5, 5);
927     ito.addMilestone(10, 0);
928     ito.setPrice(550000);
929     ito.setMinInvestedLimit(100000000000000000);
930     ito.setHardcap(49090000000000000000000);
931     ito.setWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
932     ito.setBountyTokensWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
933     ito.setAdvisorsTokensWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
934     ito.setTeamTokensWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
935     ito.setReservedTokensWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
936     ito.setBountyTokensPercent(5);
937     ito.setAdvisorsTokensPercent(10);
938     ito.setTeamTokensPercent(10);
939     ito.setReservedTokensPercent(10);
940     ito.setReferalsMinInvestLimit(100000000000000000);
941     ito.setRefererPercent(5);
942     ito.setToken(token);
943 
944     token.transferOwnership(owner);
945     preITO.transferOwnership(owner);
946     ito.transferOwnership(owner);
947   }
948 }