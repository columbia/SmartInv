1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
161     uint oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   function () public payable {
172     revert();
173   }
174 
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183   address public owner;
184 
185 
186   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() public {
194     owner = msg.sender;
195   }
196 
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     require(msg.sender == owner);
203     _;
204   }
205 
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) onlyOwner public {
212     require(newOwner != address(0));
213     OwnershipTransferred(owner, newOwner);
214     owner = newOwner;
215   }
216 
217 }
218 
219 contract LockableChanges is Ownable {
220     
221   bool public changesLocked;
222   
223   modifier notLocked() {
224     require(!changesLocked);
225     _;
226   }
227   
228   function lockChanges() public onlyOwner {
229     changesLocked = true;
230   }
231     
232 }
233 
234 /**
235  * @title Mintable token
236  * @dev Simple ERC20 Token example, with mintable token creation
237  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
238  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
239  */
240 contract GENSharesToken is StandardToken, Ownable {	
241 
242   using SafeMath for uint256;
243 
244   event Mint(address indexed to, uint256 amount);
245 
246   event MintFinished();
247     
248   string public constant name = "GEN Shares";
249    
250   string public constant symbol = "GEN";
251     
252   uint32 public constant decimals = 18;
253 
254   bool public mintingFinished = false;
255  
256   address public saleAgent;
257 
258   modifier notLocked() {
259     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
260     _;
261   }
262 
263   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
264     return super.transfer(_to, _value);
265   }
266 
267   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
268     return super.transferFrom(from, to, value);
269   }
270 
271   function setSaleAgent(address newSaleAgent) public {
272     require(saleAgent == msg.sender || owner == msg.sender);
273     saleAgent = newSaleAgent;
274   }
275 
276   function mint(address _to, uint256 _amount) public returns (bool) {
277     require(!mintingFinished);
278     require(msg.sender == saleAgent);
279     totalSupply = totalSupply.add(_amount);
280     balances[_to] = balances[_to].add(_amount);
281     Mint(_to, _amount);
282     Transfer(address(0), _to, _amount);
283     return true;
284   }
285 
286   function finishMinting() public returns (bool) {
287     require(!mintingFinished);
288     require(msg.sender == owner || msg.sender == saleAgent);
289     mintingFinished = true;
290     MintFinished();
291     return true;
292   }
293 
294 }
295 
296 contract CommonCrowdsale is Ownable, LockableChanges {
297 
298   using SafeMath for uint256;
299 
300   uint public constant PERCENT_RATE = 100;
301 
302   uint public price;
303 
304   uint public minInvestedLimit;
305 
306   uint public hardcap;
307 
308   uint public start;
309 
310   uint public end;
311 
312   uint public invested;
313 
314   uint public minted;
315   
316   address public wallet;
317 
318   address public bountyTokensWallet;
319 
320   address public devTokensWallet;
321 
322   address public advisorsTokensWallet;
323 
324   uint public bountyTokensPercent;
325 
326   uint public devTokensPercent;
327 
328   uint public advisorsTokensPercent;
329 
330   struct Bonus {
331     uint periodInDays;
332     uint bonus;
333   }
334 
335   Bonus[] public bonuses;
336 
337   GENSharesToken public token;
338 
339   modifier saleIsOn() {
340     require(msg.value >= minInvestedLimit && now >= start && now < end && invested < hardcap);
341     _;
342   }
343 
344   function setHardcap(uint newHardcap) public onlyOwner notLocked { 
345     hardcap = newHardcap;
346   }
347  
348   function setStart(uint newStart) public onlyOwner notLocked { 
349     start = newStart;
350   }
351 
352   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner notLocked { 
353     bountyTokensPercent = newBountyTokensPercent;
354   }
355 
356   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner notLocked { 
357     advisorsTokensPercent = newAdvisorsTokensPercent;
358   }
359 
360   function setDevTokensPercent(uint newDevTokensPercent) public onlyOwner notLocked { 
361     devTokensPercent = newDevTokensPercent;
362   }
363 
364   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner notLocked { 
365     bountyTokensWallet = newBountyTokensWallet;
366   }
367 
368   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner notLocked { 
369     advisorsTokensWallet = newAdvisorsTokensWallet;
370   }
371 
372   function setDevTokensWallet(address newDevTokensWallet) public onlyOwner notLocked { 
373     devTokensWallet = newDevTokensWallet;
374   }
375 
376   function setEnd(uint newEnd) public onlyOwner notLocked { 
377     require(start < newEnd);
378     end = newEnd;
379   }
380 
381   function setToken(address newToken) public onlyOwner notLocked { 
382     token = GENSharesToken(newToken);
383   }
384 
385   function setWallet(address newWallet) public onlyOwner notLocked { 
386     wallet = newWallet;
387   }
388 
389   function setPrice(uint newPrice) public onlyOwner notLocked {
390     price = newPrice;
391   }
392 
393   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner notLocked {
394     minInvestedLimit = newMinInvestedLimit;
395   }
396  
397   function bonusesCount() public constant returns(uint) {
398     return bonuses.length;
399   }
400 
401   function addBonus(uint limit, uint bonus) public onlyOwner notLocked {
402     bonuses.push(Bonus(limit, bonus));
403   }
404 
405   function mintExtendedTokens() internal {
406     uint extendedTokensPercent = bountyTokensPercent.add(devTokensPercent).add(advisorsTokensPercent);      
407     uint extendedTokens = minted.mul(extendedTokensPercent).div(PERCENT_RATE.sub(extendedTokensPercent));
408     uint summaryTokens = extendedTokens + minted;
409 
410     uint bountyTokens = summaryTokens.mul(bountyTokensPercent).div(PERCENT_RATE);
411     mintAndSendTokens(bountyTokensWallet, bountyTokens);
412 
413     uint advisorsTokens = summaryTokens.mul(advisorsTokensPercent).div(PERCENT_RATE);
414     mintAndSendTokens(advisorsTokensWallet, advisorsTokens);
415 
416     uint devTokens = extendedTokens.sub(advisorsTokens).sub(bountyTokens);
417     mintAndSendTokens(devTokensWallet, devTokens);
418   }
419 
420   function mintAndSendTokens(address to, uint amount) internal {
421     token.mint(to, amount);
422     minted = minted.add(amount);
423   }
424 
425   function calculateAndTransferTokens() internal {
426     // update invested value
427     invested = invested.add(msg.value);
428 
429     // calculate tokens
430     uint tokens = msg.value.mul(price).div(1 ether);
431     uint bonus = getBonus();
432     if(bonus > 0) {
433       tokens = tokens.add(tokens.mul(bonus).div(100));      
434     }
435     
436     // transfer tokens
437     mintAndSendTokens(msg.sender, tokens);
438   }
439 
440   function getBonus() public constant returns(uint) {
441     uint prevTimeLimit = start;
442     for (uint i = 0; i < bonuses.length; i++) {
443       Bonus storage bonus = bonuses[i];
444       prevTimeLimit += bonus.periodInDays * 1 days;
445       if (now < prevTimeLimit)
446         return bonus.bonus;
447     }
448     return 0;
449   }
450 
451   function createTokens() public payable;
452 
453   function() external payable {
454     createTokens();
455   }
456 
457   function retrieveTokens(address anotherToken) public onlyOwner {
458     ERC20 alienToken = ERC20(anotherToken);
459     alienToken.transfer(wallet, token.balanceOf(this));
460   }
461 
462 }
463 
464 contract Presale is CommonCrowdsale {
465   
466   uint public devLimit;
467 
468   uint public softcap;
469   
470   bool public refundOn;
471 
472   bool public softcapAchieved;
473 
474   bool public devWithdrawn;
475 
476   address public devWallet;
477 
478   address public nextSaleAgent;
479 
480   mapping (address => uint) public balances;
481 
482   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner notLocked {
483     nextSaleAgent = newNextSaleAgent;
484   }
485 
486   function setSoftcap(uint newSoftcap) public onlyOwner notLocked {
487     softcap = newSoftcap;
488   }
489 
490   function setDevWallet(address newDevWallet) public onlyOwner notLocked {
491     devWallet = newDevWallet;
492   }
493 
494   function setDevLimit(uint newDevLimit) public onlyOwner notLocked {
495     devLimit = newDevLimit;
496   }
497 
498   function refund() public {
499     require(now > start && refundOn && balances[msg.sender] > 0);
500     uint value = balances[msg.sender];
501     balances[msg.sender] = 0;
502     msg.sender.transfer(value);
503   } 
504 
505   function createTokens() public payable saleIsOn {
506     balances[msg.sender] = balances[msg.sender].add(msg.value);
507     calculateAndTransferTokens();
508     if(!softcapAchieved && invested >= softcap) {
509       softcapAchieved = true;      
510     }
511   } 
512 
513   function widthrawDev() public {
514     require(softcapAchieved);
515     require(devWallet == msg.sender || owner == msg.sender);
516     if(!devWithdrawn) {
517       devWithdrawn = true;
518       devWallet.transfer(devLimit);
519     }
520   } 
521 
522   function widthraw() public {
523     require(softcapAchieved);
524     require(owner == msg.sender);
525     widthrawDev();
526     wallet.transfer(this.balance);
527   } 
528 
529   function finishMinting() public onlyOwner {
530     if(!softcapAchieved) {
531       refundOn = true;      
532       token.finishMinting();
533     } else {
534       mintExtendedTokens();
535       token.setSaleAgent(nextSaleAgent);
536     }    
537   }
538 
539 }
540 
541 contract ICO is CommonCrowdsale {
542   
543   function finishMinting() public onlyOwner {
544     mintExtendedTokens();
545     token.finishMinting();
546   }
547 
548   function createTokens() public payable saleIsOn {
549     calculateAndTransferTokens();
550     wallet.transfer(msg.value);
551   } 
552 
553 }
554 
555 contract Deployer is Ownable {
556 
557   Presale public presale;  
558  
559   ICO public ico;
560 
561   GENSharesToken public token;
562 
563   function deploy() public onlyOwner {
564     owner = 0x379264aF7df7CF8141a23bC989aa44266DDD2c62;  
565       
566     token = new GENSharesToken();
567     
568     presale = new Presale();
569     presale.setToken(token);
570     token.setSaleAgent(presale);
571     presale.setMinInvestedLimit(100000000000000000);  
572     presale.setPrice(250000000000000000000);
573     presale.setBountyTokensPercent(4);
574     presale.setAdvisorsTokensPercent(2);
575     presale.setDevTokensPercent(10);
576     presale.setSoftcap(40000000000000000000);
577     presale.setHardcap(50000000000000000000000);
578     presale.addBonus(7,50);
579     presale.addBonus(7,40);
580     presale.addBonus(100,35);
581     presale.setStart(1511571600);
582     presale.setEnd(1514156400);    
583     presale.setDevLimit(6000000000000000000);
584     presale.setWallet(0x4bB656423f5476FeC4AA729aB7B4EE0fc4d0B314);
585     presale.setBountyTokensWallet(0xcACBE5d8Fb017407907026804Fe8BE64B08511f4);
586     presale.setDevTokensWallet(0xa20C62282bEC52F9dA240dB8cFFc5B2fc8586652);
587     presale.setAdvisorsTokensWallet(0xD3D85a495c7E25eAd39793F959d04ACcDf87e01b);
588     presale.setDevWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
589 
590     ico = new ICO();
591     ico.setToken(token); 
592     presale.setNextSaleAgent(ico);
593     ico.setMinInvestedLimit(100000000000000000);
594     ico.setPrice(250000000000000000000);
595     ico.setBountyTokensPercent(4);
596     ico.setAdvisorsTokensPercent(2);
597     ico.setDevTokensPercent(10);
598 
599     ico.setHardcap(206000000000000000000000);
600     ico.addBonus(7,25);
601     ico.addBonus(7,10);
602     ico.setStart(1514163600);
603     ico.setEnd(1517356800);
604     ico.setWallet(0x65954fb8f45b40c9A60dffF3c8f4F39839Bf3596);
605     ico.setBountyTokensWallet(0x6b9f45A54cDe417640f7D49D13451D7e2e9b8918);
606     ico.setDevTokensWallet(0x55A9E5b55F067078E045c72088C3888Bbcd9a64b);
607     ico.setAdvisorsTokensWallet(0x3e11Ff0BDd160C1D85cdf04e012eA9286ae1A964);
608 
609     presale.lockChanges();
610     ico.lockChanges();
611     
612     presale.transferOwnership(owner);
613     ico.transferOwnership(owner);
614     token.transferOwnership(owner);
615   }
616 
617 }