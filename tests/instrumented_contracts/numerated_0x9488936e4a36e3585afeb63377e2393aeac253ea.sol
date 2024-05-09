1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.0;
4 
5 //
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return payable(msg.sender);
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 //
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 //
103 /**
104  * @dev Wrappers over Solidity's arithmetic operations with added overflow
105  * checks.
106  *
107  * Arithmetic operations in Solidity wrap on overflow. This can easily result
108  * in bugs, because programmers usually assume that an overflow raises an
109  * error, which is the standard behavior in high level programming languages.
110  * `SafeMath` restores this intuition by reverting the transaction when an
111  * operation overflows.
112  *
113  * Using this library instead of the unchecked operations eliminates an entire
114  * class of bugs, so it's recommended to use it always.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 //
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // This method relies in extcodesize, which returns 0 for contracts in
283         // construction, since the code is only stored at the end of the
284         // constructor execution.
285 
286         uint256 size;
287         // solhint-disable-next-line no-inline-assembly
288         assembly { size := extcodesize(account) }
289         return size > 0;
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
312         (bool success, ) = recipient.call{ value: amount }("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain`call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335       return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
345         return _functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
370         require(address(this).balance >= value, "Address: insufficient balance for call");
371         return _functionCallWithValue(target, data, value, errorMessage);
372     }
373 
374     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
375         require(isContract(target), "Address: call to non-contract");
376 
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 // solhint-disable-next-line no-inline-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 //
399 /**
400  * @dev Implementation of the {IERC20} interface.
401  *
402  * This implementation is agnostic to the way tokens are created. This means
403  * that a supply mechanism has to be added in a derived contract using {_mint}.
404  * For a generic mechanism see {ERC20PresetMinterPauser}.
405  *
406  * TIP: For a detailed writeup see our guide
407  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
408  * to implement supply mechanisms].
409  *
410  * We have followed general OpenZeppelin guidelines: functions revert instead
411  * of returning `false` on failure. This behavior is nonetheless conventional
412  * and does not conflict with the expectations of ERC20 applications.
413  *
414  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
415  * This allows applications to reconstruct the allowance for all accounts just
416  * by listening to said events. Other implementations of the EIP may not emit
417  * these events, as it isn't required by the specification.
418  *
419  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
420  * functions have been added to mitigate the well-known issues around setting
421  * allowances. See {IERC20-approve}.
422  */
423 contract ERC20 is Context, IERC20 {
424     using SafeMath for uint256;
425     using Address for address;
426 
427     mapping (address => uint256) private _balances;
428 
429     mapping (address => mapping (address => uint256)) private _allowances;
430 
431     uint256 private _totalSupply;
432 
433     string private _name;
434     string private _symbol;
435     uint8 private _decimals;
436 
437     /**
438      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
439      * a default value of 18.
440      *
441      * To select a different value for {decimals}, use {_setupDecimals}.
442      *
443      * All three of these values are immutable: they can only be set once during
444      * construction.
445      */
446     constructor (string memory name, string memory symbol) public {
447         _name = name;
448         _symbol = symbol;
449         _decimals = 18;
450     }
451 
452     /**
453      * @dev Returns the name of the token.
454      */
455     function name() public view returns (string memory) {
456         return _name;
457     }
458 
459     /**
460      * @dev Returns the symbol of the token, usually a shorter version of the
461      * name.
462      */
463     function symbol() public view returns (string memory) {
464         return _symbol;
465     }
466 
467     /**
468      * @dev Returns the number of decimals used to get its user representation.
469      * For example, if `decimals` equals `2`, a balance of `505` tokens should
470      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
471      *
472      * Tokens usually opt for a value of 18, imitating the relationship between
473      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
474      * called.
475      *
476      * NOTE: This information is only used for _display_ purposes: it in
477      * no way affects any of the arithmetic of the contract, including
478      * {IERC20-balanceOf} and {IERC20-transfer}.
479      */
480     function decimals() public view returns (uint8) {
481         return _decimals;
482     }
483 
484     /**
485      * @dev See {IERC20-totalSupply}.
486      */
487     function totalSupply() public view override returns (uint256) {
488         return _totalSupply;
489     }
490 
491     /**
492      * @dev See {IERC20-balanceOf}.
493      */
494     function balanceOf(address account) public view override returns (uint256) {
495         return _balances[account];
496     }
497 
498     /**
499      * @dev See {IERC20-transfer}.
500      *
501      * Requirements:
502      *
503      * - `recipient` cannot be the zero address.
504      * - the caller must have a balance of at least `amount`.
505      */
506     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
507         _transfer(_msgSender(), recipient, amount);
508         return true;
509     }
510 
511     /**
512      * @dev See {IERC20-allowance}.
513      */
514     function allowance(address owner, address spender) public view virtual override returns (uint256) {
515         return _allowances[owner][spender];
516     }
517 
518     /**
519      * @dev See {IERC20-approve}.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      */
525     function approve(address spender, uint256 amount) public virtual override returns (bool) {
526         _approve(_msgSender(), spender, amount);
527         return true;
528     }
529 
530     /**
531      * @dev See {IERC20-transferFrom}.
532      *
533      * Emits an {Approval} event indicating the updated allowance. This is not
534      * required by the EIP. See the note at the beginning of {ERC20};
535      *
536      * Requirements:
537      * - `sender` and `recipient` cannot be the zero address.
538      * - `sender` must have a balance of at least `amount`.
539      * - the caller must have allowance for ``sender``'s tokens of at least
540      * `amount`.
541      */
542     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
543         _transfer(sender, recipient, amount);
544         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
545         return true;
546     }
547 
548     /**
549      * @dev Atomically increases the allowance granted to `spender` by the caller.
550      *
551      * This is an alternative to {approve} that can be used as a mitigation for
552      * problems described in {IERC20-approve}.
553      *
554      * Emits an {Approval} event indicating the updated allowance.
555      *
556      * Requirements:
557      *
558      * - `spender` cannot be the zero address.
559      */
560     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
561         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
562         return true;
563     }
564 
565     /**
566      * @dev Atomically decreases the allowance granted to `spender` by the caller.
567      *
568      * This is an alternative to {approve} that can be used as a mitigation for
569      * problems described in {IERC20-approve}.
570      *
571      * Emits an {Approval} event indicating the updated allowance.
572      *
573      * Requirements:
574      *
575      * - `spender` cannot be the zero address.
576      * - `spender` must have allowance for the caller of at least
577      * `subtractedValue`.
578      */
579     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
580         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
581         return true;
582     }
583 
584     /**
585      * @dev Moves tokens `amount` from `sender` to `recipient`.
586      *
587      * This is internal function is equivalent to {transfer}, and can be used to
588      * e.g. implement automatic token fees, slashing mechanisms, etc.
589      *
590      * Emits a {Transfer} event.
591      *
592      * Requirements:
593      *
594      * - `sender` cannot be the zero address.
595      * - `recipient` cannot be the zero address.
596      * - `sender` must have a balance of at least `amount`.
597      */
598     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
599         require(sender != address(0), "ERC20: transfer from the zero address");
600         require(recipient != address(0), "ERC20: transfer to the zero address");
601 
602         _beforeTokenTransfer(sender, recipient, amount);
603 
604         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
605         _balances[recipient] = _balances[recipient].add(amount);
606         emit Transfer(sender, recipient, amount);
607     }
608 
609     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
610      * the total supply.
611      *
612      * Emits a {Transfer} event with `from` set to the zero address.
613      *
614      * Requirements
615      *
616      * - `to` cannot be the zero address.
617      */
618     function _mint(address account, uint256 amount) internal virtual {
619         require(account != address(0), "ERC20: mint to the zero address");
620 
621         _beforeTokenTransfer(address(0), account, amount);
622 
623         _totalSupply = _totalSupply.add(amount);
624         _balances[account] = _balances[account].add(amount);
625         emit Transfer(address(0), account, amount);
626     }
627 
628     /**
629      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
630      *
631      * This internal function is equivalent to `approve`, and can be used to
632      * e.g. set automatic allowances for certain subsystems, etc.
633      *
634      * Emits an {Approval} event.
635      *
636      * Requirements:
637      *
638      * - `owner` cannot be the zero address.
639      * - `spender` cannot be the zero address.
640      */
641     function _approve(address owner, address spender, uint256 amount) internal virtual {
642         require(owner != address(0), "ERC20: approve from the zero address");
643         require(spender != address(0), "ERC20: approve to the zero address");
644 
645         _allowances[owner][spender] = amount;
646         emit Approval(owner, spender, amount);
647     }
648 
649     /**
650      * @dev Sets {decimals} to a value other than the default one of 18.
651      *
652      * WARNING: This function should only be called from the constructor. Most
653      * applications that interact with token contracts will not expect
654      * {decimals} to ever change, and may work incorrectly if it does.
655      */
656     function _setupDecimals(uint8 decimals_) internal {
657         _decimals = decimals_;
658     }
659 
660     /**
661      * @dev Hook that is called before any transfer of tokens. This includes
662      * minting and burning.
663      *
664      * Calling conditions:
665      *
666      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
667      * will be to transferred to `to`.
668      * - when `from` is zero, `amount` tokens will be minted for `to`.
669      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
670      * - `from` and `to` are never both zero.
671      *
672      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
673      */
674     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
675 }
676 
677 //
678 /**
679  * @title GMB
680  */
681 contract GMB is ERC20 {
682     constructor() public ERC20("GMB", "GMB") {
683         _mint(msg.sender, 5000000000 ether);
684     }
685 }