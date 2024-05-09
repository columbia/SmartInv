1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() {
49     owner = msg.sender;
50   }
51 
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) onlyOwner {
67     if (newOwner != address(0)) {
68       owner = newOwner;
69     }
70   }
71 
72 }
73 
74 
75 /**
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  */
79 contract Pausable is Ownable {
80   event Pause();
81   event Unpause();
82 
83   bool public paused = false;
84 
85 
86   /**
87    * @dev modifier to allow actions only when the contract IS paused
88    */
89   modifier whenNotPaused() {
90     require(!paused);
91     _;
92   }
93 
94   /**
95    * @dev modifier to allow actions only when the contract IS NOT paused
96    */
97   modifier whenPaused {
98     require(paused);
99     _;
100   }
101 
102   /**
103    * @dev called by the owner to pause, triggers stopped state
104    */
105   function pause() onlyOwner whenNotPaused returns (bool) {
106     paused = true;
107     Pause();
108     return true;
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused returns (bool) {
115     paused = false;
116     Unpause();
117     return true;
118   }
119 }
120 
121 contract IMintableToken {
122     function mint(address _to, uint256 _amount) returns (bool);
123     function finishMinting() returns (bool);
124 }
125 
126 contract PricingStrategy {
127 
128     using SafeMath for uint;
129 
130     uint public rate0;
131     uint public rate1;
132     uint public rate2;
133 
134     uint public threshold1;
135     uint public threshold2;
136 
137     uint public minimumWeiAmount;
138 
139     function PricingStrategy(
140         uint _rate0,
141         uint _rate1,
142         uint _rate2,
143         uint _minimumWeiAmount,
144         uint _threshold1,
145         uint _threshold2
146     ) {
147         require(_rate0 > 0);
148         require(_rate1 > 0);
149         require(_rate2 > 0);
150         require(_minimumWeiAmount > 0);
151         require(_threshold1 > 0);
152         require(_threshold2 > 0);
153 
154         rate0 = _rate0;
155         rate1 = _rate1;
156         rate2 = _rate2;
157         minimumWeiAmount = _minimumWeiAmount;
158         threshold1 = _threshold1;
159         threshold2 = _threshold2;
160     }
161 
162     /** Interface declaration. */
163     function isPricingStrategy() public constant returns (bool) {
164         return true;
165     }
166 
167     /** Calculate the current price for buy in amount. */
168     function calculateTokenAmount(uint weiAmount) public constant returns (uint tokenAmount) {
169         uint bonusRate = 0;
170 
171         if (weiAmount >= minimumWeiAmount) {
172             bonusRate = rate0;
173         }
174 
175         if (weiAmount >= threshold1) {
176             bonusRate = rate1;
177         }
178 
179         if (weiAmount >= threshold2) {
180             bonusRate = rate2;
181         }
182 
183         return weiAmount.mul(bonusRate);
184     }
185 }
186 
187 contract Presale is Pausable {
188 
189     using SafeMath for uint;
190 
191     /* Max investment count when we are still allowed to change the multisig address */
192     uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 500;
193 
194     /* The token we are selling */
195     IMintableToken public token;
196 
197     /* How we are going to price our offering */
198     PricingStrategy public pricingStrategy;
199 
200     /* tokens will be transfered from this address */
201     address public multisigWallet;
202 
203     /* if the funding goal is not reached, investors may withdraw their funds */
204     uint public minimumFundingGoal;
205 
206     /* the UNIX timestamp start date of the presale */
207     uint public startsAt;
208 
209     /* the UNIX timestamp end date of the presale */
210     uint public endsAt;
211 
212     /* Maximum amount of tokens this presale can sell. */
213     uint public tokensHardCap;
214 
215     /* the number of tokens already sold through this contract*/
216     uint public tokensSold = 0;
217 
218     /* How many wei of funding we have raised */
219     uint public weiRaised = 0;
220 
221     /* How many distinct addresses have invested */
222     uint public investorCount = 0;
223 
224     /* How much wei we have returned back to the contract after a failed crowdfund. */
225     uint public loadedRefund = 0;
226 
227     /* How much wei we have given back to investors.*/
228     uint public weiRefunded = 0;
229 
230     /** How much ETH each address has invested to this presale */
231     mapping (address => uint256) public investedAmountOf;
232 
233     /** How much tokens this presale has credited for each investor address */
234     mapping (address => uint256) public tokenAmountOf;
235 
236     /** Addresses that are allowed to invest even before ICO offical opens. Only for testing purpuses. */
237     mapping (address => bool) public earlyParticipantWhitelist;
238 
239     /** State machine
240     *
241     * - Preparing: All contract initialization calls and variables have not been set yet
242     * - Prefunding: We have not passed start time yet
243     * - Funding: Active presale
244     * - Success: Minimum funding goal reached
245     * - Failure: Minimum funding goal not reached before ending time
246     * - Refunding: Refunds are loaded on the contract for reclaim.
247     */
248     enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Refunding}
249 
250     // A new investment was made
251     event Invested(address investor, uint weiAmount, uint tokenAmount);
252 
253     // Refund was processed for a contributor
254     event Refund(address investor, uint weiAmount);
255 
256     // Address early participation whitelist status changed
257     event Whitelisted(address addr, bool status);
258 
259     // Presale end time has been changed
260     event EndsAtChanged(uint endsAt);
261 
262     function Presale(
263         address _token, 
264         address _pricingStrategy, 
265         address _multisigWallet, 
266         uint _start, 
267         uint _end, 
268         uint _tokensHardCap,
269         uint _minimumFundingGoal
270     ) {
271         require(_token != 0);
272         require(_pricingStrategy != 0);
273         require(_multisigWallet != 0);
274         require(_start != 0);
275         require(_end != 0);
276         require(_start < _end);
277         require(_tokensHardCap != 0);
278 
279         token = IMintableToken(_token);
280         setPricingStrategy(_pricingStrategy);
281         multisigWallet = _multisigWallet;
282         startsAt = _start;
283         endsAt = _end;
284         tokensHardCap = _tokensHardCap;
285         minimumFundingGoal = _minimumFundingGoal;
286     }
287 
288     /**
289     * Buy tokens
290     */
291     function() payable {
292         invest(msg.sender);
293     }
294 
295     /**
296     * Make an investment.
297     *
298     * Presale must be running for one to invest.
299     * We must have not pressed the emergency brake.
300     *
301     * @param receiver The Ethereum address who receives the tokens
302     */
303     function invest(address receiver) whenNotPaused payable {
304 
305         // Determine if it's a good time to accept investment from this participant
306         if (getState() == State.PreFunding) {
307             // Are we whitelisted for early deposit
308             require(earlyParticipantWhitelist[receiver]);
309         } else {
310             require(getState() == State.Funding);
311         }
312 
313         uint weiAmount = msg.value;
314 
315         // Account presale sales separately, so that they do not count against pricing tranches
316         uint tokenAmount = pricingStrategy.calculateTokenAmount(weiAmount);
317 
318         // Dust transaction
319         require(tokenAmount > 0);
320 
321         if (investedAmountOf[receiver] == 0) {
322             // A new investor
323             investorCount++;
324         }
325 
326         // Update investor
327         investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
328         tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
329 
330         // Update totals
331         weiRaised = weiRaised.add(weiAmount);
332         tokensSold = tokensSold.add(tokenAmount);
333 
334         // Check that we did not bust the cap
335         require(!isBreakingCap(tokensSold));
336 
337         token.mint(receiver, tokenAmount);
338 
339         // Pocket the money
340         multisigWallet.transfer(weiAmount);
341 
342         // Tell us invest was success
343         Invested(receiver, weiAmount, tokenAmount);
344     }
345 
346     /**
347     * Allow addresses to do early participation.
348     *
349     */
350     function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
351         earlyParticipantWhitelist[addr] = status;
352         Whitelisted(addr, status);
353     }
354 
355     /**
356     * Allow presale owner to close early or extend the presale.
357     *
358     * This is useful e.g. for a manual soft cap implementation:
359     * - after X amount is reached determine manual closing
360     *
361     * This may put the presale to an invalid state,
362     * but we trust owners know what they are doing.
363     *
364     */
365     function setEndsAt(uint time) onlyOwner {
366 
367         require(now <= time);
368 
369         endsAt = time;
370         EndsAtChanged(endsAt);
371     }
372 
373     /**
374     * Allow to (re)set pricing strategy.
375     *
376     * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
377     */
378     function setPricingStrategy(address _pricingStrategy) onlyOwner {
379         pricingStrategy = PricingStrategy(_pricingStrategy);
380 
381         // Don't allow setting bad agent
382         require(pricingStrategy.isPricingStrategy());
383     }
384 
385     /**
386     * Allow to change the team multisig address in the case of emergency.
387     *
388     * This allows to save a deployed presale wallet in the case the presale has not yet begun
389     * (we have done only few test transactions). After the presale is going
390     * then multisig address stays locked for the safety reasons.
391     */
392     function setMultisig(address addr) public onlyOwner {
393 
394         require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
395 
396         multisigWallet = addr;
397     }
398 
399     /**
400     * Allow load refunds back on the contract for the refunding.
401     *
402     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
403     */
404     function loadRefund() public payable inState(State.Failure) {
405         require(msg.value > 0);
406 
407         loadedRefund = loadedRefund.add(msg.value);
408     }
409 
410     /**
411     * Investors can claim refund.
412     *
413     * Note that any refunds from proxy buyers should be handled separately,
414     * and not through this contract.
415     */
416     function refund() public inState(State.Refunding) {
417         uint256 weiValue = investedAmountOf[msg.sender];
418         require(weiValue > 0);
419 
420         investedAmountOf[msg.sender] = 0;
421         weiRefunded = weiRefunded.add(weiValue);
422         Refund(msg.sender, weiValue);
423         
424         msg.sender.transfer(weiValue);
425     }
426 
427     /**
428     * Crowdfund state machine management.
429     *
430     * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
431     */
432     function getState() public constant returns (State) {
433         if (address(pricingStrategy) == 0)
434             return State.Preparing;
435         else if (block.timestamp < startsAt)
436             return State.PreFunding;
437         else if (block.timestamp <= endsAt && !isPresaleFull())
438             return State.Funding;
439         else if (isMinimumGoalReached())
440             return State.Success;
441         else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
442             return State.Refunding;
443         else
444             return State.Failure;
445     }
446 
447     /**
448     * @return true if the presale has raised enough money to be a successful.
449     */
450     function isMinimumGoalReached() public constant returns (bool reached) {
451         return weiRaised >= minimumFundingGoal;
452     }
453 
454     /**
455     * Called from invest() to confirm if the curret investment does not break our cap rule.
456     */
457     function isBreakingCap(uint tokensSoldTotal) constant returns (bool) {
458         return tokensSoldTotal > tokensHardCap;
459     }
460 
461     function isPresaleFull() public constant returns (bool) {
462         return tokensSold >= tokensHardCap;
463     }
464 
465     //
466     // Modifiers
467     //
468 
469     /** Modified allowing execution only if the presale is currently running.  */
470     modifier inState(State state) {
471         require(getState() == state);
472         _;
473     }
474 }