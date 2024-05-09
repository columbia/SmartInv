1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `to`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address to, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `from` to `to` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(
64         address from,
65         address to,
66         uint256 amount
67     ) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 
85 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 
112 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
113 
114 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Contract module which provides a basic access control mechanism, where
120  * there is an account (an owner) that can be granted exclusive access to
121  * specific functions.
122  *
123  * By default, the owner account will be the one that deploys the contract. This
124  * can later be changed with {transferOwnership}.
125  *
126  * This module is used through inheritance. It will make available the modifier
127  * `onlyOwner`, which can be applied to your functions to restrict their use to
128  * the owner.
129  */
130 abstract contract Ownable is Context {
131     address private _owner;
132 
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     /**
136      * @dev Initializes the contract setting the deployer as the initial owner.
137      */
138     constructor() {
139         _transferOwnership(_msgSender());
140     }
141 
142     /**
143      * @dev Returns the address of the current owner.
144      */
145     function owner() public view virtual returns (address) {
146         return _owner;
147     }
148 
149     /**
150      * @dev Throws if called by any account other than the owner.
151      */
152     modifier onlyOwner() {
153         require(owner() == _msgSender(), "Ownable: caller is not the owner");
154         _;
155     }
156 
157     /**
158      * @dev Leaves the contract without owner. It will not be possible to call
159      * `onlyOwner` functions anymore. Can only be called by the current owner.
160      *
161      * NOTE: Renouncing ownership will leave the contract without an owner,
162      * thereby removing any functionality that is only available to the owner.
163      */
164     function renounceOwnership() public virtual onlyOwner {
165         _transferOwnership(address(0));
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Can only be called by the current owner.
171      */
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         _transferOwnership(newOwner);
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Internal function without access restriction.
180      */
181     function _transferOwnership(address newOwner) internal virtual {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 
189 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
190 
191 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev Contract module that helps prevent reentrant calls to a function.
197  *
198  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
199  * available, which can be applied to functions to make sure there are no nested
200  * (reentrant) calls to them.
201  *
202  * Note that because there is a single `nonReentrant` guard, functions marked as
203  * `nonReentrant` may not call one another. This can be worked around by making
204  * those functions `private`, and then adding `external` `nonReentrant` entry
205  * points to them.
206  *
207  * TIP: If you would like to learn more about reentrancy and alternative ways
208  * to protect against it, check out our blog post
209  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
210  */
211 abstract contract ReentrancyGuard {
212     // Booleans are more expensive than uint256 or any type that takes up a full
213     // word because each write operation emits an extra SLOAD to first read the
214     // slot's contents, replace the bits taken up by the boolean, and then write
215     // back. This is the compiler's defense against contract upgrades and
216     // pointer aliasing, and it cannot be disabled.
217 
218     // The values being non-zero value makes deployment a bit more expensive,
219     // but in exchange the refund on every call to nonReentrant will be lower in
220     // amount. Since refunds are capped to a percentage of the total
221     // transaction's gas, it is best to keep them low in cases like this one, to
222     // increase the likelihood of the full refund coming into effect.
223     uint256 private constant _NOT_ENTERED = 1;
224     uint256 private constant _ENTERED = 2;
225 
226     uint256 private _status;
227 
228     constructor() {
229         _status = _NOT_ENTERED;
230     }
231 
232     /**
233      * @dev Prevents a contract from calling itself, directly or indirectly.
234      * Calling a `nonReentrant` function from another `nonReentrant`
235      * function is not supported. It is possible to prevent this from happening
236      * by making the `nonReentrant` function external, and making it call a
237      * `private` function that does the actual work.
238      */
239     modifier nonReentrant() {
240         // On the first call to nonReentrant, _notEntered will be true
241         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
242 
243         // Any calls to nonReentrant after this point will fail
244         _status = _ENTERED;
245 
246         _;
247 
248         // By storing the original value once again, a refund is triggered (see
249         // https://eips.ethereum.org/EIPS/eip-2200)
250         _status = _NOT_ENTERED;
251     }
252 }
253 
254 
255 // File @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol@v0.3.1
256 
257 pragma solidity ^0.8.0;
258 
259 interface AggregatorV3Interface {
260   function decimals() external view returns (uint8);
261 
262   function description() external view returns (string memory);
263 
264   function version() external view returns (uint256);
265 
266   // getRoundData and latestRoundData should both raise "No data present"
267   // if they do not have data to report, instead of returning unset values
268   // which could be misinterpreted as actual reported values.
269   function getRoundData(uint80 _roundId)
270     external
271     view
272     returns (
273       uint80 roundId,
274       int256 answer,
275       uint256 startedAt,
276       uint256 updatedAt,
277       uint80 answeredInRound
278     );
279 
280   function latestRoundData()
281     external
282     view
283     returns (
284       uint80 roundId,
285       int256 answer,
286       uint256 startedAt,
287       uint256 updatedAt,
288       uint80 answeredInRound
289     );
290 }
291 
292 
293 // File contracts/BridgeEth.sol
294 
295 pragma solidity 0.8.7;
296 
297 
298 
299 
300 /** @title This bridge operates on the Binance Smart Chain blockchain. It locks BabyDoge, initiated by a user,
301     * and subject to a flat fee in BNB and a percentage fee in BabyDoge. Unlock is initiated through an external bot and
302     * processed on a different blockchain.
303     */
304 contract BridgeEth is Ownable, ReentrancyGuard {
305     uint256 public nonce;
306     uint256 minimumUSD = 10 * 10 ** 18;
307     uint256 public feeReleaseThreshold = 0.1 ether;
308     mapping(IERC20 => TokenConfig) private _tokenConfig;
309     mapping(IERC20 => mapping(address => uint256)) private _balances;
310     mapping(uint256 => bool) private _processedNonces;
311     IERC20 private _sokuToken;
312     IERC20 private _sutekuToken;
313     bool public paused = false;
314     address payable private _unlocker_bot;
315     address private _pauser_bot;
316     uint256 constant private DAILY_TRANSFER_INTERVAL_ONE_DAY = 86400;
317     uint256 private _dailyTransferNextTimestamp = block.timestamp + DAILY_TRANSFER_INTERVAL_ONE_DAY;
318     address private _newProposedOwner;
319     uint256 private _newOwnerConfirmationTimestamp = block.timestamp;
320 
321     enum ErrorType {UnexpectedRequest, NoBalanceRequest, MigrateBridge}
322 
323     event BridgeTransfer(
324         address indexed token,
325         address indexed from,
326         address indexed to,
327         uint256 amount,
328         uint256 date,
329         uint256 nonce
330     );
331 
332     event BridgeTokensUnlocked(
333         address indexed token,
334         address indexed from,
335         address indexed to,
336         uint256 amount,
337         uint256 date
338     );
339 
340     event FeesReleasedToOwner(
341         uint256 amount,
342         uint256 date
343     );
344 
345     struct TokenConfig{
346         uint256 maximumTransferAmount;
347         uint256 collectedFees;
348         uint256 unlockTokenPercentageFee;
349         uint256 dailyLockTotal;
350         uint256 dailyWithdrawTotal;
351         uint256 dailyTransferLimit;
352         bool exists;
353     }
354 
355     event UnexpectedRequest(
356         address indexed from,
357         address indexed to,
358         uint256 amount,
359         uint256 date,
360         ErrorType indexed error
361     );
362 
363     /** @dev Creates a cross-blockchain bridge.
364       * @param soku -- BEP20 token to bridge.
365       * @param suteku -- BEP20 token to bridge.
366       * @param unlockerBot -- address of account that mints/burns.
367       * @param pauserBot -- address of account that pauses bridge in emergencies.
368       */
369     constructor(address soku, address suteku, address payable unlockerBot, address pauserBot) {
370         require(soku!=address(0) && suteku!=address(0) && unlockerBot != address(0) && pauserBot!= address(0) );
371         _unlocker_bot = unlockerBot;
372         _pauser_bot = pauserBot;
373         _sokuToken = IERC20(soku);
374         _sutekuToken = IERC20(suteku);
375         configTokens();
376     }
377 
378     function configTokens() internal{
379         _tokenConfig[_sokuToken] = TokenConfig({
380             maximumTransferAmount :10000000000000000000000000,
381             collectedFees:0,
382             unlockTokenPercentageFee:0,
383             dailyLockTotal:0,
384             dailyWithdrawTotal:0,
385             dailyTransferLimit:1000000000000000000000000000,
386             exists:true
387         });
388 
389         _tokenConfig[_sutekuToken] = TokenConfig({
390             maximumTransferAmount:10000000000000000000000000,
391             collectedFees:0,
392             unlockTokenPercentageFee:0,
393             dailyLockTotal:0,
394             dailyWithdrawTotal:0,
395             dailyTransferLimit:1000000000000000000000000000,
396             exists:true
397         });
398     }  
399 
400     modifier Pausable() {
401         require( !paused, "Bridge: Paused.");
402         _;
403     }
404 
405     modifier OnlyUnlocker() {
406         require(msg.sender == _unlocker_bot, "Bridge: You can't call this function.");
407         _;
408     }
409 
410     modifier OnlyPauserAndOwner() {
411         require((msg.sender == _pauser_bot || msg.sender == owner()), "Bridge: You can't call this function.");
412         _;
413     }
414 
415     modifier onlySokuTokens(IERC20 token) {
416         require(
417             address(token) == address(_sutekuToken) || 
418             address(token) == address(_sokuToken), "Bridge: Token not authorized.");
419         _;
420     }
421 
422     function resetTransferCounter(IERC20 token) internal {
423         _dailyTransferNextTimestamp = block.timestamp + DAILY_TRANSFER_INTERVAL_ONE_DAY;
424         TokenConfig storage config = _tokenConfig[token];
425         config.dailyLockTotal = 0;
426         config.dailyWithdrawTotal = 0;
427     }
428 
429     /** @dev Locks tokens to bridge. External bot initiates unlock on other blockchain.
430       * @param amount -- Amount of BabyDoge to lock.
431       */
432     function lock(IERC20 token, uint256 amount) external onlySokuTokens(token) Pausable {
433         address sender = msg.sender;
434         require(_tokenConfig[token].exists == true, "Bridge: access denied.");
435         require(token.balanceOf(sender) >= amount, "Bridge: Account has insufficient balance.");
436         TokenConfig storage config = _tokenConfig[token];
437         require(amount <= config.maximumTransferAmount, "Bridge: Please reduce the amount of tokens.");
438 
439         if (block.timestamp >= _dailyTransferNextTimestamp) {
440             resetTransferCounter(token);
441         }
442 
443         config.dailyLockTotal = config.dailyLockTotal + amount;
444 
445         if(config.dailyLockTotal > config.dailyTransferLimit) {
446             revert("Bridge: Daily transfer limit reached.");
447         }
448 
449         require(token.transferFrom(sender, address(this), amount), "Bridge: Transfer failed.");
450 
451         emit BridgeTransfer(
452             address(token),
453             sender,
454             address(this),
455             amount,
456             block.timestamp,
457             nonce
458         );
459         
460         nonce++;
461     }
462 
463     // Verificar limite transacao
464     function release(IERC20 token, address to, uint256 amount, uint256 otherChainNonce) 
465     external OnlyUnlocker() onlySokuTokens(token) Pausable {
466         require(!_processedNonces[otherChainNonce], "Bridge: Transaction processed.");
467         require(to!= address(0), "Bridge: access denied.");
468         TokenConfig storage config = _tokenConfig[token];
469         require(amount <= config.maximumTransferAmount, "Bridge: Transfer blocked.");
470         _processedNonces[otherChainNonce] = true;
471 
472         _balances[token][to] = _balances[token][to] + amount; 
473     }
474 
475     function getPrice() public view returns(uint256){
476         AggregatorV3Interface priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
477         (,int256 answer,,,) = priceFeed.latestRoundData();
478         return uint256(answer * 10000000000);
479     } 
480 
481     function getConversionRate(uint256 ethAmount) public view returns (uint256 ethAmountInUsd){ //wei unit
482         uint256 ethPrice = getPrice();
483         return (ethPrice*ethAmount) / 1000000000000000000; // otherwise 18 + 18 = 36 decimal - need to remove 18 decimal
484     }
485 
486     function getFee() view public returns (uint256 result) {
487         uint256 ethPrice = getPrice();
488         return (((minimumUSD*100000000000000000000) / ethPrice))/100; 
489     }
490     
491     function withdraw(IERC20 token) external onlySokuTokens(token) payable Pausable {
492         require(getConversionRate(msg.value) >= getFee(), "You need to spend more ETH"); // otherwise reverts
493         address claimer = msg.sender;
494         uint256 claimerBalance = _balances[token][claimer];
495         require(claimerBalance > 0, "Bridge: No balance.");
496     
497         TokenConfig storage config = _tokenConfig[token];
498 
499         if (block.timestamp >= _dailyTransferNextTimestamp) {
500             resetTransferCounter(token);
501         }
502 
503         config.dailyWithdrawTotal = config.dailyWithdrawTotal + claimerBalance;
504 
505         if(config.dailyWithdrawTotal > config.dailyTransferLimit) {
506             revert("Bridge: Daily transfer limit reached.");
507         }
508 
509         if(claimerBalance > token.balanceOf(address(this))) {
510             revert('Bridge: No funds in the bridge.');
511         }
512 
513         if (claimerBalance >= config.dailyTransferLimit) {
514             pauseBridge(msg.sender, address(this), claimerBalance);
515             revert('Bridge: Paused.');
516         }
517 
518         if (address(this).balance >= feeReleaseThreshold) {
519             uint256 amountReleased = address(this).balance;
520             (bool success, ) = _unlocker_bot.call{value : amountReleased}("Releasing fee to unlocker");
521             require(success, "Transfer failed.");
522             emit FeesReleasedToOwner(amountReleased, block.timestamp);
523         }
524 
525         _balances[token][claimer] = _balances[token][claimer] - claimerBalance;
526 
527         if (config.unlockTokenPercentageFee > 0) {
528             uint256 amountFee = (claimerBalance * config.unlockTokenPercentageFee) / 100;
529             claimerBalance = claimerBalance - amountFee;
530             config.collectedFees = config.collectedFees + amountFee;
531         }
532         
533         require(token.transfer(claimer, claimerBalance), "Bridge: Transfer failed");
534         
535         emit BridgeTokensUnlocked(address(token), address(this), msg.sender, claimerBalance, block.timestamp);
536     } 
537  
538     function getBalance(IERC20 token) public view onlySokuTokens(token) returns (uint256 balance) {
539         return _balances[token][msg.sender];
540     }
541 
542     function getTokenConfig(IERC20 token) public view onlySokuTokens(token) returns (TokenConfig memory) {
543         return _tokenConfig[token];
544     }
545 
546     function setTokenConfig(
547         IERC20 token, 
548         uint256 maximumTransferAmount, 
549         uint256 unlockTokenPercentageFee,
550         uint256 dailyTransferLimit) external onlySokuTokens(token) onlyOwner() {
551             TokenConfig storage config = _tokenConfig[token];   
552             config.maximumTransferAmount = maximumTransferAmount;
553             config.unlockTokenPercentageFee = unlockTokenPercentageFee;
554             config.dailyTransferLimit = dailyTransferLimit;
555     }
556 
557     function resetDailyTotals(IERC20 token) external onlySokuTokens(token) onlyOwner() {
558         resetTransferCounter(token);
559     }
560 
561     function setMinimumUsdFee(uint256 usd) external onlyOwner() {
562         require(usd > 0, "Can't be zero");
563         minimumUSD = usd * 10 ** 18;
564     }
565 
566     function setTokenPercentageFee(IERC20 token, uint256 tokenFee) external onlyOwner() onlySokuTokens(token) {
567         require(tokenFee < 25, "Bridge: Gotta be smaller then 25") ;
568         TokenConfig storage config = _tokenConfig[token];   
569         require(config.exists, "Bridge: Token not found");
570         config.unlockTokenPercentageFee = tokenFee;
571     }
572 
573     function setFeeReleaseThreshold(uint256 amount) external onlyOwner() {
574         require(amount > 0, "Bridge: Can't be zero");
575         feeReleaseThreshold = amount;
576     }
577 
578     function withdrawEth() external onlyOwner() {
579         uint256 amountReleased = address(this).balance;
580         (bool success, ) = owner().call{value : amountReleased}("Releasing eth to owner");
581         require(success, "Transfer failed");
582     }
583 
584     function withdrawERC20(IERC20 token) external onlyOwner() nonReentrant {
585         require(address(token) != address(0), "Bridge: Can't be zero");
586         require(token.balanceOf(address(this)) >= 0, "Bridge: Account has insufficient balance.");
587         require(token.transfer(owner(), token.balanceOf(address(this))), "Bridge: Transfer failed.");
588     }
589 
590     function withdrawCollectedFees(IERC20 token) external onlyOwner() onlySokuTokens(token) nonReentrant {
591         TokenConfig storage config = _tokenConfig[token];   
592         require(config.exists, "Bridge: Token not found");
593         require(token.balanceOf(address(this)) >= config.collectedFees, "Bridge: Account has insufficient balance.");
594         require(token.transfer(owner(), config.collectedFees), "Bridge: Transfer failed.");
595         config.collectedFees = 0;
596     }
597 
598     function setUnlocker(address _unlocker) external onlyOwner {
599         require(_unlocker != _unlocker_bot, "This address is already set as unlocker.");
600         _unlocker_bot = payable(_unlocker);
601     }
602 
603     function setPauser(address _pauser) external onlyOwner {
604         require(_pauser != _pauser_bot, "This address is already set as pauser.");
605         _pauser_bot = _pauser;
606     }
607 
608     function setPausedState(bool state) external onlyOwner() {
609         paused = state;
610     }
611 
612     function pauseBridge(address from, address to, uint256 amount) internal {
613         paused = true;
614 
615         emit UnexpectedRequest(
616             from,
617             to,
618             amount,
619             block.timestamp,
620             ErrorType.UnexpectedRequest
621         );
622     }
623 
624 }