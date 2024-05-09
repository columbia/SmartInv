1 pragma solidity 0.4.19;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 pragma solidity ^0.4.11;
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 pragma solidity ^0.4.11;
47 
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57 
58   /**
59   * @dev transfer token for a specified address
60   * @param _to The address to transfer to.
61   * @param _value The amount to be transferred.
62   */
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of.
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) public constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83 }
84 
85 
86 pragma solidity ^0.4.11;
87 
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public constant returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 pragma solidity ^0.4.11;
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183 }
184 
185 pragma solidity ^0.4.11;
186 /**
187  * @title Ownable
188  * @dev The Ownable contract has an owner address, and provides basic authorization control
189  * functions, this simplifies the implementation of "user permissions".
190  */
191 contract Ownable {
192   address public owner;
193 
194 
195   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197 
198   /**
199    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200    * account.
201    */
202   function Ownable() {
203     owner = msg.sender;
204   }
205 
206 
207   /**
208    * @dev Throws if called by any account other than the owner.
209    */
210   modifier onlyOwner() {
211     require(msg.sender == owner);
212     _;
213   }
214 
215 
216   /**
217    * @dev Allows the current owner to transfer control of the contract to a newOwner.
218    * @param newOwner The address to transfer ownership to.
219    */
220   function transferOwnership(address newOwner) onlyOwner public {
221     require(newOwner != address(0));
222     OwnershipTransferred(owner, newOwner);
223     owner = newOwner;
224   }
225 
226 }
227 
228 
229 pragma solidity ^0.4.11;
230 
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will receive the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258     totalSupply = totalSupply.add(_amount);
259     balances[_to] = balances[_to].add(_amount);
260     Mint(_to, _amount);
261     Transfer(address(0), _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 contract RocketToken is MintableToken {
277     string public name = "ICO ROCKET";
278     string public symbol = "ROCKET";
279     uint256 public decimals = 18;
280 }
281 /**
282  * @title Crowdsale
283  * @dev Crowdsale is a base contract for managing a token crowdsale.
284  * Crowdsales have a start and end timestamps, where investors can make
285  * token purchases and the crowdsale will assign them tokens based
286  * on a token per ETH rate. Funds collected are forwarded to a wallet
287  * as they arrive.
288  */
289 contract Crowdsale {
290   using SafeMath for uint256;
291 
292   // The token being sold
293   MintableToken public token;
294 
295   // start and end timestamps where investments are allowed (both inclusive)
296   uint256 public startTime;
297   uint256 public endTime;
298 
299   // address where funds are collected
300   address public wallet;
301 
302   // how many token units a buyer gets per wei
303   uint256 public rate;
304 
305   // amount of raised money in wei
306   uint256 public weiRaised;
307 
308   /**
309    * event for token purchase logging
310    * @param purchaser who paid for the tokens
311    * @param beneficiary who got the tokens
312    * @param value weis paid for purchase
313    * @param amount amount of tokens purchased
314    */
315   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
316 
317 
318   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
319     require(_startTime >= now);
320     require(_endTime >= _startTime);
321     require(_rate > 0);
322     require(_wallet != address(0));
323 
324     token = createTokenContract();
325     startTime = _startTime;
326     endTime = _endTime;
327     rate = _rate;
328     wallet = _wallet;
329   }
330 
331   // creates the token to be sold.
332   // override this method to have crowdsale of a specific mintable token.
333   function createTokenContract() internal returns (MintableToken) {
334     return new MintableToken();
335   }
336 
337 
338   // fallback function can be used to buy tokens
339   function () payable {
340     buyTokens(msg.sender);
341   }
342 
343   // low level token purchase function
344   function buyTokens(address beneficiary) public payable {
345     require(beneficiary != address(0));
346     require(validPurchase());
347 
348     uint256 weiAmount = msg.value;
349 
350     // calculate token amount to be created
351     uint256 tokens = weiAmount.mul(rate);
352 
353     // update state
354     weiRaised = weiRaised.add(weiAmount);
355 
356     token.mint(beneficiary, tokens);
357     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
358 
359     forwardFunds();
360   }
361 
362   // send ether to the fund collection wallet
363   // override to create custom fund forwarding mechanisms
364   function forwardFunds() internal {
365     wallet.transfer(msg.value);
366   }
367 
368   // @return true if the transaction can buy tokens
369   function validPurchase() internal constant returns (bool) {
370     bool withinPeriod = now >= startTime && now <= endTime;
371     bool nonZeroPurchase = msg.value != 0;
372     return withinPeriod && nonZeroPurchase;
373   }
374 
375   // @return true if crowdsale event has ended
376   function hasEnded() public constant returns (bool) {
377     return now > endTime;
378   }
379 
380 
381 }
382 pragma solidity ^0.4.11;
383 
384 
385 contract RocketTokenCrowdsale is Ownable, Crowdsale {
386 
387     using SafeMath for uint256;
388  
389     //operational
390     bool public LockupTokensWithdrawn = false;
391     uint256 public constant toDec = 10**18;
392     uint256 public tokensLeft = 14700000*toDec;
393     uint256 public constant cap = 14700000*toDec;
394     uint256 public constant startRate = 1000;
395 
396     enum State { BeforeSale, Bonus, NormalSale, ShouldFinalize, Lockup, SaleOver }
397     State public state = State.BeforeSale;
398 
399     /* --- Ether wallets --- */
400     // Admin ETH Wallet: 0x0662a2f97833b9b120ed40d4e60ceec39c71ef18
401 
402     // 4% Team Tokens: 0x1EB5cc8E0825dfE322df4CA44ce8522981874d51
403 
404     // 1% For me
405 
406     // 25% Investor 1: TBC
407 
408     // Pre ICO wallets
409 
410     address[2] public wallets;
411 
412     uint256 public TeamSum = 840000*toDec; // 0 - 4%
413 
414     uint256 public MeSum = 210000*toDec; // 1 - 1%
415 
416     uint256 public InvestorSum = 5250000*toDec; // 2 - 25%
417 
418 
419     // /* --- Time periods --- */
420 
421     uint256 public startTimeNumber = block.timestamp;
422 
423     uint256 public lockupPeriod = 180 * 1 days;
424 
425     uint256 public bonusPeriod = 90 * 1 days;
426 
427     uint256 public bonusEndTime = bonusPeriod + startTimeNumber;
428 
429 
430 
431     event LockedUpTokensWithdrawn();
432     event Finalized();
433 
434     modifier canWithdrawLockup() {
435         require(state == State.Lockup);
436         require(endTime.add(lockupPeriod) < block.timestamp);
437         _;
438     }
439 
440     function RocketTokenCrowdsale(
441         address _admin, /*used as the wallet for collecting funds*/
442         address _team,
443         address _me,
444         address _investor)
445     Crowdsale(
446         block.timestamp + 10, // 2018-02-01T00:00:00+00:00 - 1517443200
447         1527811200, // 2018-08-01T00:00:00+00:00 - 
448         1000,/* start rate - 1000 */
449         _admin
450     )  
451     public 
452     {      
453         wallets[0] = _team;
454         wallets[1] = _me;
455         owner = _admin;
456         token.mint(_investor, InvestorSum);
457     }
458 
459     // creates the token to be sold.
460     // override this method to have crowdsale of a specific MintableToken token.
461     function createTokenContract() internal returns (MintableToken) {
462         return new RocketToken();
463     }
464 
465     function forwardFunds() internal {
466         forwardFundsAmount(msg.value);
467     }
468 
469     function forwardFundsAmount(uint256 amount) internal {
470         wallet.transfer(amount);
471     }
472 
473     function refundAmount(uint256 amount) internal {
474         msg.sender.transfer(amount);
475     }
476 
477     function fixAddress(address newAddress, uint256 walletIndex) onlyOwner public {
478         wallets[walletIndex] = newAddress;
479     }
480 
481     function calculateCurrentRate() internal {
482         if (state == State.NormalSale) {
483             rate = 500;
484         }
485     }
486 
487     function buyTokensUpdateState() internal {
488         if(state == State.BeforeSale && now >= startTimeNumber) { state = State.Bonus; }
489         if(state == State.Bonus && now >= bonusEndTime) { state = State.NormalSale; }
490         calculateCurrentRate();
491         require(state != State.ShouldFinalize && state != State.Lockup && state != State.SaleOver && msg.value >= toDec.div(2));
492         if(msg.value.mul(rate) >= tokensLeft) { state = State.ShouldFinalize; }
493     }
494 
495     function buyTokens(address beneficiary) public payable {
496         buyTokensUpdateState();
497         var numTokens = msg.value.mul(rate);
498         if(state == State.ShouldFinalize) {
499             lastTokens(beneficiary);
500             numTokens = tokensLeft;
501         }
502         else {
503             tokensLeft = tokensLeft.sub(numTokens); // if negative, should finalize
504             super.buyTokens(beneficiary);
505         }
506     }
507 
508     function lastTokens(address beneficiary) internal {
509         require(beneficiary != 0x0);
510         require(validPurchase());
511 
512         uint256 weiAmount = msg.value;
513 
514         // calculate token amount to be created
515         uint256 tokensForFullBuy = weiAmount.mul(rate);// must be bigger or equal to tokensLeft to get here
516         uint256 tokensToRefundFor = tokensForFullBuy.sub(tokensLeft);
517         uint256 tokensRemaining = tokensForFullBuy.sub(tokensToRefundFor);
518         uint256 weiAmountToRefund = tokensToRefundFor.div(rate);
519         uint256 weiRemaining = weiAmount.sub(weiAmountToRefund);
520         
521         // update state
522         weiRaised = weiRaised.add(weiRemaining);
523 
524         token.mint(beneficiary, tokensRemaining);
525         TokenPurchase(msg.sender, beneficiary, weiRemaining, tokensRemaining);
526 
527         forwardFundsAmount(weiRemaining);
528         refundAmount(weiAmountToRefund);
529     }
530 
531     function withdrawLockupTokens() canWithdrawLockup public {
532         token.mint(wallets[1], MeSum);
533         token.mint(wallets[0], TeamSum);
534         LockupTokensWithdrawn = true;
535         LockedUpTokensWithdrawn();
536         state = State.SaleOver;
537     }
538 
539     function finalizeUpdateState() internal {
540         if(now > endTime) { state = State.ShouldFinalize; }
541         if(tokensLeft == 0) { state = State.ShouldFinalize; }
542     }
543 
544     function finalize() public {
545         finalizeUpdateState();
546         require (state == State.ShouldFinalize);
547 
548         finalization();
549         Finalized();
550     }
551 
552     function finalization() internal {
553         endTime = block.timestamp;
554         /* - preICO investors - */
555         tokensLeft = 0;
556         state = State.Lockup;
557     }
558 }