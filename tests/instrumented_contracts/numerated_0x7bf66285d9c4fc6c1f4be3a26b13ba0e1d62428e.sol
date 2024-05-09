1 // Sources flattened with hardhat v2.10.1 https://hardhat.org
2 
3 // File contracts/Math/Math.sol
4 
5 pragma solidity >=0.6.11;
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     /**
12      * @dev Returns the largest of two numbers.
13      */
14     function max(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a >= b ? a : b;
16     }
17 
18     /**
19      * @dev Returns the smallest of two numbers.
20      */
21     function min(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a < b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the average of two numbers. The result is rounded towards
27      * zero.
28      */
29     function average(uint256 a, uint256 b) internal pure returns (uint256) {
30         // (a + b) / 2 can overflow, so we distribute
31         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
32     }
33 
34     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
35     function sqrt(uint y) internal pure returns (uint z) {
36         if (y > 3) {
37             z = y;
38             uint x = y / 2 + 1;
39             while (x < z) {
40                 z = x;
41                 x = (y / x + x) / 2;
42             }
43         } else if (y != 0) {
44             z = 1;
45         }
46     }
47 }
48 
49 
50 // File contracts/Math/SafeMath.sol
51 
52 pragma solidity >=0.6.11;
53 
54 /**
55  * @dev Wrappers over Solidity's arithmetic operations with added overflow
56  * checks.
57  *
58  * Arithmetic operations in Solidity wrap on overflow. This can easily result
59  * in bugs, because programmers usually assume that an overflow raises an
60  * error, which is the standard behavior in high level programming languages.
61  * `SafeMath` restores this intuition by reverting the transaction when an
62  * operation overflows.
63  *
64  * Using this library instead of the unchecked operations eliminates an entire
65  * class of bugs, so it's recommended to use it always.
66  */
67 library SafeMath {
68     /**
69      * @dev Returns the addition of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `+` operator.
73      *
74      * Requirements:
75      * - Addition cannot overflow.
76      */
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80 
81         return c;
82     }
83 
84     /**
85      * @dev Returns the subtraction of two unsigned integers, reverting on
86      * overflow (when the result is negative).
87      *
88      * Counterpart to Solidity's `-` operator.
89      *
90      * Requirements:
91      * - Subtraction cannot overflow.
92      */
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         return sub(a, b, "SafeMath: subtraction overflow");
95     }
96 
97     /**
98      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
99      * overflow (when the result is negative).
100      *
101      * Counterpart to Solidity's `-` operator.
102      *
103      * Requirements:
104      * - Subtraction cannot overflow.
105      *
106      * _Available since v2.4.0._
107      */
108     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         require(b <= a, errorMessage);
110         uint256 c = a - b;
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
126         // benefit is lost if 'b' is also tested.
127         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
128         if (a == 0) {
129             return 0;
130         }
131 
132         uint256 c = a * b;
133         require(c / a == b, "SafeMath: multiplication overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers. Reverts on
140      * division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         return div(a, b, "SafeMath: division by zero");
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      *
164      * _Available since v2.4.0._
165      */
166     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         // Solidity only automatically asserts when dividing by 0
168         require(b > 0, errorMessage);
169         uint256 c = a / b;
170         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
177      * Reverts when dividing by zero.
178      *
179      * Counterpart to Solidity's `%` operator. This function uses a `revert`
180      * opcode (which leaves remaining gas untouched) while Solidity uses an
181      * invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      */
186     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
187         return mod(a, b, "SafeMath: modulo by zero");
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * Reverts with custom message when dividing by zero.
193      *
194      * Counterpart to Solidity's `%` operator. This function uses a `revert`
195      * opcode (which leaves remaining gas untouched) while Solidity uses an
196      * invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      *
201      * _Available since v2.4.0._
202      */
203     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b != 0, errorMessage);
205         return a % b;
206     }
207 }
208 
209 
210 // File contracts/Gauge/IveMPH.sol
211 
212 pragma solidity >=0.6.11;
213 pragma abicoder v2;
214 
215 interface IveMPH {
216 
217     struct LockedBalance {
218         int128 amount;
219         uint256 end;
220     }
221 
222     function commit_transfer_ownership(address addr) external;
223     function apply_transfer_ownership() external;
224     function commit_smart_wallet_checker(address addr) external;
225     function apply_smart_wallet_checker() external;
226     function toggleEmergencyUnlock() external;
227     function recoverERC20(address token_addr, uint256 amount) external;
228     function get_last_user_slope(address addr) external view returns (int128);
229     function user_point_history__ts(address _addr, uint256 _idx) external view returns (uint256);
230     function locked__end(address _addr) external view returns (uint256);
231     function checkpoint() external;
232     function deposit_for(address _addr, uint256 _value) external;
233     function create_lock(uint256 _value, uint256 _unlock_time) external;
234     function increase_amount(uint256 _value) external;
235     function increase_unlock_time(uint256 _unlock_time) external;
236     function withdraw() external;
237     function balanceOf(address addr) external view returns (uint256);
238     function balanceOf(address addr, uint256 _t) external view returns (uint256);
239     function balanceOfAt(address addr, uint256 _block) external view returns (uint256);
240     function totalSupply() external view returns (uint256);
241     function totalSupply(uint256 t) external view returns (uint256);
242     function totalSupplyAt(uint256 _block) external view returns (uint256);
243     function totalFXSSupply() external view returns (uint256);
244     function totalFXSSupplyAt(uint256 _block) external view returns (uint256);
245     function changeController(address _newController) external;
246     function token() external view returns (address);
247     function supply() external view returns (uint256);
248     function locked(address addr) external view returns (LockedBalance memory);
249     function epoch() external view returns (uint256);
250     function point_history(uint256 arg0) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
251     function user_point_history(address arg0, uint256 arg1) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
252     function user_point_epoch(address arg0) external view returns (uint256);
253     function slope_changes(uint256 arg0) external view returns (int128);
254     function controller() external view returns (address);
255     function transfersEnabled() external view returns (bool);
256     function emergencyUnlockActive() external view returns (bool);
257     function name() external view returns (string memory);
258     function symbol() external view returns (string memory);
259     function version() external view returns (string memory);
260     function decimals() external view returns (uint256);
261     function future_smart_wallet_checker() external view returns (address);
262     function smart_wallet_checker() external view returns (address);
263     function admin() external view returns (address);
264     function future_admin() external view returns (address);
265 }
266 
267 
268 // File contracts/Uniswap/TransferHelper.sol
269 
270 pragma solidity >=0.6.11;
271 
272 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
273 library TransferHelper {
274     function safeApprove(address token, address to, uint value) internal {
275         // bytes4(keccak256(bytes('approve(address,uint256)')));
276         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
277         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
278     }
279 
280     function safeTransfer(address token, address to, uint value) internal {
281         // bytes4(keccak256(bytes('transfer(address,uint256)')));
282         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
283         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
284     }
285 
286     function safeTransferFrom(address token, address from, address to, uint value) internal {
287         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
288         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
289         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
290     }
291 
292     function safeTransferETH(address to, uint value) internal {
293         (bool success,) = to.call{value:value}(new bytes(0));
294         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
295     }
296 }
297 
298 
299 // File contracts/Common/Context.sol
300 
301 pragma solidity >=0.6.11;
302 
303 /*
304  * @dev Provides information about the current execution context, including the
305  * sender of the transaction and its data. While these are generally available
306  * via msg.sender and msg.data, they should not be accessed in such a direct
307  * manner, since when dealing with GSN meta-transactions the account sending and
308  * paying for execution may not be the actual sender (as far as an application
309  * is concerned).
310  *
311  * This contract is only required for intermediate, library-like contracts.
312  */
313 abstract contract Context {
314     function _msgSender() internal view virtual returns (address payable) {
315         return payable(msg.sender);
316     }
317 
318     function _msgData() internal view virtual returns (bytes memory) {
319         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
320         return msg.data;
321     }
322 }
323 
324 
325 // File contracts/ERC20/IERC20.sol
326 
327 pragma solidity >=0.6.11;
328 
329 
330 /**
331  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
332  * the optional functions; to access them see {ERC20Detailed}.
333  */
334 interface IERC20 {
335     /**
336      * @dev Returns the amount of tokens in existence.
337      */
338     function totalSupply() external view returns (uint256);
339 
340     /**
341      * @dev Returns the amount of tokens owned by `account`.
342      */
343     function balanceOf(address account) external view returns (uint256);
344 
345     /**
346      * @dev Moves `amount` tokens from the caller's account to `recipient`.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transfer(address recipient, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Returns the remaining number of tokens that `spender` will be
356      * allowed to spend on behalf of `owner` through {transferFrom}. This is
357      * zero by default.
358      *
359      * This value changes when {approve} or {transferFrom} are called.
360      */
361     function allowance(address owner, address spender) external view returns (uint256);
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * IMPORTANT: Beware that changing an allowance with this method brings the risk
369      * that someone may use both the old and the new allowance by unfortunate
370      * transaction ordering. One possible solution to mitigate this race
371      * condition is to first reduce the spender's allowance to 0 and set the
372      * desired value afterwards:
373      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374      *
375      * Emits an {Approval} event.
376      */
377     function approve(address spender, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Moves `amount` tokens from `sender` to `recipient` using the
381      * allowance mechanism. `amount` is then deducted from the caller's
382      * allowance.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
389 
390     /**
391      * @dev Emitted when `value` tokens are moved from one account (`from`) to
392      * another (`to`).
393      *
394      * Note that `value` may be zero.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 value);
397 
398     /**
399      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
400      * a call to {approve}. `value` is the new allowance.
401      */
402     event Approval(address indexed owner, address indexed spender, uint256 value);
403 }
404 
405 
406 // File contracts/Utils/Address.sol
407 
408 pragma solidity >=0.6.11 <0.9.0;
409 
410 /**
411  * @dev Collection of functions related to the address type
412  */
413 library Address {
414     /**
415      * @dev Returns true if `account` is a contract.
416      *
417      * [IMPORTANT]
418      * ====
419      * It is unsafe to assume that an address for which this function returns
420      * false is an externally-owned account (EOA) and not a contract.
421      *
422      * Among others, `isContract` will return false for the following
423      * types of addresses:
424      *
425      *  - an externally-owned account
426      *  - a contract in construction
427      *  - an address where a contract will be created
428      *  - an address where a contract lived, but was destroyed
429      * ====
430      */
431     function isContract(address account) internal view returns (bool) {
432         // This method relies on extcodesize, which returns 0 for contracts in
433         // construction, since the code is only stored at the end of the
434         // constructor execution.
435 
436         uint256 size;
437         // solhint-disable-next-line no-inline-assembly
438         assembly { size := extcodesize(account) }
439         return size > 0;
440     }
441 
442     /**
443      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
444      * `recipient`, forwarding all available gas and reverting on errors.
445      *
446      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
447      * of certain opcodes, possibly making contracts go over the 2300 gas limit
448      * imposed by `transfer`, making them unable to receive funds via
449      * `transfer`. {sendValue} removes this limitation.
450      *
451      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
452      *
453      * IMPORTANT: because control is transferred to `recipient`, care must be
454      * taken to not create reentrancy vulnerabilities. Consider using
455      * {ReentrancyGuard} or the
456      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
457      */
458     function sendValue(address payable recipient, uint256 amount) internal {
459         require(address(this).balance >= amount, "Address: insufficient balance");
460 
461         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
462         (bool success, ) = recipient.call{ value: amount }("");
463         require(success, "Address: unable to send value, recipient may have reverted");
464     }
465 
466     /**
467      * @dev Performs a Solidity function call using a low level `call`. A
468      * plain`call` is an unsafe replacement for a function call: use this
469      * function instead.
470      *
471      * If `target` reverts with a revert reason, it is bubbled up by this
472      * function (like regular Solidity function calls).
473      *
474      * Returns the raw returned data. To convert to the expected return value,
475      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
476      *
477      * Requirements:
478      *
479      * - `target` must be a contract.
480      * - calling `target` with `data` must not revert.
481      *
482      * _Available since v3.1._
483      */
484     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
485       return functionCall(target, data, "Address: low-level call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
490      * `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, 0, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but also transferring `value` wei to `target`.
501      *
502      * Requirements:
503      *
504      * - the calling contract must have an ETH balance of at least `value`.
505      * - the called Solidity function must be `payable`.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
515      * with `errorMessage` as a fallback revert reason when `target` reverts.
516      *
517      * _Available since v3.1._
518      */
519     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
520         require(address(this).balance >= value, "Address: insufficient balance for call");
521         require(isContract(target), "Address: call to non-contract");
522 
523         // solhint-disable-next-line avoid-low-level-calls
524         (bool success, bytes memory returndata) = target.call{ value: value }(data);
525         return _verifyCallResult(success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
535         return functionStaticCall(target, data, "Address: low-level static call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
545         require(isContract(target), "Address: static call to non-contract");
546 
547         // solhint-disable-next-line avoid-low-level-calls
548         (bool success, bytes memory returndata) = target.staticcall(data);
549         return _verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a delegate call.
555      *
556      * _Available since v3.4._
557      */
558     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a delegate call.
565      *
566      * _Available since v3.4._
567      */
568     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
569         require(isContract(target), "Address: delegate call to non-contract");
570 
571         // solhint-disable-next-line avoid-low-level-calls
572         (bool success, bytes memory returndata) = target.delegatecall(data);
573         return _verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
577         if (success) {
578             return returndata;
579         } else {
580             // Look for revert reason and bubble it up if present
581             if (returndata.length > 0) {
582                 // The easiest way to bubble the revert reason is using memory via assembly
583 
584                 // solhint-disable-next-line no-inline-assembly
585                 assembly {
586                     let returndata_size := mload(returndata)
587                     revert(add(32, returndata), returndata_size)
588                 }
589             } else {
590                 revert(errorMessage);
591             }
592         }
593     }
594 }
595 
596 
597 // File contracts/ERC20/ERC20.sol
598 
599 pragma solidity >=0.6.11;
600 
601 
602 
603 
604 /**
605  * @dev Implementation of the {IERC20} interface.
606  *
607  * This implementation is agnostic to the way tokens are created. This means
608  * that a supply mechanism has to be added in a derived contract using {_mint}.
609  * For a generic mechanism see {ERC20Mintable}.
610  *
611  * TIP: For a detailed writeup see our guide
612  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
613  * to implement supply mechanisms].
614  *
615  * We have followed general OpenZeppelin guidelines: functions revert instead
616  * of returning `false` on failure. This behavior is nonetheless conventional
617  * and does not conflict with the expectations of ERC20 applications.
618  *
619  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
620  * This allows applications to reconstruct the allowance for all accounts just
621  * by listening to said events. Other implementations of the EIP may not emit
622  * these events, as it isn't required by the specification.
623  *
624  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
625  * functions have been added to mitigate the well-known issues around setting
626  * allowances. See {IERC20-approve}.
627  */
628  
629 contract ERC20 is Context, IERC20 {
630     using SafeMath for uint256;
631 
632     mapping (address => uint256) private _balances;
633 
634     mapping (address => mapping (address => uint256)) private _allowances;
635 
636     uint256 private _totalSupply;
637 
638     string private _name;
639     string private _symbol;
640     uint8 private _decimals;
641     
642     /**
643      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
644      * a default value of 18.
645      *
646      * To select a different value for {decimals}, use {_setupDecimals}.
647      *
648      * All three of these values are immutable: they can only be set once during
649      * construction.
650      */
651     constructor (string memory __name, string memory __symbol) {
652         _name = __name;
653         _symbol = __symbol;
654         _decimals = 18;
655     }
656 
657     /**
658      * @dev Returns the name of the token.
659      */
660     function name() public view returns (string memory) {
661         return _name;
662     }
663 
664     /**
665      * @dev Returns the symbol of the token, usually a shorter version of the
666      * name.
667      */
668     function symbol() public view returns (string memory) {
669         return _symbol;
670     }
671 
672     /**
673      * @dev Returns the number of decimals used to get its user representation.
674      * For example, if `decimals` equals `2`, a balance of `505` tokens should
675      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
676      *
677      * Tokens usually opt for a value of 18, imitating the relationship between
678      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
679      * called.
680      *
681      * NOTE: This information is only used for _display_ purposes: it in
682      * no way affects any of the arithmetic of the contract, including
683      * {IERC20-balanceOf} and {IERC20-transfer}.
684      */
685     function decimals() public view returns (uint8) {
686         return _decimals;
687     }
688 
689     /**
690      * @dev See {IERC20-totalSupply}.
691      */
692     function totalSupply() public view override returns (uint256) {
693         return _totalSupply;
694     }
695 
696     /**
697      * @dev See {IERC20-balanceOf}.
698      */
699     function balanceOf(address account) public view override returns (uint256) {
700         return _balances[account];
701     }
702 
703     /**
704      * @dev See {IERC20-transfer}.
705      *
706      * Requirements:
707      *
708      * - `recipient` cannot be the zero address.
709      * - the caller must have a balance of at least `amount`.
710      */
711     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
712         _transfer(_msgSender(), recipient, amount);
713         return true;
714     }
715 
716     /**
717      * @dev See {IERC20-allowance}.
718      */
719     function allowance(address owner, address spender) public view virtual override returns (uint256) {
720         return _allowances[owner][spender];
721     }
722 
723     /**
724      * @dev See {IERC20-approve}.
725      *
726      * Requirements:
727      *
728      * - `spender` cannot be the zero address.approve(address spender, uint256 amount)
729      */
730     function approve(address spender, uint256 amount) public virtual override returns (bool) {
731         _approve(_msgSender(), spender, amount);
732         return true;
733     }
734 
735     /**
736      * @dev See {IERC20-transferFrom}.
737      *
738      * Emits an {Approval} event indicating the updated allowance. This is not
739      * required by the EIP. See the note at the beginning of {ERC20};
740      *
741      * Requirements:
742      * - `sender` and `recipient` cannot be the zero address.
743      * - `sender` must have a balance of at least `amount`.
744      * - the caller must have allowance for `sender`'s tokens of at least
745      * `amount`.
746      */
747     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
748         _transfer(sender, recipient, amount);
749         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
750         return true;
751     }
752 
753     /**
754      * @dev Atomically increases the allowance granted to `spender` by the caller.
755      *
756      * This is an alternative to {approve} that can be used as a mitigation for
757      * problems described in {IERC20-approve}.
758      *
759      * Emits an {Approval} event indicating the updated allowance.
760      *
761      * Requirements:
762      *
763      * - `spender` cannot be the zero address.
764      */
765     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
766         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
767         return true;
768     }
769 
770     /**
771      * @dev Atomically decreases the allowance granted to `spender` by the caller.
772      *
773      * This is an alternative to {approve} that can be used as a mitigation for
774      * problems described in {IERC20-approve}.
775      *
776      * Emits an {Approval} event indicating the updated allowance.
777      *
778      * Requirements:
779      *
780      * - `spender` cannot be the zero address.
781      * - `spender` must have allowance for the caller of at least
782      * `subtractedValue`.
783      */
784     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
785         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
786         return true;
787     }
788 
789     /**
790      * @dev Moves tokens `amount` from `sender` to `recipient`.
791      *
792      * This is internal function is equivalent to {transfer}, and can be used to
793      * e.g. implement automatic token fees, slashing mechanisms, etc.
794      *
795      * Emits a {Transfer} event.
796      *
797      * Requirements:
798      *
799      * - `sender` cannot be the zero address.
800      * - `recipient` cannot be the zero address.
801      * - `sender` must have a balance of at least `amount`.
802      */
803     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
804         require(sender != address(0), "ERC20: transfer from the zero address");
805         require(recipient != address(0), "ERC20: transfer to the zero address");
806 
807         _beforeTokenTransfer(sender, recipient, amount);
808 
809         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
810         _balances[recipient] = _balances[recipient].add(amount);
811         emit Transfer(sender, recipient, amount);
812     }
813 
814     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
815      * the total supply.
816      *
817      * Emits a {Transfer} event with `from` set to the zero address.
818      *
819      * Requirements
820      *
821      * - `to` cannot be the zero address.
822      */
823     function _mint(address account, uint256 amount) internal virtual {
824         require(account != address(0), "ERC20: mint to the zero address");
825 
826         _beforeTokenTransfer(address(0), account, amount);
827 
828         _totalSupply = _totalSupply.add(amount);
829         _balances[account] = _balances[account].add(amount);
830         emit Transfer(address(0), account, amount);
831     }
832 
833     /**
834      * @dev Destroys `amount` tokens from the caller.
835      *
836      * See {ERC20-_burn}.
837      */
838     function burn(uint256 amount) public virtual {
839         _burn(_msgSender(), amount);
840     }
841 
842     /**
843      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
844      * allowance.
845      *
846      * See {ERC20-_burn} and {ERC20-allowance}.
847      *
848      * Requirements:
849      *
850      * - the caller must have allowance for `accounts`'s tokens of at least
851      * `amount`.
852      */
853     function burnFrom(address account, uint256 amount) public virtual {
854         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
855 
856         _approve(account, _msgSender(), decreasedAllowance);
857         _burn(account, amount);
858     }
859 
860 
861     /**
862      * @dev Destroys `amount` tokens from `account`, reducing the
863      * total supply.
864      *
865      * Emits a {Transfer} event with `to` set to the zero address.
866      *
867      * Requirements
868      *
869      * - `account` cannot be the zero address.
870      * - `account` must have at least `amount` tokens.
871      */
872     function _burn(address account, uint256 amount) internal virtual {
873         require(account != address(0), "ERC20: burn from the zero address");
874 
875         _beforeTokenTransfer(account, address(0), amount);
876 
877         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
878         _totalSupply = _totalSupply.sub(amount);
879         emit Transfer(account, address(0), amount);
880     }
881 
882     /**
883      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
884      *
885      * This is internal function is equivalent to `approve`, and can be used to
886      * e.g. set automatic allowances for certain subsystems, etc.
887      *
888      * Emits an {Approval} event.
889      *
890      * Requirements:
891      *
892      * - `owner` cannot be the zero address.
893      * - `spender` cannot be the zero address.
894      */
895     function _approve(address owner, address spender, uint256 amount) internal virtual {
896         require(owner != address(0), "ERC20: approve from the zero address");
897         require(spender != address(0), "ERC20: approve to the zero address");
898 
899         _allowances[owner][spender] = amount;
900         emit Approval(owner, spender, amount);
901     }
902 
903     /**
904      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
905      * from the caller's allowance.
906      *
907      * See {_burn} and {_approve}.
908      */
909     function _burnFrom(address account, uint256 amount) internal virtual {
910         _burn(account, amount);
911         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
912     }
913 
914     /**
915      * @dev Hook that is called before any transfer of tokens. This includes
916      * minting and burning.
917      *
918      * Calling conditions:
919      *
920      * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
921      * will be to transferred to `to`.
922      * - when `from` is zero, `amount` tokens will be minted for `to`.
923      * - when `to` is zero, `amount` of `from`'s tokens will be burned.
924      * - `from` and `to` are never both zero.
925      *
926      * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
927      */
928     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
929 }
930 
931 
932 // File contracts/ERC20/SafeERC20.sol
933 
934 pragma solidity >=0.6.11;
935 
936 
937 
938 /**
939  * @title SafeERC20
940  * @dev Wrappers around ERC20 operations that throw on failure (when the token
941  * contract returns false). Tokens that return no value (and instead revert or
942  * throw on failure) are also supported, non-reverting calls are assumed to be
943  * successful.
944  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
945  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
946  */
947 library SafeERC20 {
948     using SafeMath for uint256;
949     using Address for address;
950 
951     function safeTransfer(IERC20 token, address to, uint256 value) internal {
952         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
953     }
954 
955     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
956         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
957     }
958 
959     /**
960      * @dev Deprecated. This function has issues similar to the ones found in
961      * {IERC20-approve}, and its usage is discouraged.
962      *
963      * Whenever possible, use {safeIncreaseAllowance} and
964      * {safeDecreaseAllowance} instead.
965      */
966     function safeApprove(IERC20 token, address spender, uint256 value) internal {
967         // safeApprove should only be called when setting an initial allowance,
968         // or when resetting it to zero. To increase and decrease it, use
969         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
970         // solhint-disable-next-line max-line-length
971         require((value == 0) || (token.allowance(address(this), spender) == 0),
972             "SafeERC20: approve from non-zero to non-zero allowance"
973         );
974         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
975     }
976 
977     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
978         uint256 newAllowance = token.allowance(address(this), spender).add(value);
979         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
980     }
981 
982     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
983         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
984         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
985     }
986 
987     /**
988      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
989      * on the return value: the return value is optional (but if data is returned, it must not be false).
990      * @param token The token targeted by the call.
991      * @param data The call data (encoded using abi.encode or one of its variants).
992      */
993     function _callOptionalReturn(IERC20 token, bytes memory data) private {
994         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
995         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
996         // the target address contains contract code and also asserts for success in the low-level call.
997 
998         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
999         if (returndata.length > 0) { // Return data is optional
1000             // solhint-disable-next-line max-line-length
1001             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1002         }
1003     }
1004 }
1005 
1006 
1007 // File contracts/Utils/ReentrancyGuard.sol
1008 
1009 pragma solidity >=0.6.11;
1010 
1011 /**
1012  * @dev Contract module that helps prevent reentrant calls to a function.
1013  *
1014  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1015  * available, which can be applied to functions to make sure there are no nested
1016  * (reentrant) calls to them.
1017  *
1018  * Note that because there is a single `nonReentrant` guard, functions marked as
1019  * `nonReentrant` may not call one another. This can be worked around by making
1020  * those functions `private`, and then adding `external` `nonReentrant` entry
1021  * points to them.
1022  *
1023  * TIP: If you would like to learn more about reentrancy and alternative ways
1024  * to protect against it, check out our blog post
1025  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1026  */
1027 abstract contract ReentrancyGuard {
1028     // Booleans are more expensive than uint256 or any type that takes up a full
1029     // word because each write operation emits an extra SLOAD to first read the
1030     // slot's contents, replace the bits taken up by the boolean, and then write
1031     // back. This is the compiler's defense against contract upgrades and
1032     // pointer aliasing, and it cannot be disabled.
1033 
1034     // The values being non-zero value makes deployment a bit more expensive,
1035     // but in exchange the refund on every call to nonReentrant will be lower in
1036     // amount. Since refunds are capped to a percentage of the total
1037     // transaction's gas, it is best to keep them low in cases like this one, to
1038     // increase the likelihood of the full refund coming into effect.
1039     uint256 private constant _NOT_ENTERED = 1;
1040     uint256 private constant _ENTERED = 2;
1041 
1042     uint256 private _status;
1043 
1044     constructor () {
1045         _status = _NOT_ENTERED;
1046     }
1047 
1048     /**
1049      * @dev Prevents a contract from calling itself, directly or indirectly.
1050      * Calling a `nonReentrant` function from another `nonReentrant`
1051      * function is not supported. It is possible to prevent this from happening
1052      * by making the `nonReentrant` function external, and make it call a
1053      * `private` function that does the actual work.
1054      */
1055     modifier nonReentrant() {
1056         // On the first call to nonReentrant, _notEntered will be true
1057         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1058 
1059         // Any calls to nonReentrant after this point will fail
1060         _status = _ENTERED;
1061 
1062         _;
1063 
1064         // By storing the original value once again, a refund is triggered (see
1065         // https://eips.ethereum.org/EIPS/eip-2200)
1066         _status = _NOT_ENTERED;
1067     }
1068 }
1069 
1070 
1071 // File contracts/Staking/Owned.sol
1072 
1073 pragma solidity >=0.6.11;
1074 
1075 // https://docs.synthetix.io/contracts/Owned
1076 contract Owned {
1077     address public owner;
1078     address public nominatedOwner;
1079 
1080     constructor (address _owner) {
1081         require(_owner != address(0), "Owner address cannot be 0");
1082         owner = _owner;
1083         emit OwnerChanged(address(0), _owner);
1084     }
1085 
1086     function nominateNewOwner(address _owner) external onlyOwner {
1087         nominatedOwner = _owner;
1088         emit OwnerNominated(_owner);
1089     }
1090 
1091     function acceptOwnership() external {
1092         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
1093         emit OwnerChanged(owner, nominatedOwner);
1094         owner = nominatedOwner;
1095         nominatedOwner = address(0);
1096     }
1097 
1098     modifier onlyOwner {
1099         require(msg.sender == owner, "Only the contract owner may perform this action");
1100         _;
1101     }
1102 
1103     event OwnerNominated(address newOwner);
1104     event OwnerChanged(address oldOwner, address newOwner);
1105 }
1106 
1107 
1108 // File contracts/Staking/veMPHYieldDistributorV4.sol
1109 
1110 pragma solidity >=0.8.0;
1111 
1112 // ====================================================================
1113 // |     ______                   _______                             |
1114 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
1115 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
1116 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
1117 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
1118 // |                                                                  |
1119 // ====================================================================
1120 // ======================veMPHYieldDistributorV4=======================
1121 // ====================================================================
1122 // Distributes Frax protocol yield based on the claimer's veMPH balance
1123 // V3: Yield will now not accrue for unlocked veMPH
1124 
1125 // Frax Finance: https://github.com/FraxFinance
1126 
1127 // Primary Author(s)
1128 // Travis Moore: https://github.com/FortisFortuna
1129 
1130 // Reviewer(s) / Contributor(s)
1131 // Jason Huan: https://github.com/jasonhuan
1132 // Sam Kazemian: https://github.com/samkazemian
1133 
1134 // Originally inspired by Synthetix.io, but heavily modified by the Frax team (veMPH portion)
1135 // https://github.com/Synthetixio/synthetix/blob/develop/contracts/StakingRewards.sol
1136 
1137 
1138 
1139 
1140 
1141 
1142 
1143 
1144 contract veMPHYieldDistributorV4 is Owned, ReentrancyGuard {
1145     using SafeMath for uint256;
1146     using SafeERC20 for ERC20;
1147 
1148     /* ========== STATE VARIABLES ========== */
1149 
1150     // Instances
1151     IveMPH private veMPH;
1152     ERC20 public emittedToken;
1153 
1154     // Addresses
1155     address public emitted_token_address;
1156 
1157     // Admin addresses
1158     address public timelock_address;
1159 
1160     // Constant for price precision
1161     uint256 private constant PRICE_PRECISION = 1e6;
1162 
1163     // Yield and period related
1164     uint256 public periodFinish;
1165     uint256 public lastUpdateTime;
1166     uint256 public yieldRate;
1167     uint256 public yieldDuration = 4 * 365 days;
1168     mapping(address => bool) public reward_notifiers;
1169 
1170     // Yield tracking
1171     uint256 public yieldPerVeMPHStored = 0;
1172     mapping(address => uint256) public userYieldPerTokenPaid;
1173     mapping(address => uint256) public yields;
1174 
1175     // veMPH tracking
1176     uint256 public totalVeMPHParticipating = 0;
1177     uint256 public totalVeMPHSupplyStored = 0;
1178     mapping(address => bool) public userIsInitialized;
1179     mapping(address => uint256) public userVeMPHCheckpointed;
1180     mapping(address => uint256) public userVeMPHEndpointCheckpointed;
1181     mapping(address => uint256) private lastRewardClaimTime; // staker addr -> timestamp
1182 
1183     // Greylists
1184     mapping(address => bool) public greylist;
1185 
1186     // Admin booleans for emergencies
1187     bool public yieldCollectionPaused = false; // For emergencies
1188 
1189     struct LockedBalance {
1190         int128 amount;
1191         uint256 end;
1192     }
1193 
1194     /* ========== MODIFIERS ========== */
1195 
1196     modifier onlyByOwnGov() {
1197         require(
1198             msg.sender == owner || msg.sender == timelock_address,
1199             "Not owner or timelock"
1200         );
1201         _;
1202     }
1203 
1204     modifier notYieldCollectionPaused() {
1205         require(yieldCollectionPaused == false, "Yield collection is paused");
1206         _;
1207     }
1208 
1209     modifier checkpointUser(address account) {
1210         _checkpointUser(account);
1211         _;
1212     }
1213 
1214     /* ========== CONSTRUCTOR ========== */
1215 
1216     constructor(
1217         address _owner,
1218         address _emittedToken,
1219         address _timelock_address,
1220         address _veMPH_address
1221     ) Owned(_owner) {
1222         emitted_token_address = _emittedToken;
1223         emittedToken = ERC20(_emittedToken);
1224 
1225         veMPH = IveMPH(_veMPH_address);
1226         lastUpdateTime = block.timestamp;
1227         timelock_address = _timelock_address;
1228 
1229         reward_notifiers[_owner] = true;
1230     }
1231 
1232     /* ========== VIEWS ========== */
1233 
1234     function fractionParticipating() external view returns (uint256) {
1235         return
1236             totalVeMPHParticipating.mul(PRICE_PRECISION).div(
1237                 totalVeMPHSupplyStored
1238             );
1239     }
1240 
1241     // Only positions with locked veMPH can accrue yield. Otherwise, expired-locked veMPH
1242     // is de-facto rewards for MPH.
1243     function eligibleCurrentVeMPH(address account)
1244         public
1245         view
1246         returns (uint256 eligible_vemph_bal, uint256 stored_ending_timestamp)
1247     {
1248         uint256 curr_vemph_bal = veMPH.balanceOf(account);
1249 
1250         // Stored is used to prevent abuse
1251         stored_ending_timestamp = userVeMPHEndpointCheckpointed[account];
1252 
1253         // Only unexpired veMPH should be eligible
1254         if (
1255             stored_ending_timestamp != 0 &&
1256             (block.timestamp >= stored_ending_timestamp)
1257         ) {
1258             eligible_vemph_bal = 0;
1259         } else if (block.timestamp >= stored_ending_timestamp) {
1260             eligible_vemph_bal = 0;
1261         } else {
1262             eligible_vemph_bal = curr_vemph_bal;
1263         }
1264     }
1265 
1266     function lastTimeYieldApplicable() public view returns (uint256) {
1267         return Math.min(block.timestamp, periodFinish);
1268     }
1269 
1270     function yieldPerVeMPH() public view returns (uint256) {
1271         if (totalVeMPHSupplyStored == 0) {
1272             return yieldPerVeMPHStored;
1273         } else {
1274             return (
1275                 yieldPerVeMPHStored.add(
1276                     lastTimeYieldApplicable()
1277                         .sub(lastUpdateTime)
1278                         .mul(yieldRate)
1279                         .mul(1e18)
1280                         .div(totalVeMPHSupplyStored)
1281                 )
1282             );
1283         }
1284     }
1285 
1286     function earned(address account) public view returns (uint256) {
1287         // Uninitialized users should not earn anything yet
1288         if (!userIsInitialized[account]) return 0;
1289 
1290         // Get eligible veMPH balances
1291         (
1292             uint256 eligible_current_vemph,
1293             uint256 ending_timestamp
1294         ) = eligibleCurrentVeMPH(account);
1295 
1296         // If your veMPH is unlocked
1297         uint256 eligible_time_fraction = PRICE_PRECISION;
1298         if (eligible_current_vemph == 0) {
1299             // And you already claimed after expiration
1300             if (lastRewardClaimTime[account] >= ending_timestamp) {
1301                 // You get NOTHING. You LOSE. Good DAY ser!
1302                 return 0;
1303             }
1304             // You haven't claimed yet
1305             else {
1306                 uint256 eligible_time = (ending_timestamp).sub(
1307                     lastRewardClaimTime[account]
1308                 );
1309                 uint256 total_time = (block.timestamp).sub(
1310                     lastRewardClaimTime[account]
1311                 );
1312                 eligible_time_fraction = PRICE_PRECISION.mul(eligible_time).div(
1313                         total_time
1314                     );
1315             }
1316         }
1317 
1318         // If the amount of veMPH increased, only pay off based on the old balance
1319         // Otherwise, take the midpoint
1320         uint256 vemph_balance_to_use;
1321         {
1322             uint256 old_vemph_balance = userVeMPHCheckpointed[account];
1323             if (eligible_current_vemph > old_vemph_balance) {
1324                 vemph_balance_to_use = old_vemph_balance;
1325             } else {
1326                 vemph_balance_to_use = (
1327                     (eligible_current_vemph).add(old_vemph_balance)
1328                 ).div(2);
1329             }
1330         }
1331 
1332         return (
1333             vemph_balance_to_use
1334                 .mul(yieldPerVeMPH().sub(userYieldPerTokenPaid[account]))
1335                 .mul(eligible_time_fraction)
1336                 .div(1e18 * PRICE_PRECISION)
1337                 .add(yields[account])
1338         );
1339     }
1340 
1341     function getYieldForDuration() external view returns (uint256) {
1342         return (yieldRate.mul(yieldDuration));
1343     }
1344 
1345     /* ========== MUTATIVE FUNCTIONS ========== */
1346 
1347     function _checkpointUser(address account) internal {
1348         // Need to retro-adjust some things if the period hasn't been renewed, then start a new one
1349         sync();
1350 
1351         // Calculate the earnings first
1352         _syncEarned(account);
1353 
1354         // Get the old and the new veMPH balances
1355         uint256 old_vemph_balance = userVeMPHCheckpointed[account];
1356         uint256 new_vemph_balance = veMPH.balanceOf(account);
1357 
1358         // Update the user's stored veMPH balance
1359         userVeMPHCheckpointed[account] = new_vemph_balance;
1360 
1361         // Update the user's stored ending timestamp
1362         IveMPH.LockedBalance memory curr_locked_bal_pack = veMPH.locked(
1363             account
1364         );
1365         userVeMPHEndpointCheckpointed[account] = curr_locked_bal_pack.end;
1366 
1367         // Update the total amount participating
1368         if (new_vemph_balance >= old_vemph_balance) {
1369             uint256 weight_diff = new_vemph_balance.sub(old_vemph_balance);
1370             totalVeMPHParticipating = totalVeMPHParticipating.add(weight_diff);
1371         } else {
1372             uint256 weight_diff = old_vemph_balance.sub(new_vemph_balance);
1373             totalVeMPHParticipating = totalVeMPHParticipating.sub(weight_diff);
1374         }
1375 
1376         // Mark the user as initialized
1377         if (!userIsInitialized[account]) {
1378             userIsInitialized[account] = true;
1379             lastRewardClaimTime[account] = block.timestamp;
1380         }
1381     }
1382 
1383     function _syncEarned(address account) internal {
1384         if (account != address(0)) {
1385             uint256 earned0 = earned(account);
1386             yields[account] = earned0;
1387             userYieldPerTokenPaid[account] = yieldPerVeMPHStored;
1388         }
1389     }
1390 
1391     // Anyone can checkpoint another user
1392     function checkpointOtherUser(address user_addr) external {
1393         _checkpointUser(user_addr);
1394     }
1395 
1396     // Checkpoints the user
1397     function checkpoint() external {
1398         _checkpointUser(msg.sender);
1399     }
1400 
1401     function getYield()
1402         external
1403         nonReentrant
1404         notYieldCollectionPaused
1405         checkpointUser(msg.sender)
1406         returns (uint256 yield0)
1407     {
1408         require(greylist[msg.sender] == false, "Address has been greylisted");
1409 
1410         yield0 = yields[msg.sender];
1411         if (yield0 > 0) {
1412             yields[msg.sender] = 0;
1413             TransferHelper.safeTransfer(
1414                 emitted_token_address,
1415                 msg.sender,
1416                 yield0
1417             );
1418             emit YieldCollected(msg.sender, yield0, emitted_token_address);
1419         }
1420 
1421         lastRewardClaimTime[msg.sender] = block.timestamp;
1422     }
1423 
1424     function sync() public {
1425         // Update the total veMPH supply
1426         yieldPerVeMPHStored = yieldPerVeMPH();
1427         totalVeMPHSupplyStored = veMPH.totalSupply();
1428         lastUpdateTime = lastTimeYieldApplicable();
1429     }
1430 
1431     function notifyRewardAmount(uint256 amount) external {
1432         // Only whitelisted addresses can notify rewards
1433         require(reward_notifiers[msg.sender], "Sender not whitelisted");
1434 
1435         // Handle the transfer of emission tokens via `transferFrom` to reduce the number
1436         // of transactions required and ensure correctness of the smission amount
1437         emittedToken.safeTransferFrom(msg.sender, address(this), amount);
1438 
1439         // Update some values beforehand
1440         sync();
1441 
1442         // Update the new yieldRate
1443         if (block.timestamp >= periodFinish) {
1444             yieldRate = amount.div(yieldDuration);
1445         } else {
1446             uint256 remaining = periodFinish.sub(block.timestamp);
1447             uint256 leftover = remaining.mul(yieldRate);
1448             yieldRate = amount.add(leftover).div(yieldDuration);
1449         }
1450 
1451         // Update duration-related info
1452         lastUpdateTime = block.timestamp;
1453         periodFinish = block.timestamp.add(yieldDuration);
1454 
1455         emit RewardAdded(amount, yieldRate);
1456     }
1457 
1458     /* ========== RESTRICTED FUNCTIONS ========== */
1459 
1460     // Added to support recovering LP Yield and other mistaken tokens from other systems to be distributed to holders
1461     function recoverERC20(address tokenAddress, uint256 tokenAmount)
1462         external
1463         onlyByOwnGov
1464     {
1465         // Only the owner address can ever receive the recovery withdrawal
1466         TransferHelper.safeTransfer(tokenAddress, owner, tokenAmount);
1467         emit RecoveredERC20(tokenAddress, tokenAmount);
1468     }
1469 
1470     function setYieldDuration(uint256 _yieldDuration) external onlyByOwnGov {
1471         require(
1472             periodFinish == 0 || block.timestamp > periodFinish,
1473             "Previous yield period must be complete before changing the duration for the new period"
1474         );
1475         yieldDuration = _yieldDuration;
1476         emit YieldDurationUpdated(yieldDuration);
1477     }
1478 
1479     function greylistAddress(address _address) external onlyByOwnGov {
1480         greylist[_address] = !(greylist[_address]);
1481     }
1482 
1483     function toggleRewardNotifier(address notifier_addr) external onlyByOwnGov {
1484         reward_notifiers[notifier_addr] = !reward_notifiers[notifier_addr];
1485     }
1486 
1487     function setPauses(bool _yieldCollectionPaused) external onlyByOwnGov {
1488         yieldCollectionPaused = _yieldCollectionPaused;
1489     }
1490 
1491     function setYieldRate(uint256 _new_rate0, bool sync_too)
1492         external
1493         onlyByOwnGov
1494     {
1495         yieldRate = _new_rate0;
1496 
1497         if (sync_too) {
1498             sync();
1499         }
1500     }
1501 
1502     function setTimelock(address _new_timelock) external onlyByOwnGov {
1503         timelock_address = _new_timelock;
1504     }
1505 
1506     /* ========== EVENTS ========== */
1507 
1508     event RewardAdded(uint256 reward, uint256 yieldRate);
1509     event OldYieldCollected(
1510         address indexed user,
1511         uint256 yield,
1512         address token_address
1513     );
1514     event YieldCollected(
1515         address indexed user,
1516         uint256 yield,
1517         address token_address
1518     );
1519     event YieldDurationUpdated(uint256 newDuration);
1520     event RecoveredERC20(address token, uint256 amount);
1521     event YieldPeriodRenewed(address token, uint256 yieldRate);
1522     event DefaultInitialization();
1523 
1524     /* ========== A CHICKEN ========== */
1525     //
1526     //         ,~.
1527     //      ,-'__ `-,
1528     //     {,-'  `. }              ,')
1529     //    ,( a )   `-.__         ,',')~,
1530     //   <=.) (         `-.__,==' ' ' '}
1531     //     (   )                      /)
1532     //      `-'\   ,                    )
1533     //          |  \        `~.        /
1534     //          \   `._        \      /
1535     //           \     `._____,'    ,'
1536     //            `-.             ,'
1537     //               `-._     _,-'
1538     //                   77jj'
1539     //                  //_||
1540     //               __//--'/`
1541     //             ,--'/`  '
1542     //
1543     // [hjw] https://textart.io/art/vw6Sa3iwqIRGkZsN1BC2vweF/chicken
1544 }