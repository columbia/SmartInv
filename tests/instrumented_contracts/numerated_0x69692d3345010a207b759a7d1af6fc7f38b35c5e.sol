1 pragma solidity =0.6.6;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 // 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () internal {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(_owner == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 // 
90 /**
91  * @dev Interface of the ERC20 standard as defined in the EIP.
92  */
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98 
99     /**
100      * @dev Returns the amount of tokens owned by `account`.
101      */
102     function balanceOf(address account) external view returns (uint256);
103 
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(address recipient, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121 
122     /**
123      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * IMPORTANT: Beware that changing an allowance with this method brings the risk
128      * that someone may use both the old and the new allowance by unfortunate
129      * transaction ordering. One possible solution to mitigate this race
130      * condition is to first reduce the spender's allowance to 0 and set the
131      * desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address spender, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Moves `amount` tokens from `sender` to `recipient` using the
140      * allowance mechanism. `amount` is then deducted from the caller's
141      * allowance.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 // 
165 /**
166  * @dev Wrappers over Solidity's arithmetic operations with added overflow
167  * checks.
168  *
169  * Arithmetic operations in Solidity wrap on overflow. This can easily result
170  * in bugs, because programmers usually assume that an overflow raises an
171  * error, which is the standard behavior in high level programming languages.
172  * `SafeMath` restores this intuition by reverting the transaction when an
173  * operation overflows.
174  *
175  * Using this library instead of the unchecked operations eliminates an entire
176  * class of bugs, so it's recommended to use it always.
177  */
178 library SafeMath {
179     /**
180      * @dev Returns the addition of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `+` operator.
184      *
185      * Requirements:
186      *
187      * - Addition cannot overflow.
188      */
189     function add(uint256 a, uint256 b) internal pure returns (uint256) {
190         uint256 c = a + b;
191         require(c >= a, "SafeMath: addition overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
207         return sub(a, b, "SafeMath: subtraction overflow");
208     }
209 
210     /**
211      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
212      * overflow (when the result is negative).
213      *
214      * Counterpart to Solidity's `-` operator.
215      *
216      * Requirements:
217      *
218      * - Subtraction cannot overflow.
219      */
220     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b <= a, errorMessage);
222         uint256 c = a - b;
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the multiplication of two unsigned integers, reverting on
229      * overflow.
230      *
231      * Counterpart to Solidity's `*` operator.
232      *
233      * Requirements:
234      *
235      * - Multiplication cannot overflow.
236      */
237     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
238         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
239         // benefit is lost if 'b' is also tested.
240         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
241         if (a == 0) {
242             return 0;
243         }
244 
245         uint256 c = a * b;
246         require(c / a == b, "SafeMath: multiplication overflow");
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers. Reverts on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(uint256 a, uint256 b) internal pure returns (uint256) {
264         return div(a, b, "SafeMath: division by zero");
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b > 0, errorMessage);
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289      * Reverts when dividing by zero.
290      *
291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
292      * opcode (which leaves remaining gas untouched) while Solidity uses an
293      * invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         return mod(a, b, "SafeMath: modulo by zero");
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * Reverts with custom message when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b != 0, errorMessage);
317         return a % b;
318     }
319 }
320 
321 // 
322 /**
323  * @dev Collection of functions related to the address type
324  */
325 library Address {
326     /**
327      * @dev Returns true if `account` is a contract.
328      *
329      * [IMPORTANT]
330      * ====
331      * It is unsafe to assume that an address for which this function returns
332      * false is an externally-owned account (EOA) and not a contract.
333      *
334      * Among others, `isContract` will return false for the following
335      * types of addresses:
336      *
337      *  - an externally-owned account
338      *  - a contract in construction
339      *  - an address where a contract will be created
340      *  - an address where a contract lived, but was destroyed
341      * ====
342      */
343     function isContract(address account) internal view returns (bool) {
344         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
345         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
346         // for accounts without code, i.e. `keccak256('')`
347         bytes32 codehash;
348         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
349         // solhint-disable-next-line no-inline-assembly
350         assembly { codehash := extcodehash(account) }
351         return (codehash != accountHash && codehash != 0x0);
352     }
353 
354     /**
355      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
356      * `recipient`, forwarding all available gas and reverting on errors.
357      *
358      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
359      * of certain opcodes, possibly making contracts go over the 2300 gas limit
360      * imposed by `transfer`, making them unable to receive funds via
361      * `transfer`. {sendValue} removes this limitation.
362      *
363      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
364      *
365      * IMPORTANT: because control is transferred to `recipient`, care must be
366      * taken to not create reentrancy vulnerabilities. Consider using
367      * {ReentrancyGuard} or the
368      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
369      */
370     function sendValue(address payable recipient, uint256 amount) internal {
371         require(address(this).balance >= amount, "Address: insufficient balance");
372 
373         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
374         (bool success, ) = recipient.call{ value: amount }("");
375         require(success, "Address: unable to send value, recipient may have reverted");
376     }
377 
378     /**
379      * @dev Performs a Solidity function call using a low level `call`. A
380      * plain`call` is an unsafe replacement for a function call: use this
381      * function instead.
382      *
383      * If `target` reverts with a revert reason, it is bubbled up by this
384      * function (like regular Solidity function calls).
385      *
386      * Returns the raw returned data. To convert to the expected return value,
387      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388      *
389      * Requirements:
390      *
391      * - `target` must be a contract.
392      * - calling `target` with `data` must not revert.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
397       return functionCall(target, data, "Address: low-level call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
402      * `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
407         return _functionCallWithValue(target, data, 0, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but also transferring `value` wei to `target`.
413      *
414      * Requirements:
415      *
416      * - the calling contract must have an ETH balance of at least `value`.
417      * - the called Solidity function must be `payable`.
418      *
419      * _Available since v3.1._
420      */
421     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
427      * with `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
432         require(address(this).balance >= value, "Address: insufficient balance for call");
433         return _functionCallWithValue(target, data, value, errorMessage);
434     }
435 
436     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
437         require(isContract(target), "Address: call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 // solhint-disable-next-line no-inline-assembly
449                 assembly {
450                     let returndata_size := mload(returndata)
451                     revert(add(32, returndata), returndata_size)
452                 }
453             } else {
454                 revert(errorMessage);
455             }
456         }
457     }
458 }
459 
460 // 
461 /**
462  * @title SafeERC20
463  * @dev Wrappers around ERC20 operations that throw on failure (when the token
464  * contract returns false). Tokens that return no value (and instead revert or
465  * throw on failure) are also supported, non-reverting calls are assumed to be
466  * successful.
467  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
468  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
469  */
470 library SafeERC20 {
471     using SafeMath for uint256;
472     using Address for address;
473 
474     function safeTransfer(IERC20 token, address to, uint256 value) internal {
475         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
476     }
477 
478     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
479         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
480     }
481 
482     /**
483      * @dev Deprecated. This function has issues similar to the ones found in
484      * {IERC20-approve}, and its usage is discouraged.
485      *
486      * Whenever possible, use {safeIncreaseAllowance} and
487      * {safeDecreaseAllowance} instead.
488      */
489     function safeApprove(IERC20 token, address spender, uint256 value) internal {
490         // safeApprove should only be called when setting an initial allowance,
491         // or when resetting it to zero. To increase and decrease it, use
492         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
493         // solhint-disable-next-line max-line-length
494         require((value == 0) || (token.allowance(address(this), spender) == 0),
495             "SafeERC20: approve from non-zero to non-zero allowance"
496         );
497         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
498     }
499 
500     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
501         uint256 newAllowance = token.allowance(address(this), spender).add(value);
502         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
503     }
504 
505     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
506         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
507         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
508     }
509 
510     /**
511      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
512      * on the return value: the return value is optional (but if data is returned, it must not be false).
513      * @param token The token targeted by the call.
514      * @param data The call data (encoded using abi.encode or one of its variants).
515      */
516     function _callOptionalReturn(IERC20 token, bytes memory data) private {
517         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
518         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
519         // the target address contains contract code and also asserts for success in the low-level call.
520 
521         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
522         if (returndata.length > 0) { // Return data is optional
523             // solhint-disable-next-line max-line-length
524             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
525         }
526     }
527 }
528 
529 // @&#%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
530 // @&@@%&@@&&&&%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
531 // @@&@(....,*#&@@@&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
532 // @@@@&/..........*(%@@@&%#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
533 // @@@&&%*..............,*(#%&@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
534 // @@@@&@#......................*#&@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
535 // @@@@&%@(..........................,(&@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
536 // @@@@@&&@(,.............................*/#@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
537 // @@@@@@@&@(,.................................*#&@@%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
538 // @@@@@@@&&@#,....................................,/%@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
539 // @@@@@@@@@&@#,.......................................,*#&@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
540 // @@@@@@@@@@&@(............................................,(&@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
541 // @@@@@@@@@@@@@/...............................................,/#@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
542 // @@@@@@@@@@@@&@(..................................................*#%@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
543 // @@@@@@@@@@@@@&@/......................................................,/&@&@@@@@@@@@@@@@@@@@@@@@@@@@
544 // @@@@@@@@@@@@@%&@/.........................................................,/#%%%&@@@@@@@@@@@@@@@@@@@
545 // @@@@@@@@@@@@@@%@@(......................................,**/((((((((((((/*,....*(%&@@@@@@@@@@@@@@@@@
546 // @@@@@@@@@@@@@@@#@@*............................,,/%&&@@@@&#(/*,,,,,,,,,,/#&@@%((/*%@@#@@@@@@@@@@@@@@
547 // @@@@@@@@@@@@@@@&%@#.................,,/#%&@@@@@&%#/*,,,.,,,,,,,,,,,,,,,,,,,,.,,*(%&@@@@@&@@@@@@@@@@@
548 // @@@@@@@@@@@@@@@@@%@*.........*(#&@@@&%#/*,...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,..*(&@@%@@@@@@@@@
549 // @@@@@@@@@@@@@@@@@&&@*....(&@@@%*,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@&@@@@@@@@
550 // @@@@@@@@@@@@@@@@@@%@@@@@@@@(,,,,,,,,,,,.....,,,,...,,,,,,,,,,,,,,,,,,,,,,,,(&/.,,,,,,,,,,,*&&&@@@@@@
551 // @@@@@@@@@@@@@@@@@@@@@@@@@&&@(,,,,,*(%&@@@@@@@@@@@@@@&(,,,,,,,,,,,,,,,,,,,*%@(,,,,,,,,,,,,,,*#@@@@@@@
552 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@(%@@@@@@&#/*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@(,,,,,,,,,,,,,,,,*%&@@@@@
553 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@/,,,,./%@@&%/,,,,,,,,,,,,,,,,,,,,,,,,,,.*(#@@(,,,,,,,,,,,,,,,,,,*%@@@@@
554 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@/,,*&@@@%#######(*,,,,,,,,,,,,,,,,,,,,.(@%/*.,,,,,,,,,,,,,,,,,,,.(@%@@@
555 // @@@@@@@@@@@@@@@@@@@@@@@@@@&@&*/%@@@@@%/%@@@@%(&&&@@&#,,,,,,,,,,,,,,.&@*,,,,,,,,,,,,,,,,,,,,,,.*%@&@@
556 // @@@@@@@@@@@@@@@@@@@@@@@@@&@%*.*%@&,,#@%//(##(#&/.*#@&*,,,,,,,,,,,,,,,.,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
557 // @@@@@@@@@@@@@@@@@@@@@@@@@@%*,,,.*%&@@@@@@@@@@@@@@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
558 // @@@@@@@@@@@@@@@@@@@@@@%&@#,,,,,,,,,,**,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
559 // @@@@@@@@@@@@@@@@@@@@@&@%*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
560 // @@@@@@@@@@@@@@@@@@@&@&*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(%@@@@@&/,,,,,,,,,,,,,,.(&&@@
561 // @@@@@@@@@@@@@@@@@#@%.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.*&@%/,,..,*%@#,,,,,,,,,,,,.(&&@@
562 // @@@@@@@@@@@@@@@&%@%,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,./@#.,#&%(,.,%@*,,,,,,,,,,,,(@&@@
563 // @@@@@@@@@@@@@@&&@%.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.*@&*/@(*&%*,#@*,,,,,,,,,,.*&&@@@
564 // @@@@@@@@@@@@@&@&*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#%/.,*&%*,#@*,,,,,,,,,,*%&&@@@
565 // @@@@@@@@@@&&@%/,,,,,,,,(%&&%(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/*,,,,,,,,*/*/&%*,#@*,,,,,,,,,,(@&@@@@
566 // @@@@@@@@@%&@(,,,,,,,,/&%*.,#@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@@/,,,,,*&@@@#,,,#@*,,,,,,,,,(@@@@@@@
567 // @@@@@@@@&&%,.,,,,,,,,,,,,,,,(@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#@%,,,,*(/.,,,./&&*,,,,,,,*%@@@@@@@@
568 // @@@@@@@@@&@@(*,,,,,,,*#&&&(,,...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@%.,,,,,,/%&&@&/,,,,,,,*&@((@@@@@@
569 // @@@@@@@@@@@@%&@@@@@@@@&%&@@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@/.,,,,,,....,,,,,,,.(@%*.*%@@&&%
570 // @@@@@@@@@@@@@@@@@@@@@@@&@&/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@(.,,,,,,,*,,,,,,,./#/,,.*%@@@@@
571 // @@@@@@@@@@@@@@@@@@@@&&@@@@&#*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(@#.,,,,,,/&%*,,,,,,,,,,,,.(@@@@@
572 // @@@@@@@@@@@@@@@@@%@@%*,,,,,*/,,(%(.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@#.,,,,,,,(@#,,,,,,,,,,,,.*%&@@@
573 // @@@@@@@@@@@@@@@@%@&,,,,,,,,,,,,,#@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,.*(&@#.,,,,,,,./&#,,,,,,,,,,,,.*%&@@@
574 // @@@@@@@@@@@@@@@@#@&##&@@@@@@@@@@&&@%,,,,,,,,,,,,,,,,,,,,,,,,,*(&@%*,,,,,,,,,,./&#,,,,,,,,,,,,.*%&@@@
575 // @@@@@@@@@@@@@@@@@@%@@%*,,,,,,,,,,,(/,,,,,,,,,,,,,,,,,,,,,,*%@%/,,,,,,,,,,,,,,./&#,,,,,,,,,,,,.*%&&@@
576 // @@@@@@@@@@@@@@@@@@&@@@#*,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@&(,,,,,,,,,,,,,,,,,,/&#,,,,,,,,,,,,,,(&&@@
577 // @@@@@@@@@@@@@@@@@@@@&@@@&@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,*#/.,,,,,,,,,,,,,,,,,,#@(,,,,,,,,,,,,,.(&&@@
578 // @@@@@@@@@@@@@@@@@@@@@&&@(.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%@%*,,,,,,,,,,,,,.(&&@@
579 // @@@@@@@@@@@@@@@@@@@@@&&&/.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,*(#&&#*.,,,,,,,,,,,,,,.(&&@@
580 // @@@@@@@@@@@@@@@@@&%@@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%@@@&(*,.,,,,,,,,,,,,,,,,,.(@%@@
581 // @@@@@@@@@@@@@@&@@%/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/#&@@@&#/*,,,,,,,,,,,,,,,,,,,,,,,,,*%&@@
582 // @@@@@@@@@@@@@%@&,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/(%@@@%(*,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%&@@
583 // @@@@@@@@@@@@&@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,/%&@@@@&/*,,.,,,,,,,,,,,,,,,,*#/.,,,,,,,,,,,,,,,,*%&@@
584 // @@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,*#&@@&%%@@@@@(.,,,,,,,,,,,,,,,,,,,,(@(.,,,,,,,,,,,,,,,,*%@&@
585 // @@@@@@@@@@@@@%&@&%/,,,,,,,,,,,,,,,,,,*#@@&@@@@@@@@@@@%,,,,,,,,,,,,,,,,,,,,*%@/.,,,,,,,,,,,,,,,,.(&&@
586 // @@@@@@@@@@@@@@@@@&%@@%(///*,......*%@@&&@@@@@@@@@@@@&@&*,,,,,,,,,,,,,,,,,/@&/,,,,,,,,,,,,,,,,,,.(@&@
587 // @@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&%@@@@@@@@@@@@@@@@@&&&(,,,,,,,,,,,,,,,(@%*,,,,,,,,,,,,,,,,,,,.*%&@
588 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@%,,,,,,,,,,,,#@&/.,,,,,,,,,,,,,,,,,.*//(&&@
589 // $CHADS Vesting Contracts (true CHADS do not dump on their frens) adapted from OZ
590 // @dev airblush@protonmail.com (virgin@protonmail.com was taken)
591 contract TokenVesting {
592     using SafeMath for uint256;
593     using SafeERC20 for IERC20;
594 
595     address public immutable beneficiary;
596 
597     uint256 public immutable cliff;
598     uint256 public immutable start;
599     uint256 public immutable duration;
600 
601     mapping (address => uint256) public released;
602 
603     event Released(uint256 amount);
604 
605     constructor(
606         address _beneficiary,
607         uint256 _start,
608         uint256 _cliff,
609         uint256 _duration
610     )
611     public
612     {
613         require(_beneficiary != address(0));
614         require(_cliff <= _duration);
615 
616         beneficiary = _beneficiary;
617         duration = _duration;
618         cliff = _start.add(_cliff);
619         start = _start;
620     }
621 
622     function release(IERC20 _token) external {
623         uint256 unreleased = releasableAmount(_token);
624 
625         require(unreleased > 0);
626 
627         released[address(_token)] = released[address(_token)].add(unreleased);
628 
629         _token.safeTransfer(beneficiary, unreleased);
630 
631         emit Released(unreleased);
632     }
633 
634     function releasableAmount(IERC20 _token) public view returns (uint256) {
635         return vestedAmount(_token).sub(released[address(_token)]);
636     }
637 
638     function vestedAmount(IERC20 _token) public view returns (uint256) {
639         uint256 currentBalance = _token.balanceOf(address(this));
640         uint256 totalBalance = currentBalance.add(released[address(_token)]);
641 
642         if (block.timestamp < cliff) {
643             return 0;
644         } else if (block.timestamp >= start.add(duration)) {
645             return totalBalance;
646         } else {
647             return totalBalance.mul(block.timestamp.sub(start)).div(duration);
648         }
649     }
650 }
651 
652 // @&#%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
653 // @&@@%&@@&&&&%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
654 // @@&@(....,*#&@@@&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
655 // @@@@&/..........*(%@@@&%#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
656 // @@@&&%*..............,*(#%&@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
657 // @@@@&@#......................*#&@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
658 // @@@@&%@(..........................,(&@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
659 // @@@@@&&@(,.............................*/#@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
660 // @@@@@@@&@(,.................................*#&@@%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
661 // @@@@@@@&&@#,....................................,/%@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
662 // @@@@@@@@@&@#,.......................................,*#&@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
663 // @@@@@@@@@@&@(............................................,(&@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
664 // @@@@@@@@@@@@@/...............................................,/#@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
665 // @@@@@@@@@@@@&@(..................................................*#%@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
666 // @@@@@@@@@@@@@&@/......................................................,/&@&@@@@@@@@@@@@@@@@@@@@@@@@@
667 // @@@@@@@@@@@@@%&@/.........................................................,/#%%%&@@@@@@@@@@@@@@@@@@@
668 // @@@@@@@@@@@@@@%@@(......................................,**/((((((((((((/*,....*(%&@@@@@@@@@@@@@@@@@
669 // @@@@@@@@@@@@@@@#@@*............................,,/%&&@@@@&#(/*,,,,,,,,,,/#&@@%((/*%@@#@@@@@@@@@@@@@@
670 // @@@@@@@@@@@@@@@&%@#.................,,/#%&@@@@@&%#/*,,,.,,,,,,,,,,,,,,,,,,,,.,,*(%&@@@@@&@@@@@@@@@@@
671 // @@@@@@@@@@@@@@@@@%@*.........*(#&@@@&%#/*,...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,..*(&@@%@@@@@@@@@
672 // @@@@@@@@@@@@@@@@@&&@*....(&@@@%*,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@&@@@@@@@@
673 // @@@@@@@@@@@@@@@@@@%@@@@@@@@(,,,,,,,,,,,.....,,,,...,,,,,,,,,,,,,,,,,,,,,,,,(&/.,,,,,,,,,,,*&&&@@@@@@
674 // @@@@@@@@@@@@@@@@@@@@@@@@@&&@(,,,,,*(%&@@@@@@@@@@@@@@&(,,,,,,,,,,,,,,,,,,,*%@(,,,,,,,,,,,,,,*#@@@@@@@
675 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@(%@@@@@@&#/*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@(,,,,,,,,,,,,,,,,*%&@@@@@
676 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@/,,,,./%@@&%/,,,,,,,,,,,,,,,,,,,,,,,,,,.*(#@@(,,,,,,,,,,,,,,,,,,*%@@@@@
677 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@/,,*&@@@%#######(*,,,,,,,,,,,,,,,,,,,,.(@%/*.,,,,,,,,,,,,,,,,,,,.(@%@@@
678 // @@@@@@@@@@@@@@@@@@@@@@@@@@&@&*/%@@@@@%/%@@@@%(&&&@@&#,,,,,,,,,,,,,,.&@*,,,,,,,,,,,,,,,,,,,,,,.*%@&@@
679 // @@@@@@@@@@@@@@@@@@@@@@@@@&@%*.*%@&,,#@%//(##(#&/.*#@&*,,,,,,,,,,,,,,,.,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
680 // @@@@@@@@@@@@@@@@@@@@@@@@@@%*,,,.*%&@@@@@@@@@@@@@@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
681 // @@@@@@@@@@@@@@@@@@@@@@%&@#,,,,,,,,,,**,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
682 // @@@@@@@@@@@@@@@@@@@@@&@%*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
683 // @@@@@@@@@@@@@@@@@@@&@&*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(%@@@@@&/,,,,,,,,,,,,,,.(&&@@
684 // @@@@@@@@@@@@@@@@@#@%.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.*&@%/,,..,*%@#,,,,,,,,,,,,.(&&@@
685 // @@@@@@@@@@@@@@@&%@%,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,./@#.,#&%(,.,%@*,,,,,,,,,,,,(@&@@
686 // @@@@@@@@@@@@@@&&@%.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.*@&*/@(*&%*,#@*,,,,,,,,,,.*&&@@@
687 // @@@@@@@@@@@@@&@&*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#%/.,*&%*,#@*,,,,,,,,,,*%&&@@@
688 // @@@@@@@@@@&&@%/,,,,,,,,(%&&%(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/*,,,,,,,,*/*/&%*,#@*,,,,,,,,,,(@&@@@@
689 // @@@@@@@@@%&@(,,,,,,,,/&%*.,#@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@@/,,,,,*&@@@#,,,#@*,,,,,,,,,(@@@@@@@
690 // @@@@@@@@&&%,.,,,,,,,,,,,,,,,(@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#@%,,,,*(/.,,,./&&*,,,,,,,*%@@@@@@@@
691 // @@@@@@@@@&@@(*,,,,,,,*#&&&(,,...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@%.,,,,,,/%&&@&/,,,,,,,*&@((@@@@@@
692 // @@@@@@@@@@@@%&@@@@@@@@&%&@@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@/.,,,,,,....,,,,,,,.(@%*.*%@@&&%
693 // @@@@@@@@@@@@@@@@@@@@@@@&@&/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@(.,,,,,,,*,,,,,,,./#/,,.*%@@@@@
694 // @@@@@@@@@@@@@@@@@@@@&&@@@@&#*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(@#.,,,,,,/&%*,,,,,,,,,,,,.(@@@@@
695 // @@@@@@@@@@@@@@@@@%@@%*,,,,,*/,,(%(.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@#.,,,,,,,(@#,,,,,,,,,,,,.*%&@@@
696 // @@@@@@@@@@@@@@@@%@&,,,,,,,,,,,,,#@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,.*(&@#.,,,,,,,./&#,,,,,,,,,,,,.*%&@@@
697 // @@@@@@@@@@@@@@@@#@&##&@@@@@@@@@@&&@%,,,,,,,,,,,,,,,,,,,,,,,,,*(&@%*,,,,,,,,,,./&#,,,,,,,,,,,,.*%&@@@
698 // @@@@@@@@@@@@@@@@@@%@@%*,,,,,,,,,,,(/,,,,,,,,,,,,,,,,,,,,,,*%@%/,,,,,,,,,,,,,,./&#,,,,,,,,,,,,.*%&&@@
699 // @@@@@@@@@@@@@@@@@@&@@@#*,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@&(,,,,,,,,,,,,,,,,,,/&#,,,,,,,,,,,,,,(&&@@
700 // @@@@@@@@@@@@@@@@@@@@&@@@&@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,*#/.,,,,,,,,,,,,,,,,,,#@(,,,,,,,,,,,,,.(&&@@
701 // @@@@@@@@@@@@@@@@@@@@@&&@(.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%@%*,,,,,,,,,,,,,.(&&@@
702 // @@@@@@@@@@@@@@@@@@@@@&&&/.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,*(#&&#*.,,,,,,,,,,,,,,.(&&@@
703 // @@@@@@@@@@@@@@@@@&%@@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%@@@&(*,.,,,,,,,,,,,,,,,,,.(@%@@
704 // @@@@@@@@@@@@@@&@@%/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/#&@@@&#/*,,,,,,,,,,,,,,,,,,,,,,,,,*%&@@
705 // @@@@@@@@@@@@@%@&,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/(%@@@%(*,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%&@@
706 // @@@@@@@@@@@@&@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,/%&@@@@&/*,,.,,,,,,,,,,,,,,,,*#/.,,,,,,,,,,,,,,,,*%&@@
707 // @@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,*#&@@&%%@@@@@(.,,,,,,,,,,,,,,,,,,,,(@(.,,,,,,,,,,,,,,,,*%@&@
708 // @@@@@@@@@@@@@%&@&%/,,,,,,,,,,,,,,,,,,*#@@&@@@@@@@@@@@%,,,,,,,,,,,,,,,,,,,,*%@/.,,,,,,,,,,,,,,,,.(&&@
709 // @@@@@@@@@@@@@@@@@&%@@%(///*,......*%@@&&@@@@@@@@@@@@&@&*,,,,,,,,,,,,,,,,,/@&/,,,,,,,,,,,,,,,,,,.(@&@
710 // @@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&%@@@@@@@@@@@@@@@@@&&&(,,,,,,,,,,,,,,,(@%*,,,,,,,,,,,,,,,,,,,.*%&@
711 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@%,,,,,,,,,,,,#@&/.,,,,,,,,,,,,,,,,,.*//(&&@
712 // $CHADS Timelock Contract for burn reserves, adapted from OZ
713 // @dev airblush@protonmail.com (virgin@protonmail.com was taken)
714 contract TokenTimelock {
715     using SafeERC20 for IERC20;
716 
717     address public immutable beneficiary;
718 
719     uint256 public immutable releaseTime;
720 
721     constructor(
722         address _beneficiary,
723         uint256 _releaseTime
724     )
725     public
726     {
727         // solium-disable-next-line security/no-block-members
728         require(_releaseTime > block.timestamp);
729         beneficiary = _beneficiary;
730         releaseTime = _releaseTime;
731     }
732 
733     function release(IERC20 _token) public {
734         // solium-disable-next-line security/no-block-members
735         require(block.timestamp >= releaseTime);
736 
737         uint256 amount = _token.balanceOf(address(this));
738         require(amount > 0);
739 
740         _token.safeTransfer(beneficiary, amount);
741     }
742 }
743 
744 // 
745 /**
746  * @dev Contract module which allows children to implement an emergency stop
747  * mechanism that can be triggered by an authorized account.
748  *
749  * This module is used through inheritance. It will make available the
750  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
751  * the functions of your contract. Note that they will not be pausable by
752  * simply including this module, only once the modifiers are put in place.
753  */
754 contract Pausable is Context {
755     /**
756      * @dev Emitted when the pause is triggered by `account`.
757      */
758     event Paused(address account);
759 
760     /**
761      * @dev Emitted when the pause is lifted by `account`.
762      */
763     event Unpaused(address account);
764 
765     bool private _paused;
766 
767     /**
768      * @dev Initializes the contract in unpaused state.
769      */
770     constructor () internal {
771         _paused = false;
772     }
773 
774     /**
775      * @dev Returns true if the contract is paused, and false otherwise.
776      */
777     function paused() public view returns (bool) {
778         return _paused;
779     }
780 
781     /**
782      * @dev Modifier to make a function callable only when the contract is not paused.
783      *
784      * Requirements:
785      *
786      * - The contract must not be paused.
787      */
788     modifier whenNotPaused() {
789         require(!_paused, "Pausable: paused");
790         _;
791     }
792 
793     /**
794      * @dev Modifier to make a function callable only when the contract is paused.
795      *
796      * Requirements:
797      *
798      * - The contract must be paused.
799      */
800     modifier whenPaused() {
801         require(_paused, "Pausable: not paused");
802         _;
803     }
804 
805     /**
806      * @dev Triggers stopped state.
807      *
808      * Requirements:
809      *
810      * - The contract must not be paused.
811      */
812     function _pause() internal virtual whenNotPaused {
813         _paused = true;
814         emit Paused(_msgSender());
815     }
816 
817     /**
818      * @dev Returns to normal state.
819      *
820      * Requirements:
821      *
822      * - The contract must be paused.
823      */
824     function _unpause() internal virtual whenPaused {
825         _paused = false;
826         emit Unpaused(_msgSender());
827     }
828 }
829 
830 // 
831 /**
832  * @dev Implementation of the {IERC20} interface.
833  *
834  * This implementation is agnostic to the way tokens are created. This means
835  * that a supply mechanism has to be added in a derived contract using {_mint}.
836  * For a generic mechanism see {ERC20PresetMinterPauser}.
837  *
838  * TIP: For a detailed writeup see our guide
839  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
840  * to implement supply mechanisms].
841  *
842  * We have followed general OpenZeppelin guidelines: functions revert instead
843  * of returning `false` on failure. This behavior is nonetheless conventional
844  * and does not conflict with the expectations of ERC20 applications.
845  *
846  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
847  * This allows applications to reconstruct the allowance for all accounts just
848  * by listening to said events. Other implementations of the EIP may not emit
849  * these events, as it isn't required by the specification.
850  *
851  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
852  * functions have been added to mitigate the well-known issues around setting
853  * allowances. See {IERC20-approve}.
854  */
855 contract ERC20 is Context, IERC20 {
856     using SafeMath for uint256;
857     using Address for address;
858 
859     mapping (address => uint256) internal _balances;
860 
861     mapping (address => mapping (address => uint256)) private _allowances;
862 
863     uint256 internal _totalSupply;
864 
865     string private _name;
866     string private _symbol;
867     uint8 private _decimals;
868 
869     /**
870      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
871      * a default value of 18.
872      *
873      * To select a different value for {decimals}, use {_setupDecimals}.
874      *
875      * All three of these values are immutable: they can only be set once during
876      * construction.
877      */
878     constructor (string memory name, string memory symbol) public {
879         _name = name;
880         _symbol = symbol;
881         _decimals = 18;
882     }
883 
884     /**
885      * @dev Returns the name of the token.
886      */
887     function name() public view returns (string memory) {
888         return _name;
889     }
890 
891     /**
892      * @dev Returns the symbol of the token, usually a shorter version of the
893      * name.
894      */
895     function symbol() public view returns (string memory) {
896         return _symbol;
897     }
898 
899     /**
900      * @dev Returns the number of decimals used to get its user representation.
901      * For example, if `decimals` equals `2`, a balance of `505` tokens should
902      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
903      *
904      * Tokens usually opt for a value of 18, imitating the relationship between
905      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
906      * called.
907      *
908      * NOTE: This information is only used for _display_ purposes: it in
909      * no way affects any of the arithmetic of the contract, including
910      * {IERC20-balanceOf} and {IERC20-transfer}.
911      */
912     function decimals() public view returns (uint8) {
913         return _decimals;
914     }
915 
916     /**
917      * @dev See {IERC20-totalSupply}.
918      */
919     function totalSupply() public view override returns (uint256) {
920         return _totalSupply;
921     }
922 
923     /**
924      * @dev See {IERC20-balanceOf}.
925      */
926     function balanceOf(address account) public view override returns (uint256) {
927         return _balances[account];
928     }
929 
930     /**
931      * @dev See {IERC20-transfer}.
932      *
933      * Requirements:
934      *
935      * - `recipient` cannot be the zero address.
936      * - the caller must have a balance of at least `amount`.
937      */
938     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
939         _transfer(_msgSender(), recipient, amount);
940         return true;
941     }
942 
943     /**
944      * @dev See {IERC20-allowance}.
945      */
946     function allowance(address owner, address spender) public view virtual override returns (uint256) {
947         return _allowances[owner][spender];
948     }
949 
950     /**
951      * @dev See {IERC20-approve}.
952      *
953      * Requirements:
954      *
955      * - `spender` cannot be the zero address.
956      */
957     function approve(address spender, uint256 amount) public virtual override returns (bool) {
958         _approve(_msgSender(), spender, amount);
959         return true;
960     }
961 
962     /**
963      * @dev See {IERC20-transferFrom}.
964      *
965      * Emits an {Approval} event indicating the updated allowance. This is not
966      * required by the EIP. See the note at the beginning of {ERC20};
967      *
968      * Requirements:
969      * - `sender` and `recipient` cannot be the zero address.
970      * - `sender` must have a balance of at least `amount`.
971      * - the caller must have allowance for ``sender``'s tokens of at least
972      * `amount`.
973      */
974     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
975         _transfer(sender, recipient, amount);
976         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
977         return true;
978     }
979 
980     /**
981      * @dev Atomically increases the allowance granted to `spender` by the caller.
982      *
983      * This is an alternative to {approve} that can be used as a mitigation for
984      * problems described in {IERC20-approve}.
985      *
986      * Emits an {Approval} event indicating the updated allowance.
987      *
988      * Requirements:
989      *
990      * - `spender` cannot be the zero address.
991      */
992     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
993         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
994         return true;
995     }
996 
997     /**
998      * @dev Atomically decreases the allowance granted to `spender` by the caller.
999      *
1000      * This is an alternative to {approve} that can be used as a mitigation for
1001      * problems described in {IERC20-approve}.
1002      *
1003      * Emits an {Approval} event indicating the updated allowance.
1004      *
1005      * Requirements:
1006      *
1007      * - `spender` cannot be the zero address.
1008      * - `spender` must have allowance for the caller of at least
1009      * `subtractedValue`.
1010      */
1011     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1012         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1013         return true;
1014     }
1015 
1016     /**
1017      * @dev Moves tokens `amount` from `sender` to `recipient`.
1018      *
1019      * This is internal function is equivalent to {transfer}, and can be used to
1020      * e.g. implement automatic token fees, slashing mechanisms, etc.
1021      *
1022      * Emits a {Transfer} event.
1023      *
1024      * Requirements:
1025      *
1026      * - `sender` cannot be the zero address.
1027      * - `recipient` cannot be the zero address.
1028      * - `sender` must have a balance of at least `amount`.
1029      */
1030     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1031         require(sender != address(0), "ERC20: transfer from the zero address");
1032         require(recipient != address(0), "ERC20: transfer to the zero address");
1033 
1034         _beforeTokenTransfer(sender, recipient, amount);
1035 
1036         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1037         _balances[recipient] = _balances[recipient].add(amount);
1038         emit Transfer(sender, recipient, amount);
1039     }
1040 
1041     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1042      * the total supply.
1043      *
1044      * Emits a {Transfer} event with `from` set to the zero address.
1045      *
1046      * Requirements
1047      *
1048      * - `to` cannot be the zero address.
1049      */
1050     function _mint(address account, uint256 amount) internal virtual {
1051         require(account != address(0), "ERC20: mint to the zero address");
1052 
1053         _beforeTokenTransfer(address(0), account, amount);
1054 
1055         _totalSupply = _totalSupply.add(amount);
1056         _balances[account] = _balances[account].add(amount);
1057         emit Transfer(address(0), account, amount);
1058     }
1059 
1060     /**
1061      * @dev Destroys `amount` tokens from `account`, reducing the
1062      * total supply.
1063      *
1064      * Emits a {Transfer} event with `to` set to the zero address.
1065      *
1066      * Requirements
1067      *
1068      * - `account` cannot be the zero address.
1069      * - `account` must have at least `amount` tokens.
1070      */
1071     function _burn(address account, uint256 amount) internal virtual {
1072         require(account != address(0), "ERC20: burn from the zero address");
1073 
1074         _beforeTokenTransfer(account, address(0), amount);
1075 
1076         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1077         _totalSupply = _totalSupply.sub(amount);
1078         emit Transfer(account, address(0), amount);
1079     }
1080 
1081     /**
1082      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1083      *
1084      * This is internal function is equivalent to `approve`, and can be used to
1085      * e.g. set automatic allowances for certain subsystems, etc.
1086      *
1087      * Emits an {Approval} event.
1088      *
1089      * Requirements:
1090      *
1091      * - `owner` cannot be the zero address.
1092      * - `spender` cannot be the zero address.
1093      */
1094     function _approve(address owner, address spender, uint256 amount) internal virtual {
1095         require(owner != address(0), "ERC20: approve from the zero address");
1096         require(spender != address(0), "ERC20: approve to the zero address");
1097 
1098         _allowances[owner][spender] = amount;
1099         emit Approval(owner, spender, amount);
1100     }
1101 
1102     /**
1103      * @dev Sets {decimals} to a value other than the default one of 18.
1104      *
1105      * WARNING: This function should only be called from the constructor. Most
1106      * applications that interact with token contracts will not expect
1107      * {decimals} to ever change, and may work incorrectly if it does.
1108      */
1109     function _setupDecimals(uint8 decimals_) internal {
1110         _decimals = decimals_;
1111     }
1112 
1113     /**
1114      * @dev Hook that is called before any transfer of tokens. This includes
1115      * minting and burning.
1116      *
1117      * Calling conditions:
1118      *
1119      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1120      * will be to transferred to `to`.
1121      * - when `from` is zero, `amount` tokens will be minted for `to`.
1122      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1123      * - `from` and `to` are never both zero.
1124      *
1125      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1126      */
1127     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1128 }
1129 
1130 interface IUniswapV2Pair {
1131     event Approval(address indexed owner, address indexed spender, uint value);
1132     event Transfer(address indexed from, address indexed to, uint value);
1133 
1134     function name() external pure returns (string memory);
1135     function symbol() external pure returns (string memory);
1136     function decimals() external pure returns (uint8);
1137     function totalSupply() external view returns (uint);
1138     function balanceOf(address owner) external view returns (uint);
1139     function allowance(address owner, address spender) external view returns (uint);
1140 
1141     function approve(address spender, uint value) external returns (bool);
1142     function transfer(address to, uint value) external returns (bool);
1143     function transferFrom(address from, address to, uint value) external returns (bool);
1144 
1145     function DOMAIN_SEPARATOR() external view returns (bytes32);
1146     function PERMIT_TYPEHASH() external pure returns (bytes32);
1147     function nonces(address owner) external view returns (uint);
1148 
1149     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1150 
1151     event Mint(address indexed sender, uint amount0, uint amount1);
1152     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1153     event Swap(
1154         address indexed sender,
1155         uint amount0In,
1156         uint amount1In,
1157         uint amount0Out,
1158         uint amount1Out,
1159         address indexed to
1160     );
1161     event Sync(uint112 reserve0, uint112 reserve1);
1162 
1163     function MINIMUM_LIQUIDITY() external pure returns (uint);
1164     function factory() external view returns (address);
1165     function token0() external view returns (address);
1166     function token1() external view returns (address);
1167     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1168     function price0CumulativeLast() external view returns (uint);
1169     function price1CumulativeLast() external view returns (uint);
1170     function kLast() external view returns (uint);
1171 
1172     function mint(address to) external returns (uint liquidity);
1173     function burn(address to) external returns (uint amount0, uint amount1);
1174     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1175     function skim(address to) external;
1176     function sync() external;
1177 
1178     function initialize(address, address) external;
1179 }
1180 
1181 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
1182 library FixedPoint {
1183     // range: [0, 2**112 - 1]
1184     // resolution: 1 / 2**112
1185     struct uq112x112 {
1186         uint224 _x;
1187     }
1188 
1189     // range: [0, 2**144 - 1]
1190     // resolution: 1 / 2**112
1191     struct uq144x112 {
1192         uint _x;
1193     }
1194 
1195     uint8 private constant RESOLUTION = 112;
1196 
1197     // encode a uint112 as a UQ112x112
1198     function encode(uint112 x) internal pure returns (uq112x112 memory) {
1199         return uq112x112(uint224(x) << RESOLUTION);
1200     }
1201 
1202     // encodes a uint144 as a UQ144x112
1203     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
1204         return uq144x112(uint256(x) << RESOLUTION);
1205     }
1206 
1207     // divide a UQ112x112 by a uint112, returning a UQ112x112
1208     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
1209         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
1210         return uq112x112(self._x / uint224(x));
1211     }
1212 
1213     // multiply a UQ112x112 by a uint, returning a UQ144x112
1214     // reverts on overflow
1215     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
1216         uint z;
1217         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
1218         return uq144x112(z);
1219     }
1220 
1221     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
1222     // equivalent to encode(numerator).div(denominator)
1223     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
1224         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
1225         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
1226     }
1227 
1228     // decode a UQ112x112 into a uint112 by truncating after the radix point
1229     function decode(uq112x112 memory self) internal pure returns (uint112) {
1230         return uint112(self._x >> RESOLUTION);
1231     }
1232 
1233     // decode a UQ144x112 into a uint144 by truncating after the radix point
1234     function decode144(uq144x112 memory self) internal pure returns (uint144) {
1235         return uint144(self._x >> RESOLUTION);
1236     }
1237 }
1238 
1239 // library with helper methods for oracles that are concerned with computing average prices
1240 library UniswapV2OracleLibrary {
1241     using FixedPoint for *;
1242 
1243     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
1244     function currentBlockTimestamp() internal view returns (uint32) {
1245         return uint32(block.timestamp % 2 ** 32);
1246     }
1247 
1248     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
1249     function currentCumulativePrices(
1250         address pair
1251     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
1252         blockTimestamp = currentBlockTimestamp();
1253         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
1254         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
1255 
1256         // if time has elapsed since the last update on the pair, mock the accumulated price values
1257         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
1258         if (blockTimestampLast != blockTimestamp) {
1259             // subtraction overflow is desired
1260             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
1261             // addition overflow is desired
1262             // counterfactual
1263             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
1264             // counterfactual
1265             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
1266         }
1267     }
1268 }
1269 
1270 //import "@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol";
1271 library UniswapV2Library {
1272     using SafeMath for uint;
1273 
1274     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1275     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1276         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1277         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1278         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1279     }
1280 
1281     // calculates the CREATE2 address for a pair without making any external calls
1282     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1283         (address token0, address token1) = sortTokens(tokenA, tokenB);
1284         pair = address(uint(keccak256(abi.encodePacked(
1285                 hex'ff',
1286                 factory,
1287                 keccak256(abi.encodePacked(token0, token1)),
1288                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1289             ))));
1290     }
1291 }
1292 
1293 // @&#%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1294 // @&@@%&@@&&&&%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1295 // @@&@(....,*#&@@@&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1296 // @@@@&/..........*(%@@@&%#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1297 // @@@&&%*..............,*(#%&@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1298 // @@@@&@#......................*#&@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1299 // @@@@&%@(..........................,(&@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1300 // @@@@@&&@(,.............................*/#@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1301 // @@@@@@@&@(,.................................*#&@@%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1302 // @@@@@@@&&@#,....................................,/%@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1303 // @@@@@@@@@&@#,.......................................,*#&@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1304 // @@@@@@@@@@&@(............................................,(&@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1305 // @@@@@@@@@@@@@/...............................................,/#@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1306 // @@@@@@@@@@@@&@(..................................................*#%@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1307 // @@@@@@@@@@@@@&@/......................................................,/&@&@@@@@@@@@@@@@@@@@@@@@@@@@
1308 // @@@@@@@@@@@@@%&@/.........................................................,/#%%%&@@@@@@@@@@@@@@@@@@@
1309 // @@@@@@@@@@@@@@%@@(......................................,**/((((((((((((/*,....*(%&@@@@@@@@@@@@@@@@@
1310 // @@@@@@@@@@@@@@@#@@*............................,,/%&&@@@@&#(/*,,,,,,,,,,/#&@@%((/*%@@#@@@@@@@@@@@@@@
1311 // @@@@@@@@@@@@@@@&%@#.................,,/#%&@@@@@&%#/*,,,.,,,,,,,,,,,,,,,,,,,,.,,*(%&@@@@@&@@@@@@@@@@@
1312 // @@@@@@@@@@@@@@@@@%@*.........*(#&@@@&%#/*,...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,..*(&@@%@@@@@@@@@
1313 // @@@@@@@@@@@@@@@@@&&@*....(&@@@%*,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@&@@@@@@@@
1314 // @@@@@@@@@@@@@@@@@@%@@@@@@@@(,,,,,,,,,,,.....,,,,...,,,,,,,,,,,,,,,,,,,,,,,,(&/.,,,,,,,,,,,*&&&@@@@@@
1315 // @@@@@@@@@@@@@@@@@@@@@@@@@&&@(,,,,,*(%&@@@@@@@@@@@@@@&(,,,,,,,,,,,,,,,,,,,*%@(,,,,,,,,,,,,,,*#@@@@@@@
1316 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@(%@@@@@@&#/*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@(,,,,,,,,,,,,,,,,*%&@@@@@
1317 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@/,,,,./%@@&%/,,,,,,,,,,,,,,,,,,,,,,,,,,.*(#@@(,,,,,,,,,,,,,,,,,,*%@@@@@
1318 // @@@@@@@@@@@@@@@@@@@@@@@@@@@&@/,,*&@@@%#######(*,,,,,,,,,,,,,,,,,,,,.(@%/*.,,,,,,,,,,,,,,,,,,,.(@%@@@
1319 // @@@@@@@@@@@@@@@@@@@@@@@@@@&@&*/%@@@@@%/%@@@@%(&&&@@&#,,,,,,,,,,,,,,.&@*,,,,,,,,,,,,,,,,,,,,,,.*%@&@@
1320 // @@@@@@@@@@@@@@@@@@@@@@@@@&@%*.*%@&,,#@%//(##(#&/.*#@&*,,,,,,,,,,,,,,,.,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
1321 // @@@@@@@@@@@@@@@@@@@@@@@@@@%*,,,.*%&@@@@@@@@@@@@@@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
1322 // @@@@@@@@@@@@@@@@@@@@@@%&@#,,,,,,,,,,**,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
1323 // @@@@@@@@@@@@@@@@@@@@@&@%*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(&&@@
1324 // @@@@@@@@@@@@@@@@@@@&@&*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(%@@@@@&/,,,,,,,,,,,,,,.(&&@@
1325 // @@@@@@@@@@@@@@@@@#@%.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.*&@%/,,..,*%@#,,,,,,,,,,,,.(&&@@
1326 // @@@@@@@@@@@@@@@&%@%,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,./@#.,#&%(,.,%@*,,,,,,,,,,,,(@&@@
1327 // @@@@@@@@@@@@@@&&@%.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.*@&*/@(*&%*,#@*,,,,,,,,,,.*&&@@@
1328 // @@@@@@@@@@@@@&@&*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#%/.,*&%*,#@*,,,,,,,,,,*%&&@@@
1329 // @@@@@@@@@@&&@%/,,,,,,,,(%&&%(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/*,,,,,,,,*/*/&%*,#@*,,,,,,,,,,(@&@@@@
1330 // @@@@@@@@@%&@(,,,,,,,,/&%*.,#@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@@/,,,,,*&@@@#,,,#@*,,,,,,,,,(@@@@@@@
1331 // @@@@@@@@&&%,.,,,,,,,,,,,,,,,(@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#@%,,,,*(/.,,,./&&*,,,,,,,*%@@@@@@@@
1332 // @@@@@@@@@&@@(*,,,,,,,*#&&&(,,...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@%.,,,,,,/%&&@&/,,,,,,,*&@((@@@@@@
1333 // @@@@@@@@@@@@%&@@@@@@@@&%&@@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@/.,,,,,,....,,,,,,,.(@%*.*%@@&&%
1334 // @@@@@@@@@@@@@@@@@@@@@@@&@&/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@(.,,,,,,,*,,,,,,,./#/,,.*%@@@@@
1335 // @@@@@@@@@@@@@@@@@@@@&&@@@@&#*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.(@#.,,,,,,/&%*,,,,,,,,,,,,.(@@@@@
1336 // @@@@@@@@@@@@@@@@@%@@%*,,,,,*/,,(%(.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@#.,,,,,,,(@#,,,,,,,,,,,,.*%&@@@
1337 // @@@@@@@@@@@@@@@@%@&,,,,,,,,,,,,,#@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,.*(&@#.,,,,,,,./&#,,,,,,,,,,,,.*%&@@@
1338 // @@@@@@@@@@@@@@@@#@&##&@@@@@@@@@@&&@%,,,,,,,,,,,,,,,,,,,,,,,,,*(&@%*,,,,,,,,,,./&#,,,,,,,,,,,,.*%&@@@
1339 // @@@@@@@@@@@@@@@@@@%@@%*,,,,,,,,,,,(/,,,,,,,,,,,,,,,,,,,,,,*%@%/,,,,,,,,,,,,,,./&#,,,,,,,,,,,,.*%&&@@
1340 // @@@@@@@@@@@@@@@@@@&@@@#*,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@&(,,,,,,,,,,,,,,,,,,/&#,,,,,,,,,,,,,,(&&@@
1341 // @@@@@@@@@@@@@@@@@@@@&@@@&@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,*#/.,,,,,,,,,,,,,,,,,,#@(,,,,,,,,,,,,,.(&&@@
1342 // @@@@@@@@@@@@@@@@@@@@@&&@(.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%@%*,,,,,,,,,,,,,.(&&@@
1343 // @@@@@@@@@@@@@@@@@@@@@&&&/.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,*(#&&#*.,,,,,,,,,,,,,,.(&&@@
1344 // @@@@@@@@@@@@@@@@@&%@@&(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%@@@&(*,.,,,,,,,,,,,,,,,,,.(@%@@
1345 // @@@@@@@@@@@@@@&@@%/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/#&@@@&#/*,,,,,,,,,,,,,,,,,,,,,,,,,*%&@@
1346 // @@@@@@@@@@@@@%@&,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/(%@@@%(*,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%&@@
1347 // @@@@@@@@@@@@&@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,/%&@@@@&/*,,.,,,,,,,,,,,,,,,,*#/.,,,,,,,,,,,,,,,,*%&@@
1348 // @@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,*#&@@&%%@@@@@(.,,,,,,,,,,,,,,,,,,,,(@(.,,,,,,,,,,,,,,,,*%@&@
1349 // @@@@@@@@@@@@@%&@&%/,,,,,,,,,,,,,,,,,,*#@@&@@@@@@@@@@@%,,,,,,,,,,,,,,,,,,,,*%@/.,,,,,,,,,,,,,,,,.(&&@
1350 // @@@@@@@@@@@@@@@@@&%@@%(///*,......*%@@&&@@@@@@@@@@@@&@&*,,,,,,,,,,,,,,,,,/@&/,,,,,,,,,,,,,,,,,,.(@&@
1351 // @@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&%@@@@@@@@@@@@@@@@@&&&(,,,,,,,,,,,,,,,(@%*,,,,,,,,,,,,,,,,,,,.*%&@
1352 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@%,,,,,,,,,,,,#@&/.,,,,,,,,,,,,,,,,,.*//(&&@
1353 // $CHADS (chads.vc)
1354 // @dev airblush@protonmail.com (virgin@protonmail.com was taken)
1355 contract ChadsToken is ERC20, Ownable, Pausable {
1356     using SafeMath for uint256;
1357 
1358     /// @notice uniswap listing rate
1359     uint256 public constant INITIAL_TOKENS_PER_ETH = 133_333 * 1 ether;
1360 
1361     /// @notice max burn percentage to teach virgins what happens when they sell too early
1362     uint256 public constant BURN_PCT = 50;
1363 
1364     /// @notice min burn percentage
1365     uint256 public constant MIN_BURN_PCT = 5;
1366 
1367     /// @notice reserve percentage of the burn percentage for rewarding true chads
1368     uint256 public constant BURN_RESERVE_PCT = 49;
1369 
1370     /// @notice WETH token address
1371     address public constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
1372 
1373     /// @notice self-explanatory
1374     address public constant uniswapV2Factory = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1375 
1376     address public immutable burnReservesAddress;
1377 
1378     address public immutable initialDistributionAddress;    
1379 
1380     address public immutable teamAddress;
1381 
1382     address public immutable devAddress;
1383 
1384     address public immutable marketingAddress;
1385 
1386     TokenTimelock public burnReservesVault;
1387 
1388     TokenVesting public teamVault;
1389 
1390     TokenVesting public devVault;
1391 
1392     /// @notice liquidity sources (e.g. UniswapV2Router) 
1393     mapping(address => bool) public whitelistedSenders;
1394 
1395     /// @notice uniswap pair for CHADS/ETH
1396     address public uniswapPair;
1397 
1398     /// @notice Whether or not this token is first in uniswap CHADS<>ETH pair
1399     bool public isThisToken0;
1400 
1401     /// @notice last TWAP update time
1402     uint32 public blockTimestampLast;
1403 
1404     /// @notice last TWAP cumulative price
1405     uint256 public priceCumulativeLast;
1406 
1407     /// @notice last TWAP average price
1408     uint256 public priceAverageLast;
1409 
1410     /// @notice TWAP min delta (10-min)
1411     uint256 public minDeltaTwap;
1412 
1413     event TwapUpdated(uint256 priceCumulativeLast, uint256 blockTimestampLast, uint256 priceAverageLast);
1414 
1415     constructor(
1416         uint256 _minDeltaTwap,
1417         address _initialDistributionAddress,
1418         address _burnReservesAddress,
1419         address _teamAddress,
1420         address _devAddress,
1421         address _marketingAddress
1422     ) 
1423     public
1424     Ownable()
1425     ERC20("chads.vc", "CHADS")
1426     {
1427         setMinDeltaTwap(_minDeltaTwap);
1428         initialDistributionAddress = _initialDistributionAddress;
1429         burnReservesAddress = _burnReservesAddress;
1430         teamAddress = _teamAddress;
1431         devAddress = _devAddress;
1432         marketingAddress = _marketingAddress;
1433         _createBurnReservesVault(_burnReservesAddress);
1434         _distributeTokens(_initialDistributionAddress, _teamAddress, _devAddress, _marketingAddress);
1435         _initializePair();
1436         _pause();
1437     }
1438 
1439     modifier whenNotPausedOrInitialDistribution() {
1440         require(!paused() || msg.sender == initialDistributionAddress, "!paused && !initialDistributionAddress");
1441         _;
1442     }
1443 
1444     modifier onlyInitialDistributionAddress() {
1445         require(msg.sender == initialDistributionAddress, "!initialDistributionAddress");
1446         _;
1447     }
1448 
1449     /**
1450      * @dev Unpauses all transfers from the distribution address (initial liquidity pool).
1451      */
1452     function unpause() external virtual onlyInitialDistributionAddress {
1453         super._unpause();
1454     }
1455 
1456     /**
1457      * @dev Min time elapsed before twap is updated.
1458      */
1459     function setMinDeltaTwap(uint256 _minDeltaTwap) public onlyOwner {
1460         minDeltaTwap = _minDeltaTwap;
1461     }
1462 
1463     /**
1464      * @dev Initializes the TWAP cumulative values for the burn curve.
1465      */
1466     function initializeTwap() external onlyInitialDistributionAddress {
1467         require(blockTimestampLast == 0, "twap already initialized");
1468         (uint256 price0Cumulative, uint256 price1Cumulative, uint32 blockTimestamp) = 
1469             UniswapV2OracleLibrary.currentCumulativePrices(uniswapPair);
1470 
1471         uint256 priceCumulative = isThisToken0 ? price1Cumulative : price0Cumulative;
1472         
1473         blockTimestampLast = blockTimestamp;
1474         priceCumulativeLast = priceCumulative;
1475         priceAverageLast = INITIAL_TOKENS_PER_ETH;
1476     }
1477 
1478     /**
1479      * @dev Sets a whitelisted sender (liquidity sources mostly).
1480      */
1481     function setWhitelistedSender(address _address, bool _whitelisted) public onlyOwner {
1482         whitelistedSenders[_address] = _whitelisted;
1483     }
1484 
1485     function _distributeTokens(
1486         address _initialDistributionAddress,
1487         address _teamAddress,
1488         address _devAddress,
1489         address _marketingAddress
1490     ) 
1491     internal
1492     {
1493         // Initial Liquidity Pool (28M tokens) + Uniswap Pool (20M tokens)
1494         _mint(address(_initialDistributionAddress), 48 * 1e6 * 1e18);
1495         setWhitelistedSender(_initialDistributionAddress, true);
1496 
1497         // Team (3M tokens, 3 months lock + 6 months vesting)
1498         teamVault = new TokenVesting(_teamAddress, block.timestamp, 12 weeks, 24 weeks);
1499         setWhitelistedSender(address(teamVault), true);
1500         _mint(address(teamVault), 3 * 1e6 * 1e18);
1501 
1502         // Dapp Development (7M tokens, 2M unlocked, 5M months vesting)
1503         devVault = new TokenVesting(_devAddress, block.timestamp, 0, 24 weeks);
1504         setWhitelistedSender(address(devVault), true);
1505         _mint(_devAddress, 2 * 1e6 * 1e18);
1506         _mint(address(devVault), 5 * 1e6 * 1e18);
1507 
1508         // Marketing/ecosystem rewards (11M tokens)
1509         _mint(_marketingAddress, 11 * 1e6 * 1e18);
1510         setWhitelistedSender(_marketingAddress, true);
1511     }
1512 
1513     function _createBurnReservesVault(address _burnReservesAddress) internal {
1514         burnReservesVault = new TokenTimelock(_burnReservesAddress, block.timestamp + 2 weeks);
1515         setWhitelistedSender(address(burnReservesVault), true);
1516     }
1517 
1518     function _initializePair() internal {
1519         (address token0, address token1) = UniswapV2Library.sortTokens(address(this), address(WETH));
1520         isThisToken0 = (token0 == address(this));
1521         uniswapPair = UniswapV2Library.pairFor(uniswapV2Factory, token0, token1);
1522         setWhitelistedSender(uniswapPair, true);
1523     }
1524 
1525     function _isWhitelistedSender(address _sender) internal view returns (bool) {
1526         return whitelistedSenders[_sender];
1527     }    
1528 
1529     function _updateTwap() internal virtual returns (uint256) {
1530         (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) = 
1531             UniswapV2OracleLibrary.currentCumulativePrices(uniswapPair);
1532         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
1533 
1534         if (timeElapsed > minDeltaTwap) {
1535             uint256 priceCumulative = isThisToken0 ? price1Cumulative : price0Cumulative;
1536 
1537             // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
1538             FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
1539                 uint224((priceCumulative - priceCumulativeLast) / timeElapsed)
1540             );
1541 
1542             priceCumulativeLast = priceCumulative;
1543             blockTimestampLast = blockTimestamp;
1544 
1545             priceAverageLast = FixedPoint.decode144(FixedPoint.mul(priceAverage, 1 ether));
1546 
1547             emit TwapUpdated(priceCumulativeLast, blockTimestampLast, priceAverageLast);
1548         }
1549 
1550         return priceAverageLast;
1551     }
1552 
1553     function _transfer(address sender, address recipient, uint256 amount)
1554         internal
1555         virtual
1556         override
1557         whenNotPausedOrInitialDistribution()
1558     {
1559         if (!_isWhitelistedSender(sender)) {
1560             uint256 scaleFactor = 1e18;
1561             uint256 currentAmountOutPerEth = _updateTwap();
1562             uint256 currentBurnPct = BURN_PCT.mul(scaleFactor);
1563             if (currentAmountOutPerEth < INITIAL_TOKENS_PER_ETH) {
1564                 // 50 / (INITIAL_TOKENS_PER_ETH / currentAmountOutPerEth)
1565                 scaleFactor = 1e9;
1566                 currentBurnPct = currentBurnPct.mul(scaleFactor)
1567                     .div(INITIAL_TOKENS_PER_ETH.mul(1e18)
1568                         .div(currentAmountOutPerEth));
1569                 uint256 minBurnPct = MIN_BURN_PCT * scaleFactor / 10;
1570                 currentBurnPct = currentBurnPct > minBurnPct ? currentBurnPct : minBurnPct;
1571             }
1572 
1573             uint256 totalBurnAmount = amount.mul(currentBurnPct).div(100).div(scaleFactor);
1574             uint256 burnReserveAmount = totalBurnAmount.mul(BURN_RESERVE_PCT).div(100);
1575             uint256 burnAmount = totalBurnAmount.sub(burnReserveAmount);
1576             
1577             super._transfer(sender, address(burnReservesVault), burnReserveAmount);
1578             super._burn(sender, burnAmount);
1579 
1580             amount = amount.sub(totalBurnAmount);
1581         }
1582         super._transfer(sender, recipient, amount);
1583     }
1584 
1585     function getCurrentTwap() public view returns (uint256) {
1586         (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) = 
1587             UniswapV2OracleLibrary.currentCumulativePrices(uniswapPair);
1588         uint32 timeElapsed = blockTimestamp - blockTimestampLast;
1589 
1590         uint256 priceCumulative = isThisToken0 ? price1Cumulative : price0Cumulative;
1591 
1592         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
1593             uint224((priceCumulative - priceCumulativeLast) / timeElapsed)
1594         );
1595 
1596         return FixedPoint.decode144(FixedPoint.mul(priceAverage, 1 ether));
1597     }
1598 
1599     function getLastTwap() public view returns (uint256) {
1600         return priceAverageLast;
1601     }
1602 }