1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.10;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers .
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 library SafeMath {
34     /**
35      * @dev Returns the addition of two unsigned integers, reverting on
36      * overflow.
37      *
38      * Counterpart to Solidity's `+` operator.
39      *
40      * Requirements:
41      *
42      * - Addition cannot overflow.
43      */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      *
73      * - Subtraction cannot overflow.
74      */
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the multiplication of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `*` operator.
87      *
88      * Requirements:
89      *
90      * - Multiplication cannot overflow.
91      */
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
94         // benefit is lost if 'b' is also tested.
95         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
96         if (a == 0) {
97             return 0;
98         }
99 
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b > 0, errorMessage);
136         uint256 c = a / b;
137         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return mod(a, b, "SafeMath: modulo by zero");
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts with custom message when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b != 0, errorMessage);
172         return a % b;
173     }
174     
175     function ceil(uint a, uint m) internal pure returns (uint r) {
176         return (a + m - 1) / m * m;
177     }
178 }
179 
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address) {
182         return msg.sender;
183     }
184 
185     function _msgData() internal view virtual returns (bytes memory) {
186         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
187         return msg.data;
188     }
189 }
190 
191 abstract contract Ownable is Context {
192     address private _owner;
193 
194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195 
196     /**
197      * @dev Initializes the contract setting the deployer as the initial owner.
198      */
199     constructor () {
200         _owner = msg.sender;
201         emit OwnershipTransferred(address(0), _owner);
202     }
203 
204     /**
205      * @dev Returns the address of the current owner.
206      */
207     function owner() public view returns (address) {
208         return _owner;
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         require(_owner == _msgSender(), "Ownable: caller is not the owner");
216         _;
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public virtual onlyOwner {
227         emit OwnershipTransferred(_owner, address(0));
228         _owner = address(0);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Can only be called by the current owner.
234      */
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(newOwner != address(0), "Ownable: new owner is the zero address");
237         emit OwnershipTransferred(_owner, newOwner);
238         _owner = newOwner;
239     }
240 }
241 
242 
243 interface IERC20 {
244     /**
245      * @dev Returns the amount of tokens in existence.
246      */
247     function totalSupply() external view returns (uint256);
248 
249     /**
250      * @dev Returns the amount of tokens owned by `account`.
251      */
252     function balanceOf(address account) external view returns (uint256);
253     
254     function decimals() external view returns (uint8);
255 
256    
257     function transfer(address recipient, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Returns the remaining number of tokens that `spender` will be
261      * allowed to spend on behalf of `owner` through {transferFrom}. This is
262      * zero by default.
263      *
264      * This value changes when {approve} or {transferFrom} are called.
265      */
266     function allowance(address owner, address spender) external view returns (uint256);
267 
268     /**
269      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * IMPORTANT: Beware that changing an allowance with this method brings the risk
274      * that someone may use both the old and the new allowance by unfortunate
275      * transaction ordering. One possible solution to mitigate this race
276      * condition is to first reduce the spender's allowance to 0 and set the
277      * desired value afterwards:
278      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279      *
280      * Emits an {Approval} event.
281      */
282     function approve(address spender, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Moves `amount` tokens from `sender` to `recipient` using the
286      * allowance mechanism. `amount` is then deducted from the caller's
287      * allowance.
288      *
289      * Returns a boolean value indicating whether the operation succeeded.
290      *
291      * Emits a {Transfer} event.
292      */
293     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
294 
295     /**
296      * @dev Emitted when `value` tokens are moved from one account (`from`) to
297      * another (`to`).
298      *
299      * Note that `value` may be zero.
300      */
301     event Transfer(address indexed from, address indexed to, uint256 value);
302 
303     /**
304      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
305      * a call to {approve}. `value` is the new allowance.
306      */
307     event Approval(address indexed owner, address indexed spender, uint256 value);
308 }
309 
310 library SafeERC20 {
311     using SafeMath for uint256;
312     using Address for address;
313 
314     function safeTransfer(IERC20 token, address to, uint256 value) internal {
315         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
316     }
317 
318     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
319         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
320     }
321 
322     /**
323      * @dev Deprecated. This function has issues similar to the ones found in
324      * {IERC20-approve}, and its usage is discouraged.
325      *
326      * Whenever possible, use {safeIncreaseAllowance} and
327      * {safeDecreaseAllowance} instead.
328      */
329     function safeApprove(IERC20 token, address spender, uint256 value) internal {
330         // safeApprove should only be called when setting an initial allowance,
331         // or when resetting it to zero. To increase and decrease it, use
332         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
333         // solhint-disable-next-line max-line-length
334         require((value == 0) || (token.allowance(address(this), spender) == 0),
335             "SafeERC20: approve from non-zero to non-zero allowance"
336         );
337         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
338     }
339 
340     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
341         uint256 newAllowance = token.allowance(address(this), spender).add(value);
342         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
343     }
344 
345     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
346         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
347         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
348     }
349 
350     /**
351      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
352      * on the return value: the return value is optional (but if data is returned, it must not be false).
353      * @param token The token targeted by the call.
354      * @param data The call data (encoded using abi.encode or one of its variants).
355      */
356     function _callOptionalReturn(IERC20 token, bytes memory data) private {
357         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
358         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
359         // the target address contains contract code and also asserts for success in the low-level call.
360 
361         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
362         if (returndata.length > 0) { // Return data is optional
363             // solhint-disable-next-line max-line-length
364             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
365         }
366     }
367 }
368 library Address {
369     /**
370      * @dev Returns true if `account` is a contract.
371      *
372      * [IMPORTANT]
373      * ====
374      * It is unsafe to assume that an address for which this function returns
375      * false is an externally-owned account (EOA) and not a contract.
376      *
377      * Among others, `isContract` will return false for the following
378      * types of addresses:
379      *
380      *  - an externally-owned account
381      *  - a contract in construction
382      *  - an address where a contract will be created
383      *  - an address where a contract lived, but was destroyed
384      * ====
385      */
386     function isContract(address account) internal view returns (bool) {
387         // This method relies on extcodesize, which returns 0 for contracts in
388         // construction, since the code is only stored at the end of the
389         // constructor execution.
390 
391         uint256 size;
392         // solhint-disable-next-line no-inline-assembly
393         assembly { size := extcodesize(account) }
394         return size > 0;
395     }
396 
397     /**
398      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
399      * `recipient`, forwarding all available gas and reverting on errors.
400      *
401      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
402      * of certain opcodes, possibly making contracts go over the 2300 gas limit
403      * imposed by `transfer`, making them unable to receive funds via
404      * `transfer`. {sendValue} removes this limitation.
405      *
406      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
407      *
408      * IMPORTANT: because control is transferred to `recipient`, care must be
409      * taken to not create reentrancy vulnerabilities. Consider using
410      * {ReentrancyGuard} or the
411      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
412      */
413     function sendValue(address payable recipient, uint256 amount) internal {
414         require(address(this).balance >= amount, "Address: insufficient balance");
415 
416         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
417         (bool success, ) = recipient.call{ value: amount }("");
418         require(success, "Address: unable to send value, recipient may have reverted");
419     }
420 
421     /**
422      * @dev Performs a Solidity function call using a low level `call`. A
423      * plain`call` is an unsafe replacement for a function call: use this
424      * function instead.
425      *
426      * If `target` reverts with a revert reason, it is bubbled up by this
427      * function (like regular Solidity function calls).
428      *
429      * Returns the raw returned data. To convert to the expected return value,
430      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
431      *
432      * Requirements:
433      *
434      * - `target` must be a contract.
435      * - calling `target` with `data` must not revert.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
440       return functionCall(target, data, "Address: low-level call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
445      * `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, 0, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but also transferring `value` wei to `target`.
456      *
457      * Requirements:
458      *
459      * - the calling contract must have an ETH balance of at least `value`.
460      * - the called Solidity function must be `payable`.
461      *
462      * _Available since v3.1._
463      */
464     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
465         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
470      * with `errorMessage` as a fallback revert reason when `target` reverts.
471      *
472      * _Available since v3.1._
473      */
474     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
475         require(address(this).balance >= value, "Address: insufficient balance for call");
476         require(isContract(target), "Address: call to non-contract");
477 
478         // solhint-disable-next-line avoid-low-level-calls
479         (bool success, bytes memory returndata) = target.call{ value: value }(data);
480         return _verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a static call.
486      *
487      * _Available since v3.3._
488      */
489     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
490         return functionStaticCall(target, data, "Address: low-level static call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
500         require(isContract(target), "Address: static call to non-contract");
501 
502         // solhint-disable-next-line avoid-low-level-calls
503         (bool success, bytes memory returndata) = target.staticcall(data);
504         return _verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a delegate call.
510      *
511      * _Available since v3.3._
512      */
513     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
514         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
519      * but performing a delegate call.
520      *
521      * _Available since v3.3._
522      */
523     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
524         require(isContract(target), "Address: delegate call to non-contract");
525 
526         // solhint-disable-next-line avoid-low-level-calls
527         (bool success, bytes memory returndata) = target.delegatecall(data);
528         return _verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
532         if (success) {
533             return returndata;
534         } else {
535             // Look for revert reason and bubble it up if present
536             if (returndata.length > 0) {
537                 // The easiest way to bubble the revert reason is using memory via assembly
538 
539                 // solhint-disable-next-line no-inline-assembly
540                 assembly {
541                     let returndata_size := mload(returndata)
542                     revert(add(32, returndata), returndata_size)
543                 }
544             } else {
545                 revert(errorMessage);
546             }
547         }
548     }
549 }
550 library TransferHelper {
551     
552     function safeTransferFrom(address token, address from, address to, uint value) internal {
553         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
554         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
555         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
556     }
557 
558 }
559 abstract contract ReentrancyGuard {
560     // Booleans are more expensive than uint256 or any type that takes up a full
561     // word because each write operation emits an extra SLOAD to first read the
562     // slot's contents, replace the bits taken up by the boolean, and then write
563     // back. This is the compiler's defense against contract upgrades and
564     // pointer aliasing, and it cannot be disabled.
565 
566     // The values being non-zero value makes deployment a bit more expensive,
567     // but in exchange the refund on every call to nonReentrant will be lower in
568     // amount. Since refunds are capped to a percentage of the total
569     // transaction's gas, it is best to keep them low in cases like this one, to
570     // increase the likelihood of the full refund coming into effect.
571     uint256 private constant _NOT_ENTERED = 1;
572     uint256 private constant _ENTERED = 2;
573 
574     uint256 private _status;
575 
576     constructor () {
577         _status = _NOT_ENTERED;
578     }
579 
580     /**
581      * @dev Prevents a contract from calling itself, directly or indirectly.
582      * Calling a `nonReentrant` function from another `nonReentrant`
583      * function is not supported. It is possible to prevent this from happening
584      * by making the `nonReentrant` function external, and make it call a
585      * `private` function that does the actual work.
586      */
587     modifier nonReentrant() {
588         // On the first call to nonReentrant, _notEntered will be true
589         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
590 
591         // Any calls to nonReentrant after this point will fail
592         _status = _ENTERED;
593 
594         _;
595 
596         // By storing the original value once again, a refund is triggered (see
597         // https://eips.ethereum.org/EIPS/eip-2200)
598         _status = _NOT_ENTERED;
599     }
600 }
601 
602 abstract contract IRewardDistributionRecipient is Ownable {
603     address rewardDistribution;
604 
605     modifier onlyRewardDistribution() {
606         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
607         _;
608     }
609 
610     function setRewardDistributionAdmin(address _rewardDistribution)
611         internal
612     {
613         require(rewardDistribution == address(0), "Reward distribution Admin already set");
614         rewardDistribution = _rewardDistribution;
615     }
616     
617     function updateRewardDistributionAdmin(address _rewardDistribution) public onlyOwner {
618         require(rewardDistribution == address(0), "Reward distribution Admin already set");
619         rewardDistribution = _rewardDistribution;
620     }
621     
622 }
623 
624 interface iGoldFarmFaaS {
625     function Initialize(address, address, address, uint256, uint256, uint256, address) external; 
626     function setFarmRewards(uint256, uint256) external;
627     function setFarmRewards1(uint256, uint256) external;
628 }
629 
630 interface iGoldFarmFaaSForOne {
631     function Initialize(address, address, uint256, uint256, address) external; 
632     function setFarmRewards(uint256, uint256) external;
633 }
634 
635 contract GoldFarmFaasDeployer{
636     using Address for address;
637     event FaaSCreated(address, address, address);
638 
639     mapping(address => mapping(address => mapping(address => address))) public getFaaSContract;
640     address[] public allContracts;
641     
642     
643     
644     function createFaaS(address _lpToken, address rewardToken0, address rewardToken1, 
645                             uint256 rewardToken1Amount, uint256 _duration1, 
646                             uint256 rewardToken2Amount, uint256 _duration2,
647                             uint256 lpTokenFrictionlessFee) 
648             external returns (address pair) {
649         
650         require(getFaaSContract[_lpToken][rewardToken0][rewardToken1] == address(0), 'Faas: Contract_EXISTS'); // single check is sufficient
651         require(_duration1 !=0, "Cannot be 0");
652         require(_duration2 !=0, "Cannot be 0");
653         bytes memory bytecode = type(GoldFarmFaaS).creationCode;
654         bytes32 salt = keccak256(abi.encodePacked(_lpToken, rewardToken0, rewardToken1));
655         assembly {
656             pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
657         }
658         
659         iGoldFarmFaaS(pair).Initialize(_lpToken, rewardToken0, rewardToken1, _duration1, _duration2, lpTokenFrictionlessFee, msg.sender); 
660         
661         getFaaSContract[_lpToken][rewardToken0][rewardToken1] = pair;
662         allContracts.push(pair);
663         
664         TransferHelper.safeTransferFrom(rewardToken0, msg.sender, address(pair), rewardToken1Amount);
665         TransferHelper.safeTransferFrom(rewardToken1, msg.sender, address(pair), rewardToken2Amount);
666         
667         iGoldFarmFaaS(pair).setFarmRewards(rewardToken1Amount, _duration1);
668         iGoldFarmFaaS(pair).setFarmRewards1(rewardToken2Amount, _duration2);
669         
670         emit FaaSCreated(_lpToken, rewardToken0, rewardToken1);
671     }
672     
673     function createFaaSForOne(address _lpToken, address rewardToken0, 
674                             uint256 rewardToken1Amount, uint256 _duration1,
675                             uint256 lpTokenFrictionlessFee) 
676             external returns (address pair) {
677         
678         require(getFaaSContract[_lpToken][rewardToken0][address(0)] == address(0), 'Faas: Contract_EXISTS'); // single check is sufficient
679         require(_duration1 !=0, "Cannot be 0");
680         bytes memory bytecode = type(GoldFarmFaaSForOne).creationCode;
681         bytes32 salt = keccak256(abi.encodePacked(_lpToken, rewardToken0, address(0)));
682         assembly {
683             pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
684         }
685         
686         iGoldFarmFaaSForOne(pair).Initialize(_lpToken, rewardToken0, _duration1, lpTokenFrictionlessFee, msg.sender); 
687         
688         getFaaSContract[_lpToken][rewardToken0][address(0)] = pair;
689         allContracts.push(pair);
690         
691         TransferHelper.safeTransferFrom(rewardToken0, msg.sender, address(pair), rewardToken1Amount);
692         
693         iGoldFarmFaaSForOne(pair).setFarmRewards(rewardToken1Amount, _duration1);
694         
695         emit FaaSCreated(_lpToken, rewardToken0, address(0));
696     }
697     
698     function getFaaSContractAddress(address _lpToken, address rewardToken0, address rewardToken1) public view returns(address){
699         return getFaaSContract[_lpToken][rewardToken0][rewardToken1];
700     }
701 }
702 
703 
704 contract GoldFarmFaaS is IRewardDistributionRecipient, ReentrancyGuard {
705     using SafeERC20 for IERC20;
706     using SafeMath for uint256;
707     using Address for address;
708     
709     IERC20 public rewardToken;
710     
711     IERC20 public rewardToken1;
712     
713     IERC20 public lpToken; // Farm Token BSC20
714     
715     address public devAddy = 0xdaC47d05e1aAa9Bd4DA120248E8e0d7480365CFB;//collects pool use fee
716     uint256 public devtxfee = 1; //Fee for pool use, sent to GOLD farming pool
717     uint256 public txfee = 0; //Amount of frictionless rewards of the LP token 
718     
719     uint256 public duration = 90 days;
720     uint256 public duration1 = 90 days;
721     bool public perform = true;
722     
723     uint256 public periodFinish = 0;
724     uint256 public rewardRate = 0;
725     uint256 public lastUpdateTime;
726     uint256 public rewardPerTokenStored;
727     mapping(address => uint256) public userRewardPerTokenPaid;
728     mapping(address => uint256) public rewards;
729     
730     uint256 public periodFinish1 = 0;
731     uint256 public rewardRate1 = 0;
732     uint256 public lastUpdateTime1;
733     uint256 public rewardPerTokenStored1;
734     mapping(address => uint256) public userRewardPerTokenPaid1;
735     mapping(address => uint256) public rewards1;
736     
737     mapping(address => uint) public farmTime; 
738     bool public farmBreaker = false; // farm can be lock by admin,, default unlocked type=0
739     bool public rewardBreaker = false; // getreward can be lock by admin,, default unlocked type=1
740     bool public reward1Breaker = false; // getreward1 can be lock by admin,, default unlocked type=2
741     bool public withdrawBreaker = false; // withdraw can be lock by admin,, default unlocked type=3
742     
743     uint256 private _totalSupply;
744     mapping(address => uint256) private _balances;
745     
746     mapping(address => uint256) public lpTokenReward;
747 
748     event RewardAdded(uint256 reward);
749     event Farmed(address indexed user, uint256 amount);
750     event Withdrawn(address indexed user, uint256 amount);
751     event RewardPaid(address indexed user, uint256 reward);
752     
753     address[] public farmers;
754     bool public deployed = false;
755     
756     struct USER{
757         bool initialized;
758     }
759     
760     mapping(address => USER) stakers;
761     
762     constructor() { }
763     
764     function Initialize(address _lpToken, address _rewardToken, address _rewardToken1, uint256 _duration1, uint256 _duration2, uint256 _lpTokenFrictionlessFee, address _newOwner) external nonReentrant {
765         require(deployed != true, "Contract can only Initialize once");
766         rewardToken = IERC20(_rewardToken);
767         rewardToken1 = IERC20(_rewardToken1);
768         lpToken = IERC20(_lpToken);
769         setRewardDistributionAdmin(msg.sender);
770         transferOwnership(_newOwner);
771         
772         duration = _duration1;
773         duration1 = _duration2;
774         
775         txfee = _lpTokenFrictionlessFee;
776         
777         deployed = true;
778     }
779 
780     modifier updateReward(address account) {
781         rewardPerTokenStored = rewardPerToken();
782         lastUpdateTime = lastTimeRewardApplicable();
783         if (account != address(0)) {
784             rewards[account] = earned(account);
785             userRewardPerTokenPaid[account] = rewardPerTokenStored;
786         }
787         _;
788     }
789     
790     modifier updateReward1(address account) {
791         rewardPerTokenStored1 = rewardPerToken1();
792         lastUpdateTime1 = lastTimeRewardApplicable1();
793         if (account != address(0)) {
794             rewards1[account] = earned1(account);
795             userRewardPerTokenPaid1[account] = rewardPerTokenStored1;
796         }
797         _;
798     }
799 
800 
801     modifier noContract(address account) {
802         require(Address.isContract(account) == false, "Contracts are not allowed to interact with the farm");
803         _;
804     }
805     
806     function setdevAddy(address _addy) public onlyOwner {
807         require(_addy != address(0), " Setting 0 as Addy "); 
808         devAddy = _addy;
809     }
810     
811     function setBreaker(bool _breaker, uint256 _type) external onlyOwner {
812         if(_type==0){
813             farmBreaker =_breaker;
814             
815         }
816         else if(_type==1){
817             rewardBreaker=_breaker;
818             
819         }
820         else if(_type==2){
821             reward1Breaker=_breaker;
822             
823         }else if(_type==3){
824             withdrawBreaker=_breaker;
825             
826         }
827     }
828 
829     function totalSupply() public view returns (uint256) {
830         return _totalSupply;
831     }
832 
833     function balanceOf(address account) public view returns (uint256) {
834         return _balances[account];
835     }
836     
837     function recoverLostTokensAfterFarmExpired(IERC20 _token, uint256 amount) external onlyOwner {
838         // Recover lost tokens can only be used after farming duration expires
839         require(duration < block.timestamp, "Cannot use if farm is live");
840         _token.safeTransfer(owner(), amount);
841     }
842     
843     receive() external payable {
844         // Prevent ETH from being sent to the farming contract
845         revert();
846     }
847 
848     function lastTimeRewardApplicable() public view returns (uint256) {
849         return Math.min(block.timestamp, periodFinish);
850     }
851     
852     function lastTimeRewardApplicable1() public view returns (uint256) {
853         return Math.min(block.timestamp, periodFinish1);
854     }
855     
856     function rewardPerToken() public view returns (uint256) {
857         if (totalSupply() == 0) {
858             return rewardPerTokenStored;
859         }
860 
861         return
862             rewardPerTokenStored.add(
863                 lastTimeRewardApplicable()
864                     .sub(lastUpdateTime)
865                     .mul(rewardRate)
866                     .mul(10** IERC20(rewardToken).decimals())
867                     .div(totalSupply())
868             );
869     }
870     
871     function rewardPerToken1() public view returns (uint256) {
872         if (totalSupply() == 0) {
873             return rewardPerTokenStored1;
874         }
875 
876         return
877             rewardPerTokenStored1.add(
878                 lastTimeRewardApplicable1()
879                     .sub(lastUpdateTime1)
880                     .mul(rewardRate1)
881                     .mul(10** IERC20(rewardToken1).decimals())
882                     .div(totalSupply())
883             );
884     }
885 
886 
887 
888     function earned(address account) public view returns (uint256) {
889         return
890             balanceOf(account)
891                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
892                 .div(10** IERC20(rewardToken).decimals())
893                 .add(rewards[account]);
894     }
895     
896     function earned1(address account) public view returns (uint256) {
897         return
898             balanceOf(account)
899                 .mul(rewardPerToken1().sub(userRewardPerTokenPaid1[account]))
900                 .div(10** IERC20(rewardToken1).decimals())
901                 .add(rewards1[account]);
902     }
903     
904     function isStakeholder(address _address)
905        public
906        view
907        returns(bool)
908    {
909        
910        if(stakers[_address].initialized) return true;
911        else return false;
912    }
913    
914    function addStakeholder(address _stakeholder)
915        internal
916    {
917        (bool _isStakeholder) = isStakeholder(_stakeholder);
918        if(!_isStakeholder) {
919            farmTime[msg.sender] =  block.timestamp;
920            stakers[_stakeholder].initialized = true;
921            farmers.push(_stakeholder);
922        }
923    }
924 
925     function farm(uint256 amount) external updateReward(msg.sender) updateReward1(msg.sender) noContract(msg.sender) nonReentrant {
926         require(farmBreaker == false, "Admin Restricted function temporarily 0");
927         require(amount > 0, "Cannot farm nothing");
928 
929         lpToken.safeTransferFrom(msg.sender, address(this), amount);
930         
931         uint256 devtax = amount.mul(devtxfee).div(100);
932         uint256 _txfee = amount.mul(txfee).div(100);
933         
934         lpToken.safeTransfer(address(devAddy), devtax);
935         
936         uint256 finalAmount = amount.sub(_txfee).sub(devtax);
937         
938         _totalSupply = _totalSupply.add(finalAmount);
939         _balances[msg.sender] = _balances[msg.sender].add(finalAmount);
940         
941         addStakeholder(msg.sender);
942         
943         emit Farmed(msg.sender,finalAmount);
944     }
945 
946     function withdraw(uint256 amount) public updateReward(msg.sender) updateReward1(msg.sender) noContract(msg.sender) nonReentrant {
947         require(withdrawBreaker == false, "Admin Restricted function temporarily 3");
948         require(amount > 0, "Cannot withdraw nothing");
949         
950         _totalSupply = _totalSupply.sub(amount);
951         _balances[msg.sender] = _balances[msg.sender].sub(amount);
952         lpToken.safeTransfer(msg.sender, amount);
953         
954         if( _balances[msg.sender] == 0) {
955             stakers[msg.sender].initialized = false;
956         }
957         emit Withdrawn(msg.sender, amount);
958         
959     }
960 
961     function exit() external {
962         withdraw(balanceOf(msg.sender));
963         ClaimLPReward(); 
964         getReward();
965         getReward1();
966         }
967 
968     function getReward() public updateReward(msg.sender) noContract(msg.sender) {
969         require(rewardBreaker == false, "Admin Restricted function temporarily 1");
970         uint256 reward = earned(msg.sender);
971         if (reward > 0) {
972             rewards[msg.sender] = 0;
973             rewardToken.safeTransfer(msg.sender, reward);
974             emit RewardPaid(msg.sender, reward);
975         }
976     }
977     
978     function getReward1() public updateReward1(msg.sender) noContract(msg.sender) {
979         require(reward1Breaker == false, "Admin Restricted function temporarily 2");
980         uint256 reward1 = earned1(msg.sender);
981         if (reward1 > 0) {
982             rewards1[msg.sender] = 0;
983             rewardToken1.safeTransfer(msg.sender, reward1);
984             emit RewardPaid(msg.sender, reward1);
985         }
986     }
987     
988     function setFarmRewards(uint256 reward, uint256 _duration)
989         public
990         onlyRewardDistribution
991         nonReentrant
992         updateReward(address(0))
993     {
994         require(_duration > 0, "Duration must not be 0");
995         if(rewardRate.mul(duration) <= rewardToken.balanceOf(address(this))){
996             duration = _duration.mul(1 days);
997             if (block.timestamp >= periodFinish) {
998                 rewardRate = reward.div(duration);
999             } else {
1000                 uint256 remaining = periodFinish.sub(block.timestamp);
1001                 uint256 leftover = remaining.mul(rewardRate);
1002                 rewardRate = reward.add(leftover).div(duration);
1003             }
1004             lastUpdateTime = block.timestamp;
1005             periodFinish = block.timestamp.add(duration);
1006             //require(rewardRate.mul(duration) <= rewardToken.balanceOf(address(this)), "Insufficient reward");
1007             emit RewardAdded(reward);
1008         }
1009     }
1010     
1011     function setFarmRewards1(uint256 _reward1, uint256 _duration2)
1012         public
1013         onlyRewardDistribution
1014         nonReentrant
1015         updateReward1(address(0))
1016     {
1017         require(_duration2 > 0, "Duration must not be 0");
1018         if(rewardRate1.mul(duration1) <= rewardToken1.balanceOf(address(this))){
1019             duration1 = _duration2.mul(1 days);
1020             if (block.timestamp >= periodFinish1) {
1021                 rewardRate1 = _reward1.div(duration1);
1022             } else {
1023                 uint256 remaining1 = periodFinish1.sub(block.timestamp);
1024                 uint256 leftover1 = remaining1.mul(rewardRate1);
1025                 rewardRate1 = _reward1.add(leftover1).div(duration1);
1026             }
1027             lastUpdateTime1 = block.timestamp;
1028             periodFinish1 = block.timestamp.add(duration1);
1029             //require(rewardRate1.mul(duration1) <= rewardToken1.balanceOf(address(this)), "Insufficient reward");
1030             emit RewardAdded(_reward1);
1031         }
1032     }
1033     
1034     uint256 public aclaimed = 0;
1035     
1036     function DisributeLPTxFunds1() public { // distribute any TX rewards tokens sent to pool for tokens with TX rewards
1037         
1038         
1039         uint256 balanceOfContract = lpToken.balanceOf(address(this));
1040         uint256 transferToAmount = balanceOfContract.sub(_totalSupply.add(aclaimed));
1041         
1042         aclaimed = aclaimed.add(transferToAmount);
1043                    
1044         if(transferToAmount > 0 ){
1045             for (uint256 s = 0; s < farmers.length; s++){
1046                  address abc = farmers[s];
1047                  uint256 blnc = balanceOf(abc);
1048                  if(blnc > 0) {
1049                      uint256 userShare  = (transferToAmount).mul(blnc).div(_totalSupply); 
1050                        
1051                        lpTokenReward[abc] = lpTokenReward[abc].add(userShare);
1052                        
1053                        emit RewardAdded(userShare);
1054                  }
1055            }
1056         }
1057     }
1058     
1059     function ClaimAllRewards() public {
1060         ClaimLPReward();
1061         getReward();
1062         getReward1();
1063         if(perform==true){
1064         DisributeLPTxFunds1();}
1065     }
1066     
1067     
1068     function onePercent(uint256 _tokens) private pure returns (uint256){
1069         uint256 roundValue = _tokens.ceil(100);
1070         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
1071         return onePercentofTokens;
1072     }
1073     
1074     function emergencySaveLostTokens(address _token) external onlyOwner {
1075         require(IERC20(_token).transfer(owner(), IERC20(_token).balanceOf(address(this))), "Error in retrieving tokens");
1076     }
1077     
1078     function ClaimLPReward() public {
1079         address _addy = msg.sender;
1080         
1081         if(lpTokenReward[_addy] > 0 ){
1082             aclaimed = aclaimed.sub(lpTokenReward[_addy]);
1083             
1084             lpToken.safeTransfer(msg.sender, lpTokenReward[_addy]);
1085             lpTokenReward[_addy] = 0;
1086         }
1087     }
1088     
1089     function changePerform(bool _bool) external onlyOwner{
1090         perform = _bool;
1091     }
1092 }
1093 
1094 
1095 contract GoldFarmFaaSForOne is IRewardDistributionRecipient, ReentrancyGuard {
1096     using SafeERC20 for IERC20;
1097     using SafeMath for uint256;
1098     using Address for address;
1099     
1100     IERC20 public rewardToken;//  BSC20
1101     
1102     IERC20 public lpToken; //  BSC20
1103     
1104     address public devAddy = 0xdaC47d05e1aAa9Bd4DA120248E8e0d7480365CFB;//collects pool use fee
1105     uint256 public devtxfee = 1; //Fee for pool use, sent to GOLD farming pool
1106     uint256 public txfee = 0; //Amount of frictionless rewards of the LP token 
1107     
1108     uint256 public duration = 180 days;
1109     bool public perform = true;
1110     
1111     
1112     uint256 public periodFinish = 0;
1113     uint256 public rewardRate = 0;
1114     uint256 public lastUpdateTime;
1115     uint256 public rewardPerTokenStored;
1116     mapping(address => uint256) public userRewardPerTokenPaid;
1117     mapping(address => uint256) public rewards;
1118     
1119     
1120     mapping(address => uint) public farmTime; 
1121     bool public farmBreaker = false; // farm can be lock by admin,, default unlocked type=0
1122     bool public rewardBreaker = false; // getreward can be lock by admin,, default unlocked type=1
1123     bool public withdrawBreaker = false; // withdraw can be lock by admin,, default unlocked type=3
1124     
1125     uint256 private _totalSupply;
1126     mapping(address => uint256) private _balances;
1127     
1128     mapping(address => uint256) public lpTokenReward;
1129 
1130     event RewardAdded(uint256 reward);
1131     event Farmed(address indexed user, uint256 amount);
1132     event Withdrawn(address indexed user, uint256 amount);
1133     event RewardPaid(address indexed user, uint256 reward);
1134     
1135     address[] public farmers;
1136     bool public deployed = false;
1137     
1138     struct USER{
1139         bool initialized;
1140     }
1141     
1142     mapping(address => USER) stakers;
1143     
1144     constructor() { }
1145 
1146     function Initialize(address _lpToken, address _rewardToken, uint256 _duration1, uint256 _lpTokenFrictionlessFee, address _newOwner) external nonReentrant {
1147         rewardToken = IERC20(_rewardToken);
1148         lpToken = IERC20(_lpToken);
1149         setRewardDistributionAdmin(msg.sender);
1150         
1151         transferOwnership(_newOwner);
1152         
1153         duration = _duration1;
1154         
1155         txfee = _lpTokenFrictionlessFee;
1156         
1157         deployed = true;
1158 
1159     }
1160 
1161     modifier updateReward(address account) {
1162         rewardPerTokenStored = rewardPerToken();
1163         lastUpdateTime = lastTimeRewardApplicable();
1164         if (account != address(0)) {
1165             rewards[account] = earned(account);
1166             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1167         }
1168         _;
1169     }
1170     
1171     
1172 
1173     modifier noContract(address account) {
1174         require(Address.isContract(account) == false, "Contracts are not allowed to interact with the farm");
1175         _;
1176     }
1177     
1178     function setdevAddy(address _addy) public onlyOwner {
1179         require(_addy != address(0), " Setting 0 as Addy "); 
1180         devAddy = _addy;
1181     }
1182     
1183     function setBreaker(bool _breaker, uint256 _type) external onlyOwner {
1184         if(_type==0){
1185             farmBreaker =_breaker;
1186             
1187         }
1188         else if(_type==1){
1189             rewardBreaker=_breaker;
1190             
1191         }
1192         else if(_type==3){
1193             withdrawBreaker=_breaker;
1194             
1195         }
1196     }
1197 
1198     function totalSupply() public view returns (uint256) {
1199         return _totalSupply;
1200     }
1201 
1202     function balanceOf(address account) public view returns (uint256) {
1203         return _balances[account];
1204     }
1205     
1206     function recoverLostTokensAfterFarmExpired(IERC20 _token, uint256 amount) external onlyOwner {
1207         // Recover lost tokens can only be used after farming duration expires
1208         require(duration < block.timestamp, "Cannot use if farm is live");
1209         _token.safeTransfer(owner(), amount);
1210     }
1211     
1212     receive() external payable {
1213         // Prevent ETH from being sent to the farming contract
1214         revert();
1215     }
1216 
1217     function lastTimeRewardApplicable() public view returns (uint256) {
1218         return Math.min(block.timestamp, periodFinish);
1219     }
1220     
1221     
1222     function rewardPerToken() public view returns (uint256) {
1223         if (totalSupply() == 0) {
1224             return rewardPerTokenStored;
1225         }
1226 
1227         return
1228             rewardPerTokenStored.add(
1229                 lastTimeRewardApplicable()
1230                     .sub(lastUpdateTime)
1231                     .mul(rewardRate)
1232                     .mul(10** IERC20(rewardToken).decimals())
1233                     .div(totalSupply())
1234             );
1235     }
1236     
1237     
1238     function earned(address account) public view returns (uint256) {
1239         return
1240             balanceOf(account)
1241                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
1242                 .div(10** IERC20(rewardToken).decimals())
1243                 .add(rewards[account]);
1244     }
1245     
1246     
1247     function isStakeholder(address _address)
1248        public
1249        view
1250        returns(bool)
1251    {
1252        
1253        if(stakers[_address].initialized) return true;
1254        else return false;
1255    }
1256    
1257    function addStakeholder(address _stakeholder)
1258        internal
1259    {
1260        (bool _isStakeholder) = isStakeholder(_stakeholder);
1261        if(!_isStakeholder) {
1262            farmTime[msg.sender] =  block.timestamp;
1263            stakers[_stakeholder].initialized = true;
1264 	        farmers.push(_stakeholder);
1265        }
1266    }
1267 
1268     function farm(uint256 amount) external updateReward(msg.sender) noContract(msg.sender) nonReentrant {
1269         require(farmBreaker == false, "Admin Restricted function temporarily");
1270         require(amount > 0, "Cannot farm nothing");
1271 
1272         lpToken.safeTransferFrom(msg.sender, address(this), amount);
1273         
1274         uint256 devtax = amount.mul(devtxfee).div(100);
1275         uint256 _txfee = amount.mul(txfee).div(100);
1276         
1277         lpToken.safeTransfer(address(devAddy), devtax);
1278         
1279         uint256 finalAmount = amount.sub(_txfee).sub(devtax);
1280         
1281         _totalSupply = _totalSupply.add(finalAmount);
1282         _balances[msg.sender] = _balances[msg.sender].add(finalAmount);
1283         
1284         addStakeholder(msg.sender);
1285         
1286         emit Farmed(msg.sender,finalAmount);
1287     }
1288 
1289     function withdraw(uint256 amount) public updateReward(msg.sender) noContract(msg.sender) nonReentrant {
1290         require(withdrawBreaker == false, "Admin Restricted function temporarily");
1291         require(amount > 0, "Cannot withdraw nothing");
1292         
1293         _totalSupply = _totalSupply.sub(amount);
1294         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1295         lpToken.safeTransfer(msg.sender, amount);
1296         
1297         if( _balances[msg.sender] == 0) {
1298             stakers[msg.sender].initialized = false;
1299         }
1300         emit Withdrawn(msg.sender, amount);
1301         
1302     }
1303 
1304     function exit() external {
1305         withdraw(balanceOf(msg.sender));
1306         ClaimLPReward(); 
1307         getReward();
1308         }
1309 
1310     function getReward() public updateReward(msg.sender) noContract(msg.sender) {
1311         require(rewardBreaker == false, "Admin Restricted function temporarily");
1312         uint256 reward = earned(msg.sender);
1313         if (reward > 0) {
1314             rewards[msg.sender] = 0;
1315             rewardToken.safeTransfer(msg.sender, reward);
1316             emit RewardPaid(msg.sender, reward);
1317         }
1318     }
1319     
1320     
1321     function setFarmRewards(uint256 reward, uint256 _duration)
1322         public
1323         onlyRewardDistribution
1324         nonReentrant
1325         updateReward(address(0))
1326     {
1327         require(_duration > 0, "Duration must not be 0");
1328         if(rewardRate.mul(duration) <= rewardToken.balanceOf(address(this))){
1329             duration = _duration.mul(1 days);
1330             if (block.timestamp >= periodFinish) {
1331                 rewardRate = reward.div(duration);
1332             } else {
1333                 uint256 remaining = periodFinish.sub(block.timestamp);
1334                 uint256 leftover = remaining.mul(rewardRate);
1335                 rewardRate = reward.add(leftover).div(duration);
1336             }
1337             lastUpdateTime = block.timestamp;
1338             periodFinish = block.timestamp.add(duration);
1339             //require(rewardRate.mul(duration) <= rewardToken.balanceOf(address(this)), "Insufficient reward");
1340             emit RewardAdded(reward);
1341         }
1342     }
1343     
1344     
1345     
1346     uint256 public aclaimed = 0;
1347     
1348     function DisributeLPTxFunds1() public { // distribute any TX rewards tokens sent to pool for tokens with TX rewards
1349         
1350         
1351         uint256 balanceOfContract = lpToken.balanceOf(address(this));
1352         uint256 transferToAmount = balanceOfContract.sub(_totalSupply.add(aclaimed));
1353         
1354         aclaimed = aclaimed.add(transferToAmount);
1355                    
1356         if(transferToAmount > 0 ){
1357             for (uint256 s = 0; s < farmers.length; s++){
1358                  address abc = farmers[s];
1359                  uint256 blnc = balanceOf(abc);
1360                  if(blnc > 0) {
1361                      uint256 userShare  = (transferToAmount).mul(blnc).div(_totalSupply); 
1362                        
1363                        lpTokenReward[abc] = lpTokenReward[abc].add(userShare);
1364                        
1365                        emit RewardAdded(userShare);
1366                  }
1367            }
1368         }
1369     }
1370     
1371     function ClaimAllRewards() public {
1372         ClaimLPReward();
1373         getReward();
1374         if(perform==true){
1375         DisributeLPTxFunds1();}
1376     }
1377     
1378     
1379     function onePercent(uint256 _tokens) private pure returns (uint256){
1380         uint256 roundValue = _tokens.ceil(100);
1381         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
1382         return onePercentofTokens;
1383     }
1384     
1385     function emergencySaveLostTokens(address _token) external onlyOwner {
1386         require(IERC20(_token).transfer(owner(), IERC20(_token).balanceOf(address(this))), "Error in retrieving tokens");
1387     }
1388     
1389     function ClaimLPReward() public {
1390         address _addy = msg.sender;
1391         
1392         if(lpTokenReward[_addy] > 0 ){
1393             aclaimed = aclaimed.sub(lpTokenReward[_addy]);
1394             
1395             lpToken.safeTransfer(msg.sender, lpTokenReward[_addy]);
1396             lpTokenReward[_addy] = 0;
1397         }
1398     }
1399     
1400     function changePerform(bool _bool) external onlyOwner{
1401         perform = _bool;
1402     }
1403 }