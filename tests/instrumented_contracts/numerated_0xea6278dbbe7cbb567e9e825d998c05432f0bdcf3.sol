1 pragma solidity ^0.4.14;
2 
3  /// @title SafeMath contract - math operations with safety checks
4 contract SafeMath {
5   function safeMul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 
18   function safeSub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function safeAdd(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 }
45 /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
46 contract ERC20 {
47  uint public totalSupply;
48  function balanceOf(address who) constant returns (uint);
49  function allowance(address owner, address spender) constant returns (uint);
50  function mint(address receiver, uint amount);
51  function transfer(address to, uint value) returns (bool ok);
52  function transferFrom(address from, address to, uint value) returns (bool ok);
53  function approve(address spender, uint value) returns (bool ok);
54  event Transfer(address indexed from, address indexed to, uint value);
55  event Approval(address indexed owner, address indexed spender, uint value);
56 }
57 
58 /// @title Ownable contract - base contract with an owner
59 contract Ownable {
60  address public owner;
61 
62  function Ownable() {
63    owner = msg.sender;
64  }
65 
66  modifier onlyOwner() {
67    require(msg.sender == owner);
68    _;
69  }
70 
71  function transferOwnership(address newOwner) onlyOwner {
72    if (newOwner != address(0)) {
73      owner = newOwner;
74    }
75  }
76 }
77 
78 /// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.
79 /// Originally envisioned in FirstBlood ICO contract.
80 contract Haltable is Ownable {
81   bool public halted;
82 
83   modifier stopInEmergency {
84     require(!halted);
85     _;
86   }
87 
88   modifier onlyInEmergency {
89     require(halted);
90     _;
91   }
92 
93   /// called by the owner on emergency, triggers stopped state
94   function halt() external onlyOwner {
95     halted = true;
96   }
97 
98   /// called by the owner on end of emergency, returns to normal state
99   function unhalt() external onlyOwner onlyInEmergency {
100     halted = false;
101   }
102 }
103  /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.
104 contract Killable is Ownable {
105   function kill() onlyOwner {
106     selfdestruct(owner);
107   }
108 }
109  /// @title SilentNotaryToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
110 contract SilentNotaryToken is SafeMath, ERC20, Killable {
111   string constant public name = "Silent Notary Token";
112   string constant public symbol = "SNTR";
113   uint constant public decimals = 4;
114   /// Buyout price
115   uint constant public buyOutPrice = 200 finney;
116   /// Holder list
117   address[] public holders;
118   /// Balance data
119   struct Balance {
120     /// Tokens amount
121     uint value;
122     /// Object exist
123     bool exist;
124   }
125   /// Holder balances
126   mapping(address => Balance) public balances;
127   /// Contract that is allowed to create new tokens and allows unlift the transfer limits on this token
128   address public crowdsaleAgent;
129   /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.
130   bool public released = false;
131   /// approve() allowances
132   mapping (address => mapping (address => uint)) allowed;
133 
134   /// @dev Limit token transfer until the crowdsale is over.
135   modifier canTransfer() {
136     if(!released)
137       require(msg.sender == crowdsaleAgent);
138     _;
139   }
140 
141   /// @dev The function can be called only before or after the tokens have been releasesd
142   /// @param _released token transfer and mint state
143   modifier inReleaseState(bool _released) {
144     require(_released == released);
145     _;
146   }
147 
148   /// @dev If holder does not exist add to array
149   /// @param holder Token holder
150   modifier addIfNotExist(address holder) {
151     if(!balances[holder].exist)
152       holders.push(holder);
153     _;
154   }
155 
156   /// @dev The function can be called only by release agent.
157   modifier onlyCrowdsaleAgent() {
158     require(msg.sender == crowdsaleAgent);
159     _;
160   }
161 
162   /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
163   /// @param size payload size
164   modifier onlyPayloadSize(uint size) {
165     require(msg.data.length >= size + 4);
166     _;
167   }
168 
169   /// @dev Make sure we are not done yet.
170   modifier canMint() {
171     require(!released);
172     _;
173   }
174 
175   /// Tokens burn event
176   event Burned(address indexed burner, address indexed holder, uint burnedAmount);
177   /// Tokens buyout event
178   event Pay(address indexed to, uint value);
179   /// Wei deposit event
180   event Deposit(address indexed from, uint value);
181 
182   /// @dev Constructor
183   function SilentNotaryToken() {
184   }
185 
186   /// Fallback method
187   function() payable {
188     require(msg.value > 0);
189     Deposit(msg.sender, msg.value);
190   }
191   /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
192   /// @param receiver Address of receiver
193   /// @param amount  Number of tokens to issue.
194   function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint addIfNotExist(receiver) public {
195       totalSupply = safeAdd(totalSupply, amount);
196       balances[receiver].value = safeAdd(balances[receiver].value, amount);
197       balances[receiver].exist = true;
198       Transfer(0, receiver, amount);
199   }
200 
201   /// @dev Set the contract that can call release and make the token transferable.
202   /// @param _crowdsaleAgent crowdsale contract address
203   function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {
204     crowdsaleAgent = _crowdsaleAgent;
205   }
206   /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
207   function releaseTokenTransfer() public onlyCrowdsaleAgent {
208     released = true;
209   }
210   /// @dev Tranfer tokens to address
211   /// @param _to dest address
212   /// @param _value tokens amount
213   /// @return transfer result
214   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer addIfNotExist(_to) returns (bool success) {
215     balances[msg.sender].value = safeSub(balances[msg.sender].value, _value);
216     balances[_to].value = safeAdd(balances[_to].value, _value);
217     balances[_to].exist = true;
218     Transfer(msg.sender, _to, _value);
219     return true;
220   }
221 
222   /// @dev Tranfer tokens from one address to other
223   /// @param _from source address
224   /// @param _to dest address
225   /// @param _value tokens amount
226   /// @return transfer result
227   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer addIfNotExist(_to) returns (bool success) {
228     var _allowance = allowed[_from][msg.sender];
229 
230     balances[_to].value = safeAdd(balances[_to].value, _value);
231     balances[_from].value = safeSub(balances[_from].value, _value);
232     balances[_to].exist = true;
233 
234     allowed[_from][msg.sender] = safeSub(_allowance, _value);
235     Transfer(_from, _to, _value);
236     return true;
237   }
238   /// @dev Tokens balance
239   /// @param _owner holder address
240   /// @return balance amount
241   function balanceOf(address _owner) constant returns (uint balance) {
242     return balances[_owner].value;
243   }
244 
245   /// @dev Approve transfer
246   /// @param _spender holder address
247   /// @param _value tokens amount
248   /// @return result
249   function approve(address _spender, uint _value) returns (bool success) {
250     // To change the approve amount you first have to reduce the addresses`
251     //  allowance to zero by calling `approve(_spender, 0)` if it is not
252     //  already 0 to mitigate the race condition described here:
253     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254     require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
255 
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /// @dev Token allowance
262   /// @param _owner holder address
263   /// @param _spender spender address
264   /// @return remain amount
265   function allowance(address _owner, address _spender) constant returns (uint remaining) {
266     return allowed[_owner][_spender];
267   }
268   /// @dev buyout method
269   /// @param _holder holder address
270   /// @param _amount wei for buyout tokens
271   function buyout(address _holder, uint _amount) onlyOwner addIfNotExist(msg.sender) external  {
272     require(_holder != msg.sender);
273     require(this.balance >= _amount);
274     require(buyOutPrice <= _amount);
275 
276     uint multiplier = 10 ** decimals;
277     uint buyoutTokens = safeDiv(safeMul(_amount, multiplier), buyOutPrice);
278 
279     balances[msg.sender].value = safeAdd(balances[msg.sender].value, buyoutTokens);
280     balances[_holder].value = safeSub(balances[_holder].value, buyoutTokens);
281     balances[msg.sender].exist = true;
282 
283     Transfer(_holder, msg.sender, buyoutTokens);
284 
285     _holder.transfer(_amount);
286     Pay(_holder, _amount);
287   }
288 }
289 
290 /// @title SilentNotary  сrowdsale contract
291 contract SilentNotaryCrowdsale is Haltable, Killable, SafeMath {
292 
293  /// Period of the ICO stage
294  uint constant public DURATION = 14 days;
295 
296  /// The duration of ICO
297  uint public icoDuration = DURATION;
298 
299  //// The token we are selling
300  SilentNotaryToken public token;
301 
302  /// Escrow wallet
303  address public multisigWallet;
304 
305  /// Team wallet
306  address public teamWallet;
307 
308  /// The UNIX timestamp start date of the crowdsale
309  uint public startsAt;
310 
311  /// the number of tokens already sold through this contract
312  uint public tokensSold = 0;
313 
314  ///  How many wei of funding we have raised
315  uint public weiRaised = 0;
316 
317  ///  How many distinct addresses have invested
318  uint public investorCount = 0;
319 
320  ///  How much wei we have returned back to the contract after a failed crowdfund.
321  uint public loadedRefund = 0;
322 
323  ///  How much wei we have given back to investors.
324  uint public weiRefunded = 0;
325 
326  ///  Has this crowdsale been finalized
327  bool public finalized;
328 
329  ///  How much ETH each address has invested to this crowdsale
330  mapping (address => uint256) public investedAmountOf;
331 
332  ///  How much tokens this crowdsale has credited for each investor address
333  mapping (address => uint256) public tokenAmountOf;
334 
335  /// if the funding goal is not reached, investors may withdraw their funds
336  uint public constant FUNDING_GOAL = 1000 ether;
337 
338  /// topup team wallet after that will topup both - team and multisig wallet by 32% and 68%
339  uint constant MULTISIG_WALLET_GOAL = FUNDING_GOAL;
340 
341  /// Minimum order quantity 0.1 ether
342  uint public constant MIN_INVESTEMENT = 100 finney;
343 
344  /// ICO start token price
345  uint public constant MIN_PRICE = 10e9;
346 
347  /// Maximum token price, if reached ICO will stop
348  uint public constant MAX_PRICE = 20e10;
349 
350  /// How much ICO tokens to sold
351  uint public constant INVESTOR_TOKENS  = 10e11;
352 
353  /// Tokens count involved in price calculation
354  uint public constant TOTAL_TOKENS_FOR_PRICE = INVESTOR_TOKENS;
355 
356  /// last token price
357  uint public tokenPrice = MIN_PRICE;
358 
359   /// State machine
360   /// Preparing: All contract initialization calls and variables have not been set yet
361   /// Funding: Active crowdsale
362   /// Success: Minimum funding goal reached
363   /// Failure: Minimum funding goal not reached before ending time
364   /// Finalized: The finalized has been called and succesfully executed
365   /// Refunding: Refunds are loaded on the contract for reclaim
366  enum State{Unknown, Preparing, Funding, Success, Failure, Finalized, Refunding}
367 
368  /// A new investment was made
369  event Invested(address investor, uint weiAmount, uint tokenAmount);
370 
371  /// Refund was processed for a contributor
372  event Refund(address investor, uint weiAmount);
373 
374  /// Crowdsale end time has been changed
375  event EndsAtChanged(uint endsAt);
376 
377  /// New price was calculated
378  event PriceChanged(uint oldValue, uint newValue);
379 
380  /// Modified allowing execution only if the crowdsale is currently runnin
381  modifier inState(State state) {
382    require(getState() == state);
383    _;
384  }
385 
386  /// @dev Constructor
387  /// @param _token SNTR token address
388  /// @param _multisigWallet  multisig wallet address
389  /// @param _start  ICO start time
390  function SilentNotaryCrowdsale(address _token, address _multisigWallet, address _teamWallet, uint _start) {
391    require(_token != 0);
392    require(_multisigWallet != 0);
393    require(_teamWallet != 0);
394    require(_start != 0);
395 
396    token = SilentNotaryToken(_token);
397    multisigWallet = _multisigWallet;
398    teamWallet = _teamWallet;
399    startsAt = _start;
400  }
401 
402  /// @dev Don't expect to just send in money and get tokens.
403  function() payable {
404    buy();
405  }
406 
407   /// @dev Make an investment.
408   /// @param receiver The Ethereum address who receives the tokens
409  function investInternal(address receiver) stopInEmergency private {
410    require(getState() == State.Funding);
411    require(msg.value >= MIN_INVESTEMENT);
412 
413    uint weiAmount = msg.value;
414 
415    var multiplier = 10 ** token.decimals();
416    uint tokenAmount = safeDiv(safeMul(weiAmount, multiplier), tokenPrice);
417    assert(tokenAmount > 0);
418 
419    if(investedAmountOf[receiver] == 0) {
420       // A new investor
421       investorCount++;
422    }
423    // Update investor
424    investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
425    tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokenAmount);
426    // Update totals
427    weiRaised = safeAdd(weiRaised, weiAmount);
428    tokensSold = safeAdd(tokensSold, tokenAmount);
429 
430    var newPrice = calculatePrice(tokensSold);
431    PriceChanged(tokenPrice, newPrice);
432    tokenPrice = newPrice;
433 
434    assignTokens(receiver, tokenAmount);
435    if(weiRaised <= MULTISIG_WALLET_GOAL)
436      multisigWallet.transfer(weiAmount);
437    else {
438      int remain = int(weiAmount - weiRaised - MULTISIG_WALLET_GOAL);
439 
440      if(remain > 0) {
441        multisigWallet.transfer(uint(remain));
442        weiAmount = safeSub(weiAmount, uint(remain));
443      }
444 
445      var distributedAmount = safeDiv(safeMul(weiAmount, 32), 100);
446      teamWallet.transfer(distributedAmount);
447      multisigWallet.transfer(safeSub(weiAmount, distributedAmount));
448 
449    }
450    // Tell us invest was success
451    Invested(receiver, weiAmount, tokenAmount);
452  }
453 
454   /// @dev Allow anonymous contributions to this crowdsale.
455   /// @param receiver The Ethereum address who receives the tokens
456  function invest(address receiver) public payable {
457    investInternal(receiver);
458  }
459 
460   /// @dev Pay for funding, get invested tokens back in the sender address.
461  function buy() public payable {
462    invest(msg.sender);
463  }
464 
465  /// @dev Finalize a succcesful crowdsale. The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
466  function finalize() public inState(State.Success) onlyOwner stopInEmergency {
467    // If not already finalized
468    require(!finalized);
469 
470    finalized = true;
471    finalizeCrowdsale();
472  }
473 
474  /// @dev Finalize a succcesful crowdsale.
475  function finalizeCrowdsale() internal {
476    var multiplier = 10 ** token.decimals();
477    uint investorTokens = safeMul(INVESTOR_TOKENS, multiplier);
478    if(investorTokens > tokensSold)
479      assignTokens(teamWallet, safeSub(investorTokens, tokensSold));
480    token.releaseTokenTransfer();
481  }
482 
483   /// @dev  Allow load refunds back on the contract for the refunding. The team can transfer the funds back on the smart contract in the case the minimum goal was not reached.
484  function loadRefund() public payable inState(State.Failure) {
485    if(msg.value == 0)
486      revert();
487    loadedRefund = safeAdd(loadedRefund, msg.value);
488  }
489 
490  /// @dev  Investors can claim refund.
491  function refund() public inState(State.Refunding) {
492    uint256 weiValue = investedAmountOf[msg.sender];
493    if (weiValue == 0)
494      revert();
495    investedAmountOf[msg.sender] = 0;
496    weiRefunded = safeAdd(weiRefunded, weiValue);
497    Refund(msg.sender, weiValue);
498    if (!msg.sender.send(weiValue))
499      revert();
500  }
501 
502   /// @dev Crowdfund state machine management.
503   /// @return State current state
504  function getState() public constant returns (State) {
505    if (finalized)
506      return State.Finalized;
507    if (address(token) == 0 || address(multisigWallet) == 0)
508      return State.Preparing;
509    if (now >= startsAt && now < startsAt + icoDuration && !isCrowdsaleFull())
510      return State.Funding;
511    if (isMinimumGoalReached())
512        return State.Success;
513    if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
514      return State.Refunding;
515    return State.Failure;
516  }
517 
518  /// @dev Prolongate ICO if owner decide it
519  function prolongate() public onlyOwner {
520    require(icoDuration < DURATION * 2);
521    icoDuration += DURATION;
522  }
523 
524  /// @dev Calculating price, it is not linear function
525  /// @param totalRaisedTokens total raised tokens
526  /// @return price in wei
527  function calculatePrice(uint totalRaisedTokens) internal returns (uint price) {
528    int multiplier = int(10**token.decimals());
529    int coefficient = int(safeDiv(totalRaisedTokens, TOTAL_TOKENS_FOR_PRICE)) - multiplier;
530    int priceDifference = coefficient * int(MAX_PRICE - MIN_PRICE) / multiplier;
531    assert(int(MAX_PRICE) >= -priceDifference);
532    return uint(priceDifference + int(MAX_PRICE));
533  }
534 
535   /// @dev Minimum goal was reached
536   /// @return true if the crowdsale has raised enough money to be a succes
537   function isMinimumGoalReached() public constant returns (bool reached) {
538     return weiRaised >= FUNDING_GOAL;
539   }
540 
541   /// @dev Check crowdsale limit
542   /// @return limit reached result
543   function isCrowdsaleFull() public constant returns (bool) {
544     return tokenPrice >= MAX_PRICE
545       || tokensSold >= safeMul(TOTAL_TOKENS_FOR_PRICE,  10 ** token.decimals())
546       || now > startsAt + icoDuration;
547   }
548 
549    /// @dev Dynamically create tokens and assign them to the investor.
550    /// @param receiver address
551    /// @param tokenAmount tokens amount
552   function assignTokens(address receiver, uint tokenAmount) private {
553     token.mint(receiver, tokenAmount);
554   }
555 }