1 pragma solidity 0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title SafeERC20
30  * @dev Wrappers around ERC20 operations that throw on failure.
31  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
32  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
33  */
34 library SafeERC20 {
35   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
36     assert(token.transfer(to, value));
37   }
38 
39   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
40     assert(token.transferFrom(from, to, value));
41   }
42 
43   function safeApprove(ERC20 token, address spender, uint256 value) internal {
44     assert(token.approve(spender, value));
45   }
46 }
47 
48 
49 /**
50  * @title TokenTimelock
51  * @dev TokenTimelock is a token holder contract that will allow a
52  * beneficiary to extract the tokens after a given release time
53  */
54 contract TokenTimelock {
55   using SafeERC20 for ERC20Basic;
56 
57   // ERC20 basic token contract being held
58   ERC20Basic public token;
59 
60   // beneficiary of tokens after they are released
61   address public beneficiary;
62 
63   // timestamp when token release is enabled
64   uint256 public releaseTime;
65 
66   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
67     require(_releaseTime > now);
68     token = _token;
69     beneficiary = _beneficiary;
70     releaseTime = _releaseTime;
71   }
72 
73   /**
74    * @notice Transfers tokens held by timelock to beneficiary.
75    */
76   function release() public {
77     require(now >= releaseTime);
78 
79     uint256 amount = token.balanceOf(this);
80     require(amount > 0);
81 
82     token.safeTransfer(beneficiary, amount);
83   }
84 }
85 
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, throws on overflow.
95   */
96   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97     if (a == 0) {
98       return 0;
99     }
100     uint256 c = a * b;
101     assert(c / a == b);
102     return c;
103   }
104 
105   /**
106   * @dev Integer division of two numbers, truncating the quotient.
107   */
108   function div(uint256 a, uint256 b) internal pure returns (uint256) {
109     // assert(b > 0); // Solidity automatically throws when dividing by 0
110     uint256 c = a / b;
111     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112     return c;
113   }
114 
115   /**
116   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     assert(b <= a);
120     return a - b;
121   }
122 
123   /**
124   * @dev Adds two numbers, throws on overflow.
125   */
126   function add(uint256 a, uint256 b) internal pure returns (uint256) {
127     uint256 c = a + b;
128     assert(c >= a);
129     return c;
130   }
131 }
132 
133 
134 /**
135  * @title Ownable
136  * @dev The Ownable contract has an owner address, and provides basic authorization control
137  * functions, this simplifies the implementation of "user permissions".
138  */
139 contract Ownable {
140   address public owner;
141 
142 
143   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145 
146   /**
147    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
148    * account.
149    */
150   function Ownable() public {
151     owner = msg.sender;
152   }
153 
154   /**
155    * @dev Throws if called by any account other than the owner.
156    */
157   modifier onlyOwner() {
158     require(msg.sender == owner);
159     _;
160   }
161 
162   /**
163    * @dev Allows the current owner to transfer control of the contract to a newOwner.
164    * @param newOwner The address to transfer ownership to.
165    */
166   function transferOwnership(address newOwner) public onlyOwner {
167     require(newOwner != address(0));
168     OwnershipTransferred(owner, newOwner);
169     owner = newOwner;
170   }
171 
172 }
173 
174 
175 contract DiceGameToken is ERC20, Ownable {
176     using SafeMath for uint256;
177 
178     string public constant name = "DiceGame Token";
179     string public constant symbol = "DICE";
180     uint8 public constant decimals = 18;
181 
182     mapping (address => uint256) private balances;
183     mapping (address => mapping (address => uint256)) internal allowed;
184 
185     event Mint(address indexed to, uint256 amount);
186     event MintFinished();
187 
188     bool public mintingFinished = false;
189 
190     uint256 private totalSupply_;
191 
192     modifier canTransfer() {
193         require(mintingFinished);
194         _;
195     }
196 
197     /**
198     * @dev total number of tokens in existence
199     */
200     function totalSupply() public view returns (uint256) {
201         return totalSupply_;
202     }
203 
204     /**
205     * @dev transfer token for a specified address
206     * @param _to The address to transfer to.
207     * @param _value The amount to be transferred.
208     */
209     function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
210         require(_to != address(0));
211         require(_value <= balances[msg.sender]);
212 
213         // SafeMath.sub will throw if there is not enough balance.
214         balances[msg.sender] = balances[msg.sender].sub(_value);
215         balances[_to] = balances[_to].add(_value);
216         Transfer(msg.sender, _to, _value);
217         return true;
218     }
219 
220     /**
221     * @dev Gets the balance of the specified address.
222     * @param _owner The address to query the the balance of.
223     * @return An uint256 representing the amount owned by the passed address.
224     */
225     function balanceOf(address _owner) public view returns (uint256 balance) {
226         return balances[_owner];
227     }
228 
229     /**
230     * @dev Transfer tokens from one address to another
231     * @param _from address The address which you want to send tokens from
232     * @param _to address The address which you want to transfer to
233     * @param _value uint256 the amount of tokens to be transferred
234     */
235     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
236         require(_to != address(0));
237         require(_value <= balances[_from]);
238         require(_value <= allowed[_from][msg.sender]);
239 
240         balances[_from] = balances[_from].sub(_value);
241         balances[_to] = balances[_to].add(_value);
242         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243         Transfer(_from, _to, _value);
244         return true;
245     }
246 
247     /**
248     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249     *
250     * Beware that changing an allowance with this method brings the risk that someone may use both the old
251     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254     * @param _spender The address which will spend the funds.
255     * @param _value The amount of tokens to be spent.
256     */
257     function approve(address _spender, uint256 _value) public returns (bool) {
258         allowed[msg.sender][_spender] = _value;
259         Approval(msg.sender, _spender, _value);
260         return true;
261     }
262 
263     /**
264     * @dev Function to check the amount of tokens that an owner allowed to a spender.
265     * @param _owner address The address which owns the funds.
266     * @param _spender address The address which will spend the funds.
267     * @return A uint256 specifying the amount of tokens still available for the spender.
268     */
269     function allowance(address _owner, address _spender) public view returns (uint256) {
270         return allowed[_owner][_spender];
271     }
272 
273     /**
274     * @dev Increase the amount of tokens that an owner allowed to a spender.
275     *
276     * approve should be called when allowed[_spender] == 0. To increment
277     * allowed value is better to use this function to avoid 2 calls (and wait until
278     * the first transaction is mined)
279     * From MonolithDAO Token.sol
280     * @param _spender The address which will spend the funds.
281     * @param _addedValue The amount of tokens to increase the allowance by.
282     */
283     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
284         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
285         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286         return true;
287     }
288 
289     /**
290     * @dev Decrease the amount of tokens that an owner allowed to a spender.
291     *
292     * approve should be called when allowed[_spender] == 0. To decrement
293     * allowed value is better to use this function to avoid 2 calls (and wait until
294     * the first transaction is mined)
295     * From MonolithDAO Token.sol
296     * @param _spender The address which will spend the funds.
297     * @param _subtractedValue The amount of tokens to decrease the allowance by.
298     */
299     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
300         uint oldValue = allowed[msg.sender][_spender];
301         if (_subtractedValue > oldValue) {
302             allowed[msg.sender][_spender] = 0;
303         } else {
304             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305         }
306         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307         return true;
308     }
309 
310     modifier canMint() {
311         require(!mintingFinished);
312         _;
313     }
314 
315     /**
316     * @dev Function to mint tokens
317     * @param _to The address that will receive the minted tokens.
318     * @param _amount The amount of tokens to mint.
319     * @return A boolean that indicates if the operation was successful.
320     */
321     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
322         totalSupply_ = totalSupply_.add(_amount);
323         balances[_to] = balances[_to].add(_amount);
324         Mint(_to, _amount);
325         Transfer(address(0), _to, _amount);
326         return true;
327     }
328 
329     /**
330     * @dev Function to stop minting new tokens.
331     * @return True if the operation was successful.
332     */
333     function finishMinting() public onlyOwner canMint returns (bool) {
334         mintingFinished = true;
335         MintFinished();
336         return true;
337     }
338 }
339 
340 
341 contract TokenDeskProxySupport {
342     function buyTokens(address sender_, address benefeciary_, uint256 tokenDeskBonus_) external payable;
343 }
344 
345 
346 contract TokenDeskProxyAware is TokenDeskProxySupport, Ownable {
347 
348     address private tokenDeskProxy;
349 
350     modifier onlyTokenDeskProxy() {
351         require(msg.sender == tokenDeskProxy);
352         _;
353     }
354 
355     function buyTokens(address beneficiary) public payable {
356         internalBuyTokens(msg.sender, beneficiary, 0);
357     }
358 
359     function buyTokens(address sender, address beneficiary, uint256 tokenDeskBonus) external payable onlyTokenDeskProxy {
360         internalBuyTokens(sender, beneficiary, tokenDeskBonus);
361     }
362 
363     function setTokenDeskProxy(address tokenDeskProxy_) public onlyOwner {
364         require(tokenDeskProxy_ != address(0));
365         tokenDeskProxy = tokenDeskProxy_;
366     }
367 
368     function internalBuyTokens(address sender, address beneficiary, uint256 tokenDeskBonus) internal;
369 }
370 
371 
372 /**
373  * The EscrowVault contract collects crowdsale ethers and allows to refund
374  * if softcap soft cap is not reached.
375  */
376 contract EscrowVault is Ownable {
377   using SafeMath for uint256;
378 
379   enum State { Active, Refunding, GoalReached, Closed }
380 
381   mapping (address => uint256) public deposited;
382   address public beneficiary;
383   address public superOwner;
384   State public state;
385 
386   event GoalReached();
387   event RefundsEnabled();
388   event Refunded(address indexed beneficiary, uint256 weiAmount);
389   event Withdrawal(uint256 weiAmount);
390   event Close();
391 
392   function EscrowVault(address _superOwner, address _beneficiary) public {
393     require(_beneficiary != address(0));
394     require(_superOwner != address(0));
395     beneficiary = _beneficiary;
396     superOwner = _superOwner;
397     state = State.Active;
398   }
399 
400   function deposit(address investor) onlyOwner public payable {
401     require(state == State.Active || state == State.GoalReached);
402     deposited[investor] = deposited[investor].add(msg.value);
403   }
404 
405   function setGoalReached() onlyOwner public {
406     require (state == State.Active);
407     state = State.GoalReached;
408     GoalReached();
409   }
410 
411   function withdraw(uint256 _amount) public {
412     require(msg.sender == superOwner);
413     require(state == State.GoalReached);
414     require (_amount <= this.balance &&  _amount > 0);
415     beneficiary.transfer(_amount);
416     Withdrawal(_amount);
417   }
418 
419   function withdrawAll() onlyOwner public {
420     require(state == State.GoalReached);
421     uint256 balance = this.balance;
422     Withdrawal(balance);
423     beneficiary.transfer(balance);
424   }
425 
426   function close() onlyOwner public {
427     require (state == State.GoalReached);
428     withdrawAll();
429     state = State.Closed;
430     Close();
431   }
432 
433   function enableRefunds() onlyOwner public {
434     require(state == State.Active);
435     state = State.Refunding;
436     RefundsEnabled();
437   }
438 
439   function refund(address investor) public {
440     require(state == State.Refunding);
441     uint256 depositedValue = deposited[investor];
442     deposited[investor] = 0;
443     investor.transfer(depositedValue);
444     Refunded(investor, depositedValue);
445   }
446 }
447 
448 
449 contract DiceGameCrowdsale is TokenDeskProxyAware {
450     using SafeMath for uint256;
451     // Wallet where all ether will be moved after escrow withdrawal. Can be even multisig wallet
452     address public constant WALLET = 0x15c6833A25AFDFd4d9BfE7524A731aaF65Ff1006;
453     // Wallet for team tokens
454     address public constant TEAM_WALLET = 0xf2f74443Be9314910a27495E47D9221b0DfCBD2f;
455     // Wallet for first tournament tokens
456     address public constant TOURNAMENT_WALLET = 0xc102b79F40736B7d96b31279a7e696535Cef7142;
457     // Wallet for company tokens
458     address public constant COMPANY_WALLET = 0x937f9187394F44D39e207C971103b23659Ec09c0;
459     // Wallet for bounty tokens
460     address public constant BOUNTY_WALLET = 0x7BEe48014C2D857C0Ef0126e3c6a3f5B718cC40f;
461     // Wallet for bounty tokens
462     address public constant ADVISORS_WALLET = 0x15a40F3A28a7409c0eF9a144a16bE354566221AD;
463 
464     uint256 public constant TEAM_TOKENS_LOCK_PERIOD = 60 * 60 * 24 * 365; // 365 days
465     uint256 public constant COMPANY_TOKENS_LOCK_PERIOD = 60 * 60 * 24 * 180; // 180 days
466     uint256 public constant SOFT_CAP = 42000000e18; // 42 000 000
467     uint256 public constant ICO_TOKENS = 210000000e18; // 147 000 000
468     uint256 public constant START_TIME = 1524830400; // 2018-04-27 12:00 UTC +0
469     uint256 public constant RATE = 10000;  // 0.0001 ETH
470     uint256 public constant LARGE_PURCHASE = 12000e18; // 12 000 tokens
471 
472     uint256 public icoEndTime = 1534420800; // 2018-08-16 12:00 12:00 UTC +0
473     uint8 public constant ICO_TOKENS_PERCENT = 70;
474     uint8 public constant TEAM_TOKENS_PERCENT = 12;
475     uint8 public constant COMPANY_TOKENS_PERCENT = 7;
476     uint8 public constant TOURNAMENT_TOKENS_PERCENT = 5;
477     uint8 public constant BOUNTY_TOKENS_PERCENT = 3;
478     uint8 public constant ADVISORS_TOKENS_PERCENT = 3;
479 
480     uint8 public constant LARGE_PURCHASE_BONUS = 5;
481 
482     Stage[] internal stages;
483 
484     struct Stage {
485         uint256 cap;
486         uint64 till;
487         uint8 bonus;
488     }
489 
490     // The token being sold
491     DiceGameToken public token;
492 
493     // amount of raised money in wei
494     uint256 public weiRaised;
495 
496     // refund vault used to hold funds while crowdsale is running
497     EscrowVault public vault;
498 
499     uint256 public currentStage = 0;
500     bool public isFinalized = false;
501 
502     address private tokenMinter;
503 
504     TokenTimelock public teamTimelock;
505     TokenTimelock public companyTimelock;
506 
507     /**
508     * event for token purchase logging
509     * @param purchaser who paid for the tokens
510     * @param beneficiary who got the tokens
511     * @param value weis paid for purchase
512     * @param amount amount of tokens purchased
513     */
514     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
515 
516     event Finalized();
517     /**
518      * When there no tokens left to mint and token minter tries to manually mint tokens
519      * this event is raised to signal how many tokens we have to charge back to purchaser
520      */
521     event ManualTokenMintRequiresRefund(address indexed purchaser, uint256 value);
522 
523     function DiceGameCrowdsale(address _token) public {
524         stages.push(Stage({ till: 1526385600, bonus: 40, cap: 20000000e18 }));    // 2018-05-15 12:00 UTC +0
525         stages.push(Stage({ till: 1527681600, bonus: 30, cap: 30000000e18 }));    // 2018-05-30 12:00 UTC +0
526         stages.push(Stage({ till: 1528977600, bonus: 20, cap: 30000000e18 }));    // 2018-06-14 12:00 UTC +0
527         stages.push(Stage({ till: 1530273600, bonus: 15, cap: 30000000e18 }));    // 2018-06-29 12:00 UTC +0
528         stages.push(Stage({ till: 1531656000, bonus: 10, cap: 30000000e18 }));    // 2018-07-15 12:00 UTC +0
529         stages.push(Stage({ till: ~uint64(0), bonus: 0, cap: 70000000e18 }));     // unlimited
530 
531         token = DiceGameToken(_token);
532         vault = new EscrowVault(msg.sender, WALLET);  // Wallet where all ether will be stored during ICO
533     }
534 
535     modifier onlyTokenMinterOrOwner() {
536         require(msg.sender == tokenMinter || msg.sender == owner);
537         _;
538     }
539 
540     function internalBuyTokens(address sender, address beneficiary, uint256 tokenDeskBonus) internal {
541         require(beneficiary != address(0));
542         require(sender != address(0));
543         require(validPurchase());
544 
545         uint256 weiAmount = msg.value;
546         uint256 nowTime = getNow();
547         // this loop moves stages and ensures correct stage according to date
548         while (currentStage < stages.length && stages[currentStage].till < nowTime) {
549             // move all unsold tokens to next stage
550             uint256 nextStage = currentStage.add(1);
551             stages[nextStage].cap = stages[nextStage].cap.add(stages[currentStage].cap);
552             stages[currentStage].cap = 0;
553             currentStage = nextStage;
554         }
555 
556         // calculate token amount to be created
557         uint256 tokens = calculateTokens(weiAmount, tokenDeskBonus);
558 
559         uint256 excess = appendContribution(beneficiary, tokens);
560         uint256 refund = (excess > 0 ? excess.mul(weiAmount).div(tokens) : 0);
561         weiAmount = weiAmount.sub(refund);
562         weiRaised = weiRaised.add(weiAmount);
563 
564         if (refund > 0) { // hard cap reached, no more tokens to mint
565             sender.transfer(refund);
566         }
567 
568         TokenPurchase(sender, beneficiary, weiAmount, tokens.sub(excess));
569 
570         if (goalReached() && vault.state() == EscrowVault.State.Active) {
571             vault.setGoalReached();
572         }
573         vault.deposit.value(weiAmount)(sender);
574     }
575 
576     function calculateTokens(uint256 _weiAmount, uint256 _tokenDeskBonus) internal view returns (uint256) {
577         uint256 tokens = _weiAmount.mul(RATE);
578 
579         if (stages[currentStage].bonus > 0) {
580             uint256 stageBonus = tokens.mul(stages[currentStage].bonus).div(100);
581             tokens = tokens.add(stageBonus);
582         }
583 
584         if (currentStage < 1) return tokens;
585 
586         uint256 bonus = _tokenDeskBonus.add(tokens >= LARGE_PURCHASE ? LARGE_PURCHASE_BONUS : 0);
587         return tokens.add(tokens.mul(bonus).div(100));
588     }
589 
590     function appendContribution(address _beneficiary, uint256 _tokens) internal returns (uint256) {
591         uint256 excess = _tokens;
592         uint256 tokensToMint = 0;
593 
594         while (excess > 0 && currentStage < stages.length) {
595             Stage storage stage = stages[currentStage];
596             if (excess >= stage.cap) {
597                 excess = excess.sub(stage.cap);
598                 tokensToMint = tokensToMint.add(stage.cap);
599                 stage.cap = 0;
600                 currentStage = currentStage.add(1);
601             } else {
602                 stage.cap = stage.cap.sub(excess);
603                 tokensToMint = tokensToMint.add(excess);
604                 excess = 0;
605             }
606         }
607         if (tokensToMint > 0) {
608             token.mint(_beneficiary, tokensToMint);
609         }
610         return excess;
611     }
612 
613     // @return true if the transaction can buy tokens
614     function validPurchase() internal view returns (bool) {
615         bool withinPeriod = getNow() >= START_TIME && getNow() <= icoEndTime;
616         bool nonZeroPurchase = msg.value != 0;
617         bool canMint = token.totalSupply() < ICO_TOKENS;
618         bool validStage = (currentStage < stages.length);
619         return withinPeriod && nonZeroPurchase && canMint && validStage;
620     }
621 
622     // if crowdsale is unsuccessful, investors can claim refunds here
623     function claimRefund() public {
624         require(isFinalized);
625         require(!goalReached());
626 
627         vault.refund(msg.sender);
628     }
629 
630     /**
631     * @dev Must be called after crowdsale ends, to do some extra finalization
632     * work. Calls the contract's finalization function.
633     */
634     function finalize() public onlyOwner {
635         require(!isFinalized);
636         require(getNow() > icoEndTime || token.totalSupply() == ICO_TOKENS);
637 
638         if (goalReached()) {
639             // Close escrowVault and transfer all collected ethers into WALLET address
640             if (vault.state() != EscrowVault.State.Closed) {
641                 vault.close();
642             }
643 
644             uint256 totalSupply = token.totalSupply();
645 
646             teamTimelock = new TokenTimelock(token, TEAM_WALLET, getNow().add(TEAM_TOKENS_LOCK_PERIOD));
647             token.mint(teamTimelock, uint256(TEAM_TOKENS_PERCENT).mul(totalSupply).div(ICO_TOKENS_PERCENT));
648 
649             companyTimelock = new TokenTimelock(token, COMPANY_WALLET, getNow().add(COMPANY_TOKENS_LOCK_PERIOD));
650             token.mint(companyTimelock, uint256(COMPANY_TOKENS_PERCENT).mul(totalSupply).div(ICO_TOKENS_PERCENT));
651 
652             token.mint(TOURNAMENT_WALLET, uint256(TOURNAMENT_TOKENS_PERCENT).mul(totalSupply).div(ICO_TOKENS_PERCENT));
653 
654             token.mint(BOUNTY_WALLET, uint256(BOUNTY_TOKENS_PERCENT).mul(totalSupply).div(ICO_TOKENS_PERCENT));
655             
656             token.mint(ADVISORS_WALLET, uint256(ADVISORS_TOKENS_PERCENT).mul(totalSupply).div(ICO_TOKENS_PERCENT));
657 
658             token.finishMinting();
659             token.transferOwnership(token);
660         } else {
661             vault.enableRefunds();
662         }
663         Finalized();
664         isFinalized = true;
665     }
666 
667     function goalReached() public view returns (bool) {
668         return token.totalSupply() >= SOFT_CAP;
669     }
670 
671     // fallback function can be used to buy tokens or claim refund
672     function () external payable {
673         if (!isFinalized) {
674             buyTokens(msg.sender);
675         } else {
676             claimRefund();
677         }
678     }
679 
680     function mintTokens(address[] _receivers, uint256[] _amounts) external onlyTokenMinterOrOwner {
681         require(_receivers.length > 0 && _receivers.length <= 100);
682         require(_receivers.length == _amounts.length);
683         require(!isFinalized);
684         for (uint256 i = 0; i < _receivers.length; i++) {
685             address receiver = _receivers[i];
686             uint256 amount = _amounts[i];
687 
688             require(receiver != address(0));
689             require(amount > 0);
690 
691             uint256 excess = appendContribution(receiver, amount);
692 
693             if (excess > 0) {
694                 ManualTokenMintRequiresRefund(receiver, excess);
695             }
696         }
697     }
698 
699     function setIcoEndTime(uint256 _endTime) public onlyOwner {
700         require(_endTime > START_TIME && _endTime > getNow());
701         icoEndTime = _endTime;
702     }
703 
704     function setTokenMinter(address _tokenMinter) public onlyOwner {
705         require(_tokenMinter != address(0));
706         tokenMinter = _tokenMinter;
707     }
708 
709     function getNow() internal view returns (uint256) {
710         return now;
711     }
712 }