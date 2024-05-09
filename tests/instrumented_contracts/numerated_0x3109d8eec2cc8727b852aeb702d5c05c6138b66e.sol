1 pragma solidity ^0.4.20;
2 contract Ownable {
3   address public owner;
4   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5   function Ownable() public {
6     owner = msg.sender;
7   }
8   modifier onlyOwner() {
9     require(msg.sender == owner);
10     _;
11   }
12   function transferOwnership(address newOwner) public onlyOwner {
13     require(newOwner != address(0));
14     OwnershipTransferred(owner, newOwner);
15     owner = newOwner;
16   }
17 
18 }
19 contract ERC20Basic {
20   function totalSupply() public view returns (uint256);
21   function balanceOf(address who) public view returns (uint256);
22   function transfer(address to, uint256 value) public returns (bool);
23   event Transfer(address indexed from, address indexed to, uint256 value);
24 }
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   uint256 totalSupply_;
56   function totalSupply() public view returns (uint256) {
57     return totalSupply_;
58   }
59 
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63 
64     // SafeMath.sub will throw if there is not enough balance.
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     Transfer(msg.sender, _to, _value);
68     return true;
69   }
70   function balanceOf(address _owner) public view returns (uint256 balance) {
71     return balances[_owner];
72   }
73 
74 }
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender) public view returns (uint256);
77   function transferFrom(address from, address to, uint256 value) public returns (bool);
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 contract StandardToken is ERC20, BasicToken {
82 
83   mapping (address => mapping (address => uint256)) internal allowed;
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[_from]);
87     require(_value <= allowed[_from][msg.sender]);
88 
89     balances[_from] = balances[_from].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
92     Transfer(_from, _to, _value);
93     return true;
94   }
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   function allowance(address _owner, address _spender) public view returns (uint256) {
102     return allowed[_owner][_spender];
103   }
104   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
105     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110   /**
111    * @dev Decrease the amount of tokens that an owner allowed to a spender.
112    *
113    * approve should be called when allowed[_spender] == 0. To decrement
114    * allowed value is better to use this function to avoid 2 calls (and wait until
115    * the first transaction is mined)
116    * From MonolithDAO Token.sol
117    * @param _spender The address which will spend the funds.
118    * @param _subtractedValue The amount of tokens to decrease the allowance by.
119    */
120   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
121     uint oldValue = allowed[msg.sender][_spender];
122     if (_subtractedValue > oldValue) {
123       allowed[msg.sender][_spender] = 0;
124     } else {
125       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126     }
127     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131 }
132 
133 // File: contracts\MintableToken.sol
134 
135 /**
136  * @title Mintable token
137  * @dev Simple ERC20 Token example, with mintable token creation
138  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
139  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
140  */
141 contract MintableToken is StandardToken, Ownable {
142   event Mint(address indexed to, uint256 amount);
143   event MintFinished();
144 
145   bool public mintingFinished = false;
146 
147 
148   modifier canMint() {
149     require(!mintingFinished);
150     _;
151   }
152 
153   /**
154    * @dev Function to mint tokens
155    * @param _to The address that will receive the minted tokens.
156    * @param _amount The amount of tokens to mint.
157    * @return A boolean that indicates if the operation was successful.
158    */
159   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
160     totalSupply_ = totalSupply_.add(_amount);
161     balances[_to] = balances[_to].add(_amount);
162     Mint(_to, _amount);
163     Transfer(address(0), _to, _amount);
164     return true;
165   }
166 
167   /**
168    * @dev Function to stop minting new tokens.
169    * @return True if the operation was successful.
170    */
171   function finishMinting() onlyOwner canMint public returns (bool) {
172     mintingFinished = true;
173     MintFinished();
174     return true;
175   }
176 }
177 
178 // File: contracts\Crowdsale.sol
179 
180 /**
181  * @title Crowdsale
182  * @dev Crowdsale is a base contract for managing a token crowdsale.
183  * Crowdsales have a start and end timestamps, where investors can make
184  * token purchases and the crowdsale will assign them tokens based
185  * on a token per ETH rate. Funds collected are forwarded to a wallet
186  * as they arrive.
187  */
188 contract Crowdsale {
189   using SafeMath for uint256;
190 
191   // The token being sold
192   MintableToken public token;
193 
194   // start and end timestamps where investments are allowed (both inclusive)
195   uint256 public startTime;
196   uint256 public endTime;
197 
198   // address where funds are collected
199   address public wallet;
200 
201   // how many token units a buyer gets per wei
202   uint256 public rate;
203 
204   // amount of raised money in wei
205   uint256 public weiRaised;
206 
207   /**
208    * event for token purchase logging
209    * @param purchaser who paid for the tokens
210    * @param beneficiary who got the tokens
211    * @param value weis paid for purchase
212    * @param amount amount of tokens purchased
213    */
214   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
215 
216 
217   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
218     //require(_startTime >= now);
219     require(_endTime >= _startTime);
220     require(_rate > 0);
221     require(_wallet != address(0));
222 
223     token = createTokenContract();
224     startTime = _startTime;
225     endTime = _endTime;
226     rate = _rate;
227     wallet = _wallet;
228   }
229 
230   // fallback function can be used to buy tokens
231   function () external payable {
232     buyTokens(msg.sender);
233   }
234 
235   // low level token purchase function
236   function buyTokens(address beneficiary) public payable {
237     require(beneficiary != address(0));
238     require(validPurchase());
239 
240     uint256 weiAmount = msg.value;
241 
242     // calculate token amount to be created
243     uint256 tokens = getTokenAmount(weiAmount);
244 
245     // update state
246     weiRaised = weiRaised.add(weiAmount);
247 
248     token.mint(beneficiary, tokens);
249     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
250 
251     forwardFunds();
252   }
253 
254   // @return true if crowdsale event has ended
255   function hasEnded() public view returns (bool) {
256     return now > endTime;
257   }
258 
259   // creates the token to be sold.
260   // override this method to have crowdsale of a specific mintable token.
261   function createTokenContract() internal returns (MintableToken) {
262     return new MintableToken();
263   }
264 
265   // Override this method to have a way to add business logic to your crowdsale when buying
266   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
267     return weiAmount.mul(rate);
268   }
269 
270   // send ether to the fund collection wallet
271   // override to create custom fund forwarding mechanisms
272   function forwardFunds() internal {
273     wallet.transfer(msg.value);
274   }
275 
276   // @return true if the transaction can buy tokens
277   function validPurchase() internal view returns (bool) {
278     bool withinPeriod = now >= startTime && now <= endTime;
279     bool nonZeroPurchase = msg.value != 0;
280     return withinPeriod && nonZeroPurchase;
281   }
282 
283 }
284 
285 contract CappedCrowdsale is Crowdsale {
286   using SafeMath for uint256;
287 
288   uint256 public cap;
289 
290   function CappedCrowdsale(uint256 _cap) public {
291     require(_cap > 0);
292     cap = _cap;
293   }
294   function hasEnded() public view returns (bool) {
295     bool capReached = weiRaised >= cap;
296     return capReached || super.hasEnded();
297   }
298   function validPurchase() internal view returns (bool) {
299     bool withinCap = weiRaised.add(msg.value) <= cap;
300     return withinCap && super.validPurchase();
301   }
302 
303 }
304 
305 contract HAIToken is MintableToken {
306   string public name = "HAI Token";
307   string public symbol = "HAI";
308   uint8 public decimals = 18;
309 }
310 
311 // File: contracts\FinalizableCrowdsale.sol
312 
313 /**
314  * @title FinalizableCrowdsale
315  * @dev Extension of Crowdsale where an owner can do extra work
316  * after finishing.
317  */
318 contract FinalizableCrowdsale is Crowdsale, Ownable {
319   using SafeMath for uint256;
320 
321   bool public isFinalized = false;
322 
323   event Finalized();
324 
325   /**
326    * @dev Must be called after crowdsale ends, to do some extra finalization
327    * work. Calls the contract's finalization function.
328    */
329   function finalize() onlyOwner public {
330     require(!isFinalized);
331     require(hasEnded());
332 
333     finalization();
334     Finalized();
335 
336     isFinalized = true;
337   }
338 
339   /**
340    * @dev Can be overridden to add finalization logic. The overriding function
341    * should call super.finalization() to ensure the chain of finalization is
342    * executed entirely.
343    */
344   function finalization() internal {
345   }
346 }
347 
348 // File: contracts\RefundVault.sol
349 
350 /**
351  * @title RefundVault
352  * @dev This contract is used for storing funds while a crowdsale
353  * is in progress. Supports refunding the money if crowdsale fails,
354  * and forwarding it if crowdsale is successful.
355  */
356 contract RefundVault is Ownable {
357   using SafeMath for uint256;
358 
359   enum State { Active, Refunding, Closed }
360 
361   mapping (address => uint256) public deposited;
362   address public wallet;
363   State public state;
364 
365   event Closed();
366   event RefundsEnabled();
367   event Refunded(address indexed beneficiary, uint256 weiAmount);
368 
369   function RefundVault(address _wallet) public {
370     require(_wallet != address(0));
371     wallet = _wallet;
372     state = State.Active;
373   }
374 
375   function deposit(address investor) onlyOwner public payable {
376     require(state == State.Active);
377     deposited[investor] = deposited[investor].add(msg.value);
378   }
379 
380   function close() onlyOwner public {
381     require(state == State.Active);
382     state = State.Closed;
383     Closed();
384     wallet.transfer(this.balance);
385   }
386 
387   function enableRefunds() onlyOwner public {
388     require(state == State.Active);
389     state = State.Refunding;
390     RefundsEnabled();
391   }
392 
393   function refund(address investor) public {
394     require(state == State.Refunding);
395     uint256 depositedValue = deposited[investor];
396     deposited[investor] = 0;
397     investor.transfer(depositedValue);
398     Refunded(investor, depositedValue);
399   }
400 }
401 
402 // File: contracts\RefundableCrowdsale.sol
403 
404 /**
405  * @title RefundableCrowdsale
406  * @dev Extension of Crowdsale contract that adds a funding goal, and
407  * the possibility of users getting a refund if goal is not met.
408  * Uses a RefundVault as the crowdsale's vault.
409  */
410 contract RefundableCrowdsale is FinalizableCrowdsale {
411   using SafeMath for uint256;
412 
413   // minimum amount of funds to be raised in weis
414   uint256 public goal;
415 
416   // refund vault used to hold funds while crowdsale is running
417   RefundVault public vault;
418 
419   function RefundableCrowdsale(uint256 _goal) public {
420     require(_goal > 0);
421     vault = new RefundVault(wallet);
422     goal = _goal;
423   }
424 
425   // if crowdsale is unsuccessful, investors can claim refunds here
426   /*function claimRefund() public {
427     require(isFinalized);
428     require(!goalReached());
429 
430     vault.refund(msg.sender);
431   }
432   */
433 
434   function goalReached() public view returns (bool) {
435     return weiRaised >= goal;
436   }
437 
438   // vault finalization task, called when owner calls finalize()
439   function finalization() internal {
440     if (goalReached()) {
441       vault.close();
442     } else {
443       vault.enableRefunds();
444     }
445 
446     super.finalization();
447   }
448 
449   // We're overriding the fund forwarding from Crowdsale.
450   // In addition to sending the funds, we want to call
451   // the RefundVault deposit function
452   function forwardFunds() internal {
453     vault.deposit.value(msg.value)(msg.sender);
454   }
455 
456 }
457 
458 // File: contracts\HAICrowdsale.sol
459 
460 contract HAICrowdsale is CappedCrowdsale, RefundableCrowdsale {
461 
462   // ICO Stage
463   // ============
464   enum CrowdsaleStage { PreICO, ICO }
465   CrowdsaleStage public stage = CrowdsaleStage.PreICO;
466   // =============
467 
468   // Token Distribution
469   // =============================
470   uint256 public maxTokens = 100000000000000000000000000;
471   uint256 public tokensForEcosystem = 5000000000000000000000000;
472   uint256 public tokensForTeam = 5000000000000000000000000;
473   uint256 public tokensForBounty = 5000000000000000000000000;
474   uint256 public totalTokensForSale = 75000000000000000000000000;
475   uint256 public totalTokensForSaleDuringPreICO = 10000000000000000000000000;
476   // ==============================
477 
478   // Amount raised in PreICO
479   // ==================
480   uint256 public totalWeiRaisedDuringPreICO;
481   // ===================
482 
483 
484   // Events
485   event EthTransferred(string text);
486   event EthRefunded(string text);
487 
488 
489   // Constructor
490   // ============
491   function HAICrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap) CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startTime, _endTime, _rate, _wallet) public {
492       require(_goal <= _cap);
493   }
494   // =============
495 
496   // Token Deployment
497   // =================
498   function createTokenContract() internal returns (MintableToken) {
499     return new HAIToken(); // Deploys the ERC20 token. Automatically called when crowdsale contract is deployed
500   }
501   // ==================
502 
503   // Crowdsale Stage Management
504   // =========================================================
505 
506   // Change Crowdsale Stage. Available Options: PreICO, ICO
507   function setCrowdsaleStage(uint value) public onlyOwner {
508 
509       CrowdsaleStage _stage;
510 
511       if (uint(CrowdsaleStage.PreICO) == value) {
512         _stage = CrowdsaleStage.PreICO;
513       } else if (uint(CrowdsaleStage.ICO) == value) {
514         _stage = CrowdsaleStage.ICO;
515       }
516 
517       stage = _stage;
518 
519       if (stage == CrowdsaleStage.PreICO) {
520         setCurrentRate(2500);
521       } else if (stage == CrowdsaleStage.ICO) {
522         setCurrentRate(2000);
523       }
524   }
525 
526   // Change the current rate
527   function setCurrentRate(uint256 _rate) private {
528       rate = _rate;
529   }
530 
531   // ================ Stage Management Over =====================
532 
533   // Token Purchase
534   // =========================
535   function () external payable {
536       uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
537       if ((stage == CrowdsaleStage.PreICO) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
538         msg.sender.transfer(msg.value); // Refund them
539         EthRefunded("PreICO Limit Hit");
540         return;
541       }
542 
543       buyTokens(msg.sender);
544 
545       if (stage == CrowdsaleStage.PreICO) {
546           totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
547       }
548   }
549 
550   function forwardFunds() internal {
551       if (stage == CrowdsaleStage.PreICO) {
552           wallet.transfer(msg.value);
553           EthTransferred("forwarding funds to wallet");
554       } else if (stage == CrowdsaleStage.ICO) {
555           EthTransferred("forwarding funds to refundable vault");
556           super.forwardFunds();
557       }
558   }
559   // ===========================
560 
561   // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
562   // ====================================================================
563 
564   function finish(address _teamFund, address _ecosystemFund, address _bountyFund) public onlyOwner {
565 
566       require(!isFinalized);
567       uint256 alreadyMinted = token.totalSupply();
568       require(alreadyMinted < maxTokens);
569       uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
570       if (unsoldTokens > 0) {
571         tokensForEcosystem = tokensForEcosystem + unsoldTokens;
572       }
573       token.mint(_teamFund,tokensForTeam);
574       token.mint(_ecosystemFund,tokensForEcosystem);
575       token.mint(_bountyFund,tokensForBounty);
576       finalize();
577   }
578 }