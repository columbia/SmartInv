1 pragma solidity ^0.6.0;
2 
3 
4 // 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // 
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
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 // 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies in extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         uint256 size;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { size := extcodesize(account) }
266         return size > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312       return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return _functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         return _functionCallWithValue(target, data, value, errorMessage);
349     }
350 
351     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
352         require(isContract(target), "Address: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 // solhint-disable-next-line no-inline-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 // 
376 /**
377  * @title SafeERC20
378  * @dev Wrappers around ERC20 operations that throw on failure (when the token
379  * contract returns false). Tokens that return no value (and instead revert or
380  * throw on failure) are also supported, non-reverting calls are assumed to be
381  * successful.
382  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
383  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
384  */
385 library SafeERC20 {
386     using SafeMath for uint256;
387     using Address for address;
388 
389     function safeTransfer(IERC20 token, address to, uint256 value) internal {
390         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
391     }
392 
393     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
394         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
395     }
396 
397     /**
398      * @dev Deprecated. This function has issues similar to the ones found in
399      * {IERC20-approve}, and its usage is discouraged.
400      *
401      * Whenever possible, use {safeIncreaseAllowance} and
402      * {safeDecreaseAllowance} instead.
403      */
404     function safeApprove(IERC20 token, address spender, uint256 value) internal {
405         // safeApprove should only be called when setting an initial allowance,
406         // or when resetting it to zero. To increase and decrease it, use
407         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
408         // solhint-disable-next-line max-line-length
409         require((value == 0) || (token.allowance(address(this), spender) == 0),
410             "SafeERC20: approve from non-zero to non-zero allowance"
411         );
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
413     }
414 
415     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).add(value);
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
418     }
419 
420     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     /**
426      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
427      * on the return value: the return value is optional (but if data is returned, it must not be false).
428      * @param token The token targeted by the call.
429      * @param data The call data (encoded using abi.encode or one of its variants).
430      */
431     function _callOptionalReturn(IERC20 token, bytes memory data) private {
432         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
433         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
434         // the target address contains contract code and also asserts for success in the low-level call.
435 
436         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
437         if (returndata.length > 0) { // Return data is optional
438             // solhint-disable-next-line max-line-length
439             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
440         }
441     }
442 }
443 
444 // 
445 /*
446  * @dev Provides information about the current execution context, including the
447  * sender of the transaction and its data. While these are generally available
448  * via msg.sender and msg.data, they should not be accessed in such a direct
449  * manner, since when dealing with GSN meta-transactions the account sending and
450  * paying for execution may not be the actual sender (as far as an application
451  * is concerned).
452  *
453  * This contract is only required for intermediate, library-like contracts.
454  */
455 abstract contract Context {
456     function _msgSender() internal view virtual returns (address payable) {
457         return msg.sender;
458     }
459 
460     function _msgData() internal view virtual returns (bytes memory) {
461         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
462         return msg.data;
463     }
464 }
465 
466 // 
467 /**
468  * @dev Contract module which provides a basic access control mechanism, where
469  * there is an account (an owner) that can be granted exclusive access to
470  * specific functions.
471  *
472  * By default, the owner account will be the one that deploys the contract. This
473  * can later be changed with {transferOwnership}.
474  *
475  * This module is used through inheritance. It will make available the modifier
476  * `onlyOwner`, which can be applied to your functions to restrict their use to
477  * the owner.
478  */
479 contract Ownable is Context {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     constructor () internal {
488         address msgSender = _msgSender();
489         _owner = msgSender;
490         emit OwnershipTransferred(address(0), msgSender);
491     }
492 
493     /**
494      * @dev Returns the address of the current owner.
495      */
496     function owner() public view returns (address) {
497         return _owner;
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         require(_owner == _msgSender(), "Ownable: caller is not the owner");
505         _;
506     }
507 
508     /**
509      * @dev Leaves the contract without owner. It will not be possible to call
510      * `onlyOwner` functions anymore. Can only be called by the current owner.
511      *
512      * NOTE: Renouncing ownership will leave the contract without an owner,
513      * thereby removing any functionality that is only available to the owner.
514      */
515     function renounceOwnership() public virtual onlyOwner {
516         emit OwnershipTransferred(_owner, address(0));
517         _owner = address(0);
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Can only be called by the current owner.
523      */
524     function transferOwnership(address newOwner) public virtual onlyOwner {
525         require(newOwner != address(0), "Ownable: new owner is the zero address");
526         emit OwnershipTransferred(_owner, newOwner);
527         _owner = newOwner;
528     }
529 }
530 
531 interface IRewardDistributionRecipient {
532     function notifyRewardAmount(uint256 reward) external;
533 }
534 
535 interface IUniswapV2Router02 {
536     function factory() external pure returns (address);
537     function WETH() external pure returns (address);
538     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) 
539     external 
540     payable 
541     returns (uint amountToken, uint amountETH, uint liquidity);
542 }
543 
544 interface IReferrers {
545     function isReferrer(address _address) external returns (bool);
546 }
547 
548 library UniswapV2Library {
549     using SafeMath for uint;
550 
551     // returns sorted token addresses, used to handle return values from pairs sorted in this order
552     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
553         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
554         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
555         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
556     }
557 
558     // calculates the CREATE2 address for a pair without making any external calls
559     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
560         (address token0, address token1) = sortTokens(tokenA, tokenB);
561         pair = address(uint(keccak256(abi.encodePacked(
562                 hex'ff',
563                 factory,
564                 keccak256(abi.encodePacked(token0, token1)),
565                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
566             ))));
567     }
568 }
569 
570 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
571 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNNWMWXKNMMMMNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
572 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXXNXKNWkdKN0xKWkl0MMMWkdXMMMMMWKKNNNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
573 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOKWWxoKXXWMOl0MWdlXOl0MMWXOlxWMMMNxoKWWK0WNKKNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
574 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX0KWMXllXMKld0KWMKlkMWkdXOlOWXXXNkl0MMMOcOMMMWW0oxXWKkKMWNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
575 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXdlxXN0odKKolkkOOOloKKOKNOdO0kOXNKdxXNXkldOOkOOloXWMKlkM0oOXXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
576 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMMMMMMN0xdxkdcllcccccccccodkO0KKKKKK0K0OxdolccclllllcloxkooX0ldXkoKMNXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
577 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxxNMMMMMMMX0xccccccccccccccccccldO0KKKK0Odl:clodddddddddddoccdxlx0xx0WNxdKXNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
578 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNMMWKodXMMNXWNOocccc:;;;;;;;;;::cccccldO0KOdc:coddolllcccllllodddl:lKkoKMKooKKokMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
579 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxxOXWNdo0XOk0dlc:;,'''.''.....'',;:ccccoxxo::lddlcccccccccccccclodocldxKklxXXOkOkOKXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
580 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMWXNMMWKkxdxxOxx00Odc:;''............,''.',;:cc::::ldoccccc::;;::::::c:clddclk0kkNWMNklxXWN00WMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
581 // MMMMMMMMMMMMMMMMMMMMMMMMMMMWWXXNWMNKNWKxk0KK0xc;'.',c,..,.     .cOko:,',;c::;:odloxOOo;cc,',,,,;loccldo:o0KKKXN0o0MMW0lkWWNWMMMMMMMMMMMMMMMMMMMMMMMMMM
582 // MMMMMMMMMMMMMMMMMMMMMMMMMW0xxkkxdkXK0KKKKKKK0o,'';d0K: 'o,.cxc. ;XMWXx:'';;;,:dxOKNN0c;od:cxxl,,dK0dldo;lOKKK0K0OKX0xokX0dxKNMMMMMMMMMMMMMMMMMMMMMMMMM
583 // MMMMMMMMMMMMMMMMMMMMMMMWWWNK000OkxO00KKKKKKKOl'.,dXWWo. ,'.lOo. lXXOo:'..'''':dooxOK0o,:l:lkOl,;kXXKxdo,ckK00KKK00OO0KOdokKkkNMMMMMMMMMMMMMMMMMMMMMMMM
584 // MMMMMMMMMMMMMMMMMMMMMWNKOkxOXNXKXXKKK0KKKK0Oxl;,',:lxd;.    .. .cc;''..'',,,';odcccldo:;;,,;;,;okkdloxdclkOOO0KKKKKK0dd0OxOx0WMMMMMMMMMMMMMMMMMMMMMMMM
585 // MMMMMMMMMMMMMMMMMMMMMK0WWN0ddXX00K0KKKKK0Odlccc:;,'..''.............''',,,,,,,cdoccccccc::::::cccccldkkxxkxxk0KKKKKK00KOoOWMWWNXXWMMMMMMMMMMMMMMMMMMMM
586 // MMMMMMMMMMMMMMMMMMMMM0dkNMMWOOKKKKKKKK0Odlcccccccc:;,''.........'''',,,,,,,,,,,codlcccccccccccccclodocccccc:cdO0KKKKKKKkx0XNXKdoKWMMMMMMMMMMMMMMMMMMMM
587 // MMMMMMMMMMMMMMMMMMKxOXKxdkO000KKKKKKK0xlccccccccccccc:;;,,,,,,,;;;;,,,,,,,,,,,,,;lodollccccccclodddl:::::::;::lx0KKKKKK000NW0odXWNKXMMMMMMMMMMMMMMMMMM
588 // MMMMMMMMMMMMMMMMWXKOxxxk0K00KKKKKKKKOdlcccccccccccccccccccccccc:;;,,,,,,,,,,,,,,,,;clodddddddddooc::::;::;:::::cd0KKKKKKKKKkokNMWXkxKMMMMMMMMMMMMMMMMM
589 // MMMMMMMMMMMMMMMWKOKWMWKkdk0KKKKKKKKOdcccccccccccccccccccccccc:;;,,,,,,,,,,,,,,,,,,,,,,;:clllcc::;:::;:::;::;::;::d0KKKKKKKKO0XXOxxxkOXMMMMMMMMMMMMMMMM
590 // MMMMMMMMMMMMMMWXkxxkKNWWX0KKKKKKKK0xlcccccccccccccccccccccc:;;,,,,,,,,,,,,,,,,,,,,,,,,,,,;;:::::::::::::;::;::::;cx0KKKKKKKK0xdx0NWWKKNMMMMMMMMMMMMMMM
591 // MMMMMMMMMMMMMMN0KNKkxdxOKKKKKKKKKKkoccccccccccccccc:::::cc:;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;::::::::::::::::::::::lkKKKKKKKKK0KWMWXOkdkNMMMMMMMMMMMMMM
592 // MMMMMMMMMMMMMMWWNWWWNKO0KKKKKKKKK0xlcccccccccc::::::::::::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::::::::::::::x00KK0KK0KKKOxxxkOKNWMMMMMMMMMMMMMM
593 // MMMMMMMMMMMMMNOxkxxkxk0KKKKKKKKKK0dcccccccccc::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;:d0KKKKKKKKKKO0X0xxxO0XWMMMMMMMMMMMM
594 // MMMMMMMMMMMMMWNXKKXWX0KKKKKKKKKKK0dcccccccccc::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::d0KKKKK0KKKKKKOxOXWWNKXMMMMMMMMMMMM
595 // MMMMMMMMMMMNXNWMWNX00KKKKKKKKKKKK0xlccccccccc:::::::;;,,,,;;;;;;;;::::::::::::::::::;;;;;;;;,,,,;:::::::::::::::::cx0KKKKKKKKKKK00KNWNKkxKMMMMMMMMMMMM
596 // MMMMMMMMMMMNXNXKkkOO0KKKKKKKKKKKKKOoccccccccc::::::::;;;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;;;:::::::::::::::::lOKKKKKKKKKKKKK00OkxxkXWWMMMMMMMMMMM
597 // MMMMMMMMMMW0kxxxxO0KKKKKKKKKKKKKKK0xlcccccccccc:::::::::::::;;;;;;;,,,,,,,,,,,,,,,,,;;;;;;;::::::::::::::::::::::cx0KKKKKKKKKKKKKKKXXNNNKxOWMMMMMMMMMM
598 // MMMMMMMMMMXkxOKNNXKKKKKKKKKKKKKKKKK0xlccccccccccc:::::::::::::::::::::::::::::::::::::::::::::::::::::::::;:::::cd0KKKKKKKKKKKKKKK00NNKxoxXMMMMMMMMMMM
599 // MMMMMMMMMMWNNWWWN0O0KKKKKKKKKKKKKKKK0xlccccccccccccc:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::cx0KKKKKKKKKKKKKKKKKXKxldKNKXMMMMMMMMMM
600 // MMMMMMMMMWKkxkOkxkOKKKKKKKKKKKKKKKKKK0koccccccccccccccccc:::::::::::::::::::::::::::::::::::::::::::::::::;:::lk0KKKKKKKKKKKKKKKKKKKOkKNNNNNMMMMMMMMMM
601 // MMMMMMMMMXkk0xdkO00KKKKKKKKKKKKKKKKKKK00xlccccccccccccccccccccccccccccccc::::::::::::::::::;::::::::::::::::lxOKKKKKKKKKKKKKKKKKK0K0OXMMMMMMMMMMMMMMMM
602 // MMMMMMMMMNOkkxxkxx0KKKKKKKKKKKKKKKKKKKKK0Oxolccccccccccccccccccccccccccccc::::::::::::::;;:::::;;;:::::;::lxO0KKKKKKKKKKKKKKKKKKKKKKXWMMMMMMMMMMMMMMMM
603 // MMMMMMMMMNXNMMMN0O0KKKKKKKKKKKKKKKKKKKKKKK0Okdlccccccccccccccccccccccccccc:::::::::::::::::::::;;::::::coxO0KKKKKKKKKKKKKKKKKKKKKKKKNMMMMMMMMMMMMMMMMM
604 // MMMMMMMMMXKNNKKWKO0KKKKKKKKKKKKKKKKKKKKKKKKK0kl,,;cccccccccccccccccccccccc:::::::::::::::::::::;;;;;,',oO0K0KKKKKKKKKKKKKKKKKKKKKKKKKOxxxk0NMMMMMMMMMM
605 // MMMMMMMMMXkxxddkxx0KKKKKKKKKKKKKKKKKKKKKK0Od:.    .lxolccccccccccccccccccc:::::::::::::::::::;:clo:.    .:dO0KKKKKKKKKKKKKKKKKKKKKK0O0KXX0OKWMMMMMMMMM
606 // MMMMMMMMMNK0KXNNNKKKKKKKKKKKKKKKKKKKKK0Odl:.       'ONKOdlcccccccccccccccc:::;:::::;;::;:;;:cdOKXx.       .,cdk0KKKKKKKKKKKKKKKKKK00KXWMMWNXWMMMMMMMMM
607 // MMMMMMMMMWKKNNNXKOOKKKKKKKKKKKKKKKK0kdc;,,'.        'OWMWKkl:::::::ccccccc:::;::::;;;:;;;:lkKWMWx.         ...,:ok00KK0KKKKKKKKKKK0OkKNMMNKXMMMMMMMMMM
608 // MMMMMMMMMW0xkkkkxxOKKKKKKKKKKKK0Oxoc;,,,,,'          'OWMMWXOdc;;;;;::::::;;;;;;;;;;;;;cd0NWMMWx.          ......';lxO0KKKKKKK0KKKK0KXXNWMMMMMMMMMMMMM
609 // MMMMMMMMMMKOKNMMMWNKKKKKKKKK0kdl:,,,,,,,,,.           'OWMMMMWKxl:;;;;;;;;;;;;;;;;;;:okKWMMMMWx.           .........',cdk0KKKKKKKK0KX0kxxkXMMMMMMMMMMM
610 // MMMMMMMMMMWKKNNN0kOKK0KK00kdc;,,,,,,,,,,,,.            'kWMMMMMWNOdc;;;;;;;;;;;;;;cd0NWMMMMMWx.            .............,:ok0KKKKKkxxxkkO0NMMMMMMMMMMM
611 // MMMMMMMMMMMXKNKxlkXNK0Oxoc;,,,,,,,,,,,,,,'.             'kWMMMMMMMWKkl:;;;;;;;;:okKWMMMMMMMWx.             ................';lxO0OddO0XWMMMMMMMMMMMMMM
612 // MMMMMMMMMMMMNOodKNN0xl:,,,,,,,,,,,,,,,,,,,'...           .kWMMMMMMMMWN0dc;;;:lx0NMMMMMMMMMWx.             ....................';lk0Oxdxxx0WMMMMMMMMMMM
613 // MMMMMMMMMMMMKdONNNNXo,,,,,,,,,,,,,,,,,,,,,,,,''...        .kWMMMMMMMMMMWKxookXWMMMMMMMMMMWd.         ...........................'lkkkkO0OXMMMMMMMMMMMM
614 // MMMMMMMMMMMMWNNXOkxxdc;,,,,,,,,,,,,,,,,,,,,,,'...          .kWMMMMMMMMMN0occo0NMMMMMMMMMWd.           .........................'dNWWW0xOXMMMMMMMMMMMMM
615 // MMMMMMMMMMMMMNkdkOKNMNd;,,,,,,,,,,,,,,,,,,,,'.              .kWMMMMMWXOo:;,'';lONMMMMMMNd.              .......................,oOKNMNKXMMMMMMMMMMMMMM
616 // MMMMMMMMMMMMMMWWMMMMMWx;,,,,,,,,,,,,,,,,,,,,,'..             .kWMMMWXxc;;;,'''':xXWMMMNd.              ......................'o00kxxxkOXMMMMMMMMMMMMMM
617 // MMMMMMMMMMMMMMMMMWKK0xdko,,,,,,,,,,,,,,,,,,,,,,'..            .xWWXKK0ko:;,',:ok0KKNWNd.             ........................,kWMMWXkxKMMMMMMMMMMMMMMM
618 // MMMMMMMMMMMMMMMMWOdkOkkxl:;,,,,,,,,,,,,,,,,,,,,,,''.           .d0KKKKKOo;,',oOKKKKK0l.           .........................'lxxdxOXXKXMMMMMMMMMMMMMMMM
619 // MMMMMMMMMMMMMMMMMX0kxdxOKOl,,,,,,,,,,,,,,,,,,,,,,,,,'.          .l0KK0Oo:;,'';oOKKKOc.          ....,,....................,l0WXkxxdkNMMMMMMMMMMMMMMMMM
620 // MMMMMMMMMMMMMMMMMMKk0NWMNXKx;',,,,,,,,,,,,,,,,,,,,,,,,'..        .l00kl;;;,''',lkKOc.         ...'ckXKd;.................'cOXWWXXXKXWMMMMMMMMMMMMMMMMM
621 // MMMMMMMMMMMMMMMMMMMMXKNNOkxdoo:,,,,,,,,,,,,,,,,,,,,,,,,,'..       .lkdlllllccc:,cdc.        ...,lONMMMWXxokOo,.........'lOkdokXWNKNMMMMMMMMMMMMMMMMMMM
622 // MMMMMMMMMMMMMMMMMMMMNXKkddkKKOxc,,,,,,,,,,,,,,,,,,,,,,,,,,''.      .cxxxxxxxxdl,'.       ....,o0NWWWWWWWWWWMWKd;.....,ldxkkO0xdkNMMMMMMMMMMMMMMMMMMMMM
623 // MMMMMMMMMMMMMMMMMMMMMWKkKN0odOXKd,',,,,,,,,,,,,,,,,,,,,,,,,,,'.      ';:::;,,,,'.      ......;loooooooooooooool:'...:OWMMWKxx0KXWMMMMMMMMMMMMMMMMMMMMM
624 // MMMMMMMMMMMMMMMMMMMMMMMMMKdOWMXkodxl;,,,,,,,,,,,,,,,,,,,,,,,,,,'..    .,;;,,'''.     .........'''''''''''''''''..,cllkNMMMMNKXWMMMMMMMMMMMMMMMMMMMMMMM
625 // MMMMMMMMMMMMMMMMMMMMMMMMMNKXKxoxXWKodd:,,,,,,,,,,,,,,,,,,,',,,,,,'..   .,;,'''.    ............................,cok00xokNMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
626 // MMMMMMMMMMMMMMMMMMMMMMMMMMWXkxXWNXxc0WOl;,,,,,,,,,,,,,,,,,,,,,,,,,,,'.  .,,''.  ............................',cONXkodXKddXMMMMMMMMMMMMMMMMMMMMMMMMMMMM
627 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKXNdoXNXXd:lc;,,,,,,,,,,,,,,,,,,,,,,,,,'...'.. ...........................';ck0ddXMMXdkWWNWMMMMMMMMMMMMMMMMMMMMMMMMMMMM
628 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNWNooKNWXldNNxc;,,,,,,,,,,,,,,,,,,,,,,,,,''............................';ckXNXNNXXNWNKXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
629 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0OWMMOlkXXNXd:dd:,,,,,,,,,,,,,,,,,,,,,,,'.......................,cook0xdxkO0XWNKKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
630 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWkxXWWMMOlOXOkdll:,,,,,,,,,,,,,,,,,,'...................,ll;lKWKXWWK0Okdd0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
631 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMWNN0cxWMWXXXd:doll:,,,,,,,,,,,,'..........,;;';dkkclXMXxodOXWMWKKWWNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
632 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXKNXodWMWX0klkNNNWxckd:d0Oooxkocclocoxdxkol0NdlXMMKlxWMWXkokWMMWNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
633 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW00WXKNKodNMMMNodWXldXXXWMMOllxNXXWXNMXoxWKlkWWWOlOK0WMNXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
634 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNN0xKMMMMOlOMMklOXWMMMN0xdoxXWXNMWdoXWdlKX0KO0XXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
635 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0kNMMXxOWMMMMNKKXKdOWKKWMOdKWXOXWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
636 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMMMMWNXNNXWMNNWMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
637 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
638 // https://Newspaper.finance
639 contract N3WSCrowdsale is Ownable {
640     using SafeMath for uint256;
641     using SafeERC20 for IERC20;
642 
643     uint256 public immutable HARDCAP = 1000 ether;
644 
645     uint256 public NEWS_PER_ETH = 500;
646 
647     uint256 public immutable startTime;
648 
649     uint256 public immutable endTime;
650 
651     bool public fcfs;
652 
653     mapping(address => bool) public whitelists;
654 
655     mapping(address => uint256) public contributions;
656 
657     mapping(address => uint256) public balances;
658 
659     uint256 public weiRaised;
660 
661     bool public finalized;
662 
663     IERC20 public token;
664 
665     IReferrers public referrers;
666 
667     IRewardDistributionRecipient public liquidityLoop;
668 
669     IUniswapV2Router02 internal constant uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
670 
671     address internal constant uniswapFactory = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
672 
673     constructor(IERC20 _token, IReferrers _referrers, IRewardDistributionRecipient _liquidityLoop, uint256 _startTime, uint256 _endTime)
674     public
675     Ownable()
676     {
677         token = _token;
678         referrers = _referrers;
679         liquidityLoop = _liquidityLoop;
680         startTime = _startTime;
681         endTime = _endTime;
682     }
683 
684     receive() payable external {
685         _buyTokens(msg.sender);
686     }
687 
688     function _buyTokens(address _beneficiary) internal {
689         uint256 weiToHardcap = HARDCAP.sub(weiRaised);
690         uint256 weiAmount = weiToHardcap < msg.value ? weiToHardcap : msg.value;
691 
692         _buyTokens(_beneficiary, weiAmount);
693 
694         uint256 refund = msg.value.sub(weiAmount);
695         if (refund > 0) {
696             payable(_beneficiary).transfer(refund);
697         }
698     }
699 
700     function _buyTokens(address _beneficiary, uint256 _amount) internal {
701         require(isOpen(), "N3WSCrowdsale: sale is not open yet");
702         require(!hasEnded(), "N3WSCrowdsale: sale is over, find me on Uniswap");
703         require(isFcFs() || whitelists[_beneficiary], 
704             "N3WSCrowdsale: sender is not whitelisted and not FCFS phase");
705 
706         weiRaised = weiRaised.add(_amount);
707         contributions[_beneficiary] = contributions[_beneficiary].add(_amount);
708 
709         uint256 tokenAmount = _getTokenAmount(_amount);
710         balances[_beneficiary] = balances[_beneficiary].add(tokenAmount);
711 
712         payable(owner()).transfer(_amount.div(2));
713     }
714 
715     function getCurrentRate() public returns (uint256) {
716         if (!isOpen()) {
717             return 0;
718         }
719 
720         uint256 rate = NEWS_PER_ETH;
721 
722         if (isReferrer(msg.sender)) {
723             rate = rate.mul(105).div(100);
724         }
725         if (weiRaised < 100 ether) {
726             return rate.mul(110).div(100);
727         }
728     
729         uint256 bonus = (110e2 - ((weiRaised/1 ether) - 100))/100;
730         return rate.mul(bonus).div(100);
731     }
732 
733     function _getTokenAmount(uint256 weiAmount) internal returns (uint256) {
734         uint256 currentRate = getCurrentRate();
735         return currentRate.mul(weiAmount);
736     }    
737 
738     function isReferrer(address _address) public returns (bool) {
739         if (address(referrers) == address(0)) {
740             return false;
741         }
742         return referrers.isReferrer(_address);
743     }
744 
745     function addWhitelists(address[] calldata _addresses, bool _whitelisted) external onlyOwner {
746         for (uint256 i = 0; i < _addresses.length; i++) {
747             whitelists[_addresses[i]] = _whitelisted;
748         }
749     }
750 
751     function setLiquidityLoop(IRewardDistributionRecipient _liquidityLooop) external onlyOwner {
752         liquidityLoop = _liquidityLooop;
753     }    
754 
755     function setFcfs(bool _fcfs) external onlyOwner {
756         fcfs = _fcfs;
757     }
758 
759     function withdrawTokens(address _beneficiary) external {
760         require(finalized, "N3WSCrowdsale: sale not finalized yet");
761         uint256 tokenAmount = balances[_beneficiary];
762         require(tokenAmount > 0, "N3WSCrowdsale: beneficiary is not due any tokens");
763 
764         balances[_beneficiary] = 0;
765         token.safeTransferFrom(owner(), _beneficiary, tokenAmount);
766     }
767 
768     function withdrawAfterSaleOnlyInCaseOfProblems() external onlyOwner {
769         require(block.timestamp >= endTime + 48 hours, "N3WSCrowdsale: can only be done 48 hours after sale is over");
770         require(!finalized, "N3WSCrowdsale: sale has already been finalized");
771         payable(owner()).transfer(address(this).balance);
772     }    
773 
774     function finalize() external virtual onlyOwner {
775         require(hasEnded(), "N3WSCrowdsale: sale on-going");
776         require(!finalized, "N3WSCrowdsale: already finalized");
777 
778         uint256 amountEthForUniswap = address(this).balance;
779         uint256 amountTokensForUniswap = amountEthForUniswap.mul(NEWS_PER_ETH);
780 
781         token.safeTransferFrom(owner(), address(this), amountTokensForUniswap); // pre-approved by owner()
782         token.approve(address(uniswapRouter), amountTokensForUniswap);
783         uniswapRouter.addLiquidityETH
784         { value: amountEthForUniswap }
785         (
786             address(token),
787             amountTokensForUniswap,
788             amountTokensForUniswap,
789             amountEthForUniswap,
790             address(this), // To send to liquidity loop
791             now
792         );
793 
794         // Lock all liquidity in the liquidity loop contract to distribute to crowdsale participants
795         address uniswapV2Pair = UniswapV2Library.pairFor(uniswapFactory, address(token), address(uniswapRouter.WETH()));
796         uint256 lpTokenBalance = IERC20(uniswapV2Pair).balanceOf(address(this));
797         IERC20(uniswapV2Pair).transfer(address(liquidityLoop), lpTokenBalance);
798         IRewardDistributionRecipient(liquidityLoop).notifyRewardAmount(lpTokenBalance);
799 
800         finalized = true;
801     }
802 
803     function isOpen() public view returns (bool) {
804         return block.timestamp >= startTime;
805     }
806 
807     function isFcFs() public view returns (bool) {
808         return fcfs;
809     }
810 
811     function hasEnded() public view returns (bool) {
812         return block.timestamp >= endTime || weiRaised >= HARDCAP;
813     }    
814 }