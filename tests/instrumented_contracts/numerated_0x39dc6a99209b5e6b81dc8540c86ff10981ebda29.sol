1 pragma solidity 0.5.11;
2 
3 /// npm package/version - @openzeppelin/contracts-ethereum-package: 2.5.0
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
28         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
29         // for accounts without code, i.e. `keccak256('')`
30         bytes32 codehash;
31         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { codehash := extcodehash(account) }
34         return (codehash != accountHash && codehash != 0x0);
35     }
36 
37     /**
38      * @dev Converts an `address` into `address payable`. Note that this is
39      * simply a type cast: the actual underlying value is not changed.
40      *
41      * _Available since v2.4.0._
42      */
43     function toPayable(address account) internal pure returns (address payable) {
44         return address(uint160(account));
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      *
63      * _Available since v2.4.0._
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         // solhint-disable-next-line avoid-call-value
69         (bool success, ) = recipient.call.value(amount)("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 }
73 
74 
75 pragma solidity 0.5.11;
76 
77 /// npm package/version - @openzeppelin/contracts-ethereum-package: 2.5.0
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      * - Subtraction cannot overflow.
130      *
131      * _Available since v2.4.0._
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      *
189      * _Available since v2.4.0._
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         // Solidity only automatically asserts when dividing by 0
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 
235 // SPDX-License-Identifier: MIT
236 
237 pragma solidity 0.5.11;
238 
239 /// @notice  Interface of the official Deposit contract from the ETH
240 ///          Foundation.
241 interface IDeposit {
242 
243     /// @notice Submit a Phase 0 DepositData object.
244     ///
245     /// @param pubkey - A BLS12-381 public key.
246     /// @param withdrawal_credentials - Commitment to a public key for withdrawals.
247     /// @param signature - A BLS12-381 signature.
248     /// @param deposit_data_root - The SHA-256 hash of the SSZ-encoded DepositData object.
249     ///                            Used as a protection against malformed input.
250     function deposit(
251         bytes calldata pubkey,
252         bytes calldata withdrawal_credentials,
253         bytes calldata signature,
254         bytes32 deposit_data_root
255     ) external payable;
256 
257 }
258 
259 
260 // SPDX-License-Identifier: MIT
261 
262 pragma solidity 0.5.11;
263 pragma experimental ABIEncoderV2;
264 
265 /// @notice  Batch ETH2 deposits, uses the official Deposit contract from the ETH
266 ///          Foundation for each atomic deposit. This contract acts as a for loop.
267 ///          Each deposit size will be an optimal 32 ETH.
268 ///
269 /// @dev     The batch size has an upper bound due to the block gas limit. Each atomic
270 ///          deposit costs ~62,000 gas. The current block gas-limit is ~12,400,000 gas.
271 ///
272 /// Author:  Staked Securely, Inc. (https://staked.us/)
273 contract BatchDeposit {
274     using Address for address payable;
275     using SafeMath for uint256;
276 
277     /*************** STORAGE VARIABLE DECLARATIONS **************/
278 
279     uint256 public constant DEPOSIT_AMOUNT = 32 ether;
280     // currently points at the Mainnet Deposit Contract
281     address public constant DEPOSIT_CONTRACT_ADDRESS = 0x00000000219ab540356cBB839Cbe05303d7705Fa;
282     IDeposit private constant DEPOSIT_CONTRACT = IDeposit(DEPOSIT_CONTRACT_ADDRESS);
283 
284     /*************** EVENT DECLARATIONS **************/
285 
286     /// @notice  Signals a refund of sent-in Ether that was extra and not required.
287     ///
288     /// @dev     The refund is sent to the msg.sender.
289     ///
290     /// @param  to - The ETH address receiving the ETH.
291     /// @param  amount - The amount of ETH being refunded.
292     event LogSendDepositLeftover(address to, uint256 amount);
293 
294     /////////////////////// FUNCTION DECLARATIONS BEGIN ///////////////////////
295 
296     /********************* PUBLIC FUNCTIONS **********************/
297 
298     /// @notice  Empty constructor.
299     constructor() public {}
300 
301     /// @notice  Fallback function.
302     ///
303     /// @dev     Used to address parties trying to send in Ether with a helpful
304     ///          error message.
305     function() external payable {
306         revert("#BatchDeposit fallback(): Use the `batchDeposit(...)` function to send Ether to this contract.");
307     }
308 
309     /// @notice Submit index-matching arrays that form Phase 0 DepositData objects.
310     ///         Will create a deposit transaction per index of the arrays submitted.
311     ///
312     /// @param pubkeys - An array of BLS12-381 public keys.
313     /// @param withdrawal_credentials - An array of public keys for withdrawals.
314     /// @param signatures - An array of BLS12-381 signatures.
315     /// @param deposit_data_roots - An array of the SHA-256 hash of the SSZ-encoded DepositData object.
316     function batchDeposit(
317         bytes[] calldata pubkeys,
318         bytes[] calldata withdrawal_credentials,
319         bytes[] calldata signatures,
320         bytes32[] calldata deposit_data_roots
321     ) external payable {
322         require(
323             pubkeys.length == withdrawal_credentials.length &&
324             pubkeys.length == signatures.length &&
325             pubkeys.length == deposit_data_roots.length,
326             "#BatchDeposit batchDeposit(): All parameter array's must have the same length."
327         );
328         require(
329             pubkeys.length > 0,
330             "#BatchDeposit batchDeposit(): All parameter array's must have a length greater than zero."
331         );
332         require(
333             msg.value >= DEPOSIT_AMOUNT.mul(pubkeys.length),
334             "#BatchDeposit batchDeposit(): Ether deposited needs to be at least: 32 * (parameter `pubkeys[]` length)."
335         );
336         uint256 deposited = 0;
337 
338         // Loop through DepositData arrays submitting deposits
339         for (uint256 i = 0; i < pubkeys.length; i++) {
340             DEPOSIT_CONTRACT.deposit.value(DEPOSIT_AMOUNT)(
341                 pubkeys[i],
342                 withdrawal_credentials[i],
343                 signatures[i],
344                 deposit_data_roots[i]
345             );
346             deposited = deposited.add(DEPOSIT_AMOUNT);
347         }
348         assert(deposited == DEPOSIT_AMOUNT.mul(pubkeys.length));
349         uint256 ethToReturn = msg.value.sub(deposited);
350         if (ethToReturn > 0) {
351 
352           // Emit `LogSendDepositLeftover` log
353           emit LogSendDepositLeftover(msg.sender, ethToReturn);
354 
355           // This function doesn't guard against re-entrancy, and we're calling an
356           // untrusted address, but in this situation there is no state, etc. to
357           // take advantage of, so re-entrancy guard is unneccesary gas cost.
358           // This function uses call.value(), and handles return values/failures by
359           // reverting the transaction.
360           (msg.sender).sendValue(ethToReturn);
361         }
362     }
363 }