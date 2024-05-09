1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
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
16   function _msgSender() internal virtual view returns (address payable) {
17     return msg.sender;
18   }
19 
20   function _msgData() internal virtual view returns (bytes memory) {
21     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22     return msg.data;
23   }
24 }
25 
26 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
27 
28 pragma solidity ^0.6.0;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34   /**
35    * @dev Returns the amount of tokens in existence.
36    */
37   function totalSupply() external view returns (uint256);
38 
39   /**
40    * @dev Returns the amount of tokens owned by `account`.
41    */
42   function balanceOf(address account) external view returns (uint256);
43 
44   /**
45    * @dev Moves `amount` tokens from the caller's account to `recipient`.
46    *
47    * Returns a boolean value indicating whether the operation succeeded.
48    *
49    * Emits a {Transfer} event.
50    */
51   function transfer(address recipient, uint256 amount) external returns (bool);
52 
53   /**
54    * @dev Returns the remaining number of tokens that `spender` will be
55    * allowed to spend on behalf of `owner` through {transferFrom}. This is
56    * zero by default.
57    *
58    * This value changes when {approve} or {transferFrom} are called.
59    */
60   function allowance(address owner, address spender)
61     external
62     view
63     returns (uint256);
64 
65   /**
66    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67    *
68    * Returns a boolean value indicating whether the operation succeeded.
69    *
70    * IMPORTANT: Beware that changing an allowance with this method brings the risk
71    * that someone may use both the old and the new allowance by unfortunate
72    * transaction ordering. One possible solution to mitigate this race
73    * condition is to first reduce the spender's allowance to 0 and set the
74    * desired value afterwards:
75    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76    *
77    * Emits an {Approval} event.
78    */
79   function approve(address spender, uint256 amount) external returns (bool);
80 
81   /**
82    * @dev Moves `amount` tokens from `sender` to `recipient` using the
83    * allowance mechanism. `amount` is then deducted from the caller's
84    * allowance.
85    *
86    * Returns a boolean value indicating whether the operation succeeded.
87    *
88    * Emits a {Transfer} event.
89    */
90   function transferFrom(
91     address sender,
92     address recipient,
93     uint256 amount
94   ) external returns (bool);
95 
96   /**
97    * @dev Emitted when `value` tokens are moved from one account (`from`) to
98    * another (`to`).
99    *
100    * Note that `value` may be zero.
101    */
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 
104   /**
105    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106    * a call to {approve}. `value` is the new allowance.
107    */
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
112 
113 pragma solidity ^0.6.0;
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129   /**
130    * @dev Returns the addition of two unsigned integers, reverting on
131    * overflow.
132    *
133    * Counterpart to Solidity's `+` operator.
134    *
135    * Requirements:
136    *
137    * - Addition cannot overflow.
138    */
139   function add(uint256 a, uint256 b) internal pure returns (uint256) {
140     uint256 c = a + b;
141     require(c >= a, 'SafeMath: addition overflow');
142 
143     return c;
144   }
145 
146   /**
147    * @dev Returns the subtraction of two unsigned integers, reverting on
148    * overflow (when the result is negative).
149    *
150    * Counterpart to Solidity's `-` operator.
151    *
152    * Requirements:
153    *
154    * - Subtraction cannot overflow.
155    */
156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157     return sub(a, b, 'SafeMath: subtraction overflow');
158   }
159 
160   /**
161    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162    * overflow (when the result is negative).
163    *
164    * Counterpart to Solidity's `-` operator.
165    *
166    * Requirements:
167    *
168    * - Subtraction cannot overflow.
169    */
170   function sub(
171     uint256 a,
172     uint256 b,
173     string memory errorMessage
174   ) internal pure returns (uint256) {
175     require(b <= a, errorMessage);
176     uint256 c = a - b;
177 
178     return c;
179   }
180 
181   /**
182    * @dev Returns the multiplication of two unsigned integers, reverting on
183    * overflow.
184    *
185    * Counterpart to Solidity's `*` operator.
186    *
187    * Requirements:
188    *
189    * - Multiplication cannot overflow.
190    */
191   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193     // benefit is lost if 'b' is also tested.
194     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195     if (a == 0) {
196       return 0;
197     }
198 
199     uint256 c = a * b;
200     require(c / a == b, 'SafeMath: multiplication overflow');
201 
202     return c;
203   }
204 
205   /**
206    * @dev Returns the integer division of two unsigned integers. Reverts on
207    * division by zero. The result is rounded towards zero.
208    *
209    * Counterpart to Solidity's `/` operator. Note: this function uses a
210    * `revert` opcode (which leaves remaining gas untouched) while Solidity
211    * uses an invalid opcode to revert (consuming all remaining gas).
212    *
213    * Requirements:
214    *
215    * - The divisor cannot be zero.
216    */
217   function div(uint256 a, uint256 b) internal pure returns (uint256) {
218     return div(a, b, 'SafeMath: division by zero');
219   }
220 
221   /**
222    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223    * division by zero. The result is rounded towards zero.
224    *
225    * Counterpart to Solidity's `/` operator. Note: this function uses a
226    * `revert` opcode (which leaves remaining gas untouched) while Solidity
227    * uses an invalid opcode to revert (consuming all remaining gas).
228    *
229    * Requirements:
230    *
231    * - The divisor cannot be zero.
232    */
233   function div(
234     uint256 a,
235     uint256 b,
236     string memory errorMessage
237   ) internal pure returns (uint256) {
238     require(b > 0, errorMessage);
239     uint256 c = a / b;
240     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242     return c;
243   }
244 
245   /**
246    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247    * Reverts when dividing by zero.
248    *
249    * Counterpart to Solidity's `%` operator. This function uses a `revert`
250    * opcode (which leaves remaining gas untouched) while Solidity uses an
251    * invalid opcode to revert (consuming all remaining gas).
252    *
253    * Requirements:
254    *
255    * - The divisor cannot be zero.
256    */
257   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258     return mod(a, b, 'SafeMath: modulo by zero');
259   }
260 
261   /**
262    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263    * Reverts with custom message when dividing by zero.
264    *
265    * Counterpart to Solidity's `%` operator. This function uses a `revert`
266    * opcode (which leaves remaining gas untouched) while Solidity uses an
267    * invalid opcode to revert (consuming all remaining gas).
268    *
269    * Requirements:
270    *
271    * - The divisor cannot be zero.
272    */
273   function mod(
274     uint256 a,
275     uint256 b,
276     string memory errorMessage
277   ) internal pure returns (uint256) {
278     require(b != 0, errorMessage);
279     return a % b;
280   }
281 }
282 
283 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
284 
285 pragma solidity ^0.6.2;
286 
287 /**
288  * @dev Collection of functions related to the address type
289  */
290 library Address {
291   /**
292    * @dev Returns true if `account` is a contract.
293    *
294    * [IMPORTANT]
295    * ====
296    * It is unsafe to assume that an address for which this function returns
297    * false is an externally-owned account (EOA) and not a contract.
298    *
299    * Among others, `isContract` will return false for the following
300    * types of addresses:
301    *
302    *  - an externally-owned account
303    *  - a contract in construction
304    *  - an address where a contract will be created
305    *  - an address where a contract lived, but was destroyed
306    * ====
307    */
308   function isContract(address account) internal view returns (bool) {
309     // This method relies in extcodesize, which returns 0 for contracts in
310     // construction, since the code is only stored at the end of the
311     // constructor execution.
312 
313     uint256 size;
314     // solhint-disable-next-line no-inline-assembly
315     assembly {
316       size := extcodesize(account)
317     }
318     return size > 0;
319   }
320 
321   /**
322    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
323    * `recipient`, forwarding all available gas and reverting on errors.
324    *
325    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
326    * of certain opcodes, possibly making contracts go over the 2300 gas limit
327    * imposed by `transfer`, making them unable to receive funds via
328    * `transfer`. {sendValue} removes this limitation.
329    *
330    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
331    *
332    * IMPORTANT: because control is transferred to `recipient`, care must be
333    * taken to not create reentrancy vulnerabilities. Consider using
334    * {ReentrancyGuard} or the
335    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
336    */
337   function sendValue(address payable recipient, uint256 amount) internal {
338     require(address(this).balance >= amount, 'Address: insufficient balance');
339 
340     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
341     (bool success, ) = recipient.call{value: amount}('');
342     require(
343       success,
344       'Address: unable to send value, recipient may have reverted'
345     );
346   }
347 
348   /**
349    * @dev Performs a Solidity function call using a low level `call`. A
350    * plain`call` is an unsafe replacement for a function call: use this
351    * function instead.
352    *
353    * If `target` reverts with a revert reason, it is bubbled up by this
354    * function (like regular Solidity function calls).
355    *
356    * Returns the raw returned data. To convert to the expected return value,
357    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
358    *
359    * Requirements:
360    *
361    * - `target` must be a contract.
362    * - calling `target` with `data` must not revert.
363    *
364    * _Available since v3.1._
365    */
366   function functionCall(address target, bytes memory data)
367     internal
368     returns (bytes memory)
369   {
370     return functionCall(target, data, 'Address: low-level call failed');
371   }
372 
373   /**
374    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375    * `errorMessage` as a fallback revert reason when `target` reverts.
376    *
377    * _Available since v3.1._
378    */
379   function functionCall(
380     address target,
381     bytes memory data,
382     string memory errorMessage
383   ) internal returns (bytes memory) {
384     return _functionCallWithValue(target, data, 0, errorMessage);
385   }
386 
387   /**
388    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389    * but also transferring `value` wei to `target`.
390    *
391    * Requirements:
392    *
393    * - the calling contract must have an ETH balance of at least `value`.
394    * - the called Solidity function must be `payable`.
395    *
396    * _Available since v3.1._
397    */
398   function functionCallWithValue(
399     address target,
400     bytes memory data,
401     uint256 value
402   ) internal returns (bytes memory) {
403     return
404       functionCallWithValue(
405         target,
406         data,
407         value,
408         'Address: low-level call with value failed'
409       );
410   }
411 
412   /**
413    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414    * with `errorMessage` as a fallback revert reason when `target` reverts.
415    *
416    * _Available since v3.1._
417    */
418   function functionCallWithValue(
419     address target,
420     bytes memory data,
421     uint256 value,
422     string memory errorMessage
423   ) internal returns (bytes memory) {
424     require(
425       address(this).balance >= value,
426       'Address: insufficient balance for call'
427     );
428     return _functionCallWithValue(target, data, value, errorMessage);
429   }
430 
431   function _functionCallWithValue(
432     address target,
433     bytes memory data,
434     uint256 weiValue,
435     string memory errorMessage
436   ) private returns (bytes memory) {
437     require(isContract(target), 'Address: call to non-contract');
438 
439     // solhint-disable-next-line avoid-low-level-calls
440     (bool success, bytes memory returndata) = target.call{value: weiValue}(
441       data
442     );
443     if (success) {
444       return returndata;
445     } else {
446       // Look for revert reason and bubble it up if present
447       if (returndata.length > 0) {
448         // The easiest way to bubble the revert reason is using memory via assembly
449 
450         // solhint-disable-next-line no-inline-assembly
451         assembly {
452           let returndata_size := mload(returndata)
453           revert(add(32, returndata), returndata_size)
454         }
455       } else {
456         revert(errorMessage);
457       }
458     }
459   }
460 }
461 
462 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
463 
464 pragma solidity ^0.6.0;
465 
466 /**
467  * @dev Implementation of the {IERC20} interface.
468  *
469  * This implementation is agnostic to the way tokens are created. This means
470  * that a supply mechanism has to be added in a derived contract using {_mint}.
471  * For a generic mechanism see {ERC20PresetMinterPauser}.
472  *
473  * TIP: For a detailed writeup see our guide
474  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
475  * to implement supply mechanisms].
476  *
477  * We have followed general OpenZeppelin guidelines: functions revert instead
478  * of returning `false` on failure. This behavior is nonetheless conventional
479  * and does not conflict with the expectations of ERC20 applications.
480  *
481  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
482  * This allows applications to reconstruct the allowance for all accounts just
483  * by listening to said events. Other implementations of the EIP may not emit
484  * these events, as it isn't required by the specification.
485  *
486  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
487  * functions have been added to mitigate the well-known issues around setting
488  * allowances. See {IERC20-approve}.
489  */
490 contract ERC20 is Context, IERC20 {
491   using SafeMath for uint256;
492   using Address for address;
493 
494   mapping(address => uint256) private _balances;
495 
496   mapping(address => mapping(address => uint256)) private _allowances;
497 
498   uint256 private _totalSupply;
499 
500   string private _name;
501   string private _symbol;
502   uint8 private _decimals;
503 
504   /**
505    * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
506    * a default value of 18.
507    *
508    * To select a different value for {decimals}, use {_setupDecimals}.
509    *
510    * All three of these values are immutable: they can only be set once during
511    * construction.
512    */
513   constructor(string memory name, string memory symbol) public {
514     _name = name;
515     _symbol = symbol;
516     _decimals = 18;
517   }
518 
519   /**
520    * @dev Returns the name of the token.
521    */
522   function name() public view returns (string memory) {
523     return _name;
524   }
525 
526   /**
527    * @dev Returns the symbol of the token, usually a shorter version of the
528    * name.
529    */
530   function symbol() public view returns (string memory) {
531     return _symbol;
532   }
533 
534   /**
535    * @dev Returns the number of decimals used to get its user representation.
536    * For example, if `decimals` equals `2`, a balance of `505` tokens should
537    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
538    *
539    * Tokens usually opt for a value of 18, imitating the relationship between
540    * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
541    * called.
542    *
543    * NOTE: This information is only used for _display_ purposes: it in
544    * no way affects any of the arithmetic of the contract, including
545    * {IERC20-balanceOf} and {IERC20-transfer}.
546    */
547   function decimals() public view returns (uint8) {
548     return _decimals;
549   }
550 
551   /**
552    * @dev See {IERC20-totalSupply}.
553    */
554   function totalSupply() public override view returns (uint256) {
555     return _totalSupply;
556   }
557 
558   /**
559    * @dev See {IERC20-balanceOf}.
560    */
561   function balanceOf(address account) public override view returns (uint256) {
562     return _balances[account];
563   }
564 
565   /**
566    * @dev See {IERC20-transfer}.
567    *
568    * Requirements:
569    *
570    * - `recipient` cannot be the zero address.
571    * - the caller must have a balance of at least `amount`.
572    */
573   function transfer(address recipient, uint256 amount)
574     public
575     virtual
576     override
577     returns (bool)
578   {
579     _transfer(_msgSender(), recipient, amount);
580     return true;
581   }
582 
583   /**
584    * @dev See {IERC20-allowance}.
585    */
586   function allowance(address owner, address spender)
587     public
588     virtual
589     override
590     view
591     returns (uint256)
592   {
593     return _allowances[owner][spender];
594   }
595 
596   /**
597    * @dev See {IERC20-approve}.
598    *
599    * Requirements:
600    *
601    * - `spender` cannot be the zero address.
602    */
603   function approve(address spender, uint256 amount)
604     public
605     virtual
606     override
607     returns (bool)
608   {
609     _approve(_msgSender(), spender, amount);
610     return true;
611   }
612 
613   /**
614    * @dev See {IERC20-transferFrom}.
615    *
616    * Emits an {Approval} event indicating the updated allowance. This is not
617    * required by the EIP. See the note at the beginning of {ERC20};
618    *
619    * Requirements:
620    * - `sender` and `recipient` cannot be the zero address.
621    * - `sender` must have a balance of at least `amount`.
622    * - the caller must have allowance for ``sender``'s tokens of at least
623    * `amount`.
624    */
625   function transferFrom(
626     address sender,
627     address recipient,
628     uint256 amount
629   ) public virtual override returns (bool) {
630     _transfer(sender, recipient, amount);
631     _approve(
632       sender,
633       _msgSender(),
634       _allowances[sender][_msgSender()].sub(
635         amount,
636         'ERC20: transfer amount exceeds allowance'
637       )
638     );
639     return true;
640   }
641 
642   /**
643    * @dev Atomically increases the allowance granted to `spender` by the caller.
644    *
645    * This is an alternative to {approve} that can be used as a mitigation for
646    * problems described in {IERC20-approve}.
647    *
648    * Emits an {Approval} event indicating the updated allowance.
649    *
650    * Requirements:
651    *
652    * - `spender` cannot be the zero address.
653    */
654   function increaseAllowance(address spender, uint256 addedValue)
655     public
656     virtual
657     returns (bool)
658   {
659     _approve(
660       _msgSender(),
661       spender,
662       _allowances[_msgSender()][spender].add(addedValue)
663     );
664     return true;
665   }
666 
667   /**
668    * @dev Atomically decreases the allowance granted to `spender` by the caller.
669    *
670    * This is an alternative to {approve} that can be used as a mitigation for
671    * problems described in {IERC20-approve}.
672    *
673    * Emits an {Approval} event indicating the updated allowance.
674    *
675    * Requirements:
676    *
677    * - `spender` cannot be the zero address.
678    * - `spender` must have allowance for the caller of at least
679    * `subtractedValue`.
680    */
681   function decreaseAllowance(address spender, uint256 subtractedValue)
682     public
683     virtual
684     returns (bool)
685   {
686     _approve(
687       _msgSender(),
688       spender,
689       _allowances[_msgSender()][spender].sub(
690         subtractedValue,
691         'ERC20: decreased allowance below zero'
692       )
693     );
694     return true;
695   }
696 
697   /**
698    * @dev Moves tokens `amount` from `sender` to `recipient`.
699    *
700    * This is internal function is equivalent to {transfer}, and can be used to
701    * e.g. implement automatic token fees, slashing mechanisms, etc.
702    *
703    * Emits a {Transfer} event.
704    *
705    * Requirements:
706    *
707    * - `sender` cannot be the zero address.
708    * - `recipient` cannot be the zero address.
709    * - `sender` must have a balance of at least `amount`.
710    */
711   function _transfer(
712     address sender,
713     address recipient,
714     uint256 amount
715   ) internal virtual {
716     require(sender != address(0), 'ERC20: transfer from the zero address');
717     require(recipient != address(0), 'ERC20: transfer to the zero address');
718 
719     _beforeTokenTransfer(sender, recipient, amount);
720 
721     _balances[sender] = _balances[sender].sub(
722       amount,
723       'ERC20: transfer amount exceeds balance'
724     );
725     _balances[recipient] = _balances[recipient].add(amount);
726     emit Transfer(sender, recipient, amount);
727   }
728 
729   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
730    * the total supply.
731    *
732    * Emits a {Transfer} event with `from` set to the zero address.
733    *
734    * Requirements
735    *
736    * - `to` cannot be the zero address.
737    */
738   function _mint(address account, uint256 amount) internal virtual {
739     require(account != address(0), 'ERC20: mint to the zero address');
740 
741     _beforeTokenTransfer(address(0), account, amount);
742 
743     _totalSupply = _totalSupply.add(amount);
744     _balances[account] = _balances[account].add(amount);
745     emit Transfer(address(0), account, amount);
746   }
747 
748   /**
749    * @dev Destroys `amount` tokens from `account`, reducing the
750    * total supply.
751    *
752    * Emits a {Transfer} event with `to` set to the zero address.
753    *
754    * Requirements
755    *
756    * - `account` cannot be the zero address.
757    * - `account` must have at least `amount` tokens.
758    */
759   function _burn(address account, uint256 amount) internal virtual {
760     require(account != address(0), 'ERC20: burn from the zero address');
761 
762     _beforeTokenTransfer(account, address(0), amount);
763 
764     _balances[account] = _balances[account].sub(
765       amount,
766       'ERC20: burn amount exceeds balance'
767     );
768     _totalSupply = _totalSupply.sub(amount);
769     emit Transfer(account, address(0), amount);
770   }
771 
772   /**
773    * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
774    *
775    * This internal function is equivalent to `approve`, and can be used to
776    * e.g. set automatic allowances for certain subsystems, etc.
777    *
778    * Emits an {Approval} event.
779    *
780    * Requirements:
781    *
782    * - `owner` cannot be the zero address.
783    * - `spender` cannot be the zero address.
784    */
785   function _approve(
786     address owner,
787     address spender,
788     uint256 amount
789   ) internal virtual {
790     require(owner != address(0), 'ERC20: approve from the zero address');
791     require(spender != address(0), 'ERC20: approve to the zero address');
792 
793     _allowances[owner][spender] = amount;
794     emit Approval(owner, spender, amount);
795   }
796 
797   /**
798    * @dev Sets {decimals} to a value other than the default one of 18.
799    *
800    * WARNING: This function should only be called from the constructor. Most
801    * applications that interact with token contracts will not expect
802    * {decimals} to ever change, and may work incorrectly if it does.
803    */
804   function _setupDecimals(uint8 decimals_) internal {
805     _decimals = decimals_;
806   }
807 
808   /**
809    * @dev Hook that is called before any transfer of tokens. This includes
810    * minting and burning.
811    *
812    * Calling conditions:
813    *
814    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
815    * will be to transferred to `to`.
816    * - when `from` is zero, `amount` tokens will be minted for `to`.
817    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
818    * - `from` and `to` are never both zero.
819    *
820    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
821    */
822   function _beforeTokenTransfer(
823     address from,
824     address to,
825     uint256 amount
826   ) internal virtual {}
827 }
828 
829 // File: contracts\StonkERC20.sol
830 
831 pragma solidity >=0.6.0;
832 
833 contract StonkERC20 is ERC20 {
834   constructor(uint256 amount) public ERC20('STONK', 'STONK') {
835     _mint(msg.sender, amount);
836   }
837 }