1 pragma solidity 0.4.24;
2 
3 // File: contracts/flavours/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11 
12     address public owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     constructor() public {
21         owner = msg.sender;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 }
42 
43 // File: contracts/flavours/Whitelisted.sol
44 
45 contract Whitelisted is Ownable {
46 
47     /// @dev True if whitelist enabled
48     bool public whitelistEnabled = true;
49 
50     /// @dev ICO whitelist
51     mapping(address => bool) public whitelist;
52 
53     event ICOWhitelisted(address indexed addr);
54     event ICOBlacklisted(address indexed addr);
55 
56     modifier onlyWhitelisted {
57         require(!whitelistEnabled || whitelist[msg.sender]);
58         _;
59     }
60 
61     /**
62      * Add address to ICO whitelist
63      * @param address_ Investor address
64      */
65     function whitelist(address address_) external onlyOwner {
66         whitelist[address_] = true;
67         emit ICOWhitelisted(address_);
68     }
69 
70     /**
71      * Remove address from ICO whitelist
72      * @param address_ Investor address
73      */
74     function blacklist(address address_) external onlyOwner {
75         delete whitelist[address_];
76         emit ICOBlacklisted(address_);
77     }
78 
79     /**
80      * @dev Returns true if given address in ICO whitelist
81      */
82     function whitelisted(address address_) public view returns (bool) {
83         if (whitelistEnabled) {
84             return whitelist[address_];
85         } else {
86             return true;
87         }
88     }
89 
90     /**
91      * @dev Enable whitelisting
92      */
93     function enableWhitelist() public onlyOwner {
94         whitelistEnabled = true;
95     }
96 
97     /**
98      * @dev Disable whitelisting
99      */
100     function disableWhitelist() public onlyOwner {
101         whitelistEnabled = false;
102     }
103 }
104 
105 // File: contracts/interface/ERC20Token.sol
106 
107 interface ERC20Token {
108     function balanceOf(address owner_) external returns (uint);
109     function allowance(address owner_, address spender_) external returns (uint);
110     function transferFrom(address from_, address to_, uint value_) external returns (bool);
111 }
112 
113 // File: contracts/base/BaseICO.sol
114 
115 /**
116  * @dev Base abstract smart contract for any ICO
117  */
118 contract BaseICO is Ownable, Whitelisted {
119 
120     /// @dev ICO state
121     enum State {
122 
123         // ICO is not active and not started
124         Inactive,
125 
126         // ICO is active, tokens can be distributed among investors.
127         // ICO parameters (end date, hard/low caps) cannot be changed.
128         Active,
129 
130         // ICO is suspended, tokens cannot be distributed among investors.
131         // ICO can be resumed to `Active state`.
132         // ICO parameters (end date, hard/low caps) may changed.
133         Suspended,
134 
135         // ICO is terminated by owner, ICO cannot be resumed.
136         Terminated,
137 
138         // ICO goals are not reached,
139         // ICO terminated and cannot be resumed.
140         NotCompleted,
141 
142         // ICO completed, ICO goals reached successfully,
143         // ICO terminated and cannot be resumed.
144         Completed
145     }
146 
147     /// @dev Token which controlled by this ICO
148     ERC20Token public token;
149 
150     /// @dev Current ICO state.
151     State public state;
152 
153     /// @dev ICO start date seconds since epoch.
154     uint public startAt;
155 
156     /// @dev ICO end date seconds since epoch.
157     uint public endAt;
158 
159     /// @dev Minimal amount of investments in wei needed for successful ICO
160     uint public lowCapWei;
161 
162     /// @dev Maximal amount of investments in wei for this ICO.
163     /// If reached ICO will be in `Completed` state.
164     uint public hardCapWei;
165 
166     /// @dev Minimal amount of investments in wei per investor.
167     uint public lowCapTxWei;
168 
169     /// @dev Maximal amount of investments in wei per investor.
170     uint public hardCapTxWei;
171 
172     /// @dev Number of investments collected by this ICO
173     uint public collectedWei;
174 
175     /// @dev Number of sold tokens by this ICO
176     uint public tokensSold;
177 
178     /// @dev Team wallet used to collect funds
179     address public teamWallet;
180 
181     // ICO state transition events
182     event ICOStarted(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
183     event ICOResumed(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
184     event ICOSuspended();
185     event ICOTerminated();
186     event ICONotCompleted();
187     event ICOCompleted(uint collectedWei);
188     event ICOInvestment(address indexed from, uint investedWei, uint tokens, uint8 bonusPct);
189 
190     modifier isSuspended() {
191         require(state == State.Suspended);
192         _;
193     }
194 
195     modifier isActive() {
196         require(state == State.Active);
197         _;
198     }
199 
200     /**
201      * @dev Trigger start of ICO.
202      * @param endAt_ ICO end date, seconds since epoch.
203      */
204     function start(uint endAt_) public onlyOwner {
205         require(endAt_ > block.timestamp && state == State.Inactive);
206         endAt = endAt_;
207         startAt = block.timestamp;
208         state = State.Active;
209         emit ICOStarted(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
210     }
211 
212     /**
213      * @dev Suspend this ICO.
214      * ICO can be activated later by calling `resume()` function.
215      * In suspend state, ICO owner can change basic ICO parameter using `tune()` function,
216      * tokens cannot be distributed among investors.
217      */
218     function suspend() public onlyOwner isActive {
219         state = State.Suspended;
220         emit ICOSuspended();
221     }
222 
223     /**
224      * @dev Terminate the ICO.
225      * ICO goals are not reached, ICO terminated and cannot be resumed.
226      */
227     function terminate() public onlyOwner {
228         require(state != State.Terminated &&
229         state != State.NotCompleted &&
230         state != State.Completed);
231         state = State.Terminated;
232         emit ICOTerminated();
233     }
234 
235     /**
236      * @dev Change basic ICO parameters. Can be done only during `Suspended` state.
237      * Any provided parameter is used only if it is not zero.
238      * @param endAt_ ICO end date seconds since epoch. Used if it is not zero.
239      * @param lowCapWei_ ICO low capacity. Used if it is not zero.
240      * @param hardCapWei_ ICO hard capacity. Used if it is not zero.
241      * @param lowCapTxWei_ Min limit for ICO per transaction
242      * @param hardCapTxWei_ Hard limit for ICO per transaction
243      */
244     function tune(uint endAt_,
245         uint lowCapWei_,
246         uint hardCapWei_,
247         uint lowCapTxWei_,
248         uint hardCapTxWei_) public onlyOwner isSuspended {
249         if (endAt_ > block.timestamp) {
250             endAt = endAt_;
251         }
252         if (lowCapWei_ > 0) {
253             lowCapWei = lowCapWei_;
254         }
255         if (hardCapWei_ > 0) {
256             hardCapWei = hardCapWei_;
257         }
258         if (lowCapTxWei_ > 0) {
259             lowCapTxWei = lowCapTxWei_;
260         }
261         if (hardCapTxWei_ > 0) {
262             hardCapTxWei = hardCapTxWei_;
263         }
264         require(lowCapWei <= hardCapWei && lowCapTxWei <= hardCapTxWei);
265         touch();
266     }
267 
268     /**
269      * @dev Resume a previously suspended ICO.
270      */
271     function resume() public onlyOwner isSuspended {
272         state = State.Active;
273         emit ICOResumed(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
274         touch();
275     }
276 
277     /**
278      * @dev Recalculate ICO state based on current block time.
279      * Should be called periodically by ICO owner.
280      */
281     function touch() public;
282 
283     /**
284      * @dev Buy tokens
285      */
286     function buyTokens() public payable;
287 
288     /**
289      * @dev Send ether to the fund collection wallet
290      */
291     function forwardFunds() internal {
292         teamWallet.transfer(msg.value);
293     }
294 }
295 
296 // File: contracts/commons/SafeMath.sol
297 
298 /**
299  * @title SafeMath
300  * @dev Math operations with safety checks that throw on error
301  */
302 library SafeMath {
303     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
304         if (a == 0) {
305             return 0;
306         }
307         uint256 c = a * b;
308         assert(c / a == b);
309         return c;
310     }
311 
312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
313         uint256 c = a / b;
314         return c;
315     }
316 
317     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
318         assert(b <= a);
319         return a - b;
320     }
321 
322     function add(uint256 a, uint256 b) internal pure returns (uint256) {
323         uint256 c = a + b;
324         assert(c >= a);
325         return c;
326     }
327 }
328 
329 // File: contracts/IonChainICO.sol
330 
331 /**
332  * @title IONC tokens ICO contract.
333  */
334 contract IonChainICO is BaseICO {
335     using SafeMath for uint;
336 
337     /// @dev 6 decimals for token
338     uint internal constant ONE_TOKEN = 1e6;
339 
340     /// @dev 1e18 WEI == 1ETH == 125000 tokens
341     uint public constant ETH_TOKEN_EXCHANGE_RATIO = 125000;
342 
343     /// @dev Token holder
344     address public tokenHolder;
345 
346     // @dev personal cap for first 48 hours
347     uint public constant PERSONAL_CAP = 1.6 ether;
348 
349     // @dev timestamp for end of personal cap
350     uint public personalCapEndAt;
351 
352     // @dev purchases till personal cap limit end
353     mapping(address => uint) internal personalPurchases;
354 
355     constructor(address icoToken_,
356             address teamWallet_,
357             address tokenHolder_,
358             uint lowCapWei_,
359             uint hardCapWei_,
360             uint lowCapTxWei_,
361             uint hardCapTxWei_) public {
362         require(icoToken_ != address(0) && teamWallet_ != address(0));
363         token = ERC20Token(icoToken_);
364         teamWallet = teamWallet_;
365         tokenHolder = tokenHolder_;
366         state = State.Inactive;
367         lowCapWei = lowCapWei_;
368         hardCapWei = hardCapWei_;
369         lowCapTxWei = lowCapTxWei_;
370         hardCapTxWei = hardCapTxWei_;
371     }
372 
373     /**
374      * Accept direct payments
375      */
376     function() external payable {
377         buyTokens();
378     }
379 
380 
381     function start(uint endAt_) onlyOwner public {
382         uint requireTokens = hardCapWei.mul(ETH_TOKEN_EXCHANGE_RATIO).mul(ONE_TOKEN).div(1 ether);
383         require(token.balanceOf(tokenHolder) >= requireTokens
384             && token.allowance(tokenHolder, address(this)) >= requireTokens);
385         personalCapEndAt = block.timestamp + 48 hours;
386         super.start(endAt_);
387     }
388 
389     /**
390      * @dev Recalculate ICO state based on current block time.
391      * Should be called periodically by ICO owner.
392      */
393     function touch() public {
394         if (state != State.Active && state != State.Suspended) {
395             return;
396         }
397         if (collectedWei >= hardCapWei) {
398             state = State.Completed;
399             endAt = block.timestamp;
400             emit ICOCompleted(collectedWei);
401         } else if (block.timestamp >= endAt) {
402             if (collectedWei < lowCapWei) {
403                 state = State.NotCompleted;
404                 emit ICONotCompleted();
405             } else {
406                 state = State.Completed;
407                 emit ICOCompleted(collectedWei);
408             }
409         }
410     }
411 
412     function buyTokens() public onlyWhitelisted payable {
413         require(state == State.Active &&
414             block.timestamp <= endAt &&
415             msg.value >= lowCapTxWei &&
416             msg.value <= hardCapTxWei &&
417             collectedWei + msg.value <= hardCapWei);
418         uint amountWei = msg.value;
419 
420         // check personal cap
421         if (block.timestamp <= personalCapEndAt) {
422             personalPurchases[msg.sender] = personalPurchases[msg.sender].add(amountWei);
423             require(personalPurchases[msg.sender] <= PERSONAL_CAP);
424         }
425 
426         uint itokens = amountWei.mul(ETH_TOKEN_EXCHANGE_RATIO).mul(ONE_TOKEN).div(1 ether);
427         collectedWei = collectedWei.add(amountWei);
428 
429         emit ICOInvestment(msg.sender, amountWei, itokens, 0);
430         // Transfer tokens to investor
431         token.transferFrom(tokenHolder, msg.sender, itokens);
432         forwardFunds();
433         touch();
434     }
435 }