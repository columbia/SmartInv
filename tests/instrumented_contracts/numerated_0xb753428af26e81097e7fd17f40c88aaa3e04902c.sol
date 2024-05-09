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
30 pragma solidity ^0.7.1;
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
106 // File: contracts/lib/SafeMath.sol
107 
108 pragma solidity ^0.7.1;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: contracts/lib/Address.sol
267 
268 pragma solidity ^0.7.1;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize, which returns 0 for contracts in
293         // construction, since the code is only stored at the end of the
294         // constructor execution.
295 
296         uint256 size;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { size := extcodesize(account) }
299         return size > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{ value: amount }("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain`call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345         return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         require(isContract(target), "Address: call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.call{ value: value }(data);
385         return _verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
395         return functionStaticCall(target, data, "Address: low-level static call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         // solhint-disable-next-line avoid-low-level-calls
408         (bool success, bytes memory returndata) = target.staticcall(data);
409         return _verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a delegate call.
415      *
416      * _Available since v3.3._
417      */
418     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
419         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a delegate call.
425      *
426      * _Available since v3.3._
427      */
428     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
429         require(isContract(target), "Address: delegate call to non-contract");
430 
431         // solhint-disable-next-line avoid-low-level-calls
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return _verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
437         if (success) {
438             return returndata;
439         } else {
440             // Look for revert reason and bubble it up if present
441             if (returndata.length > 0) {
442                 // The easiest way to bubble the revert reason is using memory via assembly
443 
444                 // solhint-disable-next-line no-inline-assembly
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 // File: contracts/lib/ERC20.sol
457 
458 pragma solidity ^0.7.1;
459 
460 
461 
462 
463 
464 /**
465  * @dev Implementation of the {IERC20} interface.
466  *
467  * This implementation is agnostic to the way tokens are created. This means
468  * that a supply mechanism has to be added in a derived contract using {_mint}.
469  * For a generic mechanism see {ERC20PresetMinterPauser}.
470  *
471  * TIP: For a detailed writeup see our guide
472  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
473  * to implement supply mechanisms].
474  *
475  * We have followed general OpenZeppelin guidelines: functions revert instead
476  * of returning `false` on failure. This behavior is nonetheless conventional
477  * and does not conflict with the expectations of ERC20 applications.
478  *
479  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
480  * This allows applications to reconstruct the allowance for all accounts just
481  * by listening to said events. Other implementations of the EIP may not emit
482  * these events, as it isn't required by the specification.
483  *
484  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
485  * functions have been added to mitigate the well-known issues around setting
486  * allowances. See {IERC20-approve}.
487  */
488 contract ERC20 is Context, IERC20 {
489     using SafeMath for uint256;
490     using Address for address;
491 
492     mapping (address => uint256) private _balances;
493 
494     mapping (address => mapping (address => uint256)) private _allowances;
495 
496     uint256 private _totalSupply;
497 
498     string private _name;
499     string private _symbol;
500     uint8 private _decimals;
501 
502     /**
503      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
504      * a default value of 18.
505      *
506      * To select a different value for {decimals}, use {_setupDecimals}.
507      *
508      * All three of these values are immutable: they can only be set once during
509      * construction.
510      */
511     constructor (string memory name_, string memory symbol_) {
512         _name = name_;
513         _symbol = symbol_;
514         _decimals = 18;
515     }
516 
517     /**
518      * @dev Returns the name of the token.
519      */
520     function name() public view returns (string memory) {
521         return _name;
522     }
523 
524     /**
525      * @dev Returns the symbol of the token, usually a shorter version of the
526      * name.
527      */
528     function symbol() public view returns (string memory) {
529         return _symbol;
530     }
531 
532     /**
533      * @dev Returns the number of decimals used to get its user representation.
534      * For example, if `decimals` equals `2`, a balance of `505` tokens should
535      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
536      *
537      * Tokens usually opt for a value of 18, imitating the relationship between
538      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
539      * called.
540      *
541      * NOTE: This information is only used for _display_ purposes: it in
542      * no way affects any of the arithmetic of the contract, including
543      * {IERC20-balanceOf} and {IERC20-transfer}.
544      */
545     function decimals() public view returns (uint8) {
546         return _decimals;
547     }
548 
549     /**
550      * @dev See {IERC20-totalSupply}.
551      */
552     function totalSupply() public view override returns (uint256) {
553         return _totalSupply;
554     }
555 
556     /**
557      * @dev See {IERC20-balanceOf}.
558      */
559     function balanceOf(address account) public view override returns (uint256) {
560         return _balances[account];
561     }
562 
563     /**
564      * @dev See {IERC20-transfer}.
565      *
566      * Requirements:
567      *
568      * - `recipient` cannot be the zero address.
569      * - the caller must have a balance of at least `amount`.
570      */
571     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
572         _transfer(_msgSender(), recipient, amount);
573         return true;
574     }
575 
576     /**
577      * @dev See {IERC20-allowance}.
578      */
579     function allowance(address owner, address spender) public view virtual override returns (uint256) {
580         return _allowances[owner][spender];
581     }
582 
583     /**
584      * @dev See {IERC20-approve}.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      */
590     function approve(address spender, uint256 amount) public virtual override returns (bool) {
591         _approve(_msgSender(), spender, amount);
592         return true;
593     }
594 
595     /**
596      * @dev See {IERC20-transferFrom}.
597      *
598      * Emits an {Approval} event indicating the updated allowance. This is not
599      * required by the EIP. See the note at the beginning of {ERC20};
600      *
601      * Requirements:
602      * - `sender` and `recipient` cannot be the zero address.
603      * - `sender` must have a balance of at least `amount`.
604      * - the caller must have allowance for ``sender``'s tokens of at least
605      * `amount`.
606      */
607     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
608         _transfer(sender, recipient, amount);
609         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
610         return true;
611     }
612 
613     /**
614      * @dev Atomically increases the allowance granted to `spender` by the caller.
615      *
616      * This is an alternative to {approve} that can be used as a mitigation for
617      * problems described in {IERC20-approve}.
618      *
619      * Emits an {Approval} event indicating the updated allowance.
620      *
621      * Requirements:
622      *
623      * - `spender` cannot be the zero address.
624      */
625     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
626         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
627         return true;
628     }
629 
630     /**
631      * @dev Atomically decreases the allowance granted to `spender` by the caller.
632      *
633      * This is an alternative to {approve} that can be used as a mitigation for
634      * problems described in {IERC20-approve}.
635      *
636      * Emits an {Approval} event indicating the updated allowance.
637      *
638      * Requirements:
639      *
640      * - `spender` cannot be the zero address.
641      * - `spender` must have allowance for the caller of at least
642      * `subtractedValue`.
643      */
644     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
645         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
646         return true;
647     }
648 
649     /**
650      * @dev Moves tokens `amount` from `sender` to `recipient`.
651      *
652      * This is internal function is equivalent to {transfer}, and can be used to
653      * e.g. implement automatic token fees, slashing mechanisms, etc.
654      *
655      * Emits a {Transfer} event.
656      *
657      * Requirements:
658      *
659      * - `sender` cannot be the zero address.
660      * - `recipient` cannot be the zero address.
661      * - `sender` must have a balance of at least `amount`.
662      */
663     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
664         require(sender != address(0), "ERC20: transfer from the zero address");
665         require(recipient != address(0), "ERC20: transfer to the zero address");
666 
667         _beforeTokenTransfer(sender, recipient, amount);
668 
669         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
670         _balances[recipient] = _balances[recipient].add(amount);
671         emit Transfer(sender, recipient, amount);
672     }
673 
674     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
675      * the total supply.
676      *
677      * Emits a {Transfer} event with `from` set to the zero address.
678      *
679      * Requirements
680      *
681      * - `to` cannot be the zero address.
682      */
683     function _mint(address account, uint256 amount) internal virtual {
684         require(account != address(0), "ERC20: mint to the zero address");
685 
686         _beforeTokenTransfer(address(0), account, amount);
687 
688         _totalSupply = _totalSupply.add(amount);
689         _balances[account] = _balances[account].add(amount);
690         emit Transfer(address(0), account, amount);
691     }
692 
693     /**
694      * @dev Destroys `amount` tokens from `account`, reducing the
695      * total supply.
696      *
697      * Emits a {Transfer} event with `to` set to the zero address.
698      *
699      * Requirements
700      *
701      * - `account` cannot be the zero address.
702      * - `account` must have at least `amount` tokens.
703      */
704     function _burn(address account, uint256 amount) internal virtual {
705         require(account != address(0), "ERC20: burn from the zero address");
706 
707         _beforeTokenTransfer(account, address(0), amount);
708 
709         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
710         _totalSupply = _totalSupply.sub(amount);
711         emit Transfer(account, address(0), amount);
712     }
713 
714     /**
715      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
716      *
717      * This is internal function is equivalent to `approve`, and can be used to
718      * e.g. set automatic allowances for certain subsystems, etc.
719      *
720      * Emits an {Approval} event.
721      *
722      * Requirements:
723      *
724      * - `owner` cannot be the zero address.
725      * - `spender` cannot be the zero address.
726      */
727     function _approve(address owner, address spender, uint256 amount) internal virtual {
728         require(owner != address(0), "ERC20: approve from the zero address");
729         require(spender != address(0), "ERC20: approve to the zero address");
730 
731         _allowances[owner][spender] = amount;
732         emit Approval(owner, spender, amount);
733     }
734 
735     /**
736      * @dev Sets {decimals} to a value other than the default one of 18.
737      *
738      * WARNING: This function should only be called from the constructor. Most
739      * applications that interact with token contracts will not expect
740      * {decimals} to ever change, and may work incorrectly if it does.
741      */
742     function _setupDecimals(uint8 decimals_) internal {
743         _decimals = decimals_;
744     }
745 
746     /**
747      * @dev Hook that is called before any transfer of tokens. This includes
748      * minting and burning.
749      *
750      * Calling conditions:
751      *
752      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
753      * will be to transferred to `to`.
754      * - when `from` is zero, `amount` tokens will be minted for `to`.
755      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
756      * - `from` and `to` are never both zero.
757      *
758      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
759      */
760     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
761 }
762 
763 // File: contracts/lib/SafeERC20.sol
764 
765 pragma solidity ^0.7.1;
766 
767 
768 
769 
770 /**
771  * @title SafeERC20
772  * @dev Wrappers around ERC20 operations that throw on failure (when the token
773  * contract returns false). Tokens that return no value (and instead revert or
774  * throw on failure) are also supported, non-reverting calls are assumed to be
775  * successful.
776  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
777  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
778  */
779 library SafeERC20 {
780   using SafeMath for uint256;
781   using Address for address;
782 
783   function safeTransfer(IERC20 token, address to, uint256 value) internal {
784     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
785   }
786 
787   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
788     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
789   }
790 
791   /**
792    * @dev Deprecated. This function has issues similar to the ones found in
793    * {IERC20-approve}, and its usage is discouraged.
794    *
795    * Whenever possible, use {safeIncreaseAllowance} and
796    * {safeDecreaseAllowance} instead.
797    */
798   function safeApprove(IERC20 token, address spender, uint256 value) internal {
799     // safeApprove should only be called when setting an initial allowance,
800     // or when resetting it to zero. To increase and decrease it, use
801     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
802     // solhint-disable-next-line max-line-length
803     require((value == 0) || (token.allowance(address(this), spender) == 0),
804       "SafeERC20: approve from non-zero to non-zero allowance"
805     );
806     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
807   }
808 
809   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
810     uint256 newAllowance = token.allowance(address(this), spender).add(value);
811     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
812   }
813 
814   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
815     uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
816     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
817   }
818 
819   /**
820    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
821    * on the return value: the return value is optional (but if data is returned, it must not be false).
822    * @param token The token targeted by the call.
823    * @param data The call data (encoded using abi.encode or one of its variants).
824    */
825   function _callOptionalReturn(IERC20 token, bytes memory data) private {
826     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
827     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
828     // the target address contains contract code and also asserts for success in the low-level call.
829 
830     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
831     if (returndata.length > 0) { // Return data is optional
832       // solhint-disable-next-line max-line-length
833       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
834     }
835   }
836 }
837 
838 // File: contracts/SFI.sol
839 
840 pragma solidity ^0.7.1;
841 
842 
843 
844 contract SFI is ERC20 {
845   using SafeERC20 for IERC20;
846 
847   address public governance;
848   address public SFI_minter;
849   uint256 public MAX_TOKENS = 100000 ether;
850 
851   constructor (string memory name, string memory symbol) ERC20(name, symbol) {
852     // Initial governance is Saffron Deployer
853     governance = msg.sender;
854   }
855 
856   function mint_SFI(address to, uint256 amount) public {
857     require(msg.sender == SFI_minter, "must be SFI_minter");
858     require(this.totalSupply() + amount < MAX_TOKENS, "cannot mint more than MAX_TOKENS");
859     _mint(to, amount);
860   }
861 
862   function set_minter(address to) external {
863     require(msg.sender == governance, "must be governance");
864     SFI_minter = to;
865   }
866 
867   function set_governance(address to) external {
868     require(msg.sender == governance, "must be governance");
869     governance = to;
870   }
871 
872   event ErcSwept(address who, address to, address token, uint256 amount);
873   function erc_sweep(address _token, address _to) public {
874     require(msg.sender == governance, "must be governance");
875 
876     IERC20 tkn = IERC20(_token);
877     uint256 tBal = tkn.balanceOf(address(this));
878     tkn.safeTransfer(_to, tBal);
879 
880     emit ErcSwept(msg.sender, _to, _token, tBal);
881   }
882 }