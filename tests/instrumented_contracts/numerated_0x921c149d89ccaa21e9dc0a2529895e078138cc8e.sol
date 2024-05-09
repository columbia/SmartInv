1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of. 
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157     
158   address public owner;
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   function Ownable() {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     require(newOwner != address(0));      
182     owner = newOwner;
183   }
184 
185 }
186 
187 /**
188  * @title Mintable token
189  * @dev Simple ERC20 Token example, with mintable token creation
190  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
191  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
192  */
193 
194 contract MintableToken is StandardToken, Ownable {
195     
196   event Mint(address indexed to, uint256 amount);
197   
198   event MintFinished();
199 
200   bool public mintingFinished = false;
201 
202   modifier canMint() {
203     require(!mintingFinished);
204     _;
205   }
206 
207   /**
208    * @dev Function to mint tokens
209    * @param _to The address that will recieve the minted tokens.
210    * @param _amount The amount of tokens to mint.
211    * @return A boolean that indicates if the operation was successful.
212    */
213   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
214     totalSupply = totalSupply.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     Mint(_to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229   
230 }
231 
232 /**
233  * @title Pausable
234  * @dev Base contract which allows children to implement an emergency stop mechanism.
235  */
236 contract Pausable is Ownable {
237     
238   event Pause();
239   
240   event Unpause();
241 
242   bool public paused = false;
243 
244   /**
245    * @dev modifier to allow actions only when the contract IS paused
246    */
247   modifier whenNotPaused() {
248     require(!paused);
249     _;
250   }
251 
252   /**
253    * @dev modifier to allow actions only when the contract IS NOT paused
254    */
255   modifier whenPaused() {
256     require(paused);
257     _;
258   }
259 
260   /**
261    * @dev called by the owner to pause, triggers stopped state
262    */
263   function pause() onlyOwner whenNotPaused {
264     paused = true;
265     Pause();
266   }
267 
268   /**
269    * @dev called by the owner to unpause, returns to normal state
270    */
271   function unpause() onlyOwner whenPaused {
272     paused = false;
273     Unpause();
274   }
275   
276 }
277 
278 contract SGAToken is MintableToken {	
279     
280   string public constant name = "SGA Token";
281    
282   string public constant symbol = "SGA";
283     
284   uint32 public constant decimals = 18;
285 
286   bool public transferAllowed = false;
287 
288   modifier whenTransferAllowed() {
289     require(transferAllowed || msg.sender == owner);
290     _;
291   }
292 
293   function allowTransfer() onlyOwner {
294     transferAllowed = true;
295   }
296 
297   function transfer(address _to, uint256 _value) whenTransferAllowed returns (bool) {
298     return super.transfer(_to, _value);
299   }
300 
301   function transferFrom(address _from, address _to, uint256 _value) whenTransferAllowed returns (bool) {
302     return super.transferFrom(_from, _to, _value);
303   }
304     
305 }
306 
307 
308 contract PurchaseBonusCrowdsale is Pausable {
309 
310   using SafeMath for uint;
311 
312   struct Bonus {
313     uint limit;
314     uint bonus;
315   }
316  
317   Bonus[] public bonuses;
318 
319   function bonusesCount() constant returns(uint) {
320     return bonuses.length;
321   }
322 
323   function addBonus(uint limit, uint bonus) onlyOwner {
324     bonuses.push(Bonus(limit, bonus));
325   }
326 
327   function removeBonus(uint8 number) onlyOwner {
328     require(number < bonuses.length);
329 
330     delete bonuses[number];
331 
332     for (uint i = number; i < bonuses.length - 1; i++) {
333       bonuses[i] = bonuses[i+1];
334     }
335 
336     bonuses.length--;
337   }
338 
339   function changeBonus(uint8 number, uint limit, uint bonusValue) onlyOwner {
340     require(number < bonuses.length);
341     Bonus storage bonus = bonuses[number];
342 
343     bonus.limit = limit;
344     bonus.bonus = bonusValue;
345   }
346 
347   function insertBonus(uint8 numberAfter, uint limit, uint bonus) onlyOwner {
348     require(numberAfter < bonuses.length);
349 
350     bonuses.length++;
351 
352     for (uint i = bonuses.length - 2; i > numberAfter; i--) {
353       bonuses[i + 1] = bonuses[i];
354     }
355 
356     bonuses[numberAfter + 1] = Bonus(limit, bonus);
357   }
358 
359   function clearBonuses() onlyOwner {
360     require(bonuses.length > 0);
361     for (uint i = 0; i < bonuses.length; i++) {
362       delete bonuses[i];
363     }
364     bonuses.length -= bonuses.length;
365   }
366 
367   function getBonus(uint value) constant returns(uint) {
368     uint targetBonus = 0;
369     if(value < bonuses[0].limit)
370       return 0;
371     for (uint i = bonuses.length; i > 0; i--) {
372       Bonus storage bonus = bonuses[i - 1];
373       if (value >= bonus.limit)
374         return bonus.bonus;
375       else
376         targetBonus = bonus.bonus;
377     }
378     return targetBonus;
379   }
380 
381 }
382 
383 contract Crowdsale is PurchaseBonusCrowdsale {
384 
385   uint public start;
386 
387   uint public period;
388 
389   uint public invested;
390 
391   uint public hardCap;
392   
393   uint public softCap;
394 
395   address public multisigWallet;
396 
397   address public secondWallet;
398   
399   address public foundersTokensWallet;
400   
401   uint public secondWalletPercent;
402 
403   uint public foundersTokensPercent;
404   
405   uint public price;
406   
407   uint public minPrice;
408 
409   uint public percentRate = 1000;
410 
411   bool public refundOn = false;
412   
413   mapping (address => uint) public balances;
414 
415   SGAToken public token = new SGAToken();
416 
417   function Crowdsale() {
418     period = 60;
419     price = 3000;
420     minPrice = 50000000000000000;
421     start = 1505998800;
422     hardCap = 186000000000000000000000;
423     softCap =  50000000000000000000000;
424     foundersTokensPercent = 202;
425     foundersTokensWallet = 0x839D81F27B870632428fab6ae9c5903936a4E5aE;
426     multisigWallet = 0x0CeeD87a6b8ac86938B6c2d1a0fA2B2e9000Cf6c;
427     secondWallet = 0x949e62320992D5BD123B4616d2E2769473101AbB;
428     secondWalletPercent = 10;
429     addBonus(1000000000000000000,5);
430     addBonus(2000000000000000000,10);
431     addBonus(3000000000000000000,15);
432     addBonus(5000000000000000000,20);
433     addBonus(7000000000000000000,25);
434     addBonus(10000000000000000000,30);
435     addBonus(15000000000000000000,35);
436     addBonus(20000000000000000000,40);
437     addBonus(50000000000000000000,45);
438     addBonus(75000000000000000000,50);
439     addBonus(100000000000000000000,55);
440     addBonus(150000000000000000000,60);
441     addBonus(200000000000000000000,70);
442     addBonus(300000000000000000000,75);
443     addBonus(500000000000000000000,80);
444     addBonus(750000000000000000000,90);
445     addBonus(1000000000000000000000,100);
446     addBonus(1500000000000000000000,110);
447     addBonus(2000000000000000000000,125);
448     addBonus(3000000000000000000000,140);
449   }
450 
451   modifier saleIsOn() {
452     require(now >= start && now < lastSaleDate());
453     _;
454   }
455   
456   modifier isUnderHardCap() {
457     require(invested <= hardCap);
458     _;
459   }
460   
461   function lastSaleDate() constant returns(uint) {
462     return start + period * 1 days;
463   }
464 
465   function setStart(uint newStart) onlyOwner {
466     start = newStart;
467   }
468   
469   function setMinPrice(uint newMinPrice) onlyOwner {
470     minPrice = newMinPrice;
471   }
472 
473   function setHardcap(uint newHardcap) onlyOwner {
474     hardCap = newHardcap;
475   }
476 
477   function setPrice(uint newPrice) onlyOwner {
478     price = newPrice;
479   }
480 
481   function setFoundersTokensPercent(uint newFoundersTokensPercent) onlyOwner {
482     foundersTokensPercent = newFoundersTokensPercent;
483   }
484 
485   function setSoftcap(uint newSoftcap) onlyOwner {
486     softCap = newSoftcap;
487   }
488 
489   function setSecondWallet(address newSecondWallet) onlyOwner {
490     secondWallet = newSecondWallet;
491   }
492   
493   function setSecondWalletPercent(uint newSecondWalletPercent) onlyOwner {
494     secondWalletPercent = newSecondWalletPercent;
495   }
496 
497   function setMultisigWallet(address newMultisigWallet) onlyOwner {
498     multisigWallet = newMultisigWallet;
499   }
500 
501   function setFoundersTokensWallet(address newFoundersTokensWallet) onlyOwner {
502     foundersTokensWallet = newFoundersTokensWallet;
503   }
504 
505   function createTokens() whenNotPaused isUnderHardCap saleIsOn payable {
506     require(msg.value >= minPrice);
507     balances[msg.sender] = balances[msg.sender].add(msg.value);
508     invested = invested.add(msg.value);
509     uint bonusPercent = getBonus(msg.value);
510     uint tokens = msg.value.mul(price);
511     uint bonusTokens = tokens.mul(bonusPercent).div(percentRate);
512     uint tokensWithBonus = tokens.add(bonusTokens);
513     token.mint(this, tokensWithBonus);
514     token.transfer(msg.sender, tokensWithBonus);
515   }
516 
517   function refund() whenNotPaused {
518     require(now > start && refundOn && balances[msg.sender] > 0);
519     msg.sender.transfer(balances[msg.sender]);
520   } 
521 
522   function finishMinting() public whenNotPaused onlyOwner {
523     if(invested < softCap) {
524       refundOn = true;      
525     } else {
526       uint secondWalletInvested = invested.mul(secondWalletPercent).div(percentRate);
527       secondWallet.transfer(secondWalletInvested);
528       multisigWallet.transfer(invested - secondWalletInvested);    
529       uint issuedTokenSupply = token.totalSupply();
530       uint foundersTokens = issuedTokenSupply.mul(foundersTokensPercent).div(percentRate - foundersTokensPercent);
531       token.mint(this, foundersTokens);
532       token.allowTransfer();
533       token.transfer(foundersTokensWallet, foundersTokens);
534     }
535     token.finishMinting();
536     token.transferOwnership(owner);
537   }
538 
539   function() external payable {
540     createTokens();
541   }
542 
543   function retrieveTokens(address anotherToken) public onlyOwner {
544     ERC20 alienToken = ERC20(anotherToken);
545     alienToken.transfer(multisigWallet, token.balanceOf(this));
546   }
547 
548 }