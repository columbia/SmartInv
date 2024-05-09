1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
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
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, 'SafeMath: addition overflow');
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, 'SafeMath: subtraction overflow');
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(
61         uint256 a,
62         uint256 b,
63         string memory errorMessage
64     ) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, 'SafeMath: multiplication overflow');
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, 'SafeMath: division by zero');
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         return mod(a, b, 'SafeMath: modulo by zero');
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts with custom message when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function mod(
164         uint256 a,
165         uint256 b,
166         string memory errorMessage
167     ) internal pure returns (uint256) {
168         require(b != 0, errorMessage);
169         return a % b;
170     }
171 
172     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
173         z = x < y ? x : y;
174     }
175 
176     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
177     function sqrt(uint256 y) internal pure returns (uint256 z) {
178         if (y > 3) {
179             z = y;
180             uint256 x = y / 2 + 1;
181             while (x < z) {
182                 z = x;
183                 x = (y / x + x) / 2;
184             }
185         } else if (y != 0) {
186             z = 1;
187         }
188     }
189 }
190 
191 
192 interface IERC20 {
193     /**
194      * @dev Returns the amount of tokens in existence.
195      */
196     function totalSupply() external view returns (uint256);
197 
198     /**
199      * @dev Returns the token decimals.
200      */
201     function decimals() external view returns (uint8);
202 
203     /**
204      * @dev Returns the token symbol.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token name.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the bep token owner.
215      */
216     function getOwner() external view returns (address);
217 
218     /**
219      * @dev Returns the amount of tokens owned by `account`.
220      */
221     function balanceOf(address account) external view returns (uint256);
222 
223     /**
224      * @dev Moves `amount` tokens from the caller's account to `recipient`.
225      *
226      * Returns a boolean value indicating whether the operation succeeded.
227      *
228      * Emits a {Transfer} event.
229      */
230     function transfer(address recipient, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Returns the remaining number of tokens that `spender` will be
234      * allowed to spend on behalf of `owner` through {transferFrom}. This is
235      * zero by default.
236      *
237      * This value changes when {approve} or {transferFrom} are called.
238      */
239     function allowance(address _owner, address spender) external view returns (uint256);
240 
241     /**
242      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * IMPORTANT: Beware that changing an allowance with this method brings the risk
247      * that someone may use both the old and the new allowance by unfortunate
248      * transaction ordering. One possible solution to mitigate this race
249      * condition is to first reduce the spender's allowance to 0 and set the
250      * desired value afterwards:
251      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252      *
253      * Emits an {Approval} event.
254      */
255     function approve(address spender, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Moves `amount` tokens from `sender` to `recipient` using the
259      * allowance mechanism. `amount` is then deducted from the caller's
260      * allowance.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transferFrom(
267         address sender,
268         address recipient,
269         uint256 amount
270     ) external returns (bool);
271 
272     /**
273      * @dev Emitted when `value` tokens are moved from one account (`from`) to
274      * another (`to`).
275      *
276      * Note that `value` may be zero.
277      */
278     event Transfer(address indexed from, address indexed to, uint256 value);
279 
280     /**
281      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
282      * a call to {approve}. `value` is the new allowance.
283      */
284     event Approval(address indexed owner, address indexed spender, uint256 value);
285 }
286 
287 
288 /**
289  * @dev Collection of functions related to the address type
290  */
291 library Address {
292     /**
293      * @dev Returns true if `account` is a contract.
294      *
295      * [IMPORTANT]
296      * ====
297      * It is unsafe to assume that an address for which this function returns
298      * false is an externally-owned account (EOA) and not a contract.
299      *
300      * Among others, `isContract` will return false for the following
301      * types of addresses:
302      *
303      *  - an externally-owned account
304      *  - a contract in construction
305      *  - an address where a contract will be created
306      *  - an address where a contract lived, but was destroyed
307      * ====
308      */
309     function isContract(address account) internal view returns (bool) {
310         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
311         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
312         // for accounts without code, i.e. `keccak256('')`
313         bytes32 codehash;
314         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
315         // solhint-disable-next-line no-inline-assembly
316         assembly {
317             codehash := extcodehash(account)
318         }
319         return (codehash != accountHash && codehash != 0x0);
320     }
321 
322     /**
323      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
324      * `recipient`, forwarding all available gas and reverting on errors.
325      *
326      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
327      * of certain opcodes, possibly making contracts go over the 2300 gas limit
328      * imposed by `transfer`, making them unable to receive funds via
329      * `transfer`. {sendValue} removes this limitation.
330      *
331      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
332      *
333      * IMPORTANT: because control is transferred to `recipient`, care must be
334      * taken to not create reentrancy vulnerabilities. Consider using
335      * {ReentrancyGuard} or the
336      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
337      */
338     function sendValue(address payable recipient, uint256 amount) internal {
339         require(address(this).balance >= amount, 'Address: insufficient balance');
340 
341         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
342         (bool success, ) = recipient.call{value: amount}('');
343         require(success, 'Address: unable to send value, recipient may have reverted');
344     }
345 
346     /**
347      * @dev Performs a Solidity function call using a low level `call`. A
348      * plain`call` is an unsafe replacement for a function call: use this
349      * function instead.
350      *
351      * If `target` reverts with a revert reason, it is bubbled up by this
352      * function (like regular Solidity function calls).
353      *
354      * Returns the raw returned data. To convert to the expected return value,
355      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
356      *
357      * Requirements:
358      *
359      * - `target` must be a contract.
360      * - calling `target` with `data` must not revert.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
365         return functionCall(target, data, 'Address: low-level call failed');
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
370      * `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         return _functionCallWithValue(target, data, 0, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but also transferring `value` wei to `target`.
385      *
386      * Requirements:
387      *
388      * - the calling contract must have an ETH balance of at least `value`.
389      * - the called Solidity function must be `payable`.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value
397     ) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
403      * with `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(
408         address target,
409         bytes memory data,
410         uint256 value,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(address(this).balance >= value, 'Address: insufficient balance for call');
414         return _functionCallWithValue(target, data, value, errorMessage);
415     }
416 
417     function _functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 weiValue,
421         string memory errorMessage
422     ) private returns (bytes memory) {
423         require(isContract(target), 'Address: call to non-contract');
424 
425         // solhint-disable-next-line avoid-low-level-calls
426         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
427         if (success) {
428             return returndata;
429         } else {
430             // Look for revert reason and bubble it up if present
431             if (returndata.length > 0) {
432                 // The easiest way to bubble the revert reason is using memory via assembly
433 
434                 // solhint-disable-next-line no-inline-assembly
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 
447 /**
448  * @title SafeERC20
449  * @dev Wrappers around ERC20 operations that throw on failure (when the token
450  * contract returns false). Tokens that return no value (and instead revert or
451  * throw on failure) are also supported, non-reverting calls are assumed to be
452  * successful.
453  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
454  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
455  */
456 library SafeERC20 {
457     using SafeMath for uint256;
458     using Address for address;
459 
460     function safeTransfer(
461         IERC20 token,
462         address to,
463         uint256 value
464     ) internal {
465         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
466     }
467 
468     function safeTransferFrom(
469         IERC20 token,
470         address from,
471         address to,
472         uint256 value
473     ) internal {
474         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
475     }
476 
477     /**
478      * @dev Deprecated. This function has issues similar to the ones found in
479      * {IERC20-approve}, and its usage is discouraged.
480      *
481      * Whenever possible, use {safeIncreaseAllowance} and
482      * {safeDecreaseAllowance} instead.
483      */
484     function safeApprove(
485         IERC20 token,
486         address spender,
487         uint256 value
488     ) internal {
489         // safeApprove should only be called when setting an initial allowance,
490         // or when resetting it to zero. To increase and decrease it, use
491         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
492         // solhint-disable-next-line max-line-length
493         require(
494             (value == 0) || (token.allowance(address(this), spender) == 0),
495             'SafeERC20: approve from non-zero to non-zero allowance'
496         );
497         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
498     }
499 
500     function safeIncreaseAllowance(
501         IERC20 token,
502         address spender,
503         uint256 value
504     ) internal {
505         uint256 newAllowance = token.allowance(address(this), spender).add(value);
506         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
507     }
508 
509     function safeDecreaseAllowance(
510         IERC20 token,
511         address spender,
512         uint256 value
513     ) internal {
514         uint256 newAllowance = token.allowance(address(this), spender).sub(
515             value,
516             'SafeERC20: decreased allowance below zero'
517         );
518         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
519     }
520 
521     /**
522      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
523      * on the return value: the return value is optional (but if data is returned, it must not be false).
524      * @param token The token targeted by the call.
525      * @param data The call data (encoded using abi.encode or one of its variants).
526      */
527     function _callOptionalReturn(IERC20 token, bytes memory data) private {
528         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
529         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
530         // the target address contains contract code and also asserts for success in the low-level call.
531 
532         bytes memory returndata = address(token).functionCall(data, 'SafeERC20: low-level call failed');
533         if (returndata.length > 0) {
534             // Return data is optional
535             // solhint-disable-next-line max-line-length
536             require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
537         }
538     }
539 }
540 
541 
542 /**
543  * @dev Contract module that helps prevent reentrant calls to a function.
544  *
545  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
546  * available, which can be applied to functions to make sure there are no nested
547  * (reentrant) calls to them.
548  *
549  * Note that because there is a single `nonReentrant` guard, functions marked as
550  * `nonReentrant` may not call one another. This can be worked around by making
551  * those functions `private`, and then adding `external` `nonReentrant` entry
552  * points to them.
553  *
554  * TIP: If you would like to learn more about reentrancy and alternative ways
555  * to protect against it, check out our blog post
556  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
557  */
558 contract ReentrancyGuard {
559     // Booleans are more expensive than uint256 or any type that takes up a full
560     // word because each write operation emits an extra SLOAD to first read the
561     // slot's contents, replace the bits taken up by the boolean, and then write
562     // back. This is the compiler's defense against contract upgrades and
563     // pointer aliasing, and it cannot be disabled.
564 
565     // The values being non-zero value makes deployment a bit more expensive,
566     // but in exchange the refund on every call to nonReentrant will be lower in
567     // amount. Since refunds are capped to a percentage of the total
568     // transaction's gas, it is best to keep them low in cases like this one, to
569     // increase the likelihood of the full refund coming into effect.
570     uint256 private constant _NOT_ENTERED = 1;
571     uint256 private constant _ENTERED = 2;
572 
573     uint256 private _status;
574 
575     constructor () internal {
576         _status = _NOT_ENTERED;
577     }
578 
579     /**
580      * @dev Prevents a contract from calling itself, directly or indirectly.
581      * Calling a `nonReentrant` function from another `nonReentrant`
582      * function is not supported. It is possible to prevent this from happening
583      * by making the `nonReentrant` function external, and make it call a
584      * `private` function that does the actual work.
585      */
586     modifier nonReentrant() {
587         // On the first call to nonReentrant, _notEntered will be true
588         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
589 
590         // Any calls to nonReentrant after this point will fail
591         _status = _ENTERED;
592 
593         _;
594 
595         // By storing the original value once again, a refund is triggered (see
596         // https://eips.ethereum.org/EIPS/eip-2200)
597         _status = _NOT_ENTERED;
598     }
599 }
600 
601 
602 contract EdoLaunchpad is ReentrancyGuard {
603   using SafeMath for uint256;
604   using SafeERC20 for IERC20;
605 
606   // Info of each user.
607   struct UserInfo {
608       uint256 amount;   // How many tokens the user has provided.
609       bool claimed;  // default false
610   }
611 
612   // admin address
613   address public adminAddress;
614   // The raising token
615   IERC20 public lpToken;
616   // The offering token
617   IERC20 public offeringToken;
618   // The block number when IDO starts
619   uint256 public startTime;
620   // The block number when IDO ends
621   uint256 public endTime;
622   // total amount of raising tokens need to be raised
623   uint256 public raisingAmount;
624   // total amount of offeringToken that will offer
625   uint256 public offeringAmount;
626   // total amount of raising tokens that have already raised
627   uint256 public totalAmount;
628   // address => amount
629   mapping (address => UserInfo) public userInfo;
630   // participators
631   address[] public addressList;
632   // if true, liquidity is created
633   bool public liquidityIsCreated;
634   // max deposit amount for per wallet
635   uint256 public depositLimitPerWallet;
636   // whtielist data
637   mapping(address => bool) private _whiteList;
638   bool public isFCFS = false;
639   bool public isPrivateSale = false;
640 
641 
642   event Deposit(address indexed user, uint256 amount);
643   event Harvest(address indexed user, uint256 offeringAmount, uint256 excessAmount);
644 
645   constructor(
646       IERC20 _lpToken,
647       IERC20 _offeringToken,
648       uint256 _startTime,
649       uint256 _endTime,
650       uint256 _offeringAmount,
651       uint256 _raisingAmount,
652       uint256 _depositLimitPerWallet,
653       address _adminAddress,
654       bool _isFCFS,
655       bool _isPrivateSale
656   ) public {
657       lpToken = _lpToken;
658       offeringToken = _offeringToken;
659       startTime = _startTime;
660       endTime = _endTime;
661       offeringAmount = _offeringAmount;
662       raisingAmount= _raisingAmount;
663       totalAmount = 0;
664       depositLimitPerWallet = _depositLimitPerWallet;
665       adminAddress = _adminAddress;
666       isFCFS = _isFCFS;
667       isPrivateSale = _isPrivateSale;
668   }
669 
670   modifier onlyAdmin() {
671     require(msg.sender == adminAddress, "admin: wut?");
672     _;
673   }
674 
675   function setOfferingAmount(uint256 _offerAmount) public onlyAdmin {
676     require (block.timestamp < startTime, 'no');
677     offeringAmount = _offerAmount;
678   }
679 
680   function setRaisingAmount(uint256 _raisingAmount) public onlyAdmin {
681     require (block.timestamp < startTime, 'no');
682     raisingAmount= _raisingAmount;
683   }
684 
685   function setDepositLimitPerWallet(uint256 _depositLimitPerWallet) public onlyAdmin {
686     require (block.timestamp < startTime, 'no');
687     depositLimitPerWallet= _depositLimitPerWallet;
688   }
689 
690   function deposit(uint256 _amount) public {
691     require (block.timestamp > startTime && block.timestamp < endTime, 'not ido time');
692     require (_amount > 0, 'need _amount > 0');
693     require (isPrivateSale == false || isWhitelisted(msg.sender), 'not whitelisted');
694 
695     lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
696     if (userInfo[msg.sender].amount == 0) {
697       addressList.push(address(msg.sender));
698     }
699     userInfo[msg.sender].amount = userInfo[msg.sender].amount.add(_amount);
700     if (depositLimitPerWallet > 0) {
701       require (userInfo[msg.sender].amount <= depositLimitPerWallet, 'exceeded max deposit amount');
702     }
703     totalAmount = totalAmount.add(_amount);
704     if ((isFCFS == true) && (totalAmount >= raisingAmount)) {
705         endTime = block.timestamp;
706     }
707     emit Deposit(msg.sender, _amount);
708   }
709 
710   function harvest() public nonReentrant {
711     require (block.timestamp > endTime, 'not harvest time');
712     require (userInfo[msg.sender].amount > 0, 'have you participated?');
713     require (!userInfo[msg.sender].claimed, 'nothing to harvest');
714     require (liquidityIsCreated, "liquidity not created");
715     uint256 offeringTokenAmount = getOfferingAmount(msg.sender);
716     uint256 refundingTokenAmount = getRefundingAmount(msg.sender);
717     offeringToken.safeTransfer(address(msg.sender), offeringTokenAmount);
718     if (refundingTokenAmount > 0) {
719       lpToken.safeTransfer(address(msg.sender), refundingTokenAmount);
720     }
721     userInfo[msg.sender].claimed = true;
722     emit Harvest(msg.sender, offeringTokenAmount, refundingTokenAmount);
723   }
724 
725   function hasHarvest(address _user) external view returns(bool) {
726       return userInfo[_user].claimed;
727   }
728 
729   // allocation 100000 means 0.1(10%), 1 meanss 0.000001(0.0001%), 1000000 means 1(100%)
730   function getUserAllocation(address _user) public view returns(uint256) {
731     return userInfo[_user].amount.mul(1e12).div(totalAmount).div(1e6);
732   }
733 
734   // get the amount of IDO token you will get
735   function getOfferingAmount(address _user) public view returns(uint256) {
736     if (totalAmount > raisingAmount) {
737       uint256 allocation = getUserAllocation(_user);
738       return offeringAmount.mul(allocation).div(1e6);
739     }
740     else {
741       // userInfo[_user] / (raisingAmount / offeringAmount)
742       return userInfo[_user].amount.mul(offeringAmount).div(raisingAmount);
743     }
744   }
745 
746   // get the amount of lp token you will be refunded
747   function getRefundingAmount(address _user) public view returns(uint256) {
748     if (totalAmount <= raisingAmount) {
749       return 0;
750     }
751     uint256 allocation = getUserAllocation(_user);
752     uint256 payAmount = raisingAmount.mul(allocation).div(1e6);
753     return userInfo[_user].amount.sub(payAmount);
754   }
755 
756   function isWhitelisted(address account) public view returns (bool) {
757     return _whiteList[account];
758   }
759 
760   function getAddressListLength() external view returns(uint256) {
761     return addressList.length;
762   }
763 
764   function includeToWhiteList(address[] memory _users) public onlyAdmin {
765     for (uint8 i = 0; i < _users.length; i++) {
766         _whiteList[_users[i]] = true;
767     }
768   }
769 
770   function finalWithdraw(uint256 _lpAmount, uint256 _offerAmount) public onlyAdmin {
771     require (_lpAmount <= lpToken.balanceOf(address(this)), 'not enough token 0');
772     require (_offerAmount <= offeringToken.balanceOf(address(this)), 'not enough token 1');
773     lpToken.safeTransfer(address(msg.sender), _lpAmount);
774     offeringToken.safeTransfer(address(msg.sender), _offerAmount);
775   }
776 
777   function setLiquidityIsCreated(bool _liquidityIsCreated) public onlyAdmin {
778     liquidityIsCreated = _liquidityIsCreated;
779   }
780 }