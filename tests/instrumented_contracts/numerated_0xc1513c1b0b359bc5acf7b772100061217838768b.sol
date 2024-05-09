1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-23
3 */
4 
5 pragma solidity ^0.6.7;
6 
7 
8 // SPDX-License-Identifier: MIT
9 interface IController {
10     function jars(address) external view returns (address);
11 
12     function rewards() external view returns (address);
13 
14     function devfund() external view returns (address);
15 
16     function treasury() external view returns (address);
17 
18     function balanceOf(address) external view returns (uint256);
19 
20     function withdraw(address, uint256) external;
21 
22     function earn(address, uint256) external;
23 }
24 
25 // SPDX-License-Identifier: MIT
26 /**
27  * @dev Wrappers over Solidity's arithmetic operations with added overflow
28  * checks.
29  *
30  * Arithmetic operations in Solidity wrap on overflow. This can easily result
31  * in bugs, because programmers usually assume that an overflow raises an
32  * error, which is the standard behavior in high level programming languages.
33  * `SafeMath` restores this intuition by reverting the transaction when an
34  * operation overflows.
35  *
36  * Using this library instead of the unchecked operations eliminates an entire
37  * class of bugs, so it's recommended to use it always.
38  */
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, reverting on
42      * overflow.
43      *
44      * Counterpart to Solidity's `+` operator.
45      *
46      * Requirements:
47      *
48      * - Addition cannot overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      *
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      *
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `*` operator.
93      *
94      * Requirements:
95      *
96      * - Multiplication cannot overflow.
97      */
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
100         // benefit is lost if 'b' is also tested.
101         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
102         if (a == 0) {
103             return 0;
104         }
105 
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator. Note: this function uses a
133      * `revert` opcode (which leaves remaining gas untouched) while Solidity
134      * uses an invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         return mod(a, b, "SafeMath: modulo by zero");
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * Reverts with custom message when dividing by zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b != 0, errorMessage);
178         return a % b;
179     }
180 }
181 
182 // SPDX-License-Identifier: MIT
183 /*
184  * @dev Provides information about the current execution context, including the
185  * sender of the transaction and its data. While these are generally available
186  * via msg.sender and msg.data, they should not be accessed in such a direct
187  * manner, since when dealing with GSN meta-transactions the account sending and
188  * paying for execution may not be the actual sender (as far as an application
189  * is concerned).
190  *
191  * This contract is only required for intermediate, library-like contracts.
192  */
193 abstract contract Context {
194     function _msgSender() internal view virtual returns (address payable) {
195         return msg.sender;
196     }
197 
198     function _msgData() internal view virtual returns (bytes memory) {
199         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
200         return msg.data;
201     }
202 }
203 
204 // File: contracts/GSN/Context.sol
205 // SPDX-License-Identifier: MIT
206 // File: contracts/token/ERC20/IERC20.sol
207 /**
208  * @dev Interface of the ERC20 standard as defined in the EIP.
209  */
210 interface IERC20 {
211     /**
212      * @dev Returns the amount of tokens in existence.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     /**
217      * @dev Returns the amount of tokens owned by `account`.
218      */
219     function balanceOf(address account) external view returns (uint256);
220 
221     /**
222      * @dev Moves `amount` tokens from the caller's account to `recipient`.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transfer(address recipient, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Returns the remaining number of tokens that `spender` will be
232      * allowed to spend on behalf of `owner` through {transferFrom}. This is
233      * zero by default.
234      *
235      * This value changes when {approve} or {transferFrom} are called.
236      */
237     function allowance(address owner, address spender) external view returns (uint256);
238 
239     /**
240      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * IMPORTANT: Beware that changing an allowance with this method brings the risk
245      * that someone may use both the old and the new allowance by unfortunate
246      * transaction ordering. One possible solution to mitigate this race
247      * condition is to first reduce the spender's allowance to 0 and set the
248      * desired value afterwards:
249      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250      *
251      * Emits an {Approval} event.
252      */
253     function approve(address spender, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Moves `amount` tokens from `sender` to `recipient` using the
257      * allowance mechanism. `amount` is then deducted from the caller's
258      * allowance.
259      *
260      * Returns a boolean value indicating whether the operation succeeded.
261      *
262      * Emits a {Transfer} event.
263      */
264     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
265 
266     /**
267      * @dev Emitted when `value` tokens are moved from one account (`from`) to
268      * another (`to`).
269      *
270      * Note that `value` may be zero.
271      */
272     event Transfer(address indexed from, address indexed to, uint256 value);
273 
274     /**
275      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
276      * a call to {approve}. `value` is the new allowance.
277      */
278     event Approval(address indexed owner, address indexed spender, uint256 value);
279 }
280 
281 // File: contracts/utils/Address.sol
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // This method relies on extcodesize, which returns 0 for contracts in
305         // construction, since the code is only stored at the end of the
306         // constructor execution.
307 
308         uint256 size;
309         // solhint-disable-next-line no-inline-assembly
310         assembly { size := extcodesize(account) }
311         return size > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
334         (bool success, ) = recipient.call{ value: amount }("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain`call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357       return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
367         return _functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         return _functionCallWithValue(target, data, value, errorMessage);
394     }
395 
396     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
397         require(isContract(target), "Address: call to non-contract");
398 
399         // solhint-disable-next-line avoid-low-level-calls
400         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407 
408                 // solhint-disable-next-line no-inline-assembly
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 // File: contracts/token/ERC20/ERC20.sol
421 /**
422  * @dev Implementation of the {IERC20} interface.
423  *
424  * This implementation is agnostic to the way tokens are created. This means
425  * that a supply mechanism has to be added in a derived contract using {_mint}.
426  * For a generic mechanism see {ERC20PresetMinterPauser}.
427  *
428  * TIP: For a detailed writeup see our guide
429  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
430  * to implement supply mechanisms].
431  *
432  * We have followed general OpenZeppelin guidelines: functions revert instead
433  * of returning `false` on failure. This behavior is nonetheless conventional
434  * and does not conflict with the expectations of ERC20 applications.
435  *
436  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
437  * This allows applications to reconstruct the allowance for all accounts just
438  * by listening to said events. Other implementations of the EIP may not emit
439  * these events, as it isn't required by the specification.
440  *
441  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
442  * functions have been added to mitigate the well-known issues around setting
443  * allowances. See {IERC20-approve}.
444  */
445 contract ERC20 is Context, IERC20 {
446     using SafeMath for uint256;
447     using Address for address;
448 
449     mapping (address => uint256) private _balances;
450 
451     mapping (address => mapping (address => uint256)) private _allowances;
452 
453     uint256 private _totalSupply;
454 
455     string private _name;
456     string private _symbol;
457     uint8 private _decimals;
458 
459     /**
460      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
461      * a default value of 18.
462      *
463      * To select a different value for {decimals}, use {_setupDecimals}.
464      *
465      * All three of these values are immutable: they can only be set once during
466      * construction.
467      */
468     constructor (string memory name, string memory symbol) public {
469         _name = name;
470         _symbol = symbol;
471         _decimals = 18;
472     }
473 
474     /**
475      * @dev Returns the name of the token.
476      */
477     function name() public view returns (string memory) {
478         return _name;
479     }
480 
481     /**
482      * @dev Returns the symbol of the token, usually a shorter version of the
483      * name.
484      */
485     function symbol() public view returns (string memory) {
486         return _symbol;
487     }
488 
489     /**
490      * @dev Returns the number of decimals used to get its user representation.
491      * For example, if `decimals` equals `2`, a balance of `505` tokens should
492      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
493      *
494      * Tokens usually opt for a value of 18, imitating the relationship between
495      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
496      * called.
497      *
498      * NOTE: This information is only used for _display_ purposes: it in
499      * no way affects any of the arithmetic of the contract, including
500      * {IERC20-balanceOf} and {IERC20-transfer}.
501      */
502     function decimals() public view returns (uint8) {
503         return _decimals;
504     }
505 
506     /**
507      * @dev See {IERC20-totalSupply}.
508      */
509     function totalSupply() public view override returns (uint256) {
510         return _totalSupply;
511     }
512 
513     /**
514      * @dev See {IERC20-balanceOf}.
515      */
516     function balanceOf(address account) public view override returns (uint256) {
517         return _balances[account];
518     }
519 
520     /**
521      * @dev See {IERC20-transfer}.
522      *
523      * Requirements:
524      *
525      * - `recipient` cannot be the zero address.
526      * - the caller must have a balance of at least `amount`.
527      */
528     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
529         _transfer(_msgSender(), recipient, amount);
530         return true;
531     }
532 
533     /**
534      * @dev See {IERC20-allowance}.
535      */
536     function allowance(address owner, address spender) public view virtual override returns (uint256) {
537         return _allowances[owner][spender];
538     }
539 
540     /**
541      * @dev See {IERC20-approve}.
542      *
543      * Requirements:
544      *
545      * - `spender` cannot be the zero address.
546      */
547     function approve(address spender, uint256 amount) public virtual override returns (bool) {
548         _approve(_msgSender(), spender, amount);
549         return true;
550     }
551 
552     /**
553      * @dev See {IERC20-transferFrom}.
554      *
555      * Emits an {Approval} event indicating the updated allowance. This is not
556      * required by the EIP. See the note at the beginning of {ERC20};
557      *
558      * Requirements:
559      * - `sender` and `recipient` cannot be the zero address.
560      * - `sender` must have a balance of at least `amount`.
561      * - the caller must have allowance for ``sender``'s tokens of at least
562      * `amount`.
563      */
564     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
565         _transfer(sender, recipient, amount);
566         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
567         return true;
568     }
569 
570     /**
571      * @dev Atomically increases the allowance granted to `spender` by the caller.
572      *
573      * This is an alternative to {approve} that can be used as a mitigation for
574      * problems described in {IERC20-approve}.
575      *
576      * Emits an {Approval} event indicating the updated allowance.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      */
582     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
583         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
584         return true;
585     }
586 
587     /**
588      * @dev Atomically decreases the allowance granted to `spender` by the caller.
589      *
590      * This is an alternative to {approve} that can be used as a mitigation for
591      * problems described in {IERC20-approve}.
592      *
593      * Emits an {Approval} event indicating the updated allowance.
594      *
595      * Requirements:
596      *
597      * - `spender` cannot be the zero address.
598      * - `spender` must have allowance for the caller of at least
599      * `subtractedValue`.
600      */
601     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
602         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
603         return true;
604     }
605 
606     /**
607      * @dev Moves tokens `amount` from `sender` to `recipient`.
608      *
609      * This is internal function is equivalent to {transfer}, and can be used to
610      * e.g. implement automatic token fees, slashing mechanisms, etc.
611      *
612      * Emits a {Transfer} event.
613      *
614      * Requirements:
615      *
616      * - `sender` cannot be the zero address.
617      * - `recipient` cannot be the zero address.
618      * - `sender` must have a balance of at least `amount`.
619      */
620     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
621         require(sender != address(0), "ERC20: transfer from the zero address");
622         require(recipient != address(0), "ERC20: transfer to the zero address");
623 
624         _beforeTokenTransfer(sender, recipient, amount);
625 
626         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
627         _balances[recipient] = _balances[recipient].add(amount);
628         emit Transfer(sender, recipient, amount);
629     }
630 
631     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
632      * the total supply.
633      *
634      * Emits a {Transfer} event with `from` set to the zero address.
635      *
636      * Requirements
637      *
638      * - `to` cannot be the zero address.
639      */
640     function _mint(address account, uint256 amount) internal virtual {
641         require(account != address(0), "ERC20: mint to the zero address");
642 
643         _beforeTokenTransfer(address(0), account, amount);
644 
645         _totalSupply = _totalSupply.add(amount);
646         _balances[account] = _balances[account].add(amount);
647         emit Transfer(address(0), account, amount);
648     }
649 
650     /**
651      * @dev Destroys `amount` tokens from `account`, reducing the
652      * total supply.
653      *
654      * Emits a {Transfer} event with `to` set to the zero address.
655      *
656      * Requirements
657      *
658      * - `account` cannot be the zero address.
659      * - `account` must have at least `amount` tokens.
660      */
661     function _burn(address account, uint256 amount) internal virtual {
662         require(account != address(0), "ERC20: burn from the zero address");
663 
664         _beforeTokenTransfer(account, address(0), amount);
665 
666         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
667         _totalSupply = _totalSupply.sub(amount);
668         emit Transfer(account, address(0), amount);
669     }
670 
671     /**
672      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
673      *
674      * This internal function is equivalent to `approve`, and can be used to
675      * e.g. set automatic allowances for certain subsystems, etc.
676      *
677      * Emits an {Approval} event.
678      *
679      * Requirements:
680      *
681      * - `owner` cannot be the zero address.
682      * - `spender` cannot be the zero address.
683      */
684     function _approve(address owner, address spender, uint256 amount) internal virtual {
685         require(owner != address(0), "ERC20: approve from the zero address");
686         require(spender != address(0), "ERC20: approve to the zero address");
687 
688         _allowances[owner][spender] = amount;
689         emit Approval(owner, spender, amount);
690     }
691 
692     /**
693      * @dev Sets {decimals} to a value other than the default one of 18.
694      *
695      * WARNING: This function should only be called from the constructor. Most
696      * applications that interact with token contracts will not expect
697      * {decimals} to ever change, and may work incorrectly if it does.
698      */
699     function _setupDecimals(uint8 decimals_) internal {
700         _decimals = decimals_;
701     }
702 
703     /**
704      * @dev Hook that is called before any transfer of tokens. This includes
705      * minting and burning.
706      *
707      * Calling conditions:
708      *
709      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
710      * will be to transferred to `to`.
711      * - when `from` is zero, `amount` tokens will be minted for `to`.
712      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
713      * - `from` and `to` are never both zero.
714      *
715      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
716      */
717     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
718 }
719 
720 /**
721  * @title SafeERC20
722  * @dev Wrappers around ERC20 operations that throw on failure (when the token
723  * contract returns false). Tokens that return no value (and instead revert or
724  * throw on failure) are also supported, non-reverting calls are assumed to be
725  * successful.
726  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
727  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
728  */
729 library SafeERC20 {
730     using SafeMath for uint256;
731     using Address for address;
732 
733     function safeTransfer(IERC20 token, address to, uint256 value) internal {
734         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
735     }
736 
737     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
738         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
739     }
740 
741     /**
742      * @dev Deprecated. This function has issues similar to the ones found in
743      * {IERC20-approve}, and its usage is discouraged.
744      *
745      * Whenever possible, use {safeIncreaseAllowance} and
746      * {safeDecreaseAllowance} instead.
747      */
748     function safeApprove(IERC20 token, address spender, uint256 value) internal {
749         // safeApprove should only be called when setting an initial allowance,
750         // or when resetting it to zero. To increase and decrease it, use
751         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
752         // solhint-disable-next-line max-line-length
753         require((value == 0) || (token.allowance(address(this), spender) == 0),
754             "SafeERC20: approve from non-zero to non-zero allowance"
755         );
756         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
757     }
758 
759     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
760         uint256 newAllowance = token.allowance(address(this), spender).add(value);
761         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
762     }
763 
764     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
765         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
766         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
767     }
768 
769     /**
770      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
771      * on the return value: the return value is optional (but if data is returned, it must not be false).
772      * @param token The token targeted by the call.
773      * @param data The call data (encoded using abi.encode or one of its variants).
774      */
775     function _callOptionalReturn(IERC20 token, bytes memory data) private {
776         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
777         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
778         // the target address contains contract code and also asserts for success in the low-level call.
779 
780         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
781         if (returndata.length > 0) { // Return data is optional
782             // solhint-disable-next-line max-line-length
783             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
784         }
785     }
786 }
787 
788 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
789 contract PickleJar is ERC20 {
790     using SafeERC20 for IERC20;
791     using Address for address;
792     using SafeMath for uint256;
793 
794     IERC20 public token;
795 
796     uint256 public min = 9500;
797     uint256 public constant max = 10000;
798 
799     address public governance;
800     address public timelock;
801     address public controller;
802 
803     constructor(address _token, address _governance, address _timelock, address _controller)
804         public
805         ERC20(
806             string(abi.encodePacked("pickling ", ERC20(_token).name())),
807             string(abi.encodePacked("p", ERC20(_token).symbol()))
808         )
809     {
810         _setupDecimals(ERC20(_token).decimals());
811         token = IERC20(_token);
812         governance = _governance;
813         timelock = _timelock;
814         controller = _controller;
815     }
816 
817     function balance() public view returns (uint256) {
818         return
819             token.balanceOf(address(this)).add(
820                 IController(controller).balanceOf(address(token))
821             );
822     }
823 
824     function setMin(uint256 _min) external {
825         require(msg.sender == governance, "!governance");
826         require(_min <= max, "numerator cannot be greater than denominator");
827         min = _min;
828     }
829 
830     function setGovernance(address _governance) public {
831         require(msg.sender == governance, "!governance");
832         governance = _governance;
833     }
834 
835     function setTimelock(address _timelock) public {
836         require(msg.sender == timelock, "!timelock");
837         timelock = _timelock;
838     }
839 
840     function setController(address _controller) public {
841         require(msg.sender == timelock, "!timelock");
842         controller = _controller;
843     }
844 
845     // Custom logic in here for how much the jars allows to be borrowed
846     // Sets minimum required on-hand to keep small withdrawals cheap
847     function available() public view returns (uint256) {
848         return token.balanceOf(address(this)).mul(min).div(max);
849     }
850 
851     function earn() public {
852         uint256 _bal = available();
853         token.safeTransfer(controller, _bal);
854         IController(controller).earn(address(token), _bal);
855     }
856 
857     function depositAll() external {
858         deposit(token.balanceOf(msg.sender));
859     }
860 
861     function deposit(uint256 _amount) public {
862         uint256 _pool = balance();
863         uint256 _before = token.balanceOf(address(this));
864         token.safeTransferFrom(msg.sender, address(this), _amount);
865         uint256 _after = token.balanceOf(address(this));
866         _amount = _after.sub(_before); // Additional check for deflationary tokens
867         uint256 shares = 0;
868         if (totalSupply() == 0) {
869             shares = _amount;
870         } else {
871             shares = (_amount.mul(totalSupply())).div(_pool);
872         }
873         _mint(msg.sender, shares);
874     }
875 
876     function withdrawAll() external {
877         withdraw(balanceOf(msg.sender));
878     }
879 
880     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
881     function harvest(address reserve, uint256 amount) external {
882         require(msg.sender == controller, "!controller");
883         require(reserve != address(token), "token");
884         IERC20(reserve).safeTransfer(controller, amount);
885     }
886 
887     // No rebalance implementation for lower fees and faster swaps
888     function withdraw(uint256 _shares) public {
889         uint256 r = (balance().mul(_shares)).div(totalSupply());
890         _burn(msg.sender, _shares);
891 
892         // Check balance
893         uint256 b = token.balanceOf(address(this));
894         if (b < r) {
895             uint256 _withdraw = r.sub(b);
896             IController(controller).withdraw(address(token), _withdraw);
897             uint256 _after = token.balanceOf(address(this));
898             uint256 _diff = _after.sub(b);
899             if (_diff < _withdraw) {
900                 r = b.add(_diff);
901             }
902         }
903 
904         token.safeTransfer(msg.sender, r);
905     }
906 
907     function getRatio() public view returns (uint256) {
908         return balance().mul(1e18).div(totalSupply());
909     }
910 }