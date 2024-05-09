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
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
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
45 // File: contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: contracts/StagedCrowdsale.sol
140 
141 contract StagedCrowdsale is Pausable {
142 
143   using SafeMath for uint;
144 
145   struct Stage {
146     uint hardcap;
147     uint price;
148     uint invested;
149     uint closed;
150   }
151 
152   uint public start;
153 
154   uint public period;
155 
156   uint public totalHardcap;
157 
158   uint public totalInvested;
159 
160   Stage[] public stages;
161 
162   function stagesCount() public constant returns(uint) {
163     return stages.length;
164   }
165 
166   function setStart(uint newStart) public onlyOwner {
167     start = newStart;
168   }
169 
170   function setPeriod(uint newPeriod) public onlyOwner {
171     period = newPeriod;
172   }
173 
174   function addStage(uint hardcap, uint price) public onlyOwner {
175     require(hardcap > 0 && price > 0);
176     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
177     stages.push(stage);
178     totalHardcap = totalHardcap.add(stage.hardcap);
179   }
180 
181   function removeStage(uint8 number) public onlyOwner {
182     require(number >= 0 && number < stages.length);
183     Stage storage stage = stages[number];
184     totalHardcap = totalHardcap.sub(stage.hardcap);
185     delete stages[number];
186     for (uint i = number; i < stages.length - 1; i++) {
187       stages[i] = stages[i+1];
188     }
189     stages.length--;
190   }
191 
192   function changeStage(uint8 number, uint hardcap, uint price) public onlyOwner {
193     require(number >= 0 && number < stages.length);
194     Stage storage stage = stages[number];
195     totalHardcap = totalHardcap.sub(stage.hardcap);
196     stage.hardcap = hardcap.mul(1 ether);
197     stage.price = price;
198     totalHardcap = totalHardcap.add(stage.hardcap);
199   }
200 
201   function insertStage(uint8 numberAfter, uint hardcap, uint price) public onlyOwner {
202     require(numberAfter < stages.length);
203     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
204     totalHardcap = totalHardcap.add(stage.hardcap);
205     stages.length++;
206     for (uint i = stages.length - 2; i > numberAfter; i--) {
207       stages[i + 1] = stages[i];
208     }
209     stages[numberAfter + 1] = stage;
210   }
211 
212   function clearStages() public onlyOwner {
213     for (uint i = 0; i < stages.length; i++) {
214       delete stages[i];
215     }
216     stages.length -= stages.length;
217     totalHardcap = 0;
218   }
219 
220   function lastSaleDate() public constant returns(uint) {
221     return start + period * 1 days;
222   }
223 
224   modifier saleIsOn() {
225     require(stages.length > 0 && now >= start && now < lastSaleDate());
226     _;
227   }
228 
229   modifier isUnderHardcap() {
230     require(totalInvested <= totalHardcap);
231     _;
232   }
233 
234   function currentStage() public saleIsOn isUnderHardcap constant returns(uint) {
235     for (uint i = 0; i < stages.length; i++) {
236       if (stages[i].closed == 0) {
237         return i;
238       }
239     }
240     revert();
241   }
242 
243 }
244 
245 // File: contracts/ReceivingContractCallback.sol
246 
247 contract ReceivingContractCallback {
248 
249   function tokenFallback(address _from, uint _value) public;
250 
251 }
252 
253 // File: contracts/token/ERC20/ERC20Basic.sol
254 
255 /**
256  * @title ERC20Basic
257  * @dev Simpler version of ERC20 interface
258  * @dev see https://github.com/ethereum/EIPs/issues/179
259  */
260 contract ERC20Basic {
261   function totalSupply() public view returns (uint256);
262   function balanceOf(address who) public view returns (uint256);
263   function transfer(address to, uint256 value) public returns (bool);
264   event Transfer(address indexed from, address indexed to, uint256 value);
265 }
266 
267 // File: contracts/token/ERC20/BasicToken.sol
268 
269 /**
270  * @title Basic token
271  * @dev Basic version of StandardToken, with no allowances.
272  */
273 contract BasicToken is ERC20Basic {
274   using SafeMath for uint256;
275 
276   mapping(address => uint256) balances;
277 
278   uint256 totalSupply_;
279 
280   /**
281   * @dev total number of tokens in existence
282   */
283   function totalSupply() public view returns (uint256) {
284     return totalSupply_;
285   }
286 
287   /**
288   * @dev transfer token for a specified address
289   * @param _to The address to transfer to.
290   * @param _value The amount to be transferred.
291   */
292   function transfer(address _to, uint256 _value) public returns (bool) {
293     require(_to != address(0));
294     require(_value <= balances[msg.sender]);
295 
296     // SafeMath.sub will throw if there is not enough balance.
297     balances[msg.sender] = balances[msg.sender].sub(_value);
298     balances[_to] = balances[_to].add(_value);
299     Transfer(msg.sender, _to, _value);
300     return true;
301   }
302 
303   /**
304   * @dev Gets the balance of the specified address.
305   * @param _owner The address to query the the balance of.
306   * @return An uint256 representing the amount owned by the passed address.
307   */
308   function balanceOf(address _owner) public view returns (uint256 balance) {
309     return balances[_owner];
310   }
311 
312 }
313 
314 // File: contracts/token/ERC20/ERC20.sol
315 
316 /**
317  * @title ERC20 interface
318  * @dev see https://github.com/ethereum/EIPs/issues/20
319  */
320 contract ERC20 is ERC20Basic {
321   function allowance(address owner, address spender) public view returns (uint256);
322   function transferFrom(address from, address to, uint256 value) public returns (bool);
323   function approve(address spender, uint256 value) public returns (bool);
324   event Approval(address indexed owner, address indexed spender, uint256 value);
325 }
326 
327 // File: contracts/token/ERC20/StandardToken.sol
328 
329 /**
330  * @title Standard ERC20 token
331  *
332  * @dev Implementation of the basic standard token.
333  * @dev https://github.com/ethereum/EIPs/issues/20
334  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
335  */
336 contract StandardToken is ERC20, BasicToken {
337 
338   mapping (address => mapping (address => uint256)) internal allowed;
339 
340 
341   /**
342    * @dev Transfer tokens from one address to another
343    * @param _from address The address which you want to send tokens from
344    * @param _to address The address which you want to transfer to
345    * @param _value uint256 the amount of tokens to be transferred
346    */
347   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
348     require(_to != address(0));
349     require(_value <= balances[_from]);
350     require(_value <= allowed[_from][msg.sender]);
351 
352     balances[_from] = balances[_from].sub(_value);
353     balances[_to] = balances[_to].add(_value);
354     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
355     Transfer(_from, _to, _value);
356     return true;
357   }
358 
359   /**
360    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
361    *
362    * Beware that changing an allowance with this method brings the risk that someone may use both the old
363    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
364    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
365    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
366    * @param _spender The address which will spend the funds.
367    * @param _value The amount of tokens to be spent.
368    */
369   function approve(address _spender, uint256 _value) public returns (bool) {
370     allowed[msg.sender][_spender] = _value;
371     Approval(msg.sender, _spender, _value);
372     return true;
373   }
374 
375   /**
376    * @dev Function to check the amount of tokens that an owner allowed to a spender.
377    * @param _owner address The address which owns the funds.
378    * @param _spender address The address which will spend the funds.
379    * @return A uint256 specifying the amount of tokens still available for the spender.
380    */
381   function allowance(address _owner, address _spender) public view returns (uint256) {
382     return allowed[_owner][_spender];
383   }
384 
385   /**
386    * @dev Increase the amount of tokens that an owner allowed to a spender.
387    *
388    * approve should be called when allowed[_spender] == 0. To increment
389    * allowed value is better to use this function to avoid 2 calls (and wait until
390    * the first transaction is mined)
391    * From MonolithDAO Token.sol
392    * @param _spender The address which will spend the funds.
393    * @param _addedValue The amount of tokens to increase the allowance by.
394    */
395   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
396     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
397     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
398     return true;
399   }
400 
401   /**
402    * @dev Decrease the amount of tokens that an owner allowed to a spender.
403    *
404    * approve should be called when allowed[_spender] == 0. To decrement
405    * allowed value is better to use this function to avoid 2 calls (and wait until
406    * the first transaction is mined)
407    * From MonolithDAO Token.sol
408    * @param _spender The address which will spend the funds.
409    * @param _subtractedValue The amount of tokens to decrease the allowance by.
410    */
411   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
412     uint oldValue = allowed[msg.sender][_spender];
413     if (_subtractedValue > oldValue) {
414       allowed[msg.sender][_spender] = 0;
415     } else {
416       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
417     }
418     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
419     return true;
420   }
421 
422 }
423 
424 // File: contracts/token/ERC20/MintableToken.sol
425 
426 /**
427  * @title Mintable token
428  * @dev Simple ERC20 Token example, with mintable token creation
429  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
430  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
431  */
432 contract MintableToken is StandardToken, Ownable {
433   event Mint(address indexed to, uint256 amount);
434   event MintFinished();
435 
436   bool public mintingFinished = false;
437 
438 
439   modifier canMint() {
440     require(!mintingFinished);
441     _;
442   }
443 
444   /**
445    * @dev Function to mint tokens
446    * @param _to The address that will receive the minted tokens.
447    * @param _amount The amount of tokens to mint.
448    * @return A boolean that indicates if the operation was successful.
449    */
450   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
451     totalSupply_ = totalSupply_.add(_amount);
452     balances[_to] = balances[_to].add(_amount);
453     Mint(_to, _amount);
454     Transfer(address(0), _to, _amount);
455     return true;
456   }
457 
458   /**
459    * @dev Function to stop minting new tokens.
460    * @return True if the operation was successful.
461    */
462   function finishMinting() onlyOwner canMint public returns (bool) {
463     mintingFinished = true;
464     MintFinished();
465     return true;
466   }
467 }
468 
469 // File: contracts/StasyqToken.sol
470 
471 contract StasyqToken is MintableToken {
472 
473   string public constant name = "Stasyq";
474 
475   string public constant symbol = "SQOIN";
476 
477   uint32 public constant decimals = 18;
478 
479   address public saleAgent;
480 
481   mapping (address => uint) public locked;
482 
483   mapping(address => bool)  public registeredCallbacks;
484 
485   modifier canTransfer() {
486     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
487     _;
488   }
489 
490   modifier onlyOwnerOrSaleAgent() {
491     require(msg.sender == owner || msg.sender == saleAgent);
492     _;
493   }
494 
495   function setSaleAgent(address newSaleAgnet) public onlyOwnerOrSaleAgent {
496     saleAgent = newSaleAgnet;
497   }
498 
499   function mint(address _to, uint256 _amount) public onlyOwnerOrSaleAgent canMint returns (bool) {
500     totalSupply_ = totalSupply_.add(_amount);
501     balances[_to] = balances[_to].add(_amount);
502     Mint(_to, _amount);
503     return true;
504   }
505 
506   function finishMinting() public onlyOwnerOrSaleAgent canMint returns (bool) {
507     mintingFinished = true;
508     MintFinished();
509     return true;
510   }
511 
512   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
513     require(locked[msg.sender] < now);
514     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
515   }
516 
517   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
518     require(locked[_from] < now);
519     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
520   }
521 
522   function lock(address addr, uint periodInDays) public {
523     require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
524     locked[addr] = now.add(periodInDays * 1 days);
525   }
526 
527   function registerCallback(address callback) public onlyOwner {
528     registeredCallbacks[callback] = true;
529   }
530 
531   function deregisterCallback(address callback) public onlyOwner {
532     registeredCallbacks[callback] = false;
533   }
534 
535   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
536     if (result && registeredCallbacks[to]) {
537       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
538       targetCallback.tokenFallback(from, value);
539     }
540     return result;
541   }
542 
543 }
544 
545 // File: contracts/CommonSale.sol
546 
547 contract CommonSale is StagedCrowdsale {
548 
549   address public masterWallet;
550 
551   address public slaveWallet;
552 
553   address public directMintAgent;
554 
555   uint public slaveWalletPercent;
556 
557   uint public percentRate = 100;
558 
559   uint public minPrice;
560 
561   uint public totalTokensMinted;
562 
563   StasyqToken public token;
564 
565   modifier onlyDirectMintAgentOrOwner() {
566     require(directMintAgent == msg.sender || owner == msg.sender);
567     _;
568   }
569 
570   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
571     directMintAgent = newDirectMintAgent;
572   }
573 
574   function setMinPrice(uint newMinPrice) public onlyOwner {
575     minPrice = newMinPrice;
576   }
577 
578   function setMasterWallet(address newMasterWallet) public onlyOwner {
579     masterWallet = newMasterWallet;
580   }
581 
582   function setToken(address newToken) public onlyOwner {
583     token = StasyqToken(newToken);
584   }
585 
586   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
587     mintTokens(to, investedWei);
588   }
589 
590   function createTokens() public whenNotPaused payable {
591     require(msg.value >= minPrice);
592     uint masterValue = msg.value.mul(percentRate.sub(slaveWalletPercent)).div(percentRate);
593     uint slaveValue = msg.value.sub(masterValue);
594     masterWallet.transfer(masterValue);
595     slaveWallet.transfer(slaveValue);
596     mintTokens(msg.sender, msg.value);
597   }
598 
599   function mintTokens(address to, uint weiInvested) internal {
600     uint stageIndex = currentStage();
601     Stage storage stage = stages[stageIndex];
602     uint tokens = weiInvested.mul(stage.price);
603     token.mint(this, tokens);
604     token.transfer(to, tokens);
605     totalTokensMinted = totalTokensMinted.add(tokens);
606     totalInvested = totalInvested.add(weiInvested);
607     stage.invested = stage.invested.add(weiInvested);
608     if (stage.invested >= stage.hardcap) {
609       stage.closed = now;
610     }
611   }
612 
613   function() external payable {
614     createTokens();
615   }
616 
617   function retrieveTokens(address anotherToken, address to) public onlyOwner {
618     ERC20 alienToken = ERC20(anotherToken);
619     alienToken.transfer(to, alienToken.balanceOf(this));
620   }
621 
622 
623 }
624 
625 // File: contracts/ITO.sol
626 
627 contract ITO is CommonSale {
628 
629   address public foundersTokensWallet;
630 
631   address public bountyTokensWallet;
632 
633   uint public foundersTokensPercent;
634 
635   uint public bountyTokensPercent;
636 
637   uint public lockPeriod;
638 
639   function ITO() public {
640     addStage(2000,14500);
641     addStage(2000,14000);
642     addStage(2000,13500);
643     addStage(2000,13000);
644     addStage(2000,12500);
645     addStage(2000,12000);
646     addStage(2000,11500);
647     addStage(2000,11000);
648     addStage(2000,10500);
649     addStage(2000,10000);
650     masterWallet = 0x6715Feb90B78d4d7aD92FbaCA7Fd70481e12f836;
651     slaveWallet = 0x8029618Ecb5445B73515d7C51AbB316A91FC7f23;
652     slaveWalletPercent = 50;
653     foundersTokensWallet = 0x05E87Dc9c075256cB94951e0b35C581b93961885;
654     bountyTokensWallet = 0x6715Feb90B78d4d7aD92FbaCA7Fd70481e12f836;
655     start = 1525352400;
656     period = 60;
657     lockPeriod = 90;
658     minPrice = 100000000000000000;
659     foundersTokensPercent = 25;
660     bountyTokensPercent = 5;
661   }
662 
663   function setLockPeriod(uint newLockPeriod) public onlyOwner {
664     lockPeriod = newLockPeriod;
665   }
666 
667   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
668     foundersTokensPercent = newFoundersTokensPercent;
669   }
670 
671   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
672     bountyTokensPercent = newBountyTokensPercent;
673   }
674 
675   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
676     foundersTokensWallet = newFoundersTokensWallet;
677   }
678 
679   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
680     bountyTokensWallet = newBountyTokensWallet;
681   }
682 
683   function finishMinting() public whenNotPaused onlyOwner {
684     uint summaryTokensPercent = bountyTokensPercent.add(foundersTokensPercent);
685     uint mintedTokens = token.totalSupply();
686     uint totalSupply = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
687     uint foundersTokens = totalSupply.mul(foundersTokensPercent).div(percentRate);
688     uint bountyTokens = totalSupply.mul(bountyTokensPercent).div(percentRate);
689     token.mint(this, foundersTokens);
690     token.lock(foundersTokensWallet, lockPeriod);
691     token.transfer(foundersTokensWallet, foundersTokens);
692     token.mint(this, bountyTokens);
693     token.transfer(bountyTokensWallet, bountyTokens);
694     totalTokensMinted = totalTokensMinted.add(foundersTokens).add(bountyTokens);
695     token.finishMinting();
696   }
697 
698 }