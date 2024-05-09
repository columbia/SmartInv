1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
98 
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Interface of the ERC20 standard as defined in the EIP.
104  */
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: contracts/TokenSwap.sol
177 
178 pragma solidity ^0.8.0;
179 
180 
181 
182 contract TokenSwap is Ownable {
183 
184     event AdminWalletUpdated(address addr);
185     event LockIntervalUpdated(uint256 interval);
186     event LockPercentageUpdated(uint256 percentage);
187     event MinDepositUpdated(uint256 amount);
188 
189     event TokenWithdrawed(uint256 amount);
190 
191     event PhaseCreated(uint256 startTime, uint256 endTime, uint256 swapRate);
192     event PhaseTimeUpdated(uint256 phaseId, uint256 startTime, uint256 endTime);
193     event SwapRateUpdated(uint256 phaseId, uint256 swapRate);
194 
195     event Swapped(uint256 phaseId, address account, uint256 ethDeposit, uint256 ethRefund, uint256 tokenSwap, uint256 tokenLock, string referralCode);
196 
197     event TokenClaimed(uint256 phaseId, address account, uint256 amount);
198     event TotalTokenClaimed(address account, uint256 amount);
199 
200     IERC20 private _token;
201 
202     address private _adminWallet;
203 
204     uint256 private _lockInterval;
205 
206     uint256 private _lockPercentage;
207 
208     uint256 private _minDeposit;
209 
210     struct ReferralCodeInfo {
211         uint128 amount; // ETH
212         uint128 numSwap;
213     }
214 
215     // Mapping referral code to statistics information
216     mapping(string => ReferralCodeInfo) private _referralCodes;
217 
218     struct PhaseInfo {
219         uint128 startTime;
220         uint128 endTime;
221         uint256 swapRate;
222     }
223 
224     uint256 private _totalPhases;
225 
226     // Mapping phase id to phase information
227     mapping(uint256 => PhaseInfo) private _phases;
228 
229     struct LockedBalanceInfo {
230         uint128 amount; // Token
231         uint128 releaseTime;
232     }
233 
234     uint256 private _totalLockedBalance;
235 
236     // Mapping phase id to user address and locked balance information
237     mapping(uint256 => mapping(address => LockedBalanceInfo)) private _lockedBalances;
238 
239     mapping(address => uint256[]) private _boughtPhases;
240 
241     /**
242      * @dev Throws if phase doesn't exist
243      */
244     modifier phaseExist(uint256 phaseId) {
245         require(_phases[phaseId].swapRate > 0, "TokenSwap: phase doesn't exist");
246         _;
247     }
248 
249     /**
250      * @dev Sets initial values
251      */
252     constructor(address token, address adminWallet)
253     {
254         _token = IERC20(token);
255 
256         _adminWallet = adminWallet;
257 
258         _lockInterval = 6 * 30 days; // 6 months
259 
260         _lockPercentage = 75; // 75%
261 
262         _minDeposit = 0.5 ether;
263     }
264 
265     /**
266      * @dev Returns smart contract information
267      */
268     function getContractInfo()
269         public
270         view
271         returns (uint256, uint256, uint256, uint256, uint256, uint256, address, address)
272     {
273         return (
274             _lockInterval, _lockPercentage, _totalLockedBalance, _totalPhases, _token.balanceOf(address(this)), _minDeposit,
275             _adminWallet, address(_token)
276         );
277     }
278 
279     /**
280      * @dev Updates admin wallet address where contains ETH user deposited
281      * to smart contract for swapping
282      */
283     function updateAdminWallet(address adminWallet)
284         public
285         onlyOwner
286     {
287         require(adminWallet != address(0), "TokenSwap: address is invalid");
288 
289         _adminWallet = adminWallet;
290 
291         emit AdminWalletUpdated(adminWallet);
292     }
293 
294     /**
295      * @dev Updates lock interval
296      */
297     function updateLockInterval(uint256 lockInterval)
298         public
299         onlyOwner
300     {
301         _lockInterval = lockInterval;
302 
303         emit LockIntervalUpdated(lockInterval);
304     }
305 
306     /**
307      * @dev Updates lock percentage
308      */
309     function updateLockPercentage(uint256 lockPercentage)
310         public
311         onlyOwner
312     {
313         require(lockPercentage <= 100, "TokenSwap: percentage is invalid");
314 
315         _lockPercentage = lockPercentage;
316 
317         emit LockPercentageUpdated(lockPercentage);
318     }
319 
320     /**
321      * @dev Updates minimum deposit amount
322      */
323     function updateMinDeposit(uint256 minDeposit)
324         public
325         onlyOwner
326     {
327         require(minDeposit > 0, "TokenSwap: amount is invalid");
328 
329         _minDeposit = minDeposit;
330 
331         emit MinDepositUpdated(minDeposit);
332     }
333 
334     /**
335      * @dev Withdraws token out of this smart contract and transfer to 
336      * admin wallet
337      *
338      * Admin can withdraw all tokens that includes locked token of user in case emergency
339      */
340     function withdrawToken(uint256 amount)
341         public
342         onlyOwner
343     {
344         require(amount > 0, "TokenSwap: amount is invalid");
345 
346         _token.transfer(_adminWallet, amount);
347 
348         emit TokenWithdrawed(amount);
349     }
350 
351     /**
352      * @dev Creates new phase
353      */
354     function createPhase(uint256 startTime, uint256 endTime, uint256 swapRate)
355         public
356         onlyOwner
357     {
358         require(startTime >= block.timestamp && startTime > _phases[_totalPhases].endTime && startTime < endTime, "TokenSwap: time is invalid");
359 
360         require(swapRate > 0, "TokenSwap: rate is invalid");
361 
362         _totalPhases++;
363 
364         _phases[_totalPhases] = PhaseInfo(uint128(startTime), uint128(endTime), swapRate);
365 
366         emit PhaseCreated(startTime, endTime, swapRate);
367     }
368 
369     /**
370      * @dev Updates phase time
371      */
372     function updatePhaseTime(uint256 phaseId, uint256 startTime, uint256 endTime)
373         public
374         onlyOwner
375         phaseExist(phaseId)
376     {
377         PhaseInfo storage phase = _phases[phaseId];
378 
379         if (startTime != 0) {
380             phase.startTime = uint128(startTime);
381         }
382 
383         if (endTime != 0) {
384             phase.endTime = uint128(endTime);
385         }
386 
387         require((startTime == 0 || startTime >= block.timestamp) && phase.startTime < phase.endTime, "TokenSwap: time is invalid");
388 
389         emit PhaseTimeUpdated(phaseId, startTime, endTime);
390     }
391 
392     /**
393      * @dev Updates swap rate
394      */
395     function updateSwapRate(uint256 phaseId, uint256 swapRate)
396         public
397         onlyOwner
398         phaseExist(phaseId)
399     {
400         require(swapRate > 0, "TokenSwap: rate is invalid");
401 
402         _phases[phaseId].swapRate = swapRate;
403 
404         emit SwapRateUpdated(phaseId, swapRate);
405     }
406 
407     /**
408      * @dev Returns phase information
409      */
410     function getPhaseInfo(uint256 phaseId)
411         public
412         view
413         returns (PhaseInfo memory)
414     {
415         return _phases[phaseId];
416     }
417 
418     /**
419      * @dev Returns current active phase information
420      */
421     function getActivePhaseInfo()
422         public
423         view
424         returns (uint256, PhaseInfo memory)
425     {
426         uint256 currentTime = block.timestamp;
427 
428         for (uint256 i = 1; i <= _totalPhases; i++) {
429             PhaseInfo memory phase = _phases[i];
430 
431             if (currentTime < phase.endTime) {
432                 return (i, phase);
433             }
434         }
435 
436         return (0, _phases[0]);
437     }
438 
439     /**
440      * @dev Returns referral code information
441      */
442     function getReferralCodeInfo(string memory referralCode)
443         public
444         view
445         returns (ReferralCodeInfo memory)
446     {
447         return _referralCodes[referralCode];
448     }
449 
450     /**
451      * @dev Swaps ETH to token
452      */
453     function swap(uint256 phaseId, string memory referralCode)
454         public
455         payable
456     {
457         require(msg.value >= _minDeposit, "TokenSwap: msg.value is invalid");
458 
459         PhaseInfo memory phase = _phases[phaseId];
460 
461         require(block.timestamp >= phase.startTime && block.timestamp < phase.endTime, "TokenSwap: not in swapping time");
462 
463         uint256 remain = _token.balanceOf(address(this)) - _totalLockedBalance;
464 
465         require(remain > 0, "TokenSwap: not enough token");
466 
467         uint256 amount = msg.value * phase.swapRate / 1 ether;
468 
469         uint refund;
470 
471         // Calculates redundant money
472         if (amount > remain) {
473             refund = (amount - remain) * 1 ether / phase.swapRate;
474             amount = remain;
475         }
476 
477         // Refunds redundant money for user
478         if (refund > 0) {
479             payable(_msgSender()).transfer(refund);
480         }
481 
482         // Transfers money to admin wallet
483         payable(_adminWallet).transfer(msg.value - refund);
484 
485         // Calculates number of tokens that will be locked
486         uint256 locked = amount * _lockPercentage / 100;
487 
488         // Transfers token for user
489         _token.transfer(_msgSender(), amount - locked);
490 
491         // Manages total locked tokens in smart contract
492         _totalLockedBalance += locked;
493 
494         // Manages locked tokens by user
495         LockedBalanceInfo storage balance = _lockedBalances[phaseId][_msgSender()];
496         balance.amount += uint128(locked);
497         balance.releaseTime = uint128(phase.startTime + _lockInterval);
498 
499         // Manages referral codes
500         ReferralCodeInfo storage referral = _referralCodes[referralCode];
501         referral.amount += uint128(msg.value - refund);
502         referral.numSwap++;
503 
504         uint256[] storage phases = _boughtPhases[_msgSender()];
505 
506         if (phases.length == 0 || phases[phases.length - 1] != phaseId) {
507             phases.push(phaseId);
508         }
509 
510         emit Swapped(phaseId, _msgSender(), msg.value, refund, amount, locked, referralCode);
511     }
512 
513     /**
514      * @dev Returns token balance of user in smart contract that includes
515      * claimable and unclaimable
516      */
517     function getTokenBalance(address account)
518         public
519         view
520         returns (uint256, uint256)
521     {
522         uint256 currentTime = block.timestamp;
523 
524         uint256 balance;
525 
526         uint256 lockedBalance;
527 
528         uint256[] memory phases = _boughtPhases[account];
529 
530         for (uint256 i = 0; i < phases.length; i++) {
531             LockedBalanceInfo memory info = _lockedBalances[phases[i]][account];
532 
533             if (info.amount == 0) {
534                 continue;
535             }
536 
537             if (info.releaseTime <= currentTime) {
538                 balance += info.amount;
539 
540             } else {
541                 lockedBalance += info.amount;
542             }
543         }
544 
545         return (balance, lockedBalance);
546     }
547 
548     /**
549      * @dev Claims the remainning token after lock time end
550      */
551     function claimToken()
552         public
553     {
554         address msgSender = _msgSender();
555 
556         uint256 currentTime = block.timestamp;
557 
558         uint256 balance;
559 
560         uint256[] memory phases = _boughtPhases[msgSender];
561 
562         uint256 length = phases.length;
563 
564         for (uint256 i = 0; i < length; i++) {
565             LockedBalanceInfo memory info = _lockedBalances[phases[i]][msgSender];
566 
567             uint256 amount = info.amount;
568 
569             if (amount == 0) {
570                 continue;
571             }
572 
573             if (info.releaseTime <= currentTime) {
574                 balance += amount;
575 
576                 emit TokenClaimed(phases[i], msgSender, amount);
577 
578                 delete _lockedBalances[phases[i]][msgSender];
579             }
580         }
581 
582         require(balance > 0, "TokenSwap: balance isn't enough");
583 
584         _totalLockedBalance -= balance;
585 
586         _token.transfer(msgSender, balance);
587 
588         emit TotalTokenClaimed(msgSender, balance);
589     }
590 
591     /**
592      * @dev Returns locked balance information
593      */
594     function getLockedBalanceInfo(uint256 phaseId, address account)
595         public
596         view
597         returns (LockedBalanceInfo memory)
598     {
599         return _lockedBalances[phaseId][account];
600     }
601 
602     /**
603      * @dev Returns phases that user bought
604      */
605     function getBoughtPhases(address account)
606         public
607         view
608         returns (uint256[] memory)
609     {
610         return _boughtPhases[account];
611     }
612 
613 }