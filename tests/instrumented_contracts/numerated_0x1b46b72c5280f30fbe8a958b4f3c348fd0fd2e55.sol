1 pragma solidity >=0.6.0;
2 
3 
4 interface IERC20 {
5    
6     function totalSupply() external view returns (uint256);
7 
8   
9     function balanceOf(address account) external view returns (uint256);
10 
11     
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function transferWithoutDeflationary(address recipient, uint256 amount) external returns (bool) ;
14    
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22 
23     
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31    
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39    
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52    
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55         // benefit is lost if 'b' is also tested.
56         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63 
64         return c;
65     }
66 
67     
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         // Solidity only automatically asserts when dividing by 0
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79         return c;
80     }
81 
82     
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86 
87     
88     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b != 0, errorMessage);
90         return a % b;
91     }
92 }
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
117         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
118         // for accounts without code, i.e. `keccak256('')`
119         bytes32 codehash;
120         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
121         // solhint-disable-next-line no-inline-assembly
122         assembly { codehash := extcodehash(account) }
123         return (codehash != accountHash && codehash != 0x0);
124     }
125 
126     /**
127      * @dev Converts an `address` into `address payable`. Note that this is
128      * simply a type cast: the actual underlying value is not changed.
129      *
130      * _Available since v2.4.0._
131      */
132     function toPayable(address account) internal pure returns (address payable) {
133         return address(uint160(account));
134     }
135 
136     /**
137      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
138      * `recipient`, forwarding all available gas and reverting on errors.
139      *
140      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
141      * of certain opcodes, possibly making contracts go over the 2300 gas limit
142      * imposed by `transfer`, making them unable to receive funds via
143      * `transfer`. {sendValue} removes this limitation.
144      *
145      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
146      *
147      * IMPORTANT: because control is transferred to `recipient`, care must be
148      * taken to not create reentrancy vulnerabilities. Consider using
149      * {ReentrancyGuard} or the
150      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
151      *
152      * _Available since v2.4.0._
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
158         (bool success, ) = recipient.call.value(amount)("");
159         require(success, "Address: unable to send value, recipient may have reverted");
160     }
161 }
162 
163 /**
164  * @title SafeERC20
165  * @dev Wrappers around ERC20 operations that throw on failure (when the token
166  * contract returns false). Tokens that return no value (and instead revert or
167  * throw on failure) are also supported, non-reverting calls are assumed to be
168  * successful.
169  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
170  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
171  */
172 library SafeERC20 {
173     using SafeMath for uint256;
174     using Address for address;
175 
176     function safeTransfer(IERC20 token, address to, uint256 value) internal {
177         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
178     }
179 
180     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
181         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
182     }
183 
184     function safeApprove(IERC20 token, address spender, uint256 value) internal {
185         // safeApprove should only be called when setting an initial allowance,
186         // or when resetting it to zero. To increase and decrease it, use
187         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
188         // solhint-disable-next-line max-line-length
189         require((value == 0) || (token.allowance(address(this), spender) == 0),
190             "SafeERC20: approve from non-zero to non-zero allowance"
191         );
192         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
193     }
194 
195     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
196         uint256 newAllowance = token.allowance(address(this), spender).add(value);
197         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
198     }
199 
200     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
201         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
202         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
203     }
204 
205     /**
206      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
207      * on the return value: the return value is optional (but if data is returned, it must not be false).
208      * @param token The token targeted by the call.
209      * @param data The call data (encoded using abi.encode or one of its variants).
210      */
211     function callOptionalReturn(IERC20 token, bytes memory data) private {
212         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
213         // we're implementing it ourselves.
214 
215         // A Solidity high level call has three parts:
216         //  1. The target address is checked to verify it contains contract code
217         //  2. The call itself is made, and success asserted
218         //  3. The return value is decoded, which in turn checks the size of the returned data.
219         // solhint-disable-next-line max-line-length
220         require(address(token).isContract(), "SafeERC20: call to non-contract");
221 
222         // solhint-disable-next-line avoid-low-level-calls
223         (bool success, bytes memory returndata) = address(token).call(data);
224         require(success, "SafeERC20: low-level call failed");
225 
226         if (returndata.length > 0) { // Return data is optional
227             // solhint-disable-next-line max-line-length
228             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
229         }
230     }
231 }
232 
233 contract Context {
234   
235     constructor () internal { }
236 
237     function _msgSender() internal view virtual returns (address payable) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes memory) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
247 /**
248  * @dev Contract module which provides a basic access control mechanism, where
249  * there is an account (an owner) that can be granted exclusive access to
250  * specific functions.
251  *
252  * This module is used through inheritance. It will make available the modifier
253  * `onlyOwner`, which can be applied to your functions to restrict their use to
254  * the owner.
255  */
256 contract Ownable is Context {
257     address private _owner;
258 
259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
260 
261     /**
262      * @dev Initializes the contract setting the deployer as the initial owner.
263      */
264     constructor () internal {
265         address msgSender = _msgSender();
266         _owner = msgSender;
267         emit OwnershipTransferred(address(0), msgSender);
268     }
269 
270     /**
271      * @dev Returns the address of the current owner.
272      */
273     function owner() public view returns (address) {
274         return _owner;
275     }
276 
277     /**
278      * @dev Throws if called by any account other than the owner.
279      */
280     modifier onlyOwner() {
281         require(isOwner(), "Ownable: caller is not the owner");
282         _;
283     }
284 
285     /**
286      * @dev Returns true if the caller is the current owner.
287      */
288     function isOwner() public view returns (bool) {
289         return _msgSender() == _owner;
290     }
291 
292     /**
293      * @dev Leaves the contract without owner. It will not be possible to call
294      * `onlyOwner` functions anymore. Can only be called by the current owner.
295      *
296      * NOTE: Renouncing ownership will leave the contract without an owner,
297      * thereby removing any functionality that is only available to the owner.
298      */
299     function renounceOwnership() public virtual onlyOwner {
300         emit OwnershipTransferred(_owner, address(0));
301         _owner = address(0);
302     }
303 
304     /**
305      * @dev Transfers ownership of the contract to a new account (`newOwner`).
306      * Can only be called by the current owner.
307      */
308     function transferOwnership(address newOwner) public virtual onlyOwner {
309         _transferOwnership(newOwner);
310     }
311 
312     /**
313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
314      */
315     function _transferOwnership(address newOwner) internal virtual {
316         require(newOwner != address(0), "Ownable: new owner is the zero address");
317         emit OwnershipTransferred(_owner, newOwner);
318         _owner = newOwner;
319     }
320 }
321 
322 contract PolkaBridgeStaking is Ownable {
323     string public name = "PolkaBridge: Staking";
324     using SafeMath for uint256;
325     using SafeERC20 for IERC20;
326 
327     struct UserInfo {
328         uint256 amount;
329         uint256 rewardDebt;
330         uint256 rewardClaimed;
331         uint256 lastBlock;
332         uint256 beginTime;
333         uint256 endTime;
334     }
335 
336     // Info of each pool.
337     struct PoolInfo {
338         IERC20 stakeToken;
339         IERC20 rewardToken;
340         uint256 allocPoint;
341         uint256 lastRewardBlock;
342         uint256 accTokenPerShare;
343         uint256 rewardPerBlock;
344         uint256 totalTokenStaked;
345         uint256 totalTokenClaimed;
346         uint256 endDate;
347     }
348 
349     // Info of each pool.
350     PoolInfo[] private poolInfo;
351 
352     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
353     uint256 public totalUser;
354 
355     // The block number when staking  starts.
356     uint256 public startBlock;
357 
358     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
359     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
360     event EmergencyWithdraw(
361         address indexed user,
362         uint256 indexed pid,
363         uint256 amount
364     );
365 
366     constructor(uint256 _startBlock) public {
367         startBlock = _startBlock;
368     }
369 
370     function poolLength() external view returns (uint256) {
371         return poolInfo.length;
372     }
373 
374     function addPool(
375         uint256 _allocPoint,
376         IERC20 _stakeToken,
377         IERC20 _rewardToken,
378         uint256 _rewardPerBlock,
379         uint256 _endDate,
380         bool _withUpdate
381     ) public onlyOwner {
382         if (_withUpdate) {
383             massUpdatePools();
384         }
385         uint256 _lastRewardBlock =
386             block.number > startBlock ? block.number : startBlock;
387 
388         poolInfo.push(
389             PoolInfo({
390                 stakeToken: _stakeToken,
391                 rewardToken: _rewardToken,
392                 allocPoint: _allocPoint,
393                 lastRewardBlock: _lastRewardBlock,
394                 accTokenPerShare: 0,
395                 rewardPerBlock: _rewardPerBlock,
396                 totalTokenStaked: 0,
397                 totalTokenClaimed: 0,
398                 endDate: _endDate
399             })
400         );
401     }
402 
403     function setPool(
404         uint256 _pid,
405         uint256 _allocPoint,
406         uint256 _rewardPerBlock,
407         uint256 _endDate,
408         bool _withUpdate
409     ) public onlyOwner {
410         if (_withUpdate) {
411             massUpdatePools();
412         }
413         if (_allocPoint > 0) {
414             poolInfo[_pid].allocPoint = _allocPoint;
415         }
416         if (_rewardPerBlock > 0) {
417             poolInfo[_pid].rewardPerBlock = _rewardPerBlock;
418         }
419         if (_endDate > 0) {
420             poolInfo[_pid].endDate = _endDate;
421         }
422     }
423 
424     // Return reward multiplier over the given _from to _to block.
425     function getMultiplier(uint256 _fromBlock, uint256 _toBlock)
426         public
427         view
428         returns (uint256)
429     {
430         return _toBlock.sub(_fromBlock);
431     }
432 
433     function getTotalTokenStaked(uint256 _pid) public view returns (uint256) {
434         PoolInfo storage pool = poolInfo[_pid];
435         return pool.totalTokenStaked;
436     }
437 
438     function pendingReward(uint256 _pid, address _user)
439         external
440         view
441         returns (uint256)
442     {
443         PoolInfo storage pool = poolInfo[_pid];
444         UserInfo storage user = userInfo[_pid][_user];
445         uint256 accTokenPerShare = pool.accTokenPerShare;
446         uint256 totalTokenStaked = getTotalTokenStaked(_pid);
447 
448         if (block.number > pool.lastRewardBlock && totalTokenStaked > 0) {
449             uint256 multiplier =
450                 getMultiplier(pool.lastRewardBlock, block.number); //number diff block
451             uint256 tokenReward = multiplier.mul(pool.rewardPerBlock);
452 
453             accTokenPerShare = accTokenPerShare.add(
454                 tokenReward.mul(1e18).div(totalTokenStaked)
455             );
456         }
457         return user.amount.mul(accTokenPerShare).div(1e18).sub(user.rewardDebt);
458     }
459 
460     // Update reward variables for all pools. Be careful of gas spending!
461     function massUpdatePools() public {
462         uint256 length = poolInfo.length;
463         for (uint256 pid = 0; pid < length; ++pid) {
464             updatePool(pid);
465         }
466     }
467 
468     // Update reward variables of the given pool to be up-to-date.
469     function updatePool(uint256 _pid) public {
470         PoolInfo storage pool = poolInfo[_pid];
471         if (block.number <= pool.lastRewardBlock) {
472             return;
473         }
474         uint256 totalTokenStaked = getTotalTokenStaked(_pid);
475 
476         if (totalTokenStaked == 0 || pool.allocPoint == 0) {
477             pool.lastRewardBlock = block.number;
478             return;
479         }
480 
481         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
482         uint256 tokenReward = multiplier.mul(pool.rewardPerBlock);
483 
484         pool.accTokenPerShare = pool.accTokenPerShare.add(
485             tokenReward.mul(1e18).div(totalTokenStaked)
486         );
487         pool.lastRewardBlock = block.number;
488     }
489 
490     function deposit(uint256 _pid, uint256 _amount) public {
491         PoolInfo storage pool = poolInfo[_pid];
492         UserInfo storage user = userInfo[_pid][msg.sender];
493         require(block.timestamp < pool.endDate, "staking pool already closed");
494 
495         updatePool(_pid);
496 
497         if (user.amount > 0) {
498             uint256 pending =
499                 user.amount.mul(pool.accTokenPerShare).div(1e18).sub(
500                     user.rewardDebt
501                 );
502             if (pending > 0) {
503                 safeTokenTransfer(msg.sender, pending, _pid);
504                 pool.totalTokenClaimed = pool.totalTokenClaimed.add(pending);
505                 user.rewardClaimed = user.rewardClaimed.add(pending);
506             }
507         } else {
508             //new user, or old user unstake all before
509             totalUser = totalUser.add(1);
510             user.beginTime = block.timestamp;
511             user.endTime = 0; //reset endtime
512         }
513         if (_amount > 0) {
514             pool.stakeToken.safeTransferFrom(
515                 address(msg.sender),
516                 address(this),
517                 _amount
518             );
519             user.amount = user.amount.add(_amount);
520             pool.totalTokenStaked = pool.totalTokenStaked.add(_amount);
521         }
522         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e18);
523         user.lastBlock = block.number;
524         emit Deposit(msg.sender, _pid, _amount);
525     }
526 
527     function withdraw(uint256 _pid, uint256 _amount) public {
528         PoolInfo storage pool = poolInfo[_pid];
529         UserInfo storage user = userInfo[_pid][msg.sender];
530         require(user.amount >= _amount, "withdraw: bad request");
531         updatePool(_pid);
532         uint256 pending =
533             user.amount.mul(pool.accTokenPerShare).div(1e18).sub(
534                 user.rewardDebt
535             );
536         if (pending > 0) {
537             safeTokenTransfer(msg.sender, pending, _pid);
538             pool.totalTokenClaimed = pool.totalTokenClaimed.add(pending);
539             user.rewardClaimed = user.rewardClaimed.add(pending);
540         }
541         if (_amount > 0) {
542             user.amount = user.amount.sub(_amount);
543             if (user.amount == 0) {
544                 user.endTime = block.timestamp;
545             }
546             pool.totalTokenStaked = pool.totalTokenStaked.sub(_amount);
547 
548             pool.stakeToken.safeTransfer(address(msg.sender), _amount);
549         }
550         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e18);
551         user.lastBlock = block.number;
552         emit Withdraw(msg.sender, _pid, _amount);
553     }
554 
555     function emergencyWithdraw(uint256 _pid) public {
556         PoolInfo storage pool = poolInfo[_pid];
557         UserInfo storage user = userInfo[_pid][msg.sender];
558         uint256 amount = user.amount;
559         user.amount = 0;
560         user.rewardDebt = 0;
561         pool.stakeToken.safeTransfer(address(msg.sender), amount);
562         emit EmergencyWithdraw(msg.sender, _pid, amount);
563     }
564 
565     function safeTokenTransfer(
566         address _to,
567         uint256 _amount,
568         uint256 _pid
569     ) internal {
570         PoolInfo storage pool = poolInfo[_pid];
571         uint256 totalPoolReward = pool.allocPoint;
572 
573         if (_amount > totalPoolReward) {
574             pool.rewardToken.transfer(_to, totalPoolReward);
575         } else {
576             pool.rewardToken.transfer(_to, _amount);
577         }
578     }
579 
580     function getPoolInfo(uint256 _pid)
581         public
582         view
583         returns (
584             uint256,
585             uint256,
586             uint256,
587             uint256,
588             uint256
589         )
590     {
591         return (
592             poolInfo[_pid].accTokenPerShare,
593             poolInfo[_pid].lastRewardBlock,
594             poolInfo[_pid].rewardPerBlock,
595             poolInfo[_pid].totalTokenStaked,
596             poolInfo[_pid].totalTokenClaimed
597         );
598     }
599 
600     function getDiffBlock(address user, uint256 pid)
601         public
602         view
603         returns (uint256)
604     {
605         UserInfo memory user = userInfo[pid][user];
606         return block.number.sub(user.lastBlock);
607     }
608 }