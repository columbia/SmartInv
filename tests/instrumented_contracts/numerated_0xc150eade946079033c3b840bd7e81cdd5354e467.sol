1 /**
2 
3 Link marines the time has finally come. Presenting YFLink governance token:
4 
5 #     # ####### #
6  #   #  #       #       # #    # #    #     #  ####
7   # #   #       #       # ##   # #   #      # #    #
8    #    #####   #       # # #  # ####       # #    #
9    #    #       #       # #  # # #  #   ### # #    #
10    #    #       #       # #   ## #   #  ### # #    #
11    #    #       ####### # #    # #    # ### #  ####
12 
13 
14 ######                                            #
15 #     # #  ####  #####  #        ##   #   #      # #   #####    ##   #####  #####   ##   #####  # #      # ##### #   #
16 #     # # #      #    # #       #  #   # #      #   #  #    #  #  #  #    #   #    #  #  #    # # #      #   #    # #
17 #     # #  ####  #    # #      #    #   #      #     # #    # #    # #    #   #   #    # #####  # #      #   #     #
18 #     # #      # #####  #      ######   #      ####### #    # ###### #####    #   ###### #    # # #      #   #     #
19 #     # # #    # #      #      #    #   #      #     # #    # #    # #        #   #    # #    # # #      #   #     #
20 ######  #  ####  #      ###### #    #   #      #     # #####  #    # #        #   #    # #####  # ###### #   #     #
21 
22 
23 This code was forked from Andre Cronje's YFI and modified.
24 It has not been audited and may contain bugs - be warned.
25 Similarly as YFI, it has zero initial supply and has zero financial value.
26 There is no sale of it either, it can only be minted by staking Link.
27 
28 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 SOFTWARE.
35 
36 */
37 
38 // File: @openzeppelin/contracts/math/SafeMath.sol
39 
40 pragma solidity ^0.5.0;
41 
42 /**
43  * @dev Wrappers over Solidity's arithmetic operations with added overflow
44  * checks.
45  *
46  * Arithmetic operations in Solidity wrap on overflow. This can easily result
47  * in bugs, because programmers usually assume that an overflow raises an
48  * error, which is the standard behavior in high level programming languages.
49  * `SafeMath` restores this intuition by reverting the transaction when an
50  * operation overflows.
51  *
52  * Using this library instead of the unchecked operations eliminates an entire
53  * class of bugs, so it's recommended to use it always.
54  */
55 library SafeMath {
56     /**
57      * @dev Returns the addition of two unsigned integers, reverting on
58      * overflow.
59      *
60      * Counterpart to Solidity's `+` operator.
61      *
62      * Requirements:
63      * - Addition cannot overflow.
64      */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return sub(a, b, "SafeMath: subtraction overflow");
83     }
84 
85     /**
86      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
87      * overflow (when the result is negative).
88      *
89      * Counterpart to Solidity's `-` operator.
90      *
91      * Requirements:
92      * - Subtraction cannot overflow.
93      *
94      * _Available since v2.4.0._
95      */
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the multiplication of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `*` operator.
108      *
109      * Requirements:
110      * - Multiplication cannot overflow.
111      */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers. Reverts on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator. Note: this function uses a
131      * `revert` opcode (which leaves remaining gas untouched) while Solidity
132      * uses an invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return div(a, b, "SafeMath: division by zero");
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         // Solidity only automatically asserts when dividing by 0
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return mod(a, b, "SafeMath: modulo by zero");
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts with custom message when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      *
189      * _Available since v2.4.0._
190      */
191     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b != 0, errorMessage);
193         return a % b;
194     }
195 }
196 
197 
198 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
199 
200 pragma solidity ^0.5.0;
201 
202 /**
203  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
204  * the optional functions; to access them see {ERC20Detailed}.
205  */
206 interface IERC20 {
207     /**
208      * @dev Returns the amount of tokens in existence.
209      */
210     function totalSupply() external view returns (uint256);
211 
212     /**
213      * @dev Returns the amount of tokens owned by `account`.
214      */
215     function balanceOf(address account) external view returns (uint256);
216 
217     /**
218      * @dev Moves `amount` tokens from the caller's account to `recipient`.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transfer(address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Returns the remaining number of tokens that `spender` will be
228      * allowed to spend on behalf of `owner` through {transferFrom}. This is
229      * zero by default.
230      *
231      * This value changes when {approve} or {transferFrom} are called.
232      */
233     function allowance(address owner, address spender) external view returns (uint256);
234 
235     /**
236      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * IMPORTANT: Beware that changing an allowance with this method brings the risk
241      * that someone may use both the old and the new allowance by unfortunate
242      * transaction ordering. One possible solution to mitigate this race
243      * condition is to first reduce the spender's allowance to 0 and set the
244      * desired value afterwards:
245      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246      *
247      * Emits an {Approval} event.
248      */
249     function approve(address spender, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Moves `amount` tokens from `sender` to `recipient` using the
253      * allowance mechanism. `amount` is then deducted from the caller's
254      * allowance.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * Emits a {Transfer} event.
259      */
260     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
261 
262     /**
263      * @dev Emitted when `value` tokens are moved from one account (`from`) to
264      * another (`to`).
265      *
266      * Note that `value` may be zero.
267      */
268     event Transfer(address indexed from, address indexed to, uint256 value);
269 
270     /**
271      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
272      * a call to {approve}. `value` is the new allowance.
273      */
274     event Approval(address indexed owner, address indexed spender, uint256 value);
275 }
276 
277 // File: @openzeppelin/contracts/utils/Address.sol
278 
279 pragma solidity ^0.5.5;
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * This test is non-exhaustive, and there may be false-negatives: during the
289      * execution of a contract's constructor, its address will be reported as
290      * not containing a contract.
291      *
292      * IMPORTANT: It is unsafe to assume that an address for which this
293      * function returns false is an externally-owned account (EOA) and not a
294      * contract.
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies in extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
302         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
303         // for accounts without code, i.e. `keccak256('')`
304         bytes32 codehash;
305         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
306         // solhint-disable-next-line no-inline-assembly
307         assembly { codehash := extcodehash(account) }
308         return (codehash != 0x0 && codehash != accountHash);
309     }
310 
311     /**
312      * @dev Converts an `address` into `address payable`. Note that this is
313      * simply a type cast: the actual underlying value is not changed.
314      *
315      * _Available since v2.4.0._
316      */
317     function toPayable(address account) internal pure returns (address payable) {
318         return address(uint160(account));
319     }
320 
321     /**
322      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
323      * `recipient`, forwarding all available gas and reverting on errors.
324      *
325      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
326      * of certain opcodes, possibly making contracts go over the 2300 gas limit
327      * imposed by `transfer`, making them unable to receive funds via
328      * `transfer`. {sendValue} removes this limitation.
329      *
330      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
331      *
332      * IMPORTANT: because control is transferred to `recipient`, care must be
333      * taken to not create reentrancy vulnerabilities. Consider using
334      * {ReentrancyGuard} or the
335      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
336      *
337      * _Available since v2.4.0._
338      */
339     function sendValue(address payable recipient, uint256 amount) internal {
340         require(address(this).balance >= amount, "Address: insufficient balance");
341 
342         // solhint-disable-next-line avoid-call-value
343         (bool success, ) = recipient.call.value(amount)("");
344         require(success, "Address: unable to send value, recipient may have reverted");
345     }
346 }
347 
348 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
349 
350 pragma solidity ^0.5.0;
351 
352 
353 
354 
355 /**
356  * @title SafeERC20
357  * @dev Wrappers around ERC20 operations that throw on failure (when the token
358  * contract returns false). Tokens that return no value (and instead revert or
359  * throw on failure) are also supported, non-reverting calls are assumed to be
360  * successful.
361  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
362  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
363  */
364 library SafeERC20 {
365     using SafeMath for uint256;
366     using Address for address;
367 
368     function safeTransfer(IERC20 token, address to, uint256 value) internal {
369         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
370     }
371 
372     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
373         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
374     }
375 
376     function safeApprove(IERC20 token, address spender, uint256 value) internal {
377         // safeApprove should only be called when setting an initial allowance,
378         // or when resetting it to zero. To increase and decrease it, use
379         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
380         // solhint-disable-next-line max-line-length
381         require((value == 0) || (token.allowance(address(this), spender) == 0),
382             "SafeERC20: approve from non-zero to non-zero allowance"
383         );
384         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
385     }
386 
387     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
388         uint256 newAllowance = token.allowance(address(this), spender).add(value);
389         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
390     }
391 
392     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
393         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
394         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
395     }
396 
397     /**
398      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
399      * on the return value: the return value is optional (but if data is returned, it must not be false).
400      * @param token The token targeted by the call.
401      * @param data The call data (encoded using abi.encode or one of its variants).
402      */
403     function callOptionalReturn(IERC20 token, bytes memory data) private {
404         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
405         // we're implementing it ourselves.
406 
407         // A Solidity high level call has three parts:
408         //  1. The target address is checked to verify it contains contract code
409         //  2. The call itself is made, and success asserted
410         //  3. The return value is decoded, which in turn checks the size of the returned data.
411         // solhint-disable-next-line max-line-length
412         require(address(token).isContract(), "SafeERC20: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = address(token).call(data);
416         require(success, "SafeERC20: low-level call failed");
417 
418         if (returndata.length > 0) { // Return data is optional
419             // solhint-disable-next-line max-line-length
420             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
421         }
422     }
423 }
424 
425 pragma solidity ^0.5.0;
426 
427 contract LPTokenWrapper {
428     using SafeMath for uint256;
429     using SafeERC20 for IERC20;
430 
431     IERC20 public yflink = IERC20(0x28cb7e841ee97947a86B06fA4090C8451f64c0be);
432 
433     uint256 private _totalSupply;
434     mapping(address => uint256) private _balances;
435 
436     function totalSupply() public view returns (uint256) {
437         return _totalSupply;
438     }
439 
440     function balanceOf(address account) public view returns (uint256) {
441         return _balances[account];
442     }
443 
444     function stake(uint256 amount) public {
445         _totalSupply = _totalSupply.add(amount);
446         _balances[msg.sender] = _balances[msg.sender].add(amount);
447         yflink.safeTransferFrom(msg.sender, address(this), amount);
448     }
449 
450     function withdraw(uint256 amount) public {
451         _totalSupply = _totalSupply.sub(amount);
452         _balances[msg.sender] = _balances[msg.sender].sub(amount);
453         yflink.safeTransfer(msg.sender, amount);
454     }
455 }
456 
457 contract YFLinkGov is LPTokenWrapper {
458 
459     /* Modifications for proposals */
460 
461     mapping(address => uint) public voteLock; // period that your stake it locked to keep it for voting
462 
463     struct Proposal {
464         uint id;
465         address proposer;
466         mapping(address => uint) forVotes;
467         mapping(address => uint) againstVotes;
468         uint totalForVotes;
469         uint totalAgainstVotes;
470         uint start; // block start;
471         uint end; // start + period
472         string url; //url to proposal or img
473     }
474 
475     mapping (uint => Proposal) public proposals;
476     uint public proposalCount;
477     uint public period = 17280; // voting period in blocks ~ 17280 3 days for 15s/block
478     uint public lock = 17280;
479     uint public minimum = 1e17; //0.1 YFLink
480 
481     function propose(string memory _url) public {
482         require(balanceOf(msg.sender) > minimum, "<minimum");
483         proposals[proposalCount++] = Proposal({
484             id: proposalCount,
485             proposer: msg.sender,
486             totalForVotes: 0,
487             totalAgainstVotes: 0,
488             start: block.number,
489             end: period.add(block.number),
490             url: _url
491             });
492 
493         voteLock[msg.sender] = lock.add(block.number);
494     }
495 
496     function voteFor(uint id) public {
497         require(proposals[id].start < block.number , "<start");
498         require(proposals[id].end > block.number , ">end");
499         uint votes = balanceOf(msg.sender).sub(proposals[id].forVotes[msg.sender]);
500         proposals[id].totalForVotes = proposals[id].totalForVotes.add(votes);
501         proposals[id].forVotes[msg.sender] = balanceOf(msg.sender);
502 
503         voteLock[msg.sender] = lock.add(block.number);
504     }
505 
506     function voteAgainst(uint id) public {
507         require(proposals[id].start < block.number , "<start");
508         require(proposals[id].end > block.number , ">end");
509         uint votes = balanceOf(msg.sender).sub(proposals[id].againstVotes[msg.sender]);
510         proposals[id].totalAgainstVotes = proposals[id].totalAgainstVotes.add(votes);
511         proposals[id].againstVotes[msg.sender] = balanceOf(msg.sender);
512 
513         voteLock[msg.sender] = lock.add(block.number);
514     }
515 
516     function stake(uint256 amount) public {
517         require(amount > 0, "Cannot stake 0");
518         super.stake(amount);
519     }
520 
521     function withdraw(uint256 amount) public {
522         require(amount > 0, "Cannot withdraw 0");
523         require(voteLock[msg.sender] < block.number,"tokens locked");
524         super.withdraw(amount);
525     }
526 }