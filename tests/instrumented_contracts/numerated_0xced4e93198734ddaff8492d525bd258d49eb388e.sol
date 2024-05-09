1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal constant returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 contract MintableInterface {
73   function mint(address _to, uint256 _amount) returns (bool);
74   function mintLocked(address _to, uint256 _amount) returns (bool);
75 }
76 
77 /**
78  * This is the Crowdsale contract from OpenZeppelin version 1.2.0
79  * The only changes are:
80  *   - the type of token field is changed from MintableToken to MintableInterface
81  *   - the createTokenContract() method is removed, the token field must be initialized in the derived contracts constuctor
82  **/
83 
84 
85 
86 
87 
88 
89 /**
90  * @title Crowdsale 
91  * @dev Crowdsale is a base contract for managing a token crowdsale.
92  * Crowdsales have a start and end block, where investors can make
93  * token purchases and the crowdsale will assign them tokens based
94  * on a token per ETH rate. Funds collected are forwarded to a wallet 
95  * as they arrive.
96  */
97 contract Crowdsale {
98   using SafeMath for uint256;
99 
100   // The token being sold
101   MintableInterface public token;
102 
103   // start and end block where investments are allowed (both inclusive)
104   uint256 public startBlock;
105   uint256 public endBlock;
106 
107   // address where funds are collected
108   address public wallet;
109 
110   // how many token units a buyer gets per wei
111   uint256 public rate;
112 
113   // amount of raised money in wei
114   uint256 public weiRaised;
115 
116   /**
117    * event for token purchase logging
118    * @param purchaser who paid for the tokens
119    * @param beneficiary who got the tokens
120    * @param value weis paid for purchase
121    * @param amount amount of tokens purchased
122    */ 
123   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
124 
125 
126   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
127     require(_startBlock >= block.number);
128     require(_endBlock >= _startBlock);
129     require(_rate > 0);
130     require(_wallet != 0x0);
131 
132     startBlock = _startBlock;
133     endBlock = _endBlock;
134     rate = _rate;
135     wallet = _wallet;
136   }
137 
138   // fallback function can be used to buy tokens
139   function () payable {
140     buyTokens(msg.sender);
141   }
142 
143   // low level token purchase function
144   function buyTokens(address beneficiary) payable {
145     require(beneficiary != 0x0);
146     require(validPurchase());
147 
148     uint256 weiAmount = msg.value;
149 
150     // calculate token amount to be created
151     uint256 tokens = weiAmount.mul(rate);
152 
153     // update state
154     weiRaised = weiRaised.add(weiAmount);
155 
156     token.mint(beneficiary, tokens);
157     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
158 
159     forwardFunds();
160   }
161 
162   // send ether to the fund collection wallet
163   // override to create custom fund forwarding mechanisms
164   function forwardFunds() internal {
165     wallet.transfer(msg.value);
166   }
167 
168   // @return true if the transaction can buy tokens
169   function validPurchase() internal constant returns (bool) {
170     uint256 current = block.number;
171     bool withinPeriod = current >= startBlock && current <= endBlock;
172     bool nonZeroPurchase = msg.value != 0;
173     return withinPeriod && nonZeroPurchase;
174   }
175 
176   // @return true if crowdsale event has ended
177   function hasEnded() public constant returns (bool) {
178     return block.number > endBlock;
179   }
180 
181 
182 }
183 
184 /**
185  * @title CappedCrowdsale
186  * @dev Extension of Crowsdale with a max amount of funds raised
187  */
188 contract TokenCappedCrowdsale is Crowdsale {
189   using SafeMath for uint256;
190 
191   // tokenCap should be initialized in derived contract
192   uint256 public tokenCap;
193 
194   uint256 public soldTokens;
195 
196   // overriding Crowdsale#hasEnded to add tokenCap logic
197   // @return true if crowdsale event has ended
198   function hasEnded() public constant returns (bool) {
199     bool capReached = soldTokens >= tokenCap;
200     return super.hasEnded() || capReached;
201   }
202 
203   // overriding Crowdsale#buyTokens to add extra tokenCap logic
204   function buyTokens(address beneficiary) payable {
205     // calculate token amount to be created
206     uint256 tokens = msg.value.mul(rate);
207     uint256 newTotalSold = soldTokens.add(tokens);
208     require(newTotalSold <= tokenCap);
209     soldTokens = newTotalSold;
210     super.buyTokens(beneficiary);
211   }
212 }
213 
214 /**
215  * @title ERC20Basic
216  * @dev Simpler version of ERC20 interface
217  * @dev see https://github.com/ethereum/EIPs/issues/179
218  */
219 contract ERC20Basic {
220   uint256 public totalSupply;
221   function balanceOf(address who) constant returns (uint256);
222   function transfer(address to, uint256 value) returns (bool);
223   event Transfer(address indexed from, address indexed to, uint256 value);
224 }
225 
226 /**
227  * This is the TokenTimelock contract from OpenZeppelin version 1.2.0
228  * The only changes are:
229  *   - all contract fields are declared as public
230  *   - removed deprecated claim() method
231  **/
232 
233 
234 
235 
236 
237 /**
238  * @title TokenTimelock
239  * @dev TokenTimelock is a token holder contract that will allow a 
240  * beneficiary to extract the tokens after a given release time
241  */
242 contract TokenTimelock {
243   
244   // ERC20 basic token contract being held
245   ERC20Basic public token;
246 
247   // beneficiary of tokens after they are released
248   address public beneficiary;
249 
250   // timestamp when token release is enabled
251   uint public releaseTime;
252 
253   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
254     require(_releaseTime > now);
255     token = _token;
256     beneficiary = _beneficiary;
257     releaseTime = _releaseTime;
258   }
259 
260   /**
261    * @notice Transfers tokens held by timelock to beneficiary.
262    */
263   function release() {
264     require(now >= releaseTime);
265 
266     uint amount = token.balanceOf(this);
267     require(amount > 0);
268 
269     token.transfer(beneficiary, amount);
270   }
271 }
272 
273 /**
274  * @title Basic token
275  * @dev Basic version of StandardToken, with no allowances. 
276  */
277 contract BasicToken is ERC20Basic {
278   using SafeMath for uint256;
279 
280   mapping(address => uint256) balances;
281 
282   /**
283   * @dev transfer token for a specified address
284   * @param _to The address to transfer to.
285   * @param _value The amount to be transferred.
286   */
287   function transfer(address _to, uint256 _value) returns (bool) {
288     balances[msg.sender] = balances[msg.sender].sub(_value);
289     balances[_to] = balances[_to].add(_value);
290     Transfer(msg.sender, _to, _value);
291     return true;
292   }
293 
294   /**
295   * @dev Gets the balance of the specified address.
296   * @param _owner The address to query the the balance of. 
297   * @return An uint256 representing the amount owned by the passed address.
298   */
299   function balanceOf(address _owner) constant returns (uint256 balance) {
300     return balances[_owner];
301   }
302 
303 }
304 
305 /**
306  * @title ERC20 interface
307  * @dev see https://github.com/ethereum/EIPs/issues/20
308  */
309 contract ERC20 is ERC20Basic {
310   function allowance(address owner, address spender) constant returns (uint256);
311   function transferFrom(address from, address to, uint256 value) returns (bool);
312   function approve(address spender, uint256 value) returns (bool);
313   event Approval(address indexed owner, address indexed spender, uint256 value);
314 }
315 
316 /**
317  * @title Standard ERC20 token
318  *
319  * @dev Implementation of the basic standard token.
320  * @dev https://github.com/ethereum/EIPs/issues/20
321  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
322  */
323 contract StandardToken is ERC20, BasicToken {
324 
325   mapping (address => mapping (address => uint256)) allowed;
326 
327 
328   /**
329    * @dev Transfer tokens from one address to another
330    * @param _from address The address which you want to send tokens from
331    * @param _to address The address which you want to transfer to
332    * @param _value uint256 the amout of tokens to be transfered
333    */
334   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
335     var _allowance = allowed[_from][msg.sender];
336 
337     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
338     // require (_value <= _allowance);
339 
340     balances[_to] = balances[_to].add(_value);
341     balances[_from] = balances[_from].sub(_value);
342     allowed[_from][msg.sender] = _allowance.sub(_value);
343     Transfer(_from, _to, _value);
344     return true;
345   }
346 
347   /**
348    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
349    * @param _spender The address which will spend the funds.
350    * @param _value The amount of tokens to be spent.
351    */
352   function approve(address _spender, uint256 _value) returns (bool) {
353 
354     // To change the approve amount you first have to reduce the addresses`
355     //  allowance to zero by calling `approve(_spender, 0)` if it is not
356     //  already 0 to mitigate the race condition described here:
357     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
358     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
359 
360     allowed[msg.sender][_spender] = _value;
361     Approval(msg.sender, _spender, _value);
362     return true;
363   }
364 
365   /**
366    * @dev Function to check the amount of tokens that an owner allowed to a spender.
367    * @param _owner address The address which owns the funds.
368    * @param _spender address The address which will spend the funds.
369    * @return A uint256 specifing the amount of tokens still avaible for the spender.
370    */
371   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
372     return allowed[_owner][_spender];
373   }
374 
375 }
376 
377 contract EidooToken is MintableInterface, Ownable, StandardToken {
378   using SafeMath for uint256;
379 
380   string public name = "Eidoo Token";
381   string public symbol = "EDO";
382   uint256 public decimals = 18;
383 
384   uint256 public transferableFromBlock;
385   uint256 public lockEndBlock;
386   mapping (address => uint256) public initiallyLockedAmount;
387 
388   function EidooToken(uint256 _transferableFromBlock, uint256 _lockEndBlock) {
389     require(_lockEndBlock > _transferableFromBlock);
390     transferableFromBlock = _transferableFromBlock;
391     lockEndBlock = _lockEndBlock;
392   }
393 
394   modifier canTransfer(address _from, uint _value) {
395     if (block.number < lockEndBlock) {
396       require(block.number >= transferableFromBlock);
397       uint256 locked = lockedBalanceOf(_from);
398       if (locked > 0) {
399         uint256 newBalance = balanceOf(_from).sub(_value);
400         require(newBalance >= locked);
401       }
402     }
403    _;
404   }
405 
406   function lockedBalanceOf(address _to) constant returns(uint256) {
407     uint256 locked = initiallyLockedAmount[_to];
408     if (block.number >= lockEndBlock ) return 0;
409     else if (block.number <= transferableFromBlock) return locked;
410 
411     uint256 releaseForBlock = locked.div(lockEndBlock.sub(transferableFromBlock));
412     uint256 released = block.number.sub(transferableFromBlock).mul(releaseForBlock);
413     return locked.sub(released);
414   }
415 
416   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) returns (bool) {
417     return super.transfer(_to, _value);
418   }
419 
420   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) returns (bool) {
421     return super.transferFrom(_from, _to, _value);
422   }
423 
424   // --------------- Minting methods
425 
426   modifier canMint() {
427     require(!mintingFinished());
428     _;
429   }
430 
431   function mintingFinished() constant returns(bool) {
432     return block.number >= transferableFromBlock;
433   }
434 
435   /**
436    * @dev Function to mint tokens, implements MintableInterface
437    * @param _to The address that will recieve the minted tokens.
438    * @param _amount The amount of tokens to mint.
439    * @return A boolean that indicates if the operation was successful.
440    */
441   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
442     totalSupply = totalSupply.add(_amount);
443     balances[_to] = balances[_to].add(_amount);
444     Transfer(address(0), _to, _amount);
445     return true;
446   }
447 
448   function mintLocked(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
449     initiallyLockedAmount[_to] = initiallyLockedAmount[_to].add(_amount);
450     return mint(_to, _amount);
451   }
452 
453   function burn(uint256 _amount) returns (bool) {
454     balances[msg.sender] = balances[msg.sender].sub(_amount);
455     totalSupply = totalSupply.sub(_amount);
456     Transfer(msg.sender, address(0), _amount);
457     return true;
458   }
459 }
460 
461 contract EidooTokenSale is Ownable, TokenCappedCrowdsale {
462   using SafeMath for uint256;
463   uint256 public MAXIMUM_SUPPLY = 100000000 * 10**18;
464   uint256 [] public LOCKED = [     20000000 * 10**18,
465                                    15000000 * 10**18,
466                                     6000000 * 10**18,
467                                     6000000 * 10**18 ];
468   uint256 public POST_ICO =        21000000 * 10**18;
469   uint256 [] public LOCK_END = [
470     1570190400, // 4 October 2019 12:00:00 GMT
471     1538654400, // 4 October 2018 12:00:00 GMT
472     1522843200, // 4 April 2018 12:00:00 GMT
473     1515067200  // 4 January 2018 12:00:00 GMT
474   ];
475 
476   mapping (address => bool) public claimed;
477   TokenTimelock [4] public timeLocks;
478 
479   event ClaimTokens(address indexed to, uint amount);
480 
481   modifier beforeStart() {
482     require(block.number < startBlock);
483     _;
484   }
485 
486   function EidooTokenSale(
487     uint256 _startBlock,
488     uint256 _endBlock,
489     uint256 _rate,
490     uint _tokenStartBlock,
491     uint _tokenLockEndBlock,
492     address _wallet
493   )
494     Crowdsale(_startBlock, _endBlock, _rate, _wallet)
495   {
496     token = new EidooToken(_tokenStartBlock, _tokenLockEndBlock);
497 
498     // create timelocks for tokens
499     timeLocks[0] = new TokenTimelock(EidooToken(token), _wallet, LOCK_END[0]);
500     timeLocks[1] = new TokenTimelock(EidooToken(token), _wallet, LOCK_END[1]);
501     timeLocks[2] = new TokenTimelock(EidooToken(token), _wallet, LOCK_END[2]);
502     timeLocks[3] = new TokenTimelock(EidooToken(token), _wallet, LOCK_END[3]);
503     token.mint(address(timeLocks[0]), LOCKED[0]);
504     token.mint(address(timeLocks[1]), LOCKED[1]);
505     token.mint(address(timeLocks[2]), LOCKED[2]);
506     token.mint(address(timeLocks[3]), LOCKED[3]);
507 
508     token.mint(_wallet, POST_ICO);
509 
510     // initialize maximum number of tokens that can be sold
511     tokenCap = MAXIMUM_SUPPLY.sub(EidooToken(token).totalSupply());
512   }
513 
514   function claimTokens(address [] buyers, uint [] amounts) onlyOwner beforeStart public {
515     require(buyers.length == amounts.length);
516     uint len = buyers.length;
517     for (uint i = 0; i < len; i++) {
518       address to = buyers[i];
519       uint256 amount = amounts[i];
520       if (amount > 0 && !claimed[to]) {
521         claimed[to] = true;
522         if (to == 0x32Be343B94f860124dC4fEe278FDCBD38C102D88) {
523           // replace Poloniex Wallet address
524           to = 0x2274bebe2b47Ec99D50BB9b12005c921F28B83bB;
525         }
526         tokenCap = tokenCap.sub(amount);
527         uint256 unlockedAmount = amount.div(10).mul(3);
528         token.mint(to, unlockedAmount);
529         token.mintLocked(to, amount.sub(unlockedAmount));
530         ClaimTokens(to, amount);
531       }
532     }
533   }
534 
535 }