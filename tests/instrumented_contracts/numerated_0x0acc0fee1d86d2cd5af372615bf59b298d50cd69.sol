1 // Sources flattened with hardhat v2.2.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v3.3.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.2 <0.8.0;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
152         if (success) {
153             return returndata;
154         } else {
155             // Look for revert reason and bubble it up if present
156             if (returndata.length > 0) {
157                 // The easiest way to bubble the revert reason is using memory via assembly
158 
159                 // solhint-disable-next-line no-inline-assembly
160                 assembly {
161                     let returndata_size := mload(returndata)
162                     revert(add(32, returndata), returndata_size)
163                 }
164             } else {
165                 revert(errorMessage);
166             }
167         }
168     }
169 }
170 
171 
172 // File @openzeppelin/contracts/GSN/Context.sol@v3.3.0
173 
174 pragma solidity >=0.6.0 <0.8.0;
175 
176 /*
177  * @dev Provides information about the current execution context, including the
178  * sender of the transaction and its data. While these are generally available
179  * via msg.sender and msg.data, they should not be accessed in such a direct
180  * manner, since when dealing with GSN meta-transactions the account sending and
181  * paying for execution may not be the actual sender (as far as an application
182  * is concerned).
183  *
184  * This contract is only required for intermediate, library-like contracts.
185  */
186 abstract contract Context {
187     function _msgSender() internal view virtual returns (address payable) {
188         return msg.sender;
189     }
190 
191     function _msgData() internal view virtual returns (bytes memory) {
192         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
193         return msg.data;
194     }
195 }
196 
197 
198 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
199 
200 pragma solidity >=0.6.0 <0.8.0;
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
239      * IMPORTANT: Beware that changing an allowance with this method brings the risk
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
277 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
278 
279 pragma solidity >=0.6.0 <0.8.0;
280 
281 /**
282  * @dev Wrappers over Solidity's arithmetic operations with added overflow
283  * checks.
284  *
285  * Arithmetic operations in Solidity wrap on overflow. This can easily result
286  * in bugs, because programmers usually assume that an overflow raises an
287  * error, which is the standard behavior in high level programming languages.
288  * `SafeMath` restores this intuition by reverting the transaction when an
289  * operation overflows.
290  *
291  * Using this library instead of the unchecked operations eliminates an entire
292  * class of bugs, so it's recommended to use it always.
293  */
294 library SafeMath {
295     /**
296      * @dev Returns the addition of two unsigned integers, reverting on
297      * overflow.
298      *
299      * Counterpart to Solidity's `+` operator.
300      *
301      * Requirements:
302      *
303      * - Addition cannot overflow.
304      */
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         uint256 c = a + b;
307         require(c >= a, "SafeMath: addition overflow");
308 
309         return c;
310     }
311 
312     /**
313      * @dev Returns the subtraction of two unsigned integers, reverting on
314      * overflow (when the result is negative).
315      *
316      * Counterpart to Solidity's `-` operator.
317      *
318      * Requirements:
319      *
320      * - Subtraction cannot overflow.
321      */
322     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
323         return sub(a, b, "SafeMath: subtraction overflow");
324     }
325 
326     /**
327      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
328      * overflow (when the result is negative).
329      *
330      * Counterpart to Solidity's `-` operator.
331      *
332      * Requirements:
333      *
334      * - Subtraction cannot overflow.
335      */
336     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         require(b <= a, errorMessage);
338         uint256 c = a - b;
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the multiplication of two unsigned integers, reverting on
345      * overflow.
346      *
347      * Counterpart to Solidity's `*` operator.
348      *
349      * Requirements:
350      *
351      * - Multiplication cannot overflow.
352      */
353     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
354         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
355         // benefit is lost if 'b' is also tested.
356         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
357         if (a == 0) {
358             return 0;
359         }
360 
361         uint256 c = a * b;
362         require(c / a == b, "SafeMath: multiplication overflow");
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the integer division of two unsigned integers. Reverts on
369      * division by zero. The result is rounded towards zero.
370      *
371      * Counterpart to Solidity's `/` operator. Note: this function uses a
372      * `revert` opcode (which leaves remaining gas untouched) while Solidity
373      * uses an invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function div(uint256 a, uint256 b) internal pure returns (uint256) {
380         return div(a, b, "SafeMath: division by zero");
381     }
382 
383     /**
384      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
385      * division by zero. The result is rounded towards zero.
386      *
387      * Counterpart to Solidity's `/` operator. Note: this function uses a
388      * `revert` opcode (which leaves remaining gas untouched) while Solidity
389      * uses an invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
396         require(b > 0, errorMessage);
397         uint256 c = a / b;
398         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
399 
400         return c;
401     }
402 
403     /**
404      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
405      * Reverts when dividing by zero.
406      *
407      * Counterpart to Solidity's `%` operator. This function uses a `revert`
408      * opcode (which leaves remaining gas untouched) while Solidity uses an
409      * invalid opcode to revert (consuming all remaining gas).
410      *
411      * Requirements:
412      *
413      * - The divisor cannot be zero.
414      */
415     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
416         return mod(a, b, "SafeMath: modulo by zero");
417     }
418 
419     /**
420      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
421      * Reverts with custom message when dividing by zero.
422      *
423      * Counterpart to Solidity's `%` operator. This function uses a `revert`
424      * opcode (which leaves remaining gas untouched) while Solidity uses an
425      * invalid opcode to revert (consuming all remaining gas).
426      *
427      * Requirements:
428      *
429      * - The divisor cannot be zero.
430      */
431     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
432         require(b != 0, errorMessage);
433         return a % b;
434     }
435 }
436 
437 
438 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.3.0
439 
440 pragma solidity >=0.6.0 <0.8.0;
441 
442 
443 
444 /**
445  * @dev Implementation of the {IERC20} interface.
446  *
447  * This implementation is agnostic to the way tokens are created. This means
448  * that a supply mechanism has to be added in a derived contract using {_mint}.
449  * For a generic mechanism see {ERC20PresetMinterPauser}.
450  *
451  * TIP: For a detailed writeup see our guide
452  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
453  * to implement supply mechanisms].
454  *
455  * We have followed general OpenZeppelin guidelines: functions revert instead
456  * of returning `false` on failure. This behavior is nonetheless conventional
457  * and does not conflict with the expectations of ERC20 applications.
458  *
459  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
460  * This allows applications to reconstruct the allowance for all accounts just
461  * by listening to said events. Other implementations of the EIP may not emit
462  * these events, as it isn't required by the specification.
463  *
464  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
465  * functions have been added to mitigate the well-known issues around setting
466  * allowances. See {IERC20-approve}.
467  */
468 contract ERC20 is Context, IERC20 {
469     using SafeMath for uint256;
470 
471     mapping (address => uint256) private _balances;
472 
473     mapping (address => mapping (address => uint256)) private _allowances;
474 
475     uint256 private _totalSupply;
476 
477     string private _name;
478     string private _symbol;
479     uint8 private _decimals;
480 
481     /**
482      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
483      * a default value of 18.
484      *
485      * To select a different value for {decimals}, use {_setupDecimals}.
486      *
487      * All three of these values are immutable: they can only be set once during
488      * construction.
489      */
490     constructor (string memory name_, string memory symbol_) public {
491         _name = name_;
492         _symbol = symbol_;
493         _decimals = 18;
494     }
495 
496     /**
497      * @dev Returns the name of the token.
498      */
499     function name() public view returns (string memory) {
500         return _name;
501     }
502 
503     /**
504      * @dev Returns the symbol of the token, usually a shorter version of the
505      * name.
506      */
507     function symbol() public view returns (string memory) {
508         return _symbol;
509     }
510 
511     /**
512      * @dev Returns the number of decimals used to get its user representation.
513      * For example, if `decimals` equals `2`, a balance of `505` tokens should
514      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
515      *
516      * Tokens usually opt for a value of 18, imitating the relationship between
517      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
518      * called.
519      *
520      * NOTE: This information is only used for _display_ purposes: it in
521      * no way affects any of the arithmetic of the contract, including
522      * {IERC20-balanceOf} and {IERC20-transfer}.
523      */
524     function decimals() public view returns (uint8) {
525         return _decimals;
526     }
527 
528     /**
529      * @dev See {IERC20-totalSupply}.
530      */
531     function totalSupply() public view override returns (uint256) {
532         return _totalSupply;
533     }
534 
535     /**
536      * @dev See {IERC20-balanceOf}.
537      */
538     function balanceOf(address account) public view override returns (uint256) {
539         return _balances[account];
540     }
541 
542     /**
543      * @dev See {IERC20-transfer}.
544      *
545      * Requirements:
546      *
547      * - `recipient` cannot be the zero address.
548      * - the caller must have a balance of at least `amount`.
549      */
550     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
551         _transfer(_msgSender(), recipient, amount);
552         return true;
553     }
554 
555     /**
556      * @dev See {IERC20-allowance}.
557      */
558     function allowance(address owner, address spender) public view virtual override returns (uint256) {
559         return _allowances[owner][spender];
560     }
561 
562     /**
563      * @dev See {IERC20-approve}.
564      *
565      * Requirements:
566      *
567      * - `spender` cannot be the zero address.
568      */
569     function approve(address spender, uint256 amount) public virtual override returns (bool) {
570         _approve(_msgSender(), spender, amount);
571         return true;
572     }
573 
574     /**
575      * @dev See {IERC20-transferFrom}.
576      *
577      * Emits an {Approval} event indicating the updated allowance. This is not
578      * required by the EIP. See the note at the beginning of {ERC20}.
579      *
580      * Requirements:
581      *
582      * - `sender` and `recipient` cannot be the zero address.
583      * - `sender` must have a balance of at least `amount`.
584      * - the caller must have allowance for ``sender``'s tokens of at least
585      * `amount`.
586      */
587     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
588         _transfer(sender, recipient, amount);
589         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
590         return true;
591     }
592 
593     /**
594      * @dev Atomically increases the allowance granted to `spender` by the caller.
595      *
596      * This is an alternative to {approve} that can be used as a mitigation for
597      * problems described in {IERC20-approve}.
598      *
599      * Emits an {Approval} event indicating the updated allowance.
600      *
601      * Requirements:
602      *
603      * - `spender` cannot be the zero address.
604      */
605     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
606         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
607         return true;
608     }
609 
610     /**
611      * @dev Atomically decreases the allowance granted to `spender` by the caller.
612      *
613      * This is an alternative to {approve} that can be used as a mitigation for
614      * problems described in {IERC20-approve}.
615      *
616      * Emits an {Approval} event indicating the updated allowance.
617      *
618      * Requirements:
619      *
620      * - `spender` cannot be the zero address.
621      * - `spender` must have allowance for the caller of at least
622      * `subtractedValue`.
623      */
624     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
625         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
626         return true;
627     }
628 
629     /**
630      * @dev Moves tokens `amount` from `sender` to `recipient`.
631      *
632      * This is internal function is equivalent to {transfer}, and can be used to
633      * e.g. implement automatic token fees, slashing mechanisms, etc.
634      *
635      * Emits a {Transfer} event.
636      *
637      * Requirements:
638      *
639      * - `sender` cannot be the zero address.
640      * - `recipient` cannot be the zero address.
641      * - `sender` must have a balance of at least `amount`.
642      */
643     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
644         require(sender != address(0), "ERC20: transfer from the zero address");
645         require(recipient != address(0), "ERC20: transfer to the zero address");
646 
647         _beforeTokenTransfer(sender, recipient, amount);
648 
649         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
650         _balances[recipient] = _balances[recipient].add(amount);
651         emit Transfer(sender, recipient, amount);
652     }
653 
654     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
655      * the total supply.
656      *
657      * Emits a {Transfer} event with `from` set to the zero address.
658      *
659      * Requirements:
660      *
661      * - `to` cannot be the zero address.
662      */
663     function _mint(address account, uint256 amount) internal virtual {
664         require(account != address(0), "ERC20: mint to the zero address");
665 
666         _beforeTokenTransfer(address(0), account, amount);
667 
668         _totalSupply = _totalSupply.add(amount);
669         _balances[account] = _balances[account].add(amount);
670         emit Transfer(address(0), account, amount);
671     }
672 
673     /**
674      * @dev Destroys `amount` tokens from `account`, reducing the
675      * total supply.
676      *
677      * Emits a {Transfer} event with `to` set to the zero address.
678      *
679      * Requirements:
680      *
681      * - `account` cannot be the zero address.
682      * - `account` must have at least `amount` tokens.
683      */
684     function _burn(address account, uint256 amount) internal virtual {
685         require(account != address(0), "ERC20: burn from the zero address");
686 
687         _beforeTokenTransfer(account, address(0), amount);
688 
689         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
690         _totalSupply = _totalSupply.sub(amount);
691         emit Transfer(account, address(0), amount);
692     }
693 
694     /**
695      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
696      *
697      * This internal function is equivalent to `approve`, and can be used to
698      * e.g. set automatic allowances for certain subsystems, etc.
699      *
700      * Emits an {Approval} event.
701      *
702      * Requirements:
703      *
704      * - `owner` cannot be the zero address.
705      * - `spender` cannot be the zero address.
706      */
707     function _approve(address owner, address spender, uint256 amount) internal virtual {
708         require(owner != address(0), "ERC20: approve from the zero address");
709         require(spender != address(0), "ERC20: approve to the zero address");
710 
711         _allowances[owner][spender] = amount;
712         emit Approval(owner, spender, amount);
713     }
714 
715     /**
716      * @dev Sets {decimals} to a value other than the default one of 18.
717      *
718      * WARNING: This function should only be called from the constructor. Most
719      * applications that interact with token contracts will not expect
720      * {decimals} to ever change, and may work incorrectly if it does.
721      */
722     function _setupDecimals(uint8 decimals_) internal {
723         _decimals = decimals_;
724     }
725 
726     /**
727      * @dev Hook that is called before any transfer of tokens. This includes
728      * minting and burning.
729      *
730      * Calling conditions:
731      *
732      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
733      * will be to transferred to `to`.
734      * - when `from` is zero, `amount` tokens will be minted for `to`.
735      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
736      * - `from` and `to` are never both zero.
737      *
738      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
739      */
740     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
741 }
742 
743 
744 // File @openzeppelin/contracts/utils/SafeCast.sol@v3.3.0
745 
746 pragma solidity >=0.6.0 <0.8.0;
747 
748 
749 /**
750  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
751  * checks.
752  *
753  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
754  * easily result in undesired exploitation or bugs, since developers usually
755  * assume that overflows raise errors. `SafeCast` restores this intuition by
756  * reverting the transaction when such an operation overflows.
757  *
758  * Using this library instead of the unchecked operations eliminates an entire
759  * class of bugs, so it's recommended to use it always.
760  *
761  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
762  * all math on `uint256` and `int256` and then downcasting.
763  */
764 library SafeCast {
765 
766     /**
767      * @dev Returns the downcasted uint128 from uint256, reverting on
768      * overflow (when the input is greater than largest uint128).
769      *
770      * Counterpart to Solidity's `uint128` operator.
771      *
772      * Requirements:
773      *
774      * - input must fit into 128 bits
775      */
776     function toUint128(uint256 value) internal pure returns (uint128) {
777         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
778         return uint128(value);
779     }
780 
781     /**
782      * @dev Returns the downcasted uint64 from uint256, reverting on
783      * overflow (when the input is greater than largest uint64).
784      *
785      * Counterpart to Solidity's `uint64` operator.
786      *
787      * Requirements:
788      *
789      * - input must fit into 64 bits
790      */
791     function toUint64(uint256 value) internal pure returns (uint64) {
792         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
793         return uint64(value);
794     }
795 
796     /**
797      * @dev Returns the downcasted uint32 from uint256, reverting on
798      * overflow (when the input is greater than largest uint32).
799      *
800      * Counterpart to Solidity's `uint32` operator.
801      *
802      * Requirements:
803      *
804      * - input must fit into 32 bits
805      */
806     function toUint32(uint256 value) internal pure returns (uint32) {
807         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
808         return uint32(value);
809     }
810 
811     /**
812      * @dev Returns the downcasted uint16 from uint256, reverting on
813      * overflow (when the input is greater than largest uint16).
814      *
815      * Counterpart to Solidity's `uint16` operator.
816      *
817      * Requirements:
818      *
819      * - input must fit into 16 bits
820      */
821     function toUint16(uint256 value) internal pure returns (uint16) {
822         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
823         return uint16(value);
824     }
825 
826     /**
827      * @dev Returns the downcasted uint8 from uint256, reverting on
828      * overflow (when the input is greater than largest uint8).
829      *
830      * Counterpart to Solidity's `uint8` operator.
831      *
832      * Requirements:
833      *
834      * - input must fit into 8 bits.
835      */
836     function toUint8(uint256 value) internal pure returns (uint8) {
837         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
838         return uint8(value);
839     }
840 
841     /**
842      * @dev Converts a signed int256 into an unsigned uint256.
843      *
844      * Requirements:
845      *
846      * - input must be greater than or equal to 0.
847      */
848     function toUint256(int256 value) internal pure returns (uint256) {
849         require(value >= 0, "SafeCast: value must be positive");
850         return uint256(value);
851     }
852 
853     /**
854      * @dev Returns the downcasted int128 from int256, reverting on
855      * overflow (when the input is less than smallest int128 or
856      * greater than largest int128).
857      *
858      * Counterpart to Solidity's `int128` operator.
859      *
860      * Requirements:
861      *
862      * - input must fit into 128 bits
863      *
864      * _Available since v3.1._
865      */
866     function toInt128(int256 value) internal pure returns (int128) {
867         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
868         return int128(value);
869     }
870 
871     /**
872      * @dev Returns the downcasted int64 from int256, reverting on
873      * overflow (when the input is less than smallest int64 or
874      * greater than largest int64).
875      *
876      * Counterpart to Solidity's `int64` operator.
877      *
878      * Requirements:
879      *
880      * - input must fit into 64 bits
881      *
882      * _Available since v3.1._
883      */
884     function toInt64(int256 value) internal pure returns (int64) {
885         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
886         return int64(value);
887     }
888 
889     /**
890      * @dev Returns the downcasted int32 from int256, reverting on
891      * overflow (when the input is less than smallest int32 or
892      * greater than largest int32).
893      *
894      * Counterpart to Solidity's `int32` operator.
895      *
896      * Requirements:
897      *
898      * - input must fit into 32 bits
899      *
900      * _Available since v3.1._
901      */
902     function toInt32(int256 value) internal pure returns (int32) {
903         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
904         return int32(value);
905     }
906 
907     /**
908      * @dev Returns the downcasted int16 from int256, reverting on
909      * overflow (when the input is less than smallest int16 or
910      * greater than largest int16).
911      *
912      * Counterpart to Solidity's `int16` operator.
913      *
914      * Requirements:
915      *
916      * - input must fit into 16 bits
917      *
918      * _Available since v3.1._
919      */
920     function toInt16(int256 value) internal pure returns (int16) {
921         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
922         return int16(value);
923     }
924 
925     /**
926      * @dev Returns the downcasted int8 from int256, reverting on
927      * overflow (when the input is less than smallest int8 or
928      * greater than largest int8).
929      *
930      * Counterpart to Solidity's `int8` operator.
931      *
932      * Requirements:
933      *
934      * - input must fit into 8 bits.
935      *
936      * _Available since v3.1._
937      */
938     function toInt8(int256 value) internal pure returns (int8) {
939         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
940         return int8(value);
941     }
942 
943     /**
944      * @dev Converts an unsigned uint256 into a signed int256.
945      *
946      * Requirements:
947      *
948      * - input must be less than or equal to maxInt256.
949      */
950     function toInt256(uint256 value) internal pure returns (int256) {
951         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
952         return int256(value);
953     }
954 }
955 
956 
957 // File @openzeppelin/contracts/math/SignedSafeMath.sol@v3.3.0
958 
959 pragma solidity >=0.6.0 <0.8.0;
960 
961 /**
962  * @title SignedSafeMath
963  * @dev Signed math operations with safety checks that revert on error.
964  */
965 library SignedSafeMath {
966     int256 constant private _INT256_MIN = -2**255;
967 
968     /**
969      * @dev Returns the multiplication of two signed integers, reverting on
970      * overflow.
971      *
972      * Counterpart to Solidity's `*` operator.
973      *
974      * Requirements:
975      *
976      * - Multiplication cannot overflow.
977      */
978     function mul(int256 a, int256 b) internal pure returns (int256) {
979         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
980         // benefit is lost if 'b' is also tested.
981         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
982         if (a == 0) {
983             return 0;
984         }
985 
986         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
987 
988         int256 c = a * b;
989         require(c / a == b, "SignedSafeMath: multiplication overflow");
990 
991         return c;
992     }
993 
994     /**
995      * @dev Returns the integer division of two signed integers. Reverts on
996      * division by zero. The result is rounded towards zero.
997      *
998      * Counterpart to Solidity's `/` operator. Note: this function uses a
999      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1000      * uses an invalid opcode to revert (consuming all remaining gas).
1001      *
1002      * Requirements:
1003      *
1004      * - The divisor cannot be zero.
1005      */
1006     function div(int256 a, int256 b) internal pure returns (int256) {
1007         require(b != 0, "SignedSafeMath: division by zero");
1008         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
1009 
1010         int256 c = a / b;
1011 
1012         return c;
1013     }
1014 
1015     /**
1016      * @dev Returns the subtraction of two signed integers, reverting on
1017      * overflow.
1018      *
1019      * Counterpart to Solidity's `-` operator.
1020      *
1021      * Requirements:
1022      *
1023      * - Subtraction cannot overflow.
1024      */
1025     function sub(int256 a, int256 b) internal pure returns (int256) {
1026         int256 c = a - b;
1027         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
1028 
1029         return c;
1030     }
1031 
1032     /**
1033      * @dev Returns the addition of two signed integers, reverting on
1034      * overflow.
1035      *
1036      * Counterpart to Solidity's `+` operator.
1037      *
1038      * Requirements:
1039      *
1040      * - Addition cannot overflow.
1041      */
1042     function add(int256 a, int256 b) internal pure returns (int256) {
1043         int256 c = a + b;
1044         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
1045 
1046         return c;
1047     }
1048 }
1049 
1050 
1051 // File contracts/interfaces/IController.sol
1052 
1053 /*
1054     Copyright 2020 Set Labs Inc.
1055 
1056     Licensed under the Apache License, Version 2.0 (the "License");
1057     you may not use this file except in compliance with the License.
1058     You may obtain a copy of the License at
1059 
1060     http://www.apache.org/licenses/LICENSE-2.0
1061 
1062     Unless required by applicable law or agreed to in writing, software
1063     distributed under the License is distributed on an "AS IS" BASIS,
1064     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1065     See the License for the specific language governing permissions and
1066     limitations under the License.
1067 */
1068 pragma solidity 0.6.10;
1069 
1070 interface IController {
1071     function addSet(address _setToken) external;
1072     function feeRecipient() external view returns(address);
1073     function getModuleFee(address _module, uint256 _feeType) external view returns(uint256);
1074     function isModule(address _module) external view returns(bool);
1075     function isSet(address _setToken) external view returns(bool);
1076     function isSystemContract(address _contractAddress) external view returns (bool);
1077     function resourceId(uint256 _id) external view returns(address);
1078 }
1079 
1080 
1081 // File contracts/interfaces/IModule.sol
1082 
1083 /*
1084     Copyright 2020 Set Labs Inc.
1085 
1086     Licensed under the Apache License, Version 2.0 (the "License");
1087     you may not use this file except in compliance with the License.
1088     You may obtain a copy of the License at
1089 
1090     http://www.apache.org/licenses/LICENSE-2.0
1091 
1092     Unless required by applicable law or agreed to in writing, software
1093     distributed under the License is distributed on an "AS IS" BASIS,
1094     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1095     See the License for the specific language governing permissions and
1096     limitations under the License.
1097 */
1098 pragma solidity 0.6.10;
1099 
1100 
1101 /**
1102  * @title IModule
1103  * @author Set Protocol
1104  *
1105  * Interface for interacting with Modules.
1106  */
1107 interface IModule {
1108     /**
1109      * Called by a SetToken to notify that this module was removed from the Set token. Any logic can be included
1110      * in case checks need to be made or state needs to be cleared.
1111      */
1112     function removeModule() external;
1113 }
1114 
1115 
1116 // File contracts/interfaces/ISetToken.sol
1117 
1118 /*
1119     Copyright 2020 Set Labs Inc.
1120 
1121     Licensed under the Apache License, Version 2.0 (the "License");
1122     you may not use this file except in compliance with the License.
1123     You may obtain a copy of the License at
1124 
1125     http://www.apache.org/licenses/LICENSE-2.0
1126 
1127     Unless required by applicable law or agreed to in writing, software
1128     distributed under the License is distributed on an "AS IS" BASIS,
1129     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1130     See the License for the specific language governing permissions and
1131     limitations under the License.
1132 */
1133 pragma solidity 0.6.10;
1134 
1135 /**
1136  * @title ISetToken
1137  * @author Set Protocol
1138  *
1139  * Interface for operating with SetTokens.
1140  */
1141 interface ISetToken is IERC20 {
1142 
1143     /* ============ Enums ============ */
1144 
1145     enum ModuleState {
1146         NONE,
1147         PENDING,
1148         INITIALIZED
1149     }
1150 
1151     /* ============ Structs ============ */
1152     /**
1153      * The base definition of a SetToken Position
1154      *
1155      * @param component           Address of token in the Position
1156      * @param module              If not in default state, the address of associated module
1157      * @param unit                Each unit is the # of components per 10^18 of a SetToken
1158      * @param positionState       Position ENUM. Default is 0; External is 1
1159      * @param data                Arbitrary data
1160      */
1161     struct Position {
1162         address component;
1163         address module;
1164         int256 unit;
1165         uint8 positionState;
1166         bytes data;
1167     }
1168 
1169     /**
1170      * A struct that stores a component's cash position details and external positions
1171      * This data structure allows O(1) access to a component's cash position units and 
1172      * virtual units.
1173      *
1174      * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
1175      *                                  updating all units at once via the position multiplier. Virtual units are achieved
1176      *                                  by dividing a "real" value by the "positionMultiplier"
1177      * @param componentIndex            
1178      * @param externalPositionModules   List of external modules attached to each external position. Each module
1179      *                                  maps to an external position
1180      * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
1181      */
1182     struct ComponentPosition {
1183       int256 virtualUnit;
1184       address[] externalPositionModules;
1185       mapping(address => ExternalPosition) externalPositions;
1186     }
1187 
1188     /**
1189      * A struct that stores a component's external position details including virtual unit and any
1190      * auxiliary data.
1191      *
1192      * @param virtualUnit       Virtual value of a component's EXTERNAL position.
1193      * @param data              Arbitrary data
1194      */
1195     struct ExternalPosition {
1196       int256 virtualUnit;
1197       bytes data;
1198     }
1199 
1200 
1201     /* ============ Functions ============ */
1202     
1203     function addComponent(address _component) external;
1204     function removeComponent(address _component) external;
1205     function editDefaultPositionUnit(address _component, int256 _realUnit) external;
1206     function addExternalPositionModule(address _component, address _positionModule) external;
1207     function removeExternalPositionModule(address _component, address _positionModule) external;
1208     function editExternalPositionUnit(address _component, address _positionModule, int256 _realUnit) external;
1209     function editExternalPositionData(address _component, address _positionModule, bytes calldata _data) external;
1210 
1211     function invoke(address _target, uint256 _value, bytes calldata _data) external returns(bytes memory);
1212 
1213     function editPositionMultiplier(int256 _newMultiplier) external;
1214 
1215     function mint(address _account, uint256 _quantity) external;
1216     function burn(address _account, uint256 _quantity) external;
1217 
1218     function lock() external;
1219     function unlock() external;
1220 
1221     function addModule(address _module) external;
1222     function removeModule(address _module) external;
1223     function initializeModule() external;
1224 
1225     function setManager(address _manager) external;
1226 
1227     function manager() external view returns (address);
1228     function moduleStates(address _module) external view returns (ModuleState);
1229     function getModules() external view returns (address[] memory);
1230     
1231     function getDefaultPositionRealUnit(address _component) external view returns(int256);
1232     function getExternalPositionRealUnit(address _component, address _positionModule) external view returns(int256);
1233     function getComponents() external view returns(address[] memory);
1234     function getExternalPositionModules(address _component) external view returns(address[] memory);
1235     function getExternalPositionData(address _component, address _positionModule) external view returns(bytes memory);
1236     function isExternalPositionModule(address _component, address _module) external view returns(bool);
1237     function isComponent(address _component) external view returns(bool);
1238     
1239     function positionMultiplier() external view returns (int256);
1240     function getPositions() external view returns (Position[] memory);
1241     function getTotalComponentRealUnits(address _component) external view returns(int256);
1242 
1243     function isInitializedModule(address _module) external view returns(bool);
1244     function isPendingModule(address _module) external view returns(bool);
1245     function isLocked() external view returns (bool);
1246 }
1247 
1248 
1249 // File contracts/lib/PreciseUnitMath.sol
1250 
1251 /*
1252     Copyright 2020 Set Labs Inc.
1253 
1254     Licensed under the Apache License, Version 2.0 (the "License");
1255     you may not use this file except in compliance with the License.
1256     You may obtain a copy of the License at
1257 
1258     http://www.apache.org/licenses/LICENSE-2.0
1259 
1260     Unless required by applicable law or agreed to in writing, software
1261     distributed under the License is distributed on an "AS IS" BASIS,
1262     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1263     See the License for the specific language governing permissions and
1264     limitations under the License.
1265 */
1266 
1267 pragma solidity 0.6.10;
1268 pragma experimental ABIEncoderV2;
1269 
1270 
1271 /**
1272  * @title PreciseUnitMath
1273  * @author Set Protocol
1274  *
1275  * Arithmetic for fixed-point numbers with 18 decimals of precision. Some functions taken from
1276  * dYdX's BaseMath library.
1277  *
1278  * CHANGELOG:
1279  * - 9/21/20: Added safePower function
1280  * - 4/21/21: Added approximatelyEquals function
1281  */
1282 library PreciseUnitMath {
1283     using SafeMath for uint256;
1284     using SignedSafeMath for int256;
1285 
1286     // The number One in precise units.
1287     uint256 constant internal PRECISE_UNIT = 10 ** 18;
1288     int256 constant internal PRECISE_UNIT_INT = 10 ** 18;
1289 
1290     // Max unsigned integer value
1291     uint256 constant internal MAX_UINT_256 = type(uint256).max;
1292     // Max and min signed integer value
1293     int256 constant internal MAX_INT_256 = type(int256).max;
1294     int256 constant internal MIN_INT_256 = type(int256).min;
1295 
1296     /**
1297      * @dev Getter function since constants can't be read directly from libraries.
1298      */
1299     function preciseUnit() internal pure returns (uint256) {
1300         return PRECISE_UNIT;
1301     }
1302 
1303     /**
1304      * @dev Getter function since constants can't be read directly from libraries.
1305      */
1306     function preciseUnitInt() internal pure returns (int256) {
1307         return PRECISE_UNIT_INT;
1308     }
1309 
1310     /**
1311      * @dev Getter function since constants can't be read directly from libraries.
1312      */
1313     function maxUint256() internal pure returns (uint256) {
1314         return MAX_UINT_256;
1315     }
1316 
1317     /**
1318      * @dev Getter function since constants can't be read directly from libraries.
1319      */
1320     function maxInt256() internal pure returns (int256) {
1321         return MAX_INT_256;
1322     }
1323 
1324     /**
1325      * @dev Getter function since constants can't be read directly from libraries.
1326      */
1327     function minInt256() internal pure returns (int256) {
1328         return MIN_INT_256;
1329     }
1330 
1331     /**
1332      * @dev Multiplies value a by value b (result is rounded down). It's assumed that the value b is the significand
1333      * of a number with 18 decimals precision.
1334      */
1335     function preciseMul(uint256 a, uint256 b) internal pure returns (uint256) {
1336         return a.mul(b).div(PRECISE_UNIT);
1337     }
1338 
1339     /**
1340      * @dev Multiplies value a by value b (result is rounded towards zero). It's assumed that the value b is the
1341      * significand of a number with 18 decimals precision.
1342      */
1343     function preciseMul(int256 a, int256 b) internal pure returns (int256) {
1344         return a.mul(b).div(PRECISE_UNIT_INT);
1345     }
1346 
1347     /**
1348      * @dev Multiplies value a by value b (result is rounded up). It's assumed that the value b is the significand
1349      * of a number with 18 decimals precision.
1350      */
1351     function preciseMulCeil(uint256 a, uint256 b) internal pure returns (uint256) {
1352         if (a == 0 || b == 0) {
1353             return 0;
1354         }
1355         return a.mul(b).sub(1).div(PRECISE_UNIT).add(1);
1356     }
1357 
1358     /**
1359      * @dev Divides value a by value b (result is rounded down).
1360      */
1361     function preciseDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1362         return a.mul(PRECISE_UNIT).div(b);
1363     }
1364 
1365 
1366     /**
1367      * @dev Divides value a by value b (result is rounded towards 0).
1368      */
1369     function preciseDiv(int256 a, int256 b) internal pure returns (int256) {
1370         return a.mul(PRECISE_UNIT_INT).div(b);
1371     }
1372 
1373     /**
1374      * @dev Divides value a by value b (result is rounded up or away from 0).
1375      */
1376     function preciseDivCeil(uint256 a, uint256 b) internal pure returns (uint256) {
1377         require(b != 0, "Cant divide by 0");
1378 
1379         return a > 0 ? a.mul(PRECISE_UNIT).sub(1).div(b).add(1) : 0;
1380     }
1381 
1382     /**
1383      * @dev Divides value a by value b (result is rounded down - positive numbers toward 0 and negative away from 0).
1384      */
1385     function divDown(int256 a, int256 b) internal pure returns (int256) {
1386         require(b != 0, "Cant divide by 0");
1387         require(a != MIN_INT_256 || b != -1, "Invalid input");
1388 
1389         int256 result = a.div(b);
1390         if (a ^ b < 0 && a % b != 0) {
1391             result -= 1;
1392         }
1393 
1394         return result;
1395     }
1396 
1397     /**
1398      * @dev Multiplies value a by value b where rounding is towards the lesser number.
1399      * (positive values are rounded towards zero and negative values are rounded away from 0).
1400      */
1401     function conservativePreciseMul(int256 a, int256 b) internal pure returns (int256) {
1402         return divDown(a.mul(b), PRECISE_UNIT_INT);
1403     }
1404 
1405     /**
1406      * @dev Divides value a by value b where rounding is towards the lesser number.
1407      * (positive values are rounded towards zero and negative values are rounded away from 0).
1408      */
1409     function conservativePreciseDiv(int256 a, int256 b) internal pure returns (int256) {
1410         return divDown(a.mul(PRECISE_UNIT_INT), b);
1411     }
1412 
1413     /**
1414     * @dev Performs the power on a specified value, reverts on overflow.
1415     */
1416     function safePower(
1417         uint256 a,
1418         uint256 pow
1419     )
1420         internal
1421         pure
1422         returns (uint256)
1423     {
1424         require(a > 0, "Value must be positive");
1425 
1426         uint256 result = 1;
1427         for (uint256 i = 0; i < pow; i++){
1428             uint256 previousResult = result;
1429 
1430             // Using safemath multiplication prevents overflows
1431             result = previousResult.mul(a);
1432         }
1433 
1434         return result;
1435     }
1436 
1437     /**
1438      * @dev Returns true if a =~ b within range, false otherwise.
1439      */
1440     function approximatelyEquals(uint256 a, uint256 b, uint256 range) internal pure returns (bool) {
1441         return a <= b.add(range) && a >= b.sub(range);
1442     }
1443 }
1444 
1445 
1446 // File contracts/protocol/lib/Position.sol
1447 
1448 /*
1449     Copyright 2020 Set Labs Inc.
1450 
1451     Licensed under the Apache License, Version 2.0 (the "License");
1452     you may not use this file except in compliance with the License.
1453     You may obtain a copy of the License at
1454 
1455     http://www.apache.org/licenses/LICENSE-2.0
1456 
1457     Unless required by applicable law or agreed to in writing, software
1458     distributed under the License is distributed on an "AS IS" BASIS,
1459     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1460     See the License for the specific language governing permissions and
1461     limitations under the License.
1462 */
1463 
1464 pragma solidity 0.6.10;
1465 
1466 
1467 
1468 
1469 
1470 /**
1471  * @title Position
1472  * @author Set Protocol
1473  *
1474  * Collection of helper functions for handling and updating SetToken Positions
1475  *
1476  * CHANGELOG:
1477  *  - Updated editExternalPosition to work when no external position is associated with module
1478  */
1479 library Position {
1480     using SafeCast for uint256;
1481     using SafeMath for uint256;
1482     using SafeCast for int256;
1483     using SignedSafeMath for int256;
1484     using PreciseUnitMath for uint256;
1485 
1486     /* ============ Helper ============ */
1487 
1488     /**
1489      * Returns whether the SetToken has a default position for a given component (if the real unit is > 0)
1490      */
1491     function hasDefaultPosition(ISetToken _setToken, address _component) internal view returns(bool) {
1492         return _setToken.getDefaultPositionRealUnit(_component) > 0;
1493     }
1494 
1495     /**
1496      * Returns whether the SetToken has an external position for a given component (if # of position modules is > 0)
1497      */
1498     function hasExternalPosition(ISetToken _setToken, address _component) internal view returns(bool) {
1499         return _setToken.getExternalPositionModules(_component).length > 0;
1500     }
1501     
1502     /**
1503      * Returns whether the SetToken component default position real unit is greater than or equal to units passed in.
1504      */
1505     function hasSufficientDefaultUnits(ISetToken _setToken, address _component, uint256 _unit) internal view returns(bool) {
1506         return _setToken.getDefaultPositionRealUnit(_component) >= _unit.toInt256();
1507     }
1508 
1509     /**
1510      * Returns whether the SetToken component external position is greater than or equal to the real units passed in.
1511      */
1512     function hasSufficientExternalUnits(
1513         ISetToken _setToken,
1514         address _component,
1515         address _positionModule,
1516         uint256 _unit
1517     )
1518         internal
1519         view
1520         returns(bool)
1521     {
1522        return _setToken.getExternalPositionRealUnit(_component, _positionModule) >= _unit.toInt256();    
1523     }
1524 
1525     /**
1526      * If the position does not exist, create a new Position and add to the SetToken. If it already exists,
1527      * then set the position units. If the new units is 0, remove the position. Handles adding/removing of 
1528      * components where needed (in light of potential external positions).
1529      *
1530      * @param _setToken           Address of SetToken being modified
1531      * @param _component          Address of the component
1532      * @param _newUnit            Quantity of Position units - must be >= 0
1533      */
1534     function editDefaultPosition(ISetToken _setToken, address _component, uint256 _newUnit) internal {
1535         bool isPositionFound = hasDefaultPosition(_setToken, _component);
1536         if (!isPositionFound && _newUnit > 0) {
1537             // If there is no Default Position and no External Modules, then component does not exist
1538             if (!hasExternalPosition(_setToken, _component)) {
1539                 _setToken.addComponent(_component);
1540             }
1541         } else if (isPositionFound && _newUnit == 0) {
1542             // If there is a Default Position and no external positions, remove the component
1543             if (!hasExternalPosition(_setToken, _component)) {
1544                 _setToken.removeComponent(_component);
1545             }
1546         }
1547 
1548         _setToken.editDefaultPositionUnit(_component, _newUnit.toInt256());
1549     }
1550 
1551     /**
1552      * Update an external position and remove and external positions or components if necessary. The logic flows as follows:
1553      * 1) If component is not already added then add component and external position. 
1554      * 2) If component is added but no existing external position using the passed module exists then add the external position.
1555      * 3) If the existing position is being added to then just update the unit and data
1556      * 4) If the position is being closed and no other external positions or default positions are associated with the component
1557      *    then untrack the component and remove external position.
1558      * 5) If the position is being closed and other existing positions still exist for the component then just remove the
1559      *    external position.
1560      *
1561      * @param _setToken         SetToken being updated
1562      * @param _component        Component position being updated
1563      * @param _module           Module external position is associated with
1564      * @param _newUnit          Position units of new external position
1565      * @param _data             Arbitrary data associated with the position
1566      */
1567     function editExternalPosition(
1568         ISetToken _setToken,
1569         address _component,
1570         address _module,
1571         int256 _newUnit,
1572         bytes memory _data
1573     )
1574         internal
1575     {
1576         if (_newUnit != 0) {
1577             if (!_setToken.isComponent(_component)) {
1578                 _setToken.addComponent(_component);
1579                 _setToken.addExternalPositionModule(_component, _module);
1580             } else if (!_setToken.isExternalPositionModule(_component, _module)) {
1581                 _setToken.addExternalPositionModule(_component, _module);
1582             }
1583             _setToken.editExternalPositionUnit(_component, _module, _newUnit);
1584             _setToken.editExternalPositionData(_component, _module, _data);
1585         } else {
1586             require(_data.length == 0, "Passed data must be null");
1587             // If no default or external position remaining then remove component from components array
1588             if (_setToken.getExternalPositionRealUnit(_component, _module) != 0) {
1589                 address[] memory positionModules = _setToken.getExternalPositionModules(_component);
1590                 if (_setToken.getDefaultPositionRealUnit(_component) == 0 && positionModules.length == 1) {
1591                     require(positionModules[0] == _module, "External positions must be 0 to remove component");
1592                     _setToken.removeComponent(_component);
1593                 }
1594                 _setToken.removeExternalPositionModule(_component, _module);
1595             }
1596         }
1597     }
1598 
1599     /**
1600      * Get total notional amount of Default position
1601      *
1602      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
1603      * @param _positionUnit       Quantity of Position units
1604      *
1605      * @return                    Total notional amount of units
1606      */
1607     function getDefaultTotalNotional(uint256 _setTokenSupply, uint256 _positionUnit) internal pure returns (uint256) {
1608         return _setTokenSupply.preciseMul(_positionUnit);
1609     }
1610 
1611     /**
1612      * Get position unit from total notional amount
1613      *
1614      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
1615      * @param _totalNotional      Total notional amount of component prior to
1616      * @return                    Default position unit
1617      */
1618     function getDefaultPositionUnit(uint256 _setTokenSupply, uint256 _totalNotional) internal pure returns (uint256) {
1619         return _totalNotional.preciseDiv(_setTokenSupply);
1620     }
1621 
1622     /**
1623      * Get the total tracked balance - total supply * position unit
1624      *
1625      * @param _setToken           Address of the SetToken
1626      * @param _component          Address of the component
1627      * @return                    Notional tracked balance
1628      */
1629     function getDefaultTrackedBalance(ISetToken _setToken, address _component) internal view returns(uint256) {
1630         int256 positionUnit = _setToken.getDefaultPositionRealUnit(_component); 
1631         return _setToken.totalSupply().preciseMul(positionUnit.toUint256());
1632     }
1633 
1634     /**
1635      * Calculates the new default position unit and performs the edit with the new unit
1636      *
1637      * @param _setToken                 Address of the SetToken
1638      * @param _component                Address of the component
1639      * @param _setTotalSupply           Current SetToken supply
1640      * @param _componentPreviousBalance Pre-action component balance
1641      * @return                          Current component balance
1642      * @return                          Previous position unit
1643      * @return                          New position unit
1644      */
1645     function calculateAndEditDefaultPosition(
1646         ISetToken _setToken,
1647         address _component,
1648         uint256 _setTotalSupply,
1649         uint256 _componentPreviousBalance
1650     )
1651         internal
1652         returns(uint256, uint256, uint256)
1653     {
1654         uint256 currentBalance = IERC20(_component).balanceOf(address(_setToken));
1655         uint256 positionUnit = _setToken.getDefaultPositionRealUnit(_component).toUint256();
1656 
1657         uint256 newTokenUnit;
1658         if (currentBalance > 0) {
1659             newTokenUnit = calculateDefaultEditPositionUnit(
1660                 _setTotalSupply,
1661                 _componentPreviousBalance,
1662                 currentBalance,
1663                 positionUnit
1664             );
1665         } else {
1666             newTokenUnit = 0;
1667         }
1668 
1669         editDefaultPosition(_setToken, _component, newTokenUnit);
1670 
1671         return (currentBalance, positionUnit, newTokenUnit);
1672     }
1673 
1674     /**
1675      * Calculate the new position unit given total notional values pre and post executing an action that changes SetToken state
1676      * The intention is to make updates to the units without accidentally picking up airdropped assets as well.
1677      *
1678      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
1679      * @param _preTotalNotional   Total notional amount of component prior to executing action
1680      * @param _postTotalNotional  Total notional amount of component after the executing action
1681      * @param _prePositionUnit    Position unit of SetToken prior to executing action
1682      * @return                    New position unit
1683      */
1684     function calculateDefaultEditPositionUnit(
1685         uint256 _setTokenSupply,
1686         uint256 _preTotalNotional,
1687         uint256 _postTotalNotional,
1688         uint256 _prePositionUnit
1689     )
1690         internal
1691         pure
1692         returns (uint256)
1693     {
1694         // If pre action total notional amount is greater then subtract post action total notional and calculate new position units
1695         uint256 airdroppedAmount = _preTotalNotional.sub(_prePositionUnit.preciseMul(_setTokenSupply));
1696         return _postTotalNotional.sub(airdroppedAmount).preciseDiv(_setTokenSupply);
1697     }
1698 }
1699 
1700 
1701 // File contracts/lib/AddressArrayUtils.sol
1702 
1703 /*
1704     Copyright 2020 Set Labs Inc.
1705 
1706     Licensed under the Apache License, Version 2.0 (the "License");
1707     you may not use this file except in compliance with the License.
1708     You may obtain a copy of the License at
1709 
1710     http://www.apache.org/licenses/LICENSE-2.0
1711 
1712     Unless required by applicable law or agreed to in writing, software
1713     distributed under the License is distributed on an "AS IS" BASIS,
1714     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1715     See the License for the specific language governing permissions and
1716     limitations under the License.
1717 */
1718 
1719 pragma solidity 0.6.10;
1720 
1721 /**
1722  * @title AddressArrayUtils
1723  * @author Set Protocol
1724  *
1725  * Utility functions to handle Address Arrays
1726  *
1727  * CHANGELOG:
1728  * - 4/21/21: Added validatePairsWithArray methods
1729  */
1730 library AddressArrayUtils {
1731 
1732     /**
1733      * Finds the index of the first occurrence of the given element.
1734      * @param A The input array to search
1735      * @param a The value to find
1736      * @return Returns (index and isIn) for the first occurrence starting from index 0
1737      */
1738     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
1739         uint256 length = A.length;
1740         for (uint256 i = 0; i < length; i++) {
1741             if (A[i] == a) {
1742                 return (i, true);
1743             }
1744         }
1745         return (uint256(-1), false);
1746     }
1747 
1748     /**
1749     * Returns true if the value is present in the list. Uses indexOf internally.
1750     * @param A The input array to search
1751     * @param a The value to find
1752     * @return Returns isIn for the first occurrence starting from index 0
1753     */
1754     function contains(address[] memory A, address a) internal pure returns (bool) {
1755         (, bool isIn) = indexOf(A, a);
1756         return isIn;
1757     }
1758 
1759     /**
1760     * Returns true if there are 2 elements that are the same in an array
1761     * @param A The input array to search
1762     * @return Returns boolean for the first occurrence of a duplicate
1763     */
1764     function hasDuplicate(address[] memory A) internal pure returns(bool) {
1765         require(A.length > 0, "A is empty");
1766 
1767         for (uint256 i = 0; i < A.length - 1; i++) {
1768             address current = A[i];
1769             for (uint256 j = i + 1; j < A.length; j++) {
1770                 if (current == A[j]) {
1771                     return true;
1772                 }
1773             }
1774         }
1775         return false;
1776     }
1777 
1778     /**
1779      * @param A The input array to search
1780      * @param a The address to remove
1781      * @return Returns the array with the object removed.
1782      */
1783     function remove(address[] memory A, address a)
1784         internal
1785         pure
1786         returns (address[] memory)
1787     {
1788         (uint256 index, bool isIn) = indexOf(A, a);
1789         if (!isIn) {
1790             revert("Address not in array.");
1791         } else {
1792             (address[] memory _A,) = pop(A, index);
1793             return _A;
1794         }
1795     }
1796 
1797     /**
1798      * @param A The input array to search
1799      * @param a The address to remove
1800      */
1801     function removeStorage(address[] storage A, address a)
1802         internal
1803     {
1804         (uint256 index, bool isIn) = indexOf(A, a);
1805         if (!isIn) {
1806             revert("Address not in array.");
1807         } else {
1808             uint256 lastIndex = A.length - 1; // If the array would be empty, the previous line would throw, so no underflow here
1809             if (index != lastIndex) { A[index] = A[lastIndex]; }
1810             A.pop();
1811         }
1812     }
1813 
1814     /**
1815     * Removes specified index from array
1816     * @param A The input array to search
1817     * @param index The index to remove
1818     * @return Returns the new array and the removed entry
1819     */
1820     function pop(address[] memory A, uint256 index)
1821         internal
1822         pure
1823         returns (address[] memory, address)
1824     {
1825         uint256 length = A.length;
1826         require(index < A.length, "Index must be < A length");
1827         address[] memory newAddresses = new address[](length - 1);
1828         for (uint256 i = 0; i < index; i++) {
1829             newAddresses[i] = A[i];
1830         }
1831         for (uint256 j = index + 1; j < length; j++) {
1832             newAddresses[j - 1] = A[j];
1833         }
1834         return (newAddresses, A[index]);
1835     }
1836 
1837     /**
1838      * Returns the combination of the two arrays
1839      * @param A The first array
1840      * @param B The second array
1841      * @return Returns A extended by B
1842      */
1843     function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1844         uint256 aLength = A.length;
1845         uint256 bLength = B.length;
1846         address[] memory newAddresses = new address[](aLength + bLength);
1847         for (uint256 i = 0; i < aLength; i++) {
1848             newAddresses[i] = A[i];
1849         }
1850         for (uint256 j = 0; j < bLength; j++) {
1851             newAddresses[aLength + j] = B[j];
1852         }
1853         return newAddresses;
1854     }
1855 
1856     /**
1857      * Validate that address and uint array lengths match. Validate address array is not empty
1858      * and contains no duplicate elements.
1859      *
1860      * @param A         Array of addresses
1861      * @param B         Array of uint
1862      */
1863     function validatePairsWithArray(address[] memory A, uint[] memory B) internal pure {
1864         require(A.length == B.length, "Array length mismatch");
1865         _validateLengthAndUniqueness(A);
1866     }
1867 
1868     /**
1869      * Validate that address and bool array lengths match. Validate address array is not empty
1870      * and contains no duplicate elements.
1871      *
1872      * @param A         Array of addresses
1873      * @param B         Array of bool
1874      */
1875     function validatePairsWithArray(address[] memory A, bool[] memory B) internal pure {
1876         require(A.length == B.length, "Array length mismatch");
1877         _validateLengthAndUniqueness(A);
1878     }
1879 
1880     /**
1881      * Validate that address and string array lengths match. Validate address array is not empty
1882      * and contains no duplicate elements.
1883      *
1884      * @param A         Array of addresses
1885      * @param B         Array of strings
1886      */
1887     function validatePairsWithArray(address[] memory A, string[] memory B) internal pure {
1888         require(A.length == B.length, "Array length mismatch");
1889         _validateLengthAndUniqueness(A);
1890     }
1891 
1892     /**
1893      * Validate that address array lengths match, and calling address array are not empty
1894      * and contain no duplicate elements.
1895      *
1896      * @param A         Array of addresses
1897      * @param B         Array of addresses
1898      */
1899     function validatePairsWithArray(address[] memory A, address[] memory B) internal pure {
1900         require(A.length == B.length, "Array length mismatch");
1901         _validateLengthAndUniqueness(A);
1902     }
1903 
1904     /**
1905      * Validate that address and bytes array lengths match. Validate address array is not empty
1906      * and contains no duplicate elements.
1907      *
1908      * @param A         Array of addresses
1909      * @param B         Array of bytes
1910      */
1911     function validatePairsWithArray(address[] memory A, bytes[] memory B) internal pure {
1912         require(A.length == B.length, "Array length mismatch");
1913         _validateLengthAndUniqueness(A);
1914     }
1915 
1916     /**
1917      * Validate address array is not empty and contains no duplicate elements.
1918      *
1919      * @param A          Array of addresses
1920      */
1921     function _validateLengthAndUniqueness(address[] memory A) internal pure {
1922         require(A.length > 0, "Array length must be > 0");
1923         require(!hasDuplicate(A), "Cannot duplicate addresses");
1924     }
1925 }
1926 
1927 
1928 // File contracts/protocol/SetToken.sol
1929 
1930 /*
1931     Copyright 2020 Set Labs Inc.
1932 
1933     Licensed under the Apache License, Version 2.0 (the "License");
1934     you may not use this file except in compliance with the License.
1935     You may obtain a copy of the License at
1936 
1937     http://www.apache.org/licenses/LICENSE-2.0
1938 
1939     Unless required by applicable law or agreed to in writing, software
1940     distributed under the License is distributed on an "AS IS" BASIS,
1941     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1942     See the License for the specific language governing permissions and
1943     limitations under the License.
1944 */
1945 
1946 pragma solidity 0.6.10;
1947 
1948 
1949 
1950 
1951 
1952 
1953 
1954 
1955 
1956 
1957 /**
1958  * @title SetToken
1959  * @author Set Protocol
1960  *
1961  * ERC20 Token contract that allows privileged modules to make modifications to its positions and invoke function calls
1962  * from the SetToken. 
1963  */
1964 contract SetToken is ERC20 {
1965     using SafeMath for uint256;
1966     using SafeCast for int256;
1967     using SafeCast for uint256;
1968     using SignedSafeMath for int256;
1969     using PreciseUnitMath for int256;
1970     using Address for address;
1971     using AddressArrayUtils for address[];
1972 
1973     /* ============ Constants ============ */
1974 
1975     /*
1976         The PositionState is the status of the Position, whether it is Default (held on the SetToken)
1977         or otherwise held on a separate smart contract (whether a module or external source).
1978         There are issues with cross-usage of enums, so we are defining position states
1979         as a uint8.
1980     */
1981     uint8 internal constant DEFAULT = 0;
1982     uint8 internal constant EXTERNAL = 1;
1983 
1984     /* ============ Events ============ */
1985 
1986     event Invoked(address indexed _target, uint indexed _value, bytes _data, bytes _returnValue);
1987     event ModuleAdded(address indexed _module);
1988     event ModuleRemoved(address indexed _module);    
1989     event ModuleInitialized(address indexed _module);
1990     event ManagerEdited(address _newManager, address _oldManager);
1991     event PendingModuleRemoved(address indexed _module);
1992     event PositionMultiplierEdited(int256 _newMultiplier);
1993     event ComponentAdded(address indexed _component);
1994     event ComponentRemoved(address indexed _component);
1995     event DefaultPositionUnitEdited(address indexed _component, int256 _realUnit);
1996     event ExternalPositionUnitEdited(address indexed _component, address indexed _positionModule, int256 _realUnit);
1997     event ExternalPositionDataEdited(address indexed _component, address indexed _positionModule, bytes _data);
1998     event PositionModuleAdded(address indexed _component, address indexed _positionModule);
1999     event PositionModuleRemoved(address indexed _component, address indexed _positionModule);
2000 
2001     /* ============ Modifiers ============ */
2002 
2003     /**
2004      * Throws if the sender is not a SetToken's module or module not enabled
2005      */
2006     modifier onlyModule() {
2007         // Internal function used to reduce bytecode size
2008         _validateOnlyModule();
2009         _;
2010     }
2011 
2012     /**
2013      * Throws if the sender is not the SetToken's manager
2014      */
2015     modifier onlyManager() {
2016         _validateOnlyManager();
2017         _;
2018     }
2019 
2020     /**
2021      * Throws if SetToken is locked and called by any account other than the locker.
2022      */
2023     modifier whenLockedOnlyLocker() {
2024         _validateWhenLockedOnlyLocker();
2025         _;
2026     }
2027 
2028     /* ============ State Variables ============ */
2029 
2030     // Address of the controller
2031     IController public controller;
2032 
2033     // The manager has the privelege to add modules, remove, and set a new manager
2034     address public manager;
2035 
2036     // A module that has locked other modules from privileged functionality, typically required
2037     // for multi-block module actions such as auctions
2038     address public locker;
2039 
2040     // List of initialized Modules; Modules extend the functionality of SetTokens
2041     address[] public modules;
2042 
2043     // Modules are initialized from NONE -> PENDING -> INITIALIZED through the
2044     // addModule (called by manager) and initialize  (called by module) functions
2045     mapping(address => ISetToken.ModuleState) public moduleStates;
2046 
2047     // When locked, only the locker (a module) can call privileged functionality
2048     // Typically utilized if a module (e.g. Auction) needs multiple transactions to complete an action
2049     // without interruption
2050     bool public isLocked;
2051 
2052     // List of components
2053     address[] public components;
2054 
2055     // Mapping that stores all Default and External position information for a given component.
2056     // Position quantities are represented as virtual units; Default positions are on the top-level,
2057     // while external positions are stored in a module array and accessed through its externalPositions mapping
2058     mapping(address => ISetToken.ComponentPosition) private componentPositions;
2059 
2060     // The multiplier applied to the virtual position unit to achieve the real/actual unit.
2061     // This multiplier is used for efficiently modifying the entire position units (e.g. streaming fee)
2062     int256 public positionMultiplier;
2063 
2064     /* ============ Constructor ============ */
2065 
2066     /**
2067      * When a new SetToken is created, initializes Positions in default state and adds modules into pending state.
2068      * All parameter validations are on the SetTokenCreator contract. Validations are performed already on the 
2069      * SetTokenCreator. Initiates the positionMultiplier as 1e18 (no adjustments).
2070      *
2071      * @param _components             List of addresses of components for initial Positions
2072      * @param _units                  List of units. Each unit is the # of components per 10^18 of a SetToken
2073      * @param _modules                List of modules to enable. All modules must be approved by the Controller
2074      * @param _controller             Address of the controller
2075      * @param _manager                Address of the manager
2076      * @param _name                   Name of the SetToken
2077      * @param _symbol                 Symbol of the SetToken
2078      */
2079     constructor(
2080         address[] memory _components,
2081         int256[] memory _units,
2082         address[] memory _modules,
2083         IController _controller,
2084         address _manager,
2085         string memory _name,
2086         string memory _symbol
2087     )
2088         public
2089         ERC20(_name, _symbol)
2090     {
2091         controller = _controller;
2092         manager = _manager;
2093         positionMultiplier = PreciseUnitMath.preciseUnitInt();
2094         components = _components;
2095 
2096         // Modules are put in PENDING state, as they need to be individually initialized by the Module
2097         for (uint256 i = 0; i < _modules.length; i++) {
2098             moduleStates[_modules[i]] = ISetToken.ModuleState.PENDING;
2099         }
2100 
2101         // Positions are put in default state initially
2102         for (uint256 j = 0; j < _components.length; j++) {
2103             componentPositions[_components[j]].virtualUnit = _units[j];
2104         }
2105     }
2106 
2107     /* ============ External Functions ============ */
2108 
2109     /**
2110      * PRIVELEGED MODULE FUNCTION. Low level function that allows a module to make an arbitrary function
2111      * call to any contract.
2112      *
2113      * @param _target                 Address of the smart contract to call
2114      * @param _value                  Quantity of Ether to provide the call (typically 0)
2115      * @param _data                   Encoded function selector and arguments
2116      * @return _returnValue           Bytes encoded return value
2117      */
2118     function invoke(
2119         address _target,
2120         uint256 _value,
2121         bytes calldata _data
2122     )
2123         external
2124         onlyModule
2125         whenLockedOnlyLocker
2126         returns (bytes memory _returnValue)
2127     {
2128         _returnValue = _target.functionCallWithValue(_data, _value);
2129 
2130         emit Invoked(_target, _value, _data, _returnValue);
2131 
2132         return _returnValue;
2133     }
2134 
2135     /**
2136      * PRIVELEGED MODULE FUNCTION. Low level function that adds a component to the components array.
2137      */
2138     function addComponent(address _component) external onlyModule whenLockedOnlyLocker {
2139         require(!isComponent(_component), "Must not be component");
2140         
2141         components.push(_component);
2142 
2143         emit ComponentAdded(_component);
2144     }
2145 
2146     /**
2147      * PRIVELEGED MODULE FUNCTION. Low level function that removes a component from the components array.
2148      */
2149     function removeComponent(address _component) external onlyModule whenLockedOnlyLocker {
2150         components.removeStorage(_component);
2151 
2152         emit ComponentRemoved(_component);
2153     }
2154 
2155     /**
2156      * PRIVELEGED MODULE FUNCTION. Low level function that edits a component's virtual unit. Takes a real unit
2157      * and converts it to virtual before committing.
2158      */
2159     function editDefaultPositionUnit(address _component, int256 _realUnit) external onlyModule whenLockedOnlyLocker {
2160         int256 virtualUnit = _convertRealToVirtualUnit(_realUnit);
2161 
2162         componentPositions[_component].virtualUnit = virtualUnit;
2163 
2164         emit DefaultPositionUnitEdited(_component, _realUnit);
2165     }
2166 
2167     /**
2168      * PRIVELEGED MODULE FUNCTION. Low level function that adds a module to a component's externalPositionModules array
2169      */
2170     function addExternalPositionModule(address _component, address _positionModule) external onlyModule whenLockedOnlyLocker {
2171         require(!isExternalPositionModule(_component, _positionModule), "Module already added");
2172 
2173         componentPositions[_component].externalPositionModules.push(_positionModule);
2174 
2175         emit PositionModuleAdded(_component, _positionModule);
2176     }
2177 
2178     /**
2179      * PRIVELEGED MODULE FUNCTION. Low level function that removes a module from a component's 
2180      * externalPositionModules array and deletes the associated externalPosition.
2181      */
2182     function removeExternalPositionModule(
2183         address _component,
2184         address _positionModule
2185     )
2186         external
2187         onlyModule
2188         whenLockedOnlyLocker
2189     {
2190         componentPositions[_component].externalPositionModules.removeStorage(_positionModule);
2191 
2192         delete componentPositions[_component].externalPositions[_positionModule];
2193 
2194         emit PositionModuleRemoved(_component, _positionModule);
2195     }
2196 
2197     /**
2198      * PRIVELEGED MODULE FUNCTION. Low level function that edits a component's external position virtual unit. 
2199      * Takes a real unit and converts it to virtual before committing.
2200      */
2201     function editExternalPositionUnit(
2202         address _component,
2203         address _positionModule,
2204         int256 _realUnit
2205     )
2206         external
2207         onlyModule
2208         whenLockedOnlyLocker
2209     {
2210         int256 virtualUnit = _convertRealToVirtualUnit(_realUnit);
2211 
2212         componentPositions[_component].externalPositions[_positionModule].virtualUnit = virtualUnit;
2213 
2214         emit ExternalPositionUnitEdited(_component, _positionModule, _realUnit);
2215     }
2216 
2217     /**
2218      * PRIVELEGED MODULE FUNCTION. Low level function that edits a component's external position data
2219      */
2220     function editExternalPositionData(
2221         address _component,
2222         address _positionModule,
2223         bytes calldata _data
2224     )
2225         external
2226         onlyModule
2227         whenLockedOnlyLocker
2228     {
2229         componentPositions[_component].externalPositions[_positionModule].data = _data;
2230 
2231         emit ExternalPositionDataEdited(_component, _positionModule, _data);
2232     }
2233 
2234     /**
2235      * PRIVELEGED MODULE FUNCTION. Modifies the position multiplier. This is typically used to efficiently
2236      * update all the Positions' units at once in applications where inflation is awarded (e.g. subscription fees).
2237      */
2238     function editPositionMultiplier(int256 _newMultiplier) external onlyModule whenLockedOnlyLocker {        
2239         _validateNewMultiplier(_newMultiplier);
2240 
2241         positionMultiplier = _newMultiplier;
2242 
2243         emit PositionMultiplierEdited(_newMultiplier);
2244     }
2245 
2246     /**
2247      * PRIVELEGED MODULE FUNCTION. Increases the "account" balance by the "quantity".
2248      */
2249     function mint(address _account, uint256 _quantity) external onlyModule whenLockedOnlyLocker {
2250         _mint(_account, _quantity);
2251     }
2252 
2253     /**
2254      * PRIVELEGED MODULE FUNCTION. Decreases the "account" balance by the "quantity".
2255      * _burn checks that the "account" already has the required "quantity".
2256      */
2257     function burn(address _account, uint256 _quantity) external onlyModule whenLockedOnlyLocker {
2258         _burn(_account, _quantity);
2259     }
2260 
2261     /**
2262      * PRIVELEGED MODULE FUNCTION. When a SetToken is locked, only the locker can call privileged functions.
2263      */
2264     function lock() external onlyModule {
2265         require(!isLocked, "Must not be locked");
2266         locker = msg.sender;
2267         isLocked = true;
2268     }
2269 
2270     /**
2271      * PRIVELEGED MODULE FUNCTION. Unlocks the SetToken and clears the locker
2272      */
2273     function unlock() external onlyModule {
2274         require(isLocked, "Must be locked");
2275         require(locker == msg.sender, "Must be locker");
2276         delete locker;
2277         isLocked = false;
2278     }
2279 
2280     /**
2281      * MANAGER ONLY. Adds a module into a PENDING state; Module must later be initialized via 
2282      * module's initialize function
2283      */
2284     function addModule(address _module) external onlyManager {
2285         require(moduleStates[_module] == ISetToken.ModuleState.NONE, "Module must not be added");
2286         require(controller.isModule(_module), "Must be enabled on Controller");
2287 
2288         moduleStates[_module] = ISetToken.ModuleState.PENDING;
2289 
2290         emit ModuleAdded(_module);
2291     }
2292 
2293     /**
2294      * MANAGER ONLY. Removes a module from the SetToken. SetToken calls removeModule on module itself to confirm
2295      * it is not needed to manage any remaining positions and to remove state.
2296      */
2297     function removeModule(address _module) external onlyManager {
2298         require(!isLocked, "Only when unlocked");
2299         require(moduleStates[_module] == ISetToken.ModuleState.INITIALIZED, "Module must be added");
2300 
2301         IModule(_module).removeModule();
2302 
2303         moduleStates[_module] = ISetToken.ModuleState.NONE;
2304 
2305         modules.removeStorage(_module);
2306 
2307         emit ModuleRemoved(_module);
2308     }
2309 
2310     /**
2311      * MANAGER ONLY. Removes a pending module from the SetToken.
2312      */
2313     function removePendingModule(address _module) external onlyManager {
2314         require(!isLocked, "Only when unlocked");
2315         require(moduleStates[_module] == ISetToken.ModuleState.PENDING, "Module must be pending");
2316 
2317         moduleStates[_module] = ISetToken.ModuleState.NONE;
2318 
2319         emit PendingModuleRemoved(_module);
2320     }
2321 
2322     /**
2323      * Initializes an added module from PENDING to INITIALIZED state. Can only call when unlocked.
2324      * An address can only enter a PENDING state if it is an enabled module added by the manager.
2325      * Only callable by the module itself, hence msg.sender is the subject of update.
2326      */
2327     function initializeModule() external {
2328         require(!isLocked, "Only when unlocked");
2329         require(moduleStates[msg.sender] == ISetToken.ModuleState.PENDING, "Module must be pending");
2330         
2331         moduleStates[msg.sender] = ISetToken.ModuleState.INITIALIZED;
2332         modules.push(msg.sender);
2333 
2334         emit ModuleInitialized(msg.sender);
2335     }
2336 
2337     /**
2338      * MANAGER ONLY. Changes manager; We allow null addresses in case the manager wishes to wind down the SetToken.
2339      * Modules may rely on the manager state, so only changable when unlocked
2340      */
2341     function setManager(address _manager) external onlyManager {
2342         require(!isLocked, "Only when unlocked");
2343         address oldManager = manager;
2344         manager = _manager;
2345 
2346         emit ManagerEdited(_manager, oldManager);
2347     }
2348 
2349     /* ============ External Getter Functions ============ */
2350 
2351     function getComponents() external view returns(address[] memory) {
2352         return components;
2353     }
2354 
2355     function getDefaultPositionRealUnit(address _component) public view returns(int256) {
2356         return _convertVirtualToRealUnit(_defaultPositionVirtualUnit(_component));
2357     }
2358 
2359     function getExternalPositionRealUnit(address _component, address _positionModule) public view returns(int256) {
2360         return _convertVirtualToRealUnit(_externalPositionVirtualUnit(_component, _positionModule));
2361     }
2362 
2363     function getExternalPositionModules(address _component) external view returns(address[] memory) {
2364         return _externalPositionModules(_component);
2365     }
2366 
2367     function getExternalPositionData(address _component,address _positionModule) external view returns(bytes memory) {
2368         return _externalPositionData(_component, _positionModule);
2369     }
2370 
2371     function getModules() external view returns (address[] memory) {
2372         return modules;
2373     }
2374 
2375     function isComponent(address _component) public view returns(bool) {
2376         return components.contains(_component);
2377     }
2378 
2379     function isExternalPositionModule(address _component, address _module) public view returns(bool) {
2380         return _externalPositionModules(_component).contains(_module);
2381     }
2382 
2383     /**
2384      * Only ModuleStates of INITIALIZED modules are considered enabled
2385      */
2386     function isInitializedModule(address _module) external view returns (bool) {
2387         return moduleStates[_module] == ISetToken.ModuleState.INITIALIZED;
2388     }
2389 
2390     /**
2391      * Returns whether the module is in a pending state
2392      */
2393     function isPendingModule(address _module) external view returns (bool) {
2394         return moduleStates[_module] == ISetToken.ModuleState.PENDING;
2395     }
2396 
2397     /**
2398      * Returns a list of Positions, through traversing the components. Each component with a non-zero virtual unit
2399      * is considered a Default Position, and each externalPositionModule will generate a unique position.
2400      * Virtual units are converted to real units. This function is typically used off-chain for data presentation purposes.
2401      */
2402     function getPositions() external view returns (ISetToken.Position[] memory) {
2403         ISetToken.Position[] memory positions = new ISetToken.Position[](_getPositionCount());
2404         uint256 positionCount = 0;
2405 
2406         for (uint256 i = 0; i < components.length; i++) {
2407             address component = components[i];
2408 
2409             // A default position exists if the default virtual unit is > 0
2410             if (_defaultPositionVirtualUnit(component) > 0) {
2411                 positions[positionCount] = ISetToken.Position({
2412                     component: component,
2413                     module: address(0),
2414                     unit: getDefaultPositionRealUnit(component),
2415                     positionState: DEFAULT,
2416                     data: ""
2417                 });
2418 
2419                 positionCount++;
2420             }
2421 
2422             address[] memory externalModules = _externalPositionModules(component);
2423             for (uint256 j = 0; j < externalModules.length; j++) {
2424                 address currentModule = externalModules[j];
2425 
2426                 positions[positionCount] = ISetToken.Position({
2427                     component: component,
2428                     module: currentModule,
2429                     unit: getExternalPositionRealUnit(component, currentModule),
2430                     positionState: EXTERNAL,
2431                     data: _externalPositionData(component, currentModule)
2432                 });
2433 
2434                 positionCount++;
2435             }
2436         }
2437 
2438         return positions;
2439     }
2440 
2441     /**
2442      * Returns the total Real Units for a given component, summing the default and external position units.
2443      */
2444     function getTotalComponentRealUnits(address _component) external view returns(int256) {
2445         int256 totalUnits = getDefaultPositionRealUnit(_component);
2446 
2447         address[] memory externalModules = _externalPositionModules(_component);
2448         for (uint256 i = 0; i < externalModules.length; i++) {
2449             // We will perform the summation no matter what, as an external position virtual unit can be negative
2450             totalUnits = totalUnits.add(getExternalPositionRealUnit(_component, externalModules[i]));
2451         }
2452 
2453         return totalUnits;
2454     }
2455 
2456 
2457     receive() external payable {} // solium-disable-line quotes
2458 
2459     /* ============ Internal Functions ============ */
2460 
2461     function _defaultPositionVirtualUnit(address _component) internal view returns(int256) {
2462         return componentPositions[_component].virtualUnit;
2463     }
2464 
2465     function _externalPositionModules(address _component) internal view returns(address[] memory) {
2466         return componentPositions[_component].externalPositionModules;
2467     }
2468 
2469     function _externalPositionVirtualUnit(address _component, address _module) internal view returns(int256) {
2470         return componentPositions[_component].externalPositions[_module].virtualUnit;
2471     }
2472 
2473     function _externalPositionData(address _component, address _module) internal view returns(bytes memory) {
2474         return componentPositions[_component].externalPositions[_module].data;
2475     }
2476 
2477     /**
2478      * Takes a real unit and divides by the position multiplier to return the virtual unit. Negative units will
2479      * be rounded away from 0 so no need to check that unit will be rounded down to 0 in conversion.
2480      */
2481     function _convertRealToVirtualUnit(int256 _realUnit) internal view returns(int256) {
2482         int256 virtualUnit = _realUnit.conservativePreciseDiv(positionMultiplier);
2483 
2484         // This check ensures that the virtual unit does not return a result that has rounded down to 0
2485         if (_realUnit > 0 && virtualUnit == 0) {
2486             revert("Real to Virtual unit conversion invalid");
2487         }
2488 
2489         // This check ensures that when converting back to realUnits the unit won't be rounded down to 0
2490         if (_realUnit > 0 && _convertVirtualToRealUnit(virtualUnit) == 0) {
2491             revert("Virtual to Real unit conversion invalid");
2492         }
2493 
2494         return virtualUnit;
2495     }
2496 
2497     /**
2498      * Takes a virtual unit and multiplies by the position multiplier to return the real unit
2499      */
2500     function _convertVirtualToRealUnit(int256 _virtualUnit) internal view returns(int256) {
2501         return _virtualUnit.conservativePreciseMul(positionMultiplier);
2502     }
2503 
2504     /**
2505      * To prevent virtual to real unit conversion issues (where real unit may be 0), the 
2506      * product of the positionMultiplier and the lowest absolute virtualUnit value (across default and
2507      * external positions) must be greater than 0.
2508      */
2509     function _validateNewMultiplier(int256 _newMultiplier) internal view {
2510         int256 minVirtualUnit = _getPositionsAbsMinimumVirtualUnit();
2511 
2512         require(minVirtualUnit.conservativePreciseMul(_newMultiplier) > 0, "New multiplier too small");
2513     }
2514 
2515     /**
2516      * Loops through all of the positions and returns the smallest absolute value of 
2517      * the virtualUnit.
2518      *
2519      * @return Min virtual unit across positions denominated as int256
2520      */
2521     function _getPositionsAbsMinimumVirtualUnit() internal view returns(int256) {
2522         // Additional assignment happens in the loop below
2523         uint256 minimumUnit = uint256(-1);
2524 
2525         for (uint256 i = 0; i < components.length; i++) {
2526             address component = components[i];
2527 
2528             // A default position exists if the default virtual unit is > 0
2529             uint256 defaultUnit = _defaultPositionVirtualUnit(component).toUint256();
2530             if (defaultUnit > 0 && defaultUnit < minimumUnit) {
2531                 minimumUnit = defaultUnit;
2532             }
2533 
2534             address[] memory externalModules = _externalPositionModules(component);
2535             for (uint256 j = 0; j < externalModules.length; j++) {
2536                 address currentModule = externalModules[j];
2537 
2538                 uint256 virtualUnit = _absoluteValue(
2539                     _externalPositionVirtualUnit(component, currentModule)
2540                 );
2541                 if (virtualUnit > 0 && virtualUnit < minimumUnit) {
2542                     minimumUnit = virtualUnit;
2543                 }
2544             }
2545         }
2546 
2547         return minimumUnit.toInt256();        
2548     }
2549 
2550     /**
2551      * Gets the total number of positions, defined as the following:
2552      * - Each component has a default position if its virtual unit is > 0
2553      * - Each component's external positions module is counted as a position
2554      */
2555     function _getPositionCount() internal view returns (uint256) {
2556         uint256 positionCount;
2557         for (uint256 i = 0; i < components.length; i++) {
2558             address component = components[i];
2559 
2560             // Increment the position count if the default position is > 0
2561             if (_defaultPositionVirtualUnit(component) > 0) {
2562                 positionCount++;
2563             }
2564 
2565             // Increment the position count by each external position module
2566             address[] memory externalModules = _externalPositionModules(component);
2567             if (externalModules.length > 0) {
2568                 positionCount = positionCount.add(externalModules.length);  
2569             }
2570         }
2571 
2572         return positionCount;
2573     }
2574 
2575     /**
2576      * Returns the absolute value of the signed integer value
2577      * @param _a Signed interger value
2578      * @return Returns the absolute value in uint256
2579      */
2580     function _absoluteValue(int256 _a) internal pure returns(uint256) {
2581         return _a >= 0 ? _a.toUint256() : (-_a).toUint256();
2582     }
2583 
2584     /**
2585      * Due to reason error bloat, internal functions are used to reduce bytecode size
2586      *
2587      * Module must be initialized on the SetToken and enabled by the controller
2588      */
2589     function _validateOnlyModule() internal view {
2590         require(
2591             moduleStates[msg.sender] == ISetToken.ModuleState.INITIALIZED,
2592             "Only the module can call"
2593         );
2594 
2595         require(
2596             controller.isModule(msg.sender),
2597             "Module must be enabled on controller"
2598         );
2599     }
2600 
2601     function _validateOnlyManager() internal view {
2602         require(msg.sender == manager, "Only manager can call");
2603     }
2604 
2605     function _validateWhenLockedOnlyLocker() internal view {
2606         if (isLocked) {
2607             require(msg.sender == locker, "When locked, only the locker can call");
2608         }
2609     }
2610 }