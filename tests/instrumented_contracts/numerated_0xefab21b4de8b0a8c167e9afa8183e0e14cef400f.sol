1 /**
2  *
3  * MIT License
4  *
5  * Copyright (c) 2018, MEXC Program Developers & OpenZeppelin Project.
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
26 pragma solidity ^0.4.17;
27 
28 library SafeMath {
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 library SafeERC20 {
58   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
59     assert(token.transfer(to, value));
60   }
61 
62   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
63     assert(token.transferFrom(from, to, value));
64   }
65 
66   function safeApprove(ERC20 token, address spender, uint256 value) internal {
67     assert(token.approve(spender, value));
68   }
69 }
70 
71 contract Ownable {
72   address public owner;
73 
74   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   function Ownable() public {
81     owner = msg.sender;
82   }
83 
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
100     OwnershipTransferred(owner, newOwner);
101     owner = newOwner;
102   }
103 }
104 
105 contract Destructible is Ownable {
106 
107   function Destructible() public payable { }
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
165     Transfer(msg.sender, _to, _value);
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
197     Transfer(_from, _to, _value);
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
213     Approval(msg.sender, _spender, _value);
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
239     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
271 
272   modifier canMint() {
273     require(!mintingFinished);
274     _;
275   }
276 
277   /**
278    * @dev Function to mint tokens
279    * @param _to The address that will receive the minted tokens.
280    * @param _amount The amount of tokens to mint.
281    * @return A boolean that indicates if the operation was successful.
282    */
283   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
284     totalSupply = totalSupply.add(_amount);
285     balances[_to] = balances[_to].add(_amount);
286     Mint(_to, _amount);
287     Transfer(address(0), _to, _amount);
288     return true;
289   }
290 
291   /**
292    * @dev Function to stop minting new tokens.
293    * @return True if the operation was successful.
294    */
295   function finishMinting() onlyOwner canMint public returns (bool) {
296     mintingFinished = true;
297     MintFinished();
298     return true;
299   }
300 }
301 
302 contract MEXCToken is MintableToken, Destructible  {
303 
304   string  public name = 'MEX Care Token';
305   string  public symbol = 'MEXC';
306   uint8   public decimals = 18;
307   uint256 public maxSupply = 1714285714 ether;    // max allowable minting.
308   bool    public transferDisabled = true;         // disable transfer init.
309 
310   event Confiscate(address indexed offender, uint256 value);
311 
312   // empty constructor
313   function MEXCToken() public {}
314 
315   /*
316    * the real reason for quarantined addresses are for those who are
317    * mistakenly sent the MEXC tokens to the wrong address. We can disable
318    * the usage of the MEXC tokens here.
319    */
320   mapping(address => bool) quarantined;           // quarantined addresses
321   mapping(address => bool) gratuity;              // locked addresses for owners
322 
323   modifier canTransfer() {
324     if (msg.sender == owner) {
325       _;
326     } else {
327       require(!transferDisabled);
328       require(quarantined[msg.sender] == false);  // default bool is false
329       require(gratuity[msg.sender] == false);     // default bool is false
330       _;
331     }
332   }
333 
334   /*
335    * Allow the transfer of token to happen once listed on exchangers
336    */
337   function allowTransfers() onlyOwner public returns (bool) {
338     transferDisabled = false;
339     return true;
340   }
341 
342   function disallowTransfers() onlyOwner public returns (bool) {
343     transferDisabled = true;
344     return true;
345   }
346 
347   function quarantineAddress(address _addr) onlyOwner public returns (bool) {
348     quarantined[_addr] = true;
349     return true;
350   }
351 
352   function unQuarantineAddress(address _addr) onlyOwner public returns (bool) {
353     quarantined[_addr] = false;
354     return true;
355   }
356 
357   function lockAddress(address _addr) onlyOwner public returns (bool) {
358     gratuity[_addr] = true;
359     return true;
360   }
361 
362   function unlockAddress(address _addr) onlyOwner public returns (bool) {
363     gratuity[_addr] = false;
364     return true;
365   }
366 
367   /**
368    * This is confiscate the money that is sent to the wrong address accidentally.
369    * the confiscated value can then be transferred to the righful owner. This is
370    * especially important during ICO where some are *still* using Exchanger wallet
371    * address, instead of their personal address.
372    */
373   function confiscate(address _offender) onlyOwner public returns (bool) {
374     uint256 all = balances[_offender];
375     require(all > 0);
376     
377     balances[_offender] = balances[_offender].sub(all);
378     balances[msg.sender] = balances[msg.sender].add(all);
379     Confiscate(_offender, all);
380     return true;
381   }
382 
383   /*
384    * @dev Function to mint tokens
385    * @param _to The address that will receive the minted tokens.
386    * @param _amount The amount of tokens to mint.
387    * @return A boolean that indicates if the operation was successful.
388    */
389   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
390     require(totalSupply <= maxSupply);
391     return super.mint(_to, _amount);
392   }
393 
394   /**
395   * @dev transfer token for a specified address
396   * @param _to The address to transfer to.
397   * @param _value The amount to be transferred.
398   */
399   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
400     return super.transfer(_to, _value);
401   }
402 
403   /**
404    * @dev Transfer tokens from one address to another
405    * @param _from address The address which you want to send tokens from
406    * @param _to address The address which you want to transfer to
407    * @param _value uint256 the amount of tokens to be transferred
408    */
409   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
410     return super.transferFrom(_from, _to, _value);
411   }
412 
413   /**
414    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
415    *
416    * Beware that changing an allowance with this method brings the risk that someone may use both the old
417    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
418    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
419    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
420    * @param _spender The address which will spend the funds.
421    * @param _value The amount of tokens to be spent.
422    */
423   function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
424     return super.approve(_spender, _value);
425   }
426 }
427 
428 /**
429  * The MEXCrowdsale contract.
430  * The token is based on ERC20 Standard token, with ERC23 functionality to reclaim
431  * other tokens accidentally sent to this contract, as well as to destroy
432  * this contract once the ICO has ended.
433  */
434 contract MEXCrowdsale is CanReclaimToken, Destructible {
435   using SafeMath for uint256;
436 
437   // The token being sold
438   MintableToken public token;
439 
440   // start and end timestamps where investments are allowed (both inclusive)
441   uint256 public startTime = 0;
442   uint256 public endTime = 0;
443 
444   // address where funds are collected
445   address public wallet = address(0);
446 
447   // amount of raised money in wei
448   uint256 public weiRaised = 0;
449 
450   // cap for crowdsale
451   uint256 public cap = 300000 ether;
452 
453   // whitelist backers
454   mapping(address => bool) whiteList;
455 
456   // addmin list
457   mapping(address => bool) adminList;
458 
459   // mappig of our days, and rates.
460   mapping(uint8 => uint256) daysRates;
461 
462   modifier onlyAdmin() { 
463     require(adminList[msg.sender] == true || msg.sender == owner);
464     _; 
465   }
466   
467   /**
468    * event for token purchase logging
469    * @param purchaser who paid for the tokens
470    * @param beneficiary who got the tokens
471    * @param value weis paid for purchase
472    * @param amount amount of tokens purchased
473    */
474   event TokenPurchase(address indexed purchaser, address indexed beneficiary, 
475                       uint256 value, uint256 amount);
476 
477   function MEXCrowdsale() public {
478 
479     token = createTokenContract();
480     startTime = 1518048000;
481     endTime = startTime + 80 days;
482     wallet = 0x77733DEFb072D75aF02A4415f60212925E6BcF95;
483 
484     // set the days lapsed, and rates for the priod since startTime.
485     daysRates[15] = 4000;
486     daysRates[45] = 3500;
487     daysRates[65] = 3250;
488     daysRates[75] = 3125;
489     daysRates[80] = 3000;
490   }
491 
492   // creates the token to be sold.
493   // override this method to have crowdsale of a specific mintable token.
494   function createTokenContract() internal returns (MintableToken) {
495     return new MEXCToken();
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
544       TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);      
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
558     // 80 days of sale.
559     bool withinPeriod = (now >= startTime && now <= endTime) || msg.sender == owner;
560     bool nonZeroPurchase = msg.value != 0;
561     bool withinCap = weiRaised.add(msg.value) <= cap;
562     return withinPeriod && nonZeroPurchase && withinCap;
563   }
564 
565   function getRate() internal view returns (uint256 rate) {
566     uint256 diff = (now - startTime);
567 
568     if (diff <= 15 days) {
569       require(whiteList[msg.sender] == true);
570       return daysRates[15];
571     } else if (diff > 15 && diff <= 45 days) {
572       return daysRates[45];
573     } else if (diff > 45 && diff <= 65 days) {
574       return daysRates[65];
575     } else if (diff > 65 && diff <= 75 days) {
576       return daysRates[75];
577     } else if (diff <= 80 days) {
578       return daysRates[80];
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