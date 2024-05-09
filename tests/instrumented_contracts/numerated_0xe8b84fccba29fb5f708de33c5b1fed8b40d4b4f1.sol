1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 library SafeMath {
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43       return 0;
44     }
45     uint256 c = a * b;
46     assert(c / a == b);
47     return c;
48   }
49 
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 contract ERC20Basic {
70   uint256 public totalSupply;
71   function balanceOf(address who) public view returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     // SafeMath.sub will throw if there is not enough balance.
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public view returns (uint256 balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130 
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) public view returns (uint256) {
161     return allowed[_owner][_spender];
162   }
163 
164   /**
165    * @dev Increase the amount of tokens that an owner allowed to a spender.
166    *
167    * approve should be called when allowed[_spender] == 0. To increment
168    * allowed value is better to use this function to avoid 2 calls (and wait until
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    * @param _spender The address which will spend the funds.
172    * @param _addedValue The amount of tokens to increase the allowance by.
173    */
174   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
175     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   /**
181    * @dev Decrease the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To decrement
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _subtractedValue The amount of tokens to decrease the allowance by.
189    */
190   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
191     uint oldValue = allowed[msg.sender][_spender];
192     if (_subtractedValue > oldValue) {
193       allowed[msg.sender][_spender] = 0;
194     } else {
195       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196     }
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201 }
202 
203 contract MintableToken is StandardToken, Ownable {
204   event Mint(address indexed to, uint256 amount);
205   event MintFinished();
206 
207   bool public mintingFinished = false;
208 
209 
210   modifier canMint() {
211     require(!mintingFinished);
212     _;
213   }
214 
215   /**
216    * @dev Function to mint tokens
217    * @param _to The address that will receive the minted tokens.
218    * @param _amount The amount of tokens to mint.
219    * @return A boolean that indicates if the operation was successful.
220    */
221   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
222     totalSupply = totalSupply.add(_amount);
223     balances[_to] = balances[_to].add(_amount);
224     Mint(_to, _amount);
225     Transfer(address(0), _to, _amount);
226     return true;
227   }
228 
229   /**
230    * @dev Function to stop minting new tokens.
231    * @return True if the operation was successful.
232    */
233   function finishMinting() onlyOwner canMint public returns (bool) {
234     mintingFinished = true;
235     MintFinished();
236     return true;
237   }
238 }
239 
240 contract TokenContract is MintableToken {
241   string public name         = "Navalcoin";  // change token name here
242   string public symbol       = "NAC";         // change token symbol
243   uint8 public decimals      = 18;             
244 }
245 
246 contract RefundVault is Ownable {
247   using SafeMath for uint256;
248 
249   enum State { Active, Refunding, Closed }
250 
251   mapping (address => uint256) public deposited;
252   address public wallet;
253   State public state;
254 
255   event Closed();
256   event RefundsEnabled();
257   event Refunded(address indexed beneficiary, uint256 weiAmount);
258 
259   function RefundVault(address _wallet) public {
260     require(_wallet != address(0));
261     wallet = _wallet;
262     state = State.Active;
263   }
264 
265   function deposit(address investor) onlyOwner public payable {
266     require(state == State.Active);
267     deposited[investor] = deposited[investor].add(msg.value);
268   }
269 
270   function close() onlyOwner public {
271     require(state == State.Active);
272     state = State.Closed;
273     Closed();
274     wallet.transfer(this.balance);
275   }
276 
277   function enableRefunds() onlyOwner public {
278     require(state == State.Active);
279     state = State.Refunding;
280     RefundsEnabled();
281   }
282 
283   function refund(address investor) public {
284     require(state == State.Refunding);
285     uint256 depositedValue = deposited[investor];
286     deposited[investor] = 0;
287     investor.transfer(depositedValue);
288     Refunded(investor, depositedValue);
289   }
290 }
291 
292 contract Crowdsale {
293   using SafeMath for uint256;
294 
295   // The token being sold
296   MintableToken public token;
297 
298   // start and end timestamps where investments are allowed (both inclusive)
299   uint256 public startTime;
300   uint256 public endTime;
301 
302   // address where funds are collected
303   address public wallet;
304 
305   // how many token units a buyer gets per wei
306   uint256 public rate;
307 
308   // amount of raised money in wei
309   uint256 public weiRaised;
310 
311   /**
312    * event for token purchase logging
313    * @param purchaser who paid for the tokens
314    * @param beneficiary who got the tokens
315    * @param value weis paid for purchase
316    * @param amount amount of tokens purchased
317    */
318   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
319 
320 
321   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
322     // require(_startTime >= now);
323     
324     require(_endTime >= _startTime);
325     require(_rate > 0);
326     require(_wallet != address(0));
327 
328     token = createTokenContract();
329     startTime = _startTime;
330     endTime = _endTime;
331     rate = _rate;
332     wallet = _wallet;
333   }
334 
335   // creates the token to be sold.
336   // override this method to have crowdsale of a specific mintable token.
337   function createTokenContract() internal returns (MintableToken) {
338     return new MintableToken();
339   }
340 
341 
342   // fallback function can be used to buy tokens
343   function () external payable {
344     buyTokens(msg.sender);
345   }
346 
347   // low level token purchase function
348   function buyTokens(address beneficiary) public payable {
349     require(beneficiary != address(0));
350     require(validPurchase());
351 
352     uint256 weiAmount = msg.value;
353 
354     // calculate token amount to be created
355     uint256 tokens = weiAmount.mul(rate);
356 
357     // update state
358     weiRaised = weiRaised.add(weiAmount);
359 
360     token.mint(beneficiary, tokens);
361     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
362 
363     forwardFunds();
364   }
365 
366   // send ether to the fund collection wallet
367   // override to create custom fund forwarding mechanisms
368   function forwardFunds() internal {
369     wallet.transfer(msg.value);
370   }
371 
372   // @return true if the transaction can buy tokens
373   function validPurchase() internal view returns (bool) {
374     bool withinPeriod = now >= startTime && now <= endTime;
375     bool nonZeroPurchase = msg.value != 0;
376     return withinPeriod && nonZeroPurchase;
377   }
378 
379   // @return true if crowdsale event has ended
380   function hasEnded() public view returns (bool) {
381     return now > endTime;
382   }
383 
384 
385 }
386 
387 contract FinalizableCrowdsale is Crowdsale, Ownable {
388   using SafeMath for uint256;
389 
390   bool public isFinalized = false;
391 
392   event Finalized();
393 
394   /**
395    * @dev Must be called after crowdsale ends, to do some extra finalization
396    * work. Calls the contract's finalization function.
397    */
398   function finalize() onlyOwner public {
399     require(!isFinalized);
400     require(hasEnded());
401 
402     finalization();
403     Finalized();
404 
405     isFinalized = true;
406   }
407 
408   /**
409    * @dev Can be overridden to add finalization logic. The overriding function
410    * should call super.finalization() to ensure the chain of finalization is
411    * executed entirely.
412    */
413   function finalization() internal {
414   }
415 }
416 
417 contract CappedCrowdsale is Crowdsale {
418   using SafeMath for uint256;
419 
420   uint256 public cap;
421 
422   function CappedCrowdsale(uint256 _cap) public {
423     require(_cap > 0);
424     cap = _cap;
425   }
426 
427   // overriding Crowdsale#validPurchase to add extra cap logic
428   // @return true if investors can buy at the moment
429   function validPurchase() internal view returns (bool) {
430     bool withinCap = weiRaised.add(msg.value) <= cap;
431     return super.validPurchase() && withinCap;
432   }
433 
434   // overriding Crowdsale#hasEnded to add cap logic
435   // @return true if crowdsale event has ended
436   function hasEnded() public view returns (bool) {
437     bool capReached = weiRaised >= cap;
438     return super.hasEnded() || capReached;
439   }
440 
441 }
442 
443 contract RefundableCrowdsale is FinalizableCrowdsale {
444   using SafeMath for uint256;
445 
446   // minimum amount of funds to be raised in weis
447   uint256 public goal;
448 
449   // refund vault used to hold funds while crowdsale is running
450   RefundVault public vault;
451 
452   function RefundableCrowdsale(uint256 _goal) public {
453     require(_goal > 0);
454     vault = new RefundVault(wallet);
455     goal = _goal;
456   }
457 
458   // We're overriding the fund forwarding from Crowdsale.
459   // In addition to sending the funds, we want to call
460   // the RefundVault deposit function
461   function forwardFunds() internal {
462     vault.deposit.value(msg.value)(msg.sender);
463   }
464 
465   // if crowdsale is unsuccessful, investors can claim refunds here
466   function claimRefund() public {
467     require(isFinalized);
468     require(!goalReached());
469 
470     vault.refund(msg.sender);
471   }
472 
473   // vault finalization task, called when owner calls finalize()
474   function finalization() internal {
475     if (goalReached()) {
476       vault.close();
477     } else {
478       vault.enableRefunds();
479     }
480 
481     super.finalization();
482   }
483 
484   function goalReached() public view returns (bool) {
485     return weiRaised >= goal;
486   }
487 
488 }
489 
490 contract NacContract is CappedCrowdsale, RefundableCrowdsale {
491 
492 
493   // Token Decimals and Distribution
494   // ===========
495   uint8 public decimals = 18;
496   uint256 public maxTokens                        =  1000000000 * 10 ** uint256(decimals); //    1 billion tokens max
497   uint256 public totalTokensForSale               =   700000000 * 10 ** uint256(decimals); //  700 million tokens in total
498   uint256 public tokensForTeam                    =   200000000 * 10 ** uint256(decimals); //  200 million tokens for team
499   uint256 public tokensBounty                     =    15000000 * 10 ** uint256(decimals); //   15 million tokens for bounty
500   uint256 public tokensAirdrop                    =    85000000 * 10 ** uint256(decimals); //   85 million tokens for airdrop
501   // ==============================
502 
503 
504 
505   event EthTransferred(string text);
506   event EthRefunded(string text);
507 
508 
509   // Constructor
510   // ============
511   function NacContract(            uint256 _startTime, 
512                                    uint256 _endTime, 
513                                    uint256 _rate, 
514                                    address _wallet, 
515                                    uint256 _goal, 
516                                    uint256 _cap) 
517     CappedCrowdsale(_cap*10**18) FinalizableCrowdsale() RefundableCrowdsale(_goal*10**18) 
518     Crowdsale(_startTime, _endTime, _rate, _wallet) 
519     public 
520     {
521       require(_goal <= _cap);
522   }
523   
524 
525 
526   // Token Deployment
527   // =================
528   function createTokenContract() internal returns (MintableToken) {
529     return new TokenContract();  // binding the token contract to this crowdsale
530   }
531   // ==================
532 
533   // Mint bounty tokens
534   function mintBountytokens(address _bountyWallet) public onlyOwner {
535     token.mint(_bountyWallet,tokensBounty);
536   }
537 
538   // Change the current rate
539   function setCurrentRate(uint256 _rate)  public onlyOwner {
540       rate = _rate;
541   }
542 
543   //change start time
544   function setNewStartTime(uint256 _startTime) public onlyOwner {
545       startTime = _startTime;
546   }
547 
548   //change end time
549   function setNewEndTime(uint256 _endTime) public onlyOwner {
550       endTime = _endTime;
551   }
552 
553 
554 
555   // Token Purchase
556   // =========================
557   function () external payable {
558     uint256 mintAfterPurchase = msg.value.mul(rate);
559       if ((token.totalSupply() + mintAfterPurchase > totalTokensForSale)) {
560         msg.sender.transfer(msg.value); // Refund them
561         EthRefunded("sale Limit Hit");
562         return;
563       }
564 
565       buyTokens(msg.sender);
566   }
567 
568   function forwardFunds() internal {
569       EthTransferred("Pushing funds to smartEscrow");
570       super.forwardFunds();
571       
572   }
573  
574 
575   // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
576   // ====================================================================
577 
578   function finish(address _teamFund, address _airdropFund) public onlyOwner {
579       
580       require(!isFinalized);
581 
582       uint256 alreadyMintedTokens = token.totalSupply();
583       require(alreadyMintedTokens < maxTokens);
584       
585       uint256 unsoldTokens = totalTokensForSale - alreadyMintedTokens;
586       if (unsoldTokens > 0) {
587         tokensAirdrop = tokensAirdrop + unsoldTokens;
588       }
589 
590       token.mint(_airdropFund,tokensAirdrop);
591       token.mint(_teamFund,tokensForTeam);
592 
593       finalize();
594   }
595   // ===============================
596 
597   function showTokenBalance(address sender) public constant returns (uint) {
598       return token.balanceOf(sender);
599   }
600   function getWeiRaised() public constant returns (uint) {
601       return weiRaised;
602   }
603   
604 }