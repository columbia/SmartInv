1 pragma solidity 0.5.17;
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
160 interface IERC20 {
161     /**
162      * @dev Returns the amount of tokens in existence.
163      */
164     function totalSupply() external view returns (uint256);
165 
166     /**
167      * @dev Returns the amount of tokens owned by `account`.
168      */
169     function balanceOf(address account) external view returns (uint256);
170 
171     /**
172      * @dev Moves `amount` tokens from the caller's account to `recipient`.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transfer(address recipient, uint256 amount) external returns (bool);
179     function mint(address account, uint amount) external;
180     /**
181      * @dev Returns the remaining number of tokens that `spender` will be
182      * allowed to spend on behalf of `owner` through {transferFrom}. This is
183      * zero by default.
184      *
185      * This value changes when {approve} or {transferFrom} are called.
186      */
187     function allowance(address owner, address spender) external view returns (uint256);
188 
189     /**
190      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * IMPORTANT: Beware that changing an allowance with this method brings the risk
195      * that someone may use both the old and the new allowance by unfortunate
196      * transaction ordering. One possible solution to mitigate this race
197      * condition is to first reduce the spender's allowance to 0 and set the
198      * desired value afterwards:
199      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200      *
201      * Emits an {Approval} event.
202      */
203     function approve(address spender, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Moves `amount` tokens from `sender` to `recipient` using the
207      * allowance mechanism. `amount` is then deducted from the caller's
208      * allowance.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Emitted when `value` tokens are moved from one account (`from`) to
218      * another (`to`).
219      *
220      * Note that `value` may be zero.
221      */
222     event Transfer(address indexed from, address indexed to, uint256 value);
223 
224     /**
225      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
226      * a call to {approve}. `value` is the new allowance.
227      */
228     event Approval(address indexed owner, address indexed spender, uint256 value);
229 }
230 
231 /**
232  * @dev Collection of functions related to the address type
233  */
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * This test is non-exhaustive, and there may be false-negatives: during the
239      * execution of a contract's constructor, its address will be reported as
240      * not containing a contract.
241      *
242      * IMPORTANT: It is unsafe to assume that an address for which this
243      * function returns false is an externally-owned account (EOA) and not a
244      * contract.
245      */
246     function isContract(address account) internal view returns (bool) {
247         // This method relies in extcodesize, which returns 0 for contracts in
248         // construction, since the code is only stored at the end of the
249         // constructor execution.
250 
251         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
252         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
253         // for accounts without code, i.e. `keccak256('')`
254         bytes32 codehash;
255         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
256         // solhint-disable-next-line no-inline-assembly
257         assembly { codehash := extcodehash(account) }
258         return (codehash != 0x0 && codehash != accountHash);
259     }
260 
261     /**
262      * @dev Converts an `address` into `address payable`. Note that this is
263      * simply a type cast: the actual underlying value is not changed.
264      *
265      * _Available since v2.4.0._
266      */
267     function toPayable(address account) internal pure returns (address payable) {
268         return address(uint160(account));
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      *
287      * _Available since v2.4.0._
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         // solhint-disable-next-line avoid-call-value
293         (bool success, ) = recipient.call.value(amount)("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 }
297 
298 library SafeERC20 {
299     using SafeMath for uint256;
300     using Address for address;
301 
302     function safeTransfer(IERC20 token, address to, uint256 value) internal {
303         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
304     }
305 
306     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
307         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
308     }
309 
310     function safeApprove(IERC20 token, address spender, uint256 value) internal {
311         // safeApprove should only be called when setting an initial allowance,
312         // or when resetting it to zero. To increase and decrease it, use
313         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
314         // solhint-disable-next-line max-line-length
315         require((value == 0) || (token.allowance(address(this), spender) == 0),
316             "SafeERC20: approve from non-zero to non-zero allowance"
317         );
318         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
319     }
320 
321     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
322         uint256 newAllowance = token.allowance(address(this), spender).add(value);
323         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
324     }
325 
326     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
327         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
328         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
329     }
330 
331     /**
332      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
333      * on the return value: the return value is optional (but if data is returned, it must not be false).
334      * @param token The token targeted by the call.
335      * @param data The call data (encoded using abi.encode or one of its variants).
336      */
337     function callOptionalReturn(IERC20 token, bytes memory data) private {
338         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
339         // we're implementing it ourselves.
340 
341         // A Solidity high level call has three parts:
342         //  1. The target address is checked to verify it contains contract code
343         //  2. The call itself is made, and success asserted
344         //  3. The return value is decoded, which in turn checks the size of the returned data.
345         // solhint-disable-next-line max-line-length
346         require(address(token).isContract(), "SafeERC20: call to non-contract");
347 
348         // solhint-disable-next-line avoid-low-level-calls
349         (bool success, bytes memory returndata) = address(token).call(data);
350         require(success, "SafeERC20: low-level call failed");
351 
352         if (returndata.length > 0) { // Return data is optional
353             // solhint-disable-next-line max-line-length
354             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
355         }
356     }
357 }
358 
359 interface DONDIAirdrop {
360     function airdrop(uint256 value) external;
361     function airdropAll() external;
362     function getRemainAirdrop(address pool) external view returns (uint256);
363 }
364 
365 interface SmartContractDondi {
366     function getOwner() external view returns(address);
367     function usersActiveX3Levels(address userAddress, uint8 level) external view returns(bool);
368     function usersActiveX6Levels(address userAddress, uint8 level) external view returns(bool);
369 }
370 
371 contract DONDISlotHarvester {
372     using SafeMath for uint256;
373     using SafeERC20 for IERC20;
374 
375     address public gov;
376     DONDIAirdrop public airdropAddress = DONDIAirdrop(0xbd1A31ac12Cd16bacE58519c91a4562069d5A6A6);
377     SmartContractDondi public smartDondiAddress;
378     address public wheelAddress;
379 
380     mapping(address => uint256) public referredAmount;
381     mapping(address => uint256) public registerTime;
382     mapping(address => uint256) public fortuneAmount;
383     IERC20 public dondi = IERC20(0x45Ed25A237B6AB95cE69aF7555CF8D7A2FfEE67c);
384 
385     constructor() public {
386         gov = msg.sender;
387     }
388 
389     modifier onlyGov() {
390         require(msg.sender == gov);
391         _;
392     }
393 
394     function transferOwnership(address owner)
395         external
396         onlyGov
397     {
398         gov = owner;
399     }
400 
401     function setSmartDondi(address newAddress) external onlyGov {
402         smartDondiAddress = SmartContractDondi(newAddress);
403         registerTime[smartDondiAddress.getOwner()] = now;
404     }
405 
406     function setWheelAddress(address newAddress) external onlyGov {
407         wheelAddress = newAddress;
408     }
409 
410     function harvest() external {
411         require(registerTime[msg.sender] > 0, "User doesn't exist!");
412         uint256 allHours = uint256(now).div(3600).sub(registerTime[msg.sender].div(3600));
413         uint8 i;
414         uint8 sum = 2;
415         for (i = 2; i <= 12; i++) {
416             if (smartDondiAddress.usersActiveX3Levels(msg.sender, i) == true) {
417                 sum++;
418             }
419         }
420         for (i = 2; i <= 12; i++) {
421             if (smartDondiAddress.usersActiveX6Levels(msg.sender, i) == true) {
422                 sum++;
423             }
424         }
425 
426         uint256 harvestedAmount = fortuneAmount[msg.sender].add(referredAmount[msg.sender]).add(allHours.mul(sum)).mul(10 ** 18);
427         if (harvestedAmount > 0) {
428             airdropAddress.airdrop(harvestedAmount);
429             registerTime[msg.sender] = now;
430             fortuneAmount[msg.sender] = 0;
431             referredAmount[msg.sender] = 0;
432             dondi.safeTransfer(msg.sender, harvestedAmount);
433         }
434     }
435 
436     function register(address user, address referrer) external {
437         require(msg.sender == address(smartDondiAddress), "not register!");
438         referredAmount[referrer] = referredAmount[referrer].add(10);
439         registerTime[user] = now;
440     }
441 
442     function setFortune(address user, uint256 amount) external {
443         require(msg.sender == wheelAddress, "not wheel!");
444         fortuneAmount[user] = fortuneAmount[user].add(amount);
445     }
446 }