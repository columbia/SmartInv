1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
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
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
107 // File: @openzeppelin/contracts/math/SafeMath.sol
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
268 // File: @openzeppelin/contracts/utils/Address.sol
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
411 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
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
719 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
720 
721 
722 pragma solidity ^0.6.0;
723 
724 /**
725  * @dev Library for managing
726  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
727  * types.
728  *
729  * Sets have the following properties:
730  *
731  * - Elements are added, removed, and checked for existence in constant time
732  * (O(1)).
733  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
734  *
735  * ```
736  * contract Example {
737  *     // Add the library methods
738  *     using EnumerableSet for EnumerableSet.AddressSet;
739  *
740  *     // Declare a set state variable
741  *     EnumerableSet.AddressSet private mySet;
742  * }
743  * ```
744  *
745  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
746  * (`UintSet`) are supported.
747  */
748 library EnumerableSet {
749     // To implement this library for multiple types with as little code
750     // repetition as possible, we write it in terms of a generic Set type with
751     // bytes32 values.
752     // The Set implementation uses private functions, and user-facing
753     // implementations (such as AddressSet) are just wrappers around the
754     // underlying Set.
755     // This means that we can only create new EnumerableSets for types that fit
756     // in bytes32.
757 
758     struct Set {
759         // Storage of set values
760         bytes32[] _values;
761 
762         // Position of the value in the `values` array, plus 1 because index 0
763         // means a value is not in the set.
764         mapping (bytes32 => uint256) _indexes;
765     }
766 
767     /**
768      * @dev Add a value to a set. O(1).
769      *
770      * Returns true if the value was added to the set, that is if it was not
771      * already present.
772      */
773     function _add(Set storage set, bytes32 value) private returns (bool) {
774         if (!_contains(set, value)) {
775             set._values.push(value);
776             // The value is stored at length-1, but we add 1 to all indexes
777             // and use 0 as a sentinel value
778             set._indexes[value] = set._values.length;
779             return true;
780         } else {
781             return false;
782         }
783     }
784 
785     /**
786      * @dev Removes a value from a set. O(1).
787      *
788      * Returns true if the value was removed from the set, that is if it was
789      * present.
790      */
791     function _remove(Set storage set, bytes32 value) private returns (bool) {
792         // We read and store the value's index to prevent multiple reads from the same storage slot
793         uint256 valueIndex = set._indexes[value];
794 
795         if (valueIndex != 0) { // Equivalent to contains(set, value)
796             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
797             // the array, and then remove the last element (sometimes called as 'swap and pop').
798             // This modifies the order of the array, as noted in {at}.
799 
800             uint256 toDeleteIndex = valueIndex - 1;
801             uint256 lastIndex = set._values.length - 1;
802 
803             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
804             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
805 
806             bytes32 lastvalue = set._values[lastIndex];
807 
808             // Move the last value to the index where the value to delete is
809             set._values[toDeleteIndex] = lastvalue;
810             // Update the index for the moved value
811             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
812 
813             // Delete the slot where the moved value was stored
814             set._values.pop();
815 
816             // Delete the index for the deleted slot
817             delete set._indexes[value];
818 
819             return true;
820         } else {
821             return false;
822         }
823     }
824 
825     /**
826      * @dev Returns true if the value is in the set. O(1).
827      */
828     function _contains(Set storage set, bytes32 value) private view returns (bool) {
829         return set._indexes[value] != 0;
830     }
831 
832     /**
833      * @dev Returns the number of values on the set. O(1).
834      */
835     function _length(Set storage set) private view returns (uint256) {
836         return set._values.length;
837     }
838 
839    /**
840     * @dev Returns the value stored at position `index` in the set. O(1).
841     *
842     * Note that there are no guarantees on the ordering of values inside the
843     * array, and it may change when more values are added or removed.
844     *
845     * Requirements:
846     *
847     * - `index` must be strictly less than {length}.
848     */
849     function _at(Set storage set, uint256 index) private view returns (bytes32) {
850         require(set._values.length > index, "EnumerableSet: index out of bounds");
851         return set._values[index];
852     }
853 
854     // AddressSet
855 
856     struct AddressSet {
857         Set _inner;
858     }
859 
860     /**
861      * @dev Add a value to a set. O(1).
862      *
863      * Returns true if the value was added to the set, that is if it was not
864      * already present.
865      */
866     function add(AddressSet storage set, address value) internal returns (bool) {
867         return _add(set._inner, bytes32(uint256(value)));
868     }
869 
870     /**
871      * @dev Removes a value from a set. O(1).
872      *
873      * Returns true if the value was removed from the set, that is if it was
874      * present.
875      */
876     function remove(AddressSet storage set, address value) internal returns (bool) {
877         return _remove(set._inner, bytes32(uint256(value)));
878     }
879 
880     /**
881      * @dev Returns true if the value is in the set. O(1).
882      */
883     function contains(AddressSet storage set, address value) internal view returns (bool) {
884         return _contains(set._inner, bytes32(uint256(value)));
885     }
886 
887     /**
888      * @dev Returns the number of values in the set. O(1).
889      */
890     function length(AddressSet storage set) internal view returns (uint256) {
891         return _length(set._inner);
892     }
893 
894    /**
895     * @dev Returns the value stored at position `index` in the set. O(1).
896     *
897     * Note that there are no guarantees on the ordering of values inside the
898     * array, and it may change when more values are added or removed.
899     *
900     * Requirements:
901     *
902     * - `index` must be strictly less than {length}.
903     */
904     function at(AddressSet storage set, uint256 index) internal view returns (address) {
905         return address(uint256(_at(set._inner, index)));
906     }
907 
908 
909     // UintSet
910 
911     struct UintSet {
912         Set _inner;
913     }
914 
915     /**
916      * @dev Add a value to a set. O(1).
917      *
918      * Returns true if the value was added to the set, that is if it was not
919      * already present.
920      */
921     function add(UintSet storage set, uint256 value) internal returns (bool) {
922         return _add(set._inner, bytes32(value));
923     }
924 
925     /**
926      * @dev Removes a value from a set. O(1).
927      *
928      * Returns true if the value was removed from the set, that is if it was
929      * present.
930      */
931     function remove(UintSet storage set, uint256 value) internal returns (bool) {
932         return _remove(set._inner, bytes32(value));
933     }
934 
935     /**
936      * @dev Returns true if the value is in the set. O(1).
937      */
938     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
939         return _contains(set._inner, bytes32(value));
940     }
941 
942     /**
943      * @dev Returns the number of values on the set. O(1).
944      */
945     function length(UintSet storage set) internal view returns (uint256) {
946         return _length(set._inner);
947     }
948 
949    /**
950     * @dev Returns the value stored at position `index` in the set. O(1).
951     *
952     * Note that there are no guarantees on the ordering of values inside the
953     * array, and it may change when more values are added or removed.
954     *
955     * Requirements:
956     *
957     * - `index` must be strictly less than {length}.
958     */
959     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
960         return uint256(_at(set._inner, index));
961     }
962 }
963 
964 // File: @openzeppelin/contracts/access/AccessControl.sol
965 
966 
967 pragma solidity ^0.6.0;
968 
969 
970 
971 
972 /**
973  * @dev Contract module that allows children to implement role-based access
974  * control mechanisms.
975  *
976  * Roles are referred to by their `bytes32` identifier. These should be exposed
977  * in the external API and be unique. The best way to achieve this is by
978  * using `public constant` hash digests:
979  *
980  * ```
981  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
982  * ```
983  *
984  * Roles can be used to represent a set of permissions. To restrict access to a
985  * function call, use {hasRole}:
986  *
987  * ```
988  * function foo() public {
989  *     require(hasRole(MY_ROLE, msg.sender));
990  *     ...
991  * }
992  * ```
993  *
994  * Roles can be granted and revoked dynamically via the {grantRole} and
995  * {revokeRole} functions. Each role has an associated admin role, and only
996  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
997  *
998  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
999  * that only accounts with this role will be able to grant or revoke other
1000  * roles. More complex role relationships can be created by using
1001  * {_setRoleAdmin}.
1002  *
1003  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1004  * grant and revoke this role. Extra precautions should be taken to secure
1005  * accounts that have been granted it.
1006  */
1007 abstract contract AccessControl is Context {
1008     using EnumerableSet for EnumerableSet.AddressSet;
1009     using Address for address;
1010 
1011     struct RoleData {
1012         EnumerableSet.AddressSet members;
1013         bytes32 adminRole;
1014     }
1015 
1016     mapping (bytes32 => RoleData) private _roles;
1017 
1018     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1019 
1020     /**
1021      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1022      *
1023      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1024      * {RoleAdminChanged} not being emitted signaling this.
1025      *
1026      * _Available since v3.1._
1027      */
1028     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1029 
1030     /**
1031      * @dev Emitted when `account` is granted `role`.
1032      *
1033      * `sender` is the account that originated the contract call, an admin role
1034      * bearer except when using {_setupRole}.
1035      */
1036     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1037 
1038     /**
1039      * @dev Emitted when `account` is revoked `role`.
1040      *
1041      * `sender` is the account that originated the contract call:
1042      *   - if using `revokeRole`, it is the admin role bearer
1043      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1044      */
1045     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1046 
1047     /**
1048      * @dev Returns `true` if `account` has been granted `role`.
1049      */
1050     function hasRole(bytes32 role, address account) public view returns (bool) {
1051         return _roles[role].members.contains(account);
1052     }
1053 
1054     /**
1055      * @dev Returns the number of accounts that have `role`. Can be used
1056      * together with {getRoleMember} to enumerate all bearers of a role.
1057      */
1058     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1059         return _roles[role].members.length();
1060     }
1061 
1062     /**
1063      * @dev Returns one of the accounts that have `role`. `index` must be a
1064      * value between 0 and {getRoleMemberCount}, non-inclusive.
1065      *
1066      * Role bearers are not sorted in any particular way, and their ordering may
1067      * change at any point.
1068      *
1069      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1070      * you perform all queries on the same block. See the following
1071      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1072      * for more information.
1073      */
1074     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1075         return _roles[role].members.at(index);
1076     }
1077 
1078     /**
1079      * @dev Returns the admin role that controls `role`. See {grantRole} and
1080      * {revokeRole}.
1081      *
1082      * To change a role's admin, use {_setRoleAdmin}.
1083      */
1084     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1085         return _roles[role].adminRole;
1086     }
1087 
1088     /**
1089      * @dev Grants `role` to `account`.
1090      *
1091      * If `account` had not been already granted `role`, emits a {RoleGranted}
1092      * event.
1093      *
1094      * Requirements:
1095      *
1096      * - the caller must have ``role``'s admin role.
1097      */
1098     function grantRole(bytes32 role, address account) public virtual {
1099         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1100 
1101         _grantRole(role, account);
1102     }
1103 
1104     /**
1105      * @dev Revokes `role` from `account`.
1106      *
1107      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1108      *
1109      * Requirements:
1110      *
1111      * - the caller must have ``role``'s admin role.
1112      */
1113     function revokeRole(bytes32 role, address account) public virtual {
1114         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1115 
1116         _revokeRole(role, account);
1117     }
1118 
1119     /**
1120      * @dev Revokes `role` from the calling account.
1121      *
1122      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1123      * purpose is to provide a mechanism for accounts to lose their privileges
1124      * if they are compromised (such as when a trusted device is misplaced).
1125      *
1126      * If the calling account had been granted `role`, emits a {RoleRevoked}
1127      * event.
1128      *
1129      * Requirements:
1130      *
1131      * - the caller must be `account`.
1132      */
1133     function renounceRole(bytes32 role, address account) public virtual {
1134         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1135 
1136         _revokeRole(role, account);
1137     }
1138 
1139     /**
1140      * @dev Grants `role` to `account`.
1141      *
1142      * If `account` had not been already granted `role`, emits a {RoleGranted}
1143      * event. Note that unlike {grantRole}, this function doesn't perform any
1144      * checks on the calling account.
1145      *
1146      * [WARNING]
1147      * ====
1148      * This function should only be called from the constructor when setting
1149      * up the initial roles for the system.
1150      *
1151      * Using this function in any other way is effectively circumventing the admin
1152      * system imposed by {AccessControl}.
1153      * ====
1154      */
1155     function _setupRole(bytes32 role, address account) internal virtual {
1156         _grantRole(role, account);
1157     }
1158 
1159     /**
1160      * @dev Sets `adminRole` as ``role``'s admin role.
1161      *
1162      * Emits a {RoleAdminChanged} event.
1163      */
1164     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1165         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1166         _roles[role].adminRole = adminRole;
1167     }
1168 
1169     function _grantRole(bytes32 role, address account) private {
1170         if (_roles[role].members.add(account)) {
1171             emit RoleGranted(role, account, _msgSender());
1172         }
1173     }
1174 
1175     function _revokeRole(bytes32 role, address account) private {
1176         if (_roles[role].members.remove(account)) {
1177             emit RoleRevoked(role, account, _msgSender());
1178         }
1179     }
1180 }
1181 
1182 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
1183 
1184 
1185 pragma solidity ^0.6.0;
1186 
1187 
1188 
1189 
1190 /**
1191  * @title SafeERC20
1192  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1193  * contract returns false). Tokens that return no value (and instead revert or
1194  * throw on failure) are also supported, non-reverting calls are assumed to be
1195  * successful.
1196  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1197  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1198  */
1199 library SafeERC20 {
1200     using SafeMath for uint256;
1201     using Address for address;
1202 
1203     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1204         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1205     }
1206 
1207     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1208         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1209     }
1210 
1211     /**
1212      * @dev Deprecated. This function has issues similar to the ones found in
1213      * {IERC20-approve}, and its usage is discouraged.
1214      *
1215      * Whenever possible, use {safeIncreaseAllowance} and
1216      * {safeDecreaseAllowance} instead.
1217      */
1218     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1219         // safeApprove should only be called when setting an initial allowance,
1220         // or when resetting it to zero. To increase and decrease it, use
1221         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1222         // solhint-disable-next-line max-line-length
1223         require((value == 0) || (token.allowance(address(this), spender) == 0),
1224             "SafeERC20: approve from non-zero to non-zero allowance"
1225         );
1226         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1227     }
1228 
1229     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1230         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1231         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1232     }
1233 
1234     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1235         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1236         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1237     }
1238 
1239     /**
1240      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1241      * on the return value: the return value is optional (but if data is returned, it must not be false).
1242      * @param token The token targeted by the call.
1243      * @param data The call data (encoded using abi.encode or one of its variants).
1244      */
1245     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1246         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1247         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1248         // the target address contains contract code and also asserts for success in the low-level call.
1249 
1250         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1251         if (returndata.length > 0) { // Return data is optional
1252             // solhint-disable-next-line max-line-length
1253             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1254         }
1255     }
1256 }
1257 
1258 // File: @openzeppelin/contracts/access/Ownable.sol
1259 
1260 
1261 pragma solidity ^0.6.0;
1262 
1263 /**
1264  * @dev Contract module which provides a basic access control mechanism, where
1265  * there is an account (an owner) that can be granted exclusive access to
1266  * specific functions.
1267  *
1268  * By default, the owner account will be the one that deploys the contract. This
1269  * can later be changed with {transferOwnership}.
1270  *
1271  * This module is used through inheritance. It will make available the modifier
1272  * `onlyOwner`, which can be applied to your functions to restrict their use to
1273  * the owner.
1274  */
1275 contract Ownable is Context {
1276     address private _owner;
1277 
1278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1279 
1280     /**
1281      * @dev Initializes the contract setting the deployer as the initial owner.
1282      */
1283     constructor () internal {
1284         address msgSender = _msgSender();
1285         _owner = msgSender;
1286         emit OwnershipTransferred(address(0), msgSender);
1287     }
1288 
1289     /**
1290      * @dev Returns the address of the current owner.
1291      */
1292     function owner() public view returns (address) {
1293         return _owner;
1294     }
1295 
1296     /**
1297      * @dev Throws if called by any account other than the owner.
1298      */
1299     modifier onlyOwner() {
1300         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1301         _;
1302     }
1303 
1304     /**
1305      * @dev Leaves the contract without owner. It will not be possible to call
1306      * `onlyOwner` functions anymore. Can only be called by the current owner.
1307      *
1308      * NOTE: Renouncing ownership will leave the contract without an owner,
1309      * thereby removing any functionality that is only available to the owner.
1310      */
1311     function renounceOwnership() public virtual onlyOwner {
1312         emit OwnershipTransferred(_owner, address(0));
1313         _owner = address(0);
1314     }
1315 
1316     /**
1317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1318      * Can only be called by the current owner.
1319      */
1320     function transferOwnership(address newOwner) public virtual onlyOwner {
1321         require(newOwner != address(0), "Ownable: new owner is the zero address");
1322         emit OwnershipTransferred(_owner, newOwner);
1323         _owner = newOwner;
1324     }
1325 }
1326 
1327 // File: contracts/Claimer.sol
1328 
1329 pragma solidity 0.6.10;
1330 
1331 
1332 
1333 
1334 /**
1335  * @title Reclaimer
1336  * @author Protofire
1337  * @dev Allows owner to claim ERC20 tokens ot ETH sent to this contract.
1338  */
1339 abstract contract Claimer is Ownable {
1340     using SafeERC20 for IERC20;
1341 
1342     /**
1343      * @dev send all token balance of an arbitrary erc20 token
1344      * in the contract to another address
1345      * @param token token to reclaim
1346      * @param _to address to send eth balance to
1347      */
1348     function claimToken(IERC20 token, address _to) external onlyOwner {
1349         uint256 balance = token.balanceOf(address(this));
1350         token.safeTransfer(_to, balance);
1351     }
1352 
1353     /**
1354      * @dev send all eth balance in the contract to another address
1355      * @param _to address to send eth balance to
1356      */
1357     function claimEther(address payable _to) external onlyOwner {
1358         (bool sent, ) = _to.call{value: address(this).balance}("");
1359         require(sent, "Failed to send Ether");
1360     }
1361 }
1362 
1363 // File: contracts/interfaces/IUserRegistry.sol
1364 
1365 
1366 pragma solidity 0.6.10;
1367 
1368 /**
1369  * @dev Interface of the Registry contract.
1370  */
1371 interface IUserRegistry {
1372     function canTransfer(address _from, address _to) external view;
1373 
1374     function canTransferFrom(
1375         address _spender,
1376         address _from,
1377         address _to
1378     ) external view;
1379 
1380     function canMint(address _to) external view;
1381 
1382     function canBurn(address _from, uint256 _amount) external view;
1383 
1384     function canWipe(address _account) external view;
1385 
1386     function isRedeem(address _sender, address _recipient)
1387         external
1388         view
1389         returns (bool);
1390 
1391     function isRedeemFrom(
1392         address _caller,
1393         address _sender,
1394         address _recipient
1395     ) external view returns (bool);
1396 }
1397 
1398 // File: contracts/EURST.sol
1399 
1400 pragma solidity 0.6.10;
1401 
1402 
1403 
1404 
1405 
1406 /**
1407  * @title EURST
1408  * @author Protofire
1409  * @dev Implementation of the EURST stablecoin.
1410  */
1411 contract EURST is ERC20, AccessControl, Claimer {
1412     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1413     bytes32 public constant WIPER_ROLE = keccak256("WIPER_ROLE");
1414     bytes32 public constant REGISTRY_MANAGER_ROLE =
1415         keccak256("REGISTRY_MANAGER_ROLE");
1416 
1417     IUserRegistry public userRegistry;
1418 
1419     event Burn(address indexed burner, uint256 value);
1420     event Mint(address indexed to, uint256 value);
1421     event SetUserRegistry(IUserRegistry indexed userRegistry);
1422     event WipeBlocklistedAccount(address indexed account, uint256 balance);
1423 
1424     /**
1425      * @dev Sets {name} as "EURO Stable Token", {symbol} as "EURST" and {decimals} with 18.
1426      *      Setup roles {DEFAULT_ADMIN_ROLE}, {MINTER_ROLE}, {WIPER_ROLE} and {REGISTRY_MANAGER_ROLE}.
1427      *      Mints `initialSupply` tokens and assigns them to the caller.
1428      */
1429     constructor(
1430         uint256 _initialSupply,
1431         IUserRegistry _userRegistry,
1432         address _minter,
1433         address _wiper,
1434         address _registryManager
1435     ) public ERC20("EURO Stable Token", "EURST") {
1436         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1437         _setupRole(MINTER_ROLE, _minter);
1438         _setupRole(WIPER_ROLE, _wiper);
1439         _setupRole(REGISTRY_MANAGER_ROLE, _registryManager);
1440 
1441         _mint(msg.sender, _initialSupply);
1442 
1443         userRegistry = _userRegistry;
1444 
1445         emit SetUserRegistry(_userRegistry);
1446     }
1447 
1448     /**
1449      * @dev Moves tokens `_amount` from the caller to `_recipient`.
1450      * In case `_recipient` is a redeem address it also Burns `_amount` of tokens from `_recipient`.
1451      *
1452      * Emits a {Transfer} event.
1453      *
1454      * Requirements:
1455      *
1456      * - {userRegistry.canTransfer} should not revert
1457      */
1458     function transfer(address _recipient, uint256 _amount)
1459         public
1460         override
1461         returns (bool)
1462     {
1463         userRegistry.canTransfer(_msgSender(), _recipient);
1464 
1465         super.transfer(_recipient, _amount);
1466 
1467         if (userRegistry.isRedeem(_msgSender(), _recipient)) {
1468             _redeem(_recipient, _amount);
1469         }
1470 
1471         return true;
1472     }
1473 
1474     /**
1475      * @dev Moves tokens `_amount` from `_sender` to `_recipient`.
1476      * In case `_recipient` is a redeem address it also Burns `_amount` of tokens from `_recipient`.
1477      *
1478      * Emits a {Transfer} event.
1479      *
1480      * Requirements:
1481      *
1482      * - {userRegistry.canTransferFrom} should not revert
1483      */
1484     function transferFrom(
1485         address _sender,
1486         address _recipient,
1487         uint256 _amount
1488     ) public override returns (bool) {
1489         userRegistry.canTransferFrom(_msgSender(), _sender, _recipient);
1490 
1491         super.transferFrom(_sender, _recipient, _amount);
1492 
1493         if (userRegistry.isRedeemFrom(_msgSender(), _sender, _recipient)) {
1494             _redeem(_recipient, _amount);
1495         }
1496 
1497         return true;
1498     }
1499 
1500     /**
1501      * @dev Destroys `_amount` tokens from `_to`, reducing the
1502      * total supply.
1503      *
1504      * Emits a {Transfer} event with `to` set to the zero address.
1505      * Emits a {Burn} event with `burner` set to the redeeming address used as recipient in the transfer.
1506      *
1507      * Requirements
1508      *
1509      * - {userRegistry.canBurn} should not revert
1510      */
1511     function _redeem(address _to, uint256 _amount) internal {
1512         userRegistry.canBurn(_to, _amount);
1513 
1514         _burn(_to, _amount);
1515 
1516         emit Burn(_to, _amount);
1517     }
1518 
1519     /** @dev Creates `_amount` tokens and assigns them to `_to`, increasing
1520      * the total supply.
1521      *
1522      * Emits a {Transfer} event with `from` set to the zero address.
1523      * Emits a {Mint} event with `to` set to the `_to` address.
1524      *
1525      * Requirements
1526      *
1527      * - the caller should have {MINTER_ROLE} role.
1528      * - {userRegistry.canMint} should not revert
1529      */
1530     function mint(address _to, uint256 _amount) public onlyMinter {
1531         userRegistry.canMint(_to);
1532 
1533         _mint(_to, _amount);
1534 
1535         emit Mint(_to, _amount);
1536     }
1537 
1538     /**
1539      * @dev Destroys the tokens owned by a blocklisted `_account`, reducing the
1540      * total supply.
1541      *
1542      * Emits a {Transfer} event with `to` set to the zero address.
1543      * Emits a {WipeBlocklistedAccount} event with `account` set to the `_account` address.
1544      *
1545      * Requirements
1546      *
1547      * - the caller should have {WIPER_ROLE} role.
1548      * - {userRegistry.canWipe} should not revert
1549      */
1550     function wipeBlocklistedAccount(address _account) public onlyWiper {
1551         userRegistry.canWipe(_account);
1552 
1553         uint256 accountBlance = balanceOf(_account);
1554 
1555         _burn(_account, accountBlance);
1556 
1557         emit WipeBlocklistedAccount(_account, accountBlance);
1558     }
1559 
1560     /**
1561      * @dev Sets the {userRegistry} address
1562      *
1563      * Emits a {SetUserRegistry}.
1564      *
1565      * Requirements
1566      *
1567      * - the caller should have {REGISTRY_MANAGER_ROLE} role.
1568      */
1569     function setUserRegistry(IUserRegistry _userRegistry)
1570         public
1571         onlyRegistryManager
1572     {
1573         userRegistry = _userRegistry;
1574         emit SetUserRegistry(userRegistry);
1575     }
1576 
1577     /**
1578      * @dev Throws if called by any account which does not have MINTER_ROLE.
1579      */
1580     modifier onlyMinter {
1581         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1582 
1583         _;
1584     }
1585 
1586     /**
1587      * @dev Throws if called by any account which does not have WIPER_ROLE.
1588      */
1589     modifier onlyWiper {
1590         require(hasRole(WIPER_ROLE, msg.sender), "Caller is not a wiper");
1591 
1592         _;
1593     }
1594 
1595     /**
1596      * @dev Throws if called by any account which does not have REGISTRY_MANAGER_ROLE.
1597      */
1598     modifier onlyRegistryManager {
1599         require(
1600             hasRole(REGISTRY_MANAGER_ROLE, msg.sender),
1601             "Caller is not a registry manager"
1602         );
1603 
1604         _;
1605     }
1606 }