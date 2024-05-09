1 // File: contracts/lib/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.1;
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
28 // File: contracts/lib/IERC20.sol
29 
30 
31 pragma solidity ^0.7.1;
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
107 // File: contracts/lib/SafeMath.sol
108 
109 
110 pragma solidity ^0.7.1;
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
268 // File: contracts/lib/Address.sol
269 
270 
271 pragma solidity ^0.7.1;
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
295         // This method relies on extcodesize, which returns 0 for contracts in
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
348         return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, 0, errorMessage);
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
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: value }(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
398         return functionStaticCall(target, data, "Address: low-level static call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
408         require(isContract(target), "Address: static call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.3._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.3._
430      */
431     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.delegatecall(data);
436         return _verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 // solhint-disable-next-line no-inline-assembly
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 // File: contracts/lib/ERC20.sol
460 
461 
462 pragma solidity ^0.7.1;
463 
464 
465 
466 
467 
468 /**
469  * @dev Implementation of the {IERC20} interface.
470  *
471  * This implementation is agnostic to the way tokens are created. This means
472  * that a supply mechanism has to be added in a derived contract using {_mint}.
473  * For a generic mechanism see {ERC20PresetMinterPauser}.
474  *
475  * TIP: For a detailed writeup see our guide
476  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
477  * to implement supply mechanisms].
478  *
479  * We have followed general OpenZeppelin guidelines: functions revert instead
480  * of returning `false` on failure. This behavior is nonetheless conventional
481  * and does not conflict with the expectations of ERC20 applications.
482  *
483  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
484  * This allows applications to reconstruct the allowance for all accounts just
485  * by listening to said events. Other implementations of the EIP may not emit
486  * these events, as it isn't required by the specification.
487  *
488  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
489  * functions have been added to mitigate the well-known issues around setting
490  * allowances. See {IERC20-approve}.
491  */
492 contract ERC20 is Context, IERC20 {
493     using SafeMath for uint256;
494     using Address for address;
495 
496     mapping (address => uint256) private _balances;
497 
498     mapping (address => mapping (address => uint256)) private _allowances;
499 
500     uint256 private _totalSupply;
501 
502     string private _name;
503     string private _symbol;
504     uint8 private _decimals;
505 
506     /**
507      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
508      * a default value of 18.
509      *
510      * To select a different value for {decimals}, use {_setupDecimals}.
511      *
512      * All three of these values are immutable: they can only be set once during
513      * construction.
514      */
515     constructor (string memory name_, string memory symbol_) {
516         _name = name_;
517         _symbol = symbol_;
518         _decimals = 18;
519     }
520 
521     /**
522      * @dev Returns the name of the token.
523      */
524     function name() public view returns (string memory) {
525         return _name;
526     }
527 
528     /**
529      * @dev Returns the symbol of the token, usually a shorter version of the
530      * name.
531      */
532     function symbol() public view returns (string memory) {
533         return _symbol;
534     }
535 
536     /**
537      * @dev Returns the number of decimals used to get its user representation.
538      * For example, if `decimals` equals `2`, a balance of `505` tokens should
539      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
540      *
541      * Tokens usually opt for a value of 18, imitating the relationship between
542      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
543      * called.
544      *
545      * NOTE: This information is only used for _display_ purposes: it in
546      * no way affects any of the arithmetic of the contract, including
547      * {IERC20-balanceOf} and {IERC20-transfer}.
548      */
549     function decimals() public view returns (uint8) {
550         return _decimals;
551     }
552 
553     /**
554      * @dev See {IERC20-totalSupply}.
555      */
556     function totalSupply() public view override returns (uint256) {
557         return _totalSupply;
558     }
559 
560     /**
561      * @dev See {IERC20-balanceOf}.
562      */
563     function balanceOf(address account) public view override returns (uint256) {
564         return _balances[account];
565     }
566 
567     /**
568      * @dev See {IERC20-transfer}.
569      *
570      * Requirements:
571      *
572      * - `recipient` cannot be the zero address.
573      * - the caller must have a balance of at least `amount`.
574      */
575     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
576         _transfer(_msgSender(), recipient, amount);
577         return true;
578     }
579 
580     /**
581      * @dev See {IERC20-allowance}.
582      */
583     function allowance(address owner, address spender) public view virtual override returns (uint256) {
584         return _allowances[owner][spender];
585     }
586 
587     /**
588      * @dev See {IERC20-approve}.
589      *
590      * Requirements:
591      *
592      * - `spender` cannot be the zero address.
593      */
594     function approve(address spender, uint256 amount) public virtual override returns (bool) {
595         _approve(_msgSender(), spender, amount);
596         return true;
597     }
598 
599     /**
600      * @dev See {IERC20-transferFrom}.
601      *
602      * Emits an {Approval} event indicating the updated allowance. This is not
603      * required by the EIP. See the note at the beginning of {ERC20};
604      *
605      * Requirements:
606      * - `sender` and `recipient` cannot be the zero address.
607      * - `sender` must have a balance of at least `amount`.
608      * - the caller must have allowance for ``sender``'s tokens of at least
609      * `amount`.
610      */
611     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
612         _transfer(sender, recipient, amount);
613         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
614         return true;
615     }
616 
617     /**
618      * @dev Atomically increases the allowance granted to `spender` by the caller.
619      *
620      * This is an alternative to {approve} that can be used as a mitigation for
621      * problems described in {IERC20-approve}.
622      *
623      * Emits an {Approval} event indicating the updated allowance.
624      *
625      * Requirements:
626      *
627      * - `spender` cannot be the zero address.
628      */
629     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
630         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
631         return true;
632     }
633 
634     /**
635      * @dev Atomically decreases the allowance granted to `spender` by the caller.
636      *
637      * This is an alternative to {approve} that can be used as a mitigation for
638      * problems described in {IERC20-approve}.
639      *
640      * Emits an {Approval} event indicating the updated allowance.
641      *
642      * Requirements:
643      *
644      * - `spender` cannot be the zero address.
645      * - `spender` must have allowance for the caller of at least
646      * `subtractedValue`.
647      */
648     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
649         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
650         return true;
651     }
652 
653     /**
654      * @dev Moves tokens `amount` from `sender` to `recipient`.
655      *
656      * This is internal function is equivalent to {transfer}, and can be used to
657      * e.g. implement automatic token fees, slashing mechanisms, etc.
658      *
659      * Emits a {Transfer} event.
660      *
661      * Requirements:
662      *
663      * - `sender` cannot be the zero address.
664      * - `recipient` cannot be the zero address.
665      * - `sender` must have a balance of at least `amount`.
666      */
667     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
668         require(sender != address(0), "ERC20: transfer from the zero address");
669         require(recipient != address(0), "ERC20: transfer to the zero address");
670 
671         _beforeTokenTransfer(sender, recipient, amount);
672 
673         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
674         _balances[recipient] = _balances[recipient].add(amount);
675         emit Transfer(sender, recipient, amount);
676     }
677 
678     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
679      * the total supply.
680      *
681      * Emits a {Transfer} event with `from` set to the zero address.
682      *
683      * Requirements
684      *
685      * - `to` cannot be the zero address.
686      */
687     function _mint(address account, uint256 amount) internal virtual {
688         require(account != address(0), "ERC20: mint to the zero address");
689 
690         _beforeTokenTransfer(address(0), account, amount);
691 
692         _totalSupply = _totalSupply.add(amount);
693         _balances[account] = _balances[account].add(amount);
694         emit Transfer(address(0), account, amount);
695     }
696 
697     /**
698      * @dev Destroys `amount` tokens from `account`, reducing the
699      * total supply.
700      *
701      * Emits a {Transfer} event with `to` set to the zero address.
702      *
703      * Requirements
704      *
705      * - `account` cannot be the zero address.
706      * - `account` must have at least `amount` tokens.
707      */
708     function _burn(address account, uint256 amount) internal virtual {
709         require(account != address(0), "ERC20: burn from the zero address");
710 
711         _beforeTokenTransfer(account, address(0), amount);
712 
713         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
714         _totalSupply = _totalSupply.sub(amount);
715         emit Transfer(account, address(0), amount);
716     }
717 
718     /**
719      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
720      *
721      * This is internal function is equivalent to `approve`, and can be used to
722      * e.g. set automatic allowances for certain subsystems, etc.
723      *
724      * Emits an {Approval} event.
725      *
726      * Requirements:
727      *
728      * - `owner` cannot be the zero address.
729      * - `spender` cannot be the zero address.
730      */
731     function _approve(address owner, address spender, uint256 amount) internal virtual {
732         require(owner != address(0), "ERC20: approve from the zero address");
733         require(spender != address(0), "ERC20: approve to the zero address");
734 
735         _allowances[owner][spender] = amount;
736         emit Approval(owner, spender, amount);
737     }
738 
739     /**
740      * @dev Sets {decimals} to a value other than the default one of 18.
741      *
742      * WARNING: This function should only be called from the constructor. Most
743      * applications that interact with token contracts will not expect
744      * {decimals} to ever change, and may work incorrectly if it does.
745      */
746     function _setupDecimals(uint8 decimals_) internal {
747         _decimals = decimals_;
748     }
749 
750     /**
751      * @dev Hook that is called before any transfer of tokens. This includes
752      * minting and burning.
753      *
754      * Calling conditions:
755      *
756      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
757      * will be to transferred to `to`.
758      * - when `from` is zero, `amount` tokens will be minted for `to`.
759      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
760      * - `from` and `to` are never both zero.
761      *
762      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
763      */
764     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
765 }
766 
767 // File: contracts/lib/SafeERC20.sol
768 
769 
770 pragma solidity ^0.7.1;
771 
772 
773 
774 
775 /**
776  * @title SafeERC20
777  * @dev Wrappers around ERC20 operations that throw on failure (when the token
778  * contract returns false). Tokens that return no value (and instead revert or
779  * throw on failure) are also supported, non-reverting calls are assumed to be
780  * successful.
781  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
782  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
783  */
784 library SafeERC20 {
785   using SafeMath for uint256;
786   using Address for address;
787 
788   function safeTransfer(IERC20 token, address to, uint256 value) internal {
789     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
790   }
791 
792   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
793     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
794   }
795 
796   /**
797    * @dev Deprecated. This function has issues similar to the ones found in
798    * {IERC20-approve}, and its usage is discouraged.
799    *
800    * Whenever possible, use {safeIncreaseAllowance} and
801    * {safeDecreaseAllowance} instead.
802    */
803   function safeApprove(IERC20 token, address spender, uint256 value) internal {
804     // safeApprove should only be called when setting an initial allowance,
805     // or when resetting it to zero. To increase and decrease it, use
806     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
807     // solhint-disable-next-line max-line-length
808     require((value == 0) || (token.allowance(address(this), spender) == 0),
809       "SafeERC20: approve from non-zero to non-zero allowance"
810     );
811     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
812   }
813 
814   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
815     uint256 newAllowance = token.allowance(address(this), spender).add(value);
816     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
817   }
818 
819   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
820     uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
821     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
822   }
823 
824   /**
825    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
826    * on the return value: the return value is optional (but if data is returned, it must not be false).
827    * @param token The token targeted by the call.
828    * @param data The call data (encoded using abi.encode or one of its variants).
829    */
830   function _callOptionalReturn(IERC20 token, bytes memory data) private {
831     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
832     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
833     // the target address contains contract code and also asserts for success in the low-level call.
834 
835     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
836     if (returndata.length > 0) { // Return data is optional
837       // solhint-disable-next-line max-line-length
838       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
839     }
840   }
841 }
842 
843 // File: contracts/rSFI.sol
844 
845 
846 pragma solidity ^0.7.1;
847 
848 
849 
850 contract rSFI is ERC20 {
851   using SafeERC20 for IERC20;
852 
853   address public governance;
854   address public rSFI_minter;
855   uint256 public constant MAX_TOKENS = 15489020891056530000000;
856 
857   constructor (string memory name, string memory symbol) ERC20(name, symbol) {
858     // Initial governance is Saffron Deployer
859     governance = msg.sender;
860   }
861 
862   function mint_rSFI(address to, uint256 amount) public {
863     require(msg.sender == rSFI_minter, "must be rSFI_minter");
864     require(this.totalSupply() + amount < MAX_TOKENS, "cannot mint more than MAX_TOKENS");
865     _mint(to, amount);
866   }
867 
868   function set_minter(address to) external {
869     require(msg.sender == governance, "must be governance");
870     rSFI_minter = to;
871   }
872 
873   function set_governance(address to) external {
874     require(msg.sender == governance, "must be governance");
875     governance = to;
876   }
877 
878   event ErcSwept(address who, address to, address token, uint256 amount);
879   function erc_sweep(address _token, address _to) public {
880     require(msg.sender == governance, "must be governance");
881 
882     IERC20 tkn = IERC20(_token);
883     uint256 tBal = tkn.balanceOf(address(this));
884     tkn.safeTransfer(_to, tBal);
885 
886     emit ErcSwept(msg.sender, _to, _token, tBal);
887   }
888 }