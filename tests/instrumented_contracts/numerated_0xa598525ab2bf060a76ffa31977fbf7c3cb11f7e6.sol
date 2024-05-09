1 //// SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: contracts/interfaces/IRocketDrop.sol
88 
89 
90 pragma solidity ^0.8.10;
91 // pragma experimental ABIEncoderV2;
92 
93 
94 interface IRocketDrop {
95      struct UserInfo {
96         uint256 amount;     // How many LP tokens the user has provided.
97         uint256 rewardDebt; // Reward debt. See explanation below.
98         uint256 depositStamp;
99     }
100 
101     // Info of each pool.
102     struct PoolInfo {
103         IERC20 lpToken;             // Address of LP token contract.
104         uint256 lastRewardBlock;    // Last block number that ERC20s distribution occurs.
105         uint256 accERC20PerShare;   // Accumulated ERC20s per share, times 1e36.
106         IERC20 rewardToken;         // pool specific reward token.
107         uint256 startBlock;         // pool specific block number when rewards start
108         uint256 endBlock;           // pool specific block number when rewards end
109         uint256 rewardPerBlock;     // pool specific reward per block
110         uint256 paidOut;            // total paid out by pool
111         uint256 tokensStaked;       // allows the same token to be staked across different pools
112         uint256 gasAmount;          // eth fee charged on deposits and withdrawals (per pool)
113         uint256 minStake;           // minimum tokens allowed to be staked
114         uint256 maxStake;           // max tokens allowed to be staked
115         address payable partnerTreasury;    // allows eth fee to be split with a partner on transfer
116         uint256 partnerPercent;     // eth fee percent of partner split, 2 decimals (ie 10000 = 100.00%, 1002 = 10.02%)
117     }
118 
119     // extra parameters for pools; optional
120     struct PoolExtras {
121         uint256 totalStakers;
122         uint256 maxStakers;
123         uint256 lpTokenFee;         // divide by 1000 ie 150 is 1.5%
124         uint256 lockPeriod;         // time in blocks needed before withdrawal
125         IERC20 accessToken;
126         uint256 accessTokenMin;
127         bool accessTokenRequired;
128     }
129 
130     function deposit(uint256 _pid, uint256 _amount) external payable;
131     function withdraw(uint256 _pid, uint256 _amount) external payable;
132     function updatePool(uint256 _pid) external;
133     function pending(uint256 _pid, address _user) external view returns (uint256);
134     function rewardPerBlock(uint) external view returns (uint);
135     function poolExtras(uint) external returns (PoolExtras memory);
136     function userInfo(address) external returns (UserInfo memory);
137     //mapping (uint256 => mapping (address => UserInfo)) public userInfo;
138 }
139 // File: @openzeppelin/contracts/utils/Context.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/access/Ownable.sol
167 
168 
169 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
170 
171 pragma solidity ^0.8.0;
172 
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * By default, the owner account will be the one that deploys the contract. This
180  * can later be changed with {transferOwnership}.
181  *
182  * This module is used through inheritance. It will make available the modifier
183  * `onlyOwner`, which can be applied to your functions to restrict their use to
184  * the owner.
185  */
186 abstract contract Ownable is Context {
187     address private _owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     /**
192      * @dev Initializes the contract setting the deployer as the initial owner.
193      */
194     constructor() {
195         _transferOwnership(_msgSender());
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view virtual returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         _transferOwnership(address(0));
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Can only be called by the current owner.
227      */
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         _transferOwnership(newOwner);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Internal function without access restriction.
236      */
237     function _transferOwnership(address newOwner) internal virtual {
238         address oldOwner = _owner;
239         _owner = newOwner;
240         emit OwnershipTransferred(oldOwner, newOwner);
241     }
242 }
243 
244 // File: contracts/StakeManager.sol
245 
246 
247 
248 pragma solidity ^0.8.10;
249 
250 //import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
251 
252 
253 contract RBXStakeManager is Ownable {
254     IERC20 public rbxs;
255     IRocketDrop public rocketDrop;
256 
257     struct PoolInfo {
258         uint poolID;
259         uint collected;
260         uint distributed;
261         uint amount;
262         uint accounts;
263         uint lastUpdateBlock;
264         uint accruedValuePerShare;
265         uint rewardPerBlock;
266     }
267 
268     struct UserInfo {
269         uint amount;
270         uint distroDebt;
271     }
272 
273     PoolInfo public poolInfo;
274 
275     mapping(address => UserInfo) public userInfo;
276     //mapping()
277 
278     constructor(address _rocketDrop, address _rbxs){
279         rocketDrop = IRocketDrop(_rocketDrop);
280         rbxs = IERC20(_rbxs);
281     }
282 
283     function createAllotment(address account, uint amount) public onlyOwner {
284         UserInfo storage allotment = userInfo[account];
285         require(allotment.amount == 0, "Allotment already established");
286         
287         uint bal0 = rbxs.balanceOf(address(this));
288         rbxs.transferFrom(msg.sender, address(this), amount);
289         rbxs.approve(address(rocketDrop),amount);
290         rocketDrop.deposit(poolInfo.poolID, amount);
291         poolInfo.amount += amount;
292         uint newYield = rbxs.balanceOf(address(this)) - bal0;
293 
294         poolInfo.collected += newYield;
295         poolInfo.accruedValuePerShare += newYield * 1e18 / poolInfo.amount;
296 
297         allotment.amount = amount;
298         allotment.distroDebt = amount * poolInfo.accruedValuePerShare / 1e18;
299 
300         poolInfo.accounts += 1;
301     }
302 
303     function transferAllotment(address account0, address account1, bool withClaim) public onlyOwner {
304         UserInfo storage allotment0 = userInfo[account0];
305         UserInfo storage allotment1 = userInfo[account1];
306         require(allotment0.amount > 0, "Allotment does not exist");
307         
308         if(withClaim)
309             internalClaim(account0);
310 
311         allotment1.amount += allotment0.amount;
312         allotment1.distroDebt += allotment0.distroDebt;
313 
314         allotment0.amount = 0;
315         allotment0.distroDebt = 0;
316     }
317 
318     function discardAllotment(address account, bool withClaim) public onlyOwner {
319         UserInfo storage allotment = userInfo[account];
320         require(allotment.amount > 0, "Allotment does not exist");
321         
322         if(withClaim)
323             internalClaim(account);
324         
325         poolInfo.amount -= allotment.amount;
326         poolInfo.accounts -= 1;
327 
328         allotment.amount = 0;
329         allotment.distroDebt = 0;
330 
331 
332         rocketDrop.withdraw(poolInfo.poolID, allotment.amount);
333         rbxs.transfer(msg.sender, rbxs.balanceOf(address(this)));
334     }
335 
336     function batchCreate(address[] memory accounts, uint[] memory amounts) public onlyOwner {
337         uint totalAmount;
338 
339         for (uint256 i = 0; i < amounts.length; i++) {
340             totalAmount += amounts[i];
341         }
342 
343         if(poolInfo.amount > 0){
344             collectPoolYield();
345         }
346 
347         rbxs.transferFrom(msg.sender, address(this), totalAmount);
348         rbxs.approve(address(rocketDrop),totalAmount);
349         rocketDrop.deposit(poolInfo.poolID, totalAmount);
350 
351         for (uint256 i = 0; i < accounts.length; i++) {
352             require(userInfo[accounts[i]].amount == 0, "Allotment already exists");
353             userInfo[accounts[i]].amount = amounts[i];
354             userInfo[accounts[i]].distroDebt = amounts[i] * poolInfo.accruedValuePerShare / 1e18;
355             poolInfo.accounts += 1;
356             poolInfo.amount += userInfo[accounts[i]].amount;
357         }   
358     }
359 
360     function batchDiscard(address[] memory accounts, uint[] memory amounts) public onlyOwner {
361         uint totalAmount;
362 
363         for (uint256 i = 0; i < amounts.length; i++) {
364             totalAmount += userInfo[accounts[i]].amount;
365         }
366 
367         uint bal0 = rbxs.balanceOf(address(this));
368 
369         rocketDrop.withdraw(poolInfo.poolID, totalAmount);
370         rbxs.transfer(msg.sender, totalAmount);
371 
372         uint newYield = rbxs.balanceOf(address(this)) - bal0;
373 
374         poolInfo.collected += newYield;
375         poolInfo.accruedValuePerShare += newYield * 1e18 / poolInfo.amount;
376 
377         for (uint256 i = 0; i < accounts.length; i++) {
378             poolInfo.amount -= userInfo[accounts[i]].amount;
379             poolInfo.accounts -= 1;
380             userInfo[accounts[i]].amount = 0;
381             userInfo[accounts[i]].distroDebt = 0;
382         }   
383     }
384 
385 
386     function pendingCurrent(address _account) public view returns (uint){
387         UserInfo memory account = userInfo[_account];
388         uint valuePerShare = poolInfo.accruedValuePerShare;
389 
390         return account.amount * valuePerShare / 1e18 - account.distroDebt;
391     }
392 
393 
394     function pending(address _account) public view returns (uint){
395         uint pendingAmount = rocketDrop.pending(poolInfo.poolID, address(this));
396         uint valuePerShare = poolInfo.accruedValuePerShare + (pendingAmount * 1e18 / poolInfo.amount);
397 
398         UserInfo memory account = userInfo[_account];
399 
400         return account.amount * valuePerShare / 1e18 - account.distroDebt;
401     }
402 
403     function accountAllotment(address account) public view returns (uint){
404         return userInfo[account].amount;
405     }
406 
407     function uncollectedYield() public view returns (uint){
408         return rocketDrop.pending(poolInfo.poolID, address(this));
409     }
410 
411     function collectPoolYield() public {
412         if(poolInfo.amount == 0){
413             return;
414         }
415 
416         uint bal0 = rbxs.balanceOf(address(this));
417 
418         rocketDrop.withdraw(poolInfo.poolID, 0);
419         uint newYield = rbxs.balanceOf(address(this)) - bal0;
420         poolInfo.collected += newYield;
421         poolInfo.accruedValuePerShare += newYield * 1e18 / poolInfo.amount;
422 
423     }
424 
425     function claimAccountYield() public {
426         UserInfo storage user = userInfo[msg.sender];
427         collectPoolYield();
428 
429         uint pendingAmount = pendingCurrent(msg.sender);
430 
431         if(pendingAmount > 0){
432             user.distroDebt += pendingAmount;
433             distribute(msg.sender, pendingAmount);
434         }  
435     }
436 
437     function internalClaim(address account) internal {
438         UserInfo storage user = userInfo[account];
439         collectPoolYield();
440 
441         uint pendingAmount = pendingCurrent(account);
442 
443         if(pendingAmount > 0){
444             user.distroDebt += pendingAmount;
445             distribute(account, pendingAmount);
446         }  
447     }
448 
449     function distribute(address to, uint amount) internal {
450         rbxs.transfer(to, amount);
451         poolInfo.distributed += amount;
452     }
453     
454     // used for pool access on rocketDrop
455     function balanceOf(address account) external view returns (uint){
456         return account == address(this) ? 1 : 0;
457     }
458 
459     // admin functions
460     
461     function setPID(uint _pid) public onlyOwner {
462         poolInfo.poolID = _pid;
463     }
464 
465     function adjustBlockReward(uint256 _rewardPerBlock) public onlyOwner {
466         poolInfo.rewardPerBlock = _rewardPerBlock;
467     }
468 
469     function adjustRocketDrop(address _rocketDrop) public onlyOwner {
470         rocketDrop = IRocketDrop(_rocketDrop);
471     }
472 
473     function adjustRBXS(address _rbxs) public onlyOwner {
474         rbxs = IERC20(_rbxs);
475     }
476 
477     function adjustVPS(uint256 _accruedValuePerShare) public onlyOwner {
478         poolInfo.accruedValuePerShare = _accruedValuePerShare;
479     }
480 
481     function tokenRescue(address _recipient, address _ERC20address, uint256 _amount) public onlyOwner {
482         IERC20(_ERC20address).transfer(_recipient, _amount);
483     }
484 
485     function rescueNative(address payable _recipient) public onlyOwner {
486         _recipient.transfer(address(this).balance);
487     }
488 
489     function adjustUser(address _user, uint _amount, uint _distroDebt) public onlyOwner {
490         userInfo[_user].amount = _amount;
491         userInfo[_user].distroDebt = _distroDebt;
492     }
493 
494 }