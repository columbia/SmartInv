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
256   address public unlockedAddress;
257 
258   function setUnlockedAddress(address newUnlockedAddress) public onlyOwner {
259     unlockedAddress = newUnlockedAddress;
260   }
261 
262   modifier notLocked() {
263     require(msg.sender == owner || msg.sender == saleAgent || msg.sender == unlockedAddress || mintingFinished);
264     _;
265   }
266 
267   function setSaleAgent(address newSaleAgnet) public {
268     require(msg.sender == saleAgent || msg.sender == owner);
269     saleAgent = newSaleAgnet;
270   }
271 
272   function mint(address _to, uint256 _amount) public returns (bool) {
273     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
274     
275     totalSupply = totalSupply.add(_amount);
276     balances[_to] = balances[_to].add(_amount);
277     Mint(_to, _amount);
278     return true;
279   }
280 
281   /**
282    * @dev Function to stop minting new tokens.
283    * @return True if the operation was successful.
284    */
285   function finishMinting() public returns (bool) {
286     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
287     mintingFinished = true;
288     MintFinished();
289     return true;
290   }
291 
292   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
293     return super.transfer(_to, _value);
294   }
295 
296   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
297     return super.transferFrom(from, to, value);
298   }
299 
300 }
301 
302 // File: contracts/ReceivingContractCallback.sol
303 
304 contract ReceivingContractCallback {
305 
306   function tokenFallback(address _from, uint _value) public;
307 
308 }
309 
310 // File: contracts/GeseToken.sol
311 
312 contract GeseToken is MintableToken {
313 
314   string public constant name = "Gese";
315 
316   string public constant symbol = "GSE";
317 
318   uint32 public constant decimals = 2;
319 
320   mapping(address => bool)  public registeredCallbacks;
321 
322   function transfer(address _to, uint256 _value) public returns (bool) {
323     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
324   }
325 
326   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
327     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
328   }
329 
330   function registerCallback(address callback) public onlyOwner {
331     registeredCallbacks[callback] = true;
332   }
333 
334   function deregisterCallback(address callback) public onlyOwner {
335     registeredCallbacks[callback] = false;
336   }
337 
338   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
339     if (result && registeredCallbacks[to]) {
340       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
341       targetCallback.tokenFallback(from, value);
342     }
343     return result;
344   }
345 
346 }
347 
348 // File: contracts/InvestedProvider.sol
349 
350 contract InvestedProvider is Ownable {
351 
352   uint public invested;
353 
354 }
355 
356 // File: contracts/PercentRateProvider.sol
357 
358 contract PercentRateProvider is Ownable {
359 
360   uint public percentRate = 100;
361 
362   function setPercentRate(uint newPercentRate) public onlyOwner {
363     percentRate = newPercentRate;
364   }
365 
366 }
367 
368 // File: contracts/RetrieveTokensFeature.sol
369 
370 contract RetrieveTokensFeature is Ownable {
371 
372   function retrieveTokens(address to, address anotherToken) public onlyOwner {
373     ERC20 alienToken = ERC20(anotherToken);
374     alienToken.transfer(to, alienToken.balanceOf(this));
375   }
376 
377 }
378 
379 // File: contracts/WalletProvider.sol
380 
381 contract WalletProvider is Ownable {
382 
383   address public wallet;
384 
385   function setWallet(address newWallet) public onlyOwner {
386     wallet = newWallet;
387   }
388 
389 }
390 
391 // File: contracts/CommonSale.sol
392 
393 contract CommonSale is InvestedProvider, WalletProvider, PercentRateProvider, RetrieveTokensFeature {
394 
395   using SafeMath for uint;
396 
397   address public directMintAgent;
398 
399   uint public price;
400 
401   uint public start;
402 
403   uint public minInvestedLimit;
404 
405   MintableToken public token;
406 
407   uint public hardcap;
408 
409   modifier isUnderHardcap() {
410     require(invested < hardcap);
411     _;
412   }
413 
414   function setHardcap(uint newHardcap) public onlyOwner {
415     hardcap = newHardcap;
416   }
417 
418   modifier onlyDirectMintAgentOrOwner() {
419     require(directMintAgent == msg.sender || owner == msg.sender);
420     _;
421   }
422 
423   modifier minInvestLimited(uint value) {
424     require(value >= minInvestedLimit);
425     _;
426   }
427 
428   function setStart(uint newStart) public onlyOwner {
429     start = newStart;
430   }
431 
432   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
433     minInvestedLimit = newMinInvestedLimit;
434   }
435 
436   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
437     directMintAgent = newDirectMintAgent;
438   }
439 
440   function setPrice(uint newPrice) public onlyOwner {
441     price = newPrice;
442   }
443 
444   function setToken(address newToken) public onlyOwner {
445     token = MintableToken(newToken);
446   }
447 
448   function calculateTokens(uint _invested) internal returns(uint);
449 
450   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
451     mintTokens(to, tokens);
452   }
453 
454   function mintTokens(address to, uint tokens) internal {
455     token.mint(this, tokens);
456     token.transfer(to, tokens);
457   }
458 
459   function endSaleDate() public view returns(uint);
460 
461   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
462     return mintTokensByETH(to, _invested);
463   }
464 
465   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
466     invested = invested.add(_invested);
467     uint tokens = calculateTokens(_invested);
468     mintTokens(to, tokens);
469     return tokens;
470   }
471 
472   function fallback() internal minInvestLimited(msg.value) returns(uint) {
473     require(now >= start && now < endSaleDate());
474     wallet.transfer(msg.value);
475     return mintTokensByETH(msg.sender, msg.value);
476   }
477 
478   function () public payable {
479     fallback();
480   }
481 
482 }
483 
484 // File: contracts/InputAddressFeature.sol
485 
486 contract InputAddressFeature {
487 
488   function bytesToAddress(bytes source) internal pure returns(address) {
489     uint result;
490     uint mul = 1;
491     for(uint i = 20; i > 0; i--) {
492       result += uint8(source[i-1])*mul;
493       mul = mul*256;
494     }
495     return address(result);
496   }
497 
498   function getInputAddress() internal pure returns(address) {
499     if(msg.data.length == 20) {
500       return bytesToAddress(bytes(msg.data));
501     }
502     return address(0);
503   }
504 
505 }
506 
507 // File: contracts/ReferersRewardFeature.sol
508 
509 contract ReferersRewardFeature is InputAddressFeature, CommonSale {
510 
511   uint public refererPercent;
512 
513   uint public referalsMinInvestLimit;
514 
515   function setReferalsMinInvestLimit(uint newRefereralsMinInvestLimit) public onlyOwner {
516     referalsMinInvestLimit = newRefereralsMinInvestLimit;
517   }
518 
519   function setRefererPercent(uint newRefererPercent) public onlyOwner {
520     refererPercent = newRefererPercent;
521   }
522 
523   function fallback() internal returns(uint) {
524     uint tokens = super.fallback();
525     if(msg.value >= referalsMinInvestLimit) {
526       address referer = getInputAddress();
527       if(referer != address(0)) {
528         require(referer != address(token) && referer != msg.sender && referer != address(this));
529         mintTokens(referer, tokens.mul(refererPercent).div(percentRate));
530       }
531     }
532     return tokens;
533   }
534 
535 }
536 
537 // File: contracts/StagedCrowdsale.sol
538 
539 contract StagedCrowdsale is Ownable {
540 
541   using SafeMath for uint;
542 
543   struct Milestone {
544     uint period;
545     uint bonus;
546   }
547 
548   uint public totalPeriod;
549 
550   Milestone[] public milestones;
551 
552   function milestonesCount() public view returns(uint) {
553     return milestones.length;
554   }
555 
556   function addMilestone(uint period, uint bonus) public onlyOwner {
557     require(period > 0);
558     milestones.push(Milestone(period, bonus));
559     totalPeriod = totalPeriod.add(period);
560   }
561 
562   function removeMilestone(uint8 number) public onlyOwner {
563     require(number < milestones.length);
564     Milestone storage milestone = milestones[number];
565     totalPeriod = totalPeriod.sub(milestone.period);
566 
567     delete milestones[number];
568 
569     for (uint i = number; i < milestones.length - 1; i++) {
570       milestones[i] = milestones[i+1];
571     }
572 
573     milestones.length--;
574   }
575 
576   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
577     require(number < milestones.length);
578     Milestone storage milestone = milestones[number];
579 
580     totalPeriod = totalPeriod.sub(milestone.period);
581 
582     milestone.period = period;
583     milestone.bonus = bonus;
584 
585     totalPeriod = totalPeriod.add(period);
586   }
587 
588   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
589     require(numberAfter < milestones.length);
590 
591     totalPeriod = totalPeriod.add(period);
592 
593     milestones.length++;
594 
595     for (uint i = milestones.length - 2; i > numberAfter; i--) {
596       milestones[i + 1] = milestones[i];
597     }
598 
599     milestones[numberAfter + 1] = Milestone(period, bonus);
600   }
601 
602   function clearMilestones() public onlyOwner {
603     require(milestones.length > 0);
604     for (uint i = 0; i < milestones.length; i++) {
605       delete milestones[i];
606     }
607     milestones.length -= milestones.length;
608     totalPeriod = 0;
609   }
610 
611   function lastSaleDate(uint start) public view returns(uint) {
612     return start + totalPeriod * 1 days;
613   }
614 
615   function currentMilestone(uint start) public view returns(uint) {
616     uint previousDate = start;
617     for(uint i=0; i < milestones.length; i++) {
618       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
619         return i;
620       }
621       previousDate = previousDate.add(milestones[i].period * 1 days);
622     }
623     revert();
624   }
625 
626 }
627 
628 // File: contracts/ReferersCommonSale.sol
629 
630 contract ReferersCommonSale is RetrieveTokensFeature, ReferersRewardFeature {
631 
632 
633 }
634 
635 // File: contracts/AssembledCommonSale.sol
636 
637 contract AssembledCommonSale is StagedCrowdsale, ReferersCommonSale {
638 
639   function calculateTokens(uint _invested) internal returns(uint) {
640     uint milestoneIndex = currentMilestone(start);
641     Milestone storage milestone = milestones[milestoneIndex];
642     uint tokens = _invested.mul(price).div(1 ether);
643     if(milestone.bonus > 0) {
644       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
645     }
646     return tokens;
647   }
648 
649   function endSaleDate() public view returns(uint) {
650     return lastSaleDate(start);
651   }
652 
653 }
654 
655 // File: contracts/ITO.sol
656 
657 contract ITO is AssembledCommonSale {
658 
659   address public bountyTokensWallet;
660 
661   address public advisorsTokensWallet;
662   
663   address public teamTokensWallet;
664 
665   address public reservedTokensWallet;
666 
667   uint public bountyTokensPercent;
668   
669   uint public advisorsTokensPercent;
670 
671   uint public teamTokensPercent;
672 
673   uint public reservedTokensPercent;
674 
675   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
676     bountyTokensPercent = newBountyTokensPercent;
677   }
678   
679   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner {
680     advisorsTokensPercent = newAdvisorsTokensPercent;
681   }
682 
683   function setTeamTokensPercent(uint newTeamTokensPercent) public onlyOwner {
684     teamTokensPercent = newTeamTokensPercent;
685   }
686 
687   function setReservedTokensPercent(uint newReservedTokensPercent) public onlyOwner {
688     reservedTokensPercent = newReservedTokensPercent;
689   }
690 
691   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
692     bountyTokensWallet = newBountyTokensWallet;
693   }
694 
695   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner {
696     advisorsTokensWallet = newAdvisorsTokensWallet;
697   }
698 
699   function setTeamTokensWallet(address newTeamTokensWallet) public onlyOwner {
700     teamTokensWallet = newTeamTokensWallet;
701   }
702 
703   function setReservedTokensWallet(address newReservedTokensWallet) public onlyOwner {
704     reservedTokensWallet = newReservedTokensWallet;
705   }
706 
707   function finish() public onlyOwner {
708     uint summaryTokensPercent = bountyTokensPercent.add(advisorsTokensPercent).add(teamTokensPercent).add(reservedTokensPercent);
709     uint mintedTokens = token.totalSupply();
710     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
711     uint advisorsTokens = allTokens.mul(advisorsTokensPercent).div(percentRate);
712     uint bountyTokens = allTokens.mul(bountyTokensPercent).div(percentRate);
713     uint teamTokens = allTokens.mul(teamTokensPercent).div(percentRate);
714     uint reservedTokens = allTokens.mul(reservedTokensPercent).div(percentRate);
715     mintTokens(advisorsTokensWallet, advisorsTokens);
716     mintTokens(bountyTokensWallet, bountyTokens);
717     mintTokens(teamTokensWallet, teamTokens);
718     mintTokens(reservedTokensWallet, reservedTokens);
719     token.finishMinting();
720   }
721 
722 }
723 
724 // File: contracts/NextSaleAgentFeature.sol
725 
726 contract NextSaleAgentFeature is Ownable {
727 
728   address public nextSaleAgent;
729 
730   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
731     nextSaleAgent = newNextSaleAgent;
732   }
733 
734 }
735 
736 // File: contracts/SoftcapFeature.sol
737 
738 contract SoftcapFeature is InvestedProvider, WalletProvider {
739 
740   using SafeMath for uint;
741 
742   mapping(address => uint) public balances;
743 
744   bool public softcapAchieved;
745 
746   bool public refundOn;
747 
748   uint public softcap;
749 
750   uint public constant devLimit = 4500000000000000000;
751 
752   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
753 
754   function setSoftcap(uint newSoftcap) public onlyOwner {
755     softcap = newSoftcap;
756   }
757 
758   function withdraw() public {
759     require(msg.sender == owner || msg.sender == devWallet);
760     require(softcapAchieved);
761     devWallet.transfer(devLimit);
762     wallet.transfer(this.balance);
763   }
764 
765   function updateBalance(address to, uint amount) internal {
766     balances[to] = balances[to].add(amount);
767     if (!softcapAchieved && invested >= softcap) {
768       softcapAchieved = true;
769     }
770   }
771 
772   function refund() public {
773     require(refundOn && balances[msg.sender] > 0);
774     uint value = balances[msg.sender];
775     balances[msg.sender] = 0;
776     msg.sender.transfer(value);
777   }
778 
779   function updateRefundState() internal returns(bool) {
780     if (!softcapAchieved) {
781       refundOn = true;
782     }
783     return refundOn;
784   }
785 
786 }
787 
788 // File: contracts/PreITO.sol
789 
790 contract PreITO is NextSaleAgentFeature, SoftcapFeature, ReferersCommonSale {
791 
792   uint public period;
793 
794   function calculateTokens(uint _invested) internal returns(uint) {
795     return _invested.mul(price).div(1 ether);
796   }
797 
798   function setPeriod(uint newPeriod) public onlyOwner {
799     period = newPeriod;
800   }
801 
802   function endSaleDate() public view returns(uint) {
803     return start.add(period * 1 days);
804   }
805   
806   function mintTokensByETH(address to, uint _invested) internal returns(uint) {
807     uint _tokens = super.mintTokensByETH(to, _invested);
808     updateBalance(to, _invested);
809     return _tokens;
810   }
811 
812   function finish() public onlyOwner {
813     if (updateRefundState()) {
814       token.finishMinting();
815     } else {
816       withdraw();
817       token.setSaleAgent(nextSaleAgent);
818     }
819   }
820 
821   function fallback() internal minInvestLimited(msg.value) returns(uint) {
822     require(now >= start && now < endSaleDate());
823     uint tokens = mintTokensByETH(msg.sender, msg.value);
824     if(msg.value >= referalsMinInvestLimit) {
825       address referer = getInputAddress();
826       if(referer != address(0)) {
827         require(referer != address(token) && referer != msg.sender && referer != address(this));
828         mintTokens(referer, tokens.mul(refererPercent).div(percentRate));
829       }
830     }
831     return tokens;
832   }
833 
834 }
835 
836 // File: contracts/Configurator.sol
837 
838 contract Configurator is Ownable {
839 
840   MintableToken public token;
841 
842   PreITO public preITO;
843 
844   ITO public ito;
845 
846   function deploy() public onlyOwner {
847 
848     token = new GeseToken();
849 
850     preITO = new PreITO();
851 
852     preITO.setWallet(0xa86780383E35De330918D8e4195D671140A60A74);
853     preITO.setStart(1526342400);
854     preITO.setPeriod(15);
855     preITO.setPrice(786700);
856     preITO.setMinInvestedLimit(100000000000000000);
857     preITO.setHardcap(3818000000000000000000);
858     preITO.setSoftcap(3640000000000000000000);
859     preITO.setReferalsMinInvestLimit(100000000000000000);
860     preITO.setRefererPercent(5);
861     preITO.setToken(token);
862 
863     token.setSaleAgent(preITO);
864 
865     ito = new ITO();
866 
867     ito.setWallet(0x98882D176234AEb736bbBDB173a8D24794A3b085);
868     ito.setStart(1527811200);
869     ito.addMilestone(5, 33);
870     ito.addMilestone(5, 18);
871     ito.addMilestone(5, 11);
872     ito.addMilestone(5, 5);
873     ito.addMilestone(10, 0);
874     ito.setPrice(550000);
875     ito.setMinInvestedLimit(100000000000000000);
876     ito.setHardcap(49090000000000000000000);
877     ito.setBountyTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
878     ito.setAdvisorsTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
879     ito.setTeamTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
880     ito.setReservedTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
881     ito.setBountyTokensPercent(5);
882     ito.setAdvisorsTokensPercent(10);
883     ito.setTeamTokensPercent(10);
884     ito.setReservedTokensPercent(10);
885     ito.setReferalsMinInvestLimit(100000000000000000);
886     ito.setRefererPercent(5);
887     ito.setToken(token);
888 
889     preITO.setNextSaleAgent(ito);
890 
891     address manager = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
892 
893     token.transferOwnership(manager);
894     preITO.transferOwnership(manager);
895     ito.transferOwnership(manager);
896   }
897 
898 }