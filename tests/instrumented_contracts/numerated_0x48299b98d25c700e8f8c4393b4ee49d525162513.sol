1 pragma solidity ^0.4.11;
2 
3 /*
4   Set of classes OpenZeppelin
5 */
6 
7 /*
8 *****************************************************************************************
9 
10 below is 'OpenZeppelin  - Ownable.sol'
11 
12 */
13 
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20   address public owner;
21 
22 
23   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() {
31     owner = msg.sender;
32   }
33 
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) onlyOwner public {
49     require(newOwner != address(0));
50     OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54 }
55 
56 
57 
58 
59 
60 /*
61 *****************************************************************************************
62 below is 'OpenZeppelin  - ERC20Basic.sol'
63 
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Basic {
69   uint256 public totalSupply;
70   function balanceOf(address who) public constant returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 
76 /*
77 *****************************************************************************************
78 below is 'OpenZeppelin  - BasicToken.sol'
79 
80 */
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicFrozenToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89   
90     /**
91    * @dev mapping sender -> unfrozeTimestamp
92    * when sender is unfrozen
93    */
94   mapping(address => uint256) unfrozeTimestamp;
95 
96     // Custom code - checking for on frozen
97   // @return true if the sending is allowed (not frozen)
98   function isUnfrozen(address sender) public constant returns (bool) {
99     // frozeness is checked until  07.07.18 00:00:00 (1530921600), after all tokens are minted as unfrozen
100     if(now > 1530921600)
101       return true;
102     else
103      return unfrozeTimestamp[sender] < now;
104   }
105 
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function frozenTimeOf(address _owner) public constant returns (uint256 balance) {
113     return unfrozeTimestamp[_owner];
114   }
115 
116   /**
117   * @dev transfer token for a specified address
118   * @param _to The address to transfer to.
119   * @param _value The amount to be transferred.
120   */
121   function transfer(address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[msg.sender]);
124     
125     // Custom code - checking for frozen state
126     require(isUnfrozen(msg.sender));
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135 
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of.
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) public constant returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 
149 
150 /*
151 *****************************************************************************************
152 below is 'OpenZeppelin  - ERC20.sol'
153 
154 */
155 
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender) public constant returns (uint256);
163   function transferFrom(address from, address to, uint256 value) public returns (bool);
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 
169 
170 
171 /*
172 *****************************************************************************************
173 
174 below is 'OpenZeppelin  - StandardToken.sol'
175 
176 */
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicFrozenToken {
186 
187   mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200     
201     // Custom code - проверка на факт разморозки
202     require(isUnfrozen(_from));
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    */
243   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 
263 
264 
265 
266 /*
267 *****************************************************************************************
268 below is 'OpenZeppelin  - SafeMath.sol'
269  * @title SafeMath
270  * @dev Math operations with safety checks that throw on error
271  */
272 library SafeMath {
273   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
274     uint256 c = a * b;
275     assert(a == 0 || c / a == b);
276     return c;
277   }
278 
279   function div(uint256 a, uint256 b) internal constant returns (uint256) {
280     // assert(b > 0); // Solidity automatically throws when dividing by 0
281     uint256 c = a / b;
282     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283     return c;
284   }
285 
286   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
287     assert(b <= a);
288     return a - b;
289   }
290 
291   function add(uint256 a, uint256 b) internal constant returns (uint256) {
292     uint256 c = a + b;
293     assert(c >= a);
294     return c;
295   }
296 }
297 
298 
299 /**
300  * @title Quasacoin token
301  * Based on code by OpenZeppelin MintableToken.sol
302  
303   + added frozing when minting
304  
305  */
306 
307 contract QuasacoinToken is StandardToken, Ownable {
308     
309   string public name = "Quasacoin";
310   string public symbol = "QUA";
311   uint public decimals = 18;
312   
313   event Mint(address indexed to, uint256 amount);
314   event MintFinished();
315 
316   bool public mintingFinished = false;
317 
318   modifier canMint() {
319     require(!mintingFinished);
320     _;
321   }
322 
323   /**
324    * @dev Function to mint tokens
325    * @param _to The address that will receive the minted tokens.
326    * @param _amount The amount of tokens to mint.
327    * @return A boolean that indicates if the operation was successful.
328    */
329   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
330     require(_to != address(0));
331     require(_amount > 0);
332 
333     totalSupply = totalSupply.add(_amount);
334     balances[_to] = balances[_to].add(_amount);
335 
336     uint frozenTime = 0; 
337     // frozeness is checked until  07.07.18 00:00:00 (1530921600), after all tokens are minted as unfrozen
338     if(now < 1530921600) {
339       // выпуск                      до 15.01.18 00:00:00 (1515974400) - заморозка до 30.03.18 00:00:00 (1522368000)
340       if(now < 1515974400)
341         frozenTime = 1522368000;
342 
343       // выпуск c 15.01.18 00:00:00  до 15.02.18 00:00:00 (1518652800) - заморозка до 30.05.18 00:00:00 (1527638400)     
344       else if(now < 1518652800)
345         frozenTime = 1527638400;
346 
347       // выпуск c 15.02.18 00:00:00  до 26.03.18 00:00:00 (1522022400) - заморозка до 30.06.18 00:00:00 (1530316800)
348       else if(now < 1522022400)
349         frozenTime = 1530316800;
350 
351       // выпуск c 26.03.18 00:00:00  до 15.04.18 00:00:00 (1523750400) - заморозка до 01.07.18 00:00:00 (1530403200)
352       else if(now < 1523750400)
353         frozenTime = 1530403200;
354 
355       // выпуск c 15.04.18 00:00:00  до 15.05.18 00:00:00 (1526342400) - заморозка до 07.07.18 00:00:00 (1530921600)
356       else if(now < 1526342400)
357         frozenTime = 1530921600;
358 
359       // выпуск c 15.05.18 00:00:00  до 15.06.18 00:00:00 (1529020800) - заморозка до 30.06.18 00:00:00 (1530316800)
360       else if(now < 1529020800)
361         frozenTime = 1530316800;
362       else 
363       // выпуск с 15.06.18 00:00:00  после до 07.07.18 00:00:00 (1530921600) - заморозка до 07.07.18 00:00:00 (1530921600)
364         frozenTime = 1530921600;
365       unfrozeTimestamp[_to] = frozenTime;
366     }
367 
368     Mint(_to, _amount);
369     Transfer(0x0, _to, _amount);
370     return true;
371   }
372 
373   /**
374    * @dev Function to stop minting new tokens.
375    * @return True if the operation was successful.
376    */
377   function finishMinting() onlyOwner public returns (bool) {
378     mintingFinished = true;
379     MintFinished();
380     return true;
381   }
382 }
383 
384 
385 /**
386  * @title QuasocoinCrowdsale
387  * based upon OpenZeppelin CrowdSale smartcontract
388  */
389 contract QuasacoinTokenCrowdsale {
390   using SafeMath for uint256;
391 
392   // The token being sold
393   QuasacoinToken public token;
394 
395   // start and end timestamps where investments are allowed (both inclusive)
396   uint256 public startPreICOTime;
397   // переход из preICO в ICO
398   uint256 public startICOTime;
399   uint256 public endTime;
400 
401   // address where funds are collected
402   address public wallet;
403 
404   // кому вернуть ownership после завершения ICO
405   address public tokenOwner;
406 
407   // how many token units a buyer gets per wei
408   uint256 public ratePreICO;
409   uint256 public rateICO;
410 
411   // amount of raised money in wei
412   uint256 public weiRaisedPreICO;
413   uint256 public weiRaisedICO;
414 
415   uint256 public capPreICO;
416   uint256 public capICO;
417 
418   mapping(address => bool) internal allowedMinters;
419 
420   /**
421    * event for token purchase logging
422    * @param purchaser who paid for the tokens
423    * @param beneficiary who got the tokens
424    * @param value weis paid for purchase
425    * @param amount amount of tokens purchased
426    */
427   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
428 
429   function QuasacoinTokenCrowdsale() {
430     token = QuasacoinToken(0x4dAeb4a06F70f4b1A5C329115731fE4b89C0B227);
431     tokenOwner = 0x373ae730d8c4250b3d022a65ef998b8b7ab1aa53;
432     wallet = 0x373ae730d8c4250b3d022a65ef998b8b7ab1aa53;
433 
434     // 15.01.18 00:00:00 (1515974400) 
435     startPreICOTime = 1515974400;
436     // 15.02.18 00:00:00 (1518652800)
437     startICOTime = 1518652800;
438     // 26.03.18 00:00:00 (1522022400)
439     endTime = 1522022400;
440     
441     // Pre-ICO, 1 ETH = 6000 QUA
442     ratePreICO = 6000;
443 
444     // ICO, 1 ETH = 3000 QUA
445     rateICO = 3000;
446 
447     capPreICO = 5000 ether;
448     capICO = 50000 ether;
449   }
450 
451   // fallback function can be used to buy tokens
452   function () payable {
453     buyTokens(msg.sender);
454   }
455 
456   // low level token purchase function
457   function buyTokens(address beneficiary) public payable {
458     require(beneficiary != 0x0);
459     require(validPurchase());
460 
461     uint256 weiAmount = msg.value;
462 
463     // calculate token amount to be created
464     uint256 tokens;
465     if(now < startICOTime) {  
466       weiRaisedPreICO = weiRaisedPreICO.add(weiAmount);
467       tokens = weiAmount * ratePreICO;
468     } 
469     else {
470       weiRaisedICO = weiRaisedICO.add(weiAmount);
471       tokens = weiAmount * rateICO;
472     }
473 
474     token.mint(beneficiary, tokens);
475     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
476 
477     forwardFunds();
478   }
479 
480   // send ether to the fund collection wallet
481   // override to create custom fund forwarding mechanisms
482   function forwardFunds() internal {
483     wallet.transfer(msg.value);
484   }
485 
486   // @return true if the transaction can buy tokens
487   function validPurchase() internal constant returns (bool) {
488    
489     if(now >= startPreICOTime && now < startICOTime) {
490       return weiRaisedPreICO.add(msg.value) <= capPreICO;
491     } else if(now >= startICOTime && now < endTime) {
492       return weiRaisedICO.add(msg.value) <= capICO;
493     } else
494     return false;
495   }
496 
497   // @return true if crowdsale event has ended
498   function hasEnded() public constant returns (bool) {
499     if(now < startPreICOTime)
500       return false;
501     else if(now >= startPreICOTime && now < startICOTime) {
502       return weiRaisedPreICO >= capPreICO;
503     } else if(now >= startICOTime && now < endTime) {
504       return weiRaisedICO >= capICO;
505     } else
506       return true;
507   }
508 
509   function returnTokenOwnership() public {
510     require(msg.sender == tokenOwner);
511     token.transferOwnership(tokenOwner);
512   }
513 
514   function addMinter(address addr) {
515     require(msg.sender == tokenOwner);
516     allowedMinters[addr] = true;
517   }
518   function removeMinter(address addr) {
519     require(msg.sender == tokenOwner);
520     allowedMinters[addr] = false;
521   }
522 
523   function mintProxyWithoutCap(address _to, uint256 _amount) public {
524     require(allowedMinters[msg.sender]);
525     token.mint(_to, _amount);
526   }
527 
528   function mintProxy(address _to, uint256 _amount) public {
529     require(allowedMinters[msg.sender]);
530     require(now >= startPreICOTime && now < endTime);
531     
532     uint256 weiAmount;
533 
534     if(now < startICOTime) {
535       weiAmount = _amount.div(ratePreICO);
536       require(weiRaisedPreICO.add(weiAmount) <= capPreICO);
537       weiRaisedPreICO = weiRaisedPreICO.add(weiAmount);
538     } 
539     else {
540       weiAmount = _amount.div(rateICO);
541       require(weiRaisedICO.add(weiAmount) <= capICO);
542       weiRaisedICO = weiRaisedICO.add(weiAmount);
543     }
544 
545     token.mint(_to, _amount);
546     TokenPurchase(msg.sender, _to, weiAmount, _amount);
547   }
548 }