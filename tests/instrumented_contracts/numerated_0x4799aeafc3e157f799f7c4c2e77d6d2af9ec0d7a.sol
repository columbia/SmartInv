1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 }
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   function totalSupply() public view returns (uint256);
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   uint256 totalSupply_;
123 
124   /**
125   * @dev total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return totalSupply_;
129   }
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[msg.sender]);
139 
140     // SafeMath.sub will throw if there is not enough balance.
141     balances[msg.sender] = balances[msg.sender].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     Transfer(msg.sender, _to, _value);
144     return true;
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of.
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) public view returns (uint256 balance) {
153     return balances[_owner];
154   }
155 
156 }
157 
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is ERC20, BasicToken {
167 
168   mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185     Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191    *
192    * Beware that changing an allowance with this method brings the risk that someone may use both the old
193    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) public returns (bool) {
200     allowed[msg.sender][_spender] = _value;
201     Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param _owner address The address which owns the funds.
208    * @param _spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(address _owner, address _spender) public view returns (uint256) {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _addedValue The amount of tokens to increase the allowance by.
224    */
225   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 
255 /**
256  * @title Mintable token
257  * @dev Simple ERC20 Token example, with mintable token creation
258  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
259  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
260  */
261 contract MintableToken is StandardToken, Ownable {
262   event Mint(address indexed to, uint256 amount);
263   event MintFinished();
264 
265   bool public mintingFinished = false;
266 
267 
268   modifier canMint() {
269     require(!mintingFinished);
270     _;
271   }
272 
273   /**
274    * @dev Function to mint tokens
275    * @param _to The address that will receive the minted tokens.
276    * @param _amount The amount of tokens to mint.
277    * @return A boolean that indicates if the operation was successful.
278    */
279   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
280     totalSupply_ = totalSupply_.add(_amount);
281     balances[_to] = balances[_to].add(_amount);
282     Mint(_to, _amount);
283     Transfer(address(0), _to, _amount);
284     return true;
285   }
286 
287   /**
288    * @dev Function to stop minting new tokens.
289    * @return True if the operation was successful.
290    */
291   function finishMinting() onlyOwner canMint public returns (bool) {
292     mintingFinished = true;
293     MintFinished();
294     return true;
295   }
296 }
297 
298 /**
299  * @title RefundVault
300  * @dev This contract is used for storing funds while a crowdsale
301  * is in progress. Supports refunding the money if crowdsale fails,
302  * and forwarding it if crowdsale is successful.
303  */
304 contract RefundVault is Ownable {
305   using SafeMath for uint256;
306 
307   enum State { Active, Refunding, Closed }
308 
309   mapping (address => uint256) public deposited;
310   address public wallet;
311   State public state;
312 
313   event Closed();
314   event RefundsEnabled();
315   event Refunded(address indexed beneficiary, uint256 weiAmount);
316 
317   function RefundVault(address _wallet) public {
318     require(_wallet != address(0));
319     wallet = _wallet;
320     state = State.Active;
321   }
322 
323   function deposit(address investor) onlyOwner public payable {
324     require(state == State.Active);
325     deposited[investor] = deposited[investor].add(msg.value);
326   }
327 
328   function close() onlyOwner public {
329     require(state == State.Active);
330     state = State.Closed;
331     Closed();
332     wallet.transfer(this.balance);
333   }
334 
335   function enableRefunds() onlyOwner public {
336     require(state == State.Active);
337     state = State.Refunding;
338     RefundsEnabled();
339   }
340 
341   function refund(address investor) public {
342     require(state == State.Refunding);
343     uint256 depositedValue = deposited[investor];
344     deposited[investor] = 0;
345     investor.transfer(depositedValue);
346     Refunded(investor, depositedValue);
347   }
348 }
349 
350 
351 contract MinerOneToken is MintableToken {
352     using SafeMath for uint256;
353 
354     string public name = "MinerOne";
355     string public symbol = "MIO";
356     uint8 public decimals = 18;
357 
358     /**
359      * This struct holds data about token holder dividends
360      */
361     struct Account {
362         /**
363          * Last amount of dividends seen at the token holder payout
364          */
365         uint256 lastDividends;
366         /**
367          * Amount of wei contract needs to pay to token holder
368          */
369         uint256 fixedBalance;
370         /**
371          * Unpayed wei amount due to rounding
372          */
373         uint256 remainder;
374     }
375 
376     /**
377      * Mapping which holds all token holders data
378      */
379     mapping(address => Account) internal accounts;
380 
381     /**
382      * Running total of all dividends distributed
383      */
384     uint256 internal totalDividends;
385     /**
386      * Holds an amount of unpayed weis
387      */
388     uint256 internal reserved;
389 
390     /**
391      * Raised when payment distribution occurs
392      */
393     event Distributed(uint256 amount);
394     /**
395      * Raised when shareholder withdraws his profit
396      */
397     event Paid(address indexed to, uint256 amount);
398     /**
399      * Raised when the contract receives Ether
400      */
401     event FundsReceived(address indexed from, uint256 amount);
402 
403     modifier fixBalance(address _owner) {
404         Account storage account = accounts[_owner];
405         uint256 diff = totalDividends.sub(account.lastDividends);
406         if (diff > 0) {
407             uint256 numerator = account.remainder.add(balances[_owner].mul(diff));
408 
409             account.fixedBalance = account.fixedBalance.add(numerator.div(totalSupply_));
410             account.remainder = numerator % totalSupply_;
411             account.lastDividends = totalDividends;
412         }
413         _;
414     }
415 
416     modifier onlyWhenMintingFinished() {
417         require(mintingFinished);
418         _;
419     }
420 
421     function () external payable {
422         withdraw(msg.sender, msg.value);
423     }
424 
425     function deposit() external payable {
426         require(msg.value > 0);
427         require(msg.value <= this.balance.sub(reserved));
428 
429         totalDividends = totalDividends.add(msg.value);
430         reserved = reserved.add(msg.value);
431         Distributed(msg.value);
432     }
433 
434     /**
435      * Returns unpayed wei for a given address
436      */
437     function getDividends(address _owner) public view returns (uint256) {
438         Account storage account = accounts[_owner];
439         uint256 diff = totalDividends.sub(account.lastDividends);
440         if (diff > 0) {
441             uint256 numerator = account.remainder.add(balances[_owner].mul(diff));
442             return account.fixedBalance.add(numerator.div(totalSupply_));
443         } else {
444             return 0;
445         }
446     }
447 
448     function transfer(address _to, uint256 _value) public
449         onlyWhenMintingFinished
450         fixBalance(msg.sender)
451         fixBalance(_to) returns (bool) {
452         return super.transfer(_to, _value);
453     }
454 
455     function transferFrom(address _from, address _to, uint256 _value) public
456         onlyWhenMintingFinished
457         fixBalance(_from)
458         fixBalance(_to) returns (bool) {
459         return super.transferFrom(_from, _to, _value);
460     }
461 
462     function payoutToAddress(address[] _holders) external {
463         require(_holders.length > 0);
464         require(_holders.length <= 100);
465         for (uint256 i = 0; i < _holders.length; i++) {
466             withdraw(_holders[i], 0);
467         }
468     }
469 
470     /**
471      * Token holder must call this to receive dividends
472      */
473     function withdraw(address _benefeciary, uint256 _toReturn) internal
474         onlyWhenMintingFinished
475         fixBalance(_benefeciary) returns (bool) {
476 
477         uint256 amount = accounts[_benefeciary].fixedBalance;
478         reserved = reserved.sub(amount);
479         accounts[_benefeciary].fixedBalance = 0;
480         uint256 toTransfer = amount.add(_toReturn);
481         if (toTransfer > 0) {
482             _benefeciary.transfer(toTransfer);
483         }
484         if (amount > 0) {
485             Paid(_benefeciary, amount);
486         }
487         return true;
488     }
489 }
490 
491 
492 contract MinerOneCrowdsale is Ownable {
493     using SafeMath for uint256;
494     // Wallet where all ether will be
495     address public constant WALLET = 0x2C2b3885BC8B82Ad4D603D95ED8528Ef112fE8F2;
496     // Wallet for team tokens
497     address public constant TEAM_WALLET = 0x997faEf570B534E5fADc8D2D373e2F11aF4e115a;
498     // Wallet for research and development tokens
499     address public constant RESEARCH_AND_DEVELOPMENT_WALLET = 0x770998331D6775c345B1807c40413861fc4D6421;
500     // Wallet for bounty tokens
501     address public constant BOUNTY_WALLET = 0xd481Aab166B104B1aB12e372Ef7af6F986f4CF19;
502 
503     uint256 public constant UINT256_MAX = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
504     uint256 public constant ICO_TOKENS = 287000000e18;
505     uint8 public constant ICO_TOKENS_PERCENT = 82;
506     uint8 public constant TEAM_TOKENS_PERCENT = 10;
507     uint8 public constant RESEARCH_AND_DEVELOPMENT_TOKENS_PERCENT = 6;
508     uint8 public constant BOUNTY_TOKENS_PERCENT = 2;
509     uint256 public constant SOFT_CAP = 3000000e18;
510     uint256 public constant START_TIME = 1518692400; // 2018/02/15 11:00 UTC +0
511     uint256 public constant RATE = 1000; // 1000 tokens costs 1 ether
512     uint256 public constant LARGE_PURCHASE = 10000e18;
513     uint256 public constant LARGE_PURCHASE_BONUS = 4;
514     uint256 public constant TOKEN_DESK_BONUS = 3;
515     uint256 public constant MIN_TOKEN_AMOUNT = 100e18;
516 
517     Phase[] internal phases;
518 
519     struct Phase {
520         uint256 till;
521         uint8 discount;
522     }
523 
524     // The token being sold
525     MinerOneToken public token;
526     // amount of raised money in wei
527     uint256 public weiRaised;
528     // refund vault used to hold funds while crowdsale is running
529     RefundVault public vault;
530     uint256 public currentPhase = 0;
531     bool public isFinalized = false;
532     address private tokenMinter;
533     address private tokenDeskProxy;
534     uint256 public icoEndTime = 1526558400; // 2018/05/17 12:00 UTC +0
535 
536     /**
537     * event for token purchase logging
538     * @param purchaser who paid for the tokens
539     * @param beneficiary who got the tokens
540     * @param value weis paid for purchase
541     * @param amount amount of tokens purchased
542     */
543     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
544 
545     event Finalized();
546     /**
547     * When there no tokens left to mint and token minter tries to manually mint tokens
548     * this event is raised to signal how many tokens we have to charge back to purchaser
549     */
550     event ManualTokenMintRequiresRefund(address indexed purchaser, uint256 value);
551 
552     function MinerOneCrowdsale(address _token) public {
553         phases.push(Phase({ till: 1519214400, discount: 35 })); // 2018/02/21 12:00 UTC +0
554         phases.push(Phase({ till: 1519905600, discount: 30 })); // 2018/03/01 12:00 UTC +0
555         phases.push(Phase({ till: 1521201600, discount: 25 })); // 2018/03/16 12:00 UTC +0
556         phases.push(Phase({ till: 1522584000, discount: 20 })); // 2018/04/01 12:00 UTC +0
557         phases.push(Phase({ till: 1524312000, discount: 15 })); // 2018/04/21 12:00 UTC +0
558         phases.push(Phase({ till: 1525608000, discount: 10 })); // 2018/05/06 12:00 UTC +0
559         phases.push(Phase({ till: 1526472000, discount: 5  })); // 2018/05/16 12:00 UTC +0
560         phases.push(Phase({ till: UINT256_MAX, discount:0 }));  // unlimited
561 
562         token = MinerOneToken(_token);
563         vault = new RefundVault(WALLET);
564         tokenMinter = msg.sender;
565     }
566 
567     modifier onlyTokenMinterOrOwner() {
568         require(msg.sender == tokenMinter || msg.sender == owner);
569         _;
570     }
571 
572     // fallback function can be used to buy tokens or claim refund
573     function () external payable {
574         if (!isFinalized) {
575             buyTokens(msg.sender, msg.sender);
576         } else {
577             claimRefund();
578         }
579     }
580 
581     function mintTokens(address[] _receivers, uint256[] _amounts) external onlyTokenMinterOrOwner {
582         require(_receivers.length > 0 && _receivers.length <= 100);
583         require(_receivers.length == _amounts.length);
584         require(!isFinalized);
585         for (uint256 i = 0; i < _receivers.length; i++) {
586             address receiver = _receivers[i];
587             uint256 amount = _amounts[i];
588 
589             require(receiver != address(0));
590             require(amount > 0);
591 
592             uint256 excess = appendContribution(receiver, amount);
593 
594             if (excess > 0) {
595                 ManualTokenMintRequiresRefund(receiver, excess);
596             }
597         }
598     }
599 
600     // low level token purchase function
601     function buyTokens(address sender, address beneficiary) public payable {
602         require(beneficiary != address(0));
603         require(sender != address(0));
604         require(validPurchase());
605 
606         uint256 weiReceived = msg.value;
607         uint256 nowTime = getNow();
608         // this loop moves phases and insures correct stage according to date
609         while (currentPhase < phases.length && phases[currentPhase].till < nowTime) {
610             currentPhase = currentPhase.add(1);
611         }
612 
613         // calculate token amount to be created
614         uint256 tokens = calculateTokens(weiReceived);
615 
616         if (tokens < MIN_TOKEN_AMOUNT) revert();
617 
618         uint256 excess = appendContribution(beneficiary, tokens);
619         uint256 refund = (excess > 0 ? excess.mul(weiReceived).div(tokens) : 0);
620 
621         weiReceived = weiReceived.sub(refund);
622         weiRaised = weiRaised.add(weiReceived);
623 
624         if (refund > 0) {
625             sender.transfer(refund);
626         }
627 
628         TokenPurchase(sender, beneficiary, weiReceived, tokens.sub(excess));
629 
630         if (goalReached()) {
631             WALLET.transfer(weiReceived);
632         } else {
633             vault.deposit.value(weiReceived)(sender);
634         }
635     }
636 
637     // if crowdsale is unsuccessful, investors can claim refunds here
638     function claimRefund() public {
639         require(isFinalized);
640         require(!goalReached());
641 
642         vault.refund(msg.sender);
643     }
644 
645     /**
646     * @dev Must be called after crowdsale ends, to do some extra finalization
647     * work. Calls the contract's finalization function.
648     */
649     function finalize() public onlyOwner {
650         require(!isFinalized);
651         require(hasEnded());
652 
653         if (goalReached()) {
654             vault.close();
655 
656             uint256 totalSupply = token.totalSupply();
657 
658             uint256 teamTokens = uint256(TEAM_TOKENS_PERCENT).mul(totalSupply).div(ICO_TOKENS_PERCENT);
659             token.mint(TEAM_WALLET, teamTokens);
660             uint256 rdTokens = uint256(RESEARCH_AND_DEVELOPMENT_TOKENS_PERCENT).mul(totalSupply).div(ICO_TOKENS_PERCENT);
661             token.mint(RESEARCH_AND_DEVELOPMENT_WALLET, rdTokens);
662             uint256 bountyTokens = uint256(BOUNTY_TOKENS_PERCENT).mul(totalSupply).div(ICO_TOKENS_PERCENT);
663             token.mint(BOUNTY_WALLET, bountyTokens);
664 
665             token.finishMinting();
666             token.transferOwnership(token);
667         } else {
668             vault.enableRefunds();
669         }
670 
671         Finalized();
672 
673         isFinalized = true;
674     }
675 
676     // @return true if crowdsale event has ended
677     function hasEnded() public view returns (bool) {
678         return getNow() > icoEndTime || token.totalSupply() == ICO_TOKENS;
679     }
680 
681     function goalReached() public view returns (bool) {
682         return token.totalSupply() >= SOFT_CAP;
683     }
684 
685     function setTokenMinter(address _tokenMinter) public onlyOwner {
686         require(_tokenMinter != address(0));
687         tokenMinter = _tokenMinter;
688     }
689 
690     function setTokenDeskProxy(address _tokekDeskProxy) public onlyOwner {
691         require(_tokekDeskProxy != address(0));
692         tokenDeskProxy = _tokekDeskProxy;
693     }
694 
695     function setIcoEndTime(uint256 _endTime) public onlyOwner {
696         require(_endTime > icoEndTime);
697         icoEndTime = _endTime;
698     }
699 
700     function getNow() internal view returns (uint256) {
701         return now;
702     }
703 
704     function calculateTokens(uint256 _weiAmount) internal view returns (uint256) {
705         uint256 tokens = _weiAmount.mul(RATE).mul(100).div(uint256(100).sub(phases[currentPhase].discount));
706 
707         uint256 bonus = 0;
708         if (currentPhase > 0) {
709             bonus = bonus.add(tokens >= LARGE_PURCHASE ? LARGE_PURCHASE_BONUS : 0);
710             bonus = bonus.add(msg.sender == tokenDeskProxy ? TOKEN_DESK_BONUS : 0);
711         }
712         return tokens.add(tokens.mul(bonus).div(100));
713     }
714 
715     function appendContribution(address _beneficiary, uint256 _tokens) internal returns (uint256) {
716         uint256 excess = 0;
717         uint256 tokensToMint = 0;
718         uint256 totalSupply = token.totalSupply();
719 
720         if (totalSupply.add(_tokens) < ICO_TOKENS) {
721             tokensToMint = _tokens;
722         } else {
723             tokensToMint = ICO_TOKENS.sub(totalSupply);
724             excess = _tokens.sub(tokensToMint);
725         }
726         if (tokensToMint > 0) {
727             token.mint(_beneficiary, tokensToMint);
728         }
729         return excess;
730     }
731 
732     // @return true if the transaction can buy tokens
733     function validPurchase() internal view returns (bool) {
734         bool withinPeriod = getNow() >= START_TIME && getNow() <= icoEndTime;
735         bool nonZeroPurchase = msg.value != 0;
736         bool canMint = token.totalSupply() < ICO_TOKENS;
737         bool validPhase = (currentPhase < phases.length);
738         return withinPeriod && nonZeroPurchase && canMint && validPhase;
739     }
740 }