1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) public view returns (uint256);
100   function transferFrom(address from, address to, uint256 value) public returns (bool);
101   function approve(address spender, uint256 value) public returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
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
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract StandardToken is ERC20, BasicToken {
151 
152   mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169     Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public view returns (uint256) {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    */
205   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
212     uint oldValue = allowed[msg.sender][_spender];
213     if (_subtractedValue > oldValue) {
214       allowed[msg.sender][_spender] = 0;
215     } else {
216       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217     }
218     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222 }
223 
224 
225 contract KITToken is StandardToken, Ownable {
226 
227   using SafeMath for uint256;
228 
229   event Mint(address indexed to, uint256 amount);
230 
231   event MintFinished();
232 
233   string public constant name = 'KIT';
234 
235   string public constant symbol = 'KIT';
236 
237   uint32 public constant decimals = 18;
238 
239   bool public mintingFinished = false;
240 
241   address public saleAgent;
242 
243   modifier notLocked() {
244     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
245     _;
246   }
247 
248   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
249     return super.transfer(_to, _value);
250   }
251 
252   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
253     return super.transferFrom(from, to, value);
254   }
255 
256   function setSaleAgent(address newSaleAgent) public {
257     require(saleAgent == msg.sender || owner == msg.sender);
258     saleAgent = newSaleAgent;
259   }
260 
261   function mint(address _to, uint256 _amount) public returns (bool) {
262     require(!mintingFinished);
263     require(msg.sender == saleAgent);
264     totalSupply = totalSupply.add(_amount);
265     balances[_to] = balances[_to].add(_amount);
266     Mint(_to, _amount);
267     Transfer(address(0), _to, _amount);
268     return true;
269   }
270 
271   function finishMinting() public returns (bool) {
272     require(!mintingFinished);
273     require(msg.sender == owner || msg.sender == saleAgent);
274     mintingFinished = true;
275     MintFinished();
276     return true;
277   }
278 
279 }
280 
281 
282 contract LockableChanges is Ownable {
283 
284   bool public changesLocked;
285 
286   modifier notLocked() {
287     require(!changesLocked);
288     _;
289   }
290 
291   function lockChanges() public onlyOwner {
292     changesLocked = true;
293   }
294 
295 }
296 
297 
298 contract CommonCrowdsale is Ownable, LockableChanges {
299 
300   using SafeMath for uint256;
301 
302   uint public constant PERCENT_RATE = 100;
303 
304   uint public price;
305 
306   uint public minInvestedLimit;
307 
308   uint public hardcap;
309 
310   uint public start;
311 
312   uint public end;
313 
314   uint public invested;
315 
316   uint public minted;
317 
318   address public wallet;
319 
320   address public bountyTokensWallet;
321 
322   address public devTokensWallet;
323 
324   address public advisorsTokensWallet;
325 
326   address public foundersTokensWallet;
327 
328   uint public bountyTokensPercent;
329 
330   uint public devTokensPercent;
331 
332   uint public advisorsTokensPercent;
333 
334   uint public foundersTokensPercent;
335 
336   address public directMintAgent;
337 
338   struct Bonus {
339     uint periodInDays;
340     uint bonus;
341   }
342 
343   Bonus[] public bonuses;
344 
345   KITToken public token;
346 
347   modifier saleIsOn() {
348     require(msg.value >= minInvestedLimit && now >= start && now < end && invested < hardcap);
349     _;
350   }
351 
352   function setHardcap(uint newHardcap) public onlyOwner {
353     hardcap = newHardcap;
354   }
355 
356   function setStart(uint newStart) public onlyOwner {
357     start = newStart;
358   }
359 
360   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
361     bountyTokensPercent = newBountyTokensPercent;
362   }
363 
364   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner {
365     advisorsTokensPercent = newAdvisorsTokensPercent;
366   }
367 
368   function setDevTokensPercent(uint newDevTokensPercent) public onlyOwner {
369     devTokensPercent = newDevTokensPercent;
370   }
371 
372   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
373     foundersTokensPercent = newFoundersTokensPercent;
374   }
375 
376   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
377     bountyTokensWallet = newBountyTokensWallet;
378   }
379 
380   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner {
381     advisorsTokensWallet = newAdvisorsTokensWallet;
382   }
383 
384   function setDevTokensWallet(address newDevTokensWallet) public onlyOwner {
385     devTokensWallet = newDevTokensWallet;
386   }
387 
388   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
389     foundersTokensWallet = newFoundersTokensWallet;
390   }
391 
392   function setEnd(uint newEnd) public onlyOwner {
393     require(start < newEnd);
394     end = newEnd;
395   }
396 
397   function setToken(address newToken) public onlyOwner {
398     token = KITToken(newToken);
399   }
400 
401   function setWallet(address newWallet) public onlyOwner {
402     wallet = newWallet;
403   }
404 
405   function setPrice(uint newPrice) public onlyOwner {
406     price = newPrice;
407   }
408 
409   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
410     minInvestedLimit = newMinInvestedLimit;
411   }
412 
413   function bonusesCount() public constant returns(uint) {
414     return bonuses.length;
415   }
416 
417   function addBonus(uint limit, uint bonus) public onlyOwner {
418     bonuses.push(Bonus(limit, bonus));
419   }
420 
421   modifier onlyDirectMintAgentOrOwner() {
422     require(directMintAgent == msg.sender || owner == msg.sender);
423     _;
424   }
425 
426   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
427     directMintAgent = newDirectMintAgent;
428   }
429 
430   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
431     calculateAndTransferTokens(to, investedWei);
432   }
433 
434   function mintExtendedTokens() internal {
435     uint extendedTokensPercent = bountyTokensPercent.add(devTokensPercent).add(advisorsTokensPercent).add(foundersTokensPercent);
436     uint extendedTokens = minted.mul(extendedTokensPercent).div(PERCENT_RATE.sub(extendedTokensPercent));
437     uint summaryTokens = extendedTokens.add(minted);
438 
439     uint bountyTokens = summaryTokens.mul(bountyTokensPercent).div(PERCENT_RATE);
440     mintAndSendTokens(bountyTokensWallet, bountyTokens);
441 
442     uint advisorsTokens = summaryTokens.mul(advisorsTokensPercent).div(PERCENT_RATE);
443     mintAndSendTokens(advisorsTokensWallet, advisorsTokens);
444 
445     uint foundersTokens = summaryTokens.mul(foundersTokensPercent).div(PERCENT_RATE);
446     mintAndSendTokens(foundersTokensWallet, foundersTokens);
447 
448     uint devTokens = extendedTokens.sub(bountyTokens).sub(advisorsTokens).sub(foundersTokens);
449     mintAndSendTokens(devTokensWallet, devTokens);
450   }
451 
452   function mintAndSendTokens(address to, uint amount) internal {
453     token.mint(to, amount);
454     minted = minted.add(amount);
455   }
456 
457   function calculateAndTransferTokens(address to, uint investedInWei) internal {
458     // update invested value
459     invested = invested.add(investedInWei);
460 
461     // calculate tokens
462     uint tokens = msg.value.mul(price).div(1 ether);
463     uint bonus = getBonus();
464     if (bonus > 0) {
465       tokens = tokens.add(tokens.mul(bonus).div(100));
466     }
467 
468     // transfer tokens
469     mintAndSendTokens(to, tokens);
470   }
471 
472   function getBonus() public constant returns(uint) {
473     uint prevTimeLimit = start;
474     for (uint i = 0; i < bonuses.length; i++) {
475       Bonus storage bonus = bonuses[i];
476       prevTimeLimit += bonus.periodInDays * 1 days;
477       if (now < prevTimeLimit)
478         return bonus.bonus;
479     }
480     return 0;
481   }
482 
483   function createTokens() public payable;
484 
485   function() external payable {
486     createTokens();
487   }
488 
489   function retrieveTokens(address anotherToken) public onlyOwner {
490     ERC20 alienToken = ERC20(anotherToken);
491     alienToken.transfer(wallet, alienToken.balanceOf(this));
492   }
493 
494 }
495 
496 
497 contract Presale is CommonCrowdsale {
498 
499   uint public devLimit;
500 
501   uint public softcap;
502 
503   bool public refundOn;
504 
505   bool public softcapAchieved;
506 
507   bool public devWithdrawn;
508 
509   address public devWallet;
510 
511   address public nextSaleAgent;
512 
513   mapping (address => uint) public balances;
514 
515   function Presale() public {
516     minInvestedLimit = 10000000000000000;
517     price = 1000000000000000000000;
518     bountyTokensPercent = 3;
519     advisorsTokensPercent = 1;
520     devTokensPercent = 4;
521     foundersTokensPercent = 10;
522     softcap = 20000000000000000000;
523     hardcap = 63000000000000000000000;
524     addBonus(7,42);
525     addBonus(7,25);
526     addBonus(7,11);
527     start = 1513774800;
528     end = 1516885200;
529     devLimit = 7000000000000000000;
530     wallet = 0x72EcAEB966176c50CfFc0Db53E4A2D3DbC0d538B;
531     devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
532     bountyTokensWallet = 0x7E513B54e3a45B60d6f92c6CECE10C68977EEA8c;
533     foundersTokensWallet = 0x4227859C5A9Bb4391Cc4735Aa655e980a3DD4380;
534     advisorsTokensWallet = 0x6e740ef8618A7d822238F867c622373Df8B54a22;
535     devTokensWallet = 0xCaDca9387E12F55997F46870DA28F0af1626A6d4;
536   }
537 
538   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
539     nextSaleAgent = newNextSaleAgent;
540   }
541 
542   function setSoftcap(uint newSoftcap) public onlyOwner {
543     softcap = newSoftcap;
544   }
545 
546   function setDevWallet(address newDevWallet) public onlyOwner notLocked {
547     devWallet = newDevWallet;
548   }
549 
550   function setDevLimit(uint newDevLimit) public onlyOwner notLocked {
551     devLimit = newDevLimit;
552   }
553 
554   function refund() public {
555     require(now > start && refundOn && balances[msg.sender] > 0);
556     uint value = balances[msg.sender];
557     balances[msg.sender] = 0;
558     msg.sender.transfer(value);
559   }
560 
561   function createTokens() public payable saleIsOn {
562     balances[msg.sender] = balances[msg.sender].add(msg.value);
563     calculateAndTransferTokens(msg.sender, msg.value);
564     if (!softcapAchieved && invested >= softcap) {
565       softcapAchieved = true;
566     }
567   }
568 
569   function withdrawDev() public {
570     require(softcapAchieved);
571     require(devWallet == msg.sender || owner == msg.sender);
572     if (!devWithdrawn) {
573       devWithdrawn = true;
574       devWallet.transfer(devLimit);
575     }
576   }
577 
578   function withdraw() public {
579     require(softcapAchieved);
580     require(owner == msg.sender);
581     withdrawDev();
582     wallet.transfer(this.balance);
583   }
584 
585   function finishMinting() public onlyOwner {
586     if (!softcapAchieved) {
587       refundOn = true;
588       token.finishMinting();
589     } else {
590       mintExtendedTokens();
591       token.setSaleAgent(nextSaleAgent);
592     }
593   }
594 
595 }
596 
597 
598 contract ICO is CommonCrowdsale {
599 
600   function ICO() public {
601     minInvestedLimit = 10000000000000000;
602     price = 909000000000000000000;
603     bountyTokensPercent = 3;
604     advisorsTokensPercent = 1;
605     devTokensPercent = 4;
606     foundersTokensPercent = 10;
607     hardcap = 67500000000000000000000;
608     addBonus(7,10);
609     addBonus(7,5);
610     start = 1519131600;
611     end = 1521550800;
612     wallet = 0x72EcAEB966176c50CfFc0Db53E4A2D3DbC0d538B;
613     bountyTokensWallet = 0x7E513B54e3a45B60d6f92c6CECE10C68977EEA8c;
614     foundersTokensWallet = 0x4227859C5A9Bb4391Cc4735Aa655e980a3DD4380;
615     advisorsTokensWallet = 0x6e740ef8618A7d822238F867c622373Df8B54a22;
616     devTokensWallet = 0xCaDca9387E12F55997F46870DA28F0af1626A6d4;
617   }
618 
619   function finishMinting() public onlyOwner {
620     mintExtendedTokens();
621     token.finishMinting();
622   }
623 
624   function createTokens() public payable saleIsOn {
625     calculateAndTransferTokens(msg.sender, msg.value);
626     wallet.transfer(msg.value);
627   }
628 
629 }
630 
631 
632 contract Deployer is Ownable {
633 
634   Presale public presale;
635 
636   ICO public ico;
637 
638   KITToken public token;
639 
640   function deploy() public onlyOwner {
641     owner = 0x69F5C3850D1f1d5BAeAe71E947e915A539088Bb0;
642 
643     token = new KITToken();
644 
645     presale = new Presale();
646     presale.setToken(token);
647     token.setSaleAgent(presale);
648 
649     ico = new ICO();
650     ico.setToken(token);
651     presale.setNextSaleAgent(ico);
652 
653     presale.lockChanges();
654     ico.lockChanges();
655 
656     presale.transferOwnership(owner);
657     ico.transferOwnership(owner);
658     token.transferOwnership(owner);
659   }
660 
661 }