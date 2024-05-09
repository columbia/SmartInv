1 pragma solidity ^0.4.15;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55   function div(uint256 a, uint256 b) internal constant returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 /**
72  * @title Crowdsale
73  * @dev Crowdsale is a base contract for managing a token crowdsale.
74  * Crowdsales have a start and end timestamps, where investors can make
75  * token purchases and the crowdsale will assign them tokens based
76  * on a token per ETH rate. Funds collected are forwarded to a wallet
77  * as they arrive.
78  */
79 contract Crowdsale {
80   using SafeMath for uint256;
81   // The token being sold
82 //  MintableToken public token;
83   address public tokenAddr;
84   TestTokenA public testTokenA;
85   // start and end timestamps where investments are allowed (both inclusive)
86   uint256 public startTime;
87   uint256 public endTime;
88   // address where funds are collected
89   address public wallet;
90   // how many token units a buyer gets per wei
91   uint256 public rate;
92   // amount of raised money in wei
93   uint256 public weiRaised;
94   /**
95    * event for token purchase logging
96    * @param purchaser who paid for the tokens
97    * @param beneficiary who got the tokens
98    * @param value weis paid for purchase
99    * @param amount amount of tokens purchased
100    */
101   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
102   function Crowdsale(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
103     require(_startTime >= now);
104     require(_endTime >= _startTime);
105     require(_rate > 0);
106     require(_wallet != 0x0);
107     require(_tokenAddress != 0x0);
108 //    createTokenContract(_tokenAddress);
109 //    createTokenContract();
110     tokenAddr = _tokenAddress;
111     startTime = _startTime;
112     endTime = _endTime;
113     rate = _rate;
114     wallet = _wallet;
115   }
116   // creates the token to be sold.
117   // override this method to have crowdsale of a specific mintable token.
118 //  function createTokenContract() internal returns (MintableToken) {
119 //      return new TestTokenA();
120 ////    return MintableToken(_tokenAddress);
121 //  }
122   // fallback function can be used to buy tokens
123   function () payable {
124     buyTokens(msg.sender);
125   }
126   // low level token purchase function
127   function buyTokens(address beneficiary) public payable {
128     require(beneficiary != 0x0);
129     require(validPurchase());
130     uint256 weiAmount = msg.value;
131     // calculate token amount to be created
132     uint256 tokens = weiAmount.mul(rate);
133     // update state
134     weiRaised = weiRaised.add(weiAmount);
135 //    token.mint(beneficiary, tokens);
136 //    bytes4 methodId = bytes4(keccak256("mint(address,uint256)"));
137 //    tokenAddr.call(methodId, beneficiary, tokens);
138     testTokenA = TestTokenA(tokenAddr);
139     testTokenA.mint(beneficiary, tokens);
140     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
141     forwardFunds();
142   }
143   // send ether to the fund collection wallet
144   // override to create custom fund forwarding mechanisms
145   function forwardFunds() internal {
146     wallet.transfer(msg.value);
147   }
148   // @return true if the transaction can buy tokens
149   function validPurchase() internal constant returns (bool) {
150     bool withinPeriod = now >= startTime && now <= endTime;
151     bool nonZeroPurchase = msg.value != 0;
152     return withinPeriod && nonZeroPurchase;
153   }
154   // @return true if crowdsale event has ended
155   function hasEnded() public constant returns (bool) {
156     return now > endTime;
157   }
158 }
159 /**
160  * @title CappedCrowdsale
161  * @dev Extension of Crowdsale with a max amount of funds raised
162  */
163 contract CappedCrowdsale is Crowdsale {
164   using SafeMath for uint256;
165   uint256 public cap;
166   function CappedCrowdsale(uint256 _cap) {
167     require(_cap > 0);
168     cap = _cap;
169   }
170   // overriding Crowdsale#validPurchase to add extra cap logic
171   // @return true if investors can buy at the moment
172   function validPurchase() internal constant returns (bool) {
173     bool withinCap = weiRaised.add(msg.value) <= cap;
174     return super.validPurchase() && withinCap;
175   }
176   // overriding Crowdsale#hasEnded to add cap logic
177   // @return true if crowdsale event has ended
178   function hasEnded() public constant returns (bool) {
179     bool capReached = weiRaised >= cap;
180     return super.hasEnded() || capReached;
181   }
182 }
183 /**
184  * @title FinalizableCrowdsale
185  * @dev Extension of Crowdsale where an owner can do extra work
186  * after finishing.
187  */
188 contract FinalizableCrowdsale is Crowdsale, Ownable {
189   using SafeMath for uint256;
190   bool public isFinalized = false;
191   event Finalized();
192   /**
193    * @dev Must be called after crowdsale ends, to do some extra finalization
194    * work. Calls the contract's finalization function.
195    */
196   function finalize() onlyOwner public {
197     require(!isFinalized);
198     require(hasEnded());
199     finalization();
200     Finalized();
201     isFinalized = true;
202   }
203   /**
204    * @dev Can be overridden to add finalization logic. The overriding function
205    * should call super.finalization() to ensure the chain of finalization is
206    * executed entirely.
207    */
208   function finalization() internal {
209   }
210 }
211 /**
212  * @title RefundVault
213  * @dev This contract is used for storing funds while a crowdsale
214  * is in progress. Supports refunding the money if crowdsale fails,
215  * and forwarding it if crowdsale is successful.
216  */
217 contract RefundVault is Ownable {
218   using SafeMath for uint256;
219   enum State { Active, Refunding, Closed }
220   mapping (address => uint256) public deposited;
221   address public wallet;
222   State public state;
223   event Closed();
224   event RefundsEnabled();
225   event Refunded(address indexed beneficiary, uint256 weiAmount);
226   function RefundVault(address _wallet) {
227     require(_wallet != 0x0);
228     wallet = _wallet;
229     state = State.Active;
230   }
231   function deposit(address investor) onlyOwner public payable {
232     require(state == State.Active);
233     deposited[investor] = deposited[investor].add(msg.value);
234   }
235   function close() onlyOwner public {
236     require(state == State.Active);
237     state = State.Closed;
238     Closed();
239     wallet.transfer(this.balance);
240   }
241   function enableRefunds() onlyOwner public {
242     require(state == State.Active);
243     state = State.Refunding;
244     RefundsEnabled();
245   }
246   function refund(address investor) public {
247     require(state == State.Refunding);
248     uint256 depositedValue = deposited[investor];
249     deposited[investor] = 0;
250     investor.transfer(depositedValue);
251     Refunded(investor, depositedValue);
252   }
253 }
254 /**
255  * @title RefundableCrowdsale
256  * @dev Extension of Crowdsale contract that adds a funding goal, and
257  * the possibility of users getting a refund if goal is not met.
258  * Uses a RefundVault as the crowdsale's vault.
259  */
260 contract RefundableCrowdsale is FinalizableCrowdsale {
261   using SafeMath for uint256;
262   // minimum amount of funds to be raised in weis
263   uint256 public goal;
264   // refund vault used to hold funds while crowdsale is running
265   RefundVault public vault;
266   function RefundableCrowdsale(uint256 _goal) {
267     require(_goal > 0);
268     vault = new RefundVault(wallet);
269     goal = _goal;
270   }
271   // We're overriding the fund forwarding from Crowdsale.
272   // In addition to sending the funds, we want to call
273   // the RefundVault deposit function
274   function forwardFunds() internal {
275     vault.deposit.value(msg.value)(msg.sender);
276   }
277   // if crowdsale is unsuccessful, investors can claim refunds here
278   function claimRefund() public {
279     require(isFinalized);
280     require(!goalReached());
281     vault.refund(msg.sender);
282   }
283 //  // if crowdsale is unsuccessful, investors can claim refunds here
284 //  function claimRefund() notPaused public returns (bool) {
285 //    require(!goalReached);
286 //    require(hasEnded());
287 //    uint contributedAmt = weiContributed[msg.sender];
288 //    require(contributedAmt > 0);
289 //    weiContributed[msg.sender] = 0;
290 //    msg.sender.transfer(contributedAmt);
291 //    LogClaimRefund(msg.sender, contributedAmt);
292 //    return true;
293 //  }
294   // vault finalization task, called when owner calls finalize()
295   function finalization() internal {
296     if (goalReached()) {
297       vault.close();
298     } else {
299       vault.enableRefunds();
300     }
301     super.finalization();
302   }
303   function goalReached() public constant returns (bool) {
304     return weiRaised >= goal;
305   }
306 }
307 /**
308  * @title Destructible
309  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
310  */
311 contract Destructible is Ownable {
312   function Destructible() payable { }
313   /**
314    * @dev Transfers the current balance to the owner and terminates the contract.
315    */
316   function destroy() onlyOwner public {
317     selfdestruct(owner);
318   }
319   function destroyAndSend(address _recipient) onlyOwner public {
320     selfdestruct(_recipient);
321   }
322 }
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract Pausable is Ownable {
328   event Pause();
329   event Unpause();
330   bool public paused = false;
331   /**
332    * @dev Modifier to make a function callable only when the contract is not paused.
333    */
334   modifier whenNotPaused() {
335     require(!paused);
336     _;
337   }
338   /**
339    * @dev Modifier to make a function callable only when the contract is paused.
340    */
341   modifier whenPaused() {
342     require(paused);
343     _;
344   }
345   /**
346    * @dev called by the owner to pause, triggers stopped state
347    */
348   function pause() onlyOwner whenNotPaused public {
349     paused = true;
350     Pause();
351   }
352   /**
353    * @dev called by the owner to unpause, returns to normal state
354    */
355   function unpause() onlyOwner whenPaused public {
356     paused = false;
357     Unpause();
358   }
359 }
360 /**
361  * @title Basic token
362  * @dev Basic version of StandardToken, with no allowances.
363  */
364 contract BasicToken is ERC20Basic {
365   using SafeMath for uint256;
366   mapping(address => uint256) balances;
367   /**
368   * @dev transfer token for a specified address
369   * @param _to The address to transfer to.
370   * @param _value The amount to be transferred.
371   */
372   function transfer(address _to, uint256 _value) public returns (bool) {
373     require(_to != address(0));
374     // SafeMath.sub will throw if there is not enough balance.
375     balances[msg.sender] = balances[msg.sender].sub(_value);
376     balances[_to] = balances[_to].add(_value);
377     Transfer(msg.sender, _to, _value);
378     return true;
379   }
380   /**
381   * @dev Gets the balance of the specified address.
382   * @param _owner The address to query the the balance of.
383   * @return An uint256 representing the amount owned by the passed address.
384   */
385   function balanceOf(address _owner) public constant returns (uint256 balance) {
386     return balances[_owner];
387   }
388 }
389 /**
390  * @title ERC20 interface
391  * @dev see https://github.com/ethereum/EIPs/issues/20
392  */
393 contract ERC20 is ERC20Basic {
394   function allowance(address owner, address spender) public constant returns (uint256);
395   function transferFrom(address from, address to, uint256 value) public returns (bool);
396   function approve(address spender, uint256 value) public returns (bool);
397   event Approval(address indexed owner, address indexed spender, uint256 value);
398 }
399 /**
400  * @title Standard ERC20 token
401  *
402  * @dev Implementation of the basic standard token.
403  * @dev https://github.com/ethereum/EIPs/issues/20
404  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
405  */
406 contract StandardToken is ERC20, BasicToken {
407   mapping (address => mapping (address => uint256)) allowed;
408   /**
409    * @dev Transfer tokens from one address to another
410    * @param _from address The address which you want to send tokens from
411    * @param _to address The address which you want to transfer to
412    * @param _value uint256 the amount of tokens to be transferred
413    */
414   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
415     require(_to != address(0));
416     uint256 _allowance = allowed[_from][msg.sender];
417     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
418     // require (_value <= _allowance);
419     balances[_from] = balances[_from].sub(_value);
420     balances[_to] = balances[_to].add(_value);
421     allowed[_from][msg.sender] = _allowance.sub(_value);
422     Transfer(_from, _to, _value);
423     return true;
424   }
425   /**
426    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
427    *
428    * Beware that changing an allowance with this method brings the risk that someone may use both the old
429    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
430    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
431    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
432    * @param _spender The address which will spend the funds.
433    * @param _value The amount of tokens to be spent.
434    */
435   function approve(address _spender, uint256 _value) public returns (bool) {
436     allowed[msg.sender][_spender] = _value;
437     Approval(msg.sender, _spender, _value);
438     return true;
439   }
440   /**
441    * @dev Function to check the amount of tokens that an owner allowed to a spender.
442    * @param _owner address The address which owns the funds.
443    * @param _spender address The address which will spend the funds.
444    * @return A uint256 specifying the amount of tokens still available for the spender.
445    */
446   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
447     return allowed[_owner][_spender];
448   }
449   /**
450    * approve should be called when allowed[_spender] == 0. To increment
451    * allowed value is better to use this function to avoid 2 calls (and wait until
452    * the first transaction is mined)
453    * From MonolithDAO Token.sol
454    */
455   function increaseApproval (address _spender, uint _addedValue)
456     returns (bool success) {
457     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
458     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
459     return true;
460   }
461   function decreaseApproval (address _spender, uint _subtractedValue)
462     returns (bool success) {
463     uint oldValue = allowed[msg.sender][_spender];
464     if (_subtractedValue > oldValue) {
465       allowed[msg.sender][_spender] = 0;
466     } else {
467       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
468     }
469     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
470     return true;
471   }
472 }
473 /**
474  * @title Mintable token
475  * @dev Simple ERC20 Token example, with mintable token creation
476  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
477  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
478  */
479 contract MintableToken is StandardToken, Ownable {
480   event Mint(address indexed to, uint256 amount);
481   event MintFinished();
482   bool public mintingFinished = false;
483   modifier canMint() {
484     require(!mintingFinished);
485     _;
486   }
487   /**
488    * @dev Function to mint tokens
489    * @param _to The address that will receive the minted tokens.
490    * @param _amount The amount of tokens to mint.
491    * @return A boolean that indicates if the operation was successful.
492    */
493 //  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
494   function mint(address _to, uint256 _amount) public returns (bool) {
495     totalSupply = totalSupply.add(_amount);
496     balances[_to] = balances[_to].add(_amount);
497     Mint(_to, _amount);
498     Transfer(0x0, _to, _amount);
499     return true;
500   }
501   /**
502    * @dev Function to stop minting new tokens.
503    * @return True if the operation was successful.
504    */
505   function finishMinting() onlyOwner public returns (bool) {
506     mintingFinished = true;
507     MintFinished();
508     return true;
509   }
510 }
511 contract TestTokenA is MintableToken {
512   string public constant name = "TestTokenA";
513   string public constant symbol = "ZNX";
514   uint8 public constant decimals = 18;
515   uint256 public constant initialSupply = 65000000 * (10 ** uint256(decimals));    // number of tokens in reserve
516   /*
517    * gives msg.sender all of existing tokens.
518    */
519   function TestTokenA() {
520     totalSupply = initialSupply;
521     balances[msg.sender] = initialSupply;
522   }
523 }
524 contract TestTokenAPreICO is CappedCrowdsale, RefundableCrowdsale, Destructible, Pausable {
525   function TestTokenAPreICO(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet)
526     CappedCrowdsale(_cap)
527     FinalizableCrowdsale()
528     RefundableCrowdsale(_goal)
529     Crowdsale(_tokenAddress, _startTime, _endTime, _rate, _wallet)
530   {
531     //As goal needs to be met for a successful crowdsale
532     //the value needs to less or equal than a cap which is limit for accepted funds
533     require(_goal <= _cap);
534   }
535 }