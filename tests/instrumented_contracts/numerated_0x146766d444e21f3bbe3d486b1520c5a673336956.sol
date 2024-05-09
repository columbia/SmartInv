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
404 interface IMigrate {
405     function migrate(address addr, uint256 amount) external returns(bool);
406 }
407 
408 contract DPRStaking {
409     using SafeMath for uint256;
410     using SafeERC20 for IERC20;
411     uint256 DPR_UNIT = 10 ** 18;
412     IERC20 public dpr;
413     uint256 public staking_time = 270 days; // lock for 9 months
414     uint256 private total_release_time; // linear release in 3 months
415     // uint256 private reward_time = 0;
416     uint256 private total_level;
417     address public owner; 
418     IMigrate public migrate_address;
419     bool public pause;
420 
421     mapping (address => uint256) private user_staking_amount;
422     mapping (address => uint256) private user_release_time;
423     mapping (address => uint256) private user_claimed_map;
424     mapping (address => string) private dpr_address_mapping;
425     mapping (string => address) private address_dpr_mapping;
426     mapping (address => bool) private user_start_claim;
427     mapping (address => uint256) private user_staking_time;
428 
429     //modifiers
430     modifier onlyOwner() {
431         require(msg.sender==owner, "DPRStaking: Only owner can operate this function");
432         _;
433     }
434 
435     modifier whenNotPaused(){
436         require(pause == false, "DPRStaking: Pause!");
437         _;
438     }
439     
440     //events
441     event Stake(address indexed user, string DPRAddress, uint256 indexed amount);
442     event StakeChange(address indexed user, uint256 indexed oldAmount, uint256 indexed newAmount);
443     event OwnerShipTransfer(address indexed oldOwner, address indexed newOwner);
444     event DPRAddressChange(bytes32 oldAddress, bytes32 newAddress);
445     event UserInfoChange(address indexed oldUser, address indexed newUser);
446     event WithdrawAllFunds(address indexed to);
447     event Migrate(address indexed migrate_address, uint256 indexed migrate_amount);
448     event MigrateAddressSet(address indexed migrate_address);
449     event ExtendStakingTime(address indexed addr);
450     event AdminWithdrawUserFund(address indexed addr);
451 
452 
453     constructor(IERC20 _dpr) public {
454         dpr = _dpr;
455         total_release_time = 90 days; // for initialize
456         owner = msg.sender;
457     }
458 
459     function stake(string calldata DPRAddress, uint256 amount) external whenNotPaused returns(bool){
460        require(user_staking_amount[msg.sender] == 0, "DPRStaking: Already stake, use addStaking instead");
461        checkDPRAddress(msg.sender, DPRAddress);
462        uint256 staking_amount = amount;
463        dpr.safeTransferFrom(msg.sender, address(this), staking_amount);
464        user_staking_amount[msg.sender] = staking_amount;
465        user_staking_time[msg.sender] = block.timestamp;
466        user_release_time[msg.sender] = block.timestamp + staking_time; 
467        //user_staking_level[msg.sender] = level;
468        dpr_address_mapping[msg.sender] = DPRAddress;
469        address_dpr_mapping[DPRAddress] = msg.sender;
470        emit Stake(msg.sender, DPRAddress, staking_amount);
471        return true;
472     }
473 
474     function addAndExtendStaking(uint256 amount) external  whenNotPaused returns(bool) {
475         require(!canUserClaim(msg.sender), "DPRStaking: Can only claim");
476         uint256 oldStakingAmount = user_staking_amount[msg.sender];
477         require(oldStakingAmount > 0, "DPRStaking: Please Stake first");
478         dpr.safeTransferFrom(msg.sender, address(this), amount);
479         //update user staking amount
480         user_staking_amount[msg.sender] = user_staking_amount[msg.sender].add(amount);
481         user_staking_time[msg.sender] = block.timestamp;
482         user_release_time[msg.sender] = block.timestamp + staking_time;
483         emit StakeChange(msg.sender, oldStakingAmount, user_staking_amount[msg.sender]);
484         return true;
485     }
486 
487     function claim() external whenNotPaused returns(bool){
488         require(canUserClaim(msg.sender), "DPRStaking: Not reach the release time");
489         require(block.timestamp >= user_release_time[msg.sender], "DPRStaking: Not release period");
490         if(!user_start_claim[msg.sender]){
491             user_start_claim[msg.sender] == true;
492         }
493         uint256 staking_amount = user_staking_amount[msg.sender];
494         require(staking_amount > 0, "DPRStaking: Must stake first");
495         uint256 user_claimed = user_claimed_map[msg.sender];
496         uint256 claim_per_period = staking_amount.mul(1 days).div(total_release_time);
497         uint256 time_pass = block.timestamp.sub(user_release_time[msg.sender]).div(1 days);
498         uint256 total_claim_amount = claim_per_period * time_pass;
499         if(total_claim_amount >= user_staking_amount[msg.sender]){
500             total_claim_amount = user_staking_amount[msg.sender];
501             user_staking_amount[msg.sender] = 0;
502         }
503         user_claimed_map[msg.sender] = total_claim_amount;
504         uint256 claim_this_time = total_claim_amount.sub(user_claimed);
505         dpr.safeTransfer(msg.sender, claim_this_time);
506         return true;
507     }
508 
509     function transferOwnership(address newOwner) onlyOwner external returns(bool){
510         require(newOwner != address(0), "DPRStaking: Transfer Ownership to zero address");
511         owner = newOwner;
512         emit OwnerShipTransfer(msg.sender, newOwner);
513     } 
514     
515     //for emergency case, Deeper Offical can help users to modify their staking info
516     function modifyUserAddress(address user, string calldata DPRAddress) external onlyOwner returns(bool){
517         require(user_staking_amount[user] > 0, "DPRStaking: User does not have any record");
518         require(address_dpr_mapping[DPRAddress] == address(0), "DPRStaking: DPRAddress already in use");
519         bytes32 oldDPRAddressHash = keccak256(abi.encodePacked(dpr_address_mapping[user]));
520         bytes32 newDPRAddressHash = keccak256(abi.encodePacked(DPRAddress));
521         require(oldDPRAddressHash != newDPRAddressHash, "DPRStaking: DPRAddress is same"); 
522         dpr_address_mapping[user] = DPRAddress;
523         delete address_dpr_mapping[dpr_address_mapping[user]];
524         address_dpr_mapping[DPRAddress] = user;
525         emit DPRAddressChange(oldDPRAddressHash, newDPRAddressHash);
526         return true;
527 
528     }
529     //for emergency case(User lost their control of their accounts), Deeper Offical can help users to transfer their staking info to a new address 
530     function transferUserInfo(address oldUser, address newUser) external onlyOwner returns(bool){
531         require(oldUser != newUser, "DPRStaking: Address are same");
532         require(user_staking_amount[oldUser] > 0, "DPRStaking: Old user does not have any record");
533         require(user_staking_amount[newUser] == 0, "DPRStaking: New user must a clean address");
534         //Transfer Staking Info
535         user_staking_amount[newUser] = user_staking_amount[oldUser];
536         user_release_time[newUser] = user_release_time[oldUser];
537         //Transfer claim Info
538         user_claimed_map[newUser] = user_claimed_map[oldUser];
539         //Transfer address mapping info
540 		address_dpr_mapping[dpr_address_mapping[oldUser]] = newUser;
541         dpr_address_mapping[newUser] = dpr_address_mapping[oldUser];
542         user_staking_time[msg.sender] = block.timestamp;
543         //clear account
544         clearAccount(oldUser,false);
545         emit UserInfoChange(oldUser, newUser);
546         return true;
547 
548     }
549     //for emergency case, Deeper Offical have permission to withdraw all fund in the contract
550     function withdrawAllFund(address token,uint256 amount) external onlyOwner returns(bool){
551         IERC20(token).safeTransfer(owner,amount);
552         emit WithdrawAllFunds(owner);
553         return true;
554     }
555 	
556 
557     function setPause(bool is_pause) external onlyOwner returns(bool){
558         pause = is_pause;
559         return true;
560     }
561 
562     function adminWithdrawUserFund(address user) external onlyOwner returns(bool){
563         require(user_staking_amount[user] >0, "DPRStaking: No staking");
564         dpr.safeTransfer(user, user_staking_amount[user]);
565         clearAccount(user, true);
566         emit AdminWithdrawUserFund(user);
567         return true;
568     }
569 	
570     function clearAccount(address user, bool is_clear_address) private{
571         delete user_staking_amount[user];
572         delete user_release_time[user];
573         delete user_claimed_map[user];
574 		// delete user_staking_period_index[user];
575 		// delete user_staking_periods[user];
576         delete user_staking_time[user];
577         if(is_clear_address){
578 			delete address_dpr_mapping[dpr_address_mapping[user]];
579 		}
580 		delete dpr_address_mapping[user];
581     }
582 	
583 
584     function extendStaking() external returns(bool){
585         require(user_staking_amount[msg.sender] > 0, "DPRStaking: User does not stake");
586         require(!isUserClaim(msg.sender), "DPRStaking: User start claim");
587         // Can be extended up to 12 hours before the staking end
588         //require(block.timestamp  >= user_release_time[msg.sender].sub(43200) && block.timestamp <=user_release_time[msg.sender], "DPRStaking: Too early");
589         user_release_time[msg.sender] = user_release_time[msg.sender] + staking_time;
590         emit ExtendStakingTime(msg.sender);
591         return true;
592     }
593 
594     function migrate() external returns(bool){
595         uint256 staking_amount = user_staking_amount[msg.sender];
596         require(staking_amount >0, "DPRStaking: User does not stake");
597         require(address(migrate_address) != address(0), "DPRStaking: Staking not start");
598         clearAccount(msg.sender, true);
599         dpr.approve(address(migrate_address), uint256(-1));
600         migrate_address.migrate(msg.sender, staking_amount);
601         emit Migrate(address(migrate_address), staking_amount);
602         return true;
603     }
604 
605 
606 
607     function setMigrateAddress(address _migrate_address) external onlyOwner returns(bool){
608         migrate_address = IMigrate(_migrate_address);
609         emit MigrateAddressSet(_migrate_address);
610         return true;
611     }
612 
613 
614     function checkDPRAddress(address _address, string memory _dprAddress) private{
615         require(keccak256(abi.encodePacked(dpr_address_mapping[_address])) == bytes32(hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"), "DPRStaking: DPRAddress already set");
616         require(address_dpr_mapping[_dprAddress] == address(0), "DPRStaking: ETH address already bind an DPRAddress");
617     }
618 	
619 
620     // function isUserStartRelease(address _user) external view returns(bool){
621     //     return user_start_release[msg.sender];
622     // }
623 
624     function getUserDPRAddress(address user) external view returns(string memory){
625         return dpr_address_mapping[user];
626     }
627 	
628 	function getUserAddressByDPRAddress(string calldata dpr_address) external view returns(address){
629 		return address_dpr_mapping[dpr_address];
630 	}
631 
632     function getReleaseTime(address user) external view returns(uint256){
633         return user_release_time[user];
634     }
635 
636     function getStaking(address user) external view returns(uint256){
637         return user_staking_amount[user];
638     }
639 
640     function getUserReleasePerDay(address user) external view returns(uint256){
641         uint256 staking_amount = user_staking_amount[user];
642         uint256 release_per_day = staking_amount.mul(1 days).div(total_release_time);
643         return release_per_day;
644     }
645 
646     function getUserClaimInfo(address user) external view returns(uint256){
647         return user_claimed_map[user];
648     }
649 
650     function getReleaseTimeInDays() external view returns(uint256){
651         return total_release_time.div(1 days);
652     }
653 
654 
655     function getUserStakingTime(address user) external view returns(uint256){
656         return user_staking_time[user];
657     }
658 
659     function canUserClaim(address user) public  view returns(bool){
660         return block.timestamp >= (user_staking_time[user] + staking_time);
661     }
662 
663     function isUserClaim(address user) public view returns(bool){
664         return user_start_claim[user];
665     }
666 }