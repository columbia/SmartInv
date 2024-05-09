1 pragma solidity ^0.4.13;
2 
3  /// @title Ownable contract - base contract with an owner
4  /// @author dev@smartcontracteam.com
5 contract Ownable {
6   address public owner;
7 
8   function Ownable() {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);  
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 }
23 
24 /// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.
25 /// @author dev@smartcontracteam.com
26 /// Originally envisioned in FirstBlood ICO contract.
27 contract Haltable is Ownable {
28   bool public halted;
29 
30   modifier stopInEmergency {
31     require(!halted);
32     _;
33   }
34 
35   modifier onlyInEmergency {
36     require(halted);       
37     _;
38   }
39 
40   /// called by the owner on emergency, triggers stopped state
41   function halt() external onlyOwner {
42     halted = true;
43   }
44 
45   /// called by the owner on end of emergency, returns to normal state
46   function unhalt() external onlyOwner onlyInEmergency {
47     halted = false;
48   }
49 }
50 
51 
52 
53  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
54  /// @author dev@smartcontracteam.com
55 contract ERC20 {
56   uint public totalSupply;
57   function balanceOf(address who) constant returns (uint);
58   function allowance(address owner, address spender) constant returns (uint);
59   function mint(address receiver, uint amount);
60   function transfer(address to, uint value) returns (bool ok);
61   function transferFrom(address from, address to, uint value) returns (bool ok);
62   function approve(address spender, uint value) returns (bool ok);
63   event Transfer(address indexed from, address indexed to, uint value);
64   event Approval(address indexed owner, address indexed spender, uint value);
65 }
66 
67  /// @title SafeMath contract - math operations with safety checks
68  /// @author dev@smartcontracteam.com
69 contract SafeMath {
70   function safeMul(uint a, uint b) internal returns (uint) {
71     uint c = a * b;
72     assert(a == 0 || c / a == b);
73     return c;
74   }
75 
76   function safeDiv(uint a, uint b) internal returns (uint) {
77     assert(b > 0);
78     uint c = a / b;
79     assert(a == b * c + a % b);
80     return c;
81   }
82 
83   function safeSub(uint a, uint b) internal returns (uint) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   function safeAdd(uint a, uint b) internal returns (uint) {
89     uint c = a + b;
90     assert(c>=a && c>=b);
91     return c;
92   }
93 
94   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
95     return a >= b ? a : b;
96   }
97 
98   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
99     return a < b ? a : b;
100   }
101 
102   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
103     return a >= b ? a : b;
104   }
105 
106   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
107     return a < b ? a : b;
108   }
109 
110   function assert(bool assertion) internal {
111     require(assertion);  
112   }
113 }
114 
115 
116 /// @title SolarDaoToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
117 /// @author dev@smartcontracteam.com
118 contract SolarDaoToken is SafeMath, ERC20, Ownable {
119  string public name = "Solar DAO Token";
120  string public symbol = "SDAO";
121  uint public decimals = 4;
122 
123  /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
124  address public crowdsaleAgent;
125  /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
126  bool public released = false;
127  /// approve() allowances
128  mapping (address => mapping (address => uint)) allowed;
129  /// holder balances
130  mapping(address => uint) balances;
131 
132  /// @dev Limit token transfer until the crowdsale is over.
133  modifier canTransfer() {
134    if(!released) {
135        require(msg.sender == crowdsaleAgent);
136    }
137    _;
138  }
139 
140  /// @dev The function can be called only before or after the tokens have been releasesd
141  /// @param _released token transfer and mint state
142  modifier inReleaseState(bool _released) {
143    require(_released == released);
144    _;
145  }
146 
147  /// @dev The function can be called only by release agent.
148  modifier onlyCrowdsaleAgent() {
149    require(msg.sender == crowdsaleAgent);
150    _;
151  }
152 
153  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
154  /// @param size payload size
155  modifier onlyPayloadSize(uint size) {
156     require(msg.data.length >= size + 4);
157     _;
158  }
159 
160  /// @dev Make sure we are not done yet.
161  modifier canMint() {
162     require(!released);
163     _;
164   }
165 
166  /// @dev Constructor
167  function SolarDaoToken() {
168    owner = msg.sender;
169  }
170 
171  /// Fallback method will buyout tokens
172  function() payable {
173    revert();
174  }
175 
176  /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
177  /// @param receiver Address of receiver
178  /// @param amount  Number of tokens to issue.
179  function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {
180     totalSupply = safeAdd(totalSupply, amount);
181     balances[receiver] = safeAdd(balances[receiver], amount);
182     Transfer(0, receiver, amount);
183  }
184 
185  /// @dev Set the contract that can call release and make the token transferable.
186  /// @param _crowdsaleAgent crowdsale contract address
187  function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
188    crowdsaleAgent = _crowdsaleAgent;
189  }
190  /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
191  function releaseTokenTransfer() public onlyCrowdsaleAgent {
192    released = true;
193  }
194  /// @dev Tranfer tokens to address
195  /// @param _to dest address
196  /// @param _value tokens amount
197  /// @return transfer result
198  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
199    balances[msg.sender] = safeSub(balances[msg.sender], _value);
200    balances[_to] = safeAdd(balances[_to], _value);
201 
202    Transfer(msg.sender, _to, _value);
203    return true;
204  }
205 
206  /// @dev Tranfer tokens from one address to other
207  /// @param _from source address
208  /// @param _to dest address
209  /// @param _value tokens amount
210  /// @return transfer result
211  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
212    var _allowance = allowed[_from][msg.sender];
213 
214     balances[_to] = safeAdd(balances[_to], _value);
215     balances[_from] = safeSub(balances[_from], _value);
216     allowed[_from][msg.sender] = safeSub(_allowance, _value);
217     Transfer(_from, _to, _value);
218     return true;
219  }
220  /// @dev Tokens balance
221  /// @param _owner holder address
222  /// @return balance amount
223  function balanceOf(address _owner) constant returns (uint balance) {
224    return balances[_owner];
225  }
226 
227  /// @dev Approve transfer
228  /// @param _spender holder address
229  /// @param _value tokens amount
230  /// @return result
231  function approve(address _spender, uint _value) returns (bool success) {
232    // To change the approve amount you first have to reduce the addresses`
233    //  allowance to zero by calling `approve(_spender, 0)` if it is not
234    //  already 0 to mitigate the race condition described here:
235    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
237 
238    allowed[msg.sender][_spender] = _value;
239    Approval(msg.sender, _spender, _value);
240    return true;
241  }
242 
243  /// @dev Token allowance
244  /// @param _owner holder address
245  /// @param _spender spender address
246  /// @return remain amount
247  function allowance(address _owner, address _spender) constant returns (uint remaining) {
248    return allowed[_owner][_spender];
249  }
250 }
251 
252 
253 /// @title SolarDaoTokenCrowdsale contract - contract for token sales.
254 /// @author dev@smartcontracteam.com
255 contract SolarDaoTokenCrowdsale is Haltable, SafeMath {
256 
257   /// Prefunding goal in USD cents, if the prefunding goal is reached, ico will start
258   uint public constant PRE_FUNDING_GOAL = 4e6 * PRICE;
259 
260   /// Tokens funding goal in USD cents, if the funding goal is reached, ico will stop
261   uint public constant ICO_GOAL = 8e7 * PRICE;
262 
263   /// Miminal tokens funding goal in USD cents, if this goal isn't reached during ICO, refund will begin
264   uint public constant MIN_ICO_GOAL = 1e7;
265 
266   /// Percent of bonus tokens team receives from each investment
267   uint public constant TEAM_BONUS_PERCENT = 25;
268 
269   /// The token price in USD cents
270   uint constant public PRICE = 100;
271 
272   /// Duration of the pre-ICO stage
273   uint constant public PRE_ICO_DURATION = 5 weeks;
274 
275   /// The token we are selling
276   SolarDaoToken public token;
277 
278   /// tokens will be transfered from this address
279   address public multisigWallet;
280 
281   /// the UNIX timestamp start date of the crowdsale
282   uint public startsAt;
283 
284   /// the UNIX timestamp end date of the crowdsale
285   uint public endsAt;
286 
287   /// the UNIX timestamp start date of the pre invest crowdsale
288   uint public preInvestStart;
289 
290   /// the number of tokens already sold through this contract
291   uint public tokensSold = 0;
292 
293   /// How many wei of funding we have raised
294   uint public weiRaised = 0;
295 
296   /// How many distinct addresses have invested
297   uint public investorCount = 0;
298 
299   /// How much wei we have returned back to the contract after a failed crowdfund.
300   uint public loadedRefund = 0;
301 
302   /// How much wei we have given back to investors.
303   uint public weiRefunded = 0;
304 
305   /// Has this crowdsale been finalized
306   bool public finalized;
307 
308   /// USD to Ether rate in cents
309   uint public exchangeRate;
310 
311   /// exchangeRate timestamp
312   uint public exchangeRateTimestamp;
313 
314   /// External agent that will can change exchange rate
315   address public exchangeRateAgent;
316 
317   /// How much ETH each address has invested to this crowdsale
318   mapping (address => uint256) public investedAmountOf;
319 
320   /// How much tokens this crowdsale has credited for each investor address
321   mapping (address => uint256) public tokenAmountOf;
322 
323   /// Define preICO pricing schedule using milestones.
324   struct Milestone {
325       // UNIX timestamp when this milestone kicks in
326       uint start;
327       // UNIX timestamp when this milestone kicks out
328       uint end;
329       // How many % tokens will add
330       uint bonus;
331   }
332 
333   Milestone[] public milestones;
334 
335   /// State machine
336   /// Preparing: All contract initialization calls and variables have not been set yet
337   /// Prefunding: We have not passed start time yet
338   /// Funding: Active crowdsale
339   /// Success: Minimum funding goal reached
340   /// Failure: Minimum funding goal not reached before ending time
341   /// Finalized: The finalized has been called and succesfully executed\
342   /// Refunding: Refunds are loaded on the contract for reclaim.
343   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
344 
345   /// A new investment was made
346   event Invested(address investor, uint weiAmount, uint tokenAmount);
347   /// Refund was processed for a contributor
348   event Refund(address investor, uint weiAmount);
349   /// Crowdsale end time has been changed
350   event EndsAtChanged(uint endsAt);
351   /// Calculated new price
352   event ExchangeRateChanged(uint oldValue, uint newValue);
353 
354   /// @dev Modified allowing execution only if the crowdsale is currently running
355   modifier inState(State state) {
356     require(getState() == state);
357     _;
358   }
359 
360   modifier onlyExchangeRateAgent() {
361     require(msg.sender == exchangeRateAgent);
362     _;
363   }
364 
365   /// @dev Constructor
366   /// @param _token Solar Dao token address
367   /// @param _multisigWallet team wallet
368   /// @param _preInvestStart preICO start date
369   /// @param _start token ICO start date
370   /// @param _end token ICO end date
371   function Crowdsale(address _token, address _multisigWallet, uint _preInvestStart, uint _start, uint _end) {
372     require(_multisigWallet != 0);
373     require(_preInvestStart != 0);
374     require(_start != 0);
375     require(_end != 0);
376     require(_start < _end);
377     require(_end > _preInvestStart + PRE_ICO_DURATION);
378 
379     owner = msg.sender;
380     token = SolarDaoToken(_token);
381 
382     multisigWallet = _multisigWallet;
383     startsAt = _start;
384     endsAt = _end;
385     preInvestStart = _preInvestStart;
386 
387     var preIcoBonuses = [uint(100), 80, 70, 60, 50];
388     for (uint i = 0; i < preIcoBonuses.length; i++) {
389       milestones.push(Milestone(preInvestStart + i * 1 weeks, preInvestStart + (i + 1) * 1 weeks, preIcoBonuses[i]));
390     }
391     milestones.push(Milestone(startsAt, startsAt + 4 days, 25));
392     milestones.push(Milestone(startsAt + 4 days, startsAt + 1 weeks, 20));
393     delete preIcoBonuses;
394 
395     var icoBonuses = [uint(15), 10, 5];
396     for (i = 1; i <= icoBonuses.length; i++) {
397       milestones.push(Milestone(startsAt + i * 1 weeks, startsAt + (i + 1) * 1 weeks, icoBonuses[i - 1]));
398     }
399     delete icoBonuses;
400   }
401 
402   function() payable {
403     buy();
404   }
405 
406   /// @dev Get the current milestone or bail out if we are not in the milestone periods.
407   /// @return Milestone current bonus milestone
408   function getCurrentMilestone() private constant returns (Milestone) {
409       for (uint i = 0; i < milestones.length; i++) {
410         if (milestones[i].start <= now && milestones[i].end > now) {
411           return milestones[i];
412         }
413       }
414   }
415 
416    /// @dev Make an investment. Crowdsale must be running for one to invest.
417    /// @param receiver The Ethereum address who receives the tokens
418   function investInternal(address receiver) stopInEmergency private {
419     var state = getState();
420     require(state == State.Funding || state == State.PreFunding);
421 
422     uint weiAmount = msg.value;
423     uint tokensAmount = calculateTokens(weiAmount);
424     assert (tokensAmount > 0);
425 
426     if(state == State.PreFunding) {
427         tokensAmount += safeDiv(safeMul(tokensAmount, getCurrentMilestone().bonus), 100);
428     }
429 
430     if(investedAmountOf[receiver] == 0) {
431        // A new investor
432        investorCount++;
433     }
434 
435     // Update investor
436     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
437     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokensAmount);
438     // Update totals
439     weiRaised = safeAdd(weiRaised, weiAmount);
440     tokensSold = safeAdd(tokensSold, tokensAmount);
441 
442     // Check that we did not bust the cap
443     /*
444     if(isBreakingCap(weiAmount, tokensAmount, weiRaised, tokensSold)) {
445       throw;
446     }*/
447 
448     assignTokens(receiver, tokensAmount);
449     var teamBonusTokens = safeDiv(safeMul(tokensAmount, TEAM_BONUS_PERCENT), 100 - TEAM_BONUS_PERCENT);
450     assignTokens(multisigWallet, teamBonusTokens);
451 
452     multisigWallet.transfer(weiAmount);
453     // Tell us invest was success
454     Invested(receiver, weiAmount, tokensAmount);
455   }
456 
457   /// @dev Allow anonymous contributions to this crowdsale.
458   /// @param receiver The Ethereum address who receives the tokens
459   function invest(address receiver) public payable {
460     investInternal(receiver);
461   }
462 
463   /// @dev The basic entry point to participate the crowdsale process.
464   function buy() public payable {
465     invest(msg.sender);
466   }
467 
468   /// @dev Finalize a succcesful crowdsale.
469   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
470     require(!finalized);
471 
472     finalized = true;
473     finalizeCrowdsale();
474   }
475 
476   /// @dev Finalize a succcesful crowdsale.
477   function finalizeCrowdsale() internal {
478     //assignTokens(owner, safeAdd(safeSub(uint(MAX_TOKENS_TO_SOLD), tokensSold), TEAM_TOKENS_AMOUNT));
479     token.releaseTokenTransfer();
480   }
481 
482    /// @dev Method for setting USD to Ether rate from Poloniex
483    /// @param value USD amout in cents for 1 Ether
484    /// @param time timestamp
485   function setExchangeRate(uint value, uint time) onlyExchangeRateAgent {
486     require(value > 0);
487     require(time > 0);
488     require(exchangeRateTimestamp == 0 || getDifference(int(time), int(now)) <= 1 minutes);
489     require(exchangeRate == 0 || (getDifference(int(value), int(exchangeRate)) * 100 / exchangeRate <= 30));
490 
491     ExchangeRateChanged(exchangeRate, value);
492     exchangeRate = value;
493     exchangeRateTimestamp = time;
494   }
495 
496   /// @dev Method set exchange rate agent
497   /// @param newAgent new agent
498  function setExchangeRateAgent(address newAgent) onlyOwner {
499    if (newAgent != address(0)) {
500      exchangeRateAgent = newAgent;
501    }
502  }
503 
504   function getDifference(int one, int two) private constant returns (uint) {
505     var diff = one - two;
506     if (diff < 0)
507       diff = -diff;
508     return uint(diff);
509   }
510 
511   /// @dev Allow crowdsale owner to close early or extend the crowdsale.
512   /// @param time timestamp
513   function setEndsAt(uint time) onlyOwner {
514     require(time >= now);
515     endsAt = time;
516     EndsAtChanged(endsAt);
517   }
518 
519   /// @dev Allow load refunds back on the contract for the refunding.
520   function loadRefund() public payable inState(State.Failure) {
521     require(msg.value > 0);
522     loadedRefund = safeAdd(loadedRefund, msg.value);
523   }
524 
525   /// @dev Investors can claim refund.
526   function refund() public inState(State.Refunding) {
527     uint256 weiValue = investedAmountOf[msg.sender];
528     if (weiValue == 0)
529       return;
530     investedAmountOf[msg.sender] = 0;
531     weiRefunded = safeAdd(weiRefunded, weiValue);
532     Refund(msg.sender, weiValue);
533     msg.sender.transfer(weiValue);
534   }
535 
536   /// @dev Minimum goal was reached
537   /// @return true if the crowdsale has raised enough money to not initiate the refunding
538   function isMinimumGoalReached() public constant returns (bool reached) {
539     return weiToUsdCents(weiRaised) >= MIN_ICO_GOAL;
540   }
541 
542   /// @dev Check if the ICO goal was reached.
543   /// @return true if the crowdsale has raised enough money to be a success
544   function isCrowdsaleFull() public constant returns (bool) {
545     return weiToUsdCents(weiRaised) >= ICO_GOAL;
546   }
547 
548   /// @dev Crowdfund state machine management.
549   /// @return State current state
550   function getState() public constant returns (State) {
551     if (finalized)
552       return State.Finalized;
553     if (address(token) == 0 || address(multisigWallet) == 0 || now < preInvestStart)
554       return State.Preparing;
555     if (preInvestStart <= now && now < startsAt && !isMaximumPreFundingGoalReached())
556       return State.PreFunding;
557     if (now <= endsAt && !isCrowdsaleFull())
558       return State.Funding;
559     if (isMinimumGoalReached())
560       return State.Success;
561     if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
562       return State.Refunding;
563     return State.Failure;
564   }
565 
566   /// @dev Calculating tokens count
567   /// @param weiAmount invested
568   /// @return tokens amount
569   function calculateTokens(uint weiAmount) internal returns (uint tokenAmount) {
570     var multiplier = 10 ** token.decimals();
571 
572     uint usdAmount = weiToUsdCents(weiAmount);
573     assert (usdAmount >= PRICE);
574 
575     return safeMul(usdAmount, safeDiv(multiplier, PRICE));
576   }
577 
578    /// @dev Check if the current invested breaks our cap rules.
579    /// @param weiAmount The amount of wei the investor tries to invest in the current transaction
580    /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
581    /// @param weiRaisedTotal What would be our total raised balance after this transaction
582    /// @param tokensSoldTotal What would be our total sold tokens count after this transaction
583    /// @return result
584    function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
585      return false;
586    }
587 
588    /// @dev Check if the pre ICO goal was reached.
589    /// @return true if the preICO has raised enough money to be a success
590    function isMaximumPreFundingGoalReached() public constant returns (bool reached) {
591      return weiToUsdCents(weiRaised) >= PRE_FUNDING_GOAL;
592    }
593 
594    /// @dev Converts wei value into USD cents according to current exchange rate
595    /// @param weiValue wei value to convert
596    /// @return USD cents equivalent of the wei value
597    function weiToUsdCents(uint weiValue) private returns (uint) {
598      return safeDiv(safeMul(weiValue, exchangeRate), 1e18);
599    }
600 
601    /// @dev Dynamically create tokens and assign them to the investor.
602    /// @param receiver investor address
603    /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
604    function assignTokens(address receiver, uint tokenAmount) private {
605      token.mint(receiver, tokenAmount);
606    }
607 }