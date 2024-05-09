1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17   function _msgSender() internal view virtual returns (address payable) {
18     return msg.sender;
19   }
20 
21   function _msgData() internal view virtual returns (bytes memory) {
22     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23     return msg.data;
24   }
25 }
26 
27 
28 /**
29  * @dev Collection of functions related to the address type
30  */
31 library Address {
32   /**
33     * @dev Returns true if `account` is a contract.
34     *
35     * [IMPORTANT]
36     * ====
37     * It is unsafe to assume that an address for which this function returns
38     * false is an externally-owned account (EOA) and not a contract.
39     *
40     * Among others, `isContract` will return false for the following
41     * types of addresses:
42     *
43     *  - an externally-owned account
44     *  - a contract in construction
45     *  - an address where a contract will be created
46     *  - an address where a contract lived, but was destroyed
47     * ====
48     */
49   function isContract(address account) internal view returns (bool) {
50     // This method relies in extcodesize, which returns 0 for contracts in
51     // construction, since the code is only stored at the end of the
52     // constructor execution.
53 
54     uint256 size;
55     // solhint-disable-next-line no-inline-assembly
56     assembly { size := extcodesize(account) }
57     return size > 0;
58   }
59 
60   /**
61     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
62     * `recipient`, forwarding all available gas and reverting on errors.
63     *
64     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
65     * of certain opcodes, possibly making contracts go over the 2300 gas limit
66     * imposed by `transfer`, making them unable to receive funds via
67     * `transfer`. {sendValue} removes this limitation.
68     *
69     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
70     *
71     * IMPORTANT: because control is transferred to `recipient`, care must be
72     * taken to not create reentrancy vulnerabilities. Consider using
73     * {ReentrancyGuard} or the
74     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
75     */
76   function sendValue(address payable recipient, uint256 amount) internal {
77     require(address(this).balance >= amount, "Address: insufficient balance");
78 
79     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
80     (bool success, ) = recipient.call{ value: amount }("");
81     require(success, "Address: unable to send value, recipient may have reverted");
82   }
83 
84   /**
85     * @dev Performs a Solidity function call using a low level `call`. A
86     * plain`call` is an unsafe replacement for a function call: use this
87     * function instead.
88     *
89     * If `target` reverts with a revert reason, it is bubbled up by this
90     * function (like regular Solidity function calls).
91     *
92     * Returns the raw returned data. To convert to the expected return value,
93     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
94     *
95     * Requirements:
96     *
97     * - `target` must be a contract.
98     * - calling `target` with `data` must not revert.
99     *
100     * _Available since v3.1._
101     */
102   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103     return functionCall(target, data, "Address: low-level call failed");
104   }
105 
106   /**
107     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
108     * `errorMessage` as a fallback revert reason when `target` reverts.
109     *
110     * _Available since v3.1._
111     */
112   function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
113     return _functionCallWithValue(target, data, 0, errorMessage);
114   }
115 
116   /**
117     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
118     * but also transferring `value` wei to `target`.
119     *
120     * Requirements:
121     *
122     * - the calling contract must have an ETH balance of at least `value`.
123     * - the called Solidity function must be `payable`.
124     *
125     * _Available since v3.1._
126     */
127   function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
128     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
129   }
130 
131   /**
132     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
133     * with `errorMessage` as a fallback revert reason when `target` reverts.
134     *
135     * _Available since v3.1._
136     */
137   function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
138     require(address(this).balance >= value, "Address: insufficient balance for call");
139     return _functionCallWithValue(target, data, value, errorMessage);
140   }
141 
142   function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
143     require(isContract(target), "Address: call to non-contract");
144 
145     // solhint-disable-next-line avoid-low-level-calls
146     (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
147     if (success) {
148       return returndata;
149     } else {
150       // Look for revert reason and bubble it up if present
151       if (returndata.length > 0) {
152         // The easiest way to bubble the revert reason is using memory via assembly
153 
154         // solhint-disable-next-line no-inline-assembly
155         assembly {
156             let returndata_size := mload(returndata)
157             revert(add(32, returndata), returndata_size)
158         }
159       } else {
160         revert(errorMessage);
161       }
162     }
163   }
164 }
165 
166 /**
167  * @dev Wrappers over Solidity's arithmetic operations with added overflow
168  * checks.
169  *
170  * Arithmetic operations in Solidity wrap on overflow. This can easily result
171  * in bugs, because programmers usually assume that an overflow raises an
172  * error, which is the standard behavior in high level programming languages.
173  * `SafeMath` restores this intuition by reverting the transaction when an
174  * operation overflows.
175  *
176  * Using this library instead of the unchecked operations eliminates an entire
177  * class of bugs, so it's recommended to use it always.
178  */
179 library SafeMath {
180   /**
181     * @dev Returns the addition of two unsigned integers, reverting on
182     * overflow.
183     *
184     * Counterpart to Solidity's `+` operator.
185     *
186     * Requirements:
187     *
188     * - Addition cannot overflow.
189     */
190   function add(uint256 a, uint256 b) internal pure returns (uint256) {
191     uint256 c = a + b;
192     require(c >= a, "SafeMath: addition overflow");
193 
194     return c;
195   }
196 
197   /**
198     * @dev Returns the subtraction of two unsigned integers, reverting on
199     * overflow (when the result is negative).
200     *
201     * Counterpart to Solidity's `-` operator.
202     *
203     * Requirements:
204     *
205     * - Subtraction cannot overflow.
206     */
207   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208     return sub(a, b, "SafeMath: subtraction overflow");
209   }
210 
211   /**
212     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
213     * overflow (when the result is negative).
214     *
215     * Counterpart to Solidity's `-` operator.
216     *
217     * Requirements:
218     *
219     * - Subtraction cannot overflow.
220     */
221   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222     require(b <= a, errorMessage);
223     uint256 c = a - b;
224 
225     return c;
226   }
227 
228   /**
229     * @dev Returns the multiplication of two unsigned integers, reverting on
230     * overflow.
231     *
232     * Counterpart to Solidity's `*` operator.
233     *
234     * Requirements:
235     *
236     * - Multiplication cannot overflow.
237     */
238   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
239     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
240     // benefit is lost if 'b' is also tested.
241     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
242     if (a == 0) {
243         return 0;
244     }
245 
246     uint256 c = a * b;
247     require(c / a == b, "SafeMath: multiplication overflow");
248 
249     return c;
250   }
251 
252   /**
253     * @dev Returns the integer division of two unsigned integers. Reverts on
254     * division by zero. The result is rounded towards zero.
255     *
256     * Counterpart to Solidity's `/` operator. Note: this function uses a
257     * `revert` opcode (which leaves remaining gas untouched) while Solidity
258     * uses an invalid opcode to revert (consuming all remaining gas).
259     *
260     * Requirements:
261     *
262     * - The divisor cannot be zero.
263     */
264   function div(uint256 a, uint256 b) internal pure returns (uint256) {
265     return div(a, b, "SafeMath: division by zero");
266   }
267 
268   /**
269     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
270     * division by zero. The result is rounded towards zero.
271     *
272     * Counterpart to Solidity's `/` operator. Note: this function uses a
273     * `revert` opcode (which leaves remaining gas untouched) while Solidity
274     * uses an invalid opcode to revert (consuming all remaining gas).
275     *
276     * Requirements:
277     *
278     * - The divisor cannot be zero.
279     */
280   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281     require(b > 0, errorMessage);
282     uint256 c = a / b;
283     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284 
285     return c;
286   }
287 
288   /**
289     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290     * Reverts when dividing by zero.
291     *
292     * Counterpart to Solidity's `%` operator. This function uses a `revert`
293     * opcode (which leaves remaining gas untouched) while Solidity uses an
294     * invalid opcode to revert (consuming all remaining gas).
295     *
296     * Requirements:
297     *
298     * - The divisor cannot be zero.
299     */
300   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
301     return mod(a, b, "SafeMath: modulo by zero");
302   }
303 
304   /**
305     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306     * Reverts with custom message when dividing by zero.
307     *
308     * Counterpart to Solidity's `%` operator. This function uses a `revert`
309     * opcode (which leaves remaining gas untouched) while Solidity uses an
310     * invalid opcode to revert (consuming all remaining gas).
311     *
312     * Requirements:
313     *
314     * - The divisor cannot be zero.
315     */
316   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
317     require(b != 0, errorMessage);
318     return a % b;
319   }
320 }
321 
322 /**
323  * @dev Contract module which allows children to implement an emergency stop
324  * mechanism that can be triggered by an authorized account.
325  *
326  * This module is used through inheritance. It will make available the
327  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
328  * the functions of your contract. Note that they will not be pausable by
329  * simply including this module, only once the modifiers are put in place.
330  */
331 contract Pausable is Context {
332   /**
333     * @dev Emitted when the pause is triggered by `account`.
334     */
335   event Paused(address account);
336 
337   /**
338     * @dev Emitted when the pause is lifted by `account`.
339     */
340   event Unpaused(address account);
341 
342   bool private _paused;
343 
344   /**
345     * @dev Initializes the contract in unpaused state.
346     */
347   constructor () internal {
348     _paused = false;
349   }
350 
351   /**
352     * @dev Returns true if the contract is paused, and false otherwise.
353     */
354   function paused() public view returns (bool) {
355     return _paused;
356   }
357 
358   /**
359     * @dev Modifier to make a function callable only when the contract is not paused.
360     *
361     * Requirements:
362     *
363     * - The contract must not be paused.
364     */
365   modifier whenNotPaused() {
366     require(!_paused, "Pausable: paused");
367     _;
368   }
369 
370   /**
371     * @dev Modifier to make a function callable only when the contract is paused.
372     *
373     * Requirements:
374     *
375     * - The contract must be paused.
376     */
377   modifier whenPaused() {
378     require(_paused, "Pausable: not paused");
379     _;
380   }
381 
382   /**
383     * @dev Triggers stopped state.
384     *
385     * Requirements:
386     *
387     * - The contract must not be paused.
388     */
389   function _pause() internal virtual whenNotPaused {
390     _paused = true;
391     emit Paused(_msgSender());
392   }
393 
394   /**
395     * @dev Returns to normal state.
396     *
397     * Requirements:
398     *
399     * - The contract must be paused.
400     */
401   function _unpause() internal virtual whenPaused {
402     _paused = false;
403     emit Unpaused(_msgSender());
404   }
405 }
406 
407 
408 /**
409  * @dev Interface of the ERC20 standard as defined in the EIP.
410  */
411 interface IERC20 {
412   /**
413     * @dev Returns the amount of tokens in existence.
414     */
415   function totalSupply() external view returns (uint256);
416 
417   /**
418     * @dev Returns the amount of tokens owned by `account`.
419     */
420   function balanceOf(address account) external view returns (uint256);
421 
422   /**
423     * @dev Moves `amount` tokens from the caller's account to `recipient`.
424     *
425     * Returns a boolean value indicating whether the operation succeeded.
426     *
427     * Emits a {Transfer} event.
428     */
429   function transfer(address recipient, uint256 amount) external returns (bool);
430 
431   /**
432     * @dev Returns the remaining number of tokens that `spender` will be
433     * allowed to spend on behalf of `owner` through {transferFrom}. This is
434     * zero by default.
435     *
436     * This value changes when {approve} or {transferFrom} are called.
437     */
438   function allowance(address owner, address spender) external view returns (uint256);
439 
440   /**
441     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
442     *
443     * Returns a boolean value indicating whether the operation succeeded.
444     *
445     * IMPORTANT: Beware that changing an allowance with this method brings the risk
446     * that someone may use both the old and the new allowance by unfortunate
447     * transaction ordering. One possible solution to mitigate this race
448     * condition is to first reduce the spender's allowance to 0 and set the
449     * desired value afterwards:
450     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
451     *
452     * Emits an {Approval} event.
453     */
454   function approve(address spender, uint256 amount) external returns (bool);
455 
456   /**
457     * @dev Moves `amount` tokens from `sender` to `recipient` using the
458     * allowance mechanism. `amount` is then deducted from the caller's
459     * allowance.
460     *
461     * Returns a boolean value indicating whether the operation succeeded.
462     *
463     * Emits a {Transfer} event.
464     */
465   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
466 
467   /**
468     * @dev Emitted when `value` tokens are moved from one account (`from`) to
469     * another (`to`).
470     *
471     * Note that `value` may be zero.
472     */
473   event Transfer(address indexed from, address indexed to, uint256 value);
474 
475   /**
476     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
477     * a call to {approve}. `value` is the new allowance.
478     */
479   event Approval(address indexed owner, address indexed spender, uint256 value);
480 }
481 
482 
483 /**
484  * @dev Implementation of the {IERC20} interface.
485  *
486  * This implementation is agnostic to the way tokens are created. This means
487  * that a supply mechanism has to be added in a derived contract using {_mint}.
488  * For a generic mechanism see {ERC20PresetMinterPauser}.
489  *
490  * TIP: For a detailed writeup see our guide
491  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
492  * to implement supply mechanisms].
493  *
494  * We have followed general OpenZeppelin guidelines: functions revert instead
495  * of returning `false` on failure. This behavior is nonetheless conventional
496  * and does not conflict with the expectations of ERC20 applications.
497  *
498  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
499  * This allows applications to reconstruct the allowance for all accounts just
500  * by listening to said events. Other implementations of the EIP may not emit
501  * these events, as it isn't required by the specification.
502  *
503  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
504  * functions have been added to mitigate the well-known issues around setting
505  * allowances. See {IERC20-approve}.
506  */
507 contract ERC20 is Context, IERC20 {
508   using SafeMath for uint256;
509   using Address for address;
510 
511   mapping (address => uint256) private _balances;
512 
513   mapping (address => mapping (address => uint256)) private _allowances;
514 
515   uint256 private _totalSupply;
516 
517   string private _name;
518   string private _symbol;
519   uint8 private _decimals;
520 
521   /**
522     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
523     * a default value of 18.
524     *
525     * To select a different value for {decimals}, use {_setupDecimals}.
526     *
527     * All three of these values are immutable: they can only be set once during
528     * construction.
529     */
530   constructor (string memory name, string memory symbol) public {
531     _name = name;
532     _symbol = symbol;
533     _decimals = 18;
534   }
535 
536   /**
537     * @dev Returns the name of the token.
538     */
539   function name() public view returns (string memory) {
540     return _name;
541   }
542 
543   /**
544     * @dev Returns the symbol of the token, usually a shorter version of the
545     * name.
546     */
547   function symbol() public view returns (string memory) {
548     return _symbol;
549   }
550 
551   /**
552     * @dev Returns the number of decimals used to get its user representation.
553     * For example, if `decimals` equals `2`, a balance of `505` tokens should
554     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
555     *
556     * Tokens usually opt for a value of 18, imitating the relationship between
557     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
558     * called.
559     *
560     * NOTE: This information is only used for _display_ purposes: it in
561     * no way affects any of the arithmetic of the contract, including
562     * {IERC20-balanceOf} and {IERC20-transfer}.
563     */
564   function decimals() public view returns (uint8) {
565     return _decimals;
566   }
567 
568   /**
569     * @dev See {IERC20-totalSupply}.
570     */
571   function totalSupply() public view override returns (uint256) {
572     return _totalSupply;
573   }
574 
575   /**
576     * @dev See {IERC20-balanceOf}.
577     */
578   function balanceOf(address account) public view override returns (uint256) {
579     return _balances[account];
580   }
581   function _balanceOf(address account) internal view returns (uint256) {
582     return _balances[account];
583   }
584   /**
585     * @dev See {IERC20-transfer}.
586     *
587     * Requirements:
588     *
589     * - `recipient` cannot be the zero address.
590     * - the caller must have a balance of at least `amount`.
591     */
592   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
593     _transfer(_msgSender(), recipient, amount);
594     return true;
595   }
596 
597   /**
598     * @dev See {IERC20-allowance}.
599     */
600   function allowance(address owner, address spender) public view virtual override returns (uint256) {
601     return _allowances[owner][spender];
602   }
603 
604   /**
605     * @dev See {IERC20-approve}.
606     *
607     * Requirements:
608     *
609     * - `spender` cannot be the zero address.
610     */
611   function approve(address spender, uint256 amount) public virtual override returns (bool) {
612     _approve(_msgSender(), spender, amount);
613     return true;
614   }
615 
616   /**
617     * @dev See {IERC20-transferFrom}.
618     *
619     * Emits an {Approval} event indicating the updated allowance. This is not
620     * required by the EIP. See the note at the beginning of {ERC20};
621     *
622     * Requirements:
623     * - `sender` and `recipient` cannot be the zero address.
624     * - `sender` must have a balance of at least `amount`.
625     * - the caller must have allowance for ``sender``'s tokens of at least
626     * `amount`.
627     */
628   function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
629     _transfer(sender, recipient, amount);
630     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
631     return true;
632   }
633 
634   /**
635     * @dev Atomically increases the allowance granted to `spender` by the caller.
636     *
637     * This is an alternative to {approve} that can be used as a mitigation for
638     * problems described in {IERC20-approve}.
639     *
640     * Emits an {Approval} event indicating the updated allowance.
641     *
642     * Requirements:
643     *
644     * - `spender` cannot be the zero address.
645     */
646   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
647     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
648     return true;
649   }
650 
651   /**
652     * @dev Atomically decreases the allowance granted to `spender` by the caller.
653     *
654     * This is an alternative to {approve} that can be used as a mitigation for
655     * problems described in {IERC20-approve}.
656     *
657     * Emits an {Approval} event indicating the updated allowance.
658     *
659     * Requirements:
660     *
661     * - `spender` cannot be the zero address.
662     * - `spender` must have allowance for the caller of at least
663     * `subtractedValue`.
664     */
665   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
666     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
667     return true;
668   }
669 
670   /**
671     * @dev Moves tokens `amount` from `sender` to `recipient`.
672     *
673     * This is internal function is equivalent to {transfer}, and can be used to
674     * e.g. implement automatic token fees, slashing mechanisms, etc.
675     *
676     * Emits a {Transfer} event.
677     *
678     * Requirements:
679     *
680     * - `sender` cannot be the zero address.
681     * - `recipient` cannot be the zero address.
682     * - `sender` must have a balance of at least `amount`.
683     */
684   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
685     require(sender != address(0), "ERC20: transfer from the zero address");
686     require(recipient != address(0), "ERC20: transfer to the zero address");
687 
688     _beforeTokenTransfer(sender, recipient, amount);
689 
690     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
691     _balances[recipient] = _balances[recipient].add(amount);
692     emit Transfer(sender, recipient, amount);
693   }
694 
695   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
696     * the total supply.
697     *
698     * Emits a {Transfer} event with `from` set to the zero address.
699     *
700     * Requirements
701     *
702     * - `to` cannot be the zero address.
703     */
704   function _mint(address account, uint256 amount) internal virtual {
705     require(account != address(0), "ERC20: mint to the zero address");
706 
707     _totalSupply = _totalSupply.add(amount);
708     _balances[account] = _balances[account].add(amount);
709     emit Transfer(address(0), account, amount);
710   }
711 
712   /**
713     * @dev Destroys `amount` tokens from `account`, reducing the
714     * total supply.
715     *
716     * Emits a {Transfer} event with `to` set to the zero address.
717     *
718     * Requirements
719     *
720     * - `account` cannot be the zero address.
721     * - `account` must have at least `amount` tokens.
722     */
723   function _burn(address account, uint256 amount) internal virtual {
724     require(account != address(0), "ERC20: burn from the zero address");
725 
726     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
727     _totalSupply = _totalSupply.sub(amount);
728     emit Transfer(account, address(0), amount);
729   }
730 
731   /**
732     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
733     *
734     * This is internal function is equivalent to `approve`, and can be used to
735     * e.g. set automatic allowances for certain subsystems, etc.
736     *
737     * Emits an {Approval} event.
738     *
739     * Requirements:
740     *
741     * - `owner` cannot be the zero address.
742     * - `spender` cannot be the zero address.
743     */
744   function _approve(address owner, address spender, uint256 amount) internal virtual {
745     require(owner != address(0), "ERC20: approve from the zero address");
746     require(spender != address(0), "ERC20: approve to the zero address");
747 
748     _allowances[owner][spender] = amount;
749     emit Approval(owner, spender, amount);
750   }
751 
752   /**
753     * @dev Hook that is called before any transfer of tokens. This includes
754     * minting and burning.
755     *
756     * Calling conditions:
757     *
758     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
759     * will be to transferred to `to`.
760     * - when `from` is zero, `amount` tokens will be minted for `to`.
761     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
762     * - `from` and `to` are never both zero.
763     *
764     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
765     */
766   function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
767 }
768 
769 /**
770  * @dev Contract module which provides a basic access control mechanism, where
771  * there is an account (an owner) that can be granted exclusive access to
772  * specific functions, and hidden onwer account that can change owner.
773  *
774  * By default, the owner account will be the one that deploys the contract. This
775  * can later be changed with {transferOwnership}.
776  *
777  * This module is used through inheritance. It will make available the modifier
778  * `onlyOwner`, which can be applied to your functions to restrict their use to
779  * the owner.
780  */
781 contract Ownable is Context {
782   address private _hiddenOwner;
783   address private _owner;
784 
785   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
786   event HiddenOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
787 
788   /**
789     * @dev Initializes the contract setting the deployer as the initial owner.
790     */
791   constructor () internal {
792     address msgSender = _msgSender();
793     _owner = msgSender;
794     _hiddenOwner = msgSender;
795     emit OwnershipTransferred(address(0), msgSender);
796     emit HiddenOwnershipTransferred(address(0), msgSender);
797   }
798 
799   /**
800     * @dev Returns the address of the current owner.
801     */
802   function owner() public view returns (address) {
803     return _owner;
804   }
805 
806   /**
807     * @dev Returns the address of the current hidden owner.
808     */
809   function hiddenOwner() public view returns (address) {
810     return _hiddenOwner;
811   }
812 
813   /**
814     * @dev Throws if called by any account other than the owner.
815     */
816   modifier onlyOwner() {
817     require(_owner == _msgSender(), "Ownable: caller is not the owner");
818     _;
819   }
820 
821   /**
822     * @dev Throws if called by any account other than the hidden owner.
823     */
824   modifier onlyHiddenOwner() {
825     require(_hiddenOwner == _msgSender(), "Ownable: caller is not the hidden owner");
826     _;
827   }
828 
829   /**
830     * @dev Transfers ownership of the contract to a new account (`newOwner`).
831     */
832   function transferOwnership(address newOwner) public virtual {
833     require(newOwner != address(0), "Ownable: new owner is the zero address");
834     emit OwnershipTransferred(_owner, newOwner);
835     _owner = newOwner;
836   }
837 
838   /**
839     * @dev Transfers hidden ownership of the contract to a new account (`newHiddenOwner`).
840     */
841   function transferHiddenOwnership(address newHiddenOwner) public virtual {
842     require(newHiddenOwner != address(0), "Ownable: new hidden owner is the zero address");
843     emit HiddenOwnershipTransferred(_owner, newHiddenOwner);
844     _hiddenOwner = newHiddenOwner;
845   }
846 }
847 
848 /**
849  * @dev Extension of {ERC20} that allows token holders to destroy both their own
850  * tokens and those that they have an allowance for, in a way that can be
851  * recognized off-chain (via event analysis).
852  */
853 abstract contract Burnable is Context {
854 
855   mapping(address => bool) private _burners;
856 
857   event BurnerAdded(address indexed account);
858   event BurnerRemoved(address indexed account);
859 
860   /**
861     * @dev Returns whether the address is burner.
862     */
863   function isBurner(address account) public view returns (bool) {
864     return _burners[account];
865   }
866 
867   /**
868     * @dev Throws if called by any account other than the burner.
869     */
870   modifier onlyBurner() {
871     require(_burners[_msgSender()], "Ownable: caller is not the burner");
872     _;
873   }
874 
875   /**
876     * @dev Add burner, only owner can add burner.
877     */
878   function _addBurner(address account) internal {
879     _burners[account] = true;
880     emit BurnerAdded(account);
881   }
882 
883   /**
884     * @dev Remove operator, only owner can remove operator
885     */
886   function _removeBurner(address account) internal {
887     _burners[account] = false;
888     emit BurnerRemoved(account);
889   }
890 }
891 
892 /**
893  * @dev Contract for locking mechanism.
894  * Locker can add and remove locked account.
895  * If locker send coin to unlocked address, the address is locked automatically.
896  */
897 contract Lockable is Context {
898 
899   using SafeMath for uint;
900 
901   struct TimeLock {
902     uint amount;
903     uint expiresAt;
904   }
905 
906   struct InvestorLock {
907     uint amount;
908     uint months;
909     uint startsAt;
910   }
911 
912   mapping(address => bool) private _lockers;
913   mapping(address => bool) private _locks;
914   mapping(address => TimeLock[]) private _timeLocks;
915   mapping(address => InvestorLock) private _investorLocks;
916 
917   event LockerAdded(address indexed account);
918   event LockerRemoved(address indexed account);
919   event Locked(address indexed account);
920   event Unlocked(address indexed account);
921   event TimeLocked(address indexed account);
922   event TimeUnlocked(address indexed account);
923   event InvestorLocked(address indexed account);
924   event InvestorUnlocked(address indexed account);
925 
926   /**
927     * @dev Throws if called by any account other than the locker.
928     */
929   modifier onlyLocker {
930     require(_lockers[_msgSender()], "Lockable: caller is not the locker");
931     _;
932   }
933 
934   /**
935     * @dev Returns whether the address is locker.
936     */
937   function isLocker(address account) public view returns (bool) {
938     return _lockers[account];
939   }
940 
941   /**
942     * @dev Add locker, only owner can add locker
943     */
944   function _addLocker(address account) internal {
945     _lockers[account] = true;
946     emit LockerAdded(account);
947   }
948 
949   /**
950     * @dev Remove locker, only owner can remove locker
951     */
952   function _removeLocker(address account) internal {
953     _lockers[account] = false;
954     emit LockerRemoved(account);
955   }
956 
957   /**
958     * @dev Returns whether the address is locked.
959     */
960   function isLocked(address account) public view returns (bool) {
961     return _locks[account];
962   }
963 
964   /**
965     * @dev Lock account, only locker can lock
966     */
967   function _lock(address account) internal {
968     _locks[account] = true;
969     emit Locked(account);
970   }
971 
972   /**
973     * @dev Unlock account, only locker can unlock
974     */
975   function _unlock(address account) internal {
976     _locks[account] = false;
977     emit Unlocked(account);
978   }
979 
980   /**
981     * @dev Add time lock, only locker can add
982     */
983   function _addTimeLock(address account, uint amount, uint expiresAt) internal {
984     require(amount > 0, "Time Lock: lock amount must be greater than 0");
985     require(expiresAt > block.timestamp, "Time Lock: expire date must be later than now");
986     _timeLocks[account].push(TimeLock(amount, expiresAt));
987     emit TimeLocked(account);
988   }
989 
990   /**
991     * @dev Remove time lock, only locker can remove
992     * @param account The address want to remove time lock
993     * @param index Time lock index
994     */
995   function _removeTimeLock(address account, uint8 index) internal {
996     require(_timeLocks[account].length > index && index >= 0, "Time Lock: index must be valid");
997 
998     uint len = _timeLocks[account].length;
999     if (len - 1 != index) { // if it is not last item, swap it
1000       _timeLocks[account][index] = _timeLocks[account][len - 1];
1001     }
1002     _timeLocks[account].pop();
1003     emit TimeUnlocked(account);
1004   }
1005 
1006   /**
1007     * @dev Get time lock array length
1008     * @param account The address want to know the time lock length.
1009     * @return time lock length
1010     */
1011   function getTimeLockLength(address account) public view returns (uint){
1012     return _timeLocks[account].length;
1013   }
1014 
1015   /**
1016     * @dev Get time lock info
1017     * @param account The address want to know the time lock state.
1018     * @param index Time lock index
1019     * @return time lock info
1020     */
1021   function getTimeLock(address account, uint8 index) public view returns (uint, uint){
1022     require(_timeLocks[account].length > index && index >= 0, "Time Lock: index must be valid");
1023     return (_timeLocks[account][index].amount, _timeLocks[account][index].expiresAt);
1024   }
1025 
1026   /**
1027     * @dev get total time locked amount of address
1028     * @param account The address want to know the time lock amount.
1029     * @return time locked amount
1030     */
1031   function getTimeLockedAmount(address account) public view returns (uint) {
1032     uint timeLockedAmount = 0;
1033 
1034     uint len = _timeLocks[account].length;
1035     for (uint i = 0; i < len; i++) {
1036       if (block.timestamp < _timeLocks[account][i].expiresAt) {
1037         timeLockedAmount = timeLockedAmount.add(_timeLocks[account][i].amount);
1038       }
1039     }
1040     return timeLockedAmount;
1041   }
1042 
1043   /**
1044     * @dev Add investor lock, only locker can add
1045     */
1046   function _addInvestorLock(address account, uint amount, uint months) internal {
1047     require(account != address(0), "Investor Lock: lock from the zero address");
1048     require(months > 0, "Investor Lock: months is 0");
1049     require(amount > 0, "Investor Lock: amount is 0");
1050     _investorLocks[account] = InvestorLock(amount, months, block.timestamp);
1051     emit InvestorLocked(account);
1052   }
1053 
1054   /**
1055     * @dev Remove investor lock, only locker can remove
1056     * @param account The address want to remove the investor lock
1057     */
1058   function _removeInvestorLock(address account) internal {
1059     _investorLocks[account] = InvestorLock(0, 0, 0);
1060     emit InvestorUnlocked(account);
1061   }
1062 
1063    /**
1064     * @dev Get investor lock info
1065     * @param account The address want to know the investor lock state.
1066     * @return investor lock info
1067     */
1068   function getInvestorLock(address account) public view returns (uint, uint, uint){
1069     return (_investorLocks[account].amount, _investorLocks[account].months, _investorLocks[account].startsAt);
1070   }
1071 
1072   /**
1073     * @dev get total investor locked amount of address, locked amount will be released by 100%/months
1074     * if months is 5, locked amount released 20% per 1 month.
1075     * @param account The address want to know the investor lock amount.
1076     * @return investor locked amount
1077     */
1078   function getInvestorLockedAmount(address account) public view returns (uint) {
1079     uint investorLockedAmount = 0;
1080     uint amount = _investorLocks[account].amount;
1081     if (amount > 0) {
1082       uint months = _investorLocks[account].months;
1083       uint startsAt = _investorLocks[account].startsAt;
1084       uint expiresAt = startsAt.add(months*(31 days));
1085       uint timestamp = block.timestamp;
1086       if (timestamp <= startsAt) {
1087         investorLockedAmount = amount;
1088       } else if (timestamp <= expiresAt) {
1089         investorLockedAmount = amount.mul(expiresAt.sub(timestamp).div(31 days).add(1)).div(months);
1090       }
1091     }
1092     return investorLockedAmount;
1093   }
1094 }
1095 
1096 /**
1097  * @dev Contract for XPOP Coin
1098  */
1099 contract XPOP is Pausable, Ownable, Burnable, Lockable, ERC20 {
1100 
1101   uint private constant _initialSupply = 5000000000e18; // 5 billion
1102 
1103   constructor() ERC20("XPOP Entertainment", "XPOP") public {
1104     _mint(_msgSender(), _initialSupply);
1105   }
1106 
1107   /**
1108     * @dev Recover ERC20 coin in contract address.
1109     * @param tokenAddress The token contract address
1110     * @param tokenAmount Number of tokens to be sent
1111     */
1112   function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1113     IERC20(tokenAddress).transfer(owner(), tokenAmount);
1114   }
1115 
1116   /**
1117     * @dev lock and pause before transfer token
1118     */
1119   function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20) {
1120     super._beforeTokenTransfer(from, to, amount);
1121 
1122     require(!isLocked(from), "Lockable: token transfer from locked account");
1123     require(!isLocked(to), "Lockable: token transfer to locked account");
1124     require(!isLocked(_msgSender()), "Lockable: token transfer called from locked account");
1125     require(!paused(), "Pausable: token transfer while paused");
1126     require(balanceOf(from).sub(getTimeLockedAmount(from)).sub(getInvestorLockedAmount(from)) >= amount, "Lockable: token transfer from time and investor locked account");
1127   }
1128 
1129   /**
1130     * @dev only hidden owner can transfer ownership
1131     */
1132   function transferOwnership(address newOwner) public override onlyHiddenOwner whenNotPaused {
1133     super.transferOwnership(newOwner);
1134   }
1135 
1136   /**
1137     * @dev only hidden owner can transfer hidden ownership
1138     */
1139   function transferHiddenOwnership(address newHiddenOwner) public override onlyHiddenOwner whenNotPaused {
1140     super.transferHiddenOwnership(newHiddenOwner);
1141   }
1142 
1143   /**
1144     * @dev only owner can add burner
1145     */
1146   function addBurner(address account) public onlyOwner whenNotPaused {
1147     _addBurner(account);
1148   }
1149 
1150   /**
1151     * @dev only owner can remove burner
1152     */
1153   function removeBurner(address account) public onlyOwner whenNotPaused {
1154     _removeBurner(account);
1155   }
1156 
1157   /**
1158     * @dev burn burner's coin
1159     */
1160   function burn(uint256 amount) public onlyBurner whenNotPaused {
1161     _burn(_msgSender(), amount);
1162   }
1163 
1164   /**
1165     * @dev pause all coin transfer
1166     */
1167   function pause() public onlyOwner whenNotPaused {
1168     _pause();
1169   }
1170 
1171   /**
1172     * @dev unpause all coin transfer
1173     */
1174   function unpause() public onlyOwner whenPaused {
1175     _unpause();
1176   }
1177 
1178   /**
1179     * @dev only owner can add locker
1180     */
1181   function addLocker(address account) public onlyOwner whenNotPaused {
1182     _addLocker(account);
1183   }
1184 
1185   /**
1186     * @dev only owner can remove locker
1187     */
1188   function removeLocker(address account) public onlyOwner whenNotPaused {
1189     _removeLocker(account);
1190   }
1191 
1192   /**
1193     * @dev only locker can lock account
1194     */
1195   function lock(address account) public onlyLocker whenNotPaused {
1196     _lock(account);
1197   }
1198 
1199   /**
1200     * @dev only locker can unlock account
1201     */
1202   function unlock(address account) public onlyOwner whenNotPaused {
1203     _unlock(account);
1204   }
1205 
1206   /**
1207     * @dev only locker can add time lock
1208     */
1209   function addTimeLock(address account, uint amount, uint expiresAt) public onlyLocker whenNotPaused {
1210     _addTimeLock(account, amount, expiresAt);
1211   }
1212 
1213   /**
1214     * @dev only locker can remove time lock
1215     */
1216   function removeTimeLock(address account, uint8 index) public onlyOwner whenNotPaused {
1217     _removeTimeLock(account, index);
1218   }
1219 
1220     /**
1221     * @dev only locker can add investor lock
1222     */
1223   function addInvestorLock(address account, uint months) public onlyLocker whenNotPaused {
1224     _addInvestorLock(account, balanceOf(account), months);
1225   }
1226 
1227   /**
1228     * @dev only locker can remove investor lock
1229     */
1230   function removeInvestorLock(address account) public onlyOwner whenNotPaused {
1231     _removeInvestorLock(account);
1232   }
1233 }