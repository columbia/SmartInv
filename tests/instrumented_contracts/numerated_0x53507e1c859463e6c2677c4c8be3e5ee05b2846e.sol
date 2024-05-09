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
296 // File: contracts/InspemToken.sol
297 
298 contract InspemToken is MintableToken {
299 
300   string public constant name = "Inspem";
301 
302   string public constant symbol = "INP";
303 
304   uint32 public constant decimals = 18;
305 
306 }
307 
308 // File: contracts/PercentRateProvider.sol
309 
310 contract PercentRateProvider is Ownable {
311 
312   uint public percentRate = 100;
313 
314   function setPercentRate(uint newPercentRate) public onlyOwner {
315     percentRate = newPercentRate;
316   }
317 
318 }
319 
320 // File: contracts/CommonSale.sol
321 
322 contract CommonSale is PercentRateProvider {
323 
324   using SafeMath for uint;
325 
326   address public wallet;
327 
328   address public directMintAgent;
329 
330   uint public price;
331 
332   uint public start;
333 
334   uint public minInvestedLimit;
335 
336   MintableToken public token;
337 
338   uint public hardcap;
339 
340   uint public invested;
341 
342   modifier isUnderHardcap() {
343     require(invested < hardcap);
344     _;
345   }
346 
347   function setHardcap(uint newHardcap) public onlyOwner {
348     hardcap = newHardcap;
349   }
350 
351   modifier onlyDirectMintAgentOrOwner() {
352     require(directMintAgent == msg.sender || owner == msg.sender);
353     _;
354   }
355 
356   modifier minInvestLimited(uint value) {
357     require(value >= minInvestedLimit);
358     _;
359   }
360 
361   function setStart(uint newStart) public onlyOwner {
362     start = newStart;
363   }
364 
365   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
366     minInvestedLimit = newMinInvestedLimit;
367   }
368 
369   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
370     directMintAgent = newDirectMintAgent;
371   }
372 
373   function setWallet(address newWallet) public onlyOwner {
374     wallet = newWallet;
375   }
376 
377   function setPrice(uint newPrice) public onlyOwner {
378     price = newPrice;
379   }
380 
381   function setToken(address newToken) public onlyOwner {
382     token = MintableToken(newToken);
383   }
384 
385   function calculateTokens(uint _invested) internal returns(uint);
386 
387   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
388     mintTokens(to, tokens);
389   }
390 
391   function mintTokens(address to, uint tokens) internal {
392     token.mint(this, tokens);
393     token.transfer(to, tokens);
394   }
395 
396   function endSaleDate() public view returns(uint);
397 
398   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
399     return mintTokensByETH(to, _invested);
400   }
401 
402   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
403     invested = invested.add(_invested);
404     uint tokens = calculateTokens(_invested);
405     mintTokens(to, tokens);
406     return tokens;
407   }
408 
409   function fallback() internal minInvestLimited(msg.value) returns(uint) {
410     require(now >= start && now < endSaleDate());
411     wallet.transfer(msg.value);
412     return mintTokensByETH(msg.sender, msg.value);
413   }
414 
415   function () public payable {
416     fallback();
417   }
418 
419 }
420 
421 // File: contracts/InputAddressFeature.sol
422 
423 contract InputAddressFeature {
424 
425   function bytesToAddress(bytes source) internal pure returns(address) {
426     uint result;
427     uint mul = 1;
428     for(uint i = 20; i > 0; i--) {
429       result += uint8(source[i-1])*mul;
430       mul = mul*256;
431     }
432     return address(result);
433   }
434 
435   function getInputAddress() internal pure returns(address) {
436     if(msg.data.length == 20) {
437       return bytesToAddress(bytes(msg.data));
438     }
439     return address(0);
440   }
441 
442 }
443 
444 // File: contracts/ReferersRewardFeature.sol
445 
446 contract ReferersRewardFeature is InputAddressFeature, CommonSale {
447 
448   uint public refererPercent;
449 
450   function setRefererPercent(uint newRefererPercent) public onlyOwner {
451     refererPercent = newRefererPercent;
452   }
453 
454   function fallback() internal returns(uint) {
455     uint tokens = super.fallback();
456     address referer = getInputAddress();
457     if(referer != address(0)) {
458       require(referer != address(token) && referer != msg.sender && referer != address(this));
459       mintTokens(referer, tokens.mul(refererPercent).div(percentRate));
460     }
461     return tokens;
462   }
463 
464 }
465 
466 // File: contracts/RetrieveTokensFeature.sol
467 
468 contract RetrieveTokensFeature is Ownable {
469 
470   function retrieveTokens(address to, address anotherToken) public onlyOwner {
471     ERC20 alienToken = ERC20(anotherToken);
472     alienToken.transfer(to, alienToken.balanceOf(this));
473   }
474 
475 }
476 
477 // File: contracts/StagedCrowdsale.sol
478 
479 contract StagedCrowdsale is Ownable {
480 
481   using SafeMath for uint;
482 
483   struct Milestone {
484     uint period;
485     uint bonus;
486   }
487 
488   uint public totalPeriod;
489 
490   Milestone[] public milestones;
491 
492   function milestonesCount() public view returns(uint) {
493     return milestones.length;
494   }
495 
496   function addMilestone(uint period, uint bonus) public onlyOwner {
497     require(period > 0);
498     milestones.push(Milestone(period, bonus));
499     totalPeriod = totalPeriod.add(period);
500   }
501 
502   function removeMilestone(uint8 number) public onlyOwner {
503     require(number < milestones.length);
504     Milestone storage milestone = milestones[number];
505     totalPeriod = totalPeriod.sub(milestone.period);
506 
507     delete milestones[number];
508 
509     for (uint i = number; i < milestones.length - 1; i++) {
510       milestones[i] = milestones[i+1];
511     }
512 
513     milestones.length--;
514   }
515 
516   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
517     require(number < milestones.length);
518     Milestone storage milestone = milestones[number];
519 
520     totalPeriod = totalPeriod.sub(milestone.period);
521 
522     milestone.period = period;
523     milestone.bonus = bonus;
524 
525     totalPeriod = totalPeriod.add(period);
526   }
527 
528   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
529     require(numberAfter < milestones.length);
530 
531     totalPeriod = totalPeriod.add(period);
532 
533     milestones.length++;
534 
535     for (uint i = milestones.length - 2; i > numberAfter; i--) {
536       milestones[i + 1] = milestones[i];
537     }
538 
539     milestones[numberAfter + 1] = Milestone(period, bonus);
540   }
541 
542   function clearMilestones() public onlyOwner {
543     require(milestones.length > 0);
544     for (uint i = 0; i < milestones.length; i++) {
545       delete milestones[i];
546     }
547     milestones.length -= milestones.length;
548     totalPeriod = 0;
549   }
550 
551   function lastSaleDate(uint start) public view returns(uint) {
552     return start + totalPeriod * 1 days;
553   }
554 
555   function currentMilestone(uint start) public view returns(uint) {
556     uint previousDate = start;
557     for(uint i=0; i < milestones.length; i++) {
558       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
559         return i;
560       }
561       previousDate = previousDate.add(milestones[i].period * 1 days);
562     }
563     revert();
564   }
565 
566 }
567 
568 // File: contracts/InspemCommonSale.sol
569 
570 contract InspemCommonSale is StagedCrowdsale, RetrieveTokensFeature, ReferersRewardFeature {
571 
572   function calculateTokens(uint _invested) internal returns(uint) {
573     uint milestoneIndex = currentMilestone(start);
574     Milestone storage milestone = milestones[milestoneIndex];
575     uint tokens = _invested.mul(price).div(1 ether);
576     if(milestone.bonus > 0) {
577       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
578     }
579     return tokens;
580   }
581 
582   function endSaleDate() public view returns(uint) {
583     return lastSaleDate(start);
584   }
585 
586 }
587 
588 // File: contracts/Mainsale.sol
589 
590 contract Mainsale is InspemCommonSale {
591 
592   address public foundersTokensWallet;
593 
594   address public bountyTokensWallet;
595 
596   uint public foundersTokensPercent;
597 
598   uint public bountyTokensPercent;
599 
600   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
601     foundersTokensPercent = newFoundersTokensPercent;
602   }
603 
604   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
605     bountyTokensPercent = newBountyTokensPercent;
606   }
607 
608   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
609     foundersTokensWallet = newFoundersTokensWallet;
610   }
611 
612   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
613     bountyTokensWallet = newBountyTokensWallet;
614   }
615 
616   function finish() public onlyOwner {
617     uint summaryTokensPercent = bountyTokensPercent.add(foundersTokensPercent);
618     uint mintedTokens = token.totalSupply();
619     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
620     uint foundersTokens = allTokens.mul(foundersTokensPercent).div(percentRate);
621     uint bountyTokens = allTokens.mul(bountyTokensPercent).div(percentRate);
622     mintTokens(foundersTokensWallet, foundersTokens);
623     mintTokens(bountyTokensWallet, bountyTokens);
624     token.finishMinting();
625   }
626 
627 }
628 
629 // File: contracts/NextSaleAgentFeature.sol
630 
631 contract NextSaleAgentFeature is Ownable {
632 
633   address public nextSaleAgent;
634 
635   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
636     nextSaleAgent = newNextSaleAgent;
637   }
638 
639 }
640 
641 // File: contracts/Presale.sol
642 
643 contract Presale is NextSaleAgentFeature, InspemCommonSale {
644 
645   function finish() public onlyOwner {
646     token.setSaleAgent(nextSaleAgent);
647   }
648 
649 }
650 
651 // File: contracts/Configurator.sol
652 
653 contract Configurator is Ownable {
654 
655   MintableToken public token;
656 
657   Presale public presale;
658 
659   Mainsale public mainsale;
660 
661   function deploy() public onlyOwner {
662 
663     token = new InspemToken();
664     presale = new Presale();
665     mainsale = new Mainsale();
666 
667     token.setSaleAgent(presale);
668 
669     presale.addMilestone(14, 100);
670     presale.addMilestone(14, 50);
671     presale.setWallet(0x16Af606E2f396DDdde61809A2C73b8E64A81c1Ea);
672     presale.setStart(1521550800);
673     presale.setPrice(5000000000000000000000);
674     presale.setHardcap(2000000000000000000000);
675     presale.setMinInvestedLimit(100000000000000000);
676     presale.setRefererPercent(5);
677     presale.setToken(token);
678     presale.setNextSaleAgent(mainsale);
679 
680     mainsale.addMilestone(7, 30);
681     mainsale.addMilestone(7, 20);
682     mainsale.addMilestone(7, 10);
683     mainsale.addMilestone(7, 0);
684     mainsale.setPrice(5000000000000000000000);
685     mainsale.setWallet(0xb24EDbc6d7EDa33af4A91d57c621e5eB86c02BcF);
686     mainsale.setFoundersTokensWallet(0xAFA1bFDF3112d4d3e9CaC4A100a0eBf22231878c);
687     mainsale.setBountyTokensWallet(0x3c0260Ce19363350264D23Fd1A48F50001dBb5ee);
688     mainsale.setStart(1525179600);
689     mainsale.setHardcap(30000000000000000000000);
690     mainsale.setMinInvestedLimit(100000000000000000);
691     mainsale.setRefererPercent(5);
692     mainsale.setFoundersTokensPercent(15);
693     mainsale.setBountyTokensPercent(5);
694     mainsale.setToken(token);
695 
696     address manager = 0x3e886934D9d2414186CE54477F7CC3bBE164022a;
697     token.transferOwnership(manager);
698     presale.transferOwnership(manager);
699     mainsale.transferOwnership(manager);
700   }
701 
702 }