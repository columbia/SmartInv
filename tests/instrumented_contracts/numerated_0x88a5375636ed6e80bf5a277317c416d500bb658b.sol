1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 //Address (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol)
5 
6 /**
7  * @dev Collection of functions related to the address type
8  */
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      * ====
26      */
27     function isContract(address account) internal view returns (bool) {
28         // This method relies on extcodesize, which returns 0 for contracts in
29         // construction, since the code is only stored at the end of the
30         // constructor execution.
31 
32         uint256 size;
33         assembly {
34             size := extcodesize(account)
35         }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         (bool success, ) = recipient.call{value: amount}("");
59         require(success, "Address: unable to send value, recipient may have reverted");
60     }
61 
62     /**
63      * @dev Performs a Solidity function call using a low level `call`. A
64      * plain `call` is an unsafe replacement for a function call: use this
65      * function instead.
66      *
67      * If `target` reverts with a revert reason, it is bubbled up by this
68      * function (like regular Solidity function calls).
69      *
70      * Returns the raw returned data. To convert to the expected return value,
71      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
72      *
73      * Requirements:
74      *
75      * - `target` must be a contract.
76      * - calling `target` with `data` must not revert.
77      *
78      * _Available since v3.1._
79      */
80     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
81         return functionCall(target, data, "Address: low-level call failed");
82     }
83 
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(
91         address target,
92         bytes memory data,
93         string memory errorMessage
94     ) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
100      * but also transferring `value` wei to `target`.
101      *
102      * Requirements:
103      *
104      * - the calling contract must have an ETH balance of at least `value`.
105      * - the called Solidity function must be `payable`.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint256 value
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
119      * with `errorMessage` as a fallback revert reason when `target` reverts.
120      *
121      * _Available since v3.1._
122      */
123     function functionCallWithValue(
124         address target,
125         bytes memory data,
126         uint256 value,
127         string memory errorMessage
128     ) internal returns (bytes memory) {
129         require(address(this).balance >= value, "Address: insufficient balance for call");
130         require(isContract(target), "Address: call to non-contract");
131 
132         (bool success, bytes memory returndata) = target.call{value: value}(data);
133         return verifyCallResult(success, returndata, errorMessage);
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
138      * but performing a static call.
139      *
140      * _Available since v3.3._
141      */
142     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
143         return functionStaticCall(target, data, "Address: low-level static call failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(
153         address target,
154         bytes memory data,
155         string memory errorMessage
156     ) internal view returns (bytes memory) {
157         require(isContract(target), "Address: static call to non-contract");
158 
159         (bool success, bytes memory returndata) = target.staticcall(data);
160         return verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but performing a delegate call.
166      *
167      * _Available since v3.4._
168      */
169     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         require(isContract(target), "Address: delegate call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.delegatecall(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     /**
191      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
192      * revert reason using the provided one.
193      *
194      * _Available since v4.3._
195      */
196     function verifyCallResult(
197         bool success,
198         bytes memory returndata,
199         string memory errorMessage
200     ) internal pure returns (bytes memory) {
201         if (success) {
202             return returndata;
203         } else {
204             // Look for revert reason and bubble it up if present
205             if (returndata.length > 0) {
206                 // The easiest way to bubble the revert reason is using memory via assembly
207 
208                 assembly {
209                     let returndata_size := mload(returndata)
210                     revert(add(32, returndata), returndata_size)
211                 }
212             } else {
213                 revert(errorMessage);
214             }
215         }
216     }
217 }
218 // Context (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol) 
219 /**
220  * @dev Provides information about the current execution context, including the
221  * sender of the transaction and its data. While these are generally available
222  * via msg.sender and msg.data, they should not be accessed in such a direct
223  * manner, since when dealing with meta-transactions the account sending and
224  * paying for execution may not be the actual sender (as far as an application
225  * is concerned).
226  *
227  * This contract is only required for intermediate, library-like contracts.
228  */
229 abstract contract Context {
230     function _msgSender() internal view virtual returns (address) {
231         return msg.sender;
232     }
233 
234     function _msgData() internal view virtual returns (bytes calldata) {
235         return msg.data;
236     }
237 }
238 
239 // Ownable (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol)
240 
241 /**
242  * @dev Contract module which provides a basic access control mechanism, where
243  * there is an account (an owner) that can be granted exclusive access to
244  * specific functions.
245  *
246  * By default, the owner account will be the one that deploys the contract. This
247  * can later be changed with {transferOwnership}.
248  *
249  * This module is used through inheritance. It will make available the modifier
250  * `onlyOwner`, which can be applied to your functions to restrict their use to
251  * the owner.
252  */
253 abstract contract Ownable is Context {
254     address private _owner;
255 
256     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258     /**
259      * @dev Initializes the contract setting the deployer as the initial owner.
260      */
261     constructor() {
262         _transferOwnership(_msgSender());
263     }
264 
265     /**
266      * @dev Returns the address of the current owner.
267      */
268     function owner() public view virtual returns (address) {
269         return _owner;
270     }
271 
272     /**
273      * @dev Throws if called by any account other than the owner.
274      */
275     modifier onlyOwner() {
276         require(owner() == _msgSender(), "Ownable: caller is not the owner");
277         _;
278     }
279 
280     /**
281      * @dev Leaves the contract without owner. It will not be possible to call
282      * `onlyOwner` functions anymore. Can only be called by the current owner.
283      *
284      * NOTE: Renouncing ownership will leave the contract without an owner,
285      * thereby removing any functionality that is only available to the owner.
286      */
287     function renounceOwnership() public virtual onlyOwner {
288         _transferOwnership(address(0xdead));
289     }
290 
291     /**
292      * @dev Transfers ownership of the contract to a new account (`newOwner`).
293      * Can only be called by the current owner.
294      */
295     function transferOwnership(address newOwner) public virtual onlyOwner {
296         require(newOwner != address(0xdead), "Ownable: new owner is the zero address");
297         _transferOwnership(newOwner);
298     }
299 
300     /**
301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
302      * Internal function without access restriction.
303      */
304     function _transferOwnership(address newOwner) internal virtual {
305         address oldOwner = _owner;
306         _owner = newOwner;
307         emit OwnershipTransferred(oldOwner, newOwner);
308     }
309 }
310 
311 
312 
313 // ReentrancyGuard (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
314 /**
315  * @dev Contract module that helps prevent reentrant calls to a function.
316  *
317  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
318  * available, which can be applied to functions to make sure there are no nested
319  * (reentrant) calls to them.
320  *
321  * Note that because there is a single `nonReentrant` guard, functions marked as
322  * `nonReentrant` may not call one another. This can be worked around by making
323  * those functions `private`, and then adding `external` `nonReentrant` entry
324  * points to them.
325  *
326  * TIP: If you would like to learn more about reentrancy and alternative ways
327  * to protect against it, check out our blog post
328  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
329  */
330 abstract contract ReentrancyGuard {
331     // Booleans are more expensive than uint256 or any type that takes up a full
332     // word because each write operation emits an extra SLOAD to first read the
333     // slot's contents, replace the bits taken up by the boolean, and then write
334     // back. This is the compiler's defense against contract upgrades and
335     // pointer aliasing, and it cannot be disabled.
336 
337     // The values being non-zero value makes deployment a bit more expensive,
338     // but in exchange the refund on every call to nonReentrant will be lower in
339     // amount. Since refunds are capped to a percentage of the total
340     // transaction's gas, it is best to keep them low in cases like this one, to
341     // increase the likelihood of the full refund coming into effect.
342     uint256 private constant _NOT_ENTERED = 1;
343     uint256 private constant _ENTERED = 2;
344 
345     uint256 private _status;
346 
347     constructor() {
348         _status = _NOT_ENTERED;
349     }
350 
351     /**
352      * @dev Prevents a contract from calling itself, directly or indirectly.
353      * Calling a `nonReentrant` function from another `nonReentrant`
354      * function is not supported. It is possible to prevent this from happening
355      * by making the `nonReentrant` function external, and making it call a
356      * `private` function that does the actual work.
357      */
358     modifier nonReentrant() {
359         // On the first call to nonReentrant, _notEntered will be true
360         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
361 
362         // Any calls to nonReentrant after this point will fail
363         _status = _ENTERED;
364 
365         _;
366 
367         // By storing the original value once again, a refund is triggered (see
368         // https://eips.ethereum.org/EIPS/eip-2200)
369         _status = _NOT_ENTERED;
370     }
371 }
372 								//
373 // IERC20 (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol)
374 /**
375  * @dev Interface of the ERC20 standard as defined in the EIP.
376  */
377 interface IERC20 {
378     /**
379      * @dev Returns the amount of tokens in existence.
380      */
381     function totalSupply() external view returns (uint256);
382 
383     /**
384      * @dev Returns the amount of tokens owned by `account`.
385      */
386     function balanceOf(address account) external view returns (uint256);
387 
388     /**
389      * @dev Moves `amount` tokens from the caller's account to `recipient`.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transfer(address recipient, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Returns the remaining number of tokens that `spender` will be
399      * allowed to spend on behalf of `owner` through {transferFrom}. This is
400      * zero by default.
401      *
402      * This value changes when {approve} or {transferFrom} are called.
403      */
404     function allowance(address owner, address spender) external view returns (uint256);
405 
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * IMPORTANT: Beware that changing an allowance with this method brings the risk
412      * that someone may use both the old and the new allowance by unfortunate
413      * transaction ordering. One possible solution to mitigate this race
414      * condition is to first reduce the spender's allowance to 0 and set the
415      * desired value afterwards:
416      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
417      *
418      * Emits an {Approval} event.
419      */
420     function approve(address spender, uint256 amount) external returns (bool);
421 
422     /**
423      * @dev Moves `amount` tokens from `sender` to `recipient` using the
424      * allowance mechanism. `amount` is then deducted from the caller's
425      * allowance.
426      *
427      * Returns a boolean value indicating whether the operation succeeded.
428      *
429      * Emits a {Transfer} event.
430      */
431     function transferFrom(
432         address sender,
433         address recipient,
434         uint256 amount
435     ) external returns (bool);
436 
437     /**
438      * @dev Emitted when `value` tokens are moved from one account (`from`) to
439      * another (`to`).
440      *
441      * Note that `value` may be zero.
442      */
443     event Transfer(address indexed from, address indexed to, uint256 value);
444 
445     /**
446      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
447      * a call to {approve}. `value` is the new allowance.
448      */
449     event Approval(address indexed owner, address indexed spender, uint256 value);
450 }
451 
452 interface IUniswapV2Router02 {
453     function factory() external pure returns (address);
454 
455     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
456         uint256 amountIn,
457         uint256 amountOutMin,
458         address[] calldata path,
459         address to,
460         uint256 deadline
461     ) external;
462 }
463 
464 
465 // SafeERC20 (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol)
466 /**
467  * @title SafeERC20
468  * @dev Wrappers around ERC20 operations that throw on failure (when the token
469  * contract returns false). Tokens that return no value (and instead revert or
470  * throw on failure) are also supported, non-reverting calls are assumed to be
471  * successful.
472  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
473  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
474  */ 
475 library SafeERC20 {
476     using Address for address;
477 
478     function safeTransfer(
479         IERC20 token,
480         address to,
481         uint256 value
482     ) internal {
483         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
484     }
485 
486     function safeTransferFrom(
487         IERC20 token,
488         address from,
489         address to,
490         uint256 value
491     ) internal {
492         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
493     }
494 
495     /**
496      * @dev Deprecated. This function has issues similar to the ones found in
497      * {IERC20-approve}, and its usage is discouraged.
498      *
499      * Whenever possible, use {safeIncreaseAllowance} and
500      * {safeDecreaseAllowance} instead.
501      */
502     function safeApprove(
503         IERC20 token,
504         address spender,
505         uint256 value
506     ) internal {
507         // safeApprove should only be called when setting an initial allowance,
508         // or when resetting it to zero. To increase and decrease it, use
509         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
510         require(
511             (value == 0) || (token.allowance(address(this), spender) == 0),
512             "SafeERC20: approve from non-zero to non-zero allowance"
513         );
514         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
515     }
516 
517     function safeIncreaseAllowance(
518         IERC20 token,
519         address spender,
520         uint256 value
521     ) internal {
522         uint256 newAllowance = token.allowance(address(this), spender) + value;
523         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
524     }
525 
526     function safeDecreaseAllowance(
527         IERC20 token,
528         address spender,
529         uint256 value
530     ) internal {
531         unchecked {
532             uint256 oldAllowance = token.allowance(address(this), spender);
533             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
534             uint256 newAllowance = oldAllowance - value;
535             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536         }
537     }
538 
539     /**
540      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
541      * on the return value: the return value is optional (but if data is returned, it must not be false).
542      * @param token The token targeted by the call.
543      * @param data The call data (encoded using abi.encode or one of its variants).
544      */
545     function _callOptionalReturn(IERC20 token, bytes memory data) private {
546         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
547         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
548         // the target address contains contract code and also asserts for success in the low-level call.
549 
550         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
551         if (returndata.length > 0) {
552             // Return data is optional
553             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
554         }
555     }
556 }
557 
558 
559 
560 // Staking contract (this is forked, rewritten for 0.8.x, gas optimized and functionally modified from GooseDefi's MasterchefV2, codebase is battle tested countless times and is totally safe).
561 // You're free to publish, distribute and modify a copy of this contract as you want. Please mention where it's from though. 
562 // Have fun reading it :) ( Original contract : https://github.com/goosedefi/goose-contracts/blob/master/contracts/MasterChefV2.sol). 
563 // RWT is a placeholder name for the upcoming reward token
564 contract SpiralChef is Ownable, ReentrancyGuard{
565     using SafeERC20 for IERC20;
566 	
567     // Info of each user.
568     struct UserInfo {
569         uint256 amount;             // How many LP tokens the user has provided.    //
570         uint256[] rewardDebt;		    // Reward debt. See explanation below.            
571         uint256[] claimableRWT;
572         
573     }
574     // Info of each pool.
575     struct PoolInfo {
576         IERC20 lpToken;             // Address of LP token contract.
577         uint64 allocPoint;          // How many allocation points assigned to this pool. 
578         uint64 lastRewardBlock;     // Last block number that rewards distribution occurs.
579         uint256[] accRwtPerShare;     // Accumulated RWTs per share, times 1e30.   
580     }
581 
582   
583     IERC20 public spiral;
584 	// The reward tokens 
585 	IERC20[] public rwt;
586     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
587 	uint256[] public perBurn;
588     uint256[] public maxBurn;
589     uint256[] public rwtPerBlock;
590     mapping(address => mapping(uint256 => uint256)) public userBurnt;
591     // Info of each pool.
592     PoolInfo[] public poolInfo;
593     // Info of each user that stakes LP tokens.
594     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
595     // Total allocation points. Must be the sum of all allocation points in all pools.
596     uint256 public totalAllocPoint;
597     // The block number when the farm starts mining starts.
598     uint256 public startBlock;
599     uint256 public lockUntil;
600 	bool public isEmergency;
601 	event RewardTokenSet(IERC20 indexed spiralddress, uint256 indexed rwtPerBlock, uint256 timestamp);
602     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
603     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
604     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
605     event UpdateEmissionRate(address indexed user, uint256 rwtPerBlock);
606     event Burn(address indexed user, uint256 burnAmount);
607 	event Emergency(uint256 timestamp, bool ifEmergency);
608     mapping(IERC20 => bool) public poolExistence;
609     mapping(IERC20 => bool) public rwtExistence;
610 
611     modifier nonDuplicated(IERC20 _lpToken) {
612         require(poolExistence[_lpToken] == false, "nonDuplicated: duplicated");
613         _;
614     }
615 
616     modifier nonDuplicatedRWT(IERC20 _rwtToken) {
617         require(rwtExistence[_rwtToken] == false, "nonDuplicated: duplicated");
618         _;
619     }
620     
621     modifier onlyEmergency {
622         require(isEmergency == true, "onlyEmergency: Emergency use only!");
623         _;
624     }
625     mapping(address => bool) public authorized;
626     modifier onlyAuthorized {
627         require(authorized[msg.sender] == true, "onlyAuthorized: address not authorized");
628         _;
629     }
630     constructor(IERC20 _spiral) {
631         spiral = _spiral;
632 		startBlock = type(uint256).max;
633         add(1, _spiral, false);
634     }
635 
636 //--------------------------------------------------------VIEW FUNCTIONS --------------------------------------------------------
637     // Return number of pools
638 	function poolLength() external view returns (uint256) {
639         return poolInfo.length;
640     }
641     // Return reward multiplier over the given _from to _to block.
642     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
643         return (_to - _from);
644     }
645 
646     // View function to see pending rewards on frontend.
647     function pendingRewards(uint256 _pid, address _user) external view returns (uint256[] memory) {
648         PoolInfo memory pool = poolInfo[_pid];
649         UserInfo memory user = userInfo[_pid][_user];
650         uint256 amount = user.amount;
651         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
652         uint256[] memory accRwtPerShare = pool.accRwtPerShare;
653         uint256[] memory PendingRWT = new uint256[](rwt.length);
654         if (amount != 0) {
655             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
656             for (uint i=0; i < rwt.length; i++) {
657                 uint256 rwtReward = multiplier * rwtPerBlock[i] * pool.allocPoint / totalAllocPoint;
658                 accRwtPerShare[i] = accRwtPerShare[i] + rwtReward * 1e30 / lpSupply;
659                 if (i < user.rewardDebt.length){
660                     PendingRWT[i] = (amount * accRwtPerShare[i] / 1e30) - user.rewardDebt[i] + user.claimableRWT[i];
661                 }
662                 else {
663                     PendingRWT[i] = (amount * accRwtPerShare[i] / 1e30);
664                 }
665             }
666         }
667         return(PendingRWT);
668     }
669 
670     function poolAccRew(uint256 _pid) external view returns (uint256[] memory) {
671         uint256[] memory _poolAccRew = poolInfo[_pid].accRwtPerShare;
672         return(_poolAccRew);
673     }
674 
675     function userRewDebt(uint256 _pid, address _user) external view returns (uint256[] memory) {
676         uint256[] memory _userRewDebt = userInfo[_pid][_user].rewardDebt;
677         return(_userRewDebt);
678     }
679 
680     function userClaimable(uint256 _pid, address _user) external view returns (uint256[] memory) {
681         uint256[] memory _userClaimable = userInfo[_pid][_user].claimableRWT;
682         return(_userClaimable);
683     }
684 
685     function userBurntForNum(uint256 burnNum, address user) external view returns (uint256) {
686         return(userBurnt[user][burnNum]);
687     } 
688 
689     function userAmount(uint256 _pid, address user) external view returns (uint256) {
690         return(userInfo[_pid][user].amount);
691     }
692 
693 //--------------------------------------------------------PUBLIC FUNCTIONS --------------------------------------------------------
694     // Update reward variables for all pools. Be careful of gas spending!
695     function massUpdatePools() public {
696         uint256 length = poolInfo.length;
697         for (uint256 pid = 0; pid < length; pid++) {
698             updatePool(pid);
699         }
700     }
701     
702     // Update reward variables of the given pool to be up-to-date.
703     function updatePool(uint256 _pid) public {
704         PoolInfo storage pool = poolInfo[_pid];
705         if (block.number <= pool.lastRewardBlock) {
706             return;
707         }
708         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
709         if (lpSupply == 0 || pool.allocPoint == 0) {
710             pool.lastRewardBlock = uint64(block.number);
711             return;
712         }
713         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
714         if(rwt.length > 0) {
715             uint256[] memory _rwtPerBlock = rwtPerBlock;
716             PoolInfo memory _pool = pool;
717             for (uint i=0; i < rwt.length; i++) {
718                 uint256 rwtReward = multiplier * _rwtPerBlock[i] * _pool.allocPoint / totalAllocPoint;
719                 pool.accRwtPerShare[i] = _pool.accRwtPerShare[i] + rwtReward * 1e30 / lpSupply;
720             }
721         }
722         pool.lastRewardBlock = uint64(block.number);
723     }
724 
725     function burnFromWallet(uint256 burnAmount, uint256 burnNum) public nonReentrant {
726         require(burnAmount > 0);
727         uint256 burnspiralmount = burnAmount * perBurn[burnNum];
728         userBurnt[msg.sender][burnNum] += burnAmount;
729         require(userBurnt[msg.sender][burnNum] <= maxBurn[burnNum]);
730         spiral.safeTransferFrom(msg.sender, address(0xdead), burnspiralmount);
731         emit Burn(msg.sender, burnspiralmount);
732     }
733 
734     function burnFromStake(uint256 burnAmount, uint256 burnNum) public nonReentrant {
735         uint256 burnspiralmount = burnAmount * perBurn[burnNum];
736         uint256 postAmount = userInfo[0][msg.sender].amount - burnspiralmount;
737         require(postAmount >= 0 && burnspiralmount > 0);
738         updatePool(0);
739         _addToClaimable(0, msg.sender);
740         userInfo[0][msg.sender].amount = postAmount;
741         if (rwt.length != 0) {
742             uint256[] memory _poolAccRew = poolInfo[0].accRwtPerShare;
743             for (uint i = 0; i < rwt.length; i++) {
744                 userInfo[0][msg.sender].rewardDebt[i] = postAmount * _poolAccRew[i] / 1e30;
745             }
746         }
747         userBurnt[msg.sender][burnNum] += burnAmount;
748         require(userBurnt[msg.sender][burnNum] <= maxBurn[burnNum]);
749         spiral.safeTransfer(address(0xdead), burnspiralmount);
750         emit Burn(msg.sender, burnspiralmount);
751     }
752 
753     // Deposit tokens for rewards.
754     function deposit(uint256 _pid, uint256 _amount) public nonReentrant {
755         _deposit(msg.sender, _pid, _amount);
756     }
757 
758     function claimRWT(uint256 _pid, uint256 _tokenID) public nonReentrant {
759         require(_tokenID < rwt.length);
760         updatePool(_pid);
761         UserInfo storage user = userInfo[_pid][msg.sender];
762         uint256[] memory _poolAccRew = poolInfo[_pid].accRwtPerShare;
763         uint256 pending;
764         if(user.rewardDebt.length <= _tokenID) {
765             pending = (user.amount * _poolAccRew[_tokenID] / 1e30);
766             uint diff = _tokenID-user.rewardDebt.length;
767             if (diff > 0) {
768                 for (uint i = 0; i<diff; i++){
769                     user.claimableRWT.push();
770                     user.rewardDebt.push();
771                 }
772             }
773             user.claimableRWT.push();
774             user.rewardDebt.push(pending);
775         }
776         else {
777             pending = (user.amount * _poolAccRew[_tokenID] / 1e30) + user.claimableRWT[_tokenID] - user.rewardDebt[_tokenID];
778             user.claimableRWT[_tokenID] = 0;
779             user.rewardDebt[_tokenID] = user.amount * _poolAccRew[_tokenID] / 1e30;
780         }
781         require(pending > 0); 
782         safeRWTTransfer(_tokenID, msg.sender, pending);
783 
784     }
785 
786     function claimAllRWT(uint256 _pid) public nonReentrant {
787         updatePool(_pid);
788         UserInfo storage user = userInfo[_pid][msg.sender];
789         uint256[] memory _poolAccRew = poolInfo[_pid].accRwtPerShare;
790         UserInfo memory _user = user;
791         if(rwt.length != 0) {
792            for (uint i=0; i < _user.rewardDebt.length; i++){
793                 uint256 pending = (_user.amount * _poolAccRew[i] / 1e30) - _user.rewardDebt[i] + _user.claimableRWT[i];
794                 if (pending > 0) {
795                     user.claimableRWT[i] = 0;
796                     user.rewardDebt[i] = _user.amount * _poolAccRew[i] / 1e30;
797                     safeRWTTransfer(i, msg.sender, pending);
798                 }
799             }
800             if (_user.rewardDebt.length != rwt.length) {
801                 for (uint i = _user.rewardDebt.length; i < rwt.length; i++) {
802                     uint256 pending = (_user.amount * _poolAccRew[i] / 1e30);
803                     user.claimableRWT.push();
804                     user.rewardDebt.push(_user.amount * _poolAccRew[i] / 1e30);
805                     if(pending > 0) {
806                         safeRWTTransfer(i, msg.sender, pending);
807                     }
808                 }
809             }
810         }
811     }
812     // Withdraw unlocked tokens.
813     function withdraw(uint256 _pid, uint256 _amount) public nonReentrant {
814         require(block.timestamp > lockUntil);
815         UserInfo storage user = userInfo[_pid][msg.sender];
816         uint256 postAmount = user.amount - _amount;
817         require(postAmount >= 0 && _amount > 0, "withdraw: not good");
818         updatePool(_pid);
819         if (rwt.length > 0) {
820                 _addToClaimable(_pid, msg.sender);
821                 uint256[] memory _poolAccRew = poolInfo[_pid].accRwtPerShare;
822                 for (uint i=0; i < rwt.length; i++){
823                     if (user.claimableRWT[i] > 0) {
824                         safeRWTTransfer(i, msg.sender, user.claimableRWT[i]);
825                         user.claimableRWT[i] = 0;
826                         user.rewardDebt[i] = postAmount * _poolAccRew[i] / 1e30;
827                     }
828                 }
829         }
830         user.amount = postAmount;
831         poolInfo[_pid].lpToken.safeTransfer(address(msg.sender), _amount);
832         
833         emit Withdraw(msg.sender, _pid, _amount);
834     }
835 
836     function reinvestRewards(uint256 _tokenID, uint256 amountOutMin) public nonReentrant {
837             UserInfo storage user = userInfo[0][msg.sender];
838             updatePool(0);
839             require(user.amount > 0, "reinvestRewards: No tokens staked");
840             _addToClaimable(0, msg.sender);
841             uint256 claimableAmount = user.claimableRWT[_tokenID];
842             user.claimableRWT[_tokenID] = 0;
843             address[] memory path = new address[](2);
844             path[0] = address(rwt[_tokenID]);
845             path[1] = address(spiral);
846             if (claimableAmount > 0) { 
847                 rwt[_tokenID].approve(router, claimableAmount);
848                 uint256 balanceBefore = spiral.balanceOf(address(this));
849                 IUniswapV2Router02(router).swapExactTokensForTokensSupportingFeeOnTransferTokens(
850                 claimableAmount,    
851                 amountOutMin,
852                 path,
853                 address(this),
854                 block.timestamp
855                 );
856                 uint256 amountSwapped = spiral.balanceOf(address(this)) - balanceBefore;
857                 user.amount += amountSwapped;
858                 uint256 postAmount = user.amount;
859                 uint256[] memory _poolAccRew = poolInfo[0].accRwtPerShare;
860                 for (uint i = 0; i < rwt.length; i++) {
861                     userInfo[0][msg.sender].rewardDebt[i] = postAmount * _poolAccRew[i] / 1e30;
862                 }
863 				emit Deposit(msg.sender, 0, amountSwapped);
864             }
865     }
866 
867     // Withdraw unlocked tokens without caring about rewards. EMERGENCY ONLY.
868     function emergencyWithdraw(uint256 _pid) public nonReentrant onlyEmergency {
869         PoolInfo storage pool = poolInfo[_pid];
870         UserInfo storage user = userInfo[_pid][msg.sender];
871         uint256 amount = user.amount;
872         uint256[] memory zeroArray = new uint256[](rwt.length);
873         user.amount = 0;
874         user.rewardDebt = zeroArray;
875         user.claimableRWT = zeroArray;
876         pool.lpToken.safeTransfer(address(msg.sender), amount);
877         emit EmergencyWithdraw(msg.sender, _pid, amount);
878     }
879 	
880 	
881     
882 //--------------------------------------------------------RESTRICTED FUNCTIONS --------------------------------------------------------	
883 
884     function depositFor(address sender, uint256 _pid, uint256 amount) public onlyAuthorized {
885         _deposit(sender, _pid, amount);
886     }
887     // Create a new pool. Can only be called by the owner.
888     function add(uint64 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner nonDuplicated(_lpToken) {
889         if (_withUpdate) {
890             massUpdatePools();
891         }
892         uint64 lastRewardBlock = uint64(block.number > startBlock ? block.number : startBlock);
893         totalAllocPoint = totalAllocPoint + _allocPoint;
894         poolExistence[_lpToken] = true;
895         uint256[] memory accRWT = new uint256[](rwt.length);
896         poolInfo.push(PoolInfo({
897         lpToken : _lpToken,
898         allocPoint : _allocPoint,
899         lastRewardBlock : lastRewardBlock,
900         accRwtPerShare : accRWT
901         }));
902     }
903 
904 	// Pull out tokens accidentally sent to the contract. Doesnt work with the reward token or any staked token. Can only be called by the owner.
905     function rescueToken(address tokenaddress) public onlyOwner {
906         require(!rwtExistence[IERC20(tokenaddress)] && !poolExistence[IERC20(tokenaddress)], "rescueToken : wrong token address");
907         uint256 bal = IERC20(tokenaddress).balanceOf(address(this));
908         IERC20(tokenaddress).transfer(msg.sender, bal);
909     }
910 
911     // Update the given pool's rewards allocation point and deposit fee. Can only be called by the owner.
912     function set(uint256 _pid, uint64 _allocPoint, bool _withUpdate) public onlyOwner {
913         if (_withUpdate) {
914             massUpdatePools();
915         }
916         totalAllocPoint = totalAllocPoint - poolInfo[_pid].allocPoint + _allocPoint ;
917         poolInfo[_pid].allocPoint = _allocPoint;
918     }
919 	// Initialize the rewards. Can only be called by the owner. 
920     function startRewards() public onlyOwner {
921         require(startBlock > block.number, "startRewards: rewards already started");
922         startBlock = block.number;
923         for (uint i; i < poolInfo.length; i++) {
924             poolInfo[i].lastRewardBlock = uint64(block.number);            
925         }
926     }
927     // Updates RWT emision rate. Can only be called by the owner
928     function updateEmissionRate(uint256 _tokenID, uint256 _rwtPerBlock) public onlyOwner {
929         require(_tokenID < rwt.length);
930 		massUpdatePools();
931         rwtPerBlock[_tokenID] = _rwtPerBlock;
932         emit UpdateEmissionRate(msg.sender, _rwtPerBlock);
933     }
934     // Sets the reward token address and the initial emission rate. Can only be called by the owner. 
935     function addRewardToken(IERC20 _RWT, uint _rwtPerBlock) public onlyOwner nonDuplicatedRWT(_RWT) {
936         rwt.push(_RWT);
937         rwtPerBlock.push(_rwtPerBlock);
938         rwtExistence[_RWT] = true;
939         uint256 length = poolInfo.length;
940         for (uint256 pid = 0; pid < length; pid++) {
941             poolInfo[pid].accRwtPerShare.push();
942         }
943         emit RewardTokenSet(_RWT, _rwtPerBlock, block.timestamp);
944     }
945 
946     function setPerBurn(uint256 _perBurn, uint256 _maxBurn) external onlyOwner {
947         perBurn.push(_perBurn);
948         maxBurn.push(_maxBurn);
949     }
950     
951     // Emergency only 
952     function emergency(bool _isEmergency) external onlyOwner {
953         isEmergency = _isEmergency;
954         emit Emergency(block.timestamp, _isEmergency);
955     }
956     function authorize(address _address) external onlyOwner {
957         authorized[_address] = true;
958     }
959     function unauthorize(address _address) external onlyOwner {
960         authorized[_address] = false;
961     }
962 
963     function setLock(uint256 _lockUntil) external onlyOwner {
964         require(_lockUntil <= block.timestamp + 2 weeks && lockUntil + 1 days <= block.timestamp);
965         lockUntil = _lockUntil;
966     }
967 
968 
969 //--------------------------------------------------------INTERNAL FUNCTIONS --------------------------------------------------------
970     function _deposit(address sender, uint256 _pid, uint256 _amount) internal {
971         require(_amount > 0);
972         UserInfo storage user = userInfo[_pid][sender];
973         uint256 amount = user.amount;
974         updatePool(_pid);
975         if(amount > 0) {
976             _addToClaimable(_pid, sender);
977         }
978 
979         poolInfo[_pid].lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
980         user.amount = amount + _amount;
981         if(rwt.length != 0) {
982             amount = user.amount;
983             uint256[] memory accRwtPerShare = poolInfo[_pid].accRwtPerShare;
984             for (uint i=0; i < user.rewardDebt.length; i++){
985                 user.rewardDebt[i] = amount * accRwtPerShare[i] / 1e30;
986             }
987             if (user.rewardDebt.length != rwt.length) {
988                 for (uint i = user.rewardDebt.length; i < rwt.length; i++) {
989                     user.claimableRWT.push(0);
990                     user.rewardDebt.push(amount * accRwtPerShare[i] / 1e30);
991                 }
992             }    
993         }
994         emit Deposit(sender, _pid, _amount);
995     }
996     
997     function _addToClaimable(uint256 _pid, address sender) internal {
998         if(rwt.length != 0) {
999             UserInfo storage user = userInfo[_pid][sender];
1000             PoolInfo memory pool = poolInfo[_pid];
1001             UserInfo memory _user = user;
1002             for (uint i=0; i < _user.rewardDebt.length; i++){
1003                 uint256 pending = (_user.amount * pool.accRwtPerShare[i] / 1e30) - _user.rewardDebt[i] + _user.claimableRWT[i];
1004                 if (pending > 0) {
1005                     user.claimableRWT[i] = pending;
1006                 }
1007             }
1008             if (_user.rewardDebt.length != rwt.length) {
1009                 for (uint i = _user.rewardDebt.length; i < rwt.length; i++) {
1010                     uint256 pending = (_user.amount * pool.accRwtPerShare[i] / 1e30);
1011                     user.claimableRWT.push(pending);
1012                     user.rewardDebt.push();
1013                 }
1014             }
1015         }
1016     }
1017 
1018     // Safe transfer function, just in case if rounding error causes pool to not have enough RWTs.
1019     function safeRWTTransfer(uint tokenID, address _to, uint256 _amount) internal {
1020         IERC20 _rwt = rwt[tokenID];
1021         uint256 rwtBal = _rwt.balanceOf(address(this));
1022         bool transferSuccess = false;
1023         if (_amount > rwtBal) {
1024             transferSuccess = _rwt.transfer(_to, rwtBal);
1025         } else {
1026             transferSuccess = _rwt.transfer(_to, _amount);
1027         }
1028         require(transferSuccess, "safeRWTTransfer: transfer failed");
1029     }
1030 }