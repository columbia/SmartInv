1 pragma solidity ^0.4.13;
2 
3 
4  /// @title SafeMath contract - math operations with safety checks
5 contract SafeMath {
6   function safeMul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function safeDiv(uint a, uint b) internal returns (uint) {
13     assert(b > 0);
14     uint c = a / b;
15     assert(a == b * c + a % b);
16     return c;
17   }
18 
19   function safeSub(uint a, uint b) internal returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function safeAdd(uint a, uint b) internal returns (uint) {
25     uint c = a + b;
26     assert(c>=a && c>=b);
27     return c;
28   }
29 
30   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a >= b ? a : b;
32   }
33 
34   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a < b ? a : b;
36   }
37 
38   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a >= b ? a : b;
40   }
41 
42   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a < b ? a : b;
44   }
45 
46  
47 }
48 
49 
50 
51  /// @title Ownable contract - base contract with an owner
52 contract Ownable {
53   address public owner;
54 
55   function Ownable() {
56     owner = msg.sender;
57   }
58 
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 }
70 
71 
72 /// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.
73 /// Originally envisioned in FirstBlood ICO contract.
74 contract Haltable is Ownable {
75   bool public halted;
76 
77   modifier stopInEmergency {
78     require(!halted);
79     _;
80   }
81 
82   modifier onlyInEmergency {
83     require(halted);
84     _;
85   }
86 
87   /// called by the owner on emergency, triggers stopped state
88   function halt() external onlyOwner {
89     halted = true;
90   }
91 
92   /// called by the owner on end of emergency, returns to normal state
93   function unhalt() external onlyOwner onlyInEmergency {
94     halted = false;
95   }
96 }
97 
98 
99 
100 
101  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
102 contract ERC20 {
103   uint public totalSupply;
104   function balanceOf(address who) constant returns (uint);
105   function allowance(address owner, address spender) constant returns (uint);
106   function mint(address receiver, uint amount);
107   function transfer(address to, uint value) returns (bool ok);
108   function transferFrom(address from, address to, uint value) returns (bool ok);
109   function approve(address spender, uint value) returns (bool ok);
110   event Transfer(address indexed from, address indexed to, uint value);
111   event Approval(address indexed owner, address indexed spender, uint value);
112 }
113 
114 
115 
116 /// @title SolarDaoToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
117 contract SolarDaoToken is SafeMath, ERC20, Ownable {
118  string public name = "Solar DAO Token";
119  string public symbol = "SDAO";
120  uint public decimals = 4;
121 
122  /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
123  address public crowdsaleAgent;
124  /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
125  bool public released = false;
126  /// approve() allowances
127  mapping (address => mapping (address => uint)) allowed;
128  /// holder balances
129  mapping(address => uint) balances;
130 
131  /// @dev Limit token transfer until the crowdsale is over.
132  modifier canTransfer() {
133    if(!released) {
134        require(msg.sender == crowdsaleAgent);
135    }
136    _;
137  }
138 
139  /// @dev The function can be called only before or after the tokens have been releasesd
140  /// @param _released token transfer and mint state
141  modifier inReleaseState(bool _released) {
142    require(_released == released);
143    _;
144  }
145 
146  /// @dev The function can be called only by release agent.
147  modifier onlyCrowdsaleAgent() {
148    require(msg.sender == crowdsaleAgent);
149    _;
150  }
151 
152  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
153  /// @param size payload size
154  modifier onlyPayloadSize(uint size) {
155     require(msg.data.length >= size + 4);
156     _;
157  }
158 
159  /// @dev Make sure we are not done yet.
160  modifier canMint() {
161     require(!released);
162     _;
163   }
164 
165  /// @dev Constructor
166  function SolarDaoToken() {
167    owner = msg.sender;
168  }
169 
170  /// Fallback method will buyout tokens
171  function() payable {
172    revert();
173  }
174 
175  /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
176  /// @param receiver Address of receiver
177  /// @param amount  Number of tokens to issue.
178  function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {
179     totalSupply = safeAdd(totalSupply, amount);
180     balances[receiver] = safeAdd(balances[receiver], amount);
181     Transfer(0, receiver, amount);
182  }
183 
184  /// @dev Set the contract that can call release and make the token transferable.
185  /// @param _crowdsaleAgent crowdsale contract address
186  function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
187    crowdsaleAgent = _crowdsaleAgent;
188  }
189  /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
190  function releaseTokenTransfer() public onlyCrowdsaleAgent {
191    released = true;
192  }
193  /// @dev Tranfer tokens to address
194  /// @param _to dest address
195  /// @param _value tokens amount
196  /// @return transfer result
197  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
198    balances[msg.sender] = safeSub(balances[msg.sender], _value);
199    balances[_to] = safeAdd(balances[_to], _value);
200 
201    Transfer(msg.sender, _to, _value);
202    return true;
203  }
204 
205  /// @dev Tranfer tokens from one address to other
206  /// @param _from source address
207  /// @param _to dest address
208  /// @param _value tokens amount
209  /// @return transfer result
210  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
211    var _allowance = allowed[_from][msg.sender];
212 
213     balances[_to] = safeAdd(balances[_to], _value);
214     balances[_from] = safeSub(balances[_from], _value);
215     allowed[_from][msg.sender] = safeSub(_allowance, _value);
216     Transfer(_from, _to, _value);
217     return true;
218  }
219  /// @dev Tokens balance
220  /// @param _owner holder address
221  /// @return balance amount
222  function balanceOf(address _owner) constant returns (uint balance) {
223    return balances[_owner];
224  }
225 
226  /// @dev Approve transfer
227  /// @param _spender holder address
228  /// @param _value tokens amount
229  /// @return result
230  function approve(address _spender, uint _value) returns (bool success) {
231    // To change the approve amount you first have to reduce the addresses`
232    //  allowance to zero by calling `approve(_spender, 0)` if it is not
233    //  already 0 to mitigate the race condition described here:
234    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
236 
237    allowed[msg.sender][_spender] = _value;
238    Approval(msg.sender, _spender, _value);
239    return true;
240  }
241 
242  /// @dev Token allowance
243  /// @param _owner holder address
244  /// @param _spender spender address
245  /// @return remain amount
246  function allowance(address _owner, address _spender) constant returns (uint remaining) {
247    return allowed[_owner][_spender];
248  }
249 }
250 /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
251 contract Killable is Ownable {
252  function kill() onlyOwner {
253    selfdestruct(owner);
254  }
255 }
256 
257 
258 /// @title SolarDaoTokenCrowdsale contract - contract for token sales.
259 contract SolarDaoTokenCrowdsale is Haltable, Killable, SafeMath {
260 
261   /// Prefunding goal in USD cents, if the prefunding goal is reached, ico will start
262   uint public constant PRE_FUNDING_GOAL = 4e6 * PRICE;
263 
264   /// Tokens funding goal in USD cents, if the funding goal is reached, ico will stop
265   uint public constant ICO_GOAL = 8e7 * PRICE;
266 
267   /// Miminal tokens funding goal in USD cents, if this goal isn't reached during ICO, refund will begin
268   uint public constant MIN_ICO_GOAL = 1e7;
269 
270   /// Miminal investment value
271   uint public constant MIN_INVESTMENT = 5 ether;
272 
273   /// Percent of bonus tokens team receives from each investment
274   uint public constant TEAM_BONUS_PERCENT = 25;
275 
276   /// The token price in USD cents
277   uint constant public PRICE = 100;
278 
279   /// The token we are selling
280   SolarDaoToken public token;
281 
282   /// tokens will be transfered from this address
283   address public multisigWallet;
284 
285   /// the UNIX timestamp start date of the crowdsale
286   uint public startsAt;
287 
288   /// the UNIX timestamp end date of the crowdsale
289   uint public endsAt;
290 
291   /// the UNIX timestamp start date of the pre invest crowdsale
292   uint public preInvestStart;
293 
294   /// the number of tokens already sold through this contract
295   uint public tokensSold = 0;
296 
297   /// How many wei of funding we have raised
298   uint public weiRaised = 0;
299 
300   /// How many distinct addresses have invested
301   uint public investorCount = 0;
302 
303   /// How much wei we have returned back to the contract after a failed crowdfund.
304   uint public loadedRefund = 0;
305 
306   /// How much wei we have given back to investors.
307   uint public weiRefunded = 0;
308 
309   /// Has this crowdsale been finalized
310   bool public finalized;
311 
312   /// USD to Ether rate in cents
313   uint public exchangeRate;
314 
315   /// exchangeRate timestamp
316   uint public exchangeRateTimestamp;
317 
318   /// External agent that will can change exchange rate
319   address public exchangeRateAgent;
320 
321   /// How much ETH each address has invested to this crowdsale
322   mapping (address => uint256) public investedAmountOf;
323 
324   /// How much tokens this crowdsale has credited for each investor address
325   mapping (address => uint256) public tokenAmountOf;
326 
327   /// Define preICO pricing schedule using milestones.
328   struct Milestone {
329       // UNIX timestamp when this milestone kicks in
330       uint start;
331       // UNIX timestamp when this milestone kicks out
332       uint end;
333       // How many % tokens will add
334       uint bonus;
335   }
336 
337   Milestone[] public milestones;
338 
339   /// State machine
340   /// Preparing: All contract initialization calls and variables have not been set yet
341   /// Prefunding: We have not passed start time yet
342   /// Funding: Active crowdsale
343   /// Success: Minimum funding goal reached
344   /// Failure: Minimum funding goal not reached before ending time
345   /// Finalized: The finalized has been called and succesfully executed\
346   /// Refunding: Refunds are loaded on the contract for reclaim.
347   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
348 
349   /// A new investment was made
350   event Invested(address investor, uint weiAmount, uint tokenAmount);
351   /// Refund was processed for a contributor
352   event Refund(address investor, uint weiAmount);
353   /// Crowdsale end time has been changed
354   //event EndsAtChanged(uint endsAt);
355   /// Calculated new price
356   event ExchangeRateChanged(uint oldValue, uint newValue);
357 
358   /// @dev Modified allowing execution only if the crowdsale is currently running
359   modifier inState(State state) {
360     require(getState() == state);
361     _;
362   }
363 
364   modifier onlyExchangeRateAgent() {
365     require(msg.sender == exchangeRateAgent);
366     _;
367   }
368 
369   /// @dev Constructor
370   /// @param _token Solar Dao token address
371   /// @param _multisigWallet team wallet
372   /// @param _preInvestStart preICO start date
373   /// @param _start token ICO start date
374   /// @param _end token ICO end date
375   function SolarDaoTokenCrowdsale(address _token, address _multisigWallet, uint _preInvestStart, uint _start, uint _end) {
376     require(_multisigWallet != 0);
377     require(_preInvestStart != 0);
378     require(_start != 0);
379     require(_end != 0);
380     require(_start < _end);
381     require(_end >  1514419199);
382 
383     token = SolarDaoToken(_token);
384 
385     multisigWallet = _multisigWallet;
386     startsAt = _start;
387     endsAt = _end;
388     preInvestStart = _preInvestStart;
389 
390     milestones.push(Milestone(preInvestStart, 1514419199, 40));
391 
392     var icoBonuses = [uint(15), 10, 5];
393     for (uint i = 1; i <= icoBonuses.length; i++) {
394       milestones.push(Milestone(startsAt + i * 1 weeks, startsAt + (i + 1) * 1 weeks, icoBonuses[i - 1]));
395     }
396     delete icoBonuses;
397   }
398 
399   function() payable {
400     buy();
401   }
402 
403   /// @dev Get the current milestone or bail out if we are not in the milestone periods.
404   /// @return Milestone current bonus milestone
405   function getCurrentMilestone() private constant returns (Milestone) {
406       for (uint i = 0; i < milestones.length; i++) {
407         if (milestones[i].start <= now && milestones[i].end > now) {
408           return milestones[i];
409         }
410       }
411   }
412 
413    /// @dev Make an investment. Crowdsale must be running for one to invest.
414    /// @param receiver The Ethereum address who receives the tokens
415   function investInternal(address receiver) stopInEmergency private {
416     var state = getState();
417     require(state == State.Funding || state == State.PreFunding);
418     require(msg.value >= MIN_INVESTMENT);
419 
420     uint weiAmount = msg.value;
421 
422     uint tokensAmount = calculateTokens(weiAmount);
423     assert (tokensAmount > 0);
424 
425     if(state == State.PreFunding) {
426         tokensAmount += safeDiv(safeMul(tokensAmount, getCurrentMilestone().bonus), 100);
427     }
428 
429     if(investedAmountOf[receiver] == 0) {
430        // A new investor
431        investorCount++;
432     }
433 
434     // Update investor
435     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
436     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokensAmount);
437     // Update totals
438     weiRaised = safeAdd(weiRaised, weiAmount);
439     tokensSold = safeAdd(tokensSold, tokensAmount);
440 
441     assignTokens(receiver, tokensAmount);
442     var teamBonusTokens = safeDiv(safeMul(tokensAmount, TEAM_BONUS_PERCENT), 100 - TEAM_BONUS_PERCENT);
443     assignTokens(multisigWallet, teamBonusTokens);
444 
445     multisigWallet.transfer(weiAmount);
446     // Tell us invest was success
447     Invested(receiver, weiAmount, tokensAmount);
448   }
449 
450   /// @dev Allow anonymous contributions to this crowdsale.
451   /// @param receiver The Ethereum address who receives the tokens
452   function invest(address receiver) public payable {
453     investInternal(receiver);
454   }
455 
456   /// @dev The basic entry point to participate the crowdsale process.
457   function buy() public payable {
458     invest(msg.sender);
459   }
460 
461   /// @dev Finalize a succcesful crowdsale.
462   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
463     require(!finalized);
464 
465     finalized = true;
466     finalizeCrowdsale();
467   }
468 
469   /// @dev Finalize a succcesful crowdsale.
470   function finalizeCrowdsale() internal {
471     token.releaseTokenTransfer();
472   }
473 
474    /// @dev Method for setting USD to Ether rate from Poloniex
475    /// @param value USD amout in cents for 1 Ether
476    /// @param time timestamp
477   function setExchangeRate(uint value, uint time) onlyExchangeRateAgent {
478     require(value > 0);
479     require(time > 0);
480     require(exchangeRateTimestamp == 0 || getDifference(int(time), int(now)) <= 1 minutes);
481     require(exchangeRate == 0 || (getDifference(int(value), int(exchangeRate)) * 100 / exchangeRate <= 30));
482 
483     ExchangeRateChanged(exchangeRate, value);
484     exchangeRate = value;
485     exchangeRateTimestamp = time;
486   }
487 
488   /// @dev Method set exchange rate agent
489   /// @param newAgent new agent
490  function setExchangeRateAgent(address newAgent) onlyOwner {
491    if (newAgent != address(0)) {
492      exchangeRateAgent = newAgent;
493    }
494  }
495 
496   /// @dev Method set data from migrated contract
497   /// @param _tokensSold tokens sold
498   /// @param _weiRaised _wei raised
499   /// @param _investorCount investor count
500  function setCrowdsaleData(uint _tokensSold, uint _weiRaised, uint _investorCount) onlyOwner {
501 	require(_tokensSold > 0);
502 	require(_weiRaised > 0);
503 	require(_investorCount > 0);
504 
505 	tokensSold = _tokensSold;
506 	weiRaised = _weiRaised;
507 	investorCount = _investorCount;
508  }
509 
510   function getDifference(int one, int two) private constant returns (uint) {
511     var diff = one - two;
512     if (diff < 0)
513       diff = -diff;
514     return uint(diff);
515   }
516 
517   /// @dev Allow crowdsale owner to close early or extend the crowdsale.
518   /// @param time timestamp
519   function setEndsAt(uint time) onlyOwner {
520     require(time >= now);
521     endsAt = time;
522     //EndsAtChanged(endsAt);
523   }
524 
525   /// @dev Allow load refunds back on the contract for the refunding.
526   function loadRefund() public payable inState(State.Failure) {
527     require(msg.value > 0);
528     loadedRefund = safeAdd(loadedRefund, msg.value);
529   }
530 
531   /// @dev Investors can claim refund.
532   function refund() public inState(State.Refunding) {
533     uint256 weiValue = investedAmountOf[msg.sender];
534     if (weiValue == 0)
535       return;
536     investedAmountOf[msg.sender] = 0;
537     weiRefunded = safeAdd(weiRefunded, weiValue);
538     Refund(msg.sender, weiValue);
539     msg.sender.transfer(weiValue);
540   }
541 
542   /// @dev Minimum goal was reached
543   /// @return true if the crowdsale has raised enough money to not initiate the refunding
544   function isMinimumGoalReached() public constant returns (bool reached) {
545     return weiToUsdCents(weiRaised) >= MIN_ICO_GOAL;
546   }
547 
548   /// @dev Check if the ICO goal was reached.
549   /// @return true if the crowdsale has raised enough money to be a success
550   function isCrowdsaleFull() public constant returns (bool) {
551     return weiToUsdCents(weiRaised) >= ICO_GOAL;
552   }
553 
554   /// @dev Crowdfund state machine management.
555   /// @return State current state
556   function getState() public constant returns (State) {
557     if (finalized)
558       return State.Finalized;
559     if (address(token) == 0 || address(multisigWallet) == 0 || now < preInvestStart)
560       return State.Preparing;
561     if (preInvestStart <= now && now < startsAt && !isMaximumPreFundingGoalReached())
562       return State.PreFunding;
563     if (now <= endsAt && !isCrowdsaleFull())
564       return State.Funding;
565     if (isMinimumGoalReached())
566       return State.Success;
567     if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
568       return State.Refunding;
569     return State.Failure;
570   }
571 
572   /// @dev Calculating tokens count
573   /// @param weiAmount invested
574   /// @return tokens amount
575   function calculateTokens(uint weiAmount) internal returns (uint tokenAmount) {
576     var multiplier = 10 ** token.decimals();
577 
578     uint usdAmount = weiToUsdCents(weiAmount);
579     assert (usdAmount >= PRICE);
580 
581     return safeMul(usdAmount, safeDiv(multiplier, PRICE));
582   }
583 
584    /// @dev Check if the pre ICO goal was reached.
585    /// @return true if the preICO has raised enough money to be a success
586    function isMaximumPreFundingGoalReached() public constant returns (bool reached) {
587      return weiToUsdCents(weiRaised) >= PRE_FUNDING_GOAL;
588    }
589 
590    /// @dev Converts wei value into USD cents according to current exchange rate
591    /// @param weiValue wei value to convert
592    /// @return USD cents equivalent of the wei value
593    function weiToUsdCents(uint weiValue) private returns (uint) {
594      return safeDiv(safeMul(weiValue, exchangeRate), 1e18);
595    }
596 
597    /// @dev Dynamically create tokens and assign them to the investor.
598    /// @param receiver investor address
599    /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
600    function assignTokens(address receiver, uint tokenAmount) private {
601      token.mint(receiver, tokenAmount);
602    }
603 }