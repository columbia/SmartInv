1 // File: contracts/intf/IERC20.sol
2 
3 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
4 
5 pragma solidity 0.6.9;
6 pragma experimental ABIEncoderV2;
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
81 
82 /**
83  * @title SafeMath
84  * @author DODO Breeder
85  *
86  * @notice Math operations with safety checks that revert on error
87  */
88 library SafeMath {
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "MUL_ERROR");
96 
97         return c;
98     }
99 
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         require(b > 0, "DIVIDING_ERROR");
102         return a / b;
103     }
104 
105     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 quotient = div(a, b);
107         uint256 remainder = a - quotient * b;
108         if (remainder > 0) {
109             return quotient + 1;
110         } else {
111             return quotient;
112         }
113     }
114 
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b <= a, "SUB_ERROR");
117         return a - b;
118     }
119 
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "ADD_ERROR");
123         return c;
124     }
125 
126     function sqrt(uint256 x) internal pure returns (uint256 y) {
127         uint256 z = x / 2 + 1;
128         y = x;
129         while (z < y) {
130             y = z;
131             z = (x / z + z) / 2;
132         }
133     }
134 }
135 
136 // File: contracts/lib/SafeERC20.sol
137 
138 
139 
140 /**
141  * @title SafeERC20
142  * @dev Wrappers around ERC20 operations that throw on failure (when the token
143  * contract returns false). Tokens that return no value (and instead revert or
144  * throw on failure) are also supported, non-reverting calls are assumed to be
145  * successful.
146  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
147  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
148  */
149 library SafeERC20 {
150     using SafeMath for uint256;
151 
152     function safeTransfer(
153         IERC20 token,
154         address to,
155         uint256 value
156     ) internal {
157         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
158     }
159 
160     function safeTransferFrom(
161         IERC20 token,
162         address from,
163         address to,
164         uint256 value
165     ) internal {
166         _callOptionalReturn(
167             token,
168             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
169         );
170     }
171 
172     function safeApprove(
173         IERC20 token,
174         address spender,
175         uint256 value
176     ) internal {
177         // safeApprove should only be called when setting an initial allowance,
178         // or when resetting it to zero. To increase and decrease it, use
179         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
180         // solhint-disable-next-line max-line-length
181         require(
182             (value == 0) || (token.allowance(address(this), spender) == 0),
183             "SafeERC20: approve from non-zero to non-zero allowance"
184         );
185         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
186     }
187 
188     /**
189      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
190      * on the return value: the return value is optional (but if data is returned, it must not be false).
191      * @param token The token targeted by the call.
192      * @param data The call data (encoded using abi.encode or one of its variants).
193      */
194     function _callOptionalReturn(IERC20 token, bytes memory data) private {
195         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
196         // we're implementing it ourselves.
197 
198         // A Solidity high level call has three parts:
199         //  1. The target address is checked to verify it contains contract code
200         //  2. The call itself is made, and success asserted
201         //  3. The return value is decoded, which in turn checks the size of the returned data.
202         // solhint-disable-next-line max-line-length
203 
204         // solhint-disable-next-line avoid-low-level-calls
205         (bool success, bytes memory returndata) = address(token).call(data);
206         require(success, "SafeERC20: low-level call failed");
207 
208         if (returndata.length > 0) {
209             // Return data is optional
210             // solhint-disable-next-line max-line-length
211             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
212         }
213     }
214 }
215 
216 // File: contracts/lib/DecimalMath.sol
217 
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
259 
260 /**
261  * @title Ownable
262  * @author DODO Breeder
263  *
264  * @notice Ownership related functions
265  */
266 contract InitializableOwnable {
267     address public _OWNER_;
268     address public _NEW_OWNER_;
269     bool internal _INITIALIZED_;
270 
271     // ============ Events ============
272 
273     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     // ============ Modifiers ============
278 
279     modifier notInitialized() {
280         require(!_INITIALIZED_, "DODO_INITIALIZED");
281         _;
282     }
283 
284     modifier onlyOwner() {
285         require(msg.sender == _OWNER_, "NOT_OWNER");
286         _;
287     }
288 
289     // ============ Functions ============
290 
291     function initOwner(address newOwner) public notInitialized {
292         _INITIALIZED_ = true;
293         _OWNER_ = newOwner;
294     }
295 
296     function transferOwnership(address newOwner) public onlyOwner {
297         emit OwnershipTransferPrepared(_OWNER_, newOwner);
298         _NEW_OWNER_ = newOwner;
299     }
300 
301     function claimOwnership() public {
302         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
303         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
304         _OWNER_ = _NEW_OWNER_;
305         _NEW_OWNER_ = address(0);
306     }
307 }
308 
309 // File: contracts/lib/Ownable.sol
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
357 interface IRewardVault {
358     function reward(address to, uint256 amount) external;
359     function withdrawLeftOver(address to, uint256 amount) external; 
360 }
361 
362 contract RewardVault is Ownable {
363     using SafeERC20 for IERC20;
364 
365     address public rewardToken;
366 
367     constructor(address _rewardToken) public {
368         rewardToken = _rewardToken;
369     }
370 
371     function reward(address to, uint256 amount) external onlyOwner {
372         IERC20(rewardToken).safeTransfer(to, amount);
373     }
374 
375     function withdrawLeftOver(address to,uint256 amount) external onlyOwner {
376         uint256 leftover = IERC20(rewardToken).balanceOf(address(this));
377         require(amount <= leftover, "VAULT_NOT_ENOUGH");
378         IERC20(rewardToken).safeTransfer(to, amount);
379     }
380 }
381 
382 // File: contracts/DODOToken/DODOMineV2/BaseMine.sol
383 
384 
385 contract BaseMine is InitializableOwnable {
386     using SafeERC20 for IERC20;
387     using SafeMath for uint256;
388 
389     // ============ Storage ============
390 
391     struct RewardTokenInfo {
392         address rewardToken;
393         uint256 startBlock;
394         uint256 endBlock;
395         address rewardVault;
396         uint256 rewardPerBlock;
397         uint256 accRewardPerShare;
398         uint256 lastRewardBlock;
399         mapping(address => uint256) userRewardPerSharePaid;
400         mapping(address => uint256) userRewards;
401     }
402 
403     RewardTokenInfo[] public rewardTokenInfos;
404 
405     uint256 internal _totalSupply;
406     mapping(address => uint256) internal _balances;
407 
408     // ============ Event =============
409 
410     event Claim(uint256 indexed i, address indexed user, uint256 reward);
411     event UpdateReward(uint256 indexed i, uint256 rewardPerBlock);
412     event UpdateEndBlock(uint256 indexed i, uint256 endBlock);
413     event NewRewardToken(uint256 indexed i, address rewardToken);
414     event RemoveRewardToken(address rewardToken);
415     event WithdrawLeftOver(address owner, uint256 i);
416 
417     // ============ View  ============
418 
419     function getPendingReward(address user, uint256 i) public view returns (uint256) {
420         require(i<rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
421         RewardTokenInfo storage rt = rewardTokenInfos[i];
422         uint256 accRewardPerShare = rt.accRewardPerShare;
423         if (rt.lastRewardBlock != block.number) {
424             accRewardPerShare = _getAccRewardPerShare(i);
425         }
426         return
427             DecimalMath.mulFloor(
428                 balanceOf(user), 
429                 accRewardPerShare.sub(rt.userRewardPerSharePaid[user])
430             ).add(rt.userRewards[user]);
431     }
432 
433     function getPendingRewardByToken(address user, address rewardToken) external view returns (uint256) {
434         return getPendingReward(user, getIdByRewardToken(rewardToken));
435     }
436 
437     function totalSupply() public view returns (uint256) {
438         return _totalSupply;
439     }
440 
441     function balanceOf(address user) public view returns (uint256) {
442         return _balances[user];
443     }
444 
445     function getRewardTokenById(uint256 i) external view returns (address) {
446         require(i<rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
447         RewardTokenInfo memory rt = rewardTokenInfos[i];
448         return rt.rewardToken;
449     }
450 
451     function getIdByRewardToken(address rewardToken) public view returns(uint256) {
452         uint256 len = rewardTokenInfos.length;
453         for (uint256 i = 0; i < len; i++) {
454             if (rewardToken == rewardTokenInfos[i].rewardToken) {
455                 return i;
456             }
457         }
458         require(false, "DODOMineV2: TOKEN_NOT_FOUND");
459     }
460 
461     function getRewardNum() external view returns(uint256) {
462         return rewardTokenInfos.length;
463     }
464 
465     // ============ Claim ============
466 
467     function claimReward(uint256 i) public {
468         require(i<rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
469         _updateReward(msg.sender, i);
470         RewardTokenInfo storage rt = rewardTokenInfos[i];
471         uint256 reward = rt.userRewards[msg.sender];
472         if (reward > 0) {
473             rt.userRewards[msg.sender] = 0;
474             IRewardVault(rt.rewardVault).reward(msg.sender, reward);
475             emit Claim(i, msg.sender, reward);
476         }
477     }
478 
479     function claimAllRewards() external {
480         uint256 len = rewardTokenInfos.length;
481         for (uint256 i = 0; i < len; i++) {
482             claimReward(i);
483         }
484     }
485 
486     // =============== Ownable  ================
487 
488     function addRewardToken(
489         address rewardToken,
490         uint256 rewardPerBlock,
491         uint256 startBlock,
492         uint256 endBlock
493     ) external onlyOwner {
494         require(rewardToken != address(0), "DODOMineV2: TOKEN_INVALID");
495         require(startBlock > block.number, "DODOMineV2: START_BLOCK_INVALID");
496         require(endBlock > startBlock, "DODOMineV2: DURATION_INVALID");
497 
498         uint256 len = rewardTokenInfos.length;
499         for (uint256 i = 0; i < len; i++) {
500             require(
501                 rewardToken != rewardTokenInfos[i].rewardToken,
502                 "DODOMineV2: TOKEN_ALREADY_ADDED"
503             );
504         }
505 
506         RewardTokenInfo storage rt = rewardTokenInfos.push();
507         rt.rewardToken = rewardToken;
508         rt.startBlock = startBlock;
509         rt.endBlock = endBlock;
510         rt.rewardPerBlock = rewardPerBlock;
511         rt.rewardVault = address(new RewardVault(rewardToken));
512 
513         emit NewRewardToken(len, rewardToken);
514     }
515 
516     function removeRewardToken(address rewardToken) external onlyOwner {
517         uint256 len = rewardTokenInfos.length;
518         for (uint256 i = 0; i < len; i++) {
519             if (rewardToken == rewardTokenInfos[i].rewardToken) {
520                 if(i != len - 1) {
521                     rewardTokenInfos[i] = rewardTokenInfos[len - 1];
522                 }
523                 rewardTokenInfos.pop();
524                 emit RemoveRewardToken(rewardToken);
525                 break;
526             }
527         }
528     }
529 
530     function setEndBlock(uint256 i, uint256 newEndBlock)
531         external
532         onlyOwner
533     {
534         require(i < rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
535         _updateReward(address(0), i);
536         RewardTokenInfo storage rt = rewardTokenInfos[i];
537 
538         require(block.number < newEndBlock, "DODOMineV2: END_BLOCK_INVALID");
539         require(block.number > rt.startBlock, "DODOMineV2: NOT_START");
540         require(block.number < rt.endBlock, "DODOMineV2: ALREADY_CLOSE");
541 
542         rt.endBlock = newEndBlock;
543         emit UpdateEndBlock(i, newEndBlock);
544     }
545 
546     function setReward(uint256 i, uint256 newRewardPerBlock)
547         external
548         onlyOwner
549     {
550         require(i < rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
551         _updateReward(address(0), i);
552         RewardTokenInfo storage rt = rewardTokenInfos[i];
553         
554         require(block.number < rt.endBlock, "DODOMineV2: ALREADY_CLOSE");
555 
556         rt.rewardPerBlock = newRewardPerBlock;
557         emit UpdateReward(i, newRewardPerBlock);
558     }
559 
560     function withdrawLeftOver(uint256 i, uint256 amount) external onlyOwner {
561         require(i < rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");
562         
563         RewardTokenInfo storage rt = rewardTokenInfos[i];
564         require(block.number > rt.endBlock, "DODOMineV2: MINING_NOT_FINISHED");
565 
566         IRewardVault(rt.rewardVault).withdrawLeftOver(msg.sender,amount);
567 
568         emit WithdrawLeftOver(msg.sender, i);
569     }
570 
571 
572     // ============ Internal  ============
573 
574     function _updateReward(address user, uint256 i) internal {
575         RewardTokenInfo storage rt = rewardTokenInfos[i];
576         if (rt.lastRewardBlock != block.number){
577             rt.accRewardPerShare = _getAccRewardPerShare(i);
578             rt.lastRewardBlock = block.number;
579         }
580         if (user != address(0)) {
581             rt.userRewards[user] = getPendingReward(user, i);
582             rt.userRewardPerSharePaid[user] = rt.accRewardPerShare;
583         }
584     }
585 
586     function _updateAllReward(address user) internal {
587         uint256 len = rewardTokenInfos.length;
588         for (uint256 i = 0; i < len; i++) {
589             _updateReward(user, i);
590         }
591     }
592 
593     function _getUnrewardBlockNum(uint256 i) internal view returns (uint256) {
594         RewardTokenInfo memory rt = rewardTokenInfos[i];
595         if (block.number < rt.startBlock || rt.lastRewardBlock > rt.endBlock) {
596             return 0;
597         }
598         uint256 start = rt.lastRewardBlock < rt.startBlock ? rt.startBlock : rt.lastRewardBlock;
599         uint256 end = rt.endBlock < block.number ? rt.endBlock : block.number;
600         return end.sub(start);
601     }
602 
603     function _getAccRewardPerShare(uint256 i) internal view returns (uint256) {
604         RewardTokenInfo memory rt = rewardTokenInfos[i];
605         if (totalSupply() == 0) {
606             return rt.accRewardPerShare;
607         }
608         return
609             rt.accRewardPerShare.add(
610                 DecimalMath.divFloor(_getUnrewardBlockNum(i).mul(rt.rewardPerBlock), totalSupply())
611             );
612     }
613 
614 }
615 
616 // File: contracts/DODOToken/DODOMineV2/vDODOMine.sol
617 
618 
619 interface IVDODOToken {
620     function availableBalanceOf(address account) external view returns (uint256);
621 }
622 
623 contract vDODOMine is BaseMine {
624     using SafeERC20 for IERC20;
625     using SafeMath for uint256;
626 
627     // ============ Storage ============
628     address public _vDODO_TOKEN_;
629 
630     function init(address owner, address vDODOToken) external {
631         super.initOwner(owner);
632         _vDODO_TOKEN_ = vDODOToken;
633     }
634 
635     // ============ Event =============
636 
637     event Deposit(address indexed user, uint256 amount);
638     event Withdraw(address indexed user, uint256 amount);
639     event SyncBalance();
640 
641     // ============ Deposit && Withdraw && Exit ============
642 
643     function deposit(uint256 amount) external {
644         require(amount > 0, "DODOMineV2: CANNOT_DEPOSIT_ZERO");
645         require(
646             amount <= IVDODOToken(_vDODO_TOKEN_).availableBalanceOf(msg.sender),
647             "DODOMineV2: vDODO_NOT_ENOUGH"
648         );
649         _updateAllReward(msg.sender);
650         _totalSupply = _totalSupply.add(amount);
651         _balances[msg.sender] = _balances[msg.sender].add(amount);
652         emit Deposit(msg.sender, amount);
653     }
654 
655     function withdraw(uint256 amount) external {
656         require(amount > 0, "DODOMineV2: CANNOT_WITHDRAW_ZERO");
657         require(amount <= _balances[msg.sender], "DODOMineV2: WITHDRAW_BALANCE_NOT_ENOUGH");
658         _updateAllReward(msg.sender);
659         _totalSupply = _totalSupply.sub(amount);
660         _balances[msg.sender] = _balances[msg.sender].sub(amount);
661         emit Withdraw(msg.sender, amount);
662     }
663 
664     function syncBalance(address[] calldata userList) external {
665         for (uint256 i = 0; i < userList.length; ++i) {
666             address user = userList[i];
667             uint256 curBalance = balanceOf(user);
668             uint256 vDODOBalance = IERC20(_vDODO_TOKEN_).balanceOf(user);
669             if (curBalance > vDODOBalance) {
670                 _updateAllReward(user);
671                 _totalSupply = _totalSupply.add(vDODOBalance).sub(curBalance);
672                 _balances[user] = vDODOBalance;
673             }
674         }
675         emit SyncBalance();
676     }
677 
678     // ============ View  ============
679 
680     function getLockedvDODO(address account) external view returns (uint256) {
681         return balanceOf(account);
682     }
683 }