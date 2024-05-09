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
111 // File: contracts/IEDOToken.sol
112 
113 pragma solidity ^0.5.0;
114 
115 
116 interface IEDOToken {
117     function balanceOf(address account) external view returns (uint256);
118     function transfer(address recipient, uint256 amount) external returns (bool);
119     function burn(uint256 _amount) external returns (bool);
120 }
121 
122 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
123 
124 pragma solidity ^0.5.0;
125 
126 /**
127  * @dev Contract module which provides a basic access control mechanism, where
128  * there is an account (an owner) that can be granted exclusive access to
129  * specific functions.
130  *
131  * This module is used through inheritance. It will make available the modifier
132  * `onlyOwner`, which can be aplied to your functions to restrict their use to
133  * the owner.
134  */
135 contract Ownable {
136     address private _owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     /**
141      * @dev Initializes the contract setting the deployer as the initial owner.
142      */
143     constructor () internal {
144         _owner = msg.sender;
145         emit OwnershipTransferred(address(0), _owner);
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if called by any account other than the owner.
157      */
158     modifier onlyOwner() {
159         require(isOwner(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     /**
164      * @dev Returns true if the caller is the current owner.
165      */
166     function isOwner() public view returns (bool) {
167         return msg.sender == _owner;
168     }
169 
170     /**
171      * @dev Leaves the contract without owner. It will not be possible to call
172      * `onlyOwner` functions anymore. Can only be called by the current owner.
173      *
174      * > Note: Renouncing ownership will leave the contract without an owner,
175      * thereby removing any functionality that is only available to the owner.
176      */
177     function renounceOwnership() public onlyOwner {
178         emit OwnershipTransferred(_owner, address(0));
179         _owner = address(0);
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Can only be called by the current owner.
185      */
186     function transferOwnership(address newOwner) public onlyOwner {
187         _transferOwnership(newOwner);
188     }
189 
190     /**
191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
192      */
193     function _transferOwnership(address newOwner) internal {
194         require(newOwner != address(0), "Ownable: new owner is the zero address");
195         emit OwnershipTransferred(_owner, newOwner);
196         _owner = newOwner;
197     }
198 }
199 
200 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
201 
202 pragma solidity ^0.5.0;
203 
204 /**
205  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
206  * the optional functions; to access them see `ERC20Detailed`.
207  */
208 interface IERC20 {
209     /**
210      * @dev Returns the amount of tokens in existence.
211      */
212     function totalSupply() external view returns (uint256);
213 
214     /**
215      * @dev Returns the amount of tokens owned by `account`.
216      */
217     function balanceOf(address account) external view returns (uint256);
218 
219     /**
220      * @dev Moves `amount` tokens from the caller's account to `recipient`.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a `Transfer` event.
225      */
226     function transfer(address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Returns the remaining number of tokens that `spender` will be
230      * allowed to spend on behalf of `owner` through `transferFrom`. This is
231      * zero by default.
232      *
233      * This value changes when `approve` or `transferFrom` are called.
234      */
235     function allowance(address owner, address spender) external view returns (uint256);
236 
237     /**
238      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * > Beware that changing an allowance with this method brings the risk
243      * that someone may use both the old and the new allowance by unfortunate
244      * transaction ordering. One possible solution to mitigate this race
245      * condition is to first reduce the spender's allowance to 0 and set the
246      * desired value afterwards:
247      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248      *
249      * Emits an `Approval` event.
250      */
251     function approve(address spender, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Moves `amount` tokens from `sender` to `recipient` using the
255      * allowance mechanism. `amount` is then deducted from the caller's
256      * allowance.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a `Transfer` event.
261      */
262     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Emitted when `value` tokens are moved from one account (`from`) to
266      * another (`to`).
267      *
268      * Note that `value` may be zero.
269      */
270     event Transfer(address indexed from, address indexed to, uint256 value);
271 
272     /**
273      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
274      * a call to `approve`. `value` is the new allowance.
275      */
276     event Approval(address indexed owner, address indexed spender, uint256 value);
277 }
278 
279 // File: openzeppelin-solidity/contracts/utils/Address.sol
280 
281 pragma solidity ^0.5.0;
282 
283 /**
284  * @dev Collection of functions related to the address type,
285  */
286 library Address {
287     /**
288      * @dev Returns true if `account` is a contract.
289      *
290      * This test is non-exhaustive, and there may be false-negatives: during the
291      * execution of a contract's constructor, its address will be reported as
292      * not containing a contract.
293      *
294      * > It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies in extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         uint256 size;
303         // solhint-disable-next-line no-inline-assembly
304         assembly { size := extcodesize(account) }
305         return size > 0;
306     }
307 }
308 
309 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
310 
311 pragma solidity ^0.5.0;
312 
313 
314 
315 
316 /**
317  * @title SafeERC20
318  * @dev Wrappers around ERC20 operations that throw on failure (when the token
319  * contract returns false). Tokens that return no value (and instead revert or
320  * throw on failure) are also supported, non-reverting calls are assumed to be
321  * successful.
322  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
323  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
324  */
325 library SafeERC20 {
326     using SafeMath for uint256;
327     using Address for address;
328 
329     function safeTransfer(IERC20 token, address to, uint256 value) internal {
330         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
331     }
332 
333     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
334         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
335     }
336 
337     function safeApprove(IERC20 token, address spender, uint256 value) internal {
338         // safeApprove should only be called when setting an initial allowance,
339         // or when resetting it to zero. To increase and decrease it, use
340         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
341         // solhint-disable-next-line max-line-length
342         require((value == 0) || (token.allowance(address(this), spender) == 0),
343             "SafeERC20: approve from non-zero to non-zero allowance"
344         );
345         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
346     }
347 
348     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
349         uint256 newAllowance = token.allowance(address(this), spender).add(value);
350         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
351     }
352 
353     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
354         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
355         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
356     }
357 
358     /**
359      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
360      * on the return value: the return value is optional (but if data is returned, it must not be false).
361      * @param token The token targeted by the call.
362      * @param data The call data (encoded using abi.encode or one of its variants).
363      */
364     function callOptionalReturn(IERC20 token, bytes memory data) private {
365         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
366         // we're implementing it ourselves.
367 
368         // A Solidity high level call has three parts:
369         //  1. The target address is checked to verify it contains contract code
370         //  2. The call itself is made, and success asserted
371         //  3. The return value is decoded, which in turn checks the size of the returned data.
372         // solhint-disable-next-line max-line-length
373         require(address(token).isContract(), "SafeERC20: call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = address(token).call(data);
377         require(success, "SafeERC20: low-level call failed");
378 
379         if (returndata.length > 0) { // Return data is optional
380             // solhint-disable-next-line max-line-length
381             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
382         }
383     }
384 }
385 
386 // File: contracts/Withdrawable.sol
387 
388 pragma solidity ^0.5.0;
389 
390 
391 
392 
393 contract Withdrawable is Ownable {
394     using SafeERC20 for IERC20;
395 
396     function withdraw(address asset) onlyOwner public {
397         if (asset == address(0)) {
398             msg.sender.transfer(address(this).balance);
399         } else {
400             IERC20 token = IERC20(asset);
401             token.safeTransfer(msg.sender, token.balanceOf(address(this)));
402         }
403     }
404 }
405 
406 // File: contracts/Burner.sol
407 
408 pragma solidity ^0.5.0;
409 
410 
411 
412 
413 contract Burner is Withdrawable {
414     using SafeMath for uint256;
415 
416     IEDOToken edo;
417 
418     address public unburnedDestination;
419     uint256 public percentageToBurn;
420     bool public paused;
421 
422     event Burn(uint burnedAmount, uint savedAmount);
423 
424     constructor(address edoTokenAddress, address unburnedDestination_, uint percentageToBurn_) public {
425         paused = false;
426         edo = IEDOToken(edoTokenAddress);
427         percentageToBurn = percentageToBurn_;
428         unburnedDestination = unburnedDestination_;
429     }
430 
431     function setPercentageToBurn (uint value) onlyOwner external {
432         percentageToBurn = value;
433     }
434 
435     function setUnburnedDestination (address value) onlyOwner external {
436         unburnedDestination = value;
437     }
438 
439     function setPaused (bool value) onlyOwner external {
440         paused = value;
441     }
442 
443     function burn() external {
444         require(!paused, 'cannot burn when paused');
445 
446         uint total = edo.balanceOf(address(this));
447         uint toBurn = total.mul(percentageToBurn).div(100);
448         require(edo.burn(toBurn), 'cannot burn');
449         uint notBurned = edo.balanceOf(address(this));
450         require(edo.transfer(unburnedDestination, notBurned), 'cannot transfer unburned tokens');
451         emit Burn(toBurn, notBurned);
452     }
453 
454 
455 }