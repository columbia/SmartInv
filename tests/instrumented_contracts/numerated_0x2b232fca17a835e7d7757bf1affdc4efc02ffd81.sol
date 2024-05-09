1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 /**
162  * @dev Interface of the ERC20 standard as defined in the EIP.
163  */
164 interface IERC20 {
165     /**
166      * @dev Returns the amount of tokens in existence.
167      */
168     function totalSupply() external view returns (uint256);
169 
170     /**
171      * @dev Returns the amount of tokens owned by `account`.
172      */
173     function balanceOf(address account) external view returns (uint256);
174 
175     /**
176      * @dev Moves `amount` tokens from the caller's account to `recipient`.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transfer(address recipient, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Returns the remaining number of tokens that `spender` will be
186      * allowed to spend on behalf of `owner` through {transferFrom}. This is
187      * zero by default.
188      *
189      * This value changes when {approve} or {transferFrom} are called.
190      */
191     function allowance(address owner, address spender) external view returns (uint256);
192 
193     /**
194      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * IMPORTANT: Beware that changing an allowance with this method brings the risk
199      * that someone may use both the old and the new allowance by unfortunate
200      * transaction ordering. One possible solution to mitigate this race
201      * condition is to first reduce the spender's allowance to 0 and set the
202      * desired value afterwards:
203      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204      *
205      * Emits an {Approval} event.
206      */
207     function approve(address spender, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Moves `amount` tokens from `sender` to `recipient` using the
211      * allowance mechanism. `amount` is then deducted from the caller's
212      * allowance.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Emitted when `value` tokens are moved from one account (`from`) to
222      * another (`to`).
223      *
224      * Note that `value` may be zero.
225      */
226     event Transfer(address indexed from, address indexed to, uint256 value);
227 
228     /**
229      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
230      * a call to {approve}. `value` is the new allowance.
231      */
232     event Approval(address indexed owner, address indexed spender, uint256 value);
233 }
234 
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address payable) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view virtual returns (bytes memory) {
241         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
242         return msg.data;
243     }
244 }
245 
246 contract Ownable is Context {
247   address private _owner;
248 
249   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251   /**
252    * @dev Initializes the contract setting the deployer as the initial owner.
253    */
254   constructor (address owner) internal {
255     _owner = owner;
256     emit OwnershipTransferred(address(0), owner);
257   }
258 
259   /**
260    * @dev Returns the address of the current owner.
261    */
262   function owner() public view returns (address) {
263     return _owner;
264   }
265 
266   /**
267    * @dev Throws if called by any account other than the owner.
268    */
269   modifier onlyOwner() {
270     require(_owner == _msgSender(), "Ownable: caller is not the owner");
271     _;
272   }
273 
274   /**
275    * @dev Leaves the contract without owner. It will not be possible to call
276    * `onlyOwner` functions anymore. Can only be called by the current owner.
277    *
278    * NOTE: Renouncing ownership will leave the contract without an owner,
279    * thereby removing any functionality that is only available to the owner.
280    */
281   function renounceOwnership() public onlyOwner {
282     emit OwnershipTransferred(_owner, address(0));
283     _owner = address(0);
284   }
285 
286   /**
287    * @dev Transfers ownership of the contract to a new account (`newOwner`).
288    * Can only be called by the current owner.
289    */
290   function transferOwnership(address newOwner) public onlyOwner {
291     _transferOwnership(newOwner);
292   }
293 
294   /**
295    * @dev Transfers ownership of the contract to a new account (`newOwner`).
296    */
297   function _transferOwnership(address newOwner) internal {
298     require(newOwner != address(0), "Ownable: new owner is the zero address");
299     emit OwnershipTransferred(_owner, newOwner);
300     _owner = newOwner;
301   }
302 }
303 
304 /**
305  * @dev Implementation of the {IERC20} interface.
306  *
307  * This implementation is agnostic to the way tokens are created. This means
308  * that a supply mechanism has to be added in a derived contract using {_mint}.
309  * For a generic mechanism see {ERC20PresetMinterPauser}.
310  *
311  * TIP: For a detailed writeup see our guide
312  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
313  * to implement supply mechanisms].
314  *
315  * We have followed general OpenZeppelin guidelines: functions revert instead
316  * of returning `false` on failure. This behavior is nonetheless conventional
317  * and does not conflict with the expectations of ERC20 applications.
318  *
319  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
320  * This allows applications to reconstruct the allowance for all accounts just
321  * by listening to said events. Other implementations of the EIP may not emit
322  * these events, as it isn't required by the specification.
323  *
324  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
325  * functions have been added to mitigate the well-known issues around setting
326  * allowances. See {IERC20-approve}.
327  */
328 contract ERC20 is Ownable, IERC20 {
329     using SafeMath for uint256;
330 
331     mapping (address => uint256) private _balances;
332 
333     mapping (address => mapping (address => uint256)) private _allowances;
334 
335     uint256 private _totalSupply;
336 
337     string private _name;
338     string private _symbol;
339     uint8 private _decimals;
340 
341     /**
342      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
343      * a default value of 6.
344      *
345      * To select a different value for {decimals}, use {_setupDecimals}.
346      *
347      * All three of these values are immutable: they can only be set once during
348      * construction.
349      */
350     constructor (address owner_, string memory name_, string memory symbol_) public Ownable(owner_) {
351         _name = name_;
352         _symbol = symbol_;
353         _decimals = 18;
354     }
355 
356     /**
357      * @dev Returns the name of the token.
358      */
359     function name() public view returns (string memory) {
360         return _name;
361     }
362 
363     /**
364      * @dev Returns the symbol of the token, usually a shorter version of the
365      * name.
366      */
367     function symbol() public view returns (string memory) {
368         return _symbol;
369     }
370 
371     /**
372      * @dev Returns the number of decimals used to get its user representation.
373      * For example, if `decimals` equals `2`, a balance of `505` tokens should
374      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
375      *
376      * Tokens usually opt for a value of 18, imitating the relationship between
377      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
378      * called.
379      *
380      * NOTE: This information is only used for _display_ purposes: it in
381      * no way affects any of the arithmetic of the contract, including
382      * {IERC20-balanceOf} and {IERC20-transfer}.
383      */
384     function decimals() public view returns (uint8) {
385         return _decimals;
386     }
387 
388     /**
389      * @dev See {IERC20-totalSupply}.
390      */
391     function totalSupply() public view override returns (uint256) {
392         return _totalSupply;
393     }
394 
395     /**
396      * @dev See {IERC20-balanceOf}.
397      */
398     function balanceOf(address account) public view override returns (uint256) {
399         return _balances[account];
400     }
401 
402     /**
403      * @dev See {IERC20-transfer}.
404      *
405      * Requirements:
406      *
407      * - `recipient` cannot be the zero address.
408      * - the caller must have a balance of at least `amount`.
409      */
410     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
411         _transfer(_msgSender(), recipient, amount);
412         return true;
413     }
414 
415     /**
416      * @dev See {IERC20-allowance}.
417      */
418     function allowance(address owner, address spender) public view virtual override returns (uint256) {
419         return _allowances[owner][spender];
420     }
421 
422     /**
423      * @dev See {IERC20-approve}.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function approve(address spender, uint256 amount) public virtual override returns (bool) {
430         _approve(_msgSender(), spender, amount);
431         return true;
432     }
433 
434     /**
435      * @dev See {IERC20-transferFrom}.
436      *
437      * Emits an {Approval} event indicating the updated allowance. This is not
438      * required by the EIP. See the note at the beginning of {ERC20}.
439      *
440      * Requirements:
441      *
442      * - `sender` and `recipient` cannot be the zero address.
443      * - `sender` must have a balance of at least `amount`.
444      * - the caller must have allowance for ``sender``'s tokens of at least
445      * `amount`.
446      */
447     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
448         _transfer(sender, recipient, amount);
449         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
450         return true;
451     }
452 
453     /**
454      * @dev Atomically increases the allowance granted to `spender` by the caller.
455      *
456      * This is an alternative to {approve} that can be used as a mitigation for
457      * problems described in {IERC20-approve}.
458      *
459      * Emits an {Approval} event indicating the updated allowance.
460      *
461      * Requirements:
462      *
463      * - `spender` cannot be the zero address.
464      */
465     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
466         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
467         return true;
468     }
469 
470     /**
471      * @dev Atomically decreases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      * - `spender` must have allowance for the caller of at least
482      * `subtractedValue`.
483      */
484     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
486         return true;
487     }
488 
489     /**
490      * @dev Moves tokens `amount` from `sender` to `recipient`.
491      *
492      * This is internal function is equivalent to {transfer}, and can be used to
493      * e.g. implement automatic token fees, slashing mechanisms, etc.
494      *
495      * Emits a {Transfer} event.
496      *
497      * Requirements:
498      *
499      * - `sender` cannot be the zero address.
500      * - `recipient` cannot be the zero address.
501      * - `sender` must have a balance of at least `amount`.
502      */
503     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
504         require(sender != address(0), "ERC20: transfer from the zero address");
505         require(recipient != address(0), "ERC20: transfer to the zero address");
506 
507         _beforeTokenTransfer(sender, recipient, amount);
508 
509         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
510         _balances[recipient] = _balances[recipient].add(amount);
511         emit Transfer(sender, recipient, amount);
512     }
513 
514     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
515      * the total supply.
516      *
517      * Emits a {Transfer} event with `from` set to the zero address.
518      *
519      * Requirements:
520      *
521      * - `to` cannot be the zero address.
522      */
523     function _mint(address account, uint256 amount) internal virtual {
524         require(account != address(0), "ERC20: mint to the zero address");
525 
526         _beforeTokenTransfer(address(0), account, amount);
527 
528         _totalSupply = _totalSupply.add(amount);
529         _balances[account] = _balances[account].add(amount);
530         emit Transfer(address(0), account, amount);
531     }
532 
533     /**
534      * @dev Destroys `amount` tokens from `account`, reducing the
535      * total supply.
536      *
537      * Emits a {Transfer} event with `to` set to the zero address.
538      *
539      * Requirements:
540      *
541      * - `account` cannot be the zero address.
542      * - `account` must have at least `amount` tokens.
543      */
544     function _burn(address account, uint256 amount) internal virtual {
545         require(account != address(0), "ERC20: burn from the zero address");
546 
547         _beforeTokenTransfer(account, address(0), amount);
548 
549         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
550         _totalSupply = _totalSupply.sub(amount);
551         emit Transfer(account, address(0), amount);
552     }
553 
554     /**
555      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
556      *
557      * This internal function is equivalent to `approve`, and can be used to
558      * e.g. set automatic allowances for certain subsystems, etc.
559      *
560      * Emits an {Approval} event.
561      *
562      * Requirements:
563      *
564      * - `owner` cannot be the zero address.
565      * - `spender` cannot be the zero address.
566      */
567     function _approve(address owner, address spender, uint256 amount) internal virtual {
568         require(owner != address(0), "ERC20: approve from the zero address");
569         require(spender != address(0), "ERC20: approve to the zero address");
570 
571         _allowances[owner][spender] = amount;
572         emit Approval(owner, spender, amount);
573     }
574 
575     /**
576      * @dev Sets {decimals} to a value other than the default one of 18.
577      *
578      * WARNING: This function should only be called from the constructor. Most
579      * applications that interact with token contracts will not expect
580      * {decimals} to ever change, and may work incorrectly if it does.
581      */
582     function _setupDecimals(uint8 decimals_) internal {
583         _decimals = decimals_;
584     }
585 
586     /**
587      * @dev Hook that is called before any transfer of tokens. This includes
588      * minting and burning.
589      *
590      * Calling conditions:
591      *
592      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
593      * will be to transferred to `to`.
594      * - when `from` is zero, `amount` tokens will be minted for `to`.
595      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
596      * - `from` and `to` are never both zero.
597      *
598      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
599      */
600     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
601 }
602 
603 /**
604  * @dev Collection of functions related to the address type
605  */
606 library Address {
607     /**
608      * @dev Returns true if `account` is a contract.
609      *
610      * [IMPORTANT]
611      * ====
612      * It is unsafe to assume that an address for which this function returns
613      * false is an externally-owned account (EOA) and not a contract.
614      *
615      * Among others, `isContract` will return false for the following
616      * types of addresses:
617      *
618      *  - an externally-owned account
619      *  - a contract in construction
620      *  - an address where a contract will be created
621      *  - an address where a contract lived, but was destroyed
622      * ====
623      */
624     function isContract(address account) internal view returns (bool) {
625         // This method relies on extcodesize, which returns 0 for contracts in
626         // construction, since the code is only stored at the end of the
627         // constructor execution.
628 
629         uint256 size;
630         // solhint-disable-next-line no-inline-assembly
631         assembly { size := extcodesize(account) }
632         return size > 0;
633     }
634 
635     /**
636      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
637      * `recipient`, forwarding all available gas and reverting on errors.
638      *
639      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
640      * of certain opcodes, possibly making contracts go over the 2300 gas limit
641      * imposed by `transfer`, making them unable to receive funds via
642      * `transfer`. {sendValue} removes this limitation.
643      *
644      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
645      *
646      * IMPORTANT: because control is transferred to `recipient`, care must be
647      * taken to not create reentrancy vulnerabilities. Consider using
648      * {ReentrancyGuard} or the
649      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
650      */
651     function sendValue(address payable recipient, uint256 amount) internal {
652         require(address(this).balance >= amount, "Address: insufficient balance");
653 
654         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
655         (bool success, ) = recipient.call{ value: amount }("");
656         require(success, "Address: unable to send value, recipient may have reverted");
657     }
658 
659     /**
660      * @dev Performs a Solidity function call using a low level `call`. A
661      * plain`call` is an unsafe replacement for a function call: use this
662      * function instead.
663      *
664      * If `target` reverts with a revert reason, it is bubbled up by this
665      * function (like regular Solidity function calls).
666      *
667      * Returns the raw returned data. To convert to the expected return value,
668      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
669      *
670      * Requirements:
671      *
672      * - `target` must be a contract.
673      * - calling `target` with `data` must not revert.
674      *
675      * _Available since v3.1._
676      */
677     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
678       return functionCall(target, data, "Address: low-level call failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
683      * `errorMessage` as a fallback revert reason when `target` reverts.
684      *
685      * _Available since v3.1._
686      */
687     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
688         return functionCallWithValue(target, data, 0, errorMessage);
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
693      * but also transferring `value` wei to `target`.
694      *
695      * Requirements:
696      *
697      * - the calling contract must have an ETH balance of at least `value`.
698      * - the called Solidity function must be `payable`.
699      *
700      * _Available since v3.1._
701      */
702     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
703         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
704     }
705 
706     /**
707      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
708      * with `errorMessage` as a fallback revert reason when `target` reverts.
709      *
710      * _Available since v3.1._
711      */
712     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
713         require(address(this).balance >= value, "Address: insufficient balance for call");
714         require(isContract(target), "Address: call to non-contract");
715 
716         // solhint-disable-next-line avoid-low-level-calls
717         (bool success, bytes memory returndata) = target.call{ value: value }(data);
718         return _verifyCallResult(success, returndata, errorMessage);
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
723      * but performing a static call.
724      *
725      * _Available since v3.3._
726      */
727     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
728         return functionStaticCall(target, data, "Address: low-level static call failed");
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
733      * but performing a static call.
734      *
735      * _Available since v3.3._
736      */
737     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
738         require(isContract(target), "Address: static call to non-contract");
739 
740         // solhint-disable-next-line avoid-low-level-calls
741         (bool success, bytes memory returndata) = target.staticcall(data);
742         return _verifyCallResult(success, returndata, errorMessage);
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
747      * but performing a delegate call.
748      *
749      * _Available since v3.4._
750      */
751     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
752         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
757      * but performing a delegate call.
758      *
759      * _Available since v3.4._
760      */
761     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
762         require(isContract(target), "Address: delegate call to non-contract");
763 
764         // solhint-disable-next-line avoid-low-level-calls
765         (bool success, bytes memory returndata) = target.delegatecall(data);
766         return _verifyCallResult(success, returndata, errorMessage);
767     }
768 
769     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
770         if (success) {
771             return returndata;
772         } else {
773             // Look for revert reason and bubble it up if present
774             if (returndata.length > 0) {
775                 // The easiest way to bubble the revert reason is using memory via assembly
776 
777                 // solhint-disable-next-line no-inline-assembly
778                 assembly {
779                     let returndata_size := mload(returndata)
780                     revert(add(32, returndata), returndata_size)
781                 }
782             } else {
783                 revert(errorMessage);
784             }
785         }
786     }
787 }
788 
789 /**
790  * @title SafeERC20
791  * @dev Wrappers around ERC20 operations that throw on failure (when the token
792  * contract returns false). Tokens that return no value (and instead revert or
793  * throw on failure) are also supported, non-reverting calls are assumed to be
794  * successful.
795  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
796  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
797  */
798 library SafeERC20 {
799     using Address for address;
800 
801     function safeTransfer(IERC20 token, address to, uint256 value) internal {
802         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
803     }
804 
805     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
806         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
807     }
808 
809     /**
810      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
811      * on the return value: the return value is optional (but if data is returned, it must not be false).
812      * @param token The token targeted by the call.
813      * @param data The call data (encoded using abi.encode or one of its variants).
814      */
815     function _callOptionalReturn(IERC20 token, bytes memory data) private {
816         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
817         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
818         // the target address contains contract code and also asserts for success in the low-level call.
819 
820         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
821         if (returndata.length > 0) { // Return data is optional
822             // solhint-disable-next-line max-line-length
823             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
824         }
825     }
826 }
827 
828 contract aJASMY is ERC20
829 {
830     using SafeERC20 for IERC20;
831     
832     bool public isSwapPaused;
833     address public revenueOwner;
834     uint32 public interestBasisPoints; // 1 basis point = 0.01%; 10000 basis points = 100%
835     IERC20 public lockedToken;
836     address public lockedTokenOwner;
837     uint256 public unlockTimestamp;
838     mapping(address => uint256) public assets; // address(0) = ETH
839     
840     uint256 private constant ONE = 10**18;
841     
842     string private constant ERR_AUTH_FAILED = "ERR_AUTH_FAILED";
843     
844     event Swap(address indexed buyer,
845                address indexed fromAsset, // address(0) = ETH
846                uint256 fromAmount,
847                uint256 toAmount,
848                uint32 indexed refCode);
849     event GetUnlocked(address indexed buyer, uint256 burnAmount, uint256 unlockedAmount);
850     event Withdraw(address indexed msgSender, bool isMsgSenderOwner, bool isEth, address indexed to, uint256 amount);
851     event SetPrice(address indexed asset, uint256 price);
852     event SwapPause(bool on);
853     event SetRevenueOwner(address indexed msgSender, address indexed newRevenueOwner);
854     event SetLockedTokenOwner(address indexed msgSender, address indexed newLockedTokenOwner);
855     
856     // Constructor:
857     //--------------------------------------------------------------------------------------------------------------------------
858     constructor(address _owner,
859                 string memory _name,
860                 string memory _symbol,
861                 address _revenueOwner,
862                 uint32 _interestBasisPoints,
863                 IERC20 _lockedToken,
864                 address _lockedTokenOwner,
865                 uint256 _unlockTimestamp,
866                 address[] memory _assetAddresses,
867                 uint256[] memory _assetPrices) public ERC20(_owner, _name, _symbol)
868     {
869         require(_assetAddresses.length == _assetPrices.length);
870         
871         revenueOwner = _revenueOwner;
872         interestBasisPoints = _interestBasisPoints;
873         lockedToken = _lockedToken;
874         lockedTokenOwner = _lockedTokenOwner;
875         unlockTimestamp = _unlockTimestamp;
876         
877         emit SetRevenueOwner(_msgSender(), _revenueOwner);
878         emit SetLockedTokenOwner(_msgSender(), _lockedTokenOwner);
879                 
880         for(uint32 i = 0; i < _assetPrices.length; ++i)
881         {
882             assets[_assetAddresses[i]] = _assetPrices[i];
883             
884             emit SetPrice(_assetAddresses[i], _assetPrices[i]);
885         }
886         
887         emit SwapPause(false);
888     }
889     //--------------------------------------------------------------------------------------------------------------------------
890     
891     // Revenue owner methods:
892     //--------------------------------------------------------------------------------------------------------------------------
893     modifier onlyRevenueOwner()
894     {
895         require(revenueOwner == _msgSender(), ERR_AUTH_FAILED);
896         _;
897     }
898     
899     function setRevenueOwner(address _newRevenueOwner) external onlyRevenueOwner
900     {
901         revenueOwner = _newRevenueOwner;
902         
903         emit SetRevenueOwner(_msgSender(), _newRevenueOwner);
904     }
905     
906     function withdrawEth(address payable _to, uint256 _amount) external onlyRevenueOwner
907     {
908         _withdrawEth(_to, _amount);
909     }
910     //--------------------------------------------------------------------------------------------------------------------------
911     
912     // Locked token owner methods:
913     //--------------------------------------------------------------------------------------------------------------------------
914     modifier onlyLockedTokenOwner()
915     {
916         require(lockedTokenOwner == _msgSender(), ERR_AUTH_FAILED);
917         _;
918     }
919     
920     function setLockedTokenOwner(address _newLockedTokenOwner) external onlyLockedTokenOwner
921     {
922         lockedTokenOwner = _newLockedTokenOwner;
923         
924         emit SetLockedTokenOwner(_msgSender(), _newLockedTokenOwner);
925     }
926     
927     function withdrawLockedToken(address _to, uint256 _amount) external onlyLockedTokenOwner
928     {
929         _withdrawLockedToken(_to, _amount);
930     }
931     //--------------------------------------------------------------------------------------------------------------------------
932     
933     // Owner methods:
934     //--------------------------------------------------------------------------------------------------------------------------
935     function withdrawEth(uint256 _amount) external onlyOwner
936     {
937         _withdrawEth(payable(revenueOwner), _amount);
938     }
939     
940     function withdrawLockedToken(uint256 _amount) external onlyOwner
941     {
942         _withdrawLockedToken(lockedTokenOwner, _amount);
943     }
944     
945     function setPrices(address[] calldata _assetAddresses, uint256[] calldata _assetPrices) external onlyOwner
946     {
947         require(_assetAddresses.length == _assetPrices.length, "ERR_ARRAYS_LENGTHS_DONT_MATCH");
948         
949         for(uint32 i = 0; i < _assetAddresses.length; ++i)
950         {
951             assets[_assetAddresses[i]] = _assetPrices[i];
952             
953             emit SetPrice(_assetAddresses[i], _assetPrices[i]);
954         }
955     }
956     
957     function swapPause(bool _on) external onlyOwner
958     {
959         require(isSwapPaused != _on);
960         
961         isSwapPaused = _on;
962         
963         emit SwapPause(_on);
964     }
965     //--------------------------------------------------------------------------------------------------------------------------
966     
967     // Withdraw helpers:
968     //--------------------------------------------------------------------------------------------------------------------------
969     function _withdrawEth(address payable _to, uint256 _amount) private
970     {
971         if(_amount == 0)
972         {
973             _amount = address(this).balance;
974         }
975         
976         _to.transfer(_amount);
977         
978         emit Withdraw(_msgSender(), _msgSender() == owner(), true, _to, _amount);
979     }
980     
981     function _withdrawLockedToken(address _to, uint256 _amount) private
982     {
983         uint256 collateralAmount = collateralAmount();
984         
985         if(_amount == 0)
986         {
987             _amount = lockedToken.balanceOf(address(this)) - collateralAmount;
988         }
989         
990         lockedToken.safeTransfer(_to, _amount);
991         
992         require(lockedToken.balanceOf(address(this)) >= collateralAmount, "ERR_INVALID_AMOUNT");
993         
994         emit Withdraw(_msgSender(), _msgSender() == owner(), false, _to, _amount);
995     }
996     //--------------------------------------------------------------------------------------------------------------------------
997     
998     // Price calculator:
999     //--------------------------------------------------------------------------------------------------------------------------
1000     function calcPrice(address _fromAsset, uint256 _fromAmount) public view returns (uint256 toActualAmount_, uint256 fromActualAmount_)
1001     {
1002         require(_fromAmount > 0, "ERR_ZERO_PAYMENT");
1003         
1004         uint256 fromAssetPrice = assets[_fromAsset];
1005         require(fromAssetPrice > 0, "ERR_ASSET_NOT_SUPPORTED");
1006         
1007         if(isSwapPaused) return (0, 0);
1008         
1009         uint256 toAvailableForSell = availableForSellAmount();
1010         
1011         fromActualAmount_ = _fromAmount;
1012 
1013         toActualAmount_ = _fromAmount.mul(ONE).div(fromAssetPrice);
1014         
1015         if(toActualAmount_ > toAvailableForSell)
1016         {
1017             toActualAmount_ = toAvailableForSell;
1018             fromActualAmount_ = toAvailableForSell.mul(fromAssetPrice).div(ONE);
1019         }
1020     }
1021     //--------------------------------------------------------------------------------------------------------------------------
1022     
1023     // Swap:
1024     //--------------------------------------------------------------------------------------------------------------------------
1025     function swapFromEth(uint256 _toExpectedAmount, uint32 _refCode) external payable
1026     {
1027         _swap(address(0), msg.value, _toExpectedAmount, _refCode);
1028     }
1029     
1030     function swapFromErc20(IERC20 _fromAsset, uint256 _toExpectedAmount, uint32 _refCode) external
1031     {
1032         require(address(_fromAsset) != address(0), "ERR_WRONG_SWAP_FUNCTION");
1033         
1034         uint256 fromAmount = _fromAsset.allowance(_msgSender(), address(this));
1035         _fromAsset.safeTransferFrom(_msgSender(), revenueOwner, fromAmount);
1036         
1037         _swap(address(_fromAsset), fromAmount, _toExpectedAmount, _refCode);
1038     }
1039     
1040     function _swap(address _fromAsset, uint256 _fromAmount, uint256 _toExpectedAmount, uint32 _refCode) private
1041     {
1042         require(!isSwapPaused, "ERR_SWAP_PAUSED");
1043         require(_toExpectedAmount > 0, "ERR_ZERO_EXPECTED_AMOUNT");
1044         
1045         (uint256 toActualAmount, uint256 fromActualAmount) = calcPrice(_fromAsset, _fromAmount);
1046         
1047         toActualAmount = _fixAmount(toActualAmount, _toExpectedAmount);
1048             
1049         require(_fromAmount == fromActualAmount, "ERR_WRONG_PAYMENT_AMOUNT");
1050         
1051         _mint(_msgSender(), toActualAmount);
1052      
1053         emit Swap(_msgSender(), _fromAsset, _fromAmount, toActualAmount, _refCode);
1054     }
1055     
1056     function _fixAmount(uint256 _actual, uint256 _expected) private pure returns (uint256)
1057     {
1058         if(_expected < _actual) return _expected;
1059         
1060         require(_actual - _expected <= 10**14, "ERR_EXPECTED_AMOUNT_MISMATCH");
1061         
1062         return _actual;
1063     }
1064     //--------------------------------------------------------------------------------------------------------------------------
1065     
1066     // Get unlocked:
1067     //--------------------------------------------------------------------------------------------------------------------------
1068     function getUnlocked(uint256 _amount) external
1069     {
1070         require(unlockTimestamp <= now, "ERR_NOT_YET_UNLOCKED");
1071         
1072         if(_amount == 0) _amount = balanceOf(_msgSender());
1073         
1074         _burn(_msgSender(), _amount);
1075         
1076         uint256 unlockedAmount = _getAmountWithInterest(_amount);
1077         lockedToken.safeTransfer(_msgSender(), unlockedAmount);
1078         
1079         emit GetUnlocked(_msgSender(), _amount, unlockedAmount);
1080     }
1081     //--------------------------------------------------------------------------------------------------------------------------
1082     
1083     // Interest and collateral:
1084     //--------------------------------------------------------------------------------------------------------------------------
1085     function _getAmountWithInterest(uint256 _amount) private view returns (uint256)
1086     {
1087         return _amount.add(_amount.mul(interestBasisPoints) / 10000);
1088     }
1089     
1090     function collateralAmount() public view returns (uint256)
1091     {
1092         return _getAmountWithInterest(totalSupply());
1093     }
1094     
1095     function availableForSellAmount() public view returns (uint256)
1096     {
1097         return (lockedToken.balanceOf(address(this)).sub(collateralAmount())).mul(10000) / (10000 + interestBasisPoints);
1098     }
1099     //--------------------------------------------------------------------------------------------------------------------------
1100 }