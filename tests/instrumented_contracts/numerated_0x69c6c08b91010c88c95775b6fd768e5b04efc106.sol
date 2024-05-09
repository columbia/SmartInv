1 /// GebLenderFirstResortRewardsVested.sol
2 
3 // Copyright (C) 2021 Reflexer Labs, INC
4 //
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU Affero General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 //
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU Affero General Public License for more details.
14 //
15 // You should have received a copy of the GNU Affero General Public License
16 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
17 
18 pragma solidity 0.6.7;
19 
20 /**
21  * @dev Contract module that helps prevent reentrant calls to a function.
22  *
23  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
24  * available, which can be applied to functions to make sure there are no nested
25  * (reentrant) calls to them.
26  *
27  * Note that because there is a single `nonReentrant` guard, functions marked as
28  * `nonReentrant` may not call one another. This can be worked around by making
29  * those functions `private`, and then adding `external` `nonReentrant` entry
30  * points to them.
31  *
32  * TIP: If you would like to learn more about reentrancy and alternative ways
33  * to protect against it, check out our blog post
34  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
35  */
36 abstract contract ReentrancyGuard {
37     // Booleans are more expensive than uint256 or any type that takes up a full
38     // word because each write operation emits an extra SLOAD to first read the
39     // slot's contents, replace the bits taken up by the boolean, and then write
40     // back. This is the compiler's defense against contract upgrades and
41     // pointer aliasing, and it cannot be disabled.
42 
43     // The values being non-zero value makes deployment a bit more expensive,
44     // but in exchange the refund on every call to nonReentrant will be lower in
45     // amount. Since refunds are capped to a percentage of the total
46     // transaction's gas, it is best to keep them low in cases like this one, to
47     // increase the likelihood of the full refund coming into effect.
48     uint256 private constant _NOT_ENTERED = 1;
49     uint256 private constant _ENTERED = 2;
50 
51     uint256 private _status;
52 
53     constructor () internal {
54         _status = _NOT_ENTERED;
55     }
56 
57     /**
58      * @dev Prevents a contract from calling itself, directly or indirectly.
59      * Calling a `nonReentrant` function from another `nonReentrant`
60      * function is not supported. It is possible to prevent this from happening
61      * by making the `nonReentrant` function external, and make it call a
62      * `private` function that does the actual work.
63      */
64     modifier nonReentrant() {
65         // On the first call to nonReentrant, _notEntered will be true
66         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
67 
68         // Any calls to nonReentrant after this point will fail
69         _status = _ENTERED;
70 
71         _;
72 
73         // By storing the original value once again, a refund is triggered (see
74         // https://eips.ethereum.org/EIPS/eip-2200)
75         _status = _NOT_ENTERED;
76     }
77 }
78 
79 abstract contract TokenLike {
80     function decimals() virtual public view returns (uint8);
81     function totalSupply() virtual public view returns (uint256);
82     function balanceOf(address) virtual public view returns (uint256);
83     function mint(address, uint) virtual public;
84     function burn(address, uint) virtual public;
85     function approve(address, uint256) virtual external returns (bool);
86     function transfer(address, uint256) virtual external returns (bool);
87     function transferFrom(address,address,uint256) virtual external returns (bool);
88 }
89 abstract contract AuctionHouseLike {
90     function activeStakedTokenAuctions() virtual public view returns (uint256);
91     function startAuction(uint256, uint256) virtual external returns (uint256);
92 }
93 abstract contract AccountingEngineLike {
94     function debtAuctionBidSize() virtual public view returns (uint256);
95     function unqueuedUnauctionedDebt() virtual public view returns (uint256);
96 }
97 abstract contract SAFEEngineLike {
98     function coinBalance(address) virtual public view returns (uint256);
99     function debtBalance(address) virtual public view returns (uint256);
100 }
101 abstract contract RewardDripperLike {
102     function dripReward() virtual external;
103     function dripReward(address) virtual external;
104     function rewardPerBlock() virtual external view returns (uint256);
105     function rewardToken() virtual external view returns (TokenLike);
106 }
107 abstract contract StakingRewardsEscrowLike {
108     function escrowRewards(address, uint256) virtual external;
109 }
110 
111 // Stores tokens, owned by GebLenderFirstResortRewardsVested
112 contract TokenPool {
113     TokenLike public token;
114     address   public owner;
115 
116     constructor(address token_) public {
117         token = TokenLike(token_);
118         owner = msg.sender;
119     }
120 
121     // @notice Transfers tokens from the pool (callable by owner only)
122     function transfer(address to, uint256 wad) public {
123         require(msg.sender == owner, "unauthorized");
124         require(token.transfer(to, wad), "TokenPool/failed-transfer");
125     }
126 
127     // @notice Returns token balance of the pool
128     function balance() public view returns (uint256) {
129         return token.balanceOf(address(this));
130     }
131 }
132 
133 contract GebLenderFirstResortRewardsVested is ReentrancyGuard {
134     // --- Auth ---
135     mapping (address => uint) public authorizedAccounts;
136     /**
137      * @notice Add auth to an account
138      * @param account Account to add auth to
139      */
140     function addAuthorization(address account) virtual external isAuthorized {
141         authorizedAccounts[account] = 1;
142         emit AddAuthorization(account);
143     }
144     /**
145      * @notice Remove auth from an account
146      * @param account Account to remove auth from
147      */
148     function removeAuthorization(address account) virtual external isAuthorized {
149         authorizedAccounts[account] = 0;
150         emit RemoveAuthorization(account);
151     }
152     /**
153     * @notice Checks whether msg.sender can call an authed function
154     **/
155     modifier isAuthorized {
156         require(authorizedAccounts[msg.sender] == 1, "GebLenderFirstResortRewardsVested/account-not-authorized");
157         _;
158     }
159 
160     // --- Structs ---
161     struct ExitRequest {
162         // Exit window deadline
163         uint256 deadline;
164         // Ancestor amount queued for exit
165         uint256 lockedAmount;
166     }
167 
168     // --- Variables ---
169     // Flag that allows/blocks joining
170     bool      public canJoin;
171     // Flag that indicates whether canPrintProtocolTokens can ignore auctioning ancestor tokens
172     bool      public bypassAuctions;
173     // Whether the contract allows forced exits or not
174     bool      public forcedExit;
175     // Last block when a reward was pulled
176     uint256   public lastRewardBlock;
177     // The current delay enforced on an exit
178     uint256   public exitDelay;
179     // Min maount of ancestor tokens that must remain in the contract and not be auctioned
180     uint256   public minStakedTokensToKeep;
181     // Max number of auctions that can be active at a time
182     uint256   public maxConcurrentAuctions;
183     // Amount of ancestor tokens to auction at a time
184     uint256   public tokensToAuction;
185     // Initial amount of system coins to request in exchange for tokensToAuction
186     uint256   public systemCoinsToRequest;
187     // Amount of rewards per share accumulated (total, see rewardDebt for more info)
188     uint256   public accTokensPerShare;
189     // Balance of the rewards token in this contract since last update
190     uint256   public rewardsBalance;
191     // Staked Supply (== sum of all staked balances)
192     uint256   public stakedSupply;
193     // Percentage of claimed rewards that will be vested
194     uint256   public percentageVested;
195     // Whether the escrow is paused or not
196     uint256   public escrowPaused;
197 
198     // Balances (not affected by slashing)
199     mapping(address => uint256)    public descendantBalanceOf;
200     // Exit data
201     mapping(address => ExitRequest) public exitRequests;
202     // The amount of tokens inneligible for claiming rewards (see formula below)
203     mapping(address => uint256)    internal rewardDebt;
204     // Pending reward = (descendant.balanceOf(user) * accTokensPerShare) - rewardDebt[user]
205 
206     // The token being deposited in the pool
207     TokenPool                public ancestorPool;
208     // The token used to pay rewards
209     TokenPool                public rewardPool;
210     // Descendant token
211     TokenLike                public descendant;
212     // Auction house for staked tokens
213     AuctionHouseLike         public auctionHouse;
214     // Accounting engine contract
215     AccountingEngineLike     public accountingEngine;
216     // The safe engine contract
217     SAFEEngineLike           public safeEngine;
218     // Contract that drips rewards
219     RewardDripperLike        public rewardDripper;
220     // Escrow for rewards
221     StakingRewardsEscrowLike public escrow;
222 
223     // Max delay that can be enforced for an exit
224     uint256 public immutable MAX_DELAY;
225 
226     // --- Events ---
227     event AddAuthorization(address account);
228     event RemoveAuthorization(address account);
229     event ModifyParameters(bytes32 indexed parameter, uint256 data);
230     event ModifyParameters(bytes32 indexed parameter, address data);
231     event ToggleJoin(bool canJoin);
232     event ToggleBypassAuctions(bool bypassAuctions);
233     event ToggleForcedExit(bool forcedExit);
234     event AuctionAncestorTokens(address auctionHouse, uint256 amountAuctioned, uint256 amountRequested);
235     event RequestExit(address indexed account, uint256 deadline, uint256 amount);
236     event Join(address indexed account, uint256 price, uint256 amount);
237     event Exit(address indexed account, uint256 price, uint256 amount);
238     event RewardsPaid(address account, uint256 amount);
239     event EscrowRewards(address escrow, address who, uint256 amount);
240     event PoolUpdated(uint256 accTokensPerShare, uint256 stakedSupply);
241     event FailEscrowRewards(bytes revertReason);
242 
243     constructor(
244       address ancestor_,
245       address descendant_,
246       address rewardToken_,
247       address auctionHouse_,
248       address accountingEngine_,
249       address safeEngine_,
250       address rewardDripper_,
251       address escrow_,
252       uint256 maxDelay_,
253       uint256 exitDelay_,
254       uint256 minStakedTokensToKeep_,
255       uint256 tokensToAuction_,
256       uint256 systemCoinsToRequest_,
257       uint256 percentageVested_
258     ) public {
259         require(maxDelay_ > 0, "GebLenderFirstResortRewardsVested/null-max-delay");
260         require(exitDelay_ <= maxDelay_, "GebLenderFirstResortRewardsVested/invalid-exit-delay");
261         require(minStakedTokensToKeep_ > 0, "GebLenderFirstResortRewardsVested/null-min-staked-tokens");
262         require(tokensToAuction_ > 0, "GebLenderFirstResortRewardsVested/null-tokens-to-auction");
263         require(systemCoinsToRequest_ > 0, "GebLenderFirstResortRewardsVested/null-sys-coins-to-request");
264         require(auctionHouse_ != address(0), "GebLenderFirstResortRewardsVested/null-auction-house");
265         require(accountingEngine_ != address(0), "GebLenderFirstResortRewardsVested/null-accounting-engine");
266         require(safeEngine_ != address(0), "GebLenderFirstResortRewardsVested/null-safe-engine");
267         require(rewardDripper_ != address(0), "GebLenderFirstResortRewardsVested/null-reward-dripper");
268         require(escrow_ != address(0), "GebLenderFirstResortRewardsVested/null-escrow");
269         require(percentageVested_ < 100, "GebLenderFirstResortRewardsVested/invalid-percentage-vested");
270         require(descendant_ != address(0), "GebLenderFirstResortRewardsVested/null-descendant");
271 
272         authorizedAccounts[msg.sender] = 1;
273         canJoin                        = true;
274         maxConcurrentAuctions          = uint(-1);
275 
276         MAX_DELAY                      = maxDelay_;
277 
278         exitDelay                      = exitDelay_;
279 
280         minStakedTokensToKeep          = minStakedTokensToKeep_;
281         tokensToAuction                = tokensToAuction_;
282         systemCoinsToRequest           = systemCoinsToRequest_;
283         percentageVested               = percentageVested_;
284 
285         auctionHouse                   = AuctionHouseLike(auctionHouse_);
286         accountingEngine               = AccountingEngineLike(accountingEngine_);
287         safeEngine                     = SAFEEngineLike(safeEngine_);
288         rewardDripper                  = RewardDripperLike(rewardDripper_);
289         escrow                         = StakingRewardsEscrowLike(escrow_);
290         descendant                     = TokenLike(descendant_);
291 
292         ancestorPool                   = new TokenPool(ancestor_);
293         rewardPool                     = new TokenPool(rewardToken_);
294 
295         lastRewardBlock                = block.number;
296 
297         require(ancestorPool.token().decimals() == 18, "GebLenderFirstResortRewardsVested/ancestor-decimal-mismatch");
298         require(descendant.decimals() == 18, "GebLenderFirstResortRewardsVested/descendant-decimal-mismatch");
299 
300         emit AddAuthorization(msg.sender);
301     }
302 
303     // --- Boolean Logic ---
304     function both(bool x, bool y) internal pure returns (bool z) {
305         assembly{ z := and(x, y)}
306     }
307     function either(bool x, bool y) internal pure returns (bool z) {
308         assembly{ z := or(x, y)}
309     }
310 
311     // --- Math ---
312     uint256 public constant WAD = 10 ** 18;
313     uint256 public constant RAY = 10 ** 27;
314 
315     function addition(uint256 x, uint256 y) internal pure returns (uint256 z) {
316         require((z = x + y) >= x, "GebLenderFirstResortRewardsVested/add-overflow");
317     }
318     function subtract(uint256 x, uint256 y) internal pure returns (uint256 z) {
319         require((z = x - y) <= x, "GebLenderFirstResortRewardsVested/sub-underflow");
320     }
321     function multiply(uint x, uint y) internal pure returns (uint z) {
322         require(y == 0 || (z = x * y) / y == x, "GebLenderFirstResortRewardsVested/mul-overflow");
323     }
324     function wdivide(uint x, uint y) internal pure returns (uint z) {
325         require(y > 0, "GebLenderFirstResortRewardsVested/wdiv-by-zero");
326         z = multiply(x, WAD) / y;
327     }
328     function wmultiply(uint x, uint y) internal pure returns (uint z) {
329         z = multiply(x, y) / WAD;
330     }
331 
332     // --- Administration ---
333     /*
334     * @notify Switch between allowing and disallowing joins
335     */
336     function toggleJoin() external isAuthorized {
337         canJoin = !canJoin;
338         emit ToggleJoin(canJoin);
339     }
340     /*
341     * @notify Switch between ignoring and taking into account auctions in canPrintProtocolTokens
342     */
343     function toggleBypassAuctions() external isAuthorized {
344         bypassAuctions = !bypassAuctions;
345         emit ToggleBypassAuctions(bypassAuctions);
346     }
347     /*
348     * @notify Switch between allowing exits when the system is underwater or blocking them
349     */
350     function toggleForcedExit() external isAuthorized {
351         forcedExit = !forcedExit;
352         emit ToggleForcedExit(forcedExit);
353     }
354     /*
355     * @notify Modify an uint256 parameter
356     * @param parameter The name of the parameter to modify
357     * @param data New value for the parameter
358     */
359     function modifyParameters(bytes32 parameter, uint256 data) external isAuthorized {
360         if (parameter == "exitDelay") {
361           require(data <= MAX_DELAY, "GebLenderFirstResortRewardsVested/invalid-exit-delay");
362           exitDelay = data;
363         }
364         else if (parameter == "minStakedTokensToKeep") {
365           require(data > 0, "GebLenderFirstResortRewardsVested/null-min-staked-tokens");
366           minStakedTokensToKeep = data;
367         }
368         else if (parameter == "tokensToAuction") {
369           require(data > 0, "GebLenderFirstResortRewardsVested/invalid-tokens-to-auction");
370           tokensToAuction = data;
371         }
372         else if (parameter == "systemCoinsToRequest") {
373           require(data > 0, "GebLenderFirstResortRewardsVested/invalid-sys-coins-to-request");
374           systemCoinsToRequest = data;
375         }
376         else if (parameter == "maxConcurrentAuctions") {
377           require(data > 1, "GebLenderFirstResortRewardsVested/invalid-max-concurrent-auctions");
378           maxConcurrentAuctions = data;
379         }
380         else if (parameter == "escrowPaused") {
381           require(data <= 1, "GebLenderFirstResortRewardsVested/invalid-escrow-paused");
382           escrowPaused = data;
383         }
384         else if (parameter == "percentageVested") {
385           require(data < 100, "GebLenderFirstResortRewardsVested/invalid-percentage-vested");
386           percentageVested = data;
387         }
388         else revert("GebLenderFirstResortRewardsVested/modify-unrecognized-param");
389         emit ModifyParameters(parameter, data);
390     }
391     /*
392     * @notify Modify an address parameter
393     * @param parameter The name of the parameter to modify
394     * @param data New value for the parameter
395     */
396     function modifyParameters(bytes32 parameter, address data) external isAuthorized {
397         require(data != address(0), "GebLenderFirstResortRewardsVested/null-data");
398 
399         if (parameter == "auctionHouse") {
400           auctionHouse = AuctionHouseLike(data);
401         }
402         else if (parameter == "accountingEngine") {
403           accountingEngine = AccountingEngineLike(data);
404         }
405         else if (parameter == "rewardDripper") {
406           rewardDripper = RewardDripperLike(data);
407         }
408         else if (parameter == "escrow") {
409           escrow = StakingRewardsEscrowLike(data);
410         }
411         else revert("GebLenderFirstResortRewardsVested/modify-unrecognized-param");
412         emit ModifyParameters(parameter, data);
413     }
414 
415     // --- Getters ---
416     /*
417     * @notify Return the ancestor token balance for this contract
418     */
419     function depositedAncestor() public view returns (uint256) {
420         return ancestorPool.balance();
421     }
422     /*
423     * @notify Returns how many ancestor tokens are offered for one descendant token
424     */
425     function ancestorPerDescendant() public view returns (uint256) {
426         return stakedSupply == 0 ? WAD : wdivide(depositedAncestor(), stakedSupply);
427     }
428     /*
429     * @notify Returns how many descendant tokens are offered for one ancestor token
430     */
431     function descendantPerAncestor() public view returns (uint256) {
432         return stakedSupply == 0 ? WAD : wdivide(stakedSupply, depositedAncestor());
433     }
434     /*
435     * @notify Given a custom amount of ancestor tokens, it returns the corresponding amount of descendant tokens to mint when someone joins
436     * @param wad The amount of ancestor tokens to compute the descendant tokens for
437     */
438     function joinPrice(uint256 wad) public view returns (uint256) {
439         return wmultiply(wad, descendantPerAncestor());
440     }
441     /*
442     * @notify Given a custom amount of descendant tokens, it returns the corresponding amount of ancestor tokens to send when someone exits
443     * @param wad The amount of descendant tokens to compute the ancestor tokens for
444     */
445     function exitPrice(uint256 wad) public view returns (uint256) {
446         return wmultiply(wad, ancestorPerDescendant());
447     }
448 
449     /*
450     * @notice Returns whether the protocol is underwater or not
451     */
452     function protocolUnderwater() public view returns (bool) {
453         uint256 unqueuedUnauctionedDebt = accountingEngine.unqueuedUnauctionedDebt();
454 
455         return both(
456           accountingEngine.debtAuctionBidSize() <= unqueuedUnauctionedDebt,
457           safeEngine.coinBalance(address(accountingEngine)) < unqueuedUnauctionedDebt
458         );
459     }
460 
461     /*
462     * @notice Burn descendant tokens in exchange for getting ancestor tokens from this contract
463     * @return Whether the pool can auction ancestor tokens
464     */
465     function canAuctionTokens() public view returns (bool) {
466         return both(
467           both(protocolUnderwater(), addition(minStakedTokensToKeep, tokensToAuction) <= depositedAncestor()),
468           auctionHouse.activeStakedTokenAuctions() < maxConcurrentAuctions
469         );
470     }
471 
472     /*
473     * @notice Returns whether the system can mint new ancestor tokens
474     */
475     function canPrintProtocolTokens() public view returns (bool) {
476         return both(
477           !canAuctionTokens(),
478           either(auctionHouse.activeStakedTokenAuctions() == 0, bypassAuctions)
479         );
480     }
481 
482     /*
483     * @notice Returns unclaimed rewards for a given user
484     */
485     function pendingRewards(address user) public view returns (uint256) {
486         uint accTokensPerShare_ = accTokensPerShare;
487         if (block.number > lastRewardBlock && stakedSupply != 0) {
488             uint increaseInBalance = (block.number - lastRewardBlock) * rewardDripper.rewardPerBlock();
489             accTokensPerShare_ = addition(accTokensPerShare_, multiply(increaseInBalance, RAY) / stakedSupply);
490         }
491         return subtract(multiply(descendantBalanceOf[user], accTokensPerShare_) / RAY, rewardDebt[user]);
492     }
493 
494     /*
495     * @notice Returns rewards earned per block for each token deposited (WAD)
496     */
497     function rewardRate() public view returns (uint256) {
498         if (stakedSupply == 0) return 0;
499         return (rewardDripper.rewardPerBlock() * WAD) / stakedSupply;
500     }
501 
502     // --- Core Logic ---
503     /*
504     * @notify Updates the pool and pays rewards (if any)
505     * @dev Must be included in deposits and withdrawals
506     */
507     modifier payRewards() {
508         updatePool();
509 
510         if (descendantBalanceOf[msg.sender] > 0 && rewardPool.balance() > 0) {
511             // Pays the reward
512             uint256 pending = subtract(multiply(descendantBalanceOf[msg.sender], accTokensPerShare) / RAY, rewardDebt[msg.sender]);
513 
514             uint256 vested;
515             if (both(address(escrow) != address(0), escrowPaused == 0)) {
516               vested = multiply(pending, percentageVested) / 100;
517 
518               try escrow.escrowRewards(msg.sender, vested) {
519                 rewardPool.transfer(address(escrow), vested);
520                 emit EscrowRewards(address(escrow), msg.sender, vested);
521               } catch(bytes memory revertReason) {
522                 emit FailEscrowRewards(revertReason);
523               }
524             }
525 
526             rewardPool.transfer(msg.sender, subtract(pending, vested));
527             rewardsBalance = rewardPool.balance();
528 
529             emit RewardsPaid(msg.sender, pending);
530         }
531         _;
532 
533         rewardDebt[msg.sender] = multiply(descendantBalanceOf[msg.sender], accTokensPerShare) / RAY;
534     }
535 
536     /*
537     * @notify Pays outstanding rewards to msg.sender
538     */
539     function getRewards() external nonReentrant payRewards {}
540 
541     /*
542     * @notify Pull funds from the dripper
543     */
544     function pullFunds() public {
545         rewardDripper.dripReward(address(rewardPool));
546     }
547 
548     /*
549     * @notify Updates pool data
550     */
551     function updatePool() public {
552         if (block.number <= lastRewardBlock) return;
553         lastRewardBlock = block.number;
554         if (stakedSupply == 0) return;
555 
556         pullFunds();
557         uint256 increaseInBalance = subtract(rewardPool.balance(), rewardsBalance);
558         rewardsBalance = addition(rewardsBalance, increaseInBalance);
559 
560         // Updates distribution info
561         accTokensPerShare = addition(accTokensPerShare, multiply(increaseInBalance, RAY) / stakedSupply);
562         emit PoolUpdated(accTokensPerShare, stakedSupply);
563     }
564 
565     /*
566     * @notify Create a new auction that sells ancestor tokens in exchange for system coins
567     */
568     function auctionAncestorTokens() external nonReentrant {
569         require(canAuctionTokens(), "GebLenderFirstResortRewardsVested/cannot-auction-tokens");
570 
571         ancestorPool.transfer(address(this), tokensToAuction);
572         ancestorPool.token().approve(address(auctionHouse), tokensToAuction);
573         auctionHouse.startAuction(tokensToAuction, systemCoinsToRequest);
574         updatePool();
575 
576         emit AuctionAncestorTokens(address(auctionHouse), tokensToAuction, systemCoinsToRequest);
577     }
578 
579     /*
580     * @notify Join ancestor tokens
581     * @param wad The amount of ancestor tokens to join
582     */
583     function join(uint256 wad) external nonReentrant payRewards {
584         require(both(canJoin, !protocolUnderwater()), "GebLenderFirstResortRewardsVested/join-not-allowed");
585         require(wad > 0, "GebLenderFirstResortRewardsVested/null-ancestor-to-join");
586         uint256 price = joinPrice(wad);
587         require(price > 0, "GebLenderFirstResortRewardsVested/null-join-price");
588 
589         require(ancestorPool.token().transferFrom(msg.sender, address(ancestorPool), wad), "GebLenderFirstResortRewardsVested/could-not-transfer-ancestor");
590         descendant.mint(msg.sender, price);
591 
592         descendantBalanceOf[msg.sender] = addition(descendantBalanceOf[msg.sender], price);
593         stakedSupply = addition(stakedSupply, price);
594 
595         emit Join(msg.sender, price, wad);
596     }
597     /*
598     * @notice Request an exit for a specific amount of ancestor tokens
599     * @param wad The amount of tokens to exit
600     */
601     function requestExit(uint wad) external nonReentrant payRewards {
602         require(wad > 0, "GebLenderFirstResortRewardsVested/null-amount-to-exit");
603 
604         exitRequests[msg.sender].deadline      = addition(now, exitDelay);
605         exitRequests[msg.sender].lockedAmount  = addition(exitRequests[msg.sender].lockedAmount, wad);
606 
607         descendantBalanceOf[msg.sender] = subtract(descendantBalanceOf[msg.sender], wad);
608         descendant.burn(msg.sender, wad);
609 
610         emit RequestExit(msg.sender, exitRequests[msg.sender].deadline, wad);
611     }
612     /*
613     * @notify Exit ancestor tokens
614     */
615     function exit() external nonReentrant {
616         require(both(now >= exitRequests[msg.sender].deadline, exitRequests[msg.sender].lockedAmount > 0), "GebLenderFirstResortRewardsVested/wait-more");
617         require(either(!protocolUnderwater(), forcedExit), "GebLenderFirstResortRewardsVested/exit-not-allowed");
618 
619         uint256 price = exitPrice(exitRequests[msg.sender].lockedAmount);
620         stakedSupply  = subtract(stakedSupply, exitRequests[msg.sender].lockedAmount);
621         ancestorPool.transfer(msg.sender, price);
622         emit Exit(msg.sender, price, exitRequests[msg.sender].lockedAmount);
623         delete exitRequests[msg.sender];
624     }
625 }