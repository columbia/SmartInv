1 pragma solidity ^0.4.13;
2 
3  /// @title Ownable contract - base contract with an owner
4 contract Ownable {
5   address public owner;
6 
7   function Ownable() {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) onlyOwner {
17     if (newOwner != address(0)) {
18       owner = newOwner;
19     }
20   }
21 }
22 
23  /// @title SafeMath contract - math operations with safety checks
24 contract SafeMath {
25   function safeMul(uint a, uint b) internal returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function safeDiv(uint a, uint b) internal returns (uint) {
32     assert(b > 0);
33     uint c = a / b;
34     assert(a == b * c + a % b);
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint a, uint b) internal returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 
49   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50     return a >= b ? a : b;
51   }
52 
53   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54     return a < b ? a : b;
55   }
56 
57   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
58     return a >= b ? a : b;
59   }
60 
61   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
62     return a < b ? a : b;
63   }
64 }
65 
66 /// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.
67 /// Originally envisioned in FirstBlood ICO contract.
68 contract Haltable is Ownable {
69   bool public halted;
70 
71   modifier stopInEmergency {
72     require(!halted);
73     _;
74   }
75 
76   modifier onlyInEmergency {
77     require(halted);
78     _;
79   }
80 
81   /// called by the owner on emergency, triggers stopped state
82   function halt() external onlyOwner {
83     halted = true;
84   }
85 
86   /// called by the owner on end of emergency, returns to normal state
87   function unhalt() external onlyOwner onlyInEmergency {
88     halted = false;
89   }
90 }
91 
92  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
93 contract ERC20 {
94   uint public totalSupply;
95   function balanceOf(address who) constant returns (uint);
96   function allowance(address owner, address spender) constant returns (uint);
97   function mint(address receiver, uint amount);
98   function transfer(address to, uint value) returns (bool ok);
99   function transferFrom(address from, address to, uint value) returns (bool ok);
100   function approve(address spender, uint value) returns (bool ok);
101   event Transfer(address indexed from, address indexed to, uint value);
102   event Approval(address indexed owner, address indexed spender, uint value);
103 }
104 
105 
106 
107 /// @title PayFairToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
108 contract PayFairToken is SafeMath, ERC20, Ownable {
109  string public name = "PayFair Token";
110  string public symbol = "PFR";
111  uint public constant decimals = 8;
112  uint public constant FROZEN_TOKENS = 11e6;
113  uint public constant FREEZE_PERIOD = 1 years;
114  uint public constant MULTIPLIER = 10 ** decimals;
115  uint public crowdSaleOverTimestamp;
116 
117  /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
118  address public crowdsaleAgent;
119  /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
120  bool public released = false;
121  /// approve() allowances
122  mapping (address => mapping (address => uint)) allowed;
123  /// holder balances
124  mapping(address => uint) balances;
125 
126  /// @dev Limit token transfer until the crowdsale is over.
127  modifier canTransfer() {
128    if(!released) {
129       require(msg.sender == crowdsaleAgent);
130    }
131    _;
132  }
133 
134  modifier checkFrozenAmount(address source, uint amount) {
135    if (source == owner && now < crowdSaleOverTimestamp + FREEZE_PERIOD) {
136      var frozenTokens = 10 ** decimals * FROZEN_TOKENS;
137      require(safeSub(balances[owner], amount) > frozenTokens);
138    }
139    _;
140  }
141 
142  /// @dev The function can be called only before or after the tokens have been releasesd
143  /// @param _released token transfer and mint state
144  modifier inReleaseState(bool _released) {
145    require(_released == released);
146    _;
147  }
148 
149  /// @dev The function can be called only by release agent.
150  modifier onlyCrowdsaleAgent() {
151    require(msg.sender == crowdsaleAgent);
152    _;
153  }
154 
155  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
156  /// @param size payload size
157  modifier onlyPayloadSize(uint size) {
158     require(msg.data.length >= size + 4);
159     _;
160  }
161 
162  /// @dev Make sure we are not done yet.
163  modifier canMint() {
164     require(!released);
165     _;
166   }
167 
168  /// @dev Constructor
169  function PayFairToken() {
170    owner = msg.sender;
171  }
172 
173  /// Fallback method will buyout tokens
174  function() payable {
175    revert();
176  }
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
193    crowdSaleOverTimestamp = now;
194    released = true;
195  }
196 
197  /// @dev Converts token value to value with decimal places
198  /// @param amount Source token value
199  function convertToDecimal(uint amount) public constant returns (uint) {
200    return safeMul(amount, MULTIPLIER);
201  }
202 
203  /// @dev Tranfer tokens to address
204  /// @param _to dest address
205  /// @param _value tokens amount
206  /// @return transfer result
207  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(msg.sender, _value) returns (bool success) {
208    balances[msg.sender] = safeSub(balances[msg.sender], _value);
209    balances[_to] = safeAdd(balances[_to], _value);
210 
211    Transfer(msg.sender, _to, _value);
212    return true;
213  }
214 
215  /// @dev Tranfer tokens from one address to other
216  /// @param _from source address
217  /// @param _to dest address
218  /// @param _value tokens amount
219  /// @return transfer result
220  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(_from, _value) returns (bool success) {
221     var _allowance = allowed[_from][msg.sender];
222 
223     balances[_to] = safeAdd(balances[_to], _value);
224     balances[_from] = safeSub(balances[_from], _value);
225     allowed[_from][msg.sender] = safeSub(_allowance, _value);
226     Transfer(_from, _to, _value);
227     return true;
228  }
229  /// @dev Tokens balance
230  /// @param _owner holder address
231  /// @return balance amount
232  function balanceOf(address _owner) constant returns (uint balance) {
233    return balances[_owner];
234  }
235 
236  /// @dev Approve transfer
237  /// @param _spender holder address
238  /// @param _value tokens amount
239  /// @return result
240  function approve(address _spender, uint _value) returns (bool success) {
241    // To change the approve amount you first have to reduce the addresses`
242    //  allowance to zero by calling `approve(_spender, 0)` if it is not
243    //  already 0 to mitigate the race condition described here:
244    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
246 
247    allowed[msg.sender][_spender] = _value;
248    Approval(msg.sender, _spender, _value);
249    return true;
250  }
251 
252  /// @dev Token allowance
253  /// @param _owner holder address
254  /// @param _spender spender address
255  /// @return remain amount
256  function allowance(address _owner, address _spender) constant returns (uint remaining) {
257    return allowed[_owner][_spender];
258  }
259 }
260 
261  /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
262 contract Killable is Ownable {
263   function kill() onlyOwner {
264     selfdestruct(owner);
265   }
266 }
267 
268 /// @title PayFairTokenCrowdsale contract - contract for token sales.
269 contract PayFairTokenCrowdsale is Haltable, Killable, SafeMath {
270 
271   /// Total count of tokens distributed via ICO
272   uint public constant TOTAL_ICO_TOKENS = 56e6;
273 
274   /// Total count of tokens distributed manually on the pre-ICO stage
275   uint public constant PRE_ICO_MAX_TOKENS = 33e6;
276 
277   /// Miminal tokens funding goal in Wei, if this goal isn't reached during ICO, refund will begin
278   uint public constant MIN_ICO_GOAL = 1 ether;
279 
280   /// The duration of ICO
281   uint public constant ICO_DURATION = 30 days;
282 
283   /// The token we are selling
284   PayFairToken public token;
285 
286   /// tokens will be transfered from this address
287   address public multisigWallet;
288 
289   /// the UNIX timestamp start date of the crowdsale
290   uint public startsAt;
291 
292   /// How many wei of funding we have raised
293   uint public weiRaised = 0;
294 
295   /// How much wei we have returned back to the contract after a failed crowdfund.
296   uint public loadedRefund = 0;
297 
298   /// How much wei we have given back to investors.
299   uint public weiRefunded = 0;
300 
301   /// Total count of tokens distributed via pre-ICO
302   uint public preIcoTokensDistributed = 0;
303 
304   /// Has this crowdsale been finalized
305   bool public finalized;
306 
307   /// How much ETH each address has invested to this crowdsale
308   mapping (address => uint256) public investedAmountOf;
309 
310   /// How much tokens this crowdsale has credited for each investor address
311   mapping (address => uint256) public tokenAmountOf;
312 
313   /// Define preICO pricing schedule using milestones.
314   struct Milestone {
315       // UNIX timestamp when this milestone kicks in
316       uint start;
317       // UNIX timestamp when this milestone kicks out
318       uint end;
319       // How many % tokens will add
320       uint bonus;
321   }
322 
323   /// Define a structure for one investment event occurrence
324   struct Investment {
325       /// Who invested
326       address source;
327 
328       /// Weight coefficient of investment (early investment bonus) in %
329       uint weight;
330 
331       /// Amount invested
332       uint weiValue;
333   }
334 
335   Milestone[] public milestones;
336   Investment[] public investments;
337 
338   /// State machine
339   /// Preparing: All contract initialization calls and variables have not been set yet
340   /// Prefunding: We have not passed start time yet
341   /// Funding: Active crowdsale
342   /// Success: Minimum funding goal reached
343   /// Failure: Minimum funding goal not reached before ending time
344   /// Finalized: The finalized has been called and succesfully executed\
345   /// Refunding: Refunds are loaded on the contract for reclaim.
346   enum State {Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
347 
348   /// A new investment was made
349   event Invested(address investor, uint weiAmount);
350   /// Refund was processed for a contributor
351   event Refund(address investor, uint weiAmount);
352 
353   /// @dev Modified allowing execution only if the crowdsale is currently running
354   modifier inState(State state) {
355     require(getState() == state);
356     _;
357   }
358 
359   /// @dev Constructor
360   /// @param _token Pay Fair token address
361   /// @param _multisigWallet team wallet
362   /// @param _start token ICO start date
363   function PayFairTokenCrowdsale(address _token, address _multisigWallet, uint _start) {
364     require(_multisigWallet != 0);
365     require(_start != 0);
366 
367     token = PayFairToken(_token);
368 
369     multisigWallet = _multisigWallet;
370     startsAt = _start;
371 
372     milestones.push(Milestone(startsAt, startsAt + 1 days, 20));
373     milestones.push(Milestone(startsAt + 1 days, startsAt + 5 days, 15));
374     milestones.push(Milestone(startsAt + 5 days, startsAt + 10 days, 10));
375     milestones.push(Milestone(startsAt + 10 days, startsAt + 20 days, 5));
376   }
377 
378   ///  Don't expect to just send in money and get tokens.
379   function() payable {
380     buy();
381   }
382 
383   /// @dev Get the current milestone or bail out if we are not in the milestone periods.
384   /// @return Milestone current bonus milestone
385   function getCurrentMilestone() private constant returns (Milestone) {
386     for (uint i = 0; i < milestones.length; i++) {
387       if (milestones[i].start <= now && milestones[i].end > now) {
388         return milestones[i];
389       }
390    }
391  }
392 
393    /// @dev Make an investment. Crowdsale must be running for one to invest.
394    /// @param receiver The Ethereum address who receives the tokens
395   function investInternal(address receiver) stopInEmergency private {
396     var state = getState();
397     require(state == State.Funding);
398     require(msg.value > 0);
399 
400     // Add investment record
401     var weiAmount = msg.value;
402     investments.push(Investment(receiver, weiAmount, getCurrentMilestone().bonus + 100));
403     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
404 
405     // Update totals
406     weiRaised = safeAdd(weiRaised, weiAmount);
407     // Transfer funds to the team wallet
408     multisigWallet.transfer(weiAmount);
409     // Tell us invest was success
410     Invested(receiver, weiAmount);
411   }
412 
413   /// @dev Allow anonymous contributions to this crowdsale.
414   /// @param receiver The Ethereum address who receives the tokens
415   function invest(address receiver) public payable {
416     investInternal(receiver);
417   }
418 
419   function sendPreIcoTokens(address receiver, uint amount) public inState(State.PreFunding) onlyOwner {
420     require(receiver != 0);
421     require(amount > 0);
422     require(safeAdd(preIcoTokensDistributed, amount) <= token.convertToDecimal(PRE_ICO_MAX_TOKENS));
423 
424     preIcoTokensDistributed = safeAdd(preIcoTokensDistributed, amount);
425     assignTokens(receiver, amount);
426   }
427 
428   /// @dev The basic entry point to participate the crowdsale process.
429   function buy() public payable {
430     invest(msg.sender);
431   }
432 
433   /// @dev Finalize a succcesful crowdsale.
434   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
435     require(!finalized);
436 
437     finalized = true;
438     finalizeCrowdsale();
439   }
440 
441   /// @dev Finalize a succcesful crowdsale.
442   function finalizeCrowdsale() internal {
443     // Calculate divisor of the total token count
444     uint divisor;
445     for (uint i = 0; i < investments.length; i++)
446        divisor = safeAdd(divisor, safeMul(investments[i].weiValue, investments[i].weight));
447 
448     uint localMultiplier = 10 ** 12;
449     // Get unit price
450     uint unitPrice = safeDiv(safeMul(token.convertToDecimal(TOTAL_ICO_TOKENS), localMultiplier), divisor);
451 
452     // Distribute tokens among investors
453     for (i = 0; i < investments.length; i++) {
454         var tokenAmount = safeDiv(safeMul(unitPrice, safeMul(investments[i].weiValue, investments[i].weight)), localMultiplier);
455         tokenAmountOf[investments[i].source] += tokenAmount;
456         assignTokens(investments[i].source, tokenAmount);
457     }
458 
459     token.releaseTokenTransfer();
460   }
461 
462   /// @dev Allow load refunds back on the contract for the refunding.
463   function loadRefund() public payable inState(State.Failure) {
464     require(msg.value > 0);
465     loadedRefund = safeAdd(loadedRefund, msg.value);
466   }
467 
468   /// @dev Investors can claim refund.
469   function refund() public inState(State.Refunding) {
470     uint256 weiValue = investedAmountOf[msg.sender];
471     if (weiValue == 0)
472       return;
473     investedAmountOf[msg.sender] = 0;
474     weiRefunded = safeAdd(weiRefunded, weiValue);
475     Refund(msg.sender, weiValue);
476     msg.sender.transfer(weiValue);
477   }
478 
479   /// @dev Minimum goal was reached
480   /// @return true if the crowdsale has raised enough money to not initiate the refunding
481   function isMinimumGoalReached() public constant returns (bool reached) {
482     return weiRaised >= MIN_ICO_GOAL;
483   }
484 
485   /// @dev Check if the ICO goal was reached.
486   /// @return true if the crowdsale has raised enough money to be a success
487   function isCrowdsaleFull() public constant returns (bool) {
488     return isMinimumGoalReached() && now > startsAt + ICO_DURATION;
489   }
490 
491   /// @dev Crowdfund state machine management.
492   /// @return State current state
493   function getState() public constant returns (State) {
494     if (finalized)
495       return State.Finalized;
496     if (address(token) == 0 || address(multisigWallet) == 0)
497       return State.Preparing;
498     if (preIcoTokensDistributed < token.convertToDecimal(PRE_ICO_MAX_TOKENS))
499         return State.PreFunding;
500     if (now >= startsAt && now < startsAt + ICO_DURATION && !isCrowdsaleFull())
501       return State.Funding;
502     if (isMinimumGoalReached())
503       return State.Success;
504     if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
505       return State.Refunding;
506     return State.Failure;
507   }
508 
509   
510    /// @dev Dynamically create tokens and assign them to the investor.
511    /// @param receiver investor address
512    /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
513    function assignTokens(address receiver, uint tokenAmount) private {
514      token.mint(receiver, tokenAmount);
515    }
516 }