1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ReceivingContractCallback.sol
4 
5 contract ReceivingContractCallback {
6 
7   function tokenFallback(address _from, uint _value) public;
8 
9 }
10 
11 // File: contracts/ownership/Ownable.sol
12 
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20 
21 
22   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   function Ownable() public {
30     owner = msg.sender;
31   }
32 
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
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
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    */
219   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236 }
237 
238 // File: contracts/LightcashCryptoToken.sol
239 
240 contract LightcashCryptoToken is StandardToken, Ownable {
241 
242   event Mint(address indexed to, uint256 amount);
243 
244   event MintFinished();
245 
246   string public constant name = 'Lightcash crypto';
247 
248   string public constant symbol = 'LCSH';
249 
250   uint32 public constant decimals = 18;
251 
252   bool public mintingFinished = false;
253 
254   address public saleAgent;
255 
256   mapping(address => bool) public authorized;
257 
258   mapping(address => bool)  public registeredCallbacks;
259 
260   function transfer(address _to, uint256 _value) public returns (bool) {
261     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
262   }
263 
264   function transferFrom(address from, address to, uint256 value) public returns (bool) {
265     return processCallback(super.transferFrom(from, to, value), from, to, value);
266   }
267 
268   function setSaleAgent(address newSaleAgent) public {
269     require(saleAgent == msg.sender || owner == msg.sender);
270     saleAgent = newSaleAgent;
271   }
272 
273   function mint(address _to, uint256 _amount) public returns (bool) {
274     require(!mintingFinished);
275     require(msg.sender == saleAgent);
276     totalSupply = totalSupply.add(_amount);
277     balances[_to] = balances[_to].add(_amount);
278     Mint(address(0), _amount);
279     Transfer(address(0), _to, _amount);
280     return true;
281   }
282 
283   function finishMinting() public returns (bool) {
284     require(!mintingFinished);
285     require(msg.sender == owner || msg.sender == saleAgent);
286     mintingFinished = true;
287     MintFinished();
288     return true;
289   }
290 
291   function registerCallback(address callback) public onlyOwner {
292     registeredCallbacks[callback] = true;
293   }
294 
295   function deregisterCallback(address callback) public onlyOwner {
296     registeredCallbacks[callback] = false;
297   }
298 
299   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
300     if (result && registeredCallbacks[to]) {
301       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
302       targetCallback.tokenFallback(from, value);
303     }
304     return result;
305   }
306 
307 }
308 
309 // File: contracts/CommonTokenEvent.sol
310 
311 contract CommonTokenEvent is Ownable {
312 
313   using SafeMath for uint;
314 
315   uint public constant PERCENT_RATE = 100;
316 
317   uint public price;
318 
319   uint public start;
320 
321   uint public period;
322 
323   uint public minPurchaseLimit;
324 
325   uint public minted;
326 
327   uint public hardcap;
328 
329   uint public invested;
330 
331   uint public referrerPercent;
332 
333   uint public maxReferrerTokens;
334 
335   address public directMintAgent;
336 
337   address public wallet;
338 
339   LightcashCryptoToken public token;
340 
341   modifier canMint() {
342     require(now >= start && now < lastSaleDate() && msg.value >= minPurchaseLimit && minted < hardcap);
343     _;
344   }
345 
346   modifier onlyDirectMintAgentOrOwner() {
347     require(directMintAgent == msg.sender || owner == msg.sender);
348     _;
349   }
350 
351   function sendReferrerTokens(uint tokens) internal {
352     if (msg.data.length == 20) {
353       address referrer = bytesToAddres(bytes(msg.data));
354       require(referrer != address(token) && referrer != msg.sender);
355       uint referrerTokens = tokens.mul(referrerPercent).div(PERCENT_RATE);
356       if(referrerTokens > maxReferrerTokens) {
357         referrerTokens = maxReferrerTokens;
358       }
359       mintAndSendTokens(referrer, referrerTokens);
360     }
361   }
362 
363   function bytesToAddres(bytes source) internal pure returns(address) {
364     uint result;
365     uint mul = 1;
366     for (uint i = 20; i > 0; i--) {
367       result += uint8(source[i-1])*mul;
368       mul = mul*256;
369     }
370     return address(result);
371   }
372 
373   function setMaxReferrerTokens(uint newMaxReferrerTokens) public onlyOwner {
374     maxReferrerTokens = newMaxReferrerTokens;
375   }
376 
377   function setHardcap(uint newHardcap) public onlyOwner {
378     hardcap = newHardcap;
379   }
380 
381   function setToken(address newToken) public onlyOwner {
382     token = LightcashCryptoToken(newToken);
383   }
384 
385   function setReferrerPercent(uint newReferrerPercent) public onlyOwner {
386     referrerPercent = newReferrerPercent;
387   }
388 
389   function setStart(uint newStart) public onlyOwner {
390     start = newStart;
391   }
392 
393   function setPrice(uint newPrice) public onlyOwner {
394     price = newPrice;
395   }
396 
397   function lastSaleDate() public view returns(uint) {
398     return start + period * 1 days;
399   }
400 
401   function setMinPurchaseLimit(uint newMinPurchaseLimit) public onlyOwner {
402     minPurchaseLimit = newMinPurchaseLimit;
403   }
404 
405   function setWallet(address newWallet) public onlyOwner {
406     wallet = newWallet;
407   }
408 
409   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
410     directMintAgent = newDirectMintAgent;
411   }
412 
413   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner {
414     calculateAndTransferTokens(to, investedWei);
415   }
416 
417   function directMintTokens(address to, uint count) public onlyDirectMintAgentOrOwner {
418     mintAndSendTokens(to, count);
419   }
420 
421   function mintAndSendTokens(address to, uint amount) internal {
422     token.mint(to, amount);
423     minted = minted.add(amount);
424   }
425 
426   function calculateAndTransferTokens(address to, uint investedInWei) internal returns(uint) {
427     uint tokens = calculateTokens(investedInWei);
428     mintAndSendTokens(to, tokens);
429     invested = invested.add(investedInWei);
430     return tokens;
431   }
432 
433   function calculateAndTransferTokensWithReferrer(address to, uint investedInWei) internal {
434     uint tokens = calculateAndTransferTokens(to, investedInWei);
435     sendReferrerTokens(tokens);
436   }
437 
438   function calculateTokens(uint investedInWei) public view returns(uint);
439 
440   function createTokens() public payable;
441 
442   function() external payable {
443     createTokens();
444   }
445 
446   function retrieveTokens(address to, address anotherToken) public onlyOwner {
447     ERC20 alienToken = ERC20(anotherToken);
448     alienToken.transfer(to, alienToken.balanceOf(this));
449   }
450 
451 }
452 
453 // File: contracts/PreTGE.sol
454 
455 contract PreTGE is CommonTokenEvent {
456 
457   uint public softcap;
458 
459   bool public refundOn;
460 
461   bool public softcapAchieved;
462 
463   address public nextSaleAgent;
464 
465   mapping (address => uint) public balances;
466 
467   event RefundsEnabled();
468 
469   event SoftcapReached();
470 
471   event Refunded(address indexed beneficiary, uint256 weiAmount);
472 
473   function setPeriod(uint newPeriod) public onlyOwner {
474     period = newPeriod;
475   }
476 
477   function calculateTokens(uint investedInWei) public view returns(uint) {
478     return investedInWei.mul(price).div(1 ether);
479   }
480 
481   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
482     nextSaleAgent = newNextSaleAgent;
483   }
484 
485   function setSoftcap(uint newSoftcap) public onlyOwner {
486     softcap = newSoftcap;
487   }
488 
489   function refund() public {
490     require(now > start && refundOn && balances[msg.sender] > 0);
491     uint value = balances[msg.sender];
492     balances[msg.sender] = 0;
493     msg.sender.transfer(value);
494     Refunded(msg.sender, value);
495   }
496 
497   function widthraw() public {
498     require(softcapAchieved);
499     wallet.transfer(this.balance);
500   }
501 
502   function createTokens() public payable canMint {
503     balances[msg.sender] = balances[msg.sender].add(msg.value);
504     super.calculateAndTransferTokensWithReferrer(msg.sender, msg.value);
505     if (!softcapAchieved && minted >= softcap) {
506       softcapAchieved = true;
507       SoftcapReached();
508     }
509   }
510 
511   function finish() public onlyOwner {
512     if (!softcapAchieved) {
513       refundOn = true;
514       RefundsEnabled();
515     } else {
516       widthraw();
517       token.setSaleAgent(nextSaleAgent);
518     }
519   }
520 
521 }
522 
523 // File: contracts/StagedTokenEvent.sol
524 
525 contract StagedTokenEvent is CommonTokenEvent {
526 
527   using SafeMath for uint;
528 
529   struct Stage {
530     uint period;
531     uint discount;
532   }
533 
534   uint public constant STAGES_PERCENT_RATE = 100;
535 
536   Stage[] public stages;
537 
538   function stagesCount() public constant returns(uint) {
539     return stages.length;
540   }
541 
542   function addStage(uint stagePeriod, uint discount) public onlyOwner {
543     require(stagePeriod > 0);
544     stages.push(Stage(stagePeriod, discount));
545     period = period.add(stagePeriod);
546   }
547 
548   function removeStage(uint8 number) public onlyOwner {
549     require(number >= 0 && number < stages.length);
550 
551     Stage storage stage = stages[number];
552     period = period.sub(stage.period);
553 
554     delete stages[number];
555 
556     for (uint i = number; i < stages.length - 1; i++) {
557       stages[i] = stages[i+1];
558     }
559 
560     stages.length--;
561   }
562 
563   function changeStage(uint8 number, uint stagePeriod, uint discount) public onlyOwner {
564     require(number >= 0 && number < stages.length);
565 
566     Stage storage stage = stages[number];
567 
568     period = period.sub(stage.period);
569 
570     stage.period = stagePeriod;
571     stage.discount = discount;
572 
573     period = period.add(stagePeriod);
574   }
575 
576   function insertStage(uint8 numberAfter, uint stagePeriod, uint discount) public onlyOwner {
577     require(numberAfter < stages.length);
578 
579 
580     period = period.add(stagePeriod);
581 
582     stages.length++;
583 
584     for (uint i = stages.length - 2; i > numberAfter; i--) {
585       stages[i + 1] = stages[i];
586     }
587 
588     stages[numberAfter + 1] = Stage(period, discount);
589   }
590 
591   function clearStages() public onlyOwner {
592     for (uint i = 0; i < stages.length; i++) {
593       delete stages[i];
594     }
595     stages.length -= stages.length;
596     period = 0;
597   }
598 
599   function getDiscount() public constant returns(uint) {
600     uint prevTimeLimit = start;
601     for (uint i = 0; i < stages.length; i++) {
602       Stage storage stage = stages[i];
603       prevTimeLimit += stage.period * 1 days;
604       if (now < prevTimeLimit)
605         return stage.discount;
606     }
607     revert();
608   }
609 
610 }
611 
612 // File: contracts/TGE.sol
613 
614 contract TGE is StagedTokenEvent {
615 
616   address public extraTokensWallet;
617 
618   uint public extraTokensPercent;
619 
620   bool public finished = false;
621 
622   function setExtraTokensWallet(address newExtraTokensWallet) public onlyOwner {
623     extraTokensWallet = newExtraTokensWallet;
624   }
625 
626   function setExtraTokensPercent(uint newExtraTokensPercent) public onlyOwner {
627     extraTokensPercent = newExtraTokensPercent;
628   }
629 
630   function calculateTokens(uint investedInWei) public view returns(uint) {
631     return investedInWei.mul(price).mul(STAGES_PERCENT_RATE).div(STAGES_PERCENT_RATE.sub(getDiscount())).div(1 ether);
632   }
633 
634   function finish() public onlyOwner {
635     require(!finished);
636     finished = true;
637     uint256 totalSupply = token.totalSupply();
638     uint allTokens = totalSupply.mul(PERCENT_RATE).div(PERCENT_RATE.sub(extraTokensPercent));
639     uint extraTokens = allTokens.mul(extraTokensPercent).div(PERCENT_RATE);
640     mintAndSendTokens(extraTokensWallet, extraTokens);
641   }
642 
643   function createTokens() public payable canMint {
644     require(!finished);
645     wallet.transfer(msg.value);
646     calculateAndTransferTokensWithReferrer(msg.sender, msg.value);
647   }
648 
649 }
650 
651 // File: contracts/Deployer.sol
652 
653 contract Deployer is Ownable {
654 
655   LightcashCryptoToken public token;
656 
657   PreTGE public preTGE;
658 
659   TGE public tge;
660 
661   function deploy() public onlyOwner {
662     token = new LightcashCryptoToken();
663 
664     preTGE = new PreTGE();
665     preTGE.setPrice(7143000000000000000000);
666     preTGE.setMinPurchaseLimit(100000000000000000);
667     preTGE.setSoftcap(7142857000000000000000000);
668     preTGE.setHardcap(52500000000000000000000000);
669     preTGE.setStart(1517230800);
670     preTGE.setPeriod(11);
671     preTGE.setWallet(0xDFDCAc0c9Eb45C63Bcff91220A48684882F1DAd0);
672     preTGE.setMaxReferrerTokens(10000000000000000000000);
673     preTGE.setReferrerPercent(10);
674 
675     tge = new TGE();
676     tge.setPrice(5000000000000000000000);
677     tge.setMinPurchaseLimit(10000000000000000);
678     tge.setHardcap(126000000000000000000000000);
679     tge.setStart(1517835600);
680     tge.setWallet(0x3aC45b49A4D3CB35022fd8122Fd865cd1B47932f);
681     tge.setExtraTokensWallet(0xF0e830148F3d1C4656770DAa282Fda6FAAA0Fe0B);
682     tge.setExtraTokensPercent(15);
683     tge.addStage(7, 20);
684     tge.addStage(7, 15);
685     tge.addStage(7, 10);
686     tge.addStage(1000, 5);
687     tge.setMaxReferrerTokens(10000000000000000000000);
688     tge.setReferrerPercent(10);
689 
690     preTGE.setToken(token);
691     tge.setToken(token);
692     preTGE.setNextSaleAgent(tge);
693     token.setSaleAgent(preTGE);
694 
695     address newOnwer = 0xF51E0a3a17990D41C5f1Ff1d0D772b26E4D6B6d0;
696     token.transferOwnership(newOnwer);
697     preTGE.transferOwnership(newOnwer);
698     tge.transferOwnership(newOnwer);
699   }
700 
701 }