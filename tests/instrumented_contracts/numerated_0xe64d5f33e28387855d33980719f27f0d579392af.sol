1 //  Copyright (c) 2017, 2018 EtherJack.io. All rights reserved.
2 //  This code is disclosed only to be used for inspection and audit purposes.
3 //  Code modification and use for any purpose other than security audit
4 //  is prohibited. Creation of derived works or unauthorized deployment
5 //  of the code or any its portion to a blockchain is prohibited.
6 
7 pragma solidity ^0.4.19;
8 
9 
10 contract HouseOwned {
11     address house;
12 
13     modifier onlyHouse {
14         require(msg.sender == house);
15         _;
16     }
17 
18     /// @dev Contract constructor
19     function HouseOwned() public {
20         house = msg.sender;
21     }
22 }
23 
24 
25 // SafeMath is a part of Zeppelin Solidity library
26 // licensed under MIT License
27 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/LICENSE
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (a == 0) {
36             return 0;
37         }
38         uint256 c = a * b;
39         assert(c / a == b);
40         return c;
41     }
42 
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         // assert(b > 0); // Solidity automatically throws when dividing by 0
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 }
61 
62 // ----------------------------------------------------------------------------
63 // ERC Token Standard #20 Interface
64 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
65 // ----------------------------------------------------------------------------
66 contract ERC20Interface {
67     function totalSupply() public constant returns (uint);
68     function balanceOf(address _owner) public constant returns (uint balance);
69     function allowance(address _owner, address _spender) public constant returns (uint remaining);
70     function transfer(address _to, uint _value) public returns (bool success);
71     function approve(address _spender, uint _value) public returns (bool success);
72     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
73 
74     event Transfer(address indexed from, address indexed to, uint value);
75     event Approval(address indexed tokenOwner, address indexed spender, uint value);
76 }
77 
78 contract Token is HouseOwned, ERC20Interface {
79     using SafeMath for uint;
80 
81     // Public variables of the token
82     string public name;
83     string public symbol;
84     uint8 public constant decimals = 0;
85     uint256 public supply;
86 
87     // Trusted addresses
88     Jackpot public jackpot;
89     address public croupier;
90 
91     // All users' balances
92     mapping (address => uint256) internal balances;
93     // Users' deposits with Croupier
94     mapping (address => uint256) public depositOf;
95     // Total amount of deposits
96     uint256 public totalDeposit;
97     // Total amount of "Frozen Deposit Pool" -- the tokens for sale at Croupier
98     uint256 public frozenPool;
99     // Allowance mapping
100     mapping (address => mapping (address => uint256)) internal allowed;
101 
102     //////
103     /// @title Modifiers
104     //
105 
106     /// @dev Only Croupier
107     modifier onlyCroupier {
108         require(msg.sender == croupier);
109         _;
110     }
111 
112     /// @dev Only Jackpot
113     modifier onlyJackpot {
114         require(msg.sender == address(jackpot));
115         _;
116     }
117 
118     /// @dev Protection from short address attack
119     modifier onlyPayloadSize(uint size) {
120         assert(msg.data.length == size + 4);
121         _;
122     }
123 
124     //////
125     /// @title Events
126     //
127 
128     /// @dev Fired when a token is burned (bet made)
129     event Burn(address indexed from, uint256 value);
130 
131     /// @dev Fired when a deposit is made or withdrawn
132     ///       direction == 0: deposit
133     ///       direction == 1: withdrawal
134     event Deposit(address indexed from, uint256 value, uint8 direction, uint256 newDeposit);
135 
136     /// @dev Fired when a deposit with Croupier is frozen (set for sale)
137     event DepositFrozen(address indexed from, uint256 value);
138 
139     /// @dev Fired when a deposit with Croupier is unfrozen (removed from sale)
140     //       Value is the resulting deposit, NOT the unfrozen amount
141     event DepositUnfrozen(address indexed from, uint256 value);
142 
143     //////
144     /// @title Constructor and Initialization
145     //
146 
147     /// @dev Initializes contract with initial supply tokens to the creator of the contract
148     function Token() HouseOwned() public {
149         name = "JACK Token";
150         symbol = "JACK";
151         supply = 1000000;
152     }
153 
154     /// @dev Function to set address of Jackpot contract once after creation
155     /// @param _jackpot Address of the Jackpot contract
156     function setJackpot(address _jackpot) onlyHouse public {
157         require(address(jackpot) == 0x0);
158         require(_jackpot != address(this)); // Protection from admin's mistake
159 
160         jackpot = Jackpot(_jackpot);
161 
162         uint256 bountyPortion = supply / 40;           // 2.5% is the bounty portion for marketing expenses
163         balances[house] = bountyPortion;               // House receives the bounty tokens
164         balances[jackpot] = supply - bountyPortion;    // Jackpot gets the rest
165 
166         croupier = jackpot.croupier();
167     }
168 
169     //////
170     /// @title Public Methods
171     //
172 
173 
174     /// @dev Croupier invokes this method to return deposits to players
175     /// @param _to The address of the recipient
176     /// @param _extra Additional off-chain credit (AirDrop support), so that croupier can return more than the user has actually deposited
177     function returnDeposit(address _to, uint256 _extra) onlyCroupier public {
178         require(depositOf[_to] > 0 || _extra > 0);
179         uint256 amount = depositOf[_to];
180         depositOf[_to] = 0;
181         totalDeposit = totalDeposit.sub(amount);
182 
183         _transfer(croupier, _to, amount.add(_extra));
184 
185         Deposit(_to, amount, 1, 0);
186     }
187 
188     /// @dev Gets the balance of the specified address.
189     /// @param _owner The address
190     function balanceOf(address _owner) public view returns (uint256 balance) {
191         return balances[_owner];
192     }
193     
194     function totalSupply() public view returns (uint256) {
195         return supply;
196     }
197 
198     /// @dev Send `_value` tokens to `_to`
199     /// @param _to The address of the recipient
200     /// @param _value the amount to send
201     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
202         require(address(jackpot) != 0x0);
203         require(croupier != 0x0);
204 
205         if (_to == address(jackpot)) {
206             // It is a token bet. Ignoring _value, only using 1 token
207             _burnFromAccount(msg.sender, 1);
208             jackpot.betToken(msg.sender);
209             return true;
210         }
211 
212         if (_to == croupier && msg.sender != house) {
213             // It's a deposit to Croupier. In addition to transferring the token,
214             // mark it in the deposits table
215 
216             // House can't make deposits. If House is transferring something to
217             // Croupier, it's just a transfer, nothing more
218 
219             depositOf[msg.sender] += _value;
220             totalDeposit = totalDeposit.add(_value);
221 
222             Deposit(msg.sender, _value, 0, depositOf[msg.sender]);
223         }
224 
225         // In all cases but Jackpot transfer (which is terminated by a return), actually
226         // do perform the transfer
227         return _transfer(msg.sender, _to, _value);
228     }
229 
230     /// @dev Transfer tokens from one address to another
231     /// @param _from address The address which you want to send tokens from
232     /// @param _to address The address which you want to transfer to
233     /// @param _value uint256 the amount of tokens to be transferred
234     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
235         require(_to != address(0));
236         require(_value <= balances[_from]);
237         require(_value <= allowed[_from][msg.sender]);
238 
239         balances[_from] = balances[_from].sub(_value);
240         balances[_to] = balances[_to].add(_value);
241         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242         Transfer(_from, _to, _value);
243         return true;
244     }
245 
246     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247     /// @param _spender The address which will spend the funds.
248     /// @param _value The amount of tokens to be spent.
249     function approve(address _spender, uint256 _value) public returns (bool) {
250         allowed[msg.sender][_spender] = _value;
251         Approval(msg.sender, _spender, _value);
252         return true;
253     }
254 
255     /// @dev Function to check the amount of tokens that an owner allowed to a spender.
256     /// @param _owner address The address which owns the funds.
257     /// @param _spender address The address which will spend the funds.
258     /// @return A uint256 specifying the amount of tokens still available for the spender.
259     function allowance(address _owner, address _spender) public view returns (uint256) {
260         return allowed[_owner][_spender];
261     }
262 
263     /// @dev Increase the amount of tokens that an owner allowed to a spender.
264     /// @param _spender The address which will spend the funds.
265     /// @param _addedValue The amount of tokens to increase the allowance by.
266     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
267         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
268         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269         return true;
270     }
271 
272     /// @dev Decrease the amount of tokens that an owner allowed to a spender.
273     /// @param _spender The address which will spend the funds.
274     /// @param _subtractedValue The amount of tokens to decrease the allowance by.
275     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
276         uint oldValue = allowed[msg.sender][_spender];
277         if (_subtractedValue > oldValue) {
278             allowed[msg.sender][_spender] = 0;
279         } else {
280             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
281         }
282         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283         return true;
284     }
285 
286     /// @dev Croupier uses this method to set deposited credits of a player for sale
287     /// @param _user The address of the user
288     /// @param _extra Additional off-chain credit (AirDrop support), so that croupier could have frozen more than the user had invested
289     function freezeDeposit(address _user, uint256 _extra) onlyCroupier public {
290         require(depositOf[_user] > 0 || _extra > 0);
291 
292         uint256 deposit = depositOf[_user];
293         depositOf[_user] = depositOf[_user].sub(deposit);
294         totalDeposit = totalDeposit.sub(deposit);
295 
296         uint256 depositWithExtra = deposit.add(_extra);
297 
298         frozenPool = frozenPool.add(depositWithExtra);
299 
300         DepositFrozen(_user, depositWithExtra);
301     }
302 
303     /// @dev Croupier uses this method stop selling user's tokens and return them to normal deposit
304     /// @param _user The user whose deposit is being unfrozen
305     /// @param _value The value to unfreeze according to Croupier's records (off-chain sale data)
306     function unfreezeDeposit(address _user, uint256 _value) onlyCroupier public {
307         require(_value > 0);
308         require(frozenPool >= _value);
309 
310         depositOf[_user] = depositOf[_user].add(_value);
311         totalDeposit = totalDeposit.add(_value);
312 
313         frozenPool = frozenPool.sub(_value);
314 
315         DepositUnfrozen(_user, depositOf[_user]);
316     }
317 
318     /// @dev The Jackpot contract invokes this method when selling tokens from Croupier
319     /// @param _to The recipient of the tokens
320     /// @param _value The amount
321     function transferFromCroupier(address _to, uint256 _value) onlyJackpot public {
322         require(_value > 0);
323         require(frozenPool >= _value);
324 
325         frozenPool = frozenPool.sub(_value);
326 
327         _transfer(croupier, _to, _value);
328     }
329 
330     //////
331     /// @title Internal Methods
332     //
333 
334     /// @dev Internal transfer function
335     /// @param _from From address
336     /// @param _to To address
337     /// @param _value The value to transfer
338     /// @return success
339     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
340         require(_to != address(0));                         // Prevent transfer to 0x0 address
341         require(balances[_from] >= _value);                 // Check if the sender has enough
342         balances[_from] = balances[_from].sub(_value);      // Subtract from the sender
343         balances[_to] = balances[_to].add(_value);          // Add the same to the recipient
344         Transfer(_from, _to, _value);
345         return true;
346     }
347 
348     /// @dev Internal function for burning tokens
349     /// @param _sender The token sender (whose tokens are being burned)
350     /// @param _value The amount of tokens to burn
351     function _burnFromAccount(address _sender, uint256 _value) internal {
352         require(balances[_sender] >= _value);               // Check if the sender has enough
353         balances[_sender] = balances[_sender].sub(_value);  // Subtract from the sender
354         supply = supply.sub(_value);                        // Updates totalSupply
355         Burn(_sender, _value);
356     }
357 
358 }
359 
360 contract Jackpot is HouseOwned {
361     using SafeMath for uint;
362 
363     enum Stages {
364         InitialOffer,   // ICO stage: forming the jackpot fund
365         GameOn,         // The game is running
366         GameOver,       // The jackpot is won, paying out the jackpot
367         Aborted         // ICO aborted, refunding investments
368     }
369 
370     uint256 constant initialIcoTokenPrice = 4 finney;
371     uint256 constant initialBetAmount = 10 finney;
372     uint constant gameStartJackpotThreshold = 333 ether;
373     uint constant icoTerminationTimeout = 48 hours;
374 
375     // These variables hold the values needed for minor prize checking:
376     //  - when they were last won (once the number reaches the corresponding amount, the
377     //    minor prize is won, and it should be reset)
378     //  - how much ether was bet since it was last won
379     // `etherSince*` variables start with value of 1 and always have +1 in their value
380     // so that the variables never go 0, for gas consumption consistency
381     uint32 public totalBets = 0;
382     uint256 public etherSince20 = 1;
383     uint256 public etherSince50 = 1;
384     uint256 public etherSince100 = 1;
385     uint256 public pendingEtherForCroupier = 0;
386 
387     // ICO status
388     uint32 public icoSoldTokens;
389     uint256 public icoEndTime;
390 
391     // Jackpot status
392     address public lastBetUser;
393     uint256 public terminationTime;
394     address public winner;
395     uint256 public pendingJackpotForHouse;
396     uint256 public pendingJackpotForWinner;
397 
398     // General configuration and stage
399     address public croupier;
400     Token public token;
401     Stages public stage = Stages.InitialOffer;
402 
403     // Price state
404     uint256 public currentIcoTokenPrice = initialIcoTokenPrice;
405     uint256 public currentBetAmount = initialBetAmount;
406 
407     // Investment tracking for emergency ICO termination
408     mapping (address => uint256) public investmentOf;
409     uint256 public abortTime;
410 
411     //////
412     /// @title Modifiers
413     //
414 
415     /// @dev Only Token
416     modifier onlyToken {
417         require(msg.sender == address(token));
418         _;
419     }
420 
421     /// @dev Only Croupier
422     modifier onlyCroupier {
423         require(msg.sender == address(croupier));
424         _;
425     }
426 
427     //////
428     /// @title Events
429     //
430 
431     /// @dev Fired when tokens are sold for Ether in ICO
432     event EtherIco(address indexed from, uint256 value, uint256 tokens);
433 
434     /// @dev Fired when a bid with Ether is made
435     event EtherBet(address indexed from, uint256 value, uint256 dividends);
436 
437     /// @dev Fired when a bid with a Token is made
438     event TokenBet(address indexed from);
439 
440     /// @dev Fired when a bidder wins a minor prize
441     ///      Type: 1: 20, 2: 50, 3: 100
442     event MinorPrizePayout(address indexed from, uint256 value, uint8 prizeType);
443 
444     /// @dev Fired when as a result of ether bid, tokens are sold from the Croupier's pool
445     ///      The parameters are who bought them, how many tokens, and for how much Ether they were sold
446     event SoldTokensFromCroupier(address indexed from, uint256 value, uint256 tokens);
447 
448     /// @dev Fired when the jackpot is won
449     event JackpotWon(address indexed from, uint256 value);
450 
451 
452     //////
453     /// @title Constructor and Initialization
454     //
455 
456     /// @dev The contract constructor
457     /// @param _croupier The address of the trusted Croupier bot's account
458     function Jackpot(address _croupier)
459         HouseOwned()
460         public
461     {
462         require(_croupier != 0x0);
463         croupier = _croupier;
464 
465         // There are no bets (it even starts in ICO stage), so initialize
466         // lastBetUser, just so that value is not zero and is meaningful
467         // The game can't end until at least one bid is made, and once
468         // a bid is made, this value is permanently overwritten.
469         lastBetUser = _croupier;
470     }
471 
472     /// @dev Function to set address of Token contract once after creation
473     /// @param _token Address of the Token contract (JACK Token)
474     function setToken(address _token) onlyHouse public {
475         require(address(token) == 0x0);
476         require(_token != address(this)); // Protection from admin's mistake
477 
478         token = Token(_token);
479     }
480 
481 
482     //////
483     /// @title Default Function
484     //
485 
486     /// @dev The fallback function for receiving ether (bets)
487     ///      Action depends on stages:
488     ///       - ICO: just sell the tokens
489     ///       - Game: accept bets, award tokens, award minor (20, 50, 100) prizes
490     ///       - Game Over: pay out jackpot
491     ///       - Aborted: fail
492     function() payable public {
493         require(croupier != 0x0);
494         require(address(token) != 0x0);
495         require(stage != Stages.Aborted);
496 
497         uint256 tokens;
498 
499         if (stage == Stages.InitialOffer) {
500 
501             // First, check if the ICO is over. If it is, trigger the events and
502             // refund sent ether
503             bool started = checkGameStart();
504             if (started) {
505                 // Refund ether without failing the transaction
506                 // (because side-effect is needed)
507                 msg.sender.transfer(msg.value);
508                 return;
509             }
510 
511             require(msg.value >= currentIcoTokenPrice);
512         
513             // THE PLAN
514             // 1. [CHECK + EFFECT] Calculate how much times price, the investment amount is,
515             //    calculate how many tokens the investor is going to get
516             // 2. [EFFECT] Log and count
517             // 3. [EFFECT] Check game start conditions and maybe start the game
518             // 4. [INT] Award the tokens
519             // 5. [INT] Transfer 20% to house
520 
521             // 1. [CHECK + EFFECT] Checking the amount
522             tokens = _icoTokensForEther(msg.value);
523 
524             // 2. [EFFECT] Log
525             // Log the ICO event and count investment
526             EtherIco(msg.sender, msg.value, tokens);
527 
528             investmentOf[msg.sender] = investmentOf[msg.sender].add(
529                 msg.value.sub(msg.value / 5)
530             );
531 
532             // 3. [EFFECT] Game start
533             // Check if we have accumulated the jackpot amount required for game start
534             if (icoEndTime == 0 && this.balance >= gameStartJackpotThreshold) {
535                 icoEndTime = now + icoTerminationTimeout;
536             }
537 
538             // 4. [INT] Awarding tokens
539             // Award the deserved tokens (if any)
540             if (tokens > 0) {
541                 token.transfer(msg.sender, tokens);
542             }
543 
544             // 5. [INT] House
545             // House gets 20% of ICO according to the rules
546             house.transfer(msg.value / 5);
547 
548         } else if (stage == Stages.GameOn) {
549 
550             // First, check if the game is over. If it is, trigger the events and
551             // refund sent ether
552             bool terminated = checkTermination();
553             if (terminated) {
554                 // Refund ether without failing the transaction
555                 // (because side-effect is needed)
556                 msg.sender.transfer(msg.value);
557                 return;
558             }
559 
560             // Now processing an Ether bid
561             require(msg.value >= currentBetAmount);
562 
563             // THE PLAN
564             // 1. [CHECK] Calculate how much times min-bet, the bet amount is,
565             //    calculate how many tokens the player is going to get
566             // 2. [CHECK] Check how much is sold from the Croupier's pool, and how much from Jackpot
567             // 3. [EFFECT] Deposit 25% to the Croupier (for dividends and house's benefit)
568             // 4. [EFFECT] Log and mark bid
569             // 6. [INT] Check and reward (if won) minor (20, 100, 1000) prizes
570             // 7. [EFFECT] Update bet amount
571             // 8. [INT] Award the tokens
572 
573 
574             // 1. [CHECK + EFFECT] Checking the bet amount and token reward
575             tokens = _betTokensForEther(msg.value);
576 
577             // 2. [CHECK] Check how much is sold from the Croupier's pool, and how much from Jackpot
578             //    The priority is (1) Croupier, (2) Jackpot
579             uint256 sellingFromJackpot = 0;
580             uint256 sellingFromCroupier = 0;
581             if (tokens > 0) {
582                 uint256 croupierPool = token.frozenPool();
583                 uint256 jackpotPool = token.balanceOf(this);
584 
585                 if (croupierPool == 0) {
586                     // Simple case: only Jackpot is selling
587                     sellingFromJackpot = tokens;
588                     if (sellingFromJackpot > jackpotPool) {
589                         sellingFromJackpot = jackpotPool;
590                     }
591                 } else if (jackpotPool == 0 || tokens <= croupierPool) {
592                     // Simple case: only Croupier is selling
593                     // either because Jackpot has 0, or because Croupier takes over
594                     // by priority and has enough tokens in its pool
595                     sellingFromCroupier = tokens;
596                     if (sellingFromCroupier > croupierPool) {
597                         sellingFromCroupier = croupierPool;
598                     }
599                 } else {
600                     // Complex case: both are selling now
601                     sellingFromCroupier = croupierPool;  // (tokens > croupierPool) is guaranteed at this point
602                     sellingFromJackpot = tokens.sub(sellingFromCroupier);
603                     if (sellingFromJackpot > jackpotPool) {
604                         sellingFromJackpot = jackpotPool;
605                     }
606                 }
607             }
608 
609             // 3. [EFFECT] Croupier deposit
610             // Transfer a portion to the Croupier for dividend payout and house benefit
611             // Dividends are a sum of:
612             //   + 25% of bet
613             //   + 50% of price of tokens sold from Jackpot (or just anything other than the bet and Croupier payment)
614             //   + 0%  of price of tokens sold from Croupier
615             //          (that goes in SoldTokensFromCroupier instead)
616             uint256 tokenValue = msg.value.sub(currentBetAmount);
617 
618             uint256 croupierSaleRevenue = 0;
619             if (sellingFromCroupier > 0) {
620                 croupierSaleRevenue = tokenValue.div(
621                     sellingFromJackpot.add(sellingFromCroupier)
622                 ).mul(sellingFromCroupier);
623             }
624             uint256 jackpotSaleRevenue = tokenValue.sub(croupierSaleRevenue);
625 
626             uint256 dividends = (currentBetAmount.div(4)).add(jackpotSaleRevenue.div(2));
627 
628             // 100% of money for selling from Croupier still goes to Croupier
629             // so that it's later paid out to the selling user
630             pendingEtherForCroupier = pendingEtherForCroupier.add(dividends.add(croupierSaleRevenue));
631 
632             // 4. [EFFECT] Log and mark bid
633             // Log the bet with actual amount charged (value less change)
634             EtherBet(msg.sender, msg.value, dividends);
635             lastBetUser = msg.sender;
636             terminationTime = now + _terminationDuration();
637 
638             // If anything was sold from Croupier, log it appropriately
639             if (croupierSaleRevenue > 0) {
640                 SoldTokensFromCroupier(msg.sender, croupierSaleRevenue, sellingFromCroupier);
641             }
642 
643             // 5. [INT] Minor prizes
644             // Check for winning minor prizes
645             _checkMinorPrizes(msg.sender, currentBetAmount);
646 
647             // 6. [EFFECT] Update bet amount
648             _updateBetAmount();
649 
650             // 7. [INT] Awarding tokens
651             if (sellingFromJackpot > 0) {
652                 token.transfer(msg.sender, sellingFromJackpot);
653             }
654             if (sellingFromCroupier > 0) {
655                 token.transferFromCroupier(msg.sender, sellingFromCroupier);
656             }
657 
658         } else if (stage == Stages.GameOver) {
659 
660             require(msg.sender == winner || msg.sender == house);
661 
662             if (msg.sender == winner) {
663                 require(pendingJackpotForWinner > 0);
664 
665                 uint256 winnersPay = pendingJackpotForWinner;
666                 pendingJackpotForWinner = 0;
667 
668                 msg.sender.transfer(winnersPay);
669             } else if (msg.sender == house) {
670                 require(pendingJackpotForHouse > 0);
671 
672                 uint256 housePay = pendingJackpotForHouse;
673                 pendingJackpotForHouse = 0;
674 
675                 msg.sender.transfer(housePay);
676             }
677         }
678     }
679 
680     // Croupier will call this function when the jackpot is won
681     // If Croupier fails to call the function for any reason, house and winner
682     // still can claim their jackpot portion by sending ether to Jackpot
683     function payOutJackpot() onlyCroupier public {
684         require(winner != 0x0);
685     
686         if (pendingJackpotForHouse > 0) {
687             uint256 housePay = pendingJackpotForHouse;
688             pendingJackpotForHouse = 0;
689 
690             house.transfer(housePay);
691         }
692 
693         if (pendingJackpotForWinner > 0) {
694             uint256 winnersPay = pendingJackpotForWinner;
695             pendingJackpotForWinner = 0;
696 
697             winner.transfer(winnersPay);
698         }
699 
700     }
701 
702     //////
703     /// @title Public Functions
704     //
705 
706     /// @dev View function to check whether the game should be terminated
707     ///      Used as internal function by checkTermination, as well as by the
708     ///      Croupier bot, to check whether it should call checkTermination
709     /// @return Whether the game should be terminated by timeout
710     function shouldBeTerminated() public view returns (bool should) {
711         return stage == Stages.GameOn && terminationTime != 0 && now > terminationTime;
712     }
713 
714     /// @dev Check whether the game should be terminated, and if it should, terminate it
715     /// @return Whether the game was terminated as the result
716     function checkTermination() public returns (bool terminated) {
717         if (shouldBeTerminated()) {
718             stage = Stages.GameOver;
719 
720             winner = lastBetUser;
721 
722             // Flush amount due for Croupier immediately
723             _flushEtherToCroupier();
724 
725             // The rest should be claimed by the winner (except what house gets)
726             JackpotWon(winner, this.balance);
727 
728 
729             uint256 jackpot = this.balance;
730             pendingJackpotForHouse = jackpot.div(5);
731             pendingJackpotForWinner = jackpot.sub(pendingJackpotForHouse);
732 
733             return true;
734         }
735 
736         return false;
737     }
738 
739     /// @dev View function to check whether the game should be started
740     ///      Used as internal function by `checkGameStart`, as well as by the
741     ///      Croupier bot, to check whether it should call `checkGameStart`
742     /// @return Whether the game should be started
743     function shouldBeStarted() public view returns (bool should) {
744         return stage == Stages.InitialOffer && icoEndTime != 0 && now > icoEndTime;
745     }
746 
747     /// @dev Check whether the game should be started, and if it should, start it
748     /// @return Whether the game was started as the result
749     function checkGameStart() public returns (bool started) {
750         if (shouldBeStarted()) {
751             stage = Stages.GameOn;
752 
753             return true;
754         }
755 
756         return false;
757     }
758 
759     /// @dev Bet 1 token in the game
760     ///      The token has already been burned having passed all checks, so
761     ///      just process the bet of 1 token
762     function betToken(address _user) onlyToken public {
763         // Token bets can only be accepted in the game stage
764         require(stage == Stages.GameOn);
765 
766         bool terminated = checkTermination();
767         if (terminated) {
768             return;
769         }
770 
771         TokenBet(_user);
772         lastBetUser = _user;
773         terminationTime = now + _terminationDuration();
774 
775         // Check for winning minor prizes
776         _checkMinorPrizes(_user, 0);
777     }
778 
779     /// @dev Allows House to terminate ICO as an emergency measure
780     function abort() onlyHouse public {
781         require(stage == Stages.InitialOffer);
782 
783         stage = Stages.Aborted;
784         abortTime = now;
785     }
786 
787     /// @dev In case the ICO is emergency-terminated by House, allows investors
788     ///      to pull back the investments
789     function claimRefund() public {
790         require(stage == Stages.Aborted);
791         require(investmentOf[msg.sender] > 0);
792 
793         uint256 payment = investmentOf[msg.sender];
794         investmentOf[msg.sender] = 0;
795 
796         msg.sender.transfer(payment);
797     }
798 
799     /// @dev In case the ICO was terminated, allows House to kill the contract in 2 months
800     ///      after the termination date
801     function killAborted() onlyHouse public {
802         require(stage == Stages.Aborted);
803         require(now > abortTime + 60 days);
804 
805         selfdestruct(house);
806     }
807 
808 
809 
810     //////
811     /// @title Internal Functions
812     //
813 
814     /// @dev Get current bid timer duration
815     /// @return duration The duration
816     function _terminationDuration() internal view returns (uint256 duration) {
817         return (5 + 19200 / (100 + totalBets)) * 1 minutes;
818     }
819 
820     /// @dev Updates the current ICO price according to the rules
821     function _updateIcoPrice() internal {
822         uint256 newIcoTokenPrice = currentIcoTokenPrice;
823 
824         if (icoSoldTokens < 10000) {
825             newIcoTokenPrice = 4 finney;
826         } else if (icoSoldTokens < 20000) {
827             newIcoTokenPrice = 5 finney;
828         } else if (icoSoldTokens < 30000) {
829             newIcoTokenPrice = 5.3 finney;
830         } else if (icoSoldTokens < 40000) {
831             newIcoTokenPrice = 5.7 finney;
832         } else {
833             newIcoTokenPrice = 6 finney;
834         }
835 
836         if (newIcoTokenPrice != currentIcoTokenPrice) {
837             currentIcoTokenPrice = newIcoTokenPrice;
838         }
839     }
840 
841     /// @dev Updates the current bid price according to the rules
842     function _updateBetAmount() internal {
843         uint256 newBetAmount = 10 finney + (totalBets / 100) * 6 finney;
844 
845         if (newBetAmount != currentBetAmount) {
846             currentBetAmount = newBetAmount;
847         }
848     }
849 
850     /// @dev Calculates how many tokens a user should get with a given Ether bid
851     /// @param value The bid amount
852     /// @return tokens The number of tokens
853     function _betTokensForEther(uint256 value) internal view returns (uint256 tokens) {
854         // One bet amount is for the bet itself, for the rest we will sell
855         // tokens
856         tokens = (value / currentBetAmount) - 1;
857 
858         if (tokens >= 1000) {
859             tokens = tokens + tokens / 4; // +25%
860         } else if (tokens >= 300) {
861             tokens = tokens + tokens / 5; // +20%
862         } else if (tokens >= 100) {
863             tokens = tokens + tokens / 7; // ~ +14.3%
864         } else if (tokens >= 50) {
865             tokens = tokens + tokens / 10; // +10%
866         } else if (tokens >= 20) {
867             tokens = tokens + tokens / 20; // +5%
868         }
869     }
870 
871     /// @dev Calculates how many tokens a user should get with a given ICO transfer
872     /// @param value The transfer amount
873     /// @return tokens The number of tokens
874     function _icoTokensForEther(uint256 value) internal returns (uint256 tokens) {
875         // How many times the input is greater than current token price
876         tokens = value / currentIcoTokenPrice;
877 
878         if (tokens >= 10000) {
879             tokens = tokens + tokens / 4; // +25%
880         } else if (tokens >= 5000) {
881             tokens = tokens + tokens / 5; // +20%
882         } else if (tokens >= 1000) {
883             tokens = tokens + tokens / 7; // ~ +14.3%
884         } else if (tokens >= 500) {
885             tokens = tokens + tokens / 10; // +10%
886         } else if (tokens >= 200) {
887             tokens = tokens + tokens / 20; // +5%
888         }
889 
890         // Checking if Jackpot has the tokens in reserve
891         if (tokens > token.balanceOf(this)) {
892             tokens = token.balanceOf(this);
893         }
894 
895         icoSoldTokens += (uint32)(tokens);
896 
897         _updateIcoPrice();
898     }
899 
900     /// @dev Flush the currently pending Ether to Croupier
901     function _flushEtherToCroupier() internal {
902         if (pendingEtherForCroupier > 0) {
903             uint256 willTransfer = pendingEtherForCroupier;
904             pendingEtherForCroupier = 0;
905             
906             croupier.transfer(willTransfer);
907         }
908     }
909 
910     /// @dev Count the bid towards minor prize fund, check if the user
911     ///      wins a minor prize, and if they did, transfer the prize to them
912     /// @param user The user in question
913     /// @param value The bid value
914     function _checkMinorPrizes(address user, uint256 value) internal {
915         // First and foremost, increment the counters and ether counters
916         totalBets ++;
917         if (value > 0) {
918             etherSince20 = etherSince20.add(value);
919             etherSince50 = etherSince50.add(value);
920             etherSince100 = etherSince100.add(value);
921         }
922 
923         // Now actually check if the bets won
924 
925         uint256 etherPayout;
926 
927         if ((totalBets + 30) % 100 == 0) {
928             // Won 100th
929             etherPayout = (etherSince100 - 1) / 10;
930             etherSince100 = 1;
931 
932             MinorPrizePayout(user, etherPayout, 3);
933 
934             user.transfer(etherPayout);
935             return;
936         }
937 
938         if ((totalBets + 5) % 50 == 0) {
939             // Won 100th
940             etherPayout = (etherSince50 - 1) / 10;
941             etherSince50 = 1;
942 
943             MinorPrizePayout(user, etherPayout, 2);
944 
945             user.transfer(etherPayout);
946             return;
947         }
948 
949         if (totalBets % 20 == 0) {
950             // Won 20th
951             etherPayout = (etherSince20 - 1) / 10;
952             etherSince20 = 1;
953 
954             _flushEtherToCroupier();
955 
956             MinorPrizePayout(user, etherPayout, 1);
957 
958             user.transfer(etherPayout);
959             return;
960         }
961 
962         return;
963     }
964 
965 }