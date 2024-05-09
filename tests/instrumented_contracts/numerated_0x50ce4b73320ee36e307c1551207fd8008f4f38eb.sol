1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   /**
53   * @dev transfer token for a specified address
54   * @param _to The address to transfer to.
55   * @param _value The amount to be transferred.
56   */
57   function transfer(address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59     require(_value <= balances[msg.sender]);
60 
61     // SafeMath.sub will throw if there is not enough balance.
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68   /**
69   * @dev Gets the balance of the specified address.
70   * @param _owner The address to query the the balance of.
71   * @return An uint256 representing the amount owned by the passed address.
72   */
73   function balanceOf(address _owner) public view returns (uint256 balance) {
74     return balances[_owner];
75   }
76 
77 }
78 
79 contract StandardToken is ERC20, BasicToken {
80 
81   mapping (address => mapping (address => uint256)) internal allowed;
82 
83 
84   /**
85    * @dev Transfer tokens from one address to another
86    * @param _from address The address which you want to send tokens from
87    * @param _to address The address which you want to transfer to
88    * @param _value uint256 the amount of tokens to be transferred
89    */
90   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[_from]);
93     require(_value <= allowed[_from][msg.sender]);
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98     Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   /**
103    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
104    *
105    * Beware that changing an allowance with this method brings the risk that someone may use both the old
106    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
107    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
108    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
109    * @param _spender The address which will spend the funds.
110    * @param _value The amount of tokens to be spent.
111    */
112   function approve(address _spender, uint256 _value) public returns (bool) {
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifying the amount of tokens still available for the spender.
123    */
124   function allowance(address _owner, address _spender) public view returns (uint256) {
125     return allowed[_owner][_spender];
126   }
127 
128   /**
129    * @dev Increase the amount of tokens that an owner allowed to a spender.
130    *
131    * approve should be called when allowed[_spender] == 0. To increment
132    * allowed value is better to use this function to avoid 2 calls (and wait until
133    * the first transaction is mined)
134    * From MonolithDAO Token.sol
135    * @param _spender The address which will spend the funds.
136    * @param _addedValue The amount of tokens to increase the allowance by.
137    */
138   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
139     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
140     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141     return true;
142   }
143 
144   /**
145    * @dev Decrease the amount of tokens that an owner allowed to a spender.
146    *
147    * approve should be called when allowed[_spender] == 0. To decrement
148    * allowed value is better to use this function to avoid 2 calls (and wait until
149    * the first transaction is mined)
150    * From MonolithDAO Token.sol
151    * @param _spender The address which will spend the funds.
152    * @param _subtractedValue The amount of tokens to decrease the allowance by.
153    */
154   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
155     uint oldValue = allowed[msg.sender][_spender];
156     if (_subtractedValue > oldValue) {
157       allowed[msg.sender][_spender] = 0;
158     } else {
159       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
160     }
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165 }
166 
167 contract Ownable {
168   address public owner;
169 
170 
171   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
172 
173 
174   /**
175    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
176    * account.
177    */
178   function Ownable() public {
179     owner = msg.sender;
180   }
181 
182 
183   /**
184    * @dev Throws if called by any account other than the owner.
185    */
186   modifier onlyOwner() {
187     require(msg.sender == owner);
188     _;
189   }
190 
191 
192   /**
193    * @dev Allows the current owner to transfer control of the contract to a newOwner.
194    * @param newOwner The address to transfer ownership to.
195    */
196   function transferOwnership(address newOwner) public onlyOwner {
197     require(newOwner != address(0));
198     OwnershipTransferred(owner, newOwner);
199     owner = newOwner;
200   }
201 
202 }
203 
204 contract MintableToken is StandardToken, Ownable {
205   event Mint(address indexed to, uint256 amount);
206   event MintFinished();
207   event Burn(address indexed burner, uint256 value);
208 
209   bool public mintingFinished = false;
210 
211 
212   modifier canMint() {
213     require(!mintingFinished);
214     _;
215   }
216 
217   /**
218    * @dev Function to mint tokens
219    * @param _to The address that will receive the minted tokens.
220    * @param _amount The amount of tokens to mint.
221    * @return A boolean that indicates if the operation was successful.
222    */
223   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
224     totalSupply = totalSupply.add(_amount);
225     balances[_to] = balances[_to].add(_amount);
226     Mint(_to, _amount);
227     Transfer(address(0), _to, _amount);
228     return true;
229   }
230 
231   /**
232    * @dev Function to stop minting new tokens.
233    * @return True if the operation was successful.
234    */
235   function finishMinting() onlyOwner canMint public returns (bool) {
236     mintingFinished = true;
237     MintFinished();
238     return true;
239   }
240 
241   /**
242    * @dev Burns a specific amount of tokens.
243    * @param _value The amount of token to be burned.
244    */
245   function burn(uint256 _value) public {
246       require(_value <= balances[msg.sender]);
247       // no need to require value <= totalSupply, since that would imply the
248       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
249 
250       address burner = msg.sender;
251       balances[burner] = balances[burner].sub(_value);
252       totalSupply = totalSupply.sub(_value);
253       Burn(burner, _value);
254     }
255 }
256 
257 contract CirrusCoinToken is MintableToken {
258 
259   string public constant name = "Cirrus Coin";
260   string public constant symbol = "CRC";
261   uint8 public constant decimals = 18;
262 
263 }
264 
265 /**
266  * @title RefundVault
267  * @dev This contract is used for storing funds while a crowdsale
268  * is in progress. Supports refunding the money if crowdsale fails,
269  * and forwarding it if crowdsale is successful.
270  */
271 contract RefundVault is Ownable {
272   using SafeMath for uint256;
273 
274   enum State { Active, Refunding, Closed }
275 
276   mapping (address => uint256) public deposited;
277   address public wallet;
278   State public state;
279 
280   event Closed();
281   event RefundsEnabled();
282   event Refunded(address indexed beneficiary, uint256 weiAmount);
283 
284   function RefundVault(address _wallet) public {
285     require(_wallet != address(0));
286     wallet = _wallet;
287     state = State.Active;
288   }
289 
290   function deposit(address investor) onlyOwner public payable {
291     require(state == State.Active);
292     deposited[investor] = deposited[investor].add(msg.value);
293   }
294 
295   function close() onlyOwner public {
296     require(state == State.Active);
297     state = State.Closed;
298     Closed();
299     wallet.transfer(this.balance);
300   }
301 
302   function walletWithdraw(uint256 _value) onlyOwner public {
303     require(_value < this.balance);
304     wallet.transfer(_value);
305   }
306 
307   function enableRefunds() onlyOwner public {
308     require(state == State.Active);
309     state = State.Refunding;
310     RefundsEnabled();
311   }
312 
313   function refund(address investor) public {
314     require(state == State.Refunding);
315     uint256 depositedValue = deposited[investor];
316     deposited[investor] = 0;
317     investor.transfer(depositedValue);
318     Refunded(investor, depositedValue);
319   }
320 }
321 
322 contract Crowdsale {
323   using SafeMath for uint256;
324 
325   // The token being sold
326   MintableToken public token;
327 
328   // start and end timestamps where investments are allowed (both inclusive)
329   uint256 public startTime;
330   uint256 public endTime;
331 
332   // address where funds are collected
333   address public wallet;
334 
335   // how many token units a buyer gets per wei
336   uint256 public rate;
337 
338   // amount of raised money in wei
339   uint256 public weiRaised;
340 
341   /**
342    * event for token purchase logging
343    * @param purchaser who paid for the tokens
344    * @param beneficiary who got the tokens
345    * @param value weis paid for purchase
346    * @param amount amount of tokens purchased
347    */
348   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
349   event TokenRateChange(uint256 new_rate);
350 
351   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
352     require(_startTime >= now);
353     require(_endTime >= _startTime);
354     require(_rate > 0);
355     require(_wallet != address(0));
356 
357     token = createTokenContract();
358     startTime = _startTime;
359     endTime = _endTime;
360     rate = _rate;
361     wallet = _wallet;
362   }
363 
364   // creates the token to be sold.
365   // override this method to have crowdsale of a specific mintable token.
366   function createTokenContract() internal returns (MintableToken) {
367     return new MintableToken();
368   }
369 
370 
371 
372   // fallback function can be used to buy tokens
373   function () external payable {
374     buyTokens(msg.sender);
375   }
376 
377   // low level token purchase function
378   function buyTokens(address beneficiary) public payable {
379     require(beneficiary != address(0));
380     require(validPurchase());
381 
382     uint256 weiAmount = msg.value;
383 
384     // calculate token amount to be created
385     uint256 tokens = weiAmount.mul(rate);
386 
387     // update state
388     weiRaised = weiRaised.add(weiAmount);
389 
390     token.mint(beneficiary, tokens);
391     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
392 
393     forwardFunds();
394   }
395 
396   // send ether to the fund collection wallet
397   // override to create custom fund forwarding mechanisms
398   function forwardFunds() internal {
399     wallet.transfer(msg.value);
400   }
401 
402   // @return true if the transaction can buy tokens
403   function validPurchase() internal view returns (bool) {
404     bool withinPeriod = now >= startTime && now <= endTime;
405     bool nonZeroPurchase = msg.value != 0;
406     return withinPeriod && nonZeroPurchase;
407   }
408 
409   // @return true if crowdsale event has ended
410   function hasEnded() public view returns (bool) {
411     return now > endTime;
412   }
413 
414 
415 }
416 contract FinalizableCrowdsale is Crowdsale, Ownable {
417   using SafeMath for uint256;
418 
419   bool public isFinalized = false;
420 
421   event Finalized();
422 
423   /**
424    * @dev Must be called after crowdsale ends, to do some extra finalization
425    * work. Calls the contract's finalization function.
426    */
427   function finalize() onlyOwner public {
428     require(!isFinalized);
429     require(hasEnded());
430 
431     finalization();
432     Finalized();
433 
434     isFinalized = true;
435   }
436 
437   /**
438    * @dev Can be overridden to add finalization logic. The overriding function
439    * should call super.finalization() to ensure the chain of finalization is
440    * executed entirely.
441    */
442   function finalization() internal {
443   }
444 }
445 contract CappedCrowdsale is Crowdsale {
446   using SafeMath for uint256;
447 
448   uint256 public cap;
449 
450   function CappedCrowdsale(uint256 _cap) public {
451     require(_cap > 0);
452     cap = _cap;
453   }
454 
455   // overriding Crowdsale#validPurchase to add extra cap logic
456   // @return true if investors can buy at the moment
457   function validPurchase() internal view returns (bool) {
458     bool withinCap = weiRaised.add(msg.value) <= cap;
459     return super.validPurchase() && withinCap;
460   }
461 
462   // overriding Crowdsale#hasEnded to add cap logic
463   // @return true if crowdsale event has ended
464   function hasEnded() public view returns (bool) {
465     bool capReached = weiRaised >= cap;
466     return super.hasEnded() || capReached;
467   }
468 
469 }
470 contract RefundableCrowdsale is FinalizableCrowdsale {
471   using SafeMath for uint256;
472 
473   // minimum amount of funds to be raised
474   uint256 public goal;
475 
476   // refund vault used to hold funds while crowdsale is running
477   RefundVault public vault;
478 
479   function RefundableCrowdsale(uint256 _goal) public {
480     require(_goal > 0);
481     vault = new RefundVault(wallet);
482     goal = _goal;
483   }
484 
485   // We're overriding the fund forwarding from Crowdsale.
486   // In addition to sending the funds, we want to call
487   // the RefundVault deposit function
488   function forwardFunds() internal {
489     vault.deposit.value(msg.value)(msg.sender);
490   }
491 
492   // if crowdsale is unsuccessful, investors can claim refunds here
493   function claimRefund() public {
494     require(isFinalized);
495     require(!goalReached());
496 
497     vault.refund(msg.sender);
498   }
499 
500   // vault finalization task, called when owner calls finalize()
501   function finalization() internal {
502     if (goalReached()) {
503       vault.close();
504     } else {
505       vault.enableRefunds();
506     }
507 
508     super.finalization();
509   }
510 
511   function goalReached() public view returns (bool) {
512     return weiRaised >= goal;
513   }
514 
515   // making this function publicly accessible because
516   // random people accessing it just sends us money
517 
518   function sendMoneyBeforeEnd(uint256 _amount) public returns (bool) {
519     require(goalReached() == true);
520     vault.walletWithdraw(_amount);
521   }
522 }
523 contract GreensparcCrowdsale is CappedCrowdsale, RefundableCrowdsale {
524 
525   function GreensparcCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet) public
526     CappedCrowdsale(_cap)
527     FinalizableCrowdsale()
528     RefundableCrowdsale(_goal)
529     Crowdsale(_startTime, _endTime, _rate, _wallet)
530   {
531     //As goal needs to be met for a successful crowdsale
532     //the value needs to less or equal than a cap which is limit for accepted funds
533     require(_goal <= _cap);
534   }
535 
536   function createTokenContract() internal returns (MintableToken) {
537     return new CirrusCoinToken();
538   }
539 
540   function rateChange(uint256 _newRate) public onlyOwner {
541     rate = _newRate;
542   }
543   
544 }