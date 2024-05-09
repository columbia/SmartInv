1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title SafeERC20
39  * @dev Wrappers around ERC20 operations that throw on failure.
40  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
41  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
42  */
43 library SafeERC20 {
44   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
45     assert(token.transfer(to, value));
46   }
47 
48   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
49     assert(token.transferFrom(from, to, value));
50   }
51 
52   function safeApprove(ERC20 token, address spender, uint256 value) internal {
53     assert(token.approve(spender, value));
54   }
55 }
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   function Ownable() public {
74     owner = msg.sender;
75   }
76 
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) public onlyOwner {
92     require(newOwner != address(0));
93     OwnershipTransferred(owner, newOwner);
94     owner = newOwner;
95   }
96 }
97 
98 /**
99  * @title RefundVault
100  * @dev This contract is used for storing funds while a crowdsale
101  * is in progress. Supports refunding the money if crowdsale fails,
102  * and forwarding it if crowdsale is successful.
103  */
104 contract RefundVault is Ownable {
105   using SafeMath for uint256;
106 
107   enum State { Active, Refunding, Closed }
108 
109   mapping (address => uint256) public deposited;
110   address public wallet;
111   State public state;
112 
113   event Closed();
114   event RefundsEnabled();
115   event Refunded(address indexed beneficiary, uint256 weiAmount);
116 
117   function RefundVault(address _wallet) public {
118     require(_wallet != address(0));
119     wallet = _wallet;
120     state = State.Active;
121   }
122 
123   function deposit(address investor) onlyOwner public payable {
124     require(state == State.Active);
125     deposited[investor] = deposited[investor].add(msg.value);
126   }
127 
128   function close() onlyOwner public {
129     require(state == State.Active);
130     state = State.Closed;
131     Closed();
132     wallet.transfer(this.balance);
133   }
134 
135   function enableRefunds() onlyOwner public {
136     require(state == State.Active);
137     state = State.Refunding;
138     RefundsEnabled();
139   }
140 
141   function refund(address investor) public {
142     require(state == State.Refunding);
143     uint256 depositedValue = deposited[investor];
144     deposited[investor] = 0;
145     investor.transfer(depositedValue);
146     Refunded(investor, depositedValue);
147   }
148 }
149 
150 /**
151  * @title TokenTimelock
152  * @dev TokenTimelock is a token holder contract that will allow a
153  * beneficiary to extract the tokens after a given release time
154  */
155 contract TokenTimelock {
156   using SafeERC20 for ERC20Basic;
157 
158   // ERC20 basic token contract being held
159   ERC20Basic public token;
160 
161   // beneficiary of tokens after they are released
162   address public beneficiary;
163 
164   // timestamp when token release is enabled
165   uint256 public releaseTime;
166 
167   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
168     require(_releaseTime > now);
169     token = _token;
170     beneficiary = _beneficiary;
171     releaseTime = _releaseTime;
172   }
173 
174   /**
175    * @notice Transfers tokens held by timelock to beneficiary.
176    */
177   function release() public {
178     require(now >= releaseTime);
179 
180     uint256 amount = token.balanceOf(this);
181     require(amount > 0);
182 
183     token.safeTransfer(beneficiary, amount);
184   }
185 }
186 
187 
188 /**
189  * @title ERC20Basic
190  * @dev Simpler version of ERC20 interface
191  * @dev see https://github.com/ethereum/EIPs/issues/179
192  */
193 contract ERC20Basic {
194   uint256 public totalSupply;
195   function balanceOf(address who) public view returns (uint256);
196   function transfer(address to, uint256 value) public returns (bool);
197   event Transfer(address indexed from, address indexed to, uint256 value);
198 }
199 
200 /**
201  * @title ERC20 interface
202  * @dev see https://github.com/ethereum/EIPs/issues/20
203  */
204 contract ERC20 is ERC20Basic {
205   function allowance(address owner, address spender) public view returns (uint256);
206   function transferFrom(address from, address to, uint256 value) public returns (bool);
207   function approve(address spender, uint256 value) public returns (bool);
208   event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 
211 contract BitcoinusToken is ERC20, Ownable {
212   using SafeMath for uint256;
213 
214   string public constant name = "Bitcoinus";
215     string public constant symbol = "BITS";
216     uint8 public constant decimals = 18;
217 
218   mapping (address => uint256) balances;
219   mapping (address => mapping (address => uint256)) internal allowed;
220 
221   event Mint(address indexed to, uint256 amount);
222     event MintFinished();
223 
224   bool public mintingFinished = false;
225 
226   modifier canTransfer() {
227     require(mintingFinished);
228     _;
229   }
230 
231   /**
232   * @dev transfer token for a specified address
233   * @param _to The address to transfer to.
234   * @param _value The amount to be transferred.
235   */
236   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
237     require(_to != address(0));
238     require(_value <= balances[msg.sender]);
239 
240     // SafeMath.sub will throw if there is not enough balance.
241     balances[msg.sender] = balances[msg.sender].sub(_value);
242     balances[_to] = balances[_to].add(_value);
243     Transfer(msg.sender, _to, _value);
244     return true;
245   }
246 
247   /**
248   * @dev Gets the balance of the specified address.
249   * @param _owner The address to query the the balance of.
250   * @return An uint256 representing the amount owned by the passed address.
251   */
252   function balanceOf(address _owner) public view returns (uint256 balance) {
253     return balances[_owner];
254   }
255 
256 
257   /**
258   * @dev Transfer tokens from one address to another
259   * @param _from address The address which you want to send tokens from
260   * @param _to address The address which you want to transfer to
261   * @param _value uint256 the amount of tokens to be transferred
262   */
263   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
264     require(_to != address(0));
265     require(_value <= balances[_from]);
266     require(_value <= allowed[_from][msg.sender]);
267 
268     balances[_from] = balances[_from].sub(_value);
269     balances[_to] = balances[_to].add(_value);
270     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
271     Transfer(_from, _to, _value);
272     return true;
273   }
274 
275   /**
276   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
277   *
278   * Beware that changing an allowance with this method brings the risk that someone may use both the old
279   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282   * @param _spender The address which will spend the funds.
283   * @param _value The amount of tokens to be spent.
284   */
285   function approve(address _spender, uint256 _value) public returns (bool) {
286     allowed[msg.sender][_spender] = _value;
287     Approval(msg.sender, _spender, _value);
288     return true;
289   }
290 
291   /**
292   * @dev Function to check the amount of tokens that an owner allowed to a spender.
293   * @param _owner address The address which owns the funds.
294   * @param _spender address The address which will spend the funds.
295   * @return A uint256 specifying the amount of tokens still available for the spender.
296   */
297   function allowance(address _owner, address _spender) public view returns (uint256) {
298     return allowed[_owner][_spender];
299   }
300 
301   /**
302   * @dev Increase the amount of tokens that an owner allowed to a spender.
303   *
304   * approve should be called when allowed[_spender] == 0. To increment
305   * allowed value is better to use this function to avoid 2 calls (and wait until
306   * the first transaction is mined)
307   * From MonolithDAO Token.sol
308   * @param _spender The address which will spend the funds.
309   * @param _addedValue The amount of tokens to increase the allowance by.
310   */
311   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
312     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
313     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317   /**
318   * @dev Decrease the amount of tokens that an owner allowed to a spender.
319   *
320   * approve should be called when allowed[_spender] == 0. To decrement
321   * allowed value is better to use this function to avoid 2 calls (and wait until
322   * the first transaction is mined)
323   * From MonolithDAO Token.sol
324   * @param _spender The address which will spend the funds.
325   * @param _subtractedValue The amount of tokens to decrease the allowance by.
326   */
327   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
328     uint oldValue = allowed[msg.sender][_spender];
329     if (_subtractedValue > oldValue) {
330       allowed[msg.sender][_spender] = 0;
331     } else {
332       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
333     }
334     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338   modifier canMint() {
339     require(!mintingFinished);
340     _;
341   }
342 
343   /**
344   * @dev Function to mint tokens
345   * @param _to The address that will receive the minted tokens.
346   * @param _amount The amount of tokens to mint.
347   * @return A boolean that indicates if the operation was successful.
348   */
349   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
350     totalSupply = totalSupply.add(_amount);
351     balances[_to] = balances[_to].add(_amount);
352     Mint(_to, _amount);
353     Transfer(address(0), _to, _amount);
354     return true;
355   }
356 
357   /**
358   * @dev Function to stop minting new tokens.
359   * @return True if the operation was successful.
360   */
361   function finishMinting() onlyOwner canMint public returns (bool) {
362     mintingFinished = true;
363     MintFinished();
364     return true;
365   }
366 }
367 
368 contract BitcoinusCrowdsale is Ownable {
369   using SafeMath for uint256;
370   // Wallet where all ether will be stored
371   address public constant WALLET = 0x3f39CD8a8Ae0540F0FD38aB695D36ceCf0f254E3;
372   // Wallet for team tokens
373   address public constant TEAM_WALLET = 0x35317879205E9fd59AeeC429b5494B84D8507C20;
374   // Wallet for bounty tokens
375   address public constant BOUNTY_WALLET = 0x088C48cA51A024909f06DF60597492492Eb66C2a;
376   // Wallet for company tokens
377   address public constant COMPANY_WALLET = 0x576B5cA75d4598dC31640F395F6201C5Dd0EbbB4;
378 
379   uint256 public constant TEAM_TOKENS = 4000000e18;
380   uint256 public constant TEAM_TOKENS_LOCK_PERIOD = 60 * 60 * 24 * 365; // 365 days
381   uint256 public constant COMPANY_TOKENS = 10000000e18;
382   uint256 public constant COMPANY_TOKENS_LOCK_PERIOD = 60 * 60 * 24 * 180; // 180 days
383   uint256 public constant BOUNTY_TOKENS = 1000000e18;
384   uint256 public constant SOFT_CAP = 3000000e18;
385   uint256 public constant ICO_TOKENS = 50000000e18;
386   uint256 public constant START_TIME = 1516579200; // 2018/01/22 00:00 UTC +0
387   uint256 public constant END_TIME = 1525996800; // 2018/05/11 00:00 UTC +0
388   uint256 public constant RATE = 1000;
389   uint256 public constant LARGE_PURCHASE = 1500e18;
390   uint256 public constant LARGE_PURCHASE_BONUS = 5;
391 
392   Stage[] stages;
393 
394   struct Stage {
395     uint256 till;
396     uint256 cap;
397     uint8 discount;
398   }
399 
400   // The token being sold
401   BitcoinusToken public token;
402 
403   // amount of raised money in wei
404   uint256 public weiRaised;
405 
406   // refund vault used to hold funds while crowdsale is running
407     RefundVault public vault;
408 
409   uint256 public currentStage = 0;
410     bool public isFinalized = false;
411 
412   address tokenMinter;
413 
414   TokenTimelock public teamTimelock;
415   TokenTimelock public companyTimelock;
416 
417   /**
418   * event for token purchase logging
419   * @param purchaser who paid for the tokens
420   * @param beneficiary who got the tokens
421   * @param value weis paid for purchase
422   * @param amount amount of tokens purchased
423   */
424   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
425 
426   event Finalized();
427   /**
428    * When there no tokens left to mint and token minter tries to manually mint tokens
429    * this event is raised to signal how many tokens we have to charge back to purchaser
430    */
431   event ManualTokenMintRequiresRefund(address indexed purchaser, uint256 value);
432 
433   function BitcoinusCrowdsale(address _token) public {
434     stages.push(Stage({ till: 1519344000, discount: 47, cap: 8000000e18 })); // 2018/02/23 00:00 UTC +0
435     stages.push(Stage({ till: 1521849600, discount: 40, cap: 17000000e18 })); // 2018/03/24 00:00 UTC +0
436     stages.push(Stage({ till: 1523836800, discount: 30, cap: 15000000e18 })); // 2018/04/16 00:00 UTC +0
437     stages.push(Stage({ till: 1525219200, discount: 15, cap: 7000000e18 })); // 2018/05/02 00:00 UTC +0
438     stages.push(Stage({ till: 1525996800, discount: 5,  cap: 3000000e18 })); // 2018/05/11 00:00 UTC +0
439 
440     token = BitcoinusToken(_token);
441     vault = new RefundVault(WALLET);
442     tokenMinter = msg.sender;
443   }
444 
445   modifier onlyTokenMinterOrOwner() {
446     require(msg.sender == tokenMinter || msg.sender == owner);
447     _;
448   }
449 
450   // low level token purchase function
451   function buyTokens(address beneficiary) public payable {
452     require(beneficiary != address(0));
453     require(validPurchase());
454 
455     uint256 weiAmount = msg.value;
456     uint256 nowTime = getNow();
457     // this loop moves stages and insures correct stage according to date
458     while (currentStage < stages.length && stages[currentStage].till < nowTime) {
459       stages[stages.length - 1].cap = stages[stages.length - 1].cap.add(stages[currentStage].cap); // move all unsold tokens to last stage
460       stages[currentStage].cap = 0;
461       currentStage = currentStage.add(1);
462     }
463 
464     // calculate token amount to be created
465     uint256 tokens = calculateTokens(weiAmount);
466 
467     uint256 excess = appendContribution(beneficiary, tokens);
468 
469     if (excess > 0) { // hard cap reached, no more tokens to mint
470       uint256 refund = excess.mul(weiAmount).div(tokens);
471       weiAmount = weiAmount.sub(refund);
472       msg.sender.transfer(refund);
473     }
474 
475     // update state
476     weiRaised = weiRaised.add(weiAmount);
477     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens.sub(excess));
478 
479     if (goalReached()) {
480       WALLET.transfer(weiAmount);
481     } else {
482       vault.deposit.value(weiAmount)(msg.sender);
483     }
484   }
485 
486   function calculateTokens(uint256 _weiAmount) internal view returns (uint256) {
487     uint256 tokens = _weiAmount.mul(RATE).mul(100).div(uint256(100).sub(stages[currentStage].discount));
488 
489     uint256 bonus = 0;
490     if (currentStage > 0 && tokens >= LARGE_PURCHASE) {
491       bonus = tokens.mul(LARGE_PURCHASE_BONUS).div(100);
492     }
493 
494     return tokens.add(bonus);
495   }
496 
497   function appendContribution(address _beneficiary, uint256 _tokens) internal returns (uint256) {
498     uint256 excess = _tokens;
499     uint256 tokensToMint = 0;
500 
501     while (excess > 0 && currentStage < stages.length) {
502       Stage storage stage = stages[currentStage];
503       if (excess >= stage.cap) {
504         excess = excess.sub(stage.cap);
505         tokensToMint = tokensToMint.add(stage.cap);
506         stage.cap = 0;
507         currentStage = currentStage.add(1);
508       } else {
509         stage.cap = stage.cap.sub(excess);
510         tokensToMint = tokensToMint.add(excess);
511         excess = 0;
512       }
513     }
514     token.mint(_beneficiary, tokensToMint);
515     return excess;
516   }
517 
518   // @return true if the transaction can buy tokens
519   function validPurchase() internal view returns (bool) {
520     bool withinPeriod = getNow() >= START_TIME && getNow() <= END_TIME;
521     bool nonZeroPurchase = msg.value != 0;
522     bool canMint = token.totalSupply() < ICO_TOKENS;
523     bool validStage = (currentStage < stages.length);
524     return withinPeriod && nonZeroPurchase && canMint && validStage;
525   }
526 
527   // if crowdsale is unsuccessful, investors can claim refunds here
528     function claimRefund() public {
529       require(isFinalized);
530       require(!goalReached());
531 
532       vault.refund(msg.sender);
533   }
534 
535   /**
536     * @dev Must be called after crowdsale ends, to do some extra finalization
537     * work. Calls the contract's finalization function.
538     */
539     function finalize() onlyOwner public {
540       require(!isFinalized);
541       require(hasEnded());
542 
543       if (goalReached()) {
544       vault.close();
545 
546       teamTimelock = new TokenTimelock(token, TEAM_WALLET, getNow().add(TEAM_TOKENS_LOCK_PERIOD));
547       token.mint(teamTimelock, TEAM_TOKENS);
548 
549       companyTimelock = new TokenTimelock(token, COMPANY_WALLET, getNow().add(COMPANY_TOKENS_LOCK_PERIOD));
550       token.mint(companyTimelock, COMPANY_TOKENS);
551 
552       token.mint(BOUNTY_WALLET, BOUNTY_TOKENS);
553 
554       token.finishMinting();
555       token.transferOwnership(0x1);
556       } else {
557           vault.enableRefunds();
558       }
559 
560       Finalized();
561 
562       isFinalized = true;
563     }
564 
565   // @return true if crowdsale event has ended
566   function hasEnded() public view returns (bool) {
567     return getNow() > END_TIME || token.totalSupply() == ICO_TOKENS;
568   }
569 
570     function goalReached() public view returns (bool) {
571       return token.totalSupply() >= SOFT_CAP;
572     }
573 
574     // fallback function can be used to buy tokens or claim refund
575     function () external payable {
576       if (!isFinalized) {
577         buyTokens(msg.sender);
578     } else {
579       claimRefund();
580       }
581     }
582 
583     function mintTokens(address[] _receivers, uint256[] _amounts) external onlyTokenMinterOrOwner {
584     require(_receivers.length > 0 && _receivers.length <= 100);
585     require(_receivers.length == _amounts.length);
586     require(!isFinalized);
587     for (uint256 i = 0; i < _receivers.length; i++) {
588       address receiver = _receivers[i];
589       uint256 amount = _amounts[i];
590 
591         require(receiver != address(0));
592         require(amount > 0);
593 
594         uint256 excess = appendContribution(receiver, amount);
595 
596         if (excess > 0) {
597           ManualTokenMintRequiresRefund(receiver, excess);
598         }
599     }
600     }
601 
602     function setTokenMinter(address _tokenMinter) public onlyOwner {
603       require(_tokenMinter != address(0));
604       tokenMinter = _tokenMinter;
605     }
606 
607   function getNow() internal view returns (uint256) {
608     return now;
609   }
610 }