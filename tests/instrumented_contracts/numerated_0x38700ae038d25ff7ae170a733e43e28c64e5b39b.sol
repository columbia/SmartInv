1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 
113 
114 
115 
116 
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) public view returns (uint256);
124   function transferFrom(address from, address to, uint256 value) public returns (bool);
125   function approve(address spender, uint256 value) public returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    *
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) public view returns (uint256) {
184     return allowed[_owner][_spender];
185   }
186 
187   /**
188    * @dev Increase the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To increment
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _addedValue The amount of tokens to increase the allowance by.
196    */
197   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   /**
204    * @dev Decrease the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To decrement
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _subtractedValue The amount of tokens to decrease the allowance by.
212    */
213   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 
227 
228 
229 
230 /**
231  * @title Mintable token
232  * @dev Simple ERC20 Token example, with mintable token creation
233  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
234  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
235  */
236 
237 contract MintableToken is StandardToken, Ownable {
238   event Mint(address indexed to, uint256 amount);
239   event MintFinished();
240 
241   bool public mintingFinished = false;
242 
243 
244   modifier canMint() {
245     require(!mintingFinished);
246     _;
247   }
248 
249   /**
250    * @dev Function to mint tokens
251    * @param _to The address that will receive the minted tokens.
252    * @param _amount The amount of tokens to mint.
253    * @return A boolean that indicates if the operation was successful.
254    */
255   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
256     totalSupply = totalSupply.add(_amount);
257     balances[_to] = balances[_to].add(_amount);
258     Mint(_to, _amount);
259     Transfer(address(0), _to, _amount);
260     return true;
261   }
262 
263   /**
264    * @dev Function to stop minting new tokens.
265    * @return True if the operation was successful.
266    */
267   function finishMinting() onlyOwner canMint public returns (bool) {
268     mintingFinished = true;
269     MintFinished();
270     return true;
271   }
272 }
273 
274 
275 // Author: Eugenio Noyola Leon www.k3no.com
276 
277 contract RedFundToken is MintableToken {
278   string public name = "RED FUND TOKEN";
279   string public symbol = "REDF";
280   uint8 public decimals = 18;
281 }
282 
283 
284 
285 
286 
287 
288 
289 /**
290  * @title SafeMath
291  * @dev Math operations with safety checks that throw on error
292  */
293 library SafeMath {
294   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295     if (a == 0) {
296       return 0;
297     }
298     uint256 c = a * b;
299     assert(c / a == b);
300     return c;
301   }
302 
303   function div(uint256 a, uint256 b) internal pure returns (uint256) {
304     // assert(b > 0); // Solidity automatically throws when dividing by 0
305     uint256 c = a / b;
306     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
307     return c;
308   }
309 
310   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
311     assert(b <= a);
312     return a - b;
313   }
314 
315   function add(uint256 a, uint256 b) internal pure returns (uint256) {
316     uint256 c = a + b;
317     assert(c >= a);
318     return c;
319   }
320 }
321 
322 
323 
324 
325 
326 
327 
328 
329 
330 
331 /**
332  * @title Crowdsale
333  * @dev Crowdsale is a base contract for managing a token crowdsale.
334  * Crowdsales have a start and end timestamps, where investors can make
335  * token purchases and the crowdsale will assign them tokens based
336  * on a token per ETH rate. Funds collected are forwarded to a wallet
337  * as they arrive.
338  */
339 contract Crowdsale {
340   using SafeMath for uint256;
341 
342   // The token being sold
343   MintableToken public token;
344 
345   // start and end timestamps where investments are allowed (both inclusive)
346   uint256 public startTime;
347   uint256 public endTime;
348 
349   // address where funds are collected
350   address public wallet;
351 
352   // how many token units a buyer gets per wei
353   uint256 public rate;
354 
355   // amount of raised money in wei
356   uint256 public weiRaised;
357 
358   /**
359    * event for token purchase logging
360    * @param purchaser who paid for the tokens
361    * @param beneficiary who got the tokens
362    * @param value weis paid for purchase
363    * @param amount amount of tokens purchased
364    */
365   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
366 
367 
368   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
369     /* require(_startTime >= now); */
370     require(_endTime >= _startTime);
371     require(_rate > 0);
372     require(_wallet != address(0));
373 
374     token = createTokenContract();
375     startTime = _startTime;
376     endTime = _endTime;
377     rate = _rate;
378     wallet = _wallet;
379   }
380 
381   // creates the token to be sold.
382   // override this method to have crowdsale of a specific mintable token.
383   function createTokenContract() internal returns (MintableToken) {
384     return new MintableToken();
385   }
386 
387 
388   // fallback function can be used to buy tokens
389   function () external payable {
390     buyTokens(msg.sender);
391   }
392 
393   // low level token purchase function
394   function buyTokens(address beneficiary) public payable {
395     require(beneficiary != address(0));
396     require(validPurchase());
397 
398     uint256 weiAmount = msg.value;
399 
400     // calculate token amount to be created
401     uint256 tokens = weiAmount.mul(rate);
402 
403     // update state
404     weiRaised = weiRaised.add(weiAmount);
405 
406     token.mint(beneficiary, tokens);
407     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
408 
409     forwardFunds();
410   }
411 
412   // send ether to the fund collection wallet
413   // override to create custom fund forwarding mechanisms
414   function forwardFunds() internal {
415     wallet.transfer(msg.value);
416   }
417 
418   // @return true if the transaction can buy tokens
419   function validPurchase() internal view returns (bool) {
420     bool withinPeriod = now >= startTime && now <= endTime;
421     bool nonZeroPurchase = msg.value != 0;
422     return withinPeriod && nonZeroPurchase;
423   }
424 
425   // @return true if crowdsale event has ended
426   function hasEnded() public view returns (bool) {
427     return now > endTime;
428   }
429 
430 
431 }
432 
433 
434 /**
435  * @title FinalizableCrowdsale
436  * @dev Extension of Crowdsale where an owner can do extra work
437  * after finishing.
438  */
439 contract FinalizableCrowdsale is Crowdsale, Ownable {
440   using SafeMath for uint256;
441 
442   bool public isFinalized = false;
443 
444   event Finalized();
445 
446   /**
447    * @dev Must be called after crowdsale ends, to do some extra finalization
448    * work. Calls the contract's finalization function.
449    */
450   function finalize() onlyOwner public {
451     require(!isFinalized);
452     require(hasEnded());
453 
454     finalization();
455     Finalized();
456 
457     isFinalized = true;
458   }
459 
460   /**
461    * @dev Can be overridden to add finalization logic. The overriding function
462    * should call super.finalization() to ensure the chain of finalization is
463    * executed entirely.
464    */
465   function finalization() internal {
466   }
467 }
468 
469 
470 
471 
472 
473 
474 /**
475  * @title RefundVault
476  * @dev This contract is used for storing funds while a crowdsale
477  * is in progress. Supports refunding the money if crowdsale fails,
478  * and forwarding it if crowdsale is successful.
479  */
480 contract RefundVault is Ownable {
481   using SafeMath for uint256;
482 
483   enum State { Active, Refunding, Closed }
484 
485   mapping (address => uint256) public deposited;
486   address public wallet;
487   State public state;
488 
489   event Closed();
490   event RefundsEnabled();
491   event Refunded(address indexed beneficiary, uint256 weiAmount);
492 
493   function RefundVault(address _wallet) public {
494     require(_wallet != address(0));
495     wallet = _wallet;
496     state = State.Active;
497   }
498 
499   function deposit(address investor) onlyOwner public payable {
500     require(state == State.Active);
501     deposited[investor] = deposited[investor].add(msg.value);
502   }
503 
504   function close() onlyOwner public {
505     require(state == State.Active);
506     state = State.Closed;
507     Closed();
508     wallet.transfer(this.balance);
509   }
510 
511   function enableRefunds() onlyOwner public {
512     require(state == State.Active);
513     state = State.Refunding;
514     RefundsEnabled();
515   }
516 
517   function refund(address investor) public {
518     require(state == State.Refunding);
519     uint256 depositedValue = deposited[investor];
520     deposited[investor] = 0;
521     investor.transfer(depositedValue);
522     Refunded(investor, depositedValue);
523   }
524 }
525 
526 
527 
528 /**
529  * @title RefundableCrowdsale
530  * @dev Extension of Crowdsale contract that adds a funding goal, and
531  * the possibility of users getting a refund if goal is not met.
532  * Uses a RefundVault as the crowdsale's vault.
533  */
534 contract RefundableCrowdsale is FinalizableCrowdsale {
535   using SafeMath for uint256;
536 
537   // minimum amount of funds to be raised in weis
538   uint256 public goal;
539 
540   // refund vault used to hold funds while crowdsale is running
541   RefundVault public vault;
542 
543   function RefundableCrowdsale(uint256 _goal) public {
544     require(_goal > 0);
545     vault = new RefundVault(wallet);
546     goal = _goal;
547   }
548 
549   // We're overriding the fund forwarding from Crowdsale.
550   // In addition to sending the funds, we want to call
551   // the RefundVault deposit function
552   function forwardFunds() internal {
553     vault.deposit.value(msg.value)(msg.sender);
554   }
555 
556   // if crowdsale is unsuccessful, investors can claim refunds here
557   function claimRefund() public {
558     require(isFinalized);
559     require(!goalReached());
560 
561     vault.refund(msg.sender);
562   }
563 
564   // vault finalization task, called when owner calls finalize()
565   function finalization() internal {
566     if (goalReached()) {
567       vault.close();
568     } else {
569       vault.enableRefunds();
570     }
571 
572     super.finalization();
573   }
574 
575   function goalReached() public view returns (bool) {
576     return weiRaised >= goal;
577   }
578 
579 }
580 
581 
582 
583 // Author: Eugenio Noyola Leon www.k3no.com
584 
585 contract RedFundCrowdsale is RefundableCrowdsale {
586 
587   uint256 public minAmount = 2000000000000000000;
588 
589   // Constructor
590 
591   function RedFundCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startTime, _endTime, _rate, _wallet) public {
592   }
593 
594   // Token Deployment
595   function createTokenContract() internal returns (MintableToken) {
596     return new RedFundToken();
597   }
598 
599   // Change the current rate
600   function setCurrentRate(uint256 _rate) public onlyOwner{
601       rate = _rate;
602   }
603 
604   // Set Minimum Contribution
605   function setMinimum(uint256 _minAmount) public onlyOwner{
606       minAmount = _minAmount;
607   }
608 
609   // Extend Crowdsale
610   function extendCrowdsale(uint256 _endTime) public onlyOwner{
611       endTime = _endTime;
612   }
613 
614   // Set Goal
615   function setGoal(uint256 _goal) public onlyOwner{
616       goal = _goal;
617   }
618 
619   // Token Purchase
620 
621   function () external payable {
622       require(msg.value >= minAmount);
623       buyTokens(msg.sender);
624   }
625 
626   // Convenience functions
627   function mintOnDemand(address _benef, uint256 _tokens) public onlyOwner{
628     token.mint(_benef, _tokens);
629   }
630 
631 
632   function changeTokenOwner(address _newOwner) public onlyOwner{
633     token.transferOwnership(_newOwner);
634   }
635 
636   // Finish:
637 
638   function finish() public onlyOwner {
639       require(!isFinalized);
640         finalize();
641   }
642 
643 }