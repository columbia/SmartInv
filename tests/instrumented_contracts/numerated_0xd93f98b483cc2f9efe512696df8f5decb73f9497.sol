1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma experimental ABIEncoderV2;
3 
4 // File: @openzeppelin/contracts/math/SafeMath.sol
5 
6 
7 pragma solidity ^0.6.0;
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
164 
165 // File: @openzeppelin/contracts/GSN/Context.sol
166 
167 
168 pragma solidity ^0.6.0;
169 
170 /*
171  * @dev Provides information about the current execution context, including the
172  * sender of the transaction and its data. While these are generally available
173  * via msg.sender and msg.data, they should not be accessed in such a direct
174  * manner, since when dealing with GSN meta-transactions the account sending and
175  * paying for execution may not be the actual sender (as far as an application
176  * is concerned).
177  *
178  * This contract is only required for intermediate, library-like contracts.
179  */
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address payable) {
182         return msg.sender;
183     }
184 
185     function _msgData() internal view virtual returns (bytes memory) {
186         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
187         return msg.data;
188     }
189 }
190 
191 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
192 
193 
194 pragma solidity ^0.6.0;
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP.
198  */
199 interface IERC20 {
200     /**
201      * @dev Returns the amount of tokens in existence.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns the amount of tokens owned by `account`.
207      */
208     function balanceOf(address account) external view returns (uint256);
209 
210     /**
211      * @dev Moves `amount` tokens from the caller's account to `recipient`.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transfer(address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Returns the remaining number of tokens that `spender` will be
221      * allowed to spend on behalf of `owner` through {transferFrom}. This is
222      * zero by default.
223      *
224      * This value changes when {approve} or {transferFrom} are called.
225      */
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to {approve}. `value` is the new allowance.
266      */
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 }
269 
270 // File: @openzeppelin/contracts/utils/Address.sol
271 
272 
273 pragma solidity ^0.6.2;
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
297         // This method relies in extcodesize, which returns 0 for contracts in
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
413 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
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
721 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
722 
723 
724 pragma solidity ^0.6.0;
725 
726 /**
727  * @dev Contract module that helps prevent reentrant calls to a function.
728  *
729  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
730  * available, which can be applied to functions to make sure there are no nested
731  * (reentrant) calls to them.
732  *
733  * Note that because there is a single `nonReentrant` guard, functions marked as
734  * `nonReentrant` may not call one another. This can be worked around by making
735  * those functions `private`, and then adding `external` `nonReentrant` entry
736  * points to them.
737  *
738  * TIP: If you would like to learn more about reentrancy and alternative ways
739  * to protect against it, check out our blog post
740  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
741  */
742 contract ReentrancyGuard {
743     // Booleans are more expensive than uint256 or any type that takes up a full
744     // word because each write operation emits an extra SLOAD to first read the
745     // slot's contents, replace the bits taken up by the boolean, and then write
746     // back. This is the compiler's defense against contract upgrades and
747     // pointer aliasing, and it cannot be disabled.
748 
749     // The values being non-zero value makes deployment a bit more expensive,
750     // but in exchange the refund on every call to nonReentrant will be lower in
751     // amount. Since refunds are capped to a percentage of the total
752     // transaction's gas, it is best to keep them low in cases like this one, to
753     // increase the likelihood of the full refund coming into effect.
754     uint256 private constant _NOT_ENTERED = 1;
755     uint256 private constant _ENTERED = 2;
756 
757     uint256 private _status;
758 
759     constructor () internal {
760         _status = _NOT_ENTERED;
761     }
762 
763     /**
764      * @dev Prevents a contract from calling itself, directly or indirectly.
765      * Calling a `nonReentrant` function from another `nonReentrant`
766      * function is not supported. It is possible to prevent this from happening
767      * by making the `nonReentrant` function external, and make it call a
768      * `private` function that does the actual work.
769      */
770     modifier nonReentrant() {
771         // On the first call to nonReentrant, _notEntered will be true
772         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
773 
774         // Any calls to nonReentrant after this point will fail
775         _status = _ENTERED;
776 
777         _;
778 
779         // By storing the original value once again, a refund is triggered (see
780         // https://eips.ethereum.org/EIPS/eip-2200)
781         _status = _NOT_ENTERED;
782     }
783 }
784 
785 // File: contracts/GToken.sol
786 
787 pragma solidity ^0.6.0;
788 
789 
790 /**
791  * @dev Minimal interface for gTokens, implemented by the GTokenBase contract.
792  *      See GTokenBase.sol for further documentation.
793  */
794 interface GToken is IERC20
795 {
796 	// pure functions
797 	function calcDepositSharesFromCost(uint256 _cost, uint256 _totalReserve, uint256 _totalSupply, uint256 _depositFee) external pure returns (uint256 _netShares, uint256 _feeShares);
798 	function calcDepositCostFromShares(uint256 _netShares, uint256 _totalReserve, uint256 _totalSupply, uint256 _depositFee) external pure returns (uint256 _cost, uint256 _feeShares);
799 	function calcWithdrawalSharesFromCost(uint256 _cost, uint256 _totalReserve, uint256 _totalSupply, uint256 _withdrawalFee) external pure returns (uint256 _grossShares, uint256 _feeShares);
800 	function calcWithdrawalCostFromShares(uint256 _grossShares, uint256 _totalReserve, uint256 _totalSupply, uint256 _withdrawalFee) external pure returns (uint256 _cost, uint256 _feeShares);
801 
802 	// view functions
803 	function reserveToken() external view returns (address _reserveToken);
804 	function totalReserve() external view returns (uint256 _totalReserve);
805 	function depositFee() external view returns (uint256 _depositFee);
806 	function withdrawalFee() external view returns (uint256 _withdrawalFee);
807 
808 	// open functions
809 	function deposit(uint256 _cost) external;
810 	function withdraw(uint256 _grossShares) external;
811 }
812 
813 // File: contracts/GVoting.sol
814 
815 pragma solidity ^0.6.0;
816 
817 /**
818  * @dev An interface to extend gTokens with voting delegation capabilities.
819  *      See GTokenType3.sol for further documentation.
820  */
821 interface GVoting
822 {
823 	// view functions
824 	function votes(address _candidate) external view returns (uint256 _votes);
825 	function candidate(address _voter) external view returns (address _candidate);
826 
827 	// open functions
828 	function setCandidate(address _newCandidate) external;
829 
830 	// emitted events
831 	event ChangeCandidate(address indexed _voter, address indexed _oldCandidate, address indexed _newCandidate);
832 	event ChangeVotes(address indexed _candidate, uint256 _oldVotes, uint256 _newVotes);
833 }
834 
835 // File: contracts/GFormulae.sol
836 
837 pragma solidity ^0.6.0;
838 
839 
840 /**
841  * @dev Pure implementation of deposit/minting and withdrawal/burning formulas
842  *      for gTokens.
843  *      All operations assume that, if total supply is 0, then the total
844  *      reserve is also 0, and vice-versa.
845  *      Fees are calculated percentually based on the gross amount.
846  *      See GTokenBase.sol for further documentation.
847  */
848 library GFormulae
849 {
850 	using SafeMath for uint256;
851 
852 	/* deposit(cost):
853 	 *   price = reserve / supply
854 	 *   gross = cost / price
855 	 *   net = gross * 0.99	# fee is assumed to be 1% for simplicity
856 	 *   fee = gross - net
857 	 *   return net, fee
858 	 */
859 	function _calcDepositSharesFromCost(uint256 _cost, uint256 _totalReserve, uint256 _totalSupply, uint256 _depositFee) internal pure returns (uint256 _netShares, uint256 _feeShares)
860 	{
861 		uint256 _grossShares = _totalSupply == _totalReserve ? _cost : _cost.mul(_totalSupply).div(_totalReserve);
862 		_netShares = _grossShares.mul(uint256(1e18).sub(_depositFee)).div(1e18);
863 		_feeShares = _grossShares.sub(_netShares);
864 		return (_netShares, _feeShares);
865 	}
866 
867 	/* deposit_reverse(net):
868 	 *   price = reserve / supply
869 	 *   gross = net / 0.99	# fee is assumed to be 1% for simplicity
870 	 *   cost = gross * price
871 	 *   fee = gross - net
872 	 *   return cost, fee
873 	 */
874 	function _calcDepositCostFromShares(uint256 _netShares, uint256 _totalReserve, uint256 _totalSupply, uint256 _depositFee) internal pure returns (uint256 _cost, uint256 _feeShares)
875 	{
876 		uint256 _grossShares = _netShares.mul(1e18).div(uint256(1e18).sub(_depositFee));
877 		_cost = _totalReserve == _totalSupply ? _grossShares : _grossShares.mul(_totalReserve).div(_totalSupply);
878 		_feeShares = _grossShares.sub(_netShares);
879 		return (_cost, _feeShares);
880 	}
881 
882 	/* withdrawal_reverse(cost):
883 	 *   price = reserve / supply
884 	 *   net = cost / price
885 	 *   gross = net / 0.99	# fee is assumed to be 1% for simplicity
886 	 *   fee = gross - net
887 	 *   return gross, fee
888 	 */
889 	function _calcWithdrawalSharesFromCost(uint256 _cost, uint256 _totalReserve, uint256 _totalSupply, uint256 _withdrawalFee) internal pure returns (uint256 _grossShares, uint256 _feeShares)
890 	{
891 		uint256 _netShares = _cost == _totalReserve ? _totalSupply : _cost.mul(_totalSupply).div(_totalReserve);
892 		_grossShares = _netShares.mul(1e18).div(uint256(1e18).sub(_withdrawalFee));
893 		_feeShares = _grossShares.sub(_netShares);
894 		return (_grossShares, _feeShares);
895 	}
896 
897 	/* withdrawal(gross):
898 	 *   price = reserve / supply
899 	 *   net = gross * 0.99	# fee is assumed to be 1% for simplicity
900 	 *   cost = net * price
901 	 *   fee = gross - net
902 	 *   return cost, fee
903 	 */
904 	function _calcWithdrawalCostFromShares(uint256 _grossShares, uint256 _totalReserve, uint256 _totalSupply, uint256 _withdrawalFee) internal pure returns (uint256 _cost, uint256 _feeShares)
905 	{
906 		uint256 _netShares = _grossShares.mul(uint256(1e18).sub(_withdrawalFee)).div(1e18);
907 		_cost = _netShares == _totalSupply ? _totalReserve : _netShares.mul(_totalReserve).div(_totalSupply);
908 		_feeShares = _grossShares.sub(_netShares);
909 		return (_cost, _feeShares);
910 	}
911 }
912 
913 // File: contracts/modules/Math.sol
914 
915 pragma solidity ^0.6.0;
916 
917 /**
918  * @dev This library implements auxiliary math definitions.
919  */
920 library Math
921 {
922 	function _min(uint256 _amount1, uint256 _amount2) internal pure returns (uint256 _minAmount)
923 	{
924 		return _amount1 < _amount2 ? _amount1 : _amount2;
925 	}
926 
927 	function _max(uint256 _amount1, uint256 _amount2) internal pure returns (uint256 _maxAmount)
928 	{
929 		return _amount1 > _amount2 ? _amount1 : _amount2;
930 	}
931 }
932 
933 // File: contracts/network/$.sol
934 
935 pragma solidity ^0.6.0;
936 
937 /**
938  * @dev This library is provided for conveniece. It is the single source for
939  *      the current network and all related hardcoded contract addresses. It
940  *      also provide useful definitions for debuging faultless code via events.
941  */
942 library $
943 {
944 	address constant GRO = 0x09e64c2B61a5f1690Ee6fbeD9baf5D6990F8dFd0;
945 }
946 
947 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
948 
949 
950 pragma solidity ^0.6.0;
951 
952 
953 
954 
955 /**
956  * @title SafeERC20
957  * @dev Wrappers around ERC20 operations that throw on failure (when the token
958  * contract returns false). Tokens that return no value (and instead revert or
959  * throw on failure) are also supported, non-reverting calls are assumed to be
960  * successful.
961  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
962  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
963  */
964 library SafeERC20 {
965     using SafeMath for uint256;
966     using Address for address;
967 
968     function safeTransfer(IERC20 token, address to, uint256 value) internal {
969         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
970     }
971 
972     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
973         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
974     }
975 
976     /**
977      * @dev Deprecated. This function has issues similar to the ones found in
978      * {IERC20-approve}, and its usage is discouraged.
979      *
980      * Whenever possible, use {safeIncreaseAllowance} and
981      * {safeDecreaseAllowance} instead.
982      */
983     function safeApprove(IERC20 token, address spender, uint256 value) internal {
984         // safeApprove should only be called when setting an initial allowance,
985         // or when resetting it to zero. To increase and decrease it, use
986         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
987         // solhint-disable-next-line max-line-length
988         require((value == 0) || (token.allowance(address(this), spender) == 0),
989             "SafeERC20: approve from non-zero to non-zero allowance"
990         );
991         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
992     }
993 
994     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
995         uint256 newAllowance = token.allowance(address(this), spender).add(value);
996         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
997     }
998 
999     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1000         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1001         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1002     }
1003 
1004     /**
1005      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1006      * on the return value: the return value is optional (but if data is returned, it must not be false).
1007      * @param token The token targeted by the call.
1008      * @param data The call data (encoded using abi.encode or one of its variants).
1009      */
1010     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1011         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1012         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1013         // the target address contains contract code and also asserts for success in the low-level call.
1014 
1015         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1016         if (returndata.length > 0) { // Return data is optional
1017             // solhint-disable-next-line max-line-length
1018             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1019         }
1020     }
1021 }
1022 
1023 // File: contracts/modules/Transfers.sol
1024 
1025 pragma solidity ^0.6.0;
1026 
1027 
1028 
1029 /**
1030  * @dev This library abstracts ERC-20 operations.
1031  */
1032 library Transfers
1033 {
1034 	using SafeERC20 for IERC20;
1035 
1036 	/**
1037 	 * @dev Retrieves a given ERC-20 token balance for the current contract.
1038 	 * @param _token An ERC-20 compatible token address.
1039 	 * @return _balance The current contract balance of the given ERC-20 token.
1040 	 */
1041 	function _getBalance(address _token) internal view returns (uint256 _balance)
1042 	{
1043 		return IERC20(_token).balanceOf(address(this));
1044 	}
1045 
1046 	/**
1047 	 * @dev Allows a spender to access a given ERC-20 balance for the current contract.
1048 	 * @param _token An ERC-20 compatible token address.
1049 	 * @param _to The spender address.
1050 	 * @param _amount The exact spending allowance amount.
1051 	 */
1052 	function _approveFunds(address _token, address _to, uint256 _amount) internal
1053 	{
1054 		uint256 _allowance = IERC20(_token).allowance(address(this), _to);
1055 		if (_allowance > _amount) {
1056 			IERC20(_token).safeDecreaseAllowance(_to, _allowance - _amount);
1057 		}
1058 		else
1059 		if (_allowance < _amount) {
1060 			IERC20(_token).safeIncreaseAllowance(_to, _amount - _allowance);
1061 		}
1062 	}
1063 
1064 	/**
1065 	 * @dev Transfer a given ERC-20 token amount into the current contract.
1066 	 * @param _token An ERC-20 compatible token address.
1067 	 * @param _from The source address.
1068 	 * @param _amount The amount to be transferred.
1069 	 */
1070 	function _pullFunds(address _token, address _from, uint256 _amount) internal
1071 	{
1072 		if (_amount == 0) return;
1073 		IERC20(_token).safeTransferFrom(_from, address(this), _amount);
1074 	}
1075 
1076 	/**
1077 	 * @dev Transfer a given ERC-20 token amount from the current contract.
1078 	 * @param _token An ERC-20 compatible token address.
1079 	 * @param _to The target address.
1080 	 * @param _amount The amount to be transferred.
1081 	 */
1082 	function _pushFunds(address _token, address _to, uint256 _amount) internal
1083 	{
1084 		if (_amount == 0) return;
1085 		IERC20(_token).safeTransfer(_to, _amount);
1086 	}
1087 }
1088 
1089 // File: contracts/G.sol
1090 
1091 pragma solidity ^0.6.0;
1092 
1093 
1094 
1095 
1096 
1097 
1098 
1099 /**
1100  * @dev This public library provides a single entrypoint to most of the relevant
1101  *      internal libraries available in the modules folder. It exists to
1102  *      circunvent the contract size limitation imposed by the EVM. All function
1103  *      calls are directly delegated to the target library function preserving
1104  *      argument and return values exactly as they are. This library is shared
1105  *      by many contracts and even other public libraries from this repository,
1106  *      therefore it needs to be published alongside them.
1107  */
1108 library G
1109 {
1110 	function min(uint256 _amount1, uint256 _amount2) public pure returns (uint256 _minAmount) { return Math._min(_amount1, _amount2); }
1111 	function max(uint256 _amount1, uint256 _amount2) public pure returns (uint256 _maxAmount) { return Math._max(_amount1, _amount2); }
1112 
1113 	function getBalance(address _token) public view returns (uint256 _balance) { return Transfers._getBalance(_token); }
1114 	function pullFunds(address _token, address _from, uint256 _amount) public { Transfers._pullFunds(_token, _from, _amount); }
1115 	function pushFunds(address _token, address _to, uint256 _amount) public { Transfers._pushFunds(_token, _to, _amount); }
1116 	function approveFunds(address _token, address _to, uint256 _amount) public { Transfers._approveFunds(_token, _to, _amount); }
1117 }
1118 
1119 // File: contracts/GTokenType3.sol
1120 
1121 pragma solidity ^0.6.0;
1122 
1123 
1124 
1125 
1126 
1127 
1128 
1129 
1130 /**
1131  * @notice This contract implements the functionality for the gToken Type 3.
1132  *         It has a higher deposit/withdrawal fee when compared to other
1133  *         gTokens (10%). Half of the collected fee used to reward token
1134  *         holders while the other half is burned along with the same proportion
1135  *         of the reserve. It is used in the implementation of stkGRO.
1136  */
1137 contract GTokenType3 is ERC20, ReentrancyGuard, GToken, GVoting
1138 {
1139 	using SafeMath for uint256;
1140 
1141 	uint256 constant DEPOSIT_FEE = 10e16; // 10%
1142 	uint256 constant WITHDRAWAL_FEE = 10e16; // 10%
1143 
1144 	uint256 constant VOTING_ROUND_INTERVAL = 1 days;
1145 
1146 	address public immutable override reserveToken;
1147 
1148 	mapping (address => address) public override candidate;
1149 
1150 	mapping (address => uint256) private votingRound;
1151 	mapping (address => uint256[2]) private voting;
1152 
1153 	/**
1154 	 * @dev Constructor for the gToken contract.
1155 	 * @param _name The ERC-20 token name.
1156 	 * @param _symbol The ERC-20 token symbol.
1157 	 * @param _decimals The ERC-20 token decimals.
1158 	 * @param _reserveToken The ERC-20 token address to be used as reserve
1159 	 *                      token (e.g. GRO for sktGRO).
1160 	 */
1161 	constructor (string memory _name, string memory _symbol, uint8 _decimals, address _reserveToken)
1162 		ERC20(_name, _symbol) public
1163 	{
1164 		_setupDecimals(_decimals);
1165 		reserveToken = _reserveToken;
1166 	}
1167 
1168 	/**
1169 	 * @notice Allows for the beforehand calculation of shares to be
1170 	 *         received/minted upon depositing to the contract.
1171 	 * @param _cost The amount of reserve token being deposited.
1172 	 * @param _totalReserve The reserve balance as obtained by totalReserve().
1173 	 * @param _totalSupply The shares supply as obtained by totalSupply().
1174 	 * @param _depositFee The current deposit fee as obtained by depositFee().
1175 	 * @return _netShares The net amount of shares being received.
1176 	 * @return _feeShares The fee amount of shares being deducted.
1177 	 */
1178 	function calcDepositSharesFromCost(uint256 _cost, uint256 _totalReserve, uint256 _totalSupply, uint256 _depositFee) public pure override returns (uint256 _netShares, uint256 _feeShares)
1179 	{
1180 		return GFormulae._calcDepositSharesFromCost(_cost, _totalReserve, _totalSupply, _depositFee);
1181 	}
1182 
1183 	/**
1184 	 * @notice Allows for the beforehand calculation of the amount of
1185 	 *         reserve token to be deposited in order to receive the desired
1186 	 *         amount of shares.
1187 	 * @param _netShares The amount of this gToken shares to receive.
1188 	 * @param _totalReserve The reserve balance as obtained by totalReserve().
1189 	 * @param _totalSupply The shares supply as obtained by totalSupply().
1190 	 * @param _depositFee The current deposit fee as obtained by depositFee().
1191 	 * @return _cost The cost, in the reserve token, to be paid.
1192 	 * @return _feeShares The fee amount of shares being deducted.
1193 	 */
1194 	function calcDepositCostFromShares(uint256 _netShares, uint256 _totalReserve, uint256 _totalSupply, uint256 _depositFee) public pure override returns (uint256 _cost, uint256 _feeShares)
1195 	{
1196 		return GFormulae._calcDepositCostFromShares(_netShares, _totalReserve, _totalSupply, _depositFee);
1197 	}
1198 
1199 	/**
1200 	 * @notice Allows for the beforehand calculation of shares to be
1201 	 *         given/burned upon withdrawing from the contract.
1202 	 * @param _cost The amount of reserve token being withdrawn.
1203 	 * @param _totalReserve The reserve balance as obtained by totalReserve()
1204 	 * @param _totalSupply The shares supply as obtained by totalSupply()
1205 	 * @param _withdrawalFee The current withdrawal fee as obtained by withdrawalFee()
1206 	 * @return _grossShares The total amount of shares being deducted,
1207 	 *                      including fees.
1208 	 * @return _feeShares The fee amount of shares being deducted.
1209 	 */
1210 	function calcWithdrawalSharesFromCost(uint256 _cost, uint256 _totalReserve, uint256 _totalSupply, uint256 _withdrawalFee) public pure override returns (uint256 _grossShares, uint256 _feeShares)
1211 	{
1212 		return GFormulae._calcWithdrawalSharesFromCost(_cost, _totalReserve, _totalSupply, _withdrawalFee);
1213 	}
1214 
1215 	/**
1216 	 * @notice Allows for the beforehand calculation of the amount of
1217 	 *         reserve token to be withdrawn given the desired amount of
1218 	 *         shares.
1219 	 * @param _grossShares The amount of this gToken shares to provide.
1220 	 * @param _totalReserve The reserve balance as obtained by totalReserve().
1221 	 * @param _totalSupply The shares supply as obtained by totalSupply().
1222 	 * @param _withdrawalFee The current withdrawal fee as obtained by withdrawalFee().
1223 	 * @return _cost The cost, in the reserve token, to be received.
1224 	 * @return _feeShares The fee amount of shares being deducted.
1225 	 */
1226 	function calcWithdrawalCostFromShares(uint256 _grossShares, uint256 _totalReserve, uint256 _totalSupply, uint256 _withdrawalFee) public pure override returns (uint256 _cost, uint256 _feeShares)
1227 	{
1228 		return GFormulae._calcWithdrawalCostFromShares(_grossShares, _totalReserve, _totalSupply, _withdrawalFee);
1229 	}
1230 
1231 	/**
1232 	 * @notice Provides the amount of reserve tokens currently being help by
1233 	 *         this contract.
1234 	 * @return _totalReserve The amount of the reserve token corresponding
1235 	 *                       to this contract's balance.
1236 	 */
1237 	function totalReserve() public view virtual override returns (uint256 _totalReserve)
1238 	{
1239 		return G.getBalance(reserveToken);
1240 	}
1241 
1242 	/**
1243 	 * @notice Provides the current minting/deposit fee. This fee is
1244 	 *         applied to the amount of this gToken shares being created
1245 	 *         upon deposit. The fee defaults to 10%.
1246 	 * @return _depositFee A percent value that accounts for the percentage
1247 	 *                     of shares being minted at each deposit that be
1248 	 *                     collected as fee.
1249 	 */
1250 	function depositFee() public view override returns (uint256 _depositFee) {
1251 		return DEPOSIT_FEE;
1252 	}
1253 
1254 	/**
1255 	 * @notice Provides the current burning/withdrawal fee. This fee is
1256 	 *         applied to the amount of this gToken shares being redeemed
1257 	 *         upon withdrawal. The fee defaults to 10%.
1258 	 * @return _withdrawalFee A percent value that accounts for the
1259 	 *                        percentage of shares being burned at each
1260 	 *                        withdrawal that be collected as fee.
1261 	 */
1262 	function withdrawalFee() public view override returns (uint256 _withdrawalFee) {
1263 		return WITHDRAWAL_FEE;
1264 	}
1265 
1266 	/**
1267 	 * @notice Provides the number of votes a given candidate has at the end
1268 	 *         of the previous voting interval. The interval is 24 hours
1269 	 *         and resets at 12AM UTC. See _transferVotes().
1270 	 * @param _candidate The candidate for which we want to know the number
1271 	 *                   of delegated votes.
1272 	 * @return _votes The candidate number of votes. It is the sum of the
1273 	 *                balances of the voters that have him as cadidate at
1274 	 *                the end of the previous voting interval.
1275 	 */
1276 	function votes(address _candidate) public view override returns (uint256 _votes)
1277 	{
1278 		uint256 _votingRound = block.timestamp.div(VOTING_ROUND_INTERVAL);
1279 		// if the candidate balance was last updated the current round
1280 		// uses the backup instead (position 1), otherwise uses the most
1281 		// up-to-date balance (position 0)
1282 		return voting[_candidate][votingRound[_candidate] < _votingRound ? 0 : 1];
1283 	}
1284 
1285 	/**
1286 	 * @notice Performs the minting of gToken shares upon the deposit of the
1287 	 *         reserve token. The actual number of shares being minted can
1288 	 *         be calculated using the calcDepositSharesFromCost function.
1289 	 *         In every deposit, 10% of the shares is retained in terms of
1290 	 *         deposit fee. The fee amount and half of its equivalent
1291 	 *         reserve amount are immediately burned. The funds will be
1292 	 *         pulled in by this contract, therefore they must be previously
1293 	 *         approved.
1294 	 * @param _cost The amount of reserve token being deposited in the
1295 	 *              operation.
1296 	 */
1297 	function deposit(uint256 _cost) public override nonReentrant
1298 	{
1299 		address _from = msg.sender;
1300 		require(_cost > 0, "cost must be greater than 0");
1301 		(uint256 _netShares, uint256 _feeShares) = GFormulae._calcDepositSharesFromCost(_cost, totalReserve(), totalSupply(), depositFee());
1302 		require(_netShares > 0, "shares must be greater than 0");
1303 		G.pullFunds(reserveToken, _from, _cost);
1304 		_mint(_from, _netShares);
1305 		_burnReserveFromShares(_feeShares.div(2));
1306 	}
1307 
1308 	/**
1309 	 * @notice Performs the burning of gToken shares upon the withdrawal of
1310 	 *         the reserve token. The actual amount of the reserve token to
1311 	 *         be received can be calculated using the
1312 	 *         calcWithdrawalCostFromShares function. In every withdrawal,
1313 	 *         10% of the shares is retained in terms of withdrawal fee.
1314 	 *         The fee amount and half of its equivalent reserve amount are
1315 	 *         immediately burned.
1316 	 * @param _grossShares The gross amount of this gToken shares being
1317 	 *                     redeemed in the operation.
1318 	 */
1319 	function withdraw(uint256 _grossShares) public override nonReentrant
1320 	{
1321 		address _from = msg.sender;
1322 		require(_grossShares > 0, "shares must be greater than 0");
1323 		(uint256 _cost, uint256 _feeShares) = GFormulae._calcWithdrawalCostFromShares(_grossShares, totalReserve(), totalSupply(), withdrawalFee());
1324 		require(_cost > 0, "cost must be greater than 0");
1325 		_cost = G.min(_cost, G.getBalance(reserveToken));
1326 		G.pushFunds(reserveToken, _from, _cost);
1327 		_burn(_from, _grossShares);
1328 		_burnReserveFromShares(_feeShares.div(2));
1329 	}
1330 
1331 	/**
1332 	 * @notice Changes the voter's choice for candidate and vote delegation.
1333 	 *         It is only going to be reflected in the voting by the next
1334 	 *         interval. The interval is 24 hours and resets at 12AM UTC.
1335 	 *         This function will emit a ChangeCandidate event.
1336 	 * @param _newCandidate The new candidate chosen.
1337 	 */
1338 	function setCandidate(address _newCandidate) public override nonReentrant
1339 	{
1340 		address _voter = msg.sender;
1341 		uint256 _votes = balanceOf(_voter);
1342 		address _oldCandidate = candidate[_voter];
1343 		candidate[_voter] = _newCandidate;
1344 		_transferVotes(_oldCandidate, _newCandidate, _votes);
1345 		emit ChangeCandidate(_voter, _oldCandidate, _newCandidate);
1346 	}
1347 
1348 	/**
1349 	 * @dev Burns a given amount of shares worth of the reserve token.
1350 	 *      See burnReserve().
1351 	 * @param _grossShares The amount of shares for which the equivalent,
1352 	 *                     in the reserve token, will be burned.
1353 	 */
1354 	function _burnReserveFromShares(uint256 _grossShares) internal virtual
1355 	{
1356 		// we use the withdrawal formula to calculated how much is burned (withdrawn) from the contract
1357 		// since the fee is 0 using the deposit formula would yield the same amount
1358 		(uint256 _cost,) = GFormulae._calcWithdrawalCostFromShares(_grossShares, totalReserve(), totalSupply(), 0);
1359 		_cost = G.min(_cost, G.getBalance(reserveToken));
1360 		_burnReserve(_cost);
1361 	}
1362 
1363 	/**
1364 	 * @dev Burns the given amount of the reserve token. The default behavior
1365 	 *      of the function for general ERC-20 is to send the funds to
1366 	 *      address(0), but that can be overriden by a subcontract.
1367 	 * @param _reserveAmount The amount of the reserve token being burned.
1368 	 */
1369 	function _burnReserve(uint256 _reserveAmount) internal virtual
1370 	{
1371 		G.pushFunds(reserveToken, address(0), _reserveAmount);
1372 	}
1373 
1374 	/**
1375 	 * @dev This hook is called whenever tokens are minted, burned and
1376 	 *      transferred. This contract forbids token transfers by design.
1377 	 *      Token minting and burning will be reflected in the additional
1378 	 *      votes being credited or debited to the chosen candidate.
1379 	 *      See _transferVotes().
1380 	 * @param _from The provider of funds. Address 0 for minting.
1381 	 * @param _to The receiver of funds. Address 0 for burning.
1382 	 * @param _amount The amount being transfered.
1383 	 */
1384 	function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override
1385 	{
1386 		require(_from == address(0) || _to == address(0), "transfer prohibited");
1387 		address _oldCandidate = candidate[_from];
1388 		address _newCandidate = candidate[_to];
1389 		uint256 _votes = _amount;
1390 		_transferVotes(_oldCandidate, _newCandidate, _votes);
1391 	}
1392 
1393 	/**
1394 	 * @dev Implements the vote transfer logic. It will deduct the votes
1395 	 *      from one candidate and credit it to another candidate. If
1396 	 *      either of candidates is the 0 address, the the voter is either
1397 	 *      setting its initial candidate or abstaining himself from voting.
1398 	 *      The change is only reflected after the voting interval resets.
1399 	 *      We use a 2 element array to keep track of votes. The amount on
1400 	 *      position 0 is always the current vote count for the candidate.
1401 	 *      The amount on position 1 is a backup that reflect the vote count
1402 	 *      prior to the current round only if it has been updated for the
1403 	 *      current round. We also record the last voting round where the
1404 	 *      candidate balance was updated. If the last round is the current
1405 	 *      then we use the backup value on position 1, otherwise we use
1406 	 *      the most up to date value on position 0. This function will
1407 	 *      emit a ChangeVotes event upon candidate vote balance change.
1408 	 *      See _updateVotes().
1409 	 * @param _oldCandidate The candidate to deduct votes from.
1410 	 * @param _newCandidate The candidate to credit voter for.
1411 	 * @param _votes the number of votes being transfered.
1412 	 */
1413 	function _transferVotes(address _oldCandidate, address _newCandidate, uint256 _votes) internal
1414 	{
1415 		if (_votes == 0) return;
1416 		if (_oldCandidate == _newCandidate) return;
1417 		if (_oldCandidate != address(0)) {
1418 			// position 0 always has the most up-to-date balance
1419 			uint256 _oldVotes = voting[_oldCandidate][0];
1420 			uint256 _newVotes = _oldVotes.sub(_votes);
1421 			// updates position 0 backing up the previous amount
1422 			_updateVotes(_oldCandidate, _newVotes);
1423 			emit ChangeVotes(_oldCandidate, _oldVotes, _newVotes);
1424 		}
1425 		if (_newCandidate != address(0)) {
1426 			// position 0 always has the most up-to-date balance
1427 			uint256 _oldVotes = voting[_newCandidate][0];
1428 			uint256 _newVotes = _oldVotes.add(_votes);
1429 			// updates position 0 backing up the previous amount
1430 			_updateVotes(_newCandidate, _newVotes);
1431 			emit ChangeVotes(_newCandidate, _oldVotes, _newVotes);
1432 		}
1433 	}
1434 
1435 	/**
1436 	 * @dev Updates the candidate's current vote balance (position 0) and
1437 	 *      backs up the vote balance for the previous interval (position 1).
1438 	 *      The routine makes sure we do not overwrite and corrupt the
1439 	 *      backup if multiple vote updates happen within a single roung.
1440 	 *      See _transferVotes().
1441 	 * @param _candidate The candidate for which we are updating the votes.
1442 	 * @param _votes The candidate's new vote balance.
1443 	 */
1444 	function _updateVotes(address _candidate, uint256 _votes) internal
1445 	{
1446 		uint256 _votingRound = block.timestamp.div(VOTING_ROUND_INTERVAL);
1447 		// if the candidates voting round is not the current it means
1448 		// we are updating the voting balance for the first time in
1449 		// the current round, that is the only time we want to make a
1450 		// backup of the vote balance for the previous roung
1451 		if (votingRound[_candidate] < _votingRound) {
1452 			votingRound[_candidate] = _votingRound;
1453 			// position 1 is the backup if there are updates in
1454 			// the current round
1455 			voting[_candidate][1] = voting[_candidate][0];
1456 		}
1457 		// position 0 always hold the up-to-date vote balance
1458 		voting[_candidate][0] = _votes;
1459 	}
1460 }
1461 
1462 // File: contracts/GTokens.sol
1463 
1464 pragma solidity ^0.6.0;
1465 
1466 
1467 
1468 /**
1469  * @notice Definition of stkGRO. As a gToken Type 3, it uses GRO as reserve and
1470  * burns both reserve and supply with each operation.
1471  */
1472 contract stkGRO is GTokenType3
1473 {
1474 	constructor ()
1475 		GTokenType3("staked GRO", "stkGRO", 18, $.GRO) public
1476 	{
1477 	}
1478 }