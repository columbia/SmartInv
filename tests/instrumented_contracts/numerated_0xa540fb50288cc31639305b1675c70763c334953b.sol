1 pragma solidity ^0.5.10;
2 pragma experimental ABIEncoderV2;
3 
4 
5 
6 /**
7  * @dev Contract module which provides a basic access control mechanism, where
8  * there is an account (an owner) that can be granted exclusive access to
9  * specific functions.
10  *
11  * This module is used through inheritance. It will make available the modifier
12  * `onlyOwner`, which can be applied to your functions to restrict their use to
13  * the owner.
14  */
15 contract Ownable {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor () internal {
24         _owner = msg.sender;
25         emit OwnershipTransferred(address(0), _owner);
26     }
27 
28     /**
29      * @dev Returns the address of the current owner.
30      */
31     function owner() public view returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(isOwner(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     /**
44      * @dev Returns true if the caller is the current owner.
45      */
46     function isOwner() public view returns (bool) {
47         return msg.sender == _owner;
48     }
49 
50     /**
51      * @dev Leaves the contract without owner. It will not be possible to call
52      * `onlyOwner` functions anymore. Can only be called by the current owner.
53      *
54      * > Note: Renouncing ownership will leave the contract without an owner,
55      * thereby removing any functionality that is only available to the owner.
56      */
57     function renounceOwnership() public onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     /**
63      * @dev Transfers ownership of the contract to a new account (`newOwner`).
64      * Can only be called by the current owner.
65      */
66     function transferOwnership(address newOwner) public onlyOwner {
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      */
73     function _transferOwnership(address newOwner) internal {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 
81 /**
82  * @dev Wrappers over Solidity's arithmetic operations with added overflow
83  * checks.
84  *
85  * Arithmetic operations in Solidity wrap on overflow. This can easily result
86  * in bugs, because programmers usually assume that an overflow raises an
87  * error, which is the standard behavior in high level programming languages.
88  * `SafeMath` restores this intuition by reverting the transaction when an
89  * operation overflows.
90  *
91  * Using this library instead of the unchecked operations eliminates an entire
92  * class of bugs, so it's recommended to use it always.
93  */
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
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
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b <= a, "SafeMath: subtraction overflow");
122         uint256 c = a - b;
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Solidity only automatically asserts when dividing by 0
163         require(b > 0, "SafeMath: division by zero");
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
182         require(b != 0, "SafeMath: modulo by zero");
183         return a % b;
184     }
185 }
186 
187 
188 /**
189  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
190  * the optional functions; to access them see `ERC20Detailed`.
191  */
192 interface IERC20 {
193     /**
194      * @dev Returns the amount of tokens in existence.
195      */
196     function totalSupply() external view returns (uint256);
197 
198     /**
199      * @dev Returns the amount of tokens owned by `account`.
200      */
201     function balanceOf(address account) external view returns (uint256);
202 
203     /**
204      * @dev Moves `amount` tokens from the caller's account to `recipient`.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * Emits a `Transfer` event.
209      */
210     function transfer(address recipient, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Returns the remaining number of tokens that `spender` will be
214      * allowed to spend on behalf of `owner` through `transferFrom`. This is
215      * zero by default.
216      *
217      * This value changes when `approve` or `transferFrom` are called.
218      */
219     function allowance(address owner, address spender) external view returns (uint256);
220 
221     /**
222      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * > Beware that changing an allowance with this method brings the risk
227      * that someone may use both the old and the new allowance by unfortunate
228      * transaction ordering. One possible solution to mitigate this race
229      * condition is to first reduce the spender's allowance to 0 and set the
230      * desired value afterwards:
231      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232      *
233      * Emits an `Approval` event.
234      */
235     function approve(address spender, uint256 amount) external returns (bool);
236 
237     /**
238      * @dev Moves `amount` tokens from `sender` to `recipient` using the
239      * allowance mechanism. `amount` is then deducted from the caller's
240      * allowance.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * Emits a `Transfer` event.
245      */
246     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
247 
248     /**
249      * @dev Emitted when `value` tokens are moved from one account (`from`) to
250      * another (`to`).
251      *
252      * Note that `value` may be zero.
253      */
254     event Transfer(address indexed from, address indexed to, uint256 value);
255 
256     /**
257      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
258      * a call to `approve`. `value` is the new allowance.
259      */
260     event Approval(address indexed owner, address indexed spender, uint256 value);
261 }
262 
263 
264 
265 
266 
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * This test is non-exhaustive, and there may be false-negatives: during the
276      * execution of a contract's constructor, its address will be reported as
277      * not containing a contract.
278      *
279      * > It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      */
282     function isContract(address account) internal view returns (bool) {
283         // This method relies in extcodesize, which returns 0 for contracts in
284         // construction, since the code is only stored at the end of the
285         // constructor execution.
286         
287         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
288         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
289         // for accounts without code, i.e. `keccak256('')`
290         bytes32 codehash;
291         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { codehash := extcodehash(account) }
294         return (codehash != 0x0 && codehash != accountHash);
295     }
296 
297     /**
298      * @dev Converts an `address` into `address payable`. Note that this is
299      * simply a type cast: the actual underlying value is not changed.
300      */
301     function toPayable(address account) internal pure returns (address payable) {
302         return address(uint160(account));
303     }
304 }
305 
306 /**
307  * @title SafeERC20
308  * @dev Wrappers around ERC20 operations that throw on failure (when the token
309  * contract returns false). Tokens that return no value (and instead revert or
310  * throw on failure) are also supported, non-reverting calls are assumed to be
311  * successful.
312  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
313  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
314  */
315 library SafeERC20 {
316     using SafeMath for uint256;
317     using Address for address;
318 
319     function safeTransfer(IERC20 token, address to, uint256 value) internal {
320         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
321     }
322 
323     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
324         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
325     }
326 
327     function safeApprove(IERC20 token, address spender, uint256 value) internal {
328         // safeApprove should only be called when setting an initial allowance,
329         // or when resetting it to zero. To increase and decrease it, use
330         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
331         // solhint-disable-next-line max-line-length
332         require((value == 0) || (token.allowance(address(this), spender) == 0),
333             "SafeERC20: approve from non-zero to non-zero allowance"
334         );
335         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
336     }
337 
338     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
339         uint256 newAllowance = token.allowance(address(this), spender).add(value);
340         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
341     }
342 
343     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
344         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
345         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
346     }
347 
348     /**
349      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
350      * on the return value: the return value is optional (but if data is returned, it must not be false).
351      * @param token The token targeted by the call.
352      * @param data The call data (encoded using abi.encode or one of its variants).
353      */
354     function callOptionalReturn(IERC20 token, bytes memory data) private {
355         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
356         // we're implementing it ourselves.
357 
358         // A Solidity high level call has three parts:
359         //  1. The target address is checked to verify it contains contract code
360         //  2. The call itself is made, and success asserted
361         //  3. The return value is decoded, which in turn checks the size of the returned data.
362         // solhint-disable-next-line max-line-length
363         require(address(token).isContract(), "SafeERC20: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = address(token).call(data);
367         require(success, "SafeERC20: low-level call failed");
368 
369         if (returndata.length > 0) { // Return data is optional
370             // solhint-disable-next-line max-line-length
371             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
372         }
373     }
374 }
375 
376 contract IWETH is IERC20 {
377     function withdraw(uint256 amount) external;
378 }
379 
380 contract ApprovalHandler is Ownable {
381 
382     using SafeERC20 for IERC20;
383 
384     function transferFrom(IERC20 erc, address sender, address receiver, uint256 numTokens) external onlyOwner {
385         erc.safeTransferFrom(sender, receiver, numTokens);
386     }
387 }
388 
389 contract DexTrading is Ownable {
390     using SafeMath for uint256;
391     using SafeERC20 for IERC20;
392 
393     ApprovalHandler public approvalHandler;
394 
395     event Trade(address indexed from, address indexed to, uint256 toAmount, address indexed trader, address[] exchanges, uint256 tradeType);
396 
397     IWETH public WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
398 
399     constructor() public {
400         approvalHandler = new ApprovalHandler();
401     }
402 
403     function trade(
404         IERC20 from,
405         IERC20 to,
406         uint256 fromAmount,
407         address[] memory exchanges,
408         address[] memory approvals,
409         bytes memory data,
410         uint256[] memory offsets,
411         uint256[] memory etherValues,
412         uint256 limitAmount,
413         uint256 tradeType
414     ) public payable {
415         require(exchanges.length > 0, 'No Exchanges');
416 
417         // if from is an ERC20, pull tokens from msg.sender
418         if (address(from) != 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
419             approvalHandler.transferFrom(from, msg.sender, address(this), fromAmount);
420         }
421 
422         // execute trades on dexes
423         executeTrades(from, exchanges, approvals, data, offsets, etherValues);
424 
425         // check how many tokens were received after trade execution
426         uint256 tradeReturn = viewBalance(to, address(this));
427         require(tradeReturn >= limitAmount, 'Trade returned less than the minimum amount');
428 
429         // return any unspent funds
430         uint256 leftover = viewBalance(from, address(this));
431         if (leftover > 0) {
432             sendFunds(from, msg.sender, leftover);
433         }
434 
435         sendFunds(to, msg.sender, tradeReturn);
436 
437         emit Trade(address(from), address(to), tradeReturn, msg.sender, exchanges, tradeType);
438     }
439 
440     function executeTrades(
441         IERC20 from,
442         address[] memory exchanges,
443         address[] memory approvals,
444         bytes memory data,
445         uint256[] memory offsets,
446         uint256[] memory etherValues) internal {
447             for (uint i = 0; i < exchanges.length; i++) {
448                 // prevent calling the approvalHandler and check that exchange is a valid contract address
449                 require(exchanges[i] != address(approvalHandler) && isContract(exchanges[i]), 'Invalid Address');
450                 if (approvals[i] != address(0)) {
451                     // handle approval if the aprovee is not the exchange address
452                     approve(from, approvals[i]);
453                 } else {
454                     // handle approval if the approvee is the exchange address
455                     approve(from, exchanges[i]);
456                 }
457                 // do trade
458                 require(external_call(exchanges[i], etherValues[i], offsets[i], offsets[i + 1] - offsets[i], data), 'External Call Failed');
459             }
460         }
461 
462     // ERC20 Utility Functions
463 
464     function approve(IERC20 erc, address approvee) internal {
465         if (
466             address(erc) != 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE &&
467             erc.allowance(address(this), approvee) == 0
468         ) {
469             erc.safeApprove(approvee, uint256(-1));
470         }
471     }
472 
473     function viewBalance(IERC20 erc, address owner) internal view returns(uint256) {
474         if (address(erc) == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
475             return owner.balance;
476         } else {
477             return erc.balanceOf(owner);
478         }
479     }
480 
481     function sendFunds(IERC20 erc, address payable receiver, uint256 funds) internal {
482         if (address(erc) == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
483             receiver.transfer(funds);
484         } else {
485             erc.safeTransfer(receiver, funds);
486         }
487     }
488 
489     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
490     // call has been separated into its own function in order to take advantage
491     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
492     function external_call(address destination, uint value, uint dataOffset, uint dataLength, bytes memory data) internal returns (bool) {
493         bool result;
494         assembly {
495             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
496             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
497             result := call(
498                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
499                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
500                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
501                 destination,
502                 value,
503                 add(d, dataOffset),
504                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
505                 x,
506                 0                  // Output is ignored, therefore the output size is zero
507             )
508         }
509         return result;
510     }
511 
512     /**
513      * @dev Returns true if `account` is a contract.
514      *
515      * This test is non-exhaustive, and there may be false-negatives: during the
516      * execution of a contract's constructor, its address will be reported as
517      * not containing a contract.
518      *
519      * > It is unsafe to assume that an address for which this function returns
520      * false is an externally-owned account (EOA) and not a contract.
521      */
522     function isContract(address account) internal view returns (bool) {
523         // This method relies in extcodesize, which returns 0 for contracts in
524         // construction, since the code is only stored at the end of the
525         // constructor execution.
526         
527         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
528         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
529         // for accounts without code, i.e. `keccak256('')`
530         bytes32 codehash;
531         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
532         // solhint-disable-next-line no-inline-assembly
533         assembly { codehash := extcodehash(account) }
534         return (codehash != 0x0 && codehash != accountHash);
535     }
536 
537     function withdrawWeth() external {
538         uint256 amount = WETH.balanceOf(address(this));
539         WETH.withdraw(amount);
540     }
541 
542     function () external payable {
543         require(msg.sender != tx.origin);
544     }
545 }