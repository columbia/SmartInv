1 pragma solidity ^0.5.17;
2 
3 // File: @openzeppelin/contracts/math/SafeMath.sol
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
160 
161 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
162 
163 /**
164  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
165  * the optional functions; to access them see {ERC20Detailed}.
166  */
167 interface IERC20 {
168     /**
169      * @dev Returns the amount of tokens in existence.
170      */
171     function totalSupply() external view returns (uint256);
172 
173     /**
174      * @dev Returns the amount of tokens owned by `account`.
175      */
176     function balanceOf(address account) external view returns (uint256);
177 
178     /**
179      * @dev Moves `amount` tokens from the caller's account to `recipient`.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transfer(address recipient, uint256 amount) external returns (bool);
186     function mint(address account, uint amount) external;
187     /**
188      * @dev Returns the remaining number of tokens that `spender` will be
189      * allowed to spend on behalf of `owner` through {transferFrom}. This is
190      * zero by default.
191      *
192      * This value changes when {approve} or {transferFrom} are called.
193      */
194     function allowance(address owner, address spender) external view returns (uint256);
195 
196     /**
197      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * IMPORTANT: Beware that changing an allowance with this method brings the risk
202      * that someone may use both the old and the new allowance by unfortunate
203      * transaction ordering. One possible solution to mitigate this race
204      * condition is to first reduce the spender's allowance to 0 and set the
205      * desired value afterwards:
206      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207      *
208      * Emits an {Approval} event.
209      */
210     function approve(address spender, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Moves `amount` tokens from `sender` to `recipient` using the
214      * allowance mechanism. `amount` is then deducted from the caller's
215      * allowance.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Emitted when `value` tokens are moved from one account (`from`) to
225      * another (`to`).
226      *
227      * Note that `value` may be zero.
228      */
229     event Transfer(address indexed from, address indexed to, uint256 value);
230 
231     /**
232      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
233      * a call to {approve}. `value` is the new allowance.
234      */
235     event Approval(address indexed owner, address indexed spender, uint256 value);
236 }
237 
238 // File: @openzeppelin/contracts/utils/Address.sol
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * This test is non-exhaustive, and there may be false-negatives: during the
248      * execution of a contract's constructor, its address will be reported as
249      * not containing a contract.
250      *
251      * IMPORTANT: It is unsafe to assume that an address for which this
252      * function returns false is an externally-owned account (EOA) and not a
253      * contract.
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies in extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
261         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
262         // for accounts without code, i.e. `keccak256('')`
263         bytes32 codehash;
264         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
265         // solhint-disable-next-line no-inline-assembly
266         assembly { codehash := extcodehash(account) }
267         return (codehash != 0x0 && codehash != accountHash);
268     }
269 
270     /**
271      * @dev Converts an `address` into `address payable`. Note that this is
272      * simply a type cast: the actual underlying value is not changed.
273      *
274      * _Available since v2.4.0._
275      */
276     function toPayable(address account) internal pure returns (address payable) {
277         return address(uint160(account));
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      *
296      * _Available since v2.4.0._
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         // solhint-disable-next-line avoid-call-value
302         (bool success, ) = recipient.call.value(amount)("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 }
306 
307 
308 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
309 
310 /**
311  * @title SafeERC20
312  * @dev Wrappers around ERC20 operations that throw on failure (when the token
313  * contract returns false). Tokens that return no value (and instead revert or
314  * throw on failure) are also supported, non-reverting calls are assumed to be
315  * successful.
316  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
317  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
318  */
319 library SafeERC20 {
320     using SafeMath for uint256;
321     using Address for address;
322 
323     function safeTransfer(IERC20 token, address to, uint256 value) internal {
324         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
325     }
326 
327     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
328         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
329     }
330 
331     function safeApprove(IERC20 token, address spender, uint256 value) internal {
332         // safeApprove should only be called when setting an initial allowance,
333         // or when resetting it to zero. To increase and decrease it, use
334         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
335         // solhint-disable-next-line max-line-length
336         require((value == 0) || (token.allowance(address(this), spender) == 0),
337             "SafeERC20: approve from non-zero to non-zero allowance"
338         );
339         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
340     }
341 
342     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
343         uint256 newAllowance = token.allowance(address(this), spender).add(value);
344         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
345     }
346 
347     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
348         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
349         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
350     }
351 
352     /**
353      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
354      * on the return value: the return value is optional (but if data is returned, it must not be false).
355      * @param token The token targeted by the call.
356      * @param data The call data (encoded using abi.encode or one of its variants).
357      */
358     function callOptionalReturn(IERC20 token, bytes memory data) private {
359         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
360         // we're implementing it ourselves.
361 
362         // A Solidity high level call has three parts:
363         //  1. The target address is checked to verify it contains contract code
364         //  2. The call itself is made, and success asserted
365         //  3. The return value is decoded, which in turn checks the size of the returned data.
366         // solhint-disable-next-line max-line-length
367         require(address(token).isContract(), "SafeERC20: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = address(token).call(data);
371         require(success, "SafeERC20: low-level call failed");
372 
373         if (returndata.length > 0) { // Return data is optional
374             // solhint-disable-next-line max-line-length
375             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
376         }
377     }
378 }
379 
380 interface DONDIAirdrop {
381     function airdrop(uint256 value) external;
382     function airdropAll() external;
383     function getRemainAirdrop(address pool) external view returns (uint256);
384 }
385 
386 interface DONDISlotHarvester {
387     function setFortune(address user, uint256 amount) external;
388 }
389 
390 contract DONDIRoulette {
391     using SafeMath for uint256;
392     using SafeERC20 for IERC20;
393     DONDISlotHarvester harvester = DONDISlotHarvester(0x7BF87882611c9A0FE92FdAAfFC9Ed0d241305EEe);
394     
395     struct MyAction {
396         uint256 rand;
397         uint256 lastTimestamp;	
398     }
399     
400     mapping(address => uint8) public spinCount;
401     mapping(address => MyAction) public result;
402     mapping(address => uint256) lastDay;
403     constructor() public {
404     }
405 
406     function randModulus(uint256 randString) external payable {
407 
408         uint256 day = now / 86400;
409         address payable fundaddress = address(0x1912780CA1056fB9B5f3B4C241881f69Ed225861);
410         uint256 rand = uint256(keccak256(abi.encodePacked(
411             randString,
412             now,
413             block.difficulty,
414             msg.sender)
415         )) % 1000;
416         
417         if (lastDay[msg.sender] != day) {
418             lastDay[msg.sender] = day;
419             
420             spinCount[msg.sender] = 0;
421             uint256 spinCost = uint256(15) * 10 ** 18 / 1000;
422             require(msg.value == spinCost, "Wrong cost");
423             result[msg.sender].lastTimestamp = now;
424             uint256 airdropAmount;
425             if (rand < 20) {
426                 // free spin
427                 if (!msg.sender.send(spinCost)) {
428                     msg.sender.transfer(spinCost);
429                 }
430                 airdropAmount = 0;
431             } else {
432                 if (!fundaddress.send(spinCost)) {
433                     fundaddress.transfer(address(this).balance);
434                 }
435                 if (rand < 50) {
436                     // no dondi
437                     airdropAmount = 1;
438                     spinCount[msg.sender] = 1;
439                 } else if (rand < 550) {
440                     // 5 dondi
441                     airdropAmount = 5;
442                     spinCount[msg.sender] = 1;
443                 } else if (rand < 800) {
444                     // 10 dondi
445                     airdropAmount = 10;
446                     spinCount[msg.sender] = 1;
447                 } else if (rand < 950) {
448                     // 15 dondi
449                     airdropAmount = 15;
450                     spinCount[msg.sender] = 1;
451                 } else if (rand < 980) {
452                     // 25 dondi
453                     airdropAmount = 25;
454                     spinCount[msg.sender] = 1;
455                 } else if (rand < 998) {
456                     // 100 dondi
457                     airdropAmount = 100;
458                     spinCount[msg.sender] = 1;
459                 } else {
460                     // 1000 dondi
461                     airdropAmount = 1000;
462                     spinCount[msg.sender] = 1;
463                 }
464             }
465             result[msg.sender].rand = airdropAmount;
466             if (airdropAmount == 1) {
467                 airdropAmount = 0;
468             }
469             if (airdropAmount > 0) {
470                 harvester.setFortune(msg.sender, airdropAmount);
471             }
472         } else {
473             require(spinCount[msg.sender] < 5, "you already use all spin count for today");
474             
475             uint256 spinCost = uint256(15) * uint256(2) ** spinCount[msg.sender] * 10 ** 18 / 1000;
476             require(msg.value == spinCost, "Wrong cost");
477 
478             result[msg.sender].lastTimestamp = now;
479             uint256 airdropAmount;
480             if (rand < 20) {
481                 // free spin
482                 if (!msg.sender.send(spinCost)) {
483                     msg.sender.transfer(spinCost);
484                 }
485                 airdropAmount = 0;
486             } else {
487                 if (!fundaddress.send(spinCost)) {
488                     fundaddress.transfer(address(this).balance);
489                 }
490                 if (rand < 50) {
491                     // no dondi
492                     airdropAmount = 1;
493                     spinCount[msg.sender]++;
494                 } else if (rand < 550) {
495                     // 5 dondi
496                     airdropAmount = 5;
497                     spinCount[msg.sender]++;
498                 } else if (rand < 800) {
499                     // 10 dondi
500                     airdropAmount = 10;
501                     spinCount[msg.sender]++;
502                 } else if (rand < 950) {
503                     // 15 dondi
504                     airdropAmount = 15;
505                     spinCount[msg.sender]++;
506                 } else if (rand < 980) {
507                     // 25 dondi
508                     airdropAmount = 25;
509                     spinCount[msg.sender]++;
510                 } else if (rand < 998) {
511                     // 100 dondi
512                     airdropAmount = 100;
513                     spinCount[msg.sender]++;
514                 } else {
515                     // 1000 dondi
516                     airdropAmount = 1000;
517                     spinCount[msg.sender]++;
518                 }
519             }
520             result[msg.sender].rand = airdropAmount;
521             if (airdropAmount == 1) {
522                 airdropAmount = 0;
523             }
524             if (airdropAmount > 0) {
525                 harvester.setFortune(msg.sender, airdropAmount);
526             }
527         }
528     }
529 }