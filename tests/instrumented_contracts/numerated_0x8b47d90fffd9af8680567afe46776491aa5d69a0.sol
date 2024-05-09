1 // SPDX-License-Identifier: MIT
2 
3 /*
4  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄                           
5 ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌                          
6 ▐░▌       ▐░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌                          
7 ▐░▌       ▐░▌     ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌                          
8 ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌                          
9 ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌                          
10 ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌                          
11 ▐░▌       ▐░▌     ▐░▌     ▐░▌          ▐░▌          ▐░▌       ▐░▌                          
12 ▐░▌       ▐░▌ ▄▄▄▄█░█▄▄▄▄ ▐░▌          ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌                          
13 ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌          ▐░▌          ▐░░░░░░░░░░░▌                          
14  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀            ▀            ▀▀▀▀▀▀▀▀▀▀▀                           
15                                                                                            
16  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
17 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
18 ▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ 
19 ▐░▌               ▐░▌     ▐░▌▐░▌    ▐░▌▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌          ▐░▌          
20 ▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▌   ▐░▌▐░▌          ▐░█▄▄▄▄▄▄▄▄▄ 
21 ▐░░░░░░░░░░░▌     ▐░▌     ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌▐░▌          ▐░░░░░░░░░░░▌
22 ▐░█▀▀▀▀▀▀▀▀▀      ▐░▌     ▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌   ▐░▌ ▐░▌▐░▌          ▐░█▀▀▀▀▀▀▀▀▀ 
23 ▐░▌               ▐░▌     ▐░▌    ▐░▌▐░▌▐░▌       ▐░▌▐░▌    ▐░▌▐░▌▐░▌          ▐░▌          
24 ▐░▌           ▄▄▄▄█░█▄▄▄▄ ▐░▌     ▐░▐░▌▐░▌       ▐░▌▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ 
25 ▐░▌          ▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░▌       ▐░▌▐░▌      ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
26  ▀            ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀         ▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ 
27 */
28 
29 // File: @openzeppelin/contracts/GSN/Context.sol
30 
31 
32 pragma solidity ^0.6.0;
33 
34 /*
35  * @dev Provides information about the current execution context, including the
36  * sender of the transaction and its data. While these are generally available
37  * via msg.sender and msg.data, they should not be accessed in such a direct
38  * manner, since when dealing with GSN meta-transactions the account sending and
39  * paying for execution may not be the actual sender (as far as an application
40  * is concerned).
41  *
42  * This contract is only required for intermediate, library-like contracts.
43  */
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address payable) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
56 
57 
58 pragma solidity ^0.6.0;
59 
60 /**
61  * @dev Interface of the ERC20 standard as defined in the EIP.
62  */
63 interface IERC20 {
64     /**
65      * @dev Returns the amount of tokens in existence.
66      */
67     function totalSupply() external view returns (uint256);
68 
69     /**
70      * @dev Returns the amount of tokens owned by `account`.
71      */
72     function balanceOf(address account) external view returns (uint256);
73 
74     /**
75      * @dev Moves `amount` tokens from the caller's account to `recipient`.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transfer(address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Returns the remaining number of tokens that `spender` will be
85      * allowed to spend on behalf of `owner` through {transferFrom}. This is
86      * zero by default.
87      *
88      * This value changes when {approve} or {transferFrom} are called.
89      */
90     function allowance(address owner, address spender) external view returns (uint256);
91 
92     /**
93      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * IMPORTANT: Beware that changing an allowance with this method brings the risk
98      * that someone may use both the old and the new allowance by unfortunate
99      * transaction ordering. One possible solution to mitigate this race
100      * condition is to first reduce the spender's allowance to 0 and set the
101      * desired value afterwards:
102      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103      *
104      * Emits an {Approval} event.
105      */
106     function approve(address spender, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Moves `amount` tokens from `sender` to `recipient` using the
110      * allowance mechanism. `amount` is then deducted from the caller's
111      * allowance.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Emitted when `value` tokens are moved from one account (`from`) to
121      * another (`to`).
122      *
123      * Note that `value` may be zero.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 
127     /**
128      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
129      * a call to {approve}. `value` is the new allowance.
130      */
131     event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 // File: @openzeppelin/contracts/math/SafeMath.sol
135 
136 
137 pragma solidity ^0.6.0;
138 
139 /**
140  * @dev Wrappers over Solidity's arithmetic operations with added overflow
141  * checks.
142  *
143  * Arithmetic operations in Solidity wrap on overflow. This can easily result
144  * in bugs, because programmers usually assume that an overflow raises an
145  * error, which is the standard behavior in high level programming languages.
146  * `SafeMath` restores this intuition by reverting the transaction when an
147  * operation overflows.
148  *
149  * Using this library instead of the unchecked operations eliminates an entire
150  * class of bugs, so it's recommended to use it always.
151  */
152 library SafeMath {
153     /**
154      * @dev Returns the addition of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `+` operator.
158      *
159      * Requirements:
160      *
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
181         return sub(a, b, "SafeMath: subtraction overflow");
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b <= a, errorMessage);
196         uint256 c = a - b;
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the multiplication of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `*` operator.
206      *
207      * Requirements:
208      *
209      * - Multiplication cannot overflow.
210      */
211     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
213         // benefit is lost if 'b' is also tested.
214         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
215         if (a == 0) {
216             return 0;
217         }
218 
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         return div(a, b, "SafeMath: division by zero");
239     }
240 
241     /**
242      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
243      * division by zero. The result is rounded towards zero.
244      *
245      * Counterpart to Solidity's `/` operator. Note: this function uses a
246      * `revert` opcode (which leaves remaining gas untouched) while Solidity
247      * uses an invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b > 0, errorMessage);
255         uint256 c = a / b;
256         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
274         return mod(a, b, "SafeMath: modulo by zero");
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * Reverts with custom message when dividing by zero.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b != 0, errorMessage);
291         return a % b;
292     }
293 }
294 
295 // File: @openzeppelin/contracts/utils/Address.sol
296 
297 
298 pragma solidity ^0.6.2;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // This method relies in extcodesize, which returns 0 for contracts in
323         // construction, since the code is only stored at the end of the
324         // constructor execution.
325 
326         uint256 size;
327         // solhint-disable-next-line no-inline-assembly
328         assembly { size := extcodesize(account) }
329         return size > 0;
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
352         (bool success, ) = recipient.call{ value: amount }("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain`call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375       return functionCall(target, data, "Address: low-level call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
385         return _functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
405      * with `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
410         require(address(this).balance >= value, "Address: insufficient balance for call");
411         return _functionCallWithValue(target, data, value, errorMessage);
412     }
413 
414     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
415         require(isContract(target), "Address: call to non-contract");
416 
417         // solhint-disable-next-line avoid-low-level-calls
418         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
419         if (success) {
420             return returndata;
421         } else {
422             // Look for revert reason and bubble it up if present
423             if (returndata.length > 0) {
424                 // The easiest way to bubble the revert reason is using memory via assembly
425 
426                 // solhint-disable-next-line no-inline-assembly
427                 assembly {
428                     let returndata_size := mload(returndata)
429                     revert(add(32, returndata), returndata_size)
430                 }
431             } else {
432                 revert(errorMessage);
433             }
434         }
435     }
436 }
437 
438 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
439 
440 
441 pragma solidity ^0.6.0;
442 
443 
444 
445 
446 
447 /**
448  * @dev Implementation of the {IERC20} interface.
449  *
450  * This implementation is agnostic to the way tokens are created. This means
451  * that a supply mechanism has to be added in a derived contract using {_mint}.
452  * For a generic mechanism see {ERC20PresetMinterPauser}.
453  *
454  * TIP: For a detailed writeup see our guide
455  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
456  * to implement supply mechanisms].
457  *
458  * We have followed general OpenZeppelin guidelines: functions revert instead
459  * of returning `false` on failure. This behavior is nonetheless conventional
460  * and does not conflict with the expectations of ERC20 applications.
461  *
462  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
463  * This allows applications to reconstruct the allowance for all accounts just
464  * by listening to said events. Other implementations of the EIP may not emit
465  * these events, as it isn't required by the specification.
466  *
467  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
468  * functions have been added to mitigate the well-known issues around setting
469  * allowances. See {IERC20-approve}.
470  */
471 contract ERC20 is Context, IERC20 {
472     using SafeMath for uint256;
473     using Address for address;
474 
475     mapping (address => uint256) private _balances;
476 
477     mapping (address => mapping (address => uint256)) private _allowances;
478 
479     uint256 private _totalSupply;
480 
481     string private _name;
482     string private _symbol;
483     uint8 private _decimals;
484 
485     /**
486      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
487      * a default value of 18.
488      *
489      * To select a different value for {decimals}, use {_setupDecimals}.
490      *
491      * All three of these values are immutable: they can only be set once during
492      * construction.
493      */
494     constructor (string memory name, string memory symbol) public {
495         _name = name;
496         _symbol = symbol;
497         _decimals = 18;
498     }
499 
500     /**
501      * @dev Returns the name of the token.
502      */
503     function name() public view returns (string memory) {
504         return _name;
505     }
506 
507     /**
508      * @dev Returns the symbol of the token, usually a shorter version of the
509      * name.
510      */
511     function symbol() public view returns (string memory) {
512         return _symbol;
513     }
514 
515     /**
516      * @dev Returns the number of decimals used to get its user representation.
517      * For example, if `decimals` equals `2`, a balance of `505` tokens should
518      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
519      *
520      * Tokens usually opt for a value of 18, imitating the relationship between
521      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
522      * called.
523      *
524      * NOTE: This information is only used for _display_ purposes: it in
525      * no way affects any of the arithmetic of the contract, including
526      * {IERC20-balanceOf} and {IERC20-transfer}.
527      */
528     function decimals() public view returns (uint8) {
529         return _decimals;
530     }
531 
532     /**
533      * @dev See {IERC20-totalSupply}.
534      */
535     function totalSupply() public view override returns (uint256) {
536         return _totalSupply;
537     }
538 
539     /**
540      * @dev See {IERC20-balanceOf}.
541      */
542     function balanceOf(address account) public view override returns (uint256) {
543         return _balances[account];
544     }
545 
546     /**
547      * @dev See {IERC20-transfer}.
548      *
549      * Requirements:
550      *
551      * - `recipient` cannot be the zero address.
552      * - the caller must have a balance of at least `amount`.
553      */
554     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
555         _transfer(_msgSender(), recipient, amount);
556         return true;
557     }
558 
559     /**
560      * @dev See {IERC20-allowance}.
561      */
562     function allowance(address owner, address spender) public view virtual override returns (uint256) {
563         return _allowances[owner][spender];
564     }
565 
566     /**
567      * @dev See {IERC20-approve}.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      */
573     function approve(address spender, uint256 amount) public virtual override returns (bool) {
574         _approve(_msgSender(), spender, amount);
575         return true;
576     }
577 
578     /**
579      * @dev See {IERC20-transferFrom}.
580      *
581      * Emits an {Approval} event indicating the updated allowance. This is not
582      * required by the EIP. See the note at the beginning of {ERC20};
583      *
584      * Requirements:
585      * - `sender` and `recipient` cannot be the zero address.
586      * - `sender` must have a balance of at least `amount`.
587      * - the caller must have allowance for ``sender``'s tokens of at least
588      * `amount`.
589      */
590     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
591         _transfer(sender, recipient, amount);
592         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
593         return true;
594     }
595 
596     /**
597      * @dev Atomically increases the allowance granted to `spender` by the caller.
598      *
599      * This is an alternative to {approve} that can be used as a mitigation for
600      * problems described in {IERC20-approve}.
601      *
602      * Emits an {Approval} event indicating the updated allowance.
603      *
604      * Requirements:
605      *
606      * - `spender` cannot be the zero address.
607      */
608     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
609         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
610         return true;
611     }
612 
613     /**
614      * @dev Atomically decreases the allowance granted to `spender` by the caller.
615      *
616      * This is an alternative to {approve} that can be used as a mitigation for
617      * problems described in {IERC20-approve}.
618      *
619      * Emits an {Approval} event indicating the updated allowance.
620      *
621      * Requirements:
622      *
623      * - `spender` cannot be the zero address.
624      * - `spender` must have allowance for the caller of at least
625      * `subtractedValue`.
626      */
627     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
628         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
629         return true;
630     }
631 
632     /**
633      * @dev Moves tokens `amount` from `sender` to `recipient`.
634      *
635      * This is internal function is equivalent to {transfer}, and can be used to
636      * e.g. implement automatic token fees, slashing mechanisms, etc.
637      *
638      * Emits a {Transfer} event.
639      *
640      * Requirements:
641      *
642      * - `sender` cannot be the zero address.
643      * - `recipient` cannot be the zero address.
644      * - `sender` must have a balance of at least `amount`.
645      */
646     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
647         require(sender != address(0), "ERC20: transfer from the zero address");
648         require(recipient != address(0), "ERC20: transfer to the zero address");
649 
650         _beforeTokenTransfer(sender, recipient, amount);
651 
652         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
653         _balances[recipient] = _balances[recipient].add(amount);
654         emit Transfer(sender, recipient, amount);
655     }
656 
657     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
658      * the total supply.
659      *
660      * Emits a {Transfer} event with `from` set to the zero address.
661      *
662      * Requirements
663      *
664      * - `to` cannot be the zero address.
665      */
666     function _mint(address account, uint256 amount) internal virtual {
667         require(account != address(0), "ERC20: mint to the zero address");
668 
669         _beforeTokenTransfer(address(0), account, amount);
670 
671         _totalSupply = _totalSupply.add(amount);
672         _balances[account] = _balances[account].add(amount);
673         emit Transfer(address(0), account, amount);
674     }
675 
676     /**
677      * @dev Destroys `amount` tokens from `account`, reducing the
678      * total supply.
679      *
680      * Emits a {Transfer} event with `to` set to the zero address.
681      *
682      * Requirements
683      *
684      * - `account` cannot be the zero address.
685      * - `account` must have at least `amount` tokens.
686      */
687     function _burn(address account, uint256 amount) internal virtual {
688         require(account != address(0), "ERC20: burn from the zero address");
689 
690         _beforeTokenTransfer(account, address(0), amount);
691 
692         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
693         _totalSupply = _totalSupply.sub(amount);
694         emit Transfer(account, address(0), amount);
695     }
696 
697     /**
698      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
699      *
700      * This internal function is equivalent to `approve`, and can be used to
701      * e.g. set automatic allowances for certain subsystems, etc.
702      *
703      * Emits an {Approval} event.
704      *
705      * Requirements:
706      *
707      * - `owner` cannot be the zero address.
708      * - `spender` cannot be the zero address.
709      */
710     function _approve(address owner, address spender, uint256 amount) internal virtual {
711         require(owner != address(0), "ERC20: approve from the zero address");
712         require(spender != address(0), "ERC20: approve to the zero address");
713 
714         _allowances[owner][spender] = amount;
715         emit Approval(owner, spender, amount);
716     }
717 
718     /**
719      * @dev Sets {decimals} to a value other than the default one of 18.
720      *
721      * WARNING: This function should only be called from the constructor. Most
722      * applications that interact with token contracts will not expect
723      * {decimals} to ever change, and may work incorrectly if it does.
724      */
725     function _setupDecimals(uint8 decimals_) internal {
726         _decimals = decimals_;
727     }
728 
729     /**
730      * @dev Hook that is called before any transfer of tokens. This includes
731      * minting and burning.
732      *
733      * Calling conditions:
734      *
735      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
736      * will be to transferred to `to`.
737      * - when `from` is zero, `amount` tokens will be minted for `to`.
738      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
739      * - `from` and `to` are never both zero.
740      *
741      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
742      */
743     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
744 }
745 
746 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
747 
748 
749 pragma solidity ^0.6.0;
750 
751 
752 
753 
754 /**
755  * @title SafeERC20
756  * @dev Wrappers around ERC20 operations that throw on failure (when the token
757  * contract returns false). Tokens that return no value (and instead revert or
758  * throw on failure) are also supported, non-reverting calls are assumed to be
759  * successful.
760  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
761  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
762  */
763 library SafeERC20 {
764     using SafeMath for uint256;
765     using Address for address;
766 
767     function safeTransfer(IERC20 token, address to, uint256 value) internal {
768         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
769     }
770 
771     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
772         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
773     }
774 
775     /**
776      * @dev Deprecated. This function has issues similar to the ones found in
777      * {IERC20-approve}, and its usage is discouraged.
778      *
779      * Whenever possible, use {safeIncreaseAllowance} and
780      * {safeDecreaseAllowance} instead.
781      */
782     function safeApprove(IERC20 token, address spender, uint256 value) internal {
783         // safeApprove should only be called when setting an initial allowance,
784         // or when resetting it to zero. To increase and decrease it, use
785         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
786         // solhint-disable-next-line max-line-length
787         require((value == 0) || (token.allowance(address(this), spender) == 0),
788             "SafeERC20: approve from non-zero to non-zero allowance"
789         );
790         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
791     }
792 
793     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
794         uint256 newAllowance = token.allowance(address(this), spender).add(value);
795         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
796     }
797 
798     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
799         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
800         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
801     }
802 
803     /**
804      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
805      * on the return value: the return value is optional (but if data is returned, it must not be false).
806      * @param token The token targeted by the call.
807      * @param data The call data (encoded using abi.encode or one of its variants).
808      */
809     function _callOptionalReturn(IERC20 token, bytes memory data) private {
810         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
811         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
812         // the target address contains contract code and also asserts for success in the low-level call.
813 
814         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
815         if (returndata.length > 0) { // Return data is optional
816             // solhint-disable-next-line max-line-length
817             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
818         }
819     }
820 }
821 
822 // File: @openzeppelin/contracts/access/Ownable.sol
823 
824 
825 pragma solidity ^0.6.0;
826 
827 /**
828  * @dev Contract module which provides a basic access control mechanism, where
829  * there is an account (an owner) that can be granted exclusive access to
830  * specific functions.
831  *
832  * By default, the owner account will be the one that deploys the contract. This
833  * can later be changed with {transferOwnership}.
834  *
835  * This module is used through inheritance. It will make available the modifier
836  * `onlyOwner`, which can be applied to your functions to restrict their use to
837  * the owner.
838  */
839 contract Ownable is Context {
840     address private _owner;
841 
842     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
843 
844     /**
845      * @dev Initializes the contract setting the deployer as the initial owner.
846      */
847     constructor () internal {
848         address msgSender = _msgSender();
849         _owner = msgSender;
850         emit OwnershipTransferred(address(0), msgSender);
851     }
852 
853     /**
854      * @dev Returns the address of the current owner.
855      */
856     function owner() public view returns (address) {
857         return _owner;
858     }
859 
860     /**
861      * @dev Throws if called by any account other than the owner.
862      */
863     modifier onlyOwner() {
864         require(_owner == _msgSender(), "Ownable: caller is not the owner");
865         _;
866     }
867 
868     /**
869      * @dev Leaves the contract without owner. It will not be possible to call
870      * `onlyOwner` functions anymore. Can only be called by the current owner.
871      *
872      * NOTE: Renouncing ownership will leave the contract without an owner,
873      * thereby removing any functionality that is only available to the owner.
874      */
875     function renounceOwnership() public virtual onlyOwner {
876         emit OwnershipTransferred(_owner, address(0));
877         _owner = address(0);
878     }
879 
880     /**
881      * @dev Transfers ownership of the contract to a new account (`newOwner`).
882      * Can only be called by the current owner.
883      */
884     function transferOwnership(address newOwner) public virtual onlyOwner {
885         require(newOwner != address(0), "Ownable: new owner is the zero address");
886         emit OwnershipTransferred(_owner, newOwner);
887         _owner = newOwner;
888     }
889 }
890 
891 // File: contracts/AngryHippo.sol
892 
893 pragma solidity 0.6.12;
894 
895 
896 
897 
898 
899 contract AngryHippo is ERC20("AngryHippo", "aHIPPO"), Ownable {
900     using SafeMath for uint256;
901 
902     using SafeERC20 for IERC20;
903     using SafeMath for uint256;
904 
905     // Addresses
906     address public devAddress;
907     address public fundAddress;
908 
909     // Reward
910     uint256 public rewardPerBlock;
911     uint256 public rewardPerBlockLP;
912 
913     // Rate of Reward
914     uint256 public rateDevFee = 5;
915     uint256 public rateReward = 75;
916     uint256 public rateFund = 20;
917     uint256 public start_block = 0;
918 
919     // Addresses for stake
920     IERC20 public HippoToken;
921     IERC20 public HippoLPToken;
922 
923     // Start?
924     bool public isStart;
925 
926 
927     // Stakeaddress
928     struct stakeTracker {
929         uint256 lastBlock;
930         uint256 lastBlockLP;
931         uint256 rewards;
932         uint256 rewardsLP;
933         uint256 stakedHIPPO;
934         uint256 stakedHippoLP;
935     }
936     mapping(address => stakeTracker) public staked;
937 
938     // Amount
939     uint256 private totalStakedAmount = 0; // for HIPPO
940     uint256 private totalStakedAmountLP = 0; // for HIPPO/ETH
941 
942 
943     constructor(
944         address hippoToken,
945         address _devAddress,
946         address _fundAddress,
947         uint256 _start_block
948     ) public {
949         _mint(msg.sender, 10000 * 1000000000000000000);
950         devAddress = _devAddress;
951         fundAddress = _fundAddress;
952         rewardPerBlock = 2 * 1000000000000000000;
953         rewardPerBlockLP = 3 * 1000000000000000000;
954         start_block = _start_block;
955         HippoToken = IERC20(address(hippoToken));
956         isStart = false;
957     }
958 
959 
960     // Events
961     event Staked(address indexed user, uint256 amount, uint256 total);
962     event Unstaked(address indexed user, uint256 amount, uint256 total);
963     event StakedLP(address indexed user, uint256 amount, uint256 total);
964     event UnstakedLP(address indexed user, uint256 amount, uint256 total);
965     event Rewards(address indexed user, uint256 amount);
966 
967 
968     // Reward Updater
969     modifier updateStakingReward(address account) {
970 
971         uint256 h = 0;
972         uint256 lastBlock = staked[account].lastBlock;
973         if(block.number > staked[account].lastBlock && totalStakedAmount != 0) {
974             uint256 multiplier = block.number.sub(lastBlock);
975             uint256 hippoReward = multiplier.mul(rewardPerBlock);
976             h = hippoReward.mul(staked[account].stakedHIPPO).div(totalStakedAmount);
977             staked[account].rewards = staked[account].rewards.add(h);
978         }
979 
980         _;
981     }
982 
983 
984     // Reward Updater LP
985     modifier updateStakingRewardLP(address account) {
986 
987         uint256 h = 0;
988         uint256 lastBlockLP = staked[account].lastBlockLP;
989         if(block.number > staked[account].lastBlockLP && totalStakedAmountLP != 0) {
990             uint256 multiplier = block.number.sub(lastBlockLP);
991             uint256 hippoReward = multiplier.mul(rewardPerBlockLP);
992             h = hippoReward.mul(staked[account].stakedHippoLP).div(totalStakedAmountLP);
993             staked[account].rewardsLP = staked[account].rewardsLP.add(h);
994         }
995 
996         _;
997     }
998 
999 
1000 
1001     function setHippoToken(address _addr) public onlyOwner {
1002         HippoToken = IERC20(address(_addr));
1003     }
1004 
1005     function setHippoLPToken(address _addr) public onlyOwner {
1006         HippoLPToken = IERC20(address(_addr));
1007     }
1008 
1009 
1010     // Set Rewards both
1011     function setRewardPerBlockBoth(uint256 _hippo, uint256 _lp) public onlyOwner {
1012         rewardPerBlock = _hippo;
1013         rewardPerBlockLP = _lp;
1014     }
1015 
1016     // Set Reward Per Block
1017     function setRewardPerBlock(uint256 _amount) public onlyOwner {
1018         rewardPerBlock = _amount;
1019     }
1020 
1021     // Set Reward Per Block - LP
1022     function setRewardPerBlockLP(uint256 _amount) public onlyOwner {
1023         rewardPerBlockLP = _amount;
1024     }
1025 
1026     // Set Reward
1027     function setDevAddress(address addr) public onlyOwner {
1028         devAddress = addr;
1029     }
1030 
1031     // Set Funding Contract
1032     function setFundAddress(address addr) public onlyOwner {
1033         fundAddress = addr;
1034     }
1035 
1036 
1037     // Stake $HIPPO
1038     function stake(uint256 amount) public updateStakingReward(msg.sender) {
1039         require(isStart, "not started");
1040         require(0 < amount, ":stake: Fund Error");
1041         totalStakedAmount = totalStakedAmount.add(amount);
1042         staked[msg.sender].stakedHIPPO = staked[msg.sender].stakedHIPPO.add(amount);
1043         HippoToken.safeTransferFrom(msg.sender, address(this), amount);
1044         staked[msg.sender].lastBlock = block.number;
1045         emit Staked(msg.sender, amount, totalStakedAmount);
1046     }
1047 
1048     // Unstake $HIPPO
1049     function unstake(uint256 amount) public updateStakingReward(msg.sender) {
1050         require(isStart, "not started");
1051         require(amount <= staked[msg.sender].stakedHIPPO, ":unstake: Fund ERROR");
1052         require(0 < amount, ":unstake: Fund Error 2");
1053         totalStakedAmount = totalStakedAmount.sub(amount);
1054         staked[msg.sender].stakedHIPPO = staked[msg.sender].stakedHIPPO.sub(amount);
1055         HippoToken.safeTransfer(msg.sender, amount);
1056         staked[msg.sender].lastBlock = block.number;
1057         emit Unstaked(msg.sender, amount, totalStakedAmount);
1058     }
1059 
1060     // Stake $HIPPO/ETH
1061     function stakeLP(uint256 amount) public updateStakingRewardLP(msg.sender) {
1062         require(isStart, "not started");
1063         require(0 < amount, ":stakeLP: Fund Error");
1064         totalStakedAmountLP = totalStakedAmountLP.add(amount);
1065         staked[msg.sender].stakedHippoLP = staked[msg.sender].stakedHippoLP.add(amount);
1066         HippoLPToken.safeTransferFrom(msg.sender, address(this), amount);
1067         emit StakedLP(msg.sender, amount, totalStakedAmountLP);
1068     }
1069 
1070     // Unstake $HIPPO/ETH
1071     function unstakeLP(uint256 amount) public updateStakingRewardLP(msg.sender) {
1072         require(isStart, "not started");
1073         require(amount <= staked[msg.sender].stakedHippoLP, ":unstakeLP: Fund ERROR");
1074         require(0 < amount, ":unstakeLP: Fund Error 2");
1075         totalStakedAmountLP = totalStakedAmountLP.sub(amount);
1076         staked[msg.sender].stakedHippoLP = staked[msg.sender].stakedHippoLP.sub(amount);
1077         HippoLPToken.safeTransfer(msg.sender, amount);
1078         emit UnstakedLP(msg.sender, amount, totalStakedAmountLP);
1079     }
1080 
1081     // Claim
1082     function sendReward() public updateStakingReward(msg.sender) {
1083         require(isStart, "not started");
1084         require(0 < staked[msg.sender].rewards, "More than 0");
1085         uint256 reward = staked[msg.sender].rewards;
1086         staked[msg.sender].rewards = 0;
1087         uint256 totalWeight = rateReward.add(rateDevFee).add(rateFund);
1088         // 75% to User
1089         _mint(msg.sender, reward.div(totalWeight).mul(rateReward));
1090         // 20% to Funding event
1091         _mint(fundAddress, reward.div(totalWeight).mul(rateFund));
1092         // 5% to DevFee
1093         _mint(devAddress, reward.div(totalWeight).mul(rateDevFee));
1094         emit Rewards(msg.sender, reward);
1095     }
1096     
1097 
1098     // Claim LP
1099     function sendRewardLP() public updateStakingRewardLP(msg.sender) {
1100         require(isStart, "not started");
1101         require(0 < staked[msg.sender].rewards, "More than 0");
1102         uint256 reward = staked[msg.sender].rewards;
1103         staked[msg.sender].rewards = 0;
1104         uint256 totalWeight = rateReward.add(rateDevFee).add(rateFund);
1105         // 75% to User
1106         _mint(msg.sender, reward.div(totalWeight).mul(rateReward));
1107         // 20% to Funding event
1108         _mint(fundAddress, reward.div(totalWeight).mul(rateFund));
1109         // 5% to DevFee
1110         _mint(devAddress, reward.div(totalWeight).mul(rateDevFee));
1111         emit Rewards(msg.sender, reward);
1112     }
1113 
1114     function setStart() public onlyOwner {
1115         isStart = true;
1116     }
1117 
1118     // Get my reward
1119     function getHippoReward(address account) public view returns (uint256) {
1120         uint256 h = 0;
1121         uint256 lastBlock = staked[account].lastBlock;
1122         if(block.number > staked[account].lastBlock && totalStakedAmount != 0) {
1123             uint256 multiplier = block.number.sub(lastBlock);
1124             uint256 hippoReward = multiplier.mul(rewardPerBlock);
1125             h = hippoReward.mul(staked[account].stakedHIPPO).div(totalStakedAmount);
1126         }
1127         return staked[account].rewards.add(h);
1128     }
1129 
1130     function getHippoLPReward(address account) public view returns (uint256) {
1131         uint256 h = 0;
1132         uint256 lastBlock = staked[account].lastBlockLP;
1133         if(block.number > staked[account].lastBlockLP && totalStakedAmountLP != 0) {
1134             uint256 multiplier = block.number.sub(lastBlock);
1135             uint256 hippoReward = multiplier.mul(rewardPerBlockLP);
1136             h = hippoReward.mul(staked[account].stakedHippoLP).div(totalStakedAmountLP);
1137         }
1138         return staked[account].rewardsLP.add(h);
1139     }
1140 
1141     // Get staked amount of angry hippo
1142     function getStakedAmount(address _account) public view returns (uint256) {
1143         return staked[_account].stakedHIPPO;
1144     }
1145     
1146     // Get staked amount of angry hippo / eth
1147     function getStakedAmountOfLP(address _account) public view returns (uint256) {
1148         return staked[_account].stakedHippoLP;
1149     }
1150 
1151     // Get total staked aHIPPO
1152     function getTotalStakedAmount() public view returns (uint256) {
1153         return totalStakedAmount;
1154     }
1155 
1156     // Get total staked aHIPPO/ETH
1157     function getTotalStakedAmountLP() public view returns (uint256) {
1158         return totalStakedAmountLP;
1159     }
1160 }