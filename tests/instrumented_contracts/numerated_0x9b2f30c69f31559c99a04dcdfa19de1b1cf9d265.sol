1 /**
2  *
3  * MIT License
4  *
5  * Copyright (c) 2018, TOPEX Developers & OpenZeppelin Project.
6  *
7  * Permission is hereby granted, free of charge, to any person obtaining a copy
8  * of this software and associated documentation files (the "Software"), to deal
9  * in the Software without restriction, including without limitation the rights
10  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11  * copies of the Software, and to permit persons to whom the Software is
12  * furnished to do so, subject to the following conditions:
13  *
14  * The above copyright notice and this permission notice shall be included in all
15  * copies or substantial portions of the Software.
16  *
17  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
18  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
19  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
20  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
21  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
22  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
23  * SOFTWARE.
24  *
25  */
26 
27 pragma solidity ^0.4.24;
28 
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 library SafeERC20 {
59   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
60     assert(token.transfer(to, value));
61   }
62 
63   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
64     assert(token.transferFrom(from, to, value));
65   }
66 
67   function safeApprove(ERC20 token, address spender, uint256 value) internal {
68     assert(token.approve(spender, value));
69   }
70 }
71 
72 contract Ownable {
73   address public owner;
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   constructor() public {
82     owner = msg.sender;
83   }
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));
100     emit OwnershipTransferred(owner, newOwner);
101     owner = newOwner;
102   }
103 }
104 
105 contract Destructible is Ownable {
106 
107   constructor() public payable { }
108 
109   /**
110    * @dev Transfers the current balance to the owner and terminates the contract.
111    */
112   function destroy() onlyOwner public {
113     selfdestruct(owner);
114   }
115 
116   function destroyAndSend(address _recipient) onlyOwner public {
117     selfdestruct(_recipient);
118   }
119 }
120 
121 contract CanReclaimToken is Ownable {
122   using SafeERC20 for ERC20Basic;
123 
124   /**
125    * @dev Reclaim all ERC20Basic compatible tokens
126    * @param token ERC20Basic The address of the token contract
127    */
128   function reclaimToken(ERC20Basic token) external onlyOwner {
129     uint256 balance = token.balanceOf(this);
130     token.safeTransfer(owner, balance);
131   }
132 }
133 
134 contract ERC20Basic {
135   uint256 public totalSupply;
136   function balanceOf(address who) public view returns (uint256);
137   function transfer(address to, uint256 value) public returns (bool);
138   event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender) public view returns (uint256);
143   function transferFrom(address from, address to, uint256 value) public returns (bool);
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     // SafeMath.sub will throw if there is not enough balance.
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     emit Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256 balance) {
175     return balances[_owner];
176   }
177 }
178 
179 contract StandardToken is ERC20, BasicToken {
180 
181   mapping (address => mapping (address => uint256)) internal allowed;
182 
183   /**
184    * @dev Transfer tokens from one address to another
185    * @param _from address The address which you want to send tokens from
186    * @param _to address The address which you want to transfer to
187    * @param _value uint256 the amount of tokens to be transferred
188    */
189   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[_from]);
192     require(_value <= allowed[_from][msg.sender]);
193 
194     balances[_from] = balances[_from].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
197     emit Transfer(_from, _to, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    *
204    * Beware that changing an allowance with this method brings the risk that someone may use both the old
205    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208    * @param _spender The address which will spend the funds.
209    * @param _value The amount of tokens to be spent.
210    */
211   function approve(address _spender, uint256 _value) public returns (bool) {
212     allowed[msg.sender][_spender] = _value;
213     emit Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Function to check the amount of tokens that an owner allowed to a spender.
219    * @param _owner address The address which owns the funds.
220    * @param _spender address The address which will spend the funds.
221    * @return A uint256 specifying the amount of tokens still available for the spender.
222    */
223   function allowance(address _owner, address _spender) public view returns (uint256) {
224     return allowed[_owner][_spender];
225   }
226 
227   /**
228    * @dev Increase the amount of tokens that an owner allowed to a spender.
229    *
230    * approve should be called when allowed[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _addedValue The amount of tokens to increase the allowance by.
236    */
237   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
238     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243   /*
244    * @dev Decrease the amount of tokens that an owner allowed to a spender.
245    *
246    * approve should be called when allowed[_spender] == 0. To decrement
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param _spender The address which will spend the funds.
251    * @param _subtractedValue The amount of tokens to decrease the allowance by.
252    */
253   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
254     uint oldValue = allowed[msg.sender][_spender];
255     if (_subtractedValue > oldValue) {
256       allowed[msg.sender][_spender] = 0;
257     } else {
258       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259     }
260     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 }
264 
265 contract MintableToken is StandardToken, Ownable {
266   event Mint(address indexed to, uint256 amount);
267   event MintFinished();
268 
269   bool public mintingFinished = false;
270 
271   modifier canMint() {
272     require(!mintingFinished);
273     _;
274   }
275 
276   /**
277    * @dev Function to mint tokens
278    * @param _to The address that will receive the minted tokens.
279    * @param _amount The amount of tokens to mint.
280    * @return A boolean that indicates if the operation was successful.
281    */
282   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
283     totalSupply = totalSupply.add(_amount);
284     balances[_to] = balances[_to].add(_amount);
285     emit Mint(_to, _amount);
286     emit Transfer(address(0), _to, _amount);
287     return true;
288   }
289 
290   /**
291    * @dev Function to stop minting new tokens.
292    * @return True if the operation was successful.
293    */
294   function finishMinting() onlyOwner canMint public returns (bool) {
295     mintingFinished = true;
296     emit MintFinished();
297     return true;
298   }
299 }
300 
301 contract TPXToken is MintableToken, Destructible {
302 
303   string  public name = 'TOPEX Token';
304   string  public symbol = 'TPX';
305   uint8   public decimals = 18;
306   uint256 public maxSupply = 200000000 ether;    // max allowable minting.
307   bool    public transferDisabled = true;         // disable transfer init.
308 
309   event Confiscate(address indexed offender, uint256 value);
310 
311   // empty constructor
312   constructor() public {}
313 
314   /*
315    * the real reason for quarantined addresses are for those who are
316    * mistakenly sent the TPX tokens to the wrong address. We can disable
317    * the usage of the TPX tokens here.
318    */
319   mapping(address => bool) quarantined;           // quarantined addresses
320   mapping(address => bool) gratuity;              // locked addresses for owners
321 
322   modifier canTransfer() {
323     if (msg.sender == owner) {
324       _;
325     } else {
326       require(!transferDisabled);
327       require(quarantined[msg.sender] == false);  // default bool is false
328       require(gratuity[msg.sender] == false);     // default bool is false
329       _;
330     }
331   }
332 
333   /*
334    * Allow the transfer of tokens to happen once ICO finished
335    */
336   function allowTransfers() onlyOwner public returns (bool) {
337     transferDisabled = false;
338     return true;
339   }
340 
341   function disallowTransfers() onlyOwner public returns (bool) {
342     transferDisabled = true;
343     return true;
344   }
345 
346   function quarantineAddress(address _addr) onlyOwner public returns (bool) {
347     quarantined[_addr] = true;
348     return true;
349   }
350 
351   function unQuarantineAddress(address _addr) onlyOwner public returns (bool) {
352     quarantined[_addr] = false;
353     return true;
354   }
355 
356   function lockAddress(address _addr) onlyOwner public returns (bool) {
357     gratuity[_addr] = true;
358     return true;
359   }
360 
361   function unlockAddress(address _addr) onlyOwner public returns (bool) {
362     gratuity[_addr] = false;
363     return true;
364   }
365 
366   /**
367    * This is confiscate the money that is sent to the wrong address accidentally.
368    * the confiscated value can then be transferred to the righful owner. This is
369    * especially important during ICO where some are *still* using Exchanger wallet
370    * address, instead of their personal address.
371    */
372   function confiscate(address _offender) onlyOwner public returns (bool) {
373     uint256 all = balances[_offender];
374     require(all > 0);
375     
376     balances[_offender] = balances[_offender].sub(all);
377     balances[msg.sender] = balances[msg.sender].add(all);
378     emit Confiscate(_offender, all);
379     return true;
380   }
381 
382   /*
383    * @dev Function to mint tokens
384    * @param _to The address that will receive the minted tokens.
385    * @param _amount The amount of tokens to mint.
386    * @return A boolean that indicates if the operation was successful.
387    */
388   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
389     require(totalSupply <= maxSupply);
390     return super.mint(_to, _amount);
391   }
392 
393   /**
394   * @dev transfer token for a specified address
395   * @param _to The address to transfer to.
396   * @param _value The amount to be transferred.
397   */
398   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
399     return super.transfer(_to, _value);
400   }
401 
402   /**
403    * @dev Transfer tokens from one address to another
404    * @param _from address The address which you want to send tokens from
405    * @param _to address The address which you want to transfer to
406    * @param _value uint256 the amount of tokens to be transferred
407    */
408   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
409     return super.transferFrom(_from, _to, _value);
410   }
411 
412   /**
413    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
414    *
415    * Beware that changing an allowance with this method brings the risk that someone may use both the old
416    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
417    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
418    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
419    * @param _spender The address which will spend the funds.
420    * @param _value The amount of tokens to be spent.
421    */
422   function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
423     return super.approve(_spender, _value);
424   }
425 }
426 
427 /**
428  * The TPXCrowdsale contract.
429  * The token is based on ERC20 Standard token, with ERC23 functionality to reclaim
430  * other tokens accidentally sent to this contract, as well as to destroy
431  * this contract once the ICO has ended.
432  */
433 contract TPXCrowdsale is CanReclaimToken, Destructible {
434   using SafeMath for uint256;
435 
436   // The token being sold 
437   MintableToken public token;
438 
439   // start and end timestamps where investments are allowed (both inclusive)
440   uint256 public startTime = 0;
441   uint256 public endTime = 0;
442 
443   // address where funds are collected
444   address public wallet = address(0);
445 
446   // amount of raised money in wei
447   uint256 public weiRaised = 0;
448 
449   // cap for crowdsale
450   uint256 public cap = 20000 ether;
451 
452   // whitelist backers
453   mapping(address => bool) whiteList;
454 
455   // addmin list
456   mapping(address => bool) adminList;
457 
458   // mappig of our days, and rates.
459   mapping(uint8 => uint256) daysRates;
460 
461   modifier onlyAdmin() { 
462     require(adminList[msg.sender] == true || msg.sender == owner);
463     _; 
464   }
465   
466   /**
467    * eurchase logging
468    * @param purchaser who paid for the tokens
469    * @param beneficiary who got the tokens
470    * @param value weis paid for purchase
471    * @param amount amount of tokens purchased
472    */
473   event TokenPurchase(address indexed purchaser, address indexed beneficiary, 
474                       uint256 value, uint256 amount);
475 
476   constructor(MintableToken _token) public {
477 
478     // Token contract address to enter 
479     token = _token;
480     startTime = 1532952000; 
481     endTime = startTime + 79 days;
482     // TPX Owner wallet address
483     wallet = 0x44f43463C5663C515cD1c3e53B226C335e41D970;
484 
485     // set the days lapsed, and rates(tokens per ETH) for the period since startTime.
486     daysRates[51] = 7000;
487     // 40% bonus 45 days - private sale for whitelisted only!
488     daysRates[58] = 6500;
489     // 30% bonus first week of ICO -  public crowdsale
490     daysRates[65] = 6000;
491     // 20% bonus second week of ICO -  public crowdsale
492     daysRates[72] = 5500;
493     // 10% bonus third week of ICO -  public crowdsale
494     daysRates[79] = 5000;
495     // 0% bonus fourth week of ICO -  public crowdsale
496   }
497 
498   function setTokenOwner (address _newOwner) public onlyOwner {
499     token.transferOwnership(_newOwner);
500   }
501 
502   function addWhiteList (address _backer) public onlyAdmin returns (bool res) {
503     whiteList[_backer] = true;
504     return true;
505   }
506   
507   function addAdmin (address _admin) onlyAdmin public returns (bool res) {
508     adminList[_admin] = true;
509     return true;
510   }
511 
512   function isWhiteListed (address _backer) public view returns (bool res) {
513     return whiteList[_backer];
514   }
515 
516   function isAdmin (address _admin) public view returns (bool res) {
517     return adminList[_admin];
518   }
519   
520   function totalRaised() public view returns (uint256) {
521     return weiRaised;
522   }
523 
524   // fallback function can be used to buy tokens
525   function () external payable {
526     buyTokens(msg.sender);
527   }
528 
529   // low level token purchase function
530   function buyTokens(address beneficiary) public payable {
531     require(beneficiary != address(0));
532     require(validPurchase());
533 
534     uint256 weiAmount = msg.value;
535 
536     // calculate token amount to be created
537     uint256 tokens = weiAmount.mul(getRate());
538 
539     // update state
540     weiRaised = weiRaised.add(weiAmount);
541 
542     if (tokens > 0) {
543       token.mint(beneficiary, tokens);
544       emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);      
545     }
546 
547     forwardFunds();
548   }
549 
550   // send ether to the fund collection wallet
551   // override to create custom fund forwarding mechanisms
552   function forwardFunds() internal {
553     wallet.transfer(msg.value);
554   }
555 
556   // @return true if the transaction can buy tokens
557   function validPurchase() internal view returns (bool) {
558     // 73 days of sale.
559     bool withinPeriod = (now >= startTime && now <= endTime) || msg.sender == owner;
560     bool nonZeroPurchase = msg.value != 0;
561     bool withinCap = weiRaised.add(msg.value) <= cap;
562     return withinPeriod && nonZeroPurchase && withinCap;
563   }
564 
565   function getRate() internal view returns (uint256 rate) {
566     uint256 diff = (now - startTime);
567 
568     if (diff <= 51 days) {
569       require(whiteList[msg.sender] == true);
570       return daysRates[51];
571     } else if (diff > 51 && diff <= 58 days) {
572       return daysRates[58];
573     } else if (diff > 58 && diff <= 65 days) {
574       return daysRates[65];
575     } else if (diff > 65 && diff <= 72 days) {
576       return daysRates[72];
577     } else if (diff <= 79 days) {
578       return daysRates[79];
579     } 
580     return 0;
581   }
582 
583   // @return true if crowdsale event has ended
584   function hasEnded() public view returns (bool) {
585     bool capReached = weiRaised >= cap;
586     return now > endTime || capReached;
587   }
588 }