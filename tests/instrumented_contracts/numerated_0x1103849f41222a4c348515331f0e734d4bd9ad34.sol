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
46   function assert(bool assertion) internal {
47     require(assertion);
48   }
49 }
50 
51 
52 
53  /// @title Ownable contract - base contract with an owner
54 contract Ownable {
55   address public owner;
56 
57   function Ownable() {
58     owner = msg.sender;
59   }
60 
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   function transferOwnership(address newOwner) onlyOwner {
67     if (newOwner != address(0)) {
68       owner = newOwner;
69     }
70   }
71 }
72 
73 
74 /// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.
75 /// Originally envisioned in FirstBlood ICO contract.
76 contract Haltable is Ownable {
77   bool public halted;
78 
79   modifier stopInEmergency {
80     require(!halted);
81     _;
82   }
83 
84   modifier onlyInEmergency {
85     require(halted);
86     _;
87   }
88 
89   /// called by the owner on emergency, triggers stopped state
90   function halt() external onlyOwner {
91     halted = true;
92   }
93 
94   /// called by the owner on end of emergency, returns to normal state
95   function unhalt() external onlyOwner onlyInEmergency {
96     halted = false;
97   }
98 }
99 
100 
101 
102 
103  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
104 contract ERC20 {
105   uint public totalSupply;
106   function balanceOf(address who) constant returns (uint);
107   function allowance(address owner, address spender) constant returns (uint);
108   function mint(address receiver, uint amount);
109   function transfer(address to, uint value) returns (bool ok);
110   function transferFrom(address from, address to, uint value) returns (bool ok);
111   function approve(address spender, uint value) returns (bool ok);
112   event Transfer(address indexed from, address indexed to, uint value);
113   event Approval(address indexed owner, address indexed spender, uint value);
114 }
115 
116 
117 
118 /// @title SolarDaoToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
119 contract SolarDaoToken is SafeMath, ERC20, Ownable {
120  string public name = "Solar DAO Token";
121  string public symbol = "SDAO";
122  uint public decimals = 4;
123 
124  /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
125  address public crowdsaleAgent;
126  /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
127  bool public released = false;
128  /// approve() allowances
129  mapping (address => mapping (address => uint)) allowed;
130  /// holder balances
131  mapping(address => uint) balances;
132 
133  /// @dev Limit token transfer until the crowdsale is over.
134  modifier canTransfer() {
135    if(!released) {
136        require(msg.sender == crowdsaleAgent);
137    }
138    _;
139  }
140 
141  /// @dev The function can be called only before or after the tokens have been releasesd
142  /// @param _released token transfer and mint state
143  modifier inReleaseState(bool _released) {
144    require(_released == released);
145    _;
146  }
147 
148  /// @dev The function can be called only by release agent.
149  modifier onlyCrowdsaleAgent() {
150    require(msg.sender == crowdsaleAgent);
151    _;
152  }
153 
154  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
155  /// @param size payload size
156  modifier onlyPayloadSize(uint size) {
157     require(msg.data.length >= size + 4);
158     _;
159  }
160 
161  /// @dev Make sure we are not done yet.
162  modifier canMint() {
163     require(!released);
164     _;
165   }
166 
167  /// @dev Constructor
168  function SolarDaoToken() {
169    owner = msg.sender;
170  }
171 
172  /// Fallback method will buyout tokens
173  function() payable {
174    revert();
175  }
176 
177  /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
178  /// @param receiver Address of receiver
179  /// @param amount  Number of tokens to issue.
180  function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {
181     totalSupply = safeAdd(totalSupply, amount);
182     balances[receiver] = safeAdd(balances[receiver], amount);
183     Transfer(0, receiver, amount);
184  }
185 
186  /// @dev Set the contract that can call release and make the token transferable.
187  /// @param _crowdsaleAgent crowdsale contract address
188  function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
189    crowdsaleAgent = _crowdsaleAgent;
190  }
191  /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
192  function releaseTokenTransfer() public onlyCrowdsaleAgent {
193    released = true;
194  }
195  /// @dev Tranfer tokens to address
196  /// @param _to dest address
197  /// @param _value tokens amount
198  /// @return transfer result
199  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
200    balances[msg.sender] = safeSub(balances[msg.sender], _value);
201    balances[_to] = safeAdd(balances[_to], _value);
202 
203    Transfer(msg.sender, _to, _value);
204    return true;
205  }
206 
207  /// @dev Tranfer tokens from one address to other
208  /// @param _from source address
209  /// @param _to dest address
210  /// @param _value tokens amount
211  /// @return transfer result
212  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
213    var _allowance = allowed[_from][msg.sender];
214 
215     balances[_to] = safeAdd(balances[_to], _value);
216     balances[_from] = safeSub(balances[_from], _value);
217     allowed[_from][msg.sender] = safeSub(_allowance, _value);
218     Transfer(_from, _to, _value);
219     return true;
220  }
221  /// @dev Tokens balance
222  /// @param _owner holder address
223  /// @return balance amount
224  function balanceOf(address _owner) constant returns (uint balance) {
225    return balances[_owner];
226  }
227 
228  /// @dev Approve transfer
229  /// @param _spender holder address
230  /// @param _value tokens amount
231  /// @return result
232  function approve(address _spender, uint _value) returns (bool success) {
233    // To change the approve amount you first have to reduce the addresses`
234    //  allowance to zero by calling `approve(_spender, 0)` if it is not
235    //  already 0 to mitigate the race condition described here:
236    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
238 
239    allowed[msg.sender][_spender] = _value;
240    Approval(msg.sender, _spender, _value);
241    return true;
242  }
243 
244  /// @dev Token allowance
245  /// @param _owner holder address
246  /// @param _spender spender address
247  /// @return remain amount
248  function allowance(address _owner, address _spender) constant returns (uint remaining) {
249    return allowed[_owner][_spender];
250  }
251 }
252 /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
253 contract Killable is Ownable {
254  function kill() onlyOwner {
255    selfdestruct(owner);
256  }
257 }
258 
259 
260 /// @title SolarDaoTokenCrowdsale contract - contract for token sales.
261 contract SolarDaoTokenCrowdsale is Haltable, Killable, SafeMath {
262 
263   /// Prefunding goal in USD cents, if the prefunding goal is reached, ico will start
264   uint public constant PRE_FUNDING_GOAL = 4e6 * PRICE;
265 
266   /// Tokens funding goal in USD cents, if the funding goal is reached, ico will stop
267   uint public constant ICO_GOAL = 8e7 * PRICE;
268 
269   /// Miminal tokens funding goal in USD cents, if this goal isn't reached during ICO, refund will begin
270   uint public constant MIN_ICO_GOAL = 1e7;
271 
272   /// Percent of bonus tokens team receives from each investment
273   uint public constant TEAM_BONUS_PERCENT = 25;
274 
275   /// The token price in USD cents
276   uint constant public PRICE = 100;
277 
278   /// Duration of the pre-ICO stage
279   uint constant public PRE_ICO_DURATION = 5 weeks;
280 
281   /// The token we are selling
282   SolarDaoToken public token;
283 
284   /// tokens will be transfered from this address
285   address public multisigWallet;
286 
287   /// the UNIX timestamp start date of the crowdsale
288   uint public startsAt;
289 
290   /// the UNIX timestamp end date of the crowdsale
291   uint public endsAt;
292 
293   /// the UNIX timestamp start date of the pre invest crowdsale
294   uint public preInvestStart;
295 
296   /// the number of tokens already sold through this contract
297   uint public tokensSold = 0;
298 
299   /// How many wei of funding we have raised
300   uint public weiRaised = 0;
301 
302   /// How many distinct addresses have invested
303   uint public investorCount = 0;
304 
305   /// How much wei we have returned back to the contract after a failed crowdfund.
306   uint public loadedRefund = 0;
307 
308   /// How much wei we have given back to investors.
309   uint public weiRefunded = 0;
310 
311   /// Has this crowdsale been finalized
312   bool public finalized;
313 
314   /// USD to Ether rate in cents
315   uint public exchangeRate;
316 
317   /// exchangeRate timestamp
318   uint public exchangeRateTimestamp;
319 
320   /// External agent that will can change exchange rate
321   address public exchangeRateAgent;
322 
323   /// How much ETH each address has invested to this crowdsale
324   mapping (address => uint256) public investedAmountOf;
325 
326   /// How much tokens this crowdsale has credited for each investor address
327   mapping (address => uint256) public tokenAmountOf;
328 
329   /// Define preICO pricing schedule using milestones.
330   struct Milestone {
331       // UNIX timestamp when this milestone kicks in
332       uint start;
333       // UNIX timestamp when this milestone kicks out
334       uint end;
335       // How many % tokens will add
336       uint bonus;
337   }
338 
339   Milestone[] public milestones;
340 
341   /// State machine
342   /// Preparing: All contract initialization calls and variables have not been set yet
343   /// Prefunding: We have not passed start time yet
344   /// Funding: Active crowdsale
345   /// Success: Minimum funding goal reached
346   /// Failure: Minimum funding goal not reached before ending time
347   /// Finalized: The finalized has been called and succesfully executed\
348   /// Refunding: Refunds are loaded on the contract for reclaim.
349   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
350 
351   /// A new investment was made
352   event Invested(address investor, uint weiAmount, uint tokenAmount);
353   /// Refund was processed for a contributor
354   event Refund(address investor, uint weiAmount);
355   /// Crowdsale end time has been changed
356   event EndsAtChanged(uint endsAt);
357   /// Calculated new price
358   event ExchangeRateChanged(uint oldValue, uint newValue);
359 
360   /// @dev Modified allowing execution only if the crowdsale is currently running
361   modifier inState(State state) {
362     require(getState() == state);
363     _;
364   }
365 
366   modifier onlyExchangeRateAgent() {
367     require(msg.sender == exchangeRateAgent);
368     _;
369   }
370 
371   /// @dev Constructor
372   /// @param _token Solar Dao token address
373   /// @param _multisigWallet team wallet
374   /// @param _preInvestStart preICO start date
375   /// @param _start token ICO start date
376   /// @param _end token ICO end date
377   function SolarDaoTokenCrowdsale(address _token, address _multisigWallet, uint _preInvestStart, uint _start, uint _end) {
378     require(_multisigWallet != 0);
379     require(_preInvestStart != 0);
380     require(_start != 0);
381     require(_end != 0);
382     require(_start < _end);
383     require(_end > _preInvestStart + PRE_ICO_DURATION);
384 
385     token = SolarDaoToken(_token);
386 
387     multisigWallet = _multisigWallet;
388     startsAt = _start;
389     endsAt = _end;
390     preInvestStart = _preInvestStart;
391 
392     var preIcoBonuses = [uint(100), 80, 70, 60, 50];
393     for (uint i = 0; i < preIcoBonuses.length; i++) {
394       milestones.push(Milestone(preInvestStart + i * 1 weeks, preInvestStart + (i + 1) * 1 weeks, preIcoBonuses[i]));
395     }
396     milestones.push(Milestone(startsAt, startsAt + 4 days, 25));
397     milestones.push(Milestone(startsAt + 4 days, startsAt + 1 weeks, 20));
398     delete preIcoBonuses;
399 
400     var icoBonuses = [uint(15), 10, 5];
401     for (i = 1; i <= icoBonuses.length; i++) {
402       milestones.push(Milestone(startsAt + i * 1 weeks, startsAt + (i + 1) * 1 weeks, icoBonuses[i - 1]));
403     }
404     delete icoBonuses;
405   }
406 
407   function() payable {
408     buy();
409   }
410 
411   /// @dev Get the current milestone or bail out if we are not in the milestone periods.
412   /// @return Milestone current bonus milestone
413   function getCurrentMilestone() private constant returns (Milestone) {
414       for (uint i = 0; i < milestones.length; i++) {
415         if (milestones[i].start <= now && milestones[i].end > now) {
416           return milestones[i];
417         }
418       }
419   }
420 
421    /// @dev Make an investment. Crowdsale must be running for one to invest.
422    /// @param receiver The Ethereum address who receives the tokens
423   function investInternal(address receiver) stopInEmergency private {
424     var state = getState();
425     require(state == State.Funding || state == State.PreFunding);
426 
427     uint weiAmount = msg.value;
428     uint tokensAmount = calculateTokens(weiAmount);
429     assert (tokensAmount > 0);
430 
431     if(state == State.PreFunding) {
432         tokensAmount += safeDiv(safeMul(tokensAmount, getCurrentMilestone().bonus), 100);
433     }
434 
435     if(investedAmountOf[receiver] == 0) {
436        // A new investor
437        investorCount++;
438     }
439 
440     // Update investor
441     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
442     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokensAmount);
443     // Update totals
444     weiRaised = safeAdd(weiRaised, weiAmount);
445     tokensSold = safeAdd(tokensSold, tokensAmount);   
446 
447     assignTokens(receiver, tokensAmount);
448     var teamBonusTokens = safeDiv(safeMul(tokensAmount, TEAM_BONUS_PERCENT), 100 - TEAM_BONUS_PERCENT);
449     assignTokens(multisigWallet, teamBonusTokens);
450 
451     multisigWallet.transfer(weiAmount);
452     // Tell us invest was success
453     Invested(receiver, weiAmount, tokensAmount);
454   }
455 
456   /// @dev Allow anonymous contributions to this crowdsale.
457   /// @param receiver The Ethereum address who receives the tokens
458   function invest(address receiver) public payable {
459     investInternal(receiver);
460   }
461 
462   /// @dev The basic entry point to participate the crowdsale process.
463   function buy() public payable {
464     invest(msg.sender);
465   }
466 
467   /// @dev Finalize a succcesful crowdsale.
468   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
469     require(!finalized);
470 
471     finalized = true;
472     finalizeCrowdsale();
473   }
474 
475   /// @dev Finalize a succcesful crowdsale.
476   function finalizeCrowdsale() internal {    
477     token.releaseTokenTransfer();
478   }
479 
480    /// @dev Method for setting USD to Ether rate from Poloniex
481    /// @param value USD amout in cents for 1 Ether
482    /// @param time timestamp
483   function setExchangeRate(uint value, uint time) onlyExchangeRateAgent {
484     require(value > 0);
485     require(time > 0);
486     require(exchangeRateTimestamp == 0 || getDifference(int(time), int(now)) <= 1 minutes);
487     require(exchangeRate == 0 || (getDifference(int(value), int(exchangeRate)) * 100 / exchangeRate <= 30));
488 
489     ExchangeRateChanged(exchangeRate, value);
490     exchangeRate = value;
491     exchangeRateTimestamp = time;
492   }
493 
494   /// @dev Method set exchange rate agent
495   /// @param newAgent new agent
496  function setExchangeRateAgent(address newAgent) onlyOwner {
497    if (newAgent != address(0)) {
498      exchangeRateAgent = newAgent;
499    }
500  }
501  
502   /// @dev Method set data from migrated contract
503   /// @param _tokensSold tokens sold
504   /// @param _weiRaised _wei raised
505   /// @param _investorCount investor count
506  function setCrowdsaleData(uint _tokensSold, uint _weiRaised, uint _investorCount) onlyOwner {  
507 	require(_tokensSold > 0);
508 	require(_weiRaised > 0);
509 	require(_investorCount > 0);
510 	
511 	tokensSold = _tokensSold;
512 	weiRaised = _weiRaised;
513 	investorCount = _investorCount;	
514  }
515 
516   function getDifference(int one, int two) private constant returns (uint) {
517     var diff = one - two;
518     if (diff < 0)
519       diff = -diff;
520     return uint(diff);
521   }
522 
523   /// @dev Allow crowdsale owner to close early or extend the crowdsale.
524   /// @param time timestamp
525   function setEndsAt(uint time) onlyOwner {
526     require(time >= now);
527     endsAt = time;
528     EndsAtChanged(endsAt);
529   }
530 
531   /// @dev Allow load refunds back on the contract for the refunding.
532   function loadRefund() public payable inState(State.Failure) {
533     require(msg.value > 0);
534     loadedRefund = safeAdd(loadedRefund, msg.value);
535   }
536 
537   /// @dev Investors can claim refund.
538   function refund() public inState(State.Refunding) {
539     uint256 weiValue = investedAmountOf[msg.sender];
540     if (weiValue == 0)
541       return;
542     investedAmountOf[msg.sender] = 0;
543     weiRefunded = safeAdd(weiRefunded, weiValue);
544     Refund(msg.sender, weiValue);
545     msg.sender.transfer(weiValue);
546   }
547 
548   /// @dev Minimum goal was reached
549   /// @return true if the crowdsale has raised enough money to not initiate the refunding
550   function isMinimumGoalReached() public constant returns (bool reached) {
551     return weiToUsdCents(weiRaised) >= MIN_ICO_GOAL;
552   }
553 
554   /// @dev Check if the ICO goal was reached.
555   /// @return true if the crowdsale has raised enough money to be a success
556   function isCrowdsaleFull() public constant returns (bool) {
557     return weiToUsdCents(weiRaised) >= ICO_GOAL;
558   }
559 
560   /// @dev Crowdfund state machine management.
561   /// @return State current state
562   function getState() public constant returns (State) {
563     if (finalized)
564       return State.Finalized;
565     if (address(token) == 0 || address(multisigWallet) == 0 || now < preInvestStart)
566       return State.Preparing;
567     if (preInvestStart <= now && now < startsAt && !isMaximumPreFundingGoalReached())
568       return State.PreFunding;
569     if (now <= endsAt && !isCrowdsaleFull())
570       return State.Funding;
571     if (isMinimumGoalReached())
572       return State.Success;
573     if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
574       return State.Refunding;
575     return State.Failure;
576   }
577 
578   /// @dev Calculating tokens count
579   /// @param weiAmount invested
580   /// @return tokens amount
581   function calculateTokens(uint weiAmount) internal returns (uint tokenAmount) {
582     var multiplier = 10 ** token.decimals();
583 
584     uint usdAmount = weiToUsdCents(weiAmount);
585     assert (usdAmount >= PRICE);
586 
587     return safeMul(usdAmount, safeDiv(multiplier, PRICE));
588   }  
589 
590    /// @dev Check if the pre ICO goal was reached.
591    /// @return true if the preICO has raised enough money to be a success
592    function isMaximumPreFundingGoalReached() public constant returns (bool reached) {
593      return weiToUsdCents(weiRaised) >= PRE_FUNDING_GOAL;
594    }
595 
596    /// @dev Converts wei value into USD cents according to current exchange rate
597    /// @param weiValue wei value to convert
598    /// @return USD cents equivalent of the wei value
599    function weiToUsdCents(uint weiValue) private returns (uint) {
600      return safeDiv(safeMul(weiValue, exchangeRate), 1e18);
601    }
602 
603    /// @dev Dynamically create tokens and assign them to the investor.
604    /// @param receiver investor address
605    /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
606    function assignTokens(address receiver, uint tokenAmount) private {
607      token.mint(receiver, tokenAmount);
608    }
609 }