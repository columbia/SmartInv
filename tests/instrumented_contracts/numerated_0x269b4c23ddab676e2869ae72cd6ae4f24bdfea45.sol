1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         if (a != 0 && c / a != b) revert();
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         if (b > a) revert();
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         if (c < a) revert();
30         return c;
31     }
32 }
33 
34 contract ERC20Basic {
35     uint256 public totalSupply;
36 
37     function balanceOf(address who) public constant returns (uint256);
38 
39     function transfer(address to, uint256 value) public returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 /**
45  * @title ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/20
47  */
48 contract ERC20 is ERC20Basic {
49     function allowance(address owner, address spender) public constant returns (uint256);
50 
51     function transferFrom(address from, address to, uint256 value) public returns (bool);
52 
53     function approve(address spender, uint256 value) public returns (bool);
54 
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63     using SafeMath for uint256;
64 
65     mapping (address => uint256) balances;
66 
67     /**
68     * @dev transfer token for a specified address
69     * @param _to The address to transfer to.
70     * @param _value The amount to be transferred.
71     */
72     function transfer(address _to, uint256 _value) public returns (bool) {
73         require(_to != address(0));
74 
75         // SafeMath.sub will throw if there is not enough balance.
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     /**
83     * @dev Gets the balance of the specified address.
84     * @param _owner The address to query the the balance of.
85     * @return An uint256 representing the amount owned by the passed address.
86     */
87     function balanceOf(address _owner) public constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102     mapping (address => mapping (address => uint256)) allowed;
103 
104 
105     /**
106      * @dev Transfer tokens from one address to another
107      * @param _from address The address which you want to send tokens from
108      * @param _to address The address which you want to transfer to
109      * @param _value uint256 the amount of tokens to be transferred
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113 
114         uint256 _allowance = allowed[_from][msg.sender];
115 
116         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117         // require (_value <= _allowance);
118 
119         balances[_from] = balances[_from].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         allowed[_from][msg.sender] = _allowance.sub(_value);
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     /**
127      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128      *
129      * Beware that changing an allowance with this method brings the risk that someone may use both the old
130      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      * @param _spender The address which will spend the funds.
134      * @param _value The amount of tokens to be spent.
135      */
136     function approve(address _spender, uint256 _value) public returns (bool) {
137         allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     /**
143      * @dev Function to check the amount of tokens that an owner allowed to a spender.
144      * @param _owner address The address which owns the funds.
145      * @param _spender address The address which will spend the funds.
146      * @return A uint256 specifying the amount of tokens still available for the spender.
147      */
148     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149         return allowed[_owner][_spender];
150     }
151 
152     /**
153      * approve should be called when allowed[_spender] == 0. To increment
154      * allowed value is better to use this function to avoid 2 calls (and wait until
155      * the first transaction is mined)
156      * From MonolithDAO Token.sol
157      */
158     function increaseApproval(address _spender, uint _addedValue)
159     returns (bool success) {
160         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 
165     function decreaseApproval(address _spender, uint _subtractedValue)
166     returns (bool success) {
167         uint oldValue = allowed[msg.sender][_spender];
168         if (_subtractedValue > oldValue) {
169             allowed[msg.sender][_spender] = 0;
170         }
171         else {
172             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173         }
174         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175         return true;
176     }
177 
178 }
179 
180 
181 /**
182  * @title Ownable
183  * @dev The Ownable contract has an owner address, and provides basic authorization control
184  * functions, this simplifies the implementation of "user permissions".
185  */
186 contract Ownable {
187     address public owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190     /**
191      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
192      * account.
193      */
194     function Ownable() {
195         owner = msg.sender;
196     }
197 
198     /**
199      * @dev Throws if called by any account other than the owner.
200      */
201     modifier onlyOwner() {
202         require(msg.sender == owner);
203         _;
204     }
205 
206     /**
207      * @dev Allows the current owner to transfer control of the contract to a newOwner.
208      * @param newOwner The address to transfer ownership to.
209      */
210     function transferOwnership(address newOwner) onlyOwner public {
211         require(newOwner != address(0));
212         OwnershipTransferred(owner, newOwner);
213         owner = newOwner;
214     }
215 
216 }
217 
218 /**
219  * @title Pausable
220  * @dev Base contract which allows children to implement an emergency stop mechanism.
221  */
222 contract Pausable is Ownable {
223     event Pause();
224 
225     event Unpause();
226 
227     bool public paused = false;
228 
229 
230     /**
231      * @dev Modifier to make a function callable only when the contract is not paused.
232      */
233     modifier whenNotPaused() {
234         require(!paused);
235         _;
236     }
237 
238     /**
239      * @dev Modifier to make a function callable only when the contract is paused.
240      */
241     modifier whenPaused() {
242         require(paused);
243         _;
244     }
245 
246     /**
247      * @dev called by the owner to pause, triggers stopped state
248      */
249     function pause() onlyOwner whenNotPaused public {
250         paused = true;
251         Pause();
252     }
253 
254     /**
255      * @dev called by the owner to unpause, returns to normal state
256      */
257     function unpause() onlyOwner whenPaused public {
258         paused = false;
259         Unpause();
260     }
261 }
262 
263 /**
264  * @title IRBTokens
265  * @dev IRB Token contract based on Zeppelin StandardToken contract
266  */
267 contract IRBToken is StandardToken, Ownable {
268     using SafeMath for uint256;
269 
270     /**
271      * @dev ERC20 descriptor variables
272      */
273     string public constant name = "IRB Tokens";
274 
275     string public constant symbol = "IRB";
276 
277     uint8 public decimals = 18;
278 
279     /**
280      * @dev 489.58 millions s the initial Token sale
281      */
282     uint256 public constant crowdsaleTokens = 489580 * 10 ** 21;
283 
284     /**
285      * @dev 10.42 millions is the initial Token presale
286      */
287     uint256 public constant preCrowdsaleTokens = 10420 * 10 ** 21;
288 
289     // TODO: TestRPC addresses, replace to real
290     // PRE Crowdsale Tokens Wallet
291     address public constant preCrowdsaleTokensWallet = 0x0CD95a59fAd089c4EBCCEB54f335eC8f61Caa80e;
292     // Crowdsale Tokens Wallet
293     address public constant crowdsaleTokensWallet = 0x48545E41696Dc51020C35cA8C36b678101a98437;
294 
295     /**
296      * @dev Address of PRE Crowdsale contract which will be compared
297      *       against in the appropriate modifier check
298      */
299     address public preCrowdsaleContractAddress;
300 
301     /**
302      * @dev Address of Crowdsale contract which will be compared
303      *       against in the appropriate modifier check
304      */
305     address public crowdsaleContractAddress;
306 
307     /**
308      * @dev variable that holds flag of ended pre tokensake
309      */
310     bool isPreFinished = false;
311 
312     /**
313      * @dev variable that holds flag of ended tokensake
314      */
315     bool isFinished = false;
316 
317     /**
318      * @dev Modifier that allow only the Crowdsale contract to be sender
319      */
320     modifier onlyPreCrowdsaleContract() {
321         require(msg.sender == preCrowdsaleContractAddress);
322         _;
323     }
324 
325     /**
326      * @dev Modifier that allow only the Crowdsale contract to be sender
327      */
328     modifier onlyCrowdsaleContract() {
329         require(msg.sender == crowdsaleContractAddress);
330         _;
331     }
332 
333     /**
334      * @dev event for the burnt tokens after crowdsale logging
335      * @param tokens amount of tokens available for crowdsale
336      */
337     event TokensBurnt(uint256 tokens);
338 
339     /**
340      * @dev event for the tokens contract move to the active state logging
341      * @param supply amount of tokens left after all the unsold was burned
342      */
343     event Live(uint256 supply);
344 
345     /**
346      * @dev Contract constructor
347      */
348     function IRBToken() {
349         // Issue pre crowdsale tokens
350         balances[preCrowdsaleTokensWallet] = balanceOf(preCrowdsaleTokensWallet).add(preCrowdsaleTokens);
351         Transfer(address(0), preCrowdsaleTokensWallet, preCrowdsaleTokens);
352 
353         // Issue crowdsale tokens
354         balances[crowdsaleTokensWallet] = balanceOf(crowdsaleTokensWallet).add(crowdsaleTokens);
355         Transfer(address(0), crowdsaleTokensWallet, crowdsaleTokens);
356 
357         // 500 millions tokens overall
358         totalSupply = crowdsaleTokens.add(preCrowdsaleTokens);
359     }
360 
361     /**
362      * @dev back link IRBToken contract with IRBPreCrowdsale one
363      * @param _preCrowdsaleAddress non zero address of IRBPreCrowdsale contract
364      */
365     function setPreCrowdsaleAddress(address _preCrowdsaleAddress) onlyOwner external {
366         require(_preCrowdsaleAddress != address(0));
367         preCrowdsaleContractAddress = _preCrowdsaleAddress;
368 
369         // Allow pre crowdsale contract
370         uint256 balance = balanceOf(preCrowdsaleTokensWallet);
371         allowed[preCrowdsaleTokensWallet][preCrowdsaleContractAddress] = balance;
372         Approval(preCrowdsaleTokensWallet, preCrowdsaleContractAddress, balance);
373     }
374 
375     /**
376      * @dev back link IRBToken contract with IRBCrowdsale one
377      * @param _crowdsaleAddress non zero address of IRBCrowdsale contract
378      */
379     function setCrowdsaleAddress(address _crowdsaleAddress) onlyOwner external {
380         require(isPreFinished);
381         require(_crowdsaleAddress != address(0));
382         crowdsaleContractAddress = _crowdsaleAddress;
383 
384         // Allow crowdsale contract
385         uint256 balance = balanceOf(crowdsaleTokensWallet);
386         allowed[crowdsaleTokensWallet][crowdsaleContractAddress] = balance;
387         Approval(crowdsaleTokensWallet, crowdsaleContractAddress, balance);
388     }
389 
390     /**
391      * @dev called only by linked IRBPreCrowdsale contract to end precrowdsale.
392      */
393     function endPreTokensale() onlyPreCrowdsaleContract external {
394         require(!isPreFinished);
395         uint256 preCrowdsaleLeftovers = balanceOf(preCrowdsaleTokensWallet);
396 
397         if (preCrowdsaleLeftovers > 0) {
398             balances[preCrowdsaleTokensWallet] = 0;
399             balances[crowdsaleTokensWallet] = balances[crowdsaleTokensWallet].add(preCrowdsaleLeftovers);
400             Transfer(preCrowdsaleTokensWallet, crowdsaleTokensWallet, preCrowdsaleLeftovers);
401         }
402 
403         isPreFinished = true;
404     }
405 
406     /**
407      * @dev called only by linked IRBCrowdsale contract to end crowdsale.
408      */
409     function endTokensale() onlyCrowdsaleContract external {
410         require(!isFinished);
411         uint256 crowdsaleLeftovers = balanceOf(crowdsaleTokensWallet);
412 
413         if (crowdsaleLeftovers > 0) {
414             totalSupply = totalSupply.sub(crowdsaleLeftovers);
415 
416             balances[crowdsaleTokensWallet] = 0;
417             Transfer(crowdsaleTokensWallet, address(0), crowdsaleLeftovers);
418             TokensBurnt(crowdsaleLeftovers);
419         }
420 
421         isFinished = true;
422         Live(totalSupply);
423     }
424 }
425 
426 
427 /**
428  * @title RefundVault.
429  * @dev This contract is used for storing funds while a crowdsale
430  * is in progress. Supports refunding the money if crowdsale fails,
431  * and forwarding it if crowdsale is successful.
432  */
433 contract IRBPreRefundVault is Ownable {
434     using SafeMath for uint256;
435 
436     enum State {Active, Refunding, Closed}
437     State public state;
438 
439     mapping (address => uint256) public deposited;
440 
441     uint256 public totalDeposited;
442 
443     address public constant wallet = 0x26dB9eF39Bbfe437f5b384c3913E807e5633E7cE;
444 
445     address preCrowdsaleContractAddress;
446 
447     event Closed();
448 
449     event RefundsEnabled();
450 
451     event Refunded(address indexed beneficiary, uint256 weiAmount);
452 
453     event Withdrawal(address indexed receiver, uint256 weiAmount);
454 
455     function IRBPreRefundVault() {
456         state = State.Active;
457     }
458 
459     modifier onlyCrowdsaleContract() {
460         require(msg.sender == preCrowdsaleContractAddress);
461         _;
462     }
463 
464     function setPreCrowdsaleAddress(address _preCrowdsaleAddress) external onlyOwner {
465         require(_preCrowdsaleAddress != address(0));
466         preCrowdsaleContractAddress = _preCrowdsaleAddress;
467     }
468 
469     function deposit(address investor) onlyCrowdsaleContract external payable {
470         require(state == State.Active);
471         uint256 amount = msg.value;
472         deposited[investor] = deposited[investor].add(amount);
473         totalDeposited = totalDeposited.add(amount);
474     }
475 
476     function close() onlyCrowdsaleContract external {
477         require(state == State.Active);
478         state = State.Closed;
479         totalDeposited = 0;
480         Closed();
481         wallet.transfer(this.balance);
482     }
483 
484     function enableRefunds() onlyCrowdsaleContract external {
485         require(state == State.Active);
486         state = State.Refunding;
487         RefundsEnabled();
488     }
489 
490     function refund(address investor) public {
491         require(state == State.Refunding);
492         uint256 depositedValue = deposited[investor];
493         deposited[investor] = 0;
494         investor.transfer(depositedValue);
495         Refunded(investor, depositedValue);
496     }
497 
498     /**
499      * @dev withdraw method that can be used by crowdsale contract's owner
500      *      for the withdrawal funds to the owner
501      */
502     function withdraw(uint value) onlyCrowdsaleContract external returns (bool success) {
503         require(state == State.Active);
504         require(totalDeposited >= value);
505         totalDeposited = totalDeposited.sub(value);
506         wallet.transfer(value);
507         Withdrawal(wallet, value);
508         return true;
509     }
510 
511     /**
512      * @dev killer method that can be used by owner to
513      *      kill the contract and send funds to owner
514      */
515     function kill() onlyOwner {
516         require(state == State.Closed);
517         selfdestruct(owner);
518     }
519 }
520 
521 
522 
523 /**
524  * @title IRBPreCrowdsale
525  * @dev IRB pre crowdsale contract borrows Zeppelin Finalized, Capped and Refundable crowdsales implementations
526  */
527 contract IRBPreCrowdsale is Ownable, Pausable {
528     using SafeMath for uint;
529 
530     /**
531      * @dev token contract
532      */
533     IRBToken public token;
534 
535     /**
536      * @dev refund vault used to hold funds while crowdsale is running
537      */
538     IRBPreRefundVault public vault;
539 
540     /**
541      * @dev tokensale(presale) start time: Dec 12, 2017, 11:00:00 + 3
542      */
543     uint startTime = 1513065600;
544 
545     /**
546      * @dev tokensale end time: Jan 14, 2018 23:59:59 +3
547      */
548     uint endTime = 1515963599;
549 
550     /**
551      * @dev minimum purchase amount for presale
552      */
553     uint256 public constant minPresaleAmount = 108 * 10 ** 15; // 400 IRB
554 
555     /**
556      * @dev minimum and maximum amount of funds to be raised in weis
557      */
558     uint256 public constant goal = 1125 * 10 ** 18;  // 1.125 Kether
559     uint256 public constant cap = 2250 * 10 ** 18; // 2.25 Kether
560 
561     /**
562      * @dev amount of raised money in wei
563      */
564     uint256 public weiRaised;
565 
566     /**
567      * @dev tokensale finalization flag
568      */
569     bool public isFinalized = false;
570 
571     /**
572      * @dev event for token purchase logging
573      * @param purchaser who paid for the tokens
574      * @param beneficiary who got the tokens
575      * @param value weis paid for purchase
576      * @param amount amount of tokens purchased
577      */
578     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
579 
580     /**
581      * @dev event for tokensale final logging
582      */
583     event Finalized();
584 
585     /**
586      * @dev Pre Crowdsale in the constructor takes addresses of
587      *      the just deployed IRBToken and IRBPreRefundVault contracts
588      * @param _tokenAddress address of the IRBToken deployed contract
589      * @param _vaultAddress address of the IRBPreRefundVault deployed contract
590      */
591     function IRBPreCrowdsale(address _tokenAddress, address _vaultAddress) {
592         require(_tokenAddress != address(0));
593         require(_vaultAddress != address(0));
594 
595         // IRBToken and IRBPreRefundVault was deployed separately
596         token = IRBToken(_tokenAddress);
597         vault = IRBPreRefundVault(_vaultAddress);
598     }
599 
600     /**
601      * @dev fallback function can be used to buy tokens
602      */
603     function() payable {
604         buyTokens(msg.sender);
605     }
606 
607     /**
608      * @dev main function to buy tokens
609      * @param beneficiary target wallet for tokens can vary from the sender one
610      */
611     function buyTokens(address beneficiary) whenNotPaused public payable {
612         require(beneficiary != address(0));
613         require(validPurchase(msg.value));
614 
615         uint256 weiAmount = msg.value;
616 
617         // buyer and beneficiary could be two different wallets
618         address buyer = msg.sender;
619 
620         // calculate token amount to be created
621         uint256 tokens = convertAmountToTokens(weiAmount);
622 
623         weiRaised = weiRaised.add(weiAmount);
624 
625         if (!token.transferFrom(token.preCrowdsaleTokensWallet(), beneficiary, tokens)) {
626             revert();
627         }
628 
629         TokenPurchase(buyer, beneficiary, weiAmount, tokens);
630 
631         vault.deposit.value(weiAmount)(buyer);
632     }
633 
634     /**
635      * @dev check if the current purchase valid based on time and amount of passed ether
636      * @param _value amount of passed ether
637      * @return true if investors can buy at the moment
638      */
639     function validPurchase(uint256 _value) internal constant returns (bool) {
640         bool nonZeroPurchase = _value != 0;
641         bool withinPeriod = now >= startTime && now <= endTime;
642         bool withinCap = weiRaised.add(_value) <= cap;
643         // For presale we want to decline all payments less then minPresaleAmount
644         bool withinAmount = msg.value >= minPresaleAmount;
645 
646         return nonZeroPurchase && withinPeriod && withinCap && withinAmount;
647     }
648 
649     /**
650      * @dev check if crowdsale still active based on current time and cap
651      * consider minPresaleAmount
652      * @return true if crowdsale event has ended
653      */
654     function hasEnded() public constant returns (bool) {
655         bool capReached = weiRaised.add(minPresaleAmount) >= cap;
656         bool timeIsUp = now > endTime;
657         return timeIsUp || capReached;
658     }
659 
660     /**
661      * @dev if crowdsale is unsuccessful, investors can claim refunds here
662      */
663     function claimRefund() public {
664         require(isFinalized);
665         require(!goalReached());
666 
667         vault.refund(msg.sender);
668     }
669 
670     /**
671      * @dev finalize crowdsale. this method triggers vault and token finalization
672      */
673     function finalize() onlyOwner public {
674         require(!isFinalized);
675         require(hasEnded());
676 
677         // trigger vault and token finalization
678         if (goalReached()) {
679             vault.close();
680         }
681         else {
682             vault.enableRefunds();
683         }
684 
685         token.endPreTokensale();
686 
687         isFinalized = true;
688 
689         Finalized();
690     }
691 
692     /**
693      * @dev check if hard cap goal is reached
694      */
695     function goalReached() public constant returns (bool) {
696         return weiRaised >= goal;
697     }
698 
699     /**
700     * @dev withdraw method that can be used by owner for
701     *      withdraw funds from vault to owner
702     */
703     function withdraw(uint256 amount) onlyOwner public {
704         require(!isFinalized);
705         require(goalReached());
706         require(amount > 0);
707 
708         vault.withdraw(amount);
709     }
710 
711     /**
712      * @dev returns current token price
713      */
714     function convertAmountToTokens(uint256 amount) public constant returns (uint256) {
715         // 1 token = 0.00027 ETH
716         uint256 tokens = amount.div(27).mul(100000);
717         // bonus +25%
718         uint256 bonus = tokens.div(4);
719 
720         return tokens.add(bonus);
721     }
722 
723     /**
724      * @dev killer method that can bu used by owner to
725      *      kill the contract and send funds to owner
726      */
727     function kill() onlyOwner whenPaused {
728         selfdestruct(owner);
729     }
730 }