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
187 
188 
189 contract Reservation is Pausable {
190 
191     using SafeMath for uint;
192 
193     /* Max investment count when we are still allowed to change the multisig address */
194     uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 500;
195 
196     /* The token we are selling */
197     IMintableToken public token;
198 
199     /* How we are going to price our offering */
200     PricingStrategy public pricingStrategy;
201 
202     /* tokens will be transfered from this address */
203     address public multisigWallet;
204 
205     /* if the funding goal is not reached, investors may withdraw their funds */
206     uint public minimumFundingGoal;
207 
208     /* the UNIX timestamp start date of the reservation */
209     uint public startsAt;
210 
211     /* the UNIX timestamp end date of the reservation */
212     uint public endsAt;
213 
214     /* Maximum amount of tokens this reservation can sell. */
215     uint public tokensHardCap;
216 
217     /* the number of tokens already sold through this contract*/
218     uint public tokensSold = 0;
219 
220     /* How many wei of funding we have raised */
221     uint public weiRaised = 0;
222 
223     /* How many distinct addresses have invested */
224     uint public investorCount = 0;
225 
226     /* How much wei we have returned back to the contract after a failed crowdfund. */
227     uint public loadedRefund = 0;
228 
229     /* How much wei we have given back to investors.*/
230     uint public weiRefunded = 0;
231 
232     /** How much ETH each address has invested to this reservation */
233     mapping (address => uint256) public investedAmountOf;
234 
235     /** How much tokens this reservation has credited for each investor address */
236     mapping (address => uint256) public tokenAmountOf;
237 
238     /** Addresses that are allowed to invest even before ICO offical opens. Only for testing purpuses. */
239     mapping (address => bool) public earlyParticipantWhitelist;
240 
241     /** State machine
242     *
243     * - Preparing: All contract initialization calls and variables have not been set yet
244     * - Prefunding: We have not passed start time yet
245     * - Funding: Active reservation
246     * - Success: Minimum funding goal reached
247     * - Failure: Minimum funding goal not reached before ending time
248     * - Refunding: Refunds are loaded on the contract for reclaim.
249     */
250     enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Refunding}
251 
252     // A new investment was made
253     event Invested(address investor, uint weiAmount, uint tokenAmount);
254 
255     // Refund was processed for a contributor
256     event Refund(address investor, uint weiAmount);
257 
258     // Address early participation whitelist status changed
259     event Whitelisted(address addr, bool status);
260 
261     // Reservation end time has been changed
262     event EndsAtChanged(uint endsAt);
263 
264     function Reservation(
265         address _token, 
266         address _pricingStrategy, 
267         address _multisigWallet, 
268         uint _start, 
269         uint _end, 
270         uint _tokensHardCap,
271         uint _minimumFundingGoal
272     ) {
273         require(_token != 0);
274         require(_pricingStrategy != 0);
275         require(_multisigWallet != 0);
276         require(_start != 0);
277         require(_end != 0);
278         require(_start < _end);
279         require(_tokensHardCap != 0);
280 
281         token = IMintableToken(_token);
282         setPricingStrategy(_pricingStrategy);
283         multisigWallet = _multisigWallet;
284         startsAt = _start;
285         endsAt = _end;
286         tokensHardCap = _tokensHardCap;
287         minimumFundingGoal = _minimumFundingGoal;
288     }
289 
290     /**
291     * Buy tokens
292     */
293     function() payable {
294         invest(msg.sender);
295     }
296 
297     /**
298     * Make an investment.
299     *
300     * Reservation must be running for one to invest.
301     * We must have not pressed the emergency brake.
302     *
303     * @param receiver The Ethereum address who receives the tokens
304     */
305     function invest(address receiver) whenNotPaused payable {
306 
307         // Determine if it's a good time to accept investment from this participant
308         if (getState() == State.PreFunding) {
309             // Are we whitelisted for early deposit
310             require(earlyParticipantWhitelist[receiver]);
311         } else {
312             require(getState() == State.Funding);
313         }
314 
315         uint weiAmount = msg.value;
316 
317         // Account reservation sales separately, so that they do not count against pricing tranches
318         uint tokenAmount = pricingStrategy.calculateTokenAmount(weiAmount);
319 
320         // Dust transaction
321         require(tokenAmount > 0);
322 
323         if (investedAmountOf[receiver] == 0) {
324             // A new investor
325             investorCount++;
326         }
327 
328         // Update investor
329         investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
330         tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
331 
332         // Update totals
333         weiRaised = weiRaised.add(weiAmount);
334         tokensSold = tokensSold.add(tokenAmount);
335 
336         // Check that we did not bust the cap
337         require(!isBreakingCap(tokensSold));
338 
339         token.mint(receiver, tokenAmount);
340 
341         // Pocket the money
342         multisigWallet.transfer(weiAmount);
343 
344         // Tell us invest was success
345         Invested(receiver, weiAmount, tokenAmount);
346     }
347 
348     /**
349     * Allow addresses to do early participation.
350     *
351     */
352     function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {
353         earlyParticipantWhitelist[addr] = status;
354         Whitelisted(addr, status);
355     }
356 
357     /**
358     * Allow reservation owner to close early or extend the reservation.
359     *
360     * This is useful e.g. for a manual soft cap implementation:
361     * - after X amount is reached determine manual closing
362     *
363     * This may put the reservation to an invalid state,
364     * but we trust owners know what they are doing.
365     *
366     */
367     function setEndsAt(uint time) onlyOwner {
368 
369         require(now <= time);
370 
371         endsAt = time;
372         EndsAtChanged(endsAt);
373     }
374 
375     /**
376     * Allow to (re)set pricing strategy.
377     *
378     * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
379     */
380     function setPricingStrategy(address _pricingStrategy) onlyOwner {
381         pricingStrategy = PricingStrategy(_pricingStrategy);
382 
383         // Don't allow setting bad agent
384         require(pricingStrategy.isPricingStrategy());
385     }
386 
387     /**
388     * Allow to change the team multisig address in the case of emergency.
389     *
390     * This allows to save a deployed reservation wallet in the case the reservation has not yet begun
391     * (we have done only few test transactions). After the reservation is going
392     * then multisig address stays locked for the safety reasons.
393     */
394     function setMultisig(address addr) public onlyOwner {
395 
396         require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
397 
398         multisigWallet = addr;
399     }
400 
401     /**
402     * Allow load refunds back on the contract for the refunding.
403     *
404     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
405     */
406     function loadRefund() public payable inState(State.Failure) {
407         require(msg.value > 0);
408 
409         loadedRefund = loadedRefund.add(msg.value);
410     }
411 
412     /**
413     * Investors can claim refund.
414     *
415     * Note that any refunds from proxy buyers should be handled separately,
416     * and not through this contract.
417     */
418     function refund() public inState(State.Refunding) {
419         uint256 weiValue = investedAmountOf[msg.sender];
420         require(weiValue > 0);
421 
422         investedAmountOf[msg.sender] = 0;
423         weiRefunded = weiRefunded.add(weiValue);
424         Refund(msg.sender, weiValue);
425         
426         msg.sender.transfer(weiValue);
427     }
428 
429     /**
430     * Crowdfund state machine management.
431     *
432     * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
433     */
434     function getState() public constant returns (State) {
435         if (address(pricingStrategy) == 0)
436             return State.Preparing;
437         else if (block.timestamp < startsAt)
438             return State.PreFunding;
439         else if (block.timestamp <= endsAt && !isReservationFull())
440             return State.Funding;
441         else if (isMinimumGoalReached())
442             return State.Success;
443         else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)
444             return State.Refunding;
445         else
446             return State.Failure;
447     }
448 
449     /**
450     * @return true if the reservation has raised enough money to be a successful.
451     */
452     function isMinimumGoalReached() public constant returns (bool reached) {
453         return weiRaised >= minimumFundingGoal;
454     }
455 
456     /**
457     * Called from invest() to confirm if the curret investment does not break our cap rule.
458     */
459     function isBreakingCap(uint tokensSoldTotal) constant returns (bool) {
460         return tokensSoldTotal > tokensHardCap;
461     }
462 
463     function isReservationFull() public constant returns (bool) {
464         return tokensSold >= tokensHardCap;
465     }
466 
467     //
468     // Modifiers
469     //
470 
471     /** Modified allowing execution only if the reservation is currently running.  */
472     modifier inState(State state) {
473         require(getState() == state);
474         _;
475     }
476 }