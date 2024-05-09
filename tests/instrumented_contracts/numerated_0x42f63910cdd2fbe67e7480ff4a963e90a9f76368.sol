1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
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
33 /**
34  * @dev Wrappers over Solidity's arithmetic operations with added overflow
35  * checks.
36  *
37  * Arithmetic operations in Solidity wrap on overflow. This can easily result
38  * in bugs, because programmers usually assume that an overflow raises an
39  * error, which is the standard behavior in high level programming languages.
40  * `SafeMath` restores this intuition by reverting the transaction when an
41  * operation overflows.
42  *
43  * Using this library instead of the unchecked operations eliminates an entire
44  * class of bugs, so it's recommended to use it always.
45  */
46 library SafeMath {
47     /**
48      * @dev Returns the addition of two unsigned integers, reverting on
49      * overflow.
50      *
51      * Counterpart to Solidity's `+` operator.
52      *
53      * Requirements:
54      * - Addition cannot overflow.
55      */
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting on
65      * overflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      * - Subtraction cannot overflow.
84      *
85      * _Available since v2.4.0._
86      */
87     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the multiplication of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `*` operator.
99      *
100      * Requirements:
101      * - Multiplication cannot overflow.
102      */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         return div(a, b, "SafeMath: division by zero");
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
134      * division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator. Note: this function uses a
137      * `revert` opcode (which leaves remaining gas untouched) while Solidity
138      * uses an invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      * - The divisor cannot be zero.
142      *
143      * _Available since v2.4.0._
144      */
145     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         // Solidity only automatically asserts when dividing by 0
147         require(b > 0, errorMessage);
148         uint256 c = a / b;
149         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return mod(a, b, "SafeMath: modulo by zero");
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts with custom message when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      *
180      * _Available since v2.4.0._
181      */
182     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b != 0, errorMessage);
184         return a % b;
185     }
186 }
187 
188 /*
189  * @dev Provides information about the current execution context, including the
190  * sender of the transaction and its data. While these are generally available
191  * via msg.sender and msg.data, they should not be accessed in such a direct
192  * manner, since when dealing with GSN meta-transactions the account sending and
193  * paying for execution may not be the actual sender (as far as an application
194  * is concerned).
195  *
196  * This contract is only required for intermediate, library-like contracts.
197  */
198 abstract contract Context {
199     function _msgSender() internal view virtual returns (address payable) {
200         return msg.sender;
201     }
202     function _msgData() internal view virtual returns (bytes memory) {
203         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
204         return msg.data;
205     }
206 }
207 
208 /**
209  * @dev Contract module which provides a basic access control mechanism, where
210  * there is an account (an owner) that can be granted exclusive access to
211  * specific functions.
212  *
213  * By default, the owner account will be the one that deploys the contract. This
214  * can later be changed with {transferOwnership}.
215  *
216  * This module is used through inheritance. It will make available the modifier
217  * `onlyOwner`, which can be applied to your functions to restrict their use to
218  * the owner.
219  */
220 abstract contract Ownable is Context {
221     address private _owner;
222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223     /**
224      * @dev Initializes the contract setting the deployer as the initial owner.
225      */
226     constructor () internal {
227         address msgSender = _msgSender();
228         _owner = msgSender;
229         emit OwnershipTransferred(address(0), msgSender);
230     }
231     /**
232      * @dev Returns the address of the current owner.
233      */
234     function owner() public view returns (address) {
235         return _owner;
236     }
237     /**
238      * @dev Throws if called by any account other than the owner.
239      */
240     modifier onlyOwner() {
241         require(_owner == _msgSender(), "Ownable: caller is not the owner");
242         _;
243     }
244     /**
245      * @dev Leaves the contract without owner. It will not be possible to call
246      * `onlyOwner` functions anymore. Can only be called by the current owner.
247      *
248      * NOTE: Renouncing ownership will leave the contract without an owner,
249      * thereby removing any functionality that is only available to the owner.
250      */
251     function renounceOwnership() public virtual onlyOwner {
252         emit OwnershipTransferred(_owner, address(0));
253         _owner = address(0);
254     }
255     /**
256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
257      * Can only be called by the current owner.
258      */
259     function transferOwnership(address newOwner) public virtual onlyOwner {
260         require(newOwner != address(0), "Ownable: new owner is the zero address");
261         emit OwnershipTransferred(_owner, newOwner);
262         _owner = newOwner;
263     }
264 }
265 
266 /**
267  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
268  * the optional functions; to access them see {ERC20Detailed}.
269  */
270 interface IERC20 {
271     /**
272      * @dev Returns the amount of tokens in existence.
273      */
274     function totalSupply() external view returns (uint256);
275 
276     /**
277      * @dev Returns the amount of tokens owned by `account`.
278      */
279     function balanceOf(address account) external view returns (uint256);
280 
281     /**
282      * @dev Moves `amount` tokens from the caller's account to `recipient`.
283      *
284      * Returns a boolean value indicating whether the operation succeeded.
285      *
286      * Emits a {Transfer} event.
287      */
288     function transfer(address recipient, uint256 amount) external returns (bool);
289 
290     /**
291      * @dev Returns the remaining number of tokens that `spender` will be
292      * allowed to spend on behalf of `owner` through {transferFrom}. This is
293      * zero by default.
294      *
295      * This value changes when {approve} or {transferFrom} are called.
296      */
297     function allowance(address owner, address spender) external view returns (uint256);
298 
299     /**
300      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
301      *
302      * Returns a boolean value indicating whether the operation succeeded.
303      *
304      * IMPORTANT: Beware that changing an allowance with this method brings the risk
305      * that someone may use both the old and the new allowance by unfortunate
306      * transaction ordering. One possible solution to mitigate this race
307      * condition is to first reduce the spender's allowance to 0 and set the
308      * desired value afterwards:
309      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310      *
311      * Emits an {Approval} event.
312      */
313     function approve(address spender, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Moves `amount` tokens from `sender` to `recipient` using the
317      * allowance mechanism. `amount` is then deducted from the caller's
318      * allowance.
319      *
320      * Returns a boolean value indicating whether the operation succeeded.
321      *
322      * Emits a {Transfer} event.
323      */
324     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
325 
326     /**
327      * @dev Emitted when `value` tokens are moved from one account (`from`) to
328      * another (`to`).
329      *
330      * Note that `value` may be zero.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 value);
333 
334     /**
335      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
336      * a call to {approve}. `value` is the new allowance.
337      */
338     event Approval(address indexed owner, address indexed spender, uint256 value);
339 }
340 
341 /**
342  * @dev Collection of functions related to the address type
343  */
344 library Address {
345     /**
346      * @dev Returns true if `account` is a contract.
347      *
348      * This test is non-exhaustive, and there may be false-negatives: during the
349      * execution of a contract's constructor, its address will be reported as
350      * not containing a contract.
351      *
352      * IMPORTANT: It is unsafe to assume that an address for which this
353      * function returns false is an externally-owned account (EOA) and not a
354      * contract.
355      */
356     function isContract(address account) internal view returns (bool) {
357         // This method relies in extcodesize, which returns 0 for contracts in
358         // construction, since the code is only stored at the end of the
359         // constructor execution.
360 
361         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
362         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
363         // for accounts without code, i.e. `keccak256('')`
364         bytes32 codehash;
365         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
366         // solhint-disable-next-line no-inline-assembly
367         assembly { codehash := extcodehash(account) }
368         return (codehash != 0x0 && codehash != accountHash);
369     }
370 
371     /**
372      * @dev Converts an `address` into `address payable`. Note that this is
373      * simply a type cast: the actual underlying value is not changed.
374      *
375      * _Available since v2.4.0._
376      */
377     function toPayable(address account) internal pure returns (address payable) {
378         return address(uint160(account));
379     }
380 
381     /**
382      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
383      * `recipient`, forwarding all available gas and reverting on errors.
384      *
385      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
386      * of certain opcodes, possibly making contracts go over the 2300 gas limit
387      * imposed by `transfer`, making them unable to receive funds via
388      * `transfer`. {sendValue} removes this limitation.
389      *
390      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
391      *
392      * IMPORTANT: because control is transferred to `recipient`, care must be
393      * taken to not create reentrancy vulnerabilities. Consider using
394      * {ReentrancyGuard} or the
395      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
396      *
397      * _Available since v2.4.0._
398      */
399     function sendValue(address payable recipient, uint256 amount) internal {
400         require(address(this).balance >= amount, "Address: insufficient balance");
401 
402         // solhint-disable-next-line avoid-call-value
403         (bool success, ) = recipient.call.value(amount)("");
404         require(success, "Address: unable to send value, recipient may have reverted");
405     }
406 }
407 
408 /**
409  * @title SafeERC20
410  * @dev Wrappers around ERC20 operations that throw on failure (when the token
411  * contract returns false). Tokens that return no value (and instead revert or
412  * throw on failure) are also supported, non-reverting calls are assumed to be
413  * successful.
414  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
415  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
416  */
417 library SafeERC20 {
418     using SafeMath for uint256;
419     using Address for address;
420 
421     function safeTransfer(IERC20 token, address to, uint256 value) internal {
422         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
423     }
424 
425     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
426         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
427     }
428 
429     function safeApprove(IERC20 token, address spender, uint256 value) internal {
430         // safeApprove should only be called when setting an initial allowance,
431         // or when resetting it to zero. To increase and decrease it, use
432         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
433         // solhint-disable-next-line max-line-length
434         require((value == 0) || (token.allowance(address(this), spender) == 0),
435             "SafeERC20: approve from non-zero to non-zero allowance"
436         );
437         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
438     }
439 
440     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).add(value);
442         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
446         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
447         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
448     }
449 
450     /**
451      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
452      * on the return value: the return value is optional (but if data is returned, it must not be false).
453      * @param token The token targeted by the call.
454      * @param data The call data (encoded using abi.encode or one of its variants).
455      */
456     function callOptionalReturn(IERC20 token, bytes memory data) private {
457         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
458         // we're implementing it ourselves.
459 
460         // A Solidity high level call has three parts:
461         //  1. The target address is checked to verify it contains contract code
462         //  2. The call itself is made, and success asserted
463         //  3. The return value is decoded, which in turn checks the size of the returned data.
464         // solhint-disable-next-line max-line-length
465         require(address(token).isContract(), "SafeERC20: call to non-contract");
466 
467         // solhint-disable-next-line avoid-low-level-calls
468         (bool success, bytes memory returndata) = address(token).call(data);
469         require(success, "SafeERC20: low-level call failed");
470 
471         if (returndata.length > 0) { // Return data is optional
472             // solhint-disable-next-line max-line-length
473             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
474         }
475     }
476 }
477 
478 contract Depositor is Ownable{
479     using SafeMath for uint256;
480     using SafeERC20 for IERC20;
481     
482     IERC20 srx = IERC20(0xb149d8C556D888785aD13aDb67Ed29dc64edCD71); //SRX token
483     
484     string[] public nickNames;
485     bool public isPaused = true;
486     
487     function pauseDeposit() external onlyOwner{
488         isPaused = true;
489     }
490     
491      function unpauseDeposit() external onlyOwner{
492         isPaused = false;
493     }
494     
495     mapping(string => uint256) public _balances;
496     
497     mapping(address => uint256) public track_balances;
498     
499     function totalNickNames() external view returns(uint256){
500         return nickNames.length;
501     }
502     
503     event Deposit(string nickName, uint256 amount);
504     
505     function deposit(string memory nickName) external{
506         require(!isPaused, "Deposits are paused.");
507         uint256 amount = srx.balanceOf(msg.sender);
508         require(amount > 0, "Cannot deposit 0");
509         if(_balances[nickName] == 0){
510             nickNames.push(nickName);
511         }
512         _balances[nickName] = _balances[nickName].add(amount);
513         track_balances[msg.sender] = track_balances[msg.sender].add(amount);
514         srx.safeTransferFrom(msg.sender, address(this), amount);
515         emit Deposit(nickName, amount);
516     }   
517 }