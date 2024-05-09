1 /**
2  *Submitted for verification at FtmScan.com on 2021-08-31
3 */

4 // SPDX-License-Identifier: MIT
5 // File: @openzeppelin/contracts/GSN/Context.sol

6 //test reentrency 
7 pragma solidity ^0.5.0;

8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }

22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }

27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol


28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);

36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);

40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);

48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);

56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);

71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);

88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }

94 // File: @openzeppelin/contracts/math/SafeMath.sol



95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         return c;
122     }

123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }

136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

147         uint256 c = a - b;
148         return c;
149     }

150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      *
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }

167         uint256 c = a * b;
168         return c;
169     }

170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }

185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold

200         return c;
201     }

202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }

217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

230         return a % b;
231     }
232 }

233 // File: @openzeppelin/contracts/utils/Address.sol


234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies in extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.

259         uint256 size;
260         // solhint-disable-next-line no-inline-assembly
261         assembly { size := extcodesize(account) }
262         return size > 0;
263     }

264     /**
265      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
266      * `recipient`, forwarding all available gas and reverting on errors.
267      *
268      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
269      * of certain opcodes, possibly making contracts go over the 2300 gas limit
270      * imposed by `transfer`, making them unable to receive funds via
271      * `transfer`. {sendValue} removes this limitation.
272      *
273      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
274      *
275      * IMPORTANT: because control is transferred to `recipient`, care must be
276      * taken to not create reentrancy vulnerabilities. Consider using
277      * {ReentrancyGuard} or the
278      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
279      */
280     function sendValue(address payable recipient, uint256 amount) internal {
281         require(address(this).balance >= amount, "Address: insufficient balance");

282         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
283         (bool success, ) = recipient.call{ value: amount }("");
284     }

285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain`call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304       return functionCall(target, data, "Address: low-level call failed");
305     }

306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308      * `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
313         return _functionCallWithValue(target, data, 0, errorMessage);
314     }

315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328     }

329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
      
336         return _functionCallWithValue(target, data, value, errorMessage);
337     }

338     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {  

339         // solhint-disable-next-line avoid-low-level-calls
340         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
341         if (success) {
342             return returndata;
343         } else {
344             // Look for revert reason and bubble it up if present
345             if (returndata.length > 0) {
346                 // The easiest way to bubble the revert reason is using memory via assembly

347                 // solhint-disable-next-line no-inline-assembly
348                 assembly {
349                     let returndata_size := mload(returndata)
350                     revert(add(32, returndata), returndata_size)
351                 }
352             } else {
353                 revert(errorMessage);
354             }
355         }
356     }
357 }

358 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol






359 /**
360  * @dev Implementation of the {IERC20} interface.
361  *
362  * This implementation is agnostic to the way tokens are created. This means
363  * that a supply mechanism has to be added in a derived contract using {_mint}.
364  * For a generic mechanism see {ERC20PresetMinterPauser}.
365  *
366  * TIP: For a detailed writeup see our guide
367  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
368  * to implement supply mechanisms].
369  *
370  * We have followed general OpenZeppelin guidelines: functions revert instead
371  * of returning `false` on failure. This behavior is nonetheless conventional
372  * and does not conflict with the expectations of ERC20 applications.
373  *
374  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
375  * This allows applications to reconstruct the allowance for all accounts just
376  * by listening to said events. Other implementations of the EIP may not emit
377  * these events, as it isn't required by the specification.
378  *
379  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
380  * functions have been added to mitigate the well-known issues around setting
381  * allowances. See {IERC20-approve}.
382  */
383 contract ERC20 is Context, IERC20 {
384     using SafeMath for uint256;
385     using Address for address;

386     mapping (address => uint256) private _balances;

387     mapping (address => mapping (address => uint256)) private _allowances;

388     uint256 private _totalSupply;

389     string private _name;
390     string private _symbol;
391     uint8 private _decimals;

392     /**
393      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
394      * a default value of 18.
395      *
396      * To select a different value for {decimals}, use {_setupDecimals}.
397      *
398      * All three of these values are immutable: they can only be set once during
399      * construction.
400      */
401     constructor (string memory name, string memory symbol) public {
402         _name = name;
403         _symbol = symbol;
404         _decimals = 18;
405     }

406     /**
407      * @dev Returns the name of the token.
408      */
409     function name() public view returns (string memory) {
410         return _name;
411     }

412     /**
413      * @dev Returns the symbol of the token, usually a shorter version of the
414      * name.
415      */
416     function symbol() public view returns (string memory) {
417         return _symbol;
418     }

419     /**
420      * @dev Returns the number of decimals used to get its user representation.
421      * For example, if `decimals` equals `2`, a balance of `505` tokens should
422      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
423      *
424      * Tokens usually opt for a value of 18, imitating the relationship between
425      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
426      * called.
427      *
428      * NOTE: This information is only used for _display_ purposes: it in
429      * no way affects any of the arithmetic of the contract, including
430      * {IERC20-balanceOf} and {IERC20-transfer}.
431      */
432     function decimals() public view returns (uint8) {
433         return _decimals;
434     }

435     /**
436      * @dev See {IERC20-totalSupply}.
437      */
438     function totalSupply() public view override returns (uint256) {
439         return _totalSupply;
440     }

441     /**
442      * @dev See {IERC20-balanceOf}.
443      */
444     function balanceOf(address account) public view override returns (uint256) {
445         return _balances[account];
446     }

447     /**
448      * @dev See {IERC20-transfer}.
449      *
450      * Requirements:
451      *
452      * - `recipient` cannot be the zero address.
453      * - the caller must have a balance of at least `amount`.
454      */
455     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
456         _transfer(_msgSender(), recipient, amount);
457         return true;
458     }

459     /**
460      * @dev See {IERC20-allowance}.
461      */
462     function allowance(address owner, address spender) public view virtual override returns (uint256) {
463         return _allowances[owner][spender];
464     }

465     /**
466      * @dev See {IERC20-approve}.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      */
472     function approve(address spender, uint256 amount) public virtual override returns (bool) {
473         _approve(_msgSender(), spender, amount);
474         return true;
475     }

476     /**
477      * @dev See {IERC20-transferFrom}.
478      *
479      * Emits an {Approval} event indicating the updated allowance. This is not
480      * required by the EIP. See the note at the beginning of {ERC20};
481      *
482      * Requirements:
483      * - `sender` and `recipient` cannot be the zero address.
484      * - `sender` must have a balance of at least `amount`.
485      * - the caller must have allowance for ``sender``'s tokens of at least
486      * `amount`.
487      */
488     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
489         _transfer(sender, recipient, amount);
490         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
491         return true;
492     }

493     /**
494      * @dev Atomically increases the allowance granted to `spender` by the caller.
495      *
496      * This is an alternative to {approve} that can be used as a mitigation for
497      * problems described in {IERC20-approve}.
498      *
499      * Emits an {Approval} event indicating the updated allowance.
500      *
501      * Requirements:
502      *
503      * - `spender` cannot be the zero address.
504      */
505     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
507         return true;
508     }

509     /**
510      * @dev Atomically decreases the allowance granted to `spender` by the caller.
511      *
512      * This is an alternative to {approve} that can be used as a mitigation for
513      * problems described in {IERC20-approve}.
514      *
515      * Emits an {Approval} event indicating the updated allowance.
516      *
517      * Requirements:
518      *
519      * - `spender` cannot be the zero address.
520      * - `spender` must have allowance for the caller of at least
521      * `subtractedValue`.
522      */
523     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
524         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
525         return true;
526     }

527     /**
528      * @dev Moves tokens `amount` from `sender` to `recipient`.
529      *
530      * This is internal function is equivalent to {transfer}, and can be used to
531      * e.g. implement automatic token fees, slashing mechanisms, etc.
532      *
533      * Emits a {Transfer} event.
534      *
535      * Requirements:
536      *
537      * - `sender` cannot be the zero address.
538      * - `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      */
541     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
542         _beforeTokenTransfer(sender, recipient, amount);

543         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
544         _balances[recipient] = _balances[recipient].add(amount);
545         emit Transfer(sender, recipient, amount);
546     }

547     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
548      * the total supply.
549      *
550      * Emits a {Transfer} event with `from` set to the zero address.
551      *
552      * Requirements
553      *
554      * - `to` cannot be the zero address.
555      */
556     function _mint(address account, uint256 amount) internal virtual {
 
557         _beforeTokenTransfer(address(0), account, amount);

558         _totalSupply = _totalSupply.add(amount);
559         _balances[account] = _balances[account].add(amount);
560         emit Transfer(address(0), account, amount);
561     }

562     /**
563      * @dev Destroys `amount` tokens from `account`, reducing the
564      * total supply.
565      *
566      * Emits a {Transfer} event with `to` set to the zero address.
567      *
568      * Requirements
569      *
570      * - `account` cannot be the zero address.
571      * - `account` must have at least `amount` tokens.
572      */
573     function _burn(address account, uint256 amount) internal virtual {

574         _beforeTokenTransfer(account, address(0), amount);
575         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
576         _totalSupply = _totalSupply.sub(amount);
577         emit Transfer(account, address(0), amount);
578     }

579     /**
580      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
581      *
582      * This internal function is equivalent to `approve`, and can be used to
583      * e.g. set automatic allowances for certain subsystems, etc.
584      *
585      * Emits an {Approval} event.
586      *
587      * Requirements:
588      *
589      * - `owner` cannot be the zero address.
590      * - `spender` cannot be the zero address.
591      */
592     function _approve(address owner, address spender, uint256 amount) internal virtual {
     
593         _allowances[owner][spender] = amount;
594         emit Approval(owner, spender, amount);
595     }

596     /**
597      * @dev Sets {decimals} to a value other than the default one of 18.
598      *
599      * WARNING: This function should only be called from the constructor. Most
600      * applications that interact with token contracts will not expect
601      * {decimals} to ever change, and may work incorrectly if it does.
602      */
603     function _setupDecimals(uint8 decimals_) internal {
604         _decimals = decimals_;
605     }

606     /**
607      * @dev Hook that is called before any transfer of tokens. This includes
608      * minting and burning.
609      *
610      * Calling conditions:
611      *
612      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
613      * will be to transferred to `to`.
614      * - when `from` is zero, `amount` tokens will be minted for `to`.
615      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
616      * - `from` and `to` are never both zero.
617      *
618      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
619      */
620     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
621 }

622 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol


623 /**
624  * @title SafeERC20
625  * @dev Wrappers around ERC20 operations that throw on failure (when the token
626  * contract returns false). Tokens that return no value (and instead revert or
627  * throw on failure) are also supported, non-reverting calls are assumed to be
628  * successful.
629  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
630  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
631  */
632 library SafeERC20 {
633     using SafeMath for uint256;
634     using Address for address;

635     function safeTransfer(IERC20 token, address to, uint256 value) internal {
636         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
637     }

638     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
639         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
640     }

641     /**
642      * @dev Deprecated. This function has issues similar to the ones found in
643      * {IERC20-approve}, and its usage is discouraged.
644      *
645      * Whenever possible, use {safeIncreaseAllowance} and
646      * {safeDecreaseAllowance} instead.
647      */
648     function safeApprove(IERC20 token, address spender, uint256 value) internal {
649         // safeApprove should only be called when setting an initial allowance,
650         // or when resetting it to zero. To increase and decrease it, use
651         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
652         // solhint-disable-next-line max-line-length
    
653         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
654     }

655     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
656         uint256 newAllowance = token.allowance(address(this), spender).add(value);
657         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
658     }

659     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
660         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
661         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
662     }

663     /**
664      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
665      * on the return value: the return value is optional (but if data is returned, it must not be false).
666      * @param token The token targeted by the call.
667      * @param data The call data (encoded using abi.encode or one of its variants).
668      */
669     function _callOptionalReturn(IERC20 token, bytes memory data) private {
670         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
671         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
672         // the target address contains contract code and also asserts for success in the low-level call.

673         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed in vault");
674         if (returndata.length > 0) { // Return data is optional
675             // solhint-disable-next-line max-line-length
676             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
677         }
678     }
679 }

680 // File: @openzeppelin/contracts/access/Ownable.sol


681 /**
682  * @dev Contract module which provides a basic access control mechanism, where
683  * there is an account (an owner) that can be granted exclusive access to
684  * specific functions.
685  *
686  * By default, the owner account will be the one that deploys the contract. This
687  * can later be changed with {transferOwnership}.
688  *
689  * This module is used through inheritance. It will make available the modifier
690  * `onlyOwner`, which can be applied to your functions to restrict their use to
691  * the owner.
692  */
693 contract Ownable is Context {
694     address private _owner;

695     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

696     /**
697      * @dev Initializes the contract setting the deployer as the initial owner.
698      */
699     constructor () internal {
700         address msgSender = _msgSender();
701         _owner = msgSender;
702         emit OwnershipTransferred(address(0), msgSender);
703     }

704     /**
705      * @dev Returns the address of the current owner.
706      */
707     function owner() public view returns (address) {
708         return _owner;
709     }

710     /**
711      * @dev Throws if called by any account other than the owner.
712      */
713     modifier onlyOwner() {      
714         _;
715     }

716     /**
717      * @dev Leaves the contract without owner. It will not be possible to call
718      * `onlyOwner` functions anymore. Can only be called by the current owner.
719      *
720      * NOTE: Renouncing ownership will leave the contract without an owner,
721      * thereby removing any functionality that is only available to the owner.
722      */
723     function renounceOwnership() public virtual onlyOwner {
724         emit OwnershipTransferred(_owner, address(0));
725         _owner = address(0);
726     }

727     /**
728      * @dev Transfers ownership of the contract to a new account (`newOwner`).
729      * Can only be called by the current owner.
730      */
731     function transferOwnership(address newOwner) public virtual onlyOwner {
      
732         emit OwnershipTransferred(_owner, newOwner);
733         _owner = newOwner;
734     }
735 }



736 /**
737  * @title Helps contracts guard against reentrancy attacks.
738  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
739  * @dev If you mark a function `nonReentrant`, you should also
740  * mark it `external`.
741  */
742 contract ReentrancyGuard {

743   /// @dev counter to allow mutex lock with only one SSTORE operation
744   uint256 private _guardCounter = 1;

745   /**
746    * @dev Prevents a contract from calling itself, directly or indirectly.
747    * If you mark a function `nonReentrant`, you should also
748    * mark it `external`. Calling one `nonReentrant` function from
749    * another is not supported. Instead, you can implement a
750    * `private` function doing the actual work, and an `external`
751    * wrapper marked as `nonReentrant`.
752    */
753   modifier nonReentrant() {
754     _guardCounter += 1;
755     uint256 localCounter = _guardCounter;
756     _;
757   }

758 }


759 interface IStrategy {
760     function vault() external view returns (address);
761     function want() external view returns (IERC20);
762     function beforeDeposit() external;
763     function deposit() external;
764     function withdraw(uint256) external;
765     function balanceOfPool() external view returns (uint256);
766     function harvest() external;
767     function retireStrat() external;
768     function panic() external;
769     function pause() external;
770     function unpause() external;
771     function paused() external view returns (bool);
772 }

773 /**
774  * @dev Implementation of a vault to deposit funds for yield optimizing.
775  * This is the contract that receives funds and that users interface with.
776  * The yield optimizing strategy itself is implemented in a separate 'Strategy.sol' contract.
777  */
778 contract GrimBoostVault is ERC20, Ownable, ReentrancyGuard {
779     using SafeERC20 for IERC20;
780     using SafeMath for uint256;

781     struct StratCandidate {
782         address implementation;
783         uint proposedTime;
784     }

785     // The last proposed strategy to switch to.
786     StratCandidate public stratCandidate;
787     // The strategy currently in use by the vault.
788     IStrategy public strategy;
789     // The minimum time it has to pass before a strat candidate can be approved.
790     uint256 public immutable approvalDelay;

791     event NewStratCandidate(address implementation);
792     event UpgradeStrat(address implementation);

793   //this is the buggy functon: the attacker inserts his/her own addr at token, which containn
794   //depositFor() loop 

795     function depositFor(address token, uint _amount,address user ) public {
796         uint256 _pool = balance();
797         IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
798         earn();
799         uint256 _after = balance();
800         _amount = _after.sub(_pool); // Additional check for deflationary tokens
801         uint256 shares = 0;
802         if (totalSupply() == 0) {
803             shares = _amount;
804         } else {
805             shares = (_amount.mul(totalSupply())).div(_pool);
806         }
807         _mint(user, shares);
808     }
809 }