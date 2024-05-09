1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
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
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
166  * the optional functions; to access them see {ERC20Detailed}.
167  */
168 interface IERC20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address recipient, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 pragma solidity ^0.5.5;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following 
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
266         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
267         // for accounts without code, i.e. `keccak256('')`
268         bytes32 codehash;
269         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { codehash := extcodehash(account) }
272         return (codehash != accountHash && codehash != 0x0);
273     }
274 
275     /**
276      * @dev Converts an `address` into `address payable`. Note that this is
277      * simply a type cast: the actual underlying value is not changed.
278      *
279      * _Available since v2.4.0._
280      */
281     function toPayable(address account) internal pure returns (address payable) {
282         return address(uint160(account));
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      *
301      * _Available since v2.4.0._
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         // solhint-disable-next-line avoid-call-value
307         (bool success, ) = recipient.call.value(amount)("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
313 
314 pragma solidity ^0.5.0;
315 
316 
317 
318 
319 /**
320  * @title SafeERC20
321  * @dev Wrappers around ERC20 operations that throw on failure (when the token
322  * contract returns false). Tokens that return no value (and instead revert or
323  * throw on failure) are also supported, non-reverting calls are assumed to be
324  * successful.
325  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
326  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
327  */
328 library SafeERC20 {
329     using SafeMath for uint256;
330     using Address for address;
331 
332     function safeTransfer(IERC20 token, address to, uint256 value) internal {
333         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
334     }
335 
336     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
337         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
338     }
339 
340     function safeApprove(IERC20 token, address spender, uint256 value) internal {
341         // safeApprove should only be called when setting an initial allowance,
342         // or when resetting it to zero. To increase and decrease it, use
343         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
344         // solhint-disable-next-line max-line-length
345         require((value == 0) || (token.allowance(address(this), spender) == 0),
346             "SafeERC20: approve from non-zero to non-zero allowance"
347         );
348         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
349     }
350 
351     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
352         uint256 newAllowance = token.allowance(address(this), spender).add(value);
353         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
354     }
355 
356     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
357         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
358         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
359     }
360 
361     /**
362      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
363      * on the return value: the return value is optional (but if data is returned, it must not be false).
364      * @param token The token targeted by the call.
365      * @param data The call data (encoded using abi.encode or one of its variants).
366      */
367     function callOptionalReturn(IERC20 token, bytes memory data) private {
368         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
369         // we're implementing it ourselves.
370 
371         // A Solidity high level call has three parts:
372         //  1. The target address is checked to verify it contains contract code
373         //  2. The call itself is made, and success asserted
374         //  3. The return value is decoded, which in turn checks the size of the returned data.
375         // solhint-disable-next-line max-line-length
376         require(address(token).isContract(), "SafeERC20: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = address(token).call(data);
380         require(success, "SafeERC20: low-level call failed");
381 
382         if (returndata.length > 0) { // Return data is optional
383             // solhint-disable-next-line max-line-length
384             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
385         }
386     }
387 }
388 
389 // File: contracts/eth/EthManager.sol
390 
391 pragma solidity 0.5.17;
392 
393 
394 
395 
396 contract EthManager {
397     using SafeMath for uint256;
398     using SafeERC20 for IERC20;
399 
400     IERC20 public constant ETH_ADDRESS = IERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
401 
402     mapping(bytes32 => bool) public usedEvents_;
403 
404     event Locked(
405         address indexed token,
406         address indexed sender,
407         uint256 amount,
408         address recipient
409     );
410 
411     event Unlocked(
412         address ethToken,
413         uint256 amount,
414         address recipient,
415         bytes32 receiptId
416     );
417 
418     address public wallet;
419     modifier onlyWallet {
420         require(msg.sender == wallet, "EthManager/not-authorized");
421         _;
422     }
423 
424     /**
425      * @dev constructor
426      * @param _wallet is the multisig wallet
427      */
428     constructor(address _wallet) public {
429         wallet = _wallet;
430     }
431 
432     /**
433      * @dev lock ETHs to be minted on harmony chain
434      * @param amount amount of tokens to lock
435      * @param recipient recipient address on the harmony chain
436      */
437     function lockEth(
438         uint256 amount,
439         address recipient
440     ) public payable {
441         require(
442             recipient != address(0),
443             "EthManager/recipient is a zero address"
444         );
445         require(msg.value == amount, "EthManager/zero token locked");
446         emit Locked(address(ETH_ADDRESS), msg.sender, amount, recipient);
447     }
448 
449     /**
450      * @dev unlock ETHs after burning them on harmony chain
451      * @param amount amount of unlock tokens
452      * @param recipient recipient of the unlock tokens
453      * @param receiptId transaction hash of the burn event on harmony chain
454      */
455     function unlockEth(
456         uint256 amount,
457         address payable recipient,
458         bytes32 receiptId
459     ) public onlyWallet {
460         require(
461             !usedEvents_[receiptId],
462             "EthManager/The burn event cannot be reused"
463         );
464         usedEvents_[receiptId] = true;
465         recipient.transfer(amount);
466         emit Unlocked(address(ETH_ADDRESS), amount, recipient, receiptId);
467     }
468 }