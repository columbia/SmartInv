1 // File: ..\..\..\node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: ..\..\..\node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: ..\..\..\node_modules\@openzeppelin\contracts\math\SafeMath.sol
108 
109 
110 pragma solidity ^0.6.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 // File: ..\..\..\node_modules\@openzeppelin\contracts\utils\Address.sol
269 
270 
271 pragma solidity ^0.6.2;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies in extcodesize, which returns 0 for contracts in
296         // construction, since the code is only stored at the end of the
297         // constructor execution.
298 
299         uint256 size;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { size := extcodesize(account) }
302         return size > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
325         (bool success, ) = recipient.call{ value: amount }("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain`call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348       return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
358         return _functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         return _functionCallWithValue(target, data, value, errorMessage);
385     }
386 
387     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
388         require(isContract(target), "Address: call to non-contract");
389 
390         // solhint-disable-next-line avoid-low-level-calls
391         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 // solhint-disable-next-line no-inline-assembly
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
412 
413 
414 pragma solidity ^0.6.0;
415 
416 
417 
418 
419 
420 /**
421  * @dev Implementation of the {IERC20} interface.
422  *
423  * This implementation is agnostic to the way tokens are created. This means
424  * that a supply mechanism has to be added in a derived contract using {_mint}.
425  * For a generic mechanism see {ERC20PresetMinterPauser}.
426  *
427  * TIP: For a detailed writeup see our guide
428  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
429  * to implement supply mechanisms].
430  *
431  * We have followed general OpenZeppelin guidelines: functions revert instead
432  * of returning `false` on failure. This behavior is nonetheless conventional
433  * and does not conflict with the expectations of ERC20 applications.
434  *
435  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
436  * This allows applications to reconstruct the allowance for all accounts just
437  * by listening to said events. Other implementations of the EIP may not emit
438  * these events, as it isn't required by the specification.
439  *
440  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
441  * functions have been added to mitigate the well-known issues around setting
442  * allowances. See {IERC20-approve}.
443  */
444 contract ERC20 is Context, IERC20 {
445     using SafeMath for uint256;
446     using Address for address;
447 
448     mapping (address => uint256) private _balances;
449 
450     mapping (address => mapping (address => uint256)) private _allowances;
451 
452     uint256 private _totalSupply;
453 
454     string private _name;
455     string private _symbol;
456     uint8 private _decimals;
457 
458     /**
459      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
460      * a default value of 18.
461      *
462      * To select a different value for {decimals}, use {_setupDecimals}.
463      *
464      * All three of these values are immutable: they can only be set once during
465      * construction.
466      */
467     constructor (string memory name, string memory symbol) public {
468         _name = name;
469         _symbol = symbol;
470         _decimals = 18;
471     }
472 
473     /**
474      * @dev Returns the name of the token.
475      */
476     function name() public view returns (string memory) {
477         return _name;
478     }
479 
480     /**
481      * @dev Returns the symbol of the token, usually a shorter version of the
482      * name.
483      */
484     function symbol() public view returns (string memory) {
485         return _symbol;
486     }
487 
488     /**
489      * @dev Returns the number of decimals used to get its user representation.
490      * For example, if `decimals` equals `2`, a balance of `505` tokens should
491      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
492      *
493      * Tokens usually opt for a value of 18, imitating the relationship between
494      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
495      * called.
496      *
497      * NOTE: This information is only used for _display_ purposes: it in
498      * no way affects any of the arithmetic of the contract, including
499      * {IERC20-balanceOf} and {IERC20-transfer}.
500      */
501     function decimals() public view returns (uint8) {
502         return _decimals;
503     }
504 
505     /**
506      * @dev See {IERC20-totalSupply}.
507      */
508     function totalSupply() public view override returns (uint256) {
509         return _totalSupply;
510     }
511 
512     /**
513      * @dev See {IERC20-balanceOf}.
514      */
515     function balanceOf(address account) public view override returns (uint256) {
516         return _balances[account];
517     }
518 
519     /**
520      * @dev See {IERC20-transfer}.
521      *
522      * Requirements:
523      *
524      * - `recipient` cannot be the zero address.
525      * - the caller must have a balance of at least `amount`.
526      */
527     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
528         _transfer(_msgSender(), recipient, amount);
529         return true;
530     }
531 
532     /**
533      * @dev See {IERC20-allowance}.
534      */
535     function allowance(address owner, address spender) public view virtual override returns (uint256) {
536         return _allowances[owner][spender];
537     }
538 
539     /**
540      * @dev See {IERC20-approve}.
541      *
542      * Requirements:
543      *
544      * - `spender` cannot be the zero address.
545      */
546     function approve(address spender, uint256 amount) public virtual override returns (bool) {
547         _approve(_msgSender(), spender, amount);
548         return true;
549     }
550 
551     /**
552      * @dev See {IERC20-transferFrom}.
553      *
554      * Emits an {Approval} event indicating the updated allowance. This is not
555      * required by the EIP. See the note at the beginning of {ERC20};
556      *
557      * Requirements:
558      * - `sender` and `recipient` cannot be the zero address.
559      * - `sender` must have a balance of at least `amount`.
560      * - the caller must have allowance for ``sender``'s tokens of at least
561      * `amount`.
562      */
563     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
564         _transfer(sender, recipient, amount);
565         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
566         return true;
567     }
568 
569     /**
570      * @dev Atomically increases the allowance granted to `spender` by the caller.
571      *
572      * This is an alternative to {approve} that can be used as a mitigation for
573      * problems described in {IERC20-approve}.
574      *
575      * Emits an {Approval} event indicating the updated allowance.
576      *
577      * Requirements:
578      *
579      * - `spender` cannot be the zero address.
580      */
581     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
583         return true;
584     }
585 
586     /**
587      * @dev Atomically decreases the allowance granted to `spender` by the caller.
588      *
589      * This is an alternative to {approve} that can be used as a mitigation for
590      * problems described in {IERC20-approve}.
591      *
592      * Emits an {Approval} event indicating the updated allowance.
593      *
594      * Requirements:
595      *
596      * - `spender` cannot be the zero address.
597      * - `spender` must have allowance for the caller of at least
598      * `subtractedValue`.
599      */
600     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
601         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
602         return true;
603     }
604 
605     /**
606      * @dev Moves tokens `amount` from `sender` to `recipient`.
607      *
608      * This is internal function is equivalent to {transfer}, and can be used to
609      * e.g. implement automatic token fees, slashing mechanisms, etc.
610      *
611      * Emits a {Transfer} event.
612      *
613      * Requirements:
614      *
615      * - `sender` cannot be the zero address.
616      * - `recipient` cannot be the zero address.
617      * - `sender` must have a balance of at least `amount`.
618      */
619     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
620         require(sender != address(0), "ERC20: transfer from the zero address");
621         require(recipient != address(0), "ERC20: transfer to the zero address");
622 
623         _beforeTokenTransfer(sender, recipient, amount);
624 
625         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
626         _balances[recipient] = _balances[recipient].add(amount);
627         emit Transfer(sender, recipient, amount);
628     }
629 
630     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
631      * the total supply.
632      *
633      * Emits a {Transfer} event with `from` set to the zero address.
634      *
635      * Requirements
636      *
637      * - `to` cannot be the zero address.
638      */
639     function _mint(address account, uint256 amount) internal virtual {
640         require(account != address(0), "ERC20: mint to the zero address");
641 
642         _beforeTokenTransfer(address(0), account, amount);
643 
644         _totalSupply = _totalSupply.add(amount);
645         _balances[account] = _balances[account].add(amount);
646         emit Transfer(address(0), account, amount);
647     }
648 
649     /**
650      * @dev Destroys `amount` tokens from `account`, reducing the
651      * total supply.
652      *
653      * Emits a {Transfer} event with `to` set to the zero address.
654      *
655      * Requirements
656      *
657      * - `account` cannot be the zero address.
658      * - `account` must have at least `amount` tokens.
659      */
660     function _burn(address account, uint256 amount) internal virtual {
661         require(account != address(0), "ERC20: burn from the zero address");
662 
663         _beforeTokenTransfer(account, address(0), amount);
664 
665         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
666         _totalSupply = _totalSupply.sub(amount);
667         emit Transfer(account, address(0), amount);
668     }
669 
670     /**
671      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
672      *
673      * This internal function is equivalent to `approve`, and can be used to
674      * e.g. set automatic allowances for certain subsystems, etc.
675      *
676      * Emits an {Approval} event.
677      *
678      * Requirements:
679      *
680      * - `owner` cannot be the zero address.
681      * - `spender` cannot be the zero address.
682      */
683     function _approve(address owner, address spender, uint256 amount) internal virtual {
684         require(owner != address(0), "ERC20: approve from the zero address");
685         require(spender != address(0), "ERC20: approve to the zero address");
686 
687         _allowances[owner][spender] = amount;
688         emit Approval(owner, spender, amount);
689     }
690 
691     /**
692      * @dev Sets {decimals} to a value other than the default one of 18.
693      *
694      * WARNING: This function should only be called from the constructor. Most
695      * applications that interact with token contracts will not expect
696      * {decimals} to ever change, and may work incorrectly if it does.
697      */
698     function _setupDecimals(uint8 decimals_) internal {
699         _decimals = decimals_;
700     }
701 
702     /**
703      * @dev Hook that is called before any transfer of tokens. This includes
704      * minting and burning.
705      *
706      * Calling conditions:
707      *
708      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
709      * will be to transferred to `to`.
710      * - when `from` is zero, `amount` tokens will be minted for `to`.
711      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
712      * - `from` and `to` are never both zero.
713      *
714      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
715      */
716     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
717 }
718 
719 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
720 
721 
722 pragma solidity ^0.6.0;
723 
724 
725 
726 
727 /**
728  * @title SafeERC20
729  * @dev Wrappers around ERC20 operations that throw on failure (when the token
730  * contract returns false). Tokens that return no value (and instead revert or
731  * throw on failure) are also supported, non-reverting calls are assumed to be
732  * successful.
733  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
734  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
735  */
736 library SafeERC20 {
737     using SafeMath for uint256;
738     using Address for address;
739 
740     function safeTransfer(IERC20 token, address to, uint256 value) internal {
741         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
742     }
743 
744     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
745         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
746     }
747 
748     /**
749      * @dev Deprecated. This function has issues similar to the ones found in
750      * {IERC20-approve}, and its usage is discouraged.
751      *
752      * Whenever possible, use {safeIncreaseAllowance} and
753      * {safeDecreaseAllowance} instead.
754      */
755     function safeApprove(IERC20 token, address spender, uint256 value) internal {
756         // safeApprove should only be called when setting an initial allowance,
757         // or when resetting it to zero. To increase and decrease it, use
758         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
759         // solhint-disable-next-line max-line-length
760         require((value == 0) || (token.allowance(address(this), spender) == 0),
761             "SafeERC20: approve from non-zero to non-zero allowance"
762         );
763         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
764     }
765 
766     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
767         uint256 newAllowance = token.allowance(address(this), spender).add(value);
768         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
769     }
770 
771     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
772         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
773         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
774     }
775 
776     /**
777      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
778      * on the return value: the return value is optional (but if data is returned, it must not be false).
779      * @param token The token targeted by the call.
780      * @param data The call data (encoded using abi.encode or one of its variants).
781      */
782     function _callOptionalReturn(IERC20 token, bytes memory data) private {
783         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
784         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
785         // the target address contains contract code and also asserts for success in the low-level call.
786 
787         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
788         if (returndata.length > 0) { // Return data is optional
789             // solhint-disable-next-line max-line-length
790             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
791         }
792     }
793 }
794 
795 
796 // File: contracts\kKushToken.sol
797 
798 pragma solidity ^0.6.0;
799 
800 
801 
802 
803 
804 contract kKushToken is ERC20 {
805     
806     struct stakeTracker {
807         uint256 lastBlockChecked;
808         uint256 rewards;
809         uint256 kSeedStaked;
810     }
811 
812     address private owner;
813     
814     uint256 private rewardsVar;
815     
816     using SafeERC20 for IERC20;
817     using SafeMath for uint256;
818  
819     address private kSeedAddress;
820     IERC20 private kSeedToken;
821 
822     uint256 private _totalkSeedStaked;
823     mapping(address => stakeTracker) private _stakedBalances;
824     
825     constructor() public ERC20("kKUSH", "kKUSH") {
826         owner = msg.sender;
827         _mint(msg.sender, 420 * (10 ** 18));
828         rewardsVar = 4200000;
829     }
830     
831     event Staked(address indexed user, uint256 amount, uint256 totalkSeedStaked);
832     event Withdrawn(address indexed user, uint256 amount);
833     event Rewards(address indexed user, uint256 reward);
834     
835     modifier _onlyOwner() {
836         require(msg.sender == owner);
837         _;
838     }
839 
840     modifier updateStakingReward(address account) {
841         if (block.number > _stakedBalances[account].lastBlockChecked) {
842             uint256 rewardBlocks = block.number
843                                         .sub(_stakedBalances[account].lastBlockChecked);
844                                         
845                                         
846              
847             if (_stakedBalances[account].kSeedStaked > 0) {
848                 _stakedBalances[account].rewards = _stakedBalances[account].rewards
849                                                                             .add(
850                                                                             _stakedBalances[account].kSeedStaked
851                                                                             .mul(rewardBlocks)
852                                                                             / rewardsVar);
853             }
854                     
855             _stakedBalances[account].lastBlockChecked = block.number;
856             
857             emit Rewards(account, _stakedBalances[account].rewards);                                                     
858         }
859         _;
860     }
861 
862 
863     function setkSeedAddress(address _kseedAddress) public _onlyOwner returns(uint256) {
864         kSeedAddress = _kseedAddress;
865         kSeedToken = IERC20(_kseedAddress);
866     }
867     
868     function updatingStakingReward(address account) public returns(uint256) {
869         if (block.number > _stakedBalances[account].lastBlockChecked) {
870             uint256 rewardBlocks = block.number
871                                         .sub(_stakedBalances[account].lastBlockChecked);
872                                         
873                                         
874             if (_stakedBalances[account].kSeedStaked > 0) {
875                 _stakedBalances[account].rewards = _stakedBalances[account].rewards
876                                                                             .add(
877                                                                             _stakedBalances[account].kSeedStaked
878                                                                             .mul(rewardBlocks)
879                                                                             / rewardsVar);
880             }
881                                                 
882             _stakedBalances[account].lastBlockChecked = block.number;
883                                                 
884             emit Rewards(account, _stakedBalances[account].rewards);                                                     
885         
886         }
887         return(_stakedBalances[account].rewards);
888     }
889     
890     function getBlockNum() public view returns (uint256) {
891         return block.number;
892     }
893     
894     function getLastBlockCheckedNum(address _account) public view returns (uint256) {
895         return _stakedBalances[_account].lastBlockChecked;
896     }
897 
898     function getAddressStakeAmount(address _account) public view returns (uint256) {
899         return _stakedBalances[_account].kSeedStaked;
900     }
901     
902     function setRewardsVar(uint256 _amount) public _onlyOwner {
903         rewardsVar = _amount;
904     }
905     
906     function totalStakedSupply() public view returns (uint256) {
907         return _totalkSeedStaked;
908     }
909 
910     function myRewardsBalance(address account) public view returns (uint256) {
911         if (block.number > _stakedBalances[account].lastBlockChecked) {
912             uint256 rewardBlocks = block.number
913                                         .sub(_stakedBalances[account].lastBlockChecked);
914                                         
915                                         
916              
917             if (_stakedBalances[account].kSeedStaked > 0) {
918                 return _stakedBalances[account].rewards
919                                                 .add(
920                                                 _stakedBalances[account].kSeedStaked
921                                                 .mul(rewardBlocks)
922                                                 / rewardsVar);
923             }                                                  
924         }
925 
926     }
927 
928     function stake(uint256 amount) public updateStakingReward(msg.sender) {
929         _totalkSeedStaked = _totalkSeedStaked.add(amount);
930         _stakedBalances[msg.sender].kSeedStaked = _stakedBalances[msg.sender].kSeedStaked.add(amount);
931         kSeedToken.safeTransferFrom(msg.sender, address(this), amount);
932         emit Staked(msg.sender, amount, _totalkSeedStaked);
933     }
934 
935     function withdraw(uint256 amount) public updateStakingReward(msg.sender) {
936         _totalkSeedStaked = _totalkSeedStaked.sub(amount);
937         _stakedBalances[msg.sender].kSeedStaked = _stakedBalances[msg.sender].kSeedStaked.sub(amount);
938         kSeedToken.safeTransfer(msg.sender, amount);
939         emit Withdrawn(msg.sender, amount);
940     }
941     
942    function getReward() public updateStakingReward(msg.sender) {
943        uint256 reward = _stakedBalances[msg.sender].rewards;
944        _stakedBalances[msg.sender].rewards = 0;
945        _mint(msg.sender, reward.mul(8) / 10);
946        uint256 fundingPoolReward = reward.mul(2) / 10;
947        _mint(kSeedAddress, fundingPoolReward);
948        emit Rewards(msg.sender, reward);
949    }
950 
951     
952 }