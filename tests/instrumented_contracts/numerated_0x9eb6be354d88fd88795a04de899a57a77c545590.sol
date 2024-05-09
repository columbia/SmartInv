1 // File: @openzeppelin/contracts/GSN/Context.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
27 
28 
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
721 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
722 
723 
724 
725 pragma solidity ^0.6.0;
726 
727 
728 
729 /**
730  * @dev Extension of {ERC20} that allows token holders to destroy both their own
731  * tokens and those that they have an allowance for, in a way that can be
732  * recognized off-chain (via event analysis).
733  */
734 abstract contract ERC20Burnable is Context, ERC20 {
735     /**
736      * @dev Destroys `amount` tokens from the caller.
737      *
738      * See {ERC20-_burn}.
739      */
740     function burn(uint256 amount) public virtual {
741         _burn(_msgSender(), amount);
742     }
743 
744     /**
745      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
746      * allowance.
747      *
748      * See {ERC20-_burn} and {ERC20-allowance}.
749      *
750      * Requirements:
751      *
752      * - the caller must have allowance for ``accounts``'s tokens of at least
753      * `amount`.
754      */
755     function burnFrom(address account, uint256 amount) public virtual {
756         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
757 
758         _approve(account, _msgSender(), decreasedAllowance);
759         _burn(account, amount);
760     }
761 }
762 
763 // File: @openzeppelin/contracts/access/Ownable.sol
764 
765 
766 
767 pragma solidity ^0.6.0;
768 
769 /**
770  * @dev Contract module which provides a basic access control mechanism, where
771  * there is an account (an owner) that can be granted exclusive access to
772  * specific functions.
773  *
774  * By default, the owner account will be the one that deploys the contract. This
775  * can later be changed with {transferOwnership}.
776  *
777  * This module is used through inheritance. It will make available the modifier
778  * `onlyOwner`, which can be applied to your functions to restrict their use to
779  * the owner.
780  */
781 contract Ownable is Context {
782     address private _owner;
783 
784     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
785 
786     /**
787      * @dev Initializes the contract setting the deployer as the initial owner.
788      */
789     constructor () internal {
790         address msgSender = _msgSender();
791         _owner = msgSender;
792         emit OwnershipTransferred(address(0), msgSender);
793     }
794 
795     /**
796      * @dev Returns the address of the current owner.
797      */
798     function owner() public view returns (address) {
799         return _owner;
800     }
801 
802     /**
803      * @dev Throws if called by any account other than the owner.
804      */
805     modifier onlyOwner() {
806         require(_owner == _msgSender(), "Ownable: caller is not the owner");
807         _;
808     }
809 
810     /**
811      * @dev Leaves the contract without owner. It will not be possible to call
812      * `onlyOwner` functions anymore. Can only be called by the current owner.
813      *
814      * NOTE: Renouncing ownership will leave the contract without an owner,
815      * thereby removing any functionality that is only available to the owner.
816      */
817     function renounceOwnership() public virtual onlyOwner {
818         emit OwnershipTransferred(_owner, address(0));
819         _owner = address(0);
820     }
821 
822     /**
823      * @dev Transfers ownership of the contract to a new account (`newOwner`).
824      * Can only be called by the current owner.
825      */
826     function transferOwnership(address newOwner) public virtual onlyOwner {
827         require(newOwner != address(0), "Ownable: new owner is the zero address");
828         emit OwnershipTransferred(_owner, newOwner);
829         _owner = newOwner;
830     }
831 }
832 
833 // File: contracts/owner/Operator.sol
834 
835 pragma solidity ^0.6.0;
836 
837 
838 
839 contract Operator is Context, Ownable {
840     address private _operator;
841 
842     event OperatorTransferred(
843         address indexed previousOperator,
844         address indexed newOperator
845     );
846 
847     constructor() internal {
848         _operator = _msgSender();
849         emit OperatorTransferred(address(0), _operator);
850     }
851 
852     function operator() public view returns (address) {
853         return _operator;
854     }
855 
856     modifier onlyOperator() {
857         require(
858             _operator == msg.sender,
859             'operator: caller is not the operator'
860         );
861         _;
862     }
863 
864     function isOperator() public view returns (bool) {
865         return _msgSender() == _operator;
866     }
867 
868     function transferOperator(address newOperator_) public onlyOwner {
869         _transferOperator(newOperator_);
870     }
871 
872     function _transferOperator(address newOperator_) internal {
873         require(
874             newOperator_ != address(0),
875             'operator: zero address given for new operator'
876         );
877         emit OperatorTransferred(address(0), newOperator_);
878         _operator = newOperator_;
879     }
880 }
881 
882 // File: contracts/GameStopToken.sol
883 
884 pragma solidity ^0.6.0;
885 
886 
887 
888 contract GameStopToken is ERC20Burnable, Operator {
889     /**
890      * @notice Constructs the GameStop token ERC-20 contract.
891      */
892     constructor() public ERC20('GameStop.Finance', 'GME') {}
893 
894     /**
895      * @notice Operator mints GameStop token to a recipient
896      * @param recipient_ The address of recipient
897      * @param amount_ The amount of GameStop token to mint to
898      * @return whether the process has been done
899      */
900     function mint(address recipient_, uint256 amount_)
901         public
902         onlyOperator
903         returns (bool)
904     {
905         uint256 balanceBefore = balanceOf(recipient_);
906         _mint(recipient_, amount_);
907         uint256 balanceAfter = balanceOf(recipient_);
908 
909         return balanceAfter > balanceBefore;
910     }
911 
912     function burn(uint256 amount) public override onlyOperator {
913         super.burn(amount);
914     }
915 
916     function burnFrom(address account, uint256 amount)
917         public
918         override
919         onlyOperator
920     {
921         super.burnFrom(account, amount);
922     }
923 }