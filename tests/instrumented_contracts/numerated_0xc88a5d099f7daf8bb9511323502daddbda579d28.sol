1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
82 
83 
84 pragma solidity ^0.6.0;
85 
86 /*
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with GSN meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address payable) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes memory) {
102         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
103         return msg.data;
104     }
105 }
106 
107 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
108 
109 
110 pragma solidity ^0.6.2;
111 
112 /**
113  * @dev Collection of functions related to the address type
114  */
115 library Address {
116     /**
117      * @dev Returns true if `account` is a contract.
118      *
119      * [IMPORTANT]
120      * ====
121      * It is unsafe to assume that an address for which this function returns
122      * false is an externally-owned account (EOA) and not a contract.
123      *
124      * Among others, `isContract` will return false for the following
125      * types of addresses:
126      *
127      *  - an externally-owned account
128      *  - a contract in construction
129      *  - an address where a contract will be created
130      *  - an address where a contract lived, but was destroyed
131      * ====
132      */
133     function isContract(address account) internal view returns (bool) {
134         // This method relies in extcodesize, which returns 0 for contracts in
135         // construction, since the code is only stored at the end of the
136         // constructor execution.
137 
138         uint256 size;
139         // solhint-disable-next-line no-inline-assembly
140         assembly { size := extcodesize(account) }
141         return size > 0;
142     }
143 
144     /**
145      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
146      * `recipient`, forwarding all available gas and reverting on errors.
147      *
148      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
149      * of certain opcodes, possibly making contracts go over the 2300 gas limit
150      * imposed by `transfer`, making them unable to receive funds via
151      * `transfer`. {sendValue} removes this limitation.
152      *
153      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
154      *
155      * IMPORTANT: because control is transferred to `recipient`, care must be
156      * taken to not create reentrancy vulnerabilities. Consider using
157      * {ReentrancyGuard} or the
158      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
159      */
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(address(this).balance >= amount, "Address: insufficient balance");
162 
163         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
164         (bool success, ) = recipient.call{ value: amount }("");
165         require(success, "Address: unable to send value, recipient may have reverted");
166     }
167 
168     /**
169      * @dev Performs a Solidity function call using a low level `call`. A
170      * plain`call` is an unsafe replacement for a function call: use this
171      * function instead.
172      *
173      * If `target` reverts with a revert reason, it is bubbled up by this
174      * function (like regular Solidity function calls).
175      *
176      * Returns the raw returned data. To convert to the expected return value,
177      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
178      *
179      * Requirements:
180      *
181      * - `target` must be a contract.
182      * - calling `target` with `data` must not revert.
183      *
184      * _Available since v3.1._
185      */
186     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
187       return functionCall(target, data, "Address: low-level call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
192      * `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
197         return _functionCallWithValue(target, data, 0, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
202      * but also transferring `value` wei to `target`.
203      *
204      * Requirements:
205      *
206      * - the calling contract must have an ETH balance of at least `value`.
207      * - the called Solidity function must be `payable`.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
217      * with `errorMessage` as a fallback revert reason when `target` reverts.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         return _functionCallWithValue(target, data, value, errorMessage);
224     }
225 
226     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
227         require(isContract(target), "Address: call to non-contract");
228 
229         // solhint-disable-next-line avoid-low-level-calls
230         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
231         if (success) {
232             return returndata;
233         } else {
234             // Look for revert reason and bubble it up if present
235             if (returndata.length > 0) {
236                 // The easiest way to bubble the revert reason is using memory via assembly
237 
238                 // solhint-disable-next-line no-inline-assembly
239                 assembly {
240                     let returndata_size := mload(returndata)
241                     revert(add(32, returndata), returndata_size)
242                 }
243             } else {
244                 revert(errorMessage);
245             }
246         }
247     }
248 }
249 
250 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
251 
252 
253 pragma solidity ^0.6.0;
254 
255 
256 
257 
258 
259 /**
260  * @dev Implementation of the {IERC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20PresetMinterPauser}.
265  *
266  * TIP: For a detailed writeup see our guide
267  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
268  * to implement supply mechanisms].
269  *
270  * We have followed general OpenZeppelin guidelines: functions revert instead
271  * of returning `false` on failure. This behavior is nonetheless conventional
272  * and does not conflict with the expectations of ERC20 applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20 {
284     using SafeMath for uint256;
285     using Address for address;
286 
287     mapping (address => uint256) private _balances;
288 
289     mapping (address => mapping (address => uint256)) private _allowances;
290 
291     uint256 private _totalSupply;
292 
293     string private _name;
294     string private _symbol;
295     uint8 private _decimals;
296 
297     /**
298      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
299      * a default value of 18.
300      *
301      * To select a different value for {decimals}, use {_setupDecimals}.
302      *
303      * All three of these values are immutable: they can only be set once during
304      * construction.
305      */
306     constructor (string memory name, string memory symbol) public {
307         _name = name;
308         _symbol = symbol;
309         _decimals = 18;
310     }
311 
312     /**
313      * @dev Returns the name of the token.
314      */
315     function name() public view returns (string memory) {
316         return _name;
317     }
318 
319     /**
320      * @dev Returns the symbol of the token, usually a shorter version of the
321      * name.
322      */
323     function symbol() public view returns (string memory) {
324         return _symbol;
325     }
326 
327     /**
328      * @dev Returns the number of decimals used to get its user representation.
329      * For example, if `decimals` equals `2`, a balance of `505` tokens should
330      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
331      *
332      * Tokens usually opt for a value of 18, imitating the relationship between
333      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
334      * called.
335      *
336      * NOTE: This information is only used for _display_ purposes: it in
337      * no way affects any of the arithmetic of the contract, including
338      * {IERC20-balanceOf} and {IERC20-transfer}.
339      */
340     function decimals() public view returns (uint8) {
341         return _decimals;
342     }
343 
344     /**
345      * @dev See {IERC20-totalSupply}.
346      */
347     function totalSupply() public view override returns (uint256) {
348         return _totalSupply;
349     }
350 
351     /**
352      * @dev See {IERC20-balanceOf}.
353      */
354     function balanceOf(address account) public view override returns (uint256) {
355         return _balances[account];
356     }
357 
358     /**
359      * @dev See {IERC20-transfer}.
360      *
361      * Requirements:
362      *
363      * - `recipient` cannot be the zero address.
364      * - the caller must have a balance of at least `amount`.
365      */
366     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
367         _transfer(_msgSender(), recipient, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-allowance}.
373      */
374     function allowance(address owner, address spender) public view virtual override returns (uint256) {
375         return _allowances[owner][spender];
376     }
377 
378     /**
379      * @dev See {IERC20-approve}.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function approve(address spender, uint256 amount) public virtual override returns (bool) {
386         _approve(_msgSender(), spender, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-transferFrom}.
392      *
393      * Emits an {Approval} event indicating the updated allowance. This is not
394      * required by the EIP. See the note at the beginning of {ERC20};
395      *
396      * Requirements:
397      * - `sender` and `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      * - the caller must have allowance for ``sender``'s tokens of at least
400      * `amount`.
401      */
402     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
403         _transfer(sender, recipient, amount);
404         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
405         return true;
406     }
407 
408     /**
409      * @dev Atomically increases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      */
420     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
421         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
422         return true;
423     }
424 
425     /**
426      * @dev Atomically decreases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      * - `spender` must have allowance for the caller of at least
437      * `subtractedValue`.
438      */
439     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
440         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
441         return true;
442     }
443 
444     /**
445      * @dev Moves tokens `amount` from `sender` to `recipient`.
446      *
447      * This is internal function is equivalent to {transfer}, and can be used to
448      * e.g. implement automatic token fees, slashing mechanisms, etc.
449      *
450      * Emits a {Transfer} event.
451      *
452      * Requirements:
453      *
454      * - `sender` cannot be the zero address.
455      * - `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      */
458     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462         _beforeTokenTransfer(sender, recipient, amount);
463 
464         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
465         _balances[recipient] = _balances[recipient].add(amount);
466         emit Transfer(sender, recipient, amount);
467     }
468 
469     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
470      * the total supply.
471      *
472      * Emits a {Transfer} event with `from` set to the zero address.
473      *
474      * Requirements
475      *
476      * - `to` cannot be the zero address.
477      */
478     function _mint(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: mint to the zero address");
480 
481         _beforeTokenTransfer(address(0), account, amount);
482 
483         _totalSupply = _totalSupply.add(amount);
484         _balances[account] = _balances[account].add(amount);
485         emit Transfer(address(0), account, amount);
486     }
487 
488     /**
489      * @dev Destroys `amount` tokens from `account`, reducing the
490      * total supply.
491      *
492      * Emits a {Transfer} event with `to` set to the zero address.
493      *
494      * Requirements
495      *
496      * - `account` cannot be the zero address.
497      * - `account` must have at least `amount` tokens.
498      */
499     function _burn(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: burn from the zero address");
501 
502         _beforeTokenTransfer(account, address(0), amount);
503 
504         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
505         _totalSupply = _totalSupply.sub(amount);
506         emit Transfer(account, address(0), amount);
507     }
508 
509     /**
510      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
511      *
512      * This internal function is equivalent to `approve`, and can be used to
513      * e.g. set automatic allowances for certain subsystems, etc.
514      *
515      * Emits an {Approval} event.
516      *
517      * Requirements:
518      *
519      * - `owner` cannot be the zero address.
520      * - `spender` cannot be the zero address.
521      */
522     function _approve(address owner, address spender, uint256 amount) internal virtual {
523         require(owner != address(0), "ERC20: approve from the zero address");
524         require(spender != address(0), "ERC20: approve to the zero address");
525 
526         _allowances[owner][spender] = amount;
527         emit Approval(owner, spender, amount);
528     }
529 
530     /**
531      * @dev Sets {decimals} to a value other than the default one of 18.
532      *
533      * WARNING: This function should only be called from the constructor. Most
534      * applications that interact with token contracts will not expect
535      * {decimals} to ever change, and may work incorrectly if it does.
536      */
537     function _setupDecimals(uint8 decimals_) internal {
538         _decimals = decimals_;
539     }
540 
541     /**
542      * @dev Hook that is called before any transfer of tokens. This includes
543      * minting and burning.
544      *
545      * Calling conditions:
546      *
547      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
548      * will be to transferred to `to`.
549      * - when `from` is zero, `amount` tokens will be minted for `to`.
550      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
551      * - `from` and `to` are never both zero.
552      *
553      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
554      */
555     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
556 }
557 
558 // File: @openzeppelin\contracts\math\SafeMath.sol
559 
560 
561 pragma solidity ^0.6.0;
562 
563 /**
564  * @dev Wrappers over Solidity's arithmetic operations with added overflow
565  * checks.
566  *
567  * Arithmetic operations in Solidity wrap on overflow. This can easily result
568  * in bugs, because programmers usually assume that an overflow raises an
569  * error, which is the standard behavior in high level programming languages.
570  * `SafeMath` restores this intuition by reverting the transaction when an
571  * operation overflows.
572  *
573  * Using this library instead of the unchecked operations eliminates an entire
574  * class of bugs, so it's recommended to use it always.
575  */
576 library SafeMath {
577     /**
578      * @dev Returns the addition of two unsigned integers, reverting on
579      * overflow.
580      *
581      * Counterpart to Solidity's `+` operator.
582      *
583      * Requirements:
584      *
585      * - Addition cannot overflow.
586      */
587     function add(uint256 a, uint256 b) internal pure returns (uint256) {
588         uint256 c = a + b;
589         require(c >= a, "SafeMath: addition overflow");
590 
591         return c;
592     }
593 
594     /**
595      * @dev Returns the subtraction of two unsigned integers, reverting on
596      * overflow (when the result is negative).
597      *
598      * Counterpart to Solidity's `-` operator.
599      *
600      * Requirements:
601      *
602      * - Subtraction cannot overflow.
603      */
604     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
605         return sub(a, b, "SafeMath: subtraction overflow");
606     }
607 
608     /**
609      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
610      * overflow (when the result is negative).
611      *
612      * Counterpart to Solidity's `-` operator.
613      *
614      * Requirements:
615      *
616      * - Subtraction cannot overflow.
617      */
618     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
619         require(b <= a, errorMessage);
620         uint256 c = a - b;
621 
622         return c;
623     }
624 
625     /**
626      * @dev Returns the multiplication of two unsigned integers, reverting on
627      * overflow.
628      *
629      * Counterpart to Solidity's `*` operator.
630      *
631      * Requirements:
632      *
633      * - Multiplication cannot overflow.
634      */
635     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
636         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
637         // benefit is lost if 'b' is also tested.
638         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
639         if (a == 0) {
640             return 0;
641         }
642 
643         uint256 c = a * b;
644         require(c / a == b, "SafeMath: multiplication overflow");
645 
646         return c;
647     }
648 
649     /**
650      * @dev Returns the integer division of two unsigned integers. Reverts on
651      * division by zero. The result is rounded towards zero.
652      *
653      * Counterpart to Solidity's `/` operator. Note: this function uses a
654      * `revert` opcode (which leaves remaining gas untouched) while Solidity
655      * uses an invalid opcode to revert (consuming all remaining gas).
656      *
657      * Requirements:
658      *
659      * - The divisor cannot be zero.
660      */
661     function div(uint256 a, uint256 b) internal pure returns (uint256) {
662         return div(a, b, "SafeMath: division by zero");
663     }
664 
665     /**
666      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
667      * division by zero. The result is rounded towards zero.
668      *
669      * Counterpart to Solidity's `/` operator. Note: this function uses a
670      * `revert` opcode (which leaves remaining gas untouched) while Solidity
671      * uses an invalid opcode to revert (consuming all remaining gas).
672      *
673      * Requirements:
674      *
675      * - The divisor cannot be zero.
676      */
677     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
678         require(b > 0, errorMessage);
679         uint256 c = a / b;
680         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
681 
682         return c;
683     }
684 
685     /**
686      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
687      * Reverts when dividing by zero.
688      *
689      * Counterpart to Solidity's `%` operator. This function uses a `revert`
690      * opcode (which leaves remaining gas untouched) while Solidity uses an
691      * invalid opcode to revert (consuming all remaining gas).
692      *
693      * Requirements:
694      *
695      * - The divisor cannot be zero.
696      */
697     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
698         return mod(a, b, "SafeMath: modulo by zero");
699     }
700 
701     /**
702      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
703      * Reverts with custom message when dividing by zero.
704      *
705      * Counterpart to Solidity's `%` operator. This function uses a `revert`
706      * opcode (which leaves remaining gas untouched) while Solidity uses an
707      * invalid opcode to revert (consuming all remaining gas).
708      *
709      * Requirements:
710      *
711      * - The divisor cannot be zero.
712      */
713     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
714         require(b != 0, errorMessage);
715         return a % b;
716     }
717 }
718 
719 // File: @openzeppelin\contracts\access\Ownable.sol
720 
721 
722 pragma solidity ^0.6.0;
723 
724 /**
725  * @dev Contract module which provides a basic access control mechanism, where
726  * there is an account (an owner) that can be granted exclusive access to
727  * specific functions.
728  *
729  * By default, the owner account will be the one that deploys the contract. This
730  * can later be changed with {transferOwnership}.
731  *
732  * This module is used through inheritance. It will make available the modifier
733  * `onlyOwner`, which can be applied to your functions to restrict their use to
734  * the owner.
735  */
736 contract Ownable is Context {
737     address private _owner;
738 
739     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
740 
741     /**
742      * @dev Initializes the contract setting the deployer as the initial owner.
743      */
744     constructor () internal {
745         address msgSender = _msgSender();
746         _owner = msgSender;
747         emit OwnershipTransferred(address(0), msgSender);
748     }
749 
750     /**
751      * @dev Returns the address of the current owner.
752      */
753     function owner() public view returns (address) {
754         return _owner;
755     }
756 
757     /**
758      * @dev Throws if called by any account other than the owner.
759      */
760     modifier onlyOwner() {
761         require(_owner == _msgSender(), "Ownable: caller is not the owner");
762         _;
763     }
764 
765     /**
766      * @dev Leaves the contract without owner. It will not be possible to call
767      * `onlyOwner` functions anymore. Can only be called by the current owner.
768      *
769      * NOTE: Renouncing ownership will leave the contract without an owner,
770      * thereby removing any functionality that is only available to the owner.
771      */
772     function renounceOwnership() public virtual onlyOwner {
773         emit OwnershipTransferred(_owner, address(0));
774         _owner = address(0);
775     }
776 
777     /**
778      * @dev Transfers ownership of the contract to a new account (`newOwner`).
779      * Can only be called by the current owner.
780      */
781     function transferOwnership(address newOwner) public virtual onlyOwner {
782         require(newOwner != address(0), "Ownable: new owner is the zero address");
783         emit OwnershipTransferred(_owner, newOwner);
784         _owner = newOwner;
785     }
786 }
787 
788 // File: ..\contracts\DraculaToken.sol
789 
790 
791 pragma solidity 0.6.12;
792 
793 
794 
795 
796 contract DraculaToken is ERC20("Dracula Token", "DRC"), Ownable {
797     using SafeMath for uint256;
798 
799     event Minted(address indexed minter, address indexed receiver, uint mintAmount);
800     event Burned(address indexed burner, uint burnAmount);
801 
802     function mint(address _to, uint256 _amount) public onlyOwner {
803         _mint(_to, _amount);
804         emit Minted(owner(), _to, _amount);
805     }
806 
807     function burn(uint256 _amount) public {
808         _burn(msg.sender, _amount);
809         emit Burned(msg.sender, _amount);
810     }
811 
812     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override virtual { 
813         _moveDelegates(_delegates[from], _delegates[to], amount);
814     }
815 
816     /// @dev A record of each accounts delegate
817     mapping (address => address) internal _delegates;
818 
819     /// @notice A checkpoint for marking number of votes from a given block
820     struct Checkpoint {
821         uint32 fromBlock;
822         uint256 votes;
823     }
824 
825     /// @notice A record of votes checkpoints for each account, by index
826     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
827 
828     /// @notice The number of checkpoints for each account
829     mapping (address => uint32) public numCheckpoints;
830 
831     /// @notice The EIP-712 typehash for the contract's domain
832     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
833 
834     /// @notice The EIP-712 typehash for the delegation struct used by the contract
835     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
836 
837     /// @notice A record of states for signing / validating signatures
838     mapping (address => uint) public nonces;
839 
840       /// @notice An event thats emitted when an account changes its delegate
841     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
842 
843     /// @notice An event thats emitted when a delegate account's vote balance changes
844     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
845 
846     /**
847      * @notice Delegate votes from `msg.sender` to `delegatee`
848      * @param delegator The address to get delegatee for
849      */
850     function delegates(address delegator)
851         external
852         view
853         returns (address)
854     {
855         return _delegates[delegator];
856     }
857 
858    /**
859     * @notice Delegate votes from `msg.sender` to `delegatee`
860     * @param delegatee The address to delegate votes to
861     */
862     function delegate(address delegatee) external {
863         return _delegate(msg.sender, delegatee);
864     }
865 
866     /**
867      * @notice Delegates votes from signatory to `delegatee`
868      * @param delegatee The address to delegate votes to
869      * @param nonce The contract state required to match the signature
870      * @param expiry The time at which to expire the signature
871      * @param v The recovery byte of the signature
872      * @param r Half of the ECDSA signature pair
873      * @param s Half of the ECDSA signature pair
874      */
875     function delegateBySig(
876         address delegatee,
877         uint nonce,
878         uint expiry,
879         uint8 v,
880         bytes32 r,
881         bytes32 s
882     )
883         external
884     {
885         bytes32 domainSeparator = keccak256(
886             abi.encode(
887                 DOMAIN_TYPEHASH,
888                 keccak256(bytes(name())),
889                 getChainId(),
890                 address(this)
891             )
892         );
893 
894         bytes32 structHash = keccak256(
895             abi.encode(
896                 DELEGATION_TYPEHASH,
897                 delegatee,
898                 nonce,
899                 expiry
900             )
901         );
902 
903         bytes32 digest = keccak256(
904             abi.encodePacked(
905                 "\x19\x01",
906                 domainSeparator,
907                 structHash
908             )
909         );
910 
911         address signatory = ecrecover(digest, v, r, s);
912         require(signatory != address(0), "DRC::delegateBySig: invalid signature");
913         require(nonce == nonces[signatory]++, "DRC::delegateBySig: invalid nonce");
914         require(now <= expiry, "DRC::delegateBySig: signature expired");
915         return _delegate(signatory, delegatee);
916     }
917 
918     /**
919      * @notice Gets the current votes balance for `account`
920      * @param account The address to get votes balance
921      * @return The number of current votes for `account`
922      */
923     function getCurrentVotes(address account)
924         external
925         view
926         returns (uint256)
927     {
928         uint32 nCheckpoints = numCheckpoints[account];
929         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
930     }
931 
932     /**
933      * @notice Determine the prior number of votes for an account as of a block number
934      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
935      * @param account The address of the account to check
936      * @param blockNumber The block number to get the vote balance at
937      * @return The number of votes the account had as of the given block
938      */
939     function getPriorVotes(address account, uint blockNumber)
940         external
941         view
942         returns (uint256)
943     {
944         require(blockNumber < block.number, "DRC::getPriorVotes: not yet determined");
945 
946         uint32 nCheckpoints = numCheckpoints[account];
947         if (nCheckpoints == 0) {
948             return 0;
949         }
950 
951         // First check most recent balance
952         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
953             return checkpoints[account][nCheckpoints - 1].votes;
954         }
955 
956         // Next check implicit zero balance
957         if (checkpoints[account][0].fromBlock > blockNumber) {
958             return 0;
959         }
960 
961         uint32 lower = 0;
962         uint32 upper = nCheckpoints - 1;
963         while (upper > lower) {
964             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
965             Checkpoint memory cp = checkpoints[account][center];
966             if (cp.fromBlock == blockNumber) {
967                 return cp.votes;
968             } else if (cp.fromBlock < blockNumber) {
969                 lower = center;
970             } else {
971                 upper = center - 1;
972             }
973         }
974         return checkpoints[account][lower].votes;
975     }
976 
977     function _delegate(address delegator, address delegatee)
978         internal
979     {
980         address currentDelegate = _delegates[delegator];
981         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying DRCs (not scaled);
982         _delegates[delegator] = delegatee;
983 
984         emit DelegateChanged(delegator, currentDelegate, delegatee);
985 
986         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
987     }
988 
989     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
990         if (srcRep != dstRep && amount > 0) {
991             if (srcRep != address(0)) {
992                 // decrease old representative
993                 uint32 srcRepNum = numCheckpoints[srcRep];
994                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
995                 uint256 srcRepNew = srcRepOld.sub(amount);
996                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
997             }
998 
999             if (dstRep != address(0)) {
1000                 // increase new representative
1001                 uint32 dstRepNum = numCheckpoints[dstRep];
1002                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1003                 uint256 dstRepNew = dstRepOld.add(amount);
1004                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1005             }
1006         }
1007     }
1008 
1009     function _writeCheckpoint(
1010         address delegatee,
1011         uint32 nCheckpoints,
1012         uint256 oldVotes,
1013         uint256 newVotes
1014     )
1015         internal
1016     {
1017         uint32 blockNumber = safe32(block.number, "DRC::_writeCheckpoint: block number exceeds 32 bits");
1018 
1019         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1020             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1021         } else {
1022             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1023             numCheckpoints[delegatee] = nCheckpoints + 1;
1024         }
1025 
1026         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1027     }
1028 
1029     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1030         require(n < 2**32, errorMessage);
1031         return uint32(n);
1032     }
1033 
1034     function getChainId() internal pure returns (uint) {
1035         uint256 chainId;
1036         assembly { chainId := chainid() }
1037         return chainId;
1038     }
1039 }
1040 
1041 // File: ..\contracts\DraculaHoard.sol
1042 
1043 
1044 pragma solidity ^0.6.12;
1045 
1046 
1047 
1048 
1049 
1050 
1051 contract DraculaHoard is ERC20("DraculaHoard", "BLOOD"), Ownable {
1052     using SafeMath for uint256;
1053     IERC20 public dracula;
1054     uint256 public burnRate = 1;
1055 
1056     constructor(IERC20 _draculaToken) public {
1057         dracula = _draculaToken;
1058     }
1059 
1060     function setBurnRate(uint256 _burnRate) external onlyOwner {
1061         require(_burnRate <= 10, "Invalid burn rate value");
1062         burnRate = _burnRate;
1063     }
1064 
1065     /// @notice Return staked amount + rewards
1066     function balance(address account) public view returns (uint256) {
1067         uint256 totalShares = totalSupply();
1068         return (totalShares > 0) ? balanceOf(account).mul(dracula.balanceOf(address(this))).div(totalShares) : 0;
1069     }
1070 
1071     function stake(uint256 _amount) external {
1072         uint256 totalDracula = dracula.balanceOf(address(this));
1073         uint256 totalShares = totalSupply();
1074         if (totalShares == 0 || totalDracula == 0) {
1075             _mint(msg.sender, _amount);
1076         }
1077         else {
1078             uint256 what = _amount.mul(totalShares).div(totalDracula);
1079             _mint(msg.sender, what);
1080         }
1081         dracula.transferFrom(msg.sender, address(this), _amount);
1082     }
1083 
1084     function unstake(uint256 _share) external {
1085         uint256 totalShares = totalSupply();
1086         uint256 what = _share.mul(dracula.balanceOf(address(this))).div(totalShares);
1087         _burn(msg.sender, _share);
1088         uint256 burnAmount = what.mul(burnRate).div(100);
1089         if (burnAmount > 0) {
1090             DraculaToken(address(dracula)).burn(burnAmount);
1091         }
1092         dracula.transfer(msg.sender, what.sub(burnAmount));
1093     }
1094 }