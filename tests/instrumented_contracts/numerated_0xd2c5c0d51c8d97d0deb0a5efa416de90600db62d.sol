1 pragma solidity ^0.4.13;
2 
3 pragma solidity ^0.4.13;
4 
5  /// @title SafeMath contract - math operations with safety checks
6  /// @author dev@smartcontracteam.com
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     require(assertion);  
50   }
51 }
52 
53 pragma solidity ^0.4.13;
54 
55 pragma solidity ^0.4.13;
56 
57  /// @title Ownable contract - base contract with an owner
58  /// @author dev@smartcontracteam.com
59 contract Ownable {
60   address public owner;
61 
62   function Ownable() {
63     owner = msg.sender;
64   }
65 
66   modifier onlyOwner() {
67     require(msg.sender == owner);  
68     _;
69   }
70 
71   function transferOwnership(address newOwner) onlyOwner {
72     if (newOwner != address(0)) {
73       owner = newOwner;
74     }
75   }
76 }
77 
78 
79 /// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.
80 /// @author dev@smartcontracteam.com
81 /// Originally envisioned in FirstBlood ICO contract.
82 contract Haltable is Ownable {
83   bool public halted;
84 
85   modifier stopInEmergency {
86     require(!halted);
87     _;
88   }
89 
90   modifier onlyInEmergency {
91     require(halted);       
92     _;
93   }
94 
95   /// called by the owner on emergency, triggers stopped state
96   function halt() external onlyOwner {
97     halted = true;
98   }
99 
100   /// called by the owner on end of emergency, returns to normal state
101   function unhalt() external onlyOwner onlyInEmergency {
102     halted = false;
103   }
104 }
105 
106 pragma solidity ^0.4.13;
107 
108 pragma solidity ^0.4.13;
109 
110  
111 
112 
113  /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
114  /// @author dev@smartcontracteam.com
115 contract Killable is Ownable {
116   function kill() onlyOwner {
117     selfdestruct(owner);
118   }
119 }
120 
121 pragma solidity ^0.4.13;
122 
123 pragma solidity ^0.4.13;
124 
125  
126 
127 pragma solidity ^0.4.13;
128 
129  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
130  /// @author dev@smartcontracteam.com
131 contract ERC20 {
132   uint public totalSupply;
133   function balanceOf(address who) constant returns (uint);
134   function allowance(address owner, address spender) constant returns (uint);
135   function mint(address receiver, uint amount);
136   function transfer(address to, uint value) returns (bool ok);
137   function transferFrom(address from, address to, uint value) returns (bool ok);
138   function approve(address spender, uint value) returns (bool ok);
139   event Transfer(address indexed from, address indexed to, uint value);
140   event Approval(address indexed owner, address indexed spender, uint value);
141 }
142 
143 pragma solidity ^0.4.13;
144 
145  
146 
147 
148 /// @title ZiberToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
149 /// @author dev@smartcontracteam.com
150 contract ZiberToken is SafeMath, ERC20, Ownable {
151  string public name = "Ziber Token";
152  string public symbol = "ZBR";
153  uint public decimals = 8;
154  uint public constant FROZEN_TOKENS = 1e7;
155  uint public constant FREEZE_PERIOD = 1 years;
156  uint public crowdSaleOverTimestamp;
157 
158  /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
159  address public crowdsaleAgent;
160  /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
161  bool public released = false;
162  /// approve() allowances
163  mapping (address => mapping (address => uint)) allowed;
164  /// holder balances
165  mapping(address => uint) balances;
166 
167  /// @dev Limit token transfer until the crowdsale is over.
168  modifier canTransfer() {
169    if(!released) {
170      require(msg.sender == crowdsaleAgent);
171    }
172    _;
173  }
174 
175  modifier checkFrozenAmount(address source, uint amount) {
176    if (source == owner && now < crowdSaleOverTimestamp + FREEZE_PERIOD) {
177      var frozenTokens = 10 ** decimals * FROZEN_TOKENS;
178      require(safeSub(balances[owner], amount) > frozenTokens);
179    }
180    _;
181  }
182 
183  /// @dev The function can be called only before or after the tokens have been releasesd
184  /// @param _released token transfer and mint state
185  modifier inReleaseState(bool _released) {
186    require(_released == released);
187    _;
188  }
189 
190  /// @dev The function can be called only by release agent.
191  modifier onlyCrowdsaleAgent() {
192    require(msg.sender == crowdsaleAgent);
193    _;
194  }
195 
196  /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
197  /// @param size payload size
198  modifier onlyPayloadSize(uint size) {
199    require(msg.data.length >= size + 4);
200     _;
201  }
202 
203  /// @dev Make sure we are not done yet.
204  modifier canMint() {
205    require(!released);
206     _;
207   }
208 
209  /// @dev Constructor
210  function ZiberToken() {
211    owner = msg.sender;
212  }
213 
214  /// Fallback method will buyout tokens
215  function() payable {
216    revert();
217  }
218  /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
219  /// @param receiver Address of receiver
220  /// @param amount  Number of tokens to issue.
221  function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {
222     totalSupply = safeAdd(totalSupply, amount);
223     balances[receiver] = safeAdd(balances[receiver], amount);
224     Transfer(0, receiver, amount);
225  }
226 
227  /// @dev Set the contract that can call release and make the token transferable.
228  /// @param _crowdsaleAgent crowdsale contract address
229  function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
230    crowdsaleAgent = _crowdsaleAgent;
231  }
232  /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
233  function releaseTokenTransfer() public onlyCrowdsaleAgent {
234    crowdSaleOverTimestamp = now;
235    released = true;
236  }
237  /// @dev Tranfer tokens to address
238  /// @param _to dest address
239  /// @param _value tokens amount
240  /// @return transfer result
241  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(msg.sender, _value) returns (bool success) {
242    balances[msg.sender] = safeSub(balances[msg.sender], _value);
243    balances[_to] = safeAdd(balances[_to], _value);
244 
245    Transfer(msg.sender, _to, _value);
246    return true;
247  }
248 
249  /// @dev Tranfer tokens from one address to other
250  /// @param _from source address
251  /// @param _to dest address
252  /// @param _value tokens amount
253  /// @return transfer result
254  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(_from, _value) returns (bool success) {
255     var _allowance = allowed[_from][msg.sender];
256 
257     balances[_to] = safeAdd(balances[_to], _value);
258     balances[_from] = safeSub(balances[_from], _value);
259     allowed[_from][msg.sender] = safeSub(_allowance, _value);
260     Transfer(_from, _to, _value);
261     return true;
262  }
263  /// @dev Tokens balance
264  /// @param _owner holder address
265  /// @return balance amount
266  function balanceOf(address _owner) constant returns (uint balance) {
267    return balances[_owner];
268  }
269 
270  /// @dev Approve transfer
271  /// @param _spender holder address
272  /// @param _value tokens amount
273  /// @return result
274  function approve(address _spender, uint _value) returns (bool success) {
275    // To change the approve amount you first have to reduce the addresses`
276    //  allowance to zero by calling `approve(_spender, 0)` if it is not
277    //  already 0 to mitigate the race condition described here:
278    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279    require(_value == 0 && allowed[msg.sender][_spender] == 0);
280 
281    allowed[msg.sender][_spender] = _value;
282    Approval(msg.sender, _spender, _value);
283    return true;
284  }
285 
286  /// @dev Token allowance
287  /// @param _owner holder address
288  /// @param _spender spender address
289  /// @return remain amount
290  function allowance(address _owner, address _spender) constant returns (uint remaining) {
291    return allowed[_owner][_spender];
292  }
293 }
294 
295 
296 /// @title ZiberCrowdsale contract - contract for token sales.
297 /// @author dev@smartcontracteam.com
298 contract ZiberCrowdsale is Haltable, Killable, SafeMath {
299 
300   /// Total count of tokens distributed via ICO
301   uint public constant TOTAL_ICO_TOKENS = 1e8;
302 
303   /// Miminal tokens funding goal in Wei, if this goal isn't reached during ICO, refund will begin
304   uint public constant MIN_ICO_GOAL = 5e3 ether;
305 
306   /// Maximal tokens funding goal in Wei
307   uint public constant MAX_ICO_GOAL = 5e4 ether;
308 
309   /// the UNIX timestamp 5e4 ether funded
310   uint public maxGoalReachedAt = 0;
311 
312   /// The duration of ICO
313   uint public constant ICO_DURATION = 10 days;
314 
315   /// The duration of ICO
316   uint public constant AFTER_MAX_GOAL_DURATION = 24 hours;
317 
318   /// The token we are selling
319   ZiberToken public token;
320 
321   /// the UNIX timestamp start date of the crowdsale
322   uint public startsAt;
323 
324   /// How many wei of funding we have raised
325   uint public weiRaised = 0;
326 
327   /// How much wei we have returned back to the contract after a failed crowdfund.
328   uint public loadedRefund = 0;
329 
330   /// How much wei we have given back to investors.
331   uint public weiRefunded = 0;
332 
333   /// Has this crowdsale been finalized
334   bool public finalized;
335 
336   /// How much ETH each address has invested to this crowdsale
337   mapping (address => uint256) public investedAmountOf;
338 
339   /// How much tokens this crowdsale has credited for each investor address
340   mapping (address => uint256) public tokenAmountOf;
341 
342   /// Define a structure for one investment event occurrence
343   struct Investment {
344       /// Who invested
345       address source;
346       /// Amount invested
347       uint weiValue;
348   }
349 
350   Investment[] public investments;
351 
352   /// State machine
353   /// Preparing: All contract initialization calls and variables have not been set yet
354   /// Prefunding: We have not passed start time yet
355   /// Funding: Active crowdsale
356   /// Success: Minimum funding goal reached
357   /// Failure: Minimum funding goal not reached before ending time
358   /// Finalized: The finalized has been called and succesfully executed\
359   /// Refunding: Refunds are loaded on the contract for reclaim.
360   enum State {Unknown, Preparing, Funding, Success, Failure, Finalized, Refunding}
361 
362   /// A new investment was made
363   event Invested(address investor, uint weiAmount);
364   /// Refund was processed for a contributor
365   event Refund(address investor, uint weiAmount);
366 
367   /// @dev Modified allowing execution only if the crowdsale is currently running
368   modifier inState(State state) {
369     require(getState() == state);
370     _;
371   }
372 
373   /// @dev Constructor
374   /// @param _token Pay Fair token address
375   /// @param _start token ICO start date
376   function Crowdsale(address _token, uint _start) {
377     require(_token != 0);
378     require(_start != 0);
379 
380     owner = msg.sender;
381     token = ZiberToken(_token);
382     startsAt = _start;
383   }
384 
385   ///  Don't expect to just send in money and get tokens.
386   function() payable {
387     buy();
388   }
389 
390    /// @dev Make an investment. Crowdsale must be running for one to invest.
391    /// @param receiver The Ethereum address who receives the tokens
392   function investInternal(address receiver) stopInEmergency private {
393     var state = getState();
394     require(state == State.Funding);
395     require(msg.value > 0);
396 
397     // Add investment record
398     var weiAmount = msg.value;
399     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
400     investments.push(Investment(receiver, weiAmount));
401 
402     // Update totals
403     weiRaised = safeAdd(weiRaised, weiAmount);
404     // Max ICO goal reached at
405     if(maxGoalReachedAt == 0 && weiRaised >= MAX_ICO_GOAL)
406       maxGoalReachedAt = now;
407     // Tell us invest was success
408     Invested(receiver, weiAmount);
409   }
410 
411   /// @dev Allow anonymous contributions to this crowdsale.
412   /// @param receiver The Ethereum address who receives the tokens
413   function invest(address receiver) public payable {
414     investInternal(receiver);
415   }
416 
417   /// @dev The basic entry point to participate the crowdsale process.
418   function buy() public payable {
419     invest(msg.sender);
420   }
421 
422   /// @dev Finalize a succcesful crowdsale.
423   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
424     require(!finalized);
425 
426     finalized = true;
427     finalizeCrowdsale();
428   }
429 
430   /// @dev Owner can withdraw contract funds
431   function withdraw() public onlyOwner {
432     // Transfer funds to the team wallet
433     owner.transfer(this.balance);
434   }
435 
436   /// @dev Finalize a succcesful crowdsale.
437   function finalizeCrowdsale() internal {
438     // Calculate divisor of the total token count
439     uint divisor;
440     for (uint i = 0; i < investments.length; i++)
441        divisor = safeAdd(divisor, investments[i].weiValue);
442 
443     var multiplier = 10 ** token.decimals();
444     // Get unit price
445     uint unitPrice = safeDiv(safeMul(TOTAL_ICO_TOKENS, multiplier), divisor);
446 
447     // Distribute tokens among investors
448     for (i = 0; i < investments.length; i++) {
449         var tokenAmount = safeMul(unitPrice, investments[i].weiValue);
450         tokenAmountOf[investments[i].source] += tokenAmount;
451         assignTokens(investments[i].source, tokenAmount);
452     }
453     assignTokens(owner, 2e7);
454     token.releaseTokenTransfer();
455   }
456 
457   /// @dev Allow load refunds back on the contract for the refunding.
458   function loadRefund() public payable inState(State.Failure) {
459     require(msg.value > 0);
460     loadedRefund = safeAdd(loadedRefund, msg.value);
461   }
462 
463   /// @dev Investors can claim refund.
464   function refund() public inState(State.Refunding) {
465     uint256 weiValue = investedAmountOf[msg.sender];
466     if (weiValue == 0)
467       return;
468     investedAmountOf[msg.sender] = 0;
469     weiRefunded = safeAdd(weiRefunded, weiValue);
470     Refund(msg.sender, weiValue);
471     msg.sender.transfer(weiValue);
472   }
473 
474   /// @dev Minimum goal was reached
475   /// @return true if the crowdsale has raised enough money to not initiate the refunding
476   function isMinimumGoalReached() public constant returns (bool reached) {
477     return weiRaised >= MIN_ICO_GOAL;
478   }
479 
480   /// @dev Check if the ICO goal was reached.
481   /// @return true if the crowdsale has raised enough money to be a success
482   function isCrowdsaleFull() public constant returns (bool) {
483     return weiRaised >= MAX_ICO_GOAL && now > maxGoalReachedAt + AFTER_MAX_GOAL_DURATION;
484   }
485 
486   /// @dev Crowdfund state machine management.
487   /// @return State current state
488   function getState() public constant returns (State) {
489     if (finalized)
490       return State.Finalized;
491     if (address(token) == 0)
492       return State.Preparing;
493     if (now >= startsAt && now < startsAt + ICO_DURATION && !isCrowdsaleFull())
494       return State.Funding;
495     if (isCrowdsaleFull())
496       return State.Success;
497     if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
498       return State.Refunding;
499     return State.Failure;
500   }
501 
502    /// @dev Dynamically create tokens and assign them to the investor.
503    /// @param receiver investor address
504    /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
505    function assignTokens(address receiver, uint tokenAmount) private {
506      token.mint(receiver, tokenAmount);
507    }
508 }