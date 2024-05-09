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
82   address public tokenAddr;
83   AtomToken public atomToken;
84   // start and end timestamps where investments are allowed (both inclusive)
85   uint256 public startTime;
86   uint256 public endTime;
87   // address where funds are collected
88   address public wallet;
89   // how many token units a buyer gets per wei
90   uint256 public rate;
91   // amount of raised money in wei
92   uint256 public weiRaised;
93   /**
94    * event for token purchase logging
95    * @param purchaser who paid for the tokens
96    * @param beneficiary who got the tokens
97    * @param value weis paid for purchase
98    * @param amount amount of tokens purchased
99    */
100   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
101   function Crowdsale(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
102     require(_startTime >= now);
103     require(_endTime >= _startTime);
104     require(_rate > 0);
105     require(_wallet != 0x0);
106     require(_tokenAddress != 0x0);
107     tokenAddr = _tokenAddress;
108     startTime = _startTime;
109     endTime = _endTime;
110     rate = _rate;
111     wallet = _wallet;
112   }
113   // fallback function can be used to buy tokens
114   function () payable {
115     buyTokens(msg.sender);
116   }
117   // low level token purchase function
118   function buyTokens(address beneficiary) public payable {
119     require(beneficiary != 0x0);
120     require(validPurchase());
121     uint256 weiAmount = msg.value;
122     // calculate token amount to be created
123     uint256 tokens = weiAmount.mul(rate);
124     // update state
125     weiRaised = weiRaised.add(weiAmount);
126     atomToken = AtomToken(tokenAddr);
127     atomToken.mint(beneficiary, tokens);
128     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
129     forwardFunds();
130   }
131   // send ether to the fund collection wallet
132   // override to create custom fund forwarding mechanisms
133   function forwardFunds() internal {
134     wallet.transfer(msg.value);
135   }
136   // @return true if the transaction can buy tokens
137   function validPurchase() internal constant returns (bool) {
138     bool withinPeriod = now >= startTime && now <= endTime;
139     bool nonZeroPurchase = msg.value != 0;
140     return withinPeriod && nonZeroPurchase;
141   }
142   // @return true if crowdsale event has ended
143   function hasEnded() public constant returns (bool) {
144     return now > endTime;
145   }
146 }
147 /**
148  * @title CappedCrowdsale
149  * @dev Extension of Crowdsale with a max amount of funds raised
150  */
151 contract CappedCrowdsale is Crowdsale {
152   using SafeMath for uint256;
153   uint256 public cap;
154   function CappedCrowdsale(uint256 _cap) {
155     require(_cap > 0);
156     cap = _cap;
157   }
158   // overriding Crowdsale#validPurchase to add extra cap logic
159   // @return true if investors can buy at the moment
160   function validPurchase() internal constant returns (bool) {
161     bool withinCap = weiRaised.add(msg.value) <= cap;
162     return super.validPurchase() && withinCap;
163   }
164   // overriding Crowdsale#hasEnded to add cap logic
165   // @return true if crowdsale event has ended
166   function hasEnded() public constant returns (bool) {
167     bool capReached = weiRaised >= cap;
168     return super.hasEnded() || capReached;
169   }
170 }
171 /**
172  * @title FinalizableCrowdsale
173  * @dev Extension of Crowdsale where an owner can do extra work
174  * after finishing.
175  */
176 contract FinalizableCrowdsale is Crowdsale, Ownable {
177   using SafeMath for uint256;
178   bool public isFinalized = false;
179   event Finalized();
180   /**
181    * @dev Must be called after crowdsale ends, to do some extra finalization
182    * work. Calls the contract's finalization function.
183    */
184   function finalize() onlyOwner public {
185     require(!isFinalized);
186     require(hasEnded());
187     finalization();
188     Finalized();
189     isFinalized = true;
190   }
191   /**
192    * @dev Can be overridden to add finalization logic. The overriding function
193    * should call super.finalization() to ensure the chain of finalization is
194    * executed entirely.
195    */
196   function finalization() internal {
197   }
198 }
199 /**
200  * @title RefundVault
201  * @dev This contract is used for storing funds while a crowdsale
202  * is in progress. Supports refunding the money if crowdsale fails,
203  * and forwarding it if crowdsale is successful.
204  */
205 contract RefundVault is Ownable {
206   using SafeMath for uint256;
207   enum State { Active, Refunding, Closed }
208   mapping (address => uint256) public deposited;
209   address public wallet;
210   State public state;
211   event Closed();
212   event RefundsEnabled();
213   event Refunded(address indexed beneficiary, uint256 weiAmount);
214   function RefundVault(address _wallet) {
215     require(_wallet != 0x0);
216     wallet = _wallet;
217     state = State.Active;
218   }
219   function deposit(address investor) onlyOwner public payable {
220     require(state == State.Active);
221     deposited[investor] = deposited[investor].add(msg.value);
222   }
223   function close() onlyOwner public {
224     require(state == State.Active);
225     state = State.Closed;
226     Closed();
227     wallet.transfer(this.balance);
228   }
229   function enableRefunds() onlyOwner public {
230     require(state == State.Active);
231     state = State.Refunding;
232     RefundsEnabled();
233   }
234   function refund(address investor) public {
235     require(state == State.Refunding);
236     uint256 depositedValue = deposited[investor];
237     deposited[investor] = 0;
238     investor.transfer(depositedValue);
239     Refunded(investor, depositedValue);
240   }
241 }
242 /**
243  * @title RefundableCrowdsale
244  * @dev Extension of Crowdsale contract that adds a funding goal, and
245  * the possibility of users getting a refund if goal is not met.
246  * Uses a RefundVault as the crowdsale's vault.
247  */
248 contract RefundableCrowdsale is FinalizableCrowdsale {
249   using SafeMath for uint256;
250   // minimum amount of funds to be raised in weis
251   uint256 public goal;
252   // refund vault used to hold funds while crowdsale is running
253   RefundVault public vault;
254   function RefundableCrowdsale(uint256 _goal) {
255     require(_goal > 0);
256     vault = new RefundVault(wallet);
257     goal = _goal;
258   }
259   // We're overriding the fund forwarding from Crowdsale.
260   // In addition to sending the funds, we want to call
261   // the RefundVault deposit function
262   function forwardFunds() internal {
263     vault.deposit.value(msg.value)(msg.sender);
264   }
265   // if crowdsale is unsuccessful, investors can claim refunds here
266   function claimRefund() public {
267     require(isFinalized);
268     require(!goalReached());
269     vault.refund(msg.sender);
270   }
271 //  // if crowdsale is unsuccessful, investors can claim refunds here
272 //  function claimRefund() notPaused public returns (bool) {
273 //    require(!goalReached);
274 //    require(hasEnded());
275 //    uint contributedAmt = weiContributed[msg.sender];
276 //    require(contributedAmt > 0);
277 //    weiContributed[msg.sender] = 0;
278 //    msg.sender.transfer(contributedAmt);
279 //    LogClaimRefund(msg.sender, contributedAmt);
280 //    return true;
281 //  }
282   // vault finalization task, called when owner calls finalize()
283   function finalization() internal {
284     if (goalReached()) {
285       vault.close();
286     } else {
287       vault.enableRefunds();
288     }
289     super.finalization();
290   }
291   function goalReached() public constant returns (bool) {
292     return weiRaised >= goal;
293   }
294 }
295 /**
296  * @title Destructible
297  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
298  */
299 contract Destructible is Ownable {
300   function Destructible() payable { }
301   /**
302    * @dev Transfers the current balance to the owner and terminates the contract.
303    */
304   function destroy() onlyOwner public {
305     selfdestruct(owner);
306   }
307   function destroyAndSend(address _recipient) onlyOwner public {
308     selfdestruct(_recipient);
309   }
310 }
311 /**
312  * @title Pausable
313  * @dev Base contract which allows children to implement an emergency stop mechanism.
314  */
315 contract Pausable is Ownable {
316   event Pause();
317   event Unpause();
318   bool public paused = false;
319   /**
320    * @dev Modifier to make a function callable only when the contract is not paused.
321    */
322   modifier whenNotPaused() {
323     require(!paused);
324     _;
325   }
326   /**
327    * @dev Modifier to make a function callable only when the contract is paused.
328    */
329   modifier whenPaused() {
330     require(paused);
331     _;
332   }
333   /**
334    * @dev called by the owner to pause, triggers stopped state
335    */
336   function pause() onlyOwner whenNotPaused public {
337     paused = true;
338     Pause();
339   }
340   /**
341    * @dev called by the owner to unpause, returns to normal state
342    */
343   function unpause() onlyOwner whenPaused public {
344     paused = false;
345     Unpause();
346   }
347 }
348 /**
349  * @title Basic token
350  * @dev Basic version of StandardToken, with no allowances.
351  */
352 contract BasicToken is ERC20Basic {
353   using SafeMath for uint256;
354   mapping(address => uint256) balances;
355   /**
356   * @dev transfer token for a specified address
357   * @param _to The address to transfer to.
358   * @param _value The amount to be transferred.
359   */
360   function transfer(address _to, uint256 _value) public returns (bool) {
361     require(_to != address(0));
362     // SafeMath.sub will throw if there is not enough balance.
363     balances[msg.sender] = balances[msg.sender].sub(_value);
364     balances[_to] = balances[_to].add(_value);
365     Transfer(msg.sender, _to, _value);
366     return true;
367   }
368   /**
369   * @dev Gets the balance of the specified address.
370   * @param _owner The address to query the the balance of.
371   * @return An uint256 representing the amount owned by the passed address.
372   */
373   function balanceOf(address _owner) public constant returns (uint256 balance) {
374     return balances[_owner];
375   }
376 }
377 /**
378  * @title ERC20 interface
379  * @dev see https://github.com/ethereum/EIPs/issues/20
380  */
381 contract ERC20 is ERC20Basic {
382   function allowance(address owner, address spender) public constant returns (uint256);
383   function transferFrom(address from, address to, uint256 value) public returns (bool);
384   function approve(address spender, uint256 value) public returns (bool);
385   event Approval(address indexed owner, address indexed spender, uint256 value);
386 }
387 /**
388  * @title Standard ERC20 token
389  *
390  * @dev Implementation of the basic standard token.
391  * @dev https://github.com/ethereum/EIPs/issues/20
392  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
393  */
394 contract StandardToken is ERC20, BasicToken {
395   mapping (address => mapping (address => uint256)) allowed;
396   /**
397    * @dev Transfer tokens from one address to another
398    * @param _from address The address which you want to send tokens from
399    * @param _to address The address which you want to transfer to
400    * @param _value uint256 the amount of tokens to be transferred
401    */
402   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
403     require(_to != address(0));
404     uint256 _allowance = allowed[_from][msg.sender];
405     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
406     // require (_value <= _allowance);
407     balances[_from] = balances[_from].sub(_value);
408     balances[_to] = balances[_to].add(_value);
409     allowed[_from][msg.sender] = _allowance.sub(_value);
410     Transfer(_from, _to, _value);
411     return true;
412   }
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
423   function approve(address _spender, uint256 _value) public returns (bool) {
424     allowed[msg.sender][_spender] = _value;
425     Approval(msg.sender, _spender, _value);
426     return true;
427   }
428   /**
429    * @dev Function to check the amount of tokens that an owner allowed to a spender.
430    * @param _owner address The address which owns the funds.
431    * @param _spender address The address which will spend the funds.
432    * @return A uint256 specifying the amount of tokens still available for the spender.
433    */
434   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
435     return allowed[_owner][_spender];
436   }
437   /**
438    * approve should be called when allowed[_spender] == 0. To increment
439    * allowed value is better to use this function to avoid 2 calls (and wait until
440    * the first transaction is mined)
441    * From MonolithDAO Token.sol
442    */
443   function increaseApproval (address _spender, uint _addedValue)
444     returns (bool success) {
445     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
446     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
447     return true;
448   }
449   function decreaseApproval (address _spender, uint _subtractedValue)
450     returns (bool success) {
451     uint oldValue = allowed[msg.sender][_spender];
452     if (_subtractedValue > oldValue) {
453       allowed[msg.sender][_spender] = 0;
454     } else {
455       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
456     }
457     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
458     return true;
459   }
460 }
461 /**
462  * @title Mintable token
463  * @dev Simple ERC20 Token example, with mintable token creation
464  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
465  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
466  */
467 contract MintableToken is StandardToken, Ownable {
468   event Mint(address indexed to, uint256 amount);
469   event MintFinished();
470   bool public mintingFinished = false;
471   modifier canMint() {
472     require(!mintingFinished);
473     _;
474   }
475   /**
476    * @dev Function to mint tokens
477    * @param _to The address that will receive the minted tokens.
478    * @param _amount The amount of tokens to mint.
479    * @return A boolean that indicates if the operation was successful.
480    */
481 //  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
482   function mint(address _to, uint256 _amount) public returns (bool) {
483     totalSupply = totalSupply.add(_amount);
484     balances[_to] = balances[_to].add(_amount);
485     Mint(_to, _amount);
486     Transfer(0x0, _to, _amount);
487     return true;
488   }
489   /**
490    * @dev Function to stop minting new tokens.
491    * @return True if the operation was successful.
492    */
493   function finishMinting() onlyOwner public returns (bool) {
494     mintingFinished = true;
495     MintFinished();
496     return true;
497   }
498 }
499 contract AtomToken is MintableToken {
500   string public constant name = "AtomToken";
501   string public constant symbol = "ATM";
502   uint8 public constant decimals = 18;
503   uint256 public constant initialSupply = 65000000 * (10 ** uint256(decimals));    // number of tokens in reserve
504   /*
505    * gives msg.sender all of existing tokens.
506    */
507   function AtomToken() {
508     totalSupply = initialSupply;
509     balances[msg.sender] = initialSupply;
510   }
511 }
512 contract AtomTokenPreICO is CappedCrowdsale, RefundableCrowdsale, Destructible, Pausable {
513   function AtomTokenPreICO(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet)
514     CappedCrowdsale(_cap)
515     FinalizableCrowdsale()
516     RefundableCrowdsale(_goal)
517     Crowdsale(_tokenAddress, _startTime, _endTime, _rate, _wallet)
518   {
519     //As goal needs to be met for a successful crowdsale
520     //the value needs to less or equal than a cap which is limit for accepted funds
521     require(_goal <= _cap);
522   }
523 }