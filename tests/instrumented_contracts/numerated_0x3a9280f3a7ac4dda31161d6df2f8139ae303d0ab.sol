1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations with added overflow
101  * checks.
102  *
103  * Arithmetic operations in Solidity wrap on overflow. This can easily result
104  * in bugs, because programmers usually assume that an overflow raises an
105  * error, which is the standard behavior in high level programming languages.
106  * `SafeMath` restores this intuition by reverting the transaction when an
107  * operation overflows.
108  *
109  * Using this library instead of the unchecked operations eliminates an entire
110  * class of bugs, so it's recommended to use it always.
111  */
112 library SafeMath {
113     /**
114      * @dev Returns the addition of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `+` operator.
118      *
119      * Requirements:
120      *
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the multiplication of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `*` operator.
166      *
167      * Requirements:
168      *
169      * - Multiplication cannot overflow.
170      */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts on
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
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts with custom message when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // This method relies on extcodesize, which returns 0 for contracts in
278         // construction, since the code is only stored at the end of the
279         // constructor execution.
280 
281         uint256 size;
282         // solhint-disable-next-line no-inline-assembly
283         assembly { size := extcodesize(account) }
284         return size > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
307         (bool success, ) = recipient.call{ value: amount }("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 
311     /**
312      * @dev Performs a Solidity function call using a low level `call`. A
313      * plain`call` is an unsafe replacement for a function call: use this
314      * function instead.
315      *
316      * If `target` reverts with a revert reason, it is bubbled up by this
317      * function (like regular Solidity function calls).
318      *
319      * Returns the raw returned data. To convert to the expected return value,
320      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
321      *
322      * Requirements:
323      *
324      * - `target` must be a contract.
325      * - calling `target` with `data` must not revert.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
330       return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335      * `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but also transferring `value` wei to `target`.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least `value`.
350      * - the called Solidity function must be `payable`.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
360      * with `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
365         require(address(this).balance >= value, "Address: insufficient balance for call");
366         require(isContract(target), "Address: call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = target.call{ value: value }(data);
370         return _verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
380         return functionStaticCall(target, data, "Address: low-level static call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return _verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 /**
418  * @dev Implementation of the {IERC20} interface.
419  *
420  * This implementation is agnostic to the way tokens are created. This means
421  * that a supply mechanism has to be added in a derived contract using {_mint}.
422  * For a generic mechanism see {ERC20PresetMinterPauser}.
423  *
424  * TIP: For a detailed writeup see our guide
425  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
426  * to implement supply mechanisms].
427  *
428  * We have followed general OpenZeppelin guidelines: functions revert instead
429  * of returning `false` on failure. This behavior is nonetheless conventional
430  * and does not conflict with the expectations of ERC20 applications.
431  *
432  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
433  * This allows applications to reconstruct the allowance for all accounts just
434  * by listening to said events. Other implementations of the EIP may not emit
435  * these events, as it isn't required by the specification.
436  *
437  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
438  * functions have been added to mitigate the well-known issues around setting
439  * allowances. See {IERC20-approve}.
440  */
441 contract ERC20 is Context, IERC20 {
442     using SafeMath for uint256;
443 
444     mapping (address => uint256) private _balances;
445 
446     mapping (address => mapping (address => uint256)) private _allowances;
447 
448     uint256 private _totalSupply;
449 
450     string private _name;
451     string private _symbol;
452     uint8 private _decimals;
453 
454     /**
455      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
456      * a default value of 18.
457      *
458      * To select a different value for {decimals}, use {_setupDecimals}.
459      *
460      * All three of these values are immutable: they can only be set once during
461      * construction.
462      */
463     constructor (string memory name_, string memory symbol_) public {
464         _name = name_;
465         _symbol = symbol_;
466         _decimals = 18;
467     }
468 
469     /**
470      * @dev Returns the name of the token.
471      */
472     function name() public view returns (string memory) {
473         return _name;
474     }
475 
476     /**
477      * @dev Returns the symbol of the token, usually a shorter version of the
478      * name.
479      */
480     function symbol() public view returns (string memory) {
481         return _symbol;
482     }
483 
484     /**
485      * @dev Returns the number of decimals used to get its user representation.
486      * For example, if `decimals` equals `2`, a balance of `505` tokens should
487      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
488      *
489      * Tokens usually opt for a value of 18, imitating the relationship between
490      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
491      * called.
492      *
493      * NOTE: This information is only used for _display_ purposes: it in
494      * no way affects any of the arithmetic of the contract, including
495      * {IERC20-balanceOf} and {IERC20-transfer}.
496      */
497     function decimals() public view returns (uint8) {
498         return _decimals;
499     }
500 
501     /**
502      * @dev See {IERC20-totalSupply}.
503      */
504     function totalSupply() public view override returns (uint256) {
505         return _totalSupply;
506     }
507 
508     /**
509      * @dev See {IERC20-balanceOf}.
510      */
511     function balanceOf(address account) public view override returns (uint256) {
512         return _balances[account];
513     }
514 
515     /**
516      * @dev See {IERC20-transfer}.
517      *
518      * Requirements:
519      *
520      * - `recipient` cannot be the zero address.
521      * - the caller must have a balance of at least `amount`.
522      */
523     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
524         _transfer(_msgSender(), recipient, amount);
525         return true;
526     }
527 
528     /**
529      * @dev See {IERC20-allowance}.
530      */
531     function allowance(address owner, address spender) public view virtual override returns (uint256) {
532         return _allowances[owner][spender];
533     }
534 
535     /**
536      * @dev See {IERC20-approve}.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      */
542     function approve(address spender, uint256 amount) public virtual override returns (bool) {
543         _approve(_msgSender(), spender, amount);
544         return true;
545     }
546 
547     /**
548      * @dev See {IERC20-transferFrom}.
549      *
550      * Emits an {Approval} event indicating the updated allowance. This is not
551      * required by the EIP. See the note at the beginning of {ERC20}.
552      *
553      * Requirements:
554      *
555      * - `sender` and `recipient` cannot be the zero address.
556      * - `sender` must have a balance of at least `amount`.
557      * - the caller must have allowance for ``sender``'s tokens of at least
558      * `amount`.
559      */
560     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
561         _transfer(sender, recipient, amount);
562         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically increases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      */
578     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
580         return true;
581     }
582 
583     /**
584      * @dev Atomically decreases the allowance granted to `spender` by the caller.
585      *
586      * This is an alternative to {approve} that can be used as a mitigation for
587      * problems described in {IERC20-approve}.
588      *
589      * Emits an {Approval} event indicating the updated allowance.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      * - `spender` must have allowance for the caller of at least
595      * `subtractedValue`.
596      */
597     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
598         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
599         return true;
600     }
601 
602     /**
603      * @dev Moves tokens `amount` from `sender` to `recipient`.
604      *
605      * This is internal function is equivalent to {transfer}, and can be used to
606      * e.g. implement automatic token fees, slashing mechanisms, etc.
607      *
608      * Emits a {Transfer} event.
609      *
610      * Requirements:
611      *
612      * - `sender` cannot be the zero address.
613      * - `recipient` cannot be the zero address.
614      * - `sender` must have a balance of at least `amount`.
615      */
616     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
617         require(sender != address(0), "ERC20: transfer from the zero address");
618         require(recipient != address(0), "ERC20: transfer to the zero address");
619 
620         _beforeTokenTransfer(sender, recipient, amount);
621 
622         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
623         _balances[recipient] = _balances[recipient].add(amount);
624         emit Transfer(sender, recipient, amount);
625     }
626 
627     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
628      * the total supply.
629      *
630      * Emits a {Transfer} event with `from` set to the zero address.
631      *
632      * Requirements:
633      *
634      * - `to` cannot be the zero address.
635      */
636     function _mint(address account, uint256 amount) internal virtual {
637         require(account != address(0), "ERC20: mint to the zero address");
638 
639         _beforeTokenTransfer(address(0), account, amount);
640 
641         _totalSupply = _totalSupply.add(amount);
642         _balances[account] = _balances[account].add(amount);
643         emit Transfer(address(0), account, amount);
644     }
645 
646     /**
647      * @dev Destroys `amount` tokens from `account`, reducing the
648      * total supply.
649      *
650      * Emits a {Transfer} event with `to` set to the zero address.
651      *
652      * Requirements:
653      *
654      * - `account` cannot be the zero address.
655      * - `account` must have at least `amount` tokens.
656      */
657     function _burn(address account, uint256 amount) internal virtual {
658         require(account != address(0), "ERC20: burn from the zero address");
659 
660         _beforeTokenTransfer(account, address(0), amount);
661 
662         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
663         _totalSupply = _totalSupply.sub(amount);
664         emit Transfer(account, address(0), amount);
665     }
666 
667     /**
668      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
669      *
670      * This internal function is equivalent to `approve`, and can be used to
671      * e.g. set automatic allowances for certain subsystems, etc.
672      *
673      * Emits an {Approval} event.
674      *
675      * Requirements:
676      *
677      * - `owner` cannot be the zero address.
678      * - `spender` cannot be the zero address.
679      */
680     function _approve(address owner, address spender, uint256 amount) internal virtual {
681         require(owner != address(0), "ERC20: approve from the zero address");
682         require(spender != address(0), "ERC20: approve to the zero address");
683 
684         _allowances[owner][spender] = amount;
685         emit Approval(owner, spender, amount);
686     }
687 
688     /**
689      * @dev Sets {decimals} to a value other than the default one of 18.
690      *
691      * WARNING: This function should only be called from the constructor. Most
692      * applications that interact with token contracts will not expect
693      * {decimals} to ever change, and may work incorrectly if it does.
694      */
695     function _setupDecimals(uint8 decimals_) internal {
696         _decimals = decimals_;
697     }
698 
699     /**
700      * @dev Hook that is called before any transfer of tokens. This includes
701      * minting and burning.
702      *
703      * Calling conditions:
704      *
705      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
706      * will be to transferred to `to`.
707      * - when `from` is zero, `amount` tokens will be minted for `to`.
708      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
709      * - `from` and `to` are never both zero.
710      *
711      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
712      */
713     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
714 }
715 
716 /**
717  * @dev Extension of {ERC20} that allows token holders to destroy both their own
718  * tokens and those that they have an allowance for, in a way that can be
719  * recognized off-chain (via event analysis).
720  */
721 abstract contract ERC20Burnable is Context, ERC20 {
722     using SafeMath for uint256;
723 
724     /**
725      * @dev Destroys `amount` tokens from the caller.
726      *
727      * See {ERC20-_burn}.
728      */
729     function burn(uint256 amount) public virtual {
730         _burn(_msgSender(), amount);
731     }
732 
733     /**
734      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
735      * allowance.
736      *
737      * See {ERC20-_burn} and {ERC20-allowance}.
738      *
739      * Requirements:
740      *
741      * - the caller must have allowance for ``accounts``'s tokens of at least
742      * `amount`.
743      */
744     function burnFrom(address account, uint256 amount) public virtual {
745         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
746 
747         _approve(account, _msgSender(), decreasedAllowance);
748         _burn(account, amount);
749     }
750 }
751 
752 /**
753  * @title SafeERC20
754  * @dev Wrappers around ERC20 operations that throw on failure (when the token
755  * contract returns false). Tokens that return no value (and instead revert or
756  * throw on failure) are also supported, non-reverting calls are assumed to be
757  * successful.
758  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
759  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
760  */
761 library SafeERC20 {
762     using SafeMath for uint256;
763     using Address for address;
764 
765     function safeTransfer(IERC20 token, address to, uint256 value) internal {
766         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
767     }
768 
769     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
770         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
771     }
772 
773     /**
774      * @dev Deprecated. This function has issues similar to the ones found in
775      * {IERC20-approve}, and its usage is discouraged.
776      *
777      * Whenever possible, use {safeIncreaseAllowance} and
778      * {safeDecreaseAllowance} instead.
779      */
780     function safeApprove(IERC20 token, address spender, uint256 value) internal {
781         // safeApprove should only be called when setting an initial allowance,
782         // or when resetting it to zero. To increase and decrease it, use
783         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
784         // solhint-disable-next-line max-line-length
785         require((value == 0) || (token.allowance(address(this), spender) == 0),
786             "SafeERC20: approve from non-zero to non-zero allowance"
787         );
788         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
789     }
790 
791     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
792         uint256 newAllowance = token.allowance(address(this), spender).add(value);
793         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
794     }
795 
796     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
797         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
798         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
799     }
800 
801     /**
802      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
803      * on the return value: the return value is optional (but if data is returned, it must not be false).
804      * @param token The token targeted by the call.
805      * @param data The call data (encoded using abi.encode or one of its variants).
806      */
807     function _callOptionalReturn(IERC20 token, bytes memory data) private {
808         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
809         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
810         // the target address contains contract code and also asserts for success in the low-level call.
811 
812         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
813         if (returndata.length > 0) { // Return data is optional
814             // solhint-disable-next-line max-line-length
815             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
816         }
817     }
818 }
819 
820 /**
821  * @dev Contract module which provides a basic access control mechanism, where
822  * there is an account (an owner) that can be granted exclusive access to
823  * specific functions.
824  *
825  * By default, the owner account will be the one that deploys the contract. This
826  * can later be changed with {transferOwnership}.
827  *
828  * This module is used through inheritance. It will make available the modifier
829  * `onlyOwner`, which can be applied to your functions to restrict their use to
830  * the owner.
831  */
832 abstract contract Ownable is Context {
833     address private _owner;
834 
835     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
836 
837     /**
838      * @dev Initializes the contract setting the deployer as the initial owner.
839      */
840     constructor () internal {
841         address msgSender = _msgSender();
842         _owner = msgSender;
843         emit OwnershipTransferred(address(0), msgSender);
844     }
845 
846     /**
847      * @dev Returns the address of the current owner.
848      */
849     function owner() public view returns (address) {
850         return _owner;
851     }
852 
853     /**
854      * @dev Throws if called by any account other than the owner.
855      */
856     modifier onlyOwner() {
857         require(_owner == _msgSender(), "Ownable: caller is not the owner");
858         _;
859     }
860 
861     /**
862      * @dev Leaves the contract without owner. It will not be possible to call
863      * `onlyOwner` functions anymore. Can only be called by the current owner.
864      *
865      * NOTE: Renouncing ownership will leave the contract without an owner,
866      * thereby removing any functionality that is only available to the owner.
867      */
868     function renounceOwnership() public virtual onlyOwner {
869         emit OwnershipTransferred(_owner, address(0));
870         _owner = address(0);
871     }
872 
873     /**
874      * @dev Transfers ownership of the contract to a new account (`newOwner`).
875      * Can only be called by the current owner.
876      */
877     function transferOwnership(address newOwner) public virtual onlyOwner {
878         require(newOwner != address(0), "Ownable: new owner is the zero address");
879         emit OwnershipTransferred(_owner, newOwner);
880         _owner = newOwner;
881     }
882 }
883 
884 
885 /**
886  * @dev Contract module that helps prevent reentrant calls to a function.
887  *
888  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
889  * available, which can be applied to functions to make sure there are no nested
890  * (reentrant) calls to them.
891  *
892  * Note that because there is a single `nonReentrant` guard, functions marked as
893  * `nonReentrant` may not call one another. This can be worked around by making
894  * those functions `private`, and then adding `external` `nonReentrant` entry
895  * points to them.
896  *
897  * TIP: If you would like to learn more about reentrancy and alternative ways
898  * to protect against it, check out our blog post
899  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
900  */
901 abstract contract ReentrancyGuard {
902     // Booleans are more expensive than uint256 or any type that takes up a full
903     // word because each write operation emits an extra SLOAD to first read the
904     // slot's contents, replace the bits taken up by the boolean, and then write
905     // back. This is the compiler's defense against contract upgrades and
906     // pointer aliasing, and it cannot be disabled.
907 
908     // The values being non-zero value makes deployment a bit more expensive,
909     // but in exchange the refund on every call to nonReentrant will be lower in
910     // amount. Since refunds are capped to a percentage of the total
911     // transaction's gas, it is best to keep them low in cases like this one, to
912     // increase the likelihood of the full refund coming into effect.
913     uint256 private constant _NOT_ENTERED = 1;
914     uint256 private constant _ENTERED = 2;
915 
916     uint256 private _status;
917 
918     constructor () internal {
919         _status = _NOT_ENTERED;
920     }
921 
922     /**
923      * @dev Prevents a contract from calling itself, directly or indirectly.
924      * Calling a `nonReentrant` function from another `nonReentrant`
925      * function is not supported. It is possible to prevent this from happening
926      * by making the `nonReentrant` function external, and make it call a
927      * `private` function that does the actual work.
928      */
929     modifier nonReentrant() {
930         // On the first call to nonReentrant, _notEntered will be true
931         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
932 
933         // Any calls to nonReentrant after this point will fail
934         _status = _ENTERED;
935 
936         _;
937 
938         // By storing the original value once again, a refund is triggered (see
939         // https://eips.ethereum.org/EIPS/eip-2200)
940         _status = _NOT_ENTERED;
941     }
942 }
943 
944 contract DuckTiers is Ownable, ReentrancyGuard {
945 
946 	using SafeMath for uint;
947 
948 	struct UserInfo {
949 		uint staked;
950 		uint stakedTime;
951 	}
952 
953 	uint constant MAX_NUM_TIERS = 10;
954 	uint8 currentMaxTier = 4;
955 
956 	mapping(address => UserInfo) public userInfo;
957 	uint[MAX_NUM_TIERS] tierPrice;
958 
959 	uint[] public withdrawFeePercent;
960 	ERC20Burnable public DUCK;
961 
962 	bool public canEmergencyWithdraw;
963 
964 	event Staked(address indexed user, uint amount);
965 	event Withdrawn(address indexed user, uint indexed amount, uint fee);
966 	event EmergencyWithdrawn(address indexed user, uint amount);
967 
968 	constructor(address _duckTokenAddress) public {
969 		DUCK = ERC20Burnable(_duckTokenAddress);
970 
971 		tierPrice[1] = 2000e18;
972 		tierPrice[2] = 5000e18;
973 		tierPrice[3] = 10000e18;
974 		tierPrice[4] = 20000e18;
975 
976 		withdrawFeePercent.push(30);
977 		withdrawFeePercent.push(25);
978 		withdrawFeePercent.push(20);
979 		withdrawFeePercent.push(10);
980 		withdrawFeePercent.push(5);
981 		withdrawFeePercent.push(0);
982 	}
983 
984 	function deposit(uint _amount) external nonReentrant() {
985 		DUCK.transferFrom(msg.sender, address(this), _amount);
986 
987 		userInfo[msg.sender].staked = userInfo[msg.sender].staked.add(_amount);
988 		userInfo[msg.sender].stakedTime = block.timestamp;
989 
990 		emit Staked(msg.sender, _amount);
991 	}
992 
993 	function withdraw(uint _amount) external nonReentrant() {
994 		UserInfo storage user = userInfo[msg.sender];
995 		require(user.staked >= _amount, "not enough amount to withdraw");
996 
997 		uint toBurn = calculateWithdrawFee(msg.sender, _amount);
998 		user.staked = user.staked.sub(_amount);
999 
1000 		if(toBurn > 0) {
1001 			DUCK.burn(toBurn);
1002 		}
1003 
1004 		DUCK.transfer(msg.sender, _amount.sub(toBurn));
1005 		emit Withdrawn(msg.sender, _amount, toBurn);
1006 	}
1007 
1008 	function updateEmergencyWithdrawStatus(bool _status) external onlyOwner {
1009 		canEmergencyWithdraw = _status;
1010 	}
1011 
1012 	function emergencyWithdraw() external {
1013 		require(canEmergencyWithdraw, "function disabled");
1014 		UserInfo storage user = userInfo[msg.sender];
1015 		require(user.staked > 0, "nothing to withdraw");
1016 
1017 		uint _amount = user.staked;
1018 		user.staked = 0;
1019 
1020 		DUCK.transfer(msg.sender, _amount);
1021 		emit EmergencyWithdrawn(msg.sender, _amount);
1022 	}
1023 
1024 	function updateTier(uint8 _tierId, uint _amount) external onlyOwner {
1025 		require(_tierId > 0 && _tierId <= MAX_NUM_TIERS, "invalid _tierId");
1026 		tierPrice[_tierId] = _amount;
1027 		if (_tierId > currentMaxTier) {
1028 			currentMaxTier = _tierId;
1029 		}
1030 	}
1031 
1032 	function updateWithdrawFee(uint _key, uint _percent) external onlyOwner {
1033 		require(_percent < 100, "too high percent");
1034 		withdrawFeePercent[_key] = _percent;
1035 	}
1036 
1037 	function getUserTier(address _userAddress) external view returns(uint8 res) {
1038 		for(uint8 i = 1; i <= MAX_NUM_TIERS; i++) {
1039 			if(tierPrice[i] == 0 || userInfo[_userAddress].staked < tierPrice[i]) {
1040 				return res;
1041 			}
1042 
1043 			res = i;
1044 		}
1045 	}
1046 
1047 	function calculateWithdrawFee(address _userAddress, uint _amount) public view returns(uint) {
1048 		UserInfo storage user = userInfo[_userAddress];
1049 		require(user.staked >= _amount, "not enough amount to withdraw");
1050 
1051 		if(block.timestamp < user.stakedTime.add(10 days)) {
1052 			return _amount.mul(withdrawFeePercent[0]).div(100); //30%
1053 		}
1054 
1055 		if(block.timestamp < user.stakedTime.add(20 days)) {
1056 			return _amount.mul(withdrawFeePercent[1]).div(100); //25%
1057 		}
1058 
1059 		if(block.timestamp < user.stakedTime.add(30 days)) {
1060 			return _amount.mul(withdrawFeePercent[2]).div(100); //20%
1061 		}
1062 
1063 		if(block.timestamp < user.stakedTime.add(60 days)) {
1064 			return _amount.mul(withdrawFeePercent[3]).div(100); //10%
1065 		}
1066 
1067 		if(block.timestamp < user.stakedTime.add(90 days)) {
1068 			return _amount.mul(withdrawFeePercent[4]).div(100); //5%
1069 		}
1070 
1071 		return _amount.mul(withdrawFeePercent[5]).div(100);
1072 	}
1073 
1074 	//frontend func
1075 	function getTiers() external view returns(uint[MAX_NUM_TIERS] memory buf) {
1076 		for(uint8 i = 1; i < MAX_NUM_TIERS; i++) {
1077 			if(tierPrice[i] == 0) {
1078 				return buf;
1079 			}
1080 			buf[i-1] = tierPrice[i];
1081 		}
1082 
1083 		return buf;
1084 	}
1085 }