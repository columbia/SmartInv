1 pragma solidity 0.6.12;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /*
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with GSN meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address payable) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes memory) {
94         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
95         return msg.data;
96     }
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
277         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
278         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
279         // for accounts without code, i.e. `keccak256('')`
280         bytes32 codehash;
281         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
282         // solhint-disable-next-line no-inline-assembly
283         assembly { codehash := extcodehash(account) }
284         return (codehash != accountHash && codehash != 0x0);
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
340         return _functionCallWithValue(target, data, 0, errorMessage);
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
366         return _functionCallWithValue(target, data, value, errorMessage);
367     }
368 
369     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
370         require(isContract(target), "Address: call to non-contract");
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 // solhint-disable-next-line no-inline-assembly
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 /**
394  * @dev Implementation of the {IERC20} interface.
395  *
396  * This implementation is agnostic to the way tokens are created. This means
397  * that a supply mechanism has to be added in a derived contract using {_mint}.
398  * For a generic mechanism see {ERC20PresetMinterPauser}.
399  *
400  * TIP: For a detailed writeup see our guide
401  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
402  * to implement supply mechanisms].
403  *
404  * We have followed general OpenZeppelin guidelines: functions revert instead
405  * of returning `false` on failure. This behavior is nonetheless conventional
406  * and does not conflict with the expectations of ERC20 applications.
407  *
408  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
409  * This allows applications to reconstruct the allowance for all accounts just
410  * by listening to said events. Other implementations of the EIP may not emit
411  * these events, as it isn't required by the specification.
412  *
413  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
414  * functions have been added to mitigate the well-known issues around setting
415  * allowances. See {IERC20-approve}.
416  */
417 contract ERC20 is Context, IERC20 {
418     using SafeMath for uint256;
419     using Address for address;
420 
421     mapping (address => uint256) private _balances;
422 
423     mapping (address => mapping (address => uint256)) private _allowances;
424 
425     uint256 private _totalSupply;
426 
427     string private _name;
428     string private _symbol;
429     uint8 private _decimals;
430 
431     /**
432      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
433      * a default value of 18.
434      *
435      * To select a different value for {decimals}, use {_setupDecimals}.
436      *
437      * All three of these values are immutable: they can only be set once during
438      * construction.
439      */
440     constructor (string memory name, string memory symbol) public {
441         _name = name;
442         _symbol = symbol;
443         _decimals = 18;
444     }
445 
446     /**
447      * @dev Returns the name of the token.
448      */
449     function name() public view returns (string memory) {
450         return _name;
451     }
452 
453     /**
454      * @dev Returns the symbol of the token, usually a shorter version of the
455      * name.
456      */
457     function symbol() public view returns (string memory) {
458         return _symbol;
459     }
460 
461     /**
462      * @dev Returns the number of decimals used to get its user representation.
463      * For example, if `decimals` equals `2`, a balance of `505` tokens should
464      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
465      *
466      * Tokens usually opt for a value of 18, imitating the relationship between
467      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
468      * called.
469      *
470      * NOTE: This information is only used for _display_ purposes: it in
471      * no way affects any of the arithmetic of the contract, including
472      * {IERC20-balanceOf} and {IERC20-transfer}.
473      */
474     function decimals() public view returns (uint8) {
475         return _decimals;
476     }
477 
478     /**
479      * @dev See {IERC20-totalSupply}.
480      */
481     function totalSupply() public view override returns (uint256) {
482         return _totalSupply;
483     }
484 
485     /**
486      * @dev See {IERC20-balanceOf}.
487      */
488     function balanceOf(address account) public view override returns (uint256) {
489         return _balances[account];
490     }
491 
492     /**
493      * @dev See {IERC20-transfer}.
494      *
495      * Requirements:
496      *
497      * - `recipient` cannot be the zero address.
498      * - the caller must have a balance of at least `amount`.
499      */
500     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
501         _transfer(_msgSender(), recipient, amount);
502         return true;
503     }
504 
505     /**
506      * @dev See {IERC20-allowance}.
507      */
508     function allowance(address owner, address spender) public view virtual override returns (uint256) {
509         return _allowances[owner][spender];
510     }
511 
512     /**
513      * @dev See {IERC20-approve}.
514      *
515      * Requirements:
516      *
517      * - `spender` cannot be the zero address.
518      */
519     function approve(address spender, uint256 amount) public virtual override returns (bool) {
520         _approve(_msgSender(), spender, amount);
521         return true;
522     }
523 
524     /**
525      * @dev See {IERC20-transferFrom}.
526      *
527      * Emits an {Approval} event indicating the updated allowance. This is not
528      * required by the EIP. See the note at the beginning of {ERC20};
529      *
530      * Requirements:
531      * - `sender` and `recipient` cannot be the zero address.
532      * - `sender` must have a balance of at least `amount`.
533      * - the caller must have allowance for ``sender``'s tokens of at least
534      * `amount`.
535      */
536     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
537         _transfer(sender, recipient, amount);
538         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
539         return true;
540     }
541 
542     /**
543      * @dev Atomically increases the allowance granted to `spender` by the caller.
544      *
545      * This is an alternative to {approve} that can be used as a mitigation for
546      * problems described in {IERC20-approve}.
547      *
548      * Emits an {Approval} event indicating the updated allowance.
549      *
550      * Requirements:
551      *
552      * - `spender` cannot be the zero address.
553      */
554     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
555         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
556         return true;
557     }
558 
559     /**
560      * @dev Atomically decreases the allowance granted to `spender` by the caller.
561      *
562      * This is an alternative to {approve} that can be used as a mitigation for
563      * problems described in {IERC20-approve}.
564      *
565      * Emits an {Approval} event indicating the updated allowance.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      * - `spender` must have allowance for the caller of at least
571      * `subtractedValue`.
572      */
573     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
575         return true;
576     }
577 
578     /**
579      * @dev Moves tokens `amount` from `sender` to `recipient`.
580      *
581      * This is internal function is equivalent to {transfer}, and can be used to
582      * e.g. implement automatic token fees, slashing mechanisms, etc.
583      *
584      * Emits a {Transfer} event.
585      *
586      * Requirements:
587      *
588      * - `sender` cannot be the zero address.
589      * - `recipient` cannot be the zero address.
590      * - `sender` must have a balance of at least `amount`.
591      */
592     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
593         require(sender != address(0), "ERC20: transfer from the zero address");
594         require(recipient != address(0), "ERC20: transfer to the zero address");
595 
596         _beforeTokenTransfer(sender, recipient, amount);
597 
598         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
599         _balances[recipient] = _balances[recipient].add(amount);
600         emit Transfer(sender, recipient, amount);
601     }
602 
603     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
604      * the total supply.
605      *
606      * Emits a {Transfer} event with `from` set to the zero address.
607      *
608      * Requirements
609      *
610      * - `to` cannot be the zero address.
611      */
612     function _mint(address account, uint256 amount) internal virtual {
613         require(account != address(0), "ERC20: mint to the zero address");
614 
615         _beforeTokenTransfer(address(0), account, amount);
616 
617         _totalSupply = _totalSupply.add(amount);
618         _balances[account] = _balances[account].add(amount);
619         emit Transfer(address(0), account, amount);
620     }
621 
622     /**
623      * @dev Destroys `amount` tokens from `account`, reducing the
624      * total supply.
625      *
626      * Emits a {Transfer} event with `to` set to the zero address.
627      *
628      * Requirements
629      *
630      * - `account` cannot be the zero address.
631      * - `account` must have at least `amount` tokens.
632      */
633     function _burn(address account, uint256 amount) internal virtual {
634         require(account != address(0), "ERC20: burn from the zero address");
635 
636         _beforeTokenTransfer(account, address(0), amount);
637 
638         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
639         _totalSupply = _totalSupply.sub(amount);
640         emit Transfer(account, address(0), amount);
641     }
642 
643     /**
644      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
645      *
646      * This is internal function is equivalent to `approve`, and can be used to
647      * e.g. set automatic allowances for certain subsystems, etc.
648      *
649      * Emits an {Approval} event.
650      *
651      * Requirements:
652      *
653      * - `owner` cannot be the zero address.
654      * - `spender` cannot be the zero address.
655      */
656     function _approve(address owner, address spender, uint256 amount) internal virtual {
657         require(owner != address(0), "ERC20: approve from the zero address");
658         require(spender != address(0), "ERC20: approve to the zero address");
659 
660         _allowances[owner][spender] = amount;
661         emit Approval(owner, spender, amount);
662     }
663 
664     /**
665      * @dev Sets {decimals} to a value other than the default one of 18.
666      *
667      * WARNING: This function should only be called from the constructor. Most
668      * applications that interact with token contracts will not expect
669      * {decimals} to ever change, and may work incorrectly if it does.
670      */
671     function _setupDecimals(uint8 decimals_) internal {
672         _decimals = decimals_;
673     }
674 
675     /**
676      * @dev Hook that is called before any transfer of tokens. This includes
677      * minting and burning.
678      *
679      * Calling conditions:
680      *
681      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
682      * will be to transferred to `to`.
683      * - when `from` is zero, `amount` tokens will be minted for `to`.
684      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
685      * - `from` and `to` are never both zero.
686      *
687      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
688      */
689     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
690 }
691 
692 /**
693  * @title SafeERC20
694  * @dev Wrappers around ERC20 operations that throw on failure (when the token
695  * contract returns false). Tokens that return no value (and instead revert or
696  * throw on failure) are also supported, non-reverting calls are assumed to be
697  * successful.
698  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
699  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
700  */
701 library SafeERC20 {
702     using SafeMath for uint256;
703     using Address for address;
704 
705     function safeTransfer(IERC20 token, address to, uint256 value) internal {
706         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
707     }
708 
709     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
710         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
711     }
712 
713     /**
714      * @dev Deprecated. This function has issues similar to the ones found in
715      * {IERC20-approve}, and its usage is discouraged.
716      *
717      * Whenever possible, use {safeIncreaseAllowance} and
718      * {safeDecreaseAllowance} instead.
719      */
720     function safeApprove(IERC20 token, address spender, uint256 value) internal {
721         // safeApprove should only be called when setting an initial allowance,
722         // or when resetting it to zero. To increase and decrease it, use
723         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
724         // solhint-disable-next-line max-line-length
725         require((value == 0) || (token.allowance(address(this), spender) == 0),
726             "SafeERC20: approve from non-zero to non-zero allowance"
727         );
728         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
729     }
730 
731     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
732         uint256 newAllowance = token.allowance(address(this), spender).add(value);
733         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
734     }
735 
736     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
737         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
738         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
739     }
740 
741     /**
742      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
743      * on the return value: the return value is optional (but if data is returned, it must not be false).
744      * @param token The token targeted by the call.
745      * @param data The call data (encoded using abi.encode or one of its variants).
746      */
747     function _callOptionalReturn(IERC20 token, bytes memory data) private {
748         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
749         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
750         // the target address contains contract code and also asserts for success in the low-level call.
751 
752         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
753         if (returndata.length > 0) { // Return data is optional
754             // solhint-disable-next-line max-line-length
755             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
756         }
757     }
758 }
759 
760 /**
761  * @dev Contract module that helps prevent reentrant calls to a function.
762  *
763  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
764  * available, which can be aplied to functions to make sure there are no nested
765  * (reentrant) calls to them.
766  *
767  * Note that because there is a single `nonReentrant` guard, functions marked as
768  * `nonReentrant` may not call one another. This can be worked around by making
769  * those functions `private`, and then adding `external` `nonReentrant` entry
770  * points to them.
771  */
772 contract ReentrancyGuard {
773     /// @dev counter to allow mutex lock with only one SSTORE operation
774     uint256 private _guardCounter;
775 
776     constructor () internal {
777         // The counter starts at one to prevent changing it from zero to a non-zero
778         // value, which is a more expensive operation.
779         _guardCounter = 1;
780     }
781 
782     /**
783      * @dev Prevents a contract from calling itself, directly or indirectly.
784      * Calling a `nonReentrant` function from another `nonReentrant`
785      * function is not supported. It is possible to prevent this from happening
786      * by making the `nonReentrant` function external, and make it call a
787      * `private` function that does the actual work.
788      */
789     modifier nonReentrant() {
790         _guardCounter += 1;
791         uint256 localCounter = _guardCounter;
792         _;
793         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
794     }
795 }
796 
797 interface IController {
798     function withdraw(address, uint) external;
799     function balanceOf(address) external view returns (uint);
800     function farm(address, uint) external;
801     function harvest(address) external;
802 }
803 
804 interface ITokenMaster {
805     function tokenToPid(address _poolToken) external view returns (uint);
806     function userBalanceForPool(address _user, address _poolToken) external view returns (uint);
807 }
808 
809 // Forked from the original yearn yVault (https://github.com/yearn/yearn-protocol/blob/develop/contracts/vaults/yVault.sol) with the following changes:
810 // - Introduce reward token of which the user can claim from the underlying strategy
811 // - Keeper fees for farm and harvest
812 // - Overriding transfer function to avoid reward token accumulation in TokenMaster (e.g when user stake Vault token into TokenMaster)
813 abstract contract BaseVault is ERC20, ReentrancyGuard {
814   using SafeERC20 for IERC20;
815   using Address for address;
816   using SafeMath for uint256;
817 
818   /* ========== STATE VARIABLES ========== */
819 
820   IERC20 public token;
821   IERC20 public rewardToken;
822 
823   uint public availableMin = 9500;
824   uint public farmKeeperFeeMin = 0;
825   uint public harvestKeeperFeeMin = 0;
826   uint public constant MAX = 10000;
827 
828   uint public rewardsPerShareStored;
829   mapping(address => uint256) public userRewardPerSharePaid;
830   mapping(address => uint256) public rewards;
831 
832   address public governance;
833   address public controller;
834   address public tokenMaster;
835   mapping(address => bool) public keepers;
836 
837   /* ========== CONSTRUCTOR ========== */
838 
839   constructor (
840       address _token,
841       address _rewardToken,
842       address _controller,
843       address _tokenMaster)
844       public
845       ERC20 (
846         string(abi.encodePacked("aladdin ", ERC20(_token).name())),
847         string(abi.encodePacked("ald", ERC20(_token).symbol())
848       )
849   ) {
850       _setupDecimals(ERC20(_token).decimals());
851       token = IERC20(_token);
852       rewardToken = IERC20(_rewardToken);
853       controller = _controller;
854       governance = msg.sender;
855       tokenMaster = _tokenMaster;
856   }
857 
858   /* ========== VIEWS ========== */
859 
860   function balance() public view returns (uint) {
861       return token.balanceOf(address(this))
862              .add(IController(controller).balanceOf(address(this)));
863   }
864 
865   // Custom logic in here for how much the vault allows to be borrowed
866   // Sets minimum required on-hand to keep small withdrawals cheap
867   function available() public view returns (uint) {
868       return token.balanceOf(address(this)).mul(availableMin).div(MAX);
869   }
870 
871   function getPricePerFullShare() public view returns (uint) {
872       return balance().mul(1e18).div(totalSupply());
873   }
874 
875   // amount staked in token master
876   function stakedBalanceOf(address _user) public view returns(uint) {
877       return ITokenMaster(tokenMaster).userBalanceForPool(_user, address(this));
878   }
879 
880   function earned(address account) public view returns (uint) {
881       uint256 totalBalance = balanceOf(account).add(stakedBalanceOf(account));
882       return totalBalance.mul(rewardsPerShareStored.sub(userRewardPerSharePaid[account])).div(1e18).add(rewards[account]);
883   }
884 
885   /* ========== USER MUTATIVE FUNCTIONS ========== */
886 
887   function deposit(uint _amount) external nonReentrant {
888       _updateReward(msg.sender);
889 
890       uint _pool = balance();
891       token.safeTransferFrom(msg.sender, address(this), _amount);
892 
893       uint shares = 0;
894       if (totalSupply() == 0) {
895         shares = _amount;
896       } else {
897         shares = (_amount.mul(totalSupply())).div(_pool);
898       }
899       _mint(msg.sender, shares);
900       emit Deposit(msg.sender, _amount);
901   }
902 
903   // No rebalance implementation for lower fees and faster swaps
904   function withdraw(uint _shares) public nonReentrant {
905       _updateReward(msg.sender);
906 
907       uint r = (balance().mul(_shares)).div(totalSupply());
908       _burn(msg.sender, _shares);
909 
910       // Check balance
911       uint b = token.balanceOf(address(this));
912       if (b < r) {
913           uint _withdraw = r.sub(b);
914           IController(controller).withdraw(address(this), _withdraw);
915           uint _after = token.balanceOf(address(this));
916           uint _diff = _after.sub(b);
917           if (_diff < _withdraw) {
918               r = b.add(_diff);
919           }
920       }
921 
922       token.safeTransfer(msg.sender, r);
923       emit Withdraw(msg.sender, r);
924   }
925 
926   function claim() public {
927       _updateReward(msg.sender);
928 
929       uint reward = rewards[msg.sender];
930       if (reward > 0) {
931           rewards[msg.sender] = 0;
932           rewardToken.safeTransfer(msg.sender, reward);
933       }
934       emit Claim(msg.sender, reward);
935   }
936 
937   function exit() external {
938       withdraw(balanceOf(msg.sender));
939       claim();
940   }
941 
942   // Override underlying transfer function to update reward before transfer, except on staking/withdraw to token master
943   function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override
944   {
945       if (to != tokenMaster && from != tokenMaster) {
946           _updateReward(from);
947           _updateReward(to);
948       }
949 
950       super._beforeTokenTransfer(from, to, amount);
951   }
952 
953   /* ========== KEEPER MUTATIVE FUNCTIONS ========== */
954 
955   // Keepers call farm() to send funds to strategy
956   function farm() external onlyKeeper {
957       uint _bal = available();
958 
959       uint keeperFee = _bal.mul(farmKeeperFeeMin).div(MAX);
960       if (keeperFee > 0) {
961           token.safeTransfer(msg.sender, keeperFee);
962       }
963 
964       uint amountLessFee = _bal.sub(keeperFee);
965       token.safeTransfer(controller, amountLessFee);
966       IController(controller).farm(address(this), amountLessFee);
967 
968       emit Farm(msg.sender, keeperFee, amountLessFee);
969   }
970 
971   // Keepers call harvest() to claim rewards from strategy
972   // harvest() is marked as onlyEOA to prevent sandwich/MEV attack to collect most rewards through a flash-deposit() follow by a claim
973   function harvest() external onlyKeeper {
974       uint _rewardBefore = rewardToken.balanceOf(address(this));
975       IController(controller).harvest(address(this));
976       uint _rewardAfter = rewardToken.balanceOf(address(this));
977 
978       uint harvested = _rewardAfter.sub(_rewardBefore);
979       uint keeperFee = harvested.mul(harvestKeeperFeeMin).div(MAX);
980       if (keeperFee > 0) {
981           rewardToken.safeTransfer(msg.sender, keeperFee);
982       }
983 
984       uint newRewardAmount = harvested.sub(keeperFee);
985       // distribute new rewards to current shares evenly
986       rewardsPerShareStored = rewardsPerShareStored.add(newRewardAmount.mul(1e18).div(totalSupply()));
987 
988       emit Harvest(msg.sender, keeperFee, newRewardAmount);
989   }
990 
991   /* ========== INTERNAL FUNCTIONS ========== */
992 
993   function _updateReward(address account) internal {
994       rewards[account] = earned(account);
995       userRewardPerSharePaid[account] = rewardsPerShareStored;
996   }
997 
998   /* ========== RESTRICTED FUNCTIONS ========== */
999 
1000   function setAvailableMin(uint _availableMin) external {
1001       require(msg.sender == governance, "!governance");
1002       require(_availableMin < MAX, "over MAX");
1003       availableMin = _availableMin;
1004   }
1005 
1006   function setFarmKeeperFeeMin(uint _farmKeeperFeeMin) external {
1007       require(msg.sender == governance, "!governance");
1008       require(_farmKeeperFeeMin < MAX, "over MAX");
1009       farmKeeperFeeMin = _farmKeeperFeeMin;
1010   }
1011 
1012   function setHarvestKeeperFeeMin(uint _harvestKeeperFeeMin) external {
1013       require(msg.sender == governance, "!governance");
1014       require(_harvestKeeperFeeMin < MAX, "over MAX");
1015       harvestKeeperFeeMin = _harvestKeeperFeeMin;
1016   }
1017 
1018   function setGovernance(address _governance) external {
1019       require(msg.sender == governance, "!governance");
1020       governance = _governance;
1021   }
1022 
1023   function setController(address _controller) external {
1024       require(msg.sender == governance, "!governance");
1025       controller = _controller;
1026   }
1027 
1028   function setTokenMaster(address _tokenMaster) external {
1029       require(msg.sender == governance, "!governance");
1030       tokenMaster = _tokenMaster;
1031   }
1032 
1033   function addKeeper(address _address) external {
1034       require(msg.sender == governance, "!governance");
1035       keepers[_address] = true;
1036   }
1037 
1038   function removeKeeper(address _address) external {
1039       require(msg.sender == governance, "!governance");
1040       keepers[_address] = false;
1041   }
1042 
1043   /* ========== MODIFIERS ========== */
1044 
1045   modifier onlyKeeper() {
1046       require(keepers[msg.sender] == true, "!keeper");
1047        _;
1048   }
1049 
1050   /* ========== EVENTS ========== */
1051 
1052   event Deposit(address indexed user, uint256 amount);
1053   event Withdraw(address indexed user, uint256 amount);
1054   event Claim(address indexed user, uint256 amount);
1055   event Farm(address indexed keeper, uint256 keeperFee, uint256 farmedAmount);
1056   event Harvest(address indexed keeper, uint256 keeperFee, uint256 harvestedAmount);
1057 }
1058 
1059 contract VaultCurveRenWBTC is BaseVault {
1060     constructor (
1061           address _controller,
1062           address _tokenMaster)
1063         public
1064         BaseVault(
1065           address(0x49849C98ae39Fff122806C06791Fa73784FB3675), // crvRenWBTC
1066           address(0xD533a949740bb3306d119CC777fa900bA034cd52), // crv
1067           _controller,
1068           _tokenMaster
1069         )
1070     {}
1071 }