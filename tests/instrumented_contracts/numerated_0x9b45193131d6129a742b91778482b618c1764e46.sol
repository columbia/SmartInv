1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
117  * the optional functions; to access them see `ERC20Detailed`.
118  */
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129 
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a `Transfer` event.
136      */
137     function transfer(address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through `transferFrom`. This is
142      * zero by default.
143      *
144      * This value changes when `approve` or `transferFrom` are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * > Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an `Approval` event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a `Transfer` event.
172      */
173     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to `approve`. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 // File: openzeppelin-solidity/contracts/utils/Address.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @dev Collection of functions related to the address type,
196  */
197 library Address {
198     /**
199      * @dev Returns true if `account` is a contract.
200      *
201      * This test is non-exhaustive, and there may be false-negatives: during the
202      * execution of a contract's constructor, its address will be reported as
203      * not containing a contract.
204      *
205      * > It is unsafe to assume that an address for which this function returns
206      * false is an externally-owned account (EOA) and not a contract.
207      */
208     function isContract(address account) internal view returns (bool) {
209         // This method relies in extcodesize, which returns 0 for contracts in
210         // construction, since the code is only stored at the end of the
211         // constructor execution.
212 
213         uint256 size;
214         // solhint-disable-next-line no-inline-assembly
215         assembly { size := extcodesize(account) }
216         return size > 0;
217     }
218 }
219 
220 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
221 
222 pragma solidity ^0.5.0;
223 
224 
225 
226 
227 /**
228  * @title SafeERC20
229  * @dev Wrappers around ERC20 operations that throw on failure (when the token
230  * contract returns false). Tokens that return no value (and instead revert or
231  * throw on failure) are also supported, non-reverting calls are assumed to be
232  * successful.
233  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
234  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
235  */
236 library SafeERC20 {
237     using SafeMath for uint256;
238     using Address for address;
239 
240     function safeTransfer(IERC20 token, address to, uint256 value) internal {
241         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
242     }
243 
244     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
245         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
246     }
247 
248     function safeApprove(IERC20 token, address spender, uint256 value) internal {
249         // safeApprove should only be called when setting an initial allowance,
250         // or when resetting it to zero. To increase and decrease it, use
251         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
252         // solhint-disable-next-line max-line-length
253         require((value == 0) || (token.allowance(address(this), spender) == 0),
254             "SafeERC20: approve from non-zero to non-zero allowance"
255         );
256         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
257     }
258 
259     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
260         uint256 newAllowance = token.allowance(address(this), spender).add(value);
261         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
262     }
263 
264     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
265         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
266         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
267     }
268 
269     /**
270      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
271      * on the return value: the return value is optional (but if data is returned, it must not be false).
272      * @param token The token targeted by the call.
273      * @param data The call data (encoded using abi.encode or one of its variants).
274      */
275     function callOptionalReturn(IERC20 token, bytes memory data) private {
276         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
277         // we're implementing it ourselves.
278 
279         // A Solidity high level call has three parts:
280         //  1. The target address is checked to verify it contains contract code
281         //  2. The call itself is made, and success asserted
282         //  3. The return value is decoded, which in turn checks the size of the returned data.
283         // solhint-disable-next-line max-line-length
284         require(address(token).isContract(), "SafeERC20: call to non-contract");
285 
286         // solhint-disable-next-line avoid-low-level-calls
287         (bool success, bytes memory returndata) = address(token).call(data);
288         require(success, "SafeERC20: low-level call failed");
289 
290         if (returndata.length > 0) { // Return data is optional
291             // solhint-disable-next-line max-line-length
292             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
293         }
294     }
295 }
296 
297 // File: contracts/interfaces/IEDOToken.sol
298 
299 pragma solidity ^0.5.0;
300 
301 
302 interface IEDOToken {
303     function balanceOf(address account) external view returns (uint256);
304     function transfer(address recipient, uint256 amount) external returns (bool);
305     function burn(uint256 _amount) external returns (bool);
306 }
307 
308 // File: contracts/interfaces/IKyberNetwork.sol
309 
310 pragma solidity >=0.4.21 <0.6.0;
311 
312 interface IKyberNetwork {
313 
314     function getExpectedRate(address src, address dest, uint srcQty) external view
315         returns (uint expectedRate, uint slippageRate);
316 
317     function trade(
318         address src,
319         uint srcAmount,
320         address dest,
321         address payable destAddress,
322         uint maxDestAmount,
323         uint minConversionRate,
324         address walletId
325     ) external payable returns(uint256);
326 }
327 
328 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
329 
330 pragma solidity ^0.5.0;
331 
332 /**
333  * @dev Contract module which provides a basic access control mechanism, where
334  * there is an account (an owner) that can be granted exclusive access to
335  * specific functions.
336  *
337  * This module is used through inheritance. It will make available the modifier
338  * `onlyOwner`, which can be aplied to your functions to restrict their use to
339  * the owner.
340  */
341 contract Ownable {
342     address private _owner;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346     /**
347      * @dev Initializes the contract setting the deployer as the initial owner.
348      */
349     constructor () internal {
350         _owner = msg.sender;
351         emit OwnershipTransferred(address(0), _owner);
352     }
353 
354     /**
355      * @dev Returns the address of the current owner.
356      */
357     function owner() public view returns (address) {
358         return _owner;
359     }
360 
361     /**
362      * @dev Throws if called by any account other than the owner.
363      */
364     modifier onlyOwner() {
365         require(isOwner(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     /**
370      * @dev Returns true if the caller is the current owner.
371      */
372     function isOwner() public view returns (bool) {
373         return msg.sender == _owner;
374     }
375 
376     /**
377      * @dev Leaves the contract without owner. It will not be possible to call
378      * `onlyOwner` functions anymore. Can only be called by the current owner.
379      *
380      * > Note: Renouncing ownership will leave the contract without an owner,
381      * thereby removing any functionality that is only available to the owner.
382      */
383     function renounceOwnership() public onlyOwner {
384         emit OwnershipTransferred(_owner, address(0));
385         _owner = address(0);
386     }
387 
388     /**
389      * @dev Transfers ownership of the contract to a new account (`newOwner`).
390      * Can only be called by the current owner.
391      */
392     function transferOwnership(address newOwner) public onlyOwner {
393         _transferOwnership(newOwner);
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      */
399     function _transferOwnership(address newOwner) internal {
400         require(newOwner != address(0), "Ownable: new owner is the zero address");
401         emit OwnershipTransferred(_owner, newOwner);
402         _owner = newOwner;
403     }
404 }
405 
406 // File: contracts/Withdrawable.sol
407 
408 pragma solidity ^0.5.0;
409 
410 
411 
412 
413 contract Withdrawable is Ownable {
414     using SafeERC20 for IERC20;
415 
416     function withdraw(address asset) onlyOwner public {
417         if (asset == address(0)) {
418             msg.sender.transfer(address(this).balance);
419         } else {
420             IERC20 token = IERC20(asset);
421             token.safeTransfer(msg.sender, token.balanceOf(address(this)));
422         }
423     }
424 }
425 
426 // File: contracts/Burner.sol
427 
428 pragma solidity ^0.5.0;
429 
430 
431 
432 
433 
434 
435 
436 contract Burner is Withdrawable {
437     using SafeMath for uint256;
438     using SafeERC20 for IERC20;
439     uint constant BIG_LIMIT = 1e36;
440     address constant ETHER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
441 
442     IEDOToken edo;
443     IKyberNetwork kyberNetwork;
444     address public kyberFeeWallet;
445 
446     address public unburnedDestination;
447     uint256 public percentageToBurn;
448     bool public paused;
449 
450     event Burn(uint burnedAmount, uint savedAmount);
451     event TokenTrade(address srcToken, uint srcAmount, uint burnTokenAmount);
452 
453     constructor(address edoTokenAddress, address unburnedDestination_, uint percentageToBurn_, address kyberNetAddress, address kyberFeeWallet_) public {
454         paused = false;
455         edo = IEDOToken(edoTokenAddress);
456         percentageToBurn = percentageToBurn_;
457         unburnedDestination = unburnedDestination_;
458         kyberNetwork = IKyberNetwork(kyberNetAddress);
459         kyberFeeWallet = kyberFeeWallet_;
460     }
461 
462     function setPercentageToBurn (uint value) onlyOwner external {
463         percentageToBurn = value;
464     }
465 
466     function setUnburnedDestination (address value) onlyOwner external {
467         unburnedDestination = value;
468     }
469 
470     function setPaused (bool value) onlyOwner external {
471         paused = value;
472     }
473 
474     function setKyberFeeWallet(address _wallet) public onlyOwner {
475         kyberFeeWallet = _wallet;
476     }
477 
478     function burn() public {
479         require(!paused, 'cannot burn when paused');
480 
481         uint total = edo.balanceOf(address(this));
482         uint toBurn = total.mul(percentageToBurn).div(100);
483         require(edo.burn(toBurn), 'cannot burn');
484         uint notBurned = edo.balanceOf(address(this));
485         require(edo.transfer(unburnedDestination, notBurned), 'cannot transfer unburned tokens');
486         emit Burn(toBurn, notBurned);
487     }
488 
489     function convertAndBurn(address [] calldata tokens) external {
490         for (uint i = 0; i < tokens.length; i++) {
491             _convert(tokens[i]);
492         }
493         burn();
494     }
495 
496     function _convert(address srcToken) internal {
497         uint srcAmount;
498         uint converted;
499         if (srcToken == ETHER || srcToken == address(0)) {
500             srcAmount = address(this).balance;
501             converted = kyberNetwork.trade
502                 .value(srcAmount)(ETHER, srcAmount, address(edo), address(uint160(address(this))), BIG_LIMIT, 1, kyberFeeWallet);
503         } else {
504             srcAmount = IERC20(srcToken).balanceOf(address(this));
505             if (IERC20(srcToken).allowance(address(this), address(kyberNetwork)) > 0) {
506                 IERC20(srcToken).safeApprove(address(kyberNetwork), 0);
507             }
508             IERC20(srcToken).safeApprove(address(kyberNetwork), srcAmount);
509             converted = kyberNetwork.trade(srcToken, srcAmount, address(edo), address(uint160(address(this))), BIG_LIMIT, 1, kyberFeeWallet);
510         }
511         emit TokenTrade(srcToken, srcAmount, converted);
512     }
513 
514     function () external payable {}
515 
516 }