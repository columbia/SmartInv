1 // File: contracts/intf/IERC20.sol
2 
3 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity 0.6.9;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     function decimals() external view returns (uint8);
18 
19     function name() external view returns (string memory);
20 
21     function symbol() external view returns (string memory);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 }
77 
78 // File: contracts/lib/SafeMath.sol
79 
80 
81 /**
82  * @title SafeMath
83  * @author DODO Breeder
84  *
85  * @notice Math operations with safety checks that revert on error
86  */
87 library SafeMath {
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "MUL_ERROR");
95 
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b > 0, "DIVIDING_ERROR");
101         return a / b;
102     }
103 
104     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 quotient = div(a, b);
106         uint256 remainder = a - quotient * b;
107         if (remainder > 0) {
108             return quotient + 1;
109         } else {
110             return quotient;
111         }
112     }
113 
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b <= a, "SUB_ERROR");
116         return a - b;
117     }
118 
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "ADD_ERROR");
122         return c;
123     }
124 
125     function sqrt(uint256 x) internal pure returns (uint256 y) {
126         uint256 z = x / 2 + 1;
127         y = x;
128         while (z < y) {
129             y = z;
130             z = (x / z + z) / 2;
131         }
132     }
133 }
134 
135 // File: contracts/lib/SafeERC20.sol
136 
137 
138 
139 
140 
141 /**
142  * @title SafeERC20
143  * @dev Wrappers around ERC20 operations that throw on failure (when the token
144  * contract returns false). Tokens that return no value (and instead revert or
145  * throw on failure) are also supported, non-reverting calls are assumed to be
146  * successful.
147  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
148  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
149  */
150 library SafeERC20 {
151     using SafeMath for uint256;
152 
153     function safeTransfer(
154         IERC20 token,
155         address to,
156         uint256 value
157     ) internal {
158         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
159     }
160 
161     function safeTransferFrom(
162         IERC20 token,
163         address from,
164         address to,
165         uint256 value
166     ) internal {
167         _callOptionalReturn(
168             token,
169             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
170         );
171     }
172 
173     function safeApprove(
174         IERC20 token,
175         address spender,
176         uint256 value
177     ) internal {
178         // safeApprove should only be called when setting an initial allowance,
179         // or when resetting it to zero. To increase and decrease it, use
180         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
181         // solhint-disable-next-line max-line-length
182         require(
183             (value == 0) || (token.allowance(address(this), spender) == 0),
184             "SafeERC20: approve from non-zero to non-zero allowance"
185         );
186         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
187     }
188 
189     /**
190      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
191      * on the return value: the return value is optional (but if data is returned, it must not be false).
192      * @param token The token targeted by the call.
193      * @param data The call data (encoded using abi.encode or one of its variants).
194      */
195     function _callOptionalReturn(IERC20 token, bytes memory data) private {
196         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
197         // we're implementing it ourselves.
198 
199         // A Solidity high level call has three parts:
200         //  1. The target address is checked to verify it contains contract code
201         //  2. The call itself is made, and success asserted
202         //  3. The return value is decoded, which in turn checks the size of the returned data.
203         // solhint-disable-next-line max-line-length
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = address(token).call(data);
207         require(success, "SafeERC20: low-level call failed");
208 
209         if (returndata.length > 0) {
210             // Return data is optional
211             // solhint-disable-next-line max-line-length
212             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
213         }
214     }
215 }
216 
217 // File: contracts/lib/DecimalMath.sol
218 
219 
220 /**
221  * @title DecimalMath
222  * @author DODO Breeder
223  *
224  * @notice Functions for fixed point number with 18 decimals
225  */
226 library DecimalMath {
227     using SafeMath for uint256;
228 
229     uint256 internal constant ONE = 10**18;
230     uint256 internal constant ONE2 = 10**36;
231 
232     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
233         return target.mul(d) / (10**18);
234     }
235 
236     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
237         return target.mul(d).divCeil(10**18);
238     }
239 
240     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
241         return target.mul(10**18).div(d);
242     }
243 
244     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
245         return target.mul(10**18).divCeil(d);
246     }
247 
248     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
249         return uint256(10**36).div(target);
250     }
251 
252     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
253         return uint256(10**36).divCeil(target);
254     }
255 }
256 
257 // File: contracts/lib/InitializableOwnable.sol
258 
259 /**
260  * @title Ownable
261  * @author DODO Breeder
262  *
263  * @notice Ownership related functions
264  */
265 contract InitializableOwnable {
266     address public _OWNER_;
267     address public _NEW_OWNER_;
268     bool internal _INITIALIZED_;
269 
270     // ============ Events ============
271 
272     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     // ============ Modifiers ============
277 
278     modifier notInitialized() {
279         require(!_INITIALIZED_, "DODO_INITIALIZED");
280         _;
281     }
282 
283     modifier onlyOwner() {
284         require(msg.sender == _OWNER_, "NOT_OWNER");
285         _;
286     }
287 
288     // ============ Functions ============
289 
290     function initOwner(address newOwner) public notInitialized {
291         _INITIALIZED_ = true;
292         _OWNER_ = newOwner;
293     }
294 
295     function transferOwnership(address newOwner) public onlyOwner {
296         emit OwnershipTransferPrepared(_OWNER_, newOwner);
297         _NEW_OWNER_ = newOwner;
298     }
299 
300     function claimOwnership() public {
301         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
302         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
303         _OWNER_ = _NEW_OWNER_;
304         _NEW_OWNER_ = address(0);
305     }
306 }
307 
308 // File: contracts/lib/Ownable.sol
309 
310 
311 /**
312  * @title Ownable
313  * @author DODO Breeder
314  *
315  * @notice Ownership related functions
316  */
317 contract Ownable {
318     address public _OWNER_;
319     address public _NEW_OWNER_;
320 
321     // ============ Events ============
322 
323     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
324 
325     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
326 
327     // ============ Modifiers ============
328 
329     modifier onlyOwner() {
330         require(msg.sender == _OWNER_, "NOT_OWNER");
331         _;
332     }
333 
334     // ============ Functions ============
335 
336     constructor() internal {
337         _OWNER_ = msg.sender;
338         emit OwnershipTransferred(address(0), _OWNER_);
339     }
340 
341     function transferOwnership(address newOwner) external onlyOwner {
342         emit OwnershipTransferPrepared(_OWNER_, newOwner);
343         _NEW_OWNER_ = newOwner;
344     }
345 
346     function claimOwnership() external {
347         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
348         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
349         _OWNER_ = _NEW_OWNER_;
350         _NEW_OWNER_ = address(0);
351     }
352 }
353 
354 // File: contracts/DODOToken/DODOMineV2/RewardVault.sol
355 
356 
357 
358 interface IRewardVault {
359     function reward(address to, uint256 amount) external;
360     function withdrawLeftOver(address to, uint256 amount) external; 
361 }
362 
363 contract RewardVault is Ownable {
364     using SafeERC20 for IERC20;
365 
366     address public rewardToken;
367 
368     constructor(address _rewardToken) public {
369         rewardToken = _rewardToken;
370     }
371 
372     function reward(address to, uint256 amount) external onlyOwner {
373         IERC20(rewardToken).safeTransfer(to, amount);
374     }
375 
376     function withdrawLeftOver(address to,uint256 amount) external onlyOwner {
377         uint256 leftover = IERC20(rewardToken).balanceOf(address(this));
378         require(amount <= leftover, "VAULT_NOT_ENOUGH");
379         IERC20(rewardToken).safeTransfer(to, amount);
380     }
381 }
382 
383 // File: contracts/DODOToken/DODOMineV2/BaseMine.sol
384 
385 
386 
387 
388 contract BaseMine is InitializableOwnable {
389     using SafeERC20 for IERC20;
390     using SafeMath for uint256;
391 
392     // ============ Storage ============
393 
394     struct RewardTokenInfo {
395         address rewardToken;
396         uint256 startBlock;
397         uint256 endBlock;
398         address rewardVault;
399         uint256 rewardPerBlock;
400         uint256 accRewardPerShare;
401         uint256 lastRewardBlock;
402         mapping(address => uint256) userRewardPerSharePaid;
403         mapping(address => uint256) userRewards;
404     }
405 
406     RewardTokenInfo[] public rewardTokenInfos;
407 
408     uint256 internal _totalSupply;
409     mapping(address => uint256) internal _balances;
410 
411     // ============ Event =============
412 
413     event Claim(uint256 indexed i, address indexed user, uint256 reward);
414     event UpdateReward(uint256 indexed i, uint256 rewardPerBlock);
415     event UpdateEndBlock(uint256 indexed i, uint256 endBlock);
416     event NewRewardToken(uint256 indexed i, address rewardToken);
417     event RemoveRewardToken(address rewardToken);
418     event WithdrawLeftOver(address owner, uint256 i);
419 
420     // ============ View  ============
421 
422     function getPendingReward(address user, uint256 i) public view returns (uint256) {
423         require(i<rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
424         RewardTokenInfo storage rt = rewardTokenInfos[i];
425         uint256 accRewardPerShare = rt.accRewardPerShare;
426         if (rt.lastRewardBlock != block.number) {
427             accRewardPerShare = _getAccRewardPerShare(i);
428         }
429         return
430             DecimalMath.mulFloor(
431                 balanceOf(user), 
432                 accRewardPerShare.sub(rt.userRewardPerSharePaid[user])
433             ).add(rt.userRewards[user]);
434     }
435 
436     function getPendingRewardByToken(address user, address rewardToken) external view returns (uint256) {
437         return getPendingReward(user, getIdByRewardToken(rewardToken));
438     }
439 
440     function totalSupply() public view returns (uint256) {
441         return _totalSupply;
442     }
443 
444     function balanceOf(address user) public view returns (uint256) {
445         return _balances[user];
446     }
447 
448     function getRewardTokenById(uint256 i) external view returns (address) {
449         require(i<rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
450         RewardTokenInfo memory rt = rewardTokenInfos[i];
451         return rt.rewardToken;
452     }
453 
454     function getIdByRewardToken(address rewardToken) public view returns(uint256) {
455         uint256 len = rewardTokenInfos.length;
456         for (uint256 i = 0; i < len; i++) {
457             if (rewardToken == rewardTokenInfos[i].rewardToken) {
458                 return i;
459             }
460         }
461         require(false, "DODOMineV2: TOKEN_NOT_FOUND");
462     }
463 
464     function getRewardNum() external view returns(uint256) {
465         return rewardTokenInfos.length;
466     }
467 
468     // ============ Claim ============
469 
470     function claimReward(uint256 i) public {
471         require(i<rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
472         _updateReward(msg.sender, i);
473         RewardTokenInfo storage rt = rewardTokenInfos[i];
474         uint256 reward = rt.userRewards[msg.sender];
475         if (reward > 0) {
476             rt.userRewards[msg.sender] = 0;
477             IRewardVault(rt.rewardVault).reward(msg.sender, reward);
478             emit Claim(i, msg.sender, reward);
479         }
480     }
481 
482     function claimAllRewards() external {
483         uint256 len = rewardTokenInfos.length;
484         for (uint256 i = 0; i < len; i++) {
485             claimReward(i);
486         }
487     }
488 
489     // =============== Ownable  ================
490 
491     function addRewardToken(
492         address rewardToken,
493         uint256 rewardPerBlock,
494         uint256 startBlock,
495         uint256 endBlock
496     ) external onlyOwner {
497         require(rewardToken != address(0), "DODOMineV2: TOKEN_INVALID");
498         require(startBlock > block.number, "DODOMineV2: START_BLOCK_INVALID");
499         require(endBlock > startBlock, "DODOMineV2: DURATION_INVALID");
500 
501         uint256 len = rewardTokenInfos.length;
502         for (uint256 i = 0; i < len; i++) {
503             require(
504                 rewardToken != rewardTokenInfos[i].rewardToken,
505                 "DODOMineV2: TOKEN_ALREADY_ADDED"
506             );
507         }
508 
509         RewardTokenInfo storage rt = rewardTokenInfos.push();
510         rt.rewardToken = rewardToken;
511         rt.startBlock = startBlock;
512         rt.endBlock = endBlock;
513         rt.rewardPerBlock = rewardPerBlock;
514         rt.rewardVault = address(new RewardVault(rewardToken));
515 
516         emit NewRewardToken(len, rewardToken);
517     }
518 
519     function removeRewardToken(address rewardToken) external onlyOwner {
520         uint256 len = rewardTokenInfos.length;
521         for (uint256 i = 0; i < len; i++) {
522             if (rewardToken == rewardTokenInfos[i].rewardToken) {
523                 if(i != len - 1) {
524                     rewardTokenInfos[i] = rewardTokenInfos[len - 1];
525                 }
526                 rewardTokenInfos.pop();
527                 emit RemoveRewardToken(rewardToken);
528                 break;
529             }
530         }
531     }
532 
533     function setEndBlock(uint256 i, uint256 newEndBlock)
534         external
535         onlyOwner
536     {
537         require(i < rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
538         _updateReward(address(0), i);
539         RewardTokenInfo storage rt = rewardTokenInfos[i];
540 
541         require(block.number < newEndBlock, "DODOMineV2: END_BLOCK_INVALID");
542         require(block.number > rt.startBlock, "DODOMineV2: NOT_START");
543         require(block.number < rt.endBlock, "DODOMineV2: ALREADY_CLOSE");
544 
545         rt.endBlock = newEndBlock;
546         emit UpdateEndBlock(i, newEndBlock);
547     }
548 
549     function setReward(uint256 i, uint256 newRewardPerBlock)
550         external
551         onlyOwner
552     {
553         require(i < rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
554         _updateReward(address(0), i);
555         RewardTokenInfo storage rt = rewardTokenInfos[i];
556         
557         require(block.number < rt.endBlock, "DODOMineV2: ALREADY_CLOSE");
558 
559         rt.rewardPerBlock = newRewardPerBlock;
560         emit UpdateReward(i, newRewardPerBlock);
561     }
562 
563     function withdrawLeftOver(uint256 i, uint256 amount) external onlyOwner {
564         require(i < rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
565         
566         RewardTokenInfo storage rt = rewardTokenInfos[i];
567         require(block.number > rt.endBlock, "DODOMineV2: MINING_NOT_FINISHED");
568 
569         IRewardVault(rt.rewardVault).withdrawLeftOver(msg.sender,amount);
570 
571         emit WithdrawLeftOver(msg.sender, i);
572     }
573 
574 
575     // ============ Internal  ============
576 
577     function _updateReward(address user, uint256 i) internal {
578         RewardTokenInfo storage rt = rewardTokenInfos[i];
579         if (rt.lastRewardBlock != block.number){
580             rt.accRewardPerShare = _getAccRewardPerShare(i);
581             rt.lastRewardBlock = block.number;
582         }
583         if (user != address(0)) {
584             rt.userRewards[user] = getPendingReward(user, i);
585             rt.userRewardPerSharePaid[user] = rt.accRewardPerShare;
586         }
587     }
588 
589     function _updateAllReward(address user) internal {
590         uint256 len = rewardTokenInfos.length;
591         for (uint256 i = 0; i < len; i++) {
592             _updateReward(user, i);
593         }
594     }
595 
596     function _getUnrewardBlockNum(uint256 i) internal view returns (uint256) {
597         RewardTokenInfo memory rt = rewardTokenInfos[i];
598         if (block.number < rt.startBlock || rt.lastRewardBlock > rt.endBlock) {
599             return 0;
600         }
601         uint256 start = rt.lastRewardBlock < rt.startBlock ? rt.startBlock : rt.lastRewardBlock;
602         uint256 end = rt.endBlock < block.number ? rt.endBlock : block.number;
603         return end.sub(start);
604     }
605 
606     function _getAccRewardPerShare(uint256 i) internal view returns (uint256) {
607         RewardTokenInfo memory rt = rewardTokenInfos[i];
608         if (totalSupply() == 0) {
609             return rt.accRewardPerShare;
610         }
611         return
612             rt.accRewardPerShare.add(
613                 DecimalMath.divFloor(_getUnrewardBlockNum(i).mul(rt.rewardPerBlock), totalSupply())
614             );
615     }
616 
617 }
618 
619 // File: contracts/DODOToken/DODOMineV2/ERC20Mine.sol
620 
621 
622 
623 contract ERC20Mine is BaseMine {
624     using SafeERC20 for IERC20;
625     using SafeMath for uint256;
626 
627     // ============ Storage ============
628 
629     address public _TOKEN_;
630 
631     function init(address owner, address token) external {
632         super.initOwner(owner);
633         _TOKEN_ = token;
634     }
635 
636     // ============ Event  ============
637 
638     event Deposit(address indexed user, uint256 amount);
639     event Withdraw(address indexed user, uint256 amount);
640 
641     // ============ Deposit && Withdraw && Exit ============
642 
643     function deposit(uint256 amount) external {
644         require(amount > 0, "DODOMineV2: CANNOT_DEPOSIT_ZERO");
645 
646         _updateAllReward(msg.sender);
647 
648         uint256 erc20OriginBalance = IERC20(_TOKEN_).balanceOf(address(this));
649         IERC20(_TOKEN_).safeTransferFrom(msg.sender, address(this), amount);
650         uint256 actualStakeAmount = IERC20(_TOKEN_).balanceOf(address(this)).sub(erc20OriginBalance);
651         
652         _totalSupply = _totalSupply.add(actualStakeAmount);
653         _balances[msg.sender] = _balances[msg.sender].add(actualStakeAmount);
654 
655         emit Deposit(msg.sender, actualStakeAmount);
656     }
657 
658     function withdraw(uint256 amount) external {
659         require(amount > 0, "DODOMineV2: CANNOT_WITHDRAW_ZERO");
660 
661         _updateAllReward(msg.sender);
662         _totalSupply = _totalSupply.sub(amount);
663         _balances[msg.sender] = _balances[msg.sender].sub(amount);
664         IERC20(_TOKEN_).safeTransfer(msg.sender, amount);
665 
666         emit Withdraw(msg.sender, amount);
667     }
668 }