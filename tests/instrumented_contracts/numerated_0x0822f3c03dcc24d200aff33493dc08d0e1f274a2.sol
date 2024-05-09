1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-20
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.7.5;
7 
8 library SafeMath {
9     /**
10      * @dev Returns the addition of two unsigned integers, reverting on
11      * overflow.
12      *
13      * Counterpart to Solidity's `+` operator.
14      *
15      * Requirements:
16      *
17      * - Addition cannot overflow.
18      */
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25 
26     /**
27      * @dev Returns the subtraction of two unsigned integers, reverting on
28      * overflow (when the result is negative).
29      *
30      * Counterpart to Solidity's `-` operator.
31      *
32      * Requirements:
33      *
34      * - Subtraction cannot overflow.
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `*` operator.
62      *
63      * Requirements:
64      *
65      * - Multiplication cannot overflow.
66      */
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69         // benefit is lost if 'b' is also tested.
70         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
71         if (a == 0) {
72             return 0;
73         }
74 
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the integer division of two unsigned integers. Reverts on
83      * division by zero. The result is rounded towards zero.
84      *
85      * Counterpart to Solidity's `/` operator. Note: this function uses a
86      * `revert` opcode (which leaves remaining gas untouched) while Solidity
87      * uses an invalid opcode to revert (consuming all remaining gas).
88      *
89      * Requirements:
90      *
91      * - The divisor cannot be zero.
92      */
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         return div(a, b, "SafeMath: division by zero");
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      *
107      * - The divisor cannot be zero.
108      */
109     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
119      * Reverts when dividing by zero.
120      *
121      * Counterpart to Solidity's `%` operator. This function uses a `revert`
122      * opcode (which leaves remaining gas untouched) while Solidity uses an
123      * invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         return mod(a, b, "SafeMath: modulo by zero");
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
135      * Reverts with custom message when dividing by zero.
136      *
137      * Counterpart to Solidity's `%` operator. This function uses a `revert`
138      * opcode (which leaves remaining gas untouched) while Solidity uses an
139      * invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b != 0, errorMessage);
147         return a % b;
148     }
149 
150     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
151     function sqrrt(uint256 a) internal pure returns (uint c) {
152         if (a > 3) {
153             c = a;
154             uint b = add( div( a, 2), 1 );
155             while (b < c) {
156                 c = b;
157                 b = div( add( div( a, b ), b), 2 );
158             }
159         } else if (a != 0) {
160             c = 1;
161         }
162     }
163 
164     /*
165      * Expects percentage to be trailed by 00,
166     */
167     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
168         return div( mul( total_, percentage_ ), 1000 );
169     }
170 
171     /*
172      * Expects percentage to be trailed by 00,
173     */
174     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
175         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
176     }
177 
178     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
179         return div( mul(part_, 100) , total_ );
180     }
181 
182     /**
183      * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol
184      * @dev Returns the average of two numbers. The result is rounded towards
185      * zero.
186      */
187     function average(uint256 a, uint256 b) internal pure returns (uint256) {
188         // (a + b) / 2 can overflow, so we distribute
189         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
190     }
191 
192     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
193         return sqrrt( mul( multiplier_, payment_ ) );
194     }
195 
196   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
197       return mul( multiplier_, supply_ );
198   }
199 }
200 
201 interface IOwnable {
202 
203   function owner() external view returns (address);
204 
205   function renounceOwnership() external;
206   
207   function transferOwnership( address newOwner_ ) external;
208 }
209 
210 contract Ownable is IOwnable {
211     
212   address internal _owner;
213 
214   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
215 
216   /**
217    * @dev Initializes the contract setting the deployer as the initial owner.
218    */
219   constructor () {
220     _owner = msg.sender;
221     emit OwnershipTransferred( address(0), _owner );
222   }
223 
224   /**
225    * @dev Returns the address of the current owner.
226    */
227   function owner() public view override returns (address) {
228     return _owner;
229   }
230 
231   /**
232    * @dev Throws if called by any account other than the owner.
233    */
234   modifier onlyOwner() {
235     require( _owner == msg.sender, "Ownable: caller is not the owner" );
236     _;
237   }
238 
239   /**
240    * @dev Leaves the contract without owner. It will not be possible to call
241    * `onlyOwner` functions anymore. Can only be called by the current owner.
242    *
243    * NOTE: Renouncing ownership will leave the contract without an owner,
244    * thereby removing any functionality that is only available to the owner.
245    */
246   function renounceOwnership() public virtual override onlyOwner() {
247     emit OwnershipTransferred( _owner, address(0) );
248     _owner = address(0);
249   }
250 
251   /**
252    * @dev Transfers ownership of the contract to a new account (`newOwner`).
253    * Can only be called by the current owner.
254    */
255   function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {
256     require( newOwner_ != address(0), "Ownable: new owner is the zero address");
257     emit OwnershipTransferred( _owner, newOwner_ );
258     _owner = newOwner_;
259   }
260 }
261 
262 interface IStaking {
263 
264     function initialize(
265         address olyTokenAddress_,
266         address sOLY_,
267         address dai_
268     ) external;
269 
270     //function stakeOLY(uint amountToStake_) external {
271     function stakeOLYWithPermit (
272         uint256 amountToStake_,
273         uint256 deadline_,
274         uint8 v_,
275         bytes32 r_,
276         bytes32 s_
277     ) external;
278 
279     //function unstakeOLY( uint amountToWithdraw_) external {
280     function unstakeOLYWithPermit (
281         uint256 amountToWithdraw_,
282         uint256 deadline_,
283         uint8 v_,
284         bytes32 r_,
285         bytes32 s_
286     ) external;
287 
288     function stakeOLY( uint amountToStake_ ) external returns ( bool );
289 
290     function unstakeOLY( uint amountToWithdraw_ ) external returns ( bool );
291 
292     function distributeOLYProfits() external;
293 }
294 
295 interface IERC20 {
296   /**
297    * @dev Returns the amount of tokens in existence.
298    */
299   function totalSupply() external view returns (uint256);
300 
301   /**
302    * @dev Returns the amount of tokens owned by `account`.
303    */
304   function balanceOf(address account) external view returns (uint256);
305 
306   /**
307    * @dev Moves `amount` tokens from the caller's account to `recipient`.
308    *
309    * Returns a boolean value indicating whether the operation succeeded.
310    *
311    * Emits a {Transfer} event.
312    */
313   function transfer(address recipient, uint256 amount) external returns (bool);
314 
315   /**
316    * @dev Returns the remaining number of tokens that `spender` will be
317    * allowed to spend on behalf of `owner` through {transferFrom}. This is
318    * zero by default.
319    *
320    * This value changes when {approve} or {transferFrom} are called.
321    */
322   function allowance(address owner, address spender) external view returns (uint256);
323 
324   /**
325    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
326    *
327    * Returns a boolean value indicating whether the operation succeeded.
328    *
329    * IMPORTANT: Beware that changing an allowance with this method brings the risk
330    * that someone may use both the old and the new allowance by unfortunate
331    * transaction ordering. One possible solution to mitigate this race
332    * condition is to first reduce the spender's allowance to 0 and set the
333    * desired value afterwards:
334    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
335    *
336    * Emits an {Approval} event.
337    */
338   function approve(address spender, uint256 amount) external returns (bool);
339 
340   /**
341    * @dev Moves `amount` tokens from `sender` to `recipient` using the
342    * allowance mechanism. `amount` is then deducted from the caller's
343    * allowance.
344    *
345    * Returns a boolean value indicating whether the operation succeeded.
346    *
347    * Emits a {Transfer} event.
348    */
349   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
350 
351   /**
352    * @dev Emitted when `value` tokens are moved from one account (`from`) to
353    * another (`to`).
354    *
355    * Note that `value` may be zero.
356    */
357   event Transfer(address indexed from, address indexed to, uint256 value);
358 
359   /**
360    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
361    * a call to {approve}. `value` is the new allowance.
362    */
363   event Approval(address indexed owner, address indexed spender, uint256 value);
364 }
365 
366 library Address {
367     /**
368      * @dev Returns true if `account` is a contract.
369      *
370      * [IMPORTANT]
371      * ====
372      * It is unsafe to assume that an address for which this function returns
373      * false is an externally-owned account (EOA) and not a contract.
374      *
375      * Among others, `isContract` will return false for the following
376      * types of addresses:
377      *
378      *  - an externally-owned account
379      *  - a contract in construction
380      *  - an address where a contract will be created
381      *  - an address where a contract lived, but was destroyed
382      * ====
383      */
384     function isContract(address account) internal view returns (bool) {
385         // This method relies in extcodesize, which returns 0 for contracts in
386         // construction, since the code is only stored at the end of the
387         // constructor execution.
388 
389         uint256 size;
390         // solhint-disable-next-line no-inline-assembly
391         assembly { size := extcodesize(account) }
392         return size > 0;
393     }
394 
395     /**
396      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
397      * `recipient`, forwarding all available gas and reverting on errors.
398      *
399      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
400      * of certain opcodes, possibly making contracts go over the 2300 gas limit
401      * imposed by `transfer`, making them unable to receive funds via
402      * `transfer`. {sendValue} removes this limitation.
403      *
404      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
405      *
406      * IMPORTANT: because control is transferred to `recipient`, care must be
407      * taken to not create reentrancy vulnerabilities. Consider using
408      * {ReentrancyGuard} or the
409      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
410      */
411     function sendValue(address payable recipient, uint256 amount) internal {
412         require(address(this).balance >= amount, "Address: insufficient balance");
413 
414         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
415         (bool success, ) = recipient.call{ value: amount }("");
416         require(success, "Address: unable to send value, recipient may have reverted");
417     }
418 
419     /**
420      * @dev Performs a Solidity function call using a low level `call`. A
421      * plain`call` is an unsafe replacement for a function call: use this
422      * function instead.
423      *
424      * If `target` reverts with a revert reason, it is bubbled up by this
425      * function (like regular Solidity function calls).
426      *
427      * Returns the raw returned data. To convert to the expected return value,
428      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
429      *
430      * Requirements:
431      *
432      * - `target` must be a contract.
433      * - calling `target` with `data` must not revert.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
438       return functionCall(target, data, "Address: low-level call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
443      * `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
448         return _functionCallWithValue(target, data, 0, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but also transferring `value` wei to `target`.
454      *
455      * Requirements:
456      *
457      * - the calling contract must have an ETH balance of at least `value`.
458      * - the called Solidity function must be `payable`.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
463         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
468      * with `errorMessage` as a fallback revert reason when `target` reverts.
469      *
470      * _Available since v3.1._
471      */
472     // function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
473     //     require(address(this).balance >= value, "Address: insufficient balance for call");
474     //     return _functionCallWithValue(target, data, value, errorMessage);
475     // }
476     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
477         require(address(this).balance >= value, "Address: insufficient balance for call");
478         require(isContract(target), "Address: call to non-contract");
479 
480         // solhint-disable-next-line avoid-low-level-calls
481         (bool success, bytes memory returndata) = target.call{ value: value }(data);
482         return _verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
486         require(isContract(target), "Address: call to non-contract");
487 
488         // solhint-disable-next-line avoid-low-level-calls
489         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 // solhint-disable-next-line no-inline-assembly
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 
508   /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
510      * but performing a static call.
511      *
512      * _Available since v3.3._
513      */
514     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
515         return functionStaticCall(target, data, "Address: low-level static call failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
520      * but performing a static call.
521      *
522      * _Available since v3.3._
523      */
524     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
525         require(isContract(target), "Address: static call to non-contract");
526 
527         // solhint-disable-next-line avoid-low-level-calls
528         (bool success, bytes memory returndata) = target.staticcall(data);
529         return _verifyCallResult(success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but performing a delegate call.
535      *
536      * _Available since v3.3._
537      */
538     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
539         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
544      * but performing a delegate call.
545      *
546      * _Available since v3.3._
547      */
548     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
549         require(isContract(target), "Address: delegate call to non-contract");
550 
551         // solhint-disable-next-line avoid-low-level-calls
552         (bool success, bytes memory returndata) = target.delegatecall(data);
553         return _verifyCallResult(success, returndata, errorMessage);
554     }
555 
556     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
557         if (success) {
558             return returndata;
559         } else {
560             // Look for revert reason and bubble it up if present
561             if (returndata.length > 0) {
562                 // The easiest way to bubble the revert reason is using memory via assembly
563 
564                 // solhint-disable-next-line no-inline-assembly
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 
575     function addressToString(address _address) internal pure returns(string memory) {
576         bytes32 _bytes = bytes32(uint256(_address));
577         bytes memory HEX = "0123456789abcdef";
578         bytes memory _addr = new bytes(42);
579 
580         _addr[0] = '0';
581         _addr[1] = 'x';
582 
583         for(uint256 i = 0; i < 20; i++) {
584             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
585             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
586         }
587 
588         return string(_addr);
589 
590     }
591 }
592 
593 library SafeERC20 {
594     using SafeMath for uint256;
595     using Address for address;
596 
597     function safeTransfer(IERC20 token, address to, uint256 value) internal {
598         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
599     }
600 
601     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
602         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
603     }
604 
605     /**
606      * @dev Deprecated. This function has issues similar to the ones found in
607      * {IERC20-approve}, and its usage is discouraged.
608      *
609      * Whenever possible, use {safeIncreaseAllowance} and
610      * {safeDecreaseAllowance} instead.
611      */
612     function safeApprove(IERC20 token, address spender, uint256 value) internal {
613         // safeApprove should only be called when setting an initial allowance,
614         // or when resetting it to zero. To increase and decrease it, use
615         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
616         // solhint-disable-next-line max-line-length
617         require((value == 0) || (token.allowance(address(this), spender) == 0),
618             "SafeERC20: approve from non-zero to non-zero allowance"
619         );
620         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
621     }
622 
623     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
624         uint256 newAllowance = token.allowance(address(this), spender).add(value);
625         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
626     }
627 
628     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
629         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
630         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
631     }
632 
633     /**
634      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
635      * on the return value: the return value is optional (but if data is returned, it must not be false).
636      * @param token The token targeted by the call.
637      * @param data The call data (encoded using abi.encode or one of its variants).
638      */
639     function _callOptionalReturn(IERC20 token, bytes memory data) private {
640         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
641         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
642         // the target address contains contract code and also asserts for success in the low-level call.
643 
644         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
645         if (returndata.length > 0) { // Return data is optional
646             // solhint-disable-next-line max-line-length
647             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
648         }
649     }
650 }
651 interface ITreasury {
652 
653   function getBondingCalculator() external returns ( address );
654   function payDebt( address depositor_ ) external returns ( bool );
655   function getTimelockEndBlock() external returns ( uint );
656   function getManagedToken() external returns ( address );
657   function getDebtAmountDue() external returns ( uint );
658   function incurDebt( address principleToken_, uint principieTokenAmountDeposited_ ) external returns ( bool );
659 }
660 
661 interface IOHMandsOHM {
662     function rebase(uint256 ohmProfit)
663         external
664         returns (uint256);
665 
666     function circulatingSupply() external view returns (uint256);
667 
668     function balanceOf(address who) external view returns (uint256);
669 
670     function permit(
671         address owner,
672         address spender,
673         uint256 amount,
674         uint256 deadline,
675         uint8 v,
676         bytes32 r,
677         bytes32 s
678     ) external;
679 }
680 
681 contract OlympusStaking is Ownable {
682 
683   using SafeMath for uint256;
684   using SafeERC20 for IERC20;
685 
686   uint256 public epochLengthInBlocks;
687 
688   address public ohm;
689   address public sOHM;
690   uint256 public ohmToDistributeNextEpoch;
691 
692   uint256 nextEpochBlock;
693 
694   bool isInitialized;
695 
696   modifier notInitialized() {
697     require( !isInitialized );
698     _;
699   }
700 
701   function initialize(
702         address ohmTokenAddress_,
703         address sOHM_,
704         uint8 epochLengthInBlocks_
705     ) external onlyOwner() notInitialized() {
706         ohm = ohmTokenAddress_;
707         sOHM = sOHM_;
708         epochLengthInBlocks = epochLengthInBlocks_;
709         isInitialized = true;
710     }
711 
712   function setEpochLengthintBlock( uint256 newEpochLengthInBlocks_ ) external onlyOwner() {
713     epochLengthInBlocks = newEpochLengthInBlocks_;
714   }
715 
716   function _distributeOHMProfits() internal {
717     if( nextEpochBlock <= block.number ) {
718       IOHMandsOHM(sOHM).rebase(ohmToDistributeNextEpoch);
719       uint256 _ohmBalance = IOHMandsOHM(ohm).balanceOf(address(this));
720       uint256 _sohmSupply = IOHMandsOHM(sOHM).circulatingSupply();
721       ohmToDistributeNextEpoch = _ohmBalance.sub(_sohmSupply);
722       nextEpochBlock = nextEpochBlock.add( epochLengthInBlocks );
723     }
724   }
725 
726   function _stakeOHM( uint256 amountToStake_ ) internal {
727     _distributeOHMProfits();
728         
729     IERC20(ohm).safeTransferFrom(
730         msg.sender,
731         address(this),
732         amountToStake_
733       );
734 
735     IERC20(sOHM).safeTransfer(msg.sender, amountToStake_);
736   }
737 
738   function stakeOHMWithPermit (
739         uint256 amountToStake_,
740         uint256 deadline_,
741         uint8 v_,
742         bytes32 r_,
743         bytes32 s_
744     ) external {
745 
746         IOHMandsOHM(ohm).permit(
747             msg.sender,
748             address(this),
749             amountToStake_,
750             deadline_,
751             v_,
752             r_,
753             s_
754         );
755 
756         _stakeOHM( amountToStake_ );
757     }
758 
759     function stakeOHM( uint amountToStake_ ) external returns ( bool ) {
760 
761       _stakeOHM( amountToStake_ );
762 
763       return true;
764 
765     }
766 
767     function _unstakeOHM( uint256 amountToUnstake_ ) internal {
768 
769       _distributeOHMProfits();
770 
771       IERC20(sOHM).safeTransferFrom(
772             msg.sender,
773             address(this),
774             amountToUnstake_
775         );
776 
777       IERC20(ohm).safeTransfer(msg.sender, amountToUnstake_);
778     }
779 
780     function unstakeOHMWithPermit (
781         uint256 amountToWithdraw_,
782         uint256 deadline_,
783         uint8 v_,
784         bytes32 r_,
785         bytes32 s_
786     ) external {
787         
788         IOHMandsOHM(sOHM).permit(
789             msg.sender,
790             address(this),
791             amountToWithdraw_,
792             deadline_,
793             v_,
794             r_,
795             s_
796         );
797 
798         _unstakeOHM( amountToWithdraw_ );
799 
800     }
801 
802     function unstakeOHM( uint amountToWithdraw_ ) external returns ( bool ) {
803 
804         _unstakeOHM( amountToWithdraw_ );
805 
806         return true;
807     }
808 }