1 pragma solidity ^0.5.12;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /**
161  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
162  * the optional functions; to access them see {ERC20Detailed}.
163  */
164 interface IERC20 {
165     /**
166      * @dev Returns the amount of tokens in existence.
167      */
168     function totalSupply() external view returns (uint256);
169 
170     /**
171      * @dev Returns the amount of tokens owned by `account`.
172      */
173     function balanceOf(address account) external view returns (uint256);
174 
175     /**
176      * @dev Moves `amount` tokens from the caller's account to `recipient`.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transfer(address recipient, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Returns the remaining number of tokens that `spender` will be
186      * allowed to spend on behalf of `owner` through {transferFrom}. This is
187      * zero by default.
188      *
189      * This value changes when {approve} or {transferFrom} are called.
190      */
191     function allowance(address owner, address spender) external view returns (uint256);
192 
193     /**
194      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * IMPORTANT: Beware that changing an allowance with this method brings the risk
199      * that someone may use both the old and the new allowance by unfortunate
200      * transaction ordering. One possible solution to mitigate this race
201      * condition is to first reduce the spender's allowance to 0 and set the
202      * desired value afterwards:
203      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204      *
205      * Emits an {Approval} event.
206      */
207     function approve(address spender, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Moves `amount` tokens from `sender` to `recipient` using the
211      * allowance mechanism. `amount` is then deducted from the caller's
212      * allowance.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Emitted when `value` tokens are moved from one account (`from`) to
222      * another (`to`).
223      *
224      * Note that `value` may be zero.
225      */
226     event Transfer(address indexed from, address indexed to, uint256 value);
227 
228     /**
229      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
230      * a call to {approve}. `value` is the new allowance.
231      */
232     event Approval(address indexed owner, address indexed spender, uint256 value);
233 }
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following 
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267     /**
268      * @dev Converts an `address` into `address payable`. Note that this is
269      * simply a type cast: the actual underlying value is not changed.
270      *
271      * _Available since v2.4.0._
272      */
273     function toPayable(address account) internal pure returns (address payable) {
274         return address(uint160(account));
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      *
293      * _Available since v2.4.0._
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-call-value
299         (bool success, ) = recipient.call.value(amount)("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 }
303 
304 /**
305  * @title SafeERC20
306  * @dev Wrappers around ERC20 operations that throw on failure (when the token
307  * contract returns false). Tokens that return no value (and instead revert or
308  * throw on failure) are also supported, non-reverting calls are assumed to be
309  * successful.
310  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
311  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
312  */
313 library SafeERC20 {
314     using SafeMath for uint256;
315     using Address for address;
316 
317     function safeTransfer(IERC20 token, address to, uint256 value) internal {
318         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
319     }
320 
321     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
322         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
323     }
324 
325     function safeApprove(IERC20 token, address spender, uint256 value) internal {
326         // safeApprove should only be called when setting an initial allowance,
327         // or when resetting it to zero. To increase and decrease it, use
328         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
329         // solhint-disable-next-line max-line-length
330         require((value == 0) || (token.allowance(address(this), spender) == 0),
331             "SafeERC20: approve from non-zero to non-zero allowance"
332         );
333         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
334     }
335 
336     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
337         uint256 newAllowance = token.allowance(address(this), spender).add(value);
338         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
339     }
340 
341     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
342         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
343         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
344     }
345 
346     /**
347      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
348      * on the return value: the return value is optional (but if data is returned, it must not be false).
349      * @param token The token targeted by the call.
350      * @param data The call data (encoded using abi.encode or one of its variants).
351      */
352     function callOptionalReturn(IERC20 token, bytes memory data) private {
353         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
354         // we're implementing it ourselves.
355 
356         // A Solidity high level call has three parts:
357         //  1. The target address is checked to verify it contains contract code
358         //  2. The call itself is made, and success asserted
359         //  3. The return value is decoded, which in turn checks the size of the returned data.
360         // solhint-disable-next-line max-line-length
361         require(address(token).isContract(), "SafeERC20: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = address(token).call(data);
365         require(success, "SafeERC20: low-level call failed");
366 
367         if (returndata.length > 0) { // Return data is optional
368             // solhint-disable-next-line max-line-length
369             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
370         }
371     }
372 }
373 
374 /**
375  * @dev These functions deal with verification of Merkle trees (hash trees),
376  */
377 library MerkleProof {
378     /**
379      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
380      * defined by `root`. For this, a `proof` must be provided, containing
381      * sibling hashes on the branch from the leaf to the root of the tree. Each
382      * pair of leaves and each pair of pre-images are assumed to be sorted.
383      */
384     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
385         bytes32 computedHash = leaf;
386 
387         for (uint256 i = 0; i < proof.length; i++) {
388             bytes32 proofElement = proof[i];
389 
390             if (computedHash <= proofElement) {
391                 // Hash(current computed hash + current element of the proof)
392                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
393             } else {
394                 // Hash(current element of the proof + current computed hash)
395                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
396             }
397         }
398 
399         // Check if the computed hash (root) is equal to the provided root
400         return computedHash == root;
401     }
402 }
403 
404 contract DPRStaking {
405     using SafeMath for uint256;
406     using SafeERC20 for IERC20;
407     uint256 DPR_UNIT = 10 ** 18;
408     struct Period{
409 		bytes32  withdraw_root;
410         uint256 start_time;
411         uint256 end_time;
412     }
413     Period[] private periods;
414     IERC20 public dpr;
415     uint256 public staking_time = 270 days; // lock for 9 months
416     uint256 private total_release_time; // linear release in 3 months
417     uint256 private reward_time = 0;
418     address public owner; 
419     address public migrate_address;
420     bool public pause;
421 
422 	mapping (address => uint256) private user_staking_period_index;
423     mapping (address => uint256) private user_staking_amount;
424     mapping (address => uint256) private user_release_time;
425     mapping (address => uint256) private user_claimed_map;
426     mapping (address => string) private dpr_address_mapping;
427     mapping (string => address) private address_dpr_mapping;
428     mapping (address => Period) private user_staking_periods;
429     mapping (address => uint256) private user_staking_time;
430     uint256[8] private staking_level = [
431         20000 * DPR_UNIT, // 100 credit
432         46800 * DPR_UNIT, // 200 credit
433         76800 * DPR_UNIT, // 300 credit
434         138000 * DPR_UNIT, // 400 credit
435         218000 * DPR_UNIT, // 500 credit
436         288000 * DPR_UNIT, // 600 credit
437         368000 * DPR_UNIT, // 700 credit
438         468000 * DPR_UNIT // 800 credit
439     ];
440 
441 
442     
443     //modifiers
444     modifier onlyOwner() {
445         require(msg.sender==owner, "DPRStaking: Only owner can operate this function");
446         _;
447     }
448 
449     modifier whenNotPaused(){
450         require(pause == false, "DPRStaking: Pause!");
451         _;
452     }
453     
454     //events
455     event Stake(address indexed user, string DPRAddress, uint256 indexed amount);
456     event StakeChange(address indexed user, uint256 indexed oldAmount, uint256 indexed newAmount);
457     event OwnerShipTransfer(address indexed oldOwner, address indexed newOwner);
458     event DPRAddressChange(bytes32 oldAddress, bytes32 newAddress);
459     event UserInfoChange(address indexed oldUser, address indexed newUser);
460     event WithdrawAllFunds(address indexed to);
461     event LinearTimeChange(uint256 day);
462     event WithdrawStaking(address indexed _address, uint256 indexed _amount);
463     event UpdateRewardTime(uint256 indexed _new_reward_time);
464     event EndTimeChanged(uint256 indexed _new_end_time);
465     event NewPeriod(uint256 indexed _start_time, uint256 indexed _end_time);
466     event Migrate(address indexed migrate_address, uint256 indexed migrate_amount);
467     event MigrateAddressSet(address indexed migrate_address);
468 	event RootSet(bytes32 indexed root, uint256 indexed _index);
469     event ModifyPeriodTime(uint256 indexed _index, uint256 _start_time, uint256 _end_time);
470 
471     constructor(IERC20 _dpr) public {
472         dpr = _dpr;
473         total_release_time = 90 days; // for initialize
474         owner = msg.sender;
475     }
476 
477     function stake(string calldata DPRAddress, uint256 level) external whenNotPaused returns(bool){
478        //Check current lastest staking period
479        require(periods.length > 0, "DPRStaking: No active staking period");
480        Period memory lastest_period = periods[periods.length.sub(1)];
481        require(isInCurrentPeriod(),"DPRStaking: Staking not start or already end");
482        require(level <= staking_level.length.sub(1), "DPRStaking: Level does not exist");
483        require(user_staking_amount[msg.sender] == 0, "DPRStaking: Already stake, use addStaking instead");
484        //check if address already set DPRAddress and DPRAddress is not in use
485        checkDPRAddress(msg.sender, DPRAddress);
486        uint256 staking_amount = staking_level[level];
487        dpr.safeTransferFrom(msg.sender, address(this), staking_amount);
488        user_staking_amount[msg.sender] = staking_amount;
489        user_staking_time[msg.sender] = block.timestamp;
490        dpr_address_mapping[msg.sender] = DPRAddress;
491        address_dpr_mapping[DPRAddress] = msg.sender;
492        //update user staking period
493        user_staking_periods[msg.sender] = lastest_period;
494 	   user_staking_period_index[msg.sender] = periods.length.sub(1);
495        emit Stake(msg.sender, DPRAddress, staking_amount);
496        return true;
497     }
498 
499     function addStaking(uint256 level) external  whenNotPaused returns(bool) {
500         // staking period checking
501         require(periods.length >0, "DPRStaking: No active staking period");
502         require(checkPeriod(msg.sender), "DRPStaking: Not current period, try to move to lastest period");
503         require(isInCurrentPeriod(), "DPRStaking: Staking not start or already end");
504         require(level <= staking_level.length.sub(1), "DPRStaking: Level does not exist");
505         uint256 newStakingAmount = staking_level[level];
506         uint256 oldStakingAmount = user_staking_amount[msg.sender];
507         require(oldStakingAmount > 0, "DPRStaking: Please Stake first");
508         require(oldStakingAmount < newStakingAmount, "DPRStaking: Can only upgrade your level");
509         uint256 difference = newStakingAmount.sub(oldStakingAmount);
510         dpr.safeTransferFrom(msg.sender, address(this), difference);
511         //update user staking amount
512         user_staking_amount[msg.sender] = staking_level[level];
513         user_staking_time[msg.sender] = block.timestamp;
514         emit StakeChange(msg.sender, oldStakingAmount, newStakingAmount);
515         return true;
516     }
517 
518     function claim() external whenNotPaused returns(bool){
519         require(reward_time > 0, "DPRStaking: Reward time not set");
520         require(block.timestamp >= reward_time.add(staking_time), "DPRStaking: Not reach the release time");
521         if(user_release_time[msg.sender] == 0){
522             user_release_time[msg.sender] = reward_time.add(staking_time);
523         }
524         // user staking end time checking
525         require(block.timestamp >= user_release_time[msg.sender], "DPRStaking: Not release period");
526         uint256 staking_amount = user_staking_amount[msg.sender];
527         require(staking_amount > 0, "DPRStaking: Must stake first");
528         uint256 user_claimed = user_claimed_map[msg.sender];
529         uint256 claim_per_period = staking_amount.mul(1 days).div(total_release_time);
530         uint256 time_pass = block.timestamp.sub(user_release_time[msg.sender]).div(1 days);
531         uint256 total_claim_amount = claim_per_period * time_pass;
532         if(total_claim_amount >= user_staking_amount[msg.sender]){
533             total_claim_amount = user_staking_amount[msg.sender];
534             user_staking_amount[msg.sender] = 0;
535         }
536         user_claimed_map[msg.sender] = total_claim_amount;
537         uint256 claim_this_time = total_claim_amount.sub(user_claimed);
538         dpr.safeTransfer(msg.sender, claim_this_time);
539         return true;
540     }
541 
542     function transferOwnership(address newOwner) onlyOwner external returns(bool){
543         require(newOwner != address(0), "DPRStaking: Transfer Ownership to zero address");
544         owner = newOwner;
545         emit OwnerShipTransfer(msg.sender, newOwner);
546     } 
547     
548     //for emergency case, Deeper Offical can help users to modify their staking info
549     function modifyUserAddress(address user, string calldata DPRAddress) external onlyOwner returns(bool){
550         require(user_staking_amount[user] > 0, "DPRStaking: User does not have any record");
551         require(address_dpr_mapping[DPRAddress] == address(0), "DPRStaking: DPRAddress already in use");
552         bytes32 oldDPRAddressHash = keccak256(abi.encodePacked(dpr_address_mapping[user]));
553         bytes32 newDPRAddressHash = keccak256(abi.encodePacked(DPRAddress));
554         require(oldDPRAddressHash != newDPRAddressHash, "DPRStaking: DPRAddress is same"); 
555         dpr_address_mapping[user] = DPRAddress;
556         delete address_dpr_mapping[dpr_address_mapping[user]];
557         address_dpr_mapping[DPRAddress] = user;
558         emit DPRAddressChange(oldDPRAddressHash, newDPRAddressHash);
559         return true;
560 
561     }
562     //for emergency case(User lost their control of their accounts), Deeper Offical can help users to transfer their staking info to a new address 
563     function transferUserInfo(address oldUser, address newUser) external onlyOwner returns(bool){
564         require(oldUser != newUser, "DPRStaking: Address are same");
565         require(user_staking_amount[oldUser] > 0, "DPRStaking: Old user does not have any record");
566         require(user_staking_amount[newUser] == 0, "DPRStaking: New user must a clean address");
567         //Transfer Staking Info
568         user_staking_amount[newUser] = user_staking_amount[oldUser];
569 		user_staking_period_index[newUser] = user_staking_period_index[oldUser];
570 		user_staking_periods[newUser] = user_staking_periods[oldUser];
571         //Transfer release Info
572         user_release_time[newUser] = user_release_time[oldUser];
573         //Transfer claim Info
574         user_claimed_map[newUser] = user_claimed_map[oldUser];
575         //Transfer address mapping info
576 		address_dpr_mapping[dpr_address_mapping[oldUser]] = newUser;
577         dpr_address_mapping[newUser] = dpr_address_mapping[oldUser];
578         user_staking_time[msg.sender] = block.timestamp;
579         //clear account
580         clearAccount(oldUser,false);
581         emit UserInfoChange(oldUser, newUser);
582         return true;
583 
584     }
585     //for emergency case, Deeper Offical have permission to withdraw all fund in the contract
586     function withdrawAllFund(uint256 amount) external onlyOwner returns(bool){
587         dpr.safeTransfer(owner,amount);
588         emit WithdrawAllFunds(owner);
589         return true;
590     }
591 	
592 	function setRootForPeriod(bytes32 root, uint256 index) external onlyOwner returns(bool){
593 		require(index <= periods.length.sub(1), "DPRStaking: Not that period");
594 		Period storage period_to_modify = periods[index];
595 		period_to_modify.withdraw_root = root;
596 		emit RootSet(root, index);
597 		return true;
598 	}
599 
600     function modifyPeriodTime(uint256 index, uint256 start_time, uint256 end_time) external onlyOwner returns(bool){
601         require(periods.length > 0, "DPRStaking: No period");
602         require(index <= periods.length.sub(1), "DPRStaking: Wrong Period");
603         Period storage period = periods[index];
604         period.start_time = start_time;
605         period.end_time = end_time;
606         emit ModifyPeriodTime(index, start_time, end_time);
607     }
608 
609     //Change the linear time before claim start
610     //if reward_time is 0, means mainnet not lanuch, so there is no need to check the reward time
611     function modifyLinearTime(uint256 newdays) onlyOwner external returns(bool){
612         require(block.timestamp <= reward_time.add(staking_time), "DPRStaking: Claim period has started");
613         total_release_time = newdays * 86400;
614         emit LinearTimeChange(newdays);
615         return true;
616     }
617 
618     function setPause(bool is_pause) external onlyOwner returns(bool){
619         pause = is_pause;
620         return true;
621     }
622 	
623     function clearAccount(address user, bool is_clear_address) private{
624         delete user_staking_amount[user];
625         delete user_release_time[user];
626         delete user_claimed_map[user];
627 		delete user_staking_period_index[user];
628 		delete user_staking_periods[user];
629         delete user_staking_time[user];
630         if(is_clear_address){
631 			delete address_dpr_mapping[dpr_address_mapping[user]];
632 		}
633 		delete dpr_address_mapping[user];
634     }
635 	
636 	function generateUserHash(address user) private returns(bytes32){
637 		uint256 staking_amount = user_staking_amount[user];
638 		return keccak256(abi.encodePacked(user, staking_amount));
639 	}
640 	
641 	function moveToLastestPeriod() external returns(bool){
642 		uint256 staking_amount = user_staking_amount[msg.sender];
643 		require(staking_amount > 0, "DPRStaking: User does not stake");
644 		Period memory lastest_period = periods[periods.length.sub(1)];
645 		require(isInCurrentPeriod(), "DPRStaking: Not in current period");
646 		//if user's period is same as the current period, means there is no new period
647 		require(!checkPeriod(msg.sender), "DPRStaking: No new staking period");
648 		user_staking_periods[msg.sender] = lastest_period;
649 		user_staking_period_index[msg.sender] = periods.length.sub(1);
650 	}
651 
652 
653     //only allow user withdraw his fund in one period
654     //for user withdraw their fund before staking end
655     function withdrawStaking(bytes32[] calldata path, address user) external returns(bool){
656         require(periods.length >=0, "DPRStaking: No active staking period");
657 		uint256 index = user_staking_period_index[user];
658 		bytes32 root = periods[index].withdraw_root;
659 		bytes32 user_node = generateUserHash(user);
660 		require(MerkleProof.verify(path, root, user_node), "DPRStaking: User not allow to withdraw");
661 		uint256 withdraw_amount = user_staking_amount[user];
662         require(withdraw_amount >0, "DPRStaking: User does not stake");
663         require(withdraw_amount <= dpr.balanceOf(address(this)), "DPRStaking: Not enough balanbce");
664 		clearAccount(user, true);
665         dpr.safeTransfer(user, withdraw_amount);
666         emit WithdrawStaking(user, withdraw_amount);
667         return true;
668     }
669 
670     function addStakingPeriod(uint256 _start_time, uint256 _end_time) external onlyOwner returns(bool){
671         require(_end_time >= _start_time, "DPRStaking: Time error");
672         if(periods.length != 0){
673             Period memory lastest_period = periods[periods.length.sub(1)];
674             uint256 end_time = lastest_period.end_time;
675             require(block.timestamp > end_time, "DPRStaking: last period was not end");
676         }
677         Period memory p;
678         p.start_time = _start_time;
679         p.end_time = _end_time;
680         periods.push(p);
681         emit NewPeriod(_start_time, _end_time);
682         return true;
683     }
684 
685     //modify reward time
686     function setRewardTime(uint256 _new_reward_time) external onlyOwner returns(bool){
687         require(reward_time == 0,  "DPRStaking: Reward time is already set");
688         reward_time = _new_reward_time;
689         emit UpdateRewardTime(_new_reward_time);
690         return true;
691     }
692     //when staking end, user can choose to migrate their fund to new contract
693     function migrate() external returns(bool){
694         uint256 staking_amount = user_staking_amount[msg.sender];
695         require(staking_amount >0, "DPRStaking: User does not stake");
696         require(migrate_address != address(0), "DPRStaking: Staking not start");
697         clearAccount(msg.sender, true);
698         dpr.safeTransfer(migrate_address, staking_amount);
699         emit Migrate(migrate_address, staking_amount);
700         return true;
701     }
702 
703 
704 
705     function setMigrateAddress(address _migrate_address) external onlyOwner returns(bool){
706         migrate_address = _migrate_address;
707         emit MigrateAddressSet(_migrate_address);
708         return true;
709     }
710 
711     function checkPeriod(address user) private returns(bool){
712 		Period memory lastest_period = periods[periods.length.sub(1)];
713 		Period memory user_period = user_staking_periods[user];
714         return(lastest_period.start_time == user_period.start_time && lastest_period.end_time == user_period.end_time);
715     }
716 
717     function checkDPRAddress(address _address, string memory _dprAddress) private{
718         require(keccak256(abi.encodePacked(dpr_address_mapping[_address])) == bytes32(hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"), "DPRStaking: DPRAddress already set");
719         require(address_dpr_mapping[_dprAddress] == address(0), "DPRStaking: ETH address already bind an DPRAddress");
720     }
721 	
722 	function isInCurrentPeriod() private returns(bool){
723 		Period memory lastest_period = periods[periods.length.sub(1)];
724 		uint256 start_time = lastest_period.start_time;
725 		uint256 end_time = lastest_period.end_time;
726 		return (block.timestamp >= start_time && end_time >= block.timestamp);
727 	}
728 
729     function getUserDPRAddress(address user) external view returns(string memory){
730         return dpr_address_mapping[user];
731     }
732 	
733 	function getUserAddressByDPRAddress(string calldata dpr_address) external view returns(address){
734 		return address_dpr_mapping[dpr_address];
735 	}
736 
737     function getReleaseTime(address user) external view returns(uint256){
738         return user_release_time[user];
739     }
740 
741     function getStaking(address user) external view returns(uint256){
742         return user_staking_amount[user];
743     }
744 
745     function getUserReleasePerDay(address user) external view returns(uint256){
746         uint256 staking_amount = user_staking_amount[user];
747         uint256 release_per_day = staking_amount.mul(1 days).div(total_release_time);
748         return release_per_day;
749     }
750 
751     function getUserClaimInfo(address user) external view returns(uint256){
752         return user_claimed_map[user];
753     }
754 
755     function getReleaseTimeInDays() external view returns(uint256){
756         return total_release_time.div(1 days);
757     }
758 
759     function getPeriodInfo(uint256 index) external view returns (Period memory){
760 		return periods[index];
761     }
762 
763     function getRewardTime() external view returns(uint256){
764         return reward_time;  
765     }
766 
767     function getUserStakingPeriod(address user) external view returns(Period memory){
768         return user_staking_periods[user];
769     }
770 	
771 	function getUserStakingIndex(address user) external view returns(uint256){
772 		return user_staking_period_index[user];
773 	}
774 
775     function getUserStakingTime(address user) external view returns(uint256){
776         return user_staking_time[user];
777     }
778 
779 }