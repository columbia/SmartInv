1 pragma solidity ^0.6.2;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      *
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      *
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      *
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      *
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      *
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      *
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 contract Ownable {
160     /**
161      * @notice map for list of owners
162      */
163     mapping(address => uint256) public owner;
164     uint256 index = 0;
165 
166     /**
167      * @notice constructor, where first user is an administrator
168      */
169     constructor() public {
170         owner[msg.sender] = ++index;
171     }
172 
173     /**
174      * @notice modifier which check the status of user and continue only if msg.sender is administrator
175      */
176     modifier onlyOwner() {
177         require(owner[msg.sender] > 0, "onlyOwner exception");
178         _;
179     }
180 
181     /**
182      * @notice adding new owner to list of owners
183      * @param newOwner address of new administrator
184      * @return true when operation is successful
185      */
186     function addNewOwner(address newOwner) public onlyOwner returns(bool) {
187         owner[newOwner] = ++index;
188         return true;
189     }
190 
191     /**
192      * @notice remove owner from list of owners
193      * @param removedOwner address of removed administrator
194      * @return true when operation is successful
195      */
196     function removeOwner(address removedOwner) public onlyOwner returns(bool) {
197         require(msg.sender != removedOwner, "Denied deleting of yourself");
198         owner[removedOwner] = 0;
199         return true;
200     }
201 }
202 
203 /*
204  * @dev Provides information about the current execution context, including the
205  * sender of the transaction and its data. While these are generally available
206  * via msg.sender and msg.data, they should not be accessed in such a direct
207  * manner, since when dealing with GSN meta-transactions the account sending and
208  * paying for execution may not be the actual sender (as far as an application
209  * is concerned).
210  *
211  * This contract is only required for intermediate, library-like contracts.
212  */
213 abstract contract Context {
214     function _msgSender() internal view virtual returns (address payable) {
215         return msg.sender;
216     }
217 
218     function _msgData() internal view virtual returns (bytes memory) {
219         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
220         return msg.data;
221     }
222 }
223 
224 /**
225  * @dev Collection of functions related to the address type
226  */
227 library Address {
228     /**
229      * @dev Returns true if `account` is a contract.
230      *
231      * [IMPORTANT]
232      * ====
233      * It is unsafe to assume that an address for which this function returns
234      * false is an externally-owned account (EOA) and not a contract.
235      *
236      * Among others, `isContract` will return false for the following
237      * types of addresses:
238      *
239      *  - an externally-owned account
240      *  - a contract in construction
241      *  - an address where a contract will be created
242      *  - an address where a contract lived, but was destroyed
243      */
244     function isContract(address account) internal view returns (bool) {
245         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
246         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
247         // for accounts without code, i.e. `keccak256('')`
248         bytes32 codehash;
249         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
250         // solhint-disable-next-line no-inline-assembly
251         assembly { codehash := extcodehash(account) }
252         return (codehash != accountHash && codehash != 0x0);
253     }
254 
255     /**
256      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
257      * `recipient`, forwarding all available gas and reverting on errors.
258      *
259      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
260      * of certain opcodes, possibly making contracts go over the 2300 gas limit
261      * imposed by `transfer`, making them unable to receive funds via
262      * `transfer`. {sendValue} removes this limitation.
263      *
264      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
265      *
266      * IMPORTANT: because control is transferred to `recipient`, care must be
267      * taken to not create reentrancy vulnerabilities. Consider using
268      * {ReentrancyGuard} or the
269      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
270      */
271     function sendValue(address payable recipient, uint256 amount) internal {
272         require(address(this).balance >= amount, "Address: insufficient balance");
273 
274         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
275         (bool success, ) = recipient.call{ value: amount }("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain`call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289      *
290      * Requirements:
291      *
292      * - `target` must be a contract.
293      * - calling `target` with `data` must not revert.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionCall(target, data, "Address: low-level call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303      * `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
308         return _functionCallWithValue(target, data, 0, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but also transferring `value` wei to `target`.
314      *
315      * Requirements:
316      *
317      * - the calling contract must have an ETH balance of at least `value`.
318      * - the called Solidity function must be `payable`.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
328      * with `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
333         require(address(this).balance >= value, "Address: insufficient balance for call");
334         return _functionCallWithValue(target, data, value, errorMessage);
335     }
336 
337     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
338         require(isContract(target), "Address: call to non-contract");
339 
340         // solhint-disable-next-line avoid-low-level-calls
341         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
342         if (success) {
343             return returndata;
344         } else {
345             // Look for revert reason and bubble it up if present
346             if (returndata.length > 0) {
347                 // The easiest way to bubble the revert reason is using memory via assembly
348 
349                 // solhint-disable-next-line no-inline-assembly
350                 assembly {
351                     let returndata_size := mload(returndata)
352                     revert(add(32, returndata), returndata_size)
353                 }
354             } else {
355                 revert(errorMessage);
356             }
357         }
358     }
359 }
360 
361 /**
362  * @dev Interface of the ERC20 standard as defined in the EIP.
363  */
364 interface IERC20 {
365     /**
366      * @dev Returns the amount of tokens in existence.
367      */
368     function totalSupply() external view returns (uint256);
369 
370     /**
371      * @dev Returns the amount of tokens owned by `account`.
372      */
373     function balanceOf(address account) external view returns (uint256);
374 
375     /**
376      * @dev Moves `amount` tokens from the caller's account to `recipient`.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * Emits a {Transfer} event.
381      */
382     function transfer(address recipient, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Returns the remaining number of tokens that `spender` will be
386      * allowed to spend on behalf of `owner` through {transferFrom}. This is
387      * zero by default.
388      *
389      * This value changes when {approve} or {transferFrom} are called.
390      */
391     function allowance(address owner, address spender) external view returns (uint256);
392 
393     /**
394      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
395      *
396      * Returns a boolean value indicating whether the operation succeeded.
397      *
398      * IMPORTANT: Beware that changing an allowance with this method brings the risk
399      * that someone may use both the old and the new allowance by unfortunate
400      * transaction ordering. One possible solution to mitigate this race
401      * condition is to first reduce the spender's allowance to 0 and set the
402      * desired value afterwards:
403      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
404      *
405      * Emits an {Approval} event.
406      */
407     function approve(address spender, uint256 amount) external returns (bool);
408 
409     /**
410      * @dev Moves `amount` tokens from `sender` to `recipient` using the
411      * allowance mechanism. `amount` is then deducted from the caller's
412      * allowance.
413      *
414      * Returns a boolean value indicating whether the operation succeeded.
415      *
416      * Emits a {Transfer} event.
417      */
418     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
419 
420     /**
421      * @dev Emitted when `value` tokens are moved from one account (`from`) to
422      * another (`to`).
423      *
424      * Note that `value` may be zero.
425      */
426     event Transfer(address indexed from, address indexed to, uint256 value);
427 
428     /**
429      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
430      * a call to {approve}. `value` is the new allowance.
431      */
432     event Approval(address indexed owner, address indexed spender, uint256 value);
433 }
434 
435 contract ERC20 is Context, IERC20 {
436     using SafeMath for uint256;
437     using Address for address;
438 
439     mapping (address => uint256) private _balances;
440 
441     mapping (address => mapping (address => uint256)) private _allowances;
442 
443     uint256 private _totalSupply;
444 
445     string private _name;
446     string private _symbol;
447     uint8 private _decimals;
448 
449     /**
450      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
451      * a default value of 18.
452      *
453      * To select a different value for {decimals}, use {_setupDecimals}.
454      *
455      * All three of these values are immutable: they can only be set once during
456      * construction.
457      */
458     constructor (string memory name, string memory symbol) public {
459         _name = name;
460         _symbol = symbol;
461         _decimals = 18;
462     }
463 
464     /**
465      * @dev Returns the name of the token.
466      */
467     function name() public view returns (string memory) {
468         return _name;
469     }
470 
471     /**
472      * @dev Returns the symbol of the token, usually a shorter version of the
473      * name.
474      */
475     function symbol() public view returns (string memory) {
476         return _symbol;
477     }
478 
479     /**
480      * @dev Returns the number of decimals used to get its user representation.
481      * For example, if `decimals` equals `2`, a balance of `505` tokens should
482      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
483      *
484      * Tokens usually opt for a value of 18, imitating the relationship between
485      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
486      * called.
487      *
488      * NOTE: This information is only used for _display_ purposes: it in
489      * no way affects any of the arithmetic of the contract, including
490      * {IERC20-balanceOf} and {IERC20-transfer}.
491      */
492     function decimals() public view returns (uint8) {
493         return _decimals;
494     }
495 
496     /**
497      * @dev See {IERC20-totalSupply}.
498      */
499     function totalSupply() public view override returns (uint256) {
500         return _totalSupply;
501     }
502 
503     /**
504      * @dev See {IERC20-balanceOf}.
505      */
506     function balanceOf(address account) public view override returns (uint256) {
507         return _balances[account];
508     }
509 
510     /**
511      * @dev See {IERC20-transfer}.
512      *
513      * Requirements:
514      *
515      * - `recipient` cannot be the zero address.
516      * - the caller must have a balance of at least `amount`.
517      */
518     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
519         _transfer(_msgSender(), recipient, amount);
520         return true;
521     }
522 
523     /**
524      * @dev See {IERC20-allowance}.
525      */
526     function allowance(address owner, address spender) public view virtual override returns (uint256) {
527         return _allowances[owner][spender];
528     }
529 
530     /**
531      * @dev See {IERC20-approve}.
532      *
533      * Requirements:
534      *
535      * - `spender` cannot be the zero address.
536      */
537     function approve(address spender, uint256 amount) public virtual override returns (bool) {
538         _approve(_msgSender(), spender, amount);
539         return true;
540     }
541 
542     /**
543      * @dev See {IERC20-transferFrom}.
544      *
545      * Emits an {Approval} event indicating the updated allowance. This is not
546      * required by the EIP. See the note at the beginning of {ERC20};
547      *
548      * Requirements:
549      * - `sender` and `recipient` cannot be the zero address.
550      * - `sender` must have a balance of at least `amount`.
551      * - the caller must have allowance for ``sender``'s tokens of at least
552      * `amount`.
553      */
554     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
555         _transfer(sender, recipient, amount);
556         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
557         return true;
558     }
559 
560     /**
561      * @dev Atomically increases the allowance granted to `spender` by the caller.
562      *
563      * This is an alternative to {approve} that can be used as a mitigation for
564      * problems described in {IERC20-approve}.
565      *
566      * Emits an {Approval} event indicating the updated allowance.
567      *
568      * Requirements:
569      *
570      * - `spender` cannot be the zero address.
571      */
572     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
573         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
574         return true;
575     }
576 
577     /**
578      * @dev Atomically decreases the allowance granted to `spender` by the caller.
579      *
580      * This is an alternative to {approve} that can be used as a mitigation for
581      * problems described in {IERC20-approve}.
582      *
583      * Emits an {Approval} event indicating the updated allowance.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      * - `spender` must have allowance for the caller of at least
589      * `subtractedValue`.
590      */
591     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
592         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
593         return true;
594     }
595 
596     /**
597      * @dev Moves tokens `amount` from `sender` to `recipient`.
598      *
599      * This is internal function is equivalent to {transfer}, and can be used to
600      * e.g. implement automatic token fees, slashing mechanisms, etc.
601      *
602      * Emits a {Transfer} event.
603      *
604      * Requirements:
605      *
606      * - `sender` cannot be the zero address.
607      * - `recipient` cannot be the zero address.
608      * - `sender` must have a balance of at least `amount`.
609      */
610     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
611         require(sender != address(0), "ERC20: transfer from the zero address");
612         require(recipient != address(0), "ERC20: transfer to the zero address");
613         revert("Transfers are not allowed");
614 
615         _beforeTokenTransfer(sender, recipient, amount);
616 
617         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
618         _balances[recipient] = _balances[recipient].add(amount);
619         emit Transfer(sender, recipient, amount);
620     }
621 
622     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
623      * the total supply.
624      *
625      * Emits a {Transfer} event with `from` set to the zero address.
626      *
627      * Requirements
628      *
629      * - `to` cannot be the zero address.
630      */
631     function _mint(address account, uint256 amount) internal virtual {
632         require(account != address(0), "ERC20: mint to the zero address");
633 
634         _beforeTokenTransfer(address(0), account, amount);
635 
636         _totalSupply = _totalSupply.add(amount);
637         _balances[account] = _balances[account].add(amount);
638         emit Transfer(address(0), account, amount);
639     }
640 
641     /**
642      * @dev Destroys `amount` tokens from `account`, reducing the
643      * total supply.
644      *
645      * Emits a {Transfer} event with `to` set to the zero address.
646      *
647      * Requirements
648      *
649      * - `account` cannot be the zero address.
650      * - `account` must have at least `amount` tokens.
651      */
652     function _burn(address account, uint256 amount) internal virtual {
653         require(account != address(0), "ERC20: burn from the zero address");
654 
655         _beforeTokenTransfer(account, address(0), amount);
656 
657         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
658         _totalSupply = _totalSupply.sub(amount);
659         emit Transfer(account, address(0), amount);
660     }
661 
662     /**
663      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
664      *
665      * This is internal function is equivalent to `approve`, and can be used to
666      * e.g. set automatic allowances for certain subsystems, etc.
667      *
668      * Emits an {Approval} event.
669      *
670      * Requirements:
671      *
672      * - `owner` cannot be the zero address.
673      * - `spender` cannot be the zero address.
674      */
675     function _approve(address owner, address spender, uint256 amount) internal virtual {
676         require(owner != address(0), "ERC20: approve from the zero address");
677         require(spender != address(0), "ERC20: approve to the zero address");
678 
679         _allowances[owner][spender] = amount;
680         emit Approval(owner, spender, amount);
681     }
682 
683     /**
684      * @dev Sets {decimals} to a value other than the default one of 18.
685      *
686      * WARNING: This function should only be called from the constructor. Most
687      * applications that interact with token contracts will not expect
688      * {decimals} to ever change, and may work incorrectly if it does.
689      */
690     function _setupDecimals(uint8 decimals_) internal {
691         _decimals = decimals_;
692     }
693 
694     /**
695      * @dev Hook that is called before any transfer of tokens. This includes
696      * minting and burning.
697      *
698      * Calling conditions:
699      *
700      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
701      * will be to transferred to `to`.
702      * - when `from` is zero, `amount` tokens will be minted for `to`.
703      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
704      * - `from` and `to` are never both zero.
705      *
706      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
707      */
708     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
709 }
710 
711 contract ETHSteps is ERC20, Ownable {
712     address public stepMarket;
713 
714     constructor()
715     ERC20("CoinClash", "CoC")
716     public {}
717 
718     function init(address _stepMarket) public onlyOwner {
719         stepMarket = _stepMarket;
720     }
721 
722     /**
723      * mint tokens to user
724      * @param  _to address token receiver
725      * @param _value uint256 amount of tokens for mint
726      */
727     function mint(address _to, uint256 _value) public {
728         require(msg.sender == stepMarket, "address not stepmarket");
729         _mint(_to, _value);
730     }
731 
732     /**
733      * burn tokens from user
734      * @param _from address address of user for burning
735      * @param _value uint256 amount of tokens for burn
736      */
737     function burnFrom(address _from, uint256 _value) public {
738         require(msg.sender == stepMarket, "address not stepmarket");
739         _burn(_from, _value);
740     }
741 }
742 
743 contract ETHStepMarket is Ownable {
744     using SafeMath for uint256;
745 
746     mapping(address => uint256) public percentages;
747     address[] public admins;
748     ETHSteps public stepAddress;
749     uint256 public adminPart;
750     uint256 public treasurePart;
751     uint256 public commissionPart;
752     uint256 public treasurePercentage = 90;
753     uint256 public adminPercentage = 10;
754 
755     /**
756      * event of success airdrop of coc tokens
757      */
758     event WithdrawAdminProcessed(
759         address caller,
760         uint256 amount,
761         uint256 timestamp
762     );
763     event AdminAddressAdded(
764         address newAddress,
765         uint256 percentage
766     );
767     event AdminAddressRemoved(
768         address oldAddress
769     );
770     event AdminPercentageChanged(
771         address admin,
772         uint256 newPercentage
773     );
774     event StepsAirdropped(
775         address indexed user,
776         uint256 amount
777     );
778     event AirdropDeposited(
779         address indexed user,
780         uint256 amount
781     );
782     event StepsBoughtViaEth(
783         address indexed user,
784         uint256 ethAmount
785     );
786     event TreasurePercentagesChanged(
787         uint256 treasurePercentage,
788         uint256 adminPercentage
789     );
790     event TreasureAdded(uint256 amount);
791     event WithdrawEmitted(address indexed user);
792     event EmitInternalDrop(address indexed user);
793 
794     function init(address _stepAddress) public onlyOwner {
795         stepAddress = ETHSteps(_stepAddress);
796     }
797 
798     /**
799      * send free steps to many users as airdrop
800      * @param _user address[] receivers address list
801      * @param _amount uint256[] amount of tokens for sending
802      */
803     function airdropToMany(
804         address[] memory _user,
805         uint256[] memory _amount
806     ) public onlyOwner {
807         require(_user.length == _amount.length, "Length must be equal");
808 
809         for (uint256 i = 0; i < _user.length; i++) {
810             stepAddress.mint(_user[i], _amount[i].mul(1 ether));
811 
812             emit StepsAirdropped(_user[i], _amount[i].mul(1 ether));
813         }
814     }
815 
816     function sendRewardToMany(
817         address[] memory _user,
818         uint256[] memory _amount,
819         uint256 totaRewardSent
820     ) public onlyOwner {
821         require(_user.length == _amount.length, "Length must be equal");
822         require(treasurePart >= totaRewardSent);
823 
824         treasurePart = treasurePart.sub(totaRewardSent);
825 
826         for (uint256 i = 0; i < _user.length; i++) {
827             address(uint160(_user[i])).transfer(_amount[i]);
828         }
829     }
830 
831     function receiveCommission() public onlyOwner {
832         require(commissionPart > 0);
833 
834         uint256 value = commissionPart;
835         commissionPart = 0;
836 
837         msg.sender.transfer(value);
838     }
839 
840     function getInternalAirdrop() public {
841         stepAddress.mint(msg.sender, 1 ether);
842         stepAddress.burnFrom(msg.sender, 1 ether);
843 
844         emit EmitInternalDrop(msg.sender);
845     }
846 
847     function buySteps() public payable {
848         require(msg.value != 0, "value can't be 0");
849 
850         stepAddress.mint(msg.sender, msg.value);
851         stepAddress.burnFrom(msg.sender, msg.value);
852 
853         adminPart = adminPart.add(msg.value.mul(adminPercentage).div(100));
854         treasurePart = treasurePart.add(msg.value.mul(treasurePercentage).div(100));
855 
856         emit StepsBoughtViaEth(
857             msg.sender,
858             msg.value
859         );
860     }
861 
862     function depositToGame() public {
863         require(stepAddress.balanceOf(msg.sender) != 0, "No tokens for deposit");
864 
865         emit AirdropDeposited(
866             msg.sender,
867             stepAddress.balanceOf(msg.sender)
868         );
869 
870         stepAddress.burnFrom(msg.sender, stepAddress.balanceOf(msg.sender));
871     }
872 
873     function changeTreasurePercentage(
874         uint256 _treasurePercentage,
875         uint256 _adminPercentage
876     ) public onlyOwner {
877         require(_treasurePercentage + _adminPercentage == 100, "Total percentage not 100");
878         treasurePercentage = _treasurePercentage;
879         adminPercentage = _adminPercentage;
880 
881         emit TreasurePercentagesChanged(
882             treasurePercentage,
883             adminPercentage
884         );
885     }
886 
887     function addAdmin(address _admin, uint256 _percentage) public onlyOwner {
888         require(percentages[_admin] == 0, "Admin exists");
889 
890         admins.push(_admin);
891         percentages[_admin] = _percentage;
892 
893         emit AdminAddressAdded(
894             _admin,
895             _percentage
896         );
897     }
898 
899     function addToTreasure() public payable {
900         treasurePart = treasurePart.add(msg.value);
901 
902         emit TreasureAdded(
903             msg.value
904         );
905     }
906 
907     function emitWithdrawal() public payable {
908         require(msg.value >= 4 finney);
909 
910         commissionPart = commissionPart.add(msg.value);
911 
912         emit WithdrawEmitted(
913             msg.sender
914         );
915     }
916 
917     function changePercentage(
918         address _admin,
919         uint256 _percentage
920     ) public onlyOwner {
921         percentages[_admin] = _percentage;
922 
923         emit AdminPercentageChanged(
924             _admin,
925             _percentage
926         );
927     }
928 
929     function deleteAdmin(address _removedAdmin) public onlyOwner {
930         uint256 found = 0;
931         for (uint256 i = 0; i < admins.length; i++) {
932             if (admins[i] == _removedAdmin) {
933                 found = i;
934             }
935         }
936 
937         for (uint256 i = found; i < admins.length - 1; i++) {
938             admins[i] = admins[i + 1];
939         }
940 
941         admins.pop();
942 
943         percentages[_removedAdmin] = 0;
944 
945         emit AdminAddressRemoved(_removedAdmin);
946     }
947 
948     function withdrawAdmins() public payable {
949         uint256 percent = 0;
950 
951         uint256 value = adminPart;
952         adminPart = 0;
953 
954         for (uint256 i = 0; i < admins.length; i++) {
955             percent = percent.add(percentages[admins[i]]);
956         }
957 
958         require(percent == 10000, "Total admin percent must be 10000 or 100,00%");
959 
960         for (uint256 i = 0; i < admins.length; i++) {
961             uint256 amount = value.mul(percentages[admins[i]]).div(10000);
962             address(uint160(admins[i])).transfer(amount);
963         }
964 
965         emit WithdrawAdminProcessed(
966             msg.sender,
967             adminPart,
968             block.timestamp
969         );
970     }
971 }