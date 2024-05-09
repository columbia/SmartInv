1 pragma solidity ^0.4.13;
2 
3  /// @title SafeMath contract - math operations with safety checks
4  /// @author dev@smartcontracteam.com
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
51  /// @title Ownable contract - base contract with an owner
52  /// @author dev@smartcontracteam.com
53 contract Ownable {
54   address public owner;
55 
56   function Ownable() {
57     owner = msg.sender;
58   }
59 
60   modifier onlyOwner() {
61     require(msg.sender == owner);  
62     _;
63   }
64 
65   function transferOwnership(address newOwner) onlyOwner {
66     if (newOwner != address(0)) {
67       owner = newOwner;
68     }
69   }
70 }
71 
72 
73 /// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.
74 /// @author dev@smartcontracteam.com
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
100  /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
101  /// @author dev@smartcontracteam.com
102 contract Killable is Ownable {
103   function kill() onlyOwner {
104     selfdestruct(owner);
105   }
106 }
107 
108 
109  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
110  /// @author dev@smartcontracteam.com
111 contract ERC20 {
112   uint public totalSupply;
113   function balanceOf(address who) constant returns (uint);
114   function allowance(address owner, address spender) constant returns (uint);
115   function mint(address receiver, uint amount);
116   function transfer(address to, uint value) returns (bool ok);
117   function transferFrom(address from, address to, uint value) returns (bool ok);
118   function approve(address spender, uint value) returns (bool ok);
119   event Transfer(address indexed from, address indexed to, uint value);
120   event Approval(address indexed owner, address indexed spender, uint value);
121 }
122 
123 
124 /// @title ZiberToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
125 /// @author dev@smartcontracteam.com
126 contract ZiberToken is SafeMath, ERC20, Ownable {
127  string public name = "Ziber Token";
128  string public symbol = "ZBR";
129  uint public decimals = 8;
130  uint public constant FROZEN_TOKENS = 1e7;
131  uint public constant FREEZE_PERIOD = 1 years;
132  uint public crowdSaleOverTimestamp;
133 
134  /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
135  address public crowdsaleAgent;
136  /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
137  bool public released = false;
138  /// approve() allowances
139  mapping (address => mapping (address => uint)) allowed;
140  /// holder balances
141  mapping(address => uint) balances;
142 
143  /// @dev Limit token transfer until the crowdsale is over.
144  modifier canTransfer() {
145    if(!released) {
146      require(msg.sender == crowdsaleAgent);
147    }
148    _;
149  }
150 
151  modifier checkFrozenAmount(address source, uint amount) {
152    if (source == owner && now < crowdSaleOverTimestamp + FREEZE_PERIOD) {
153      var frozenTokens = 10 ** decimals * FROZEN_TOKENS;
154      require(safeSub(balances[owner], amount) > frozenTokens);
155    }
156    _;
157  }
158 
159  /// @dev The function can be called only before or after the tokens have been releasesd
160  /// @param _released token transfer and mint state
161  modifier inReleaseState(bool _released) {
162    require(_released == released);
163    _;
164  }
165 
166  /// @dev The function can be called only by release agent.
167  modifier onlyCrowdsaleAgent() {
168    require(msg.sender == crowdsaleAgent);
169    _;
170  }
171 
172  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
173  /// @param size payload size
174  modifier onlyPayloadSize(uint size) {
175    require(msg.data.length >= size + 4);
176     _;
177  }
178 
179  /// @dev Make sure we are not done yet.
180  modifier canMint() {
181    require(!released);
182     _;
183   }
184 
185  /// @dev Constructor
186  function ZiberToken() {
187    owner = msg.sender;
188  }
189 
190  /// Fallback method will buyout tokens
191  function() payable {
192    revert();
193  }
194  /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
195  /// @param receiver Address of receiver
196  /// @param amount  Number of tokens to issue.
197  function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {
198     totalSupply = safeAdd(totalSupply, amount);
199     balances[receiver] = safeAdd(balances[receiver], amount);
200     Transfer(0, receiver, amount);
201  }
202 
203  /// @dev Set the contract that can call release and make the token transferable.
204  /// @param _crowdsaleAgent crowdsale contract address
205  function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
206    crowdsaleAgent = _crowdsaleAgent;
207  }
208  /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
209  function releaseTokenTransfer() public onlyCrowdsaleAgent {
210    crowdSaleOverTimestamp = now;
211    released = true;
212  }
213  /// @dev Tranfer tokens to address
214  /// @param _to dest address
215  /// @param _value tokens amount
216  /// @return transfer result
217  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(msg.sender, _value) returns (bool success) {
218    balances[msg.sender] = safeSub(balances[msg.sender], _value);
219    balances[_to] = safeAdd(balances[_to], _value);
220 
221    Transfer(msg.sender, _to, _value);
222    return true;
223  }
224 
225  /// @dev Tranfer tokens from one address to other
226  /// @param _from source address
227  /// @param _to dest address
228  /// @param _value tokens amount
229  /// @return transfer result
230  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(_from, _value) returns (bool success) {
231     var _allowance = allowed[_from][msg.sender];
232 
233     balances[_to] = safeAdd(balances[_to], _value);
234     balances[_from] = safeSub(balances[_from], _value);
235     allowed[_from][msg.sender] = safeSub(_allowance, _value);
236     Transfer(_from, _to, _value);
237     return true;
238  }
239  /// @dev Tokens balance
240  /// @param _owner holder address
241  /// @return balance amount
242  function balanceOf(address _owner) constant returns (uint balance) {
243    return balances[_owner];
244  }
245 
246  /// @dev Approve transfer
247  /// @param _spender holder address
248  /// @param _value tokens amount
249  /// @return result
250  function approve(address _spender, uint _value) returns (bool success) {
251    // To change the approve amount you first have to reduce the addresses`
252    //  allowance to zero by calling `approve(_spender, 0)` if it is not
253    //  already 0 to mitigate the race condition described here:
254    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
256 
257    allowed[msg.sender][_spender] = _value;
258    Approval(msg.sender, _spender, _value);
259    return true;
260  }
261 
262  /// @dev Token allowance
263  /// @param _owner holder address
264  /// @param _spender spender address
265  /// @return remain amount
266  function allowance(address _owner, address _spender) constant returns (uint remaining) {
267    return allowed[_owner][_spender];
268  }
269 }
270 
271 
272 /// @title ZiberCrowdsale contract - contract for token sales.
273 /// @author dev@smartcontracteam.com
274 contract ZiberCrowdsale is Haltable, Killable, SafeMath {
275 
276   /// Total count of tokens distributed via ICO
277   uint public constant TOTAL_ICO_TOKENS = 100000000;
278 
279   /// Miminal tokens funding goal in Wei, if this goal isn't reached during ICO, refund will begin
280   uint public constant MIN_ICO_GOAL = 5000 ether;
281 
282   /// Maximal tokens funding goal in Wei
283   uint public constant MAX_ICO_GOAL = 50000 ether;
284   
285   /// the UNIX timestamp 5e4 ether funded
286   uint public maxGoalReachedAt = 0;
287 
288   /// The duration of ICO
289   uint public constant ICO_DURATION = 10 days;
290 
291   /// The duration of ICO
292   uint public constant AFTER_MAX_GOAL_DURATION = 24 hours;
293 
294   /// The token we are selling
295   ZiberToken public token;
296 
297   /// the UNIX timestamp start date of the crowdsale
298   uint public startsAt;
299 
300   /// How many wei of funding we have raised
301   uint public weiRaised = 0;
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
312   /// How much ETH each address has invested to this crowdsale
313   mapping (address => uint256) public investedAmountOf;
314 
315   /// How much tokens this crowdsale has credited for each investor address
316   mapping (address => uint256) public tokenAmountOf;
317 
318   /// Define a structure for one investment event occurrence
319   struct Investment {
320       /// Who invested
321       address source;
322       /// Amount invested
323       uint weiValue;
324   }
325 
326   Investment[] public investments;
327 
328   /// State machine
329   /// Preparing: All contract initialization calls and variables have not been set yet
330   /// Prefunding: We have not passed start time yet
331   /// Funding: Active crowdsale
332   /// Success: Minimum funding goal reached
333   /// Failure: Minimum funding goal not reached before ending time
334   /// Finalized: The finalized has been called and succesfully executed\
335   /// Refunding: Refunds are loaded on the contract for reclaim.
336   enum State {Unknown, Preparing, Funding, Success, Failure, Finalized, Refunding}
337 
338   /// A new investment was made
339   event Invested(address investor, uint weiAmount);
340   /// Refund was processed for a contributor
341   event Refund(address investor, uint weiAmount);
342 
343   /// @dev Modified allowing execution only if the crowdsale is currently running
344   modifier inState(State state) {
345     require(getState() == state);
346     _;
347   }
348 
349   /// @dev Constructor
350   /// @param _token Pay Fair token address
351   /// @param _start token ICO start date
352   function Crowdsale(address _token, uint _start) {
353     require(_token != 0);
354     require(_start != 0);
355 
356     owner = msg.sender;
357     token = ZiberToken(_token);
358     startsAt = _start;
359   }
360 
361   ///  Don't expect to just send in money and get tokens.
362   function() payable {
363     buy();
364   }
365 
366    /// @dev Make an investment. Crowdsale must be running for one to invest.
367    /// @param receiver The Ethereum address who receives the tokens
368   function investInternal(address receiver) stopInEmergency private {
369     var state = getState();
370     require(state == State.Funding);
371     require(msg.value > 0);
372 
373     // Add investment record
374     var weiAmount = msg.value;
375     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
376     investments.push(Investment(receiver, weiAmount));
377 
378     // Update totals
379     weiRaised = safeAdd(weiRaised, weiAmount);
380     // Max ICO goal reached at
381     if(maxGoalReachedAt == 0 && weiRaised >= MAX_ICO_GOAL)
382       maxGoalReachedAt = now;
383     // Tell us invest was success
384     Invested(receiver, weiAmount);
385   }
386 
387   /// @dev Allow anonymous contributions to this crowdsale.
388   /// @param receiver The Ethereum address who receives the tokens
389   function invest(address receiver) public payable {
390     investInternal(receiver);
391   }
392 
393   /// @dev The basic entry point to participate the crowdsale process.
394   function buy() public payable {
395     invest(msg.sender);
396   }
397 
398   /// @dev Finalize a succcesful crowdsale.
399   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
400     require(!finalized);
401 
402     finalized = true;
403     finalizeCrowdsale();
404   }
405 
406   /// @dev Owner can withdraw contract funds
407   function withdraw() public onlyOwner {
408     // Transfer funds to the team wallet
409     owner.transfer(this.balance);
410   }
411 
412   /// @dev Finalize a succcesful crowdsale.
413   function finalizeCrowdsale() internal {
414     // Calculate divisor of the total token count
415     uint divisor;
416     for (uint i = 0; i < investments.length; i++)
417        divisor = safeAdd(divisor, investments[i].weiValue);
418 
419     var multiplier = 10 ** token.decimals();
420     // Get unit price
421     uint unitPrice = safeDiv(safeMul(TOTAL_ICO_TOKENS, multiplier), divisor);
422 
423     // Distribute tokens among investors
424     for (i = 0; i < investments.length; i++) {
425         var tokenAmount = safeMul(unitPrice, investments[i].weiValue);
426         tokenAmountOf[investments[i].source] += tokenAmount;
427         assignTokens(investments[i].source, tokenAmount);
428     }
429     assignTokens(owner, 2e7);
430     token.releaseTokenTransfer();
431   }
432 
433   /// @dev Allow load refunds back on the contract for the refunding.
434   function loadRefund() public payable inState(State.Failure) {
435     require(msg.value > 0);
436     loadedRefund = safeAdd(loadedRefund, msg.value);
437   }
438 
439   /// @dev Investors can claim refund.
440   function refund() public inState(State.Refunding) {
441     uint256 weiValue = investedAmountOf[msg.sender];
442     if (weiValue == 0)
443       return;
444     investedAmountOf[msg.sender] = 0;
445     weiRefunded = safeAdd(weiRefunded, weiValue);
446     Refund(msg.sender, weiValue);
447     msg.sender.transfer(weiValue);
448   }
449 
450   /// @dev Minimum goal was reached
451   /// @return true if the crowdsale has raised enough money to not initiate the refunding
452   function isMinimumGoalReached() public constant returns (bool reached) {
453     return weiRaised >= MIN_ICO_GOAL;
454   }
455 
456   /// @dev Check if the ICO goal was reached.
457   /// @return true if the crowdsale has raised enough money to be a success
458   function isCrowdsaleFull() public constant returns (bool) {
459     return weiRaised >= MAX_ICO_GOAL && now > maxGoalReachedAt + AFTER_MAX_GOAL_DURATION;
460   }
461 
462   /// @dev Crowdfund state machine management.
463   /// @return State current state
464   function getState() public constant returns (State) {
465     if (finalized)
466       return State.Finalized;
467     if (address(token) == 0)
468       return State.Preparing;
469     if (now >= startsAt && now < startsAt + ICO_DURATION && !isCrowdsaleFull())
470       return State.Funding;
471     if (isCrowdsaleFull())
472       return State.Success;
473     if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
474       return State.Refunding;
475     return State.Failure;
476   }
477 
478    /// @dev Dynamically create tokens and assign them to the investor.
479    /// @param receiver investor address
480    /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
481    function assignTokens(address receiver, uint tokenAmount) private {
482      token.mint(receiver, tokenAmount);
483    }
484 }