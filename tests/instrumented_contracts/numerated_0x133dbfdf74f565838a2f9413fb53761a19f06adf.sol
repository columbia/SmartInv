1 pragma solidity >=0.5.5 <0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      *
56      * _Available since v2.4.0._
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      *
114      * _Available since v2.4.0._
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 /**
160  * @dev Collection of functions related to the address type
161  */
162 library Address {
163     /**
164      * @dev Returns true if `account` is a contract.
165      *
166      * [IMPORTANT]
167      * ====
168      * It is unsafe to assume that an address for which this function returns
169      * false is an externally-owned account (EOA) and not a contract.
170      *
171      * Among others, `isContract` will return false for the following 
172      * types of addresses:
173      *
174      *  - an externally-owned account
175      *  - a contract in construction
176      *  - an address where a contract will be created
177      *  - an address where a contract lived, but was destroyed
178      * ====
179      */
180     function isContract(address account) internal view returns (bool) {
181         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
182         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
183         // for accounts without code, i.e. `keccak256('')`
184         bytes32 codehash;
185         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
186         // solhint-disable-next-line no-inline-assembly
187         assembly { codehash := extcodehash(account) }
188         return (codehash != accountHash && codehash != 0x0);
189     }
190 
191     /**
192      * @dev Converts an `address` into `address payable`. Note that this is
193      * simply a type cast: the actual underlying value is not changed.
194      *
195      * _Available since v2.4.0._
196      */
197     function toPayable(address account) internal pure returns (address payable) {
198         return address(uint160(account));
199     }
200 
201     /**
202      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
203      * `recipient`, forwarding all available gas and reverting on errors.
204      *
205      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
206      * of certain opcodes, possibly making contracts go over the 2300 gas limit
207      * imposed by `transfer`, making them unable to receive funds via
208      * `transfer`. {sendValue} removes this limitation.
209      *
210      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
211      *
212      * IMPORTANT: because control is transferred to `recipient`, care must be
213      * taken to not create reentrancy vulnerabilities. Consider using
214      * {ReentrancyGuard} or the
215      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
216      *
217      * _Available since v2.4.0._
218      */
219     function sendValue(address payable recipient, uint256 amount) internal {
220         require(address(this).balance >= amount, "Address: insufficient balance");
221 
222         // solhint-disable-next-line avoid-call-value
223         (bool success, ) = recipient.call.value(amount)("");
224         require(success, "Address: unable to send value, recipient may have reverted");
225     }
226 }
227 
228 
229 interface IERC20 {
230     /**
231      * @dev Returns the amount of tokens in existence.
232      */
233     function totalSupply() external view returns (uint256);
234 
235     /**
236      * @dev Returns the amount of tokens owned by `account`.
237      */
238     function balanceOf(address account) external view returns (uint256);
239 
240     /**
241      * @dev Moves `amount` tokens from the caller's account to `recipient`.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transfer(address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Returns the remaining number of tokens that `spender` will be
251      * allowed to spend on behalf of `owner` through {transferFrom}. This is
252      * zero by default.
253      *
254      * This value changes when {approve} or {transferFrom} are called.
255      */
256     function allowance(address owner, address spender) external view returns (uint256);
257 
258     /**
259      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * IMPORTANT: Beware that changing an allowance with this method brings the risk
264      * that someone may use both the old and the new allowance by unfortunate
265      * transaction ordering. One possible solution to mitigate this race
266      * condition is to first reduce the spender's allowance to 0 and set the
267      * desired value afterwards:
268      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269      *
270      * Emits an {Approval} event.
271      */
272     function approve(address spender, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Moves `amount` tokens from `sender` to `recipient` using the
276      * allowance mechanism. `amount` is then deducted from the caller's
277      * allowance.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Emitted when `value` tokens are moved from one account (`from`) to
287      * another (`to`).
288      *
289      * Note that `value` may be zero.
290      */
291     event Transfer(address indexed from, address indexed to, uint256 value);
292 
293     /**
294      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
295      * a call to {approve}. `value` is the new allowance.
296      */
297     event Approval(address indexed owner, address indexed spender, uint256 value);
298 }
299 
300 
301 library SafeERC20 {
302     using SafeMath for uint256;
303     using Address for address;
304 
305     function safeTransfer(IERC20 token, address to, uint256 value) internal {
306         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
307     }
308 
309     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
310         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
311     }
312 
313     function safeApprove(IERC20 token, address spender, uint256 value) internal {
314         // safeApprove should only be called when setting an initial allowance,
315         // or when resetting it to zero. To increase and decrease it, use
316         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
317         // solhint-disable-next-line max-line-length
318         require((value == 0) || (token.allowance(address(this), spender) == 0),
319             "SafeERC20: approve from non-zero to non-zero allowance"
320         );
321         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
322     }
323 
324     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         uint256 newAllowance = token.allowance(address(this), spender).add(value);
326         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
327     }
328 
329     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
330         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
331         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
332     }
333 
334     /**
335      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
336      * on the return value: the return value is optional (but if data is returned, it must not be false).
337      * @param token The token targeted by the call.
338      * @param data The call data (encoded using abi.encode or one of its variants).
339      */
340     function callOptionalReturn(IERC20 token, bytes memory data) private {
341         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
342         // we're implementing it ourselves.
343 
344         // A Solidity high level call has three parts:
345         //  1. The target address is checked to verify it contains contract code
346         //  2. The call itself is made, and success asserted
347         //  3. The return value is decoded, which in turn checks the size of the returned data.
348         // solhint-disable-next-line max-line-length
349         require(address(token).isContract(), "SafeERC20: call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = address(token).call(data);
353         require(success, "SafeERC20: low-level call failed");
354 
355         if (returndata.length > 0) { // Return data is optional
356             // solhint-disable-next-line max-line-length
357             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
358         }
359     }
360 }
361 
362 contract HashedTimeLockContract {
363     using SafeERC20 for IERC20;
364 
365     mapping(bytes32 => LockContract) public contracts;
366 
367     //                   / - WITHDRAWN
368     // INVALID - ACTIVE |
369     //                   \ - EXPIRED - REFUNDED
370 
371     uint256 public constant INVALID = 0; // Uninitialized  swap -> can go to ACTIVE
372     uint256 public constant ACTIVE = 1; // Active swap -> can go to WITHDRAWN or EXPIRED
373     uint256 public constant REFUNDED = 2; // Swap is refunded -> final state.
374     uint256 public constant WITHDRAWN = 3; // Swap is withdrawn -> final state.
375     uint256 public constant EXPIRED = 4; // Swap is expired -> can go to REFUNDED
376 
377     struct LockContract {
378         uint256 inputAmount;
379         uint256 outputAmount;
380         uint256 expiration;
381         uint256 status;
382         bytes32 hashLock;
383         address tokenAddress;
384         address sender;
385         address receiver;
386         string outputNetwork;
387         string outputAddress;
388     }
389 
390     event Withdraw(
391         bytes32 id,
392         bytes32 secret,
393         bytes32 hashLock,
394         address indexed tokenAddress,
395         address indexed sender,
396         address indexed receiver
397     );
398 
399     event Refund(
400         bytes32 id,
401         bytes32 hashLock,
402         address indexed tokenAddress,
403         address indexed sender,
404         address indexed receiver
405     );
406 
407     event NewContract(
408         uint256 inputAmount,
409         uint256 outputAmount,
410         uint256 expiration,
411         bytes32 id,
412         bytes32 hashLock,
413         address indexed tokenAddress,
414         address indexed sender,
415         address indexed receiver,
416         string outputNetwork,
417         string outputAddress
418     );
419 
420     function newContract(
421         uint256 inputAmount,
422         uint256 outputAmount,
423         uint256 expiration,
424         bytes32 hashLock,
425         address tokenAddress,
426         address receiver,
427         string calldata outputNetwork,
428         string calldata outputAddress
429     ) external {
430         require(expiration > block.timestamp, "INVALID_TIME");
431 
432         require(inputAmount > 0, "INVALID_AMOUNT");
433 
434         IERC20(tokenAddress).safeTransferFrom(
435             msg.sender,
436             address(this),
437             inputAmount
438         );
439 
440         bytes32 id = sha256(
441             abi.encodePacked(
442                 msg.sender,
443                 receiver,
444                 inputAmount,
445                 hashLock,
446                 expiration,
447                 tokenAddress
448             )
449         );
450 
451         require(contracts[id].status == INVALID, "SWAP_EXISTS");
452 
453         contracts[id] = LockContract(
454             inputAmount,
455             outputAmount,
456             expiration,
457             ACTIVE,
458             hashLock,
459             tokenAddress,
460             msg.sender,
461             receiver,
462             outputNetwork,
463             outputAddress
464         );
465 
466         emit NewContract(
467             inputAmount,
468             outputAmount,
469             expiration,
470             id,
471             hashLock,
472             tokenAddress,
473             msg.sender,
474             receiver,
475             outputNetwork,
476             outputAddress
477         );
478     }
479 
480     function withdraw(bytes32 id, bytes32 secret, address tokenAddress)
481         external
482     {
483         LockContract storage c = contracts[id];
484 
485         require(c.tokenAddress == tokenAddress, "INVALID_TOKEN");
486 
487         require(c.status == ACTIVE, "SWAP_NOT_ACTIVE");
488 
489         require(c.expiration > block.timestamp, "INVALID_TIME");
490 
491         require(
492             c.hashLock == sha256(abi.encodePacked(secret)),
493             "INVALID_SECRET"
494         );
495 
496         c.status = WITHDRAWN;
497 
498         IERC20(tokenAddress).safeTransfer(c.receiver, c.inputAmount);
499 
500         emit Withdraw(
501             id,
502             secret,
503             c.hashLock,
504             tokenAddress,
505             c.sender,
506             c.receiver
507         );
508     }
509 
510     function refund(bytes32 id, address tokenAddress) external {
511         LockContract storage c = contracts[id];
512 
513         require(c.tokenAddress == tokenAddress, "INVALID_TOKEN");
514 
515         require(c.status == ACTIVE, "SWAP_NOT_ACTIVE");
516 
517         require(c.expiration <= block.timestamp, "INVALID_TIME");
518 
519         c.status = REFUNDED;
520 
521         IERC20(tokenAddress).safeTransfer(c.sender, c.inputAmount);
522 
523         emit Refund(id, c.hashLock, tokenAddress, c.sender, c.receiver);
524     }
525 
526     function getStatus(bytes32[] memory ids)
527         public
528         view
529         returns (uint256[] memory)
530     {
531         uint256[] memory result = new uint256[](ids.length);
532 
533         for (uint256 index = 0; index < ids.length; index++) {
534             result[index] = getSingleStatus(ids[index]);
535         }
536 
537         return result;
538     }
539 
540     function getSingleStatus(bytes32 id) public view returns (uint256 result) {
541         LockContract memory tempContract = contracts[id];
542 
543         if (
544             tempContract.status == ACTIVE &&
545             tempContract.expiration < block.timestamp
546         ) {
547             result = EXPIRED;
548         } else {
549             result = tempContract.status;
550         }
551     }
552 }