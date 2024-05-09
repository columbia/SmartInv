1 pragma solidity ^0.6.0;
2 
3 
4 // 
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
17      * @dev Returns the smallest of two numbers.
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
33 // 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // 
109 /**
110  * @dev Wrappers over Solidity's arithmetic operations with added overflow
111  * checks.
112  *
113  * Arithmetic operations in Solidity wrap on overflow. This can easily result
114  * in bugs, because programmers usually assume that an overflow raises an
115  * error, which is the standard behavior in high level programming languages.
116  * `SafeMath` restores this intuition by reverting the transaction when an
117  * operation overflows.
118  *
119  * Using this library instead of the unchecked operations eliminates an entire
120  * class of bugs, so it's recommended to use it always.
121  */
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      *
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         return sub(a, b, "SafeMath: subtraction overflow");
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      *
179      * - Multiplication cannot overflow.
180      */
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183         // benefit is lost if 'b' is also tested.
184         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185         if (a == 0) {
186             return 0;
187         }
188 
189         uint256 c = a * b;
190         require(c / a == b, "SafeMath: multiplication overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return mod(a, b, "SafeMath: modulo by zero");
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts with custom message when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b != 0, errorMessage);
261         return a % b;
262     }
263 }
264 
265 // 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
289         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
290         // for accounts without code, i.e. `keccak256('')`
291         bytes32 codehash;
292         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { codehash := extcodehash(account) }
295         return (codehash != accountHash && codehash != 0x0);
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{ value: amount }("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain`call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341       return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
351         return _functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         return _functionCallWithValue(target, data, value, errorMessage);
378     }
379 
380     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
381         require(isContract(target), "Address: call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 // 
405 /**
406  * @title SafeERC20
407  * @dev Wrappers around ERC20 operations that throw on failure (when the token
408  * contract returns false). Tokens that return no value (and instead revert or
409  * throw on failure) are also supported, non-reverting calls are assumed to be
410  * successful.
411  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
412  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
413  */
414 library SafeERC20 {
415     using SafeMath for uint256;
416     using Address for address;
417 
418     function safeTransfer(IERC20 token, address to, uint256 value) internal {
419         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
420     }
421 
422     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
423         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
424     }
425 
426     /**
427      * @dev Deprecated. This function has issues similar to the ones found in
428      * {IERC20-approve}, and its usage is discouraged.
429      *
430      * Whenever possible, use {safeIncreaseAllowance} and
431      * {safeDecreaseAllowance} instead.
432      */
433     function safeApprove(IERC20 token, address spender, uint256 value) internal {
434         // safeApprove should only be called when setting an initial allowance,
435         // or when resetting it to zero. To increase and decrease it, use
436         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
437         // solhint-disable-next-line max-line-length
438         require((value == 0) || (token.allowance(address(this), spender) == 0),
439             "SafeERC20: approve from non-zero to non-zero allowance"
440         );
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
442     }
443 
444     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).add(value);
446         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
450         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
451         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
452     }
453 
454     /**
455      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
456      * on the return value: the return value is optional (but if data is returned, it must not be false).
457      * @param token The token targeted by the call.
458      * @param data The call data (encoded using abi.encode or one of its variants).
459      */
460     function _callOptionalReturn(IERC20 token, bytes memory data) private {
461         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
462         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
463         // the target address contains contract code and also asserts for success in the low-level call.
464 
465         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
466         if (returndata.length > 0) { // Return data is optional
467             // solhint-disable-next-line max-line-length
468             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
469         }
470     }
471 }
472 
473 // 
474 /*
475  * @dev Provides information about the current execution context, including the
476  * sender of the transaction and its data. While these are generally available
477  * via msg.sender and msg.data, they should not be accessed in such a direct
478  * manner, since when dealing with GSN meta-transactions the account sending and
479  * paying for execution may not be the actual sender (as far as an application
480  * is concerned).
481  *
482  * This contract is only required for intermediate, library-like contracts.
483  */
484 abstract contract Context {
485     function _msgSender() internal view virtual returns (address payable) {
486         return msg.sender;
487     }
488 
489     function _msgData() internal view virtual returns (bytes memory) {
490         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
491         return msg.data;
492     }
493 }
494 
495 // 
496 /**
497  * @dev Contract module which provides a basic access control mechanism, where
498  * there is an account (an owner) that can be granted exclusive access to
499  * specific functions.
500  *
501  * By default, the owner account will be the one that deploys the contract. This
502  * can later be changed with {transferOwnership}.
503  *
504  * This module is used through inheritance. It will make available the modifier
505  * `onlyOwner`, which can be applied to your functions to restrict their use to
506  * the owner.
507  */
508 contract Ownable is Context {
509     address private _owner;
510 
511     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
512 
513     /**
514      * @dev Initializes the contract setting the deployer as the initial owner.
515      */
516     constructor () internal {
517         address msgSender = _msgSender();
518         _owner = msgSender;
519         emit OwnershipTransferred(address(0), msgSender);
520     }
521 
522     /**
523      * @dev Returns the address of the current owner.
524      */
525     function owner() public view returns (address) {
526         return _owner;
527     }
528 
529     /**
530      * @dev Throws if called by any account other than the owner.
531      */
532     modifier onlyOwner() {
533         require(_owner == _msgSender(), "Ownable: caller is not the owner");
534         _;
535     }
536 
537     /**
538      * @dev Leaves the contract without owner. It will not be possible to call
539      * `onlyOwner` functions anymore. Can only be called by the current owner.
540      *
541      * NOTE: Renouncing ownership will leave the contract without an owner,
542      * thereby removing any functionality that is only available to the owner.
543      */
544     function renounceOwnership() public virtual onlyOwner {
545         emit OwnershipTransferred(_owner, address(0));
546         _owner = address(0);
547     }
548 
549     /**
550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
551      * Can only be called by the current owner.
552      */
553     function transferOwnership(address newOwner) public virtual onlyOwner {
554         require(newOwner != address(0), "Ownable: new owner is the zero address");
555         emit OwnershipTransferred(_owner, newOwner);
556         _owner = newOwner;
557     }
558 }
559 
560 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNK0OkxxddddddxxxkO0KNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
561 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKOxddxxxxxkkkkkkxxxxddxOKNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
562 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xddxxkkkOOOOOOOOOOOkkkxxddk0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
563 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXkddxxkkOOO00000000000OOOOkkxddkXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
564 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNKxddxxkkOOO0000000000000OOOkkxxddxKNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
565 // MMMMMMMMMMMMMMMMMMMMMMMMWNXKK0OOkkkkkkkkkkkOOOOOOOOOOOOOkkkkkkkkkkkOO00KKXWWWMMMMMMMMMMMMMMMMMMMMMMM
566 // MMMMMMMMMMMMMMMMMMMMWWNK0OkkOOO0000KKKKK00000OOOOOOOOOO0000KKKKKKK0000OOkkO0KNWWMMMMMMMMMMMMMMMMMMMM
567 // MMMMMMMMMMMMMMMMMWWNK0kkkO00KKKXXXXXXXXXXXXXXXKKKKKKKKXXXXXXXXXXXXXXXKKK00Okkk0XNWWMMMMMMMMMMMMMMMMM
568 // MMMMMMMMMMMMMMMWWNKOkkO00KKXXXXNNNNNNNNNNNNNXXXXXXXXXXXNNNNNNNNNNNNNNNXXXKK00OkkOKNWMMMMMMMMMMMMMMMM
569 // MMMMMMMMMMMMMMWNKOkkO0KKXXXXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXXXKK0OkkOXNWWMMMMMMMMMMMMM
570 // MMMMMMMMMMMMWWX0kkO00KXXXXNNNNNNNNNNNNNNNNNNNNNNXXXXNNNNNNNNNNNNNNNNNNNNNNXXXXK00Okk0NWWMMMMMMMMMMMM
571 // MMMMMMMMMMMWNXOkkO0KKXXXXXXNNNNNNNNNNNNNXXXXXXXXXXXXXXXXXXXXXNNNNNNNNNNNNNNXXXXKK0OkxOXNWMMMMMMMMMMM
572 // MMMMMMMMMWWNKkxkO0KKXXXXXXXXXXXXXXXXXXXXXXXXXKKKKKKKKKXXXXXXXXXXXXXXXXXXXXXXXXXXKK0OkxOKNWMMMMMMMMMM
573 // MMMMMMMMWWNKkxkO0KKKXXXXXXXXXXXXXXXXXKKKKK00000OOOOO00000KKKKKXXXXXXXXXXXXXXXXXXKKK0OkxkKNWMMMMMMMMM
574 // MMMMMMMWWNKkxkO00KKKKXXXXXXXXXXKKKKKK00OOOkxdollccccllodxkkO000KKKKXXXXXXXXXXXXXKKK00OkxOKNWWMMMMMMM
575 // MMMMMMWWX0kxkO00KKKKKKKKKKKKKKKK000OOkdolcc::::cccccc::::cclodkOO000KKKKKKKKKKKKKKKK00Okxk0NWWMMMMMM
576 // MMMMMWNKOxxkO000KKKKKKKKKKK0000OOkxolcc:cllooddddddddddoolcc::cloxkOO000KKKKKKKKKKKKK00OkxxOXNWMMMMM
577 // MMMWWN0kxkkO00000KKKKKK0000OOkkdolcccloodxxkkOOOOOOOOOOkkxxdoolccccodkkOO0000KKKKKKKK000OkkxkKNWWMMM
578 // MMWNXOxxkOO0000000000000OOkkdolccloddxkOO0000KKKKKKKKKK000OOkkxdolccccodkkOO0000000000000OOkxx0XWWMM
579 // MWNXOxxkOO0000000000OOOkkxolcclodxkkO000KKKKKKKKKKKKKKKKKKKK000OkxdolcccloxkkOO00000000000OOkxxOXWWM
580 // WNKkxxkOO000000000OOkkxdocccldxkkO00KKKKKKKKKKKKKKKKKKKKKKKKKKK000OkxdolcccodxkOOO000000000OOkxxOXNW
581 // NKkxxkOOO0000000OOkkxdlcclodxkOO00KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK00OOkxdlcccldxkOOO00000000OOkxxOXN
582 // XOxxkkOO000000OOOkxxoccclodxxkkOOO00KKKKKKKKKKKKKKKKKKKKKKKKKKKK0OOOOkkxddolc:coxkkOOO000000OOkkxxOX
583 // OxxxkOOOOOOOOOOOkxdlccloodxkOO00000KKKKKKKKKKKKKKKKKKKKKKKKKKKKKK00000OOkxdollccldxkOOO00000OOOkxxx0
584 // kdxkkOOOOOOOOOkkxdlcldxkOO000000000000KKKKKKKKKKKKKKKKKKKKKKKK000000000000OkxdolcldxkOOOO0OOOOOOkxdk
585 // ddxkOOOOOOOOOkkxolcldkOO000000OOkOO000000KKKKKKKKKKKKKKKKKK00000OOkkOO000000OkxdlcloxkkOOOOOOOOOkxxx
586 // dxkkOOOOOOOOkkxolcodkOOOO000xl;,'',:dO00000KKKKKKKKKKKKKK0O000Od:,''';lx000OOOOxdlcldxkkOOOOOOOOkkxd
587 // dxkkOOOOOOOkkxdlcodkOOOO00Oo'.....  .cOKKK00KKKKKKKKKKKK0000KOc........'oO000OOOxdlcldxkkOOOOOOOkkxd
588 // dxxkkOOOOOkkxdlcldxOOOO00Kk;..''......dXK0K00KKKKKKKKKK00K0KXd....'.....;kK000OOOxdlclxxkkOOOOOkkxxd
589 // ddxkkkOOOkkxxxdddxkOOO000NO:'.........oNN0KK00KKKKKKKK0OK00NNo.........':ON000OOOkxdddxxkkkOOOkkkxdd
590 // ddxxkkkkkkxxdodxkO00OO000XKd:;,'....'c0WX00K0OOOOOOOOOkOK00XW0:'....',,:dXX00K0O00Okxdodxxkkkkkkxxdd
591 // dddxxkkxxxddocldxO0K00K000K0xlc:;;:cd0XK00KX0O00000000O0KK00KX0dc:;;:clx0K00KK00K0Oxdlclddxxkkkxxddd
592 // xdddxxxxddoolcodxkO0OO0KKK000OkxxxkO00000KKK00KKKKKKKK00KK000000OkxxxkO000KKKKOO0Okxdlccooddxxxxdddx
593 // kdooddddooolclodxkOO0OO0KKKKKKKK000000000KK00KKKKKKKKKK00KK0O0000000KKKKKKKKK0O00OkxdoccloooodddodxO
594 // 0kdooooolllcclodkkOO00OO000000000000000KKK0000KKKKKKKK00000KK0OO000000000KK0O000OOkxdocccllloooooxO0
595 // X0Oxollllccc:lodxkOO0000OO0000000000KKK00000OOkOOOOOOkOO0000KKKK000000K000000000OOkxdoc:ccclllldxOKX
596 // NXKOxdolcc:::codxkkOO0000000000000000000KK000OkkxxxxxkO0000KK000000000000000000OOkkxdlc:::cclodk0KXN
597 // WWNX0Oxdolc:;:ldxkkkOO0000KKKKKK00KKKKKK000KKKK000000KKK0000KKKKKKKKKKKKKK0000OOkkxxdl:::clodkOKXNWW
598 // MWWNNX0OkxxdooodxxkkOOO00000KKKKKKKKKKK0000KKKKKKKKKKKKKK00000KKKKKKKKKKK0000OOOkkxxollodxxkOKXNWWMM
599 // MMMWWWNXK00000OxxxkkkkOOO0000KKKKKKK00kc;;;;;;;;,,,,;;;;;;;;ck00KKKKKKK00000OOkkkkxdxO0000KKXNWWMMMM
600 // MMMMMWWWNNXXXNNKkxxkkkkOOO00000KKKK00KO:..                ..:OKKKKKKK00000OOOkkkkxxkKNXXXNNNWWMMMMMM
601 // MMMMMMMMMWWWWWWWN0kxkkkkkOOO0000000KKKKOo,....         ...,oOKKKK0000000OOOkkkkkxxOXWWWWWWWMMMMMMMMM
602 // MMMMMMMMMMMMMMMMMWKOxkkkkkkOOO0000000KKKKOxl:;'......',:ldOKKKKK000000OOOkkkkkkxkKWMMMMMMMMMMMMMMMMM
603 // MMMMMMMMMMMMMMMMMMMNKOkxkkkkkOOOOO00000000KK00OkkkkkkO00KKK000000OOOOOOkkkkkxxk0NMMMMMMMMMMMMMMMMMMM
604 // MMMMMMMMMMMMMMMMMMMMMWKOkxkkkkkkkOOO000000000000000000000000000OOOkkkkkkkxxkOKNMMMMMMMMMMMMMMMMMMMMM
605 // MMMMMMMMMMMMMMMMMMMMMMMWNK0kkxkkkkkkOOOOOOO000000000000000OOOOOOkkkkkkxkkOKNWMMMMMMMMMMMMMMMMMMMMMMM
606 // MMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0OkxxkkkkkkOOOOOOOOOOOOOOOOOOOkkkkkxxkO0KXNWMMMMMMMMMMMMMMMMMMMMMMMMMM
607 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXKOkxxkkkkkkkkkkkkkkkkkkkkkkkkxxkO0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
608 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNK0OkkkxxxxkkkkkkkkkkxxxkkO0KXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
609 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNK0OkkxxxxxxxxxxkkO0KNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
610 //
611 // Put your tendies away in mommy's purse and earn Good Boy Points!
612 //
613 // Brought to you by <3 by Tendies (https://tendies.dev), and the Good Boys Federation.
614 //
615 // Special thanks to the good boys @k06a and @AndreCronjeTech for the inspiration.
616 contract IRewardDistributionRecipient is Ownable {
617     address public rewardDistribution;
618 
619     function notifyRewardAmount(uint256 reward) external virtual {}
620 
621     modifier onlyRewardDistribution() {
622         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
623         _;
624     }
625 
626     function setRewardDistribution(address _rewardDistribution)
627         external
628         onlyOwner
629     {
630         rewardDistribution = _rewardDistribution;
631     }
632 }
633 
634 interface ITendToken {
635     function grillPool() external;
636 }
637 
638 contract LPTokenWrapper {
639     using SafeMath for uint256;
640     using SafeERC20 for IERC20;
641 
642     IERC20 public lpt;
643 
644     uint256 private _totalSupply;
645     mapping(address => uint256) private _balances;
646 
647     function totalSupply() public view returns (uint256) {
648         return _totalSupply;
649     }
650 
651     function balanceOf(address account) public view returns (uint256) {
652         return _balances[account];
653     }
654 
655     function stake(uint256 amount) public virtual {
656         _totalSupply = _totalSupply.add(amount);
657         _balances[msg.sender] = _balances[msg.sender].add(amount);
658         lpt.safeTransferFrom(msg.sender, address(this), amount);
659     }
660 
661     function withdraw(uint256 amount) public virtual {
662         _totalSupply = _totalSupply.sub(amount);
663         _balances[msg.sender] = _balances[msg.sender].sub(amount);
664         lpt.safeTransfer(msg.sender, amount);
665     }
666 }
667 
668 contract MommysPurse is LPTokenWrapper, IRewardDistributionRecipient {
669     IERC20 public gbp;
670     uint256 public duration;
671 
672     uint256 public startTime;
673     uint256 public periodFinish;
674     uint256 public rewardRate;
675     uint256 public lastUpdateTime;
676     uint256 public rewardPerTokenStored;
677     
678     mapping(address => uint256) public userRewardPerTokenPaid;
679     mapping(address => uint256) public rewards;
680 
681     event RewardAdded(uint256 reward);
682     event Staked(address indexed user, uint256 amount);
683     event Withdrawn(address indexed user, uint256 amount);
684     event RewardPaid(address indexed user, uint256 reward);
685 
686     constructor(address _gbp, address _lpt, uint256 _startTime, uint256 _durationInDays) public {
687         gbp = IERC20(_gbp);
688         lpt = IERC20(_lpt);
689         startTime = _startTime;
690         duration = _durationInDays * 1 days;
691     }
692 
693     modifier checkStart() {
694         require(block.timestamp >= startTime, "not start");
695         _;
696     }
697 
698     modifier updateReward(address account) {
699         rewardPerTokenStored = rewardPerToken();
700         lastUpdateTime = lastTimeRewardApplicable();
701         if (account != address(0)) {
702             rewards[account] = earned(account);
703             userRewardPerTokenPaid[account] = rewardPerTokenStored;
704         }
705         _;
706     }
707 
708     function lastTimeRewardApplicable() public view returns (uint256) {
709         return Math.min(block.timestamp, periodFinish);
710     }
711 
712     function rewardPerToken() public view returns (uint256) {
713         if (totalSupply() == 0) {
714             return rewardPerTokenStored;
715         }
716         return
717             rewardPerTokenStored.add(
718                 lastTimeRewardApplicable()
719                     .sub(lastUpdateTime)
720                     .mul(rewardRate)
721                     .mul(1e18)
722                     .div(totalSupply())
723             );
724     }
725 
726     function earned(address account) public view returns (uint256) {
727         return
728             balanceOf(account)
729                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
730                 .div(1e18)
731                 .add(rewards[account]);
732     }
733 
734     function stake(uint256 amount) public override updateReward(msg.sender) checkStart /*alwaysGrill*/ {
735         require(amount > 0, "Cannot stake 0");
736         super.stake(amount);
737         emit Staked(msg.sender, amount);
738     }
739 
740     function withdraw(uint256 amount) public override updateReward(msg.sender) checkStart {
741         require(amount > 0, "Cannot withdraw 0");
742         super.withdraw(amount);
743         emit Withdrawn(msg.sender, amount);
744     }
745 
746     function exit() external {
747         withdraw(balanceOf(msg.sender));
748         getReward();
749     }
750 
751     function getReward() public updateReward(msg.sender) checkStart {
752         uint256 reward = earned(msg.sender);
753         if (reward > 0) {
754             rewards[msg.sender] = 0;
755             gbp.safeTransfer(msg.sender, reward);
756             emit RewardPaid(msg.sender, reward);
757         }
758     }
759 
760     function notifyRewardAmount(uint256 reward)
761         external override
762         onlyRewardDistribution
763         updateReward(address(0))
764     {
765         if (block.timestamp > startTime) {
766           if (block.timestamp >= periodFinish) {
767               rewardRate = reward.div(duration);
768           } else {
769               uint256 remaining = periodFinish.sub(block.timestamp);
770               uint256 leftover = remaining.mul(rewardRate);
771               rewardRate = reward.add(leftover).div(duration);
772           }
773           lastUpdateTime = block.timestamp;
774           periodFinish = block.timestamp.add(duration);
775           emit RewardAdded(reward);
776         } else {
777           rewardRate = reward.div(duration);
778           lastUpdateTime = startTime;
779           periodFinish = startTime.add(duration);
780           emit RewardAdded(reward);
781         }
782     }
783 }