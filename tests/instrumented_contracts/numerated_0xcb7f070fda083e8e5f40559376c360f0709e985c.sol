1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold.
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract ERC20Basic {
124   uint256 public totalSupply;
125   function balanceOf(address who) public constant returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142 
143     // SafeMath.sub will throw if there is not enough balance.
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of.
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) public constant returns (uint256 balance) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender) public constant returns (uint256);
163   function transferFrom(address from, address to, uint256 value) public returns (bool);
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181 
182     uint256 _allowance = allowed[_from][msg.sender];
183 
184     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
185     // require (_value <= _allowance);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = _allowance.sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    */
226   function increaseApproval (address _spender, uint _addedValue)
227     returns (bool success) {
228     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   function decreaseApproval (address _spender, uint _subtractedValue)
234     returns (bool success) {
235     uint oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 contract Ownable {
248   address public owner;
249 
250 
251   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253 
254   /**
255    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
256    * account.
257    */
258   function Ownable() {
259     owner = msg.sender;
260   }
261 
262 
263   /**
264    * @dev Throws if called by any account other than the owner.
265    */
266   modifier onlyOwner() {
267     require(msg.sender == owner);
268     _;
269   }
270 
271 
272   /**
273    * @dev Allows the current owner to transfer control of the contract to a newOwner.
274    * @param newOwner The address to transfer ownership to.
275    */
276   function transferOwnership(address newOwner) onlyOwner public {
277     require(newOwner != address(0));
278     OwnershipTransferred(owner, newOwner);
279     owner = newOwner;
280   }
281 
282 }
283 
284 contract FinalizableCrowdsale is Crowdsale, Ownable {
285   using SafeMath for uint256;
286 
287   bool public isFinalized = false;
288 
289   event Finalized();
290 
291   /**
292    * @dev Must be called after crowdsale ends, to do some extra finalization
293    * work. Calls the contract's finalization function.
294    */
295   function finalize() onlyOwner public {
296     require(!isFinalized);
297     require(hasEnded());
298 
299     finalization();
300     Finalized();
301 
302     isFinalized = true;
303   }
304 
305   /**
306    * @dev Can be overridden to add finalization logic. The overriding function
307    * should call super.finalization() to ensure the chain of finalization is
308    * executed entirely.
309    */
310   function finalization() internal {
311   }
312 }
313 
314 contract RefundableCrowdsale is FinalizableCrowdsale {
315   using SafeMath for uint256;
316 
317   // minimum amount of funds to be raised in weis
318   uint256 public goal;
319 
320   // refund vault used to hold funds while crowdsale is running
321   RefundVault public vault;
322 
323   function RefundableCrowdsale(uint256 _goal) {
324     require(_goal > 0);
325     vault = new RefundVault(wallet);
326     goal = _goal;
327   }
328 
329   // We're overriding the fund forwarding from Crowdsale.
330   // In addition to sending the funds, we want to call
331   // the RefundVault deposit function
332   function forwardFunds() internal {
333     vault.deposit.value(msg.value)(msg.sender);
334   }
335 
336   // if crowdsale is unsuccessful, investors can claim refunds here
337   function claimRefund() public {
338     require(isFinalized);
339     require(!goalReached());
340 
341     vault.refund(msg.sender);
342   }
343 
344   // vault finalization task, called when owner calls finalize()
345   function finalization() internal {
346     if (goalReached()) {
347       vault.close();
348     } else {
349       vault.enableRefunds();
350     }
351 
352     super.finalization();
353   }
354 
355   function goalReached() public constant returns (bool) {
356     return weiRaised >= goal;
357   }
358 
359 }
360 
361 contract RefundVault is Ownable {
362   using SafeMath for uint256;
363 
364   enum State { Active, Refunding, Closed }
365 
366   mapping (address => uint256) public deposited;
367   address public wallet;
368   State public state;
369 
370   event Closed();
371   event RefundsEnabled();
372   event Refunded(address indexed beneficiary, uint256 weiAmount);
373 
374   function RefundVault(address _wallet) {
375     require(_wallet != 0x0);
376     wallet = _wallet;
377     state = State.Active;
378   }
379 
380   function deposit(address investor) onlyOwner public payable {
381     require(state == State.Active);
382     deposited[investor] = deposited[investor].add(msg.value);
383   }
384 
385   function close() onlyOwner public {
386     require(state == State.Active);
387     state = State.Closed;
388     Closed();
389     wallet.transfer(this.balance);
390   }
391 
392   function enableRefunds() onlyOwner public {
393     require(state == State.Active);
394     state = State.Refunding;
395     RefundsEnabled();
396   }
397 
398   function refund(address investor) public {
399     require(state == State.Refunding);
400     uint256 depositedValue = deposited[investor];
401     deposited[investor] = 0;
402     investor.transfer(depositedValue);
403     Refunded(investor, depositedValue);
404   }
405 }
406 
407 contract DeckCoinCrowdsale is RefundableCrowdsale {
408   using SafeMath for uint256;
409 
410   uint256 public constant startTime = 1508824800; // Oct. 24th 1AM CST
411   uint256 public constant endTime = 1511506800; // Nov. 24th 1AM CST
412   uint256 public constant fortyEndTime = 1509516000; // Nov. 1st 1AM CST
413   uint256 public constant twentyEndTime = 1510124400; // Nov. 8th 1AM CST
414   uint256 public constant tenEndTime = 1510729200; // Nov. 15th 1AM CST
415   uint256 public constant tokenGoal = 8000000 * 10 ** 18;
416   uint256 public constant tokenCap = 70000000 * 10 ** 18;
417   uint256 public constant rate = 28000;
418   address public constant wallet = 0x67cE4BFf7333C091EADc1d90425590d931A3E972;
419   uint256 public tokensSold;
420 
421   function DeckCoinCrowdsale()
422     FinalizableCrowdsale()
423     RefundableCrowdsale(1)
424     Crowdsale(startTime, endTime, rate, wallet) public {}
425 
426   function bulkMint(uint[] data) onlyOwner public {
427     DeckCoin(token).bulkMint(data);
428   }
429 
430   function finishMinting() onlyOwner public  {
431     token.finishMinting();
432   }
433 
434   function weiToTokens(uint256 weiAmount) public constant returns (uint256){
435     uint256 tokens;
436 
437     // Note: assumes rate is 28000
438     if (now < fortyEndTime) {
439       tokens = weiAmount.mul(rate.add(11200));
440     } else if (now < twentyEndTime) {
441       tokens = weiAmount.mul(rate.add(5600));
442     } else if (now < tenEndTime) {
443       tokens = weiAmount.mul(rate.add(2800));
444     } else {
445       tokens = weiAmount.mul(rate);
446     }
447 
448     return tokens;
449   }
450 
451   // @Override
452   function buyTokens(address beneficiary) public payable {
453     require(beneficiary != 0x0);
454     require(validPurchase());
455 
456     uint256 weiAmount = msg.value;
457 
458     //
459     // START CHANGES
460     //
461 
462     uint256 tokens = weiToTokens(weiAmount);
463     tokensSold = tokensSold.add(tokens);
464 
465     //
466     // END CHANGES
467     //
468 
469     // update state
470     weiRaised = weiRaised.add(weiAmount);
471 
472     token.mint(beneficiary, tokens);
473     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
474 
475     forwardFunds();
476   }
477 
478   // @Override
479   function goalReached() public constant returns (bool) {
480     return tokensSold >= tokenGoal;
481   }
482 
483   // @Override
484   function hasEnded() public constant returns (bool) {
485     bool capReached = tokensSold >= tokenCap;
486     return super.hasEnded() || capReached;
487   }
488 
489   // @Override
490   function validPurchase() internal constant returns (bool) {
491     bool withinCap = tokensSold.add(weiToTokens(msg.value)) <= tokenCap;
492     return super.validPurchase() && withinCap;
493   }
494 
495   // @Override
496   function createTokenContract() internal returns (MintableToken) {
497     return new DeckCoin();
498   }
499 
500 }
501 
502 contract MintableToken is StandardToken, Ownable {
503   event Mint(address indexed to, uint256 amount);
504   event MintFinished();
505 
506   bool public mintingFinished = false;
507 
508 
509   modifier canMint() {
510     require(!mintingFinished);
511     _;
512   }
513 
514   /**
515    * @dev Function to mint tokens
516    * @param _to The address that will receive the minted tokens.
517    * @param _amount The amount of tokens to mint.
518    * @return A boolean that indicates if the operation was successful.
519    */
520   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
521     totalSupply = totalSupply.add(_amount);
522     balances[_to] = balances[_to].add(_amount);
523     Mint(_to, _amount);
524     Transfer(0x0, _to, _amount);
525     return true;
526   }
527 
528   /**
529    * @dev Function to stop minting new tokens.
530    * @return True if the operation was successful.
531    */
532   function finishMinting() onlyOwner public returns (bool) {
533     mintingFinished = true;
534     MintFinished();
535     return true;
536   }
537 }
538 
539 contract DeckCoin is MintableToken {
540   // ERC20 optionals
541   string public constant name = "Deck Coin";
542   string public constant symbol = "DEK";
543   uint8 public constant decimals = 18;
544 
545   uint256 private constant D160 = 0x10000000000000000000000000000000000000000;
546 
547   // The 160 LSB is the address of the balance
548   // The 96 MSB is the balance of that address.
549   // Note: amounts are pre-decimal
550   function bulkMint(uint256[] data) onlyOwner canMint public {
551     uint256 totalMinted = 0;
552 
553     for (uint256 i = 0; i < data.length; i++) {
554       address beneficiary = address(data[i] & (D160 - 1));
555       uint256 amount = data[i] / D160;
556 
557       totalMinted += amount;
558       balances[beneficiary] += amount;
559     }
560 
561     totalSupply = totalSupply.add(totalMinted);
562     Mint(0x0, totalMinted);
563   }
564 
565 }