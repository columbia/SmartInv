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
256   mapping(address => bool) public lockedAddressesAfterITO;
257 
258   mapping(address => bool) public unlockedAddressesDuringITO;
259 
260   address[] public tokenHolders;
261 
262   modifier onlyOwnerOrSaleAgent() {
263     require(msg.sender == saleAgent || msg.sender == owner);
264     _;
265   }
266 
267   function unlockAddressDuringITO(address addressToUnlock) public onlyOwnerOrSaleAgent {
268     unlockedAddressesDuringITO[addressToUnlock] = true;
269   }
270 
271   function lockAddressAfterITO(address addressToLock) public onlyOwnerOrSaleAgent {
272     lockedAddressesAfterITO[addressToLock] = true;
273   }
274 
275   function unlockAddressAfterITO(address addressToUnlock) public onlyOwnerOrSaleAgent {
276     lockedAddressesAfterITO[addressToUnlock] = false;
277   }
278 
279   function unlockBatchOfAddressesAfterITO(address[] addressesToUnlock) public onlyOwnerOrSaleAgent {
280     for(uint i = 0; i < addressesToUnlock.length; i++) lockedAddressesAfterITO[addressesToUnlock[i]] = false;
281   }
282 
283 
284   modifier notLocked(address sender) {
285     require((mintingFinished && !lockedAddressesAfterITO[sender]) ||
286             sender == saleAgent || 
287             sender == owner ||
288             (!mintingFinished && unlockedAddressesDuringITO[sender]));
289     _;
290   }
291 
292   function setSaleAgent(address newSaleAgnet) public onlyOwnerOrSaleAgent {
293     saleAgent = newSaleAgnet;
294   }
295 
296   function mint(address _to, uint256 _amount) public returns (bool) {
297     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
298     if(balances[_to] == 0) tokenHolders.push(_to);
299     totalSupply = totalSupply.add(_amount);
300     balances[_to] = balances[_to].add(_amount);
301     Mint(_to, _amount);
302     return true;
303   }
304 
305   /**
306    * @dev Function to stop minting new tokens.
307    * @return True if the operation was successful.
308    */
309   function finishMinting() public returns (bool) {
310     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
311     mintingFinished = true;
312     MintFinished();
313     return true;
314   }
315 
316   function transfer(address _to, uint256 _value) public notLocked(msg.sender) returns (bool) {
317     return super.transfer(_to, _value);
318   }
319 
320   function transferFrom(address from, address to, uint256 value) public notLocked(from) returns (bool) {
321     return super.transferFrom(from, to, value);
322   }
323 
324 }
325 
326 // File: contracts/ReceivingContractCallback.sol
327 
328 contract ReceivingContractCallback {
329 
330   function tokenFallback(address _from, uint _value) public;
331 
332 }
333 
334 // File: contracts/GeseToken.sol
335 
336 contract GeseToken is MintableToken {
337 
338   string public constant name = "Gese";
339 
340   string public constant symbol = "GSE";
341 
342   uint32 public constant decimals = 2;
343 
344   mapping(address => bool)  public registeredCallbacks;
345 
346   function transfer(address _to, uint256 _value) public returns (bool) {
347     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
348   }
349 
350   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
351     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
352   }
353 
354   function registerCallback(address callback) public onlyOwner {
355     registeredCallbacks[callback] = true;
356   }
357 
358   function deregisterCallback(address callback) public onlyOwner {
359     registeredCallbacks[callback] = false;
360   }
361 
362   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
363     if (result && registeredCallbacks[to]) {
364       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
365       targetCallback.tokenFallback(from, value);
366     }
367     return result;
368   }
369 
370 }
371 
372 // File: contracts/InvestedProvider.sol
373 
374 contract InvestedProvider is Ownable {
375 
376   uint public invested;
377 
378 }
379 
380 // File: contracts/PercentRateProvider.sol
381 
382 contract PercentRateProvider is Ownable {
383 
384   uint public percentRate = 100;
385 
386   function setPercentRate(uint newPercentRate) public onlyOwner {
387     percentRate = newPercentRate;
388   }
389 
390 }
391 
392 // File: contracts/RetrieveTokensFeature.sol
393 
394 contract RetrieveTokensFeature is Ownable {
395 
396   function retrieveTokens(address to, address anotherToken) public onlyOwner {
397     ERC20 alienToken = ERC20(anotherToken);
398     alienToken.transfer(to, alienToken.balanceOf(this));
399   }
400 
401 }
402 
403 // File: contracts/WalletProvider.sol
404 
405 contract WalletProvider is Ownable {
406 
407   address public wallet;
408 
409   function setWallet(address newWallet) public onlyOwner {
410     wallet = newWallet;
411   }
412 
413 }
414 
415 // File: contracts/CommonSale.sol
416 
417 contract CommonSale is InvestedProvider, WalletProvider, PercentRateProvider, RetrieveTokensFeature {
418 
419   using SafeMath for uint;
420 
421   address public directMintAgent;
422 
423   uint public price;
424 
425   uint public start;
426 
427   uint public minInvestedLimit;
428 
429   MintableToken public token;
430 
431   uint public hardcap;
432 
433   bool public lockAfterManuallyMint = true;
434 
435   modifier isUnderHardcap() {
436     require(invested < hardcap);
437     _;
438   }
439 
440   function setLockAfterManuallyMint(bool newLockAfterManuallyMint) public onlyOwner {
441     lockAfterManuallyMint = newLockAfterManuallyMint;
442   }
443 
444   function setHardcap(uint newHardcap) public onlyOwner {
445     hardcap = newHardcap;
446   }
447 
448   modifier onlyDirectMintAgentOrOwner() {
449     require(directMintAgent == msg.sender || owner == msg.sender);
450     _;
451   }
452 
453   modifier minInvestLimited(uint value) {
454     require(value >= minInvestedLimit);
455     _;
456   }
457 
458   function setStart(uint newStart) public onlyOwner {
459     start = newStart;
460   }
461 
462   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
463     minInvestedLimit = newMinInvestedLimit;
464   }
465 
466   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
467     directMintAgent = newDirectMintAgent;
468   }
469 
470   function setPrice(uint newPrice) public onlyOwner {
471     price = newPrice;
472   }
473 
474   function setToken(address newToken) public onlyOwner {
475     token = MintableToken(newToken);
476   }
477 
478   function calculateTokens(uint _invested) internal returns(uint);
479 
480   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
481     mintTokens(to, tokens);
482     if(lockAfterManuallyMint) token.lockAddressAfterITO(to);
483   }
484 
485   function mintTokens(address to, uint tokens) internal {
486     token.mint(to, tokens);
487   }
488 
489   function endSaleDate() public view returns(uint);
490 
491   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner {
492     mintTokensByETH(to, _invested);
493     if(lockAfterManuallyMint) token.lockAddressAfterITO(to);
494   }
495 
496   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
497     invested = invested.add(_invested);
498     uint tokens = calculateTokens(_invested);
499     mintTokens(to, tokens);
500     return tokens;
501   }
502 
503   function fallback() internal minInvestLimited(msg.value) returns(uint) {
504     require(now >= start && now < endSaleDate());
505     wallet.transfer(msg.value);
506     token.lockAddressAfterITO(msg.sender);
507     return mintTokensByETH(msg.sender, msg.value);
508   }
509 
510   function () public payable {
511     fallback();
512   }
513 
514 }
515 
516 // File: contracts/InputAddressFeature.sol
517 
518 contract InputAddressFeature {
519 
520   function bytesToAddress(bytes source) internal pure returns(address) {
521     uint result;
522     uint mul = 1;
523     for(uint i = 20; i > 0; i--) {
524       result += uint8(source[i-1])*mul;
525       mul = mul*256;
526     }
527     return address(result);
528   }
529 
530   function getInputAddress() internal pure returns(address) {
531     if(msg.data.length == 20) {
532       return bytesToAddress(bytes(msg.data));
533     }
534     return address(0);
535   }
536 
537 }
538 
539 // File: contracts/ReferersRewardFeature.sol
540 
541 contract ReferersRewardFeature is InputAddressFeature, CommonSale {
542 
543   uint public refererPercent;
544 
545   uint public referalsMinInvestLimit;
546 
547   function setReferalsMinInvestLimit(uint newRefereralsMinInvestLimit) public onlyOwner {
548     referalsMinInvestLimit = newRefereralsMinInvestLimit;
549   }
550 
551   function setRefererPercent(uint newRefererPercent) public onlyOwner {
552     refererPercent = newRefererPercent;
553   }
554 
555   function fallback() internal returns(uint) {
556     uint tokens = super.fallback();
557     if(msg.value >= referalsMinInvestLimit) {
558       address referer = getInputAddress();
559       if(referer != address(0)) {
560         require(referer != address(token) && referer != msg.sender && referer != address(this));
561         mintTokens(referer, tokens.mul(refererPercent).div(percentRate));
562       }
563     }
564     return tokens;
565   }
566 
567 }
568 
569 // File: contracts/StagedCrowdsale.sol
570 
571 contract StagedCrowdsale is Ownable {
572 
573   using SafeMath for uint;
574 
575   struct Milestone {
576     uint period;
577     uint bonus;
578   }
579 
580   uint public totalPeriod;
581 
582   Milestone[] public milestones;
583 
584   function milestonesCount() public view returns(uint) {
585     return milestones.length;
586   }
587 
588   function addMilestone(uint period, uint bonus) public onlyOwner {
589     require(period > 0);
590     milestones.push(Milestone(period, bonus));
591     totalPeriod = totalPeriod.add(period);
592   }
593 
594   function removeMilestone(uint8 number) public onlyOwner {
595     require(number < milestones.length);
596     Milestone storage milestone = milestones[number];
597     totalPeriod = totalPeriod.sub(milestone.period);
598 
599     delete milestones[number];
600 
601     for (uint i = number; i < milestones.length - 1; i++) {
602       milestones[i] = milestones[i+1];
603     }
604 
605     milestones.length--;
606   }
607 
608   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
609     require(number < milestones.length);
610     Milestone storage milestone = milestones[number];
611 
612     totalPeriod = totalPeriod.sub(milestone.period);
613 
614     milestone.period = period;
615     milestone.bonus = bonus;
616 
617     totalPeriod = totalPeriod.add(period);
618   }
619 
620   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
621     require(numberAfter < milestones.length);
622 
623     totalPeriod = totalPeriod.add(period);
624 
625     milestones.length++;
626 
627     for (uint i = milestones.length - 2; i > numberAfter; i--) {
628       milestones[i + 1] = milestones[i];
629     }
630 
631     milestones[numberAfter + 1] = Milestone(period, bonus);
632   }
633 
634   function clearMilestones() public onlyOwner {
635     require(milestones.length > 0);
636     for (uint i = 0; i < milestones.length; i++) {
637       delete milestones[i];
638     }
639     milestones.length -= milestones.length;
640     totalPeriod = 0;
641   }
642 
643   function lastSaleDate(uint start) public view returns(uint) {
644     return start + totalPeriod * 1 days;
645   }
646 
647   function currentMilestone(uint start) public view returns(uint) {
648     uint previousDate = start;
649     for(uint i=0; i < milestones.length; i++) {
650       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
651         return i;
652       }
653       previousDate = previousDate.add(milestones[i].period * 1 days);
654     }
655     revert();
656   }
657 
658 }
659 
660 // File: contracts/ReferersCommonSale.sol
661 
662 contract ReferersCommonSale is RetrieveTokensFeature, ReferersRewardFeature {
663 
664 
665 }
666 
667 // File: contracts/AssembledCommonSale.sol
668 
669 contract AssembledCommonSale is StagedCrowdsale, ReferersCommonSale {
670 
671   function calculateTokens(uint _invested) internal returns(uint) {
672     uint milestoneIndex = currentMilestone(start);
673     Milestone storage milestone = milestones[milestoneIndex];
674     uint tokens = _invested.mul(price).div(1 ether);
675     if(milestone.bonus > 0) {
676       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
677     }
678     return tokens;
679   }
680 
681   function endSaleDate() public view returns(uint) {
682     return lastSaleDate(start);
683   }
684 
685 }
686 
687 // File: contracts/ITO.sol
688 
689 contract ITO is AssembledCommonSale {
690 
691   address public bountyTokensWallet;
692 
693   address public advisorsTokensWallet;
694   
695   address public teamTokensWallet;
696 
697   address public reservedTokensWallet;
698 
699   uint public bountyTokensPercent;
700   
701   uint public advisorsTokensPercent;
702 
703   uint public teamTokensPercent;
704 
705   uint public reservedTokensPercent;
706 
707   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
708     bountyTokensPercent = newBountyTokensPercent;
709   }
710   
711   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner {
712     advisorsTokensPercent = newAdvisorsTokensPercent;
713   }
714 
715   function setTeamTokensPercent(uint newTeamTokensPercent) public onlyOwner {
716     teamTokensPercent = newTeamTokensPercent;
717   }
718 
719   function setReservedTokensPercent(uint newReservedTokensPercent) public onlyOwner {
720     reservedTokensPercent = newReservedTokensPercent;
721   }
722 
723   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
724     bountyTokensWallet = newBountyTokensWallet;
725   }
726 
727   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner {
728     advisorsTokensWallet = newAdvisorsTokensWallet;
729   }
730 
731   function setTeamTokensWallet(address newTeamTokensWallet) public onlyOwner {
732     teamTokensWallet = newTeamTokensWallet;
733   }
734 
735   function setReservedTokensWallet(address newReservedTokensWallet) public onlyOwner {
736     reservedTokensWallet = newReservedTokensWallet;
737   }
738 
739   function finish() public onlyOwner {
740     uint summaryTokensPercent = bountyTokensPercent.add(advisorsTokensPercent).add(teamTokensPercent).add(reservedTokensPercent);
741     uint mintedTokens = token.totalSupply();
742     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
743     uint advisorsTokens = allTokens.mul(advisorsTokensPercent).div(percentRate);
744     uint bountyTokens = allTokens.mul(bountyTokensPercent).div(percentRate);
745     uint teamTokens = allTokens.mul(teamTokensPercent).div(percentRate);
746     uint reservedTokens = allTokens.mul(reservedTokensPercent).div(percentRate);
747     mintTokens(advisorsTokensWallet, advisorsTokens);
748     mintTokens(bountyTokensWallet, bountyTokens);
749     mintTokens(teamTokensWallet, teamTokens);
750     mintTokens(reservedTokensWallet, reservedTokens);
751     token.finishMinting();
752   }
753 
754 }
755 
756 // File: contracts/NextSaleAgentFeature.sol
757 
758 contract NextSaleAgentFeature is Ownable {
759 
760   address public nextSaleAgent;
761 
762   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
763     nextSaleAgent = newNextSaleAgent;
764   }
765 
766 }
767 
768 // File: contracts/SoftcapFeature.sol
769 
770 contract SoftcapFeature is InvestedProvider, WalletProvider {
771 
772   using SafeMath for uint;
773 
774   mapping(address => uint) public balances;
775 
776   bool public softcapAchieved;
777 
778   bool public refundOn;
779 
780   uint public softcap;
781 
782   uint public constant devLimit = 4500000000000000000;
783 
784   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
785 
786   function setSoftcap(uint newSoftcap) public onlyOwner {
787     softcap = newSoftcap;
788   }
789 
790   function withdraw() public {
791     require(msg.sender == owner || msg.sender == devWallet);
792     require(softcapAchieved);
793     devWallet.transfer(devLimit);
794     wallet.transfer(this.balance);
795   }
796 
797   function updateBalance(address to, uint amount) internal {
798     balances[to] = balances[to].add(amount);
799     if (!softcapAchieved && invested >= softcap) {
800       softcapAchieved = true;
801     }
802   }
803 
804   function refund() public {
805     require(refundOn && balances[msg.sender] > 0);
806     uint value = balances[msg.sender];
807     balances[msg.sender] = 0;
808     msg.sender.transfer(value);
809   }
810 
811   function updateRefundState() internal returns(bool) {
812     if (!softcapAchieved) {
813       refundOn = true;
814     }
815     return refundOn;
816   }
817 
818 }
819 
820 // File: contracts/PreITO.sol
821 
822 contract PreITO is NextSaleAgentFeature, SoftcapFeature, ReferersCommonSale {
823 
824   uint public period;
825 
826   function calculateTokens(uint _invested) internal returns(uint) {
827     return _invested.mul(price).div(1 ether);
828   }
829 
830   function setPeriod(uint newPeriod) public onlyOwner {
831     period = newPeriod;
832   }
833 
834   function endSaleDate() public view returns(uint) {
835     return start.add(period * 1 days);
836   }
837   
838   function mintTokensByETH(address to, uint _invested) internal returns(uint) {
839     uint _tokens = super.mintTokensByETH(to, _invested);
840     updateBalance(to, _invested);
841     return _tokens;
842   }
843 
844   function finish() public onlyOwner {
845     if (updateRefundState()) {
846       token.finishMinting();
847     } else {
848       withdraw();
849       token.setSaleAgent(nextSaleAgent);
850     }
851   }
852 
853   function fallback() internal minInvestLimited(msg.value) returns(uint) {
854     require(now >= start && now < endSaleDate());
855     token.lockAddressAfterITO(msg.sender);
856     uint tokens = mintTokensByETH(msg.sender, msg.value);
857     if(msg.value >= referalsMinInvestLimit) {
858       address referer = getInputAddress();
859       if(referer != address(0)) {
860         require(referer != address(token) && referer != msg.sender && referer != address(this));
861         mintTokens(referer, tokens.mul(refererPercent).div(percentRate));
862       }
863     }
864     return tokens;
865   }
866 
867 }
868 
869 // File: contracts/Configurator.sol
870 
871 contract Configurator is Ownable {
872 
873   MintableToken public token;
874 
875   PreITO public preITO;
876 
877   ITO public ito;
878 
879   function deploy() public onlyOwner {
880 
881     token = new GeseToken();
882 
883     preITO = new PreITO();
884 
885     preITO.setWallet(0xa86780383E35De330918D8e4195D671140A60A74);
886     preITO.setStart(1529971200);
887     preITO.setPeriod(14);
888     preITO.setPrice(786700);
889     preITO.setMinInvestedLimit(100000000000000000);
890     preITO.setHardcap(3818000000000000000000);
891     preITO.setSoftcap(3640000000000000000000);
892     preITO.setReferalsMinInvestLimit(100000000000000000);
893     preITO.setRefererPercent(5);
894     preITO.setToken(token);
895 
896     token.setSaleAgent(preITO);
897 
898     ito = new ITO();
899 
900     ito.setWallet(0x98882D176234AEb736bbBDB173a8D24794A3b085);
901     ito.setStart(1536105600);
902     ito.addMilestone(5, 33);
903     ito.addMilestone(5, 18);
904     ito.addMilestone(5, 11);
905     ito.addMilestone(5, 5);
906     ito.addMilestone(10, 0);
907     ito.setPrice(550000);
908     ito.setMinInvestedLimit(100000000000000000);
909     ito.setHardcap(49090000000000000000000);
910     ito.setBountyTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
911     ito.setAdvisorsTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
912     ito.setTeamTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
913     ito.setReservedTokensWallet(0x28732f6dc12606D529a020b9ac04C9d6f881D3c5);
914     ito.setBountyTokensPercent(5);
915     ito.setAdvisorsTokensPercent(10);
916     ito.setTeamTokensPercent(10);
917     ito.setReservedTokensPercent(10);
918     ito.setReferalsMinInvestLimit(100000000000000000);
919     ito.setRefererPercent(5);
920     ito.setToken(token);
921 
922     preITO.setNextSaleAgent(ito);
923 
924     address manager = 0x6c29554bD66D788Aa15D9B80A1Fff0717614341c;
925 
926     token.transferOwnership(manager);
927     preITO.transferOwnership(manager);
928     ito.transferOwnership(manager);
929   }
930 
931 }