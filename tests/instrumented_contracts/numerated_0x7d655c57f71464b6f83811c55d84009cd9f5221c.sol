1 pragma solidity ^0.6.2;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract ReentrancyGuard {
6   bool private _notEntered;
7 
8   constructor() internal {
9     // Storing an initial non-zero value makes deployment a bit more
10     // expensive, but in exchange the refund on every call to nonReentrant
11     // will be lower in amount. Since refunds are capped to a percetange of
12     // the total transaction's gas, it is best to keep them low in cases
13     // like this one, to increase the likelihood of the full refund coming
14     // into effect.
15     _notEntered = true;
16   }
17 
18   /**
19    * @dev Prevents a contract from calling itself, directly or indirectly.
20    * Calling a `nonReentrant` function from another `nonReentrant`
21    * function is not supported. It is possible to prevent this from happening
22    * by making the `nonReentrant` function external, and make it call a
23    * `private` function that does the actual work.
24    */
25   modifier nonReentrant() {
26     // On the first call to nonReentrant, _notEntered will be true
27     require(_notEntered, "ReentrancyGuard: reentrant call");
28 
29     // Any calls to nonReentrant after this point will fail
30     _notEntered = false;
31 
32     _;
33 
34     // By storing the original value once again, a refund is triggered (see
35     // https://eips.ethereum.org/EIPS/eip-2200)
36     _notEntered = true;
37   }
38 }
39 
40 
41 contract Context {
42   // Empty internal constructor, to prevent people from mistakenly deploying
43   // an instance of this contract, which should be used via inheritance.
44   constructor() internal {}
45 
46   function _msgSender() internal virtual view returns (address payable) {
47     return msg.sender;
48   }
49 
50   function _msgData() internal virtual view returns (bytes memory) {
51     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
52     return msg.data;
53   }
54 }
55 
56 
57 contract Pausable is Context {
58   /**
59    * @dev Emitted when the pause is triggered by `account`.
60    */
61   event Paused(address account);
62 
63   /**
64    * @dev Emitted when the pause is lifted by `account`.
65    */
66   event Unpaused(address account);
67 
68   bool private _paused;
69 
70   /**
71    * @dev Initializes the contract in unpaused state.
72    */
73   constructor() internal {
74     _paused = false;
75   }
76 
77   /**
78    * @dev Returns true if the contract is paused, and false otherwise.
79    */
80   function paused() public view returns (bool) {
81     return _paused;
82   }
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is not paused.
86    */
87   modifier whenNotPaused() {
88     require(!_paused, "Pausable: paused");
89     _;
90   }
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is paused.
94    */
95   modifier whenPaused() {
96     require(_paused, "Pausable: not paused");
97     _;
98   }
99 
100   /**
101    * @dev Triggers stopped state.
102    */
103   function _pause() internal virtual whenNotPaused {
104     _paused = true;
105     emit Paused(_msgSender());
106   }
107 
108   /**
109    * @dev Returns to normal state.
110    */
111   function _unpause() internal virtual whenPaused {
112     _paused = false;
113     emit Unpaused(_msgSender());
114   }
115 }
116 
117 
118 contract Ownable is Context {
119   address private _owner;
120 
121   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123   /**
124    * @dev Initializes the contract setting the deployer as the initial owner.
125    */
126   constructor() internal {
127     address msgSender = _msgSender();
128     _owner = msgSender;
129     emit OwnershipTransferred(address(0), msgSender);
130   }
131 
132   /**
133    * @dev Returns the address of the current owner.
134    */
135   function owner() public view returns (address) {
136     return _owner;
137   }
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(_owner == _msgSender(), "Ownable: caller is not the owner");
144     _;
145   }
146 
147   /**
148    * @dev Leaves the contract without owner. It will not be possible to call
149    * `onlyOwner` functions anymore. Can only be called by the current owner.
150    *
151    * NOTE: Renouncing ownership will leave the contract without an owner,
152    * thereby removing any functionality that is only available to the owner.
153    */
154   function renounceOwnership() public virtual onlyOwner {
155     emit OwnershipTransferred(_owner, address(0));
156     _owner = address(0);
157   }
158 
159   /**
160    * @dev Transfers ownership of the contract to a new account (`newOwner`).
161    * Can only be called by the current owner.
162    */
163   function transferOwnership(address newOwner) public virtual onlyOwner {
164     require(newOwner != address(0), "Ownable: new owner is the zero address");
165     emit OwnershipTransferred(_owner, newOwner);
166     _owner = newOwner;
167   }
168 }
169 
170 
171 interface IERC20 {
172   /**
173    * @dev Returns the amount of tokens in existence.
174    */
175   function totalSupply() external view returns (uint256);
176 
177   /**
178    * @dev Returns the amount of tokens owned by `account`.
179    */
180   function balanceOf(address account) external view returns (uint256);
181 
182   /**
183    * @dev Moves `amount` tokens from the caller's account to `recipient`.
184    *
185    * Returns a boolean value indicating whether the operation succeeded.
186    *
187    * Emits a {Transfer} event.
188    */
189   function transfer(address recipient, uint256 amount) external returns (bool);
190 
191   /**
192    * @dev Returns the remaining number of tokens that `spender` will be
193    * allowed to spend on behalf of `owner` through {transferFrom}. This is
194    * zero by default.
195    *
196    * This value changes when {approve} or {transferFrom} are called.
197    */
198   function allowance(address owner, address spender) external view returns (uint256);
199 
200   /**
201    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
202    *
203    * Returns a boolean value indicating whether the operation succeeded.
204    *
205    * IMPORTANT: Beware that changing an allowance with this method brings the risk
206    * that someone may use both the old and the new allowance by unfortunate
207    * transaction ordering. One possible solution to mitigate this race
208    * condition is to first reduce the spender's allowance to 0 and set the
209    * desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    *
212    * Emits an {Approval} event.
213    */
214   function approve(address spender, uint256 amount) external returns (bool);
215 
216   /**
217    * @dev Moves `amount` tokens from `sender` to `recipient` using the
218    * allowance mechanism. `amount` is then deducted from the caller's
219    * allowance.
220    *
221    * Returns a boolean value indicating whether the operation succeeded.
222    *
223    * Emits a {Transfer} event.
224    */
225   function transferFrom(
226     address sender,
227     address recipient,
228     uint256 amount
229   ) external returns (bool);
230 
231   /**
232    * @dev Emitted when `value` tokens are moved from one account (`from`) to
233    * another (`to`).
234    *
235    * Note that `value` may be zero.
236    */
237   event Transfer(address indexed from, address indexed to, uint256 value);
238 
239   /**
240    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
241    * a call to {approve}. `value` is the new allowance.
242    */
243   event Approval(address indexed owner, address indexed spender, uint256 value);
244 }
245 
246 
247 library Address {
248   /**
249    * @dev Returns true if `account` is a contract.
250    *
251    * [IMPORTANT]
252    * ====
253    * It is unsafe to assume that an address for which this function returns
254    * false is an externally-owned account (EOA) and not a contract.
255    *
256    * Among others, `isContract` will return false for the following
257    * types of addresses:
258    *
259    *  - an externally-owned account
260    *  - a contract in construction
261    *  - an address where a contract will be created
262    *  - an address where a contract lived, but was destroyed
263    * ====
264    */
265   function isContract(address account) internal view returns (bool) {
266     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
267     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
268     // for accounts without code, i.e. `keccak256('')`
269     bytes32 codehash;
270     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271     // solhint-disable-next-line no-inline-assembly
272     assembly {
273       codehash := extcodehash(account)
274     }
275     return (codehash != accountHash && codehash != 0x0);
276   }
277 
278   /**
279    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280    * `recipient`, forwarding all available gas and reverting on errors.
281    *
282    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283    * of certain opcodes, possibly making contracts go over the 2300 gas limit
284    * imposed by `transfer`, making them unable to receive funds via
285    * `transfer`. {sendValue} removes this limitation.
286    *
287    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288    *
289    * IMPORTANT: because control is transferred to `recipient`, care must be
290    * taken to not create reentrancy vulnerabilities. Consider using
291    * {ReentrancyGuard} or the
292    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293    */
294   function sendValue(address payable recipient, uint256 amount) internal {
295     require(address(this).balance >= amount, "Address: insufficient balance");
296 
297     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298     (bool success, ) = recipient.call{value: amount}("");
299     require(success, "Address: unable to send value, recipient may have reverted");
300   }
301 }
302 
303 
304 library SafeMath {
305   /**
306    * @dev Returns the addition of two unsigned integers, reverting on
307    * overflow.
308    *
309    * Counterpart to Solidity's `+` operator.
310    *
311    * Requirements:
312    * - Addition cannot overflow.
313    */
314   function add(uint256 a, uint256 b) internal pure returns (uint256) {
315     uint256 c = a + b;
316     require(c >= a, "SafeMath: addition overflow");
317 
318     return c;
319   }
320 
321   /**
322    * @dev Returns the subtraction of two unsigned integers, reverting on
323    * overflow (when the result is negative).
324    *
325    * Counterpart to Solidity's `-` operator.
326    *
327    * Requirements:
328    * - Subtraction cannot overflow.
329    */
330   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
331     return sub(a, b, "SafeMath: subtraction overflow");
332   }
333 
334   /**
335    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
336    * overflow (when the result is negative).
337    *
338    * Counterpart to Solidity's `-` operator.
339    *
340    * Requirements:
341    * - Subtraction cannot overflow.
342    */
343   function sub(
344     uint256 a,
345     uint256 b,
346     string memory errorMessage
347   ) internal pure returns (uint256) {
348     require(b <= a, errorMessage);
349     uint256 c = a - b;
350 
351     return c;
352   }
353 
354   /**
355    * @dev Returns the multiplication of two unsigned integers, reverting on
356    * overflow.
357    *
358    * Counterpart to Solidity's `*` operator.
359    *
360    * Requirements:
361    * - Multiplication cannot overflow.
362    */
363   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
364     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
365     // benefit is lost if 'b' is also tested.
366     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
367     if (a == 0) {
368       return 0;
369     }
370 
371     uint256 c = a * b;
372     require(c / a == b, "SafeMath: multiplication overflow");
373 
374     return c;
375   }
376 
377   /**
378    * @dev Returns the integer division of two unsigned integers. Reverts on
379    * division by zero. The result is rounded towards zero.
380    *
381    * Counterpart to Solidity's `/` operator. Note: this function uses a
382    * `revert` opcode (which leaves remaining gas untouched) while Solidity
383    * uses an invalid opcode to revert (consuming all remaining gas).
384    *
385    * Requirements:
386    * - The divisor cannot be zero.
387    */
388   function div(uint256 a, uint256 b) internal pure returns (uint256) {
389     return div(a, b, "SafeMath: division by zero");
390   }
391 
392   /**
393    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
394    * division by zero. The result is rounded towards zero.
395    *
396    * Counterpart to Solidity's `/` operator. Note: this function uses a
397    * `revert` opcode (which leaves remaining gas untouched) while Solidity
398    * uses an invalid opcode to revert (consuming all remaining gas).
399    *
400    * Requirements:
401    * - The divisor cannot be zero.
402    */
403   function div(
404     uint256 a,
405     uint256 b,
406     string memory errorMessage
407   ) internal pure returns (uint256) {
408     // Solidity only automatically asserts when dividing by 0
409     require(b > 0, errorMessage);
410     uint256 c = a / b;
411     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
412 
413     return c;
414   }
415 
416   /**
417    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418    * Reverts when dividing by zero.
419    *
420    * Counterpart to Solidity's `%` operator. This function uses a `revert`
421    * opcode (which leaves remaining gas untouched) while Solidity uses an
422    * invalid opcode to revert (consuming all remaining gas).
423    *
424    * Requirements:
425    * - The divisor cannot be zero.
426    */
427   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
428     return mod(a, b, "SafeMath: modulo by zero");
429   }
430 
431   /**
432    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
433    * Reverts with custom message when dividing by zero.
434    *
435    * Counterpart to Solidity's `%` operator. This function uses a `revert`
436    * opcode (which leaves remaining gas untouched) while Solidity uses an
437    * invalid opcode to revert (consuming all remaining gas).
438    *
439    * Requirements:
440    * - The divisor cannot be zero.
441    */
442   function mod(
443     uint256 a,
444     uint256 b,
445     string memory errorMessage
446   ) internal pure returns (uint256) {
447     require(b != 0, errorMessage);
448     return a % b;
449   }
450 }
451 
452 
453 library SafeERC20 {
454   using SafeMath for uint256;
455   using Address for address;
456 
457   function safeTransfer(
458     IERC20 token,
459     address to,
460     uint256 value
461   ) internal {
462     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
463   }
464 
465   function safeTransferFrom(
466     IERC20 token,
467     address from,
468     address to,
469     uint256 value
470   ) internal {
471     _callOptionalReturn(
472       token,
473       abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
474     );
475   }
476 
477   function safeApprove(
478     IERC20 token,
479     address spender,
480     uint256 value
481   ) internal {
482     // safeApprove should only be called when setting an initial allowance,
483     // or when resetting it to zero. To increase and decrease it, use
484     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
485     // solhint-disable-next-line max-line-length
486     require(
487       (value == 0) || (token.allowance(address(this), spender) == 0),
488       "SafeERC20: approve from non-zero to non-zero allowance"
489     );
490     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
491   }
492 
493   function safeIncreaseAllowance(
494     IERC20 token,
495     address spender,
496     uint256 value
497   ) internal {
498     uint256 newAllowance = token.allowance(address(this), spender).add(value);
499     _callOptionalReturn(
500       token,
501       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
502     );
503   }
504 
505   function safeDecreaseAllowance(
506     IERC20 token,
507     address spender,
508     uint256 value
509   ) internal {
510     uint256 newAllowance = token.allowance(address(this), spender).sub(
511       value,
512       "SafeERC20: decreased allowance below zero"
513     );
514     _callOptionalReturn(
515       token,
516       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
517     );
518   }
519 
520   /**
521    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
522    * on the return value: the return value is optional (but if data is returned, it must not be false).
523    * @param token The token targeted by the call.
524    * @param data The call data (encoded using abi.encode or one of its variants).
525    */
526   function _callOptionalReturn(IERC20 token, bytes memory data) private {
527     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
528     // we're implementing it ourselves.
529 
530     // A Solidity high level call has three parts:
531     //  1. The target address is checked to verify it contains contract code
532     //  2. The call itself is made, and success asserted
533     //  3. The return value is decoded, which in turn checks the size of the returned data.
534     // solhint-disable-next-line max-line-length
535     require(address(token).isContract(), "SafeERC20: call to non-contract");
536 
537     // solhint-disable-next-line avoid-low-level-calls
538     (bool success, bytes memory returndata) = address(token).call(data);
539     require(success, "SafeERC20: low-level call failed");
540 
541     if (returndata.length > 0) {
542       // Return data is optional
543       // solhint-disable-next-line max-line-length
544       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
545     }
546   }
547 }
548 
549 
550 contract BulkCheckout is Ownable, Pausable, ReentrancyGuard {
551   using Address for address payable;
552   using SafeMath for uint256;
553   /**
554    * @notice Placeholder token address for ETH donations. This address is used in various other
555    * projects as a stand-in for ETH
556    */
557   address constant ETH_TOKEN_PLACHOLDER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
558 
559   /**
560    * @notice Required parameters for each donation
561    */
562   struct Donation {
563     address token; // address of the token to donate
564     uint256 amount; // amount of tokens to donate
565     address payable dest; // grant address
566   }
567 
568   /**
569    * @dev Emitted on each donation
570    */
571   event DonationSent(
572     address indexed token,
573     uint256 indexed amount,
574     address dest,
575     address indexed donor
576   );
577 
578   /**
579    * @dev Emitted when a token or ETH is withdrawn from the contract
580    */
581   event TokenWithdrawn(address indexed token, uint256 indexed amount, address indexed dest);
582 
583   /**
584    * @notice Bulk gitcoin grant donations
585    * @dev We assume all token approvals were already executed
586    * @param _donations Array of donation structs
587    */
588   function donate(Donation[] calldata _donations) external payable nonReentrant whenNotPaused {
589     // We track total ETH donations to ensure msg.value is exactly correct
590     uint256 _ethDonationTotal = 0;
591 
592     for (uint256 i = 0; i < _donations.length; i++) {
593       emit DonationSent(_donations[i].token, _donations[i].amount, _donations[i].dest, msg.sender);
594       if (_donations[i].token != ETH_TOKEN_PLACHOLDER) {
595         // Token donation
596         // This method throws on failure, so there is no return value to check
597         SafeERC20.safeTransferFrom(
598           IERC20(_donations[i].token),
599           msg.sender,
600           _donations[i].dest,
601           _donations[i].amount
602         );
603       } else {
604         // ETH donation
605         // See comments in Address.sol for why we use sendValue over transer
606         _donations[i].dest.sendValue(_donations[i].amount);
607         _ethDonationTotal = _ethDonationTotal.add(_donations[i].amount);
608       }
609     }
610 
611     // Revert if the wrong amount of ETH was sent
612     require(msg.value == _ethDonationTotal, "BulkCheckout: Too much ETH sent");
613   }
614 
615   /**
616    * @notice Transfers all tokens of the input adress to the recipient. This is
617    * useful tokens are accidentally sent to this contrasct
618    * @param _tokenAddress address of token to send
619    * @param _dest destination address to send tokens to
620    */
621   function withdrawToken(address _tokenAddress, address _dest) external onlyOwner {
622     uint256 _balance = IERC20(_tokenAddress).balanceOf(address(this));
623     emit TokenWithdrawn(_tokenAddress, _balance, _dest);
624     SafeERC20.safeTransfer(IERC20(_tokenAddress), _dest, _balance);
625   }
626 
627   /**
628    * @notice Transfers all Ether to the specified address
629    * @param _dest destination address to send ETH to
630    */
631   function withdrawEther(address payable _dest) external onlyOwner {
632     uint256 _balance = address(this).balance;
633     emit TokenWithdrawn(ETH_TOKEN_PLACHOLDER, _balance, _dest);
634     _dest.sendValue(_balance);
635   }
636 
637   /**
638    * @notice Pause contract
639    */
640   function pause() external onlyOwner whenNotPaused {
641     _pause();
642   }
643 
644   /**
645    * @notice Unpause contract
646    */
647   function unpause() external onlyOwner whenPaused {
648     _unpause();
649   }
650 }