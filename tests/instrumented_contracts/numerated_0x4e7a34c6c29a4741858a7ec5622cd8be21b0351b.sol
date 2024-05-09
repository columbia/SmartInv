1 pragma solidity ^0.4.13;
2 /// @title Ownable contract - base contract with an owner
3 contract Ownable {
4     address public owner;
5 
6     function Ownable() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         if (newOwner != address(0)) {
17             owner = newOwner;
18         }
19     }
20 }
21 
22 /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
23 contract Killable is Ownable {
24     function kill() onlyOwner {
25         selfdestruct(owner);
26     }
27 }
28 
29 /// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.
30 /// Originally envisioned in FirstBlood ICO contract.
31 contract Haltable is Ownable {
32     bool public halted;
33 
34     modifier stopInEmergency {
35         require(!halted);
36         _;
37     }
38 
39     modifier onlyInEmergency {
40         require(halted);
41         _;
42     }
43 
44     /// called by the owner on emergency, triggers stopped state
45     function halt() external onlyOwner {
46         halted = true;
47     }
48 
49     /// called by the owner on end of emergency, returns to normal state
50     function unhalt() external onlyOwner onlyInEmergency {
51         halted = false;
52     }
53 }
54 
55 /// @title Migrations contract - abstract contract that allows migrate to new address.
56 contract Migrations is Ownable {
57     uint public lastCompletedMigration;
58 
59     function setCompleted(uint completed) onlyOwner {
60         lastCompletedMigration = completed;
61     }
62 
63     function upgrade(address newAddress) onlyOwner {
64         Migrations upgraded = Migrations(newAddress);
65         upgraded.setCompleted(lastCompletedMigration);
66     }
67 }
68 /// @title Pausable contract - abstract contract that allows children to implement an emergency stop mechanism.
69 contract Pausable is Ownable {
70     bool public stopped;
71 
72     modifier stopInEmergency {
73         if (!stopped) {
74             _;
75         }
76     }
77 
78     modifier onlyInEmergency {
79         if (stopped) {
80             _;
81         }
82     }
83 
84     /// called by the owner on emergency, triggers stopped state
85     function emergencyStop() external onlyOwner {
86         stopped = true;
87     }
88 
89     /// called by the owner on end of emergency, returns to normal state
90     function release() external onlyOwner onlyInEmergency {
91         stopped = false;
92     }
93 }
94 
95 /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
96 contract ERC20 {
97     uint public totalSupply;
98     function balanceOf(address who) constant returns (uint);
99     function allowance(address owner, address spender) constant returns (uint);
100     function mint(address receiver, uint amount);
101     function transfer(address to, uint value) returns (bool ok);
102     function transferFrom(address from, address to, uint value) returns (bool ok);
103     function approve(address spender, uint value) returns (bool ok);
104     event Transfer(address indexed from, address indexed to, uint value);
105     event Approval(address indexed owner, address indexed spender, uint value);
106 }
107 
108 
109 /// @title SafeMath contract - math operations with safety checks
110 contract SafeMath {
111     function safeMul(uint a, uint b) internal returns (uint) {
112         uint c = a * b;
113         return c;
114     }
115 
116     function safeDiv(uint a, uint b) internal returns (uint) {
117         uint c = a / b;
118         return c;
119     }
120 
121     function safeSub(uint a, uint b) internal returns (uint) {
122         return a - b;
123     }
124 
125     function safeAdd(uint a, uint b) internal returns (uint) {
126         uint c = a + b;
127         return c;
128     }
129 
130     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
131         return a >= b ? a : b;
132     }
133 
134     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
135         return a < b ? a : b;
136     }
137 
138     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
139         return a >= b ? a : b;
140     }
141 
142     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
143         return a < b ? a : b;
144     }
145 }
146 
147 /// @title ShareEstateToken contract - ERC20 token with Short Hand Attack and approve() race condition mitigation.
148 contract ShareEstateToken is SafeMath, ERC20, Ownable {
149     string public name = "ShareEstate Token";
150     string public symbol = "SRE";
151     uint public decimals = 4;
152 
153     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
154     address public crowdsaleAgent;
155     /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
156     bool public released = false;
157     /// approve() allowances
158     mapping (address => mapping (address => uint)) allowed;
159     /// holder balances
160     mapping(address => uint) balances;
161 
162     /// @dev Limit token transfer until the crowdsale is over.
163     modifier canTransfer() {
164         if(!released) {
165             require(msg.sender == crowdsaleAgent);
166         }
167         _;
168     }
169 
170     /// @dev The function can be called only before or after the tokens have been releasesd
171     /// @param _released token transfer and mint state
172     modifier inReleaseState(bool _released) {
173         require(_released == released);
174         _;
175     }
176 
177     /// @dev The function can be called only by release agent.
178     modifier onlyCrowdsaleAgent() {
179         require(msg.sender == crowdsaleAgent);
180         _;
181     }
182 
183     /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
184     /// @param size payload size
185     modifier onlyPayloadSize(uint size) {
186         require(msg.data.length >= size + 4);
187         _;
188     }
189 
190     /// @dev Make sure we are not done yet.
191     modifier canMint() {
192         require(!released);
193         _;
194     }
195 
196     /// @dev Main Constructor
197     function ShareEstateToken() {
198         owner = msg.sender;
199     }
200 
201     /// Fallback method will buyout tokens
202     function() payable {
203         revert();
204     }
205 
206     /// @dev Create new tokens and allocate them to an address. Only callable by a crowdsale contract
207     /// @param receiver Address of receiver
208     /// @param amount  Number of tokens to issue.
209     function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {
210         totalSupply = safeAdd(totalSupply, amount);
211         balances[receiver] = safeAdd(balances[receiver], amount);
212         Transfer(0, receiver, amount);
213     }
214 
215     /// @dev Set the contract that can call release and make the token transferable.
216     /// @param _crowdsaleAgent crowdsale contract address
217     function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
218         crowdsaleAgent = _crowdsaleAgent;
219     }
220     /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
221     function releaseTokenTransfer() public onlyCrowdsaleAgent {
222         released = true;
223     }
224     /// @dev Tranfer tokens to address
225     /// @param _to dest address
226     /// @param _value tokens amount
227     /// @return transfer result
228     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
229         balances[msg.sender] = safeSub(balances[msg.sender], _value);
230         balances[_to] = safeAdd(balances[_to], _value);
231 
232         Transfer(msg.sender, _to, _value);
233         return true;
234     }
235 
236     /// @dev Tranfer tokens from one address to other
237     /// @param _from source address
238     /// @param _to dest address
239     /// @param _value tokens amount
240     /// @return transfer result
241     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
242         var _allowance = allowed[_from][msg.sender];
243 
244         balances[_to] = safeAdd(balances[_to], _value);
245         balances[_from] = safeSub(balances[_from], _value);
246         allowed[_from][msg.sender] = safeSub(_allowance, _value);
247         Transfer(_from, _to, _value);
248         return true;
249     }
250     /// @dev Tokens balance
251     /// @param _owner holder address
252     /// @return balance amount
253     function balanceOf(address _owner) constant returns (uint balance) {
254         return balances[_owner];
255     }
256 
257     /// @dev Approve transfer
258     /// @param _spender holder address
259     /// @param _value tokens amount
260     /// @return result
261     function approve(address _spender, uint _value) returns (bool success) {
262         // To change the approve amount you first have to reduce the addresses`
263         //  allowance to zero by calling `approve(_spender, 0)` if it is not
264         //  already 0 to mitigate the race condition described here:
265         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266         require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
267 
268         allowed[msg.sender][_spender] = _value;
269         Approval(msg.sender, _spender, _value);
270         return true;
271     }
272 
273     /// @dev Token allowance
274     /// @param _owner holder address
275     /// @param _spender spender address
276     /// @return remain amount
277     function allowance(address _owner, address _spender) constant returns (uint remaining) {
278         return allowed[_owner][_spender];
279     }
280 }
281 /// @title ShareEstateTokenCrowdsale contract - contract for token sales.
282 contract ShareEstateTokenCrowdsale is Haltable, Killable, SafeMath {
283 
284     /// Prefunding goal in USD cents, if the prefunding goal is reached, pre ICO will stop
285     uint public constant PRE_FUNDING_GOAL = 1e6 * PRICE;
286 
287     /// Miminal tokens funding goal in USD cents, if this goal isn't reached during ICO, refund will begin
288     uint public constant MIN_PRE_FUNDING_GOAL = 2e5 * PRICE;
289 
290     /// Percent of bonus tokens team receives from each investment
291     uint public constant TEAM_BONUS_PERCENT = 24;
292 
293     /// The token price in USD cents
294     uint constant public PRICE = 100;
295 
296     /// Duration of the pre-ICO stage
297     uint constant public PRE_ICO_DURATION = 5 weeks;
298 
299     /// The token we are selling
300 
301     ShareEstateToken public token;
302 
303     /// tokens will be transfered from this address
304     address public multisigWallet;
305 
306     /// the UNIX timestamp start date of the crowdsale
307     uint public startsAt;
308 
309     /// the UNIX timestamp end date of the crowdsale
310     uint public preIcoEndsAt;
311 
312     /// the number of tokens already sold through this contract
313     uint public tokensSold = 0;
314 
315     /// How many wei of funding we have raised
316     uint public weiRaised = 0;
317 
318     /// How many distinct addresses have invested
319     uint public investorCount = 0;
320 
321     /// How much wei we have returned back to the contract after a failed crowdfund.
322     uint public loadedRefund = 0;
323 
324     /// How much wei we have given back to investors.
325     uint public weiRefunded = 0;
326 
327     /// Has this crowdsale been finalized
328     bool public finalized;
329 
330     /// USD to Ether rate in cents
331     uint public exchangeRate;
332 
333     /// exchangeRate timestamp
334     uint public exchangeRateTimestamp;
335 
336     /// External agent that will can change exchange rate
337     address public exchangeRateAgent;
338 
339     /// How much ETH each address has invested to this crowdsale
340     mapping (address => uint256) public investedAmountOf;
341 
342     /// How much tokens this crowdsale has credited for each investor address
343     mapping (address => uint256) public tokenAmountOf;
344 
345     /// Define preICO pricing schedule using milestones.
346     struct Milestone {
347     // UNIX timestamp when this milestone kicks in
348     uint start;
349     // UNIX timestamp when this milestone kicks out
350     uint end;
351     // How many % tokens will add
352     uint bonus;
353     }
354 
355     Milestone[] public milestones;
356 
357     /// State machine
358     /// Preparing: All contract initialization calls and variables have not been set yet
359     /// Prefunding: We have not passed start time yet
360     /// PreFundingSuccess: Minimum funding goal reached
361     /// Failure: Minimum funding goal not reached before ending time
362     /// Finalized: The finalized has been called and succesfully executed\
363     /// Refunding: Refunds are loaded on the contract for reclaim.
364     enum State{Unknown, Preparing, PreFunding, PreFundingSuccess, Failure, Finalized, Refunding}
365 
366     /// A new investment was made
367     event Invested(address investor, uint weiAmount, uint tokenAmount);
368     /// Refund was processed for a contributor
369     event Refund(address investor, uint weiAmount);
370     /// Crowdsale end time has been changed
371     event preIcoEndsAtChanged(uint endsAt);
372     /// Calculated new
373     event ExchangeRateChanged(uint oldValue, uint newValue);
374 
375     /// @dev Modified allowing execution only if the crowdsale is currently running
376     modifier inState(State state) {
377         require(getState() == state);
378         _;
379     }
380 
381     modifier onlyExchangeRateAgent() {
382         require(msg.sender == exchangeRateAgent);
383         _;
384     }
385 
386     /// @dev Constructor
387     /// @param _token Solar Dao token address
388     /// @param _multisigWallet team wallet
389     /// @param _preInvestStart preICO start date
390     /// @param _preInvestStop token ICO end date
391     function ShareEstateTokenCrowdsale(address _token, address _multisigWallet, uint _preInvestStart, uint _preInvestStop) {
392         require(_multisigWallet != 0);
393         require(_preInvestStart != 0);
394         require(_preInvestStop != 0);
395         require(_preInvestStart < _preInvestStop);
396 
397         token = ShareEstateToken(_token);
398 
399         multisigWallet = _multisigWallet;
400         startsAt = _preInvestStart;
401         preIcoEndsAt = _preInvestStop;
402         var preIcoBonuses = [uint(65), 50, 40, 35, 30];
403         for (uint i = 0; i < preIcoBonuses.length; i++) {
404             milestones.push(Milestone(_preInvestStart + i * 1 weeks, _preInvestStart + (i + 1) * 1 weeks, preIcoBonuses[i]));
405         }
406     }
407 
408     function() payable {
409         buy();
410     }
411 
412     /// @dev Get the current milestone or bail out if we are not in the milestone periods.
413     /// @return Milestone current bonus milestone
414     function getCurrentMilestone() private constant returns (Milestone) {
415         for (uint i = 0; i < milestones.length; i++) {
416             if (milestones[i].start <= now && milestones[i].end > now) {
417                 return milestones[i];
418             }
419         }
420     }
421 
422     /// @dev Make an investment. Crowdsale must be running for one to invest.
423     /// @param receiver The Ethereum address who receives the tokens
424     function investInternal(address receiver) stopInEmergency private {
425         var state = getState();
426         require(state == State.PreFunding);
427 
428         uint weiAmount = msg.value;
429         uint tokensAmount = calculateTokens(weiAmount);
430 
431         if(state == State.PreFunding) {
432             tokensAmount += safeDiv(safeMul(tokensAmount, getCurrentMilestone().bonus), 100);
433         }
434 
435         if(investedAmountOf[receiver] == 0) {
436             // A new investor
437             investorCount++;
438         }
439 
440         // Update investor
441         investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
442         tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokensAmount);
443         // Update totals
444         weiRaised = safeAdd(weiRaised, weiAmount);
445         tokensSold = safeAdd(tokensSold, tokensAmount);
446 
447         assignTokens(receiver, tokensAmount);
448         var teamBonusTokens = safeDiv(safeMul(tokensAmount, TEAM_BONUS_PERCENT), 100 - TEAM_BONUS_PERCENT);
449         assignTokens(multisigWallet, teamBonusTokens);
450 
451         multisigWallet.transfer(weiAmount);
452         // Tell us invest was success
453         Invested(receiver, weiAmount, tokensAmount);
454     }
455 
456     /// @dev Allow anonymous contributions to this crowdsale.
457     /// @param receiver The Ethereum address who receives the tokens
458     function invest(address receiver) public payable {
459         investInternal(receiver);
460     }
461 
462     /// @dev The basic entry point to participate the crowdsale process.
463     function buy() public payable {
464         invest(msg.sender);
465     }
466 
467     /// @dev Finalize a succcesful crowdsale.
468     function finalize() public inState(State.PreFundingSuccess) onlyOwner stopInEmergency {
469         require(!finalized);
470 
471         finalized = true;
472         finalizeCrowdsale();
473     }
474 
475     /// @dev Finalize a succcesful crowdsale.
476     function finalizeCrowdsale() internal {
477         //assignTokens(owner, safeAdd(safeSub(uint(MAX_TOKENS_TO_SOLD), tokensSold), TEAM_TOKENS_AMOUNT));
478         //token.releaseTokenTransfer(); // Will be released in result of ICO
479     }
480 
481     /// @dev Method for setting USD to Ether rate from Poloniex
482     /// @param value USD amout in cents for 1 Ether
483     /// @param time timestamp
484     function setExchangeRate(uint value, uint time) onlyExchangeRateAgent {
485         require(value > 0);
486         require(time > 0);
487         require(exchangeRateTimestamp == 0 || getDifference(int(time), int(now)) <= 1 minutes);
488         require(exchangeRate == 0 || (getDifference(int(value), int(exchangeRate)) * 100 / exchangeRate <= 30));
489 
490         ExchangeRateChanged(exchangeRate, value);
491         exchangeRate = value;
492         exchangeRateTimestamp = time;
493     }
494 
495     /// @dev Method set exchange rate agent
496     /// @param newAgent new agent
497     function setExchangeRateAgent(address newAgent) onlyOwner {
498         if (newAgent != address(0)) {
499             exchangeRateAgent = newAgent;
500         }
501     }
502 
503     function getDifference(int one, int two) private constant returns (uint) {
504         var diff = one - two;
505         if (diff < 0)
506         diff = -diff;
507         return uint(diff);
508     }
509 
510     /// @dev Allow crowdsale owner to close early or extend the crowdsale.
511     /// @param time timestamp
512     function setPreIcoEndsAt(uint time) onlyOwner {
513         require(time >= now);
514         preIcoEndsAt = time;
515         preIcoEndsAtChanged(preIcoEndsAt);
516     }
517 
518     /// @dev Allow load refunds back on the contract for the refunding.
519     function loadRefund() public payable inState(State.Failure) {
520         require(msg.value > 0);
521         loadedRefund = safeAdd(loadedRefund, msg.value);
522     }
523 
524     /// @dev Investors can claim refund.
525     function refund() public inState(State.Refunding) {
526         uint256 weiValue = investedAmountOf[msg.sender];
527         if (weiValue == 0)
528         return;
529         investedAmountOf[msg.sender] = 0;
530         weiRefunded = safeAdd(weiRefunded, weiValue);
531         Refund(msg.sender, weiValue);
532         msg.sender.transfer(weiValue);
533     }
534 
535     /// @dev Minimum goal was reached
536     /// @return true if the crowdsale has raised enough money to not initiate the refunding
537     function isMinimumGoalReached() public constant returns (bool reached) {
538         return weiToUsdCents(weiRaised) >= MIN_PRE_FUNDING_GOAL;
539     }
540 
541     /// @dev Method set data from migrated contract
542     /// @param _tokensSold tokens sold
543     /// @param _weiRaised _wei raised
544     /// @param _investorCount investor count
545     function setCrowdsaleData(uint _tokensSold, uint _weiRaised, uint _investorCount) onlyOwner {
546         require(_tokensSold > 0);
547         require(_weiRaised > 0);
548         require(_investorCount > 0);
549 
550         tokensSold = _tokensSold;
551         weiRaised = _weiRaised;
552         investorCount = _investorCount;
553     }
554 
555     /// @dev Crowdfund state machine management.
556     /// @return State current state
557     function getState() public constant returns (State) {
558         if (finalized)
559         return State.Finalized;
560         if (address(token) == 0 || address(multisigWallet) == 0 || now < startsAt)
561         return State.Preparing;
562         if (now > startsAt && now < preIcoEndsAt - 2 days && !isMaximumPreFundingGoalReached())
563         return State.PreFunding;
564         if (isMinimumGoalReached())
565         return State.PreFundingSuccess;
566         if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
567         return State.Refunding;
568         return State.Failure;
569     }
570 
571     /// @dev Calculating tokens count
572     /// @param weiAmount invested
573     /// @return tokens amount
574     function calculateTokens(uint weiAmount) internal returns (uint tokenAmount) {
575         var multiplier = 10 ** token.decimals();
576 
577         uint usdAmount = weiToUsdCents(weiAmount);
578 
579         return safeMul(usdAmount, safeDiv(multiplier, PRICE));
580     }
581 
582     /// @dev Check if the pre ICO goal was reached.
583     /// @return true if the preICO has raised enough money to be a success
584     function isMaximumPreFundingGoalReached() public constant returns (bool reached) {
585         return weiToUsdCents(weiRaised) >= PRE_FUNDING_GOAL;
586     }
587 
588     /// @dev Converts wei value into USD cents according to current exchange rate
589     /// @param weiValue wei value to convert
590     /// @return USD cents equivalent of the wei value
591     function weiToUsdCents(uint weiValue) private returns (uint) {
592         return safeDiv(safeMul(weiValue, exchangeRate), 1e18);
593     }
594 
595     /// @dev Dynamically create tokens and assign them to the investor.
596     /// @param receiver investor address
597     /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
598     function assignTokens(address receiver, uint tokenAmount) private {
599         token.mint(receiver, tokenAmount);
600     }
601 }