1 pragma solidity ^0.5.9;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
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
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
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
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      *
132      * _Available since v2.4.0._
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      *
190      * _Available since v2.4.0._
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         // Solidity only automatically asserts when dividing by 0
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      * - The divisor cannot be zero.
226      *
227      * _Available since v2.4.0._
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
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
375  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
376  *
377  * These functions can be used to verify that a message was signed by the holder
378  * of the private keys of a given address.
379  */
380 library ECDSA {
381     /**
382      * @dev Returns the address that signed a hashed message (`hash`) with
383      * `signature`. This address can then be used for verification purposes.
384      *
385      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
386      * this function rejects them by requiring the `s` value to be in the lower
387      * half order, and the `v` value to be either 27 or 28.
388      *
389      * NOTE: This call _does not revert_ if the signature is invalid, or
390      * if the signer is otherwise unable to be retrieved. In those scenarios,
391      * the zero address is returned.
392      *
393      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
394      * verification to be secure: it is possible to craft signatures that
395      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
396      * this is by receiving a hash of the original message (which may otherwise
397      * be too long), and then calling {toEthSignedMessageHash} on it.
398      */
399     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
400         // Check the signature length
401         if (signature.length != 65) {
402             return (address(0));
403         }
404 
405         // Divide the signature in r, s and v variables
406         bytes32 r;
407         bytes32 s;
408         uint8 v;
409 
410         // ecrecover takes the signature parameters, and the only way to get them
411         // currently is to use assembly.
412         // solhint-disable-next-line no-inline-assembly
413         assembly {
414             r := mload(add(signature, 0x20))
415             s := mload(add(signature, 0x40))
416             v := byte(0, mload(add(signature, 0x60)))
417         }
418 
419         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
420         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
421         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
422         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
423         //
424         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
425         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
426         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
427         // these malleable signatures as well.
428         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
429             return address(0);
430         }
431 
432         if (v != 27 && v != 28) {
433             return address(0);
434         }
435 
436         // If the signature is valid (and not malleable), return the signer address
437         return ecrecover(hash, v, r, s);
438     }
439 
440     /**
441      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
442      * replicates the behavior of the
443      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
444      * JSON-RPC method.
445      *
446      * See {recover}.
447      */
448     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
449         // 32 is the length in bytes of hash,
450         // enforced by the type signature above
451         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
452     }
453 }
454 
455 //Beneficieries (validators) template
456 //import "../helpers/ValidatorsOperations.sol";
457 contract DPRBridge {
458 
459         IERC20 public token;
460         using SafeERC20 for IERC20;
461         using SafeMath for uint256;
462 
463         enum Status {PENDING,WITHDRAW, CANCELED, CONFIRMED, CONFIRMED_WITHDRAW}
464         
465         struct DepositInfo{
466             uint256 last_deposit_time;
467             uint256 deposit_amount;
468         }
469 
470         struct WithdrawInfo{
471             uint256 last_withdraw_time;
472             uint256 withdraw_amount;
473         }
474         struct Message {
475             bytes32 messageID;
476             address spender;
477             bytes32 substrateAddress;
478             uint availableAmount;
479             Status status;
480         }
481 
482     
483 
484         event RelayMessage(bytes32 messageID, address sender, bytes32 recipient, uint amount);
485         event RevertMessage(bytes32 messageID, address sender, uint amount);
486         event WithdrawMessage(bytes32 MessageID, address recipient , bytes32 substrateSender, uint amount, bytes sig);
487         event ConfirmWithdrawMessage(bytes32 messageID);
488         
489 
490         bytes constant internal SIGN_HASH_PREFIX = "\x19Ethereum Signed Message:\n32";
491         mapping(bytes32 => Message) public messages;
492         mapping(address => DepositInfo) public user_deposit_info;
493         mapping(address => WithdrawInfo) public user_withdraw_info;
494         DepositInfo public contract_deposit_info;
495         WithdrawInfo public contract_withdraw_info;
496         address public submiter;
497         address public owner;
498         uint256 private user_daily_max_deposit_and_withdraw_amount = 20000 * 10 ** 18; //init value
499         uint256 private daily_max_deposit_and_withdraw_amount = 500000 * 10 ** 18; //init value
500         uint256 private user_min_deposit_and_withdraw_amount = 1000 * 10 ** 18; //init value
501         uint256 private user_max_deposit_and_withdraw_amount = 20000 * 10 ** 18; //init value
502 
503 
504 
505        /**
506        * @notice Constructor.
507        * @param _token  Address of DPR token
508        */
509 
510         constructor (IERC20 _token,address _submiter) public {
511             owner = msg.sender;
512             token = _token;
513             submiter = _submiter;
514         }  
515 
516         /*
517             check that message is valid
518         */
519         modifier validMessage(bytes32 messageID, address spender, bytes32 substrateAddress, uint availableAmount) {
520             require((messages[messageID].spender == spender)
521                 && (messages[messageID].substrateAddress == substrateAddress)
522                 && (messages[messageID].availableAmount == availableAmount), "Data is not valid");
523             _;
524         }
525 
526 
527         modifier pendingMessage(bytes32 messageID) {
528             require(messages[messageID].status ==  Status.PENDING, "DPRBridge: Message is not pending");
529             _;
530         }
531 
532         modifier onlyOwner(){
533             require(msg.sender == owner, "DPRBridge: Not Owner");
534         _;
535         }
536 
537         modifier withdrawMessage(bytes32 messageID) {
538             require(messages[messageID].status ==  Status.WITHDRAW, "Message is not withdrawed");
539             _;
540         }
541 
542         modifier  updateUserDepositInfo(address user, uint256 amount) {
543             require(amount >= user_min_deposit_and_withdraw_amount && amount <= user_max_deposit_and_withdraw_amount, "DPRBridge: Not in the range");
544             DepositInfo storage di = user_deposit_info[user];
545             uint256 last_deposit_time = di.last_deposit_time;
546             if(last_deposit_time == 0){
547                 require(amount <= user_daily_max_deposit_and_withdraw_amount,"DPRBridge: Execeed the daily limit");
548                 di.last_deposit_time = block.timestamp;
549                 di.deposit_amount = amount;
550             }else{
551                 uint256 pass_time = block.timestamp.sub(last_deposit_time);
552                 if(pass_time <= 1 days){
553                     uint256 total_deposit_amount = di.deposit_amount.add(amount);
554                     require(total_deposit_amount <= user_daily_max_deposit_and_withdraw_amount, "DPRBridge: Execeed the daily limit");
555                     di.deposit_amount = total_deposit_amount;
556                 }else{
557                     require(amount <= user_daily_max_deposit_and_withdraw_amount, "DPRBridge: Execeed the daily limit");
558                     di.last_deposit_time = block.timestamp;
559                     di.deposit_amount = amount;
560 
561                 }
562             }
563             _;
564         }
565 
566         modifier updateContractDepositInfo(uint256 amount){
567             DepositInfo storage cdi = contract_deposit_info;
568             uint256 last_deposit_time = cdi.last_deposit_time;
569             if(last_deposit_time == 0){
570                 cdi.last_deposit_time = block.timestamp;
571                 cdi.deposit_amount += amount;
572             }else{
573                 uint256 pass_time = block.timestamp.sub(last_deposit_time);
574                 if(pass_time <= 1 days){
575                     uint256 total_deposit_amount = cdi.deposit_amount.add(amount);
576                     require(total_deposit_amount <= daily_max_deposit_and_withdraw_amount, "DPRBridge: Execeed contract deposit limit");
577                     cdi.deposit_amount = total_deposit_amount;
578                 }else{
579                     cdi.deposit_amount = amount;
580                     cdi.last_deposit_time = block.timestamp;
581                 }
582                 
583             }
584             _;
585             
586         }
587 
588         modifier updateContractWithdrawInfo(uint256 amount){
589             WithdrawInfo storage cdi = contract_withdraw_info;
590             uint256 last_withdraw_time = cdi.last_withdraw_time;
591             if(last_withdraw_time == 0){
592                 cdi.last_withdraw_time = block.timestamp;
593                 cdi.withdraw_amount += amount;
594             }else{
595                 uint256 pass_time = block.timestamp.sub(last_withdraw_time);
596                 if(pass_time <= 1 days){
597                     uint256 total_withdraw_amount = cdi.withdraw_amount.add(amount);
598                     require(total_withdraw_amount <= daily_max_deposit_and_withdraw_amount, "DPRBridge: Execeed contract deposit limit");
599                     cdi.withdraw_amount = total_withdraw_amount;
600                 }else{
601                     cdi.withdraw_amount = amount;
602                     cdi.last_withdraw_time = block.timestamp;
603                 }
604                 
605             }
606             _;
607             
608         }
609 
610         modifier  updateUserWithdrawInfo(address user, uint256 amount) {
611             require(amount >= user_min_deposit_and_withdraw_amount && amount <= user_max_deposit_and_withdraw_amount, "DPRBridge: Not in the range");
612             WithdrawInfo storage ui = user_withdraw_info[user];
613             uint256 last_withdraw_time = ui.last_withdraw_time;
614             if(last_withdraw_time == 0){
615                 require(amount <= user_daily_max_deposit_and_withdraw_amount,"DPRBridge: Execeed the daily limit");
616                 ui.last_withdraw_time = block.timestamp;
617                 ui.withdraw_amount = amount;
618             }else{
619                 uint256 pass_time = block.timestamp.sub(last_withdraw_time);
620                 if(pass_time <= 1 days){
621                     uint256 total_withdraw_amount = ui.withdraw_amount.add(amount);
622                     require(total_withdraw_amount <= user_daily_max_deposit_and_withdraw_amount, "DPRBridge: Execeed the daily limit");
623                     ui.withdraw_amount = total_withdraw_amount;
624                 }else{
625                     require(amount <= user_daily_max_deposit_and_withdraw_amount, "DPRBridge: Execeed the daily limit");
626                     ui.last_withdraw_time = block.timestamp;
627                     ui.withdraw_amount = amount;
628 
629                 }
630             }
631             _;
632         }
633 
634         function changeSubmiter(address _newSubmiter)   external onlyOwner{
635             submiter = _newSubmiter;
636         }
637         function setUserDailyMax(uint256 max_amount) external onlyOwner returns(bool){
638             user_daily_max_deposit_and_withdraw_amount = max_amount;
639             return true;
640         }
641 
642         function setDailyMax(uint256 max_amount) external onlyOwner returns(bool){
643             daily_max_deposit_and_withdraw_amount = max_amount;
644             return true;
645         }
646 
647         function setUserMin(uint256 min_amount) external onlyOwner returns(bool){
648             user_min_deposit_and_withdraw_amount = min_amount;
649             return true;
650         }
651 
652          function setUserMax(uint256 max_amount) external onlyOwner returns(bool){
653             user_max_deposit_and_withdraw_amount = max_amount;
654             return true;
655          }
656 
657         function setTransfer(uint amount, bytes32 substrateAddress) public  
658             updateUserDepositInfo(msg.sender, amount) 
659             updateContractDepositInfo(amount){
660             require(token.allowance(msg.sender, address(this)) >= amount, "contract is not allowed to this amount");
661             
662             token.transferFrom(msg.sender, address(this), amount);
663 
664             bytes32 messageID = keccak256(abi.encodePacked(now));
665 
666             Message  memory message = Message(messageID, msg.sender, substrateAddress, amount, Status.CONFIRMED);
667             messages[messageID] = message;
668 
669             emit RelayMessage(messageID, msg.sender, substrateAddress, amount);
670         }
671 
672         /*
673         * Widthdraw finance by message ID when transfer pending
674         */
675         function revertTransfer(bytes32 messageID) public pendingMessage(messageID) {
676             Message storage message = messages[messageID];
677             require(message.spender == msg.sender, "DPRBridge: Not spender");
678             message.status = Status.CANCELED;
679             DepositInfo storage di = user_deposit_info[msg.sender];
680             di.deposit_amount = di.deposit_amount.sub(message.availableAmount);
681             DepositInfo storage cdi = contract_deposit_info;
682             cdi.deposit_amount.sub(message.availableAmount);
683             token.transfer(msg.sender, message.availableAmount);
684 
685             emit RevertMessage(messageID, msg.sender, message.availableAmount);
686         }
687 
688 
689         /*
690         * Withdraw tranfer by message ID after approve from Substrate
691         */
692         function withdrawTransfer(bytes32  substrateSender, address recipient, uint availableAmount,bytes memory sig)  public
693         updateContractWithdrawInfo(availableAmount)
694          {  
695             //require(msg.value == fee, "DPRBridge: Fee not match");
696             require(token.balanceOf(address(this)) >= availableAmount, "DPRBridge: Balance is not enough");
697             bytes32 messageID = keccak256(abi.encodePacked(substrateSender, recipient, availableAmount, block.timestamp));
698             setMessageAndEmitEvent(messageID, substrateSender, recipient, availableAmount, sig);
699         }
700 
701         function setMessageAndEmitEvent(bytes32 messageID, bytes32  substrateSender, address recipient, uint availableAmount, bytes memory sig) private {
702              Message  memory message = Message(messageID, recipient, substrateSender, availableAmount, Status.WITHDRAW);
703              messages[messageID] = message;
704              emit WithdrawMessage(messageID,msg.sender , substrateSender, availableAmount, sig);
705         }
706 
707         /*
708         * Confirm Withdraw tranfer by message ID after approve from Substrate
709         */
710         function confirmWithdrawTransfer(bytes32 messageID, bytes memory signature) public withdrawMessage(messageID) 
711         //onlyManyValidatorsConfirm(messageID, msg.sender) 
712         {
713             bytes32 data = keccak256(abi.encodePacked(messageID));
714             bytes32 sign_data = keccak256(abi.encodePacked(SIGN_HASH_PREFIX, data));
715             address recover_address = ECDSA.recover(sign_data, signature);
716             require(recover_address == submiter, "DPRBridge: Address not match");
717             Message storage message = messages[messageID];
718             uint256 withdraw_amount = message.availableAmount;
719             //setWithdrawData(message.spender, withdraw_amount);
720             message.status = Status.CONFIRMED_WITHDRAW;
721             token.safeTransfer(message.spender, withdraw_amount);
722             emit ConfirmWithdrawMessage(messageID);
723             
724             
725         }
726         function transferOwnerShip(address _newOwner) onlyOwner external{
727             owner = _newOwner;
728         }
729         function withdrawAllTokens(IERC20 _token, uint256 amount) external onlyOwner{
730             _token.safeTransfer(owner, amount);
731         }
732 }