1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
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
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
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
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address payable) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes memory) {
176         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
177         return msg.data;
178     }
179 }
180 
181 /**
182  * @dev Interface of the ERC20 standard as defined in the EIP.
183  */
184 interface IERC20 {
185     /**
186      * @dev Returns the amount of tokens in existence.
187      */
188     function totalSupply() external view returns (uint256);
189 
190     /**
191      * @dev Returns the amount of tokens owned by `account`.
192      */
193     function balanceOf(address account) external view returns (uint256);
194 
195     /**
196      * @dev Moves `amount` tokens from the caller's account to `recipient`.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transfer(address recipient, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Returns the remaining number of tokens that `spender` will be
206      * allowed to spend on behalf of `owner` through {transferFrom}. This is
207      * zero by default.
208      *
209      * This value changes when {approve} or {transferFrom} are called.
210      */
211     function allowance(address owner, address spender) external view returns (uint256);
212 
213     /**
214      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * IMPORTANT: Beware that changing an allowance with this method brings the risk
219      * that someone may use both the old and the new allowance by unfortunate
220      * transaction ordering. One possible solution to mitigate this race
221      * condition is to first reduce the spender's allowance to 0 and set the
222      * desired value afterwards:
223      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224      *
225      * Emits an {Approval} event.
226      */
227     function approve(address spender, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Moves `amount` tokens from `sender` to `recipient` using the
231      * allowance mechanism. `amount` is then deducted from the caller's
232      * allowance.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Emitted when `value` tokens are moved from one account (`from`) to
242      * another (`to`).
243      *
244      * Note that `value` may be zero.
245      */
246     event Transfer(address indexed from, address indexed to, uint256 value);
247 
248     /**
249      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
250      * a call to {approve}. `value` is the new allowance.
251      */
252     event Approval(address indexed owner, address indexed spender, uint256 value);
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
277         // This method relies in extcodesize, which returns 0 for contracts in
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
330         return functionCall(target, data, "Address: low-level call failed");
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
644      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
645      *
646      * This internal function is equivalent to `approve`, and can be used to
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
760 interface IAdmin {
761     function admin() external view returns (address);
762 }
763 
764 interface IUNIStakingRewards {
765     function stake(uint amount) external;
766     function withdraw(uint amount) external;
767     function getReward() external;
768     function rewardPerToken() external view returns (uint);
769     function rewardPerTokenStored() external view returns (uint);
770     function earned(address account) external view returns (uint);
771     function userRewardPerTokenPaid(address) external view returns (uint);
772     function rewards(address) external view returns (uint);
773     function balanceOf(address account) external view returns (uint);
774 }
775 
776 contract ZETA is ERC20 {
777     using SafeMath for uint;
778     using SafeERC20 for IERC20;
779 
780     uint public tokenPerBlock;
781     uint public tokenPerBlockAdmin;
782 
783     uint public BONUS_MULTIPLIER;
784 
785     uint public startBlock;
786     uint public bonusEndBlock;
787     uint public endBlock;
788 
789     uint public adminClaimRewardEndBlock;
790     uint public lastClaimBlockAdmin;
791 
792     uint public totalPoolWeight;
793 
794     IAdmin public admin;
795 
796     poolInfo[] public rewardPools;
797     address public UNIAddress;
798     address public adminReceiveAddress;
799 
800     struct userInfo {
801         uint lastClaimAmount;
802         uint depositAmount;
803         uint rewardsUni;
804         uint userRewardPerTokenPaidUni;
805     }
806 
807     struct poolInfo {
808         address addrToken;
809         address addrUniStakingRewards;
810         uint rewardRate;
811         uint lastUpdateBlock;
812         uint totalBalance;
813         uint poolWeight;
814         uint totalRewardsUni;
815     }
816 
817 
818     mapping (address => mapping (uint => userInfo)) public userInfos;
819 
820     event NewRewardPool(address rewardPool);
821     event Deposit(address indexed account, uint indexed idx, uint amount);
822     event Withdrawal(address indexed account, uint indexed idx, uint amount);
823     event ClaimReward(address indexed account, uint indexed idx, uint amount);
824 
825     constructor (
826         address adminAddress,
827         address _adminReceiveAddress,
828         address reserveContractAddress,
829         address YFIInspirdropAddress,
830         address uniAddress,
831         uint _tokenPerBlock,
832         uint _startBlock,
833         uint _bonusEndBlock,
834         uint _endBlock,
835         uint _adminEndBlock,
836         uint initialReserveAmount,
837         uint yfiAirdropAmount,
838         uint _tokenPerBlockAdmin,
839         uint _bonus_multiplier
840     ) ERC20("ZETA", "ZETA") public {
841         tokenPerBlock = _tokenPerBlock;
842         startBlock = _startBlock;
843         bonusEndBlock = _bonusEndBlock;
844         endBlock = _endBlock;
845         adminClaimRewardEndBlock = _adminEndBlock;
846         tokenPerBlockAdmin = _tokenPerBlockAdmin;
847         BONUS_MULTIPLIER = _bonus_multiplier;
848 
849         lastClaimBlockAdmin = startBlock;
850 
851         admin = IAdmin(adminAddress);
852         adminReceiveAddress = _adminReceiveAddress;
853         _mint(reserveContractAddress, initialReserveAmount);
854         _mint(YFIInspirdropAddress, yfiAirdropAmount);
855         UNIAddress = uniAddress;
856     }
857 
858     function setAdminReceiveAddress(address addr) public {
859         require(msg.sender == admin.admin(), "Not admin");
860         adminReceiveAddress = addr;
861     }
862 
863     function addRewardPool(address addrToken, address addrUniStakingRewards, uint poolWeight) public {
864         require(msg.sender == admin.admin(), "Not admin");
865         for (uint i = 0; i < rewardPools.length; i++) {
866             updatePool(i);
867         }
868         rewardPools.push(
869             poolInfo(
870                 addrToken,
871                 addrUniStakingRewards,
872                 0,
873                 startBlock > block.number ? startBlock : block.number,
874                 0,
875                 poolWeight,
876                 0
877             )
878         );
879         totalPoolWeight = totalPoolWeight.add(poolWeight);
880         emit NewRewardPool(addrToken);
881     }
882 
883     function setPoolWeight(uint idx, uint poolWeight) public {
884         require(msg.sender == admin.admin(), "Not admin");
885         for (uint i = 0; i < rewardPools.length; i++) {
886             updatePool(i);
887         }
888         totalPoolWeight = totalPoolWeight.sub(rewardPools[idx].poolWeight).add(poolWeight);
889         rewardPools[idx].poolWeight = poolWeight;
890     }
891 
892     function rewardPerPeriod(uint lastUpdateBlock) public view returns (uint) {
893         uint _from = lastUpdateBlock;
894         uint _to = block.number < startBlock ? startBlock : (block.number > endBlock ? endBlock : block.number);
895 
896         uint period;
897         if (_to <= bonusEndBlock) {
898             period = _to.sub(_from).mul(BONUS_MULTIPLIER);
899         } else if (_from >= bonusEndBlock) {
900             period = _to.sub(_from);
901         } else {
902             period = bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
903                 _to.sub(bonusEndBlock)
904             );
905         }
906 
907         return period.mul(tokenPerBlock);
908     }
909 
910     function rewardAmount(uint idx, address account) public view returns (uint) {
911         poolInfo memory pool = rewardPools[idx];
912         userInfo memory user = userInfos[account][idx];
913 
914         uint rewardRate = pool.rewardRate;
915         if (block.number > pool.lastUpdateBlock && pool.totalBalance != 0) {
916             rewardRate = rewardRate.add(
917                 rewardPerPeriod(pool.lastUpdateBlock)
918                     .mul(pool.poolWeight)
919                     .div(totalPoolWeight)
920                     .mul(1e18)
921                     .div(pool.totalBalance));
922         }
923         return user.depositAmount.mul(rewardRate).div(1e18).sub(user.lastClaimAmount);
924     }
925 
926     function rewardAmountUni(uint idx, address account) public view returns (uint) {
927         poolInfo memory pool = rewardPools[idx];
928         userInfo memory user = userInfos[account][idx];
929         uint rewardPerTokenUni = 0;
930         if(pool.addrUniStakingRewards != address(0)) {
931             rewardPerTokenUni = IUNIStakingRewards(pool.addrUniStakingRewards)
932                 .rewardPerToken();
933         }
934         return user.depositAmount
935             .mul(rewardPerTokenUni.sub(user.userRewardPerTokenPaidUni))
936             .div(1e18)
937             .add(user.rewardsUni);
938     }
939 
940     function deposit(uint idx, uint amount) public {
941         require(idx < rewardPools.length, "Not in reward pool list");
942 
943         userInfo storage user = userInfos[msg.sender][idx];
944         poolInfo storage pool = rewardPools[idx];
945 
946         if (user.depositAmount > 0) {
947             claimReward(idx);
948         } else {
949             updatePool(idx);
950         }
951 
952         pool.totalBalance = pool.totalBalance.add(amount);
953 
954         user.depositAmount = user.depositAmount.add(amount);
955         user.lastClaimAmount = user.depositAmount.mul(pool.rewardRate).div(1e18);
956 
957         IERC20(pool.addrToken).safeTransferFrom(msg.sender, address(this), amount);
958 
959         if (pool.addrUniStakingRewards != address(0)) {
960             IERC20(pool.addrToken).approve(pool.addrUniStakingRewards, amount);
961             IUNIStakingRewards(pool.addrUniStakingRewards).stake(amount);
962         }
963 
964         emit Deposit(msg.sender, idx, amount);
965     }
966 
967     function withdraw(uint idx, uint amount) public {
968         require(idx < rewardPools.length, "Not in reward pool list");
969 
970         userInfo storage user = userInfos[msg.sender][idx];
971         poolInfo storage pool = rewardPools[idx];
972 
973         claimReward(idx);
974 
975         pool.totalBalance = pool.totalBalance.sub(amount);
976 
977         user.depositAmount = user.depositAmount.sub(amount);
978         user.lastClaimAmount = user.depositAmount.mul(pool.rewardRate).div(1e18);
979 
980         if (pool.addrUniStakingRewards != address(0)) {
981             IUNIStakingRewards(pool.addrUniStakingRewards).withdraw(amount);
982         }
983 
984         IERC20(pool.addrToken).safeTransfer(msg.sender, amount);
985 
986         emit Withdrawal(msg.sender, idx, amount);
987     }
988 
989     function updatePoolUni(uint idx) private {
990         poolInfo storage pool = rewardPools[idx];
991         userInfo storage user = userInfos[msg.sender][idx];
992         IUNIStakingRewards uni = IUNIStakingRewards(pool.addrUniStakingRewards);
993 
994         uint _before = IERC20(UNIAddress).balanceOf(address(this));
995         uni.getReward();
996         uint _after = IERC20(UNIAddress).balanceOf(address(this));
997         pool.totalRewardsUni = pool.totalRewardsUni.add(_after.sub(_before));
998 
999         uint rewardPerTokenUni = uni.rewardPerTokenStored();
1000 
1001         user.rewardsUni = user.depositAmount
1002             .mul(rewardPerTokenUni.sub(user.userRewardPerTokenPaidUni))
1003             .div(1e18)
1004             .add(user.rewardsUni);
1005         user.userRewardPerTokenPaidUni = rewardPerTokenUni;
1006     }
1007 
1008     function claimRewardUni(uint idx) private {
1009         poolInfo storage pool = rewardPools[idx];
1010         userInfo storage user = userInfos[msg.sender][idx];
1011         updatePoolUni(idx);
1012 
1013         if(user.rewardsUni > 0) {
1014             uint _rewardAmount = user.rewardsUni;
1015             if(_rewardAmount > pool.totalRewardsUni) {
1016                 _rewardAmount = pool.totalRewardsUni;
1017             }
1018             user.rewardsUni = 0;
1019             pool.totalRewardsUni = pool.totalRewardsUni.sub(_rewardAmount);
1020             IERC20(UNIAddress).safeTransfer(msg.sender, _rewardAmount);
1021         }
1022     }
1023 
1024     function updatePool(uint idx) private {
1025         poolInfo storage pool = rewardPools[idx];
1026 
1027         if (pool.addrUniStakingRewards != address(0)) {
1028             claimRewardUni(idx);
1029         }
1030 
1031         if (block.number <= pool.lastUpdateBlock) {
1032             return;
1033         }
1034 
1035         uint currentBlock = block.number >= endBlock ? endBlock : block.number;
1036 
1037         if (pool.totalBalance == 0) {
1038             pool.lastUpdateBlock = currentBlock;
1039             return;
1040         }
1041 
1042         uint rewardPerPool = rewardPerPeriod(pool.lastUpdateBlock)
1043             .mul(pool.poolWeight)
1044             .div(totalPoolWeight);
1045 
1046         pool.rewardRate = pool.rewardRate
1047             .add(rewardPerPool
1048                 .mul(1e18)
1049                 .div(pool.totalBalance)
1050         );
1051 
1052         pool.lastUpdateBlock = currentBlock;
1053     }
1054 
1055     function claimReward(uint idx) public {
1056         require(idx < rewardPools.length, "Not in reward pool list");
1057         userInfo storage user = userInfos[msg.sender][idx];
1058 
1059         updatePool(idx);
1060 
1061         uint reward = user.depositAmount
1062             .mul(rewardPools[idx].rewardRate)
1063             .div(1e18)
1064             .sub(user.lastClaimAmount);
1065 
1066         if(reward > 0) {
1067             user.lastClaimAmount = reward.add(user.lastClaimAmount);
1068             _mint(msg.sender, reward);
1069         }
1070 
1071         emit ClaimReward(msg.sender, idx, reward);
1072     }
1073 
1074     function claimRewardAdmin() public {
1075         require(lastClaimBlockAdmin < adminClaimRewardEndBlock, "No more reward for admin");
1076         uint toBlock = block.number >= adminClaimRewardEndBlock ? adminClaimRewardEndBlock : block.number;
1077         uint reward = toBlock.sub(lastClaimBlockAdmin).mul(tokenPerBlockAdmin);
1078         _mint(adminReceiveAddress, reward);
1079         lastClaimBlockAdmin = toBlock;
1080         emit ClaimReward(adminReceiveAddress, 0, reward);
1081     }
1082 }