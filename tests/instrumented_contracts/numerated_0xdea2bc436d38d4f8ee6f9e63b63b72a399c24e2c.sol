1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address public owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() {
20         owner = msg.sender;
21     }
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) onlyOwner public {
36         require(newOwner != address(0));
37         OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 
44 
45 
46 
47 
48 
49 
50 
51 /**
52  * @title SafeMath
53  * @dev Math operations with safety checks that throw on error
54  */
55 library SafeMath {
56     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
57         uint256 c = a * b;
58         if (a != 0 && c / a != b) revert();
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal constant returns (uint256) {
63         // assert(b > 0); // Solidity automatically throws when dividing by 0
64         uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66         return c;
67     }
68 
69     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
70         if (b > a) revert();
71         return a - b;
72     }
73 
74     function add(uint256 a, uint256 b) internal constant returns (uint256) {
75         uint256 c = a + b;
76         if (c < a) revert();
77         return c;
78     }
79 }
80 
81 
82 
83 contract VLBBonusStore is Ownable {
84     mapping(address => uint8) public rates;
85 
86     function collectRate(address investor) onlyOwner public returns (uint8) {
87         require(investor != address(0));
88         uint8 rate = rates[investor];
89         if (rate != 0) {
90             delete rates[investor];
91         }
92         return rate;
93     }
94 
95     function addRate(address investor, uint8 rate) onlyOwner public {
96         require(investor != address(0));
97         rates[investor] = rate;
98     }
99 }
100 contract VLBRefundVault is Ownable {
101     using SafeMath for uint256;
102 
103     enum State {Active, Refunding, Closed}
104     State public state;
105 
106     mapping (address => uint256) public deposited;
107 
108     address public wallet;
109 
110     event Closed();
111     event FundsDrained(uint256 weiAmount);
112     event RefundsEnabled();
113     event Refunded(address indexed beneficiary, uint256 weiAmount);
114 
115     function VLBRefundVault(address _wallet) public {
116         require(_wallet != address(0));
117         wallet = _wallet;
118         state = State.Active;
119     }
120 
121     function deposit(address investor) onlyOwner public payable {
122         require(state == State.Active);
123         deposited[investor] = deposited[investor].add(msg.value);
124     }
125 
126     function unhold() onlyOwner public {
127         require(state == State.Active);
128         FundsDrained(this.balance);
129         wallet.transfer(this.balance);
130     }
131 
132     function close() onlyOwner public {
133         require(state == State.Active);
134         state = State.Closed;
135         Closed();
136         FundsDrained(this.balance);
137         wallet.transfer(this.balance);
138     }
139 
140     function enableRefunds() onlyOwner public {
141         require(state == State.Active);
142         state = State.Refunding;
143         RefundsEnabled();
144     }
145 
146     function refund(address investor) public {
147         require(state == State.Refunding);
148         uint256 depositedValue = deposited[investor];
149         deposited[investor] = 0;
150         investor.transfer(depositedValue);
151         Refunded(investor, depositedValue);
152     }
153 }
154 
155 
156 interface Token {
157     function transferFrom(address from, address to, uint256 value) public returns (bool);
158     function tokensWallet() public returns (address);
159 }
160 
161 /**
162  * @title VLBCrowdsale
163  * @dev VLB crowdsale contract borrows Zeppelin Finalized, Capped and Refundable crowdsales implementations
164  */
165 contract VLBCrowdsale is Ownable {
166     using SafeMath for uint;
167 
168     /**
169      * @dev escrow address
170      */
171     address public escrow;
172 
173     /**
174      * @dev token contract
175      */
176     Token public token;
177 
178     /**
179      * @dev refund vault used to hold funds while crowdsale is running
180      */
181     VLBRefundVault public vault;
182 
183     /**
184      * @dev refund vault used to hold funds while crowdsale is running
185      */
186     VLBBonusStore public bonuses;
187 
188     /**
189      * @dev tokensale start time: Dec 17, 2017 12:00:00 UTC (1513512000)
190      */
191     uint startTime = 1513512000;
192 
193     /**
194      * @dev tokensale end time: Apr 09, 2018 12:00:00 UTC (1523275200)
195      */
196     uint endTime = 1523275200;
197 
198     /**
199      * @dev minimum purchase amount for presale
200      */
201     uint256 public constant MIN_SALE_AMOUNT = 5 * 10**17; // 0.5 ether
202 
203     /**
204      * @dev minimum and maximum amount of funds to be raised in USD
205      */
206     uint256 public constant USD_GOAL = 4 * 10**6;  // $4M
207     uint256 public constant USD_CAP  = 12 * 10**6; // $12M
208 
209     /**
210      * @dev amount of raised money in wei
211      */
212     uint256 public weiRaised;
213 
214     /**
215      * @dev tokensale finalization flag
216      */
217     bool public isFinalized = false;
218 
219     /**
220      * @dev tokensale pause flag
221      */
222     bool public paused = false;
223 
224     /**
225      * @dev refunding satge flag
226      */
227     bool public refunding = false;
228 
229     /**
230      * @dev min cap reach flag
231      */
232     bool public isMinCapReached = false;
233 
234     /**
235      * @dev ETH x USD exchange rate
236      */
237     uint public ETHUSD;
238 
239     /**
240      * @dev event for token purchase logging
241      * @param purchaser who paid for the tokens
242      * @param beneficiary who got the tokens
243      * @param value weis paid for purchase
244      * @param amount amount of tokens purchased
245      */
246     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
247 
248     /**
249      * @dev event for tokensale final logging
250     */
251     event Finalized();
252 
253     /**
254      * @dev event for tokensale pause logging
255     */    
256     event Pause();
257 
258     /**
259      * @dev event for tokensale uppause logging
260     */    
261     event Unpause();
262 
263     /**
264      * @dev Modifier to make a function callable only when the contract is not paused.
265      */
266     modifier whenNotPaused() {
267         require(!paused);
268         _;
269     }
270 
271     /**
272      * @dev Modifier to make a function callable only when the contract is paused.
273      */
274     modifier whenPaused() {
275         require(paused);
276         _;
277     }
278 
279     /**
280      * @dev Modifier to make a function callable only when its called by escrow.
281      */
282     modifier onlyEscrow() {
283         require(msg.sender == escrow);
284         _;
285     }
286 
287     /**
288      * @dev Crowdsale in the constructor takes addresses of
289      *      the just deployed VLBToken and VLBRefundVault contracts
290      * @param _tokenAddress address of the VLBToken deployed contract
291      */
292     function VLBCrowdsale(address _tokenAddress, address _wallet, address _escrow, uint rate) public {
293         require(_tokenAddress != address(0));
294         require(_wallet != address(0));
295         require(_escrow != address(0));
296 
297         escrow = _escrow;
298 
299         // Set initial exchange rate
300         ETHUSD = rate;
301 
302         // VLBTokenwas deployed separately
303         token = Token(_tokenAddress);
304 
305         vault = new VLBRefundVault(_wallet);
306         bonuses = new VLBBonusStore();
307     }
308 
309     /**
310      * @dev fallback function can be used to buy tokens
311      */
312     function() public payable {
313         buyTokens(msg.sender);
314     }
315 
316     /**
317      * @dev main function to buy tokens
318      * @param beneficiary target wallet for tokens can vary from the sender one
319      */
320     function buyTokens(address beneficiary) whenNotPaused public payable {
321         require(beneficiary != address(0));
322         require(validPurchase(msg.value));
323 
324         uint256 weiAmount = msg.value;
325 
326         // buyer and beneficiary could be two different wallets
327         address buyer = msg.sender;
328 
329         weiRaised = weiRaised.add(weiAmount);
330 
331         // calculate token amount to be created
332         uint256 tokens = weiAmount.mul(getConversionRate());
333 
334         uint8 rate = bonuses.collectRate(beneficiary);
335         if (rate != 0) {
336             tokens = tokens.mul(rate).div(100);
337         }
338 
339         if (!token.transferFrom(token.tokensWallet(), beneficiary, tokens)) {
340             revert();
341         }
342 
343         TokenPurchase(buyer, beneficiary, weiAmount, tokens);
344 
345         vault.deposit.value(weiAmount)(buyer);
346     }
347 
348     /**
349      * @dev check if the current purchase valid based on time and amount of passed ether
350      * @param _value amount of passed ether
351      * @return true if investors can buy at the moment
352      */
353     function validPurchase(uint256 _value) internal constant returns (bool) {
354         bool nonZeroPurchase = _value != 0;
355         bool withinPeriod = now >= startTime && now <= endTime;
356         bool withinCap = !capReached(weiRaised.add(_value));
357 
358         // For presale we want to decline all payments less then minPresaleAmount
359         bool withinAmount = msg.value >= MIN_SALE_AMOUNT;
360 
361         return nonZeroPurchase && withinPeriod && withinCap && withinAmount;
362     }
363 
364     /**
365      * @dev finish presale stage and move vault to
366      *      refund state if GOAL was not reached
367      */
368     function unholdFunds() onlyOwner public {
369         if (goalReached()) {
370             isMinCapReached = true;
371             vault.unhold();
372         } else {
373             revert();
374         }
375     }
376     
377     /**
378      * @dev check if crowdsale still active based on current time and cap
379      * @return true if crowdsale event has ended
380      */
381     function hasEnded() public constant returns (bool) {
382         bool timeIsUp = now > endTime;
383         return timeIsUp || capReached();
384     }
385 
386     /**
387      * @dev finalize crowdsale. this method triggers vault and token finalization
388      */
389     function finalize() onlyOwner public {
390         require(!isFinalized);
391         require(hasEnded());
392 
393         if (goalReached()) {
394             vault.close();
395         } else {
396             refunding = true;
397             vault.enableRefunds();
398         }
399 
400         isFinalized = true;
401         Finalized();
402     }
403 
404     /**
405      * @dev add previous investor compensaton rate
406      */
407     function addRate(address investor, uint8 rate) onlyOwner public {
408         require(investor != address(0));
409         bonuses.addRate(investor, rate);
410     }
411 
412     /**
413      * @dev check if soft cap goal is reached in USD
414      */
415     function goalReached() public view returns (bool) {        
416         return isMinCapReached || weiRaised.mul(ETHUSD).div(10**20) >= USD_GOAL;
417     }
418 
419     /**
420      * @dev check if hard cap goal is reached in USD
421      */
422     function capReached() internal view returns (bool) {
423         return weiRaised.mul(ETHUSD).div(10**20) >= USD_CAP;
424     }
425 
426     /**
427      * @dev check if hard cap goal is reached in USD
428      */
429     function capReached(uint256 raised) internal view returns (bool) {
430         return raised.mul(ETHUSD).div(10**20) >= USD_CAP;
431     }
432 
433     /**
434      * @dev if crowdsale is unsuccessful, investors can claim refunds here
435      */
436     function claimRefund() public {
437         require(isFinalized && refunding);
438 
439         vault.refund(msg.sender);
440     }    
441 
442     /**
443      * @dev called by the owner to pause, triggers stopped state
444      */
445     function pause() onlyOwner whenNotPaused public {
446         paused = true;
447         Pause();
448     }
449 
450     /**
451      * @dev called by the owner to unpause, returns to normal state
452      */
453     function unpause() onlyOwner whenPaused public {
454         paused = false;
455         Unpause();
456     }
457     
458     /**
459      * @dev called by the escrow to update current ETH x USD exchange rate
460      */
461     function updateExchangeRate(uint rate) onlyEscrow public {
462         ETHUSD = rate;
463     } 
464 
465     /**
466      * @dev returns current token price based on current presale time frame
467      */
468     function getConversionRate() public constant returns (uint256) {
469         if (now >= startTime + 106 days) {
470             return 650;
471         } else if (now >= startTime + 99 days) {
472             return 676;
473         } else if (now >= startTime + 92 days) {
474             return 715;
475         } else if (now >= startTime + 85 days) {
476             return 780;
477         } else if (now >= startTime) {
478             return 845;
479         }
480         return 0;
481     }
482 
483     /**
484      * @dev killer method that can bu used by owner to
485      *      kill the contract and send funds to owner
486      */
487     function kill() onlyOwner whenPaused public {
488         selfdestruct(owner);
489     }
490 }