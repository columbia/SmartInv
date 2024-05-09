1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
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
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: @openzeppelin/contracts/math/SafeMath.sol
107 
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
271 
272 pragma solidity ^0.6.2;
273 
274 /**
275  * @dev Collection of functions related to the address type
276  */
277 library Address {
278     /**
279      * @dev Returns true if `account` is a contract.
280      *
281      * [IMPORTANT]
282      * ====
283      * It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      *
286      * Among others, `isContract` will return false for the following
287      * types of addresses:
288      *
289      *  - an externally-owned account
290      *  - a contract in construction
291      *  - an address where a contract will be created
292      *  - an address where a contract lived, but was destroyed
293      * ====
294      */
295     function isContract(address account) internal view returns (bool) {
296         // This method relies in extcodesize, which returns 0 for contracts in
297         // construction, since the code is only stored at the end of the
298         // constructor execution.
299 
300         uint256 size;
301         // solhint-disable-next-line no-inline-assembly
302         assembly { size := extcodesize(account) }
303         return size > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
326         (bool success, ) = recipient.call{ value: amount }("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain`call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349       return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
359         return _functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
384         require(address(this).balance >= value, "Address: insufficient balance for call");
385         return _functionCallWithValue(target, data, value, errorMessage);
386     }
387 
388     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
389         require(isContract(target), "Address: call to non-contract");
390 
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399 
400                 // solhint-disable-next-line no-inline-assembly
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
413 
414 
415 
416 pragma solidity ^0.6.0;
417 
418 
419 
420 
421 
422 /**
423  * @dev Implementation of the {IERC20} interface.
424  *
425  * This implementation is agnostic to the way tokens are created. This means
426  * that a supply mechanism has to be added in a derived contract using {_mint}.
427  * For a generic mechanism see {ERC20PresetMinterPauser}.
428  *
429  * TIP: For a detailed writeup see our guide
430  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
431  * to implement supply mechanisms].
432  *
433  * We have followed general OpenZeppelin guidelines: functions revert instead
434  * of returning `false` on failure. This behavior is nonetheless conventional
435  * and does not conflict with the expectations of ERC20 applications.
436  *
437  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
438  * This allows applications to reconstruct the allowance for all accounts just
439  * by listening to said events. Other implementations of the EIP may not emit
440  * these events, as it isn't required by the specification.
441  *
442  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
443  * functions have been added to mitigate the well-known issues around setting
444  * allowances. See {IERC20-approve}.
445  */
446 contract ERC20 is Context, IERC20 {
447     using SafeMath for uint256;
448     using Address for address;
449 
450     mapping (address => uint256) private _balances;
451 
452     mapping (address => mapping (address => uint256)) private _allowances;
453 
454     uint256 private _totalSupply;
455 
456     string private _name;
457     string private _symbol;
458     uint8 private _decimals;
459 
460     /**
461      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
462      * a default value of 18.
463      *
464      * To select a different value for {decimals}, use {_setupDecimals}.
465      *
466      * All three of these values are immutable: they can only be set once during
467      * construction.
468      */
469     constructor (string memory name, string memory symbol) public {
470         _name = name;
471         _symbol = symbol;
472         _decimals = 18;
473     }
474 
475     /**
476      * @dev Returns the name of the token.
477      */
478     function name() public view returns (string memory) {
479         return _name;
480     }
481 
482     /**
483      * @dev Returns the symbol of the token, usually a shorter version of the
484      * name.
485      */
486     function symbol() public view returns (string memory) {
487         return _symbol;
488     }
489 
490     /**
491      * @dev Returns the number of decimals used to get its user representation.
492      * For example, if `decimals` equals `2`, a balance of `505` tokens should
493      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
494      *
495      * Tokens usually opt for a value of 18, imitating the relationship between
496      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
497      * called.
498      *
499      * NOTE: This information is only used for _display_ purposes: it in
500      * no way affects any of the arithmetic of the contract, including
501      * {IERC20-balanceOf} and {IERC20-transfer}.
502      */
503     function decimals() public view returns (uint8) {
504         return _decimals;
505     }
506 
507     /**
508      * @dev See {IERC20-totalSupply}.
509      */
510     function totalSupply() public view override returns (uint256) {
511         return _totalSupply;
512     }
513 
514     /**
515      * @dev See {IERC20-balanceOf}.
516      */
517     function balanceOf(address account) public view override returns (uint256) {
518         return _balances[account];
519     }
520 
521     /**
522      * @dev See {IERC20-transfer}.
523      *
524      * Requirements:
525      *
526      * - `recipient` cannot be the zero address.
527      * - the caller must have a balance of at least `amount`.
528      */
529     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
530         _transfer(_msgSender(), recipient, amount);
531         return true;
532     }
533 
534     /**
535      * @dev See {IERC20-allowance}.
536      */
537     function allowance(address owner, address spender) public view virtual override returns (uint256) {
538         return _allowances[owner][spender];
539     }
540 
541     /**
542      * @dev See {IERC20-approve}.
543      *
544      * Requirements:
545      *
546      * - `spender` cannot be the zero address.
547      */
548     function approve(address spender, uint256 amount) public virtual override returns (bool) {
549         _approve(_msgSender(), spender, amount);
550         return true;
551     }
552 
553     /**
554      * @dev See {IERC20-transferFrom}.
555      *
556      * Emits an {Approval} event indicating the updated allowance. This is not
557      * required by the EIP. See the note at the beginning of {ERC20};
558      *
559      * Requirements:
560      * - `sender` and `recipient` cannot be the zero address.
561      * - `sender` must have a balance of at least `amount`.
562      * - the caller must have allowance for ``sender``'s tokens of at least
563      * `amount`.
564      */
565     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
566         _transfer(sender, recipient, amount);
567         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
568         return true;
569     }
570 
571     /**
572      * @dev Atomically increases the allowance granted to `spender` by the caller.
573      *
574      * This is an alternative to {approve} that can be used as a mitigation for
575      * problems described in {IERC20-approve}.
576      *
577      * Emits an {Approval} event indicating the updated allowance.
578      *
579      * Requirements:
580      *
581      * - `spender` cannot be the zero address.
582      */
583     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
584         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
585         return true;
586     }
587 
588     /**
589      * @dev Atomically decreases the allowance granted to `spender` by the caller.
590      *
591      * This is an alternative to {approve} that can be used as a mitigation for
592      * problems described in {IERC20-approve}.
593      *
594      * Emits an {Approval} event indicating the updated allowance.
595      *
596      * Requirements:
597      *
598      * - `spender` cannot be the zero address.
599      * - `spender` must have allowance for the caller of at least
600      * `subtractedValue`.
601      */
602     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
603         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
604         return true;
605     }
606 
607     /**
608      * @dev Moves tokens `amount` from `sender` to `recipient`.
609      *
610      * This is internal function is equivalent to {transfer}, and can be used to
611      * e.g. implement automatic token fees, slashing mechanisms, etc.
612      *
613      * Emits a {Transfer} event.
614      *
615      * Requirements:
616      *
617      * - `sender` cannot be the zero address.
618      * - `recipient` cannot be the zero address.
619      * - `sender` must have a balance of at least `amount`.
620      */
621     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
622         require(sender != address(0), "ERC20: transfer from the zero address");
623         require(recipient != address(0), "ERC20: transfer to the zero address");
624 
625         _beforeTokenTransfer(sender, recipient, amount);
626 
627         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
628         _balances[recipient] = _balances[recipient].add(amount);
629         emit Transfer(sender, recipient, amount);
630     }
631 
632     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
633      * the total supply.
634      *
635      * Emits a {Transfer} event with `from` set to the zero address.
636      *
637      * Requirements
638      *
639      * - `to` cannot be the zero address.
640      */
641     function _mint(address account, uint256 amount) internal virtual {
642         require(account != address(0), "ERC20: mint to the zero address");
643 
644         _beforeTokenTransfer(address(0), account, amount);
645 
646         _totalSupply = _totalSupply.add(amount);
647         _balances[account] = _balances[account].add(amount);
648         emit Transfer(address(0), account, amount);
649     }
650 
651     /**
652      * @dev Destroys `amount` tokens from `account`, reducing the
653      * total supply.
654      *
655      * Emits a {Transfer} event with `to` set to the zero address.
656      *
657      * Requirements
658      *
659      * - `account` cannot be the zero address.
660      * - `account` must have at least `amount` tokens.
661      */
662     function _burn(address account, uint256 amount) internal virtual {
663         require(account != address(0), "ERC20: burn from the zero address");
664 
665         _beforeTokenTransfer(account, address(0), amount);
666 
667         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
668         _totalSupply = _totalSupply.sub(amount);
669         emit Transfer(account, address(0), amount);
670     }
671 
672     /**
673      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
674      *
675      * This internal function is equivalent to `approve`, and can be used to
676      * e.g. set automatic allowances for certain subsystems, etc.
677      *
678      * Emits an {Approval} event.
679      *
680      * Requirements:
681      *
682      * - `owner` cannot be the zero address.
683      * - `spender` cannot be the zero address.
684      */
685     function _approve(address owner, address spender, uint256 amount) internal virtual {
686         require(owner != address(0), "ERC20: approve from the zero address");
687         require(spender != address(0), "ERC20: approve to the zero address");
688 
689         _allowances[owner][spender] = amount;
690         emit Approval(owner, spender, amount);
691     }
692 
693     /**
694      * @dev Sets {decimals} to a value other than the default one of 18.
695      *
696      * WARNING: This function should only be called from the constructor. Most
697      * applications that interact with token contracts will not expect
698      * {decimals} to ever change, and may work incorrectly if it does.
699      */
700     function _setupDecimals(uint8 decimals_) internal {
701         _decimals = decimals_;
702     }
703 
704     /**
705      * @dev Hook that is called before any transfer of tokens. This includes
706      * minting and burning.
707      *
708      * Calling conditions:
709      *
710      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
711      * will be to transferred to `to`.
712      * - when `from` is zero, `amount` tokens will be minted for `to`.
713      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
714      * - `from` and `to` are never both zero.
715      *
716      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
717      */
718     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
722 
723 
724 
725 pragma solidity ^0.6.0;
726 
727 
728 
729 
730 /**
731  * @title SafeERC20
732  * @dev Wrappers around ERC20 operations that throw on failure (when the token
733  * contract returns false). Tokens that return no value (and instead revert or
734  * throw on failure) are also supported, non-reverting calls are assumed to be
735  * successful.
736  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
737  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
738  */
739 library SafeERC20 {
740     using SafeMath for uint256;
741     using Address for address;
742 
743     function safeTransfer(IERC20 token, address to, uint256 value) internal {
744         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
745     }
746 
747     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
748         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
749     }
750 
751     /**
752      * @dev Deprecated. This function has issues similar to the ones found in
753      * {IERC20-approve}, and its usage is discouraged.
754      *
755      * Whenever possible, use {safeIncreaseAllowance} and
756      * {safeDecreaseAllowance} instead.
757      */
758     function safeApprove(IERC20 token, address spender, uint256 value) internal {
759         // safeApprove should only be called when setting an initial allowance,
760         // or when resetting it to zero. To increase and decrease it, use
761         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
762         // solhint-disable-next-line max-line-length
763         require((value == 0) || (token.allowance(address(this), spender) == 0),
764             "SafeERC20: approve from non-zero to non-zero allowance"
765         );
766         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
767     }
768 
769     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
770         uint256 newAllowance = token.allowance(address(this), spender).add(value);
771         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
772     }
773 
774     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
775         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
776         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
777     }
778 
779     /**
780      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
781      * on the return value: the return value is optional (but if data is returned, it must not be false).
782      * @param token The token targeted by the call.
783      * @param data The call data (encoded using abi.encode or one of its variants).
784      */
785     function _callOptionalReturn(IERC20 token, bytes memory data) private {
786         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
787         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
788         // the target address contains contract code and also asserts for success in the low-level call.
789 
790         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
791         if (returndata.length > 0) { // Return data is optional
792             // solhint-disable-next-line max-line-length
793             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
794         }
795     }
796 }
797 
798 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
799 
800 
801 
802 pragma solidity ^0.6.0;
803 
804 /**
805  * @dev Contract module that helps prevent reentrant calls to a function.
806  *
807  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
808  * available, which can be applied to functions to make sure there are no nested
809  * (reentrant) calls to them.
810  *
811  * Note that because there is a single `nonReentrant` guard, functions marked as
812  * `nonReentrant` may not call one another. This can be worked around by making
813  * those functions `private`, and then adding `external` `nonReentrant` entry
814  * points to them.
815  *
816  * TIP: If you would like to learn more about reentrancy and alternative ways
817  * to protect against it, check out our blog post
818  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
819  */
820 contract ReentrancyGuard {
821     // Booleans are more expensive than uint256 or any type that takes up a full
822     // word because each write operation emits an extra SLOAD to first read the
823     // slot's contents, replace the bits taken up by the boolean, and then write
824     // back. This is the compiler's defense against contract upgrades and
825     // pointer aliasing, and it cannot be disabled.
826 
827     // The values being non-zero value makes deployment a bit more expensive,
828     // but in exchange the refund on every call to nonReentrant will be lower in
829     // amount. Since refunds are capped to a percentage of the total
830     // transaction's gas, it is best to keep them low in cases like this one, to
831     // increase the likelihood of the full refund coming into effect.
832     uint256 private constant _NOT_ENTERED = 1;
833     uint256 private constant _ENTERED = 2;
834 
835     uint256 private _status;
836 
837     constructor () internal {
838         _status = _NOT_ENTERED;
839     }
840 
841     /**
842      * @dev Prevents a contract from calling itself, directly or indirectly.
843      * Calling a `nonReentrant` function from another `nonReentrant`
844      * function is not supported. It is possible to prevent this from happening
845      * by making the `nonReentrant` function external, and make it call a
846      * `private` function that does the actual work.
847      */
848     modifier nonReentrant() {
849         // On the first call to nonReentrant, _notEntered will be true
850         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
851 
852         // Any calls to nonReentrant after this point will fail
853         _status = _ENTERED;
854 
855         _;
856 
857         // By storing the original value once again, a refund is triggered (see
858         // https://eips.ethereum.org/EIPS/eip-2200)
859         _status = _NOT_ENTERED;
860     }
861 }
862 
863 // File: contracts/Pausable.sol
864 
865 
866 
867 pragma solidity 0.6.12;
868 
869 
870 /**
871  * @dev Contract module which allows children to implement an emergency stop
872  * mechanism that can be triggered by an authorized account.
873  *
874  */
875 contract Pausable is Context {
876     event Paused(address account);
877     event Shutdown(address account);
878     event Unpaused(address account);
879     event Open(address account);
880 
881     bool public paused;
882     bool public stopEverything;
883 
884     modifier whenNotPaused() {
885         require(!paused, "Pausable: paused");
886         _;
887     }
888     modifier whenPaused() {
889         require(paused, "Pausable: not paused");
890         _;
891     }
892 
893     modifier whenNotShutdown() {
894         require(!stopEverything, "Pausable: shutdown");
895         _;
896     }
897 
898     modifier whenShutdown() {
899         require(stopEverything, "Pausable: not shutdown");
900         _;
901     }
902 
903     /// @dev Pause contract operations, if contract is not paused.
904     function _pause() internal virtual whenNotPaused {
905         paused = true;
906         emit Paused(_msgSender());
907     }
908 
909     /// @dev Unpause contract operations, allow only if contract is paused and not shutdown.
910     function _unpause() internal virtual whenPaused whenNotShutdown {
911         paused = false;
912         emit Unpaused(_msgSender());
913     }
914 
915     /// @dev Shutdown contract operations, if not already shutdown.
916     function _shutdown() internal virtual whenNotShutdown {
917         stopEverything = true;
918         paused = true;
919         emit Shutdown(_msgSender());
920     }
921 
922     /// @dev Open contract operations, if contract is in shutdown state
923     function _open() internal virtual whenShutdown {
924         stopEverything = false;
925         emit Open(_msgSender());
926     }
927 }
928 
929 // File: contracts/interfaces/vesper/IController.sol
930 
931 
932 
933 pragma solidity 0.6.12;
934 
935 interface IController {
936     function aaveReferralCode() external view returns (uint16);
937 
938     function feeCollector(address) external view returns (address);
939 
940     function founderFee() external view returns (uint256);
941 
942     function founderVault() external view returns (address);
943 
944     function interestFee(address) external view returns (uint256);
945 
946     function isPool(address) external view returns (bool);
947 
948     function pools() external view returns (address);
949 
950     function strategy(address) external view returns (address);
951 
952     function rebalanceFriction(address) external view returns (uint256);
953 
954     function poolRewards(address) external view returns (address);
955 
956     function treasuryPool() external view returns (address);
957 
958     function uniswapRouter() external view returns (address);
959 
960     function withdrawFee(address) external view returns (uint256);
961 }
962 
963 // File: contracts/interfaces/vesper/IVesperPool.sol
964 
965 
966 
967 pragma solidity 0.6.12;
968 
969 
970 interface IVesperPool is IERC20 {
971     function approveToken() external;
972 
973     function deposit() external payable;
974 
975     function deposit(uint256) external;
976 
977     function multiTransfer(uint256[] memory) external returns (bool);
978 
979     function permit(
980         address,
981         address,
982         uint256,
983         uint256,
984         uint8,
985         bytes32,
986         bytes32
987     ) external;
988 
989     function rebalance() external;
990 
991     function resetApproval() external;
992 
993     function sweepErc20(address) external;
994 
995     function withdraw(uint256) external;
996 
997     function withdrawETH(uint256) external;
998 
999     function withdrawByStrategy(uint256) external;
1000 
1001     function feeCollector() external view returns (address);
1002 
1003     function getPricePerShare() external view returns (uint256);
1004 
1005     function token() external view returns (address);
1006 
1007     function tokensHere() external view returns (uint256);
1008 
1009     function totalValue() external view returns (uint256);
1010 
1011     function withdrawFee() external view returns (uint256);
1012 }
1013 
1014 // File: contracts/interfaces/vesper/IPoolRewards.sol
1015 
1016 
1017 
1018 pragma solidity 0.6.12;
1019 
1020 interface IPoolRewards {
1021     function notifyRewardAmount(uint256) external;
1022 
1023     function claimReward(address) external;
1024 
1025     function updateReward(address) external;
1026 
1027     function rewardForDuration() external view returns (uint256);
1028 
1029     function claimable(address) external view returns (uint256);
1030 
1031     function pool() external view returns (address);
1032 
1033     function lastTimeRewardApplicable() external view returns (uint256);
1034 
1035     function rewardPerToken() external view returns (uint256);
1036 }
1037 
1038 // File: sol-address-list/contracts/interfaces/IAddressList.sol
1039 
1040 
1041 
1042 pragma solidity ^0.6.6;
1043 
1044 interface IAddressList {
1045     event AddressUpdated(address indexed a, address indexed sender);
1046     event AddressRemoved(address indexed a, address indexed sender);
1047 
1048     function add(address a) external returns (bool);
1049 
1050     function addValue(address a, uint256 v) external returns (bool);
1051 
1052     function addMulti(address[] calldata addrs) external returns (uint256);
1053 
1054     function addValueMulti(address[] calldata addrs, uint256[] calldata values) external returns (uint256);
1055 
1056     function remove(address a) external returns (bool);
1057 
1058     function removeMulti(address[] calldata addrs) external returns (uint256);
1059 
1060     function get(address a) external view returns (uint256);
1061 
1062     function contains(address a) external view returns (bool);
1063 
1064     function at(uint256 index) external view returns (address, uint256);
1065 
1066     function length() external view returns (uint256);
1067 }
1068 
1069 // File: sol-address-list/contracts/interfaces/IAddressListExt.sol
1070 
1071 
1072 
1073 pragma solidity ^0.6.6;
1074 
1075 
1076 interface IAddressListExt is IAddressList {
1077     function hasRole(bytes32 role, address account) external view returns (bool);
1078 
1079     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1080 
1081     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1082 
1083     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1084 
1085     function grantRole(bytes32 role, address account) external;
1086 
1087     function revokeRole(bytes32 role, address account) external;
1088 
1089     function renounceRole(bytes32 role, address account) external;
1090 }
1091 
1092 // File: sol-address-list/contracts/interfaces/IAddressListFactory.sol
1093 
1094 
1095 
1096 pragma solidity ^0.6.6;
1097 
1098 interface IAddressListFactory {
1099     event ListCreated(address indexed _sender, address indexed _newList);
1100 
1101     function ours(address a) external view returns (bool);
1102 
1103     function listCount() external view returns (uint256);
1104 
1105     function listAt(uint256 idx) external view returns (address);
1106 
1107     function createList() external returns (address listaddr);
1108 }
1109 
1110 // File: contracts/pools/PoolShareToken.sol
1111 
1112 
1113 
1114 pragma solidity 0.6.12;
1115 
1116 
1117 
1118 
1119 
1120 
1121 
1122 
1123 
1124 
1125 /// @title Holding pool share token
1126 // solhint-disable no-empty-blocks
1127 abstract contract PoolShareToken is ERC20, Pausable, ReentrancyGuard {
1128     using SafeERC20 for IERC20;
1129     IERC20 public immutable token;
1130     IAddressListExt public immutable feeWhiteList;
1131     IController public immutable controller;
1132 
1133     /// @dev The EIP-712 typehash for the contract's domain
1134     bytes32 public constant DOMAIN_TYPEHASH =
1135         keccak256(
1136             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1137         );
1138 
1139     /// @dev The EIP-712 typehash for the permit struct used by the contract
1140     bytes32 public constant PERMIT_TYPEHASH =
1141         keccak256(
1142             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
1143         );
1144 
1145     bytes32 public immutable domainSeparator;
1146 
1147     uint256 internal constant MAX_UINT_VALUE = uint256(-1);
1148     mapping(address => uint256) public nonces;
1149     event Deposit(address indexed owner, uint256 shares, uint256 amount);
1150     event Withdraw(address indexed owner, uint256 shares, uint256 amount);
1151 
1152     constructor(
1153         string memory _name,
1154         string memory _symbol,
1155         address _token,
1156         address _controller
1157     ) public ERC20(_name, _symbol) {
1158         uint256 chainId;
1159         assembly {
1160             chainId := chainid()
1161         }
1162         token = IERC20(_token);
1163         controller = IController(_controller);
1164         IAddressListFactory factory =
1165             IAddressListFactory(0xD57b41649f822C51a73C44Ba0B3da4A880aF0029);
1166         IAddressListExt _feeWhiteList = IAddressListExt(factory.createList());
1167         _feeWhiteList.grantRole(keccak256("LIST_ADMIN"), _controller);
1168         feeWhiteList = _feeWhiteList;
1169         domainSeparator = keccak256(
1170             abi.encode(
1171                 DOMAIN_TYPEHASH,
1172                 keccak256(bytes(_name)),
1173                 keccak256(bytes("1")),
1174                 chainId,
1175                 address(this)
1176             )
1177         );
1178     }
1179 
1180     /**
1181      * @notice Deposit ERC20 tokens and receive pool shares depending on the current share price.
1182      * @param amount ERC20 token amount.
1183      */
1184     function deposit(uint256 amount) external virtual nonReentrant whenNotPaused {
1185         _deposit(amount);
1186     }
1187 
1188     /**
1189      * @notice Deposit ERC20 tokens with permit aka gasless approval.
1190      * @param amount ERC20 token amount.
1191      * @param deadline The time at which signature will expire
1192      * @param v The recovery byte of the signature
1193      * @param r Half of the ECDSA signature pair
1194      * @param s Half of the ECDSA signature pair
1195      */
1196     function depositWithPermit(
1197         uint256 amount,
1198         uint256 deadline,
1199         uint8 v,
1200         bytes32 r,
1201         bytes32 s
1202     ) external virtual nonReentrant whenNotPaused {
1203         IVesperPool(address(token)).permit(_msgSender(), address(this), amount, deadline, v, r, s);
1204         _deposit(amount);
1205     }
1206 
1207     /**
1208      * @notice Withdraw collateral based on given shares and the current share price.
1209      * Transfer earned rewards to caller. Withdraw fee, if any, will be deduced from
1210      * given shares and transferred to feeCollector. Burn remaining shares and return collateral.
1211      * @param shares Pool shares. It will be in 18 decimals.
1212      */
1213     function withdraw(uint256 shares) external virtual nonReentrant whenNotShutdown {
1214         _withdraw(shares);
1215     }
1216 
1217     /**
1218      * @notice Withdraw collateral based on given shares and the current share price.
1219      * Transfer earned rewards to caller. Burn shares and return collateral.
1220      * @dev No withdraw fee will be assessed when this function is called.
1221      * Only some white listed address can call this function.
1222      * @param shares Pool shares. It will be in 18 decimals.
1223      */
1224     function withdrawByStrategy(uint256 shares) external virtual nonReentrant whenNotShutdown {
1225         require(feeWhiteList.get(_msgSender()) != 0, "Not a white listed address");
1226         _withdrawByStrategy(shares);
1227     }
1228 
1229     /**
1230      * @notice Transfer tokens to multiple recipient
1231      * @dev Left 160 bits are the recipient address and the right 96 bits are the token amount.
1232      * @param bits array of uint
1233      * @return true/false
1234      */
1235     function multiTransfer(uint256[] memory bits) external returns (bool) {
1236         for (uint256 i = 0; i < bits.length; i++) {
1237             address a = address(bits[i] >> 96);
1238             uint256 amount = bits[i] & ((1 << 96) - 1);
1239             require(transfer(a, amount), "Transfer failed");
1240         }
1241         return true;
1242     }
1243 
1244     /**
1245      * @notice Triggers an approval from owner to spends
1246      * @param owner The address to approve from
1247      * @param spender The address to be approved
1248      * @param amount The number of tokens that are approved (2^256-1 means infinite)
1249      * @param deadline The time at which to expire the signature
1250      * @param v The recovery byte of the signature
1251      * @param r Half of the ECDSA signature pair
1252      * @param s Half of the ECDSA signature pair
1253      */
1254     function permit(
1255         address owner,
1256         address spender,
1257         uint256 amount,
1258         uint256 deadline,
1259         uint8 v,
1260         bytes32 r,
1261         bytes32 s
1262     ) external {
1263         require(deadline >= block.timestamp, "Expired");
1264         bytes32 digest =
1265             keccak256(
1266                 abi.encodePacked(
1267                     "\x19\x01",
1268                     domainSeparator,
1269                     keccak256(
1270                         abi.encode(
1271                             PERMIT_TYPEHASH,
1272                             owner,
1273                             spender,
1274                             amount,
1275                             nonces[owner]++,
1276                             deadline
1277                         )
1278                     )
1279                 )
1280             );
1281         address signatory = ecrecover(digest, v, r, s);
1282         require(signatory != address(0) && signatory == owner, "Invalid signature");
1283         _approve(owner, spender, amount);
1284     }
1285 
1286     /**
1287      * @notice Get price per share
1288      * @dev Return value will be in token defined decimals.
1289      */
1290     function getPricePerShare() external view returns (uint256) {
1291         if (totalSupply() == 0) {
1292             return convertFrom18(1e18);
1293         }
1294         return totalValue().mul(1e18).div(totalSupply());
1295     }
1296 
1297     /// @dev Convert to 18 decimals from token defined decimals. Default no conversion.
1298     function convertTo18(uint256 amount) public pure virtual returns (uint256) {
1299         return amount;
1300     }
1301 
1302     /// @dev Convert from 18 decimals to token defined decimals. Default no conversion.
1303     function convertFrom18(uint256 amount) public pure virtual returns (uint256) {
1304         return amount;
1305     }
1306 
1307     /// @dev Get fee collector address
1308     function feeCollector() public view virtual returns (address) {
1309         return controller.feeCollector(address(this));
1310     }
1311 
1312     /// @dev Returns the token stored in the pool. It will be in token defined decimals.
1313     function tokensHere() public view virtual returns (uint256) {
1314         return token.balanceOf(address(this));
1315     }
1316 
1317     /**
1318      * @dev Returns sum of token locked in other contracts and token stored in the pool.
1319      * Default tokensHere. It will be in token defined decimals.
1320      */
1321     function totalValue() public view virtual returns (uint256) {
1322         return tokensHere();
1323     }
1324 
1325     /**
1326      * @notice Get withdraw fee for this pool
1327      * @dev Format: 1e16 = 1% fee
1328      */
1329     function withdrawFee() public view virtual returns (uint256) {
1330         return controller.withdrawFee(address(this));
1331     }
1332 
1333     /**
1334      * @dev Hook that is called just before burning tokens. To be used i.e. if
1335      * collateral is stored in a different contract and needs to be withdrawn.
1336      * @param share Pool share in 18 decimals
1337      */
1338     function _beforeBurning(uint256 share) internal virtual {}
1339 
1340     /**
1341      * @dev Hook that is called just after burning tokens. To be used i.e. if
1342      * collateral stored in a different/this contract needs to be transferred.
1343      * @param amount Collateral amount in collateral token defined decimals.
1344      */
1345     function _afterBurning(uint256 amount) internal virtual {}
1346 
1347     /**
1348      * @dev Hook that is called just before minting new tokens. To be used i.e.
1349      * if the deposited amount is to be transferred from user to this contract.
1350      * @param amount Collateral amount in collateral token defined decimals.
1351      */
1352     function _beforeMinting(uint256 amount) internal virtual {}
1353 
1354     /**
1355      * @dev Hook that is called just after minting new tokens. To be used i.e.
1356      * if the deposited amount is to be transferred to a different contract.
1357      * @param amount Collateral amount in collateral token defined decimals.
1358      */
1359     function _afterMinting(uint256 amount) internal virtual {}
1360 
1361     /**
1362      * @dev Calculate shares to mint based on the current share price and given amount.
1363      * @param amount Collateral amount in collateral token defined decimals.
1364      */
1365     function _calculateShares(uint256 amount) internal view returns (uint256) {
1366         require(amount != 0, "amount is 0");
1367 
1368         uint256 _totalSupply = totalSupply();
1369         uint256 _totalValue = convertTo18(totalValue());
1370         uint256 shares =
1371             (_totalSupply == 0 || _totalValue == 0)
1372                 ? amount
1373                 : amount.mul(_totalSupply).div(_totalValue);
1374         return shares;
1375     }
1376 
1377     /// @dev Deposit incoming token and mint pool token i.e. shares.
1378     function _deposit(uint256 amount) internal whenNotPaused {
1379         uint256 shares = _calculateShares(convertTo18(amount));
1380         _beforeMinting(amount);
1381         _mint(_msgSender(), shares);
1382         _afterMinting(amount);
1383         emit Deposit(_msgSender(), shares, amount);
1384     }
1385 
1386     /// @dev Handle withdraw fee calculation and fee transfer to fee collector.
1387     function _handleFee(uint256 shares) internal returns (uint256 _sharesAfterFee) {
1388         if (withdrawFee() != 0) {
1389             uint256 _fee = shares.mul(withdrawFee()).div(1e18);
1390             _sharesAfterFee = shares.sub(_fee);
1391             _transfer(_msgSender(), feeCollector(), _fee);
1392         } else {
1393             _sharesAfterFee = shares;
1394         }
1395     }
1396 
1397     /// @dev Update pool reward of sender and receiver before transfer.
1398     function _beforeTokenTransfer(
1399         address from,
1400         address to,
1401         uint256 /* amount */
1402     ) internal virtual override {
1403         address poolRewards = controller.poolRewards(address(this));
1404         if (poolRewards != address(0)) {
1405             if (from != address(0)) {
1406                 IPoolRewards(poolRewards).updateReward(from);
1407             }
1408             if (to != address(0)) {
1409                 IPoolRewards(poolRewards).updateReward(to);
1410             }
1411         }
1412     }
1413 
1414     /// @dev Burns shares and returns the collateral value, after fee, of those.
1415     function _withdraw(uint256 shares) internal whenNotShutdown {
1416         require(shares != 0, "share is 0");
1417         _beforeBurning(shares);
1418         uint256 sharesAfterFee = _handleFee(shares);
1419         uint256 amount =
1420             convertFrom18(sharesAfterFee.mul(convertTo18(totalValue())).div(totalSupply()));
1421 
1422         _burn(_msgSender(), sharesAfterFee);
1423         _afterBurning(amount);
1424         emit Withdraw(_msgSender(), shares, amount);
1425     }
1426 
1427     /// @dev Burns shares and returns the collateral value of those.
1428     function _withdrawByStrategy(uint256 shares) internal {
1429         require(shares != 0, "Withdraw must be greater than 0");
1430         _beforeBurning(shares);
1431         uint256 amount = convertFrom18(shares.mul(convertTo18(totalValue())).div(totalSupply()));
1432         _burn(_msgSender(), shares);
1433         _afterBurning(amount);
1434         emit Withdraw(_msgSender(), shares, amount);
1435     }
1436 }
1437 
1438 // File: contracts/interfaces/uniswap/IUniswapV2Router01.sol
1439 
1440 
1441 
1442 pragma solidity 0.6.12;
1443 
1444 interface IUniswapV2Router01 {
1445     function factory() external pure returns (address);
1446 
1447     function swapExactTokensForTokens(
1448         uint256 amountIn,
1449         uint256 amountOutMin,
1450         address[] calldata path,
1451         address to,
1452         uint256 deadline
1453     ) external returns (uint256[] memory amounts);
1454 
1455     function swapTokensForExactTokens(
1456         uint256 amountOut,
1457         uint256 amountInMax,
1458         address[] calldata path,
1459         address to,
1460         uint256 deadline
1461     ) external returns (uint256[] memory amounts);
1462 
1463     function swapExactETHForTokens(
1464         uint256 amountOutMin,
1465         address[] calldata path,
1466         address to,
1467         uint256 deadline
1468     ) external payable returns (uint256[] memory amounts);
1469 
1470     function swapTokensForExactETH(
1471         uint256 amountOut,
1472         uint256 amountInMax,
1473         address[] calldata path,
1474         address to,
1475         uint256 deadline
1476     ) external returns (uint256[] memory amounts);
1477 
1478     function swapExactTokensForETH(
1479         uint256 amountIn,
1480         uint256 amountOutMin,
1481         address[] calldata path,
1482         address to,
1483         uint256 deadline
1484     ) external returns (uint256[] memory amounts);
1485 
1486     function swapETHForExactTokens(
1487         uint256 amountOut,
1488         address[] calldata path,
1489         address to,
1490         uint256 deadline
1491     ) external payable returns (uint256[] memory amounts);
1492 
1493     function quote(
1494         uint256 amountA,
1495         uint256 reserveA,
1496         uint256 reserveB
1497     ) external pure returns (uint256 amountB);
1498 
1499     function getAmountOut(
1500         uint256 amountIn,
1501         uint256 reserveIn,
1502         uint256 reserveOut
1503     ) external pure returns (uint256 amountOut);
1504 
1505     function getAmountIn(
1506         uint256 amountOut,
1507         uint256 reserveIn,
1508         uint256 reserveOut
1509     ) external pure returns (uint256 amountIn);
1510 
1511     function getAmountsOut(uint256 amountIn, address[] calldata path)
1512         external
1513         view
1514         returns (uint256[] memory amounts);
1515 
1516     function getAmountsIn(uint256 amountOut, address[] calldata path)
1517         external
1518         view
1519         returns (uint256[] memory amounts);
1520 }
1521 
1522 // File: contracts/interfaces/uniswap/IUniswapV2Router02.sol
1523 
1524 
1525 
1526 pragma solidity 0.6.12;
1527 
1528 
1529 interface IUniswapV2Router02 is IUniswapV2Router01 {
1530     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1531         uint256 amountIn,
1532         uint256 amountOutMin,
1533         address[] calldata path,
1534         address to,
1535         uint256 deadline
1536     ) external;
1537 
1538     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1539         uint256 amountOutMin,
1540         address[] calldata path,
1541         address to,
1542         uint256 deadline
1543     ) external payable;
1544 
1545     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1546         uint256 amountIn,
1547         uint256 amountOutMin,
1548         address[] calldata path,
1549         address to,
1550         uint256 deadline
1551     ) external;
1552 }
1553 
1554 // File: contracts/interfaces/vesper/IStrategy.sol
1555 
1556 
1557 
1558 pragma solidity 0.6.12;
1559 
1560 interface IStrategy {
1561     function rebalance() external;
1562 
1563     function deposit(uint256 amount) external;
1564 
1565     function beforeWithdraw() external;
1566 
1567     function withdraw(uint256 amount) external;
1568 
1569     function withdrawAll() external;
1570 
1571     function isUpgradable() external view returns (bool);
1572 
1573     function isReservedToken(address _token) external view returns (bool);
1574 
1575     function token() external view returns (address);
1576 
1577     function pool() external view returns (address);
1578 
1579     function totalLocked() external view returns (uint256);
1580 
1581     //Lifecycle functions
1582     function pause() external;
1583 
1584     function unpause() external;
1585 }
1586 
1587 // File: contracts/pools/VTokenBase.sol
1588 
1589 
1590 
1591 pragma solidity 0.6.12;
1592 
1593 
1594 
1595 
1596 abstract contract VTokenBase is PoolShareToken {
1597     address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1598 
1599     constructor(
1600         string memory name,
1601         string memory symbol,
1602         address _token,
1603         address _controller
1604     ) public PoolShareToken(name, symbol, _token, _controller) {
1605         require(_controller != address(0), "Controller address is zero");
1606     }
1607 
1608     modifier onlyController() {
1609         require(address(controller) == _msgSender(), "Caller is not the controller");
1610         _;
1611     }
1612 
1613     function pause() external onlyController {
1614         _pause();
1615     }
1616 
1617     function unpause() external onlyController {
1618         _unpause();
1619     }
1620 
1621     function shutdown() external onlyController {
1622         _shutdown();
1623     }
1624 
1625     function open() external onlyController {
1626         _open();
1627     }
1628 
1629     /// @dev Approve strategy to spend collateral token and strategy token of pool.
1630     function approveToken() external virtual onlyController {
1631         address strategy = controller.strategy(address(this));
1632         token.safeApprove(strategy, MAX_UINT_VALUE);
1633         IERC20(IStrategy(strategy).token()).safeApprove(strategy, MAX_UINT_VALUE);
1634     }
1635 
1636     /// @dev Reset token approval of strategy. Called when updating strategy.
1637     function resetApproval() external virtual onlyController {
1638         address strategy = controller.strategy(address(this));
1639         token.safeApprove(strategy, 0);
1640         IERC20(IStrategy(strategy).token()).safeApprove(strategy, 0);
1641     }
1642 
1643     /**
1644      * @dev Rebalance invested collateral to mitigate liquidation risk, if any.
1645      * Behavior of rebalance is driven by risk parameters defined in strategy.
1646      */
1647     function rebalance() external virtual {
1648         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1649         strategy.rebalance();
1650     }
1651 
1652     /**
1653      * @dev Convert given ERC20 token into collateral token via Uniswap
1654      * @param _erc20 Token address
1655      */
1656     function sweepErc20(address _erc20) external virtual {
1657         _sweepErc20(_erc20);
1658     }
1659 
1660     /// @dev Returns collateral token locked in strategy
1661     function tokenLocked() public view virtual returns (uint256) {
1662         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1663         return strategy.totalLocked();
1664     }
1665 
1666     /// @dev Returns total value of vesper pool, in terms of collateral token
1667     function totalValue() public view override returns (uint256) {
1668         return tokenLocked().add(tokensHere());
1669     }
1670 
1671     /**
1672      * @dev After burning hook, it will be called during withdrawal process.
1673      * It will withdraw collateral from strategy and transfer it to user.
1674      */
1675     function _afterBurning(uint256 _amount) internal override {
1676         uint256 balanceHere = tokensHere();
1677         if (balanceHere < _amount) {
1678             _withdrawCollateral(_amount.sub(balanceHere));
1679             balanceHere = tokensHere();
1680             _amount = balanceHere < _amount ? balanceHere : _amount;
1681         }
1682         token.safeTransfer(_msgSender(), _amount);
1683     }
1684 
1685     /**
1686      * @dev Before burning hook.
1687      * Some actions, like resurface(), can impact share price and has to be called before withdraw.
1688      */
1689     function _beforeBurning(
1690         uint256 /* shares */
1691     ) internal override {
1692         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1693         strategy.beforeWithdraw();
1694     }
1695 
1696     function _beforeMinting(uint256 amount) internal override {
1697         token.safeTransferFrom(_msgSender(), address(this), amount);
1698     }
1699 
1700     function _withdrawCollateral(uint256 amount) internal virtual {
1701         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1702         strategy.withdraw(amount);
1703     }
1704 
1705     function _sweepErc20(address _from) internal {
1706         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1707         require(
1708             _from != address(token) && _from != address(this) && !strategy.isReservedToken(_from),
1709             "Not allowed to sweep"
1710         );
1711         IUniswapV2Router02 uniswapRouter = IUniswapV2Router02(controller.uniswapRouter());
1712         uint256 amt = IERC20(_from).balanceOf(address(this));
1713         IERC20(_from).safeApprove(address(uniswapRouter), 0);
1714         IERC20(_from).safeApprove(address(uniswapRouter), amt);
1715         address[] memory path;
1716         if (address(token) == WETH) {
1717             path = new address[](2);
1718             path[0] = _from;
1719             path[1] = address(token);
1720         } else {
1721             path = new address[](3);
1722             path[0] = _from;
1723             path[1] = WETH;
1724             path[2] = address(token);
1725         }
1726         uniswapRouter.swapExactTokensForTokens(amt, 1, path, address(this), now + 30);
1727     }
1728 }
1729 
1730 // File: contracts/pools/VLINK.sol
1731 
1732 
1733 
1734 pragma solidity 0.6.12;
1735 
1736 
1737 //solhint-disable no-empty-blocks
1738 contract VLINK is VTokenBase {
1739     constructor(address _controller)
1740         public
1741         VTokenBase("vLINK Pool", "vLINK", 0x514910771AF9Ca656af840dff83E8264EcF986CA, _controller)
1742     {}
1743 }