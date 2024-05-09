1 // hevm: flattened sources of src/staking-rewards.sol
2 pragma solidity >=0.4.23 >=0.6.0 <0.7.0 >=0.6.2 <0.7.0 >=0.6.7 <0.7.0;
3 
4 ////// src/lib/safe-math.sol
5 // SPDX-License-Identifier: MIT
6 
7 /* pragma solidity ^0.6.0; */
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      *
31      * - Addition cannot overflow.
32      */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      *
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 ////// src/lib/erc20.sol
165 
166 // File: contracts/GSN/Context.sol
167 
168 
169 
170 /* pragma solidity ^0.6.0; */
171 
172 /* import "./safe-math.sol"; */
173 
174 /*
175  * @dev Provides information about the current execution context, including the
176  * sender of the transaction and its data. While these are generally available
177  * via msg.sender and msg.data, they should not be accessed in such a direct
178  * manner, since when dealing with GSN meta-transactions the account sending and
179  * paying for execution may not be the actual sender (as far as an application
180  * is concerned).
181  *
182  * This contract is only required for intermediate, library-like contracts.
183  */
184 abstract contract Context {
185     function _msgSender() internal view virtual returns (address payable) {
186         return msg.sender;
187     }
188 
189     function _msgData() internal view virtual returns (bytes memory) {
190         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
191         return msg.data;
192     }
193 }
194 
195 // File: contracts/token/ERC20/IERC20.sol
196 
197 
198 /**
199  * @dev Interface of the ERC20 standard as defined in the EIP.
200  */
201 interface IERC20 {
202     /**
203      * @dev Returns the amount of tokens in existence.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     /**
208      * @dev Returns the amount of tokens owned by `account`.
209      */
210     function balanceOf(address account) external view returns (uint256);
211 
212     /**
213      * @dev Moves `amount` tokens from the caller's account to `recipient`.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transfer(address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Returns the remaining number of tokens that `spender` will be
223      * allowed to spend on behalf of `owner` through {transferFrom}. This is
224      * zero by default.
225      *
226      * This value changes when {approve} or {transferFrom} are called.
227      */
228     function allowance(address owner, address spender) external view returns (uint256);
229 
230     /**
231      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * IMPORTANT: Beware that changing an allowance with this method brings the risk
236      * that someone may use both the old and the new allowance by unfortunate
237      * transaction ordering. One possible solution to mitigate this race
238      * condition is to first reduce the spender's allowance to 0 and set the
239      * desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address spender, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Moves `amount` tokens from `sender` to `recipient` using the
248      * allowance mechanism. `amount` is then deducted from the caller's
249      * allowance.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Emitted when `value` tokens are moved from one account (`from`) to
259      * another (`to`).
260      *
261      * Note that `value` may be zero.
262      */
263     event Transfer(address indexed from, address indexed to, uint256 value);
264 
265     /**
266      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
267      * a call to {approve}. `value` is the new allowance.
268      */
269     event Approval(address indexed owner, address indexed spender, uint256 value);
270 }
271 
272 // File: contracts/utils/Address.sol
273 
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         uint256 size;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { size := extcodesize(account) }
304         return size > 0;
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         return _functionCallWithValue(target, data, value, errorMessage);
387     }
388 
389     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
390         require(isContract(target), "Address: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 // solhint-disable-next-line no-inline-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 // File: contracts/token/ERC20/ERC20.sol
414 
415 /**
416  * @dev Implementation of the {IERC20} interface.
417  *
418  * This implementation is agnostic to the way tokens are created. This means
419  * that a supply mechanism has to be added in a derived contract using {_mint}.
420  * For a generic mechanism see {ERC20PresetMinterPauser}.
421  *
422  * TIP: For a detailed writeup see our guide
423  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
424  * to implement supply mechanisms].
425  *
426  * We have followed general OpenZeppelin guidelines: functions revert instead
427  * of returning `false` on failure. This behavior is nonetheless conventional
428  * and does not conflict with the expectations of ERC20 applications.
429  *
430  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
431  * This allows applications to reconstruct the allowance for all accounts just
432  * by listening to said events. Other implementations of the EIP may not emit
433  * these events, as it isn't required by the specification.
434  *
435  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
436  * functions have been added to mitigate the well-known issues around setting
437  * allowances. See {IERC20-approve}.
438  */
439 contract ERC20 is Context, IERC20 {
440     using SafeMath for uint256;
441     using Address for address;
442 
443     mapping (address => uint256) private _balances;
444 
445     mapping (address => mapping (address => uint256)) private _allowances;
446 
447     uint256 private _totalSupply;
448 
449     string private _name;
450     string private _symbol;
451     uint8 private _decimals;
452 
453     /**
454      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
455      * a default value of 18.
456      *
457      * To select a different value for {decimals}, use {_setupDecimals}.
458      *
459      * All three of these values are immutable: they can only be set once during
460      * construction.
461      */
462     constructor (string memory name, string memory symbol) public {
463         _name = name;
464         _symbol = symbol;
465         _decimals = 18;
466     }
467 
468     /**
469      * @dev Returns the name of the token.
470      */
471     function name() public view returns (string memory) {
472         return _name;
473     }
474 
475     /**
476      * @dev Returns the symbol of the token, usually a shorter version of the
477      * name.
478      */
479     function symbol() public view returns (string memory) {
480         return _symbol;
481     }
482 
483     /**
484      * @dev Returns the number of decimals used to get its user representation.
485      * For example, if `decimals` equals `2`, a balance of `505` tokens should
486      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
487      *
488      * Tokens usually opt for a value of 18, imitating the relationship between
489      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
490      * called.
491      *
492      * NOTE: This information is only used for _display_ purposes: it in
493      * no way affects any of the arithmetic of the contract, including
494      * {IERC20-balanceOf} and {IERC20-transfer}.
495      */
496     function decimals() public view returns (uint8) {
497         return _decimals;
498     }
499 
500     /**
501      * @dev See {IERC20-totalSupply}.
502      */
503     function totalSupply() public view override returns (uint256) {
504         return _totalSupply;
505     }
506 
507     /**
508      * @dev See {IERC20-balanceOf}.
509      */
510     function balanceOf(address account) public view override returns (uint256) {
511         return _balances[account];
512     }
513 
514     /**
515      * @dev See {IERC20-transfer}.
516      *
517      * Requirements:
518      *
519      * - `recipient` cannot be the zero address.
520      * - the caller must have a balance of at least `amount`.
521      */
522     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
523         _transfer(_msgSender(), recipient, amount);
524         return true;
525     }
526 
527     /**
528      * @dev See {IERC20-allowance}.
529      */
530     function allowance(address owner, address spender) public view virtual override returns (uint256) {
531         return _allowances[owner][spender];
532     }
533 
534     /**
535      * @dev See {IERC20-approve}.
536      *
537      * Requirements:
538      *
539      * - `spender` cannot be the zero address.
540      */
541     function approve(address spender, uint256 amount) public virtual override returns (bool) {
542         _approve(_msgSender(), spender, amount);
543         return true;
544     }
545 
546     /**
547      * @dev See {IERC20-transferFrom}.
548      *
549      * Emits an {Approval} event indicating the updated allowance. This is not
550      * required by the EIP. See the note at the beginning of {ERC20};
551      *
552      * Requirements:
553      * - `sender` and `recipient` cannot be the zero address.
554      * - `sender` must have a balance of at least `amount`.
555      * - the caller must have allowance for ``sender``'s tokens of at least
556      * `amount`.
557      */
558     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
559         _transfer(sender, recipient, amount);
560         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
561         return true;
562     }
563 
564     /**
565      * @dev Atomically increases the allowance granted to `spender` by the caller.
566      *
567      * This is an alternative to {approve} that can be used as a mitigation for
568      * problems described in {IERC20-approve}.
569      *
570      * Emits an {Approval} event indicating the updated allowance.
571      *
572      * Requirements:
573      *
574      * - `spender` cannot be the zero address.
575      */
576     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
577         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
578         return true;
579     }
580 
581     /**
582      * @dev Atomically decreases the allowance granted to `spender` by the caller.
583      *
584      * This is an alternative to {approve} that can be used as a mitigation for
585      * problems described in {IERC20-approve}.
586      *
587      * Emits an {Approval} event indicating the updated allowance.
588      *
589      * Requirements:
590      *
591      * - `spender` cannot be the zero address.
592      * - `spender` must have allowance for the caller of at least
593      * `subtractedValue`.
594      */
595     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
596         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
597         return true;
598     }
599 
600     /**
601      * @dev Moves tokens `amount` from `sender` to `recipient`.
602      *
603      * This is internal function is equivalent to {transfer}, and can be used to
604      * e.g. implement automatic token fees, slashing mechanisms, etc.
605      *
606      * Emits a {Transfer} event.
607      *
608      * Requirements:
609      *
610      * - `sender` cannot be the zero address.
611      * - `recipient` cannot be the zero address.
612      * - `sender` must have a balance of at least `amount`.
613      */
614     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
615         require(sender != address(0), "ERC20: transfer from the zero address");
616         require(recipient != address(0), "ERC20: transfer to the zero address");
617 
618         _beforeTokenTransfer(sender, recipient, amount);
619 
620         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
621         _balances[recipient] = _balances[recipient].add(amount);
622         emit Transfer(sender, recipient, amount);
623     }
624 
625     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
626      * the total supply.
627      *
628      * Emits a {Transfer} event with `from` set to the zero address.
629      *
630      * Requirements
631      *
632      * - `to` cannot be the zero address.
633      */
634     function _mint(address account, uint256 amount) internal virtual {
635         require(account != address(0), "ERC20: mint to the zero address");
636 
637         _beforeTokenTransfer(address(0), account, amount);
638 
639         _totalSupply = _totalSupply.add(amount);
640         _balances[account] = _balances[account].add(amount);
641         emit Transfer(address(0), account, amount);
642     }
643 
644     /**
645      * @dev Destroys `amount` tokens from `account`, reducing the
646      * total supply.
647      *
648      * Emits a {Transfer} event with `to` set to the zero address.
649      *
650      * Requirements
651      *
652      * - `account` cannot be the zero address.
653      * - `account` must have at least `amount` tokens.
654      */
655     function _burn(address account, uint256 amount) internal virtual {
656         require(account != address(0), "ERC20: burn from the zero address");
657 
658         _beforeTokenTransfer(account, address(0), amount);
659 
660         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
661         _totalSupply = _totalSupply.sub(amount);
662         emit Transfer(account, address(0), amount);
663     }
664 
665     /**
666      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
667      *
668      * This internal function is equivalent to `approve`, and can be used to
669      * e.g. set automatic allowances for certain subsystems, etc.
670      *
671      * Emits an {Approval} event.
672      *
673      * Requirements:
674      *
675      * - `owner` cannot be the zero address.
676      * - `spender` cannot be the zero address.
677      */
678     function _approve(address owner, address spender, uint256 amount) internal virtual {
679         require(owner != address(0), "ERC20: approve from the zero address");
680         require(spender != address(0), "ERC20: approve to the zero address");
681 
682         _allowances[owner][spender] = amount;
683         emit Approval(owner, spender, amount);
684     }
685 
686     /**
687      * @dev Sets {decimals} to a value other than the default one of 18.
688      *
689      * WARNING: This function should only be called from the constructor. Most
690      * applications that interact with token contracts will not expect
691      * {decimals} to ever change, and may work incorrectly if it does.
692      */
693     function _setupDecimals(uint8 decimals_) internal {
694         _decimals = decimals_;
695     }
696 
697     /**
698      * @dev Hook that is called before any transfer of tokens. This includes
699      * minting and burning.
700      *
701      * Calling conditions:
702      *
703      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
704      * will be to transferred to `to`.
705      * - when `from` is zero, `amount` tokens will be minted for `to`.
706      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
707      * - `from` and `to` are never both zero.
708      *
709      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
710      */
711     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
712 }
713 
714 /**
715  * @title SafeERC20
716  * @dev Wrappers around ERC20 operations that throw on failure (when the token
717  * contract returns false). Tokens that return no value (and instead revert or
718  * throw on failure) are also supported, non-reverting calls are assumed to be
719  * successful.
720  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
721  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
722  */
723 library SafeERC20 {
724     using SafeMath for uint256;
725     using Address for address;
726 
727     function safeTransfer(IERC20 token, address to, uint256 value) internal {
728         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
729     }
730 
731     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
732         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
733     }
734 
735     /**
736      * @dev Deprecated. This function has issues similar to the ones found in
737      * {IERC20-approve}, and its usage is discouraged.
738      *
739      * Whenever possible, use {safeIncreaseAllowance} and
740      * {safeDecreaseAllowance} instead.
741      */
742     function safeApprove(IERC20 token, address spender, uint256 value) internal {
743         // safeApprove should only be called when setting an initial allowance,
744         // or when resetting it to zero. To increase and decrease it, use
745         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
746         // solhint-disable-next-line max-line-length
747         require((value == 0) || (token.allowance(address(this), spender) == 0),
748             "SafeERC20: approve from non-zero to non-zero allowance"
749         );
750         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
751     }
752 
753     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
754         uint256 newAllowance = token.allowance(address(this), spender).add(value);
755         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
756     }
757 
758     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
759         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
760         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
761     }
762 
763     /**
764      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
765      * on the return value: the return value is optional (but if data is returned, it must not be false).
766      * @param token The token targeted by the call.
767      * @param data The call data (encoded using abi.encode or one of its variants).
768      */
769     function _callOptionalReturn(IERC20 token, bytes memory data) private {
770         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
771         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
772         // the target address contains contract code and also asserts for success in the low-level call.
773 
774         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
775         if (returndata.length > 0) { // Return data is optional
776             // solhint-disable-next-line max-line-length
777             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
778         }
779     }
780 }
781 ////// src/lib/owned.sol
782 /* pragma solidity ^0.6.7; */
783 
784 // https://docs.synthetix.io/contracts/Owned
785 contract Owned {
786     address public owner;
787     address public nominatedOwner;
788 
789     constructor(address _owner) public {
790         require(_owner != address(0), "Owner address cannot be 0");
791         owner = _owner;
792         emit OwnerChanged(address(0), _owner);
793     }
794 
795     function nominateNewOwner(address _owner) external onlyOwner {
796         nominatedOwner = _owner;
797         emit OwnerNominated(_owner);
798     }
799 
800     function acceptOwnership() external {
801         require(
802             msg.sender == nominatedOwner,
803             "You must be nominated before you can accept ownership"
804         );
805         emit OwnerChanged(owner, nominatedOwner);
806         owner = nominatedOwner;
807         nominatedOwner = address(0);
808     }
809 
810     modifier onlyOwner {
811         _onlyOwner();
812         _;
813     }
814 
815     function _onlyOwner() private view {
816         require(
817             msg.sender == owner,
818             "Only the contract owner may perform this action"
819         );
820     }
821 
822     event OwnerNominated(address newOwner);
823     event OwnerChanged(address oldOwner, address newOwner);
824 }
825 
826 ////// src/lib/pausable.sol
827 /* pragma solidity ^0.6.7; */
828 
829 // Inheritance
830 /* import "./owned.sol"; */
831 
832 // https://docs.synthetix.io/contracts/Pausable
833 abstract contract Pausable is Owned {
834     uint256 public lastPauseTime;
835     bool public paused;
836 
837     constructor() internal {
838         // This contract is abstract, and thus cannot be instantiated directly
839         require(owner != address(0), "Owner must be set");
840         // Paused will be false, and lastPauseTime will be 0 upon initialisation
841     }
842 
843     /**
844      * @notice Change the paused state of the contract
845      * @dev Only the contract owner may call this.
846      */
847     function setPaused(bool _paused) external onlyOwner {
848         // Ensure we're actually changing the state before we do anything
849         if (_paused == paused) {
850             return;
851         }
852 
853         // Set our paused state.
854         paused = _paused;
855 
856         // If applicable, set the last pause time.
857         if (paused) {
858             lastPauseTime = now;
859         }
860 
861         // Let everyone know that our pause state has changed.
862         emit PauseChanged(paused);
863     }
864 
865     event PauseChanged(bool isPaused);
866 
867     modifier notPaused {
868         require(
869             !paused,
870             "This action cannot be performed while the contract is paused"
871         );
872         _;
873     }
874 }
875 
876 ////// src/lib/reentrancy-guard.sol
877 
878 
879 /* pragma solidity ^0.6.0; */
880 
881 /**
882  * @dev Contract module that helps prevent reentrant calls to a function.
883  *
884  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
885  * available, which can be applied to functions to make sure there are no nested
886  * (reentrant) calls to them.
887  *
888  * Note that because there is a single `nonReentrant` guard, functions marked as
889  * `nonReentrant` may not call one another. This can be worked around by making
890  * those functions `private`, and then adding `external` `nonReentrant` entry
891  * points to them.
892  *
893  * TIP: If you would like to learn more about reentrancy and alternative ways
894  * to protect against it, check out our blog post
895  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
896  */
897 contract ReentrancyGuard {
898     // Booleans are more expensive than uint256 or any type that takes up a full
899     // word because each write operation emits an extra SLOAD to first read the
900     // slot's contents, replace the bits taken up by the boolean, and then write
901     // back. This is the compiler's defense against contract upgrades and
902     // pointer aliasing, and it cannot be disabled.
903 
904     // The values being non-zero value makes deployment a bit more expensive,
905     // but in exchange the refund on every call to nonReentrant will be lower in
906     // amount. Since refunds are capped to a percentage of the total
907     // transaction's gas, it is best to keep them low in cases like this one, to
908     // increase the likelihood of the full refund coming into effect.
909     uint256 private constant _NOT_ENTERED = 1;
910     uint256 private constant _ENTERED = 2;
911 
912     uint256 private _status;
913 
914     constructor () internal {
915         _status = _NOT_ENTERED;
916     }
917 
918     /**
919      * @dev Prevents a contract from calling itself, directly or indirectly.
920      * Calling a `nonReentrant` function from another `nonReentrant`
921      * function is not supported. It is possible to prevent this from happening
922      * by making the `nonReentrant` function external, and make it call a
923      * `private` function that does the actual work.
924      */
925     modifier nonReentrant() {
926         // On the first call to nonReentrant, _notEntered will be true
927         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
928 
929         // Any calls to nonReentrant after this point will fail
930         _status = _ENTERED;
931 
932         _;
933 
934         // By storing the original value once again, a refund is triggered (see
935         // https://eips.ethereum.org/EIPS/eip-2200)
936         _status = _NOT_ENTERED;
937     }
938 }
939 ////// src/staking-rewards.sol
940 
941 
942 /* pragma solidity ^0.6.7; */
943 
944 /* import "./lib/reentrancy-guard.sol"; */
945 /* import "./lib/pausable.sol"; */
946 /* import "./lib/erc20.sol"; */
947 /* import "./lib/safe-math.sol"; */
948 
949 contract StakingRewards is ReentrancyGuard, Pausable {
950     using SafeMath for uint256;
951     using SafeERC20 for IERC20;
952 
953     /* ========== STATE VARIABLES ========== */
954 
955     IERC20 public rewardsToken;
956     IERC20 public stakingToken;
957     uint256 public periodFinish = 0;
958     uint256 public rewardRate = 0;
959     uint256 public rewardsDuration = 7 days;
960     uint256 public lastUpdateTime;
961     uint256 public rewardPerTokenStored;
962 
963     mapping(address => uint256) public userRewardPerTokenPaid;
964     mapping(address => uint256) public rewards;
965 
966     uint256 private _totalSupply;
967     mapping(address => uint256) private _balances;
968 
969     /* ========== CONSTRUCTOR ========== */
970 
971     constructor(
972         address _owner,
973         address _rewardsToken,
974         address _stakingToken
975     ) public Owned(_owner) {
976         rewardsToken = IERC20(_rewardsToken);
977         stakingToken = IERC20(_stakingToken);
978     }
979 
980     /* ========== VIEWS ========== */
981 
982     function totalSupply() external view returns (uint256) {
983         return _totalSupply;
984     }
985 
986     function balanceOf(address account) external view returns (uint256) {
987         return _balances[account];
988     }
989 
990     function lastTimeRewardApplicable() public view returns (uint256) {
991         return min(block.timestamp, periodFinish);
992     }
993 
994     function rewardPerToken() public view returns (uint256) {
995         if (_totalSupply == 0) {
996             return rewardPerTokenStored;
997         }
998         return
999             rewardPerTokenStored.add(
1000                 lastTimeRewardApplicable()
1001                     .sub(lastUpdateTime)
1002                     .mul(rewardRate)
1003                     .mul(1e18)
1004                     .div(_totalSupply)
1005             );
1006     }
1007 
1008     function earned(address account) public view returns (uint256) {
1009         return
1010             _balances[account]
1011                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
1012                 .div(1e18)
1013                 .add(rewards[account]);
1014     }
1015 
1016     function getRewardForDuration() external view returns (uint256) {
1017         return rewardRate.mul(rewardsDuration);
1018     }
1019 
1020     function min(uint256 a, uint256 b) public pure returns (uint256) {
1021         return a < b ? a : b;
1022     }
1023 
1024     /* ========== MUTATIVE FUNCTIONS ========== */
1025 
1026     function stake(uint256 amount)
1027         external
1028         nonReentrant
1029         notPaused
1030         updateReward(msg.sender)
1031     {
1032         require(amount > 0, "Cannot stake 0");
1033         _totalSupply = _totalSupply.add(amount);
1034         _balances[msg.sender] = _balances[msg.sender].add(amount);
1035         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1036         emit Staked(msg.sender, amount);
1037     }
1038 
1039     function withdraw(uint256 amount)
1040         public
1041         nonReentrant
1042         updateReward(msg.sender)
1043     {
1044         require(amount > 0, "Cannot withdraw 0");
1045         _totalSupply = _totalSupply.sub(amount);
1046         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1047         stakingToken.safeTransfer(msg.sender, amount);
1048         emit Withdrawn(msg.sender, amount);
1049     }
1050 
1051     function getReward() public nonReentrant updateReward(msg.sender) {
1052         uint256 reward = rewards[msg.sender];
1053         if (reward > 0) {
1054             rewards[msg.sender] = 0;
1055             rewardsToken.safeTransfer(msg.sender, reward);
1056             emit RewardPaid(msg.sender, reward);
1057         }
1058     }
1059 
1060     function exit() external {
1061         withdraw(_balances[msg.sender]);
1062         getReward();
1063     }
1064 
1065     /* ========== RESTRICTED FUNCTIONS ========== */
1066 
1067     function notifyRewardAmount(uint256 reward)
1068         external
1069         onlyOwner
1070         updateReward(address(0))
1071     {
1072         if (block.timestamp >= periodFinish) {
1073             rewardRate = reward.div(rewardsDuration);
1074         } else {
1075             uint256 remaining = periodFinish.sub(block.timestamp);
1076             uint256 leftover = remaining.mul(rewardRate);
1077             rewardRate = reward.add(leftover).div(rewardsDuration);
1078         }
1079 
1080         // Ensure the provided reward amount is not more than the balance in the contract.
1081         // This keeps the reward rate in the right range, preventing overflows due to
1082         // very high values of rewardRate in the earned and rewardsPerToken functions;
1083         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1084         uint256 balance = rewardsToken.balanceOf(address(this));
1085         require(
1086             rewardRate <= balance.div(rewardsDuration),
1087             "Provided reward too high"
1088         );
1089 
1090         lastUpdateTime = block.timestamp;
1091         periodFinish = block.timestamp.add(rewardsDuration);
1092         emit RewardAdded(reward);
1093     }
1094 
1095     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
1096     function recoverERC20(address tokenAddress, uint256 tokenAmount)
1097         external
1098         onlyOwner
1099     {
1100         // Cannot recover the staking token or the rewards token
1101         require(
1102             tokenAddress != address(stakingToken) &&
1103                 tokenAddress != address(rewardsToken),
1104             "Cannot withdraw the staking or rewards tokens"
1105         );
1106         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
1107         emit Recovered(tokenAddress, tokenAmount);
1108     }
1109 
1110     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
1111         require(
1112             block.timestamp > periodFinish,
1113             "Previous rewards period must be complete before changing the duration for the new period"
1114         );
1115         rewardsDuration = _rewardsDuration;
1116         emit RewardsDurationUpdated(rewardsDuration);
1117     }
1118 
1119     /* ========== MODIFIERS ========== */
1120 
1121     modifier updateReward(address account) {
1122         rewardPerTokenStored = rewardPerToken();
1123         lastUpdateTime = lastTimeRewardApplicable();
1124         if (account != address(0)) {
1125             rewards[account] = earned(account);
1126             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1127         }
1128         _;
1129     }
1130 
1131     /* ========== EVENTS ========== */
1132 
1133     event RewardAdded(uint256 reward);
1134     event Staked(address indexed user, uint256 amount);
1135     event Withdrawn(address indexed user, uint256 amount);
1136     event RewardPaid(address indexed user, uint256 reward);
1137     event RewardsDurationUpdated(uint256 newDuration);
1138     event Recovered(address token, uint256 amount);
1139 }