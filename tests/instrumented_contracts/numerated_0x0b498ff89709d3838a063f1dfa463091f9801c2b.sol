1 // Dependency file: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 
5 // pragma solidity >=0.6.2 <0.8.0;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [// importANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies on extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { size := extcodesize(account) }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * // importANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: value }(data);
122         return _verifyCallResult(success, returndata, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
127      * but performing a static call.
128      *
129      * _Available since v3.3._
130      */
131     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
132         return functionStaticCall(target, data, "Address: low-level static call failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
137      * but performing a static call.
138      *
139      * _Available since v3.3._
140      */
141     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
142         require(isContract(target), "Address: static call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.staticcall(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
150         if (success) {
151             return returndata;
152         } else {
153             // Look for revert reason and bubble it up if present
154             if (returndata.length > 0) {
155                 // The easiest way to bubble the revert reason is using memory via assembly
156 
157                 // solhint-disable-next-line no-inline-assembly
158                 assembly {
159                     let returndata_size := mload(returndata)
160                     revert(add(32, returndata), returndata_size)
161                 }
162             } else {
163                 revert(errorMessage);
164             }
165         }
166     }
167 }
168 
169 
170 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
171 
172 
173 // pragma solidity >=0.6.0 <0.8.0;
174 
175 /*
176  * @dev Provides information about the current execution context, including the
177  * sender of the transaction and its data. While these are generally available
178  * via msg.sender and msg.data, they should not be accessed in such a direct
179  * manner, since when dealing with GSN meta-transactions the account sending and
180  * paying for execution may not be the actual sender (as far as an application
181  * is concerned).
182  *
183  * This contract is only required for intermediate, library-like contracts.
184  */
185 abstract contract Context {
186     function _msgSender() internal view virtual returns (address payable) {
187         return msg.sender;
188     }
189 
190     function _msgData() internal view virtual returns (bytes memory) {
191         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
192         return msg.data;
193     }
194 }
195 
196 
197 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
198 
199 
200 // pragma solidity >=0.6.0 <0.8.0;
201 
202 /**
203  * @dev Interface of the ERC20 standard as defined in the EIP.
204  */
205 interface IERC20 {
206     /**
207      * @dev Returns the amount of tokens in existence.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     /**
212      * @dev Returns the amount of tokens owned by `account`.
213      */
214     function balanceOf(address account) external view returns (uint256);
215 
216     /**
217      * @dev Moves `amount` tokens from the caller's account to `recipient`.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transfer(address recipient, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Returns the remaining number of tokens that `spender` will be
227      * allowed to spend on behalf of `owner` through {transferFrom}. This is
228      * zero by default.
229      *
230      * This value changes when {approve} or {transferFrom} are called.
231      */
232     function allowance(address owner, address spender) external view returns (uint256);
233 
234     /**
235      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * // importANT: Beware that changing an allowance with this method brings the risk
240      * that someone may use both the old and the new allowance by unfortunate
241      * transaction ordering. One possible solution to mitigate this race
242      * condition is to first reduce the spender's allowance to 0 and set the
243      * desired value afterwards:
244      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245      *
246      * Emits an {Approval} event.
247      */
248     function approve(address spender, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Moves `amount` tokens from `sender` to `recipient` using the
252      * allowance mechanism. `amount` is then deducted from the caller's
253      * allowance.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Emitted when `value` tokens are moved from one account (`from`) to
263      * another (`to`).
264      *
265      * Note that `value` may be zero.
266      */
267     event Transfer(address indexed from, address indexed to, uint256 value);
268 
269     /**
270      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
271      * a call to {approve}. `value` is the new allowance.
272      */
273     event Approval(address indexed owner, address indexed spender, uint256 value);
274 }
275 
276 
277 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
278 
279 
280 // pragma solidity >=0.6.0 <0.8.0;
281 
282 /**
283  * @dev Wrappers over Solidity's arithmetic operations with added overflow
284  * checks.
285  *
286  * Arithmetic operations in Solidity wrap on overflow. This can easily result
287  * in bugs, because programmers usually assume that an overflow raises an
288  * error, which is the standard behavior in high level programming languages.
289  * `SafeMath` restores this intuition by reverting the transaction when an
290  * operation overflows.
291  *
292  * Using this library instead of the unchecked operations eliminates an entire
293  * class of bugs, so it's recommended to use it always.
294  */
295 library SafeMath {
296     /**
297      * @dev Returns the addition of two unsigned integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `+` operator.
301      *
302      * Requirements:
303      *
304      * - Addition cannot overflow.
305      */
306     function add(uint256 a, uint256 b) internal pure returns (uint256) {
307         uint256 c = a + b;
308         require(c >= a, "SafeMath: addition overflow");
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the subtraction of two unsigned integers, reverting on
315      * overflow (when the result is negative).
316      *
317      * Counterpart to Solidity's `-` operator.
318      *
319      * Requirements:
320      *
321      * - Subtraction cannot overflow.
322      */
323     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
324         return sub(a, b, "SafeMath: subtraction overflow");
325     }
326 
327     /**
328      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
329      * overflow (when the result is negative).
330      *
331      * Counterpart to Solidity's `-` operator.
332      *
333      * Requirements:
334      *
335      * - Subtraction cannot overflow.
336      */
337     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         require(b <= a, errorMessage);
339         uint256 c = a - b;
340 
341         return c;
342     }
343 
344     /**
345      * @dev Returns the multiplication of two unsigned integers, reverting on
346      * overflow.
347      *
348      * Counterpart to Solidity's `*` operator.
349      *
350      * Requirements:
351      *
352      * - Multiplication cannot overflow.
353      */
354     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
355         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
356         // benefit is lost if 'b' is also tested.
357         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
358         if (a == 0) {
359             return 0;
360         }
361 
362         uint256 c = a * b;
363         require(c / a == b, "SafeMath: multiplication overflow");
364 
365         return c;
366     }
367 
368     /**
369      * @dev Returns the integer division of two unsigned integers. Reverts on
370      * division by zero. The result is rounded towards zero.
371      *
372      * Counterpart to Solidity's `/` operator. Note: this function uses a
373      * `revert` opcode (which leaves remaining gas untouched) while Solidity
374      * uses an invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      *
378      * - The divisor cannot be zero.
379      */
380     function div(uint256 a, uint256 b) internal pure returns (uint256) {
381         return div(a, b, "SafeMath: division by zero");
382     }
383 
384     /**
385      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
386      * division by zero. The result is rounded towards zero.
387      *
388      * Counterpart to Solidity's `/` operator. Note: this function uses a
389      * `revert` opcode (which leaves remaining gas untouched) while Solidity
390      * uses an invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      *
394      * - The divisor cannot be zero.
395      */
396     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
397         require(b > 0, errorMessage);
398         uint256 c = a / b;
399         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
400 
401         return c;
402     }
403 
404     /**
405      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
406      * Reverts when dividing by zero.
407      *
408      * Counterpart to Solidity's `%` operator. This function uses a `revert`
409      * opcode (which leaves remaining gas untouched) while Solidity uses an
410      * invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      *
414      * - The divisor cannot be zero.
415      */
416     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
417         return mod(a, b, "SafeMath: modulo by zero");
418     }
419 
420     /**
421      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
422      * Reverts with custom message when dividing by zero.
423      *
424      * Counterpart to Solidity's `%` operator. This function uses a `revert`
425      * opcode (which leaves remaining gas untouched) while Solidity uses an
426      * invalid opcode to revert (consuming all remaining gas).
427      *
428      * Requirements:
429      *
430      * - The divisor cannot be zero.
431      */
432     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
433         require(b != 0, errorMessage);
434         return a % b;
435     }
436 }
437 
438 
439 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
440 
441 
442 // pragma solidity >=0.6.0 <0.8.0;
443 
444 // import "@openzeppelin/contracts/GSN/Context.sol";
445 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
446 // import "@openzeppelin/contracts/math/SafeMath.sol";
447 
448 /**
449  * @dev Implementation of the {IERC20} interface.
450  *
451  * This implementation is agnostic to the way tokens are created. This means
452  * that a supply mechanism has to be added in a derived contract using {_mint}.
453  * For a generic mechanism see {ERC20PresetMinterPauser}.
454  *
455  * TIP: For a detailed writeup see our guide
456  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
457  * to implement supply mechanisms].
458  *
459  * We have followed general OpenZeppelin guidelines: functions revert instead
460  * of returning `false` on failure. This behavior is nonetheless conventional
461  * and does not conflict with the expectations of ERC20 applications.
462  *
463  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
464  * This allows applications to reconstruct the allowance for all accounts just
465  * by listening to said events. Other implementations of the EIP may not emit
466  * these events, as it isn't required by the specification.
467  *
468  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
469  * functions have been added to mitigate the well-known issues around setting
470  * allowances. See {IERC20-approve}.
471  */
472 contract ERC20 is Context, IERC20 {
473     using SafeMath for uint256;
474 
475     mapping (address => uint256) private _balances;
476 
477     mapping (address => mapping (address => uint256)) private _allowances;
478 
479     uint256 private _totalSupply;
480 
481     string private _name;
482     string private _symbol;
483     uint8 private _decimals;
484 
485     /**
486      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
487      * a default value of 18.
488      *
489      * To select a different value for {decimals}, use {_setupDecimals}.
490      *
491      * All three of these values are immutable: they can only be set once during
492      * construction.
493      */
494     constructor (string memory name_, string memory symbol_) public {
495         _name = name_;
496         _symbol = symbol_;
497         _decimals = 18;
498     }
499 
500     /**
501      * @dev Returns the name of the token.
502      */
503     function name() public view returns (string memory) {
504         return _name;
505     }
506 
507     /**
508      * @dev Returns the symbol of the token, usually a shorter version of the
509      * name.
510      */
511     function symbol() public view returns (string memory) {
512         return _symbol;
513     }
514 
515     /**
516      * @dev Returns the number of decimals used to get its user representation.
517      * For example, if `decimals` equals `2`, a balance of `505` tokens should
518      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
519      *
520      * Tokens usually opt for a value of 18, imitating the relationship between
521      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
522      * called.
523      *
524      * NOTE: This information is only used for _display_ purposes: it in
525      * no way affects any of the arithmetic of the contract, including
526      * {IERC20-balanceOf} and {IERC20-transfer}.
527      */
528     function decimals() public view returns (uint8) {
529         return _decimals;
530     }
531 
532     /**
533      * @dev See {IERC20-totalSupply}.
534      */
535     function totalSupply() public view override returns (uint256) {
536         return _totalSupply;
537     }
538 
539     /**
540      * @dev See {IERC20-balanceOf}.
541      */
542     function balanceOf(address account) public view override returns (uint256) {
543         return _balances[account];
544     }
545 
546     /**
547      * @dev See {IERC20-transfer}.
548      *
549      * Requirements:
550      *
551      * - `recipient` cannot be the zero address.
552      * - the caller must have a balance of at least `amount`.
553      */
554     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
555         _transfer(_msgSender(), recipient, amount);
556         return true;
557     }
558 
559     /**
560      * @dev See {IERC20-allowance}.
561      */
562     function allowance(address owner, address spender) public view virtual override returns (uint256) {
563         return _allowances[owner][spender];
564     }
565 
566     /**
567      * @dev See {IERC20-approve}.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      */
573     function approve(address spender, uint256 amount) public virtual override returns (bool) {
574         _approve(_msgSender(), spender, amount);
575         return true;
576     }
577 
578     /**
579      * @dev See {IERC20-transferFrom}.
580      *
581      * Emits an {Approval} event indicating the updated allowance. This is not
582      * required by the EIP. See the note at the beginning of {ERC20}.
583      *
584      * Requirements:
585      *
586      * - `sender` and `recipient` cannot be the zero address.
587      * - `sender` must have a balance of at least `amount`.
588      * - the caller must have allowance for ``sender``'s tokens of at least
589      * `amount`.
590      */
591     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
592         _transfer(sender, recipient, amount);
593         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
594         return true;
595     }
596 
597     /**
598      * @dev Atomically increases the allowance granted to `spender` by the caller.
599      *
600      * This is an alternative to {approve} that can be used as a mitigation for
601      * problems described in {IERC20-approve}.
602      *
603      * Emits an {Approval} event indicating the updated allowance.
604      *
605      * Requirements:
606      *
607      * - `spender` cannot be the zero address.
608      */
609     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
610         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
611         return true;
612     }
613 
614     /**
615      * @dev Atomically decreases the allowance granted to `spender` by the caller.
616      *
617      * This is an alternative to {approve} that can be used as a mitigation for
618      * problems described in {IERC20-approve}.
619      *
620      * Emits an {Approval} event indicating the updated allowance.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      * - `spender` must have allowance for the caller of at least
626      * `subtractedValue`.
627      */
628     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
629         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
630         return true;
631     }
632 
633     /**
634      * @dev Moves tokens `amount` from `sender` to `recipient`.
635      *
636      * This is internal function is equivalent to {transfer}, and can be used to
637      * e.g. implement automatic token fees, slashing mechanisms, etc.
638      *
639      * Emits a {Transfer} event.
640      *
641      * Requirements:
642      *
643      * - `sender` cannot be the zero address.
644      * - `recipient` cannot be the zero address.
645      * - `sender` must have a balance of at least `amount`.
646      */
647     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
648         require(sender != address(0), "ERC20: transfer from the zero address");
649         require(recipient != address(0), "ERC20: transfer to the zero address");
650 
651         _beforeTokenTransfer(sender, recipient, amount);
652 
653         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
654         _balances[recipient] = _balances[recipient].add(amount);
655         emit Transfer(sender, recipient, amount);
656     }
657 
658     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
659      * the total supply.
660      *
661      * Emits a {Transfer} event with `from` set to the zero address.
662      *
663      * Requirements:
664      *
665      * - `to` cannot be the zero address.
666      */
667     function _mint(address account, uint256 amount) internal virtual {
668         require(account != address(0), "ERC20: mint to the zero address");
669 
670         _beforeTokenTransfer(address(0), account, amount);
671 
672         _totalSupply = _totalSupply.add(amount);
673         _balances[account] = _balances[account].add(amount);
674         emit Transfer(address(0), account, amount);
675     }
676 
677     /**
678      * @dev Destroys `amount` tokens from `account`, reducing the
679      * total supply.
680      *
681      * Emits a {Transfer} event with `to` set to the zero address.
682      *
683      * Requirements:
684      *
685      * - `account` cannot be the zero address.
686      * - `account` must have at least `amount` tokens.
687      */
688     function _burn(address account, uint256 amount) internal virtual {
689         require(account != address(0), "ERC20: burn from the zero address");
690 
691         _beforeTokenTransfer(account, address(0), amount);
692 
693         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
694         _totalSupply = _totalSupply.sub(amount);
695         emit Transfer(account, address(0), amount);
696     }
697 
698     /**
699      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
700      *
701      * This internal function is equivalent to `approve`, and can be used to
702      * e.g. set automatic allowances for certain subsystems, etc.
703      *
704      * Emits an {Approval} event.
705      *
706      * Requirements:
707      *
708      * - `owner` cannot be the zero address.
709      * - `spender` cannot be the zero address.
710      */
711     function _approve(address owner, address spender, uint256 amount) internal virtual {
712         require(owner != address(0), "ERC20: approve from the zero address");
713         require(spender != address(0), "ERC20: approve to the zero address");
714 
715         _allowances[owner][spender] = amount;
716         emit Approval(owner, spender, amount);
717     }
718 
719     /**
720      * @dev Sets {decimals} to a value other than the default one of 18.
721      *
722      * WARNING: This function should only be called from the constructor. Most
723      * applications that interact with token contracts will not expect
724      * {decimals} to ever change, and may work incorrectly if it does.
725      */
726     function _setupDecimals(uint8 decimals_) internal {
727         _decimals = decimals_;
728     }
729 
730     /**
731      * @dev Hook that is called before any transfer of tokens. This includes
732      * minting and burning.
733      *
734      * Calling conditions:
735      *
736      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
737      * will be to transferred to `to`.
738      * - when `from` is zero, `amount` tokens will be minted for `to`.
739      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
740      * - `from` and `to` are never both zero.
741      *
742      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
743      */
744     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
745 }
746 
747 
748 // Dependency file: @openzeppelin/contracts/utils/SafeCast.sol
749 
750 
751 // pragma solidity >=0.6.0 <0.8.0;
752 
753 
754 /**
755  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
756  * checks.
757  *
758  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
759  * easily result in undesired exploitation or bugs, since developers usually
760  * assume that overflows raise errors. `SafeCast` restores this intuition by
761  * reverting the transaction when such an operation overflows.
762  *
763  * Using this library instead of the unchecked operations eliminates an entire
764  * class of bugs, so it's recommended to use it always.
765  *
766  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
767  * all math on `uint256` and `int256` and then downcasting.
768  */
769 library SafeCast {
770 
771     /**
772      * @dev Returns the downcasted uint128 from uint256, reverting on
773      * overflow (when the input is greater than largest uint128).
774      *
775      * Counterpart to Solidity's `uint128` operator.
776      *
777      * Requirements:
778      *
779      * - input must fit into 128 bits
780      */
781     function toUint128(uint256 value) internal pure returns (uint128) {
782         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
783         return uint128(value);
784     }
785 
786     /**
787      * @dev Returns the downcasted uint64 from uint256, reverting on
788      * overflow (when the input is greater than largest uint64).
789      *
790      * Counterpart to Solidity's `uint64` operator.
791      *
792      * Requirements:
793      *
794      * - input must fit into 64 bits
795      */
796     function toUint64(uint256 value) internal pure returns (uint64) {
797         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
798         return uint64(value);
799     }
800 
801     /**
802      * @dev Returns the downcasted uint32 from uint256, reverting on
803      * overflow (when the input is greater than largest uint32).
804      *
805      * Counterpart to Solidity's `uint32` operator.
806      *
807      * Requirements:
808      *
809      * - input must fit into 32 bits
810      */
811     function toUint32(uint256 value) internal pure returns (uint32) {
812         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
813         return uint32(value);
814     }
815 
816     /**
817      * @dev Returns the downcasted uint16 from uint256, reverting on
818      * overflow (when the input is greater than largest uint16).
819      *
820      * Counterpart to Solidity's `uint16` operator.
821      *
822      * Requirements:
823      *
824      * - input must fit into 16 bits
825      */
826     function toUint16(uint256 value) internal pure returns (uint16) {
827         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
828         return uint16(value);
829     }
830 
831     /**
832      * @dev Returns the downcasted uint8 from uint256, reverting on
833      * overflow (when the input is greater than largest uint8).
834      *
835      * Counterpart to Solidity's `uint8` operator.
836      *
837      * Requirements:
838      *
839      * - input must fit into 8 bits.
840      */
841     function toUint8(uint256 value) internal pure returns (uint8) {
842         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
843         return uint8(value);
844     }
845 
846     /**
847      * @dev Converts a signed int256 into an unsigned uint256.
848      *
849      * Requirements:
850      *
851      * - input must be greater than or equal to 0.
852      */
853     function toUint256(int256 value) internal pure returns (uint256) {
854         require(value >= 0, "SafeCast: value must be positive");
855         return uint256(value);
856     }
857 
858     /**
859      * @dev Returns the downcasted int128 from int256, reverting on
860      * overflow (when the input is less than smallest int128 or
861      * greater than largest int128).
862      *
863      * Counterpart to Solidity's `int128` operator.
864      *
865      * Requirements:
866      *
867      * - input must fit into 128 bits
868      *
869      * _Available since v3.1._
870      */
871     function toInt128(int256 value) internal pure returns (int128) {
872         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
873         return int128(value);
874     }
875 
876     /**
877      * @dev Returns the downcasted int64 from int256, reverting on
878      * overflow (when the input is less than smallest int64 or
879      * greater than largest int64).
880      *
881      * Counterpart to Solidity's `int64` operator.
882      *
883      * Requirements:
884      *
885      * - input must fit into 64 bits
886      *
887      * _Available since v3.1._
888      */
889     function toInt64(int256 value) internal pure returns (int64) {
890         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
891         return int64(value);
892     }
893 
894     /**
895      * @dev Returns the downcasted int32 from int256, reverting on
896      * overflow (when the input is less than smallest int32 or
897      * greater than largest int32).
898      *
899      * Counterpart to Solidity's `int32` operator.
900      *
901      * Requirements:
902      *
903      * - input must fit into 32 bits
904      *
905      * _Available since v3.1._
906      */
907     function toInt32(int256 value) internal pure returns (int32) {
908         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
909         return int32(value);
910     }
911 
912     /**
913      * @dev Returns the downcasted int16 from int256, reverting on
914      * overflow (when the input is less than smallest int16 or
915      * greater than largest int16).
916      *
917      * Counterpart to Solidity's `int16` operator.
918      *
919      * Requirements:
920      *
921      * - input must fit into 16 bits
922      *
923      * _Available since v3.1._
924      */
925     function toInt16(int256 value) internal pure returns (int16) {
926         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
927         return int16(value);
928     }
929 
930     /**
931      * @dev Returns the downcasted int8 from int256, reverting on
932      * overflow (when the input is less than smallest int8 or
933      * greater than largest int8).
934      *
935      * Counterpart to Solidity's `int8` operator.
936      *
937      * Requirements:
938      *
939      * - input must fit into 8 bits.
940      *
941      * _Available since v3.1._
942      */
943     function toInt8(int256 value) internal pure returns (int8) {
944         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
945         return int8(value);
946     }
947 
948     /**
949      * @dev Converts an unsigned uint256 into a signed int256.
950      *
951      * Requirements:
952      *
953      * - input must be less than or equal to maxInt256.
954      */
955     function toInt256(uint256 value) internal pure returns (int256) {
956         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
957         return int256(value);
958     }
959 }
960 
961 
962 // Dependency file: @openzeppelin/contracts/math/SignedSafeMath.sol
963 
964 
965 // pragma solidity >=0.6.0 <0.8.0;
966 
967 /**
968  * @title SignedSafeMath
969  * @dev Signed math operations with safety checks that revert on error.
970  */
971 library SignedSafeMath {
972     int256 constant private _INT256_MIN = -2**255;
973 
974     /**
975      * @dev Returns the multiplication of two signed integers, reverting on
976      * overflow.
977      *
978      * Counterpart to Solidity's `*` operator.
979      *
980      * Requirements:
981      *
982      * - Multiplication cannot overflow.
983      */
984     function mul(int256 a, int256 b) internal pure returns (int256) {
985         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
986         // benefit is lost if 'b' is also tested.
987         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
988         if (a == 0) {
989             return 0;
990         }
991 
992         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
993 
994         int256 c = a * b;
995         require(c / a == b, "SignedSafeMath: multiplication overflow");
996 
997         return c;
998     }
999 
1000     /**
1001      * @dev Returns the integer division of two signed integers. Reverts on
1002      * division by zero. The result is rounded towards zero.
1003      *
1004      * Counterpart to Solidity's `/` operator. Note: this function uses a
1005      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1006      * uses an invalid opcode to revert (consuming all remaining gas).
1007      *
1008      * Requirements:
1009      *
1010      * - The divisor cannot be zero.
1011      */
1012     function div(int256 a, int256 b) internal pure returns (int256) {
1013         require(b != 0, "SignedSafeMath: division by zero");
1014         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
1015 
1016         int256 c = a / b;
1017 
1018         return c;
1019     }
1020 
1021     /**
1022      * @dev Returns the subtraction of two signed integers, reverting on
1023      * overflow.
1024      *
1025      * Counterpart to Solidity's `-` operator.
1026      *
1027      * Requirements:
1028      *
1029      * - Subtraction cannot overflow.
1030      */
1031     function sub(int256 a, int256 b) internal pure returns (int256) {
1032         int256 c = a - b;
1033         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
1034 
1035         return c;
1036     }
1037 
1038     /**
1039      * @dev Returns the addition of two signed integers, reverting on
1040      * overflow.
1041      *
1042      * Counterpart to Solidity's `+` operator.
1043      *
1044      * Requirements:
1045      *
1046      * - Addition cannot overflow.
1047      */
1048     function add(int256 a, int256 b) internal pure returns (int256) {
1049         int256 c = a + b;
1050         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
1051 
1052         return c;
1053     }
1054 }
1055 
1056 
1057 // Dependency file: contracts/interfaces/IController.sol
1058 
1059 /*
1060     Copyright 2020 Set Labs Inc.
1061 
1062     Licensed under the Apache License, Version 2.0 (the "License");
1063     you may not use this file except in compliance with the License.
1064     You may obtain a copy of the License at
1065 
1066     http://www.apache.org/licenses/LICENSE-2.0
1067 
1068     Unless required by applicable law or agreed to in writing, software
1069     distributed under the License is distributed on an "AS IS" BASIS,
1070     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1071     See the License for the specific language governing permissions and
1072     limitations under the License.
1073 
1074 
1075 */
1076 // pragma solidity 0.6.10;
1077 
1078 interface IController {
1079     function addSet(address _setToken) external;
1080     function feeRecipient() external view returns(address);
1081     function getModuleFee(address _module, uint256 _feeType) external view returns(uint256);
1082     function isModule(address _module) external view returns(bool);
1083     function isSet(address _setToken) external view returns(bool);
1084     function isSystemContract(address _contractAddress) external view returns (bool);
1085     function resourceId(uint256 _id) external view returns(address);
1086 }
1087 
1088 // Dependency file: contracts/interfaces/IModule.sol
1089 
1090 /*
1091     Copyright 2020 Set Labs Inc.
1092 
1093     Licensed under the Apache License, Version 2.0 (the "License");
1094     you may not use this file except in compliance with the License.
1095     You may obtain a copy of the License at
1096 
1097     http://www.apache.org/licenses/LICENSE-2.0
1098 
1099     Unless required by applicable law or agreed to in writing, software
1100     distributed under the License is distributed on an "AS IS" BASIS,
1101     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1102     See the License for the specific language governing permissions and
1103     limitations under the License.
1104 
1105 
1106 */
1107 // pragma solidity 0.6.10;
1108 
1109 
1110 /**
1111  * @title IModule
1112  * @author Set Protocol
1113  *
1114  * Interface for interacting with Modules.
1115  */
1116 interface IModule {
1117     /**
1118      * Called by a SetToken to notify that this module was removed from the Set token. Any logic can be included
1119      * in case checks need to be made or state needs to be cleared.
1120      */
1121     function removeModule() external;
1122 }
1123 
1124 // Dependency file: contracts/interfaces/ISetToken.sol
1125 
1126 /*
1127     Copyright 2020 Set Labs Inc.
1128 
1129     Licensed under the Apache License, Version 2.0 (the "License");
1130     you may not use this file except in compliance with the License.
1131     You may obtain a copy of the License at
1132 
1133     http://www.apache.org/licenses/LICENSE-2.0
1134 
1135     Unless required by applicable law or agreed to in writing, software
1136     distributed under the License is distributed on an "AS IS" BASIS,
1137     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1138     See the License for the specific language governing permissions and
1139     limitations under the License.
1140 
1141 
1142 */
1143 // pragma solidity 0.6.10;
1144 
1145 
1146 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1147 
1148 /**
1149  * @title ISetToken
1150  * @author Set Protocol
1151  *
1152  * Interface for operating with SetTokens.
1153  */
1154 interface ISetToken is IERC20 {
1155 
1156     /* ============ Enums ============ */
1157 
1158     enum ModuleState {
1159         NONE,
1160         PENDING,
1161         INITIALIZED
1162     }
1163 
1164     /* ============ Structs ============ */
1165     /**
1166      * The base definition of a SetToken Position
1167      *
1168      * @param component           Address of token in the Position
1169      * @param module              If not in default state, the address of associated module
1170      * @param unit                Each unit is the # of components per 10^18 of a SetToken
1171      * @param positionState       Position ENUM. Default is 0; External is 1
1172      * @param data                Arbitrary data
1173      */
1174     struct Position {
1175         address component;
1176         address module;
1177         int256 unit;
1178         uint8 positionState;
1179         bytes data;
1180     }
1181 
1182     /**
1183      * A struct that stores a component's cash position details and external positions
1184      * This data structure allows O(1) access to a component's cash position units and 
1185      * virtual units.
1186      *
1187      * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
1188      *                                  updating all units at once via the position multiplier. Virtual units are achieved
1189      *                                  by dividing a "real" value by the "positionMultiplier"
1190      * @param componentIndex            
1191      * @param externalPositionModules   List of external modules attached to each external position. Each module
1192      *                                  maps to an external position
1193      * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
1194      */
1195     struct ComponentPosition {
1196       int256 virtualUnit;
1197       address[] externalPositionModules;
1198       mapping(address => ExternalPosition) externalPositions;
1199     }
1200 
1201     /**
1202      * A struct that stores a component's external position details including virtual unit and any
1203      * auxiliary data.
1204      *
1205      * @param virtualUnit       Virtual value of a component's EXTERNAL position.
1206      * @param data              Arbitrary data
1207      */
1208     struct ExternalPosition {
1209       int256 virtualUnit;
1210       bytes data;
1211     }
1212 
1213 
1214     /* ============ Functions ============ */
1215     
1216     function addComponent(address _component) external;
1217     function removeComponent(address _component) external;
1218     function editDefaultPositionUnit(address _component, int256 _realUnit) external;
1219     function addExternalPositionModule(address _component, address _positionModule) external;
1220     function removeExternalPositionModule(address _component, address _positionModule) external;
1221     function editExternalPositionUnit(address _component, address _positionModule, int256 _realUnit) external;
1222     function editExternalPositionData(address _component, address _positionModule, bytes calldata _data) external;
1223 
1224     function invoke(address _target, uint256 _value, bytes calldata _data) external returns(bytes memory);
1225 
1226     function editPositionMultiplier(int256 _newMultiplier) external;
1227 
1228     function mint(address _account, uint256 _quantity) external;
1229     function burn(address _account, uint256 _quantity) external;
1230 
1231     function lock() external;
1232     function unlock() external;
1233 
1234     function addModule(address _module) external;
1235     function removeModule(address _module) external;
1236     function initializeModule() external;
1237 
1238     function setManager(address _manager) external;
1239 
1240     function manager() external view returns (address);
1241     function moduleStates(address _module) external view returns (ModuleState);
1242     function getModules() external view returns (address[] memory);
1243     
1244     function getDefaultPositionRealUnit(address _component) external view returns(int256);
1245     function getExternalPositionRealUnit(address _component, address _positionModule) external view returns(int256);
1246     function getComponents() external view returns(address[] memory);
1247     function getExternalPositionModules(address _component) external view returns(address[] memory);
1248     function getExternalPositionData(address _component, address _positionModule) external view returns(bytes memory);
1249     function isExternalPositionModule(address _component, address _module) external view returns(bool);
1250     function isComponent(address _component) external view returns(bool);
1251     
1252     function positionMultiplier() external view returns (int256);
1253     function getPositions() external view returns (Position[] memory);
1254     function getTotalComponentRealUnits(address _component) external view returns(int256);
1255 
1256     function isInitializedModule(address _module) external view returns(bool);
1257     function isPendingModule(address _module) external view returns(bool);
1258     function isLocked() external view returns (bool);
1259 }
1260 
1261 // Dependency file: contracts/lib/PreciseUnitMath.sol
1262 
1263 /*
1264     Copyright 2020 Set Labs Inc.
1265 
1266     Licensed under the Apache License, Version 2.0 (the "License");
1267     you may not use this file except in compliance with the License.
1268     You may obtain a copy of the License at
1269 
1270     http://www.apache.org/licenses/LICENSE-2.0
1271 
1272     Unless required by applicable law or agreed to in writing, software
1273     distributed under the License is distributed on an "AS IS" BASIS,
1274     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1275     See the License for the specific language governing permissions and
1276     limitations under the License.
1277 
1278 
1279 */
1280 
1281 // pragma solidity 0.6.10;
1282 pragma experimental ABIEncoderV2;
1283 
1284 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1285 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
1286 
1287 
1288 /**
1289  * @title PreciseUnitMath
1290  * @author Set Protocol
1291  *
1292  * Arithmetic for fixed-point numbers with 18 decimals of precision. Some functions taken from
1293  * dYdX's BaseMath library.
1294  *
1295  * CHANGELOG:
1296  * - 9/21/20: Added safePower function
1297  */
1298 library PreciseUnitMath {
1299     using SafeMath for uint256;
1300     using SignedSafeMath for int256;
1301 
1302     // The number One in precise units.
1303     uint256 constant internal PRECISE_UNIT = 10 ** 18;
1304     int256 constant internal PRECISE_UNIT_INT = 10 ** 18;
1305 
1306     // Max unsigned integer value
1307     uint256 constant internal MAX_UINT_256 = type(uint256).max;
1308     // Max and min signed integer value
1309     int256 constant internal MAX_INT_256 = type(int256).max;
1310     int256 constant internal MIN_INT_256 = type(int256).min;
1311 
1312     /**
1313      * @dev Getter function since constants can't be read directly from libraries.
1314      */
1315     function preciseUnit() internal pure returns (uint256) {
1316         return PRECISE_UNIT;
1317     }
1318 
1319     /**
1320      * @dev Getter function since constants can't be read directly from libraries.
1321      */
1322     function preciseUnitInt() internal pure returns (int256) {
1323         return PRECISE_UNIT_INT;
1324     }
1325 
1326     /**
1327      * @dev Getter function since constants can't be read directly from libraries.
1328      */
1329     function maxUint256() internal pure returns (uint256) {
1330         return MAX_UINT_256;
1331     }
1332 
1333     /**
1334      * @dev Getter function since constants can't be read directly from libraries.
1335      */
1336     function maxInt256() internal pure returns (int256) {
1337         return MAX_INT_256;
1338     }
1339 
1340     /**
1341      * @dev Getter function since constants can't be read directly from libraries.
1342      */
1343     function minInt256() internal pure returns (int256) {
1344         return MIN_INT_256;
1345     }
1346 
1347     /**
1348      * @dev Multiplies value a by value b (result is rounded down). It's assumed that the value b is the significand
1349      * of a number with 18 decimals precision.
1350      */
1351     function preciseMul(uint256 a, uint256 b) internal pure returns (uint256) {
1352         return a.mul(b).div(PRECISE_UNIT);
1353     }
1354 
1355     /**
1356      * @dev Multiplies value a by value b (result is rounded towards zero). It's assumed that the value b is the
1357      * significand of a number with 18 decimals precision.
1358      */
1359     function preciseMul(int256 a, int256 b) internal pure returns (int256) {
1360         return a.mul(b).div(PRECISE_UNIT_INT);
1361     }
1362 
1363     /**
1364      * @dev Multiplies value a by value b (result is rounded up). It's assumed that the value b is the significand
1365      * of a number with 18 decimals precision.
1366      */
1367     function preciseMulCeil(uint256 a, uint256 b) internal pure returns (uint256) {
1368         if (a == 0 || b == 0) {
1369             return 0;
1370         }
1371         return a.mul(b).sub(1).div(PRECISE_UNIT).add(1);
1372     }
1373 
1374     /**
1375      * @dev Divides value a by value b (result is rounded down).
1376      */
1377     function preciseDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1378         return a.mul(PRECISE_UNIT).div(b);
1379     }
1380 
1381 
1382     /**
1383      * @dev Divides value a by value b (result is rounded towards 0).
1384      */
1385     function preciseDiv(int256 a, int256 b) internal pure returns (int256) {
1386         return a.mul(PRECISE_UNIT_INT).div(b);
1387     }
1388 
1389     /**
1390      * @dev Divides value a by value b (result is rounded up or away from 0).
1391      */
1392     function preciseDivCeil(uint256 a, uint256 b) internal pure returns (uint256) {
1393         require(b != 0, "Cant divide by 0");
1394 
1395         return a > 0 ? a.mul(PRECISE_UNIT).sub(1).div(b).add(1) : 0;
1396     }
1397 
1398     /**
1399      * @dev Divides value a by value b (result is rounded down - positive numbers toward 0 and negative away from 0).
1400      */
1401     function divDown(int256 a, int256 b) internal pure returns (int256) {
1402         require(b != 0, "Cant divide by 0");
1403         require(a != MIN_INT_256 || b != -1, "Invalid input");
1404 
1405         int256 result = a.div(b);
1406         if (a ^ b < 0 && a % b != 0) {
1407             result -= 1;
1408         }
1409 
1410         return result;
1411     }
1412 
1413     /**
1414      * @dev Multiplies value a by value b where rounding is towards the lesser number. 
1415      * (positive values are rounded towards zero and negative values are rounded away from 0). 
1416      */
1417     function conservativePreciseMul(int256 a, int256 b) internal pure returns (int256) {
1418         return divDown(a.mul(b), PRECISE_UNIT_INT);
1419     }
1420 
1421     /**
1422      * @dev Divides value a by value b where rounding is towards the lesser number. 
1423      * (positive values are rounded towards zero and negative values are rounded away from 0). 
1424      */
1425     function conservativePreciseDiv(int256 a, int256 b) internal pure returns (int256) {
1426         return divDown(a.mul(PRECISE_UNIT_INT), b);
1427     }
1428 
1429     /**
1430     * @dev Performs the power on a specified value, reverts on overflow.
1431     */
1432     function safePower(
1433         uint256 a,
1434         uint256 pow
1435     )
1436         internal
1437         pure
1438         returns (uint256)
1439     {
1440         require(a > 0, "Value must be positive");
1441 
1442         uint256 result = 1;
1443         for (uint256 i = 0; i < pow; i++){
1444             uint256 previousResult = result;
1445 
1446             // Using safemath multiplication prevents overflows
1447             result = previousResult.mul(a);
1448         }
1449 
1450         return result;
1451     }
1452 }
1453 
1454 // Dependency file: contracts/protocol/lib/Position.sol
1455 
1456 /*
1457     Copyright 2020 Set Labs Inc.
1458 
1459     Licensed under the Apache License, Version 2.0 (the "License");
1460     you may not use this file except in compliance with the License.
1461     You may obtain a copy of the License at
1462 
1463     http://www.apache.org/licenses/LICENSE-2.0
1464 
1465     Unless required by applicable law or agreed to in writing, software
1466     distributed under the License is distributed on an "AS IS" BASIS,
1467     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1468     See the License for the specific language governing permissions and
1469     limitations under the License.
1470 
1471 
1472 */
1473 
1474 // pragma solidity 0.6.10;
1475 
1476 
1477 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1478 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
1479 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1480 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
1481 
1482 // import { ISetToken } from "contracts/interfaces/ISetToken.sol";
1483 // import { PreciseUnitMath } from "contracts/lib/PreciseUnitMath.sol";
1484 
1485 
1486 /**
1487  * @title Position
1488  * @author Set Protocol
1489  *
1490  * Collection of helper functions for handling and updating SetToken Positions
1491  *
1492  * CHANGELOG:
1493  *  - Updated editExternalPosition to work when no external position is associated with module
1494  */
1495 library Position {
1496     using SafeCast for uint256;
1497     using SafeMath for uint256;
1498     using SafeCast for int256;
1499     using SignedSafeMath for int256;
1500     using PreciseUnitMath for uint256;
1501 
1502     /* ============ Helper ============ */
1503 
1504     /**
1505      * Returns whether the SetToken has a default position for a given component (if the real unit is > 0)
1506      */
1507     function hasDefaultPosition(ISetToken _setToken, address _component) internal view returns(bool) {
1508         return _setToken.getDefaultPositionRealUnit(_component) > 0;
1509     }
1510 
1511     /**
1512      * Returns whether the SetToken has an external position for a given component (if # of position modules is > 0)
1513      */
1514     function hasExternalPosition(ISetToken _setToken, address _component) internal view returns(bool) {
1515         return _setToken.getExternalPositionModules(_component).length > 0;
1516     }
1517     
1518     /**
1519      * Returns whether the SetToken component default position real unit is greater than or equal to units passed in.
1520      */
1521     function hasSufficientDefaultUnits(ISetToken _setToken, address _component, uint256 _unit) internal view returns(bool) {
1522         return _setToken.getDefaultPositionRealUnit(_component) >= _unit.toInt256();
1523     }
1524 
1525     /**
1526      * Returns whether the SetToken component external position is greater than or equal to the real units passed in.
1527      */
1528     function hasSufficientExternalUnits(
1529         ISetToken _setToken,
1530         address _component,
1531         address _positionModule,
1532         uint256 _unit
1533     )
1534         internal
1535         view
1536         returns(bool)
1537     {
1538        return _setToken.getExternalPositionRealUnit(_component, _positionModule) >= _unit.toInt256();    
1539     }
1540 
1541     /**
1542      * If the position does not exist, create a new Position and add to the SetToken. If it already exists,
1543      * then set the position units. If the new units is 0, remove the position. Handles adding/removing of 
1544      * components where needed (in light of potential external positions).
1545      *
1546      * @param _setToken           Address of SetToken being modified
1547      * @param _component          Address of the component
1548      * @param _newUnit            Quantity of Position units - must be >= 0
1549      */
1550     function editDefaultPosition(ISetToken _setToken, address _component, uint256 _newUnit) internal {
1551         bool isPositionFound = hasDefaultPosition(_setToken, _component);
1552         if (!isPositionFound && _newUnit > 0) {
1553             // If there is no Default Position and no External Modules, then component does not exist
1554             if (!hasExternalPosition(_setToken, _component)) {
1555                 _setToken.addComponent(_component);
1556             }
1557         } else if (isPositionFound && _newUnit == 0) {
1558             // If there is a Default Position and no external positions, remove the component
1559             if (!hasExternalPosition(_setToken, _component)) {
1560                 _setToken.removeComponent(_component);
1561             }
1562         }
1563 
1564         _setToken.editDefaultPositionUnit(_component, _newUnit.toInt256());
1565     }
1566 
1567     /**
1568      * Update an external position and remove and external positions or components if necessary. The logic flows as follows:
1569      * 1) If component is not already added then add component and external position. 
1570      * 2) If component is added but no existing external position using the passed module exists then add the external position.
1571      * 3) If the existing position is being added to then just update the unit and data
1572      * 4) If the position is being closed and no other external positions or default positions are associated with the component
1573      *    then untrack the component and remove external position.
1574      * 5) If the position is being closed and other existing positions still exist for the component then just remove the
1575      *    external position.
1576      *
1577      * @param _setToken         SetToken being updated
1578      * @param _component        Component position being updated
1579      * @param _module           Module external position is associated with
1580      * @param _newUnit          Position units of new external position
1581      * @param _data             Arbitrary data associated with the position
1582      */
1583     function editExternalPosition(
1584         ISetToken _setToken,
1585         address _component,
1586         address _module,
1587         int256 _newUnit,
1588         bytes memory _data
1589     )
1590         internal
1591     {
1592         if (_newUnit != 0) {
1593             if (!_setToken.isComponent(_component)) {
1594                 _setToken.addComponent(_component);
1595                 _setToken.addExternalPositionModule(_component, _module);
1596             } else if (!_setToken.isExternalPositionModule(_component, _module)) {
1597                 _setToken.addExternalPositionModule(_component, _module);
1598             }
1599             _setToken.editExternalPositionUnit(_component, _module, _newUnit);
1600             _setToken.editExternalPositionData(_component, _module, _data);
1601         } else {
1602             require(_data.length == 0, "Passed data must be null");
1603             // If no default or external position remaining then remove component from components array
1604             if (_setToken.getExternalPositionRealUnit(_component, _module) != 0) {
1605                 address[] memory positionModules = _setToken.getExternalPositionModules(_component);
1606                 if (_setToken.getDefaultPositionRealUnit(_component) == 0 && positionModules.length == 1) {
1607                     require(positionModules[0] == _module, "External positions must be 0 to remove component");
1608                     _setToken.removeComponent(_component);
1609                 }
1610                 _setToken.removeExternalPositionModule(_component, _module);
1611             }
1612         }
1613     }
1614 
1615     /**
1616      * Get total notional amount of Default position
1617      *
1618      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
1619      * @param _positionUnit       Quantity of Position units
1620      *
1621      * @return                    Total notional amount of units
1622      */
1623     function getDefaultTotalNotional(uint256 _setTokenSupply, uint256 _positionUnit) internal pure returns (uint256) {
1624         return _setTokenSupply.preciseMul(_positionUnit);
1625     }
1626 
1627     /**
1628      * Get position unit from total notional amount
1629      *
1630      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
1631      * @param _totalNotional      Total notional amount of component prior to
1632      * @return                    Default position unit
1633      */
1634     function getDefaultPositionUnit(uint256 _setTokenSupply, uint256 _totalNotional) internal pure returns (uint256) {
1635         return _totalNotional.preciseDiv(_setTokenSupply);
1636     }
1637 
1638     /**
1639      * Get the total tracked balance - total supply * position unit
1640      *
1641      * @param _setToken           Address of the SetToken
1642      * @param _component          Address of the component
1643      * @return                    Notional tracked balance
1644      */
1645     function getDefaultTrackedBalance(ISetToken _setToken, address _component) internal view returns(uint256) {
1646         int256 positionUnit = _setToken.getDefaultPositionRealUnit(_component); 
1647         return _setToken.totalSupply().preciseMul(positionUnit.toUint256());
1648     }
1649 
1650     /**
1651      * Calculates the new default position unit and performs the edit with the new unit
1652      *
1653      * @param _setToken                 Address of the SetToken
1654      * @param _component                Address of the component
1655      * @param _setTotalSupply           Current SetToken supply
1656      * @param _componentPreviousBalance Pre-action component balance
1657      * @return                          Current component balance
1658      * @return                          Previous position unit
1659      * @return                          New position unit
1660      */
1661     function calculateAndEditDefaultPosition(
1662         ISetToken _setToken,
1663         address _component,
1664         uint256 _setTotalSupply,
1665         uint256 _componentPreviousBalance
1666     )
1667         internal
1668         returns(uint256, uint256, uint256)
1669     {
1670         uint256 currentBalance = IERC20(_component).balanceOf(address(_setToken));
1671         uint256 positionUnit = _setToken.getDefaultPositionRealUnit(_component).toUint256();
1672 
1673         uint256 newTokenUnit;
1674         if (currentBalance > 0) {
1675             newTokenUnit = calculateDefaultEditPositionUnit(
1676                 _setTotalSupply,
1677                 _componentPreviousBalance,
1678                 currentBalance,
1679                 positionUnit
1680             );
1681         } else {
1682             newTokenUnit = 0;
1683         }
1684 
1685         editDefaultPosition(_setToken, _component, newTokenUnit);
1686 
1687         return (currentBalance, positionUnit, newTokenUnit);
1688     }
1689 
1690     /**
1691      * Calculate the new position unit given total notional values pre and post executing an action that changes SetToken state
1692      * The intention is to make updates to the units without accidentally picking up airdropped assets as well.
1693      *
1694      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
1695      * @param _preTotalNotional   Total notional amount of component prior to executing action
1696      * @param _postTotalNotional  Total notional amount of component after the executing action
1697      * @param _prePositionUnit    Position unit of SetToken prior to executing action
1698      * @return                    New position unit
1699      */
1700     function calculateDefaultEditPositionUnit(
1701         uint256 _setTokenSupply,
1702         uint256 _preTotalNotional,
1703         uint256 _postTotalNotional,
1704         uint256 _prePositionUnit
1705     )
1706         internal
1707         pure
1708         returns (uint256)
1709     {
1710         // If pre action total notional amount is greater then subtract post action total notional and calculate new position units
1711         uint256 airdroppedAmount = _preTotalNotional.sub(_prePositionUnit.preciseMul(_setTokenSupply));
1712         return _postTotalNotional.sub(airdroppedAmount).preciseDiv(_setTokenSupply);
1713     }
1714 }
1715 
1716 
1717 // Dependency file: contracts/lib/AddressArrayUtils.sol
1718 
1719 /*
1720     Copyright 2020 Set Labs Inc.
1721 
1722     Licensed under the Apache License, Version 2.0 (the "License");
1723     you may not use this file except in compliance with the License.
1724     You may obtain a copy of the License at
1725 
1726     http://www.apache.org/licenses/LICENSE-2.0
1727 
1728     Unless required by applicable law or agreed to in writing, software
1729     distributed under the License is distributed on an "AS IS" BASIS,
1730     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1731     See the License for the specific language governing permissions and
1732     limitations under the License.
1733 
1734 
1735 */
1736 
1737 // pragma solidity 0.6.10;
1738 
1739 /**
1740  * @title AddressArrayUtils
1741  * @author Set Protocol
1742  *
1743  * Utility functions to handle Address Arrays
1744  */
1745 library AddressArrayUtils {
1746 
1747     /**
1748      * Finds the index of the first occurrence of the given element.
1749      * @param A The input array to search
1750      * @param a The value to find
1751      * @return Returns (index and isIn) for the first occurrence starting from index 0
1752      */
1753     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
1754         uint256 length = A.length;
1755         for (uint256 i = 0; i < length; i++) {
1756             if (A[i] == a) {
1757                 return (i, true);
1758             }
1759         }
1760         return (uint256(-1), false);
1761     }
1762 
1763     /**
1764     * Returns true if the value is present in the list. Uses indexOf internally.
1765     * @param A The input array to search
1766     * @param a The value to find
1767     * @return Returns isIn for the first occurrence starting from index 0
1768     */
1769     function contains(address[] memory A, address a) internal pure returns (bool) {
1770         (, bool isIn) = indexOf(A, a);
1771         return isIn;
1772     }
1773 
1774     /**
1775     * Returns true if there are 2 elements that are the same in an array
1776     * @param A The input array to search
1777     * @return Returns boolean for the first occurrence of a duplicate
1778     */
1779     function hasDuplicate(address[] memory A) internal pure returns(bool) {
1780         require(A.length > 0, "A is empty");
1781 
1782         for (uint256 i = 0; i < A.length - 1; i++) {
1783             address current = A[i];
1784             for (uint256 j = i + 1; j < A.length; j++) {
1785                 if (current == A[j]) {
1786                     return true;
1787                 }
1788             }
1789         }
1790         return false;
1791     }
1792 
1793     /**
1794      * @param A The input array to search
1795      * @param a The address to remove     
1796      * @return Returns the array with the object removed.
1797      */
1798     function remove(address[] memory A, address a)
1799         internal
1800         pure
1801         returns (address[] memory)
1802     {
1803         (uint256 index, bool isIn) = indexOf(A, a);
1804         if (!isIn) {
1805             revert("Address not in array.");
1806         } else {
1807             (address[] memory _A,) = pop(A, index);
1808             return _A;
1809         }
1810     }
1811 
1812     /**
1813      * @param A The input array to search
1814      * @param a The address to remove
1815      */
1816     function removeStorage(address[] storage A, address a)
1817         internal
1818     {
1819         (uint256 index, bool isIn) = indexOf(A, a);
1820         if (!isIn) {
1821             revert("Address not in array.");
1822         } else {
1823             uint256 lastIndex = A.length - 1; // If the array would be empty, the previous line would throw, so no underflow here
1824             if (index != lastIndex) { A[index] = A[lastIndex]; }
1825             A.pop();
1826         }
1827     }
1828 
1829     /**
1830     * Removes specified index from array
1831     * @param A The input array to search
1832     * @param index The index to remove
1833     * @return Returns the new array and the removed entry
1834     */
1835     function pop(address[] memory A, uint256 index)
1836         internal
1837         pure
1838         returns (address[] memory, address)
1839     {
1840         uint256 length = A.length;
1841         require(index < A.length, "Index must be < A length");
1842         address[] memory newAddresses = new address[](length - 1);
1843         for (uint256 i = 0; i < index; i++) {
1844             newAddresses[i] = A[i];
1845         }
1846         for (uint256 j = index + 1; j < length; j++) {
1847             newAddresses[j - 1] = A[j];
1848         }
1849         return (newAddresses, A[index]);
1850     }
1851 
1852     /**
1853      * Returns the combination of the two arrays
1854      * @param A The first array
1855      * @param B The second array
1856      * @return Returns A extended by B
1857      */
1858     function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1859         uint256 aLength = A.length;
1860         uint256 bLength = B.length;
1861         address[] memory newAddresses = new address[](aLength + bLength);
1862         for (uint256 i = 0; i < aLength; i++) {
1863             newAddresses[i] = A[i];
1864         }
1865         for (uint256 j = 0; j < bLength; j++) {
1866             newAddresses[aLength + j] = B[j];
1867         }
1868         return newAddresses;
1869     }
1870 }
1871 
1872 // Root file: contracts/protocol/SetToken.sol
1873 
1874 /*
1875     Copyright 2020 Set Labs Inc.
1876 
1877     Licensed under the Apache License, Version 2.0 (the "License");
1878     you may not use this file except in compliance with the License.
1879     You may obtain a copy of the License at
1880 
1881     http://www.apache.org/licenses/LICENSE-2.0
1882 
1883     Unless required by applicable law or agreed to in writing, software
1884     distributed under the License is distributed on an "AS IS" BASIS,
1885     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1886     See the License for the specific language governing permissions and
1887     limitations under the License.
1888 
1889 
1890 */
1891 
1892 pragma solidity 0.6.10;
1893 
1894 
1895 // import { Address } from "@openzeppelin/contracts/utils/Address.sol";
1896 // import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
1897 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
1898 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1899 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
1900 
1901 // import { IController } from "contracts/interfaces/IController.sol";
1902 // import { IModule } from "contracts/interfaces/IModule.sol";
1903 // import { ISetToken } from "contracts/interfaces/ISetToken.sol";
1904 // import { Position } from "contracts/protocol/lib/Position.sol";
1905 // import { PreciseUnitMath } from "contracts/lib/PreciseUnitMath.sol";
1906 // import { AddressArrayUtils } from "contracts/lib/AddressArrayUtils.sol";
1907 
1908 
1909 /**
1910  * @title SetToken
1911  * @author Set Protocol
1912  *
1913  * ERC20 Token contract that allows privileged modules to make modifications to its positions and invoke function calls
1914  * from the SetToken. 
1915  */
1916 contract SetToken is ERC20 {
1917     using SafeMath for uint256;
1918     using SafeCast for int256;
1919     using SafeCast for uint256;
1920     using SignedSafeMath for int256;
1921     using PreciseUnitMath for int256;
1922     using Address for address;
1923     using AddressArrayUtils for address[];
1924 
1925     /* ============ Constants ============ */
1926 
1927     /*
1928         The PositionState is the status of the Position, whether it is Default (held on the SetToken)
1929         or otherwise held on a separate smart contract (whether a module or external source).
1930         There are issues with cross-usage of enums, so we are defining position states
1931         as a uint8.
1932     */
1933     uint8 internal constant DEFAULT = 0;
1934     uint8 internal constant EXTERNAL = 1;
1935 
1936     /* ============ Events ============ */
1937 
1938     event Invoked(address indexed _target, uint indexed _value, bytes _data, bytes _returnValue);
1939     event ModuleAdded(address indexed _module);
1940     event ModuleRemoved(address indexed _module);    
1941     event ModuleInitialized(address indexed _module);
1942     event ManagerEdited(address _newManager, address _oldManager);
1943     event PendingModuleRemoved(address indexed _module);
1944     event PositionMultiplierEdited(int256 _newMultiplier);
1945     event ComponentAdded(address indexed _component);
1946     event ComponentRemoved(address indexed _component);
1947     event DefaultPositionUnitEdited(address indexed _component, int256 _realUnit);
1948     event ExternalPositionUnitEdited(address indexed _component, address indexed _positionModule, int256 _realUnit);
1949     event ExternalPositionDataEdited(address indexed _component, address indexed _positionModule, bytes _data);
1950     event PositionModuleAdded(address indexed _component, address indexed _positionModule);
1951     event PositionModuleRemoved(address indexed _component, address indexed _positionModule);
1952 
1953     /* ============ Modifiers ============ */
1954 
1955     /**
1956      * Throws if the sender is not a SetToken's module or module not enabled
1957      */
1958     modifier onlyModule() {
1959         // Internal function used to reduce bytecode size
1960         _validateOnlyModule();
1961         _;
1962     }
1963 
1964     /**
1965      * Throws if the sender is not the SetToken's manager
1966      */
1967     modifier onlyManager() {
1968         _validateOnlyManager();
1969         _;
1970     }
1971 
1972     /**
1973      * Throws if SetToken is locked and called by any account other than the locker.
1974      */
1975     modifier whenLockedOnlyLocker() {
1976         _validateWhenLockedOnlyLocker();
1977         _;
1978     }
1979 
1980     /* ============ State Variables ============ */
1981 
1982     // Address of the controller
1983     IController public controller;
1984 
1985     // The manager has the privelege to add modules, remove, and set a new manager
1986     address public manager;
1987 
1988     // A module that has locked other modules from privileged functionality, typically required
1989     // for multi-block module actions such as auctions
1990     address public locker;
1991 
1992     // List of initialized Modules; Modules extend the functionality of SetTokens
1993     address[] public modules;
1994 
1995     // Modules are initialized from NONE -> PENDING -> INITIALIZED through the
1996     // addModule (called by manager) and initialize  (called by module) functions
1997     mapping(address => ISetToken.ModuleState) public moduleStates;
1998 
1999     // When locked, only the locker (a module) can call privileged functionality
2000     // Typically utilized if a module (e.g. Auction) needs multiple transactions to complete an action
2001     // without interruption
2002     bool public isLocked;
2003 
2004     // List of components
2005     address[] public components;
2006 
2007     // Mapping that stores all Default and External position information for a given component.
2008     // Position quantities are represented as virtual units; Default positions are on the top-level,
2009     // while external positions are stored in a module array and accessed through its externalPositions mapping
2010     mapping(address => ISetToken.ComponentPosition) private componentPositions;
2011 
2012     // The multiplier applied to the virtual position unit to achieve the real/actual unit.
2013     // This multiplier is used for efficiently modifying the entire position units (e.g. streaming fee)
2014     int256 public positionMultiplier;
2015 
2016     /* ============ Constructor ============ */
2017 
2018     /**
2019      * When a new SetToken is created, initializes Positions in default state and adds modules into pending state.
2020      * All parameter validations are on the SetTokenCreator contract. Validations are performed already on the 
2021      * SetTokenCreator. Initiates the positionMultiplier as 1e18 (no adjustments).
2022      *
2023      * @param _components             List of addresses of components for initial Positions
2024      * @param _units                  List of units. Each unit is the # of components per 10^18 of a SetToken
2025      * @param _modules                List of modules to enable. All modules must be approved by the Controller
2026      * @param _controller             Address of the controller
2027      * @param _manager                Address of the manager
2028      * @param _name                   Name of the SetToken
2029      * @param _symbol                 Symbol of the SetToken
2030      */
2031     constructor(
2032         address[] memory _components,
2033         int256[] memory _units,
2034         address[] memory _modules,
2035         IController _controller,
2036         address _manager,
2037         string memory _name,
2038         string memory _symbol
2039     )
2040         public
2041         ERC20(_name, _symbol)
2042     {
2043         controller = _controller;
2044         manager = _manager;
2045         positionMultiplier = PreciseUnitMath.preciseUnitInt();
2046         components = _components;
2047 
2048         // Modules are put in PENDING state, as they need to be individually initialized by the Module
2049         for (uint256 i = 0; i < _modules.length; i++) {
2050             moduleStates[_modules[i]] = ISetToken.ModuleState.PENDING;
2051         }
2052 
2053         // Positions are put in default state initially
2054         for (uint256 j = 0; j < _components.length; j++) {
2055             componentPositions[_components[j]].virtualUnit = _units[j];
2056         }
2057     }
2058 
2059     /* ============ External Functions ============ */
2060 
2061     /**
2062      * PRIVELEGED MODULE FUNCTION. Low level function that allows a module to make an arbitrary function
2063      * call to any contract.
2064      *
2065      * @param _target                 Address of the smart contract to call
2066      * @param _value                  Quantity of Ether to provide the call (typically 0)
2067      * @param _data                   Encoded function selector and arguments
2068      * @return _returnValue           Bytes encoded return value
2069      */
2070     function invoke(
2071         address _target,
2072         uint256 _value,
2073         bytes calldata _data
2074     )
2075         external
2076         onlyModule
2077         whenLockedOnlyLocker
2078         returns (bytes memory _returnValue)
2079     {
2080         _returnValue = _target.functionCallWithValue(_data, _value);
2081 
2082         emit Invoked(_target, _value, _data, _returnValue);
2083 
2084         return _returnValue;
2085     }
2086 
2087     /**
2088      * PRIVELEGED MODULE FUNCTION. Low level function that adds a component to the components array.
2089      */
2090     function addComponent(address _component) external onlyModule whenLockedOnlyLocker {
2091         require(!isComponent(_component), "Must not be component");
2092         
2093         components.push(_component);
2094 
2095         emit ComponentAdded(_component);
2096     }
2097 
2098     /**
2099      * PRIVELEGED MODULE FUNCTION. Low level function that removes a component from the components array.
2100      */
2101     function removeComponent(address _component) external onlyModule whenLockedOnlyLocker {
2102         components.removeStorage(_component);
2103 
2104         emit ComponentRemoved(_component);
2105     }
2106 
2107     /**
2108      * PRIVELEGED MODULE FUNCTION. Low level function that edits a component's virtual unit. Takes a real unit
2109      * and converts it to virtual before committing.
2110      */
2111     function editDefaultPositionUnit(address _component, int256 _realUnit) external onlyModule whenLockedOnlyLocker {
2112         int256 virtualUnit = _convertRealToVirtualUnit(_realUnit);
2113 
2114         componentPositions[_component].virtualUnit = virtualUnit;
2115 
2116         emit DefaultPositionUnitEdited(_component, _realUnit);
2117     }
2118 
2119     /**
2120      * PRIVELEGED MODULE FUNCTION. Low level function that adds a module to a component's externalPositionModules array
2121      */
2122     function addExternalPositionModule(address _component, address _positionModule) external onlyModule whenLockedOnlyLocker {
2123         require(!isExternalPositionModule(_component, _positionModule), "Module already added");
2124 
2125         componentPositions[_component].externalPositionModules.push(_positionModule);
2126 
2127         emit PositionModuleAdded(_component, _positionModule);
2128     }
2129 
2130     /**
2131      * PRIVELEGED MODULE FUNCTION. Low level function that removes a module from a component's 
2132      * externalPositionModules array and deletes the associated externalPosition.
2133      */
2134     function removeExternalPositionModule(
2135         address _component,
2136         address _positionModule
2137     )
2138         external
2139         onlyModule
2140         whenLockedOnlyLocker
2141     {
2142         componentPositions[_component].externalPositionModules.removeStorage(_positionModule);
2143 
2144         delete componentPositions[_component].externalPositions[_positionModule];
2145 
2146         emit PositionModuleRemoved(_component, _positionModule);
2147     }
2148 
2149     /**
2150      * PRIVELEGED MODULE FUNCTION. Low level function that edits a component's external position virtual unit. 
2151      * Takes a real unit and converts it to virtual before committing.
2152      */
2153     function editExternalPositionUnit(
2154         address _component,
2155         address _positionModule,
2156         int256 _realUnit
2157     )
2158         external
2159         onlyModule
2160         whenLockedOnlyLocker
2161     {
2162         int256 virtualUnit = _convertRealToVirtualUnit(_realUnit);
2163 
2164         componentPositions[_component].externalPositions[_positionModule].virtualUnit = virtualUnit;
2165 
2166         emit ExternalPositionUnitEdited(_component, _positionModule, _realUnit);
2167     }
2168 
2169     /**
2170      * PRIVELEGED MODULE FUNCTION. Low level function that edits a component's external position data
2171      */
2172     function editExternalPositionData(
2173         address _component,
2174         address _positionModule,
2175         bytes calldata _data
2176     )
2177         external
2178         onlyModule
2179         whenLockedOnlyLocker
2180     {
2181         componentPositions[_component].externalPositions[_positionModule].data = _data;
2182 
2183         emit ExternalPositionDataEdited(_component, _positionModule, _data);
2184     }
2185 
2186     /**
2187      * PRIVELEGED MODULE FUNCTION. Modifies the position multiplier. This is typically used to efficiently
2188      * update all the Positions' units at once in applications where inflation is awarded (e.g. subscription fees).
2189      */
2190     function editPositionMultiplier(int256 _newMultiplier) external onlyModule whenLockedOnlyLocker {        
2191         _validateNewMultiplier(_newMultiplier);
2192 
2193         positionMultiplier = _newMultiplier;
2194 
2195         emit PositionMultiplierEdited(_newMultiplier);
2196     }
2197 
2198     /**
2199      * PRIVELEGED MODULE FUNCTION. Increases the "account" balance by the "quantity".
2200      */
2201     function mint(address _account, uint256 _quantity) external onlyModule whenLockedOnlyLocker {
2202         _mint(_account, _quantity);
2203     }
2204 
2205     /**
2206      * PRIVELEGED MODULE FUNCTION. Decreases the "account" balance by the "quantity".
2207      * _burn checks that the "account" already has the required "quantity".
2208      */
2209     function burn(address _account, uint256 _quantity) external onlyModule whenLockedOnlyLocker {
2210         _burn(_account, _quantity);
2211     }
2212 
2213     /**
2214      * PRIVELEGED MODULE FUNCTION. When a SetToken is locked, only the locker can call privileged functions.
2215      */
2216     function lock() external onlyModule {
2217         require(!isLocked, "Must not be locked");
2218         locker = msg.sender;
2219         isLocked = true;
2220     }
2221 
2222     /**
2223      * PRIVELEGED MODULE FUNCTION. Unlocks the SetToken and clears the locker
2224      */
2225     function unlock() external onlyModule {
2226         require(isLocked, "Must be locked");
2227         require(locker == msg.sender, "Must be locker");
2228         delete locker;
2229         isLocked = false;
2230     }
2231 
2232     /**
2233      * MANAGER ONLY. Adds a module into a PENDING state; Module must later be initialized via 
2234      * module's initialize function
2235      */
2236     function addModule(address _module) external onlyManager {
2237         require(moduleStates[_module] == ISetToken.ModuleState.NONE, "Module must not be added");
2238         require(controller.isModule(_module), "Must be enabled on Controller");
2239 
2240         moduleStates[_module] = ISetToken.ModuleState.PENDING;
2241 
2242         emit ModuleAdded(_module);
2243     }
2244 
2245     /**
2246      * MANAGER ONLY. Removes a module from the SetToken. SetToken calls removeModule on module itself to confirm
2247      * it is not needed to manage any remaining positions and to remove state.
2248      */
2249     function removeModule(address _module) external onlyManager {
2250         require(!isLocked, "Only when unlocked");
2251         require(moduleStates[_module] == ISetToken.ModuleState.INITIALIZED, "Module must be added");
2252 
2253         IModule(_module).removeModule();
2254 
2255         moduleStates[_module] = ISetToken.ModuleState.NONE;
2256 
2257         modules.removeStorage(_module);
2258 
2259         emit ModuleRemoved(_module);
2260     }
2261 
2262     /**
2263      * MANAGER ONLY. Removes a pending module from the SetToken.
2264      */
2265     function removePendingModule(address _module) external onlyManager {
2266         require(!isLocked, "Only when unlocked");
2267         require(moduleStates[_module] == ISetToken.ModuleState.PENDING, "Module must be pending");
2268 
2269         moduleStates[_module] = ISetToken.ModuleState.NONE;
2270 
2271         emit PendingModuleRemoved(_module);
2272     }
2273 
2274     /**
2275      * Initializes an added module from PENDING to INITIALIZED state. Can only call when unlocked.
2276      * An address can only enter a PENDING state if it is an enabled module added by the manager.
2277      * Only callable by the module itself, hence msg.sender is the subject of update.
2278      */
2279     function initializeModule() external {
2280         require(!isLocked, "Only when unlocked");
2281         require(moduleStates[msg.sender] == ISetToken.ModuleState.PENDING, "Module must be pending");
2282         
2283         moduleStates[msg.sender] = ISetToken.ModuleState.INITIALIZED;
2284         modules.push(msg.sender);
2285 
2286         emit ModuleInitialized(msg.sender);
2287     }
2288 
2289     /**
2290      * MANAGER ONLY. Changes manager; We allow null addresses in case the manager wishes to wind down the SetToken.
2291      * Modules may rely on the manager state, so only changable when unlocked
2292      */
2293     function setManager(address _manager) external onlyManager {
2294         require(!isLocked, "Only when unlocked");
2295         address oldManager = manager;
2296         manager = _manager;
2297 
2298         emit ManagerEdited(_manager, oldManager);
2299     }
2300 
2301     /* ============ External Getter Functions ============ */
2302 
2303     function getComponents() external view returns(address[] memory) {
2304         return components;
2305     }
2306 
2307     function getDefaultPositionRealUnit(address _component) public view returns(int256) {
2308         return _convertVirtualToRealUnit(_defaultPositionVirtualUnit(_component));
2309     }
2310 
2311     function getExternalPositionRealUnit(address _component, address _positionModule) public view returns(int256) {
2312         return _convertVirtualToRealUnit(_externalPositionVirtualUnit(_component, _positionModule));
2313     }
2314 
2315     function getExternalPositionModules(address _component) external view returns(address[] memory) {
2316         return _externalPositionModules(_component);
2317     }
2318 
2319     function getExternalPositionData(address _component,address _positionModule) external view returns(bytes memory) {
2320         return _externalPositionData(_component, _positionModule);
2321     }
2322 
2323     function getModules() external view returns (address[] memory) {
2324         return modules;
2325     }
2326 
2327     function isComponent(address _component) public view returns(bool) {
2328         return components.contains(_component);
2329     }
2330 
2331     function isExternalPositionModule(address _component, address _module) public view returns(bool) {
2332         return _externalPositionModules(_component).contains(_module);
2333     }
2334 
2335     /**
2336      * Only ModuleStates of INITIALIZED modules are considered enabled
2337      */
2338     function isInitializedModule(address _module) external view returns (bool) {
2339         return moduleStates[_module] == ISetToken.ModuleState.INITIALIZED;
2340     }
2341 
2342     /**
2343      * Returns whether the module is in a pending state
2344      */
2345     function isPendingModule(address _module) external view returns (bool) {
2346         return moduleStates[_module] == ISetToken.ModuleState.PENDING;
2347     }
2348 
2349     /**
2350      * Returns a list of Positions, through traversing the components. Each component with a non-zero virtual unit
2351      * is considered a Default Position, and each externalPositionModule will generate a unique position.
2352      * Virtual units are converted to real units. This function is typically used off-chain for data presentation purposes.
2353      */
2354     function getPositions() external view returns (ISetToken.Position[] memory) {
2355         ISetToken.Position[] memory positions = new ISetToken.Position[](_getPositionCount());
2356         uint256 positionCount = 0;
2357 
2358         for (uint256 i = 0; i < components.length; i++) {
2359             address component = components[i];
2360 
2361             // A default position exists if the default virtual unit is > 0
2362             if (_defaultPositionVirtualUnit(component) > 0) {
2363                 positions[positionCount] = ISetToken.Position({
2364                     component: component,
2365                     module: address(0),
2366                     unit: getDefaultPositionRealUnit(component),
2367                     positionState: DEFAULT,
2368                     data: ""
2369                 });
2370 
2371                 positionCount++;
2372             }
2373 
2374             address[] memory externalModules = _externalPositionModules(component);
2375             for (uint256 j = 0; j < externalModules.length; j++) {
2376                 address currentModule = externalModules[j];
2377 
2378                 positions[positionCount] = ISetToken.Position({
2379                     component: component,
2380                     module: currentModule,
2381                     unit: getExternalPositionRealUnit(component, currentModule),
2382                     positionState: EXTERNAL,
2383                     data: _externalPositionData(component, currentModule)
2384                 });
2385 
2386                 positionCount++;
2387             }
2388         }
2389 
2390         return positions;
2391     }
2392 
2393     /**
2394      * Returns the total Real Units for a given component, summing the default and external position units.
2395      */
2396     function getTotalComponentRealUnits(address _component) external view returns(int256) {
2397         int256 totalUnits = getDefaultPositionRealUnit(_component);
2398 
2399         address[] memory externalModules = _externalPositionModules(_component);
2400         for (uint256 i = 0; i < externalModules.length; i++) {
2401             // We will perform the summation no matter what, as an external position virtual unit can be negative
2402             totalUnits = totalUnits.add(getExternalPositionRealUnit(_component, externalModules[i]));
2403         }
2404 
2405         return totalUnits;
2406     }
2407 
2408 
2409     receive() external payable {} // solium-disable-line quotes
2410 
2411     /* ============ Internal Functions ============ */
2412 
2413     function _defaultPositionVirtualUnit(address _component) internal view returns(int256) {
2414         return componentPositions[_component].virtualUnit;
2415     }
2416 
2417     function _externalPositionModules(address _component) internal view returns(address[] memory) {
2418         return componentPositions[_component].externalPositionModules;
2419     }
2420 
2421     function _externalPositionVirtualUnit(address _component, address _module) internal view returns(int256) {
2422         return componentPositions[_component].externalPositions[_module].virtualUnit;
2423     }
2424 
2425     function _externalPositionData(address _component, address _module) internal view returns(bytes memory) {
2426         return componentPositions[_component].externalPositions[_module].data;
2427     }
2428 
2429     /**
2430      * Takes a real unit and divides by the position multiplier to return the virtual unit
2431      */
2432     function _convertRealToVirtualUnit(int256 _realUnit) internal view returns(int256) {
2433         int256 virtualUnit = _realUnit.conservativePreciseDiv(positionMultiplier);
2434 
2435         // These checks ensure that the virtual unit does not return a result that has rounded down to 0
2436         if (_realUnit > 0 && virtualUnit == 0) {
2437             revert("Virtual unit conversion invalid");
2438         }
2439 
2440         return virtualUnit;
2441     }
2442 
2443     /**
2444      * Takes a virtual unit and multiplies by the position multiplier to return the real unit
2445      */
2446     function _convertVirtualToRealUnit(int256 _virtualUnit) internal view returns(int256) {
2447         return _virtualUnit.conservativePreciseMul(positionMultiplier);
2448     }
2449 
2450     /**
2451      * To prevent virtual to real unit conversion issues (where real unit may be 0), the 
2452      * product of the positionMultiplier and the lowest absolute virtualUnit value (across default and
2453      * external positions) must be greater than 0.
2454      */
2455     function _validateNewMultiplier(int256 _newMultiplier) internal view {
2456         int256 minVirtualUnit = _getPositionsAbsMinimumVirtualUnit();
2457 
2458         require(minVirtualUnit.conservativePreciseMul(_newMultiplier) > 0, "New multiplier too small");
2459     }
2460 
2461     /**
2462      * Loops through all of the positions and returns the smallest absolute value of 
2463      * the virtualUnit.
2464      *
2465      * @return Min virtual unit across positions denominated as int256
2466      */
2467     function _getPositionsAbsMinimumVirtualUnit() internal view returns(int256) {
2468         // Additional assignment happens in the loop below
2469         uint256 minimumUnit = uint256(-1);
2470 
2471         for (uint256 i = 0; i < components.length; i++) {
2472             address component = components[i];
2473 
2474             // A default position exists if the default virtual unit is > 0
2475             uint256 defaultUnit = _defaultPositionVirtualUnit(component).toUint256();
2476             if (defaultUnit > 0 && defaultUnit < minimumUnit) {
2477                 minimumUnit = defaultUnit;
2478             }
2479 
2480             address[] memory externalModules = _externalPositionModules(component);
2481             for (uint256 j = 0; j < externalModules.length; j++) {
2482                 address currentModule = externalModules[j];
2483 
2484                 uint256 virtualUnit = _absoluteValue(
2485                     _externalPositionVirtualUnit(component, currentModule)
2486                 );
2487                 if (virtualUnit > 0 && virtualUnit < minimumUnit) {
2488                     minimumUnit = virtualUnit;
2489                 }
2490             }
2491         }
2492 
2493         return minimumUnit.toInt256();        
2494     }
2495 
2496     /**
2497      * Gets the total number of positions, defined as the following:
2498      * - Each component has a default position if its virtual unit is > 0
2499      * - Each component's external positions module is counted as a position
2500      */
2501     function _getPositionCount() internal view returns (uint256) {
2502         uint256 positionCount;
2503         for (uint256 i = 0; i < components.length; i++) {
2504             address component = components[i];
2505 
2506             // Increment the position count if the default position is > 0
2507             if (_defaultPositionVirtualUnit(component) > 0) {
2508                 positionCount++;
2509             }
2510 
2511             // Increment the position count by each external position module
2512             address[] memory externalModules = _externalPositionModules(component);
2513             if (externalModules.length > 0) {
2514                 positionCount = positionCount.add(externalModules.length);  
2515             }
2516         }
2517 
2518         return positionCount;
2519     }
2520 
2521     /**
2522      * Returns the absolute value of the signed integer value
2523      * @param _a Signed interger value
2524      * @return Returns the absolute value in uint256
2525      */
2526     function _absoluteValue(int256 _a) internal pure returns(uint256) {
2527         return _a >= 0 ? _a.toUint256() : (-_a).toUint256();
2528     }
2529 
2530     /**
2531      * Due to reason error bloat, internal functions are used to reduce bytecode size
2532      *
2533      * Module must be initialized on the SetToken and enabled by the controller
2534      */
2535     function _validateOnlyModule() internal view {
2536         require(
2537             moduleStates[msg.sender] == ISetToken.ModuleState.INITIALIZED,
2538             "Only the module can call"
2539         );
2540 
2541         require(
2542             controller.isModule(msg.sender),
2543             "Module must be enabled on controller"
2544         );
2545     }
2546 
2547     function _validateOnlyManager() internal view {
2548         require(msg.sender == manager, "Only manager can call");
2549     }
2550 
2551     function _validateWhenLockedOnlyLocker() internal view {
2552         if (isLocked) {
2553             require(msg.sender == locker, "When locked, only the locker can call");
2554         }
2555     }
2556 }